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

unit dht_socket;

interface

uses
 classes,dht_consts,synsock,classes2,sysutils,windows,dht_search;

 type
 mdht_outpacket_type=(packet_type_none,query_ping,query_getpeer,query_findnode,query_announce);

 type
 precord_outpacket=^record_outpacket;
 record_outpacket=record
  time: Cardinal;
  id: Word;
  ttype:mdht_outpacket_type;
  ipC: Cardinal;
  portW: Word;
  targetsearch: TmDHTsearch;
 end;

 type
 precord_mdht_packet=^record_mdht_packet;
 record_mdht_packet=record
  destIP: Cardinal;
  destPort: Word;
  buffer: string;
 end;

procedure mdht_send(DestinationIP: Cardinal; DestinationPort: Word; packet_type:mdht_outpacket_type; targetSearch: Tmdhtsearch = nil); overload;
procedure mdht_send(DestinationIP: Cardinal; DestinationPort:word); overload;
procedure mdht_freeoutpackets;
function mdht_find_outpacket(packetid: Word; remoteipC: Cardinal; remoteportW:word):precord_outpacket;
procedure mdht_delete_outpacket(packet:precord_outpacket);
procedure mdht_expireoutpackets(nowt: Cardinal);
procedure mdht_flush_udp_packet;

var
 mdht_currentOutpacketIndex: Word;
 mdht_outpackets: TMylist;

implementation

uses
 vars_global,zlib,thread_bittorrent,helper_datetime,helper_ipfunc;

procedure mdht_freeoutpackets;
var
outpacket:precord_outpacket;
begin
 while (mdht_outpackets.count>0) do begin
   outpacket := mdht_outpackets[mdht_outpackets.count-1];
   mdht_outpackets.delete(mdht_outpackets.count-1);
    freemem(outpacket,sizeof(record_outpacket));
 end;
 mdht_outpackets.Free;
end;

function mdht_find_outpacket(packetid: Word; remoteipC: Cardinal; remoteportW:word):precord_outpacket;
var
 i: Integer;
 outpacket:precord_outpacket;
begin
 Result := nil;
 i := 0;
 while (i<mdht_outpackets.count) do begin
  outpacket := mdht_outpackets[i];

   if outpacket.ipC=remoteipC then begin
    if outpacket^.id=packetid then begin
      if outpacket^.portW=remoteportW then begin
       Result := outpacket;
       exit;
      end;
    end;
   end;

  inc(i);
 end;

end;

procedure mdht_delete_outpacket(packet:precord_outpacket);
var
i: Integer;
outpacket:precord_outpacket;
begin

 i := 0;
 while (i<mdht_outpackets.count) do begin
  outpacket := mdht_outpackets[i];
  if outpacket=packet then begin
   mdht_outpackets.delete(i);
   freemem(outpacket,sizeof(record_outpacket));
   exit;
  end;
  inc(i);
 end;
       
end;

procedure mdht_expireoutpackets(nowt: Cardinal);
var
i: Integer;
outpacket:precord_outpacket;
begin

 i := 0;
 while (i<mdht_outpackets.count) do begin
  outpacket := mdht_outpackets[i];
  if thread_bittorrent.mdht_nowt-outpacket^.time>20 then begin
   mdht_outpackets.delete(i);
   freemem(outpacket,sizeof(record_outpacket));
   continue;
  end;
  inc(i);
 end;

end;

procedure mdht_send(DestinationIP: Cardinal; DestinationPort: Word; packet_type:mdht_outpacket_type; targetSearch: Tmdhtsearch = nil);
var
 outpacket:precord_outpacket;
 packet:precord_mdht_packet;
begin
  if MDHT_udp_outpackets.count>1000 then exit;

  if packet_type<>packet_type_none then begin
   outpacket := allocMem(sizeof(record_outpacket));
    outpacket^.time := thread_bittorrent.mdht_nowt;
    outpacket^.id := mdht_currentOutpacketIndex;
    outpacket^.ttype := packet_type;
    outpacket^.ipC := DestinationIP;
    outpacket^.portW := DestinationPort;
    outpacket^.targetsearch := targetSearch;

   mdht_outpackets.add(outpacket);

   inc(mdht_currentOutpacketIndex);
   if mdht_currentOutpacketIndex>=65534 then mdht_currentOutpacketIndex := 0;
  end;

  // delay sending
    packet := AllocMem(sizeof(record_mdht_packet));
     packet.destIP := DestinationIP;
     packet.destPort := DestinationPort;
     SetLength(packet^.buffer,MDHT_len_tosend);
     move(MDHT_buffer,packet^.buffer[1],length(packet^.buffer));
    MDHT_udp_outpackets.add(packet);

end;

procedure mdht_send(DestinationIP: Cardinal; DestinationPort:word);
var
 packet:precord_mdht_packet;
begin
  if MDHT_udp_outpackets.count>1000 then exit;

  // delay sending
    packet := AllocMem(sizeof(record_mdht_packet));
     packet.destIP := DestinationIP;
     packet.destPort := DestinationPort;
     SetLength(packet^.buffer,MDHT_len_tosend);
     move(MDHT_buffer,packet^.buffer[1],length(packet^.buffer));
    MDHT_udp_outpackets.add(packet);

end;

procedure mdht_flush_udp_packet;
var
 packet:precord_mdht_packet;
begin
if MDHT_udp_outpackets.count=0 then exit;

 packet := MDHT_udp_outpackets[0];
         MDHT_udp_outpackets.delete(0);

  MDHT_RemoteSendSin.sin_family := AF_INET;
  MDHT_RemoteSendSin.sin_port := packet^.destPort;
  MDHT_RemoteSendSin.sin_addr.s_addr := packet^.destIP;

 synsock.SendTo(MDHT_socket,packet^.buffer[1],length(packet^.buffer),0,@MDHT_RemoteSendSin,SizeOf(MDHT_RemoteSendSin));

 SetLength(packet^.buffer,0);
 FreeMem(packet,sizeof(record_mdht_packet));
end;

end.