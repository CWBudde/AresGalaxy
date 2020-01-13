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
global variables, some related to threads
}

unit vars_global;

interface

uses
  classes2,thread_terminator,DSPack,ufrmhint,classes,windows,graphics,
  ares_types,comettrees,tntmenus,thread_upload,thread_download,
  thread_client,thread_supernode,thread_share,int128,ares_objects,
  helper_autoscan,thread_dht,blcksock,synsock,dhtzones,
  dhttypes,thread_bittorrent,tntforms,forms,helper_channellist{,
  thread_webtorrent};

var
  COLOR_DL_COMPLETED,
  COLOR_UL_COMPLETED,
  COLOR_UL_CANCELLED,
  COLOR_PROGRESS_DOWN,
  COLOR_PROGRESS_UP,
  COLOR_OVERLAY_UPLOAD,
  COLORE_ALTERNATE_ROW,
  COLORE_LISTVIEW_HOT,
  COLORE_TRANALTERNATE_ROW,
  COLORE_HINT_BG,
  COLORE_HINT_FONT,
  COLORE_GRAPH_BG,
  COLORE_GRAPH_GRID,
  COLORE_PLAYER_BG,
  COLORE_PLAYER_FONT,
  COLORE_LISTVIEWS_BG,
  COLORE_LISTVIEWS_FONT,
  COLORE_LISTVIEWS_FONTALT1,
  COLORE_LISTVIEWS_FONTALT2,
  COLORE_LISTVIEWS_GRIDLINES,
  COLORE_LISTVIEWS_TREELINES,
  COLORE_PARTIAL_UPLOAD,
  COLORE_PARTIAL_DOWNLOAD,
  COLORE_GRAPH_INK,
  COLORE_SEARCH_PANEL,
  COLORE_LIBDETAILS_PANEL,
  COLORE_FONT_SEARCHPNL,
  COLORE_FONT_LIBDET,
  COLORE_PANELS_SEPARATOR,
  COLORE_PANELS_BG,
  COLORE_PANELS_FONT,
  COLORE_LISTVIEWS_HEADERBK,
  COLORE_LISTVIEWS_HEADERFONT,
  COLORE_LISTVIEWS_HEADERBORDER,
  COLOR_MISSING_CHUNK,
  COLOR_CHUNK_COMPLETED,
  COLOR_PARTIAL_CHUNK,
  COLORE_DLSOURCE,
  COLORE_PHASH_VERIFY,
  COLORE_TOOLBAR_BG,
  COLORE_TOOLBAR_FONT,
  COLORE_ULSOURCE_CHUNK: Tcolor;
  VARS_SCREEN_LOGO: WideString;
  SETTING_3D_PROGBAR,
  VARS_THEMED_BUTTONS,
  VARS_THEMED_HEADERS,
  VARS_THEMED_PANELS: Boolean;


  glob_shared_mem:ares_objects.tsharedmemory;
  initialized: Boolean;
  app_minimized: Boolean;
  mute_on: Boolean;
  closing: Boolean;
  last_shown_SRCtab: Byte;
  InternetConnectionOK: Boolean;
  trayinternetswitch: Boolean;

  maxScoreChannellist: Word;
  //thread_webtorrent: Tthread_webtorrent;
  thread_up: Tthread_upload;
  thread_down: Tthread_download;
  client: Tthread_client;
  hash_server: Tthread_supernode;
  chanlistthread: Tthread_udp_channellist;
  share: Tthread_share;

  search_dir: Tthread_search_dir;
  IDEIsRunning: Boolean;
  chat_favorite_height: Integer;
  typed_lines_chat: TMyStringList;
  typed_lines_chat_index: Integer;
  num_seconds: Byte;
  isvideoplaying: Boolean;
  StopAskingChatServers: Boolean;

  last_mem_check: Cardinal;
  image_less_top,image_more_top,image_back_top: Integer;
  allow_regular_paths_browse: Boolean;
  browse_type: Byte;
  ip_user_granted: Cardinal;
  port_user_granted: Word;
  ip_alt_granted: Cardinal;

  chat_chanlist_backup: TMylist;

  fresh_downloaded_files: TMylist;
  terminator: Tthread_terminator;
  queue_firstinfirstout: Boolean;
  src_panel_list: TMylist;
  filtro2: TFilterGraph;
  formhint: Tfrmhint;
  MAX_OUTCONNECTIONS: Integer; //sp2 limit download outgoing sources
  block_pm,block_pvt_chat: Boolean;
  max_dl_allowed: Byte;
  up_band_allow,down_band_allow: Cardinal;
  numero_upload,numero_download,numero_queued,numTorrentDownloads,
  numTorrentUploads,speedTorrentDownloads,speedTorrentUploads: Cardinal;
  downloadedBytes,BitTorrentDownloadedBytes,BitTorrentUploadedBytes: Int64;
  lista_shared: TMylist;
  should_show_prompt_nick: Boolean;
  MAX_SIZE_NO_QUEUE: Cardinal;
   app_path: WideString;
   data_path: WideString;
  versioneares: string;
  mega_uploaded,mega_downloaded: Integer;
  hashing: Boolean;
  lista_down_temp: TMylist;
  cambiato_search: Boolean;
  program_totminuptime,program_start_time,program_first_day: Cardinal;
  my_shared_count: Integer;
  im_firewalled: Boolean;
  logon_time: Cardinal;
  velocita_att_upload,velocita_att_download: Cardinal;
  LanIPC: Cardinal;
  LanIPS: string;
  prev_cursorpos: TPoint;
  minutes_idle: Cardinal;
  socks_type: Tsocks_type;
  socks_password,socks_username,socks_ip: string;
  socks_port: Word;
  global_supernode_port: Word;


  chat_enabled_remoteJSTemplate: Boolean;

  stopped_by_user: Boolean;
  font_chat: Tfont;
  ares_aval_nodes: TthreadList;
  should_send_channel_list: Boolean;
  need_rescan: Boolean;
  scan_start_time: Cardinal;
  queue_length: Byte;
  mypgui: string;
  previous_hint_node:pcmtvnode;
  handle_obj_GraphHint: Cardinal;
  graphIsDownload,graphIsUpload: Boolean;
  max_ul_per_ip: Byte;
  shufflying_playlist: Boolean;
  buildno: Cardinal;
  FSomeFolderChecked: Boolean;
  changed_download_hashes: Boolean;
  ShareScans: Cardinal;
  update_my_nick: Boolean;
  playlist_visible: Boolean;
  velocita_up: Cardinal;
  velocita_down:dword;
  oldhintposx,oldhintposy: Integer;
  limite_upload: Byte;
  hash_select_in_library: string;
  user_sex: Byte;
  user_age: Byte;
  user_country: Word;
  user_statecity: string;
  defLangEnglish: Boolean;
  myport: Word;
  mynick: string;
  file_visione_da_copiatore,caption_player: WideString;
  panel6sizedefault,panelScreensizedefault,panelUploadHeight,default_width_chat: Integer;
  ending_session: Boolean;
  blendPlaylistForm: Tform;
  localip: string;
  localipC: Cardinal;
  myshared_folder,my_torrentFolder: WideString;
  last_index_icona_details_library: Byte;
  client_h_global: Integer;
  bytes_sent: Int64;
  muptime: Cardinal;
  lista_socket_accept_down: TMylist;
  lista_risorse_temp: Tthreadlist;
  lista_risorsepartial_temp: Tthreadlist;
  lista_socket_temp_proxy: TMylist;
  lista_push_nostri: TMylist;
  ever_pressed_chat_list: Boolean;
  hash_throttle: Byte;


  cambiato_manual_folder_share,cambiato_setting_autoscan,want_stop_autoscan: Boolean;
  partialUploadSent: Int64;
  speedUploadPartial: Cardinal;
  was_on_src_tab: Boolean; //for unbolding of search results

  threadDHT: Tthread_dht;
  DHT_socket:hsocket;
  DHT_RemoteSin: TVarSin;
  DHT_buffer: array [0..9999] of Byte;

  DHT_len_recvd,DHT_len_tosend: Integer;
  DHT_routingZone: TRoutingZone;
  DHT_m_Publish: Boolean; //autopubblish of own key
  DHT_m_nextID: Cardinal;
  DHT_events: TMylist;
  DHT_Searches: TMylist;
  DHTme128:CU_INT128;
  DHT_availableContacts: Integer;
  DHT_AliveContacts: Integer;
  DHT_possibleBootstrapClientIP: Cardinal;
  DHT_possibleBootstrapClientPort: Word;
  DHT_hashFiles: TthreadList;
  DHT_KeywordFiles: TthreadList;
  DHT_LastPublishKeyFiles: Cardinal; //milliseconds 
  DHT_LastPublishHashFiles: Cardinal; //milliseconds

  my_mdht_port: Word;
  
  BitTorrentTempList: TMyList;
  bittorrent_Accepted_sockets: TMylist;
  thread_bittorrent: Tthread_bitTorrent;


  check_opt_gen_autostart_checked: Boolean;
  check_opt_gen_autoconnect_checked: Boolean;
  check_opt_gen_gclose_checked: Boolean;
  check_opt_tran_warncanc_checked: Boolean;
  check_opt_gen_capt_checked: Boolean;
  check_opt_tran_perc_checked: Boolean;
  check_opt_gen_pausevid_checked: Boolean;
  check_opt_gen_nohint_checked: Boolean;
  check_opt_tran_inconidle_checked: Boolean;
  Check_opt_chat_time_checked: Boolean;
  Check_opt_chat_autoadd_checked: Boolean;
  check_opt_chat_joinpart_checked: Boolean;
  check_opt_chat_taskbtn_checked: Boolean;
  Check_opt_chat_nopm_checked: Boolean;
  check_opt_chat_whatsong_checked: Boolean;
  Check_opt_chatRoom_nopm_checked: Boolean;
  check_opt_chat_noemotes_checked: Boolean;
  check_opt_chat_browsable_checked: Boolean;
  check_opt_chat_realbrowse_checked: Boolean;
  check_opt_chat_isaway_checked: Boolean;
  memo_opt_chat_away_text: WideString;
  check_opt_net_nosprnode_checked: Boolean;
  Check_opt_hlink_filterexe_checked: Boolean;
  check_opt_hlink_magnet_checked: Boolean;
  check_opt_hlink_pls_checked: Boolean;
  check_opt_torrent_assoc_checked: Boolean;
  lbl_opt_skin_title_caption,
  lbl_opt_skin_author_caption,
  lbl_opt_skin_url_caption,
  lbl_opt_skin_version_caption,
  lbl_opt_skin_date_caption,
  lbl_opt_skin_comments_caption: WideString;
  
implementation

end.
