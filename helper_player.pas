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
player (direct show) high level funcs
}

unit helper_player;

interface

uses
 classes,ActiveX,DSPack,directdraw,directshow9,windows,forms,sysutils,tntwindows,
 registry,math,DSUtil,AsyncExTypes,mmsystem,uflvplayer,unetplayer;

const
PLAYABLE_AUDIO_EXT    = '.mp3 .wav .qt .aif .aifc .aiff .wax .vod .au .mp2 .snd .cda .mid .midi .mpa .aac, .m4a, .f4a'; //.wma
PLAYABLE_VIDEO_EXT    = '.avi .mpeg .asf .mpa .mpg .mpe .wmv .wvx .wmx .m1v .flv .mp4 .f4v .mov';
PLAYABLE_IMAGE_EXT    = '.jpg .bmp .gif';
PLAYABLE_ASYNCEX      = '.mp3 .wav .aiff .au';

function runmedia: Boolean;
procedure stopmedia(sender: Tobject);
procedure pausemedia;

procedure player_deleteformer_preview;
procedure player_get_volumesettings;
procedure player_playnew(nome: WideString; isPreview:boolean=false);
procedure player_togglefullscreen(goFullscreen:boolean);
procedure resize_video_window; overload;
procedure resize_video_window( BasicVideo : IBasicVideo; VideoWindow:IVideoWindow); overload;
procedure switch_pause_media;
procedure player_NillAll;
procedure player_SetVolume(Volume: Integer);
function player_openStream(fname: WideString; ext: string; isPreview:boolean=false):HResult;
function player_GetState: TGraphState;
procedure player_setTrackbar(CalcDuration:boolean=true; filename: WideString=''; ext: string='');
procedure player_PutFullScreen(isFullScreen:boolean);
procedure player_resettrackbar;
procedure player_step_backward;
procedure player_step_forward;
function IsMediaMp3(const Filename: wideString; var isAudio:boolean): boolean;
procedure SetWavOutVolume(volume:integer);

const
 AsyncExPinID = 'StreamOut';

var
    player_actualfile: WideString;
    player_working: Boolean;

    m_GraphBuilder: IGraphBuilder;
    m_MediaControl: IMediaControl;
    m_FileSource: IFilesourcefilter;
    m_AsyncExControl: IAsyncExControl;
    m_AsyncEx: IBaseFilter;
    m_Mpeg1Splitter: IBaseFilter;
    m_Mp3Dec: IBaseFilter;

    m_Pin: IPin;

    player_is_playing_image: Boolean;
    FFullScreenWindow: TForm;

const
  CLSID_Mpeg1Split: TGUID = '{336475D0-942A-11CE-A870-00AA002FEAB5}';
  CLSID_Mp3Dec: TGUID = '{422A3AF6-0B1D-42CB-AAF9-7DFD8EB2FCEF}'; //'{4A2286E0-7BEF-11CE-9BD9-0000E202599C}'; //'{38BE3000-DBF4-11D0-860E-00A024CFEF6D}';

implementation

uses
 ufrmmain,vars_global,helper_datetime,helper_diskio,helper_gui_misc,
 helper_unicode,const_ares,helper_playlist,helper_strings,
 helper_urls,shoutcast,umediar,uWhatImListeningTo,utility_ares;

function IsMediaMp3(const Filename: wideString; var isAudio:boolean): boolean;
var
  MediaDet: IMediaDet;
  mediatype:_AMMediaType;
  hr:HResult;
  i: Integer;
  str,outstr: string;
begin
  Result := False;
  isAudio := False;

  if length(filename)=0 then exit;
  
  if CoCreateInstance(CLSID_MediaDet, nil, CLSCTX_INPROC_SERVER,IID_IMediaDet, MediaDet)<>S_OK then exit;

  if MediaDet.put_Filename(Filename)<>S_OK then begin
   mediaDet := nil;
   exit;
  end;

  hr := MediaDet.get_StreamMediaType(mediatype);
  if hr<>S_OK then begin
   mediaDet := nil;
   exit;
  end;

  if not isEqualGuid(mediatype.majortype,MEDIATYPE_Audio) then begin
   mediaDet := nil;
   exit;
  end;

  isAudio := True;

  SetLength(str,16);
  outstr := '';
  move(mediatype.subtype,str[1],16);
  for i := 1 to 16 do outstr := outstr+inttoHex(ord(str[i]),2);
  if isEqualGuid(mediatype.subtype,MEDIASUBTYPE_MPEG1AudioPayload) then Result := True;
   //   if MediaDet.put_CurrentStream(0)=S_OK then
    //    if MediaDet.get_StreamLength(Result) <> S_OK then
    //      Result := 0;
  MediaDet := nil;
end;

procedure switch_pause_media;
begin
if m_GraphBuilder<>nil then
 if ((isvideoplaying) and (Player_GetState=gsPlaying)) then
  ufrmmain.ares_frmmain.btn_player_pauseclick(nil);
end;



procedure resize_video_window;
var
 BasicVideo : IBasicVideo;
 VideoWindow:IVideoWindow;
begin
if unetPlayer.NETPlayer<>nil then begin
 ufrmmain.ares_frmmain.resizeNETPlayer;
 //unetPlayer.NETPlayer.left := (ares_frmmain.panel_vid.width div 2)-(unetPlayer.NETPlayer.width div 2);
 //unetPlayer.NETPlayer.top := (ares_frmmain.panel_vid.height div 2)-(unetPlayer.NETPlayer.height div 2);
 exit;
end else
if uflvplayer.flvplayer<>nil then begin
 ufrmmain.ares_frmmain.resizeFLVPlayer;
// uflvplayer.flvplayer.left := (ares_frmmain.panel_vid.width div 2)-(uflvplayer.flvplayer.width div 2);
// uflvplayer.flvplayer.top := (ares_frmmain.panel_vid.height div 2)-(uflvplayer.flvplayer.height div 2);
 exit;
end;
// uflvplayer.flvplayer.left := (ares_frmmain.panel_vid.width div 2)-(uflvplayer.flvplayer.width div 2);
// uflvplayer.flvplayer.top := (ares_frmmain.panel_vid.height div 2)-(uflvplayer.flvplayer.height div 2);


if m_GraphBuilder=nil then exit;
if not isvideoplaying then exit;
if ares_frmmain.fullscreen2.checked then exit;

try
If m_GraphBuilder.QueryInterface(IBasicVideo, BasicVideo)<>S_OK then exit;
if m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow)<>S_OK then exit;

resize_video_window(basicVideo,videowindow);

except
end;
end;

procedure resize_video_window( BasicVideo : IBasicVideo; VideoWindow:IVideoWindow);
var
x,y: Integer;
nuovowidth,nuovoheight: Integer;
begin
 try
 
        BasicVideo.get_VideoWidth(x);
        BasicVideo.get_VideoHeight(y);
       //fit to screen non actual size
if not ares_frmmain.fittoscreen1.checked then begin // ok size originale, con restrizioni?

    { if ((sizexvideo<>0) and (not ares_frmmain.originalsize1.checked)) then begin
      VideoWindow.get_Width(xn);
      nuovowidth := xn;
      nuovoheight := (y*xn) div x;
               //(sizexvideo*40);
          x := nuovowidth;
          y := nuovoheight;
     end else }
     
     BasicVideo.GetVideoSize(x,y);
     

       if y>ares_frmmain.panel_vid.clientheight+5 then begin
           nuovoheight := ares_frmmain.panel_vid.clientheight;
           nuovowidth := (x*nuovoheight) div y;
           x := nuovowidth;
           y := nuovoheight;
       end else
       if x>ares_frmmain.panel_vid.clientwidth+5 then begin
            nuovowidth := ares_frmmain.panel_vid.clientwidth;
            nuovoheight := (y*nuovowidth) div x;
            x := nuovowidth;
            y := nuovoheight;
       end;
                 basicvideo.put_destinationtop(0);
                 basicvideo.put_destinationleft(0);
                 basicvideo.put_destinationwidth(x);
                 BasicVideo.put_Destinationheight(y);


            videowindow.SetWindowPosition((ares_frmmain.panel_vid.clientwidth div 2) - (x div 2),
                                          (ares_frmmain.panel_vid.clientheight div 2) - (y div 2),
                                          x,
                                          y);


end else begin

         if x>y then begin
          nuovoheight := (y*ares_frmmain.panel_vid.clientwidth) div x;
          nuovowidth := ares_frmmain.panel_vid.clientwidth;
          x := nuovowidth;
          y := nuovoheight;
         end else begin
          nuovoheight := ares_frmmain.panel_vid.clientheight;
          nuovowidth := (x*ares_frmmain.panel_vid.clientheight) div y;
          x := nuovowidth;
          y := nuovoheight;
        end;

       if y>ares_frmmain.panel_vid.clientheight+5 then begin
         nuovoheight := ares_frmmain.panel_vid.clientheight;
         nuovowidth := (x*nuovoheight) div y;
       end else
       if x>ares_frmmain.panel_vid.clientwidth+5 then begin
            nuovowidth := ares_frmmain.panel_vid.clientwidth;
            nuovoheight := (y*nuovowidth) div x;
       end;

                  basicvideo.put_destinationtop(0);
                  basicvideo.put_destinationleft(0);
                  BasicVideo.put_Destinationheight(nuovoheight);
                  basicvideo.put_destinationwidth(nuovowidth);



            videowindow.SetWindowPosition((ares_frmmain.panel_vid.clientwidth div 2) - (nuovowidth div 2),
                                          (ares_frmmain.panel_vid.clientheight div 2) - (nuovoheight div 2),
                                           nuovowidth,
                                           nuovoheight);

end;

except
end;
end;


procedure stopmedia(sender: Tobject);
var
 hr:HRESULT;
 wasPlayingShoutcast: Boolean;
begin
try
if unetplayer.NETPlayer<>nil then begin
 unetplayer.freePlayer(sender);
 exit;
end else
if uflvplayer.flvplayer<>nil then begin
 //uflvPlayer.FLVPlayer.stop;
 uflvplayer.freePlayer(sender);
 exit;
end;

if m_graphBuilder=nil then exit;

if FFullScreenWindow<>nil then player_putfullscreen(false);

if m_mediaControl=nil then begin
 if not FAILED(m_GraphBuilder.QueryInterface(IID_IMediaControl, m_MediaControl)) then begin
  hr := m_MediaControl.Stop;
 end;
end else hr := m_MediaControl.Stop;

///// this closes file handles in case file has to be deleted
wasPlayingShoutcast := (isPlayingShoutcast) and (sender<>nil);

player_NillAll;

if wasPlayingShoutcast then begin
 ares_frmmain.mplayerpanel1.wCaption := '';
 ares_frmmain.mplayerpanel1.url := '';
 ares_frmmain.mplayerpanel1.urlCaption := '';
 ares_frmmain.mplayerpanel1.TimeCaption := '';
end;
////////////////////////////////////////////////////////////////

if imgscnlogo<>nil then imgscnlogo.visible := True;
except
end;

   ares_frmmain.trackbar_player.position := 0;

   if sender<>nil then stopped_by_user := True;
end;

procedure player_togglefullscreen(goFullscreen:boolean);
var
x,y: Integer;
nuovoheight: Int64;
nuovowidth: Int64;
scw,sch: Integer;
BasicVideo:IBasicVideo;
 VideoWindow:IVideoWindow;
begin
try
if m_GraphBuilder=nil then exit;

if goFullscreen then begin

  scw := screen.width;
  sch := screen.height;

  If m_GraphBuilder.QueryInterface(IBasicVideo, BasicVideo)<>S_OK then exit;
  If m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow)<>S_OK then exit;

        BasicVideo.Get_videoheight(y);
        BasicVideo.Get_videowidth(x);


 player_PutFullScreen(true);

if x>y then begin
 nuovoheight := (y*scw) div x;
 nuovowidth := scw;
  with basicvideo do begin
   put_destinationtop((sch div 2) - (nuovoheight div 2));
   put_destinationleft((scw div 2) - (nuovowidth div 2));
   put_Destinationheight(nuovoheight);
   put_destinationwidth(nuovowidth);
  end;
end else
if x<y then begin
 nuovoheight := sch;
 nuovowidth := (x*sch) div y;
  with basicVideo do begin
   put_destinationtop((sch div 2) - (nuovoheight div 2));
   put_destinationleft((scw div 2) - (nuovowidth div 2));
   put_Destinationheight(nuovoheight);
   put_destinationwidth(nuovowidth);
  end;
end;

end else begin

  //If m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow)<>S_OK then exit;
   //videowindow.put_FullScreenMode(false);
   player_PutFullScreen(false);
   ufrmmain.ares_frmmain.panel_vidresize(nil);

end;


except
end;

end;

function runmedia: Boolean;
var
hr:HResult;
begin
result := False;
if m_GraphBuilder=nil then exit;
stopped_by_user := False;

if m_mediaControl=nil then begin
 if not FAILED(m_GraphBuilder.QueryInterface(IID_IMediaControl, m_MediaControl)) then begin
  hr := m_MediaControl.Run;
 end;
end else hr := m_MediaControl.Run;
//ares_frmmain.filtro.play;

result := (player_getstate=gsPlaying);
ares_frmmain.MPlayerPanel1.Playing := True;
end;

procedure player_NillAll;

begin
  // required before destroying filter and interface (important!)

  ares_frmmain.MPlayerPanel1.Playing := False;

  try
  if Assigned(m_MediaControl) then m_MediaControl.Stop; // Cleanup Filter and it's interfaces

  if Assigned(m_AsyncEx) then m_AsyncEx := nil;
  
  if Assigned(helper_player.m_AsyncExControl) then begin
    helper_player.m_AsyncExControl.FreeCallback;
    helper_player.m_AsyncExControl := nil;
  end;

  if Assigned(m_Pin) then m_Pin := nil;
  if Assigned(m_FileSource) then m_FileSource := nil;
  if Assigned(m_MediaControl) then m_MediaControl := nil;
  if Assigned(m_Mp3Dec) then m_Mp3Dec := nil;
  if Assigned(m_Mpeg1Splitter) then m_Mpeg1Splitter := nil;
  if Assigned(m_GraphBuilder) then m_GraphBuilder := nil;

 except
 end;
 m_GraphBuilder := nil;

 if FLVPlayer<>nil then FreeAndNil(FLVPlayer);

 shoutcast.Shoutcast_NillVars;
 uWhatImListeningTo.UpdateWhatImListeningTo('','','',false);
 ares_frmmain.trackbar_player.TrackbarEnabled := False;
 utility_ares.waitProcessing(50);
end;

procedure player_playnew(nome: WideString; isPreview:boolean=false);
var
oldfilename: WideString;
hr:hresult;
estensione,nomeutf8: string;
Videowindow : IVideoWindow;
FWindowStyle, FWindowStyleEx: LongWord;
begin
if uflvplayer.flvplayer<>nil then begin
 //uflvplayer.FLVPlayer.Stop;
 FreeAndNil(uflvplayer.FLVPlayer);
end else
if unetPlayer.NETPlayer<>nil then begin

 FreeAndNil(unetPlayer.NETPlayer);

end else
if helper_player.m_GraphBuilder<>nil then begin
 player_NillAll;
end;

// don't bother...for some reason the file doesn't exists

 if lowercase(copy(nome,1,4))='rtmp' then begin
  unetPlayer.init_net_player(nome);
  exit;
 end else
 if lowercase(copy(nome,1,4))='http' then begin
  unetPlayer.init_net_player(nome);
  exit;
 end;

if not fileexistsW(nome) then begin
 exit;
end;

nomeutf8 := widestrtoutf8str(nome);
estensione := lowercase(extractfileext(nomeutf8));
if length(estensione)<2 then exit;

    if ((pos(estensione,PLAYABLE_AUDIO_EXT)=0) and
        (pos(estensione,PLAYABLE_VIDEO_EXT)=0) and
        (pos(estensione,PLAYABLE_IMAGE_EXT)=0)) then begin
     Tnt_ShellExecuteW(ares_frmmain.handle,'open',pwidechar(nome),'','',SW_SHOWNORMAL);
     exit;
    end;

  ares_frmmain.mplayerpanel1.wcaption := '';
  ares_frmmain.mplayerpanel1.TimeCaption := '';
  ares_frmmain.mplayerpanel1.urlCaption := '';
  ares_frmmain.mplayerpanel1.url := '';

// finished preview mode, we can move to next file in playlist when
// we'll reach the end of the file we're about to play
if nome<>file_visione_da_copiatore then file_visione_da_copiatore := '';

 oldfilename := player_actualfile;

    if not player_working then begin
      Tnt_ShellExecuteW(ares_frmmain.handle,'open',pwidechar(nome),'','',SW_SHOWNORMAL);
      exit;
    end;

  //  ares_frmmain.Filtro.Active := False;  //chidiamo vecchio filtro

if ((pos(estensione,PLAYABLE_VIDEO_EXT)<>0) or
    (pos(estensione,PLAYABLE_IMAGE_EXT)<>0)) then begin //si tratta di un video / image

      if (estensione='.flv') or
          (estensione='.mp4') or
          (estensione='.f4v') or
          (estensione='.mov') then begin
           if not isPreview then begin
            uflvplayer.init_flv_player(nome);
            exit;
           end;
       end;


       lockwindowUpdate(ares_frmmain.handle);

        hr := player_openStream(nome,estensione,isPreview);
        if Failed(hr) then begin
         lockwindowUpdate(0);
         vars_global.caption_player := 'Media Error: '+DSUtil.GetErrorString(hr);
         ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
         player_deleteformer_preview;
         exit;
        end;

       if m_GraphBuilder.QueryInterface(IVideoWindow,VideoWindow)=S_OK then begin
         videowindow.put_AutoShow(true);
         videowindow.put_Caption(nome);
         FWindowStyle := GetWindowLong(ares_frmmain.panel_vid.Handle, GWL_STYLE);
         FWindowStyleEx := GetWindowLong(ares_frmmain.panel_vid.Handle,GWL_EXSTYLE);
         videowindow.put_owner(ares_frmmain.panel_vid.handle);
         videowindow.put_WindowStyle(FWindowStyle or WS_CHILD or WS_CLIPSIBLINGS);
         videowindow.put_WindowStyleEx(FWindowStyleEx);
         videowindow.SetWindowPosition(0,0,ares_frmmain.panel_vid.Width,ares_frmmain.panel_vid.Height);
         VideoWindow.put_MessageDrain(ares_frmmain.panel_vid.handle);

         isvideoplaying := True;
         resize_video_window;

         lockwindowUpdate(0);

       end else lockwindowUpdate(0);


           if imgscnlogo<>nil then imgscnlogo.visible := False;

           player_get_volumesettings;
           player_actualfile := nome;


           caption_player := get_player_displayname(nome,estensione);
           ares_frmmain.mplayerpanel1.wcaption := caption_player;

           player_resetTrackbar;
           player_setTrackbar;


          if player_is_playing_image then begin
            ares_frmmain.trackbar_player.TrackbarEnabled := False;
            stopped_by_user := False;

            runMedia;
            pauseMedia;

            stopped_by_user := False;
            caption_player := get_player_displayname(nome,estensione);
            ares_frmmain.mplayerpanel1.wcaption := caption_player;
          end
           else runmedia;

           // If m_GraphBuilder.QueryInterface(IBasicVideo, BasicVideo)=S_OK then begin
             ares_frmmain.tabs_pageview.activePage := IDTAB_SCREEN;
            // helper_gui_misc.mainGui_showscreen;

           //  resize_video_window(basicVideo,videowindow);
           // ufrmmain.ares_frmmain.clientPanelResize(ares_frmmain.clientPanel);

           // ares_frmmain.panel_vid.visible := True;

          //  end;
            //ufrmmain.ares_frmmain.panel_vidresize(ares_frmmain.panel_vid);


end else begin//audio

       isvideoplaying := False;

       if (estensione='.aac') or
          //(estensione='.mp3') or
          (estensione='.m4a') or
          (estensione='.f4a') then begin
          isvideoplaying := True;
        uflvplayer.init_flv_player(nome);
        exit;
       end;

        hr := player_openStream(nome,estensione,isPreview);
        if Failed(hr) then begin
         player_deleteformer_preview;
         vars_global.caption_player := 'Media Error: '+DSUtil.GetErrorString(hr);
         ares_frmmain.mplayerpanel1.wcaption := vars_global.caption_player;
         exit;
        end;

        if imgscnlogo<>nil then imgscnlogo.visible := True;

            player_get_volumesettings;

            caption_player := get_player_displayname(nome,estensione);
            ares_frmmain.mplayerpanel1.wcaption := caption_player;

            player_resetTrackbar;
            player_setTrackbar(true,nome,estensione);

            player_actualfile := nome;

            runmedia;
end;


playlist_selectfile;
player_deleteformer_preview;
end;




function player_openStream(fname: WideString; ext: string; isPreview:boolean=false):HResult;
begin
result := S_OK;
try

if helper_player.m_graphBuilder<>nil then player_NilLAll;


player_is_playing_image := (pos(ext,PLAYABLE_IMAGE_EXT)<>0);

// can't play image using asyncEx and seeking doesn't work well with videos
// therefore we're allowed to use it only with certain audio files
// everything else is rendered by means of the filtergraph thingy

if ((pos(ext,PLAYABLE_ASYNCEX)=0) or (helper_diskio.isWriteableFile(fname))) then begin
result := CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC,TGUID(IID_IGraphBuilder), m_GraphBuilder);
if Failed(result) then exit;

if ext='.mp3' then begin                     //MP3Source.ax
  Result := CoCreateInstance(TGUID(CLSID_Mp3Dec), NIL, CLSCTX_INPROC, TGUID(IID_IBaseFilter),m_Mp3Dec);
  if not failed(result) then begin
   m_GraphBuilder.AddFilter(m_Mp3Dec,'File Source (MP3)');
   with m_Mp3Dec as IFileSourceFilter do Load(pwidechar(fname), nil);
   m_Pin := GetOutPin(m_Mp3Dec,0);
   Result := (m_GraphBuilder as IGraphbuilder).Render(m_Pin);
   if failed(result) then begin
     player_NilLAll;
     Result := CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC,TGUID(IID_IGraphBuilder), m_GraphBuilder);
     if Failed(result) then exit;
     Result := m_GraphBuilder.RenderFile(pwidechar(fname),nil);
   end;
  end;
end else
  Result := m_GraphBuilder.RenderFile(pwidechar(fname),nil);

 exit;
end;


// audio files preview (write file access lock)
result := CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC,TGUID(IID_IGraphBuilder), m_GraphBuilder);
 if failed(result) then exit;
result := m_GraphBuilder.QueryInterface(IID_IMediaControl, m_MediaControl);
 if failed(result) then exit;
result := CoCreateInstance(TGUID(CLSID_AsyncEx), nil, CLSCTX_INPROC,IID_IBaseFilter, m_AsyncEx);
 if failed(result) then exit;
result := m_AsyncEx.QueryInterface(IID_IFilesourcefilter,m_FileSource);
 if failed(result) then exit;
result := m_FileSource.Load(pwidechar(fname), nil);
 if failed(result) then exit;
result := m_AsyncEx.FindPin(AsyncExPinID, m_Pin);
 if failed(result) then exit;
result := m_GraphBuilder.AddFilter(m_AsyncEx,StringToOleStr('AsyncEx'));
 if failed(result) then exit;
result := m_GraphBuilder.Render(m_Pin);
except
end;
end;

function DStimeFormatToString(inFormat: TGuid): string;
begin
//if (MediaSeeking.IsFormatSupported(TIME_FORMAT_BYTE) = S_OK) then
  if IsEqualGUID(inFormat,TIME_FORMAT_MEDIA_TIME) then Result := 'Time Format Media Time'
   else
  if comparemem(@inFormat,@TIME_FORMAT_NONE,16) then Result := 'Time Format None'
   else
  if comparemem(@inFormat,@TIME_FORMAT_FRAME,16) then Result := 'Time Format Frame'
   else
  if comparemem(@inFormat,@TIME_FORMAT_BYTE,16) then Result := 'Time Format Byte'
   else
  if comparemem(@inFormat,@TIME_FORMAT_SAMPLE,16) then Result := 'Time Format Sample'
   else
  if comparemem(@inFormat,@TIME_FORMAT_FIELD,16) then Result := 'Time Format Field'
   else
  Result := 'Unknown Time Format';
end;

{function Player_GetDuration: Integer;
var
    MediaSeeking:IMediaSeeking;
    RefTime,
    totalFrames: Int64;
   // RefTimeE,
   // totalFramesE:extended;
   // FPS:extended;
    timeformat: TGuid;
    hr:HResult;
begin
 if Succeeded(m_GraphBuilder.QueryInterface(IMediaSeeking, MediaSeeking)) then begin


 // videos with asyncEx have to change time format while not running
  hr := MediaSeeking.IsFormatSupported(TIME_FORMAT_FRAME);
  if failed(hr) then exit;
  if hr=S_OK then begin
   hr := MediaSeeking.SetTimeFormat(TIME_FORMAT_FRAME);
   if failed(hr) then exit;
   hr := MediaSeeking.GetDuration(totalFrames);
   if failed(hr) then exit;
  end;




  hr := MediaSeeking.GetTimeFormat(timeformat);
  if not failed(hr) then begin
   if not compareMem(@timeFormat,@TIME_FORMAT_MEDIA_TIME,16) then begin
    hr := MediaSeeking.SetTimeFormat(TIME_FORMAT_MEDIA_TIME);
    if failed(hr) then exit;
   end;
  end;

  hr := MediaSeeking.GetDuration(RefTime);
  if failed(hr) then exit;
  RefTime := RefTimeToMiliSec(RefTime);  // seconds




  totalFramesE := totalframes;
  reftimeE := (RefTime div 1000);
  FPS := totalFramesE / RefTimeE;
  'FPS:'+FloatToStrF(fps, ffNumber, 18, 2)+'  total frames:'+inttostr(totalFrames)+'  '+inttostr(refTime)


  Result := RefTime;

  MediaSeeking := nil;
 end else Result := 0;
end;  }

procedure player_resettrackbar;
begin

if ares_frmmain.trackbar_player<>nil then
  with ares_frmmain.trackbar_player do begin
   OnChanged := nil;
   Position := 0;
   TrackbarEnabled := True;
   Onchanged := ufrmmain.ares_frmmain.trackbar_playerChange;
  end;
end;

procedure player_setTrackbar(CalcDuration:boolean=true; filename: WideString=''; ext: string='');
var
MediaSeeking:IMediaSeeking;
CurrentPos,StopPos: Int64;
MlsCurrentPos,MlsStopPos: Cardinal;
hr:HResult;
mp3: TMPEGaudio;
isMp3,isAudio: Boolean;
begin
 if Failed(m_GraphBuilder.QueryInterface(IMediaSeeking, MediaSeeking)) then exit;
 MlsStopPos := 0;

 if calcDuration then begin

  if ext='.mp3' then begin
   isMp3 := True;
   isAudio := True;
  end
   else isMp3 := IsMediaMp3(Filename,isAudio);

    if isMp3 then begin
      mp3 := TMPEGAudio.create;
       if mp3.ReadFromFile(filename) then begin
         if mp3.Valid then UpdateWhatImListeningTo(mp3);
       end else UpdateWhatImListeningTo(caption_player,'');
      mp3.Free;
    end else
    if isAudio then UpdateWhatImListeningTo(caption_player,'');


 try
  hr := MediaSeeking.GetDuration(StopPos);
  if not Succeeded(hr) then exit;
  MlsStopPos := RefTimeToMiliSec(StopPos);
 except
 end;
 end;

 try
 hr := MediaSeeking.GetCurrentPosition(CurrentPos);
 if not Succeeded(hr) then exit;
 except
 end;

  MlsCurrentPos := RefTimeToMiliSec(CurrentPos);

  ares_frmmain.trackbar_player.OnChanged := nil;

   if calcDuration then begin
   ares_frmmain.trackbar_player.max := MlsStopPos;
   end;

   ares_frmmain.trackbar_player.Position := MlsCurrentPos;

  ares_frmmain.trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;

   ufrmmain.ares_frmmain.trackbar_playertimer(ufrmmain.ares_frmmain.trackbar_player,
                                              ares_frmmain.trackbar_player.Position,
                                              ares_frmmain.trackbar_player.max);
end;

procedure player_step_backward;  // move 1 second backward
begin
if not ares_frmmain.trackbar_player.TrackbarEnabled then exit;

 if ares_frmmain.trackbar_player.position-1000>0 then
 ares_frmmain.trackbar_player.Position := ares_frmmain.trackbar_player.Position-1000
  else
 ares_frmmain.trackbar_player.Position := 0;
end;

procedure player_step_forward;  // move 1 second forward
begin
if not ares_frmmain.trackbar_player.TrackbarEnabled then exit;

 if ares_frmmain.trackbar_player.position+1000<=ares_frmmain.trackbar_player.max then
  ares_frmmain.trackbar_player.Position := ares_frmmain.trackbar_player.Position+1000
   else
  ares_frmmain.trackbar_player.Position := ares_frmmain.trackbar_player.max;
end;


procedure player_get_volumesettings;
var
reg: Tregistry;
position: Integer;
{i,}value: Integer;
{t,c,v:extended; }
begin
if m_GraphBuilder=nil then exit;

reg := tregistry.create;

with reg do begin
try

 openkey(areskey,true);

          if valueexists('Player.Mute') then
            if readinteger('Player.Mute')=1 then begin
             player_SetVolume(0);
             closekey;
             destroy;
             exit;
            end;

            if valueexists('Player.Volume') then begin
              position := 10000-readinteger('Player.Volume');
              value := (position - (position*2))+10000;
              player_SetVolume(value);
            end else player_SetVolume(10000);


          closekey;
except
end;
   destroy;
end;
end;

procedure player_SetVolume(Volume: Integer);
var
    BasicAudio: IBasicAudio;
    FVolume: Integer;
begin
FVolume := EnsureRange(Volume,0,10000);

if uflvplayer.FLVplayer<>nil then begin
 uflvplayer.FLVPlayer.SetVariable('setcVolume',inttostr(FVolume div 100));
 exit;
end else
if unetPlayer.NETPlayer<>nil then begin
 unetPlayer.NETPlayer.SetVariable('setcVolume',inttostr(FVolume div 100));
 exit;
end;

     if isPlayingShoutcast then
      if not renderingMp3Stream then begin
       SetWavOutVolume(FVolume);
       exit;
      end;

     if helper_player.m_GraphBuilder=nil then exit;

    if Succeeded(m_GraphBuilder.QueryInterface(IBasicAudio, BasicAudio)) then begin
     // if FLinearVolume then
     BasicAudio.put_Volume(SetBasicAudioVolume(FVolume));
        //else
       // BasicAudio.put_Volume(FVolume-10000);
     BasicAudio := nil;
    end;
end;

procedure SetWavOutVolume(volume:integer);
var
 volValue,VolInteger: Cardinal;
 VolDouble:double;
begin
  VolDouble := Volume;
  VolDouble := VolDouble*6.535;
  VolInteger := Trunc(VolDouble);
  volValue := (VolInteger shl 16)+VolInteger;
  waveOutSetVolume(0, volValue);
end;

procedure player_deleteformer_preview;
begin
if length(vars_global.data_path)>0 then
 erase_dir_recursive(vars_global.data_path+'\Temp\');
end;

procedure pausemedia;
var
hr:HResult;
begin
  try
  if m_GraphBuilder=nil then exit;

    if m_mediaControl=nil then begin
     if not FAILED(m_GraphBuilder.QueryInterface(IID_IMediaControl, m_MediaControl)) then begin
      hr := m_MediaControl.pause;
     end;
    end else hr := m_MediaControl.pause;
    ares_frmmain.MPlayerPanel1.Playing := False;

  except
  end;
end;

function player_GetState: TGraphState;
var
    AState: TFilterState;
    MediaControl: IMediaControl;
begin
result := gsUninitialized;
if m_graphBuilder=nil then exit;

    if Succeeded(m_graphBuilder.QueryInterface(IMediaControl, MediaControl)) then begin
      MediaControl.GetState(0,AState);
      case AState of
        State_Stopped: Result := gsStopped;
        State_Paused : Result := gsPaused;
        State_Running: Result := gsPlaying;
      end;
      MediaControl := nil;
    end;
end;

procedure player_PutFullScreen(isFullScreen:boolean);
var
VideoWindow:IVideoWindow;
hr:HResult;
FWindowStyle, FWindowStyleEx: LongWord;
begin
if m_graphBuilder=nil then exit;
if m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow)<>S_OK then exit;

if isFullScreen then begin

 FFullScreenWindow := TForm.create(nil);
  FFullScreenWindow.Color := $0;
  FFullScreenWindow.DefaultMonitor := dmDesktop;
  FFullScreenWindow.BorderStyle := bsnone;
  FFullScreenWindow.BoundsRect := rect(0,0,screen.width,screen.Height);
  FFullScreenWindow.Show;
  FFullScreenWindow.FormStyle := fsStayOnTop; //fsNormal;
  FFullScreenWindow.onDblclick := ufrmmain.ares_Frmmain.panel_vidDblClick;
  FFullScreenWindow.PopupMenu := ares_frmmain.PopupMenuvideo;
  FFullScreenWindow.OnMouseMove := ufrmmain.ares_frmmain.fullscreenMouseMove;

  GetCursorPos(vars_global.prev_cursorpos);
  ares_frmmain.timer_fullScreenHideCursor.interval := 3000;
  ares_frmmain.timer_fullScreenHideCursor.enabled := True;  // hide cursor in 2 seconds

 //SetVideoZOrder;
 //FFullScreenWindow.OnCloseQuery := FullScreenCloseQuery;
  hr := videowindow.put_owner(FFullScreenWindow.Handle);
  if failed(hr) then exit;
  hr := VideoWindow.put_MessageDrain(FFullScreenWindow.Handle);
  if failed(hr) then exit;

  hr := VideoWindow.SetWindowPosition(0, 0, FFullScreenWindow.Width, FFullScreenWindow.Height);
end else begin


  FWindowStyle := GetWindowLong(ares_frmmain.panel_vid.Handle, GWL_STYLE);
  FWindowStyleEx := GetWindowLong(ares_frmmain.panel_vid.Handle,GWL_EXSTYLE);
  videowindow.put_owner(ares_frmmain.panel_vid.handle);
  videowindow.put_WindowStyle(FWindowStyle or WS_CHILD or WS_CLIPSIBLINGS);
  videowindow.put_WindowStyleEx(FWindowStyleEx);
  videowindow.SetWindowPosition(0,0,ares_frmmain.panel_vid.Width,ares_frmmain.panel_vid.Height);
  hr := VideoWindow.put_MessageDrain(ares_frmmain.panel_vid.handle);

  ares_frmmain.timer_fullScreenHideCursor.enabled := False;
  if FFullScreenwindow<>nil then FFullScreenWindow.release;
  FFullScreenWindow := nil;
  ares_frmmain.timer_fullScreenHideCursor.enabled := False;
  while ShowCursor(true)<0 do;

end;

end;

{
procedure SetVideoZOrder;
var
    input    : IPin;
    enum     : IEnumPins;
    ColorKey : TColorKey;
    dwColorKey : DWord;
    MPC     : IMixerPinConfig;
begin

    try
      ColorKey.KeyType := CK_INDEX or CK_RGB;
      ColorKey.PaletteIndex := 0;
      ColorKey.LowColorValue := $000F000F;
      ColorKey.HighColorValue := $000F000F;

      FVideoWindowHandle := findWindowEx(Parent.handle, 0, 'VideoRenderer', PChar(name));
      if FVideoWindowHandle = 0 then
        FVideoWindowHandle := findWindowEx(0, 0, 'VideoRenderer', PChar(name));
      if FVideoWindowHandle = 0 then Exit;
      SetWindowPos(FVideoWindowHandle, Handle, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE or SWP_NOCOPYBITS or SWP_NOACTIVATE);
      if (FVideoWindowHandle <> 0) then
      begin
        FOverlayMixer.EnumPins(Enum);
        Enum.Next(1, Input, nil);

        if Succeeded(Input.QueryInterface(IID_IMixerPinConfig2, MPC)) then
        begin
          MPC.GetColorKey(ColorKey, dwColorKey);
          FColorKey := ColorKey.HighColorValue;
          if Assigned(FOnColorKey) then
            FOnColorKey(Self);
        end;
      end;
    finally
      Input := nil;
      Enum := nil;
      MPC := nil;
    end;
  end;
 }

end.
