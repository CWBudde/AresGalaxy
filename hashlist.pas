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


unit hashlist;

interface

uses
 classes,windows,sysutils,const_ares,types_supernode;

type
tbkts=array of pointer;

const
DB_HASH_ITEMS=4001;
DB_KEYWORD_ITEMS=4001;


DB_RESULTIDS_ITEMS=HASH_SUPERNODE_ALLOWED_USERS+50;

type
Thashlist = class(Tobject)
 public
  bkt: array of pointer; //[0..DB_HASH_ITEMS-1] of pointer;
  constructor create(numitems:word);
end;

procedure KWList_DeletehashShare(hash: PHash; item: PHashItem);
function HashList_AddHashKey(crc:word): PHash; //ultimo entrato diventa primo
function HashList_FindHashkey(crc:word): PHash;
procedure HashList_FreeHashList(first: PHash);
procedure KWList_FreeList(first: PKeyword);
function KWList_Findkey(const keyword: pchar; lenkey: Byte; crc:word): PKeyword;
procedure KWList_DeleteShare(keyword: PKeyword; item: PKeywordItem; share: Precord_file_shared);
procedure DeleteKeywordsItem(pfile: PRecord_file_shared);
function KWList_AddSharehash(hash: PHash; share: precord_file_shared): PHashItem;
procedure InitSupernodeHashLists;


var
db_hash: Thashlist;
db_keywords: Thashlist;


db_result_ids: Thashlist; //id massimo è 999
hash_generale_sha1: array [0..19] of Byte; //per non allocare in ogni add share

implementation

constructor THashlist.create(numitems:word);
var
i: Integer;
begin
 SetLength(bkt,numitems);
    for i := 0 to high(bkt) do bkt[i] := nil;
end;

procedure InitSupernodeHashLists;
begin
   db_hash := Thashlist.create(DB_HASH_ITEMS);
   db_keywords := ThashList.create(DB_KEYWORD_ITEMS);
   db_result_ids := ThashList.create(DB_RESULTIDS_ITEMS);
end;


function KWList_AddSharehash(hash: PHash; share: precord_file_shared): PHashItem;
var
 hashitem,lastitem:phashitem;
begin
    inc(hash^.count);


    lastitem := nil;
    hashitem := hash^.firstitem;


      Result := AllocMem(sizeof(THashItem));
      result^.prev := nil;

      if hash^.firstitem<>nil then begin
       hash^.firstitem.prev := result;
       result^.next := hash^.firstitem
      end else result^.next := nil;

      hash^.firstitem := result; //ora siamo noi i primi!

      result^.share := share;  //puntatore a nostro share...

end;

procedure DeleteKeywordsItem(pfile: PRecord_file_shared);
// deletes all keyword items from database
var
 i: Integer;
begin

 for i := 0 to pfile^.numkeywords-1 do KWList_DeleteShare(pfile^.keywords[i*3],pfile^.keywords[i*3+1],pfile);

 FreeMem(pfile^.keywords, pfile^.numkeywords * 3 * SizeOf(Pointer));
end;

procedure KWList_DeleteShare(keyword: PKeyword; item: PKeywordItem; share: Precord_file_shared);

 procedure KWList_Deletekey(keyword: PKeyword);
 begin
  if db_keywords.bkt[keyword^.crc mod DB_KEYWORD_ITEMS]=nil then exit;

  if keyword^.prev=nil then db_keywords.bkt[keyword^.crc mod DB_KEYWORD_ITEMS] := keyword^.next  //mettiamo la prossima come prima della lista
  else keyword^.prev^.next := keyword^.next; //assegniamo alla mia precedente la mia prossima
  if keyword^.next<>nil then keyword^.next^.prev := keyword^.prev; //se la prossima esiste, assegniamogli la nostra precedente

  SetLength(keyword^.keyword,0);

  FreeMem(keyword,sizeof(TKeyword));
 end;

begin
 if item=nil then exit;
 
 if item^.prev=nil then keyword^.firstitem := item^.next  //mettiamo la prossima come prima della lista
 else item^.prev^.next := item^.next; //assegniamo alla mia precedente la mia prossima
 if item^.next<>nil then item^.next^.prev := item^.prev; //se la prossima esiste, assegniamogli la nostra precedente


   FreeMem(item,sizeof(TKeywordItem));
   dec(keyword^.count);

   if keyword^.firstitem=nil then KWList_Deletekey(keyword);

end;

function KWList_Findkey(const keyword: pchar; lenkey: Byte; crc:word): PKeyword;
begin

 if db_keywords.bkt[crc mod DB_KEYWORD_ITEMS]=nil then begin
  Result := nil;
  exit;
 end;

    Result := db_keywords.bkt[crc mod DB_KEYWORD_ITEMS];
    while (result<>nil) do begin
     if result^.crc=crc then
      if length(result^.keyword)=lenkey then
       if comparemem(@result^.keyword[0],keyword,lenkey) then exit;
     Result := result^.next;
    end;
end;

procedure KWList_FreeList(first: PKeyword);
var
 item, next: PKeyword;
 item2, next2: PKeywordItem;
begin
if first=nil then exit;

   item := first;
 while item<>nil do begin
   next := item^.next;

   item2 := item^.firstitem;
   while item2<>nil do begin
     next2 := item2^.next;
     FreeMem(item2,sizeof(TKeywordItem));
     item2 := next2;
   end;

   SetLength(item^.keyword,0);
   FreeMem(item,sizeof(TKeyword));
   item := next;
 end;

end;
//HASH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

procedure HashList_FreeHashList(first: PHash);
var
 item, next: PHash;
 hashItem,nextItem:PHashItem;
begin
if first=nil then exit;

   item := first;
 while item<>nil do begin
   next := item^.next;

    hashItem := item^.firstitem;
    while (hashItem<>nil) do begin
     nextItem := hashItem^.next;
      FreeMem(hashItem,sizeof(THashItem));
     HashItem := NextItem;
    end;

    FreeMem(item,sizeof(THash));
   item := next;
 end;
end;

function HashList_FindHashkey(crc:word): PHash;
var
num: Word;
begin


  move(hash_generale_sha1[0],num,2);

  if db_hash.bkt[(num mod DB_HASH_ITEMS)]=nil then begin
   Result := nil;
   exit;
  end;


   Result := db_hash.bkt[(num mod DB_HASH_ITEMS)];
   while (result<>nil) do begin
     if result^.crc=crc then
       if comparemem(@result^.hash[0],@hash_generale_sha1[0],20) then exit;
     Result := result^.next;
   end;
end;

function HashList_AddHashKey(crc:word): PHash; //ultimo entrato diventa primo
var
first:phash;
num: Word;
begin
result := AllocMem(sizeof(THash));
 result^.crc := crc; //crc per hash...
 result^.firstitem := nil;
 result^.count := 0;
 
   move(hash_generale_sha1[0],result^.hash[0],20);

   move(hash_generale_sha1[0],num,2);

   first := db_hash.bkt[num mod DB_HASH_ITEMS];
    result^.next := first;  //agganciamo precedente nella lista
    if first<>nil then first^.prev := result; //se c'era diciamogli che siamo noi i primi ora
    result^.prev := nil;  //non abbiamo nessuno davanti
   db_hash.bkt[num mod DB_HASH_ITEMS] := result;  // e siamo i primi per la lista
end;


procedure KWList_DeletehashShare(hash: PHash; item: PHashItem);

 procedure HashList_DeleteHashkey(hash: PHash);
 var
 num: Word;
 begin
  move(hash^.hash[0],num,2);
  if db_hash.bkt[num mod DB_HASH_ITEMS]=nil then exit;

  if hash^.prev=nil then db_hash.bkt[num mod DB_HASH_ITEMS] := hash^.next
  else hash^.prev^.next := hash^.next;
  if hash^.next<>nil then hash^.next^.prev := hash^.prev;

  FreeMem(hash,sizeof(THash));
 end;

begin
 if item^.prev=nil then hash^.firstitem := item^.next  //mettiamo la prossima come prima della lista
 else item^.prev^.next := item^.next; //assegniamo alla mia precedente la mia prossima
 if item^.next<>nil then item^.next^.prev := item^.prev; //se la prossima esiste, assegniamogli la nostra precedente

 FreeMem(item,sizeof(THashitem)); //eliminiamo hashitem

 if hash^.count>0 then dec(hash^.count);

              //vuoto!
 if hash^.firstitem=nil then HAshList_DeleteHashKey(hash); //se era unico aliminiamo anche hashkey
end;


end.
