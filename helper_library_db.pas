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
load/save filelists from/to disk
}

unit helper_library_db;

interface

uses
ares_types,classes2,classes,tntwindows,windows,sysutils;

function set_NEWtrusted_metas: Boolean;
procedure set_trusted_metas; // in synchro da scrivi su form1
procedure get_trusted_metas;
procedure get_cached_metas;
function already_in_DBTOWRITE(hash_sha1: string; crcsha1:word): Boolean;
function find_trusted_file(hash_sha1: string; crcsha1:word):precord_file_trusted;
procedure set_cached_metas;
function find_cached_file(hash_sha1: string; crcsha1:word):precord_file_library;
procedure DBFiles_free;
procedure DBTrustedFiles_free;
function DB_everseen(path: string; fsize: Int64):precord_file_library;
procedure DB_TOWRITE_free;
procedure assign_trusted_metas(pfile:precord_file_library);
procedure init_cached_dbs;

var
    DB_TRUSTED: array [0..255] of pointer;
    DB_CACHED: array [0..255] of pointer;
    DB_TOWRITE: array [0..255] of pointer;

implementation

uses
helper_diskio,vars_global,helper_strings,helper_crypt,
vars_localiz,helper_datetime,helper_visual_library,
helper_stringfinal,const_ares,helper_mimetypes,helper_ICH;


procedure init_cached_dbs;
var
i: Integer;
begin
   for i := 0 to 255 do DB_TOWRITE[i] := nil;
   for i := 0 to 255 do DB_CACHED[i] := nil;
   for i := 0 to 255 do DB_TRUSTED[i] := nil;
end;

procedure assign_trusted_metas(pfile:precord_file_library);
var
pfiletrust:precord_file_trusted;
begin
try
pfile^.corrupt := False;    //default settings
pfile^.shared := True;

pfiletrust := find_trusted_file(pfile^.hash_sha1,pfile^.crcsha1);
if pfiletrust=nil then exit;

         with pfile^ do begin
           if pfile^.amime=ARES_MIME_SOFTWARe then begin
            title := trim(copy(pfiletrust^.title,1,length(pfiletrust^.title)));
            artist := trim(copy(pfiletrust^.artist,1,length(Pfiletrust^.artist)));
            album := trim(copy(pfiletrust^.album,1,length(pfiletrust^.album)));
           end else begin
            title := copy(pfiletrust^.title,1,length(pfiletrust^.title));
            artist := copy(pfiletrust^.artist,1,length(pfiletrust^.artist));
            album := copy(pfiletrust^.album,1,length(pfiletrust^.album));
           end;
           category := copy(pfiletrust^.category,1,length(pfiletrust^.category));
           language := copy(pfiletrust^.language,1,length(pfiletrust^.language));
           comment := copy(pfiletrust^.comment,1,length(pfiletrust^.comment));
           url := copy(pfiletrust^.url,1,length(pfiletrust^.url));
           year := copy(pfiletrust^.year,1,length(pfiletrust^.year));
           filedate := pfiletrust^.filedate;
           corrupt := pfiletrust^.corrupt;
           shared := pfiletrust^.shared;
         end;

except
end;
end;

procedure DB_TOWRITE_free;
var
pfile,next_pfile:precord_file_library;
i: Integer;
begin
try
for i := 0 to 255 do begin

 if DB_TOWRITE[i]=nil then continue;

 pfile := DB_TOWRITE[i];
 while (pfile<>nil) do begin
  next_pfile := pfile^.next;
    reset_pfile_strings(pfile);
    FreeMem(pfile,sizeof(record_file_library));
    if next_pfile=nil then break;
  pfile := next_pfile;
 end;
  DB_TOWRITE[i] := nil;

end;

except
end;
end;

function DB_everseen(path: string; fsize: Int64):precord_file_library;
var
i: Integer;
pfile:precord_file_library;
lopath: string;
begin
result := nil;

lopath := lowercase(path);

try
for i := 0 to 255 do begin
 if DB_CACHED[i]=nil then continue;

  pfile := DB_CACHED[i];

  while (pfile<>nil) do begin
   if pfile^.fsize<>fsize then begin
    pfile := pfile^.next;
    continue;
   end;
   if lowercase(pfile^.path)<>lopath then begin
    pfile := pfile^.next;
    continue;
   end;
   if length(pfile^.hash_sha1)<>20 then begin
    pfile := pfile^.next;
    continue;
   end;
    Result := pfile;
    exit;
  end;

end;

except
end;
end;


procedure DBTrustedFiles_free;
var
pfiletrusted,thenext:precord_file_trusted;
i: Integer;
begin
try

for i := 0 to 255 do begin

 if DB_TRUSTED[i]=nil then continue;

 pfiletrusted := DB_TRUSTED[i];
 while (pfiletrusted<>nil) do begin
  thenext := pfiletrusted^.next;
    reset_pfile_trusted_strings(pfiletrusted);
    FreeMem(pfiletrusted,sizeof(record_file_trusted));
  if thenext=nil then break;
  pfiletrusted := thenext;
 end;

 DB_TRUSTED[i] := nil;


end;


except
end;
end;

procedure DBFiles_free;
var
i: Integer;
pfile,next_pfile:precord_file_library;
begin
try

for i := 0 to 255 do begin

  if DB_CACHED[i]=nil then continue;

  pfile := DB_CACHED[i];
  while (pfile<>nil) do begin
   next_pfile := pfile^.next;
     reset_pfile_strings(pfile);
     FreeMem(pfile,sizeof(record_file_library));
   if next_pfile=nil then break;
   pfile := next_pfile;
  end;
  DB_CACHED[i] := nil;

end;

except
end;
end;

function find_cached_file(hash_sha1: string; crcsha1:word):precord_file_library;
begin
result := nil;

if DB_CACHED[ord(hash_sha1[1])]=nil then exit;

result := DB_CACHED[ord(hash_sha1[1])];
while (result<>nil) do begin

  if result^.crcsha1=crcsha1 then
   if result^.hash_sha1=hash_sha1 then exit;

result := result^.next;
end;

end;

procedure set_cached_metas;
var
pfile:precord_file_library;
i: Integer;
str_detail,str: string;
stream: Thandlestream;
buffer: array [0..4095] of char;
begin

 tntwindows.Tnt_CreateDirectoryW(pwidechar(data_path+'\Data'),nil);


 stream := Myfileopen(data_path+'\Data\ShareL.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH);
 if stream=nil then exit;

stream.size := 0;
                                                                                                //2963 diventa 1.04
               str := '__ARESDB1.04L_';
               move(str[1],buffer,length(str));
                stream.write(buffer,length(str));
                //FlushFileBuffers(stream.handle);


str := '';
try
for i := 0 to 255 do begin
  if DB_TOWRITE[i]=nil then continue;

 pfile := DB_TOWRITE[i];
while (pfile<>nil) do begin
 if length(pfile^.hash_sha1)<>20 then begin   //only corrected files
  pfile := pfile^.next;
  continue;
 end;

                          str_detail := chr(1)+int_2_word_string(length(pfile^.path))+pfile^.path+
                                      chr(2)+int_2_word_string(length(pfile^.title))+pfile^.title+
                                      chr(3)+int_2_word_string(length(pfile^.artist))+pfile^.artist+
                                      chr(4)+int_2_word_string(length(pfile^.album))+pfile^.album+
                                      chr(5)+int_2_word_string(length(pfile^.category))+pfile^.category+
                                      chr(6)+int_2_word_string(length(pfile^.year))+pfile^.year+
                                      chr(7)+int_2_word_string(length(pfile^.vidinfo))+pfile^.vidinfo+
                                      chr(8)+int_2_word_string(length(pfile^.language))+pfile^.language+
                                      chr(9)+int_2_word_string(length(pfile^.url))+pfile^.url+
                                      chr(10)+int_2_word_string(length(pfile^.comment))+pfile^.comment+
                                      chr(18)+int_2_word_string(length(pfile^.hash_of_phash))+pfile^.hash_of_phash; //2963

                  if pfile^.corrupt then str_detail := str_detail+chr(17)+chr(20)+CHRNULL+pfile^.hash_sha1;

     str := str+
          e67(pfile^.hash_sha1+
              chr(pfile^.amime)+
              int_2_dword_string(0)+
              int_2_qword_string(pfile^.fsize)+
              int_2_dword_string(pfile^.param1)+
              int_2_dword_string(pfile^.param2)+
              int_2_dword_string(pfile^.param3)+
              int_2_word_string(length(str_detail)),13871)+
          e67(str_detail,13872);       //crypt

          if length(str)>2500 then begin
            move(str[1],buffer,length(str));
            stream.write(buffer,length(str));
            //FlushFileBuffers(stream.handle);
            str := '';
          end;
 pfile := pfile^.next;
 end;

end;

except
end;

  if length(str)>0 then begin
     move(str[1],buffer,length(str));
     stream.write(buffer,length(str));
     //FlushFileBuffers(stream.handle);
     str := '';
   end;

FreeHandleStream(stream);

end;

function find_trusted_file(hash_sha1: string; crcsha1:word):precord_file_trusted;
begin
result := nil;
if length(hash_sha1)<>20 then exit;

if DB_TRUSTED[ord(hash_sha1[1])]=nil then exit;

result := DB_TRUSTED[ord(hash_sha1[1])];

while (result<>nil) do begin
 if result^.crcsha1=crcsha1 then
  if result^.hash_sha1=hash_sha1 then exit; //FOUND!
 Result := result^.next;
end;

end;

function already_in_DBTOWRITE(hash_sha1: string; crcsha1:word): Boolean;
var
pfile:precord_file_library;
begin
result := False;

if DB_TOWRITE[ord(hash_sha1[1])]=nil then exit;

pfile := DB_TOWRITE[ord(hash_sha1[1])];
while (pfile<>nil) do begin
  if pfile^.crcsha1=crcsha1 then
   if pfile^.hash_sha1=hash_sha1 then begin
    Result := True;
    exit;
   end;

   pfile := pfile^.next;
end;

end;

procedure get_cached_metas;
var
stream: Thandlestream;
buffer,buffer2: array [0..2047] of Byte;
letti: Integer;
lun: Word;
pfile,last_pfile:precord_file_library;
fsize: Int64;
param1,param2,param3: Integer;
str_detail,str_temp: string;
mime,fkind: Byte;
i,hi: Integer;
b: Word;
crcsha1: Word;
hash_sha1: string;
begin
 for i := 0 to 255 do DB_CACHED[i] := nil;


stream := MyFileOpen(data_path+'\data\ShareL.dat',ARES_READONLY_BUT_SEQUENTIAL);
if stream=nil then exit;

letti := stream.read(buffer,14);
 if letti<14 then begin
  FreeHandleStream(Stream);
  sleep(5);
  exit;
 end;
 SetLength(hash_sha1,14);
 move(buffer,hash_sha1[1],14);

 if hash_sha1<>'__ARESDB1.04L_' then begin
      FreeHandleStream(Stream);
      exit;
 end;


try

while stream.position<stream.size do begin


  letti := stream.read(buffer,47);
  if letti<47 then break;

  if stream.position>=stream.size then break;


      move(buffer,buffer2,47);
       b := 13871;
       for hi := 0 to 46 do begin
        buffer2[hI] := buffer[hI] xor (b shr 8);
        b := (buffer[hI] + b) * 23219 + 36126;
       end;
      move(buffer2,buffer,47);


 SetLength(hash_sha1,20);
  move(buffer,hash_sha1[1],20);
  crcsha1 := crcstring(hash_sha1);

  mime := buffer[20];

  SetLength(str_temp,26);
  move(buffer[21],str_temp[1],26);

  fsize := chars_2_Qword(copy(str_temp,5,8));
  param1 := chars_2_dword(copy(str_temp,13,4));
  param2 := chars_2_dword(copy(str_temp,17,4));
  param3 := chars_2_dword(copy(str_temp,21,4));

  move(str_temp[25],lun,2);


 if lun=0 then continue; //empty ?
 if lun>2048 then break; //(???)


letti := stream.read(buffer,lun); //leggiamo strdetail
if lun>letti then break; //corrotto?

  if fsize>ICH_MIN_FILESIZE then
   if ICH_find_phash_index(hash_sha1,crcsha1)=nil then continue;  //must have partial hashes too

 pfile := find_cached_file(hash_sha1,crcsha1);
   if pfile=nil then begin
     pfile := AllocMem(sizeof(recorD_file_library));
     if DB_CACHED[ord(hash_sha1[1])]=nil then pfile^.next := nil
      else begin
       last_pfile := DB_CACHED[ord(hash_sha1[1])];
       pfile^.next := last_pfile;
      end;
      DB_CACHED[ord(hash_sha1[1])] := pfile;
   end;

     reset_pfile_strings(pfile);

     pfile^.hash_sha1 := hash_sha1; //20 bytes!
     pfile^.crcsha1 := crcsha1;
     pfile^.filedate := 0;
     pfile^.amime := mime;
     pfile^.fsize := fsize;
     pfile^.shared := True;
     pfile^.param1 := param1;
     pfile^.param2 := param2;
     pfile^.param3 := param3;
     pfile^.shared := True;
     pfile^.mediatype := mediatype_to_str(pfile^.amime);
     pfile^.corrupt := False;


       move(buffer,buffer2,lun);
        b := 13872;
        for hi := 0 to lun-1 do begin
         buffer2[hI] := buffer[hI] xor (b shr 8);
         b := (buffer[hI] + b) * 23219 + 36126;
        end;
       move(buffer2,buffer,lun);


     SetLength(str_detail,lun);
     move(buffer,str_detail[1],lun);

     for i := 0 to 14 do begin
       if length(str_detail)<3 then break;
       fkind := ord(str_detail[1]);
       move(str_detail[2],lun,2);
       delete(str_detail,1,3);
        case fkind of
         1:begin
            pfile^.path := copy(str_detail,1,lun);
           end;
         2:pfile^.title := copy(str_detail,1,lun);
         3:pfile^.artist := copy(str_detail,1,lun);
         4:pfile^.album := copy(str_detail,1,lun);
         5:pfile^.category := copy(str_detail,1,lun);
         6:pfile^.year := copy(str_detail,1,lun);
         7:pfile^.vidinfo := copy(str_detail,1,lun);
         8:pfile^.language := copy(str_detail,1,lun);
         9:pfile^.url := copy(str_detail,1,lun);
         10:pfile^.comment := copy(str_detail,1,lun);
         17:pfile^.corrupt := True;
         18:pfile^.hash_of_phash := copy(str_detail,1,lun);
        end;
       delete(str_detail,1,lun);
     end; //for params...
     pfile^.ext := lowercase(extractfileext(pfile^.path));

      //check overflows...........
      if length(pfile^.title)>MAX_LENGTH_TITLE then delete(pfile^.title,MAX_LENGTH_TITLE,length(pfile^.title));
      if length(pfile^.artist)>MAX_LENGTH_FIELDS then delete(pfile^.artist,MAX_LENGTH_FIELDS,length(pfile^.artist));
      if length(pfile^.album)>MAX_LENGTH_FIELDS then delete(pfile^.album,MAX_LENGTH_FIELDS,length(pfile^.album));
      if length(pfile^.category)>MAX_LENGTH_FIELDS then delete(pfile^.category,MAX_LENGTH_FIELDS,length(pfile^.category));
      if length(pfile^.language)>MAX_LENGTH_FIELDS then delete(pfile^.language,MAX_LENGTH_FIELDS,length(pfile^.language));
      if length(pfile^.year)>MAX_LENGTH_FIELDS then delete(pfile^.year,MAX_LENGTH_FIELDS,length(pfile^.year));
      if length(pfile^.comment)>MAX_LENGTH_COMMENT then delete(pfile^.comment,MAX_LENGTH_COMMENT,length(pfile^.comment));
      if length(pfile^.url)>MAX_LENGTH_URL then delete(pfile^.url,MAX_LENGTH_URL,length(pfile^.url));

      if pfile^.amime=ARES_MIME_SOFTWARE then begin //hack to eliminate exe trailing spaces bug
       pfile^.title := trim(pfile^.title);
       pfile^.artist := trim(pfile^.artist);
       pfile^.album := trim(pfile^.album);
      end;
      ////////////////////////////////////
end;

except
end;

FreeHandleStream(Stream);

sleep(5);

end;

procedure get_trusted_metas;
var
stream: Thandlestream;
buffer,buffer2: array [0..2047] of Byte;
letti: Integer;
lun,b: Word;
pfiletrusted,LastPfileTrusted:precord_file_trusted;
str_detail,str_temp: string;
tipo: Byte;
i,hi: Integer;
shared: Boolean;
 crcsha1: Word;
 hash_sha1,tempStr: string;
begin
DBTrustedFiles_Free;
//for i := 0 to 255 do DB_TRUSTED[i] := nil;


stream := MyFileOpen(data_path+'\data\ShareH.dat',ARES_READONLY_BUT_SEQUENTIAL);
if stream=nil then exit;

  ////////////////////////////////   is it encrypted???
 letti := stream.read(buffer,14);
 if letti<14 then begin
  FreeHandleStream(Stream);
  sleep(5);
  exit;
 end;
 SetLength(hash_sha1,14);
 move(buffer,hash_sha1[1],14);

 if hash_sha1<>'__ARESDB1.02H_' then begin
  FreeHandleStream(Stream);
  exit;
 end;
  //////////////////////////////////////////////////////

try

while stream.position<stream.size do begin

 str_temp := '';

 letti := stream.read(buffer,23);
 if letti<23 then break;
 if stream.position>=stream.size-1 then break; //non c'è più nulla qui!

 //////////////////decrypt
      move(buffer,buffer2,23); //copiamo in buffer2
       b := 13871;   //header 1 content 2
       for hi := 0 to 22 do begin
        buffer2[hI] := buffer[hI] xor (b shr 8);
        b := (buffer[hI] + b) * 23219 + 36126;
       end;
      move(buffer2,buffer,23); //rimettiamo in buffer


 SetLength(hash_sha1,20);  //attenzione ora ho sha1 prima avevo md5+dword num scaricati (2941+)
 move(buffer,hash_sha1[1],20);   //copy hash
 crcsha1 := crcstring(hash_sha1);
  SetLength(str_temp,7);
  move(buffer[20],str_temp[1],3);

 shared := (ord(str_temp[1])=1);
 move(str_temp[2],lun,2);
  if lun=0 then continue; //boh non c'è title o altro...
  if lun>1024 then break;

 letti := stream.read(buffer,lun);  //read str detail

 if lun>letti then break;   //file finito non ho letto abbastanza?

 pfiletrusted := find_trusted_file(hash_sha1,crcsha1);
 if pfiletrusted=nil then begin
      pfiletrusted := AllocMem(sizeof(record_file_trusted));
      if DB_TRUSTED[ord(hash_sha1[1])]=nil then pfiletrusted^.next := nil
       else begin
        Lastpfiletrusted := DB_TRUSTED[ord(hash_sha1[1])];
        pfiletrusted^.next := Lastpfiletrusted;
      end;
      DB_TRUSTED[ord(hash_sha1[1])] := pfiletrusted;
 end;

      reset_pfile_trusted_strings(pfiletrusted);

      pfiletrusted^.hash_sha1 := hash_sha1;
      pfiletrusted^.filedate := 0; //se non ha data non lo facciamo comparire nei recent...
      pfiletrusted^.crcsha1 := crcsha1;
      pfiletrusted^.shared := shared;
      pfiletrusted^.corrupt := False;  //di default non è corrotto

      /////////decrypt
       move(buffer,buffer2,lun); //copiamo in buffer2
        b := 13872; //2 mentre header ha 1
        for hi := 0 to lun-1 do begin
         buffer2[hI] := buffer[hI] xor (b shr 8);
         b := (buffer[hI] + b) * 23219 + 36126;
        end;
       move(buffer2,buffer,lun); //rimettiamo in buffer

      SetLength(str_detail,lun);
      move(buffer,str_detail[1],lun);

         for i := 0 to 11 do begin
          if length(str_detail)<3 then break;
          tipo := ord(str_detail[1]);
          move(str_detail[2],lun,2);
           delete(str_detail,1,3);
           tempStr := copy(str_detail,1,lun);
           case tipo of
            2:pfiletrusted^.title := tempStr;
            3:pfiletrusted^.artist := tempStr;
            4:pfiletrusted^.album := tempStr;
            5:pfiletrusted^.category := tempStr;
            6:pfiletrusted^.year := tempStr;
            8:pfiletrusted^.language := tempStr;
            9:pfiletrusted^.url := tempStr;
            10:pfiletrusted^.comment := tempStr;
            11:pfiletrusted^.filedate := UnixToDelphiDateTime(chars_2_dword(tempStr));
            17:begin
               pfiletrusted^.corrupt := True;
               end;
           end;
           tempStr := '';
           delete(str_detail,1,lun);
         end; //fine for
//check overflows...........
      if length(pfiletrusted^.title)>MAX_LENGTH_TITLE then delete(pfiletrusted^.title,MAX_LENGTH_TITLE,length(pfiletrusted^.title));
      if length(pfiletrusted^.artist)>MAX_LENGTH_FIELDS then delete(pfiletrusted^.artist,MAX_LENGTH_FIELDS,length(pfiletrusted^.artist));
      if length(pfiletrusted^.album)>MAX_LENGTH_FIELDS then delete(pfiletrusted^.album,MAX_LENGTH_FIELDS,length(pfiletrusted^.album));
      if length(pfiletrusted^.category)>MAX_LENGTH_FIELDS then delete(pfiletrusted^.category,MAX_LENGTH_FIELDS,length(pfiletrusted^.category));
      if length(pfiletrusted^.language)>MAX_LENGTH_FIELDS then delete(pfiletrusted^.language,MAX_LENGTH_FIELDS,length(pfiletrusted^.language));
      if length(pfiletrusted^.year)>MAX_LENGTH_FIELDS then delete(pfiletrusted^.year,MAX_LENGTH_FIELDS,length(pfiletrusted^.year));
      if length(pfiletrusted^.comment)>MAX_LENGTH_COMMENT then delete(pfiletrusted^.comment,MAX_LENGTH_COMMENT,length(pfiletrusted^.comment));
      if length(pfiletrusted^.url)>MAX_LENGTH_URL then delete(pfiletrusted^.url,MAX_LENGTH_URL,length(pfiletrusted^.url));
////////////////////////////////////
end;  //while

except
end;

FreeHandleStream(Stream);

str_detail := '';
str_temp := '';
hash_sha1 := '';
sleep(5);

end;


procedure set_trusted_metas; // in synchro da scrivi su form1
var
i: Integer;
pfiletrusted:precord_file_trusted;
str_detail,str: string;
stream: Thandlestream;
buffer: array [0..4095] of char;
begin


 tntwindows.Tnt_CreateDirectoryW(pwidechar(data_path+'\Data'),nil);


stream := Myfileopen(data_path+'\Data\ShareH.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH);
if stream=nil then exit;

stream.size := 0; //tronchiamo file (cancellazione) dobbiamo riscrivere da zero

            str := '__ARESDB1.02H_'; //centrambi riptati!
               move(str[1],buffer,length(str));
                stream.write(buffer,length(str));
                FlushFileBuffers(stream.handle); //boh


str := '';
try
for i := 0 to 255 do begin
 if DB_TRUSTED[i]=nil then continue;

 pfiletrusted := DB_TRUSTED[i];
 while (pfiletrusted<>nil) do begin

 if length(pfiletrusted^.hash_sha1)<>20 then begin
  pfiletrusted := pfiletrusted^.next;
  continue; //evitiamo corruzione
 end;

 if lowercase(pfiletrusted^.artist)=GetLangStringA(STR_UNKNOW_LOWER) then pfiletrusted^.artist := '';
 if lowercase(pfiletrusted^.category)=GetLangStringA(STR_UNKNOW_LOWER) then pfiletrusted^.category := '';
 if lowercase(pfiletrusted^.album)=GetLangStringA(STR_UNKNOW_LOWER) then pfiletrusted^.album := '';

                           str_detail := chr(2)+int_2_word_string(length(pfiletrusted^.title))+pfiletrusted^.title+
                                       chr(3)+int_2_word_string(length(pfiletrusted^.artist))+pfiletrusted^.artist+
                                       chr(4)+int_2_word_string(length(pfiletrusted^.album))+pfiletrusted^.album+
                                       chr(5)+int_2_word_string(length(pfiletrusted^.category))+pfiletrusted^.category+
                                       chr(6)+int_2_word_string(length(pfiletrusted^.year))+pfiletrusted^.year+
                                       chr(8)+int_2_word_string(length(pfiletrusted^.language))+pfiletrusted^.language+
                                       chr(9)+int_2_word_string(length(pfiletrusted^.url))+pfiletrusted^.url+
                                       chr(10)+int_2_word_string(length(pfiletrusted^.comment))+pfiletrusted^.comment;

                 if trunc(pfiletrusted^.filedate)<>0 then str_detail := str_detail+chr(11)+chr(4)+CHRNULL+int_2_dword_string(DelphiDateTimeToUnix(pfiletrusted^.filedate));

                 if pfiletrusted^.corrupt then str_detail := str_detail+chr(17)+chr(20)+CHRNULL+pfiletrusted^.hash_sha1;

                            str := str+
                                 e67(pfiletrusted^.hash_sha1+//pfile^.requested_total)+
                                     chr(integer(pfiletrusted^.shared))+
                                     int_2_word_string(length(str_detail)),13871)+

                                 e67(str_detail,13872); //criptiamo

                                 if length(str)>2500 then begin
                                  move(str[1],buffer,length(str));
                                  stream.write(buffer,length(str));
                                  //FlushFileBuffers(stream.handle);
                                  str := '';
                                 end;

  pfiletrusted := pfiletrusted^.next;
  end; //while
end;  //for per DB_TRUSTED count


                                 if length(str)>0 then begin
                                  move(str[1],buffer,length(str));
                                  stream.write(buffer,length(str));
                                  //FlushFileBuffers(stream.handle);
                                 end;

except
end;

FreeHandleStream(Stream);

end;


function set_newtrusted_metas: Boolean; //chiamato in chiusura e riapertura thread_share
var                                                    //aggiunge in coda file su trusted
i: Integer;
pfile:precord_file_library;
stream,stream2: Thandlestream;
str_detail,str: string;
str_detail2,str2: string;
buffer: array [0..1023] of char;
buffer2: array [0..2047] of char;
begin

result := False;

 tntwindows.Tnt_CreateDirectoryW(pwidechar(data_path+'\data'),nil);

if not helper_diskio.FileExistsW(data_path+'\data\ShareH.dat') then stream := Myfileopen(data_path+'\data\ShareH.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH)
 else stream := Myfileopen(data_path+'\data\ShareH.dat',ARES_WRITEEXISTING_WRITETHROUGH); //open to append  existing

  if stream<>nil then begin
     stream.seek(0,sofromend);
         if stream.position=0 then begin //primo file, mettiamo header cript nuovo
             str := '__ARESDB1.02H_';
             move(str[1],buffer,length(str));
             stream.write(buffer,length(str));
             FlushFileBuffers(stream.handle); //boh
         end;
  end;


if not helper_diskio.FileExistsW(data_path+'\data\ShareL.dat') then stream2 := Myfileopen(data_path+'\data\ShareL.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH)
 else stream2 := Myfileopen(data_path+'\data\ShareL.dat',ARES_WRITEEXISTING_WRITETHROUGH); //open to append  existing

 if stream2<>nil then begin //handle al file di settings
   stream2.seek(0,sofromend);
         if stream2.position=0 then begin //secondo file, mettiamo header cript nuovo                        //2963 diventa chr 52 (1.04L)
             str := '__ARESDB1.04L_';
             move(str[1],buffer,length(str));
             stream2.write(buffer,length(str));
             FlushFileBuffers(stream2.handle); //boh
         end;
 end;

  if stream2=nil then
   if stream=nil then exit;

 try
for i := 0 to lista_shared.count-1 do begin
 pfile := lista_shared[i];

 if not pfile^.write_to_disk then continue;

 if length(pfile^.hash_sha1)<>20 then continue; //woah

 Result := True;

 pfile^.write_to_disk := False; 


  if lowercase(pfile^.artist)=GetLangStringA(STR_UNKNOW_LOWER) then pfile^.artist := '';
  if lowercase(pfile^.category)=GetLangStringA(STR_UNKNOW_LOWER) then pfile^.category := '';
  if lowercase(pfile^.album)=GetLangStringA(STR_UNKNOW_LOWER) then pfile^.album := '';

                           str_detail := chr(2)+int_2_word_string(length(pfile^.title))+pfile^.title+
                                       chr(3)+int_2_word_string(length(pfile^.artist))+pfile^.artist+
                                       chr(4)+int_2_word_string(length(pfile^.album))+pfile^.album+
                                       chr(5)+int_2_word_string(length(pfile^.category))+pfile^.category+
                                       chr(6)+int_2_word_string(length(pfile^.year))+pfile^.year+
                                       chr(8)+int_2_word_string(length(pfile^.language))+pfile^.language+
                                       chr(9)+int_2_word_string(length(pfile^.url))+pfile^.url+
                                       chr(10)+int_2_word_string(length(pfile^.comment))+pfile^.comment;

                         if trunc(pfile^.filedate)<>0 then str_detail := str_detail+chr(11)+chr(4)+CHRNULL+int_2_dword_string(DelphiDateTimeToUnix(pfile^.filedate));

                         if pfile^.corrupt then str_detail := str_detail+chr(17)+chr(20)+CHRNULL+pfile^.hash_sha1;

                         str_detail2 := chr(1)+int_2_word_string(length(pfile^.path))+pfile^.path+
                                      chr(2)+int_2_word_string(length(pfile^.title))+pfile^.title+
                                      chr(3)+int_2_word_string(length(pfile^.artist))+pfile^.artist+
                                      chr(4)+int_2_word_string(length(pfile^.album))+pfile^.album+
                                      chr(5)+int_2_word_string(length(pfile^.category))+pfile^.category+
                                      chr(6)+int_2_word_string(length(pfile^.year))+pfile^.year+
                                      chr(7)+int_2_word_string(length(pfile^.vidinfo))+pfile^.vidinfo+
                                      chr(8)+int_2_word_string(length(pfile^.language))+pfile^.language+
                                      chr(9)+int_2_word_string(length(pfile^.url))+pfile^.url+
                                      chr(10)+int_2_word_string(length(pfile^.comment))+pfile^.comment+
                                      chr(18)+int_2_word_string(length(pfile^.hash_of_phash))+pfile^.hash_of_phash;



                 if pfile^.corrupt then str_detail2 := str_detail2+chr(17)+chr(20)+CHRNULL+pfile^.hash_sha1;


                                       str := e67(pfile^.hash_sha1+
                                                chr(integer(pfile^.shared))+
                                                int_2_word_string(length(str_detail)),13871)+
                                            e67(str_detail,13872);

                            if stream<>nil then begin
                              move(str[1],buffer,length(str));
                              stream.write(buffer,length(str));
                              FlushFileBuffers(stream.handle); //boh
                            end;


                              str2 := e67(pfile^.hash_sha1+
                                        chr(pfile^.amime)+
                                        int_2_dword_string(0)+
                                        int_2_Qword_string(pfile^.fsize)+
                                        int_2_dword_string(pfile^.param1)+
                                        int_2_dword_string(pfile^.param2)+
                                        int_2_dword_string(pfile^.param3)+
                                        int_2_word_string(length(str_detail2)),13871)+
                                    e67(str_detail2,13872);


                            if stream2<>nil then begin
                              move(str2[1],buffer2,length(str2));
                              stream2.write(buffer2,length(str2));
                              FlushFileBuffers(stream2.handle);
                            end;

end;


except
end;

if stream<>nil then FreeHandleStream(Stream);
if stream2<>nil then FreeHandleStream(Stream2);


end;


end.
