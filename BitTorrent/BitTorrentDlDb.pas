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
Db stored on disk containing Transfer informations
}


unit BitTorrentDlDb;

interface

uses
  Classes, Classes2, Btcore, TntWindows;

const
  TAG_TORRENT_DB_NAME     = 1;
  TAG_TORRENT_DB_ANNOUNCE = 2;
  TAG_TORRENT_DB_COMMENT  = 3;
  TAG_TORRENT_DB_DATE     = 4;
  TAG_TORRENT_START_DATE  = 5;
  TAG_TORRENT_DB_ANNOUNCES= 6;
  TAG_TORRENT_ELAPSED     = 7;

  BT_DBERROR_FILEMISSING              = 1;
  BT_DBERROR_FILEPROTECTED            = 2;
  BT_DBERROR_HASHMISMATCH             = 3;
  BT_DBERROR_FILECORRUPTED            = 4;
  BT_DBERROR_FILECORRUPTED_CHUNK      = 5;
  BT_DBERROR_FILECORRUPTED_POSTCHUNK  = 6;
  BT_DBERROR_FILECORRUPTED_FILES      = 7;
  BT_DBERROR_FILECORRUPTED_FINAL      = 8;
  BT_DBERROR_FILES_LOCKED             = 10;

procedure BitTorrentDb_updateDbOnDisk(Transfer: TBitTorrentTransfer);
procedure BitTorrentDb_clearDb(Transfer: TBitTorrentTransfer);
procedure bitTorrentDb_CheckErase(Transfer: TBitTorrentTransfer);
procedure BitTorrentDb_load(Transfer: TBitTorrentTransfer);

implementation

uses
  helper_diskio,BittorrentStringfunc,windows,ares_objects,helper_unicode,
  sysutils,vars_global,helper_strings,bittorrentConst,BitTorrentUtils,
  helper_mimetypes;
 
procedure bitTorrentDb_CheckErase(Transfer: TBitTorrentTransfer);
var
dbsize: Integer;
begin
dbsize := 0;

with transfer do begin
  if dbstream<>nil then begin
   dbsize := dbstream.size;
   FreeHandleStream(dbstream);
   dbstream := nil;
  end;
end;

if dbsize=0 then begin
 helper_diskio.deletefileW(vars_global.data_Path+'\Data\TempDl\PBTHash_'+bytestr_to_hexstr(Transfer.fHashValue)+'.dat');
end;
end;

procedure BitTorrentDb_clearDb(Transfer: TBitTorrentTransfer);
begin
if Transfer.dbstream<>nil then Transfer.dbstream.size := 0;
end;

procedure BitTorrentDb_load(Transfer: TBitTorrentTransfer);

    procedure setError(Errocode:integer);
    begin
      Transfer.ferrorCode := errocode;
      if Transfer.ferrorCode<=BT_DBERROR_FILEPROTECTED then exit;
       transfer.dbstream.size := 0;
      if Transfer.FerrorCode<BT_DBERROR_FILECORRUPTED_CHUNK then exit;
       Transfer.FreeChunks;
      if Transfer.FerrorCode<BT_DBERROR_FILECORRUPTED_FILES then exit;
       Transfer.FreeFiles;
    end;

var
 dbName: WideString;
 offset: Integer;
 num16: Word;
 num32: Cardinal;
 num64: Int64;
 buffer: array [0..1023] of Byte;
 file_modify_time: Cardinal;
 //filedownloadable,filePrioritary,filePreviewable: Boolean;
 chunk: TBitTorrentChunk;
 chunkOffset: Int64;
 filescount,ChunkSize: Cardinal;
 newfile: TBitTorrentFile;
 fileOffset,maxSize: Int64;
 filname,rootpath,parseStr,payload,therootpath,ext: string;
 bytCount,i,hi: Integer;
 tagid: Byte;
 lenPayload: Word;
begin
try

dbname := vars_global.data_Path+'\Data\TempDl\PBTHash_'+bytestr_to_hexstr(Transfer.fHashValue)+'.dat';
if not fileexistsW(dbname) then begin
 setError(BT_DBERROR_FILEMISSING);
 exit;
end;

transfer.dbstream := MyFileOpen(dbname,ARES_WRITE_EXISTING);
if transfer.dbstream=nil then begin
 setError(BT_DBERROR_FILEPROTECTED);
 exit;
end;

if transfer.dbstream.read(buffer,54)<>54 then begin
 setError(BT_DBERROR_FILECORRUPTED);
 exit;
end;

offset := 0;  //byte[0]= db version
if not comparemem(@buffer[offset+1],@Transfer.fHashValue[1],20) then begin
 setError(BT_DBERROR_HASHMISMATCH);
 helper_diskio.deletefileW(dbname);
 exit;
end;

transfer.fstate := BitTorrentUtils.BytetoBittorrentState(buffer[offset+21]);
if transfer.fstate=dlSeeding then transfer.UploadTreeview := True;
//if buffer[offset+21]=1 then Transfer.Fstate := dlPaused;
 inc(offset,22);
move(buffer[offset],Transfer.fsize,8);
 inc(offset,8);
move(buffer[offset],Transfer.fPieceLength,4);
 inc(offset,4);
move(buffer[offset],Transfer.fDownloaded,8);
 inc(offset,8);
move(buffer[offset],Transfer.fUploaded,8);
 inc(offset,8);
move(buffer[offset],num32,4);
SetLength(Transfer.FPieces,num32);
 inc(offset,4);


chunkOffset := 0;
Transfer.fDownloaded := 0;
chunkSize := Transfer.fPieceLength;
for i := 0 to high(Transfer.Fpieces) do Transfer.fpieces[i] := nil;
for i := 0 to high(Transfer.fPieces) do begin
 if transfer.dbstream.read(buffer,21)<>21 then begin
  setError(BT_DBERROR_FILECORRUPTED_CHUNK);
  helper_diskio.deletefileW(dbname);
  exit;
 end;

 if i=high(Transfer.fPieces) then
  if chunkOffset+ChunkSize>Transfer.fSize then ChunkSize := Transfer.fsize-chunkOffset;

 chunk := TBitTorrentChunk.create(Transfer,chunkOffset,chunkSize,i);
  move(buffer[0],chunk.checksum[0],20);
  chunk.checked := (buffer[20]=1);
  if chunk.checked then begin
   chunk.fprogress := chunkSize;
   inc(Transfer.fDownloaded,chunkSize);
    for hi := 0 to high(chunk.pieces) do chunk.pieces[hi] := True;
  end;
   Transfer.fPieces[i] := chunk;

 inc(chunkOffset,chunkSize);

end;

transfer.tempDownloaded := transfer.fdownloaded;

// get filecount & torrent name
if transfer.dbstream.read(buffer,6)<>6 then begin
 setError(BT_DBERROR_FILECORRUPTED_POSTCHUNK);
 exit;
end;
move(buffer[0],filesCount,4);
move(buffer[4],num16,2);

SetLength(Transfer.fname,num16);
if transfer.dbstream.Read(Transfer.Fname[1],num16)<>num16 then begin
 setError(BT_DBERROR_FILECORRUPTED_POSTCHUNK);
 exit;
end;


if pos('\',Transfer.fname)=0 then Transfer.fname := widestrtoutf8str(vars_global.my_torrentFolder)+'\'+Transfer.fname;
rootpath := Transfer.fname;

transfer.ffileS := tmylist.create;
fileOffset := 0;
maxSize := 0;
for i := 1 to filesCount do begin

  if transfer.dbstream.read(buffer,10)<>10 then begin
   setError(BT_DBERROR_FILECORRUPTED_FILES);
   exit;
  end;
   move(buffer[0],num64,8);  // size
   move(buffer[8],num16,2);  // len of filename

   if num16=0 then begin   // if these two bytes are set to zero, then we have to expect new (1.9.5+) db which includes downloadable state
    if transfer.dbstream.read(buffer,6)<>6 then begin
     setError(BT_DBERROR_FILECORRUPTED_FILES);
     exit;
    end;
    //filedownloadable := (buffer[0]=1);
   // filePrioritary := (buffer[1]=1);
    //filePreviewAble := (buffer[2]=1);
    move(buffer,file_modify_time,4);
    move(buffer[4],num16,2);
   end; // else filedownloadable := True;

   SetLength(filname,num16);
  if transfer.dbstream.read(filname[1],num16)<>num16 then begin
   Transfer.ferrorCode := BT_DBERROR_FILECORRUPTED_FILES;
   exit;
  end;

  if filesCount=1 then begin
    therootpath := extractfilepath(Transfer.fname);
    delete(therootpath,length(therootpath),1);
    newfile := TBitTorrentFile.create(therootpath,
                                    filname,
                                    fileOffset,
                                    num64,
                                    transfer,
                                    false,
                                    file_modify_time);
    ext := lowercase(extractfileext(filname));
    if (transfer.suggestedMime=100) and (length(ext)>1) then begin
     transfer.suggestedmime := helper_mimetypes.extstr_to_mediatype(ext);

    end;
  end else begin
  //if transfer.ferrorCode=0 then
  newfile := TBitTorrentFile.create(rootpath,
                                  filname,
                                  fileOffset,
                                  num64,
                                  transfer,
                                  false,
                                  file_modify_time);
     if maxSize<num64 then begin
      maxSize := num64;
      ext := lowercase(extractfileext(filname));
     end;

  end;
  //if transfer.ferrorCode<>0 then setError(BT_DBERROR_FILES_LOCKED);

  if transfer.ferrorcode<>0 then begin
   // setError(BT_DBERROR_FILES_LOCKED);
    exit;
  end;

  inc(fileOffset,num64);
  Transfer.ffiles.add(newfile);
end;

   if (transfer.suggestedMime=100) and (maxSize>0) and (length(ext)>1) then begin
    transfer.suggestedmime := helper_mimetypes.extstr_to_mediatype(ext);  //mime taken by the biggest file
    
   end;

bytCount := transfer.dbstream.Read(buffer,sizeof(buffer));
if bytCount<2 then begin
 setError(BT_DBERROR_FILECORRUPTED_FINAL);
 exit;
end;

SetLength(parseStr,bytCount);
move(buffer[0],parseStr[1],bytCount);

while (length(parseStr)>2) do begin
 tagid := ord(parseStr[1]);
 move(parseStr[2],lenPayload,2);
 delete(parseStr,1,3);

 payload := copy(parseStr,1,lenPayload);
 case tagid of
  TAG_TORRENT_DB_ANNOUNCES,
  TAG_TORRENT_DB_ANNOUNCE: Transfer.addTracker(payload);
  TAG_TORRENT_DB_COMMENT:begin
                          transfer.fcomment := payload;
                         end;
  TAG_TORRENT_DB_DATE: Transfer.fdate := chars_2_dword(payload);
  TAG_TORRENT_START_DATE: Transfer.start_date := chars_2_dword(payload);
  TAG_TORRENT_ELAPSED: Transfer.m_elapsed := chars_2_dword(payload);
 end;

 delete(parseStr,1,lenPayload);
end;

transfer.CalculateFilesProgress;

except
end;
end;

procedure BitTorrentDb_updateDbOnDisk(Transfer: TBitTorrentTransfer);
var
 dbName: WideString;
 subfilename,announceURL: string;
 buffer: array [0..1023] of Byte;
 offset,i: Integer;
 num32,tmplen: Cardinal;
 chunk: TBitTorrentChunk;
 num16: Word;
 thisfile: TBitTorrentFile;
 tracker: TbittorrentTracker;
begin
if transfer.fstate=dlBittorrentMagnetDiscovery then exit;
if length(transfer.fHashValue)<>20 then exit;
try

tntwindows.tnt_createdirectoryW(pwidechar(vars_global.data_Path+'\Data'),nil);
tntwindows.tnt_createdirectoryW(pwidechar(vars_global.data_Path+'\Data\TempDl'),nil);

with transfer do begin
dbname := vars_global.data_Path+'\Data\TempDl\PBTHash_'+bytestr_to_hexstr(fHashValue)+'.dat';

if ((not fileexistsW(dbname)) or (dbstream=nil)) then dbstream := MyFileOpen(dbname,ARES_OVERWRITE_EXISTING);
if dbStream=nil then exit;

dbstream.size := 0;

// create a DB containing torrent Transfer infos and chunk checksum values
offset := 0;
buffer[offset] := 1; //DB's version
 inc(offset);
move(fHashValue[1],buffer[offset],20);
 inc(offset,20);
buffer[offset] := bittorrentStatetoByte(transfer.fstate);
 inc(offset);
move(fsize,buffer[offset],8);
 inc(offset,8);
move(fPieceLength,buffer[offset],4);
 inc(offset,4);
move(fDownloaded,buffer[offset],8);
 inc(offset,8);
move(fUploaded,buffer[offset],8);
 inc(offset,8);
num32 := high(fPieces)+1;
move(num32,buffer[offset],4);
 inc(offset,4);
dbstream.write(buffer,offset);

offset := 0;


for i := 0 to high(fpieces) do begin
 chunk := fpieces[i];

 move(chunk.CheckSum[0],buffer[offset],20);
 buffer[offset+20] := integer(chunk.checked);
 inc(offset,21);

 if offset>1000 then begin
  dbstream.write(buffer,offset);
  offset := 0;
 end;

end;

if offset>0 then begin
  dbstream.write(buffer,offset);
  offset := 0;
end;


 num32 := ffiles.count;
move(num32,buffer[offset],4);
 num16 := length(fname);
move(num16,buffer[offset+4],2);
move(fname[1],buffer[offset+6],num16);  // write torrent name & filecount
dbstream.write(buffer,6+num16);
 offset := 0;

 tmplen := length(fname+'\');

for i := 0 to ffiles.count-1 do begin
   thisfile := ffiles[i];
   offset := 0;

  subfilename := thisfile.ffilename;
  if ffiles.count>1 then delete(subfilename,1,tmplen) else subfilename := extractfilename(subfilename);

  move(thisfile.fsize,buffer[offset],8);
   inc(offset,8);
   //1.9.5 & +
  num16 := 0;
  move(num16,buffer[offset],2);
   inc(offset,2);

 move(thisfile.modify_date,buffer[offset],4);
 inc(offset,4);
 { buffer[offset] := integer(thisfile.fdownloadable);
   inc(offset);
  buffer[offset] := integer(thisfile.fprioritary);
   inc(offset);
  buffer[offset] := integer(thisfile.fpreviewable);
   inc(offset,2);  // leave room for extra two bytes
 }
  num16 := length(subfilename);
  move(num16,buffer[offset],2);
   inc(offset,2);
  move(subfilename[1],buffer[offset],num16);
   inc(offset,num16);
  dbstream.write(buffer,offset);
end;


// announce
for i := 0 to transfer.trackers.count-1 do begin
 tracker := transfer.trackers[i];
 announceURL := tracker.url;
   if transfer.trackers.count=1 then buffer[0] := TAG_TORRENT_DB_ANNOUNCE
    else buffer[0] := TAG_TORRENT_DB_ANNOUNCES;
    num16 := length(announceURL);
    move(num16,buffer[1],2);
   if num16>0 then move(announceURL[1],buffer[3],length(announceURL));
    dbstream.write(buffer,length(announceURL)+3);
 end;

// comment
buffer[0] := TAG_TORRENT_DB_COMMENT;
num16 := length(fComment);
move(num16,buffer[1],2);
if num16>0 then begin
 move(fcomment[1],buffer[3],length(fcomment));
 offset := length(fcomment)+3;
end else offset := 3;
 dbstream.write(buffer,offset);


// write date
buffer[0] := TAG_TORRENT_DB_DATE;
buffer[1] := 4;
buffer[2] := 0;
move(fdate,buffer[3],4);
 dbstream.write(buffer,7);

// write start date
buffer[0] := TAG_TORRENT_START_DATE;
buffer[1] := 4;
buffer[2] := 0;
move(start_date,buffer[3],4);
 dbstream.write(buffer,7);

buffer[0] := TAG_TORRENT_ELAPSED;
buffer[1] := 4;
buffer[2] := 0;
move(m_elapsed,buffer[3],4);
 dbstream.write(buffer,7);

end;


except
end;
end;

end.                                                            
