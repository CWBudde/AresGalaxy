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
our ASYNC source filter (DSPACK at www.progdigy.com/dspack) doesn't allow us to load busy filestreams,
hence the need to copy audio/video files before previewing them, AVI temp header rebuilder adapted from divfix at http://divfix.maxeline.com
}

unit helper_preview;

interface

uses
classes,windows,ufrmpreview,helper_unicode,vars_localiz,helper_urls,helper_strings,
helper_diskio,const_ares,sysutils,tntwindows,vars_global,const_win_messages,ares_objects;

  type
  MainAVIHeader=record
    dwMicroSecPerFrame: Cardinal;
    dwMaxBytesPerSec: Cardinal;
    dwReserved1: Cardinal;
    dwFlags: Cardinal;
    dwTotalFrames: Cardinal;   // video frame count (audio could be less)
    dwInitialFrames: Cardinal;
    dwStreams: Cardinal;       // how many stream we're supposed to parse
    dwSuggestedBufferSize: Cardinal;
    dwWidth: Cardinal;
    dwHeight: Cardinal;
    dwScale: Cardinal;
    dwRate: Cardinal;
    dwStart: Cardinal;
    dwLength: Cardinal;
   end;

   AVIStreamHeader=record
    fccType: array [0..3] of char;
    fccHandler: array [0..3] of char;
    dwFlags: Cardinal;
    dwReserved1: Cardinal;
    dwInitialFrames: Cardinal;
    dwScale: Cardinal;   // dwScale = nBlockAlign for waveformatex
    dwRate: Cardinal;
    dwStart: Cardinal;
    dwLength: Cardinal;   // number of video frames or not so precise bytes count for audio
    dwSuggestedBufferSize: Cardinal;
    dwQuality: Integer;
    dwSampleSize: Cardinal;
   end;

   BITMAPINFOHEADER=record
    biSize: Cardinal;
    biWidth: Integer;
    biHeight: Integer;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: Cardinal;
    biSizeImage: Cardinal;
    biXPelsPerMeter: Integer;
    biYPelsPerMeter: Integer;
    biClrUsed: Cardinal;
    biClrImportant: Cardinal;
   end;

   WAVEFORMATEX=record
    wFormatTag: Word;
    nChannels: Word;
    nSamplesPerSec: Cardinal;
    nAvgBytesPerSec: Cardinal;
    nBlockAlign: Word;
    wBitsPerSample: Word;
    cbSize: Word;
   end;

   aviindex_chunk=record
    fcc: string[4];
    cb: Cardinal;
    wLongsPerEntry: Word;   // size of each entry in aIndex array
    bIndexSubType: Byte;    // future use.  must be 0
    bIndexType: Byte;       // one of AVI_INDEX_* codes
    nEntriesInUse: Cardinal;    // index of first unused member in aIndex array
    dwChunkId: Cardinal;        // fcc of what is indexed
    dwReserved1: Cardinal;    // meaning differs for each index
    dwReserved2: Cardinal;
    dwReserved3: Cardinal;
    adw: array of Byte; // type/subtype.   0 if unused
   end;

   
type
tth_cp= class(tthread)
 protected
  frmpreview: Tfrmpreview;
  DisplayedSize,DisplayedProgress: Int64;
  should_stop,
  IsAviFile: Boolean;
  bitfield: array of boolean;
  writer,reader,idxStream: Thandlestream;
  Copybuffer: Pointer;

  TotalFrameCount,
  TotalFrameAudio,
  TotalFrameVideo,
  TotalBytesAudio,
  TotalBytesVideo: Cardinal;
  SizeAviHeaderLists: Cardinal;
  positionAviHeader,positionStreamVideoHeader,positionStreamAudioHeader: Cardinal;
  MoviBlockPosition,MoviBlockSize: Cardinal;
  TotalAviFrameDone,estimatedMovieBlockSize: Cardinal;
  
  avih:MainAVIHeader;
  avishV,avishA:AVIStreamHeader;
  sizeIdx1,posIDX1: Cardinal;
  sizeDownChunk: Cardinal;
  
 protected
  procedure execute;override;
  procedure preview_start; //synchronize
  function preview_avi(source: WideString): WideString;
  procedure close_form;
  procedure open_form; //synch
  procedure Display_progress; //synch
  procedure generating_preview; //synch
  procedure copy_whole_File;
  procedure copy_downloaded_chunks;
  procedure copyChunk(start,endb: Int64);
  procedure RebuildAvi;
  function RebuildAviUsingIDX1: Boolean;
  procedure RebuildAviUsingHeuristic;
  procedure clearAviStats;
  procedure ParseAviHeaderList(StreamId: Integer; SizeTotal: Cardinal);
  procedure copyAviDataChunk(const chunkname: string; chunkflags,chunkOffset,chunkSize: Cardinal; checkFlags:boolean=false);
  function HasOffsetOnDisk(offset: Cardinal; wantedSize: Integer; sizeChunks: Cardinal): Boolean;
 public
  sources: WideString; // read fso write fso;
  dests: WideString; // read fde write fde;
  formhandle:hwnd; // read fhand write fhand;
end;

procedure Preview_copyAndOpen(DnData:precord_displayed_download); overload;
procedure Preview_copyAndOpen(BtData:precord_displayed_bittorrentTransfer); overload;
procedure CheckAviHeader(download: TDownload);
procedure GetEndofMoviBlock(download: TDownload);
function CheckIsAviFile(input: THandleStream): Boolean;
function AviHasIndexInFlags(Flags: Cardinal): Boolean;
function AviIsInterleavedInFlags(Flags: Cardinal): Boolean;
procedure copyBlock(StreamIn: THandleStream; StreamOut: ThandleStream; SizeC: Cardinal);


implementation

uses
 utility_ares,ufrmmain,helper_player,helper_ICH;

procedure Preview_copyAndOpen(BtData:precord_displayed_bittorrentTransfer);
  var
  dira: WideString;
  cp: Tth_cp;
  ext: string;
  fname: WideString;
  i: Integer;
begin
 fname := utf8strtowidestr(BtData^.path);
 ext := lowercase(extractfileext(BtData^.path));

// can't play image using asyncEx and seeking doesn't work well with videos
// therefore we're allowed to use it only with previewed audio files
 if pos(ext,PLAYABLE_ASYNCEX)<>0 then begin
  helper_player.player_playnew(fname,true);
  exit;
 end;

 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);
  dira := inttostr(gettickcount);
 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp\'+dira),nil);


cp := tth_cp.create(true);

SetLength(cp.bitfield,0);
if BtData^.bitfield<>nil then
 if length(BtData^.Bitfield)>0 then begin
   SetLength(cp.bitfield,length(BtData^.Bitfield));
   for i := 0 to high(cp.bitfield) do cp.bitfield[i] := BtData^.Bitfield[i];
 end;

 cp.sources := fname;
 cp.dests := data_path+'\Temp\'+dira+'\'+extract_fnameW(fname);
 cp.formhandle := ares_frmmain.handle;
  cp.resume;
end;

procedure Preview_copyAndOpen(DnData:precord_displayed_download);
  var
  dira: WideString;
  cp: Tth_cp;
  ext: string;
  fname: WideString;
  i: Integer;
begin
 fname := utf8strtowidestr(DnData^.filename);
 ext := lowercase(extractfileext(DnData^.filename));

// can't play image using asyncEx and seeking doesn't work well with videos
// therefore we're allowed to use it only with previewed audio files
 if pos(ext,PLAYABLE_ASYNCEX)<>0 then begin
  helper_player.player_playnew(fname,true);
  exit;
 end;

 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);
  dira := inttostr(gettickcount);
 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp\'+dira),nil);


cp := tth_cp.create(true);

SetLength(cp.bitfield,0);
if DnData^.VisualBitfield<>nil then
 if length(DnData^.VisualBitfield)>0 then begin
   SetLength(cp.bitfield,length(DnData^.VisualBitfield));
   for i := 0 to high(cp.bitfield) do cp.bitfield[i] := DnData^.visualBitfield[i];
 end;

 cp.sources := fname;
 cp.dests := data_path+'\Temp\'+dira+'\'+extract_fnameW(fname);
 cp.formhandle := ares_frmmain.handle;
  cp.resume;
end;

procedure tth_cp.open_form; //synch
var
nome: string;
wid: Integer;
begin

nome := widestrtoutf8str(extract_fnameW(dests));
if pos('___ARESTRA___',nome)=1 then delete(nome,1,13);
if length(nome)>200 then delete(nome,200,length(nome));

frmpreview := tfrmpreview.create(nil);
frmpreview.Label1.caption := GetLangStringW(STR_FILE)+': '+
                                         utf8strtowidestr(nome);


                                         
frmpreview.canvas.font.Name := frmpreview.Label1.font.Name;
frmpreview.canvas.font.size := frmpreview.Label1.font.size;
wid := gettextwidth(frmpreview.Label1.caption,frmpreview.canvas); //type
if wid+(frmpreview.Label1.left*2)>=230 then frmpreview.clientwidth := wid+(frmpreview.Label1.left*2);


frmpreview.label2.caption := GetLangStringW(STR_STATUS)+': '+
                       format_currency(DisplayedProgress div KBYTE)+' '+GetLangStringW(STR_OF)+' '+
                       format_currency(DisplayedSize div KBYTE)+' '+STR_KB;
frmpreview.ProgressBar1.max := DisplayedSize div KBYTE;
//frmpreview.Top := ares_frmmain.top+(ares_frmmain.Height div 2);
//frmpreview.left := ares_frmmain.Left+(ares_frmmain.width div 2);
frmpreview.show;
end;

procedure tth_cp.Display_progress; //synch
begin
frmpreview.ProgressBar1.position := DisplayedProgress div KBYTE;
frmpreview.label2.caption := GetLangStringW(STR_STATUS)+': '+
                       format_currency(DisplayedProgress div KBYTE)+' '+GetLangStringW(STR_OF)+' '+
                       format_currency(DisplayedSize div KBYTE)+' '+STR_KB;
if frmpreview.cancella then terminate;
if frmpreview.okstop then should_stop := True;
end;

procedure tth_cp.generating_preview; //synch
begin
frmpreview.caption := GetLangStringW(STR_GENERATING_PREVIEW);
end;

procedure tth_cp.copy_whole_File;
var
i: Integer;
Bytesread: Int64;
begin


 writer := MyFileOpen(dests,ARES_OVERWRITE_EXISTING);
 if writer=nil then begin
 exit;
 end;

 
 GetMem(Copybuffer, 4096);
 reader.seek(0,soFromBeginning);
 
 i := 0;
 while (reader.position<reader.size-(4*KBYTE)) do begin
  bytesread := reader.read(copybuffer^,4096);
   if bytesread>0 then begin
    writer.write(copybuffer^,bytesread);
    inc(DisplayedProgress,bytesread);

     inc(i);
     if (i mod 100)=0 then begin
      synchronize(Display_progress);
      if terminated then break;
      if should_stop then break;
     end;

    end;
   end;

  FreeHandleStream(Writer);

freemem(Copybuffer, 4096);
end;

procedure tth_cp.copyChunk(start,endb: Int64);
var
i,toRead,bytesread: Integer;
BytesProcessed: Integer;
sizeWanted: Integer;
begin
DisplayedProgress := start;


i := 0;
BytesProcessed := 0;
sizeWanted := (endb-start)+1;

 while (BytesProcessed<sizeWanted) do begin

    toRead := 4096;
    if BytesProcessed+toRead>sizeWanted then toRead := sizeWanted-BytesProcessed;
    bytesread := reader.read(copybuffer^,toRead);

     if bytesread>0 then begin
      writer.write(copybuffer^,bytesread);

       inc(DisplayedProgress,bytesread);
       inc(i);
       if (i mod 100)=0 then begin
        synchronize(Display_progress);
        if terminated then break;
        if should_stop then break;
       end;

      inc(BytesProcessed,bytesRead);
    end else break;

 end;

end;

procedure tth_cp.copy_downloaded_chunks;
var
sizeChunk: Cardinal;
offSet: Int64;
end_byte: Int64;
i: Integer;
begin
 GetMem(Copybuffer, 4096);
 sizeChunk := helper_ich.ICH_calc_chunk_size(DisplayedSize);

 writer := MyFileOpen(dests,ARES_OVERWRITE_EXISTING);
 if writer<>nil then begin

    reader.seek(0,soFromBeginning);
    offSet := 0;
    for i := 0 to high(bitfield) do begin

     if should_stop then break;

     if not bitfield[i] then begin
      inc(offset,sizeChunk);
      continue;
     end;

      end_byte := (offset+sizeChunk)-1;
      if end_byte>=DisplayedSize then end_byte := DisplayedSize-1;

      copyChunk(offset,end_byte);
      inc(offset,sizeChunk);
    end;

  FreeHandleStream(writer);
 end;

 freemem(Copybuffer, 4096);
end;

procedure tth_cp.clearAviStats;
begin
  TotalFrameCount := 0;
  TotalFrameAudio := 0;
  TotalFrameVideo := 0;
  TotalBytesAudio := 0;
  TotalBytesVideo := 0;
end;

procedure tth_cp.RebuildAvi;

 procedure error(const errorStr: string);
 begin
  FreeHandleStream(writer);
  if idxStream<>nil then FreeHandleStream(idxStream);
 end;

var
 str: string;
 sizeC: Cardinal;
 i: Integer;
 estimatedRIFFSize: Cardinal;

begin
synchronize(generating_preview);

sizeDownChunk := helper_ich.ICH_calc_chunk_size(DisplayedSize);

positionStreamVideoHeader := 0;
positionStreamAudioHeader := 0;
positionAviHeader := 0;


 idxStream := nil;

 writer := MyFileOpen(dests,ARES_OVERWRITE_EXISTING);
 if writer<>nil then begin
  clearAviStats;

  // start reading source file, get size of headerlist so that we can skip it more efficiently
  reader.seek(16,soFromBeginning);
  reader.read(SizeAviHeaderLists,4);


  SetLength(str,4);
  reader.read(str[1],4);
  if str<>'hdrl' then begin  // read AVI header first
   error('AVIHeader List field missing');
   exit;
  end;
  reader.read(str[1],4);
  if str<>'avih' then begin // avi header field should be right here
   error('AVIHeader field missing');
   exit;
  end;
  reader.read(SizeC,4);
  if sizeC<>56 then begin  // expected size of AVIHeader is 56 bytes
   error('AVIHeader size mismatch:'+inttostr(sizeC));
   exit;
  end;

  // get AVI header, we need to extract number of streams out of it
  positionAviHeader := reader.position;   // keep track of correct position, this would be modified in destination file to reflect previewed file's condition
  reader.read(aviH,56);



  // parse streams headerS  (video and audio, we need them in order to update frame count)
  for i := 1 to avih.dwStreams do begin

    while true do begin  // search for a 'LIST' field
     SetLength(str,4);
     reader.read(str[1],4);
     reader.read(SizeC,4);

     if str='strn' then begin
      if (sizeC mod 2)=1 then inc(sizeC);
       reader.position := reader.position+sizeC;
       continue;
     end;
      if str='strd' then begin
      if (sizeC mod 2)=1 then inc(sizeC);
      reader.position := reader.position+sizeC;
      continue;
     end;
     if str='JUNK' then begin
      if (sizeC mod 2)=1 then inc(sizeC);
      reader.position := reader.position+sizeC;
      continue;
     end;
     if str='indx' then begin
      if (sizeC mod 2)=1 then inc(sizeC);
      reader.position := reader.position+sizeC;
      continue;
     end;


     if str<>'LIST' then begin
      error('Stream '+inttostr(i-1)+' Header LIST not found... found:'+str);
      exit;
     end;

     break;  // found list!
    end;
 
    SetLength(str,4);
    reader.read(str[1],4);
    if str<>'strl' then begin // it should be a strl LIST
     error('Expecting ''strl'' lists of stream headers for each stream');
     exit;
    end;

    ParseAviHeaderList(i-1,SizeC-4);
  end;


  // fast seeking to the end of aviheaderlist
  reader.position := 20+SizeAviHeaderLists;


  // now look for the beginning of 'movi' data chunk
  while true do begin

   SetLength(str,4);
   reader.read(str[1],4);
   reader.read(SizeC,4);

   if (sizeC mod 2)=1 then inc(SizeC);

   if str='strn' then begin
    reader.position := reader.position+SizeC;
    continue;
   end;
   if str='JUNK' then begin
    reader.position := reader.position+SizeC;
    continue;
   end;
   if str<>'LIST' then begin
    error('expecting LIST not found');
    exit;
   end;

   SetLength(str,4);
   reader.read(str[1],4);

   if str='INFO' then begin
    reader.position := reader.position+(SizeC-4);
    continue;
   end;
   if str='odml' then begin
    reader.position := reader.position+(SizeC-4);
    continue;
   end;

   if str='movi' then begin

    MoviBlockPosition := reader.position;
    MoviBlockSize := sizeC-4;

    reader.seek(0,soFromBeginning);
    writer.seek(0,soFromBeginning);
   copyBlock(reader,writer,MoviBlockPosition);   // copy whole header to destination file (till 'movi' inclusive)
    reader.seek(MoviBlockPosition+MoviBlockSize,soFromBeginning);

   break;   //Found movi block
 end;

  reader.position := reader.position+(SizeC-4);

  if reader.position>100000 then begin
   error('couldn''t find movi block in the first 100k of file');
   exit;
  end;

 end;


 if not RebuildAviUsingIDX1 then RebuildAviUsingHeuristic;

 // now perform final update on our rebuilt idx and copy this chunk at the end of destination file
 idxStream.seek(4,soFromBeginning);
  sizeC := TotalAviFrameDone*16;
  idxStream.write(sizeC,4);
 idxStream.seek(0,soFromBeginning);
 writer.seek(writer.size,soFromBeginning);
  copyBlock(idxStream,writer,idxStream.size);
 FreeHandleStream(IdxStream);


 // write updated RIFF size
 estimatedRIFFSize := writer.Size-8;
 writer.seek(4,soFromBeginning);
 writer.write(estimatedRIFFSize,4);


 //update AVI frame header with the correct amount of frames found
 if positionAviHeader>0 then begin
  writer.seek(positionAviHeader,soFromBeginning);
  aviH.dwTotalFrames := TotalFrameVideo;
  writer.write(aviH,56);
 end;

 //update num of video frames
 if positionStreamVideoHeader>0 then begin
  writer.seek(positionStreamVideoHeader,soFromBeginning);
  avishV.dwLength := TotalFrameVideo;
  writer.write(avishV,48);
 end;

 //update num of audio frames
 if positionStreamAudioHeader>0 then begin
  writer.seek(positionStreamAudioHeader,soFromBeginning);
  if avishA.dwscale=1 then avishA.dwLength := TotalBytesAudio
   else avishA.dwLength := TotalFrameAudio;    //TODO /
  writer.write(avishA,48);
 end;

 //update size of movi block
 writer.seek(MoviBlockPosition-8,soFromBeginning);
 sizeC := estimatedMovieBlockSize;
 writer.write(sizeC,4);

 FreeHandleStream(Writer);
end;
FreeHandleStream(Reader);
end;

procedure tth_cp.RebuildAviUsingHeuristic;

var
 lenToRead,offsetRead,bytesRead,i,h,posScan: Integer;
 bufferSeek: array [0..1031] of Byte;  //1024+8 bytes
 emptyBuffer: array [0..63] of Byte;
 found: Boolean;
 posRecBlock: Integer;
 recName,str: string;
 recSize,dummyValue: Cardinal;
begin

 //now parse source's IDX1 and rebuild avi
 // how many frame we found
 TotalAviFrameDone := 0;
 // we should already have the first 4 bytes written to destination file containing 'movi'
 estimatedMovieBlockSize := 4;

 // create a temporary file to store idx1 we're about to create
 IdxStream := myfileOpen(dests+'.idx',ARES_OVERWRITE_EXISTING);

 str := 'idx1';
 dummyValue := 0;
 IdxStream.write(str[1],4);
 IdxStream.write(dummyValue,4);  // this is going to be overwritten at the end of this cycle


 // move cursor to the beginning of movi 
Reader.seek(MoviBlockPosition,soFromBeginning);
offsetRead := MoviBlockPosition;
for i := 0 to 63 do emptyBuffer[i] := 0;
h := 0;
i := 0;

while (offsetRead<MoviBlockPosition+MoviBlockSize) do begin



      // after first chunk we try to make things a little faster by scanning only chunks we certainly have (ICH verified)
      if offsetRead>=sizeDownChunk then
       if not HasOffsetOnDisk(offSetRead,10,sizeDownChunk) then begin
               while (not HasOffsetOnDisk(offSetRead,1024,sizeDownChunk)) do begin // seek memory not disk...
                inc(offSetRead,sizeDownChunk);
                if offsetRead>displayedSize then break;  // endoffile reached
              end;
              reader.seek(offsetRead,soFromBeginning);
      end;


   lenToRead := sizeof(bufferSeek)-8;
   if lenToRead+offsetRead>MoviBlockPosition+MoviBlockSize then lenToRead := (MoviBlockPosition+MoviBlockSize)-offsetRead;

   if offsetRead>=displayedSize then break;

   bytesRead := Reader.read(bufferSeek,lenToRead);



   posScan := 0;
   found := False;
   while posScan+64<=bytesRead do begin

     if bufferSeek[posScan]<>48 then begin
      if compareMem(@bufferSeek[posScan],@emptyBuffer,64) then begin  // empty block
       inc(posScan,64);
      end else inc(posScan);
     continue;
     end;

      for i := posScan to bytesRead-1 do begin // search for character '0' (beginning of a rec block)

        if bufferSeek[i]<>48 then continue;  //01dc  00db 01wb , ecc
        if ((bufferSeek[i+1]<>48) and (bufferSeek[i+1]<>49)) then continue;

         if chr(bufferSeek[i+2])+chr(bufferSeek[i+3])<>'wb' then
          if chr(bufferSeek[i+2])+chr(bufferSeek[i+3])<>'db' then
           if chr(bufferSeek[i+2])+chr(bufferSeek[i+3])<>'dc' then continue;

            move(bufferSeek[i+4],dummyValue,4);
            if dummyValue>MEGABYTE then begin
             continue;
            end;
        found := True;
        break;
      end;

      if found then break;
      inc(posScan,64);
   end;

   if found then begin
    posRecBlock := offsetRead+i;
    reader.seek(posRecBlock,soFromBeginning);

    SetLength(recName,4);
    reader.Read(recName[1],4);
    reader.Read(recSize,4);

     if HasOffsetOnDisk(posRecBlock,recSize+8,sizeDownChunk) then begin
      copyAviDataChunk(recName,0,(offsetRead+i)-(MoviBlockPosition-4),recSize,true{check flags as we don't have genuine idx1});
     end;

     if (recSize mod 2)=1 then inc(offSetRead,recSize+9+i)
      else inc(offSetRead,recSize+8+i);
    reader.seek(offsetRead,soFromBeginning);

   end else inc(OffsetRead,bytesRead); // non contiguos let's break here



     inc(h);
     if (h mod 20)=0 then begin
      DisplayedProgress := offSetRead;
      synchronize(Display_progress);
      if terminated then break;
      if should_stop then break;
      sleep(5);
     end;

end;

end;

function tth_cp.RebuildAviUsingIDX1: Boolean;

var
 str,recName,chunkname: string;
 read,positionBefore,i: Integer;
 buffer16: array [0..15] of Byte;
 chunkflags,chunkOffset,chunksize: Cardinal;
 offSetPiece: Cardinal;
 RelativeOffset: Cardinal;
 isFirstFrame: Boolean;
begin
result := False;
 // now look for source file's IDX1 which should be at the end of 'movi' block
 SetLength(str,4);
 sizeIdx1 := 0;
 reader.read(str[1],4);
 reader.read(sizeIdx1,4);
 if ((str<>'idx1') or (sizeIdx1=0)) then begin // if we don't have idx1 we can try cpu intensive euristic rebuild

  exit;
 end;

 posIDX1 := reader.position;

 reader.seek(posIDX1+sizeIdx1,soFromBeginning);   // do we have whole segment, usually we should have JUNK at the end of avi?
 SetLength(str,4);
 reader.read(str[1],4);
 recName := copy(str,3,2);
 if recName<>'wb' then   // some IDX1 may have wrong sizeIdx1
  if recName<>'dc' then
   if recName<>'db' then
    if str<>'JUNK' then
     if str<>'LIST' then
      if str<>'___A'{'___ARESTRA__3'} then begin

       exit;
      end;


      //TODO check ICH chunks to exclude possibility we don't have parts within beginning and end of idx1!!!
 for i := high(bitfield) downto 0 do begin
   if not bitfield[i] then begin

    exit;
   end;
   offSetPiece := i*sizeDownChunk;
   if offsetPiece<posIDX1 then break; // we have full idx block
 end;


      
 while reader.position<>posIDX1 do reader.position := posIDX1; // return to IDX1 position

 //now parse source's IDX1 and rebuild avi
 // how many frame we found
 TotalAviFrameDone := 0;
 // we should already have the first 4 bytes written to destination file containing 'movi'
 estimatedMovieBlockSize := 4;

 // create a temporary file to store idx1 we're about to create
 IdxStream := myfileOpen(dests+'.idx',ARES_OVERWRITE_EXISTING);
 str := 'idx1';
 IdxStream.write(str[1],4);
 IdxStream.write(sizeIdx1,4);

 // allocate 4 bytes here
 SetLength(chunkname,4);


 // read original file's idx1, extract frames data out of it and check file for those frames
 // if found copy frames and update our temporary idx1 accordingly
 // number of bytes we have processed in source file's IDX1
 read := 0;
 RelativeOffset := 0;
 isFirstFrame := True;
 positionBefore := reader.position+16;
 i := 0;
 repeat
  reader.read(buffer16,16);

  move(buffer16,chunkname[1],4);
  move(buffer16[4],chunkflags,4);
  move(buffer16[8],chunkOffset,4);
  move(buffer16[12],chunksize,4);

  if isFirstFrame then begin
    isFirstFrame := False;
    if MoviBlockPosition=chunkOffset then RelativeOffset := (MoviBlockPosition-4);
  end;

  if ((chunkOffset<4) or (chunkSize=0)) then begin  // it may be a null piece of idx1
   inc(positionBefore,16);
   inc(read,16);
   if ((read+16>sizeIdx1) or
      (reader.position>=reader.Size)) then break;
      if should_stop then break;
   continue;
  end;

  if HasOffsetOnDisk(chunkOffset+((MoviBlockPosition-4)-RelativeOffset),chunkSize,sizeDownChunk) then begin
    copyAviDataChunk(chunkname,chunkflags,chunkOffset-RelativeOffset,chunkSize);
    reader.seek(positionBefore,soFromBeginning);  // restore cursor position to source's idx1
  end;

  inc(positionBefore,16);
  inc(read,16);


     displayedProgress := chunkOffset;
     inc(i);
     if (i mod 1000)=0 then begin
      synchronize(Display_progress);
      if terminated then break;
      if should_stop then break;
      sleep(1);
     end;

 until ((read+16>sizeIdx1) or
        (reader.position>=reader.Size));

result := True;

 if not should_stop then
  if reader.position>=reader.Size then begin

   exit;
  end;


end;

function tth_cp.HasOffsetOnDisk(offset: Cardinal; wantedSize: Integer; sizeChunks: Cardinal): Boolean;
var
indexChunk,checkValue: Integer;
begin
result := False;

indexChunk := offset div sizeChunks;
if indexChunk>high(bitfield) then begin
 exit;
end;
if not bitfield[indexChunk] then exit;

checkValue := (offset+(wantedSize-1)) div sizeChunks;

if checkValue=indexChunk+1 then begin

 if checkValue>high(bitfield) then begin
  exit;
 end;
 Result := bitfield[checkValue];

end else Result := True;
end;


procedure tth_cp.copyAviDataChunk(const chunkname: string; chunkflags,chunkOffset,chunkSize: Cardinal; checkFlags:boolean=false);

Const
  KeyFrame:Longint=16;
  NormFrame:Longint=0;
  NullString4=CHRNULL+CHRNULL+CHRNULL+CHRNULL;
var
 str,chunkTypeStr: string;
 isVideo: Boolean;
 sizeC,
 offsetNew,keyType,FrameType: Cardinal;
 buffer: array [0..1] of char;
begin
// move sourcefile cursor to expected position
reader.seek(chunkOffset+(MoviBlockPosition-4),soFromBeginning);

// read frame data name and compare it to what we expect to see (according to original file's IDX1)
SetLength(str,4);
reader.read(str[1],4);

if str<>chunkName then
 if str<>NullString4 then begin  // we don't have this chunk it shoudl be 0x00000000
 exit;
end;

// do the same with expected size
reader.read(sizeC,4);
if sizeC<>chunkSize then begin
 exit;
end;

chunkTypeStr := copy(chunkname,3,2);
if ((chunkTypeStr='dc') or (chunkTypeStr='db')) then begin  //video
 if checkFlags then begin
  reader.read(KeyType,4);
  reader.Read(FrameType,4);
 end;
 isVideo := True;
end else
if chunkTypeStr='wb' then isVideo := false
else begin  // JUNK?
 exit;
end;


// move file source's cursor to current expected block position
reader.seek(chunkOffset+(MoviBlockPosition-4),soFromBeginning);

// move pointer in destination file to its endof file
writer.seek(writer.size,soFromBeginning);

// calculate offset of the block we're about to copy (relative to our 'movi')
offsetNew := writer.position-(MoviBlockPosition-4);

// copy frame data to our destination target file
copyBlock(reader,writer,SizeC+8);



// update our IDX1
IdxStream.write(chunkname[1],4);
if checkFlags then begin
   If (not isVideo) Or
      ((  ((KeyType<>65536) and (FrameType and 64=0)) or ((KeyType=65536) and (FrameType=65536)) )   and (SizeC>0)) then IdxStream.Write(KeyFrame,4)
     else IdxStream.Write(NormFrame,4);  // is it a 'valid' frame?
end else IdxStream.write(chunkFlags,4);

//IdxStream.write(chunkFlags,4);

IdxStream.write(offsetNew,4);  // updated to our values
IdxStream.write(chunkSize,4);

// update stats
if not IsVideo then begin
 inc(TotalFrameAudio);
 inc(TotalBytesAudio,chunksize);
end else begin
 inc(TotalFrameVideo);
 inc(TotalBytesVideo,chunksize);
end;

// eventually add a parity byte
if (SizeC mod 2)=1 then begin
 writer.write(buffer,1);
 inc(SizeC);
end;

// final touch on stats
 inc(estimatedMovieBlockSize,SizeC+8);
 inc(TotalAviFrameDone);
end;

procedure copyBlock(StreamIn: THandleStream; StreamOut: ThandleStream; SizeC: Cardinal);
var
buffer: array [0..1023] of char;
len,len_read,copied: Integer;
begin
copied := 0;

while (copied<sizeC) do begin
  len := sizeC-copied;
  if len>sizeof(buffer) then len := sizeof(buffer);

  len_read := StreamIn.read(buffer,len);
  if len_read>0 then StreamOut.write(buffer,len_read) else break;

  inc(copied,len_read);
  if len_read<>len then begin
   break;
  end;
end;

end;

procedure tth_cp.ParseAviHeaderList(StreamId: Integer; SizeTotal: Cardinal);
var
 str: string;
 sizeC: Cardinal;

 btmh:BITMAPINFOHEADER;
 wfm:WAVEFORMATEX;
 
headerType: string;
isVideo: Boolean;
begin
isVideo := True;

SetLength(headerType,4);
reader.read(headerType[1],4);
reader.Read(sizeC,4);

if headerType='strh' then begin

  if streamID=0 then begin
   positionStreamVideoHeader := reader.position;
   reader.read(avishV,48);
   isVideo := True;
  end else begin
   isVideo := False;
    positionStreamAudioHeader := reader.position;
    reader.read(avishA,48);
   end;

   reader.position := reader.position+(sizeC-48);

end;


 SetLength(str,4);
 reader.read(str[1],4);
 reader.Read(sizeC,4);

 if str='strf' then begin  // next field should be header format

 if isVideo then begin  // if it's a video this should be a bitmapinfoheader
    reader.read(btmh,sizeof(BITMAPINFOHEADER));
    // unfortunately we can have wrong lengths here...
    if sizeC>sizeof(BITMAPINFOHEADER) then reader.position := reader.position+(sizeC-sizeof(BITMAPINFOHEADER))
     else
    if sizeC<sizeof(BITMAPINFOHEADER) then reader.position := reader.position-(sizeof(BITMAPINFOHEADER)-sizeC)
  end else begin
    reader.read(wfm,sizeof(WAVEFORMATEX));
    // unfortunately we can have wrong lengths here...
    if sizeC>sizeof(WAVEFORMATEX) then reader.position := reader.position+(sizeC-sizeof(WAVEFORMATEX))
     else
    if sizeC<sizeof(WAVEFORMATEX) then reader.position := reader.position-(sizeof(WAVEFORMATEX)-sizeC);
  end;

end;


end;


procedure tth_cp.execute;
begin
freeonterminate := True;
priority := tplower;

reader := MyFileOpen(sources,ARES_READONLY_ACCESS);
if reader=nil then begin
 terminate;
 exit;
end;
IsAviFile := CheckIsAviFile(reader);


 should_stop := False;

try
 DisplayedSize := gethugefilesize(sources)-(4*KBYTE);
 DisplayedProgress := 0;

 synchronize(open_form);

 if length(bitfield)=0 then begin

  copy_whole_File;
  FreeHandleStream(Reader);

  if isAviFile then preview_avi(dests);

 end else begin

     if IsAviFile then RebuildAvi
      else begin
       copy_downloaded_chunks;
      // copy_whole_File;
       FreeHandleStream(Reader);
      end;

  end;
  

 gethugefilesize(dests); //assegnia time

 synchronize(close_form);

 if terminated then exit;

  synchronize(preview_start);
  postmessage(formhandle,WM_PREVIEW_START,0,0);

except
end;
end;

procedure tth_cp.close_form;
begin
frmpreview.release;
end;



procedure SkipJunkFrame(input: TStream; StreamStart: Cardinal; var Position: Cardinal);
var
 sizeC: Cardinal;
begin
 input.Read(SizeC,4);
 Position := Position+SizeC+8;
 input.Seek(StreamStart+Position,sofrombeginning);
end;

function GetStreamStart(input: THandleStream; var StreamStart: Cardinal; var StreamSize: Cardinal): Boolean;
var
 ChunkName: string;
 sizeC: Cardinal;
 position: Int64;
begin
result := False;

SetLength(chunkName,4);
sizeC := 0;
position := 16;

Repeat
 if input.position>=input.size then exit;
 Position := Position+SizeC;
 input.Seek(Position,sofrombeginning);
 input.Read(SizeC,4);
 Input.read(Chunkname[1],4);
 Inc(Position,8);
Until (Chunkname='movi');

 StreamStart := Position-4;  // position of 'movi'
 StreamSize := sizeC;       // length of data chunk

result := True;
end;

procedure CheckAviHeader(download: TDownload);
begin

if not CheckIsAviFile(download.stream) then begin
 download.AviHeaderState := aviStateNotAvi;
 exit;
end else download.AviHeaderState := aviStateIsAvi;

GetEndOfMoviBlock(download);
end;

function AviHasIndexInFlags(Flags: Cardinal): Boolean;
const
 AVIF_HASINDEX=$00000010;
begin
result := False;
result := ((flags and AVIF_HASINDEX)>0);
end;

function AviIsInterleavedInFlags(Flags: Cardinal): Boolean;
const
 AVIF_ISINTERLEAVED = $00000100;
begin
result := False;
result := ((flags and AVIF_ISINTERLEAVED)>0);
end;

procedure GetEndofMoviBlock(download: TDownload);
var
sizeC: Cardinal;
fileS: Cardinal;
flags: Cardinal;
str: string;
begin
//RIFF+ xxxx + AVI LIST + xxxx
download.stream.seek(4,soFromBeginning);
download.stream.read(fileS,4);

download.stream.seek(16,soFromBeginning); // read hearlist length
download.stream.read(SizeC,4);

download.stream.seek(44,soFromBeginning);
download.stream.read(flags,4);
if not AviHasIndexInFlags(flags) then begin
 exit;
end;

 download.stream.seek(SizeC+20,soFromBeginning);

SetLength(str,4);
while (true) do begin

 download.stream.read(str[1],4);  // 'LIST + xxxx + movi'
 download.stream.read(sizeC,4);

 if (sizeC mod 2)=1 then begin
  inc(sizeC);
 end;

 if str='JUNK' then begin
  download.stream.position := download.stream.position+sizeC;
  continue;
 end;
 if str='strn' then begin
  download.stream.position := download.stream.position+sizeC;
  continue;
 end;

 if str<>'LIST' then begin
  download.stream.position := download.stream.position+SizeC;
  continue;
 end;

 download.stream.read(str[1],4);

 if str='odml' then begin
   download.stream.position := (download.stream.position+SizeC)-4;
   continue;
 end;
 if str='INFO' then begin
   download.stream.position := (download.stream.position+SizeC)-4;
   continue;
 end;

 if str='movi' then begin  // could be 'INFO'
  break;
 end;


 download.stream.position := download.stream.position+(SizeC-4);
 if download.stream.position>100000 then begin
  exit;
 end;

end;


download.AviIDX1At := download.stream.position+(sizeC-4);  //idx1 + xxxx
end;

function CheckIsAviFile(input: THandleStream): Boolean;
var
str: string;
begin               // 'RIFFxxxxAVI LIST'
result := False;

 SetLength(str,4);
 input.Seek(0,sofrombeginning);
 if input.Read(str[1],4)<>4 then exit;
 if str<>'RIFF' then begin
 exit;
 end;

 SetLength(str,8);

 input.Seek(8,sofrombeginning);
 if input.Read(str[1],8)<>8 then exit;

 If str<>'AVI LIST' Then begin
  exit;
 end;

 Result := True;
end;

procedure SkipListHeader(input: THandleStream; var position: Cardinal);
begin
 input.Seek(Input.position+8,sofrombeginning);
 Inc(Position,12);
end;

function tth_cp.preview_avi(source: WideString): WideString;

const
 MAX_AVI_SIZE=2147483648; // 2 giga

Var
 Input: Thandlestream;
 Output: Thandlestream;
 i,j,hz:	cardinal;
 Position:	cardinal;
 StreamStart:	cardinal;
 StreamSize:	cardinal;
 VideoFrameCount:	cardinal;
 LastInputPosition:	cardinal;
 LastIndexPosition:	cardinal;
 isInterleaved: Boolean;
 Text2:	String[2];
 Chunkname:	String;
 Temp: cardinal;
 FrameType:	cardinal;
 KeyType:	cardinal;
 Buffer:	Array [0..32800] Of Byte;
 k	:	Cardinal;
 sizeC: Cardinal;
 Empty_String: string;
Label BError;
Label BStartRead;

Const
  KeyFrame:	Longint = 16;
  NormFrame :	Longint = 0;
  Number  :	Set of char =['0'..'9'];
begin
result := '';

synchronize(generating_preview);

DisplayedProgress := 0;
hz := 0;
synchronize(Display_progress);
try

 Empty_String := CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+
               CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL;

 Input := MyFileOpen(source,ARES_WRITE_EXISTING);
 if input=nil then exit;

  if not CheckIsAviFile(input) then begin
   FreeHandleStream(input);
   exit;
  end;

  output := MyFileOpen(extract_fpathW(source)+'\tmp',ARES_OVERWRITE_EXISTING);
  if output=nil then begin
   FreeHandleStream(Input);
   Exit;
  End;


  if not GetStreamStart(input,StreamStart,StreamSize) then begin
   FreeHandleStream(input);
   FreeHandleStream(output);
   exit;
  end;

  // the purpose of this procedure is to prepare an idx1 chunk (a table of memory offsets to each chunk within the 'movi' list)
  // write idx1 at the start of output stream, at the end of file scan this data will be added to input stream
	   Chunkname := 'idx1';
     output.Write(Chunkname[1],4);
     SizeC := StreamSize;
	   Output.write(SizeC,4);


     LastIndexPosition := Output.position;

	   Position := 4;
     i := 0;
	   VideoFrameCount := 0;
     //Difference := 0;
	   isInterleaved := False;


repeat
input.Seek(StreamStart+Position,sofrombeginning);

	BStartRead:If Input.position<=input.size then begin

                DisplayedProgress := position;
                inc(hz);
                if (hz mod 40)=0 then begin
                 synchronize(Display_progress);
                 if terminated then break;
                end;

                 if length(ChunkName)<>4 then SetLength(Chunkname,4);
                 temp := input.Read(Chunkname[1],4); // get next four bytes into chunkname

    	           if ChunkName='LIST' then begin
                  SkipListHeader(input,position);
    	            goto BStartRead;
                 end;
	               if ChunkName='JUNK' then begin
                   SkipJunkFrame(input,StreamStart,position);
		               goto BStartRead;
                 end;

    	           Text2 := Copy(ChunkName,3,2);
      	         if (Copy(ChunkName,1,2)='ix') Or
                    (Text2='ix') then begin
  	                Inc(Position,16);
    	  	          input.Seek(StreamStart+Position,sofrombeginning);
      	            isInterleaved := True;
        	         goto BStartRead;
		             end;


  	            if Input.position<=input.size then begin


      		        if ((ChunkName[1] In Number) and
                      (ChunkName[2] In Number)) and
                       ((Text2='dc'{compressed video data}) or
                        (Text2='db'{dib/compressed video}) or  // we found aduo/video data
                        (Text2='wb'{audio data})) then begin   // eg. 01dc or 01db or 01wb  A 'rec ' list (a record) contains the audio and video data for a single frame.

  	      	             if (Text2='dc') Or (Text2='db') then begin
                          if VideoFrameCount=0 then begin
              	           Input.read(SizeC,4);
               	           input.Read(KeyType,4);
                           input.Seek(Input.position-8,sofrombeginning);
                          end;
            	            Inc(VideoFrameCount); //keep track of total video frame #
                         end;

    	                   if isInterleaved then begin
        	                input.Seek(Input.position-16,sofrombeginning);
          	              Dec(Position,16);
            	            isInterleaved := False;
                         end;

	                       temp := input.Read(SizeC,4);

    	                    if (SizeC>MAX_AVI_SIZE) And (Temp=4) then begin  // can't be over 2 giga...
                           Inc(Position,4);
  	                       input.Seek(StreamStart+Position,sofrombeginning);

                           SetLength(ChunkName,4);
    	                     temp := input.Read(Chunkname[1],4);
      	                    if ChunkName='LIST' then begin
                             SkipListHeader(input,position);
                             goto BStartRead;
	                          end;
  	                        if ChunkName='JUNK' then begin
                             SkipJunkFrame(input,StreamStart,position);
                             goto BStartRead;
                            end;

  	                        input.Seek(StreamStart+Position,sofrombeginning);
    	                      goto BError;
                          end;


		                     if Input.position>=input.size then begin
                          break;
                         end;

          		           LastInputPosition := Input.position-4;
                         input.Read(FrameType,4);
                          j := (((Position+SizeC) Div 2)+((Position+SizeC) Mod 2))*2+8;
                        input.Seek(StreamStart+j-1,sofrombeginning);

		                    if Input.position>=input.size then begin
                          break;
                        end;

          	  	        LastIndexPosition := Output.position;
                        output.Write(Chunkname[1],4);
              	        Text2 := Copy(ChunkName,3,2);

		                   If ((Text2='dc') or
                           (Text2='db') or
                           (Text2='wb')) and
                           ((Chunkname[1] in Number) and (ChunkName[2] in Number)) then
      	                   If (Text2='wb') Or
                              ((((KeyType<>65536) and
                              (FrameType and 64=0)) or ((KeyType=65536) and
                              (FrameType=65536))) and (SizeC>0)) then output.Write(KeyFrame,4)
                                                                else output.Write(NormFrame,4);  // is it a 'valid' frame?

  	            	           // j := Position{-Difference};
    	          	            output.Write(Position,4);
			                        output.Write(SizeC,4);
            	                j := Position;
	 		                        Position := (((Position+SizeC) div 2)+((Position+SizeC) mod 2))*2+8;
	                           input.Seek(StreamStart+j,sofrombeginning);
                            Inc(i);

                            
      end else begin

    	    	BError:If Chunkname<>'idx1'{'idx1' (4 byte chunk size) (index data)...an optional index into movie (a chunk)} then begin
                                       {The optional index contains a table of memory offsets to each chunk within the 'movi' list.}
                                       { The 'idx1' index supports rapid seeking to frames within the video file.}
	          	        //Str(VideoFrameCount,Text);
  		               if Output.position>16 then output.Seek(Output.position-16,sofrombeginning);
        	            //Str(StreamStart+Position,Text);
    	                output.Seek(LastIndexPosition,sofrombeginning);
    	                j := Position;

      		              repeat
                          input.Seek(StreamStart+Position,sofrombeginning);
          		                if Input.position<=input.size then begin
	      	  		               temp := input.Read(Buffer[1],32768);
                	             k := 1;   // we didn't find a valid frame so search file till we found something
		                           repeat

                                  if k+64<32768 then
                                  if CompareMem(@buffer[k],@Empty_String[1],64) then begin
                                   inc(k,64);
                                   continue;
                                  end;

			                            if ((Chr(Buffer[k])='d') or
                                      (Chr(Buffer[k])='w')) then Begin
 		  		                             if ((Chr(Buffer[k+1])='c') Or
                                           (Chr(Buffer[k+1])='b')) then begin
      	  		        	                 input.Seek(StreamStart+Position+k-3,sofrombeginning);
 	      	  		                          If Input.position<=input.size then begin
                                           if length(ChunkName)<>4 then SetLength(ChunkName,4);
                                           input.Read(ChunkName[1],4);
                                          end;
   	      	  		                     end;
     	      	  		              end;
		  	                          Inc(k);
	                                Text2 := Copy(ChunkName,3,2);
                                  if (k mod 9000)=0 then sleep(5);
			                          until (((Text2='dc') or (Text2='db') or (Text2='wb')) and
                                       ((ChunkName[1] in Number) and (ChunkName[2] In Number))) or
                                        (Chunkname='idx1') or
                                        (k>32768);

        	                    Inc(Position,k-3);
	  	    	                  end;
      	                    Text2 := Copy(ChunkName,3,2);
                            sleep(5);  // this loop is pretty much cpu intensive...
    	  	               until (((Text2='dc') or (Text2='db') or (Text2='wb')) and
                                ((ChunkName[1] in Number) and (ChunkName[2] in Number))) or
                                 (Chunkname='idx1') or
                                 (Input.position>=input.size);


	         	             if Input.position<=input.size then Dec(Position);
        	         end else begin    //we found file's idx1 segment
  	        	        input.Seek(Input.position+6,sofrombeginning);
    	                SetLength(ChunkName,2);
      	              input.Read(ChunkName[1],2);
        	            input.Seek(Input.position-8,sofrombeginning);
          	         if (ChunkName='dc') or
                        (ChunkName='wb') or
                        (ChunkName='db') then begin // yes it contains data!
  	                    ChunkName := 'idx1';
    	                end else begin
            	         ChunkName := '0000';
              	       goto BError;
	                    end;
  	               end;


    	 end;

     end;

	 end;

until (Input.position>=input.size) or
      (ChunkName='idx1');



    if i=0 then begin // we didn't find any valid frame!
      FreeHandleStream(Input);
      FreeHandleStream(Output);
      helper_diskio.deletefileW(extract_fpathW(source)+'\tmp');  // free temp file
      exit;
    end;


	 	SizeC := i*16;  // how many referenced data blocks we have (each of them is 16 bytes long)
    output.Seek(4,sofrombeginning);  // write size of RIFF
    output.Write(SizeC,4);


  		if ChunkName='idx1' then StreamSize := Input.position-StreamStart-4
	     else StreamSize := Input.size-StreamStart;

		  input.Seek(StreamStart-4,sofrombeginning);
 			input.Write(StreamSize,4); // 'LISTxxxxmovi' stream size, correct size of 'movi' data block


		  input.Seek(StreamStart+StreamSize,sofrombeginning);  // move to the end of 'movi' data
  	  if (StreamStart+StreamSize) mod 2=1 then begin       // add a null byte if StreamSize is odd
    		Buffer[0] := 0;
	    	input.Write(Buffer,1);
  	  end;


 		  output.Seek(0,sofrombeginning);  // copy the whole reconstructed idx1 chunk at the end of 'LISTxxxxmovi' chunk

      DisplayedProgress := 0; //displayed progress
      hz := 0;

		  repeat
 		    temp := output.Read(Buffer,32768);
        input.Write(Buffer,Temp);

        DisplayedProgress := DisplayedProgress+temp;
        inc(hz);
        if (hz mod 9)=0 then begin
        synchronize(Display_progress);
        if terminated then break;
        end;
      until Not(Temp=32768);

      //correct RIFFxxxxAVI LIST whole file size
      sizeC := input.size-4;
      input.Seek(4,soFromBeginning);
      input.write(sizeC,4);

      FreeHandleStream(Input);
      FreeHandleStream(Output);


	  	helper_diskio.deletefileW(extract_fpathW(source)+'\tmp');  // free temp file

      Result := source;

except
end;
end;

procedure tth_cp.preview_start; //synchronize
begin
vars_global.file_visione_da_copiatore := dests;
end;

end.
