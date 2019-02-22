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
DHT binary tree code
}

unit dhtzones;

interface

uses
  Classes, Windows, Math, DhtRoutingbin, Int128, DhtTypes,
  SynSock, SysUtils, Dhtcontact, Classes2;

type
  TRoutingZone = class(Tobject)
    m_subZones: array [0..1] of TRoutingZone;
    m_superZone: TRoutingZone;
    m_bin: TRoutingBin;
    m_zoneIndex:CU_INT128;
    m_level: Cardinal;
    m_nextBigTimer: Cardinal;
    m_nextSmallTimer: Cardinal;
    function isLeaf: Boolean;
    function canSplit: Boolean;
    constructor create;
    destructor destroy; override;

    procedure init(super_zone: TRoutingZone; level: Integer; zone_index:pCU_INT128; shouldStartTimer:boolean=true);
    function Add(id:pCU_Int128; ip: Cardinal; port: Word; tport: Word; ttype: Byte): Boolean;
    procedure split;
    procedure merge;
    function genSubZone(side:integer): TRoutingZone;
    function getNumContacts: Cardinal;
    procedure topDepth(depth: Integer; list: TMylist; emptyFirst:boolean = false);
    procedure randomBin(list: TMylist; emptyFirst:boolean = false);
    procedure startTimer;
    procedure StopTimer;
    function onBigTimer: Boolean;
    procedure onSmallTimer;
    procedure randomLookup;
    function getMaxDepth: Cardinal;
    procedure getAllEntries(list: TMylist; emptyFirst:boolean=false);
    function getClosestTo(maxType: Cardinal; target:pCU_INT128; distance:pCU_INT128;
     maxRequired: Cardinal; ContactMap: TMylist; emptyFirst:boolean=false; inUse:boolean=false): Cardinal;
    function getContact(id:pCU_INT128; distance:pCU_INT128): TContact;
    procedure setAlive(ip: Cardinal; port: Word; setroundtrip:boolean=false);
    function FindHost(ip: Cardinal): TContact;
  end;

procedure DHT_readnodeFile(m_Filename: WideString; root: TRoutingZone);
procedure DHT_writeNodeFile(m_Filename: WideString; root: TRoutingZone);
procedure DHT_getBootstrapContacts(root: TRoutingZone; var list: TMylist; maxRequired: Cardinal);

implementation

uses
  helper_diskio, dhtconsts, dhtutils, helper_registry, dhtsocket,
  dhtsearchmanager, vars_global, helper_ipfunc, helper_datetime;


procedure DHT_writeNodeFile(m_Filename: WideString; root: TRoutingZone);
var
  stream: thandlestream;
  buffer: array [0..24] of Byte;
  i: integer;
  numD: cardinal;
  c: TContact;
  contacts: tmylist;
begin
  stream := MyFileOpen(m_filename,ARES_OVERWRITE_EXISTING);
  if stream=nil then
    exit;

  contacts := tmylist.create;

  DHT_getBootstrapContacts(root,contacts,200);
  numD := min(contacts.Count,CONTACT_FILE_LIMIT);
  stream.write(numD,4);

  for i := 0 to contacts.count-1 do
  begin
    c := contacts[i];

    CU_INT128_CopyToBuffer(@c.m_clientID,@buffer[0]);

    move(c.m_ip,buffer[16],4); // watch it...emule uses reversed order , we don't
    move(c.m_UDPPort,buffer[20],2);
    move(c.m_TCPPort,buffer[22],2);
    buffer[24] := c.m_type;

    stream.write(buffer,25);
    if i=CONTACT_FILE_LIMIT then break;
  end;

  FreeHandleStream(stream);
  contacts.Free;
end;

procedure DHT_readnodeFile(m_Filename: WideString; root: TRoutingZone);
var
stream: Thandlestream;
numEntries: Cardinal;
buffer: array [0..24] of Byte;
i: Integer;
ipC: Cardinal;
UDPPortW,TCPPortW: Word;
ttype: Byte;
clientID:CU_INT128;
begin

stream := MyFileOpen(m_filename,ARES_READONLY_BUT_SEQUENTIAL);
 if stream=nil then begin
  exit;
 end;

numEntries := 0;
if stream.read(numEntries,4)<>4 then begin
 FreeHandleStream(stream);
 exit;
end;

for i := 0 to NumEntries-1 do begin

    if stream.read(buffer,25)<>25 then begin
     break;
    end;

    move(buffer[16],ipC,4);
   // ipC := synsock.ntohl(ipC); // watch it...emule uses reversed order , we don't

    if isAntiP2PIP(ipC) then continue;
    if ip_firewalled(ipC) then continue;


    CU_INT128_CopyFromBuffer(@buffer[0],@ClientID);

    move(buffer[20],UDPPortW,2);
    move(buffer[22],TCPPortW,2);
    ttype := buffer[24];

     if ttype<4 then begin
      root.add(@clientID, ipC, UDPPortW, TCPPortW, ttype);
     end;
end;

FreeHandleStream(stream);
end;

procedure DHT_getBootstrapContacts(root: TRoutingZone; var list: TMylist; maxRequired: Cardinal);
begin
  if root.m_superzone<>nil then exit;

  list.clear;

	root.topDepth(LOG_BASE_EXPONENT{5}, list);
  while (list.count>maxRequired) do list.delete(list.count-1);
end;




///////////////////////////////////////////// TRoutingZone

constructor TRoutingZone.create;
begin
 m_subzones[0] := nil;
 m_subzones[1] := nil;
 m_SuperZone := nil;
end;

destructor TRoutingZone.destroy;
begin
	if isLeaf then m_bin.free
	else begin
		TRoutingZone(m_subZones[0]).Free;
		TRoutingZone(m_subZones[1]).Free;
	end;

inherited;
end;

procedure TRoutingZone.init(super_zone: TRoutingZone; level: Integer; zone_index:pCU_INT128; shouldStartTimer:boolean=true);
begin
	m_superZone := super_zone;
	m_level := level;

  m_zoneIndex[0] := zone_index[0];
  m_zoneIndex[1] := zone_index[1];
  m_zoneIndex[2] := zone_index[2];
  m_zoneIndex[3] := zone_index[3];

	m_subZones[0] := nil;
	m_subZones[1] := nil;

  m_bin := TRoutingBin.create;

 	m_nextSmallTimer := time_now+m_zoneIndex[3];

	if shouldStartTimer then startTimer;
end;


function TRoutingZone.canSplit: Boolean;
begin
result := False;
	if m_level>=127 then exit;

	// Check if we are close to the center
	result := (
            ((CU_INT128_MinorOf(@m_zoneIndex,KK)) or (m_level<KBASE)) and
             (m_bin.m_entries.count=K10)
           );
end;

function TRoutingZone.FindHost(ip: Cardinal): TContact;
begin
 if isLeaf then Result := m_bin.FindHost(ip)
  else begin
   Result := m_subZones[0].FindHost(ip);
   if result<>nil then exit;
   Result := m_subZones[1].FindHost(ip);
  end;
end;



function TRoutingZone.Add(id:pCU_Int128; ip: Cardinal; port: Word; tport: Word; ttype: Byte): Boolean;
var
distance:CU_INT128;
c: TContact;
begin
result := False;

  if id[0]=0 then exit;

  if ((id[0]=0) and
      (id[1]=0) and
      (id[2]=0) and
      (id[3]=0)) then exit;

  if ((DHTme128[0]=id[0]) and
      (DHTme128[1]=id[1]) and
      (DHTme128[2]=id[2]) and
      (DHTme128[3]=id[3])) then exit;

  CU_INT128_fillNXor(@distance,@DHTme128,id);


	try
  
		if not isLeaf then begin
			result := m_subZones[CU_INT128_getBitNumber(@distance,m_level)].add(id, ip, port, tport, ttype);
      exit;
    end;
    

			c := m_bin.getContact(id);
			if c<>nil then begin
				c.m_ip := ip;
				c.m_udpport := port;
				c.m_tcpport := tport;
				result := True;
        exit;
      end;



      if m_bin.m_entries.count<K10 then begin
				c := TContact.create;
        c.Init(ID,ip,Port,tPort,@DHTme128);
				result := m_bin.add(c);
				if not Result then c.Free;
       exit;
			end;


      if canSplit then begin
				split;
				result := m_subZones[CU_INT128_getBitNumber(@distance,m_level)].add(id, ip, port, tport, ttype);
        exit;
       end;


        merge;
				c := TContact.Create;
        c.Init(ID,ip,Port,tPort,@DHTme128);
				result := m_bin.add(c);
				if not Result then c.Free;

   except
   end;


end;



procedure TRoutingZone.setAlive(ip: Cardinal; port: Word; setroundtrip:boolean=false);
begin
 if isLeaf then m_bin.setAlive(ip, port,setroundtrip)
  else begin
   m_subZones[0].setAlive(ip, port,setroundtrip);
   m_subZones[1].setAlive(ip, port,setroundtrip);
  end;
end;

function TRoutingZone.getContact(id:pCU_INT128; distance:pCU_INT128): TContact;
begin
	if isLeaf then Result := m_bin.getContact(id)
   else  Result := m_subZones[CU_INT128_getBitNumber(distance{id},m_level)].getContact(id,distance);
end;

function TRoutingZone.getClosestTo(maxType: Cardinal; target:pCU_INT128; distance:pCU_INT128; maxRequired: Cardinal;
ContactMap: TMylist; emptyFirst:boolean=false; inUse:boolean=false): Cardinal;
var
closer: Integer;
found: Cardinal;
begin
	// If leaf zone, do it here
	if isLeaf then begin
		result := m_bin.getClosestTo(maxType, target, maxRequired, ContactMap, emptyFirst, inUse);
    exit;
	end;

	// otherwise, recurse in the closer-to-the-target subzone first
	closer := CU_INT128_GetBitNumber(distance,m_level);
	found := m_subZones[closer].getClosestTo(maxType, target, distance, maxRequired, ContactMap, emptyFirst, inUse);
  sortCloserContacts(ContactMap,target);

  
	// if still not enough tokens found, recurse in the other subzone too
	if found<maxRequired then begin
   found := found+m_subZones[1-closer].getClosestTo(maxType, target, distance, maxRequired-found, ContactMap, false, inUse);
   sortCloserContacts(ContactMap,target);
	end;

	result := found;
end;

procedure TRoutingZone.getAllEntries(list: TMylist; emptyFirst:boolean=false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
   else begin
		m_subZones[0].getAllEntries(list, emptyFirst);
		m_subZones[1].getAllEntries(list, false);
	end;
end;

procedure TRoutingZone.topDepth(depth: Integer; list: TMylist; emptyFirst:boolean = false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
	 else
    if depth<=0 then randomBin(list, emptyFirst)
	   else begin
		  m_subZones[0].topDepth(depth-1, list, emptyFirst);
		  m_subZones[1].topDepth(depth-1, list, false);
	   end;
end;

procedure TRoutingZone.randomBin(list: TMylist; emptyFirst:boolean = false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
	 else m_subZones[random(2)].randomBin(list, emptyFirst);
end;

function TRoutingZone.getMaxDepth: Cardinal;
begin
 Result := 0;
	if isLeaf then exit;

	result := 1+max(m_subZones[0].getMaxDepth,m_subZones[1].getMaxDepth);
end;

procedure TRoutingZone.split;
var
i,sz: Integer;
con: Tcontact;
begin
	try
	 	stopTimer;
		
		m_subZones[0] := genSubZone(0);
		m_subZones[1] := genSubZone(1);

		for i := 0 to m_bin.m_entries.count-1 do begin
      con := m_bin.m_entries[i];
			sz := CU_INT128_getBitNumber(@con.m_distance,m_level);
			m_subZones[sz].m_bin.add(con);
		end;

		m_bin.m_dontDeleteContacts := True;
		FreeAndNil(m_bin);

	except
  end;
end;



procedure TRoutingZone.merge;
var
i: Integer;
con: TContact;
begin
	try
    if ((isLeaf) and (m_superZone<>nil)) then m_superZone.merge
		else
    if ( (not isLeaf) and
			   ((m_subZones[0].isLeaf) and (m_subZones[1].isLeaf)) and
			    (getNumContacts<(K10 div 2)) ) then begin


			m_bin := TRoutingBin.create;
			
		 	m_subZones[0].stopTimer;
		 	m_subZones[1].stopTimer;

			if getNumContacts>0 then begin
				for i := 0 to m_subzones[0].m_bin.m_entries.count-1 do begin
         con := m_subzones[0].m_bin.m_entries[i];
         m_bin.add(con);
        end;
				for i := 0 to m_subzones[1].m_bin.m_entries.count-1 do begin
         con := m_subzones[1].m_bin.m_entries[i];
         m_bin.add(con);
        end;
			end;

			m_subZones[0].m_superZone := nil;
			m_subZones[1].m_superZone := nil;

			FreeAndNil(m_subZones[0]);
			FreeAndNil(m_subZones[1]);

		 	startTimer;
			
			if m_superZone<>nil then m_superZone.merge;
	  end;
	except
  end;

end;

function TRoutingZone.isLeaf: Boolean;
begin
	result := (m_bin<>nil);
end;

function TRoutingZone.genSubZone(side:integer): TRoutingZone;
var
newIndex:CU_INT128;
begin
  newIndex[0] := m_zoneIndex[0];
  newIndex[1] := m_zoneIndex[1];
  newIndex[2] := m_zoneIndex[2];
  newIndex[3] := m_zoneIndex[3];

  CU_INT128_shiftLeft(@newIndex,1);
	if side<>0 then CU_INT128_add(@newIndex,1);

	result := TRoutingZone.create;
  result.init(self, m_level+1, @newIndex);
end;

procedure TRoutingZone.startTimer;
begin
	// Start filling the tree, closest bins first.
	m_nextBigTimer := time_now+(MIN2S(1)*m_zoneIndex[3])+SEC(10);
  DHT_Events.add(self);
end;

procedure TRoutingZone.stopTimer;
var
ind: Integer;
begin
try
	ind := DHT_Events.indexof(self);
  if ind<>-1 then DHT_events.delete(ind);
except
end;
end;

function TRoutingZone.onBigTimer: Boolean;
begin
  Result := False;
	if not isLeaf then exit;


	if ( (CU_INT128_MinorOf(@m_zoneIndex,KK{5})) or
       (m_level<KBASE{4}) or
       (K10-m_bin.m_entries.count>=(K10*0.4))
       ) then begin
		randomLookup;
		result := True;
	end;
end;


procedure TRoutingZone.onSmallTimer;
var
c: Tcontact;
i: Integer;
nowt: Cardinal;
begin
	if not isLeaf then exit;

	c := nil;
  nowt := time_now;

	try
		// Remove dead entries
    i := 0;
    while (i<m_bin.m_entries.count) do begin
       c := m_bin.m_entries[i];
         if c.m_type=4 then begin
             if (((c.m_expires>0) and (c.m_expires<=nowt))) then begin
                if c.m_inUse=0 then begin
						     m_bin.m_entries.delete(i);
						     c.Free;
                end else inc(i);
               continue;
					   end;
         end;
			if c.m_expires=0 then c.m_expires := nowt;
      inc(i);
    end;


		c := nil;
		//Ping only contacts that are in the branches that meet the set level and are not close to our ID.
		//The other contacts are checked with the big timer.   ( 7-10 m_bin )
		if K10-m_bin.m_entries.count<KPINGABLE{4} then c := m_bin.getOldest;
		if c<>nil then begin
			 if ((c.m_expires>=nowt) or
           (c.m_type=4)) then begin  // already pinged or awaiting for expiration, move ahead = fresh?
			     	m_bin.moveback(c);
				    c := nil;
			 end;
		end;
    
	except
  end;

	if c<>nil then begin
		c.checkingType;
    c.m_outHelloTime := gettickcount;
		DHT_sendMyDetails(CMD_DHT_HELLO_REQ, c.m_ip, c.m_UDPPort);
	end;

end;

procedure TRoutingZone.randomLookup;
var
prefix:CU_INT128;
rando:CU_INT128;
begin
	// Look-up a random client in this zone
  CU_INT128_fill(@prefix,@m_zoneIndex);

  CU_Int128_shiftLeft(@prefix,128-m_level);

  CU_INT128_fill(@rando,@prefix,m_level);

  rando[0] := rando[0] xor DHTme128[0];
  rando[1] := rando[1] xor DHTme128[1];
  rando[2] := rando[2] xor DHTme128[2];
  rando[3] := rando[3] xor DHTme128[3];

	DHTSearchManager.findNode(@rando);
end;

function TRoutingZone.getNumContacts: Cardinal;
begin
	if isLeaf then
    Result := m_bin.m_entries.count
  else
    Result := m_subZones[0].getNumContacts+m_subZones[1].getNumContacts;
end;

end.
