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
sorting callbacks
}


unit helper_sorting;

interface

uses
ares_types,sysutils,thread_download,classes,classes2,ares_objects;

function ordina_risorse_queued_prima_migliore(item1,item2: Pointer): Integer;
function ordina_per_size(item1,item2: Pointer): Integer;
function CompFunc_strings(item1,item2: Pointer): Integer;
function ordina_cartelle_parent_prima(item1,item2: Pointer): Integer;
function ordina_xqueued(item1,item2: Pointer): Integer;
function ordina_risorsa_per_succesfull_factor(item1,item2: Pointer): Integer;
function ordina_risorse_peggiore_prima(item1,item2: Pointer): Integer;
function ordina_risorse_per_have_tried(item1,item2: Pointer): Integer;
function ordina_risorse_slower_prima(item1,item2: Pointer): Integer;
function ordina_queued_per_num_uploads(item1,item2: Pointer): Integer;
procedure shuffle_list(list: Tlist);
procedure shuffle_mylist(list: TMylist; startindex: Cardinal);
procedure shuffle_myStringList(list: TMyStringList);
procedure shuffle_StringList(list: TStringList);
function sort_cache_str_tires(List: TStringList; Index1, Index2: Integer): Integer;    // ordiniamo in modo crescente in base a start point...
function sort_aresnodes_bestrating(item1,item2: Pointer): Integer;  //most rated first
function sort_aresnodes_worstrating(item1,item2: Pointer): Integer;  //worst rated first
function sort_HardFailed_Comp(item1,item2: Pointer): Integer;
function sort_worstSupernodeFirst(item1,item2: Pointer): Integer;  //worst rated first
function sort_bestSupernodeFirst(item1,item2: Pointer): Integer;  //worst rated first
function ordina_users_per_shared(item1,item2: Pointer): Integer;

//bittorrent
function worstUploaderFirst(item1,item2: Pointer): Integer;
function worstDownloaderFirst(item1,item2: Pointer): Integer;
function sortLeastPopularFirst(item1,item2: Pointer): Integer; //least popular first
function SortSourcesOlderFirst(item1,item2: Pointer): Integer;
function BitTorrentSortWorstForaSeederInactiveSourceFirst(item1,item2: Pointer): Integer;
function BitTorrentSortWorstForaLeecherInactiveSourceFirst(item1,item2: Pointer): Integer;
function sortBitTorrentBestDownBytesFirst(item1,item2: Pointer): Integer;
function sortBitTorrentBestDownRateFirst(item1,item2: Pointer): Integer;
function sortBitTorrentBestUpRateFirst(item1,item2: Pointer): Integer;
function sortBitTorrentBestUpBytesFirst(item1,item2: Pointer): Integer;
//function sortBitTorrentudptrackerfirst(item1,item2: Pointer): Integer;
//function sortBitTorrenthttptrackerfirst(item1,item2: Pointer): Integer;
function sort_lastudpsearchlast(item1,item2: Pointer): Integer;

function sortMostPrioritaryFirst(item1,item2: Pointer): Integer; //most prioritary first

//supernodes
function sortSupLeastUsersFirst(item1,item2: Pointer): Integer; //less users first

implementation

uses
types_supernode,helper_strings,helper_ares_nodes,btcore;

//****************** supernodes *********************
function sortSupLeastUsersFirst(item1,item2: Pointer): Integer; //less users first
var
sup1,sup2: Tsupernode;
begin
 sup1 := item1;
 sup2 := item2;

 Result := integer(sup1.users) - integer(sup2.users);
end;
//***************** bittorrent **********************


{function sortBitTorrentudptrackerfirst(item1,item2: Pointer): Integer;
var
track1,track2: TbittorrentTracker;
begin
 Result := integer(track2.isudp) - integer(track1.isudp);
end;

function sortBitTorrenthttptrackerfirst(item1,item2: Pointer): Integer;
var
track1,track2: TbittorrentTracker;
begin
 Result := integer(track1.isudp) - integer(track2.isudp);
end; }

function sortMostPrioritaryFirst(item1,item2: Pointer): Integer; //most prioritary first
var
piece1,piece2: TBitTorrentChunk;
begin
 piece1 := item1;
 piece2 := item2;

 Result := integer(piece2.priority) - integer(piece1.priority);
end;

function sortLeastPopularFirst(item1,item2: Pointer): Integer; //least popular first
var
piece1,piece2: TBitTorrentChunk;
begin
 piece1 := item1;
 piece2 := item2;

 Result := integer(piece1.popularity) - integer(piece2.popularity);
end;

function sort_lastudpsearchlast(item1,item2: Pointer): Integer; //earliest searched first
var
 tran1,tran2: TBittorrentTransfer;
begin
 tran1 := item1;
 tran2 := item2;

 Result := integer(tran1.m_lastudpsearch)-integer(tran2.m_lastudpsearch);
end;


function sortBitTorrentBestDownRateFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source2.speed_recv) - integer(source1.speed_recv);
end;

function sortBitTorrentBestUpRateFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source2.speed_send) - integer(source1.speed_send);
end;

function sortBitTorrentBestDownBytesFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source2.recv) - integer(source1.recv);
end;

function sortBitTorrentBestUpBytesFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source2.sent) - integer(source1.sent);
end;



function worstDownloaderFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source1.sent) - integer(source2.sent);
end;

function worstUploaderFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source1.recv) - integer(source2.recv);
end;

function SortSourcesOlderFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source1.lastDataIn) - integer(source2.lastDataIn);
end;

function BitTorrentSortWorstForaSeederInactiveSourceFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source1.lastDataOut) - integer(source2.lastDataOut);
end;

function BitTorrentSortWorstForaLeecherInactiveSourceFirst(item1,item2: Pointer): Integer;
var
source1,source2: TBitTorrentSource;
begin
 source1 := item1;
 source2 := item2;

 Result := integer(source1.lastDataIn) - integer(source2.lastDataIn);
end;
//*****************************************************




procedure shuffle_list(list: Tlist);
var
i: Integer;
begin
try
 if list.count<2 then exit;
 for i := 0 to list.count-1 do list.Move(i,random(list.count));
except
end;
end;

procedure shuffle_myStringList(list: TMyStringList);
var
i: Integer;
begin
try

if list.count<2 then exit;

for i := 0 to list.count-1 do list.Move(i,random(list.count));

except
end;
end;

procedure shuffle_StringList(list: TStringList);
var
i: Integer;
begin
try

if list.count<2 then exit;

for i := 0 to list.count-1 do list.Move(i,random(list.count));

except
end;
end;

procedure shuffle_mylist(list: TMylist; startindex: Cardinal);
var
i: Integer;
amount: Integer;
begin
try

if list.count<2 then exit;
if startindex>=cardinal(list.count)-1 then exit;

amount := (cardinal(list.count)-1)-startindex;
for i := startindex to list.count-1 do list.Move(i,startindex+cardinal(random(amount+1)));

except
end;
end;

function CompFunc_strings(item1,item2: Pointer): Integer;
var
item1p,item2p:precord_string;
begin
item1p := pointer(item1);
item2p := pointer(item2);

result := comparetext(item1p.str,item2p.str);
end;

function ordina_users_per_shared(item1,item2: Pointer): Integer;
var
us1,us2: Tlocaluser;
begin
us1 := item1;
us2 := item2;
result := us1.shared_count-us2.shared_count;   //leecher first
end;

function ordina_cartelle_parent_prima(item1,item2: Pointer): Integer;
var
item1p,item2p:precord_cartella_share;
begin
item1p := precord_cartella_share(item1);
item2p := precord_cartella_share(item2);

result := length(item1p^.path)-length(item2p^.path);    //il maggiore davanti  (shortest length)
end;

function sort_cache_str_tires(List: TStringList; Index1, Index2: Integer): Integer;    // ordiniamo in modo crescente in base a start point...
var
cache1,cache2: string;
begin
cache1 := list.strings[index1];
cache2 := list.strings[index2];

result := chars_2_word(copy(cache1,5,2)) - chars_2_word(copy(cache2,5,2)); // use2p.accepted_connections-use1p.accepted_connections;
end;

function ordina_risorse_per_have_tried(item1,item2: Pointer): Integer;
var
ris1,ris2: Trisorsa_download;
begin
 ris1 := item1;
 ris2 := item2;                           //quella con numero minore di tentativi prima

 Result := integer(ris1.have_tried) - integer(ris2.have_tried);
end;

function ordina_risorsa_per_succesfull_factor(item1,item2: Pointer): Integer;
var
ris1,ris2: Trisorsa_download;
begin
 ris1 := item1;                              //quella con fattore migliore prima
 ris2 := item2;

 Result := ris2.succesfull_factor - ris1.succesfull_factor;
end;

function ordina_risorse_queued_prima_migliore(item1,item2: Pointer): Integer;
var
ris1,ris2: Trisorsa_download;
begin
ris1 := item1;
ris2 := item2;

result := ris1.queued_position - ris2.queued_position; //minore in coda prima
end;

function ordina_risorse_peggiore_prima(item1,item2: Pointer): Integer;
var
ris1,ris2: Trisorsa_download;
begin
ris1 := item1;
ris2 := item2;

result := ris2.num_fail - ris1.num_fail;
end;

function ordina_xqueued(item1,item2: Pointer): Integer; //prima posizione inferiore
var
item1p,item2p:precord_queued;
begin
item1p := precord_queued(item1);
item2p := precord_queued(item2);

result := item1p^.posizione-item2p^.posizione;
end;


function ordina_risorse_slower_prima(item1,item2: Pointer): Integer;
var
ris1,ris2: Trisorsa_download;
begin
 ris1 := item1;                              //quella con fattore migliore prima
 ris2 := item2;
 Result := ris1.speed - ris2.speed;
end;

function ordina_per_size(item1,item2: Pointer): Integer;
var
item1p,item2p:precord_file_library;
begin
item1p := precord_file_library(item1);
item2p := precord_file_library(item2);

result := item2p^.fsize-item1p^.fsize;    //bigger ahead
end;

function sort_HardFailed_Comp(item1,item2: Pointer): Integer;
var
item1p,item2p:precord_ipc;
str1,str2: string;
ip1,ip2: Cardinal;
begin
item1p := precord_ipc(item1);
item2p := precord_ipc(item2);

   SetLength(str1,4);
   SetLength(str2,4);
  move(item1p^.ip,str1[1],4);
  move(item2p^.ip,str2[1],4);
   str1 := reverse_order(str1);
   str2 := reverse_order(str2);
  move(str1[1],ip1,4);
  move(str2[1],ip2,4);

result := ip1-ip2;    //bigger ahead
end;


function sort_aresnodes_bestrating(item1,item2: Pointer): Integer;  //best rated first
var
node1,node2: Tares_node;
begin
node1 := item1;
node2 := item2;
result := round(node2.rate)-round(node1.rate);
end;

function sort_aresnodes_worstrating(item1,item2: Pointer): Integer;  //worst rated first
var
node1,node2: Tares_node;
begin
node1 := item1;
node2 := item2;
result := round(node1.rate-node2.rate);
end;

function sort_worstSupernodeFirst(item1,item2: Pointer): Integer;  //worst rated first
var
sup1,sup2:precord_availableSupernode;
begin
sup1 := precord_availableSupernode(item1);
sup2 := precord_availableSupernode(item2);

result := (integer(sup1.connects*5) - (integer(sup1.attempts))) -
        (integer(sup2.connects*5) - (integer(sup2.attempts)));
end;

function sort_BestSupernodeFirst(item1,item2: Pointer): Integer;  //best rated first
var
sup1,sup2:precord_availableSupernode;
begin
sup1 := precord_availableSupernode(item1);
sup2 := precord_availableSupernode(item2);

result := (integer(sup2.connects*5) - (integer(sup2.attempts))) -
        (integer(sup1.connects*5) - (integer(sup1.attempts)));
end;

function ordina_queued_per_num_uploads(item1,item2: Pointer): Integer;
var
item1p,item2p:precord_queued;
downc1,downc2,end_boost1,end_boost2: Integer;
begin
item1p := precord_queued(item1);
item2p := precord_queued(item2);


 downc1 := item1p^.his_downcount;  
if downc1<0 then downc1 := 4;
 downc2 := item2p^.his_downcount;
if downc2<0 then downc2 := 4;

 if item1p^.his_progress>90 then end_boost1 := 10-(100-item1p^.his_progress) else end_boost1 := 0;
 if item2p^.his_progress>90 then end_boost2 := 10-(100-item2p^.his_progress) else end_boost2 := 0;

 Result := ( (item2p^.his_upcount*2) - downc2) - ( (item1p^.his_upcount*2) - downc1);    //bigger ahead
end;

end.
