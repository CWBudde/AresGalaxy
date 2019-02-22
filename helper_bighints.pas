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
bighint visualization code, graphically format informations on big popup window (library/search and transfer)
}

unit helper_bighints;

interface

uses
 ares_objects,sysutils,comettrees,classes2,graphics,classes,windows,
 ares_types;

function availibility_to_point(aval:word): Byte;
function availibility_to_str(aval:word): WideString;
function BitTorrentdownloadhint_show(node:pCmtVnode; dataNode:precord_data_node; lista: TMyStringList; fromUploadTreeview:boolean): Boolean;
function BitTorrentSourcehint_show(node:pCmtVnode; dataNode:precord_data_node; lista: TMyStringList; fromUploadTreeview:boolean): Boolean;
function downloadhint_show(node:PCmtVNode; lista: TMyStringList): Boolean; overload;
function downloadhint_show(dataSource:precord_displayed_downloadsource; dataDownload:Precord_displayed_download; lista: TMyStringList): Boolean; overload;
function uploadhint_show(node:PCmtVNode; lista: TMyStringList): Boolean;
procedure queuehint_show(nodo:PCmtVNode; lista: TMyStringList);
procedure libraryhint_show(nodo:PCmtVNode; lista: TMyStringList);
procedure searchint_show(listview: Tcomettree; nodo:PCmtVNode; lista: TMyStringList);
procedure hint_chunk_draw(cellrect: TRect; startp: Int64; endp: Int64; tot: Int64; overlayed:boolean);
function check_bounds_hint: Boolean;
procedure formhint_hide;
procedure mainGui_hintTimer(treeview: Tcomettree; node:PCmtVNode);
function partialuploadhint_show(node:pCmtVnode; DataNode:precord_data_node; lista: TMyStringList): Boolean;
procedure Fill_Download_Hint_details(data_download:precord_displayed_download; var lista: TMyStringList);

implementation

uses
 ufrmmain,helper_unicode,vars_localiz,helper_strings,
 const_ares,helper_mimetypes,helper_datetime,vars_global,utility_ares,
 helper_urls,helper_download_misc,btcore,BittorrentStringfunc,
 bittorrentUtils;


procedure formhint_hide;
var
punto: TPoint;
begin
try
if formhint.top=10000 then exit;

getcursorpos(punto);
oldhintposx := punto.x;
oldhintposy := punto.y;   //old hint pos per evitare loop reshow


formhint.top := 10000;

previous_hint_node := nil;
handle_obj_GraphHint := INVALID_HANDLE_VALUE
except
end;
end;

function check_bounds_hint: Boolean;
var
punto,punto1: TPoint;
hitinfo: THitInfo;
hnd:hwnd;
i: Integer;
src:precord_panel_search;
begin
result := False;

if ares_frmmain.tabs_pageview.activepage=IDTAB_LIBRARY then begin
 getcursorpos(punto);
 if punto.x>ares_frmmain.left+ares_frmmain.width then begin
  formhint_hide;
  exit;
 end;
 punto1 := ares_frmmain.listview_lib.screentoclient(punto);
 ares_frmmain.listview_lib.GetHitTestInfoAt(punto1.x,punto1.y,true,hitinfo);
end else
if ares_frmmain.tabs_pageview.activepage=IDTAB_SEARCH then begin
 getcursorpos(punto);
 if punto.x>ares_frmmain.left+ares_frmmain.width then begin
  formhint_hide;
  exit;
 end;
 for i := 0 to src_panel_list.count-1 do begin
  src := src_panel_list[i];
  if src^.containerPanel=ares_frmmain.pagesrc.activepanel then begin
    punto1 := src^.listview.screentoclient(punto);
    src^.listview.GetHitTestInfoAt(punto1.x,punto1.y,true,hitinfo);
    break;
  end;
 end;
end else
if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then begin
 getcursorpos(punto);
 if punto.x>ares_frmmain.left+ares_frmmain.width then begin
  formhint_hide;
  exit;
 end;
 punto1 := ares_frmmain.treeview_download.screentoclient(punto);
 ares_frmmain.treeview_download.GetHitTestInfoAt(punto1.x,punto1.y,true,hitinfo);
 if hitinfo.HitNode=nil then begin
   if ares_frmmain.treeview_upload.visible then begin
     punto1 := ares_frmmain.treeview_upload.screentoclient(punto);
     ares_frmmain.treeview_upload.GetHitTestInfoAt(punto1.x,punto1.y,true,hitinfo);
    end else begin
     punto1 := ares_frmmain.treeview_queue.screentoclient(punto);
     ares_frmmain.treeview_queue.GetHitTestInfoAt(punto1.x,punto1.y,true,hitinfo);
    end;
 end;
end else begin   //su altre finestre non dev'esserci hint
 formhint_hide;
 exit;
end;

   if hitinfo.HitNode=nil then begin
    formhint_hide;
    exit;
   end;

 if not (hiOnItemLabel in HitInfo.HitPositions) then begin
  formhint_hide;
  exit;
 end;

   hnd := GetForegroundWindow;
  if hnd<>ares_frmmain.handle then
   if hnd<>formhint.handle then begin
    formhint_hide;
   exit;
  end;

  Result := True; //ok siamo in bound
end;

procedure mainGui_hintTimer(treeview: Tcomettree; node:pCmtVnode);
var
punto: TPoint;
leftp,topp: Integer;
r: TRect;
lista: TMyStringList;
i: Integer;
src:precord_panel_search;
begin
try

 if vars_global.check_opt_gen_nohint_checked then begin
  formhint_hide;
  exit;
 end;

 if ((ares_frmmain.tabs_pageview.activepage<>IDTAB_SEARCH) and
     (ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER) and
     (ares_frmmain.tabs_pageview.activepage<>IDTAB_LIBRARY)) then begin
  formhint_hide;
  exit;
 end;


if ares_frmmain.tabs_pageview.activepage=IDTAB_SEARCH then begin
 lista := tmyStringList.create;
  for i := 0 to src_panel_list.count-1 do begin
   src := src_panel_list[i];
   if src^.containerPanel=ares_frmmain.pagesrc.activepanel then begin
    helper_bighints.searchint_show(src^.listview,node,lista);
    break;
   end;
  end;
 lista.Free;
end else
////////////////////////////////////////////////////////////////library hint //////////////////////////////7
if ares_frmmain.tabs_pageview.activepage=IDTAB_LIBRARY then begin
 lista := tmyStringList.create;
  helper_bighints.libraryhint_show(node,lista);
 lista.Free;
end else    //fine se era nella library
if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then begin
 lista := tmyStringList.create;

 if treeview=ares_frmmain.treeview_download then begin
  if not helper_bighints.downloadhint_show(node,lista) then begin
   lista.Free;
   exit;
  end;
 end else
   if treeview=ares_frmmain.treeview_upload then begin
     if not helper_bighints.uploadhint_show(node,lista) then begin
       lista.Free;
       exit;
     end;
   end else queuehint_show(node,lista);

 lista.Free;
end;

 getcursorpos(punto);
 leftp := punto.x+15;
 topp := punto.y+20;

 SystemParametersInfo(SPI_GETWORKAREA,0,@r,0);
 if topp+formhint.height>r.bottom then topp := r.bottom-formhint.height;
 if leftp+formhint.width>r.right then leftp := r.right-formhint.width;



  try        // smoth transition
      if previous_hint_node<>nil then begin
        if node<>previous_hint_node then begin
         formhint.blend;
         formhint.top := 10000; //per win98
        end;
      end;
  except
  end;


  if formhint.left<>leftp then formhint.left := leftp;
  if formhint.top<>topp then formhint.top := topp;

   setwindowpos(formhint.handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);

  try
       if previous_hint_node<>nil then
        if node<>previous_hint_node then formhint.appear;
  except
  end;
  previous_hint_node := node;

except
end;
end;

procedure searchint_show(listview: Tcomettree; nodo:pCmtVnode; lista: TMyStringList);
var
data_search,data_parent:precord_search_result;
numero: Integer;
size: WideString;
mega:double;
stype,comment,nomefile: WideString;
num_seen: WideString;
totx,locx,i: Integer;
rc: TRect;
widstr: WideString;
numero_sources: Word;
begin
try

data_search := listview.getdata(nodo);             //conta sources....


 if listview.getnodelevel(nodo)<>0 then data_parent := listview.getdata(nodo.parent)
  else data_parent := nil;

if listview.getnodelevel(nodo)<1 then numero := nodo.ChildCount
 else numero := 1;
if numero=0 then numero := 1;

nomefile := utf8strtowidestr(data_search^.filenameS);


  if data_parent<>nil then begin
      numero_sources := nodo.parent.childcount;
      num_seen := GetLangStringW(STR_AVAILIBILITY)+': '+availibility_to_str(numero_sources)+'   '+GetLangStringW(STR_USER)+': '+utf8strtowidestr(data_search^.nickname);
  end else begin
   if data_search^.isTorrent then num_seen := GetLangStringW(STR_AVAILIBILITY)+': '+torrentavailibility_to_str(data_search^.param1,data_search^.param2)
    else begin
     numero_sources := nodo.childcount;
     if numero_sources>1 then num_seen := GetLangStringW(STR_AVAILIBILITY)+': '+availibility_to_str(numero_sources)
      else num_seen := GetLangStringW(STR_AVAILIBILITY)+': '+availibility_to_str(1)+'   '+GetLangStringW(STR_USER)+': '+utf8strtowidestr(data_search^.nickname);
    end;
  end;


 if data_search^.fsize<4096 then begin
  size := GetLangStringW(STR_SIZE)+': '+
        format_currency(data_search^.fsize)+' '+STR_BYTES;
 end else
 if data_search^.fsize<MEGABYTE then begin
  size := GetLangStringW(STR_SIZE)+': '+
        format_currency(data_search^.fsize div KBYTE)+' '+STR_KB+'  ('+
        format_currency(data_search^.fsize)+' '+STR_BYTES+')';
 end else begin
  mega := data_search^.fsize / MEGABYTE;
  size := GetLangStringW(STR_SIZE)+': '+
        FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB+'  ('+
        format_currency(data_search^.fsize)+' '+STR_BYTES+')';
 end;


 if data_search^.isTorrent then stype := GetLangStringW(STR_TYPE)+': Torrent ('+mediatype_to_str(data_search^.amime)+')' else
  stype := GetLangStringW(STR_TYPE)+': '+
         mediatype_to_str(data_search^.amime)+' ('+
         DocumentToContentType(data_search^.filenameS)+')';

  if data_search^.amime=ARES_MIME_MP3 then begin
     if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
     if length(data_search^.artist)>0 then lista.add(GetLangStringA(STR_ARTIST)+': '+data_search^.artist);
     if length(data_search^.album)>0 then lista.add(GetLangStringA(STR_ALBUM)+': '+data_search^.album);
     if length(data_search^.category)>0 then lista.add(GetLangStringA(STR_GENRE)+': '+data_search^.category);
     if length(data_search^.year)>0 then lista.add(GetLangStringA(STR_YEAR)+': '+data_search^.year);
     if not data_search^.isTorrent then begin
      if data_search^.param1<>0 then lista.add(GetLangStringA(STR_QUALITY)+': '+inttostr(data_search^.param1)+' Kbit');
      if data_search^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+': '+format_time(data_search^.param3));
     end;
          if length(data_search^.keyword_genre)>=2 then lista.add(GetLangStringA(STR_RELATED_ARTISTS)+': '+data_search^.keyword_genre);
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
     if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end else
  if data_search^.amime=ARES_MIME_SOFTWARE then begin
    if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
    if length(data_search^.album)>0 then lista.add(GetLangStringA(STR_VERSION)+': '+data_search^.album);
    if length(data_search^.artist)>0 then lista.add(GetLangStringA(STR_COMPANY)+': '+data_search^.artist);
    if length(data_search^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_search^.language);
    if length(data_search^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_search^.category);
    if length(data_search^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_search^.year);
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
    if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end else
  if data_search^.amime=ARES_MIME_VIDEO then begin
      if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
      if length(data_search^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_search^.artist);
      if length(data_search^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_search^.category);
      if length(data_search^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_search^.language);
      if length(data_search^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_search^.year);
      if not data_search^.isTorrent then begin
       if data_search^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+': '+inttostr(data_search^.param1)+'x'+inttostr(data_search^.param2));
       if data_search^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+': '+format_time(data_search^.param3));
      end;
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end else
  if data_search^.amime=ARES_MIME_DOCUMENT then begin
    if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
    if length(data_search^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_search^.artist);
    if length(data_search^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_search^.language);
    if length(data_search^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_search^.category);
    if length(data_search^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_search^.year);
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
    if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end else
  if data_search^.amime=ARES_MIME_IMAGE then begin
      if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
      if length(data_search^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_search^.artist);
      if length(data_search^.album)>0 then lista.add(GetLangStringA(STR_ALBUM)+': '+data_search^.album);
      if length(data_search^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_search^.category);
      if length(data_search^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_search^.year);
        if not data_search^.isTorrent then begin
         if data_search^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+': '+inttostr(data_search^.param1)+'x'+inttostr(data_search^.param2));
         if data_search^.param3=4 then lista.add(GetLangStringA(STR_COLOURS)+': 16') else
         if data_search^.param3=8 then lista.add(GetLangStringA(STR_COLOURS)+': 256') else
         if data_search^.param3=16 then lista.add(GetLangStringA(STR_COLOURS)+': 65K') else
         if data_search^.param3<>0 then lista.add(GetLangStringA(STR_COLOURS)+': 24M'); //'truecolor';
        end;
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end else
  if data_search^.amime=ARES_MIME_OTHER then begin
     if length(data_search^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+': '+data_search^.title);
     if length(data_search^.comments)>0 then begin
       if length(data_search^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_search^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_search^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if (not data_search^.isTorrent) and (length(data_search^.url)>0) then lista.add(GetLangStringA(STR_URL)+': '+data_search^.url);
  end;

  ////////// calc max width
      vars_global.formhint.canvas.lock;
      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      vars_global.formhint.canvas.Font.style := [];
      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),vars_global.formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;

        locx := gettextwidth(stype,vars_global.formhint.canvas); //type
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,vars_global.formhint.canvas);   //size
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(num_seen,vars_global.formhint.canvas);    //size
        locx := 5+locx;
        if locx>totx then totx := locx;



      if (Win32Platform=VER_PLATFORM_WIN32_NT) then vars_global.formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,vars_global.formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

     vars_global.formhint.width := totx+5;
     vars_global.formhint.height := 70+(28)+(lista.count*14);
   /////////////////////////////////////////////////////////////////////////7

     vars_global.formhint.canvas.pen.color := clgray;

     vars_global.formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     vars_global.formhint.canvas.rectangle(0,0,vars_global.formhint.width,formhint.height);
     vars_global.formhint.canvas.brush.style := bsclear;

     if (Win32Platform=VER_PLATFORM_WIN32_NT) then vars_global.formhint.canvas.Font.style := [fsbold];

     
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(vars_global.formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
     vars_global.formhint.canvas.font.style := [];

     vars_global.formhint.canvas.brush.color := clgray;
     vars_global.formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     vars_global.formhint.canvas.FillRect(rc);

     vars_global.formhint.canvas.brush.color := $00FEFFFF;
     vars_global.formhint.canvas.rectangle(6,25,46,65);


     ares_frmmain.ImageList_lib_max.draw(vars_global.formhint.canvas,10,29,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(data_search^.filenameS)))),true);



     vars_global.formhint.canvas.brush.style := bsclear;
     vars_global.formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
    Windows.ExtTextOutW(vars_global.formhint.canvas.Handle, 51, 29, 0, nil, PwideChar(stype),Length(stype), nil); //status
    Windows.ExtTextOutW(vars_global.formhint.canvas.Handle, 51, 45, 0, nil, PwideChar(size),Length(size), nil); //status


     vars_global.formhint.canvas.brush.color := clgray; //second line
     vars_global.formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := vars_global.formhint.width-5;
     rc.top := 69;
     rc.bottom := 70;
     vars_global.formhint.canvas.FillRect(rc);

     vars_global.formhint.canvas.brush.style := bsclear;
     vars_global.formhint.canvas.Font.style := [];

    Windows.ExtTextOutW(vars_global.formhint.canvas.Handle, 5, 73, 0, nil, PwideChar(num_seen),Length(num_seen), nil); //status

            vars_global.formhint.canvas.brush.color := clgray; //thirdd line
            vars_global.formhint.canvas.brush.style := bssolid;
            rc.left := 5;                       //drow first rect
            rc.right := formhint.width-5;
            rc.top := 90;
            rc.bottom := 91;
            vars_global.formhint.canvas.FillRect(rc);




     vars_global.formhint.canvas.brush.style := bsclear;
     vars_global.formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     i := 94;  //in base ai source

     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
       Windows.ExtTextOutW(vars_global.formhint.canvas.Handle, 5, i, 0, nil, PwideChar(widstr),Length(widstr), nil); //status
      lista.delete(0);
      inc(i,14);
     until (not true);

     vars_global.formhint.posygraph := -1; // nasconde il grafico
     vars_global.formhint.canvas.unlock;
except
end;
end;

procedure libraryhint_show(nodo:pCmtVnode; lista: TMyStringList);
var
data_library:^record_file_library;
mega:double;
stype,comment,location,nomefile,path,size: WideString;
totx,locx,i: Integer;
rc: TRect;
path2,location2: WideString;
widstr: WideString;
begin
try

data_library := ares_frmmain.listview_lib.getdata(nodo);             //conta sources....

if ((data_library^.imageindex=0) or (widestrtoutf8str(ares_frmmain.listview_lib.header.columns.Items[0].text)=GetLangStringA(STR_YOUR_LIBRARY))) then begin    //library root....
     totx := 100;

     formhint.canvas.lock;
      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];

       location := utf8strtowidestr(data_library^.artist);
       path := utf8strtowidestr(data_library^.category);
       location2 := utf8strtowidestr(data_library^.album);
       path2 := utf8strtowidestr(data_library^.year);


        locx := gettextwidth(path,formhint.canvas);
        locx := 71+locx;
        if locx>totx then totx := locx;

        if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];
        locx := gettextwidth(location,formhint.canvas);
        locx := 71+locx;
        if locx>totx then totx := locx;

         if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [];
        locx := gettextwidth(path2,formhint.canvas);
        locx := 71+locx;
        if locx>totx then totx := locx;

        if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];
        locx := gettextwidth(location2,formhint.canvas);
        locx := 71+locx;
        if locx>totx then totx := locx;

     formhint.width := totx+5;
     formhint.height := 70;

    with formhint.canvas do begin
     pen.color := clgray;
     brush.color := vars_global.COLORE_HINT_BG;
     rectangle(0,0,formhint.width,formhint.height);

     brush.color := $00FEFFFF;
     rectangle(6,5,65,65);

       ares_frmmain.imagelist_lib_max.draw(formhint.canvas,19,18,data_library^.imageindex,true);


     brush.style := bsclear;

    formhint.Canvas.Font.Color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(Handle, 71, 5, 0, nil, PwideChar(location),Length(location), nil); //status

      Font.style := [];

      formhint.Canvas.Font.Color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(Handle, 71, 22, 0, nil, PwideChar(path),Length(path), nil); //status
     Windows.ExtTextOutW(Handle, 71, 37, 0, nil, PwideChar(location2),Length(location2), nil); //status
     Windows.ExtTextOutW(Handle, 71,52, 0, nil, PwideChar(path2),Length(path2), nil); //status

     unlock;
    end;
     exit;

end;

formhint.canvas.lock;

path := extract_fpathW(utf8strtowidestr(data_library^.path));
nomefile := extract_fnameW(utf8strtowidestr(data_library^.path));

if data_library^.fsize<4096 then begin
 size := GetLangStringW(STR_SIZE)+':'+chr(32)+format_currency(data_library^.fsize)+
       chr(32)+STR_BYTES;
end else
if data_library^.fsize<MEGABYTE then begin
 size := GetLangStringW(STR_SIZE)+':'+chr(32)+format_currency(data_library^.fsize div KBYTE)+
       chr(32)+STR_KB+'  ('+format_currency(data_library^.fsize)+chr(32)+STR_BYTES+')';
end else begin
 mega := data_library^.fsize / MEGABYTE;
 size := GetLangStringW(STR_SIZE)+':'+chr(32)+FloatToStrF(mega, ffNumber, 18, 2)+chr(32)+STR_MB+'  ('+
       format_currency(data_library^.fsize)+chr(32)+STR_BYTES+')';
end;

  stype := GetLangStringW(STR_TYPE)+':'+chr(32)+
         mediatype_to_str(data_library^.amime)+' ('+
         DocumentToContentType(data_library^.path)+')';

  location := GetLangStringW(STR_LOCATION)+':'+chr(32)+path;


  if data_library^.amime=ARES_MIME_MP3 then begin
     if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
     if length(data_library^.artist)>0 then lista.add(GetLangStringA(STR_ARTIST)+':'+chr(32)+data_library^.artist);
     if length(data_library^.album)>0 then lista.add(GetLangStringA(STR_ALBUM)+':'+chr(32)+data_library^.album);
     if length(data_library^.category)>0 then lista.add(GetLangStringA(STR_GENRE)+':'+chr(32)+data_library^.category);
     if length(data_library^.year)>0 then lista.add(GetLangStringA(STR_YEAR)+':'+chr(32)+data_library^.year);
     if data_library^.param1<>0 then lista.add(GetLangStringA(STR_QUALITY)+':'+chr(32)+inttostr(data_library^.param1)+' Kbit');
     if data_library^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+':'+chr(32)+format_time(data_library^.param3));
     if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
      end;
            end;
     if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end else
  if data_library^.amime=ARES_MIME_SOFTWARE then begin
    if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
    if length(data_library^.album)>0 then lista.add(GetLangStringA(STR_VERSION)+':'+chr(32)+data_library^.album);
    if length(data_library^.artist)>0 then lista.add(GetLangStringA(STR_COMPANY)+':'+chr(32)+data_library^.artist);
    if length(data_library^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+':'+chr(32)+data_library^.language);
    if length(data_library^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+':'+chr(32)+data_library^.category);
    if length(data_library^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+':'+chr(32)+data_library^.year);
    if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
      end;
           end;
    if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end else
  if data_library^.amime=ARES_MIME_VIDEO then begin
      if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
      if length(data_library^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+':'+chr(32)+data_library^.artist);
      if length(data_library^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+':'+chr(32)+data_library^.category);
      if length(data_library^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+':'+chr(32)+data_library^.language);
      if length(data_library^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+':'+chr(32)+data_library^.year);
      if data_library^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+':'+chr(32)+inttostr(data_library^.param1)+'x'+inttostr(data_library^.param2));
      if data_library^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+':'+chr(32)+format_time(data_library^.param3));
      if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
      end;
         end;
      if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end else
  if data_library^.amime=ARES_MIME_DOCUMENT then begin
    if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
    if length(data_library^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+':'+chr(32)+data_library^.artist);
    if length(data_library^.language)>0 then lista.add(GetLangStringA(STR_LANGUAGE)+':'+chr(32)+data_library^.language);
    if length(data_library^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+':'+chr(32)+data_library^.category);
    if length(data_library^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+':'+chr(32)+data_library^.year);
    if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
    if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end else
  if data_library^.amime=ARES_MIME_IMAGE then begin
      if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
      if length(data_library^.artist)>0 then lista.add(GetLangStringA(STR_AUTHOR)+':'+chr(32)+data_library^.artist);
      if length(data_library^.album)>0 then lista.add(GetLangStringA(STR_ALBUM)+':'+chr(32)+data_library^.album);
      if length(data_library^.category)>0 then lista.add(GetLangStringA(STR_CATEGORY)+':'+chr(32)+data_library^.category);
      if length(data_library^.year)>0 then lista.add(GetLangStringA(STR_DATE_COLUMN)+':'+chr(32)+data_library^.year);
      if data_library^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+': '+inttostr(data_library^.param1)+'x'+inttostr(data_library^.param2));
        if data_library^.param3=4 then lista.add(GetLangStringA(STR_COLOURS)+': 16') else
        if data_library^.param3=8 then lista.add(GetLangStringA(STR_COLOURS)+': 256') else
        if data_library^.param3=16 then lista.add(GetLangStringA(STR_COLOURS)+': 65K') else
        if data_library^.param3<>0 then lista.add(GetLangStringA(STR_COLOURS)+': 24M'); //'truecolor';
      if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end else
  if data_library^.amime=ARES_MIME_OTHER then begin
   if length(data_library^.title)>0 then lista.add(GetLangStringA(STR_TITLE)+':'+chr(32)+data_library^.title);
   if length(data_library^.comment)>0 then begin
       if length(data_library^.comment)<90 then lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(strip_returns(utf8strtowidestr(data_library^.comment)))) else begin
       comment := strip_returns(utf8strtowidestr(data_library^.comment));
       lista.add(GetLangStringA(STR_COMMENT)+':'+chr(32)+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(chr(32)+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
       end;
    if length(data_library^.url)>0 then lista.add(GetLangStringA(STR_URL)+':'+chr(32)+data_library^.url);
  end;

  if trunc(data_library^.filedate)<>0 then
  lista.add(GetLangStringA(STR_DOWNLOADED_ON)+':'+chr(32)+formatdatetime('mm/dd/yyyy  h:nn AM/PM',data_library^.filedate));

  ////////// calc max width
      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];

      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;

        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 71+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,formhint.canvas);     //size
        locx := 71+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(location,formhint.canvas);    //size
        locx := 71+locx;
        if locx>totx then totx := locx;


       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

     formhint.width := totx+5;
     formhint.height := 94+(lista.count*14);
   /////////////////////////////////////////////////////////////////////////7
     with formhint.canvas do begin
      pen.color := clgray;
       brush.color := vars_global.COLORE_HINT_BG;
       rectangle(0,0,formhint.width,formhint.height);
      brush.style := bsclear;

      
      if (Win32Platform=VER_PLATFORM_WIN32_NT) then Font.style := [fsbold];
      formhint.Canvas.Font.Color := vars_global.COLORE_HINT_FONT;
      Windows.ExtTextOutW(Handle, 5,4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
      font.style := [];

      brush.color := clgray;
      brush.style := bssolid;
     end;
     
     with rc do begin
      left := 5;                       //draw first rect
      right := formhint.width-5;
      top := 20;
      bottom := 21;
     end;

     with formhint.canvas do begin
      FillRect(rc);

      brush.color := $00FEFFFF;
      rectangle(6,25,65,85);

       ares_frmmain.ImageList_lib_max.draw(formhint.canvas,19,38,aresmime_to_imgindexbig(data_library^.amime),true);

      brush.style := bsclear;
      Font.style := [];
      formhint.Canvas.Font.Color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(Handle, 71,31, 0, nil, PwideChar(stype),Length(stype), nil); //status
     Windows.ExtTextOutW(Handle, 71,48, 0, nil, PwideChar(size),Length(size), nil); //status
     Windows.ExtTextOutW(Handle, 71,65, 0, nil, PwideChar(location),Length(location), nil); //status

     brush.color := clgray; //second line
     brush.style := bssolid;
     end;

     with rc do begin
      left := 5;                       //draw first rect
      right := formhint.width-5;
      top := 89;
      bottom := 90;
     end;

     with formhint.canvas do begin
      FillRect(rc);
      brush.style := bsclear;
      Font.style := [];
      formhint.Canvas.Font.Color := vars_global.COLORE_HINT_FONT;
     i := 92;
     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
       Windows.ExtTextOutW(Handle, 5,i, 0, nil, PwideChar(widstr),Length(widstr), nil); //status
      lista.delete(0);
      inc(i,14);
     until (not true);

     unlock;
     end;

     formhint.posygraph := -1;

except
end;
end;

procedure queuehint_show(nodo:pCmtVnode; lista: TMyStringList);
var
data_queued:precord_queued;
nomefile: WideString;
size: WideString;
stype: WideString;
totx,locx: Integer;
rc: TRect;
i: Integer;
kbyt:double;
mega:double;
hareaprogress: Integer; //altezza dell'area progress che cambia
tempo: Cardinal;
widstr: WideString;
begin
try

data_queued := ares_frmmain.treeview_queue.getdata(nodo);             //conta sources....

nomefile := extract_fnameW(utf8strtowidestr(data_queued^.nomefile));

if data_queued^.size<MEGABYTE then begin
 kbyt := data_queued^.size/KBYTE;
 size := FloatToStrF(kbyt, ffNumber, 18, 2)+' '+STR_KB;
 size := GetLangStringW(STR_SIZE)+': '+size+'  ('+
       format_currency(data_queued^.size)+' '+STR_BYTES+')';
end else begin
 mega := data_queued^.size/MEGABYTE;
 size := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 size := GetLangStringW(STR_SIZE)+': '+size+'  ('+
       format_currency(data_queued^.size)+' '+STR_BYTES+')';
end;

stype := GetLangStringW(STR_TYPE)+': '+
       mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(data_queued^.nomefile))))+' ('+
       DocumentToContentType(nomefile)+')';

   tempo := gettickcount;


if data_queued^.his_shared<>-1 then begin
 lista.add(GetLangStringA(STR_USER)+': '+right_strip_at_agent(data_queued^.user)+'@'+data_queued^.his_agent+'  ('+inttostr(data_queued^.his_shared)+' '+GetLangStringA(STR_FILES)+')');
end else lista.add(GetLangStringA(STR_USER)+': '+right_strip_at_agent(data_queued^.user)+'@'+data_queued^.his_agent);


 lista.add(GetLangStringA(STR_STARTED)+': '+format_time((tempo-data_queued^.queue_start) div 1000));
 lista.add(GetLangStringA(STR_SOURCES_AVAILABLE)+': '+inttostr(data_queued^.num_available));
 lista.add(GetLangStringA(STR_ACTUALPROGRESS)+': '+inttostr(data_queued^.his_progress)+'%');
 lista.add(GetLangStringA(STR_TOTALTRIES)+': '+format_currency(data_queued^.total_tries));
 if data_queued^.retry_interval=0 then lista.add(GetLangStringA(STR_RETRYINTERVAL)+': '+STR_NA) else lista.add(GetLangStringA(STR_RETRYINTERVAL)+': '+format_currency(data_queued^.retry_interval));
 lista.add(GetLangStringA(STR_LASTREQUESTED)+': '+format_time((tempo-data_queued^.polltime) div 1000));
 lista.add(GetLangStringA(STR_EXPIRATION)+': '+format_time(((data_queued^.polltime div 1000)+data_queued^.pollmax) - (tempo div 1000)));


  ////////// calc max width
  formhint.canvas.lock;
      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;

        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 56+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,formhint.canvas);   //upload_size
        locx := 56+locx;
        if locx>totx then totx := locx;

       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

      hareaprogress := 28;

     formhint.width := totx+5;
     formhint.height := 78+hareaprogress+(lista.count*14);
   /////////////////////////////////////////////////////////////////////////7

     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     formhint.canvas.rectangle(0,0,formhint.width,formhint.height);
     formhint.canvas.brush.style := bsclear;

     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5,4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(6,25,46,65);


    ares_frmmain.ImageList_lib_max.draw(formhint.canvas,10,29,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(data_queued^.nomefile)))),true);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 56,30, 0, nil, PwideChar(stype),Length(stype), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 56,46, 0, nil, PwideChar(size),Length(size), nil); //status


     formhint.canvas.brush.color := clgray; //second line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw first rect
     rc.right := formhint.width-5;
     rc.top := 70;
     rc.bottom := 71;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     i := 75;
     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
      Windows.ExtTextOutW(formhint.canvas.Handle, 5,i, 0, nil, PwideChar(widstr),Length(widstr), nil);
      lista.delete(0);
      inc(i,14);
     until (not true);

     formhint.canvas.brush.color := clgray; //fourth line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw first rect
     rc.right := formhint.width-5;
     rc.top := i+3;       //<---------offset
     rc.bottom := i+4;
     formhint.canvas.FillRect(rc);

     ///progressbar total
     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.Rectangle(5,i+7,formhint.Width-5,i+27);

      if ((data_queued^.polltime div 1000)+data_queued^.pollmax) - (tempo div 1000)>0 then begin
        formhint.canvas.brush.color := COLOR_PROGRESS_UP;
        formhint.canvas.pen.color := COLOR_PROGRESS_UP;
       hint_chunk_draw(rect(5,i+7,formhint.width-5,i+27),0,((data_queued^.polltime div 1000)+data_queued^.pollmax) - (tempo div 1000),data_queued^.pollmax,false);
      end;

           formhint.canvas.Unlock;
           formhint.posygraph := -1;
except
end;
end;

procedure hint_chunk_draw(cellrect: TRect; startp: Int64; endp: Int64; tot: Int64; overlayed:boolean);
var
larghezzatot: Int64;
puntoxr,puntoxl: Int64;
begin
try
larghezzatot := cellrect.right-cellrect.left-7;  // <----dimensione progressbar per il disegno
if ((larghezzatot<1) or (tot<1)) then exit;

 puntoxl := ((larghezzatot*startp) div tot);        // punto di inizio nel canvas
 puntoxr := ((larghezzatot*endp) div tot);          // punto finale nel canvas
// disegno il quadratino sulla progressbar, rappresentante quanto mi Earrivato del download
 if puntoxr-puntoxl<1 then exit;

 if overlayed then begin //rebuilding
        with formhint.canvas do begin
          brush.color := COLOR_UL_CANCELLED;    // ??verde
          pen.color := COLOR_UL_CANCELLED;
         rectangle((cellrect.Left+3),cellrect.Top+2,(cellrect.right-3) ,cellrect.Bottom-3);
          brush.color := COLOR_PROGRESS_UP;    // ??verde
          pen.color := COLOR_PROGRESS_UP;
       end;
 end;

 formhint.canvas.rectangle((cellrect.Left+3)+puntoxl,cellrect.Top+3,(cellrect.left+3)+ puntoxr ,cellrect.Bottom-3);
except
end;
end;

function uploadhint_show(node:pCmtVnode; lista: TMyStringList): Boolean;
var
dataNode:precord_data_node;
data_upload:precord_displayed_upload;
nomefile: WideString;
size: WideString;
mega,kbyt:double;
stype,velocita,remaining,size_total,real_size_total,str_his_speed: WideString;
size_progress,downloaded,percent,upload_size,size_chunks: WideString;
status: WideString;
ksec,kbyts:double;
progress,size_chunk,perc_requested_tous:extended;
totx,locx: Integer;
rc: TRect;
i: Integer;
hareaprogress: Integer; 
widstr: WideString;
secondi_rimanenti: Integer;
begin
try
result := False;

dataNode := ares_frmmain.treeview_upload.getdata(node);

if dataNode^.m_type=dnt_bitTorrentMain then begin
 Result := BitTorrentdownloadhint_show(node,dataNode,lista,true);
 exit;
end;

if dataNode^.m_type=dnt_bitTorrentSource then begin
 Result := BitTorrentSourcehint_show(node,dataNode,lista,true);
 exit;
end;

if dataNode^.m_type=dnt_Partialupload then begin
 Result := partialuploadhint_show(node,dataNode,lista);
 exit;
end;

if dataNode^.m_type<>dnt_upload then exit;

data_upload := dataNode^.data;

vars_global.handle_obj_GraphHint := data_upload^.handle_obj;

vars_global.graphIsUpload := True;  //consumer is thread upload
vars_global.graphisDownload := False;

nomefile := extract_fnameW(utf8strtowidestr(data_upload^.nomefile));


perc_requested_tous := (data_upload^.size+data_upload^.continued_from);
perc_requested_tous := perc_requested_tous/data_upload^.filesize_reale;
perc_requested_tous := perc_requested_tous*100;
percent := FloatToStrF(perc_requested_tous, ffNumber, 18, 2);

if (data_upload^.size+data_upload^.continued_from)<4096 then begin
 size_total := format_currency(data_upload^.size+data_upload^.continued_from)+' '+STR_BYTES;
 upload_size := GetLangStringW(STR_REQUESTED_SIZE)+': '+size_total+'  '+percent+'%';
end else
if (data_upload^.size+data_upload^.continued_from)<MEGABYTE then begin
 kbyt := (data_upload^.size+data_upload^.continued_from)/KBYTE;
 size_total := FloatToStrF(kbyt, ffNumber, 18, 2)+' '+STR_KB;
 upload_size := GetLangStringW(STR_REQUESTED_SIZE)+': '+size_total+'  ('+format_currency(data_upload^.size+data_upload^.continued_from)+' '+STR_BYTES+')  '+percent+'%';
end else begin
 mega := (data_upload^.size+data_upload^.continued_from)/MEGABYTE;
 size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 upload_size := GetLangStringW(STR_REQUESTED_SIZE)+': '+size_total+'  ('+format_currency(data_upload^.size+data_upload^.continued_from)+' '+STR_BYTES+')  '+percent+'%';
end;

if data_upload^.filesize_reale<4096 then begin
 real_size_total := format_currency(data_upload^.filesize_reale)+' '+STR_BYTES;
 size := GetLangStringW(STR_FILE_SIZE)+': '+real_size_total;
end else
if data_upload^.filesize_reale<MEGABYTE then begin
 kbyt := data_upload^.filesize_reale/KBYTE;
 real_size_total := FloatToStrF(kbyt, ffNumber, 18, 2)+' '+STR_KB;
 size := GetLangStringW(STR_FILE_SIZE)+': '+real_size_total+'  ('+format_currency(data_upload^.filesize_reale)+' '+STR_BYTES+')';
end else begin
 mega := data_upload^.filesize_reale/MEGABYTE;
 real_size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 size := GetLangStringW(STR_FILE_SIZE)+': '+real_size_total+'  ('+format_currency(data_upload^.filesize_reale)+' '+STR_BYTES+')';
end;


if ((data_upload^.progress{+data_upload^.continued_from}<4096) and (data_upload^.size{+data_upload^.continued_from}<4096)) then begin
 size_progress := format_currency(data_upload^.progress{+data_upload^.continued_from})+' '+STR_BYTES;
end else
if (data_upload^.progress{+data_upload^.continued_from})<MEGABYTE then begin
 kbyt := (data_upload^.progress{+data_upload^.continued_from})/KBYTE;
 size_progress := FloatToStrF(kbyt, ffNumber, 18, 2)+' '+STR_KB;
end else begin
 mega := (data_upload^.progress{+data_upload^.continued_from}) / MEGABYTE;
 size_progress := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
end;

stype := GetLangStringW(STR_TYPE)+': '+
       mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(data_upload^.nomefile))))+
       ' ('+DocumentToContentType(nomefile)+')';

                    if data_upload^.his_speedDL>0 then begin   //2957+
                                               if data_upload^.his_speedDL<4096 then begin
                                                str_his_speed := ' '+format_currency(data_upload^.his_speedDL)+'b/s';
                                               end else begin
                                                kbyts := data_upload^.his_speedDL/KBYTE;
                                                str_his_speed := ' '+FloatToStrF(kbyts, ffNumber, 18, 2)+'KB/s';
                                              end;
                                             end else str_his_speed := '';

if data_upload^.completed then begin
  if data_upload^.progress=data_upload^.size then status := GetLangStringW(STR_STATUS)+': '+GetLangStringW(STR_COMPLETED) else
    status := GetLangStringW(STR_STATUS)+': '+GetLangStringW(STR_CANCELLED);
     if data_upload^.his_progress>0 then status := status+' '+inttostr(data_upload^.his_progress)+'%';
     if data_upload^.num_available>0 then status := status+'  ('+inttostr(data_upload^.num_available)+' '+GetLangStringW(STR_SOURCES)+str_his_speed+')';
end else begin
  status := GetLangStringW(STR_STATUS)+': '+GetLangStringW(STR_UPLOADING);
   if data_upload^.his_progress>0 then status := status+' '+inttostr(data_upload^.his_progress)+'%';
   if data_upload^.num_available>0 then status := status+'  ('+inttostr(data_upload^.num_available)+' '+GetLangStringW(STR_SOURCES)+str_his_speed+')';
end;

if ((data_upload^.velocita>0) and (not data_upload^.completed)) then begin
 ksec := data_upload^.velocita;
 ksec := ksec/KBYTE;
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+FloatToStrF(ksec, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
             secondi_rimanenti := ((data_upload^.size{+data_upload^.continued_from})-(data_upload^.progress{+data_upload^.continued_from})) div data_upload.velocita;
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+format_time(secondi_rimanenti);
end else begin
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+STR_NA;
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA;
end;

 progress := (data_upload^.progress{+data_upload^.continued_from});
 if (data_upload^.size{+data_upload^.continued_from})=0 then progress := 1 else progress := progress/(data_upload^.size{+data_upload^.continued_from});
 progress := progress*100;
 percent := FloatToStrF(progress, ffNumber, 18, 2);

 size_chunk := (data_upload^.size{+data_upload^.continued_from});
 if size_chunk<4096 then size_chunks := format_currency(data_upload^.size)+' '+STR_BYTES else
 if size_chunk<MEGABYTE then size_chunks := FloatToStrF((size_chunk/KBYTE), ffNumber, 18, 2)+' '+STR_KB else
                         size_chunks := FloatToStrF((size_chunk/MEGABYTE), ffNumber, 18, 2)+' '+STR_MB;


 downloaded := GetLangStringW(STR_VOLUME_TRANSMITTED)+': '+
             size_progress+' '+
             GetLangStringW(STR_OF)+' '+size_chunks+' ('+percent+'%)';


  if data_upload^.his_shared<>-1 then begin
    lista.add(GetLangStringA(STR_USER)+': '+right_strip_at_agent(data_upload^.nickname)+'@'+
              data_upload^.his_agent+'  ('+inttostr(data_upload^.his_shared)+' '+GetLangStringA(STR_FILES)+')');
     //if data_upload^.his_downcount<>-1 then lista.add(GetLangStringA(STR_USER)+': '+data_upload^.nickname+'  ('+his_buildNs+inttostr(data_upload^.his_shared)+' '+GetLangStringA(STR_FILES)+', '+inttostr(data_upload.his_upcount)+' '+GetLangStringA(STR_UPLOADS)+', '+inttostr(data_upload.his_downcount)+' '+GetLangStringA(STR_DOWNLOADS)+')')
     // else lista.add(GetLangStringA(STR_USER)+': '+data_upload^.nickname+'  ('+his_buildNs+inttostr(data_upload^.his_shared)+' '+GetLangStringA(STR_FILES)+', '+inttostr(data_upload.his_upcount)+' '+GetLangStringA(STR_UPLOADS)+')');
  end else lista.add(GetLangStringA(STR_USER)+': '+right_strip_at_agent(data_upload^.nickname)+'@'+data_upload^.his_agent);

  ////////// calcolo larghezza massima
     formhint.canvas.lock;
      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;

        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 56+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(upload_size,formhint.canvas);    //upload_size
        locx := 56+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,formhint.canvas);    //real size
        locx := 56+locx;
        if locx>totx then totx := locx;


        locx := gettextwidth(status,formhint.canvas);    //status
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(remaining,formhint.canvas);    //remaining
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(velocita,formhint.canvas);    //velocita
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(downloaded,formhint.canvas);    //bandwidths
        locx := 5+locx;
        if locx>totx then totx := locx;

       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

      if data_upload^.completed then hareaprogress := 28 else hareaprogress := 70;
       //progress bar total e eventualmente progress local+indicazione speed local +indicazione user + graph

     formhint.width := totx+5;
     formhint.height := 156+hareaprogress+(lista.count*14);
   /////////////////////////////////////////////////////////////////////////7

     
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));
     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG;
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     if data_upload^.completed then begin
      formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-1);
    end else begin
      formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-45);
     end;

     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;

     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

    formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
    Windows.ExtTextOutW(formhint.canvas.Handle, 5,4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(6,33,46,73);



    ares_frmmain.ImageList_lib_max.draw(formhint.canvas,10,37,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(data_upload^.nomefile)))),true);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
    Windows.ExtTextOutW(formhint.canvas.Handle, 56,29, 0, nil, PwideChar(stype),Length(stype), nil); //status
    Windows.ExtTextOutW(formhint.canvas.Handle, 56,45, 0, nil, PwideChar(upload_size),Length(upload_size), nil); //status
    Windows.ExtTextOutW(formhint.canvas.Handle, 56,61, 0, nil, PwideChar(size),Length(size), nil); //status



     formhint.canvas.brush.color := clgray; //second line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 85;
     rc.bottom := 86;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5,89, 0, nil, PwideChar(status),Length(status), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5,103, 0, nil, PwideChar(velocita),Length(velocita), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5,117, 0, nil, PwideChar(remaining),Length(remaining), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5,131, 0, nil, PwideChar(downloaded),Length(downloaded), nil); //status

     formhint.canvas.brush.color := clgray; //thirdd line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 148;
     rc.bottom := 149;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;

     i := 152;
     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
      Windows.ExtTextOutW(formhint.canvas.Handle, 5,i, 0, nil, PwideChar(widstr),Length(widstr), nil); //status
      lista.delete(0);
      inc(i,14);
     until (not true);

     formhint.canvas.brush.color := clgray; //fourth line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := i+3;       //<---------offset
     rc.bottom := i+4;
     formhint.canvas.FillRect(rc);

     ///progressbar total
     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(5,i+7,formhint.width-5,i+27);


          if data_upload^.completed then begin
                       if (data_upload^.progress+data_upload^.continued_from)=(data_upload^.size+data_upload^.continued_from) then begin
                          formhint.canvas.brush.color := COLOR_DL_COMPLETED; //     $00BA3232; //$000030ff;
                          formhint.canvas.pen.color := COLOR_DL_COMPLETED;
                       end else begin
                          formhint.canvas.brush.color := COLOR_PROGRESS_UP; //     $00BA3232; //$000030ff;
                          formhint.canvas.pen.color := COLOR_PROGRESS_UP;
                       end;
                  hint_chunk_draw(rect(3,i+5,formhint.width-2,i+29),0,data_upload^.progress,data_upload^.size,false);

               formhint.canvas.brush.color := COLOR_MISSING_CHUNK; //     draw empty little bar
               formhint.canvas.pen.color := COLOR_MISSING_CHUNK;
               hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),0,100,100,false);

               formhint.canvas.brush.color := COLOR_PARTIAL_CHUNK; //     $00BA3232; //$000030ff;
               formhint.canvas.pen.color := COLOR_PARTIAL_CHUNK;
               hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),data_upload^.start_point,data_upload^.start_point+data_upload^.size,data_upload^.filesize_reale,false);

                //draw position over chunk
               formhint.canvas.brush.color := COLORE_ULSOURCE_CHUNK; //     $00BA3232; //$000030ff;
               formhint.canvas.pen.color := COLORE_ULSOURCE_CHUNK;
               hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),data_upload^.start_point,data_upload^.start_point+data_upload^.progress,data_upload^.filesize_reale,false);

               formhint.canvas.brush.color := cl3dlight; //     riga separatore chunks
               formhint.canvas.pen.color := cl3dlight;
               formhint.canvas.fillrect(rect(6,i+19,formhint.width-6,i+20));

                formhint.posygraph := -1; // nasconde il grafico
                formhint.Canvas.Unlock;
           Result := True;
           exit;
          end;



        formhint.canvas.brush.color := COLOR_PROGRESS_UP; //     $00BA3232; //$000030ff;
        formhint.canvas.pen.color := COLOR_PROGRESS_UP;
        hint_chunk_draw(rect(3,i+5,formhint.width-2,i+29),0,data_upload^.progress{+data_upload^.continued_from},data_upload^.size{+data_upload^.continued_from},false);


         formhint.canvas.brush.color := COLOR_MISSING_CHUNK; //     draw empty little bar
         formhint.canvas.pen.color := COLOR_MISSING_CHUNK;
         hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),0,100,100,false);



     //draw chunk requested over overal file
     formhint.canvas.brush.color := COLOR_PARTIAL_CHUNK; //     $00BA3232; //$000030ff;
     formhint.canvas.pen.color := COLOR_PARTIAL_CHUNK;
     hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),data_upload^.start_point,data_upload^.start_point+data_upload^.size,data_upload^.filesize_reale,false);

     //draw position over chunk
     formhint.canvas.brush.color := COLORE_ULSOURCE_CHUNK; //     $00BA3232; //$000030ff;
     formhint.canvas.pen.color := COLORE_ULSOURCE_CHUNK;
     hint_chunk_draw(rect(3,i+17,formhint.width-2,i+29),data_upload^.start_point,data_upload^.start_point+data_upload^.progress,data_upload^.filesize_reale,false);


          if data_upload^.upload<>nil then formhint.posygraph := i+29;

           formhint.canvas.Unlock;

           Result := True;
except
result := False;
end;
end;

procedure Fill_Download_Hint_details(data_download:precord_displayed_download; var lista: TMyStringList);
var
comment: WideString;
begin
  if data_download^.tipo=1 then begin
     if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
     if length(data_download^.artist)>1 then lista.add(GetLangStringA(STR_ARTIST)+': '+data_download^.artist);
     if length(data_download^.album)>1 then lista.add(GetLangStringA(STR_ALBUM)+': '+data_download^.album);
     if length(data_download^.category)>1 then lista.add(GetLangStringA(STR_GENRE)+': '+data_download^.category);
     if length(data_download^.date)>1 then lista.add(GetLangStringA(STR_YEAR)+': '+data_download^.date);
     if data_download^.param1<>0 then lista.add(GetLangStringA(STR_QUALITY)+': '+inttostr(data_download^.param1)+' Kbit');
     if data_download^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+': '+format_time(data_download^.param3));
     if length(data_download^.keyword_genre)>=2 then lista.add(GetLangStringA(STR_RELATED_ARTISTS)+': '+data_download^.keyword_genre);
     if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));  //rimettiamo encode in lista
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
     if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end else
  if data_download^.tipo=3 then begin
    if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
    if length(data_download^.album)>1 then lista.add(GetLangStringA(STR_VERSION)+': '+data_download^.album);
    if length(data_download^.artist)>1 then lista.add(GetLangStringA(STR_COMPANY)+': '+data_download^.artist);
    if length(data_download^.language)>1 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_download^.language);
    if length(data_download^.category)>1 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_download^.category);
    if length(data_download^.date)>1 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_download^.date);
    if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
    if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end else
  if data_download^.tipo=5 then begin
      if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
      if length(data_download^.artist)>1 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_download^.artist);
      if length(data_download^.category)>1 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_download^.category);
      if length(data_download^.language)>1 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_download^.language);
      if length(data_download^.date)>1 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_download^.date);
      if data_download^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+': '+inttostr(data_download^.param1)+'x'+inttostr(data_download^.param2));
      if data_download^.param3<>0 then lista.add(GetLangStringA(STR_LENGTH)+': '+format_time(data_download^.param3));
      if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end else
  if data_download^.tipo=6 then begin
    if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
    if length(data_download^.artist)>1 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_download^.artist);
    if length(data_download^.language)>1 then lista.add(GetLangStringA(STR_LANGUAGE)+': '+data_download^.language);
    if length(data_download^.category)>1 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_download^.category);
    if length(data_download^.date)>1 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_download^.date);
    if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
    if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end else
  if data_download^.tipo=7 then begin
      if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
      if length(data_download^.artist)>1 then lista.add(GetLangStringA(STR_AUTHOR)+': '+data_download^.artist);
      if length(data_download^.album)>1 then lista.add(GetLangStringA(STR_ALBUM)+': '+data_download^.album);
      if length(data_download^.category)>1 then lista.add(GetLangStringA(STR_CATEGORY)+': '+data_download^.category);
      if length(data_download^.date)>1 then lista.add(GetLangStringA(STR_DATE_COLUMN)+': '+data_download^.date);
      if data_download^.param1<>0 then lista.add(GetLangStringA(STR_RESOLUTION)+': '+inttostr(data_download^.param1)+'x'+inttostr(data_download^.param2));
        if data_download^.param3=4 then lista.add(GetLangStringA(STR_COLOURS)+': 16') else
        if data_download^.param3=8 then lista.add(GetLangStringA(STR_COLOURS)+': 256') else
        if data_download^.param3=16 then lista.add(GetLangStringA(STR_COLOURS)+': 65K') else
        if data_download^.param3<>0 then lista.add(GetLangStringA(STR_COLOURS)+': 24M'); //'truecolor';
      if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end else
  if data_download^.tipo=0 then begin
     if length(data_download^.title)>1 then lista.add(GetLangStringA(STR_TITLE)+': '+data_download^.title);
     if length(data_download^.comments)>1 then begin
       if length(data_download^.comments)<90 then lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(strip_returns(utf8strtowidestr(data_download^.comments)))) else begin
       comment := strip_returns(utf8strtowidestr(data_download^.comments));
       lista.add(GetLangStringA(STR_COMMENT)+': '+widestrtoutf8str(copy(comment,1,90)));
       delete(comment,1,90);
       repeat
        if length(comment)=0 then break;
         lista.add(' '+widestrtoutf8str(copy(comment,1,90)));
         delete(comment,1,90);
       until (not true);
       end;
      end;
      if length(data_download^.url)>1 then lista.add(GetLangStringA(STR_URL)+': '+data_download^.url);
  end;
end;

function partialuploadhint_show(node:pCmtVnode; DataNode:precord_data_node; lista: TMyStringList): Boolean;
var
data_upload:precord_displayed_download;
node_download:pcmtvnode;
data_parent:precord_displayed_download;
mainDataNode:precord_data_node;

mega:double;

nomefile,
stype,
size,
velocita,
remaining,
size_total,
size_progress,
downloaded,
percent,
status,
widstr: WideString;

ksec:double;
progress:extended;
totx,locx: Integer;
rc: TRect;
i: Integer;
secondi_rimanenti: Integer;
begin
result := False;

 data_upload := dataNode^.data;

 data_parent := nil;
 node_download := ares_frmmain.treeview_download.getFirst;
 while (node_download<>nil) do begin

    mainDataNode := ares_frmmain.treeview_download.getdata(node_download);
    if mainDataNode^.m_type<>dnt_download then begin
     node_download := ares_frmmain.treeview_download.getNextSibling(node_download);
     continue;
    end;

    data_parent := mainDataNode^.data;
    if data_parent^.crcsha1=data_upload^.crcsha1 then
     if data_parent^.hash_sha1=data_upload^.hash_sha1 then break;

    node_download := ares_frmmain.treeview_download.getNextSibling(node_download);
    data_parent := nil;
 end;

 if data_parent=nil then exit;


 vars_global.handle_obj_GraphHint := data_upload^.handle_obj;
 vars_global.graphIsDownload := True; //consumer is thread download
 vars_global.graphIsUpload := False;

 nomefile := data_upload^.nomedisplayw;

if data_upload^.size=0 then begin  //er download
  size_total := STR_NA;
  size := GetLangStringW(STR_SIZE)+': '+STR_NA;
end else
if data_upload^.size<4096 then begin
 size_total := format_currency(data_upload^.size)+' '+STR_BYTES;
 size := GetLangStringW(STR_SIZE)+': '+size_total;
end else
if data_upload^.size<MEGABYTE then begin
 size_total := format_currency(data_upload^.size div KBYTE)+' '+STR_KB;
 size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(data_upload^.size)+' '+STR_BYTES+')';
end else begin
 mega := data_upload^.size/MEGABYTE;
 size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(data_upload^.size)+' '+STR_BYTES+')';
end;

if ((data_upload^.progress<4096) and
    (data_upload^.size<4096) and
    (data_upload^.size>0)) then size_progress := format_currency(data_upload^.progress)+' '+STR_BYTES else
if ((data_upload^.progress<MEGABYTE) and
    (data_upload^.size>0)) then size_progress := format_currency(data_upload^.progress div KBYTE)+' '+STR_KB else
if data_upload^.size>0 then begin
 mega := data_upload^.progress / MEGABYTE;
 size_progress := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
end else size_progress := STR_NA;

stype := GetLangStringW(STR_TYPE)+': '+
                       mediatype_to_str(data_upload^.tipo)+' ('+
                       DocumentToContentType(nomefile)+')';
status := GetLangStringW(STR_STATUS)+': '+
                       helper_download_misc.downloadStatetoStrW(data_upload);


if data_upload^.velocita>0 then begin
   secondi_rimanenti := (data_upload^.size-data_upload^.progress) div data_upload^.velocita;
 ksec := data_upload^.velocita/KBYTE;
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+
                            FloatToStrF(ksec, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+
                            format_time(secondi_rimanenti);
end else begin
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+STR_NA;
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA;
end;

if data_upload^.size=0 then begin
 percent := '';
end else begin
 if data_upload^.size=0 then progress := 1 else progress := (data_upload^.progress/data_upload^.size);
 progress := progress*100;
 percent := ' ('+FloatToStrF(progress, ffNumber, 18, 2)+'%)';
end;

if data_upload^.size=0 then downloaded := GetLangStringW(STR_VOLUME_TRANSMITTED)+': '+STR_NA
 else downloaded := GetLangStringW(STR_VOLUME_TRANSMITTED)+': '+
             size_progress+' '+GetLangStringW(STR_OF)+' '+
             size_total+
             percent;


 //lista.add(GetLangStringA(STR_USER)+': '+widestrtoutf8str(data_upload^.nicknameW));

   ////////// calcolo larghezza massima

      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;



        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,formhint.canvas);    //size
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(status,formhint.canvas);    //status
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(remaining,formhint.canvas);      //remaining
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(velocita,formhint.canvas);      //velocita
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(downloaded,formhint.canvas);    //bandwidths
        locx := 5+locx;
        if locx>totx then totx := locx;


       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;


     formhint.width := totx+5;
     formhint.height := 224; //+(lista.count*14);

   /////////////////////////////////////////////////////////////////////////7

    formhint.canvas.lock;
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));

     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG; //tooltip
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;

     formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-45);


     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;

        //draw first line of text, bold
     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(6,25,46,65);


       ares_frmmain.ImageList_lib_max.draw(formhint.canvas,10,29,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(data_upload^.filename)))),true);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,29, 0, nil, pwidechar(stype),length(stype),nil); //type
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,45, 0, nil, PwideChar(size),length(size),nil);    //size


     formhint.canvas.brush.color := clgray; //second line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 69;
     rc.bottom := 70;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 73, 0, nil, PwideChar(status),Length(status), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 87, 0, nil, PwideChar(velocita),Length(velocita), nil); //size
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 101, 0, nil, PwideChar(remaining),Length(remaining), nil); //size
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 115, 0, nil, PwideChar(downloaded),Length(downloaded), nil); //size

            formhint.canvas.brush.color := clgray; //thirdd line
            formhint.canvas.brush.style := bssolid;
            rc.left := 5;                       //drow first rect
            rc.right := formhint.width-5;
            rc.top := 132;
            rc.bottom := 133;
            formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;

     i := 136;
     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(widstr),Length(widstr), nil); //size
      lista.delete(0);
      inc(i,14);
     until (not true);

     formhint.canvas.brush.color := clgray; //fourth line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := i+3;       //<---------offset
     rc.bottom := i+4;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.Rectangle(5,i+6,formhint.Width-5,i+27);


     formhint.canvas.brush.color := COLOR_PROGRESS_DOWN; //     $00BA3232; //$000030ff;
     formhint.canvas.pen.color := COLOR_PROGRESS_DOWN;
     hint_chunk_draw(rect(3,i+4,formhint.width-2,i+29),0,data_parent^.progress,data_parent^.size,false);


     formhint.canvas.pen.style := pssolid;
     formhint.canvas.brush.color := COLOR_MISSING_CHUNK;
     formhint.canvas.pen.color := COLOR_MISSING_CHUNK;
     formhint.canvas.fillrect(rect(6,i+19,formhint.width-6,i+26));


               // draw ICH bar
          if length(data_parent^.VisualBitField)>0 then begin
           formhint.canvas.brush.color := COLORE_PHASH_VERIFY; //
           formhint.canvas.pen.color := COLORE_PHASH_VERIFY;
           Utility_ares.draw_transfer_bitfield(formhint.canvas,8,rect(3,i+20,formhint.width-3,i+30),data_parent);
          end;
          
        { if data_upload^.endp>0 then begin
                formhint.canvas.brush.color := COLOR_PARTIAL_CHUNK;
                formhint.canvas.pen.color := COLOR_PARTIAL_CHUNK;
                 hint_chunk_draw(rect(3,i+16,formhint.width-2,i+29),data_upload^.startp,data_upload^.endp,data_parent^.size,false);
                  formhint.canvas.brush.color := COLORE_ULSOURCE_CHUNK;
                  formhint.canvas.pen.color := COLORE_ULSOURCE_CHUNK;
                   hint_chunk_draw(rect(3,i+16,formhint.width-2,i+29),data_upload^.startp,data_upload^.startp+data_upload^.progress_child,data_parent^.size,false);
         end;  }




      formhint.posygraph := i+29;
      formhint.canvas.unlock;
      
      Result := True;
end;

function BitTorrentSourcehint_show(node:pCmtVnode; dataNode:precord_data_node; lista: TMyStringList; fromUploadTreeview:boolean): Boolean;
var
dataSource:btcore.precord_Displayed_source;
dataTransfer:precord_displayed_bittorrentTransfer;
datanodeTransfer:precord_data_node;
totx,locx,toty,i: Integer;
fname,strUser,status,bitstatus,progress,transmitted,speed: WideString;
rc: TRect;
ksecUp,ksecDown:extended;
begin
result := False;
dataSource := dataNode^.data;

 if fromUploadTreeview then dataNodeTransfer := ares_frmmain.treeview_upload.getData(node.parent)
  else dataNodeTransfer := ares_frmmain.treeview_download.getData(node.parent);
 dataTransfer := dataNodeTransfer^.data;

 fname := utf8strtowidestr(dataTransfer^.FileName);

vars_global.handle_obj_GraphHint := dataSource.sourceHandle;
vars_global.graphIsDownload := False;
vars_global.graphIsUpload := False;

      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;

      if length(dataSource^.client)>0 then strUser := GetLangStringW(STR_USER)+': '+
                                                    dataSource^.ipS+AddBoolString(':'+inttostr(dataSource.port),(dataSource^.port>0))+'@'+
                                                    dataSource^.client
                                                    else
                                           strUser := GetLangStringW(STR_USER)+': '+
                                                    dataSource^.ipS+AddBoolString(':'+inttostr(dataSource.port),(dataSource^.port>0));

 status := GetLangStringW(STR_STATUS)+': '+BTSourceStatusToStringW(dataSource^.status);

 if dataSource^.status=btSourceConnected then bitstatus := BTBitStatustoString(dataSource);

 if ((dataSource^.progress>0) or (dataSource^.status=btSourceConnected)) then begin
  progress := GetLangStringW(STR_PROGRESS)+': '+inttostr(dataSource^.progress)+'%  ('+BTProgressToFamiltyStrName(dataSource^.progress)+')';
 end;

 if ((dataSource^.recv>0) or (dataSource^.sent>0)) then
  transmitted := GetLangStringW(STR_VOLUME_TRANSMITTED)+': '+
               format_currency(dataSource^.recv div KBYTE)+STR_KB+' '+GetLangStringW(STR_RECEIVED)+' / '+
               format_currency(dataSource^.sent div KBYTE)+STR_KB+' '+GetLangStringW(STR_SENT);

  if ((dataSource^.speedUp>0) or (dataSource^.speedDown>0)) and (dataSource^.status=btSourceConnected) then begin
   ksecUp := dataSource^.speedUp/KBYTE;
   ksecDown := dataSource^.speedDown/KBYTE;
   speed := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+
          ': DL '+FloatToStrF(ksecDown, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC)+
          '   UL '+FloatToStrF(ksecUp, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
  end;

      locx := gettextwidth(strUser,formhint.canvas); //user
      locx := 5+locx;
      if locx>totx then totx := locx;
      locx := gettextwidth(status,formhint.canvas); //status
      locx := 5+locx;
      if locx>totx then totx := locx;
      toty := 57;
      if dataSource^.status=btSourceConnected then begin
       locx := gettextwidth(bitstatus,formhint.canvas); //status
       locx := 5+locx;
       if locx>totx then totx := locx;
       inc(toty,14); // has graph
      end;
      if ((dataSource^.progress>0) or (dataSource^.status=btSourceConnected)) then begin
       locx := gettextwidth(progress,formhint.canvas); //status
       locx := 5+locx;
       if locx>totx then totx := locx;
       inc(toty,44); // has progress
      end;
      if ((dataSource^.recv>0) or (dataSource^.sent>0)) then begin
       locx := gettextwidth(transmitted,formhint.canvas); //status
       locx := 5+locx;
       if locx>totx then totx := locx;
       inc(toty,14);
      end;
      if ((dataSource^.speedUp>0) or (dataSource^.speedDown>0)) and (dataSource.status=btSourceConnected) then begin
       locx := gettextwidth(speed,formhint.canvas); //status
       locx := 5+locx;
       if locx>totx then totx := locx;
       inc(toty,14);
      end;

       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(fname,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;


     formhint.width := totx+5;
     formhint.height := toty;


     formhint.canvas.lock;
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));

     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG; //tooltip
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-1);


     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;
        //draw first line of text, bold
     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(fname),Length(fname), nil); //filename
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 24, 0, nil, PwideChar(strUser),Length(strUser), nil); //user
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 38, 0, nil, PwideChar(status),Length(status), nil); //status
     i := 52;
     if dataSource^.status=btSourceConnected then begin
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(bitstatus),Length(bitstatus), nil); //bitstatus
      inc(i,14);
     end;
     if ((dataSource^.progress>0) or (dataSource^.status=btSourceConnected)) then begin
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(progress),Length(progress), nil); //progress
      inc(i,14);
     end;
     if ((dataSource^.recv>0) or (dataSource^.sent>0)) then begin
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(transmitted),Length(transmitted), nil); //progress
      inc(i,14);
     end;
     if ((dataSource^.speedUp>0) or (dataSource^.speedDown>0)) and (dataSource.status=btSourceConnected) then begin
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(speed),Length(speed), nil); //progress
      inc(i,14);
     end;


            formhint.canvas.brush.color := clgray;
            formhint.canvas.brush.style := bssolid;
            inc(i,4);
            rc.left := 5;
            rc.right := formhint.width-5;
            rc.top := i;
            rc.bottom := i+1;
            formhint.canvas.FillRect(rc);
            inc(i,5);


       rc.left := 5;
       rc.right := formhint.width-5;
       rc.top := i+1;
       rc.bottom := i+20;
       formhint.canvas.brush.color := clwhite;
       formhint.canvas.pen.color := clgray;
       formhint.canvas.rectangle(rc.left,rc.top,rc.right,rc.bottom);
       formhint.canvas.brush.color := clgray;

     // draw bitfield
     if dataSource^.progress=100 then begin
        formhint.canvas.brush.color := COLOR_DL_COMPLETED;
        formhint.canvas.pen.color := COLOR_DL_COMPLETED;
        hint_chunk_draw(rect(3,rc.top-2,formhint.width-2,rc.top+21),0,1000,1000,false);
     end else
     if dataSource^.progress>0 then begin
       rc.top := rc.top+2;
       rc.bottom := rc.bottom+2;
       rc.left := rc.left-2;
       rc.right := rc.right+2;
       draw_transfer_bitfield(formhint.canvas, 17, rc, DataSource);
       //inc(i,25);
     end;



     formhint.posygraph := -1;
     formhint.canvas.Unlock;
     Result := True;

end;

function BitTorrentdownloadhint_show(node:pCmtVnode; dataNode:precord_data_node; lista: TMyStringList; fromUploadTreeview:boolean): Boolean;
var
dataTransfer:precord_displayed_bittorrentTransfer;
fname,stype,size,size_total,status,tracker,peers,speeddn,remaining,
strpercent,size_progress,strDownloaded,strShared: WideString;
locx,totx,emoticx: Integer;
mega,ksec,progress,ratio,ksecUp:extended;
rc: TRect;
secrem: Int64;
begin
result := False;
dataTransfer := dataNode^.data;

fname := utf8strtowidestr(dataTransfer^.FileName);

vars_global.handle_obj_GraphHint := dataTransfer^.handle_obj;
vars_global.graphIsDownload := False;
vars_global.graphIsUpload := False;



stype := GetLangStringW(STR_TYPE)+': BitTorrent';
if dataTransfer^.size=0 then begin 
  size_total := STR_NA;
  size := GetLangStringW(STR_SIZE)+': '+STR_NA;
end else
 if dataTransfer^.size<4096 then begin
  size_total := format_currency(dataTransfer^.size)+' '+STR_BYTES;
  size := GetLangStringW(STR_SIZE)+': '+size_total;
 end else
  if dataTransfer^.size<MEGABYTE then begin
  size_total := format_currency(dataTransfer^.size div KBYTE)+' '+STR_KB;
  size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(dataTransfer^.size)+' '+STR_BYTES+')';
   end else begin
    mega := dataTransfer^.size/MEGABYTE;
    size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
    size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(dataTransfer^.size)+' '+STR_BYTES+')';
  end;

  status := GetLangStringW(STR_STATUS)+': '+
          helper_download_misc.downloadStatetoStrW(dataTransfer);


  tracker := 'Tracker: '+dataTransfer^.trackerStr;

  peers := GetLangStringW(STR_USERS)+': '+
         inttostr(dataTransfer^.NumConnectedSeeders)+'('+format_currency(dataTransfer^.numSeeders)+') Seeds / '+
         inttostr(datatransfer^.NumConnectedLeechers)+'('+format_currency(dataTransfer^.NumLeechers)+') Leechers';


 if ((dataTransfer^.SpeedDl>0) or (dataTransfer.SpeedUl>0)) then begin
   if dataTransfer^.speedDL>0 then secrem := (dataTransfer^.size-dataTransfer^.downloaded) div dataTransfer^.SpeedDl else secrem := 0;
   ksec := dataTransfer^.SpeedDl/KBYTE;
   ksecUp := dataTransfer^.SpeedUl/KBYTE;
   speeddn := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+
            ': DL '+FloatToStrF(ksec, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC)+
            '    UL '+FloatToStrF(ksecUp, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
   if dataTransfer^.speedDL>0 then remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+
                                              format_time(secrem)+'  ('+format_time(dataTransfer.elapsed)+')'
          else
   remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA+'  ('+format_time(dataTransfer.elapsed)+')';
 end else begin
  speeddn := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+STR_NA;
  remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA+'  ('+format_time(dataTransfer.elapsed)+')';
 end;

 if ((dataTransfer^.downloaded<4096) and (dataTransfer^.size<4096) and (dataTransfer^.size>0)) then size_progress := format_currency(dataTransfer^.downloaded)+' '+STR_BYTES else
 if ((datatransfer^.downloaded<MEGABYTE) and (dataTransfer^.size>0)) then size_progress := format_currency(dataTransfer^.downloaded div KBYTE)+' '+STR_KB else
 begin
  mega := dataTransfer^.downloaded / MEGABYTE;
  size_progress := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 end;
 if dataTransfer^.size>0 then progress := (dataTransfer^.downloaded/dataTransfer^.size) else progress := 0;
 progress := progress*100;
 strpercent := ' ('+FloatToStrF(progress, ffNumber, 18, 2)+'%)';
 strdownloaded := GetLangStringW(STR_VOLUME_DOWNLOADED)+': '+
             size_progress+' '+GetLangStringW(STR_OF)+' '+
             size_total+
             Strpercent;

 if dataTransfer^.uploaded<4096 then strShared := format_currency(dataTransfer^.uploaded)+' '+STR_BYTES
  else
   if dataTransfer^.uploaded<MEGABYTE then strShared := format_Currency(dataTransfer^.uploaded div KBYTE)+' '+STR_KB
    else begin
      mega := dataTransfer^.uploaded / MEGABYTE;
      strShared := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
    end;

    if ((dataTransfer^.downloaded=0) or (dataTransfer^.uploaded=0)) then
    strShared := GetLangStringW(STR_SHARED)+': '+strShared
     else begin
      ratio := (dataTransfer^.uploaded/dataTransfer^.downloaded);
      strShared := GetLangStringW(STR_SHARED)+': '+strShared+'  Ratio: '+FloatToStrF(ratio, ffNumber, 18, 2);
     end;

      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];

      //calculate hint window's dimensions
      totx := 0;

        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 51+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(size,formhint.canvas);  //size
        locx := 51+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(status,formhint.canvas);  //status
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(tracker,formhint.canvas);  //tracker
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(peers,formhint.canvas);  //peers
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(speeddn,formhint.canvas);  //speed
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(remaining,formhint.canvas);  //remaining
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(strDownloaded,formhint.canvas);  //downloaded
        locx := 5+locx;
        if locx>totx then totx := locx;
        locx := gettextwidth(strShared,formhint.canvas);  //shared
        emoticx := locx+7;
        locx := 27+locx;
        if locx>totx then totx := locx;


        // fname font is bold
        if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
        locx := gettextwidth(fname,formhint.canvas);
        locx := 5+locx;
        if locx>totx then totx := locx;

       //resize hint window
       formhint.width := totx+5;
       formhint.height := 212;


       
       //start drawing
     formhint.canvas.lock;
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));

     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG; //tooltip
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-1);


     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;

        //draw first line of text, bold
     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(fname),Length(fname), nil); //status
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;

     //draw first rect
     rc.left := 5;
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);

     //draw icon rectangle
     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(6,25,46,65);

     //draw icon
     ares_frmmain.ImageList_lib_max.draw(formhint.canvas,10,29,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(dataTransfer^.FileName)))),true);

     // write text (type and size
     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,29, 0, nil, pwidechar(stype),length(stype),nil); //type
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,45, 0, nil, PwideChar(size),length(size),nil);    //size

     // draw second line
     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;
     rc.right := formhint.width-5;
     rc.top := 69;
     rc.bottom := 70;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;

     // write status and tracker text
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 73, 0, nil, PwideChar(status),Length(status), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 87, 0, nil, PwideChar(tracker),Length(tracker), nil); //tracker
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 101, 0, nil, PwideChar(peers),Length(peers), nil); //peers

     // draw third rect
     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;
     rc.right := formhint.width-5;
     rc.top := 119;
     rc.bottom := 120;
     formhint.canvas.FillRect(rc);
     formhint.canvas.brush.style := bsclear;

     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 122, 0, nil, PwideChar(speedDn),Length(speedDn), nil); //speed
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 136, 0, nil, PwideChar(remaining),Length(remaining), nil); //speed
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 150, 0, nil, PwideChar(strDownloaded),Length(strDownloaded), nil); //downloaded
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 164, 0, nil, PwideChar(strShared),Length(strShared), nil); //shared

     // draw ratio emoticons
     ares_frmmain.ImgList_emotic.draw(formhint.canvas,emoticx,162,BTRatioToEmotIndex(dataTransfer^.uploaded,dataTransfer^.downloaded),true);



      formhint.canvas.brush.color := clgray;
      formhint.canvas.brush.style := bssolid;

      //draw fourth rect
      rc.left := 5;
      rc.right := formhint.width-5;
      rc.top := 181;
      rc.bottom := 182;
      formhint.canvas.FillRect(rc);

      // draw progressbar box
       rc.left := 5;
       rc.right := formhint.width-5;
       rc.top := 187;
       rc.bottom := 206;
       formhint.canvas.brush.color := clwhite;
       formhint.canvas.pen.color := clgray;
       formhint.canvas.rectangle(rc.left,rc.top,rc.right,rc.bottom);
       formhint.canvas.brush.color := clgray;

       //draw bitfield
     if dataTransfer^.downloaded=dataTransfer^.size then begin
        formhint.canvas.brush.color := COLOR_DL_COMPLETED;
        formhint.canvas.pen.color := COLOR_DL_COMPLETED;
        hint_chunk_draw(rect(3,rc.top-2,formhint.width-2,rc.top+21),0,1000,1000,false);
    end else
    if dataTransfer^.downloaded>0 then begin
       rc.top := rc.top+2;
       rc.bottom := rc.bottom+2;
       rc.left := rc.left-2;
       rc.right := rc.right+2;
       draw_transfer_bitfield(formhint.canvas, 17, rc, DataTransfer);

       // draw progress bar
       formhint.canvas.brush.color := COLORE_PHASH_VERIFY; //
       formhint.canvas.pen.color := COLORE_PHASH_VERIFY;
       draw_3d_progress(formhint.canvas, 6, rc, DataTransfer^.downloaded, DataTransfer^.size);
     end;



     //unlock canvas, remove graph and exit
     formhint.posygraph := -1;
     formhint.canvas.Unlock;
     Result := True;
end;

function downloadhint_show(dataSource:precord_displayed_downloadsource; dataDownload:Precord_displayed_download; lista: TMyStringList): Boolean;
var
nomefile,size_total,sizeW,size_progress,status,nickname,downloaded,percent,velocita,remaining: WideString;
mega,progress,ksec:double;
locx,totx,hareaprogress,secondi_rimanenti: Integer;
rc: TRect;
begin
result := False;

 vars_global.handle_obj_GraphHint := dataSource^.handle_obj;
 vars_global.graphIsDownload := True; //consumer is thread download
 vars_global.graphIsUpload := False;

 nomefile := dataSource^.nomedisplayw;

 if dataSource^.size=0 then begin  //er download
  size_total := STR_NA;
  sizeW := GetLangStringW(STR_SIZE)+': '+STR_NA;
 end else
 if dataSource^.size<4096 then begin
  size_total := format_currency(dataSource^.size)+' '+STR_BYTES;
  sizeW := GetLangStringW(STR_SIZE)+': '+size_total;
 end else
 if dataSource^.size<MEGABYTE then begin
  size_total := format_currency(dataSource^.size div KBYTE)+' '+STR_KB;
  sizeW := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(dataSource^.size)+' '+STR_BYTES+')';
 end else begin
  mega := dataSource^.size/MEGABYTE;
  size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
  sizeW := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(dataSource^.size)+' '+STR_BYTES+')';
 end;


 if ((dataSource^.progress<4096) and
     (dataSource^.size<4096) and
     (dataSource^.size>0)) then size_progress := format_currency(dataSource^.progress)+' '+STR_BYTES
     else
     if ((dataSource^.progress<MEGABYTE) and
         (dataSource^.size>0)) then size_progress := format_currency(dataSource^.progress div KBYTE)+' '+STR_KB
         else
         if dataSource^.size>0 then begin
          mega := dataSource^.progress / MEGABYTE;
          size_progress := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
        end else size_progress := STR_NA;


if dataSource^.size=0 then percent := ''
 else begin
 if dataSource^.size=0 then progress := 1 else progress := (dataSource^.progress/dataSource^.size);
  progress := progress*100;
  percent := ' ('+FloatToStrF(progress, ffNumber, 18, 2)+'%)';
 end;

if dataSource^.size=0 then downloaded := GetLangStringW(STR_VOLUME_DOWNLOADED)+': '+STR_NA
 else downloaded := GetLangStringW(STR_VOLUME_DOWNLOADED)+': '+
             size_progress+' '+GetLangStringW(STR_OF)+' '+
             size_total+
             percent;

if dataSource^.speed>0 then begin
 secondi_rimanenti := (dataSource^.size-dataSource^.progress) div dataSource^.speed;
 ksec := dataSource^.speed/KBYTE;
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+
                            FloatToStrF(ksec, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+
                            format_time(secondi_rimanenti);
end else begin
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+STR_NA;
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA;
end;

status := GetLangStringW(STR_STATUS)+': '+
                       helper_download_misc.SourceStatetoStrW(dataSource);
nickname := GetLangStringW(STR_USER)+': '+utf8strtowidestr(dataSource^.nickname)+' '+dataSource^.versionS;

      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;


      locx := gettextwidth(downloaded,formhint.canvas); //progress
      locx := 5+locx;
      if locx>totx then totx := locx;

      locx := gettextwidth(status,formhint.canvas); //status
      locx := 5+locx;
      if locx>totx then totx := locx;

      locx := gettextwidth(nickname,formhint.canvas); //nickname
      locx := 5+locx;
      if locx>totx then totx := locx;

      locx := gettextwidth(velocita,formhint.canvas); //speed
      locx := 5+locx;
      if locx>totx then totx := locx;

      locx := gettextwidth(remaining,formhint.canvas); //remaining
      locx := 5+locx;
      if locx>totx then totx := locx;

       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //filename bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

      if ((dataSource^.state<>srs_receiving) and (dataSource^.state<>srs_UDPDownloading)) then hareaprogress := 0
       else hareaprogress := 70;


     formhint.width := totx+5;
     formhint.height := 99+hareaprogress;


     formhint.canvas.lock;
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));

     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG; //tooltip
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     if dataSource^.state<>srs_receiving then formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-1)
      else formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-45);


     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;
        //draw first line of text, bold
     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //filename
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 25, 0, nil, PwideChar(nickname),Length(nickname), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 39, 0, nil, PwideChar(status),Length(status), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 53, 0, nil, PwideChar(downloaded),Length(downloaded), nil); //downloaded
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 67, 0, nil, PwideChar(velocita),Length(velocita), nil); //downloaded
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 81, 0, nil, PwideChar(remaining),Length(remaining), nil); //downloaded

     if ((dataSource^.state<>srs_receiving) and (dataSource^.state<>srs_UDPDownloading)) then begin
       formhint.posygraph := -1;
       formhint.canvas.unlock;
       Result := True;
       exit;
     end;

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //draw second rect
     rc.right := formhint.width-5;
     rc.top := 98;
     rc.bottom := 99;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.Rectangle(5,101,formhint.Width-5,122);
     formhint.canvas.brush.color := COLORE_DLSOURCE;
     formhint.canvas.pen.color := COLORE_DLSOURCE;
     hint_chunk_draw(rect(3,99,formhint.width-2,123),0,dataSource^.progress,dataSource^.size,false);

     
     // draw gray chunk bar
     formhint.canvas.pen.style := pssolid;
     formhint.canvas.brush.color := COLOR_MISSING_CHUNK;
     formhint.canvas.pen.color := COLOR_MISSING_CHUNK;
     formhint.canvas.fillrect(rect(6,114,formhint.width-6,121));


     // draw our position in file
     formhint.canvas.brush.color := COLOR_PARTIAL_CHUNK;
     formhint.canvas.pen.color := COLOR_PARTIAL_CHUNK;
     hint_chunk_draw(rect(3,111,formhint.width-2,124),dataSource^.startp,dataSource^.endp,datadownload^.size,false);
     formhint.canvas.brush.color := COLORE_DLSOURCE;
     formhint.canvas.pen.color := COLORE_DLSOURCE;
     hint_chunk_draw(rect(3,111,formhint.width-2,124),dataSource^.startp,dataSource^.startp+dataSource^.progress,datadownload^.size,false);


               // draw ICH bar
      if length(datadownload^.VisualBitField)>0 then begin
       formhint.canvas.brush.color := COLORE_PHASH_VERIFY; //
       formhint.canvas.pen.color := COLORE_PHASH_VERIFY;
       Utility_ares.draw_transfer_bitfield(formhint.canvas,8,rect(3,119,formhint.width-3,125),datadownload);
      end;

     formhint.posygraph := 124;
     formhint.canvas.unlock;

     Result := True;
end;

function downloadhint_show(node:pCmtVnode; lista: TMyStringList): Boolean;
var
data_download:precord_displayed_download;
data_child:precord_displayed_downloadsource;
dataNode:precord_data_node;
node_child:pCmtVnode;
dataSource:precord_displayed_downloadsource;
mega:double;

nomefile,
stype,
size,
velocita,
remaining,
size_total,
sources,
size_progress,
downloaded,
percent,
status,
widstr,
str_nickname: WideString;
str_parz_sources: string;

ksec:double;
progress:extended;
totx,locx: Integer;
rc: TRect;
i: Integer;
hareaprogress: Integer;

secondi_rimanenti: Integer;
begin
result := False;

try
 dataNode := ares_frmmain.treeview_download.getdata(node);

 if dataNode^.m_type=dnt_bittorrentMain then begin
  Result := BitTorrentdownloadhint_show(node,dataNode,lista,false);
  exit;
 end;

 if dataNode^.m_type=dnt_bittorrentSource then begin
  Result := BitTorrentSourcehint_show(node,dataNode,lista,false);
  exit;
 end;

if dataNode^.m_type=dnt_downloadSource then begin {ares_frmmain.treeview_download.getnodelevel(node)>0}
 dataSource := dataNode^.data;
  dataNode := ares_frmmain.treeview_download.getdata(node.parent);
  data_download := dataNode^.data;
 Result := downloadhint_show(dataSource,data_download,lista);
 exit;
end;

 if dataNode^.m_type<>dnt_download then exit;
 
 data_download := dataNode^.data;


 vars_global.handle_obj_GraphHint := data_download^.handle_obj;
 vars_global.graphIsDownload := True; //consumer is thread download
 vars_global.graphIsUpload := False;

 nomefile := data_download^.nomedisplayw;


if data_download^.size=0 then begin  //er download
  size_total := STR_NA;
  size := GetLangStringW(STR_SIZE)+': '+STR_NA;
end else
if data_download^.size<4096 then begin
 size_total := format_currency(data_download^.size)+' '+STR_BYTES;
 size := GetLangStringW(STR_SIZE)+': '+size_total;
end else
if data_download^.size<MEGABYTE then begin
 size_total := format_currency(data_download^.size div KBYTE)+' '+STR_KB;
 size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(data_download^.size)+' '+STR_BYTES+')';
end else begin
 mega := data_download^.size/MEGABYTE;
 size_total := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
 size := GetLangStringW(STR_SIZE)+': '+size_total+'  ('+
                        format_currency(data_download^.size)+' '+STR_BYTES+')';
end;

if ((data_download^.progress<4096) and (data_download^.size<4096) and (data_download^.size>0)) then size_progress := format_currency(data_download^.progress)+' '+STR_BYTES else
if ((data_download^.progress<MEGABYTE) and (data_download^.size>0)) then size_progress := format_currency(data_download^.progress div KBYTE)+' '+STR_KB else
if data_download^.size>0 then begin
 mega := data_download^.progress / MEGABYTE;
 size_progress := FloatToStrF(mega, ffNumber, 18, 2)+' '+STR_MB;
end else size_progress := STR_NA;

stype := GetLangStringW(STR_TYPE)+': '+
                       mediatype_to_str(data_download^.tipo)+' ('+
                       DocumentToContentType(nomefile)+')';
status := GetLangStringW(STR_STATUS)+': '+
                       helper_download_misc.downloadStatetoStrW(data_download);


if data_download^.velocita>0 then begin
   secondi_rimanenti := (data_download^.size-data_download^.progress) div data_download^.velocita;
 ksec := data_download^.velocita/KBYTE;
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+
                            FloatToStrF(ksec, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC);
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+
                            format_time(secondi_rimanenti);
end else begin
 velocita := GetLangStringW(STR_TOTAL_TRANSFER_SPEED)+': '+STR_NA;
 remaining := GetLangStringW(STR_ESTIMATED_TIME_REMAINING)+': '+STR_NA;
end;

if data_download^.size=0 then begin
 percent := '';
end else begin
 if data_download^.size=0 then progress := 1 else progress := (data_download^.progress/data_download^.size);
 progress := progress*100;
 percent := ' ('+FloatToStrF(progress, ffNumber, 18, 2)+'%)';
end;

if data_download^.size=0 then downloaded := GetLangStringW(STR_VOLUME_DOWNLOADED)+': '+STR_NA
 else downloaded := GetLangStringW(STR_VOLUME_DOWNLOADED)+': '+
             size_progress+' '+GetLangStringW(STR_OF)+' '+
             size_total+
             percent;


 if data_download^.num_partial_sources>0 then str_parz_sources := '+'+inttostr(data_download^.num_partial_sources)+'P'
  else str_parz_sources := '';

 if data_download^.num_sources=0 then sources := GetLangStringW(STR_NUMBER_OF_SOURCES)+': 0'+str_parz_sources else
 if data_download^.num_sources=1 then sources := GetLangStringW(STR_NUMBER_OF_SOURCES)+': 1'+str_parz_sources+str_nickname else
 sources := GetLangStringW(STR_NUMBER_OF_SOURCES)+': '+
                           inttostr(data_download^.num_sources)+
                           str_parz_sources+
                           str_nickname;

fill_download_hint_details(data_download,lista);


  ////////// calcolo larghezza massima

      formhint.canvas.font.name := formhint.font.name;
      formhint.canvas.font.size := formhint.font.size;
      formhint.canvas.Font.style := [];
      totx := 0;
      for i := 0 to lista.count -1 do begin
       locx := gettextwidth(utf8strtowidestr(lista.strings[i]),formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;
      end;



        locx := gettextwidth(stype,formhint.canvas); //type
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(size,formhint.canvas);    //size
        locx := 51+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(sources,formhint.canvas);   //sources
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(status,formhint.canvas);    //status
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(remaining,formhint.canvas);      //remaining
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(velocita,formhint.canvas);      //velocita
        locx := 5+locx;
        if locx>totx then totx := locx;

        locx := gettextwidth(downloaded,formhint.canvas);    //bandwidths
        locx := 5+locx;
        if locx>totx then totx := locx;


       if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];  //titolo bold
       locx := gettextwidth(nomefile,formhint.canvas);
       locx := 5+locx;
       if locx>totx then totx := locx;

      if data_download^.state<>dlDownloading then hareaprogress := 27
       else hareaprogress := 70;
      // hareaprogress := 70;
       //progress bar total e eventualmente progress local+indicazione speed local +indicazione user + graph

     formhint.width := totx+5;
     formhint.height := 154+hareaprogress+(lista.count*14);

   /////////////////////////////////////////////////////////////////////////7

    formhint.canvas.lock;
     formhint.canvas.brush.color := clgray;
     formhint.canvas.framerect(rect(0,0,formhint.width,formhint.height));

     formhint.canvas.pen.color := vars_global.COLORE_HINT_BG; //tooltip
     formhint.canvas.brush.color := vars_global.COLORE_HINT_BG;
     if data_download^.state<>dlDownloading then begin
      formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-1);
    end else begin
      formhint.canvas.rectangle(1,1,formhint.width-1,formhint.height-45);
     end;

     formhint.canvas.pen.color := clgray;
     formhint.canvas.brush.style := bsclear;

        //draw first line of text, bold
     if (Win32Platform=VER_PLATFORM_WIN32_NT) then formhint.canvas.Font.style := [fsbold];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 4, 0, nil, PwideChar(nomefile),Length(nomefile), nil); //status
     formhint.canvas.font.style := [];

     formhint.canvas.brush.color := clgray;
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 20;
     rc.bottom := 21;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.rectangle(6,25,46,65);


       ares_frmmain.ImageList_lib_max.draw(formhint.canvas,10,29,aresmime_to_imgindexbig(extstr_to_mediatype(lowercase(extractfileext(data_download^.filename)))),true);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,29, 0, nil, pwidechar(stype),length(stype),nil); //type
     Windows.ExtTextOutW(formhint.canvas.Handle, 51,45, 0, nil, PwideChar(size),length(size),nil);    //size


     formhint.canvas.brush.color := clgray; //second line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := 69;
     rc.bottom := 70;
     formhint.canvas.FillRect(rc);

     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];

     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 73, 0, nil, PwideChar(status),Length(status), nil); //status
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 87, 0, nil, PwideChar(velocita),Length(velocita), nil); //size
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 101, 0, nil, PwideChar(remaining),Length(remaining), nil); //size
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 115, 0, nil, PwideChar(downloaded),Length(downloaded), nil); //size
     Windows.ExtTextOutW(formhint.canvas.Handle, 5, 129, 0, nil, PwideChar(sources),Length(sources), nil); //size


            formhint.canvas.brush.color := clgray; //thirdd line
            formhint.canvas.brush.style := bssolid;
            rc.left := 5;                       //drow first rect
            rc.right := formhint.width-5;
            rc.top := 146;
            rc.bottom := 147;
            formhint.canvas.FillRect(rc);


     formhint.canvas.brush.style := bsclear;
     formhint.canvas.Font.style := [];
     formhint.canvas.Font.color := vars_global.COLORE_HINT_FONT;

     i := 150;
     repeat
      if lista.count=0 then break;
      widstr := utf8strtowidestr(lista.strings[0]);
      Windows.ExtTextOutW(formhint.canvas.Handle, 5, i, 0, nil, PwideChar(widstr),Length(widstr), nil); //size
      lista.delete(0);
      inc(i,14);
     until (not true);

     formhint.canvas.brush.color := clgray; //fourth line
     formhint.canvas.brush.style := bssolid;
     rc.left := 5;                       //drow first rect
     rc.right := formhint.width-5;
     rc.top := i+3;       //<---------offset
     rc.bottom := i+4;
     formhint.canvas.FillRect(rc);





     formhint.canvas.brush.color := $00FEFFFF;
     formhint.canvas.Rectangle(5,i+6,formhint.Width-5,i+27);

     if data_download^.state=dlCompleted then begin
        formhint.canvas.brush.color := COLOR_DL_COMPLETED;
        formhint.canvas.pen.color := COLOR_DL_COMPLETED;
        hint_chunk_draw(rect(3,i+4,formhint.width-2,i+29),0,1000,1000,false);
    end else begin
        formhint.canvas.brush.color := COLOR_PROGRESS_DOWN; //     $00BA3232; //$000030ff;
        formhint.canvas.pen.color := COLOR_PROGRESS_DOWN;
        hint_chunk_draw(rect(3,i+4,formhint.width-2,i+29),0,data_download^.progress,data_download^.size,false);



     formhint.canvas.pen.style := pssolid;
     formhint.canvas.brush.color := COLOR_MISSING_CHUNK;
     formhint.canvas.pen.color := COLOR_MISSING_CHUNK; //cl3dlight;
     formhint.canvas.fillrect(rect(6,i+19,formhint.width-6,i+26));
    end;




if data_download^.state<>dlCompleted then begin


//draw child sources
       if node.childcount>0 then begin
           node_child := ares_frmmain.treeview_download.getfirstchild(node);
           while (node_child)<>nil do begin
               dataNode := ares_frmmain.treeview_download.getdata(node_child);
               data_child := dataNode^.data;
               if ((data_child^.state=srs_receiving) or (data_child^.state=srs_UDPDownloading)) then begin
                if data_child^.endp>0 then begin
                 formhint.canvas.brush.color := COLOR_PARTIAL_CHUNK; //     $00BA3232; //$000030ff;
                 formhint.canvas.pen.color := COLOR_PARTIAL_CHUNK;
                  hint_chunk_draw(rect(3,i+16,formhint.width-2,i+29),data_child^.startp,data_child^.endp,data_download^.size,false);
                   formhint.canvas.brush.color := COLORE_DLSOURCE; //     $00BA3232; //$000030ff;
                   formhint.canvas.pen.color := COLORE_DLSOURCE;
                    hint_chunk_draw(rect(3,i+16,formhint.width-2,i+29),data_child^.startp,data_child^.startp+data_child^.progress,data_download^.size,false);
                 end;
                end;
            node_child := ares_frmmain.treeview_download.getnextsibling(node_child);
           end;
       end;
end; //if not completed



          // draw ICH bar
          if length(data_download^.VisualBitField)>0 then begin
           formhint.canvas.brush.color := COLORE_PHASH_VERIFY; //
           formhint.canvas.pen.color := COLORE_PHASH_VERIFY;
           Utility_ares.draw_transfer_bitfield(formhint.canvas,8,rect(3,i+20,formhint.width-3,i+30),data_download);
          end;

                   

          if data_download^.state<>dlDownloading then begin
            formhint.posygraph := -1; // nasconde il grafico
            formhint.canvas.Unlock;
            Result := True;
            exit;
          end;

      formhint.posygraph := i+29;
      formhint.canvas.unlock;
      Result := True;
except
end;
end;


function availibility_to_str(aval:word): WideString;
begin
 if aval=0 then Result := GetLangStringW(STR_OFFLINE)+' ('+inttostr(aval)+')' else
 if aval=1 then Result := GetLangStringW(STR_POOR)+' ('+inttostr(aval)+')' else
 if aval<10 then Result := GetLangStringW(STR_AVERAGE)+' ('+inttostr(aval)+')' else
 if aval<50 then Result := GetLangStringW(STR_GOOD)+' ('+inttostr(aval)+')' else
 Result := GetLangStringW(STR_VERYGOOD)+' ('+inttostr(aval)+')';
end;

function availibility_to_point(aval:word): Byte;
begin
 if aval<2 then Result := 1 else
 if aval<10 then Result := 2 else
 if aval<80 then Result := 3 else
 Result := 4;
end;

end.
