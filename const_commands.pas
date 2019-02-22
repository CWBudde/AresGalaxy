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
various protocol command values (alway 1 byte)
}

unit const_commands;

interface

const

 MSG_CLIENT_LOGIN_REQ                  =      0;
 MSG_CLIENT_PUSH_REQ                   =      7;
 MSG_CLIENT_PUSH_REQNOCRYPT            =      8;

 MSG_CLIENT_ADD_SEARCH_NEW             =      9;
 MSG_CLIENT_ENDOFSEARCH                =      12;
 MSG_CLIENT_ADD_SEARCH_NEWUNICODE      =      13;
 MSG_CLIENT_REMOVING_SHARED            =      21;
 MSG_CLIENT_ADD_SHARE_KEY              =      23;
 MSG_CLIENT_ADD_CRCSHARE_KEY           =      28;
 MSG_CLIENT_LOGMEOFF                   =      26;
 MSG_CLIENT_STAT_REQ                   =      30;
 MSG_CLIENT_UPDATING_NICK              =      34;
 MSG_CLIENT_DUMMY                      =      35;
 MSG_CLIENT_COMPRESSED                 =      50;

 MSG_CLIENT_BROWSE_REQ                 =      71;
 MSG_CLIENT_CHAT_NEWPUSH               =      73;
 MSG_CLIENT_CHAT_NEWPUSHNOCRYPT        =       6;

 MSG_CLIENT_WANT_DL_SORCS              =      75;
 MSG_CLIENT_ADD_HASHREQUEST            =      80;
 MSG_CLIENT_REM_HASHREQUEST            =      81;
 MSG_CLIENT_USERFIREWALL_REPORT        =      82; //2967+ 28-6-2005
 MSG_CLIENT_USERFIREWALL_REQ           =      82; //2967+ 28-6-2005
 MSG_CLIENT_USERFIREWALL_RESULT        =      83;
 MSG_CLIENT_FIRST_LOG                  =      90;
 MSG_CLIENT_TEST                       =      91;
 MSG_SUPERNODE_FIRST_LOG               =      93;
 MSG_SUPERNODE_SECOND_LOG              =      98;

 CMD_TAG_SUPPORTDIRECTCHAT             =       1;  //handshaked to verify compatibility
 CMD_RELAYING_SOCKET_PACKET            =       3;  //server->localclient (data from remote user)
 CMD_RELAYING_SOCKET_OUTBUFSIZE        =       4;  //server->localclient (slow down)
 MSG_CLIENT_RELAYDIRECTCHATPACKET      =       14; //localclient->server->remote requesting user
 CMD_RELAYING_SOCKET_REQUEST           =       5;  // someone wants us to relay to our local user
 CMD_RELAYING_SOCKET_OFFLINE           =       6;  //let remote user know user isn't here anymore
 CMD_RELAYING_SOCKET_START             =       7; //let remote user know we're ready
 CMD_SERVER_RELAYINGSOCKETREQUEST      =       8; // someone wants us to relay to our local user, let client know this
 CMD_CLIENT_RELAYDIRECTCHATDROP        =       2; // localclient closes window

implementation

end.
