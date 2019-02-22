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

unit const_udpTransfer;

interface

const

  { peer to peer }

  // used to see if file's available remotely
  CMD_UDPTRANSFER_FILEREQ        = 10; // is file available?
  CMD_UDPTRANSFER_FILEREPOK      = 11; // file is available!
  CMD_UDPTRANSFER_FILENOTSHARED  = 12; // file isn't available
  CMD_UDPTRANSFER_FILEPING       = 13; // nat traversal packet sent by thread_upload while downloader tries to reach him

  // retrieve ICH data
  CMD_UDPTRANSFER_ICHPIECEREQ    = 20; // request a piece of ICH data
  CMD_UDPTRANSFER_ICHPIECEREP    = 21; // data of remote ICH db
  CMD_UDPTRANSFER_ICHPIECEERR1   = 22; // ICH error ( db error )
  CMD_UDPTRANSFER_ICHPIECEERR2   = 23; // ICH error ( read beyond limit = ICH transfer end )
  CMD_UDPTRANSFER_ICHPIECEERR3   = 24; // ICH error ( read from stream error = len mismatch )
  CMD_UDPTRANSFER_ICHPIECEERR4   = 25; // ICH error ( file not shared )

  // download file
  CMD_UDPTRANSFER_PIECEREQ       = 30; // requesting a piece of shared file
  CMD_UDPTRANSFER_PIECEREP       = 31; // file's data
  CMD_UDPTRANSFER_PIECEBUSY      = 32; // server busy
  CMD_UDPTRANSFER_PIECEERR       = 33; // server error
  CMD_UDPTRANSFER_XSIZEREP       = 34; // meta infos regarding file (magnet)
  TAG_ARESHEADER_DATA            = 35;
  TAG_ARESHEADER_DATACHECKSUM    = 36;

  UDPTRANSFER_ERROR_FILENOTSHARED     = 0;
  UDPTRANSFER_ERROR_USERBLOCKED       = 1;
  UDPTRANSFER_ERROR_MISSINGHEADERS    = 2;
  UDPTRANSFER_ERROR_FILEERROR         = 3;
  UDPTRANSFER_ERROR_UNEXPECTEDERROR   = 4;
  UDPTRANSFER_ERROR_OFFSETBEYONDLIMIT = 5;


  UDPTRANSFER_PIECESIZE = 8192;
  {
    peer to supernode and viceversa
    used to let peers know about each other's NAT endpoints
    and maintain NAT endpoints alive
  }

  CMD_UDPTRANSFER_PING           = 0; // thread upload keeps NAT session alive
  CMD_UDPTRANSFER_PONG           = 1; // supernodes acknowledge ping
  CMD_UDPTRANSFER_PUSH           = 2; // downloader wants a new NAT traversal session with an user of mines
  CMD_UDPTRANSFER_PUSHFAIL1      = 3; // can't start session, user's offline
  CMD_UDPTRANSFER_PUSHFAIL2      = 4; // can't start session, user isn't pinging us
  CMD_UDPTRANSFER_PUSHACK        = 5; // session started (remote uploader informed)
  CMD_UDPTRANSFER_PUSHREQ        = 6; // to uploader: remote peer wants to start a session between you and him
  CMD_UDPTRANSFER_ECHOPRTREQ     = 7; // general purpose command
  CMD_UDPTRANSFER_ECHOPRTREP     = 8; // supernode sends back user's UDP NAT port

implementation

end.
