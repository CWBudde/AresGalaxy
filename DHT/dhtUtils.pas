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

*****************************************************************
 The following delphi code is based on Emule (0.46.2.26) Kad's implementation http://emule.sourceforge.net
 and KadC library http://kadc.sourceforge.net/
*****************************************************************
 }

{
Description:
misc fuctions
}

unit dhtUtils;

interface

uses
  Classes;

function dht_packet_to_str(id:integer): string;

implementation

uses
  SysUtils, Windows, Classes2, DhtConsts;

function dht_packet_to_str(id:integer): string;
begin
  case id of
    CMD_DHT_BOOTSTRAP_REQ:
      Result := 'BOOTSTRAP_REQ'; // send bootstrap nodes
    CMD_DHT_BOOTSTRAP_RES:
      Result := 'BOOTSTRAP_RES';

    CMD_DHT_HELLO_REQ:
      Result := 'HELLO_REQ'; //	 	        = $55; // ping pong
    CMD_DHT_HELLO_RES:
      Result := 'HELLO_RES'; //     	    = $56;

    CMD_DHT_REQID:
      Result := 'REQID'; //		   	        = $60; // find nodes
    CMD_DHT_RESID:
      Result := 'RESID'; //			          = $61;
    CMD_DHT_REQID2:
      Result := 'REQID2'; //              = $62;

    CMD_DHT_SEARCHKEY_REQ:
      Result := 'SEARCHKEY_REQ'; //		    = $70; // search and publish
    CMD_DHT_SEARCHKEY_RES:
      Result := 'SEARCHKEY_RES'; //		    = $71;

    CMD_DHT_PUBLISHKEY_REQ:
      Result := 'PUBLISHKEY_REQ'; //      = $75;
    CMD_DHT_PUBLISHKEY_RES:
      Result := 'PUBLISHKEY_RES'; //	    = $76;

    CMD_DHT_SEARCHHASH_REQ:
      Result := 'SEARCHHASH_REQ'; //		  = $80; // search and publish
    CMD_DHT_SEARCHHASH_RES:
      Result := 'SEARCHHASH_RES'; //		  = $81;
    CMD_DHT_PUBLISHHASH_REQ:
      Result := 'PUBLISHHASH_REQ'; //     = $82;
    CMD_DHT_PUBLISHHASH_RES:
      Result := 'PUBLISHHASH_RES'; //	    = $83;
    CMD_DHT_SEARCHPARTIALHASH_RES:
      Result := 'SEARCHPARTIALHASH_RES'; // = $84;

    CMD_DHT_IPREQ:
      Result := 'IPREQ'; //	              = $90;
    CMD_DHT_IPREP:
      Result := 'IPREP'; //	              = $91;
    CMD_DHT_CACHESREQ:
      Result := 'CACHESREQ'; //	          = $92;
    CMD_DHT_CACHESREP:
      Result := 'CACHESREP'; //	          = $93;
    CMD_DHT_FIREWALLCHECK:
      Result := 'FIREWALLCHECK'; //       = $95;
    CMD_DHT_FIREWALLCHECKINPROG:
      Result := 'FIREWALLCHECKINPROG'; // = $96;
    CMD_DHT_FIREWALLCHECKRESULT:
      Result := 'FIREWALLCHECKRESULT'; //$97;
    else
      Result := 'Unknown ' + IntToStr(id);
  end;
end;

end.
