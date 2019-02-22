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
DHT hashlists used by dhtthread to store published files
}

unit DhtHashList;

interface

uses
  DhtTypes, HashList, Classes, SysUtils, Types_SuperNode, Helper_Datetime;

const
  DB_DHTHASH_ITEMS     = 1031;
  DB_DHTKEYFILES_ITEMS = 1031;
  DB_DHT_KEYWORD_ITEMS = 1031;
  DB_DHTHASHPARTIALSOURCES_ITEMS = 1031;
  DHT_EXPIRE_FILETIME  = 21600; // 6 hours (seconds)
  DHT_EXPIRE_PARTIALSOURCES = 3600; // 1 hour

  procedure DHT_CheckExpireHashFileList(HsLst: THashList; TimeInterval: Cardinal);
  procedure DHT_FreeHashFileList(FirstHash:PRecord_dht_hash; HsLst: THashList);
  procedure DHT_FreeHashFile(Hash:PRecord_dht_hash; hlst: THashList);
  function DHT_findhashFileSource(Hash:PRecord_dht_hash; ip: Cardinal):PRecord_dht_source;
  function DHT_FindHashFile(HsLst: THashList):PRecord_dht_hash;
  procedure DHT_CheckExpireHashFile(Hash:PRecord_dht_hash; Nowt: Cardinal; TimeInterval: Cardinal; hlst: THashList);
  procedure DHT_FreeSource(Source:PRecord_dht_source; Hash:PRecord_dht_hash);
  procedure DHT_FreeLastSource(Hash:PRecord_dht_hash);

  function DHT_FindKeywordFile:PRecord_dht_storedfile;
  procedure DHT_FreeKeyWordFile(PFile:PRecord_dht_storedfile);
  procedure DHT_FreeKeywordFileList(FirstKeyWordFile:PRecord_dht_storedfile);
  procedure DHT_FreeFile_Keyword(Keyword: PDHTKeyword; Item: PDHTKeywordItem; Share:PRecord_dht_storedfile);
  procedure DHT_CheckExpireKeywordFileList;

  function DHT_KWList_Findkey(Keyword:PChar; Lenkey: Byte; crc:Word): PDHTKeyword;
  function DHT_KWList_Addkey(Keyword:PChar; Lenkey: Byte; crc:Word): PDHTKeyword;
  function DHT_KWList_AddShare(Keyword:PDHTKeyword; Share:PRecord_dht_storedfile): PDHTKeywordItem;

var
  db_DHT_hashFile: THashList;
  db_DHT_hashPartialSources: THashList;
  db_DHT_keywordFile: THashList;
  db_DHT_keywords: THashList;
  DHT_SharedFilesCount: Integer;
  DHT_SharedHashCount: Integer;
  DHT_SharedPartialSourcesCount: Integer;

implementation

uses
  thread_dht, windows;


/////////////////////////////////////////// Hash file sources /////////////////////////
procedure DHT_CheckExpireHashFileList(HsLst: THashList; TimeInterval: Cardinal);
var
  i: Integer;
  FirstHash,NextHash:PRecord_dht_hash;
  Nowt: Cardinal;
begin
  Nowt := Time_now;

  for i := 0 to high(HsLst.bkt) do
  begin
    if HsLst.bkt[i]=nil then continue;

    FirstHash := HsLst.bkt[i];
    while (FirstHash<>nil) do
    begin
      NextHash := FirstHash^.Next;
      DHT_CheckExpireHashFile(FirstHash, Nowt, TimeInterval, HsLst);
      FirstHash := NextHash;
    end;
  end;
end;

procedure DHT_CheckExpireHashFile(Hash:PRecord_dht_hash; Nowt: Cardinal; TimeInterval: Cardinal; hlst: THashList);
var
  Source, NextSource: PRecord_dht_source;
begin
  if Nowt-Hash^.lastSeen>TimeInterval then
  begin
    DHT_FreeHashFile(Hash,hlst);
    Exit;
  end;

  Source := Hash^.FirstSource;
  while (Source<>nil) do
  begin
    NextSource := Source^.Next;
    if Nowt-source^.lastSeen>TimeInterval then
      DHT_FreeSource(Source,Hash);
    Source := NextSource;
  end;

  if Hash^.FirstSource=nil then DHT_FreeHashFile(Hash,hlst);
  //Hash^.Count=0
end;

procedure DHT_FreeLastSource(Hash:PRecord_dht_hash);
var
  Source: PRecord_dht_source;
begin
  Source := Hash^.FirstSource;
  while (Source<>nil) do
  begin
    if Source^.Next=nil then
    begin
      DHT_FreeSource(Source,Hash);
      break;
    end;
    Source := Source^.Next;
  end;
end;

procedure DHT_FreeSource(Source:PRecord_dht_source; Hash:PRecord_dht_hash);
begin
  Source^.raw := '';

  if Source^.Prev=nil then
    Hash^.FirstSource := Source^.Next
  else
    Source^.Prev^.Next := Source^.Next;
  if Source^.Next <> nil then
    Source^.Next^.Prev := Source^.Prev;

  FreeMem(Source,SizeOf(record_dht_source));
  dec(Hash^.Count);
end;

procedure DHT_FreeHashFile(Hash:PRecord_dht_hash; hlst: THashList);
var
  Source,NextSource: PRecord_dht_source;
begin
  Source := Hash^.FirstSource;
  while (Source<>nil) do
  begin
    NextSource := Source^.Next;
    DHT_FreeSource(Source,Hash);
    Source := NextSource;
  end;

  if Hash^.Prev=nil then
    hlst.bkt[Hash^.crc mod DB_DHTHASH_ITEMS] := Hash^.Next
  else
    Hash^.Prev^.Next := Hash^.Next;
  if Hash^.Next<>nil then
    Hash^.Next^.Prev := Hash^.Prev;

  FreeMem(Hash,SizeOf(recorD_dht_hash));

  if hlst=db_DHT_hashFile then
  begin
    if DHT_SharedHashCount>0 then
      dec(DHT_SharedHashCount);
  end
  else
  if DHT_SharedPartialSourcesCount > 0 then
    dec(DHT_SharedPartialSourcesCount);
end;

procedure DHT_FreeHashFileList(FirstHash:PRecord_dht_hash; HsLst: THashList);
var
  NextHash: PRecord_dht_hash;
begin
  if FirstHash=nil then Exit;

  while (FirstHash<>nil) do
  begin
    NextHash := FirstHash^.Next;
    DHT_FreeHashFile(FirstHash,HsLst);
    FirstHash := NextHash;
  end;
end;

function DHT_FindHashFile(HsLst: THashList):PRecord_dht_hash;
begin

  if HsLst.bkt[DHT_crcsha1_global mod DB_DHTHASH_ITEMS]=nil then
  begin
    Result := nil;
    Exit;
  end;

  Result := HsLst.bkt[(DHT_crcsha1_global mod DB_DHTHASH_ITEMS)];
  while (Result<>nil) do
  begin
    if Result^.crc=DHT_crcsha1_global then
      if CompareMem(@Result^.hashValue[0],@DHT_hash_sha1_global[0],20) then Exit;
    Result := Result^.Next;
  end;
end;

function DHT_findhashFileSource(Hash:PRecord_dht_hash; ip: Cardinal):PRecord_dht_source;
begin
  Result := Hash^.FirstSource;
  while (Result<>nil) do
  begin
    if Result^.ip=ip then Exit;
    Result := Result^.Next;
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// Keyword file db //////////////////////////////////////////
function DHT_FindKeywordFile:PRecord_dht_storedfile;
begin
  if db_DHT_keywordFile.bkt[(DHT_crcsha1_global mod DB_DHTKEYFILES_ITEMS)]=nil then
  begin
    Result := nil;
    Exit;
  end;

  Result := db_DHT_keywordFile.bkt[(DHT_crcsha1_global mod DB_DHTKEYFILES_ITEMS)];
  while (Result<>nil) do
  begin
    if Result^.crc=DHT_crcsha1_global then
      if CompareMem(@Result^.hashValue[0],@DHT_hash_sha1_global[0],20) then
        Exit;
    Result := Result^.Next;
  end;
end;


procedure DHT_FreeKeywordFileList(FirstKeyWordFile:PRecord_dht_storedfile);
var
  NextKeywordFile: PRecord_dht_storedfile;
begin
  if FirstKeyWordFile=nil then
    Exit;

  while (FirstKeyWordFile<>nil) do
  begin
    NextKeywordFile := FirstKeyWordFile^.Next;

    DHT_FreeKeyWordFile(FirstKeyWordFile);

    FirstKeyWordFile := NextKeywordFile;
  end;

end;

procedure DHT_FreeFile_Keyword(Keyword: PDHTKeyword; Item: PDHTKeywordItem; Share:PRecord_dht_storedfile);

  procedure DHT_FreeKeyWord(Keyword: PDHTKeyword);
  begin
    if db_DHT_keywords.bkt[Keyword^.crc mod DB_DHT_KEYWORD_ITEMS]=nil then Exit;

    if Keyword^.Prev=nil then
      db_DHT_keywords.bkt[Keyword^.crc mod DB_DHT_KEYWORD_ITEMS] := Keyword^.Next
    else
      Keyword^.Prev^.Next := Keyword^.Next;
    if Keyword^.Next<>nil then
      Keyword^.Next^.Prev := Keyword^.Prev;

    SetLength(Keyword^.Keyword,0);
    FreeMem(Keyword,SizeOf(TDHTKeyword));
  end;

begin
 if Item=nil then
   Exit; // already cleared Keyword for this Item, this happens with files having duplicated keywords

  if Item^.Prev=nil then
    Keyword^.FirstItem := Item^.Next
  else
    Item^.Prev^.Next := Item^.Next;

  if Item^.Next<>nil then
    Item^.Next^.Prev := Item^.Prev;

  FreeMem(Item,SizeOf(TDHTKeywordItem));
  dec(Keyword^.Count);

  if Keyword^.FirstItem=nil then
    DHT_FreeKeyWord(Keyword);
end;


procedure DHT_FreeKeyWordFile(PFile:PRecord_dht_storedfile);
var
  i: Integer;
begin
  PFile^.info := '';

  // remove file Keyword items, and whole Keyword if needed
  for i := 0 to PFile^.numkeywords-1 do DHT_FreeFile_Keyword(PFile^.keywords[i*3],PFile^.keywords[(i*3)+1],PFile);
  FreeMem(PFile^.keywords, PFile^.numkeywords * 3 * SizeOf(Pointer));

  // detach file from list
  if PFile^.Prev=nil then
    db_DHT_keywordFile.bkt[(PFile^.crc mod DB_DHTKEYFILES_ITEMS)] := PFile^.Next
  else
    PFile^.Prev^.Next := PFile^.Next;
  if PFile^.Next<>nil then
    PFile^.Next^.Prev := PFile^.Prev;

  FreeMem(PFile,SizeOf(record_dht_storedfile));

  if DHT_SharedFilesCount > 0 then
    dec(DHT_SharedFilesCount);
end;


procedure DHT_CheckExpireKeywordFileList; // once every 60 minutes
var
  i: Integer;
  FirstKeyWordFile,NextKeywordFile:PRecord_dht_storedfile;
  Nowt: Cardinal;
begin
  Nowt := Time_now;

  for i := 0 to high(db_DHT_keywordFile.bkt) do
  begin
    if db_DHT_keywordFile.bkt[i]=nil then
      continue;

    FirstKeyWordFile := db_DHT_keywordFile.bkt[i];
    while (FirstKeyWordFile<>nil) do
    begin
      NextKeywordFile := FirstKeyWordFile^.Next;

      if Nowt-FirstKeyWordFile^.lastSeen>DHT_EXPIRE_FILETIME then
        DHT_FreeKeyWordFile(FirstKeyWordFile)
      else
      begin
        if FirstKeyWordFile^.Count>30 then FirstKeyWordFile^.Count := 30;
      end;

      FirstKeyWordFile := NextKeywordFile;
    end;
  end;
end;

/////////////////////////////////////////////////////////////////////////////



////////////////////////// KEYWORDS /////////////////////////////////////////

function DHT_KWList_Findkey(Keyword:PChar; Lenkey: Byte; crc:Word): PDHTKeyword;
begin
  if db_DHT_keywords.bkt[(crc mod DB_DHT_KEYWORD_ITEMS)]=nil then
  begin
    Result := nil;
    Exit;
  end;

  Result := db_DHT_keywords.bkt[(crc mod DB_DHT_KEYWORD_ITEMS)];
  while (Result<>nil) do
  begin
    if Length(Result^.Keyword)=Lenkey then
      if CompareMem(@Result^.Keyword[0],Keyword,Lenkey) then Exit;
    Result := Result^.Next;
  end;
end;

function writestringfrombuffer(buff: Pointer; len:Integer): string;
begin
  SetLength(Result,len);
  Move(buff^,Result[1],len);
end;

function DHT_KWList_Addkey(Keyword:PChar; Lenkey: Byte; crc:Word): PDHTKeyword;
var
  First: PDHTKeyword;
begin
  Result := AllocMem(SizeOf(TDHTKeyword));

  SetLength(Result^.Keyword,Lenkey);
  Move(Keyword^,Result^.Keyword[0],Lenkey);

  Result^.FirstItem := nil;
  Result^.Count := 0;
  Result^.crc := crc;

  First := db_DHT_keywords.bkt[(crc mod DB_DHT_KEYWORD_ITEMS)];
  Result^.Next := First;
  if First<>nil then
    First^.Prev := Result;
  Result^.Prev := nil;
  db_DHT_keywords.bkt[(crc mod DB_DHT_KEYWORD_ITEMS)] := Result;
end;



function DHT_KWList_AddShare(Keyword:PDHTKeyword; Share:PRecord_dht_storedfile): PDHTKeywordItem;

  function DHT_KWList_ShareExists(Keyword:PDHTKeyword; Share:PRecord_dht_storedfile): Boolean;
  begin
    if Keyword^.FirstItem=nil then
    begin
      Result := False;
      Exit;
    end;
    Result := (Keyword^.FirstItem^.Share=Share);  // can be only the First Item
  end;

begin
  //we seen already this Keyword for this file, eg Keyword contained in both title and artist field,
  //the First Keyword instance gets a valid 'item' pointer, the second one a nil pointer...
  if DHT_KWList_ShareExists(Keyword,Share) then
  begin
    Result := nil;
    Exit;
  end;

  Result := AllocMem(SizeOf(TDHTKeywordItem));

  Result^.Next := Keyword^.FirstItem;
  if Keyword^.FirstItem<>nil then
    Keyword^.FirstItem^.Prev := Result;
  Result^.Prev := nil;
  Keyword^.FirstItem := Result;
  Result^.Share := Share;

  Inc(Keyword^.Count);
end;

end.
