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
Ares supernode, thread
}

unit thread_supernode;

interface

uses
  Classes,windows,blcksock,synsock,winsock,sysutils,const_supernode_commands,
  const_commands,registry,utility_ares,ares_types,ares_objects,zlib,classes2,
  keywfunc,class_cmdlist,types_supernode,const_timeouts,const_win_messages,vars_localiz,
  const_ares,helper_supernode_crypt,hashlist,
  helper_diskio;

const
 MAX_FILES_SHARED_PERUSER=750;
 MAX_FILES_SHARED_PERSUPERNODE=150000;
 MAX_USER_UDP_SEARCHES=10;
 MAX_SIZE_UDPSEARCH=200; // 10 hashes max
 MAXLENSALT=22;
 MINLENSALT=6;
 MAX_NUM_AVSUPERNODES=400;
 NUM_MAXSUPERNODES_LINKED=70;
 MAX_LINKEDRESULT_COUNT=20;
 MAX_UNREALIABLE_SUPERNODES=300;
 MAX_BOOTSTRAP_SUPERNODES=400;
 MAX_HASHHIT_SUPERNODE = 20;
 MAX_HASHHIT_SUPERNODE_PLUS10=30;

 MAX_LINKCONGESTION_TODISCONNECT       = 1000;
 MAX_LINKCONGESTION_TODROPSEARCHES     = 200;
 MAX_LINKCONGESTION_TODROPHITS         = 100;
 MAX_LINKCONGESTION_TODROPHASHSEARCHES = 300;
 MAX_LINKCONGESTION_TODROPHASHHITS     = 150;
 LINK_CONGESTION_THRESHOLD             = 50; // do not loop receive calls with this server


 LIMIT_SIZE_RELAYEDOUTBUFFER=65535;  //when localclient fills outbuffer this much is time to protect ourselves and drop this relay session
 THREASHOLD_SIZE_RELAYEDOUTBUFFER=16384; //from now on let our local user know he has to slow down sending to use data
 THRESHOLD_RELAYING_RECIPIENT_BUSY=200; //200 packets still to be sent to our local user

type
tthread_supernode = class(TThread)
  protected
   my_salt_key_str: string;
   my_key_out: Word;

   sup_unencrypted_login_key: string; // da 2953+ tiene la chiave di 128 bytes + soliti sc e ca
   sup_encrypted_login_key: string; //questo invece contiene il risultato dell'elaborazione
   sup_enc_keyto_cache: string; //da e tra cache

  server_socket_tcp: Ttcpblocksocket;

  UDP_socket:Hsocket;
  UDP_RemoteSin: TVarSin;
  UDP_Buffer: array [0..1023] of Byte;
  UDP_len_recvd: Integer;
  
  my_tcp_port: Word;
  mylocalip_dword: string[4];
  my_tcp_port_word: string[2];
  locip: Cardinal;

  user_list: TMylist;
  socket_list: TMylist;
  avSupernodes: TMylist;
  LinkedSupernodes: TMylist;
  avSupernodesTrying: TMylist;
  UnreliableSupernodes: TMylist;

    latest_cache_url_string: string; //per avere in memoria last caches da inviare subito a login client 2952+
   // buffer_udp: array [0..500] of Byte;
   // ip_dworded: array [0..3] of Byte;

   // my_udp_horizon: Cardinal; //quanti servers cercano su di me
   // len_recvd_udp: Integer; //lungezza bytes in buffer
   // cmd_udp: Byte;

    salt_global: array [0..MAXLENSALT+37] of Byte;

    buffer_ricezione,buffer_ricezione_temp: array [0..1499] of Byte; //crypt-decrypt-socket_recv_compression etc...
    bytes_in_buffer: Integer;

   // FRemoteUDPSin: TVarSin;

    tim,             // global time aka gettickcount
    last_Halfsecond, // time to check our users...
    last_5_sec,  //per expire antiflood
    last_minute,
    last_30_minutes,
    start_time: Cardinal; // ora di partenza server
    glb_lst_keywords: TMylist;   //pronti a trasferire puntatori
    byte1_ransend: Byte;           //per evitare sempre random()
    byte1_ransendchr,
    byte1_ransendchr2: string;
    in1_decrypt,in2_decrypt: Word; //per push evitiamo ripetizione passaggi
    my_fe: string;
    my_ca: Byte;
    my_sc: Word;

    out_buffer_global: string; // per non copiare tra funzioni
    GlobUser: TLocalUser; //user globale gestito da parse e process command
    content: string; // content for local command recv

   // throttle_udp: Cardinal; //lo aggiorniamo in base a orizzonte medio remoto
    rfield_title:^record_field;
    rfield_artist:^record_field;
    rfield_album:^record_field;
    rfield_category:^record_field;
    rfield_date:^record_field;
    rfield_language:^record_field;
    wanted_search: Twanted_search;

    buffer_parse_keywords: array [0..399] of Byte; //per parse keywords in add shared

     stato_supernodecache_query: Tstato_supernode_cache_query;
     cachequery_last: Cardinal;
     received_cache_str,cache_str_toflush: string;
     socket_cache: Integer;
     port_cache: Word;
     ip_cache_cardinal: Cardinal;

    supernode_prelogin: array [0..137] of Byte;
    pre_login_out_buffer: array [0..143] of Byte; // 144 bytes at max
    len_prelogin_out_buffer: Byte;

    WANTED_USER_IN_CLUSTER: Word; // 80 utenti, finche non arrivo a quella quota continuo a linkare
    WANTED_FILES_IN_CLUSTER: Cardinal; //2967
    MAX_LINKED_HSERVERS: Byte;   //variabili impostabili da cache server...


    setted_preferred_port: Boolean; //per inserire solo una sola volta porta supernode
    shared_count: Cardinal;
    
    listRelayingSockets: TMylist;

    procedure receiveUDP;
    procedure handler_udpTransfer_ping;
    procedure handler_udpTransfer_push;
    procedure handler_udpTransfer_echoport;

    procedure avSupernode_incConnects(ip: Cardinal;port:word);
    function avSuper_isUnreliable(ip: Cardinal): Boolean;
    procedure avSupernodeMarkUnrealiable(avSup:precord_availableSupernode);
    function get_crypt_cache_key(const unenc_key: string): string;
    function get_crypt_udp_key(const unenc_key: string): string;
    procedure getLocalIp; //synch
    function addAvSupernode(ip: Cardinal; port:word):precord_availableSupernode;
    function avSupernodes_GetSuitable:precord_availableSupernode;
    procedure avSupernodePutOffline(avSup:precord_availableSupernode); overload;
    procedure avSupernodePutOffline(ip: Cardinal; port:word); overload;
    function LinkedToSupernode(ip: Cardinal): Boolean;
    procedure DisconnectSupernode(sup: TSupernode; fast:boolean=false);
    procedure AvSupernodeDeal;
    function generate_supernode_loginpacket(avSup:precord_availableSupernode): string;
    procedure decrypt_supernode_packet(len:integer);
    procedure generate_new_accepted_supernode(sockt:Hsocket; ip: Cardinal);
    procedure generate_new_connected_supernode(avSup:precord_availableSupernode);
    procedure supernodesDeal;
    procedure flushSupernode(sup: TSupernode);
    procedure ReceiveSupernode(sup: TSupernode);
    procedure process_supernode_command(sup: TSupernode);
    procedure super_handler_ping(sup: TSupernode); // send one ong to him
    procedure super_handler_query(sup: TSupernode);
    procedure super_handler_queryHit(sup: TSupernode);
    procedure super_handler_queryHash(sup: TSupernode);
    procedure super_handler_queryHashHit(sup: TSupernode);
    procedure super_handler_endofsync(sup: TSupernode);
    function can_share_this_hash(ip: Cardinal; crc:word): Boolean;

    procedure pingSupernodes;
    procedure add_result_from_server(searchP:precord_local_search; ip: Cardinal);
    function enough_results_from_server(searchP:precord_local_search; ip: Cardinal): Boolean;
    procedure clear_rec_seen(list: TMylist);
    procedure remote_search(sup: Tsupernode; max_results: Byte);
    procedure decompress_supernode_command(sup: TSupernode);
    procedure parse_supernode_decompressed_stream(sup: TSupernode; buffer: Pointer; DecompSize:integer);
    procedure SupernodeDisconnectWithError(sup: TSupernode; error: Byte);
    procedure FreeRelayingSocket(aSocket:precord_relaying_socket);

    procedure gen_keys;
    procedure Continue_search(complex_back_udp: string; num_rim:integer);
    procedure parse_new_search(index: Byte; var complex: string);
    procedure parse_old_search(var Complex: string);
    function enough_keys: Boolean;
    procedure check_agent;
    procedure load_cached_supernodes;
    procedure generate_hashwordkey(var inkey: Word; sizein:integer);
    procedure decrypt_buffer(InBuff: Pointer; len: Integer; OutBuff: Pointer; var inkey:word);
    procedure encrypt_buffer(InBuff: Pointer; len: Integer; OutBuff: Pointer; var outkey:word);
    procedure gen_out_key;
    function make_search_str(complex: string): string;


    procedure log_dump(log_file: Thandlestream; const txt: string);
    procedure log_write(log_file: Thandlestream; const txt: string);
   // procedure big_dump;
   // function serialize_keys(item:precorD_file_shared): string;


    procedure init_vars1;
    procedure init_vars2;
    procedure Execute; override;
    procedure FreeHashLists;
    procedure regenerate_keys; //every 45 minutes
    procedure put_my_name;  //synch
    procedure CheckSync;       //auto load
    procedure get_reg_preferred_port;    //synch
    procedure set_reg_preferred_port;    //synch
    procedure get_user_result_string(us: Tlocaluser);
    function local_search: Byte;
    function trova_keyword_minima_search:pkeyword;
    function match_file_search(pfile:precord_file_shared; should_complex:boolean): Boolean;
   // function comp_search_kewds(list: Tnapcmdlist;kw:pkeyword): Boolean;

    procedure createsockets;
    procedure Listen;
    procedure free_sockets;
    procedure create_lists;
    procedure free_lists;
    procedure receive_users; // per tutti gli utenti
    procedure receive_user(cycle: Byte=0);
    procedure receive_sockets;

    procedure check_Halfsecond;

    procedure relayingSockets_deal;
    procedure handler_relayPacket;
    procedure handler_releayDrop;

    procedure shutdown;
    procedure check_60_second;
    procedure dropunresponsiveServeRs;
    function get_4_servers_str: string;
    procedure put_reg_slow_speed; //troppo lag...abbassiamo la nostra velocita!!

    procedure assign_result_id(us: TLocalUser);

    procedure process_command1(command: Byte);
    function d1(cont: string): string; //decrypt
    procedure accept;
    function count_clones_ip(ip: Cardinal): Word;
    procedure flush_tcp;
    procedure free_id_in_shared_list(us: TLocalUser;fast:boolean);
    procedure send_back(cmd: Byte);
    procedure send_back_user(us: TLocalUser;cmd: Byte);
    procedure handler_client_endofsearch;
    function user_da_ip(ip: Cardinal): TlocalUser;
    function user_da_ip_hash(ip: Cardinal; crc:word): TLocalUser;
    procedure evita_cloni_nick; // assegniamo altro nick ad user se ne ho già uno...
    procedure process_command2(command: Byte);
    procedure free_user_searches(conn: TLocalUser; only_exceeding:boolean = False; searchP:precord_local_search=nil; requested:boolean=false);
    procedure send_Back_EndofSearch(conn: TLocaluser; const search_id: string; reason: Byte);
    procedure parse_complex_search(complex: string);
    procedure drop_clones_logged_ip(us: Tlocaluser);

    procedure handler_login;            // client login, server login, client push req
    procedure handler_add_key_search_new;
    procedure handler_rem_shared;        //remove shared
    procedure handler_add_shared_key(nuovo:boolean);

    procedure handler_status;             // send us status and receive from us stats
    procedure handle_update_my_nick;
    procedure handler_compressed;
    procedure handler_add_hashrequest;
    procedure handler_rem_hashrequest;
    function handleR_push(usr:precord_socket_user; encrypted:boolean=true): Boolean;
    function handler_remote_relaychat_request(usr:precord_socket_user): Boolean;
    function handler_chat_push(usr:precord_socket_user; encrypted:boolean=true): Boolean;
    procedure handler_firewall_test_result;
    procedure add_hash_key(item:precord_file_shared; crc:word);
    function check_user_video: Boolean;
    procedure fill_prelogin_buffer; //ogni minuto...per non stressare ogni volta con allocazioni
    procedure test_user_firewall_condition;

    procedure check_ghost;   //ogni 60 sec
    function abcd: string;

    procedure free_user_stuff(conn: TLocalUser; fast:boolean);
  end;

   var
   
   //header_udp_ares: string='ARE';
   buffer_supernode_firstlog: array [0..5] of byte = (3,0,MSG_SUPERNODE_FIRST_LOG,3,4,5);
   str_myagent: string;
   STR_NULL_STATSTRING: string=chr(2)+CHRNULL+CHRNULL+CHRNULL+
                              chr(2)+CHRNULL+CHRNULL+CHRNULL+
                              chr(2)+CHRNULL+CHRNULL+CHRNULL;
   STR_ENDOFSYNC_PACKET: string;

implementation

uses
  ufrmmain,helper_sockets,helper_strings,helper_crypt,helper_ipfunc,helper_sorting,
  helper_mimetypes,secureHash,
  vars_global,helper_datetime,
  helper_unicode,helper_ares_nodes,const_udpTransfer;


procedure tthread_supernode.get_reg_preferred_port;    //synch
var
reg: Tregistry;
begin
reg := tregistry.create;
try
reg.openkey(areskey,true);
if reg.valueexists('Network.SupernodePort') then
 my_tcp_port := reg.readinteger('Network.SupernodePort') else my_tcp_port := 0;
reg.closekey;
except
end;
reg.destroy;
end;

procedure tthread_supernode.set_reg_preferred_port;    //synch
var
reg: Tregistry;
begin
try
reg := tregistry.create;
with reg do begin
 openkey(areskey,true);
  if my_tcp_port>=5000 then writeinteger('Network.SupernodePort',my_tcp_port);
 closekey;
 destroy;
end;


except
end;
setted_preferred_port := True;
end;


procedure tthread_supernode.createsockets;
var
er: Integer;
sin: TVarSin;
//x: Integer;
begin
try

synchronize(get_reg_preferred_port);
if my_tcp_port<5000 then my_tcp_port := random(60000)+5010;

server_socket_tcp := ttcpblocksocket.create(false);


        while true do begin
         Listen;
         er := server_socket_tcp.lasterror;
          if er<>0 then begin
          server_socket_tcp.closesocket;
          sleep(50);
           my_tcp_port := random(60000)+5010;
           if terminated then exit;
          end else break;
        end;

      my_tcp_port_word := int_2_word_String(my_tcp_port);
      global_supernode_port := my_tcp_port;

 FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(my_tcp_port);
 Sin.sin_addr.s_addr := 0;
 UDP_socket := synsock.socket(PF_INET,integer(SOCK_DGRAM),IPPROTO_UDP);
 synsock.Bind(UDP_socket,@Sin,SizeOfVarSin(Sin));

except
end;
end;

procedure tthread_supernode.Listen;
begin
server_socket_tcp.createsocket;
server_socket_tcp.bind(cAnyHost,inttostr(my_tcp_port));
server_socket_tcp.listen(64);
end;

procedure tthread_supernode.free_sockets;
begin
try
server_socket_tcp.Free;
server_socket_tcp := nil;
except
end;

try
TCPSocket_Free(socket_cache);
TCPSocket_Free(UDP_socket);
except
end;
end;


procedure tthread_supernode.create_lists;
begin
socket_list := tmylist.create;
user_list := tmylist.create;
glb_lst_keywords := tmylist.create;
avSupernodes := tmylist.create;
LinkedSupernodes := tmylist.create;
avSupernodesTrying := tmylist.create;
UnreliableSupernodes := tmylist.create;

new(rfield_title);
new(rfield_artist);
new(rfield_album);
new(rfield_category);
new(rfield_date);
new(rfield_language);

InitSupernodeHashLists;
end;


procedure tthread_supernode.free_user_stuff(conn: TLocalUser; fast:boolean);
var
 aSocket:precord_relaying_socket;
 ind: Integer;
begin

try
    free_id_in_shared_list(conn,fast);
except
end;

 try
  free_user_searches(conn);
 except
 end;

  if conn.supportDirectChat then begin
     if conn.relayingSockets<>nil then begin
      while (conn.relayingSockets.count>0) do begin
       aSocket := conn.relayingSockets[conn.relayingSockets.count-1];
                conn.relayingSockets.delete(conn.relayingSockets.count-1);

      if not fast then begin
       ind := listRelayingSockets.indexof(aSocket);
       if ind<>-1 then listRelayingSockets.delete(ind);
      end;

       TCPSocket_Free(aSocket^.Socket);
         aSocket^.in_buffer := '';
         aSocket^.out_buffer := '';
       FreeMem(aSocket,sizeof(record_relaying_socket));
      end;
      conn.relayingSockets.Free;
     end;
  end;

end;

procedure tthread_supernode.avSupernodeMarkUnrealiable(avSup:precord_availableSupernode);
var
ind: Integer;
i: Integer;
ip: Cardinal;
rec_seen:precord_ip_seen;
begin
 TCPSocket_free(avSup^.socket);
 avSup^.Socket := INVALID_SOCKET;
 avSup^.inUse := False;
 ip := avSup^.ip;
 avSup.buff := '';

 ind := avSupernodes.indexof(avSup);
 if ind<>-1 then begin
  avSupernodes.delete(ind);
  FreeMem(avSup,sizeof(record_availableSupernode));
 end else avSup^.lastAttempt := tim;

 for i := 0 to UnreliableSupernodes.count-1 do begin
    rec_seen := UnreliableSupernodes[i];
    if rec_seen^.ip=ip then exit;
 end;

 while (UnreliableSupernodes.count>MAX_UNREALIABLE_SUPERNODES) do begin
    rec_seen := UnreliableSupernodes[0];
              UnreliableSupernodes.delete(0);
    FreeMem(rec_seen,sizeof(record_ip_seen));
 end;

 rec_seen := AllocMem(sizeof(record_ip_seen));
  rec_seen^.ip := ip;
  rec_seen^.seen := tim;
  UnReliableSupernodes.add(rec_seen);
end;

function tthread_supernode.avSuper_isUnreliable(ip: Cardinal): Boolean;
var
i: Integer;
rec_seen:precord_ip_seen;
begin
 Result := False;

  for i := 0 to UnreliableSupernodes.count-1 do begin
    rec_seen := UnreliableSupernodes[i];
    if rec_seen^.ip=ip then begin
     Result := True;
     exit;
    end;
 end;

end;

procedure tthread_supernode.avSupernode_incConnects(ip: Cardinal; port:word);
var
i: Integer;
avSuper:precord_availableSupernode;
begin

for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper^.ip=ip then begin
   inc(avSuper^.connects);
   exit;
  end;
 end;

 avSuper := addavSupernode(ip,port);
 if avSuper=nil then exit;
 avSuper^.connects := 1;
end;

function tthread_supernode.addAvSupernode(ip: Cardinal; port:word):precord_availableSupernode;
var
i: Integer;
avSuper:precord_availableSupernode;
begin
result := nil;
 if avSuper_isUnreliable(ip) then exit;
 if isAntiP2PIP(ip) then exit;

 for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper^.ip=ip then exit;
 end;

 if avSupernodes.count>MAX_NUM_AVSUPERNODES then begin
  avSupernodes.sort(sort_worstSupernodeFirst);
  i := 0;
  while ((avSupernodes.count>MAX_NUM_AVSUPERNODES) and (i<avSupernodes.count)) do begin
    avSuper := avSupernodes[i];
    if avSuper^.inUse then begin
     inc(i);
     continue;
    end;

    if avSupernodes.count<(MAX_NUM_AVSUPERNODES*2) then begin
     if avSuper^.attempts=0 then begin //try first...
      inc(i);
      continue;
     end;
     if avSuper^.connects>0 then begin
      inc(i);
      continue;
     end;
    end;


    avSupernodes.delete(i);
    FreeMem(avSuper,sizeof(record_availableSupernode));
  end;
 end;

 avSuper := AllocMem(sizeof(record_availableSupernode));

  avSuper^.attempts := 0;
  avSuper^.connects := 0;
  avSuper^.lastAttempt := 0;
  avSuper^.ip := ip;
  avSuper^.port := port;
  avSuper^.inUse := False;
  avSuper^.socket := INVALID_SOCKET;
  avSuper^.tick := 0;
  avSuper^.buff := '';

   avsupernodes.add(avSuper);

   Result := avSuper;
end;

procedure tthread_supernode.avSupernodePutOffline(avSup:precord_availableSupernode);
begin
avSup^.lastAttempt := tim;
avSup^.inUse := False;
 TCPSocket_free(avSup^.socket);
 avSup^.Socket := INVALID_SOCKET;
 avSup^.buff := '';
end;



function tthread_supernode.generate_supernode_loginpacket(avSup:precord_availableSupernode): string;
var
his_unenc_key,his_enc_key: string;
begin
   SetLength(his_unenc_key,128);
   move(buffeR_ricezione[4],his_unenc_key[1],128); //skip first 4 bytes

   his_enc_key := get_crypt_udp_key(his_unenc_key);

   move(buffer_ricezione[132],avSup^.sc,2);
   avSup^.ca := buffer_ricezione[134];

   Result := his_enc_key+
           int_2_word_string(my_tcp_port)+
           int_2_word_string(user_list.count)+
           int_2_word_string(LinkedSupernodes.count)+
           int_2_word_String(my_sc)+
           chr(my_ca)+
           sup_unencrypted_login_key;

   Result := int_2_word_string(length(result))+
           chr(MSG_SUPERNODE_SECOND_LOG)+
           result;
end;

procedure tthread_supernode.decrypt_supernode_packet(len:integer);
var
b: Word;
hi: Integer;
begin
 b := a1(my_sc,buffer_ricezione[0],ff[my_ca]); //get his B key

 move(buffer_ricezione[2],buffer_ricezione_temp[0],len-2); //skippiamo i primi due

 for hI := 0 to len-3 do begin
  buffer_ricezione[hI] := buffer_ricezione_temp[hI] xor (b shr 8);
  b := (buffer_ricezione_temp[hI]+b) * 52845 + 22719;
 end;

end;

procedure tthread_supernode.generate_new_accepted_supernode(sockt:Hsocket; ip: Cardinal);
var
supernode: TSupernode;
his_unenc_key,str: string;
i: Integer;
b: Word;
begin

supernode := TSupernode.create;
 supernode.ConnType := LT_ACCEPTED;
 supernode.socket := sockt;
 supernode.ip := ip;
 supernode.logtime := tim;

 move(buffer_ricezione[20],supernode.port,2);
 move(buffer_ricezione[26],supernode.sc,2);
 supernode.ca := buffer_ricezione[28];


 SetLength(his_unenc_key,128);
 move(buffer_ricezione[29],his_unenc_key[1],128);


 str := get_crypt_udp_key(his_unenc_key)+
      int_2_word_string(vars_global.buildno);  //added since 2953+

  b := a1(supernode.sc,byte1_ransend,ff[supernode.ca]);
  for i := 1 to Length(str) do begin
        str[i] := char(byte(str[i]) xor (b shr 8));
        b := (byte(str[i]) + b) * 52845 + 22719;
  end;

  str := byte1_ransendchr+
       byte1_ransendchr2+
       str;


  LinkedSupernodes.add(supernode);

   supernode.outBuffer.add(int_2_word_string(length(str))+
                           chr(MSG_SERVER_LOGIN_OK)+
                           str);

   supernode.outBuffer.add(STR_ENDOFSYNC_PACKET);


end;

procedure tthread_supernode.generate_new_connected_supernode(avSup:precord_availableSupernode);
var
supernode: TSupernode;
begin
supernode := TSupernode.create;
 supernode.ConnType := LT_CONNECTED;
 supernode.socket := avSup^.socket;
 supernode.ip := avSup^.ip;
 supernode.port := avSup^.port;
 supernode.sc := avSup^.sc;
 supernode.ca := avSup^.ca;
 supernode.logtime := tim;

 
supernode.outBuffer.add(STR_ENDOFSYNC_PACKET);
                        
   LinkedSupernodes.add(supernode);
end;

procedure tthread_supernode.supernodesDeal;
var
sup: TSupernode;
i: Integer;
begin

 i := 0;
 while (i<LinkedSupernodes.count) do begin
   sup := LinkedSupernodes[i];

   if (i mod 10)=5 then checksync;

   if sup.state=DISCONNECTED then begin
     LinkedSupernodes.delete(i);
      AvSupernodePutOffline(sup.ip,sup.port);
      DisconnectSupernode(sup);
     sup.Free;
     continue;
   end;

   if sup.state=DISCONNECTING then begin  // flush errorcode
     flushSupernode(sup);
     if tim-sup.tick>10000 then sup.state := DISCONNECTED;
     inc(i);
     continue;
   end;

   if sup.outBuffer.count>MAX_LINKCONGESTION_TODISCONNECT then begin
    SupernodeDisconnectWithError(sup,ERROR_FLUSH_OVERFLOW);
    inc(i);
    continue;
   end;

   flushSupernode(sup);
   receiveSupernode(sup);

   inc(i);
 end;

end;

procedure Tthread_Supernode.flushSupernode(sup: TSupernode);
var
er,loops,len: Integer;
begin
try

if sup.state<>DISCONNECTING then
 if sup.outBuffer.count>100 then
  if tim-sup.tick>45000 then begin
   SupernodeDisconnectWithError(sup,ERROR_FLUSHQUEUE_OVERFLOW);
   exit;
  end;
  

 loops := 0;

 while (sup.outBuffer.count>0) do begin

   // TODO implement recycle factory class to reduce heap fragmentation
   len := length(sup.outbuffer.Strings[0]);
   if len>0 then TCPSocket_SendBuffer(sup.socket,PChar(sup.outbuffer.Strings[0]),len,er)
    else begin
      sup.outbuffer.Delete(0);
      continue;
    end;

   if er=WSAEWOULDBLOCK then break;
   if er<>0 then begin
    sup.state := DISCONNECTED;
    break;
   end;
   
   sup.outbuffer.Delete(0);
   sup.tick := tim;
   
   inc(loops);
   if loops>10 then break;
 end;

except
end;
end;

procedure tthread_supernode.SupernodeDisconnectWithError(sup: TSupernode; error: Byte);
begin
 sup.tick := tim;
 sup.outBuffer.clear;
 sup.outBuffer.add(chr(1)+chr(0)+
                   chr(MSG_LINKED_BYE_PACKET_100)+
                   chr(error));
 sup.state := DISCONNECTING;
end;

procedure tthreaD_supernode.receiveSupernode(sup: TSupernode);
var
len,er,loops: Integer;
len_wanted: Word;
begin

 loops := 0;
 while (loops<10) do begin
    if ((sup.state=DISCONNECTED) or (sup.state=DISCONNECTING)) then exit;

     if not TCPSocket_CanRead(sup.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then sup.state := DISCONNECTED;
      exit;
     end;

    if sup.bytes_in_header<3 then begin
        len := TCPSocket_RecvBuffer(sup.socket,@sup.header_in[sup.bytes_in_header],3-sup.bytes_in_header,er);
        if er=WSAEWOULDBLOCK then break;
        if er<>0 then begin
         sup.state := DISCONNECTED;
         exit;
        end;
        inc(sup.bytes_in_header,len);
        if sup.bytes_in_header>3 then begin  //wtf?
         SupernodeDisconnectWithError(sup,ERROR_NETWORKISSUE);
         exit;
        end;
     sup.tick := tim;
     inc(loops);
     continue;
    end;

    move(sup.header_in[0],len_wanted,2);

    byteS_in_buffer := length(sup.inBuffer);

    if bytes_in_buffer=len_wanted then begin //empty payload...
      process_supernode_command(sup);

     // if sup.outBuffer.count>LINK_CONGESTION_THRESHOLD then break;

     inc(loops);
     sup.bytes_in_headeR := 0;
     sup.inBuffer := '';
      continue;
    end;


    if len_wanted>1024 then begin  // command is too big
     SupernodeDisconnectWithError(sup,ERROR_PAYLOADBIG);
     exit;
    end;

    len := TCPSocket_RecvBuffer(sup.socket,@buffer_ricezione[0],len_wanted-bytes_in_buffer,er);
    if er=WSAEWOULDBLOCK then break;
    if er<>0 then begin
     sup.state := DISCONNECTED;
     exit;
    end;
    sup.tick := tim;

    if len+bytes_in_buffer=len_wanted then begin //enough

      if bytes_in_buffer>0 then begin
       move(sup.inbuffer[1],buffer_ricezione_temp[0],bytes_in_buffer);
       move(buffer_ricezione[0],buffer_ricezione_temp[bytes_in_buffer],len);
       move(buffer_ricezione_temp[0],buffer_ricezione[0],bytes_in_buffer+len);
      end;
      
            bytes_in_buffer := len_wanted;
            process_supernode_command(sup);
            
             if ((sup.state=DISCONNECTED) or (sup.state=DISCONNECTING)) then exit;

              //if sup.outBuffer.count>LINK_CONGESTION_THRESHOLD then break;
              sup.bytes_in_headeR := 0;
              sup.inBuffer := '';

    end else begin
     SetLength(sup.inBuffer,bytes_in_buffer+len);
     move(buffer_ricezione[0],sup.InBuffer[byteS_in_buffer+1],len);
    end;

    inc(loops);
 end;


end;

procedure tthread_supernode.parse_supernode_decompressed_stream(sup: TSupernode; buffer: Pointer; DecompSize:integer);
var
offset,loops: Integer;
len_payload: Word;
begin

try

offset := 0;
loops := 0;

while (true) do begin
 if offset+3>=Decompsize then break;

 move(pbytearray(buffer)[offset],len_payload,2);

   if len_payload<=sizeof(buffer_ricezione) then begin  //massimo compress da 1 k!

     if offset+3+len_payload<=DecompSize then begin
      move(len_payload,sup.header_in[0],2);
      sup.header_in[2] := pbytearray(buffer)[offset+2];
      move(pbytearray(buffer)[offset+3],buffer_ricezione[0],len_payload);

      bytes_in_buffer := len_payload;

      try
       process_supernode_command(sup);
      except
       exit;
      end;
      
       if sup.state=DISCONNECTED then exit
        else
         if sup.state=DISCONNECTING then exit;

       inc(offset,len_payload+3);

       inc(loops);
       if (loops mod 3)=0 then checksync;
     end else break;

   end else begin
    SupernodeDisconnectWithError(sup,ERROR_DECOMPRESSED_PACKETBIG);
    break;
   end;

 end;

except
end;

end;

procedure tthread_supernode.decompress_supernode_command(sup: TSupernode);
var
buffer: Pointer;
decompSize: Integer;
begin
try
if not ZDecompress(@buffer_ricezione[0],bytes_in_buffer,buffer,DecompSize) then begin
 SupernodeDisconnectWithError(sup,ERROR_DECOMPRESSION_ERROR);
 exit;
end;

 if DecompSize>300 then checksync;

    try
     parse_supernode_decompressed_stream(sup,buffer,DecompSize);
    except
    end;

 FreeMem(buffer,Decompsize);
except
 SupernodeDisconnectWithError(sup,ERROR_DECOMPRESSION_ERROR);
end;

end;

procedure tthread_supernode.process_supernode_command(sup: TSupernode);
var
b: Word;
i: Integer;
begin
if sup.header_in[2]=MSG_SERVER_COMPRESSED then begin
 decompress_supernode_command(sup);
 exit;
end;

if sup.header_in[2]>=100 then dec(sup.header_in[2],100) else begin
   b := a1(my_sc,buffer_ricezione[0],ff[my_ca]);
   dec(bytes_in_buffer,2);

   move(buffer_ricezione[2],buffer_ricezione_temp[0],bytes_in_buffer);
    for i := 0 to bytes_in_buffer-1 do begin
       buffer_ricezione[I] := buffer_ricezione_temp[I] xor (b shr 8);
       b := (buffer_ricezione_temp[I] + b) * 52845 + 22719;
    end;
end;


 case sup.header_in[2] of
  //MSG_LINKED_PING_100:super_handler_ping(sup);
  MSG_LINKED_PING:super_handler_ping(sup);
  MSG_LINKED_QUERY:super_handler_query(sup);
  MSG_LINKED_QUERY_HIT:super_handler_queryhit(sup);
  MSG_LINKED_QUERYHASH:super_handler_queryHash(sup);
  MSG_LINKED_QUERYHASH_HIT:super_handler_queryhashhit(sup);
  MSG_LINKED_ENDOFSYNCH:super_handler_endofsync(sup);
  MSG_LINKED_BYE_PACKET:sup.state := DISCONNECTED; //TODO ERROR HANDLING HERE
 end;


end;


procedure tthread_supernode.super_handler_endofsync(sup: TSupernode);
begin
if sup.state=SYNCHED then exit;

if bytes_in_buffer<5 then begin
 SupernodeDisconnectWithError(sup,ERROR_SYNC_NOBUILDERROR);
exit;
end;

move(buffer_ricezione[2],sup.build_no,2);
if sup.build_no<2991 then begin
 SupernodeDisconnectWithError(sup,ERROR_SYNC_OLDBUILDERROR);
 exit;
end;

sup.state := SYNCHED;


avSupernode_incConnects(sup.ip,sup.port);
end;

procedure tthread_supernode.super_handler_queryHash(sup: TSupernode);
var
client_resultId,crcsha1: Word;
phas:phash;
us: TLocalUser;
client_resultIDs,strHash,str: string;
i: Integer;
item:phashitem;
begin
if bytes_in_buffer<23 then exit; //client id + 20 byte hash + 1 tipo has
if sup.state<>SYNCHED then exit;
if sup.outBuffer.count>=MAX_LINKCONGESTION_TODROPHASHHITS then exit;

move(buffer_ricezione[0],client_Resultid,2);


  //is_md4 := (buffer_ricezione[22]=1);
  if buffer_ricezione[22]=1 then exit; //old versions

  move(buffer_ricezione[2],hash_generale_sha1[0],20);
  move(hash_generale_sha1[2],crcsha1,2);

  phas := hashList_FindHashkey(crcsha1); //perform immediatly our local hash search
  if phas=nil then exit;

        SetLength(client_resultIDs,2);
        move(client_Resultid,client_resultIDs[1],2); //ripetiamo una sola volta
         SetLength(strHash,20);
         move(hash_generale_sha1[0],strHash[1],20); //stringa hash contenente sha1...eventualmente...

         i := 0;
         item := phas^.firstitem;
         while (item<>nil) do begin
          us := item^.share^.user;  //utente nostro ha il file!     invia risultato per questo id a server

           str := client_resultids+
                us.result_hash_str+   //dati utente che ha file da noi
                strHash+
                us.his_local_ip;
                
                        sup.outbuffer.add(int_2_word_string(length(str))+
                                         chr(MSG_LINKED_QUERYHASH_HIT_100)+
                                         str);

                inc(i);
              if i>=MAX_HASHHIT_SUPERNODE then exit; // not too many!!
             item := item^.next;
           end;
end;

procedure tthread_supernode.super_handler_queryHit(sup: TSupernode);
var
us: TLocalUser;
tresult_id: Word;
found: Boolean;
i: Integer;
searchP:precord_local_search;
begin
if bytes_in_buffer<30 then exit;
if bytes_in_buffer>700 then exit;
if sup.state<>SYNCHED then exit;

try
move(buffer_ricezione[0],tresult_id,2);

if tresult_id>high(db_result_ids.bkt) then exit;
if db_result_ids.bkt[tresult_id]=nil then exit; //non ho l'utente richiedente

 us := db_result_ids.bkt[tresult_id];

  if us.searches=nil then exit;

  searchP := nil;
  found := False;
  for i := 0 to us.searches.count-1 do begin
   searchP := us.searches[i];
   if comparemem(@searchP^.search_id,@buffer_ricezione[2],2) then begin  //searchid
    found := True;
    break;
   end;
  end;
  if not found then exit;

  if enough_results_from_server(searchP,sup.ip) then exit; // MAX_LINKEDRESULT_COUNT/each
  add_result_from_server(searchP,sup.ip);

   checksync;

     SetLength(out_buffer_global,5+bytes_in_buffer);
      out_buffer_global[1] := CHRNULL;  //result key not hash
      move(searchP^.search_id,out_buffer_global[2],2);
      move(sup.ip,out_buffer_global[4],4);
      move(sup.port,out_buffer_global[8],2);
      move(buffer_ricezione[4],out_buffer_global[10],bytes_in_buffer-4);

     send_back_user(us,MSG_SERVER_SEARCH_RESULT);

except
end;
end;

function tthread_supernode.enough_results_from_server(searchP:precord_local_search; ip: Cardinal): Boolean;
var
i: Integer;
reC_ip:precord_ip_seen;
begin
result := False;
if searchP.ips=nil then exit;

for i := 0 to searchP.ips.count-1 do begin
  rec_ip := searchP.ips[i];
  if rec_ip.ip=ip then begin
   Result := (rec_ip^.seen>=MAX_LINKEDRESULT_COUNT);
   exit;
  end;
end;

end;

procedure tthread_supernode.add_result_from_server(searchP:precord_local_search; ip: Cardinal);
var
i: Integer;
reC_ip:precord_ip_seen;
begin
if searchP.ips=nil then searchP.ips := tmylist.Create;



for i := 0 to searchP.ips.count-1 do begin
  rec_ip := searchP.ips[i];
  if rec_ip^.ip=ip then begin
   inc(rec_ip^.seen);
   exit;
  end;
end;

rec_ip := AllocMem(sizeof(record_ip_seen));
 rec_ip^.ip := ip;
 rec_ip^.seen := 1;
  searchP^.ips.add(rec_ip);

end;

procedure tthread_supernode.clear_rec_seen(list: TMylist);
var
rec_ip:precord_ip_seen;
begin
if list=nil then exit;

 while (list.count>0) do begin
  rec_ip := list[list.count-1];
    list.delete(list.count-1);
  FreeMem(rec_ip,sizeof(record_ip_seen));
 end;
 
 list.Free;
end;

procedure tthread_supernode.super_handler_query(sup: TSupernode);
var
complex: string;
begin
if bytes_in_buffer<10 then exit;
if bytes_in_buffer>255 then exit;
if sup.state<>SYNCHED then exit;
if sup.outBuffer.count>=MAX_LINKCONGESTION_TODROPHITS then exit;

 wanted_search.clear;

wanted_search.amime := buffer_ricezione[5]; //tipo diretto
if wanted_search.amime>5 then wanted_search.amime := ARES_MIMESRC_ALL255;

 move(buffer_ricezione[0],wanted_search.search_id[0],2);
 move(buffer_ricezione[2],wanted_search.client_id[0],2);

wanted_search.strict := True;
complex := '';

 parse_new_search(6,complex);

 if not enough_keys then exit;

 if wanted_search.strict then parse_complex_search(complex);

 remote_search(sup,buffer_ricezione[4]);

end;

procedure tthread_supernode.remote_search(sup: Tsupernode; max_results: Byte);
var
kw_min:PKeyword;
p:PKeywordItem;
first_part_result: string;

str: string;
should_complex: Boolean;

sh:precord_file_shared;
us: Tlocaluser;
sync: Integer;
begin

kw_min := trova_keyword_minima_search;
if kw_min=nil then exit;

p := kw_min^.firstitem;
if p=nil then exit;

SetLength(first_part_result,4);
 move(wanted_search.client_id[0],first_part_result[1],2);
 move(wanted_search.search_id[0],first_part_result[3],2);

sync := 0;

should_complex := ((wanted_search.sizecomp<>0) or
                 (wanted_search.param1comp<>0) or
                 (wanted_search.param3comp<>0));


if max_results>MAX_LINKEDRESULT_COUNT then max_results := MAX_LINKEDRESULT_COUNT;

if ((wanted_search.lista_helper_result.count>1) or
               (wanted_search.strict) or
               (wanted_search.amime<=5)) then begin //serve controllo campi, avevo più di una keyword da trovare?
 while p<>nil do begin
          sh := p^.share;
          if not match_file_search(sh,should_complex) then begin
              inc(sync);
              if (sync mod 100)=30 then checksync;
           p := p^.next;
           continue;
          end;
            us := sh^.user;
                  str := first_part_result+
                       us.result_str+
                       sh^.serialize;
                         sup.outBuffer.add(int_2_word_string(length(str))+
                                           chr(MSG_LINKED_QUERY_HIT_100)+
                                           str);

                            dec(max_results);
                            if max_results=0 then exit;

   //proseguiamo a prossima keyword?
  p := p^.next;
 end;

end else begin  //se ho solo una keyword e non ho complex
 while p<>nil do begin
          sh := p^.share;
          us := sh^.user;
                  str := first_part_result+
                       us.result_str+
                       sh^.serialize;
                          sup.outBuffer.add(int_2_word_string(length(str))+
                                            chr(MSG_LINKED_QUERY_HIT_100)+
                                            str);

                            dec(max_results);
                            if max_results=0 then exit;
  p := p^.next;
 end;
end;  //fine se non ho complex
end;

procedure tthread_supernode.super_handler_ping(sup: TSupernode);
var
posiz: Word;
ip: Cardinal;
port: Word;
added: Byte;
begin
if bytes_in_buffer<11 then exit;
if sup.state<>SYNCHED then exit;

  //int_2_word_string(User_list.count)+       //numero reale utenti non connessioni
  //        int_2_dword_string(0)+
  //        int_2_dword_string(0)+
  //        chr(LinkedSupernodes.count)+
  //        get_4_servers_str;
//if avSupernodes.count>MAX_NUM_AVSUPERNODES+20 then exit;
 posiz := 0;
 move(buffer_ricezione[posiz],sup.users,2);

try
added := 0;
posiz := 11;
while (true) do begin
 if posiz+6>bytes_in_buffer then break;

  move(buffer_ricezione[posiz],ip,4);
  move(buffer_ricezione[posiz+4],port,2);

      addAvSupernode(ip,port);

 //if avSupernodes.count>=MAX_NUM_AVSUPERNODES-50 then exit; //just one in this case

 inc(posiz,6);

 inc(added);
 if added>1 then break;
end;

except
end;
end;

procedure tthread_supernode.pingSupernodes;
var
i: Integer;
sup: TSupernode;
str: string;
begin

     str := int_2_word_string(User_list.count)+       //numero reale utenti non connessioni
          int_2_dword_string(0)+
          int_2_dword_string(0)+
          chr(LinkedSupernodes.count)+
          get_4_servers_str;

     str := int_2_word_string(length(str))+
          chr(MSG_LINKED_PING_100)+
          str;

 for i := 0 to LinkedSupernodes.count-1 do begin
  sup := LinkedSupernodes[i];
   if sup.state<>SYNCHED then continue;
   sup.outBuffer.add(str);
 end;

end;


procedure tthread_supernode.AvSupernodeDeal;   //
var
 i,er,len: Integer;
 avSup:precord_availableSupernode;
begin

if LinkedSupernodes.count<NUM_MAXSUPERNODES_LINKED then begin

 for i := 0 to 7 do begin
  if avSupernodesTrying.count<8 then begin
    avSup := avSupernodes_GetSuitable;
    if avSup<>nil then begin
     avSup^.socket := TCPSocket_Create;
     TCPSocket_Block(avSup^.socket,false);
     avSup^.tick := tim;
     avsup^.state := CONNECTING;
     TCPSocket_Connect(avSup^.socket,ipint_to_dotstring(avSup^.ip),inttostr(avSup^.port),er);
     avSupernodesTrying.add(avSup);
    end else break;
  end else break;
 end;
 
end;

 i := 0;
 while (i<avSupernodesTrying.count) do begin
  avSup := avSupernodesTrying[i];

    if tim-avSup^.tick>15000 then begin
      avSupernodesTrying.delete(i);
      avSupernodePutOffline(avSup);
      continue;
    end;


    case avSup^.state of

    
         CONNECTING:begin
                        if not TCPSocket_CanWrite(avSup^.socket,0,er) then begin
                         if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                           avSupernodesTrying.delete(i);
                           avSupernodePutOffline(avSup);
                         end else inc(i);
                         continue;
                        end;

                        TCPSocket_SendBuffer(avSup^.socket,@buffer_supernode_firstlog[0],sizeof(buffer_supernode_firstlog),er);
                        if er=WSAEWOULDBLOCK then begin
                         inc(i);
                         continue;
                        end;
                        if er<>0 then begin
                           avSupernodesTrying.delete(i);
                           avSupernodePutOffline(avSup);
                           continue;
                        end;
                        avSup^.tick := tim;
                        avSup^.state := RECEIVING_FIRSTKEY_HEADER;
                    end;


         RECEIVING_FIRSTKEY_HEADER:begin
                            if not TCPSocket_CanRead(avSup^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              avSupernodesTrying.delete(i);
                              avSupernodeMarkUnrealiable(avSup);
                             end else inc(i);
                             continue;
                            end;

                            len := TCPSocket_RecvBuffer(avSup^.socket,@buffer_ricezione[0],3,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                             avSupernodesTrying.delete(i);
                              avSupernodeMarkUnrealiable(avSup);
                              continue;
                            end;
                            if len<>3 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            if buffer_ricezione[2]<>MSG_SERVER_PRELOGIN_OK_NEWNET_LATEST then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            move(buffer_ricezione[0],avSup^.len_payload,2);
                            if ((avSup^.len_payload>180) or (avsup^.len_payload<135)) then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            avSup^.tick := tim;
                            avSup.state := RECEIVING_FIRSTKEY_PAYLOAD;
                          end;


         RECEIVING_FIRSTKEY_PAYLOAD:begin
                            if not TCPSocket_CanRead(avSup^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                             end else inc(i);
                             continue;
                            end;
                            len := TCPSocket_RecvBuffer(avSup^.socket,@buffer_ricezione[0],avsup^.len_payload,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            if len<>avSup^.len_payload then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            avSup^.tick := tim;
                            avSup^.state := FLUSHING_LOGINREQ;
                            avsup^.buff := generate_supernode_loginpacket(avSup);
                          end;


         FLUSHING_LOGINREQ:begin
                             if not TCPSocket_CanWrite(avSup^.socket,0,er) then begin
                              if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                               avSupernodesTrying.delete(i);
                               avSupernodePutOffline(avSup);
                              end else inc(i);
                              continue;
                             end;
                             TCPSocket_SendBuffer(avSup^.socket,@avSup^.buff[1],length(avSup^.buff),er);
                             if er=WSAEWOULDBLOCK then begin
                              inc(i);
                              continue;
                             end;
                             if er<>0 then begin
                               avSupernodesTrying.delete(i);
                               avSupernodePutOffline(avSup);
                               continue;
                             end;
                             avSup^.tick := tim;
                             avSup^.state := RECEIVING_LOGINREPLY_HEADER;
                         end;


         RECEIVING_LOGINREPLY_HEADER:begin
                            if not TCPSocket_CanRead(avSup^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                             end else inc(i);
                             continue;
                            end;

                            len := TCPSocket_RecvBuffer(avSup^.socket,@buffer_ricezione[0],3,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            if len<>3 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            if buffer_ricezione[2]<>MSG_SERVER_LOGIN_OK then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            move(buffer_ricezione[0],avSup^.len_payload,2);
                            if avSup^.len_Payload>100 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            avsup^.tick := tim;
                            avSup^.state := RECEIVING_LOGINREPLY_PAYLOAD;
                         end;


         RECEIVING_LOGINREPLY_PAYLOAD:begin
                            if not TCPSocket_CanRead(avSup^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                             end else inc(i);
                             continue;
                            end;
                            len := TCPSocket_RecvBuffer(avSup^.socket,@buffer_ricezione[0],avsup^.len_payload,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;
                            if len<>avSup^.len_payload then begin
                              avSupernodesTrying.delete(i);
                              avSupernodePutOffline(avSup);
                              continue;
                            end;

                            

                            if linkedToSupernode(avSup^.ip) then begin //TODO add BYE Packet here
                             avSupernodesTrying.delete(i);
                             avSupernodePutOffline(avSup);
                             continue;
                            end;

                             avSup^.tick := tim;
                             decrypt_supernode_packet(len);

                              if not CompareMem(@buffer_ricezione[0],@sup_encrypted_login_key[1],length(sup_encrypted_login_key)) then begin
                               avSupernodesTrying.delete(i);
                               avSupernodePutOffline(avSup);
                               continue;
                              end else begin

                               generate_new_connected_supernode(avSup);

                                avSupernodesTrying.delete(i);
                                avSup^.socket := INVALID_SOCKET;
                               continue;
                              end;
                         end;

    end;

  inc(i);
 end;
end;

procedure tthread_supernode.avSupernodePutOffline(ip: Cardinal; port:word);
var
i: Integer;
avSuper:precord_AvailableSupernode;
begin

 for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper^.ip=ip then
   if avSuper^.port=port then begin
    avSuper^.lastAttempt := tim;
    avSuper^.inUse := False;
    TCPSocket_free(avSuper^.socket);
    avsuper^.Socket := INVALID_SOCKET;
    avsuper^.buff := '';
    break;
   end;
  end;


end;

procedure tthread_supernode.DisconnectSupernode(sup: TSupernode; fast:boolean=false);
var
ind: Integer;
begin
 TCPSocket_Free(sup.socket);
 sup.socket := INVALID_SOCKET;

 if not fast then begin
  avSupernodePutOffline(sup.ip,sup.port);
   ind := LinkedSupernodes.indexof(sup);
   if ind<>-1 then LinkedSupernodes.delete(ind);
 end;

end;

function tthread_supernode.LinkedToSupernode(ip: Cardinal): Boolean;
var
i: Integer;
sup: TSupernode;
begin
 Result := False;

  for i := 0 to LinkedSupernodes.count-1 do begin
    sup := LinkedSupernodes[i];
    if sup.ip=ip then begin
      Result := True;
      exit;
     end;
  end;

end;

function tthread_supernode.avSupernodes_GetSuitable:precord_availableSupernode;
var
i: Integer;
avSuper:precord_AvailableSupernode;
min_interval: Cardinal;
begin
 Result := nil;
 min_interval := 10*MINUTE;

 avSupernodes.sort(sort_BestSupernodeFirst);

 for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper^.inUse then continue;
  if tim-avSuper^.lastAttempt<min_interval then continue;
  if LinkedToSupernode(avSuper^.ip) then continue;

   inc(avSuper^.attempts);
   avSuper^.lastAttempt := tim;
   avSuper^.inUse := True;
   avSuper^.buff := '';

   Result := avSuper;
   break;
 end;

end;

procedure tthread_supernode.free_lists;
var
PsocketUsr:precord_socket_User;
user: Tlocaluser;
avSuper:precord_availableSupernode;
sup: Tsupernode;
rec_seen:precord_ip_seen;
begin
try

try
while (LinkedSupernodes.count>0) do begin
   sup := LinkedSupernodes[LinkedSupernodes.count-1];
        LinkedSupernodes.delete(LinkedSupernodes.count-1);
   DisconnectSupernode(sup,true);
   sup.Free;
end;
except
end;
LinkedSupernodes.Free;

try
while (avSupernodes.count>0) do begin
   avSuper := avSupernodes[avSupernodes.count-1];
            avSupernodes.delete(avSupernodes.count-1);

    avSuper^.buff := '';
    if avsuper^.socket<>INVALID_SOCKET then TCPSocket_Free(avsuper^.socket);
    
   FreeMem(avSuper,sizeof(record_availableSupernode));
end;
except
end;
FreeAndNil(avSupernodes);
FreeAndNil(avSupernodesTrying);

try
while (socket_list.count>0) do begin
  Psocketusr := socket_list[socket_list.count-1];
              socket_list.delete(socket_list.count-1);
     TCPSocket_Free(psocketusr.socket);
  FreeMem(psocketUsr,sizeof(record_socket_user));
end;
except
end;
FreeAndNil(socket_list);


try
while (UnreliableSupernodes.count>0) do begin
 rec_seen := UnreliableSupernodes[UnreliableSupernodes.count-1];
           UnreliableSupernodes.delete(UnreliableSupernodes.count-1);
 FreeMem(rec_seen,sizeof(recorD_ip_seen));
end;
except
end;
FreeAndNil(UnreliableSupernodes);
//checksync;

try
while (user_list.count>0) do begin
 user := user_list[user_list.count-1]; //assegniazione globale
       user_list.delete(user_list.count-1);
 free_user_stuff(user,true); //fast clear!(le keyword le cancelliamo poi da freekeywords!
   user.Free;
end;
except
end;
FreeAndNil(user_list);


listRelayingSockets.Free;
//checksync;



dispose(rfield_title);
dispose(rfield_artist);
dispose(rfield_album);
dispose(rfield_category);
dispose(rfield_date);
dispose(rfield_language);


glb_lst_keywords.Free;

try
FreeHashLists;
except
end;

except
end;
end;





function tthread_supernode.get_4_servers_str: string;
var
i: Integer;
avSuper:precord_availableSupernode;
added: Integer;
begin
result := '';
added := 0;

if avSupernodes.count>4 then shuffle_mylist(avSupernodes,0);
 for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper.connects=0 then continue;
    Result := result+int_2_dword_string(avSuper^.ip)+
                   int_2_word_string(avSuper^.port);
     inc(added);
     if added>=4 then break;
 end;


end;



procedure tthread_supernode.gen_keys;   //unencrypted key viene generata in put my name
begin
sup_encrypted_login_key := get_crypt_udp_key(sup_unencrypted_login_key);
sup_enc_keyto_cache := get_crypt_cache_key(sup_unencrypted_login_key);
end;


procedure tthread_supernode.put_my_name; //synch
var
str: string;
guid1: Tguid;
begin

my_fe := abcd; //my name random string di 16 bytes
my_ca := random(254)+1; //my crypt algo fisso per ogni sessione evitiamo 1
my_sc := random(65534)+1;   // second key









//questo lo generiamo qui in synchronize
cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   // 16
sup_unencrypted_login_key := str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //32
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //48
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //64
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //80
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //96
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //112
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //128
sup_unencrypted_login_key := sup_unencrypted_login_key+str;  //questo viene inviato
end;




procedure tthread_supernode.regenerate_keys; //every 45 minutes
var
str: string;
guid1: Tguid;
begin
//questo lo generiamo qui in synchronize
my_fe := abcd; //my name random string di 16 bytes in seguito rigeneriamo anche strl_special per clients    RICORDARSI di fare FILL prelogin buffer!


cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   // 16
sup_unencrypted_login_key := str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //32
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //48
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //64
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //80
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //96
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //112
sup_unencrypted_login_key := sup_unencrypted_login_key+str;

cocreateguid(guid1);
SetLength(str,16);
move(guid1,str[1],16);   //128
sup_unencrypted_login_key := sup_unencrypted_login_key+str;  //questo viene inviato


end;

procedure tthread_supernode.init_vars2;
begin


   WANTED_USER_IN_CLUSTER := 9000; //12-14000 users in cluster
   WANTED_FILES_IN_CLUSTER := 2000000;
   MAX_LINKED_HSERVERS := 90; //max 50 links?


socket_cache := INVALID_SOCKET;

start_time := gettickcount;
tim := start_time;
last_HAlfsecond := tim;
cachequery_last := 0;  //update subito
last_5_sec := tim; //per expire search
last_minute := tim;
shared_count := 0;
last_30_minutes := tim;

end;

procedure tthread_supernode.init_vars1;
begin
setted_preferred_port := False; //per mettere in reg solo once
server_socket_tcp := nil;

latest_cache_url_string := ''; //da inviare on client login contiene comando intero per facilitare bootstrapping....


str_myagent := appname+' '+versioneares+CHRNULL;

    byte1_ransend := random(250)+1;           //per evitare sempre random()
    byte1_ransendchr := chr(byte1_ransend);
    byte1_ransendchr2 := chr(random(250)+1);

 len_prelogin_out_buffer := 0; //per fill prelogin e non allocare ogni volta...

 wanted_search := TWanted_search.create;
 FillChar(UDP_RemoteSin, Sizeof(UDP_RemoteSin), 0);             
 STR_ENDOFSYNC_PACKET := int_2_word_string(5)+
                       chr(MSG_LINKED_ENDOFSYNCH_100)+
                       CHRNULL+CHRNULL+int_2_word_string(vars_global.buildNo)+CHRNULL;
 listRelayingSockets := tmylist.create;
end;

procedure tthread_supernode.log_write(log_file: Thandlestream; const txt: string);
var
txt_log: string;
begin
txt_log := formatdatetime('hh:nn:ss:zzz',now)+'  '+txt+chr(13)+chr(10);
log_file.write(txt_log[1],length(txt_log));
end;

procedure tthread_supernode.log_dump(log_file: Thandlestream; const txt: string);
var
txt_log: string;
begin
txt_log := txt+chr(13)+chr(10);
log_file.write(txt_log[1],length(txt_log));
end;

procedure tthread_supernode.load_cached_supernodes;
var
list: TMyStringList;
hostStr: string;
ipC: Cardinal;
portW: Word;
//added: Integer;
begin
list := tmyStringList.create;
try
//added := 0;
helper_ares_nodes.aresnodes_loadaddresses(list,MAX_BOOTSTRAP_SUPERNODES);

 while (list.count>0) do begin
   hostStr := list.strings[list.count-1];
         list.delete(list.count-1);

   ipC := chars_2_dword(copy(hostSTr,1,4));
   portW := chars_2_word(copy(hostStr,5,2));

   addAvSupernode(ipC,portW);
   //inc(added);
 end;

 except
 end;
list.Free;

end;

procedure tthread_supernode.getLocalIp; //synch
var
ipsd: string;
begin
locip := 0;
mylocalip_dword := int_2_dword_string(0);
in1_decrypt := 0;
in2_decrypt := 0;

 if vars_global.localip<>'' then begin

         mylocalip_dword := int_2_dword_string(vars_global.localipC);
         locip := chars_2_dword(reverse_order(mylocalip_dword)); 

          ipsd := int_2_dword_string(locip);
          in1_decrypt := chars_2_word(copy(ipsd,1,2)); //1
          in2_decrypt := chars_2_word(copy(ipsd,3,2)); //2
 end;

end;

procedure tthread_supernode.Execute;
begin
priority := tphigher;
freeonterminate := False;

sleep(20000);

try

init_vars1;

createsockets; //cerchiamo di usare sempre stessa porta...
create_lists;

synchronize(getlocalip);


synchronize(put_my_name); // ATTENZIONE unencrypted key viene generata sopra in put my name RISPETTARE l'ORDINE!
gen_keys;  // ATTENZIONE unencrypted key viene generata sopra in put my name RISPETTARE l'ORDINE!
gen_out_key;

init_vars2;

fill_prelogin_buffer; //per non trovarci vuoti al primo...  ATTENZIONE dopo gen Keys e prep special

except
exit;
end;

try
load_cached_supernodes;
except
end;

while (true) do begin
   tim := gettickcount;

 try
  accept;
  receive_sockets;
  receiveUDP;
  supernodesDeal;
  if not terminated then sleep(10) else break;
  receive_users;
     if not terminated then sleep(5) else break;
   check_Halfsecond;
  RelayingSockets_deal;

 except
  tim := 0;
 end;

end; //ciclo


try
shutdown;
except
end;

end;



procedure tthread_supernode.receiveUDP;
var
er,len: Integer;
begin
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
  CMD_UDPTRANSFER_PING:handler_udpTransfer_ping;
  CMD_UDPTRANSFER_PUSH:handler_udpTransfer_push;
  CMD_UDPTRANSFER_ECHOPRTREQ:handler_udpTransfer_echoport;
 end;

end;

procedure tthread_supernode.handler_udpTransfer_echoport;
var
portW: Word;
begin
 portW := synsock.htons(UDP_remoteSin.sin_port);

 UDP_buffer[0] := CMD_UDPTRANSFER_ECHOPRTREP;
 move(portW,UDP_Buffer[1],2);

 synsock.SendTo(UDP_socket,UDP_buffer,3,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
end;


procedure tthread_supernode.handler_udpTransfer_ping;
var
us: TlocalUser;
tusid: Word;
portW: Word;
begin
if UDP_len_recvd<3 then exit;

move(UDP_Buffer[1],tusid,2);
if tusid>high(db_result_ids.bkt) then exit;
if db_result_ids.bkt[tusid]=nil then exit;

 us := db_result_ids.bkt[tusid];
 if us.ip<>cardinal(UDP_remoteSin.sin_addr.S_addr) then exit;

 portW := synsock.htons(UDP_remoteSin.sin_port);
 us.UDPTransferPort := portW;  // this port value should be always the same for well behaved NAT routers when local endpoint doesn't change


 UDP_buffer[0] := CMD_UDPTRANSFER_PONG;
 move(portW,UDP_Buffer[1],2);

 synsock.SendTo(UDP_socket,UDP_buffer,3,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
end;

procedure tthread_supernode.handler_udpTransfer_push;
var
us: TLocalUser;
RequestedIP: Cardinal;
portW: Word;
UDP_len_tosend: Integer;
restOfCommand: string;
begin
if UDP_len_recvd<25 then exit;
if UDP_len_recvd>60 then exit;


move(UDP_Buffer[1],RequestedIP,4);

us := user_da_ip(RequestedIP);
if us=nil then begin        // requested user not found
 UDP_Buffer[0] := CMD_UDPTRANSFER_PUSHFAIL1;
 synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_recvd,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
 exit;
end;

if us.UDPTransferPort=0 then begin  // requested user isn't constantly pinging this server
 UDP_Buffer[0] := CMD_UDPTRANSFER_PUSHFAIL2;
 synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_recvd,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
 exit;
end;

SetLength(restOfCommand,UDP_len_recvd-5);
move(UDP_Buffer[5],restOfCommand[1],length(restOfCommand));



// send back push ack to caller, giving him our user's UDP port 'local endpoint' he should then
// send UDP packets to our user's NAT ip:port pair while our user sends UDP packets to his NAT ip:port pair
UDP_Buffer[0] := CMD_UDPTRANSFER_PUSHACK;
move(us.UDPTransferPort,UDP_buffer[1],2);
UDP_Buffer[3] := 0;
UDP_Buffer[4] := 0;
synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_recvd,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));



// send request to target user
portW := synsock.htons(UDP_remoteSin.sin_port);
 UDP_Buffer[0] := CMD_UDPTRANSFER_PUSHREQ;
 move(UDP_remoteSin.sin_addr.S_addr,UDP_Buffer[1],4);
 move(portW,UDP_buffer[5],2);
 move(restOfCommand[1],UDP_Buffer[7],length(restOfCommand)); // anything contained in his request...

 UDP_len_tosend := 7+length(restOfCommand);
 UDP_RemoteSin.sin_family := AF_INET;
 UDP_RemoteSin.sin_port := synsock.htons(us.UDPTransferPort);
 UDP_RemoteSin.sin_addr.s_addr := us.ip;
 synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_tosend,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
end;

procedure tthread_supernode.shutdown;
begin
priority := tpnormal;
try
free_sockets;
except
end;

priority := tplower;


try
free_lists;
except
end;

try
wanted_search.Free;
except
end;

end;





procedure tthread_supernode.check_Halfsecond;
begin
 if tim-last_Halfsecond<500 then exit;  //mezzo secondo in realtà?
   last_Halfsecond := tim;

   

   try
    checksync;
   except
   end;

   try
   AvSupernodeDeal;
   except
   end;


      try
    if tim-last_5_sec>5000 then begin //7 secondi!
     last_5_sec := tim;
       checksync;
    end;


     except
     end;

   
     
if terminated then exit;

 check_60_second;
end;

procedure tthread_supernode.FreeRelayingSocket(aSocket:precord_relaying_socket);
var
 aUser: Tlocaluser;
 ind: Integer;
begin
 aUser := aSocket^.user;
  SetLength(out_buffer_global,4);
  move(aSocket^.id,out_buffer_global[1],4);
 Send_back_user(aUser,CMD_RELAYING_SOCKET_OFFLINE);

   ind := aUser.relayingSockets.indexof(aSocket);
   if ind<>-1 then aUser.relayingSockets.delete(ind);

  TCPSocket_free(aSocket^.socket);
  aSocket^.in_buffer := '';
  aSocket^.out_buffer := '';
  FreeMem(aSocket,sizeof(record_relaying_socket));
end;

procedure tthread_supernode.handler_releayDrop;
var
 i,ind: Integer;
 id: Cardinal;
 aSocket:precord_relaying_socket;
begin
if GlobUser.relayingSockets=nil then exit;
if bytes_in_buffer<4 then exit;

 move(buffer_ricezione[0],id,4);

for i := 0 to GlobUser.relayingSockets.count-1 do begin
   aSocket := GlobUser.relayingSockets[i];
   if aSocket^.id<>id then continue;

    ind := GlobUser.relayingSockets.indexof(aSocket);
    if ind<>-1 then GlobUser.relayingSockets.delete(ind);

    TCPSocket_free(aSocket^.socket);
    aSocket^.in_buffer := '';
    aSocket^.out_buffer := '';

    ind := listRelayingSockets.indexof(aSocket);
    if ind<>-1 then listRelayingSockets.delete(ind);

    FreeMem(aSocket,sizeof(record_relaying_socket));
    exit;
end;

end;

procedure tthread_supernode.handler_relayPacket; // our local user want us to relay this packet to remote directchat user
var
 i: Integer;
 id: Cardinal;
 aSocket:precord_relaying_socket;
 previous_len: Integer;
begin
 if bytes_in_buffer<5 then exit; //nothing to send?!

 move(buffer_ricezione[0],id,4);

 if GlobUser.relayingSockets=nil then begin
    GlobUser.out_buffer.add(int_2_word_string(4)+chr(CMD_RELAYING_SOCKET_OFFLINE)+
                            int_2_dword_string(id));
   exit;
 end;


 for i := 0 to GlobUser.relayingSockets.count-1 do begin
   aSocket := GlobUser.relayingSockets[i];
   if aSocket^.id<>id then continue;

   if length(aSocket.out_buffer)>LIMIT_SIZE_RELAYEDOUTBUFFER then begin
    GlobUser.out_buffer.add(int_2_word_string(4)+chr(CMD_RELAYING_SOCKET_OFFLINE)+
                            int_2_dword_string(id));
    listRelayingSockets.delete(i);
    FreeRelayingSocket(aSocket);
    exit;
   end;

   if length(aSocket.out_buffer)>=THREASHOLD_SIZE_RELAYEDOUTBUFFER then begin
        GlobUser.out_buffer.add(int_2_word_string(8)+chr(CMD_RELAYING_SOCKET_OUTBUFSIZE)+
                                int_2_dword_string(id)+
                                int_2_dword_string(length(aSocket.out_buffer)+length(content)));
   end;
   
    previous_len := length(aSocket.out_buffer);
    SetLength(aSocket.out_buffer,previous_len+(bytes_in_buffer-4));
    move(buffer_ricezione[4],aSocket.out_buffer[previous_len+1],bytes_in_buffer-4);
   exit;
 end;

 //not found!
    GlobUser.out_buffer.add(int_2_word_string(4)+chr(CMD_RELAYING_SOCKET_OFFLINE)+
                            int_2_dword_string(id));

end;

procedure tthread_supernode.relayingSockets_deal;
var
 i,er,len,previous_len: Integer;
 aSocket:precord_relaying_socket;
 to_receiveW,to_sendW: Word;
// aUser: Tlocaluser;
begin
 // receive from remote requesting user -> send to our local user data
 i := 0;
 while (i<listRelayingSockets.count) do begin
  aSocket := listRelayingSockets[i];

     if tim-aSocket^.lastIn>120000 then begin  // at least one ping every minute...
        listRelayingSockets.delete(i);
        FreeRelayingSocket(aSocket);
        continue;
     end;

     if aSocket^.user.out_buffer.count>1 then begin
      inc(i);
      continue;
     end;

     if aSocket^.bytes_in_header<4 then begin //pvt header len 4 bytes!

      if not TCPSocket_CanRead(aSocket^.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        listRelayingSockets.delete(i);
        FreeRelayingSocket(aSocket);
       end else inc(i);
       continue;
      end;

     len := TCPSocket_RecvBuffer(aSocket^.socket,@aSocket^.buffer_header_ricezione[aSocket^.bytes_in_header],4-aSocket^.bytes_in_header,er);
       if er=WSAEWOULDBLOCK then begin
       inc(i);
       continue;
       end else
       if er<>0 then begin
        listRelayingSockets.delete(i);
        FreeRelayingSocket(aSocket);
        continue;
       end;
       inc(aSocket^.bytes_in_header,len);
       if aSocket^.bytes_in_header=4 then begin
        aSocket^.in_buffer := ''; //prepare inbuffer
        aSocket^.lastIn := tim;
       // move(aSocket^.buffer_header_ricezione[1],to_receiveW,2); // first byte is a null byte
      end;
       inc(i);
       continue;
      end;


      
     move(aSocket^.buffer_header_ricezione[1],to_receiveW,2); // first byte is a null byte
     if to_receiveW>0 then begin

      if to_receiveW>sizeof(buffer_ricezione_temp) then begin
        listRelayingSockets.delete(i);
        FreeRelayingSocket(aSocket);
        continue;
      end;

      if not TCPSocket_CanRead(aSocket^.socket,0,er) then begin
       if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        listRelayingSockets.delete(i);
        FreeRelayingSocket(aSocket);
       end else inc(i);
       continue;
      end;

       previous_len := length(aSocket^.in_buffer);
       len := TCPSocket_RecvBuffer(aSocket^.socket,@buffer_ricezione_temp[0],to_receiveW-previous_len,er);

       if er=WSAEWOULDBLOCK then begin
        inc(i);
        continue;
        end else
        if er<>0 then begin
         listRelayingSockets.delete(i);
         FreeRelayingSocket(aSocket);
         continue;
       end;
       aSocket^.lastIn := tim;
       if previous_len+len<to_receiveW then begin //non ho ancora tutto...riempio quello che ho in in_buffer utente(stringa)
         SetLength(aSocket^.in_buffer,previous_len+len); //accresciamo buffer...per prossimo recv
         move(buffer_ricezione_temp[0],aSocket^.in_buffer[previous_len+1],len);
         inc(i);
         continue;
       end;

        if previous_len>0 then begin
         move(aSocket^.in_buffer[1],buffer_ricezione[0],previous_len);
         move(buffer_ricezione_temp[0],buffer_ricezione[previous_len],len);
         bytes_in_buffer := len+previous_len;
        end else begin
         move(buffer_ricezione_temp[0],buffer_ricezione[0],len);
         bytes_in_buffer := len;
        end;
        
    end else bytes_in_buffer := 0;


         checksync;

          SetLength(out_buffer_global,bytes_in_buffer+8);

          to_sendW := length(out_buffer_global)-3;
          move(to_sendW,out_buffer_global[1],2);
          out_buffer_global[3] := chr(CMD_RELAYING_SOCKET_PACKET);

          
          out_buffer_global[4] := chr(aSocket^.buffer_header_ricezione[3]); //copy original command
          move(aSocket^.id,out_buffer_global[5],4);
          if bytes_in_buffer>0 then move(buffer_ricezione[0],out_buffer_global[9],length(out_buffer_global)-8);

          aSocket^.user.out_buffer.add(out_buffer_global); //send packet

       aSocket^.bytes_in_header := 0;
       aSocket^.in_buffer := '';
       

  inc(i);
 end;

 //flush data from our local user to remote requesting user
  i := 0;
 while (i<listRelayingSockets.count) do begin
  aSocket := listRelayingSockets[i];
  if length(aSocket^.out_buffer)=0 then begin
   inc(i);
   continue;
  end;

  len := length(aSocket^.out_buffer);
  if len>1024 then len := 1024;
  TCPSocket_SendBuffer(aSocket^.socket,PChar(aSocket^.out_buffer),len,er);

   if er=WSAEWOULDBLOCK then begin
     if aSocket^.lastOut=0 then begin
      inc(i);
      continue;
     end;
     if tim-aSocket^.lastOut>20000 then begin
      listRelayingSockets.delete(i);
      FreeRelayingSocket(aSocket);
     end else inc(i);
    continue;
   end;

   if er<>0 then begin
    listRelayingSockets.delete(i);
    FreeRelayingSocket(aSocket);
    continue;
   end;

   delete(aSocket^.out_Buffer,1,len);
   if length(aSocket^.out_Buffer)=0 then aSocket^.lastOut := 0 else // zero check
                                        aSocket^.lastOut := tim;
  inc(i);
 end;

end;

procedure tthread_supernode.dropunresponsiveServeRs;
var
 i: Integer;
 sup: TSupernode;
 avSuper:precord_availableSupernode;
begin

// disconnect broken links
 for i := 0 to LinkedSupernodes.count-1 do begin
  sup := LinkedSupernodes[i];
  if sup.state<>SYNCHED then
   if tim-sup.logtime>30000 then begin
    SupernodeDisconnectWithError(sup,ERROR_SYNCTIMEOUT);
    continue;
   end;
   if tim-sup.tick>360000 then begin
    SupernodeDisconnectWithError(sup,ERROR_FLOWTIMEOUT); // disconnect in next supernodesdeal call
   end;
 end;


// available supernodes failed 5 times are flushed
 i := 0;
 while (i<avsupernodes.count) do begin
  aVSuper := avSupernodes[i];
  if avSuper^.inUse then begin
   inc(i);
   continue;
  end;

  if avSuper^.attempts>=5 then begin
    avSupernodes.delete(i);
    FreeMem(avSuper,sizeof(record_availableSupernode));
  end else inc(i);

 end;



end;

procedure tthread_supernode.check_60_second;
begin
 if tim-last_minute<MINUTE then exit;
    last_minute := tim;


    try
      check_ghost;   
      pingSupernodes;
       dropunresponsiveServeRs;
      checksync;
    except
    end;


          try
          ////////////////////////////////////////
           if stato_supernodecache_query=STATO_SUPERNODE_CACHE_QUERY_IDLE then begin  //don't change keys while polling caches
            synchronize(regenerate_keys);
            gen_keys;
            fill_prelogin_buffer;
           end;
          ///////////////////////////////////////
          except
          end;

         checksync;

       try
         if not setted_preferred_port then
          if user_list.count>30 then synchronize(set_reg_preferred_port);
       except
       end;



    byte1_ransend := random(250)+1;           //per evitare sempre random()
    byte1_ransendchr := chr(byte1_ransend);
    byte1_ransendchr2 := chr(random(250)+1);

   // if tim-last_30_minutes>5*MINUTO then big_dump;
end;

{function tthread_supernode.serialize_keys(item:precorD_file_shared): string;
var
z: Integer;
key:pKeyword;
keys: string;
begin
result := 'Mime: '+inttostr(item^.tipo)+'  '+
         inttostr(item^.size DIV MEGABYTE)+'MB  Keys:';

          for z := 0 to item^.numKeywords-1 do begin
           key := item^.keywords[z*3];
           SetLength(keys,length(key.keyword));
           move(key.keyword[0],keys[1],length(key.keyword));
            Result := result+keys+',';
          end;
       delete(result,length(result),1);
end;

procedure tthread_supernode.big_dump; 
var
i,h: Integer;
us: Tlocaluser;
pfile:precord_file_shared;
str: string;

log_file: Thandlestream;
waszero: Boolean;
begin
last_30_minutes := tim;
 user_list.sort(ordina_users_per_shared);
 waszero := True;
 
log_file := MyFileOpen('c:\dump.txt',ARES_OVERWRITE_EXISTING);
if log_file=nil then exit;
 
 log_file.size := 0;
 log_write(log_file,'Users:'+inttostr(user_list.count)+' Files:'+inttostr(shared_count)+' Uptime:'+format_time((tim-start_time) div 1000));

 for i := 0 to user_list.count-1 do begin
    us := user_list[i];
    if us.disconnect then continue;

    if us.shared_count>0 then
     if waszero then begin
      waszero := False;
      log_write(log_file,'');
      log_dump(log_file,inttostr(i)+' ----Begin share---');
     end;
     
     if not waszero then log_dump(log_file,'');
     log_dump(log_file,'User: '+us.nick+'@'+us.agent+' '+
                       ipint_to_dotstring(us.ip)+':'+inttostr(us.port)+
                       '  Uptime:'+format_time((tim-us.logtime) div 1000)+
                       '  ShareBlocked:'+inttostr(integer(us.shareBlocked)));

     if us.shared_list=nil then continue;

      log_dump(log_file,'Files:'+inttostr(us.shared_list.count)+'  MB:'+inttostr(us.shared_Size div MEGABYTE));

      for h := 0 to us.shared_list.count-1 do begin
       pfile := us.shared_list[h];

          log_dump(log_file,serialize_keys(pfile));
      end;

 end;

 FreeHandleStream(log_file);
end; }



procedure tthread_supernode.put_reg_slow_speed; //troppo lag...abbassiamo la nostra velocita!!
var
reg: Tregistry;
begin
vars_global.velocita_up := 0; //azzeriamo anche nostra...
reg := tregistry.create;
 try
  with reg do begin
   openkey(areskey,true);
   if valueexists('Stats.CUpSpeed') then
    deletevalue('Stats.CUpSpeed');
   closekey;
  end;
 except
 end;
reg.destroy;
end;


function tthread_supernode.get_crypt_cache_key(const unenc_key: string): string;
var
secH: Tsha1;
i: Integer;
str1,str2: string;
begin
result := '';

 str2 := unenc_key;
 for i := 1 to 20 do begin
  str1 := chr(i+1)+str2+chr(254-i);
   secH := Tsha1.create;
   secH.transform(str1[1],length(str1));
   secH.complete;
  str2 := str2+secH.HashValue;
   secH.Free;
  end;
  delete(str2,513,length(str2));
  
  if length(str2)<512 then exit;

  move(str2[1],buffer_ricezione_temp[0],sizeof(ac8));

  E090216F(@buffer_ricezione_temp[0]);

  SetLength(str2,sizeof(ac8)+2);
  str2[1] := chr(1);
   move(buffer_ricezione_temp[0],str2[2],sizeof(ac8));
  str2[length(str2)] := chr(254);

  secH := TSha1.create;
   secH.transform(str2[1],length(str2));
  secH.complete;
   str1 := secH.HashValue;
  secH.Free;
  
result := e64(str1,16912);
end;


function tthread_supernode.d1(cont: string): string;
var
b2: Word;
constr: string;
begin
try
constr := cont;
 b2 := a1(my_sc,ord(constr[1]),ff[my_ca]);

 delete(constr,1,2); // 2 byte fasullo
 Result := d2(constr,b2);
except
result := ''; // errore<------- esce con zero di result

end;
end;





procedure tthread_supernode.process_command1(command: Byte);
var
b: Word;
i: Integer;
begin

try

                  if command=MSG_CLIENT_COMPRESSED then begin //dopo essere autorizzati accettiamo pure compressed
                   handler_compressed;
                   exit;
                  end;

                                    
                  if not GlobUser.noCrypt then begin
                          b := a1(my_sc,buffer_ricezione[0],ff[my_ca]); //get key

                          move(buffer_ricezione[2],buffer_ricezione_temp[0],bytes_in_buffer-2); //alliniamo anche destinazione
                          dec(bytes_in_buffer,2); //togliamo coda

                       for i :=  0 to bytes_in_buffer-1 do begin  //criptiamo len-1 -2 perchè ho skippato 2 bytes
                          buffer_ricezione[i] := buffer_ricezione_temp[i] xor (b shr 8);
                          b := (buffer_ricezione_temp[i] + b) * 52845 + 22719;
                       end;
                   end;

             process_command2(command);



except
end;
end;

procedure tthread_supernode.process_command2(command: Byte);
begin
try

case command of

 MSG_CLIENT_LOGIN_REQ:handler_login; // login req could be client login, server login, client push req
 MSG_CLIENT_ADD_SEARCH_NEW:handler_add_key_search_new; // keyword add search
 MSG_CLIENT_ENDOFSEARCH:handler_client_endofsearch;
 MSG_CLIENT_ADD_SHARE_KEY:handler_add_shared_key(false); // keyword add search
 MSG_CLIENT_ADD_CRCSHARE_KEY:handler_add_shared_key(true); // keyword add search
 MSG_CLIENT_REMOVING_SHARED:handler_rem_shared; // remove shared file
 MSG_CLIENT_STAT_REQ:handler_status; // client status & stat request  (ping)
 MSG_CLIENT_UPDATING_NICK:handle_update_my_nick;
 MSG_CLIENT_ADD_HASHREQUEST:handler_add_hashrequest;
 MSG_CLIENT_USERFIREWALL_REPORT:handler_firewall_test_result;
 MSG_CLIENT_REM_HASHREQUEST:handler_rem_hashrequest;

 MSG_CLIENT_RELAYDIRECTCHATPACKET:handler_relayPacket;
 CMD_CLIENT_RELAYDIRECTCHATDROP:handler_releayDrop;
//MSG_CLIENT_DUMMY:; //questo non arriva più qui...ma viene usato dai client per correggere bug decompressione filelist(ultimo messaggio non arrivava)
//MSG_CLIENT_ADD_SEARCH_NEWUNICODE:handler_add_key_search_unicode;
//MSG_CLIENT_ADD_SHARE_KEY_UNICODE:handler_add_shared_unicode;
//MSG_CLIENT_ADD_SHARE_KEY_NEW:handler_add_shared_key_new;  // solo tipo + size + hash + fields
//MSG_CLIENT_GIVEMEPROXYADDR:handler_send_meproxyaddr; //client vuole qualche utente per proxy
end;

except
end;
end;

procedure tthread_supernode.send_Back_EndofSearch(conn: TLocaluser; const search_id: string; reason: Byte);
begin
    out_buffer_global := search_id+chr(reason);
    send_Back_user(conn,MSG_SERVER_SEARCH_ENDOF);
end;

procedure tthread_supernode.free_user_searches(conn: TLocalUser; only_exceeding:boolean = False; searchP:precord_local_search=nil; requested:boolean=false);
var
i: Integer;
src:precord_local_search;
begin
try

if conn.searches=nil then exit;


if searchP<>nil then begin   //delete specific search

 for i := 0 to conn.searches.count-1 do begin
  src := conn.searches[i];
   if src=searchP then begin
     conn.searches.delete(i);
     
      if requested then send_Back_EndofSearch(conn,int_2_word_string(src^.search_id),RSN_ENDOFSEARCH_ASREQUESTED)
       else send_Back_EndofSearch(conn,int_2_word_string(src^.search_id),RSN_ENDOFSEARCH_ENOUGHRESULTS);

      clear_rec_seen(src^.ips);
      FreeMem(src,sizeof(record_local_search));
       if conn.searches.count=0 then FreeAndNil(conn.searches);
    exit;
   end;
 end;

end else

if only_exceeding then begin   // delete oldest search (only if needed)

    i := 0;
    while (i<conn.searches.count) do begin
         src := conn.searches[i];  //older first

          conn.searches.delete(i);

        send_Back_EndofSearch(conn,int_2_word_String(src^.search_id),RSN_ENDOFSEARCH_TOMANYSEARCHES);

         clear_rec_seen(src^.ips);
        FreeMem(src,sizeof(record_local_search));

     break;
     end;

end else begin       // delete all searches

  while (conn.searches.count>0) do begin
   src := conn.searches[conn.searches.count-1];
           conn.searches.delete(conn.searches.count-1);
       clear_rec_seen(src^.ips);
      FreeMem(src,sizeof(record_local_search));
  end;
  FreeAndNil(conn.searches);

end;


except
end;

end;


procedure tthread_supernode.parse_complex_search(complex: string);
var
num: Byte;
begin
try
while (length(complex)>2) do begin
 num := ord(complex[1]);
 delete(complex,1,1);
 if length(complex)<2 then exit;  //not enough data

 case num of
 1:begin                                   //size minore di
  wanted_search.sizecomp := 1;
  wanted_search.wantedsize := chars_2_dword(complex);
  delete(complex,1,4);
 end;
 2:begin                                       //size approx to
  wanted_search.sizecomp := 2;
  wanted_search.wantedsize := chars_2_dword(complex);
  wanted_search.wanted_size_avarage_min := wanted_search.wantedsize-(wanted_search.wantedsize div 10);
  wanted_search.wanted_size_avarage_max := wanted_search.wantedsize+(wanted_search.wantedsize div 10);
  delete(complex,1,4);
 end;
 3:begin                                           //size maggiore di
  wanted_search.sizecomp := 3;
  wanted_search.wantedsize := chars_2_dword(complex);
  delete(complex,1,4);
 end;
 
 4:begin                                            //param1 minore di
  wanted_search.param1comp := 1;
  wanted_search.wantedparam1 := chars_2_word(complex);
  delete(complex,1,2);
 end;
 5:begin                                             //param1 uguale a
  wanted_search.param1comp := 2;
  wanted_search.wantedparam1 := chars_2_word(complex);
  delete(complex,1,2);
 end;
 6:begin                                           //param1 maggiore di
  wanted_search.param1comp := 3;
  wanted_search.wantedparam1 := chars_2_word(complex);
  delete(complex,1,2);
 end;

 10:begin                                           //param3 minore di
  wanted_search.param3comp := 1;
  wanted_search.wantedparam3 := chars_2_dword(complex);
  delete(complex,1,4);
 end;
 11:begin                                           //param3 uguale a
  wanted_search.param3comp := 2;
  wanted_search.wantedparam3 := chars_2_dword(complex);
  wanted_search.wanted_param3_avarage_max := wanted_search.wantedparam3+(wanted_search.wantedparam3 div 10);
  wanted_search.wanted_param3_avarage_min := wanted_search.wantedparam3-(wanted_search.wantedparam3 div 10);
  delete(complex,1,4);
 end;                                               //param3 maggiore di
 12:begin
  wanted_search.param3comp := 3;
  wanted_search.wantedparam3 := chars_2_dword(complex);
   delete(complex,1,4);
 end;
 end;
end;
except
end;
end;


procedure tthread_supernode.handler_client_endofsearch;
var
i: Integer;
searchP:precord_local_search;
begin

if bytes_in_buffer<2 then exit;

if GlobUser.searches=nil then exit;



  for i := 0 to GlobUser.searches.count-1 do begin
   searchP := GlobUser.searches[i];
    if not comparemem(@buffer_ricezione[0],@searchP.search_id,2) then continue;
      free_user_searches(GlobUser,false,searchP,true);
      exit;
  end;

end;

procedure tthread_supernode.handler_firewall_test_result;
var
ip_user: Cardinal;
us: Tlocaluser;
begin
  try


if bytes_in_buffer<5 then exit;


move(buffer_ricezione[1],ip_user,4);
us := user_da_ip(ip_user);
if us=nil then exit;

  us.num_special := buffer_ricezione[0];   // 0 = firewalled(cant connect)  1= not firewalled  2967 + 28-6-2005

    us.result_hash_str := int_2_dword_string(us.ip)+
                        int_2_word_string(us.port)+
                        chr(us.num_special)+
                        us.nick+chr(64){'@'}+us.agent+CHRNULL;

    get_user_result_string(us); //attenzione va dopo Result hash str....


    out_buffer_global := chr(us.num_special)+
                       int_2_word_string(us.result_id); // for UDP transfer protocol and UDP ping

    send_back_user(us,MSG_CLIENT_USERFIREWALL_RESULT);    //2981 2005-11-6
  except
  end;
end;

procedure tthread_supernode.handler_add_key_search_new;
var
num_rim: Integer;
complex,complex_back_udp: string; //backup da aggingere in remote search record
begin


if bytes_in_buffer<5 then exit;
if bytes_in_buffer>255 then exit;

if tim-GlobUser.last_search<500 then begin

 exit;
end;

GlobUser.last_search := tim;

try
if GlobUser.searches<>nil then
 if GlobUser.searches.count>=MAX_USER_UDP_SEARCHES then free_user_searches(GlobUser,true);   //only if exceeding MAX_NUM

 wanted_search.clear;
 
 wanted_search.amime := buffer_ricezione[0];
 if wanted_search.amime>=100 then dec(wanted_search.amime,100);  //used to means wanted_results = 100 + mime type
 if wanted_search.amime>ARES_MIMESRC_OTHER then wanted_search.amime := ARES_MIME_OTHER; //>8 then = 0
 wanted_search.amime := clienttype_to_searchservertype(wanted_search.amime);

 move(buffer_ricezione[2],wanted_search.search_id[0],2);

 complex := '';
 complex_back_udp := '';

 wanted_search.strict := True;

if buffer_ricezione[1]=15 then parse_new_search(4,complex)
 else parse_old_search(complex);

if not enough_keys then begin
 send_Back_EndofSearch(GlobUser, wanted_search.search_id_toStr, RSN_ENDOFSEARCH_MISSINGFIELDS);
 exit;
end;

if wanted_search.strict then begin
  complex_back_udp := complex;
  parse_complex_search(complex);
end;


checksync;

num_rim := local_search;
if num_rim>0 then Continue_search(complex_back_udp,num_rim)
 else send_Back_EndofSearch(GlobUser,wanted_search.search_id_toStr,RSN_ENDOFSEARCH_ENOUGHRESULTS);


except
end;

end;

function tthread_supernode.enough_keys: Boolean;
begin
result := False;

if wanted_search.strict then begin
  if wanted_search.keywords_title.count=0 then
   if wanted_search.keywords_artist.count=0 then
    if wanted_search.keywords_album.count=0 then
     if wanted_search.keywords_category.count=0 then
      if length(wanted_search.keyword_date)<2 then
       if length(wanted_search.keyword_language)<2 then exit;
end else begin
  if wanted_search.keywords_generali.count=0 then exit;
end;

result := True;
end;

procedure tthread_supernode.parse_new_search(index: Byte; var complex: string);
var
i: Integer;
lenkey: Byte;
crckey: Word;
keyword: string;
begin
try
  //ora parsiamo ricerca 0..3 header 4..7 client infos
 i := index;
 while (i+2<bytes_in_buffer) do begin  //che ci sia almeno keylen..per prox check
   case buffer_ricezione[i] of
     20:begin //general
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],crckey,2);
         SetLength(keyword,lenkey);
        move(buffer_ricezione[i+4],keyword[1],lenkey);
        inc(i,4+lenkey);
        wanted_search.keywords_generali.AddCmd(crckey,keyword);
        wanted_search.strict := False;
       end;
     1:begin //title
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],crckey,2);
         SetLength(keyword,lenkey);
        move(buffer_ricezione[i+4],keyword[1],lenkey);
        inc(i,4+lenkey);
        wanted_search.keywords_title.AddCmd(crckey,keyword);
        end;
     2:begin //artist
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],crckey,2);
         SetLength(keyword,lenkey);
        move(buffer_ricezione[i+4],keyword[1],lenkey);
        inc(i,4+lenkey);
        wanted_search.keywords_artist.AddCmd(crckey,keyword);
        end;
     3:begin //album
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],crckey,2);
         SetLength(keyword,lenkey);
        move(buffer_ricezione[i+4],keyword[1],lenkey);
        inc(i,4+lenkey);
        wanted_search.keywords_album.AddCmd(crckey,keyword);
        end;
     4:begin //category
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],crckey,2);
         SetLength(keyword,lenkey);
        move(buffer_ricezione[i+4],keyword[1],lenkey);
        inc(i,4+lenkey);
        wanted_search.keywords_category.AddCmd(crckey,keyword);
        end;
     5:begin //date single
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],wanted_search.crcdate,2);
         SetLength(wanted_search.keyword_date,lenkey);
        move(buffer_ricezione[i+4],wanted_search.keyword_date[1],lenkey);
        inc(i,4+lenkey);  //possibile bug, per 3 giorni dall'uscita versione qui non avevo crcdate e crclanguage
        end;
     6:begin //language single
        lenkey := buffer_ricezione[i+1];
        if lenkey<KEYWORD_LEN_MIN then break;
        if lenkey>KEYWORD_LEN_MAX then break;
        if bytes_in_buffer<i+4+lenkey then break;
        move(buffer_ricezione[i+2],wanted_search.crclanguage,2);
         SetLength(wanted_search.keyword_language,lenkey);
        move(buffer_ricezione[i+4],wanted_search.keyword_language[1],lenkey);
        inc(i,4+lenkey);
        end;
     7:begin //complex
        lenkey := buffer_ricezione[i+1];
        if lenkey<3 then break;
        if bytes_in_buffer<i+2+lenkey then break;
         SetLength(complex,lenkey);
        move(buffer_ricezione[i+2],complex[1],lenkey);
        break;
      end else break;
   end;
 end;

except
end;

end;

procedure tthread_supernode.parse_old_search(var Complex: string);
var
num: Byte;
keyw: string;
begin
   
   dec(bytes_in_buffer,4); //prima era 17 in quanto ricevevo guid 16 e non avevo should_udp_continue
   SetLength(content,bytes_in_buffer); //alloc per comodità
   move(buffer_ricezione[4],content[1],bytes_in_buffer);

 while (length(content)>1) do begin
 try
 num := ord(content[1]);
 delete(content,1,1);
 case num of
   20:begin   //1 title  no strict
   keyw := copy(content,1,pos(CHRNULL,content)-1);
    if splittokeywords_searchultra(keyw+chr(32),wanted_search.keywords_generali,MAX_KEYWORDS_SEARCH)<1 then exit;
   wanted_search.strict := False;
   break;
  end;
  1:begin   //1 title
   keyw := copy(content,1,pos(CHRNULL,content)-1);
    splittokeywords_searchultra(keyw+chr(32),wanted_search.keywords_title,MAX_KEYWORDS_SEARCH);
  end;
  2:begin //2 artist
    keyw := copy(content,1,pos(CHRNULL,content)-1);
     splittokeywords_searchultra(keyw+chr(32),wanted_search.keywords_artist,MAX_KEYWORDS_SEARCH);
  end;
  3:begin   //3 album
   keyw := copy(content,1,pos(CHRNULL,content)-1);
     splittokeywords_searchultra(keyw+chr(32),wanted_search.keywords_album,MAX_KEYWORDS_SEARCH);
  end;
  4:begin // 4 category
   keyw := copy(content,1,pos(CHRNULL,content)-1);
    splittokeywords_searchultra(keyw+chr(32),wanted_search.keywords_category,2);
  end;
  5:begin  //5 date
   keyw := copy(content,1,pos(CHRNULL,content)-1);
     wanted_search.keyword_date := splittokeywords3(keyw+chr(32));
     if length(wanted_search.keyword_date)>=2 then begin
       wanted_search.crcdate := stringcrc(wanted_search.keyword_date,true);
     end;
  end;
  6:begin  // 6 language
   keyw := copy(content,1,pos(CHRNULL,content)-1);
     wanted_search.keyword_language := splittokeywords3(keyw+chr(32));
     if length(wanted_search.keyword_language)>=1 then begin
       wanted_search.crclanguage := stringcrc(wanted_search.keyword_language,true);
     end;
  end;
  7:begin // 7 complex è il finale
   complex := content;
   content := '';
   break;
  end else break;
end;
except
complex := '';
break;
end;
   delete(content,1,pos(CHRNULL,content)); //al prox
end;
end;  //fine se non era high_speed parse

procedure tthread_supernode.Continue_search(complex_back_udp: string; num_rim:integer);
var
searchP:precord_local_search;
search_str: string;
i: Integer;
sup: Tsupernode;
begin
 if GlobUser.result_id=-1 then assign_result_id(GlobUser);

 searchP := AllocMem(sizeof(record_local_search));
  with searchP^ do begin
   ips := nil;
   search_id := wanted_search.search_id_toWord;
  end;

   if GlobUser.searches=nil then GlobUser.searches := tmylist.create;
   GlobUser.searches.add(searchP);

   search_str := wanted_search.search_id_toStr+
               int_2_word_string(GlobUser.result_id)+
               chr(MAX_LINKEDRESULT_COUNT+10)+
               chr(wanted_search.amime)+
               make_search_str(complex_back_udp);

   search_str := int_2_word_string(length(search_str))+
               chr(MSG_LINKED_QUERY_100)+
               search_str;
                        
     for i := 0 to LinkedSupernodes.count-1 do begin
      sup := LinkedSupernodes[i];
      if sup.state<>SYNCHED then continue;
      if sup.outBuffer.count>=MAX_LINKCONGESTION_TODROPSEARCHES then continue;
      sup.outBuffer.add(search_str)
     end;

end;



function tthread_supernode.make_search_str(complex: string): string;
var
i: Integer;
keyw: string;
crckey: Word;
begin
result := '';  //tipo già trasformato

 ////////////////////////////////////////////////////////general
 if wanted_search.keywords_generali.count>0 then begin
  for i := 0 to wanted_search.keywords_generali.count-1 do begin //inviamo già formattate con prima e ultima lettera ok! :)
     keyw := wanted_search.keywords_generali.str(i);
     crckey := wanted_search.keywords_generali.id(i);
    Result := result+chr(20)+
                   chr(length(keyw))+
                   int_2_word_string(crckey)+
                   keyw;
  end;
 end;


 //////////////////////////////////////////////////////////title
 if wanted_search.keywords_title.count>0 then begin
  for i := 0 to wanted_search.keywords_title.count-1 do begin
     keyw := wanted_search.keywords_title.str(i);
     crckey := wanted_search.keywords_title.id(i);
    Result := result+chr(1)+
                   chr(length(keyw))+
                   int_2_word_string(crckey)+
                   keyw;
  end;
 end;


 ////////////////////////////////////////////////////////artist
 if wanted_search.keywords_artist.count>0 then begin
  for i := 0 to wanted_search.keywords_artist.count-1 do begin
     keyw := wanted_search.keywords_artist.str(i);
     crckey := wanted_search.keywords_artist.id(i);
    Result := result+chr(2)+
                   chr(length(keyw))+
                   int_2_word_string(crckey)+
                   keyw;
  end;
 end;


 ////////////////////////////////////////////////////////album
 if wanted_search.keywords_album.count>0 then begin
  for i := 0 to wanted_search.keywords_album.count-1 do begin
     keyw := wanted_search.keywords_album.str(i);
     crckey := wanted_search.keywords_album.id(i);
    Result := result+chr(3)+
                   chr(length(keyw))+
                   int_2_word_string(crckey)+
                   keyw;
  end;
 end;


 ////////////////////////////////////////////////////////category
 if wanted_search.keywords_category.count>0 then begin
  for i := 0 to wanted_search.keywords_category.count-1 do begin
     keyw := wanted_search.keywords_category.str(i);
     crckey := wanted_search.keywords_category.id(i);
    Result := result+chr(4)+
                   chr(length(keyw))+
                   int_2_word_string(crckey)+
                   keyw;
  end;
 end;


 ////////////////////////////////////////////////////////date
 if length(wanted_search.keyword_date)>0 then begin
    Result := result+chr(5)+
                   chr(length(wanted_search.keyword_date))+
                   int_2_word_string(wanted_search.crcdate)+
                   wanted_search.keyword_date;
 end;


  ////////////////////////////////////////////////////////language
 if length(wanted_search.keyword_language)>0 then begin
    Result := result+chr(6)+
                   chr(length(wanted_search.keyword_language))+
                   int_2_word_string(wanted_search.crclanguage)+
                   wanted_search.keyword_language;
 end;


 //////////////////////////////////////////////////////// complex
 if length(complex)>=2 then Result := result+chr(7)+
                                           chr(length(complex))+
                                           complex;
end;

function tthread_supernode.local_search: Byte;
var
kw_min: PKeyword;
should_complex: Boolean;
sync: Integer;
p: PKeywordItem;
sh:precord_file_shared;
us: Tlocaluser;
first_part_result: string;
begin
result := MAX_RESULT_PER_SEARCH;

try
kw_min := trova_keyword_minima_search;
if kw_min=nil then exit; //nun ce sta...

//ho una weyword, ora parsiamola e confrontiamo i files...
p := kw_min^.firstitem;
if p=nil then exit;

SetLength(first_part_result,9);
 first_part_result[1] := CHRNULL;
 move(wanted_search.search_id[0],first_part_result[2],2);
 move(mylocalip_dword[1],first_part_result[4],4);
 move(my_tcp_port_word[1],first_part_result[8],2);

should_complex := ((wanted_search.sizecomp<>0) or
                 (wanted_search.param1comp<>0) or
                 (wanted_search.param3comp<>0));

sync := 0;


if ((wanted_search.lista_helper_result.count>1) or
               (wanted_search.strict) or
               (wanted_search.amime<=5)) then begin //serve controllo campi, avevo più di una keyword da trovare?
 while p<>nil do begin
          sh := p^.share;
            if not match_file_search(sh,should_complex) then begin
              inc(sync);
              if (sync mod 100)=30 then checksync;
              p := p^.next;
              continue;
            end;
          us := sh^.user;
                 if us<>GlobUser then begin
                       out_buffer_global := first_part_result+
                                          us.result_str+
                                          sh^.serialize;
                                send_back(MSG_SERVER_SEARCH_RESULT);

                       dec(result);
                       if result=0 then exit;
                  end;
              inc(sync);
              if (sync mod 100)=30 then checksync;
   //proseguiamo a prossima keyword?
  p := p^.next;
 end;

end else begin  //se ho solo una keyword e non ho complex
 while p<>nil do begin
          sh := p^.share;
          us := sh^.user;
                  if us<>GlobUser then begin
                     out_buffer_global := first_part_result+
                                        us.result_str+
                                        sh^.serialize;
                                send_back(MSG_SERVER_SEARCH_RESULT);

                      dec(result);
                       if result=0 then exit;

                  end;
           inc(sync);
           if (sync mod 100)=30 then checksync;
  p := p^.next;
 end;
end;  //fine se non ho complex



except
end;
end;

function tthread_supernode.match_file_search(pfile:precord_file_shared; should_complex:boolean): Boolean;
var
i,j: Integer;
found: Boolean;
begin
result := False;

   if wanted_search.amime<=5 then
    if wanted_search.amime<>pfile^.amime then exit; //il tipo è giusto(solo se richiede match tipo)?


   // ok ora cerchiamo le keyword, altrimenti è valida soltanto una delle trovate....
if not wanted_search.strict then begin   //se sono qui vuol dire che ho almeno una keyword quindi il controllo non serve
  for i := 0 to wanted_search.lista_helper_result.Count-1 do begin
  found := False;
    for j := 0 to pfile^.numkeywords-1 do begin
     if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result[i] then continue; //deve avere tutte le keyword!
       found := True;
       break;
    end;
    if not found then exit; // !!!!
  end;
result := True;
exit;
end;




    if should_complex then begin //ricerca complessa...
     if wanted_search.sizecomp>0 then begin
       case wanted_search.sizecomp of
        1: if pfile^.size>wanted_search.wantedsize then exit;
        2: if ((pfile^.size<wanted_search.wanted_size_avarage_min) or (pfile^.size>wanted_search.wanted_size_avarage_max)) then exit;
        3: if pfile^.size<wanted_search.wantedsize then exit;
       end;
     end;
     if wanted_search.param1comp>0 then begin
      if pfile^.param1=0 then exit; // non ho par
       case wanted_search.param1comp of
        1: if pfile^.param1>wanted_search.wantedparam1 then exit;
        2: if pfile^.param1<>wanted_search.wantedparam1 then exit;
        3: if pfile^.param1<wanted_search.wantedparam1 then exit;
       end;
      end;
      if wanted_search.param3comp>0 then begin
       if pfile^.param3=0 then exit; // non ho par
       case wanted_search.param3comp of
        1: if pfile^.param3>wanted_search.wantedparam3 then exit;
        2: if ((pfile^.param3<wanted_search.wanted_param3_avarage_min) or (pfile^.param3>wanted_search.wanted_param3_avarage_max)) then exit;
        3: if pfile^.param3<wanted_search.wantedparam3 then exit;
       end;
      end;
   end;

   

//qui siamo a strict, vediamo se le keyword combaciano ma allo specifico campo del file usando il campo keyword^.field
//match per field, prima si controlla keyword poi si controlla tipo field
 for i := 0 to wanted_search.lista_helper_result_title.count-1 do begin  ///match title?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_TITLE) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_title[i] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
 end;


 for i := 0 to wanted_search.lista_helper_result_artist.count-1 do begin  ///match artist?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_ARTIST) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_artist[i] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
  end;


  for i := 0 to wanted_search.lista_helper_result_album.count-1 do begin  ///match album?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_ALBUM) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_album[i] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
  end;


  for i := 0 to wanted_search.lista_helper_result_category.count-1 do begin  ///match album?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_CATEGORY) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_category[i] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
  end;


  if wanted_search.lista_helper_result_date.count>0 then begin  ///match album?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_DATE) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_date[0] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
  end;


  if wanted_search.lista_helper_result_language.count>0 then begin  ///match album?
         found := False;
         for j := 0 to pfile^.numkeywords-1 do begin
            if pfile^.keywords^[(j*3)+2]<>precord_field(rFIELD_LANGUAGE) then continue; //non è un titolo chissene del compare
              if pfile^.keywords^[j*3]<>wanted_search.lista_helper_result_language[0] then continue; //deve avere tutte le keywords!
              found := True;
              break;
         end;
         if not found then exit; //!!!!!
  end;


result := True;

end;


function tthread_supernode.trova_keyword_minima_search:pkeyword;
var
kwcrc: Word;
kw:pkeyword;
keyword: string;
i,count_precedente: Integer;
begin
result := nil;

try
count_precedente := 0;


////// SEARCH GENERAL AND EXIT
if not wanted_search.strict then begin
   for i := 0 to wanted_search.keywords_generali.count-1 do begin
      keyword := PNapCmd(wanted_search.keywords_generali.Items[i])^.cmd;
      kwcrc := PNapCmd(wanted_search.keywords_generali.Items[i])^.id;
       kw := KWList_Findkey(PChar(keyword),length(keyword),kwcrc);
       if kw=nil then begin
        Result := nil;
        exit; //nessun risultato!!!
       end;
      wanted_search.lista_helper_result.add(kw);
      if ((kw.count<count_precedente) or (count_precedente=0)) then begin
       Result := kw;
       count_precedente := kw.count;
      end;
   end;
  exit;
end;

except
exit;
end;



try


////// SEARCH TITLE
if wanted_search.keywords_title.count>0 then begin

    for i := 0 to wanted_search.keywords_title.count-1 do begin
       keyword := PNapCmd(wanted_search.keywords_title.Items[i])^.cmd;
       kwcrc := wanted_search.keywords_title.Id(i);
        kw := KWList_Findkey(PChar(keyword),length(keyword),kwcrc);
        if kw=nil then begin
         Result := nil;
         exit; //nessuno!
        end;
         wanted_search.lista_helper_result_title.add(kw);
         if ((kw.count<count_precedente) or (count_precedente=0)) then begin
          Result := kw;
          count_precedente := kw.count;
         end;
    end;
end;

////// SEARCH ARTISTS
if wanted_search.keywords_artist.count>0 then begin

    for i := 0 to wanted_search.keywords_artist.count-1 do begin
       keyword := PNapCmd(wanted_search.keywords_artist.Items[i])^.cmd;
       kwcrc := PNapCmd(wanted_search.keywords_artist.Items[i])^.id;
        kw := KWList_Findkey(PChar(keyword),length(keyword),kwcrc);
        if kw=nil then begin
         Result := nil;
         exit;
        end;
        wanted_search.lista_helper_result_artist.add(kw);
         if ((kw.count<count_precedente) or (count_precedente=0)) then begin
          Result := kw;
          count_precedente := kw.count;
         end;
    end;
end;

////// SEARCH ALBUMS
if wanted_search.keywords_album.count>0 then begin

    for i := 0 to wanted_search.keywords_album.count-1 do begin
       keyword := PNapCmd(wanted_search.keywords_album.Items[i])^.cmd;
       kwcrc := PNapCmd(wanted_search.keywords_album.Items[i])^.id;
       kw := KWList_Findkey(PChar(keyword),length(keyword),kwcrc);
       if kw=nil then begin
        Result := nil;
        exit;
       end;
       wanted_search.lista_helper_result_album.add(kw);
         if ((kw.count<count_precedente) or (count_precedente=0)) then begin
          Result := kw;
          count_precedente := kw.count;
         end;
    end;
end;

////// SEARCH CATEGORY
if wanted_search.keywords_category.count>0 then begin

    for i := 0 to wanted_search.keywords_category.count-1 do begin
       keyword := PNapCmd(wanted_search.keywords_category.Items[i])^.cmd;
       kwcrc := PNapCmd(wanted_search.keywords_category.Items[i])^.id;
        kw := KWList_Findkey(PChar(keyword),length(keyword),kwcrc);
        if kw=nil then begin
         Result := nil;
         exit;
        end;
        wanted_search.lista_helper_result_category.add(kw);
         if ((kw.count<count_precedente) or (count_precedente=0)) then begin
          Result := kw;
          count_precedente := kw.count;
         end;
    end;
end;

////// SEARCH DATE
if length(wanted_search.keyword_date)>=2 then begin

       kwcrc := wanted_search.crcdate;
       kw := KWList_Findkey(PChar(wanted_search.keyword_date),length(wanted_search.keyword_date),kwcrc);
       if kw=nil then begin
        Result := nil;
        exit;
       end;
       wanted_search.lista_helper_result_date.add(kw);
       if ((kw.count<count_precedente) or (count_precedente=0)) then begin
        Result := kw;
        count_precedente := kw.count;
       end;
end;

////// SEARCH LANGUAGE
if length(wanted_search.keyword_language)>=2 then begin

       kwcrc := wanted_search.crclanguage; //stringcrc(wanted_search^.keyword_language,true);
       kw := KWList_Findkey(PChar(wanted_search.keyword_language),length(wanted_search.keyword_language),kwcrc);
       if kw=nil then begin
        Result := nil;
        exit;
       end;
       wanted_search.lista_helper_result_language.add(kw);
       if ((kw.count<count_precedente) or (count_precedente=0)) then begin
        Result := kw;
        count_precedente := kw.count;
       end;
end;

except
exit;
end;
end;

procedure tthread_supernode.send_back_user(us: TLocalUser; cmd: Byte);
var
b: Word;
i: Integer;
lento,lenpkt,lencon: Word;
str,outstr: string;
begin
try

if us.encrypted_out then begin
  str := int_2_word_string(length(out_buffer_global))+
                         chr(cmd)+
                         out_buffer_global;

  SetLength(outstr,length(str));
  encrypt_buffer(@str[1],length(str),@outstr[1],us.outkey);

  us.out_buffer.add(outstr);
exit;
end;


if us.noCrypt then begin
  Us.out_buffer.add(int_2_word_string(length(out_buffer_global))+
                    chr(cmd)+
                    out_buffer_global);
exit;
end;


b := a1(my_sc,byte1_ransend,ff[my_ca]);

   lento := length(out_buffer_global);
   lenpkt := lento+5;
   lencon := lento+2;

     SetLength(str,lenpkt);  //allocazione

       move(lencon,str[1],2);
       str[3] := chr(cmd);
         str[4] := byte1_ransendchr[1];
         str[5] := byte1_ransendchr2[1];

         if lento>0 then
         for i :=  1 to Lento do begin  //criptiamo direttamente su buffer
           str[i+5] := char(byte(out_buffer_global[i]) xor (b shr 8));
           b := (byte(str[i+5]) + b) * 52845 + 22719;
         end;
       us.out_buffer.add(str);


except
end;
end;

procedure tthread_supernode.send_back(cmd: Byte);
var
b: Word;
i: Integer;
lento,lenpkt,lencon: Word;
 str,outstr: string;
begin
try

if GlobUser.encrypted_out then begin
  str := int_2_word_string(length(out_buffer_global))+
                         chr(cmd)+
                         out_buffer_global;

  SetLength(outstr,length(str));
  encrypt_buffer(@str[1],length(str),@outstr[1],GlobUser.outkey);

  GlobUser.out_buffer.add(outstr);
exit;
end;

if GlobUser.noCrypt then begin
 GlobUser.out_buffer.add(int_2_word_string(length(out_buffer_global))+
                         chr(cmd)+
                         out_buffer_global);
exit;
end;

b := a1(my_sc,byte1_ransend,ff[my_ca]);

   lento := length(out_buffer_global);
   lenpkt := lento+5;
   lencon := lento+2;

     SetLength(str,lenpkt);  //allocazione

       move(lencon,str[1],2);
       str[3] := chr(cmd);
         str[4] := byte1_ransendchr[1]; //chr(byte1);
         str[5] := byte1_ransendchr2[1]; //chr(random(250)+1);

         if lento>0 then
         for i :=  1 to Lento do begin  //criptiamo direttamente su buffer
           str[i+5] := char(byte(out_buffer_global[i]) xor (b shr 8));
           b := (byte(str[i+5]) + b) * 52845 + 22719;
         end;
       GlobUser.out_buffer.add(str);


except
end;
end;



procedure tthread_supernode.test_user_firewall_condition;
var
i,h,z: Integer;
us: Tlocaluser;
begin
try
    out_buffer_global := int_2_dword_string(GlobUser.ip)+
                       int_2_word_string(GlobUser.port);



for z := 1 to 5 do begin //proviamo un po' di volte?
 h := random(user_list.count);

  for i := h to user_list.count-1 do begin
   us := user_list[i];
    if us.disconnect then continue;
    if us=GlobUser then continue;

    send_back_user(us,MSG_CLIENT_USERFIREWALL_REQ);
    exit;
  end;

end;


 for i := user_list.count-1 downto 0 do begin  //in extremis
   us := user_list[i];
    if us.disconnect then continue;
    if us=GlobUser then continue;

    send_back_user(us,MSG_CLIENT_USERFIREWALL_REQ);
    exit;
 end;


except
end;
end;


function tthread_supernode.user_da_ip(ip: Cardinal): TLocalUser;
var
i: Integer;
us: Tlocaluser;
begin
result := nil;
try

for i := 0 to user_list.count-1 do begin
 us := user_list[i];

 if us.ip<>ip then continue;
   Result := us;
   exit;

end;

except
end;
end;

function tthread_supernode.user_da_ip_hash(ip: Cardinal; crc:word): TLocalUser;
var
us: Tlocaluser;
phas:phash;
item:phashitem;
begin
result := nil;
//logtime := 0;   // cerchiamo l'ultimo, ma ci va bene anche il primo
try




//perform immediatly an hash search  cerchiamo utente prima da hash sha1
phas := HashList_FindHashkey(crc);
if phas=nil then exit;

 item := phas^.firstitem;
 while (item<>nil) do begin
   us := item^.share^.user;  //utente nostro ha il file!     invia risultato per questo id a server
    if us.ip=ip then begin   //ok è lui?
       Result := us;
       exit;
    end;
  item := item^.next;
 end;



except
end;
end;



function tthread_supernode.handler_chat_push(usr:precord_socket_user; encrypted:boolean=true): Boolean;
var
us: TLocalUser;
 requested_ip: Cardinal;

 his_ip: Cardinal;
 his_ip_alt: Cardinal;
 his_tcp_port: Word;
 requested_randoms,str: string;
b: Word;
i: Integer;
buffer_backup: array [0..99] of Byte;
begin
result := False;
try
                                           //  ip,special,randoms , nick+cnull
if bytes_in_buffer<29 then exit;   //wrong size  4+1+16 +nick+null  +header
if bytes_in_buffer>100 then exit;
                               //viene usato ip integer da client per richiedere


//eliminate header
move(buffer_ricezione[3],buffer_backup[0],bytes_in_buffer-3);
dec(bytes_in_buffer,3);
move(buffer_backup[0],buffer_ricezione[0],bytes_in_buffer);

if encrypted then begin
//////////////////////////////////////////////primo decrypt globale tutto il pacchetto
  b := 20308;
  move(buffer_ricezione[0],buffer_backup[0],bytes_in_buffer);
  for I := 0 to bytes_in_buffer-1 do begin  //primo decifriamo globale
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//str := d2(strin,20308);    //3
//////////////////////////////////////////////////////////////////////
////////////////////////////////////////////decifriamo primi 6 caratteri con 15872
  b := 15872;
  move(buffer_ricezione[0],buffer_backup[0],6);
  for I := 0 to 5 do begin  //primo decifriamo globale
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//str := d2(strin,20308);    //3
/////////////////////////////////////////////

//////////////////////////////////////////// decifriamo da carattere 7 in poi con porta(passaggio #2)
  b := my_tcp_port;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(copy(str,7,length(str)),my_tcp_port); //4
//////////////////////////////////////////////////7
////////////////////////////////////////////////// decifriamo da carettere 7 con in2, passaggio#3
  b := in2_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in2);  //5
////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////decifriamo da carattere 7 con in1, passaggio#4
  b := in1_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in1);   //6
/////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////decifriamo nuovamente da carattere 7 con porta, passaggio#5
  b := my_tcp_port;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,my_tcp_port);  //7
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////decifriamo da carattere 7 con in2, passaggio#6
  b := in2_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in2);   //8
/////////////////////////////////////////////////////////////////////////7
//////////////////////////////////////////////////////////////////////////decifriamo da 7 con in1 passaggio#7
  b := in1_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in1);   //9
//////////////////////////////////////////////////////////////////////////7
end;


  Result := True;
  usr^.state := SOCKETUSR_FLUSHINPUSH;
  usr^.last := tim;

 his_ip := usr^.ip; // dell'utente richiedente....

 move(buffer_ricezione[0],requested_ip,4);
 move(buffer_ricezione[4],his_tcp_port,2);
 move(buffer_ricezione[6],his_ip_alt,4);

 SetLength(requested_randoms,16);
 move(buffer_ricezione[10],requested_randoms[1],16);

  us := user_da_ip(requested_ip); // non esiste utente richiesto
 if us=nil then begin
  str := '0000';
  move(str[1],usr^.outBuff[0],4);
  exit;
 end;
  checksync;

  str := 'UC';
  move(str[1],usr^.outBuff[0],2);
  move(us.Natport,usr^.outBuff[2],2);

    out_buffer_global := int_2_dword_string(his_ip)+
                       int_2_word_string(his_tcp_port)+
                       int_2_dword_string(his_ip_alt)+
                       requested_randoms;
    send_back_user(us,MSG_SERVER_PUSH_CHATREQ_NEW);  //mandiamo richiesta ad utente richiesto...


except
end;
end;


procedure tthread_supernode.fill_prelogin_buffer; //ogni 60 secondi...
var
str: string;
i: Integer;
num: Byte;
numW: Word;
b: Word;
sup: TSupernode;
avSuper:precord_availableSupernode;
begin
num := 0;

str := int_2_word_string(user_list.count)+
     my_fe+
     int_2_word_string(my_sc)+
     chr(my_ca);


if avSupernodes.count>20 then shuffle_mylist(avSupernodes,0);
for i := 0 to avSupernodes.count-1 do begin
  avSuper := avSupernodes[i];
  if avSuper.connects=0 then continue;
         str := str+
              int_2_dword_string(avSuper^.ip)+
              int_2_word_string(avSuper^.port);
     inc(num);
     if num>=19 then break;
end;




if num<10 then begin
 if LinkedSupernodes.count>1 then LinkedSupernodes.sort(sortSupLeastUsersFirst);
 //if LinkedSupernodes.count>20 then shuffle_myList(LinkedSupernodes,0);
 for i := 0 to LinkedSupernodes.count-1 do begin
  sup := LinkedSupernodes[i];
  if sup.state<>SYNCHED then continue;
           str := str+
                int_2_dword_string(sup.ip)+
                int_2_word_string(sup.port);
      inc(num);
      if num>19 then break;
 end;
end;

     b := my_tcp_port;
     for i := 1 to Length(str) do begin //encrypt e3a, lui decripterà per avere mio orinale fe!
        str[i] := char(byte(str[i]) xor (b shr 8));
        b := (byte(str[i]) + b) * 23712 + 5612;
     end;

  if length(str)+3>sizeof(pre_login_out_buffer) then delete(str,sizeof(pre_login_out_buffer)-2,length(str));

  str := int_2_word_string(length(str))+
       chr(MSG_SERVER_PRELGNOK)+
       str;
       
    move(str[1],pre_login_out_buffer[0],length(str));
    len_prelogin_out_buffer := length(str);


    
// Supernodes first log too
 numW := 135;
move(numW,supernode_prelogin[0],2);
supernode_prelogin[2] := MSG_SERVER_PRELOGIN_OK_NEWNET_LATEST;

numW := user_list.count;
 move(numW,supernode_prelogin[3],2);
numW := LinkedSupernodes.count;
 move(numW,supernode_prelogin[5],2);
 move(sup_unencrypted_login_key[1],supernode_prelogin[7],length(sup_unencrypted_login_key));
 move(my_sc,supernode_prelogin[135],2);
 supernode_prelogin[137] := my_ca;


end;



procedure tthread_supernode.super_handler_queryHashHit(sup: TSupernode);
var
us: TLocalUser;
tresult_id: Word;
begin
if bytes_in_buffer<31 then exit; //2id 4ip 2port 2nick+1null + 20 byte hash
if sup.state<>SYNCHED then exit;

try
move(buffer_ricezione[0],tresult_id,2);

if tresult_id>high(db_result_ids.bkt) then exit;
if db_result_ids.bkt[tresult_id]=nil then exit; //non ho l'utente richiedente

 us := db_result_ids.bkt[tresult_id];

 SetLength(out_buffer_global,bytes_in_buffer+5);
 out_buffer_global[1] := chr(1);
 move(sup.ip,out_buffer_global[2],4);
 move(sup.port,out_buffer_global[6],2);
 move(buffer_ricezione[2],out_buffer_global[8],bytes_in_buffer-2);

  send_back_user(us,MSG_SERVER_SEARCH_RESULT);    //usipdword + portword + numspec + nick+null + hash

except
end;
end;



function tthread_supernode.get_crypt_udp_key(const unenc_key: string): string;
var
str2,str1: string;
hic: Integer;
secH: Tsha1;
begin
result := '';
   //now expansion to 512 bytes  /////////////////////////////////////////////////////////
str2 := unenc_key;
for hic := 1 to 20 do begin
 str1 := chr(0)+str2+chr(255);
  secH := Tsha1.create;
  secH.Transform(str1[1],length(str1));
  secH.complete;
 str2 := Str2+secH.hashvalue;
  secH.Free;
end;
delete(str2,513,length(str2));
if length(str2)<512 then exit;
 //now pass to cypher

move(str2[1],buffer_ricezione_temp[0],sizeof(ac8));

ECE27561(@buffer_ricezione_temp[0]);


SetLength(str2,sizeof(ac8)+2);
 str2[1] := chr(0);
 move(buffer_ricezione_temp[0],str2[2],sizeof(ac8));
 str2[length(str2)] := chr(255);

  secH := Tsha1.create;
  secH.Transform(str2[1],length(str2));
  secH.complete;
 str1 := secH.hashvalue;
  secH.Free;

 Result := e64(str1,16932);   //fun last encryption
///////////////////////////////////////////////////////////////////////////////////////
end;

function tthread_supernode.handler_remote_relaychat_request(usr:precord_socket_user): Boolean;
var
 str,welcomePacket,nick1,nick2: string;
 ipC: Cardinal;
 portW,hisPortW: Word;
 sessionID: Cardinal;
 us: Tlocaluser;
 i: Integer;
 found: Boolean;
 aSocket:precord_relaying_socket;
begin
result := False;

if (bytes_in_buffer<8+(MIN_CHAT_NAME_LEN*2)) or  //35+3 header
   (bytes_in_buffer>60{MAX_NICK_LEN}) then begin
  usr^.state := SOCKETUSR_FLUSHINPUSH;
  usr^.outBuff[0] := CMD_RELAYING_SOCKET_OFFLINE;
  usr^.outBuff[1] := 0;
  usr^.outBuff[2] := 0;
  usr^.outBuff[3] := 0;
  exit;  //35+3 header
end;

//eliminate header
move(buffer_ricezione[3],sessionID,4);
move(buffer_ricezione[7],ipC,4);
move(buffer_ricezione[11],portW,2);
move(buffer_ricezione[13],HisPortW,2);

SetLength(str,bytes_in_buffer-14);
move(buffer_ricezione[15],str[1],length(str));
 nick1 := copy(str,1,pos(CHRNULL,str)-1);
  delete(str,1,pos(CHRNULL,str));
 nick2 := copy(str,1,pos(CHRNULL,str)-1);

 us := nil;
 found := False;
 for i := 0 to user_list.count-1 do begin
  us := user_list[i];
  if not us.supportDirectChat then continue;
  if us.ip<>ipC then continue;
  if us.port<>portW then continue;
  if us.nick<>nick1 then continue;
  found := True;
  break;
 end;

 if not found then begin
  usr^.state := SOCKETUSR_FLUSHINPUSH;
  usr^.outBuff[1] := CMD_RELAYING_SOCKET_OFFLINE;
  usr^.outBuff[1] := 0;
  usr^.outBuff[2] := 0;
  usr^.outBuff[3] := 0;
  exit;
 end;




 if us.relayingSockets=nil then us.relayingSockets := tmylist.create;
 aSocket := AllocMem(sizeof(record_relaying_socket));
  aSocket^.user := us;
  aSocket^.socket := usr^.socket;
  aSocket^.id := usr^.socket;
  aSocket^.bytes_in_header := 0;
  aSocket^.in_buffer := '';
  aSocket^.out_buffer := chr(CMD_RELAYING_SOCKET_START)+CHRNULL+CHRNULL+CHRNULL;
  aSocket^.lastOut := tim;
  aSocket^.lastIn := tim;
 us.relayingSockets.add(aSocket);
 listRelayingSockets.add(aSocket);
 

     welcomePacket := int_2_dword_string(aSocket^.id)+
                    int_2_dword_string(usr^.ip)+int_2_word_String(hisPortW)+
                    nick2+CHRNULL;

  us.out_buffer.Add(int_2_word_string(length(welcomePacket))+
                    chr(CMD_RELAYING_SOCKET_START)+
                    welcomePacket);


  Result := True; // yes remove it from the list
  FreeMem(usr,sizeof(record_socket_user));
end;

function tthread_supernode.handler_push(usr:precord_socket_user; encrypted:boolean=true): Boolean; // non criptato convenzionalmente ma da decifrare
var
 ip_richiesto: Cardinal;
 us: TLocalUser;
 str: string;
 i: Integer;
 b: Word;
 buffer_backup: array [0..99] of Byte;
begin
result := False;

try
if bytes_in_buffer<38 then exit;  //35+3 header
if bytes_in_buffer>100 then exit;

//eliminate header
move(buffer_ricezione[3],buffer_backup[0],bytes_in_buffer-3);
dec(bytes_in_buffer,3);
move(buffer_backup[0],buffer_ricezione[0],bytes_in_buffer);

if encrypted then begin
//////////////////////////////////////////////primo decrypt globale tutto il pacchetto
  b := 20308;
  move(buffer_ricezione[0],buffer_backup[0],bytes_in_buffer);
  for I := 0 to bytes_in_buffer-1 do begin  //primo decifriamo globale
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//str := d2(strin,20308);    //3
//////////////////////////////////////////////////////////////////////
////////////////////////////////////////////decifriamo primi 6 caratteri con 15872
  b := 15872;
  move(buffer_ricezione[0],buffer_backup[0],6);
  for I := 0 to 5 do begin  //primo decifriamo globale
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//str := d2(strin,20308);    //3
/////////////////////////////////////////////

//////////////////////////////////////////// decifriamo da carattere 7 in poi con porta(passaggio #2)
  b := my_tcp_port;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(copy(str,7,length(str)),my_tcp_port); //4
//////////////////////////////////////////////////7
////////////////////////////////////////////////// decifriamo da carettere 7 con in2, passaggio#3
  b := in2_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in2);  //5
////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////decifriamo da carattere 7 con in1, passaggio#4
  b := in1_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in1);   //6
/////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////decifriamo nuovamente da carattere 7 con porta, passaggio#5
  b := my_tcp_port;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,my_tcp_port);  //7
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////decifriamo da carattere 7 con in2, passaggio#6
  b := in2_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in2);   //8
/////////////////////////////////////////////////////////////////////////7
//////////////////////////////////////////////////////////////////////////decifriamo da 7 con in1 passaggio#7
  b := in1_decrypt;
  move(buffer_ricezione[6],buffer_backup[6],bytes_in_buffer-6);
  for I := 6 to bytes_in_buffer-1 do begin  //primo decifriamo globale dal 7ettimo carattere
        buffer_ricezione[I] := buffer_backup[I] xor (b shr 8);
        b := (buffer_backup[I] + b) * 52845 + 22719;
  end;
//strtemp := d2(strtemp,in1);   //9
//////////////////////////////////////////////////////////////////////////7
end;

  Result := True;

  usr^.state := SOCKETUSR_FLUSHINPUSH;
  usr^.last := tim;



 move(buffer_ricezione[0],ip_richiesto,4);

 us := user_da_ip(ip_richiesto); // only ip(9-11-2005), user_sharelist might not be available
 if us=nil then begin
  str := '0000';
  move(str[1],usr^.outBuff[0],4);
  exit;
 end else checksync;



   str := 'UP'+int_2_word_string(us.NATport);
   move(str[1],usr^.outBuff[0],4);
   


  SetLength(out_buffer_global,35);
   move(usr^.ip,out_buffer_global[1],4); // ip to
   move(buffer_ricezione[4],out_buffer_global[5],2);  // port to
   move(buffer_ricezione[6],out_buffer_global[7],20); // hash sha1
  out_buffer_global[27] := CHRNULL;
   move(buffer_ricezione[26],out_buffer_global[28],8);   // randoms 8 bytes

   send_back_user(us,MSG_SERVER_PUSH_REQ);



except
end;
end;


procedure tthread_supernode.assign_result_id(us: TLocalUser);
var
i: Integer;
begin

for i := low(db_result_ids.bkt) to high(db_result_ids.bkt) do
 if db_result_ids.bkt[i]=nil then begin
   us.result_id := i;
   db_result_ids.bkt[i] := us; //result forwarding
   break;
 end;

end;

procedure tthread_supernode.handler_login;
begin
if GlobUser.logtime<>0 then exit;

if bytes_in_buffer<32 then begin
 GlobUser.disconnect := True;
 exit;
end;
if bytes_in_buffer>250 then begin
 GlobUser.disconnect := True;
 exit;
end;

try

drop_clones_logged_ip(GlobUser);


GlobUser.logtime := tim;


move(buffer_ricezione[20],GlobUser.speed,2);
GlobUser.upload_count := buffer_ricezione[22];
GlobUser.max_uploads := buffer_ricezione[23];
GlobUser.queue_length := buffer_ricezione[25];
move(buffer_ricezione[26],GlobUser.port,2);

SetLength(content,bytes_in_buffer-28);
move(buffer_ricezione[28],content[1],bytes_in_buffer-28);  //copiamo qui...allocazione minore

GlobUser.nick := copy(content,1,pos(CHRNULL,content)-1); //allocazione
if length(GlobUser.nick)>MAX_NICK_LEN then delete(GlobUser.nick,MAX_NICK_LEN,length(GlobUser.nick));
delete(content,1,pos(CHRNULL,content));


   delete(content,1,sizeof(tguid)+2);  //remove guid+can be supern+i'm firewalled

   if length(content)>1 then begin
    GlobUser.agent := copy(content,1,pos(CHRNULL,content)-1) ;
    if length(GlobUser.agent)>20 then delete(GlobUser.agent,20,length(GlobUser.agent));

    if length(GlobUser.agent)<2 then begin
     GlobUser.agent := STR_UNKNOWNS;
     GlobUser.nick := STR_ANON+ip_to_hex_str(GlobUser.ip);
    end;
    
     delete(content,1,pos(CHRNULL,content));
    if length(content)>=4 then begin
     GlobUser.his_local_ip := copy(content,1,4);
     if length(content)>=5 then
      if content[5]=chr(CMD_TAG_SUPPORTDIRECTCHAT) then GlobUser.supportDirectChat := True;
     end else
      GlobUser.his_local_ip := ''; //estraiamo nuovi localip di fastweb?

   end else begin
    GlobUser.agent := STR_UNKNOWNS;
    GlobUser.nick := STR_ANON+ip_to_hex_str(GlobUser.ip);
    GlobUser.his_local_ip := '';
   end;


    checksync;

if length(GlobUser.nick)<4 then GlobUser.nick := STR_ANON+ip_to_hex_str(GlobUser.ip);
GlobUser.nick := strip_at(GlobUser.nick);

 evita_cloni_nick;  


checksync;



 out_buffer_global := STR_NULL_STATSTRING;
 send_back(MSG_SERVER_LOGIN_OK);



 out_buffer_global := GlobUser.nick+CHRNULL+chr(CMD_TAG_SUPPORTDIRECTCHAT);
 send_back(MSG_SERVER_YOUR_NICK);


 if GlobUser.result_id=-1 then assign_result_id(GlobUser);
 out_buffer_global := int_2_dword_string(GlobUser.ip)+
                    chr(0)+
                    int_2_word_string(GlobUser.NATport)+
                    int_2_word_string(GlobUser.result_id)+ // for UDP transfer protocol and UDP ping
                    int_2_word_string(my_buildnumber)+
                    int_2_word_string(vars_global.myport); // #3027 client DHTBootstrap
                    
 send_back(MSG_SERVER_YOUR_IP);
 


GlobUser.last_cache_patch := 0;


checksync;

check_agent;
//if isAntiP2PIP(GlobUser.ip) then GlobUser.shareBlocked := True;


  GlobUser.last_stats_click := tim; //must receive a stat_update packet from him within 5 minutes or it will be considered ghost
  GlobUser.num_special := $61; //firewalled? don't know yet

  GlobUser.result_hash_str := int_2_dword_string(GlobUser.ip)+
                            int_2_word_string(GlobUser.port)+
                            chr(GlobUser.num_special)+
                            GlobUser.nick+'@'+GlobUser.agent+CHRNULL;

  get_user_result_string(GlobUser); //attenzione va dopo Result hash str....



  test_user_firewall_condition;
except
end;

end;




procedure tthread_supernode.check_agent;
var
luseragent: string;
begin
   luseragent := lowercase(GlobUser.agent);
   if pos('warez lite',luseragent)<>0 then begin
    GlobUser.ShareBlocked := True;
   end else
   if pos('filecroc 1.50',luseragent)<>0 then begin
    GlobUser.shareblocked := True;
   end else
   if pos('ares lite',luseragent)<>0 then begin
    GlobUser.shareBlocked := True;
   end;
end;



procedure tthread_supernode.get_user_result_string(us: Tlocaluser);
var
newlen: Word;
begin
                   //assegnata in login, contiene ipdword,portword,numspecial e nick
newlen := length(us.result_hash_str)+5;
if length(us.result_str)<>newlen then SetLength(us.result_str,newlen);

move(us.result_hash_str[1],us.result_str[1],newlen-5);
move(us.speed,us.result_str[newlen-4],2);
 us.result_str[newlen-2] := chr(us.upload_count);
 us.result_str[newlen-1] := chr(us.max_uploads);
 us.result_str[newlen] := chr(us.queue_length);

end;


procedure tthread_supernode.drop_clones_logged_ip(us: Tlocaluser);
var
i: Integer;
begin

for i := 0 to user_list.count-1 do begin
   if TLocalUser(user_list[i]).socket=us.socket then continue;
   if TLocalUser(user_list[i]).ip=us.ip then TLocalUser(user_list[i]).disconnect := True;
end;

end;


procedure tthread_supernode.evita_cloni_nick;
var
i: Integer;
clone: Boolean;
us: Tlocaluser;
nick_us,str_add: string;
begin
try
nick_us := GlobUser.nick;
str_add := '';

repeat
clone := False;
 for i := 0 to user_list.count - 1 do begin
   us := user_list[i];
   if us=GlobUser then continue;
   if us.nick=nick_us+str_add then begin
    str_add := lowercase(inttohex(random($fd)+1,2));
    clone := True;
    break;
   end;
 end;
until (not clone);


GlobUser.nick := nick_us+str_add;
except
end;
end;

procedure tthread_supernode.handle_update_my_nick;
var
i: Integer;
begin

for i := 0 to bytes_in_buffer-1 do begin
 if buffer_ricezione[i]=0 then begin
   SetLength(GlobUser.nick,i);
   move(buffer_ricezione[0],GlobUser.nick[1],i);
 break;
 end;
end;

try
GlobUser.nick := strip_at(GlobUser.nick);
if length(GlobUser.nick)<4 then GlobUser.nick := STR_ANON+ip_to_hex_str(GlobUser.ip);

evita_cloni_nick;

out_buffer_global := GlobUser.nick+CHRNULL;
 send_back(5);

  GlobUser.result_hash_str := int_2_dword_string(GlobUser.ip)+
                            int_2_word_string(GlobUser.port)+
                            chr(GlobUser.num_special)+
                            GlobUser.nick+'@'+GlobUser.agent+CHRNULL;
  get_user_result_string(GlobUser);
except
end;
end;


procedure tthread_supernode.handler_add_hashrequest;
var
str,str1: string;
i: Integer;
crcsha1: Word;
us: Tlocaluser;
phas:phash;
item:phashitem;

copiata: Boolean;
sup: TSupernode;
begin
try

if bytes_in_buffer<21 then exit;

 //md4 := (buffer_ricezione[20]=1);

if buffer_ricezione[20]=1 then exit;


   move(buffer_ricezione[0],hash_generale_sha1[0],20);
   move(hash_generale_sha1[2],crcsha1,2);

         //eseguiamo nostra search locale, se troviamo qualcuno che ha il file mandiamo a citrone che ci ha mandato richiests
          phas := HashList_FindHashkey(crcsha1); //sha1!
          if phas<>nil then begin  //non trovato nulla
              i := 0;
               copiata := False;
                item := phas^.firstitem;
                 while (item<>nil) do begin
                  us := item^.share^.user;
                   if us<>GlobUser then begin
                      if not copiata then begin
                       SetLength(str1,20);
                       move(hash_generale_sha1[0],str1[1],20);
                       copiata := True;
                      end;

                      out_buffer_global := chr(1)+  //hash result
                                         mylocalip_dword+
                                         my_tcp_port_word+
                                         us.result_hash_str+
                                         str1+
                                         us.his_local_ip;
                        send_back(MSG_SERVER_SEARCH_RESULT);
                       inc(i);
                      if i>=MAX_HASHHIT_SUPERNODE then exit; // basta!!
                   end;
                    item := item^.next;
                  end;
            end;



            //send hash search
       if GlobUser.result_id=-1 then assign_result_id(GlobUser);

       SetLength(str,26);              //ora aggiorniamo nostri server
         str[1] := chr(23);  //lungezza payload 23 bytes
         str[2] := CHRNULL;
         str[3] := chr(MSG_LINKED_QUERYHASH_100);
         move(GlobUser.result_id,str[4],2);
         move(hash_generale_sha1[0],str[6],20);
         str[26] := CHRNULL;  //sha1!

         for i := 0 to LinkedSupernodes.count-1 do begin
           sup := LinkedSupernodes[i];
           if sup.state<>SYNCHED then continue;
           if sup.outBuffer.count>=MAX_LINKCONGESTION_TODROPHASHSEARCHES then continue;
           sup.outBuffer.add(str);
         end;


except
end;
end;

procedure tthread_supernode.handler_rem_hashrequest;
begin
if bytes_in_buffer<20 then exit;


end;



procedure tthread_supernode.handler_add_shared_key(nuovo:boolean);

   function KWList_AddShare(keyword: PKeyword; share: precord_file_shared): PKeywordItem;

        function KWList_ShareExists(keyword:PKeyword; share:precord_file_shared): Boolean;
        begin
        if keyword^.firstitem=nil then begin
         Result := False;
         exit;
        end;
         Result := (keyword^.firstItem^.share=share);  // can be only the first item
        end;

   begin

         if KWList_ShareExists(keyword,share) then begin
          Result := nil;
          exit;
         end;

     Result := AllocMem(sizeof(TKeywordItem));
     result^.next := keyword^.firstitem;  //agganciamo precedente nella lista
     if keyword^.firstitem<>nil then keyword^.firstitem^.prev := result; //se c'era diciamogli che siamo noi i primi ora
     result^.prev := nil;  //non abbiamo nessuno davanti
     keyword^.firstitem := result;  // e siamo i primi per la lista
     result^.share := share;
     inc(keyword^.count);
   end;

   function KWList_Addkey(keyword:pchar; lenkey: Byte; crc:word): PKeyword;
   var
   first:PKeyword;
   begin
    Result := AllocMem(sizeof(TKeyword));
    //Pointer(result^.keyword) := nil;

    SetLength(result^.keyword,lenkey);
    move(keyword^,result^.keyword[0],lenkey);
    
    //result^.keyword := keyword;
    result^.firstitem := nil;
    result^.count := 0; // numero di share presenti per search più efficiente!!!!!!
    result^.crc := crc;  // per compare in match_file e rimozione veloce in deleteshare
    
    first := db_keywords.bkt[crc mod DB_KEYWORD_ITEMS];
    result^.next := first;  //agganciamo precedente nella lista
    if first<>nil then first^.prev := result; //se c'era diciamogli che siamo noi i primi ora
    result^.prev := nil;  //non abbiamo nessuno davanti
    db_keywords.bkt[crc mod DB_KEYWORD_ITEMS] := result;  // e siamo i primi per la lista
   end;

   function KWList_Findkey_dabuffer(keyword:pchar; lenkey: Byte; crc:word): PKeyword;
   begin
    if db_keywords.bkt[crc mod DB_KEYWORD_ITEMS]=nil then begin
     Result := nil;
     exit;
    end;

    Result := db_keywords.bkt[crc mod DB_KEYWORD_ITEMS];
    while (result<>nil) do begin
        if length(result^.keyword)=lenkey then
         if comparemem(@result^.keyword[0],keyword,lenkey) then exit;
       Result := result^.next;
    end;
   end;

   procedure move_keywords_to_share(fsharef:precord_file_shared); //copiamo puntatori a keyword e a specifico punto in keyword, sul nostro file
   var
   j{,num}: Integer;
   begin
    //num := (lst_facility_keywords.count div 3);
    //item^.numkeywords := num;    //mettiamo keywords in share...
    ReallocMem(fsharef^.keywords, glb_lst_keywords.count * SizeOf(Pointer)); //memorizziamo solo quello che ci serve...
    for j := 0 to glb_lst_keywords.count-1 do fsharef^.keywords[j] := glb_lst_keywords.Items[j];
   end;
   
var
sharef:precord_file_shared;
param1,param2,param3,fsize: Cardinal;
amime: Byte;

crchash_sha1: Word;
posiz: Word;
len_keyword: Word;

lenkey: Byte;
crckey: Word;
keyword_buffer: array [0..KEYWORD_LEN_MAX-1] of Byte;

 
 kw: PKeyword;
 kwi: PKeywordItem;
 pfield: Pointer;
begin
 posiz := 0;
 amime := 0;
try

 if GlobUser.shareBlocked then exit;

 if GlobUser.shared_count>=MAX_FILES_SHARED_PERUSER then exit;

 if shared_count>=MAX_FILES_SHARED_PERSUPERNODE then exit;


if bytes_in_buffer<65 then exit;
if bytes_in_buffer>1024 then exit; //evitiamo qui files troppo ingombranti

move(buffer_ricezione[0],len_keyword,2);
if len_keyword>400 then exit; //troppe keywords?


move(buffer_ricezione[2],buffer_parse_keywords[0],len_keyword);

posiz := 2+len_keyword;
if posiz+39>bytes_in_buffer then exit;

if not nuovo then inc(posiz,16);  //vecchio skippiamo edonkey md4

move(buffer_ricezione[posiz],param1,4);
move(buffer_ricezione[posiz+4],param2,4);
move(buffer_ricezione[posiz+8],param3,4);
 amime := buffer_ricezione[posiz+12];
move(buffer_ricezione[posiz+13],fsize,4);

 inc(posiz,12);  //da qui in poi ho content str da conservare con allocazione per serialize

if amime>7 then exit;
if fsize=0 then exit;  //possible bug in clients?

amime := clienttype_to_shareservertype(amime);  //0 è tipo 0!


move(buffer_ricezione[posiz+5],hash_generale_sha1[0],20);
move(hash_generale_sha1[2],crchash_sha1,2);


except
end;
if not can_share_this_hash(GlobUser.ip,crchash_sha1) then exit;
    sharef := nil;
try
    sharef := AllocMem(sizeof(record_file_shared));
     sharef^.user := GlobUser;
     sharef^.amime := amime;
     sharef^.param1 := param1;
     sharef^.param2 := param2;
     sharef^.param3 := param3;
     sharef^.size := fsize;

    SetLength(sharef^.serialize,bytes_in_buffer-posiz); //copiamo serialize allocazione#1+hash
    move(buffer_ricezione[posiz],sharef^.serialize[1],bytes_in_buffer-posiz);

     sharef^.hashkey_sha1 := nil;
     sharef^.hashitem_sha1 := nil;
     sharef^.keywords := nil;
     sharef^.numkeywords := 0; //quante keywords ho?
   glb_lst_keywords.clear;
except
end;

try
if nuovo then begin  //nuovo ha crc wordhash e non ha due caratteri 3-4 che prima contenevano lettera iniziale e finale

  posiz := 0;
  while (posiz+5<len_keyword) do begin //parsiamo le keywords

   lenkey := buffer_parse_keywords[posiz+3];

   if lenkey>KEYWORD_LEN_MAX then begin
    inc(posiz,4+lenkey);
    continue; //akeyword di lunghezza eccessiva
   end;

   if lenkey<KEYWORD_LEN_MIN then break;
   if posiz+4+lenkey>len_keyword then break;


    case buffer_parse_keywords[posiz] of
     1:pfield := precord_field(rfield_title);
     2:pfield := precord_field(rfield_artist);
     3:pfield := precord_field(rfield_album);
     4:pfield := precord_field(rfield_category);
     5:pfield := precord_field(rfield_language);
     6:pfield := precord_field(rfield_date) else begin
      pfield := precord_field(rfield_title);
      break;
     end;
    end;


    move(buffer_parse_keywords[posiz+4],keyword_buffer[0],lenkey);


    if amime=5 then
     if ((lenkey=8) or (lenkey=13)) then
      if comparemem(@STR_ALBUMART[1],@keyword_buffer[0],8) then begin
       sharef^.serialize := '';
       FreeMem(sharef,sizeof(record_file_shared));
       exit;
      end;

     move(buffer_parse_keywords[posiz+1],crckey,2);


      kw := KWList_Findkey_dabuffer(@keyword_buffer[0],lenkey,crckey);
      if kw=nil then kw := KWList_Addkey(@keyword_buffer[0],lenkey,crckey);
      kwi := KWList_AddShare(kw,sharef); //mettiamo puntatori a share in keyword
       glb_lst_keywords.Add(kw);
       glb_lst_keywords.Add(kwi);
       glb_lst_keywords.Add(pfield);
       inc(sharef^.numkeywords);

     if glb_lst_keywords.count>=MAX_KEYWORDS3 then break; //ho già 12 keywords...
     
   inc(posiz,4+lenkey);
  end;

end else begin

 posiz := 0;
 while (posiz+7<len_keyword) do begin //parsiamo le keywords

   lenkey := buffer_parse_keywords[posiz+5];

   if lenkey>KEYWORD_LEN_MAX then begin
    inc(posiz,6+lenkey);
    continue; //akeyword di lunghezza eccessiva
   end;

   if lenkey<KEYWORD_LEN_MIN then break;
   if posiz+6+lenkey>len_keyword then break; //keyword segata non includiamo!

    case buffer_parse_keywords[posiz] of
     1:pfield := precord_field(rfield_title);
     2:pfield := precord_field(rfield_artist);
     3:pfield := precord_field(rfield_album);
     4:pfield := precord_field(rfield_category);
     5:pfield := precord_field(rfield_language);
     6:pfield := precord_field(rfield_date) else begin
      pfield := precord_field(rfield_title);
      break;
     end;
    end;

    //SetLength(keyword,lenkey);
    move(buffer_parse_keywords[posiz+6],keyword_buffer[0],lenkey);

    if amime=5 then
     if ((lenkey=8) or (lenkey=13)) then
      if comparemem(@STR_ALBUMART[1],@keyword_buffer[0],8) then begin
       sharef^.serialize := '';
       FreeMem(sharef,sizeof(record_file_shared));
       exit;
      end;

      crckey := whlbuff(@keyword_buffer[0],lenkey);

      kw := KWList_Findkey_dabuffer(@keyword_buffer[0],lenkey,crckey);
      if kw=nil then kw := KWList_Addkey(@keyword_buffer[0],lenkey,crckey);
      kwi := KWList_AddShare(kw,sharef); //mettiamo puntatori a share in keyword
       glb_lst_keywords.Add(kw);
       glb_lst_keywords.Add(kwi);
       glb_lst_keywords.Add(pfield);
       inc(sharef^.numkeywords);

     if glb_lst_keywords.count>=MAX_KEYWORDS3 then break; //ho già 12 keywords...

   inc(posiz,6+lenkey);
  end;
end; //endif nuovo

except
end;



try
  if sharef^.numkeywords=0 then begin   // no keywords!
    sharef^.serialize := '';
    FreeMem(sharef,sizeof(record_file_shared));
    exit;
   end;
except
end;

  //create keyword pointer list in sharef record
  try
  move_keywords_to_share(sharef);
  except
  end;

  ///add file in hash_sha1 table
  try
  add_hash_key(sharef, crchash_sha1);
   except
   end;

  try
  if GlobUser.shared_list=nil then GlobUser.shared_list := tmylist.create;
  GlobUser.shared_list.add(sharef); // add file in userlist



            inc(GlobUser.shared_count);
            //inc(loc_b_shared,sharef^.size);
            inc(shared_count);
            inc(GlobUser.shared_Size,fsize);


              if sharef^.amime=3 then
               if sharef^.size>734003200{700*MEGABYTE} then begin
                inc(GlobUser.NumbigVideos);

                   if GlobUser.NumBigVideos>30 then
                      if GlobUser.shared_size>32212254720{21474836480}{10737418240} then begin
                        GlobUser.shareBlocked := True;
                        //check_user_video;
                        Free_id_In_Shared_list(GlobUser,false);
                        exit;
                      end;
               end;

   
except
end;
end;


function tthread_supernode.check_user_video: Boolean;
begin
result := False;

end;

procedure tthread_supernode.add_hash_key(item:precord_file_shared; crc:word);
var
ph:phash;
phi:PHashItem;
begin

   ph := HashList_FindHashkey(crc);
   if ph=nil then ph := HashList_AddHashkey(crc);

   phi := KWList_AddSharehash(ph,item); //mettiamo puntatori a share in keyword

    item^.hashkey_sha1 := ph;
    item^.hashitem_sha1 := phi;

end;


function tthread_supernode.can_share_this_hash(ip: Cardinal; crc:word): Boolean;
var
ph:phash;
item:phashitem;
us: Tlocaluser;
begin
result := True;

   ph := HashList_FindHashkey(crc);
   if ph=nil then exit;

   if ph^.count>=MAX_HASHHIT_SUPERNODE_PLUS10 then begin
    Result := False;
    exit;
   end;

 item := ph^.firstitem;
 while (item<>nil) do begin
   us := item^.share^.user;
    if us.ip=ip then begin   
       Result := False;
       exit;
    end;
  item := item^.next;
 end;

end;



procedure tthread_supernode.handler_rem_shared;
begin
try
if GlobUser.shared_count=0 then exit;

 if bytes_in_buffer=0 then free_id_in_shared_list(GlobUser,false);


except
end;
end;

procedure tthread_supernode.handler_compressed;
var
len: Word;
i: Integer; //per sync
 buffer: Pointer;
 size: Integer;
 //a: Integer;
  cmd: Byte;
begin
try

if not ZDecompress(@buffer_ricezione[0],bytes_in_buffer,buffer,size) then begin
exit; //allocazione
end;

checksync;

i := 0;
//a := 0;
while (true) do begin
 if i+3>=size then break;

 move(pbytearray(buffer)[i],len,2);
   if len<700 then begin  //massimo compress da 1 k! dovrebbe essere molto meno

     if i+3+len<=size then begin
     
      fillchar(buffer_ricezione,len,0);
      cmd := pbytearray(buffer)[i+2];
      move(pbytearray(buffer)[i+3],buffer_ricezione[0],len);
      bytes_in_buffer := len;

      process_command2(cmd);

      inc(i,len+3);

      if GlobUser.disconnect then break;

      //inc(a);
      //if (a mod 10)=0 then checksync;
     end else break;

   end else break;
end;

FreeMem(buffer,size);
except
end;
end;


procedure tthread_supernode.handler_status;
begin
if bytes_in_buffer<4 then exit;
//if tim-GlobUser.last_stats_click<15000 then exit;

try
GlobUser.upload_count := buffer_ricezione[0];
GlobUser.max_uploads := buffer_ricezione[1];
GlobUser.queue_length := buffer_ricezione[3];


if bytes_in_buffer>6 then begin
 move(buffer_ricezione[4],GlobUser.speed,2);
// user.accepted_connections := buffer_ricezione[6];
end else begin
 //user.accepted_connections := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////
    get_user_result_string(GlobUser); //attenzione va dopo Result hash str....
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



GlobUser.last_stats_click := tim;
checksync;



  out_buffer_global := STR_NULL_STATSTRING+
                     get_4_servers_str;
  send_back(MSG_SERVER_STATS);


except
end;
end;




procedure tthread_supernode.accept;
var
h: TSocket;
usr:precord_socket_user;
ipi: Cardinal;
sin:synsock.TSockAddrIn;
i: Byte;
begin
 try



 i := 0;
 while server_socket_tcp.CanRead(0) do begin

    h := server_socket_tcp.accept;

      if h=SOCKET_ERROR then exit;
      if h=INVALID_SOCKET then exit;

   inc(i);
   TCPSocket_Block(h,false);

   if user_list.count+socket_list.count>ACCEPT_HARD_LIMIT then begin
      TCPSocket_Free(H);
      exit;
   end;



   sin := TCPSocket_GetRemoteSin(h);
   ipi := Sin.sin_addr.S_addr;

  if isAntiP2PIP(ipi) then begin
   TCPSocket_Free(H);
   exit;
  end;
  

     if count_clones_ip(ipi)>MAX_CONNECTIONS_PER_IP then begin
       TCPSocket_Free(H);
       continue;
      end;


     usr := AllocMem(sizeof(record_socket_user));
      usr^.socket := h;
      usr^.ip := ipi;
      usr^.last := tim;
      usr^.NatPort := synsock.ntohs(Sin.sin_port);
      usr^.state := SOCKETUSR_WAITINGFIRST;
      usr^.encrypted_in := False;
      usr^.encrypted_out := False;
       socket_list.add(usr);


  if i>5 then break;
 end;

 except
 end;
end;



procedure tthread_supernode.CheckSync;
var
t: Integer;
begin
 t := (GetTickCount xor 50) mod 200;
 if t>150 then exit;
 if t<10 then sleep(25)
 else if t<40 then sleep(10)
 else if t<80 then sleep(3)
 else sleep(0);
end;

function tthread_supernode.count_clones_ip(ip: Cardinal): Word;
var
i: Integer;
usr:precord_socket_user;
begin
result := 0;

try

for i := 0 to user_list.count-1 do begin
 if TLocalUser(user_list[i]).ip=ip  then inc(result);
end;

for i := 0 to socket_list.count-1 do begin
 usr := socket_list[i];
  if usr.ip=ip then inc(result);
end;

except
end;
end;


procedure tthread_supernode.receive_users;
var
i: Integer;
begin
try

i := 0;

while (i<user_list.count) do begin
  if terminated then exit;
  if (i mod 20)=10 then checksync;
try

Globuser := user_list[i];  // goes global

 if Globuser.disconnect then begin //free user object here TODO class recycle factory to reduce heap fragmentation
    user_list.delete(i);
       if Globuser.result_id<>-1 then begin
         if db_result_ids.bkt[GlobUser.result_id]=GlobUser then db_result_ids.bkt[GlobUser.result_id] := nil
          else begin

         end;
       end;


       try
       free_user_stuff(Globuser,false);
       except
       end;
       GlobUser.Free;

      continue;
 end;

receive_user;

except
end;

inc(i);


end;

except
end;
end;


procedure tthread_supernode.generate_hashwordkey(var inkey: Word; sizein:integer);
var
sha1: Tsha1;
str: string;
b1,b2,b3,b4: Word;
begin
//process salt_global[]
//if bytes_in_buffer<=12 then //only salt  (max 12 bytes salt key, don't touch the rest)
 sha1 := tsha1.create;
  sha1.Transform(salt_global[0],sizein);
 sha1.Complete;
  str := sha1.HashValue;
 sha1.Free;

 move(str[4],b1,2);
 move(str[8],b2,2);
 move(str[12],b3,2);
 move(str[16],b4,2);

 inKey := b1+b2+b3+b4;
end;

procedure tthread_supernode.decrypt_buffer(inbuff: Pointer; len: Integer; outbuff: Pointer; var inkey:word);
type
 pbytearray=^bytearray;
 bytearray=array [0..1] of Byte;
var
 i: Integer;
begin
//decrypt buffer with given inKey (return shifted inKey)

    for i := 0 to len-1 do begin
        pbytearray(PChar(outbuff)+i)^[0] := byte(pbytearray(PChar(inbuff)+i)^[0] xor (inKey shr 8));
        inKey := (pbytearray(PChar(inbuff)+i)^[0] + inKey) * 52845 + 22719;
    end;
end;

procedure tthread_supernode.encrypt_buffer(inbuff: Pointer; len: Integer; outbuff: Pointer; var outkey:word);
type
 pbytearray=^bytearray;
 bytearray=array [0..1] of Byte;
var
 i: Integer;
begin
//encrypt buffer with given outKey (return shifted outKey)
move(inbuff^,outbuff^,len);

    for i := 0 to len-1 do begin
        pbytearray(PChar(outbuff)+i)^[0] := byte(pbytearray(PChar(inbuff)+i)^[0] xor (outKey shr 8));
        outKey := (pbytearray(PChar(outbuff)+i)^[0] + outKey) * 52845 + 22719;
    end;
end;


procedure tthreaD_supernode.gen_out_key;
var
i,ran: Integer;
sha1: Tsha1;
b1,b2,b3,b4: Word;
str: string;
begin
my_salt_key_str := '';

ran := random((MAXLENSALT-MINLENSALT)+1)+MINLENSALT; // len between 6 and 22
for i := 1 to ran do begin
 my_salt_key_str := my_salt_key_str+chr(random(256));
end;

 sha1 := tsha1.create;
  sha1.Transform(my_salt_key_str[1],length(my_salt_key_str));
 sha1.Complete;
  str := sha1.HashValue;
 sha1.Free;

 move(str[4],b1,2);
 move(str[8],b2,2);
 move(str[12],b3,2);
 move(str[16],b4,2);

 my_key_out := b1+b2+b3+b4;

end;


procedure tthread_supernode.receive_sockets;
var
i,er,len: Integer;
usr:precord_socket_user;
len_payload: Word;
us: TlocalUser;
begin

i := 0;
while (i<socket_list.count) do begin
    usr := socket_list[i];

    if tim-usr^.last>15000 then begin
     socket_list.delete(i);
     TCPSocket_Free(usr^.socket);
     FreeMem(usr,sizeof(record_socket_user));
     continue;
    end;


    
    case usr.state of


      SOCKETUSR_FLUSHING_MY_SALTKEY:begin
                                  TcpSocket_SendBuffer(usr^.socket,@my_salt_key_str[1],length(my_salt_key_str),er);
                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  usr.last := tim;
                                  usr^.outKey := my_key_out;
                                  usr^.state := SOCKETUSER_WAITINGFIRSTCRYPT;
                          end;



      SOCKETUSER_WAITINGFIRSTCRYPT:begin
                                  if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                                   if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                    socket_list.delete(i);
                                    TCPSocket_Free(usr^.socket);
                                    FreeMem(usr,sizeof(record_socket_user));
                                    continue;
                                   end;
                                   inc(i);
                                   continue;
                                  end;
                                  len := TCPSocket_RecvBuffer(usr^.socket,@Buffer_ricezione,sizeof(salt_global),er); //maximum length of packet=35 (push)
                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  if len<3 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;

                                  bytes_in_buffer := len;

                                  decrypt_buffer(@buffer_ricezione[0],bytes_in_buffer,@buffer_ricezione_temp[0],usr^.inKey);
                                  move(buffer_ricezione_temp[0],len_payload,2);

                                  if bytes_in_buffer-3<>len_payload then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  usr^.last := tim;
                                  case buffer_ricezione_temp[2] of
                                   MSG_CLIENT_FIRST_LOG:begin
                                                         usr^.state := SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT
                                                        end;
                                   MSG_SUPERNODE_FIRST_LOG:begin
                                                            socket_list.delete(i);
                                                            TCPSocket_Free(usr^.socket);
                                                            FreeMem(usr,sizeof(record_socket_user));
                                                            continue;
                                                           end else begin
                                                            socket_list.delete(i);
                                                            TCPSocket_Free(usr^.socket);
                                                            FreeMem(usr,sizeof(record_socket_user));
                                                            continue;
                                                           end;
                                  end;
                                end;



      SOCKETUSR_WAITINGFIRST:begin        //waiting for user input...
                          if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                 socket_list.delete(i);
                                 TCPSocket_Free(usr^.socket);
                                 FreeMem(usr,sizeof(record_socket_user));
                             end else inc(i);
                           continue;
                          end;                                                         //60 bytes
                          len := TCPSocket_RecvBuffer(usr^.socket,@Buffer_ricezione,sizeof(salt_global),er); //maximum length of packet=35 (push)
                          if er=WSAEWOULDBLOCK then begin
                           inc(i);
                           continue;
                          end;
                          if er<>0 then begin
                            socket_list.delete(i);
                            TCPSocket_Free(usr^.socket);
                            FreeMem(usr,sizeof(record_socket_user));
                            continue;
                          end;
                          if len<3 then begin  //missing comand len
                            socket_list.delete(i);
                            TCPSocket_Free(usr^.socket);
                            FreeMem(usr,sizeof(record_socket_user));
                            continue;
                          end;
                          bytes_in_buffer := len;
                          move(buffer_ricezione[0],len_payload,2);

                    //////////////////////////////////////////////////////////////////////
                          if bytes_in_buffer-3<>len_payload then begin //receive request size mismatch, we need to get all at once
                              if bytes_in_buffer>=MINLENSALT then begin
                               usr^.encrypted_in := True;

                                move(buffer_ricezione[0],salt_global[0],bytes_in_buffer);
                                generate_hashwordkey(usr^.inkey,bytes_in_buffer);

                               if bytes_in_buffer<=MAXLENSALT then begin  //only salt key, both sides encrypts
                                usr^.last := tim;
                                usr^.encrypted_out := True;
                                usr^.state := SOCKETUSR_FLUSHING_MY_SALTKEY;
                                inc(i);
                                continue;
                               end;

                               decrypt_buffer(@buffer_ricezione[MINLENSALT],bytes_in_buffer-MINLENSALT,@buffer_ricezione_temp[0],usr^.inkey);
                               move(buffer_ricezione_temp[0],buffer_ricezione[0],bytes_in_buffer-MINLENSALT);

                             end else begin     //wrong size len <6
                              socket_list.delete(i);
                              TCPSocket_Free(usr^.socket);
                              FreeMem(usr,sizeof(record_socket_user));
                              continue;
                             end;
                             
                          end;
                     //////////////////////////////////////////////////////////////////////

                          usr^.last := tim;

                            case buffer_ricezione[2] of    //possible commands

                               MSG_SUPERNODE_FIRST_LOG:begin   //if this goes encrypted(oneway) payload must be bigger than MAXLENSALT-MINLENSALT
                                                        if linkedToSupernode(usr^.ip) then begin
                                                         usr^.outBuff[0] := 1;
                                                         usr^.outBuff[1] := 0;
                                                         usr^.outBuff[2] := 0;
                                                         usr^.outBuff[3] := 0;
                                                         usr^.state := SOCKETUSR_FLUSHINPUSH;
                                                        end else begin
                                                         usr^.state := SOCKETUSR_FLUSHIN_SUPERNODEFIRSTLOG;
                                                        end;
                                                       end;

                               CMD_RELAYING_SOCKET_REQUEST:begin
                                if handler_remote_relaychat_request(usr) then socket_list.delete(i);
                                continue;
                               end;

                               MSG_CLIENT_FIRST_LOG:begin   //if this goes encrypted(oneway) payload must be bigger than MAXLENSALT-MINLENSALT
                                    if len_payload>=3 then begin
                                      if buffer_ricezione[5]<>CHAR_MARKER_NEWSTACK then begin  //without this there are only very old versions
                                       usr^.outBuff[0] := 1;
                                       usr^.outBuff[1] := 0;
                                       usr^.outBuff[2] := 0;
                                       usr^.outBuff[3] := 0;
                                       usr^.state := SOCKETUSR_FLUSHINPUSH;
                                      end else begin
                                         if ((buffer_ricezione[3]=CHAR_MARKER_NOCRYPT) and (buffer_ricezione[4]=CHAR_MARKER_NOCRYPT)) then usr^.state := SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT  // starting from oct 25th 2005 new clients tag byte[4] of preloginReq's payload with 0x6 to signal they handle 'plaintext' session
                                          else usr^.state := SOCKETUSR_FLUSHINFIRSTLOG;
                                      end;
                                    end else begin  // too short prelogin payload?
                                      usr^.outBuff[0] := 1;
                                      usr^.outBuff[1] := 0;
                                      usr^.outBuff[2] := 0;
                                      usr^.outBuff[3] := 0;
                                      usr^.state := SOCKETUSR_FLUSHINPUSH;
                                    end;
                                   end;

                                MSG_CLIENT_PUSH_REQ,
                                MSG_CLIENT_PUSH_REQNOCRYPT:begin   // criptato in modo diverso
                                    if not handler_push(usr,(buffer_ricezione[2]=MSG_CLIENT_PUSH_REQ)) then begin
                                      socket_list.delete(i);
                                      TCPSocket_Free(usr^.socket);
                                      FreeMem(usr,sizeof(record_socket_user));
                                      continue;
                                    end;
                                  end;

                                MSG_CLIENT_CHAT_NEWPUSH,
                                MSG_CLIENT_CHAT_NEWPUSHNOCRYPT:begin
                                    if not handler_chat_push(usr,(buffer_ricezione[2]=MSG_CLIENT_CHAT_NEWPUSH))then begin
                                      socket_list.delete(i);
                                      TCPSocket_Free(usr^.socket);
                                      FreeMem(usr,sizeof(record_socket_user));
                                      continue;
                                    end;

                                  end else begin
                                    socket_list.delete(i);
                                    TCPSocket_Free(usr^.socket);
                                    FreeMem(usr,sizeof(record_socket_user));
                                    continue;
                                  end;

                            end;
                       end;

      SOCKETUSR_FLUSHIN_SUPERNODEFIRSTLOG:begin
                                  TCPSocket_SendBuffer(usr^.socket,@supernode_prelogin[0],sizeof(supernode_prelogin),er);
                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  usr^.last := tim;
                                  usr^.state := SOCKETUSR_RECEIVING_SUPERNODE_LOGINHEADER;
                                end;

      SOCKETUSR_RECEIVING_SUPERNODE_LOGINHEADER:begin
                                  if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                                   if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                     socket_list.delete(i);
                                     TCPSocket_Free(usr^.socket);
                                     FreeMem(usr,sizeof(record_socket_user));
                                   end else inc(i);
                                   continue;
                                  end;
                                  len := TCPSocket_RecvBuffer(usr^.socket,@buffer_ricezione[0],3,er);
                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                    socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  if len<>3 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  if buffer_ricezione[2]<>MSG_SUPERNODE_SECOND_LOG then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  move(buffer_ricezione[0],usr^.len_payload,2);
                                  if usr^.len_payload>180 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  usr^.state := SOCKETUSR_RECEIVING_SUPERNODE_LOGINPAYLOAD;
                                  usr^.last := tim;
                                end;


      SOCKETUSR_RECEIVING_SUPERNODE_LOGINPAYLOAD:begin
                                  if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                                   if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                     socket_list.delete(i);
                                     TCPSocket_Free(usr^.socket);
                                     FreeMem(usr,sizeof(record_socket_user));
                                   end else inc(i);
                                   continue;
                                  end;
                                  len := TCPSocket_RecvBuffer(usr^.socket,@buffer_ricezione[0],usr^.len_payload,er);
                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                    socket_list.delete(i);
                                    TCPSocket_Free(usr^.socket);
                                    FreeMem(usr,sizeof(record_socket_user));
                                    continue;
                                  end;
                                  if len<>usr^.len_payload then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                  usr^.last := tim;

                                  if LinkedSupernodes.count>NUM_MAXSUPERNODES_LINKED+20 then begin  //40..60
                                       usr^.outBuff[0] := 2;
                                       usr^.outBuff[1] := 0;
                                       usr^.outBuff[2] := 0;
                                       usr^.outBuff[3] := 0;
                                       usr^.state := SOCKETUSR_FLUSHINPUSH;
                                     inc(i);
                                     continue;
                                  end;

                                  if isAntiP2PIP(usr^.ip) then begin
                                       usr^.outBuff[0] := 13;
                                       usr^.outBuff[1] := 0;
                                       usr^.outBuff[2] := 0;
                                       usr^.outBuff[3] := 0;
                                       usr^.state := SOCKETUSR_FLUSHINPUSH;
                                     inc(i);
                                     continue;
                                  end;

                                  if linkedToSupernode(usr^.ip) then begin
                                     usr^.outBuff[0] := 1;
                                     usr^.outBuff[1] := 0;
                                     usr^.outBuff[2] := 0;
                                     usr^.outBuff[3] := 0;
                                     usr^.state := SOCKETUSR_FLUSHINPUSH;
                                     inc(i);
                                     continue;
                                  end;

                                   if not CompareMem(@buffer_ricezione[0],@sup_encrypted_login_key[1],length(sup_encrypted_login_key)) then begin
                                       usr^.outBuff[0] := 3;
                                       usr^.outBuff[1] := 0;
                                       usr^.outBuff[2] := 0;
                                       usr^.outBuff[3] := 0;
                                       usr^.state := SOCKETUSR_FLUSHINPUSH;
                                     inc(i);
                                     continue;
                                   end;

                                   Generate_new_Accepted_supernode(usr^.socket,usr^.ip);


                                  socket_list.delete(i);
                                  usr^.socket := INVALID_SOCKET;
                                  FreeMem(usr,sizeof(record_socket_user));

                                  continue;
                                end;

                                

      SOCKETUSR_FLUSHINFIRSTLOG,
      SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT:begin       // sending firstlog reply
                                    if user_list.count>=HASH_SUPERNODE_ALLOWED_USERS then begin
                                     pre_login_out_buffer[2] := MSG_SERVER_PRELOGFAILLOGBUSY;
                                    end else begin
                                      if usr^.state=SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT then pre_login_out_buffer[2] := MSG_SERVER_PRELGNOKNOCRYPT
                                       else pre_login_out_buffer[2] := MSG_SERVER_PRELGNOK;
                                     end;

                                  if usr^.encrypted_out then begin
                                    encrypt_buffer(@pre_login_out_buffer[0],len_prelogin_out_buffer,@buffer_ricezione_temp[0],usr^.outKey);
                                    TCPSocket_SendBuffer(usr^.socket,@buffer_ricezione_temp[0],len_prelogin_out_buffer,er);
                                  end else TCPSocket_SendBuffer(usr^.socket,@pre_login_out_buffer[0],len_prelogin_out_buffer,er);

                                  if er=WSAEWOULDBLOCK then begin
                                   inc(i);
                                   continue;
                                  end;
                                  if er<>0 then begin
                                   socket_list.delete(i);
                                   TCPSocket_Free(usr^.socket);
                                   FreeMem(usr,sizeof(record_socket_user));
                                   continue;
                                  end;
                                usr^.last := tim;

                                   //continue with handshaking
                                 if pre_login_out_buffer[2]=MSG_SERVER_PRELOGFAILLOGBUSY then usr^.state := SOCKETUSR_FLUSHEDPUSH
                                  else
                                   if usr^.state=SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT then usr^.state := SOCKETUSR_RECEIVINGLOGINREQNOCRYPT
                                    else
                                     usr^.state := SOCKETUSR_RECEIVINGLOGINREQ;
                          end;


      SOCKETUSR_FLUSHINPUSH:begin          // sending 4 byte push reply
                         TCPSocket_SendBuffer(usr^.socket,@usr^.outbuff[0],4,er);
                         if er=WSAEWOULDBLOCK then begin
                          inc(i);
                          continue;
                         end;
                         if er<>0 then begin
                           socket_list.delete(i);
                           TCPSocket_Free(usr^.socket);
                           FreeMem(usr,sizeof(record_socket_user));
                           continue;
                         end;
                         usr^.last := tim;
                         usr^.state := SOCKETUSR_FLUSHEDPUSH;
                       end;


      SOCKETUSR_FLUSHEDPUSH:begin
                        if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                         if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                           socket_list.delete(i);
                           TCPSocket_Free(usr^.socket);
                           FreeMem(usr,sizeof(record_socket_user));
                         end else inc(i);
                         continue;
                        end;
                        TCPSocket_RecvBuffer(usr^.socket,@buffer_ricezione[0],1,er);
                        if er=WSAEWOULDBLOCK then begin
                         inc(i);
                         continue;
                        end;
                   //either we got few data from a connection which isn't allowed to send anymore, or we got a receive error (connection reset by peer)
                           socket_list.delete(i);
                           TCPSocket_Free(usr^.socket);
                           FreeMem(usr,sizeof(record_socket_user));
                           continue;
                       end;


      SOCKETUSR_RECEIVINGLOGINREQ,
      SOCKETUSR_RECEIVINGLOGINREQNOCRYPT:begin        // we need the first 3 bytes of the loginreq header
                          if not TCPSocket_CanRead(usr^.socket,0,er) then begin
                            if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                 socket_list.delete(i);
                                 TCPSocket_Free(usr^.socket);
                                 FreeMem(usr,sizeof(record_socket_user));
                            end else inc(i);
                           continue;
                          end;
                          len := TCPSocket_RecvBuffer(usr^.socket,@Buffer_ricezione,3,er);
                          if er=WSAEWOULDBLOCK then begin
                           inc(i);
                           continue;
                          end;
                          if er<>0 then begin
                             socket_list.delete(i);
                             TCPSocket_Free(usr^.socket);
                             FreeMem(usr,sizeof(record_socket_user));
                             continue;
                          end;
                          if len<>3 then begin
                             socket_list.delete(i);
                             TCPSocket_Free(usr^.socket);
                             FreeMem(usr,sizeof(record_socket_user));
                             continue;
                          end;

                          if usr^.encrypted_in then begin
                           decrypt_buffer(@buffer_ricezione[0],3,@buffer_ricezione_temp[0],usr^.inKey);
                            buffer_ricezione[0] := buffer_ricezione_temp[0];
                            buffer_ricezione[1] := 0;  // no need to send this (stay below 255 bytes payload)
                            buffer_ricezione[2] := MSG_CLIENT_LOGIN_REQ; // no need to send this
                          end else
                          if buffer_ricezione[2]<>MSG_CLIENT_LOGIN_REQ then begin
                             socket_list.delete(i);
                             TCPSocket_Free(usr^.socket);
                             FreeMem(usr,sizeof(record_socket_user));
                             continue;
                          end;
                          
                            us := TLocalUSer.create;
                             us.socket := usr^.socket;
                             us.logtime := 0; //allow to logon once
                             us.ip := usr^.ip;
                             us.NATport := usr^.NATPort;
                             us.noCrypt := (usr^.state=SOCKETUSR_RECEIVINGLOGINREQNOCRYPT);
                              us.encrypted_in := usr^.encrypted_in;
                              us.encrypted_out := usr^.encrypted_out;
                              us.inkey := usr^.inkey;
                              us.outkey := usr^.outkey;
                             us.bytes_in_header := 3;
                              move(buffer_ricezione[0],us.buffer_header_ricezione,3);
                             user_list.add(us);

                            socket_list.delete(i);
                            FreeMem(usr,sizeof(record_socket_user));
                       end;

    end;

inc(i);
end;

end;

procedure tthread_supernode.receive_user(cycle: Byte=0);   //qui andiamo sul socket e teniamo basso il buffer...in server andiamo di memoria invece...
var
er: Integer;
to_receive: Word;
len: Integer;
previous_len: Integer;
begin

 try

 if GlobUser.out_buffer.count>0 then flush_tcp;   //max 5 flush

 //if GlobUser.out_buffer.count>50 then exit; 

 if GlobUser.disconnect then exit;


 if not TCPSocket_CanRead(GlobUser.socket,0,er) then begin
   if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
    GlobUser.disconnect := True;
   end;
    exit;
 end;


 if GlobUser.bytes_in_header<3 then begin
    len := TCPSocket_RecvBuffer(GlobUser.socket,@GlobUser.buffer_header_ricezione[GlobUser.bytes_in_header],3-GlobUser.bytes_in_header,er);
       if er=WSAEWOULDBLOCK then exit
       else
       if er<>0 then begin
        GlobUser.disconnect := True;  // disconnettiamo a prossimo giro di receive....
        exit;
       end;

       inc(GlobUser.bytes_in_header,len);
       if GlobUser.bytes_in_header>3 then begin
        GlobUser.disconnect := True;  // disconnettiamo a prossimo giro di receive....
        exit;
       end;

       if GlobUser.bytes_in_header=3 then begin

        if GlobUser.encrypted_in then begin
          decrypt_buffer(@GlobUser.buffer_header_ricezione[0],3,@buffer_ricezione[0],GlobUser.inKey);
          move(buffer_ricezione[0],GlobUser.buffer_header_ricezione[0],3);
        end;

        GlobUser.in_buffer := '';
       end;

       if cycle=0 then begin
         inc(cycle);
         receive_user(cycle);
       end;

     exit;
  end;



    move(GlobUser.buffer_header_ricezione[0],to_receive,2);
    if to_receive>sizeof(buffer_ricezione_temp) then begin
      GlobUser.disconnect := True;
      exit;
     end;


    previous_len := length(GlobUser.in_buffer);
    len := TCPSocket_RecvBuffer(GlobUser.socket,@buffer_ricezione_temp[0],to_receive-previous_len,er);

    if er=WSAEWOULDBLOCK then exit
    else
    if er<>0 then begin
     GlobUser.disconnect := True;  // disconnettiamo a prossimo giro di receive....
     exit;
    end;

     if GlobUser.encrypted_in then begin
      decrypt_buffer(@buffer_ricezione_temp[0],len,@buffer_ricezione[0],GlobUser.inKey);
      move(buffer_ricezione[0],buffer_ricezione_temp[0],len);
     end;

   if previous_len+len<to_receive then begin //non ho ancora tutto...riempio quello che ho in in_buffer utente(stringa)
     SetLength(GlobUser.in_buffer,previous_len+len); //accresciamo buffer...per prossimo recv
     move(buffer_ricezione_temp[0],GlobUser.in_buffer[previous_len+1],len);
     exit;
   end;

   //se sono qui ho tutto....ora copio in buffer ricezione (solo se ho user.in_buffer pieno, altrimenti i dati sono tutti già pronti

    if previous_len>0 then begin
     move(GlobUser.in_buffer[1],buffer_ricezione[0],previous_len);
     move(buffer_ricezione_temp[0],buffer_ricezione[previous_len],len);
     bytes_in_buffer := len+previous_len;
    end else begin
     move(buffer_ricezione_temp[0],buffer_ricezione[0],len);
     bytes_in_buffer := len;
    end;

         checksync;  //copiamo da slavanap....

        process_command1(GlobUser.buffer_header_ricezione[2]);

        //if GlobUser.disconnect then exit;  //wella.....


       GlobUser.bytes_in_header := 0;
       GlobUser.in_buffer := '';

 except
 end;
end;

procedure tthread_supernode.free_id_in_shared_list(us: TLocalUser;fast:boolean);
var
fsharef:precord_file_shared;
i: Integer;
begin
try
if us.shared_count=0 then exit;
if us.shared_list=nil then exit;

i := 0;
while (i<us.shared_list.count) do begin

 fsharef := us.shared_list[i];
          inc(i);

   try
    if fast then FreeMem(fsharef^.keywords, fsharef^.numkeywords * 3 * SizeOf(Pointer)) //cancelliamo solo memoria in chiusura cancella lists
    else begin
     KWList_DeleteHashShare(fsharef^.hashkey_sha1,fsharef^.hashitem_sha1);
     DeleteKeywordsItem(fsharef);
    end;

        fsharef^.serialize := '';


        FreeMem(fsharef,sizeof(record_file_shared));
   except
   end;
end;


 freeAndNil(us.shared_list);
 if fast then exit;

 if shared_count>us.shared_count then dec(shared_count,us.shared_count)
  else shared_count := 0;
 us.shared_count := 0; //non ha nulla condiviso
 us.shared_size := 0;
 us.numBigVideos := 0;

 except
 end;
end;








procedure tthread_supernode.flush_tcp;
var
er: Integer;
num: Byte;
len: Integer;
begin
 try
 if GlobUser.out_buffer.count=0 then GlobUser.LastFailedFlush := 0;

 if GlobUser.out_buffer.count>=MAX_LINKCONGESTION_TODISCONNECT then begin
      GlobUser.disconnect := True;
      exit;
 end;

 if GlobUser.LastFailedFlush<>0 then
  if GlobUser.out_Buffer.count>0 then
   if tim-GlobUser.LastFailedFlush>180000then begin
       GlobUser.disconnect := True;
         exit;
   end;




 checksync;
 num := 0;

 while (GlobUser.out_buffer.count>0) do begin

  // TODO implement recycle factory class to reduce heap fragmentation
  len := length(GlobUser.out_buffer.strings[0]);
  if len>0 then TCPSocket_SendBuffer(GlobUser.socket,PChar(GlobUser.out_buffer.strings[0]),len,er)
   else begin
     GlobUser.LastFailedFlush := 0;
     GlobUser.out_buffer.delete(0);
     continue;
   end;

 if er=WSAEWOULDBLOCK then begin
   if GlobUser.LastFailedFlush=0 then GlobUser.LastFailedFlush := tim;
  exit;
 end;

 if er<>0 then begin
  GlobUser.disconnect := True;
  exit;
 end;

 GlobUser.out_buffer.delete(0);
 GlobUser.LastFailedFlush := 0;

end;

except
end;
end;




procedure tthread_supernode.check_ghost;
var
i: Integer;
us: Tlocaluser;
tempoghost: Cardinal;
begin
if tim<5*MINUTE then exit;

tempoghost := 10*MINUTE;

 for i := 0 to user_list.count-1 do begin
  us := user_list[i];
  if tim-us.logtime<tempoghost then continue;
  if tim-us.last_stats_click>tempoghost then us.disconnect := True;
 end;

end;



function tthread_supernode.abcd: string;
var i: Byte;
begin
result := '';

for i := 1 to 16 do Result := result+chr(random(256)+gettickcount);  //migliore casualità?

end;




procedure tthread_supernode.FreeHAshLists;
var
i: Integer;
begin
try
  for i := 0 to high(db_keywords.bkt) do KWList_FreeList(db_keywords.bkt[i]);
  FreeAndNil(db_keywords);
except
end;


try
  for i := 0 to high(db_hash.bkt) do HashList_freehashlist(db_hash.bkt[i]);
  FreeAndNil(db_hash);
except
end;

FreeAndNil(db_result_ids);

end;


end.






