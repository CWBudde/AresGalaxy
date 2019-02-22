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
download thread, Ares support pseudo-HTTP download protocol and custom partial-sharing protocol
}

unit thread_download;

interface

uses
  Classes,windows,sysutils,blcksock,synsock,
  registry,ares_types,ares_objects,comettrees,
  const_ares,classes2,graphics,helper_graphs,
  tntwindows,class_cmdlist,winsock,const_commands_pfs,
  btCore;

type
  tthread_download = class(TThread)
  protected

  testo: string;
  tempo,last_receive_tick,last_out_graph: Cardinal;

  totp,totd: Integer; // per alleggerire carico synchronize eventuale update treeview
  brecv,brecvmega,bsentmega: Int64;
  limite_download_leech: Boolean; // un download alla volta se modifichi la banda....

  last_check,last_check_5_sec,last_check_5_dec: Cardinal;
  last_partial,last_check_10minutes: Cardinal;

  loc_is_connecting: Boolean; //SP2 don't flood of SYN_SENT while prioritary process are taking place
  loc_outgoing_connections: Integer;

  buffer2_ricezione,buffer3_ricezione: array [0..1023] of Byte;   //20k! il 3 è per decrypt on the fly
  buffer_ricezione_partial: array [0..4095] of Byte;
  m_partialUpload_sent: Int64;
  crcglobale: Word;
  hashglobale: string;
  socket_globale_longint:longint;
  lista_socket_temp_flush,tempDownloads: TMylist;

  ip_global: Cardinal;
  port_global: Word;

  m_graphObject: Cardinal;
  FirstGraphSample:precord_graph_sample;
  LastGraphSample:precord_graph_sample;
  NumGraphStats: Word;
  m_graphWidth: Word;
  Frestart_player: Boolean;

  procedure freeSource;
  procedure AddVisualNewSources;
  procedure AddVisualDownload; //sync
  procedure put_ShouldupdateClientHashes; //sync
  procedure DelDownload;
  procedure UpdateVisualDownload;
  procedure CheckDownloadsStatus;

    function ebx(idx: Byte; b: Byte): Integer;
    function eax(idx: Byte; b: Byte): Integer;
    function de_parz(s: string): string;
    function en_parz(s: string): string;
    procedure UpdateVisualBitField; //sync
    procedure check_visual_phash;



    procedure GraphCreateFirstSamples;
    procedure GraphUpdate;  //synchronize
    procedure GraphDeal(callsynch:boolean);
    procedure GraphAddSample(Value: Cardinal);
    procedure GraphCheckSync;
    procedure GraphIncrement(Elapsed:integer);


    procedure Execute; override;
    procedure check_five_seconds;
    procedure check_second;
    procedure check_half_second;
    procedure init_vars;
    procedure create_lists;

    procedure check_UDPSources(download: Tdownload; Risorsa: TRisorsa_download); 
    function sourceReceiveUDPServerAck(risorsa: TRisorsa_download): Boolean;
    procedure sourceSendUDPPush(risorsa: TRisorsa_download);
    procedure sourceSendUdpFileRequest(risorsa: Trisorsa_download); // send request of hash file to remote firewalled user
    function sourceReceiveUDPFilePiece(risorsa: TRisorsa_download): Boolean; // receive the requested piece
    function sourceReceiveUDPFileReply(risorsa: TRisorsa_download): Boolean;
    procedure sourceSendUDPICHRequest(risorsa: TRisorsa_download);
    function sourceReceiveUDPICHData(risorsa: TRisorsa_download): Boolean;
    procedure UDP_CompleteICH(download: TDownload; risorsa: TRisorsa_download);
    procedure sourceSendUDPPieceRequest(download: TDownload; risorsa: TRisorsa_download);
    procedure addUDPHeaders(var offset: Integer; download: TDownload; risorsa: Trisorsa_download; buffer:pchar);


    procedure check_ICH_recv(downloaD: TDownload; risorsa: TRisorsa_download);
    procedure ICH_delete_unused_phashes;

    procedure update_lastbitofhint; //synch
    procedure add_downloads_recursive(const folder: WideString; depth:integer);
    procedure pause_locally_downloads(max_dl_allowed: Integer; num_down_attivi:integer);
    procedure unpause_locally_paused_downloads;
    procedure unpause_locally(howmany:integer);
    procedure pause_locally(howmany:integer);
    procedure unleech_1_download;
    procedure unleech_all_downloads;
    procedure leech_pause_download;

    procedure ActivateSources; overload;
    procedure ActivateSources(download: Tdownload; num_max_sources:integer); overload;
    procedure ActivateSources(download: Tdownload); overload;

    procedure ReceiveRequestResponses(download: TDownload; risorsa: TRisorsa_download); 
    procedure ParseResponse(download: TDownload; risorsa: TRisorsa_download; lenHeader:integer);

    function get_HTTPnickname(headerlist: TMylist): string;
    function get_HTTPagent(risorsa: TRisorsa_download; headerlist: TMylist): string;
    procedure check_HTTP_PartialSources(download: TDownload; risorsa: TRisorsa_Download; headerlist: TMylist);
    procedure check_HTTPHostINFO(risorsa: TRisorsa_download; headerlist: TMylist);
    function check_HTTP_SizeMagnet(download: TDownload; risorsa: TRisorsa_download; headerlist: TMylist): Boolean;
    procedure check_HTTP_AlternateSources(download: TDownload; risorsa: TRisorsa_Download; headerlist: TMylist);
    function check_HTTP_contentrange(download: TDownload; risorsa: TRisorsa_download; headerlist: TMylist): Boolean;
    function check_HTTP_XQueued(download: TDownload; risorsa: TRisorsa_Download; HeaderList: TMylist): Boolean;
    function check_HTTP_ICHIdx(download: TDownload; risorsa: TRisorsa_download; HTTPBody: string; HeaderList: TMylist): Boolean;


    procedure push_add(risorsa: Trisorsa_download);
    procedure Push_Start_Request; overload;
    procedure Push_Start_Request(download: TDownload; tempo: Cardinal); overload;
    procedure push_deal; //ogni mezzo secondo
    procedure push_flush_out(download: Tdownload);
    procedure push_check_timeout_sent(download: Tdownload);   //attendo dieci secondi dopo invio per essere sicuro di aver inviato a server
    procedure push_metti_null_server_arisorsa(download: Tdownload);  //push consegnato, ora il server mi ha detto di annà a frascati
    procedure push_check_timeout_connection(download: Tdownload);
    procedure push_assegna_stato_firewalled(download: Tdownload);
    procedure push_incapace(download: Tdownload);
    procedure push_expire_old;

    procedure check_DLcounts(num_down_att:integer);
    procedure CheckConnection(download: TDownload; risorsa: TRisorsa_download); overload;
    procedure CheckSources(download: TDownload); overload;
    procedure CheckSources; overload;

    procedure prendi_socket_accept;
    procedure dosynch_vars;    //synch  e prendiamo anche download da form1
    procedure ProcessTempDownloads(dummy:boolean); overload;
    procedure ProcessTempDownloads; overload;

    function drop_one_trying_source(download: Tdownload): Boolean;
    procedure push_assegna_arrivo_socket_a_risorsa(socket: Ttcpblocksocket);
    function DoIdleSlowestSource(download: Tdownload;risorsa: Trisorsa_download): Boolean;

    procedure ReceiveFiles; overload;
    procedure ReceiveFiles(Tempo: Cardinal); overload;
    procedure ReceiveFiles(BytesToRecv: Integer; Cicles: Integer; Tempo: Cardinal); overload;
    procedure ReceiveSource(risorsa: TRisorsa_download; Tempo: Cardinal; indexInList:integer); overload;
    procedure ReceiveSource(risorsa: TRisorsa_download; Tempo: Cardinal; indexInList: Integer; loops: Integer; BytesToRecv:integer); overload;

    procedure RemoveFromDuty(risorsa: Trisorsa_download);
    procedure SourceTerminatedOnDuty(risorsa: Trisorsa_download);
    function BeginDownload(risorsa: Trisorsa_download;download: Tdownload; HTTPBody: string): Byte;
    procedure termina_download_download(download: Tdownload;pulisci: Boolean;remove_from_memory: Boolean; leaveVisual:boolean=false); // terminiamo download nella lista
    procedure update_status;

    procedure SourceFlushRequest(download: Tdownload;risorsa: TRisorsa_download);

    procedure DownloadDoComplete(download: Tdownload);
    procedure SourceDoIdle(risorsa: Trisorsa_download; destroy_socket:boolean);
    procedure SourceDestroy(risorsa: Trisorsa_download; fast: Boolean; addToBanList:boolean=false);
    procedure pausa_risorse(download: Tdownload);
    procedure unpausa_risorse(download: Tdownload);
    procedure prendi_risorse_da_loc_temp;
    procedure SourcesGetAvailable;

    procedure checkPreviewedFile; //sync
    procedure restartPreview;  //sync
    
    procedure update_size_download_visual; //synch da ricevi risposte, ho finalmente size di sto sha1 magnet URI
    procedure SyncStats; //synch
    procedure update_hint(node:PCmtVNode); overload; //synch
    procedure update_hint(node:pCmtVnode; treeview: Tcomettree); overload;

    procedure update_hint_phash; //synch
    function elimina_queued_peggiore(download: Tdownload): Boolean;
    procedure start_update_treeview; //synch
    procedure end_update_treeview; //synch
    procedure delete_lists;
    procedure Sources_Save;
    //procedure drop_corrupting_sources_ip(risorsa: Trisorsa_download);
     procedure DHT_add_possible_bootstrap_client;
     procedure DHT_check_bootstrap_build_number(const agent: string; ip: Cardinal; port:word);
    end;

    procedure dec_download_num(download: TDownload);


    var
     down_general: Tdownload;
     risorsa_general: Trisorsa_download;
     download_globale: Tdownload; //per synch vari risorse napster...
     lista_download: TMylist;
     SourcesOnDuty: TMylist;
     loc_lista_temp_risorse: TMylist;
     sockets_accepted: TMylist;

     loc_velocita_up: Word;
     loc_ksent: Integer;
     loc_muptime: Cardinal;
     localip: string;
     my_port: Word;
     my_nick: string;
     loc_files_condivisi: Word;
     loc_numero_uploads: Byte; // per send in stats
     speed_down_max,loc_speed_down: Integer;
     loc_numero_down: Integer;
     download_bandwidth: Cardinal;


implementation

uses
 ufrmmain,utility_ares,helper_sorting,vars_global,vars_localiz,
 helper_strings, helper_crypt,helper_unicode,helper_urls,helper_diskio,
 helper_ipfunc,helper_mimetypes,helper_datetime,const_commands,
 helper_sockets,helper_registry,helper_base64_32,th_rbld,
 helper_http,helper_download_misc,const_timeouts,const_udpTransfer,
 helper_altsources,helper_download_disk,helper_bighints,secureHash,
 helper_ICH,BitTorrentUtils,BitTorrentDlDb,const_supernode_commands,
 helper_preview,helper_player,helper_ares_nodes;


procedure tthread_download.DHT_check_bootstrap_build_number(const agent: string; ip: Cardinal; port:word);
var
version: string;
buildno: Integer;
begin
if pos('ares ',lowercase(trim(agent)))<>1 then exit;

version := trim(agent);
delete(version,1,pos(' ',version));
 delete(version,1,pos('.',version));
 delete(version,1,pos('.',version));
 delete(version,1,pos('.',version));
 buildno := strtointdef(version,0);


 if buildno>=DHT_SINCE_BUILD then begin
  ip_global := ip;
  port_global := port;
  synchronize(DHT_add_possible_bootstrap_client);
 end;
end;

procedure tthread_download.DHT_add_possible_bootstrap_client;
begin
if ip_global=0 then exit;
if port_global=0 then exit;
DHT_possibleBootstrapClientIP := ip_global;
DHT_possibleBootstrapClientPort := port_global;
end;

procedure tthread_download.dosynch_vars;    //prendiamo download da form1
begin
try
download_bandwidth := vars_global.down_band_allow;
limite_download_leech := ((vars_global.up_band_allow>0) and (vars_global.up_band_allow<LEECH_MIN_BANDWIDTH));
localip := vars_global.localip;
my_port := vars_global.myport;
my_nick := vars_global.mynick;
loc_muptime := vars_global.muptime;
loc_ksent := vars_global.bytes_sent div KBYTE;
loc_velocita_up := vars_global.velocita_up div 100;
speed_down_max := vars_global.velocita_down;
loc_files_condivisi := vars_global.my_shared_count;
loc_numero_uploads := vars_global.numero_upload; // per send in stats

loc_is_connecting := ((vars_global.logon_time=0) and (not ares_frmmain.btn_opt_disconnect.down));

 try
 prendi_socket_accept;
 except
 end;

 try
  ProcessTempDownloads;
 except
 end;

 try
  GraphCheckSync;
 except
 end;

except
end;
end;


procedure tthread_download.ProcessTempDownloads;
var
down: Tdownload;
begin

  while (vars_global.lista_down_temp.count>0) do begin
   down := vars_global.lista_down_temp[vars_global.lista_down_temp.count-1];
         vars_global.lista_down_temp.delete(vars_global.lista_down_temp.count-1);
   tempDownloads.add(down);
  end;
  
end;

procedure tthread_download.ProcessTempDownloads(dummy:boolean);
begin
try


while (tempDownloads.count>0) do begin
    down_general := tempDownloads[tempDownloads.count-1];
                  tempDownloads.delete(tempDownloads.count-1);

     try
      resume_db(down_general);
     except
     end;


     if lista_download.count>0 then lista_download.insert(0,down_general)
      else lista_download.add(down_general);   //at the end...better local pause system

   pause_locally_downloads(vars_global.max_dl_allowed,activedownload_count);

   vars_global.changed_download_hashes := True;
end;

except
end;
end;


procedure tthread_download.GraphDeal(callsynch:boolean);
var
Elapsed: Cardinal;
begin

try
Elapsed := gettickcount-last_out_graph;

if Elapsed<GRAPH_TICK_TIME then exit;
last_out_graph := gettickcount;

if callsynch then begin
 synchronize(GraphUpdate);
end else begin
 GraphUpdate; // already in synch
end;

GraphIncrement(Elapsed);

except
end;
end;

procedure tthread_download.GraphCreateFirstSamples;
begin
helper_graphs.GraphCreateFirstSamples(FirstGraphSample,LastGraphSample,NumGraphStats);
end;

procedure tthread_download.GraphIncrement(Elapsed:integer);   //il tick del campione grafico
begin
helper_graphs.GraphIncrement(FirstGraphSample,LastGraphSample,NumGraphStats,m_graphWidth,Elapsed);
end;


procedure tthread_download.GraphAddSample(Value: Cardinal);
begin
if FirstGraphSample=nil then exit;
FirstGraphSample^.sample := FirstGraphSample^.sample+Value;
end;

procedure tthread_download.GraphCheckSync;
begin
if ((vars_global.handle_obj_GraphHint=INVALID_HANDLE_VALUE) or
   (vars_global.formhint.posygraph=-1)) then begin
    GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats);
    m_graphObject := INVALID_HANDLE_VALUE;
    exit;
end;

if ((ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER) or
    (vars_global.formhint.top=10000) or
    (not vars_global.graphIsDownload)) then begin
    GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats);
    m_graphObject := INVALID_HANDLE_VALUE;
    exit;
end;

if not vars_global.graphIsDownload then exit;

if ((vars_global.handle_obj_GraphHint<>INVALID_HANDLE_VALUE) and
    (vars_global.formhint.posygraph<>-1)) then begin

  if m_graphObject<>vars_global.handle_obj_GraphHint then
   if m_graphObject<>INVALID_HANDLE_VALUE then GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats); // new graph needed clear previous data
end;

if m_graphObject<>vars_global.handle_obj_GraphHint then GraphCreateFirstSamples;

m_graphObject := vars_global.handle_obj_GraphHint;  //sync to our local target object
m_graphWidth := vars_global.formhint.GraphWidth;
end;

procedure tthread_download.GraphUpdate;  //synchronize
begin
helper_graphs.GraphUpdate(FirstGraphSample^.next);
end;

procedure tthread_download.ICH_delete_unused_phashes;
var
 dirinfo: TsearchrecW;
 doserror: Integer;
 i,iterations: Integer;
 down: Tdownload;
 found: Boolean;
 hash_comp: string;
begin
iterations := 0;
doserror := helper_diskio.FindFirstW(data_path+'\Data\TempDL\PHash_*.dat',faanyfile,dirinfo);
while (doserror=0) do begin

     if ((dirinfo.name=chr(46){'.'}) or
         (dirinfo.name=chr(46)+chr(46){'..'}) or
         ( (dirinfo.attr and FADIRECTORY)>0 )) then begin
         doserror := helper_diskio.FindNextW(dirinfo);
         continue;
         end;

    hash_comp := hexstr_to_bytestr(copy(dirinfo.name,7,40));

   found := False;
   for i := 0 to lista_download.count-1 do begin
    down := lista_download[i];
    if down.hash_sha1<>hash_comp then continue;
     found := True;
     break;
   end;

   if not found then begin
    deletefileW(data_path+'\Data\TempDL\'+dirinfo.name);
   end;


   doserror := helper_diskio.FindNextW(dirinfo);

   inc(iterations);
   if iterations>500 then break;
end;

helper_diskio.FindCloseW(dirinfo);
end;

procedure tthread_download.add_downloads_recursive(const folder: WideString; depth:integer);
var
dirinfo: TsearchrecW;
doserror: Integer;
download: Tdownload;
dira: WideString;
size: Int64;
iterations: Integer;
begin
iterations := 0;
doserror := helper_diskio.FindFirstW(folder+'\___ARESTRA___'+const_ares.STR_ANYFILE_DISKPATTERN,faanyfile,dirinfo);
while (doserror=0) do begin

     if ((dirinfo.name=chr(46){'.'}) or
         (dirinfo.name=chr(46)+chr(46){'..'}) or
         ( (dirinfo.attr and FADIRECTORY)>0 )) then begin
         doserror := helper_diskio.FindNextW(dirinfo);
         continue;
         end;

     size := gethugefilesize(folder+'\'+dirinfo.name);

     if size<4096 then begin
       helper_diskio.deletefileW(folder+'\'+dirinfo.name);
       doserror := helper_diskio.FindNextW(dirinfo);

        inc(iterations);
        if iterations>100 then break;

       continue;
     end;


     download := tdownload.create;
      download.filename := widestrtoutf8str(folder+'\'+dirinfo.name);
      download.tipo := extstr_to_mediatype(lowercase(extractfileext(download.filename)));
      if download.tipo<>ARES_MIME_VIDEO then download.aviHeaderState := aviStateNotAvi;
     lista_download.add(download);

      down_general := download;
      synchronize(AddVisualDownload);

      try
       helper_download_disk.resume_db(download);
      except
      end;

      down_general := download;
      synchronize(UpdateVisualDownload);

   doserror := helper_diskio.FindNextW(dirinfo);

   inc(iterations);
   if iterations>50 then break;
 end;

 helper_diskio.FindCloseW(dirinfo);

 inc(depth);
 if depth>10 then exit;

 //now search subfolders
 dira := folder;
 iterations := 0;
 try
 DosError := helper_diskio.FindFirstW(folder+'\'+const_ares.STR_ANYFILE_DISKPATTERN, faDirectory, dirinfo);
      while (DosError=0) do begin
      
      if terminated then exit;
       if (((dirinfo.attr and faDirectory) = 0) or
             (dirinfo.name = chr(46){'.'}) or
             (dirinfo.name = chr(46)+chr(46){'..'})) then begin
              DosError := helper_diskio.FindNextW(dirinfo);
              continue;
        end;

         add_downloads_recursive(dira+'\'+dirinfo.name,depth); {Time for the recursion!}

        DosError := helper_diskio.FindNextW(dirinfo); {Look for another subdirectory}

         inc(iterations);
         if iterations>50 then break;

     end;

     finally
     helper_diskio.FindCloseW(dirinfo);
     end;


end;

procedure tthread_download.AddVisualDownload; //sync
begin
down_general.addVisualReference;
end;

procedure tthread_download.UpdateVisualDownload;
begin
helper_download_misc.UpdateVisualDownload(down_general);
end;


procedure tthread_download.DelDownload; //sync
begin
down_general.Free;
end;

procedure tthread_download.check_half_second;
begin

 last_check_5_dec := tempo;

  synchronize(dosynch_vars);
  ProcessTempDownloads(true); // temp downloads out of sync
  CheckSources;

  sleep(5);
end;


procedure tthread_download.check_UDPSources(download: Tdownload; Risorsa: TRisorsa_download);
begin

case risorsa.state of

 srs_UDPPushing:begin
                if sourceReceiveUDPServerAck(risorsa) then exit;
                if risorsa.unAckedPackets>=5 then begin
                 risorsa.RemoveServer(risorsa.CurrentUDPPushSupernode);
                 SourceDoIdle(risorsa,false);
                end else sourceSendUDPPush(risorsa);
               end;

 srs_waitingForUserUdpAck:begin
                           if sourceReceiveUDPFileReply(risorsa) then exit;
                           if risorsa.unAckedPackets>=5 then SourceDoIdle(risorsa,false)
                            else sourceSendUDPFileRequest(risorsa);
                          end;

 srs_UDPreceivingICH:begin
                 if sourceReceiveUDPICHData(risorsa) then exit;
                 if risorsa.unAckedPackets>=5 then SourceDoIdle(risorsa,false)
                   else sourceSendUDPICHRequest(risorsa);
              end;

 srs_waitingForUserUDPPieceAck,
 srs_UDPDownloading:begin
                     if sourceReceiveUDPFilePiece(risorsa) then exit;
                     if risorsa.unAckedPackets>=5 then SourceDoIdle(risorsa,false)
                      else sourceSendUDPPieceRequest(download,risorsa);
                    end;
end;
end;

procedure tthread_download.sourceSendUDPPush(risorsa: TRisorsa_download);
var
Sin: TVarSin;
buffer: array [0..28] of Byte;
num32,ip_server: Cardinal;
port_server: Word;
download: TDownload;
begin
if tempo-risorsa.lastUDPOut<risorsa.nextUDPOutInterval then exit;

 risorsa.nextUDPOutInterval := (risorsa.nextUDPOutInterval shl 1);
 risorsa.lastUDPOut := tempo;

 inc(risorsa.unAckedPackets);
 download := risorsa.download;

 // add source's ip, donwload hash and source handle to outbuffer
 buffer[0] := CMD_UDPTRANSFER_PUSH;
 move(risorsa.ip,buffer[1],4);
 move(download.hash_sha1[1],buffer[5],20);
 num32 := cardinal(risorsa);
 move(num32,buffer[25],4);

 // send packet to source's supernode
 if risorsa.CurrentUDPPushSupernode=0 then begin
  risorsa.GetFirstServerDetails(ip_server,port_server);
  risorsa.CurrentUDPPushSupernode := ip_server;
 end;


 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(port_server);
 Sin.sin_addr.s_addr := ip_server;

 synsock.SendTo(risorsa.UDP_socket,
                buffer,
                29,
                0,
                @Sin,
                SizeOf(Sin));
end;

function tthread_download.sourceReceiveUDPServerAck(risorsa: TRisorsa_download): Boolean;
var
er,len,len_recvd: Integer;
RemoteSin: TVarSin;
buffer: array [0..49] of Byte;
begin
result := False;

if not TCPSocket_canRead(risorsa.UDP_socket,0,er) then exit;

 len := SizeOf(RemoteSin);
 FillChar(RemoteSin,0,sizeof(RemoteSin));

 len_recvd := synsock.RecvFrom(risorsa.UDP_socket,
                             Buffer,
                             sizeof(buffer),
                             0,
                             @RemoteSin,
                             len);

 if len_recvd<1 then exit;

 Result := True;



 // client replied before server's response got through
 if cardinal(RemoteSin.sin_addr.S_addr)<>risorsa.CurrentUDPPushSupernode then begin
  if cardinal(RemoteSin.sin_addr.S_addr)<>risorsa.ip then exit; //what is going on?

   risorsa.UDPNatPort := synsock.htons(RemoteSin.sin_port);
     if len_recvd=1 then
      if buffer[0]=CMD_UDPTRANSFER_FILEPING then begin   // NAT punch succeded...request file
       risorsa.state := srs_waitingForUserUdpAck;
       risorsa.unackedPackets := 0;
       sourceSendUDPFileRequest(risorsa);
      end;
   exit;
 end;


 if len_recvd<29 then begin
  risorsa.RemoveServer(RemoteSin.sin_addr.S_addr);
  SourceDoIdle(risorsa,false);
  exit;
 end;



 case buffer[0] of

  CMD_UDPTRANSFER_PUSHFAIL1:begin // user not available on supernode
                              risorsa.RemoveServer(RemoteSin.sin_addr.S_addr);
                              SourceDoIdle(risorsa,false);
                            end;

  CMD_UDPTRANSFER_PUSHFAIL2:begin // user isn't using UDP ping (not firewall, but not reachable by us??, older version?)
                              risorsa.RemoveServer(RemoteSin.sin_addr.S_addr);
                              SourceDoIdle(risorsa,false);
                            end;

  CMD_UDPTRANSFER_PUSHACK:begin  //user alive and kicking, get his NAT port and send request
                            move(buffer[1],risorsa.UDPNatPort,2);
                            risorsa.state := srs_waitingForUserUdpAck;
                            risorsa.unackedPackets := 0;
                            risorsa.nextUDPOutInterval := 1000;
                            risorsa.lastUDPOut := 0;
                            sourceSendUDPFileRequest(risorsa);
                          end;

  end;

end;

procedure tthread_download.sourceSendUDPFileRequest(risorsa: Trisorsa_download);
var
download: TDownload;
buffer: array [0..24] of Byte;
Sin: TVarSin;
num32: Cardinal;
begin
if tempo-risorsa.lastUDPOut<risorsa.nextUDPOutInterval then exit;

 risorsa.nextUDPOutInterval := (risorsa.nextUDPOutInterval shl 1);
 risorsa.lastUDPOut := tempo;
 inc(risorsa.unAckedPackets);

download := risorsa.download;

 // download's hash and self handle
 buffer[0] := CMD_UDPTRANSFER_FILEREQ;
 move(download.hash_sha1[1],buffer[1],20);
 num32 := cardinal(risorsa);
 move(num32,buffer[21],4);

 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(risorsa.UDPNatPort);
 Sin.sin_addr.s_addr := risorsa.ip;

 synsock.SendTo(risorsa.UDP_socket,
                buffer,
                25,
                0,
                @Sin,
                SizeOf(Sin));
end;

function tthread_download.sourceReceiveUDPFileReply(risorsa: TRisorsa_download): Boolean;
var
er,len_recvd,len: Integer;
RemoteSin: TVarSin;
buffer: array [0..99] of Byte;
num32: Cardinal;
download: TDownload;
begin
result := False;

if not TCPSocket_canRead(risorsa.UDP_socket,0,er) then exit;

 len := SizeOf(RemoteSin);
 FillChar(RemoteSin,0,sizeof(RemoteSin));
 len_recvd := synsock.RecvFrom(risorsa.UDP_socket,
                             Buffer,
                             sizeof(buffer),
                             0,
                             @RemoteSin,
                             len);

 if len_recvd<1 then exit;

 Result := True;
 
 if cardinal(RemoteSin.sin_addr.S_addr)<>risorsa.ip then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;
 risorsa.UDPNatPort := synsock.htons(RemoteSin.sin_port);

 if buffer[0]=CMD_UDPTRANSFER_FILEPING then begin  //it's a ping...maybe our first FileRequest didn't get through, send it here again, since it's more likely timing will help NAT punch
  risorsa.state := srs_waitingForUserUdpAck;
  risorsa.unackedPackets := 0;
  risorsa.nextUDPOutInterval := 2000;
  risorsa.lastUDPOut := 0;
  sourceSendUDPFileRequest(risorsa);
  exit;
 end;

 if buffer[0]<>CMD_UDPTRANSFER_FILEREPOK then begin
  SourceDestroy(risorsa,false);   // doesn't have file shared...no use to us
  exit;
 end;

 if len_recvd<25 then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;
 
 download := risorsa.download;
 if not comparemem(@buffer[1],@download.hash_sha1[1],20) then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;

 move(buffer[21],num32,4);
 if num32<>cardinal(risorsa) then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;

 if download.is_getting_phash then begin
  sourceDoIdle(risorsa,false);
  exit;
 end;

 // if we still need ICH checksums, request them here, else go for data chunk
 if ((length(download.FPieces)=0) and
     (download.FPieceSize>0) and
     (download.size>0) and
     (not download.is_getting_phash)) then begin  //should retrieve ICH pieces first, but only 1 source at a time
           with risorsa do begin
            start_byte := 0;
            end_byte := 2;
            global_size := 3;
            if piece<>nil then piece.FinUse := False;
            piece := nil;
            getting_phash := True;
           end;

      risorsa.UDPICHProgress := 0;
      risorsa.unAckedPackets := 0;
      risorsa.nextUDPOutInterval := 1000;
      risorsa.lastUDPOut := 0;
      risorsa.state := srs_UDPreceivingICH;
   sourceSendUDPICHRequest(risorsa);

 end else

 if ((length(download.FPieces)>0) or
     (download.FPieceSize=0)) then begin
  // either we already have ICH data or file is smaller than ICH thresold
   risorsa.state := srs_waitingForUserUDPPieceAck;
   if not source_startbyte_assign(download,risorsa) then sourceDoIdle(risorsa,false) else begin
      risorsa.unAckedPackets := 0;
      risorsa.nextUDPOutInterval := 5000;
      risorsa.lastUDPOut := 0;
      risorsa.progress_su_disco := 0;
      risorsa.state := srs_waitingForUserUDPPieceAck;
      sourceSendUDPPieceRequest(download,risorsa);
   end;

 end else begin
 //
 end;



end;

procedure tthread_download.sourceSendUDPPieceRequest(download: TDownload; risorsa: TRisorsa_download);
var
buffer: array [0..1023] of Byte;
Sin: TVarSin;
num32: Cardinal;
num64: Int64;
num16: Word;
offset: Integer;
begin
try

if tempo-risorsa.lastUDPOut<risorsa.nextUDPOutInterval then exit;
 risorsa.lastUDPOut := tempo;
 inc(risorsa.unAckedPackets);

 try
 // download's hash and self handle + wanted progress and max len
 buffer[0] := CMD_UDPTRANSFER_PIECEREQ;
 move(download.hash_sha1[1],buffer[1],20);
  num32 := cardinal(risorsa);
 move(num32,buffer[21],4);
 num64 := risorsa.progress_su_disco+risorsa.start_byte;
  move(num64,buffer[25],8);
 if risorsa.size_to_receive>UDPTRANSFER_PIECESIZE then num16 := 0 
  else num16 := risorsa.size_to_receive;
 move(num16,buffer[33],2);
 except
 end;
 
 offset := 35;
 
 if risorsa.state=srs_waitingForUserUDPPieceAck then begin // beginning of transfer...send headers
  try
   addUDPHeaders(offset,download,risorsa,@buffer[offset]);
  except
  end;
 end;

 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(risorsa.UDPNatPort);
 Sin.sin_addr.s_addr := risorsa.ip;

except
end;

try
 synsock.SendTo(risorsa.UDP_socket,
                buffer,
                offset,
                0,
                @Sin,
                SizeOf(Sin));
except
end;
end;

procedure tthread_download.addUDPHeaders(var offset: Integer; download: TDownload; risorsa: Trisorsa_download; buffer:pchar);
var
outBuf: string;
strTemp: string;
strVers: string;
begin
strVers := appname+CHRSPACE+vars_global.versioneares;

   outBuf := int_2_word_string(length(strVers))+chr(TAG_ARESHEADER_AGENT)+
           strVers+
           int_2_word_string(length(vars_global.mynick))+chr(TAG_ARESHEADER_NICKNAME)+
           vars_global.mynick;

   StrTemp := helper_download_misc.stats_to_str(download);
   outBuf := outBuf+int_2_word_string(length(strTemp))+chr(TAG_ARESHEADER_XSTATS2)+strTemp;

   strTemp := helper_ipfunc.serialize_myConDetails;
   outBuf := outBuf+int_2_word_string(length(strTemp))+chr(TAG_ARESHEADER_HOSTINFO2)+strTemp;

   strTemp := helper_altsources.get_altsource_string(download,risorsa,true);
   outBuf := outBuf+int_2_word_string(length(strTemp))+chr(TAG_ARESHEADER_ALTSSRC)+strTemp;

 move(outBuf[1],buffer^,length(outBuf));
 inc(offset,length(outBuf));
end;

function tthread_download.sourceReceiveUDPFilePiece(risorsa: TRisorsa_download): Boolean;
var
len,er: Integer;
RemoteSin: TVarSin;
buffer: array [0..9999] of Byte;
len_recvd: Integer;
download: TDownload;
num32: Cardinal;
offSetInFile: Int64;
offsetData,lenData: Word;
lenPayload: Word;
tagID: Byte;
agent,nickname,tempstr,HashChecksum: string;
sha1: TSha1;
begin
result := False;
try

if not TCPSocket_canRead(risorsa.UDP_socket,0,er) then exit;

 len := SizeOf(RemoteSin);
 FillChar(RemoteSin,0,sizeof(RemoteSin));
 len_recvd := synsock.RecvFrom(risorsa.UDP_socket,
                             Buffer,
                             sizeof(buffer),
                             0,
                             @RemoteSin,
                             len);



 if cardinal(RemoteSin.sin_addr.S_addr)<>risorsa.ip then begin   // is the source's address correct?
  exit;
 end;
 risorsa.UDPNatPort := synsock.htons(RemoteSin.sin_port);
 
 if len_recvd<33 then begin  // some other packet?
  exit;
 end;

  download := risorsa.download;
 if not comparemem(@buffer[1],@download.hash_sha1[1],20) then begin  // not related to this download?
  SourceDoIdle(risorsa,false);
  exit;
 end;


 move(buffer[21],num32,4);
 if num32<>cardinal(risorsa) then begin  // not related to this source?
  SourceDoIdle(risorsa,false);
  exit;
 end;




 if buffer[0]<>CMD_UDPTRANSFER_ICHPIECEREP then begin  // wrong/busy reply
  //parse error reply
   case buffer[0] of
    CMD_UDPTRANSFER_PIECEBUSY:begin    // parse QUEUED header here...contains nickname and altsources
                                 offsetData := 33;
                                 while (offsetData<len_recvd) do begin
                                  move(buffer[offsetData],lenPayload,2);
                                  tagID := buffer[offsetData+2];
                                  inc(offsetData,3);
                                  case tagID of
                                   TAG_ARESHEADER_AGENT:begin
                                       if lenPayload>0 then begin
                                        SetLength(agent,lenPayload);
                                        move(buffer[offsetData],agent[1],lenPayload);
                                        if pos(' ',agent)>0 then risorsa.version := copy(agent,pos(' ',agent)+1,length(agent))
                                         else risorsa.version := getfirstNumberStr(agent);
                                        agent := ucfirst(get_first_word(strip_vers(agent)));
                                       end else agent := APPNAME;
                                   end;
                                   TAG_ARESHEADER_NICKNAME:begin
                                         if lenPayload>0 then begin
                                          SetLength(nickname,lenPayload);
                                          move(buffer[offsetData],nickname[1],lenPayload);
                                         end else nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2);
                                   end;
                                   TAG_ARESHEADER_HOSTINFO2:begin
                                        SetLength(tempStr,lenPayload);
                                        move(buffer[offsetData],tempStr[1],lenPayload);
                                        //skip ip_user
                                        risorsa.porta := chars_2_word(copy(tempStr,5,2));
                                        risorsa.ip_interno := chars_2_dword(copy(tempStr,7,4));
                                        risorsa.InsertServers(copy(tempStr,11,length(tempStr)));
                                        helper_ares_nodes.aresnodes_add_candidates(risorsa.his_servers,ares_aval_nodes);
                                   end;
                                   TAG_ARESHEADER_ALTSSRC:begin
                                     SetLength(tempStr,lenPayload);
                                     move(buffer[offsetData],tempStr[1],lenPayload);
                                     helper_altsources.parse_Binary_altsources(download,tempStr);
                                   end else begin

                                    break;
                                   end;
                                end;
                             inc(offsetData,lenPayload);
                              end;  //endof while parse header
                               risorsa.next_poll := gettickcount+60000;
                               risorsa.queued_position := 102;
                               SourceDoIdle(risorsa,false);
                               Result := True;
                              end;
    CMD_UDPTRANSFER_PIECEERR:begin
                              Result := True;
                              SourceDestroy(risorsa,false);
                              exit;
                             end;
    CMD_UDPTRANSFER_XSIZEREP:begin
                             Result := True;
                             end;
   end;

           if ((length(nickname)>0) and
              (length(agent)>0)) then risorsa.nickname := nickname+'@'+agent
            else
             if length(agent)>0 then risorsa.nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2)+'@'+agent
              else begin
                if length(risorsa.nickname)<2 then
                 risorsa.nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2)+STR_UNKNOWNCLIENT;
              end;
 exit;
 end;


 move(buffer[25],offsetInFile,8); // chunk position check
 if offsetInFile<>risorsa.progress_su_disco+risorsa.start_byte then begin
  exit;
 end;




 Result := True;

 try
 // start transfer
 if risorsa.state=srs_waitingForUserUDPPieceAck then begin  // were we waiting for headers (first piece request)
  with risorsa do begin
   size_to_receive := (end_byte-start_byte)+1;
   speed := 0;
   progress := 0;
   progress_su_disco := 0;
   bytes_prima := 0;
   queued_position := 0;
   tick_attivazione := gettickcount;
   last_in := tick_attivazione;
   started_time := tick_attivazione;   //compare worst speed
   state := srs_UDPDownloading; //next time don't send header...
  end;
  download.state := dlDownloading;
  inc(download.num_in_down);
 end;
 except
 end;

 offSetData := 33;
 HashChecksum := ''; //#3005 support this

 try

 if buffer[offsetData+2]<>TAG_ARESHEADER_DATA then begin //parse header

  while (offsetData<len_recvd) do begin
    move(buffer[offsetData],lenPayload,2);
    tagID := buffer[offsetData+2];
    inc(offsetData,3);
     case tagID of
      TAG_ARESHEADER_AGENT:begin
                           if lenPayload>0 then begin
                            SetLength(agent,lenPayload);
                            move(buffer[offsetData],agent[1],lenPayload);
                            if pos(' ',agent)>0 then risorsa.version := copy(agent,pos(' ',agent)+1,length(agent))
                             else risorsa.version := getfirstNumberStr(agent);
                            agent := ucfirst(get_first_word(strip_vers(agent)));
                           end; // else agent := APPNAME;
      end;
      TAG_ARESHEADER_NICKNAME:begin
                           if lenPayload>0 then begin
                             SetLength(nickname,lenPayload);
                             move(buffer[offsetData],nickname[1],lenPayload);
                           end; // else nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2);
      end;
      TAG_ARESHEADER_HOSTINFO2:begin
                               SetLength(tempStr,lenPayload);
                               move(buffer[offsetData],tempStr[1],lenPayload);
                                //skip ip_user
                                risorsa.porta := chars_2_word(copy(tempStr,5,2));
                                risorsa.ip_interno := chars_2_dword(copy(tempStr,7,4));
                                risorsa.InsertServers(copy(tempStr,11,length(tempStr)));
                                helper_ares_nodes.aresnodes_add_candidates(risorsa.his_servers,ares_aval_nodes);
      end;
      TAG_ARESHEADER_ALTSSRC:begin
                               SetLength(tempStr,lenPayload);
                               move(buffer[offsetData],tempStr[1],lenPayload);
                               helper_altsources.parse_Binary_altsources(download,tempStr);
      end;
      TAG_ARESHEADER_DATACHECKSUM:begin  //sha1 of the data
                               SetLength(HashChecksum,20);
                               move(buffer[offsetData],hashCheckSum[1],20);
      end;
      TAG_ARESHEADER_DATA:begin
       lenData := lenPayload;
       // set user details here only if available   03/10/2006
       // (#3007 sends DATACHECKSUM info therefore empty nick and agent used to be assigned here ('@' bug)
           if ((length(nickname)>0) and
              (length(agent)>0)) then risorsa.nickname := nickname+'@'+agent
            else
             if length(agent)>0 then risorsa.nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2)+'@'+agent
              else begin
                 if length(risorsa.nickname)<2 then
                  risorsa.nickname := STR_ANON+inttohex(random($ff),2)+inttohex(random($ff),2)+STR_UNKNOWNCLIENT;
              end;
       break;
      end;

    end;
    inc(offsetData,lenPayload);
  end;

 end else begin
  //simple packet made of headerless data
  move(buffer[offsetData],lenData,2);
  inc(offSetData,3);
 end;
 except
 end;



 try
 if risorsa.piece=nil then
  if length(download.FPieces)>0 then begin
  exit;
 end;

  if len_recvd-offsetData>lenData then begin
   exit;
  end;
 except
 end;



  try
  if length(HashCheckSum)=20 then begin   // checksum verification
   sha1 := TSha1.create;
   sha1.transform(buffer[offSetData], lenData);
   sha1.complete;
   if HashCheckSum<>sha1.hashValue then begin
    sha1.Free;
     risorsa.unAckedPackets := 0;   //rerequest packet
     risorsa.nextUDPOutInterval := 5000;
     risorsa.lastUDPOut := 0;
     sourceSendUDPPieceRequest(download,risorsa);
    exit;
   end;
   sha1.Free;
  end;
 except
 end;


  try
   if risorsa.writecache=nil then risorsa.writecache := TWriteCache.create(download.stream,offsetInFile);
   write_download(download,risorsa,@buffer[offSetData], lenData, offsetInFile );
  except
  end;

      inc(risorsa.progress_su_disco,lenData);

       inc(brecv,lenData);
       inc(brecvmega,lenData);
       risorsa.last_in := tempo;
       dec(risorsa.size_to_receive,lenData);
       inc(risorsa.progress,lenData);
        inc(download.progress,lenData);

        if ((cardinal(download)=m_graphObject) or
            (cardinal(risorsa)=m_graphObject)) then GraphAddSample(lenData);

       if risorsa.size_to_receive<=0 then begin
         dec_download_num(risorsa.download);
         SourceTerminatedOnDuty(risorsa);
        exit;
       end;

 risorsa.unAckedPackets := 0;
 risorsa.nextUDPOutInterval := 5000;
 risorsa.lastUDPOut := 0;
 try
 sourceSendUDPPieceRequest(download,risorsa);
 except
 end;


except
end;

end;

function tthread_download.sourceReceiveUDPICHData(risorsa: TRisorsa_download): Boolean;
var
len,er: Integer;
RemoteSin: TVarSin;
buffer: array [0..1050] of Byte;
len_recvd: Integer;
download: TDownload;
sizeICH,progressPiece,num32: Cardinal;
begin
result := False;

if not TCPSocket_canRead(risorsa.UDP_socket,0,er) then exit;

 len := SizeOf(RemoteSin);
 FillChar(RemoteSin,0,sizeof(RemoteSin));
 len_recvd := synsock.RecvFrom(risorsa.UDP_socket,
                             Buffer,
                             sizeof(buffer),
                             0,
                             @RemoteSin,
                             len);


 if cardinal(RemoteSin.sin_addr.S_addr)<>risorsa.ip then begin
  exit;
 end;
 risorsa.UDPNatPort := synsock.htons(RemoteSin.sin_port);
 
 if len_recvd<29 then begin
  exit;
 end;

 download := risorsa.download;
 if not comparemem(@buffer[1],@download.hash_sha1[1],20) then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;

 move(buffer[21],num32,4);
 if num32<>cardinal(risorsa) then begin
  SourceDoIdle(risorsa,false);
  exit;
 end;

 Result := True;


 case buffer[0] of
 
  CMD_UDPTRANSFER_ICHPIECEREP:begin

                               if len_recvd>33 then begin
                                move(buffer[25],progressPiece,4);
                                move(buffer[29],sizeICH,4);
                                download.phash_stream.seek(progressPiece,soFromBeginning);
                                download.phash_stream.write(buffer[33],len_recvd-33);

                                if len_recvd=1033 then begin //another piece should follow
                                 risorsa.unAckedPackets := 0;
                                 risorsa.nextUDPOutInterval := 1000;
                                 risorsa.lastUDPOut := 0;
                                 risorsa.state := srs_UDPreceivingICH;
                                 sourceSendUDPICHRequest(risorsa); // ask next piece immediately
                                end else UDP_CompleteICH(download,risorsa);

                                // if sizeICH=download.phash_stream.size then begin
                                // end;
                               end;
                              end;

  CMD_UDPTRANSFER_ICHPIECEERR2:UDP_CompleteICH(download,risorsa);

  CMD_UDPTRANSFER_ICHPIECEERR1,
  CMD_UDPTRANSFER_ICHPIECEERR3,
  CMD_UDPTRANSFER_ICHPIECEERR4:begin
                                 if risorsa.getting_phash then begin
                                  download.is_getting_phash := False;
                                  risorsa.getting_phash := False;
                                 end;
                                 SourceDoIdle(risorsa,false);
                                end;
 end;

end;

procedure tthread_download.UDP_CompleteICH(download: TDownload; risorsa: TRisorsa_download);
var
ICH_Completed: Boolean;
begin
   if ICH_corrupt_dl_index(download,risorsa,ICH_completed) then begin
    SourceDoIdle(risorsa,false);
    exit;
   end;
   risorsa.getting_phash := False;
   download.is_getting_phash := False;

   if ICH_Completed then begin

    if download.phash_stream<>nil then FreeHandleStream(download.phash_Stream);
    ICH_loadPieces(download);

    risorsa.state := srs_waitingForUserUdpAck;
    risorsa.unackedPackets := 0;
    risorsa.nextUDPOutInterval := 1000;
    risorsa.lastUDPOut := 0;
    risorsa.progress_su_disco := 0;
    sourceSendUDPFileRequest(risorsa);
    end else begin
    SourceDoIdle(risorsa,false);
    end;
end;

procedure tthread_download.sourceSendUDPICHRequest(risorsa: TRisorsa_download);
var
buffer: array [0..28] of Byte;
Sin: TVarSin;
num32: Cardinal;
download: TDownload;
begin
if tempo-risorsa.lastUDPOut<risorsa.nextUDPOutInterval then exit;

 risorsa.nextUDPOutInterval := (risorsa.nextUDPOutInterval shl 1);
 risorsa.lastUDPOut := tempo;

 inc(risorsa.unAckedPackets);

 download := risorsa.download;
 download.is_getting_phash := True;


 if download.phash_stream=nil then begin
   if not helper_ICH.ICH_start_rcv_indexs(download) then begin
    risorsa.FailedICHDBRet := True;
    SourceDoIdle(risorsa,false);
    exit;
  end;
 end;

 buffer[0] := CMD_UDPTRANSFER_ICHPIECEREQ;
 move(download.hash_sha1[1],buffer[1],20);
 num32 := cardinal(risorsa);
 move(num32,buffer[21],4);
 num32 := download.phash_stream.size;
 move(num32,buffer[25],4);

 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(risorsa.UDPNatPort);
 Sin.sin_addr.s_addr := risorsa.ip;

 synsock.SendTo(risorsa.UDP_socket,
                buffer,
                29,
                0,
                @Sin,
                SizeOf(Sin));
end;





procedure tthread_download.check_second;
begin
      try
      
        synchronize(SyncStats);

        last_check := gettickcount;

        ActivateSources;

        Push_Start_Request;
        push_deal;

        sleep(5);

        if tempo-last_check_5_sec>=5000 then check_five_seconds;


     except
     end;

end;   

procedure tthread_download.check_five_seconds;
begin
     last_check_5_sec := tempo;
     
     push_expire_old;
     SourcesGetAvailable;
     prendi_risorse_da_loc_temp;
end;


procedure tthread_download.init_vars;
begin
  brecv := 0;
  brecvmega := 0;
  bsentmega := 0; //sent partial
  loc_speed_down := 0;

  loc_outgoing_connections := 0;
  m_partialUpload_sent := 0;
  Frestart_player := False;
   last_check := gettickcount;
   last_out_graph := last_check; //output grafico
   last_check_5_sec := last_check;
   last_check_5_dec := last_check;
   last_check_10minutes := last_check;
   last_partial := last_check;
   last_receive_tick := 0;  // per bandwidth
   limite_download_leech := False; // limite su banda troppo bassa...

   m_graphObject := INVALID_HANDLE_VALUE;
   FirstGraphSample := nil;
   LastGraphSample := nil;
   NumGraphStats := 0;
   m_graphWidth := 0;

   synchronize(dosynch_vars);
end;

procedure tthread_download.create_lists;
begin
lista_download := tmylist.create;      // preme da timer form 1 per aggiornamento transfer tab
SourcesOnDuty := tmylist.create;
loc_lista_temp_risorse := tmylist.create;
sockets_accepted := tmylist.create;
lista_socket_temp_flush := tmylist.create;
tempDownloads := tmylist.create;
end;

procedure tthread_download.put_ShouldupdateClientHashes;
begin
vars_global.changed_download_hashes := True;
end;



procedure tthread_download.Execute;
begin
freeonterminate := False;
priority := tpnormal;

sleep(2000);
create_lists;

try
BitTorrentUtils.check_bittorrentTransfers;
except
end;

try
add_downloads_recursive(vars_global.myshared_folder,0);
synchronize(put_ShouldupdateClientHashes);
ICH_delete_unused_phashes;
except
end;

init_vars;



  while not Terminated do begin
       try

   tempo := gettickcount;

    if tempo-last_check_5_dec>504 then check_half_second;

     if tempo-last_check>=SECOND then check_second;

     if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(true);  

      ReceiveFiles;
        sleep(10);

      
 except
 end;
end;

    Sources_Save;

    delete_lists;

end;





procedure tthread_download.Sources_Save;
var
download: Tdownload;
i: Integer;
begin
try

for i := 0 to lista_download.count-1 do begin
download := lista_download[i];
 if isDownloadTerminated(download) then continue;



   if download.ercode<>0 then continue;
   if download.stream=nil then continue;

   if download.lista_risorse.count>1 then download.lista_risorse.sort(ordina_risorsa_per_succesfull_factor);

   if length(download.FPieces)>0 then helper_ich.ICH_SaveDownloadBitField(download);
   update_hole_table(download); //save sources

 sleep(0);

end;

except
end;
end;

procedure tthread_download.delete_lists;
var
download: Tdownload;
risorsa: Trisorsa_download;
socket: Ttcpblocksocket;
begin


try
while (lista_socket_temp_flush.count>0) do begin
 socket := lista_socket_temp_flush[lista_socket_temp_flush.count-1];
    lista_socket_temp_flush.delete(lista_socket_temp_flush.count-1);
 socket.Free;
end;
except
end;

try
lista_socket_temp_flush.Free;
except
end;



try
while (sockets_accepted.count>0) do begin
 socket := sockets_accepted[sockets_accepted.count-1];
         sockets_accepted.delete(sockets_accepted.count-1);
   socket.Free;
end;
sockets_accepted.Free;
except
end;




try
while (lista_download.count>0) do begin
 download := lista_download[lista_download.count-1];
           lista_download.delete(lista_download.count-1);
           termina_download_download(download,false,true);
end;
except
end;

try
lista_download.Free;
SourcesOnDuty.Free;
except
end;


try
while (loc_lista_temp_risorse.count>0) do begin
 risorsa := loc_lista_temp_risorse[loc_lista_temp_risorse.count-1];
 loc_lista_temp_risorse.delete(loc_lista_temp_risorse.count-1);
  risorsa.Free;
end;
except
end;
loc_lista_temp_risorse.Free;


try
tempDownloads.Free;
except
end;

end;


procedure tthread_download.update_size_download_visual; //synch da ricevi risposte, ho finalmente size di sto sha1 magnet URI
begin
 download_globale.display_data^.size := download_globale.size;
 
  download_globale.display_data^.title := download_globale.title;
  download_globale.display_data^.artist := download_globale.artist;
  download_globale.display_data^.album := download_globale.album;
  download_globale.display_data^.category := download_globale.category;
  download_globale.display_data^.language := download_globale.language;
  download_globale.display_data^.date := download_globale.date;
  download_globale.display_data^.comments := download_globale.comments;

 ares_frmmain.treeview_download.invalidatenode(download_globale.display_node);

 update_hole_table(download_globale);
end;

procedure tthread_download.SyncStats;  //synch
var
download: Tdownload;
i,h: Integer;
intero:hsocket;
risorsa: Trisorsa_download;
attuale_vel:double;
loc_num_act: Integer;
begin
vars_global.speedUploadPartial := 0;
vars_global.partialUploadSent := m_partialUpload_sent;
vars_global.downloadedBytes := brecv;

if brecvmega>=MEGABYTE then begin
 inc(vars_global.mega_downloaded);
 brecvmega := 0;
end;
if bsentmega>=MEGABYTE then begin
 inc(vars_global.mega_uploaded);
 bsentmega := 0;
end;

loc_speed_down := 0;
loc_numero_down := 0;
loc_num_act := 0;
tempo := gettickcount;


CheckDownloadsStatus;

for i := 0 to lista_download.count-1 do begin
 download := lista_download[i];
 download.num_in_down := 0;
 download.speed := 0;


  for h := 0 to download.lista_risorse.count-1 do begin
   risorsa := download.lista_risorse[h];
                                                           
     if ((vsExpanded in download.display_node.States) or
         (cardinal(download)=vars_global.handle_obj_GraphHint)) then begin
      // if risorsa.state=srs_paused then include(risorsa.display_node.states,vsHidden)
      //  else Exclude(risorsa.display_node.states,vsHidden);
       risorsa.display_data^.state := risorsa.state;
       risorsa.display_data^.progress := risorsa.progress;
       risorsa.display_data^.size := risorsa.global_size;
       risorsa.display_data^.startp := risorsa.start_byte;
       risorsa.display_data^.endp := risorsa.end_byte;
       risorsa.display_data^.queued_position := risorsa.queued_position;
       risorsa.display_data^.nickname := risorsa.nickname;
       risorsa.display_data^.versionS := risorsa.version;
     end;

       if ((risorsa.state=srs_receiving) or (risorsa.state=srs_UDPDownloading)) then begin
         inc(download.num_in_down);

        if (vsExpanded in download.display_node.States) then begin
         if risorsa.display_data^.should_disconnect then begin
          risorsa.display_data^.should_disconnect := False;
          if risorsa.socket<>nil then begin  // TCP only
           intero := risorsa.socket.socket;
           TCPSocket_Free(intero);
          end;
          continue;
         end;
        end;

         attuale_vel := (risorsa.progress-risorsa.bytes_prima) * (SECOND / (tempo-last_check));
         risorsa.speed := ((risorsa.speed div 5)*4)+(trunc(attuale_vel) div 5);
         risorsa.bytes_prima := risorsa.progress;
         if (vsExpanded in download.display_node.States) then risorsa.display_data^.speed := risorsa.speed;
         if risorsa.speed>0 then inc(download.speed,risorsa.speed);
       end;

       if (vsExpanded in download.display_node.States) then
        if cardinal(risorsa)=vars_global.handle_obj_GraphHint then
         update_hint(risorsa.display_node);
  end;
  {
  if download.partial_sources<>nil then begin
     download.display_data^.num_partial_sources := download.partial_sources.count;
     for h := 0 to download.partial_sources.count-1 do begin
      risorsa_encap := download.partial_sources[h];

            if risorsa_encap.display_data^.should_disconnect then begin
             risorsa_encap.display_data^.should_disconnect := False;
             intero := risorsa_encap.socket.socket;
             TCPSOcket_free(intero);
             continue;
            end;
            
     end;
  end; }
  download.display_data^.num_sources := download.lista_risorse.count;
  download.display_data^.state := download.state;
  download.display_data^.progress := download.progress;
  download.display_data^.velocita := download.speed;
  download.display_data^.numInDown := download.num_in_down;
 
  if download.state=dlDownloading then begin
   inc(loc_numero_down);
   if download.speed>0 then inc(loc_speed_down,download.speed);
  end;

  if cardinal(download)=vars_global.handle_obj_GraphHint then update_hint(download.display_node);

 if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then ares_frmmain.treeview_download.Sort(download.display_node,3,sdAscending);
end;


if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then ares_frmmain.treeview_download.Invalidate;

{
for i := 0 to lista_download.count - 1 do begin  //calcoliamo remaining download
download := lista_download[i];
 if download.partial_sources=nil then continue;
   for h := 0 to download.partial_sources.count-1 do begin
    risorsa_encap := download.partial_sources[h];
    if risorsa_encap.stato<>STATO_TRANSFERRING then continue;

      if risorsa_encap.display_data^.should_disconnect then begin
         risorsa_encap.display_data^.should_disconnect := False;
         intero := risorsa_encap.socket.socket;
         TCPSOcket_free(intero);
         continue;
      end;

    if not risorsa_encap.is_upload then inc(download.num_in_down); //count here, resetted before

    attuale_vel := (risorsa_encap.progress-risorsa_encap.bytes_prima) * (SECONDO / (tempo-last_check));
    risorsa_encap.speed := ((risorsa_encap.speed div 5)*4)+(trunc(attuale_vel) div 5); //((upload.velocita div 5)*4)+(trunc(attuale_vel) div 5);

    if risorsa_encap.is_upload then inc(vars_global.speedUploadPartial,risorsa_encap.speed);

    risorsa_encap.bytes_prima := risorsa_encap.progress;   //pertiamo avanti

         //se è un download o ho solo degli upload.... mostro velocità
    if ((not risorsa_encap.is_upload) or ((risorsa_encap.is_upload) and (download.num_in_down=0))) then
     if risorsa_encap.speed>0 then inc(download.speed,risorsa_encap.speed); //impostiamo speed download

       risorsa_encap.display_data^.velocita := risorsa_encap.speed;
      if risorsa_encap.display_node<>download.display_node then begin
       risorsa_encap.display_data^.progress := risorsa_encap.progress;
       risorsa_encap.display_data^.size := (risorsa_encap.end_byte-risorsa_encap.start_byte)+1;
        risorsa_encap.display_data^.progress_child := risorsa_encap.progress;
        risorsa_encap.display_data^.startp := risorsa_encap.start_byte;
        risorsa_encap.display_data^.endp := risorsa_encap.end_byte;
      end else risorsa_encap.display_data^.progress_child := risorsa_encap.progress;

       if risorsa_encap.is_upload then begin
        ares_frmmain.treeview_upload.invalidatenode(risorsa_encap.display_node);
          if cardinal(risorsa_encap)=vars_global.handle_obj_GraphHint then begin
          // update_holes_visual(download,download.display_data);
           update_hint(risorsa_encap.display_node,ares_frmmain.treeview_upload);
          end;
        end else begin
         ares_frmmain.treeview_download.invalidatenode(risorsa_encap.display_node);
          if cardinal(risorsa_encap)=vars_global.handle_obj_GraphHint then begin
           //update_holes_visual(download,download.display_data);
           update_hint(risorsa_encap.display_node);
          end;
        end;
  end;
end; }

 update_status;
end;


procedure tthread_download.CheckDownloadsStatus;
var
i: Integer;
download: TDownload;
node:pcmtvnode;
begin

try

 i := 0;
while (i<lista_download.count) do begin
  download := lista_download[i];

         if download.state=dlAllocating then begin
          inc(i);
          continue;
         end;

         if download.display_data^.state=dlJustCompleted then begin 
            lista_download.delete(i);
           download.state := dlCompleted;

           with download.display_data^ do begin
            filename := download.filename;
            progress := download.size; //100%
            state := download.state;
            velocita := 0;
            handle_obj := INVALID_HANDLE_VALUE;
           end;
            node := download.display_node;
            termina_download_download(download,false,true,true);
            ares_frmmain.treeview_download.DeleteChildren(node,true);
            ares_frmmain.treeview_download.invalidatenode(node);
            update_hint(node);
            vars_global.changed_download_hashes := True; //remove request on thread client
            continue;
          end;


          if download.display_data^.want_cancelled then begin
            if ((download.state<>dlCompleted) and
                (download.state<>dlRebuilding)) then begin
             lista_download.delete(i);
             with download.display_data^ do begin
              velocita := 0;
              state := dlCancelled;
              hash_sha1 := '';
              handle_obj := INVALID_HANDLE_VALUE;
             end;
             node := download.display_node;
             termina_download_download(download,true,true,true);
             ares_frmmain.treeview_download.DeleteChildren(node,true);
             ares_frmmain.treeview_download.invalidatenode(node);
             update_hint(node);
             vars_global.changed_download_hashes := True; //remove request
             continue;
           end;
          end;


        
          if ((download.ercode<>0) or
              (download.stream=nil)) then begin
              if download.display_data.ercode<>download.ercode then begin
               with download.display_data^ do begin
                state := download.state;
                ercode := download.ercode;
               end;
               ares_frmmain.treeview_download.invalidatenode(download.display_node);
              end;
           inc(i);
           continue;
          end;



          if download.display_data^.change_paused then begin
            download.display_data^.change_paused := False;

            if download.state=dlPaused then begin
               unpausa_risorse(download);
               download.state := dlProcessing;
               download.display_data^.state := download.state;
               download.display_data^.velocita := 0;
               ares_frmmain.treeview_download.invalidatenode(download.display_node);
               update_hint(download.display_node);
               update_hole_table(download);
               if download.lista_risorse.count>1 then
                download.lista_risorse.sort(ordina_risorsa_per_succesfull_factor);  //ora facciamo shake

             end else begin
               pausa_risorse(download);
               download.state := dlPaused;
                with download.display_data^ do begin
                velocita := 0;
                state := dlPaused;
                end;
               update_hole_table(download);
               ares_frmmain.treeview_download.invalidatenode(download.display_node);
               update_hint(download.display_node);
             end;
            vars_global.changed_download_hashes := True;
          end;

          inc(i);
  end;


except
end;
end;

procedure tthread_download.check_DLcounts(num_down_att:integer);
begin

  if limite_download_leech then begin
   if num_down_att>1 then leech_pause_download else
    if num_down_att=0 then unleech_1_download;
  end else begin
    unleech_all_downloads;
    pause_locally_downloads(vars_global.max_dl_allowed,num_down_att);
  end;

end;

procedure tthread_download.start_update_treeview; //synch
begin
ares_frmmain.treeview_download.beginupdate;
end;

procedure tthread_download.end_update_treeview; //synch
begin
ares_frmmain.treeview_download.endupdate;
end;

procedure tthread_download.update_hint_phash; //synch
begin
if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then ares_frmmain.treeview_download.invalidatenode(down_general.display_node);

if m_graphObject=INVALID_HANDLE_VALUE then exit;
check_visual_phash;
end;

procedure tthread_download.UpdateVisualBitField; //sync
begin
helper_download_misc.UpdateVisualBitField(down_general); //sync
update_hint_phash;
end;

procedure tthread_download.check_visual_phash;
var
i: Integer;
risorsa: Trisorsa_download;
begin

  if cardinal(down_general)=m_graphObject then begin
   update_hint(down_general.display_node);
   exit;
  end;

     for i := 0 to down_general.lista_risorse.count-1 do begin
      risorsa := down_general.lista_risorse[i];
      if cardinal(risorsa)=m_graphObject then begin
         update_hint(risorsa.display_node);
         exit;
      end;
     end;

end;

procedure tthread_download.update_hint(node:pCmtVnode); //in synch
begin
try

if vars_global.formhint.top=10000 then exit;

if node<>vars_global.previous_hint_node then exit;

 mainGui_hintTimer(ares_frmmain.treeview_download,node);

except
end;
end;

procedure tthread_download.update_hint(node:pCmtVnode; treeview: Tcomettree);
begin
try

if vars_global.formhint.top=10000 then exit;
if node<>vars_global.previous_hint_node then exit;
mainGui_hintTimer(treeview,node);

except
end;

end;



procedure tthread_download.SourcesGetAvailable;
var
risorsa: Trisorsa_download;
list: Tlist;
begin

list := vars_global.lista_risorse_temp.locklist;
while (list.count>0) do begin   //ares
 risorsa := list[list.count-1];
          list.delete(list.count-1);
  loc_lista_temp_risorse.add(risorsa);
end;
vars_global.lista_risorse_temp.unlocklist;

end;


procedure tthread_download.prendi_risorse_da_loc_temp;
var
risorsa,risorsap: Trisorsa_download;
download: Tdownload;
h: Integer;
isDuplicate,isBanned: Boolean;
ips: string;
HasAdded: Boolean;
begin
HasAdded := False;
try



while (loc_lista_temp_risorse.count>0) do begin
try
risorsa := loc_lista_temp_risorse[loc_lista_temp_risorse.count-1];
         loc_lista_temp_risorse.delete(loc_lista_temp_risorse.count-1);

download := handle_to_download(risorsa.handle_download);  // non serve più
if download=nil then begin
 risorsa.Free;
 continue;
end;

if download.lista_risorse.count>=MAX_SOURCES_DOWNLOAD_ARES then begin
 risorsa.Free;
 continue;
end;

if isDownloadTerminated(download) then begin
     risorsa.Free;
     continue;
end;


     ips := ipint_to_dotstring(risorsa.ip);
    if ((ips=vars_global.localip) or (not is_ip(ips))) then begin  // occhio a non fare boiate
     if risorsa.ip_interno=vars_global.LanIPC then begin
      risorsa.Free;
      continue;
     end;
    end;
      if risorsa.ip_interno=0 then risorsa.ip_interno := risorsa.ip; //annulliamo ip interno


    isDuplicate := False;
    isBanned := download.isBannedIp(risorsa.ip);


     if not isBanned then begin   //check 2 aggiorniamo ip server di nostra risorsa nel caso sia cambiato
       for h := 0 to download.lista_risorse.count-1 do begin
        risorsap := download.lista_risorse[h];

         if ((risorsa.ip=risorsap.ip) or
           (risorsa.nickname=risorsap.nickname))  then begin
            isDuplicate := True;
            break;
         end;
       end;
     end;


     if ((not isDuplicate) and
         (not isBanned)) then begin
      { if ( ((download.tipo=ARES_MIME_VIDEO) and (download.lista_risorse.count>=MAX_NUM_SOURCES*2)) or
            ((download.lista_risorse.count>=MAX_NUM_SOURCES) and (download.tipo<>ARES_MIME_VIDEO)) ) then begin
              if tempo-download.creationTime>60000 then free_worst_source(download)
              else begin
               risorsa.Free;
               continue;
              end;
       end;  }

       if helper_download_misc.isDownloadPaused(download) then risorsa.state := srs_paused;
       risorsa.download := download;
       HasAdded := True;
       download.lista_risorse.add(risorsa);
     end else risorsa.Free;


except
end;
end;


except
end;
if not HasAdded then exit;

synchronize(AddVisualNewSources);
end;

procedure tthread_download.AddVisualNewSources;
var
i,h: Integer;
download: TDownload;
source: TRisorsa_download;
begin
ares_frmmain.treeview_download.beginupdate;

for i := 0 to lista_download.count-1 do begin
 download := lista_download[i];
 if isDownloadTerminated(download) then continue;

 for h := 0 to download.lista_risorse.count-1 do begin
  source := download.lista_risorse[h];
  if source.display_node=nil then source.AddVisualReference;
 end;

end;

ares_frmmain.treeview_download.endupdate;
end;



procedure tthread_download.push_expire_old;
var tempo: Cardinal;
i,h: Integer;
download: Tdownload;
risorsa: Trisorsa_download;
begin
// dopo 60 secondi che sto aspettando push rimetto connect sulla risorsa
tempo := gettickcount;

for i := 0 to lista_download.count-1 do begin
try

download := lista_download[i];



 for h := 0 to download.lista_risorse.count-1 do begin
  risorsa := download.lista_risorse[h];

  if risorsa.state<>srs_waitingIcomingConnection then continue;

  if tempo-risorsa.tick_attivazione<30000 then continue;

  SourceDoIdle(risorsa,false);
 end;


except
end;
end;

end;



procedure tthread_download.prendi_socket_accept; //synch
var
socket: Ttcpblocksocket;
begin


   try

   while (vars_global.lista_socket_accept_down.count>0) do begin
    socket := vars_global.lista_socket_accept_down[0];
            vars_global.lista_socket_accept_down.delete(0);

        socket.tag := tempo; //prolunghiamo qui?

      if pos('PUSH ',socket.buffstr)=1 then push_assegna_arrivo_socket_a_risorsa(socket)
        else sockets_accepted.add(socket);

   end;

   except
   end;

end;


function tthread_download.drop_one_trying_source(download: Tdownload): Boolean; //facciamo spazio ad una sicura firewalled piuttosto
var
i: Integer;
risorsa: Trisorsa_download;
begin
result := False;

for i := 0 to download.lista_risorse.count-1 do begin  //prima trying
risorsa := download.lista_risorse[i];
 if risorsa.state=srs_connecting then begin
  SourceDoIdle(risorsa,true);
  Result := True;
 exit;
end;
end;

for i := 0 to download.lista_risorse.count-1 do begin  //ora connected e waiting for reply
risorsa := download.lista_risorse[i];
 if ((risorsa.state=srs_connected) or
     (risorsa.state=srs_ReceivingReply)) then begin
  SourceDoIdle(risorsa,true);
  Result := True;
 exit;
end;
end;

end;

procedure tthread_download.push_assegna_arrivo_socket_a_risorsa(socket: Ttcpblocksocket);
var
i,h: Integer;
download: Tdownload;
risorsa: Trisorsa_download;
hash_sha1,randoms: string;
crcsha1: Word;
begin
try
if socket.ip=vars_global.localip then begin
 socket.Free;
 exit;
end;
except
end;

 //format:
 //
 //PUSH SHA1:ABCDEFABCD01234567890  + randoms
 //

delete(socket.buffstr,1,5);
delete(socket.buffstr,pos(chr(10),socket.buffstr),length(socket.buffstr));

 if pos('SHA1:',socket.buffstr)=1 then begin //sha1 push (20*2)+8
    delete(socket.buffstr,1,5);
    hash_sha1 := hexstr_to_bytestr(copy(socket.buffstr,1,40));
    if length(hash_sha1)<>20 then begin
     socket.Free;
     exit;
    end;
    crcsha1 := crcstring(hash_sha1);
    delete(socket.buffstr,1,40);
   randoms := socket.buffstr;
 end else begin
     socket.Free;
     exit;
 end;


 

for i := 0 to lista_download.count-1 do begin
   try
   download := lista_download[i];
    if download.crcsha1<>crcsha1 then continue;
     if download.hash_sha1<>hash_sha1 then continue;
      if not isDownloadActive(download) then continue;

      if download.num_in_down>=cardinal(max_sources_per_download) then begin
       socket.Free;
       exit;
      end;


          for h := 0 to download.lista_risorse.count-1 do begin
           risorsa := download.lista_risorse[h];

           if risorsa.state<>srs_waitingIcomingConnection then continue;

             if risorsa.randoms<>randoms then continue;

               if ((length(download.FPieces)=0) and
                      (download.FPieceSize>0) and
                      (download.size>0) and
                      (not download.is_getting_phash)) then begin  //should retrieve ICH pieces first, but only 1 source at a time
                       with risorsa do begin
                        start_byte := 0;
                        end_byte := 2;
                        global_size := 3;
                        if piece<>nil then piece.FinUse := False;
                        piece := nil;
                        getting_phash := True;
                      end;
                      download.is_getting_phash := True;
                end else begin
                   if not source_startbyte_assign(download,risorsa) then begin // we can't assign a start_byte

                        if not drop_one_trying_source(download) then begin  // disconnect a trying source first
                          socket.Free;
                          SourceDoIdle(risorsa,true);
                          exit;
                        end;

                        if not source_startbyte_assign(download,risorsa) then begin  //still can't assign a start_byte?
                          socket.Free;
                          SourceDoIdle(risorsa,true);
                          exit;
                        end;
                   end;
                 end;

            if risorsa.socket<>nil then begin
             risorsa.socket.Free;
            end;

             risorsa.socket := socket;
              risorsa.socket.buffstr := '';
              risorsa.socket.port := risorsa.porta;
              risorsa.socket.ip := ipint_to_dotstring(risorsa.ip);
              risorsa.tick_attivazione := gettickcount;
              risorsa.queued_position := 0;
              risorsa.actual_decrypt_key := random($ffff);
              risorsa.encryption_branch := 1;
              out_http_get_req_str(risorsa.out_buf,download,risorsa);
              risorsa.state := srs_connected;

              exit;
          end;

  except
  end;
end;

socket.Free;

exit;
end;




procedure tthread_download.leech_pause_download;  //solo uno permesso
var
i: Integer;
download: Tdownload;
leech: Integer;
begin
leech := 0;


  for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if helper_download_misc.isDownloadActive(download) then begin
       inc(leech);
      if leech>1 then begin
        pausa_risorse(download);

                  download.state := dlLeechPaused;
                  download.is_getting_phash := False;
                  if download.phash_Stream<>nil then FreeHandleStream(download.phash_stream);

                 download.display_data^.state := dlLeechPaused;

                   vars_global.changed_download_hashes := True;

      end;
   end;
 end;
end;

procedure tthread_download.unleech_1_download;  //solo uno permesso
var i: Integer;
download: Tdownload;
begin
 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if download.state=dlLeechPaused then begin

       unpausa_risorse(download);
       download.state := dlProcessing;
       vars_global.changed_download_hashes := True; //remove or add request on thread client

      break;
   end;
 end;
end;

procedure tthread_download.pause_locally_downloads(max_dl_allowed: Integer; num_down_attivi:integer);
begin
 if max_dl_allowed=num_down_attivi then exit else
 if max_dl_allowed>num_down_attivi then unpause_locally(max_dl_allowed-num_down_attivi) else
                                         pause_locally(num_down_attivi-max_dl_allowed);
end;

procedure tthread_download.unpause_locally(howmany:integer);
var
i: Integer;
download: Tdownload;
fatti: Integer;
begin
fatti := 0;

 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if download.state=dlLocalPaused then begin

      unpausa_risorse(download);
       download.state := dlProcessing;
       
      // num_sources := download.lista_risorse.count;

          vars_global.changed_download_hashes := True; //remove or add request on thread client

          inc(fatti);
          if fatti>=howmany then break;
   end;
 end;
end;

procedure tthread_download.pause_locally(howmany:integer);
var
i,h: Integer;
download: Tdownload;
fatti: Integer;
risorsa: Trisorsa_download;
in_coda: Boolean;
begin
fatti := 0;

 for i := lista_download.count-1 downto 0 do begin    //pause not in progress first
   download := lista_download[i];
   if download.state<>dlProcessing then continue;

      download.is_getting_phash := False;
      if download.phash_Stream<>nil then FreeHandleStream(download.phash_stream);
      
   //try to pause worst download first
      in_coda := False;
      for h := 0 to download.lista_risorse.count-1 do begin
       risorsa := download.lista_risorse[h];
       if ((risorsa.queued_position>0) and (risorsa.queued_position<102)) then in_coda := True;
      end;
      if in_coda then continue;


      pausa_risorse(download);

                 download.state := dlLocalPaused;
                 download.display_data^.state := dlLocalPaused;

                  vars_global.changed_download_hashes := True; //remove or add request on thread client

          inc(fatti);
          if fatti>=howmany then exit;   //need more?
 end;



 

  for i := lista_download.count-1 downto 0 do begin    //pause not in progress first
   download := lista_download[i];
   if download.state<>dlProcessing then continue;
      pausa_risorse(download);

       download.state := dlLocalPaused;
       download.display_data^.state := dlLocalPaused;

       vars_global.changed_download_hashes := True; //remove or add request on thread client

       inc(fatti);
         if fatti>=howmany then exit;   //need more?
 end;





 for i := lista_download.count-1 downto 0 do begin
   download := lista_download[i];
   if download.state<>dlDownloading then continue;

      pausa_risorse(download);

      download.state := dlLocalPaused;
      download.display_data^.state := dlLocalPaused;

      vars_global.changed_download_hashes := True; //remove or add request on thread client

      inc(fatti);
      if fatti>=howmany then exit;
 end;
 
end;

procedure tthread_download.unpause_locally_paused_downloads;
var
i: Integer;
download: Tdownload;
begin
 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if download.state<>dlLocalPaused then continue;

      unpausa_risorse(download);
      download.state := dlProcessing;

     // num_sources := download.lista_risorse.count;
      vars_global.changed_download_hashes := True; //remove or add request on thread client

 end;
end;

procedure tthread_download.unleech_all_downloads;
var
i: Integer;
download: Tdownload;
begin
 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if download.state<>dlLeechPaused then continue;

     unpausa_risorse(download);
     download.state := dlProcessing;
     vars_global.changed_download_hashes := True; //remove or add request on thread client

 end;
end;


procedure tthread_download.unpausa_risorse(download: Tdownload);
var
risorsa: Trisorsa_download;
i: Integer;
begin
try

 for i := 0 to download.lista_risorse.count-1 do begin

  risorsa := download.lista_risorse[i];
  if risorsa.state<>srs_paused then continue;

   risorsa.state := srs_idle;
   risorsa.tick_attivazione := gettickcount-SOURCE_RETRY_INTERVAL;
   risorsa.queued_position := 0;

 end;
 
  download.paused_sources := False;

except
end;
end;

procedure tthread_download.pausa_risorse(download: Tdownload);
var
risorsa: Trisorsa_download;
i: Integer;
piece: TDownloadPiece;
begin
try

down_general := download;

for i := 0 to high(download.FPieces) do begin
 piece := download.Fpieces[i];
 piece.FInUse := piece.Fdone;
end;

for i := 0 to download.lista_risorse.count-1 do begin
 risorsa := download.lista_risorse[i];
 if risorsa.state=srs_paused then continue;

  RemoveFromDuty(risorsa);
  risorsa.state := srs_paused;
  risorsa.tick_attivazione := 0;
  risorsa.queued_position := 0;
  if risorsa.piece<>nil then risorsa.piece.FInUse := False;
  risorsa.piece := nil;
     if risorsa.socket<>nil then FreeAndNil(risorsa.socket);
     risorsa.start_byte := 0;
     risorsa.end_byte := 0;
     risorsa.size_to_receive := 0;
     risorsa.progress := 0;
     risorsa.attivato_ip := False;
end;


download.paused_sources := True; //per evitare di rifare subito
if download.num_in_down>0 then download.num_in_down := 0; //resettiamo?

except
end;

end;


procedure tthread_download.termina_download_download(download: Tdownload;
 pulisci: Boolean; remove_from_memory: Boolean; leaveVisual:boolean=false); // terminiamo download nella lista
var
risorsa: Trisorsa_download;
ind: Integer;
begin

 if pulisci then begin
  down_general := download;
  synchronize(checkPreviewedFile);
  frestart_player := False;
 end;

try
  while download.lista_risorse.count>0  do begin
   risorsa := download.lista_risorse[download.lista_risorse.count-1];
            download.lista_risorse.delete(download.lista_risorse.count-1);
       try
        SourceDestroy(risorsa,true); //fast
       except
       end;
  end;
except
end;



try
if pulisci then erase_download_file(download);
except
end;

try
if remove_from_memory then begin
 ind := lista_download.indexof(download);
 if ind<>-1 then lista_download.delete(ind);

end;
except
end;

if leaveVisual then begin
 download.display_data^.handle_obj := INVALID_HANDLE_VALUE;
 download.display_node := nil;
 download.Free;
end else begin
 down_general := download;
 synchronize(DelDownload);
end;

end;

procedure tthread_download.update_status; //in synch
begin
vars_global.numero_download := loc_numero_down;
if cardinal(loc_speed_down)>vars_global.velocita_down then vars_global.velocita_down := cardinal(loc_speed_down);
vars_global.velocita_att_download := loc_speed_down; //per special caption
ares_frmmain.update_status_transfer;
end;

function tthread_download.elimina_queued_peggiore(download: Tdownload): Boolean; //eliminiamo peggior queued nel caso siano tutti queued
var i: Integer;
peggiore: Integer;
index_peggiore: Integer;
risorsa: Trisorsa_download;
begin
index_peggiore := -1;
peggiore := 0;

result := False;
 for i := 0 to download.lista_risorse.count-1 do begin
 risorsa := download.lista_risorse[i];
 if risorsa.queued_position=0 then continue;
    if risorsa.queued_position>peggiore then begin
     peggiore := risorsa.queued_position;
     index_peggiore := i;
    end;
 end;

 if index_peggiore=-1 then exit;

 risorsa := download.lista_risorse[index_peggiore];
 risorsa.queued_position := 0; // togli da coda
 SourceDoIdle(risorsa,true);
 Result := True;
end;



procedure tthread_download.ActivateSources(download: Tdownload);
var
h: Integer;
risorsa: Trisorsa_download;
begin


 h := 0;
 while (h<download.lista_risorse.count) do begin
  risorsa := download.lista_risorse[h];

  if ((risorsa.ICH_failed) or
      (risorsa.num_fail>=20)) then begin

   download.lista_risorse.delete(h);
   SourceDestroy(risorsa,false);
   continue;
  end;


  if risorsa.state<>srs_idle then begin
   inc(h);
   continue;
  end;

  if ((risorsa.FailedICHDBRet) and (length(download.FPieces)=0)) then begin
   inc(h);
   continue;  //missing ICH don't ask DB to a source which failed to deliver
  end;

      //queued source should have suggested reconnect time
      if risorsa.queued_position<>0 then
       if tempo<risorsa.next_poll then begin
        inc(h);
        continue;
       end;

     // regular source have fixed reconnect interval
     if risorsa.queued_position=0 then
      if tempo-risorsa.tick_attivazione<SOURCE_RETRY_INTERVAL then begin
       inc(h);
       continue;
      end;

    if sources_activecount(risorsa)>=3 then begin //another nested loop, needed to preved flooding on a single IP :(
     inc(h);
     continue;
    end;

   risorsa.out_buf := '';
   risorsa.queued_position := 0;

   if not source_connect(download,risorsa) then begin
    download.lista_risorse.delete(h);
    SourceDestroy(risorsa,false);
    continue;
   end;
   inc(loc_outgoing_connections);
   break; // one by one...

   //  inc(loc_outgoing_connections);
    // if loc_outgoing_connections>=MAX_OUTCONNECTIONS then exit;

  // inc(h);
  end;

end;


procedure tthread_download.ActivateSources;
var
 i,h: Integer;
 risorsa: Trisorsa_download;
 num_max_sources,loc_num_act: Integer;
begin



num_max_sources := max_sources_per_download;
loc_num_act := 0;
loc_outgoing_connections := 0;

for i := 0 to lista_download.count-1 do begin
 download_globale := lista_download[i];
 if isDownloadActive(download_globale) then inc(loc_num_act);

  if download_globale.socket_push<>nil then begin
   if not download_globale.push_connected then inc(loc_outgoing_connections);
  end;
  
 for h := 0 to download_globale.lista_risorse.count-1 do begin
  risorsa := download_globale.lista_risorse[h];
  if risorsa.state=srs_connecting then inc(loc_outgoing_connections);

 end;

end;


check_DLcounts(loc_num_act); // pause unpause


try
for i := 0 to lista_download.count-1 do begin

if (i mod 10)=0 then
 if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(true);

download_globale := lista_download[i];

 if isDownloadState(download_globale,dlAllocating) then continue;

 if isDownloadState(download_globale,dlFinishedAllocating) then begin
  download_globale.allocator.waitfor;
  download_globale.allocator.Free;
  download_globale.allocator := nil;
  download_globale.state := dlProcessing;
 end;

if download_globale.stream=nil then continue;
 if download_globale.ercode<>0 then continue;
  if length(download_globale.hash_sha1)<>20 then continue;


if helper_download_misc.isDownloadPaused(download_globale) then begin
     if not download_globale.paused_sources then begin
      pausa_risorse(download_globale);
      continue;
     end;
end else
if helper_download_misc.isDownloadActive(download_globale) then begin
     if download_globale.paused_sources then unpausa_risorse(download_globale);
end;

  if download_globale.lista_risorse.count=0 then exit;
  if loc_outgoing_connections>=MAX_OUTCONNECTIONS then exit;
   if (loc_is_connecting) and
      (loc_outgoing_connections>0) then exit;


   ActivateSources(download_globale,num_max_sources);


end;

except
end;

end;


procedure tthread_download.check_ICH_recv(downloaD: TDownload; risorsa: TRisorsa_download);
var
ICH_Completed: Boolean;
len,er,hi: Integer;
buffer,buffer2: array [0..1023] of Byte;
begin

      if gettickcount-risorsa.socket.tag>TIMEOUT_RECEIVING_FILE then begin //timeout
        risorsa.FailedICHDBRet := True; //timeout while receiving
        SourceDoIdle(risorsa,true);
        exit;
      end;

      if not TCPSocket_canRead(risorsa.socket.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        risorsa.FailedICHDBRet := True; //hangup while receiving
        SourceDoIdle(risorsa,true);
       end;
      exit;
      end;

      len := TCPSocket_RecvBuffer(risorsa.socket.socket,@buffer,sizeof(buffer),er);
      if er=WSAEWOULDBLOCK then exit;
      if er<>0 then begin
           risorsa.FailedICHDBRet := True;  //hangup while receiving
           SourceDoIdle(risorsa,true);
           exit;
      end;

      move(buffer,buffer2,len);    //decrypt
      for hI := 0 to Len-1 do begin
             buffer[hI] := buffer2[hI] xor (risorsa.actual_decrypt_key shr 8);
             risorsa.actual_decrypt_key := (buffer2[hI] + risorsa.actual_decrypt_key) * 52079 + 16826;
      end;

      risorsa.socket.tag := gettickcount;
      download.phash_stream.seek(download.phash_stream.size,sofrombeginning);
      download.phash_stream.Write(buffer,len);        //write another chunk of data
      //////////////////////////////////////////////////////////////////////////////


      if ICH_corrupt_dl_index(download,risorsa,ICH_completed) then begin
       risorsa.FailedICHDBRet := True;  //corrupted db
       SourceDoIdle(risorsa,true);
       exit;
      end;

     if ICH_Completed then begin
          risorsa.getting_phash := False;
          download.is_getting_phash := False;
          if download.phash_stream<>nil then FreeHandleStream(download.phash_Stream);

            risorsa.state := srs_readytorequest;
            risorsa.tick_Attivazione := gettickcount;

             ICH_loadPieces(download);

             if length(download.FPieces)=0 then begin  // failed for some reason sanity check
              risorsa.FailedICHDBRet := True;
              SourceDoIdle(risorsa,true);
             end;

     end;

end;

procedure tthread_download.ActivateSources(download: Tdownload; num_max_sources:integer);   //normali ares
var
 h,totd,tryn: Integer;
 risorsa: Trisorsa_download;
begin

if not (vars_global.InternetConnectionOK) then begin
 sleep(10);
 exit;
end;

 totd := 0;
 tryn := 0;

 for h := 0 to download.lista_risorse.count-1 do begin
  risorsa := download.lista_risorse[h];
  if risorsa.ICH_failed then continue;

   if isSourceState(risorsa,srs_connecting) then inc(tryn);
   if isSourceState(risorsa,[srs_receiving,srs_UDPDownloading]) then inc(totd);
 end;

 if totd>=num_max_sources then exit;
 

 ActivateSources(download);

end;


procedure tthread_download.CheckSources;
var
i: Integer;
download: Tdownload;
begin
tempo := gettickcount;

i := 0;
while (i<lista_download.count) do begin
try
if terminated then exit;

download := lista_download[i];
 if not isDownloadActive(download) then begin
  inc(i);
  continue;
 end;

 CheckSources(download);
except
end;

 inc(i);
end;
end;

procedure tthread_download.CheckSources(download: TDownload);
var
i: Integer;
risorsa: Trisorsa_download;
begin

 i := 0;
 while (i<download.lista_risorse.count) do begin

 try
  risorsa := download.lista_risorse[i];

   if ((risorsa.state=srs_connecting) or (risorsa.state=srs_readytorequest)) then CheckConnection(download,risorsa)
    else
    if risorsa.state=srs_connected then SourceFlushRequest(download,risorsa)
     else
     if risorsa.state=srs_receivingICH then check_ICH_recv(download,risorsa)
      else
      if risorsa.state=srs_receivingReply then ReceiveRequestResponses(download,risorsa)
       else
       if helper_download_misc.isSourceUDPTrying(risorsa) then check_UDPSources(download,risorsa);

 except
 end;
   inc(i);
 end;
 
end;

procedure tthread_download.CheckConnection(download: TDownload; risorsa: TRisorsa_download);
var
er,lung: Integer;
begin
try

   if tempo-risorsa.tick_attivazione>TIMOUT_SOCKET_CONNECTION then begin

       inc(risorsa.num_fail);
       risorsa.out_buf := '';

     if ((risorsa.socket.ip=ipint_to_dotstring(risorsa.ip_interno)) and
         (risorsa.ip_interno<>risorsa.ip)) then begin
         risorsa.failed_ipint := True;
         risorsa.ip_interno := risorsa.ip;
       SourceDoIdle(risorsa,true);
       exit;
     end;


   if risorsa.his_servers.count=0 then begin //  no more routes to host available
     if ((risorsa.isFirewalled) and (risorsa.num_fail>=4)) then begin  // destroy source if it's unreachable after 4 attempts
      SourceDestroy(risorsa,false);
     end else SourceDoIdle(risorsa,true);
     exit;
   end;

   if risorsa.isFirewalled then push_add(risorsa)
    else SourceDoIdle(risorsa,true);

   exit;
  end;

 
 
    er := TCPSocket_ISConnected(risorsa.socket);
    if er=WSAEWOULDBLOCK then exit;
    if er<>0 then begin
     risorsa.out_buf := '';
     push_add(risorsa);
     exit;
    end;


    if risorsa.ip_interno<>risorsa.ip then begin
      if risorsa.socket.ip=ipint_to_dotstring(risorsa.ip_interno) then risorsa.ip := risorsa.ip_interno
       else risorsa.ip_interno := risorsa.ip;
    end;
    if risorsa.state=srs_Connecting then risorsa.isFirewalled := False;  //

       if ((length(download.FPieces)=0) and
           (download.FPieceSize>0) and
           (download.size>0) and
           (not download.is_getting_phash)) then begin  //should retrieve ICH pieces first, but only 1 source at a time
           with risorsa do begin
            start_byte := 0;
            end_byte := 2;
            global_size := 3;
            if piece<>nil then piece.FinUse := False;
            piece := nil;
            getting_phash := True;
           end;
           download.is_getting_phash := True;
       end else begin
            if not source_startbyte_assign(download,risorsa) then begin
               SourceDoIdle(risorsa,true);
               exit;
            end;
       end;


     with risorsa do begin
        actual_decrypt_key := random($ffff);
        encryption_branch := 1;
        out_http_get_req_str(out_buf,download,risorsa);
        state := srs_connected;
        tick_attivazione := tempo;

       lung := TCPSocket_SendBuffer(socket.socket,@out_buf[1],length(out_buf),er);

       if er=WSAEWOULDBLOCK then exit;
       if er<>0 then begin
        inc(num_fail);
        if succesfull_factor>0 then dec(succesfull_factor);
        SourceDoIdle(risorsa,true);
        exit;
       end;

       if lung<length(out_buf) then begin
        delete(out_buf,1,lung);
        exit;
      end;

      out_buf := '';
      socket.buffstr := '';
      tick_attivazione := tempo;
      state := srs_ReceivingReply;
    end;



except
end;

end;


procedure tthread_download.push_add(risorsa: Trisorsa_download);
var
sin: TVarSin;
begin

with risorsa do begin

   randoms := inttohex(random(256),2)+
            inttohex(random(256),2)+
            inttohex(random(256),2)+
            inttohex(random(256),2);

      if socket<>nil then FreeAndNil(socket);
      if piece<>nil then begin
       piece.FInUse := False;
       piece := nil;
      end;

     if vars_global.im_firewalled then begin // UDP Push
      risorsa.state := srs_UDPpushing;

      // create source's UDP socket
      FillChar(Sin, Sizeof(Sin), 0);
      Sin.sin_family := AF_INET;
      Sin.sin_port := synsock.htons(random(59000)+1024);
      Sin.sin_addr.s_addr := inet_addr(PChar(cAnyHost));
      risorsa.UDP_socket := synsock.socket(PF_INET,integer(SOCK_DGRAM),IPPROTO_UDP);
      synsock.Bind(risorsa.UDP_socket,@Sin,SizeOfVarSin(Sin));

       risorsa.unAckedPackets := 0;
       risorsa.nextUDPOutInterval := 1000;
       risorsa.lastUDPOut := 0;
       sourceSendUDPPush(risorsa);
     end else state := srs_waitingPush; // TCP Push


 end;

end;


procedure tthread_download.push_deal;
var
i: Integer;
download: Tdownload;
begin


for i := 0 to lista_download.count-1 do begin
download := lista_download[i];
if not isDownloadActive(download) then continue;

 with download do begin
     if socket_push=nil then continue;

     if not push_connected then push_check_timeout_connection(download) else
      if not push_flushed then push_flush_out(download) else
       push_check_timeout_sent(download); // else
   end;
end;


end;


procedure tthread_download.push_assegna_stato_firewalled(download: Tdownload);
var
 h: Integer;
 risorsa: Trisorsa_download;
begin

     for h := 0 to download.lista_risorse.count-1 do begin
      risorsa := download.lista_risorse[h];
       if risorsa.state<>srs_TCPpushing then continue;
       if risorsa.randoms<>download.push_randoms then continue;
        //l/og_d(download,risorsa,'push_assegna_stato_firewalled: push inviato, attesa connessione da utente firewalled');
        risorsa.state := srs_waitingIcomingConnection;
        risorsa.tick_attivazione := gettickcount; //timeout inizia da ora!
       exit;
      end;


end;

procedure tthread_download.push_metti_null_server_arisorsa(download: Tdownload);
var
   h: Integer;
   risorsa: Trisorsa_download;
begin
try

     for h := 0 to download.lista_risorse.count-1 do begin
      risorsa := download.lista_risorse[h];
         if risorsa.state<>srs_waitingIcomingConnection then continue;
          if risorsa.randoms<>download.push_randoms then continue;

            risorsa.RemoveServer(download.push_ip_server);
            SourceDoIdle(risorsa,false);

       exit;
      end;


except
end;
end;

procedure tthread_download.push_incapace(download: Tdownload);
var
   h: Integer;
   risorsa: Trisorsa_download;
begin
 try

   for h := 0 to download.lista_risorse.count-1 do begin
      risorsa := download.lista_risorse[h];
      if risorsa.state<>srs_TCPpushing then continue;
       if risorsa.randoms<>download.push_Randoms then continue;

        risorsa.RemoveServer(download.push_ip_server);
        SourceDoIdle(risorsa,false);
       exit;
  end;

  except
  end;
end;

procedure tthread_download.push_check_timeout_sent(download: Tdownload);   //attendo dieci secondi dopo invio per essere sicuro di aver inviato a server
var
str: string;
er,len: Integer;
//port_NAT: Word;
begin
try
if download.socket_push=nil then exit;


  if gettickcount-download.push_tick>10*SECOND then begin
    FreeAndNil(download.socket_push); //pronto al prox
    exit;
  end;

  if not TCPSocket_canRead(download.socket_push.socket,0,er) then begin
    if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
      FreeAndNil(download.socket_push); //pronto al prox
    end;
    exit;
  end;

  len := TCPSocket_RecvBuffer(download.socket_push.socket,@buffer2_ricezione,4,er);
  if er=WSAEWOULDBLOCK then exit;
  if er<>0 then begin
      FreeAndNil(download.socket_push); //pronto al prox
      exit;
  end;

  SetLength(str,len);
  move(buffer2_ricezione,str[1],4);

  if str='0000' then begin


    push_metti_null_server_arisorsa(download);
  end else
  if ((length(str)=4) and (copy(str,1,2)='UP')) then begin


  // port_NAT := chars_2_word(copy(str,3,2));
  // push_start_Punching(download,port_Nat);
  end;
  
  FreeAndNil(download.socket_push); //pronto al prox

 except
 end;
end;


procedure tthread_download.push_flush_out(download: Tdownload);
var
str,str1: string;
er: Integer;
begin
if download.socket_push=nil then exit;

try

        if gettickcount-download.push_tick>TIMOUT_SOCKET_CONNECTION then begin
          FreeAndNil(download.socket_push);
          push_incapace(download);
          exit;
        end;

 str1 := int_2_dword_string(download.push_ip_requested)+
       int_2_word_string(vars_global.myport)+
       download.hash_sha1+
       download.push_randoms+
       chr(download.push_num_special);


 str := e7(int_2_dword_string(download.push_ip_server),download.push_port_server,str1);
  str := int_2_word_string(length(str))+
       chr(MSG_CLIENT_PUSH_REQ)+
       str;

        
      TCPSocket_SendBuffer(download.socket_push.socket,@str[1],length(str),er);
      if er=WSAEWOULDBLOCK then exit else
      if er<>0 then begin
       FreeAndNil(download.socket_push);
       push_incapace(download);
       exit;
      end;

      download.push_tick := gettickcount;
      download.push_flushed := True; //wait for server reply within 10 seconds
       push_assegna_stato_firewalled(download); //waiting for peer


except
end;
end;

procedure tthread_download.push_check_timeout_connection(download: Tdownload);
var
er: Integer;
begin
try

  if gettickcount-download.push_tick>TIMOUT_SOCKET_CONNECTION then begin
   FreeAndNil(download.socket_push);
   push_incapace(download);
   exit;
  end;

  er := TCPSocket_ISConnected(download.socket_push);
  if er=WSAEWOULDBLOCK then exit else
  if er<>0 then begin
   FreeAndNil(download.socket_push);
   push_incapace(download);
   exit;
  end;


 download.push_tick := gettickcount;
 download.push_connected := True;

 push_flush_out(download);


except
end;
end;


procedure tthread_download.Push_Start_Request;
var
i: Integer;
download: Tdownload;
begin
try

tempo := gettickcount;

for i := 0 to lista_download.count-1 do begin
 download := lista_download[i];
 if not isDownloadActive(download) then continue;

 if download.socket_push<>nil then continue;

 Push_Start_Request(download,tempo);
end;

except
end;
end;


procedure tthread_download.Push_start_Request(download: TDownload; tempo: Cardinal);
var
h: Integer;
risorsa: Trisorsa_download;
begin
try

   for h := 0 to download.lista_risorse.count-1 do begin
    risorsa := download.lista_risorse[h];
    if risorsa.state<>srs_waitingPush then continue;
     if tempo-risorsa.last_out_push_req<MIN_DELAY_BETWEEN_PUSH then continue;

      risorsa.state := srs_TCPpushing;
      risorsa.last_out_push_req := gettickcount;
        with download do begin
         push_connected := False;
         push_flushed := False;
         push_testoricevuto := '';
         push_tick := gettickcount;         
         push_randoms := risorsa.randoms;
         push_ip_requested := risorsa.ip;
         push_num_special := $61; //risorsa.num_special;
         risorsa.GetFirstServerDetails(push_ip_server,push_port_server);
         socket_push := TTCPBlockSocket.create(true);
         socket_push.ip := ipint_to_dotstring(push_ip_server);
         socket_push.port := push_port_server;
         assign_proxy_settings(socket_push);
         socket_push.Connect(socket_push.ip,inttostr(socket_push.port));
     end;

      break;
   end; //source loop

  except
  end;
end;




procedure tthread_download.ReceiveRequestResponses(download: TDownload; risorsa: TRisorsa_download);

                    procedure broken_reply(risorsa: TRisorsa_download);
                    begin
                       risorsa.num_fail := 250;
                       risorsa.attivato_ip := False;
                       risorsa.ICH_failed := True;
                       SourceDoIdle(risorsa,true);
                     end;
var
len,er: Integer;
str: string;
OutB: Word;
lenheader: Integer;
previous_len: Integer;
skipped_len: Byte;
begin
    try

     if tempo-risorsa.tick_attivazione>TIMEOUT_RECEIVE_REPLY then begin
      inc(risorsa.num_fail);
      if risorsa.succesfull_factor>0 then dec(risorsa.succesfull_factor);
      SourceDoIdle(risorsa,true);
      exit;
     end;


     if not TCPSocket_CanRead(risorsa.socket.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
         inc(risorsa.num_fail);
         SourceDoIdle(risorsa,true);
        end;
       exit;
     end;


         len := TCPSocket_recvBuffer(risorsa.socket.socket,
                                   @buffer2_ricezione,
                                   sizeof(buffer2_ricezione),
                                   er);

         if er=WSAEWOULDBLOCK then exit;

         if er<>0 then begin
          SourceDestroy(risorsa,false,true);
          exit;
         end;
         
           previous_len := length(risorsa.socket.buffstr);
           SetLength(risorsa.socket.buffstr,previous_len+len);
           move(buffer2_ricezione,risorsa.socket.buffstr[previous_len+1],len);



           if length(risorsa.socket.buffstr)<24 then exit; //need more

            if pos(STR_HTTP_PLAIN,copy(risorsa.socket.buffstr,1,length(STR_HTTP_PLAIN)))=1 then begin  //can't handle plain requests anymore
                 if pos(CRLF+'x-size:',lowercase(risorsa.socket.buffstr))>0 then begin // got unencrypted reply containing x-size header for magnet URIs
                  if download.size=0 then begin
                   lenheader := pos(CRLF+CRLF,risorsa.socket.buffstr);
                   ParseResponse(download,risorsa,lenHeader);
                  end else SourceDoIdle(risorsa,true);
                 end else broken_reply(risorsa);
              exit;
            end;

                  str := d54var(risorsa.socket.buffstr,risorsa.actual_decrypt_key,OutB);
                  skipped_len := ord(str[3]);
                  if skipped_len>=17 then begin
                     broken_reply(risorsa);
                     exit;
                  end;

                  lenheader := pos(CRLF+CRLF,copy(str,4+skipped_len,length(str)));
                   if lenheader=0 then begin   //need more data
                    if length(risorsa.socket.buffstr)>3*KBYTE then begin
                     broken_reply(risorsa);
                    end;
                    exit;
                   end;

                  delete(str,1,3+skipped_len);
                  if pos(STR_HTTP_PLAIN,copy(str,1,length(STR_HTTP_PLAIN)))<>1 then begin //missing HTTP reply
                   broken_reply(risorsa);
                   exit;
                  end;

         risorsa.actual_decrypt_key := OutB;
         risorsa.socket.buffstr := str;

         ParseResponse(download,risorsa,lenHeader);

         except
         end;
end;



procedure tthread_download.ParseResponse(download: TDownload; risorsa: TRisorsa_download; lenHeader:integer);
                    procedure broken_reply(risorsa: TRisorsa_download);
                    begin
                       risorsa.num_fail := 250;
                       risorsa.attivato_ip := False;
                       risorsa.ICH_failed := True;
                       SourceDoIdle(risorsa,true);
                     end;
var
header,HTTPBody: string;
headerList: TMyList;
HTTPResultCase: Integer;
begin

       header := copy(risorsa.socket.buffstr,1,lenheader+1);
        delete(risorsa.socket.buffstr,1,lenheader+3);
       HTTPBody := risorsa.socket.buffstr;

        risorsa.socket.buffstr := '';

        headerList := Tmylist.create;
        helper_http.ParseHTTPHeader(headerList,header);

        risorsa.nickname := get_HTTPnickname(headerList)+'@'+get_HTTPagent(risorsa,headerList);

        if duplicate_source_nickname(risorsa) then begin
         SourceDestroy(risorsa,false);
         helper_http.FreeHTTPHeaderList(headerList);
         exit;
        end;


        check_HTTPHostINFO(risorsa,HeaderList);


        if length(download.FPieces)=0 then
         if download.FpieceSize>0 then
          if check_HTTP_ICHIdx(download,risorsa,HTTPBody,HeaderList) then begin // stop here
           helper_http.FreeHTTPHeaderList(headerList);
           exit;
          end;


        check_HTTP_AlternateSources(download,risorsa,HeaderList);
        check_HTTP_PartialSources(download,risorsa,HeaderList);


        if check_HTTP_SizeMagnet(download,risorsa,HeaderList) then begin   // magnet URI size discovery
         helper_http.FreeHTTPHeaderList(headerList);
         exit;
        end;
        

        if check_HTTP_XQueued(download,risorsa,HeaderList) then begin  // busy?
         SourceDoIdle(risorsa,true);
         helper_http.FreeHTTPHeaderList(headerList);
         exit;
        end;

        if download.FPieceSize>0 then
         if ((length(download.FPieces)=0) or (risorsa.piece=nil)) then begin //should have bitfield in order to get here
             SourceDoIdle(risorsa,true);
             helper_http.FreeHTTPHeaderList(headerList);
             exit;
         end;


         risorsa.out_buf := '';
         risorsa.num_fail := 0;

         HTTPResultCase := helper_http.HTTP_reply_code(header);
         case HTTPResultCase of

           HTTPOK:begin
                   if not check_HTTP_contentrange(download,risorsa,HeaderList) then begin  // size mismatch?
                    SourceDoIdle(risorsa,true);
                    helper_http.FreeHTTPHeaderList(headerList);
                    exit;
                   end;
                   if BeginDownload(risorsa,download,HTTPBody)=0 then begin
                    inc(risorsa.succesfull_factor,10);
                    helper_ares_nodes.aresnodes_add_candidates(risorsa.his_servers,ares_aval_nodes);
                   end;
           end;

           HTTPBUSY:begin
             inc(risorsa.succesfull_factor);
             risorsa.queued_position := 102; //busy without xqueued
             risorsa.next_poll := gettickcount+60000;
             SourceDoIdle(risorsa,true);
           end;

           HTTPNOTFOUND:begin
            SourceDestroy(risorsa,false,true);
           end;

          end;

          helper_http.FreeHTTPHeaderList(headerList);

end;

function tthread_download.check_HTTP_SizeMagnet(download: TDownload; risorsa: TRisorsa_download; headerlist: TMylist): Boolean;
var
strtemp: string;
begin
result := False;

strtemp := helper_http.FindHTTPValue(headerList,'x-size');
if length(strtemp)>0 then begin

 download.size := strtointdef(strtemp,0);
 if download.size>0 then begin
  download.FPieceSize := helper_ich.ICH_calc_chunk_size(download.size);
  risorsa.state := srs_readytorequest;
  risorsa.tick_Attivazione := gettickcount;
 end else SourceDoIdle(risorsa,true);
 
strtemp := helper_http.FindHTTPValue(headerList,'x-title');
if length(strtemp)>0 then download.title := urldecode(strtemp);

 strtemp := helper_http.FindHTTPValue(headerList,'x-artist');
 if length(strtemp)>0 then download.artist := urldecode(strtemp);

  strtemp := helper_http.FindHTTPValue(headerList,'x-album');
  if length(strtemp)>0 then download.album := urldecode(strtemp);

   strtemp := helper_http.FindHTTPValue(headerList,'x-type');
   if length(strtemp)>0 then download.category := urldecode(strtemp);

    strtemp := helper_http.FindHTTPValue(headerList,'x-language');
    if length(strtemp)>0 then download.language := urldecode(strtemp);

     strtemp := helper_http.FindHTTPValue(headerList,'x-date');
     if length(strtemp)>0 then download.date := urldecode(strtemp);

      strtemp := helper_http.FindHTTPValue(headerList,'x-comments');
      if length(strtemp)>0 then download.comments := urldecode(strtemp);



 download_globale := download;
 synchronize(update_size_download_visual);
 Result := True;
end;

end;

procedure tthread_download.check_HTTP_AlternateSources(download: TDownload; risorsa: TRisorsa_Download; headerlist: TMylist);
var
strtemp: string;
begin
strtemp := helper_http.FindHTTPValue(headerList,'x-alt');
 while (length(strtemp)>0) do begin
  helper_altsources.parse_alternate_source(download,strtemp);
  strtemp := helper_http.FindHTTPValue(headerList,'x-alt');
 end;
end;

procedure tthread_download.check_HTTP_PartialSources(download: TDownload; risorsa: TRisorsa_Download; headerlist: TMylist);
var
strtemp: string;
begin
strtemp := helper_http.FindHTTPValue(headerList,'x-btrnt');
 while (length(strtemp)>=32) do begin
  strtemp := hexstr_to_bytestr(strtemp);
  strtemp := d54(strtemp,3617);
  //helper_altsources.partial_add_one_tree_source(strtemp,download);
  strtemp := helper_http.FindHTTPValue(headerList,'x-btrnt');
 end;
end;

function tthread_download.get_HTTPnickname(headerlist: TMylist): string;
begin
result := helper_http.FindHTTPValue(headerList,'x-my-nick');
result := strip_websites_str(result);
if pos('www.',result)<>0 then Result := ''
 else
  if pos('.com',result)<>0 then Result := '';
if length(result)=0 then Result := STR_ANON+inttohex(random(255),2)+inttohex(random(255),2);
end;

function tthread_download.get_HTTPagent(risorsa: TRisorsa_download; headerlist: TMylist): string;
var
agent: string;
begin
agent := helper_http.FindHTTPValue(headerList,'server');
if length(agent)=0 then agent := STR_UNKNOWNCLIENT
 else begin
  if not risorsa.isFirewalled then DHT_check_bootstrap_build_number(agent,risorsa.ip,risorsa.porta);
  if pos(' ',agent)>0 then risorsa.version := copy(agent,pos(' ',agent)+1,length(agent))
  else risorsa.version := getfirstNumberStr(agent);
 end;
 
 Result := ucfirst(get_first_word(strip_vers(agent)));
end;


procedure tthread_download.check_HTTPHostINFO(risorsa: TRisorsa_download; headerlist: TMylist);
var
strxip,strtemp: string;
begin
strxip := helper_http.FindHTTPValue(headerList,'x-b6mi');
if length(strxip)>0 then begin
 strxip := DecodeBase64(strxip);
 strxip := d54(strxip,3617);
 risorsa.InsertServer(chars_2_dword(copy(strxip,1,4)),chars_2_word(copy(strxip,5,2)),true);
 risorsa.porta := chars_2_word(copy(strxip,11,2));
 risorsa.ip_interno := chars_2_dword(copy(strxip,13,4));
  strtemp := helper_http.FindHTTPValue(headerList,'x-mylip');
  if strtemp<>'00000000' then risorsa.ip_interno := chars_2_dword(hexstr_to_bytestr(strtemp));
  exit;
end;

strxip := helper_http.FindHTTPValue(headerList,'x-acdet');
if length(strxip)>0 then begin
 strxip := DecodeBase64(strxip);
 //skip ip_user
 risorsa.porta := chars_2_word(copy(strxip,5,2));
 risorsa.ip_interno := chars_2_dword(copy(strxip,7,4));
 risorsa.InsertServers(copy(strxip,11,length(strxip)));
end;

end;

function tthread_download.check_HTTP_contentrange(download: TDownload; risorsa: TRisorsa_download; headerlist: TMylist): Boolean;
var
str,endbyteS: string;
size,startbyte,endbyte: Int64;
begin
result := True;

str := helper_http.FindHTTPValue(headerList,'content-range');
if length(str)=0 then begin
  Result := False;
  exit;
end;

 delete(str,1,pos('bytes=',str)+5);

 if ((pos('-',str)=0) or
     (pos('/',str)=0)) then begin
  risorsa.num_fail := 250;
  risorsa.attivato_ip := False;
  Result := False;
  exit;
 end;

 startbyte := strtointdef(copy(str,1,pos('-',str)-1),-1);
 if risorsa.start_byte<>startbyte then begin
  risorsa.num_fail := 250;
  risorsa.attivato_ip := False;
  Result := False;
  exit;
 end;

 endbyteS := copy(str,pos('-',str)+1,length(str));
 endbyte := strtointdef(copy(endbyteS,1,pos('/',endbyteS)-1),-1);
 if endbyte<>risorsa.end_byte then begin
  risorsa.num_fail := 250;
  risorsa.attivato_ip := False;
  Result := False;
  exit;
 end;


     size := strtointdef(copy(str,pos('/',str)+1,length(str)),0);
     if download.size<>size then begin
      risorsa.num_fail := 250;
      risorsa.attivato_ip := False;
      Result := False;
     end;
end;

function tthread_download.check_HTTP_XQueued(download: TDownload; risorsa: TRisorsa_Download; HeaderList: TMylist): Boolean;
var
str,strTemp: string;
pollMin: Cardinal;
begin
result := False;

str := helper_http.FindHTTPValue(headerList,'x-queued');
result := (length(str)>0);

if not Result then exit;
inc(risorsa.succesfull_factor);

if pos('pollmin=',str)<0 then begin
 strTemp := copy(str,pos('pollmin=',str)+8,length(str));
  if pos(',',strTemp)<>0 then pollmin := strtointdef(copy(strTemp,1,pos(',',strTemp)-1),60)
   else pollmin := strtointdef(str,60);
   risorsa.next_poll := gettickcount+((pollmin)*1000);
end else risorsa.next_poll := gettickcount+60000;

if pos('position=',str)<>0 then begin
 strTemp := copy(str,pos('position=',str)+9,length(str));
  if pos(',',strTemp)<>0 then risorsa.queued_position := strtointdef(copy(strTemp,1,pos(',',strTemp)-1),1)
   else risorsa.queued_position := strtointdef(str,1);
end;
end;

function tthread_download.check_HTTP_ICHIdx(download: TDownload; risorsa: TRisorsa_download; HTTPBody: string; HeaderList: TMylist): Boolean;
var
str: string;
sizepiece: Int64;
ICH_completed: Boolean;
begin
result := False;

str := helper_http.FindHTTPValue(headerList,'phashidx');
if length(str)=0 then begin // no ICH_IDX infos, warez client?
 risorsa.FailedICHDBRet := True;
 SourceDoIdle(risorsa,true);
 exit;
end;

result := True;  // ok caller should stop parsing header, past this


if bytestr_to_hexstr(download.hash_sha1)<>str then begin  // hash mismatch
 download.is_getting_phash := False;
 if download.phash_Stream<>nil then FreeHandleStream(download.phash_stream);
 risorsa.FailedICHDBRet := True;
 SourceDoIdle(risorsa,true);
 exit;
end;


str := helper_http.FindHTTPValue(headerList,'phsize');
 if length(str)>0 then begin
  sizepiece := strtointdef(str,0);
  if sizepiece<>0 then
    if sizepiece<>int64(download.FPieceSize) then begin   // PieceLength mismatch
     risorsa.FailedICHDBRet := True;
     SourceDoIdle(risorsa,true);
     exit;
    end;
 end;
 
risorsa.state := srs_receivingICH;
if not helper_ICH.ICH_start_rcv_indexs(download,risorsa,HTTPBody,ICH_completed) then begin // corrupted DB?
 risorsa.FailedICHDBRet := True;
 SourceDoIdle(risorsa,true);
 exit;
end;


if ICH_completed then begin
 if download.phash_stream<>nil then FreeHandleStream(download.phash_Stream);
 download.is_getting_phash := False;
 ICH_check_DLPhash(download);
 if length(download.FPieces)>0 then begin //send to checkConnections
  risorsa.state := srs_readytorequest;
  risorsa.tick_Attivazione := gettickcount;
 end else begin
  risorsa.FailedICHDBRet := True;
  SourceDoIdle(risorsa,true);
 end;
end;

end;


function tthread_download.BeginDownload(risorsa: Trisorsa_download;download: Tdownload; HTTPBody: string): Byte;
var
to_write: Integer;
begin
try

if download.ercode<>0 then begin
 Result := 1;
 exit;
end;

with risorsa do begin
 size_to_receive := (end_byte-start_byte)+1;
 speed := 0;
 progress := 0;
 progress_su_disco := 0;
 bytes_prima := 0;
 queued_position := 0;
 tick_attivazione := gettickcount;
 last_in := tick_attivazione;
 started_time := tick_attivazione;   //compare worst speed
 state := srs_receiving
end;

 download.state := dlDownloading;

      inc(download.num_in_down);
      SourcesOnDuty.add(risorsa);

      risorsa.writecache := TWriteCache.create(download.stream,risorsa.start_byte);


       if length(HTTPBody)>0 then begin

         while (length(HTTPBody)>0) do begin
          to_write := length(HTTPBody);
          if to_write>sizeof(buffer2_ricezione) then to_write := sizeof(buffer2_ricezione);

            move(HTTPBody[1],buffer2_ricezione,to_write);
            delete(HTTPBody,1,to_write);


            write_download(download,
                           risorsa,
                           @buffer2_ricezione,
                           to_write,
                           risorsa.progress_su_disco+risorsa.start_byte);
                           
              inc(risorsa.progress_su_disco,to_write);

              inc(brecv,to_write);
              inc(brecvmega,to_write);
              dec(risorsa.size_to_receive,to_write);
              inc(risorsa.progress,to_write);

                inc(download.progress,to_write);

                if ((cardinal(download)=m_graphObject) or
                    (cardinal(risorsa)=m_graphObject)) then GraphAddsample(to_write);

         end; //while

     end;

       risorsa.last_in := tempo;

result := 0;

except
result := 1;
end;
end;

{procedure tthread_download.drop_corrupting_sources_ip(risorsa: Trisorsa_download);
var
i: Integer;
down: Tdownload;
ris: Trisorsa_download;
begin

try
down := risorsa.download;

 i := 0;
 while (i<down.lista_risorse.count) do begin
  ris := down.lista_risorse[i];

  if ris=risorsa then begin
   inc(i);
   continue;
  end;

   if ris.ip=risorsa.ip then begin
     down.lista_risorse.delete(i);
     SourceDestroy(ris,false);
   end else
   if copy(int_2_dword_string(ris.ip),1,2)=copy(int_2_dword_string(risorsa.ip),1,2) then begin
     down.lista_risorse.delete(i);
     SourceDestroy(ris,false);
   end else inc(i);
  end;

 except
 end;

end;}

procedure tthread_download.SourceTerminatedOnDuty(risorsa: Trisorsa_download);
var
fullpiece: Boolean;
PieceOffset: Int64;
begin
with risorsa do begin

 if size_to_receive>0 then begin    //not completed
   if writeCache<>nil then FreeAndNil(writecache);
  // update chunks db or file info (in case of small files)
   if piece<>nil then helper_ich.ICH_SaveDownloadBitField(download)
    else update_hole_table(download);
  SourceDoIdle(risorsa,true);
  exit;
 end;


               down_general := download;
               state := srs_idle;
               if writeCache<>nil then FreeAndNil(writecache);

                  if piece<>nil then begin

                    if helper_ich.ICH_verify_chunk(down_general,risorsa) then helper_ich.ICH_SaveDownloadBitField(down_general);
                   
                   piece.FInUse := False;
                   FullPiece := (risorsa.start_byte=piece.fOffset);
                   PieceOffset := piece.FOffset;
                   piece := nil;

                     if not ICH_failed then begin
                      synchronize(UpdateVisualBitField);
                      risorsa.ICH_passed := True;

                      if PieceOffset=0 then
                       if down_general.AviHeaderState=aviStateNotChecked then
                        helper_preview.CheckAviHeader(down_general);
                        
                     end else begin
                        if FullPiece then SourceDestroy(risorsa,false,true)
                         else SourceDoIdle(risorsa,true);
                        exit;
                     end;
                  end;


               if speed>20000 then inc(succesfull_factor,12) else
               if speed>10000 then inc(succesfull_factor,8) else
               inc(succesfull_factor,4);

               if socket<>nil then socket.buffstr := '';
               out_buf := '';
               progress := 0;
               global_size := 0;
               have_tried := False;
               queued_position := 0;
               tick_attivazione := gettickcount;
               progress_su_disco := 0;
               
          if down_general.progress>=down_general.size then begin
           DownloadDoComplete(down_general);
           exit;
          end;

                       if not source_startbyte_assign(down_general,risorsa) then begin
                          if DoIdleSlowestSource(down_general,risorsa) then begin
                             if not source_startbyte_assign(down_general,risorsa) then begin
                               SourceDoIdle(risorsa,true);
                               exit;
                             end;
                          end;
                       end;


          if risorsa.socket=nil then begin  //UDP source?
            risorsa.unAckedPackets := 0;
            risorsa.nextUDPOutInterval := 1000;
            risorsa.lastUDPOut := 0;
            risorsa.state := srs_waitingForUserUDPPieceAck;
            sourceSendUDPPieceRequest(download,risorsa);
          end else begin
            actual_decrypt_key := random($ffff);
            encryption_branch := 1;
            out_http_get_req_str(out_buf,download,risorsa);
            state := srs_connected;
            tick_attivazione := gettickcount;
            speed := 0;
          end;


end;

end;

function tthread_download.DoIdleSlowestSource(download: Tdownload; risorsa: Trisorsa_download): Boolean;
var
i: Integer;
ris: Trisorsa_download;
tempo: Cardinal;
begin

result := False;

for i := 0 to download.lista_risorse.count-1 do begin
 ris := download.lista_risorse[i];
 if ris=risorsa then continue;
 if ris.piece=nil then continue; //should never happen
  if isSourceState(ris,srs_connecting) then begin
   SourceDoIdle(ris,true);
   Result := True;
   exit;
  end;
end;


if download.lista_risorse.count>1 then download.lista_risorse.sort(ordina_risorse_slower_prima);

tempo := gettickcount;
for i := 0 to download.lista_risorse.count-1 do begin
 ris := download.lista_risorse[i];
 if ris=risorsa then continue;
  if ris.state<>srs_receiving then continue;
   if tempo-ris.started_time<5000 then continue;   // started soon
    if ris.speed>(risorsa.speed div 2) then continue; // reasonably fast
     if ris.size_to_receive<(ris.speed * 5) then continue; //...going to be completed within 5 seconds

         RemoveFromDuty(ris);
         update_hole_table(download);
         SourceDoIdle(ris,true);

           Result := True;
           exit;
end;
end;




procedure tthread_download.ReceiveFiles;  
var
tempo: Cardinal;
tot_amount_recv: Integer;
loc_amount_recv: Integer;
cicli_da_fare: Integer;
begin
if SourcesOnDuty.count=0 then exit;

tempo := gettickcount;

if download_bandwidth>0 then begin
  if tempo-last_receive_tick<5*TENTHOFSEC then exit;
  last_receive_tick := tempo;

 tot_amount_recv := (download_bandwidth*KBYTE) div 2; // due letture al secondo
 loc_amount_recv := tot_amount_recv div SourcesOnDuty.count;

 if loc_amount_recv>KBYTE then begin  //troppo da inviare per il buffer, riduciamo
  cicli_da_fare := (loc_amount_recv div KBYTE)+1;
  loc_amount_recv := loc_amount_recv div cicli_da_fare;
 end else cicli_da_fare := 1;

 ReceiveFiles(loc_amount_recv,cicli_da_fare,Tempo);

end else ReceiveFiles(tempo);

end;

procedure tthread_download.RemoveFromDuty(risorsa: Trisorsa_download);
var
download: Tdownload;
ind: Integer;
begin

 if risorsa.writeCache<>nil then FreeAndNil(risorsa.writecache);
 ind := SourcesOnDuty.indexof(risorsa);
 if ind<>-1 then begin
   SourcesOnDuty.delete(ind);
   dec_download_num(risorsa.download);
 end else
 if risorsa.state=srs_UDPDownloading then dec_download_num(risorsa.download);


 download := risorsa.download;
 if download.is_getting_phash then begin
   if risorsa.getting_phash then begin
    download.is_getting_phash := False;
   if download.phash_stream<>nil then FreeHandleStream(download.phash_stream);
  end;
 end;

  risorsa.state := srs_idle;

end;

procedure tthread_download.ReceiveFiles(BytesToRecv: Integer; Cicles: Integer; Tempo: Cardinal);
var
i: Integer;
risorsa: Trisorsa_download;
begin

 i := 0;
 while (i<SourcesOnDuty.count) do begin
   risorsa := SourcesOnDuty[i];

      if tempo-risorsa.last_in>TIMEOUT_RECEIVING_FILE then begin
       SourcesOnDuty.delete(i);
         dec_download_num(risorsa.download);
        SourceTerminatedOnDuty(risorsa);
       continue
      end;

      ReceiveSource(risorsa,tempo,i,Cicles,BytesToRecv);

  inc(i);
 end;

end;

procedure tthread_download.ReceiveFiles(Tempo: Cardinal);
var
i: Integer;
risorsa: TRisorsa_download;
begin

  i := 0;
  while (i<SourcesOnDuty.count) do begin
   risorsa := SourcesOnDuty[i];

      if tempo-risorsa.last_in>TIMEOUT_RECEIVING_FILE then begin
        SourcesOnDuty.delete(i);
         dec_download_num(risorsa.download);
        SourceTerminatedOnDuty(risorsa);
       exit;
      end;

      ReceiveSource(risorsa,tempo,i);

      if (i mod 10)=0 then
       if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(True);

      inc(i);
   end;

end;

procedure tthread_download.ReceiveSource(risorsa: TRisorsa_download; Tempo: Cardinal; indexInList:integer);
//var
//cicles: Integer;
begin
{cicles := 40-SourcesOnDuty.count;
if cicles<5 then cicles := 5;     }
ReceiveSource(risorsa,Tempo,indexInList,20,0);
end;

procedure tthread_download.ReceiveSource(risorsa: TRisorsa_download; Tempo: Cardinal; indexInList: Integer; loops: Integer; BytesToRecv:integer);
var
to_recv,len,er,hi: Integer;
download: TDownload;
begin

while (true) do begin


      if not TCPSocket_canRead(risorsa.socket.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        SourcesOnDuty.delete(indexInList);
          dec_download_num(risorsa.download);
         SourceTerminatedOnDuty(risorsa);
       end;
       exit;
      end;


      if BytesToRecv>0 then to_recv := BytesToRecv
       else to_recv := KBYTE;
      if to_recv>risorsa.size_to_receive then to_recv := risorsa.size_to_receive;


      len := TCPSocket_RecvBuffer(risorsa.socket.socket,@buffer2_ricezione,to_recv,er);
      if er=WSAEWOULDBLOCK then exit;


      if er<>0 then begin
        SourcesOnDuty.delete(indexInList);
         dec_download_num(risorsa.download);
       SourceTerminatedOnDuty(risorsa);
       exit;
      end;


         move(buffer2_ricezione,buffer3_ricezione,len);
            for hi := 0 to Len-1 do begin
             buffer2_ricezione[hi] := buffer3_ricezione[hi] xor (risorsa.actual_decrypt_key shr 8);
             risorsa.actual_decrypt_key := (buffer3_ricezione[hi] + risorsa.actual_decrypt_key) * 52079 + 16826;
            end;



      download := risorsa.download;
      write_download(download,risorsa,@buffer2_ricezione, len, risorsa.progress_su_disco+risorsa.start_byte );
      inc(risorsa.progress_su_disco,len);


       inc(brecv,len);
       inc(brecvmega,len);
       risorsa.last_in := tempo;
       dec(risorsa.size_to_receive,len);
       inc(risorsa.progress,len);
        download := risorsa.download;
        inc(download.progress,len);

        if ((cardinal(download)=m_graphObject) or
            (cardinal(risorsa)=m_graphObject)) then GraphAddSample(len);

       if risorsa.size_to_receive<=0 then begin
        SourcesOnDuty.delete(indexInList);
         dec_download_num(risorsa.download);
        SourceTerminatedOnDuty(risorsa);
        exit;
       end;

  dec(loops);
  if loops=0 then exit;
end;

end;

procedure dec_download_num(download: TDownload);
begin
 if download.num_in_down>0 then dec(download.num_in_down);

if download.num_in_down=0 then
 if isDownloadState(download,dlDownloading) then download.state := dlProcessing;

end;


procedure tthread_download.SourceDestroy(risorsa: Trisorsa_download; fast: Boolean; addToBanList:boolean=false);
var
ind: Integer;
download: Tdownload;
begin

  if risorsa.piece<>nil then begin
   risorsa.piece.FInUse := False;
   risorsa.piece := nil;
  end;
  
 RemoveFromDuty(risorsa);



 try
  if risorsa.download<>nil then begin
   download := risorsa.download;

         if download.is_getting_phash then begin
          if risorsa.getting_phash then begin
           download.is_getting_phash := False;
           if download.phash_stream<>nil then FreeHandleStream(download.phash_stream);
          end;
         end;

   ind := download.lista_risorse.indexof(risorsa);
   if ind<>-1 then download.lista_risorse.delete(ind);

      if addToBanList then download.AddToBanList(risorsa.ip);


  end;
 except
 end;

   try
   if risorsa.socket<>nil then risorsa.socket.Free;
   except
   end;
   risorsa.socket := nil; // per clear interno in destroy risorsa...

   if not fast then begin
    risorsa_general := risorsa;
    synchronize(FreeSource);
   end else begin
    risorsa.display_node := nil;
    risorsa.Free;
   end;

end;

procedure tthread_download.freeSource;
begin
risorsa_general.Free;
end;

procedure tthread_download.SourceDoIdle(risorsa: Trisorsa_download; destroy_socket:boolean);
begin
try

         if risorsa.piece<>nil then begin
          risorsa.piece.FInUse := False;
          risorsa.piece := nil;
         end;

         down_general := risorsa.download;
         if down_general.is_getting_phash then
          if risorsa.getting_phash then begin
           down_general.is_getting_phash := False;
           risorsa.getting_phash := False;
           if down_general.phash_stream<>nil then FreeHandleStream(down_general.phash_stream);
          end;

        RemoveFromDuty(risorsa);

      with risorsa do begin
         tick_attivazione := gettickcount;
         out_buf := '';
         if UDP_Socket<>INVALID_SOCKET then TCPSocket_Free(UDP_Socket);
         UDP_Socket := INVALID_SOCKET;
         
         if destroy_socket then
          if socket<>nil then FreeAndNil(socket);

         CurrentUDPPushSupernode := 0;
         state := srs_idle;
         speed := 0;
         start_byte := 0;
         progress := 0;
         global_size := 0;
         end_byte := 0;
         out_buf := '';
      end;

except
end;
end;




procedure tthread_download.DownloadDoComplete(download: Tdownload);
var
rebuilder: Tth_rbld;
risorsa: Trisorsa_download;
point_of_insertion: Cardinal;
hashophash: string;
begin
try
 if download.state=dlRebuilding then exit;

 download.state := dlRebuilding;

 FlushFileBuffers(download.stream.handle);

 erase_holedb(download);

 down_general := download; //download is already down_general
 synchronize(checkPreviewedFile);


 rename_file(download);

 if Frestart_player then begin
  FRestart_Player := False;
  synchronize(RestartPreview);
 end;


 hashophash := '';
 
 point_of_insertion := 0;
 if length(download.FPieces)>0 then
  if download.FPieceSize>0 then begin
    if length(download.hash_of_phash)<>20 then hashophash := ICH_get_hash_of_phash_fromDLHASH(download.hash_sha1) else hashophash := download.hash_of_phash;
    point_of_insertion := ICH_copyDlhash_todb(download);
  end;


 try
  while (download.lista_risorse.count>0) do begin
   risorsa := download.lista_risorse[0];
            download.lista_risorse.delete(0);
        SourceDestroy(risorsa,true);
  end;
 except
 end;

 try
 down_general := download;
 synchronize(upDate_lastbitofhint);
 except
 end;




rebuilder := tth_rbld.create(true);
with rebuilder do begin
 nomefile := download.filename;
 handle_download := cardinal(download);
 size := download.size;
 title := download.title;
 artist := download.artist;
 album := download.album;
 hash_of_phash_paragone := hashophash;
 point_of_phash_db := point_of_insertion;
 category := download.category;
 comment := download.comments;
 url := download.url;
 language := download.language;
 year := download.date;
 in_subfolder := download.in_subfolder;
 crcsha1_paragone := download.crcsha1;
 hash_sha1_paragone := download.hash_sha1;
 keyword_genre := download.keyword_genre;
 amime := download.tipo;
  resume;
end;



except
end;
end;

procedure tthread_download.restartPreview;  //sync
begin
try
 helper_player.player_playnew(utf8strtowidestr(down_general.filename));
except
end;
end;

procedure tthread_download.checkPreviewedFile; //sync
begin
try


 if lowercase(widestrtoutf8str(down_general.filename))=lowercase(widestrtoutf8str(helper_player.player_actualfile)) then begin
  Frestart_player := True;
  try
  ares_frmmain.Timer_sec.enabled := False;
  helper_player.stopmedia(nil);
  sleep(50);
  utility_ares.WaitProcessing(50);
  except
  end;
  ares_frmmain.Timer_sec.enabled := True;
 end else Frestart_player := False;

except
end;
end;

procedure tthread_download.upDate_lastbitofhint; //synch
var
i: Integer;
begin

down_general.progress := down_general.size;

if down_general.display_node=nil then exit;

 ares_frmmain.treeview_download.deletechildren(down_general.display_node,true);

 if length(down_general.FPieces)>0 then
  if length(down_general.display_data.VisualBitField)=length(down_general.FPieces) then
   for i := 0 to high(down_general.display_data.VisualBitField) do
    if (down_general.FPieces[i] as TDownloadPiece).FDone then down_general.display_data.VisualBitField[i] := True;

 try
 ares_frmmain.treeview_download.invalidatenode(down_general.display_node);
 update_hint(down_general.display_node);
 except
 end;
end;




procedure Tthread_download.SourceFlushRequest(download: Tdownload;risorsa: TRisorsa_download);
var
er: Integer;
begin

 with risorsa do begin


   if tempo-tick_attivazione>TIMEOUT_FLUSH_TCP then begin  // tempo scaduto dopo 14 seocndi che non riesco ad inviare richiesta...
     inc(num_fail);
     if succesfull_factor>0 then dec(succesfull_factor);
     SourceDoIdle(risorsa,true);
     exit;
   end;


  TCPSocket_SendBuffer(socket.socket,@out_buf[1],length(out_buf),er);

  if er=WSAEWOULDBLOCK then exit;
  if er<>0 then begin
   inc(num_fail);
   if succesfull_factor>0 then dec(succesfull_factor);
   SourceDoIdle(risorsa,true);
   exit;
  end;


  out_buf := '';
  socket.buffstr := '';
  tick_attivazione := gettickcount;
  state := srs_receivingReply;

 end;

end;



function tthread_download.ebx(idx: Byte; b: Byte): Integer;
begin
case idx of
0: Result := $56006 - b;
1: Result := $22393 - b;
2: Result := $1018 - b;
3: Result := $21021 - b;
4: Result := $32701 - b;
5: Result := $49815 - b;
6: Result := $46785 - b;
7: Result := $63166 - b;
8: Result := $4669 - b;
9: Result := $26777 - b;
10: Result := $59416 - b;
11: Result := $49340 - b;
12: Result := $33377 - b;
13: Result := $58614 - b;
14: Result := $63496 - b;
15: Result := $435 - b;
16: Result := $24421 - b;
17: Result := $38867 - b;
18: Result := $27376 - b;
19: Result := $16887 - b;
20: Result := $53031 - b;
21: Result := $27497 - b;
22: Result := $29863 - b;
23: Result := $26661 - b;
24: Result := $33756 - b;
25: Result := $37048 - b;
26: Result := $22482 - b;
27: Result := $1513 - b;
28: Result := $27664 - b;
29: Result := $57195 - b;
30: Result := $62850 - b;
31: Result := $38410 - b;
32: Result := $6370 - b;
33: Result := $50444 - b;
34: Result := $10516 - b;
35: Result := $47037 - b;
36: Result := $5758 - b;
37: Result := $61289 - b;
38: Result := $52290 - b;
39: Result := $45865 - b;
40: Result := $45786 - b;
41: Result := $7752 - b;
42: Result := $32654 - b;
43: Result := $54071 - b;
44: Result := $61110 - b;
45: Result := $51272 - b;
46: Result := $37586 - b;
47: Result := $24733 - b;
48: Result := $38097 - b;
49: Result := $32535 - b;
50: Result := $43553 - b;
51: Result := $18987 - b;
52: Result := $45926 - b;
53: Result := $16092 - b;
54: Result := $64226 - b;
55: Result := $50773 - b;
56: Result := $62448 - b;
57: Result := $5340 - b;
58: Result := $15662 - b;
59: Result := $31234 - b;
60: Result := $36124 - b;
61: Result := $51567 - b;
62: Result := $44390 - b;
63: Result := $61589 - b;
64: Result := $51979 - b;
65: Result := $31016 - b;
66: Result := $47641 - b;
67: Result := $28986 - b;
68: Result := $27083 - b;
69: Result := $18753 - b;
70: Result := $14870 - b;
71: Result := $32116 - b;
72: Result := $15893 - b;
73: Result := $41798 - b;
74: Result := $18126 - b;
75: Result := $34021 - b;
76: Result := $59464 - b;
77: Result := $41987 - b;
78: Result := $5870 - b;
79: Result := $39517 - b;
80: Result := $36263 - b;
81: Result := $43441 - b;
82: Result := $30010 - b;
83: Result := $13863 - b;
84: Result := $54224 - b;
85: Result := $11613 - b;
86: Result := $44973 - b;
87: Result := $20881 - b;
88: Result := $39550 - b;
89: Result := $21402 - b;
90: Result := $6864 - b;
91: Result := $26554 - b;
92: Result := $12161 - b;
93: Result := $57448 - b;
94: Result := $34135 - b;
95: Result := $10145 - b;
96: Result := $63739 - b;
97: Result := $31333 - b;
98: Result := $14339 - b;
99: Result := $58219 - b;
100: Result := $53725 - b;
101: Result := $26932 - b;
102: Result := $23989 - b;
103: Result := $2294 - b;
104: Result := $38051 - b;
105: Result := $15147 - b;
106: Result := $61391 - b;
107: Result := $12189 - b;
108: Result := $36941 - b;
109: Result := $65088 - b;
110: Result := $33490 - b;
111: Result := $34635 - b;
112: Result := $58271 - b;
113: Result := $63543 - b;
114: Result := $36659 - b;
115: Result := $46275 - b;
116: Result := $64154 - b;
117: Result := $2567 - b;
118: Result := $4735 - b;
119: Result := $26415 - b;
120: Result := $43580 - b;
121: Result := $10891 - b;
122: Result := $42159 - b;
123: Result := $13032 - b;
124: Result := $42613 - b;
125: Result := $42095 - b;
126: Result := $24013 - b;
127: Result := $32134 - b;
128: Result := $20074 - b;
129: Result := $859 - b;
130: Result := $10185 - b;
131: Result := $34601 - b;
132: Result := $2799 - b;
133: Result := $56410 - b;
134: Result := $22679 - b;
135: Result := $56583 - b;
136: Result := $47934 - b;
137: Result := $56718 - b;
138: Result := $45195 - b;
139: Result := $49463 - b;
140: Result := $60414 - b;
141: Result := $53528 - b;
142: Result := $6392 - b;
143: Result := $21438 - b;
144: Result := $54386 - b;
145: Result := $32578 - b;
146: Result := $48900 - b;
147: Result := $35032 - b;
148: Result := $22015 - b;
149: Result := $39920 - b;
150: Result := $26319 - b;
151: Result := $14473 - b;
152: Result := $31202 - b;
153: Result := $11079 - b;
154: Result := $4805 - b;
155: Result := $54116 - b;
156: Result := $10545 - b;
157: Result := $2461 - b;
158: Result := $23360 - b;
159: Result := $34972 - b;
160: Result := $6928 - b;
161: Result := $33441 - b;
162: Result := $4708 - b;
163: Result := $59722 - b;
164: Result := $13621 - b;
165: Result := $9165 - b;
166: Result := $4148 - b;
167: Result := $21759 - b;
168: Result := $55966 - b;
169: Result := $13833 - b;
170: Result := $17146 - b;
171: Result := $48011 - b;
172: Result := $58514 - b;
173: Result := $35489 - b;
174: Result := $24534 - b;
175: Result := $32781 - b;
176: Result := $16856 - b;
177: Result := $34666 - b;
178: Result := $53157 - b;
179: Result := $35133 - b;
180: Result := $30773 - b;
181: Result := $40497 - b;
182: Result := $46102 - b;
183: Result := $51958 - b;
184: Result := $33833 - b;
185: Result := $39782 - b;
186: Result := $8457 - b;
187: Result := $54535 - b;
188: Result := $53995 - b;
189: Result := $30728 - b;
190: Result := $58920 - b;
191: Result := $13116 - b;
192: Result := $21156 - b;
193: Result := $39632 - b;
194: Result := $33993 - b;
195: Result := $43688 - b;
196: Result := $54504 - b;
197: Result := $46242 - b;
198: Result := $11780 - b;
199: Result := $41015 - b;
200: Result := $16251 - b;
201: Result := $42034 - b;
202: Result := $58641 - b;
203: Result := $13427 - b;
204: Result := $18242 - b;
205: Result := $3316 - b;
206: Result := $8678 - b;
207: Result := $57490 - b;
208: Result := $45448 - b;
209: Result := $36167 - b;
210: Result := $36878 - b;
211: Result := $41162 - b;
212: Result := $22389 - b;
213: Result := $49122 - b;
214: Result := $50636 - b;
215: Result := $63438 - b;
216: Result := $26569 - b;
217: Result := $29824 - b;
218: Result := $3955 - b;
219: Result := $22440 - b;
220: Result := $41694 - b;
221: Result := $52168 - b;
222: Result := $43773 - b;
223: Result := $48061 - b;
224: Result := $36062 - b;
225: Result := $8833 - b;
226: Result := $4084 - b;
227: Result := $32795 - b;
228: Result := $53825 - b;
229: Result := $63476 - b;
230: Result := $8064 - b;
231: Result := $49670 - b;
232: Result := $23180 - b;
233: Result := $15266 - b;
234: Result := $22731 - b;
235: Result := $54723 - b;
236: Result := $50501 - b;
237: Result := $44584 - b;
238: Result := $28062 - b;
239: Result := $40357 - b;
240: Result := $19771 - b;
241: Result := $16753 - b;
242: Result := $54071 - b;
243: Result := $52823 - b;
244: Result := $19958 - b;
245: Result := $42011 - b;
246: Result := $11115 - b;
247: Result := $27754 - b;
248: Result := $59257 - b;
249: Result := $25644 - b;
250: Result := $41466 - b;
251: Result := $3872 - b;
252: Result := $31808 - b;
253: Result := $21751 - b;
254: Result := $39479 - b;
255: Result := $46199 - b;
end;
end;

function tthread_download.eax(idx: Byte; b: Byte): Integer;
begin
case idx of
0: Result := $46369 + b;
1: Result := $10881 + b;
2: Result := $1323 + b;
3: Result := $28502 + b;
4: Result := $10118 + b;
5: Result := $56432 + b;
6: Result := $38795 + b;
7: Result := $48234 + b;
8: Result := $43918 + b;
9: Result := $32134 + b;
10: Result := $64583 + b;
11: Result := $60008 + b;
12: Result := $33251 + b;
13: Result := $49843 + b;
14: Result := $46219 + b;
15: Result := $6499 + b;
16: Result := $3529 + b;
17: Result := $11016 + b;
18: Result := $50449 + b;
19: Result := $53292 + b;
20: Result := $56658 + b;
21: Result := $55433 + b;
22: Result := $25197 + b;
23: Result := $35286 + b;
24: Result := $23753 + b;
25: Result := $49491 + b;
26: Result := $22166 + b;
27: Result := $57707 + b;
28: Result := $41302 + b;
29: Result := $21747 + b;
30: Result := $43960 + b;
31: Result := $6129 + b;
32: Result := $63223 + b;
33: Result := $61950 + b;
34: Result := $26682 + b;
35: Result := $61593 + b;
36: Result := $7586 + b;
37: Result := $51191 + b;
38: Result := $26636 + b;
39: Result := $8008 + b;
40: Result := $25011 + b;
41: Result := $353 + b;
42: Result := $40755 + b;
43: Result := $50504 + b;
44: Result := $64412 + b;
45: Result := $21024 + b;
46: Result := $20888 + b;
47: Result := $47184 + b;
48: Result := $25295 + b;
49: Result := $17942 + b;
50: Result := $3087 + b;
51: Result := $36788 + b;
52: Result := $32740 + b;
53: Result := $60410 + b;
54: Result := $27300 + b;
55: Result := $46054 + b;
56: Result := $59920 + b;
57: Result := $47228 + b;
58: Result := $63530 + b;
59: Result := $60470 + b;
60: Result := $39881 + b;
61: Result := $48537 + b;
62: Result := $45831 + b;
63: Result := $9929 + b;
64: Result := $51890 + b;
65: Result := $37434 + b;
66: Result := $827 + b;
67: Result := $30419 + b;
68: Result := $52942 + b;
69: Result := $34322 + b;
70: Result := $11696 + b;
71: Result := $34074 + b;
72: Result := $17636 + b;
73: Result := $64950 + b;
74: Result := $37062 + b;
75: Result := $61100 + b;
76: Result := $55341 + b;
77: Result := $4862 + b;
78: Result := $13856 + b;
79: Result := $19937 + b;
80: Result := $24390 + b;
81: Result := $54684 + b;
82: Result := $34217 + b;
83: Result := $59789 + b;
84: Result := $14419 + b;
85: Result := $51196 + b;
86: Result := $9707 + b;
87: Result := $18057 + b;
88: Result := $4209 + b;
89: Result := $29789 + b;
90: Result := $21906 + b;
91: Result := $5987 + b;
92: Result := $33374 + b;
93: Result := $13870 + b;
94: Result := $19004 + b;
95: Result := $18017 + b;
96: Result := $14444 + b;
97: Result := $37803 + b;
98: Result := $24709 + b;
99: Result := $5564 + b;
100: Result := $32164 + b;
101: Result := $50104 + b;
102: Result := $10577 + b;
103: Result := $37402 + b;
104: Result := $27193 + b;
105: Result := $15359 + b;
106: Result := $41048 + b;
107: Result := $54093 + b;
108: Result := $5934 + b;
109: Result := $25415 + b;
110: Result := $6137 + b;
111: Result := $51021 + b;
112: Result := $34119 + b;
113: Result := $50196 + b;
114: Result := $42553 + b;
115: Result := $33651 + b;
116: Result := $9014 + b;
117: Result := $23430 + b;
118: Result := $7963 + b;
119: Result := $22517 + b;
120: Result := $7936 + b;
121: Result := $57451 + b;
122: Result := $59428 + b;
123: Result := $8615 + b;
124: Result := $61102 + b;
125: Result := $7848 + b;
126: Result := $12592 + b;
127: Result := $38383 + b;
128: Result := $48187 + b;
129: Result := $49864 + b;
130: Result := $24176 + b;
131: Result := $34058 + b;
132: Result := $41147 + b;
133: Result := $12771 + b;
134: Result := $44997 + b;
135: Result := $20096 + b;
136: Result := $56009 + b;
137: Result := $18867 + b;
138: Result := $28994 + b;
139: Result := $996 + b;
140: Result := $27700 + b;
141: Result := $9457 + b;
142: Result := $16637 + b;
143: Result := $62925 + b;
144: Result := $51946 + b;
145: Result := $16374 + b;
146: Result := $13846 + b;
147: Result := $42778 + b;
148: Result := $37158 + b;
149: Result := $39311 + b;
150: Result := $62730 + b;
151: Result := $25187 + b;
152: Result := $22743 + b;
153: Result := $44066 + b;
154: Result := $64827 + b;
155: Result := $60859 + b;
156: Result := $11858 + b;
157: Result := $23297 + b;
158: Result := $48057 + b;
159: Result := $6319 + b;
160: Result := $17977 + b;
161: Result := $12299 + b;
162: Result := $12117 + b;
163: Result := $8312 + b;
164: Result := $58026 + b;
165: Result := $34186 + b;
166: Result := $10727 + b;
167: Result := $9860 + b;
168: Result := $37805 + b;
169: Result := $30793 + b;
170: Result := $31451 + b;
171: Result := $13605 + b;
172: Result := $16090 + b;
173: Result := $48629 + b;
174: Result := $36610 + b;
175: Result := $36505 + b;
176: Result := $39495 + b;
177: Result := $48055 + b;
178: Result := $20889 + b;
179: Result := $16956 + b;
180: Result := $1723 + b;
181: Result := $30993 + b;
182: Result := $23187 + b;
183: Result := $17418 + b;
184: Result := $62734 + b;
185: Result := $19191 + b;
186: Result := $46636 + b;
187: Result := $33368 + b;
188: Result := $17119 + b;
189: Result := $21295 + b;
190: Result := $53681 + b;
191: Result := $46548 + b;
192: Result := $14971 + b;
193: Result := $12267 + b;
194: Result := $22923 + b;
195: Result := $59324 + b;
196: Result := $8715 + b;
197: Result := $30629 + b;
198: Result := $5260 + b;
199: Result := $59996 + b;
200: Result := $34301 + b;
201: Result := $56634 + b;
202: Result := $2172 + b;
203: Result := $16332 + b;
204: Result := $43701 + b;
205: Result := $6220 + b;
206: Result := $29667 + b;
207: Result := $10984 + b;
208: Result := $53622 + b;
209: Result := $60883 + b;
210: Result := $26904 + b;
211: Result := $59024 + b;
212: Result := $15501 + b;
213: Result := $62723 + b;
214: Result := $5772 + b;
215: Result := $16163 + b;
216: Result := $7869 + b;
217: Result := $62563 + b;
218: Result := $2130 + b;
219: Result := $2615 + b;
220: Result := $57839 + b;
221: Result := $62251 + b;
222: Result := $61168 + b;
223: Result := $14491 + b;
224: Result := $28956 + b;
225: Result := $23264 + b;
226: Result := $46954 + b;
227: Result := $32399 + b;
228: Result := $29044 + b;
229: Result := $50475 + b;
230: Result := $142 + b;
231: Result := $52802 + b;
232: Result := $38609 + b;
233: Result := $20992 + b;
234: Result := $14715 + b;
235: Result := $8335 + b;
236: Result := $32609 + b;
237: Result := $41452 + b;
238: Result := $62837 + b;
239: Result := $18419 + b;
240: Result := $49807 + b;
241: Result := $53439 + b;
242: Result := $16622 + b;
243: Result := $51663 + b;
244: Result := $7987 + b;
245: Result := $3165 + b;
246: Result := $973 + b;
247: Result := $63972 + b;
248: Result := $62715 + b;
249: Result := $41950 + b;
250: Result := $48385 + b;
251: Result := $54284 + b;
252: Result := $29979 + b;
253: Result := $43758 + b;
254: Result := $9037 + b;
255: Result := $20536 + b;
end;
end;

function tthread_download.en_parz(s: string): string;
var
I: cardinal;
b: Word;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
b := 12;



try
 Result := s;
    for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 6));
        b := (byte(Result[I]) + b) + (byte(result[I]) + eax(byte(result[I]),byte(result[i]) xor b));
        b := (byte(result[I]) - b) * (byte(result[I]) - ebx(byte(result[I]),byte(result[i]) + b));
        if byte(result[i])<93 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>222 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>104 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<110 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<25 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>18 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<54 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<104 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<50 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>153 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>245 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>36 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<45 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<4 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>85 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<42 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<70 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>145 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>246 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<86 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>172 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<160 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<235 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<78 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>195 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<165 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<76 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>130 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>130 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<187 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<205 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>196 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>211 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>187 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<118 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>105 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>19 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>233 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<96 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<250 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>143 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<48 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<128 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>126 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<41 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b + byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>234 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<143 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>70 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<241 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<67 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>241 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<86 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<233 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<29 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<188 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<86 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<196 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<142 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<190 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>23 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>193 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>238 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>169 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>165 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<146 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<112 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>55 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<235 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>84 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<75 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<111 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>232 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>149 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<123 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>246 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<111 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<111 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<12 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>106 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>126 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<169 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>237 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<213 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<32 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<247 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>104 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>44 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<223 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<58 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>22 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>218 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<205 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>218 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>104 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>104 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>16 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<49 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>203 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>37 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<11 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<252 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<79 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<232 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>13 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>235 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<222 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<226 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<155 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<47 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<16 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<122 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>63 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>37 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>128 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<61 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<232 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>20 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<188 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>222 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<231 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<234 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<188 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>74 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>106 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<28 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>242 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>189 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<147 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>135 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<226 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<251 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>28 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>109 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>80 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>142 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>136 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<121 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>249 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<17 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>234 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<214 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<225 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>145 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>55 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>92 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<47 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>3 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>39 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<191 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<145 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>185 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>172 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<222 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<69 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<249 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>243 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>23 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>150 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<156 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>251 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<173 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<5 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>184 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>180 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>69 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>232 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<102 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>181 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<102 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>175 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>141 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<129 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>24 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>171 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>197 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<84 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<135 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>106 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>68 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<145 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<186 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<162 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>222 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<171 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<94 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>176 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>22 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<176 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>154 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>159 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<57 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>88 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<250 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<197 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<149 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>172 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>98 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<240 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>177 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<53 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>26 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<33 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>163 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>196 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<226 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<212 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>104 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<196 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>29 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>227 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<92 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<27 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<3 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<232 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<178 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<162 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<240 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<65 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<9 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>37 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<182 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>149 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<8 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>246 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<7 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<244 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>15 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>23 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>230 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<131 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<246 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<227 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<61 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<177 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<222 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>91 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>100 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<10 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>15 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<243 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<212 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>141 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<230 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>251 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<218 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<157 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<216 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>143 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>94 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<120 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<127 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>23 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])>187 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));
if byte(result[i])<66 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])<187 then b := b xor ebx(byte(result[I]),byte(result[i]) - (b  +  byte(result[i]))) else b := b xor eax(byte(result[I]),byte(result[i]) and b);
if byte(result[i])>100 then b := b xor eax(byte(result[I]),byte(result[i]) xor b) else b := b xor ebx(byte(result[I]),byte(result[i]) - (b xor byte(result[i])));


    end;


except
end;
end;

function tthread_download.de_parz(s: string): string;
var
I: cardinal;
b: Word;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
 b := 12;
 Result := s;

     for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 6));
        b := (byte(s[I]) + b) + (byte(S[I]) + eax(byte(S[I]),byte(s[i]) xor b));
        b := (byte(s[I]) - b) * (byte(S[I]) - ebx(byte(S[I]),byte(s[i])+ b));

        if byte(s[i])<93 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>222 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>104 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<110 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<25 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>18 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<54 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<104 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<50 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>153 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>245 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>36 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<45 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<4 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>85 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<42 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<70 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>145 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>246 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<86 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>172 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<160 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<235 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<78 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>195 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<165 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<76 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>130 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>130 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<187 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<205 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>196 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>211 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>187 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<118 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>105 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>19 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>233 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<96 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<250 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>143 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<48 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<128 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>126 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<41 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>234 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<143 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>70 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<241 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<67 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>241 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<86 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<233 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<29 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<188 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<86 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<196 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<142 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<190 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>23 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>193 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>238 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>169 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>165 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<146 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<112 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>55 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<235 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>84 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<75 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<111 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>232 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>149 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<123 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>246 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<111 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<111 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<12 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>106 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>126 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<169 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>237 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<213 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<32 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<247 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>104 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>44 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<223 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<58 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>22 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>218 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<205 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>218 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>104 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>104 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>16 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<49 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>203 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>37 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<11 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<252 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<79 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<232 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>13 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>235 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<222 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<226 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<155 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<47 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<16 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<122 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>63 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>37 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>128 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<61 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<232 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>20 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<188 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>222 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<231 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<234 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<188 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>74 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>106 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<28 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>242 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>189 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<147 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>135 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<226 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<251 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>28 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>109 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>80 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>142 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>136 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<121 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>249 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<17 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>234 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<214 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<225 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>145 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>55 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>92 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<47 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>3 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>39 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<191 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<145 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>185 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>172 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<222 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<69 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<249 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>243 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>23 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>150 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<156 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>251 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<173 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<5 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>184 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>180 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>69 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>232 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<102 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>181 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<102 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>175 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>141 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<129 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>24 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>171 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>197 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<84 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<135 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>106 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>68 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<145 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<186 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<162 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>222 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<171 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<94 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>176 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>22 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<176 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>154 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>159 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<57 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>88 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<250 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<197 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<149 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>172 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>98 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<240 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>177 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<53 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>26 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<33 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>163 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>196 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<226 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<212 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>104 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<196 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>29 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>227 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<92 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<27 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<3 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<232 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<178 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<162 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<240 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<65 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<9 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>37 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<182 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>149 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<8 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>246 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<7 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<244 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>15 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>23 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>230 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<131 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<246 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<227 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<61 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<177 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<222 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>91 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>100 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<10 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>15 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<243 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<212 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>141 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<230 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>251 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<218 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<157 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<216 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>143 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>94 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<120 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<127 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>23 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])>187 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));
if byte(s[i])<66 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])<187 then b := b xor ebx(byte(s[I]),byte(s[i]) - (b  +  byte(s[i]))) else b := b xor eax(byte(s[I]),byte(s[i]) and b);
if byte(s[i])>100 then b := b xor eax(byte(s[I]),byte(s[i]) xor b) else b := b xor ebx(byte(s[I]),byte(s[i]) - (b xor byte(s[i])));


    end;

end;




end.
