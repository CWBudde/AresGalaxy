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
generic code related to UI
}

unit helper_GUI_misc;

interface

uses
 classes,classes2,registry,windows,forms,ares_types,DSPack,activex,MSHTML,cometPageView,
 sysutils,graphics,comettopicpnl,ExtCtrls,Controls,xpbutton,TntStdCtrls,node_upgrade,
 messages;

procedure mainGui_applycolor;
procedure mainGUI_screenlogo_init;
procedure mainGui_sizectrls;
procedure mainGui_applyChanges;
procedure mainGui_applychatfont;   //questo viene chiamato dopo di localizzazione ed eventualmente legge preset dell'utente riguardo al font
procedure mainGui_applyfont;
procedure mainGui_applymaxlengths;
procedure choose_nickname_prompt;
procedure mainGui_setposition;
procedure mainGui_saveposition;


procedure mainGui_showsearch;
procedure mainGui_showlibrary;
procedure mainGui_showoptions;
procedure mainGui_showtransfer;
procedure mainGui_showscreen;
procedure mainGui_showchat;
//procedure mainGui_togglechats(lista_canali: Boolean; should_set_glyph: Boolean; pnl: TCometPagePanel);

procedure mainGui_refresh_caption; overload; // per special caption crazy maniak
procedure mainGUI_refresh_Caption(invalidateit:boolean); overload;
procedure scan_in_progress_caption;
procedure showMainWindow;
procedure init_tabs_second;
procedure init_tabs_first;


implementation

uses
 ufrmmain,vars_global,const_ares,helper_unicode,vars_localiz,
 helper_registry,helper_diskio,helper_bighints,
 helper_combos,utility_ares,helper_datetime,
 comettrees,helper_params,helper_search_gui,
 helper_visual_headers,helper_chat_favorites,
 helper_player,helper_skin,helper_channellist,
 helper_strings,ufrm_settings;


procedure showMainWindow;
begin
 //Sho/wWindow(mainfrm,SW_RESTORE);
 //SetForegroundWindow(mainfrm);
// postmessage(mainfrm,WM_USERSHOW,0,0);
 if widestrtoutf8str(ares_frmmain.tray_minimize.caption)=GetLangStringA(STR_HIDE_ARES) then begin
  SetForegroundWindow(ares_frmmain.handle);
 end else begin
  ufrmmain.ares_frmmain.tray_MinimizeClick(nil);
 end;
end;

procedure scan_in_progress_caption;
begin
try

if share<>nil then begin
 ares_frmmain.panel_hash.capt := ' '+GetLangStringW(STR_SCAN_IN_PROGRESS)+
                               '   '+format_time((gettickcount-scan_start_time) div 1000); //
end;

except
end;
end;

procedure mainGui_showchat;
var
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin
application.OnMessage := nil;
switch_pause_media;

unbold_results;
vars_global.was_on_src_tab := False;


formhint_hide;

//ufrmmain.ares_frmmain.btn_list_channel_toolbarClick(ares_frmmain.panel_chat.activepage);


ufrmmain.ares_frmmain.panel_chatResize(ares_frmmain.panel_list_channels);
//ufrmmain.ares_frmmain.btn_list_channel_toolbarClick(ares_frmmain.panel_chat.ActivePage);

if not ever_pressed_chat_list then begin
 ares_frmmain.panel_chat.ActivePage := 0;
 ares_frmmain.btns_chat.visible := True;
 ares_frmmain.btn_chat_join.left := ares_frmmain.btn_chat_refchanlist.left+ares_frmmain.btn_chat_refchanlist.width+2;
 ares_frmmain.edit_chat_chanfilter.left := ares_frmmain.btn_chat_join.left+ares_frmmain.btn_chat_join.width+10;
 ares_frmmain.btn_chat_fav.left := ares_frmmain.edit_chat_chanfilter.left+ares_frmmain.edit_chat_chanfilter.width+10;
 ares_frmmain.btn_chat_host.left := ares_frmmain.btn_chat_fav.left+ares_frmmain.btn_chat_fav.width+2;
 //mainGui_togglechats(nil,true,false,nil);
 
 ever_pressed_chat_list := True;

 ares_frmmain.listview_chat_channel.header.columns.items[0].width := ares_frmmain.listview_chat_channel.width;
 //ufrmmain.ares_frmmain.btn_chat_favClick(ares_frmmain.btn_chat_fav);

 ufrmmain.ares_frmmain.btn_chat_refchanlistClick(nil);

 if ares_frmmain.edit_chat_chanfilter.glyphIndex=0 then begin
  ares_frmmain.edit_chat_chanfilter.glyphIndex := 12;
  ares_frmmain.edit_chat_chanfilter.text := GetLangStringW(STR_FILTER);
 end;

end else begin
 //ufrmmain.ares_frmmain.panel_chatPanelShow(ares_frmmain.panel_chat,ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage]);
end;
 mainGui_refresh_caption;

 if ares_frmmain.panel_chat.activePage<>0 then begin
   try
   pnl := ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
   if pnl.ID<>IDXChatMain then exit;
   pnl.FImageIndex := 2;
   processData := pnl.fdata;
   SetWindowPos(processData^.wnhandle,0,0,0,processData^.containerPnl.ClientWidth,processData^.containerPnl.ClientHeight,SWP_NOZORDER);
   SetForegroundWindow(processData.wnhandle);
   if not helper_skin.skinnedFrameLoaded then SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, 1, 0);
   helper_channellist.SendNoticeHasFocus(pnl);
   except
   end;
 end;
end;

{procedure mainGui_togglechats(lista_canali: Boolean; should_set_glyph: Boolean; pnl: TCometPagePanel);
begin
with ares_frmmain do begin

if ares_frmmain.tabs_pageview.activepage<>IDTAB_CHAT then exit; //se non sto guardando chat, qui mi crea casini con labels...


if lista_canali then begin

 if edit_chat_chanfilter.glyphIndex=0 then begin
  edit_chat_chanfilter.glyphIndex := 12;
  edit_chat_chanfilter.text := GetLangStringW(STR_FILTER);
 end;


     btn_chat_join.visible := True; //.top := 1;
     btn_chat_refchanlist.visible := True; //.top := 1;
    // btn_chat_host.visible := False; //.top := 10000;
     btn_chat_refchanlist.left := 10;
     btn_chat_join.left := btn_chat_refchanlist.left+btn_chat_refchanlist.width+3;

    lbl_chat_capt.visible := False;
    edit_chat_chanfilter.visible := True; //.top := 4;
    edit_chat_chanfilter.left := btn_chat_join.left+btn_chat_join.width+10;


   btn_chat_fav.visible := True;
   btn_chat_host.visible := True;

   btn_chat_fav.left := edit_chat_chanfilter.left+edit_chat_chanfilter.width+10;
   btn_chat_host.left := (btn_chat_fav.left+btn_chat_fav.width)+15;
    exit;
end else begin //solo part channel se sono in canale
 // btn_chat_host.visible := False; //.top := 10000;
  btn_chat_refchanlist.visible := False; //.top := 10000;
  btn_chat_join.visible := False; //.top := 10000;
  edit_chat_chanfilter.visible := False; //.Top := 10000;
   btn_chat_fav.visible := False;
   btn_chat_host.visible := False;
end;


   if pnl=nil then lbl_chat_capt.visible := false
   else begin

   end;

end;

end;}

procedure mainGUI_refresh_Caption(invalidateit:boolean);
begin
with ares_frmmain do begin
 if ((not vars_global.check_opt_gen_capt_checked) and (not invalidateit)) then exit;

  mainGui_refresh_caption;

end;
end;

procedure init_tabs_first;
begin
with ares_frmmain do begin
 panel_chat.AddPanel(IDNone,'',[cometpageview.csDown],panel_list_channels,nil,false,-1); //need to do it here because we're assigning a caption in load language



 pagesrc.AddPanel(IDNone,'New Search',[cometpageview.csDown],panel_src_default,nil,false,-1);
 pagesrc.activePage := 0;
 
end;
end;

procedure init_tabs_second;
var
pnl: Tpanel;
begin

   ares_frmmain.tabs_pageview.drawMargin := True;
   ares_frmmain.tabs_pageview.switchOnDown := False;

   //library
  pnl := tpanel.create(ares_frmmain);
   pnl.caption := '';
   pnl.FullRepaint := False;
   pnl.BevelOuter := bvnone;
   ares_frmmain.tabs_pageview.AddPanel(IdxBtnLibrary,GetLangStringW(STR_LIBRARY),[],pnl,nil,false,-1);
   pnl.OnResize := ufrmmain.ares_frmmain.libraryOnResize;
   ares_frmmain.btns_library.parent := pnl;
   ares_frmmain.btns_library.align := alTop;
   ares_frmmain.listview_lib.parent := pnl;
   ares_frmmain.splitter_library.parent := pnl;
   ares_frmmain.panel_details_library.parent := pnl;
   ares_frmmain.treeview_lib_virfolders.parent := pnl;
   ares_frmmain.treeview_lib_regfolders.parent := pnl;
   ares_frmmain.panel_hash.parent := pnl;

   //screen
   ares_frmmain.tabs_pageview.AddPanel(IdxBtnScreen,GetLangStringW(STR_SCREEN),[],ares_frmmain.panel_screen,nil,false,-1);
  // ares_frmmain.panel_vid.Parent := ares_frmmain.tabs_pageview;

   //search
  pnl := tpanel.create(ares_frmmain);
   pnl.caption := '';
   pnl.FullRepaint := False;
   pnl.BevelOuter := bvnone;
   ares_frmmain.tabs_pageview.AddPanel(IdxBtnSearch,GetLangStringW(STR_SEARCH),[],pnl,nil,false,-1);
   pnl.OnResize := ufrmmain.ares_frmmain.resizeSearch;
   ares_frmmain.panel_search.Parent := pnl;
   ares_frmmain.panel_search.align := alLeft; //left := 0;
  // ares_frmmain.panel_search.top := ares_frmmain.btns_search.height;
   ares_frmmain.pagesrc.left := ares_frmmain.panel_search.width+1;
   ares_frmmain.pagesrc.parent := pnl;
   ares_frmmain.pagesrc.align := alClient; //left := ares_frmmain.panel_search.width+1;
   //ares_frmmain.pagesrc.top := ares_frmmain.btns_search.height;


  // transfer
  pnl := tpanel.create(ares_frmmain);
   pnl.caption := '';
   pnl.FullRepaint := False;
   pnl.BevelOuter := bvnone;
  ares_frmmain.tabs_pageview.AddPanel(IdxBtnTransfer,GetLangStringW(STR_TRANSFER),[],pnl,nil,false,-1);

  ares_frmmain.btns_transfer.parent := pnl;
  ares_frmmain.btns_transfer.align := altop;
  ares_frmmain.panel_transfer.parent := pnl;
  ares_frmmain.panel_transfer.top := ares_frmmain.btns_transfer.height;
  ares_frmmain.panel_transfer.align := alclient;

   // chat
   pnl := tpanel.create(ares_frmmain);
   pnl.caption := '';
   pnl.FullRepaint := False;
   pnl.BevelOuter := bvnone;
   ares_frmmain.tabs_pageview.AddPanel(IdxBtnChat,GetLangStringW(STR_CHAT),[],pnl,nil,false,-1);
   ares_frmmain.panel_chat.parent := pnl;
   //ares_frmmain.btns_chat.parent := ares_frmmain.panel_list_channels;;
   //ares_frmmain.btns_chat.align := alTop;
   ares_frmmain.panel_chat.top := 0; //ares_frmmain.btns_chat.height;
   ares_frmmain.panel_chat.align := alclient;

   //options
   ares_frmmain.tabs_pageview.AddPanel(IdxBtnOptions,GetLangStringW(STR_MAIN_CONTROL_PANEL),[],ares_frmmain.btns_options,nil,false,-1);

   ares_frmmain.tabs_pageview.onPanelShow := ufrmmain.ares_frmmain.tabs_pageviewPanelShow;
   helper_gui_misc.mainGui_showsearch;
   ares_frmmain.tabs_pageview.activePage := IDTAB_SEARCH;
end;

procedure mainGui_refresh_caption;
var
str,str_caption,strHeader,strDownTab: WideString;
begin
try

with ares_frmmain do begin


if not vars_global.check_opt_gen_capt_checked then begin

 ares_frmmain.caption := ' '+appname+' '+versioneares;
 
 //vars_global.theApp.Title := ares_frmmain.caption;
 //forms.Application.title := ares_frmmain.caption;
 if helper_skin.skinnedFrameLoaded then
  if helper_skin.FCaptionRect.left>=0 then helper_skin.drawCustomSkinnedCaption(ares_frmmain);

 ares_FrmMain.update_status_transfer;

 exit;
end;

 strHeader := ' '+appname;
 strDownTab := '   ['+(ares_frmmain.tabs_pageview.panels[ares_frmmain.tabs_pageview.activePage] as TCometPagePanel).btncaption+'] ';
 str_caption := '';

str_caption := str_caption+'  -';

if numero_download+numTorrentDownloads>0 then begin
   if velocita_att_download+speedTorrentDownloads>0 then str := format_speedW(velocita_att_download+speedTorrentDownloads)+' ' else str := '0 '+GetLangStringW(STR_KB_SEC);
str_caption := str_caption+ '   '+inttostr(numero_download+numTorrentDownloads)+' DL '+str;
end;


if numero_upload+numTorrentUploads>0 then begin
   if velocita_att_upload+speedTorrentUploads>0 then str := format_speedW(velocita_att_upload+speedTorrentUploads)+' ' else str := '0 '+GetLangStringW(STR_KB_SEC);
str_caption := str_caption+ '   '+inttostr(numero_upload+numTorrentUploads)+' UL '+str;
end else
if vars_global.speedUploadPartial>0 then begin  // no upload count but partial upspeed due to partialsharing
 str_caption := str_caption+'  UL '+format_speedW(velocita_att_upload)+' ';
end;

if numero_queued>0 then begin
str_caption := str_caption+ '   '+inttostr(numero_queued)+' '+GetLangStringW(STR_IN_QUEUE);
end;

if btn_opt_disconnect.down then str_caption := str_caption+'  <'+GetLangStringW(STR_NOT_CONNECTED)+'>' else
 if vars_global.logon_time=0 then str_caption := str_caption+'  <'+GetLangStringW(STR_CONNECTING)+'>' else
  str_caption := str_caption+'  <Online '+format_time((gettickcount-vars_global.logon_time) div 1000)+'>';

//ares_frmmain.caption := strHeader+' '+versioneares+strDownTab+str_caption;
//vars_global.theApp.Title := strHeader+str_caption;

 ares_frmmain.caption := strHeader+' '+versioneares+strDownTab+str_caption;
 //forms.Application.title := ares_frmmain.caption;

  if helper_skin.skinnedFrameLoaded then
   if helper_skin.FCaptionRect.left>=0 then helper_skin.drawCustomSkinnedCaption(ares_frmmain);

   ares_FrmMain.update_status_transfer;
end;

except
end;
end;

procedure mainGui_showscreen;
begin
 if helper_player.m_GraphBuilder<>nil then
 if not stopped_by_user then begin
   if ((isvideoplaying) and
       (helpeR_player.player_GetState=gsPaused)) then ufrmmain.ares_frmmain.btn_player_pauseclick(nil);
 end;
 
unbold_results;
vars_global.was_on_src_tab := False;

formhint_hide;
mainGUI_screenlogo_init;
imgscnlogo.visible := (not isvideoplaying);
mainGui_refresh_caption;
application.OnMessage := ufrmmain.ares_frmmain.MsgScreenHandler;
helper_channellist.SendNoticeHasFocus(nil);
end;


procedure mainGui_showtransfer;
begin
switch_pause_media;

unbold_results;
vars_global.was_on_src_tab := False;

formhint_hide;

 if ares_frmmain.btn_tran_clearIdle.left+ares_frmmain.btn_tran_clearIdle.width+ares_frmmain.btn_tran_toggle_queup.width+7<ares_frmmain.btns_transfer.clientwidth then
  ares_frmmain.btn_tran_toggle_queup.left := (ares_frmmain.btns_transfer.clientwidth-ares_frmmain.btn_tran_toggle_queup.width)-3
  else ares_frmmain.btn_tran_toggle_queup.left := ares_frmmain.btn_tran_clearIdle.left+ares_frmmain.btn_tran_clearIdle.width+7;

 //ares_frmmain.panel_tran_upqu.bringtofront;
 ufrmmain.ares_frmmain.panel_transferResize(ares_frmmain.panel_transfer);
 mainGui_refresh_caption;
 helper_channellist.SendNoticeHasFocus(nil);
end;


procedure mainGui_showsearch;
begin
application.OnMessage := nil;
vars_global.was_on_src_tab := True;
 if ares_frmmain.edit_src_filter.glyphIndex=0 then begin
  ares_frmmain.edit_src_filter.glyphIndex := 12;
  ares_frmmain.edit_src_filter.text := GetLangStringW(STR_FILTER);
 end;
switch_pause_media;
formhint_hide;
ares_frmmain.pagesrc.Resize;
ufrmmain.ares_frmmain.resizeSearch(ares_frmmain.panel_search.parent);
mainGui_refresh_caption;
helper_channellist.SendNoticeHasFocus(nil);
end;

procedure mainGui_saveposition;
var
reg: Tregistry;
r: TRect;
begin

    reg := tregistry.create;
    try
   reg.openkey(areskey+REG_BOUNDS_ROOT,true);

with ares_frmmain do begin
       if windowstate=wsNormal then begin
       SystemParametersInfo(SPI_GETWORKAREA,0,@r,0);

         if width>=500 then
          if height>=300 then
           if top>=r.top then
            if top<=r.bottom-100 then
             if left>=r.left then
              if left<=r.right-100 then begin

                reg.writeinteger('Main.Left',left);
                reg.writeinteger('Main.Top',top);
                if (width<=(r.right-r.left)-50) then reg.writeinteger('Main.Width',width);
                if (height<=(r.bottom-r.top)-50) then reg.writeinteger('Main.Height',height);

              end;
          reg.writeinteger('Main.Maximized',0);
        end else
        if windowState=wsMaximized then reg.writeinteger('Main.Maximized',1);
end;


 if ares_frmmain.btn_chat_fav.down then reg.writeinteger('ChatRoom.PanelFavHeight',vars_global.chat_favorite_height);


   reg.closekey;
   except
   end;
   reg.destroy;
end;



procedure mainGui_showoptions;
begin
application.OnMessage := nil;
switch_pause_media;

if frm_settings=nil then begin
 frm_settings := tfrm_settings.create(application);
  frm_settings.Parent := ares_frmmain.btns_options;
  frm_settings.Left := 0;
  frm_settings.show;
  ufrmmain.ares_frmmain.btns_optionsResize(ares_frmmain.btns_options);
  frm_settings.apply_language;
  frm_settings.load_settings;
end;

unbold_results;
vars_global.was_on_src_tab := False;

formhint_hide;
mainGui_refresh_caption;
helper_channellist.SendNoticeHasFocus(nil);
end;



procedure choose_nickname_prompt;
var
reg: Tregistry;
begin
if widestrtoutf8str(ares_frmmain.tray_minimize.caption)<>GetLangStringA(STR_HIDE_ARES) then exit;   //app minimized don't show now...

should_show_prompt_nick := False;

 reg := tregistry.create;   //prompt for nickname choice...
  try
 reg.openkey(areskey,true);

 if prendi_mynick(reg)='' then begin
  if messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_WOULD_YOU_LIKE_TO_CHOSE_NICK)),pwidechar(widestring(appname)),MB_YESNO+MB_ICONQUESTION)=IDYES then begin
     ares_frmmain.tabs_pageview.activepage := IDTAB_OPTION;
     frm_settings.settings_control.ActivePage := 2;

     try
      if frm_settings.edit_opt_gen_nick.CanFocus then frm_settings.edit_opt_gen_nick.SetFocus;
     except
     end;
  end;
 end;

 reg.closekey;
  except
 end;
 reg.destroy;
end;

procedure mainGui_showlibrary;
var
nodo:pCmtVnode;
begin
application.OnMessage := nil;
switch_pause_media;

unbold_results;
vars_global.was_on_src_tab := False;

formhint_hide;
ufrmmain.ares_frmmain.libraryOnResize(ares_frmmain.listview_lib.parent);

try

if ares_frmmain.btn_lib_regular_view.down then begin
 nodo := ares_frmmain.treeview_lib_regfolders.getfirstselected;
    if nodo=nil then begin
     nodo := ares_frmmain.treeview_lib_regfolders.getfirst;
     ares_frmmain.treeview_lib_regfolders.selected[nodo] := True;
     ufrmmain.ares_frmmain.treeview_lib_regfoldersClick(nil);
   end;
 end else begin  //virtual di default?
  nodo := ares_frmmain.treeview_lib_virfolders.getfirstselected;
   if nodo=nil then begin
    nodo := ares_frmmain.treeview_lib_virfolders.getfirst;
    ares_frmmain.treeview_lib_virfolders.selected[nodo] := True;
    ufrmmain.ares_frmmain.treeview_lib_virfoldersClick(nil);
   end;
 end;

mainGui_refresh_caption;
helper_channellist.SendNoticeHasFocus(nil);
except
end;
end;

procedure mainGui_setposition;
var
 reg: Tregistry;
 le,tod,wi,he: Integer;
 starmi: Boolean;
 maxim: Boolean;
 wr: TRect;
begin

try
   reg := tregistry.create;

 with reg do begin

    starmi := should_hide_in_params;
    if not starmi then begin
      openkey(areskey,true);
      if valueexists('General.StartMinimized') then begin
       starmi := (readinteger('General.StartMinimized')=1);
      end else starmi := False;

      reg.closekey;
    end;

   openkey(areskey+REG_BOUNDS_ROOT,true);

   if valueexists('Main.Maximized') then begin
    maxim := (readinteger('Main.Maximized')=1);
   end else maxim := False;

    if valueexists('Main.Height') then he := readinteger('Main.Height') else he := 395;
    if valueexists('Main.Width') then wi := readinteger('Main.Width') else wi := 635;
    if valueexists('Main.Left') then le := readinteger('Main.Left') else le := 20;
    if valueexists('Main.Top') then tod := readinteger('Main.Top') else tod := 20;

    closekey;
    destroy;
   end;

 with ares_frmmain do begin


    SystemParametersInfo(SPI_GETWORKAREA,0,@wr,0);


    if le<wr.left then le := wr.left;
    if wi<640 then wi := 640
     else
    if wi>(wr.right-wr.left)-50 then wi := (wr.right-wr.left)-50;
    if he<480 then he := 480
     else
    if he>(wr.bottom-wr.top)-50 then he := (wr.bottom-wr.top)-50;

    if tod<wr.top then tod := wr.top;
    if tod>wr.Bottom-100 then tod := wr.top;
    if le>wr.right-100 then le := wr.left;


    left := le;
    width := wi;
    height := he;

    mainGui_invalidate_searchpanel;

   top := tod;
   ares_frmmain.visible := True;

   

    if starmi then begin
      application.Minimize;
      ShowWindow(application.handle,SW_HIDE);
      TrayIcon1.iconvisible := True;
    end else
    if maxim then postmessage(ares_frmmain.handle,WM_SYSCOMMAND,SC_MAXIMIZE,0);


end;

except
end;

end;


procedure mainGui_applymaxlengths;
begin
 with ares_frmmain do begin
  edit_title.maxlength := MAX_LENGTH_TITLE;
  edit_description.maxlength := MAX_LENGTH_COMMENT;
  edit_url_library.maxlength := MAX_LENGTH_URL;
  combocatlibrary.maxlength := MAX_LENGTH_FIELDS;
  edit_author.maxlength := MAX_LENGTH_FIELDS;
  edit_album.maxlength := MAX_LENGTH_FIELDS;
  edit_year.maxlength := MAX_LENGTH_FIELDS;
  combo_search.maxlength := MAX_LENGTH_TITLE;
  combotitsearch.maxlength := MAX_LENGTH_TITLE;
  comboautsearch.maxlength := MAX_LENGTH_FIELDS;
  combocatsearch.maxlength := MAX_LENGTH_FIELDS;
  comboalbsearch.maxlength := MAX_LENGTH_FIELDS;
  combodatesearch.maxlength := MAX_LENGTH_FIELDS;
  combo_lang_search.maxlength := MAX_LENGTH_FIELDS;
 end;
end;

procedure mainGui_applyfont;
var
i: Integer;
src:precord_panel_search;
begin
try

with ares_frmmain do begin


 if canvas.textheight('T')>17 then begin
 i := 0;
 while ((canvas.textheight('T')>17) and (i<100)) do begin
  canvas.font.size := canvas.font.size-1;
  inc(i);
 if i>10 then break;
 end;

  font := canvas.font;
 end;
 {
 for i := 0 to panel_tabs.ControlCount-1 do begin
    if panel_tabs.Controls[i].classtype=TXPButton then begin
     (panel_tabs.Controls[i] as TXPButton).font.name := font.name;
     (panel_tabs.Controls[i] as TXPButton).font.size := font.size;
    end else
    if panel_tabs.Controls[i].classtype=TTntLabel then begin
     (panel_tabs.Controls[i] as TTntLabel).font.name := font.name;
     (panel_tabs.Controls[i] as TTntLabel).font.size := font.size;
    end;
 end;  }


  //lbl_src_status.font.name := font.name;
  // lbl_src_status.font.size := font.size;

  lbl_capt_search.font.name := font.name;
  lbl_capt_search.font.size := font.size;
  //if (Win32Platform=VER_PLATFORM_WIN32_NT) then lbl_capt_search.font.style := [fsbold];
  //ares_frmmain.lbl_capt_search.font.color := clcaptiontext;

  label_back_src.font.name := font.name;
  label_back_src.font.size := font.size;
  if (Win32Platform=VER_PLATFORM_WIN32_NT) then label_back_src.font.style := [fsbold];

  label_more_searchopt.font.name := font.name;
  label_more_searchopt.font.size := font.size;
  if (Win32Platform=VER_PLATFORM_WIN32_NT) then label_more_searchopt.font.style := [fsbold];

  btns_options.Font.name := font.name;
  btns_options.font.size := font.size;
  
  treeview_lib_virfolders.font.name := font.name;
   treeview_lib_virfolders.font.size := font.size;
  treeview_lib_regfolders.font.name := font.name;
   treeview_lib_regfolders.font.size := font.size;
  listview_lib.header.font.name := Font.name;
   listview_lib.header.font.size := Font.size;
  listview_lib.font.name := font.name;
   listview_lib.font.size := font.size;
  treeview_download.header.font.name := font.name;
   treeview_download.header.font.size := font.size;
  treeview_download.font.name := font.name;
   treeview_download.font.size := font.size;
  treeview_upload.header.font.name := font.name;
   treeview_upload.header.font.size := font.size;
  treeview_upload.font.name := font.name;
   treeview_upload.font.size := font.size;


 for i := 0 to src_panel_list.count-1 do begin
  src := src_panel_list[i];
  with src^.listview do begin
   font.name := ares_frmmain.font.name;
   font.size := ares_frmmain.font.size;
   header.font.name := ares_frmmain.font.name;
   header.font.size := ares_frmmain.font.size;
  end;
 end;
panel_Src_default.font.name := font.name;
panel_src_default.font.size := font.size;

  treeview_queue.header.font.name := font.name;
   treeview_queue.header.font.size := font.size;
  treeview_queue.font.name := font.name;
   treeview_queue.font.size := font.size;
  listview_chat_channel.header.font.name := font.name;
   listview_chat_channel.header.font.size := font.size;
  listview_chat_channel.font.name := font.name;
   listview_chat_channel.font.size := font.size;
  treeview_chat_favorites.header.font.name := font.name;
   treeview_chat_favorites.header.font.size := font.size;
  treeview_chat_favorites.font.name := font.name;
   treeview_chat_favorites.font.size := font.size;

  formhint.font.name := font.name; //hint951.font; //font della hint...
   formhint.font.size := font.size;

 btn_lib_regular_view.font.name := font.name; //bottone virtual library
 btn_lib_regular_view.font.size := font.size;
 btn_lib_virtual_view.font.name := font.name;
 btn_lib_virtual_view.font.size := font.size;
 btn_tran_toggle_queup.font.name := font.name; //show queue
 btn_tran_toggle_queup.font.size := font.size;
 btn_playlist_close.font.name := Font.name;
 btn_playlist_close.font.size := Font.size;

  panel_search.Font.name := font.name;
  panel_search.font.size := font.size;
   lbl_srcmime_all.font.Name := font.Name;
   lbl_srcmime_all.font.size := font.size;
    lbl_srcmime_audio.font.Name := font.Name;
    lbl_srcmime_audio.font.size := font.size;
     lbl_srcmime_video.font.Name := font.Name;
     lbl_srcmime_video.font.size := font.size;
      lbl_srcmime_image.font.Name := font.Name;
      lbl_srcmime_image.font.size := font.size;
       lbl_srcmime_document.font.Name := font.Name;
       lbl_srcmime_document.font.size := font.size;
        lbl_srcmime_software.font.Name := font.Name;
        lbl_srcmime_software.font.size := font.size;
         lbl_srcmime_other.font.Name := font.Name;
         lbl_srcmime_other.font.size := font.size;

   panel_details_library.font.name := font.name;
   panel_details_library.font.size := font.size;
   chk_lib_fileshared.font.name := font.name;
   chk_lib_fileshared.font.size := font.size;


 //lbl_chat_filter.Font := font;
 //btn_chat_search.font := font;

  panel_chat.font.name := font.name;
   panel_chat.font.size := font.size;


   panel_hash.Font.name := font.name;
   panel_hash.Font.Size := font.size;

   panel_hash.font.name := font.name;
   panel_hash.font.size := font.size;
end;

  mainGui_applychatfont;
  if frm_settings<>nil then ufrm_settings.frm_settings.pnl_opt_sharingResize(nil); //avoid overlap label (thank you tempo)
 except
 end;

end;

procedure mainGui_applychatfont;
var
reg: Tregistry;
i,h: Integer;
begin


reg := tregistry.create;
with reg do begin
 openkey(areskey,true);
 if valueexists('ChatRoom.FontName') then font_chat.name := readstring('ChatRoom.FontName');
 if valueexists('ChatRoom.FontSize') then font_chat.size := readinteger('ChatRoom.FontSize');
 if valueExists('ChatRoom.FontItalic') then if readInteger('ChatRoom.FontItalic')=1 then font_chat.style := font_chat.style+[graphics.fsItalic] else font_chat.style := font_chat.style-[graphics.fsItalic];
 if valueExists('ChatRoom.FontBold') then if readInteger('ChatRoom.FontBold')=1 then font_chat.style := font_chat.style+[graphics.fsBold] else font_chat.style := font_chat.style-[graphics.fsBold];
 if valueExists('ChatRoom.FontColor') then font_chat.color := readInteger('ChatRoom.FontColor') else font_chat.color := clBlack;
 closekey;
 destroy;
end;

  if frm_settings<>nil then begin
   frm_settings.btn_opt_chat_font.font.name := vars_global.font_chat.name;
   frm_settings.btn_opt_chat_font.font.size := vars_global.font_chat.size;
   frm_settings.btn_opt_chat_font.font.style := vars_global.font_chat.style;
   frm_settings.btn_opt_chat_font.font.color := vars_global.font_chat.color;
  end;

end;

procedure mainGui_applyChanges;
begin
   //assegna_imageindexs;
   mainGui_applycolor;

with ares_frmmain do begin

//   if ((not ThemeServices.ThemesEnabled) or not (VARS_THEMED_BIGPANELS)) then begin
     panel_search.color := COLORE_SEARCH_PANEL;
     panel_details_library.color := COLORE_LIBDETAILS_PANEL;
end;

end;

procedure mainGui_sizectrls;
begin
with ares_frmmain do begin
//navbar main


 //library
 btn_lib_toggle_folders.left := 10; //btn_refresh_library.left+btn_refresh_library.width+3;
 btn_lib_virtual_view.left := btn_lib_toggle_folders.left+btn_lib_toggle_folders.width+3;
 btn_lib_regular_view.left := btn_lib_virtual_view.left+btn_lib_virtual_view.width+3;

 edit_lib_search.left := btn_lib_regular_view.left+btn_lib_regular_view.width+10;

 btn_lib_toggle_details.left := edit_lib_search.left+edit_lib_search.width+10;
 btn_lib_delete.left := btn_lib_toggle_details.left+btn_lib_toggle_details.width+7;
 btn_lib_addtoplaylist.left := btn_lib_delete.left+btn_lib_delete.width;
 btn_lib_refresh.left := btn_lib_addtoplaylist.left+btn_lib_addtoplaylist.width;


 //transfer
 btn_tran_play.left := btn_tran_cancel.left+btn_tran_cancel.width;
 btn_tran_locate.left := btn_tran_play.left+btn_tran_play.width;
 btn_tran_clearidle.left := btn_tran_locate.left+btn_tran_locate.width;
  if btn_tran_clearIdle.left+btn_tran_clearIdle.width+btn_tran_toggle_queup.width<btns_transfer.clientwidth then
  btn_tran_toggle_queup.left := (btns_transfer.clientwidth-btn_tran_toggle_queup.width)-3
  else btn_tran_toggle_queup.left := btn_tran_clearIdle.left+btn_tran_clearIdle.width;

 //search
 //btn_src_download.left := btn_src_close.left+btn_src_close.width;
 // btn_src_close.left := panel_tabs.clientwidth-(btn_src_close.width+5);
 //chat

 //settings
 btn_opt_disconnect.left := btn_opt_connect.left+btn_opt_connect.width+3;
 lbl_opt_statusconn.left := btn_opt_disconnect.left+btn_opt_disconnect.width+15;
end;

end;


procedure mainGUI_screenlogo_init;
var
stream: Thandlestream;
begin
 if imgscnlogo<>nil then exit;
 try
 imgscnlogo := timage.create(ares_frmmain);
 with imgscnlogo do begin
  parent := ares_frmmain.panel_vid;
  Transparent := True;
  align := alclient;
  center := True;
  autosize := False;
  stretch := False;
  OnDblClick := ufrmmain.ares_frmmain.videoDblClick; //doppio click massimizza
  visible := (not isvideoplaying);
 end;

 if fileexistsW(skin_directory+'\'+VARS_SCREEN_LOGO) then begin
   stream := MyFileOpen(skin_directory+'\'+VARS_SCREEN_LOGO,ARES_READONLY_BUT_SEQUENTIAL);
   if stream=nil then exit;
   
    imgscnlogo.picture.bitmap.loadfromstream(stream);

   FreeHandleStream(stream);
 end;

  
except
end;
end;

procedure mainGui_applycolor;
var
 i,h: Integer;
 src:precord_panel_search;
begin
try

with ares_frmmain do begin

 btns_chat.Color := vars_global.COLORE_TOOLBAR_BG;
 btns_chat.OnPaint := ufrmmain.ares_frmmain.paintToolbar;
 btn_chat_fav.colorbg := btns_chat.Color;
 btn_chat_host.colorBg := btns_chat.color;
 //btn_chat_host.colorbg := btns_chat.Color;
 btn_chaT_join.colorbg := btns_chat.Color;
 btn_chat_refChanlist.colorbg := btns_chat.Color;
// lbl_chat_capt.Color := btns_chat.Color;

 btns_library.Color := btns_chat.Color;
btns_library.OnPaint := ufrmmain.ares_frmmain.paintToolbar;
 btn_lib_addtoplaylist.colorbg := btns_library.Color;
 btn_lib_delete.colorbg := btns_library.Color;
 btn_lib_refresh.colorbg := btns_library.Color;
 btn_lib_regular_view.colorbg := btns_library.Color;
 btn_lib_toggle_details.colorbg := btns_library.Color;
 btn_lib_toggle_folders.colorbg := btns_library.Color;
 btn_lib_virtual_view.colorbg := btns_library.Color;

 btns_options.color := btns_chat.Color;
btns_options.OnPaint := ufrmmain.ares_frmmain.paintToolbar;
 btn_opt_connect.colorbg := btns_options.color;
 btn_opt_disconnect.colorbg := btns_options.color;
 lbl_opt_statusconn.color := btns_options.color;

 btns_transfer.color := btns_chat.Color;
btns_transfer.OnPaint := ufrmmain.ares_frmmain.paintToolbar;
 btn_tran_cancel.colorbg := btns_transfer.color;
 btn_tran_clearidle.colorbg := btns_transfer.color;
 btn_tran_locate.colorbg := btns_transfer.color;
 btn_tran_play.colorbg := btns_transfer.color;
 btn_tran_toggle_queup.colorbg := btns_transfer.color;
 
treeview_lib_virfolders.font.color := vars_global.COLORE_LISTVIEWS_FONT;
treeview_lib_regfolders.font.color := vars_global.COLORE_LISTVIEWS_FONT;
listview_lib.font.color := vars_global.COLORE_LISTVIEWS_FONT;

 for i := 0 to src_panel_list.count-1 do begin
  src := src_panel_list[i];
  src^.listview.font.color := vars_global.COLORE_LISTVIEWS_FONT;
  src^.listview.bgcolor := COLORE_ALTERNATE_ROW;
  src^.listview.colors.HotColor := COLORE_LISTVIEW_HOT;
   if tabs_pageview.activepage=IDTAB_SEARCH then
    if src^.containerPanel=pagesrc.activepanel then src^.listview.invalidate;
 end;
panel_Src_default.font.color := vars_global.COLORE_LISTVIEWS_FONT;

panel_vid.color := $00000000; //COLORE_SCREEN;

listview_chat_channel.font.color := vars_global.COLORE_LISTVIEWS_FONT;

treeview_download.font.color := vars_global.COLORE_LISTVIEWS_FONT;

treeview_upload.font.color := vars_global.COLORE_LISTVIEWS_FONT;

treeview_queue.font.color := vars_global.COLORE_LISTVIEWS_FONT;

edit_src_filter.font.color := font.color;
edit_lib_search.font.color := font.color;

listview_lib.bgcolor := COLORE_ALTERNATE_ROW;
listview_lib.colors.HotColor := COLORE_LISTVIEW_HOT;

tvchannels.bgcolor := COLORE_ALTERNATE_ROW;
tvchannels.colors.HotColor := COLORE_LISTVIEW_HOT;

listview_chat_channel.bgcolor := COLORE_ALTERNATE_ROW;
listview_chat_channel.colors.HotColor := COLORE_LISTVIEW_HOT;
treeview_chat_favorites.bgcolor := COLORE_ALTERNATE_ROW;
treeview_chat_favorites.colors.HotColor := COLORE_LISTVIEW_HOT;

treeview_download.BGColor := COLORE_TRANALTERNATE_ROW;
treeview_download.colors.HotColor := COLORE_LISTVIEW_HOT;
treeview_upload.BGColor := COLORE_TRANALTERNATE_ROW;
treeview_upload.colors.HotColor := COLORE_LISTVIEW_HOT;
treeview_queue.BGColor := COLORE_TRANALTERNATE_ROW;
treeview_queue.colors.HotColor := COLORE_LISTVIEW_HOT;


if tabs_pageview.activepage=IDTAB_LIBRARY then listview_lib.invalidate else
if tabs_pageview.activepage=IDTAB_CHAT then listview_chat_channel.invalidate else
if tabs_pageview.activepage=IDTAB_TRANSFER then begin
 try
 treeview_download.invalidate;
 treeview_upload.invalidate;
 treeview_queue.invalidate;
 except
 end;
end;

end;

except
end;

end;


end.
