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
 supernode server communication
}

unit const_supernode_commands;

interface

const
//bye packet codes
 ERROR_PAYLOADBIG              = 1;
 ERROR_FLOWTIMEOUT             = 2;
 ERROR_NETWORKISSUE            = 3;
 ERROR_FLUSHQUEUE_OVERFLOW     = 4;
 ERROR_DECOMPRESSION_ERROR     = 5;
 ERROR_DECOMPRESSED_PACKETBIG  = 6;
 ERROR_SYNCTIMEOUT             = 7;
 ERROR_SYNC_OLDBUILDERROR      = 8;
 ERROR_SYNC_NOBUILDERROR       = 9;
 ERROR_FLUSH_OVERFLOW          = 10;

// end of search descriptions
 RSN_ENDOFSEARCH_ASREQUESTED   = 1;
 RSN_ENDOFSEARCH_TOMANYSEARCHES= 2;
 RSN_ENDOFSEARCH_MISSINGFIELDS = 3;
 RSN_ENDOFSEARCH_ENOUGHRESULTS = 4;

// handle not encrypted packets
 CHAR_MARKER_NOCRYPT = 6;
 CHAR_MARKER_NEWSTACK =5;


 MSG_SERVER_LOGIN_OK                   =      1;
 MSG_SERVER_YOUR_NICK                  =      5;
 MSG_SERVER_PUSH_REQ                   =      8;
 MSG_SERVER_SEARCH_RESULT              =     18;
 MSG_SERVER_SEARCH_ENDOF               =     19;
 MSG_SERVER_STATS                      =     30;
 MSG_LINKED_ENDOFSYNCH                 =     45;
 MSG_LINKED_ENDOFSYNCH_100             =    145;
 MSG_SERVER_YOUR_IP                    =     37;
 MSG_SERVER_HERE_KSERVS                =     38;
 MSG_SERVER_PRELOGIN_OK                =     51;
 MSG_SERVER_PRELOGIN_OK_NEWNET_LATEST  =     52;
 MSG_SERVER_HERE_CACHEPATCH            =     53;
 MSG_SERVER_HERE_CACHEPATCH2           =     54;
 MSG_SERVER_HERE_CACHEPATCH3           =     55; //2952
 MSG_SERVER_PRELGNOK                   =     56; //2958+ 17-2-2005
 MSG_SERVER_PRELGNOKNOCRYPT            =     60;
 MSG_SERVER_HERE_CHATCACHEPATCH        =     57; //2960+
 MSG_SERVER_PRELOGFAILLOGSECURTYIP     =     58;
 MSG_SERVER_PRELOGFAILLOGBUSY          =     59;
 MSG_SERVER_LINK_FULL                  =     94;
 MSG_SERVER_PUSH_CHATREQ_NEW           =     97;
 MSG_SERVER_COMPRESSED                 =    101;
 MSG_LINKED_PING                       =      3;
 MSG_LINKED_PING_100                   =    103;
 MSG_LINKED_QUERY                      =     19;
 MSG_LINKED_QUERY_100                  =    119;
 MSG_LINKED_QUERY_HIT                  =     11;
 MSG_LINKED_QUERY_HIT_100              =    111;
 MSG_LINKED_BYE_PACKET                 =     36;
 MSG_LINKED_BYE_PACKET_100             =    136;
 MSG_LINKED_QUERYHASH                  =     70;
 MSG_LINKED_QUERYHASH_100              =    170;
 MSG_LINKED_QUERYHASH_HIT              =     75;
 MSG_LINKED_QUERYHASH_HIT_100          =    175;



// udp protocol
 MSG_SERV_UDP_PRELOGIN_REQ  =  31;
 MSG_SERV_UDP_HERE_MYKEY    =  32;
 MSG_SERV_UDP_LOGINREQ      =  33;
 MSG_SERV_UDP_LOGIN_OK      =  34;
 MSG_SERV_UDP_QUERY         =  26;
 MSG_SERV_UDP_QUERY_HIT     =  27;
 MSG_SERV_UDP_QUERY_ACK     =  28;
 MSG_SERV_UDP_PING          =  30;
 MSG_SERV_UDP_PONG          =  37;
 MSG_SERV_UDP_QUERYHASH     =  35;
 MSG_CLNT_UDP_PUSH          =  45;
 MSG_SRV_UDP_PUSH_ACK       =  46;
 MSG_SRV_UDP_PUSH_FAIL      =  47;
 MSG_CLNT_UDP_CHATPUSH      =  41;
 MSG_SRV_UDP_CHATPUSH_ACK   =  42;
 MSG_SRV_UDP_CHATPUSH_FAIL  =  43;



// deprecated stuff
//MSG_LINKED_USERLOGIN                 =     33; //2964
//MSG_LINKED_USERsSYNC                 =     34; //2964
//MSG_LINKED_DUMMY                     =     35; //per bug cryptazione su supernodo in parse receive <size fino a vers 2935 compresa
//MSG_LINKER_RESET_REMOTE_HASH_TABLE   =     50;
//MSG_LINKER_ADD_REMOTE_HASH           =     51;
//CMD_LINKER_REMOTE_REM_HASH_REQUEST   =     71;
//MSG_LINKED_PONG                      =     4;
//MSG_LINKED_QUERY                     =     10;
//MSG_LINKED_QUERY2                    =     15;
//MSG_LINKED_QUERY_UNICODE             =     16;
//MSG_SERVER_HEREPROXY_ADDR            =     95;
//MSG_SERVER_STATUS_LINK               =     58; //sent to client to facilitate elections
//MSG_SUPERNODE_FIRST_LOG              =     93;   <---in const_commands
//MSG_SERVER_PRELOGIN_OK_NEWNET         =      51;
implementation

end.
