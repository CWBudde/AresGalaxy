unit helper_upnp;

interface

uses
 windows,sysutils,ComObj,Variants,ActiveX;

  type
  TUPnP_PortMapTable = class
  public
    class function add(const active: Boolean; const extPort, intPort: DWORD;
      const ip, proto, desc: String): Boolean;
    class function remove(const extPort: DWORD; const proto: String): Boolean;
  end;

  procedure map_ports;
  procedure unmap_ports;

implementation

uses
 ufrmmain,vars_global;

procedure map_ports;
begin
  TUPnP_PortMapTable.remove(vars_global.myport, 'tcp');
  TUPnP_PortMapTable.remove(vars_global.myport, 'udp');
 // TUPnP_PortMapTable.remove(vars_global.myport+1, 'udp');

  TUPnP_PortMapTable.add(true, vars_global.myport, vars_global.myport, vars_global.LocalIP, 'TCP', 'AresTCP');
  TUPnP_PortMapTable.add(true, vars_global.myport, vars_global.myport, vars_global.LocalIP, 'UDP', 'AresUDP');
end;

procedure unmap_ports;
begin
  TUPnP_PortMapTable.remove(vars_global.myport, 'tcp');
  TUPnP_PortMapTable.remove(vars_global.myport, 'udp');
end;

class function TUPnP_PortMapTable.add(const active: Boolean; const extPort, intPort: DWORD;
  const ip, proto, desc: String): Boolean;
var
  n, p: Variant;
Begin
  Result := False;
  try
    n := CreateOleObject('HNetCfg.NATUPnP');
    p := n.StaticPortMappingCollection;
    if not VarIsClear(p) then
    begin
      p.Add(extPort, UpperCase(proto), intPort, ip, active, desc);
      Result := True;
    end;
  except
// on e: exception do showmessage(e.Message);
  end;
end;

class function TUPnP_PortMapTable.remove(const extPort: DWORD; const proto: String): Boolean;
var
  n, p: Variant;
Begin
  Result := False;
  try
    n := CreateOleObject('HNetCfg.NATUPnP');
    p := n.StaticPortMappingCollection;
    if not VarIsClear(p) then
      Result := p.Remove(extPort, UpperCase(proto)) = S_OK;
  except
// on e: exception do showmessage(e.Message);
  end;
end;

end.