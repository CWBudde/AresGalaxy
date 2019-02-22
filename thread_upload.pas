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
upload main code, this thread also accepts private chats and download pushes connections
furthermore it connects to remote downloaders to deliver pushes(requested through thread_client)
}

unit thread_upload;

interface

uses
  Classes,windows,sysutils,blcksock,synsock,utility_ares,
  ares_types,comettrees,registry,graphics,class_cmdlist,
  controls,const_ares,forms,comctrls,classes2,
  winsock,ares_objects,tntwindows,helper_graphs;


type
precord_udpping=^record_udpping;
record_udpping=record
 fip: Cardinal;
 fport: Word;
 fsent: Byte;
 Finterval: Cardinal;
 FLastOut: Cardinal;
end;

type
  tthread_upload = class(TThread)
  private
    localip: string;
    m_limite_upload: Integer;
    last_sent_upload: Cardinal;
    
  protected
   accept_server: Ttcpblocksocket;
   lista_sockets_accepted: TMylist; 
   loc_block_pvt_chat: Boolean;
   accept_psocket_globale:precord_socket;
   lista_upload: TMylist;
   pushedRequests,IdleUploads,socketstoFlush: TMylist;
   lista_queued: TMylist;
   udppings: TMylist;
   pushes_out: TMylist;

  UDP_Socket:hsocket;
  UDP_RemoteSin: TVarSin;
  UDP_Buffer: array [0..9999] of Byte;
  UDP_len_recvd: Integer;
  
  upload_bandwidth: Cardinal;
  tempo,last_sec,last_accept,last_15_sec: Cardinal;
  last_accept_chat: Cardinal; //per prevenire superflodding chat

 lista_hashes_alternate_source: array [0..255] of pointer;
  lista_accepted_chat: TMylist; // globale assegnata quando ho trovato file in library o in download parziale

  lista_user_granted: TMylist;
  socket: Ttcpblocksocket; // main socket trattato

  meta_title: string;   //per eventuale comunicazione in header per magnet uri
  meta_artist: string;
  meta_album: string;
  meta_category: string;
  meta_language: string;
  meta_date: string;
  meta_comments: string;
  
  header: string; //lowercase req
  header_backup: string; //req ma non lowercase per i vari base64 e nickname
  is_rehashing: Boolean;
  xstats: string; //xstats inviate da nuovi uploader
  nickname: string;  //nick including agent
  agent: string;      //just agent
  partenza: Int64;   //want partial?
  fine: Int64;
  nomefile: string;
  crcnomefile: Word; //per velocizzare
  queue_firstinfirstout: Boolean; //rispettiamo posizioni coda?
  filesize_reale: Int64;
  ip_user,ip_server,ip_utente_interno: Cardinal;
  port_user,port_server: Word;
  his_progress: Byte;
  his_numero_condivisi: Integer; //impostato da apri general library view
  his_upcount: Integer; //per stats
  his_downcount: Integer;
  his_speed: Cardinal;
  his_buildn: Word;
  his_agent: string;

  wants_phash_indexs: Boolean;   //2956+ send him phash indexs?
  phash_insertion_point: Cardinal;

  is_encrypted: Boolean;
  encryption_key: Word;
  encryption_branch: Byte;

  num_available: Byte;
  MAX_SIZE_NO_QUEUE: Cardinal; //minimo size che passa le code

  free_random_visual: Integer; // per synch in get random #
  loc_max_ul_per_ip: Byte;
  velocita_up_max: Integer;
  speed_up_att: Integer;
  
  socket_globale: Ttcpblocksocket; //push e pget

  hash_sha1: string; // globale per invia tree hash
  crcsha1: Word;

  velocita_max_ufrmmain: Cardinal;

  m_graphObject: Cardinal;
  FirstGraphSample:precord_graph_sample;
  LastGraphSample:precord_graph_sample;
  NumGraphStats: Word;
  m_graphWidth: Word;

  buffer_ricezione_handshake: array [0..1024] of char;

  last_out_graph,last_minuto,last_ora: Cardinal;

  bsentp,bsentpmega: Int64;

  isSha1inLibrary: Boolean;
  ce_in_download: Boolean;
  upload_visual_per_synch: Tupload; // per rimuovere upload da visual in synch

  risorsa_globale: Trisorsa_download; //per aggiunta in synch su mp3webars.lista_temp

    procedure handle_plainTextRequests(sock: TTCPBlockSocket);
    procedure XQueued_AssignUserValues(queued:precord_queued);
    procedure BindUdpSocket;
    function hasUDPPing(ip: Cardinal): Boolean;
    procedure receive_udp;
    procedure check_firewalled_status;
    procedure checkUDPPings;
    procedure SendUDPPing(udpping:precord_udpping);
    procedure handler_UDPTransferReq;
    procedure ParseUDPSrcInfo(SrcInfo: string; var wantXSize:boolean);
    function FindUDPUpload(sourceHandle: Cardinal): TUpload;
    procedure SendBackUDPError(ErCode: Byte);
    function UDPFillData(upload: Tupload; Len: Cardinal; addHeaders:boolean): Integer;
    function UDPFillXSizeReply: Integer;
    procedure addUDPHeaders(var offset:integer);

    procedure GraphCreateFirstSamples;
    procedure GraphUpdate;  //synchronize
    procedure GraphDeal(callsynch:boolean);
    procedure GraphAddSample(Value:integer);
    procedure GraphCheckSync;
    procedure GraphIncrement(Elapsed:integer);

  procedure UploadsCheckTimeout; //ogni secondo
  function is_timeouted_upload(upload: Tupload; tempo: Cardinal): Boolean;
  function is_user_granted: Boolean; overload;
  function is_user_granted(ip: Cardinal;port: Word;ip_alt: Cardinal): Boolean; overload;

  procedure add_user_granted; //in synch da prendi bandwidth
  function drop_slower_transfer: Boolean;

  procedure check_hour;
  procedure check_second;
  procedure check_half_sec;
  procedure check_15_sec;
  procedure DHT_add_possible_bootstrap_client; //synch

   procedure flushSockets;
   function flushUpload(upload: TUpload; loops: Integer; amountPerCicle:integer): Boolean;

   procedure free_alternates;
   procedure init_alternates;
   function find_alternate_holder(const hash_sha1: string):precord_hash_holder_alternate;
   procedure add_alternate_source_holder(const hash_sha1: string; ip_user,ip_server: Cardinal; port_user,port_server:word);

    procedure accept_metti_ufrmmain_myport;
    procedure accept_listen;
    procedure accept_put_arrived_bittorrent;
    function accept_countfromip(const ip: string): Integer;
    procedure accept_put_arrived_push; // in synch


    procedure accept_accept; //
    procedure accept_receive_handshake;
    procedure expire_lista_accept_chat; //ogni minuto
    procedure Execute; override;
    procedure init_vars;
    procedure checkSha1inLibrary; //synch
    function CheckMaxULPerIp: Boolean;
    procedure ParseAltSources(strin: string);
    function numero_queued_da_ip: Integer;
    procedure xqueued_delete_queued_user(ip: Cardinal;port: Word; crc: Word; nomefile: string);
    function xqueued_trova_queued(ip: Cardinal;port: Word; crc: Word; nomefile: string):precord_queued;
    procedure ParseXStats;
    function xqueued_in_listview(listview: Tcomettree;queued:precord_queued):PCmtVNode;
    procedure handler_richiesta_encrypted(ForceGranted:boolean = false);
    procedure handler_push_arrived_encrypted(strin: string);
    procedure CheckPushedRequests;
    procedure CheckGetRequest(socket: TTCPBlockSocket; var shouldDisconnect: Boolean;
     var requestProcessed: Boolean; isIdleUpload:Boolean);
    procedure CheckIdleUploads;

    procedure free_upload_stuff(upload: Tupload; should_continue:boolean);
    procedure prendi_bandwidth;
    procedure xqueued_update_queue_log; // synchro
    function numero_up_da_ip(ip: Cardinal; port: Word; ip_alt: Cardinal): Integer;
    procedure XQueued_AssignPollTimeouts(queued:Precord_queued);
    procedure SendHTTPACK(has_range:boolean);
    procedure SendHTTPError(ErrorCode: string);
    procedure SendHTTPBusy;
    function trova_queued_per_questa_req:precord_queued;
    procedure check_minuto;
    procedure update_hint(treeview: Tcomettree; node:PCmtVNode);

     procedure FlushHeaders(tempo: Cardinal);

     procedure drop_upload_because_of_scanning; //2953+

     procedure FlushFiles; overload;
     procedure FlushFiles(tempo: Cardinal); overload;
     procedure FlushFiles(tempo: Cardinal; dummy:boolean); overload;
    procedure update_transfer_treeview;
    procedure update_listview_upload_eventuale;  // in synchronize
    procedure add_new_upload_visual; //synch
    procedure termina_upload_visual; //synch  upload_visual_per_synch
    function trova_stesso_file( upload: Tupload ):PCmtVNode;
    procedure metti_velocita_up; //synch  sempre per special caption
    procedure metti_nuova_velocita_up; //in synchronize
    procedure shutdown;
    procedure error_upload;
    procedure pushing_deal;
    procedure SendHTTPMetas;
    procedure pushing_sync;
    procedure xqueued_controlla_timeouts;
    procedure pushing_activate(push:Precord_push_to_go);
    procedure update_statusbar_1;
    function upload_count: Cardinal;
    function GetAltSources(evitaip: Cardinal): string;
    function GetBinAltSources(evitaip: Cardinal): string;
    function GetPartialSources(evitaip: Cardinal): string; //partial sono aggiunti solo quando almeno uno è stato completato! (buona affidabilità sorgente)
  end;

implementation

uses
  ufrmmain,helper_unicode,vars_localiz,helper_crypt,helper_strings,helper_base64_32,
  helper_diskio,helper_sockets,helper_ipfunc,helper_urls,helper_sorting,const_udpTransfer,
  helper_registry,vars_global,helper_datetime,mysupernodes,secureHash,
  const_timeouts,helper_http,helper_bighints,helper_ICH,helper_download_misc,bittorrentConst,
  ufrm_settings,helper_ares_nodes,helper_fakes;


procedure tthread_upload.CheckIdleUploads;
var
i,er: Integer;
ShouldDisconnect,requestProcessed: Boolean;
begin

i := 0;
while (i<IdleUploads.count) do begin
  socket := IdleUploads[i];

    if tempo-socket.tag>TIMEOUT_RECEIVE_HANDSHAKE then begin
      IdleUploads.delete(i);
      socket.Free;
      continue;
    end;

    if not TCPSocket_CanRead(socket.socket,0,er) then begin
      if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
       IdleUploads.delete(i);
       socket.Free;
      end else inc(i);
     continue;
   end;

   CheckGetRequest(socket,shouldDisconnect,requestProcessed,true);
   
 if shouldDisconnect then begin
  IdleUploads.delete(i);
  socket.Free;
 end else
  if requestProcessed then IdleUploads.delete(i)
   else inc(i);

end;

end;

procedure tthread_upload.CheckPushedRequests;
var
i,er: Integer;
ShouldDisconnect,requestProcessed: Boolean;
begin

try
i := 0;
while (i<pushedRequests.count) do begin

socket := pushedRequests[i]; // global

         if tempo-socket.tag>TIMEOUT_RECEIVE_HANDSHAKE then begin
            pushedRequests.delete(i);
            socket.Free;
            continue;
         end;

         if not TCPSocket_CanRead(socket.socket,0,er) then begin
           if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
             pushedRequests.delete(i);
             socket.Free;
           end else inc(i);
           continue;
         end;

 CheckGetRequest(socket,ShouldDisconnect,requestProcessed,false);

 if shouldDisconnect then begin
  pushedRequests.delete(i);
  socket.Free;
 end else
  if requestProcessed then pushedRequests.delete(i)
   else inc(i);

end;

except
end;
end;

procedure tthread_upload.CheckGetRequest(socket: TTCPBlockSocket; var shouldDisconnect: Boolean;
 var requestProcessed: Boolean; isIdleUpload:Boolean);
var
previous_len,er,len: Integer;
str: string;
len_want: Word;
commandID,bytes_skipped: Byte;
begin
shouldDisconnect := False;
requestProcessed := False;

         len := TCPSocket_RecvBuffer(socket.socket,
                                   @buffer_ricezione_handshake,
                                   sizeof(buffer_ricezione_handshake),
                                   er);

         if er=WSAEWOULDBLOCK then exit;
         if er<>0 then begin
          shouldDisconnect := True;
          exit;
         end;

         previous_len := length(socket.buffstr);
         SetLength(socket.buffstr,previous_len+len);
         move(buffer_ricezione_handshake,socket.buffstr[previous_len+1],len);

         socket.tag := tempo;


      if length(socket.buffstr)<6 then exit;

      str := d3a(socket.buffstr,23836);
      bytes_skipped := ord(str[3]);
       if bytes_skipped>=17 then begin
         shouldDisconnect := True;
         exit;
       end;

       if length(socket.buffstr)<bytes_skipped+5 then exit;

       len_want := chars_2_word(copy(str,4+bytes_skipped,2));
       if length(socket.buffstr)<bytes_skipped+5+len_want then exit;

        if len_want<5 then begin
         shouldDisconnect := True;
         exit;
       end;

       delete(str,1,bytes_skipped+5);
        str := d12(str,16298);
        commandID := ord(str[1]);
         delete(str,1,1);

        case commandID of
          0,1:begin  //GET
            socket.buffstr := str;
            socket.tag := gettickcount;
            requestProcessed := True;
            handler_richiesta_encrypted(isIdleUpload);
            sleep(2);
          end else shouldDisconnect := True;
        end;

end;


procedure tthread_upload.handler_push_arrived_encrypted(strin: string);
var
hash_sha1,randoms: string;
command: Byte;
len: Word;
cont: string;
begin
try

while (length(strin)>=3) do begin
  len := chars_2_word(copy(strin,1,2));
  command := ord(strin[3]);
   cont := copy(strin,4,len);
 delete(strin,1,3+len);

  if length(cont)<>len then continue;

   case command of
    1:begin
     randoms := cont;
    end;
    2:begin
     hash_sha1 := copy(cont,1,20);
     if length(hash_sha1)<>20 then break;
      socket_globale.buffstr := 'PUSH SHA1:'+bytestr_to_hexstr(hash_sha1)+randoms+chr(10)+chr(10);
      synchronize(accept_put_arrived_push);
      exit;
     end;

   end;
end;

socket_globale.Free;
except
end;
end;


procedure tthread_upload.DHT_add_possible_bootstrap_client; //synch
begin
if ip_user=0 then exit;
if port_user=0 then exit;

DHT_possibleBootstrapClientIP := ip_user;
DHT_possibleBootstrapClientPort := port_user;
end;

procedure tthread_upload.handler_richiesta_encrypted(ForceGranted:boolean = false);
var
len: Word;
command: Byte;
cont,str_temp,ext: string;
want_size_magnet,granted: Boolean;
alt_sources: string;
upload: Tupload;
begin
try
ip_user := inet_addr(PChar(socket.ip)); // per ban

if is_banned_ip(ip_user) then begin
 SendHTTPError(HTTPERROR403);
 exit;
end;

agent := '';
his_agent := '';
nickname := '';
partenza := -1;
fine := -1;
port_server := 0;
ip_server := 0;
port_user := 0;
xstats := '';
hash_sha1 := '';
is_encrypted := True;
encryption_key := 0;
encryption_branch := 0;
want_size_magnet := False;
wants_phash_indexs := False;
his_buildn := 0;

while (length(socket.buffstr)>3) do begin
  len := chars_2_word(copy(socket.buffstr,1,2));
  command := ord(socket.buffstr[3]);
   cont := copy(socket.buffstr,4,len);
  delete(socket.buffstr,1,3+len);
   if length(cont)<>len then continue; //wrong sized field??
   
     case command of

      TAG_ARESHEADER_CRYPTBRANCH:begin  //encryption method and key
         if len>=3 then begin
           encryption_branch := ord(cont[1]);
           if encryption_branch=1 then encryption_key := chars_2_word(copy(cont,2,2)) else begin //we can't handle
             SendHTTPError(HTTPERROR501);
             exit;
           end;
         end else begin  //we can't handle
            SendHTTPError(HTTPERROR501);
            exit;
         end;
      end;
      
      TAG_ARESHEADER_WANTEDHASH:begin //wanted sha1
        hash_sha1 := copy(cont,1,20);
        crcsha1 := crcstring(hash_sha1); //global
      end;

      TAG_ARESHEADER_NICKNAME:nickname := cont;

      TAG_ARESHEADER_HOSTINFO1:begin  //serverip  serverport  ip  port  ip_alt
         if ((ip_server=0) and (port_server=0) and (ip_user=0)) then begin  //old server host info may come later than lost info2 overwriting data to port_server=0 etc
          ip_server := chars_2_dword(copy(cont,1,4));
          port_server := chars_2_word(copy(cont,5,2));
          ip_user := chars_2_dword(copy(cont,7,4)); // per ban
          port_user := chars_2_word(copy(cont,11,2));
          ip_utente_interno := chars_2_dword(copy(cont,13,4));
          helper_ares_nodes.aresnodes_add_candidate(ip_server,port_server,ares_aval_nodes);
         end;
      end;

      TAG_ARESHEADER_XSIZE:want_size_magnet := True;
     // 6:begin  //stringa stats
     //   xstats := d2(cont,45876);
     // end;
      TAG_ARESHEADER_RANGE32:begin //range dword+dword
        partenza := chars_2_dword(copy(cont,1,4));
        fine := chars_2_dword(copy(cont,5,4));
      end;

      TAG_ARESHEADER_ALTSSRC:alt_sources := cont;

      TAG_ARESHEADER_AGENT:begin //agent
       his_agent := trim(cont);
       agent := get_first_word(trim(cont));
        str_temp := copy(cont,pos(' ',cont)+1,length(cont));    //2958+
        str_temp := trim(str_temp);
        delete(str_temp,1,pos('.',str_temp)); // 1.8.1.2957 -> 8.1.2957
        delete(str_temp,1,pos('.',str_temp)); // 8.1.2957 -> 1.2957
        delete(str_temp,1,pos('.',str_temp)); // 1.2957 -> 2957
        his_buildn := strtointdef(str_temp,0);
        if his_buildn>=DHT_SINCE_BUILD then synchronize(DHT_add_possible_bootstrap_client);
      end;

      TAG_ARESHEADER_XSTATS1:begin                //2948+
        cont := d67(d64(cont,24384),5593);
        delete(cont,1,1);  //  BYTE(random)    DWORD(random)    NULL    BYTE(random)    WH(DWORD(random)+21)    PAYLOAD
        if ((cont[5]=CHRNULL) and (chars_2_word(copy(cont,7,2))=word(wh(copy(cont,1,4))+21))) then begin
         delete(cont,1,8);
           if length(cont)>18 then begin
            //if cont[18]<>chr(17) then
            xstats := d2(cont,45876); // else xstats := cont;
           end;
        end;
      end;

      TAG_ARESHEADER_XSTATS2:xstats := cont; // 01/01/2006

      TAG_ARESHEADER_RANGE64:begin      //2951+
        partenza := chars_2_Qword(copy(cont,1,8));
        fine := chars_2_Qword(copy(cont,9,8));
      end;

      TAG_ARESHEADER_ICHREQ:begin //2956+
       if length(cont)>=1 then begin
        if cont[1]=chr(1) then wants_phash_indexs := True;  //send him phash
       end;
      end;

      TAG_ARESHEADER_HOSTINFO2:begin // new detail str 12/29/2005
        ip_user := chars_2_dword(copy(cont,1,4));
        port_user := chars_2_word(copy(cont,5,2));
        ip_utente_interno := chars_2_dword(copy(cont,7,4));
        if length(cont)>10 then begin
         ip_server := chars_2_dword(copy(cont,11,4));
         port_server := chars_2_word(copy(cont,15,2));

         // add potential supernodes
          delete(cont,1,10);
          helper_ares_nodes.aresnodes_add_candidates(copy(cont,1,length(cont)),ares_aval_nodes);
        end;
               // 0 to 4 other servers follow here
      end;

     end;

end;

nickname := strip_websites_str(nickname);
if nickname='' then nickname := ipdotstring_to_anonnick(socket.ip);
if agent='' then agent := STR_FOURQSTNMRK;

nickname := nickname+'@'+agent;

           ///////////////////////////c'è file in library?
          synchronize(checkSha1inLibrary);
          if isSha1inLibrary then begin
              ext := lowercase(extractfileext(nomefile));
              if ((ext='.mp3') or (ext='.avi')) and (helper_fakes.isFakeFile(nomefile)) then begin
                SendHTTPError(HTTPERROR404);
                exit;
              end;

              crcnomefile := stringcrc(nomefile,true);
              if want_size_magnet then begin //send size of file to this dude(magnet URI)
               SendHTTPMetas;
               exit;
              end;

              if wants_phash_indexs then
               if filesize_reale>ICH_MIN_FILESIZE then begin
                 upload := ICH_send_Phash(tempo,hash_sha1,socket,phash_insertion_point,encryption_key,filesize_reale);
                 if upload<>nil then lista_upload.add(upload)
                  else SendHTTPError(HTTPERROR500);
                exit;
               end;

            if length(alt_sources)>=12 then ParseAltSources(alt_sources); 

            ParseXStats;

            if forceGranted then granted := true
             else
              granted := is_user_granted;

                  if filesize_reale<MAX_SIZE_NO_QUEUE then begin
                   SendHTTPACK( ((partenza<>-1) or (fine<>-1)) );
                   exit;
                  end;

                  if not granted then
                   if upload_count+cardinal(IdleUploads.count)>=cardinal(m_limite_upload) then begin
                    SendHTTPBusy;
                    exit;
                   end;

                  if not CheckMaxULPerIp then begin
                   SendHTTPBusy;
                   exit;
                  end;

                  SendHTTPACK( ((partenza<>-1) or (fine<>-1)) );
                  exit;
           end;

           if is_rehashing then SendHTTPError(HTTPERROR510)
            else SendHTTPError(HTTPERROR404);

except
SendHTTPError(HTTPERROR500);
end;

end;

function tthread_upload.CheckMaxULPerIp: Boolean;
begin
result := True;
if loc_max_ul_per_ip=0 then exit;

if numero_up_da_ip(ip_user,port_user,ip_utente_interno)>=loc_max_ul_per_ip then Result := False;
end;

procedure tthread_upload.ParseAltSources(strin: string);
var
port_server_parse,port_user_parse: Word;
ip_user_parse,ip_server_parse: Cardinal;
ip_user_parses,ip_server_parses: string;
begin    //format ip_server port_server ip_user port_user
try

while (length(strin)>=12) do begin
   ip_server_parse := chars_2_dword(copy(strin,1,4));
   port_server_parse := chars_2_word(copy(strin,5,2));
   ip_user_parse := chars_2_dword(copy(strin,7,4));
   port_user_parse := chars_2_word(copy(strin,11,2));
    delete(strin,1,12);


   if isAntiP2PIP(ip_server_parse) then continue;
   if isAntiP2PIP(ip_user_parse) then continue;
   ip_user_parses := ipint_to_dotstring(ip_user_parse);
   if ip_user_parses=localip then continue;
   if ip_firewalled(ip_user_parses) then continue;
    ip_server_parses := ipint_to_dotstring(ip_server_parse);
    if ip_firewalled(ip_server_parses) then continue;

   if port_server_parse=0 then continue;
   if port_user_parse=0 then continue;

 add_alternate_source_holder(hash_sha1,
                             ip_user_parse,
                             ip_server_parse,
                             port_user_parse,
                             port_server_parse);
end;

except
end;
end;


procedure tthread_upload.checkSha1inLibrary; //synch
var hi: Integer;
pfile:precord_file_library;
begin
isSha1inLibrary := False;
is_rehashing := False;

try
if vars_global.share<>nil then begin
 is_rehashing := True;
 exit;
end;
except
end;

if vars_global.my_shared_count=0 then exit; //sta facendo scan 2953

try
         for hi := 0 to vars_global.lista_shared.count-1 do begin
           pfile := vars_global.lista_shared[hi];
           if not pfile^.shared then continue;
            if pfile^.crcsha1<>crcsha1 then continue;
             if pfile^.hash_sha1<>hash_sha1 then continue;


             isSha1inLibrary := True;  //vittorioso! globale

             nomefile := pfile^.path; //globale!
             filesize_reale := pfile^.fsize;
             phash_insertion_point := pfile^.phash_index; //2956+

             meta_title := pfile^.title;
             meta_artist := pfile^.artist;
             meta_album := pfile^.album;
             meta_category := pfile^.category;
             meta_language := pfile^.language;
             meta_date := pfile^.year;
             meta_comments := pfile^.comment;


             break;
         end;

except
end;
end;

function tthread_upload.is_user_granted(ip: Cardinal; port: Word; ip_alt: Cardinal): Boolean;
var
us_granted:precord_user_granted;
i: Integer;
begin

result := False;

if lista_user_granted=nil then exit;

if ip=0 then exit else
 if port=0 then exit;


for i := 0 to lista_user_granted.count-1 do begin
 us_granted := lista_user_granted[i];
  if us_granted^.port_user=port then
   if us_granted^.ip_user=ip then
    if us_granted^.ip_alt=ip_alt then begin
     Result := True;
     exit;
    end;
end;
end;

function tthread_upload.is_user_granted: Boolean;
var
us_granted:precord_user_granted;
i: Integer;
begin
 Result := False;

if lista_user_granted=nil then exit;

if ip_user=0 then exit else
 if port_user=0 then exit;


for i := 0 to lista_user_granted.count-1 do begin
 us_granted := lista_user_granted[i];
  if us_granted^.port_user=port_user then
   if us_granted^.ip_user=ip_user then
    if us_granted^.ip_alt=ip_utente_interno then begin
     Result := True;
     exit;
    end;
end;

end;

function tthread_upload.drop_slower_transfer: Boolean;
var
i,ind: Integer;
up,slower: Tupload;
min_speed: Integer;
tm: Cardinal;
begin
result := False;

min_speed := -1;
slower := nil;
tm := gettickcount;

for i := 0 to lista_upload.count-1 do begin
 up := lista_upload[i];

 if not up.should_display then continue;
 if tm-up.start_time<10000 then continue;
 if is_user_granted(up.ip_user,up.port_user,up.ip_alt) then continue;

   {
   if (up.his_buildn xor vars_global.buildno)>10 then begin
      slower := up;
      break;
   end;
   }
 if min_speed=-1 then begin
  min_speed := up.velocita;
  slower := up;
 end;

 if up.velocita<min_speed then begin
  min_speed := up.velocita;
  slower := up;
 end;


end;

if slower=nil then exit;


 ind := lista_upload.indexof(slower);
 if ind<>-1 then begin
   lista_upload.delete(ind);
   free_upload_stuff(slower,true);

             upload_visual_per_synch := slower;
             synchronize(termina_upload_visual); //synch  upload_visual_per_synch

           slower.Free;
  end else slower.socket.closesocket;

result := True;

end;



function tthread_upload.numero_up_da_ip(ip: Cardinal; port: Word; ip_alt: Cardinal): Integer;
var
i: Integer;
upload: Tupload;
begin
result := 0;
try

 for i := 0 to lista_upload.count-1 do begin
  upload := lista_upload[i];
  if not upload.should_display then continue;
  
   if upload.port_user=port then
    if upload.ip_user=ip then
     if upload.ip_alt=ip_alt then inc(result);

 end;
 except
 end;
end;

procedure tthread_upload.ParseXStats;
begin
his_progress := 0;
his_downcount := 40;
his_upcount := -1;
num_available := 1;
his_numero_condivisi := -1;
his_speed := 0;

if length(xstats)<18 then exit;

if xstats[18]<>chr(17) then exit;


try
num_available := ord(xstats[6]);
his_progress := ord(xstats[7]);


his_speed := chars_2_dword(copy(xstats,8,4));

if length(xstats)>20 then begin
 his_numero_condivisi := chars_2_word(copy(xstats,19,2)); //impostato da apri general library view
 his_upcount := ord(xstats[21]);
  if length(xstats)>21 then begin
   his_downcount := ord(xstats[22]);
    // if length(xstats)>22 then his_pl := ord(xstats[23]);
  end;

end else begin
 his_numero_condivisi := -1;
 his_upcount := -1;
end;

except
end;
end;



procedure tthread_upload.SendHTTPACK(has_range:boolean);
var
stringa,str: string;
i: Cardinal; //integer;
size: Int64;
upload: Tupload;
stream: Thandlestream;
skipped_len: Byte;
begin
try

size := filesize_reale;
if partenza<0 then partenza := 0;
if fine<0 then fine := size-1;     // not set

if ((partenza>=size) or (fine<partenza)) then begin //wrong request...stay away from me
 SendHTTPError(HTTPERROR416);
 exit;
end;

if fine+1>size then fine := size-1; //correzione per bug in 2956+

if (fine-partenza)+1>MAX_CHUNK_SIZE then fine := (partenza+MAX_CHUNK_SIZE)-1; //mai troppo grossi sti chunk!


  stream := MyFileOpen(utf8strtowidestr(nomefile),ARES_READONLY_ACCESS);
  if stream=nil then begin
   SendHTTPError(HTTPERROR500);
   exit;
  end;

 if has_range then stringa := HTTP206
             else stringa := HTTP200;


    stringa := STR_HTTP1+stringa+CRLF+
             STR_SERVER_ARES+vars_global.versioneares+CRLF+
             STR_MYNICK + CHRSPACE + vars_global.mynick+CRLF+
             STR_XB64MYDET + CHRSPACE + encodebase64(helper_ipfunc.serialize_myConDetails)+CRLF;


 stringa := stringa+GetAltSources(ip_user); //+
                 // GetPartialSources(ip_user);


 if has_range then begin
  stringa := stringa+STR_CONTENT_RANGE+inttostr(partenza)+'-'+inttostr(fine)+'/'+inttostr(size)+CRLF+
                   STR_CONTENT_LENGTH+inttostr((fine-partenza)+1)+CRLF+
                   CRLF;
end else begin   
 stringa := stringa+STR_CONTENT_LENGTH+inttostr((fine-partenza)+1)+CRLF+
                  CRLF;
 partenza := 0;
end;


 upload := tupload.create(tempo);

if is_encrypted then begin
     skipped_len := random(16)+1;
     str := chr(random($ff))+chr(random($ff))+chr(skipped_len);
      for i := 1 to skipped_len do str := Str+chr(random($ff));
     stringa := str+stringa;

    upload.is_encrypted := True;
    upload.encryption_key := encryption_key;
    for I := 1 to Length(Stringa) do begin
        stringa[I] := char(byte(Stringa[I]) xor (upload.encryption_key shr 8));
        upload.encryption_key := (byte(stringa[I]) + upload.encryption_key) * 52079 + 16826;
    end;
end;


  upload.stream := stream;
  upload.his_progress := his_progress;
  upload.his_agent := his_agent;
  upload.his_upcount := his_upcount;                 
   if his_downcount=0 then upload.his_downcount := 1
    else upload.his_downcount := his_downcount;
  upload.his_shared := his_numero_condivisi;
  upload.his_speedDL := his_speed;
  upload.num_available := num_available;
  upload.port_server := port_server;
  upload.ip_server := ip_server;
  upload.port_user := port_user;
  upload.ip_user := ip_user;
  upload.ip_alt := ip_utente_interno;
  upload.nickname := nickname;
  upload.crcnick := stringcrc(nickname,true);
  upload.socket := socket;
   socket.tag := upload.start_time;
  upload.filename := nomefile;
  upload.crcfilename := crcnomefile;
  upload.out_reply_header := stringa;
  upload.actual := partenza;
  upload.startpoint := partenza;
  upload.endpoint := fine;
  upload.size := (fine-partenza)+1;
  upload.filesize_reale := filesize_reale;
  upload.bytesprima := partenza;
  upload.velocita := 0;
   upload.should_display := True;

  if upload.actual>0 then begin
    helper_diskio.MyFileSeek(upload.stream,upload.actual,ord(soFromBeginning));

     if helper_diskio.MyFileSeek(upload.stream,0,ord(soCurrent))<>upload.actual then begin
      sleep(10);
      helper_diskio.MyFileSeek(upload.stream,upload.actual,ord(soFromBeginning));
     end;
     
  end;
  

 lista_upload.add(upload);
 synchronize(add_new_upload_visual);

except
socket.Free;
end;
end;


procedure tthread_upload.SendHTTPError(ErrorCode: string);
var
stringa,str: string;
skipped_len: Byte;
i: Integer;
begin

try
    stringa := STR_HTTP1+ErrorCode+CRLF+
             STR_SERVER_ARES+vars_global.versioneares+CRLF+CRLF;


    if is_encrypted then begin
     skipped_len := random(16)+1;
     str := chr(random($ff))+chr(random($ff))+chr(skipped_len);
      for i := 1 to skipped_len do str := Str+chr(random($ff));
      stringa := str+stringa;
      stringa := e54(stringa,encryption_key);
    end;

     socket.buffstr := stringa;
     socket.tag := tempo;
     socketstoFlush.add(socket);
except
end;
end;

procedure tthread_upload.SendHTTPMetas;
var
stringa: string;
begin

try

             stringa := STR_HTTP1+HTTP200+CRLF+
                      STR_SERVER_ARES+vars_global.versioneares+CRLF+
                      STR_MYNICK+chr(32)+vars_global.mynick+CRLF+
                      STR_XB64MYDET+chr(32)+encodebase64(helper_ipfunc.serialize_myConDetails)+CRLF+
                      'X-Title: '+urlencode(meta_title)+CRLF+
                      'X-Artist: '+urlencode(meta_artist)+CRLF+
                      'X-Album: '+urlencode(meta_album)+CRLF+
                      'X-Type: '+urlencode(meta_category)+CRLF+
                      'X-Language: '+urlencode(meta_language)+CRLF+
                      'X-Date: '+urlencode(meta_date)+CRLF+
                      'X-Comments: '+urlencode(meta_comments)+CRLF+
                      'X-Size: '+inttostr(filesize_reale)+CRLF+
                      CRLF;

    socket.buffstr := stringa;
    socket.tag := tempo;
     socketstoFlush.add(socket);

except
end;
end;

function tthread_upload.upload_count: Cardinal;
var
i: Integer;
upload: Tupload;
begin
result := 0;
try

for i := 0 to lista_upload.count-1 do begin
 upload := lista_upload[i];
 if upload.should_display then inc(result);
end;

except
end;
end;

procedure tthread_upload.update_statusbar_1;  // in synchronize
begin
try

vars_global.numero_upload := upload_count;
vars_global.numero_queued := lista_queued.count;

ares_FrmMain.update_status_transfer;
except
end;
end;

function tthread_upload.numero_queued_da_ip: Integer;
var
i: Integer;
queued:precord_queued;
begin
result := 0;
 for i := 0 to lista_queued.count-1 do begin
  queued := lista_queued[i];
  if queued^.port=port_user then
   if queued^.ip=ip_user then
    if queued^.ip_alt=ip_utente_interno then inc(result);
 end;
end;

function tthread_upload.trova_queued_per_questa_req:precord_queued;
var
hiq: Integer;
queued:precord_queued;
pollmin_prec: Cardinal;
begin
result := nil;
try

      // for hiq := 0 to lista_queued.count-1 do begin
      //    queued := lista_queued[hiq];
      //      if queued^.ip<>ip_user then continue else
      //          if queued^.port<>port_user then continue else
      //           if queued^.crcnomefile<>crcnomefile then continue else
      //           if queued^.nomefile<>nomefile then continue;

     //                queued^.his_upcount := his_upcount; //ora mettiamo in riga secondo il numero degli up, chi ha più up passa prima
     //                break;
     //  end;


        // if lista_queued.count>1 then begin       2967 monday 27-6-2005
        //             lista_queued.sort(ordina_queued_per_num_uploads);
         //            for i := 0 to lista_queued.count-1 do begin //riassegniamo posizioni
        //              queued2 := lista_queued[i];
        //              queued2^.posizione := i+1;
        //             end;
        // end;

        for hiq := 0 to lista_queued.count-1 do begin
          queued := lista_queued[hiq];
            if queued^.ip<>ip_user then continue else
                if queued^.port<>port_user then continue else
                 if queued^.crcnomefile<>crcnomefile then continue else
                  if queued^.nomefile<>nomefile then continue;

                                queued^.posizione := hiq+1;
                                queued^.user := nickname;
                                queued^.server_ip := ip_server;
                                queued^.server_port := port_server;
                                queued^.ip_alt := ip_utente_interno;
                               pollmin_prec := queued^.polltime;
                                inc(queued^.total_tries);
                                queued^.retry_interval := ((gettickcount-pollmin_prec) div 1000);
                                queued^.polltime := gettickcount;
                                queued^.size := filesize_reale;

                                queued^.his_progress := his_progress;
                                queued^.num_available := num_available;
                                queued^.his_shared := his_numero_condivisi;
                                queued^.his_downcount := his_downcount;
                                queued^.his_speedDL := his_speed;
                                queued^.his_agent := his_agent;
                                
                               if queue_firstinfirstout then begin
                                  if queued^.posizione<3 then begin
                                   queued^.pollmin := 30;
                                   queued^.pollmax := 90;
                                  end else
                                  if queued^.posizione<10 then begin
                                   queued^.pollmin := 60;
                                   queued^.pollmax := 120;
                                  end else
                                  if queued^.posizione<20 then begin
                                   queued^.pollmin := 120;
                                   queued^.pollmax := 180;
                                  end else begin
                                   queued^.pollmin := 240;
                                   queued^.pollmax := 300;
                                  end;
                              end else begin
                               queued^.pollmin := 60;
                               queued^.pollmax := 120;
                             end;
             Result := queued;
          break;
       end;      //fine for?

except
end;
end;

procedure tthread_upload.SendHTTPBusy;
var
stringa,str: string;
queued:precord_queued;
num,i: Integer;
canAdd: Boolean;
skipped_len: Byte;
begin

try

 stringa := STR_HTTP1+HTTPERROR503+CRLF+
          STR_SERVER_ARES+vars_global.versioneares+CRLF+
          STR_MYNICK + CHRSPACE + vars_global.mynick+CRLF+
          STR_XB64MYDET + CHRSPACE + encodebase64(helper_ipfunc.serialize_myConDetails)+CRLF;


 queued := trova_queued_per_questa_req;
 if queued<>nil then stringa := stringa+STR_XQUEUED_HEADER+inttostr(queued^.posizione)+','+
                                        STR_LENGTH_HEADER+inttostr(lista_queued.count)+','+
                                        STR_LIMIT+inttostr(m_limite_upload)+','+
                                        STR_POLLMIN+inttostr(queued.pollmin)+','+
                                        STR_POLLMAX+inttostr(queued.pollmax)+CRLF
    else
     if lista_queued.count>=NUM_MAX_QUEUED then  //not found and list full
                            stringa := stringa+STR_XQUEUED_HEADER+'102,'+
                                             STR_LENGTH_HEADER+inttostr(lista_queued.count)+','+
                                             STR_LIMIT+inttostr(m_limite_upload)+','+
                                             STR_POLLMIN+'240,'+
                                             STR_POLLMAX+'360'+CRLF
         else begin // not found, and place in line available

              if loc_max_ul_per_ip<>0 then begin
                num := numero_up_da_ip(ip_user,port_user,ip_utente_interno)+numero_queued_da_ip;
                CanAdd := (num<loc_max_ul_per_ip);  // is he within our max UL per IP settings?
                if not CanAdd then stringa := stringa+STR_XQUEUED_HEADER+'103,'+
                                                    STR_LENGTH_HEADER+inttostr(lista_queued.count)+','+
                                                    STR_LIMIT+inttostr(m_limite_upload)+','+
                                                    STR_POLLMIN+'125,'+
                                                    STR_POLLMAX+'245'+CRLF;
              end else CanAdd := True;


              if canAdd then begin
                queued := AllocMem(sizeof(record_queued));
                 XQueued_AssignUserValues(queued);
                 XQueued_AssignPollTimeouts(queued);
                lista_queued.add(queued);

                  stringa := stringa+STR_XQUEUED_HEADER+inttostr(queued^.posizione)+','+
                                   STR_LENGTH_HEADER+inttostr(lista_queued.count)+','+
                                   STR_LIMIT+inttostr(m_limite_upload)+','+
                                   STR_POLLMIN+inttostr(queued.pollmin)+','+
                                   STR_POLLMAX+inttostr(queued.pollmax)+CRLF;
                  synchronize(update_statusbar_1);
               end;

        end;

 stringa := stringa+GetAltSources(ip_user)+
                 // GetPartialSources(ip_user)+
                  CRLF;



   if is_encrypted then begin
     skipped_len := random(16)+1;
     str := chr(random($ff))+chr(random($ff))+chr(skipped_len);
      for i := 1 to skipped_len do str := Str+chr(random($ff));
      stringa := str+stringa;
      stringa := e54(stringa,encryption_key);
    end;


    socket.buffstr := stringa;
    socket.tag := tempo;
     socketstoFlush.add(socket);

except
end;
end;

procedure tthread_upload.XQueued_AssignUserValues(queued:precord_queued);
begin
with queued^ do begin
 banned := False;
 disconnect := False;
 ip := ip_user;
 ip_alt := ip_utente_interno;
 port := port_user;
 server_ip := ip_server;
 server_port := port_server;
 total_tries := 1;
 user := nickname;
 queue_start := gettickcount;
 polltime := queue_start;
 posizione := lista_queued.count+1;
 retry_interval := 60;
 size := filesize_reale;
 his_speedDL := his_speed;
 his_shared := his_numero_condivisi;
end;
 queued^.nomefile := nomefile;
 queued^.crcnomefile := crcnomefile;
 queued^.his_progress := his_progress;
 queued^.num_available := num_available;
 queued^.his_upcount := his_upcount;
 queued^.his_downcount := his_downcount;
 queued^.his_agent := his_agent;
 queued^.his_upcount := his_upcount;
end;

procedure tthread_upload.XQueued_AssignPollTimeouts(queued:Precord_queued);
begin
if queue_firstinfirstout then begin
  if queued^.posizione<3 then begin //i primi due viaggiano!
   queued^.pollmin := 25;
   queued^.pollmax := 90;
  end else
   if queued^.posizione<10 then begin
    queued^.pollmin := 45;
    queued^.pollmax := 120;
   end else
    if queued^.posizione<20 then begin
     queued^.pollmin := 90;
     queued^.pollmax := 180;
    end else begin
     queued^.pollmin := 180;
     queued^.pollmax := 300;
    end;
 end else begin
  queued^.pollmin := 60;
  queued^.pollmax := 120;
 end;
end;

procedure tthread_upload.prendi_bandwidth; //synch

begin
upload_bandwidth := vars_global.up_band_allow;

vars_global.queue_length := lista_queued.count;
localip := vars_global.localip;
m_limite_upload := vars_global.limite_upload;
vars_global.block_pvt_chat := vars_global.Check_opt_chat_nopm_checked;
loc_block_pvt_chat := vars_global.Check_opt_chat_nopm_checked;
vars_global.block_pm := vars_global.Check_opt_chatroom_nopm_checked;

loc_max_ul_per_ip := vars_global.max_ul_per_ip;
MAX_SIZE_NO_QUEUE := vars_global.max_size_no_queue;
velocita_max_ufrmmain := vars_global.velocita_up; //velocità max calcolata e paragonata in gestisci stats
queue_firstinfirstout := vars_global.queue_firstinfirstout;

  pushing_sync;



if ((vars_global.check_opt_tran_inconidle_checked) and
    (utility_ares.is_idle_cursor(false))) then begin
    upload_bandwidth := 0; //azzeriamo se in idle
    inc(m_limite_upload,4);
end;


if vars_global.port_user_granted<>0 then begin
  add_user_granted;
   vars_global.ip_user_granted := 0;
   vars_global.port_user_granted := 0;
   vars_global.ip_alt_granted := 0;
end;

if vars_global.my_shared_count=0 then begin
 drop_upload_because_of_scanning;
 exit; //sta facendo scan
end;

GraphCheckSync;

end;




procedure tthread_upload.add_user_granted;   //in synch da prendi bandwidth
var
us_granted:precord_user_granted;
i: Integer;
begin

 if lista_user_granted<>nil then begin   
  for i := 0 to lista_user_granted.count-1 do begin
   us_granted := lista_user_granted[i];
    if us_granted^.port_user=vars_global.port_user_granted then
     if us_granted^.ip_user=vars_global.ip_user_granted then
      if us_granted^.ip_alt=vars_global.ip_alt_granted then exit;
   end;
 end;

  us_granted := AllocMem(sizeof(record_user_granted));
   us_granted^.ip_user := vars_global.ip_user_granted;
   us_granted^.port_user := vars_global.port_user_granted;
   us_granted^.ip_alt := vars_global.ip_alt_granted;

   if lista_user_granted=nil then lista_user_granted := tmylist.create;
    lista_user_granted.add(us_granted);
end;


procedure tthread_upload.xqueued_update_queue_log; // synchro
var
i: Integer;
node:pCmtVnode;
queued,data:precord_queued;
begin
if ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER then exit;
if not ares_FrmMain.treeview_queue.visible then exit; //queue invisibile

try
  node := nil;
 i := 0;
 repeat
 if i=0 then node := ares_FrmMain.treeview_queue.getfirst
  else node := ares_FrmMain.treeview_queue.GetNext(node);
  if node=nil then break;
  inc(i);
  
  data := ares_FrmMain.treeview_queue.getdata(node);

 if data^.disconnect then begin  //perform ban
   xqueued_delete_queued_user(data^.ip,data^.port,data^.crcnomefile,data^.nomefile);
   ares_FrmMain.treeview_queue.deletenode(node);
   i := 0;
   continue;
 end else
 if data^.banned then begin
    add_ban(data^.ip);
    xqueued_delete_queued_user(data^.ip,data^.port,data^.crcnomefile,data^.nomefile);
   ares_FrmMain.treeview_queue.deletenode(node);
   i := 0;
   continue;
 end;

                    //posiziona in lista e assegna posizione
 queued := xqueued_trova_queued(data^.ip,data^.port,data^.crcnomefile,data^.nomefile);
  if queued=nil then begin
   ares_FrmMain.treeview_queue.deletenode(node);
   i := 0;
   continue;
  end;

until (not true);


 if lista_queued.count>1 then lista_queued.sort(ordina_xqueued);  // ordina secondo ordine che gli diamo noi

 if lista_queued.count=0 then ares_FrmMain.panel_tran_upqu.capt := ' '+GetLangStringW(STR_SERVER_QUEUE)+': 0 '+GetLangStringW(STR_IN_QUEUE) else
 ares_FrmMain.panel_tran_upqu.capt := ' '+GetLangStringW(STR_SERVER_QUEUE)+': '+inttostr(lista_queued.count)+' '+GetLangStringW(STR_IN_QUEUE);
 // ora scriviamo

 for i := 0 to lista_queued.count-1 do begin
  queued := lista_queued[i];

  node := xqueued_in_listview(ares_FrmMain.treeview_queue,queued);
     if node=nil then begin
       node := ares_FrmMain.treeview_queue.addchild(nil);
        data := ares_FrmMain.treeview_queue.getdata(node);
        with data^ do begin
         disconnect := False;
         banned := False;
         user := queued^.user;
         nomefile := queued^.nomefile;
         crcnomefile := queued^.crcnomefile;
         size := queued^.size;
         ip := queued^.ip;
         ip_alt := queued^.ip_alt;
         port := queued^.port;
         server_ip := queued^.server_ip;
         server_port := queued^.server_port;
         importance := queued^.importance;
         his_progress := queued^.his_progress;
         num_available := queued^.num_available;
         his_shared := queued^.his_shared;
         his_speedDL := queued^.his_speedDL;
         his_upcount := queued^.his_upcount;
         his_downcount := queued^.his_downcount;
         his_agent := queued^.his_agent;
         polltime := queued^.polltime;
         retry_interval := queued^.retry_interval;
         total_tries := queued^.total_tries;
         queue_start := queued^.queue_start;
         pollmax := queued^.pollmax;
         posizione := queued^.posizione;
        end;
           update_hint(ares_FrmMain.treeview_queue,node);
      end else begin
        data := ares_FrmMain.treeview_queue.getdata(node);
         with data^ do begin
          importance := queued^.importance;
          his_progress := queued^.his_progress;
          num_available := queued^.num_available;
          his_shared := queued^.his_shared;
          his_upcount := queued^.his_upcount;
          his_downcount := queued^.his_downcount;
          his_speedDL := queued^.his_speedDL;
          polltime := queued^.polltime;
          server_ip := queued^.server_ip;
          server_port := queued^.server_port;
          pollmax := queued^.pollmax;
          retry_interval := queued^.retry_interval;
          total_tries := queued^.total_tries;
          posizione := queued^.posizione;
         end;
         ares_FrmMain.treeview_queue.invalidatenode(node);
         update_hint(ares_FrmMain.treeview_queue,node);
      end;
 end;

except
end;
end;

function tthread_upload.xqueued_in_listview(listview: Tcomettree; queued:precord_queued):pCmtVnode;
var
node:pCmtVnode;
i: Integer;
data:precord_queued;
begin
result := nil;
try
 nodE := nil;
 i := 0;
 repeat
 if i=0 then node := listview.getfirst
  else node := listview.getnext(node);
  if node=nil then break;
  inc(i);

  data := listview.getdata(node);

  if data^.ip=queued^.ip then
   if data^.port=queued^.port then
    if data^.crcnomefile=queued^.crcnomefile then
     if data^.nomefile=queued^.nomefile then begin
      Result := node;
      exit;
     end;

  until (not true);

except
end;
end;


function tthread_upload.xqueued_trova_queued(ip: Cardinal;port: Word;crc: Word;nomefile: string):precord_queued;
var
i: Integer;
queued:precord_queued;
begin
result := nil;
try

for i := 0 to lista_queued.count-1 do begin
 queued := lista_queued[i];

  if queued^.ip=ip then
   if queued^.port=port then
    if queued^.crcnomefile=crc then
    if queued^.nomefile=nomefile then begin
     Result := queued;
     exit;
    end;
  
end;

except
end;
end;

procedure tthread_upload.xqueued_delete_queued_user(ip: Cardinal;port: Word;crc: Word;nomefile: string);
var
i: Integer;
queued:precord_queued;
cancel: Boolean;
begin
 cancel := False;
try
   
 for i := 0 to lista_queued.count-1 do begin
 queued := lista_queued[i];

  if queued^.ip=ip then
   if queued^.port=port then
    if queued^.crcnomefile=crc then
     if queued^.nomefile=nomefile then begin
       queued^.nomefile := '';
       queued^.user := '';
       queued^.his_agent := '';
      lista_queued.delete(i);
       FreeMem(queued,sizeof(record_queued));

      cancel := True;
      break;
  end;
 end;

 except
 end;
 
 if cancel then synchronize(update_statusbar_1);
end;

function tthread_upload.accept_countfromip(const ip: string): Integer;
var
i: Integer;
sock: Ttcpblocksocket;
begin
result := 0;
 for i := 0 to lista_sockets_accepted.count-1 do begin
  sock := lista_sockets_accepted[i];
   if sock.ip=ip then inc(result);
 end;
end;

procedure tthread_upload.BindUdpSocket;
var
sin: TVarSin;
begin
if UDP_Socket<>INVALID_SOCKET then exit;

 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(vars_global.myport+1); // myport already used by threadDHT
 Sin.sin_addr.s_addr := 0;
  UDP_socket := synsock.socket(PF_INET,integer(SOCK_DGRAM),IPPROTO_UDP);
 synsock.Bind(UDP_socket,@Sin,SizeOfVarSin(Sin));

end;

procedure tthread_upload.accept_listen;
var
valore_porta,
er: Integer;
begin

valore_porta := vars_global.myport;

        repeat
          with accept_server do begin
           ip := cAnyHost;
           port := valore_porta;
           createsocket;
           bind(ip,inttostr(port));
           listen(16);
           er := lasterror;
             if er<>0 then begin
              closesocket;
              inc(valore_porta);
              if valore_porta>65535 then valore_porta := 80;
              sleep(50);
              if terminated then exit;
            end;
          end;
        until (er=0);

 if not terminated then synchronize(accept_metti_ufrmmain_myport);
end;



procedure tthread_upload.accept_metti_ufrmmain_myport;
begin
vars_global.myport := accept_server.port;

 if frm_settings<>nil then begin
  frm_settings.edit_opt_tran_port.text := inttostr(vars_global.myport);
 end;

end;

procedure tthread_upload.accept_put_arrived_push; // in synch
begin
vars_global.lista_socket_accept_down.add(socket_globale);  //globale
end;

procedure tthread_upload.accept_put_arrived_bittorrent; //sync
begin
try

if vars_global.thread_bittorrent=nil then begin
 socket_globale.Free;
 exit;
end;
vars_global.bittorrent_Accepted_sockets.add(socket_globale);

except
end;
end;


procedure tthread_upload.expire_lista_accept_chat; //ogni minuto
var
i: Integer;
tempo: Cardinal;
ip_accepted_chat:precord_ip_accepted_chat;
begin
try

tempo := gettickcount;
i := 0;
while (i<lista_accepted_chat.count) do begin
    ip_accepted_chat := lista_accepted_chat[i];

    if tempo-ip_accepted_chat.last>10*MINUTE then begin
      dec(ip_accepted_chat.volte);
      ip_accepted_chat^.last := tempo;

       if ip_accepted_chat^.volte=0 then begin  //ok è bravo, togliamolo
         lista_accepted_chat.delete(i);
         FreeMem(ip_accepted_chat,sizeof(record_ip_accepted_chat));
        continue;
       end;

    end;

 inc(i);
end;

 except
 end;
end;


procedure tthread_upload.GraphAddSample(Value:integer);
begin
if FirstGraphSample=nil then exit;
FirstGraphSample^.sample := FirstGraphSample^.sample+cardinal(Value);
end;

procedure tthread_upload.GraphIncrement(Elapsed:integer);
begin
 helper_graphs.GraphIncrement(FirstGraphSample,LastGraphSample,NumGraphStats,m_graphWidth,Elapsed);
end;

procedure tthread_upload.GraphCreateFirstSamples;
begin
helper_graphs.GraphCreateFirstSamples(FirstGraphSample,LastGraphSample,NumGraphStats);
end;

procedure tthread_upload.GraphUpdate;  //synchronize
begin
helper_graphs.GraphUpdate(FirstGraphSample^.next);
end;

procedure tthread_upload.GraphCheckSync;
begin
if ((vars_global.handle_obj_GraphHint=INVALID_HANDLE_VALUE) or
   (vars_global.formhint.posYgraph=-1)) then begin
    GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats);
    m_graphObject := INVALID_HANDLE_VALUE;
    exit;
end;

if ((ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER) or
    (vars_global.formhint.top=10000) or
    (not vars_global.graphIsUpload)) then begin
    GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats);
    m_graphObject := INVALID_HANDLE_VALUE;
    exit;
end;

if not vars_global.graphIsUpload then exit;

if ((vars_global.handle_obj_GraphHint<>INVALID_HANDLE_VALUE) and
    (vars_global.formhint.posygraph<>-1)) then begin

  if m_graphObject<>vars_global.handle_obj_GraphHint then
   if m_graphObject<>INVALID_HANDLE_VALUE then GraphClearRecords(FirstGraphSample,LastGraphSample,NumGraphStats); // new graph needed clear previous data
end;

if m_graphObject<>vars_global.handle_obj_GraphHint then GraphCreateFirstSamples;

m_graphObject := vars_global.handle_obj_GraphHint;  //sync to our local target object
m_graphWidth := vars_global.formhint.GraphWidth;
end;

procedure tthread_upload.GraphDeal(callsynch:boolean);
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


procedure tthread_upload.accept_accept; //
var
h: TSocket;
sin:synsock.TSockAddrIn;
ips: string;
socket: Ttcpblocksocket;
begin
try

 while (accept_server.CanRead(0)) do begin;

      h := accept_server.Accept;
      if h=SOCKET_ERROR then exit;
      if h=INVALID_SOCKET then exit;

      sin := TCPSocket_GetRemoteSin(h);

      TCPSocket_Block(h,false);

      try
      if lista_sockets_accepted.count>=10 then
       if hash_server<>nil then begin
        TCPSocket_Free(h);
        continue;
       end;
      except
      end;

      if isAntiP2PIP(Sin.sin_addr.S_addr) then begin
       TCPSocket_Free(h);
       continue;
      end;

      ips := ipint_to_dotstring(Sin.sin_addr.S_addr);

      if accept_countfromip(ips)>MAX_ACCEPT_SOCKETS_FROM_IP_NO_OR_FLOOD then begin
       TCPSocket_Free(h);
       continue;
      end;

        socket := TTCPBlocksocket.create(false);
         with socket do begin
          socket := h;
          ip := ips;
          port := 0;
          buffstr := '';
          tag := tempo;
         end;

         
        lista_sockets_accepted.add(socket);
 end;

except
end;
end;


procedure tthread_upload.accept_receive_handshake;
var
i,er,len: Integer;
socke: TTCPBlockSocket;
previous_len,bytes_skipped,len_want,lensoFar: Integer;
str: string;
comando: Byte;
begin
try


    i := 0;
    while (i<lista_sockets_accepted.count) do begin
     socke := lista_sockets_accepted[i];


       if tempo-socke.tag>TIMEOUT_RECEIVE_HANDSHAKE then begin  // se ha timer connessione 10 sec
            lista_sockets_accepted.delete(i);

            socke.Free;
            continue;
       end;

      if not TCPSocket_CanRead(socke.socket,0,er) then begin
         if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
            lista_sockets_accepted.delete(i);

            socke.Free;
         end else inc(i);
       continue;
      end;



      len := TCPSocket_RecvBuffer(socke.socket,@buffer_ricezione_handshake,sizeof(buffer_ricezione_handshake),er);

       if er=WSAEWOULDBLOCK then begin
        inc(i);
        continue;
       end;

        if er<>0 then begin
          lista_sockets_accepted.delete(i);

          socke.Free;
          continue;
        end;

        previous_len := length(socke.buffstr);
        if previous_len+len>4096 then begin   //overflow?
         lista_sockets_accepted.delete(i);

         socke.Free;
         continue;
        end;
        socke.tag := tempo;

        
        SetLength(socke.buffstr,previous_len+len);
        move(buffer_ricezione_handshake[0],socke.buffstr[previous_len+1],len);




        lensoFar := length(socke.buffstr);
        if ((lensoFar=68) or
            (pos(STR_BITTORRENT_PROTOCOL_HANDSHAKE,socke.buffstr)=1)) then begin //20handshake+ 8zero +20hash +20clientid
             if pos(STR_BITTORRENT_PROTOCOL_HANDSHAKE,socke.buffstr)=1 then begin
               lista_sockets_accepted.delete(i);
                if socke.ip=localip then begin

                 socke.Free;
                 continue;
                end;
                if lensoFar<>68 then begin //malformed bittorrent handshake

                 socke.Free;
                 continue;
                end;

                  socket_globale := ttcpblocksocket.create(false);
                   socket_globale.socket := socke.socket;
                   socket_globale.ip := socke.ip;
                   socket_globale.port := socke.port;
                   socket_globale.tag := socke.tag;
                   socket_globale.buffstr := socke.buffstr;
                  socke.socket := INVALID_SOCKET;

                  socke.Free;

                  try
                   synchronize(accept_put_arrived_bittorrent);
                  except
                  end;
                  continue;
             end else begin
              // received 68 bytes but it's not a bittorrent request?

             end;
        end else
        if lensoFar=7 then begin
            if pos(STR_FIREWALLED_TEXT{FIRETST},socke.buffstr)=1 then begin   //2962+ DHT supernode may use this, hangup first to save his socket memory
              lista_sockets_accepted.delete(i);

              socke.Free;
              continue;
            end;
            if pos(STR_ARES_PGT{'ARESPGT'},socke.buffstr)=1 then begin //encapsulated GET for downloads
              lista_sockets_accepted.delete(i);

              socke.Free;
              continue;
            end;
        end else
        if lensoFar<10 then begin   //check encryption?
         inc(i);
         continue;
        end;

        

            str := copy(socke.buffstr,1,4);

            // is it a plaintext request?
            if ((str='GET ') or
                (str='CHAT') or
                (str='PUSH')) then begin
                if pos(CRLF+CRLF,socke.buffstr)=0 then
                 if pos(chr(10)+chr(10),socke.buffstr)=0 then begin  // need more?
                  inc(i);
                  continue;
                 end;
                 lista_sockets_accepted.delete(i);
                 Handle_PlainTextRequests(socke);
                 continue;
             end;

             //it's encrypted
                  str := d3a(socke.buffstr,23836);
                  bytes_skipped := ord(str[3]);
                  if bytes_skipped>16 then begin //within limits?
                    lista_sockets_accepted.delete(i);

                    socke.Free;
                    continue;
                  end;

                  if length(socke.buffstr)<bytes_skipped+5 then begin // have enough?
                    inc(i);
                    continue;
                  end;

                  len_want := chars_2_word(copy(str,4+bytes_skipped,2));
                  if len_want<5 then begin              // empty request?
                   lista_sockets_accepted.delete(i);

                   socke.Free;
                   continue;
                  end;
                  if length(socke.buffstr)<bytes_skipped+5+len_want then begin // have full payload?
                   inc(i);
                   continue;
                  end;


                 delete(str,1,bytes_skipped+5); // remove header

                  str := d12(str,16298);  // decrypt payload

                  comando := ord(str[1]);
                  delete(str,1,1);

               case comando of
                   0,1:begin  //GET
                     lista_sockets_accepted.delete(i);

                     socket := ttcpblocksocket.create(false); //CREAZIONE GLOBALE
                     with socket do begin
                      socket := socke.socket;
                      ip := socke.ip;
                      port := socke.port;
                      buffstr := str;
                      tag := socke.tag;
                     end;
                       handler_richiesta_encrypted;
                       sleep(2);
                      socke.socket := INVALID_SOCKET;

                      socke.Free;
                     continue;
                   end;
                   
                   2:begin //push
                       lista_sockets_accepted.delete(i);

                       socket_globale := ttcpblocksocket.create(false); //ASSEGNIAZIONE SOCKET GLOBALE
                       with socket_globale do begin
                        socket := socke.socket;
                        ip := socke.ip;
                        port := socke.port;
                        tag := socke.tag;
                       end;

                           handler_push_arrived_encrypted(str);
                           sleep(2);

                      socke.socket := INVALID_SOCKET;

                      socke.Free;
                      continue;
                   end;

                   3:begin  //chat connect
                      lista_sockets_accepted.delete(i);


                      socke.Free;
                      continue;
                   end;

                   4:begin  //chat push request
                      lista_sockets_accepted.delete(i);
                      socket_globale := ttcpblocksocket.create(false); //ASSEGNIAZIONE SOCKET GLOBALE
                      if length(str)<19 then begin     // header+16

                       socke.Free;
                       continue;
                      end;
                      if chars_2_word(copy(str,1,2))<>16 then begin //randoms è di 16 bytes

                       socke.Free;
                       continue;
                      end;
                      if ord(str[3])<>1 then begin  //cmd id solo 1 ovvero randoms

                       socke.Free;
                       continue;
                      end;

                       socke.Free;
                      continue;
                   end else begin  //unknown command
                    lista_sockets_accepted.delete(i);
                    
                    socke.Free;
                    continue;
                   end;
               end; //endof case

  inc(i);
end;

  except
  end;
end;

procedure tthread_upload.handle_plainTextRequests(sock: TTCPBlockSocket);
begin

//#13#10 ended
if pos(CRLF+CRLF,sock.buffstr)>0 then begin    // protocollo 0.6  e HTTP
         if pos('CHAT CONNECT/0.1'+CRLF,sock.buffstr)=1 then begin
            { if not loc_block_pvt_chat then begin
              socket_globale := ttcpblocksocket.create(false);
               with socket_globale do begin
                socket := sock.socket;
                ip := sock.ip;
                port := sock.port;
                tag := sock.tag;
               end;
               synchronize(accept_crea_form_chat);
               sock.socket := INVALID_SOCKET; //salviamo socket
             end;  }
              sock.Free;
          end else sock.Free;
exit;
end;


//#10+#10 ended
if pos('PUSH ',sock.buffstr)=1 then begin  //download firewall

  socket_globale := ttcpblocksocket.create(false); //ASSEGNIAZIONE SOCKET GLOBALE
  with socket_globale do begin
   socket := sock.socket;
   ip := sock.ip;
   port := sock.port;
   buffstr := sock.buffstr;
   tag := sock.tag;
  end;
  synchronize(accept_put_arrived_push);

  sock.socket := INVALID_SOCKET;
  sock.Free;
end else
if pos('CHAT PUSH/1.0 ',sock.buffstr)=1 then begin

  { socket_globale := ttcpblocksocket.create(false); //ASSEGNIAZIONE SOCKET GLOBALE
   with socket_globale do begin
    socket := sock.socket;
    ip := sock.ip;
    port := sock.port;
    buffstr := hexstr_to_bytestr(copy(sock.buffstr,15,32));  //32 (2*16) di randoms
    tag := sock.tag;
   end;
   synchronize(add_chat_push_arrived); //nel caso non trovi randoms in lista, cancella lui il socket

   sock.socket := INVALID_SOCKET; }
   sock.Free;

end else sock.Free;
end;

procedure tthreaD_upload.free_alternates;
var
i: Integer;
alt,next:precord_alternate;
hash_hold,hash_hold_next:precord_hash_holder_alternate;
begin
try

for i := 0 to 255 do begin
 if lista_hashes_alternate_source[i]=nil then continue; //init alternates
  hash_hold := lista_hashes_alternate_source[i];

  while (hash_hold<>nil) do begin
   hash_hold_next := hash_hold^.next;

    alt := hash_hold^.first_alt;
     while (alt<>nil) do begin
      next := alt^.next;
       FreeMem(alt,sizeof(record_alternate));
      alt := next;
     end;

     FreeMem(hash_hold,sizeof(record_hash_holder_alternate));
   hash_hold := hash_hold_next;
  end;

end;

except
end;
end;

procedure tthread_upload.init_alternates;
var
i: Integer;
begin
 for i := 0 to 255 do lista_hashes_alternate_source[i] := nil; //init alternates
end;

procedure tthread_upload.add_alternate_source_holder(const hash_sha1: string; ip_user,ip_server: Cardinal; port_user,port_server:word);
var
alt,next_alt:precord_alternate;
first_holder,hash_holder:precord_hash_holder_alternate;
begin
try

hash_holder := find_alternate_holder(hash_sha1);
if hash_holder=nil then begin

 hash_holder := AllocMem(sizeof(record_hash_holder_alternate));

  move(hash_sha1[1],hash_holder^.hash_sha1[0],20);
  hash_holder^.crcsha1 := crcstring(hash_sha1);
  hash_holder^.num := 1;

   hash_holder^.first_alt := AllocMem(sizeof(record_alternate));
      hash_holder^.first_alt^.ip_user := ip_user;
      hash_holder^.first_alt^.port_user := port_user;
      hash_holder^.first_alt^.ip_server := ip_server;
      hash_holder^.first_alt^.port_server := port_server;
    hash_holder^.first_alt^.prev := nil;
    hash_holder^.first_alt^.next := nil;



   first_holder := lista_hashes_alternate_source[ord(hash_sha1[1])];
    hash_holder^.next := first_holder;
   lista_hashes_alternate_source[ord(hash_sha1[1])] := hash_holder;

end else begin

   // do we have this source?
   alt := hash_holder^.first_alt;
   while (alt<>nil) do begin
      if alt^.ip_user=ip_user then
       if alt^.port_user=port_user then exit;
    if alt^.next=nil then break
     else alt := alt^.next;
   end;

   // if full delete oldest entry
   if hash_holder^.num>=MAX_NUM_SOURCES then begin
     alt^.prev^.next := nil;
      FreeMem(alt,sizeof(record_alternate));
      dec(hash_holder^.num);
   end;



  next_alt := hash_holder^.first_alt;

   hash_holder^.first_alt := AllocMem(sizeof(record_alternate));
       hash_holder^.first_alt^.ip_user := ip_user;
       hash_holder^.first_alt^.port_user := port_user;
       hash_holder^.first_alt^.ip_server := ip_server;
       hash_holder^.first_alt^.port_server := port_server;
     hash_holder^.first_alt^.prev := nil;
     hash_holder^.first_alt^.next := next_alt;

  if next_alt<>nil then next_alt^.prev := hash_holder^.first_alt;

     inc(hash_holder^.num);

end;

except
end;
end;


function tthread_upload.find_alternate_holder(const hash_sha1: string):precord_hash_holder_alternate;
var
crcsha1: Word;
begin
result := nil;

if lista_hashes_alternate_source[ord(hash_sha1[1])]=nil then exit;

 crcsha1 := crcstring(hash_sha1);

  Result := lista_hashes_alternate_source[ord(hash_sha1[1])];
  while (result<>nil) do begin
     if crcsha1=result^.crcsha1 then
      if comparemem(@hash_sha1[1],@result^.hash_sha1[0],20) then exit;
     Result := result^.next;
  end;

end;


procedure tthread_upload.init_vars;
begin
lista_upload := tmylist.create;
pushedRequests := tmylist.create;
IdleUploads := tmylist.create;
lista_queued := tmylist.create;
lista_accepted_chat := tmylist.create;
lista_sockets_accepted := tmylist.create; //ta thread acceptor
pushes_out := tmylist.create;
udppings := tmylist.create;
socketstoFlush := tmylist.create;

lista_user_granted := nil;

lista_banned_ip := nil;

 init_alternates;

velocita_up_max := 0;



last_sec := gettickcount;
last_accept_chat := 0;
last_accept := 0;
last_ora := last_sec;
last_minuto := last_sec;
last_out_graph := last_sec;
last_sent_upload := last_sec;
last_15_sec := last_sec;
upload_bandwidth := 0;
bsentp := 0;
bsentpmega := 0;

   UDP_Socket := INVALID_SOCKET;

   m_graphObject := INVALID_HANDLE_VALUE;
   FirstGraphSample := nil;
   LastGraphSample := nil;
   NumGraphStats := 0;
   m_graphWidth := 0;
end;

procedure tthread_upload.check_second;
begin
 try

            synchronize(xqueued_update_queue_log);
            
            update_transfer_treeview;
            if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(true);
            xqueued_controlla_timeouts;
            if not terminated then sleep(2);

            if UDP_Socket<>INVALID_SOCKET then checkUDPPings;

               CheckPushedRequests;
               CheckIdleUploads;
               
            check_minuto;

 except
 end;
last_sec := tempo; 
end;

procedure tthread_upload.check_half_sec;
begin

  last_accept := tempo;

 try

   synchronize(prendi_bandwidth);

   accept_receive_handshake; //just accepted
   pushing_deal;
   flushSockets;
 except
 end;

end;

procedure tthread_upload.flushSockets;
var
i,er: Integer;
begin

i := 0;
while (i<socketstoFlush.count) do begin
  socket := socketstoFlush[i];

  if tempo-socket.tag>=25000 then begin
   socketstoFlush.delete(i);
   socket.Free;
   continue;
  end;

  if not TCPSocket_CanWrite(socket.socket,0,er) then begin
    if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
      socketstoFlush.delete(i);
      socket.Free;
    end else inc(i);
    continue;
  end;

  if length(socket.buffstr)=0 then begin  //already sent
   inc(i);
   continue;
  end;

  TCPSocket_SendBuffer(socket.socket,@socket.buffstr[1],length(socket.buffstr),er);
  if er=WSAEWOULDBLOCK then begin
   inc(i);
   continue;
  end;
  if er<>0 then begin
    socketstoFlush.delete(i);
    socket.Free;
   continue;
  end;

  socket.buffstr := ''; //sent...just wait for remote disconnection
  inc(i);
end;

end;


procedure tthread_upload.check_15_sec;
begin
last_15_sec := tempo;
UploadsCheckTimeout;


if UDP_Socket<>INVALID_SOCKET then mysupernodes.mySupernodes_ping(tempo,UDP_Socket);
end;

procedure tthread_upload.Execute;
begin
freeonterminate := False;
priority := tpnormal;


sleep(1000);

accept_server := Ttcpblocksocket.create(false);
accept_listen;



init_vars;



synchronize(prendi_bandwidth); //prendiamo vars!!!


while (not terminated) do begin

   try

      tempo := gettickcount;  //global

      accept_accept;

      if UDP_Socket<>INVALID_SOCKET then receive_udp;

      if lista_upload.count>0 then FlushFiles;

       sleep(5);

      if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(true);

      if tempo-last_accept>500 then check_half_sec;
      
      if tempo-last_15_sec>15000 then check_15_sec
       else
        if tempo-last_sec>1000 then check_second;



      if lista_upload.count>0 then FlushFiles;

      if m_graphObject<>INVALID_HANDLE_VALUE then GraphDeal(true);

       sleep(10);

   except
   end;

end;


shutdown;

end;

procedure tthread_upload.receive_udp;
var
 er,len: Integer;
 udpping:precord_udpping;
 ext: string;
begin
try

if not TCPSocket_canRead(UDP_socket,0,er) then exit;
 Len := SizeOf(UDP_RemoteSin);

 UDP_len_recvd := synsock.RecvFrom(UDP_socket,
                                 UDP_Buffer,
                                 sizeof(UDP_buffer),
                                 0,
                                 @UDP_RemoteSin,
                                 Len);

 if UDP_len_recvd<1 then exit;

 if isAntiP2PIP(UDP_remoteSin.sin_addr.S_addr) then exit;
 if ip_firewalled(UDP_remoteSin.sin_addr.S_addr) then exit;

 case UDP_buffer[0] of

   // CMD_UDPTRANSFER_PONG:; supernode pong
   // CMD_UDPTRANSFER_FILEPING:; peer ping NAT traversal

   CMD_UDPTRANSFER_PUSHREQ:begin // remote server wants us to ping a remote 'interested' user (NAT traversal)
                   if UDP_len_recvd<7 then exit;
                   if not mysupernodes.IsSupernodeIP(UDP_remoteSin.sin_addr.S_addr) then exit;


                   udpping := AllocMem(sizeof(record_udpping));
                    move(UDP_Buffer[1],udpping^.fIP,4);
                    move(UDP_Buffer[5],udpping^.fPort,2);
                    udpping^.fsent := 0;
                    udpping^.finterval := 250;
                    SendUDPPing(udpping);
                   udppings.add(udpping);

              end;


   CMD_UDPTRANSFER_FILEREQ:begin // remote peer wants to know if we are sharing a particular file, just send back an ack
                if UDP_len_recvd<21 then exit;
                if UDP_len_recvd>100 then exit;
                if not hasUDPPing(UDP_remoteSin.sin_addr.S_addr) then exit;

                SetLength(hash_sha1,20);
                move(UDP_Buffer[1],hash_sha1[1],20);
                crcsha1 := crcstring(hash_sha1);

                 synchronize(checkSha1inLibrary);
                 if isSha1inLibrary then begin
                   ext := lowercase(extractfileext(nomefile));
                   if ((ext='.mp3') or (ext='.avi')) and (helper_fakes.isFakeFile(nomefile)) then UDP_Buffer[0] := CMD_UDPTRANSFER_FILENOTSHARED
                    else UDP_Buffer[0] := CMD_UDPTRANSFER_FILEREPOK;
                 end else UDP_Buffer[0] := CMD_UDPTRANSFER_FILENOTSHARED;
                 synsock.SendTo(UDP_socket,
                                UDP_Buffer,
                                UDP_len_recvd,
                                0,
                                @UDP_RemoteSin,
                                SizeOf(UDP_RemoteSin));
              end;


   CMD_UDPTRANSFER_ICHPIECEREQ:begin // remote peer wants ICH data
               if UDP_len_recvd<29 then exit;

                SetLength(hash_sha1,20);
                move(UDP_Buffer[1],hash_sha1[1],20);
                crcsha1 := crcstring(hash_sha1);
                
                synchronize(checkSha1inLibrary);
                 if not isSha1inLibrary then begin
                 UDP_Buffer[0] := CMD_UDPTRANSFER_ICHPIECEERR4;
                 synsock.SendTo(UDP_socket,
                                UDP_Buffer,
                                UDP_len_recvd,
                                0,
                                @UDP_RemoteSin,
                                SizeOf(UDP_RemoteSin));
                 exit;
                 end;

                 helper_ich.ICH_send_Phash(UDP_Socket,
                                           hash_sha1,
                                           @UDP_buffer[0],
                                           UDP_len_recvd,
                                           UDP_RemoteSin,
                                           phash_insertion_point,
                                           filesize_reale);

             end;

   CMD_UDPTRANSFER_PIECEREQ:begin
                        if UDP_len_recvd<35 then exit;    // op + hash + 4 source handle , 8 byte start byte + 4 byte limitlen
                        SetLength(hash_sha1,20);
                        move(UDP_Buffer[1],hash_sha1[1],20);
                        crcsha1 := crcstring(hash_sha1);
                
                        synchronize(checkSha1inLibrary);
                        if not isSha1inLibrary then begin
                         SendBackUDPError(UDPTRANSFER_ERROR_FILENOTSHARED);
                         exit;
                        end;
                        if is_banned_ip(UDP_RemoteSin.sin_addr.S_addr) then begin
                         SendBackUDPError(UDPTRANSFER_ERROR_USERBLOCKED);
                         exit;
                        end;

                        handler_UDPTransferReq;
                      end;

 end;

except
end;
end;

procedure tthread_upload.handler_UDPTransferReq;
var
sourceHandle: Cardinal;
upload: TUPload;
WantedProgress: Int64;
MaxLen: Word;
SrcInfo: string;
len_packet: Integer;
fstream: THandleStream;
sendXsize: Boolean;
AddHeaders: Boolean;
begin
move(UDP_Buffer[21],sourceHandle,4);
move(UDP_Buffer[25],WantedProgress,8);
move(UDP_Buffer[33],MaxLen,2);


    if WantedProgress>=filesize_reale then begin
      SendBackUDPError(UDPTRANSFER_ERROR_OFFSETBEYONDLIMIT);
      exit;
    end;


if UDP_Len_recvd>35 then begin
 AddHeaders := True;
 SetLength(SrcInfo,UDP_len_recvd-35);
 move(UDP_Buffer[35],SrcInfo[1],length(SrcInfo));
 ParseUDPSrcInfo(SrcInfo,sendXsize);

 if sendXsize then begin
  len_packet := UDPFillXSizeReply;
  synsock.SendTo(UDP_socket,
                 UDP_Buffer,
                 len_packet,
                 0,
                 @UDP_RemoteSin,
                 SizeOf(UDP_RemoteSin));
 exit;
 end;

end else AddHeaders := False;


ip_user := cardinal(UDP_RemoteSin.sin_addr.S_addr); //required by comparison below
upload := FindUDPUpload(sourceHandle);
if upload=nil then begin

 if not AddHeaders then begin
  SendBackUDPError(UDPTRANSFER_ERROR_MISSINGHEADERS);
  exit;
 end;

 //should create a new upload, check if we are busy
 if ((upload_count>=cardinal(m_limite_upload)) and
     (not is_user_granted) and
     (filesize_reale>MAX_SIZE_NO_QUEUE)) then begin
      UDP_Buffer[0] := CMD_UDPTRANSFER_PIECEBUSY;
      len_packet := 33;
      addUDPHeaders(len_packet);
     synsock.SendTo(UDP_socket,
                    UDP_Buffer,
                    len_packet,
                    0,
                    @UDP_RemoteSin,
                    SizeOf(UDP_RemoteSin));
 exit;
 end;


 fstream := MyFileOpen(utf8strtowidestr(nomefile),ARES_READONLY_ACCESS);
 if fstream=nil then begin
   SendBackUDPError(UDPTRANSFER_ERROR_FILEERROR);
   exit;
 end;

 if MaxLen=0 then MaxLen := UDPTRANSFER_PIECESIZE
  else
   if MaxLen>UDPTRANSFER_PIECESIZE then MaxLen := UDPTRANSFER_PIECESIZE;

 upload := TUpload.create(tempo);
  with upload do begin
   isUDP := True;
   should_display := True;
   lastUDPData := tempo;
   out_reply_header := '';
   UDPSourceHandle := sourceHandle;
   filename := nomefile;
   crcfilename := crcnomefile;
   stream := fstream;
   his_shared := his_numero_condivisi;
   his_speedDL := his_speed;
   ip_alt := ip_utente_interno;
   velocita := 0;
   actual := WantedProgress;
   startpoint := WantedProgress;
   bytesprima := startpoint;
  end;
  upload.his_agent := his_agent;
  upload.his_progress := his_progress;
  upload.his_buildn := his_buildn;
  upload.his_upcount := his_upcount;                 
   if his_downcount=0 then upload.his_downcount := 1
    else upload.his_downcount := his_downcount;
  upload.num_available := num_available;
  upload.port_server := port_server;
  upload.ip_server := ip_server;
  upload.ip_user := ip_user;
  upload.port_user := port_user;
   if length(nickname)=0 then nickname := STR_ANON+inttohex(random(255),2)+inttohex(random(255),2)+STR_UNKNOWNCLIENT;
   upload.nickname := nickname;
   upload.crcnick := stringcrc(nickname,true);
  upload.filesize_reale := filesize_reale;
  upload.endpoint := (upload.startPoint+helper_ich.ICH_calc_chunk_size(filesize_reale))-1;
  upload.size := (upload.endpoint-upload.startpoint)+1;
  upload.bsent := 0;
  upload.bytesprima := 0;

  lista_upload.add(upload);
  synchronize(add_new_upload_visual);

end else begin
  if MaxLen=0 then MaxLen := UDPTRANSFER_PIECESIZE
   else
    if MaxLen>UDPTRANSFER_PIECESIZE then MaxLen := UDPTRANSFER_PIECESIZE;

  with upload do begin
   lastUDPData := tempo;
   actual := WantedProgress;
   if endpoint+UDPTRANSFER_PIECESIZE>endpoint then begin
    endpoint := endpoint+ICH_calc_chunk_size(filesize_reale);
    size := (endpoint-startpoint)+1;
   end;
  end;

end;


     helper_diskio.MyFileSeek(upload.stream,upload.actual,ord(soFromBeginning));
     if helper_diskio.MyFileSeek(upload.stream,0,ord(soCurrent))<>upload.actual then begin
      SendBackUDPError(UDPTRANSFER_ERROR_UNEXPECTEDERROR);
      exit;
     end;

  if upload.actual+MaxLen>upload.stream.size then MaxLen := upload.stream.size-upload.actual;

  if MaxLen=0 then begin  // file terminated
   SendBackUDPError(UDPTRANSFER_ERROR_UNEXPECTEDERROR);
   exit;
  end;



     len_Packet := UDPFillData(upload,MaxLen,AddHeaders);
     synsock.SendTo(UDP_socket,
                    UDP_Buffer,
                    len_packet,
                    0,
                    @UDP_RemoteSin,
                    SizeOf(UDP_RemoteSin));


end;

function tthread_upload.UDPFillXSizeReply: Integer;
var
stringa: string;
begin
UDP_Buffer[0] := CMD_UDPTRANSFER_XSIZEREP;
result := 25;
 stringa := 'X-Title: '+urlencode(meta_title)+CRLF+
          'X-Artist: '+urlencode(meta_artist)+CRLF+
          'X-Album: '+urlencode(meta_album)+CRLF+
          'X-Type: '+urlencode(meta_category)+CRLF+
          'X-Language: '+urlencode(meta_language)+CRLF+
          'X-Date: '+urlencode(meta_date)+CRLF+
          'X-Comments: '+urlencode(meta_comments)+CRLF+
          'X-Size: '+inttostr(filesize_reale)+CRLF;
 move(stringa[1],UDP_Buffer[result],length(stringa));
 inc(result,length(stringa));
end;

procedure tthread_upload.addUDPHeaders(var offset:integer);
var
outBuf: string;
strTemp: string;
begin
   outBuf := int_2_word_string(length(appname+CHRSPACE+vars_global.versioneares))+chr(TAG_ARESHEADER_AGENT)+
            appname+CHRSPACE+vars_global.versioneares+
              int_2_word_string(length(vars_global.mynick))+chr(TAG_ARESHEADER_NICKNAME)+
              vars_global.mynick;

              
   strTemp := helper_ipfunc.serialize_myConDetails;
   outBuf := outBuf+int_2_word_string(length(strTemp))+chr(TAG_ARESHEADER_HOSTINFO2)+strTemp;


   strTemp := GetBinAltSources(ip_user);
   outBuf := outBuf+int_2_word_string(length(strTemp))+chr(TAG_ARESHEADER_ALTSSRC)+strTemp;

 move(outBuf[1],UDP_Buffer[offset],length(outBuf));
 inc(offset,length(outBuf));
end;

function tthread_upload.UDPFillData(upload: Tupload; Len: Cardinal; addHeaders:boolean): Integer;
var
len_red: Integer;
len_redW: Word;
sha1: TSha1;
checkSumStartPoint: Word;
checkSum: string;
begin
UDP_Buffer[0] := CMD_UDPTRANSFER_ICHPIECEREP;
result := 33;

// reply headers here...
if addHeaders then addUDPHeaders(result);


checkSumStartPoint := result;   //keep track of correct point where to write checksums later

//write checksum's header  #build 3005+
UDP_Buffer[checkSumStartPoint] := 20;
UDP_Buffer[checkSumStartPoint+1] := 0;
UDP_Buffer[checkSumStartPoint+2] := TAG_ARESHEADER_DATACHECKSUM;
 inc(checkSumStartPoint,3);  // this is were checksum data will be written later


 
 inc(result,23); // move to the correct offset (skip checksum data)
UDP_Buffer[result+2] := TAG_ARESHEADER_DATA;
len_red := upload.stream.read(UDP_Buffer[result+3],Len);

if len_red>0 then begin

//calculate sha1 checksum for this data
sha1 := TSha1.create;
 sha1.transform(UDP_Buffer[result+3],len_red);
 sha1.complete;
 checksum := sha1.hashValue;
sha1.Free;
move(checksum[1],UDP_Buffer[checkSumStartPoint],20);

//write data header
 len_redW := len_red;
 move(len_redW,UDP_Buffer[result],2);
 inc(result,len_redW+3);

  inc(upload.actual,len_redW);
  inc(bsentp,len_redW);
  inc(bsentpmega,len_redW);
  inc(upload.bsent,len_redW);
  if cardinal(upload)=m_graphObject then GraphAddSample(len_red);
  
end else begin
 len_redw := 0;
 move(len_redW,UDP_Buffer[result],2);
 inc(result,3);
end;

end;

procedure tthread_upload.SendBackUDPError(ErCode: Byte);
begin
UDP_Buffer[0] := CMD_UDPTRANSFER_PIECEERR;
UDP_Buffer[33] := ErCode;
     synsock.SendTo(UDP_socket,
                    UDP_Buffer,
                    34,
                    0,
                    @UDP_RemoteSin,
                    SizeOf(UDP_RemoteSin));
end;


function tthread_upload.FindUDPUpload(sourceHandle: Cardinal): TUpload;
var
i: Integer;
upload: TUpload;
begin
result := nil;

for i := 0 to lista_upload.count-1 do begin
 upload := lista_upload[i];
  if not upload.should_display then continue;
   if not upload.isUDP then continue;
    if upload.ip_user<>cardinal(UDP_remoteSin.sin_addr.S_addr) then continue;
     if upload.UDPSourceHandle<>sourceHandle then continue;
      if upload.filename<>nomefile then continue;

   Result := upload;
   break;
end;

end;


procedure tthread_upload.ParseUDPSrcInfo(SrcInfo: string; var wantXSize:boolean);
var
cont,str_temp: string;
len: Word;
command: Byte;
begin
wantXSize := False;
agent := '';
his_agent := '';
nickname := '';
port_server := 0;
ip_server := 0;

port_user := 0;

his_progress := 0;
his_downcount := 40;
his_upcount := -1;
num_available := 1;
his_numero_condivisi := -1;
his_speed := 0;

while (length(SrcInfo)>=3) do begin
  len := chars_2_word(copy(SrcInfo,1,2));
  command := ord(SrcInfo[3]);
   cont := copy(SrcInfo,4,len);
  delete(SrcInfo,1,3+len);
   if length(cont)<>len then continue; //wrong sized field??

  case command of

   TAG_ARESHEADER_NICKNAME:nickname := cont;

   TAG_ARESHEADER_XSIZE:wantXSize := True;

   TAG_ARESHEADER_ALTSSRC:ParseAltSources(cont);

   TAG_ARESHEADER_AGENT:begin //agent
       his_agent := trim(cont);
       agent := get_first_word(trim(cont));
        str_temp := copy(cont,pos(' ',cont)+1,length(cont));    //2958+
        str_temp := trim(str_temp);
        delete(str_temp,1,pos('.',str_temp)); // 1.8.1.2957 -> 8.1.2957
        delete(str_temp,1,pos('.',str_temp)); // 8.1.2957 -> 1.2957
        delete(str_temp,1,pos('.',str_temp)); // 1.2957 -> 2957
        his_buildn := strtointdef(str_temp,0);
        synchronize(DHT_add_possible_bootstrap_client);
    end;

    TAG_ARESHEADER_XSTATS2:begin
                           xstats := cont;
                           ParseXStats;
                           end;
                           
    TAG_ARESHEADER_HOSTINFO2:begin // new detail str 12/29/2005
       ip_user := chars_2_dword(copy(cont,1,4));
       port_user := chars_2_word(copy(cont,5,2));
       ip_utente_interno := chars_2_dword(copy(cont,7,4));
       ip_server := chars_2_dword(copy(cont,11,4));
       port_server := chars_2_word(copy(cont,15,2));
       // 0 to 4 other servers follow here
      end;

  end;
end;

if nickname='' then nickname := ipdotstring_to_anonnick(
                               ipint_to_dotstring(
                                UDP_remoteSin.sin_addr.S_addr));
if agent='' then agent := STR_FOURQSTNMRK;
nickname := nickname+'@'+agent;

end;

procedure tthread_upload.checkUDPPings;
var
udpping:precord_udpping;
i: Integer;
begin

i := 0;
while (i<udppings.count) do begin
 udpping := udppings[i];

   if tempo-udpping^.flastOut<udpping^.finterval then begin
    inc(i);
    continue;
   end;

  SendUDPPing(udpping);

  if udpping^.fsent=7 then begin
   udppings.delete(i);
   FreeMem(udpping,sizeof(record_udpping));
  end else inc(i);

end;

end;

function tthread_upload.hasUDPPing(ip: Cardinal): Boolean;
var
udpping:precord_udpping;
i: Integer;
begin
result := False;
for i := 0 to udppings.count-1 do begin
  udpping := udppings[i];
  if udpping^.fip=ip then begin
   Result := True;
   exit;
  end;
end;
end;

procedure tthread_upload.SendUDPPing(udpping:precord_udpping);
begin
 inc(udpping^.fsent);
 udpping^.flastOut := tempo;
 udpping^.finterval := (udpping^.finterval shl 1);

 UDP_Buffer[0] := CMD_UDPTRANSFER_FILEPING;

 UDP_RemoteSin.sin_family := AF_INET;
 UDP_RemoteSin.sin_port := synsock.htons(udpping.fport);
 UDP_RemoteSin.sin_addr.s_addr := udpping.fip;

 synsock.SendTo(UDP_socket,
                UDP_Buffer,
                1,
                0,
                @UDP_RemoteSin,
                SizeOf(UDP_RemoteSin));
end;


procedure tthread_upload.check_minuto;
begin
if gettickcount-last_minuto<MINUTE then exit;
 last_minuto := gettickcount;

expire_lista_accept_chat;

synchronize(check_firewalled_status);

if lista_queued.count>=10 then
 if upload_count+cardinal(IdleUploads.count)>=cardinal(m_limite_upload) then drop_slower_transfer;

check_hour;
end;

procedure tthread_upload.check_firewalled_status;
begin
if vars_global.im_firewalled then
 if UDP_Socket=INVALID_SOCKET then BindUdpSocket;
end;

procedure tthread_upload.check_hour;
begin
if last_minuto-last_ora<HOUR then exit;
 last_ora := last_minuto;


end;



procedure tthread_upload.pushing_deal;
var
er: Integer;
sockt: Ttcpblocksocket;
push_out: Tpush_out;
i: Integer;
begin

try
i := 0;
while (i<pushes_out.count) do begin
 push_out := pushes_out[i];

  if tempo-push_out.socket.tag>TIMOUT_SOCKET_CONNECTION then begin
     pushes_out.delete(i);

     push_out.Free;
     continue;
  end;

  if not push_out.connected then begin
    er := TCPSocket_ISConnected(push_out.socket);
    if er=WSAEWOULDBLOCK then begin
     inc(i);
     continue;
    end else
    if er<>0 then begin
     pushes_out.delete(i);

     push_out.Free;
     continue;
    end;
    push_out.connected := True;
  end;


  TCPSocket_SendBuffer(push_out.socket.socket,@push_out.socket.buffstr[1],length(push_out.socket.buffstr),er);
  if er=WSAEWOULDBLOCK then begin
   inc(i);
   continue;
  end else
  if er<>0 then begin
     pushes_out.delete(i);

     push_out.Free;
     continue;
  end;



 sockt := TTcpBlockSocket.create(false);
  sockt.ip := push_out.socket.ip;
  sockt.socket := push_out.socket.socket;
  sockt.port := push_out.socket.port;{0};
  sockt.buffstr := '';
  sockt.tag := tempo;
   PushedRequests.add(sockt);

  pushes_out.delete(i);
  push_out.socket.socket := INVALID_SOCKET;
  push_out.Free;
end;


except
end;
end;



procedure tthread_upload.pushing_sync; //synch
var
ppush_to_go:precord_push_to_go;
begin
try


    if vars_global.lista_push_nostri.count>0 then begin
     ppush_to_go := vars_global.lista_push_nostri[0];

      if not isAntiP2PIP(ppush_to_go^.ip) then
       if not is_banned_ip(ppush_to_go^.ip) then
        if ppush_to_go^.port<>0 then pushing_activate(ppush_to_go);

        ppush_to_go^.filename := '';
        vars_global.lista_push_nostri.delete(0);
       FreeMem(ppush_to_go,sizeof(record_push_to_go));
    end;


except
end;
end;



procedure tthread_upload.xqueued_controlla_timeouts;
var
i: Integer;
queued:precord_queued;
cancelled: Boolean;
begin
tempo := gettickcount;

cancelled := False;
i := 0;
try            //queued
while (i<lista_queued.count) do begin

queued := lista_queued[i];


 if tempo>queued^.polltime+(queued^.pollmax*1000) then begin    // qui facciamo scadere....

  queued^.nomefile := '';
  queued^.user := '';
  queued^.his_agent := '';
  
  lista_queued.delete(i);
   FreeMem(queued,sizeof(record_queued));

  cancelled := True;

 end else inc(i);
end;
except
end;

 if cancelled then begin
  try
  synchronize(update_statusbar_1);
  except
  end;
 end;

end;

procedure tthread_upload.pushing_activate(push:Precord_push_to_go);
var
push_out: Tpush_out;
begin
try

 //if push^.proxy then push_out_string := 'PPUS '+push^.filename+chr(10)+chr(10)
 //formati:
 //   vercchio PUSH ABCDEF0123456789            +randoms
 //   nuovi     PUSH SHA1:ABCDEFABCD01234567890  +randoms
 //              PUSH MD5:ABCDEF0123456789

push_out := Tpush_out.create(tempo);
 with push_out do begin//hash(hexstr)+8bte randoms

  {socket.buffstr := 'PUSH SHA1:'+
              bytestr_to_hexstr(copy(push^.filename,1,20))+
              copy(push^.filename,21,length(push^.filename))+
              chr(10)+chr(10); }

  socket.buffstr := helper_download_misc.get_out_push_string(copy(push^.filename,1,20),
                  copy(push^.filename,21,length(push^.filename)));
  assign_proxy_settings(socket);
  socket.ip := ipint_to_dotstring(push^.ip);
  socket.port := push^.port;
  socket.connect(socket.ip,inttostr(socket.port));
 end;

  pushes_out.add(push_out);

except
end;
end;


procedure tthread_upload.error_upload;
begin
//    display terrible error message :)
end;

procedure tthread_upload.update_transfer_treeview;    // graphical display
var
i: Integer;
upload: Tupload;
attuale_vel:double;
begin
if lista_upload.count=0 then begin
 speed_up_att := 0;
 synchronize(metti_velocita_up); //sempre per special caption...
 exit;
end;

 tempo := gettickcount;
 if tempo-last_sec=0 then exit;


  velocita_up_max := 0;
  speed_up_att := 0;      //calculate new

 try

 for i := 0 to lista_upload.count-1 do begin
  upload := lista_upload[i];
  
  if upload.isUDP then attuale_vel := (upload.bsent-upload.bytesprima) * (SECOND / (tempo-last_sec))
   else attuale_vel := (upload.actual-upload.bytesprima) * (SECOND / (tempo-last_sec));

  upload.velocita := ((upload.velocita div 3)*2)+(trunc(attuale_vel) div 3);

  if upload.velocita>0 then begin
  inc(speed_up_att,upload.velocita);
   if not upload.isUDP then begin
     if upload.socket<>nil then begin

      if ((upload.socket.ip<>localip) and
          (not ip_firewalled(upload.socket.ip))) then inc(velocita_up_max,upload.velocita);
     end;
   end else inc(velocita_up_max,upload.velocita);
  end;

  if upload.isUDP then upload.bytesPrima := upload.bsent
   else upload.bytesprima := upload.actual;

 end;

 except
 end;



 if cardinal(velocita_up_max)>velocita_max_ufrmmain then synchronize(metti_nuova_velocita_up); //se miglire...

   try
  synchronize(update_listview_upload_eventuale);
   except
   end;

end;

procedure tthread_upload.metti_velocita_up; //synch
begin
try
vars_global.bytes_sent := bsentp+vars_global.partialUploadSent;
vars_global.velocita_att_upload := cardinal(speed_up_att)+vars_global.speedUploadPartial;

if bsentpmega>=MEGABYTE then begin
 inc(vars_global.mega_uploaded);
 bsentpmega := 0;
end;


except
end;
end;

procedure tthread_upload.metti_nuova_velocita_up; //synchronize
begin
   vars_global.velocita_up := velocita_up_max;
   velocita_max_ufrmmain := velocita_up_max;
end;



function tthread_upload.trova_stesso_file( upload: Tupload ):pCmtVnode;
var
node:pCmtVnode;
datanode:precord_data_node;
UpData:precord_displayed_upload;
begin
result := nil;

    node := ares_FrmMain.treeview_upload.getfirst;
    while (node<>nil) do begin

     datanode := ares_FrmMain.treeview_upload.getdata(node);
     if datanode.m_type<>dnt_upload then begin
      node := ares_FrmMain.treeview_upload.getnextSibling(node);
      continue;
     end;

     updata := datanode^.data;
     if updata^.upload=nil then
      if updata^.completed then
       if upload.ip_user=updata^.ip then
        if upload.crcnick=updata^.crcnick then
         if upload.crcfilename=updata^.crcfilename then
          if upload.nickname=updata^.nickname then
           if upload.filename=updata^.nomefile then begin
            Result := node;
            exit;
           end;

     node := ares_FrmMain.treeview_upload.getnextSibling(node);
    end;
    
end;

procedure tthread_upload.termina_upload_visual; //synch  upload_visual_per_synch
var
node:pCmtVnode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
begin
 try

 node := ares_FrmMain.treeview_upload.getfirst;
 while (node<>nil) do begin

  datanode := ares_FrmMain.treeview_upload.getdata(node);
  if datanode^.m_type<>dnt_upload then begin
    node := ares_FrmMain.treeview_upload.getnextSibling(node);
    continue;
  end;

  UpData := datanode^.data;

    if not UpData^.completed then
     if UpData^.upload<>nil then
      if UpData^.upload=upload_visual_per_synch then begin
        UpData^.completed := True;
        UpData^.upload := nil;
        UpData^.velocita := 0;
        if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then ares_FrmMain.treeview_upload.invalidatenode(node);
       update_statusbar_1;
       if ares_frmmain.clearIdle1.checked then ares_frmmain.treeview_upload.deleteNode(node,true);
       break;
     end;

     node := ares_FrmMain.treeview_upload.getnextSibling(node);
end;


except
end;
end;

procedure tthread_upload.add_new_upload_visual; //synch
var
uploadl: Tupload;
node:pCmtVnode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
begin
try
uploadl := lista_upload[lista_upload.count-1];

   node := trova_stesso_file(uploadl);
   if node<>nil then begin
    dataNode := ares_FrmMain.treeview_upload.getdata(node);
    UpData := dataNode^.data;
    with UPData^ do begin
     handle_obj := cardinal(uploadl);
     upload := uploadl;
     inc(continued_from,progress); //vecchio progress
     size := (uploadl.endpoint-uploadl.startpoint)+1;
     continued := True;
     his_progress := uploadl.his_progress;
     his_speedDL := uploadl.his_speedDL;
     num_available := uploadl.num_available;
     his_shared := uploadl.his_shared;
     his_upcount := uploadl.his_upcount;
     his_downcount := uploadl.his_downcount;
     his_agent := uploadl.his_agent;
     isUDP := uploadl.isUDP;
    end;
   end else begin
    node := ares_FrmMain.treeview_upload.AddChild(nil);
     dataNode := ares_FrmMain.treeview_upload.getdata(node);
     dataNode^.m_type := dnt_upload;
     UpData := AllocMem(sizeof(record_displayed_upload));
     dataNode^.data := UpData;
     with UpData^ do begin
      handle_obj := cardinal(uploadl);
      upload := uploadl;
      size := (uploadl.endpoint-uploadl.startpoint)+1;
      progress := uploadl.actual-uploadl.startpoint;
      continued := False;
      nomefile := uploadl.filename;
      crcfilename := uploadl.crcfilename;
      continued_from := 0;
      isUDP := uploadl.isUDP;
      his_progress := uploadl.his_progress;
      num_available := uploadl.num_available;
      his_shared := uploadl.his_shared;
      his_speedDL := uploadl.his_speedDL;
      his_upcount := uploadl.his_upcount;
      his_downcount := uploadl.his_downcount;
      his_agent := uploadl.his_agent;
      nickname := uploadl.nickname;
      crcnick := uploadl.crcnick;

      filesize_reale := uploadl.filesize_reale;
     end;
   end;

    with UpData^ do begin
     completed := False;
     should_ban := False;
     should_stop := False;
     ip := uploadl.ip_user;
     ip_alt := uploadl.ip_alt;
     port := uploadl.port_user;
     ip_server := uploadl.ip_server;
     port_server := uploadl.port_server;
     start_point := uploadl.startpoint;
     size := (uploadl.endpoint-uploadl.startpoint)+1;
     if isUDP then progress := 0
      else progress := (uploadl.actual-uploadl.startpoint);

     velocita := uploadl.velocita;
   end;


update_statusbar_1;
except
end;
end;

procedure tthread_upload.update_listview_upload_eventuale; //synch
var
ind: Integer;
node,tmpNode:pCmtVnode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
upload: Tupload;
has_changed: Boolean;
begin

try
metti_velocita_up;
except
end;

 try
 node := ares_FrmMain.treeview_upload.getfirst;
 while (node<>nil) do begin

  dataNode := ares_FrmMain.treeview_upload.getdata(node);
  if datanode^.m_type<>dnt_upload then begin
   node := ares_FrmMain.treeview_upload.getnextSibling(node);
   continue;
  end;

  UpData := dataNode^.data;

   if UpData^.should_ban then begin
     add_ban(UpData^.ip);
      if UpData^.upload<>nil then begin
        upload := UpData^.upload;
          UpData^.upload := nil;
          if upload.socket<>nil then free_upload_stuff(upload,false);
           ind := lista_upload.indexof(upload);
           if ind<>-1 then lista_upload.delete(ind);
          upload.Free;
          UpData^.completed := True;
          ares_FrmMain.treeview_upload.invalidatenode(node);
          update_statusbar_1;
     end;
     if ares_frmmain.clearIdle1.checked then begin //auto Clear Idle
      tmpNode := ares_FrmMain.treeview_upload.getnextSibling(node);
       ares_frmmain.treeview_upload.deleteNode(node,true);
      node := tmpNode;
     end else node := ares_FrmMain.treeview_upload.getnextSibling(node);
    continue;
   end;

 if UpData^.completed then begin
  node := ares_FrmMain.treeview_upload.getnextSibling(node);
  continue;
 end;
 if UpData^.upload=nil then begin
  node := ares_FrmMain.treeview_upload.getnextSibling(node);
  continue;
 end;

  upload := UpData^.upload;

  has_changed := False;

  if UpData^.should_stop then begin
    UpData^.upload := nil;
     if upload.socket<>nil then free_upload_stuff(upload,false);

     ind := lista_upload.indexof(upload);
     if ind<>-1 then lista_upload.delete(ind);
     upload.Free;
     UpData^.completed := True;
     ares_FrmMain.treeview_upload.invalidatenode(node);
     update_statusbar_1;
     if ares_frmmain.clearIdle1.checked then begin //auto Clear Idle
      tmpNode := ares_FrmMain.treeview_upload.getnextSibling(node);
      ares_frmmain.treeview_upload.deleteNode(node,true);
      node := tmpNode;
     end else node := ares_FrmMain.treeview_upload.getnextSibling(node);
    continue;
  end;

       if UpData^.isUDP then begin
         if UpData^.progress<>upload.bsent then begin
          has_changed := True;
          UpData^.progress := upload.bsent;
         end;
       end else begin
         if UpData^.progress<>(upload.actual-upload.startpoint) then begin
          has_changed := True;
          UpData^.progress := (upload.actual-upload.startpoint);
         end;
       end;

        if UpData^.isUDP then 
         if UpData^.progress>=UpData^.size then begin
          has_changed := True;
          UpData^.size := UpData^.progress+(256*KBYTE);
         end;

        if UpData^.velocita<>upload.velocita then begin
         has_changed := True;
         UpData^.velocita := upload.velocita;
        end;


        if ((has_changed) and
            (ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER)) then begin
         ares_FrmMain.treeview_upload.invalidatenode(node);
         update_hint(ares_FrmMain.treeview_upload,node);
        end;

     node := ares_FrmMain.treeview_upload.getnextSibling(node);
 end;

except
end;
end;

procedure tthread_upload.update_hint(treeview: Tcomettree; node:pCmtVnode);
begin
try
if vars_global.formhint.top=10000 then exit;
 if node<>vars_global.previous_hint_node then exit;

     mainGui_hintTimer(treeview,node);

except
end;
end;


procedure tthread_upload.shutdown;
var
upload: Tupload;
queued:precord_queued;
us_granted:precord_user_granted;
ip_accepted_chat:precord_ip_accepted_chat;
push_out: Tpush_out;
udpping:precord_udpping;
begin

try
while (pushes_out.count>0) do begin
  push_out := pushes_out[pushes_out.count-1];
            pushes_out.delete(pushes_out.count-1);
  push_out.Free;
end;
pushes_out.Free;
except
end;

try
while (udppings.count>0) do begin
 udpping := udppings[udppings.count-1];
          udppings.delete(udppings.count-1);
 FreeMem(udpping,sizeof(record_udpping));
end;
udppings.Free;
except
end;

try
while (lista_accepted_chat.count>0) do begin
 ip_accepted_chat := lista_accepted_chat[lista_accepted_chat.count-1];
    lista_accepted_chat.delete(lista_accepted_chat.count-1);
    FreeMem(ip_accepted_chat,sizeof(record_ip_accepted_chat));
end;
lista_accepted_chat.Free;
except
end;



try
if lista_user_granted<>nil then begin
 while (lista_user_granted.count>0) do begin
  us_granted := lista_user_granted[lista_user_granted.count-1];
  lista_user_granted.delete(lista_user_granted.count-1);
  FreeMem(us_granted,sizeof(record_user_granted));
 end;
 lista_user_granted.Free;
end;
except
end;


   try
   accept_server.closesocket;
   accept_server.Free;
   except
   end;


      try
while (lista_sockets_accepted.count>0) do begin
    socket := lista_sockets_accepted[lista_sockets_accepted.count-1];
     lista_sockets_accepted.delete(lista_sockets_accepted.count-1);
     socket.Free;
end;
lista_sockets_accepted.Free;
   except
   end;


try
while (socketstoFlush.count>0) do begin
    socket := socketstoFlush[socketstoFlush.count-1];
            socketstoFlush.delete(socketstoFlush.count-1);
     socket.Free;
end;
socketstoFlush.Free;
except
end;

try
while (pushedRequests.count>0) do begin
socket := pushedRequests[pushedRequests.count-1];
 pushedRequests.delete(pushedRequests.count-1);
socket.Free;
end;
except
end;
pushedRequests.Free;


try
while (lista_upload.count>0) do begin
upload := lista_upload[lista_upload.count-1];
        lista_upload.delete(lista_upload.count-1);
upload.Free;
end;
except
end;

  lista_upload.Free;
  lista_upload := nil;

try
while (IdleUploads.count>0) do begin
socket := IdleUploads[IdleUploads.count-1];
        IdleUploads.delete(IdleUploads.count-1);
socket.Free;
end;
except
end;
IdleUploads.Free;

  try
  if lista_banned_ip<>nil then begin
  lista_banned_ip.Free;
  end;
  except
  end;

try
while (lista_queued.count>0) do begin
 queued := lista_queued[lista_queued.count-1];
  queued^.user := '';
  queued^.nomefile := '';
  queued^.his_agent := '';
 lista_queued.delete(lista_queued.count-1);
FreeMem(queued,sizeof(record_queued));
end;
except
end;
lista_queued.Free;
lista_queued := nil;

free_alternates;

end;

procedure tthread_upload.free_upload_stuff(upload: Tupload; should_continue:boolean);
var
socket: Ttcpblocksocket;
begin

 try
  if ((should_continue) and (upload.should_display)) then synchronize(update_listview_upload_eventuale); //need to tell him...
 except
 end;

        if upload.stream<>nil then FreeHandleStream(Upload.stream);
        upload.stream := nil;

        if upload.is_phash then begin
         helper_diskio.deletefileW(utf8strtowidestr(upload.filename));  // delete temp phash
         //TODO delete empty folder?
        end;

  upload.filename := '';
  upload.nickname := '';
  upload.out_reply_header := '';

 try
   if ((not should_continue) and (not upload.is_phash)) then begin
     if upload.socket<>nil then FreeAndNil(upload.socket);
   end else begin

        if upload.socket<>nil then begin
         socket := upload.socket;
          socket.buffstr := '';
          socket.tag := tempo;
           IdleUploads.add(socket); //keep-alive after first chunk
         upload.socket := nil;
        end;

   end;
 except
 end;

end;

procedure tthread_upload.UploadsCheckTimeout; //15 secs
var
i: Integer;
upload: Tupload;
tm: Cardinal;
begin

tm := gettickcount; //<---poll here or timeouts will occur
try
/////////////////////////////////////////////////gestione headers!
i := 0;
while (i<lista_upload.count) do begin
if terminated then exit;

 upload := lista_upload[i];

 if is_timeouted_upload(upload,tm) then begin
        free_upload_stuff(upload,(not upload.isUDP));
        lista_upload.delete(i);
          if upload.should_display then begin
            upload_visual_per_synch := upload;
            synchronize(termina_upload_visual); //synch  upload_visual_per_synch
          end;
           upload.Free;
 end else inc(i);

end;

except
end;
end;


function tthread_upload.is_timeouted_upload(upload: Tupload; tempo: Cardinal): Boolean;
begin
result := False;
          if upload.isUDP then exit;
          if upload.socket=nil then exit;

          if tempo-upload.socket.tag>MINUTE then begin //flush timeout?
           Result := True;
           exit;
          end;

         if lista_upload.count<m_limite_upload then exit;  // no need to go further if slots are available for other users

       {  if upload.num_available<10 then begin
           if tempo-upload.start_time>35*MINUTO then Result := True;
           exit; //facciamo drop solo se ha altre alternative...
         end;   }

         { if upload.port_user<>0 then begin  //ares timeout ogni 15 minuti? buttiamo giù risorse peggiori

            if upload.velocita>35000 then begin
             if tempo-upload.start_time>25*MINUTO then Result := True;
            end else
            if upload.velocita>10000 then begin  //da 10 a 30 k sec hanno 30 minuti
              if tempo-upload.start_time>40*MINUTO then Result := True;
            end else
            if upload.velocita>5000 then begin
             if tempo-upload.start_time>10*MINUTO then Result := True; //tutti gli altri hanno 10 minuti
            end else
              if tempo-upload.start_time>2*MINUTO then Result := True;
              
          end else begin  }

             if upload.velocita>50000 then begin //fibra se riesce scarica tutto
              if tempo-upload.start_time>30*MINUTE then Result := True;
             end else
             if upload.velocita>20000 then begin
              if tempo-upload.start_time>20*MINUTE then Result := True;
             end else
             if upload.velocita>5000 then begin
              if tempo-upload.start_time>10*MINUTE then Result := True;
             end else
             if tempo-upload.start_time>2*MINUTE then Result := True;
        //  end;
end;

procedure tthread_upload.FlushHeaders(tempo: Cardinal);
var
 i: Integer; //i per forza intero perchè puà essere -1 in caso di free upload
 upload: Tupload;
 er: Integer;
 to_send: Integer;
 lung: Integer;
begin
/////////////////////////////////////////////////gestione headers!
i := 0;
while (i<lista_upload.count) do begin
if terminated then exit;
try

upload := lista_upload[i];
if upload.SentHeader then begin
 inc(i);
 continue;
end;

  if upload.isUDP then begin
       if tempo-upload.lastUDPData>TIMEOUT_UDP_UPLOAD then begin
         free_upload_stuff(upload,false);
         lista_upload.delete(i);
            upload_visual_per_synch := upload;
            synchronize(termina_upload_visual); //synch  upload_visual_per_synch
         upload.Free;
      end else inc(i);
      continue;
  end;

    if tempo-upload.socket.tag>TIMEOUT_INVIO_HEADER_REPLY_UPLOAD then begin
         free_upload_stuff(upload,false);
         lista_upload.delete(i);
          if upload.should_display then begin
            upload_visual_per_synch := upload;
            synchronize(termina_upload_visual); //synch  upload_visual_per_synch
          end;
         upload.Free;
         continue;
    end;

    to_send := length(upload.out_reply_header);
    if to_send>512 then to_send := 512;

    if to_send=0 then begin //nulla da inviare? odd
         free_upload_stuff(upload,false);
         lista_upload.delete(i);
         if upload.should_display then begin
            upload_visual_per_synch := upload;
            synchronize(termina_upload_visual); //synch  upload_visual_per_synch
          end;
         upload.Free;
         continue;
    end;


      lung := TCPSocket_SendBuffer(upload.socket.socket,@upload.out_reply_header[1],to_send,er);
      if er=WSAEWOULDBLOCK then begin
       inc(i);
       continue;
      end;
      if er<>0 then begin    // errore disconnesso
         free_upload_stuff(upload,false);
         lista_upload.delete(i);
          if upload.should_display then begin
            upload_visual_per_synch := upload;
            synchronize(termina_upload_visual); //synch  upload_visual_per_synch
          end;
         upload.Free;
         continue;
      end;

     if lung<length(upload.out_reply_header) then begin //non ha inviato tutto , probabile se avevo da inviare più di 512 bytes
      delete(upload.out_reply_header,1,lung);
      inc(i);
      continue;
     end;

     upload.socket.tag := tempo;    // prossima scadenza

        upload.out_reply_header := '';
        upload.SentHeader := True; //ok header è andato...

        upload.bytes_in_buffer := 0;
except
end;
inc(i);
end; //while invio headers...senza limite bandwidth!

end;

procedure tthread_upload.drop_upload_because_of_scanning;
var
upload: Tupload;
begin

 while (lista_upload.count>0) do begin
  upload := lista_upload[lista_upload.count-1];
           free_upload_stuff(upload,true);
           lista_upload.delete(lista_upload.count-1);
            if upload.should_display then begin
             upload_visual_per_synch := upload;
             synchronize(termina_upload_visual); //synch  upload_visual_per_synch
            end;
           upload.Free;
 end;

end;

procedure tthread_upload.FlushFiles(tempo: Cardinal);
var
 i: Integer;
 upload: Tupload;
begin

i := 0;
while (i<lista_upload.count) do begin

  try

upload := lista_upload[i];

if ((not upload.SentHeader) or
    (upload.isUDP)) then begin
 inc(i);
 continue;
end;

if not FlushUpload(upload,10,KBYTE) then begin
 lista_upload.delete(i);
 if upload.should_display then begin
   upload_visual_per_synch := upload;
   synchronize(termina_upload_visual);
 end;
 upload.Free;
end else inc(i);


 except
  exit;
 end;

end;

end;

function tthread_upload.flushUpload(upload: TUpload; loops: Integer; amountPerCicle:integer): Boolean;
var
h,hi: Integer;
er: Integer;
to_send: Integer;
lung: Integer;
begin
result := True;

for h := 1 to loops do begin

     if upload.actual>=upload.endpoint+1 then begin
           Result := False;
           free_upload_stuff(upload,true);
           exit;
       end;


   to_send := amountPerCicle;
   if upload.actual+to_send>upload.endpoint+1 then to_send := (upload.endpoint+1)-upload.actual;

   if upload.bytes_in_buffer=0 then begin
     if upload.stream.position+1=upload.stream.size then exit;
         upload.bytes_in_buffer := upload.stream.read(upload.buffer_invio,to_send);
         if upload.bytes_in_buffer=0 then exit;
               if upload.is_encrypted then begin
                 for hI := 0 to upload.bytes_in_buffer-1 do begin
                  upload.buffer_invio[hI] := upload.buffer_invio[hi] xor (upload.encryption_key shr 8);
                  upload.encryption_key := (upload.buffer_invio[hI] + upload.encryption_key) * 52079 + 16826;
                 end;
               end;
   end;



         
        lung := TCPSocket_SendBuffer(upload.socket.socket,@upload.buffer_invio[0],upload.bytes_in_buffer,er);

        if er=WSAEWOULDBLOCK then exit;
        if er<>0 then begin
            Result := False;
            free_upload_stuff(upload,false);
          exit;
        end;


           inc(upload.actual,lung);
            upload.bytes_in_buffer := 0;
            upload.socket.tag := tempo;
          inc(bsentp,lung);
          inc(bsentpmega,lung);
         if cardinal(upload)=m_graphObject then GraphAddSample(Lung);


end;


end;

procedure tthread_upload.FlushFiles;
begin
 FlushHeaders(tempo);

 if upload_bandwidth=0 then FlushFiles(tempo)
  else FlushFiles(tempo,true);
end;

procedure tthread_upload.FlushFiles(tempo: Cardinal; dummy:boolean);
var
 i: Integer;
 upload: Tupload;
 tot_amount_tosend,amountpercycle: Cardinal;
 Loops: Cardinal;
begin
 if tempo-last_sent_upload<TENTHOFSEC then exit;
 last_sent_upload := tempo;
 

 tot_amount_tosend := (upload_bandwidth*KBYTE) div 10;
 if lista_upload.count>0 then amountpercycle := tot_amount_tosend div cardinal(lista_upload.count)
  else amountpercycle := tot_amount_tosend;

 if amountpercycle>512 then begin
  Loops := (amountpercycle div 512)+1;
  amountpercycle := amountpercycle div Loops;
 end else Loops := 1;


 i := 0;
while (i<lista_upload.count) do begin

  try

upload := lista_upload[i];

if ((not upload.SentHeader) or
    (upload.isUDP)) then begin
 inc(i);
 continue;
end;

if not FlushUpload(upload,loops,amountpercycle) then begin
 lista_upload.delete(i);
 if upload.should_display then begin
   upload_visual_per_synch := upload;
   synchronize(termina_upload_visual);
 end;
 upload.Free;
end else inc(i);


 except
  exit;
 end;

end;

end;



function tthread_upload.GetAltSources(evitaip: Cardinal): string;
var
i: Integer;
altern:precord_alternate;
hash_holder:precord_hash_holder_alternate;
lista_alternate: TMylist;
begin
result := '';
try
 hash_holder := find_alternate_holder(hash_sha1);
 if hash_holder=nil then exit;

 lista_alternate := tmylist.create;

 altern := hash_holder^.first_alt;
 while (altern<>nil) do begin
  if altern^.ip_user<>evitaip then lista_alternate.add(altern);
  altern := altern^.next;
 end;



if lista_alternate.count>6 then shuffle_mylist(lista_alternate,0);

for i := 0 to lista_alternate.count-1 do begin
 altern := lista_alternate[i];

       Result := result+STR_X_ALT+chr(32)+ipint_to_dotstring(altern^.ip_server)+':'+
                                    inttostr(altern^.port_server)+'|'+
                                    ipint_to_dotstring(altern^.ip_user)+':'+
                                    inttostr(altern^.port_user)+
                                    CRLF;

 if i>=5 then break;
end;

 lista_alternate.Free;
except
end;
end;

function tthread_upload.GetBinAltSources(evitaip: Cardinal): string;
var
i: Integer;
altern:precord_alternate;
hash_holder:precord_hash_holder_alternate;
lista_alternate: TMylist;
begin
result := '';
try
 hash_holder := find_alternate_holder(hash_sha1);
 if hash_holder=nil then exit;

 lista_alternate := tmylist.create;

 altern := hash_holder^.first_alt;
 while (altern<>nil) do begin
  if altern^.ip_user<>evitaip then lista_alternate.add(altern);
  altern := altern^.next;
 end;



if lista_alternate.count>6 then shuffle_mylist(lista_alternate,0);

for i := 0 to lista_alternate.count-1 do begin
 altern := lista_alternate[i];

       Result := result+int_2_dword_string(altern^.ip_server)+
                      int_2_word_string(altern^.port_server)+
                      int_2_dword_string(altern^.ip_user)+
                      int_2_word_string(altern^.port_user);

 if i>=5 then break;
end;

 lista_alternate.Free;
except
end;
end;

function tthread_upload.GetPartialSources(evitaip: Cardinal): string; //partial sono aggiunti solo quando almeno uno è stato completato! (buona affidabilità sorgente)
var
queued:precord_queued;
upload: Tupload;
i: Integer;
num: Byte;
begin
result := '';    //inviamo tanti treeroot
try
num := 0;
for i := 0 to lista_queued.count-1 do begin
queued := lista_queued[i];
if queued^.crcnomefile<>crcnomefile then continue;
if queued^.nomefile<>nomefile then continue;
if queued^.ip=evitaip then continue;

         if his_buildn>=BITTORRENTPARTIAL_BUILDSINCE then Result := result+STR_BITPART
          else Result := result+STR_X_TREE_ROOT;

               Result := result+chr(32)+bytestr_to_hexstr(e54(int_2_dword_string(queued^.server_ip)+
                                                             int_2_word_string(queued^.server_port)+
                                                             int_2_dword_string(queued^.ip)+
                                                             int_2_word_string(queued^.port)+
                                                             int_2_dword_string(queued^.ip_alt),3617))+
                                                             CRLF;
                   inc(num);
                   if num>7 then exit; //max 8
end;

                                                          //cripta
for i := 0 to lista_upload.count-1 do begin
upload := lista_upload[i];

if not upload.should_display then continue;
 if upload.crcfilename<>crcnomefile then continue;
  if upload.filename<>nomefile then continue;
   if upload.ip_user=evitaip then continue;

         if his_buildn>=BITTORRENTPARTIAL_BUILDSINCE then Result := result+STR_BITPART
          else Result := result+STR_X_TREE_ROOT;

                     Result := result+chr(32)+bytestr_to_hexstr(e54(int_2_dword_string(upload.ip_server)+
                                                             int_2_word_string(upload.port_server)+
                                                             int_2_dword_string(upload.ip_user)+
                                                             int_2_word_string(upload.port_user)+
                                                             int_2_dword_string(upload.ip_alt),3617))+
                                                             CRLF;
                   inc(num);
                   if num>7 then exit; //max 8
end;


except
end;
end;





end.
