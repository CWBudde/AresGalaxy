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
control unit of flvplayer.swf: plays flv and mp4 files
}

unit uflvplayer;

interface

uses
 ShockwaveEx,windows,classes,sysutils;

 procedure init_flv_player(const filename: WideString);
 procedure freePlayer(sender: TObject);
 //function copyFLVPlayer(const filename: WideString; const thepath: WideString): Boolean;

var
 FLVPlayer: TShockwaveFlashEx;
 FLVLength: Int64;
 FLVPosition: Int64;
 FLVWidth: Integer;
 FLVHeight: Integer;
 FLVGeometry:double;

implementation

{$R flvplayer.res}

uses
 umediar,helper_diskio,vars_global,ufrmmain,ares_types,helper_strings,
 const_ares,helper_player,helper_datetime,helper_gui_misc,helper_urls;

 
procedure freePlayer(sender: TObject);
begin
 FLVPlayer.OnFSCommand := nil;

 FreeAndNil(FLVPlayer);
 if imgscnlogo<>nil then imgscnlogo.visible := True;
 ares_frmmain.trackbar_player.position := 0;
 if sender<>nil then stopped_by_user := True;
 ares_frmmain.MPlayerPanel1.Playing := False;
 ares_frmmain.trackbar_player.TrackbarEnabled := False;
 ares_frmmain.trackbar_player.max := 0;
 ares_frmmain.mplayerpanel1.TimeCaption := '';
 FLVLength := 0;
 FLVPosition := 0;

end;

{function copyFLVPlayer(const filename: WideString; const thepath: WideString): Boolean;
var
 streamIn,streamOut: Thandlestream;
 len: Integer;
 buffeR: array [0..1023] of Byte;
begin
result := False;
try
if not fileexistsW(thepath) then begin
 if not fileexistsW(app_path+'\data\flvplayer.swf') then exit;

 streamin := myfileopen(app_path+'\data\flvplayer.swf',ARES_READONLY_ACCESS);
 streamout := myfileopen(thepath,ARES_OVERWRITE_EXISTING);
 if streamin=nil then exit;
 if streamout=nil then exit;

 while (streamin.position<streamIn.size) do begin
  len := streamIn.read(buffer,sizeof(buffer));
       streamOut.Write(buffer,len);
  if len<>sizeof(buffer) then break;
 end;

 FreeHandleStream(streamIn);
 FreeHandleStream(streamOut);
end;

result := True;
except
end;
end; }


procedure init_flv_player(const filename: WideString);
var
 rs: TResourceStream;
begin
if FLVPlayer<>nil then begin
//FlvPlayer.Stop;
FreeAndNil(FLVPlayer);
end;

 try
FLVLength := 0;
FLVPosition := 0;
FLVGeometry := 1.333333333333333; //4:3

 if ares_frmmain.tabs_pageview.activePage=IDTAB_SCREEN then ares_frmmain.panel_screen.visible := False;
//ares_frmmain.tabs_pageview.activePage := IDTAB_WEB;
 FLVPlayer := TShockwaveFlashEx.create(nil);
 FLVPlayer.BackgroundColor := 0;
  if FindResource(hInstance, 'flvplayer', RT_RCDATA)=0 then begin
   //amf.RTMP_Log('init_flv_player can''t find resource');
   FreeAndNil(FLVPlayer);
   exit;
  end;
    rs := TResourceStream.Create(hInstance, 'flvplayer', RT_RCDATA);
    rs.Position := 0;
    FLVPlayer.LoadMovieFromStream(rs);
   rs.Free;
{
with FLVPlayer do begin
 parent := ares_frmmain.panel_vid;

 ScaleMode := 7;
 width := 640; //425; //480;
 height := 480; //325; //300;
 Quality := 3;
 left := (ares_frmmain.panel_vid.width div 2)-(width div 2); //212;
 top := (ares_frmmain.panel_vid.height div 2)-(height div 2); //162;
 Menu := False;
 Loop := False;
 OnFSCommand := ufrmmain.ares_frmmain.FlashPlayerFSCommand;
 Movie := thepath;
 SetVariable('file',flashize_Filename(filename));
end;   }

with FLVPlayer do begin
 parent := ares_frmmain.panel_vid;
 scale := '2';
 ScaleMode := 2;  //0 - ShowAll, 1 - NoBorder, 2 - ExactFit, 3 - NoScale, 4 - Low, 5 - AutoLow, 6 - AutoHight, 7 - Hight, 8 - Best, 9 - AutoMedium, 10 - Medium
 width := ares_frmmain.panel_vid.width; //dwidth; //425; //480;
 height := ares_frmmain.panel_vid.height; //dheight; //325; //300;
 Quality := 3;
 AllowFullScreen := 'True';
 //AllowFullScreenInteractive := 'true';
 left := (ares_frmmain.panel_vid.width div 2)-(width div 2);; //212;
 top := (ares_frmmain.panel_vid.height div 2)-(height div 2); //162;
 SAlign := 'LTRB'; // align scale LR, LT, TR, LTR, LB, RB, LRB, TB, LTB, TRB, LTRB
 Menu := False;
 Loop := False;
 wmode := 'transparent';
 OnFSCommand := ufrmmain.ares_frmmain.FlashPlayerFSCommand;
 //Movie := app_path+'\Data\flvplayer.swf'; //thepath;
 //Movie := thepath;
 //SetVariable('flashvars','file='+extractfilename(filename));
// SetVariable('file',flashize_Filename(filename));
 //SetVariable('autostart','true');
 SetVariable('file',flashize_Filename(filename));
end;
 

 if imgscnlogo<>nil then imgscnlogo.visible := False;

 ares_frmmain.tabs_pageview.activePage := IDTAB_SCREEN;
 ares_frmmain.panel_screen.visible := True;

 caption_player := helper_strings.get_player_displayname(filename,'.flv');
 ares_frmmain.mplayerpanel1.wcaption := caption_player;
 isvideoplaying := True;

 helper_player.player_actualfile := filename;

 player_resettrackbar;
 
 ares_frmmain.trackbar_player.OnChanged := nil;
 ares_frmmain.trackbar_player.max := FLVLength;
 ares_frmmain.trackbar_player.Position := uflvplayer.FLVPosition;
 ares_frmmain.trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;

 ares_frmmain.MPlayerPanel1.Playing := True;
 
 player_get_volumesettings;
 ares_frmmain.mplayerpanel1.TimeCaption := format_time(0)+' / '+
                                         format_time(FLVLength div 1000);


 except
 end;
end;




end.