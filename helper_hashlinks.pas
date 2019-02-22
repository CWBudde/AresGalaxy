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

unit helper_hashlinks;

{
Description:
hashlink handling (Ares-.arlnk and MagnetURI)
}

interface

uses
 ares_types,ares_objects,sysutils,tntwindows,zlib,classes2,windows,classes,
 registry,forms,comettrees,ufrm_settings,helper_registry;

procedure export_hashlink(datao:precord_file_library; addsource:boolean);
procedure add_weblink(url: string);
procedure check_hashlink_associations(reg: Tregistry);
procedure export_hashlink_fromchatroombrowse;
procedure export_hashlink_fromchatroomresult;
procedure mainGui_exporthashlink_fromresult;
procedure download_hashlink_frommemo;
procedure add_magnet_link(url: string);

implementation

uses
 ufrmmain,helper_base64_32,helper_crypt,helper_strings,
 helper_unicode,helper_urls,vars_global,helper_diskio,
 helper_mimetypes,helper_ipfunc,const_ares,helper_channellist,
 helper_download_misc,
 shoutcast,helper_gui_misc,cometpageview,
 bittorrentUtils,helper_share_misc;


{procedure reg_toggle_magnetassoc;
var
reg: Tregistry;
begin
  reg := tregistry.create;


  with reg do begin

   openkey(areskey,true);
   writeinteger('HashLinks.HookMagnet',integer(vars_global.check_opt_hlink_magnet_checked));
   closekey;

 try
      
 if vars_global.check_opt_hlink_magnet_checked then begin
   rootkey := HKEY_CLASSES_ROOT;
   if openkey('magnet',true) then begin
    writestring('','URL:Magnet protocol');
    writestring('URL Protocol','');
   closekey;
   openkey('magnet\shell\open\command',true);
   writestring('','"'+application.exename+'" "%L"');
    closekey;
   rootkey := HKEY_LOCAL_MACHINE;
    openkey('Software\Classes\magnet\',true);
    writestring('','URL:Magnet protocol');
    writestring('URL Protocol','');
    closekey;
   openkey('Software\Classes\magnet\shell\open\command',true);
    writestring('','"'+application.exename+'" "%L"');
   closekey;
 end;
end;
except
end;

 end;



reg.destroy;

end; }

procedure download_hashlink_frommemo;
var
url: string;
posi: Integer;
begin

url := trim(widestrtoutf8str(frm_settings.Memo_opt_hlink.text));
set_regstring('General.LastHashLink',url);

posi := pos(const_ares.STR_ARLNK_LOWER,lowercase(url));
if posi>0 then begin
 add_weblink(copy(url,posi+8,length(url)));
 exit;
end;

posi := pos('magnet:?',lowercase(url));
if posi>0 then begin
 add_magnet_link(copy(url,posi,length(url)));
 exit;
end;

end;

procedure mainGui_exporthashlink_fromresult;
var
pfile:precord_file_library;
datao:precord_search_result;
node:pCmtVnode;
src:precord_panel_search;
i: Integer;
begin
try

for i := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[i];
 if src^.ContainerPanel<>ares_frmmain.pagesrc.activepanel then continue;

 node := src^.listview.getfirstselected;
 if node=nil then exit;

 datao := src^.listview.getdata(node);

             pfile := AllocMem(sizeof(record_file_library));
             with pfile^ do begin
              hash_sha1 := datao^.hash_sha1;
              fsize := datao^.fsize;
              path := 'e:\'+datao^.filenameS;
              category := datao^.category;
              year := datao^.year;
              artist := datao^.artist;
              album := datao^.album;
             end;
          export_hashlink(pfile,false);
             with pfile^ do begin
              album := '';
              artist := '';
              year := '';
              category := '';
              path := '';
              hash_sha1 := '';
              hash_of_phash := '';
             end;
              FreeMem(pfile,sizeof(record_file_library));
break;
end;


except
end;
end;

procedure export_hashlink_fromchatroomresult;
begin
end;


procedure export_hashlink_fromchatroombrowse;
begin
end;


procedure add_magnet_link(url: string);
var
suggestedMime: Integer;
hash_sha1s,
fname,
estensione,
titles: string;
down: Tdownload;
thearr: Targuments;
i: Integer;
str,variable,argument: string;
tracker,hash,suggestedName: string;
begin
{
Here is a description of the Magnet Urn:
xt - the fingerprint of a file expressed as a sha1 hash
dn - the name of the file
xs - the source of a file, potentially on a P2P network or webserver
as - an alternate (or second) source for the file if available
}
 helper_gui_misc.showMainWindow;


try

//hash_sha1 := copy(url,pos('xt=urn:sha1:',lowercase(url))+12,32);
//if pos('&',hash_sha1)<>0 then delete(hash_sha1,pos('&',hash_sha1),length(hash_sha1));
if pos('xt=urn:btih:',lowercase(url))<>0 then begin

  if pos('magnet:?',lowercase(url))=1 then delete(url,1,8); //strip magnet:?


  tracker := '';
  hash := '';
  suggestedName := '';
  suggestedMime := 100;
  thearr := helper_strings.explode(url,'&');
  for i := 0 to length(thearr)-1 do begin
   str := thearr[i];
   variable := copy(str,1,pos('=',str)-1);
   argument := urldecode(copy(str,pos('=',str)+1,length(str)));
   if variable='xt' then hash := copy(argument,10,length(argument)) else
   if variable='dn' then suggestedName := argument else
   if variable='tr' then tracker := tracker+argument+CHRNULL else
   if variable='sm' then suggestedMime := strtointdef(argument,100);

   thearr[i] := '';
  end;
  if is_torrent_in_progress(hexstr_to_bytestr(hash)) then exit;

  bittorrentUtils.loadmagnetTorrent(hash,suggestedName,suggestedMime,tracker);

  SetLength(thearr,0);
  exit;
end;


  thearr := helper_strings.explode(url,'&');
  for i := 0 to length(thearr)-1 do begin
   str := thearr[i];
   
   variable := copy(str,1,pos('=',str)-1);
   argument := copy(str,pos('=',str)+1,length(str));

   if (variable='xt.1') or
      (variable='xt') then begin
       if pos('urn:sha1:',lowercase(argument))=1 then begin
        hash_sha1s := copy(argument,pos(':',argument)+1,length(argument));
        delete(hash_sha1s,1,pos(':',hash_sha1s));
        hash_sha1s := decodebase32(hash_sha1s);
       end else
       if pos('urn:bitprint:',lowercase(argument))=1 then begin
        hash_sha1s := copy(argument,pos(':',argument)+1,length(argument));
        delete(hash_sha1s,1,pos(':',hash_sha1s));
        delete(hash_sha1s,pos('.',hash_sha1s),length(hash_sha1s));
        hash_sha1s := decodebase32(hash_sha1s);
       end;
   end else
   if variable='dn' then fname := urldecode(argument);


   thearr[i] := '';
  end;

  SetLength(thearr,0);



 if length(hash_sha1s)<>20 then exit;
 if length(fname)<1 then begin
  fname := 'magnet_'+bytestr_to_hexstr(hash_sha1s)+'.raw';
 end;

 estensione := extractfileext(fname);
 if length(estensione)<2 then exit;

 titles := fname;
 delete(titles,(length(titles)-length(estensione))+1,length(estensione));
 if ((length(estensione)>10) or (length(estensione)<1)) then estensione := '.raw';


 down := tdownload.create;
 helper_download_misc.seek_suitable_filename(fname,
                                             utf8strtowidestr(titles),
                                             '',
                                             '',
                                             down);

 with down do begin
  hash_sha1 := hash_sha1s;
  crcsha1 := crcstring(hash_sha1s);
  tipo := extstr_to_mediatype(lowercase(estensione));
  size := 0;
  param1 := 0;
  param2 := 0;
  param3 := 0;
  title := titles;
  artist := '';
  album := '';
  category := '';
  date := '';
  language := '';
  url := '';
  comments := '';
  keyword_genre := '';
  AddVisualReference;
end;

  lista_down_temp.add(down);


  if ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activepage := IDTAB_TRANSFER;
except
end;
end;

procedure add_weblink(url: string);
var
str: string;
hash_sha1s: string;
sizec: Int64;
filename,titles: string;
estensione: string;

down: Tdownload;
risorsa: Trisorsa_download;
ipc: Cardinal;
portw: Word;
list: TMyStringList;

fiel: Byte;
artists,albums,categorys,dates,languages: string;
begin           // hash + size + filename+null + 10+ip+port
if length(url)<10 then exit;
try


helper_gui_misc.showMainWindow;
 
if pos('chatroom:',lowercase(url))=1 then begin
  join_arlnk_chat(copy(url,10,length(url)),true);
  exit;
end else
if pos('radio:',lowercase(url))=1 then begin
 shoutcast.arlnk_addradio(copy(url,7,length(url)));
 exit;
end;


str := DecodeBase64(url);
 str := d67(str,28435);

 str := zlib.zDecompressStr(str);


  sizec := chars_2_dword(copy(str,17,4)); //skip null md5
 delete(str,1,20);
  filename := copy(str,1,pos(CHRNULL,str)-1); //utf8
 delete(str,1,pos(CHRNULL,str));

if sizec=0 then begin  //special hashlinks may contain different data
 if filename='CHATCHANNEL' then join_arlnk_chat(str);
  exit;
end;

  estensione := lowercase(extractfileext(filename));
 titles := copy(filename,1,length(filename)-(length(estensione)));

 list := nil; //sorgenti
 artists := '';
 albums := '';
 categorys := '';
 dates := '';
 languages := '';
 while (length(str)>1) do begin
  fiel := ord(str[1]);
  delete(str,1,1);
  case fiel of
   2:begin
     artists := copy(str,1,pos(CHRNULL,str)-1);
     delete(str,1,pos(CHRNULL,str));
     end;
    3:begin
     albums := copy(str,1,pos(CHRNULL,str)-1);
     delete(str,1,pos(CHRNULL,str));
     end;
    4:begin
     categorys := copy(str,1,pos(CHRNULL,str)-1);
     delete(str,1,pos(CHRNULL,str));
     end;
    5:begin
     dates := copy(str,1,pos(CHRNULL,str)-1);
     delete(str,1,pos(CHRNULL,str));
     end;
    6:begin
     languages := copy(str,1,pos(CHRNULL,str)-1);
     delete(str,1,pos(CHRNULL,str));
     end;
    7:begin
       if list=nil then list := tmyStringList.create;
       list.add(copy(str,1,6));
       delete(str,1,6);
      end;
     8:begin
      hash_sha1s := copy(str,1,20);
      delete(str,1,20);
     end;
     9:begin      //2951+
      sizec := chars_2_Qword(copy(str,1,8));
      delete(str,1,8);
     end else break; //per ora skippiamo
    end;
 end;


if hash_sha1s='' then exit;
if length(hash_sha1s)<>20 then exit;


down := tdownload.create;
helper_download_misc.seek_suitable_filename(filename,
                                            utf8strtowidestr(titleS),
                                            utf8strtowidestr(artistS),
                                            utf8strtowidestr(albumS),
                                            down);
with down do begin
 hash_sha1 := hash_sha1s;
 crcsha1 := crcstring(hash_sha1s);
 size := sizec;
 param1 := 0;
 param2 := 0;
 param3 := 0;
 title := titles;
 artist := artists;
 album := albums;
 category := categorys;
 date := dates;
 language := languages;
 url := '';
 comments := '';
 keyword_genre := '';
 AddVisualReference;
end;

  lista_down_temp.add(down);

  if list<>nil then begin //aggiungiamo anche sources ora
    while (list.count>0) do begin
     str := list.strings[0];
         list.delete(0);
     ipc := chars_2_dword(copy(str,1,4));
     portw := chars_2_word(copy(str,5,2));
       risorsa := trisorsa_download.create;
        with risorsa do begin
         handle_download := cardinal(down);
         ip := ipc;
         porta := portw;
         ip_interno := 0;
         nickname := STR_ANON+ip_to_hex_str(ipc)+STR_UNKNOWNCLIENT; //contiene anche @agent nei nuovi servers
         tick_attivazione := 0;
         socket := nil;
         download := down;
         AddVisualReference;
       end;
         down.lista_risorse.add(risorsa);
    end;
   list.Free;
  end;

  if ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activepage := IDTAB_TRANSFER;
except
end;
end;

procedure export_hashlink(datao:precord_file_library; addsource:boolean);
var
nomefile: WideString;
stream: Thandlestream;
str_normal: string;
str_source: string;
str: string;
str_magnet: string;
begin
with datao^ do begin
if length(hash_sha1)<>20 then exit;

str_normal := '0000000000000000'+
            int_2_dword_string(fsize)+
            widestrtoutf8str(extract_fnameW(utf8strtowidestr(path)))+CHRNULL;

if length(language)>1 then str_normal := str_normal+chr(6)+language+CHRNULL;
if length(category)>1 then str_normal := str_normal+chr(4)+category+CHRNULL;
if length(year)>1 then str_normal := str_normal+chr(5)+year+CHRNULL;
if length(artist)>1 then str_normal := str_normal+chr(2)+artist+CHRNULL;
if length(album)>1 then str_normal := str_normal+chr(3)+album+CHRNULL;

 if fsize>LIMIT_INTEGER then str_normal := Str_normal+chr(9)+int_2_Qword_string(fsize); //2951+
//TODO check max len !!!!!

if length(hash_sha1)=20 then begin
                                   str_magnet := 'magnet:?xt=urn:sha1:'+encodebase32(hash_sha1)+
                                               '&dn='+widestrtoutf8str(extract_fnameW(utf8strtowidestr(path)));
                                   end else begin
                                    str_magnet := '';
                                   end;

if addsource then begin
                   str_source := str_normal+
                               chr(7)+int_2_dword_string(vars_global.localipC)+
                               int_2_word_string(vars_global.myport);
                   if length(hash_sha1)=20 then str_source := str_source+chr(8)+hash_sha1; //recentemente...
                  end;

 if length(hash_sha1)=20 then str_normal := str_normal+chr(8)+hash_sha1;

str_normal := zcompressstr(str_normal);
str_normal := e67(str_normal,28435);
 str_normal := const_ares.STR_ARLNK_LOWER+EncodeBase64(str_normal);

if addsource then begin
 str_source := zcompressstr(str_source);
 str_source := e67(str_source,28435);
  str_source := const_ares.STR_ARLNK_LOWER+EncodeBase64(str_source);
end;


if not addsource then begin
  str := 'HashLink for file: '+CRLF+widestrtoutf8str(extract_fnameW(utf8strtowidestr(path)))+CRLF+
       'Size: '+format_currency(fsize)+' '+STR_BYTES+CRLF+
       'Hash: '+bytestr_to_hexstr(hash_sha1)+CRLF+CRLF+
       'HashLink'+CRLF+str_normal+CRLF+CRLF;
end else begin
 str := 'HashLinks for file: '+CRLF+path+CRLF+
      'Size: '+format_currency(fsize)+' '+STR_BYTES+CRLF+
      'Hash: '+bytestr_to_hexstr(hash_sha1)+CRLF+CRLF+
      'Simple HashLink'+CRLF+str_normal+CRLF+CRLF+
      'HashLink including yourself as a source'+CRLF+str_source+CRLF+CRLF;
end;
end;


if length(str_magnet)>0 then str := str+'Magnet URI'+CRLF+
                                       str_magnet+CRLF+CRLF;

  tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);
       nomefile := formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' hashlink temp.txt';



      stream := MyFileOpen(data_path+'\Temp\'+nomefile,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream=nil then exit;
      with stream do write(str[1],length(str));
      FreeHandleStream(stream);
      
     Tnt_ShellExecuteW(ares_frmmain.handle,'open',pwidechar(widestring('notepad')),pwidechar(data_path+'\Temp\'+nomefile),nil,SW_SHOW);

end;


procedure check_hashlink_associations(reg: Tregistry);
begin
////////////////////////////////////////////////// arlnk


with reg do begin

try

 rootkey := HKEY_CLASSES_ROOT;
 {
  openkey('.arlnk',true);
   writestring('','Ares.Arlnk');
  closekey;
  openkey('Ares.Arlnk',true);
   writestring('','URL:Ares protocol');
   writestring('URL Protocol','');
  closekey;
  openkey('Ares.Arlnk\shell\open\command',true);
   writestring('','"'+application.exename+'" "%L"');
  closekey;

  openkey('Arlnk',true);
   writestring('','URL:Ares protocol');
   writestring('URL Protocol','');
  closekey;
  openkey('Arlnk\shell\open\command',true);
   writestring('','"'+application.exename+'" "%L"');
  closekey;

 rootkey := HKEY_LOCAL_MACHINE;
  openkey('Software\Classes\Ares.Arlnk',true);
   writestring('','URL:Ares protocol');
   writestring('URL Protocol','');
  closekey;
  openkey('Software\Classes\Ares.Arlnk\shell\open\command',true);
   writestring('','"'+application.exename+'" "%L"');
  closekey;}
/////////////////////////////////////////////////////////

//////////////////////////////////////////////////  collections
{ rootkey := HKEY_CLASSES_ROOT;
  openkey('.arescol',true);
   writestring('','Ares.CollectionList');
  closekey;

  openkey('Ares.CollectionList\Content Type',true);
   writestring('','application/x-ares');
  closekey;
  openkey('Ares.CollectionList\DefaultIcon',true);
   writestring('','"'+application.exename+'",0');
  closekey;
  openkey('Ares.CollectionList\shell\open\command',true);
   writestring('','"'+application.exename+'" "%1"');
  closekey;}
 except
 end;

 try
 rootkey := HKEY_CURRENT_USER;
  openkey('Software\Classes\.arescol',true);
   writestring('','Ares.CollectionList');
  closekey;

  openkey('Software\Classes\Ares.CollectionList\Content Type',true);
   writestring('','application/x-ares');
  closekey;
  openkey('Software\Classes\Ares.CollectionList\DefaultIcon',true);
   writestring('','"'+application.exename+'",0');
  closekey;
  openkey('Software\Classes\Ares.CollectionList\shell\open\command',true);
   writestring('','"'+application.exename+'" "%1"');
  closekey;
except
end;

end;
//////////////////////////////////////////////////
end;

end.
