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
this thread is started by thread download at 100% progress,
its purpose is to calculate an hash value of file and visually add the new entry to library view
}

unit th_rbld;

interface
uses
classes,registry,windows,sysutils,utility_ares,const_ares,tntwindows,
ares_types,ares_objects,umediar,comctrls,comettrees,SecureHash,helper_unicode,
vars_localiz,helper_arescol,activeX,directDraw,Directshow9,dspack,ComObj,graphics,
helper_diskio,helper_urls,helper_strings,helper_mimetypes,vars_global;

type
  tth_rbld = class(TThread)
 private
   param1,param2,param3: Integer;
   pfilez:precord_file_library;
   go_scan: Boolean;
   filenW_mpeg: WideString;
   info_video: TDSMediaInfo;
   DirectDraw: IDirectDraw;
   AMStream: IAMMultiMediaStream;
 protected
  procedure Execute; override;
  procedure add_to_treeviews; //synch
  procedure aggiungi_nodo_library(dopo: string;treeview: Tcomettree; nodo:pCmtVnode); //synch
  procedure aggiungi_nodo_library_folder; //synch
  procedure segnala_fine_treeview_download; //synch
  procedure hashCompute(const FileName: widestring; fsize: Int64; var sha1: string);
  procedure deal_with_new_file; //synch
  procedure get_params_media(ext: string);

  procedure getDDrawVideoInfo;
  procedure initDDraw;
  procedure finalizeDDrawInfo;

  function findNode(nodo_root:pCmtVnode; pathS: string):pCmtVnode;
  procedure shutdown;
 public


   nomefile: string; // read fnomefile write fnomefile;
   title: string; // read ftitle write ftitle;
   artist: string; // read fartist write fartist;
   album: string; // read falbum write falbum;
   category: string; // read fcategory write fcategory;
   comment: string; // read fcomment write fcomment;
   language: string; // read flanguage write flanguage;
   url: string; // read furl write furl;
   keyword_genre: string; // read fkeyword_genre write fkeyword_genre;
   year: string; // read fyear write fyear;
   handle_download: Cardinal; // read fid write fid;
   size: Int64; // read fsize write fsize;
   amime: Integer; // read ftipo write ftipo;
   vidinfo: string;
    crcsha1_paragone: Word; //verifica!
    hash_sha1_paragone: string;
    hash_of_phash_paragone: string;
    in_subfolder: string;
    point_of_phash_db: Cardinal;
  end;

implementation

uses
 ufrmmain,thread_download,thread_share,helper_library_db,
 classes2,helper_share_misc,dhtkeywords,bittorrentUtils,
 helper_fakes;

procedure tth_rbld.execute;
begin
freeonterminate := True;
priority := tpnormal;

  sleep(500);

  go_scan := False;

  if handle_download<>0 then synchronize(segnala_fine_treeview_download);


 /////////////////////////////////////////////////////////
 try
  if go_scan then deal_with_new_file;
 except
 end;

  shutdown;
end;

procedure tth_rbld.shutdown;
begin
nomefile := '';
title := '';
artist := '';
album := '';
category := '';
comment := '';
language := '';
url := '';
keyword_genre := '';
year := '';
vidinfo := '';
hash_sha1_paragone := '';
hash_of_phash_paragone := '';
in_subfolder := '';
end;

procedure tth_rbld.segnala_fine_treeview_download; //synch
var
node:pCmtVnode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
begin
try

node := ares_FrmMain.treeview_download.getfirst;
while (node<>nil) do begin
  dataNode := ares_FrmMain.treeview_download.getdata(node);
  if dataNode^.m_type<>dnt_download then begin
   node := ares_FrmMain.treeview_download.getnextsibling(node);
   continue;
  end;

  DnData := dataNode^.data;
  if DnData^.handle_obj=handle_download then begin
   DnData^.state := dlJustCompleted;
   go_scan := True;
   break;
  end;
  
  node := ares_FrmMain.treeview_download.getnextsibling(node);
end;

except
end;
end;

procedure tth_rbld.get_params_media(ext: string);
var
mp3: TMPEGaudio;
ogg: TOggVorbis;
wma: TWMAfile;
wav: Twavfile;
immagine: Tdcimageinfo;
flac: TFLACFile;
ape: TMonkey;
raudio:^record_audioinfo;
duratawav:variant;
vqf: TTwinVQ;
aac: TAACFile;
mpc: TMPCFile;
begin
try

if ext='.mp3' then begin
     mp3 := TMPEGaudio.create;
     try
     if not mp3.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
     mp3.Free;
     exit;
     end;
     except
     mp3.Free;
     exit;
     end;
     if not mp3.Valid then begin
      mp3.Free;
      exit;
     end;
      param1 := mp3.BitRate;
      param3 := trunc(mp3.Duration);
      param2 := mp3.SampleRate;
      mp3.Free;
end else
if ext='.flv' then begin
  new(raudio);
  try
    raudio^ := get_flv_infos(nomefile);
    param1 := raudio^.bitrate;
    param2 := raudio^.frequency;
    param3 := raudio^.duration;
     vidinfo := 'FLV '+raudio^.codec;
  except
   raudio^.codec := '';
   dispose(raudio);
   exit;
  end;
  raudio^.codec := '';
  dispose(raudio);
end else
if ext='.mpc' then begin
     mpc := TMPCFile.create;
     try
     if not mpc.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
     mpc.Free;
     exit;
     end;
     except
     mpc.Free;
     exit;
     end;
     if not mpc.Valid then begin
      mpc.Free;
      exit;
     end;
      param1 := mpc.BitRate;
      param3 := trunc(mpc.Duration);
      param2 := mpc.SampleRate;
      mpc.Free;
end else
if ((ext='.aac') or (ext='.mp4')) then begin
     aac := TAACFile.create;
     try
     if not aac.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
     aac.Free;
     exit;
     end;
     except
     aac.Free;
     exit;
     end;
     if not aac.Valid then begin
      aac.Free;
      exit;
     end;
      param1 := aac.BitRate;
      param3 := trunc(aac.Duration);
      param2 := aac.SampleRate;
      aac.Free;
end else
if ext='.flac' then begin
   flac := TFLacfile.create;
     try
     if not flac.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
      flac.Free;
      exit;
     end;
     except
      flac.Free;
      exit;
     end;
      if not flac.Valid then begin
       flac.Free;
       exit;
      end;
      param1 := flac.bitrate;
      param2 := flac.SampleRate;
      param3 := trunc(flac.duration);
   flac.Free;
end else
if ext='.vqf' then begin
   vqf := TTwinVQ.create;
     try
     if not vqf.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
      vqf.Free;
      exit;
     end;
     except
      vqf.Free;
      exit;
     end;
      if not vqf.Valid then begin
       vqf.Free;
       exit;
      end;
      param1 := vqf.BitRate;
      param3 := trunc(vqf.Duration);
      param2 := vqf.SampleRate;
   vqf.Free;
end else
if ext='.ape' then begin
   ape := TMonkey.create;
     try
     if not ape.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
      ape.Free;
      exit;
     end;
     except
      ape.Free;
      exit;
     end;
      if not ape.Valid then begin
       ape.Free;
       exit;
      end;
 param1 := ape.bitrate;
 param2 := ape.samplerate;
 param3 := trunc(ape.duration);
   ape.Free;
end else
if ext='.ogg' then begin
  ogg := TOggVorbis.create;
   try
  if not ogg.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
  ogg.Free;
  exit;
  end;
 except
 ogg.Free;
  exit;
 end;
 if not ogg.Valid then begin
  ogg.Free;
  exit;
 end;
 param1 := ogg.BitRateNominal;
 param2 := ogg.SampleRate;
 param3 := trunc(ogg.duration);
 ogg.free
end else
if ext='.wma' then begin
  wma := TWMAfile.create;
   try
  if not wma.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
  wma.Free;
  exit;
  end;
 except
 wma.Free;
  exit;
 end;
 if not wma.Valid then begin
 wma.Free;
 exit;
 end;
 param1 := wma.BitRate;
 param2 := wma.SampleRate;
 param3 := trunc(wma.duration);
 wma.Free;
end else

if ext='.wav' then begin
   wav := twavfile.create;
  try
   if not wav.ReadFromFile(utf8strtowidestr(copy(nomefile,1,length(nomefile)))) then begin
   wav.Free;
   exit;
   end;
   except
   wav.Free;
   exit;
   end;
   if not wav.Valid then begin
   wav.Free;
   exit;
   end;
   param1 := wav.BitsPerSample;
   param2 := wav.SampleRate;
   duratawav := wav.duration;
   param3 := duratawav;
   wav.Free;
end else
if ((ext='.bmp') or
    (ext='.jpg') or
    (ext='.gif') or
    (ext='.png') or
    (ext='.pcx') or
    (ext='.tiff') or
    (ext='.jpeg')) then begin
   immagine := tdcimageinfo.create;
      try
   immagine.ReadFile(utf8strtowidestr(copy(nomefile,1,length(nomefile))));
   param1 := immagine.Width;
   param2 := immagine.height;
   param3 := immagine.Depth;   // other
   except
   immagine.Free;
   exit;
   end;
   immagine.Free;
end else
if ext='.psd' then begin
  new(raudio);
  try
  raudio^ := ricava_dati_psd(utf8strtowidestr(copy(nomefile,1,length(nomefile))));
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;   // other
  except
  dispose(raudio);
  exit;
  end;
end else
  if ext='.psp' then begin
  new(raudio);
  try
  raudio^ := ricava_dati_psp(utf8strtowidestr(copy(nomefile,1,length(nomefile))));
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;   // other
  except
  dispose(raudio);
  exit;
  end;
end else
if ext='.mov' then begin
  new(raudio);
  try
  raudio^ := ricava_dati_mov(utf8strtowidestr(copy(nomefile,1,length(nomefile))));
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;   // other
  if param1=0 then begin
   param1 := 0;
   param2 := 0;
   param3 := 0;
  end;
  vidinfo := 'QTime';
  except
   param1 := 0;
   param2 := 0;
   param3 := 0;
  end;
    dispose(raudio);
end else
if ext='.avi' then begin
   new(raudio);
 try
  raudio^ := ricava_dati_avi(utf8strtowidestr(copy(nomefile,1,length(nomefile))));
  param1 := raudio^.bitrate;
  param2 := raudio^.frequency;
  param3 := raudio^.duration;   // other
  vidinfo := 'AVI '+uppercase(raudio^.codec);
      if param1=0 then begin
         vidinfo := 'AVI';
         getDDrawVideoInfo;
      end;
  except
   vidinfo := 'AVI';
   getDDrawVideoInfo;
  end;
  if ((param1=0) or (param2=0) or (param3=0)) then begin
       param1 := 0;
       param2 := 0;
       param3 := 0;
  end;
  raudio^.codec := '';
  dispose(raudio);
end else
  if ((ext='.mpe') or
      (ext='.mpg') or
      (ext='.wmv') or
      (ext='.mpeg')) then begin
      getDDrawVideoInfo;
    vidinfo := 'MPEG';
end;

except
end;
end;

procedure tth_rbld.initDDraw;
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

procedure tth_rbld.getDDrawVideoInfo;
begin
 try
filenW_mpeg := utf8strtowidestr(copy(nomefile,1,length(nomefile)));

activeX.coInitialize(nil);
initDDraw;
info_video.FileSize := GetHugeFileSize(filenW_mpeg);

 OleCheck(AMStream.OpenFile(PWideChar(filenW_mpeg), AMMSF_NOCLOCK));

finalizeDDrawInfo;


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
end;

procedure tth_rbld.finalizeDDrawInfo;
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

procedure tth_rbld.deal_with_new_file;
var
ext,hash_sha1: string;
crcsha1: Word;
begin
try
  ext := lowercase(extractfileext(nomefile));
  if ext='.wmv' then begin
   if is_trojan_wmv(utf8strtowidestr(nomefile), size) then exit;
  end;

  vidinfo := '';
  param1 := 0;
  param2 := 0;
  param3 := 0;

  try
   get_params_media(ext);
  except
  end;

   if ((amime=ARES_MIME_VIDEO) and (((param1>4000) or (param2>4000)))) then begin
    param1 := 0;
    param2 := 0;
    param3 := 0;
   end;


 hashCompute(utf8strtowidestr(nomefile),size,hash_sha1);
 if length(hash_sha1)<>20 then exit;

 if ext='.arescol' then arescol_get_meta(utf8strtowidestr(nomefile),title,comment,url,amime) else //handle special metas...
 if (ext='.mp3') or (ext='.avi') then begin
  if helper_fakes.isFakeFile(nomefile) then begin
   helper_diskio.deletefileW(nomefile);
   exit;
  end;
 end;

 crcsha1 := crcstring(hash_sha1);

 pfilez := AllocMem(sizeof(record_file_library));
  pfilez^.hash_of_phash := copy(hash_of_phash_paragone,1,length(hash_of_phash_paragone));
  pfilez^.hash_sha1 := copy(hash_sha1,1,length(hash_sha1));
  pfilez^.crcsha1 := crcsha1;
  pfilez^.path := copy(nomefile,1,length(nomefile));
  pfilez^.ext := copy(ext,1,length(ext));
  pfilez^.amime := amime;
  pfilez^.corrupt := False;

  pfilez^.title := copy(title,1,length(title));
  pfilez^.artist := copy(artist,1,length(artist));
  pfilez^.album := copy(album,1,length(album));
  pfilez^.category := copy(category,1,length(category));
  pfilez^.year := copy(year,1,length(year));
  pfilez^.language := copy(language,1,length(language));
  pfilez^.comment := copy(comment,1,length(comment));
  pfilez^.url := copy(url,1,length(url));
  pfilez^.keywords_genre := copy(keyword_genre,1,length(keyword_genre));
  pfilez^.fsize := size;
  pfilez^.param1 := param1;
  pfilez^.param2 := param2;
  pfilez^.param3 := param3;
  pfilez^.filedate := now;
  pfilez^.vidinfo := vidinfo;
  pfilez^.mediatype := mediatype_to_str(amime);
  pfilez^.shared := True;
  pfilez^.write_to_disk := True;
  pfilez^.phash_index := point_of_phash_db; //2956+

 if length(hash_sha1_paragone)=20 then begin
   if crcsha1_paragone<>0 then begin
     if hash_sha1_paragone<>hash_sha1 then begin
         pfilez^.corrupt := True;
         pfilez^.shared := False;
     end else begin
        if ext='.arescol' then arescol_parse_file(utf8strtowidestr(nomefile)) else
        if ext='.torrent' then bittorrentUtils.loadTorrent(utf8strtowidestr(nomefile));
     end;
   end;
 end;

 dhtkeywords.DHT_addFileOntheFly(pfilez,false);

synchronize(add_to_treeviews);

except
end;
end;



procedure tth_rbld.add_to_treeviews; //synch
var
 nodoroot,nodoall,nodoaudio,nodoimmagini,nodovideo,
 nododocumenti,nodosoftware,nodoother,nodorecent,nodosel,
 nodo1,nodo2,nodo3:pCmtVnode;
 data:ares_types.precord_string;
begin
  //add to form
vars_global.lista_shared.add(pfilez);
 if not pfilez.corrupt then begin
  inc(vars_global.my_shared_count);
  helper_share_misc.addfile_tofresh_downloads(pfilez);
 end;
 helper_library_db.set_newtrusted_metas; //write to db aswell


try

aggiungi_nodo_library_folder;


with ares_frmmain do begin
 with treeview_lib_virfolders do begin
nodoroot := GetFirst;

nodoall := Getfirstchild(nodoroot);
 data := getdata(nodoall);
 inc(data^.counter);
 invalidatenode(nodoall);


nodoaudio := getnextsibling(nodoall);
nodoimmagini := getnextsibling(nodoaudio);
nodovideo := getnextsibling(nodoimmagini);
nododocumenti := getnextsibling(nodovideo);
nodosoftware := getnextsibling(nododocumenti);
nodoother := getnextsibling(nodosoftware);

  nodorecent := getnextsibling(nodoother);
   data := getdata(nodorecent);
   inc(data^.counter);
   invalidatenode(nodorecent);

if ((amime=ARES_MIME_MP3) or (amime=ARES_MIME_AUDIOOTHER1) or (amime=ARES_MIME_AUDIOOTHER2)) then data := getdata(nodoaudio) else
if amime=ARES_MIME_IMAGE then data := getdata(nodoimmagini) else
if amime=ARES_MIME_VIDEO then data := getdata(nodovideo) else
if amime=ARES_MIME_DOCUMENT then data := getdata(nododocumenti) else
if amime=ARES_MIME_SOFTWARE then data := getdata(nodosoftware) else begin
 data := getdata(nodoother);
 inc(data^.counter);
  if ares_frmmain.tabs_pageview.activepage<>IDTAB_LIBRARY then exit;
  if btn_lib_virtual_view.down then begin
    nodosel := getfirstselected;
    if nodosel<>nil then ufrmmain.ares_FrmMain.treeview_lib_virfoldersclick(nil);
  end else begin
    nodosel := getfirstselected;
    if nodosel<>nil then ufrmmain.ares_FrmMain.treeview_lib_regfoldersclick(nil);
  end;
 exit;
end;

inc(data^.counter); //aumentiamo numero in mime

case amime of
ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
 nodo1 := getfirstchild(nodoaudio);  //by artist
 nodo2 := getnextsibling(nodo1);    //by album
 nodo3 := getnextsibling(nodo2);    //by category
 aggiungi_nodo_library(artist,treeview_lib_virfolders,nodo1);
 aggiungi_nodo_library(album,treeview_lib_virfolders,nodo2);
 aggiungi_nodo_library(category,treeview_lib_virfolders,nodo3);
  sort(nodo1,0,sdascending);
  sort(nodo2,0,sdascending);
  sort(nodo3,0,sdascending);
end;
ARES_MIME_SOFTWARE:begin   //software
 nodo1 := getfirstchild(nodosoftware);
 nodo2 := getnextsibling(nodo1);
 aggiungi_nodo_library(artist,treeview_lib_virfolders,nodo1);
 aggiungi_nodo_library(category,treeview_lib_virfolders,nodo2);
   sort(nodo1,0,sdascending);
   sort(nodo2,0,sdascending);
end;
ARES_MIME_VIDEO:begin    //video
 nodo1 := getfirstchild(nodovideo);
 aggiungi_nodo_library(category,treeview_lib_virfolders,nodo1);
   sort(nodo1,0,sdascending);
end;
ARES_MIME_DOCUMENT:begin
 nodo1 := getfirstchild(nododocumenti);
 nodo2 := getnextsibling(nodo1);
 aggiungi_nodo_library(artist,treeview_lib_virfolders,nodo1);
 aggiungi_nodo_library(category,treeview_lib_virfolders,nodo2);
   sort(nodo1,0,sdascending);
   sort(nodo2,0,sdascending);
end;
ARES_MIME_IMAGE:begin
 nodo1 := getfirstchild(nodoimmagini);
 nodo2 := getnextsibling(nodo1);
 aggiungi_nodo_library(album,treeview_lib_virfolders,nodo1);
 aggiungi_nodo_library(category,treeview_lib_virfolders,nodo2);
   sort(nodo1,0,sdascending);
   sort(nodo2,0,sdascending);
end;
end;

if ares_frmmain.tabs_pageview.activepage<>IDTAB_LIBRARY then exit;

  if btn_lib_virtual_view.down then begin
    nodosel := getfirstselected;
    if nodosel<>nil then ufrmmain.ares_FrmMain.treeview_lib_virfoldersclick(nil);
  end else begin
    nodosel := getfirstselected;
    if nodosel<>nil then ufrmmain.ares_FrmMain.treeview_lib_regfoldersclick(nil);
  end;

end;
end;

except
end;
end;

function tth_rbld.FindNode(nodo_root:pCmtVnode; pathS: string):pCmtVnode;
var
i: Integer;
cartella:precord_cartella_share;
begin
result := nil;

with ares_frmmain.treeview_lib_regfolders do begin

i := 0;
repeat
if i=0 then Result := getfirstchild(nodo_root)
 else Result := getnext(result);
 if result=nil then exit;
 inc(i);

 cartella := getdata(result);
   if lowercase(widestrtoutf8str(cartella^.path))=pathS then exit;

until (not true);
end;

end;

procedure tth_rbld.aggiungi_nodo_library_folder; //synch
var
i: Integer;
data_sharedfolder:ares_types.precord_cartella_share;
destination_path,actual_path: WideString;
nodo_sharedfolder,nodo_root:pCmtVnode;
begin

if in_subfolder<>'' then destination_path := vars_global.myshared_folder+utf8strtowidestr(in_subfolder)+'\'
 else destination_path := vars_global.myshared_folder+'\';
 
nodo_root := ares_FrmMain.treeview_lib_regfolders.getfirst;
if nodo_root=nil then exit;


i := length(vars_global.myshared_folder);
repeat
 inc(i);
 if i>1000 then exit;
 
 if vars_global.myshared_folder+'\'=destination_path then actual_path := vars_global.myshared_folder else begin
    if destination_path[i]='\' then actual_path := copy(destination_path,1,i-1)
     else continue;
 end;

 nodo_sharedfolder := FindNode(nodo_root,lowercase(widestrtoutf8str(actual_path)));
  if nodo_sharedfolder=nil then begin
   nodo_sharedfolder := ares_FrmMain.treeview_lib_regfolders.addchild(nodo_root);
    data_sharedfolder := ares_FrmMain.treeview_lib_regfolders.getdata(nodo_sharedfolder);
    with data_sharedfolder^ do begin
     path := actual_path;
     items := 0;
     items_shared := 0;
     display_path := widestrtoutf8str(extract_fnameW(actual_path));
     id := random(40000)+500;
    end;
  end;

   if actual_path+'\'=destination_path then begin
    data_sharedfolder := ares_FrmMain.treeview_lib_regfolders.getdata(nodo_sharedfolder);
        if not pfilez.corrupt then inc(data_sharedfolder^.items_shared);
        pfilez^.folder_id := data_sharedfolder^.id;
        inc(data_sharedfolder^.items);
          if ares_frmmain.tabs_pageview.activepage=IDTAB_LIBRARY then
           if ares_FrmMain.btn_lib_regular_view.down then ares_FrmMain.treeview_lib_regfolders.invalidatenode(nodo_sharedfolder);
         exit;
   end;
   
   nodo_root := nodo_sharedfolder;

 if i>1000 then exit;
until (not true);




end;


procedure tth_rbld.aggiungi_nodo_library(dopo: string; treeview: Tcomettree; nodo:pCmtVnode); //synch
var
nd:pCmtVnode;
data_virtual:ares_types.precord_string;
need_create: Boolean;
lodopo: string;
begin

need_create := True;
if dopo='' then dopo := GetLangStringA(STR_UNKNOWN);
 lodopo := lowercase(dopo);

 nd := treeview.getfirstchild(nodo);
while (nd<>nil) do begin

 data_virtual := treeview.getdata(nd);
 if lowercase(data_virtual^.str)=lodopo then begin
  need_create := False;
  inc(data_virtual^.counter);
  treeview.invalidatenode(nd);
  break;
 end;

 nd := treeview.getnextsibling(nd);
end;

if need_create then begin
 nd := treeview.addchild(nodo);
  data_virtual := treeview.getdata(nd);
  data_virtual^.str := dopo;
  data_virtual^.counter := 1;
end;

end;



procedure tth_rbld.hashCompute(const FileName: widestring; fsize: Int64; var sha1: string);
var
  stream: Thandlestream;
  csha1: Tsha1;
  NumBytes: Integer;
  buffer: array [1..1024] of char;
begin
  sha1 := '';

  if fsize>100*MEGABYTE then priority := tpidle;

     stream := MyFileOpen(FileName,ARES_READONLY_BUT_SEQUENTIAL);
     if stream=nil then exit;

   cSHA1 := TSHA1.Create;

  repeat

   sleep(0);

        NumBytes := stream.read(Buffer, SizeOf(Buffer));

        cSHA1.Transform(Buffer, NumBytes);

  until (numbytes<>sizeof(buffer));

   FreeHandleStream(Stream);

  cSHA1.Complete;
   sha1 := cSHA1.HashValue;
  cSHA1.Free;

 priority := tpnormal;
end;



end.
