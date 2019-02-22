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
some application objects are listed here
}

unit ares_objects;

interface

uses
  Comettrees, Classes, Classes2, Blcksock, Const_ares,
  Windows, SysUtils;

type
  TDownloadState = (
    dlBittorrentMagnetDiscovery,
    dlSeeding,
    dlFileError,
    dlAllocating,
    dlFinishedAllocating,
    dlRebuilding,
    dlProcessing,
    dlJustCompleted,
    dlCompleted,
    dlDownloading,
    dlPaused,
    dlLeechPaused,
    dlLocalPaused,
    dlCancelled,
    dlQueuedSource,
    dlUploading);

  TDownloadStates = set of TDownloadState;

  TSourceState = (
    srs_paused,
    srs_idle,
    srs_connecting,
    srs_readytorequest,
    srs_receiving,
    srs_waitingPush,
    srs_TCPpushing,
    srs_UDPPushing,
    srs_waitingForUserUdpAck,
    srs_UDPDownloading,
    srs_UDPreceivingICH,
    srs_waitingForUserUDPPieceAck,
    srs_waitingIcomingConnection,
    srs_connected,
    srs_ReceivingReply,
    srs_receivingICH
  );
  TSourceStates=set of TSourceState;

  TBitTorrentViewMode=(vmFiles,vmSources);

  precord_displayed_bittorrentTransfer = ^record_displayed_bittorrentTransfer;
  record_displayed_bittorrentTransfer = record
    handle_obj: Cardinal;
    FileName,path,trackerStr: string;
    Size: Int64;
    downloaded,uploaded: Int64;
    hash_sha1: string;
    crcsha1: Word;
    SpeedDl,SpeedUl: Cardinal;
    state: TDownloadState;
    want_cancelled,
    want_paused,
    want_changeView,
    want_cleared: Boolean;
    num_sources: Word;
    NumLeechers,NumSeeders,NumConnectedSeeders,NumConnectedLeechers: Cardinal;
    ercode: Integer;
    bitfield: array of Boolean;
    FPieceSize: Cardinal;
    elapsed: Cardinal;
  end;


   


  precord_displayed_downloadsource=^record_displayed_downloadsource;
  record_displayed_downloadsource = record
    handle_obj: Cardinal;
    queued_position: Integer;
    ip: Cardinal;
    ip_alt: Cardinal;
    port: Word;
    ip_server: Cardinal;
    port_server: Word;
    nomedisplayw: WideString;  //widestrin!
    should_disconnect: Boolean;
    nickname: string;
    versionS: string;
    state: TSourceState;
    speed: Integer;
    size: Cardinal;
    progress: Cardinal;
    startp: Int64;
    endp: Int64;
  end;

  precord_displayed_download=^record_displayed_download;
  record_displayed_download=packed record
    handle_obj: Cardinal;
    VisualBitfield: array of Boolean;
    numInDown: Byte;
    FPieceSize: Cardinal;
    ercode: Integer;
    lastDHTCheckForSources: Cardinal;

    hash_sha1: string;
    crcsha1: Word;
    state: TDownloadState;

    Title: string;
    Keyword_genre: string;
    progress: Int64;
    velocita: Int64;
    size: Int64;
    filename: string;
    nomedisplayw: WideString;  //widestrin!
    tipo: Byte;
    Artist: string;
    Album: string;
    Category: string;
    Comments: string;
    Language: string;
    Date: string;
    Url: string;
    param1: Cardinal;
    param2: Cardinal;
    param3: Cardinal;
    num_sources: Word;
    num_partial_sources: Word;
    want_cancelled: Boolean; // per comandare..
    change_paused: Boolean;
  end;

  precord_alternate=^record_alternate;
  record_alternate= packed record
    ip_user: Cardinal;
    port_user: Word;
    ip_server: Cardinal;
    port_server: Word;
    prev,next:precord_alternate;
  end;

  TDownloadPiece = class(TObject)
    FOffset: Int64;
    FProgress: Int64;
    FHashValue: array [0..19] of byte;
    FDone: Boolean;
    FInUse: Boolean;
  end;

  TAviHeaderCheckState=(
    aviStateNotAvi,
    aviStateNotChecked,
    aviStateIsAvi
  );

  TDownload = class(TObject)
    FPieces: array of TDownloadPiece;
    FPieceSize: Int64;
    allocator: TThread;
    display_node:PCmtVNode;
    display_data:precord_displayed_download;
    startDate: Cardinal;
    creationTime: Cardinal;
    size: Int64;
    progress: Int64;

    stream: THandleStream;
    aviHeaderState: TAviHeaderCheckState;
    AviIDX1At: Cardinal;

    filename,
    remaining,
    hash_sha1,
    in_subfolder,
    hash_of_phash: string; //per cancellazione subfolder nel caso sia libera alla fine
    crcsha1: Word;
    num_in_down: Cardinal;

    tipo: Byte;

    state: TDownloadState;
    paused_sources: Boolean; //per evitare di entrare nel ciclo pause all ogni volta
    lista_risorse: TMyList;
    notworking_ips: TMyList;
    speed: Integer;
    param1,param2,param3: Integer;
    Title,Artist,Album,Category,Language,Comments,Date,Url,Keyword_genre: string;

    phash_verified_progr: Int64;
    is_getting_phash: Boolean;
    phash_Stream: THandleStream;

    ercode: Integer;
    socket_push: Ttcpblocksocket;
    push_connected: Boolean;
    push_testoricevuto: string;
    push_flushed: Boolean;
    push_tick: Cardinal;
    push_randoms: string;
    push_ip_requested: Cardinal;
    push_num_special: Byte;
    push_ip_server: Cardinal;
    push_port_server: Word;

    constructor Create;
    destructor Destroy; override;

    function BitFieldtoStr: string;
    function BitFieldStrLen: Integer;
    procedure AddVisualReference;     //synch
    procedure RemoveVisualReference;
    procedure AddToBanList(ip: Cardinal);
    function isBannedIp(ip: Cardinal): Boolean;
  end;


type
  FSTSessionState= (
    SessIdle,
    SessConnecting,
    SessEstablished,
    SessDisconnected,
    SessReceivingNa,  //for ares
    SessFlushingLogin,
    SessWaitingForLoginReply
  );


  tares_node = class(TObject)
    reports,attempts,connects,
    first_seen,last_seen,last_attempt: Cardinal;
    in_use,dejavu,noCrypt,oldProt: Boolean;
    state:FSTSessionState;
    out_buf,searchIDS: TMystringlist; //clear out buf
    socket: Ttcpblocksocket;
    reported: Boolean;
    supportDirectChat: Boolean;
    hits_received: Cardinal;
    last_lag: Cardinal;
    last: Cardinal; //per vari timeouts
    last_out_stats: Cardinal;
    logtime: Cardinal;
    ListSents,HistSentFilelists: Cardinal;
    ready_for_filelist,EverSentFilelist: Boolean;
    sc: Word; // second key
    fc: Byte;  // first key algo
    host: string;   //remote host server
    port: Word;
    constructor create;
    destructor destroy;override;
    function rate: Single;
    //procedure get_prepna;
  end;


  TWriteCache = class(TObject)
    Fbuffer: array of byte;
    FStream: THandleStream;
    FCurrentDiskOffset: Int64;
    FCurrentInternalOffset: Int64;
    constructor create(stream: THandleStream; DiskOffset: Int64);
    destructor destroy; override;
    procedure write(data: Pointer; len: Cardinal);
    procedure flush;
  end;

  trisorsa_download = class(TObject)
    writecache: TWriteCache;
    display_node:PCmtVNode;
    display_data:precord_displayed_downloadsource;
    attivato_ip,ICH_passed: Boolean;
    failed_ipint,
    has_tried_extIP,
    FailedICHDBRet: Boolean;
    handle_download: Cardinal;
    started_time: Cardinal;
    nickname: string;
    version: string;
    randoms: string;
    origfilename: string;
    ICH_failed: Boolean;
    getting_phash: Boolean;
    isFirewalled: Boolean; //default = true
    UDP_Socket:Hsocket;
    unAckedPackets: Byte;
    UDPNatPort: Word;
    UDPICHProgress: Integer;
    CurrentUDPPushSupernode: Cardinal;
    nextUDPOutInterval: Cardinal;
    lastUDPOut: Cardinal;

    queued_position: Integer;

    speed: Int64;
    next_poll: Cardinal;
    num_fail: Byte;
    numgiven_mesh: Byte;
    have_tried: Boolean;
    actual_decrypt_key: Word;
    encryption_branch: Byte;
    ip_interno: Cardinal;
    ip: Cardinal;
    porta: Word;
    his_servers: TMyStringlist;

    state: TSourceState;
    socket: Ttcpblocksocket;
    out_buf: string;
    last_in: Cardinal;
    last_out_push_req: Cardinal;
    tick_attivazione: Cardinal;
    succesfull_factor: Cardinal;

    start_byte: Int64;
    end_byte: Int64;
    global_size: Int64;
    bytes_prima: Int64;
    progress: Int64;
    size_to_receive: Int64;
    progress_su_disco: Int64;

    download: Pointer;
    piece: TDownloadPiece;
    constructor create;
    procedure AddVisualReference;
    procedure RemoveVisualReference;
    procedure InsertServer(ip: Cardinal; port: Word; clearPrevious:Boolean=false);
    procedure InsertServers(buffer: string);
    procedure RemoveServer(ip: Cardinal);
    function GetFirstBinaryServerStr: string;
    procedure GetFirstServerDetails(var ip: Cardinal; var port:word);
    destructor Destroy; override;
  end;


type
  precord_buffer_invio=^record_buffer_invio;
  record_buffer_invio=array [0..1028] of byte; //2942< era 1024

  tupload = class(TObject)
    socket: Ttcpblocksocket;
    stream: THandleStream;

    filename: string;
    crcfilename: Word;
    nickname: string;
    crcnick: Word;
    out_reply_header: string;
    his_progress: Byte;
    his_upcount: Integer;
    his_downcount: Integer;
    his_speedDL: Cardinal; // 2957+ mostra sua speed per fini statistici
    his_shared: Integer;
    his_agent: string;
    ip_server: Cardinal;
    ip_alt: Cardinal;
    port_server: Word;
    ip_user: Cardinal;
    port_user: Word;
       
    isUDP: Boolean;
    UDPSourceHandle: Cardinal;
    lastUDPData: Cardinal;
    bsent: Int64;
    actual: Int64;
    startpoint: Int64;
    endpoint: Int64;
    size: Int64;
    filesize_reale: Int64; //crazy maniak
    SentHeader: Boolean;

    bytesprima: Int64;
    velocita: Integer;
    is_phash: Boolean; //per invio phash, il flag elimina il file temp alla fine dell'upload
    start_time: Cardinal;
    should_display: Boolean;
    num_available: Byte;

    buffer_invio:record_buffer_invio;
    bytes_in_buffer: Integer;
    is_encrypted: Boolean;
    encryption_key: Word;
    his_buildn: Word;
    constructor Create(tim: Cardinal);
    destructor Destroy; override;
  end;

  Tpush_out = class(TObject)
    socket: TTCPBlockSocket;
    connected: Boolean;
    constructor create(tim: Cardinal);
    destructor destroy; override;
  end;

  TBitClass = class(TObject)
    data: array of Boolean;
    position: Integer;
  public
    constructor create;
    procedure load(datain: string);
    destructor destroy; override;
    procedure seek(newpos:Integer);
    function getint(numbit:Integer): Cardinal;
  end;

  TSharedMemory = class(TObject)
    HMapping: THandle;
    PMapData: Pointer;
    HMapMutex: THandle;
    procedure OpenMap;
    procedure CloseMap;
    function LockMap: Boolean;
    procedure unLockMap;
  end;

implementation

uses
  securehash,thread_supernode,helper_diskio,helper_ares_nodes,
  ares_types,ufrmmain,helper_unicode,
  helper_ich,helper_urls,helper_download_misc,helper_strings,
  helper_ipfunc,helper_datetime;

procedure TSharedMemory.OpenMap;
 var
   llInit: Boolean;
  // lInt: Integer;
 begin
   HMapping := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE,
                 0, 512, PChar('MY MUTEX NAME GOES HERE'));
   // Check if already exists
   llInit := (GetLastError() <> ERROR_ALREADY_EXISTS);
   if (hMapping = 0) then
   begin
     //ShowMessage('Can''t Create Memory Map');
     //Application.Terminate;
     exit;
   end;
   PMapData := MapViewOfFile(HMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);
   if PMapData = nil then
   begin
     CloseHandle(HMapping);
     //ShowMessage('Can''t View Memory Map');
    // Application.Terminate;
     exit;
   end;
   if (llInit) then
   begin
     // Init block to #0 if newly created

      FillChar(PMapData^, 512, 0);
   end
 end;

procedure TSharedMemory.CloseMap;
begin
 if PMapData<>nil then UnMapViewOfFile(PMapData);
 if HMapping<>0 then CloseHandle(HMapping);
end;

function TSharedMemory.LockMap: Boolean;
begin
   Result := True;
   HMapMutex := CreateMutex(nil, false,PChar('Ares_mmap_mutex'));
   if HMapMutex = 0 then 
   begin
    // ShowMessage('Can''t create map mutex');
     Result := False;
   end 
   else 
   begin
     if WaitForSingleObject(HMapMutex,1000) = WAIT_FAILED then 
     begin
       // timeout
      // ShowMessage('Can''t lock memory mapped file');
       Result := False;
     end
   end
 end;
 
procedure TSharedMemory.UnlockMap;
begin
 ReleaseMutex(HMapMutex);
 CloseHandle(HMapMutex);
end;



constructor TBitClass.create;
begin
inherited;
 position := 0;
end;

procedure TBitClass.load(datain: string);
var
 i: Integer;
 thebyte: Byte;
begin
position := 0;
SetLength(data,length(datain)*8);

for i := 1 to length(datain) do begin
 thebyte := ord(datain[i]);

 data[(i-1)*8] := ((thebyte and 128)=128);
 data[((i-1)*8)+1] := ((thebyte and 64)=64);
 data[((i-1)*8)+2] := ((thebyte and 32)=32);
 data[((i-1)*8)+3] := ((thebyte and 16)=16);
 data[((i-1)*8)+4] := ((thebyte and 8)=8);
 data[((i-1)*8)+5] := ((thebyte and 4)=4);
 data[((i-1)*8)+6] := ((thebyte and 2)=2);
 data[((i-1)*8)+7] := ((thebyte and 1)=1);
end;

end;

procedure TBitClass.seek(newpos:Integer);
begin
 position := position+newpos;
end;

function TBitClass.getint(numbit:Integer): Cardinal;
var
 i: Integer;
 multiplier: Cardinal;
begin
result := 0;
multiplier := 1;

for i := (position+numbit)-1 downto position do begin
 Result := result+(Integer(data[i])*multiplier);
 multiplier := multiplier*2;
end;

inc(position,numbit);
end;

destructor TBitClass.destroy;
begin
  SetLength(data, 0);
  inherited;
end;

constructor Tpush_out.create(tim: Cardinal);
begin
  socket := ttcpblocksocket.create(true);
  socket.tag := tim;
  connected := False;
end;

destructor tPush_out.destroy;
begin
  if socket<>nil then 
    Socket.Free;
  inherited;
end;

constructor trisorsa_download.create;
begin
inherited create;

 piece := nil;
 writecache := nil;
 display_node := nil;
 display_data := nil;
 attivato_ip := False;
 num_fail := 0;
 socket := nil;
 ip_interno := 0;
 failed_ipint := False;
 CurrentUDPPushSupernode := 0;
 has_tried_extIP := False;
 FailedICHDBRet := False;
 numgiven_mesh := 0;
 ICH_failed := False;
 isFirewalled := True;
 getting_phash := False;
 last_out_push_req := 0;
 out_buf := '';
 origfilename := '';
 ICH_passed := False;
 version := '';
 ip := 0;
 porta := 0;
 his_servers := TMyStringlist.create;
 succesfull_factor := 0;
 UDP_Socket := INVALID_SOCKET;
 queued_position := 0;
 actual_decrypt_key := 0;
 encryption_branch := 0;

 state := srs_idle;
 have_tried := False;
 start_byte := 0;
 end_byte := 0;
 progress := 0;
 speed := 0;
 global_size := 0;
 tick_attivazione := 0;
end;

procedure trisorsa_download.InsertServer(ip: Cardinal; port: Word; clearPrevious:Boolean=false);
var
ipb: array [0..3] of byte;
str: string;
i: Integer;
begin

if clearPrevious then his_servers.clear else
if his_servers.count>0 then begin
 move(ip,ipb[0],4);
 for i := 0 to his_servers.count-1 do begin
  str := his_servers.strings[i];
  if compareMem(@ipb[0],@str[1],4) then exit;
 end;
end;
if ip_firewalled(ip) then exit;
if isAntiP2PIP(ip) then exit;

if his_servers.count>=NUM_SESSIONS_TO_SUPERNODES then his_servers.delete(0);

his_servers.add(int_2_dword_string(ip)+
                int_2_word_string(port));
end;

function trisorsa_download.GetFirstBinaryServerStr: string;
begin
if his_servers.count=0 then begin
 Result := CHRNULL+CHRNULL+CHRNULL+CHRNULL+
         CHRNULL+CHRNULL;
 exit;
end;

result := his_servers.strings[0];

if length(result)<>6 then Result := CHRNULL+CHRNULL+CHRNULL+CHRNULL+
                                  CHRNULL+CHRNULL;
end;

procedure trisorsa_download.GetFirstServerDetails(var ip: Cardinal; var port:word);
var
str: string;
begin

if his_servers.count=0 then begin
 ip := 0;
 port := 0;
 exit;
end;

str := his_servers.strings[0];
 ip := chars_2_dword(copy(str,1,4));
 port := chars_2_word(copy(str,5,2));
end;

procedure trisorsa_download.InsertServers(buffer: string);
var
tempip: Cardinal;
begin
if his_servers.count>0 then his_servers.clear;

while (length(buffer)>=6) do begin
tempip := chars_2_dword(copy(buffer,1,4));

 if not ip_firewalled(tempip) then
  if not isAntiP2PIP(tempip) then
   his_servers.add(copy(buffer,1,6));

  delete(buffer,1,6);
 if his_servers.count>=NUM_SESSIONS_TO_SUPERNODES then break;
end;

end;

procedure trisorsa_download.RemoveServer(ip: Cardinal);
var
ipb: array [0..3] of byte;
str: string;
i: Integer;
begin
if his_servers.count=0 then exit;

move(ip,ipb[0],4);

for i := 0 to his_servers.count-1 do begin
 str := his_servers[i];
 if compareMem(@ipb[0],@str[1],4) then begin
  his_servers.delete(i);
  exit;
 end;
end;

end;


procedure trisorsa_download.AddVisualReference;
var
dataNode:precord_data_node;
aNode:PcmtVnode;
down: TDownload;
begin
 down := download;

 aNode := ares_frmmain.treeview_download.addchild(down.display_node);

  dataNode := ares_frmmain.treeview_download.getdata(aNode);
  dataNode^.m_type := dnt_downloadSource;
  dataNode^.data := AllocMem(sizeof(record_displayed_downloadsource));


  display_node := aNode;
  display_data := dataNode^.data;

  with display_data^ do begin
    handle_obj := Cardinal(self);
    ip := self.ip;
    ip_alt := self.ip_interno;
    port := self.porta;
    self.GetFirstServerDetails(ip_server,port_server);
    should_disconnect := False;
    nickname := self.nickname;
    speed := 0;
    size := 0;
    progress := 0;
    startp := 0;
    endp := 0;
    state := self.state;
    
     if self.origfilename<>'' then nomedisplayw := utf8strtowidestr(self.origfilename)
      else nomedisplayw := down.display_data^.nomedisplayw;
   end;
end;

procedure trisorsa_download.RemoveVisualReference;
begin
if display_node<>nil then begin
 ares_frmmain.treeview_download.deletenode(display_node);
end;

end;


destructor trisorsa_download.Destroy;
begin
try
his_servers.Free;
except
end;
try
if socket<>nil then socket.Free;
except
end;

socket := nil;

if UDP_Socket<>INVALID_SOCKET then TCPSocket_Free(UDP_Socket);

out_buf := '';
nickname := ''; // nostro proto
randoms := '';
origfilename := '';
version := '';

RemoveVisualReference; 

inherited destroy;
end;



constructor TDownload.create;
begin
  inherited Create;

  SetLength(FPieces,0);
  FPieceSize := 0;
    
  aviHeaderState := aviStateNotChecked;
  AviIDX1At := 0;
    
  display_node := nil;
  display_data := nil;

  lista_risorse := TMyList.create;
  notworking_ips := nil;
  num_in_down := 0;
  speed := 0;
  progress := 0;
    
  paused_sources := False;
  in_subfolder := '';
  hash_of_phash := '';

  stream := nil;

  phash_verified_progr := 0;
  is_getting_phash := False;

  phash_stream := nil;
  ercode := 0;
  socket_push := nil;
  state := dlProcessing;
  creationTime := gettickcount;

  FPieceSize := helper_ich.ICH_calc_chunk_size(size);
end;

procedure TDownload.RemoveVisualReference;
begin
  if display_node<>nil then 
    ares_frmmain.treeview_download.deleteNode(display_node);
end;

procedure TDownload.AddVisualReference;     //synch
var
  dataNode: precord_data_node;
  someNode: pcmtVNode;
begin
  someNode := ares_frmmain.treeview_download.AddChild(nil);
  
  dataNode := ares_frmmain.treeview_download.getdata(someNode);
  dataNode^.m_type := dnt_download;
  dataNode^.data := AllocMem(sizeof(record_displayed_download));
  
  self.display_data := dataNode^.data;
  self.display_node := someNode;
  
  helper_download_misc.UpdateVisualDownload(self);
end;

procedure TDownload.AddToBanList(ip: Cardinal);
var
  i: Integer;
  ipc:precord_ip;
begin
  if notworking_ips=nil then notworking_ips := TMyList.create;

 for i := 0 to notworking_ips.count-1 do begin
  ipc := notworking_ips[i];
   if ipc^.ip=ip then exit;
 end;

 ipc := AllocMem(sizeof(record_ip));
  ipc^.ip := ip;
 notworking_ips.add(ipc);
end;

function TDownload.isBannedIp(ip: Cardinal): Boolean;
var
i: Integer;
ipc:precord_ip;
begin
result := False;
if notworking_ips=nil then exit;

 for i := 0 to notworking_ips.count-1 do begin
  ipc := notworking_ips[i];
   if ipc^.ip=ip then begin
    Result := True;
    exit;
   end;
 end;

end;


function TDownload.BitFieldStrLen: Integer;
var
num: Integer;
begin
if length(FPieces)=0 then begin
 Result := 0;
 exit;
end;

num := high(fPieces)+1;
if (num mod 8)>0 then Result := (num div 8)+1
 else Result := num div 8;
end;

function TDownload.BitFieldtoStr: string;
var
  c: Byte;
  i: Integer;
  written: Boolean;
  piece: TDownloadPiece;
begin
  if length(FPieces)=0 then
  begin
    Result := '';
    exit;
  end;

 // num := high(fPieces)+1;

  c := 0;

  SetLength(result,BitFieldStrLen);
  //SetLength(result,(length(FPieces) div 8)+1);
  written := False;

  for i := 0 to high(FPieces) do begin
    piece := FPieces[i];
    if piece.FDone then inc(c,1 shl (7-(i mod 8)) );

    if (i mod 8)=7 then begin
     result[(i div 8)+1] := chr(c);
     c := 0;
     written := True;
    end else written := False;
  end;

  if not written then result[(i div 8)+1] := chr(c);
end;


destructor TDownload.Destroy;
var
  ipc:precord_ip;
  i: Integer;
  piece: TDownloadPiece;
begin
  filename := '';
  remaining := '';
  in_subfolder := '';
  hash_of_phash := '';
  hash_sha1 := '';
  Keyword_genre := '';
  Title := '';
  Artist := '';
  Album := '';
  Category := '';
  Language := '';
  Date := '';
  Url := '';
  Comments := '';
  push_testoricevuto := '';
  push_randoms := '';

  RemoveVisualReference;

  if allocator<>nil then
  begin
    allocator.terminate;
    allocator.waitfor;
    allocator.Free;
  end;

  if length(FPieces)>0 then begin
    for i := 0 to High(FPieces) do
    begin
      piece := FPieces[i];
      piece.Free;
    end;
    SetLength(FPieces,0);
  end;

  try
   if stream<>nil then FreeHandleStream(stream);
  except
  end;

  try
    if phash_stream<>nil then FreeHandleStream(phash_stream);
  except
  end;

  try
    if notworking_ips<>nil then
    begin
      while (notworking_ips.count>0) do
      begin
        ipc := notworking_ips[notworking_ips.count-1];
        notworking_ips.delete(notworking_ips.count-1);
        FreeMem(ipc,sizeof(record_ip));
      end;
    FreeAndNil(notworking_ips);
    end;
  except
  end;

  try
    if lista_risorse<>nil then FreeAndNil(lista_risorse);
  except
  end;


  try
    if socket_push<>nil then FreeAndNil(socket_push);
  except
  end;


  inherited destroy;
end;

constructor tares_node.create;
begin
  last_attempt := 0;
  first_seen := 0;
  last_seen := 0;
  connects := 0;
  reports := 0;
  attempts := 0;

  in_use := False;
  dejavu := False;
  noCrypt := False;
  oldProt := False;
  state := sessIdle;
  out_buf := nil; //clear out buf
  socket := nil;
  hits_received := 0;
  last := 0;
  last_lag := 0;
  searchIDS := nil;
  reported := False;
  sc := 0; // second key
  fc := 0;  // first key algo
  host := '';   //remote host server
  port := 0;
  ListSents := 0;
  ready_for_filelist := falsE;
  HistSentFilelists := 0;
  supportDirectChat := False;
end;

function tares_node.rate: Single;
var
 rateofsuccess,historical,popularity: Single;
 nowunix: Cardinal;
begin
  Result := 0;
  nowunix := DelphiDateTimeToUnix(now);

  if connects=0 then begin  // no connect, recently we've heard about it but we didn't try it yet
     if (reports>5) and
        (attempts=0) and
        (nowunix-last_seen<1800) then Result := 1;
     exit;
  end;

  rateofsuccess := ((connects + 1) / (attempts + 1));  // rate of tried-succeded

  if nowunix-last_seen<86400 then begin // recently seen?
   if (last_seen - first_seen) / 86400>=10 then historical := 4 else historical := 2;   //add two if we've seen it in the last 24 hours, four if it's older than 10 days
  end else historical := 86400 / (nowunix-last_seen);

  popularity := (reports / rateofsuccess);

  Result := ((connects*5)+(popularity/10)) * (2*rateofsuccess) * historical;
end;

destructor tares_node.destroy;
begin
  if out_buf<>nil then FreeAndNil(out_buf); //clear out buf
  if socket<>nil then FreeAndNil(socket);
  host := '';   //remote host server
  if searchIDs<>nil then FreeAndNil(searchIDS);

  inherited destroy;
end;

constructor tupload.create(tim: Cardinal);
begin
  inherited Create;
  bsent := 0;
  filename := '';
  nickname := '';
  out_reply_header := '';
  start_time := tim;
  is_encrypted := False;
  bytes_in_buffer := 0;
  SentHeader := False;
  his_progress := 0;
  is_phash := False;
  isUDP := False;
  his_agent := '';
  socket := nil;
  stream := nil;
end;

destructor tupload.Destroy;
begin
  filename := '';
  nickname := '';
  out_reply_header := '';
  his_agent := '';
  try
    if socket<>nil then socket.Free;
  except
  end;

  try
    if stream<>nil then FreeHandleStream(stream);
  except
  end;

  inherited Destroy;
end;


{ TWriteCache }

procedure TWriteCache.flush;
begin
  helper_diskio.MyFileSeek(FStream,FCurrentDiskOffset,ord(soFromBeginning));
  FStream.write(FBuffer[0],FCurrentInternalOffset);
  inc(FCurrentDiskOffset,FCurrentInternalOffset);
  FCurrentInternalOffset := 0;
end;

Procedure TWriteCache.write(data: Pointer; len: Cardinal);
begin
  if len+FCurrentInternalOffset>length(FBuffer) then Flush;

  move(data^,FBuffer[FCurrentInternalOffset],len);
  inc(FCurrentInternalOffset,len);
end;


constructor TWriteCache.create(stream: THandleStream; DiskOffset: Int64);
begin
  inherited create;

  FStream := stream;
  FCurrentDiskOffset := diskoffset;
  FCurrentInternalOffset := 0;
  SetLength(Fbuffer,65536{16384}{8192});
end;

destructor TWriteCache.Destroy;
begin
  if FCurrentInternalOffset > 0 then Flush;
  SetLength(FBuffer,0);

  inherited Destroy;
end;

end.