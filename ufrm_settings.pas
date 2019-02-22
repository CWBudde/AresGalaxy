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


unit ufrm_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, CometTrees, CheckLst, ComCtrls,
  comettopicpnl, cometPageView,const_win_messages,tntwindows, folderBrowse,
  jpeg, Mask, Buttons, TntButtons;

type
  Tfrm_settings = class(TForm)
    settings_control: TCometPageView;
    pnl_opt_transfer: TCometTopicPnl;
    lbl_opt_tran_port: TTntLabel;
    grpbx_opt_tran_shfolder: TTntGroupBox;
    lbl_opt_tran_shfolder: TTntLabel;
    lbl_opt_tran_disksp: TTntLabel;
    btn_opt_tran_chshfold: TTntButton;
    btn_opt_tran_defshfold: TTntButton;
    edit_opt_tran_shfolder: TTntEdit;
    Edit_opt_tran_port: TEdit;
    check_opt_tran_warncanc: TTntCheckBox;
    check_opt_tran_perc: TTntCheckBox;
    grpbx_opt_tran_band: TTntGroupBox;
    lbl_opt_tran_upband: TTntLabel;
    lbl_opt_tran_dnband: TTntLabel;
    check_opt_tran_inconidle: TTntCheckBox;
    Edit_opt_tran_upband: TEdit;
    Edit_opt_tran_dnband: TEdit;
    grpbx_opt_tran_sims: TTntGroupBox;
    Label_max_uploads: TTntLabel;
    label_max_upperip: TTntLabel;
    label_max_dl: TTntLabel;
    Edit_opt_tran_limup: TEdit;
    UpDown1: TUpDown;
    Edit_opt_tran_upip: TEdit;
    UpDown2: TUpDown;
    Edit_opt_tran_limdn: TEdit;
    UpDown3: TUpDown;
    pnl_opt_skin: TCometTopicPnl;
    lbl_opt_skin_author: TTntLabel;
    lbl_opt_skin_version: TTntLabel;
    lbl_opt_skin_title: TTntLabel;
    lbl_opt_skin_url: TTntLabel;
    lbl_opt_skin_urlcap: TTntLabel;
    lbl_opt_skin_comments: TTntLabel;
    lbl_opt_skin_date: TTntLabel;
    lstbox_opt_skin: TTntListBox;
    pnl_opt_bittorrent: TCometTopicPnl;
    grpbx_opt_bittorrent_dlfolder: TTntGroupBox;
    lbl_opt_torrent_shfolder: TTntLabel;
    lbl_opt_torrent_disksp: TTntLabel;
    btn_opt_torrent_chshfold: TTntButton;
    btn_opt_torrent_defshfold: TTntButton;
    edit_opt_bittorrent_dlfolder: TTntEdit;
    pnl_opt_sharing: TCometTopicPnl;
    btn_shareset_ok: TTntButton;
    btn_shareset_cancel: TTntButton;
    pgctrl_shareset: TCometPageView;
    pnl_shareset_autoscan: TCometTopicPnl;
    pnl_shareset_auto: TPanel;
    lbl_shareset_auto: TTntLabel;
    progbar_shareset_auto: TProgressBar;
    chklstbx_shareset_auto: TCheckListBox;
    btn_shareset_atuostart: TTntButton;
    btn_shareset_atuostop: TTntButton;
    btn_shareset_atuocheckall: TTntButton;
    btn_shareset_atuoUncheckall: TTntButton;
    pnl_shareset_manual: TCometTopicPnl;
    lbl_shareset_manuhint: TTntLabel;
    mfolder: TCometTree;
    grpbx_shareset_manuhint: TTntGroupBox;
    img_shareset_manuhint1: TImage;
    img_shareset_manuhint2: TImage;
    lbl_shareset_manuhint1: TTntLabel;
    lbl_shareset_manuhint2: TTntLabel;
    pnl_opt_network: TCometTopicPnl;
    check_opt_net_nosprnode: TTntCheckBox;
    grpbx_opt_proxy: TTntGroupBox;
    lbl_opt_proxy_addr: TTntLabel;
    lbl_opt_proxy_login: TTntLabel;
    lbl_opt_proxy_pass: TTntLabel;
    lbl_opt_proxy_check: TTntLabel;
    radiobtn_noproxy: TTntRadioButton;
    radiobtn_proxy4: TTntRadioButton;
    radiobtn_proxy5: TTntRadioButton;
    Edit_opt_proxy_addr: TEdit;
    edit_opt_proxy_login: TTntEdit;
    edit_opt_proxy_pass: TTntEdit;
    btn_opt_proxy_check: TTntButton;
    edit_opt_network_yourip: TEdit;
    pnl_opt_general: TCometTopicPnl;
    lbl_opt_gen_lan: TTntLabel;
    Combo_opt_gen_gui_lang: TTntComboBox;
    check_opt_gen_autostart: TTntCheckBox;
    check_opt_gen_autoconnect: TTntCheckBox;
    check_opt_gen_gclose: TTntCheckBox;
    check_opt_gen_nohint: TTntCheckBox;
    check_opt_gen_pausevid: TTntCheckBox;
    check_opt_gen_capt: TTntCheckBox;
    pnl_opt_chat: TCometTopicPnl;
    pnl_opt_hashlinks: TCometTopicPnl;
    Memo_opt_hlink: TTntMemo;
    btn_opt_hlink_down: TTntButton;
    FontDialog1: TFontDialog;
    Fold: TBrowseForFolder;
    grpbx_opt_chat: TTntGroupBox;
    check_opt_chat_joinpart: TTntCheckBox;
    Check_opt_chat_time: TTntCheckBox;
    Check_opt_chatroom_nopm: TTntCheckBox;
    check_opt_chat_noemotes: TTntCheckBox;
    TntLabel2: TTntLabel;
    edit_opt_chat_autolog: TTntEdit;
    GrpBx_nick: TTntGroupBox;
    lbl_opt_gen_nick: TTntLabel;
    edit_opt_gen_nick: TTntEdit;
    img_opt_avatar: TImage;
    btn_opt_avatar_load: TTntButton;
    btn_opt_avatar_clr: TTntButton;
    lbl_opt_chat_avatar: TTntLabel;
    lbl_opt_chat_age: TTntLabel;
    lbl_opt_chat_sex: TTntLabel;
    lbl_opt_chat_country: TTntLabel;
    cmbo_opt_chat_country: TComboBox;
    lbl_opt_chat_statecity: TLabel;
    edit_opt_chat_statecity: TTntEdit;
    cmbo_opt_chat_sex: TTntComboBox;
    lbl_opt_chat_message: TTntLabel;
    edit_opt_chat_message: TTntEdit;
    check_opt_chat_keepAlive: TTntCheckBox;
    edit_opt_chat_age: TMaskEdit;
    UpDown4: TUpDown;
    check_opt_chat_joinremotetemplate: TTntCheckBox;
    check_opt_chat_msnsong: TTntCheckBox;
    btn_opt_chat_font: TBitBtn;
    check_opt_chat_browsable: TTntCheckBox;
    Memo_opt_chat_away: TTntMemo;
    Check_opt_chat_isaway: TTntCheckBox;
    Check_opt_tran_filterexe: TTntCheckBox;
    btn_opt_gen_about: TTntBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure edit_opt_gen_nickChange(Sender: TObject);
    procedure Combo_opt_gen_gui_langClick(Sender: TObject);
    procedure check_opt_gen_autostartClick(Sender: TObject);
    procedure check_opt_gen_autoconnectClick(Sender: TObject);
    procedure check_opt_gen_msnsongClick(Sender: TObject);
    procedure check_opt_gen_gcloseClick(Sender: TObject);
    procedure check_opt_tran_warncancClick(Sender: TObject);
    procedure check_opt_gen_captClick(Sender: TObject);
    procedure check_opt_tran_percClick(Sender: TObject);
    procedure check_opt_gen_pausevidClick(Sender: TObject);
    procedure Edit_dataportClick(Sender: TObject);
    procedure Edit_opt_tran_limdnChange(Sender: TObject);
    procedure Edit_opt_tran_upipChange(Sender: TObject);
    procedure Edit_opt_tran_limupChange(Sender: TObject);
    procedure check_opt_tran_inconidleClick(Sender: TObject);
    procedure Edit_opt_tran_upbandChange(Sender: TObject);
    procedure Edit_opt_tran_dnbandChange(Sender: TObject);
    procedure Check_opt_chat_timeClick(Sender: TObject);
    procedure check_opt_chat_joinpartClick(Sender: TObject);
    procedure Check_opt_chatroom_nopmClick(Sender: TObject);
    procedure check_opt_chat_noemotesClick(Sender: TObject);
    procedure check_opt_chat_browsableClick(Sender: TObject);
    procedure Check_opt_chat_isawayClick(Sender: TObject);
    procedure awayMemoChange(Sender : TObject);
    procedure check_opt_net_nosprnodeClick(Sender: TObject);
    procedure btn_opt_proxy_checkClick(Sender: TObject);
    procedure radiobtn_noproxyClick(Sender: TObject);
    procedure Check_opt_hlink_filterexeClick(Sender: TObject);
    procedure check_opt_gen_nohintClick(Sender: TObject);
    procedure btn_shareset_cancelClick(Sender: TObject);
    procedure btn_shareset_okClick(Sender: TObject);
    procedure pnl_opt_sharingResize(Sender: TObject);
    procedure mfolderGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure mfolderFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure mfolderGetSize(Sender: TBaseCometTree;var Size: Integer);
    procedure mfolderGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure mfolderClick(Sender: TObject);
    procedure tabsheet_shareset_manuResize(Sender: TObject);
    procedure btn_shareset_atuostopClick(Sender: TObject);
    procedure btn_shareset_atuocheckallClick(Sender: TObject);
    procedure btn_shareset_atuoUncheckallClick(Sender: TObject);
    procedure btn_shareset_atuostartClick(Sender: TObject);
    procedure chklstbx_shareset_autoDblClick(Sender: TObject);
    procedure tabsheet_shareset_autoResize(Sender: TObject);
    procedure chklstbx_shareset_autoClick(Sender: TObject);
    procedure chklstbx_shareset_autoDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure btn_opt_tran_chshfoldClick(Sender: TObject);
    procedure btn_opt_tran_defshfoldClick(Sender: TObject);
    procedure btn_opt_chat_fontClick(Sender: TObject);
    procedure edit_opt_proxy_loginChange(Sender: TObject);
    procedure edit_opt_proxy_passChange(Sender: TObject);
    procedure edit_opt_proxy_addrChange(Sender: TObject);
    procedure mfolderExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
    procedure mfolderCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure DownloadHashLink1Click(Sender: TObject);
    procedure lbl_opt_skin_urlMouseEnter(Sender: TObject);
    procedure lbl_opt_skin_urlMouseLeave(Sender: TObject);
    procedure lbl_opt_skin_urlClick(Sender: TObject);
    procedure lstbox_opt_skinClick(Sender: TObject);
    procedure btn_opt_torrent_chshfoldClick(Sender: TObject);
    procedure btn_opt_torrent_defshfoldClick(Sender: TObject);
    procedure settings_controlPanelShow(Sender, aPanel: TObject);
    procedure Memo_opt_chat_awayKeyPress(Sender: TObject; var Key: Char);
    procedure start_thread_share;
    procedure edit_opt_chat_autologChange(Sender: TObject);
    procedure btn_opt_avatar_loadClick(Sender: TObject);
    procedure btn_opt_avatar_clrClick(Sender: TObject);
    procedure cmbo_opt_chat_sexClick(Sender: TObject);
    procedure cmbo_opt_chat_countryClick(Sender: TObject);
    procedure edit_opt_chat_statecityChange(Sender: TObject);
    procedure edit_opt_chat_ageChange(Sender: TObject);
    procedure edit_opt_chat_messageChange(Sender: TObject);
    procedure check_opt_chat_keepAliveClick(Sender: TObject);
    procedure check_opt_chat_joinremotetemplateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_opt_gen_aboutClick(Sender: TObject);

  private
    procedure createMiniAvatarJpg(source:graphics.TBitmap);
    procedure createAvatarJpg(source:graphics.TBitmap);
    procedure do_draw_empty_avatar;
    procedure init_avatar;
    procedure init_manual_share(var msg:messages.tmessage); message WM_USER;
    procedure init_tabs;
    procedure thread_autoscan_end(var msg:messages.tmessage); message const_win_messages.WM_THREADSEARCHDIR_END;
  public
    procedure select_listbox_skin;
    procedure apply_language;
    procedure load_settings;
  end;

var
  frm_settings: Tfrm_settings;

implementation

{$R *.dfm}

uses
  vars_global,vars_localiz,helper_registry,helper_strings,helper_unicode,
  const_ares,uWhatImListeningTo,registry,helper_combos,helper_diskio,ares_types,
  ufrmmain,helper_manual_share,helper_hashlinks,helper_urls,
  utility_ares,helper_skin,helper_gui_misc,helper_autoscan,
  helper_stringfinal,helper_library_db,thread_share,helper_check_proxy,
  secureHash,helper_channellist,ufrmabout;



procedure tfrm_settings.init_avatar;
var
 avatarFile: string;
 loadBitmap,tmpBitmap,tmpBitmap2:graphics.TBitmap;
 stream: ThandleStream;
 memStream: TmemoryStream;
begin
try
avatarFile := get_regstring('Personal.Avatar');

if length(avatarFile)=0 then begin
 do_draw_empty_avatar;
 exit;
end;

if not fileExistsW(data_path+'\Data\avatar.bmp') then begin
 do_draw_empty_avatar;
 exit;
end;

stream := myFileOpen(data_path+'\Data\avatar.bmp',ARES_READONLY_ACCESS);
if stream=nil then begin
 do_draw_empty_avatar;
 exit;
end;

loadBitmap := graphics.TBitmap.create;
 loadBitmap.LoadFromStream(stream);

  tmpBitmap := graphics.TBitmap.create;
  tmpBitmap.width := img_opt_avatar.width-4;
  tmpBitmap.height := img_opt_avatar.height-4;
 if (loadBitmap.width<>tmpBitmap.width) or
    (loadBitmap.height<>tmpBitmap.Height) then begin
     resizeBitmap(loadBitmap,tmpBitmap);
    end
    else tmpBitmap.canvas.draw(0,0,loadBitmap);
  loadBitmap.Free;


 //draw frame
 tmpBitmap2 := graphics.TBitmap.create;
 drawAvatarFrame(tmpBitmap2,false);
  tmpBitmap2.canvas.draw(2,2,tmpBitmap);

 tmpBitmap.Free;


 memStream := TmemoryStream.create;
 tmpBitmap2.SaveToStream(memStream);
 memStream.position := 0;
 img_opt_avatar.Picture.Bitmap.LoadFromStream(memStream);
 memStream.Free;
 tmpBitmap2.Free;
// img_opt_avatar.picture.bitmap.assign(tmpBitmap2);


//tmpBitmap.Free;
freeHandleStream(stream);
except
end;
end;

procedure Tfrm_settings.btn_opt_avatar_loadClick(Sender: TObject);
var
 streamread,streamWrite: ThandleStream;
 jpg: TJPEGImage;
 ext: string;
 tmpBitmap,loadBitmap,tmpBitmap2,bitbltbmp:graphics.TBitmap;
 memStream: TmemoryStream;
begin
try
ares_frmmain.OpenDialog1.filter := 'Jpeg & Bitmap|*.jpg;*.bmp';
if not ares_frmmain.OpenDialog1.execute then exit;

streamread := myFileOpen(ares_frmmain.OpenDialog1.filename,ARES_READONLY_ACCESS);
if streamread=nil then exit;

 screen.cursor := crHourGlass;
 application.processMessages;
 
loadBitmap := graphics.TBitmap.create;

ext := lowercase(extractfileExt(ares_frmmain.OpenDialog1.filename));
if (ext='.jpg') or
   (ext='.jpeg') then begin
   jpg := TJPEGImage.Create;
 try

   jpg.LoadFromStream(streamread);
   jpg.DIBNeeded;
  loadBitmap.assign(jpg);
 except
 end;
 jpg.Free;
end else begin
  loadBitmap.loadFromStream(streamread);
end;

 if loadBitmap.width>loadBitmap.height then begin
    bitbltbmp := graphics.TBitmap.create;
     bitbltbmp.width := loadBitmap.Height;
     bitbltbmp.height := loadBitmap.Height;
     bitBlt(bitbltbmp.canvas.Handle,
            0,0,bitbltbmp.width,bitbltbmp.Height,
            loadBitmap.canvas.handle,
            (loadBitmap.width div 2)-(bitbltbmp.height div 2),0,
            SRCCOPY);
  loadBitmap.width := loadBitmap.Height;
  loadBitmap.Canvas.draw(0,0,bitbltbmp);
  bitbltbmp.Free;
 end else
 if loadBitmap.height>loadBitmap.width then begin
     bitbltbmp := graphics.TBitmap.create;
     bitbltbmp.width := loadBitmap.width;
     bitbltbmp.height := loadBitmap.width;
     bitBlt(bitbltbmp.canvas.Handle,
            0,0,bitbltbmp.width,bitbltbmp.Height,
            loadBitmap.canvas.handle,
            0,(loadBitmap.height div 2)-(bitbltbmp.height div 2),
            SRCCOPY);
  loadBitmap.height := loadBitmap.Width;
  loadBitmap.Canvas.draw(0,0,bitbltbmp);
  bitbltbmp.Free;
 end;

 tmpBitmap := graphics.TBitmap.create;
  tmpBitmap.width := img_opt_avatar.width-4;
  tmpBitmap.height := img_opt_avatar.height-4;
 resizeBitmap(loadBitmap,tmpBitmap);


 //draw frame
 tmpBitmap2 := graphics.TBitmap.create;
 drawAvatarFrame(tmpBitmap2,false);
  tmpBitmap2.canvas.draw(2,2,tmpBitmap);

  streamWrite := myFileOpen(data_path+'\Data\avatar.bmp',ARES_OVERWRITE_EXISTING);
  if streamWrite<>nil then begin
   tmpBitmap.SaveToStream(streamwrite);
   FreeHandleStream(streamwrite);
   set_regString('Personal.Avatar','avatar.bmp');
  end;

  createMiniAvatarJpg(loadBitmap);
  createAvatarJpg(tmpBitmap);

  tmpBitmap.Free;
 // tmpBitmap.canvas.draw(2,2,loadBitmap);
  loadBitmap.Free;


 memStream := TmemoryStream.create;
 tmpBitmap2.SaveToStream(memStream);
 memStream.position := 0;
 img_opt_avatar.Picture.Bitmap.LoadFromStream(memStream);
 memStream.Free;
 tmpBitmap2.Free;

 //img_opt_avatar.picture.bitmap.assign(tmpBitmap2);


 
freeHandleStream(streamread);
except
end;
screen.cursor := crDefault;
end;

procedure tfrm_settings.createAvatarJpg(source:graphics.TBitmap);
var
 streamWrite: ThandleStream;
 jpg: TJPEGImage;
 quality: Integer;
begin
try
streamWrite := myFileOpen(data_path+'\Data\Avatar.jpg',ARES_OVERWRITE_EXISTING);
if streamWrite=nil then exit;


quality := 100;
Jpg := TJPEGImage.Create;
  try
    jpg.CompressionQuality := quality;
    Jpg.Assign(source);
    Jpg.SaveToStream(streamWrite);
  finally
    jpg.Free;
  end;

while (streamWrite.size>=8192) do begin

 streamWrite.size := 0;
 dec(quality,10);

 if quality<10 then begin
  FreeHandleStream(streamWrite);
  exit;
 end;

 Jpg := TJPEGImage.Create;
  try
    jpg.CompressionQuality := quality;
    Jpg.Assign(source);
    Jpg.SaveToStream(streamWrite);
  finally
    jpg.Free;
  end;

end;

FreeHandleStream(streamWrite);
except
end;
end;

procedure tfrm_settings.createMiniAvatarJpg(source:graphics.TBitmap);
var
 streamWrite: ThandleStream;
 jpg: TJPEGImage;
 miniSource: TBitmap;
 quality: Integer;
begin
try
streamWrite := myFileOpen(data_path+'\Data\MiniAvatar.jpg',ARES_OVERWRITE_EXISTING);
if streamWrite=nil then exit;

minisource := graphics.TBitmap.create;
 minisource.width := 48;
 minisource.Height := minisource.width;
resizeBitmap(source,minisource);

quality := 100;
Jpg := TJPEGImage.Create;
  try
    jpg.CompressionQuality := quality;
    Jpg.Assign(minisource);
    Jpg.SaveToStream(streamWrite);
  finally
    jpg.Free;
  end;

while (streamWrite.size>=2048) do begin

 streamWrite.size := 0;
 dec(quality,10);

 if quality<10 then begin
  minisource.Free;
  FreeHandleStream(streamWrite);
  exit;
 end;

 Jpg := TJPEGImage.Create;
  try
    jpg.CompressionQuality := quality;
    Jpg.Assign(minisource);
    Jpg.SaveToStream(streamWrite);
  finally
    jpg.Free;
  end;

end;

minisource.Free;
FreeHandleStream(streamWrite);
except
end;
end;

procedure Tfrm_settings.btn_opt_avatar_clrClick(Sender: TObject);
begin
set_regstring('Personal.Avatar','');
do_draw_empty_avatar;
if fileExistsW(data_path+'\Data\Avatar.bmp') then deleteFileW(data_path+'\Data\Avatar.bmp');
if fileExistsW(data_path+'\Data\MiniAvatar.jpg') then deleteFileW(data_path+'\Data\MiniAvatar.jpg');
if fileExistsW(data_path+'\Data\Avatar.jpg') then deleteFileW(data_path+'\Data\Avatar.jpg');
end;

procedure tfrm_settings.do_draw_empty_avatar;
var
 tmpBitmap,loadBitmap:graphics.TBitmap;
 streamRead: Thandlestream;
 memStream: Tmemorystream;
begin
try
 tmpBitmap := graphics.TBitmap.create;
 drawAvatarFrame(tmpBitmap,true);

 streamRead := myFileOpen(app_path+'\Data\no-avatar.bmp',ARES_READONLY_ACCESS);
 if streamRead<>nil then begin
  loadBitmap := graphics.TBitmap.create;
  loadBitmap.loadFromStream(streamRead);
  FreeHandleStream(streamRead);
   loadBitmap.width := tmpBitmap.width-4;
   loadBitmap.height := tmpBitmap.height-4;
    tmpBitmap.canvas.draw(2,2,loadBitmap);
   loadBitmap.Free;
 end;

 memStream := TmemoryStream.create;
 tmpBitmap.SaveToStream(memStream);
 memStream.position := 0;
 img_opt_avatar.Picture.Bitmap.LoadFromStream(memStream);
 memStream.Free;
 tmpBitmap.Free;

 //img_opt_avatar.picture.bitmap.assign(tmpBitmap);
 // tmpBitmap.Free;
except
end;
end;

procedure tfrm_settings.load_settings;
var
 reg: Tregistry;
begin
vars_localiz.mainGui_enumlangs;
combo_opt_gen_gui_lang.onclick := Combo_opt_gen_gui_langClick;


 //personal details
  edit_opt_gen_nick.text := utf8strtowidestr(vars_global.mynick);
 edit_opt_gen_nick.onChange := edit_opt_gen_nickChange;
  cmbo_opt_chat_sex.ItemIndex := vars_global.user_sex;
 cmbo_opt_chat_sex.onClick := cmbo_opt_chat_sexclick;
  cmbo_opt_chat_country.itemindex := vars_global.user_country;
 cmbo_opt_chat_country.onclick := cmbo_opt_chat_countryClick;
  edit_opt_chat_statecity.text := utf8strtowidestr(vars_global.user_stateCity);
 edit_opt_chat_statecity.onchange := edit_opt_chat_statecityChange;
 // edit_opt_chat_age.text := 
  updown4.position := vars_global.user_age;
 edit_opt_chat_age.onchange := edit_opt_chat_ageChange;
  edit_opt_chat_message.text := utf8strtowidestr(get_regString('Personal.CustomMessage'));
 edit_opt_chat_message.onChange := edit_opt_chat_messageChange;


 check_opt_gen_autostart.checked := vars_global.check_opt_gen_autostart_checked;
 check_opt_gen_autostart.onClick := check_opt_gen_autostartClick;

 check_opt_gen_autoconnect.checked := vars_global.check_opt_gen_autoconnect_checked;
 check_opt_gen_autoconnect.onClick := check_opt_gen_autoconnectClick;



 check_opt_gen_gclose.checked := vars_global.check_opt_gen_gclose_checked;
 check_opt_gen_gclose.onClick := check_opt_gen_gcloseClick;

 check_opt_tran_warncanc.checked := vars_global.check_opt_tran_warncanc_checked;
 check_opt_tran_warncanc.onClick := check_opt_tran_warncancClick;

 check_opt_gen_capt.checked := vars_global.check_opt_gen_capt_checked;
 check_opt_gen_capt.OnClick := check_opt_gen_captClick;

 check_opt_tran_perc.checked := vars_global.check_opt_tran_perc_checked;
 check_opt_tran_perc.onClick := check_opt_tran_percClick;

 check_opt_gen_pausevid.checked := vars_global.check_opt_gen_pausevid_checked;
 check_opt_gen_pausevid.onClick := check_opt_gen_pausevidClick;

 check_opt_gen_nohint.checked := vars_global.check_opt_gen_nohint_checked;
 check_opt_gen_nohint.onClick := check_opt_gen_nohintClick;

 edit_opt_tran_shfolder.text := vars_global.myshared_folder;
 edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;
 helper_diskio.getfreedrivespace;


 //TRANSFER////////////////////////////////////
 Edit_opt_tran_port.text := inttostr(vars_global.myport);
 Edit_opt_tran_port.onChange := Edit_dataportClick;

 updown1.max := 25;
 updown1.position := vars_global.limite_upload;
 Edit_opt_tran_limup.text := inttostr(vars_global.limite_upload);
 Edit_opt_tran_limup.onchange := Edit_opt_tran_limupChange;

  updown2.max := 10;
  updown2.position := vars_global.max_ul_per_ip;
  Edit_opt_tran_upip.text := inttostr(vars_global.max_ul_per_ip);
  Edit_opt_tran_upip.onchange := Edit_opt_tran_upipChange;

  UpDown3.max := MAXNUM_ACTIVE_DOWNLOADS;
  UpDown3.position := vars_global.max_dl_allowed;
  Edit_opt_tran_limdn.text := inttostr(vars_global.max_dl_allowed);
  Edit_opt_tran_limdn.OnChange := Edit_opt_tran_limdnChange;

  Edit_opt_tran_upband.text := inttostr(vars_global.up_band_allow);
  edit_opt_tran_upband.onchange := Edit_opt_tran_upbandChange;

  Edit_opt_tran_dnband.text := inttostr(vars_global.down_band_allow);
  Edit_opt_tran_dnband.onChange := Edit_opt_tran_dnbandChange;

  check_opt_tran_inconidle.checked := vars_global.check_opt_tran_inconidle_checked;
  check_opt_tran_inconidle.onClick := check_opt_tran_inconidleClick;

  //CHAT//////////////////////////////////////////
  Check_opt_chat_time.checked := vars_global.Check_opt_chat_time_checked;
  Check_opt_chat_time.onClick := Check_opt_chat_timeClick;

  check_opt_chat_joinpart.checked := vars_global.check_opt_chat_joinpart_checked;
  check_opt_chat_joinpart.onClick := check_opt_chat_joinpartClick;

  if get_regstring('ChatRoom.AutoLoginPass')<>'' then edit_opt_chat_autolog.Text := '********';
  edit_opt_chat_autolog.OnChange := edit_opt_chat_autologChange;

  btn_opt_chat_font.font.name := vars_global.font_chat.name;
  btn_opt_chat_font.font.size := vars_global.font_chat.size;
  btn_opt_chat_font.font.style := vars_global.font_chat.style;
  btn_opt_chat_font.Font.color := vars_global.font_chat.color;

  Check_opt_chatRoom_nopm.checked := vars_global.Check_opt_chatRoom_nopm_checked;
  Check_opt_chatRoom_nopm.onClick := Check_opt_chatroom_nopmClick;

  check_opt_chat_msnsong.checked := vars_global.check_opt_chat_whatsong_checked;
  check_opt_chat_msnsong.OnClick := check_opt_gen_msnsongClick;

  check_opt_chat_noemotes.checked := vars_global.check_opt_chat_noemotes_checked;
  check_opt_chat_noemotes.onClick := check_opt_chat_noemotesClick;

  check_opt_chat_joinremotetemplate.checked := vars_global.chat_enabled_remoteJSTemplate;
  check_opt_chat_joinremotetemplate.onClick := check_opt_chat_joinremotetemplateClick;

  check_opt_chat_keepAlive.checked := (get_regInteger('ChatRoom.KeepAlive',0)=1);
  check_opt_chat_keepAlive.onClick := check_opt_chat_keepAliveClick;

  check_opt_chat_browsable.checked := vars_global.check_opt_chat_browsable_checked;
  check_opt_chat_browsable.onClick := check_opt_chat_browsableClick;

  check_opt_chat_isaway.checked := vars_global.check_opt_chat_isaway_checked;
  check_opt_chat_isaway.onClick := Check_opt_chat_isawayClick;
  memo_opt_chat_away.enabled := Check_opt_chat_isaway.checked;
  memo_opt_chat_away.text := vars_global.memo_opt_chat_away_text;
  memo_opt_chat_away.onChange := awayMemoChange;

  //network
  check_opt_net_nosprnode.checked := vars_global.check_opt_net_nosprnode_checked;
  check_opt_net_nosprnode.onClick := check_opt_net_nosprnodeClick;


   //proxy
  if vars_global.socks_ip<>'' then Edit_opt_proxy_addr.text := vars_global.socks_ip+':'+inttostr(vars_global.socks_port)
  else Edit_opt_proxy_addr.text := '';
  edit_opt_proxy_login.text := utf8strtowidestr(vars_global.socks_username);
  edit_opt_proxy_pass.text := utf8strtowidestr(vars_global.socks_password);

  if vars_global.socks_type=SoctNone then radiobtn_noproxy.checked := true else
  if vars_global.socks_type=SoctSock4 then radiobtn_proxy4.checked := true else
  radiobtn_proxy5.checked := True;

  radiobtn_noproxy.onClick := radiobtn_noproxyClick;
  radiobtn_proxy4.OnClick := radiobtn_noproxyClick;
  radiobtn_proxy5.OnClick := radiobtn_noproxyClick;
  btn_opt_proxy_check.onClick := btn_opt_proxy_checkClick;
  edit_opt_proxy_addr.onChange := edit_opt_proxy_addrChange;
  edit_opt_proxy_login.onChange := edit_opt_proxy_loginChange;
  edit_opt_proxy_pass.onChange := edit_opt_proxy_passChange;



  if vars_global.LANIPs<>vars_global.localip then edit_opt_network_yourip.text := 'IP: '+vars_global.localip+' ('+vars_global.LANIPs+')'+bool_string(vars_global.im_firewalled,' F',' A')
   else edit_opt_network_yourip.text := 'IP: '+vars_global.localip+bool_string(vars_global.im_firewalled,' F',' A');

  reg := tregistry.create;
  with reg do begin
  openkey(areskey,true);
  memo_opt_hlink.text := utf8strtowidestr(reg.readstring('General.LastHashLink'));
  if length(memo_opt_hlink.text)=0 then memo_opt_hlink.text := const_ares.STR_ARLNK_LOWER;
  closekey;
  destroy;
  end;

  btn_shareset_cancel.onclick := btn_shareset_cancelClick;
  btn_shareset_ok.onclick := btn_shareset_okClick;
  pnl_opt_sharing.onResize := pnl_opt_sharingResize;


  btn_shareset_atuostop.onClick := btn_shareset_atuostopClick;
  btn_shareset_atuocheckall.onClick := btn_shareset_atuocheckallClick;
  btn_shareset_atuoUncheckall.onclick := btn_shareset_atuoUncheckallClick;
  btn_shareset_atuostart.onClick := btn_shareset_atuostartClick;

  mfolder.onGetImageIndex := mfolderGetImageIndex;
  mfolder.onFreeNode := mfolderFreeNode;
  mfolder.onGetSize := mfolderGetSize;
  mfolder.onGetText := mfolderGetText;
  mfolder.onClick := mfolderClick;
  mfolder.onExpanding := mfolderExpanding;
  mfolder.onCompareNodes := mfolderCompareNodes;

  pnl_shareset_manual.onResize := tabsheet_shareset_manuResize;

  //hashlinks
   Check_opt_tran_filterexe.checked := vars_global.Check_opt_hlink_filterexe_checked;
  Check_opt_tran_filterexe.onClick := Check_opt_hlink_filterexeClick;
  btn_opt_hlink_down.onClick := DownloadHashLink1Click;

  chklstbx_shareset_auto.onDblClick := chklstbx_shareset_autoDblClick;
  pnl_shareset_autoscan.onResize := tabsheet_shareset_autoResize;
  chklstbx_shareset_auto.onClick := chklstbx_shareset_autoClick;
  chklstbx_shareset_auto.onDrawItem := chklstbx_shareset_autoDrawItem;


  //transfer
  btn_opt_tran_chshfold.onClick := btn_opt_tran_chshfoldClick;
  btn_opt_tran_defshfold.onClick := btn_opt_tran_defshfoldClick;
  btn_opt_chat_font.onClick := btn_opt_chat_fontClick;

  lstbox_opt_skin.onClick := lstbox_opt_skinClick;
  lbl_opt_skin_url.onClick := lbl_opt_skin_urlClick;
  lbl_opt_skin_url.onMouseLeave := lbl_opt_skin_urlMouseLeave;
  lbl_opt_skin_url.onMouseEnter := lbl_opt_skin_urlMouseEnter;

  btn_opt_torrent_chshfold.onClick := btn_opt_torrent_chshfoldClick;
  btn_opt_torrent_defshfold.onClick := btn_opt_torrent_defshfoldClick;


  Memo_opt_chat_away.onKeyPress := Memo_opt_chat_awayKeyPress;

  lbl_opt_skin_title.caption := vars_global.lbl_opt_skin_title_caption;
  lbl_opt_skin_author.caption := vars_global.lbl_opt_skin_author_caption;
  lbl_opt_skin_url.caption := vars_global.lbl_opt_skin_url_caption;
  lbl_opt_skin_version.caption := vars_global.lbl_opt_skin_version_caption;
  lbl_opt_skin_date.caption := vars_global.lbl_opt_skin_date_caption;
  lbl_opt_skin_comments.caption := vars_global.lbl_opt_skin_comments_caption;

  fill_listbox_skin;
  select_listbox_skin;
  settings_control.buttonsHeight := ares_frmmain.panel_chat.buttonsHeight;
  pgctrl_shareset.buttonsHeight := ares_frmmain.panel_chat.buttonsHeight;
  settings_control.buttonsLeftMargin := ares_frmmain.panel_chat.buttonsLeftMargin;
  pgctrl_shareset.buttonsLeftMargin := ares_frmmain.panel_chat.buttonsLeftMargin;
  settings_control.buttonsTopMargin := ares_frmmain.panel_chat.buttonsTopMargin;
  pgctrl_shareset.buttonsTopMargin := ares_frmmain.panel_chat.buttonsTopMargin;
  settings_control.buttonsLeft := ares_frmmain.panel_chat.buttonsLeft;
  pgctrl_shareset.buttonsLeft := ares_frmmain.panel_chat.buttonsLeft;
  settings_control.closebuttonLeftMargin := ares_frmmain.panel_chat.closebuttonLeftMargin;
  pgctrl_shareset.closebuttonLeftMargin := ares_frmmain.panel_chat.closebuttonLeftMargin;
  settings_control.closebuttonTopMargin := ares_frmmain.panel_chat.closebuttonTopMargin;
  pgctrl_shareset.closebuttonTopMargin := ares_frmmain.panel_chat.closebuttonTopMargin;
  settings_control.closeButtonWidth := 13;
  settings_control.closeButtonHeight := 13;
  pgctrl_shareset.closeButtonWidth := 13;
  pgctrl_shareset.closeButtonHeight := 13;
  pgctrl_shareset.font.color := font.color;
  settings_control.font.color := font.color;
  chklstbx_shareset_auto.color := COLORE_LISTVIEWS_BG;
  chklstbx_shareset_auto.font.color := COLORE_LISTVIEWS_FONT;
  mfolder.Color := COLORE_LISTVIEWS_BG;
  mfolder.font.color := COLORE_LISTVIEWS_FONT;
  pnl_opt_sharing.color := COLORE_PANELS_BG;
  pnl_opt_sharing.font.name := font.name;
  pnl_opt_sharing.font.size := font.size;
  btn_opt_chat_font.font.name := vars_global.font_chat.name;
  btn_opt_chat_font.font.size := vars_global.font_chat.size;
  btn_opt_chat_font.font.style := vars_global.font_chat.style;
  btn_opt_chat_font.font.color := vars_global.font_chat.color;
  init_avatar;
end;



procedure tfrm_settings.select_listbox_skin;
var
 i: Integer;
 str_comp: string;
 nameselected: string;
begin

nameselected := widestrtoutf8str(skin_directory);
for i := length(nameselected) downto 1 do if nameselected[i]='\' then begin
 delete(nameselected,1,i);
 break;
end;

 for i := 0 to frm_settings.lstbox_opt_skin.count-1 do begin
   str_comp := widestrtoutf8str(frm_settings.lstbox_opt_skin.Items.Strings[i]);
   if str_comp=nameselected then begin
     frm_settings.lstbox_opt_skin.Selected[i] := True;
     break;
   end;
 end;


end;

procedure tfrm_settings.Memo_opt_chat_awayKeyPress(Sender: TObject; var Key: Char);
var
 edit_chat: TtntMemo;
begin
edit_chat := (sender as ttntMemo);

 case integer(key) of
  2:begin
     edit_chat.text := edit_chat.text+chr(2);
     key := char(vk_cancel);
    edit_chat.SelStart := length(edit_chat.text);
  end;
 end;

end;

procedure tfrm_settings.settings_controlPanelShow(Sender, aPanel: TObject);
var
 pnl: TCometPagePanel;
begin
pnl := aPanel as TcometPagePanel;
 if pnl.panel=pnl_opt_sharing then begin
  ares_frmmain.lbl_opt_statusconn.visible := False;
  ares_frmmain.btn_opt_connect.visible := False;
  ares_frmmain.btn_opt_disconnect.visible := False;
  ares_frmmain.lbl_shareset_hint.visible := True;
  ares_frmmain.lbl_shareset_hint.left := 16;
  mfolder.onexpanding := nil;
  postMessage(self.handle,WM_USER,0,0);
 end else begin
 // btn_shareset_cancelClick(nil);
  ares_frmmain.lbl_shareset_hint.visible := False;
  ares_frmmain.lbl_opt_statusconn.visible := True;
  ares_frmmain.btn_opt_connect.visible := True;
  ares_frmmain.btn_opt_disconnect.visible := True;
 end;
end;

procedure tfrm_settings.init_manual_share(var msg:messages.tmessage);
begin
invalidate;
WaitProcessing(100);
helper_manual_share.mainGUI_init_manual_share;
end;


procedure tfrm_settings.btn_opt_torrent_defshfoldClick(Sender: TObject);
begin
try
vars_global.my_torrentFolder := vars_global.myshared_folder;{helper_urls.Get_Desktop_Path;}
 edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;

getfreedrivespace;

set_regstring('Torrents.Folder',bytestr_to_hexstr(widestrtoutf8str(vars_global.my_torrentFolder)));
except
end;
end;

procedure tfrm_settings.btn_opt_torrent_chshfoldClick(Sender: TObject);
begin
try
fold.FolderName := vars_global.my_torrentFolder;
if not Fold.execute then exit;

if direxistsW(fold.foldername) then begin
 vars_global.my_torrentFolder := fold.foldername;
  edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;
 getfreedrivespace;

 set_regstring('Torrents.Folder',bytestr_to_hexstr(widestrtoutf8str(vars_global.my_torrentFolder)));
end;

except
end;
end;

procedure tfrm_settings.lbl_opt_skin_urlMouseEnter(Sender: TObject);
begin
(sender as ttntlabel).font.style := [fsunderline];
end;

procedure tfrm_settings.lbl_opt_skin_urlMouseLeave(Sender: TObject);
begin
(sender as ttntlabel).font.style := [];
end;

procedure tfrm_settings.lbl_opt_skin_urlClick(Sender: TObject);
begin
utility_ares.browser_go((sender as ttntlabel).caption);
end;

procedure tfrm_settings.lstbox_opt_skinClick(Sender: TObject);
begin
if lstbox_opt_skin.ItemIndex=-1 then exit;
skin_directory := vars_global.app_path+'\Data\GUI\'+lstbox_opt_skin.Items.Strings[lstbox_opt_skin.ItemIndex];
helper_skin.load_new_skin;
end;

procedure tfrm_settings.DownloadHashLink1Click(Sender: TObject);
begin
download_hashlink_frommemo;
end;

procedure tfrm_settings.mfolderCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
data1,data2:ares_types.precord_mfolder;
begin
 data1 := sender.getdata(node1);
 data2 := sender.getdata(node2);
  Result := comparetext(widestrtoutf8str(extract_fnameW(utf8strtowidestr(data1^.path))),
                       widestrtoutf8str(extract_fnameW(utf8strtowidestr(data2^.path))));
end;

procedure tfrm_settings.mfolderExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
allowed := True;
screen.cursor := crhourglass;
mfolder_EnumerateFolder(node);
screen.cursor := crdefault;
end;


procedure tfrm_settings.edit_opt_proxy_passChange(Sender: TObject);
begin
vars_global.socks_password := edit_opt_proxy_pass.text;
set_regstring('Proxy.Password',bytestr_to_hexstr(widestrtoutf8str(vars_global.socks_password)));
end;

procedure tfrm_settings.edit_opt_proxy_loginChange(Sender: TObject);
begin
vars_global.socks_username := edit_opt_proxy_login.text;
set_regstring('Proxy.Username',bytestr_to_hexstr(widestrtoutf8str(vars_global.socks_username)));
end;

procedure tfrm_settings.edit_opt_proxy_addrChange(Sender: TObject);
var
 ip: string;
 port: Word;
begin
if pos(':',edit_opt_proxy_addr.text)=0 then begin
 ip := edit_opt_proxy_addr.text;
 port := 1080;
end else begin
 ip := copy(edit_opt_proxy_addr.text,1,pos(':',edit_opt_proxy_addr.text)-1);
 port := strtointdef(copy(edit_opt_proxy_addr.text,pos(':',edit_opt_proxy_addr.text)+1,length(edit_opt_proxy_addr.text)),1080);
end;
vars_global.socks_ip := ip;
vars_global.socks_port := port;

set_regstring('Proxy.Addr',ip);
set_regInteger('Proxy.Port',port);
end;



procedure tfrm_settings.btn_opt_chat_fontClick(Sender: TObject);
var
 reg: Tregistry;
begin
fontDialog1.Font.Color := btn_opt_chat_font.font.color;
fontDialog1.font.size := btn_opt_chat_font.font.size;
fontDialog1.font.Name := btn_opt_chat_font.font.name;
fontDialog1.font.style := btn_opt_chat_font.font.style;

if not FontDialog1.execute then exit;

//fontdialog1.font.style := [btn_opt_chat_font.font.style];
if fontdialog1.font.size>14 then fontdialog1.font.size := 14;
       
btn_opt_chat_font.font.name := FontDialog1.font.name;
btn_opt_chat_font.font.size := FontDialog1.font.size;
btn_opt_chat_font.font.color := FontDialog1.font.color;
if (graphics.fsBold in FontDialog1.font.style) then btn_opt_chat_font.font.style := btn_opt_chat_font.font.style+[graphics.fsbold] else btn_opt_chat_font.font.style := btn_opt_chat_font.font.style-[graphics.fsbold];
if (graphics.fsItalic in FontDialog1.font.style) then btn_opt_chat_font.font.style := btn_opt_chat_font.font.style+[graphics.fsItalic] else btn_opt_chat_font.font.style := btn_opt_chat_font.font.style-[graphics.fsItalic];

    if ((font_chat.size<>btn_opt_chat_font.font.size) or
       (font_chat.name<>btn_opt_chat_font.font.name) or
       (font_chat.color<>btn_opt_chat_font.font.color) or
       (font_chat.style<>btn_opt_chat_font.font.style)) then begin

      font_chat.name := btn_opt_chat_font.font.name;
      font_chat.size := btn_opt_chat_font.font.size;
      font_chat.style := btn_opt_chat_font.font.style;
      font_chat.color := btn_opt_chat_font.font.color;

       reg := tregistry.create;
       with reg do begin
        openkey(areskey,true);
        Writestring('ChatRoom.FontName',btn_opt_chat_font.font.name);
        Writeinteger('ChatRoom.FontSize',btn_opt_chat_font.font.size);
        writeinteger('ChatRoom.FontItalic',integer((graphics.fsItalic in FontDialog1.font.style)));
        writeinteger('ChatRoom.FontBold',integer((graphics.fsBold in FontDialog1.font.style)));
        writeInteger('ChatRoom.FontColor',FontDialog1.font.color);
        closekey;
        destroy;
       end;
      helper_gui_misc.mainGui_applychatfont;
     end;
end;

procedure tfrm_settings.btn_opt_tran_defshfoldClick(Sender: TObject);
begin
try
tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\'+STR_MYSHAREDFOLDER),nil);
vars_global.myshared_folder := data_path+'\'+STR_MYSHAREDFOLDER;
 edit_opt_tran_shfolder.text := vars_global.myshared_folder;
getfreedrivespace;

set_regstring('Download.Folder',bytestr_to_hexstr(widestrtoutf8str(vars_global.myshared_folder)));
except
end;
end;

procedure tfrm_settings.btn_opt_tran_chshfoldClick(Sender: TObject);
begin
try
fold.FolderName := vars_global.myshared_folder;
if not Fold.execute then exit;

if direxistsW(fold.foldername) then begin
 vars_global.myshared_folder := fold.foldername;
  edit_opt_tran_shfolder.text := vars_global.myshared_folder;
 getfreedrivespace;

 set_regstring('Download.Folder',bytestr_to_hexstr(widestrtoutf8str(vars_global.myshared_folder)));
end;

except
end;
end;

procedure tfrm_settings.chklstbx_shareset_autoDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  checklistbox: TCheckListBox;
  Flags: Longint;
  widstr: WideString;
begin
checklistbox := control as TCheckListBox;


 with checklistbox.canvas do begin
    FillRect(Rect);
    font.name := ares_frmmain.font.name;
    font.size := ares_frmmain.font.size;
   if (odSelected in state) then font.color := $00FEFFFF else
    font.color := COLORE_LISTVIEWS_FONT;

    if Index < checklistbox.Items.Count then begin
      Flags := checklistbox.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER);
      if not checklistbox.UseRightToLeftAlignment then Inc(Rect.Left, 2)  else
        Dec(Rect.Right, 2);
        widstr := utf8strtowidestr(hexstr_to_bytestr(checklistbox.Items[Index]));
      DrawTextW(Handle, PwideChar(widstr), Length(widstr), Rect,Flags,false);
    end;
 end;

end;

procedure tfrm_settings.chklstbx_shareset_autoClick(Sender: TObject);
begin
cambiato_setting_autoscan := True;
end;

procedure tfrm_settings.tabsheet_shareset_autoResize(Sender: TObject);
begin
  pnl_shareset_auto.width := pnl_shareset_autoscan.clientwidth-16;
  progbar_shareset_auto.width := pnl_shareset_autoscan.clientwidth-16;
  chklstbx_shareset_auto.width := pnl_shareset_autoscan.clientwidth-16;
  lbl_shareset_auto.width := pnl_shareset_auto.clientwidth-8;
  btn_shareset_atuostart.top := (pnl_shareset_autoscan.clientheight-btn_shareset_atuostart.height)-5;
  btn_shareset_atuostop.top := btn_shareset_atuostart.top;
  btn_shareset_atuocheckall.top := btn_shareset_atuostart.top;
  btn_shareset_atuoUncheckall.top := btn_shareset_atuostart.top;
  chklstbx_shareset_auto.height := (btn_shareset_atuostart.top-chklstbx_shareset_auto.top)-4;
end;

procedure tfrm_settings.thread_autoscan_end(var msg:messages.tmessage);
begin
try
if search_dir<>nil then begin
 search_dir.waitfor;
 search_dir.Free;
end;
except
end;

search_dir := nil;

 if want_stop_autoscan then begin
    want_stop_autoscan := False;
    chklstbx_shareset_auto.Items.clear;
    lbl_shareset_auto.caption := ' '+GetLangStringW(STR_HIT_START_TOBEGIN);
    progbar_shareset_auto.Position := 0;
 end;
 
end;

procedure tfrm_settings.chklstbx_shareset_autoDblClick(Sender: TObject);
var
 i: Integer;
begin
 for i := 0 to chklstbx_shareset_auto.items.count-1 do
  if chklstbx_shareset_auto.Selected[i] then begin

   Tnt_ShellExecuteW(handle,'open',pwidechar(utf8strtowidestr(hexstr_to_bytestr(chklstbx_shareset_auto.Items[i]))+'\'),'','',SW_SHOWNORMAL);
   break;
  end;
end;

procedure tfrm_settings.btn_shareset_atuostartClick(Sender: TObject);
begin
cambiato_setting_autoscan := True;
lbl_shareset_auto.caption := GetLangStringW(STR_SCAN_IN_PROGRESS);
helper_autoscan.start_autoscan_folder;
end;

procedure tfrm_settings.btn_shareset_atuoUncheckallClick(Sender: TObject);
var
 i: Integer;
begin
for i := 0 to chklstbx_shareset_auto.items.count -1 do chklstbx_shareset_auto.Checked[i] := False;
cambiato_setting_autoscan := True;
end;

procedure tfrm_settings.btn_shareset_atuocheckallClick(Sender: TObject);
var
 i: Integer;
begin
for i := 0 to chklstbx_shareset_auto.items.count -1 do chklstbx_shareset_auto.Checked[i] := True;
cambiato_setting_autoscan := True;
end;

procedure tfrm_settings.btn_shareset_atuostopClick(Sender: TObject);
begin
stop_autoscan_folder;
end;

procedure tfrm_settings.tabsheet_shareset_manuResize(Sender: TObject);
begin
lbl_shareset_manuhint.width := pnl_shareset_manual.clientwidth-16;
mfolder.width := pnl_shareset_manual.clientwidth-8;
grpbx_shareset_manuhint.width := pnl_shareset_manual.clientwidth-8;
grpbx_shareset_manuhint.top := (pnl_shareset_manual.clientheight-grpbx_shareset_manuhint.height)-5;
mfolder.height := (grpbx_shareset_manuhint.top-mfolder.top)-3;
 lbl_shareset_manuhint1.width := grpbx_shareset_manuhint.clientwidth-lbl_shareset_manuhint1.left-4;
 lbl_shareset_manuhint2.width := lbl_shareset_manuhint1.width;
end;

procedure tfrm_settings.mfolderClick(Sender: TObject);
var
 punto: TPoint;
 hitinfo: THitinfo;
begin
try
getcursorpos(punto);
punto := mfolder.screentoclient(punto);

mfolder.GetHitTestInfoAt(punto.x,punto.y,true,hitinfo);

if hitinfo.hitnode=nil then exit;

if mfolder.getnodelevel(hitinfo.hitnode)<1 then exit;


 if ((hiOnNormalIcon in hitinfo.HitPositions) or
     (hiOnStateIcon in hitinfo.HitPositions)) then begin
      mfolder_proofstates(hitinfo.hitnode);
 end;
except
end;
end;

procedure tfrm_settings.mfolderGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
data:ares_types.precord_mfolder;
level: Integer;
begin

data := mfolder.getdata(node);

   level := mfolder.getnodelevel(node);

if level=0 then celltext := 'My computer' else
if level=1 then begin
    if data^.drivetype=DRIVE_CDROM then celltext := 'CDRom '+utf8strtowidestr(data^.path) else
    if data^.drivetype=DRIVE_REMOVABLE then celltext := 'Floppy '+utf8strtowidestr(data^.path) else
    if data^.drivetype=DRIVE_FIXED then celltext := 'Local Drive '+utf8strtowidestr(data^.path) else
    if data^.drivetype=DRIVE_REMOTE then celltext := 'Network Drive '+utf8strtowidestr(data^.path) else
    celltext := 'Drive '+utf8strtowidestr(data^.path);
 end else celltext := extract_fnameW(utf8strtowidestr(data^.path));
end;

procedure tfrm_settings.mfolderFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
helper_stringfinal.finalize_mfolder(sender,node);
end;

procedure tfrm_settings.mfolderGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
size := sizeof(ares_types.record_mfolder);
end;

procedure tfrm_settings.mfolderGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
 level: Integer;
 data:ares_types.precord_mfolder;
begin
if not (vsSelected in node.states) then begin

      data := sender.getdata(node);
      level := mfolder.getnodelevel(node);
      case level of
       0:imageindex := WORKSTATION_ICON;
       1:begin
          if data^.drivetype=DRIVE_CDROM then ImageIndex := CDROM_ICON+data^.stato
          else begin
           if data^.drivetype=DRIVE_REMOTE then imageindex := NETWORK_ICON+data^.stato
            else Imageindex := DRIVE_ICON+data^.stato;
          end;
         end else begin
           if vsExpanded in node.States then imageindex := FOLDER_SELECTED+data^.stato
            else Imageindex := FOLDER_NORMAL+data^.stato;
         end;
      end;
exit;
end;

      data := sender.getdata(node);
      level := mfolder.getnodelevel(node);
      case level of
       0:Imageindex := WORKSTATION_ICON;
       1:begin
            if data^.drivetype=DRIVE_CDROM then ImageIndex := CDROM_ICON+data^.stato else
             if data^.drivetype=DRIVE_REMOTE then imageindex := NETWORK_ICON+data^.stato
              else Imageindex := DRIVE_ICON+data^.stato;
         end else begin
          if vsExpanded in node.States then imageindex := FOLDER_SELECTED+data^.stato
           else Imageindex := FOLDER_NORMAL+data^.stato;
         end;
       end;
end;

procedure tfrm_settings.pnl_opt_sharingResize(Sender: TObject);
begin
with ares_frmmain.lbl_shareset_hint do begin
 Width := ares_frmmain.btns_library.clientwidth-left;
 autosize := False;
 autosize := True;
 pgctrl_shareset.Top := 0; //top+Height+5;
end;

btn_shareset_ok.Top := (pnl_opt_sharing.clientheight-btn_shareset_ok.height)-10;
btn_shareset_cancel.Top := btn_shareset_ok.Top;
btn_shareset_ok.left := pnl_opt_sharing.clientwidth-100;
btn_shareset_cancel.Left := (pnl_opt_sharing.clientwidth-btn_shareset_cancel.width)-10;
btn_shareset_ok.left := (btn_shareset_cancel.Left-btn_shareset_cancel.width)-10;

 ares_frmmain.lbl_shareset_hint.width := pnl_opt_sharing.clientwidth-ares_frmmain.lbl_shareset_hint.left;

 with pgctrl_shareset do begin
  Width := pnl_opt_sharing.clientwidth;
  height := (btn_shareset_ok.Top-top)-10;
 end;
end;

procedure tfrm_settings.start_thread_share;
var
 paused: Boolean;
begin
try
if vars_global.share<>nil then begin
  vars_global.need_rescan := True;
  vars_global.share.terminate;
end else begin

  paused := helper_library_db.set_NEWtrusted_metas;

 vars_global.scan_start_time := gettickcount;
 vars_global.share := tthread_share.create(true);
  vars_global.share.paused := paused;
  vars_global.share.juststarted := False;
   vars_global.share.resume;
end;
except
end;
end;


procedure tfrm_settings.btn_shareset_okClick(Sender: TObject);
begin
stop_autoscan_folder;

 if cambiato_manual_folder_share then begin
  mfolder_savecheckstodisk;
   set_reginteger('Share.EverConfigured',1);
  start_thread_share;
 end else
 if cambiato_setting_autoscan then begin
  cambiato_setting_autoscan := False;
  write_prefs_autoscan;
   set_reginteger('Share.EverConfigured',1);
  start_thread_share;
 end;

 cambiato_manual_folder_share := False;
 mfolder.clear;
  cambiato_setting_autoscan := False;
 chklstbx_shareset_auto.Items.clear;
  btn_shareset_atuostart.enabled := True;
  btn_shareset_atuostop.enabled := False;
  btn_shareset_atuocheckall.enabled := False;
  btn_shareset_atuoUncheckall.enabled := False;
 lbl_shareset_auto.caption := ' '+GetLangStringW(STR_HIT_START_TOBEGIN);
 progbar_shareset_auto.Position := 0;

 settings_control.activePage := 0;
// btn_lib_settings.onclick := btn_lib_settingsClick;
end;

procedure tfrm_settings.btn_shareset_cancelClick(Sender: TObject);
begin
cambiato_manual_folder_share := False;
mfolder.clear;

stop_autoscan_folder;

 cambiato_setting_autoscan := False;
 chklstbx_shareset_auto.Items.clear;

 btn_shareset_atuostart.enabled := True;
 btn_shareset_atuostop.enabled := False;
 btn_shareset_atuocheckall.enabled := False;
 btn_shareset_atuoUncheckall.enabled := False;
 lbl_shareset_auto.caption := ' '+GetLangStringW(STR_HIT_START_TOBEGIN);
 progbar_shareset_auto.Position := 0;

 settings_control.activePage := 0;
//btn_lib_settings.onclick := btn_lib_settingsClick;
end;

procedure tfrm_settings.Check_opt_hlink_filterexeClick(Sender: TObject);
begin
vars_global.Check_opt_hlink_filterexe_checked := Check_opt_tran_filterexe.checked;
set_reginteger('Search.BlockExe',integer(vars_global.Check_opt_hlink_filterexe_checked));
end;

procedure tfrm_settings.btn_opt_proxy_checkClick(Sender: TObject);
begin
 lbl_opt_proxy_check.caption := GetLangStringW(STR_CHECKPROXY_TESTING);
 btn_opt_proxy_check.enabled := False;
 radiobtn_noproxy.enabled := False;
 radiobtn_proxy4.enabled := False;
 radiobtn_proxy5.enabled := False;
 Edit_opt_proxy_addr.Enabled := False;
 edit_opt_proxy_login.Enabled := False;
 edit_opt_proxy_pass.Enabled := False;
  helper_check_proxy.tthread_checkproxy.create(false);
end;

procedure tfrm_settings.radiobtn_noproxyClick(Sender: TObject);
var
reg: Tregistry;
begin

 lbl_opt_proxy_addr.enabled := not radiobtn_noproxy.checked;
 lbl_opt_proxy_login.enabled := lbl_opt_proxy_addr.enabled;
 lbl_opt_proxy_pass.enabled := lbl_opt_proxy_addr.enabled;
 Edit_opt_proxy_addr.enabled := lbl_opt_proxy_addr.enabled;
 edit_opt_proxy_login.enabled := lbl_opt_proxy_addr.enabled;
 edit_opt_proxy_pass.enabled := lbl_opt_proxy_addr.enabled;

  reg := tregistry.create;
  with reg do begin
   openkey(areskey,true);

  if radiobtn_noproxy.checked then begin
   vars_global.socks_type := SoctNone;
    writeinteger('Proxy.Protocol',0);
  end else
  if radiobtn_proxy4.checked then begin
   vars_global.socks_type := SoctSock4;
    writeinteger('Proxy.Protocol',4);
  end else begin
   vars_global.socks_type := SoctSock5;
    writeinteger('Proxy.Protocol',5);
  end;

    closekey;
    destroy;
   end;

end;

procedure tfrm_settings.check_opt_net_nosprnodeClick(Sender: TObject);
begin
set_reginteger('Network.NoSupernode',integer(check_opt_net_nosprnode.checked));
vars_global.check_opt_net_nosprnode_checked := check_opt_net_nosprnode.checked;
end;

procedure tfrm_settings.awayMemoChange(Sender : TObject);
begin
vars_global.memo_opt_chat_away_text := memo_opt_chat_away.text;
set_regstring('PrivateMessage.AwayMessage',bytestr_to_hexstr(widestrtoutf8str(Memo_opt_chat_away.text)));
end;

procedure Tfrm_settings.Check_opt_chat_isawayClick(Sender: TObject);
begin
vars_global.check_opt_chat_isaway_checked := check_opt_chat_isaway.checked;
memo_opt_chat_away.enabled := check_opt_chat_isaway.checked;
set_reginteger('PrivateMessage.SetAway',integer(check_opt_chat_isaway.checked));
end;

procedure Tfrm_settings.check_opt_chat_browsableClick(Sender: TObject);
begin
vars_global.check_opt_chat_browsable_checked := check_opt_chat_browsable.checked;
set_reginteger('PrivateMessage.AllowBrowse',integer(check_opt_chat_browsable.checked));
end;

procedure Tfrm_settings.check_opt_chat_noemotesClick(Sender: TObject);
begin
vars_global.check_opt_chat_noemotes_checked := check_opt_chat_noemotes.checked;
set_reginteger('ChatRoom.BlockEmotes',integer(check_opt_chat_noemotes.checked));
end;

procedure Tfrm_settings.Check_opt_chatroom_nopmClick(Sender: TObject);
begin
vars_global.Check_opt_chatroom_nopm_checked := Check_opt_chatroom_nopm.checked;
set_reginteger('ChatRoom.BlockPM',integer(Check_opt_chatroom_nopm.checked));
end;

procedure Tfrm_settings.check_opt_chat_joinpartClick(Sender: TObject);
begin
set_reginteger('ChatRoom.ShowJP',integer(check_opt_chat_joinpart.checked));
vars_global.check_opt_chat_joinpart_checked := check_opt_chat_joinpart.checked;
end;

procedure Tfrm_settings.Check_opt_chat_timeClick(Sender: TObject);
begin
set_reginteger('ChatRoom.ShowTimeLog',integer(Check_opt_chat_time.checked));
vars_global.Check_opt_chat_time_checked := Check_opt_chat_time.checked;
end;

procedure Tfrm_settings.Edit_opt_tran_upbandChange(Sender: TObject);
begin
vars_global.up_band_allow := strtointdef(Edit_opt_tran_upband.text,0);
set_reginteger('Transfer.AllowedUpBand',vars_global.up_band_allow);
end;

procedure Tfrm_settings.Edit_opt_tran_dnbandChange(Sender: TObject);
begin
vars_global.down_band_allow := strtointdef(Edit_opt_tran_dnband.text,0);
set_reginteger('Transfer.AllowedDownBand',vars_global.down_band_allow);
end;

procedure Tfrm_settings.check_opt_tran_inconidleClick(Sender: TObject);
begin
set_reginteger('Transfer.MaximizeUpBandOnIdle',integer(check_opt_tran_inconidle.checked));
vars_global.check_opt_tran_inconidle_checked := check_opt_tran_inconidle.checked;
end;

procedure Tfrm_settings.Edit_opt_tran_limupChange(Sender: TObject);
begin
 vars_global.limite_upload := strtointdef(Edit_opt_tran_limup.text,4);
 set_reginteger('Transfer.MaxUpCount',vars_global.limite_upload);
end;

procedure Tfrm_settings.Edit_opt_tran_upipChange(Sender: TObject);
begin
 vars_global.max_ul_per_ip := strtointdef(Edit_opt_tran_upip.text,3);
 set_reginteger('Transfer.MaxUpPerUser',vars_global.max_ul_per_ip);
end;


procedure Tfrm_settings.Edit_opt_tran_limdnChange(Sender: TObject);
begin
vars_global.max_dl_allowed := strtointdef(Edit_opt_tran_limdn.text,MAXNUM_ACTIVE_DOWNLOADS);
set_reginteger('Transfer.MaxDlCount',vars_global.max_dl_allowed);
end;

procedure Tfrm_settings.Edit_dataportClick(Sender: TObject);
var
 port: Integer;
begin
 port := strtointdef(Edit_opt_tran_port.text,80);
 if ((port<1) or (port>65535)) then port := 80;
 set_reginteger('Transfer.ServerPort',port);
end;

procedure Tfrm_settings.check_opt_gen_nohintClick(Sender: TObject);
begin
vars_global.check_opt_gen_nohint_checked := check_opt_gen_nohint.checked;
set_reginteger('Extra.BlockHints',integer(check_opt_gen_nohint.checked));
end;

procedure Tfrm_settings.check_opt_gen_pausevidClick(Sender: TObject);
begin
vars_global.check_opt_gen_pausevid_checked := check_opt_gen_pausevid.checked;
set_reginteger('Extra.PauseVideoOnLeave',integer(check_opt_gen_pausevid.checked));
end;

procedure Tfrm_settings.check_opt_tran_percClick(Sender: TObject);
begin
vars_global.check_opt_tran_perc_checked := check_opt_tran_perc.checked;
set_reginteger('Extra.ShowTransferPercent',integer(check_opt_tran_perc.checked));
end;

procedure Tfrm_settings.check_opt_gen_captClick(Sender: TObject);
begin
vars_global.check_opt_gen_capt_checked := check_opt_gen_capt.checked;
set_reginteger('Extra.ShowActiveCaption',integer(check_opt_gen_capt.checked));
mainGUI_refresh_caption(true);
end;

procedure Tfrm_settings.check_opt_tran_warncancClick(Sender: TObject);
begin
vars_global.check_opt_tran_warncanc_checked := check_opt_tran_warncanc.checked;
set_reginteger('Extra.WarnOnCancelDL',integer(check_opt_tran_warncanc.checked));
end;

procedure Tfrm_settings.check_opt_gen_gcloseClick(Sender: TObject);
begin
vars_global.check_opt_gen_gclose_checked := check_opt_gen_gclose.checked;
set_reginteger('General.CloseOnQuery',integer(check_opt_gen_gclose.checked));
end;

procedure Tfrm_settings.check_opt_gen_msnsongClick(Sender: TObject);
begin
vars_global.check_opt_chat_whatsong_checked := check_opt_chat_msnsong.checked;
if not check_opt_chat_msnsong.checked then uWhatImListeningTo.UpdateWhatImListeningTo('','','',false);
set_reginteger('General.WhatSongNotif',integer(check_opt_chat_msnsong.checked));
end;

procedure Tfrm_settings.check_opt_gen_autoconnectClick(Sender: TObject);
begin
vars_global.check_opt_gen_autoconnect_checked := check_opt_gen_autoconnect.checked;
set_reginteger('General.AutoConnect',integer(check_opt_gen_autoconnect.checked));
end;

procedure Tfrm_settings.check_opt_gen_autostartClick(Sender: TObject);
begin
vars_global.check_opt_gen_autostart_checked := check_opt_gen_autostart.checked;
reg_toggle_autostart;
end;

procedure Tfrm_settings.edit_opt_gen_nickChange(Sender: TObject);
begin
 vars_global.mynick := widestrtoutf8str(strippa_fastidiosi(edit_opt_gen_nick.text,chr(95){'_'}));
 vars_global.update_my_nick := True;

  set_regstring('Personal.Nickname',bytestr_to_hexstr(vars_global.mynick));
end;

procedure Tfrm_settings.Combo_opt_gen_gui_langClick(Sender: TObject);
begin
  set_regstring('General.Language',bytestr_to_hexstr(widestrtoutf8str(Combo_opt_gen_gui_lang.text)));

  localiz_loadlanguage;
  mainGui_apply_language;

  if ares_frmmain.combo_search.Items.count>1 then ares_frmmain.combo_search.items.strings[0] := GetLangStringW(PURGE_SEARCH_STR);
end;

procedure Tfrm_settings.FormCreate(Sender: TObject);
begin
init_tabs;
end;

procedure tfrm_settings.init_tabs;
begin
 color := ares_frmmain.btns_options.color;
 font := ares_frmmain.font;

 settings_control.AddPanel(IDNone,'General',[cometpageview.csDown],pnl_opt_general,nil,false,-1);
 settings_control.AddPanel(IDNone,'Transfer',[],pnl_opt_transfer,nil,false,-1);
 settings_control.AddPanel(IDNone,'Chat',[],pnl_opt_chat,nil,false,-1);
 settings_control.AddPanel(IDNone,'Network',[],pnl_opt_network,nil,false,-1);
 settings_control.AddPanel(IDNone,'Hashlinks',[],pnl_opt_hashlinks,nil,false,-1);
 settings_control.AddPanel(IDNone,'Skin',[],pnl_opt_skin,nil,false,-1);
 settings_control.AddPanel(IDNone,'Bittorrent',[],pnl_opt_bittorrent,nil,false,-1);
 settings_control.AddPanel(IDNone,'Filesharing',[],pnl_opt_sharing,nil,false,-1);
 settings_control.ActivePage := 0;
 settings_control.OnPanelShow := settings_controlPanelShow;

 pgctrl_shareset.AddPanel(IDNone,'Auto',[cometpageview.csDown],pnl_shareset_autoscan,nil,false,-1);
 pgctrl_shareset.AddPanel(IDNone,'Manual',[],pnl_shareset_manual,nil,false,-1);
 pgctrl_shareset.ActivePage := 0;

 settings_control.OnPaintButton := ufrmmain.ares_frmmain.smallTabsPaintButton;
 settings_control.OnPaintButtonFrame := ufrmmain.ares_frmmain.smalltabs_pageviewPaintButtonFrame;

 pgctrl_shareset.OnPaintButton := ufrmmain.ares_frmmain.smallTabsPaintButton;
 pgctrl_shareset.OnPaintButtonFrame := ufrmmain.ares_frmmain.smalltabs_pageviewPaintButtonFrame;


end;




procedure Tfrm_settings.apply_language;
const
 TABID_OPT_GENERAL=0;
 TABID_OPT_TRANSFER=1;
 TABID_OPT_CHAT=2;
 TABID_OPT_NETWORK=3;
 TABID_OPT_HASHLINKS=4;
 TABID_OPT_SKIN=5;
 TABID_OPT_BITTORRENT=6;
 TABID_OPT_FILESHARING=7;
var
 pnl: TCometPagePanel;
 i: Integer;
begin
//filesharing
 pnl := settings_control.panels[TABID_OPT_FILESHARING];
 pnl.btncaption := GetLangstringW(STR_FILESHARING);

  //network
  pnl := settings_control.Panels[TABID_OPT_NETWORK];
  pnl.btncaption := GetLangStringW(STR_CONFIG_NETWORK);
   check_opt_net_nosprnode.caption := GetLangStringW(STR_CONF_CANTSUPERNODE);
   grpbx_opt_proxy.caption := ' '+GetLangStringW(STR_CONFIG_PROXY)+' ';
   radiobtn_noproxy.caption := GetLangStringW(STR_CONFIG_PROXY_NOTUSINGPROXY);
   radiobtn_proxy4.caption := GetLangStringW(STR_CONFIG_PROXY_USING_SOCK4);
   radiobtn_proxy5.caption := GetLangStringW(STR_CONFIG_PROXY_USING_SOCK5);
   lbl_opt_proxy_addr.caption := GetLangStringW(STR_CONFIG_PROXY_SOCKSADDR);
   lbl_opt_proxy_login.caption := GetLangStringW(STR_CONFIG_PROXY_USERNAME);
   lbl_opt_proxy_pass.caption := GetLangStringW(STR_CONFIG_PROXY_PASSWORD);
   btn_opt_proxy_check.caption := GetLangStringW(STR_CONFIG_CHECKPROXY);

     //hashlinks
        pnl := settings_control.Panels[TABID_OPT_HASHLINKS];
        pnl.btncaption := GetLangStringW(STR_CONFIG_HASHLINKS);

       btn_opt_hlink_down.caption := GetLangStringW(STR_DOWNLOAD_HASHLINK);
       Check_opt_tran_filterexe.caption := GetLangStringW(STR_FILTERPOTENTIALYDANGEROUS);
       
         //general
        pnl := settings_control.Panels[TABID_OPT_GENERAL];
        pnl.btncaption := GetLangStringW(STR_CONFIG_GENERAL);
         lbl_opt_gen_lan.caption := GetLangStringW(STR_CONF_PREFERRED_LANGUAGE);
          Combo_opt_gen_gui_lang.left := lbl_opt_gen_lan.left+lbl_opt_gen_lan.width+5;
          GrpBx_nick.caption := ' '+GetLangStringW(STR_CONFIG_PERSONAL_DETAIL)+' ';
         lbl_opt_gen_nick.caption := GetLangStringW(STR_CONF_NICKNAME);
         // edit_opt_gen_nick.left := lbl_opt_gen_nick.left+lbl_opt_gen_nick.width+5;
          //combo_opt_gen_speed.left := lbl_opt_gen_speed.left+lbl_opt_gen_speed.width+5;
         check_opt_gen_autostart.caption := GetLangStringW(STR_CONF_HKEYSETTINGS);
         check_opt_gen_autoconnect.caption := GetLangStringW(STR_CONF_AUTOCONNECT);
         check_opt_gen_gclose.caption := GetLangStringW(STR_CONF_CLOSEARESWHENSHUT);
         check_opt_gen_nohint.caption := GetLangStringW(STR_CONF_BLOCKLARGEHINTS);
         check_opt_gen_pausevid.caption := GetLangStringW(STR_CONF_PAUSEVIDEOWHENMOVING);
         check_opt_gen_capt.caption := GetLangStringW(STR_CONF_SHOWSPECCAPT);

          //transfer
          pnl := settings_control.Panels[TABID_OPT_TRANSFER];
          pnl.btncaption := GetLangStringW(STR_CONFIG_TRANSFER);
          lbl_opt_tran_port.caption := GetLangStringW(STR_CONF_ACCEPTPORT);
          Edit_opt_tran_port.left := lbl_opt_tran_port.left+lbl_opt_tran_port.width+5;
          Label_max_uploads.caption := GetLangStringW(STR_CONF_UPATONCE);
          label_max_upperip.caption := GetLangStringW(STR_CONF_UPPERUSER);
          label_max_dl.caption := GetLangStringW(STR_CONF_DLATONCE);
          grpbx_opt_tran_band.caption := ' '+GetLangStringW(STR_BANDWIDTH)+' ';
          grpbx_opt_tran_sims.caption := ' '+GetLangStringW(STR_CONFIG_TRANSFER)+' ';
          lbl_opt_tran_upband.caption := GetLangStringW(STR_CONF_UPBAND);
           Edit_opt_tran_upband.left := lbl_opt_tran_upband.left+lbl_opt_tran_upband.width+5;
          check_opt_tran_inconidle.caption := GetLangStringW(STR_CONF_INCREASEONIDLE);
          lbl_opt_tran_dnband.Caption := GetLangStringW(STR_CONF_DLBAND);
           Edit_opt_tran_dnband.Left := lbl_opt_tran_dnband.left+lbl_opt_tran_dnband.width+5;
          check_opt_tran_warncanc.caption := GetLangStringW(STR_CONF_ASKWHENCANCELLINGDL);
          check_opt_tran_perc.caption := GetLangStringW(STR_CONF_SHOWTRANPERCENT);
           grpbx_opt_tran_shfolder.caption := ' '+GetLangStringW(STR_CONFIG_SHARE_DOWNLOAD_FOLDER)+' '; //dlfolder
            lbl_opt_tran_shfolder.caption := GetLangStringW(STR_CONF_SAVEINFOLD);
            btn_opt_tran_chshfold.caption := GetLangStringW(STR_CONF_CHANGEFOLD);
            btn_opt_tran_defshfold.caption := GetLangStringW(STR_CONF_RESTOREDETAULDLFOLDER);
          //chat->room
          pnl := settings_control.Panels[TABID_OPT_CHAT];
          pnl.btncaption := GetLangStringW(STR_CONFIG_CHAT);
          Check_opt_chat_time.caption := GetLangStringW(STR_CONF_CHATTIME);
   
          check_opt_chat_joinpart.caption := GetLangStringW(STR_CONF_SHOW_JP);
         // check_opt_chat_dargbg.caption := utf8strtowidestr(STR_CHATROOM_DARKBG);
            lbl_opt_chat_avatar.caption := GetLangStringW(STR_AVATAR)+':';
            grpbx_opt_chat.caption := ' '+getLangStringW(STR_CHAT)+' ';

            Check_opt_chatroom_nopm.caption := GetLangStringW(STR_CONF_BLOCK_PVT);
            check_opt_chat_noemotes.caption := GetLangStringW(STR_CONF_BLOCK_EMOTES);
            check_opt_chat_msnsong.caption := GetLangStringW(STR_CONF_WHATSONG);
            check_opt_chat_joinremotetemplate.caption := GetLangStringW(STR_JOIN_WITHREMOTETEMPLATE);
            check_opt_chat_keepAlive.caption := GetLangStringW(STR_KEEP_ALIVE_CONNECTION);
            check_opt_chat_browsable.caption := GetLangStringW(STR_DISALLOWPVTBROWSE);
         
            Check_opt_chat_isaway.caption := GetLangStringW(STR_CONF_PVTAWAY);
           
            btn_opt_avatar_load.caption := GetLangStringW(STR_LOAD);
            btn_opt_avatar_clr.caption := GetLangStringW(STR_CLEAR);
            lbl_opt_chat_message.caption := GetLangStringW(STR_PERSONAL_MESSAGE)+':';
             cmbo_opt_chat_country.Items.beginupdate;
             cmbo_opt_chat_country.Items.clear;
             cmbo_opt_chat_country.Items.add('');
             for i := low(country_strings) to high(country_strings) do cmbo_opt_chat_country.Items.add(country_strings[i]);
             cmbo_opt_chat_country.Items.endupdate;
              cmbo_opt_chat_sex.items.clear;
              cmbo_opt_chat_sex.items.add('');
              cmbo_opt_chat_sex.items.add(GetLangStringW(STR_MALE));
              cmbo_opt_chat_sex.items.add(GetLangStringW(STR_FEMALE));
              lbl_opt_chat_age.caption := getLangStringW(STR_AGE)+':';
               edit_opt_chat_age.left := lbl_opt_chat_age.left+lbl_opt_chat_age.width+5;
              lbl_opt_chat_sex.caption := GetLangStringW(STR_SEX)+':';
              lbl_opt_chat_country.caption := GetLangStringW(STR_COUNTRY)+':';
              lbl_opt_chat_statecity.caption := GetlangStringW(STR_STATECITY)+':';

             //bittorrent
            pnl := settings_control.Panels[TABID_OPT_BITTORRENT];
            pnl.btncaption := STR_BITTORRENT;
             grpbx_opt_bittorrent_dlfolder.caption := grpbx_opt_tran_shfolder.caption;
             lbl_opt_torrent_shfolder.caption := lbl_opt_tran_shfolder.caption;
             btn_opt_torrent_chshfold.caption := btn_opt_tran_chshfold.caption;
             btn_opt_torrent_defshfold.caption := btn_opt_tran_defshfold.caption;
            // check_opt_torrent_assoc.caption := GetLangStringW(STR_BITTORRENT_ASSOCIATION);


   btn_shareset_ok.caption := GetLangStringW(STR_OK);
   btn_shareset_cancel.caption := GetLangStringW(STR_CANCEL);
     ares_frmmain.lbl_shareset_hint.caption := GetLangStringW(STR_CONF_FILESHARE_TIP);
      lbl_shareset_manuhint.caption := GetLangStringW(STR_CONF_MANUALFILESHARE_TIP);
      grpbx_shareset_manuhint.caption := ' '+GetLangStringW(STR_CONF_LEGEND)+' ';
      lbl_shareset_manuhint1.caption := GetLangStringW(STR_CONF_THISFOLDERNOTSHARE);
      lbl_shareset_manuhint2.caption := GetLangStringW(STR_CONF_THISFOLDERSHARED);

   pnl := pgctrl_shareset.panels[0];
      pnl.btncaption := GetLangStringW(STR_CONFIG_SHARE_SYSTEMSCAN);
      pnl := pgctrl_shareset.panels[1];
      pnl.btncaption := GetLangStringW(STR_CONFIG_SHARE_MANUAL);
        lbl_shareset_auto.caption := ' '+GetLangStringW(STR_HIT_START_TOBEGIN);
        btn_shareset_atuostart.caption := GetLangStringW(STR_CONF_START_SCAN);
        btn_shareset_atuostop.caption := GetLangStringW(STR_CONF_STOP_SCAN);
        btn_shareset_atuocheckall.caption := GetLangStringW(STR_CONF_CHECKALL);
        btn_shareset_atuoUncheckall.caption := GetLangStringW(STR_CONF_UNCHECKALL);
        
end;


procedure Tfrm_settings.edit_opt_chat_autologChange(Sender: TObject);
var
 str,tempstr: string;
 sha1:secureHash.tsha1;
begin
  tempstr := widestrtoutf8str(edit_opt_chat_autolog.text);
  if length(tempstr)=0 then begin
   set_regstring('ChatRoom.AutoLoginPass','');
   exit;
  end;

  sha1 := tsha1.create;
  sha1.Transform(tempstr[1],length(tempstr));
   sha1.Complete;
   str := sha1.HashValue;
  sha1.Free;
  set_regstring('ChatRoom.AutoLoginPass',bytestr_to_hexstr(str));
end;



procedure Tfrm_settings.cmbo_opt_chat_sexClick(Sender: TObject);
begin
 vars_global.user_sex := cmbo_opt_chat_sex.itemindex;
 set_regInteger('Personal.Sex',vars_global.user_sex);
end;

procedure Tfrm_settings.cmbo_opt_chat_countryClick(Sender: TObject);
begin
 vars_global.user_country := cmbo_opt_chat_country.itemindex;
 set_regInteger('Personal.Country',vars_global.user_country);
end;

procedure Tfrm_settings.edit_opt_chat_statecityChange(Sender: TObject);
begin
 vars_global.user_statecity := trim(widestrtoutf8str(edit_opt_chat_statecity.text));
 set_regString('Personal.StateCity',vars_global.user_statecity);
end;

procedure Tfrm_settings.edit_opt_chat_ageChange(Sender: TObject);
begin
 vars_global.user_age := strtointdef(edit_opt_chat_age.text,18);
 set_regInteger('Personal.Age',vars_global.user_age);
end;

procedure Tfrm_settings.edit_opt_chat_messageChange(Sender: TObject);
var
 str: string;
begin
 str := trim(widestrtoutf8str(edit_opt_chat_message.text));
 set_regString('Personal.CustomMessage',str);
 if high(ares_frmmain.panel_chat.panels)>0 then helper_channellist.broadCastChildChatrooms('PERSMSG'+str+CHRNULL);
end;

procedure Tfrm_settings.check_opt_chat_keepAliveClick(Sender: TObject);
begin
set_reginteger('ChatRoom.KeepAlive',integer(check_opt_chat_keepAlive.checked));
end;

procedure Tfrm_settings.check_opt_chat_joinremotetemplateClick(Sender: TObject);
begin
 vars_global.chat_enabled_remoteJSTemplate := check_opt_chat_joinremotetemplate.checked;
 set_regInteger('ChatRoom.UseRemoteTemplate',integer(vars_global.chat_enabled_remoteJSTemplate));
 if vars_global.chat_enabled_remoteJSTemplate then begin
  ares_frmmain.JoinTemplate1.caption := GetLangStringW(STR_JOIN_WITHOUTTEMPLATE);
  ares_frmmain.JoinTemplate2.caption := ares_frmmain.JoinTemplate1.caption;
 end else begin
  ares_frmmain.JoinTemplate1.caption := GetLangStringW(STR_JOIN_WITHREMOTETEMPLATE);
  ares_frmmain.JoinTemplate2.caption := ares_frmmain.JoinTemplate1.caption;
 end;
end;

procedure Tfrm_settings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
try
 img_opt_avatar.picture.bitmap.FreeImage;
except
end;
end;

procedure Tfrm_settings.btn_opt_gen_aboutClick(Sender: TObject);
begin
with tfrmabout.create(application) do show;
end;

end.
