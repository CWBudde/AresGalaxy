{
 this file is part of Ares
 Copyright (C)2005 Aresgalaxy ( http://aresgalaxy.sourceforge.org )

  This program is Free software; you can redistribute it and/or
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
Ares media player button panel
}

unit mPlayerPanel;

interface

uses
  Controls, Windows, SysUtils, Graphics, Classes, ExtCtrls, Messages, Forms;

const
  BTN_ID_PLAY      = 0;
  BTN_ID_PLAYLIST  = 1;
  BTN_ID_STOP      = 2;
  BTN_ID_PREV      = 3;
  BTN_ID_NEXT      = 4;
  BTN_ID_VOLUME    = 5;
  BTN_ID_RADIO     = 6;

type
  TMPlayerButtonID = (
    MPBtnNone,
    MPBtnPlaylist,
    MPBtnStop,
    MPBtnPrev,
    MPBtnRew,
    MPBtnPlay,
    MPBtnPause,
    MPBtnFF,
    MPBtnNext,
    MPBtnVol,
    MPBtnRadio
  );

  TMPlayerNotifyEvent = procedure(BtnId: TMPlayerButtonID) of object;
  TCmtUrlClickEvent = procedure(Sender: TObject; const URLText: String; Button: TMouseButton) of object;

  TMPlayerButtonState = (
    MPBtnOff,
    MPBtnHover,
    MPBtnDown
  );

  TMPlayerButton = class
    FID: TMPlayerButtonID;
    FHitRect: TRect; // click zone
    FPaintOffset: TPoint; // where to paste pictures on destination (relative to player section Left)
    FOffCopyRect,  // where to copy state pictures from
    FHoverCopyRect,
    FDownCopyRect: TRect;
    FState: TMPlayerButtonState;
  end;

  TMBtnArray = array of TMPlayerButton;

  TMPlayerPanel = class(TPanel)
  private
    FLoaded: Boolean;

    FButtons: TMBtnArray;
    FSourceBitmap: Graphics.TBitmap;

    FRewindDownCopyRect,
    FFastForwardDownCopyRect: TRect;

    FPlaying: Boolean;  // swap play to pause

    FleftCenter: Integer;
    FOnClick: TMPlayerNotifyEvent;
    FOnBtnHint: TMPlayerNotifyEvent;
    FOnUrlClick: TCmtUrlClickEvent;
    FOnCaptionClick: TNotifyEvent;

    FSeekTimer, FSeekTickTimer: TTimer;

    FPlayOffCopyRect,
    FPlayHoverCopyRect,
    FPlayDownCopyRect,
    FPauseOffCopyRect,
    FPauseHoverCopyRect,
    FPauseDownCopyRect: TRect;

    FTimeCaption, FUrl: string;
    FCaption, FUrlCaption: WideString;
    FLastposTimeCaption: Integer;
    FPosUrl, FPosTimeCaption, FMaxWidthCaption, FSizeUrlCaption: Integer;
    procedure SetUrl(const Value: string);
    procedure SetwCaption(const Value: WideString);
    procedure SetUrlCaption(const Value: WideString);
    procedure SetTimeCaption(const Value: string);
    procedure RecalcPositions(clRect: TRect; ACanvas: TCanvas);

    procedure InvalidateCaptions(ACanvas: TCanvas = nil);
    procedure InvalidateCaption(clRect: TRect; ACanvas: TCanvas);
    procedure InvalidateTimeCaption(clRect: TRect; ACanvas: TCanvas);
    procedure InvalidateUrlCaption(clRect: TRect; ACanvas: TCanvas);

    procedure SetPlaying(Value: Boolean);
    procedure DrawButtons(ACanvas: TCanvas);  // draw all buttons in their current state (in response to an invalidate component)
    procedure RepaintPreviouslyActiveButtons(ExceptButton: TMPlayerButton; SetState: Boolean = True; RemoveDown: Boolean = False);
    procedure SeekTimerStartTimer(Sender: TObject);  // is FF or RewButton still pressed?
    procedure SeekTimerEventTimer(Sender: TObject);
    function GetPressedButton: TMPlayerButton;
    procedure SetSourceBitmap(Value: Graphics.TBitmap);

    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure WMUser(var msg: TMessage); message WM_USER;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUP(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  published
    property url: string read FUrl write SetUrl;
    property urlCaption: WideString read FUrlCaption write SetUrlCaption;
    property wcaption: WideString read FCaption write SetwCaption;
    property TimeCaption: string read FTimeCaption write SetTimeCaption;
    property Buttons: TMBtnArray read FButtons;
    property SourceBitmap: Graphics.TBitmap read FSourceBitmap write SetSourceBitmap;
    property Playing: Boolean read FPlaying write SetPlaying;
    property OnClick: TMPlayerNotifyEvent read FOnClick write FOnClick;
    property OnBtnHint: TMPlayerNotifyEvent read FOnBtnHint write FOnBtnHint;
    property OnUrlClick: TCmtUrlClickEvent read FOnUrlClick write FOnUrlClick;
    property OnCaptionClick: TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
 end;

procedure Register;

implementation

{$R bmpmplayer.res}

constructor TMPlayerPanel.create(Owner: TComponent);
var
  btn: TMPlayerButton;
begin
  inherited create(Owner);

  parent := (Owner as TWInControl);

  FLoaded := False;
  FOnClick := nil;
  FOnBtnHint := nil;
  FOnUrlClick := nil;
  FOnCaptionClick := nil;

  FSizeUrlCaption := 0;
  FPosTimeCaption := 0;
  FPosUrl := FPosTimeCaption;
  FLastposTimeCaption := 0;
  FCaption := '';
  FUrlCaption := '';
  FUrl := '';
  FTimeCaption := '';

  FPlayOffCopyRect := Rect(35,3,25,25);
  FPlayHoverCopyRect := rect(25,35,25,25);
  FPlayDownCopyRect := rect(25,35,25,25);

  FPauseOffCopyRect := rect(98,35,25,25);
  FPauseHoverCopyRect := rect(123,35,25,25);
  FPauseDownCopyRect := rect(123,35,25,25);

  // FastForward/Rewind timers...if button is still down after a second, seek (by simulating click event every 10 millisecs)
  FSeekTimer := TTimer.create(nil);
  FSeekTimer.Enabled := False;
  FSeekTimer.Interval := 700;
  FSeekTimer.OnTimer := SeekTimerStartTimer;

  FSeekTickTimer := TTimer.create(nil);
  FSeekTickTimer.Enabled := False;
  FSeekTickTimer.Interval := 50;
  FSeekTickTimer.OnTimer := SeekTimerEventTimer;


  // path := 'C:\Programmi\Borland\Delphi7\Projects\test\mplayer panel\';
  FSourceBitmap := Graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BTMMPLAYER');
  // FSourceBitmap.savetoFile('c:\sourcebitmap.bmp');

  SetLength(FButtons,7);

  // play button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnPlay;
    FHitRect := rect(35,3,59,27);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 34;
      y := 3;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := FPlayOffCopyRect;  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := FPlayHoverCopyRect;
    FDownCopyRect := FPlayDownCopyRect;
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_PLAY] := btn;


  //playlist button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnPlaylist;
    FHitRect := rect(125,3,145,22);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 125;
      y := 3;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := rect(126,3,22,24);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := rect(0,61,22,24);
    FDownCopyRect := rect(0,61,22,24);
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_PLAYLIST] := btn;

  // stop button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnStop;
    FHitRect := rect(96,4,119,27);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 95;
      y := 4;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := rect(96,4,22,22);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := rect(75,35,22,22);
    FDownCopyRect := rect(75,35,22,22);
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_STOP] := btn;

  // prev button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnPrev;
    FHitRect := rect(4,4,28,27);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 3;
      y := 3;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := rect(4,3,25,25);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := rect(0,35,25,25);
    FDownCopyRect := rect(0,35,25,25);
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_PREV] := btn;

  // rects of the media seek equivalents (these images get displayed when theres seeking in progress
  FRewindDownCopyRect := rect(148,35,25,25);
  FFastForwardDownCopyRect := rect(173,35,25,25);

  // next button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnNext;
    FHitRect := rect(67,4,92,27);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 66;
      y := 3;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := Rect(67,3,25,25);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := Rect(50,35,25,25);
    FDownCopyRect := Rect(50,35,25,25);
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_NEXT] := btn;


  // volume button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnVol;
    FHitRect := rect(150,3,172,22);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 148;
      y := 2;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := Rect(149,2,20,24);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := Rect(22,61,20,24);
    FDownCopyRect := Rect(22,61,20,24);
    FState := MPBtnOff;
  end;
 FButtons[BTN_ID_VOLUME] := btn;

  // radio button
  btn := TMPlayerButton.create;
  with btn do
  begin
    FID := MPBtnRadio;
    FHitRect := rect(170,7,184,23);  //sligthly smaller than Paint rect, points sensible to mouse cursor
    with FPaintOffset do
    begin
      x := 168;
      y := 2;   // where we have to paste state bitmaps on destination Canvas (relative to player panel Left)
    end;
    FOffCopyRect := Rect(168,2,23,24);  // where we have to copy state images from on our source bitmap
    FHoverCopyRect := Rect(42,61,23,24);
    FDownCopyRect := Rect(42,61,23,24);
    FState := MPBtnOff;
  end;
  FButtons[BTN_ID_RADIO] := btn;

  FLoaded := True;
end;

destructor TMPlayerPanel.Destroy;
var
  i: Integer;
  btn: TMPlayerButton;
begin
  for i := 0 to high(FButtons) do begin
   btn := FButtons[i];
   btn.Free;
  end;
  SetLength(FButtons,0);



  FSeekTimer.Enabled := False;
  FSeekTickTimer.Enabled := False;
  FSeekTimer.Free;
  FSeekTickTimer.Free;

  FSourceBitmap.Free;

  inherited;
end;

procedure TMPlayerPanel.SetSourceBitmap(Value:Graphics.TBitmap);
begin
  if Value=nil then
  begin   // use internal bitmap
    if FSourceBitmap <> nil then
      FSourceBitmap.Free;
    FSourceBitmap := Graphics.TBitmap.create;
    FSourceBitmap.LoadFromResourceName(hinstance,'BTMMPLAYER');
  end else
  begin      // use external bitmap
    if FSourceBitmap<>nil then
      FSourceBitmap.Free;
    FSourceBitmap := Value;
  end;
end;

procedure TMPlayerPanel.SetUrl(const Value: string);
begin
  FUrl := Value;
  if Length(FUrlCaption)=0 then
    FUrlCaption := FUrl;
  if not FLoaded then Exit;
  InvalidateCaptions;
end;

procedure TMPlayerPanel.SetwCaption(const Value: WideString);
begin
  FCaption := Value;
  if not FLoaded then
    Exit;
  InvalidateCaptions;
end;

procedure TMPlayerPanel.SetUrlCaption(const Value: WideString);
begin
  FUrlCaption := Value;
  if not FLoaded then
    Exit;
  InvalidateCaptions;
end;

procedure TMPlayerPanel.SetTimeCaption(const Value: string);
begin
  if not FLoaded then
    Exit;
  FTimeCaption := Value;
  InvalidateCaptions;
end;


procedure TMPlayerPanel.SetPlaying(Value: Boolean);
var
  btn: TMPlayerButton;
  shouldMove: Boolean;
  point: TPoint;
begin
  FPlaying := Value;

  btn := FButtons[BTN_ID_PLAY];
  if Value then
  begin
    btn.FID := MPBtnPause;
    btn.FOffCopyRect := FPauseOffCopyRect;
    btn.FHoverCopyRect := FPauseHoverCopyRect;
    btn.FDownCopyRect := FPauseDownCopyRect;
  end else
  begin
    btn.FID := MPBtnPlay;
    btn.FOffCopyRect := FPlayOffCopyRect;
    btn.FHoverCopyRect := FPlayHoverCopyRect;
    btn.FDownCopyRect := FPlayDownCopyRect;
  end;

  getCursorPos(point);
  point := screenToclient(point);
  with point do
    shouldMove := 
      ((x>=btn.FHitRect.Left+FleftCenter) and
       (x<=FleftCenter+btn.FHitRect.Right) and
       (y>=btn.FHitRect.Top) and
       (y<=btn.FHitRect.Bottom));

  repaint;

  if shouldMove then
  begin
    btn.FState := MPBtnHover;
    bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
      btn.FPaintOffset.Y, btn.FHoverCopyRect.Right, btn.FHoverCopyRect.Bottom,
      FSourceBitmap.Canvas.handle, btn.FHoverCopyRect.Left,
      btn.FHoverCopyRect.top, SRCCopy);
  end;

end;

procedure TMPlayerPanel.WMEraseBkgnd(Var Msg : TMessage);
begin
  msg.result := 1;
end;

procedure TMPlayerPanel.SeekTimerStartTimer(Sender: TObject);  // is FF or RewButton still pressed?
var
  i: Integer;
  btn: TMPlayerButton;
begin
  FSeekTimer.Enabled := False;

  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];

    if btn.FID <> MPBtnPrev then
    if btn.FID <> MPBtnNext then continue;

    if btn.fState <> MPBtnDown then continue;

    // swap down image with the correct seek image
    if btn.FID = MPBtnPrev then
      bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
        btn.FPaintOffset.Y, FRewindDownCopyRect.Right,
        FRewindDownCopyRect.Bottom, FSourceBitmap.Canvas.handle,
        FRewindDownCopyRect.Left, FRewindDownCopyRect.top, SRCCopy)
    else
      bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
        btn.FPaintOffset.Y, FFastForwardDownCopyRect.Right,
        FFastForwardDownCopyRect.Bottom, FSourceBitmap.Canvas.handle,
        FFastForwardDownCopyRect.Left, FFastForwardDownCopyRect.top, SRCCopy);

    FSeekTickTimer.Enabled := True; // time to start seeking!  redraw button as a Rew or FF one
    break;
  end;

end;

procedure TMPlayerPanel.SeekTimerEventTimer(Sender: TObject);
var
  i: Integer;
  btn: TMPlayerButton;
begin
  FSeekTickTimer.Enabled := False;

  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];

    if btn.FID<>MPBtnPrev then
    if btn.FID<>MPBtnNext then continue;

    if btn.fState<>MPBtnDown then continue;

    if Assigned(FOnClick) then
    begin
      if btn.FID=MPBtnPrev then
        FOnClick(MPBtnRew)
      else
        FOnClick(MPBtnFF);  // call event!
    end;

    FSeekTickTimer.Enabled := True; // time to start seeking!
    break;
  end;
end;


procedure TMPlayerPanel.DrawButtons(ACanvas: TCanvas);  // draw all buttons in their current state (in response to an invalidate component)
var
  i: Integer;
  btn: TMPlayerButton;
begin
  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];

    case btn.FState of
      MPBtnOff:
        bitBlt(ACanvas.handle,
          FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FOffCopyRect.Right,btn.FOffCopyRect.Bottom,
          FSourceBitmap.Canvas.handle,btn.FOffCopyRect.Left,btn.FOffCopyRect.top,SRCCopy);

      MPBtnHover:
        bitBlt(ACanvas.handle,
          FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FHoverCopyRect.Right,btn.FHoverCopyRect.Bottom,
          FSourceBitmap.Canvas.handle,btn.FHoverCopyRect.Left,btn.FHoverCopyRect.top,SRCCopy);

      MPBtnDown:
        bitBlt(ACanvas.handle,
          FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FDownCopyRect.Right,btn.FDownCopyRect.Bottom,
          FSourceBitmap.Canvas.handle,btn.FDownCopyRect.Left,btn.FDownCopyRect.top,SRCCopy);
    end;
  end;
end;

function TMPlayerPanel.GetPressedButton: TMPlayerButton;
var
  i: Integer;
  btn: TMPlayerButton;
begin
  Result := nil;
  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];
    if btn.FState=MPBtnDown then
    begin
      Result := btn;
      Exit;
    end;
  end;
end;

procedure TMPlayerPanel.MouseMove(Shift: TShiftState; X, Y: Integer); // mouse moved over control, if it's over a button's hitrect change its state to Hover (unless it's already in down state)
var
  i: Integer;
  btn,pressedButton: TMPlayerButton;
  found: Boolean;
begin
  if (x>FSourceBitmap.Width+7) and (y>5) and (y<28) then
  begin
    if ((x>=FSourceBitmap.Width+7+FPosUrl) and
        (Length(FUrlCaption)>0) and
        (Length(FUrl)>0) and
        (x<=FSourceBitmap.Width+7+FPosUrl+FSizeUrlCaption) and
        (Assigned(FOnUrlClick))) then
      self.cursor := CrHandpoint
    else
      self.cursor := crDefault;

    Exit;
  end;

  found := False;
  PressedButton := GetPressedButton;

  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];
    if x<btn.FHitRect.Left+FleftCenter then continue;
    if y<btn.FHitRect.Top then continue;
    if y>btn.FHitRect.Bottom then continue;
    if x>btn.FHitRect.Right+FleftCenter then continue;
    found := True;
    if Assigned(FOnBtnHint) then FOnBtnHint(btn.FID);
    RepaintPreviouslyActiveButtons(btn,False);

    if pressedButton<>nil then
      if pressedButton<>btn then break;   // if a button has been pressed then redraw only his state and 'freeze' others

    if btn.FState=MPBtnDown then
    begin
      if ((btn.FID=MPBtnPrev) and (FSeekTickTimer.Enabled)) then
          bitBlt(Canvas.handle,
                 FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FRewindDownCopyRect.Right,FRewindDownCopyRect.Bottom,
                 FSourceBitmap.Canvas.handle,FRewindDownCopyRect.Left,FRewindDownCopyRect.top,SRCCopy)
      else
      if ((btn.FID=MPBtnNext) and (FSeekTickTimer.Enabled)) then
          bitBlt(Canvas.handle,
                 FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FFastForwardDownCopyRect.Right,FFastForwardDownCopyRect.Bottom,
                 FSourceBitmap.Canvas.handle,FFastForwardDownCopyRect.Left,FFastForwardDownCopyRect.top,SRCCopy)
      else
        bitBlt(Canvas.handle,
               FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FDownCopyRect.Right,btn.FDownCopyRect.Bottom,
               FSourceBitmap.Canvas.handle,btn.FDownCopyRect.Left,btn.FDownCopyRect.top,SRCCopy);
    end
    else
    begin
      btn.FState := MPBtnHover;
      bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
        btn.FPaintOffset.Y, btn.FHoverCopyRect.Right, btn.FHoverCopyRect.Bottom,
        FSourceBitmap.Canvas.handle, btn.FHoverCopyRect.Left,
        btn.FHoverCopyRect.top, SRCCopy);
    end;
    Exit;
  end;

  if not found then
  begin
    RepaintPreviouslyActiveButtons(nil);
    if Assigned(FOnBtnHint) then FOnBtnHint(MPBtnNone);
  end;
end;


procedure TMPlayerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);   // mouse clicked over control, perform drawing and eventually start FSeekTimer
var
  i: Integer;
  btn: TMPlayerButton;
  found, SeekButton: Boolean;
  dummy: TMouseButton;
begin
  if (x>FSourceBitmap.Width+7) and (y>5) and (y<28) then
  begin
    self.cursor := crDefault;

    if ((x<=FSourceBitmap.Width+7+FMaxWidthCaption+4) and (Length(FCaption)>0)) then
      if Assigned(FOnCaptionClick) then FOnCaptionClick(self);

    if ((x>=FSourceBitmap.Width+7+FPosUrl) and
       (Length(FUrlCaption)>0) and
       (x<=FSourceBitmap.Width+7+FPosUrl+FSizeUrlCaption) and
       (Length(FUrl)>0) and
       (Assigned(FOnUrlClick))) then
    begin
      self.cursor := crHandpoint;
      FOnUrlClick(self,FUrl,dummy);
    end;

    Exit;
  end;

  found := False;
  SeekButton := False;

  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];
    if x<btn.FHitRect.Left+FleftCenter then continue;
    if y<btn.FHitRect.Top then continue;
    if y>btn.FHitRect.Bottom then continue;
    if x>btn.FHitRect.Right+FleftCenter then continue;
    found := True;
    RepaintPreviouslyActiveButtons(btn);
    btn.FState := MPBtnDown;  // set state
    bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
      btn.FPaintOffset.Y, btn.FDownCopyRect.Right, btn.FDownCopyRect.Bottom,
      FSourceBitmap.Canvas.handle, btn.FDownCopyRect.Left,
      btn.FDownCopyRect.top, SRCCopy);

    if ((btn.FID=MPBtnPrev) or (btn.FID=MPBtnNext)) then
    begin
      SeekButton := True;
      if ((not FSeekTickTimer.Enabled) and (not FSeekTimer.Enabled)) then
      begin
        FSeekTickTimer.Enabled := False;
        FSeekTimer.Enabled := False;
        FSeekTimer.Enabled := True;
      end;
    end;

    Exit;
  end;

  if not found then
  begin
    FSeekTickTimer.Enabled := False;
    FSeekTimer.Enabled := False;
    RepaintPreviouslyActiveButtons(nil);
  end
  else
  if not SeekButton then
  begin
    FSeekTickTimer.Enabled := False;
    FSeekTimer.Enabled := False;
  end;

end;

procedure TMPlayerPanel.MouseUP(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  btn: TMPlayerButton;
  found, wasDown: Boolean;
  seekEnabled, seekInProgress: Boolean;
begin
  found := False;
  seekEnabled := FSeekTimer.Enabled;
  seekInProgress := FSeekTickTimer.Enabled;
  FSeekTickTimer.Enabled := False;
  FSeekTimer.Enabled := False;

  for i := 0 to high(FButtons) do
  begin
    btn := FButtons[i];
    if x<btn.FHitRect.Left+FleftCenter then continue;
    if y<btn.FHitRect.Top then continue;
    if y>btn.FHitRect.Bottom then continue;
    if x>btn.FHitRect.Right+FleftCenter then continue;

    found := True;
    wasDown := (btn.FState=MPBtnDown);
    RepaintPreviouslyActiveButtons(btn,true,true);

    btn.FState := MPBtnHover;
    bitBlt(Canvas.handle, FleftCenter + 1 + btn.FPaintOffset.x,
      btn.FPaintOffset.Y, btn.FHoverCopyRect.Right, btn.FHoverCopyRect.Bottom,
      FSourceBitmap.Canvas.handle, btn.FHoverCopyRect.Left,
      btn.FHoverCopyRect.top, SRCCopy);

      if Assigned(FOnClick) then
      begin
        if seekEnabled then
        begin // if release of mouse button happens within first second then it's a playlist event
          if btn.FID=MPBtnPrev then
            FOnClick(MPBtnPrev)
          else
            FOnClick(MPBtnNext);

          Exit;
        end
        else
        if seekInProgress then
          Exit;

        if wasDown then FOnClick(btn.FID); // just call btn event
      end;
     Exit;
  end;

  if not found then
    RepaintPreviouslyActiveButtons(nil,true,true);
end;

procedure TMPlayerPanel.CMMouseLeave(var Msg: TMessage);
begin
  FSeekTickTimer.Enabled := False;
  FSeekTimer.Enabled := False;
  RepaintPreviouslyActiveButtons(nil, False);
end;

procedure TMPlayerPanel.WMUser(Var msg: TMessage);
begin
  RepaintPreviouslyActiveButtons(nil, true, true);
end;

procedure TMPlayerPanel.RepaintPreviouslyActiveButtons(ExceptButton: TMPlayerButton;
  SetState: Boolean = True; RemoveDown: Boolean = False);
var
  i: Integer;
  tmpBtn: TMPlayerButton;
begin
  // now invalidate all other 'inactive buttons'
  for i := 0 to high(FButtons) do
  begin
    tmpBtn := FButtons[i];

    if (ExceptButton<>nil) and (tmpBtn=ExceptButton) then
      continue;

    if tmpBtn.FState<>MPBtnOff then
    begin
      if SetState and (tmpBtn.FState=MPBtnHover) then
        tmpBtn.FState := MPBtnOff;

      if RemoveDown and (tmpBtn.FState=MPBtnDown) then
        tmpBtn.FState := MPBtnOff;

      bitBlt(Canvas.handle, FleftCenter + 1 + tmpBtn.FPaintOffset.x,
        tmpBtn.FPaintOffset.Y, tmpBtn.FOffCopyRect.Right,
        tmpBtn.FOffCopyRect.Bottom, FSourceBitmap.Canvas.handle,
        tmpBtn.FOffCopyRect.Left, tmpBtn.FOffCopyRect.top,SRCCopy);
    end;
  end;
end;

procedure TMPlayerPanel.Paint;
var
  TempBitmap: Graphics.TBitmap;
  backBitmap: Graphics.TBitmap;
begin
  if not FLoaded then
  begin
    inherited;
    Exit;
  end;

  backBitmap := Graphics.TBitmap.create;
  try
    backBitmap.PixelFormat := pf24bit;
    backBitmap.Width := clientWidth;
    backBitmap.Height := ClientHeight;
    backBitmap.Canvas.Brush.Style := bsSolid;

    //FleftCenter := (clientwidth div 2)-((FSourceBitmap.Width-2) div 2);

    FLeftCenter := 0;

    TempBitmap := Graphics.TBitmap.create;
    try
      TempBitmap.PixelFormat := pf24bit;
      TempBitmap.Width := 1;
      TempBitmap.Height := ClientHeight; //51;

      bitBlt(TempBitmap.Canvas.Handle,0,0,TempBitmap.Width,TempBitmap.Height,
             FSourceBitmap.Canvas.Handle,0,0,SRCCopy);
      backBitmap.Canvas.draw(FleftCenter,0,FSourceBitmap);
      backBitmap.Canvas.StretchDraw(rect(FleftCenter+FSourceBitmap.Width,0,clientwidth,ClientHeight),TempBitmap);
    finally
      TempBitmap.Free;
    end;

    InvalidateCaptions(backBitmap.Canvas);

    DrawButtons(backBitmap.Canvas);

    BitBlt(Canvas.handle,0,0,clientWidth,ClientHeight,
         backBitmap.Canvas.handle,0,0,SRCCOPY);
  finally
    backBitmap.Free;
  end;
end;

procedure TMPlayerPanel.InvalidateCaptions(ACanvas: TCanvas = nil);
var
  TempBitmap: Graphics.TBitmap;
  wi,he,lex,topy: Integer;
  cliRect: TRect;
begin
  TempBitmap := nil;

  if ACanvas=nil then
  begin
    wi := (clientwidth-1)-(FSourceBitmap.Width+2);
    he := (ClientHeight-5)-3;

    TempBitmap := Graphics.TBitmap.create;
    TempBitmap.PixelFormat := pf24bit;

    TempBitmap.Width := wi;
    TempBitmap.Height := he;

    ACanvas := TempBitmap.Canvas;
    lex := 0;
    topy := 0;
  end
  else
  begin
    wi := (clientwidth-3);
    he := (ClientHeight-5);
    lex := FSourceBitmap.Width;
    topy := 3;
  end;

  ACanvas.brush.Color := $00323232;
  ACanvas.fillrect(rect(lex,topy,Wi,He));

  clirect := rect(lex+1,topy+1,wi-1,he-1);

  ACanvas.brush.Color := clBlack;
  ACanvas.fillrect(clirect);

  Inc(cliRect.Left,7);
  Dec(cliRect.Right,7);
  RecalcPositions(cliRect,ACanvas);

  //DrawCaptionBackGround(doCaption,doUrlCaption,DoTimeCaption);
  // if doCaption then
  InvalidateCaption(cliRect,ACanvas);
  //if dourlCaption then
  InvalidateUrlCaption(cliRect,ACanvas);
  //if DoTimeCaption then
  InvalidateTimeCaption(cliRect,ACanvas);

  if TempBitmap<>nil then
  begin
    BitBlt(self.Canvas.Handle,FSourceBitmap.Width,3,wi,he,
          ACanvas.handle,0,0,SRCCopy);
    TempBitmap.Free;
  end;
end;

procedure TMPlayerPanel.InvalidateCaption(clRect: TRect; ACanvas: TCanvas);
var
  rc: TRect;
begin
  if not FLoaded then Exit;

  if Length(FCaption)=0 then Exit;

  ACanvas.Font.Name := 'Tahoma';
  ACanvas.Font.Size := 8;
  ACanvas.Font.Style := [];
  ACanvas.Font.Color := clSilver;

   rc.Left := clRect.Left;
   if clRect.Left+FMaxWidthCaption>clRect.Right then rc.Right := clRect.Right
    else rc.Right := clRect.Left+FMaxWidthCaption;
   rc.top := clRect.top;
   rc.Bottom := clRect.Bottom;

  SetBkMode(ACanvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(ACanvas.Handle, clRect.Left, clRect.top+4, ETO_CLIPPED, @Rc, PwideChar(FCaption),Length(FCaption), nil);
end;

procedure TMPlayerPanel.InvalidateUrlCaption(clRect: TRect; ACanvas: TCanvas);
var
  rc: TRect;
begin
  if not FLoaded then Exit;

  if ((Length(FUrlCaption)=0) or (Length(FUrl)=0)) then Exit;

  ACanvas.Font.Name := 'Tahoma';
  ACanvas.Font.Size := 8;
  ACanvas.Font.Style := [fsUnderline];
  ACanvas.Font.Color := clSilver;


  rc.Left := clRect.Left+FposUrl;
  if clRect.Left+FposUrl+FSizeUrlCaption>clRect.Right then
    rc.Right := clRect.Right
  else
    rc.Right := clRect.Left+FposUrl+FSizeUrlCaption;
  rc.top := clRect.top;
  rc.Bottom := clRect.Bottom;

  SetBkMode(ACanvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(ACanvas.Handle, clRect.Left+FposUrl, clRect.top+4, ETO_CLIPPED, @Rc, PwideChar(FUrlCaption),Length(FUrlCaption), nil);
end;

procedure TMPlayerPanel.InvalidateTimeCaption(clRect: TRect; ACanvas: TCanvas);
var
  rc: TRect;
begin
  if not FLoaded then Exit;

  if Length(FTimeCaption)=0 then Exit;

  ACanvas.Font.Name := 'Tahoma';
  ACanvas.Font.Size := 8;
  ACanvas.Font.Style := [];
  ACanvas.Font.Color := clSilver; //$00f0f0f0;


  rc.Left := clRect.Left+FposTimeCaption;
  rc.Right := clRect.Right;
  rc.Top := clRect.top;
  rc.Bottom := clRect.Bottom;

  SetBkMode(ACanvas.Handle, TRANSPARENT);
  Windows.ExtTextOut(ACanvas.Handle, clRect.Left+FposTimeCaption, clRect.top+4, ETO_CLIPPED, @Rc, PChar(FTimeCaption),Length(FTimeCaption), nil);
end;

procedure TMPlayerPanel.RecalcPositions(clRect: TRect; ACanvas: TCanvas);
var
  Size: TSize;
  FSizeTimeCaption: Integer;
begin
  if not FLoaded then Exit;

  ACanvas.Font.Name := 'Tahoma';
  ACanvas.Font.Size := 8;
  ACanvas.Font.Style := [];

  // get Width of caption
  if Length(FCaption)>0 then
  begin
    Size.cX := 0;
    Size.cY := 0;
    Windows.GetTextExtentPointW(ACanvas.handle, PWideChar(FCaption), Length(FCaption), Size);
    FMaxWidthCaption := Size.cx+10;
  end
  else
    FMaxWidthCaption := 0;

  FLastposTimeCaption := FposTimeCaption;
  if Length(FTimeCaption)>0 then
  begin
    Size.cX := 0;
    Size.cY := 0;
    Windows.GetTextExtentPoint(ACanvas.handle, PChar(FTimeCaption), Length(FTimeCaption), Size);
    FposTimeCaption := ((clRect.Right-clRect.Left)-3)-size.cx;
    FSizeTimeCaption := Size.cx;
  end
  else
  begin
    FPosTimeCaption := 0;
    FSizeTimeCaption := 0;
  end;

  if ((Length(FUrlCaption)>0) and (Length(FUrl)>0)) then
  begin
    ACanvas.Font.Style := [fsUnderline];
    Size.cX := 0;
    Size.cY := 0;
    Windows.GetTextExtentPointW(ACanvas.handle, PwideChar(FUrlCaption), Length(FUrlCaption), Size);
    if FposTimeCaption>0 then
      FposUrl := (FposTimeCaption-3)-size.cx
    else
      FPosUrl := ((clRect.Right-clRect.Left)-3)-size.cx;
    FSizeUrlCaption := Size.cx;
    if (clRect.Right-clRect.Left)<FPosUrl+FSizeUrlCaption then
      FSizeUrlCaption := (clRect.Right-clRect.Left)-FPosUrl; // windows is too small to show UrlCaption, resize accordingly
  end
  else
  begin
    FSizeUrlCaption := 0;
    FPosUrl := 0;
  end;

  if ((FmaxWidthCaption+5>FPosUrl) and (FPosUrl>0)) then FMaxWidthCaption := FPosUrl-5; // caption overlapping URL
  if ((FMaxWidthCaption+5>FposTimeCaption) and (FPosTimeCaption>0)) then FMaxWidthCaption := FposTimeCaption-5; // caption overlapping Timecaption
  if (clRect.Right-clRect.Left)<5+FMaxWidthCaption+5+FSizeUrlCaption+5+FSizeTimeCaption then FMaxWidthCaption := ((clRect.Right-clRect.Left)-15)-(FSizeUrlCaption+FSizeTimeCaption);

  if FPosUrl > FMaxWidthCaption + 5 then
    FPosUrl := FMaxWidthCaption+5; // keep Url close to caption
  if FPosUrl < 5 then
    FPosUrl := 5;

  if (FPosUrl>0) and (Length(FUrl)>0) and (Length(FUrlCaption)>0) and (FPosTimeCaption<FPosUrl+FSizeUrlCaption) then
    FPosTimeCaption := FPosUrl+FSizeUrlCaption+5;
end;


procedure Register;
begin
  RegisterComponents('Comet', [TMPlayerPanel]);
end;

end.
