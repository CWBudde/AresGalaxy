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
UDP socket code
}

unit dhtsocket;

interface

uses
  Classes, SysUtils, Windows, Dhtconsts, SynSock, DhtTypes;

procedure DHT_send(DestinationIP: Cardinal; DestinationPort: Word; compress:boolean=false; priority:boolean=false);
procedure DHT_sendMyDetails(opcode: Byte; ip: Cardinal; port:word);
procedure DHT_SendBackPublishHashAck(ip: Cardinal; port: Word; load: Byte);
procedure DHT_SendCacheCheck(ip: Cardinal; port:word);
procedure DHT_flush_outpackets;

implementation

uses
  vars_global, zlib, thread_dht, helper_ipfunc;


procedure DHT_SendBackPublishHashAck(ip: Cardinal; port: Word; load: Byte);
begin
  DHT_buffer[1] := CMD_DHT_PUBLISHHASH_RES;
  DHT_buffer[22] := load;
  DHT_len_tosend := 23;
  DHT_send(ip,port,false);
end;

procedure DHT_SendCacheCheck(ip: Cardinal; port:word);
begin
  DHT_buffer[1] := CMD_DHT_CACHESREQ;
  DHT_buffer[2] := 0;
  DHT_len_tosend := 3;
  DHT_send(ip,port,false);
  thread_dht.DHT_CacheCheckIp := ip;
end;


procedure DHT_sendMyDetails(opcode: Byte; ip: Cardinal; port:word);
begin
  DHT_buffer[1] := opcode;

   move(DHTme128[0],DHT_buffer[2],4);
   move(DHTme128[1],DHT_buffer[6],4);
   move(DHTme128[2],DHT_buffer[10],4);
   move(DHTme128[3],DHT_buffer[14],4);

  //my_ipKadOrder := synsock.ntohl(vars_global.localipC);
  move(vars_global.localipC,DHT_buffer[18],4);
   move(vars_global.myport,DHT_buffer[22],2);
   move(vars_global.myport,DHT_buffer[24],2);
  DHT_buffer[26] := 0;
  DHT_len_tosend := 27;

	DHT_send(ip, port, false, true);
end;

procedure DHT_send(DestinationIP: Cardinal; DestinationPort: Word; compress:boolean=false; priority:boolean=false);
var
 buff: Pointer;
 outsize: Integer;
 outpacket:precord_dht_outpacket;
begin
  if DHT_len_tosend<1 then exit;
  if DHT_outpackets.count>2000 then exit;

  if compress then begin

    DHT_buffer[0] := OP_DHT_PACKEDPROT;

    try
    ZCompress(@DHT_Buffer[2],DHT_len_tosend-2,buff,outsize);
    Move(buff^, DHT_Buffer[2], outsize);
    DHT_len_tosend := outsize+2;
    FreeMem(buff,outsize);
    except
      exit;
    end;
  end else DHT_buffer[0] := OP_DHT_HEADER;

  if DHT_len_tosend<1 then exit;


 // if priority then begin
   DHT_RemoteSin.sin_family := AF_INET;
   DHT_RemoteSin.sin_port := synsock.htons(DestinationPort);
   DHT_RemoteSin.sin_addr.s_addr := DestinationIP;
   synsock.SendTo(DHT_socket,DHT_buffer,DHT_len_tosend,0,@DHT_RemoteSin,SizeOf(DHT_RemoteSin));
   exit;
 // end;

  while (DHT_outpackets.count>10) do begin
   DHT_flush_outpackets;
  end;

  outpacket := AllocMem(sizeof(record_dht_outpacket));
   outpacket^.destIP := DestinationIP;
   outpacket^.destPort := synsock.htons(DestinationPort);

   SetLength(outpacket^.buffer,DHT_len_tosend);
   move(DHT_buffer,outpacket^.buffer[1],length(outpacket^.buffer));

  DHT_outpackets.add(outpacket);

 // DHT_RemoteSin.sin_family := AF_INET;
 // DHT_RemoteSin.sin_port := synsock.htons(DestinationPort);
 // DHT_RemoteSin.sin_addr.s_addr := DestinationIP;
  //synsock.SendTo(DHT_socket,DHT_buffer,DHT_len_tosend,0,@DHT_RemoteSin,SizeOf(DHT_RemoteSin));
end;

procedure DHT_flush_outpackets;
var
 outpacket:precord_dht_outpacket;
begin
if  DHT_outpackets.count=0 then exit;


 outpacket := DHT_outpackets[0];
            DHT_outpackets.delete(0);

 DHT_RemoteSin.sin_family := AF_INET;
 DHT_RemoteSin.sin_port := outpacket^.destPort;
 DHT_RemoteSin.sin_addr.s_addr := outpacket^.destIP;

  synsock.SendTo(DHT_socket,outpacket^.buffer[1],length(outpacket^.buffer),0,@DHT_RemoteSin,SizeOf(DHT_RemoteSin));


  SetLength(outpacket^.buffer,0);
  FreeMem(outpacket,sizeof(record_dht_outpacket));
end;

end.
