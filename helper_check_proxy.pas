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
used by control panel->proxy->check connection event...should help user with proxy configuration
}

unit helper_check_proxy;

interface

uses
classes,classes2,blcksock,helper_sockets,windows,winsock,helper_unicode,vars_localiz;

 type
  tthread_checkproxy = class(tthread)
  protected
  procedure execute; override;
   procedure connection_failed; //synch
   procedure connection_succeded; //synch
  end;

implementation

uses
 ufrmmain,ufrm_settings;

procedure tthread_checkproxy.execute;
var
 socket: Ttcpblocksocket;
 tempo: Cardinal;
 er: Integer;
 lista: TMyStringList;
 ips: string;
begin
freeonterminate := True;
priority := tplower;

socket := ttcpblocksocket.create(true);
 assign_proxy_settings(socket);

  if socket.FSockSType=ST_Socks4 then begin //resolve hostnames for sock4 proxies
   lista := tmyStringList.create;  
   ResolveNameToIP('www.networksolutions.com',lista);
    if lista.count<1 then begin
     lista.Free;
     socket.Free;
     exit;
    end;
    ips := lista.strings[0];
   lista.Free;
 end else ips := 'www.networksolutions.com';


  socket.ip := ips;
  socket.port := 80;
  socket.Connect(ips,'80');
  
  sleep(100);
   tempo := gettickcount;
  while (gettickcount-tempo<15000) do begin

    er := TCPSocket_ISConnected(socket);
    if er=WSAEWOULDBLOCK then begin
     sleep(100);
     continue;
    end;
    if er<>0 then begin
      synchronize(connection_failed);
      socket.Free;
      exit;
    end;
     synchronize(connection_succeded);
    socket.Free;
    exit;
  end;

   synchronize(connection_failed); //timeout
   socket.Free;

end;

procedure tthread_checkproxy.connection_failed; //synch
begin
if frm_settings=nil then exit;

 with frm_settings do begin
  lbl_opt_proxy_check.caption := GetLangStringW(STR_CHECKPROXY_FAILED);
  btn_opt_proxy_check.enabled := True;
  radiobtn_noproxy.enabled := True;
  radiobtn_proxy4.enabled := True;
  radiobtn_proxy5.enabled := True;
  Edit_opt_proxy_addr.Enabled := True;
  edit_opt_proxy_login.Enabled := True;
  edit_opt_proxy_pass.Enabled := True;
 end;
end;

procedure tthread_checkproxy.connection_succeded; //synch
begin
if frm_settings=nil then exit;

 with frm_settings do begin
  lbl_opt_proxy_check.caption := GetLangStringW(STR_CHECKPROXY_SUCCEDED);
  btn_opt_proxy_check.enabled := True;
  radiobtn_noproxy.enabled := True;
  radiobtn_proxy4.enabled := True;
  radiobtn_proxy5.enabled := True;
  Edit_opt_proxy_addr.Enabled := True;
  edit_opt_proxy_login.Enabled := True;
  edit_opt_proxy_pass.Enabled := True;
 end;
end;

end.
