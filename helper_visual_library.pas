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
library virtual/regular folders view 
}

unit helper_visual_library;

interface

uses
comettrees,classes2,ares_types,imglist,graphics,windows,classes,controls,sysutils;

function apri_categoria_library(regname1,regname2: string; tree: Tcomettree; listview: Tcomettree; lista_files_utente: TMylist; level: Integer; node:PCmtVNode): Tstato_library_header;
function trova_nodo_treeview2_folder(listview: Tcomettree; tree: Tcomettree):PCmtVNode;
function trova_nodo_treeview1_categoria(tree: Tcomettree; rawcat: string):PCmtVNode;
procedure cancella_cartella_per_treeview2(folder:precord_cartella_share);
procedure library_file_show(tree: Tcomettree; pfile:precord_file_library);
procedure apri_general_library_virtual_view(showshared: Boolean; lista_files: TMylist;listview: Tcomettree; imagelist_lib_max: Timagelist);
procedure apri_general_library_folder_view(showshared: Boolean; lista_files: TMylist; listview: Tcomettree; imagelist_lib_max: Timagelist; treeview2: Tcomettree);
procedure add_base_virtualnodes(tree: Tcomettree; includerecent:boolean);
procedure add_virfolders_entry(list: TMylist;const stringain: string);
procedure free_virfolders_entries(list: TMylist);
function stringa_in_nodi_child(stringa: string; tree: TcometTree; nodoparent:PCmtVNode):PCmtVNode;
function folder_id_to_folder_displayname(folder_id: Word; tree: Tcomettree): string;
function folder_id_to_folder_name(folder_id: Word; tree: Tcomettree): WideString;
procedure library_file_showdetails(hash_sha1: string);
procedure details_library_toggle(sshow:boolean);
procedure toggle_regularchatfolderbrowse_click(sender: Tobject);
procedure details_library_hideall;

procedure mainGui_decsharedall;
procedure decrementa_recent_treeview_library;
procedure mainGui_erase_shared_entry(crcsha1: Word; hash_sha1: string);
procedure edit_nodevirfolders(before: string; after: string; tree: Tcomettree; nodo:PCmtVNode);
procedure mainGui_updatevirfolders_entry(artist: string; album: string; categ: string; tipo: Byte); overload;
procedure mainGui_updatevirfolders_entry; overload;
procedure mainGui_copyfiletonode(tree: Tcomettree; pfile:precord_file_library);
procedure mainGui_deletesharefile(nomefile: string);
procedure mainGui_delete_regviewentry(nomefile: string);
procedure mainGui_delete_virviewentry(artist,category,album: string; tipo: Byte); overload;
procedure mainGui_delete_virviewentry(mimes,param1,param2,param3: string); overload;


implementation

uses
ufrmmain,helper_strings,vars_global,
vars_localiz,const_ares,helper_unicode,helper_urls,helper_mimetypes,
helper_visual_headers,utility_ares,helper_combos,helper_share_misc,
helper_stringfinal;


procedure mainGui_delete_virviewentry(artist,category,album: string; tipo: Byte);
var
mimes,param1,
param2,param3: string;
begin

case tipo of
 ARES_MIME_OTHER:begin
  mimes := 'Other';
  param1 := '';
  param2 := '';
  param3 := '';
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end;
 ARES_MIME_VIDEO:begin
  mimes := 'Video';
  param1 := category;
  param2 := '';
  param3 := '';
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end;
 ARES_MIME_DOCUMENT:begin
  mimes := 'Document';
  param1 := artist;
  param2 := category;
  param3 := '';
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end;
 ARES_MIME_IMAGE:begin
  mimes := 'Image';
  param1 := album;
  param2 := category;
  param3 := '';
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end;
 ARES_MIME_SOFTWARE:begin
  mimes := 'Software';
  param1 := artist;
  param2 := category;
  param3 := '';
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end else begin
  mimes := 'Audio';
  param1 := artist;
  param2 := album;
  param3 := category;
  mainGui_delete_virviewentry(mimes,param1,param2,param3);
 end;
end;

end;


procedure mainGui_delete_regviewentry(nomefile: string);
var
nd,nodoroot:pCmtVnode;
patho: string;
data:^record_cartella_share;
begin
patho := widestrtoutf8str(extract_fpathW(utf8strtowidestr(nomefile)));

with ares_frmmain.treeview_lib_regfolders do begin
 nodoroot := GetFirst;
 if nodoroot=nil then exit;

nd := getfirstchild(nodoroot);
while (nd<>nil) do begin
 data := getdata(nd);
 if AnsiCompareFileName(widestrtoutf8str(data^.path),patho)=0 then begin
  dec(data^.items);
  if data^.items<1 then DeleteNode(nd);
   break;
 end;

 nd := getnextsibling(nd);
end;

end;
end;

procedure mainGui_deletesharefile(nomefile: string);
var
i: Integer;
ffile:precord_file_library;
mime: Integer;
artist,category,album: string;
begin
try
mime := -1;

for i := 0 to lista_shared.count-1 do begin
ffile := lista_shared[i];
  if AnsiCompareFileName(nomefile,ffile^.path)=0 then begin
   artist := ffile^.artist;
   category := ffile^.category;
   album := ffile^.album;
   mime := ffile^.amime;
   if ffile^.filedate+7>now then decrementa_recent_treeview_library;
   break;
  end;
end;

 if mime=-1 then exit;

 mainGui_decsharedall;
 mainGui_delete_regviewentry(nomefile);
 mainGui_delete_virviewentry(artist,category,album,mime);
 except
 end;
end;

procedure mainGui_copyfiletonode(tree: Tcomettree; pfile:precord_file_library);
var
nodo:pCmtVnode;
datao:precord_file_library;
begin
with tree do begin
 nodo := getfirstselected;
 if nodo=nil then exit;

 datao := getdata(nodo);

with datao^ do begin
 album := pfile^.album;
 title := pfile^.title;
 artist := pfile^.artist;
 category := pfile^.category;
 language := pfile^.language;
 comment := pfile^.comment;
 url := pfile^.url;
 shared := pfile^.shared;
 year := pfile^.year;
end;

invalidatenode(nodo);
end;

end;

procedure mainGui_updatevirfolders_entry;
var
i: Integer;
ffile:precord_file_library;
title,artist,category,album,language,year,url,comment,oldalbum,oldcategory,oldartist: string;
crcsha1: Word;
begin
if hash_select_in_library='' then exit;
if length(hash_select_in_library)<>20 then exit;

with ares_frmmain do begin
 try

title := widestrtoutf8str(strippa_parentesi(edit_title.text));
comment := widestrtoutf8str(edit_description.text);
url := widestrtoutf8str(edit_url_library.text); // url
 if combocatlibrary.visible then category := widestrtoutf8str(strippa_parentesi(combocatlibrary.text)) else category := '';
if edit_author.visible then artist := widestrtoutf8str(strippa_parentesi(edit_author.text)) else artist := '';
 if edit_album.visible then album := widestrtoutf8str(strippa_parentesi(edit_album.text)) else album := '';
if edit_language.visible then language := widestrtoutf8str(strippa_parentesi(edit_language.text)) else language := '';
if edit_year.visible then year := widestrtoutf8str(strippa_parentesi(edit_year.text)) else year := '';

crcsha1 := crcstring(hash_select_in_library);

for i := 0 to vars_global.lista_shared.count-1 do begin
  ffile := vars_global.lista_shared[i];
   if ffile^.crcsha1<>crcsha1 then continue;
   if ffile^.hash_sha1<>hash_select_in_library then continue;


   oldcategory := ffile^.category;
   oldartist := ffile^.artist;
   oldalbum := ffile^.album;
     mainGui_updatevirfolders_entry(oldartist,oldalbum,oldcategory,ffile^.amime);


     ffile^.shared := chk_lib_fileshared.Checked;
     shareun1.checked := chk_lib_fileshared.Checked;

     ffile^.title := trim(title);
     ffile^.comment := comment;
     ffile^.url := url; // url

    if ffile^.amime<>ARES_MIME_OTHER then begin
     ffile^.category := trim(category);
     ffile^.artist := trim(artist);
     if ffile^.amime<>ARES_MIME_SOFTWARE then ffile^.album := trim(album); //software version
     ffile^.language := language;
     ffile^.year := year;
     if ((ffile^.amime<>ARES_MIME_IMAGE) and (ffile^.amime<>ARES_MIME_MP3)) then ffile^.language := language;
   end;
     ffile^.write_to_disk := True;

       mainGui_copyfiletonode(listview_lib{treeview_lib_virfolders},ffile);
    break;

end;


 except
 end;

end;
end;

procedure mainGui_updatevirfolders_entry(artist: string; album: string; categ: string; tipo: Byte);
var
noderoot,nodeall,nodeaudio,nodeimage,nodevideo,nodedocument,nodesoftware,
node1,node2,node3:pCmtVnode;
new_art,new_cat,new_alb: string;
has_newart,has_newcat,has_newalb: Boolean;
begin

if lowercase(categ)=GetLangStringA(STR_UNKNOW_LOWER) then categ := '';
if lowercase(album)=GetLangStringA(STR_UNKNOW_LOWER) then album := '';
if lowercase(artist)=GetLangStringA(STR_UNKNOW_LOWER) then artist := '';

new_art := '';
new_alb := '';
new_cat := '';

with ares_frmmain do begin

 if combocatlibrary.visible then new_cat := trim_extended(combocatlibrary.text);
 if edit_author.visible then new_art := trim_extended(edit_author.text);
 if edit_album.visible then new_alb := trim_extended(edit_album.text);
  if new_art=GetLangStringA(STR_UNKNOW_LOWER) then new_art := '';
  if new_cat=GetLangStringA(STR_UNKNOW_LOWER) then new_cat := '';
  if new_alb=GetLangStringA(STR_UNKNOW_LOWER) then new_alb := '';

 if artist=new_art then has_newart := false else begin
  has_newart := edit_author.visible;
 end;
 if categ=new_cat then has_newcat := false else begin
  has_newcat := combocatlibrary.visible;
 end;
 if album=new_alb then has_newalb := false else begin
  has_newalb := edit_album.visible;
 end;

 if not has_newalb then
  if not has_newcat then
   if not has_newart then exit;

// cominciamo
with treeview_lib_virfolders do begin
 noderoot := GetFirst;
 nodeall := getfirstchild(noderoot);
 nodeaudio := getnextsibling(nodeall);
 nodeimage := getnextsibling(nodeaudio);
 nodevideo := getnextsibling(nodeimage);
 nodedocument := getnextsibling(nodevideo);
 nodesoftware := getnextsibling(nodedocument);

case tipo of
 ARES_MIME_OTHER:exit;
 ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
  node1 := getfirstchild(nodeaudio);
  node2 := getnextsibling(node1);
  node3 := getnextsibling(node2);
  if has_newart then edit_nodevirfolders(artist,new_art,treeview_lib_virfolders,node1);
  if has_newalb then edit_nodevirfolders(album,new_alb,treeview_lib_virfolders,node2);
  if has_newcat then edit_nodevirfolders(categ,new_cat,treeview_lib_virfolders,node3);
  sort(node1,0,sdascending);
  sort(node2,0,sdascending);
  sort(node3,0,sdascending);
 end;
 ARES_MIME_SOFTWARE:begin
  node1 := getfirstchild(nodesoftware);
  node2 := getnextsibling(node1);
  if has_newart then edit_nodevirfolders(artist,new_art,treeview_lib_virfolders,node1);
  if has_newcat then edit_nodevirfolders(categ,new_cat,treeview_lib_virfolders,node2);
  sort(node1,0,sdascending);
  sort(node2,0,sdascending);
end;
 ARES_MIME_VIDEO:begin
  node1 := getfirstchild(nodevideo);
  if has_newcat then edit_nodevirfolders(categ,new_cat,treeview_lib_virfolders,node1);
  sort(node1,0,sdascending);
 end;
 ARES_MIME_DOCUMENT:begin
  node1 := getfirstchild(nodedocument);
  node2 := getnextsibling(node1);
  if has_newart then edit_nodevirfolders(artist,new_art,treeview_lib_virfolders,node1);
  if has_newcat then edit_nodevirfolders(categ,new_cat,treeview_lib_virfolders,node2);
  sort(node1,0,sdascending);
  sort(node2,0,sdascending);
 end;
 ARES_MIME_IMAGE:begin
  node1 := getfirstchild(nodeimage);
  node2 := getnextsibling(node1);
  if has_newalb then edit_nodevirfolders(album,new_alb,treeview_lib_virfolders,node1);
  if has_newcat then edit_nodevirfolders(categ,new_cat,treeview_lib_virfolders,node2);
  sort(node1,0,sdascending);
  sort(node2,0,sdascending);
 end;
end;

end;
end;
end;

procedure edit_nodevirfolders(before: string; after: string; tree: Tcomettree; nodo:pCmtVnode);
var
nd:pCmtVnode;
data:ares_types.precord_string;
need_delete,need_create: Boolean;
loaft,lobef: string;
begin
need_delete := False;
need_create := False;

if before='' then before := GetLangStringA(STR_UNKNOWN);
if after='' then after := GetLangStringA(STR_UNKNOWN);
loaft := lowercase(after);
lobef := lowercase(before);

with tree do begin

nd := getfirstChild(nodo);
while (nd<>nil) do begin

data := getdata(nd);

 if lowercase(data^.str)=loaft then begin
   need_delete := True;
   inc(data^.counter);
   invalidatenode(nd);
  break;
 end;

 nd := getnextsibling(nd);
end;



if need_delete then begin

nd := getFirstChild(nodo);
while (nd<>nil) do begin
 data := getdata(nd);

 if lowercase(data^.str)=lobef then begin
  dec(data^.counter);
  if data^.counter>0 then invalidatenode(nd)
   else deletenode(nd);
  break;
 end;

 nd := getnextsibling(nd);
end;

end else begin

nd := getfirstchild(nodo);
while (nd<>nil) do begin
  data := getdata(nd);
    if lowercase(data^.str)=lobef then begin
       if data^.counter>1 then begin
        dec(data^.counter);
        invalidatenode(nd);
        need_create := True;
       end else begin
        data^.str := after;
        data^.counter := 1;
        invalidatenode(nd);
        need_create := False;
       end;
     break;
    end;

 nd := getnextsibling(nd);
end;

end;





if need_create then begin
 nd := AddChild(nodo);
  data := getdata(nd);
  data^.str := after;
  data^.counter := 1;
end;

end;
end;

procedure mainGui_erase_shared_entry(crcsha1: Word; hash_sha1: string);
var
i: Integer;
ffile:precord_file_library;
begin

 if length(hash_sha1)<>20 then exit;

for i := 0 to lista_shared.count-1 do begin
ffile := lista_shared[i];
 if crcsha1=ffile^.crcsha1 then
  if hash_sha1=ffile^.hash_sha1 then begin

 if ffile^.shared then
  if my_shared_count>0 then dec(my_shared_count); 

    lista_shared.delete(i);
     finalize_file_library_item(ffile);
    FreeMem(ffile,sizeof(record_file_library));
  break;
 end;
end;

end;

procedure decrementa_recent_treeview_library;
var
nodo:pCmtVnode;
data:ares_types.precord_string;
begin

with ares_frmmain.treeview_lib_virfolders do begin
nodo := Getlast;
if nodo=nil then exit;

data := getdata(nodo);
dec(data^.counter);
Invalidatenode(nodo);
end;

end;

procedure mainGui_decsharedall;
var
nodo,nodoroot:pCmtVnode;
data:ares_types.precord_string;
begin
with ares_frmmain.treeview_lib_virfolders do begin

nodoroot := GetFirst;
if nodoroot=nil then exit;

nodo := getfirstchild(nodoroot);
if nodo=nil then exit;

data := getdata(nodo);
dec(data^.counter);
Invalidatenode(nodo);
end;

end;

procedure mainGui_delete_virviewentry(mimes,param1,param2,param3: string);
var
node,
noderoot,
node_param1,
node_param2,
node_param3,
node_comp:pCmtVnode;
dato,dato1:ares_types.precord_string;
begin

with ares_frmmain do begin
 with treeview_lib_virfolders do begin
 noderoot := GetFirst;
 if noderoot=nil then exit;

node := getfirstchild(noderoot);
if node=nil then exit;

if mimes='Audio' then begin
    node := getnextsibling(node);
    if node=nil then exit;
end else
if mimes='Image' then begin
    node := getnextsibling(node);
    if node=nil then exit;
    node := getnextsibling(node);
    if node=nil then exit;
end else
if mimes='Video' then begin
    node := getnextsibling(node);
    if node=nil then exit;
    node := getnextsibling(node);
    if node=nil then exit;
    node := getnextsibling(node);
    if node=nil then exit;
end else
if mimes='Document' then begin
     node := getnextsibling(node);
     if node=nil then exit;
     node := getnextsibling(node);
     if node=nil then exit;
     node := getnextsibling(node);
     if node=nil then exit;
     node := getnextsibling(node);
     if node=nil then exit;
end else
if mimes='Software' then begin
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
end else begin
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
      node := getnextsibling(node);
      if node=nil then exit;
end;

 dato := getdata(node);
 dec(dato^.counter);
  invalidatenode(node);


node_param1 := getfirstchild(node);
if node_param1=nil then exit;
end; //with listview...



if length(param1)=0 then param1 := GetLangStringA(STR_UNKNOWN);
node_comp := stringa_in_nodi_child(param1,treeview_lib_virfolders,node_param1);
if node_comp<>nil then begin
  dato1 := treeview_lib_virfolders.getdata(node_comp);
  dec(dato1^.counter);
  if dato1^.counter>0 then treeview_lib_virfolders.invalidatenode(node_comp)
  else treeview_lib_virfolders.Deletenode(node_comp);
end;


node_param2 := treeview_lib_virfolders.getnextsibling(node_param1);
if node_param2=nil then exit;

if length(param2)=0 then param2 := GetLangStringA(STR_UNKNOWN);
node_comp := stringa_in_nodi_child(param2,treeview_lib_virfolders,node_param2);
if node_comp<>nil then begin
  dato1 := treeview_lib_virfolders.getdata(node_comp);
  dec(dato1^.counter);
  if dato1^.counter>0 then treeview_lib_virfolders.invalidatenode(node_comp)
  else treeview_lib_virfolders.Deletenode(node_comp);
end;

node_param3 := treeview_lib_virfolders.getnextsibling(node_param2);
if node_param3=nil then exit;

if length(param3)=0 then param3 := GetLangStringA(STR_UNKNOWN);
node_comp := stringa_in_nodi_child(param3,treeview_lib_virfolders,node_param3);
if node_comp<>nil then begin
  dato1 := treeview_lib_virfolders.getdata(node_comp);
  dec(dato1^.counter);
  if dato1^.counter>0 then treeview_lib_virfolders.invalidatenode(node_comp)
  else treeview_lib_virfolders.Deletenode(node_comp);
end;
end; //with ares_frmmain
end;


procedure details_library_hideall;
begin
last_index_icona_details_library := 255;

with ares_frmmain do begin
 lbl_categ_detlib.visible := False;
 combocatlibrary.visible := False;
 edit_author.visible := False;
 lbl_author_detlib.visible := False;
 lbl_album_detlib.visible := False;
 edit_album.visible := False;
 edit_language.visible := False;
 lbl_language_detlib.visible := False;
 lbl_year_detlib.visible := False;
 edit_year.visible := False;

 chk_lib_fileshared.Visible := False;
 lbl_lib_fileshared.visible := False;
 lbl_folderlib_hint.visible := False;
 lbl_url_detlib.visible := False;
 lbl_title_detlib.visible := False;
 lbl_descript_detlib.visible := False;
 edit_url_library.visible := False;
 edit_title.visible := False;
 edit_description.visible := False;
end;
end;

procedure toggle_regularchatfolderbrowse_click(sender: Tobject);
begin
end;

procedure details_library_toggle(sshow:boolean);
begin
with ares_frmmain do begin
 lbl_title_detlib.visible := sshow;
 lbl_folderlib_hint.visible := sshow;
 lbl_descript_detlib.visible := sshow;
 lbl_url_detlib.visible := sshow;
 lbl_categ_detlib.visible := sshow;
 lbl_author_detlib.visible := sshow;
 if not sshow then lbl_album_detlib.visible := sshow;
 lbl_year_detlib.visible := sshow;
 lbl_language_detlib.visible := sshow;
 edit_year.visible := sshow;
 chk_lib_fileshared.visible := sshow;
 lbl_lib_fileshared.visible := sshow;
 edit_title.visible := sshow;
 edit_description.visible := sshow;
 edit_url_library.visible := sshow;
 combocatlibrary.visible := sshow;
 edit_author.visible := sshow;
 if not sshow then edit_album.visible := sshow;
 edit_year.visible := sshow;
 edit_language.visible := sshow;
end;
end;

procedure library_file_showdetails(hash_sha1: string);
var
filename: string;
i: Integer;
ffile:^record_file_library;
crcsha1: Word;
begin
with ares_frmmain do begin


crcsha1 := crcstring(hash_sha1);

for i := 0 to vars_global.lista_shared.count-1 do begin
try
ffile := vars_global.lista_shared[i];
if ffile^.crcsha1<>crcsha1 then continue;
if ffile^.hash_sha1<>hash_sha1 then continue;
    hash_select_in_library := hash_sha1;

   filename := ffile.path;

   lbl_folderlib_hint.caption := GetLangStringW(STR_FOLDER)+': '+
                               folder_id_to_folder_name(ffile^.folder_id,treeview_lib_regfolders);   //usiamo id!

     chk_lib_fileshared.checked := ffile^.shared;

     last_index_icona_details_library := aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(filename))));


     edit_title.text := utf8strtowidestr(ffile^.title);
     edit_description.text := utf8strtowidestr(ffile^.comment);
     edit_url_library.text := utf8strtowidestr(ffile^.url);

     case ffile^.amime of
     ARES_MIME_OTHER:begin
       details_library_toggle(true);
          combocatlibrary.visible := False;
           lbl_categ_detlib.Visible := False;
          edit_author.visible := False;
           lbl_author_detlib.visible := False;
          edit_album.visible := False;
           lbl_album_detlib.visible := False;
          edit_language.visible := False;
           lbl_language_detlib.visible := False;
          edit_year.visible := False;
           lbl_year_detlib.visible := False;
     end;

     ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2,ARES_MIME_IMAGE:begin  // audio e image
             
     details_library_toggle(true);
          lbl_album_detlib.visible := True;
          edit_album.visible := True;
          if ffile^.amime<>ARES_MIME_IMAGE then begin
           lbl_author_detlib.caption := GetLangStringW(STR_ARTIST);
           lbl_categ_detlib.caption := GetLangStringW(STR_GENRE);
          end else begin
           lbl_author_detlib.caption := GetLangStringW(STR_AUTHOR);
           lbl_categ_detlib.caption := GetLangStringW(STR_CATEGORY);
          end;
          lbl_categ_detlib.left := (combocatlibrary.left-lbl_categ_detlib.width)-2;
          lbl_author_detlib.left := (edit_author.left-lbl_author_detlib.width)-2;

            if ffile^.amime=ARES_MIME_IMAGE then combo_add_categories(combocatlibrary,7)
             else combo_add_categories(combocatlibrary,1);

      with combocatlibrary do if items.indexof(ffile.category)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile.category))
        else itemindex := 0;
     edit_author.text := utf8strtowidestr(ffile.Artist);
     edit_album.text := utf8strtowidestr(ffile.album);
     edit_year.text := utf8strtowidestr(ffile.year);


      edit_year.left := edit_author.left;
      lbl_year_detlib.top := lbl_language_detlib.top;
      edit_year.width := edit_author.width;
      edit_year.top := edit_language.top;
      lbl_year_detlib.left := (edit_year.left-lbl_year_detlib.width)-2;
      lbl_language_detlib.visible := False;
      edit_language.visible := falsE;

     end;

     ARES_MIME_SOFTWARE:begin  // software
     details_library_toggle(true);
          lbl_album_detlib.visible := False;
          edit_album.visible := False;

          lbl_author_detlib.caption := GetLangStringW(STR_COMPANY);
          lbl_categ_detlib.caption := GetLangStringW(STR_CATEGORY);
          lbl_categ_detlib.left := (combocatlibrary.left-lbl_categ_detlib.width)-2;
          lbl_author_detlib.left := (edit_author.left-lbl_author_detlib.width)-2;

        combo_add_categories(combocatlibrary,3);
      with combocatlibrary do if items.indexof(ffile.category)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile.category))
       else itemindex := 0;
     edit_author.text := utf8strtowidestr(ffile.Artist);
     edit_year.text := utf8strtowidestr(ffile.year);
     edit_language.width := ares_frmmain.edit_author.width;
     if edit_language.items.count=0 then combo_add_languages(edit_language);
        with edit_language do if items.indexof(ffile.language)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile.language))
           else itemindex := 0;
           edit_language.width := edit_album.width;
           edit_year.width := edit_album.width;
           edit_year.left := edit_author.left;
           lbl_year_detlib.left := (edit_year.left-lbl_year_detlib.width)-2;
           lbl_year_detlib.top := lbl_album_detlib.top;
           edit_year.top := edit_album.top;
     end;
     
     ARES_MIME_VIDEO:begin  // video
     details_library_toggle(true);
          lbl_album_detlib.visible := False;
          edit_album.visible := False;
          lbl_author_detlib.caption := GetLangStringW(STR_AUTHOR);
          lbl_categ_detlib.caption := GetLangStringW(STR_CATEGORY);
          lbl_categ_detlib.left := (combocatlibrary.left-lbl_categ_detlib.width)-2;
          lbl_author_detlib.left := (edit_author.left-lbl_author_detlib.width)-2;

           combo_add_categories(combocatlibrary,5);
      with combocatlibrary do if items.indexof(ffile^.category)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile^.category))
       else itemindex := 0;
       edit_author.text := utf8strtowidestr(ffile^.Artist);
       edit_language.width := ares_frmmain.edit_author.width;
       if ares_frmmain.edit_language.items.count=0 then combo_add_languages(ares_frmmain.edit_language);
          with edit_language do if items.indexof(ffile.language)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile^.language))
             else itemindex := 0;
             edit_year.text := utf8strtowidestr(ffile^.year);
             edit_language.width := edit_album.width;
             edit_year.width := edit_album.width;
             edit_year.left := edit_author.left;
             lbl_year_detlib.left := (edit_year.left-lbl_year_detlib.width)-2;
             lbl_year_detlib.top := lbl_album_detlib.top;
             edit_year.top := edit_album.top;
     end;

     ARES_MIME_DOCUMENT:begin  // document
     details_library_toggle(true);
          lbl_album_detlib.visible := False;
          edit_album.visible := False;
          lbl_author_detlib.caption := GetLangStringW(STR_AUTHOR);
          lbl_categ_detlib.caption := GetLangStringW(STR_CATEGORY);
          lbl_categ_detlib.left := (combocatlibrary.left-lbl_categ_detlib.width)-2;
          lbl_author_detlib.left := (edit_author.left-lbl_author_detlib.width)-2;
               combo_add_categories(combocatlibrary,6);
         with combocatlibrary do if items.indexof(ffile.category)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile.category))
          else itemindex := 0;
          edit_author.text := utf8strtowidestr(ffile.Artist);
          edit_language.width := edit_author.width;
          if edit_language.items.count=0 then combo_add_languages(edit_language);
         with edit_language do if items.indexof(ffile.language)<>-1 then itemindex := items.indexof(utf8strtowidestr(ffile.language))
           else itemindex := 0;
           edit_language.width := edit_album.width;
           edit_year.width := edit_album.width;
           edit_year.left := edit_author.left;
           lbl_year_detlib.top := lbl_album_detlib.top;
           lbl_year_detlib.left := (edit_year.left-lbl_year_detlib.width)-2;
           edit_year.top := edit_album.top;
           edit_year.text := utf8strtowidestr(ffile.year);
     end;

     end;
     
 if btn_lib_toggle_details.Down then ufrmmain.ares_frmmain.libraryOnResize(ares_frmmain.listview_lib.parent);
 break;

except
end;
end;


end;
end;

function folder_id_to_folder_name(folder_id: Word; tree: Tcomettree): WideString;
var
folder:precord_cartella_share;
nodo:pCmtVnode;
begin
result := '';

with tree do begin
 nodo := getfirst;
 if nodo=nil then exit;


 repeat
  nodo := getnext(nodo);
  if nodo=nil then exit;
   folder := getdata(nodo);

     if folder^.id=folder_id then begin
      Result := folder^.path;
      exit;
     end;
  until (not true);

end;
end;

function folder_id_to_folder_displayname(folder_id: Word; tree: Tcomettree): string;
var
folder:precord_cartella_share;
nodo:pCmtVnode;
begin
result := '';

with tree do begin
 nodo := getfirst;
 if nodo=nil then exit;


 repeat
  nodo := getnext(nodo);
  if nodo=nil then exit;
   folder := getdata(nodo);

     if folder^.id=folder_id then begin
      Result := folder^.display_path;
      exit;
     end;
  until (not true);
end;

end;

function stringa_in_nodi_child(stringa: string; tree: TcometTree; nodoparent:pCmtVnode):pCmtVnode;
var
nodo:pCmtVnode;
data:precord_string;
stringalo: string;
begin
result := nil;
stringalo := lowercase(stringa);

with tree do begin
nodo := getfirstchild(nodoparent);

repeat
if nodo=nil then exit;
 data := getdata(nodo);
  if lowercase(data^.str)=stringalo then begin
   Result := nodo;
   exit;
  end;

nodo := getnextsibling(nodo);
until (nodo=nil);

end;

end;

procedure free_virfolders_entries(list: TMylist);
var
records:precord_string;
begin

while (list.count>0) do begin
  records := list[list.count-1];
           list.delete(list.count-1);
   records.str := '';
  FreeMem(records,sizeof(ares_types.record_string));
end;

list.Free;
end;

procedure add_virfolders_entry(list: TMylist; const stringain: string);
var
records:precord_string;
i: Integer;
strin: string;
crccomp: Word;
begin

strin := lowercase(copy(stringaIn,1,length(stringaIn)));
crccomp := stringcrc(strin,true); //crc lowercase

for i := 0 to list.count-1 do begin
 records := list[i];
  if records^.crc<>crccomp then continue;
   if lowercase(records^.str)<>strin then continue;
    inc(records^.counter);
   strin := '';
   exit;
end;



records := AllocMem(sizeof(record_string));
with records^ do begin
 str := copy(stringaIn,1,length(stringaIn));
 counter := 1;
 crc := crccomp;
end;
list.add(records);

strin := '';
end;



procedure add_base_virtualnodes(tree: Tcomettree; includerecent:boolean);
var
nodo,nodo_child,nodo_child_ordinamento:pCmtVnode;
data:ares_types.precord_string;
begin
with tree do begin
beginupdate;
clear_treeview(tree,false);


 nodo := addchild(nil);
 data := GetData(nodo);
 with data^ do begin
  str := GetLangStringA(STR_SHARED_VIRTUAL_FOLDERS);
  counter := 0;
 end;

nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_ALL);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_AUDIO);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_ARTIST);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_ALBUM);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_GENRE);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_IMAGE);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_ALBUM);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_CATEGORY);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_VIDEO);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_CATEGORY);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_DOCUMENT);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_AUTHOR);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_CATEGORY);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_SOFTWARE);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_COMPANY);
  counter := 0;
 end;

 nodo_child_ordinamento := addchild(nodo_child);
 data := GetData(nodo_child_ordinamento);
 with data^ do begin
  str := GetLangStringA(STR_GROUP_BY_CATEGORY);
  counter := 0;
 end;

 nodo_child := addchild(nodo);
 data := GetData(nodo_child);
 with data^ do begin
  str := GetLangStringA(STR_OTHER);
  counter := 0;
 end;

if includerecent then begin
  nodo_child := addchild(nodo);
   data := GetData(nodo_child);
   with data^ do begin
    str := GetLangStringA(STR_RECENT_DOWNLOADS);
    counter := 0;
   end;
end;

FullExpand;
endupdate;
end;
end;

procedure apri_general_library_folder_view(showshared: Boolean; lista_files: TMylist; listview: Tcomettree; imagelist_lib_max: Timagelist; treeview2: Tcomettree);
var
nodo_root,nodo,nodo_child,nodo_new:pCmtVnode;
cartella_main,cartella_child:precord_cartella_share;
bytes_shared: Int64;
bytes_available: Int64;
files_available,files_shared: Cardinal;
h: Integer;
pfile:precord_file_library;
data:precord_file_library;
percent_all:double;
calcolatore:double;
level: Cardinal;
bytes_shared_str,bytes_available_str: string;
begin
nodo_root := treeview2.getfirst;
if nodo_root=nil then exit;

with listview do begin
 canbgcolor := False;
 beginupdate;
 clear;
 defaultnodeheight := 34;
 images := imagelist_lib_max;
  with header do begin
   height := 34;
   Options := [hoAutoResize,hoColumnResize,hoDrag,hoRestrictDrag,hoShowImages{,hoVisible}];
   autosizeindex := 0;
   columns[10].width := 0;
   columns[0].options := [coEnabled,coResizable,coVisible];
   columns[0].width := listview.width-2;
  end;
end;

nodo := treeview2.getfirstchild(nodo_root);
while (nodo<>nil) do begin

   level := treeview2.getnodelevel(nodo);
   cartella_main := treeview2.getdata(nodo);
    bytes_shared := 0;
    bytes_available := 0;
    files_shared := 0;
    files_available := 0;

     if cartella_main^.items>0 then begin
        for h := 0 to lista_files.count-1 do begin
          pfile := lista_files[h];
           if pfile^.folder_id<>cartella_main^.id then continue;
             if pfile^.shared then begin
                                  inc(bytes_shared,pfile^.fsize);
                                  inc(files_shared);
                                  end;
             inc(bytes_available,pfile^.fsize);
             inc(files_available);
        end;
     end;

       nodo_child := treeview2.getfirstchild(nodo);
       while (nodo_child<>nil) do begin

          if treeview2.getnodelevel(nodo_child)<=level then break;

            cartella_child := treeview2.getdata(nodo_child);
            if cartella_child^.items=0 then begin
             nodo_child := treeview2.getnext(nodo_child);
             continue;
            end;

             for h := 0 to lista_files.count-1 do begin
              pfile := lista_files[h];
               if pfile^.folder_id<>cartella_child^.id then continue;
                if pfile^.shared then begin
                                     inc(bytes_shared,pfile^.fsize);
                                     inc(files_shared);
                                     end;
                inc(bytes_available,pfile^.fsize);
                inc(files_available);
             end;
          nodo_child := treeview2.getnext(nodo_child);
        end;

          if bytes_shared>0 then bytes_shared := bytes_shared div KBYTE;  //trasformiamo in kb
          if bytes_available>0 then bytes_available := bytes_available div KBYTE;
        
         nodo_new := listview.AddChild(nil);
          data := listview.GetData(nodo_new);
          with data^ do begin
           shared := False;
           imageindex := 0;
           path := '';
           hash_sha1 := '';
          end;
           if files_available>0 then begin
            percent_all := files_shared;
            percent_all := percent_all/files_available;
            percent_all := percent_all*100;
          end else percent_all := 0;

            if bytes_shared> KBYTE then begin
              calcolatore := bytes_shared;
              calcolatore := calcolatore / KBYTE;
               if calcolatore>10 then bytes_shared_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
                else bytes_shared_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
            end else bytes_shared_str := inttostr(bytes_shared)+STR_KB;

           if bytes_available> KBYTE then begin
            calcolatore := bytes_available;
            calcolatore := calcolatore / KBYTE;
              if calcolatore>10 then bytes_available_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
               else bytes_available_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
            end else bytes_available_str := inttostr(bytes_available)+STR_KB;


       if showshared then data^.title := widestrtoutf8str(extract_fnameW(cartella_main^.path))+'  '+inttostr(files_available)+' '+GetLangStringA(STR_FOUND)+' ('+bytes_available_str+') , '+inttostr(round(percent_all))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(files_shared)+' '+GetLangStringA(STR_FILES)+', '+bytes_shared_str+')'
         else data^.title := widestrtoutf8str(extract_fnameW(cartella_main^.path))+'  '+inttostr(files_available)+' '+GetLangStringA(STR_FOUND)+' ('+bytes_available_str+')';


            with data^ do begin
              artist := widestrtoutf8str(cartella_main^.path);
              category := inttostr(files_available)+' '+GetLangStringA(STR_FOUND);
              album := GetLangStringA(STR_TOTAL_SIZE)+': '+bytes_available_str;
              year := inttostr(round(percent_all))+'% '+GetLangStringA(STR_SHARED_PLUR);
            end;

nodo := treeview2.getnextsibling(nodo);
end;

 listview.endupdate;

end;

procedure apri_general_library_virtual_view(showshared: Boolean; lista_files: TMylist; listview: Tcomettree; imagelist_lib_max: Timagelist);
var
i: Integer;
node:pCmtVnode;
datao:precord_file_library;
pfile:precord_file_library;
shared_all_bytes,shared_audio_bytes,shared_video_bytes,
shared_image_bytes,shared_document_bytes,shared_software_bytes,shared_other_bytes: Int64;
my_shared_all_count,my_shared_audio_count,my_shared_video_count,
my_shared_image_count,my_shared_document_count,my_shared_software_count,my_shared_other_count: Integer;
real_shared_all_bytes,real_shared_audio_bytes,real_shared_video_bytes,
real_shared_image_bytes,real_shared_document_bytes,real_shared_software_bytes,real_shared_other_bytes: Int64;
my_real_shared_all_count,my_real_shared_audio_count,my_real_shared_video_count,
my_real_shared_image_count,my_real_shared_document_count,my_real_shared_software_count,my_real_shared_other_count: Integer;
percent_all,percent_audio,percent_image,percent_video,percent_document,percent_software,percent_other:double;
size_all_str,size_real_str: string;
calcolatore:double;
begin
try
 shared_all_bytes := 0;
 my_shared_all_count := 0;
 shared_audio_bytes := 0;
 my_shared_audio_count := 0;
 shared_video_bytes := 0;
 my_shared_video_count := 0;
 shared_image_bytes := 0;
 my_shared_image_count := 0;
 shared_document_bytes := 0;
 my_shared_document_count := 0;
  shared_software_bytes := 0;
 my_shared_software_count := 0;
 shared_other_bytes := 0;
 my_shared_other_count := 0;

  real_shared_all_bytes := 0;
 my_real_shared_all_count := 0;
 real_shared_audio_bytes := 0;
 my_real_shared_audio_count := 0;
 real_shared_video_bytes := 0;
 my_real_shared_video_count := 0;
 real_shared_image_bytes := 0;
 my_real_shared_image_count := 0;
 real_shared_document_bytes := 0;
 my_real_shared_document_count := 0;
  real_shared_software_bytes := 0;
 my_real_shared_software_count := 0;
 real_shared_other_bytes := 0;
 my_real_shared_other_count := 0;



 for i := 0 to lista_files.count-1 do begin
  pfile := lista_files[i];
  inc(my_shared_all_count);
  inc(shared_all_bytes,pfile^.fsize);
   if pfile^.shared then begin
      inc(my_real_shared_all_count);
      inc(real_shared_all_bytes,pfile^.fsize);
   end;

  case pfile^.amime of
   ARES_MIME_OTHER:begin
           inc(my_shared_other_count);
           inc(shared_other_bytes,pfile^.fsize);
           if pfile^.shared then begin
            inc(my_real_shared_other_count);
            inc(real_shared_other_bytes,pfile^.fsize);
           end;
   end;
   ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
          inc(my_shared_audio_count);
          inc(shared_audio_bytes,pfile^.fsize);
           if pfile^.shared then begin
            inc(my_real_shared_audio_count);
            inc(real_shared_audio_bytes,pfile^.fsize);
           end;
         end;
   ARES_MIME_SOFTWARE:begin
            inc(my_shared_software_count);
            inc(shared_software_bytes,pfile^.fsize);
            if pfile^.shared then begin
             inc(my_real_shared_software_count);
             inc(real_shared_software_bytes,pfile^.fsize);
           end;
     end;
   ARES_MIME_VIDEO:begin
            inc(my_shared_video_count);
            inc(shared_video_bytes,pfile^.fsize);
             if pfile^.shared then begin
              inc(my_real_shared_video_count);
              inc(real_shared_video_bytes,pfile^.fsize);
             end;
     end;
   ARES_MIME_DOCUMENT:begin
            inc(my_shared_document_count);
            inc(shared_document_bytes,pfile^.fsize);
           if pfile^.shared then begin
            inc(my_real_shared_document_count);
            inc(real_shared_document_bytes,pfile^.fsize);
           end;
     end;
   ARES_MIME_IMAGE:begin
        inc(my_shared_image_count);
        inc(shared_image_bytes,pfile^.fsize);
            if pfile^.shared then begin
            inc(my_real_shared_image_count);
            inc(real_shared_image_bytes,pfile^.fsize);
           end;
     end;
  end;
 end;




 ///////////////////
  if shared_all_bytes>0 then shared_all_bytes := shared_all_bytes div KBYTE;
  if shared_audio_bytes>0 then shared_audio_bytes := shared_audio_bytes div KBYTE;
  if shared_image_bytes>0 then shared_image_bytes := shared_image_bytes div KBYTE;
  if shared_video_bytes>0 then shared_video_bytes := shared_video_bytes div KBYTE;
  if shared_document_bytes>0 then shared_document_bytes := shared_document_bytes div KBYTE;
  if shared_other_bytes>0 then shared_other_bytes := shared_other_bytes div KBYTE;
  if shared_software_bytes>0 then shared_software_bytes := shared_software_bytes div KBYTE;

  if real_shared_all_bytes>0 then real_shared_all_bytes := real_shared_all_bytes div KBYTE;
  if real_shared_audio_bytes>0 then real_shared_audio_bytes := real_shared_audio_bytes div KBYTE;
  if real_shared_image_bytes>0 then real_shared_image_bytes := real_shared_image_bytes div KBYTE;
  if real_shared_video_bytes>0 then real_shared_video_bytes := real_shared_video_bytes div KBYTE;
  if real_shared_document_bytes>0 then real_shared_document_bytes := real_shared_document_bytes div KBYTE;
  if real_shared_other_bytes>0 then real_shared_other_bytes := real_shared_other_bytes div KBYTE;
  if real_shared_software_bytes>0 then real_shared_software_bytes := real_shared_software_bytes div KBYTE;

 with listview do begin
  canbgcolor := False;
  beginupdate;
  clear;

  defaultnodeheight := 34;
  images := imagelist_lib_max;
  with header do begin
   height := 34;
   Options := [hoAutoResize,hoColumnResize,hoDrag,hoRestrictDrag,hoShowImages{,hoVisible}];
   autosizeindex := 0;
   columns[10].width := 0;
   columns[0].options := [coEnabled,coResizable,coVisible];
   columns[0].width := listview.width-2;
  end;

 node := AddChild(nil);
 datao := GetData(node);
 end;



 with datao^ do begin
  shared := False;
  imageindex := 0;
  path := '';
  hash_sha1 := '';
 end;
 
 if my_shared_all_count>0 then begin
 percent_all := my_real_shared_all_count;
 percent_all := percent_all/my_shared_all_count;
 percent_all := percent_all*100;
 end else percent_all := 0;

 if shared_all_bytes> KBYTE then begin
  calcolatore := shared_all_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_all_bytes)+STR_KB;
 end;
 if real_shared_all_bytes> KBYTE then begin
  calcolatore := real_shared_all_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_all_bytes)+STR_KB;
 end;

 if showshared then datao^.title := GetLangStringA(STR_ALL)+': '+inttostr(my_shared_all_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_all))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_all_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
  else datao^.title := GetLangStringA(STR_ALL)+': '+inttostr(my_shared_all_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

  with datao^ do begin
   artist := GetLangStringA(STR_ALL)+': '+inttostr(my_shared_all_count)+' '+GetLangStringA(STR_FOUND);
   category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
   album := inttostr(round(percent_all))+'% '+GetLangStringA(STR_SHARED_PLUR);
   year := inttostr(my_real_shared_all_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
  end;

 node := listview.AddChild(nil);
 datao := listview.GetData(node);
  with datao^ do begin
   shared := False;
  imageindex := 1;
   path := '';
  hash_sha1 := '';
 end;

 if my_shared_audio_count>0 then begin
  percent_audio := my_real_shared_audio_count;
 percent_audio := percent_audio/my_shared_audio_count;
 percent_audio := percent_audio*100;
 end else percent_audio := 0;

 if shared_audio_bytes> KBYTE then begin
  calcolatore := shared_audio_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_audio_bytes)+STR_KB;
 end;
  if real_shared_audio_bytes> KBYTE then begin
  calcolatore := real_shared_audio_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_audio_bytes)+STR_KB;
 end;

  if showshared then datao^.title := GetLangStringA(STR_AUDIO)+': '+inttostr(my_shared_audio_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_audio))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+ inttostr(my_real_shared_audio_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
   else datao^.title := GetLangStringA(STR_AUDIO)+': '+inttostr(my_shared_audio_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

 with datao^ do begin
  artist := GetLangStringA(STR_AUDIO)+': '+inttostr(my_shared_audio_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_audio))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_audio_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;


   node := listview.AddChild(nil);
 datao := listview.GetData(node);
  with datao^ do begin
   shared := False;
  imageindex := 2;
  path := '';
  hash_sha1 := '';
  end;

 if my_shared_image_count>0 then begin
   percent_image := my_real_shared_image_count;
 percent_image := percent_image/my_shared_image_count;
 percent_image := percent_image*100;
 end else percent_image := 0;

  if shared_image_bytes> KBYTE then begin
  calcolatore := shared_image_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_image_bytes)+STR_KB;
 end;
   if real_shared_image_bytes> KBYTE then begin
  calcolatore := real_shared_image_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_image_bytes)+STR_KB;
 end;

   if showshared then datao^.title := GetLangStringA(STR_IMAGE)+': '+inttostr(my_shared_image_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_image))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_image_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
   else datao^.title := GetLangStringA(STR_IMAGE)+': '+inttostr(my_shared_image_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

 with datao^ do begin
  artist := GetLangStringA(STR_IMAGE)+': '+inttostr(my_shared_image_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_image))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_image_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;


  node := listview.AddChild(nil);
 datao := listview.GetData(node);
 with datao^ do begin
   shared := False;
  imageindex := 3;
   path := '';
  hash_sha1 := '';
 end;

 if my_shared_video_count>0 then begin
    percent_video := my_real_shared_video_count;
 percent_video := percent_video/my_shared_video_count;
 percent_video := percent_video*100;
 end else percent_video := 0;

  if shared_video_bytes> KBYTE then begin
  calcolatore := shared_video_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_video_bytes)+STR_KB;
 end;
 if real_shared_video_bytes> KBYTE then begin
  calcolatore := real_shared_video_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_video_bytes)+STR_KB;
 end;

    if showshared then datao^.title := GetLangStringA(STR_VIDEO)+': '+inttostr(my_shared_video_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_video))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_video_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
     else datao^.title := GetLangStringA(STR_VIDEO)+': '+inttostr(my_shared_video_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

 with datao^ do begin
  artist := GetLangStringA(STR_VIDEO)+': '+inttostr(my_shared_video_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_video))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_video_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;



  node := listview.AddChild(nil);
 datao := listview.GetData(node);
  with datao^ do begin
   shared := False;
  imageindex := 4;
   path := '';
  hash_sha1 := '';
  end;

 if my_shared_document_count>0 then begin
     percent_document := my_real_shared_document_count;
 percent_document := percent_document/my_shared_document_count;
 percent_document := percent_document*100;
 end else percent_document := 0;

  if shared_document_bytes> KBYTE then begin
  calcolatore := shared_document_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_document_bytes)+STR_KB;
 end;
   if real_shared_document_bytes> KBYTE then begin
  calcolatore := real_shared_document_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_document_bytes)+STR_KB;
 end;

   if showshared then datao^.title := GetLangStringA(STR_DOCUMENT)+': '+inttostr(my_shared_document_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_document))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_document_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
    else datao^.title := GetLangStringA(STR_DOCUMENT)+': '+inttostr(my_shared_document_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

 with datao^ do begin
  artist := GetLangStringA(STR_DOCUMENT)+': '+inttostr(my_shared_document_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_document))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_document_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;



  node := listview.AddChild(nil);
 datao := listview.GetData(node);
  with datao^ do begin
   shared := False;
  imageindex := 5;
   path := '';
  hash_sha1 := '';
  end;

 if my_shared_software_count>0 then begin
      percent_software := my_real_shared_software_count;
 percent_software := percent_software/my_shared_software_count;
 percent_software := percent_software*100;
 end else percent_software := 0;

  if shared_software_bytes> KBYTE then begin
  calcolatore := shared_software_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_software_bytes)+STR_KB;
 end;
   if real_shared_software_bytes> KBYTE then begin
  calcolatore := real_shared_software_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_software_bytes)+STR_KB;
 end;

    if showshared then datao^.title := GetLangStringA(STR_SOFTWARE)+': '+inttostr(my_shared_software_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_software))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_software_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
     else datao^.title := GetLangStringA(STR_SOFTWARE)+': '+inttostr(my_shared_software_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';

 with datao^ do begin
  artist := GetLangStringA(STR_SOFTWARE)+': '+inttostr(my_shared_software_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_software))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_software_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;


  node := listview.AddChild(nil);
 datao := listview.GetData(node);
  with datao^ do begin
   shared := False;
  imageindex := 6;
   path := '';
  hash_sha1 := '';
  end;

 if my_shared_other_count>0 then begin
       percent_other := my_real_shared_other_count;
 percent_other := percent_other/my_shared_other_count;
 percent_other := percent_other*100;
 end else percent_other := 0;

  if shared_other_bytes> KBYTE then begin
  calcolatore := shared_other_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_all_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_all_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_all_str := inttostr(shared_other_bytes)+STR_KB;
 end;
   if real_shared_other_bytes> KBYTE then begin
  calcolatore := real_shared_other_bytes;
  calcolatore := calcolatore / KBYTE;
    if calcolatore>10 then
     size_real_str := floattostrF(calcolatore,ffNumber,18,1)+STR_MB
    else
     size_real_str := floattostrF(calcolatore,ffNumber,18,2)+STR_MB;
 end else begin
  size_real_str := inttostr(real_shared_other_bytes)+STR_KB;
 end;

     if showshared then datao^.title := GetLangStringA(STR_OTHER)+': '+inttostr(my_shared_other_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+') , '+inttostr(round(percent_other))+'% '+GetLangStringA(STR_SHARED_PLUR)+' ('+inttostr(my_real_shared_other_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str+')'
      else datao^.title := GetLangStringA(STR_OTHER)+': '+inttostr(my_shared_other_count)+' '+GetLangStringA(STR_FOUND)+' ('+size_all_str+')';
 with datao^ do begin
  artist := GetLangStringA(STR_OTHER)+': '+inttostr(my_shared_other_count)+' '+GetLangStringA(STR_FOUND);
  category := GetLangStringA(STR_TOTAL_SIZE)+': '+size_all_str;
  album := inttostr(round(percent_other))+'% '+GetLangStringA(STR_SHARED_PLUR);
  year := inttostr(my_real_shared_other_count)+' '+GetLangStringA(STR_FILES)+', '+size_real_str;
 end;


  listview.endupdate;
  //listview.color := COLORE_LISTVIEWS_BG;

 except
 end;
end;

procedure library_file_show(tree: Tcomettree; pfile:precord_file_library);
var
nuovo_nodo:pCmtVnode;
nodedata:precord_file_library;
begin
try
     nuovo_nodo := tree.AddChild(nil);
      NodeData := tree.GetData(nuovo_nodo);
      with nodedata^ do begin
       path := pfile^.path;
       previewing := pfile^.previewing;
       hash_sha1 := pfile^.hash_sha1;
       crcsha1 := pfile^.crcsha1;
       shared := pfile^.shared;
       downloaded := pfile^.downloaded;
       being_downloaded := pfile^.being_downloaded;
       already_in_lib := pfile^.already_in_lib;
       filedate := pfile^.filedate;
       folder_id := pfile^.folder_id;
       fsize := pfile^.fsize;
       title := pfile^.title;
       album := pfile^.album;
       artist := pfile^.artist;
       vidinfo := pfile^.vidinfo;
        if lowercase(pfile^.category)=GetLangStringA(STR_UNKNOW_LOWER) then category := ''
        else category := pfile^.category;
       comment := pfile^.comment;
       param1 := pfile^.param1;
       param2 := pfile^.param2;
       param3 := pfile^.param3;
       amime := pfile^.amime;
       year := pfile^.year;
       keywords_genre := pfile^.keywords_genre;
         being_downloaded := (is_in_progress_sha1(pfile^.hash_sha1));
         already_in_lib := (is_in_lib_sha1(pfile^.hash_sha1));

        if tree<>ares_FrmMain.listview_lib then downloaded := pfile^.downloaded
         else downloaded := False;

       language := pfile^.language;
       mediatype := mediatype_to_str(pfile^.amime);
       imageindex := amime_to_imgindexsmall(pfile^.amime);
     end;
except
end;
end;

procedure cancella_cartella_per_treeview2(folder:precord_cartella_share);
var
next:precord_cartella_share;
begin
try


 while (folder<>nil) do begin
   if folder^.first_child<>nil then cancella_cartella_per_treeview2(folder^.first_child);
    nexT := folder^.next;
     with folder^ do begin
      path := '';
      path_utf8 := '';
     end;
     FreeMem(folder,sizeof(record_cartella_share));
    folder := next;
 end;

 except
 end;

end;

function trova_nodo_treeview1_categoria(tree: Tcomettree; rawcat: string):pCmtVnode;
var
node,noderoot:pCmtVnode;
cicles,i: Byte;
begin
result := nil;

with tree do begin
 noderoot := GetFirst;

 if pos(GetLangStringA(STR_ALL),rawcat)=1 then begin //all files
  Result := GetFirstChild(noderoot);
  exit;
 end;


if pos(GetLangStringA(STR_AUDIO),rawcat)=1 then cicles := 1 else
 if pos(GetLangStringA(STR_IMAGE),rawcat)=1 then cicles := 2 else
  if pos(GetLangStringA(STR_VIDEO),rawcat)=1 then cicles := 3 else
   if pos(GetLangStringA(STR_DOCUMENT),rawcat)=1 then cicles := 4 else
    if pos(GetLangStringA(STR_SOFTWARE),rawcat)=1 then cicles := 5 else
     cicles := 6;

 node := GetFirstChild(noderoot);
 for i := 1 to cicles do
  if i<>cicles then node := getnextsibling(node)
   else Result := getnextsibling(node)

end;

end;


function trova_nodo_treeview2_folder(listview: Tcomettree; tree: Tcomettree):pCmtVnode;
var
nodo_selected,nodo:pCmtVnode;
i,attuale: Integer;
data:precord_file_library;
data_treeview:precord_cartella_share;
path_wide: WideString;
begin
result := nil;

nodo_selected := listview.getfirstselected;
 if nodo_selected=nil then exit;
 data := listview.getdata(nodo_selected);
  path_wide := utf8strtowidestr(data^.language);

 if ((data^.imageindex=0) and (listview.header.height<34)) then begin  //una folder in visione regolare (japanese)

   nodo := tree.getfirst;  //first non può essere
   if nodo=nil then exit;

   nodo := tree.getfirstchild(nodo);
    while (nodo<>nil) do begin
        data_treeview := tree.getdata(nodo);
         if data_treeview^.path=path_wide then begin //stesso path, bingo
             Result := nodo;
             exit;
         end;
    nodo := tree.getnext(nodo);
    end;

 end else begin


nodo := listview.getfirst;
 if nodo=nil then exit;

i := 0;
repeat
  if nodo=nodo_selected then break;
 nodo := listview.GetNextsibling(nodo);
 if nodo=nil then exit;
 inc(i);
until (not true);


//ok ho trovato index, su treeview2 sarà stesso index+1

nodo := tree.getfirst;  //first non può essere
if nodo=nil then exit;

nodo := tree.getfirstchild(nodo);
if nodo=nil then exit;

 attuale := 0;
repeat
 if attuale=i then begin
  Result := nodo;
  exit;
 end;

 nodo := tree.getnextsibling(nodo);
 if nodo=nil then exit;
 inc(attuale);
until (not true);

 end;

end;

function apri_categoria_library(regname1,regname2: string; tree: Tcomettree; listview: Tcomettree; lista_files_utente: TMylist; level: Integer; node:pCmtVnode): Tstato_library_header;
var
i: Integer;
ffile:precord_file_library;
match,match1,match2,match3: string;
data:ares_types.precord_string;
nodeaudio,nodevideo,nodeimage,nodeother,nodeall,nodedocument,nodesoftware,noderoot,
naudiogbyartist,naudiogbygenre,naudiogbyalbum,noderecent,
nvideogbycategory,
nimagegbyalbum,nimagegbycategory,
ndocumentgbyauthor,ndocumentgbycategory,
nsoftwaregbycompany,nsoftwaregbycategory:pCmtVnode;
//nodecmp:pCmtVnode;
catbyte: Byte;
begin
try
 with listview do begin
   canbgcolor := True;
   defaultnodeheight := 18;
   images := ares_FrmMain.img_mime_small;
   with header do begin
    height := 21;
    autosizeindex := 10;
    options := [hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];
    columns[0].options := [coAllowClick,coEnabled,coDraggable,coResizable,coShowDropMark,coVisible];
   end;
      if rootnodecount>0 then begin
       BeginUpdate;
       Clear;
      end;
 end;


 with tree do begin
 noderoot := getfirst;
   nodeall := getfirstchild(noderoot);
   nodeaudio := getnextsibling(nodeall);
     naudiogbyartist := getfirstchild(nodeaudio);
     naudiogbyalbum := GetNextSibling(naudiogbyartist);
     naudiogbygenre := GetNextSibling(naudiogbyalbum);
   nodeimage := GetNextSibling(nodeaudio);
     nimagegbyalbum := getfirstchild(nodeimage);
     nimagegbycategory := getnextsibling(nimagegbyalbum);
   nodevideo := getnextsibling(nodeimage);
     nvideogbycategory := getfirstchild(nodevideo);
   nodedocument := getnextsibling(nodevideo);
     ndocumentgbyauthor := getfirstchild(nodedocument);
     ndocumentgbycategory := getnextsibling(ndocumentgbyauthor);
   nodesoftware := getnextsibling(nodedocument);
     nsoftwaregbycompany := getfirstchild(nodesoftware);
     nsoftwaregbycategory := getnextsibling(nsoftwaregbycompany);
   nodeother := getnextsibling(nodesoftware);
  end;

  if level=1 then begin

   noderecent := tree.getnextsibling(nodeother);

    if node=nodeall then catbyte := CAT_ALL else
     if node=nodeaudio then catbyte := CAT_AUDIO else
      if node=nodevideo then catbyte := CAT_VIDEO else
       if node=nodeimage then catbyte := CAT_IMAGE else
        if node=nodedocument then catbyte := CAT_DOCUMENT else
         if node=nodesoftware then catbyte := CAT_SOFTWARE else
          if node=nodeother then catbyte := CAT_OTHER else
           if node=noderecent then catbyte := CAT_RECENT else catbyte := CAT_ALL;
           Result := header_library_show(regname1,regname2,listview,'',catbyte,CAT_NOGROUP);


    for i := 0 to lista_files_utente.count-1 do begin
    ffile := lista_files_utente[i];
      if node=nodeall then library_file_show(listview,ffile) else begin
       if ((node=nodeaudio) and ((ffile^.amime=ARES_MIME_MP3) or (ffile^.amime=ARES_MIME_AUDIOOTHER1) or (ffile^.amime=ARES_MIME_AUDIOOTHER2))) then library_file_show(listview,ffile) else
       if ((node=nodesoftware) and (ffile^.amime=ARES_MIME_SOFTWARE)) then library_file_show(listview,ffile) else
       if ((node=nodevideo) and (ffile^.amime=ARES_MIME_VIDEO)) then library_file_show(listview,ffile) else
       if ((node=nodedocument) and (ffile^.amime=ARES_MIME_DOCUMENT)) then library_file_show(listview,ffile) else
       if ((node=nodeimage) and (ffile^.amime=ARES_MIME_IMAGE)) then library_file_show(listview,ffile) else
       if ((node=nodeother) and (ffile^.amime=ARES_MIME_OTHER)) then library_file_show(listview,ffile) else
       if ((node=noderecent) and (trunc(ffile.filedate)>trunc(now)-7)) then library_file_show(listview,ffile);
      end;
     end;
 end else
 if level=2 then begin //fine level1
   with node^ do begin
    if parent=nodeaudio then catbyte := CAT_AUDIO else
     if parent=nodevideo then catbyte := CAT_VIDEO else
      if parent=nodeimage then catbyte := CAT_IMAGE else
       if parent=nodedocument then catbyte := CAT_DOCUMENT else
        {if parent=nodesoftware then} catbyte := CAT_SOFTWARE;
        Result := header_library_show(regname1,regname2,listview,'',catbyte,CAT_NOGROUP)
   end;
   for i := 0 to lista_files_utente.count-1 do begin
    ffile := lista_files_utente[i];
     with node^ do begin
      if parent=nodeall then library_file_show(listview,ffile) else begin
       if ((parent=nodeaudio) and ((ffile^.amime=ARES_MIME_MP3) or (ffile^.amime=ARES_MIME_AUDIOOTHER1) or (ffile^.amime=ARES_MIME_AUDIOOTHER2))) then library_file_show(listview,ffile) else
       if ((parent=nodesoftware) and (ffile^.amime=ARES_MIME_SOFTWARE)) then library_file_show(listview,ffile) else
       if ((parent=nodevideo) and (ffile^.amime=ARES_MIME_VIDEO)) then library_file_show(listview,ffile) else
       if ((parent=nodedocument) and (ffile^.amime=ARES_MIME_DOCUMENT)) then library_file_show(listview,ffile) else
       if ((parent=nodeimage) and (ffile^.amime=ARES_MIME_IMAGE)) then library_file_show(listview,ffile) else
       if ((parent=nodeother) and (ffile^.amime=ARES_MIME_OTHER)) then library_file_show(listview,ffile);
      end;
     end;
    end;
   if level=2 then begin
   end;
end else begin
    if node.parent.parent=nodeaudio then begin
      if node.parent=naudiogbyartist then Result := header_library_show(regname1,regname2,listview,'',CAT_AUDIO,CAT_GROUPBY_ARTIST) else
      if node.parent=naudiogbyalbum then Result := header_library_show(regname1,regname2,listview,'',CAT_AUDIO,CAT_GROUPBY_ALBUM) else
      if node.parent=naudiogbygenre then Result := header_library_show(regname1,regname2,listview,'',CAT_AUDIO,CAT_GROUPBY_GENRE);
    end else
    if node.parent.parent=nodevideo then begin
     if node.parent=nvideogbycategory then Result := header_library_show(regname1,regname2,listview,'',CAT_VIDEO,CAT_GROUPBY_CATEGORY);
   end else
    if node.parent.parent=nodeimage then begin
      if node.parent=nimagegbyalbum then Result := header_library_show(regname1,regname2,listview,'',CAT_IMAGE,CAT_GROUPBY_ALBUM) else
      if node.parent=nimagegbycategory then Result := header_library_show(regname1,regname2,listview,'',CAT_IMAGE,CAT_GROUPBY_CATEGORY);
    end else
    if node.parent.parent=nodedocument then begin
     if node.parent=ndocumentgbyauthor then Result := header_library_show(regname1,regname2,listview,'',CAT_DOCUMENT,CAT_GROUPBY_AUTHOR) else
     if node.parent=ndocumentgbycategory then Result := header_library_show(regname1,regname2,listview,'',CAT_DOCUMENT,CAT_GROUPBY_CATEGORY);
    end else
    if node.parent.parent=nodesoftware then begin
     if node.parent=nsoftwaregbycompany then Result := header_library_show(regname1,regname2,listview,'',CAT_SOFTWARE,CAT_GROUPBY_COMPANY) else
     if node.parent=nsoftwaregbycategory then Result := header_library_show(regname1,regname2,listview,'',CAT_SOFTWARE,CAT_GROUPBY_CATEGORY);
    end;

match1 := '';
match2 := '';
match3 := '';

           data := tree.getdata(node);
           match := lowercase(data^.str);
           if match=GetLangStringA(STR_UNKNOW_LOWER) then match := '';

for i := 0 to lista_files_utente.count-1 do begin
     ffile := lista_files_utente[i];
        if ((node.parent.parent<>nodevideo) and (node.parent.parent<>nodeimage)) then begin
          match1 := lowercase(ffile^.artist);
          match2 := lowercase(ffile^.category);
        if node.parent.parent=nodeaudio then match3 := lowercase(ffile^.album);
        end else
        if node.parent.parent=nodevideo then begin
          match1 := lowercase(ffile^.category);
        end else
        if node.parent.parent=nodeimage then begin
          match1 := lowercase(ffile^.album);
          match2 := lowercase(ffile^.category);
        end;

        if match1=GetLangStringA(STR_UNKNOW_LOWER) then match1 := '';
        if match2=GetLangStringA(STR_UNKNOW_LOWER) then match2 := '';
        if match3=GetLangStringA(STR_UNKNOW_LOWER) then match3 := '';

    if ((node.parent.parent=nodeaudio) and ((ffile^.amime=ARES_MIME_MP3) or (ffile^.amime=ARES_MIME_AUDIOOTHER1) or (ffile^.amime=ARES_MIME_AUDIOOTHER2))) then begin
      if ((node.parent=naudiogbyartist) and (match1=match)) then library_file_show(listview,ffile) else
      if ((node.parent=naudiogbyalbum) and (match3=match)) then library_file_show(listview,ffile) else
      if ((node.parent=naudiogbygenre) and (match2=match)) then library_file_show(listview,ffile);
    end else
      if ((node.parent.parent=nodesoftware) and (ffile^.amime=ARES_MIME_SOFTWARE)) then begin
      if ((node.parent=nsoftwaregbycompany) and (match1=match)) then library_file_show(listview,ffile) else
      if ((node.parent=nsoftwaregbycategory) and (match2=match)) then library_file_show(listview,ffile);
    end else
    if ((node.parent.parent=nodevideo) and (ffile^.amime=ARES_MIME_VIDEO)) then begin
      if match1=match then library_file_show(listview,ffile);
    end else
    if ((node.parent.parent=nodedocument) and (ffile^.amime=ARES_MIME_DOCUMENT)) then begin
        if ((node.parent=ndocumentgbyauthor) and (match1=match)) then library_file_show(listview,ffile) else
        if ((node.parent=ndocumentgbycategory) and (match2=match)) then library_file_show(listview,ffile);
   end else
   if ((node.parent.parent=nodeimage) and (ffile^.amime=ARES_MIME_IMAGE)) then begin
        if ((node.parent=nimagegbyalbum) and (match1=match)) then library_file_show(listview,ffile) else
        if ((node.parent=nimagegbycategory) and (match2=match)) then library_file_show(listview,ffile);
   end;
end;
end;


  listview.endUpdate;
    except
    end;

end;

end.
