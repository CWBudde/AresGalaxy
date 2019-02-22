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
DHT high level routines related to searches
}

unit dht_searchManager;

interface

uses
 classes,classes2,dht_int160,dht_consts,dht_search,sysutils,thread_bittorrent,btcore,utility_ares;

 function findNode(findid:pCU_INT160): Boolean;
 function findNodeComplete: Boolean;
 function alreadySearchingFor(target:pCU_INT160): Boolean;
 procedure processResponse(targetSearch: Tmdhtsearch;  fromIP: Cardinal; fromPort: Word;
  results: TMylist; garbageList: TMylist);
 procedure CheckSearches(nowt: Cardinal); //every second
 function num_searches(ttype:dht_consts.tmdhtsearchtype): Integer;
 procedure ClearContacts(list: TMylist);
 function mdht_get_peers(transfer: TbittorrentTransfer): Boolean;


implementation

uses
 helper_datetime,helper_ipfunc,securehash,
 windows,helper_strings,dht_Socket,mysupernodes;



function num_searches(ttype:dht_consts.tmdhtsearchtype): Integer;
var
i: Integer;
s: TmDHTSearch;
begin
 Result := 0;

 for i := 0 to MDHT_Searches.count-1 do begin
  s := MDHT_Searches[i];
  if s.m_type=ttype then inc(result);
 end;

end;


procedure ClearContacts(list: TMylist);
var
c: Tmdhtbucket;
begin
while (list.count>0) do begin
 c := list[list.count-1];
    list.delete(list.count-1);
 c.Free;
end;
end;

procedure processResponse(targetSearch: Tmdhtsearch; fromIP: Cardinal; fromPort: Word;
 results: TMylist; garbageList: TMylist);
var
s: TmDHTsearch;
i: Integer;
found: Boolean;
begin
 found := False;
 s := nil;
 
 for i := 0 to MDHT_searches.count-1 do begin
  s := MDHT_searches[i];
  if s=targetSearch then begin
   found := True;
   break;
  end;
 end;

	if not found then begin
   ClearContacts(GarbageList);
   exit;
  end;

		s.processResponse(fromIP, fromPort, results);
end;



function alreadySearchingFor(target:pCU_INT160): Boolean;
var
i: Integer;
s: TmDHTsearch;
begin
result := False;

 for i := 0 to MDHT_Searches.count-1 do begin
    s := MDHT_Searches[i];
    if CU_INT160_Compare(@s.m_target, target) then begin
     Result := True;
     exit;
    end;
 end;

end;

function findNodeComplete: Boolean;
var
s: TmDHTsearch;
wantedid:cu_int160;
begin
result := False;

  CU_INT160_copyFromBufferRev(@DHTme160,@wantedid);
	if alreadySearchingFor(@wantedid) then exit;


	s := TmDHTsearch.create;
		s.m_type := dht_consts.NODECOMPLETE;
		CU_INT160_fill(@s.m_target,@wantedid);
		MDHT_Searches.add(s);
	 Result := s.startIDSearch;
end;

function findNode(findid:pCU_INT160): Boolean;
var
s: TmDHTsearch;
wantedid:cu_int160;
begin
result := False;

 CU_INT160_copyFromBufferRev(@findid,@wantedid);
 if alreadySearchingFor(@wantedid) then begin
  exit;
 end;

	s := TmDHTsearch.create;
		s.m_type := dht_consts.NODE;
		CU_INT160_fill(@s.m_target,@wantedid);
		MDHT_Searches.add(s);
	result := s.StartIDSearch;
end;

function mdht_get_peers(transfer: TbittorrentTransfer): Boolean;
var
 id:CU_INT160;
 s: TmDHTsearch;
begin
result := False;

CU_INT160_copyFromBufferRev(@transfer.fhashvalue[1],@id);

 if alreadySearchingFor(@id) then begin
  exit;
 end;

 	 s := TmDHTsearch.create;
		s.m_type := dht_consts.FINDSOURCE;
		CU_INT160_fill(@s.m_target,@id);
		MDHT_Searches.add(s);
    Utility_ares.debuglog('DHT finding peers for '+bytestr_to_hexstr(transfer.fhashvalue));
	 if s.StartIDSearch then begin
    transfer.m_lastudpsearch := mdht_nowt;
    Result := True;
   end;
end;


procedure CheckSearches(nowt: Cardinal); //every second
var
i: Integer;
s: TmDHTSearch;
begin

i := 0;
 while (i<MDHT_Searches.count) do begin
   s := MDHT_Searches[i];

   case s.m_type of

			dht_consts.FINDSOURCE:begin
					if s.m_created+MDHT_SEARCHFINDSOURCE_LIFETIME<thread_bittorrent.mdht_nowt then begin

            MDHT_Searches.delete(i);
            s.Free;
            continue;
					end;

					if (s.m_answers>=MDHT_SEARCHFINDSOURCE_TOTAL) or
             (s.m_created+MDHT_SEARCHFINDSOURCE_LIFETIME-SEC(5)<thread_bittorrent.mdht_nowt) then begin
            
             s.expire;
             inc(i);
             continue;
          end;

			    s.CheckExpire;
			end;

			dht_consts.NODE:begin
				if s.m_created+MDHT_SEARCHNODE_LIFETIME<thread_bittorrent.mdht_nowt then begin
            MDHT_Searches.delete(i);
            s.Free;
            continue;
				end;
        s.CheckExpire;
			end;

			dht_consts.NODECOMPLETE:begin
				if s.m_created+MDHT_SEARCHNODE_LIFETIME<thread_bittorrent.mdht_nowt then begin
            MDHT_Searches.delete(i);
            s.Free;
            continue;
				end;

				if ((s.m_created+MDHT_SEARCHNODECOMP_LIFETIME<thread_bittorrent.mdht_nowt) and
            (s.m_answers>=MDHT_SEARCHNODECOMP_TOTAL)) then begin
            
            MDHT_Searches.delete(i);
            s.Free;
            continue;
					end;
        s.CheckExpire;

			end
      else begin
					if s.m_created+MDHT_SEARCH_LIFETIME<thread_bittorrent.mdht_nowt then begin
					  MDHT_Searches.delete(i);
            s.Free;
            continue;
					end;

					s.CheckExpire;
        end;
    end;

  inc(i);
 end;

end;


end.