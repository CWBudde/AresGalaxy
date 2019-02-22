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
this thread loads filelist_db , scan for new shared file(everything not in such db_list) calculates the SHA-1 values,
 and prepare visual display in library section
}

unit thread_share;

interface

uses
  Classes,controls,registry,windows,sysutils,CmtVerNfo,umediar,
 ComCtrls,ares_types,ComObj,Activex,OleServer,const_ares,
 classes2,graphics,buttons,comettrees,tntwindows,class_cmdlist,
 helper_share_misc,DirectDraw,Directshow9, Dspack;

 type
  PPropertySetHeader = ^TPropertySetHeader;
  TPropertySetHeader = record
    wByteOrder: Word;   // Always 0xFFFE
    wFormat: Word ;     // Always 0
    dwOSVer: DWORD;     // System version
    clsid: TCLSID;      // Application CLSID
    dwReserved: DWORD;  // Should be 1
  end;

  TFMTID = TCLSID;

  PFormatIDOffset = ^TFormatIDOffset;
  TFormatIDOffset = record
    fmtid: TFMTID;      // Semantic name of a section
    dwOffset: DWORD;    // Offset from start of whole property set
                        // stream to the section
  end;

  PPropertySectionHeader = ^TPropertySectionHeader;
  TPropertySectionHeader = record
    cbSection: DWORD;    // Size of section
    cProperties: DWORD;  // Count of properties in section
  end;

  PPropertyIDOffset = ^TPropertyIDOffset;
  TPropertyIDOffset = record
    propid: DWORD;      // Name of a property
    dwOffset: DWORD;    // Offset from the start of the section to that
                        // property type/value pair
  end;

  PPropertyIDOffsetList = ^TPropertyIDOffsetList;
  TPropertyIDOffsetList = array [0..255] of TPropertyIDOffset;

  PSerializedPropertyValue = ^TSerializedPropertyValue;
  TSerializedPropertyValue = record
    dwType: DWORD;       // Type tag
    prgb: PBYTE;         // The actual property value
  end;

  PSerializedPropertyValueList = ^TSerializedPropertyValueList;
  TSerializedPropertyValueList = array [0..255] of TSerializedPropertyValue;

  PStringProperty = ^TStringProperty;
  TStringProperty = record
    propid: DWORD;
    Value: AnsiString;
  end;

  PIntegerProperty = ^TIntegerProperty;
  TIntegerProperty = record
    propid: DWORD;
    Value: Integer;
  end;

  PFileTimeProperty = ^TFileTimeProperty;
  TFileTimeProperty = record
    propid: DWORD;
    Value: TFileTime;
  end;

type

  tthread_share = class(TThread)
  protected
  artists_audio,albums_audio,categs_audio,authors_document,
  categs_document,companies_software,categs_software,
  categs_video,
  albums_image,categs_image,keywords_genre: TMylist;

  num_files_shared,num_files,num_audio,num_video,num_image,
  num_document,num_software,num_other,num_recent,num_to_scan,num_scanned: Word;

  last_update_caption_scan,time_last_check_speed: Cardinal;

  bytes_hashed_total,bytes_hashed_before,bytes_tohash_total,progressfile_hash,sizefile_hash: Int64;
  speed_hash_global:extended;

  first_shared_folder:precord_cartella_share;
  title,category,comment,album,artist,url,year: string;

  loc_sharedList_count: Word;
  m_DHT_KeywordFiles: TMylist;

    filenW_mpeg,filenW_hash: WideString;
    fileScan:precord_file_scan;
    raudio:precord_audioinfo;

    loc_hash_throttle: Byte;
    naplist_helper: TNapCmdList;
    //add_default_paths: Boolean;

    mp3: TMPEGaudio;
    ogg: TOggVorbis;
    wma: TWMAfile;
    wav: Twavfile;
    exe: TCmtVerNfo;
    flac: TFLACfile;
    ape: Tmonkey;
    aac: Taacfile;
    immagine: Tdcimageinfo;
    vqf: TTwinVQ;
    mpc: TMPCFile;
    mp4: TMP4Parser;

    procedure library_reset_stats_numbers;
    procedure init_categs;
    procedure init_thread_vars;
    procedure nihil_vars;
    procedure Execute; override;
    procedure hide_scan_folders; //synch
    procedure prepara_form1_library;
    procedure scan_in_progress_start; //synch
    procedure shutdown;


    procedure init_metareaders;
    procedure free_metareaders;

    procedure sharedlist_getGlobal;   //synch
    procedure sharedlist_clearGlobal; //synch
    procedure show_final_library;
    procedure show_temp_library;
    procedure sharedfolder_scan(preview: Boolean; folder:precord_cartella_share; var index_folder:integer);
    function is_parent_path_already_in(list: TMyStringList;dir: string): Boolean;
    procedure sharedfolder_getsubdirs(var folder:precord_cartella_share);
    procedure regular_libraryview_assign(folder:precord_cartella_share; node_parent:PCmtVNode; data_parent:precord_cartella_share);
    procedure reset_mime_stats;
    function deal_with_newfile(shouldhash: Boolean; folder:precord_cartella_share; nomefile: WideString; utf8path: string; fsize: Int64; amime:integer): Boolean;
    procedure DHT_generate_hashFilelist;


    procedure sharedfolders_init;
    function add_to_sharedlist(shouldhash: Boolean; folder:precord_cartella_share): Boolean;

    procedure get_hash_throttle; //synch
    procedure put_hash_file_name; //synch
    procedure put_clear_hash_file_name; //synch
    procedure put_hash_progress; //synch
    procedure put_end_hash; //synch
    procedure put_end_of_global_hashing; //sync

    procedure hash_compute(const FileName: widestring; fsize: Int64; var sha1: string; var hash_of_phash: string; var point_of_insertion: Cardinal);

    procedure VirFoldersView_update;
    procedure mainGUI_addlibrarynodes;

    procedure RegFoldersView_update;
    procedure categs_compute;
    procedure add_keyword_genre(genrestr,artiststr: string);
    procedure keyword_genre_compute;
    function serialize_top_keyword_genre(list: TMylist; genrestr: string; artiststr: string): string;
    procedure extract_msword_infos;
    procedure AddmswordProperty(propid: DWORD; Value: Pointer);

    procedure clear_listviewLib; // synch
    procedure sharedlist_setGlobal; //synch
    procedure getDDrawVideoinfo;
    procedure mime_stats_reset;
    procedure lists_create;
    procedure lists_free;
    procedure categs_sort;
    procedure parse_iptc(filename: WideString);

    procedure initDDraw;
    procedure finalizeDDrawInfo;

   public
    info_video: TDSMediaInfo;


     paused: Boolean;
     juststarted: Boolean;
     DirectDraw: IDirectDraw;
     AMStream: IAMMultiMediaStream;
  end;


implementation

uses
 ufrmmain,SecureHash,helper_unicode,vars_localiz,helper_diskio,helper_arescol,helper_strings,helper_crypt,
 helper_urls,helper_sorting,helper_visual_library,helper_stringfinal,helper_share_settings,
 helper_mimetypes,helper_filtering,helper_datetime,vars_global,utility_ares,const_win_messages,
 helper_gui_misc,helper_library_db,helper_ICH,helpeR_registry,dhttypes,keywfunc,dhtconsts,dhtkeywords,
 bittorrentConst,helper_fakes;



procedure tthread_share.mime_stats_reset;
begin
  num_audio := 0;
  num_video := 0;
  num_image := 0;
  num_document := 0;
  num_software := 0;
  num_other := 0;
  num_recent := 0;
end;

procedure tthread_share.lists_create;
begin
  keywords_genre := tmylist.create;
  naplist_helper := tnapcmdlist.create;
  m_DHT_KeywordFiles := tmylist.create;
end;


procedure tthread_share.lists_free;
var
keyword_genre:precord_keyword_genre;
keyword_genre_item,nextitem:precord_keyword_genre_item;
begin

try
  DB_TOWRITE_free;
  DBFiles_free;
  helper_library_db.DBTrustedFiles_free;
except
end;

 
 try
  if first_shared_folder<>nil then cancella_cartella_per_treeview2(first_shared_folder);
 except
 end;


 try
   while (keywords_genre.count>0) do begin
   keyword_genre := keywords_genre[keywords_genre.count-1];
   keyword_genre^.genre := '';
    keyword_genre_item := keyword_genre^.firstitem;
     while (keyword_genre_item<>nil) do begin
      nextitem := keyword_genre_item^.next;
       keyword_genre_item^.artist := '';
       FreeMem(keyword_genre_item,sizeof(record_keyword_genre_item));
      keyword_genre_item := nextitem;
     end;
   keywords_genre.delete(keywords_genre.count-1);
   FreeMem(keyword_genre);
   end;
 except
 end;
   keywords_genre.Free;

  try
     if artists_audio<>nil then free_virfolders_entries(artists_audio);
     if albums_audio<>nil then free_virfolders_entries(albums_audio);
     if categs_audio<>nil then free_virfolders_entries(categs_audio);
     if authors_document<>nil then free_virfolders_entries(authors_document);
     if categs_document<>nil then free_virfolders_entries(categs_document);
     if companies_software<>nil then free_virfolders_entries(companies_software);
     if categs_software<>nil then free_virfolders_entries(categs_software);
     if categs_video<>nil then free_virfolders_entries(categs_video);
     if albums_image<>nil then free_virfolders_entries(albums_image);
     if categs_image<>nil then free_virfolders_entries(categs_image);
  except
  end;

  try
   naplist_helper.Free;
  except
  end;

  try
  if m_DHT_KeywordFiles<>nil then begin
   m_DHT_KeywordFiles.Free;
  end;

  except
  end;
end;


procedure tthread_share.clear_listviewLib; // synch
var
i: Integer;
reg: Tregistry;
begin
try
put_clear_hash_file_name;

details_library_toggle(false);

with ares_frmmain do begin
 with listview_lib do begin
  defaultnodeheight := 18;
  images := ares_FrmMain.img_mime_small;
  header.height := 21;
  clear;
 end;

 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
  writestring('GUI.LastLibrary','');
  closekey;
  destroy;
 end;

 with listview_lib.header do begin
  for i := 0 to 9 do begin
   columns[i].text := '';
   columns[i].width := 0;
  end;
  autosizeindex := 10;
 end;

end;


except
end;
end;


procedure tthread_share.scan_in_progress_start; //synch
var
nodo:pCmtVnode;
//reg: Tregistry;
begin
try


 
vars_global.scan_start_time := gettickcount;
vars_global.hashing := True;

hash_update_GUIpry;
ares_FrmMain.panel_hash.capt := ' '+GetLangStringW(STR_MEDIASEARCHINPROGRESS);

num_to_scan := 0;
num_scanned := 0;


if ares_frmmain.tabs_pageview.activepage=IDTAB_LIBRARY then begin
  if ares_FrmMain.btn_lib_virtual_view.down then begin
     nodo := ares_FrmMain.treeview_lib_virfolders.getfirst;
      ares_FrmMain.treeview_lib_virfolders.selected[nodo] := True;
      ufrmmain.ares_FrmMain.treeview_lib_virfoldersClick(nil);
  end else begin
     nodo := ares_FrmMain.treeview_lib_regfolders.getfirst;
      ares_FrmMain.treeview_lib_regfolders.selected[nodo] := True;
      ufrmmain.ares_FrmMain.treeview_lib_regfoldersClick(nil);
  end;
end;

except
end;
end;


procedure tthread_share.nihil_vars;
begin
first_shared_folder := nil;

 init_cached_dbs;
 ICH_init_phash_indexs;

    artists_audio := nil;
    categs_audio := nil;
    albums_audio := nil;
    albums_image := nil;
    categs_image := nil;
    categs_video := nil;
    authors_document := nil;
    categs_document := nil;
    companies_software := nil;
    categs_software := nil;
    m_DHT_KeywordFiles := nil;

    raudio := nil;
    fileScan := nil;

    mp3 := nil;
    ogg := nil;
    wma := nil;
    exe := nil;
    flac := nil;
    ape := nil;
    vqf := nil;
    aac := nil;
    mpc := nil;
    mp4 := nil;
    immagine := nil;
end;

procedure tthread_share.prepara_form1_library;
begin
try
    synchronize(clear_listviewLib);
     sleep(15);
    synchronize(mainGUI_addlibrarynodes);
     sleep(15);
    synchronize(scan_in_progress_start);
 except
    terminate;
 end;
end;





procedure tthread_share.Execute;
begin
 Priority := tpnormal;
 freeonterminate := False;


 nihil_vars;
 lists_create;
try

    loc_sharedList_count := 0;
    if not terminated then prepara_form1_library;
    if not terminated then dhtkeywords.DHT_clear_hashFilelist;   //stop sharing
    if not terminated then dhtkeywords.DHT_clear_keywordsFiles;

      if not terminated then begin
       if paused then sleep(4000);
      end;

    if not terminated then sharedfolders_init;

     if not terminated then sleep(10);
    if not terminated then synchronize(sharedlist_GetGlobal);  //<---clear library from frmmain
     if not terminated then sleep(10);

    if not terminated then ICH_load_phash_indexs; //must be before of get_cached_metas
     if not terminated then sleep(10);
    if not terminated then helper_library_db.get_cached_metas;                   // fill cached from disk to avoid double scan
     if not terminated then sleep(10);
    if not terminated then helper_library_db.get_trusted_metas;                  // fill trusted from disk to assign older meta and shared preferences
     if not terminated then sleep(10);

  if not terminated then init_metareaders;
  if not terminated then mime_stats_reset;

   if not terminated then sleep(10);
  if not terminated then show_temp_library;                   // send DB_TOWRITE to frmmain, reset vars

   

   if not terminated then sleep(10);
  if not terminated then show_final_library;                  // perform actual scan

   synchronize(hide_scan_folders);
  except
  end;

shutdown;
end;



procedure tthread_share.init_metareaders;
begin
try
     raudio := AllocMem(sizeof(record_audioinfo));
     fileScan := AllocMem(sizeof(record_file_scan));

      mp3 := TMPEGaudio.create;
      wav := twavfile.create;
      ogg := TOggVorbis.create;
      wma := TWMAfile.create;
      flac := TFLACfile.create;
      ape := Tmonkey.create;
      vqf := TTwinVQ.create;
      aac := Taacfile.create;
      mpc := TMPCFile.create;
      mp4 := TMP4Parser.create;
      try
      exe := tCmtVerNfo.create(nil);
      except
      exe := nil;
      end;
      immagine := tdcimageinfo.create;
except
end;
end;








procedure tthreaD_share.shutdown;
begin
  lists_free;

 try
  if fileScan<>nil then begin
   fileScan.fname := '';
   fileScan.ext := '';
   FreeMem(fileScan,sizeof(record_file_scan));
  end;

  if raudio<>nil then begin
  raudio^.codec := '';
  FreeMem(raudio,sizeof(record_audioinfo));
  end;
 except
 end;

 free_metareaders;
  ICH_free_phash_indexs;

   postmessage(ares_FrmMain.handle,WM_THREADSHARE_END,1,1);
end;

procedure tthread_share.free_metareaders;
begin
try
  if mp3<>nil then mp3.Free;
  if wav<>nil then wav.Free;
  if exe<>nil then exe.Free;
  if ogg<>nil then ogg.Free;
  if wma<>nil then wma.Free;
  if flac<>nil then flac.Free;
  if ape<>nil then ape.Free;
  if vqf<>nil then vqf.Free;
  if aac<>nil then aac.Free;
  if mpc<>nil then mpc.Free;
  if immagine<>nil then immagine.Free;
  if mp4<>nil then mp4.Free;
except
end;
end;









procedure tthread_share.DHT_generate_hashFilelist;
var
pfile:precord_file_library;
i: Integer;
hashLst: Tlist;
phash:precord_DHT_hashFile;
begin
hashLst := DHT_hashFiles.Locklist;
try

for i := 0 to 255 do begin
 if DB_TOWRITE[i]=nil then continue;

  pfile := DB_TOWRITE[i];
   while (pfile<>nil) do begin
    if pfile^.shared then begin
      phash := AllocMem(sizeof(record_DHT_hashfile));
       move(pfile^.hash_sha1[1],phash^.HashValue[0],20);
      hashLst.add(phash);
    end;
    pfile := pfile^.next;
   end;
end;

except
end;
DHT_hashFiles.UnLocklist;
end;

procedure tthread_share.sharedlist_setGlobal; //synch
var
pfile:precord_file_library;
should_send: Boolean;
i: Integer;
begin
sharedlist_clearGlobal;
try
should_send := True;
num_files_shared := 0;
vars_global.my_shared_count := 0;


for i := 0 to 255 do begin
 if DB_TOWRITE[i]=nil then continue;

  pfile := DB_TOWRITE[i];

  while (pfile<>nil) do begin
    pfile^.write_to_disk := False;
    pfile^.downloaded := False;
    vars_global.lista_shared.add(pfile);
     if pfile^.previewing then should_send := false else begin
      if pfile^.shared then inc(num_files_shared);
     end;
    pfile := pfile^.next;
  end;

  DB_TOWRITE[i] := nil;
end;


vars_global.my_shared_count := num_files_shared;


if ((should_send) and (num_files_shared>0)) then inc(vars_global.ShareScans);

except
end;
end;

procedure tthread_share.add_keyword_genre(genrestr,artiststr: string);
var
crc1,crc2: Word;
len1,len2: Byte;
pkeyw:precord_keyword_genre;
pitem:precord_keyword_genre_item;
i: Integer;
genre,artist: string;
begin
try

len1 := length(genrestr);
 if len1<2 then exit;
len2 := length(artiststr);
 if len2<2 then exit;
 genre := lowercase(genrestr);
 artist := lowercase(artiststr);

if genre=GetLangStringA(STR_UNKNOW_LOWER) then exit;
if artist=GetLangStringA(STR_UNKNOW_LOWER) then exit;
crc1 := stringcrc(genre,true);
crc2 := stringcrc(artist,true);

for i := 0 to keywords_genre.count-1 do begin
 pkeyw := keywords_genre[i];
 if pkeyw^.len<>len1 then continue;
 if pkeyw^.crc<>crc1 then continue;
 if pkeyw^.genre<>genre then continue;
    pitem := pkeyw^.firstitem;
    while (pitem<>nil) do begin
      if pitem^.len<>len2 then begin
        pitem := pitem^.next;
        continue;
      end;
      if pitem^.crc<>crc2 then begin
        pitem := pitem^.next;
        continue;
      end;
      if pitem^.artist<>artist then begin
        pitem := pitem^.next;
        continue;
      end;
      inc(pitem^.times);
      exit;
    end;
    pitem := AllocMem(sizeof(record_keyword_genre_item));
     pitem^.len := len2;
     pitem^.crc := crc2;
     pitem^.artist := artist;
     pitem^.times := 1;
           pitem^.prev := nil;
            if pkeyw^.firstitem<>nil then begin
             pkeyw^.firstitem.prev := pitem;
             pitem^.next := pkeyw^.firstitem
            end else pitem^.next := nil;
           pkeyw^.firstitem := pitem;
  exit;
end;

pkeyw := AllocMem(sizeof(record_keyword_genre));
pkeyw^.crc := crc1;
pkeyw^.len := len1;
pkeyw^.genre := genre;

pitem := AllocMem(sizeof(record_keyword_genre_item));
     pitem^.len := len2;
     pitem^.crc := crc2;
     pitem^.artist := artist;
     pitem^.times := 1;
      pitem^.prev := nil;
      pitem^.next := nil;
      pkeyw^.firstitem := pitem;
 keywords_genre.add(pkeyw);

except
end;
end;

function tthread_share.serialize_top_keyword_genre(list: TMylist; genrestr: string; artiststr: string): string;
var
crc1: Word;
len1,len2: Byte;
pkeyw:precord_keyword_genre;
pitem:precord_keyword_genre_item;
i: Integer;
num: Byte;
genre: string;
begin
result := '';
list.clear;
try

len1 := length(genrestr);
 if len1<2 then exit;
len2 := length(artiststr);
 if len2<2 then exit;

genre := lowercase(genrestr);
artist := lowercase(artiststr);
if genre=GetLangStringA(STR_UNKNOW_LOWER) then exit;

crc1 := stringcrc(genre,true);

for i := 0 to keywords_genre.count-1 do begin
 pkeyw := keywords_genre[i];
 if pkeyw^.len<>len1 then continue;
 if pkeyw^.crc<>crc1 then continue;
 if pkeyw^.genre<>genre then continue;
    pitem := pkeyw^.firstitem;
    while (pitem<>nil) do begin
      if pitem^.artist=artist then begin
        pitem := pitem^.next;
        continue;
      end;
       list.add(pitem);
      pitem := pitem^.next;
    end;
    break;
end;

if list.count=0 then exit else
 if list.count>1 then shuffle_mylist(list,0);

num := 0;
for i := 0 to list.count-1 do begin
pitem := list[i];
   Result := result+pitem^.artist+chr(44){','};
    inc(num);
     if num>4 then begin
      delete(result,length(result),1);
      exit;
     end;
end;

delete(result,length(result),1);

except
end;
end;

procedure tthread_share.keyword_genre_compute;
var
i: Integer;
pfile:precord_file_library;
list: TMylist;
begin
try

list := tmylist.create;

for i := 0 to 255 do begin
  if DB_TOWRITE[i]=nil then continue;


  pfile := DB_TOWRITE[i];
  while (pfile<>nil) do begin

  if not pfile^.shared then begin
   pfile := pfile^.next;
   continue;
  end;

   if pfile^.amime<>ARES_MIME_MP3 then pfile^.keywords_genre := ''
     else pfile^.keywords_genre := serialize_top_keyword_genre(list,pfile^.category,pfile^.artist);

   pfile := pfile^.next;
   end;

end;


list.Free;

except
end;
end;


procedure tthread_share.init_categs;
begin
  try
     if artists_audio<>nil then free_virfolders_entries(artists_audio);
     if albums_audio<>nil then free_virfolders_entries(albums_audio);
     if categs_audio<>nil then free_virfolders_entries(categs_audio);
     if authors_document<>nil then free_virfolders_entries(authors_document);
     if categs_document<>nil then free_virfolders_entries(categs_document);
     if companies_software<>nil then free_virfolders_entries(companies_software);
     if categs_software<>nil then free_virfolders_entries(categs_software);
     if categs_video<>nil then free_virfolders_entries(categs_video);
     if albums_image<>nil then free_virfolders_entries(albums_image);
     if categs_image<>nil then free_virfolders_entries(categs_image);
  except
  end;

    artists_audio := tmylist.create;
    albums_audio := tmylist.create;
    categs_audio := tmylist.create;
    albums_image := tmylist.create;
    categs_image := tmylist.create;
    sleep(5);
    categs_video := tmylist.create;
    authors_document := tmylist.create;
    categs_document := tmylist.create;
    companies_software := tmylist.create;
    categs_software := tmylist.create;
end;

procedure tthread_share.categs_compute;
var
artist,categ,album,strunknown: string;
i: Integer;
pfile:precord_file_library;
begin
try
mime_stats_reset;
init_categs;

    sleep(5);

strUnknown := GetLangStringA(STR_UNKNOWN);

for i := 0 to 255 do begin
  if DB_TOWRITE[i]=nil then continue;

  pfile := DB_TOWRITE[i];
  while (pfile<>nil) do begin

    if length(pfile^.artist)<2 then artist := copy(strunknown,1,length(strunknown))
     else artist := copy(pfile^.artist,1,length(pfile^.artist));

    if length(pfile^.category)<2 then categ := copy(strunknown,1,length(strunknown))
     else categ := copy(pfile^.category,1,length(pfile^.category));

    if length(pfile^.album)<2 then album := copy(strunknown,1,length(strunknown))
     else album := copy(pfile^.album,1,length(pfile^.album));

        
    if trunc(pfile^.filedate)>trunc(now)-7 then inc(num_recent);

   case pfile.amime of
    ARES_MIME_OTHER:inc(num_other);
    ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
   inc(num_audio); //mp3
    add_virfolders_entry(artists_audio,artist);
    add_virfolders_entry(albums_audio,album);
    add_virfolders_entry(categs_audio,categ);
  end;
  ARES_MIME_SOFTWARE:begin
   inc(num_software);
    add_virfolders_entry(companies_software,artist);
    add_virfolders_entry(categs_software,categ);
  end;
  ARES_MIME_VIDEO:begin
   inc(num_Video);
    add_virfolders_entry(categs_video,categ);
  end;
  ARES_MIME_DOCUMENT:begin
   inc(num_Document);
    add_virfolders_entry(authors_document,artist);
    add_virfolders_entry(categs_document,categ);
  end;
  ARES_MIME_IMAGE:begin
   inc(num_Image);
    add_virfolders_entry(albums_image,album);
    add_virfolders_entry(categs_image,categ);
  end;
  end;
  pfile := pfile^.next;
  
  artist := '';
  categ := '';
  album := '';
 end;
end;
  except
  end;

strUnknown := '';
end;

function tthread_share.is_parent_path_already_in( list: TMyStringList; dir: string ): Boolean;
var
i: Integer;
begin
       Result := False;

         for i := 0 to list.count-1 do begin
           if length(dir)-1<length(list.strings[i]) then continue;

           if dir[length(list.strings[i])+1]<>chr(92){'\'} then continue;

           if AnsiCompareFileName(copy(dir,1,length(list.strings[i])),list.strings[i])=0 then begin
            Result := True;
            break;
           end;
          end;
end;



procedure tthread_share.sharedfolders_init;
var
pfolder:precord_cartella_share;
begin
try

 first_shared_folder := nil;

 add_this_shared_folder(first_shared_folder,vars_global.myshared_folder);
 helper_share_settings.get_shared_folders(first_shared_folder,not reg_getever_configured_share); //,add_default_paths);

  pfolder := first_shared_folder;
  while (pfolder<>nil) do begin
    sharedfolder_getsubdirs(pfolder);
   pfolder := pfolder^.next;
    if terminated then break;
  end;


except
end;
end;

procedure tthread_share.sharedfolder_getsubdirs(var folder:precord_cartella_share);
var
doserror: Integer;
searchrec:ares_types.tsearchrecW;
new_child:precord_cartella_share;
begin
try

      try
      DosError := helper_diskio.FindFirstW(folder^.path+'\'+const_ares.STR_ANYFILE_DISKPATTERN, faAnyFile, SearchRec);
      while DosError = 0 do begin

       if (((SearchRec.attr and faDirectory)>0) and
            (SearchRec.name <> chr(46){'.'}) and
            (SearchRec.name <> chr(46)+chr(46){'..'}) and
            (lowercase(SearchRec.name)<>'winnt') and
            (lowercase(SearchRec.name)<>'windows') and
            (lowercase(SearchRec.name)<>'system') and
            (lowercase(SearchRec.name)<>'system32')) then begin

              new_child := AllocMem(sizeof(record_cartella_share));
                new_child^.first_child := nil;
                new_child^.parent := folder;
                new_child^.prev := nil;
                   if folder^.first_child=nil then new_child^.next := nil else begin
                    new_child^.next := folder^.first_child;
                    folder^.firsT_child^.prev := new_child;
                   end;
                folder^.first_child := new_child;

                 new_child^.path := folder^.path+chr(92){'\'}+searchrec.name;
                 new_child^.path_utf8 := widestrtoutf8str(new_child^.path);
                 new_child^.crcpath := stringcrc(new_child^.path_utf8,true);
                 new_child^.items := 0;
                 new_child^.items_shared := 0;
                 new_child^.display_path := '';

             sharedfolder_getsubdirs(new_child);
      end;
      DosError := helper_diskio.FindNextW(SearchRec);
     end;
     finally
     helper_diskio.FindCloseW(SearchRec);
     end;
except
end;
end;


procedure tthread_share.sharedfolder_scan(preview: Boolean; folder:precord_cartella_share; var index_folder:integer);
var
 doserror: Integer;
 dirinfo: TSearchRecW;
 ext,lown: string;
 fsize: Int64;
 amime: Byte;
 folderS: WideString;
 folder_slash: WideString;
begin
try

while (folder<>nil) do begin
    inc(index_folder);
    folder^.id := index_folder;

       if folder^.first_child<>nil then begin
        try
         sharedfolder_scan(preview,folder^.first_child,index_folder);
        except
        end;
       end;

       if terminated then exit;
       if loc_sharedList_count>=MAX_FILE_SHARED then break;


     folderS := folder^.path;
     folder_slash := folderS+'\';

    try
     dosError := helper_diskio.FindFirstW(folder_slash+const_ares.STR_ANYFILE_DISKPATTERN, faAnyfile, dirInfo);

    while (DosError=0) do begin

      if loc_sharedList_count>=MAX_FILE_SHARED then break;

       if (((dirinfo.Attr and faDirectory)>0) or
            (dirinfo.name='.') or
            (dirinfo.name='..')) then begin
              DosError := helper_diskio.FindNextW(dirinfo);
              continue;
       end;

        lown := lowercase(widestrtoutf8str(dirinfo.name));
         if isUnsharableName(lown) then begin

          DosError := helper_diskio.FindNextW(dirinfo);
          continue;
         end;


       ext := extractfileext(lown);

        if not isSharableExt(ext) then begin

         DosError := helper_diskio.FindNextW(dirinfo);
         continue;
        end;

       if terminated then break;

      fsize := gethugefilesize(folder_slash+dirinfo.name);
       amime := extstr_to_mediatype(ext);
        if isTooSmallToShare(amime,fsize) then begin
         
         DosError := helper_diskio.FindNextW(dirinfo);
         continue;
        end;

        if amime=ARES_MIME_OTHER then
         if ext='.torrent' then begin
          if helper_datetime.DelphiDateTimeToUnix(now)-getFileDateW(folder_slash+dirinfo.name)>TORRENT_DONTSHARE_INTERVAL then begin
           DosError := helper_diskio.FindNextW(dirinfo);
           continue;
          end; //30 days
        end;

   fileScan^.fname := folder_slash+dirinfo.name;
   fileScan^.fsize := fsize;
   fileScan^.ext := ext;
   fileScan^.amime := amime;

    
    try
     add_to_sharedlist(not preview,folder);
     if terminated then break;
    except
    end;


    DosError := helper_diskio.FindNextW(dirinfo);
end;

finally
    helper_diskio.findcloseW(dirinfo);
end;

   if terminated then break else sleep(10);
 folder := folder^.next;
 end;

except
end;
end;

procedure tthread_share.library_reset_stats_numbers;
begin
     num_other := 0;
     num_audio := 0;
     num_video := 0;
     num_document := 0;
     num_software := 0;
     num_image := 0;
     num_files := loc_sharedList_count;
     // if loc_sharedList.count>1 then loc_sharedList.sort(ordina_per_size);
end;

procedure tthread_share.show_temp_library;
var
 index_folder: Integer;
begin

seterrormode(SEM_FAILCRITICALERRORS);
 try

bytes_hashed_total := 0;
bytes_tohash_total := 0;

index_folder := 0;

sharedfolder_scan(true,first_shared_folder,index_folder);
   
      sleep(10);

   if terminated then exit;

     library_reset_stats_numbers;

      categs_compute;

       if terminated then exit;

       synchronize(sharedlist_SetGlobal);         // put previewable DB_TOWRITE to formmain
       if terminated then exit else sleep(5);

         categs_sort;
          synchronize(VirFoldersView_update);
          synchronize(RegFoldersView_update);


         DB_TOWRITE_free;
         loc_sharedList_count := 0; //reset
         
  except
  end;

end;

procedure tthread_share.init_thread_vars;
begin
  num_other := 0;
  num_audio := 0;
  num_video := 0;
  num_document := 0;
  num_software := 0;
  num_image := 0;
  num_files := 0;
  num_files_shared := 0;
  bytes_hashed_total := 0;
  num_scanned := 0;
  time_last_check_speed := gettickcount;
  bytes_hashed_before := bytes_hashed_total;
  speed_hash_global := 0;
end;

procedure tthread_share.show_final_library;
var
index_folder: Integer;
 //last_up_grafico: Cardinal;
begin
//last_up_grafico := gettickcount;
init_thread_vars;
try
seterrormode(SEM_FAILCRITICALERRORS);

index_folder := 0;
sharedfolder_scan(false,first_shared_folder,index_folder);
   try

    synchronize(put_end_of_global_hashing);
     sleep(5);

     set_cached_metas;   // rewrite our final library to disk

   if terminated then exit;

     set_trusted_metas;  //rewrite trusted metas...we don't need them anymore , and might have duplicates...so rewrite it


     reset_mime_stats;

     // if loc_sharedList.count>1 then loc_sharedList.sort(ordina_per_size);
      
      categs_compute;
      keyword_genre_compute;

       if terminated then exit;

        sleep(10);
        DHT_generate_hashFilelist;
        dhtkeywords.DHT_keywordsFile_SetGlobal(m_DHT_KeywordFiles);

       synchronize(sharedlist_SetGlobal);
       if terminated then exit else sleep(5);

        categs_sort;
          synchronize(VirFoldersView_update);
          synchronize(RegFoldersView_update);
         
  except
  end;


except
end;
end;



procedure tthread_share.reset_mime_stats;
begin
     num_other := 0;
     num_audio := 0;
     num_video := 0;
     num_document := 0;
     num_software := 0;
     num_image := 0;
     num_files := loc_sharedList_count;
end;

procedure tthread_share.sharedlist_clearGlobal; //synch
var pfile:precord_file_library;
begin
while (vars_global.lista_shared.count>0) do begin
  pfile := vars_global.lista_shared[lista_shared.count-1];
    reset_pfile_strings(pfile);
  FreeMem(pfile,sizeof(record_file_library));
 vars_global.lista_shared.delete(lista_shared.count-1);
 end;
end;


procedure tthread_share.categs_sort;
begin

if artists_audio.count>1 then artists_audio.Sort(CompFunc_strings);
if albums_audio.count>1 then albums_audio.Sort(CompFunc_strings);
if albums_image.count>1 then albums_image.Sort(CompFunc_strings);
if authors_document.count>1 then authors_document.Sort(CompFunc_strings);
if companies_software.count>1 then companies_software.Sort(CompFunc_strings);


if categs_audio.count>1 then categs_audio.Sort(CompFunc_strings);
if categs_video.count>1 then categs_video.Sort(CompFunc_strings);
if categs_image.count>1 then categs_image.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);
if categs_document.count>1 then categs_document.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);

end;



procedure tthread_share.regular_libraryview_assign(folder:precord_cartella_share; node_parent:pCmtVnode; data_parent:precord_cartella_share);
var
node_child:pCmtVnode;
datao:precord_cartella_share;
begin

with ares_frmmain do begin
 with treeview_lib_regfolders do begin

  while (folder<>nil) do begin

 node_child := addchild(node_parent);
  if data_parent=nil then begin
     datao := getdata(node_child);

      if length(folder^.path)<=3 then datao^.display_path := widestrtoutf8str(copy(folder^.path,1,length(folder^.path)))
       else datao^.display_path := widestrtoutf8str(extract_fnameW(copy(folder^.path,1,length(folder^.path))));
  end else begin
        datao := getdata(node_child);
        datao^.display_path := copy(data_parent^.display_path,1,length(datA_parent^.display_path))+'\'+
                             widestrtoutf8str(extract_fnameW(copy(folder^.path,1,length(folder^.path))));
  end;
    with datao^ do begin
      crcpath := folder^.crcpath;
      path_utf8 := copy(folder^.path_utf8,1,length(folder^.path_utf8));
      path := folder^.path;
      items := folder^.items;
      items_shared := folder^.items_shared;
      id := folder^.id;
     end;

        if folder^.first_child<>nil then
         regular_libraryview_assign(folder^.first_child,node_child,datao);

    folder := folder^.next;
  end;


 end;
end;

end;

procedure tthread_share.RegFoldersView_update;
var
nodo_root,nodo_child,prev_node:pCmtVnode;
i: Integer;
data:precord_cartella_share;
begin


with ares_frmmain do begin

 with treeview_lib_regfolders do begin
  beginupdate;
  clear;

nodo_root := addchild(nil);
 data := getdata(nodo_root);
 with data^ do begin
  path := GetLangStringW(STR_SHARED_FOLDERS);
  items := 0;
  items_shared := 0;
 end;
end;


 if first_shared_folder<>nil then
  regular_libraryview_assign(first_shared_folder,nodo_root,nil);


with treeview_lib_regfolders do begin
 ////////////
 nodo_child := nil;
 i := 0;
 repeat
 if i=0 then nodo_child := getnext(nodo_root)
  else nodo_child := getnext(nodo_child);
 if nodo_child=nil then break;
 inc(i);
  data := getdata(nodo_child);
  if data^.items>0 then continue;

   if nodo_child.childcount=0 then begin

    if nodo_child.parent=nodo_root then prev_node := nodo_root
     else prev_node := getPrevious(nodo_child.parent);
       if prev_node=nodo_root then i := 0;

     deletenode(nodo_child,true);
    nodo_child := prev_node;
   end;

 until (not true);
 ///////////////////////////////////////////////////////////////

 
 Expanded[nodo_root] := True;
 endupdate;
 sort(nodo_root,0,sdAscending);
end;

  if btn_lib_regular_view.down then begin
   treeview_lib_regfolders.selected[nodo_root] := True;
   ufrmmain.ares_FrmMain.treeview_lib_regfoldersClick(nil);
  end;
end;

end;


procedure tthread_share.mainGUI_addlibrarynodes;
var
 data_real:ares_types.precord_cartella_share;
 nodo:pCmtVnode;
begin
try

with ares_frmmain do begin

helper_visual_library.add_base_virtualnodes(treeview_lib_virfolders,true);

treeview_lib_regfolders.beginupdate;
clear_treeview(treeview_lib_regfolders,false);

nodo := treeview_lib_regfolders.Addchild(nil);
 data_real := treeview_lib_regfolders.getdata(nodo);
 data_real^.path := GetLangStringW(STR_SHARED_FOLDERS);
 data_real^.items := 0;

 treeview_lib_regfolders.endupdate;


 if btn_lib_regular_view.down then treeview_lib_regfolders.selected[nodo] := true
  else begin
   nodo := treeview_lib_virfolders.getFirst;
   treeview_lib_virfolders.selected[nodo] := True;
  end;

end;

except
end;
end;


procedure tthread_share.VirFoldersView_update;   // in synchronize
var
node1,node2,node3,node_new,nodoroot,nodoaudio,nodoall,nodorecent,
nodoother,nodosoftware,nodovideo,nododocument,nodoimage:pCmtVnode;
records,datao:precord_string;
begin
try
with ares_frmmain do begin
 with treeview_lib_virfolders do begin

 mainGUI_addlibrarynodes;
 
 if terminated then exit;
  nodoroot := GetFirst;

 nodoall := getfirstchild(nodoroot);
  if num_files>0 then begin
   datao := getdata(nodoall);
   datao^.counter := num_files;
   invalidatenode(nodoall);
  end;


 nodoaudio := getnextsibling(nodoall);
  if num_audio>0 then begin
   datao := getdata(nodoaudio);
   datao^.counter := num_audio;
   invalidatenode(nodoaudio);
  end;


  nodoimage := getnextsibling(nodoaudio);
  if num_image>0 then begin
   datao := getdata(nodoimage);
   datao^.counter := num_image;
   invalidatenode(nodoimage);
  end;


  nodovideo := getnextsibling(nodoimage);
  if num_video>0 then begin
   datao := getdata(nodovideo);
   datao^.counter := num_video;
   invalidatenode(nodovideo);
  end;


 nododocument := getnextsibling(nodovideo);
  if num_document>0 then begin
   datao := getdata(nododocument);
   datao^.counter := num_document;
   invalidatenode(nododocument);
  end;


  nodosoftware := getnextsibling(nododocument);
  if num_software>0 then begin
   datao := getdata(nodosoftware);
   datao^.counter := num_software;
   invalidatenode(nodosoftware);
  end;


  nodoother := getnextsibling(nodosoftware);
  if num_other>0 then begin
   datao := getdata(nodoother);
   datao^.counter := num_other;
   invalidatenode(nodoother);
  end;

  nodorecent := getnextsibling(nodoother);
  if num_recent>0 then begin
   datao := getdata(nodorecent);
   datao^.counter := num_recent;
   invalidatenode(nodorecent);
  end;

  // audio
node1 := getfirstchild(nodoaudio);
node2 := getnextsibling(node1);
node3 := getnextsibling(node2);

while (artists_audio.count>0) do begin
records := artists_audio[0];
         artists_audio.delete(0);
 node_new := addchild(node1);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));

sleep(0);
end;

if terminated then exit;

while (albums_audio.count>0) do begin
records := albums_audio[0];
         albums_audio.delete(0);
 node_new := addchild(node2);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;
if terminated then exit;

while (categs_audio.count>0) do begin
records := categs_audio[0];
         categs_audio.delete(0);
 node_new := addchild(node3);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

// immagini
node1 := getfirstchild(nodoimage);
node2 := getnextsibling(node1);
while (albums_image.count>0) do begin
records := albums_image[0];
         albums_image.delete(0);
 node_new := addchild(node1);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

while (categs_image.count>0) do begin
records := categs_image[0];
         categs_image.delete(0);
 node_new := addchild(node2);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

// video
node1 := getfirstchild(nodovideo);
while (categs_video.count>0) do begin
records := categs_video[0];
         categs_video.delete(0);
 node_new := addchild(node1);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

// documenti
node1 := getfirstchild(nododocument);
node2 := getnextsibling(node1);
while (authors_document.count>0) do begin
records := authors_document[0];
         authors_document.delete(0);
 node_new := addchild(node1);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

while (categs_document.count>0) do begin
records := categs_document[0];
         categs_document.delete(0);
 node_new := addchild(node2);
  datao := getdata(node_new);
   with datao^ do begin
    str := copy(records^.str,1,length(records^.str));
    counter := records^.counter;
   end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

// software
node1 := getfirstchild(nodosoftware);
node2 := getnextsibling(node1);
while (companies_software.count>0) do begin
records := companies_software[0];
         companies_software.delete(0);
 node_new := addchild(node1);
  datao := getdata(node_new);
  with datao^ do begin
   str := copy(records^.str,1,length(records^.str));
   counter := records^.counter;
  end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;

if terminated then exit;

while (categs_software.count>0) do begin
records := categs_software[0];
         categs_software.delete(0);
 node_new := addchild(node2);
  datao := getdata(node_new);
  with datao^ do begin
   str := copy(records^.str,1,length(records^.str));
   counter := records^.counter;
  end;
 records^.str := '';
 FreeMem(records,sizeof(record_string));
sleep(0);
end;



  if btn_lib_virtual_view.down then begin
   selected[nodoroot] := True;
   ufrmmain.ares_FrmMain.treeview_lib_virfoldersClick(nil);
  end;

end;
end;
except
end;

end;

procedure tthread_share.getDDrawVideoinfo;
begin
coInitialize(nil);
initDDraw;
info_video.FileSize := GetHugeFileSize(filenW_mpeg);

OleCheck(AMStream.OpenFile(PWideChar(filenW_mpeg), AMMSF_NOCLOCK));

finalizeDDrawInfo;
end;

procedure tthread_share.finalizeDDrawInfo;
var
 GraphBuilder: IGraphBuilder;
 MediaSeeking: IMediaSeeking;
 MMStream: IMultiMediaStream;
 PrimaryVidStream: IMediaStream;
 DDStream: IDirectDrawMediaStream;
 sttim:STREAM_TIME;
 DesiredSurface: TDDSurfaceDesc;
 DDSurface: IDirectDrawSurface;
begin
 try

  AMStream.GetFilterGraph(GraphBuilder);
  MediaSeeking := GraphBuilder as IMediaSeeking;
  MediaSeeking.GetDuration(info_video.MediaLength);
  MMStream := AMStream as IMultiMediaStream;
  OleCheck(MMStream.GetMediaStream(MSPID_PrimaryVideo, PrimaryVidStream));
  DDStream := PrimaryVidStream as IDirectDrawMediaStream;


  DDStream.GetTimePerFrame(sttim);
  info_video.AvgTimePerFrame := sttim;
  {Result.FrameCount := Result.MediaLength div Result.AvgTimePerFrame;}
  { TODO : Test for better accuracy }
  if (info_video.AvgTimePerFrame>0) and (info_video.MediaLength>0) then
  info_video.FrameCount := Round(info_video.MediaLength / info_video.AvgTimePerFrame)
   else info_video.FrameCount := 0;


  info_video.MediaLength := info_video.FrameCount * info_video.AvgTimePerFrame;
  ZeroMemory(@DesiredSurface, SizeOf(DesiredSurface));
  DesiredSurface.dwSize := Sizeof(DesiredSurface);
  OleCheck(DDStream.GetFormat(TDDSurfaceDesc(nil^), IDirectDrawPalette(nil^),DesiredSurface, DWord(nil^)));
  info_video.SurfaceDesc := DesiredSurface;
  DesiredSurface.ddsCaps.dwCaps := DesiredSurface.ddsCaps.dwCaps or
                               DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
  DesiredSurface.dwFlags := DesiredSurface.dwFlags or DDSD_CAPS or DDSD_PIXELFORMAT;
  {Create a surface here to get vital statistics}
  OleCheck(DirectDraw.CreateSurface(DesiredSurface, DDSurface, nil));
  OleCheck(DDSurface.GetSurfaceDesc(DesiredSurface));
  info_video.Pitch := DesiredSurface.lPitch;
  if DesiredSurface.ddpfPixelFormat.dwRGBBitCount = 24 then
   info_video.PixelFormat := pf24bit
  else
    if DesiredSurface.ddpfPixelFormat.dwRGBBitCount = 32 then
      info_video.PixelFormat := pf32bit;
   info_video.Width := DesiredSurface.dwWidth;
    info_video.Height := DesiredSurface.dwHeight;

    except
    end;

end;

procedure tthread_share.initDDraw;
begin
// visual feedback, user is able to find cause of crashes
 try
 with ares_frmmain do begin
  lbl_hash_folder.visible := True;
  lbl_hash_file.visible := True;
  lbl_hash_file.caption := GetLangStringW(STR_FILE)+': '+extract_fnameW(filenW_mpeg);
  lbl_hash_folder.caption := GetLangStringW(STR_FOLDER)+': '+extract_fpathW(filenW_mpeg);
 end;

OleCheck(DirectDrawCreate(nil, DirectDraw, nil));
DirectDraw.SetCooperativeLevel(GetDesktopWindow(), DDSCL_NORMAL);

AMStream := IAMMultiMediaStream(CreateComObject(CLSID_AMMultiMediaStream));
OleCheck(AMStream.Initialize(STREAMTYPE_READ, AMMSF_NOGRAPHTHREAD, nil));
OleCheck(AMStream.AddMediaStream(DirectDraw, @MSPID_PrimaryVideo, 0, IMediaStream(nil^)));
   except
   end;
end;






function tthread_share.deal_with_newfile(shouldhash: Boolean; folder:precord_cartella_share; nomefile: WideString; utf8path: string; fsize: Int64; amime:integer): Boolean;
var
param1,param2,param3: Integer;
language,format: string;
ext: string;
duratawav:variant;
rec_artist_album_title:precord_title_album_artist;
durata: Int64;
requested: Word;

crcsha1: Word;
indexfile: Integer;

hash_sha1,hash_of_phash: string;
pfile_found,pfile,last_pfile:precord_file_library;
point_of_insertion: Cardinal;
begin
result := False;

  ext := fileScan^.ext;

  
   if not shouldhash then begin
     inc(bytes_tohash_total,fsize);
     inc(num_to_scan);
   end;

  artist := '';
  title := '';
  format := '';
  language := '';
  category := '';
  param1 := 0;
  param2 := 0;
  param3 := 0;
  album := '';
  comment := '';
  year := '';
  url := '';

if ext='.mp3' then begin      // mp3
     try
     if not mp3.ReadFromFile(nomefile) then exit;
     except
     exit;
     end;
     if not mp3.Valid then exit;
     if helper_fakes.isFakeFile(nomefile) then exit;
     
      param1 := mp3.BitRate;
      param3 := trunc(mp3.Duration);
      param2 := mp3.SampleRate;
    if mp3.id3v2.exists then begin
       title := mp3.id3v2.Title;
       artist := mp3.id3v2.artist;
       album := mp3.id3v2.Album;
       category := mp3.id3v2.Genre;
       comment := '';
       year := mp3.id3v2.Year;
       if mp3.id3v2.comment<>mp3.id3v2.Link then url := mp3.id3v2.Link;
        //if pos('http://',url)<>0 then url := '' else
        //if pos('www.',url)<>0 then url := '';
     end else
      if mp3.ID3v1.Exists then begin
       title := mp3.id3v1.Title;
       artist := mp3.id3v1.artist;
       album := mp3.id3v1.Album;
       category := mp3.id3v1.Genre;
       comment := '';
       year := mp3.id3v1.Year;
     end;

end else
if ext='.flv' then begin
  try
    raudio^ := get_flv_infos(nomefile);
    param1 := raudio^.bitrate;
    param2 := raudio^.frequency;
    param3 := raudio^.duration;
    format := 'FLV '+raudio^.codec;
  except
   exit;
  end;
end else
if (ext='.aac') then begin
     try
     if not aac.ReadFromFile(nomefile) then exit;
     except
     exit;
     end;
     if not aac.Valid then exit;

      param1 := aac.BitRate;
      param3 := trunc(aac.Duration);
      param2 := aac.SampleRate;
    if aac.id3v2.exists then begin
       title := aac.id3v2.Title;
       artist := aac.id3v2.artist;
       album := aac.id3v2.Album;
       category := aac.id3v2.Genre;
       comment := aac.id3v2.Comment;
       year := aac.id3v2.Year;
       url := aac.id3v2.Link;
        //if pos('http://',url)<>0 then url := '' else
        //if pos('www.',url)<>0 then url := '';
     end else
      if aac.ID3v1.Exists then begin
       title := aac.id3v1.Title;
       artist := aac.id3v1.artist;
       album := aac.id3v1.Album;
       category := aac.id3v1.Genre;
       comment := aac.id3v1.Comment;
       year := aac.id3v1.Year;
     end;

end else
if ext='.flac' then begin
  try
  if not flac.ReadFromFile(nomefile) then exit;
  except
  exit;
  end;
  if not flac.Valid then exit;
  param1 := Flac.Bitrate;
  param2 := flac.SampleRate;
  param3 := trunc(flac.duration);
  if flac.FlacVorbisTag.exists then begin
       title := flac.FlacVorbisTag.Title;
       artist := flac.FlacVorbisTag.artist;
       album := flac.FlacVorbisTag.Album;
       category := flac.FlacVorbisTag.Genre;
       comment := flac.FlacVorbisTag.Comment;
       year := flac.FlacVorbisTag.Year;
       url := flac.FlacVorbisTag.url;
       // if pos('http://',url)<>0 then url := '' else
       // if pos('www.',url)<>0 then url := '';
  end else
  if flac.id3v2.exists then begin
       title := flac.id3v2.Title;
       artist := flac.id3v2.artist;
       album := flac.id3v2.Album;
       category := flac.id3v2.Genre;
       comment := flac.id3v2.Comment;
       year := flac.id3v2.Year;
       url := flac.id3v2.Link;
       // if pos(chr(104)+chr(116)+chr(116)+chr(112)+chr(58)+chr(47)+chr(47){'http://'},url)<>0 then url := '' else
       // if pos(chr(119)+chr(119)+chr(119)+chr(46){'www.'},url)<>0 then url := '';
  end else
  if flac.ID3v1.Exists then begin
       title := flac.id3v1.Title;
       artist := flac.id3v1.artist;
       album := flac.id3v1.Album;
       category := flac.id3v1.Genre;
       comment := flac.id3v1.Comment;
       year := flac.id3v1.Year;
   end;
end else
if ext='.vqf' then begin
 try
  if not vqf.ReadFromFile(nomefile) then exit;
 except
  exit;
 end;
 if not vqf.Valid then exit;
 param1 := vqf.BitRate;
 param2 := vqf.SampleRate;
 param3 := trunc(vqf.duration);

 title := vqf.Title;
 artist := vqf.Author;
 album := vqf.Album;
 comment := vqf.Comment;
end else
if ext='.mpc' then begin
try
  if not mpc.ReadFromFile(nomefile) then begin
  exit;
  end;
 except
  exit;
 end;
 if not mpc.Valid then exit;
 param1 := mpc.bitrate;
 param2 := mpc.samplerate;
 param3 := trunc(mpc.duration);
  if mpc.APEtag.exists then begin
       title := mpc.APEtag.Title;
       artist := mpc.APEtag.artist;
       album := mpc.APEtag.Album;
       category := mpc.APEtag.Genre;
       comment := mpc.APEtag.Comment;
       year := mpc.APEtag.Year;
  end else
  if mpc.ID3v1.Exists then begin
       title := mpc.id3v1.Title;
       artist := mpc.id3v1.artist;
       album := mpc.id3v1.Album;
       category := mpc.id3v1.Genre;
       comment := mpc.id3v1.Comment;
       year := mpc.id3v1.Year;
   end;
end else
if ext='.ape' then begin
 try
  if not ape.ReadFromFile(nomefile) then begin
  exit;
  end;
 except
  exit;
 end;
 if not ape.Valid then exit;
 param1 := ape.bitrate;
 param2 := ape.samplerate;
 param3 := trunc(ape.duration);
  if ape.APEtag.exists then begin
       title := ape.APEtag.Title;
       artist := ape.APEtag.artist;
       album := ape.APEtag.Album;
       category := ape.APEtag.Genre;
       comment := ape.APEtag.Comment;
       year := ape.APEtag.Year;
  end else
   if ape.id3v2.exists then begin
       title := ape.id3v2.Title;
       artist := ape.id3v2.artist;
       album := ape.id3v2.Album;
       category := ape.id3v2.Genre;
       comment := ape.id3v2.Comment;
       year := ape.id3v2.Year;
       url := ape.id3v2.Link;
       //if pos(chr(104)+chr(116)+chr(116)+chr(112)+chr(58)+chr(47)+chr(47){'http://'},url)<>0 then url := '' else
       // if pos(chr(119)+chr(119)+chr(119)+chr(46){'www.'},url)<>0 then url := '';
  end else
  if ape.ID3v1.Exists then begin
       title := ape.id3v1.Title;
       artist := ape.id3v1.artist;
       album := ape.id3v1.Album;
       category := ape.id3v1.Genre;
       comment := ape.id3v1.Comment;
       year := ape.id3v1.Year;
   end;
end else
if ext='.ogg' then begin
 try
  if not ogg.ReadFromFile(nomefile) then exit;
 except
  exit;
 end;
 if not ogg.Valid then exit;
 param1 := ogg.BitRateNominal;
 param2 := ogg.SampleRate;
 param3 := trunc(ogg.duration);

title := ogg.Title;
artist := ogg.Artist;
album := ogg.Album;
year := ogg.Date;
comment := ogg.Comment;
category := ogg.Genre;

end else
if ext='.wma' then begin
 try
  if not wma.ReadFromFile(nomefile) then exit;
 except
  exit;
 end;
 if not wma.Valid then exit;
 param1 := wma.BitRate;
 param2 := wma.SampleRate;
 param3 := trunc(wma.duration);
 title := widestrtoutf8str(wma.Title);
 artist := widestrtoutf8str(wma.Artist);
 album := widestrtoutf8str(wma.album);
 category := widestrtoutf8str(wma.genre);
 comment := widestrtoutf8str(wma.comment);
 year := widestrtoutf8str(wma.year);
end else

if ext='.wav' then begin
   try
   if not wav.ReadFromFile(nomefile) then exit;
   except
   exit;
   end;
   if not wav.Valid then exit;
   param1 := wav.BitsPerSample;
   param2 := wav.SampleRate;
   duratawav := wav.duration;
   param3 := duratawav;
end else
if ext='.exe' then begin
 try
   if exe=nil then exit;
   exe.FileName := nomefile;
   exe.GetFileInfo(nomefile);
   if exe.HaveVersionInfo then begin
   param1 := exe.FileOS;
   param2 := exe.Language;
   title := trim(widestrtoutf8str(exe.GetValue('ProductName'))); // trim here even if it looks so ugly
   artist := trim(widestrtoutf8str(exe.getvalue('CompanyName')));
   album := trim(widestrtoutf8str(exe.GetValue('FileVersion')));
   if ((title='No such VersionInfo') or
       (artist='No such VersionInfo') or
       (album='No such VersionInfo')) then begin
    title := '';
    artist := '';
    album := '';
    param1 := 0;
    param2 := 0;
   end;
   end else begin
    title := '';
    artist := '';
    album := '';
    param1 := 0;
    param2 := 0;
   end;
   year := ottieni_data_exe(nomefile);
 except
   exit;
 end;
end else
if ((ext='.bmp') or
    (ext='.jpg') or
    (ext='.gif') or
    (ext='.png') or
    (ext='.pcx') or
    (ext='.tiff') or
    (ext='.jpeg')) then begin
      if pos(STR_ALBUMART,lowercase(nomefile))<>0 then exit;
   try
   immagine.ReadFile(nomefile);
   param1 := immagine.Width;
   param2 := immagine.height;
   param3 := immagine.Depth;
   except
   exit;
   end;
   if ((param1=0) or (param2=0) or (param3=0)) then exit;
    try
    parse_iptc(nomefile);
    except
    end;
end else
if ext='.psd' then begin
  try
  raudio^ := ricava_dati_psd(nomefile);
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;
  except
  exit;
  end;
  if ((param1=0) or (param2=0) or (param3=0)) then exit;
       parse_iptc(nomefile);
end else
  if ext='.psp' then begin
  try
  raudio^ := ricava_dati_psp(nomefile);
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;
  except
  exit;
  end;
  if ((param1=0) or (param2=0) or (param3=0)) then exit;
      parse_iptc(nomefile);
end else
if ext='.mp4' then begin
 mp4.readFile(nomefile);
 if (mp4.fduration<=0) or (mp4.fwidth<=0) or (mp4.fheight<=0) then exit;
 param1 := mp4.fwidth;
 param2 := mp4.fheight;
 param3 := mp4.fduration;
 format := 'MP4';
end else
if ext='.mov' then begin
  try
  raudio^ := ricava_dati_mov(nomefile);
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;
  if param1=0 then begin
   param1 := 0;
   param2 := 0;
   param3 := 0;
  end;
  format := 'QTime';
  except
   param1 := 0;
   param2 := 0;
   param3 := 0;
  end;
end else
if ext='.avi' then begin
 try
  if helper_fakes.isFakeFile(nomefile) then exit;
  raudio^ := ricava_dati_avi(nomefile);
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;
  format := 'AVI '+uppercase(raudio^.codec);
  if param1=0 then begin
         format := 'AVI';
       filenW_mpeg := nomefile;
      try
  getDDrawVideoinfo;
       if info_video.width<4000 then begin
        param1 := info_video.Width;
        param2 := info_video.height;
        param3 := info_video.medialength div 10000000;
       end else begin
        param1 := 0;
        param2 := 0;
        param3 := 0;
       end;
      except
       param1 := 0;
       param2 := 0;
       param3 := 0;
      end;
  end;
  except
       format := 'AVI';
       filenW_mpeg := nomefile;
      try
  getDDrawVideoinfo;
       if info_video.width<4000 then begin
        param1 := info_video.Width;
        param2 := info_video.height;
        param3 := info_video.medialength div 10000000;
       end else begin
        param1 := 0;
        param2 := 0;
        param3 := 0;
       end;
      except
       param1 := 0;
       param2 := 0;
       param3 := 0;
      end;
  end;
  if ((param1=0) or (param2=0) or (param3=0)) then begin
       param1 := 0;
       param2 := 0;
       param3 := 0;
  end;
 if param1=0 then exit;
   if ((amime=5) and (((param1>4000) or (param2>4000)))) then begin
    param1 := 0;
    param2 := 0;
    param3 := 0;
   end;
end else
  if ((ext='.mpe') or
      (ext='.mpg') or
      (ext='.wmv') or
      (ext='.mpa') or
      (ext='.mpeg')) then begin
  if ext='.wmv' then begin
   if is_trojan_wmv(nomefile,fsize) then exit;
  end;
  filenW_mpeg := nomefile;
  try
  getDDrawVideoinfo;
  param1 := info_video.Width;
  param2 := info_video.height;
  param3 := info_video.medialength div 10000000;
  except
       param1 := 0;
       param2 := 0;
       param3 := 0;
  end;
  if ((param1=0) or (param2=0) or (param3=0)) then begin
       param1 := 0;
       param2 := 0;
       param3 := 0;
  end;
format := 'MPEG';
  if param1=0 then exit;
   if ((amime=5) and (((param1>4000) or (param2>4000)))) then begin
    param1 := 0;
    param2 := 0;
    param3 := 0;
   end;
end else
if ((ext='.doc') or (ext='.ppt')) then begin
  try
  extract_msword_infos;
  except
  end;
end else
if ext='.arescol' then begin
 arescol_get_meta(nomefile,title,comment,url,amime);
end;


   title := strip_track(title);
  if (((lowercase(title)='unknown') or
      (length(title)=0)) and (amime=1) or (amime=2) or (amime=4) or (amime=5)) then begin
   rec_artist_album_title := AllocMem(sizeof(record_title_album_artist));
   try
   estrai_titolo_artista_album_da_stringa(rec_artist_album_title,nomefile);
    if artist='' then artist := trim(widestrtoutf8str(rec_artist_album_title^.artist));
    if album='' then album := trim(widestrtoutf8str(rec_artist_album_title^.album));
    title := trim(widestrtoutf8str(rec_artist_album_title.title));
   except
   end;
   FreeMem(rec_artist_album_title,sizeof(record_title_album_artist));
  end else
  if ((lowercase(title)='unknown') or (length(title)=0)) then begin
   title := trim(widestrtoutf8str(extract_fnameW(nomefile)));
   delete(title,(length(title)-length(ext))+1,length(ext));
  end;




 //check overflows...........
      if length(title)>MAX_LENGTH_TITLE then delete(title,MAX_LENGTH_TITLE,length(title));
      if length(artist)>MAX_LENGTH_FIELDS then delete(artist,MAX_LENGTH_FIELDS,length(artist));
      if length(album)>MAX_LENGTH_FIELDS then delete(album,MAX_LENGTH_FIELDS,length(album));
      if length(category)>MAX_LENGTH_FIELDS then delete(category,MAX_LENGTH_FIELDS,length(category));
      if length(language)>MAX_LENGTH_FIELDS then delete(language,MAX_LENGTH_FIELDS,length(language));
      if length(year)>MAX_LENGTH_FIELDS then delete(year,MAX_LENGTH_FIELDS,length(year));
      if length(comment)>MAX_LENGTH_COMMENT then delete(comment,MAX_LENGTH_COMMENT,length(comment));
      if length(url)>MAX_LENGTH_URL then delete(url,MAX_LENGTH_URL,length(url));
////////////////////////////////////

if shouldhash then begin
 hash_sha1 := '';
 try
 hash_compute(fileScan^.fname,fsize,hash_sha1,hash_of_phash,point_of_insertion);
 except
  exit;
 end;
 if length(hash_sha1)<>20 then exit;

 if terminated then exit;

 crcsha1 := crcstring(hash_sha1);
 if terminated then exit;
 if already_in_DBTOWRITE(hash_sha1,crcsha1) then exit;
end else begin
 hash_sha1 := chr(0); //per bypassare violazione d'accesso?
 crcsha1 := 0;
 point_of_insertion := 0;
end;

 pfile := AllocMem(sizeof(record_file_library));
  pfile^.hash_of_phash := hash_of_phash;
  pfile^.hash_sha1 := hash_sha1;
  pfile^.crcsha1 := crcsha1;
  pfile^.phash_index := point_of_insertion;
  pfile^.path := utf8path;
  pfile^.fsize := fsize;
  pfile^.filedate := 0;
  pfile^.corrupt := False;
  pfile^.title := strip_apos_amp(title);
  pfile^.artist := strip_apos_amp(artist);
  pfile^.album := strip_apos_amp(album);
  pfile^.category := strip_apos_amp(category);
  pfile^.param1 := param1;
  pfile^.param2 := param2;
  pfile^.param3 := param3;
  pfile^.shared := (length(pfile^.title)>1);
  pfile^.vidinfo := format;
  pfile^.folder_id := folder^.id;
  pfile^.comment := strip_apos_amp(comment);
  pfile^.year := strip_apos_amp(year);
  pfile^.language := strip_apos_amp(language);
  pfile^.amime := amime;
  pfile^.mediatype := mediatype_to_str(amime);
  pfile^.ext := ext;
  pfile^.url := url;

 if shouldhash then begin
  assign_trusted_metas(pfile);
  if pfile^.corrupt then pfile^.shared := False;

    inc(folder^.items);
    if pfile^.shared then inc(folder^.items_shared);

    if ((pfile^.amime=ARES_MIME_MP3) and (pfile^.shared)) then add_keyword_genre(category,artist);
 end;

  if ((amime=ARES_MIME_VIDEO) or (amime=ARES_MIME_IMAGE)) then begin
   if is_teen_content(category) then pfile^.corrupt := true else
   if is_teen_content(title) then pfile^.corrupt := true else
   if is_teen_content(utf8path) then pfile^.corrupt := true else
   if is_teen_content(artist) then pfile^.corrupt := True;
    if pfile^.corrupt then pfile^.shared := False;
  end;


 pfile^.previewing := (not shouldhash);
 if pfile^.previewing then pfile^.shared := False;

   if DB_TOWRITE[ord(pfile^.hash_sha1[1])]=nil then pfile^.next := nil
    else begin
     last_pfile := DB_TOWRITE[ord(pfile^.hash_sha1[1])];
     pfile^.next := last_pfile;
   end;
   DB_TOWRITE[ord(pfile^.hash_sha1[1])] := pfile;
   inc(loc_sharedList_count);

   if ((shouldHash) and (pfile^.shared)) then begin

    if pfile^.amime=ARES_MIME_MP3 then
     if pos(pfile^.ext,STR_DRM_EXT)<>0 then begin
      Result := True;
      exit;
     end;

    dhtkeywords.DHT_get_keywordsFromFile(pfile, m_DHT_KeywordFiles);

   end;

result := True;
end;   //fine se non trovato



function tthread_share.add_to_sharedlist(shouldhash: Boolean; folder:precord_cartella_share): Boolean;
var
pfile_found,pfile,last_pfile:precord_file_library;
nomefile: WideString;
utf8path: string;
fsize: Int64;
amime: Integer;
phash_indx:precord_phash_index;
begin
result := False;

if terminated then exit;

try

  nomefile := fileScan^.fname;
  utf8path := widestrtoutf8str(nomefile);
  fsize := fileScan^.fsize;
  amime := fileScan^.amime;

 pfile_found := DB_everseen(utf8path,fsize);
 if pfile_found=nil then begin
  Result := deal_with_newfile(shouldhash,folder,nomefile,utf8path,fsize,amime);
   sleep(1);
  exit;
 end;

 if pfile_found^.ext='.wmv' then begin
   if is_trojan_wmv(nomefile,fsize) then begin
    Result := False;
    exit;
   end;
 end;

 if already_in_DBTOWRITE(pfile_found^.hash_sha1,pfile_found^.crcsha1) then exit; // ho già aggiunto uno simile

 if pfile_found^.fsize>ICH_MIN_FILESIZE then begin
  phash_indx := ICH_find_phash_index(pfile_found^.hash_sha1,pfile_found^.crcsha1);
  if shouldhash then ICH_copyEntry_to_tmp_db(phash_indx);
 end else phash_indx := nil;

   pfile := AllocMem(sizeof(record_file_library));
   with pfile^ do begin
    album := pfile_found^.album;
    artist := pfile_found^.artist;
    category := pfile_found^.category;
    mediatype := pfile_found^.mediatype;
    if pfile_found^.fsize>ICH_MIN_FILESIZE then phash_index := phash_indx^.db_point_on_disk
     else phash_index := 0;
    filedate := 0;
    vidinfo := pfile_found^.vidinfo;
    comment := pfile_found^.comment;
    language := pfile_found^.language;
    param1 := pfile_found^.param1;
    param2 := pfile_found^.param2;
    param3 := pfile_found^.param3;
    path := pfile_found^.path;
    folder_id := folder^.id;
    title := pfile_found^.title;
    url := pfile_found^.url;
    fsize := pfile_found^.fsize;
    amime := pfile_found^.amime;
    year := pfile_found^.year;
    imageindex := pfile_found^.imageindex;
    hash_of_phash := pfile_found^.hash_of_phash;
    hash_sha1 := pfile_found^.hash_sha1;
    crcsha1 := pfile_found^.crcsha1;
    keywords_genre := pfile_found^.keywords_genre;
    ext := pfile_found^.ext;
    corrupt := True;
    write_to_disk := False;
    shared := False;
   end;

   if DB_TOWRITE[ord(pfile^.hash_sha1[1])]=nil then pfile^.next := nil
    else begin
     last_pfile := DB_TOWRITE[ord(pfile^.hash_sha1[1])];
     pfile^.next := last_pfile;
   end;
   DB_TOWRITE[ord(pfile^.hash_sha1[1])] := pfile;
   inc(loc_sharedList_count);

 

 if not shouldhash then pfile^.previewing := true
 else begin     //se invece non siamo in preview assegniamo alcuni metas da trusted....

      assign_trusted_metas(pfile);
      if pfile^.corrupt then begin
       pfile^.shared := False;
      end;

      if pfile^.shared then pfile^.shared := (length(pfile_found^.title)>1);

       pfile^.folder_id := folder^.id;

           inc(folder^.items);
            if pfile^.shared then inc(folder^.items_shared);

  if ((pfile^.amime=ARES_MIME_MP3) and (pfile^.shared)) then add_keyword_genre(pfile^.category,pfile^.artist);

  if ((amime=ARES_MIME_VIDEO) or (amime=ARES_MIME_IMAGE)) then begin
   if is_teen_content(pfile^.category) then pfile^.corrupt := true else
   if is_teen_content(pfile^.title) then pfile^.corrupt := true else
   if is_teen_content(pfile^.path) then pfile^.corrupt := true else
   if is_teen_content(pfile^.artist) then pfile^.corrupt := True;
    if pfile^.corrupt then pfile^.shared := False;
  end;
   pfile^.previewing := False;

   if pfile^.shared then begin
      if pfile^.amime=ARES_MIME_IMAGE then begin
       if pos(STR_ALBUMART,lowercase(pfile^.title))=0 then dhtkeywords.DHT_get_keywordsFromFile(pfile, m_DHT_KeywordFiles);
      end else begin

         if pfile^.amime=ARES_MIME_MP3 then
          if pos(pfile^.ext,STR_DRM_EXT)<>0 then begin
           Result := True;
           exit;
         end;

         dhtkeywords.DHT_get_keywordsFromFile(pfile, m_DHT_KeywordFiles);

      end;
   end;
 end;
 
  Result := True;

 except
 end;
end;




procedure tthread_share.sharedlist_getGlobal; //importiamo library da form1 solo se sono file che hanno già hash e quindi già pronti per essere rimessi in circolo
var
pfile:precorD_file_library;
begin

while (vars_global.lista_shared.count>0) do begin
  pfile := vars_global.lista_shared[vars_global.lista_shared.count-1];


  reset_pfile_strings(pfile);
  FreeMem(pfile,sizeof(record_file_library));

    vars_global.lista_shared.delete(vars_global.lista_shared.count-1);
end;

vars_global.my_shared_count := 0;  //impostazione per client?
end;


procedure tthread_share.hash_compute(const FileName: widestring; fsize: Int64; var sha1: string; var hash_of_phash: string; var point_of_insertion: Cardinal);
var
  stream: Thandlestream;
  NumBytes: Integer;
  buffer: array [1..1024] of char;
  csha1: Tsha1;

  i: Integer;
  last_sync: Cardinal;
  divisore: Integer;
  attesa: Word;

  phash_value: string;
  buffer_phash: array [0..19] of char;
  phash_sha1: Tsha1;
  stream_phash: Thandlestream;
  phash_chunk_size: Cardinal;
  bytes_processed_phash: Cardinal;
begin


    stream := MyFileOpen(FileName,ARES_READONLY_BUT_SEQUENTIAL);
    if stream=nil then exit;

    if stream.size<fsize then begin
      FreeHandleStream(Stream);
    exit;
    end;



   i := 0;
   divisore := 25;
    last_sync := gettickcount;


 synchronize(get_hash_throttle);
 case loc_hash_throttle of
  0:begin
     if priority<>tpnormal then priority := tpnormal;
     attesa := 0;
    end;
  1:begin
     if priority<>tpnormal then priority := tpnormal;
     attesa := 1;
     end;
  2:begin
     if priority<>tplower then priority := tplower;
     attesa := 5;
     end;
  3:begin
     if priority<>tplowest then priority := tplowest;
     attesa := 12;
     end;
  4:begin
    if priority<>tpidle then priority := tpidle;
    attesa := 25;
    end;
  5:begin
    if priority<>tpidle then priority := tpidle;
    attesa := 50;
    end else attesa := 50;
 end;

  filenW_hash := filename;
  sizefile_hash := fsize;
  progressfile_hash := 0;

 synchronize(put_hash_file_name);


   cSHA1 := TSHA1.Create;

   bytes_processed_phash := 0;

    if fsize>ICH_MIN_FILESIZE then begin
     phash_chunk_size := ICH_calc_chunk_size(fsize);
     phash_sha1 := tsha1.create;

      stream_phash := MyFileOpen(data_path+'\Data\TempPHash.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream_phash=nil then begin
        FreeHandleStream(stream);
       exit;
      end;
    end else begin
     phash_chunk_size := 0;
     stream_phash := nil;
     phash_sha1 := nil;
    end;


  repeat

   if (i mod 10)=0 then sleep(attesa) else sleep(0);

       inc(i);
       if (i mod divisore)=0 then begin

         if terminated then begin
          FreeHandleStream(stream);
          if stream_phash<>nil then FreeHandleStream(stream_phash);
          if phash_sha1<>nil then phash_sha1.Free;
          csha1.Free;
          exit;
         end;

        if gettickcount-last_sync>5*TENTHOFSEC then begin
         last_sync := gettickcount;
         synchronize(put_hash_progress);

          case loc_hash_throttle of
           0:begin
              if priority<>tpnormal then priority := tpnormal;
              divisore := 300;
              attesa := 0;
           end;
           1:begin
            if priority<>tpnormal then priority := tpnormal;
            divisore := 130;
            attesa := 1;
            end;
           2:begin
             if priority<>tplowest then priority := tplowest;
             divisore := 50;
             attesa := 5;
             end;
           else begin
             if priority<>tpidle then priority := tpidle;
             divisore := 24;
             if loc_hash_throttle=4 then attesa := 25 else
              if loc_hash_throttle=5 then attesa := 50 else attesa := 12;
           end;
          end;
        end;
       end;

        NumBytes := stream.read(Buffer, SizeOf(Buffer));



        cSHA1.Transform(Buffer, NumBytes);


        inc(progressfile_hash,NumBytes);
        inc(bytes_hashed_total,NumBytes);

        if phash_sha1<>nil then begin

         phash_sha1.Transform(buffer, NumBytes);

         inc(bytes_processed_phash,NumBytes);
         if bytes_processed_phash=phash_chunk_size then begin
              phash_sha1.Complete;
                phash_value := phash_sha1.HashValue;
                move(phash_value[1],buffer_phash,20);
                stream_phash.write(buffer_phash,20);
              phash_sha1.Free;
              phash_sha1 := Tsha1.create;
              bytes_processed_phash := 0;

         end;
        end;


        if terminated then begin
          if phash_sha1<>nil then phash_sha1.Free;
          cSHA1.Free;
           FreeHandleStream(stream);
           if stream_phash<>nil then FreeHandleStream(Stream_phash);
           exit;
        end;

      until (numbytes<>sizeof(buffer));

   FreeHandleStream(Stream);
   
  cSHA1.Complete;
   sha1 := cSHA1.HashValue;
  cSHA1.Free;

  if phash_sha1<>nil then begin
   if bytes_processed_phash>0 then begin
     phash_sha1.Complete;
      phash_value := phash_sha1.HashValue;
      move(phash_value[1],buffer_phash,20);
      stream_phash.write(buffer_phash,20);
                //FlushFileBuffers(stream.handle);
   end;

   phash_sha1.Free;
   FreeHandleStream(stream_phash);
   hash_of_phash := ICH_get_hash_of_phash(sha1);
   point_of_insertion := ICH_copy_temp_to_tmp_db(sha1);
  end;

  inc(num_scanned);
  
  synchronize(put_end_hash);

 priority := tpnormal;
end;




procedure tthread_share.hide_scan_folders; //synch
begin
 with ares_frmmain do begin
  panel_hash.capt := chr(32);
  lbl_hash_progress.caption := chr(32);
  lbl_hash_folder.Visible := False;
  lbl_hash_file.visible := False;
  lbl_hash_progress.visible := False;
  lbl_hash_pri.visible := False;
  progbar_hash_file.visible := False;
  progbar_hash_total.visible := False;
  hash_pri_trx.visible := False;
  lbl_hash_filedet.visible := False;
 end;
end;

procedure tthread_share.put_hash_file_name; //synch
begin
with ares_frmmain do begin
 panel_hash.capt := ' '+GetLangStringW(STR_HASH_CALCULATIONINPROGRESS);
 lbl_hash_hint.caption := GetLangStringW(STR_HASH_HINT);
 lbl_hash_hint.visible := True;
 lbl_hash_pri.visible := True;
 hash_pri_trx.visible := True;
 progbar_hash_file.visible := True;
 progbar_hash_total.visible := True;
 lbl_hash_progress.visible := True;
 lbl_hash_folder.visible := True;
 lbl_hash_file.visible := True;
 lbl_hash_filedet.visible := True;
 lbl_hash_file.caption := GetLangStringW(STR_FILE)+': '+extract_fnameW(filenW_hash);
 lbl_hash_folder.caption := GetLangStringW(STR_FOLDER)+': '+extract_fpathW(filenW_hash);
end;

  put_hash_progress;

end;


procedure tthread_share.put_end_of_global_hashing; //sync
begin
 with ares_frmmain do begin
  progbar_hash_file.position := progbar_hash_file.max;
  progbar_hash_total.position := progbar_hash_total.max;
 end;

bytes_tohash_total := bytes_tohash_total;
bytes_hashed_before := bytes_tohash_total;
bytes_hashed_total := bytes_tohash_total;

progressfile_hash := sizefile_hash;
num_scanned := num_to_scan;

put_hash_progress;
end;

procedure tthread_share.put_hash_progress;
var
perc:extended;
tempo: Cardinal;
size_remaining: Int64;
speed:extended;
begin
 try

 tempo := gettickcount;

 get_hash_throttle;
 with ares_frmmain do begin
  
  lbl_hash_progress.caption := format_currency(progressfile_hash)+' '+GetLangStringW(STR_OF)+' '+
                                             format_currency(sizefile_hash)+' '+STR_BYTES;
  with progbar_hash_file do begin
   position := progressfile_hash div KBYTE;
   max := sizefile_hash div KBYTE;
  end;
  with progbar_hash_total do begin
   max := bytes_tohash_total div KBYTE;
   position := (bytes_hashed_total div KBYTE);
  end;
 end;

 if tempo-time_last_check_speed>5 then begin
  speed := (bytes_hashed_total-bytes_hashed_before) * (1000 / (tempo-time_last_check_speed));
  speed := speed / 1024;
   if speed>0 then speed_hash_global := ((speed_hash_global / 10)*9)+(speed / 10)
    else speed_hash_global := 0;
 end else begin
  speed := 0;
  speed_hash_global := (speed_hash_global / 10)*9;
 end;

 size_remaining := bytes_tohash_total-bytes_hashed_before;

 bytes_hashed_before := bytes_hashed_total;
 time_last_check_speed := tempo;

 if bytes_tohash_total<=MEGABYTE+1 then perc := 0
  else
 perc := ((bytes_hashed_total div MEGABYTE) / (bytes_tohash_total div MEGABYTE))*100;

 if speed_hash_global>1 then ares_FrmMain.lbl_hash_filedet.caption := format_currency(num_scanned)+' '+GetLangStringW(STR_OF)+' '+format_currency(num_to_scan)+' '+GetLangStringW(STR_FILES)+'  ( '+
                           format_currency(bytes_hashed_total div KBYTE)+STR_KB+' '+GetLangStringW(STR_OF)+' '+format_currency(bytes_tohash_total div KBYTE)+
                           STR_KB+'  '+FloatToStrF(perc, ffNumber, 18, 0)+'% )   '+
                            FloatToStrF(speed_hash_global, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC)+'   '+
                            format_time((size_remaining div KBYTE) div trunc(speed_hash_global))
                            else
 ares_FrmMain.lbl_hash_filedet.caption := format_currency(num_scanned)+' '+GetLangStringW(STR_OF)+' '+format_currency(num_to_scan)+' '+GetLangStringW(STR_FILES)+'  ( '+
                           format_currency(bytes_hashed_total div KBYTE)+STR_KB+' '+GetLangStringW(STR_OF)+' '+format_currency(bytes_tohash_total div KBYTE)+
                           STR_KB+'  '+FloatToStrF(perc, ffNumber, 18, 0)+'% )   '+
                           '0.00'+GetLangStringW(STR_KB_SEC)+'   '+STR_NA;
   sleep(0);
 except
 end;
end;

procedure tthread_share.put_clear_hash_file_name; //synch
begin
with ares_frmmain do begin
 lbl_hash_file.caption := GetLangStringW(STR_FILE)+':';
 lbl_hash_folder.caption := GetLangStringW(STR_FOLDER)+':';
 lbl_hash_progress.caption := GetLangStringW(STR_PROGRESS)+':';
 progbar_hash_file.position := 0;
 progbar_hash_file.max := 10;
end;
end;

procedure tthread_share.put_end_hash; //synch
begin
with ares_frmmain do begin
 progbar_hash_file.position := progbar_hash_file.max;
 lbl_hash_progress.caption := format_currency(sizefile_hash)+' '+
                                             GetLangStringW(STR_OF)+' '+format_currency(sizefile_hash)+
                                             ' '+STR_BYTES;

  // with progbar_hash_total do position := max;
end;
end;





procedure tthread_share.get_hash_throttle; //synch
begin
loc_hash_throttle := vars_global.hash_throttle;
end;

procedure tthread_share.AddmswordProperty(propid: DWORD; Value: Pointer);
 const
  PID_TITLE = $00000002;
  PID_SUBJECT = $00000003;
  PID_AUTHOR = $00000004;
  PID_KEYWORDS = $00000005;
  PID_COMMENTS = $00000006;
   PID_PAGECOUNT = $0000000E;
   PID_LASTSAVE_DTM = $0000000D;
  var
  pagecount: Integer;
  pages: string;
  FileTime: TFileTime;
  date: Tdatetime;

  function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  FileDate: Integer;
  LocalFileTime: TFileTime;
begin
  Result := 0;
  if FileTimeToLocalFileTime(FileTime, LocalFileTime) and
     FileTimeToDosDateTime(LocalFileTime,
                           LongRec(FileDate).Hi, LongRec(FileDate).Lo)
  then
    try Result := FileDateToDateTime(FileDate); except Result := 0; end;
end;

begin



  case propid of
    PID_TITLE: Title := PChar(Value);
    PID_SUBJECT:category := PChar(Value);
    PID_AUTHOR:artist := PChar(Value);
    //PID_KEYWORDS:album := PChar(Value);
    PID_COMMENTS:begin
       if length(comment)=0 then Comment := PChar(Value) else
       Comment := comment+chr(32)+PChar(Value);
      end;
    PID_PAGECOUNT:begin
       CopyMemory(@PageCount,Value,SizeOf(PageCount));
       if pagecount=1 then pages := chr(49)+chr(32)+chr(112)+chr(97)+chr(103)+chr(101){'1 page'} else pages := inttostr(pagecount)+chr(32)+chr(112)+chr(97)+chr(103)+chr(101)+chr(115){' pages'};
        if length(comment)=0 then Comment := pages else Comment := Comment+chr(32)+pages;
      end;
    PID_LASTSAVE_DTM:
    begin
      CopyMemory(@FileTime,Value,SizeOf(FileTime));
      date := FileTimeToDateTime(FileTime);
      if date<>0 then year := formatdatetime('mm/dd/yyyy',date);
    end;
  end;
end;

procedure Tthread_share.extract_msword_infos;
var
  awcName: array [0..MAX_PATH-1] of WideChar;
  cbRead: Longint;
  hres:hresult;
  libNewPosition: Largeint;
  Size: Cardinal;

  Buffer: PChar;
  I,I4: Integer;
  dwType: DWORD;
  cb: Longint;
  dlibMove: Largeint;
  FileTime: TFileTime;

    stgOpen: IStorage;
    stm: IStream;
    PropertySetHeader: TPropertySetHeader;
    FormatIDOffset: TFormatIDOffset;
    PropertySectionHeader: TPropertySectionHeader;
    prgPropIDOffset: PPropertyIDOffsetList;
    prgPropertyValue: PSerializedPropertyValueList;
begin
try

//openstorage
 // StringToWideChar(names,awcName,MAX_PATH);
  hRes := StgOpenStorage(pwidechar(fileScan^.fname),               //Points to the pathname of the file containing storage object
                         nil,                   //Points to a previous opening of a root storage object
                         STGM_READ or           //Specifies the access mode for the object
                         STGM_SHARE_EXCLUSIVE,
                         nil,                   //Points to an SNB structure specifying elements to be excluded
                         0,                     //Reserved; must be zero
                         stgOpen	        //Points to location for returning the storage object
                        );

  OleCheck(hRes);

//open stream
  StringToWideChar({#5}chr(5)+chr(83)+chr(117)+chr(109)+chr(109)+chr(97)+chr(114)+chr(121)+chr(73)+chr(110)+chr(102)+chr(111)+chr(114)+chr(109)+chr(97)+chr(116)+chr(105)+chr(111)+chr(110){'SummaryInformation'},awcName,MAX_PATH);
  hRes := stgOpen.OpenStream(awcName,               //Points to name of stream to open
                             nil,                   //Reserved; must be NULL
                             STGM_READ or           //Access mode for the new stream
                             STGM_SHARE_EXCLUSIVE,
                             0, 	              //Reserved; must be zero
                             stm	              //Points to opened stream object
                            );

  OleCheck(hRes);

// ReadPropertySetHeader
    hRes := stm.Read(@PropertySetHeader,        //Pointer to buffer into which the stream is read
                   SizeOf(PropertySetHeader), //Specifies the number of bytes to read
                   @cbRead                    //Pointer to location that contains actual number of bytes read
                  );

    OleCheck(hRes);





// ReadFormatIdOffset;

   hRes := stm.Read(@FormatIDOffset,        //Pointer to buffer into which the stream is read
                   SizeOf(FormatIDOffset), //Specifies the number of bytes to read
                   @cbRead                 //Pointer to location that contains actual number of bytes read
                  );

  OleCheck(hRes);


 // ReadPropertySectionHeader;
   hRes := Stm.Seek(FormatIDOffset.dwOffset, //Offset relative to dwOrigin
                   STREAM_SEEK_SET,         //Specifies the origin for the offset
                   libNewPosition           //Pointer to location containing new seek pointer
                  );

  OleCheck(hRes);

  hRes := stm.Read(@PropertySectionHeader,        //Pointer to buffer into which the stream is read
                   SizeOf(PropertySectionHeader), //Specifies the number of bytes to read
                   @cbRead                        //Pointer to location that contains actual number of bytes read
                  );

  OleCheck(hRes);




//  ReadPropertyIdOffset;
   Size := PropertySectionHeader.cProperties*SizeOf(prgPropIDOffset^);
  GetMem(prgPropIDOffset,Size);
  hRes := stm.Read(prgPropIDOffset, //Pointer to buffer into which the stream is read
                   Size,            //Specifies the number of bytes to read
                   @cbRead          //Pointer to location that contains actual number of bytes read
                  );

  OleCheck(hRes);






 // ReadPropertySet;

 hRes := S_OK;
  Size := PropertySectionHeader.cProperties*SizeOf(prgPropertyValue^);
  for I := 0 to PropertySectionHeader.cProperties-1 do begin
    dlibMove := FormatIDOffset.dwOffset+prgPropIDOffset^[I].dwOffset;
    hRes := Stm.Seek(dlibMove,        //Offset relative to dwOrigin
                     STREAM_SEEK_SET, //Specifies the origin for the offset
                     libNewPosition   //Pointer to location containing new seek pointer
                    );

    OleCheck(hRes);

    hRes := stm.Read(@dwType,        //Pointer to buffer into which the stream is read
                     SizeOf(dwType), //Specifies the number of bytes to read
                     @cbRead         //Pointer to location that contains actual number of bytes read
                    );

    OleCheck(hRes);

    case dwType of
      VT_I4:                   { [V][T][P]  4 byte signed int           }
      begin
        hRes := stm.Read(@I4,        //Pointer to buffer into which the stream is read
                         SizeOf(I4), //Specifies the number of bytes to read
                         @cbRead     //Pointer to location that contains actual number of bytes read
                        );

        OleCheck(hRes);

        AddmswordProperty(prgPropIDOffset^[I].propid,@I4);
      end;
     VT_FILETIME:             {       [P]  FILETIME                    }
      begin
        hRes := stm.Read(@FileTime,        //Pointer to buffer into which the stream is read
                         SizeOf(FileTime), //Specifies the number of bytes to read
                         @cbRead           //Pointer to location that contains actual number of bytes read
                        );

        OleCheck(hRes);

         AddmswordProperty(prgPropIDOffset^[I].propid,@FileTime);
      end;

      VT_LPSTR:                {    [T][P]  null terminated string      }
      begin
        hRes := stm.Read(@cb,        //Pointer to buffer into which the stream is read
                         SizeOf(cb), //Specifies the number of bytes to read
                         @cbRead     //Pointer to location that contains actual number of bytes read
                        );

        OleCheck(hRes);

        GetMem(Buffer,cb*SizeOf(Char));
        try
          hRes := stm.Read(Buffer, //Pointer to buffer into which the stream is read
                           cb,     //Specifies the number of bytes to read
                           @cbRead //Pointer to location that contains actual number of bytes read
                          );

          OleCheck(hRes);

          AddmswordProperty(prgPropIDOffset^[I].propid,Buffer);
        finally
          FreeMem(Buffer);
        end;
      end;

    end;
  end;

except
end;
end;

procedure Tthread_share.parse_iptc(filename: WideString);
  VAR
    code :  BYTE;
    i    :  INTEGER;
    sLength:  INTEGER;
    s: string;
    red,len: Integer;
   stream: Thandlestream;
begin

    stream := MyFileOpen(FileName,ARES_READONLY_BUT_SEQUENTIAL);
    if stream=nil then exit;


     len := stream.size;
     if len>8192 then len := 8192;

    SetLength(s,len);
    red := stream.read(s[1],len);
    if red<len then SetLength(s,red);

    FreeHandleStream(Stream);
try

    IF POS('8BIM'+chr(4)+chr(4), s) = 0 THEN exit;

      if pos('8BIM'+chr(4)+chr($0b)+chr(9)+chr(73)+chr(109)+chr(97)+chr(103)+chr(101)+chr(32)+chr(85)+chr(82)+chr(76){'Image URL'}+CHRNULL+CHRNULL+CHRNULL,s)>0 then begin
       url := copy(s,pos('8BIM'+chr(4)+chr($0b)+chr(9)+chr(73)+chr(109)+chr(97)+chr(103)+chr(101)+chr(32)+chr(85)+chr(82)+chr(76){'Image URL'}+CHRNULL+CHRNULL+CHRNULL,s)+19,length(s));
       if length(url)>1 then begin
        len := ord(url[1]);
        url := copy(url,2,len);
       end;
      end;

      delete(s,1,POS('8BIM'+chr(4)+chr(4), s)+5);
      s := copy(s,1,pos('8BIM',s)-1);

      i := 1;
      WHILE (i+1 < LENGTH(s)) DO BEGIN

        IF ((s[i]=chr($1c)) and (s[i+1]=chr(2))) then begin
          delete(s,1,i+1);
           if length(s)<3 then exit;
          code := ord(s[1]);
          sLength := 256*ord(s[2]) + ord(s[3]);
          delete(s,1,3);
          CASE code OF
           5: Title := copy(s,1,slength);
           15:Category := copy(s,1,slength);
           20:Category := copy(s,1,slength);
           55:year := copy(s,1,slength);
           105: Title := copy(s,1,slength);
           110:artist := copy(s,1,slength);
           115:album := copy(s,1,slength);
           120:comment := copy(s,1,slength);
          end;
          delete(s,1,slength);
          i := 1;
        end else inc(i);
    end;


  except
  end;
end;






























end.
