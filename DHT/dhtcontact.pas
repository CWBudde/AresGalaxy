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
DHT nodes
 m_type = related to node's uptime , the lower the higher the uptime  , 4 = possibly stale node
 m_tcpport and udpport are the same on the Ares DHT implementation
 m_distance is relative con us (DHTMe)
}

unit dhtcontact;

interface

uses
  Classes, Classes2, Int128, Windows, DhtTypes, SysUtils;

type
  TContact = class(TObject)
    m_clientID:CU_Int128;
    m_distance:CU_Int128;
    m_ip: Cardinal;
    m_tcpPort: Word;
    m_udpPort: Word;
    m_type: Byte;
    m_lastTypeSet: Cardinal;
    m_expires: Cardinal;
    m_inUse: Cardinal;
    m_created: Cardinal;
    m_rtt: Cardinal;
    m_outhellotime: Cardinal;
    procedure Init(const clientID:pCU_Int128; ip: Cardinal; udpPort: Word; tcpPort: Word; const target:pCU_Int128);
    constructor create; // Common var initialization goes here
    procedure checkingType;
    procedure updateType;
    destructor destroy; override;
  end;

procedure sortCloserContacts(list: Tmylist; FromTarget: pCU_INT128);
procedure sortFarestContacts(list: Tmylist; FromTarget: pCU_INT128);

implementation

uses
  DhtConsts, Helper_DateTime, Vars_Global;


procedure sortCloserContacts(list: TMylist; FromTarget:pCU_INT128);

  function SCompare(item1,item2: Pointer): Integer;
  var
  c1,c2: TContact;
  begin
  c1 := TContact(item1);
  c2 := TContact(item2);

   Result := (c1.m_clientid[0] xor FromTarget[0]) -
           (c2.m_clientid[0] xor FromTarget[0]);   //smaller distance first
   if result<>0 then exit;
   Result := (c1.m_clientid[1] xor FromTarget[1]) -
           (c2.m_clientid[1] xor FromTarget[1]);   //smaller distance first
   if result<>0 then exit;
   Result := (c1.m_clientid[2] xor FromTarget[2]) -
           (c2.m_clientid[2] xor FromTarget[2]);   //smaller distance first
   if result<>0 then exit;
   Result := (c1.m_clientid[3] xor FromTarget[3]) -
           (c2.m_clientid[3] xor FromTarget[3]);   //smaller distance first

  end;

  procedure QuickSort(SortList: TmyList; L, R: Integer);
  var
    I, J: Integer;
    P, T: Pointer;
  begin
  try
   repeat
    I := L;
    J := R;
    P := SortList[(L + R) shr 1];
    repeat
      while SCompare(SortList[I], P) < 0 do Inc(I);
      while SCompare(SortList[J], P) > 0 do Dec(J);
      if I <= J then begin
        T := SortList[I];
        SortList[I] := SortList[J];
        SortList[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J);
    L := I;
   until I >= R;
   except
   end;
  end;

begin
if list.count>0 then QuickSort(List, 0, List.Count - 1);
end;

Procedure sortFarestContacts(list: TMylist; FromTarget:pCU_INT128);

  function SCompare(item1,item2: Pointer): Integer;
  var
  c1,c2: TContact;
  begin
  c1 := TContact(item1);
  c2 := TContact(item2);

   Result := (c2.m_clientid[0] xor FromTarget[0]) -
           (c1.m_clientid[0] xor FromTarget[0]);   //smaller distance first
   if result<>0 then exit;
   Result := (c2.m_clientid[1] xor FromTarget[1]) -
           (c1.m_clientid[1] xor FromTarget[1]);   //smaller distance first
   if result<>0 then exit;
   Result := (c2.m_clientid[2] xor FromTarget[2]) -
           (c1.m_clientid[2] xor FromTarget[2]);   //smaller distance first
   if result<>0 then exit;
   Result := (c2.m_clientid[3] xor FromTarget[3]) -
           (c1.m_clientid[3] xor FromTarget[3]);   //smaller distance first

  end;

  procedure QuickSort(SortList: TmyList; L, R: Integer);
  var
    I, J: Integer;
    P, T: Pointer;
  begin
   repeat
    I := L;
    J := R;
    P := SortList[(L + R) shr 1];
    repeat
      while SCompare(SortList[I], P) < 0 do Inc(I);
      while SCompare(SortList[J], P) > 0 do Dec(J);
      if I <= J then begin
        T := SortList[I];
        SortList[I] := SortList[J];
        SortList[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J);
    L := I;
   until I >= R;
  end;

begin
QuickSort(List, 0, List.Count - 1);
end;

constructor TContact.create;
begin
	m_type := 3;
	m_expires := 0;
	m_lastTypeSet := time_now;
  m_created := m_lastTypeSet;
	m_inUse := 0;
  m_rtt := 0;
  m_outhellotime := 0;
  inc(vars_global.DHT_availableContacts);
end;

destructor TContact.destroy;
begin
 dec(vars_global.DHT_availableContacts);
inherited;
end;

procedure TContact.Init(const clientID:pCU_Int128; ip: Cardinal; udpPort: Word; tcpPort: Word; const target:pCU_Int128);
begin
	CU_INT128_Fill(@m_clientID,clientID);
  CU_INT128_FillNXor(@m_distance,@m_clientID,target);
	m_ip := ip;
	m_udpPort := udpPort;
	m_tcpPort := tcpPort;
end;

procedure TContact.checkingType;
begin
	if ((time_now-m_lastTypeSet<10) or
      (m_type=4)) then exit;

	m_lastTypeSet := time_now;

	m_expires := m_lastTypeSet + MIN2S(2);
	inc(m_type);

  if m_type=3 then dec(vars_global.DHT_AliveContacts);
end;

procedure TContact.updateType;
var
hours: Cardinal;
begin
if m_type>=3 then inc(vars_global.DHT_AliveContacts);

	hours := (time_now-m_created) div HR2S(1);
	case hours of
		0:begin
			m_type := 2;
			m_expires := time_now+HR2S(1);
    end;
		1:begin
			m_type := 1;
			m_expires := time_now+HR2S(1.5);
		end else begin
			m_type := 0;
			m_expires := time_now+HR2S(2);
     end;
  end;

end;

end.
