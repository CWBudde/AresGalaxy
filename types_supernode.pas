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
custom types used by supernode
}

unit types_supernode;

interface

uses
ares_types,keywfunc,classes2,blcksock,class_cmdlist;

type
  PHash = ^THash;
  PHashItem = ^THashItem;

  precord_file_shared=^record_file_shared;     //SUPERNODE
  record_file_shared= packed record
  amime: Byte;
  
    hashkey_sha1:phash;      //memoria è assegnata e liberata in addhashshare e delete hash share
    hashitem_sha1:phashitem;
    
    param1: Cardinal;
    param2: Cardinal;
    param3: Cardinal;
    size: Cardinal; // solo per inc e dec shared amount
    serialize: string;
    keywords: PWordsArray; //usiamo puntatore per potere allocare solo quello che mi serve?
    numkeywords: Byte; //quante keywords ho?
    user: Pointer; // pointer to owner
  end;

  THashItem = packed record // one item in TKeyword
    share     : precord_file_shared;
    prev, next: PHashItem;
  end;

  THash = packed record // structure that manages one keyword
    hash      : array [0..19] of Byte; // keyword 20+16 sha1+md4
    crc       : word;
    count     : byte;
    firstitem  : Phashitem; // pointer to first full item
    prev, next: PHash; // pointer to previous and next PKeyword items in global list
  end;

  PKeywordItem = ^TKeywordItem;
  TKeywordItem = packed record // one item in TKeyword
    share     : precord_file_shared;
    prev, next: PKeywordItem;
  end;

  PKeyword = ^TKeyword;
  TKeyword = packed record // structure that manages one keyword
    keyword   : array of char; // keyword
    count     : cardinal;
    crc       : word;
    firstitem : PKeywordItem; // pointer to first full item
    prev, next: PKeyword; // pointer to previous and next PKeyword items in global list
  end;


type //ultranode->cache sockets
  tstato_supernode_cache_query=(STATO_SUPERNODE_CACHE_QUERY_IDLE,
                               STATO_SUPERNODE_CACHE_QUERY_CONNECTING,
                               STATO_SUPERNODE_CACHE_QUERY_WAITING_FORKEY,
                               STATO_SUPERNODE_CACHE_QUERY_FLUSHING_STATS,
                               STATO_SUPERNODE_CACHE_QUERY_RECEIVING);


type
precord_ip_seen=^record_ip_seen;
record_ip_seen=record
 ip: Cardinal;
 seen: Byte;
end;

type    //ultranode, TCP/UDP structure , search performed by localuser
precord_local_search=^record_local_search;  //per ogni localuser di hashsupernode ultranode
record_local_search=record
 search_id: Word; // guid per search string key
// user: Pointer;
  ips: TMylist;
end;


type  // ultranode, filled while searching
twanted_search = class(tobject)
 search_id,client_id: array [0..1] of Byte;
 amime,sizecomp,param1comp,param3comp: Byte;
 wantedparam1,wantedparam3,wanted_param3_avarage_min,
 wanted_param3_avarage_max,wanted_size_avarage_min,wanted_size_avarage_max: Cardinal;
 wantedsize: Int64; //DHT 64 bytes  supernode 32
 strict: Boolean;

 keywords_generali,
 keywords_title,
 keywords_artist,
 keywords_album,
 keywords_category: Tnapcmdlist;

 lista_helper_result,
 lista_helper_result_language,
 lista_helper_result_date,
 lista_helper_result_category,
 lista_helper_result_album,
 lista_helper_result_artist,
 lista_helper_result_title: TMylist;

 keyword_date,keyword_language: string;
 crcdate,crclanguage: Word;
 public
 constructor create;
 procedure clear;
 destructor destroy; override;
 function search_id_toStr: string;
 function search_id_toWord: Word;
end;

TStato_server_udp=(SERVER_UDP_TCP_LINKED,
                   SERVER_UDP_DISCOVERY,
                   SERVER_UDP_LOGGING_IN,
                   SERVER_UDP_HANDSHAKED);

type  //ultranode, used to keep track of others ultranode
precord_server_udp=^record_server_udp;
 record_server_udp=record
  key_verify: array [0..7] of Byte; //per login ok...
  ip: Cardinal;
  port: Word; //smallint?
  last_pong: Cardinal;
  num_login_try,failed_pings: Byte;  //pacchetti per arrivare a login
  last_search: Cardinal; //par sapere quando posso intervenire con nuova ricerca
   out_packets: Word;  //incremento in invio search, azzero in ricezione
   his_horizon: Cardinal; //numero di hosts che lo cercano, per nostro throttle su di lui
  stato: TStato_server_udp;
  next,prev:precord_server_udp;
end;

type
TState_availableSupernode=(
                           CONNECTING,
                           RECEIVING_FIRSTKEY_HEADER,
                           RECEIVING_FIRSTKEY_PAYLOAD,
                           FLUSHING_LOGINREQ,
                           RECEIVING_LOGINREPLY_HEADER,
                           RECEIVING_LOGINREPLY_PAYLOAD
                           );
type
precord_availableSupernode=^record_availableSupernode;
record_availableSupernode=record
 ip: Cardinal;
 port: Word;
 inuse: Boolean;
 attempts: Cardinal;
 connects: Cardinal;
 lastAttempt: Cardinal;
 tick: Cardinal;
 state: TState_availableSupernode;
 len_payload: Word;
 buff: string;
 ca: Byte;
 sc: Word;
 socket:Hsocket;
end;

type
TSupernodeState=(
                 CONNECTED,
                 SYNCHED,
                 DISCONNECTED,
                 DISCONNECTING
                 );
TSupernodeConnectionType=(
                          LT_ACCEPTED,
                          LT_CONNECTED
                          );
                          
Tsupernode = class(Tobject)
 connType: TSupernodeConnectionType;
 ip: Cardinal;
 port: Word;
 socket:Hsocket;
 ca: Byte;
 sc: Word;
 logtime: Cardinal;
 state: TSupernodeState;
 tick: Cardinal;
 outBuffer: TMyStringList;
 bytes_in_header: Byte;
 inBuffer: string;
 header_in: array [0..2] of Byte;
 build_no: Word;
 users: Word;
 constructor create;
 destructor destroy; override;
end;



 TLocalUser = class(TObject)
  socket: Integer;
   shareBlocked: Boolean;
   last_Search: Cardinal;
   noCrypt: Boolean;
   supportDirectChat: Boolean;
   disconnect: Boolean;  //should we disconnect this guy at the end of proess routine?
   his_local_ip: string;
   agent: string;
   result_str: string; //header da inviare in local search
   nick: string; // nickanme@agent 'messo in login'
   result_hash_str: string; //per Result hash
   ind_src_user: Byte; //index of search out to UDP
   last_udp_search: Cardinal; //throttle udp
   ip: Cardinal;
   port,NATport: Word;
   logtime: Cardinal;   //ora di arrivo
   LastFailedFlush: Cardinal;
   last_stats_click: Cardinal;   // per ghost timeout
   last_cache_patch: Cardinal; //ricordiamoci data ultima patch
   UDPTransferPort: Word;
   
   encrypted_in,encrypted_out: Boolean;
   inKey,outKey: Word;

   out_buffer: TMyStringList;
   speed: Word;
    result_id:smallint;
   shared_count: Word; //num suoi files
   shared_size: Int64;
   numBigVideos: Word;
   queue_length: Byte;
   upload_count: Byte;
   max_uploads: Byte;
   num_special: Byte; // per distinguere se hanno lo stesso ip nei push  2967 28-6-2005 per distinguere 0 = firewalled 1 = not firewalled
   relayingSockets: TMylist;
   searches: TMylist; //precord_local_search;

   bytes_in_header: Byte;
   buffer_header_ricezione: array [0..2] of Byte;

   in_buffer: string;
   shared_list: TMylist; //lista files per prima lettera hash
 constructor create;
 destructor Destroy; override;
end;

precord_relaying_socket=^record_relaying_socket;
record_relaying_socket=record
 user: Tlocaluser;
 socket:hsocket;
 id: Cardinal;
 bytes_in_header: Byte;
 buffer_header_ricezione: array [0..3] of Byte;
 in_buffer, //from requestor to our local
 out_buffer: string;  //from our local to requestor
 lastOut: Cardinal; // send to tick value when outbuffer is filled
 lastIn: Cardinal; //set on every remote receive
end;

type
TSocketUserState=(SOCKETUSR_FLUSHING_MY_SALTKEY,
                  SOCKETUSER_WAITINGFIRSTCRYPT,
                  SOCKETUSR_WAITINGFIRST,
                  SOCKETUSR_FLUSHINFIRSTLOG,

 {supernode}      SOCKETUSR_FLUSHIN_SUPERNODEFIRSTLOG,
 {supernode}      SOCKETUSR_RECEIVING_SUPERNODE_LOGINHEADER,
 {supernode}      SOCKETUSR_RECEIVING_SUPERNODE_LOGINPAYLOAD,
 
                  SOCKETUSR_FLUSHINFIRSTLOGNOCRYPT,
                  SOCKETUSR_FLUSHINPUSH,
                  SOCKETUSR_FLUSHEDPUSH,
                  SOCKETUSR_RECEIVINGLOGINREQ,
                  SOCKETUSR_RECEIVINGLOGINREQNOCRYPT);
type
precord_socket_user=^record_socket_user;
record_socket_user=record
 socket: Integer;
 last: Cardinal;
 ip: Cardinal;
 NatPort: Word;
  inKey,outKey: Word;
   len_payload: Word;
  encrypted_in,encrypted_out: Boolean;
 state: TSocketUserState;
 outBuff: array [0..3] of Byte;
end;

implementation

uses
 helper_strings,windows;
 
constructor Tsupernode.create;
begin
 socket := INVALID_SOCKET;
 state := CONNECTED;
 outBuffer := TmyStringList.create;
 bytes_in_header := 0;
 users := 0;
end;

destructor TSupernode.destroy;
begin
 inBuffer := '';
 outBuffer.Free;
 if socket<>INVALID_SOCKET then TCPSocket_Free(socket);
inherited;
end;

constructor tlocaluser.create;
begin
inherited create;
 bytes_in_header := 0;
 in_buffer := '';
 port := 0; // not yet known
 searches := nil;
 LastFailedFlush := 0;  //0 timeout flush
 out_buffer := tmyStringList.create;
 last_cache_patch := 0; //momento ultimo patch, per inviare a distanza di un'ora(dopo il primo che è in sync con parse received cache)
 num_special := $61; // a di default...poi in assegna pguid special lo cambiamo se serve
 noCrypt := False;
 shared_list := nil;
 shared_count := 0;
 shared_Size := 0;
 numBigVideos := 0;
 last_search := 0;
 disconnect := False;
 ind_src_user := 0;
 shareBlocked := False;
 result_id := -1; //not assigned = 0
 UDPTransferPort := 0;
 supportDirectChat := False;
 relayingSockets := nil;
end;

destructor tlocaluser.Destroy;
begin

  TCPSocket_Free(socket);
  

 try
  out_buffer.Free;
 except
 end;

  try
  result_hash_str := '';
  nick := '';
  agent := '';
  result_str := '';
  his_local_ip := '';
  in_buffer := '';
  except
  end;
inherited;
end;

constructor twanted_search.create;
begin
 strict := False;
 param1comp := 0;
 wantedparam1 := 0;
 param3comp := 0;
 wantedparam3 := 0;
 sizecomp := 0;
 wantedsize := 0;
 wanted_param3_avarage_min := 0;
 wanted_param3_avarage_max := 0;
 wanted_size_avarage_min := 0;
 wanted_size_avarage_max := 0;
 amime := 0;
 keywords_generali := tnapcmdlist.create;
 keywords_title := tnapcmdlist.create;
 keywords_artist := tnapcmdlist.create;
 keywords_album := tnapcmdlist.create;
 keywords_category := tnapcmdlist.create;
 keyword_date := '';
 keyword_language := '';


 lista_helper_result := tmylist.create;
 lista_helper_result_language := tmylist.create;
 lista_helper_result_date := tmylist.create;
 lista_helper_result_category := tmylist.create;
 lista_helper_result_album := tmylist.create;
 lista_helper_result_artist := tmylist.create;
 lista_helper_result_title := tmylist.create;
end;

function TWanted_search.search_id_toStr: string;
begin
SetLength(result,2);
move(search_id[0],result[1],2);
end;

function TWanted_search.search_id_toWord: Word;
begin
move(search_id[0],result,2);
end;

procedure TWanted_search.clear;
begin
try
with self do begin

strict := True; //di default...nel caso sia general imposto a false
param1comp := 0;
wantedparam1 := 0;
param3comp := 0;
wantedparam3 := 0;
sizecomp := 0;
wantedsize := 0;
wanted_param3_avarage_min := 0;
wanted_param3_avarage_max := 0;
wanted_size_avarage_min := 0;
wanted_size_avarage_max := 0;

keyword_date := '';
keyword_language := '';
//client_id := '';
//search_id := '';

keywords_generali.clear;
keywords_title.clear;
keywords_artist.clear;
keywords_album.clear;
keywords_category.clear;


 lista_helper_result.clear;
 lista_helper_result_language.clear;
 lista_helper_result_date.clear;
 lista_helper_result_category.clear;
 lista_helper_result_album.clear;
 lista_helper_result_artist.clear;
 lista_helper_result_title.clear;

end;
except
end;
end;

destructor TWanted_search.destroy;
begin

 keywords_generali.Free;
 keywords_title.Free;
 keywords_artist.Free;
 keywords_album.Free;
 keywords_category.Free;
 keyword_date := '';
 keyword_language := '';


 lista_helper_result.Free;
 lista_helper_result_language.Free;
 lista_helper_result_date.Free;
 lista_helper_result_category.Free;
 lista_helper_result_album.Free;
 lista_helper_result_artist.Free;
 lista_helper_result_title.Free;

inherited;
end;

end.