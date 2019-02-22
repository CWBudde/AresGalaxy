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
application structures are listed here
}

unit ares_types;

interface

uses
 Windows, Classes, SysUtils, blcksock, Graphics,
 synsock,const_ares,classes2,comettrees,buttons,comctrls,class_cmdlist,
 DirectDraw,ares_objects,tntforms,
  Directshow9,TntMenus,
  SyncObjs,tntcomctrls,tntstdctrls,tntbuttons,extctrls,WinSplit,xpbutton,
  tntextctrls,comettopicpnl,cometPageView,
  ActiveX;

  type tnetStreamType=(nsTRoot,nsTMovies,nsTTv,nsTUnknown);

  type
  precordNetStreamChannel=^recordNetStreamChannel;
  recordNetStreamChannel=record
   language: string;
   streamUrl: WideString;
   streamPlaypath: WideString;
   webCapt: WideString;
   webUrl: string;
   capt: WideString;
  end;

  precord_chatProcessData=^record_chatProcessData;
  record_chatProcessData=record
   wnhandle: Thandle;
   procID:dword;
   FAppThreadID: Cardinal;
   containerPnl: Tpanel;
   oldParentWn: THandle;
   hasFocus: Boolean;
   initialized: Boolean;
   ip: Cardinal;
  end;

  type
  tdatanodetype=(dnt_Null,
                 dnt_download,
                 dnt_PartialUpload,
                 dnt_PartialDownload,
                 dnt_downloadSource,
                 dnt_upload,
                 dnt_bittorrentMain,
                 dnt_bittorrentSource);
  type
  precord_data_node=^record_data_node;
  record_data_node=record
   m_type: Tdatanodetype;
   data: Pointer;
  end;
  
  type
  targuments=array of string;

  type
  precord_relayed_chat_form=^record_relayed_chat_form;
  record_relayed_chat_form=record
   frm: Pointer;
   supernode: Pointer;
   id: Cardinal;
   packetsout: TMyStringList;
   packetin: TMyStringList;
   disconnected: Boolean;
   windowclosed: Boolean;
   hasnotifyclose_toremotepeer: Boolean;
  end;

  type
  precord_httpheader_item=^record_httpheader_item;
  record_httpheader_item=record
  key: string;
  value: string;
  end;

  type  //GUI tab status
  tstato_tab_gui=(GUI_Web,
                  GUI_Library,
                  GUI_Screen,
                  GUI_Search,
                  GUI_Transfer,
                  GUI_Chat,
                  GUI_Options);


  type  // string structure for library categs
precord_string=^record_string;
record_string=record
 str: string;
 counter: Integer;
 crc: Word;
 len: Byte;
end;
  
 type  // private chat, connect to user's supernode and ask for a reverse (push) connection back to us
 precord_pushed_chat_request=^record_pushed_chat_request;
 record_pushed_chat_request=record
  randoms: string;
  issued: Cardinal;
  socket: Ttcpblocksocket;
 end;
 type HINTERNET=pointer;
    type //helper visual headers
  Tcolumn_type=(COLUMN_TITLE,
                COLUMN_ARTIST,
                COLUMN_CATEGORY,
                COLUMN_ALBUM,
                COLUMN_TYPE,
                COLUMN_SIZE,
                COLUMN_DATE,
                COLUMN_LANGUAGE,
                COLUMN_VERSION,
                COLUMN_QUALITY,
                COLUMN_COLORS,
                COLUMN_LENGTH,
                COLUMN_RESOLUTION,
                COLUMN_STATUS,
                COLUMN_FILENAME,
                COLUMN_INPROGRESS,
                COLUMN_NULL,
                COLUMN_YOUR_LIBRARY,
                COLUMN_MEDIATYPE,
                COLUMN_FORMAT,
                COLUMN_FILETYPE,
                COLUMN_USER,
                COLUMN_FILEDATE);

 type  //helper visual headers
  tstato_search_header=array [0..10] of tcolumn_type;
  tstato_library_header=array [0..10] of tcolumn_type;
  tstato_header_chat=array [0..9] of tcolumn_type;






  //thread client, structure for HASH source/resume search
  precord_download_hash=^record_download_hash;
   record_download_hash=record
    hash: string;
    crchash: Word;
    handle_download: Cardinal;
   end;

   type  //thread_client avoid some dead loop while adding/removing hosts in discovery
   precord_nodo_provato=^record_nodo_provato;
   record_nodo_provato=record
    host: string;
    when: Cardinal;
    isBad: Boolean;
   end;
   
    type
  Tsocks_type=(SoctNone,
               SoctSock4,
               SoctSock5);

  type  //thread_upload don't accept too many chat request from single ips
  precord_ip_accepted_chat=^record_ip_accepted_chat;
  record_ip_accepted_chat=record
   ip: Cardinal;
   last: Cardinal;
   volte: Byte;
  end;

  type //GUI manual folder share configuration
  precord_mfolder=^record_mfolder;
  record_mfolder=record
   drivetype: Cardinal;
   path: string;
   crcpath: Word; //per velocizzare
   stato: Integer;
  end;

   type   //cache/ultranode/thread_upload structure to prevent some accept flooding
 precord_ip_antiflood=^record_ip_antiflood;
 record_ip_antiflood=record
  ip,logtime: Cardinal;
  polled: Boolean;
 end;

  type
  POpenFilenameW = ^TOpenFilenameW;
  POpenFilename = POpenFilenameW;
  {$EXTERNALSYM tagOFNW}
  tagOFNW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PWideChar;
    lpstrCustomFilter: PWideChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PWideChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PWideChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PWideChar;
    lpstrTitle: PWideChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PWideChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PWideChar;
  end;
  {$EXTERNALSYM tagOFN}
  tagOFN = tagOFNW;
  TOpenFilenameW = tagOFNW;
  TOpenFilename = TOpenFilenameW;
  {$EXTERNALSYM OPENFILENAMEW}
  OPENFILENAMEW = tagOFNW;
  {$EXTERNALSYM OPENFILENAME}
  OPENFILENAME = OPENFILENAMEW;
  
  type  //playlist file structure
  precord_file_playlist=^record_file_playlist;
  record_file_playlist=record
   numero: Integer;
   displayName,filename: string;
   crcfilename: Word;
   amime: Byte;
   length: Cardinal;
  end;

  type //upload, user granted of upload slot
  precord_user_granted=^record_user_granted;
  record_user_granted=record
   ip_user: Cardinal;
   port_user: Word;
   ip_alt: Cardinal;
  end;

  type  //helper diskio search structure
  TSearchRecW = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: WideString;
    ExcludeAttr: Integer;
    FindHandle: THandle;
    FindData: TWin32FindDataW;
  end;


  type //private chat file transfer structure
   precord_file_chat_send=^record_file_chat_send;
   record_file_chat_send=record
    filenameA,folderA: string;
    tipoW: WideString;
    remaining,size,bytesprima,progress,speed: Int64;
    num,num_referrer,randomsenu: Integer;
    stream: Thandlestream;
    transferring,waiting_for_activation,upload,accepted,completed,should_stop: Boolean;
    last_data: Cardinal;
  end;

  type  // try also
  precord_keyword_genre_item=^record_keyword_genre_item;
  record_keyword_genre_item=record
   artist: string;
   crc: Word;
   len: Byte;
   times: Cardinal;
   prev,next:precord_keyword_genre_item;
  end;

  type // try also
  precord_keyword_genre=^record_keyword_genre;
  record_keyword_genre=record
   genre: string;
   crc: Word;
   len: Byte;
   firstitem:precord_keyword_genre_item;
  end;

 type   // directshow
  TDSMediaInfo = record
    SurfaceDesc: TDDSurfaceDesc;
    Pitch: integer;
    PixelFormat: TPixelFormat;
    MediaLength: Int64;
    AvgTimePerFrame: Int64;
    FrameCount: integer;
    Width: integer;
    Height: integer;
    FileSize: Int64;
  end;

   type
    LongRec = packed record
    Lo, Hi: Word;
  end;

  u_char = Char;
   u_short = Word;
       u_long = Longint;
    u_int = Integer;
     TSocket = u_int;
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;
    SunW = packed record
    s_w1, s_w2: u_short;
  end;

   PInAddr = ^TInAddr;
  {$EXTERNALSYM in_addr}
  in_addr = record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;
  TInAddr = in_addr;


   const
    INVALID_SOCKET		= TSocket(NOT(0));

   type
    TWMActivate = record
    Msg: Cardinal;
    Active: Word; { WA_INACTIVE, WA_ACTIVE, WA_CLICKACTIVE }
    Minimized: WordBool;
    ActiveWindow: HWND;
    Result: Longint;
  end;

  type
    TWMDropFiles = record
    Msg: Cardinal;
    Drop: THANDLE;
    Unused: Longint;
    Result: Longint;
  end;
  
   type
    TWMKey = record
    Msg: Cardinal;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  type
    TMessage = record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

  PRecToPass = ^TRecToPass;
  TRecToPass = packed record
  s: string[255];
  i: Integer;
  end;

  // params
  TWMCopyData = packed record
    Msg: Cardinal;
    From: HWND;
    CopyDataStruct: PCopyDataStruct;
    Result: Longint;
  end;

 type //secure hash
 TID = array [0..4] of integer;
 TBD = array [0..19] of Byte;

type  //channellist structure, preparsed topic to speed up draw of coloured topics
precord_displayed_channel=^record_displayed_channel;
record_displayed_channel=record
 ip: Cardinal; //ip interno fastweb
 port,status: Word;
 name,
 topic: string;
 language: string;
 locrc: Word;
 stripped_topic: WideString;
 has_colors_intopic: Boolean;
 buildNo: Word;
 enableJSTemplate: Boolean;
end;

type
precord_chat_favorite=^record_chat_favorite;
record_chat_favorite=record
 ip,last_joined: Cardinal; //ip interno fastweb
 port: Word;
 name,
 topic: string;
 locrc: Word;
 stripped_topic: WideString;
 has_colors_intopic,
 autoJoin: Boolean; // per visual più che altro
end;


type  // library regular folder structure
precord_cartella_share=^record_cartella_share;
record_cartella_share=record
 items: Word;
 items_shared: Word;
 path: WideString;
 crcpath: Word;
 path_utf8,
 display_path: string;
 id: Word;
 prev,next,first_child,parent:precord_cartella_share;
end;

 type  // file meta exchange structure
  precord_audioinfo=^record_audioinfo;
  record_audioinfo=record
   bitrate,
   frequency,
   duration: Integer;
   codec: string;
  end;

 type  // thread upload, local list of queued users (used also by treeview_queue)
  precord_queued=^record_queued;
  record_queued=record
   total_tries,    // how many time has he tried
   polltime,      // next poll expected
   retry_interval, // how often it comes
   queue_start: Cardinal; // when we first seen it
   nomefile,user: string;
   crcnomefile: Word;
   pollmax,pollmin,
   posizione: Cardinal;
   ip,ip_alt,server_ip: Cardinal;
   port,server_port: Word;
   disconnect,banned: Boolean;
   size: Int64;
   his_speedDL: Cardinal; //2957+ mostra sua velocità in luogo di age download
   importance,his_progress,num_available: Byte;
   his_shared,his_upcount,his_downcount: Integer;
   his_agent: string;
  end;


type  // string parse helper structure
precord_title_album_artist=^record_title_album_artist;
record_title_album_artist=record
 artist,
 album,
 title: WideString;
end;


type    // from client to upload (client receive it from supernode, then upload perform connection to deliver push)
 precord_push_to_go=^record_push_to_go;
 record_push_to_go=record
  filename: string;
  ip: Cardinal;
  port: Word;
 end;



type   // thread upload , data structure for listview_upload component
precord_displayed_upload=^record_displayed_upload;
record_displayed_upload=record
 handle_obj: Cardinal;
 isUDP: Boolean;
 nomefile,nickname: string;
 crcnick,crcfilename: Word;
 should_stop,should_ban: Boolean;
 progress,size,filesize_reale,continued_from,start_point: Int64;
 upload: Tupload;
 continued,completed: Boolean;
 ip,ip_server,ip_alt: Cardinal; // per ban veloci
 port,port_server: Word;
 his_speedDL: Cardinal;
 his_shared,his_upcount,his_downcount,velocita: Integer;
 num_available,his_progress: Byte;
 his_agent: string;
end;








type
precord_panel_search=^record_panel_search;
record_panel_search=record
 started: Cardinal;
 lbl_src_status_caption: WideString;
 searchID: Word;
 backup_results: TMylist;
 search_string: string;
 listview: Tcomettree;
 stato_header: Tstato_search_header;
 containerPanel: Tpanel;
 pnl: TCometPagePanel;
 numresults,numhits: Word;
 mime_search: Byte;
 is_advanced,is_updating: Boolean;
  combo_search_text,comboalbsearch_text,comboautsearch_text,combo_lang_search_text,
  combodatesearch_text,combotitsearch_text,combocatsearch_text: WideString;
  combo_sel_duration_index,combo_sel_quality_index,
  combo_sel_size_index,combo_wanted_duration_index,combo_wanted_quality_index,
  combo_wanted_size_index: Integer;
end;

type  //avoid creation of tcpblocksockets objects
precord_socket=^record_socket;
record_socket=record
 ip,buffstr: string;
 port: Word;
 socket: Integer;
 connesso: Boolean;
 tag: Cardinal;
end;



  type  //thread_share, used while scanning library
  precord_file_scan=^record_file_scan;
  record_file_scan=record
   fname: WideString;
   Amime: Byte;
   ext: string;
   fsize: Int64;
  end;


  type  //GUI p2p search Result listview structure
  precord_search_result=^record_search_result;
  record_search_result=record
    search_id: Word;
    title,artist,album,filenameS,nickname,keyword_genre,category,comments,language,url,year: string;
    hash_sha1,hash_of_phash: string;
    crcsha1: Word;
    fsize: Int64;
    ImageIndex: Integer;
    param1,param2,param3: Cardinal;
    amime: Byte;
    already_in_lib,being_downloaded,downloaded,isTorrent: Boolean;
    ip_alt,ip_user,ip_server: Cardinal;
    port_user,port_server: Word;
    bold_font,watchExt: Boolean;
    DHTload: Byte;
  end;

  //client, helps while parsing Result  attenzione deve essere allineato così
 precord_user_resultcl=^record_user_resultcl; //per riempimento header Result client veloce
 recorD_user_resultcl=packed record
  serverip: Cardinal;
  serverport: Word;
  userip: Cardinal;
  userport: Word;
  spchar: Byte;
 end;



  type   //upload, helper with the alt source excange
  precord_hash_holder_alternate=^record_hash_holder_alternate;
  record_hash_holder_alternate=record
   next:precord_hash_holder_alternate;
   first_alt:precord_alternate;
   hash_sha1: array [0..19] of Byte;
   crcsha1: Word;
   num: Cardinal;
  end;


type  //per facilitare in thread share costruzione di indexs phashes
 precord_phash_index=^record_phash_index;
 record_phash_index=record
 db_point_on_disk: Cardinal;
 len_on_disk: Cardinal;
 hash_sha1: string;
 crcsha1: Word;
 next:precord_phash_index;
end;


  type   //library local/remote(browse)
  precord_file_library=^record_file_library;
  record_file_library = record
   downloaded,being_downloaded,already_in_lib: Boolean; //pvt browse
   guid_search: Tguid; //compare Result private chat
   hash_sha1: string;   //sha1 20 bytes
   hash_of_phash: string;
   crcsha1: Word;
   ext: string;
   filedate: Tdatetime; //per assegniare orario ingresso in library
   title,album,artist,category,mediatype,vidinfo,comment,language,path,url,year,keywords_genre: string;
   param1,param2,param3: Integer;
   folder_id: Word;
   fsize: Int64;
   imageindex: Integer;
   amime: Byte;
   shared,corrupt,write_to_disk,previewing: Boolean;
   phash_index: Cardinal; //punto in db_hash per veloce ritrovamento in thread upload
   next:precord_file_library; //per facilitare library scan
 end;

 type
 precord_file_trusted=^record_file_trusted;
 record_file_trusted= record
  hash_sha1: string;
  crcsha1: Word;
  title,album,artist,category,mediatype,vidinfo,comment,language,path,url,year,keywords_genre: string;
  corrupt,shared: Boolean;
  filedate: Tdatetime; //per assegniare orario ingresso in library
  next:precord_file_trusted;
 end;

 type
 precord_ip=^record_ip;
 record_ip=record
  ip: Cardinal;
 end;

implementation



end.

