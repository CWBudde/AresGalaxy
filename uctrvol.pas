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
window shown when changing player volume settings
}

unit uctrvol;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, comettrack,registry,const_ares,
  ares_types, XPbutton, TntStdCtrls,utility_ares,math,vars_localiz,
  mmsystem;

type
  Tfrmctrlvol = class(TForm)
    btn_close: TXPbutton;
    CheckBox1: TTntCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure ksoOfficeSpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure trackbar1Changed(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FPosition,FMax: Integer;
    FThumbHeight: Integer;
    FMouseDown: Boolean;
   procedure PaintVolume(ShouldInvalidate:boolean=false);
  public
    { Public declarations }
  end;

var
  frmctrlvol: Tfrmctrlvol;


implementation

uses
 ufrmmain,helper_player,vars_global,shoutcast,uflvplayer;

{$R *.DFM}

procedure Tfrmctrlvol.CheckBox1Click(Sender: TObject);
var
reg: Tregistry;
begin
if (uflvplayer.flvplayer=nil) and (helper_player.m_GraphBuilder=nil) then exit;

  if checkbox1.checked then begin
   helper_player.player_SetVolume(0);
  end else begin
   trackbar1changed(nil);
   exit;
  end;


 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);
  writeinteger('Player.Mute',integer(checkbox1.checked));
  closekey;
  destroy;
 end;

end;

procedure Tfrmctrlvol.ksoOfficeSpeedButton1Click(Sender: TObject);
begin
close;
end;

procedure Tfrmctrlvol.FormClose(Sender: TObject; var Action: TCloseAction);
begin
PostMessage(ares_frmmain.mplayerPanel1.Handle,$0400{WM_USER},0,0);
action := cafree;
end;

procedure Tfrmctrlvol.FormDeactivate(Sender: TObject);
begin
close;
end;



procedure Tfrmctrlvol.FormPaint(Sender: TObject);
var
 rc: TRect;
begin
try

with canvas do begin
 brush.color := clblack;
 pen.color := clblack;
 with rc do begin
  left := 0;
  right := self.width;
  top := 0;
  bottom := 1;
 end;
 fillrect(rc);
 with rc do begin
  top := self.height-1;
  bottom := self.height;
 end;
 fillrect(rc);
 with rc do begin
  top := 0;
  right := 1;
 end;
 fillrect(rc);
 with rc do begin
  left := self.width-1;
  right := self.width;
 end;
 fillrect(rc);
end;

PaintVolume;

except
end;
end;

procedure TFrmCtrlVol.PaintVolume(ShouldInvalidate:boolean=false);
var
posy: Integer;
begin
if shouldInvalidate then begin
 canvas.brush.color := color;
 canvas.FillRect(rect(18,10,clientwidth-26,clientheight-35));
end;

// dra white triangle on the left
canvas.pen.color := clwhite;
canvas.MoveTo(clientwidth-33,10);
canvas.lineto(23,10);
canvas.lineto(clientwidth-32,clientheight-35);
// draw gray right line
canvas.pen.color := clgray;
canvas.MoveTo(clientwidth-32,10);
canvas.LineTo(clientwidth-32,clientheight-35);

//draw thumb
posy := ((clientheight - (43 + (FThumbHeight+2))) * FPosition) div FMax;  // 10 height of thumb
inc(posy,FThumbHeight+9);


canvas.Pen.color := clblack;
canvas.moveTo(18,posy);
canvas.LineTo(clientWidth-27,posy);
canvas.LineTo(clientWidth-27,posy-FThumbHeight);

canvas.Pen.color := clgray;
canvas.moveTo(18,posy-1);
canvas.LineTo(clientWidth-28,posy-1);
canvas.LineTo(clientWidth-28,posy-FThumbHeight);

canvas.brush.color := $00ededed;
canvas.FillRect(rect(19,posy-1,clientwidth-29,(posy-FThumbHeight)+2));

canvas.Pen.color := clwhite;
canvas.moveTo(18,posy-2);
canvas.LineTo(18,(posy-FThumbHeight)+1);
canvas.LineTo(clientwidth-28,(posy-FThumbHeight)+1);
end;

procedure Tfrmctrlvol.trackbar1Changed(Sender: TObject);
var
reg: Tregistry;
value,volume: Integer;

begin
try
  value := (Fposition - (FPosition*2))+10000;

  volume := value;
  checkbox1.checked := False;

 helper_player.player_setVolume(volume);


 reg := tregistry.create;
 with reg do begin
 openkey(areskey,true);
   writeinteger('Player.Volume',10000-Fposition);
   Writeinteger('Player.Mute',0);
 closekey;
 destroy;
 end;
except
end;
end;

procedure Tfrmctrlvol.FormShow(Sender: TObject);
var
reg: Tregistry;
begin
try
if helper_player.FFullScreenWindow<>nil then
 ufrmmain.ares_frmmain.PopupMenuvideoPopup(nil);  // show cursor
except
end;
font := ares_FrmMain.font;
 CheckBox1.caption := GetLangStringW(STR_MUTE);


 reg := tregistry.create;
 with reg do begin
 openkey(areskey,true);

 if valueexists('Player.Mute') then begin
  checkbox1.checked := (readinteger('Player.Mute')=1);
 end else checkbox1.checked := falsE;

 if valueexists('Player.Volume') then begin
  FPosition := 10000-readinteger('Player.Volume');
 end else FPosition := 0;
  
 closekey;
 destroy;
 end;

end;


procedure Tfrmctrlvol.btn_closeClick(Sender: TObject);
begin
close;
end;

procedure Tfrmctrlvol.FormCreate(Sender: TObject);
begin
color := COLORE_PANELS_BG;
FPosition := 0;
FMax := 10000;
FThumbHeight := 15;
FMouseDown := False;
btn_close.OnXPButtonDraw := ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
end;

procedure Tfrmctrlvol.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 YVar: Integer;
begin
if x<17 then exit;
if x>54 then exit;

FMouseDown := True;
cursor := crHandpoint;

YVar := Y-(FThumbHeight);
FPosition := (YVar*FMax) div (clientheight-(45+FThumbHeight));
if FPosition>FMax then FPosition := FMax;
if FPosition<0 then FPosition := 0;
caption := inttostr(FPosition);
PaintVolume(true);
trackbar1changed(nil);
end;

procedure Tfrmctrlvol.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 YVar: Integer;
begin
if (x<17) or (x>54) then begin
 cursor := crdefault;
end else begin
 if ((y>10) and (y<height-35)) then cursor := crhandpoint
  else cursor := crDefault;
end;

if not FMouseDown then exit;
 cursor := crhandpoint;

 YVar := Y-(FThumbHeight);
FPosition := (YVar*FMax) div (clientheight-(45+FThumbHeight));
if FPosition>FMax then FPosition := FMax;
if FPosition<0 then FPosition := 0;
caption := inttostr(FPosition);
PaintVolume(true);

trackbar1changed(nil);

try
if helper_player.FFullScreenWindow<>nil then
 ufrmmain.ares_frmmain.PopupMenuvideoPopup(nil);  // show cursor
except
end;
end;

procedure Tfrmctrlvol.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
FMouseDown := False;
end;

end.
