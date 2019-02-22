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
DHT low level search code
}

unit dhtsearch;

interface

uses
  int128, classes, classes2, math, dhtconsts, windows,
  sysutils, dhtcontact, dhttypes, utility_ares;

type
  TDHTsearch = class(Tobject)
    m_type: Tdhtsearchtype;
    m_stoping: Boolean;
    m_created,
    m_answers,
    m_totalRequestAnswers,
    m_PacketSent: Cardinal; //Used for gui reasons.. May not be needed later..
    m_lastResponse: Cardinal;

    m_searchID: Word;
    m_target:CU_INT128;
    m_outPayload: string;
    m_publishKeyPayloads: TMyStringList;

    m_possible,
    m_tried,
    m_responded,
    m_best,
    m_delete,
    m_inUse: TMylist;
   // procedure dump_distances(target:pCU_INT128);
    m_wantmime: Byte;

    constructor create;
    destructor destroy; override;

    procedure StartIDSearch;
    procedure sendFindID(check:pCU_INT128; ip: Cardinal; port:word);
    function Find_Replying_Contact(IP: Cardinal;Port:word): TContact;
    procedure processResponse(fromIP: Cardinal; fromPort: Word; results: TMylist);
    procedure expire;
    procedure CheckStatus;
    procedure PerformActionOnBestNode;
    function has_contacts_withID(list: TMylist; id:pCU_INT128): Boolean;
    function has_contacts_withDistance(list: TMylist; Distance:pCU_INT128): Boolean;
  end;

implementation

uses
  dhtUtils,thread_dht,helpeR_ipfunc,vars_global,helper_datetime,
  dhtsocket,helper_strings,DHTSearchManager;

constructor TDHTsearch.create;
begin
	m_created := time_now;
	m_outPayload := '';
	m_type := UNDEFINED;
	m_answers := 0;
	m_totalRequestAnswers := 0;
	m_PacketSent := 0;
	m_searchID := 0;
  m_publishKeyPayloads := nil;
	m_stoping := False;
	m_lastResponse := m_created;

  m_possible := tmylist.create;
  m_tried := tmylist.create;
  m_responded := tmylist.create;
  m_best := tmylist.create;
  m_delete := tmylist.create;
  m_inUse := tmylist.create;
end;

destructor TDHTsearch.destroy;
var
c: TContact;
i: Integer;
begin

for i := 0 to m_inUse.count-1 do begin
 c := m_inUse[i];
 if c.m_inuse>0 then dec(c.m_inuse);
end;

while (m_delete.count>0) do begin
   c := m_delete[m_delete.count-1];
      m_delete.delete(m_delete.count-1);
   c.Free;
end;

  m_possible.Free;
  m_tried.Free;
  m_responded.Free;
  m_best.Free;
  m_delete.Free;
  m_inUse.Free;

  if m_publishKeyPayloads<>nil then m_publishKeyPayloads.Free;

inherited;
end;


procedure TDHTSearch.PerformActionOnBestNode;
var
from: TContact;
begin

   sortCloserContacts(m_possible,@m_target);

   from := m_possible[0];

	if (from.m_clientID[0] xor m_target[0])>SEARCHTOLERANCE then begin
   if m_type=KEYWORD then
  // utility_ares.debuglog('DHT search node to far :-(');
   exit;
  end;
  

	case m_type of
    
    KEYWORD:begin //search for files for a particular keyword
      DHT_len_tosend := length(m_outPayload)+2;
      move(m_outPayload[1],DHT_buffeR[2],length(m_outPayload));
      DHT_buffer[1] := CMD_DHT_SEARCHKEY_REQ;
     // utility_ares.debuglog('DHT sending keysearch to target '+ipint_to_dotstring(from.m_ip));
      DHT_send(from.m_ip, from.m_udpport, false);
			inc(m_totalRequestAnswers);
		end;


		STOREFILE:begin // store himself as a source for a particular HASH
		  if m_answers>SEARCHSTOREFILE_TOTAL then begin
				expire;
				exit;
			end;
      DHT_len_tosend := length(m_outPayload)+2;
      move(m_outPayload[1],DHT_buffeR[2],length(m_outPayload));
      DHT_buffer[1] := CMD_DHT_PUBLISHHASH_REQ;
      DHT_send(from.m_ip, from.m_udpport, false);
			inc(m_totalRequestAnswers);
		end;


		STOREKEYWORD:begin  // store file including keywords
			if m_answers>SEARCHSTOREKEYWORD_TOTAL then begin
				expire;
				exit;
			end;
      DHTSearchManager.SendPublishKeyFiles(self,from.m_ip,From.m_udpPort);
      inc(m_totalRequestAnswers);
		 end;


		FINDSOURCE:begin // search for sources for a particular HASH
		 if m_answers>SEARCHFINDSOURCE_TOTAL then begin
				expire;
				exit;
			end;
      DHT_len_tosend := length(m_outPayload)+2;
      move(m_outPayload[1],DHT_buffeR[2],length(m_outPayload));
      DHT_buffer[1] := CMD_DHT_SEARCHHASH_REQ;
      DHT_send(from.m_ip, from.m_udpport, false);
			inc(m_totalRequestAnswers);
		end;

	end;
end;

procedure TDHTSearch.CheckStatus;   //every second
var
c: TContact;
begin

	if m_possible.count=0 then begin
      if m_type<>NODE then begin
        if ((m_created+SEC(20)<time_now)) then begin
	      	expire;
	      	exit;
        end;
      end else begin
       expire;
       exit;
      end;
	end;

	if m_lastResponse+SEC(3)>time_now then exit;  // every 3 seconds out search

  sortCloserContacts(m_possible,@m_target);
	while (m_possible.count>0) do begin
	     c := m_possible[0];

		//Have we already tried to contact this node.
    if has_contacts_withid(m_tried,@c.m_clientID) then begin

			//Did we get a response from this node, if so, try to store or get info.
			if has_contacts_withid(m_responded,@c.m_clientID) then PerformActionOnBestNode;
			m_possible.delete(0);

		end else begin
			// Move to tried
			m_tried.add(c);
			// Send request
			c.checkingType;
      //if m_type=KEYWORD then utility_ares.debuglog('DHT searching ID on '+ipint_to_dotstring(c.m_ip)+' hisD:'+inttostr(c.m_clientID[0] xor m_target[0]));
			sendFindID(@c.m_clientid,c.m_ip, c.m_udpport);
			break;
		end;

    if m_stoping then break;
    
	end;
end;


function TDHTSearch.has_contacts_withID(list: TMylist; id:pCU_INT128): Boolean;
var
i: Integer;
c: TContact;
begin

result := False;

 for i := 0 to list.count-1 do begin
  c := list[i];

  if CU_INT128_compare(id,@c.m_clientid) then begin
   Result := True;
   exit;
  end;

 end;

end;

function TDHTsearch.has_contacts_withDistance(list: TMylist; distance:pCU_INT128): Boolean;
var
i: Integer;
c: TContact;
c_distance:CU_INT128;
begin

result := False;

 for i := 0 to list.count-1 do begin
  c := list[i];

  CU_INT128_FillNXor(@c_distance,@c.m_clientID,@m_target);

  if CU_INT128_compare(distance,@c_distance) then begin
   Result := True;
   exit;
  end;

 end;

end;

function TDHTSearch.Find_Replying_Contact(IP: Cardinal; Port:word): TContact;
var
h: Integer;
begin
result := nil;

for h := 0 to m_tried.count-1 do begin
		result := m_tried[h];

		if ((result.m_ip=IP) and
        (result.m_udpport=Port)) then exit;
end;

result := nil;
end;




procedure tDHTsearch.processResponse(fromIP: Cardinal; fromPort: Word; results: TMylist);
var
i: Integer;
c,from,worstcontact: Tcontact;
sendlookup: Boolean;
distance,
fromdistance:CU_INT128;
begin
	m_lastResponse := time_now;

	// Remember the contacts to be deleted when finished
  for i := 0 to results.count-1 do begin
   c := results[i];
   m_delete.add(c);
  end;

	// Not interested in responses for FIND_NODE, will be added to contacts by thread_dht
	if m_type=NODE then begin
		inc(m_answers);
		m_possible.clear;
		results.clear;
		exit;
	end;


    from := Find_Replying_contact(FromIp,FromPort);
    if from=nil then exit;
    CU_INT128_fillNXor(@fromDistance,@from.m_clientid,@m_target);

		// Add to list of people who responded
    m_responded.add(from);


		// Loop through their responses
    for i := 0 to results.count-1 do begin
			c := results[i];

      // Ignore this contact if already know him
      if has_contacts_withid(m_possible,@c.m_clientID) then continue;
      if has_contacts_withid(m_tried,@c.m_clientID) then continue;

      // Add to possible
      m_possible.add(c);

      CU_INT128_FillNXor(@distance,@c.m_clientID,@m_target);
      if ((c.m_clientID[0] xor m_target[0])>(from.m_clientID[0] xor m_target[0])) then continue; // has better hosts then himself?

      // if m_type=KEYWORD then begin
      //  utility_ares.debuglog('DHT got Result search id '+ipint_to_dotstring(from.m_ip)+' hisD:'+inttostr(from.m_clientID[0] xor m_target[0])+' Suggested distance:'+inttostr(c.m_clientID[0] xor m_target[0])+' suggested IP:'+ipint_to_dotstring(c.m_ip));
     //  end;
       
       sendlookup := False;

        if m_best.count<ALPHA_QUERY then begin  //add it without any comparison
         sendlookup := True;
         m_best.add(c);
         sortCloserContacts(m_best,@m_target);


        end else begin      // add him only if he's better then the worst one

             sortCloserContacts(m_best,@m_target);
             worstContact := m_best[m_best.count-1];

             if ((c.m_clientID[0] xor m_target[0]) < (worstContact.m_clientID[0] xor m_target[0])) then begin
              m_best.delete(m_best.count-1);  // delete previous worst result
              m_best.add(c);
               sortCloserContacts(m_best,@m_target);
              sendlookup := True;

             end;

				end;

						if sendlookup then begin  // this is the best we got, get closer to targetid by searching it
							// Add to tried
							m_tried.add(c);
							// Send request
							c.checkingType;
              //if m_type=KEYWORD then utility_ares.debuglog('DHT searching ID on '+ipint_to_dotstring(c.m_ip)+' hisD:'+inttostr(c.m_clientID[0] xor m_target[0]));
							sendFindID(@c.m_clientid, c.m_ip, c.m_UDPPort);
						end;


      end; //for results loop

				if m_type=NODECOMPLETE then begin
					inc(m_answers);
				end;

     
	results.clear;
end;

procedure TDHTsearch.StartIDSearch;
var
distanceFromMe:CU_INT128;
i: Integer;
c: Tcontact;
count,donecount: Integer;
begin

	// Start with a lot of possible contacts, this is a fallback in case search stalls due to dead contacts
	if m_possible.count=0 then begin

		CU_Int128_FillNXor(@distanceFromMe,@DHTme128,@m_target);
		DHT_routingZone.getClosestTo(3, @m_target, @distanceFromMe, 50, m_possible, true, true);
	end;


  if m_possible.count=0 then exit;

	//Lets keep our contact list entries in mind to dec the inUse flag.
  for i := 0 to m_possible.count-1 do begin
   c := m_possible[i];
   m_inuse.add(c);
  end;

	// Take top 3 possible
  if m_type=dhttypes.KEYWORD then count := min(4{ALPHA_QUERY}, m_possible.count)
   else count := min(3{ALPHA_QUERY}, m_possible.count);
   
  donecount := 0;

	while ((m_possible.count>0) and (donecount<count)) do begin
	 c := m_possible[0];
      m_possible.delete(0);
		// Move to tried
		m_tried.add(c);

		// Send request
		c.checkingType;
    //if m_type=KEYWORD then utility_ares.debuglog('DHT searching ID on '+ipint_to_dotstring(c.m_ip)+' hisD:'+inttostr(c.m_clientID[0] xor m_target[0]));
		sendFindID(@c.m_clientid, c.m_ip, c.m_Udpport);

		if m_type=NODE then break;
    inc(donecount);
	end;

end;

procedure tDHTsearch.Expire;
var
baseTime: Cardinal;
begin
	if m_stoping then exit;

	baseTime := 0;

	case m_type of

	   NODE,
		 NODECOMPLETE:baseTime := SEARCHNODE_LIFETIME;

		 KEYWORD:begin
			  baseTime := SEARCHKEYWORD_LIFETIME;
			end;

		STOREFILE:baseTime := SEARCHSTOREFILE_LIFETIME;

		STOREKEYWORD:basetime := SEARCHSTOREKEYWORD_LIFETIME;

		FINDSOURCE:baseTime := SEARCHFINDSOURCE_LIFETIME
     else baseTime :=  SEARCH_LIFETIME;
	end;
	m_created := time_now-baseTime+SEC(15); //extend 15 seconds
	m_stoping := True;
end;

procedure TDHTsearch.sendFindID(check:pCU_INT128; ip: Cardinal; port:word);
begin
		if m_stoping then exit;

    CU_INT128_copyToBuffer(@m_target,@DHT_buffer[2]);
    CU_INT128_CopyToBuffer(check,@DHT_buffer[18]);

		inc(m_PacketSent);

    DHT_len_tosend := 34;
     DHT_buffer[1] := CMD_DHT_REQID;
		DHT_send(ip, port, false);
end;


end.
