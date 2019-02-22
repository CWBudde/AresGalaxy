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
DHT dht parsing and serialization routines
}

unit dhtkeywords;

interface

uses
  Classes, Classes2, DhtTypes, Ares_types, Class_cmdlist, thread_dht;

procedure DHT_RepublishKeyFiles;
procedure DHT_RepublishHashFiles;
procedure DHT_clear_keywordsFiles;
procedure DHT_clear_hashFilelist;
procedure DHT_addFileOntheFly(pfile:precord_file_library; justKey:boolean);
procedure DHT_keywordsFile_SetGlobal(sourceList: TMyList);
procedure DHT_get_keywordsFromFile(pfile:precord_file_library; destinationList: TMylist);
procedure DHT_extract_keywords(pfile:precord_file_library; list: Tnapcmdlist; max:integer);
function DHT_GetSerialized_PublishPayload(pfile:precord_file_library): string;
function DHT_is_popularKeywords(const keyw: string): Boolean;

implementation

uses
  vars_global, keywfunc, Windows, SysUtils, DhtConsts, Helper_strings,
  Helper_unicode, Helper_urls, Helper_mimetypes, Dhtutils, Const_ares;

function DHT_is_popularKeywords(const keyw: string): Boolean;
var
 ind: Integer;
begin
result := False;

if keyw='the' then Result := true
 else
 if keyw='of' then Result := true
  else
  if keyw='and' then Result := true
   else
   if keyw='mp3' then Result := true
    else
    if keyw='mpg' then Result := true
     else
      if keyw='mpeg' then Result := true
      else
       if keyw='divx' then Result := true
       else
        if keyw='xvid' then Result := true
        else
         if keyw='vcd' then Result := true
         else
          if keyw='svcd' then Result := true
          else
           if keyw='track' then Result := true
           else
            if keyw='rip' then Result := true
            else
             if keyw='dvd' then Result := true
             else
              if keyw='cd' then Result := true
              else
               if keyw='full' then Result := true
               else
                if keyw='iso' then Result := true
                else
                 if keyw='pc' then Result := true
                 else
                  if keyw='xp' then Result := true
                  else begin
                   ind := strtointdef(keyw,$ffffff);
                   if (ind<>$ffffff) and (ind<50) then Result := True;
                  end;

end;

function DHT_GetSerialized_PublishPayload(pfile:precord_file_library): string;
var
keywordstr,info,fname: string;
list: TNapCmdList;
len: Byte;
begin

list := TNapCmdList.create;
 keywordstr := keywfunc.get_keywordsstr(list,pfile);
list.Free;

fname := widestrtoutf8str(extract_fnameW(utf8strtowidestr(pfile^.path)));

info := chr(length(pfile^.title))+
      chr(TAG_ID_DHT_TITLE)+
      pfile^.title+
      chr(length(fname))+
      chr(TAG_ID_DHT_FILENAME)+
      fname;

 len := length(pfile^.artist);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_ARTIST)+pfile^.artist;
 len := length(pfile^.album);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_ALBUM)+pfile^.album;
 len := length(pfile^.category);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_CATEGORY)+pfile^.category;
 len := length(pfile^.language);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_LANGUAGE)+pfile^.language;
 len := length(pfile^.year);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_DATE)+pfile^.year;
 len := length(pfile^.comment);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_COMMENTS)+pfile^.comment;
 len := length(pfile^.url);
if len>1 then info := info+chr(len)+chr(TAG_ID_DHT_URL)+pfile^.url;

if pfile^.amime=1 then begin
 len := length(pfile^.keywords_genre);
  if len >1 then info := info+chr(len)+chr(TAG_ID_DHT_KEYWGENRE)+pfile^.keywords_genre;
end;

if pfile^.param2>0 then info := info+chr(4)+chr(TAG_ID_DHT_PARAM2)+int_2_dword_string(pfile^.param2);

result := pfile^.hash_sha1+
        keywordstr+
        chr(helper_mimetypes.clienttype_to_shareservertype(pfile^.amime))+
        int_2_Qword_string(pfile^.fsize)+
        int_2_dword_string(pfile^.param1)+
        int_2_dword_string(pfile^.param3)+
        info;

end;

procedure DHT_extract_keywords(pfile:precord_file_library; list: Tnapcmdlist; max:integer);
var
str: string;
j: Integer;
begin

j := 0;

if length(pfile^.title)>1 then begin
 str := utf8str_to_ascii(pfile^.title);
 splitToKeywords(str+' ',list,max-j,false); // strip parentesi e punti
end;

if ((j>=max) or (pfile^.amime=0)) then exit;

if length(pfile^.artist)>1 then begin
 str := utf8str_to_ascii(pfile^.artist);
 splitToKeywords(str+' ',list,max-j,false);
end;

if j>=max then exit;

if ((pfile^.amime=1) or
    (pfile^.amime=7) or
    (pfile^.amime=3)) then begin  //audio,image,exe
   if length(pfile^.album)>1 then begin
    str := utf8str_to_ascii(pfile^.album);
    splitToKeywords(str+' ',list,max-j,false);
   end;
end;


end;

procedure DHT_get_keywordsFromFile(pfile:precord_file_library; destinationList: TMylist);

  function DHT_FindKeyword(const keyword: string; crc:word):precord_DHT_keywordFilePublishReq;
  var
  i: Integer;
  pkeyw:precord_DHT_keywordFilePublishReq;
  begin
  Result := nil;
    for i := 0 to destinationList.count-1 do begin
     pkeyw := destinationList[i];
      if pkeyw^.crc=crc then
       if pkeyw^.keyW=keyword then begin
        Result := pkeyw;
        exit;
       end;
    end;
  end;

var
pKeyw:precord_DHT_keywordFilePublishReq;
list: Tnapcmdlist;
crc: Word;
keystr: string;
begin

list := tnapcmdlist.create;

DHT_extract_keywords(pfile,list,MAX_KEYWORDS);
// m_DHT_KeywordFiles

while (list.count>0) do begin
  keystr := list.str(list.count-1);
          list.delete(list.count-1);


   crc := whl(keystr);

   pkeyw := DHT_FindKeyword(keystr,crc);
   if pkeyw<>nil then begin
      if pkeyw^.fileHashes.indexof(pfile^.hash_sha1)=-1 then pkeyw^.fileHashes.add(pfile^.hash_sha1);
   end else begin
   
     if DHT_is_popularKeywords(keystr) then continue;

     pkeyW := AllocMem(sizeof(record_DHT_keywordFilePublishReq));
      pkeyw^.keyW := keystr;
      pkeyw^.crc := crc;
      pkeyw^.fileHashes := TmyStringList.create;
      pkeyw^.fileHashes.add(pfile^.hash_sha1);
       destinationList.add(pkeyw);

   end;

end;

list.Free;
end;



procedure DHT_RepublishHashFiles;
var
i: Integer;
pfile:precord_file_library;
hashLst: TList;
phash:precord_DHT_hashFile;
begin
DHT_LastPublishHashFiles := gettickcount;


hashLst := DHT_hashFiles.locklist;


  // clear any remaining hash yet to be published
  while (hashlst.count>0) do begin
     phash := hashlst[hashlst.count-1];
            hashlst.delete(hashlst.count-1);
     FreeMem(phash,sizeof(record_DHT_hashFile));
  end;

try

for i := 0 to vars_global.lista_shared.count-1 do begin
 pfile := vars_global.lista_shared[i];
  if not pfile^.shared then continue;
   if pfile^.previewing then continue;
    if length(pfile^.hash_sha1)<>20 then continue;
      if pfile^.amime=ARES_MIME_IMAGE then
       if pos(STR_ALBUMART,lowercase(pfile^.title))=0 then continue;

  // generate source hash record
 phash := AllocMem(sizeof(record_DHT_hashfile));
  move(pfile^.hash_sha1[1],phash^.HashValue[0],20);

   hashLst.add(phash);
end;

except
end;
DHT_hashFiles.Unlocklist;
end;

procedure DHT_RepublishKeyFiles;
var
i: Integer;
pfile:precord_file_library;
kwdlst: Tlist;
pkeyw:precord_DHT_keywordFilePublishReq;
TempList: TMylist;
begin
try
if vars_global.threadDHT=nil then exit;
except
exit;
end;

DHT_LastPublishKeyFiles := gettickcount;

 TempList := tmylist.create;
 try

 for i := 0 to vars_global.lista_shared.count-1 do begin
  pfile := vars_global.lista_shared[i];
  if not pfile^.shared then continue;
   if pfile^.previewing then continue;
    if length(pfile^.hash_sha1)<>20 then continue;

     if pfile^.amime=ARES_MIME_IMAGE then
       if pos(STR_ALBUMART,lowercase(pfile^.title))=0 then continue;

    dhtkeywords.DHT_get_keywordsFromFile(pfile,TempList); // extract keywords (very expensive especially here in main thread)
 end;



 kwdlst := DHT_KeywordFiles.Locklist;  // send them to DHT thread


  // clear old list if anything remains here...should definitely not be the case
  // unless it's something added right after download
  while (kwdlst.count>0) do begin
   pkeyw := kwdlst[kwdlst.count-1];
          kwdlst.delete(kwdlst.count-1);

   pkeyw^.keyW := '';
   pkeyw^.fileHashes.Free;
   FreeMem(pkeyw,sizeof(record_DHT_keywordFilePublishReq));
  end;

  // copy our fresh keywords to be published
  while (TempList.count>0) do begin
     pkeyw := TempList[TempList.count-1];
            TempList.delete(TempList.count-1);
     kwdlst.add(pkeyw);
  end;

 DHT_KeywordFiles.Unlocklist;


 
 except
 end;
 TempList.Free;

end;


// file download completed! publish it on DHT
procedure DHT_addFileOntheFly(pfile:precord_file_library; justKey:boolean);
var
hashLst: Tlist;
phash:precord_DHT_hashFile;
kwdlst: Tlist;
pkeyw:precord_DHT_keywordFilePublishReq;
TempList: TMylist;
added: Boolean;
begin
if vars_global.threadDHT=nil then exit;

if not JustKey then begin
 // generate source hash record
phash := AllocMem(sizeof(record_DHT_hashfile));
 move(pfile^.hash_sha1[1],phash^.HashValue[0],20);

 hashLst := DHT_hashFiles.locklist;
  hashLst.add(phash);
 DHT_hashFiles.Unlocklist;
end;


 TempList := tmylist.create;
 dhtkeywords.DHT_get_keywordsFromFile(pfile,TempList); // extract keywords

 added := False;
 kwdlst := DHT_KeywordFiles.Locklist;  // send them to DHT thread
  while (TempList.count>0) do begin
     pkeyw := TempList[TempList.count-1];
            TempList.delete(TempList.count-1);

     kwdlst.add(pkeyw);

     if (justKey) and (not added) then begin
      added := True;
      thread_dht.tempMagnetList.add(pfile);
     end;


  end;
 DHT_KeywordFiles.Unlocklist;

 TempList.Free;
end;

procedure DHT_clear_keywordsFiles;
var
kwdlst: Tlist;
pkeyw:precord_DHT_keywordFilePublishReq;
begin
kwdlst := DHT_KeywordFiles.Locklist;
try

 while (kwdlst.count>0) do begin
   pkeyw := kwdlst[kwdlst.count-1];
          kwdlst.delete(kwdlst.count-1);

   pkeyw^.keyW := '';
   pkeyw^.fileHashes.Free;
   FreeMem(pkeyw,sizeof(record_DHT_keywordFilePublishReq));
 end;

except
end;
DHT_KeywordFiles.Unlocklist;
end;

procedure DHT_keywordsFile_SetGlobal(sourceList: TMyList);
var
kwdlst: Tlist;
pkeyw:precord_DHT_keywordFilePublishReq;
begin
kwdlst := DHT_KeywordFiles.Locklist;
try

  while (sourceList.count>0) do begin
     pkeyw := sourceList[sourceList.count-1];
            sourceList.delete(sourceList.count-1);
     kwdlst.add(pkeyw);
  end;

except
end;
DHT_KeywordFiles.UnLocklist;
end;

procedure DHT_clear_hashFilelist;
var
  hashLst: Tlist;
  phash:precord_DHT_hashFile;
begin
  hashLst := DHT_hashFiles.Locklist;
  try

    while (hashlst.count>0) do begin
       phash := hashlst[hashlst.count-1];
              hashlst.delete(hashlst.count-1);
       FreeMem(phash,sizeof(record_DHT_hashFile));
    end;

  except
  end;
  DHT_hashFiles.UnLocklist;
end;


end.
