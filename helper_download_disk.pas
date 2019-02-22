{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 }

{
Description:
misc procedures related to disk data saving and resuming (during download)
}

unit helper_download_disk;

interface

uses
ares_types,ares_objects,classes,windows,sysutils,thread_download;

const
    CONST_DB_DOWNLOAD_META_KWGENRE=1;
    CONST_DB_DOWNLOAD_META_TITLE=2;
    CONST_DB_DOWNLOAD_META_ARTIST=3;
    CONST_DB_DOWNLOAD_META_ALBUM=4;
    CONST_DB_DOWNLOAD_META_CATEGORY=5;
    CONST_DB_DOWNLOAD_META_DATE=6;
    CONST_DB_DOWNLOAD_META_OLDALTSOURCES=7;
    CONST_DB_DOWNLOAD_META_LANGUAGE=8;
    CONST_DB_DOWNLOAD_META_URL=9;
    CONST_DB_DOWNLOAD_META_COMMENTS=10;
    CONST_DB_DOWNLOAD_META_ALTSOURCES=13;
    CONST_DB_DOWNLOAD_META_SHA1=15;
    CONST_DB_DOWNLOAD_META_SUBFLDR=19;
    CONST_DB_DOWNLOAD_META_PHASHPROG=20;
    CONST_DB_DOWNLOAD_META_DLBEGINDATE=25;

type
 tthread_downloadallocator = class(tthread)
 protected
  procedure execute; override;
 public
  download: TDownload;
 end;

procedure read_details_DB_Download(download: Tdownload);
procedure resume_db(download: Tdownload);
function download_fileassign(download: Tdownload): Boolean;
procedure update_hole_table(download: Tdownload); 
procedure write_details_DB_download(downloaD: Tdownload;paused:boolean);
procedure write_download(download: Tdownload; risorsa: Trisorsa_download;
 data: Pointer; len: Cardinal; punto: Int64 );
procedure rename_file(download: Tdownload);
procedure erase_download_file(download: Tdownload);
procedure erase_holedb(download: Tdownload);
procedure set_fileerror(download: Tdownload; ercode:integer);



implementation

uses
 helper_strings,helper_crypt,helper_unicode,tntwindows,
 helper_diskio,vars_global,helper_urls,helper_altsources,helper_ICH,
 const_ares,helper_datetime,ufrmmain,helper_player;


procedure tthread_downloadallocator.execute;
begin
freeonterminate := False;
priority := tpnormal;

download.stream.size := download.size+4096;
helper_download_disk.write_details_DB_download(download,false);
download.state := dlFinishedAllocating;
end;

procedure erase_holedb(download: Tdownload);
begin

try
 if download.stream<>nil then begin
  download.stream.size := download.size; //tronchiamo!

  FreeHandleStream(download.stream);
 end;
except
end;
download.stream := nil;

 
 
end;

procedure erase_download_file(download: Tdownload);
var
volte: Byte;
folderw: WideString;
i: Integer;
begin
try
 if download.stream<>nil then begin
  download.stream.size := 0;
  FreeHandleStream(download.stream);
 end;
except
end;
download.stream := nil;


 volte := 0;
 while (not helper_diskio.deletefileW(utf8strtowidestr(download.filename))) do begin
   inc(volte);
   if volte>20 then exit;
   sleep(100);
 end;

 ICH_eraseDLHash(download.hash_sha1);

 if length(download.in_subfolder)>1 then begin

   delete(download.in_subfolder,1,1);

   folderw := utf8strtowidestr(download.in_subfolder);
   for i := 1 to length(folderw) do begin
    if folderw[i]=chr(92){'\'} then begin
     folderw := copy(folderw,1,i-1);
     break;
    end;
   end;

  erase_emptydir(myshared_folder+chr(92){'\'}+folderw);
 end;


end;

procedure rename_file(download: Tdownload);
var
old_filename,aggiunta,
fname,path: WideString;
estensione: string;
iterations: Integer;
begin
try

try
 if download.stream<>nil then FreeHandleStream(download.stream);
except
end;
download.stream := nil;

old_filename := utf8strtowidestr(download.filename);


path := extract_fpathW(utf8strtowidestr(download.filename));
fname := extract_fnameW(utf8strtowidestr(download.filename));
 estensione := extractfileext(widestrtoutf8str(fname));

fname := copy(fname,1,length(fname)-length(estensione));
delete(fname,1,13);

download.filename := widestrtoutf8str(path+'\'+fname+estensione);

if fileexistsW(utf8strtowidestr(download.filename)) then helper_diskio.deletefileW(utf8strtowidestr(download.filename)); // nel caso ci fosse già il filename in extremis!!

if not Tnt_MoveFileW(pwidechar(old_filename), pwidechar(utf8strtowidestr(download.filename))) then begin
  aggiunta := inttostr(random(500));

   iterations := 0;
   while (not tntwindows.Tnt_MoveFileW(pwidechar(old_filename),pwidechar(utf8strtowidestr(download.filename)))) do begin
    aggiunta := inttostr(random(500));
    download.filename := widestrtoutf8str(path+'\'+fname+aggiunta+estensione);
    sleep(50);
    inc(iterations);
    if iterations>10 then break;
   end;
end;

old_filename := '';
fname := '';
path := '';
estensione := '';
except
end;
end;


procedure write_download(download: Tdownload; risorsa: Trisorsa_download; data: Pointer; len: Cardinal; punto: Int64 );
begin
try

{
with download.stream do begin
 while position<>punto do begin
   seek(punto,sofrombeginning);
   if position<>punto then sleep(10) else break;
 end;

 write(data^,len);
end; }

      risorsa.writecache.write(data,len);
      
      if risorsa.piece<>nil then inc(risorsa.piece.Fprogress,len);


 except
 end;
end;

procedure write_details_DB_download(downloaD: Tdownload; paused:boolean);
var
 buffer: array [0..4095] of char;
 str,str_sources: string;
 len_to,posit: Cardinal;
 num64: Int64;
 num16: Word;
 iterations: Integer;
begin

   str_sources := helper_altsources.get_serialized_altsources(download);

with download do begin
   len_to := 47+
           length(keyword_genre)+
           length(title)+
           length(artist)+
           length(album)+
           length(category)+
           length(date)+
           length(language)+
           length(url)+
           length(comments)+
           length(str_sources)+
           length(hash_sha1)+
           length(in_subfolder)+
           7;


      fillchar(buffer,sizeof(buffer),0);
      posit := 0;
      num64 := 0;

      str := '___ARESTRA__3';
      move(str[1],buffer[posit],13);
       inc(posit,13);
      move(size,buffer[posit],8);
       inc(posit,8);
      move(num64,buffer[posit],8); //progress
       inc(posit,8);
      move(num64,buffer[posit],8); //empty hole start
       inc(posit,8);
      move(num64,buffer[posit],8); //empty hole end
       inc(posit,8);
      buffer[posit] := chr(tipo);    //mime
       inc(posit);
      buffer[posit] := chr(integer(paused));  //paused?
       inc(posit);
      move(param1,buffer[posit],4); //param1
       inc(posit,4);
      move(param2,buffer[posit],4); //param2
       inc(posit,4);
      move(param3,buffer[posit],4); //param3
       inc(posit,4);
      num16 := len_to;
      move(num16,buffer[posit],2); //len str details
       inc(posit,2);

       ///////details
        buffer[posit] := chr(CONST_DB_DOWNLOAD_META_KWGENRE);       //keyword_genre
        num16 := length(keyword_genre);
        move(num16,buffer[posit+1],2);
        inc(posit,3);
        if num16>0 then begin
         move(keyword_genre[1],buffer[posit],num16);
         inc(posit,num16);
        end;
         buffer[posit] := chr(CONST_DB_DOWNLOAD_META_TITLE);        //title
         num16 := length(title);
         move(num16,buffer[posit+1],2);
         inc(posit,3);
         if num16>0 then begin
          move(title[1],buffer[posit],num16);
          inc(posit,num16);
         end;
          buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ARTIST);         //artist
          num16 := length(artist);
          move(num16,buffer[posit+1],2);
          inc(posit,3);
          if num16>0 then begin
           move(artist[1],buffer[posit],num16);
           inc(posit,num16);
          end;
           buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ALBUM);         //album
           num16 := length(album);
           move(num16,buffer[posit+1],2);
           inc(posit,3);
           if num16>0 then begin
            move(album[1],buffer[posit],num16);
            inc(posit,num16);
           end;
            buffer[posit] := chr(CONST_DB_DOWNLOAD_META_CATEGORY);         //category
            num16 := length(category);
            move(num16,buffer[posit+1],2);
            inc(posit,3);
            if num16>0 then begin
             move(category[1],buffer[posit],num16);
             inc(posit,num16);
            end;
             buffer[posit] := chr(CONST_DB_DOWNLOAD_META_DATE);         //date
             num16 := length(date);
             move(num16,buffer[posit+1],2);
             inc(posit,3);
             if num16>0 then begin
              move(date[1],buffer[posit],num16);
              inc(posit,num16);
             end;
              buffer[posit] := chr(CONST_DB_DOWNLOAD_META_LANGUAGE);         //language
              num16 := length(language);
              move(num16,buffer[posit+1],2);
              inc(posit,3);
              if num16>0 then begin
               move(language[1],buffer[posit],num16);
               inc(posit,num16);
              end;
               buffer[posit] := chr(CONST_DB_DOWNLOAD_META_URL);         //url
               num16 := length(url);
               move(num16,buffer[posit+1],2);
               inc(posit,3);
               if num16>0 then begin
                move(url[1],buffer[posit],num16);
                inc(posit,num16);
               end;
                buffer[posit] := chr(CONST_DB_DOWNLOAD_META_COMMENTS);         //comments
                num16 := length(comments);
                move(num16,buffer[posit+1],2);
                inc(posit,3);
                if num16>0 then begin
                 move(comments[1],buffer[posit],num16);
                 inc(posit,num16);
                end;
                 buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ALTSOURCES);         //str_sources
                 num16 := length(str_sources);
                 move(num16,buffer[posit+1],2);
                 inc(posit,3);
                 if num16>0 then begin
                  move(str_sources[1],buffer[posit],num16);
                  inc(posit,num16);
                 end;
                  buffer[posit] := chr(CONST_DB_DOWNLOAD_META_SHA1);         //hash_sha1
                  num16 := length(hash_sha1);
                  move(num16,buffer[posit+1],2);
                  inc(posit,3);
                  if num16>0 then begin
                   move(hash_sha1[1],buffer[posit],num16);
                   inc(posit,num16);
                  end;
                   buffer[posit] := chr(CONST_DB_DOWNLOAD_META_SUBFLDR);         //in_subfolder
                   num16 := length(in_subfolder);
                   move(num16,buffer[posit+1],2);
                   inc(posit,3);
                   if num16>0 then begin
                    move(in_subfolder[1],buffer[posit],num16);
                    inc(posit,num16);
                   end;
                    num64 := 0; //phash progress
                    buffer[posit] := chr(CONST_DB_DOWNLOAD_META_PHASHPROG);         //phash progress
                    num16 := 8;
                    move(num16,buffer[posit+1],2);
                    inc(posit,3);
                    if num16>0 then begin
                     move(num64,buffer[posit],num16);
                     inc(posit,num16);
                    end;
                    
                      buffer[posit] := chr(CONST_DB_DOWNLOAD_META_DLBEGINDATE);
                      num16 := 4;
                      move(num16,buffer[posit+1],2);
                      inc(posit,3);
                      move(download.StartDate,buffer[posit],num16);

          phash_verified_progr := 0;

          iterations := 0;
          helper_diskio.MyFileSeek(download.stream,download.size,ord(soFromBeginning));
          while (true) do begin
             if helper_diskio.MyFileSeek(download.stream,0,ord(soCurrent))<>download.size then begin
              sleep(50);
              helper_diskio.MyFileSeek(download.stream,download.size,ord(soFromBeginning));

              inc(iterations);
              if iterations>10 then exit;

              continue;
             end else break;
          end;


          move(str[1],buffer,length(str));
          stream.write(buffer,sizeof(buffer));

          //FlushFileBuffers(stream.handle);

          { while stream.position<>filesize+4096 do begin
            stream.seek(filesize+4096,sofrombeginning);
            if stream.position<>filesize+4096 then sleep(50) else break;
           end;  }
   end;
end;


procedure update_hole_table(download: Tdownload); //aggiorna missing table
var
str: string;
buffer: array [0..4095] of char;
str_sources: string;

 len_to,posit: Cardinal;
 num64: Int64;
 num16: Word;
 iterations: Integer;
begin
try

   str_sources := helper_altsources.get_serialized_altsources(download);

with download do begin

   len_to := 47+length(keyword_genre)+
           length(title)+
           length(artist)+
           length(album)+
           length(category)+
           length(date)+
           length(language)+
           length(url)+
           length(comments)+
           length(str_sources)+
           length(hash_sha1)+
           length(in_subfolder)+
           7;


      fillchar(buffer,sizeof(buffer),0);
      posit := 0;
      num64 := 0;

      str := '___ARESTRA__3';
      move(str[1],buffer[posit],13);
       inc(posit,13);
      move(size,buffer[posit],8);
       inc(posit,8);
      move(progress,buffer[posit],8);
       inc(posit,8);



      move(num64,buffer[posit],8); //empty hole start
       inc(posit,8);
      move(num64,buffer[posit],8); //empty hole end
       inc(posit,8);
      buffer[posit] := chr(tipo);    //tipo
       inc(posit);
      buffer[posit] := chr(integer((download.state=dlPaused)));  //paused?
       inc(posit);
      move(param1,buffer[posit],4); //param1
       inc(posit,4);
      move(param2,buffer[posit],4); //param2
       inc(posit,4);
      move(param3,buffer[posit],4); //param3
       inc(posit,4);
      num16 := len_to;
      move(num16,buffer[posit],2); //len str details
       inc(posit,2);


             ///////details
        buffer[posit] := chr(CONST_DB_DOWNLOAD_META_KWGENRE);       //keyword_genre
        num16 := length(keyword_genre);
        move(num16,buffer[posit+1],2);
        inc(posit,3);
        if num16>0 then begin
         move(keyword_genre[1],buffer[posit],num16);
         inc(posit,num16);
        end;
         buffer[posit] := chr(CONST_DB_DOWNLOAD_META_TITLE);        //title
         num16 := length(title);
         move(num16,buffer[posit+1],2);
         inc(posit,3);
         if num16>0 then begin
          move(title[1],buffer[posit],num16);
          inc(posit,num16);
         end;
          buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ARTIST);         //artist
          num16 := length(artist);
          move(num16,buffer[posit+1],2);
          inc(posit,3);
          if num16>0 then begin
           move(artist[1],buffer[posit],num16);
           inc(posit,num16);
          end;
           buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ALBUM);         //album
           num16 := length(album);
           move(num16,buffer[posit+1],2);
           inc(posit,3);
           if num16>0 then begin
            move(album[1],buffer[posit],num16);
            inc(posit,num16);
           end;
            buffer[posit] := chr(CONST_DB_DOWNLOAD_META_CATEGORY);         //category
            num16 := length(category);
            move(num16,buffer[posit+1],2);
            inc(posit,3);
            if num16>0 then begin
             move(category[1],buffer[posit],num16);
             inc(posit,num16);
            end;
             buffer[posit] := chr(CONST_DB_DOWNLOAD_META_DATE);         //date
             num16 := length(date);
             move(num16,buffer[posit+1],2);
             inc(posit,3);
             if num16>0 then begin
              move(date[1],buffer[posit],num16);
              inc(posit,num16);
             end;
              buffer[posit] := chr(CONST_DB_DOWNLOAD_META_LANGUAGE);         //language
              num16 := length(language);
              move(num16,buffer[posit+1],2);
              inc(posit,3);
              if num16>0 then begin
               move(language[1],buffer[posit],num16);
               inc(posit,num16);
              end;
               buffer[posit] := chr(CONST_DB_DOWNLOAD_META_URL);         //url
               num16 := length(url);
               move(num16,buffer[posit+1],2);
               inc(posit,3);
               if num16>0 then begin
                move(url[1],buffer[posit],num16);
                inc(posit,num16);
               end;
                buffer[posit] := chr(CONST_DB_DOWNLOAD_META_COMMENTS);         //comments
                num16 := length(comments);
                move(num16,buffer[posit+1],2);
                inc(posit,3);
                if num16>0 then begin
                 move(comments[1],buffer[posit],num16);
                 inc(posit,num16);
                end;
                 buffer[posit] := chr(CONST_DB_DOWNLOAD_META_ALTSOURCES);         //str_sources
                 num16 := length(str_sources);
                 move(num16,buffer[posit+1],2);
                 inc(posit,3);
                 if num16>0 then begin
                  move(str_sources[1],buffer[posit],num16);
                  inc(posit,num16);
                 end;
                  buffer[posit] := chr(CONST_DB_DOWNLOAD_META_SHA1);         //hash_sha1
                  num16 := length(hash_sha1);
                  move(num16,buffer[posit+1],2);
                  inc(posit,3);
                  if num16>0 then begin
                   move(hash_sha1[1],buffer[posit],num16);
                   inc(posit,num16);
                  end;
                   buffer[posit] := chr(CONST_DB_DOWNLOAD_META_SUBFLDR);         //in_subfolder
                   num16 := length(in_subfolder);
                   move(num16,buffer[posit+1],2);
                   inc(posit,3);
                   if num16>0 then begin
                    move(in_subfolder[1],buffer[posit],num16);
                    inc(posit,num16);
                   end;

                    buffer[posit] := chr(CONST_DB_DOWNLOAD_META_PHASHPROG);         //phash progress
                    num16 := 8;
                    move(num16,buffer[posit+1],2);
                    inc(posit,3);
                    move(phash_verified_progr,buffer[posit],num16);
                     inc(posit,num16);
                     
                      buffer[posit] := chr(CONST_DB_DOWNLOAD_META_DLBEGINDATE);    //dl start date
                      num16 := 4;
                      move(num16,buffer[posit+1],2);
                      inc(posit,3);
                      move(download.StartDate,buffer[posit],num16);


 iterations := 0;
 while (stream.position<>size) do begin
  stream.seek(size,sofrombeginning);
  if stream.position<>size then sleep(50) else break;

  inc(iterations);
  if iterations>10 then exit;

 end;



stream.write(buffer,sizeof(buffer));

//FlushFileBuffers(stream.handle); 


{ while (stream.position<>size+4096) do begin //aspettiamo che abbia finito flush completo
  stream.seek(size+4096,sofrombeginning);
  if stream.position<>size+4096 then sleep(50) else break;
 end;  }



end;


except
end;

end;

function download_fileassign(download: Tdownload): Boolean;
begin
result := False;
                    //  INVALID_HANDLE_VALUE
try       //   STANDARD_RIGHTS_WRITE   WRITE_OWNER
 // Result := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
  //  0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

 if not fileexistsW(utf8strtowidestr(download.filename)) then begin

       download.stream := MyFileOpen(utf8strtowidestr(download.filename),ARES_OVERWRITE_EXISTING);
       if download.stream=nil then begin
        download.state := dlFileError;
        download.ercode := GetLastError;
        exit;
      end;
       download.startDate := helper_datetime.delphidatetimetounix(now);

       if download.size>20*MEGABYTE then begin
         download.state := dlAllocating;
         download.allocator := tthread_downloadallocator.create(true);
         (download.allocator as tthread_downloadallocator).download := download;
         download.allocator.resume;
       end else begin
        download.stream.size := download.size+4096;
        write_details_DB_download(download,false);
       end;

       download.FPieceSize := helper_ich.ICH_calc_chunk_size(download.size);


 end else begin
      download.stream := MyFileOpen(utf8strtowidestr(download.filename),ARES_WRITE_EXISTING);
      if download.stream=nil then begin
       download.state := dlFileError;
       download.ercode := getlasterror;
       exit;
      end;
      read_details_DB_download(download);
      if download.stream=nil then exit;
      
      if download.stream.size<>download.size+4096 then download.stream.size := download.size+4096;
      download.FPieceSize := helper_ich.ICH_calc_chunk_size(download.size);

      if download.FPieceSize>0 then begin
       helper_ich.ICH_loadPieces(download);
       if length(download.FPieces)=0 then download.progress := download.phash_verified_progr;
      end;

 end;

 Result := True;
except
end;

end;




procedure resume_db(download: Tdownload);
   procedure fix_path;
   begin
     if not direxistsW(extract_fpathW(utf8strtowidestr(down_general.filename))) then
       down_general.filename := widestrtoutf8str(vars_global.myshared_folder+'\'+extract_fnameW(utf8strtowidestr(down_general.filename)));
   end;

begin
try
  down_general := download;
  fix_path;

download.progress := 0;

if not download_fileassign(download) then exit;

except
end;
end;

procedure set_fileerror(download: Tdownload; ercode:integer);
begin
  with download do begin
   FreeHandleStream(stream);
   stream := nil;
   ercode := 15875;
  end;
end;

procedure read_details_DB_Download(download: Tdownload);
var
buffer: array [0..4095] of char;
endp,position: Int64;
num32: Cardinal;
num16: Word;
str_detail,strcheck: string;
tagtype,letti,lun,i,iterations: Integer;
is_new_db: Boolean;
begin

try
 position := download.stream.size-sizeof(buffer);
 if position<0 then begin
  set_fileerror(download,15870);
  exit;
 end;

 iterations := 0;
 while download.stream.position<>position do begin
  download.stream.seek(position,sofrombeginning);
  sleep(50);

  inc(iterations);
  if iterations>10 then break;
 end;

 if download.stream.read(buffer,13)<>13 then begin
  set_fileerror(download,15870);
  exit;
 end;

 SetLength(strcheck,13);
 move(buffer,strcheck[1],13);


 if strcheck='___ARESTRA___' then is_new_db := false else
  if ((strcheck='___ARESTRA__2') or (strcheck='___ARESTRA__3')) then is_new_db := true
   else begin
     set_fileerror(download,15871);
     exit;
   end;

 if is_new_db then begin
   if download.stream.read(buffer,8)<>8 then begin
   set_fileerror(download,15873);
   exit;
  end;
  move(buffer,download.size,8);
 end else begin
  if download.stream.read(buffer,4)<>4 then begin
   set_fileerror(download,15873);
   exit;
  end;
  move(buffer,num32,4);
  download.size := num32;
 end;


 if is_new_db then begin
  if download.stream.read(buffer,8)<>8 then begin
   set_fileerror(download,15874);
   exit;
  end;
  move(buffer[0],download.progress,8);
 end else begin
  if download.stream.read(buffer,4)<>4 then begin
   set_fileerror(download,15874);
   exit;
  end;
  move(buffer,num32,4);
  download.progress := num32;
 end;


repeat

 if is_new_db then begin
  if download.stream.read(buffer,16)<>16 then begin
   set_fileerror(download,15875);
   exit;
  end;

  move(buffer[8],endp,8);
 end else begin
  if download.stream.read(buffer,8)<>8 then begin
   set_fileerror(download,15875);
   exit;
  end;

  move(buffer[0],num32,4);
  endp := num32;
 end;

 if endp=0 then break;  //can't be (END of PCHUNKS)

until (not true);


 if download.stream.read(buffer,16)<>16 then begin
  set_fileerror(download,15876);
  exit;
 end;

 if download.stream.position>=download.stream.size-1 then begin
  set_fileerror(download,15877);
  exit;
 end;

 download.tipo := ord(buffer[0]);
 if download.tipo<>ARES_MIME_VIDEO then download.aviHeaderState := aviStateNotAvi;
 if buffer[1]=chr(1) then download.state := dlPaused
  else download.state := dlProcessing;


with download do begin
 move(buffer[2],param1,4);
 move(buffer[6],param2,4);
 move(buffer[10],param3,4);
end;

 move(buffer[14],num16,2);
 lun := num16;

 if lun=0 then begin
  set_fileerror(download,15878);
  exit;
 end;
 if lun>3500 then begin
  set_fileerror(download,15879);
  exit;
 end;

letti := download.stream.read(buffer,lun);
if lun>letti then begin
  set_fileerror(download,15880);
  exit;
 end;


     SetLength(str_detail,lun);
     move(buffer,str_detail[1],lun);
     
    ares_frmmain.treeview_download.beginupdate;
    
     for i := 0 to 25 do begin
       if length(str_detail)<3 then break;
       tagtype := ord(str_detail[1]);
       lun := chars_2_word(copy(str_detail,2,2));
       delete(str_detail,1,3);
       with download do
        case tagtype of
         CONST_DB_DOWNLOAD_META_KWGENRE : keyword_genre := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_TITLE : title := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_ARTIST:artist := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_ALBUM:album := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_CATEGORY:category := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_DATE:date := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_OLDALTSOURCES:helper_altsources.add_sources(download,copy(str_detail,1,lun),false);
         CONST_DB_DOWNLOAD_META_LANGUAGE:language := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_URL:url := copy(str_detail,1,lun);
         CONST_DB_DOWNLOAD_META_COMMENTS:comments := copy(str_detail,1,lun);
         11:;
         12:;
         CONST_DB_DOWNLOAD_META_ALTSOURCES:helper_altsources.add_sources(download,copy(str_detail,1,lun),true);
         CONST_DB_DOWNLOAD_META_SHA1:begin
            hash_sha1 := copy(str_detail,1,lun);
            crcsha1 := crcstring(hash_sha1);
            end;
         CONST_DB_DOWNLOAD_META_SUBFLDR:in_subfolder := copy(str_detail,1,lun); //per eventuale clear folder on cancel
         CONST_DB_DOWNLOAD_META_PHASHPROG:phash_verified_progr := chars_2_qword(copy(str_detail,1,lun));
         CONST_DB_DOWNLOAD_META_DLBEGINDATE:StartDate := chars_2_dword(copy(str_detail,1,4))
          else begin

           break;
          end; //2956+
        end;
       delete(str_detail,1,lun);
     end;

   str_detail := '';
   ares_frmmain.treeview_download.endupdate;
////////////////////////////////////

  

except
  set_fileerror(download,15881);
  exit; //controlliamo size in db hole
end;

end;



end.
