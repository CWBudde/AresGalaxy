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
main bittorrent constants
}

unit bittorrentConst;

interface

uses
  Classes, helper_datetime, const_ares;

const
  TIMEOUTTCPCONNECTION = 10 * SECOND;
  TIMEOUTTCPRECEIVE = 15 * SECOND;

  TIMEOUTTCPCONNECTIONTRACKER = 15 * SECOND;
  TIMEOUTTCPRECEIVETRACKER = 30 * SECOND;

  BTSOURCE_CONN_ATTEMPT_INTERVAL = MINUTE;
  BT_MAXSOURCE_FAILED_ATTEMPTS = 2;
  BTKEEPALIVETIMEOUT = 2*MINUTE;

  BITTORRENT_PIECE_LENGTH = 16 * KBYTE;
  EXPIRE_OUTREQUEST_INTERVAL = 60 * SECOND;
  INTERVAL_REREQUEST_WHENNOTCHOCKED = 10 * SECOND;

  TRACKER_NUMPEER_REQUESTED = 100;
  BITTORRENT_INTERVAL_BETWEENCHOKES = 10 * SECOND;
  BITTORENT_MAXNUMBER_CONNECTION_ESTABLISH = 35;
  BITTORENT_MAXNUMBER_CONNECTION_ACCEPTED  = 55;
  TRACKERINTERVAL_WHENFAILED = 2 * MINUTE;
  BITTORRENT_MAX_ALLOWED_SOURCES = 300;
  BITTORRENT_DONTASKMORESOURCES = 200;
  SEVERE_LEECHING_RATIO = 10;
  NUMMAX_SOURCES_DOWNLOADING = 4;
  MAX_OUTGOING_ATTEMPTS = 3;
  MAXNUM_OUTBUFFER_PACKETS = 10;
  NUMMAX_TRANSFER_HASHFAILS = 8;
  NUMMAX_SOURCE_HASHFAILS = 4;
  STR_BITTORRENT_PROTOCOL_HANDSHAKE = chr(19)+'BitTorrent protocol';
  STR_BITTORRENT_PROTOCOL_EXTENSIONS =
    CHRNULL{chr($80)} + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + chr($10) + CHRNULL + chr(1);  // support extension protocol + dht
  TORRENT_DONTSHARE_INTERVAL = 2592000; //30 days
 
  CMD_BITTORRENT_CHOKE         = 0;
  CMD_BITTORRENT_UNCHOKE       = 1;
  CMD_BITTORRENT_INTERESTED    = 2;
  CMD_BITTORRENT_NOTINTERESTED = 3;
  CMD_BITTORRENT_HAVE          = 4;
  CMD_BITTORRENT_BITFIELD      = 5;
  CMD_BITTORRENT_REQUEST       = 6;
  CMD_BITTORRENT_PIECE         = 7;
  CMD_BITTORRENT_CANCEL        = 8;
  CMD_BITTORRENT_DHTUDPPORT    = 9;

  // fast peer extensions
  CMD_BITTORRENT_SUGGESTPIECE  = 13;
  CMD_BITTORRENT_HAVEALL       = 14;
  CMD_BITTORRENT_HAVENONE      = 15;
  CMD_BITTORRENT_REJECTREQUEST = 16;
  CMD_BITTORRENT_ALLOWEDFAST   = 17;

  // extension protocol
  CMD_BITTORRENT_EXTENSION     = 20;
  OPCODE_EXTENDED_HANDSHAKE    = 0;
  OUR_UT_PEX_OPCODE            = 1;
  OUR_UT_METADATA_OPCODE       = 2;

  // dummy value for addpacket procedure
  CMD_BITTORRENT_KEEPALIVE     = 100;
  CMD_BITTORRENT_UNKNOWN       = 101;

implementation

end.
