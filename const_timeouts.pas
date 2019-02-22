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
consts related to timeouts
}

unit const_timeouts;

interface

const
MIN_INTERVAL_QUERY_CACHE_ROOT=45; //seconds
MIN_LOG_INTERVAL_CHAT=25000;  //25 secondi tra tentativi collegamento a chat server
MIN_LOG_INTERVAL_SUPERNODE=20000;  //20 secondi tra tentativi collegamento a supernode hash server
MIN_LOG_INTERVAL_CACHE=30000;  //30 secondi tra tentativi collegamento a cache server
UDPTRANSFER_PINGTIMEOUT=60000;
TIMEOUT_UDP_UPLOAD     =60000;

INTERVAL_REQUERY_PARTIALS=120000; //due minuti
TIMEOUT_DATA_PARTIAL=60000;
TIMEOUT_RECEIVE_HANDSHAKE=15000; // after accept between handshake...
TIMEOUT_RECEIVE_REPLY=25000;
TIMEOUT_RECEIVING_FILE=60000;
 SOURCE_RETRY_INTERVAL=45000;
TIMEOUT_FLUSH_TCP=15000;
TIMEOUT_INVIO_HEADER_REPLY_UPLOAD=40000;
MIN_DELAY_BETWEEN_PUSH=30000; // 30 secondi tra push req inviate...
DELAY_BETWEEN_RECHAT_REQUEST=2500; // 5 sec
GRAPH_TICK_TIME=55; // millisecs

implementation

end.
