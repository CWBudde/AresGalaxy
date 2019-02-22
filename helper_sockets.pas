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
some helpfull socket functions and classes
}

unit helper_sockets;

interface

uses
classes,blcksock,ares_types,windows,sysutils,winsock,vars_global;

const
SOCKET_ERROR			= -1;

procedure assign_proxy_settings(socket: Ttcpblocksocket);
function probe_socket(socket:integer): Boolean;

implementation

uses
ufrmmain;

function probe_socket(socket:integer): Boolean;
var er: Integer;
buffer: array [0..1] of char;
begin
if not TCPSocket_CanRead(socket,0,er) then begin
   Result := ((er=0) or (er=WSAEWOULDBLOCK));
end else begin
 TCPSocket_RecvBuffer(socket,@buffer,1,er);
 Result := ((er=0) or (er=WSAEWOULDBLOCK));
end;
end;

procedure assign_proxy_settings(socket: Ttcpblocksocket);
begin
 if vars_global.socks_type=SocTNone then begin
  socket.SocksIP := '';
  socket.SocksPort := '0';
 end else begin
  socket.FLastTime := gettickcount; //per vari timeout in TCPSocket_connesso()
  socket.SocksIp := vars_global.socks_ip;
  socket.SocksPort := inttostr(vars_global.socks_port);
  if vars_global.socks_type=SocTSock5 then begin
    socket.SocksType := ST_Socks5;
    socket.SocksUsername := vars_global.socks_username;
    socket.SocksPassword := vars_global.socks_password;
  end else socket.SocksType := ST_Socks4;
  socket.FStatoConn := PROXY_InConnessione;
 end;
end;


end.
