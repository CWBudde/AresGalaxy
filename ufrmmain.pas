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
Ares main form, general UI events and procedures
}

unit ufrmmain; 

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, tntforms,Forms, Dialogs,
  Menus, ComCtrls, OleCtrls, ExtCtrls, StdCtrls,registry,ImgList,uTrayIcon,
  Buttons,comobj,ActiveX,messages,cometTrees,synsock,Drag_N_Drop, directshow9,
  TntStdCtrls,TntButtons,TntComCtrls,OleServer,TntExtCtrls,
  comettrack,WinSplit,XPbutton,zlib,richedit,
  tntdialogs,tntsysutils,tntwindows, TntMenus,tntsystem, themes,
  CheckLst, comettopicpnl, CmtHint,math,
  folderBrowse, DSPack ,
  ufrmhint,
  blcksock,
  ares_types,
  ares_objects,
  classes2,
  class_cmdlist,
  const_ares,
  utility_ares,
  thread_upload,
  thread_share,
  thread_download,
  thread_client,
  thread_terminator,
  thread_supernode,
  helper_channellist,
  helper_manual_share,
  helper_visual_headers,
  helper_check_proxy,
  vars_localiz,
  helper_diskio,
  helper_strings,
  helper_crypt,
  helper_base64_32,
  helper_urls,
  helper_ipfunc,
  helper_mimetypes,
  SecureHash,
  umediar,
  helper_datetime,
  helper_combos,
  helper_registry,
  helper_bighints,
  helper_visual_library,
  helper_share_settings,
  helper_preview,
  vars_global,
  const_win_messages,
  helper_params,
  helper_search_gui,
  helper_altsources,
  helper_library_db,
  helper_playlist,
  helper_hashlinks,
  helper_arescol,
  helper_player,
  helper_gui_misc,
  node_upgrade,
  helper_download_misc,
  helper_stringfinal,
  helper_findmore,
  helper_autoscan,
  helper_share_misc,
  const_timeouts,
  helper_chat_favorites,
  helper_skin,
  helper_unicode,
  btcore,
  bitTorrentStringFunc,
  DSUtil,
  AsyncExTypes,
  shoutcast,
  uWhatImListeningTo, mPlayerPanel, cometPageView, XPMan, cometbtnedit,
  uflvplayer,ufrm_settings,thread_bittorrent,unetPlayer,helper_upnp;




type
  Tares_frmmain = class(TTntForm, IAsyncExCallBack)
    Popup_search: TTntPopupMenu;
    img_mime_small: TImageList;
    Download1: TTntMenuItem;
    Popup_library: TTntPopupMenu;
    AddRemovefolderstosharelist2: TTntMenuItem;
    Timer_sec: TTimer;
    imglist_transfer: TImageList;
    PopupMenuvideo: TTntPopupMenu;
    Fullscreen2: TTntMenuItem;
    OpenPlay1: TTntMenuItem;
    Locate1: TTntMenuItem;
    Play1: TTntMenuItem;
    Stop2: TTntMenuItem;
    Pause1: TTntMenuItem;
    N1: TTntMenuItem;
    Openwithexternalplayer2: TTntMenuItem;
    Addtoplaylist1: TTntMenuItem;
    ShareUn1: TTntMenuItem;
    N5: TTntMenuItem;
    DeleteFile2: TTntMenuItem;
    fittoscreen1: TTntMenuItem;
    Popup_download: TTntPopupMenu;
    Cancel2: TTntMenuItem;
    ClearIdle2: TTntMenuItem;
    OpenPreview2: TTntMenuItem;
    NewSearch1: TTntMenuItem;
    N6: TTntMenuItem;
    PauseResume1: TTntMenuItem;
    N12: TTntMenuItem;
    Addtoplaylist2: TTntMenuItem;
    Locate2: TTntMenuItem;
    Popup_upload: TTntPopupMenu;
    OpenPlay2: TTntMenuItem;
    LocateFile1: TTntMenuItem;
    Addtoplaylist3: TTntMenuItem;
    N13: TTntMenuItem;
    Cancel1: TTntMenuItem;
    BanUser1: TTntMenuItem;
    N4: TTntMenuItem;
    N10: TTntMenuItem;
    Stopsearch1: TTntMenuItem;
    ImageList_chat: TImageList;
    popup_chat_chanlist: TTntPopupMenu;
    Joinchannel1: TTntMenuItem;
    imagelist_lib_max: TImageList;
    ClearIdle1: TTntMenuItem;
    PauseallUnpauseAll1: TTntMenuItem;
    Play3: TTntMenuItem;
    Originalsize1: TTntMenuItem;
    Findmoreofthesameartist1: TTntMenuItem;
    Artist1: TTntMenuItem;
    Genre1: TTntMenuItem;
    Findmorefromthesame2: TTntMenuItem;
    Artist3: TTntMenuItem;
    Genre3: TTntMenuItem;
    Openexternal1: TTntMenuItem;
    OpenExternal2: TTntMenuItem;
    Popup_queue: TTntPopupMenu;
    Blockhost1: TTntMenuItem;
    MenuItem7: TTntMenuItem;
    MenuItem8: TTntMenuItem;
    MenuItem9: TTntMenuItem;
    MenuItem10: TTntMenuItem;
    MenuItem11: TTntMenuItem;
    MenuItem12: TTntMenuItem;
    Findmorefromthesame1: TTntMenuItem;
    Artist2: TTntMenuItem;
    Genre2: TTntMenuItem;
    TrayIcon1: TTrayIcon;
    Popup_playlist: TTntPopupMenu;
    playlist_RemoveAll1: TTntMenuItem;
    playlist_Removeselected1: TTntMenuItem;
    playlist_openext: TTntMenuItem;
    playlist_Locate: TTntMenuItem;
    playlist_Sort1: TTntMenuItem;
    playlist_Alphasortasc: TTntMenuItem;
    playlist_Alphasortdesc: TTntMenuItem;
    playlist_sortInv: TTntMenuItem;
    MenuItem14: TTntMenuItem;
    playlist_Randomplay1: TTntMenuItem;
    playlist_Continuosplay1: TTntMenuItem;
    fol: TBrowseForFolder;
    imagelist_menu: TImageList;
    panel_playlist: TcometTopicPnl;
    btn_playlist_close: TXPbutton;
    listview_playlist: TCometTree;
    popup_tray: TTntPopupMenu;
    tray_Play: TTntMenuItem;
    tray_Pause: TTntMenuItem;
    tray_Stop: TTntMenuItem;
    N2: TTntMenuItem;
    tray_showPlaylist: TTntMenuItem;
    N11: TTntMenuItem;
    tray_quit: TTntMenuItem;
    tray_Minimize: TTntMenuItem;
    OpenDialog1: TTntOpenDialog;
    SaveDialog1: TTntSaveDialog;
    popup_lib_virfolders: TTntPopupMenu;
    AddtoPlaylist4: TTntMenuItem;
    GrantSlot1: TTntMenuItem;
    ExportHashLink1: TTntMenuItem;
    popup_lib_regfolders: TTntPopupMenu;
    AddtoPlaylist5: TTntMenuItem;
    OpenFolder1: TTntMenuItem;
    imagelist_panel_search: TImageList;
    ExportHashlink4: TTntMenuItem;
    imglist_mfolder: TImageList;
    imglist_emotic: TImageList;
    CmtHint: TCmtHint;
    Saveas1: TTntMenuItem;
    Exporthashlink5: TTntMenuItem;
    popup_capt_player: TTntPopupMenu;
    OpenExternal3: TTntMenuItem;
    Locate3: TTntMenuItem;
    addtoplaylist6: TTntMenuItem;
    Grantslot2: TTntMenuItem;
    AddtoFavorites1: TTntMenuItem;
    popup_chat_fav: TTntPopupMenu;
    Join1: TTntMenuItem;
    Remove1: TTntMenuItem;
    N3: TTntMenuItem;
    ExportHashlink6: TTntMenuItem;
    N15: TTntMenuItem;
    RemoveSource1: TTntMenuItem;
    imglist_stars: TImageList;
    RemoveSource2: TTntMenuItem;
    AutoJoin1: TTntMenuItem;
    ListentoRadio1: TTntMenuItem;
    N16: TTntMenuItem;
    New1: TTntMenuItem;
    N20: TTntMenuItem;
    Riptodisk1: TTntMenuItem;
    Locate4: TTntMenuItem;
    Enable1: TTntMenuItem;
    ExportHashlink7: TTntMenuItem;
    Directory1: TTntMenuItem;
    tmr_stop_radio: TTimer;
    timer_start_bittorrent: TTimer;
    Volume1: TTntMenuItem;
    timer_fullScreenHideCursor: TTimer;
    MPlayerPanel1: TMPlayerPanel;
    trackbar_player: Tcomettrack;
    tabs_pageview: TCometPageView;
    XPManifest1: TXPManifest;
    btns_library: TCometTopicPnl;
    btn_lib_addtoplaylist: TXPbutton;
    btn_lib_delete: TXPbutton;
    btn_lib_refresh: TXPbutton;
    btn_lib_toggle_details: TXPbutton;
    btn_lib_toggle_folders: TXPbutton;
    btn_lib_virtual_view: TXPbutton;
    btn_lib_regular_view: TXPbutton;
    btns_options: TCometTopicPnl;
    lbl_opt_statusconn: TTntLabel;
    btn_opt_connect: TXPbutton;
    btn_opt_disconnect: TXPbutton;
    btns_transfer: TCometTopicPnl;
    btn_tran_cancel: TXPbutton;
    btn_tran_clearidle: TXPbutton;
    btn_tran_locate: TXPbutton;
    btn_tran_play: TXPbutton;
    btn_tran_toggle_queup: TXPbutton;
    panel_transfer: TPanel;
    panel_tran_down: TCometTopicPnl;
    treeview_download: TCometTree;
    panel_tran_upqu: TCometTopicPnl;
    treeview_queue: TCometTree;
    treeview_upload: TCometTree;
    splitter_transfer: TWinSplit;
    splitter_library: TWinSplit;
    panel_search: TCometTopicPnl;
    Label_date_search: TTntLabel;
    icon_mime_search: TImage;
    lbl_capt_search: TTntLabel;
    label_back_src: TTntLabel;
    label_more_searchopt: TTntLabel;
    Label_title_search: TTntLabel;
    Label_auth_search: TTntLabel;
    label_cat_search: TTntLabel;
    label_album_search: TTntLabel;
    label_lang_search: TTntLabel;
    label_sel_duration: TTntLabel;
    label_sel_size: TTntLabel;
    label_sel_quality: TTntLabel;
    lbl_srcmime_all: TTntLabel;
    lbl_srcmime_audio: TTntLabel;
    lbl_srcmime_video: TTntLabel;
    lbl_srcmime_document: TTntLabel;
    lbl_srcmime_image: TTntLabel;
    lbl_srcmime_software: TTntLabel;
    lbl_srcmime_other: TTntLabel;
    combo_lang_search: TComboBox;
    combo_wanted_duration: TComboBox;
    combo_wanted_quality: TComboBox;
    combo_wanted_size: TComboBox;
    combotitsearch: TTntComboBox;
    comboautsearch: TTntComboBox;
    combocatsearch: TTntComboBox;
    comboalbsearch: TTntComboBox;
    combodatesearch: TTntComboBox;
    combo_sel_duration: TTntComboBox;
    combo_sel_quality: TTntComboBox;
    combo_sel_size: TTntComboBox;
    Btn_start_search: TTntButton;
    btn_stop_search: TTntButton;
    combo_search: TTntComboBox;
    radio_srcmime_all: TTntRadioButton;
    radio_srcmime_audio: TTntRadioButton;
    radio_srcmime_video: TTntRadioButton;
    radio_srcmime_image: TTntRadioButton;
    radio_srcmime_document: TTntRadioButton;
    radio_srcmime_software: TTntRadioButton;
    radio_srcmime_other: TTntRadioButton;
    panel_hash: TCometTopicPnl;
    lbl_hash_file: TTntLabel;
    lbl_hash_folder: TTntLabel;
    lbl_hash_progress: TTntLabel;
    lbl_hash_pri: TTntLabel;
    lbl_hash_hint: TTntLabel;
    lbl_hash_filedet: TTntLabel;
    progbar_hash_file: TProgressBar;
    hash_pri_trx: TTrackBar;
    progbar_hash_total: TProgressBar;
    listview_lib: TCometTree;
    panel_details_library: TCometTopicPnl;
    lbl_title_detlib: TTntLabel;
    lbl_descript_detlib: TTntLabel;
    lbl_url_detlib: TTntLabel;
    lbl_categ_detlib: TTntLabel;
    lbl_author_detlib: TTntLabel;
    lbl_album_detlib: TTntLabel;
    lbl_language_detlib: TTntLabel;
    lbl_year_detlib: TTntLabel;
    lbl_folderlib_hint: TTntLabel;
    lbl_lib_fileshared: TTntLabel;
    edit_language: TComboBox;
    edit_title: TTntEdit;
    edit_description: TTntMemo;
    edit_url_library: TTntEdit;
    combocatlibrary: TTntComboBox;
    edit_author: TTntEdit;
    edit_album: TTntEdit;
    edit_year: TTntEdit;
    chk_lib_fileshared: TTntCheckBox;
    treeview_lib_regfolders: TCometTree;
    treeview_lib_virfolders: TCometTree;
    panel_chat: TCometPageView;
    panel_list_channels: TCometTopicPnl;
    Splitter_chat_channel: TWinSplit;
    pnl_chat_fav: TCometTopicPnl;
    treeview_chat_favorites: TCometTree;
    listview_chat_channel: TCometTree;
    pagesrc: TCometPageView;
    panel_src_default: TCometTopicPnl;
    lbl_shareset_hint: TTntLabel;
    lbl_src_status: TTntLabel;
    edit_lib_search: TCometbtnEdit;
    edit_src_filter: TCometbtnEdit;
    N22: TTntMenuItem;
    loadplaylist1: TTntMenuItem;
    saveplaylist1: TTntMenuItem;
    addfile1: TTntMenuItem;
    addfolder1: TTntMenuItem;
    N23: TTntMenuItem;
    clientPanel: TPanel;
    Shoutcast1: TTntMenuItem;
    uner21: TTntMenuItem;
    RadioToolbox1: TTntMenuItem;
    ImageList_tabs: TImageList;
    panel_screen: TPanel;
    panel_vid: TCometTopicPnl;
    tvchannels: TCometTree;
    splitter_screen: TWinSplit;
    popup_screen_netstreams: TTntPopupMenu;
    play_netstream: TTntMenuItem;
    JoinTemplate1: TTntMenuItem;
    JoinTemplate2: TTntMenuItem;
    hiddenPanel: TPanel;
    btns_chat: TCometTopicPnl;
    btn_chat_fav: TXPbutton;
    btn_chat_join: TXPbutton;
    btn_chat_refchanlist: TXPbutton;
    edit_chat_chanfilter: TCometbtnEdit;
    btn_chat_host: TXPbutton;
    timerSetChatIDX: TTimer;


    procedure FormShow(Sender: TObject);
    procedure Btn_start_searchClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure minimizeapp(Sender: TObject);
    procedure restoreapp(Sender: TObject);
    procedure appexcept(sender: Tobject; e:exception);
    procedure btn_stop_searchClick(Sender: TObject);
    procedure Download1Click(Sender: TObject);
    procedure tray_quitClick(Sender: TObject);
    procedure tray_MinimizeClick(Sender: TObject);
    procedure flatedit1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure listview_srcGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_srcGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure listview_srcGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex;  var CellText: WideString);
    procedure listview_srcAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure listview_srcDblClick(Sender: TObject);
    procedure Folders1Click(Sender: TObject);
    procedure Moreinfo1Click(Sender: TObject);
    procedure listview_libGetSize(Sender: TBaseCometTree;var Size: Integer);
    procedure listview_libGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_libGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure deleteClick(Sender: TObject);
    procedure listview_libClick(Sender: TObject);
    procedure Edit_titleKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure Edit_keywordsKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure Edit_category_videoClick(Sender: TObject);
    procedure chk_lib_filesharedMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ShareUnsharefile1Click(Sender: TObject);
    procedure Timer_secTimer(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure treeview_downloadGetSize(Sender: TBaseCometTree;var Size: Integer);
    procedure treeview_downloadGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_downloadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_downloadAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure ToolButton21Click(Sender: TObject);
    procedure RadiosearchmimeClick(Sender: TObject);
    procedure OpenPreview1Click(Sender: TObject);
    procedure panel_vidResize(Sender: TObject);
    procedure Fullscreen2Click(Sender: TObject);
    procedure btn_player_pauseClick(Sender: TObject);
    procedure btn_player_playClick(Sender: TObject);
    procedure OpenPlay1Click(Sender: TObject);
    procedure Locate1Click(Sender: TObject);
    procedure track_not_enabled_to_change(Sender: TObject);
    procedure btn_tab_webXPButtonDraw(Sender: Tobject; TargetCanvas: Tcanvas; Rect: TRect; state:XPbutton.TCometBtnState; var should_continue:boolean);
    procedure btn_player_volClick(Sender: TObject);
    procedure Openwithexternalplayer1Click(Sender: TObject);
    procedure ksoOfficeSpeedButton13Click(Sender: TObject);
    procedure treeview_uploadGetSize(Sender: TBaseCometTree;var Size: Integer);
    procedure treeview_uploadGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure TreeviewHeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
    procedure treeview_uploadAfterCellPaint(Sender: TBaseCometTree;TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;CellRect: TRect);
    procedure treeview_uploadGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
    procedure panel_transferResize(Sender: TObject);
    procedure resize_pannellobottom_editchat(Sender: TObject);
    procedure PauseResume1Click(Sender: TObject);
    procedure split_tranCanResize(Sender: TObject; var NewSize: Integer;var Accept: Boolean);
    procedure Addtoplaylist1Click(Sender: TObject);
    procedure Addtoplaylist2Click(Sender: TObject);
    procedure Popup_downloadPopup(Sender: TObject);
    procedure treeview_uploadDblClick(Sender: TObject);
    procedure Locate2Click(Sender: TObject);
    procedure OpenPlay2Click(Sender: TObject);
    procedure locateupload3Click(Sender: TObject);
    procedure listview_srcMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Addtoplaylist3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Cancel1Click(Sender: TObject);
    procedure treeview_uploadMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure BanUser1Click(Sender: TObject);
    procedure combocatlibraryClick(Sender: TObject);
    procedure treeview_downloadMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_downloadMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_uploadMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure panel_tran_upquResize(Sender: TObject);
    procedure panel_tran_downResize(Sender: TObject);
    procedure label_back_srcClick(Sender: TObject);
    procedure label_more_searchoptClick(Sender: TObject);
    procedure radio_search_allClick(Sender: TObject);
    procedure TreeView2GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure btn_lib_virtual_viewClick(Sender: TObject);
    procedure btn_lib_refreshClick(Sender: TObject);
    procedure splitter_libraryEndSplit(Sender: TObject);
    procedure btn_playlist_closeClick(Sender: TObject);
    procedure btn_chat_refchanlistClick(Sender: TObject);
    procedure listview_chat_channelGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure listview_chat_channelGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_srcMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Joinchannel1Click(Sender: TObject);
    procedure listview_chat_channelMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure testoURLClick(Sender: TObject; const URLText: String;Button: TMouseButton);
    procedure listview_libMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Connect1Click(Sender: TObject);
    procedure Disconnect1Click(Sender: TObject);
    procedure treeview_lib_regfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_lib_regfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_lib_regfoldersGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_srcFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure listview_libFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure listview_playlistGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_downloadfreenode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_uploadfreenode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure listview_chat_channelFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_lib_virfoldersClick(Sender: TObject);
    procedure treeview_lib_regfoldersClick(Sender: TObject);
    procedure listview4SelectionChange(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_lib_virfoldersKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure treeview_lib_regfoldersKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure edit_lib_searchKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure listview_srcPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex );
    procedure btn_tran_locateClick(Sender: TObject);
    procedure PauseallUnpauseAll1Click(Sender: TObject);
    procedure Play3Click(Sender: TObject);
    procedure hash_pri_trxChanged(Sender: TObject);
    procedure treeview_downloadHintStart(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_lib_virfoldersGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_downloadHintStop(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_lib_virfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure videoDblClick(Sender: TObject);
    procedure Originalsize1Click(Sender: TObject);
    procedure edit_src_filterKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure listview_libKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure ClearIdle2Click(Sender: TObject);
    procedure ClearIdle1Click(Sender: TObject);
    procedure Artist1Click(Sender: TObject);
    procedure Genre1Click(Sender: TObject);
    procedure Artist2Click(Sender: TObject);
    procedure Genre2Click(Sender: TObject);
    procedure Artist3Click(Sender: TObject);
    procedure Genre3Click(Sender: TObject);
    procedure Openexternal1Click(Sender: TObject);
    procedure OpenExternal2Click(Sender: TObject);
    procedure browsebtnClick(Sender: TObject);
    procedure btn_tran_toggle_queupClick(Sender: TObject);
    procedure treeview_queuefreenode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_queueGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_queueGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_playlistFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_queueMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Blockhost1Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure treeview_queueGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_queueMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_queueHintStop(Sender: TBaseCometTree);
    procedure Connect1DrawItem(Sender: TObject; ACanvas: TCanvas;ARect: TRect; Selected: Boolean);
    procedure playlist_RemoveAll1Click(Sender: TObject);
    procedure playlist_Removeselected1Click(Sender: TObject);
    procedure playlist_openextClick(Sender: TObject);
    procedure playlist_LocateClick(Sender: TObject);
    procedure playlist_Randomplay1Click(Sender: TObject);
    procedure playlist_Continuosplay1Click(Sender: TObject);
    procedure playlist_AlphasortascClick(Sender: TObject);
    procedure playlist_AlphasortdescClick(Sender: TObject);
    procedure listview_playlistDblClick(Sender: TObject);
    procedure listview_playlistMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure listview_playlistKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure treeview_lib_regfoldersFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeview_lib_virfoldersGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_playlistGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_playlistGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure Loadplaylist1Click(Sender: TObject);
    procedure Saveplaylist1Click(Sender: TObject);
    procedure playlist_sortInvClick(Sender: TObject);
    procedure btn_playlist_addfileClick(Sender: TObject);
    procedure btn_playlist_addfolderClick(Sender: TObject);
    procedure listview_srcCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure listview_libCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure trackbar_playerTimer(sender: TObject; CurrentPos,StopPos: Cardinal);
    procedure filtroGraphComplete(sender: TObject; Result: HRESULT;Renderer: IBaseFilter);
    procedure panel_vidMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure treeview_downloadCompareNodes(Sender: TBaseCometTree;Node1, Node2: PCmtVNode; Column: TColumnIndex;var Result: Integer);
    procedure treeview_uploadCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure listview_chat_channelCompareNodes(Sender: TBaseCometTree;Node1, Node2: PCmtVNode; Column: TColumnIndex;var Result: Integer);
    procedure panel_playlistResize(Sender: TObject);
    procedure combo_lang_searchClick(Sender: TObject);
    procedure listview_playlistCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure treeview_lib_virfoldersCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure combotitsearchKeyPress(Sender: TObject; var Key: Char);
    procedure edit_titleKeyPress(Sender: TObject; var Key: Char);
    procedure treeview_lib_virfoldersMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure AddtoPlaylist4Click(Sender: TObject);
    procedure listview_chat_channelAfterCellPaint(Sender: TBaseCometTree;TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;CellRect: TRect);
    procedure pvt_unhide(sender: Tobject);
    procedure edit_chat_chanfilterKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure combo_chat_searchClick(Sender: TObject);
    procedure listview_chat_channelCollapsed(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure listview_libPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode;Column: TColumnIndex);
    procedure GrantSlot1Click(Sender: TObject);
    procedure treeview_downloadMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
    procedure libraryOnResize(Sender: TObject);
    procedure webOnResize(Sender: TObject);
    procedure treeviewbrowseCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure treeviewbrowseFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
    procedure treeviewbrowseGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeviewbrowseGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeviewbrowseGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure paintToolbar(sender: TObject; Acanvas: TCanvas; capt: WideString; var should_continue:boolean);
    procedure ExportHashLink1Click(Sender: TObject);

    procedure treeview_lib_regfoldersMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure AddtoPlaylist5Click(Sender: TObject);
    procedure treeview_lib_regfoldersCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure btn_lib_regular_viewClick(Sender: TObject);
    procedure OpenFolder1Click(Sender: TObject);
    procedure treeview_downloadDblClick(Sender: TObject);
    procedure panel_searchDrawHeaderBody(sender: TObject; TargetCanvas: TCanvas; aRect: TRect;HeaderColor: TColor);
    procedure label_back_srcMouseEnter(Sender: TObject);
    procedure label_back_srcMouseLeave(Sender: TObject);
    procedure panel_details_libraryAfterDraw(Sender: TObject;TargetCanvas: TCanvas);
    procedure panel_searchDraw(sender: TObject; Acanvas: TCanvas; capt: WideString; var should_continue:boolean);
    procedure panel_searchMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure panel_searchMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ExportHashlink4Click(Sender: TObject);
    procedure treeview_lib_regfoldersExpanding(Sender: TBaseCometTree;Node: PCmtVNode; var Allowed: Boolean);
    procedure treeview_downloadPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure trackbar_playerChange(Sender: TObject);
    procedure MsgScreenHandler(var Msg: TMsg; var Handled: Boolean);
    procedure listview_chat_channelResize(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Exporthashlink5Click(Sender: TObject);
    procedure Locate3Click(Sender: TObject);
    procedure OpenExternal3Click(Sender: TObject);
    procedure addtoplaylist6Click(Sender: TObject);
    procedure Grantslot2Click(Sender: TObject);
    procedure btn_chat_favClick(Sender: TObject);
    procedure treeview_chat_favoritesAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure treeview_chat_favoritesFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_chat_favoritesGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_chat_favoritesGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_chat_favoritesGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_chat_favoritesCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure AddtoFavorites1Click(Sender: TObject);
    procedure Join1Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure treeview_chat_favoritesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ExportHashlink6Click(Sender: TObject);
    procedure radiostationclick(Sender: TObject);
    procedure RemoveSource1Click(Sender: TObject);
    procedure lbl_srcmime_audioClick(Sender: TObject);
    procedure lbl_srcmime_videoClick(Sender: TObject);
    procedure lbl_srcmime_documentClick(Sender: TObject);
    procedure lbl_srcmime_imageClick(Sender: TObject);
    procedure lbl_srcmime_softwareClick(Sender: TObject);
    procedure lbl_srcmime_otherClick(Sender: TObject);
    procedure lbl_lib_filesharedClick(Sender: TObject);
    procedure panel_vidDblClick(Sender: TObject);
    procedure TntFormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure listview_chat_channelPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure listview_chat_channelCollapsing(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
    procedure treeview_uploadPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure RemoveSource2Click(Sender: TObject);
    procedure AutoJoin1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Locate4Click(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
    procedure btn_player_radioClick(Sender: TObject);
    procedure ExportHashlink7Click(Sender: TObject);
    procedure tmr_stop_radioTimer(Sender: TObject);
    procedure Volume1Click(Sender: TObject);
    procedure timer_fullScreenHideCursorTimer(Sender: TObject);
    procedure fullscreenMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure PopupMenuvideoPopup(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TntFormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure panel_player_captclick(Sender: TObject);
    procedure MPlayerPanel1Click(BtnId: TMPlayerButtonID);
    procedure MPlayerPanel1BtnHint(BtnId: TMPlayerButtonID);
    procedure TntFormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure tabs_pageviewPaintButtonFrame(Sender: TObject; aCanvas: TCanvas; paintRect: TRect);
    procedure smalltabs_pageviewPaintButtonFrame(Sender: TObject; aCanvas: TCanvas; paintRect: TRect);
    procedure tabs_pageviewPaintButton(Sender, aPanel: TObject; aCanvas: TCanvas; paintRect: TRect);
    procedure smallTabsPaintButton(Sender, aPanel: TObject; aCanvas: TCanvas; paintRect: TRect);
    procedure tabs_pageviewPanelShow(Sender, aPanel: TObject);
    procedure blendPlaylistFormDeactivate(Sender: TObject);
    procedure resizeSearch(Sender: TObject);
    procedure splitter_transferEndSplit(Sender: TObject);
    procedure btns_transferResize(Sender: TObject);
    procedure Splitter_chat_channelEndSplit(Sender: TObject);
    procedure panel_chatResize(Sender: TObject);

    procedure pnl_chat_favResize(Sender: TObject);
    procedure panel_chatPaintCloseButton(Sender, aPanel: TObject; aCanvas: TCanvas; paintRect: TRect);
    procedure btns_optionsResize(Sender: TObject);
    procedure pagesrcPanelShow(Sender, aPanel: TObject);
    procedure pagesrcPanelClose(Sender, aPanel: TObject; var Proceed: Boolean);
    procedure edit_src_filterClick(Sender: TObject);
    procedure edit_lib_searchPaint(Sender: TObject; aCanvas: TCanvas; paintRect: TRect; btnState: TCometBtnState);
    procedure edit_lib_searchClick(Sender: TObject);
    procedure edit_lib_searchBtnClick(Sender: TObject);
    procedure edit_chat_chanfilterBtnClick(Sender: TObject);
    procedure edit_chat_chanfilterClick(Sender: TObject);
    procedure edit_chat_chanfilterBtnStateChange(Sender: TObject);
    procedure edit_src_filterBtnClick(Sender: TObject);
    procedure listview_libPaintHeader(Sender: TBaseCometTree; TargetCanvas: TCanvas; R: TRect; isDownIndex, isHoverIndex: Boolean; var shouldContinue: Boolean);
    procedure AddRemovefolderstosharelist2Click(Sender: TObject);
    procedure tray_showPlaylistClick(Sender: TObject);

    procedure Stop2Click(Sender: TObject);
    procedure panel_playlistPaint(sender: TObject; Acanvas: TCanvas; capt: WideString; var should_continue: Boolean);
    procedure radio_srcmime_audioMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TntFormPaint(Sender: TObject);
    procedure enableSysMenus;
    procedure Shoutcast1Click(Sender: TObject);
    procedure uner21Click(Sender: TObject);
    procedure RadioToolbox1Click(Sender: TObject);
    procedure tray_StopClick(Sender: TObject);
    procedure listview_playlistPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure FlashPlayerFSCommand(ASender: TObject; const command, args: WideString);
    procedure NetPlayerFSCommand(ASender: TObject; const command, args: WideString);
    procedure btn_chat_hostClick(Sender: TObject);
    procedure timer_start_bittorrentTimer(Sender: TObject);
    procedure splitter_screenEndSplit(Sender: TObject);
    procedure panel_screenResize(Sender: TObject);
    procedure tvchannelsPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure tvchannelsGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure tvchannelsGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure tvchannelsFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure tvchannelsAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure tvchannelsDblClick(Sender: TObject);
    procedure tvchannelsCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure tvchannelsHeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvchannelsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure play_netstreamClick(Sender: TObject);
    procedure tvchannelsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure JoinTemplate1Click(Sender: TObject);
    procedure JoinTemplate2Click(Sender: TObject);
    procedure panel_chatPanelClose(Sender, aPanel: TObject; var Proceed: Boolean);
    procedure panel_chatPanelShow(Sender, aPanel: TObject);
    procedure resizeChatChannel(Sender: TObject);
    procedure timerSetChatIDXTimer(Sender: TObject);
  private
      FDecsSecond: Byte;
    procedure CheckMouseCapture;
    procedure DrawMouseOverButtons(var Message: TWMNCHitTest; point: Tpoint);
    procedure drawOverButtons(Overmin:boolean=false; OverMax:boolean=false; OverClose:boolean=false);
    procedure init_gui_first(sender: Tobject);
    procedure init_gui_second(sender: Tobject);
    procedure init_core_first(Sender: TObject);
    procedure init_global_vars;
    procedure init_threads_var;
    procedure init_lists;
    procedure init_hint_wnd;
    procedure init_GUI_last;
    procedure trigger_sendedit_chat(edit_chat: Ttntedit);
    procedure delete_file_da_tree_normal(folder_id: Word; was_shared:boolean);
    procedure shared_unshare_treeview_normal(folder_id: Word; shared:boolean);
    procedure tthread_lists_free;
    procedure check_incoming_data;

    function AsyncExFilterState(Buffering: LongBool; PreBuffering: LongBool; Connecting: LongBool; Playing: LongBool; BufferState: integer): HRESULT; stdcall;
    function AsyncExICYNotice(IcyItemName: PChar; ICYItem: PChar): HRESULT; stdcall;
    function AsyncExMetaData(Title: PChar; URL: PChar): HRESULT; stdcall;
    function AsyncExSockError(ErrString: PChar): HRESULT; stdcall;

     procedure global_shutdown; overload;
     procedure global_shutdown(dummy:boolean); overload;
     procedure global_shutdown(var message: Tmessage); overload; message WM_USER_QUIT;
    procedure thread_share_end(var msg: Tmessage); message WM_THREADSHARE_END;
    Procedure DropFile (var message: TWMDropFiles); message WM_DROPFILES;
    procedure previewstart_event(var msg: Tmessage); message WM_PREVIEW_START;

    procedure WMQueryEndSession(var Message: TWMQUERYENDSESSION); message WM_QUERYENDSESSION;
    procedure WMUserShow(var msg: Tmessage); message WM_USERSHOW;
   // procedure WMEntsizeMove(var msg: Tmessage); message WM_ENTERSIZEMOVE;
  //  procedure WMExisizeMove(var msg: Tmessage); message WM_EXITSIZEMOVE;
    procedure WMNCLButtonDblClk(var Message : TWMNCLButtonDblClk);  message WM_NCLBUTTONDBLCLK;
    procedure WMNCLButtonUp(var Message : TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMNCHitTest(var Message : TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDown(var Message : TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMChatDataReceived(var M: TWMCopyData); message WM_COPYDATA;
   protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMSyscommand(var msg: TWmSysCommand);  message WM_SYSCOMMAND;

   public
      FrameRgn:HRgn;
      FSizing: Boolean;
      FMinDown,FMaxDown,FCloseDown: Boolean;
      isMaximised: Boolean;
      oldwidth,oldheight,oldleft,oldtop: Integer;
    procedure update_status_transfer;
    procedure paintFrame;
    procedure resizeFLVPlayer;
    procedure resizeNETPlayer;
  end;

 procedure MaximiseForm(MyForm: TForm);
 function Drag_And_Drop_AddFile(FileName : wideString; count : integer): Boolean;
 procedure SetAnimation(Value: Boolean);
 function GetAnimation: Boolean;
 procedure DrawAppMinimizeAnimation(isMinimize:boolean);

var
  ares_frmmain: Tares_frmmain;
  ThemeServices: TThemeServices;
  imgscnlogo: Timage;
  GblTopMostList: Tlist;

implementation

uses
 uctrvol,dhtconsts,dhtkeywords,dhttypes,
 BitTorrentUtils,helper_ares_nodes,mysupernodes,thread_dht;

{$R *.DFM}

function GetAnimation: Boolean;
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  if SystemParametersInfo(SPI_GETANIMATION, SizeOf(Info), @Info, 0) then
    Result := Info.iMinAnimate <> 0 else
    Result := False;
end;

procedure SetAnimation(Value: Boolean);
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  BOOL(Info.iMinAnimate) := Value;
  SystemParametersInfo(SPI_SETANIMATION, SizeOf(Info), @Info, 0);
end;

procedure DrawAppMinimizeAnimation(isMinimize:boolean);
var
 FormRect,TrayRect: TRect;
 hTray: THandle;
begin
hTray := FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0,'TrayNotifyWnd', nil);
if hTray=0 then exit;

FormRect := ares_frmmain.BoundsRect;
GetWindowRect(hTray, TrayRect);

if isMinimize then DrawAnimatedRects(ares_frmmain.Handle, IDANI_CAPTION, FormRect, TrayRect)
 else DrawAnimatedRects(ares_frmmain.Handle, IDANI_CAPTION, TrayRect, FormRect);
end;

///////////////// FRAME SKIN NC DRAWING
procedure tares_frmmain.WMWindowPosChanging(var Message: TWMWindowPosChanging);

  procedure HandleEdge(var Edge: Integer; SnapToEdge: Integer;
    SnapDistance: Integer = 0);
  begin
    if (Abs(Edge + SnapDistance - SnapToEdge) < 10) then
      Edge := SnapToEdge - SnapDistance;
  end;

var
 xr,yr: Integer;
begin

 if (isMaximised) and (helper_skin.skinnedFrameLoaded) then begin
  xr := GetSystemMetrics(SM_CXFRAME);
  yr := GetSystemMetrics(SM_CYFRAME);
  Message.WindowPos^.x := screen.WorkAreaRect.Left-xr;
  Message.WindowPos^.y := screen.WorkAreaRect.top-yr;
  exit;
 end;


  if ((Message.WindowPos^.X <> 0) or (Message.WindowPos^.Y <> 0)) then
    with Message.WindowPos^, Monitor.WorkareaRect do
    begin
      if helper_skin.SkinnedFrameLoaded then begin
       xr := GetSystemMetrics(SM_CXFRAME);
       yr := GetSystemMetrics(SM_CYFRAME);
      end else begin
       xr := 0;
       yr := 0;
      end;
      HandleEdge(x, Left, Monitor.WorkareaRect.Left+yr);
      HandleEdge(y, Top, Monitor.WorkareaRect.Top+yr);
      HandleEdge(x, Right, Width-xr);
      HandleEdge(y, Bottom, Height-yr);
    end;

  inherited;
end;



procedure tares_frmmain.WMNCLButtonDown(var Message : TWMNCLButtonDown);
begin
if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;

  if IsIconic(Handle) then begin
   inherited;  {Call default processing.}
   exit;
  end;


  if (isMaximised) then begin
   if Message.HitTest=HTSYSMENU then inherited;
   exit;
  end;
            
    case Message.HitTest of

    HTMINBUTTON:begin
       //canvas.draw(clientwidth+skinParser.MinimiseLeft,skinParser.MinimiseTop,minimiseDownBitmap);
       SetCapture(self.handle);
       FMinDown := True;
       FMaxDown := False;
       FCloseDown := False;
      end;

    HTMAXBUTTON:begin
          //canvas.draw(clientwidth+skinParser.MaximiseLeft,skinParser.MaximiseTop,skinParser.maximisedDownBitmap);
          SetCapture(self.handle);
          FMaxDown := True;
          FMinDown := False;
          FCloseDown := False;
      end;

     HTCLOSE:begin
        SetCapture(self.handle);
        FCloseDown := True;
        FMinDown := False;
        FMaxDown := False;
        //canvas.draw(clientwidth+skinParser.closeLeft,skinParser.closeTop,skinParser.closeDownBitmap);
      end;

    else begin
      inherited;  {Call default processing.}
    end;
    end;

end;
        
procedure tares_frmmain.WMNCHitTest(var Message : TWMNCHitTest);
var
  point: TPoint;
  sizeHe: Integer;
  //,sizeWi: Integer;
begin

  if not helper_skin.skinnedFrameLoaded then begin
   inherited;  {Call default processing.}
   exit;
  end;

   point.x := Message.Pos.x;
   point.y := Message.Pos.y;
   point := ScreenToClient(point);
                              
  // inc(point.X,GetSystemMetrics(SM_CXSIZEFRAME));
   sizeHe := GetSystemMetrics(SM_CYSIZEFRAME);

  if (point.x<=helper_skin.FBorderWidth) and (not isMaximised) then begin
    CheckMouseCapture;
    if (point.y<helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTTOPLEFT
     else
     if (point.Y>=clientheight-helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTBOTTOMLEFT
      else
      if not isMaximised then Message.Result := HTLEFT
       else Message.result := windows.HTNOWHERE;
  end else
  if (point.x>=clientwidth-helper_skin.FBorderWidth) and (not isMaximised) then begin
    CheckMouseCapture;
    drawOverButtons;
    if (point.y<helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTTOPRIGHT
     else
     if (point.Y>=clientheight-helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTBOTTOMRIGHT
      else
       if not isMaximised then Message.result := HTRIGHT
        else Message.result := windows.HTNOWHERE;
  end else
  if point.y>=clientheight-helper_skin.FBorderHeight then begin
   CheckMouseCapture;
   if not isMaximised then Message.result := HTBOTTOM
    else Message.result := windows.HTNOWHERE;
  end else
  if point.y<sizeHe then begin
   CheckMouseCapture;
   drawOverButtons;
   if not isMaximised then Message.Result := HTTOP
    else Message.result := windows.HTNOWHERE;
  end else
  if ((point.y>=sizeHe{default border height}) and (point.y<=helper_skin.FCaptionHeight)) then begin
    if point.x<clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth then begin
     CheckMouseCapture;
     drawOverButtons;
     if ((point.x<helper_skin.FCaptionIconRect.Left+16) and
         (helper_skin.FCaptionIconRect.left>0)) then message.result := HTSYSMENU
      else
     Message.Result := HTCAPTION;
    end else DrawMouseOverButtons(Message,point); //HTCLOSE; //HTMAXBUTTON//HTMAXBUTTON
  end else begin
    CheckMouseCapture;
    drawOverButtons;
    Message.Result := HTCLIENT;
  end;

end;

procedure tares_frmmain.CMMouseLeave(var Msg: TMessage);
begin
if not helper_skin.skinnedFrameLoaded then exit;
 if getCapture<>self.Handle then begin
  FCloseDown := False;
  FMaxDown := False;
  FMinDown := False;
 end;
 drawOverButtons;
end;

procedure tares_frmmain.paintFrame;
var
 rc: TRect;
 pointx,pointy: Integer;

begin

 canvas.Lock;
 
 // top left
 bitBlt(canvas.handle,
        0,0,helper_skin.FrameTopLefTBitmap.SourceCopyWidth,helper_skin.FrameTopLefTBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.Handle,
        helper_skin.FrameTopLefTBitmap.SourceCopyleft,helper_skin.FrameTopLefTBitmap.SourceCopyTop,
        SRCCopy);

 // top
 pointx := helper_skin.FrameTopLefTBitmap.SourceCopyWidth;
 while (pointx<clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth) do begin
  BitBlt(canvas.handle,
         pointx,0,helper_skin.FrameTopBitmap.SourceCopyWidth,helper_skin.FrameTopBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameTopBitmap.SourceCopyleft,helper_skin.FrameTopBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointx,helper_skin.FrameTopBitmap.SourceCopyWidth);
 end;


 //lefttop
  bitBlt(canvas.handle,
        0,helper_skin.FrameTopLefTBitmap.SourceCopyHeight,helper_skin.FrameLeftTopBitmap.SourceCopyWidth,helper_skin.FrameLeftTopBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.Handle,
        helper_skin.FrameLeftTopBitmap.SourceCopyleft,helper_skin.FrameLeftTopBitmap.SourceCopyTop,
        SRCCopy);


 // left border
 pointy := helper_skin.FrameTopLefTBitmap.SourceCopyHeight+helper_skin.FrameLeftTopBitmap.SourceCopyHeight;
 while (pointy<(clientHeight-helper_skin.FrameLeftBottomBitmap.SourceCopyHeight)-helper_skin.FrameBottomLefTBitmap.SourceCopyHeight) do begin
 // canvas.Draw(0,pointy,helper_skin.lefTBitmap);
  BitBlt(canvas.handle,
         0,pointY,helper_skin.FrameLefTBitmap.SourceCopyWidth,helper_skin.FrameLefTBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.Handle,
         helper_skin.FrameLefTBitmap.SourceCopyleft,helper_skin.FrameLefTBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointy,helper_skin.FrameLefTBitmap.SourceCopyHeight);
 end;
  

 // left bottom corner
 BitBlt(canvas.handle,
        0,(clientHeight-helper_skin.FrameLeftBottomBitmap.SourceCopyHeight)-helper_skin.FrameBottomLefTBitmap.SourceCopyHeight,helper_skin.FrameLeftBottomBitmap.SourceCopyWidth,helper_skin.FrameLeftBottomBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameLeftBottomBitmap.SourceCopyleft,helper_skin.FrameLeftBottomBitmap.SourceCopyTop,
        SRCCopy);

 // bottom left corner
 BitBlt(canvas.handle,
        0,clientHeight-helper_skin.FrameBottomLefTBitmap.SourceCopyHeight,helper_skin.FrameBottomLefTBitmap.SourceCopyWidth,helper_skin.FrameBottomLefTBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameBottomLefTBitmap.SourceCopyleft,helper_skin.FrameBottomLefTBitmap.SourceCopyTop,
        SRCCopy);



 // bottom border
 pointx := helper_skin.FrameBottomLefTBitmap.SourceCopyWidth;
 while (pointx<clientwidth-helper_skin.FrameBottomRighTBitmap.SourceCopyWidth) do begin
  BitBlt(canvas.handle,
         pointx,clientheight-helper_skin.FrameBottomBitmap.SourceCopyHeight,helper_skin.FrameBottomBitmap.SourceCopyWidth,helper_skin.FrameBottomBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameBottomBitmap.SourceCopyleft,helper_skin.FrameBottomBitmap.SourceCopyTop,
         SRCCopy);
 // canvas.draw(pointx,clientheight-helper_skin.bottomBitmap.height,helper_skin.bottomBitmap);
  inc(pointx,helper_skin.FrameBottomBitmap.SourceCopyWidth);
 end;

 //right border
 pointy := helper_skin.FrameTopRigthBitmap.SourceCopyHeight+helper_skin.FrameRightTopBitmap.SourceCopyHeight;
 while (pointy<(clientheight-helper_skin.FrameBottomRighTBitmap.SourceCopyHeight)-helper_skin.FrameRightBottomBitmap.SourceCopyHeight) do begin
  BitBlt(canvas.handle,
         clientwidth-helper_skin.FrameRighTBitmap.SourceCopyWidth,pointY,helper_skin.FrameRighTBitmap.SourceCopyWidth,helper_skin.FrameRighTBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameRighTBitmap.SourceCopyleft,helper_skin.FrameRighTBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointy,helper_skin.FrameRighTBitmap.SourceCopyHeight);
 end;


  //rightbottom
  BitBlt(canvas.handle,
         clientWidth-helper_skin.FrameRightBottomBitmap.SourceCopyWidth,(clientHeight-helper_skin.FrameBottomRighTBitmap.SourceCopyHeight)-helper_skin.FrameRightBottomBitmap.SourceCopyHeight,helper_skin.FrameRightBottomBitmap.SourceCopyWidth,helper_skin.FrameRightBottomBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameRightBottomBitmap.SourceCopyleft,helper_skin.FrameRightBottomBitmap.SourceCopyTop,
         SRCCopy);



 //bottom right
 BitBlt(canvas.handle,
        clientwidth-helper_skin.FrameBottomRighTBitmap.SourceCopyWidth,clientHeight-helper_skin.FrameBottomRighTBitmap.SourceCopyHeight,helper_skin.FrameBottomRighTBitmap.SourceCopyWidth,helper_skin.FrameBottomRighTBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameBottomRighTBitmap.SourceCopyleft,helper_skin.FrameBottomRighTBitmap.SourceCopyTop,
        SRCCopy);

 // rightTop border
 BitBlt(canvas.handle,
        clientwidth-helper_skin.FrameRightTopBitmap.SourceCopyWidth,helper_skin.FrameTopLefTBitmap.SourceCopyHeight,helper_skin.FrameRightTopBitmap.SourceCopyWidth,helper_skin.FrameRightTopBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameRightTopBitmap.SourceCopyleft,helper_skin.FrameRightTopBitmap.SourceCopyTop,
        SRCCopy);



 if helper_skin.FCaptionIconRect.left>=0 then  begin
   DrawIconEx(canvas.handle, helper_skin.FCaptionIconRect.left,helper_skin.FCaptionIconRect.Top,self.icon.Handle, 0, 0, 0, 0, DI_NORMAL);
  end;

   canvas.font.color := helper_skin.color_skinned_caption;
   canvas.font.name := font.name;
   canvas.font.size := font.size;
   canvas.font.style := [fsBold];

   rc := rect(helper_skin.FCaptionRect.left,helper_skin.FCaptionRect.top,width-helper_skin.FrameTopRigthBitmap.SourceCopyWidth,helper_skin.FrameTopLefTBitmap.SourceCopyHeight-helper_skin.FCaptionRect.top);

   SetBkMode(canvas.Handle, TRANSPARENT);
   canvas.brush.style := bsclear;
   Windows.ExtTextOutW(canvas.Handle, helper_skin.FCaptionRect.left, helper_skin.FCaptionRect.top, ETO_CLIPPED, @rc, PWideChar(caption),Length(Caption), nil);


    // top right...buttons
   bitBlt(canvas.handle,
          clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth,0,helper_skin.FrameTopRigthBitmap.SourceCopyWidth,helper_skin.FrameTopRigthBitmap.SourceCopyHeight,
          helper_skin.FrameSourceBitmap.canvas.Handle,
          helper_skin.FrameTopRigthBitmap.SourceCopyleft,helper_skin.FrameTopRigthBitmap.SourceCopyTop,
          SRCCopy);

    canvas.unlock;

end;

procedure tares_frmmain.CheckMouseCapture;
begin

if GetCapture<>self.handle then begin
 FMinDown := False;
 FMaxDown := False;
 FCloseDown := False;
end;

end;

procedure MaximiseForm(MyForm: TForm);
var
  r: TRect;
  xr,yr: Integer;
begin

  xr := GetSystemMetrics(SM_CXFRAME);
  yr := GetSystemMetrics(SM_CYFRAME);
  
      r := myform.Monitor.WorkareaRect;
      //r := screen.WorkAreaRect;
      setWindowPos(myform.handle,0,
                   r.Left-xr,r.top-yr,
                   (r.right-r.left)+1+(xr*2),(r.bottom-r.top)+1+(yr*2),
                   SWP_NOZORDER);

end;

procedure tares_frmmain.DrawMouseOverButtons(var Message: TWMNCHitTest; point: Tpoint);
var
HasCapture: Boolean;
begin
hasCapture := (GetCapture=self.handle);

 if ((point.x>=width+helper_skin.MinimisebtnHitRect.Left) and (point.x<=(width+helper_skin.MinimisebtnHitRect.Left)+helper_skin.MinimisebtnHitRect.right) and
     (point.y>=helper_skin.MinimisebtnHitRect.Top) and (point.y<=helper_skin.MinimisebtnHitRect.Top+helper_skin.MinimisebtnHitRect.bottom)) then begin
  Message.result := HTMINBUTTON;
  DrawOverButtons(true,false,false);
   if ((not HasCapture) and (FminDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTMINBUTTON,0) else
   if not HasCapture then begin
    FMinDown := False;
    FCloseDown := False;
    FMaxDown := False;
   end;
 // if HasCapture then
  // if FMinDown then application.Minimize;
 end else
 if ((point.x>=width+helper_skin.MaximisebtnHitRect.Left) and (point.x<=(width+helper_skin.MaximisebtnHitRect.Left)+helper_skin.MaximiseBtnHitRect.right) and
     (point.y>=helper_skin.MaximisebtnHitRect.Top) and (point.y<=helper_skin.MaximisebtnHitRect.Top+helper_skin.MaximisebtnHitRect.bottom)) then begin
  Message.result := HTMAXBUTTON;
  DrawOverButtons(false,true,false);
   if ((not HasCapture) and (FMaxDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTMAXBUTTON,0) else
   if not HasCapture then begin
    FMinDown := False;
    FCloseDown := False;
    FMaxDown := False;
   end;
 end else
 if ((point.x>=width+helper_skin.closebtnHitRect.Left) and (point.x<=(width+helper_skin.closebtnHitRect.Left)+helper_skin.closebtnHitRect.right) and
     (point.y>=helper_skin.closebtnHitRect.Top) and (point.y<=helper_skin.closebtnHitRect.Top+helper_skin.closebtnHitRect.bottom)) then begin
  Message.result := HTCLOSE;
  DrawOverButtons(false,false,true);
   if ((not HasCapture) and (FCloseDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTCLOSE,0) else
   if not HasCapture then begin
    FMinDown := False;
    FCloseDown := False;
    FMaxDown := False;
   end;
 end else begin
   drawOverButtons;
    //just guessing...
    if point.y<4 then Message.Result := HTTOP
     else Message.Result := HTCAPTION;
   exit;
  end;

end;

procedure tares_frmmain.drawOverButtons(Overmin:boolean=false; OverMax:boolean=false; OverClose:boolean=false);
begin

 canvas.lock;

if ((OverMin) and (not FMinDown) and (not FMaxDown) and (not FCloseDown)) then bitBlt(canvas.handle,
                                                                                      clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
                                                                                      helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                      helper_skin.FrameMinimiseHoverBitmap.SourceCopyleft,helper_skin.FrameMinimiseHoverBitmap.SourceCopyTop,
                                                                                      SRCCopy)

 else
  if ((FMinDown) and (OverMin)) then bitBlt(canvas.handle,
                                            clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
                                            helper_skin.FrameSourceBitmap.Canvas.handle,
                                            helper_skin.FrameMinimiseDownBitmap.SourceCopyleft,helper_skin.FrameMinimiseDownBitmap.SourceCopyTop,
                                            SRCCopy)

   else
   bitBlt(canvas.handle,
          clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
          helper_skin.FrameSourceBitmap.Canvas.handle,
          helper_skin.FrameMinimiseOffBitmap.SourceCopyleft,helper_skin.FrameMinimiseOffBitmap.SourceCopyTop,
          SRCCopy);




if ((OverMax) and (not FMaxDown) and (not FMinDown) and (not FCloseDown)) then bitBlt(canvas.handle,
                                                                                      clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
                                                                                      helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                      helper_skin.FrameMaximiseHoverBitmap.SourceCopyleft,helper_skin.FrameMaximiseHoverBitmap.SourceCopyTop,
                                                                                      SRCCopy)
 else
  if ((FMaxDown) and (OverMax)) then bitBlt(canvas.handle,
                                            clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
                                            helper_skin.FrameSourceBitmap.Canvas.handle,
                                            helper_skin.FrameMaximiseDownBitmap.SourceCopyleft,helper_skin.FrameMaximiseDownBitmap.SourceCopyTop,
                                            SRCCopy)
   else
    bitBlt(canvas.handle,
           clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
           helper_skin.FrameSourceBitmap.Canvas.handle,
           helper_skin.FrameMaximiseOffBitmap.SourceCopyleft,helper_skin.FrameMaximiseOffBitmap.SourceCopyTop,
           SRCCopy);



if ((OverClose) and (not FCloseDown) and (not FMaxDown) and (not FMinDown)) then bitBlt(canvas.handle,
                                                                                        clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
                                                                                        helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                        helper_skin.FrameCloseHoverBitmap.SourceCopyleft,helper_skin.FrameCloseHoverBitmap.SourceCopyTop,
                                                                                        SRCCopy)
 else
  if ((FCloseDown) and (OverClose)) then bitBlt(canvas.handle,
                                                clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
                                                helper_skin.FrameSourceBitmap.Canvas.handle,
                                                helper_skin.FrameCloseDownBitmap.SourceCopyleft,helper_skin.FrameCloseDownBitmap.SourceCopyTop,
                                                SRCCopy)
   else
    bitBlt(canvas.handle,
           clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
           helper_skin.FrameSourceBitmap.Canvas.handle,
           helper_skin.FrameCloseOffBitmap.SourceCopyleft,helper_skin.FrameCloseOffBitmap.SourceCopyTop,
           SRCCopy);

    canvas.unlock;
end;

procedure tares_frmmain.WMNCLButtonUp(var Message : TWMNCLButtonUp);
begin


if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;

  if IsIconic(self.Handle) then begin
   FCloseDown := False;
   FMaxDown := False;
   FMinDown := False;
   inherited;  {Call default processing.}
   exit;
  end;


  case Message.HitTest of

    HTMINBUTTON:begin
      Sendmessage(self.handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
    end;

    HTMAXBUTTON:begin
       if not isMaximised then SendMessage(self.Handle,WM_SYSCOMMAND,SC_MAXIMIZE,0)
        else SendMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
      end;

     HTCLOSE:begin
      if GetCapture=self.handle then ReleaseCapture;
        FCloseDown := False;
        FMaxDown := False;
        FMinDown := False;
      sendmessage(self.handle,WM_SYSCOMMAND,SC_CLOSE,0);
      exit;
     end;

     else begin
      inherited;  {Call default processing.}
     end;

    end;

    
  if GetCapture=self.handle then ReleaseCapture;
  FCloseDown := False;
  FMaxDown := False;
  FMinDown := False;
end;

procedure tares_frmmain.WMNCLButtonDblClk(var Message : TWMNCLButtonDblClk);
//var
//pt : TPoint;
begin
if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;

//pt := Point(Message.XCursor, Message.YCursor);

  if (Message.HitTest=HTCAPTION) and not IsIconic(Handle) then begin

       if windowState<>wsMaximized then SendMessage(self.Handle,WM_SYSCOMMAND,SC_MAXIMIZE,0)
        else SendMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
        
  end else
 if (Message.HitTest=HTSYSMENU) and not IsIconic(handle) then SendMessage(self.handle,WM_SYSCOMMAND,SC_CLOSE,0);
end;


///////////////////////////////////////////////////////////////////////////////
// dra&drop
/////////////////////////////////////////////////////////////////////////////
function Drag_And_Drop_AddFile(FileName : wideString; count : integer): Boolean;
var
nomeutf8,estensione: string;
shouldEnqueue: Boolean;
begin
 Result := True;

 //helper_gui_misc.showMainWindow;
 

 if copy(filename,1,4)='/ADD' then begin
  delete(filename,1,4);
  shouldEnqueue := True;
 end else shouldEnqueue := False;

 nomeutf8 := widestrtoutf8str(filename);
 estensione := lowercase(extractfileext(nomeutf8));

 if estensione='.arescol' then begin  //load arescollection
  arescol_parse_file(filename);
  exit;
 end;
 if estensione='.torrent' then begin
  bittorrentUtils.loadTorrent(filename);
  exit;
 end;
 if estensione='.m3u' then begin //load playlist file
  playlist_loadm3u(filename,false);
  if not shouldEnqueue then playlist_playnext('');
  exit;
 end;
 if estensione='.pls' then begin
  playlist_loadpls(filename);
  exit;
 end;
  if (estensione='.wax') or (estensione='.asx') then begin
  playlist_loadwax(filename);
  exit;
 end;

 if estensione='.lnk' then filename := estrai_path_da_lnk(filename); //obtain real path

  if isfolder(filename) then playlist_addfolder(nomeutf8)
   else begin
    if vars_global.playlist_visible then playlist_addfile(nomeutf8,-1,false,'');
   end;

   if (pos(estensione,PLAYABLE_IMAGE_EXT)<>0) or
      (pos(estensione,PLAYABLE_VIDEO_EXT)<>0) or
      (pos(estensione,PLAYABLE_AUDIO_EXT)<>0) then player_playnew(filename);

 {if helper_player.m_GraphBuilder<>nil then begin
  if helper_player.player_GetState<>gsStopped then exit; //already playing
 end else
 if uflvplayer.flvplayer<>nil then exit;

  helper_player.player_actualfile := '';

  if not shouldEnqueue then playlist_playnext(filename); //a call to player }
end;

procedure Tares_frmmain.DropFile(var message: TWMDropFiles);
Begin
  DropGetFiles(message,Drag_And_Drop_AddFile);
 Dropped(message); // Very important
end;
/////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////// init procedures
procedure tares_frmmain.init_global_vars;
begin

 randomize;

 FrameRgn := 0;
 helper_skin.NilFrameImages;
 blendPlaylistForm := nil;
 vars_global.IDEIsRunning := False;
 isMaximised := False;
 vars_global.InternetConnectionOK := False;
 vars_global.StopAskingChatServers := False;
 uflvPlayer.FLVPlayer := nil;
 unetPlayer.NETPlayer := nil;

// wb_inserteddivID := 0;


 frm_settings := nil;
 vars_global.trayinternetswitch := False;
 chanlistthread := nil;



 DHT_availableContacts := 0; // need bootstrap?
 DHT_AliveContacts := 0;
 DHT_possibleBootstrapClientIP := 0;
 DHT_possibleBootstrapClientPort := 0;
 DHT_hashFiles := nil;
 DHT_KeywordFiles := nil;
 DHT_LastPublishKeyFiles := 0;
 DHT_LastPublishHashFiles := 0;

 vars_global.versioneares := ARES_VERS;
 
 helper_player.m_GraphBuilder := nil;
 helper_player.m_MediaControl := nil;
 helper_player.m_AsyncEx := nil;
 helper_player.m_AsyncExControl := nil;
 helpeR_player.m_Pin := nil;
 helper_player.m_FileSource := nil;
 helper_player.m_Mp3Dec := nil;

 helper_player.FFullScreenWindow := nil;

 shoutcast.isPlayingShoutcast := False;
 shoutcast.RenderError := False;

 lista_down_temp := nil;
 imgscnlogo := nil;
 filtro2 := nil;

 BitTorrentTempList := nil;
 bittorrent_Accepted_sockets := nil;
 vars_global.thread_bittorrent := nil;
 //vars_global.thread_webtorrent := nil;

 app_minimized := False;
 last_shown_SRCtab := 0;
 typed_lines_chat := nil;
 ending_session := False;
 chat_favorite_height := 0;
 vars_global.closing := False;
 initialized := False;
 cambiato_manual_folder_share := False;
 isvideoplaying := False;
 allow_regular_paths_browse := True;
 cambiato_setting_autoscan := False;
 program_start_time := gettickcount;
 changed_download_hashes := False;
 ShareScans := 0;
 shufflying_playlist := False;
 stopped_by_user := False;
 logon_time := 0;
 vars_global.was_on_src_tab := False;
 velocita_att_upload := 0;
 velocita_att_download := 0;
 hash_select_in_library := '';
 ever_pressed_chat_list := False;
 hashing := False;
 queue_firstinfirstout := True;

 socks_type := SoctNone;
 socks_password := '';
 socks_username := '';
 socks_ip := '';
 socks_port := 0;
 ip_user_granted := 0;
 port_user_granted := 0;
 FDecsSecond := 0;
 ip_alt_granted := 0;
 image_less_top := -1;
 image_more_top := -1;
 image_back_top := -1;
 MAX_SIZE_NO_QUEUE := 256*KBYTE;
// sizexvideo := 0;
 queue_length := 0;
 numero_upload := 0;
 numero_download := 0;
 numTorrentDownloads := 0;
 numTorrentUploads := 0;
 speedTorrentDownloads := 0;
 speedTorrentUploads := 0;
 downloadedBytes := 0;
 BitTorrentDownloadedBytes := 0;
 BitTorrentUploadedBytes := 0;
 numero_queued := 0;
 localip := cAnyHost;
 previous_hint_node := nil;
 graphIsDownload := False;
 graphIsUpload := False;
 handle_obj_graphhint := INVALID_HANDLE_VALUE;
 player_actualfile := '';
 panel6sizedefault := 175;
 panelScreensizedefault := 238;
 default_width_chat := 170;
 num_seconds := 0;
 up_band_allow := 0;
 down_band_allow := 0;
 im_firewalled := True;
 update_my_nick := False;

 last_mem_check := 0;
 need_rescan := False;
 playlist_visible := False;
 should_send_channel_list := False;
 my_shared_count := 0;
 oldhintposy := 0;
 oldhintposx := 0;
 partialUploadSent := 0;
 speedUploadPartial := 0;

 helper_diskio.SetfilePointerEx := nil;
 helper_diskio.kern32handle := 0;
 


end;



procedure tares_frmmain.init_threads_var;
begin
   search_dir := nil;
   thread_down := nil;
   thread_up := nil;
   hash_server := nil;
   threadDHT := nil;
   share := nil;
   client := nil;
end;

procedure tares_frmmain.init_lists;
begin
 lista_shared := nil;
 lista_socket_accept_down := nil;
 lista_risorse_temp := nil;
 lista_risorsepartial_temp := nil;
 lista_socket_temp_proxy := nil;
 src_panel_list := tmylist.create;
 chat_chanlist_backup := tmylist.create;
 fresh_downloaded_files := nil;
end;



////////////////////////////////////////////////////////////////////////////////////
// init GUI
/////////////////////////////////////////////////////////////////////////////////////
procedure tares_frmmain.init_gui_first(sender: Tobject);  //1 second after oncreate?
begin

 with sender as ttimer do free;

 init_global_vars;
 init_threads_var;
 init_lists;


  font_chat := tfont.create;

 try
  app_path := get_app_path;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
   data_path := Get_App_DataPath+'\'+appname;
   tntwindows.Tnt_createdirectoryW(pwidechar(data_path),nil);
  end else data_path := app_path;

 except
 end;

 init_hint_wnd;
 helper_gui_misc.init_tabs_first;
 helper_skin.GetOemMenuStrings(self);

mainGUI_loadStartSkin;
localiz_loadlanguage;



 helper_gui_misc.init_Tabs_second;
 mainGui_apply_languageFirst;


 panel_Src_default.font.color := vars_global.COLORE_LISTVIEWS_FONT;
 panel_search.color := COLORE_SEARCH_PANEL;
 edit_src_filter.font.color := font.color;


panel_search.OnPaint := panel_searchDraw;

DoubleBuffered := True;
mainGui_setposition;


try
if combo_search.canFocus then combo_search.SetFocus; //fixes the hide issue in vista


except
end;

 with ttimer.create(self) do begin
  ontimer := init_gui_second;
  interval := 10;
  enabled := True;
 end;

end;

procedure tares_frmmain.init_gui_second(sender: Tobject);
begin

with sender as ttimer do free;

 prendi_prefs_reg;
 mainGui_applyChanges;
 mainGui_apply_language;
 listview_lib.bgcolor := COLORE_ALTERNATE_ROW;
 listview_lib.colors.HotColor := COLORE_LISTVIEW_HOT;
 listview_chat_channel.bgcolor := COLORE_ALTERNATE_ROW;
 listview_chat_channel.colors.HotColor := COLORE_LISTVIEW_HOT;

 panel_tran_down.capt := chr(32)+GetLangStringW(STR_DOWNLOAD)+': 0'+STR_KB+chr(32)+GetLangStringW(STR_RECEIVED);
 panel_tran_upqu.capt := chr(32)+GetLangStringW(STR_UPLOAD)+': 0'+STR_KB+chr(32)+GetLangStringW(STR_SENT);
 lbl_opt_statusconn.caption := '';
 mainGui_applymaxlengths;


 imglist_emotic.BkColor := clnone;
 imglist_emotic.BlendColor := clnone;


 panel_transferResize(panel_transfer);
 update_status_transfer;

 with trayicon1 do begin
  icon := application.icon;
  minimizetotray := True;
  enabled := True;
  showhint := True;
  ondblclick := tray_MinimizeClick;
  popupmenu := Popup_Tray;
  handle_main := self.Handle;
 end;



 try
 panelUploadHeight := get_default_upload_height(200);
 except
 end;
 
 if btn_lib_virtual_view.down then ufrmmain.ares_frmmain.btn_lib_virtual_viewclick(nil)
  else ufrmmain.ares_frmmain.btn_lib_regular_viewclick(nil);


   with ttimer.create(self) do begin
    interval := 500;
    ontimer := init_core_first;
    enabled := True;
   end;

end;

procedure tares_frmmain.init_GUI_last;
begin

   try
     if FAILED(CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC,TGUID(IID_IGraphBuilder), helper_player.m_GraphBuilder)) then begin
      helper_player.player_working := False;
     end else helper_player.player_working := True;

     helper_player.m_GraphBuilder := nil;

     with trackbar_player do begin
      OnChanged := trackbar_playerchange;

      cursor := crDefault;
      visible := True;
      TrackbarEnabled := False;
     end;

     mplayerpanel1.OnUrlClick := testoUrlClick;
     mplayerpanel1.OnCaptionClick := panel_player_captclick;
   except
      mplayerPanel1.visible := False;
      if trackbar_player<>nil then trackbar_player.visible := False;
   end;
   
   playlist_loadm3u(data_path+'\Data\default.m3u',true);

mainGui_initprefpanel;


header_download_load;
header_upload_load;

shoutcast.AddMenuRadio;
helper_chat_favorites.AutoJoinRooms;

trayicon1.iconvisible := True;

vars_global.IDEIsRunning := (FindWindow(PChar('TAppBuilder'), nil)<>0);


  helper_ares_nodes.checkNeedRefreshSnodesChat;

  unetPlayer.loadNETChannels(vars_global.app_path+'\Data\netStreams.dat');

  helper_upnp.map_ports;

end;


procedure tares_frmmain.init_hint_wnd;
begin
  try
  formhint := tfrmhint.create(self);
  with formhint do begin
   top := 10000;
   show;
    setwindowpos( handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
  end;
  except
  end;
end;

///////////////////////////////////////////////////////////
//init CORE
//////////////////////////////////////////////////////////////
procedure Tares_frmmain.init_core_first(Sender: TObject);
var
 str: string;
 tmp_str: string;
 WideStr: WideString;
 desktopPath: WideString;
begin
with sender as ttimer do free;

try
LanIPC := getlocalip;
LanIPS := ipint_to_dotstring(LanIPC);
except
 LanIPC := 0;
 LanIPS := cAnyHost;
end;

getcursorpos(prev_cursorpos);
vars_global.minutes_idle := 0;

desktopPath := Get_Desktop_Path;
reg_set_desktopPath(desktopPath+'\'+STR_MYSHAREDFOLDER);

    try

     myshared_folder := prendi_reg_my_shared_folder(desktopPath);

     if not direxistsW(myshared_folder) then begin
      if (tntwindows.Tnt_createdirectoryW(pwidechar(desktopPath+'\'+STR_MYSHAREDFOLDER),nil)) then begin
       myshared_folder := desktopPath+'\'+STR_MYSHAREDFOLDER;
      end else begin
        if not direxistsW('c:\'+STR_MYSHAREDFOLDER) then begin
         tntwindows.Tnt_createdirectoryW(pwidechar(widestring('c:\')+STR_MYSHAREDFOLDER),nil);
         myshared_folder := desktopPath+'\'+STR_MYSHAREDFOLDER;
        end;
      end;

     end;
    except
       myshared_folder := 'c:\';
    end;


     try
     my_torrentFolder := regGetMyTorrentFolder(vars_global.myshared_folder{desktopPath});
     if not dirExistsW(my_torrentFolder) then begin
      //my_torrentFolder := desktopPath;
      vars_global.my_torrentFolder := vars_global.myshared_folder;
      tntwindows.Tnt_createdirectoryW(pwidechar(my_torrentFolder),nil);
     end;
     except
       my_torrentFolder := myshared_folder;
     end;

    erase_dir_recursive(data_path+widestring('\Temp'));


   try

      vars_global.versioneares := get_program_version;
       tmp_str := vars_global.versioneares;                 //1.8.1.2927
        delete(tmp_str,1,pos('.',tmp_str));   //8.1.2927
         delete(tmp_str,1,pos('.',tmp_str));  //1.2927
          delete(tmp_str,1,pos('.',tmp_str)); //2927
           vars_global.buildno := strtointdef(tmp_str,DEFAULT_BUILD_NO);

   except
    vars_global.versioneares := ARES_VERS;
    vars_global.buildno := DEFAULT_BUILD_NO;
   end;

 if Win32Platform=VER_PLATFORM_WIN32_NT then begin // OS supports setfilepointerEX?
  helper_diskio.kern32handle := SafeLoadLibrary('kernel32.dll');
  if helper_diskio.kern32handle<>0 then
   @helper_diskio.SetfilePointerEx := GetProcAddress(helper_diskio.kern32handle,'SetFilePointerEx');
 end;

 try
 vars_global.InternetConnectionOK := utility_ares.isInternetConnectionOk;
 except
 end;

 randseed := gettickcount;

 mysupernodes.mysupernodes_create;
 lista_shared := tmylist.create;
 lista_socket_accept_down := tmylist.create;
 lista_risorse_temp := tthreadlist.create;
 lista_risorsepartial_temp := tthreadlist.create;
 lista_socket_temp_proxy := tmylist.create;
 lista_push_nostri := tmylist.create;


 DHT_hashFiles := TThreadList.create;
 DHT_KeywordFiles := TThreadList.create;
 ares_aval_nodes := tthreadlist.create;

 if lista_down_temp=nil then lista_down_temp := tmylist.create;

 scan_start_time := gettickcount;

 if thread_down=nil then thread_down := tthread_download.create(true);
 if share=nil then share := tthread_share.create(true);
 if thread_up=nil then thread_up := tthread_upload.create(true);
 if client=nil then client := tthread_client.create(false);
 if threadDHT=nil then threadDHT := tthread_dht.create(false);  


 with share do begin
  paused := False;
  juststarted := True;
  Resume;
 end;



should_show_prompt_nick := True;


try
init_GUI_last;
except
end;

try
 thread_down.resume;
 thread_up.resume;
except
end;

   try
   if WideParamCount=1 then begin
     str := widestrtoutf8str(wideparamstr(1));

     if pos(const_ares.STR_ARLNK_LOWER,lowercase(str))=1 then add_weblink(copy(str,9,length(str)))
      else if pos('magnet:?',lowercase(str))=1 then add_magnet_link(copy(str,9,length(str)))
       else Drag_And_Drop_AddFile(wideParamStr(1),0);

   end else
   if WideParamCount=2 then begin
     WideStr := '/ADD'+wideparamstr(2);
     Drag_And_Drop_AddFile(wideStr,0);
   end;


  except
  end;






timer_sec.enabled := True;
end;
/////////////////////////////////////////////////////////////////

//////////////////////////////////////// tray icon and popupmenu events


procedure Tares_frmmain.tray_MinimizeClick(Sender: TObject);
var
shouldAnimate: Boolean;
begin



if widestrtoutf8str(tray_minimize.caption)=GetLangStringA(STR_HIDE_ARES) then begin

 formhint_hide;

  if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
//  if not ares_frmmain.check_opt_gen_gclose.checked then begin
//   sendmessage(self.handle,wm_syscommand,sc_close,0);
//   exit;
//  end;

  shouldAnimate := GetAnimation;
  if shouldAnimate then begin
   SetAnimation(false);
   application.Minimize;
   SetAnimation(true);
   DrawAppMinimizeAnimation(true);
  end else application.Minimize;
  TrayIcon1.iconvisible := True;
   enableSysMenus;



end
 else begin
 //application.ShowMainForm := False;
// ares_frmmain.WindowState := wsMinimized;
// ares_frmmain.visible := False;
 tray_minimize.caption := GetLangStringW(STR_HIDE_ARES);

  shouldAnimate := GetAnimation;
  if shouldAnimate then begin
   DrawAppMinimizeAnimation(false);
    SetAnimation(false);
    application.Restore;
    SetAnimation(true);
  end else application.Restore;

 {  if ((start_minimized) and (not has_first_autopositioned_tray)) then begin
    top := 9000;
     mainGui_setposition;
     has_first_autopositioned_tray := True;
     trayicon1.iconvisible := True;
   end;
  }
  enableSysMenus;
  if vars_global.trayinternetswitch then tabs_pageview.activePage := IDTAB_SEARCH;

  
end;
end;

procedure tares_frmmain.minimizeapp(Sender: TObject);
//type TNotifyEvent = procedure (Sender: TObject) of object;
begin
showWindow(application.handle,SW_HIDE);
tray_minimize.caption := GetLangStringW(STR_SHOW_ARES);
app_minimized := True;
end;


procedure tares_frmmain.restoreapp(Sender: TObject);
begin
SetForeGroundWindow(application.handle);
if windowState=wsMinimized then sendmessage(self.handle,wm_syscommand,SC_RESTORE,0);

app_minimized := False;
end;


///////////////////////////////////////////////////////////////////

// block screensaver while viewing videos
procedure tares_frmmain.MsgScreenHandler(var Msg: TMsg; var Handled: Boolean);
begin

 if isvideoplaying then begin

   if (Msg.Message = WM_SYSCOMMAND) then
     if (Msg.wParam = SC_SCREENSAVE) or (msg.wParam = SC_MONITORPOWER) then Handled := True;
     exit;
   end;

end;
/////////////////////////////////////////////////////

///////////////////////////////////////////// self exception handler/logger
procedure tares_frmmain.appexcept(sender: Tobject; e:exception);
//var
//stream: Thandlestream;
//str: string;
//Msg: string;
//buffer: array [0..500] of char;
//freeavailable,
//totalspace: Int64;
begin
exit;
{
if num_eccept>100 then exit;

try
tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);

if not helper_diskio.FileExistsW(data_path+'\Data\Except Log.dat') then stream := Myfileopen(data_path+'\Data\Except Log.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH)
 else stream := Myfileopen(data_path+'\Data\Except Log.dat',ARES_WRITEEXISTING_WRITETHROUGH); //open to append  existing
if stream=nil then exit;

with stream do begin

 if  size>10*MEGABYTE then size := 0
  else seek(0,sofromend);  //append
try

 if position=0 then begin    //write intro
   str := 'NT='+inttostr(integer(Win32Platform=VER_PLATFORM_WIN32_NT))+',Maj='+inttostr(Win32MajorVersion)+',Min='+inttostr(Win32MajorVersion)+chr(32)+inttostr(vars_global.cpu_freq)+'MHz '+inttostr(vars_global.aval_mem)+'MB'+CRLF+
        'Install path:'+app_path+CRLF+
        'Data Path:'+data_path+CRLF;
      // if Tnt_GetDiskFreeSpaceExW(pwidechar(app_path),freeavailable,totalspace,nil) then
       //   str := str+inttostr(freeavailable div MEGABYTE)+'Mb ('+inttostr(freeavailable div GIGABYTE)+'Gb)'+CRLF;

     str := str+CRLF;
        move(str[1],buffer,length(str));
        write(buffer,length(str));
         FlushFileBuffers(handle);
 end;

  Msg := E.Message;
  if (Msg <> '') and (AnsiLastChar(Msg) > '.') then Msg := Msg + '.';

 str := formatdatetime('mm/dd/yyyy hh:nn:ss',now)+' B#:'+inttostr(buildno)+' E:'+msg+CRLF;

 move(str[1],buffer,length(str));
 write(buffer,length(str));
  FlushFileBuffers(handle);

except
end;

end; //with stream
FreeHandleStream(stream);

except
end;
inc(num_eccept);
if closing then halt; }
end;
////////////////////////////////////////////////////////////////////////////////


procedure Tares_frmmain.MenuItem11Click(Sender: TObject);
var
node:PCmtVNode;
data:precord_queued;
begin
node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);
playlist_addfile(data^.nomefile,-1,false,'');
end;

procedure Tares_frmmain.MenuItem10Click(Sender: TObject);
var
node:PCmtVNode;
data:precord_queued;
begin
node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);
locate_containing_folder(data^.nomefile);
end;

procedure Tares_frmmain.MenuItem9Click(Sender: TObject);
var
node:PCmtVNode;
data:precord_queued;
begin
node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);
open_file_external(data^.nomefile);
end;

procedure Tares_frmmain.MenuItem8Click(Sender: TObject);
var
node:PCmtVNode;
data:precord_queued;
begin
node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);
player_playnew(utf8strtowidestr(data^.nomefile));
end;


procedure tares_frmmain.global_shutdown(var message: Tmessage);
begin
if vars_global.closing then exit;

vars_global.closing := True;

trayicon1.iconvisible := False;
timer_sec.enabled := False;

visible := False;


onresize := nil;  //prevent some weird bugs?

 try
 client.terminate;
 thread_down.Terminate;
 thread_up.Terminate;
 except
 end;

 try
 if hash_server<>nil then hash_server.terminate;
 if threadDHT<>nil then threadDHT.terminate;
 if vars_global.thread_bittorrent<>nil then vars_global.thread_bittorrent.terminate;
 //if vars_global.thread_webtorrent<>nil then vars_global.thread_webtorrent.terminate;
 except
 end;

try
set_NEWtrusted_metas;
except
end;

 try
 if program_start_time>0 then stats_uptime_write(program_start_time,program_totminuptime);
 stats_maxspeed_write;
 header_search_save;
 header_upload_save;
 header_download_save;
 header_library_save('Library','Library',listview_lib);
 mainGui_saveposition;
 if ares_frmmain.btn_chat_fav.down then reg_save_chatfav_height
 except
 end;



global_shutdown;
end;


procedure tares_frmmain.global_shutdown;
begin

 terminator := tthread_terminator.create(false);


 try
 helper_player.stopmedia(nil); //stop player!
 if blendPlaylistForm<>nil then blendPlaylistForm.visible := False;
 except
 end;

 try
 if share<>nil then begin
  need_rescan := False;
   share.terminate;
   exit;
 end;
 except
 end;


 global_shutdown(true);
end;

procedure tares_frmmain.global_shutdown(dummy:boolean);
var
lastTick: Cardinal;
//i: Integer;
begin


try
playlist_savem3u(data_path+'\Data\default.m3u');

erase_dir_recursive(data_path+'\Temp');
erase_emptydir(data_path+'\Data\TempDl');
erase_directory(data_path+'\Data\TempUl');
except
end;


try
thread_down.waitfor;
thread_down.Free;
 thread_down := nil;
except
end;

try
client.waitfor;
client.Free;
  client := nil;
except
end;

try
if threadDHT<>nil then begin
 threadDHT.waitfor;
 threadDHT.Free;
 threadDHT := nil;
end;
except
end;

try
if hash_server<>nil then begin
  hash_server.WaitFor;
  hash_server.Free;
  hash_server := nil;
end;
except
end;


 //if helper_player.m_GraphBuilder<>nil then helper_player.player_NillAll;
  if filtro2<>nil then begin
    filtro2.cleargraph;
    FreeAndNil(filtro2);
  end;

try
thread_up.waitfor;
thread_up.Free;
 thread_up := nil;
except
end;

try
if vars_global.thread_bittorrent<>nil then begin
 vars_global.thread_bittorrent.waitfor;
 vars_global.thread_bittorrent.Free;
 vars_global.thread_bittorrent := nil;
end;
except
end;

{try
if vars_global.thread_webtorrent<>nil then begin
 vars_global.thread_webtorrent.waitfor;
 vars_global.thread_webtorrent.Free;
 vars_global.thread_webtorrent := nil;
end;
except
end; }

try
aresnodes_savetodisk(ares_aval_nodes);
aresnodes_freeList(ares_aval_nodes);
except
end;

  try
  if chanlistthread<>nil then begin
   chanlistthread.terminate;
   chanlistthread.waitfor;
   chanlistthread.Free;
   chanlistthread := nil;
 end;
 except
 end;
 
  try
   detach_chatrooms(true);
  except
  end;

  if vars_global.font_chat<>nil then FreeAndNil(vars_global.font_chat);
  if vars_global.typed_lines_chat<>nil then vars_global.typed_lines_chat.Free;

  try
  tthread_lists_free;
  except
  end;


helper_skin.FreeFrameBitmaps;
if FrameRgn<>0 then DeleteObject(FrameRgn);

  if ((shoutcast.isPlayingShoutcast)) then begin
         lastTick := gettickcount;
         while (gettickcount-lasttick<1500) do application.processmessages;
      end;

  ares_frmmain.timer_fullScreenHideCursor.enabled := False;
  if helper_player.FFullScreenwindow<>nil then helper_player.FFullScreenWindow.release;
  helper_player.FFullScreenWindow := nil;
  ares_frmmain.timer_fullScreenHideCursor.enabled := False;


  utility_ares.clear_treeview(treeview_download);
  utility_ares.clear_treeview(treeview_upload);
  utility_ares.clear_treeview(treeview_queue);
  utility_ares.clear_treeview(listview_lib);
  utility_ares.clear_treeview(treeview_lib_regfolders);
  utility_ares.clear_treeview(treeview_lib_virfolders);
  while (pagesrc.PanelsCount>1) do pagesrc.DeletePanel(1);

  if helper_diskio.kern32handle<>0 then FreeLibrary(helper_diskio.kern32handle);

  try
  if frm_settings<>nil then frm_settings.close;
  except
  end;

 sleep(100);
 formhint.close;

 helper_upnp.unmap_ports;

 terminator.terminate;
 terminator.waitfor;
 terminator.Free;
 
sleep(100);

 application.terminate;
end;





procedure tares_frmmain.tthread_lists_free;
var
ffile:precord_file_library;
socket: Ttcpblocksocket;
psocket:precord_socket;
push_to_go:precord_push_to_go;
down: Tdownload;
kwdlst: Tlist;
push_chat_req:precord_pushed_chat_request;
pkeyw:dhttypes.precord_DHT_keywordFilePublishReq;
Pip:precord_ipc;
//pcanale:precord_canale_chat_visual;
begin
{
try
while (list_chatchan_visual.count>0) do begin
 pcanale := list_chatchan_visual[list_chatchan_visual.count-1];
          list_chatchan_visual.delete(list_chatchan_visual.count-1);
 pcanale^.name := '';
 pcanale^.topic := '';
 FreeMem(pcanale,sizeof(record_canale_chat_visual));
end;
list_chatchan_visual.Free;
except
end; }
FreeAndNil(src_panel_list);

try
 while (helper_ares_nodes.hardFailed.count>0) do begin
   pIP := hardFailed[hardFailed.count-1];
        hardFailed.delete(hardFailed.Count-1);
   FreeMem(pIP,sizeof(record_ipc));
 end;
hardFailed.Free;
except
end;

try
if DHT_hashFiles<>nil then begin
 dhtkeywords.DHT_clear_hashFilelist;   //stop sharing
 DHT_hashFiles.Free;
end;

if DHT_KeywordFiles<>nil then begin
 kwdlst := DHT_KeywordFiles.locklist;
   while (kwdlst.count>0) do begin
     pkeyw := kwdlst[kwdlst.count-1];
            kwdlst.delete(kwdlst.count-1);
     pkeyw^.keyW := '';
     pkeyw^.fileHashes.Free;
     FreeMem(pkeyw,sizeof(record_DHT_keywordFilePublishReq));
   end;
 DHT_KeywordFiles.unlocklist;
 DHT_KeywordFiles.Free;
end;
except
end;

try
if vars_global.fresh_downloaded_files<>nil then
 FreeAndNil(vars_global.fresh_downloaded_files); //should be already empty...
except
end;

try
if lista_down_temp<>nil then begin
 try
  while (lista_down_temp.count>0) do begin
   down := lista_down_temp[lista_down_temp.count-1];
   lista_down_temp.delete(lista_down_temp.count-1);
   down.Free;
  end;
 except
 end;
lista_down_temp.Free;
end;
except
end;

try
while (lista_shared.count>0) do begin
ffile := lista_shared[lista_shared.count-1];
        lista_shared.delete(lista_shared.count-1);

 finalize_file_library_item(ffile);

FreeMem(ffile,sizeof(record_file_library));
end;
except
end;
lista_shared.Free;


try
while (lista_push_nostri.count>0) do begin
 push_to_go := lista_push_nostri[lista_push_nostri.count-1];
 lista_push_nostri.delete(lista_push_nostri.count-1);
 push_to_go^.filename := '';
  FreeMem(push_to_go,sizeof(recorD_push_to_go));
end;
except
end;
lista_push_nostri.Free;


clear_chanlist_backup;
chat_chanlist_backup.Free;

try
while (lista_socket_accept_down.count>0) do begin
socket := lista_socket_accept_down[lista_socket_accept_down.count-1];
lista_socket_accept_down.delete(lista_socket_accept_down.count-1);
socket.Free;
end;
except
end;
lista_socket_accept_down.Free;

lista_risorse_temp.Free;


lista_risorsepartial_temp.Free;

try
while (lista_socket_temp_proxy.count>0) do begin
psocket := lista_socket_temp_proxy[lista_socket_temp_proxy.count-1];
lista_socket_temp_proxy.delete(lista_socket_temp_proxy.count-1);
 with psocket^ do begin
  buffstr := '';
  ip := '';
 end;
FreeMem(psocket,sizeof(record_socket));
end;
except
end;
lista_socket_temp_proxy.Free;



try
if vars_global.BitTorrentTempList<>nil then vars_global.BitTorrentTempList.Free;
except
end;

try
if vars_global.bittorrent_Accepted_sockets<>nil then begin
 while (vars_global.bittorrent_Accepted_sockets.count>0) do begin
  socket := vars_global.bittorrent_Accepted_sockets[vars_global.bittorrent_Accepted_sockets.count-1];
          vars_global.bittorrent_Accepted_sockets.delete(vars_global.bittorrent_Accepted_sockets.count-1);
  socket.Free;
 end;
 vars_global.bittorrent_Accepted_sockets.Free;
end;
except
end;


try
mysupernodes.mysupernodes_free;
except
end;
end;



procedure Tares_frmmain.FormShow(Sender: TObject);
begin
 initialized := True;
end;

procedure Tares_frmmain.RadiosearchmimeClick(Sender: TObject);
begin
mainGui_invalidate_searchpanel;
if radio_srcmime_all.checked then
 if combo_search.canfocus then combo_search.setfocus;
end;

procedure Tares_frmmain.FormResize(Sender: TObject);
var
 borderWi,borderHe: Integer;
begin
if helper_skin.skinnedFrameLoaded then begin

 borderwi := GetSystemMetrics(SM_CXSIZEFRAME);
 borderhe := GetSystemMetrics(SM_CYSIZEFRAME);

 clientPanel.left := helper_skin.fborderWidth;
 clientPanel.top := helper_skin.fcaptionHeight;
 clientPanel.width := clientwidth-(helper_skin.fborderwidth*2);
 clientPanel.height := ((clientheight-helper_skin.fcaptionHeight)-helper_skin.fborderHeight);

 FrameRgn := CreateRoundRectRgn(BorderWi-1,BorderHe-1, (width-BorderWi)+2, (height-BorderHe)+2,helper_skin.FrameRoundCorner,helper_skin.FrameRoundCorner); //<shape type="roundRect" rect="0,0,-1,-1" size="4,4"/>
 SetWindowRgn(Handle, FrameRgn, true);

 invalidate;
end else begin
 clientPanel.top := 0;
 clientPanel.left := 0;
 clientPanel.width := clientwidth;
 clientPanel.height := clientheight;
end;

end;

procedure tares_frmmain.webOnResize(Sender: TObject);
begin
//
end;

procedure tares_Frmmain.libraryOnResize(Sender: TObject);
var
 nodo:PCmtVNode;
begin
treeview_lib_regfolders.left := 0;
treeview_lib_virfolders.left := 0;
treeview_lib_regfolders.top := btns_library.height;
treeview_lib_virfolders.top := btns_library.height;
treeview_lib_regfolders.height := (sender as tpanel).clientheight-btns_library.height;
treeview_lib_virfolders.height := (sender as tpanel).clientheight-btns_library.height;
treeview_lib_regfolders.Header.Columns[0].width := treeview_lib_regfolders.width;
treeview_lib_virfolders.Header.Columns[0].width := treeview_lib_virfolders.width;

//if panel_lib_folders.width>152 then btn_lib_hidefolders.left := panel_lib_folders.width-btn_lib_hidefolders.width-2
// else btn_lib_hidefolders.left := 132;

 
 splitter_library.top := btns_library.height;
 panel_hash.Top := btns_library.height;
 listview_lib.top := btns_library.height;
 splitter_library.componentTop := (sender as tpanel).top+(integer(helper_skin.SkinnedFrameLoaded)*helper_skin.fcaptionHeight);

   if hashing then begin
    with splitter_library do begin
     visible := True;
     top := btns_library.top+btns_library.height;
     height := (sender as tpanel).clientheight-top;
    end;
     treeview_lib_virfolders.visible := btn_lib_virtual_view.down;
     treeview_lib_regfolders.visible := btn_lib_regular_view.down;
         if btn_lib_virtual_view.down then begin
         nodo := treeview_lib_virfolders.getfirst;
          if nodo<>nil then begin
            if treeview_lib_virfolders.selected[nodo] then begin
              panel_hash.visible := True;
              listview_lib.visible := False;
            end else begin
              listview_lib.visible := True;
              panel_hash.visible := False;
            end;
         end;
        end else begin
        nodo := treeview_lib_regfolders.getfirst;
          if nodo<>nil then begin
            if treeview_lib_regfolders.selected[nodo] then begin
              panel_hash.visible := True;
              listview_lib.visible := False;
             end else begin
              listview_lib.visible := True;
              panel_hash.visible := False;
             end;
          end;
        end;
   end else begin
    with splitter_library do begin
     visible := True;
     top := btns_library.top+btns_library.height;
     height := (sender as tpanel).clientheight-top;
    end;
     treeview_lib_virfolders.visible := btn_lib_virtual_view.down;
     treeview_lib_regfolders.visible := btn_lib_regular_view.down;
      listview_lib.visible := True;
      panel_hash.visible := False;
   end;

  if btn_lib_toggle_folders.down then begin
    treeview_lib_virfolders.width := vars_global.panel6sizedefault;
    treeview_lib_regfolders.width := vars_global.panel6sizedefault;
    splitter_library.left := vars_global.panel6sizedefault;
    splitter_library.width := 3;
    listview_lib.left := splitter_library.left+splitter_library.width{+1};
    panel_hash.left := listview_lib.left;
    panel_details_library.left := listview_lib.left;
    listview_lib.width := (sender as tpanel).clientwidth-listview_lib.left;
    panel_hash.width := listview_lib.width+2;
    panel_details_library.width := listview_lib.width;
 end else begin
    treeview_lib_virfolders.width := 0;
    treeview_lib_regfolders.width := 0;
    splitter_library.left := 0;
    splitter_library.width := 0;
    listview_lib.left := 0;
    panel_hash.left := 0;
    panel_details_library.left := 0;
    listview_lib.width := (sender as tpanel).clientwidth;
    panel_hash.width := listview_lib.width+2;
    panel_details_library.width := listview_lib.width;
 end;

 if ((not btn_lib_toggle_details.down) or
     (listview_lib.header.height=34) or
     (hashing)) then begin
  listview_lib.height := (sender as tpanel).clientHeight-listview_lib.top;
  listview_lib.BevelEdges := [];
  panel_hash.height := listview_lib.height+1;
  panel_details_library.visible := False;
  panel_details_library.height := 0;
 end else begin
  listview_lib.height := ((sender as tpanel).clientHeight-listview_lib.top)-129; //165;
  listview_lib.BevelEdges := [beBottom];
  panel_hash.height := listview_lib.height+1;
  with panel_details_library do begin
   visible := True;
   left := listview_lib.left;
   top := listview_lib.top+listview_lib.Height;
   width := listview_lib.width;
   height := 129; //164;
  end;
end;

end;

procedure Tares_frmmain.Edit1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if key=vk_return then
 if Btn_start_search.enabled then
  if Btn_start_search.enabled then Btn_start_searchclick(nil);
end;

procedure Tares_frmmain.FormCreate(Sender: TObject);
var
style: Integer;
begin
 helper_skin.skinnedFrameLoaded := False;
 
 application.OnException := appexcept;
 application.OnRestore := restoreapp;
 application.OnMinimize := minimizeapp;

 ShowWindow(Application.handle,SW_HIDE);

 style := GetWindowLong(Application.Handle,GWL_EXSTYLE);
 style := style and (not WS_EX_APPWINDOW) OR (WS_EX_TOOLWINDOW);
 style := style or WS_EX_ACCEPTFILES;
 SetWindowLong(Application.Handle,GWL_EXSTYLE,style);

 //style := GetWindowLong(Application.Handle,GWL_STYLE);  // vista
 //style := style and (not WS_POPUPWINDOW);
 //SetWindowLong(Application.Handle,GWL_STYLE,style);

 ShowWindow(application.handle,SW_HIDE);
 //SHowWindow(Application.Handle,SW_SHOW);


   with ttimer.create(self) do begin
    ontimer := init_gui_first;
    interval := 10;
    enabled := True;
   end;

end;

procedure Tares_frmmain.CreateParams(var Params: TCreateParams);
begin
inherited CreateParams(Params);
Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
Params.ExStyle := Params.ExStyle and not WS_EX_CONTROLPARENT;
Params.ExStyle := Params.ExStyle or WS_EX_ACCEPTFILES;

// This only works on Windows XP and above
//if CheckWin32Version(5, 1) then Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;

end;

procedure Tares_frmmain.Btn_start_searchClick(Sender: TObject);
begin
gui_start_search;
end;



procedure Tares_frmmain.btn_stop_searchClick(Sender: TObject);
begin
gui_stop_search;
end;

procedure Tares_frmmain.Download1Click(Sender: TObject);
var
node,node_child,selected_node:PCmtVNode;
datao,data_child:precord_search_result;
down: Tdownload;
hi: Integer;
src:precord_panel_search;
begin

try

for hi := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[hi];
 if src^.containerPanel<>pagesrc.activepanel then continue;

with src^.listview do begin

node := GetFirstSelected;
while (node<>nil) do begin


 if getnodelevel(node)>0 then selected_node := node.parent
  else selected_node := node;

 datao := getdata(selected_node);

 if datao^.downloaded then begin
  node := getnextselected(node);
  continue;
 end;

 if datao^.isTorrent then begin
  if is_torrent_in_progress(datao^.hash_sha1) then begin
    messageboxW(self.handle,pwidechar(GetLangStringW(STR_TRANSFER_ALREADY_IN_PROGRESS)+CRLF+CRLF+'(  '+datao^.title+'  )'+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_TRANSFER_TAB)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_REQUEST)),mb_ok+MB_ICONEXCLAMATION);
    exit;
  end;
  add_magnet_link(datao^.hash_of_phash);
  datao^.downloaded := True;
  exit;
 end else begin
  if is_in_progress_sha1(datao^.hash_sha1) then begin
   messageboxW(self.handle,pwidechar(GetLangStringW(STR_TRANSFER_ALREADY_IN_PROGRESS)+CRLF+CRLF+'(  '+extract_fnameW(utf8strtowidestr(datao^.filenameS))+'  )'+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_TRANSFER_TAB)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_REQUEST)),mb_ok+MB_ICONEXCLAMATION);
   exit;
  end;

  if is_in_lib_sha1(datao^.hash_sha1) then begin
   messageboxW(self.handle,pwidechar(GetLangStringW(STR_FILE_ALREADY_IN_LIBRARY)+CRLF+CRLF+GetLangStringW(STR_FILE)+': '+extract_fnameW(utf8strtowidestr(datao^.filenameS))+CRLF+GetLangStringW(STR_SIZE)+': '+format_currency(datao^.fsize)+chr(32)+STR_BYTES+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_YOUR_LIBRARY)),pwidechar(appname+chr(58)+chr(32){': '}+GetLangStringW(STR_DUPLICATE_FILE)),mb_ok+MB_ICONEXCLAMATION);
   exit;
  end;
 end;

down := start_download(datao);
lista_down_temp.add(down);
 GUI_add_sources_ares(src^.listview,down,selected_node,datao);

 datao^.downloaded := True;
  if node.childcount>0 then begin
     node_child := getfirstchild(selected_node);
    while (node_child<>nil) do begin
      data_child := getdata(node_child);
      data_child^.downloaded := True;
       invalidatenode(node_child);
      node_child := getnextsibling(node_child);
    end;
  end;
 invalidatenode(selected_node);
 put_backup_results_inprogress(src,datao);

 node := getnextselected(node);
end;

end;

break;
end;


except
end;

end;

procedure tares_frmmain.enableSysMenus;
var
 sysMenu: THandle;
begin
if not helper_skin.SkinnedFrameLoaded then exit;
sysMenu := GetSystemMenu(self.Handle, False);
 SetMenuGrayedState(sysmenu,SC_MYRESTORE,(ares_frmmain.isMaximised) or (isIconic(ares_frmmain.handle)) or (isIconic(application.handle)));
 SetMenuGrayedState(sysmenu,SC_MYMAXIMIZE,(not ares_frmmain.isMaximised) and not ((isIconic(ares_frmmain.handle)) or (isIconic(application.handle))) );
 SetMenuGrayedState(sysmenu,SC_MYMINIMIZE,not isIconic(ares_frmmain.handle));
end;

procedure tares_frmmain.WMSyscommand(var msg: TWmSysCommand);     // WM_SYSCOMMAND
var
 shouldRevertMaximise,shouldAnimate: Boolean;
begin

case msg.CmdType of
 SC_MYMINIMIZE:msg.CmdType := SC_MINIMIZE;
 SC_MYMAXIMIZE:msg.CmdType := SC_MAXIMIZE;
 SC_MYRESTORE:msg.CmdType := SC_RESTORE;
 SC_MYCLOSE:msg.CmdType := SC_CLOSE;
end;

case (msg.CmdType and $FFF0) of

 SC_MINIMIZE,SC_MYMINIMIZE:begin
  formhint_hide;
  if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
  ShowWindow(handle,SW_MINIMIZE);
  //visible := False;
  msg.result := 0;
  enableSysMenus;
 end;

 SC_RESTORE:begin
  formhint_hide;
  if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
  //if isiconic(application.Handle) then application.restore;
  visible := True;
       shouldRevertMaximise := (not isIconic(handle));

       ShowWindow(ares_frmmain.Handle, SW_RESTORE);
         if (helper_skin.SkinnedFrameLoaded) and (isMaximised) and (shouldRevertMaximise) then begin
          isMaximised := False;

         setWindowPos(self.handle,0,
                       oldleft,oldtop,
                       oldwidth,oldheight,
                       SWP_NOZORDER);
         end else
         if (helper_skin.SkinnedFrameLoaded) and (isMaximised) then begin
          isMaximised := False;
          ufrmmain.MaximiseForm(self);
          isMaximised := True;
         end;
    if shouldRevertMaximise then isMaximised := False;
    enableSysMenus;
   msg.result := 0;

 end;

 SC_MAXIMIZE:begin
   formhint_hide;
   if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);

    if helper_skin.SkinnedFrameLoaded then begin
     if not isMaximised then begin

      oldwidth := self.width;
      oldheight := self.height;
      oldleft := self.left;
      oldtop := self.top;
      ufrmmain.MaximiseForm(self);
      isMaximised := True;

     end else begin
     // if isIconic(handle) then
      PostMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
     end;
   end else ShowWindow(Handle, SW_MAXIMIZE);
   enableSysMenus;
   msg.result := 0;
 end;

 SC_CLOSE:begin
  formhint_hide;
 if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
 //visible := False;
 msg.result := 0;
 
  if vars_global.check_opt_gen_gclose_checked then begin
   sendmessage(self.handle,WM_USER_QUIT,1,0);
   exit;
  end;

  shouldAnimate := GetAnimation;
  if shouldAnimate then begin



   DrawAppMinimizeAnimation(true);

   SetAnimation(false);

   showwindow(application.handle,SW_HIDE);
   windows.DefWindowProc(application.Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
   showWindow(application.handle,SW_HIDE);


   tray_minimize.caption := GetLangStringW(STR_SHOW_ARES);
   app_minimized := True;

   SetAnimation(true);
  end else application.Minimize;


  TrayIcon1.iconvisible := True;
  enableSysMenus;

 end;

 else inherited;
end;

end;

procedure Tares_frmmain.tray_quitClick(Sender: TObject);
begin
postmessage(self.handle,wm_user_quit,1,0);
end;

procedure Tares_frmmain.flatedit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if key=vk_return then
 Btn_start_searchclick(nil);
end;

procedure Tares_frmmain.listview_srcGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data:precord_search_result;
begin
imageindex := -1;
if sender.getnodelevel(node)>0 then exit;

      Data := sender.getdata(node);
        if data^.downloaded then ImageIndex :=  data^.imageindex+12
         else ImageIndex := data^.imageindex;

end;

procedure Tares_frmmain.listview_srcGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
Size := SizeOf(record_search_result);
end;

procedure Tares_frmmain.listview_srcGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data:precord_search_result;
  tipo_colonna: Tcolumn_type;
  rec_res:precord_panel_search;
begin

if column<0 then exit;

 rec_res := precord_panel_search(sender.tag);
 tipo_colonna := rec_res^.stato_header[column];

Data := sender.getdata(Node);

with data^ do begin

case tipo_colonna of
 COLUMN_TITLE:CellText := utf8strtowidestr(title);
 COLUMN_STATUS:celltext := chr(32);
 COLUMN_USER:begin
              if node.ChildCount>1 then celltext := inttostr(node.childcount)+chr(32)+GetLangStringW(STR_USERS)
               else begin
                //if isTorrent then cellText := '' else
                celltext := utf8strtowidestr(nickname);
               end;
             end;
 COLUMN_TYPE:if sender.getnodelevel(node)=0 then begin
   if isTorrent then CellText := 'Torrent' else CellText := utf8strtowidestr(mediatype_to_str(amime));
 end else celltext := chr(32);
 COLUMN_FILETYPE:begin
                  CellText := lowercase(extractfileext(filenameS));
                 end;
 COLUMN_SIZE:begin
               if sender.getnodelevel(node)=0 then begin
                if fsize<4096 then CellText := format_currency(fsize)+chr(32)+STR_BYTES else
                CellText := format_currency(fsize div 1024)+chr(32)+STR_KB;
               end else celltext := chr(32);
             end;
 COLUMN_FILENAME:CellText := utf8strtowidestr(filenameS);
 COLUMN_ARTIST:CellText := utf8strtowidestr(artist);
 COLUMN_CATEGORY:CellText := utf8strtowidestr(category);
 COLUMN_ALBUM:CellText := utf8strtowidestr(album);
 COLUMN_DATE:CellText := utf8strtowidestr(year);
 COLUMN_LANGUAGE:CellText := utf8strtowidestr(language);
 COLUMN_VERSION:CellText := utf8strtowidestr(album);
 COLUMN_QUALITY:if sender.getnodelevel(node)=0 then begin
                  if param1=0 then CellText := chr(32) else begin
                   if isTorrent then cellText := chr(32)
                    else CellText := inttostr(param1);
                  end;
                end else celltext := chr(32);
 COLUMN_COLORS:begin
                 if sender.getnodelevel(node)=0 then begin
                   if param3=4 then CellText := chr(49)+chr(54){'16'} else
                    if param3=8 then CellText := chr(50)+chr(53)+chr(54){'256'} else
                     if param3=16 then CellText := chr(54)+chr(53)+chr(75){'65K'} else
                      if param3<>0 then CellText := chr(49)+chr(54)+chr(77){'16M'} else CellText := chr(32);
                 end else celltext := chr(32);
               end;
 COLUMN_LENGTH:if sender.getnodelevel(node)=0 then begin
                 if param3=0 then CellText := chr(32) else CellText := format_time(param3);
                end else celltext := chr(32);
 COLUMN_RESOLUTION:if sender.getnodelevel(node)=0 then begin
                    if (param1>0) and (param2>0) and (not isTorrent) then CellText := inttostr(param1)+chr(120){'x'}+inttostr(param2) else CellText := chr(32);
                   end else celltext := chr(32);
 COLUMN_NULL:CellText := chr(32);
 COLUMN_INPROGRESS:CellText := utf8strtowidestr(title) else CellText := chr(32);
end;

end;
end;

procedure Tares_frmmain.TreeviewHeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin
if not sender.Treeview.Selectable then exit;

 with sender do begin
  sortcolumn := column;
   if sortdirection=sdAscending then sortdirection := sdDescending
    else sortdirection := sdAscending;
  Treeview.Sort(nil,column,sender.sortdirection);
 end;
end;

procedure Tares_frmmain.listview_srcAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
var
bitmap_search_stars:graphics.TBitmap;
num: Byte;
sources: Word;
tipo_colonna: Tcolumn_type;
rec_res:precord_panel_search;
Data:precord_search_result;
begin
if column<0 then exit;

 rec_res := precord_panel_search(sender.tag);
 tipo_colonna := rec_res^.stato_header[column];

if tipo_colonna<>COLUMN_STATUS then exit;
if sender.getnodelevel(node)>0 then exit;

data := sender.getdata(Node);
if data^.isTorrent then num := torrentSeedtoLeechRatioToNumStars(data^.param1,data^.param2) else begin
 sources := node.childcount;
 if sources=0 then inc(sources);
 num := availibility_to_point(sources);
end;



bitmap_search_stars := graphics.TBitmap.create;
with bitmap_search_stars do begin
 pixelformat := pf24bit;
if (node=sender.HotNode) and (not (vsSelected in node.states)) then Canvas.Brush.color := (sender as tcomettree).Colors.HotColor else
 if (vsSelected in node.States) then Canvas.brush.color := clhighlight else
  if (node.Index mod 2)=0 then Canvas.brush.color := sender.BGColor else
  canvas.brush.color := (sender as tcomettree).color;

 canvas.fillrect(rect(0,0,width,height));

 imglist_stars.GetBitmap(num-1,bitmap_search_stars);

 width := 12*num;
 transparentcolor := clfuchsia;
 transparent := True;
 TargetCanvas.draw(cellrect.Left+3,cellrect.Top+2,bitmap_search_stars);
 free;
end;

end;

procedure Tares_frmmain.listview_srcDblClick(Sender: TObject);
var
punto: TPoint;
nodo:PCmtVNode;
data:precord_search_result;
begin
if (sender as tcomettree).GetFirstSelected=nil then exit;
getcursorpos(punto);
//if punto.x<left+pageweb.left+23 then exit;

nodo := (sender as tcomettree).getfirstselected;
if nodo=nil then exit;
if (sender as tcomettree).getnodelevel(nodo)>0 then nodo := nodo.parent;

data := (sender as tcomettree).getdata(nodo);
if data^.already_in_lib then Play3Click(nil) else
download1click(nil);
end;

procedure Tares_frmmain.Folders1Click(Sender: TObject);
begin
btn_lib_toggle_folders.down := not btn_lib_toggle_folders.down;
btn_lib_virtual_view.visible := btn_lib_toggle_folders.down;
btn_lib_regular_view.visible := btn_lib_toggle_folders.down;

if btn_lib_virtual_view.visible then begin
 btn_lib_virtual_view.left := btn_lib_toggle_folders.left+btn_lib_toggle_folders.width+3;
 btn_lib_regular_view.left := btn_lib_virtual_view.left+btn_lib_virtual_view.width+3;
  edit_lib_search.left := btn_lib_regular_view.left+btn_lib_regular_view.width+10;

// lbl_lib_search.left := btn_lib_regular_view.left+btn_lib_regular_view.width+15;
end else edit_lib_search.left := btn_lib_toggle_folders.left+btn_lib_toggle_folders.width+10;
 //else lbl_lib_search.left := btn_lib_toggle_folders.left+btn_lib_toggle_folders.width+15;

 btn_lib_toggle_details.left := edit_lib_search.left+edit_lib_search.width+10;
 btn_lib_delete.left := btn_lib_toggle_details.left+btn_lib_toggle_details.width+7;
 btn_lib_addtoplaylist.left := btn_lib_delete.left+btn_lib_delete.width;
 btn_lib_refresh.left := btn_lib_addtoplaylist.left+btn_lib_addtoplaylist.width;

libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.Moreinfo1Click(Sender: TObject);
var
nodo:PCmtVNode;
begin
btn_lib_toggle_details.down := not btn_lib_toggle_details.down;
set_reginteger('Libray.ShowDetails',integer(btn_lib_toggle_details.down));

try
 if ((listview_lib.rootnodecount>0) and
     (btn_lib_toggle_Details.down)) then begin
       nodo := listview_lib.getfirstselected;
       if nodo=nil then nodo := listview_lib.getfirst;
       listview_lib.selected[nodo] := True;
       listview_libclick(nil);
 end;
except
end;

libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.listview_libGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
  Size := SizeOf(record_file_library);
end;

procedure Tares_frmmain.listview_libGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data: precord_file_library;
begin

       Data := sender.getdata(node);
       if data^.shared then imageindex := data^.imageindex+6
        else ImageIndex :=  data^.imageindex;

end;

procedure Tares_frmmain.ExportHashLink1Click(Sender: TObject);
var
nodo:PCmtVNode;
data:precord_file_library;
begin

nodo := listview_lib.GetFirstSelected;
if nodo=nil then exit;
data := listview_lib.getdata(nodo);

export_hashlink(data,true);
end;


procedure Tares_frmmain.listview_libGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_file_library;
  tipo_colonna: Tcolumn_type;
begin
if column<0 then exit;
if column>9 then begin
 celltext := chr(32);
 exit;
end;

tipo_colonna := stato_header_library[column];

  Data := sender.getdata(Node);

  with data^ do begin

case tipo_colonna of
 COLUMN_TITLE:CellText := utf8strtowidestr(title);
 COLUMN_ARTIST:if imageindex<>0 then CellText := utf8strtowidestr(artist) else celltext := chr(32);
 COLUMN_CATEGORY:if imageindex<>0 then CellText := utf8strtowidestr(category) else celltext := chr(32);
 COLUMN_ALBUM:CellText := utf8strtowidestr(album);
 COLUMN_SIZE:begin
              if imageindex=0 then celltext := chr(32) else begin
               if fsize<4096 then CellText := format_currency(fsize)+chr(32)+STR_BYTES else
                CellText := format_currency(fsize div 1024)+chr(32)+STR_KB;
               end;
             end;
 COLUMN_DATE:CellText := utf8strtowidestr(year);
 COLUMN_LANGUAGE:CellText := utf8strtowidestr(language);
 COLUMN_VERSION:CellText := utf8strtowidestr(album);
 COLUMN_QUALITY:if param1<>0 then CellText := inttostr(param1) else CellText := chr(32);
 COLUMN_FILETYPE:begin
                  CellText := lowercase(extractfileext(path));
                 end;
 COLUMN_COLORS:begin
                if param3=4 then CellText := chr(49)+chr(54){'16'} else
                if param3=8 then CellText := chr(50)+chr(53)+chr(54){'256'} else
                if param3=16 then CellText := chr(54)+chr(53)+chr(75){'65K'} else
                if param3<>0 then CellText := chr(50)+chr(52)+chr(77){'24M'} else CellText := chr(32);
               end;
 COLUMN_LENGTH:if param3=0 then CellText := chr(32) else CellText := format_time(param3);
 COLUMN_RESOLUTION:if param1=0 then CellText := chr(32) else CellText := inttostr(param1)+chr(120){'x'}+inttostr(param2);
 COLUMN_FILENAME:CellText := extract_fnameW(utf8strtowidestr(path));
 COLUMN_NULL:CellText := chr(32);
 COLUMN_YOUR_LIBRARY:CellText := utf8strtowidestr(title);
 COLUMN_MEDIATYPE:CellText := utf8strtowidestr(mediatype);
 COLUMN_FORMAT:CellText := utf8strtowidestr(vidinfo);
 COLUMN_FILEDATE:CellText := formatdatetime('mm/dd/yyyy  h:nn AM/PM',filedate) else CellText := chr(32);
end;

end;
end;


procedure Tares_frmmain.deleteClick(Sender: TObject);
var
node:PCmtVNode;
datao:precord_file_library;
nomefilew: WideString;
stringa,stringai: WideString;
list: Tlist;
begin
 try
stringa := '';

node := listview_lib.GetFirstSelected;
if node=nil then exit;

list := tlist.create;
repeat
if node=nil then break;
 list.add(node);
  datao := listview_lib.getdata(node);
  if datao^.previewing then begin
   node := listview_lib.getnextselected(node);
   continue;
  end;
  stringa := stringa+CRLF+extract_fnameW(utf8strtowidestr(datao^.path));
 node := listview_lib.getnextselected(node);
 if list.count>30 then break;
until (not true);

if list.count=0 then begin
 list.Free;
 exit;
end;

if list.count=1 then stringai := GetLangStringW(STR_DELETE_FILE)+CRLF else stringai := GetLangStringW(STR_DELETE_FILES)+CRLF;


if messageboxW(self.handle,pwidechar(stringai+stringa+'?'{+CRLF+CRLF+GetLangStringW(STR_THERES_NO_UNDO)}),pwidechar(appname+': '+GetLangStringW(STR_WARNING_HD_ERASE)),MB_YESNO+MB_ICONWARNING)=ID_NO then begin
 list.Free;
 exit;
end;



while (list.count>0) do begin

 node := list[0];
  list.delete(0);
 datao := listview_lib.getdata(node);

   nomefileW := utf8strtowidestr(datao^.path);
   if helper_diskio.fileexistsW(nomefileW) then begin

    if lowercase(widestrtoutf8str(nomefileW))=lowercase(widestrtoutf8str(player_actualfile)) then stopmedia(nil);

    //helper_diskio.deletefileW(nomefileW);
    helper_diskio.MoveToRecycle(nomefileW);

    delete_file_da_tree_normal(datao^.folder_id,datao^.shared);
    mainGui_deletesharefile(datao^.path);
    mainGui_erase_shared_entry(datao^.crcsha1,datao^.hash_sha1);

    listview_lib.DeleteNode(node);
   end else begin

   end;

end;
list.Free;

except
end;
 details_library_hideall;
 details_library_toggle(false);

end;

procedure tares_frmmain.shared_unshare_treeview_normal(folder_id: Word; shared:boolean);
var
nodo:PCmtVNode;
cartella:precord_cartella_share;
begin

nodo := treeview_lib_regfolders.getfirst;
if nodo=nil then exit;

repeat
nodo := treeview_lib_regfolders.getnext(nodo);
if nodo=nil then exit;
   cartella := treeview_lib_regfolders.getdata(nodo);
    if cartella^.id<>folder_id then continue;

       if shared then inc(cartella^.items_shared) else begin
         if cartella^.items_shared>0 then dec(cartella^.items_shared);
       end;
       treeview_lib_regfolders.invalidatenode(nodo);
   exit;
until (not true);

end;


procedure tares_frmmain.delete_file_da_tree_normal(folder_id: Word; was_shared:boolean);
var
nodo,nodo_parent,nodo_next:PCmtVNode;
cartella,cartella_parent:precord_cartella_share;
begin
nodo := treeview_lib_regfolders.getfirst;
if nodo=nil then exit;


repeat
nodo := treeview_lib_regfolders.getnext(nodo);
if nodo=nil then exit;
   cartella := treeview_lib_regfolders.getdata(nodo);
    if cartella^.id<>folder_id then continue;

      if was_shared then
       if cartella^.items_shared>0 then dec(cartella^.items_shared);

     if cartella^.items>0 then dec(cartella^.items);

     if cartella^.items=0 then begin
         if nodo.childcount>0 then exit;

         nodo_parent := nodo.parent;
         treeview_lib_regfolders.deletenode(nodo,true);

         while true do begin
             if nodo_parent=nil then exit;
              if nodo_parent.childcount>0 then exit;
               if treeview_lib_regfolders.getnodelevel(nodo_parent)=0 then exit;

             cartella_parent := treeview_lib_regfolders.getdata(nodo_parent);
              if cartella_parent^.items>0 then exit;


              nodo_next := nodo_parent.parent;
                treeview_lib_regfolders.deletenode(nodo_parent,true);
              nodo_parent := nodo_next;
         end;


     end else treeview_lib_regfolders.invalidatenode(nodo);

     exit;
until (not true);


end;


procedure Tares_frmmain.listview_libClick(Sender: TObject);
var
data:precord_file_library;
nodo,node:PCmtVNode;
begin
try
if share<>nil then exit;
except
end;
formhint_hide;

nodo := listview_lib.GetFirstSelected;
if nodo=nil then exit;
data := listview_lib.getdata(Nodo);

 if ((data^.hash_sha1='') and (data^.path='')) then begin

  if btn_lib_regular_view.down then begin
    node := trova_nodo_treeview2_folder(listview_lib,treeview_lib_regfolders);
    if node=nil then exit;
     treeview_lib_regfolders.Selected[node] := True;
     treeview_lib_regfolders.expanded[node] := True;
     treeview_lib_regfoldersClick(treeview_lib_regfolders);
  end else begin
    node := trova_nodo_treeview1_categoria(treeview_lib_virfolders,data^.title);
    if node=nil then exit;
     treeview_lib_virfolders.Selected[node] := True;
     treeview_lib_virfoldersClick(treeview_lib_virfolders);
  end;

 exit;
 end;


library_file_showdetails(data^.hash_sha1);
end;

procedure Tares_frmmain.Edit_titleKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.Edit_keywordsKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.Edit_category_videoClick(Sender: TObject);
begin
mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.chk_lib_filesharedMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
ShareUnsharefile1Click(nil);
end;

procedure Tares_frmmain.ShareUnsharefile1Click(Sender: TObject);
var
nodo:PCmtVNode;
pfile:precorD_file_library;
data:precord_file_library;
i: Integer;
crcsha1: Word;
begin

 nodo := listview_lib.GetFirstSelected;
while (nodo<>nil) do begin
   data := listview_lib.getdata(nodo);
   if data^.previewing then begin
    nodo := listview_lib.getnextselected(nodo);
    continue;
   end;
   crcsha1 := crcstring(data^.hash_sha1);

try
   for i := 0 to lista_shared.count-1 do begin
    pfile := lista_shared[i];
    if pfile^.crcsha1<>crcsha1 then continue;
    if pfile^.hash_sha1<>data^.hash_sha1 then continue;
    if length(pfile^.title)<2 then continue;
     if pfile^.corrupt then continue;
     
      pfile^.shared := not pfile^.shared;
      if pfile^.shared then addfile_tofresh_downloads(pfile); // send to supernodes
      data^.shared := pfile^.shared;
      pfile^.write_to_disk := True;

       shared_unshare_treeview_normal(pfile^.folder_id,pfile^.shared);

         if not pfile^.shared then begin
          if my_shared_count>0 then dec(my_shared_count);
         end else begin
          inc(my_shared_count);
         end;
         
        listview_lib.invalidatenode(nodo);

       break;
  end;
except
end;


 nodo := listview_lib.getnextselected(nodo);
end;

end;


procedure tares_frmmain.check_incoming_data;
var
 copdata: string;
 p: Pointer;
 buf: Byte;
begin


vars_global.glob_shared_mem.LockMap;

p := pointer(cardinal(vars_global.glob_shared_mem.PMapData));
copymemory(@buf,p, 1);

if buf=0 then begin
 vars_global.glob_shared_mem.unLockMap;
 exit;
end;

SetLength(copdata,512);
fillchar(copdata[1],512,0);
copymemory(@copdata[1],p, 512);

  buf := 0;
 p := pointer(cardinal(vars_global.glob_shared_mem.PMapData));
 copymemory(p, @buf, 1);

vars_global.glob_shared_mem.unLockMap;

delete(copdata,pos(chr(0),copdata),length(copdata));

  if length(copdata)>0 then begin
   if pos(const_ares.STR_ARLNK_LOWER,lowercase(copdata))=1 then helper_hashlinks.add_weblink(copy(copdata,9,length(copdata)))
    else
     if pos('magnet:?',lowercase(copdata))=1 then helper_hashlinks.add_magnet_link(copy(copdata,9,length(copdata)))
      else begin
       //if CopyDataStructure.dwData=1 then copdata := '/ADD'+copdata;
       ufrmmain.Drag_And_Drop_AddFile(utf8strtowidestr(copdata),0);
      end;
      copdata := '';
  end;

end;

procedure Tares_frmmain.Timer_secTimer(Sender: TObject);
begin

try
inc(FDecsSecond);
if FDecsSecond<10 then exit;
FDecsSecond := 0;

check_incoming_data;

 scan_in_progress_caption;

 if helper_player.m_GraphBuilder<>nil then begin
    if shoutcast.isPlayingShoutcast then begin
     if (not shoutcast.isConnectingShoutcast) and (not shoutcast.isReconnecting) then ufrmmain.ares_frmmain.trackbar_playertimer(ufrmmain.ares_frmmain.trackbar_player,0,0);
    end else helper_player.player_setTrackbar(false);
 end;



/////////////////////////////
 //transfer downloaded KB
 if ares_FrmMain.treeview_Download.visible then
 ares_frmmain.panel_tran_down.capt := ' '+GetLangStringW(STR_DOWNLOAD)+': '+
                                   format_currency((vars_global.downloadedBytes+vars_global.BitTorrentDownloadedBytes) DIV KBYTE)+STR_KB+' '+GetLangStringW(STR_RECEIVED);
 //transfer uploaded KB
 if ares_FrmMain.treeview_upload.visible then
 if not ares_FrmMain.treeview_queue.visible then
  ares_FrmMain.panel_tran_upqu.capt := ' '+GetLangStringW(STR_UPLOAD)+': '+
                         format_currency((vars_global.bytes_sent+vars_global.BitTorrentUploadedBytes) DIV KBYTE)+STR_KB+' '+
                         GetLangStringW(STR_SENT);
////////////////
 if vars_global.check_opt_gen_capt_checked then mainGUI_refresh_caption(false);


if formhint.top<>10000 then check_bounds_hint;

if num_seconds=60 then begin

  vars_global.InternetConnectionOK := utility_ares.isInternetConnectionOk;

 if should_show_prompt_nick then choose_nickname_prompt;

 num_seconds := 0;
 is_idle_cursor(true);


 if DHT_LastPublishKeyFiles<>0 then
  if gettickcount-DHT_LastPublishKeyFiles>=DHT_REPUBLISHKEYTIMEms then dhtkeywords.DHT_RepublishKeyFiles; 

 if DHT_LastPublishHashFiles<>0 then
  if gettickcount-DHT_LastPublishHashFiles>=DHT_REPUBLISHHASHTIMEms then dhtkeywords.DHT_RepublishHashFiles;

end else inc(num_seconds);


except
end;

end;



procedure Tares_frmmain.trackbar_playerTimer(sender: TObject; CurrentPos,StopPos: Cardinal);
begin                  // 86400000
 try
   if unetPlayer.NETPlayer<>nil then exit;
   if uflvPlayer.FLVPlayer<>nil then exit;
   
   if shoutcast.isPlayingShoutcast then begin
    inc(shoutcast.CurrentPos);
    ares_frmmain.mplayerpanel1.TimeCaption := format_time(shoutcast.CurrentPos);
    exit;
   end;

   if currentPos>=stoppos then begin
     filtroGraphComplete(nil,0,nil);
     exit;
   end;


        mplayerpanel1.TimeCaption := format_time(CurrentPos  div 1000)+' / '+
                        format_time(StopPos div 1000);

 except
 end;
end;

procedure tares_frmmain.update_status_transfer;
var
 stringa_down,stringa_up,stringa_queue: WideString;
 str: WideString;
begin
try


if numero_download+numTorrentDownloads>0 then begin
   if velocita_att_download+speedTorrentDownloads>0 then str := '  ['+format_speedW(velocita_att_download+speedTorrentDownloads)+']' else str := '  [0 '+GetLangStringW(STR_KB_SEC)+']';
 if numero_download+numTorrentDownloads=1 then stringa_down := GetLangStringW(STR_DOWNLOAD)+': '+inttostr(numero_download+numTorrentDownloads)+str+CRLF
  else stringa_down := GetLangStringW(STR_DOWNLOADS)+': '+inttostr(numero_download+numTorrentDownloads)+str+CRLF;
end else stringa_down := '';


if numero_upload+numTorrentUploads>0 then begin
   if velocita_att_upload+speedTorrentUploads>0 then str := '  ['+format_speedW(velocita_att_upload+speedTorrentUploads)+']' else str := '  [0 '+GetLangStringW(STR_KB_SEC)+']';
 if numero_upload+numTorrentUploads=1 then stringa_up := GetLangStringW(STR_UPLOAD)+': '+inttostr(numero_upload+numTorrentUploads)+str+CRLF
  else stringa_up := GetLangStringW(STR_UPLOADS)+': '+inttostr(numero_upload+numTorrentUploads)+str+CRLF;
end else stringa_up := '';

if numero_queued>0 then stringa_queue := inttostr(numero_queued)+' '+GetLangStringW(STR_IN_QUEUE) else stringa_queue := '';


trayicon1.hintw := appname+' '+versioneares+CRLF+
                 stringa_down+
                 stringa_up+
                 stringa_queue;



except
end;
end;


procedure Tares_frmmain.ToolButton18Click(Sender: TObject);  //new search
begin
 pagesrc.ActivePage := 0;
end;



procedure Tares_frmmain.ToolButton19Click(Sender: TObject);
begin
Download1Click(nil);
end;

procedure Tares_frmmain.ToolButton27Click(Sender: TObject);
var
node,node2,nodetmp:PCmtVNode;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
dataNode:precord_data_node;
begin
try
node := treeview_download.GetFirstselected;
if node<>nil then begin
 if vars_global.check_opt_tran_warncanc_checked then begin
  if messageboxW(self.handle,pwidechar(GetLangStringW(STR_ARES_YOU_SURETOCANCEL)),pwidechar(appname+': '+GetLangStringW(STR_CANCEL_DL)),mb_yesno+mb_iconquestion)<>IDYES then exit;
 end;


with treeview_download do begin
 node := GetFirstselected;
 while (node<>nil) do begin

   if getnodelevel(node)=1 then begin
    node2 := node.parent;
    dataNode := getdata(node2);
   end else dataNode := getData(node);

   case dataNode^.m_type of

    dnt_download,
    dnt_partialDownload:begin
      DnData := dataNode^.data;
      if DnData^.handle_obj<>INVALID_HANDLE_VALUE then DnData^.want_cancelled := True;
    end;

    dnt_bittorrentMain:begin
      BtData := dataNode^.data;
      if BtData^.state=dlSeeding then begin
       node := GetNextselected(node);
       continue;
      end;
      BtData^.want_cancelled := True;
    end;

    dnt_bittorrentSource:begin
     nodetmp := node.parent;
     dataNode := getData(nodetmp);
     BtData := dataNode^.data;
      if BtData^.state=dlSeeding then begin
       node := GetNextselected(node);
       continue;
      end;
      BtData^.want_cancelled := True;
    end;

  end;

  node := GetNextselected(node);
 end;
end;

end else begin
 if btn_tran_toggle_queup.caption=GetLangStringA(STR_SHOW_QUEUE) then Cancel1Click(nil);
end;


except
end;
end;

procedure Tares_frmmain.treeview_downloadGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
Size := SizeOf(record_data_node);
end;

procedure Tares_frmmain.treeview_downloadPaintText(Sender: TBaseCometTree;const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
dataNode:precord_data_node;
begin
dataNode := sender.getdata(node);
if dataNode^.m_type<>dnt_PartialDownload then exit;
                       
TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.treeview_downloadGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  dataNode:precord_data_node;
  DnData:precord_displayed_download;
  BtData:precord_displayed_bittorrentTransfer;
  BtSrcData:btcore.precord_Displayed_source;
  DsData:precord_displayed_downloadsource;
  str1,str2: WideString;
  rem_secs: Integer;
begin
  dataNode := sender.getdata(node);
  case DataNode^.m_type of

    dnt_downloadSource:begin
      DsData := dataNode^.data;
      with DsData^ do begin
        case column of
          0:CellText := nomedisplayW;
          1:CellText := '';
          2:CellText := CHRSPACE+utf8strtowidestr(nickname);
          3:CellText := CHRSPACE+SourceStateToStrW(DsData);

          5:if ((state=srs_receiving) or (state=srs_UDPDownloading)) then CellText := format_speedW(speed)
            else CellText := '';
          6:celltext := '';
          7:if ((state=srs_receiving) or (state=srs_UDPDownloading)) then begin
              if ((progress<4096) and ((progress>0) or (size<4096))) then str1 := format_currency(progress)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency(progress div 1024)+STR_KB+chr(32);
              if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
              celltext := str1+GetLangStringW(STR_OF)+str2;
            end;
        end;
      end;
    end;

    dnt_bittorrentSource:begin
     BtSrcData := datanode^.data;
     case Column of
      0:if BtSrcDatA^.port>0 then CellText := BtSrcData^.ipS+':'+inttostr(BtSrcData^.port)
       else CellText := BtSrcData^.ipS;
      1:CellText := BtSrcData^.foundBy;
      2:CellText := BtSrcData^.client;
      3:Celltext := bitTorrentStringFunc.BTSourceStatusToStringW(BtSrcData^.status);
      4:Celltext := '';
      5:if BtSrcData^.status=btSourceConnected then
         if ((BtSrcData^.speedDown>0) or (BtSrcDatA^.speedUp>0)) then begin
            if BtSrcData^.progress=100 then CellText := format_speedW(BtSrcData^.speedDown,false) else
            CellText := format_speedW(BtSrcData^.speedDown,false)+' / '+format_speedW(BtSrcData^.speedUp,false);
          end;
      6:CellText := '';
      7:begin
         if BtSrcData^.status=btSourceConnected then begin
          if (BtSrcData^.progress=100) and (BtSrcData^.sent=0) then celltext := format_currency(BtSrcData^.recv div 1024)+STR_KB
           else celltext := format_currency(BtSrcData^.recv div 1024)+' / '+format_currency(BtSrcData^.sent div 1024)+STR_KB;
          end else
          if (BtSrcData^.sent>0) or (BtSrcData^.recv>0) then begin
            if (BtSrcData^.progress=100) and (BtSrcData^.sent=0) then celltext := format_currency(BtSrcData^.recv div 1024)+STR_KB
             else celltext := format_currency(BtSrcData^.recv div 1024)+' / '+format_currency(BtSrcData^.sent div 1024)+STR_KB;
          end else CellText := '';

        end;
     end;
    end;


    dnt_bittorrentMain:begin
      BtData := dataNode^.data;
      with BtData^ do begin
       case column of
         0:CellText := utf8strtowidestr(filename);
         1:CellText := STR_BITTORRENT;
         2:if BtData^.num_Sources=1 then CellText := '1 '+GetLangStringW(STR_USER)
          else CellText := inttostr(BtData^.num_sources)+' '+GetLangStringW(STR_USERS);
         3:if ((BtData^.ercode<>0) and (BtData^.state<>dlCancelled)) then CellText := 'Error ('+inttostr(BtData^.ercode)+')'
              else CellText := downloadStatetoStrW(BtData);
         5:if speedDl>0 then CellText := format_speedW(speedDl);
         6:begin
                 if speedDl>0 then
                  if size>downloaded then begin
                   rem_secs := (size-downloaded) div speedDl;
                   CellText := format_time(rem_secs);
                  end;
           end;
         7:begin
            if ((downloaded<4096) and ((downloaded>0) or (size<4096))) then str1 := format_currency(downloaded)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency(downloaded div 1024)+STR_KB+chr(32);
             if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
              celltext := str1+GetLangStringW(STR_OF)+str2;
          end;
       end;
      end;
    end;

    dnt_download:begin
      DnData := dataNode^.data;
      with DnData^ do begin
         case column of
          0:CellText := nomedisplayw;
          1:if node.parent=sender.rootnode then CellText := mediatype_to_widestr(tipo) else celltext := chr(32);
          2:if DnData^.state=dlDownloading then begin
             if DnData^.numInDown>1 then CellText := inttostr(DnData^.numInDown)+' '+GetLangStringW(STR_USERS)
              else
               if DnData^.numInDown=1 then CellText := '1 '+GetLangStringW(STR_USER);
            end else begin
             if node.childcount>1 then CellText := inttostr(node.childcount)+' '+GetLangStringW(STR_USERS)
              else
               if node.childcount=1 then CellText := '1 '+GetLangStringW(STR_USER)
                else
                 CellText := '';
            end;
          3:if node.parent<>sender.rootnode then CellText := ' '+downloadStatetoStrW(DnData)
          else CellText := downloadStatetoStrW(DnData);
          7:begin
            if size=0 then begin
             celltext := chr(32);
             exit; //MAGNET!
            end;
            if node.parent=sender.rootnode then begin
             if ((progress<4096) and ((progress>0) or (size<4096))) then str1 := format_currency(progress)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency(progress div 1024)+STR_KB+chr(32);
             if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
              celltext := str1+GetLangStringW(STR_OF)+str2;
            end else begin
            if ((state=dlDownloading) or (state=dlUploading)) then begin
             if ((progress<4096) and ((progress>0) or (size<4096))) then str1 := format_currency(progress)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency(progress div 1024)+STR_KB+chr(32);
              if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
            celltext := str1+GetLangStringW(STR_OF)+str2;
            end else celltext := chr(32);
            end;
         end;
         5:begin
          if ((state=dlDownloading) or ((state=dlUploading) and (node.parent<>sender.rootnode))) then begin
            if size>progress then CellText := format_speedW(velocita) else CellText := chr(32);
          end else celltext := chr(32);
         end;
         6:begin
          if state=dlDownloading then
            if node.parent=sender.rootnode then begin
              if size>progress then begin
                if velocita>0 then begin
                 rem_secs := (size-progress) div velocita;
                 CellText := format_time(rem_secs);
                end else CellText := chr(32);
              end else CellText := chr(32);
            end else CellText := chr(32);
          end else CellText := chr(32);
         end;
       end;

    end;


  end;

end;


procedure Tares_frmmain.treeview_downloadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.precord_Displayed_source;
DsData:precord_displayed_downloadsource;
//len1,len2: Integer;
begin
imageindex := -1;
 //len1 := length(GetLangStringA(STR_QUEUED_STATUS));
 //len2 := length(GetLangStringA(STR_BUSY));

      dataNode := sender.getdata(node);
      case dataNode^.m_type of

      dnt_downloadSource:begin
       DsData := dataNode^.data;
        case DsData^.state of
          srs_receiving,srs_udpDownloading:ImageIndex := 1;
          srs_connecting,
          srs_readytorequest,
          srs_connected,
          srs_ReceivingReply:ImageIndex := 7
           else ImageIndex := 8
        end;
      end;

         dnt_BittorrentSource:begin
           BtSrcData := dataNode^.data;
           case BtSrcData^.status of
            btSourceIdle:ImageIndex := 8;
            btSourceConnected:if BtSrcData^.isOptimistic then ImageIndex := 9
                               else ImageIndex := 1;
             else ImageIndex := 7;
           end;
         end;

         dnt_bittorrentMain:begin
          BtData := dataNode^.data;
             with BtData^ do begin
                case state of
                 dlDownloading,
                 dlUploading:ImageIndex := 1;
                 dlSeeding:ImageIndex := 2;
                 dlCancelled:ImageIndex := 3;
                 dlPaused,
                 dlLeechPaused,
                 dlLocalPaused:ImageIndex := 6;
                  else begin
                    if num_sources=0 then ImageIndex := 0  //searching
                      else ImageIndex := 7; //connecting
                  end;
                end;
             end;
         end;



         dnt_download:begin
            DnData := dataNode^.data;
            with DnData^ do begin

              if sender.getnodelevel(node)=1 then begin

               case state of
                 dlDownloading,
                 dlUploading:ImageIndex := 1;
                 dlQueuedSource:ImageIndex := 8
                   else ImageIndex := 7;
               end;

              end else begin

                case state of
                 dlDownloading,
                 dlUploading:ImageIndex := 1;
                 dlCompleted:ImageIndex := 2;
                 dlCancelled:ImageIndex := 3;
                 dlPaused,
                 dlLeechPaused,
                 dlLocalPaused:ImageIndex := 6;
                  else begin
                    if num_sources=0 then ImageIndex := 0  //searching
                      else ImageIndex := 7; //connecting
                  end;
                end;

             end;
          end;
      end;

      dnt_partialdownload:ImageIndex := 9;
   end;
end;

procedure Tares_frmmain.treeview_downloadAfterCellPaint(Sender: TBaseCometTree;TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;CellRect: TRect);
var
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.Precord_displayed_source;
DsData:precord_displayed_downloadsource;
begin
if column<>4 then exit;

dataNode := sender.getdata(node);
case dataNode^.m_type of

  dnt_bittorrentSource:begin
   BtSrcData := dataNode^.data;
   if BtSrcData^.visualBitfield=nil then exit;
   if length(BtSrcData^.visualBitfield.bits)=0 then exit;
   //if BtSrcData^.progress=0 then exit;
   if BtSrcData^.progress<100 then
    draw_progressbarBitTorrent(sender as TCometTree,node,
                               targetCanvas,
                               CellRect,
                               COLOR_DL_COMPLETED,
                               BtSrcData)
                else
    draw_progressbarDownload(sender as tcomettree,node,
                                       targetCanvas,
                                       CellRect,
                                       10000,
                                       10000,
                                       COLOR_DL_COMPLETED);
  end;

  dnt_bittorrentMain:begin
   BtData := dataNode^.data;
    if BtData^.state=dlCancelled then exit;
     if BtData^.state<>dlSeeding then draw_progressbarBitTorrent(sender as tcomettree,node,
                                                            targetCanvas,
                                                            CellRect,
                                                            COLOR_DL_COMPLETED,
                                                            BtData)
     else draw_progressbarDownload(sender as tcomettree,node,
                                       targetCanvas,
                                       CellRect,
                                       10000,
                                       10000,
                                       COLOR_DL_COMPLETED);
  end;

  dnt_download:begin
    DnData := dataNode^.data;
    if DnData^.state=dlCancelled then exit;
     if DnData^.state<>dlCompleted then draw_progressbarDownload(sender as tcomettree,node,
                                                                 targetCanvas,
                                                                 CellRect,
                                                                 DnData^.progress,
                                                                 DnData^.size,
                                                                 COLOR_PROGRESS_DOWN)
      else draw_progressbarDownload(sender as tcomettree,node,
                                    targetCanvas,
                                    CellRect,
                                    10000,
                                    10000,
                                    COLOR_DL_COMPLETED);
  end;

  dnt_downloadSource:begin
   DsData := dataNode^.data;
   if ((DsData^.state<>srs_receiving) and (DsData^.state<>srs_UDPDownloading)) then exit;
   draw_progressbarDownload(sender as tcomettree,
                            node,
                            targetCanvas,
                            CellRect,
                            DsData^.progress,
                            DsData^.size,
                            COLORE_DLSOURCE);
  end;

end;
end;





procedure Tares_frmmain.ToolButton21Click(Sender: TObject);
begin
ClearIdle2Click(nil);
ClearIdle1Click(nil);
end;

procedure tares_frmmain.thread_share_end(var msg: Tmessage);
var
node:PCmtVNode;
paused: Boolean;
begin
if share=nil then exit;

try
share.waitfor;
share.Free;
except
end;
share := nil;

 lbl_hash_hint.visible := False;
 lbl_hash_pri.visible := False;
  hash_pri_trx.visible := False;
  progbar_hash_file.visible := False;
  lbl_hash_progress.visible := False;
  lbl_hash_folder.visible := False;
  lbl_hash_file.visible := False;

if vars_global.closing then begin
 sleep(5000);
 global_shutdown(true);
 exit;
end;


try
if btn_lib_virtual_view.down then begin
  node := treeview_lib_virfolders.GetFirst;
  if node=nil then exit;
  hashing := False;
  treeview_lib_virfolders.selected[node] := True;
  treeview_lib_virfoldersClick(treeview_lib_virfolders);
end else begin
  node := treeview_lib_regfolders.GetFirst;
  if node=nil then exit;
  hashing := False;
  treeview_lib_regfolders.selected[node] := True;
  treeview_lib_regfoldersClick(treeview_lib_regfolders);
end;

 listview_lib.color := COLORE_LISTVIEWS_BG;
 listview_lib.bringtofront;
 listview_lib.color := COLORE_LISTVIEWS_BG;
except
end;


if not need_rescan then exit;
try
need_rescan := False;

paused := set_NEWtrusted_metas;

vars_global.scan_start_time := gettickcount;

 share := tthread_share.create(true);
  share.paused := paused;
  share.juststarted := False;
  share.Resume;
except
end;
end;

procedure Tares_frmmain.OpenPreview1Click(Sender: TObject);
var
 node:PCmtVNode;
 dataNode:precord_data_node;
 DnData:precord_displayed_download;
 BtData:precord_displayed_bittorrentTransfer;
begin
try

node := treeview_download.getfirstselected;
if node<>nil then begin

  if treeview_download.getnodelevel(node)=1 then node := node.Parent;
  dataNode := treeview_download.getdata(node);

   case dataNode^.m_type of
     dnt_bittorrentMain:begin
      BtData := dataNode^.data;

      if isFolder(BtData^.path) then open_file_external(BtData^.path)
       else begin
        if BtData^.state<>dlSeeding then Preview_copyAndOpen(BtData)
         else player_playnew(utf8strtowidestr(BtData^.path));
       end;
    end;
    
    dnt_download,
    dnt_partialDownload:begin
     DnData := dataNode^.data;
      if DnData^.state<>dlCompleted then Preview_copyAndOpen(DnData)
       else player_playnew(utf8strtowidestr(DnData^.filename));
    end;
  end;

end else
 if btn_tran_toggle_queup.caption=GetLangStringA(STR_SHOW_QUEUE) then OpenPlay2Click(nil)
  else MenuItem8Click(nil);

except
end;
end;

procedure Tares_frmmain.panel_vidResize(Sender: TObject);
begin
resize_video_window;
end;

procedure Tares_frmmain.Fullscreen2Click(Sender: TObject);
begin
if not isvideoplaying then exit;
 if helper_player.m_GraphBuilder=nil then exit;
 if helper_player.player_GetState=gsStopped then exit;
 
fullscreen2.checked := not fullscreen2.checked;

player_togglefullscreen(fullscreen2.checked);
end;

procedure Tares_frmmain.btn_player_pauseClick(Sender: TObject);
begin
if unetPlayer.NETPlayer<>nil then begin
if lowercase(copy(player_actualfile,1,4))='rtmp' then exit;
 unetPlayer.NETPlayer.SetVariable('PauseCommand','1');
 ares_frmmain.MPlayerPanel1.Playing := not ares_frmmain.MPlayerPanel1.Playing;
 exit;
end else
if uflvplayer.FLVPlayer<>nil then begin
 uflvplayer.FLVPlayer.SetVariable('PauseCommand','1');
 ares_frmmain.MPlayerPanel1.Playing := not ares_frmmain.MPlayerPanel1.Playing;
 exit;
end;

if helper_player.m_GraphBuilder=nil then exit;

if helper_player.player_GetState=gsPaused then begin
  runmedia;
  end else begin
   if ((sender=nil) and (not vars_global.check_opt_gen_pausevid_checked)) then exit;
   pausemedia;
   if sender<>nil then stopped_by_user := True;
  end;

end;

procedure Tares_frmmain.btn_player_playClick(Sender: TObject);
var
 state: TGraphState;
begin
if unetplayer.NETPlayer<>nil then begin
 unetplayer.NETPlayer.SetVariable('PauseCommand','1');
 ares_frmmain.MPlayerPanel1.Playing := not ares_frmmain.MPlayerPanel1.Playing;
 exit;
end else
if uflvplayer.FLVPlayer<>nil then begin
 uflvplayer.FLVPlayer.SetVariable('PauseCommand','1');
 ares_frmmain.MPlayerPanel1.Playing := not ares_frmmain.MPlayerPanel1.Playing;
 exit;
end;

if not helper_player.player_working then exit;

 if player_actualfile='' then begin
   playlist_playnext('');
    exit;
 end;
 state := helper_player.player_GetState;
  if ((state=gsStopped) or (state=gsUninitialized)) then begin
    player_playnew(player_actualfile,false);
  end else runmedia;
end;

procedure tares_frmmain.previewstart_event(var msg: Tmessage);
begin
player_playnew(file_visione_da_copiatore);
end;

procedure Tares_frmmain.OpenPlay1Click(Sender: TObject);
var
nodo:PCmtVNode;
data:^record_file_library;
begin
nodo := listview_lib.GetFirstSelected;
if nodo=nil then exit;
data := listview_lib.getdata(nodo);
player_playnew(utf8strtowidestr(data^.path));
end;

procedure Tares_frmmain.Locate1Click(Sender: TObject);
var
nodo:PCmtVNode;
data:^record_file_library;
begin
nodo := listview_lib.GetFirstSelected;
if nodo=nil then exit;
data := listview_lib.getdata(nodo);

locate_containing_folder(data^.path);
//Tnt_ShellExecuteW(0,'open',pwidechar(folder_id_to_folder_name(data^.folder_id,treeview_lib_regfolders)+'\'),'','',Sw_ShOwNORMAL);
end;

procedure Tares_frmmain.track_not_enabled_to_change(Sender: TObject);
begin
//
end;

procedure Tares_frmmain.btn_player_volClick(Sender: TObject);
var
punto: TPoint;
frm: Tfrmctrlvol;
begin
frm := Tfrmctrlvol.create(self);
with frm do begin
 width := 80;
 checkbox1.Width := 78-checkbox1.left;
 btn_close.left := 78-btn_close.width;
  getcursorpos(punto);
   with punto do begin
    left := x-20;
    top := (y-height);
   end;
   formstyle := fsStayOnTop;
 show;
end;

end;

procedure Tares_frmmain.Openwithexternalplayer1Click(Sender: TObject);
var
nodo:PCmtVNode;
data:precord_file_library;
begin
nodo := listview_lib.GetFirstSelected;
if nodo=nil then exit;
data := listview_lib.getdata(nodo);
 open_file_external(data^.path);
end;




procedure Tares_frmmain.ksoOfficeSpeedButton13Click(Sender: TObject);
begin
if not isvideoplaying then exit;

if fullscreen2.checked then Fullscreen2Click(nil);

fittoscreen1.checked := not fittoscreen1.checked;
originalsize1.checked := (not fittoscreen1.checked);
panel_vidresize(nil);
end;

procedure Tares_frmmain.treeview_uploadGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
Size := SizeOf(record_data_node);
end;

procedure Tares_frmmain.treeview_uploadGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  UpData:precord_displayed_upload;
  DnData:precord_displayed_download;
  BtData:precord_displayed_bittorrentTransfer;
  BtSrcData:btcore.precord_Displayed_source;
  dataNode:precord_data_node;
  str1,str2: WideString;
begin
  DataNode := sender.getdata(Node);
  case DataNode^.m_type of

    dnt_bittorrentSource:begin
     BtSrcData := datanode^.data;
     case Column of
      0:if BtSrcData^.port>0 then CellText := BtSrcData^.ips+':'+inttostr(BtSrcData^.port)
       else CellText := BtSrcData^.ips;
      1:CellText := BtSrcData^.foundBy;
      2:CellText := BtSrcData^.client;
      3:Celltext := bitTorrentStringFunc.BTSourceStatusToStringW(BtSrcData^.status);
      4:Celltext := '';
      5:if BtSrcData^.status=btSourceConnected then
         if BtSrcDatA^.speedUp>0 then
          CellText := format_speedW(BtSrcData^.speedUp);
      6:CellText := '';
      7:celltext := format_currency(BtSrcData^.recv div 1024)+' / '+format_currency(BtSrcData^.sent div 1024)+STR_KB;
     end;
    end;


    dnt_bittorrentMain:begin
      BtData := dataNode^.data;
      with BtData^ do begin
       case column of
         0:CellText := utf8strtowidestr(filename);
         1:CellText := STR_BITTORRENT;
         2:if BtData^.num_Sources=1 then CellText := '1 '+GetLangStringW(STR_USER)
          else CellText := inttostr(BtData^.num_sources)+' '+GetLangStringW(STR_USERS);
         3:if ((BtData^.ercode<>0) and (BtData^.state<>dlCancelled)) then CellText := 'Error ('+inttostr(BtData^.ercode)+')'
              else CellText := downloadStatetoStrW(BtData);
         5:if speedUl>0 then CellText := format_speedW(speedUl);
         6:CellText := '';
         7:begin
            if ((uploaded<4096) and ((uploaded>0) or (size<4096))) then str1 := format_currency(uploaded)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency(uploaded div 1024)+STR_KB+chr(32);
             if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
              celltext := str1+GetLangStringW(STR_OF)+str2;
          end;
       end;
      end;
    end;


   dnt_upload:begin
       UpData := DataNode^.data;
       with UpData^ do begin
        case column of
         0:CellText := extract_fnameW(utf8strtowidestr(nomefile));
         1:CellText := mediatype_to_widestr(extstr_to_mediatype(lowercase(extractfileext(nomefile))));
         2:CellText := utf8strtowidestr(nickname);
         3:begin
           if completed then begin
            if progress=size then CellText := GetLangStringW(STR_COMPLETED)
             else CellText := GetLangStringW(STR_CANCELLED);
           end else CellText := GetLangStringW(STR_UPLOADING);
          end;
         5:if completed then CellText := chr(32) else CellText := format_speedW(velocita);
         6:if completed then CellText := chr(32) else begin
             if velocita>0 then CellText := format_time((size-progress) div velocita)
              else CellText := chr(32);
           end;
         7:begin

             if ((progress+continued_from<4096) and ((progress+continued_from>0) or (size+continued_from<4096))) then str1 := format_currency(progress+continued_from)+chr(32)+STR_BYTES+chr(32) else str1 := format_currency((progress+continued_from) div 1024)+STR_KB+chr(32);
              if ((size+continued_from<4096) and (size+continued_from>0)) then str2 := chr(32)+format_currency(size+continued_from)+chr(32)+STR_BYTES else str2 := chr(32)+format_currency((size+continued_from) div 1024)+STR_KB;
               celltext := str1+GetLangStringW(STR_OF)+str2;

         end else CellText := chr(32);

          end;
        end;
    end;

   dnt_Partialupload:begin
     DnData := dataNode^.data;
     with DnData^ do begin
       case column of
         0:CellText := nomedisplayw;
         1:CellText := mediatype_to_widestr(tipo);
         //2:CellText := utf8strtowidestr(nickname);
         3:CellText := GetLangStringW(STR_UPLOADING);
         5:CellText := format_speedW(velocita);
         6:if velocita>0 then CellText := format_time((size-progress) div velocita) else CellText := chr(32);
         7:begin
             if ((progress<4096) and ((progress>0) or (size<4096))) then str1 := format_currency(progress)+chr(32)+STR_BYTES+chr(32)
              else str1 := format_currency(progress div 1024)+STR_KB+chr(32);
             if ((size<4096) and (size>0)) then str2 := chr(32)+format_currency(size)+chr(32)+STR_BYTES
              else str2 := chr(32)+format_currency(size div 1024)+STR_KB;
             celltext := str1+GetLangStringW(STR_OF)+str2;
         end;
       end;
     end;
   end;

  end;

end;

procedure Tares_frmmain.treeview_uploadAfterCellPaint(Sender: TBaseCometTree;TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;CellRect: TRect);
var
oldcolor,oldpencolor,colosf: Tcolor;
UpData:precord_displayed_upload;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.Precord_displayed_source;
dataNode:precord_data_node;
progress:double;
str_percent: string;
ind: Integer;
fprogress,fsize: Int64;
fcompleted: Boolean;
begin
if column<>4 then exit;

datanode := sender.getdata(node);
 case dataNode^.m_type of

  dnt_bittorrentSource:begin
   BtSrcData := dataNode^.data;
   if BtSrcData^.visualBitfield=nil then exit;
   if length(BtSrcData^.visualBitfield.bits)=0 then exit;
   //if BtSrcData^.status<>btSourceConnected then exit;
    if BtSrcData^.progress<100 then
    draw_progressbarBitTorrent(sender as TCometTree,node,
                               targetCanvas,
                               CellRect,
                               COLOR_DL_COMPLETED,
                               BtSrcData)
                else
    draw_progressbarDownload(sender as tcomettree,node,
                                       targetCanvas,
                                       CellRect,
                                       10000,
                                       10000,
                                       COLOR_DL_COMPLETED);
    exit;
  end;

  dnt_bittorrentMain:begin
   BtData := dataNode^.data;
    if BtData^.state=dlCancelled then exit;
      draw_progressbarDownload(sender as tcomettree,node,
                                       targetCanvas,
                                       CellRect,
                                       10000,
                                       10000,
                                       COLOR_DL_COMPLETED);
     exit;
  end;

   dnt_upload:begin
     Updata := dataNode^.data;
     fprogress := UpData^.progress;
     fsize := Updata^.size;
     fcompleted := UpData^.completed;
   end;
   dnt_partialUpload:begin
     DnData := dataNode^.data;
     fprogress := DnData^.progress;
     fsize := DnData^.size;
     fcompleted := False;
   end else exit;
 end;

with targetcanvas do begin
 oldcolor := brush.color;
 oldpencolor := pen.color;

 if vars_global.check_opt_tran_perc_checked then begin
  brush.style := bsclear;
   progress := fprogress;
   if progress>0 then begin
     if fsize=0 then progress := 100 else begin
       progress := progress/fsize;
       progress := progress*100;
     end;
   end else progress := 0;
     str_percent := FloatToStrF(progress, ffNumber, 18, 2);
     delete(str_percent,pos('.',str_percent),length(stR_percent));
     str_percent := str_percent+'%';
   if length(str_percent)=2 then begin //0..9%
    ind := (textwidth(chr(48){'0'}+str_percent)-textwidth(str_percent)) div 2;
    TextRect(cellrect,cellrect.left+ind,cellrect.Top+2,str_percent);
    cellrect.left := cellrect.left+(textwidth(chr(48){'0'}+str_percent)+2);
   end else begin
    TextRect(cellrect,cellrect.left,cellrect.Top+2,str_percent);
    cellrect.left := cellrect.left+(textwidth(str_percent)+2);
   end;
 end;

   if SETTING_3D_PROGBAR then begin
     if (node.Index mod 2)=0 then begin //level0 colorato
       colosf := treeview_download.BGColor;
     end else begin            //level0 non colorato
      colosf := treeview_download.Color;
     end;

    draw_3d_progressframe(targetcanvas,cellrect,colosf);
   end;


    if ((fcompleted) and
        (fprogress=fsize)) then begin
      brush.color := COLOR_UL_COMPLETED;
      pen.color := COLOR_UL_COMPLETED;
       if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
       draw_progress_tran(TargetCanvas,cellrect,0,10000,10000,false);
    end else begin

      if dataNode^.m_type=dnt_partialUpload then begin
       brush.color := COLORE_PARTIAL_UPLOAD;
       pen.color := COLORE_PARTIAL_UPLOAD;;
      end else begin
       brush.color := COLOR_PROGRESS_UP;
       pen.color := COLOR_PROGRESS_UP;
      end;
      
       if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
       draw_progress_tran(TargetCanvas,cellrect,0,fprogress,fsize,fcompleted);
    end;


Brush.Color := oldcolor;
pen.color := oldpencolor;
end;

end;


procedure Tares_frmmain.treeview_uploadGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
var
DataNode:precord_data_node;
UpData:precord_displayed_upload;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.precord_Displayed_source;
begin
      dataNode := sender.getdata(node);
      case dataNode^.m_type of

         dnt_BittorrentSource:begin
           BtSrcData := dataNode^.data;
           case BtSrcData^.status of
            btSourceIdle:ImageIndex := 8;
            btSourceConnected:if BtSrcData^.isOptimistic then ImageIndex := 9
                               else ImageIndex := 1;
             else ImageIndex := 7;
           end;
         end;

         dnt_bittorrentMain:begin
          BtData := dataNode^.data;
             with BtData^ do begin
                case state of
                 dlDownloading,
                 dlUploading:ImageIndex := 1;
                 dlSeeding:ImageIndex := 2;
                 dlCancelled:ImageIndex := 3;
                 dlPaused,
                 dlLeechPaused,
                 dlLocalPaused:ImageIndex := 6;
                  else begin
                    if num_sources=0 then ImageIndex := 0  //searching
                      else ImageIndex := 7; //connecting
                  end;
                end;
             end;
         end;

        dnt_upload:begin
         UpData := DataNode^.data;
             if ((UpData^.completed) and
                 (UpData^.size=UpData^.progress)) then ImageIndex := 2
                 else
                  if UpData^.completed then ImageIndex := 3
                   else ImageIndex := 9;
        end;
        dnt_Partialupload:ImageIndex := 9;
      end;
end;

procedure Tares_frmmain.panel_transferResize(Sender: TObject);
begin
splitter_transfer.componentTop := (sender as tpanel).top;
splitter_transfer.componentLeft := (sender as tpanel).left+(integer(helper_skin.SkinnedFrameLoaded)*helper_skin.fBorderWidth);
splitter_transfer.width := panel_tran_down.width;

 panel_tran_upqu.height := panelUploadHeight;
 //panel_tran_upqu.Top := splitter_transfer.clientheight+panelUploadHeight;

 splitter_transfer.top := panel_tran_upqu.Top-splitter_transfer.height;

//if panel_transfer.height-panelUploadHeight>20 then
 panel_tran_down.height := splitter_transfer.top;

 panel_tran_downResize(panel_tran_down);
 panel_tran_upquResize(panel_tran_upqu);
end;

procedure Tares_frmmain.resize_pannellobottom_editchat(Sender: TObject);
var
panel: Ttntpanel;
edit: Ttntedit;
i: Integer;
begin
try

panel := sender as ttntpanel;
for i := 0 to panel.ControlCount-1 do begin
  if panel.controls[i] is ttntedit then begin
   edit := panel.controls[i] as ttntedit;
   edit.width := panel.clientwidth;
   edit.top := panel.clientheight-edit.height;
  end;
end;

except
end;
end;


procedure Tares_frmmain.PauseResume1Click(Sender: TObject);
var
 node,node2:PCmtVNode;
 DnData:precord_displayed_download;
 BtData:precord_displayed_bittorrentTransfer;
 dataNode:precord_data_node;
begin
node := treeview_download.GetFirstselected;
while (node<>nil) do begin

 if treeview_download.getnodelevel(node)=1 then begin
  node2 := node.parent;
  dataNode := treeview_download.getdata(node2);
 end else dataNode := treeview_download.getdata(node);

  if dataNode^.m_type=dnt_download then begin
   DnData := dataNode^.data;
   DnData^.change_paused := True;
  end else
  if dataNode^.m_type=dnt_bittorrentMain then begin
   BtData := dataNode^.data;
   if BtData^.state<>dlCancelled then
    if btData^.state<>dlSeeding then BtData^.want_paused := True;
  end;

 node := treeview_download.GetNextselected(node);
end;

end;


procedure Tares_frmmain.split_tranCanResize(Sender: TObject; var NewSize: Integer;var Accept: Boolean);
begin
accept := ((newsize>38) and (newsize<panel_transfer.clientheight-10));
end;

procedure Tares_frmmain.Addtoplaylist1Click(Sender: TObject);
var
nodo:PCmtVNode;
data:precord_file_library;
begin
try

 nodo := listview_lib.GetFirstSelected;
repeat
if nodo=nil then break;
   data := listview_lib.getdata(nodo);

    playlist_addfile(data^.path,data^.param3,false,'');

 nodo := listview_lib.getnextselected(nodo);
until (not true);
 
except
end;
end;

procedure Tares_frmmain.Addtoplaylist2Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
begin

node := treeview_download.GetFirstselected;
while (node<>nil) do begin

 if treeview_download.getnodelevel(node)<>0 then begin
  node := treeview_download.GetNextselected(node);
  continue;
 end;

   dataNode := treeview_download.getdata(node);
   if ((dataNode^.m_type=dnt_download) or
      (dataNode^.m_type=dnt_partialDownload)) then begin
        DnData := dataNode^.data;
        playlist_addfile(DnData^.filename,DnData^.param3,false,'');
   end;


node := treeview_download.GetNextselected(node);
end;

end;


procedure Tares_frmmain.Popup_downloadPopup(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtSrcData:btcore.Precord_displayed_source;
begin
 Addtoplaylist2.visible := False;
 node := treeview_download.getfirstselected;

if node=nil then begin

    locate2.visible := False;
    n12.visible := False;
    Addtoplaylist2.visible := False;
    removesource1.visible := False;

end else begin
    locate2.visible := True;
    n12.visible := True;
    dataNode := treeview_download.getdata(node);
    case dataNode^.m_type of

      dnt_bittorrentMain,
      dnt_BitTorrentSource:begin
         if dataNode^.m_type=dnt_bittorrentSource then begin
           BtSrcData := dataNode^.data;
           removesource1.visible := (btSrcData^.status=btSourceConnected);
         end else removesource1.visible := False;
         Addtoplaylist2.visible := False;
         OpenPreview2.visible := False;
      end;

      dnt_downloadSource:begin
                         removesource1.visible := True;
                         end;

      dnt_download,
      dnt_partialDownloaD:begin
      // DnData := dataNode^.data;
      // OpenPreview2.visible := (DnData^.progress>0);
       removesource1.visible := False;
       end;

    end;

end;

//   N4.visible := ((chat2.visible) or
//                (removesource1.visible));

                
node := treeview_download.GetFirstselected;
while (node<>nil) do begin
   dataNode := treeview_download.getdata(node);
   if dataNode^.m_type<>dnt_download then begin
    node := treeview_download.GetNextselected(node);
    continue;
   end;
   DnData := dataNode^.data;
   Addtoplaylist2.visible := (DnData^.state=dlCompleted);
   break;
end;


end;

procedure Tares_frmmain.treeview_uploadDblClick(Sender: TObject);
var
node:PCmtVNode;
DataNode:precord_data_node;
UpData:precord_displayed_upload;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_upload.GetFirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);
case dataNode^.m_type of
 dnt_upload:begin
  UpData := datanode^.data;
  player_playnew(utf8strtowidestr(UpData^.nomefile));
 end;
 dnt_partialUpload:begin
  DnData := dataNode^.data;
  Preview_copyAndOpen(DnData);
 end;

 dnt_bittorrentMain:begin
   BtData := dataNode^.data;
   locate_containing_folder(BtData^.path);
 end;

 dnt_bittorrentSource:begin
  node := node.parent;
  dataNode := treeview_upload.getData(node);
  BtData := dataNode^.data;
  locate_containing_folder(BtData^.path);
 end;

end;

end;



procedure Tares_frmmain.Locate2Click(Sender: TObject);
var
 node:PCmtVNode;
 DnData:precord_displayed_download;
 BtData:precord_displayed_bittorrentTransfer;
 dataNode:precord_data_node;
begin
node := treeview_download.GetFirstselected;
if node=nil then exit;

 if treeview_download.getnodelevel(node)=1 then node := node.parent;
 dataNode := treeview_download.getdata(node);
 case dataNode^.m_type of

   dnt_bittorrentMain:begin
    BtData := dataNode^.data;
    locate_containing_folder(BtData^.path);
   end;

   dnt_bittorrentSource:begin
    node := node.parent;
    dataNode := treeview_download.getData(node);
    BtData := dataNode^.data;
    locate_containing_folder(BtData^.path);
   end;

   dnt_download,
   dnt_partialDownload:begin
     DnData := dataNode^.data;
     locate_containing_folder(DnData^.filename);
   end;
 end;
 
end;

procedure Tares_frmmain.OpenPlay2Click(Sender: TObject);
var
node:PCmtVNode;
UpData:precord_displayed_upload;
DnData:precord_displayed_download;
dataNode:precord_data_node;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_upload.getfirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);
case dataNode^.m_type of
 dnt_bittorrentMain:begin
  BtData := dataNOde^.data;
   if isFolder(BtData^.path) then open_file_external(BtData^.path)
       else player_playnew(utf8strtowidestr(BtData^.path));
 end;
 dnt_bittorrentSource:begin
  node := node.parent;
  dataNode := treeview_upload.getData(node);
  BtData := dataNOde^.data;
  if isFolder(BtData^.path) then open_file_external(BtData^.path)
    else player_playnew(utf8strtowidestr(BtData^.path));
 end;
 dnt_upload:begin
   UpData := dataNode^.data;
   player_playnew(utf8strtowidestr(UpData^.nomefile));
 end;
 dnt_partialUpload:begin
  DnData := dataNode^.data;
  Preview_copyAndOpen(DnData)
 end;
end;

end;

procedure Tares_frmmain.locateupload3Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
UpData:precord_displayed_upload;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_upload.getfirstselected;
if node=nil then exit;

datanode := treeview_upload.getdata(node);
case dataNode^.m_type of

 dnt_bittorrentMain:begin
  BtData := dataNOde^.data;
  locate_containing_folder(BtData^.path);
 end;
   dnt_bittorrentSource:begin
    node := node.parent;
    dataNode := treeview_upload.getData(node);
    BtData := dataNode^.data;
    locate_containing_folder(BtData^.path);
   end;

 dnt_upload:begin
   UpData := dataNode^.data;
   locate_containing_folder(UpData^.nomefile);
 end;
 dnt_partialupload:begin
   DnData := dataNode^.data;
   locate_containing_folder(DnData^.filename);
 end;
end;

end;

procedure Tares_frmmain.listview_srcMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
data:precord_search_result;
punto: TPoint;
begin

if not (sender as tcomettree).selectable then exit;
if button<>mbright then exit;

nodo := (sender as tcomettree).getfirstselected;
if nodo=nil then exit;
if (sender as tcomettree).GetNodeLevel(nodo)>0 then nodo := nodo.parent;

data := (sender as tcomettree).getdata(nodo);

if data^.already_in_lib then begin
   Download1.visible := False;
   Play3.visible := True;
end else begin
   Download1.visible := True;
   Play3.visible := False;
end;


      Artist2.visible := ((length(data^.artist)>0) and (data^.amime=ARES_MIME_MP3));
      Genre2.visible := ((length(data^.category)>0) and (data^.amime=ARES_MIME_MP3));
      Findmorefromthesame1.visible := ((Artist2.visible) or (Genre2.visible));

getcursorpos(punto);
popup_search.popup(punto.x,punto.y);
end;





procedure Tares_frmmain.Cancel1Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
BtData:precord_displayed_bittorrentTransfer;
//BtSrcData:btcore.precord_Displayed_source;
begin
node := treeview_upload.getfirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);
if dataNode^.m_type=dnt_upload then begin
 UpData := dataNode^.data;
 UpData^.should_stop := True;
end else
 if dataNode^.m_type=dnt_bittorrentMain then begin
  BtData := dataNode^.data;
  BtData^.want_cancelled := True;
 end else
  if dataNode^.m_type=dnt_bitTorrentSource then begin
    dataNode := treeview_upload.getdata(node.parent);
    BtData := dataNode^.data;
    BtData^.want_cancelled := True;
  end;
end;

procedure Tares_frmmain.treeview_uploadMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
punto: TPoint;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
//DnData:precord_displayed_download;
BtSrcData:btcore.Precord_displayed_source;
node:PCmtVNode;
begin
formhint_hide;

if button<>mbright then exit;
if treeview_upload.rootnodecount=0 then exit;
  node := treeview_upload.getfirstselected;
  if node=nil then begin
   grantslot2.visible := False;
   n13.visible := False;
   removesource2.visible := False;
  end else begin
   dataNode := treeview_upload.getdata(node);

   case DataNode^.m_type of

    dnt_bittorrentMain,
    dnt_BitTorrentSource:begin
          if dataNode^.m_type=dnt_bittorrentSource then begin
           BtSrcData := dataNode^.data;
           removesource2.visible := (btSrcData^.status=btSourceConnected);
         end else removesource2.visible := False;
     GrantSlot2.visible := False;
     addToPlaylist3.visible := False;
     cancel1.visible := True;
     clearIdle1.visible := True;
     BanUser1.visible := False;
     n10.Visible := False;
    end;

    dnt_upload:begin
     UpData := dataNode^.data;
     GrantSlot2.visible := True;
     addToPlaylist3.visible := True;
     cancel1.visible := True;
     ClearIdle1.visible := True;
     BanUser1.visible := True;
     N10.visible := True;
     removesource2.visible := False;
    end;

    dnt_Partialupload:begin
     //DnData := dataNode^.data;
     //Chat1.visible := (DnData^.port<>0);
     GrantSlot2.visible := False;
     addToPlaylist3.visible := False;
     cancel1.visible := False;
     ClearIdle1.visible := False;
     BanUser1.visible := False;
     N10.visible := False;
     removesource2.visible := False;
    end;
   end;

    N13.visible := (grantslot2.visible) or
                 (removesource2.visible);
  end;

getcursorpos(punto);
popup_upload.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.BanUser1Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
begin
node := treeview_upload.getfirstselected;
if node=nil then exit;

datanode := treeview_upload.getdata(node);
if dataNode^.m_type<>dnt_upload then exit;

UpData := dataNode^.data;
UpData^.should_ban := True;
end;

procedure Tares_frmmain.combocatlibraryClick(Sender: TObject);
begin
mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.treeview_downloadMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
punto: TPoint;
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
//BtData:precord_displayed_bittorrentTransfer;
//DsData:precord_displayed_downloadsource;
node:PCmtVNode;
begin
formhint_hide;

if treeview_download.rootnodecount=0 then exit;
if button<>mbright then exit;

 node := treeview_download.getfirstselected;
 if node<>nil then begin
     dataNode := treeview_download.getdata(node);
     case dataNode^.m_type of

       dnt_bittorrentMain,
       dnt_bittorrentSource:begin
         //removesource1.visible := False;
         openpreview2.visible := False;
         pauseresume1.visible := True;
         cancel2.visible := True;
         openexternal1.visible := False;
         N4.visible := False;
         RemoveSource1.visible := False;
         Findmorefromthesame2.visible := False;
         BtData := dataNode^.data;
         if dataNode^.m_type=dnt_bittorrentMain then begin
          if not isFolder(BtData^.path) then begin
           openpreview2.visible := True;
           openexternal1.visible := True;
          end;
         end;
       end;

       dnt_download,
       dnt_PartialDownload:begin
         DnData := dataNode^.data;
         N4.visible := False;
         RemoveSource1.visible := False;
         pauseresume1.visible := True;
         cancel2.visible := True;
         openpreview2.visible := (DnData^.progress>0);
         openexternal1.visible := openpreview2.visible;
         Findmorefromthesame2.visible := (DnData^.tipo=ARES_MIME_MP3);
         Artist3.visible := (length(DnData^.artist)>0);
         Genre3.visible := (length(DnData^.category)>0);
       end;


       dnt_downloadSource:begin
         dataNode := treeview_download.getData(node.parent);
         DnData := dataNode^.data;
         N4.visible := True;
         RemoveSource1.visible := True;
         pauseresume1.visible := True;
         cancel2.visible := True;
         openpreview2.visible := (DnData^.progress>0);
         openexternal1.visible := openpreview2.visible;
         Findmorefromthesame2.visible := (DnData^.tipo=ARES_MIME_MP3);
         Artist3.visible := (length(DnData^.artist)>0);
         Genre3.visible := (length(DnData^.category)>0);
       end;

     end;

 end else begin
  openpreview2.visible := False;
  openexternal1.visible := False;
  pauseresume1.visible := False;
  cancel2.visible := False;
  Findmorefromthesame2.visible := False;
  Artist3.visible := False;
  Genre3.visible := False;
  N4.visible := False;
  RemoveSource1.visible := False;
 end;


getcursorpos(punto);
popup_download.popup(punto.x,punto.y);
end;


procedure Tares_frmmain.treeview_downloadMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
begin

formhint_hide;
repeat
nodo := treeview_upload.GetFirstSelected;
if nodo=nil then break;
treeview_upload.Selected[nodo] := False;
until (not true);

repeat
nodo := treeview_queue.getfirstselected;
if nodo=nil then break;
treeview_queue.selected[nodo] := False;
until (not true);

end;

procedure Tares_frmmain.treeview_uploadMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
begin


formhint_hide;
repeat
nodo := treeview_download.GetFirstSelected;
if nodo=nil then break;
treeview_download.Selected[nodo] := False;
until (not true);

repeat
nodo := treeview_queue.GetFirstSelected;
if nodo=nil then break;
treeview_queue.Selected[nodo] := False;
until (not true);

end;

procedure Tares_frmmain.panel_tran_upquResize(Sender: TObject);
begin
treeview_upload.height := panel_tran_upqu.clientheight-18;
treeview_queue.height := panel_tran_upqu.clientheight-18;
end;

procedure Tares_frmmain.panel_tran_downResize(Sender: TObject);
begin
with treeview_download do begin
// width := panel_tran_down.clientwidth{-4};
 height := panel_tran_down.clientheight-23{top) -2};
end;
end;


procedure Tares_frmmain.label_back_srcClick(Sender: TObject);
begin
if btn_stop_search.enabled then btn_stop_searchclick(nil);
search_toggle_back;
end;

procedure Tares_frmmain.label_more_searchoptClick(Sender: TObject);
begin
if btn_stop_search.enabled then btn_stop_searchclick(nil);
search_toggle_moreopt;
end;

procedure Tares_frmmain.radio_search_allClick(Sender: TObject);
begin
if btn_stop_search.enabled then btn_stop_searchclick(nil);
searchpanel_add_histories;
end;

procedure Tares_frmmain.TreeView2GetSelectedIndex(Sender: TObject;Node: TTreeNode);
begin
if node.level>0 then begin
 node.SelectedIndex := 1;
 node.imageindex := 0;
end;
end;

procedure Tares_frmmain.btn_lib_virtual_viewClick(Sender: TObject);
var
nodo:PCmtVNode;
begin
btn_lib_virtual_view.down := True;
btn_lib_regular_view.down := False;

  treeview_lib_virfolders.visible := True;
  treeview_lib_regfolders.visible := False;

  listview_lib.clear;
  details_library_toggle(false);
   if treeview_lib_virfolders.getfirstselected=nil then begin
    nodo := treeview_lib_virfolders.GetFirst;
    treeview_lib_virfolders.selected[nodo] := True;
    treeview_lib_virfoldersClick(treeview_lib_virfolders);
   end else treeview_lib_virfoldersClick(treeview_lib_virfolders);

   set_reginteger('General.LastLibraryMode',0);
end;

procedure Tares_frmmain.btn_lib_refreshClick(Sender: TObject);
var
paused: Boolean;
begin
try
if share<>nil then begin
 need_rescan := True;
 share.terminate;
 exit;
end;
except
end;

try
paused := set_NEWtrusted_metas;

scan_start_time := gettickcount;
  share := tthread_share.create(true);
  share.paused := paused;
  share.juststarted := False;
share.resume;
except
end;

end;

procedure Tares_frmmain.splitter_libraryEndSplit(Sender: TObject);
begin
with splitter_library do begin
 invalidate;
 left := left+xpos;
 panel6sizedefault := left;
end;

if panel6sizedefault>50 then begin
 set_reginteger('GUI.FoldersWidth',panel6sizedefault);
end;

libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.btn_playlist_closeClick(Sender: TObject);
begin
playlist_visible := False;
blendPlaylistForm.visible := False;
end;

procedure Tares_frmmain.btn_chat_refchanlistClick(Sender: TObject);
begin
should_send_channel_list := True;
end;

procedure Tares_frmmain.listview_chat_channelGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
Size := SizeOf(record_displayed_channel);
end;

procedure Tares_frmmain.listview_chat_channelGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data:precord_displayed_channel;
begin
    Data := sender.getdata(Node);

  if not sender.selectable then begin
   if column=0 then celltext := utf8strtowidestr(data^.name);
   exit;
  end;
case column of
0:celltext := utf8strtowidestr(data^.name);
1:begin
 celltext := data^.language;
end;
2:begin
 //if node.childcount=0 then
 //if data^.ip<>16777343 then celltext := inttostr(data^.users)
  //else
  celltext := ' ';
 // else celltext := Chatlist_GetUserStatStr(node);
 end;
3:begin
   if data^.has_colors_intopic then begin
    celltext := data^.stripped_topic;
   end else
   celltext := data^.stripped_topic;
  end else celltext := chr(32);
end;

end;

procedure Tares_frmmain.listview_srcMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
formhint_hide;
end;

procedure Tares_frmmain.Joinchannel1Click(Sender: TObject);
var
 nodo:PCmtVNode;
 datas:precord_displayed_channel;
begin
nodo := listview_chat_channel.getfirstselected;
if nodo=nil then exit;

if nodo.childcount>0 then
 nodo := nodo.firstchild;


 datas := listview_chat_channel.getdata(nodo);

update_FAVchannel_last(nil,datas);
datas^.enableJSTemplate := vars_global.chat_enabled_remoteJSTemplate;

helper_channellist.join_channel(datas);

end;


procedure Tares_frmmain.listview_chat_channelMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 punto: TPoint;
 datao{,pchan}:precord_displayed_channel;
 //i: Integer;
 node:pcmtvnode;
begin
if button<>mbright then exit;
if not listview_chat_channel.selectable then exit;

with listview_chat_channel do begin

 if not selectable then exit;

 node := getfirstselected;

  if node<>nil then begin

    if node.childcount>0 then begin  //multiple channel on same IP
     joinchannel1.Visible := False;
     AddtoFavorites1.Visible := False;
     exporthashlink5.visible := False;
     N3.visible := False;
     getcursorpos(punto);
     popup_chat_chanlist.popup(punto.x,punto.y);
     exit;
    end;

   datao := getdata(node);
    joinchannel1.Visible := True;
    exporthashlink5.visible := True;
    AddtoFavorites1.Visible := True; //TODO is already in list?
    N3.visible := True;

  end else begin
    joinchannel1.Visible := False;
    exporthashlink5.visible := False;
    AddtoFavorites1.Visible := False;
    N3.visible := False;
  end;

end;

getcursorpos(punto);
popup_chat_chanlist.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.testoURLClick(Sender: TObject; const URLText: String; Button: TMouseButton);
var
 posi: Integer;
 link: string;
begin


posi := pos(const_ares.STR_ARLNK_LOWER,lowercase(urltext));
if posi>0 then begin
 helper_hashlinks.add_WebLink(URLdecode(copy(urltext,posi+8,length(urltext))));
 exit;
end;

posi := pos('http://arlnk//',lowercase(urltext));
if posi=1 then begin
 helper_hashlinks.add_WebLink(URLdecode(copy(urltext,posi+14,length(urltext))));
 exit;
end;

Tnt_ShellExecuteW(0,'open',pwidechar(widestring(urltext)),'','',SW_SHOWNORMAL);
end;

procedure Tares_frmmain.listview_libMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
data:precord_file_library;
nomefile,estensione: string;
punto: TPoint;
begin
if listview_lib.header.height=34 then exit;

nodo := listview_lib.getfirstselected;
  if nodo=nil then begin
   locate1.visible := False;
   openwithexternalplayer2.visible := False;
   addtoplaylist1.visible := False;
   deletefile2.visible := False;
   shareun1.visible := False;
   openplay1.visible := False;
   n5.visible := False;
   Findmoreofthesameartist1.visible := False;
   ExportHashLink1.visible := False;
  end else begin
    data := listview_lib.getdata(nodo);
     n5.visible := True;
   openwithexternalplayer2.visible := True;
   locate1.visible := True;

   shareun1.visible := (not data^.previewing);
   DeleteFile2.visible := (not data^.previewing);
   ExportHashLink1.visible := (not data^.previewing);
     data := listview_lib.getdata(nodo);
     nomefile := data^.path;


      Artist1.visible := ((length(data^.artist)>0) and (data^.amime=ARES_MIME_MP3));
      Genre1.visible := ((length(data^.category)>0) and (data^.amime=ARES_MIME_MP3));
      Findmoreofthesameartist1.visible := ((Artist1.visible) or (Genre1.visible));

     estensione := lowercase(extractfileext(nomefile));
      if ((pos(estensione,PLAYABLE_AUDIO_EXT)=0) and
          (pos(estensione,PLAYABLE_IMAGE_EXT)=0) and
          (pos(estensione,PLAYABLE_VIDEO_EXT)=0)) then begin
         addtoplaylist1.visible := False;
         openplay1.visible := False;
      end else begin
         addtoplaylist1.visible := True;
         openplay1.visible := True;
     end;
 end;

if button<>mbright then exit;
getcursorpos(punto);
popup_library.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.listview_srcFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_search_result(sender,node);
if node=previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.listview_libFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_file_library(sender,node);
if node=previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_downloadfreenode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_displayed_download(sender,node);
if node=previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_uploadfreenode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_displayed_treeviewupload(sender,node);
if node=previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.listview_chat_channelFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_chatchannel(sender,node);
end;

procedure Tares_frmmain.treeview_lib_virfoldersClick(Sender: TObject);
var
level: Integer;
node:PCmtVNode;
begin

details_library_hideall;

node := treeview_lib_virfolders.getfirstselected;
if node=nil then exit;

try
  level := treeview_lib_virfolders.getnodelevel(node);

  if level=0 then begin

      if hashing then begin
        libraryOnResize(treeview_lib_regfolders.parent);
       exit;
      end;
   // listview_lib.color := COLORE_LISTVIEWS_BG;
   stato_header_library := helper_visual_headers.header_library_show('Library','Library',listview_lib,GetLangStringA(STR_YOUR_LIBRARY),CAT_YOUR_LIBRARY,CAT_NOGROUP);
   apri_general_library_virtual_view(true,lista_shared,listview_lib,imagelist_lib_max);
   libraryOnResize(treeview_lib_regfolders.parent);

  end else begin

   stato_header_library := apri_categoria_library('Library','Library',treeview_lib_virfolders,listview_lib,lista_shared,level,node);
    if listview_lib.Header.sortcolumn<>-1 then listview_lib.Sort(nil,listview_lib.Header.sortcolumn,listview_lib.Header.sortdirection);
     if ((listview_lib.rootnodecount>0) and
         (btn_lib_toggle_Details.down) and
         (not hashing)) then begin
          node := listview_lib.getfirst;
          listview_lib.selected[node] := True;
          listview_libclick(nil);
     end;
     libraryOnResize(treeview_lib_regfolders.parent);
  end;


except
end;
end;

procedure Tares_frmmain.treeview_lib_regfoldersClick(Sender: TObject);
var
i: Integer;
pfile:precord_file_library;
data,data_folder:^record_cartella_share;
nodo,nodo_child,nodo_file:PCmtVNode;
pfile_folder:precord_file_library;
begin

details_library_hideall;

nodo := treeview_lib_regfolders.getfirstselected;
if nodo=nil then exit;

try

details_library_toggle(false);

  if treeview_lib_regfolders.getnodelevel(nodo)=0 then begin

      if hashing then begin
        libraryOnResize(treeview_lib_regfolders.parent);
       exit;
      end;
      
   stato_header_library := header_library_show('Library','Library',listview_lib,GetLangStringA(STR_YOUR_LIBRARY),CAT_YOUR_LIBRARY,CAT_NOGROUP);
   apri_general_library_folder_view(true,lista_shared,listview_lib,imagelist_lib_max,treeview_lib_regfolders);
   libraryOnResize(treeview_lib_regfolders.parent);
   exit;
  end;




 with listview_lib do begin
  defaultnodeheight := 18;
  images := img_mime_small;
  canbgcolor := True;
   with header do begin
    height := 21;
    autosizeindex := 10;
    options := [hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];
    columns[0].options := [coAllowClick,coEnabled,coDraggable,coResizable,coShowDropMark,coVisible];
   end;
  end;

   libraryOnResize(treeview_lib_regfolders.parent);
     with listview_lib do begin
      if rootnodecount>0 then begin
       BeginUpdate;
       Clear;
      end;
     end;
      stato_header_library := header_library_show('Library','Library',listview_lib,GetLangStringA(STR_YOUR_LIBRARY),CAT_ALL,CAT_NOGROUP);

      data := treeview_lib_regfolders.getdata(nodo);

      nodo_child := treeview_lib_regfolders.getfirstchild(nodo);
      while (nodo_child<>nil) do begin
         data_folder := treeview_lib_regfolders.getdata(nodo_child);
         nodo_file := listview_lib.addchild(nil);
          pfile_folder := listview_lib.getdata(nodo_file);
          with pfile_folder^ do begin
           mediatype := GetLangStringA(STR_FOLDER);
           imageindex := 0;
           fsize := 0;
           title := widestrtoutf8str(extract_fnameW(data_folder^.path));
           language := widestrtoutf8str(data_folder^.path);
            artist := GetLangStringA(STR_FOLDER)+': '+widestrtoutf8str(extract_fnameW(data_folder^.path));
            category := inttostr(data_folder^.items)+' '+GetLangStringA(STR_FOUND);
            album := inttostr(data_folder^.items_shared)+' '+GetLangStringA(STR_SHARED);
            year := GetLangStringA(STR_LOCATION)+': '+widestrtoutf8str(extract_fpathW(data_folder^.path));
          end;
       nodo_child := treeview_lib_regfolders.getnextsibling(nodo_child);
      end;

 for i := 0 to lista_shared.count-1 do begin
  pfile := lista_shared[i];
  if pfile^.folder_id=data^.id then
   library_file_show(listview_lib,pfile);
 end;

 with listview_lib do begin
   if Header.sortcolumn<>-1 then Sort(nil,Header.sortcolumn,Header.sortdirection);
    endupdate;
  end;

except
end;

end;

procedure Tares_frmmain.listview4SelectionChange(Sender: TBaseCometTree;Node: PCmtVNode);
begin
listview_libclick(nil);
end;

procedure Tares_frmmain.treeview_lib_virfoldersKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if ((key=VK_UP) or (key=VK_DOWN)) then treeview_lib_virfoldersclick(nil);
end;

procedure Tares_frmmain.treeview_lib_regfoldersKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if ((key=VK_UP) or (key=VK_DOWN)) then treeview_lib_regfoldersclick(nil);
end;

procedure Tares_frmmain.edit_lib_searchKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
var
i,h: Integer;
ffile:precord_file_library;
search_str: string;
split_string: TMyStringList;
filestr: string;
found: Boolean;
begin


try
if length(edit_lib_search.text)<1 then begin
 if btn_lib_virtual_view.down then treeview_lib_virfoldersclick(nil)
  else treeview_lib_regfoldersclick(nil);
  edit_lib_search.glyphindex := 12;
  edit_lib_search.text := '';
exit;
end;

  edit_lib_search.glyphIndex := 11;

  with listview_lib do begin
   canbgcolor := True;
   defaultnodeheight := 18;
   images := ares_FrmMain.img_mime_small;
   with header do begin
    autosizeindex := 10;
    options := [hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];
    columns[0].options := [coAllowClick,coEnabled,coDraggable,coResizable,coShowDropMark,coVisible];
    height := 21;
   end;
      if rootnodecount>0 then begin
        BeginUpdate;
        Clear;
      end;
    end;

      stato_header_library := header_library_show('Library','Library',listview_lib,GetLangStringA(STR_YOUR_LIBRARY),CAT_ALL,CAT_NOGROUP);
except
end;


   search_str := lowercase(widestrtoutf8str(edit_lib_search.text));
   split_string := tmyStringList.create;
try
   SplitString(search_str,split_string);

for i := 0 to lista_shared.count-1 do begin
    try
    ffile := lista_shared[i];
    filestr := lowercase(ffile^.title+chr(32)+
                       ffile^.artist+chr(32)+
                       ffile^.album);

    found := True;
     for h := 0 to split_string.count-1 do begin
      if pos(split_string.strings[h],filestr)=0 then begin
       found := False;
       break;
      end;
     end;
    if found then library_file_show(listview_lib,ffile);

    except
    end;
end;

   if listview_lib.Header.sortcolumn>=0 then
   listview_lib.Sort(nil,listview_lib.Header.sortcolumn,listview_lib.Header.sortdirection);

listview_lib.endupdate;
listview_lib.color := COLORE_LISTVIEWS_BG;

except
end;
split_string.clear;
split_string.Free;
end;

procedure Tares_frmmain.listview_srcPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
data:precorD_search_result;
begin
if not sender.selectable then exit;

data := sender.getdata(node);

if data^.bold_font then TargetCanvas.Font.style := [fsBold]
 else TargetCanvas.Font.style := [];

if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext else begin
 if data^.already_in_lib then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1{clgray} else
 if data^.being_downloaded then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT2{cl$00FFBF95}
  else TargetCanvas.font.color := COLORE_LISTVIEWS_FONT;
end;


end;

procedure Tares_frmmain.btn_tran_locateClick(Sender: TObject);
var
nodo:PCmtVNode;
begin
nodo := treeview_download.GetFirstselected;
 if nodo=nil then begin
  nodo := treeview_upload.GetFirstselected;
    if nodo=nil then begin
      open_file_external(myshared_folder);
     exit;
    end else begin
     if btn_tran_toggle_queup.caption=GetLangStringA(STR_SHOW_QUEUE) then LocateUpload3Click(nil)
      else MenuItem10Click(nil);
    end;
 end else Locate2Click(nil);
end;

procedure Tares_frmmain.PauseallUnpauseAll1Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_download.GetFirst;
while (node<>nil) do begin
  dataNode := treeview_download.getdata(node);

  case dataNode^.m_type of

   dnt_download:begin
     DnData := dataNode^.data;
     DnData^.change_paused := True;
   end;

   dnt_bittorrentMain:begin
    BtData := dataNode^.data;
    if BtData^.state<>dlCancelled then
     if BtData^.state<>dlSeeding then BtData^.want_paused := True;
   end;
   
  end;

 node := treeview_download.GetNextsibling(node);
end;
end;

procedure Tares_frmmain.Play3Click(Sender: TObject);
var
nodo:PCmtVNode;
data:precord_search_result;
i,hi: Integer;
pfile:precord_file_library;
src:precord_panel_search;
begin

for hi := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[hi];
 if src^.containerPanel<>pagesrc.activepanel then continue;

nodo := src^.listview.getfirstselected;
if nodo=nil then exit;

if src^.listview.GetNodeLevel(nodo)>0 then nodo := nodo.parent;
data := src^.listview.getdata(nodo);

for i := 0 to lista_shared.count-1 do begin
pfile := lista_shared[i];

if pfile^.crcsha1=data^.crcsha1 then
 if pfile^.hash_sha1=data^.hash_sha1 then begin
    player_playnew(utf8strtowidestr(pfile^.path));
   break;
 end;

end;
break;

end;


end;

procedure Tares_frmmain.hash_pri_trxChanged(Sender: TObject);
begin
set_reginteger(chr(72)+chr(97)+chr(115)+chr(104)+chr(105)+chr(110)+chr(103)+chr(46)+chr(80)+chr(114)+chr(105)+chr(111)+chr(114)+chr(105)+chr(116)+chr(121){'Hashing.Priority'},hash_pri_trx.Max-hash_pri_trx.position);
hash_throttle := hash_pri_trx.Max-hash_pri_trx.position;
hash_update_GUIpry;
end;

procedure Tares_frmmain.treeview_downloadHintStart(Sender: TBaseCometTree;Node: PCmtVNode);
begin
if (sender as tcomettree).rootnodecount=0 then exit;
if not (sender as tcomettree).selectable then exit;
if check_bounds_hint then mainGui_hintTimer((sender as tcomettree), node);
end;

procedure Tares_frmmain.treeview_downloadHintStop(Sender: TBaseCometTree; Node: PCmtVNode);
begin
formhint_hide;
end;

procedure tares_frmmain.trigger_sendedit_chat(edit_chat: Ttntedit);
begin
end;

procedure Tares_frmmain.Originalsize1Click(Sender: TObject);
begin
if not isvideoplaying then exit;
if fullscreen2.checked then Fullscreen2Click(nil);

originalsize1.checked :=  not originalsize1.checked;

if not originalsize1.checked then begin
 fittoscreen1.checked := True;
end else fittoscreen1.checked := False;
resize_video_window;
end;



procedure Tares_frmmain.edit_src_filterKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
var
i,hi,h: Integer;
resu:precord_search_result;
search_str: string;
split_string: TMyStringList;
filestr: string;
found: Boolean;
src:precord_panel_search;
begin
try



for hi := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[hi];
 if src^.containerPanel<>pagesrc.activepanel then continue;


 if length(edit_src_filter.text)<1 then begin
  src^.listview.BeginUpdate;
  src^.listview.Clear;
   for i := 0 to src^.backup_results.count-1 do begin
    resu := src^.backup_results[i];
    add_search_result(src^.listview,resu);
   end;
  if src^.listview.Header.sortcolumn>=0 then src^.listview.Sort(nil,src^.listview.header.sortcolumn,src^.listview.header.sortdirection);
  src^.listview.endupdate;
  edit_src_filter.glyphindex := 12;
exit;
end;

edit_src_filter.glyphIndex := 11;
split_string := tmyStringList.create;


  src^.listview.BeginUpdate;
  src^.listview.Clear;

   search_str := lowercase(widestrtoutf8str(edit_src_filter.text));
   SplitString(search_str,split_string);

for i := 0 to src^.backup_results.count-1 do begin
    try
    resu := src^.backup_results[i];
    with resu^ do filestr := lowercase(title+chr(32)+
                                     artist+chr(32)+
                                     album+chr(32)+
                                     category+chr(32)+
                                     language);


    found := True;
     for h := 0 to split_string.count-1 do begin
      if pos(split_string.strings[h],filestr)=0 then begin
       found := False;
       break;
      end;
     end;

    if found then add_search_result(src^.listview,resu);

    except
    end;
end;

if src^.listview.Header.sortcolumn>=0 then src^.listview.Sort(nil,src^.listview.header.sortcolumn,src^.listview.header.sortdirection);
src^.listview.endupdate;


split_string.clear;
split_string.Free;

break;
end;

except
end;
end;

procedure Tares_frmmain.listview_libKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if key=vk_delete then deleteClick(nil) else
if key=VK_RETURN then OpenPlay1Click(nil);
end;

procedure Tares_frmmain.ClearIdle2Click(Sender: TObject);
var
node,next:PCmtVNode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_download.GetFirst;
while (node<>nil) do begin

   dataNode := treeview_download.getdata(node);

   case dataNode^.m_type of

      dnt_bittorrentMain:begin
       BtData := dataNode^.data;
       if vars_global.previous_hint_node=node then formhint_hide;

       if BtData^.handle_obj=INVALID_HANDLE_VALUE then begin  //already cancelled, just clear node
         next := treeview_download.GetNextsibling(node);
          treeview_download.deletenode(node);
         node := next;
         continue;
       end else begin
        if BtData^.state=dlSeeding then BtData^.want_cleared := True; // let thread_bittorrent know it's time to stop seeding
       end;
        node := treeview_download.GetNextsibling(node);
         continue;
      end;

      dnt_download:begin
        DnData := dataNode^.data;
        if helpeR_download_misc.isDownloadTerminated(DnData) then begin
               if vars_global.previous_hint_node=node then formhint_hide;
         next := treeview_download.GetNextsibling(node);
          treeview_download.deletenode(node);
         node := next;
        continue;
      end;

   end;
  end;

node := treeview_download.GetNextsibling(node);
end;

end;

procedure Tares_frmmain.ClearIdle1Click(Sender: TObject);
var
node,next:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
BtData:precord_displayed_bittorrentTransfer;
begin
if sender<>nil then begin
 clearIdle1.checked := not clearIdle1.checked;
 helper_registry.set_reginteger('Upload.AutoClearIdle',integer(clearIdle1.checked));
end;

node := treeview_upload.GetFirst;
while (node<>nil) do begin

  dataNode := treeview_upload.getdata(node);

   if dataNode^.m_type=dnt_BitTorrentMain then begin  //clear bittorrent uploads
     BtData := dataNode^.data;
      if BtData.handle_obj=INVALID_HANDLE_VALUE then begin
        if vars_global.previous_hint_node=node then formhint_hide;
        next := treeview_upload.GetNextSibling(node);
         treeview_upload.deletenode(node,true);
        node := next;
      end else node := treeview_upload.GetNextSibling(node);
     continue;
   end;

  if dataNode^.m_type<>dnt_upload then begin
   node := treeview_upload.GetNextSibling(node);
   continue;
  end;


  UpData := dataNode^.data;

   if UpData^.completed then begin
    if vars_global.previous_hint_node=node then formhint_hide;
    
    next := treeview_upload.GetNextSibling(node);
     treeview_upload.deletenode(node,true);
    node := next;
    continue;
   end;

   node := treeview_upload.GetNextSibling(node);
end;

end;

procedure Tares_frmmain.Artist1Click(Sender: TObject);
var
data:precord_file_library;
nodo:PCmtVNode;
begin
try
nodo := listview_lib.getfirstselected;
if nodo=nil then exit;

data := listview_lib.getdata(nodo);
searchpanel_setfindmore_art(data^.artist);

ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;

except
end;
end;

procedure Tares_frmmain.Genre1Click(Sender: TObject);
var
data:precord_file_library;
nodo:PCmtVNode;
begin
try
nodo := listview_lib.getfirstselected;
if nodo=nil then exit;

data := listview_lib.getdata(nodo);
searchpanel_setfindmore_gen(data^.category);

ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;

except
end;
end;

procedure Tares_frmmain.Artist2Click(Sender: TObject);
var
data:precord_search_result;
nodo:PCmtVNode;
src:precord_panel_search;
i: Integer;
begin
try

for i := 0 to src_panel_list.count - 1 do begin
 src := src_panel_list[i];
 if src^.containerPanel<>pagesrc.activepanel then continue;
 pagesrc.activepage := 0;
 
 nodo := src^.listview.getfirstselected;
 if nodo=nil then exit;

 data := src^.listview.getdata(nodo);
 searchpanel_setfindmore_art(data^.artist);

 Btn_start_searchclick(nil);
 break;
end;

except
end;
end;



procedure Tares_frmmain.Genre2Click(Sender: TObject);
var
data:precord_search_result;
nodo:PCmtVNode;
src:precord_panel_search;
i: Integer;
begin
try

for i := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[i];
 if src^.containerPanel<>pagesrc.activepanel then continue;
 pagesrc.activepage := 0;

 nodo := src^.listview.getfirstselected;
 if nodo=nil then exit;

 data := src^.listview.getdata(nodo);
 searchpanel_setfindmore_gen(data^.category);

 Btn_start_searchclick(nil);

 break;
end;

except
end;
end;

procedure Tares_frmmain.Artist3Click(Sender: TObject);
var
dataNode:precord_data_node;
DnData:precord_displayed_download;
node:PCmtVNode;
begin
try
node := treeview_download.getfirstselected;
if node=nil then exit;

if treeview_download.getnodelevel(node)=1 then node := node.Parent;
dataNode := treeview_download.getdata(node);

if dataNode^.m_type<>dnt_download then
 if dataNode^.m_type<>dnt_partialDownload then exit;

 DnData := dataNode^.data;
 searchpanel_setfindmore_art(DnData^.artist);
 ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;


except
end;
end;

procedure tares_frmmain.genre3click(sender: Tobject);
var
dataNode:precord_data_node;
DnData:precord_displayed_download;
node:PCmtVNode;
begin
try
node := treeview_download.getfirstselected;
if node=nil then exit;

if treeview_download.getnodelevel(node)=1 then node := node.Parent;
dataNode := treeview_download.getdata(node);
if dataNode^.m_type<>dnt_download then
 if dataNode^.m_type<>dnt_partialDownload then exit;

 DnData := dataNode^.data;
 searchpanel_setfindmore_gen(DnData^.category);
 ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;


except
end;
end;



procedure Tares_frmmain.Openexternal1Click(Sender: TObject);
var
 node:PCmtVNode;
 dataNode:precord_data_node;
 DnData:precord_displayed_download;
//BtData:precord_displayed_bittorrentTransfer;
 BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_download.GetFirstSelected;
if node=nil then exit;
if treeview_download.getnodelevel(node)=1 then node := node.Parent;
dataNode := treeview_download.getdata(node);

 case dataNode^.m_type of

  dnt_bittorrentMain,dnt_bittorrentSource:begin
   BtData := dataNode^.data;
   open_file_external(BtData^.path);
  end;

  dnt_download,
  dnt_partialDownload:begin
   DnData := dataNode^.data;
   open_file_external(DnData^.filename);
  end;
  
 end;

end;

procedure Tares_frmmain.OpenExternal2Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
begin
node := treeview_upload.GetFirstSelected;
if node=nil then exit;

datanode := treeview_upload.getdata(node);
case dataNode^.m_type of
 dnt_bittorrentMain:begin
  BtData := dataNOde^.data;
  open_file_external(BtData^.path);
 end;
 dnt_bittorrentSource:begin
  node := node.parent;
  dataNode := treeview_upload.getData(node);
  BtData := dataNode^.data;
  open_file_external(BtData^.path);
 end;
 dnt_upload:begin
   UpData := dataNode^.data;
   open_file_external(UpData^.nomefile);
 end;
 dnt_partialUpload:begin
   DnData := dataNode^.data;
   open_file_external(DnData^.filename);
 end;
end;
end;

procedure Tares_frmmain.browsebtnClick(Sender: TObject);
begin
//
end;

procedure Tares_frmmain.btn_tran_toggle_queupClick(Sender: TObject);
begin
if btn_tran_toggle_queup.caption=GetLangStringA(STR_SHOW_QUEUE) then begin
 btn_tran_toggle_queup.caption := GetLangStringA(STR_SHOW_UPLOAD);
 btn_tran_toggle_queup.hint := GetLangStringA(STR_SHOW_UPLOAD_HINT);
 treeview_queue.clear;
 treeview_queue.visible := True;
 treeview_upload.visible := False;
end else begin
 btn_tran_toggle_queup.caption := GetLangStringA(STR_SHOW_QUEUE);
 btn_tran_toggle_queup.hint := GetLangStringA(STR_HINT_SHOW_QUEUE);
 treeview_upload.visible := True;
 treeview_queue.clear;
 treeview_queue.visible := False;
end;

btns_transferResize(btns_transfer);
end;

procedure Tares_frmmain.treeview_queuefreenode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_displayed_queued(sender,node);
if node=previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_queueGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
Size := SizeOf(record_queued);
end;

procedure Tares_frmmain.treeview_queueGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
Data:precord_queued;
begin
  Data := sender.getdata(Node);

case column of
 1:CellText := extract_fnameW(utf8strtowidestr(data^.nomefile));
 0:CellText := utf8strtowidestr(data^.user);
 2:begin
   if data^.size<4096 then CellText := format_currency(data^.size)
    else CellText := format_currency(data^.size DIV 1024)+STR_KB+' ('+format_currency(data^.size)+chr(32)+STR_BYTES+chr(41){')'};
  end else CellText := chr(32);
end;
end;

procedure Tares_frmmain.treeview_queueMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
punto: TPoint;
begin

if button<>mbright then exit;
if treeview_queue.getfirstselected=nil then exit;

getcursorpos(punto);
popup_queue.popup(punto.x,punto.y);   
end;

procedure Tares_frmmain.Blockhost1Click(Sender: TObject);
var
node:PCmtVNode;
data,datacomp:precord_queued;
i: Integer;
begin

node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);
data^.banned := True;

 i := 0;
 repeat
 if i=0 then node := treeview_queue.getfirst
  else node := treeview_queue.getnextsibling(node);
  if node=nil then break;
  inc(i);
  datacomp := treeview_queue.getdata(node);
  if ((datacomp^.ip=data^.ip) and (datacomp^.port=data^.port)) then datacomp^.banned := True;
until (not true);

end;

procedure Tares_frmmain.treeview_queueGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
begin
ImageIndex := 8;
end;

procedure Tares_frmmain.treeview_queueMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
begin

try
formhint_hide;
repeat
nodo := treeview_download.GetFirstSelected;
if nodo=nil then break;
treeview_download.Selected[nodo] := False;
until (not true);

repeat
nodo := treeview_upload.GetFirstSelected;
if nodo=nil then break;
treeview_upload.Selected[nodo] := False;
until (not true);

except
end;
end;

procedure Tares_frmmain.treeview_queueHintStop(Sender: TBaseCometTree);
begin
//hide_formhint;
end;

procedure Tares_frmmain.Connect1DrawItem(Sender: TObject; ACanvas: TCanvas;ARect: TRect; Selected: Boolean);
begin
//
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
size := sizeof(ares_types.record_string);
end;

procedure Tares_frmmain.treeview_lib_regfoldersFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_regular_browse_folder(sender,node);
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
size := sizeof(ares_types.record_cartella_share);
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
 if not (vsSelected in node.states) then ImageIndex := 0
  else ImageIndex := 1;
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
 if not (vsSelected in node.states) then ImageIndex := 0
  else ImageIndex := 1;
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data:ares_types.precord_string;
begin
Data := sender.getdata(Node);
 if data^.counter=0 then CellText := utf8strtowidestr(data^.str)
  else CellText := utf8strtowidestr(data^.str)+' ('+
                                inttostr(data^.counter)+')';
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
  var
  data:ares_types.precord_cartella_share;
  str_of_shared: string;
begin
Data := sender.getdata(Node);

    if sender.getnodelevel(node)>0 then begin
        if data^.items>0 then begin
           if sender=treeview_lib_regfolders then str_of_shared := inttostr(data^.items_shared)+'/' else str_of_shared := '';
            celltext := extract_fnameW(data^.path)+' ('+str_of_shared+ inttostr(data^.items)+')';
        end else celltext := extract_fnameW(data^.path);
    end else CellText := data^.path;

end;

procedure Tares_frmmain.treeview_lib_regfoldersCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: precord_cartella_share;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  if column=0 then Result :=  CompareText( extractfilename(data1^.path_utf8), extractfilename(data2^.path_utf8) );
end;

procedure Tares_frmmain.listview_playlistGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
size := sizeof(ares_types.record_file_playlist);
end;

procedure Tares_frmmain.listview_playlistFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_file_playlist(sender,node);
end;

procedure Tares_frmmain.listview_playlistGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
data:ares_types.precord_file_playlist;
begin
data := sender.getdata(node);

case column of
 -1,0:celltext := utf8strtowidestr(data^.displayName);
 1:celltext := format_time(data^.length);
end;

end;

procedure Tares_frmmain.listview_playlistCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
data1,data2:ares_types.precord_file_playlist;
begin
if shufflying_playlist then begin
 Result := 50-random(100);
 exit;
end;

if column<0 then exit;
data1 := sender.getdata(node1);
data2 := sender.getdata(node2);

case column of
 0: Result := comparetext(data1^.displayName,data2^.displayName);
 1: Result := data1^.length-data2^.length;
end;

end;

procedure Tares_frmmain.listview_playlistGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
var
data:ares_types.precord_file_playlist;
begin

      Data := sender.getdata(node);
       if data^.amime=ARES_MIME_VIDEO then ImageIndex := 4
        else ImageIndex := 3;

end;

procedure Tares_frmmain.playlist_RemoveAll1Click(Sender: TObject);
begin
listview_playlist.clear;
end;

procedure Tares_frmmain.playlist_Removeselected1Click(Sender: TObject);
var
nodo:PCmtVNode;
begin

repeat
nodo := listview_playlist.getfirstselected;
if nodo=nil then exit;
listview_playlist.DeleteNode(nodo);
until (not true);

end;

procedure Tares_frmmain.playlist_openextClick(Sender: TObject);
var
nodo:PCmtVNode;
data:ares_types.precord_file_playlist;
begin
nodo := listview_playlist.getfirstselected;
if nodo=nil then exit;
data := listview_playlist.getdata(nodo);
 open_file_external(data^.filename);
end;


procedure Tares_frmmain.playlist_LocateClick(Sender: TObject);
var
nodo:PCmtVNode;
data:ares_types.precord_file_playlist;
begin
nodo := listview_playlist.getfirstselected;
if nodo=nil then exit;
data := listview_playlist.getdata(nodo);
locate_containing_folder(data^.filename);
end;


procedure Tares_frmmain.playlist_Randomplay1Click(Sender: TObject);
begin
playlist_randomplay1.checked := not playlist_randomplay1.checked;
set_reginteger('Playlist.Shuffle',integer(playlist_randomplay1.checked));
end;

procedure Tares_frmmain.playlist_Continuosplay1Click(Sender: TObject);
begin
playlist_continuosplay1.checked := not playlist_continuosplay1.checked;
set_reginteger('Playlist.Repeat',integer(playlist_continuosplay1.checked));
end;

procedure Tares_frmmain.playlist_AlphasortascClick(Sender: TObject);
begin
listview_playlist.Sort(nil,0,sdAscending);
end;

procedure Tares_frmmain.playlist_AlphasortdescClick(Sender: TObject);
begin
listview_playlist.Sort(nil,0,sdDescending);
end;


procedure Tares_frmmain.listview_playlistDblClick(Sender: TObject);
var
nodo:PCmtVNode;
data:ares_types.precord_file_playlist;
begin
nodo := listview_playlist.getfirstselected;
if nodo=nil then exit;
data := listview_playlist.getdata(nodo);
player_playnew(utf8strtowidestr(data^.filename));
end;

procedure Tares_frmmain.listview_playlistMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
popup_playlist.autopopup := True;
end;

procedure Tares_frmmain.listview_playlistKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if key=vk_delete then playlist_Removeselected1Click(nil) else
if key=VK_RETURN then listview_playlistDblClick(nil) else
if key=66 then begin
 playlist_select_prev;
 listview_playlistDblClick(nil);
end else
if key=78 then begin
 playlist_select_next;
 listview_playlistDblClick(nil);
end else
if key=VK_DOWN then playlist_select_next else
if key=VK_UP then playlist_select_prev;
end;

procedure Tares_frmmain.Loadplaylist1Click(Sender: TObject);
begin
opendialog1.filter := GetLangStringW(STR_PLAYLIST_FILES)+'|*.m3u';
if not opendialog1.execute then exit;

playlist_loadm3u(opendialog1.filename,false);
end;

procedure Tares_frmmain.Saveplaylist1Click(Sender: TObject);
var
filename: WideString;
begin
savedialog1.filter := GetLangStringW(STR_PLAYLIST_FILES)+'|*.m3u';
savedialog1.filename := GetLangStringW(STR_PLAYLIST)+chr(46)+chr(109)+chr(51)+chr(117);

if not savedialog1.execute then exit;

filename := savedialog1.filename;
if lowercase(extractfileext(widestrtoutf8str(filename)))<>'.m3u' then filename := filename+'.m3u';
playlist_savem3u(filename);
end;

procedure Tares_frmmain.playlist_sortInvClick(Sender: TObject);
begin
shufflying_playlist := True;
 listview_playlist.Sort(nil,0,sdascending);
shufflying_playlist := False;
end;

procedure Tares_frmmain.btn_playlist_addfileClick(Sender: TObject);
var
estensione: string;
filename: WideString;
begin
opendialog1.Filter := GetLangStringW(STR_ANY_FILE)+'|'+const_ares.STR_ANYFILE_DISKPATTERN;
if not opendialog1.execute then exit;

filename := opendialog1.filename;
estensione := lowercase(extractfileext(widestrtoutf8str(filename)));

 if estensione='.m3u' then playlist_loadm3u(filename,false)
  else playlist_addfile(widestrtoutf8str(filename),-1,false,'');

end;

procedure Tares_frmmain.btn_playlist_addfolderClick(Sender: TObject);
begin
if not fol.execute then exit;
 playlist_addfolder(fol.foldername);
end;

procedure Tares_frmmain.listview_srcCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,Data2: precord_search_result;
  tipo_colonna: Tcolumn_type;
  str1,str2: string;
  rec_res:precord_panel_search;
  cmp1,cmp2: Integer;
begin
if column<0 then exit;

 rec_res := precord_panel_search(sender.tag);
 tipo_colonna := rec_res^.stato_header[column];

 Data1 := sender.getdata(Node1);
 Data2 := sender.getdata(Node2);

case tipo_colonna of
 COLUMN_TITLE: Result := CompareText(Data1.title, Data2.title);
 COLUMN_ARTIST: Result := CompareText(Data1.artist, Data2.artist);
 COLUMN_CATEGORY: Result := CompareText(Data1.category, Data2.category);
 COLUMN_ALBUM: Result := CompareText(Data1.album, Data2.album);
 COLUMN_TYPE: Result := Data1.amime-Data2.amime;
 COLUMN_SIZE:begin
             if ((data1.fsize-data2.fsize>GIGABYTE) or
                 (data2.fsize-data1.fsize>GIGABYTE)) then Result := (data1.fsize DIV KBYTE)-(data2.fsize DIV KBYTE)
              else Result := data1.fsize-data2.fsize;
             end;
 COLUMN_DATE: Result := CompareText(data1^.year,data2^.year);
 COLUMN_LANGUAGE: Result := CompareText(Data1.language, Data2.language);
 COLUMN_VERSION: Result := CompareText(Data1.album, Data2.album);
 COLUMN_QUALITY: Result := data1.param1-data2.param1;
 COLUMN_COLORS: Result := data1.param3-data2.param3;
 COLUMN_LENGTH: Result := data1.param3-data2.param3;
 COLUMN_RESOLUTION: Result := data1.param1-data2.param1;
 COLUMN_STATUS:begin
      if data1^.isTorrent then cmp1 := data1^.param1*256 else cmp1 := ((node1.childcount*256)+data1^.DHTload);
      if data2^.isTorrent then cmp2 := data2^.param1*256 else cmp2 := ((node2.childcount*256)+data2^.DHTLoad);
      Result := cmp1-cmp2;
   end;
 COLUMN_USER:begin
             if node1.childcount>0 then str1 := inttostr(node1.childcount)+' '+GetLangStringA(STR_USERS) else str1 := data1^.nickname;
             if node2.childcount>0 then str2 := inttostr(node2.childcount)+' '+GetLangStringA(STR_USERS) else str2 := data2^.nickname;
             Result := CompareText(str1, str2);
            end;
 COLUMN_FILENAME: Result := CompareText(Data1.filenameS, Data2.filenameS);
 COLUMN_FILETYPE: Result := CompareText(lowercase(extractfileext(Data1.filenameS)), lowercase(extractfileext(Data2.filenameS)));
end;

end;

procedure Tares_frmmain.listview_libCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: precord_file_library;
  tipo_colonna: Tcolumn_type;
begin
if column<0 then exit;

tipo_colonna := stato_header_library[column];

  Data1 := sender.getdata(Node1);
  Data2 := sender.getdata(Node2);
  
case tipo_colonna of
 COLUMN_TITLE: Result := CompareText(Data1^.title, Data2^.title);
 COLUMN_ARTIST: Result := CompareText(Data1^.artist, Data2^.artist);
 COLUMN_CATEGORY: Result := CompareText(Data1^.category, Data2^.category);
 COLUMN_ALBUM: Result := CompareText(Data1^.album, Data2^.album);
 COLUMN_SIZE:begin
                            if ((data1.fsize-data2.fsize>GIGABYTE) or
                                (data2.fsize-data1.fsize>GIGABYTE)) then Result := (data1.fsize DIV KBYTE)-(data2.fsize DIV KBYTE)
                                else Result := data1.fsize-data2.fsize;
                            end;
 COLUMN_DATE: Result := CompareText(Data1^.year, Data2^.year);
 COLUMN_LANGUAGE: Result := CompareText(Data1^.language, Data2^.language);
 COLUMN_VERSION: Result := CompareText(Data1^.album, Data2^.album);
 COLUMN_QUALITY: Result := data1^.param1-data2^.param1;
 COLUMN_COLORS: Result := data1^.param3-data2^.param3;
 COLUMN_LENGTH: Result := data1^.param3-data2^.param3;
 COLUMN_RESOLUTION: Result := data1^.param1-data2^.param1;
 COLUMN_FILENAME: Result := CompareText(extractfilename(Data1^.path), extractfilename(Data2^.path));
 COLUMN_MEDIATYPE: Result := CompareText(Data1^.mediatype, Data2^.mediatype);
 COLUMN_FORMAT: Result := comparetext(data1^.vidinfo,data2^.vidinfo);
 COLUMN_FILEDATE: Result := DelphiDateTimeToUnix(data1^.filedate)-DelphiDateTimeToUnix(data2^.filedate);
 COLUMN_FILETYPE: Result := CompareText(lowercase(extractfileext(Data1^.path)), lowercase(extractfileext(Data2^.path)));
end;

end;


procedure Tares_frmmain.filtroGraphComplete(sender: TObject; Result: HRESULT;Renderer: IBaseFilter);
begin
  if helper_player.player_is_playing_image then exit;
  if length(file_visione_da_copiatore)>0 then begin
   pausemedia;
   exit;
  end;

   helper_player.stopmedia(nil);

   trackbar_player.Position := 0;


         mplayerpanel1.TimeCaption := format_time(0)+' / '+
                                    format_time(trackbar_player.max div 1000);


   if not vars_global.closing then playlist_playnext('');
end;


procedure Tares_frmmain.panel_vidMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
punto: TPoint;
 VideoWindow:IVideoWindow;
 pleft,ptop,pwidth,pheight: Integer;
begin
if not isvideoplaying then exit;
if button<>mbright then exit;
if helper_player.m_GraphBuilder=nil then exit;

if not fullscreen2.checked then begin
  If helper_player.m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow)<>S_OK then exit;
  videowindow.GetWindowPosition(pleft,ptop,pwidth,pheight);
   getcursorpos(punto);
 if punto.x<pLeft then exit else
  if punto.x>pleft+pwidth then exit else
   if punto.y<ptop then exit else
    if punto.y>ptop+pheight then exit;
end else getcursorpos(punto);


 popupmenuvideo.popup(punto.x,punto.y);

end;

procedure Tares_frmmain.treeview_downloadCompareNodes(Sender: TBaseCometTree;Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  dataNode1,dataNode2:precord_data_node;
  DnData1,DnData2:precord_displayed_download;
  BtData1,BtData2:precord_displayed_bittorrentTransfer;
  BtSrcData1,BtSrcData2:btcore.precord_Displayed_source;
  DsData1,DsData2:precord_displayed_downloadsource;
  rem1,rem2: Integer;
  pro1,pro2:extended;
  filename1,filename2,str1,str2: string;
  num1,num2: Integer;
  size1,size2,progress1,progress2: Int64;

begin
  DataNode1 := Sender.getdata(Node1);
  DataNode2 := Sender.getdata(Node2);

case column of

  0:begin
    if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         filename1 := extractfilename(DnData1^.filename);
    end else
    if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         filename1 := extractfilename(BtData1^.filename);
    end else
    if dataNode1^.m_type=dnt_downloadSource then begin
       DsData1 := dataNode1^.data;
       filename1 := widestrtoutf8str(DsData1^.nomedisplayw);
    end else
    if dataNode1^.m_type=dnt_bittorrentSource then begin
     btsrcdata1 := dataNode1^.data;
     filename1 := btsrcdata1^.ipS;
    end;

    if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         filename2 := extractfilename(DnData2^.filename);
    end else
    if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         filename2 := extractfilename(BtData2^.filename);
    end else
    if dataNode2^.m_type=dnt_downloadSource then begin
       DsData2 := dataNode2^.data;
       filename2 := widestrtoutf8str(DsData2^.nomedisplayw);
    end else
    if dataNode2^.m_type=dnt_bittorrentSource then begin
     btsrcdata2 := dataNode2^.data;
     filename2 := btsrcdata2^.ipS;
    end;

    Result := CompareText(filename1,filename2);
  end;

  1:begin
    if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         str1 := mediatype_to_str(DnData1^.tipo);
    end else
    if dataNode1^.m_type=dnt_downloadSource then str1 := ''
    else
    if dataNode1^.m_type=dnt_bittorrentMain then str1 := STR_BITTORRENT
    else
    if dataNode1^.m_type=dnt_bittorrentSource then str1 := '';


    if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         str2 := mediatype_to_str(DnData2^.tipo);
    end else
    if dataNode2^.m_type=dnt_downloadSource then str2 := ''
    else
    if dataNode2^.m_type=dnt_bittorrentMain then str2 := STR_BITTORRENT
    else
    if dataNode2^.m_type=dnt_bittorrentSource then str1 := '';
    
     Result := CompareText(str1,str2);
  end;

  2:begin
    if dataNode1^.m_type=dnt_Download then str1 := inttostr(node1.childcount)
    else
    if dataNode1^.m_type=dnt_DownloadSource then begin
         DsData1 := dataNode1^.data;
         str1 := DsData1^.nickname;
    end else
    if dataNode1^.m_type=dnt_bittorrentMain then str1 := inttostr(node1.childCount)+' '+GetLangStringW(STR_USERS)
    else
    if dataNode1^.m_type=dnt_bittorrentSource then begin
     BtSrcData1 := dataNode1^.data;
     str1 := BtSrcData1^.client;
    end;

    if dataNode2^.m_type=dnt_Download then str2 := inttostr(node2.childcount)
    else
    if dataNode2^.m_type=dnt_downloadSource then begin
         DsData2 := dataNode2^.data;
         str2 := DsData2^.nickname;
    end else
    if dataNode2^.m_type=dnt_bittorrentMain then str2 := inttostr(node2.childCount)+' '+GetLangStringW(STR_USERS)
    else
    if dataNode2^.m_type=dnt_bittorrentSource then begin
     BtSrcData2 := dataNode2^.data;
     str2 := BtSrcData2^.client;
    end;
    Result := CompareText(str1,str2);
   end;


  3:begin
     num1 := 0;
     num2 := 0;
     if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         num1 := downloadstate_to_byte(DnData1^.state);
    end else
    if dataNode1^.m_type=dnt_downloadSource then begin
        DsData1 := dataNode1^.data;
        num1 := sourcestate_to_byte(DsData1);
    end else
    if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         num1 := downloadstate_to_byte(BtData1^.state);
    end else
    if dataNode1^.m_type=dnt_bittorrentSource then begin
      BtSrcData1 := dataNode1^.data;
       num1 := BTSourceStatusToByte(BtsrcData1^.status);
    end;
    
    if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         num2 := downloadstate_to_byte(DnData2^.state);
    end else
     if dataNode2^.m_type=dnt_downloadSource then begin
        DsData2 := dataNode2^.data;
        num2 := sourcestate_to_byte(DsData2);
    end else
    if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         num2 := downloadstate_to_byte(BtData2^.state);
    end else
    if dataNode2^.m_type=dnt_bittorrentSource then begin
      BtSrcData2 := dataNode2^.data;
       num2 := BTSourceStatusToByte(BtsrcData2^.status);
    end;

    Result := num1-num2;
    end;


  4:begin
      progress1 := 0;
      progress2 := 0;
      size1 := 0;
      size2 := 0;
      if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         size1 := DnData1^.size;
         progress1 := DnData1^.progress;
      end else
      if dataNode1^.m_type=dnt_downloadSource then begin
         DsData1 := dataNode1^.data;
         size1 := DsData1^.size;
         progress1 := DsData1^.progress;
      end else
      if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         size1 := BtData1^.size;
         progress1 := BtData1^.downloaded;
      end else
      if dataNode1^.m_type=dnt_bittorrentSource then begin
       BtSrcData1 := dataNode1^.data;
       progress1 := btsrcdata1^.progress;
       size1 := progress1;
      end;

      if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         size2 := DnData2^.size;
         progress2 := DnData2^.progress;
      end else
      if dataNode1^.m_type=dnt_downloadSource then begin
         DsData2 := dataNode2^.data;
         size2 := DsData2^.size;
         progress2 := DsData2^.progress;
      end else
      if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         size2 := BtData2^.size;
         progress2 := BtData2^.downloaded;
      end else
      if dataNode2^.m_type=dnt_bittorrentSource then begin
       BtSrcData2 := dataNode2^.data;
       progress2 := btsrcdata2^.progress;
       size2 := progress2;
      end;
        if size1=0 then exit;
        if size2=0 then exit;

         pro1 := progress1;
         pro1 := pro1/size1;
         pro1 := pro1*100;
         pro2 := progress2;
         pro2 := pro2/size2;
         pro2 := pro2*100;
         Result := trunc(pro1-pro2);
  end;


  5:begin
      num1 := 0;
      num2 := 0;
       if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         num1 := DnData1^.velocita;
        end else
        if dataNode1^.m_type=dnt_downloadSource then begin
         DsData1 := dataNode1^.data;
         num1 := DsData1^.speed;
        end else
        if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         num1 := BtData1^.speedDl;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         BtSrcData1 := dataNode1^.data;
         num1 := BtSrcData1^.speedDown;
        end;

       if ((dataNode2^.m_type=dnt_Download) or
           (dataNode2^.m_type=dnt_PartialDownload)) then begin
         DnData2 := dataNode2^.data;
         num2 := DnData2^.velocita;
        end else
        if dataNode2^.m_type=dnt_downloadSource then begin
         DsData2 := dataNode2^.data;
         num2 := DsData2^.speed;
        end else
        if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         num2 := BtData2^.SpeedDl;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
         BtSrcData2 := dataNode2^.data;
         num2 := BtSrcData2^.speedDown;
        end;
     Result := num1-num2;
    end;

  6:begin
      rem1 := 0;
      rem2 := 0;
      progress1 := 0;
      progress2 := 0;
      size1 := 0;
      size2 := 0;
      if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         rem1 := DnData1^.velocita;
         size1 := DnData1^.size;
         progress1 := Dndata1^.progress;
      end else
      if dataNode1^.m_type=dnt_downloadSource then begin
         DsData1 := dataNode1^.data;
         rem1 := DsData1^.speed;
         size1 := DsData1^.size;
         progress1 := Dsdata1^.progress;
      end else
      if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         rem1 := BtData1^.SpeedDl;
         size1 := BtData1^.size;
         progress1 := Btdata1^.downloaded;
      end else
      if dataNode1^.m_type=dnt_bittorrentSource then begin
       BtSrcData1 := dataNode1^.data;
       rem1 := BtSrcdata1^.speedDown;
       size1 := BtSrcdata1^.size;
       progress1 := BtSrcData1^.recv;
      end;

      if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         rem2 := DnData2^.velocita;
         size2 := DnData2^.size;
         progress2 := Dndata2^.progress;
      end else
      if dataNode2^.m_type=dnt_downloadSource then begin
         DsData2 := dataNode2^.data;
         rem2 := DsData2^.speed;
         size2 := DsData2^.size;
         progress2 := Dsdata2^.progress;
      end else
      if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         rem2 := BtData2^.SpeedDl;
         size2 := BtData2^.size;
         progress2 := Btdata2^.downloaded;
      end else
      if dataNode2^.m_type=dnt_bittorrentSource then begin
       BtSrcData2 := dataNode2^.data;
       rem2 := BtSrcdata2^.speedDown;
       size2 := BtSrcdata2^.size;
       progress2 := BtSrcData2^.recv;
      end;
      if rem1=0 then rem1 := $fffffff else rem1 := (size1-progress1) div rem1;
      if rem2=0 then rem2 := $fffffff else rem2 := (size2-progress2) div rem2;
     Result := rem1-rem2;
   end;


   7:begin
      progress1 := 0;
      progress2 := 0;
      if dataNode1^.m_type=dnt_Download then begin
         DnData1 := dataNode1^.data;
         progress1 := DnData1^.progress;
      end else
      if dataNode1^.m_type=dnt_downloadSource then begin
         DsData1 := dataNode1^.data;
         progress1 := DsData1^.progress;
      end else
      if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         progress1 := BtData1^.downloaded;
      end else
      if dataNode1^.m_type=dnt_bittorrentSource then begin
       BtSrcData1 := dataNode1^.data;
       progress1 := BtSrcData1^.recv;
      end;

      if dataNode2^.m_type=dnt_Download then begin
         DnData2 := dataNode2^.data;
         progress2 := DnData2^.progress;
      end else
      if dataNode2^.m_type=dnt_downloadSource then begin
         DsData2 := dataNode2^.data;
         progress2 := DsData2^.progress;
      end else
      if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         progress2 := BtData2^.downloaded;
      end else
      if dataNode2^.m_type=dnt_bittorrentSource then begin
       BtSrcData2 := dataNode2^.data;
       progress2 := BtSrcData2^.recv;
      end;
     Result := progress1-progress2;
     end;
  end;


end;

procedure Tares_frmmain.treeview_uploadCompareNodes(Sender: TBaseCometTree;Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  UpData1,UpData2:precord_displayed_upload;
  DnData1,DnData2:precord_displayed_download;
  BtData1,BtData2:precord_displayed_bittorrentTransfer;
  BtSrcData1,BtSrcData2:btcore.precord_Displayed_source;
  dataNode1,dataNode2:precord_data_node;
  rem1,rem2: Integer;
  pro1,pro2:extended;
  text1,text2: string;
  progress1,size1,continued1,progress2,size2,continued2: Int64;
  num1,num2: Integer;
begin
  DataNode1 := Sender.getdata(Node1);
  DataNode2 := Sender.getdata(Node2);

  case column of

   0:begin
        if dataNode1^.m_type=dnt_bittorrentMain then begin
          BtData1 := dataNode1^.data;
          text1 := BtData1^.FileName;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         BtSrcData1 := dataNode1^.data;
         text1 := BtsrcData1^.ipS;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          text1 := extractfilename(UpData1^.nomefile);
        end;{ else begin
          DnData1 := dataNode1^.data;
          text1 := widestrtoutf8str(dndata1^.nomedisplayw);
        end; }
        if dataNode2^.m_type=dnt_bittorrentMain then begin
          BtData2 := dataNode2^.data;
          text2 := BtData2^.FileName;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
         BtSrcData2 := dataNode2^.data;
         text2 := BtsrcData2^.ipS;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          text2 := extractfilename(UpData2^.nomefile);
        end;{ else begin
          DnData2 := dataNode2^.data;
          text2 := widestrtoutf8str(dndata2^.nomedisplayw);
        end; }
        Result := CompareText(text1,text2);
   end;

   1:begin
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         text1 := '';
        end else
        if dataNode1^.m_type=dnt_bitTorrentMain then begin
         text1 := STR_BITTORRENT;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          text1 := mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(UpData1^.nomefile))));
        end;{ else begin
          DnData1 := dataNode1^.data;
          text1 := mediatype_to_str(DnData1^.tipo);
        end; }

        if dataNode2^.m_type=dnt_bittorrentSource then begin
         text2 := '';
        end else
        if dataNode2^.m_type=dnt_bitTorrentMain then begin
         text2 := STR_BITTORRENT;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          text2 := mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(UpData2^.nomefile))));
        end;{ else begin
          DnData2 := dataNode2^.data;
          text2 := mediatype_to_str(DnData2^.tipo);
        end; }
        Result := CompareText(text1,text2);
   end;

   2:begin
        if dataNode1^.m_type=dnt_bittorrentSource then begin
          btSrcData1 := dataNode1^.data;
          text1 := btsrcData1^.client;
        end else
        if dataNode1^.m_type=dnt_bittorrentMain then begin
          Text1 := inttostr(node1.ChildCount)+' '+GetLangStringW(STR_USERS);
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          text1 := UpData1^.nickname;
        end;{ else begin
          DnData1 := dataNode1^.data;
          text1 := widestrtoutf8str(DnData1^.nicknamew);
        end; }

        if dataNode2^.m_type=dnt_bittorrentSource then begin
          btSrcData2 := dataNode2^.data;
          text2 := btsrcData2^.client;
        end else
        if dataNode2^.m_type=dnt_bittorrentMain then begin
         Text2 := inttostr(node2.ChildCount)+' '+GetLangStringW(STR_USERS);
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          text2 := UpData2^.nickname;
        end;{ else begin
          DnData2 := dataNode2^.data;
          text2 := widestrtoutf8str(DnData2^.nicknamew);
        end;}
        Result := CompareText(text1,text2);
   end;
   

   3:begin
        if dataNode1^.m_type=dnt_bittorrentMain then begin
         BtData1 := dataNode1^.data;
         num1 := downloadstate_to_byte(BtData1^.state);
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         BtSrcData1 := dataNode1^.data;
         num1 := BTSourceStatusToByte(BtsrcData1^.status);
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          if UpData1^.completed then begin
            if Updata1^.progress=Updata1^.size then num1 := 0
             else num1 := 1;
          end else num1 := 2;
        end else num1 := 2;

        if dataNode2^.m_type=dnt_bittorrentMain then begin
         BtData2 := dataNode2^.data;
         num2 := downloadstate_to_byte(BtData2^.state);
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
         BtSrcData2 := dataNode2^.data;
         num2 := BTSourceStatusToByte(BtsrcData2^.status);
        end else
         if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          if UpData2^.completed then begin
            if Updata2^.progress=Updata2^.size then num2 := 0
             else num2 := 1;
          end else num2 := 2;
        end else num2 := 2;
        Result := num1-num2;
   end;


   4:begin
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        continued1 := 0;
        continued2 := 0;
        if dataNode1^.m_type=dnt_bittorrentMain then begin
          btData1 := dataNode1^.data;
          progress1 := BtData1^.uploaded;
          size1 := BtData1^.downloaded;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
          btsrcData1 := dataNode1^.data;
          progress1 := BtsrcData1^.sent;
          size1 := BtsrcData1^.recv;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          progress1 := UpData1^.progress;
          size1 := UpData1^.size;
          continued1 := UpData1^.continued_from;
        end;{ else begin
          DnData1 := dataNode1^.data;
          progress1 := DnData1^.progress;
          size1 := DnData1^.size;
          continued1 := 0;
        end;}

         if dataNode2^.m_type=dnt_bittorrentMain then begin
          btData2 := dataNode2^.data;
          progress2 := BtData2^.uploaded;
          size2 := BtData2^.downloaded;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
          btsrcData2 := dataNode2^.data;
          progress2 := BtsrcData2^.sent;
          size2 := BtsrcData2^.recv;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          progress2 := UpData2^.progress;
          size2 := UpData2^.size;
          continued2 := UpData2^.continued_from;
        end;{ else begin
          DnData2 := dataNode2^.data;
          progress2 := DnData2^.progress;
          size2 := DnData2^.size;
          continued2 := 0;
        end; }
        if size1=0 then exit;
        if size2=0 then exit;
         pro1 := progress1+continued1;
         pro1 := pro1/size1+continued1;
         pro1 := pro1*100;
         pro2 := progress2+continued2;
         pro2 := pro2/size2+continued2;
         pro2 := pro2*100;
         Result := trunc(pro1-pro2);
   end;

   5:begin
        num1 := 0;
        num2 := 0;
        if dataNode1^.m_type=dnt_bittorrentMain then begin
          btData1 := dataNode1^.data;
          num1 := btdata1^.speedUl;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
          btSrcData1 := dataNode1^.data;
          num1 := btsrcData1^.speedUp;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          num1 := UpData1^.velocita;
        end;{ else begin
          DnData1 := dataNode1^.data;
          num1 := DnData1^.velocita;
        end;}
        if dataNode2^.m_type=dnt_bittorrentMain then begin
          btData2 := dataNode2^.data;
          num2 := btdata2^.speedUl;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
          btSrcData2 := dataNode2^.data;
          num2 := btsrcData2^.speedUP;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          num2 := UpData2^.velocita;
        end;{ else begin
          DnData2 := dataNode2^.data;
          num2 := DnData2^.velocita;
        end;}
        Result := num1-num2;
   end;

   6:begin
        rem1 := 0;
        rem2 := 0;
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        if dataNode1^.m_type=dnt_bittorrentMain then begin
          rem1 := 0;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         rem1 := 0;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          rem1 := UpData1^.velocita;
          size1 := Updata1^.size;
          progress1 := UpData1^.progress;
        end;{else begin
          DnData1 := dataNode1^.data;
          rem1 := DnData1^.velocita;
          size1 := DnData1^.size;
          progress1 := DnData1^.progress;
        end; }
        if dataNode2^.m_type=dnt_bittorrentMain then begin
          rem2 := 0;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
         rem2 := 0;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          rem2 := UpData2^.velocita;
          size2 := Updata2^.size;
          progress2 := UpData2^.progress;
        end;{ else begin
          DnData2 := dataNode2^.data;
          rem2 := DnData2^.velocita;
          size2 := DnData2^.size;
          progress2 := DnData2^.progress;
        end; }
        if rem1=0 then rem1 := $fffffff else rem1 := (size1-progress1) div rem1;
        if rem2=0 then rem2 := $fffffff else rem2 := (size2-progress2) div rem2;
        Result := rem1-rem2;
   end;

   7:begin
        continued1 := 0;
        continued2 := 0;
        progress1 := 0;
        progress2 := 0;
        if dataNode1^.m_type=dnt_bittorrentMain then begin
         btData1 := dataNode1^.data;
         progress1 := btData1^.uploaded;
         continued1 := 0;
        end else
        if dataNode1^.m_type=dnt_bittorrentSource then begin
         btsrcdata1 := dataNode1^.data;
         progress1 := btsrcdata1^.sent;
         continued1 := 0;
        end else
        if dataNode1^.m_type=dnt_upload then begin
          UpData1 := dataNode1^.data;
          progress1 := UpData1^.progress;
          continued1 := UpData1^.continued_from;
        end;{ else begin
          DnData1 := dataNode1^.data;
          progress1 := DnData1^.progress;
          continued1 := 0;
        end; }
        if dataNode2^.m_type=dnt_bittorrentMain then begin
         btData2 := dataNode2^.data;
         progress2 := btData2^.uploaded;
         continued2 := 0;
        end else
        if dataNode2^.m_type=dnt_bittorrentSource then begin
         btsrcdata2 := dataNode2^.data;
         progress2 := btsrcdata2^.sent;
         continued2 := 0;
        end else
        if dataNode2^.m_type=dnt_upload then begin
          UpData2 := dataNode2^.data;
          progress2 := UpData2^.progress;
          continued2 := UpData2^.continued_from;
        end;{ else begin
          DnData2 := dataNode2^.data;
          progress2 := DnData2^.progress;
          continued2 := 0;
        end; }
        Result := (progress1+continued1)-(progress2+continued2);
   end;

 end;


end;

procedure Tares_frmmain.listview_chat_channelCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode;Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: precord_displayed_channel;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  case column of
    0: Result := CompareText(Data1.name, Data2.name);
    1: Result := CompareText(data1.language,data2.language);
    3: Result := CompareText(widestrtoutf8str(Data1.stripped_topic), widestrtoutf8str(Data2.stripped_topic));
    2: Result := data1.status - data2.status;
   end;
end;

procedure Tares_frmmain.panel_playlistResize(Sender: TObject);
begin
btn_playlist_close.left := panel_playlist.width-btn_playlist_close.width-2;
listview_playlist.Height := panel_playlist.Height-20;
listview_playlist.Width := panel_playlist.width-1;
end;

procedure Tares_frmmain.combo_lang_searchClick(Sender: TObject);
var
combo: Ttntcombobox;
begin
if not (sender is ttntcombobox) then exit;
btn_stop_searchClick(nil);
combo := (sender as ttntcombobox);

with combo do begin

if itemindex=0 then begin
  if widestrtoutf8str(text)=GetLangStringA(PURGE_SEARCH_STR) then begin
   if not clear_search_history then begin
    itemindex := -1;
    text := '';
   end;
  end;
end;

end;
end;



procedure Tares_frmmain.treeview_lib_virfoldersCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
data1,data2:ares_types.precord_string;
begin
data1 := sender.getdata(node1);
data2 := sender.getdata(node2);
 Result := comparetext(data1^.str,data2^.str);
end;

procedure Tares_frmmain.combotitsearchKeyPress(Sender: TObject; var Key: Char);
var
time1: Cardinal;
begin
case integer(key) of
 13:begin
   key := char(vk_cancel);
   if Btn_start_search.enabled then Btn_start_searchclick(nil) else begin
    btn_stop_searchclick(nil);
     time1 := gettickcount;
     while gettickcount-time1<250 do application.processmessages;
    Btn_start_searchclick(nil);
   end;
 end else begin
  if btn_stop_search.enabled then btn_stop_searchclick(nil);
 end;
end;
end;

procedure Tares_frmmain.edit_titleKeyPress(Sender: TObject; var Key: Char);
begin
if integer(key)=13 then key := char(VK_CANCEL);
end;

procedure Tares_frmmain.treeview_lib_virfoldersMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
level: Integer;
punto: TPoint;
 nodoroot,nodoall,nodoaudio,nodoimage,nodovideo:PCmtVNode;
begin
with treeview_lib_virfolders do begin

if rootnodecount=0 then exit;
if button<>mbright then exit;

 nodo := getfirstselected;
 if nodo=nil then exit;

 level := getnodelevel(nodo);
 if level<>3 then exit;

 nodoroot := GetFirst;
 nodoall := getfirstchild(nodoroot);

 nodoaudio := GetNextSibling(nodoall);
 nodoimage := getnextsibling(nodoaudio);
 nodovideo := getnextsibling(nodoimage);
end;


 if nodo.parent.parent<>nodoaudio then
   if nodo.parent.parent<>nodovideo then exit;

 getcursorpos(punto);
 popup_lib_virfolders.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.AddtoPlaylist4Click(Sender: TObject);
var
nodo:PCmtVNode;
level: Integer;
 nodoroot,nodoall,nodoaudio,nodoimage,nodovideo:PCmtVNode;
    nodoaudiobyartist,nodoaudiobyalbum,nodoaudiobygenre:PCmtVNode;
    nodovideobycategory:PCmtVNode;

    pfile:precord_file_library;
    data:ares_types.precord_string;
    match,match1,match2,match3: string;
    i: Integer;
    tipo: Byte;
begin
with treeview_lib_virfolders do begin

if rootnodecount=0 then exit;

 nodo := getfirstselected;
 if nodo=nil then exit;

 level := getnodelevel(nodo);
 if level<>3 then exit;

 nodoroot := GetFirst;
 nodoall := getfirstchild(nodoroot);

nodoaudio := GetNextSibling(nodoall);
   nodoaudiobyartist := getfirstchild(nodoaudio);
   nodoaudiobyalbum := getnextsibling(nodoaudiobyartist);
   nodoaudiobygenre := getnextsibling(nodoaudiobyalbum);
 nodoimage := getnextsibling(nodoaudio);
 nodovideo := getnextsibling(nodoimage);
   nodovideobycategory := getfirstchild(nodovideo);

end;


 if nodo.parent.parent<>nodoaudio then
   if nodo.parent.parent<>nodovideo then exit;

 if nodo.parent.parent=nodoaudio then tipo := ARES_MIME_MP3 else
 if nodo.parent.parent=nodovideo then tipo := ARES_MIME_VIDEO else exit;

 data := treeview_lib_virfolders.getdata(nodo);
 match := lowercase(data^.str);
 if match=GetLangStringA(STR_UNKNOW_LOWER) then match := '';

 for i := 0 to lista_shared.count-1 do begin
  pfile := lista_shared[i];
  if pfile^.amime<>tipo then continue;

        if ((nodo.parent.parent<>nodovideo) and (nodo.parent.parent<>nodoimage)) then begin
          match1 := lowercase(pfile^.artist);
          match2 := lowercase(pfile^.category);
        if nodo.parent.parent=nodoaudio then match3 := lowercase(pfile^.album);
        end else
        if nodo.parent.parent=nodovideo then begin
          match1 := lowercase(pfile^.category);
        end else
        if nodo.parent.parent=nodoimage then begin
          match1 := lowercase(pfile^.album);
          match2 := lowercase(pfile^.category);
        end;

        if match1=GetLangStringA(STR_UNKNOW_LOWER) then match1 := '';
        if match2=GetLangStringA(STR_UNKNOW_LOWER) then match2 := '';
        if match3=GetLangStringA(STR_UNKNOW_LOWER) then match3 := '';

   case tipo of
    ARES_MIME_MP3:begin
        if nodo.parent=nodoaudiobyartist then begin
          if match1=match then playlist_addfile(pfile^.path,pfile^.param3,false,'');
        end else
        if nodo.parent=nodoaudiobyalbum then begin
          if match3=match then playlist_addfile(pfile^.path,pfile^.param3,false,'');
        end else
        if nodo.parent=nodoaudiobygenre then begin
          if match2=match then playlist_addfile(pfile^.path,pfile^.param3,false,'');
        end;
      end;
    ARES_MIME_VIDEO:begin
        if nodo.parent=nodovideobycategory then begin
          if match1=match then playlist_addfile(pfile^.path,pfile^.param3,false,'');
        end;
      end;
   end;
 end;

end;

procedure Tares_frmmain.listview_chat_channelAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode;Column: TColumnIndex; CellRect: TRect);
var
  data:precord_displayed_channel;
  widestr: WideString;
  cellrec: TRect;
  forecolor,backcolor,forecolor_gen,backcolor_gen: Tcolor;
  bitmap_stars:graphics.TBitmap;
  num:double;
begin


data := sender.getdata(node);


try

if column=2 then begin
 num := chat_status_toImgindex(data^.status);

 bitmap_stars := graphics.TBitmap.create;
 with bitmap_stars do begin
  pixelformat := pf24bit;
 if (node=sender.HotNode) and (not (vsSelected in node.states)) then Canvas.Brush.color := (sender as tcomettree).Colors.HotColor else
  if (vsSelected in node.States) then Canvas.brush.color := clhighlight else
   if (node.Index mod 2)=0 then Canvas.brush.color := sender.BGColor else
   canvas.brush.color := (sender as tcomettree).color;

  canvas.fillrect(rect(0,0,width,height));

  imglist_stars.GetBitmap(round(num*3),bitmap_stars);

  width := round(48*num);
  transparentcolor := clfuchsia;
  transparent := True;
  TargetCanvas.draw(cellrect.Left+3,cellrect.Top+2,bitmap_stars);
  free;
end;
end;


if column<>3 then exit;
if not data^.has_colors_intopic then exit;

widestr := utf8strtowidestr(data^.topic);

with cellrec do begin
 left := cellrect.left;
 top := cellrect.top+1;
 bottom := cellrect.bottom;
 right := cellrect.right;
end;

if (vsSelected in Node.States) then begin
  backcolor_gen := clHighLight;
  forecolor_gen := $00FEFFFF;
  backcolor := clHighLight;
  forecolor := $00FEFFFF;
end else begin
 forecolor_gen := clblack;
 forecolor := clblack;
 if (node.Index mod 2)=0 then backcolor_gen := sender.BGColor else backcolor_gen := $00FEFFFF;
 backcolor := backcolor_gen;
end;


 //widestr := ipint_to_dotstring(data^.ip)+':'+inttostr(data^.port)+' '+widestr;
 canvas_draw_topic(Targetcanvas,CellRec,imglist_emotic,widestr,forecolor,backcolor,forecolor_gen,backcolor_gen,8);

except
end;
end;

procedure tares_frmmain.pvt_unhide(sender: Tobject);
begin
(sender as ttnttabsheet).imageindex := 11;
end;

procedure Tares_frmmain.edit_chat_chanfilterKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
mainGui_trigger_channelfilter;
end;

procedure Tares_frmmain.combo_chat_searchClick(Sender: TObject);
var
combo: Ttntcombobox;
begin
combo := (sender as ttntcombobox);

with combo do begin

if itemindex=0 then begin
  if widestrtoutf8str(text)=GetLangStringA(PURGE_SEARCH_STR) then begin
   if not clear_search_history then begin
     itemindex := -1;
     text := '';
   end;
  end;
end;

end;
end;

procedure Tares_frmmain.treeviewbrowseCompareNodes(Sender: TBaseCometTree; Node1,Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
data1,data2:ares_types.precord_string;
begin
data1 := sender.getdata(node1);
data2 := sender.getdata(node2);
 Result := comparetext(data1^.str,data2^.str);
end;

procedure Tares_frmmain.treeviewbrowseFreeNode(Sender: TBaseCometTree;Node: PCmtVNode);
begin
finalize_virtualbrowse_entry(sender,node);
end;

procedure Tares_frmmain.treeviewbrowseGetText(Sender: TBaseCometTree;Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data:ares_types.precord_string;
begin
Data := sender.getdata(Node);
 if data^.counter=0 then CellText := utf8strtowidestr(data^.str) else
 CellText := utf8strtowidestr(data^.str)+chr(32)+chr(40){' ('}+
       inttostr(data^.counter)+chr(41){')'};
end;

procedure Tares_frmmain.treeviewbrowseGetImageIndex(Sender: TBaseCometTree;Node: PCmtVNode; var ImageIndex: Integer);
begin
if not (vsSelected in node.states) then ImageIndex := 0
 else ImageIndex := 1;
end;

procedure Tares_frmmain.treeviewbrowseGetSize(Sender: TBaseCometTree;var Size: Integer);
begin
size := sizeof(ares_types.record_string);
end;

procedure Tares_frmmain.listview_chat_channelCollapsed(Sender: TBaseCometTree; Node: PCmtVNode);
begin
sender.invalidate;
end;

procedure Tares_frmmain.listview_libPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
data:precord_file_library;

begin
data := sender.getdata(node);
if (vsselected in node.states) then targetcanvas.font.color := clhighlighttext else begin
  if data^.previewing then targetcanvas.font.color := COLORE_LISTVIEWS_FONTALT1
   else targetcanvas.Font.color := COLORE_LISTVIEWS_FONT;
end;
end;

procedure Tares_frmmain.GrantSlot1Click(Sender: TObject);
var
node:PCmtVNode;
data:precord_queued;
begin
try

node := treeview_queue.getfirstselected;
if node=nil then exit;
data := treeview_queue.getdata(node);

ip_user_granted := data^.ip;
port_user_granted := data^.port;
ip_alt_granted := data^.ip_alt;

except
end;
end;

procedure Tares_frmmain.treeview_downloadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
punto: TPoint;
hitinfo:comettrees.thitinfo;
hnd:hwnd;
begin
if (sender as tcomettree).rootnodecount=0 then begin
 formhint_hide;
 exit;
end;

getcursorpos(punto);
 punto := (sender as tcomettree).screentoclient(punto);

 (sender as tcomettree).GetHitTestInfoAt(punto.x,punto.y,true,hitinfo);

 if hitinfo.hitnode=nil then begin
  formhint_hide;
  exit;
 end;

 if not (hiOnItemLabel in HitInfo.HitPositions) then begin
  formhint_hide;
  exit;
 end;

   hnd := GetForegroundWindow;
  if hnd<>self.handle then
   if hnd<>formhint.handle then begin
    formhint_hide;
   exit;
  end;

end;

procedure Tares_frmmain.treeview_lib_regfoldersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:PCmtVNode;
level: Integer;
punto: TPoint;
data:ares_types.precord_cartella_share;
begin
if treeview_lib_regfolders.rootnodecount=0 then exit;
if button<>mbright then exit;

 nodo := treeview_lib_regfolders.getfirstselected;
 if nodo=nil then exit;

 level := treeview_lib_regfolders.getnodelevel(nodo);
 if level=0 then exit;
 data := treeview_lib_regfolders.getdata(nodo);
 AddtoPlaylist5.visible := (data^.items>0);

 getcursorpos(punto);
 popup_lib_regfolders.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.AddtoPlaylist5Click(Sender: TObject);
var
nodo:PCmtVNode;
level: Integer;
    pfile:precord_file_library;
    data:ares_types.precord_cartella_share;
    i: Integer;
begin
if treeview_lib_regfolders.rootnodecount=0 then exit;

 nodo := treeview_lib_regfolders.getfirstselected;
 if nodo=nil then exit;

 level := treeview_lib_regfolders.getnodelevel(nodo);
 if level=0 then exit;

  data := treeview_lib_regfolders.getdata(nodo);
  if data^.items=0 then exit;


 for i := 0 to lista_shared.count-1 do begin
  pfile := lista_shared[i];
  if pfile^.folder_id<>data^.id then continue;
    if pfile^.amime<>ARES_MIME_MP3 then
     if pfile^.amime<>ARES_MIME_VIDEO then continue;
   playlist_addfile(pfile^.path,pfile^.param3,false,'');
 end;

end;

procedure tares_frmmain.WMUserShow(var msg: Tmessage);
begin
if widestrtoutf8str(tray_minimize.caption)=GetLangStringA(STR_HIDE_ARES) then exit;
tray_MinimizeClick(nil);
end;

procedure Tares_frmmain.btn_lib_regular_viewClick(Sender: TObject);
var
nodo:PCmtVNode;
begin
btn_lib_regular_view.down := True;
btn_lib_virtual_view.Down := False;

  treeview_lib_regfolders.visible := True;
  treeview_lib_virfolders.visible := False;

  listview_lib.clear;
  details_library_toggle(false);
   if treeview_lib_regfolders.getfirstselected=nil then begin
    nodo := treeview_lib_regfolders.GetFirst;
    treeview_lib_regfolders.selected[nodo] := True;
    treeview_lib_regfoldersClick(treeview_lib_regfolders);
   end else treeview_lib_regfoldersClick(treeview_lib_regfolders);


   set_reginteger('General.LastLibraryMode',1);
end;

procedure Tares_frmmain.OpenFolder1Click(Sender: TObject);
var
 nodo:PCmtVNode;
 level: Integer;
 data:ares_types.precord_cartella_share;
begin
if treeview_lib_regfolders.rootnodecount=0 then exit;

 nodo := treeview_lib_regfolders.getfirstselected;
 if nodo=nil then exit;

 level := treeview_lib_regfolders.getnodelevel(nodo);
 if level=0 then exit;
  data := treeview_lib_regfolders.getdata(nodo);
   open_file_external(data^.path+chr(92){'\'});
end;

procedure Tares_frmmain.treeview_downloadDblClick(Sender: TObject);
var
punto: TPoint;
begin
getcursorpos(punto);
punto := treeview_download.screentoclient(punto);
if punto.x<30 then exit;
OpenPreview1Click(nil);
end;

procedure Tares_frmmain.panel_searchDrawHeaderBody(sender: TObject; TargetCanvas: TCanvas; aRect: TRect; HeaderColor: TColor);
//var
//Details: TThemedElementDetails;
begin
{ if ((ThemeServices.ThemesEnabled) and (VARS_THEMED_PANELS)) then begin
  Details := ThemeServices.GetElementDetails(thHeaderItemNormal);
  ThemeServices.DrawElement(TargetCanvas.Handle, Details, aRect, @aRect);
 end else begin }
  with targetcanvas do begin
   if sender=panel_playlist then begin
    brush.Color := cl3ddkshadow;
    fillrect(rect(arect.left,arect.top,arect.right,arect.top+1));
    fillrect(rect(arect.Left,arect.top,arect.left+1,arect.bottom));
   end;
  end;
// end;
end;

procedure Tares_frmmain.label_back_srcMouseEnter(Sender: TObject);
var
labels: Ttntlabel;
begin
labels := sender as ttntlabel;
labels.Font.color := clhotlight;
end;

procedure Tares_frmmain.label_back_srcMouseLeave(Sender: TObject);
var
labels: Ttntlabel;
begin
labels := sender as ttntlabel;
labels.Font.color := clWindowText;
end;

procedure Tares_frmmain.panel_details_libraryAfterDraw(Sender: TObject; TargetCanvas: TCanvas);
begin
ImageList_lib_max.draw(targetcanvas,12,32,last_index_icona_details_library);
end;

procedure Tares_frmmain.panel_searchDraw(sender: TObject; Acanvas: TCanvas; capt: WideString; var should_continue:boolean);
//var
//Details: TThemedElementDetails;
//rec: TRect;
begin

 //if ((not ThemeServices.ThemesEnabled) or (not VARS_THEMED_BIGPANELS)) then begin
   if image_back_top<>-1 then imagelist_panel_search.draw(acanvas,12,image_back_top,1);
   if image_less_top<>-1 then imagelist_panel_search.draw(acanvas,12,image_less_top,0);
   if image_more_top<>-1 then imagelist_panel_search.draw(acanvas,12,image_more_top,2);
   should_continue := False;
{ end else begin
  if image_back_top<>-1 then begin
        with rec do begin
         left := 12;
         right := 31;
         top := image_back_top;
         bottom := top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupCollapseNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
  if image_less_top<>-1 then begin
        with rec do begin
         left := 12;
         right := 31;
         top := image_less_top;
         bottom := top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupCollapseNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
  if image_more_top<>-1 then begin
        with rec do begin
         left := 12;
         right := 31;
         top := image_more_top;
         bottom :=  top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupExpandNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
 end;}
end;

procedure Tares_frmmain.panel_searchMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

 if ((y<0) or (x>31) or (x<12)) then begin
  panel_search.cursor := crdefault;
  label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
  label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
  exit;
 end;

  if ((image_back_top=-1) and 
     (image_less_top=-1) and
     (image_more_top=-1)) then begin
      panel_search.cursor := crdefault;
      label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
      label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
      exit;
     end;

 if ((x>=12) and (x<=31) and (y>=image_back_top) and (y<=image_back_top+19)) then begin
                                                                                 panel_search.cursor := crhandpoint;
                                                                                 label_back_src.Font.color := clhotlight;
                                                                                 label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
                                                                                 end else
 if ((x>=12) and (x<=31) and (y>=image_less_top) and (y<=image_less_top+19)) then begin
                                                                                  panel_search.cursor := crhandpoint;
                                                                                  label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
                                                                                  label_more_searchopt.Font.color := clhotlight;
                                                                                  end else
 if ((x>=12) and (x<=31) and (y>=image_more_top) and (y<=image_more_top+19)) then begin
                                                                                    panel_search.cursor := crhandpoint;
                                                                                    label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
                                                                                    label_more_searchopt.Font.color := clhotlight;
                                                                                    end else begin
                                                                                    panel_search.cursor := crdefault;
                                                                                    label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
                                                                                    label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
                                                                                    end;

end;

procedure Tares_frmmain.panel_searchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if image_back_top<>-1 then begin
 if ((x>=12) and (x<=31) and (y>=image_back_top) and (y<=image_back_top+19)) then label_back_srcClick(label_back_src);
end;

if image_less_top<>-1 then begin
 if ((x>=12) and (x<=31) and (y>=image_less_top) and (y<=image_less_top+19)) then label_more_searchoptClick(label_more_searchopt);
end;

if image_more_top<>-1 then begin
 if ((x>=12) and (x<=31) and (y>=image_more_top) and (y<=image_more_top+19)) then label_more_searchoptClick(label_more_searchopt);
end;
end;

procedure Tares_frmmain.ExportHashlink4Click(Sender: TObject);
begin
mainGui_exporthashlink_fromresult;
end;

procedure Tares_frmmain.treeview_lib_regfoldersExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
ares_FrmMain.treeview_lib_regfolders.sort(node,0,sdAscending);
end;

procedure Tares_frmmain.Disconnect1Click(Sender: TObject);
var
reg: Tregistry;
begin
if btn_opt_disconnect.down then exit;

 reg := tregistry.create; //when user is messin with this we may want to reset some antiflood countermeasures
 with reg do begin
  openkey(areskey,true);
  writeinteger('Stats.LstCaQueryInt',MIN_INTERVAL_QUERY_CACHE_ROOT); //minimum amount of time between queries
  writeinteger('Stats.LstCaQuery',0); //reset antiflood on gwebcache
  closekey;
  destroy;
 end;


btn_opt_disconnect.down := True;
btn_opt_connect.Down := False;
logon_time := 0;
lbl_opt_statusconn.caption := ' '+GetLangStringW(STR_NOT_CONNECTED);

end;

procedure Tares_frmmain.Connect1Click(Sender: TObject);
begin
if btn_opt_connect.down then exit;

btn_opt_connect.down := True;
btn_opt_disconnect.Down := False;
logon_time := 0;
lbl_opt_statusconn.caption := ' '+GetLangStringW(STR_CONNECTING_TO_NETWORK);
end;



procedure Tares_frmmain.trackbar_playerChange(Sender: TObject);
var
 currentPosition,Duration: Int64;
 MediaSeeking:IMediaSeeking;
 hr:HResult;
begin
if unetPlayer.NETPlayer<>nil then begin
 unetPlayer.NETPlayer.SetVariable('SeekCommand',inttostr(trackbar_player.Position));
 exit;
end else
if uflvplayer.FLVPlayer<>nil then begin
//currTime := currTime+20000;
 uflvplayer.FLVPlayer.SetVariable('SeekCommand',inttostr(trackbar_player.Position));
 exit;
end;

if helper_player.m_GraphBuilder=nil then exit;

 hr := helper_player.m_GraphBuilder.QueryInterface(IMediaSeeking, MediaSeeking);
 if FAILED(hr) then exit;

 //hr := MediaSeeking.GetDuration(Duration);
 //if FAILED(hr) then exit;

  CurrentPosition := MiliSecToRefTime(trackbar_player.Position);
  Duration := MiliSecToRefTime(trackbar_player.Max);

  hr := MediaSeeking.SetPositions(CurrentPosition,AM_SEEKING_AbsolutePositioning,Duration,AM_SEEKING_NoPositioning);
  if FAILED(hr) then exit;

  trackbar_playerTimer(trackbar_player,trackbar_player.Position,trackbar_player.max);

end;

procedure Tares_frmmain.WMQueryEndSession(var Message: TWMQUERYENDSESSION);
begin
  ending_session := True;
  application.onmessage := nil;
   message.Result := 1;
end;


procedure Tares_frmmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose := ((ending_session) or (vars_global.closing));
if not canclose then postmessage(self.handle,wm_SYSCOMMAND,sc_close,0);
end;

procedure Tares_frmmain.Addtoplaylist3Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
begin
node := treeview_upload.GetFirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);
if dataNode^.m_type<>dnt_upload then exit;

UpData := dataNode^.data;
playlist_addfile(UpData^.nomefile,-1,false,'');
end;

procedure Tares_frmmain.listview_chat_channelResize(Sender: TObject);
begin
with (sender as tcomettree){ares_frmmain.listview_chat_channel} do begin
  if Selectable then begin
     if Header.Columns.Items[3].width<clientwidth-(Header.Columns.Items[2].width+Header.Columns.Items[1].width+Header.Columns.Items[0].width) then
      Header.Columns.Items[3].width := clientwidth-(Header.Columns.Items[2].width+Header.Columns.Items[1].width+Header.Columns.Items[0].width);
  end else begin
    with header.columns do begin
     Items[0].width := clientwidth;
     Items[1].width := 0;
     Items[2].width := 0;
     Items[3].width := 0;
    end;
  end;
end;
end;



procedure Tares_frmmain.Saveas1Click(Sender: TObject);
begin
export_channellist;
end;

procedure Tares_frmmain.Exporthashlink5Click(Sender: TObject);
begin
export_channel_hashlink;
end;

procedure Tares_frmmain.Locate3Click(Sender: TObject);
begin
if player_actualfile='' then exit;
if not fileexistsW(player_actualfile) then exit;
locate_containing_folder(widestrtoutf8str(player_actualfile));
end;

procedure Tares_frmmain.OpenExternal3Click(Sender: TObject);
begin
if player_actualfile='' then exit;
if not fileexistsW(player_actualfile) then exit;
open_file_external(widestrtoutf8str(player_actualfile));
end;

procedure Tares_frmmain.addtoplaylist6Click(Sender: TObject);
begin
if player_actualfile='' then exit;
if not fileexistsW(player_actualfile) then exit;
playlist_addfile(widestrtoutf8str(player_actualfile),-1,false,'');
end;

procedure Tares_frmmain.Grantslot2Click(Sender: TObject);
var
node:PCmtVNode;
dataNode:precord_data_node;
UpData:precord_displayed_upload;
begin
try
node := treeview_upload.getfirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);
if dataNode^.m_type<>dnt_upload then exit;

UpData := dataNode^.data;
ip_user_granted := UpData^.ip;
port_user_granted := UpData^.port;
ip_alt_granted := UpData^.ip_alt;

except
end;
end;



procedure Tares_frmmain.btn_chat_favClick(Sender: TObject);
begin
try

btn_chat_fav.down := not btn_chat_fav.down;

if not btn_chat_fav.down then reg_save_chatfav_height
 else showChatFavorites;

panel_chatResize(panel_chat);


except
end;
end;

procedure Tares_frmmain.treeview_chat_favoritesAfterCellPaint(
  Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode;
  Column: TColumnIndex; CellRect: TRect);
var
  data:precord_chat_favorite;
  widestr: WideString;
  cellrec: TRect;
  forecolor,backcolor,forecolor_gen,backcolor_gen: Tcolor;
begin
if column<>2 then exit;

data := sender.getdata(node);
if not data^.has_colors_intopic then exit;

try

widestr := utf8strtowidestr(data^.topic);

with cellrec do begin
 left := cellrect.left;
 top := cellrect.top+1;
 bottom := cellrect.bottom;
 right := cellrect.right;
end;

if (vsSelected in Node.States) then begin
  backcolor_gen := clHighLight;
  forecolor_gen := $00FEFFFF;
  backcolor := clHighLight;
  forecolor := $00FEFFFF;
end else begin
 forecolor_gen := clblack;
 forecolor := clblack;
 if (node.Index mod 2)=0 then backcolor_gen := sender.BGColor else backcolor_gen := $00FEFFFF;
 backcolor := backcolor_gen;
end;

 canvas_draw_topic(Targetcanvas,CellRec,imglist_emotic,widestr,forecolor,backcolor,forecolor_gen,backcolor_gen,8);

except
end;
end;

procedure Tares_frmmain.treeview_chat_favoritesFreeNode(
  Sender: TBaseCometTree; Node: PCmtVNode);
begin
finalize_chatfavorite(sender,node);
end;

procedure Tares_frmmain.treeview_chat_favoritesGetSize(
  Sender: TBaseCometTree; var Size: Integer);
begin
Size := SizeOf(record_chat_favorite);
end;

procedure Tares_frmmain.treeview_chat_favoritesGetText(
  Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex;
  var CellText: WideString);
var
  Data:precord_chat_favorite;
begin
    Data := sender.getdata(Node);

  if not sender.selectable then begin
   if column=0 then celltext := utf8strtowidestr(data^.name);
   exit;
  end;
case column of
0:celltext := utf8strtowidestr(data^.name);
1:celltext := formatdatetime('yyyy/mm/dd hh:nn:ss',UnixToDelphiDateTime(data^.last_joined));
2:begin
   if data^.has_colors_intopic then begin
    celltext := data^.stripped_topic;
   end else
   celltext := data^.stripped_topic;
  end else celltext := chr(32);
end;
end;

procedure Tares_frmmain.treeview_chat_favoritesGetImageIndex(
  Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
imageindex := 3;
end;

procedure Tares_frmmain.treeview_chat_favoritesCompareNodes(
  Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex;
  var Result: Integer);
var
  Data1,
  Data2: precord_chat_favorite;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  case column of
    0: Result := CompareText(Data1.name, Data2.name);
    2: Result := CompareText(widestrtoutf8str(Data1.stripped_topic), widestrtoutf8str(Data2.stripped_topic));
    1: Result := Data1.last_joined - Data2.last_joined;
   end;
end;

procedure Tares_frmmain.AddtoFavorites1Click(Sender: TObject);
var
 nodo,nodof:PCmtVNode;
 datas:precord_displayed_channel;
 dataf:precord_chat_favorite;
begin
nodo := listview_chat_channel.getfirstselected;
if nodo=nil then exit;

if not btn_chat_fav.down then btn_chat_favClick(btn_chat_fav);

datas := listview_chat_channel.getdata(nodo);

nodof := treeview_chat_favorites.getfirst;
while (nodof<>nil) do begin
  dataf := treeview_chat_favorites.getdata(nodof);
  if dataf^.ip=datas^.ip then
   if dataf^.port=datas^.port then exit;
 nodof := treeview_chat_favorites.getnext(nodof);
end;

nodof := treeview_chat_favorites.addchild(nil);
 dataf := treeview_chat_favorites.getdata(nodof);
 dataf^.ip := datas^.ip;
 dataf^.last_joined := DelphiDateTimeToUnix(now);
 dataf^.port := datas^.port;
 dataf^.name := datas^.name;
 dataf^.topic := datas^.topic;
 dataf^.locrc := datas^.locrc;
 dataf^.stripped_topic := datas^.stripped_topic;
 dataf^.has_colors_intopic := datas^.has_colors_intopic;
save_favorite_channel(dataf);


end;

procedure Tares_frmmain.Join1Click(Sender: TObject);
var
 nodo:PCmtVNode;
 datas:precord_displayed_channel;
 dataf:precord_chat_favorite;
begin
try

nodo := treeview_chat_favorites.getfirstselected;
if nodo=nil then exit;
 dataf := treeview_chat_favorites.getdata(nodo);

 update_FAVchannel_last(dataf,nil);


 datas := AllocMem(sizeof(record_displayed_channel));
 datas^.ip := dataf^.ip;
 datas^.port := dataf^.port;
 datas^.name := dataf^.name;
 datas^.topic := dataf^.topic;
 datas^.locrc := dataf^.locrc;
 datas^.stripped_topic := dataf^.stripped_topic;
 datas^.has_colors_intopic := dataf^.has_colors_intopic;
 datas^.enableJSTemplate := vars_global.chat_enabled_remoteJSTemplate;

helper_channellist.join_channel(datas);

  datas^.name := '';
  datas^.topic := '';
  datas^.stripped_topic := '';
 FreeMem(datas,sizeof(record_displayed_channel));


 except
 end;
end;

procedure Tares_frmmain.Remove1Click(Sender: TObject);
var
nodo:PCmtVNode;
dataf:precord_chat_favorite;
kname: string;
reg: Tregistry;
begin
 try

nodo := treeview_chat_favorites.getfirstselected;

while (nodo<>nil) do begin
if nodo=nil then exit;
 dataf := treeview_chat_favorites.getdata(nodo);

 kname := bytestr_to_hexstr(int_2_dword_string(dataf^.ip)+int_2_word_string(dataf^.port));

 reg := tregistry.create;
 reg.RootKey := HKEY_CURRENT_USER;
 with reg do begin
  openkey(areskey+'ChatFavorites',true);
  deletekey(kname);
  closekey;
  destroy;
 end;

 treeview_chat_favorites.DeleteNode(nodo,true);
 nodo := treeview_chat_favorites.getfirstselected;
end;

except
end;
end;

procedure Tares_frmmain.treeview_chat_favoritesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
dataf:precord_chat_favorite;
nodo:pCMTVnode;
punto: TPoint;
begin
if button<>mbright then exit;
 nodo := treeview_chat_favorites.getfirstselected;
if nodo=nil then exit;

 dataf := treeview_chat_favorites.getdata(nodo);

 autoJoin1.checked := dataf^.autoJoin;

 getcursorpos(punto);
 popup_chat_fav.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.ExportHashlink6Click(Sender: TObject);
begin
export_favorite_channel_hashlink;
end;

procedure Tares_frmmain.RemoveSource1Click(Sender: TObject);
var
node:pCmtVnode;
dataNode:precord_data_node;
DsData:precord_displayed_downloadsource;
BtSrcData:btcore.Precord_displayed_source;
begin
node := treeview_download.GetFirstselected;
if node=nil then exit;

dataNode := treeview_download.getdata(node);

if dataNode^.m_type<>dnt_downloadSource then
 if dataNode^.m_type<>dnt_partialDownload then
  if datanode^.m_type<>dnt_bittorrentSource then exit;

 if dataNode^.m_type=dnt_downloadSource then begin
  DsData := dataNode^.data;
 
  if (DsData^.state in [srs_receiving,
                        srs_connecting,
                        srs_readytorequest,
                        srs_receivingReply,
                        srs_connected,
                        srs_UDPreceivingICH,
                        srs_UDPDownloading,
                        srs_receivingICH]) then DsData^.should_disconnect := True;

 end else
 if dataNode^.m_type=dnt_bittorrentSource then begin
   BtSrcData := dataNode^.data;
   if btSrcData^.status=btSourceConnected then BtSrcData^.should_disconnect := True;
 end;

end;



procedure Tares_frmmain.lbl_srcmime_audioClick(Sender: TObject);
begin
radio_srcmime_audio.Checked := True;
end;

procedure Tares_frmmain.lbl_srcmime_videoClick(Sender: TObject);
begin
radio_srcmime_video.Checked := True;
end;

procedure Tares_frmmain.lbl_srcmime_documentClick(Sender: TObject);
begin
radio_srcmime_document.Checked := True;
end;

procedure Tares_frmmain.lbl_srcmime_imageClick(Sender: TObject);
begin
radio_srcmime_image.Checked := True;
end;

procedure Tares_frmmain.lbl_srcmime_softwareClick(Sender: TObject);
begin
radio_srcmime_software.Checked := True;
end;

procedure Tares_frmmain.lbl_srcmime_otherClick(Sender: TObject);
begin
radio_srcmime_other.Checked := True;
end;

procedure Tares_frmmain.lbl_lib_filesharedClick(Sender: TObject);
begin
chk_lib_fileshared.checked := not chk_lib_fileshared.checked;
ShareUnsharefile1Click(nil);
end;



procedure Tares_frmmain.panel_vidDblClick(Sender: TObject);
begin
Fullscreen2Click(nil);
end;

procedure Tares_frmmain.videoDblClick(Sender: TObject);
begin
Fullscreen2Click(nil);
end;

procedure Tares_frmmain.TntFormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin


if key=VK_ESCAPE then
 if tabs_pageview.activepage=IDTAB_SCREEN then
  if fullscreen2.checked then
   Fullscreen2Click(nil);
end;

procedure Tares_frmmain.listview_chat_channelPaintText(
  Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode;
  Column: TColumnIndex);
begin
if node.childcount=0 then exit;

 TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
 if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.listview_chat_channelCollapsing(
  Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
allowed := False;
end;

procedure Tares_frmmain.treeview_uploadPaintText(Sender: TBaseCometTree;
  const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
datanode:precord_data_node;
begin
dataNode := sender.getdata(node);
if dataNode^.m_type<>dnt_partialUpload then exit;

TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.RemoveSource2Click(Sender: TObject);
var
datanode:precord_data_node;
node:PCmtVNode;
BtSrcData:btcore.Precord_displayed_source;
begin
node := treeview_upload.GetFirstselected;
if node=nil then exit;

dataNode := treeview_upload.getdata(node);

 if dataNode^.m_type=dnt_bittorrentSource then begin
   BtSrcData := dataNode^.data;
   if btSrcData^.status=btSourceConnected then BtSrcData^.should_disconnect := True;
 end;
end;

procedure Tares_frmmain.AutoJoin1Click(Sender: TObject);
var
nodo:PCmtVNode;
dataf:precord_chat_favorite;
begin
try
autojoin1.checked := not autojoin1.checked;

nodo := treeview_chat_favorites.getfirstselected;
if nodo=nil then exit;
dataf := treeview_chat_favorites.getdata(nodo);
dataf^.autoJoin := autojoin1.checked;
setAutoJoin(dataf,autojoin1.checked);

except
end;
end;


function Tares_frmmain.AsyncExFilterState(Buffering: LongBool; PreBuffering: LongBool; Connecting: LongBool; Playing: LongBool; BufferState: integer): HRESULT; stdcall;
var
 hr:hresult;
begin
Result := S_OK;

  if ((Buffering) or (PreBuffering) or (connecting)) then begin
    shoutcast.isConnectingShoutcast := True;
    if connecting then bufferstate := -1;
    if shoutcast.RenderError then exit;
    shoutcast.UpdateCaptionShoutcast(BufferState);
  end else

  if ((not Connecting) and
      (not PreBuffering) and
      (not buffering) and
      (not playing) and
      (BufferState=100)) then begin

     if renderingMp3Stream then begin
      if not shoutcast.isReconnecting then begin
       if assigned(helper_player.m_GraphBuilder) then begin
       hr := helper_player.m_GraphBuilder.Render(helper_player.m_Pin);
       if FAILED(hr) then begin
        shoutcast.RenderError := True;
        vars_global.caption_player := 'GraphBuilder Render Error: '+DSUtil.GetErrorString(HR);
        ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
        exit;
       end;
      end;
     end else shoutcast.isReconnecting := False;
     
      helper_player.player_get_volumesettings;

      if assigned(helper_player.m_MediaControl) then begin
       hr := helper_player.m_MediaControl.Run;
       if FAILED(hr) then begin
        shoutcast.RenderError := True;
        vars_global.caption_player := 'MediaControl Run Error: '+DSUtil.GetErrorString(HR);
        ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
        exit;
       end;
      end;
     end;
     
      helper_registry.Set_regstring('ShoutCast.LastURL',shoutcast.radioURL);

      shoutcast.isConnectingShoutcast := False;
      if not shoutcast.RenderError then shoutcast.UpdateCaptionShoutcast;
      ares_frmmain.MPlayerPanel1.Playing := True;
  end else

  if Playing then begin
    shoutcast.isConnectingShoutcast := False;
    shoutcast.UpdateCaptionShoutcast;
  end;

end;

function Tares_frmmain.AsyncExICYNotice(IcyItemName: PChar; ICYItem: PChar): HRESULT; stdcall;
const
// ICY Item Names
  c_ICYName = 'icy-name:';
  //c_ICYGenre = 'icy-genre:';
  c_ICYURL = 'icy-url:';
 // c_ICYBitrate = 'icy-br:';
  c_ICYError = 'icy-error:';
  c_ICYStreamMime = 'icy-internalmime:';
 // c_ICYMetaInterval = 'icy-metainterval:';
 // c_ICYNotice2 = 'icy-notice2:';
var
 str: string;
begin
Result := S_OK;

if shoutcast.RenderError then exit;

  if IcyItemName=c_ICYName then begin
   if length(ares_frmmain.mplayerpanel1.urlCaption)=0 then begin
     str := copy(ICYItem, 1, length(ICYItem));
     ares_frmmain.mplayerpanel1.urlCaption := widestring(str);
     shoutcast.AddMenuRadio(widestrtoutf8str(ares_frmmain.mplayerpanel1.urlCaption),shoutcast.radioUrl);
   end;
  end;

  if IcyItemName=c_ICYURL then begin
   if length(ares_frmmain.mplayerpanel1.url)=0 then begin
     ares_frmmain.mplayerpanel1.url := copy(ICYItem, 1, length(ICYItem));
   end;
  end;

   if IcyItemName=c_ICYStreamMime then begin
      str := copy(ICYItem, 1, length(ICYItem));
      if lowercase(str)='audio/mpeg' then shoutcast.connectmp3
       else shoutcast.connectaac;
   end;

  if IcyItemName=c_ICYError then begin
    str := copy(ICYItem,1,length(ICYItem));

    if pos('ICY 40',str)=1 then begin
     vars_global.caption_player := 'Service Unavailable, Radio Offline';
     ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
     shoutcast.RenderError := True;
     tmr_stop_radio.enabled := True; // we cant stop in its callback
     exit;
    end else
    if pos('stream type ',lowercase(str))=1 then begin   // Apple's AAC+ thingy?
     vars_global.caption_player := str;
     ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
     shoutcast.RenderError := True;
     tmr_stop_radio.enabled := True; // we cant stop in its callback
     exit;
    end;
    if ((pos('socket error ',lowercase(str))=1) or
       (pos('network error ',lowercase(str))=1)) then begin  // disconnected while playing stream
     shoutcast.isConnectingShoutcast := True;
     shoutcast.isReconnecting := True;
     //helper_player.pauseMedia;
    end;

    vars_global.caption_player := str;
    ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
  end;


end;

function Tares_frmmain.AsyncExSockError(ErrString: PChar): HRESULT; stdcall;
begin
Result := S_OK;
end;

function Tares_frmmain.AsyncExMetaData(Title: PChar; URL: PChar): HRESULT; stdcall;
var
 Temptitle: string;
begin
Result := S_OK;
if shoutcast.RenderError then exit;

TempTitle := copy(title,1,length(title));

while (true) do
if pos(' - ',TempTitle)=length(TempTitle)-2 then delete(TempTitle,length(TempTitle)-2,3)
 else break;

if shoutcast.titleStream<>TempTitle then begin
 shoutcast.CurrentPos := 0; // set time to 0
 shoutcast.titleStream := TempTitle;
 //Riptodisk1.visible := True;
 ares_frmmain.ExportHashlink7.visible := True;
 shoutcast.UpdateCaptionShoutcast;
 if Enable1.checked then
  if not shoutcast.hasEverStartedRip then begin
   SetRipStream(true);
   shoutcast.hasEverStartedRip := True;
  end;

  uWhatImListeningTo.UpdateWhatImListeningTo(widestrtoutf8str({widestring(}TempTitle){)},widestrtoutf8str(ares_frmmain.mplayerpanel1.urlCaption));
end else
if TempTitle='' then uWhatImListeningTo.UpdateWhatImListeningTo('',widestrtoutf8str(ares_frmmain.mplayerpanel1.urlCaption));

end;

procedure Tares_frmmain.New1Click(Sender: TObject);
var
fURL: string;

begin
fURL := get_regstring('ShoutCast.LastURL');
if length(furl)=0 then fUrl := 'http://';
if not inputquery('Internet Radio','URL:',fUrl) then exit;

n20.visible := True;
shoutcast.openRadioUrl(furl);

end;

procedure Tares_frmmain.radiostationclick(Sender: TObject);
var
item: TTntMenuItem;
begin
item := sender as ttntmenuitem;
shoutcast.OpenRadioStation(widestrtoutf8str(item.caption));
end;

procedure Tares_frmmain.Locate4Click(Sender: TObject);
begin
if shoutcast.renderingMp3Stream then
locate_containing_folder(widestrtoutf8str(vars_global.myshared_folder+'\Radio\'+shoutcast.titleStream+'.mp3'))
else
locate_containing_folder(widestrtoutf8str(vars_global.myshared_folder+'\Radio\'+shoutcast.titleStream+'.aac'))
end;

procedure Tares_frmmain.Enable1Click(Sender: TObject);
begin
Enable1.checked := not Enable1.checked;
shoutcast.SetRipStream(Enable1.checked);
end;

procedure Tares_frmmain.btn_player_radioClick(Sender: TObject);
var
punto: TPoint;
begin
OpenExternal3.visible := False;
Locate3.visible := False;
addtoplaylist6.visible := False;
N16.visible := False;

ListentoRadio1.visible := True;
ExportHashlink7.visible := (length(shoutcast.radioUrl)>=10);
getcursorpos(punto);

 popup_capt_player.popup(punto.x-10,punto.y-10);
end;

procedure Tares_frmmain.ExportHashlink7Click(Sender: TObject);
begin
if length(shoutcast.radioUrl)>=10 then
 shoutcast.export_radioArlnk(shoutcast.radioUrl);
end;

procedure Tares_frmmain.tmr_stop_radioTimer(Sender: TObject);
begin
tmr_stop_radio.enabled := False;
stopmedia(nil);
end;

procedure Tares_frmmain.Volume1Click(Sender: TObject);
begin
timer_fullScreenHideCursor.enabled := False;
while ShowCursor(true)<0 do;
btn_player_volClick(nil);
end;

procedure Tares_frmmain.timer_fullScreenHideCursorTimer(Sender: TObject);
begin
timer_fullScreenHideCursor.enabled := False;

if helper_player.FFullScreenWindow=nil then begin
 try
 while ShowCursor(true)<0 do application.processmessages;
 except
 end;
 exit;
end;

while ShowCursor(false)>=0 do application.processmessages;
GetCursorPos(vars_global.prev_cursorpos);
end;

procedure Tares_frmmain.fullscreenMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
if x-10<vars_global.prev_cursorpos.x then
 if x+10>vars_global.prev_cursorpos.x then
  if y-10<vars_global.prev_cursorpos.y then
   if y+10>vars_global.prev_cursorpos.y then exit;
try
while ShowCursor(true)<0 do application.processmessages;
GetCursorPos(vars_global.prev_cursorpos);
except
end;
timer_fullScreenHideCursor.enabled := False;
timer_fullScreenHideCursor.interval := 4000;
timer_fullScreenHideCursor.enabled := True;
end;

procedure Tares_frmmain.PopupMenuvideoPopup(Sender: TObject);
begin
 timer_fullScreenHideCursor.enabled := False;
 try
 while ShowCursor(true)<0 do application.processmessages;
 GetCursorPos(vars_global.prev_cursorpos);
 except
 end;
end;

procedure Tares_frmmain.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
try
 if ActiveControl<>nil then
  if (ActiveControl.ClassType=TEdit) or
     (ActiveControl.ClassType=TTntEdit) or
     (ActiveControl.ClassType=TCometBtnEdit) or
     (ActiveControl.ClassType=TTntCombobox) then exit;

if key=VK_RIGHT then begin
 helper_player.player_step_forward;
end else
if key=VK_LEFT then begin
 helper_player.player_step_backward;
end;
except
end;
end;

procedure Tares_frmmain.TntFormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
Handled := False;

try

  case tabs_pageview.activePage of
   IDTAB_LIBRARY:if listview_lib.enabled then listview_lib.SetFocus;
   IDTAB_SEARCH:begin
       Handled := isSrcComboFocused; //stop annoying 'clear search history' while using mousewheel 
       helper_search_gui.SetFocusSrc;
      end;
   IDTAB_CHAT:helper_channellist.SetFocus;
   IDTAB_TRANSFER:helper_download_misc.setFocus;
  end;

except
end;
end;

procedure Tares_frmmain.panel_player_captclick(Sender: TObject);
var
punto: TPoint;
begin
//if button<>mbright then exit;
if ((length(player_actualfile)=0) or
    (not fileexistsW(player_actualfile))) then begin
     OpenExternal3.visible := False;
     Locate3.visible := False;
     addtoplaylist6.visible := False;
     N16.visible := False;
     ExportHashlink7.visible := (length(shoutcast.radioUrl)>=10);
    end else begin
     OpenExternal3.visible := True;
     Locate3.visible := True;
     addtoplaylist6.visible := True;
     N16.visible := True;
     ExportHashlink7.visible := False;
    end;
getcursorpos(punto);
popup_capt_player.popup(punto.x,punto.y);
end;

procedure Tares_frmmain.MPlayerPanel1Click(BtnId: TMPlayerButtonID);
begin

 case BtnId of
   MPBtnPlaylist:begin
                  formhint_hide;
                  toggle_playlist;
                end;
   MPBtnStop:stopmedia(mplayerpanel1);
   MPBtnPrev:begin
              playlist_select_prev;
              listview_playlistDblClick(nil);
             end;
   MPBtnRew:helper_player.player_step_backward;
   MPBtnPlay:btn_player_playClick(nil);
   MPBtnPause:btn_player_pauseClick(mplayerpanel1);
   MPBtnFF:helper_player.player_step_forward;
   MPBtnNext:begin
             playlist_select_next;
             listview_playlistDblClick(nil);
             end;
   MPBtnVol:btn_player_volClick(mplayerpanel1);
   MPBtnRadio:btn_player_radioClick(mplayerpanel1);
 end;

end;

procedure Tares_frmmain.MPlayerPanel1BtnHint(BtnId: TMPlayerButtonID);

   function BtnIdtoHint(BtnId: TMPlayerButtonID): string;
   begin
    case BtnId of
       MPBtnPlaylist: Result := GetLangStringA(STR_SHOW_PLAYLIST);
       MPBtnRadio: Result := 'Internet Radio'
    end;
   end;

var
point: TPoint;
begin

if BtnID<>MPBtnRadio then
 if BtnID<>MPBtnPlaylist then begin
  MPlayerPanel1.hint := '';
  Application.CancelHint;
  exit;
 end;

if BtnIdtoHint(BtnID)<>MPlayerPanel1.hint then begin
 GetCursorPos(point);
 MPlayerPanel1.hint := BtnIdtoHint(BtnID);
 Application.ActivateHint(point);
end;
end;

procedure Tares_frmmain.TntFormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
if newWidth<300 then begin
 resize := False;
 exit;
end else
if newHeight<200 then begin
 resize := False;
 exit;
end else
 resize := True;
end;

procedure Tares_frmmain.tabs_pageviewPaintButtonFrame(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
 pointX: Integer;
 Details: TThemedElementDetails;
begin
if helper_skin.TabsSourceBitmap=nil then begin
  if ThemeServices.ThemesEnabled then begin
   Details := ThemeServices.GetElementDetails(ttbToolBarRoot); //trRebarRoot);
   //paintRect := rect(0,0,tabs_pageview.clientwidth,tabs_pageview.buttonsHeight);
   ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @PaintRect); //@paintRect);
  // aCanvas.Brush.color := clBlack;
  // aCanvas.fillrect(rect(paintRect.left,paintRect.bottom-1,paintRect.right,paintrect.Bottom));
  end else begin
   aCanvas.pen.color := clBlack;
   aCanvas.brush.Color := clBtnFace;
   aCanvas.rectangle(paintRect.left,paintRect.top,paintRect.right,paintRect.bottom);
  end;
 exit;
end;

BitBlt(aCanvas.handle,0,0,TabsCopyPointLeft.y{y=placeholder for width},tabs_pageview.buttonsHeight,
       TabsSourceBitmap.canvas.handle,TabsCopyPointLeft.x,0,SRCCOpy);

pointx := TabsCopyPointLeft.y{y=placeholder for width};
while (pointX<paintRect.right-(TabsCopyPointRight.y-1){y=placeholder for width}) and (TabsCopyPointMiddle.y>0) do begin
 BitBlt(aCanvas.Handle,pointx,0,TabsCopyPointMiddle.y,tabs_pageview.buttonsHeight,
        helper_skin.TabsSourceBitmap.canvas.handle,TabsCopyPointMiddle.x,0,SRCCopy);
 inc(pointX,TabsCopyPointMiddle.y);
end;

BitBlt(aCanvas.handle,paintRect.right-TabsCopyPointRight.y,0,TabsCopyPointRight.y,tabs_pageview.buttonsHeight,
       helper_skin.TabsSourceBitmap.canvas.handle,TabsCopyPointRight.x,0,SRCCOpy);
end;

procedure Tares_frmmain.smalltabs_pageviewPaintButtonFrame(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
 pointX,offsety: Integer;
 Details: TThemedElementDetails;
begin
if helper_skin.smallTabsSourceBitmap=nil then begin
  if ThemeServices.ThemesEnabled then begin
   Details := ThemeServices.GetElementDetails(ttBody);
   ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
   aCanvas.Brush.color := clBlack;
   aCanvas.fillrect(rect(paintRect.left,paintRect.bottom-1,paintRect.right,paintrect.Bottom));
  end else begin
   aCanvas.pen.color := clBlack;
   aCanvas.brush.Color := clBtnFace;
   aCanvas.rectangle(paintRect.left,paintRect.top,paintRect.right,paintRect.bottom);
  end;
 exit;
end;

offsety := 0;

while (offsety+(sender as TCometPageView).buttonsHeight<=paintRect.bottom) do begin
 BitBlt(aCanvas.handle,0,offsety,smallTabsCopyPointLeft.y{y=placeholder for width},panel_chat.buttonsHeight,
        smallTabsSourceBitmap.canvas.handle,smallTabsCopyPointLeft.x,0,SRCCOpy);

 pointx := smallTabsCopyPointLeft.y{y=placeholder for width};
 while (pointX<paintRect.right-(smallTabsCopyPointRight.y-1){y=placeholder for width}) and (smallTabsCopyPointMiddle.y>0) do begin
  BitBlt(aCanvas.Handle,pointx,offsety,smallTabsCopyPointMiddle.y,panel_chat.buttonsHeight,
        helper_skin.smallTabsSourceBitmap.canvas.handle,smallTabsCopyPointMiddle.x,0,SRCCopy);
  inc(pointX,smallTabsCopyPointMiddle.y);
 end;

 BitBlt(aCanvas.handle,paintRect.right-smallTabsCopyPointRight.y,offsety,smallTabsCopyPointRight.y,panel_chat.buttonsHeight,
        helper_skin.smallTabsSourceBitmap.canvas.handle,smallTabsCopyPointRight.x,0,SRCCOpy);
 inc(offsety,(sender as TCometPageView).buttonsHeight);
end;
end;

procedure Tares_frmmain.tabs_pageviewPaintButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
pointX,wid: Integer;
//gowithOsTheme: Boolean;
 Details: TThemedElementDetails;
// r: TRect;
// bitmap: TBitmap;
 pnl: TCometPagePanel;
 hovState: Boolean;
begin
if helper_skin.TabsSourceBitmap=nil then begin

 if ThemeServices.ThemesEnabled then begin

    pnl := aPanel as TCometPagePanel;
   { bitmap := TBitmap.create;
    bitmap.width := tabs_pageview.clientwidth;
    bitmap.height := tabs_pageview.buttonsheight;
    bitmap.PixelFormat := pf24bit;
    Details := ThemeServices.GetElementDetails(trRebarRoot);}
    //r := rect(0,0,tabs_pageview.clientWidth,tabs_pageview.buttonsHeight);



    Details := ThemeServices.GetElementDetails(ttbToolBarRoot);
    ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
    //bitBlt(aCanvas.handle,paintRect.left,paintrect.top,paintrect.right-paintRect.left,(paintRect.bottom-paintrect.top),
    //       bitmap.canvas.handle,pnl.BtnHitRect.left,pnl.BtnHitRect.top,SRCCOPY);
   // bitmap.Free;
    inc(paintRect.top,2);
    dec(PaintRect.bottom,3);

  if (aPanel as TCometPagePanel).btnState=[cometpageview.csDown,cometpageview.csHover] then begin
  Details := ThemeServices.GetElementDetails(ttbButtonCheckedHot); //tbPushButtonDefaulted);
  ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
  end else
  if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
     ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin
     Details := ThemeServices.GetElementDetails(ttbButtonPressed);
     ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
  end else
  if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin
  Details := ThemeServices.GetElementDetails(ttbButtonChecked);
  ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
  end else
  if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin
  Details := ThemeServices.GetElementDetails(ttbButtonHot);
  ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
  end else begin

  end;

  if ImageList_tabs.count>=14 then begin // draw Icons
   hovState := (cometpageview.csHover in (APanel as TCometPagePanel).btnState);
    case (aPanel as TCometPagePanel).ID of
     IdxBtnWeb:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,7-(integer(hovState)*7));
     IdxBtnLibrary:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,8-(integer(hovState)*7));
     IdxBtnScreen:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,9-(integer(hovState)*7));
     IdxBtnSearch:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,10-(integer(hovState)*7));
     IdxBtnTransfer:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,11-(integer(hovState)*7));
     IdxBtnChat:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,12-(integer(hovState)*7));
     IdxBtnOptions:ImageList_tabs.draw(aCanvas,paintRect.left+5,paintRect.top+5,13-(integer(hovState)*7));
    end;
  end;
   // if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.Brush.color := clbtnface
   //  else
    //paintRect.top := paintRect.Bottom;
   // paintRect.Bottom := paintRect.top+2;
    //Details := ThemeServices.GetElementDetails(ttBody);
    //ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

    //aCanvas.Brush.color := clBlack;
    //aCanvas.fillrect(rect(paintRect.left,paintRect.bottom-1,paintRect.right,paintrect.Bottom));

 end else begin
  aCanvas.pen.color := clblack;
  if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.brush.color := clwhite
   else aCanvas.brush.color := clBtnface;
  aCanvas.rectangle(paintRect.left,paintRect.Top,paintRect.right,paintrect.bottom);
 end;
 exit;
end;
//if (APanel as TCometPagePanel).btnState=[] then exit; //nothing to do


if (aPanel as TCometPagePanel).btnState=[cometpageview.csDown,cometpageview.csHover] then begin // down/hover
 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.TabsDownHoverCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownHoverCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.TabsDownHoverCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.TabsDownHoverCopyPointC.y-1)) do begin
   wid := helper_skin.TabsDownHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.TabsDownHoverCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.TabsDownHoverCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,0,wid,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownHoverCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.TabsDownHoverCopyPointC.y,0,helper_skin.TabsDownHoverCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownHoverCopyPointC.x,0,SRCCOpy);
end else

if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
    ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin  // clicked/Hover

 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.TabsClickedCopyPointA.y,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsClickedCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.TabsClickedCopyPointA.y;
while (pointX<paintRect.right-(helper_skin.TabsClickedCopyPointC.Y-1)) do begin
   wid := helper_skin.TabsClickedCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.TabsClickedCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.TabsClickedCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,0,wid,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsClickedCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.TabsClickedCopyPointC.y,0,helper_skin.TabsClickedCopyPointC.y,paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsClickedCopyPointC.x,0,SRCCOpy);
end else

if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin  // down
 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.TabsDownCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.TabsDownCopyPointA.y;
while (pointX<paintRect.right-(helper_skin.TabsDownCopyPointC.Y-1)) do begin
   wid := helper_skin.TabsDownCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.TabsDownCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.TabsDownCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,0,wid,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.TabsDownCopyPointC.y,0,helper_skin.TabsDownCopyPointC.y,paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsDownCopyPointC.x,0,SRCCOpy);
end else



if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin  //Hover
BitBlt(aCanvas.handle,
       paintRect.left,paintRect.top,helper_skin.TabsHoverCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsHoverCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.TabsHoverCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.TabsHoverCopyPointC.y-1)) do begin
   wid := helper_skin.TabsHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.TabsHoverCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.TabsHoverCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,0,wid,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsHoverCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.TabsHoverCopyPointC.y{y=placeholder for width},0,helper_skin.TabsHoverCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsHoverCopyPointC.x,0,SRCCOpy);
end else begin  //Hover
BitBlt(aCanvas.handle,
       paintRect.left,paintRect.top,helper_skin.TabsOffCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsOffCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.TabsOffCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.TabsOffCopyPointC.y-1)) do begin
   wid := helper_skin.TabsHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.TabsOffCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.TabsOffCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,0,wid,paintRect.bottom-paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsOffCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.TabsOffCopyPointC.y{y=placeholder for width},0,helper_skin.TabsOffCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.TabsSourceBitmap.canvas.handle,helper_skin.TabsOffCopyPointC.x,0,SRCCOpy);
end;


end;

procedure Tares_frmmain.smallTabsPaintButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
pointX,wid: Integer;
pnl: TCometPagePanel;
Details: TThemedElementDetails;
begin
if helper_skin.smallTabsSourceBitmap=nil then begin

 if ThemeServices.ThemesEnabled then begin
  inc(paintRect.top,2);

  {
  if (aPanel as TCometPagePanel).btnState=[cometpageview.csDown,cometpageview.csHover] then
  Details := ThemeServices.GetElementDetails(ttTabItemFocused)
   else
  if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
     ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then
     Details := ThemeServices.GetElementDetails(ttTabItemSelected)
   else    }
  if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then Details := ThemeServices.GetElementDetails(ttTabItemSelected)
   else begin
    dec(PaintRect.bottom,1);
    if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then Details := ThemeServices.GetElementDetails(ttTabItemHot)
     else  Details := ThemeServices.GetElementDetails(ttTabItemNormal);
   end;
   ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

   // paintRect.top := paintRect.Bottom;
   // paintRect.Bottom := paintRect.top+1;
   // Details := ThemeServices.GetElementDetails(ttBody);
   // ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

    if not (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then
    //aCanvas.Brush.color := clWhite
    // else
     aCanvas.Brush.color := clBlack;
    aCanvas.fillrect(rect(paintRect.left,paintRect.bottom,paintRect.right,paintrect.Bottom+1));
    
 end else begin
   aCanvas.pen.color := clblack;
   if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.brush.color := cl3dlight
    else aCanvas.brush.color := clBtnface;
    aCanvas.rectangle(paintRect.left,paintRect.Top,paintRect.right,paintrect.bottom);
 end;
 exit;
end;
//if (APanel as TCometPagePanel).btnState=[] then exit; //nothing to do


if (aPanel as TCometPagePanel).btnState=[cometpageview.csDown,cometpageview.csHover] then begin // down/hover
 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.smallTabsDownHoverCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownHoverCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.smallTabsDownHoverCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.smallTabsDownHoverCopyPointC.y-1)) do begin
   wid := helper_skin.smallTabsDownHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.smallTabsDownHoverCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.smallTabsDownHoverCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,paintRect.top,wid,paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownHoverCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.smallTabsDownHoverCopyPointC.y,paintRect.top,helper_skin.smallTabsDownHoverCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownHoverCopyPointC.x,0,SRCCOpy);
end else

if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
    ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin  // clicked/Hover

 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.smallTabsClickedCopyPointA.y,paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsClickedCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.smallTabsClickedCopyPointA.y;
while (pointX<paintRect.right-(helper_skin.smallTabsClickedCopyPointC.Y-1)) do begin
   wid := helper_skin.smallTabsClickedCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.smallTabsClickedCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.smallTabsClickedCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,paintRect.top,wid,paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsClickedCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.smallTabsClickedCopyPointC.y,paintRect.top,helper_skin.smallTabsClickedCopyPointC.y,paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsClickedCopyPointC.x,0,SRCCOpy);
end else

if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin  // down
 BitBlt(aCanvas.handle,
        paintRect.left,paintRect.top,helper_skin.smallTabsDownCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.smallTabsDownCopyPointA.y;
while (pointX<paintRect.right-(helper_skin.smallTabsDownCopyPointC.Y-1)) do begin
   wid := helper_skin.smallTabsDownCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.smallTabsDownCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.smallTabsDownCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,paintRect.top,wid,paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.smallTabsDownCopyPointC.y,paintRect.top,helper_skin.smallTabsDownCopyPointC.y,paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsDownCopyPointC.x,0,SRCCOpy);
end else



if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin  //Hover
BitBlt(aCanvas.handle,
       paintRect.left,paintRect.top,helper_skin.smallTabsHoverCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsHoverCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.smallTabsHoverCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.smallTabsHoverCopyPointC.y-1)) do begin
   wid := helper_skin.smallTabsHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.smallTabsHoverCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.smallTabsHoverCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,paintRect.top,wid{y=placeholder for width},paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsHoverCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.smallTabsHoverCopyPointC.y{y=placeholder for width},paintRect.top,helper_skin.smallTabsHoverCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsHoverCopyPointC.x,0,SRCCOpy);
end else begin

BitBlt(aCanvas.handle,
       paintRect.left,paintRect.top,helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsOffCopyPointA.x,0,SRCCOpy);

pointx := paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
while (pointX<paintRect.right-(helper_skin.smallTabsOffCopyPointC.y-1)) do begin
   wid := helper_skin.smallTabsOffCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>paintRect.right-(helper_skin.smallTabsOffCopyPointC.y-1) then wid := (paintRect.right-(helper_skin.smallTabsOffCopyPointC.y-1))-pointx;
 BitBlt(aCanvas.Handle,pointx,paintRect.top,wid,paintRect.bottom-paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsOffCopyPointB.x,0,SRCCopy);
 inc(pointX,wid);
end;

BitBlt(aCanvas.handle,paintRect.right-helper_skin.smallTabsOffCopyPointC.y{y=placeholder for width},paintRect.top,helper_skin.smallTabsOffCopyPointC.y{y=placeholder for width},paintRect.bottom-paintRect.top,
       helper_skin.smallTabsSourceBitmap.canvas.handle,helper_skin.smallTabsOffCopyPointC.x,0,SRCCOpy);

end;

pnl := aPanel as TCometPagePanel;
if pnl.imageindex<>-1 then begin
 imagelist_chat.draw(aCanvas,paintRect.left+(sender as TCometPageView).ButtonsLeftMargin,
                             paintRect.top+(sender as TCometPageView).ButtonsTopMargin-1,
                             pnl.imageindex);
end;

end;


procedure Tares_frmmain.resizeSearch(Sender: TObject);
var
panel: Tpanel;
begin
panel := sender as tpanel;
panel_search.height := panel.clientheight-panel_search.top;
pagesrc.height := panel_search.height;
//pagesrc.width := panel.clientwidth-panel_search.width;

  //if btn_src_togglefield.down then
  panel_search.width := 218;
  lbl_src_status.width := panel_search.clientWidth-(lbl_src_status.left*2);
  edit_src_filter.Width := panel_search.clientWidth-(edit_src_filter.left*2);
   // else panel_search.width := 0;

   pagesrc.left := panel_search.left+panel_search.width;
   pagesrc.width := Panel.clientwidth-pagesrc.left;

   if radio_srcmime_all.checked then begin
    lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
    if lbl_src_status.top<radio_srcmime_other.top+20 then lbl_src_status.top := radio_srcmime_other.top+20;
    edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
   end else
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
    lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
    if lbl_src_status.top<image_more_top+20 then lbl_src_status.top := image_more_top+20;
    edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
   end else begin
    lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
    if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
    edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
   end;
end;

procedure Tares_frmmain.tabs_pageviewPanelShow(Sender, aPanel: TObject);
var
pagepanel: TCometPagePanel;
begin
pagePanel := aPanel as TCometPagePanel;

case pagePanel.ID of
 IdxBtnLibrary:helper_gui_misc.mainGui_showlibrary;
 IdxBtnScreen:helper_gui_misc.mainGui_showscreen;
 IdxBtnSearch:helper_gui_misc.mainGui_showsearch;
 IdxBtnTransfer:helper_gui_misc.mainGui_showtransfer;
 IdxBtnChat:helper_gui_misc.mainGui_showChat;
 IdxBtnOptions:helper_gui_misc.mainGui_showoptions;
end;

end;

procedure tares_frmmain.blendPlaylistFormDeactivate(Sender: TObject);
begin
(sender as tform).visible := False;
playlist_visible := False;
blendPlaylistForm.visible := False;
end;




procedure Tares_frmmain.splitter_transferEndSplit(Sender: TObject);
begin

with splitter_transfer do begin
 //invalidate;
 top := top+ypos;
 panelUploadHeight := ares_frmmain.panel_transfer.clientheight-(top);
end;

if panelUploadHeight<100 then panelUploadHeight := 100;
if panelUploadHeight+100>ares_frmmain.panel_transfer.clientheight then panelUploadHeight := ares_frmmain.panel_transfer.clientheight-100;

panel_tran_upqu.height := panelUploadHeight;
splitter_transfer.top := panel_tran_upqu.Top-splitter_transfer.height;
panel_tran_down.height := splitter_transfer.top;


write_default_upload_height;

panel_transferResize(panel_transfer);
end;

procedure Tares_frmmain.btns_transferResize(Sender: TObject);
begin
 if ares_frmmain.btn_tran_clearIdle.left+ares_frmmain.btn_tran_clearIdle.width+ares_frmmain.btn_tran_toggle_queup.width+7<ares_frmmain.btns_transfer.clientwidth then
  ares_frmmain.btn_tran_toggle_queup.left := (ares_frmmain.btns_transfer.clientwidth-ares_frmmain.btn_tran_toggle_queup.width)-3
  else ares_frmmain.btn_tran_toggle_queup.left := ares_frmmain.btn_tran_clearIdle.left+ares_frmmain.btn_tran_clearIdle.width+7;
end;

procedure Tares_frmmain.Splitter_chat_channelEndSplit(Sender: TObject);
begin
 splitter_chat_channel.top := splitter_chat_channel.top+splitter_chat_channel.ypos;

 chat_favorite_height := ares_frmmain.panel_list_channels.clientheight-splitter_chat_channel.top;
 if chat_favorite_height<150 then chat_favorite_height := 150;
 if chat_favorite_height+150>panel_chat.clientHeight then chat_favorite_height := panel_chat.clientHeight-150;

reg_save_chatfav_height;
panel_chatResize(panel_chat);
end;

procedure Tares_frmmain.panel_chatResize(Sender: TObject);
var
 i: Integer;
 processData:precord_chatProcessData;
begin
splitter_chat_channel.width := panel_list_channels.clientwidth;
splitter_chat_channel.componentTop := panel_chat.top+panel_list_channels.top+(integer(helper_skin.SkinnedFrameLoaded)*helper_skin.fcaptionHeight);
splitter_chat_channel.componentLefT := (integer(helper_skin.SkinnedFrameLoaded)*helper_skin.fborderWidth); //+panel_chat.left;
splitter_chat_channel.left := 0;
listview_chat_channel.Width := panel_list_channels.clientwidth;
pnl_chat_fav.width := panel_list_channels.clientWidth;

 splitter_chat_channel.visible := btn_chat_fav.down;
 pnl_chat_fav.visible := btn_chat_fav.down;
 
 if btn_chat_fav.down then begin
  pnl_chat_fav.height := chat_favorite_height;
  pnl_chat_fav.top := panel_list_channels.clientHeight-pnl_chat_fav.height;
  splitter_chat_channel.top := pnl_chat_fav.top-splitter_chat_channel.height;
  listview_chat_channel.height := splitter_chat_channel.top-listview_chat_channel.top;
 end else listview_chat_channel.height := panel_list_channels.clientHeight-listview_chat_channel.top;

{ if high(panel_chat.panels)>0 then
 i := 1;
 while (i<=high(panel_chat.panels) do begin
  pnl := panel_chat.panels[i];
  if pnl.id=IDXChatMain then begin
   processData := pnl.fData;
   if not isWindow(processData^.wnhandle) then begin
    panel_chat.DeletePanel(pnl);
    continue;
   end;
   SetWindowPos(processData^.wnhandle,0,0,0,processData^.containerPnl.ClientWidth,processData^.containerPnl.ClientHeight,SWP_NOZORDER);
   inc(i);
  end;
 end; }

end;

procedure Tares_frmmain.resizeChatChannel(Sender: TObject);
var
 i: Integer;
 pnl: Tcometpagepanel;
 processData:precord_chatProcessData;
begin
try

for i := 1 to high(panel_chat.panels) do begin
  pnl := panel_chat.panels[i];
  if pnl.id<>IDXChatMain then continue;
  if pnl.panel<>sender then continue;
   processData := pnl.fData;
   if processData.wnhandle=0 then exit;
   if not isWindow(processData^.wnhandle) then begin
    helper_channellist.tryFixChatHandle(processData);
     if not isWindow(processData^.wnhandle) then begin

      panel_chat.DeletePanel(pnl);
      exit;
     end;
   end;
   SetWindowPos(processData^.wnhandle,0,0,0,processData^.containerPnl.ClientWidth,processData^.containerPnl.ClientHeight,SWP_NOZORDER);
   exit;
end;

except
end;
end;

procedure Tares_frmmain.panel_chatPanelClose(Sender, aPanel: TObject; var Proceed: Boolean);
var
 pnl: Tcometpagepanel;
 processData:precord_chatProcessData;
begin
pnl := aPanel as TCometPagePanel;
Proceed := True;
try
 if pnl.id<>IDXChatMain then exit;

  processData := pnl.FData;
 try
  if isWindow(processData^.wnhandle) then begin
    SetWindowPos(processData^.wnhandle,0,0,0,0,0,SWP_NOZORDER);
    Windows.SetParent(processData^.wnhandle,processData^.oldParentWn);
    UpdateWindow(processData^.wnhandle);
    AttachThreadInput(GetCurrentThreadId, processData^.FAppThreadID, false);

    postMessage(processData^.wnhandle,WM_TERMINATECHAT,0,0);

    SetWindowLong(processData^.containerPnl.Handle, GWL_STYLE, GetWindowLong(processData^.containerPnl.Handle,GWL_STYLE) - WS_CLIPCHILDREN);
    freeAndNil(processData^.containerPnl);
   end else begin
    SetWindowLong(processData^.containerPnl.Handle, GWL_STYLE, GetWindowLong(processData^.containerPnl.Handle,GWL_STYLE) - WS_CLIPCHILDREN);
    SendMessage(processData^.containerPnl.Handle, WM_UPDATEUISTATE, UIS_INITIALIZE, 0);
    freeAndNil(processData^.containerPnl);
   end;
  except
  end;

  FreeMem(processData,sizeof(record_chatProcessData));
except
end;
end;

procedure Tares_frmmain.panel_chatPanelShow(Sender, aPanel: TObject);
var
 pnl: Tcometpagepanel;
 processData:precord_chatProcessData;

begin
pnl := aPanel as TCometPagePanel;
try
 SetForegroundWindow(pnl.panel.handle);
except
end;
try
 if pnl.id<>IDXChatMain then begin
  helper_channellist.SendNoticeHasFocus(nil);
  exit;
 end;

 pnl.FImageIndex := 2;
 processData := pnl.fdata;
 
 if (processData^.wnhandle>0) and (processData^.initialized) then begin

   if not isWindow(processData^.wnhandle) then begin
    helper_channellist.tryFixChatHandle(processData);
     if not isWindow(processData^.wnhandle) then begin

      panel_chat.DeletePanel(pnl);
      exit;
     end;
   end;

   helper_channellist.SendNoticeHasFocus(pnl);
  SetWindowPos(processData^.wnhandle,0,0,0,processData^.containerPnl.ClientWidth,processData^.containerPnl.ClientHeight,SWP_NOZORDER);
  SetForegroundWindow(processData^.wnhandle);
  if not helper_skin.skinnedFrameLoaded then SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, 1, 0);
 end;

except
end;
end;

procedure tares_frmmain.WMChatDataReceived(var M: TWMCopyData);
var
 strcmd: string;
 pnl: TCometPagePanel;
begin
strcmd := PRecToPass(PCopyDataStruct(m.CopyDataStruct)^.lpData)^.s;
try
 if copy(strCmd,1,5)='ACTIV' then begin
   setForeGroundWindow(application.handle);
   setForeGroundWindow(m.From);
     if not helper_skin.skinnedFrameLoaded then SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, 1, 0);
 end else
 if copy(strcmd,1,10)='UPDATENAME' then begin //chatChannel
    pnl := helper_channellist.findChatPanel(m.From);
    if pnl<>nil then begin
     helper_channellist.updateChatCaption(pnl,m.From);
    // panel_chatPanelShow(panel_chat,pnl);
     panel_chat.Resize;
    end;
 end else
 if copy(strcmd,1,6)='NEWMSG' then begin
   pnl := helper_channellist.findChatPanel(m.From);
    if pnl<>nil then begin
      if (tabs_pageview.activePage<>IDTAB_CHAT) or
         (panel_chat.activePanel<>pnl.panel) then begin  
          pnl.FImageIndex := 3;
          panel_chat.invalidate;
      end;
    end;
 end;
except
end;
end;

procedure Tares_frmmain.paintToolbar(sender: TObject; Acanvas: TCanvas; capt: WideString; var should_continue:boolean);
var
rc: TRect;
tbar: Tpanel;
begin
tbar := sender as tpanel;

acanvas.brush.color := COLORE_PANELS_SEPARATOR; //$00C9B7A9; //A9B7C9;
rc := rect(0,btns_transfer.Height-1,tbar.clientwidth,btns_transfer.Height);
acanvas.fillrect(rc);
end;

procedure Tares_frmmain.btn_tab_webXPButtonDraw(Sender: Tobject; TargetCanvas: Tcanvas; Rect: TRect; state:XPbutton.TCometBtnState; var should_continue:boolean);
 var
 Details: TThemedElementDetails;
 drawdetail: Boolean;
 gowithOsTheme: Boolean;
 pointx,wid: Integer;
begin
 //if ((not ThemeServices.ThemesEnabled) or (not VARS_THEMED_BUTTONS)) then begin
//  should_continue := True;
 // exit;
// end;
gowithOsTheme := (ThemeServices.ThemesEnabled) and (VARS_THEMED_BUTTONS);

if (not gowithOsTheme) and (helper_skin.buttonsBitmap=nil) then begin
 should_Continue := True;
 exit;
end;
   drawdetail := True;

   if (xpbutton.csClicked in state) and (xpbutton.csHover in state) then begin
      if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonPressed) else
        begin
           BitBlt(TargetCanvas.handle,rect.left,rect.Top,rect.left+helper_skin.buttonsClickedCopyPointA.y{placeholder of width},rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsClickedCopyPointA.x,0,SRCCopy);

           pointx := rect.left+helper_skin.buttonsClickedCopyPointA.y;
            while (pointX<rect.right) do begin
             wid := helper_skin.buttonsClickedCopyPointB.y;
             if wid=0 then break;
             if pointx+wid>rect.right then wid := rect.right-pointx;
              BitBlt(targetCanvas.Handle,pointx,rect.top,pointx+wid,rect.bottom-rect.top,
                     helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsClickedCopyPointB.x,0,SRCCopy);
              inc(pointX,wid);
           end;
           BitBlt(TargetCanvas.handle,rect.right-helper_skin.buttonsClickedCopyPointC.y,rect.Top,rect.right,rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsClickedCopyPointC.x,0,SRCCopy);
       end;

   end else

   if (xpbutton.csHover in state) then begin
    // if (xpbutton.csDown in state) then Details := ThemeServices.GetElementDetails(ttbButtonCheckedHot)
     //  else
        if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonHot) else
          begin
           BitBlt(TargetCanvas.handle,rect.left,rect.Top,rect.left+helper_skin.buttonsHoverCopyPointA.y{placeholder of width},rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsHoverCopyPointA.x,0,SRCCopy);

           pointx := rect.left+helper_skin.buttonsHoverCopyPointA.y;
            while (pointX<rect.right) do begin
             wid := helper_skin.buttonsHoverCopyPointB.y;
             if wid=0 then break;
             if pointx+wid>rect.right then wid := rect.right-pointx;
              BitBlt(targetCanvas.Handle,pointx,rect.top,pointx+wid,rect.bottom-rect.top,
                     helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsHoverCopyPointB.x,0,SRCCopy);
              inc(pointX,wid);
           end;
           BitBlt(TargetCanvas.handle,rect.right-helper_skin.buttonsHoverCopyPointC.y,rect.Top,rect.right,rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsHoverCopyPointC.x,0,SRCCopy);
          end;

   end else begin

    if (xpbutton.csDown in state) then begin

     if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonChecked) else
       begin
           BitBlt(TargetCanvas.handle,rect.left,rect.Top,rect.left+helper_skin.buttonsDownCopyPointA.y{placeholder of width},rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsDownCopyPointA.x,0,SRCCopy);

           pointx := rect.left+helper_skin.buttonsDownCopyPointA.y;
            while (pointX<rect.right) do begin
             wid := helper_skin.buttonsDownCopyPointB.y;
             if wid=0 then break;
             if pointx+wid>rect.right then wid := rect.right-pointx;
              BitBlt(targetCanvas.Handle,pointx,rect.top,pointx+wid,rect.bottom-rect.top,
                     helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsDownCopyPointB.x,0,SRCCopy);
              inc(pointX,wid);
           end;
           BitBlt(TargetCanvas.handle,rect.right-helper_skin.buttonsDownCopyPointC.y,rect.Top,rect.right,rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsDownCopyPointC.x,0,SRCCopy);
       end;

    end else begin

      if gowithOsTheme then drawdetail := false{ThemeServices.GetElementDetails(ttbButtonNormal)} else
       begin
           BitBlt(TargetCanvas.handle,rect.left,rect.Top,rect.left+helper_skin.buttonsCopyPointA.y{placeholder of width},rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsCopyPointA.x,0,SRCCopy);

           pointx := rect.left+helper_skin.buttonsCopyPointA.y;
            while (pointX<rect.right) do begin
             wid := helper_skin.buttonsCopyPointB.y;
             if wid=0 then break;
             if pointx+wid>rect.right then wid := rect.right-pointx;
              BitBlt(targetCanvas.Handle,pointx,rect.top,pointx+wid,rect.bottom-rect.top,
                     helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsCopyPointB.x,0,SRCCopy);
              inc(pointX,wid);
           end;
           BitBlt(TargetCanvas.handle,rect.right-helper_skin.buttonsCopyPointC.y,rect.Top,rect.right,rect.bottom,
                  helper_skin.buttonsBitmap.canvas.handle,helper_skin.buttonsCopyPointC.x,0,SRCCopy);
       end;

    end;
  end;

   if gowithOsTheme then begin
       //// Vista ////
     TargetCanvas.brush.color := (Sender as TXPButton).Color;
     TargetCanvas.FillRect(rect);
    /////////////////////////
    if drawdetail then begin
     TargetCanvas.Brush.Style := bsClear;
     ThemeServices.DrawElement(TargetCanvas.Handle, Details, Rect, @Rect);
    end;
   end;
   
   should_continue := False;
end;


procedure Tares_frmmain.pnl_chat_favResize(Sender: TObject);
begin
treeview_chat_favorites.height := (sender as tpanel).clientheight-18;
end;

procedure Tares_frmmain.panel_chatPaintCloseButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
pagepanel: TCometPagePanel;
Details: TThemedElementDetails;
begin
pagePanel := aPanel as TCometPagePanel;

if helper_skin.smallTabsSourceBitmap=nil then begin
 if ThemeServices.ThemesEnabled then begin
    if (bsHover in pagePanel.closeBtnState) then Details := ThemeServices.GetElementDetails(tbCheckBoxMixedHot)
     else Details := ThemeServices.GetElementDetails(tbCheckBoxMixedNormal);
     ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
 end else aCanvas.TextOut(paintRect.left,paintRect.top,'X');
 exit;
end;

if (bsHover in pagePanel.closeBtnState) then begin
 // aCanvas.brush.color := clblack;
 // aCanvas.pen.color := clblack;
 // aCanvas.framerect(paintRect);
  bitBlt(aCanvas.Handle,paintRect.left,paintRect.top,paintRect.Right-paintRect.left,paintRect.bottom-paintRect.top,
         helper_skin.smallTabsSourceBitmap.canvas.Handle,helper_skin.smalltabsHoverCloseBtnRect.left,helper_skin.smalltabsHoverCloseBtnRect.Top,SRCCOPY);

end else begin
 //aCanvas.brush.color := clgray;
 //aCanvas.pen.color := clgray;
 //aCanvas.framerect(paintRect);
  bitBlt(aCanvas.Handle,paintRect.left,paintRect.top,paintRect.Right-paintRect.left,paintRect.bottom-paintRect.top,
         helper_skin.smallTabsSourceBitmap.canvas.Handle,helper_skin.smalltabsOffCloseBtnRect.left,helper_skin.smalltabsOffCloseBtnRect.Top,SRCCOPY);

end;
end;



procedure Tares_frmmain.btns_optionsResize(Sender: TObject);
begin
if frm_settings=nil then exit;
frm_settings.Height := btns_options.clientheight-30;
frm_settings.Top := 30;
frm_settings.width := btns_options.clientwidth;
end;

procedure Tares_frmmain.pagesrcPanelShow(Sender, aPanel: TObject);
var
src:precord_panel_search;
pnl: TCometPagePanel;
begin

try
unbold_results;  // using last_shown_SRCtab
except
end;

pnl := aPanel as TCometPagePanel;
try
if ((pnl.Fdata=nil) or (pnl.ID=IDNone)) then begin
 lbl_src_status.caption := '';
 last_shown_SRCtab := 0;
 edit_src_filter.visible := False;
 combo_search.text := '';
 clear_search_fields;
 btn_stop_search.enabled := False;
 btn_start_search.enabled := True;
      edit_src_filter.Enabled := False;
 enable_search_fields;
 exit;
end;
except
end;


try

  src := pnl.FData;

    lbl_src_status.caption := src^.lbl_src_status_caption;
    edit_src_filter.visible := True;

    last_shown_SRCtab := pagesrc.activepage; //cares next unbolding

     if src^.is_advanced then label_more_searchopt.caption := GetLangStringW(LESS_SEARCH_OPTION_STR)
      else label_more_searchopt.caption := GetLangStringW(MORE_SEARCH_OPTION_STR);


    case src^.mime_search of
     ARES_MIME_GUI_ALL:radio_srcmime_all.checked := True;
     ARES_MIME_MP3:radio_srcmime_audio.checked := True;
     ARES_MIME_VIDEO:radio_srcmime_video.checked := True;
     ARES_MIME_IMAGE:radio_srcmime_image.checked := True;
     ARES_MIME_DOCUMENT:radio_srcmime_document.checked := True;
     ARES_MIME_SOFTWARE:radio_srcmime_software.checked := true
      else radio_srcmime_other.checked := True;
     end;

     //ufrmmain.ares_frmmain.RadiosearchmimeClick(nil);

     combo_search.text := src^.combo_search_text;
     comboalbsearch.text := src^.comboalbsearch_text;
     comboautsearch.text := src^.comboautsearch_text;
     combodatesearch.text := src^.combodatesearch_text;
     combotitsearch.text := src^.combotitsearch_text;
     combocatsearch.text := src^.combocatsearch_text;
     combo_lang_search.text := src^.combo_lang_search_text;

     combo_sel_duration.itemindex := src^.combo_sel_duration_index;
     combo_sel_quality.itemindex := src^.combo_sel_quality_index;
     combo_sel_size.itemindex := src^.combo_sel_size_index;
     combo_wanted_duration.itemindex := src^.combo_wanted_duration_index;
     combo_wanted_quality.itemindex := src^.combo_wanted_quality_index;
     combo_wanted_size.itemindex := src^.combo_wanted_size_index;



     if src^.started=0 then begin
      btn_stop_search.enabled := False;
      btn_start_search.enabled := True;
     end else begin
      btn_stop_search.enabled := True;
      btn_start_search.enabled := False;
     end;
      edit_src_filter.Enabled := src^.listview.Selectable;
       enable_search_fields;

 except
 end;
end;

procedure Tares_frmmain.pagesrcPanelClose(Sender, aPanel: TObject;
  var Proceed: Boolean);
var
pnl: TCometPagePanel;
src:precord_panel_search;
ind: Integer;
begin
 pnl := aPanel as TCometPagePanel;
 if pnl.ID=IDNone then begin
  proceed := False;
  exit;
 end;
 
 proceed := True;



try
 src := pnl.FData;
 if src^.started<>0 then gui_stop_search;

  clear_backup_results(src);
  src^.search_string := '';
  src^.lbl_src_status_caption := '';
  src^.combo_search_text := '';
  src^.comboalbsearch_text := '';
  src^.comboautsearch_text := '';
  src^.combodatesearch_text := '';
  src^.combotitsearch_text := '';
  src^.combocatsearch_text := '';
  src^.combo_lang_search_text := '';

  clear_treeview(src^.listview);
  src^.listview.Free;
  src^.containerPanel.Free;

  if src_panel_list<>nil then begin
   ind := src_panel_list.indexof(src);
   if ind<>-1 then src_panel_list.delete(ind);
  end;

  FreeMem(src,sizeof(record_panel_search));
  cambiato_search := True; //let the client know

except
end;
//pagesrc.ActivePage := 0;
end;



procedure Tares_frmmain.edit_src_filterClick(Sender: TObject);
begin
if edit_src_filter.text=GetLangStringW(STR_FILTER) then edit_src_filter.text := '';
end;

procedure Tares_frmmain.edit_lib_searchPaint(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect; btnState: TCometBtnState);
var
edit: TCometBtnEdit;
begin
edit := sender as tcometBtnEdit;
acanvas.brush.color := edit.color;
acanvas.FillRect(paintRect);
imagelist_chat.Draw(aCanvas,paintRect.left,paintRect.top,edit.glyphindex);
end;

procedure Tares_frmmain.edit_lib_searchClick(Sender: TObject);
begin
if edit_lib_search.text=GetLangStringW(STR_SEARCH) then edit_lib_search.text := '';
end;

procedure Tares_frmmain.edit_lib_searchBtnClick(Sender: TObject);
begin

if edit_lib_search.glyphindex<>12 then begin
 if btn_lib_virtual_view.down then treeview_lib_virfoldersclick(nil)
  else treeview_lib_regfoldersclick(nil);
  edit_lib_search.text := '';
end else edit_lib_search.text := '';

edit_lib_search.glyphindex := 12;

end;

procedure Tares_frmmain.edit_chat_chanfilterBtnClick(Sender: TObject);
begin
if edit_chat_chanfilter.glyphindex<>12 then begin
  edit_chat_chanfilter.text := '';
  mainGui_trigger_channelfilter;
  edit_lib_search.glyphindex := 12;
end else edit_chat_chanfilter.text := '';


end;

procedure Tares_frmmain.edit_chat_chanfilterClick(Sender: TObject);
begin
if edit_chat_chanfilter.text=GetLangStringW(STR_FILTER) then edit_chat_chanfilter.text := '';
end;

procedure Tares_frmmain.edit_chat_chanfilterBtnStateChange(
  Sender: TObject);
begin
//
end;

procedure Tares_frmmain.edit_src_filterBtnClick(Sender: TObject);
var
wor: Word;
begin
 if edit_src_filter.glyphindex<>12 then begin
  edit_src_filter.text := '';
  wor := 13;
  edit_src_filterkeyup(edit_src_filter,wor,[]);
  edit_src_filter.glyphindex := 12;
 end else edit_src_filter.text := '';
end;

procedure Tares_frmmain.listview_libPaintHeader(Sender: TBaseCometTree;
  TargetCanvas: TCanvas; R: TRect; isDownIndex, isHoverIndex: Boolean;
  var shouldContinue: Boolean);

var
pointX,wid: Integer;
begin
if (helper_skin.listviewHeaderBitmap=nil) or (VARS_THEMED_HEADERS) then begin
 shouldContinue := True;
 exit;
end;

//targetcanvas.brush.color := clgray;
//targetcanvas.framerect(r);
shouldContinue := False;

if ((not isDownIndex) and (not isHoverIndex)) then begin
  bitBlt(TargetCanvas.handle,r.left,r.top,r.left+helper_skin.listviewHeaderCopyPointA.y{placeholder for width},r.bottom-r.top,
         helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderCopyPointA.x,0,SRCCOPY);

  pointx := r.left+helper_skin.listviewHeaderCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
  while (pointX<r.right) do begin
   wid := helper_skin.listviewHeaderCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>r.right then wid := r.right-pointx;
   BitBlt(targetCanvas.Handle,pointx,r.top,pointx+wid,r.bottom-r.top,
          helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderCopyPointB.x,0,SRCCopy);
     inc(pointX,wid);
   end;
   
end else
if (isHoverIndex) and (not isDownIndex) then begin
  bitBlt(TargetCanvas.handle,r.left,r.top,r.left+helper_skin.listviewHeaderHoverCopyPointA.y{placeholder for width},r.bottom-r.top,
         helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderHoverCopyPointA.x,0,SRCCOPY);

  pointx := r.left+helper_skin.listviewHeaderHoverCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
  while (pointX<r.right) do begin
   wid := helper_skin.listviewHeaderHoverCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>r.right then wid := r.right-pointx;
   BitBlt(targetCanvas.Handle,pointx,r.top,pointx+wid,r.bottom-r.top,
          helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderHoverCopyPointB.x,0,SRCCopy);
     inc(pointX,wid);
   end;

end else begin
  bitBlt(TargetCanvas.handle,r.left,r.top,r.left+helper_skin.listviewHeaderDownCopyPointA.y{placeholder},r.bottom-r.top,
         helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderDownCopyPointA.x,0,SRCCOPY);

  pointx := r.left+helper_skin.listviewHeaderDownCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
  while (pointX<r.right) do begin
   wid := helper_skin.listviewHeaderDownCopyPointB.y;
   if wid=0 then break;
   if pointx+wid>r.right then wid := r.right-pointx;
   BitBlt(targetCanvas.Handle,pointx,r.top,pointx+wid,r.bottom-r.top,
          helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderDownCopyPointB.x,0,SRCCopy);
     inc(pointX,wid);
   end;
    bitBlt(TargetCanvas.handle,r.right-helper_skin.listviewHeaderDownCopyPointC.y,r.top,r.right,r.bottom-r.top,
         helper_skin.listviewHeaderBitmap.canvas.handle,helper_skin.listviewHeaderDownCopyPointC.x,0,SRCCOPY);
end;

   if sender=listview_chat_channel then begin
    dec(r.top);
    TargetCanvas.brush.color := (sender as tcomettree).color;
    TargetCanvas.fillrect(rect(r.left,r.Top,r.right,r.top+2));
    inc(r.top,2);
    exit;
   end;

if (sender<>listview_lib) and
   (sender<>treeview_download) and
   (sender<>treeview_upload) and
   (sender<>treeview_queue) and
   (sender<>listview_chat_channel) then begin

   if sender.parent<>nil then
    if sender.parent.parent<>nil then
     if sender.parent.parent=pagesrc then exit; // search

    if tabs_pageview.activepage=IDTAB_CHAT then begin
      if panel_chat.activepage>high(panel_chat.panels) then exit; //deleting panel?
     if (panel_chat.panels[panel_chat.activepage].ID=IDXChatSearch) or (panel_chat.panels[panel_chat.activepage].ID=IDXChatBrowse) then exit;
    end;

    TargetCanvas.brush.color := (sender as tcomettree).colors.BorderColor;
    TargetCanvas.fillrect(rect(r.left,r.Top,r.right,r.top+1));
end;

end;

procedure Tares_frmmain.AddRemovefolderstosharelist2Click(Sender: TObject);
begin
tabs_pageview.activepage := IDTAB_OPTION;
frm_settings.settings_control.activePage := 7;
end;

procedure Tares_frmmain.tray_showPlaylistClick(Sender: TObject);
begin
if widestrtoutf8str(tray_minimize.caption)<>GetLangStringA(STR_HIDE_ARES) then tray_MinimizeClick(nil);
 toggle_playlist;
end;

procedure Tares_frmmain.Stop2Click(Sender: TObject);
begin
helper_player.stopmedia(sender);
end;

procedure Tares_frmmain.panel_playlistPaint(sender: TObject;
  Acanvas: TCanvas; capt: WideString; var should_continue: Boolean);
var
 widestr: WideString;
 r: TRect;
 pnl: TCometTopicPnl;
begin
should_Continue := True;
if sender=panel_playlist then begin
 r := rect(0,0,panel_playlist.width,20);
 acanvas.brush.color := panel_playlist.color;
 acanvas.pen.Color := cl3ddkshadow;
 acanvas.rectangle(r.left-1,r.top,r.right+1,r.bottom);
 widestr := GetLangStringW(STR_PLAYLIST);
 SetBkMode(acanvas.Handle, TRANSPARENT);
 Windows.ExtTextOutW(acanvas.Handle, r.left+6, r.top+3, 0, @r, PwideChar(widestr),Length(widestr), nil);
end else
if sender=panel_hash then begin
 r := rect(0,0,panel_playlist.width,20);
 acanvas.brush.color := panel_hash.color;
 acanvas.pen.Color := listview_lib.colors.bordercolor;
 acanvas.rectangle(r.left-1,r.top-1,r.right+1,r.bottom);
end else begin  // chat browse's panel left
 pnl := sender as tcometTopicPnl;
 r := rect(0,0,pnl.width,26);
 acanvas.brush.color := pnl.color;
 acanvas.pen.Color := listview_lib.colors.bordercolor;
 acanvas.rectangle(r.left-1,r.top-1,r.right,r.bottom);
end;

end;

procedure Tares_frmmain.radio_srcmime_audioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if btn_stop_search.enabled then btn_stop_searchclick(nil);
end;

procedure Tares_frmmain.TntFormPaint(Sender: TObject);
begin
if not helper_skin.SkinnedFrameLoaded then inherited
 else paintFrame;
end;



procedure Tares_frmmain.Shoutcast1Click(Sender: TObject);
begin
utility_ares.browser_go('http://www.internet-radio.com/');
end;

procedure Tares_frmmain.uner21Click(Sender: TObject);
begin
utility_ares.browser_go('http://www.tuner2.com');
end;

procedure Tares_frmmain.RadioToolbox1Click(Sender: TObject);
begin
utility_ares.browser_go('http://www.radiotoolbox.com/dir/');
end;

procedure Tares_frmmain.tray_StopClick(Sender: TObject);
begin
stopmedia(sender);
end;

procedure Tares_frmmain.listview_playlistPaintText(Sender: TBaseCometTree;
  const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
begin
if (vsSelected in node.states) then
Targetcanvas.Font.color := clwhite;
end;

procedure tares_frmmain.NetPlayerFSCommand(ASender: TObject; const command, args: WideString);
begin
if command='size' then begin
 unetPlayer.NETPlayerWidth := strtointdef(copy(args,1,pos('|',args)-1),640);
 unetPlayer.NETPlayerHeight := strtointdef(copy(args,pos('|',args)+1,length(args)),480);

  if (unetPlayer.NETPlayerHeight>0) and (unetPlayer.NETPlayerWidth>0) then unetPlayer.NETPlayerGeometry := unetPlayer.NETPlayerWidth/unetPlayer.NETPlayerHeight else unetPlayer.NETPlayerGeometry := 1.333333333333333; //4:3
  resizeNETPlayer;
  ares_frmmain.mplayerpanel1.wcaption := caption_player+'    '+GetLangStringW(STR_CONNECTING_TO_NETWORK)+'..';
end else
if command='time' then begin

  ares_frmmain.mplayerpanel1.wcaption := caption_player; //playing
  unetPlayer.NETPlayerPosition := trunc(strtofloatdef(copy(args,1,pos('|',args)-1),0));
  //unetPlayer.NETPlayerLength := trunc(strtofloatdef(copy(args,pos('|',args)+1,length(args)),0));
  if unetPlayer.NETPlayerPosition>unetPlayer.NETPlayerLength  then unetPlayer.NETPlayerLength := unetPlayer.NETPlayerPosition;


  trackbar_player.OnChanged := nil;
  trackbar_player.max := unetPlayer.NETPlayerLength*1000;
  trackbar_player.Position := unetPlayer.NETPlayerPosition*1000;
  trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;
  //mplayerpanel1.wcaption := 'Playing';
  if not trackbar_player.trackbarEnabled then mplayerpanel1.TimeCaption := format_time(unetPlayer.NETPlayerPosition) else
   mplayerpanel1.TimeCaption := format_time(unetPlayer.NETPlayerPosition)+' / '+
                               format_time(unetPlayer.NETPlayerLength);
 end else
if command='Stream' then begin
 //Start-Stop
 if args='Stop' then filtroGraphComplete(nil,0,nil) else
 if args='Buffer.Full' then begin
   ares_frmmain.mplayerpanel1.wcaption := caption_player+'    '+GetLangStringW(STR_CONNECTING_TO_NETWORK)+'...';
 end else
 if args='Connected' then begin
 end else
 if (args='NetStream.Failed') or
    (args='NetConnection.Connect.Rejected') or
    (args='NetConnection.Connect.Closed') then begin
  ares_frmmain.mplayerpanel1.wcaption := caption_player+'    '+GetLangStringW(STR_UNABLE_TO_CONNECT);
  unetPlayer.NETPlayer.onFsCommand := nil;
  FreeAndNil(unetPlayer.NETPlayer);
 end;

end;
end;

procedure tares_frmmain.FlashPlayerFSCommand(ASender: TObject; const command, args: WideString);
begin
if command='size' then begin
 uflvPlayer.FLVWidth := strtointdef(copy(args,1,pos('|',args)-1),640);
 uflvPlayer.FLVHeight := strtointdef(copy(args,pos('|',args)+1,length(args)),480);

  if (uflvPlayer.FLVHeight>0) and (uflvPlayer.FLVWidth>0) then uflvPlayer.FLVGeometry := uflvPlayer.FLVWidth/uflvPlayer.FLVHeight else uflvPlayer.FLVGeometry := 1.333333333333333; //4:3
  resizeFLVPlayer;

end else
if command='time' then begin


  uflvPlayer.FLVPosition := trunc(strtofloatdef(copy(args,1,pos('|',args)-1),0));
  uflvPlayer.FLVLength := trunc(strtofloatdef(copy(args,pos('|',args)+1,length(args)),0));
  if uflvPlayer.FLVPosition>uflvPlayer.FLVLength  then uflvPlayer.FLVLength := uflvPlayer.FLVPosition;


  trackbar_player.OnChanged := nil;
  trackbar_player.max := uflvPlayer.FLVLength*1000;
  trackbar_player.Position := uflvPlayer.FLVPosition*1000;
  trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;
  //mplayerpanel1.wcaption := 'Playing';
   mplayerpanel1.TimeCaption := format_time(uflvPlayer.FLVPosition)+' / '+
                               format_time(uflvPlayer.FLVLength);

  {uflvplayer.FLVPosition := strtointdef(args,0);

  if uflvplayer.FLVPosition>=uflvplayer.FLVLength then begin
   filtroGraphComplete(nil,0,nil);
   exit;
  end;

  ares_frmmain.trackbar_player.OnChanged := nil;
  ares_frmmain.trackbar_player.Position := uflvplayer.FLVPosition;
  ares_frmmain.trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;

   ares_frmmain.mplayerpanel1.TimeCaption := format_time(uflvplayer.FLVPosition div 1000)+' / '+
                                           format_time(uflvplayer.FLVLength div 1000); }

end else
if command='Stream' then begin
 //Start-Stop
 if args='Stop' then filtroGraphComplete(nil,0,nil);

end;
end;

procedure Tares_frmmain.resizeFLVPlayer;
const
WM_MOUSEDOWN = $201;
var
  desiredWidth,desiredHeight:double;
begin
if uflvplayer.FLVPlayer=nil then exit;
    DesiredWidth := panel_vid.width;
    DesiredHeight := DesiredWidth/uflvplayer.FLVGeometry;
    if DesiredHeight>panel_vid.height then begin
     DesiredHeight := panel_vid.height;
     DesiredWidth := DesiredHeight*uflvplayer.FLVGeometry;
    end;
    if DesiredWidth>panel_vid.width then begin
     DesiredWidth := panel_vid.width;
     DesiredHeight := DesiredWidth/uflvplayer.FLVGeometry;
    end;
    //showmessage(inttostr(videostage.clientwidth)+'x'+inttostr(videostage.clientheight)+'   '+inttostr(trunc(DesiredWidth))+'x'+inttostr(trunc(DesiredHeight)));
   // uflvplayer.FLVPlayer.width := trunc(DesiredWidth);
   // uflvplayer.FLVPlayer.height := trunc(DesiredHeight);
   // uflvplayer.FLVPlayer.left := (panel_vid.clientwidth div 2)-(trunc(DesiredWidth) div 2); //212;
   // uflvplayer.FLVPlayer.top := (panel_vid.clientheight div 2)-(trunc(DesiredHeight) div 2); //162;
    uflvplayer.FLVPlayer.setBounds((panel_vid.clientwidth div 2)-(trunc(DesiredWidth) div 2),
                                   (panel_vid.clientheight div 2)-(trunc(DesiredHeight) div 2),
                                   trunc(DesiredWidth),
                                   trunc(DesiredHeight));

     uflvplayer.FLVPlayer.CreateWnd;

    //showmessage(inttostr(FLVPlayer.left)+'x'+inttostr(FLVPlayer.top)+'   '+inttostr(trunc(DesiredWidth))+'x'+inttostr(trunc(DesiredHeight)));
    sendmessage(uflvplayer.FLVPlayer.Handle,WM_MOUSEDOWN,0,0);
   // FLVPlayer.SAlign
end;

procedure tares_frmmain.resizeNETPlayer;
const
WM_MOUSEDOWN = $201;
var
  desiredWidth,desiredHeight:double;
begin
if unetPlayer.NETPlayer=nil then exit;
    DesiredWidth := panel_vid.width;
    DesiredHeight := DesiredWidth/unetPlayer.NETPlayerGeometry;
    if DesiredHeight>panel_vid.height then begin
     DesiredHeight := panel_vid.height;
     DesiredWidth := DesiredHeight*unetPlayer.NETPlayerGeometry;
    end;
    if DesiredWidth>panel_vid.width then begin
     DesiredWidth := panel_vid.width;
     DesiredHeight := DesiredWidth/unetPlayer.NETPlayerGeometry;
    end;
    //showmessage(inttostr(videostage.clientwidth)+'x'+inttostr(videostage.clientheight)+'   '+inttostr(trunc(DesiredWidth))+'x'+inttostr(trunc(DesiredHeight)));
    unetPlayer.NETPlayer.setBounds((panel_vid.clientwidth div 2)-(trunc(DesiredWidth) div 2),
                                   (panel_vid.clientheight div 2)-(trunc(DesiredHeight) div 2),
                                   trunc(DesiredWidth),
                                   trunc(DesiredHeight));
    //unetPlayer.NETPlayer.setFocus;
    unetPlayer.NETPlayer.CreateWnd;
    {unetPlayer.NETPlayer.width := trunc(DesiredWidth);
    unetPlayer.NETPlayer.height := trunc(DesiredHeight);
    unetPlayer.NETPlayer.left := (panel_vid.clientwidth div 2)-(trunc(DesiredWidth) div 2); //212;
    unetPlayer.NETPlayer.top := (panel_vid.clientheight div 2)-(trunc(DesiredHeight) div 2); //162;  }
    //showmessage(inttostr(FLVPlayer.left)+'x'+inttostr(FLVPlayer.top)+'   '+inttostr(trunc(DesiredWidth))+'x'+inttostr(trunc(DesiredHeight)));
    sendmessage(unetPlayer.NETPlayer.Handle,WM_MOUSEDOWN,0,0);
   // FLVPlayer.SAlign
end;

procedure Tares_frmmain.btn_chat_hostClick(Sender: TObject);
begin
Tnt_ShellExecuteW(0,'open',pwidechar(utf8strtowidestr(app_path+'\ChatServer.exe')),'','',SW_SHOWNORMAL);
end;

procedure Tares_frmmain.timer_start_bittorrentTimer(Sender: TObject);
var
 templist: TMylist;
 i: Integer;
 BitTorrentTransfer: TBittorrentTransfer;
begin
try
timer_start_bittorrent.enabled := False;
 
  if vars_global.bittorrent_Accepted_sockets=nil then vars_global.bittorrent_Accepted_sockets := tmylist.create;
  if vars_global.BitTorrentTempList=nil then vars_global.BitTorrentTempList := tmylist.create;

  if vars_global.thread_bittorrent=nil then begin
           vars_global.thread_bittorrent := tthread_bitTorrent.create(true);
           vars_global.thread_bittorrent.BittorrentTransfers := tmylist.create;
           vars_global.thread_bittorrent.resume;
  end;

  tempList := Tmylist(timer_start_bittorrent.tag);
  for i := 0 to tempList.count-1 do begin
     bittorrentTransfer := tempList[i];
     vars_global.BitTorrentTempList.add(bittorrentTransfer);
  end;
  tempList.Free;

except
end;
end;

procedure Tares_frmmain.splitter_screenEndSplit(Sender: TObject);
begin
with splitter_screen do begin
 invalidate;
 left := left+xpos;
 panelScreensizedefault := left;
end;

if panelScreensizedefault>100 then begin
 set_reginteger('GUI.ScreenTVWidth',panelScreensizedefault);
end;

panel_screenResize(panel_screen);
end;

procedure Tares_frmmain.panel_screenResize(Sender: TObject);
begin
splitter_screen.top := 0;
tvchannels.top := -3;
tvchannels.left := -2;
splitter_screen.componentTop := (sender as tpanel).top+(integer(helper_skin.SkinnedFrameLoaded)*helper_skin.fcaptionHeight);
    with splitter_screen do begin
     visible := True;
     height := (sender as tpanel).clientheight;
    end;
    splitter_screen.left := panelScreensizedefault;
    splitter_screen.width := 3;
    tvchannels.width := splitter_screen.Left+4;

    tvchannels.height := panel_screen.clientHeight+3;
    panel_vid.left := splitter_screen.left+splitter_screen.width;
    panel_vid.width := panel_screen.clientwidth-panel_vid.left;
    panel_vid.height := panel_screen.clientheight;
end;

procedure Tares_frmmain.tvchannelsPaintText(Sender: TBaseCometTree;
  const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
begin
if (vsselected in node.states) then begin
 if tvchannels.GetNodeLevel(node)>0 then targetcanvas.font.color := clhighlighttext else targetcanvas.Font.color := COLORE_LISTVIEWS_FONT;
 end
   else targetcanvas.Font.color := COLORE_LISTVIEWS_FONT;

end;

procedure Tares_frmmain.tvchannelsGetSize(Sender: TBaseCometTree;
  var Size: Integer);
begin
size := sizeof(ares_types.recordNetStreamChannel);
end;

procedure Tares_frmmain.tvchannelsGetText(Sender: TBaseCometTree;
  Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
 channel:ares_types.precordNetStreamChannel;
begin
if tvchannels.GetNodeLevel(node)=0 then exit;
 channel := sender.getData(node);
case column of
 0:cellText := channel^.capt;
 1:cellText := channel^.language;
end;
end;

procedure Tares_frmmain.tvchannelsFreeNode(Sender: TBaseCometTree;
  Node: PCmtVNode);
var
 channel:ares_types.precordNetStreamChannel;
begin
channel := sender.getData(node);
 channel^.capt := '';
 channel^.language := '';
 channel^.streamUrl := '';
 channel^.streamPlaypath := '';
 channel^.webCapt := '';
 channel^.webUrl := '';

end;

procedure Tares_frmmain.tvchannelsAfterCellPaint(Sender: TBaseCometTree;
  TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;
  CellRect: TRect);
var
 channel:ares_types.precordNetStreamChannel;
 rect2: TRect;
begin
//if column<>0 then exit;
if tvchannels.GetNodeLevel(node)>0 then exit;
 
 channel := sender.getData(node);
 targetcanvas.Font.style := [fsBold];

 targetCanvas.brush.color := COLORE_PANELS_SEPARATOR;
 targetCanvas.fillrect(cellrect);
  rect2.left := cellrect.left;
  rect2.top := cellrect.top+1;
  rect2.right := cellrect.right;
  rect2.bottom := cellrect.bottom-1;
 targetCanvas.brush.color := clbtnface; //tvchannels.colors.hotcolor;
 targetCanvas.fillrect(rect2);

 if column=0 then targetCanvas.TextOut(cellrect.Left+6,cellrect.top+2,channel^.capt);
//end else targetcanvas.Font.style := [];
end;

procedure Tares_frmmain.tvchannelsDblClick(Sender: TObject);
var
 node:pcmtvnode;
 channel:ares_types.precordNetStreamChannel;
 rootNode:pcmtVnode;
 dataRoot:ares_types.precordNetStreamChannel;
begin

if not helper_player.player_working then exit;
node := tvchannels.getFirstSelected;
if tvchannels.GetNodeLevel(node)<>2 then exit;
 channel := tvChannels.getData(node);

 rootNode := node.parent.parent;
 dataRoot := tvchannels.GetData(rootNode);
 if dataRoot^.capt='Internet Radio' then OpenRadioUrl(channel^.streamUrl) else begin
  player_actualfile := channel^.streamUrl+'|'+channel^.streamPlaypath+'|'+channel^.webUrl+'|'+channel^.webCapt+'|'+channel^.capt;
  player_playnew(player_actualfile,false);
 end;

end;

procedure Tares_frmmain.tvchannelsCompareNodes(Sender: TBaseCometTree;
  Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
channel1,channel2:ares_types.precordNetStreamChannel;
begin
//result := 0;
//if tvchannels.GetNodeLevel(node1)<>2 then exit;
//if tvchannels.GetNodeLevel(node2)<>2 then exit;

 channel1 := sender.getdata(Node1);
 channel2 := sender.getdata(Node2);

case column of
 0: Result := CompareText(channel1.capt, channel2.capt);
 1: Result := CompareText(channel1.language, channel2.language);
end;
end;

procedure Tares_frmmain.tvchannelsHeaderClick(Sender: TCmtHdr;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
node:pcmtvnode;
list: TMylist;
i: Integer;
begin
if not tvchannels.Selectable then exit;
with sender do begin
  sortcolumn := column;
   if sortdirection=sdAscending then sortdirection := sdDescending
    else sortdirection := sdAscending;
end;

list := tmylist.create;

node := tvchannels.getFirst;
while (node<>nil) do begin
 if tvchannels.GetNodeLevel(node)<>1 then begin
  node := tvchannels.getNext(node);
  continue;
 end;
 list.add(node);

 node := tvchannels.getNext(node);
end;

for i := 0 to list.count-1 do begin
 node := list[i];
 tvchannels.Sort(node,column,sender.sortdirection);
end;
list.Free;

end;

procedure Tares_frmmain.tvchannelsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 node:pcmtvnode;
begin
node := tvchannels.GetNodeAt(x,y);
if node=nil then exit;
if tvchannels.GetNodeLevel(node)=0 then begin
  if vsExpanded in node.States then tvChannels.FullCollapse(node)
   else tvChannels.Expanded[node] := True;
end;
end;

procedure Tares_frmmain.play_netstreamClick(Sender: TObject);
begin
tvchannelsDblClick(nil);
end;

procedure Tares_frmmain.tvchannelsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 node,node1:pcmtvnode;
 point: TPoint;
begin
node := tvChannels.getFirstSelected;

if node=nil then exit;
if tvChannels.getNodeLevel(node)<>2 then exit;

node1 := tvChannels.getNodeAt(x,y);
if node<>node1 then exit;
getcursorpos(point);
popup_screen_netstreams.popup(point.x,point.y);
end;


procedure Tares_frmmain.JoinTemplate1Click(Sender: TObject);
begin
vars_global.chat_enabled_remoteJSTemplate := not vars_global.chat_enabled_remoteJSTemplate;
Joinchannel1Click(nil);
vars_global.chat_enabled_remoteJSTemplate := not vars_global.chat_enabled_remoteJSTemplate;
end;

procedure Tares_frmmain.JoinTemplate2Click(Sender: TObject);
begin
vars_global.chat_enabled_remoteJSTemplate := not vars_global.chat_enabled_remoteJSTemplate;
Join1Click(nil);
vars_global.chat_enabled_remoteJSTemplate := not vars_global.chat_enabled_remoteJSTemplate;
end;









procedure Tares_frmmain.timerSetChatIDXTimer(Sender: TObject);
begin
timerSetChatIDX.enabled := False;
panel_chat.activePage := panel_chat.PanelsCount-1;
end;

initialization
ThemeServices := TThemeServices.Create;
OleInitialize(nil);

finalization
ThemeServices.Free;
OleUninitialize;

end.








