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
main bittorrent classes
}

unit btcore;

interface

uses
  Classes, Classes2, Windows, SysUtils, Torrentparser, CometTrees,
  Winsock, BDecode, Hashes, BlckSock, Contnrs, ares_objects, StrUtils,
  tntsysutils;

const
  NO_ERROR = 0;
  ERROR_OFFSET_OUTOFRANGE = 1;
  ERROR_READ_BEYONDLIMIT = 2;
  ERROR_WRITE_BEYONDLIMIT = 3;
  ERROR_STREAM_LOCKED = 4;

type
  TBitTorrentTrackerStatus=(
    bttrackerUDPConnecting,
    bttrackerUDPReceiving,
    bttrackerConnecting,
    bttrackerreceiving
  );

  TBitTorrentTracker = class(TObject)
  public
    host: string;
    port: Word;
    URL: string;
    visualStr: string;
    FError: string;
    BufferReceive: string;
    Interval,
    Next_Poll: Cardinal;
    ipC: Cardinal;
    portW: Word;
    TrackerID,WarningMessage: string;
    Leechers: Cardinal;
    Seeders: Cardinal;
    Status: TBitTorrentTrackerStatus;
    socket: Ttcpblocksocket;
    socketUDP:hsocket;
    isudp: Boolean;
    UDPtranscationID: Cardinal;
    UDPconnectionID: Int64;
    UDPevent: Cardinal;
    UDPKey: Cardinal;
    tick: Cardinal;
    alreadyStarted,alreadyCompleted: Boolean;
    download: Pointer;
    CurrTrackerEvent: string;
    isScraping: Boolean;
    constructor Create();
    destructor Destroy(); override;
    function Load(Stream: TStream): Boolean;
    function ParseScrape(stream: TStream): Boolean;
    function SupportScrape: Boolean;
  end;

  TBitTorrentFile = class(TObject)
    FOffset: Int64;
    FSize: Int64;
    FStream: THandleStream;
    FFilename: string;
    FProgress: Int64;
    FOwner: TObject;
    Modify_date: Cardinal;
    constructor create(const rootpath: string; const fname: string; offset: Int64; size: Int64;
     lowner: TObject; allowCreate: Boolean; themodify_time: Cardinal);
    destructor destroy; override;
    procedure erase;
    procedure FillZeros;
    procedure update_modify_date;
    procedure read(offsetRead: Int64; destination: Pointer; len: Int64; var bytesProcessed: Int64);
    procedure write(offsetWrite: Int64; source: Pointer; len: Int64; var bytesProcessed: Int64);
  end;


  TBittorrentBitField = class(TObject)
    bits: array of Boolean;
    constructor Create(ItemsCount:integer);
    procedure InitWithBitField(const bitstring: string);
    destructor Destroy; override;
  end;


  TBitTorrentChunk = class(TObject)
    Checked,
    downloadable,
    preview: Boolean;
    priority: Byte;
    pieces: array of Boolean;
    CheckSum: array [0..19] of Byte;
    FOwner: TObject;
    FOffset: Int64;
    FSize: Cardinal;
    popularity: Word;
    findex: Cardinal;
    FProgress: Cardinal;
    assignedSource: Pointer;
    constructor create(owner: TObject; offset: Int64; size: Int64; index: Cardinal);
    destructor destroy; override;
    procedure check;
    procedure nullChunk;
  end;

  precord_BitTorrentoutgoing_request=^record_BitTorrentoutgoing_request;
  record_BitTorrentoutgoing_request=record
    index: Integer;
    offset: Cardinal;
    wantedLen: Cardinal;
    requestedTick: Cardinal;
    source: Cardinal;
    requested: Integer;
  end;


  TBittorrentTransfer = class(TObject)
    suggestedMime: Byte;
    maxSeeds: Integer;

    ffiles: TMyList;
    FSize: Int64;
    FDlSpeed,FUlSpeed: Cardinal;
    peakSpeedDown: Cardinal;
    fdownloaded,fuploaded,tempDownloaded,tempUploaded: Int64;
    fpieceLength: Cardinal;
    fpieces: array of TBitTorrentChunk;
    isPrivate: Boolean;
    trackers: TMyList;
    trackerIndex: Integer;
    //TBittorrentTracker;
    fname,fcomment,fhashvalue: string;
    fdate: Cardinal;
    dbstream: THandleStream;
    ferrorCode: Integer;
    uploadtreeview,finishedSeeding: Boolean;
    visualNode:PCmtvnode;
    visualData:PRecord_displayed_bittorrentTransfer;
    fstate: TDownloadState;
    fsources: TMyList;
    numConnected: Integer;
    outGoingRequests: TMyList;
    optimisticUnchokedSources: TMyList;
    changedVisualBitField: Boolean;
    start_date,m_elapsed,lastUpdateDb,lastFlushBannedIPs: Cardinal;
    hashFails: Cardinal;
    NumConnectedSeeders,NumConnectedLeechers: Cardinal;
    m_lastudpsearch: Cardinal;

    uploadSlots: TMyList;
    bannedIPs: TMyStringList;
    ut_metadatasize: Integer;
    tempmetastream: THandleStream;
    metafilenameS: string;
    procedure read(offset: Int64; destination:pchar; bytesCount: Int64; var remaining: Int64; var errorCode:integer);
    procedure write(offset: Int64; source:pchar; bytesCount: Int64; var remaining: Int64; var errorCode:integer);
    function FindFileAtOffset(offSet: Int64; var Index:integer): TBitTorrentFile;
    function serialize_bitfield: string;
    procedure init(const rootpath: string; info: TTorrentParser);
    procedure initFrom_ut_Meta;
    constructor create;
    destructor destroy; override;
    procedure FreeChunks;
    procedure freeFiles(eraseAll:Boolean=false);
    procedure addTracker(URL: string);
    procedure wipeout;
    procedure update_file_dates;
    procedure AddVisualGlobSource; //sync
    procedure addSource(const ip: string; port: Word; const ID: string; const sourcestr: string); overload;
    procedure addSource(ipC: Cardinal; port: Word; const ID: string; const sourcestr: string; removeExceeding:Boolean=true); overload;
    procedure CalculateFilesProgress;
    procedure IncFilesProgress(chunk: TBitTorrentChunk);
    function isCompleted: Boolean;
    function isEndGameMode: Boolean;
    procedure DoComplete;
    procedure CalculateLeechsSeeds;
    procedure useNextTracker;
  end;

  TBittorrentSourceStatus = (
    btSourceIdle,
    btSourceConnecting,
    btSourceReceivingHandshake,
    btSourceweMustSendHandshake,
    btSourceShouldDisconnect,
    btSourceShouldRemove,
    btSourceConnected
  );

type
  precord_Displayed_source=^record_Displayed_source;
  record_Displayed_source=record
    sourceHandle: Cardinal;
    IpS: string;
    port: Word;
    ID: string;
    client: string;
    foundby: string;
    status: TbittorrentSourceStatus;
    VisualBitField: TBitTorrentBitField;
    choked,interested,weAreChoked,weAreInterested,isOptimistic: Boolean;
    sent,recv: Int64;
    speedUp,speedDown: Cardinal;
    size: Int64;
    FPieceSize: Cardinal;
    progress: Cardinal;
    should_disconnect: Boolean; //set by the GUI
  end;

  TBitTorrentOutPacket = class(TObject)
    priority: Boolean;
    isFlushing: Boolean;
    payload: string;
    ID: Byte;
    findex,
    FOffset,
    fwantedLen: Cardinal;
    constructor create;
    destructor destroy; override;
  end;

  TBitTorrentSlotType=(ST_None,ST_Optimistic,ST_Normal);

  tbittorrentSource = class(TObject)
    IpC: Cardinal;
    port: Word;
    ID,ipS,Client: string;
    bitfield: TBittorrentBitField;
    progress: Int64;
    status: TbittorrentSourceStatus;
    socket: Ttcpblocksocket;
    foundby: string;
    failedConnectionAttempts,
    hashFails: Byte;   // num blocks corrupted when working in contiguous chunk request mode
    blocksReceived: Cardinal; //num blocks received and Checked       "          "
    isChoked,isInterested,weArechoked,weAreInterested: Boolean;
    SendBitfield,changedVisualBitField: Boolean;
    outBuffer: TMyList;
    inBuffer: string;
    bytes_in_header: Byte;

    tick,
    lastAttempt,
    lastKeepAliveIn,
    lastKeepAliveOut,
    handshakeTick,
    lastDataIn,
    lastDataOut,
    uptime: Cardinal;
    NumBytesToSendPerSecond: Integer;

    header: array [0..3] of Byte;
    dataDisplay:precord_Displayed_source;
    nodeDisplay:PCmtvnode;
    sent,recv: Int64;
    bytes_recv_before,bytes_sent_before: Cardinal;
    speed_recv,speed_send,speed_send_max,speed_recv_max: Cardinal;
    assignedChunk: TBitTorrentChunk;
    outRequests: Byte;

    SlotTimeout: Cardinal;
    SlotType: TBitTorrentSlotType;
    NumOptimisticUnchokes: Integer; //keeps track of how many times it has been unchoked

    Snubbed,IsIncomingConnection: Boolean;

    SupportsExtensions,
    SupportsFastPeer,
    SupportsDHT: Boolean;

    portDHT: Word;

    ut_pex_opcode: Byte;
    ut_metadata_opcode: Byte;
    allowedfastpieces: array of tbittorrentchunk;

    constructor create;
    destructor destroy; override;
    procedure ClearOutBuffer;
    function isSeeder: Boolean;
    function isLeecher: Boolean;
    function hasNoChunks: Boolean;
    function isNotAzureus: Boolean;
  end;

procedure CloneBitfield(Source: TBitTorrentBitfield; Destination: TBitTorrentBitfield); overload;
procedure CloneBitfield(transfer: TBitTorrentTransfer); overload;
procedure CloneBitfield(Source: TBitTorrentBitfield; Destination: TBitTorrentBitfield; var progress: Cardinal); overload;
function SourceIsDuplicate(transfer: TBittorrentTransfer; ipC: Cardinal): Boolean;
function PurgeExceedingSource(transfer: TBitTorrentTransfer): Boolean;
function CalcProgressFromBitField(source: TBitTorrentSource): Integer;
procedure AddBannedIp(transfer: TBitTorrentTransfer; ip: Cardinal);
function IsBannedIp(transfer: TBitTorrentTransfer; ip: Cardinal): Boolean;

implementation

uses
 ufrmmain, helper_diskio, BittorrentStringfunc, tntwindows, securehash,
 BitTorrentUtils, BitTorrentDlDb, helper_datetime, bittorrentConst,
 helper_sorting, thread_bitTorrent, vars_global, helper_unicode, helper_ipfunc,
 helper_strings, ares_types, const_ares, helper_mimetypes;

procedure AddBannedIp(transfer: TBittorrentTransfer; ip: Cardinal);
var
  ipS: string;
begin
  ipS := int_2_dword_string(ip);
  if transfer.bannedIPs=nil then
  begin
    transfer.bannedIPs := TMyStringList.create;
    transfer.bannedIPs.add(ipS);
  end;
  if transfer.bannedIPs.indexof(ipS)<>-1 then exit;

  transfer.bannedIPs.add(ipS);
end;

function IsBannedIp(transfer: TBitTorrentTransfer; ip: Cardinal): Boolean;
var
ipS: string;
begin
result := False;

if transfer.BannedIPs=nil then exit;

ipS := int_2_dword_string(ip);
result := (transfer.BannedIPs.indexof(ips)<>-1);
end;

function CalcProgressFromBitField(source: TBitTorrentSource): Integer;
var
i: Integer;
numHave,numTotal:extended;
begin
numHave := 0;
 Result := 0;
numTotal := length(source.bitfield.bits);
for i := 0 to high(source.bitfield.bits) do if source.bitfield.bits[i] then numHave := numHave+1;
if numTotal=0 then exit;
 Result := trunc((numHave/numTotal) * 100);
end;

procedure CloneBitfield(Source: TBitTorrentBitfield; Destination: TBitTorrentBitfield);
var
i: Integer;
begin
if source=nil then exit;
if length(source.bits)=0 then exit;
if destination=nil then exit;
if length(destination.bits)=0 then exit;
if length(destination.bits)<>length(source.bits) then exit;

for i := 0 to high(Source.bits) do Destination.bits[i] := source.bits[i];
end;

procedure CloneBitfield(Source: TBitTorrentBitfield; Destination: TBitTorrentBitfield; var progress: Cardinal);
var
i: Integer;
num,tot:extended;
begin
progress := 0;
num := 0;

if source=nil then exit;
if destination=nil then exit;
if length(source.bits)=0 then exit;
if length(destination.bits)<>length(source.bits) then SetLength(destination.bits,length(source.bits));

for i := 0 to high(Source.bits) do begin
 Destination.bits[i] := source.bits[i];
 if source.bits[i] then num := num+1;
end;

tot := length(source.bits);
progress := round((num/tot)*100);
end;

procedure CloneBitfield(transfer: TBitTorrentTransfer);
var
i: Integer;
piece: TBitTorrentChunk;
begin
if length(transfer.visualData.bitfield)=0 then exit;

if length(transfer.visualData.bitfield)<>length(transfer.FPieces) then exit;

for i := 0 to high(transfer.FPieces) do begin
 piece := transfer.fpieces[i];
 transfer.visualData.bitfield[i] := piece.Checked;
end;
end;


////////  TBitTorrentOutPacket
constructor TBitTorrentOutPacket.create;
begin
isFlushing := False;
end;

destructor TBitTorrentOutPacket.destroy;
begin
  payload := '';
  inherited;
end;


//** {tbittorrentSource} *************************

constructor tbittorrentSource.create;
begin
  socket := nil;
  status := btSourceIdle;
lastAttempt := 0;
progress := 0;
failedConnectionAttempts := 0;
tick := 0;
hashFails := 0;
blocksReceived := 0;
IsIncomingConnection := False;
SlotTimeout := 0;
SlotType := ST_None;
NumOptimisticUnchokes := 0;
Snubbed := False;
outRequests := 0;
NumBytesToSendPerSecond := 0;
ipS := '';
client := '';
ID := '';
outbuffer := TMyList.create;
inbuffer := '';
SendBitfield := False;
changedVisualBitField := False;
bitfield := nil;
bytes_in_header := 0;
dataDisplay := nil;
nodeDisplay := nil;
assignedChunk := nil;
lastDataIn := 0;
lastDataOut := 0;
sent := 0;
recv := 0;
ut_pex_opcode := 1;
ut_metadata_opcode := 2;
bytes_recv_before := 0;
bytes_sent_before := 0;
speed_recv := 0;
speed_send := 0;
speed_send_max := 0;
speed_recv_max := 0;
lastKeepAliveIn := 0;
portDHT := 0;
lastKeepAliveOut := 0;
handshakeTick := 0;
SupportsExtensions := False;
SupportsFastPeer := False;
SupportsDHT := False;
SetLength(allowedfastpieces,0);
end;

procedure TBitTorrentSource.ClearOutBuffer;
var
 outpacket: TBitTorrentOutPacket;
begin
while (outbuffer.count>0) do begin
 outpacket := outbuffer[outbuffer.count-1];
            outbuffer.delete(outbuffer.count-1);
 outpacket.Free;
end;
end;



function tBittorrentSource.isSeeder: Boolean;
begin
result := (progress=100);
end;

function tBittorrentSource.isNotAzureus: Boolean;
begin
result := (copy(client,1,7)<>'Azureus');
end;

function tBitTorrentSource.isLeecher: Boolean;
begin
result := (progress<>100);
end;

function tBitTorrentSource.hasNoChunks: Boolean;
var
i: Integer;
begin
result := True;
if bitfield=nil then exit;
if length(bitfield.bits)=0 then exit;

 for i := 0 to high(bitfield.bits) do
  if bitfield.bits[i] then begin
   Result := False;
   exit;
  end;
end;

destructor tbittorrentSource.destroy;
begin
if socket<>nil then socket.Free;
id := '';
ipS := '';
client := '';
ClearOutBuffer;
outbuffer.Free;
inbuffer := '';
SetLength(allowedfastpieces,0);
if bitfield<>nil then bitfield.Free;
 inherited;
end;


//************************* TBittorrentBitField *******************************


constructor TBittorrentBitField.create(ItemsCount:integer);
var
i: Integer;
begin
//if (itemsCount mod 8)<>0 then inc(itemsCount, (8-(itemsCount mod 8)) );
SetLength(bits,ItemsCount);
for i := 0 to high(bits) do bits[i] := False;
end;

procedure TBitTorrentBitField.InitWithBitField(const bitstring: string);
var
i,len,posi,sposi: Integer;
begin
len := length(bitstring);

if high(bits)<((len-1)*8) then begin
 exit;
end;

            
for i := 0 to len-1 do begin
  posi := (8*i);
  sposi := ord(bitstring[i+1]);

 if i=len-1 then begin
  if high(bits)>=posi+7 then bits[posi+7] := ((sposi and 1)   = 1);
  if high(bits)>=posi+6 then bits[posi+6] := ((sposi and 2)   = 2);
  if high(bits)>=posi+5 then bits[posi+5] := ((sposi and 4)   = 4);
  if high(bits)>=posi+4 then bits[posi+4] := ((sposi and 8)   = 8);
  if high(bits)>=posi+3 then bits[posi+3] := ((sposi and 16)  = 16);
  if high(bits)>=posi+2 then bits[posi+2] := ((sposi and 32)  = 32);
  if high(bits)>=posi+1 then bits[posi+1] := ((sposi and 64)  = 64);
  if high(bits)>=posi then   bits[posi] := ((sposi and 128) = 128);
 end else begin
  bits[posi+7] := ((sposi and 1)   = 1);
  bits[posi+6] := ((sposi and 2)   = 2);
  bits[posi+5] := ((sposi and 4)   = 4);
  bits[posi+4] := ((sposi and 8)   = 8);
  bits[posi+3] := ((sposi and 16)  = 16);
  bits[posi+2] := ((sposi and 32)  = 32);
  bits[posi+1] := ((sposi and 64)  = 64);
  bits[posi] := ((sposi and 128) = 128);
 end;
 
end;


end;

destructor TBittorrentBitField.destroy;
begin
SetLength(bits,0);
 inherited;
end;


//************************* TBittorrentChunk *************************

constructor TBitTorrentChunk.create(owner: TObject; offset: Int64; size: Int64; index: Cardinal);
var
i: Integer;
begin
Checked := False;
downloadable := False;
preview := False;
priority := 0;
FOwner := owner;
FOffset := offset;
FSize := size;
findex := index;
assignedSource := nil;

if (FSize mod BITTORRENT_PIECE_LENGTH)=0 then SetLength(pieces,FSize div BITTORRENT_PIECE_LENGTH)
 else begin
  SetLength(pieces,(FSize div BITTORRENT_PIECE_LENGTH)+1);
 end;

for i := 0 to high(pieces) do pieces[i] := False;
FProgress := 0;
end;

destructor TBitTorrentChunk.destroy;
begin
SetLength(pieces,0);
inherited;
end;

procedure TBitTorrentChunk.check;
var
sha1: Tsha1;
buffer: array [0..1023] of Byte;
bytesprocessed: Cardinal;
errorcode,i: Integer;
rem: Int64;
toread: Cardinal;
hashValue: string;
begin
sha1 := tsha1.create;

bytesProcessed := 0;
while (bytesProcessed<FSize) do begin
  toRead := sizeof(buffer);

  if bytesProcessed+toRead>FSize then toRead := FSize-bytesProcessed;

  (FOwner as TBitTorrentTransfer).read(FOffset+bytesProcessed,@buffer,toread,rem,errorCode);
  if rem<>0 then begin
    Checked := False;
    FProgress := 0;
    for i := 0 to high(pieces) do pieces[i] := False;

   sha1.Free;
   exit;
  end;
  sha1.Transform(buffer[0],toRead-rem);
  inc(bytesProcessed,toRead-rem);
end;

sha1.complete;
 hashValue := sha1.HashValue;
sha1.Free;

if not CompareMem(@HashValue[1],@CheckSum[0],20) then begin
 //corrupted chunk, re-download it
 Checked := False;
// nullChunk;
 for i := 0 to high(pieces) do pieces[i] := False;
 
 FProgress := 0;
end else begin
 Checked := True;
 inc((FOwner as TBitTorrentTransfer).fdownloaded,FSize);
 (FOwner as TBitTorrentTransfer).IncFilesProgress(self);
    if gettickcount-(FOwner as TBitTorrentTransfer).lastUpdateDb>5*MINUTE then begin
     BitTorrentDb_updateDbOnDisk((FOwner as TBitTorrentTransfer));
     (FOwner as TBitTorrentTransfer).lastUpdateDb := gettickcount;
    end;
end;


end;

procedure TBitTorrentChunk.nullChunk;
var
written,towrite: Cardinal;
buffer: array [0..1023] of Byte;
rem: Int64;
errorCode,i: Integer;
begin
for i := 0 to high(pieces) do pieces[i] := False;

fillChar(buffer,sizeof(buffer),0);
written := 0;

  while (written<FSize) do begin
    towrite := sizeof(buffer);

    if written+towrite>FSize then towrite := FSize-written;

    (FOwner as TBitTorrentTransfer).Write(FOffset+written,@buffer,towrite,rem,errorCode);

    inc(written,towrite);
  end;

end;


constructor TBittorrentFile.create(const rootpath: string; const fname: string; offset: Int64; size: Int64;
  lowner: TObject; allowCreate: Boolean; themodify_time: Cardinal);
var
 folder,fnametemp: string;
 iterations: Integer;
begin

FFilename := rootpath+'\'+fname;


tntwindows.tnt_createdirectoryW(pwidechar(utf8strtowidestr(rootpath)),nil);

FOffset := offset;
FSize := size;
FProgress := 0;

FOwner := lowner;

// build path
folder := '';
fnametemp := fname;
iterations := 0;
while (pos('\',fnametemp)>0) do begin
 folder := folder+'\'+copy(fnametemp,1,pos('\',fnametemp)-1);
            delete(fnametemp,1,pos('\',fnametemp));
 tntwindows.tnt_createdirectoryW(pwidechar(utf8strtowidestr(rootpath+folder)),nil);
 inc(iterations);
 if iterations>100 then break;
end;


if not fileexistsW(utf8strtowidestr(FFilename)) then begin

  if not allowCreate then begin
   (FOwner as TBitTorrentTransfer).ferrorCode := BT_DBERROR_FILES_LOCKED;
   (FOwner as TBitTorrentTransfer).finishedSeeding := True;
    exit;
  end;

  FStream := MyFileOpen(utf8strtowidestr(FFilename),ARES_OVERWRITE_EXISTING);

  if FStream=nil then begin
   (FOwner as TBitTorrentTransfer).ferrorCode := BT_DBERROR_FILES_LOCKED+1+GetLastError;
   if not allowCreate then (FOwner as TBitTorrentTransfer).finishedSeeding := True;
   exit; // show error to user
  end;
  
  if FStream.size<>FSize then FStream.size := FSize; //FillZeros

  exit;
end;




 FStream := MyFileOpen(utf8strtowidestr(FFilename),ARES_WRITE_EXISTING);

 if FStream=nil then begin
  (FOwner as TBitTorrentTransfer).ferrorCode := BT_DBERROR_FILES_LOCKED+1+GetLastError;
  if not allowCreate then (FOwner as TBitTorrentTransfer).finishedSeeding := True;
  exit;
 end;

 if FStream.size<>FSize then begin  // file is already there, but there's a size mismatch
  (FOwner as TBitTorrentTransfer).ferrorCode := BT_DBERROR_FILES_LOCKED+1;
  FreeHandleStream(FStream);
  if not allowCreate then (FOwner as TBitTorrentTransfer).finishedSeeding := True;
  exit;
 end;

 if allowCreate then update_modify_date else begin
  Modify_date := themodify_time;
  if (FOwner as TBitTorrentTransfer).fstate=dlSeeding then
    if helper_diskio.getLastModifiedW(utf8strtowidestr(FFilename))<>Modify_date then begin
     (FOwner as TBitTorrentTransfer).finishedSeeding := True;
    end;
 end;

end;

procedure TBitTorrentFile.update_modify_date;
begin
 Modify_date := helper_diskio.getLastModifiedW(utf8strtowidestr(FFilename));
end;

procedure TBitTorrentFile.FillZeros;
var
wanted: Int64;
buffer: array [0..1023] of Byte;
begin

FillChar(buffer,sizeof(buffer),0);

while FStream.size<>FSize do begin
 wanted := FSize-FStream.size;
 if wanted>sizeof(buffer) then wanted := sizeof(buffer);
 FStream.write(buffer,wanted);
end;

end;

procedure TBitTorrentFile.read(offsetRead: Int64; destination: Pointer; len: Int64; var bytesProcessed: Int64);
var
position: Int64;
begin
bytesProcessed := 0;
try

if FStream=nil then begin
 (FOwner as tbittorrentTransfer).ferrorCode := ERROR_STREAM_LOCKED;
 bytesProcessed := -1;
 exit;
end;

 while true do begin
  MyFileSeek(FStream,offsetRead,Ord(soFromBeginning));
  position := MyFileSeek(FStream,0,Ord(soCurrent));
  if position=offsetRead then break;
 end;
 
if len+offsetRead>FStream.size then len := FStream.size-offsetRead;
if len=0 then exit;

bytesProcessed := FStream.Read(destination^,len);

except
end;
end;

procedure TBitTorrentFile.write(offsetWrite: Int64; source: Pointer; len: Int64; var bytesProcessed: Int64);
var
position: Int64;
begin
bytesProcessed := 0;
try

if FStream=nil then begin
 (FOwner as tbittorrentTransfer).ferrorCode := ERROR_STREAM_LOCKED;
 bytesProcessed := -1;
 exit;
end;

 while true do begin
  MyFileSeek(FStream,offsetWrite,Ord(soFromBeginning));
  position := MyFileSeek(FStream,0,Ord(soCurrent));
  if position=offsetWrite then break;
 end;


if len+offsetWrite>FStream.size then len := FStream.size-offsetWrite;
if len=0 then exit;

bytesProcessed := FStream.Write(source^,len);
except
end;
end;


destructor TBitTorrentFile.destroy;
begin
if FStream<>nil then FreeHandleStream(FStream);
FFilename := '';
inherited;
end;

procedure TBitTorrentFile.erase;
begin
if FStream<>nil then FreeHandleStream(FStream);
helper_diskio.deletefileW(utf8strtowidestr(FFilename));
end;



constructor tBitTorrentTransfer.create;
begin
uploadtreeview := False;
suggestedMime := 100;  //unknown
maxSeeds := 0;
fname := '';
fcomment := '';
fhashValue := '';
FSize := 0;
fPieceLength := 0;
fDownloaded := 0;
fUploaded := 0;
finishedSeeding := False;
tempDownloaded := 0;
lastUpdateDb := 0;
tempUploaded := 0;
trackerIndex := 0;
fdate := 0;
FDlSpeed := 0;
FUlSpeed := 0;
peakSpeedDown := 0;
SetLength(fPieces,0);
hashFails := 0;
numConnected := 0;
NumConnectedSeeders := 0;
NumConnectedLeechers := 0;
fErrorCode := 0;
fFiles := nil;
dbstream := nil;
fstate := dlprocessing;
fsources := TMyList.create;
trackers := TMyList.create;
changedVisualBitField := True;
outGoingRequests := TMyList.create;
optimisticUnchokedSources := TMyList.create;
start_date := DelphiDateTimeToUnix(now);
lastFlushBannedIPs := gettickcount;
uploadSlots := TMyList.create;
bannedIPs := nil;
tempmetastream := nil;
metafilenameS := '';
ut_metadatasize := 0;
m_lastudpsearch := 0;
m_elapsed := 0;
visualNode := nil;
visualData := nil;
end;

function tBittorrentTransfer.isCompleted: Boolean;
begin
result := (fdownloaded=FSize) and (FSize>0);
end;

function tBittorrentTransfer.isEndGameMode: Boolean;
begin
result := ((FSize-fdownloaded)<(FSize div 100)) or
        ((FSize-fdownloaded)<(BITTORRENT_PIECE_LENGTH*100));
end;


procedure tBittorrentTransfer.initFrom_ut_Meta;
var
 Parser: TTorrentParser;
 torrentName: string;
 i: Integer;
 ffile: TBittorrentFile;
 source: TbittorrentSource;
 sha1: Tsha1;
 len: Integer;
 buffer: array [0..1023] of char;
 wrongmeta: Boolean;
begin
 fstate := dlAllocating;
 ferrorCode := 0;

 // check hash
 wrongmeta := True;
 tempmetastream.position := 0;
 sha1 := tsha1.create;
 while (tempmetastream.position<tempmetastream.size) do begin
  len := tempmetastream.read(buffer,sizeof(buffer));
  sha1.Transform(buffer,len);
  if len<sizeof(buffer) then break;
 end;
 sha1.Complete;
 if sha1.HashValue<>self.fhashvalue then begin
  wrongmeta := True;
 end else begin
  wrongmeta := False;
 end;
 sha1.Free;

 if wrongmeta then begin
  fstate := dlBittorrentMagnetDiscovery;
  tempmetastream.size := 0;
  ut_metadatasize := 0;
  exit;
 end;

  tempmetastream.position := 0;
 tempmetastream.position := 0;
 Parser := TTorrentParser.Create;

 Parser.Load(tempmetastream);

 torrentName := parser.name;
 TorrentName := StripIllegalFileChars(TorrentName);
 if length(TorrentName)>200 then delete(TorrentName,200,length(TorrentName));

   if length(torrentName)=0 then torrentName := bytestr_to_hexstr(parser.hashValue);
   
 {Torrent name already in download?}
   if direxistsW(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)) then begin
     if fileexistsW(vars_global.data_Path+'\Data\TempDl\PBTHash_'+bytestr_to_hexstr(parser.hashValue)+'.dat') then begin
       parser.Free;
       FreeHandleStream(tempmetastream);
       exit;
     end;

   torrentName := torrentName+inttohex(random($ff),2)+inttohex(random($ff),2);
   end;
   while direxistsW(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)) do
    torrentName := copy(torrentName,1,length(torrentName)-4)+inttohex(random($ff),2)+inttohex(random($ff),2);
  //////////////////////////////////////////

 tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder),nil);
 if parser.Files.count>1 then tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)),nil);



 freeHandlestream(tempmetastream);

  init(widestrtoutf8str(vars_global.my_torrentFolder)+'\'+torrentName,
       Parser);
 try
 parser.Free;
 except
 exit;
 end;
 // let thread_bittorrent know when file is ready for writing
for i := 0 to ffiles.count-1 do begin
 ffile := ffiles[i];

 FreeHandleStream(ffile.FStream);
 while true do begin
 ffile.FStream := MyFileOpen(utf8strtowidestr(ffile.FFilename),ARES_WRITE_EXISTING);
 if ffile.FStream<>nil then break else sleep(10);
 end;
end;

 fstate := dlProcessing;

 for i := 0 to fsources.count-1 do begin
 source := fsources[i];

  if source.status=btSourceIdle then continue;
   if source.status=btSourceShouldRemove then continue;
    if source.status=btSourceShouldDisconnect then continue;

      source.NumOptimisticUnchokes := 0;
      source.socket.Free;
      source.socket := nil;
      source.bytes_in_header := 0;
      source.ClearOutBuffer;
      source.inbuffer := '';
      source.status := btSourceIdle;
      source.outRequests := 0;
      source.lastAttempt := 0;
 end;


  deletefileW(utf8strtowidestr(metafilenameS));
  metafilenameS := '';

end;

procedure tBittorrentTransfer.init(const rootpath: string; info: TTorrentParser);
var
ThisFile: TTorrentSubFile;
i: Integer;
newfile: TBitTorrentFile;
piece: TTorrentPiece;
chunk: TBitTorrentChunk;

//str: string;
chunkOffset: Int64;
chunkSize: Int64;
ext: string;
maxSize: Int64;
//tracker: TBitTorrentTracker;
begin
 fstate := dlAllocating;
 ferrorCode := 0;

 fname := rootpath;

  if info._announces.count>0 then begin
   for i := 0 to info._announces.count-1 do addTracker(info._announces[i]);
  end else addTracker(info._announce);

 fcomment := info.comment;
 fpieceLength := info.PieceLength;
 FSize := info.Size;
 fhashvalue := info.hashValue;
 fdate := helper_datetime.delphidatetimeToUnix(info.Date);
 isPrivate := info.isPrivate;
 
SetLength(fPieces,length(info.pieces));

chunkOffset := 0;

for i := 0 to high(info.pieces) do begin

 piece := info.Pieces[i];

 chunkSize := info.PieceLength;

 if i=high(info.pieces) then
  if chunkOffset+ChunkSize>info.Size then begin
   ChunkSize := info.size-chunkOffset; //last chunk usually shorter
  end;

 chunk := TBitTorrentChunk.create(self,chunkOffset,chunkSize,i);
  move(piece.HashValue[0],chunk.checksum[0],20);
  fPieces[i] := chunk;
     
 chunkOffset := chunkOffset+chunkSize;
end;
 if ffileS=nil then ffileS := TMyList.create;

 

 if info.Files.count=1 then begin

  thisfile := (info.Files[0] as TTorrentSubFile);
  thisfile.Name := extractfilename(fname);
  ext := lowercase(extractfileext(thisfile.name));
  if (suggestedMime=100) and (length(ext)>1) then begin
   suggestedmime := helper_mimetypes.extstr_to_mediatype(ext);

  end;
     newfile := TBitTorrentFile.create(widestrtoutf8str(vars_global.my_torrentFolder),
                                     thisfile.Path+'__INCOMPLETE__'+thisfile.Name,
                                     thisfile.Offset,
                                     thisfile.Length,
                                     self,
                                     true,
                                     0);

   if self.fErrorCode<>0 then begin
    exit;
   end;
   ffiles.add(newfile);
 end else  begin
  maxSize := 0;
  for i := 0 to info.Files.count-1 do begin
   thisfile := (info.Files[i] as TTorrentSubFile);

   if maxSize<thisfile.Length then begin
      maxSize := thisfile.Length;
      ext := lowercase(extractfileext(thisfile.name));
   end;



    thisfile.Name := StripIllegalFileChars(thisfile.Name);
    if length(thisfile.Name)>200 then thisfile.name := copy(thisfile.name,1,200);

   newfile := TBitTorrentFile.create(rootpath,
                                   thisfile.Path+'__INCOMPLETE__'+thisfile.Name,
                                   thisfile.Offset,
                                   thisfile.Length,
                                   self,
                                   true,
                                   0);

   if self.fErrorCode<>0 then begin
    exit;
   end;
   ffiles.add(newfile);
  end;

   if (suggestedMime=100) and (maxSize>0) and (length(ext)>1) then begin
    suggestedmime := helper_mimetypes.extstr_to_mediatype(ext);  //mime taken by the biggest file

   end;

 end;

BitTorrentDb_updateDbOnDisk(self);

CalculateFilesProgress;

end;


procedure tBittorrentTransfer.FreeChunks;
var
i: Integer;
chunk: TBitTorrentChunk;
begin
for i := 0 to high(fpieces) do begin
 if fpieces[i]=nil then continue;
 chunk := fpieces[i];
 chunk.Free;
end;
SetLength(fpieces,0);
end;

procedure tbittorrentTransfer.update_file_dates;
var
thisfile: TBitTorrentFile;
i: Integer;
begin
for i := 0 to ffiles.count-1 do begin
 thisfile := ffiles[i];
 thisfile.update_modify_date;
end;
end;

procedure tBitTorrentTransfer.freeFiles(eraseAll:Boolean=false);
var
thisfile: TBitTorrentFile;
begin
if ffiles=nil then exit;

while (ffiles.count>0) do begin
 thisfile := ffiles[ffiles.count-1];
           ffiles.delete(ffiles.count-1);
 if eraseAll then thisfile.erase;
 thisfile.Free;
end;

FreeAndNil(ffiles);
end;

destructor tBittorrentTransfer.destroy;
var
 source: TBittorrentSource;
 request:precord_BitTorrentOutgoing_Request;
 tracker: TbittorrentTracker;
begin

uploadSlots.Free;
try
FreeChunks;
except
end;

try
FreeFiles;
except
end;

try
bitTorrentDb_CheckErase(self);
except
end;


while (trackers.count>0) do begin
 tracker := trackers[trackers.count-1];
          trackers.delete(trackers.count-1);
 tracker.Free;
end;

try
while (fsources.count>0) do begin
  source := fsources[fsources.count-1];
          fsources.delete(fsources.count-1);
  source.Free;
end;
except
end;
fsources.Free;

try
while (outGoingRequests.count>0) do begin
 request := outGoingRequests[outGoingRequests.count-1];
          outGoingRequests.delete(outGoingRequests.count-1);
 FreeMem(request,sizeof(record_BitTorrentOutgoing_Request));
end;
except
end;
outGoingRequests.Free;
optimisticUnchokedSources.Free;
fname := '';
fcomment := '';
fhashValue := '';
if bannedIPs<>nil then bannedIPs.Free;
if tempmetastream<>nil then freeHandleStream(tempmetastream);
if length(metafilenameS)>0 then begin
 deletefileW(utf8strtowidestr(metafilenameS));
 metafilenameS := '';
end;
inherited;
end;

procedure tBitTorrentTransfer.CalculateLeechsSeeds;
var
i: Integer;
source: TBitTorrentSource;
begin

NumConnectedSeeders := 0;
NumConnectedLeechers := 0;

 for i := 0 to fsources.count-1 do begin
  source := fsources[i];
  if source.status<>btSourceConnected then continue;
  if source.progress<100 then inc(numConnectedLeechers)
   else inc(numConnectedSeeders);
  end;
end;


procedure tBitTorrentTransfer.IncFilesProgress(chunk: TBitTorrentChunk);
var
i: Integer;
ffile: TBitTorrentFile;
RemainingBytes,numBytes: Integer;
begin

   RemainingBytes := chunk.FSize;

   i := 0;
   while ((i<ffiles.count) and (RemainingBytes>0)) do begin
      ffile := ffiles[i];

    if (chunk.FOffset+chunk.FSize)<=ffile.FOffset then begin
     inc(i);
     continue;
    end;
    if chunk.FOffset>(ffile.FOffset+ffile.FSize) then begin
     inc(i);
     continue;
    end;

    NumBytes := chunk.FSize;
    if chunk.FOffset<ffile.FOffset then dec(NumBytes,ffile.FOffset-chunk.FOffset);
    if chunk.FOffset+chunk.FSize>ffile.FOffset+ffile.FSize then dec(NumBytes,(chunk.FOffset+chunk.FSize)-(ffile.FOffset+ffile.FSize));


    inc(ffile.FProgress,NumBytes);


    dec(RemainingBytes,NumBytes);
    inc(i);
  end;



end;


procedure tBitTorrentTransfer.CalculateFilesProgress;
var
i,h: Integer;
ffile: TBitTorrentFile;
chunk: TBitTorrentChunk;
bytesAddedPreview,
numBytes: Int64;
begin
 for h := 0 to high(fpieces) do begin
   chunk := fpieces[h];
   chunk.priority := 0;
   chunk.downloadable := False;
 end;

for i := 0 to ffiles.count-1 do begin
 ffile := ffiles[i];
 BytesAddedPreview := 0;
 for h := 0 to high(fpieces) do begin
   chunk := fpieces[h];

   if (chunk.FOffset+chunk.FSize)<=ffile.FOffset then continue;
   if chunk.FOffset>(ffile.FOffset+ffile.FSize) then continue;

   NumBytes := chunk.FSize;
   if chunk.FOffset<ffile.FOffset then dec(NumBytes,ffile.FOffset-chunk.FOffset);
   if chunk.FOffset+chunk.FSize>ffile.FOffset+ffile.FSize then dec(NumBytes,(chunk.FOffset+chunk.FSize)-(ffile.FOffset+ffile.FSize));

   if chunk.Checked then inc(ffile.FProgress,NumBytes);
   chunk.downloadable := True;
    if BytesAddedPreview<5*MEGABYTE then begin
     chunk.preview := True;
     inc(BytesAddedPreview,NumBytes);
    end;
 end;
end;

end;

function PurgeExceedingSource(transfer: TBitTorrentTransfer): Boolean;
var
source: TBittorrentSource;
i: Integer;
begin
result := False;

with transfer do begin

 if fsources.count<BITTORRENT_MAX_ALLOWED_SOURCES then exit;

  if fsources.count>1 then begin
    if isCompleted then fsources.sort(worstDownloaderFirst)
     else fsources.sort(WorstUploaderFirst);
  end;

  for i := 0 to fsources.count-1 do begin
   source := fsources[i];
   if source.status=btSourceConnected then continue;
   if source.status=btSourceShouldRemove then continue;
    source.status := btSourceShouldRemove;
    Result := True;
    break;
  end;

end;

end;

function SourceIsDuplicate(transfer: TBittorrentTransfer; ipC: Cardinal): Boolean;
var
i: Integer;
source: TBittorrentSource;
begin
result := False;

with transfer do begin

  for i := 0 to fsources.count-1 do begin
   source := fsources[i];
   if source.ipC=ipC then begin
    Result := True;
    exit;
   end;
  end;

end;
end;

procedure tBittorrentTransfer.addSource(ipC: Cardinal; port: Word; const ID: string; const sourcestr: string; removeExceeding:Boolean=true);
var
source: TBittorrentSource;
ip: string;
begin


if SourceIsDuplicate(self,ipC) then exit;
if ipC=vars_global.localipC then exit;
if isAntiP2PIP(ipC) then exit;
if ipc=0 then exit;
if port=0 then exit;
if btcore.IsBannedIp(self,ipC) then exit;

if removeExceeding then purgeExceedingSource(self)
 else begin
  if fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then exit;
 end;

 ip := ipint_to_dotstring(ipC);

 source := TBittorrentSource.create;
  source.IpC := ipC;
  source.ipS := ip;
  source.port := port;
  source.ID := ID;
  source.foundby := sourcestr;
   fsources.add(source);

   thread_bittorrent.globSource := source;
   thread_bittorrent.globTransfer := self;
   vars_global.thread_bittorrent.synchronize(vars_global.thread_bittorrent,AddVisualGlobSource);

end;


procedure tBittorrentTransfer.addSource(const ip: string; port: Word; const ID: string; const sourcestr: string);
var
source: TBittorrentSource;
ipC: Cardinal;
begin

  ipC := inet_addr(PChar(ip));
  if SourceIsDuplicate(self,ipC) then exit;
  if ipC=vars_global.localipC then exit;
  if isAntiP2PIP(ipC) then exit;
  if ipc=0 then exit;
  if port=0 then exit;
  if btcore.IsBannedIp(self,ipC) then exit;
  
 if fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then
  if not purgeExceedingSource(self) then exit;

 source := TBittorrentSource.create;
  source.IpC := ipC;
  source.ipS := ip;
  source.port := port;
  source.ID := ID;
  source.foundby := sourcestr;
   fsources.add(source);

   thread_bittorrent.globSource := source;
   thread_bittorrent.globTransfer := self;
   vars_global.thread_bittorrent.synchronize(vars_global.thread_bittorrent,AddVisualGlobSource);

end;

procedure tBittorrentTransfer.useNextTracker;
begin
inc(trackerIndex);
if trackerIndex>=trackers.count then trackerIndex := 0;
end;

procedure tBittorrentTransfer.AddVisualGlobSource; //sync
var
 dataNode:ares_types.precord_data_node;
 node:PCmtvnode;
 data:btcore.precorD_displayed_source;
begin
    if UploadTreeview then begin
     node := ares_frmmain.treeview_upload.AddChild(visualNode);
     dataNode := ares_frmmain.treeview_upload.getdata(node);
    end else begin
     node := ares_frmmain.treeview_download.AddChild(visualNode);
     dataNode := ares_frmmain.treeview_download.getdata(node);
    end;

      dataNode^.m_type := dnt_bittorrentSource;

       data := AllocMem(sizeof(record_Displayed_source));
       dataNode^.data := data;

       thread_bittorrent.Globsource.nodeDisplay := node;
       thread_bittorrent.Globsource.dataDisplay := data;


       thread_bittorrent.Globsource.dataDisplay^.port := thread_bittorrent.GlobSource.port;
       thread_bittorrent.Globsource.dataDisplay^.ipS := thread_bittorrent.GlobSource.ipS;
       thread_bittorrent.Globsource.dataDisplay^.status := thread_bittorrent.Globsource.status;
       thread_bittorrent.Globsource.dataDisplay^.ID := thread_bittorrent.Globsource.ID;
       thread_bittorrent.Globsource.dataDisplay^.sourceHandle := integer(thread_bittorrent.Globsource);
       thread_bittorrent.Globsource.dataDisplay^.VisualBitField := TBitTorrentBitField.create(length(FPieces));
       thread_bittorrent.Globsource.dataDisplay^.foundby := thread_bittorrent.Globsource.foundby;
       thread_bittorrent.Globsource.dataDisplay^.choked := True;
       thread_bittorrent.Globsource.dataDisplay^.interested := False;
       thread_bittorrent.Globsource.dataDisplay^.weAreChoked := True;
       thread_bittorrent.Globsource.dataDisplay^.weAreInterested := False;
       thread_bittorrent.Globsource.dataDisplay^.sent := 0;
       thread_bittorrent.Globsource.dataDisplay^.recv := 0;
       thread_bittorrent.GlobSource.dataDisplay^.size := FSize;
       thread_bittorrent.GlobSource.dataDisplay^.FPieceSize := fpieceLength;
       thread_bittorrent.GlobSource.dataDisplay^.progress := 0;
       thread_bittorrent.GlobSource.dataDisplay^.should_disconnect := False;
end;

procedure tBittorrentTransfer.read(offset: Int64; destination:pchar; bytesCount: Int64; var remaining: Int64; var errorCode:integer);
var
StartingIndex: Integer;
Startingfile: TBitTorrentFile;
bytesProcessed: Int64;
relativeOffset: Int64;
begin
errorCode := ERROR_OFFSET_OUTOFRANGE;
remaining := bytesCount;

StartingFile := FindFileAtOffset(offset,StartingIndex);
if StartingFile=nil then exit;

relativeOffset := offset-StartingFile.FOffset;


while (bytesCount>0) do begin

  StartingFile.read(relativeOffset,destination,bytesCount,bytesProcessed);
  if bytesProcessed=-1 then begin
   remaining := bytesCount;
   errorCode := ERROR_STREAM_LOCKED;
   exit;
  end;

  bytesCount := bytesCount-bytesProcessed;
  if bytesCount=0 then break;

  inc(startingIndex);

  if startingIndex>=ffiles.count then begin
   errorCode := ERROR_READ_BEYONDLIMIT;
   remaining := bytesCount;
   exit;
  end;


  inc(destination,bytesProcessed);
  StartingFile := ffiles[StartingIndex];
  relativeOffset := 0;
end;

remaining := bytesCount;
errorCode := NO_ERROR;
end;

function tBitTorrentTransfer.FindFileAtOffset(offSet: Int64; var Index:integer): TBitTorrentFile;
var
mFile: TBitTorrentFile;
i: Integer;
begin
resulT := nil;

for i := ffiles.count-1 downto 0 do begin
  mFile := ffiles[i];

  if mFile.FOffset<=offset then begin
   Result := mFile;
   index := i;
   exit;
  end;
  
end;

end;

procedure tBittorrentTransfer.write(offset: Int64; source:pchar; bytesCount: Int64; var remaining: Int64; var errorCode:integer);
var
StartingIndex: Integer;
Startingfile: TBitTorrentFile;
bytesProcessed: Int64;
relativeOffset: Int64;
begin
errorCode := ERROR_OFFSET_OUTOFRANGE;
remaining := bytesCount;

StartingFile := FindFileAtOffset(offset,StartingIndex);
if StartingFile=nil then exit;

relativeOffset := offset-StartingFile.FOffset;

while (bytesCount>0) do begin

  StartingFile.Write(relativeOffset,source,bytesCount,bytesProcessed);
  if bytesProcessed=-1 then begin
   errorCode := ERROR_STREAM_LOCKED;
   remaining := bytesCount;
   exit;
  end;

  dec(bytesCount,bytesProcessed);
  if bytesCount=0 then break;

  inc(startingIndex);

  if startingIndex>=ffiles.count then begin
   errorCode := ERROR_WRITE_BEYONDLIMIT;
   remaining := bytesCount;
   exit;
  end;

  inc(source,bytesProcessed);
  StartingFile := ffiles[StartingIndex];
  relativeOffset := 0;
end;

remaining := bytesCount;
errorCode := NO_ERROR;
end;




function tBittorrentTransfer.serialize_bitfield: string;
var
c: Byte;
i: Integer;
num: Integer;
written: Boolean;
begin
result := '';

  num := high(fPieces)+1;

  if num<2 then exit;

  c := 0;
  if (num mod 8)>0 then SetLength(result,(num div 8)+1)
   else SetLength(result, num div 8);

  written := False;

  for i := 0 to num-1 do begin

    if fPieces[i].Checked then inc(c,1 shl (7-(i mod 8)) );

    if (i mod 8)=7 then begin
     result[(i div 8)+1] := chr(c);
     c := 0;
     written := True;
    end else written := False;
    
  end;

  if not written then result[(i div 8)+1] := chr(c);

end;

procedure tBitTorrentTransfer.wipeout;
var
 newfile: TBitTorrentFile;
begin
if dbstream<>nil then dbstream.size := 0;
bitTorrentDb_CheckErase(self);


if ffiles.count=1 then begin
 newfile := ffiles[0];
          ffiles.delete(0);
 newfile.erase;
 FreeAndNil(ffiles);
end else begin
 freeFiles(true);
 helper_diskio.erase_dir_recursive(utf8strtowidestr(fName));
end;

free;
end;

procedure tBitTorrentTransfer.DoComplete;
var
i: Integer;
ffile: TBitTorrentFile;
old_filename,new_filename: WideString;
begin
fstate := dlSeeding;



for i := 0 to ffiles.count-1 do begin
 ffile := ffiles[i];

 FreeHandleStream(ffile.FStream);
 ffile.update_modify_date;


 old_filename := utf8strtowidestr(ffile.FFilename);
 if length(old_filename)>MAX_PATH then old_filename := '\\?\'+old_filename;

 delete(ffile.FFilename,pos('__INCOMPLETE__',ffile.FFilename),14);
 new_filename := utf8strtowidestr(ffile.FFilename);
 if length(new_filename)>MAX_PATH then new_filename := '\\?\'+new_filename;


 tntwindows.Tnt_MoveFileW(pwidechar(old_filename),pwidechar(new_filename));


 ffile.FStream := MyFileOpen(utf8strtowidestr(ffile.FFilename),ARES_READONLY_ACCESS);
end;



BitTorrentDb_updateDbOnDisk(self);
//dbstream.size := 0;
//bitTorrentDb_CheckErase(self);
end;


procedure tBitTorrentTransfer.addTracker(URL: string);
var
 tracker: TbittorrentTracker;
 i: Integer;
begin
if length(url)<10 then exit;

for i := 0 to trackers.count-1 do begin
 tracker := trackers[i];
 if url=tracker.URL then exit;
end;


tracker := tBitTorrentTracker.create;
 tracker.url := url;
 tracker.host := GetHostFromUrl(tracker.Url);
 tracker.port := GetPortFromUrl(tracker.Url);
 tracker.download := self;
 if pos('udp://',lowercase(tracker.url))=1 then tracker.isudp := True;
trackers.add(tracker);

if trackers.count>1 then shuffle_mylist(trackers,0);
//trackers.sort(sortBitTorrentudptrackerfirst);
//trackers.sort(sortBitTorrenthttptrackerfirst);
end;




//****************************   Tracker ***********************************************************************

constructor TBitTorrentTracker.Create();
begin
  FError := '';
  BufferReceive := '';
  socket := nil;
  alreadyStarted := False;
  alreadyCompleted := False;
  next_poll := 0;
  interval := (TRACKERINTERVAL_WHENFAILED div 1000); //2 minutes
  tick := 0;
  download := nil;
  CurrTrackerEvent := '';
  url := '';
  trackerID := '';
  warningMessage := '';
  visualStr := '';
  isudp := False;
  socketUDP := INVALID_SOCKET;
  isScraping := False;
  inherited Create();
end;

destructor TBitTorrentTracker.Destroy();
begin
  if socket<>nil then socket.Free;
  if isudp then begin
   if socketUDP<>INVALID_SOCKET then TCPSocket_Free(socketUDP);
  end;
  FError := '';
  BufferReceive := '';
  CurrTrackerEvent := '';
  url := '';
  trackerID := '';
  visualStr := '';
  warningMessage := '';
  inherited Destroy();
end;

function TBitTorrentTracker.SupportScrape: Boolean;
var
ind: Integer;
begin
{
http://example.com/announce          -> http://example.com/scrape
http://example.com/x/announce        -> http://example.com/x/scrape
http://example.com/announce.php      -> http://example.com/scrape.php
http://example.com/a                 -> (scrape not supported)
http://example.com/announce?x<code>2%0644 -> http://example.com/scrape?x</code>2%0644
http://example.com/announce?x=2/4    -> (scrape not supported)
http://example.com/x%064announce     -> (scrape not supported)
}

ind := pos('/announce',lowercase(url));
if ind=0 then begin
 Result := False;
 exit;
end;

 Result := (PosEx('/',url,ind+9)=0);
end;

function TBitTorrentTracker.ParseScrape(stream: TStream): Boolean;
var
o,o2: TObject;
info,f: TObjectHash;
down: TBitTorrentTransfer;
_Tree: TObjectHash;
begin
  Result := False;

  FError := '';
  //WarningMessage := '';
  _Tree := nil;
    try


      o := bdecodeStream(Stream);
      if o=nil then begin
       FError := 'Invalid Tracker Response; not bencoded metainfo';
       exit;
      end;


    try
        if not (o is TObjectHash) then begin
         FError := 'Invalid Tracker Response; metainfo is malformed (not a dictionary)';
         FreeAndNil(o);
        end;
    except
     exit;
    end;


          _Tree := o as TObjectHash;

     try
          if not _Tree.Exists('files') then begin  // list, old format
           FError := 'Error while parsing scrape reply (''files'' dictionary missing)';
           FreeAndNil(o);
           exit;
          end;
    except
    exit;
    end;


    try
          if not (_Tree['files'] is TObjectHash) then begin
            FError := 'Error while parsing scrape reply (''files'' not an ojectHash)';
            FreeAndNil(o);
            exit;
          end;
   except
   exit;
   end;


   try
          f := _Tree['files'] as TObjectHash;
          if f.ItemCount<>1 then begin
            FError := 'Error while parsing scrape reply (hash not found...'+inttostr(f.ItemCount)+' files returned by tracker)';
            FreeAndNil(o);
            exit;
          end;
   except
   exit;
   end;


          down := download;


   try
          if not f.Exists(down.fhashvalue) then begin
           FError := 'Invalid Tracker Scrape Response (doesn''t exist infohash key/value)';
            FreeAndNil(o);
           exit;
          end;
   except
   exit;
   end;


   try
          o2 := f.Items[down.fhashvalue];
          if not (o2 is TObjectHash) then begin
            FError := 'Invalid Tracker Scrape Response (hash is not an TObjectHash)';
            FreeAndNil(o);
            exit;
          end;
  except
   exit;
  end;

   try
          info := o2 as TObjectHash;

          if info.Exists('complete') then begin
           seeders := (info['complete'] as TIntString).IntPart;
          end;

          if info.Exists('incomplete') then begin
           leechers := (info['incomplete'] as TIntString).IntPart;
          end;
          
          //info.Free;
   except
   end;



   finally
    if _Tree<>nil then _Tree.Free;
   // FreeAndNil(o);
   end;


 // except
 //   FError := 'Error while trying to parse Tracker scrape stats';
  //end;

  Result := True;
end;

function TBitTorrentTracker.Load(Stream: TStream): Boolean;
var
o: TObject;
info: TObjectHash;
f: TObjectList;
h,n,str: string;
i,j: Integer;
down: TbittorrentTransfer;
_Tree: TObjectHash;
begin
  Result := False;
  
  FError := '';
  WarningMessage := '';
  _Tree := nil;

    try

      o := bdecodeStream(Stream);
      if o=nil then begin
       FError := 'Invalid Tracker Response; not bencoded metainfo';
       exit;
      end;


    try
        if not (o is TObjectHash) then begin
         FError := 'Invalid Tracker Response; metainfo is malformed (not a dictionary)';
            try
            FreeAndNil(o);
            except
            end;
         exit;
        end;
    except
    end;



          _Tree := o as TObjectHash;

           seeders := 0;
           leechers := 0;

    try
          // parse vars
          if _Tree.Exists('warning message') then begin
           WarningMessage := (_Tree['warning message'] as TIntString).StringPart;
          // (_Tree['warning message'] as TIntString).Free;
          end;

          if _Tree.Exists('failure reason') then begin
           WarningMessage := (_Tree['failure reason'] as TIntString).StringPart;

           FError := 'Error '+(_Tree['failure reason'] as TIntString).StringPart;
           Interval := 600; // do not hammer trackers, 10 minutes?
           exit;
          end;


          if _Tree.Exists('interval') then begin
           Interval := (_Tree['interval'] as TIntString).IntPart;
          // (_Tree['interval'] as TIntString).Free;
          end;
          if _Tree.Exists('min interval') then begin
           Interval := (_Tree['min interval'] as TIntString).IntPart;
          // (_Tree['min interval'] as TIntString).Free;
          end;
          if _Tree.Exists('tracker id') then TrackerID := (_Tree['tracker id'] as TIntString).StringPart;
          if _Tree.Exists('complete') then begin
           seeders := (_Tree['complete'] as TIntString).IntPart;
           //(_Tree['complete'] as TIntString) := nil;
          end;
          if _Tree.Exists('incomplete') then begin
           leechers := (_Tree['incomplete'] as TIntString).IntPart;
          end;
    except
    end;


    try

          if not _Tree.Exists('peers') then begin  // list, old format
            if _Tree.Exists('failure reason') then begin
             FError := 'Error '+(_Tree['failure reason'] as TIntString).StringPart;
             Interval := 600; // do not hammer trackers, 10 minutes?
             
            end else FError := 'Invalid Tracker Response; missing "peers" segment';
           exit;
          end;

     except
     end;


     try
            if _Tree['peers'] is TObjectList then begin
              f := _Tree['peers'] as TObjectList;

              for j := 0 to f.Count-1 do begin
                if f.Items[j] is TObjectHash then begin
                  info := f.Items[j] as TObjectHash;
                  h := {bin2Hex(}(info['peer id'] as TIntString).StringPart{)};
                 // (info['peer id'] as TIntString).Free;

                   if info.Exists('port') then begin
                    i := (info['port'] as TIntString).IntPart;
                  //  (info['port'] as TIntString).Free;
                   end else i := 80;

                  n := (info['ip'] as TIntString).StringPart;
                  if download<>nil then begin
                   down := download;
                   down.addsource(n,i,h,'Tracker');
                  end;
                  //(info['ip'] as TIntString).Free;
                end else FError := 'Invalid Tracker Response; info for all peers should be a dictionary';
              end;
              
            end else begin //compact form, new format
              str := (_Tree['peers'] as TIntString).StringPart;
              while (length(str)>=6) do begin
               h := '';
               n := ipint_to_dotstring(chars_2_dword(copy(str,1,4)));
               i := (ord(str[5])*256)+ord(str[6]); //,5,2));
               delete(str,1,6);
                  if download<>nil then begin
                   down := download;
                   down.addsource(n,i,h,'Tracker');
                  end;
              end;
              //(_Tree['peers'] as TIntString).Free;
            end;
      except
      end;


  //  while _Tree.ItemCount>0 do _Tree.FDeleteIndex(0);
  finally
    try
    _Tree.Free;
    except
    end;
  end;
 // except
 //   FError := 'Error while trying to parse the Tracker state';
 // end;

  Result := True;
end;

end.
