{
 this file is part of Ares
 Copyright (C)2005 Aresgalaxy ( http://aresgalaxy.sourceforge.org )

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
Ares media player trackbar
}

unit CometTrack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, ExtCtrls;

type
  TCometTrack = class(TPanel)
  private
    FLoaded: Boolean;
    FOnChanged: TNotifyEvent;
    FPosition, FMax: Integer;
    FOver, FDown: Boolean;
    FTrackBarEnabled: Boolean;
    FSourceBitmap: Graphics.TBitmap;
    FBackGroundBitmap: Graphics.TBitmap;
    procedure SetTrackbarEnabled(Value: Boolean);

    procedure SetPosition(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;

    procedure WMEraseBkgnd(Var Msg: TMessage); message WM_ERASEBKGND;
    procedure DrawTrackBar;
    procedure SetSourceBitmap(Value: Graphics.TBitmap);
  protected
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
  published
    property SourceBitmap: Graphics.TBitmap read FSourceBitmap write SetSourceBitmap;
    property Max: Integer read FMax write SetMax;
    property Position: Integer read FPosition write SetPosition;
    property TrackBarEnabled: Boolean read FTrackbarEnabled write SetTrackbarEnabled;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

procedure Register;

implementation

{$R bmptrackbar.res}

constructor TCometTrack.create;
begin
  inherited Create(AOwner);
   parent := (AOwner as TWInControl);

  FLoaded := False;
  FSourceBitmap := nil;

  FBackGroundBitmap := Graphics.TBitmap.create;
   FBackGroundBitmap.pixelFormat := pf24Bit;
   FBackGroundBitmap.width := clientwidth;
   FBackGroundBitmap.height := clientheight;

  FOnChanged := nil;

  FSourceBitmap := Graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BITMAPTRACKBAR');

  FOver := False;
  FDown := False;
  FMax := 1000;
  FPosition := 0;


  BevelOuter := bvNone;
  height := 11;

  FTrackbarEnabled := True;

end;

destructor TCometTrack.destroy;
begin
  FBackGroundBitmap.Free;

  FSourceBitmap.Free;

  inherited;
end;

procedure TCometTrack.SetSourceBitmap(Value:Graphics.TBitmap);
begin
  if Value=nil then
  begin   // use internal bitmap
    if FSourceBitmap<>nil then
      FSourceBitmap.Free;
    FSourceBitmap := Graphics.TBitmap.create;
    FSourceBitmap.LoadFromResourceName(hinstance,'BITMAPTRACKBAR');
  end
  else
  begin      // use external bitmap
    if FSourceBitmap<>nil then FSourceBitmap.Free;
    FSourceBitmap := Value;
  end;
end;

procedure TCometTrack.Loaded;
begin
  FLoaded := True;
end;

procedure TCometTrack.SetTrackbarEnabled(Value: Boolean);
begin
  FTrackbarEnabled := Value;
  if not FLoaded then Exit;
  Invalidate;
end;


procedure TCometTrack.DrawTrackBar;
var
  rc: TRect;
  LeftProgress: Int64;
  TempBitmap: Graphics.TBitmap;
begin
  if not FLoaded then Exit;

  TempBitmap := Graphics.TBitmap.create;
  try
    TempBitmap.pixelFormat := pf24Bit;
    TempBitmap.width := 1;
    TempBitmap.height := 10;


    BitBlt(TempBitmap.Canvas.handle,0,0,TempBitmap.width,TempBitmap.height,
      FSourceBitmap.Canvas.handle,0,22,SRCCOPY);

    FBackGroundBitmap.Canvas.stretchDraw(rect(0,0,clientwidth,10),TempBitmap);
  finally
    TempBitmap.Free;
  end;


  BitBlt(FBackGroundBitmap.Canvas.handle,0,3,7,5,
    FSourceBitmap.Canvas.handle,9,18,SRCCopy);
  BitBlt(FBackGroundBitmap.Canvas.handle,clientwidth-7,3,7,5,
    FSourceBitmap.Canvas.handle,9,24,SRCCopy);

  if not FTrackbarEnabled then
    Exit;

  // draw progress 3 lines
  if FPosition>0 then
    LeftProgress := 5+((Int64(FPosition) * Int64(clientwidth-26)) div Int64(FMax))
  else
    LeftProgress := 5;

  FBackGroundBitmap.Canvas.brush.color := $00ffc584;
  rc.left := 5;
  rc.Top := 4;
  rc.bottom := 5;
  rc.Right := LeftProgress;
  FBackGroundBitmap.Canvas.FillRect(rc);

  FBackGroundBitmap.Canvas.brush.color := $00cd410f;
  rc.Top := 5;
  dec(rc.left);
  rc.bottom := 6;
  rc.Right := LeftProgress+1;
  FBackGroundBitmap.Canvas.FillRect(rc);

  FBackGroundBitmap.Canvas.brush.color := $00ff966e;
  rc.Top := 6;
  inc(rc.left);
  rc.bottom := 7;
  rc.Right := LeftProgress;
  FBackGroundBitmap.Canvas.FillRect(rc);

  if (FDown) or (Fover) then
  begin
    if FDown then
      BitBlt(FBackGroundBitmap.Canvas.Handle,LeftProgress, 1, 15, 8,
        FSourceBitmap.Canvas.handle, 1, 8, SRCCOPY)
    else
    if FOver then
      BitBlt(FBackGroundBitmap.Canvas.Handle,LeftProgress, 1, 15, 8,
        FSourceBitmap.Canvas.handle, 1, 0, SRCCOPY);
  end
  else
  begin
    BitBlt(FBackGroundBitmap.Canvas.Handle,LeftProgress, 4, 16, 3,
      FSourceBitmap.Canvas.handle, 1, 29, SRCCOPY);
  end;

end;


procedure TCometTrack.WMEraseBkgnd(var Msg: TMessage);  //no flicker!
begin
  Msg.Result := 1;
end;

procedure TCometTrack.SetPosition(Value: Integer);
var
  PreviousPosition: Integer;
begin
  if not FLoaded then
    Exit;

  if Value<0 then Value := 0;
  if Value>FMax then Value := FMax;
  PreviousPosition := FPosition;
  FPosition := Value;

  if PreviousPosition=FPosition then
    Exit;
  Invalidate;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TCometTrack.SetMax(Value: Integer);
begin
  if not FLoaded then Exit;

  if Value<=0 then Value := 1;
  FMax := Value;
  FPosition := 0;

  Invalidate;
end;

procedure TCometTrack.Paint;
begin
  if (csDesigning in componentState) then
  begin
    inherited;
    Exit;
  end;

  if not FLoaded then
    Exit;


  // clientheight := 31;
  FBackGroundBitmap.width := Self.clientwidth;
  FBackGroundBitmap.height := Self.clientheight;

  //DrawCaptions;
  DrawTrackBar;

  Canvas.lock;

  BitBlt(Canvas.handle,0,0,Self.clientwidth,Self.clientheight,
    FBackGroundBitmap.Canvas.handle,0,0,SRCCOPY);

  Canvas.Unlock;
end;

procedure TCometTrack.MouseDown(Button: TMouseButton; Shift: TShiftState;
X, Y: Integer);
var
  PreviousPosition: Integer;
  Dummy: TMouseButton;
begin
  if not FTrackbarEnabled then Exit;

  Self.Cursor := crHandpoint;

  FDown := True;
  PreviousPosition := FPosition;

  FPosition := (Int64(x-11)*Int64(Fmax)) div Int64(clientwidth-26); //Int64(x*Self.max) div (Self.width);
  if FPosition>FMax then
    FPosition := FMax;
  if FPosition<0 then
    FPosition := 0;
  Invalidate;

  if PreviousPosition=FPosition then
    Exit;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TCometTrack.MouseMove(Shift: TShiftState;X, Y: Integer);
var
  PreviousPosition: Cardinal;
begin
  if not FTrackbarEnabled then
  begin
    Self.Cursor := crDefault;
   Exit;
  end;

  Self.Cursor := crHandpoint;
  if not FDown then
    Exit;

  PreviousPosition := FPosition;

  Fposition := (Int64(x-11)*Int64(Fmax)) div Int64(clientwidth-26); //Int64(x*Self.max) div (Self.width);
  if FPosition>FMax then FPosition := FMax;
  if FPosition<0 then FPosition := 0;

  if PreviousPosition=FPosition then Exit;
  Invalidate;

  if Assigned(FOnChanged) then FOnChanged(Self);
end;

procedure TCometTrack.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDown := False;
  Invalidate;
end;

procedure TCometTrack.CMMouseEnter(var Msg: TMessage);
begin
  FOver := True;
  Invalidate;
end;

procedure TCometTrack.CMMouseLeave(var Msg: TMessage);
begin
  FOver := False;
  Invalidate;
end;


procedure Register;
begin
  RegisterComponents('Comet', [TCometTrack]);
end;


end.
