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

unit dht_zones;

interface

uses
 dht_routingbin,dht_int160,classes,windows,
 synsock,sysutils,math,classes2,dht_consts;

 type
 TMDHTRoutingZone = class(Tobject)
 	m_subZones: array [0..1] of TMDHTRoutingZone;
	m_superZone: TMDHTRoutingZone;
  m_bin: TMDHTRoutingBin;
  m_zoneIndex:CU_INT160;
  m_level: Cardinal;
  m_nextBigTimer: Cardinal;
	m_nextSmallTimer: Cardinal;
  function isLeaf: Boolean;
  function canSplit: Boolean;
  constructor create;
  destructor destroy; override;

  procedure init(super_zone: TMDHTRoutingZone; level: Integer; zone_index:pCU_INT160; shouldStartTimer:boolean=true);
  function Add(id:pCU_Int160; ip: Cardinal; port: Word; ttype: Byte): Boolean;
  procedure split;
  procedure merge;
  function genSubZone(side:integer): TMDHTRoutingZone;
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
  function getClosestTo(maxType: Cardinal; target:pCU_INT160; distance:pCU_INT160;
   maxRequired: Cardinal; ContactMap: TMylist; emptyFirst:boolean=false; inUse:boolean=false): Cardinal;
  function getContact(id:pCU_INT160; distance:pCU_INT160): Tmdhtbucket;
  procedure setAlive(ip: Cardinal; port:word);
  function FindHost(ip: Cardinal): Tmdhtbucket;

 end;

  procedure MDHT_readnodeFile(m_Filename: WideString; root: TMDHTRoutingZone);
  procedure MDHT_writeNodeFile(m_Filename: WideString; root: TMDHTRoutingZone);
  procedure MDHT_getBootstrapContacts(root: TMDHTRoutingZone; var list: TMylist; maxRequired: Cardinal);

implementation

uses
 helper_diskio,helper_registry,dht_socket,thread_bittorrent,
 dht_searchmanager,vars_global,helper_ipfunc,helper_datetime;


procedure MDHT_writeNodeFile(m_Filename: WideString; root: TMDHTRoutingZone);
var
stream: Thandlestream;
buffer: array [0..26] of Byte;
i: Integer;
numD: Cardinal;
c: Tmdhtbucket;
contacts: TMylist;
begin

stream := MyFileOpen(m_filename,ARES_OVERWRITE_EXISTING);
 if stream=nil then begin
  exit;
 end;

contacts := tmylist.create;

 MDHT_getBootstrapContacts(root,contacts,200);
 numD := min(contacts.Count,5000);
 stream.write(numD,4);

 for i := 0 to contacts.count-1 do begin
  c := contacts[i];

  CU_INT160_CopyToBuffer(@c.ID,@buffer[0]);

  move(c.ipC,buffer[20],4); // watch it...emule uses reversed order , we don't
  move(c.portW,buffer[24],2);
  buffer[26] := c.m_type;

   stream.write(buffer,sizeof(buffer));
   if i=5000 then break;
 end;

FreeHandleStream(stream);
contacts.Free;
end;

procedure MDHT_readnodeFile(m_Filename: WideString; root: TMDHTRoutingZone);
var
stream: Thandlestream;
numEntries: Cardinal;
buffer: array [0..26] of Byte;
i: Integer;
ipC: Cardinal;
UDPPortW: Word;
ttype: Byte;
clientID:CU_INT160;
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

    //  outputdebugstring(PChar(formatdatetime('hh:nn:ss.zzz',now)+'> Loading toplevel bucket'));
    //  outputdebugstring(PChar(formatdatetime('hh:nn:ss.zzz',now)+'> Me: '+CU_INT160_tohexstr(@DHTme160,false)));
for i := 0 to NumEntries-1 do begin

    if stream.read(buffer,sizeof(buffer))<>sizeof(buffer) then begin
     break;
    end;

    move(buffer[20],ipC,4);
   // ipC := synsock.ntohl(ipC); // watch it...emule uses reversed order , we don't

    if isAntiP2PIP(ipC) then continue;
    if ip_firewalled(ipC) then continue;
   

    CU_INT160_CopyFromBuffer(@buffer[0],@ClientID);
   // outputdebugstring(PChar(formatdatetime('hh:nn:ss.zzz',now)+'> '+CU_INT160_tohexstr(@ClientID,true)));
    
    move(buffer[24],UDPPortW,2);
    ttype := buffer[26];

     if ttype<4 then begin
      root.add(@clientID, ipC, UDPPortW, ttype);
     end;
end;

FreeHandleStream(stream);
end;

procedure MDHT_getBootstrapContacts(root: TMDHTRoutingZone; var list: TMylist; maxRequired: Cardinal);
begin
  if root.m_superzone<>nil then exit;

  list.clear;

	root.topDepth(5, list);
  while (list.count>maxRequired) do list.delete(list.count-1);
end;




///////////////////////////////////////////// TRoutingZone

constructor TMDHTRoutingZone.create;
begin
 m_subzones[0] := nil;
 m_subzones[1] := nil;
 m_SuperZone := nil;
 m_bin := nil;
end;

destructor TMDHTRoutingZone.destroy;
begin
	if isLeaf then m_bin.free
	else begin
		TMDHTRoutingZone(m_subZones[0]).Free;
		TMDHTRoutingZone(m_subZones[1]).Free;
	end;

inherited;
end;

procedure TMDHTRoutingZone.init(super_zone: TMDHTRoutingZone; level: Integer; zone_index:pCU_INT160; shouldStartTimer:boolean=true);
begin
	m_superZone := super_zone;
	m_level := level;

  m_zoneIndex[0] := zone_index[0];
  m_zoneIndex[1] := zone_index[1];
  m_zoneIndex[2] := zone_index[2];
  m_zoneIndex[3] := zone_index[3];
  m_zoneIndex[4] := zone_index[4];

	m_subZones[0] := nil;
	m_subZones[1] := nil;

  m_bin := TMDHTRoutingBin.create;

 	m_nextSmallTimer := time_now+m_zoneIndex[3];

	if shouldStartTimer then startTimer;
end;


function TMDHTRoutingZone.canSplit: Boolean;
begin
result := False;
	if m_level>=159 then exit;

	// Check if we are close to the center
	result := (
            ((CU_INT160_MinorOf(@m_zoneIndex,MDHT_KK{5})) or (m_level<MDHT_KBASE{4})) and
             (m_bin.m_entries.count=MDHT_K8{8})
           );
end;

function TMDHTRoutingZone.FindHost(ip: Cardinal): Tmdhtbucket;
begin
 if isLeaf then Result := m_bin.FindHost(ip)
  else begin
   Result := m_subZones[0].FindHost(ip);
   if result<>nil then exit;
   Result := m_subZones[1].FindHost(ip);
  end;
end;



function TMDHTRoutingZone.Add(id:pCU_Int160; ip: Cardinal; port: Word; ttype: Byte): Boolean;
var
distance:CU_INT160;
c: Tmdhtbucket;
begin
result := False;

  if id[0]=0 then exit;

  if ((id[0]=0) and
      (id[1]=0) and
      (id[2]=0) and
      (id[3]=0) and
      (id[4]=0)) then exit;

  if ((DHTme160[0]=id[0]) and
      (DHTme160[1]=id[1]) and
      (DHTme160[2]=id[2]) and
      (DHTme160[3]=id[3]) and
      (DHTme160[4]=id[4])) then exit;

  CU_INT160_fillNXor(@distance,@DHTme160,id);


	try
  
		if not isLeaf then begin
			result := m_subZones[CU_INT160_getBitNumber(@distance,m_level)].add(id, ip, port, ttype);
      exit;
    end;


			c := m_bin.getContact(id);
			if c<>nil then begin
				c.ipC := ip;
				c.portW := port;
				result := True;
        exit;
      end;



      if m_bin.m_entries.count<MDHT_K8 then begin
				c := tmdhtbucket.create;
        c.Init(ID,ip,Port,@DHTme160);
				result := m_bin.add(c);
				if not Result then c.Free;
       // outputdebugstring(PChar(formatdatetime('hh:nn:ss.zzz',now)+'> Zone level:'+inttostr(m_level)+' Adding bucket:'+CU_INT160_tohexstr(ID,true)+' distance:'+CU_INT160_tohexstr(@distance,true)));
       exit;
			end;


      if canSplit then begin
				split;
				result := m_subZones[CU_INT160_getBitNumber(@distance,m_level)].add(id, ip, port, ttype);
        exit;
       end;


        merge;
				c := tmdhtbucket.Create;
        c.Init(ID,ip,Port,@DHTme160);
				result := m_bin.add(c);
				if not Result then c.Free;

   except
   end;


end;



procedure TMDHTRoutingZone.setAlive(ip: Cardinal; port:word);
begin
 if isLeaf then begin
  m_bin.setAlive(ip, port);
 end else begin
   m_subZones[0].setAlive(ip, port);
   m_subZones[1].setAlive(ip, port);
  end;
end;

function TMDHTRoutingZone.getContact(id:pCU_INT160; distance:pCU_INT160): Tmdhtbucket;
begin
	if isLeaf then Result := m_bin.getContact(id)
   else  Result := m_subZones[CU_INT160_getBitNumber(distance{id},m_level)].getContact(id,distance);
end;

function TMDHTRoutingZone.getClosestTo(maxType: Cardinal; target:pCU_INT160; distance:pCU_INT160; maxRequired: Cardinal;
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
	closer := CU_INT160_GetBitNumber(distance,m_level);
	found := m_subZones[closer].getClosestTo(maxType, target, distance, maxRequired, ContactMap, emptyFirst, inUse);
  mdht_sortCloserContacts(ContactMap,target);

  
	// if still not enough tokens found, recurse in the other subzone too
	if found<maxRequired then begin
   found := found+m_subZones[1-closer].getClosestTo(maxType, target, distance, maxRequired-found, ContactMap, false, inUse);
   mdht_sortCloserContacts(ContactMap,target);
	end;

	result := found;
end;

procedure TMDHTRoutingZone.getAllEntries(list: TMylist; emptyFirst:boolean=false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
   else begin
		m_subZones[0].getAllEntries(list, emptyFirst);
		m_subZones[1].getAllEntries(list, false);
	end;
end;

procedure TMDHTRoutingZone.topDepth(depth: Integer; list: TMylist; emptyFirst:boolean = false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
	 else
    if depth<=0 then randomBin(list, emptyFirst)
	   else begin
		  m_subZones[0].topDepth(depth-1, list, emptyFirst);
		  m_subZones[1].topDepth(depth-1, list, false);
	   end;
end;

procedure TMDHTRoutingZone.randomBin(list: TMylist; emptyFirst:boolean = false);
begin
	if isLeaf then m_bin.getEntries(list, emptyFirst)
	 else m_subZones[random(2)].randomBin(list, emptyFirst);
end;

function TMDHTRoutingZone.getMaxDepth: Cardinal;
begin
 Result := 0;
	if isLeaf then exit;

	result := 1+max(m_subZones[0].getMaxDepth,m_subZones[1].getMaxDepth);
end;

procedure TMDHTRoutingZone.split;
var
i,sz: Integer;
con: Tmdhtbucket;
begin
	try
	 	stopTimer;
		
		m_subZones[0] := genSubZone(0);
		m_subZones[1] := genSubZone(1);

		for i := 0 to m_bin.m_entries.count-1 do begin
      con := m_bin.m_entries[i];
			sz := CU_INT160_getBitNumber(@con.m_distance,m_level);
			m_subZones[sz].m_bin.add(con);
		end;

		m_bin.m_dontDeleteContacts := True;
		FreeAndNil(m_bin);

	except
  end;
end;



procedure TMDHTRoutingZone.merge;
var
i: Integer;
con: Tmdhtbucket;
begin
	try
    if ((isLeaf) and (m_superZone<>nil)) then m_superZone.merge
		else
    if ( (not isLeaf) and
			   ((m_subZones[0].isLeaf) and (m_subZones[1].isLeaf)) and
			    (getNumContacts<(MDHT_K8 div 2)) ) then begin


			m_bin := TMDHTRoutingBin.create;
			
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

function TMDHTRoutingZone.isLeaf: Boolean;
begin
	result := (m_bin<>nil);
end;

function TMDHTRoutingZone.genSubZone(side:integer): TMDHTRoutingZone;
var
newIndex:CU_INT160;
begin
  newIndex[0] := m_zoneIndex[0];
  newIndex[1] := m_zoneIndex[1];
  newIndex[2] := m_zoneIndex[2];
  newIndex[3] := m_zoneIndex[3];
  newIndex[4] := m_zoneIndex[4];

  CU_INT160_shiftLeft(@newIndex,1);
	if side<>0 then CU_INT160_add(@newIndex,1);

	result := TMDHTRoutingZone.create;
  result.init(self, m_level+1, @newIndex);
end;

procedure TMDHTRoutingZone.startTimer;
begin
	// Start filling the tree, closest bins first.
	m_nextBigTimer := time_now+(MIN2S(1)*m_zoneIndex[3])+SEC(10);
  MDHT_Events.add(self);
end;

procedure TMDHTRoutingZone.stopTimer;
var
ind: Integer;
begin
try
	ind := MDHT_Events.indexof(self);
  if ind<>-1 then MDHT_events.delete(ind);
except
end;
end;

function TMDHTRoutingZone.onBigTimer: Boolean;
begin
  Result := False;
	if not isLeaf then exit;


	if ( (CU_INT160_MinorOf(@m_zoneIndex,MDHT_KK{5})) or
       (m_level<MDHT_KBASE{4}) or
       (MDHT_K8-m_bin.m_entries.count>=(MDHT_K8*0.4))
       ) then begin
		randomLookup;
		result := True;
	end;
end;


procedure TMDHTRoutingZone.onSmallTimer;
var
c: Tmdhtbucket;
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
		if MDHT_K8-m_bin.m_entries.count<MDHT_KPINGABLE{4} then c := m_bin.getOldest;
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
    mdht_ping_host(c.ipC,c.portW);
	end;

end;

procedure TMDHTRoutingZone.randomLookup;
var
prefix:CU_INT160;
rando:CU_INT160;
begin
	// Look-up a random client in this zone
  CU_INT160_fill(@prefix,@m_zoneIndex);

  CU_Int160_shiftLeft(@prefix,160-m_level);

  CU_INT160_fill(@rando,@prefix,m_level);

  rando[0] := rando[0] xor DHTme160[0];
  rando[1] := rando[1] xor DHTme160[1];
  rando[2] := rando[2] xor DHTme160[2];
  rando[3] := rando[3] xor DHTme160[3];
  rando[4] := rando[4] xor DHTme160[4];

	DHT_SearchManager.findNode(@rando);
end;

function TMDHTRoutingZone.getNumContacts: Cardinal;
begin
	if isLeaf then Result := m_bin.m_entries.count
	 else Result := m_subZones[0].getNumContacts+m_subZones[1].getNumContacts;
end;





end.
