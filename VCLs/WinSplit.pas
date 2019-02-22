{*******************************************************************************
    TWinSplit
    Copyright © Bill Menees
    bmenees@usit.net
    http://www.public.usit.net/bmenees

    This is a window splitting component similar to the one used in the Win95
    Explorer.  To use it, you must assign a control to the TargetControl
    property.  This sets the Cursor property, and a bunch of private properties
    including the Align property.

    The TargetControl is the control that gets resized at the end of the window
    "split" operation.  Thus, TargetControl must have an alignment in [alLeft,
    alRight, alTop, alBottom].

    The other useful properties introduced are MinTargetSize and MaxTargetSize.
    These determine how small or large the Width or Height of the TargetControl
    can be.  If MaxTargetSize = 0 then no maximum size is enforced.

    Note 1: Even though TWinSplit is decended from TCustomPanel, don't think of
    it as a panel.  I only published the panel properties useful to TWinSplit
    and none of the panel events.  I even made it where it won't act as the
    container for controls placed on it at design time.

    Note 2: Some drawing code is from Borland's Resource Explorer example.

*******************************************************************************}
unit WinSplit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TWinSplitOrientation = (wsVertical, wsHorizontal);
  TWinSplit = class(TPanel)
  private
    FOrientation: TWinSplitOrientation;
    FSizing: Boolean;
    FDelta: TPoint;
    FOnEndSplit: TNotifyEvent;
    FYPos, FXPos: Integer;
    FPriorMode: TPenMode;
    FTop, FLeft: Integer;
    FShouldAnimate: Boolean;
  private
    procedure DrawSizingLine;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure GradientRect(col1, col2: TColor);

    {This is here so we can update the TargetControl
    property if the target component is removed.}
    procedure Setorientation(Value: TWinSplitOrientation);

    procedure BeginSizing; virtual;
    procedure ChangeSizing(X, Y: Integer); virtual;
    procedure EndSizing; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property orientation: TWinSplitOrientation read FOrientation write setorientation;
    property Visible;
    property sizing: Boolean read FSizing write FSizing;
    property OnEndSplit: TNotifyEvent read FOnEndSplit write FOnEndSplit;
    property xpos: Integer read FXPos write FXPos;
    property ypos: Integer read FYPos write FYPos;
    property componentTop: Integer read FTop write FTop;
    property componentLefT: Integer read FLeft write FLeft;
  end;

procedure Register;

implementation

{$R WinSplit.res}

{******************************************************************************}
{** Non-Member Functions ******************************************************}
{******************************************************************************}

procedure Register;
begin
  RegisterComponents('Comet', [TWinSplit]);
end;



function CToC(C1, C2: TControl; P: TPoint): TPoint;
begin
  Result := C1.ScreenToClient(C2.ClientToScreen(P));
end;

{******************************************************************************}
{** TWinSplit Public Methods **************************************************}
{******************************************************************************}

constructor TWinSplit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := wshorizontal;
  FDelta := Point(0,0);
  FSizing := False;
  Caption := '';
  TabStop := False;
  Height := 100;
  Width := 3;
  xpos := 0;
  ypos := 0;
  FShouldAnimate := true;
  FLeft := 0;
  FTop := 0;
end;

procedure TWinSplit.Paint;
begin
  canvas.lock;
  canvas.pen.color := color;
  canvas.brush.color := color;
  canvas.rectangle(0,0,width,height);
  canvas.unlock;
end;

{******************************************************************************}
{** TWinSplit Protected Methods ***********************************************}
{******************************************************************************}

procedure TWinSplit.BeginSizing;
var
  ParentForm: TcustomForm;
begin
  ParentForm := GetParentForm(Self);
  if ParentForm <> nil then
  begin
    if ((FOrientation = wsVertical) or
        (FOrientation = wsHorizontal)) then
    begin
      FSizing := True;
      SetCaptureControl(Self);

      if FOrientation=wsVertical then
        FDelta := Point(0, Top)
      else
        FDelta := Point(Left, 0);

      ParentForm.Canvas.Handle := GetDCEx(ParentForm.Handle, 0, DCX_CACHE or DCX_NORESETATTRS or DCX_CLIPSIBLINGS or DCX_LOCKWINDOWUPDATE);

      ParentForm.Canvas.Pen.Width := 2;
      ParentForm.Canvas.Pen.Color := clwhite;

      FPriorMode := ParentForm.Canvas.pen.mode;
      ParentForm.Canvas.pen.mode := pmXor;

      DrawSizingLine;
    end;
  end;
end;

procedure TWinSplit.ChangeSizing(X, Y: Integer);
var
  OldfDelta: TPoint;
begin
  if Sizing then
  begin
    DrawSizingLine;
    OldfDelta := FDelta;
    if FOrientation=wsVertical then
      FDelta.Y := Y
    else
      FDelta.X := X;
    DrawSizingLine;
  end;
end;

procedure TWinSplit.EndSizing;
var
  ParentForm: TcustomForm;
begin
  ParentForm := GetParentForm(Self);
  FSizing := False;

  DrawSizingLine;
  releasecapture;

  if ParentForm <> nil then
  begin
    with ParentForm do
    begin
      ReleaseDC(ParentForm.Handle, ParentForm.canvas.Handle);
      ParentForm.canvas.pen.mode := FPriorMode;
    end;
  end;

  FDelta := Point(0,0);
end;

procedure TWinSplit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ParentForm: TcustomForm;
begin
  ParentForm := GetParentForm(Self);
  if ParentForm<>nil then
  begin
    if Sizing then ChangeSizing(X, Y);
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TWinSplit.CMMouseEnter(var Msg: TMessage);
begin
  if FShouldAnimate then
  begin
    FShouldAnimate := false;
    GradientRect(color,0);
  end;
end;

procedure TWinSplit.CMMouseLeave(var Msg: TMessage);
begin
  if not FShouldAnimate then
  begin
    FShouldAnimate := true;
    GradientRect(0,color);
  end;
end;


procedure TWinSplit.GradientRect(col1, col2: TColor);
var
  Max, RC, GC, BC, R : byte;
  RStep, GStep, BStep : Real;
  Red, Green, Blue, Red1, Green1, Blue1, Red2, Green2, Blue2 : byte;
  app: TApplication;
begin
  app := TApplication.create(nil);

  max := 30;

  { The GetRValue macro retrieves an intensity value for
  the Red component of a 32-bit red, green, blue (RGB) value. }
  Red1 := GetRValue(Col1);
  Green1 := GetGValue(Col1);
  Blue1 := GetBValue(Col1);

  Red2 := GetRValue(Col2);
  Green2 := GetGValue(Col2);
  Blue2 := GetBValue(Col2);

  Red := Red1;
  Green := Green1;
  Blue := Blue1;

  if red1>red2 then
    RStep := (Red1-Red2)/Max
  else
    RStep := (Red2-Red1)/Max;
  if green1>Green2 then
    GStep := (Green1-Green2)/Max
  else
    GStep := (Green2-Green1)/Max;
  if Blue1>Blue2 then
    BStep := (Blue1-Blue2)/Max
  else
    BStep := (Blue2-Blue1)/Max;

  RC := Red1;
  GC := Green1;
  BC := Blue1;

  canvas.lock;

  for R := 0 To Max do
  begin
    Canvas.brush.Color := RGB(RC,GC,BC);

    if FOrientation=wsHorizontal then
      canvas.fillrect(rect(width div 2,0,(width div 2)+1,height))
    else
      canvas.fillrect(rect(0,height div 2,width,(height div 2)+1));

    if red1>red2 then
      RC := Round(Red-R*RStep)
    else
      RC := Round(Red+R*RStep);
    if green1>Green2 then
      GC := Round(Green-R*GStep)
    else
      GC := Round(Green+R*GStep);
    if Blue1>Blue2 then
      BC := Round(Blue-R*BStep)
    else
      BC := Round(Blue+R*BStep);

    app.processMessages;
    sleep(10);
  end;

  Canvas.brush.Color := col2;

  if FOrientation=wsHorizontal then
    canvas.fillrect(rect(width div 2,0,(width div 2)+1,height))
  else
    canvas.fillrect(rect(0,height div 2,width,(height div 2)+1));

  canvas.Unlock;

  app.destroy;
end;


procedure TWinSplit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Sizing then
  begin
    xpos := x;
    ypos := y;
    EndSizing;
    Paint;
  end;

  inherited MouseUp(Button, Shift, X, Y);

  if Assigned(FOnEndSplit) then
    FOnEndSplit(Self);
end;

procedure TWinSplit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and (Shift = [ssLeft]) then BeginSizing;
end;

{******************************************************************************}
{** TWinSplit Private Methods *************************************************}
{******************************************************************************}

procedure TWinSplit.DrawSizingLine;
var
  P: TPoint;
  ParentForm: TcustomForm;
begin
  ParentForm := GetParentForm(Self);
  if ParentForm<>nil then
  begin

    P := CToC(ParentForm, Self, FDelta);
    with ParentForm.Canvas do
    begin
      if ((p.x>=0) and (p.y>=0) and (p.x<=ParentForm.width) and (p.y<=parentForm.height)) then
      begin
        if FOrientation=wsHorizontal then
         begin
          ParentForm.Canvas.MoveTo(P.X,P.Y);
          ParentForm.Canvas.LineTo(P.X, FTop+top+height);
        end
        else
        begin
          ParentForm.Canvas.MoveTo(P.X, p.y);
          ParentForm.Canvas.LineTo(FLeft+left+width, p.y);
        end;
      end;
    end;
  end;
end;

procedure TWinSplit.Setorientation(Value: TWinSplitOrientation);
begin
  if value<>FOrientation then
  begin
    FOrientation := value;
    if value=wsVertical then
      Cursor := crsizeNS
    else
      Cursor := crsizeWE;
    Invalidate;
  end;
end;

end.
