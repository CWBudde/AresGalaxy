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

unit helper_ICH;

interface

uses
 helper_diskIO,classes,ares_types,windows,blcksock,sysutils,
 tntwindows,ares_objects,synsock;


const
ICH_MIN_FILESIZE=262144; //256KB

procedure ICH_init_phash_indexs;
procedure ICH_free_phash_indexs;
procedure ICH_load_phash_indexs;
procedure ICH_loadPieces(download: Tdownload);
procedure ICH_SaveDownloadBitField(download: TDownload);
procedure ICH_WriteDlDBHeader(download: TDownload; stream: THandleStream);

function ICH_DbSanityCheck(stream: THandleStream; download: TDownload): Boolean;

function ICH_find_phash_index(hash_sha1: string; crcsha1:word):precord_phash_index; //SHARE
function ICH_calc_chunk_size(fsize: Int64): Cardinal;
function ICH_copy_temp_to_tmp_db(sha1: string): Cardinal; //SHARE   copy from phashtemp to dbtemp
function ICH_get_hash_of_phash(sha1: string): string;

procedure ICH_copyEntry_to_tmp_db(phash_indx:precord_phash_index); //SHARE

 function ICH_check_DLPhash(download: TDownload): Boolean;
 function ICH_send_Phash(strt_time: Cardinal; hash_sha1: string; sockt: Ttcpblocksocket; insertion_point: Cardinal; enc_key: Word; file_size_reale: Int64): Tupload; overload;  //get phash, copy to temp file and assign upload to it (at the end of transfer remove temp file)
 procedure ICH_send_Phash(UDP_Socket:Hsocket; hash_sha1: string; UDP_buffer:pchar; LenBuffer: Integer; UDP_RemoteSin: TVarSin; insertion_point: Cardinal;  file_size_reale: Int64); overload;
 function ICH_ExtractDataForUpload(hash_sha1: string; insertion_point: Cardinal; fname: WideString): ThandleStream;

 function ICH_start_rcv_indexs(download: Tdownload; risorsa: Trisorsa_download; recvd: string; var completed:boolean): Boolean; overload;
 function ICH_start_rcv_indexs(download: Tdownload): Boolean; overload;

 function ICH_verify_chunk(download: Tdownload; risorsa: Trisorsa_download): Boolean;

 procedure ICH_eraseDLHash(hash_sha1: string);
 function ICH_copyDLHash_todb(download: Tdownload): Cardinal;
 function ICH_get_hash_of_phash_fromDLHASH(hash_sha1: string): string;
 function ICH_corrupt_dl_index(download: Tdownload; risorsa: Trisorsa_download; var completed:boolean): Boolean; //true if corrupt

// copy phash from file db to temp  (quando ho già phash su disco)
// in calculate_hash si scrive su temp phash
// alla fine thread share chiama rename temp to DBPHASH
// ogni file library ha il punto su disco del DBPHASH del suo corrispettivo phash
// calculate amount of pieces from size of file
// calculate size of pieces from size of file

var
DB_INDEXS_PHASH: array [0..255] of pointer;

implementation

uses
 const_ares,vars_global,helper_strings,helper_http,helper_base64_32,const_udpTransfer,
 helper_crypt,winsock,helper_unicode,const_timeouts,securehash,helper_ipfunc,
 helper_preview;


procedure ICH_copyEntry_to_tmp_db(phash_indx:precord_phash_index);
var
stream_from,stream_to: Thandlestream;
num32: Cardinal;
num64: Int64;
len_item: Cardinal;
len_red,num_to_write,num_to_read: Integer;
buffer_header: array [0..35] of char;
buffer: array [0..1023] of char;
hash_sha1,str: string;
begin

      stream_from := MyFileOpen(data_path+'\Data\PHashIdx.dat',ARES_READONLY_BUT_SEQUENTIAL);
      if stream_from=nil then exit;


      if not fileexistsW(data_path+'\Data\PHashIdxTemp.dat') then stream_to := MyFileOpen(data_path+'\Data\PHashIdxTemp.dat',ARES_OVERWRITE_EXISTING)
       else stream_to := MyFileOpen(data_path+'\Data\PHashIdxTemp.dat',ARES_WRITE_EXISTING);

      if stream_to=nil then begin
       FreeHandleStream(stream_from);
       exit;
      end;

      if stream_to.size>0 then stream_to.seek(stream_to.size,sofrombeginning);

      if stream_to.size=0 then begin  //write header if needed
        str := '__ARESDBP102__';
        move(str[1],buffer_header,14);
        stream_to.write(buffer_header,14);
      end;



      stream_from.seek(phash_indx^.db_point_on_disk,sofrombeginning);
      if stream_from.position<>phash_indx^.db_point_on_disk then begin
        FreeHandleStream(stream_from);
        FreeHandleStream(stream_to);
        exit;
      end;

      len_red := stream_from.read(buffer_header,sizeof(buffer_header));
      if len_red<>sizeof(buffer_header) then begin
        FreeHandleStream(stream_from);
        FreeHandleStream(stream_to);
        exit;
      end;

      move(buffer_header,num64,8);
      if num64<>1 then begin
         FreeHandleStream(stream_from);
         FreeHandleStream(stream_to);
        exit;
      end;
      move(buffer_header[32],num32,4);
      if num32<>1 then begin
         FreeHandleStream(stream_from);
         FreeHandleStream(stream_to);
        exit;
      end;
      move(buffer_header[8],len_item,4);
      SetLength(hash_sha1,20);
      move(buffer_header[12],hash_sha1[1],20);
      if hash_sha1<>phash_indx^.hash_sha1 then begin
         FreeHandleStream(stream_from);
         FreeHandleStream(stream_to);
        exit;
      end;

      //// update index
       phash_indx^.db_point_on_disk := stream_to.position;
       stream_to.write(buffer_header,sizeof(buffer_header)); //write header here to
     ////////////////////////////
     
      num_to_write := len_item;
      while (num_to_write>0) do begin

        num_to_read := num_to_write;
        if num_to_read>sizeof(buffer) then num_to_read := sizeof(buffer);

         len_red := stream_from.read(buffer,num_to_read);
         if len_red>0 then begin
          stream_to.write(buffer,len_red);
          dec(num_to_write,len_red);
         end else break;
         
      end;

         FreeHandleStream(stream_from);
         FreeHandleStream(stream_to);
end;

function ICH_get_hash_of_phash(sha1: string): string;
var
stream: Thandlestream;
buffer: array [0..1023] of char;
len_red: Integer;
cSHA1: TSHA1;
begin

      stream := MyFileOpen(data_path+'\Data\TempPHash.dat',ARES_READONLY_BUT_SEQUENTIAL);
      if stream=nil then exit;

      cSHA1 := TSHA1.Create;

      while (true) do begin
         len_red := stream.read(buffer,sizeof(buffer));
            if len_red>0 then cSHA1.Transform(Buffer, Len_red);
         if len_red<sizeof(buffer) then break;
      end;

  cSHA1.Complete;
   Result := cSHA1.HashValue;
  cSHA1.Free;

      FreeHandleStream(stream);

end;

function ICH_copy_temp_to_tmp_db(sha1: string): Cardinal; //copy from phashtemp to dbtemp
var
stream_from,stream_to: Thandlestream;
len_red: Integer;
str: string;
fsize: Cardinal;
num64: Int64;
num32: Cardinal;
buffer: array [0..1023] of char;
buffer_header: array [0..99] of char;
begin
result := 0;

      stream_from := MyFileOpen(data_path+'\Data\TempPHash.dat',ARES_READONLY_BUT_SEQUENTIAL);
      if stream_from=nil then exit;

      fsize := stream_from.size;
      num64 := 1;
      num32 := 1;
      move(num64,buffer,8); //8 zero
      move(fsize,buffer[8],4);
      move(sha1[1],buffer[12],20);
      move(num32,buffer[32],4); //4 zero

      if not fileexistsW(data_path+'\Data\PHashIdxTemp.dat') then stream_to := MyFileOpen(data_path+'\Data\PHashIdxTemp.dat',ARES_OVERWRITE_EXISTING)
       else stream_to := MyFileOpen(data_path+'\Data\PHashIdxTemp.dat',ARES_WRITE_EXISTING);

      if stream_to=nil then begin
       FreeHandleStream(stream_from);
       exit;
      end;



      if stream_to.size=0 then begin
        str := '__ARESDBP102__';
        move(str[1],buffer_header,14);
        stream_to.write(buffer_header,14);
      end;

 Result := stream_to.Size; //<-- point of insertion

      stream_to.Seek(stream_to.size,sofrombeginning);   //append to the end
      stream_to.write(buffer,36);                       //write header

      while (true) do begin
         len_red := stream_from.read(buffer,sizeof(buffer));
           stream_to.write(buffer,len_red);
         if len_red<sizeof(buffer) then break;
      end;

      FreeHandleStream(Stream_from);
      FreeHandleStream(Stream_to);

end;




function ICH_check_DLPhash(download: TDownload): Boolean;
var
stream: Thandlestream;
buffer_header: array [0..49] of char;
len_red: Integer;
str: string;
num64: Int64;
num32,len_item: Cardinal;
pchunk_len: Int64;
begin
result := False;

if length(download.FPieces)>0 then exit;



pchunk_len := ((download.size div int64(download.FPieceSize))+1)*20;


 stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat',ARES_READONLY_BUT_SEQUENTIAL); //only read and sequential scan
 if stream=nil then exit;

   len_red := stream.read(buffer_header,sizeof(buffer_header));
   if len_red<>sizeof(buffer_header) then begin
    FreeHandleStream(stream);
    exit;
   end;

   SetLength(str,14);
   move(buffer_header,str[1],14);
   if str<>'__ARESDBP102__' then begin
     FreeHandleStream(stream);
     exit;
   end;
   move(buffer_header[14],num64,8);
   if num64<>1 then begin
     FreeHandleStream(stream);
     exit;
   end;
   move(buffer_header[46],num32,4);
   if num32<>1 then begin
     FreeHandleStream(stream);
     exit;
   end;
   move(buffer_header[22],len_item,4);
   if int64(len_item)<>pchunk_len then begin
     FreeHandleStream(stream);
     exit;
   end;
   if stream.position+int64(len_item)>stream.size then begin
     FreeHandleStream(stream);
     exit;
   end;

   if not comparemem(@buffer_header[26],@download.hash_sha1[1],20) then begin
     FreeHandleStream(Stream);
     exit;
   end;

     FreeHandleStream(Stream);

     Result := True;

     ICH_loadPieces(download);

end;

function ICH_calc_chunk_size(fsize: Int64): Cardinal;
begin
 if fsize<=ICH_MIN_FILESIZE then Result := 0 else
 if fsize<10*MEGABYTE then Result := 256*KBYTE else  //adattamento dinamico size...chunk
 if fsize<50*MEGABYTE then Result := 512*KBYTE else
 if fsize<100*MEGABYTE then Result := MEGABYTE else
 if fsize<GIGABYTE then Result := 2*MEGABYTE else
  Result := 4*MEGABYTE;

end;

function ICH_find_phash_index(hash_sha1: string; crcsha1:word):precord_phash_index;
begin
result := nil;

if DB_INDEXS_PHASH[ord(hash_sha1[1])]=nil then begin
 exit;
end;

result := DB_INDEXS_PHASH[ord(hash_sha1[1])];

while (result<>nil) do begin
  if result^.crcsha1=crcsha1 then
   if result^.hash_sha1=hash_sha1 then exit;
result := result^.next;
end;

end;

function ICH_start_rcv_indexs(download: Tdownload): Boolean;
begin
 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Data\TempDL'),nil);
 download.phash_stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat',ARES_OVERWRITE_EXISTING);
 Result := (download.phash_stream<>nil);
end;

function ICH_start_rcv_indexs(download: Tdownload; risorsa: Trisorsa_download; recvd: string; var completed:boolean): Boolean;
begin
result := False;
completed := False;



       tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Data\TempDL'),nil);

       download.phash_stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat',ARES_OVERWRITE_EXISTING);
       if download.phash_stream=nil then exit;

       if length(recvd)>0 then download.phash_stream.write(recvd[1],length(recvd));

        risorsa.socket.tag := gettickcount;

        if ICH_corrupt_dl_index(download,risorsa,completed) then exit;

        Result := True;
end;

function ICH_get_hash_of_phash_fromDLHASH(hash_sha1: string): string;
var
stream: Thandlestream;
buffer: array [0..1023] of char;
len_red: Integer;
cSHA1: TSHA1;
begin

      stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(hash_sha1)+'.dat',ARES_READONLY_BUT_SEQUENTIAL);
      if stream=nil then exit;

      stream.seek(50,soFromBeginning); //skip header
      cSHA1 := TSHA1.Create;

      while (true) do begin        // new format 29 bytes
         len_red := stream.read(buffer,29);
         if len_red=29 then cSHA1.Transform(Buffer[9], Len_red) else break;
      end;

  cSHA1.Complete;
   Result := cSHA1.HashValue;
  cSHA1.Free;

      FreeHandleStream(Stream);

end;

function ICH_copyDLHash_todb(download: TDownload): Cardinal;
var
i: Integer;
len_item,num32: Cardinal;
num64: Int64;
stream_to: Thandlestream;
buffer: array [0..50] of char;
piece: TDownloadPiece;
str: string;
begin   //copiamo contenuto file in PHashIdx.dat e usciamo con point on db per aggiornare file
result := 0;


    if not fileexistsW(data_path+'\Data\PHashIdx.dat') then stream_to := MyFileOpen(data_path+'\Data\PHashIdx.dat',ARES_OVERWRITE_EXISTING)
     else stream_to := MyFileOpen(data_path+'\Data\PHashIdx.dat',ARES_WRITE_EXISTING);

      if stream_to=nil then begin
       helper_diskio.deletefileW(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat'); //temp hash?
       exit;
      end;


     if stream_to.size=0 then begin//skip header magic key if already there in PhashIdx.dat
      str := '__ARESDBP102__';
      move(str[1],buffer[0],length(str));
      stream_to.write(buffer,14);
     end else stream_to.seek(stream_to.size,soFromBeginning);

  Result := stream_to.position;   //per aggiornare pfile!


  //add checksum header
  num64 := 1;
  move(num64,buffer[0],8);
   len_item := (int64(download.size div int64(download.FPieceSize))+1)*20;
   move(len_item,buffer[8],4);
    move(download.hash_sha1[1],buffer[12],20);
     num32 := 1;
     move(num32,buffer[32],4);
  stream_to.write(buffer,36);


  for i := 0 to high(download.FPieces) do begin
   piece := download.Fpieces[i];
   stream_to.write(piece.FHashValue[0],20)
  end;

     FreeHandleStream(Stream_to);

 helper_diskio.deletefileW(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat'); //temp hash?
end;

procedure ICH_eraseDLHash(hash_sha1: string);
begin
 helper_diskio.deletefileW(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(hash_sha1)+'.dat'); //temp hash?
end;

procedure ICH_WriteDlDBHeader(download: TDownload; stream: THandleStream);
var
str: string;
offset: Integer;
buffer_header: array [0..49] of Byte;
num64: Int64;
num32,lenItem: Cardinal;
begin
 str := '__ARESDBP103__';
 offset := 0;
 move(str[1],buffer_header[offset],14);
 inc(offset,14);

 num64 := 1;
 move(num64,buffer_header[offset],8);
 inc(offset,8);

 lenItem := length(download.FPieces)*29;
  move(lenItem,buffer_header[offset],4);
 inc(offset,4);

 move(download.hash_sha1[1],buffer_header[offset],20);
 inc(offset,20);

 num32 := 1;
 move(num32,buffer_header[offset],4);
 stream.write(buffer_header[0],sizeof(buffer_header));
end;

procedure ICH_SaveDownloadBitField(download: TDownload);
var
i: Integer;
piece: TDownloadPiece;
stream: THandleStream;
buffer_piece: array [0..28] of Byte;
begin

 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Data\TempDL'),nil);

 stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat',ARES_OVERWRITE_EXISTING);
 if stream=nil then exit;


 stream.size := 50+(length(download.FPieces)*29);
 stream.position := 0;

 ICH_WriteDLDBHeader(download,stream);

 // write pieces 29 bytes each
 for i := 0 to high(download.Fpieces) do begin
   piece := download.FPieces[i];
   buffer_piece[0] := integer(piece.FDone);
   move(piece.FProgress,buffer_piece[1],8);
   move(piece.FHashValue[0],buffer_piece[9],20);
   stream.write(buffer_piece[0],sizeof(buffer_piece));
 end;

 FreeHandleStream(stream);

end;

procedure ICH_loadPieces(download: Tdownload);
var
stream: Thandlestream;
buffer_piece: array [0..28] of Byte;
offSetPiece: Int64;
piece: TDownloadPiece;
i: Integer;
thissize: Int64;
begin
   stream := MyFileOpen(data_path+'\Data\TempDL\PHash_'+bytestr_to_hexstr(download.hash_sha1)+'.dat',ARES_READONLY_BUT_SEQUENTIAL);
   if stream=nil then begin
    exit;
   end;

   if not ICH_DbSanityCheck(stream,download) then begin
    exit;
   end;

   SetLength(download.FPieces,int64(download.size div int64(download.FPieceSize))+1);

   offSetPiece := 0;

   if stream.size=(length(download.FPieces)*20)+50 then begin // old format, should set done=true till phash_verified_progr
      for i := 0 to high(download.Fpieces) do begin
        piece := TDownloadPiece.create;
         piece.FOffset := offSetPiece;
         piece.FProgress := 0;
         piece.FDone := ((piece.FOffset+int64(download.FPieceSize))<=download.phash_verified_progr);
         piece.FInUse := piece.FDone;
         stream.Read(piece.FHashValue[0],20);
         download.FPieces[i] := piece;
         offSetPiece := offsetpiece+int64(download.FPieceSize);
      end;
    FreeHandleStream(Stream);
    ICH_SaveDownloadBitField(download);
    exit;
   end;

   if stream.size<>(length(download.FPieces)*29)+50 then begin
    FreeHandleStream(Stream);
    SetLength(download.FPieces,0);
    exit;
   end;

   //new db has chunk status infos included
   download.progress := 0;
   download.phash_verified_progr := 0;
   for i := 0 to high(download.Fpieces) do begin

        stream.Read(buffer_piece[0],sizeof(buffer_piece));

        piece := TDownloadPiece.create;
         piece.FOffset := offSetPiece;
         piece.FDone := (buffer_piece[0]=1);
         move(buffer_piece[1],piece.FProgress,8);
         move(buffer_piece[9],piece.FHashValue[0],20);
         piece.FInUse := piece.FDone;
         download.FPieces[i] := piece;
         offSetPiece := offsetpiece+int64(download.FPieceSize);

         if piece.FDone then begin
           if piece.FOffset+int64(download.FpieceSize)>download.size then thissize := download.size-piece.FOffset
             else thissize := int64(download.FPieceSize);
          inc(download.phash_verified_progr,thissize);
          inc(download.progress,thissize);
         end else
         if ((piece.FProgress>0) and 
             (piece.FProgress<int64(download.FPieceSize))) then inc(download.progress,int64(piece.FProgress));

      end;
      FreeHandleStream(Stream);



      if length(download.FPieces)>0 then begin
       piece := download.FPieces[0];
       if piece.FDone then
         if download.AviHeaderState=aviStateNotChecked then
            helper_preview.CheckAviHeader(download);
      end;
end;

function ICH_DbSanityCheck(stream: THandleStream; download: TDownload): Boolean;
var
len_red,num64: Int64;
num32,len_Item,expecteddblen: Cardinal;
str: string;
buffer_header: array [0..49] of Byte;
begin
result := False;

  len_red := stream.read(buffer_header,sizeof(buffer_header)); 
   if len_red<>50 then begin
    FreeHandleStream(Stream);
    exit;
   end;

   SetLength(str,14);
   move(buffer_header,str[1],14);
   if str='__ARESDBP103__' then expecteddblen := (int64(download.size div int64(download.FPieceSize))+1)*29
    else
     if str='__ARESDBP102__' then expecteddblen := (int64(download.size div int64(download.FPieceSize))+1)*20
      else begin
       FreeHandleStream(Stream);
       exit;
      end;

   move(buffer_header[14],num64,8);
   if num64<>1 then begin
     FreeHandleStream(Stream);
     exit;
   end;
   move(buffer_header[46],num32,4);
   if num32<>1 then begin
     FreeHandleStream(Stream);
     exit;
   end;
   move(buffer_header[22],len_item,4);
   if len_item<>expecteddblen then begin
     FreeHandleStream(Stream);
     exit;
   end;
   if stream.position+expecteddblen>stream.size then begin //not enough data
     FreeHandleStream(Stream);
     exit;
   end;

   if not comparemem(@buffeR_header[26],@download.hash_sha1[1],20) then begin
     FreeHandleStream(Stream);
     exit;
   end;
   Result := True;
end;

function ICH_verify_chunk(download: Tdownload; risorsa: Trisorsa_download): Boolean;
var
sha1: Tsha1;
buffer: array [0..1023] of char;
HashValue,hashTemp: string;
to_read,bytes_to_read,len_red,RemainingCount: Int64;
begin
result := False;

helper_diskio.MyFileSeek(download.stream,risorsa.piece.Foffset,ord(soFromBeginning));
if helper_diskio.MyFileSeek(download.stream,0,ord(soCurrent))<>risorsa.piece.Foffset then begin
 exit;
end;


  if risorsa.piece.FOffset+int64(download.FpieceSize)>download.size then bytes_to_read := download.size-risorsa.piece.FOffset
   else bytes_to_read := int64(download.FPieceSize);

  sha1 := tsha1.create;

  RemainingCount := bytes_to_read;
  while (true) do begin
     to_read := RemainingCount;
     if to_read>sizeof(buffer) then to_read := sizeof(buffer);

     len_red := download.stream.read(buffer[0],to_read);
      if len_red>0 then sha1.transform(buffer[0],len_red) else break;
      dec(RemainingCount,len_red);
      if RemainingCount=0 then break;
  end;

  sha1.complete;
 hashValue := sha1.hashvalue;
  sha1.Free;

  SetLength(hashTemp,20);
  move(risorsa.piece.FHashValue[0],hashTemp[1],20);

  if CompareMem(@HashValue[1],@risorsa.piece.FHashValue[0],20) then begin   //qui confrontiamo anche risorsa per bannarla in caso di corruzione
    risorsa.piece.FDone := True;
    risorsa.ICH_failed := False;
   Result := True;
   inc(download.phash_verified_progr,bytes_to_read);
   exit;
  end;


  risorsa.ICH_failed := True;
  risorsa.piece.Fprogress := 0;
  dec(download.progress,bytes_to_read); //download this piece again
end;

function ICH_corrupt_dl_index(download: Tdownload; risorsa: Trisorsa_download; var completed:boolean): Boolean; //true if corrupt
var
num64: Int64;
num32,len_item: Cardinal;
buffer: array [0..35] of Byte;
str: string;
begin
result := False;  //corruption is a serius thing :-)
completed := False;

    if download.phash_stream.size<50 then begin
     //risorsa.state := srs_receivingICH;
     exit;
    end;


///////////////////////////////////////////////////////////////////////////////////////////// VALIDITY CHECK
    download.phash_stream.position := 0;  //start reading from zero

        if download.phash_stream.read(buffer[0],14)<>14 then begin
         Result := True;
         exit;
        end;

        SetLength(str,14);
        move(buffer[0],str[1],14);
        if str<>'__ARESDBP102__' then begin   //sanity check?
         Result := True;        //db corrupted??
         exit;
        end;

        if download.phash_stream.read(buffer,sizeof(buffer))<>sizeof(buffer) then begin
         Result := True;
         exit;
        end;

        move(buffer[0],num64,8);         //sanity check1 failed?
        if num64<>1 then begin
         Result := True;
         exit;
        end;
        move(buffer[32],num32,4);     //sanity check2 failed?
        if num32<>1 then begin
         Result := True;
         exit;
        end;

        if not CompareMem(@download.hash_sha1[1],@buffer[12],20) then begin
         Result := True;
         exit;
        end;
////////////////////////////////////////////////////////////////////////////////////////////////


        move(buffer[8],len_item,4);     //completed?
        if download.phash_stream.position+int64(len_item)<=download.phash_stream.size then begin  // o ho tutto tolgo da stato receiving come se avessi finito una risorsa
         completed := True;
        end; // else risorsa.state := srs_receivingICH;
        
end;


procedure ICH_send_Phash(UDP_Socket:Hsocket; hash_sha1: string; UDP_buffer:pchar; LenBuffer: Integer; UDP_RemoteSin: TVarSin; insertion_point: Cardinal;  file_size_reale: Int64);
var
fname: WideString;
stream_to: Thandlestream;
buffer: array [0..1050] of Byte;
his_progress: Cardinal;
ssize,to_send: Cardinal;
begin
fname := data_path+'\Data\TempUL\UDPPHash_'+bytestr_to_hexstr(hash_sha1)+'.dat';
move(UDP_Buffer^,buffer[0],LenBuffer);

 if not fileexistsW(fname) then stream_to := ICH_ExtractDataForUpload(hash_sha1,insertion_point,fname)
  else stream_to := MyFileOpen(fname,ARES_READONLY_BUT_SEQUENTIAL);

  if stream_to=nil then begin // error
   Buffer[0] := CMD_UDPTRANSFER_ICHPIECEERR1;
   synsock.SendTo(UDP_socket,
                  Buffer,
                  LenBuffer,
                  0,
                  @UDP_RemoteSin,
                  SizeOf(UDP_RemoteSin));
    exit;
   end;


move(buffer[25],his_progress,4);
ssize := stream_to.size;

 if his_progress>=ssize then begin // ended ICH transfer
  Buffer[0] := CMD_UDPTRANSFER_ICHPIECEERR2;
  synsock.SendTo(UDP_socket,
                 Buffer,
                 LenBuffer,
                 0,
                 @UDP_RemoteSin,
                 SizeOf(UDP_RemoteSin));
  FreeHandleStream(stream_to);
  exit;
 end;



stream_to.seek(his_progress,sofrombeginning);
to_send := ssize-his_progress;
if to_send>1000 then to_send := 1000;


if stream_to.read(buffer[33],to_send)<>to_send then begin  // read error
  Buffer[0] := CMD_UDPTRANSFER_ICHPIECEERR3;
  synsock.SendTo(UDP_socket,
                 Buffer,
                 LenBuffer,
                 0,
                 @UDP_RemoteSin,
                 SizeOf(UDP_RemoteSin));
 FreeHandleStream(stream_to);
 exit;
end;

FreeHandleStream(stream_to);


  Buffer[0] := CMD_UDPTRANSFER_ICHPIECEREP;
  move(ssize,buffer[29],4); // let remote peer know about stream's expected size

  synsock.SendTo(UDP_socket,
                 Buffer,
                 to_send+33,
                 0,
                 @UDP_RemoteSin,
                 SizeOf(UDP_RemoteSin));
                 
end;

function ICH_ExtractDataForUpload(hash_sha1: string; insertion_point: Cardinal; fname: WideString): ThandleStream;
var
stream_from: THandleStream;
letti,to_write,len_to_read,len_red: Integer;
buffeR: array [0..1023] of char;
str,hash_sha1_comp: string;
num64,position: Int64;
num32,len_item: Cardinal;
begin
result := nil;

stream_from := MyFileOpen(data_path+'\Data\PHashIdx.dat',ARES_READONLY_BUT_SEQUENTIAL);
if stream_from=nil then exit;

letti := stream_from.read(buffer,14);
 if letti<14 then begin
  FreeHandleStream(Stream_from);
  exit;
 end;

 SetLength(str,14);
 move(buffer,str[1],14);

 if str<>'__ARESDBP102__' then begin
      FreeHandleStream(Stream_from);
      exit;
 end;

  stream_from.seek(insertion_point,sofrombeginning);
  while stream_from.position<>insertion_point do begin
   stream_from.seek(insertion_point,sofrombeginning);
   sleep(50);
  end;

   letti := stream_from.read(buffer,36); // 4 len item  -  20 hash
   if letti<>36 then begin
      FreeHandleStream(Stream_from);
      exit;
   end;

    move(buffer,num64,8);
    if num64<>1 then begin
      FreeHandleStream(Stream_from);
      exit;
    end;
    move(buffer[32],num32,4);
    if num32<>1 then begin
      FreeHandleStream(Stream_from);
      exit;
    end;

    move(buffer[8],len_item,4);
    position := stream_from.position;

      if stream_from.position+len_item>stream_from.size then begin
      FreeHandleStream(Stream_from);
      exit;
      end;

     stream_from.seek(position-36,sofrombeginning);
     while (stream_from.position<>position-36) do begin
      stream_from.seek(position-36,sofrombeginning); //torniamo indietro
      sleep(50);
     end;

       SetLength(hash_sha1_comp,20);
       move(buffer[12],hash_sha1_comp[1],20);

       if hash_sha1<>hash_sha1_comp then begin
         FreeHandleStream(Stream_from);
        exit;
       end;
       
       //ok ho pezzo, inizio copia

       tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Data\TempUL'),nil);


       Result := MyFileOpen(fname,ARES_OVERWRITE_EXISTING);
       if result=nil then exit;

       str := '__ARESDBP102__';
       move(str[1],buffer,14);
       result.write(buffer,14);  //write header

       to_write := len_item+36;
       while (to_write>0) do begin
         len_to_read := to_write;
         if len_to_read>sizeof(buffer) then len_to_read := sizeof(buffer);

          len_red := stream_from.read(buffer,len_to_read);
                  result.write(buffer,len_red);

          dec(to_write,len_red);
       end;

       FreeHandleStream(Stream_from);
end;

function ICH_send_Phash(strt_time: Cardinal; hash_sha1: string; sockt: Ttcpblocksocket; insertion_point: Cardinal; enc_key: Word; file_size_reale: Int64): Tupload;   //get phash, copy to temp file and assign upload to it (at the end of transfer remove temp file)
var
stream_to: Thandlestream;
i,skipped_len: Integer;
stringa,str: string;
fname: WideString;
begin
result := nil;


       fname := data_path+'\Data\TempUL\'+inttostr(random($ffffff))+'_'+bytestr_to_hexstr(hash_sha1)+'.dat';

       stream_to := ICH_ExtractDataForUpload(hash_sha1,insertion_point,fname);
       if stream_to=nil then exit;

       stream_to.seek(0,sofrombeginning);


       stringa := STR_HTTP1+HTTP200+CRLF+
                STR_SERVER_ARES+vars_global.versioneares+CRLF+
                STR_HERE_PHASH_INDEXS+bytestr_to_hexstr(hash_sha1)+CRLF+
                STR_PHASH_SIZE+inttostr(ICH_calc_Chunk_size(file_size_reale))+CRLF+
                STR_XB64MYDET+chr(32)+encodebase64(helper_ipfunc.serialize_myConDetails)+CRLF+
                STR_CONTENT_LENGTH+inttostr(stream_to.size)+CRLF+
                CRLF;



   Result := tupload.create(strt_time);

     skipped_len := random(16)+1;
     str := chr(random($ff))+chr(random($ff))+chr(skipped_len);
      for i := 1 to skipped_len do str := Str+chr(random($ff));
     stringa := str+stringa;

    result.is_encrypted := True;
    result.encryption_key := enc_key;
     for I := 1 to Length(Stringa) do begin
      stringa[I] := char(byte(Stringa[I]) xor (result.encryption_key shr 8));
      result.encryption_key := (byte(stringa[I]) + result.encryption_key) * 52079 + 16826;
     end;


          result.is_phash := True;
          result.socket := sockt;
            sockt.tag := result.start_time;
          result.filename := widestrtoutf8str(fname);
          result.crcfilename := stringcrc(result.filename,true);
          result.nickname := '';
          result.crcnick := 0;
          result.out_reply_header := stringa;
          result.stream := stream_to;
          result.his_progress := 0;
          result.his_upcount := 0;
          result.his_downcount := 0;
          result.his_shared := 0;
          result.ip_server := 0;
          result.ip_alt := 0;
          result.port_server := 0;
          result.ip_user := 0;
          result.port_user := 0;
          result.actual := 0;
          result.startpoint := 0;
          result.endpoint := stream_to.size-1;
          result.size := stream_to.size;
          result.filesize_reale := result.size;
          result.bytesprima := 0;
          result.velocita := 0;
          result.should_display := False;
          result.num_available := 0;

end;

procedure ICH_load_phash_indexs;
var
stream: Thandlestream;

str: string;
buffer: array [0..99] of Byte;
letti: Integer;

len_item: Cardinal;
item,last_item:precord_phash_index;
position: Cardinal;

num32: Cardinal;
num64: Int64;
begin

stream := MyFileOpen(data_path+'\Data\PHashIdx.dat',ARES_READONLY_BUT_SEQUENTIAL);
if stream=nil then exit;

letti := stream.read(buffer,14);
 if letti<14 then begin
  FreeHandleStream(Stream);
  exit;
 end;

 SetLength(str,14);
 move(buffer,str[1],14);

 if str<>'__ARESDBP102__' then begin
      FreeHandleStream(Stream);
      exit;
 end;


 while true do begin

  letti := stream.read(buffer,36); // 4 len item  -  20 hash
   if letti<>36 then begin
   break;
   end;

    move(buffer,num64,8);
    if num64<>1 then begin
     break;
    end;
   move(buffer[32],num32,4);
   if num32<>1 then begin
    break;
   end;

    move(buffer[8],len_item,4);
    position := stream.position;

      stream.seek(position+len_item,soFromBeginning);
      if stream.position<>position+len_item then begin
      break; //completo?
      end;

     dec(position,36);

     item := AllocMem(sizeof(record_phash_index));
      item^.db_point_on_disk := position;
      item^.len_on_disk := len_item;
      
       SetLength(item^.hash_sha1,20);
       move(buffer[12],item^.hash_sha1[1],20);
       item^.crcsha1 := crcstring(item^.hash_sha1);
       

       if DB_INDEXS_PHASH[ord(item^.hash_sha1[1])]=nil then item^.next := nil
        else begin
         last_item := DB_INDEXS_PHASH[ord(item^.hash_sha1[1])];
         item^.next := last_item;
        end;
        DB_INDEXS_PHASH[ord(item^.hash_sha1[1])] := item;

 end;

      FreeHandleStream(Stream);
end;

procedure ICH_free_phash_indexs;
var
i: Integer;
phash_index,next_phash:precord_phash_index;
begin
 try

 for i := 0 to 255 do begin
  if DB_INDEXS_PHASH[i]=nil then continue;
   phash_index := DB_INDEXS_PHASH[i];
   while (phash_index<>nil) do begin
    next_phash := phash_index^.next;

      phash_index^.hash_sha1 := '';
     FreeMem(phash_index,sizeof(record_phash_index));

    phash_index := next_phash;

    DB_INDEXS_PHASH[i] := nil;
  end;
 end;

 except
 end;
 
 helper_diskio.deletefileW(data_path+'\Data\TempPHash.dat');
 helper_diskio.deletefileW(data_path+'\Data\PHashIdx.dat');
 Tnt_MoveFileW(pwidechar(data_path+'\Data\PHashIdxTemp.dat'), pwidechar(data_path+'\Data\PHashIdx.dat'));
end;

procedure ICH_init_phash_indexs;
var
i: Integer;
begin

for i := 0 to 255 do DB_INDEXS_PHASH[i] := nil;

 helper_diskio.deletefileW(data_path+'\Data\PHashIdxTemp.dat');
 helper_diskio.deletefileW(data_path+'\Data\TempPHash.dat');
end;


end.