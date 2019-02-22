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
DHT routing bin, each routingzone may have up to 10 contacts in its routing bin
}

unit dht_routingbin;

interface

uses
 classes,classes2,dht_int160,dhtcontact,sysutils,windows,dht_consts;

type
TMDHTRoutingBin = class(TObject)
 m_entries: TMylist;
 m_dontDeletecontacts: Boolean;
 constructor create;
 destructor destroy; override;
 function getContact(id:pCU_INT160): Tmdhtbucket;
 function add(contact: Tmdhtbucket): Boolean;
 function remove(contact: Tmdhtbucket): Boolean;
 procedure getEntries(list: TMylist; emptyFirst:boolean = false);
 function getOldest: Tmdhtbucket;
 function getClosestTo(maxType: Cardinal; target:pCU_INT160; maxRequired: Cardinal;
  ContactMap: TMylist; emptyFirst:boolean=false; inUse:boolean=false): Cardinal;
 procedure setAlive(ip: Cardinal; port:word);
 procedure moveback(c: Tmdhtbucket);
 function FindHost(ip: Cardinal): Tmdhtbucket;
end;

implementation

uses
 helpeR_ipfunc,thread_bittorrent;

function TMDHTRoutingBin.FindHost(ip: Cardinal): Tmdhtbucket;
var
i: Integer;
c: Tmdhtbucket;
begin
result := nil;
	if m_entries.count=0 then exit;

	for i := 0 to m_entries.count-1 do begin
   c := m_entries[i];
		if ip=c.ipC then begin
     Result := c;
     exit;
    end;
  end;
end;

procedure TMDHTRoutingBin.getEntries(list: TMylist; emptyFirst:boolean = false);
var
i: Integer;
con: Tmdhtbucket;
begin

	if emptyFirst then list.clear;

	for i := 0 to m_entries.count-1 do begin
   con := m_entries[i];
   list.add(con);
  end;

end;

function TMDHTRoutingBin.getContact(id:pCU_INT160): Tmdhtbucket;
var
con: Tmdhtbucket;
i: Integer;
begin
	result := nil;

	for i := 0 to m_entries.count-1 do begin
     con := m_entries[i];
     if con.ID[0]<>id[0] then continue;
       if con.ID[1]<>id[1] then continue;
        if con.ID[2]<>id[2] then continue;
         if con.ID[3]<>id[3] then continue;
          if con.ID[4]<>id[4] then continue;

			result := con;
			exit;

	end;

end;

procedure TMDHTRoutingBin.setAlive(ip: Cardinal; port:word);
var
c: Tmdhtbucket;
i: Integer;
begin
	if m_entries.count=0 then exit;

	for i := 0 to m_entries.count-1 do begin
		c := m_entries[i];
		if ip=c.ipC then
     if port=c.portW then begin

			c.updateType;
      
			break;
		 end;
 end;

end;

function TMDHTRoutingBin.getClosestTo(maxType: Cardinal; target:pCU_INT160; maxRequired: Cardinal;
 ContactMap: TMylist; emptyFirst:boolean=false; inUse:boolean=false): Cardinal;
var
i: Integer;
con: Tmdhtbucket;
begin
  Result := 0;
	if m_entries.count=0 then exit;

	if emptyFirst then ContactMap.clear;

	//Put results in sort order for target.
	for i := 0 to m_entries.count-1 do begin
   con := m_entries[i];
		if con.m_type>maxType then continue;

      ContactMap.add(con);
			if inUse then inc(con.m_inUse);

	end;

  thread_bittorrent.mdht_sortCloserContacts(ContactMap,target);  //@contact.me

  while (ContactMap.count>maxRequired) do begin
   if inUse then begin
    con := ContactMap[ContactMap.count-1];
    dec(con.m_inuse);
   end;
   ContactMap.delete(ContactMap.count-1);  // delete extra results
  end;

	result := ContactMap.count;
end;

function TMDHTRoutingBin.remove(contact: Tmdhtbucket): Boolean;
var
ind: Integer;
begin
result := False;

ind := m_entries.indexof(contact);
if ind<>-1 then begin
 m_entries.delete(ind);
 Result := True;
end;

end;

function TMDHTRoutingBin.add(contact: Tmdhtbucket): Boolean;
var
c: Tmdhtbucket;
begin
result := False;

	// If this is already in the entries list
	c := getContact(@Contact.ID);
	if (c<>nil) then begin
		// Move to the end of the list
   moveback(c);
		result := False;
    exit;
	end;
		// If not full, add to end of list

		if m_entries.count<MDHT_K8 then begin
			m_entries.add(contact);
			result := True;
      //outputdebugstring(PChar(formatdatetime('hh:nn:ss.zzz',now)+'> Adding bucket:'+CU_INT160_tohexstr(@contact.id,false)));
		end else begin
			result := False;  //bin full
      
		end;



end;

procedure TMDHTRoutingBin.moveback(c: Tmdhtbucket);
var
 ind: Integer;
begin
ind := m_entries.indexof(c);

if ind<>-1 then
 if ind<>m_entries.count-1 then begin
  m_entries.delete(ind);
  m_entries.add(c);
 end;

end;


function TMDHTRoutingBin.getOldest: Tmdhtbucket;
begin
	if m_entries.count>0 then Result := m_entries[0]
   else Result := nil;
end;

constructor TMDHTRoutingBin.create;
begin
m_dontDeleteContacts := False;
m_entries := Tmylist.create;
end;

destructor TMDHTRoutingBin.destroy;
var
con: Tmdhtbucket;
begin

		if not m_dontDeleteContacts then
			while (m_entries.count>0) do begin
            con := m_entries[m_entries.count-1];
                m_entries.delete(m_entries.count-1);
            con.Free;
		  end;

		m_entries.Free;

inherited;
end;

end.
