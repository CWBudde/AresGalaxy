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
everything related to registry save/load of settings
}

unit helper_registry;

interface

uses
 windows,classes2,classes,registry,const_ares,helper_strings,
 helper_unicode,sysutils,utility_ares,vars_global,forms,ares_types,
 helper_gui_misc,activex,blcksock,dht_int160;

function reg_bannato(const ip: string): Boolean;
function getDataPort(reg: Tregistry): Word;
function getmdhtPort(reg: Tregistry): Word;
function prendi_mynick(reg: Tregistry): string;
function prendi_my_pgui(reg: Tregistry): string;
procedure write_default_upload_height;
function get_default_upload_height(maxHeight:integer): Integer;
function reg_get_avgUptime: Integer;
function prendi_cant_supernode: Boolean; //non possiamo, true se non possiamo
function prendi_reg_my_shared_folder(const data_path: WideString): WideString;
function regGetMyTorrentFolder(const sharedFolder: WideString): WideString;

procedure stats_maxspeed_write;
procedure stats_uptime_write(start_time: Cardinal; totminuptime: Cardinal);
procedure prendi_prefs_reg;
procedure set_reginteger(const vname: string; value:integer);
procedure set_regstring(const vname: string; const value: string);
procedure reg_toggle_autostart;
procedure mainGui_initprefpanel;
function get_reginteger(const vname: string; defaultv:integer): Integer;
function get_regstring(const vname: string): string;

procedure reg_get_transpeed(reg: Tregistry; var UpI: Cardinal; var DnI: Cardinal);
procedure reg_get_megasent(reg: Tregistry; var MUp: Integer; var MDn:integer);
procedure reg_get_totuptime(reg: Tregistry; var tot: Cardinal);
procedure reg_zero_avg_uptime(reg: Tregistry);
procedure reg_get_first_rundate(reg: Tregistry; var frdate: Cardinal);
function reg_getever_configured_share: Boolean;
function reg_ChatGetBindIp: string;
function reg_needs_fresh_HomePage: Boolean;
function reg_wants_chatautofavorites: Boolean;
procedure reg_save_chatfav_height;

procedure reg_SetDHT_ID;
procedure reg_GetDHT_ID;
procedure reg_GetMDHT_ID(id:pCU_INT160);
procedure reg_SetMDHT_ID(id:CU_INT160);
procedure reg_set_desktopPath(desktopPath: string);
function reg_justInstalled: Boolean;
function reg_first_load_chatroom: Boolean;

implementation

uses
 ufrmmain,helper_hashlinks,vars_localiz,helper_crypt,
 helper_datetime,helper_combos,helper_diskio,
 const_timeouts,int128;

function reg_first_load_chatroom: Boolean;
var
 reg: Tregistry;
begin
result := False;
reg := Tregistry.create;
with reg do begin
 openkey(areskey,true);

 if not valueExists('General.ChatJustInstalled') then begin
  closekey;
  destroy;
  exit;
 end;

 Result := True;
 deleteValue('General.ChatJustInstalled');
 closekey;
 destroy;
end;

end;

function reg_justInstalled: Boolean;
var
reg: TRegistry;
begin
result := False;

reg := Tregistry.create;
with reg do begin
 openkey(areskey,true);

 if not valueExists('General.JustInstalled') then begin
  closekey;
  destroy;
  exit;
 end;

 Result := True;
 deleteValue('General.JustInstalled');
 closekey;
 destroy;
end;

end;

procedure reg_GetDHT_ID;
var
reg: Tregistry;
buffer: array [0..15] of Byte;
begin

reg := Tregistry.create;
 with reg do begin
   openkey(areskey,true);
   if not valueexists('Network.DHTID') then begin
    closekey;
    destroy;
    exit;
   end;
   if GetDataSize('Network.DHTID')<>16 then begin
    closekey;
    destroy;
    exit;
   end;

   if ReadBinaryData('Network.DHTID',buffer,sizeof(buffer))<>16 then begin
    closekey;
    destroy;
    exit;
   end;
   
   CU_INT128_CopyFromBuffer(@buffer[0],@DHTMe128);
   closekey;
   destroy;
 end;

end;

procedure reg_GetMDHT_ID(id:pCU_INT160);
var
reg: Tregistry;
buffer: array [0..19] of Byte;
begin

reg := Tregistry.create;
 with reg do begin
   openkey(areskey,true);
   if not valueexists('Network.MDHTID') then begin
    closekey;
    destroy;
    exit;
   end;
   if GetDataSize('Network.MDHTID')<>20 then begin
    closekey;
    destroy;
    exit;
   end;

   if ReadBinaryData('Network.MDHTID',buffer,sizeof(buffer))<>20 then begin
    closekey;
    destroy;
    exit;
   end;

   CU_INT160_CopyFromBuffer(@buffer[0],id);
   closekey;
   destroy;
 end;

end;

procedure reg_SetMDHT_ID(id:CU_INT160);
var
reg: Tregistry;
buffer: array [0..19] of Byte;
begin

dht_int160.CU_INT160_CopyToBuffer(@id,@buffer[0]);

reg := Tregistry.create;
 with reg do begin
   openkey(areskey,true);
   WriteBinaryData('Network.MDHTID',buffer,sizeof(buffer));
   closekey;
   destroy;
 end;
end;

procedure reg_set_desktopPath(desktopPath: string);
var
 reg: Tregistry;
begin
reg := Tregistry.create;
 with reg do begin
   openkey(areskey,true);
   WriteString('Sys.Desktop',desktopPath);
   closekey;
   destroy;
 end;
end;

procedure reg_SetDHT_ID;
var
reg: Tregistry;
buffer: array [0..15] of Byte;
begin

int128.CU_INT128_CopyToBuffer(@DHTme128,@buffer[0]);

reg := Tregistry.create;
 with reg do begin
   openkey(areskey,true);
   WriteBinaryData('Network.DHTID',buffer,sizeof(buffer));
   closekey;
   destroy;
 end;
end;

procedure reg_save_chatfav_height;
var
reg: Tregistry;
begin
  reg := tregistry.create;
  with reg do begin
   openkey(areskey,true);
   writeinteger('ChatRoom.PanelFavHeight',vars_global.chat_favorite_height);
   closekey;
   destroy;
  end;
end;

function reg_wants_chatautofavorites: Boolean;
var
reg: Tregistry;
begin
result := False;

 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
  if valueexists('ChatRoom.AutoAddToFavorites') then Result := (readinteger('ChatRoom.AutoAddToFavorites')=1);
  closekey;
  destroy;
 end;
end;

function reg_needs_fresh_HomePage: Boolean;
var
reg: Tregistry;
begin
result := True;

  reg := tregistry.create;
  with reg do begin
   openkey(areskey,true);
   if valueexists('Browser.LastHomePage') then begin
     if DelphiDateTimeToUnix(now)-readinteger('Browser.LastHomePage')<604800 then Result := False;
   end;
   closekey;
   destroy;
  end;

end;

function reg_ChatGetBindIp: string;
var
reg: Tregistry;
begin
result := cAnyHost;

 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
    if valueexists('ChatRoom.BindAddr') then
     Result := readstring('ChatRoom.BindAddr');
  closekey;
  destroy;
 end;

end;

function reg_getever_configured_share: Boolean;
var
reg: Tregistry;
begin
result := False;

reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
  if valueexists('Share.EverConfigured') then Result := (readinteger('Share.EverConfigured')=1);
  closekey;
  destroy;
 end;

end;

function get_reginteger(const vname: string; defaultv:integer): Integer;
var
reg: Tregistry;
begin

result := defaultv;

reg := tregistry.create;
with reg do begin
 openkey(areskey,true);

 if valueexists(vname) then Result := readinteger(vname);

 closekey;
 destroy;
end;

end;

function get_regstring(const vname: string): string;
var
reg: Tregistry;
begin
result := '';


reg := tregistry.create;
with reg do begin
 openkey(areskey,true);

 if valueexists(vname) then Result := readstring(vname);

 closekey;
 destroy;
end;

end;

procedure mainGui_initprefpanel;
var
reg: Tregistry;
//temp_port: Integer;
begin




//GENERAL////////////////////////////////
reg := tregistry.create;
with reg do begin
  rootkey := HKEY_CURRENT_USER;
  openkey(areskey,true);
 with ares_frmmain do begin


  if valueexists('General.AutoStartUP') then begin
   vars_global.check_opt_gen_autostart_checked := (readinteger('General.AutoStartUp')=1);
  end else vars_global.check_opt_gen_autostart_checked := True;

  if valueexists('General.AutoConnect') then begin
   vars_global.check_opt_gen_autoconnect_checked := (readinteger('General.AutoConnect')=1);
  end else vars_global.check_opt_gen_autoconnect_checked := True;

  if valueexists('General.WhatSongNotif') then begin
   vars_global.check_opt_chat_whatsong_checked := (readinteger('General.WhatSongNotif')=1);
  end else vars_global.check_opt_chat_whatsong_checked := True;

  if reg.valueexists('General.CloseOnQuery') then begin
   vars_global.check_opt_gen_gclose_checked := (reg.readinteger('General.CloseOnQuery')=1);
  end else vars_global.check_opt_gen_gclose_checked := False;

  if reg.valueExists('Extra.WarnOnCancelDL') then begin
   vars_global.check_opt_tran_warncanc_checked := (reg.readinteger('Extra.WarnOnCancelDL')<>0);
  end else vars_global.check_opt_tran_warncanc_checked := False;


  if reg.valueexists('Extra.ShowActiveCaption') then begin
   vars_global.check_opt_gen_capt_checked := (reg.readinteger('Extra.ShowActiveCaption')<>0);
  end else vars_global.check_opt_gen_capt_checked := True;

  if reg.valueexists('Extra.ShowTransferPercent') then begin
   vars_global.check_opt_tran_perc_checked := (reg.readinteger('Extra.ShowTransferPercent')=1);
  end else vars_global.check_opt_tran_perc_checked := False;

  if reg.valueExists('Extra.PauseVideoOnLeave') then begin
   vars_global.check_opt_gen_pausevid_checked := (reg.readinteger('Extra.PauseVideoOnLeave')=1);
  end else vars_global.check_opt_gen_pausevid_checked := False;

  if reg.valueexists('Extra.BlockHints') then begin
   vars_global.check_opt_gen_nohint_checked := (reg.readinteger('Extra.BlockHints')=1);
  end else vars_global.check_opt_gen_nohint_checked := False;


  if reg.valueexists('Transfer.MaximizeUpBandOnIdle') then begin
   vars_global.check_opt_tran_inconidle_checked := (reg.readinteger('Transfer.MaximizeUpBandOnIdle')<>0);
  end else vars_global.check_opt_tran_inconidle_checked := True;

  

  //chatroom ->chat
  //CHAT//////////////////////////////////////////

  if valueexists('ChatRoom.ShowTimeLog') then begin
   vars_global.Check_opt_chat_time_checked := (readinteger('ChatRoom.ShowTimeLog')=1);
  end else vars_global.Check_opt_chat_time_checked := False;

  if valueexists('ChatRoom.AutoAddToFavorites') then begin
   vars_global.Check_opt_chat_autoadd_checked := (readinteger('ChatRoom.AutoAddToFavorites')=1);
  end else vars_global.Check_opt_chat_autoadd_checked := True;

  if valueexists('ChatRoom.ShowJP') then begin //channel join part
   vars_global.check_opt_chat_joinpart_checked := (readinteger('ChatRoom.ShowJP')=1);
  end else vars_global.check_opt_chat_joinpart_checked := True;

  if valueExists('ChatRoom.ShowTaskBtn') then begin
   vars_global.check_opt_chat_taskbtn_checked := (readinteger('ChatRoom.ShowTaskBtn')=1);
  end else vars_global.check_opt_chat_taskbtn_checked := True;

  if valueExists('ChatRoom.UseRemoteTemplate') then begin
   vars_global.chat_enabled_remoteJSTemplate := (readinteger('ChatRoom.UseRemoteTemplate')=1);
  end else vars_global.chat_enabled_remoteJSTemplate := True;
  if vars_global.chat_enabled_remoteJSTemplate then begin
   ares_frmmain.JoinTemplate1.caption := GetLangStringW(STR_JOIN_WITHOUTTEMPLATE);
  end else begin
   ares_frmmain.JoinTemplate1.caption := GetLangStringW(STR_JOIN_WITHREMOTETEMPLATE);
  end;
  ares_frmmain.JoinTemplate2.caption := ares_frmmain.JoinTemplate1.caption;
  
  //chat->pvt
  if reg.valueexists('PrivateMessage.BlockAll') then begin
   vars_global.Check_opt_chat_nopm_checked := (reg.readinteger('PrivateMessage.BlockAll')=1);
  end else vars_global.Check_opt_chat_nopm_checked := False;

  if reg.valueexists('ChatRoom.BlockPM') then begin
   vars_global.Check_opt_chatRoom_nopm_checked := (reg.readinteger('ChatRoom.BlockPM')=1);
  end else vars_global.Check_opt_chatRoom_nopm_checked := False;

  if reg.valueexists('ChatRoom.BlockEmotes') then begin
   vars_global.check_opt_chat_noemotes_checked := (reg.readinteger('ChatRoom.BlockEmotes')=1);
  end else vars_global.check_opt_chat_noemotes_checked := False;

  if reg.valueexists('PrivateMessage.AllowBrowse') then begin
   vars_global.check_opt_chat_browsable_checked := (reg.readinteger('PrivateMessage.AllowBrowse')=1);
  end else vars_global.check_opt_chat_browsable_checked := True;

  if reg.valueexists('Privacy.SendRegularPath') then begin
   vars_global.check_opt_chat_realbrowse_checked := (reg.readinteger('Privacy.SendRegularPath')<>0)
  end else vars_global.check_opt_chat_realbrowse_checked := True; //di default ok


  if reg.valueExists('PrivateMessage.SetAway') then begin
   vars_global.check_opt_chat_isaway_checked := (reg.readinteger('PrivateMessage.SetAway')=1);
  end else vars_global.check_opt_chat_isaway_checked := False;


  vars_global.memo_opt_chat_away_text := utf8strtowidestr(hexstr_to_bytestr(readstring('PrivateMessage.AwayMessage')));
  if length(vars_global.memo_opt_chat_away_text)<1 then vars_global.memo_opt_chat_away_text := STR_DEFAULT_AWAYMSG;


  //network
  if valueexists('Network.NoSupernode') then begin
   vars_global.check_opt_net_nosprnode_checked := (readinteger('Network.NoSupernode')=1);
  end else vars_global.check_opt_net_nosprnode_checked := False;

  //search
  if valueexists('Search.BlockExe') then begin
   vars_global.Check_opt_hlink_filterexe_checked := (readinteger('Search.BlockExe')=1);
  end else vars_global.Check_opt_hlink_filterexe_checked := False;

end; //with ares_frmmain

closekey;
destroy;
end;

end;


procedure reg_toggle_autostart;
var
reg: Tregistry;
begin
  reg := tregistry.create;

with reg do begin
  openkey(areskey,true);
  writeinteger('General.AutoStartUp',integer(vars_global.check_opt_gen_autostart_checked));
  closekey;



if vars_global.check_opt_gen_autostart_checked then begin
 openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
 writestring(lowercase(appname),'"'+application.exename+'" -h');
 CloseKey;
end else begin
 try
 rootkey := HKEY_LOCAL_MACHINE;   //rimuoviamo anche root, per utenti di prima
  if openkey('Software\Microsoft\Windows\CurrentVersion\Run',false) then begin
    try
     deletevalue(lowercase(appname));
    except
    end;
   CloseKey;
  end;
 except
 end;

 try
 rootkey := HKEY_CURRENT_USER;
 openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
  deletevalue(lowercase(appname));
 CloseKey;
 except
 end;
 
end;

destroy;
end;

end;

procedure set_regstring(const vname: string; const value: string);
var
reg: Tregistry;
begin
 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
  writestring(vname,value);
  closekey;
  destroy;
 end;
end;

procedure set_reginteger(const vname: string; value:integer);
var
reg: Tregistry;
begin
 reg := tregistry.create;
 with reg do begin
 try
  openkey(areskey,true);
  writeinteger(vname,value);
  closekey;
 except
 end;
  destroy;
 end;
end;




procedure prendi_prefs_reg;
var
reg: Tregistry;
begin


muptime := reg_get_avgUptime;

reg := tregistry.create;

check_hashlink_associations(reg);
try

reg.rootkey := HKEY_CURRENT_USER;

with reg do begin
 openkey(areskey,true);


if valueexists('General.AutoStartUp') then begin //autostartup?
 if readinteger('General.AutoStartUp')=1 then begin
  closekey;
  openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
  writestring(lowercase(appname),'"'+application.exename+'" -h');
  CloseKey;
  openkey(areskey,true);
 end;
end else begin
 closekey;
 openkey('Software\Microsoft\Windows\CurrentVersion\Run',true);
 writestring(lowercase(appname),'"'+application.exename+'" -h');
 CloseKey;
 openkey(areskey,true);
end;
end;

with reg do begin

 if valueexists('Proxy.Protocol') then begin
  if readinteger('Proxy.Protocol')=5 then socks_type := SoctSock5 else
  if readinteger('Proxy.Protocol')=4 then socks_type := SoctSock4 else
  socks_type := SoctNone;
 end else socks_type := SoctNone;

 socks_username := hexstr_to_bytestr(readstring('Proxy.Username'));
 socks_password := hexstr_to_bytestr(readstring('Proxy.Password'));

 socks_ip := readstring('Proxy.Addr');

 if valueexists('Proxy.Port') then begin
   socks_port := readinteger('Proxy.Port');
 end else socks_port := 1080;

 if valueexists('Upload.AutoClearIdle') then begin //default autoclear Idle=true
  ares_frmmain.clearidle1.checked := (readinteger('Upload.AutoClearIdle')=1);
 end else ares_frmmain.clearidle1.checked := True;

 writeinteger('Stats.HasLQCa',0); //sblocco eventuale richiesta di un cache root...
 writeinteger('Stats.LstCaQueryInt',MIN_INTERVAL_QUERY_CACHE_ROOT); //minimum amount of time between queries
 writeinteger('Stats.LstCaQuery',0); //reset antiflood on gwebcache


 if valueexists('Playlist.Repeat') then begin
  ares_frmmain.playlist_Continuosplay1.checked := (readinteger('Playlist.Repeat')=1);
 end else ares_frmmain.playlist_Continuosplay1.checked := False;

 if valueexists('Playlist.Shuffle') then begin
 ares_frmmain.playlist_Randomplay1.checked := (readinteger('Playlist.Shuffle')=1);
 end else ares_frmmain.playlist_Randomplay1.checked := False;


 if valueexists('General.LastLibraryMode') then begin
    if readinteger('General.LastLibraryMode')=1 then begin
      ares_frmmain.btn_lib_regular_view.down := True;
      ares_frmmain.btn_lib_virtual_view.down := False;
     end else begin
      ares_frmmain.btn_lib_regular_view.down := False;
      ares_frmmain.btn_lib_virtual_view.down := True;
     end;
 end else begin
     ares_frmmain.btn_lib_regular_view.down := False;
     ares_frmmain.btn_lib_virtual_view.down := True;
    end;

    if valueexists('Connections.MaxDlOutgoing') then MAX_OUTCONNECTIONS := reg.readinteger('Connections.MaxDlOutgoing')
     else MAX_OUTCONNECTIONS := 4;

 if valueexists('Hashing.Priority') then hash_throttle := readinteger('Hashing.Priority')
  else hash_throttle := 1; //default highest -1
 ares_frmmain.hash_pri_trx.position := 5-hash_throttle;
end;

hash_update_GUIpry;

with reg do begin

 if valueexists('Libray.ShowDetails') then begin
  ares_frmmain.btn_lib_toggle_details.down := (readinteger('Libray.ShowDetails')=1); //should show details in library?
 end else begin
  ares_frmmain.btn_lib_toggle_details.down := False;
 end;

 if valueexists('Transfer.QueueFirstInFirstOut') then begin
  queue_firstinfirstout := (readinteger('Transfer.QueueFirstInFirstOut')=1);
 end else queue_firstinfirstout := False;

 if valueexists('Transfer.MaxDLCount') then begin
  max_dl_allowed := readinteger('Transfer.MaxDLCount');
  if max_dl_allowed=0 then max_dl_allowed := 10; //MAXNUM_ACTIVE_DOWNLOADS;
  if max_dl_allowed>MAXNUM_ACTIVE_DOWNLOADS then max_dl_allowed := MAXNUM_ACTIVE_DOWNLOADS;
 end else max_dl_allowed := 10;


 if valueexists('GUI.FoldersWidth') then panel6sizedefault := readinteger('GUI.FoldersWidth');
 if panel6sizedefault<50 then panel6sizedefault := 50;

 if valueExists('GUI.ScreenTVWidth') then panelScreensizedefault := readinteger('GUI.ScreenTVWidth');
 if panelScreensizedefault<100 then panelScreensizedefault := 100;

 if valueexists('GUI.ChatRoomWidth') then default_width_chat := readinteger('GUI.ChatRoomWidth');
 if default_width_chat<100 then default_width_chat := 100;


 if valueexists('Transfer.AllowedUpBand') then up_band_allow := readinteger('Transfer.AllowedUpBand');
 if valueexists('Transfer.AllowedDownBand') then down_band_allow := readinteger('Transfer.AllowedDownBand');
 if up_band_allow>65535 then up_band_allow := 0;
 if down_band_allow>65535 then down_band_allow := 0;

 if valueexists('General.AutoConnect') then begin
   if readinteger('General.AutoConnect')=0 then begin
    ares_frmmain.btn_opt_connect.down := False;
    ares_frmmain.btn_opt_disconnect.down := True;
    ares_frmmain.lbl_opt_statusconn.caption := ' '+GetLangStringW(STR_NOT_CONNECTED);
   end else begin
    ares_frmmain.btn_opt_disconnect.down := False;
    ares_frmmain.btn_opt_connect.down := True;
    ares_frmmain.lbl_opt_statusconn.caption := ' '+GetLangStringW(STR_CONNECTING_TO_NETWORK);
   end;
 end else begin
    ares_frmmain.btn_opt_disconnect.down := False;
    ares_frmmain.btn_opt_connect.down := True;
    ares_frmmain.lbl_opt_statusconn.caption := ' '+GetLangStringW(STR_CONNECTING_TO_NETWORK);
 end;

 reg_get_transpeed(reg,velocita_up,velocita_down);

 reg_get_megasent(reg,mega_uploaded,mega_downloaded);

end;


mypgui := prendi_my_pgui(reg);


with reg do begin
 if valueexists('Transfer.MaxUpPerUser') then begin
  max_ul_per_ip := ReadInteger('Transfer.MaxUpPerUser');
  if max_ul_per_ip>10 then max_ul_per_ip := 10;
 end else max_ul_per_ip := 3;


 if valueexists('Transfer.MaxUpCount') then begin
  limite_upload := ReadInteger('Transfer.MaxUpCount');
  if limite_upload>25 then limite_upload := 25;
 end else limite_upload := 6;

 if valueExists('Personal.Sex') then begin
   vars_global.user_sex := readInteger('Personal.Sex');
   if vars_global.user_sex>2 then vars_global.user_sex := 0;
 end else vars_global.user_sex := 0;

 if valueExists('Personal.Country') then begin
   vars_global.user_country := readInteger('Personal.Country');
   if vars_global.user_country>high(country_strings) then vars_global.user_country := 0;
 end else vars_global.user_country := 0;

 if valueExists('Personal.StateCity') then begin
  vars_global.user_stateCity := trim(readString('Personal.StateCity'));
 end else vars_global.user_stateCity := '';

  if valueExists('Personal.Age') then begin
   vars_global.user_age := readInteger('Personal.Age');
   if vars_global.user_age>99 then vars_global.user_age := 0;
 end else vars_global.user_age := 0;

end;


 mynick := prendi_mynick(reg);

 myport := getDataPort(reg);
 if myport=0 then myport := random(60000)+5000;
 my_mdht_port := getmdhtPort(reg);
 if my_mdht_port=0 then my_mdht_port := random(60000)+5000;

with reg do begin
   deletekey('banned'); //per chat

   reg_get_totuptime(reg,program_totminuptime);
   reg_get_first_rundate(reg,program_first_day);

     if program_totminuptime*59>delphidatetimetounix(now)-program_first_day then begin
      program_totminuptime := 0;
     end;

     if not valueexists(REG_STR_STATS_AVGUPTIME) then reg_zero_avg_uptime(reg);;

     

 writestring('GUI.LastLibrary','');
 writestring('GUI.LastSearch','');
 writestring('GUI.LastPMBrowse','');
 writestring('GUI.LastChatRoomBrowse','');

   closekey;
end;


except
end;
reg.destroy;

end;

procedure reg_get_first_rundate(reg: Tregistry; var frdate: Cardinal);
var
str: string;
num: Cardinal;
lenred: Integer;
buffer: array [0..10] of char;
begin

 try

 with reg do begin

     if not valueexists(REG_STR_STATS_FIRSTDAY) then begin  //missing
        num := delphidatetimetounix(now);
        str := chr(random(255))+
             int_2_dword_string(num)+
             CHRNULL+
             chr(random(255))+
             int_2_word_string(wh(int_2_dword_string(num))+12);

       str := e64(e67(str,7193)+CHRNULL,24884);
        move(str[1],buffer,length(str));
        writebinarydata(REG_STR_STATS_FIRSTDAY,buffer,length(str));   //update average uptime

       frdate := delphidatetimetounix(now);
     end else begin
       lenred := readbinarydata(REG_STR_STATS_FIRSTDAY,buffer,10);
       if lenred=10 then begin
        SetLength(str,lenred);
        move(buffer,str[1],lenred);
        str := d67(d64(str,24884),7193);
         delete(str,1,1);    //remove random char 2047+
          if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+12))) then begin
           frdate := chars_2_dword(copy(str,1,4));

          end else begin
           frdate := 0;

         end;
       end else frdate := 0;

         if ((frdate>delphidatetimetounix(now)) or (frdate=0)) then begin  //crack
          frdate := delphidatetimetounix(now);
          str := chr(random(255))+
               int_2_dword_string(frdate)+
               CHRNULL+
               chr(random(255))+
               int_2_word_string(wh(int_2_dword_string(frdate))+12);
          str := e64(e67(str,7193)+CHRNULL,24884);
          move(str[1],buffer,length(str));
          writebinarydata(REG_STR_STATS_FIRSTDAY,buffer,length(str));   //update average uptime
        end;

     end;


end;

except
 frdate := delphidatetimetounix(now);
end;



end;

procedure reg_get_totuptime(reg: Tregistry; var tot: Cardinal);
var
str: string;
lenred: Integer;
buffer: array [0..10] of char;
begin
try

 with reg do begin
     if valueexists(REG_STR_STATS_TOTUPTIME) then begin
      lenred := readbinarydata(REG_STR_STATS_TOTUPTIME,buffer,10);
      if lenred=10 then begin
       SetLength(str,lenred);
       move(buffer,str[1],lenred);
       str := d67(d64(str,65284),16793);
       delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+14))) then begin
         tot := chars_2_dword(copy(str,1,4));

        end else begin
         tot := 0;

        end;
       end else tot := 0;
    end else tot := 0;
 end;

 except
 tot := 0;
 end;
end;

procedure reg_zero_avg_uptime(reg: Tregistry);
var
str: string;
buffer: array [0..10] of char;
begin
 with reg do begin
     str := chr(random(255))+
         int_2_dword_string(0)+
         CHRNULL+
         chr(random(255))+
         int_2_word_string(wh(int_2_dword_string(0))+17);

      str := e64(e67(str,6793)+CHRNULL,44284);
      move(str[1],buffer,length(str));
      writebinarydata(REG_STR_STATS_AVGUPTIME,buffer,length(str));   //update average uptime
 end;
end;

procedure stats_uptime_write(start_time: Cardinal; totminuptime: Cardinal);
var
reg: Tregistry;
minutes_this_session,actual_average: Integer;
num: Cardinal;
str: string;
lenred: Integer;
buffer: array [0..10] of char;
begin
reg := tregistry.create;
with reg do begin
try
 openkey(areskey,true);
  minutes_this_session := (gettickcount-start_time) div 60000;


     if valueexists(REG_STR_STATS_AVGUPTIME) then begin    //get average uptime
      lenred := readbinarydata(REG_STR_STATS_AVGUPTIME,buffer,10);
      if lenred=10 then begin
       SetLength(str,lenred);
       move(buffer,str[1],lenred);
       str := d67(d64(str,44284),6793);
       delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+17))) then begin
         actual_average := chars_2_dword(copy(str,1,4));
         
        end else begin
         actual_average := 0;

        end;
       end else actual_average := 0;
    end else actual_average := 0;

    num := ((actual_average div 5)*4)+(minutes_this_session div 5); //smoth

     str := chr(random(255))+
         int_2_dword_string(num)+
         CHRNULL+
         chr(random(255))+
         int_2_word_string(wh(int_2_dword_string(num))+17);

      str := e64(e67(str,6793)+CHRNULL,44284);
      move(str[1],buffer,length(str));
      writebinarydata(REG_STR_STATS_AVGUPTIME,buffer,length(str));   //update average uptime




     num := totminuptime + minutes_this_session;      //write minutes online!
      str := chr(random(255))+          //now store to registry
           int_2_dword_string(num)+
           CHRNULL+
           chr(random(255))+
           int_2_word_string(wh(int_2_dword_string(num))+14);

      str := e64(e67(str,16793)+CHRNULL,65284);
      move(str[1],buffer,length(str));
      writebinarydata(REG_STR_STATS_TOTUPTIME,buffer,length(str));

 closekey;
except
end;
destroy;
end;
end;

procedure reg_get_megasent(reg: Tregistry; var MUp: Integer; var MDn:integer);
var
lenred: Integer;
str: string;
buffer: array [0..10] of char;
begin
with reg do begin

 //if valueexists('Stats.TMBUpload') then deletevalue('Stats.TMBUpload');
 //if valueexists('Stats.TMBDownload') then deletevalue('Stats.TMBDownload');

 try
 if valueexists(REG_STR_STATSUPHIST) then begin
    try
    lenred := readbinarydata(REG_STR_STATSUPHIST,buffer,10);
      if lenred=10 then begin
      SetLength(str,lenred);
      move(buffer,str[1],lenred);
      str := d67(d64(str,59812),1451);
       delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+32))) then begin
         MUp := chars_2_dword(copy(str,1,4));

        end else begin

         MUp := 0;

        end;
       end else MUp := 0;
    except
     MUp := 0;
    end;
 end else MUp := 0;


 if valueexists(REG_STR_STATSDNHIST) then begin
     try
     lenred := readbinarydata(REG_STR_STATSDNHIST,buffer,10);
      if lenred=10 then begin
      SetLength(str,lenred);
      move(buffer,str[1],lenred);
     str := d67(d64(str,52812),1481);
      delete(str,1,1);  //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+31))) then begin
         MDn := chars_2_dword(copy(str,1,4));

        end else begin
         MDn := 0;

        end;
      end else MDn := 0;
     except
      MDn := 0;
     end;
 end else MDn := 0;

 except
 end;

end;
end;



procedure reg_get_transpeed(reg: Tregistry; var UpI: Cardinal; var DnI: Cardinal);
var
lenred: Integer;
str: string;
buffer: array [0..10] of char;
begin
with reg do begin
 try
  if valueexists(REG_STR_STATS_UPSPEED) then begin  //encrypted since 2947+  22/12/2004
   lenred := readbinarydata(REG_STR_STATS_UPSPEED,buffer,10);
   if lenred=10 then begin
     SetLength(str,lenred);
     move(buffer,str[1],lenred);
      str := d67(d64(str,51812),6451);
     delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+14))) then begin
         UpI := chars_2_dword(copy(str,1,4));

        end else begin
         UpI := 0;

        end;
   end else UpI := 0;
  end else UpI := 0; // 33 k di default

  if valueexists(REG_STR_STATS_DNSPEED) then begin
   lenred := readbinarydata(REG_STR_STATS_DNSPEED,buffer,10);
   if lenred=10 then begin
     SetLength(str,lenred);
     move(buffer,str[1],lenred);
      str := d67(d64(str,31942),7451);
     delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+15))) then begin
         DnI := chars_2_dword(copy(str,1,4));

        end else begin
         DnI := 0;

        end;
   end else DnI := 0;
  end else DnI := 0; // 33 k di default
  except
  end;
 end;
end;




procedure stats_maxspeed_write;
var
reg: Tregistry;
media: Int64;
str: string;
buffer: array [0..10] of char;
lenred: Integer;
begin
reg := tregistry.create;
with reg do begin
 openkey(areskey,true);

 try
 if not valueexists(REG_STR_STATS_UPSPEED) then begin

    str := chr(random(255))+
         int_2_dword_string(velocita_up)+
         CHRNULL+
         chr(random(255))+
         int_2_word_string(wh(int_2_dword_string(velocita_up))+14);

      str := e64(e67(str,6451)+CHRNULL,51812);
      move(str[1],buffer,length(str));
    reg.writebinarydata(REG_STR_STATS_UPSPEED,buffer,length(str));
 end else begin

   lenred := readbinarydata(REG_STR_STATS_UPSPEED,buffer,10); //retrieve old value
   if lenred=10 then begin
     SetLength(str,lenred);
     move(buffer,str[1],lenred);
      str := d67(d64(str,51812),6451);
     delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+14))) then begin
         media := chars_2_dword(copy(str,1,4));

        end else begin
         media := 0;

        end;
    end else media := 0;
    if media>0 then begin     //calculate average sum
      if velocita_up=media then velocita_up := ((media div 10)*9) else
      velocita_up := ((media div 10)*9)+(velocita_up div 10);
    end;

     str := chr(random(255))+          //now store to registry
          int_2_dword_string(velocita_up)+
          CHRNULL+
          chr(random(255))+
          int_2_word_string(wh(int_2_dword_string(velocita_up))+14);

      str := e64(e67(str,6451)+CHRNULL,51812);
      move(str[1],buffer,length(str));
    reg.writebinarydata(REG_STR_STATS_UPSPEED,buffer,length(str));
 end;
 except
 end;



  try
 if not valueexists(REG_STR_STATS_DNSPEED) then begin

    str := chr(random(255))+
         int_2_dword_string(velocita_down)+
         CHRNULL+
         chr(random(255))+
         int_2_word_string(wh(int_2_dword_string(velocita_down))+15);

      str := e64(e67(str,7451)+CHRNULL,31942);
      move(str[1],buffer,length(str));
    reg.writebinarydata(REG_STR_STATS_DNSPEED,buffer,length(str));
 end else begin

   lenred := readbinarydata(REG_STR_STATS_DNSPEED,buffer,10); //retrieve old value
   if lenred=10 then begin
     SetLength(str,lenred);
     move(buffer,str[1],lenred);
      str := d67(d64(str,31942),7451);
     delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+15))) then begin
         media := chars_2_dword(copy(str,1,4));

        end else begin
         media := 0;

        end;
    end else media := 0;
    if media>0 then begin     //calculate average sum
      if velocita_down=media then velocita_down := ((media div 10)*9) else
      velocita_down := ((media div 10)*9)+(velocita_down div 10);
    end;

     str := chr(random(255))+          //now store to registry
          int_2_dword_string(velocita_down)+
          CHRNULL+
          chr(random(255))+
          int_2_word_string(wh(int_2_dword_string(velocita_down))+15);

      str := e64(e67(str,7451)+CHRNULL,31942);
      move(str[1],buffer,length(str));
    reg.writebinarydata(REG_STR_STATS_DNSPEED,buffer,length(str));
 end;



except
end;
 closekey;
 destroy;
end;

end;

function regGetMyTorrentFolder(const sharedFolder: WideString): WideString;
var
reg: Tregistry;
str: string;
begin
 reg := tregistry.create;
 with reg do begin
 try
  if openkey(areskey,false) then begin
   str := hexstr_to_bytestr(readstring('Torrents.Folder'));
   closekey;
  end;
 except
 end;
 destroy;
 end;

 if length(str)>2 then begin
  Result := utf8strtowidestr(str);
 end else begin
  Result := sharedFolder;
 end;
end;

function prendi_reg_my_shared_folder(const data_path: WideString): WideString;
var
reg: Tregistry;
str: string;
begin
 reg := tregistry.create;
 with reg do begin
 try
  if openkey(areskey,false) then begin
   str := hexstr_to_bytestr(readstring('Download.Folder'));
   closekey;
  end;
 except
 end;
 destroy;
 end;

 if length(str)>2 then begin
  Result := utf8strtowidestr(str);
 end else begin
  Result := data_path+'\'+STR_MYSHAREDFOLDER;
 end;
end;

function prendi_cant_supernode: Boolean; //non possiamo, true se non possiamo
var reg: Tregistry;
begin
reg := tregistry.create;
with reg do begin
 try
 openkey(areskey,true);

 if valueexists('Network.NoSupernode') then begin
  Result := (readinteger('Network.NoSupernode')=1);
 end else Result := False;

 closekey;
 except
 Result := True;
 end;
 destroy;
end;
end;

function reg_get_avgUptime: Integer;
var
reg: Tregistry;
lenred: Integer;
str: string;
buffer: array [0..10] of char;
begin
result := 0;

reg := tregistry.create;
with reg do begin
 try
  openkey(areskey,true);

     if valueexists(REG_STR_STATS_AVGUPTIME) then begin    //get average uptime
      lenred := readbinarydata(REG_STR_STATS_AVGUPTIME,buffer,10);
      if lenred=10 then begin
       SetLength(str,lenred);
       move(buffer,str[1],lenred);
       str := d67(d64(str,44284),6793);
       delete(str,1,1);    //remove random char 2047+
        if ((str[5]=CHRNULL) and (chars_2_word(copy(str,7,2))=word(wh(copy(str,1,4))+17))) then begin
         Result := chars_2_dword(copy(str,1,4));

        end else begin
         Result := 0;

        end;
       end else Result := 0;
    end else Result := 0;

  closekey;
 except
 end;
 destroy;
end;
end;

function get_default_upload_height(maxHeight:integer): Integer;
var
reg: Tregistry;
begin
  Result := 120;
  reg := tregistry.create;
  with reg do begin
  try
  openkey(areskey,true);

   if valueexists('GUI.UpHeight') then begin
    Result := readinteger('GUI.UpHeight');
    deletevalue('GUI.UpHeight');
    closekey;
    openkey(areskey+'\Bounds',true);
    writeinteger('UpHeight',result);
   end else begin
    closekey;
    openkey(areskey+'\Bounds',true);
    if valueExists('UpHeight') then Result := readinteger('UpHeight')
     else Result := 120;
   end;

  closekey;
  except
  end;
  destroy;
  end;

if result<20 then Result := 20 else
if result>maxHeight then Result := maxHeight;
end;

procedure write_default_upload_height;
var
reg: Tregistry;
begin
reg := tregistry.create;
with reg do begin
 try
 openkey(areskey+'\Bounds',true);
 writeinteger('UpHeight',vars_global.panelUploadHeight);
 closekey;
 except
 end;
 destroy;
end;
end;

function prendi_my_pgui(reg: Tregistry): string;
var
guid: Tguid;
str: string;
begin
try
with reg do begin
str := readstring('Personal.GUID');
   if length(str)<>32 then writestring('Personal.GUID','')
   else Result := hexstr_to_bytestr(readstring('Personal.GUID'));

 if length(result)<>16 then begin
  fillchar(guid,sizeof(tguid),0);
  CoInitialize(nil);
  cocreateguid(guid);
  CounInitialize;
  SetLength(result,16);
  move(guid,result[1],sizeof(tguid));
  writestring('Personal.GUID',bytestr_to_hexstr(result));
 end;
end;

except
end;
end;

function prendi_mynick(reg: Tregistry): string;
var
str: string;
begin
 str := hexstr_to_bytestr(reg.readstring('Personal.Nickname'));
 str := copy(str,1,20);
 Result := widestrtoutf8str( strippa_fastidiosi( utf8strtowidestr(str),'_'));
end;

function getDataPort(reg: Tregistry): Word;
begin
 try
with reg do begin
 if valueexists('Transfer.ServerPort') then Result := readinteger('Transfer.ServerPort') else begin
    repeat
      Result := random(50000)+1024;
       if result=1214 then continue else
        if result=6346 then continue else
         if result=8888 then continue else
          if result=3306 then continue;
      break;
    until (not true);
   writeinteger('Transfer.ServerPort',result);
 end;
end;

 except
  Result := 80;
 end;
end;

function getmdhtPort(reg: Tregistry): Word;
begin
 try
with reg do begin
 if valueexists('Torrent.mdhtPort') then Result := readinteger('Torrent.mdhtPort') else begin
    repeat
      Result := random(50000)+1024;
       if result=1214 then continue else
        if result=6346 then continue else
         if result=8888 then continue else
          if result=3306 then continue;
      break;
    until (not true);
   writeinteger('Torrent.mdhtPort',result);
 end;
end;

 except
  Result := 80;
 end;
end;

function reg_bannato(const ip: string): Boolean;
var
reg: Tregistry;
begin
result := False;

reg := tregistry.create;
with reg do begin
 try
 openkey(areskey+'banned',true);
  Result := ValueExists(ip);
 closekey;
 except
 end;
 destroy;
end;

end;

end.
