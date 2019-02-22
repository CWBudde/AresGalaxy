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
control unit for netplayer.swf: handle rtmp and http multimedia connections
}

unit unetPlayer;

interface

uses
 ShockwaveEx,windows,classes,sysutils,comettrees; //SHDocVw_TLB,MSHTML,ActiveXwindowscontrols,UBrowserContainer,graphics,forms,ActiveX;

 procedure init_net_player(const streamer: WideString; const playpath: WideString; const capt: WideString; const weburl: WideString; const captwebUrl: WideString); overload;
 procedure init_net_player(initStr: WideString); overload;
 procedure freePlayer(sender: TObject);
 procedure loadNETChannels(const filename: WideString);
// procedure NETPlayer_SetVariable(const variableName: WideString; const variableArg: WideString);

var
 NETPlayer: TShockwaveFlashEx;
 NETPlayerLength: Int64;
 NETPlayerPosition: Int64;
 NETPlayerWidth: Integer;
 NETPlayerHeight: Integer;
 NETPlayerGeometry:double;
// fWBContainer: TWBContainer;

implementation

uses
umediar,helper_diskio,vars_global,ufrmmain,ares_types,helper_strings,
 const_ares,helper_player,helper_datetime,helper_gui_misc,helper_urls,
 vars_localiz;


procedure freePlayer(sender: TObject);
begin
 NETPlayer.OnFSCommand := nil;
 FreeAndNil(NETPlayer);
 if imgscnlogo<>nil then imgscnlogo.visible := True;
 ares_frmmain.trackbar_player.position := 0;
 if sender<>nil then stopped_by_user := True;
 ares_frmmain.MPlayerPanel1.Playing := False;
 ares_frmmain.trackbar_player.TrackbarEnabled := False;
 ares_frmmain.trackbar_player.max := 0;
 ares_frmmain.mplayerpanel1.TimeCaption := '';
 ares_frmmain.mplayerpanel1.wcaption := '';
 ares_frmmain.MPlayerPanel1.url := '';
 ares_frmmain.MPlayerPanel1.urlCaption := '';
 NETPlayerLength := 0;
 NETPlayerPosition := 0;
 player_actualfile := ''; //do not start over pressing play again
end;

procedure init_net_player(initStr: WideString);
var
 streamer,weburl,captweburl,playpath,capt: WideString;
 ind: Integer;
begin
//if lowercase(copy(initStr,1,4))='rtmp' then begin
  streamer := copy(initstr,1,pos('|',initStr)-1);
 delete(initStr,1,pos('|',initStr));
  playpath := copy(initstr,1,pos('|',initStr)-1);
 delete(initStr,1,pos('|',initStr));
  weburl := copy(initstr,1,pos('|',initStr)-1);
 delete(initStr,1,pos('|',initStr));
  captweburl := copy(initstr,1,pos('|',initStr)-1);
 delete(initStr,1,pos('|',initStr));
 ind := pos('|',initStr);
 if ind>0 then capt := copy(initStr,1,ind-1) else capt := initStr;

 init_net_player(streamer,playpath,capt,weburl,captweburl);

end;


{function forwardslashes(const strin: string): string;
var
 i: Integer;
begin
result := strin;
for i := 1 to length(result) do if result[i]='\' then result[i] := '/';
end; }

procedure init_net_player(const streamer: WideString; const playpath: WideString; const capt: WideString; const weburl: WideString; const captwebUrl: WideString); overload;
var
 rs: TResourceStream;
begin
if NETPlayer<>nil then begin
//FlvPlayer.Stop;
FreeAndNil(NETPlayer);
end;

 try
NETPlayerLength := 0;
NETPlayerPosition := 0;
NETPlayerGeometry := 1.333333333333333; //4:3

 if ares_frmmain.tabs_pageview.activePage=IDTAB_SCREEN then ares_frmmain.panel_screen.visible := False;
//ares_frmmain.tabs_pageview.activePage := IDTAB_WEB;
 NETPlayer := TShockwaveFlashEx.create(nil);
 NETPlayer.BackgroundColor := 0;
  if FindResource(hInstance, 'netplayer', RT_RCDATA)=0 then begin
   //amf.RTMP_Log('init_flv_player can''t find resource');
   FreeAndNil(NETPlayer);
   exit;
  end;
    rs := TResourceStream.Create(hInstance, 'netplayer', RT_RCDATA);
    rs.Position := 0;
    NETPlayer.LoadMovieFromStream(rs);
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

with NETPlayer do begin
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
 OnFSCommand := ufrmmain.ares_frmmain.NetPlayerFSCommand;
 //Movie := app_path+'\Data\flvplayer.swf'; //thepath;
 //Movie := thepath;
 //SetVariable('flashvars','file='+extractfilename(filename));
// SetVariable('file',flashize_Filename(filename));
 //SetVariable('autostart','true');
 SetVariable('file',streamer);
 SetVariable('id',playpath);
end;
 

 if imgscnlogo<>nil then imgscnlogo.visible := False;

 ares_frmmain.tabs_pageview.activePage := IDTAB_SCREEN;
 ares_frmmain.panel_screen.visible := True;

  caption_player := capt;
 ares_frmmain.mplayerpanel1.wcaption := caption_player+'    '+GetLangStringW(STR_CONNECTING_TO_NETWORK)+'.';
 ares_frmmain.mplayerpanel1.urlCaption := captweburl;
 ares_frmmain.mplayerpanel1.url := weburl;
 isvideoplaying := True;

 helper_player.player_actualfile := streamer+'|'+playpath+'|'+capt;

 player_resettrackbar;

 ares_frmmain.trackbar_player.OnChanged := nil;
 ares_frmmain.trackbar_player.max := 0;
 ares_frmmain.trackbar_player.Position := 0;

 if lowercase(copy(streamer,1,4))='http' then begin
  ares_frmmain.trackbar_player.OnChanged := ufrmmain.ares_frmmain.trackbar_playerChange;
  ares_frmmain.trackbar_player.Enabled := True;
   ares_frmmain.mplayerpanel1.TimeCaption := format_time(0)+' / '+
                                           format_time(0);
 end else begin
  ares_frmmain.trackbar_player.TrackbarEnabled := False;
  ares_frmmain.mplayerpanel1.TimeCaption := format_time(0);
 end;
 ares_frmmain.MPlayerPanel1.Playing := True;

 player_get_volumesettings;



 except
 end;
end;


procedure loadNETChannels(const filename: WideString);
var
 stream: Thandlestream;
 str_tot,str: string;
 lun: Int64;
 buffer: array [0..1023] of Byte;
 rootnode,genreNode:pcmtVnode;
 rootCapt,genreCapt:precordNetStreamChannel;
 first: Boolean;

 procedure parseChannels;
 var
  line: string;
  ind: Integer;
  channel:precordNetStreamChannel;
  node:pcmtVnode;
  //ttype: TnetStreamType;
 begin



   while (length(str_tot)>0) do begin
    ind := pos(CRLF,str_tot);
    if ind<1 then exit;
    line := copy(str_tot,1,ind-1);
    delete(str_tot,1,ind+1);
    if copy(line,1,1)='#' then continue;
    
    if copy(line,1,5)='type:' then begin
     if rootNode<>nil then ares_frmmain.tvChannels.expanded[rootNode] := True;
     rootnode := ares_frmmain.tvChannels.addChild(nil);

     rootCapt := ares_frmmain.tvChannels.getData(rootnode);
     rootCapt^.capt := copy(line,6,length(line));
     rootCapt^.language := '';
     continue;
    end;
    if copy(line,1,6)='genre:' then begin
     genrenode := ares_frmmain.tvChannels.addChild(rootnode);
     genreCapt := ares_frmmain.tvChannels.getData(genrenode);
     genreCapt^.capt := copy(line,7,length(line));
     genreCapt^.language := '';
     continue;
    end;
    if length(line)<10 then continue;
   node := ares_Frmmain.tvChannels.addChild(genrenode);
    channel := ares_Frmmain.tvChannels.getData(node);
    channel^.streamUrl := copy(line,1,pos('|',line)-1);
     delete(line,1,pos('|',line));
    channel^.streamPlaypath := copy(line,1,pos('|',line)-1);
     delete(line,1,pos('|',line));
    channel^.language := copy(line,1,pos('|',line)-1);
     delete(line,1,pos('|',line));
    channel^.webUrl := copy(line,1,pos('|',line)-1);
     delete(line,1,pos('|',line));
    channel^.webCapt := copy(line,1,pos('|',line)-1);
     delete(line,1,pos('|',line));
    ind := pos('|',line);
    if ind>0 then channel^.capt := copy(line,1,ind-1) else channel^.capt := line;
   end;
 end;

begin
rootnode := nil;
genrenode := nil;

stream := MyFileOpen(filename,ARES_READONLY_BUT_SEQUENTIAL);
      if stream=nil then exit;

 ares_Frmmain.tvChannels.beginupdate;

      first := True;
      str_tot := '';
      with stream do begin
        while (position+1<size) do begin
         lun := read(buffer,sizeof(buffer));
         SetLength(str,lun);
         move(buffer,str[1],lun);

         if first then begin //strip utf8 bom
          first := False;
          if copy(str,1,3)=chr($ef)+chr($bb)+chr($bf) then delete(str,1,3);
         end;

          str_tot := str_tot+
                   str;
                   parseChannels;
        end;
      end;
      FreeHandleStream(stream);
 if rootNode<>nil then ares_frmmain.tvChannels.expanded[rootNode] := True;
 //ares_Frmmain.tvChannels.FullExpand(nil);
 ares_Frmmain.tvChannels.endUpdate;
end;



end.