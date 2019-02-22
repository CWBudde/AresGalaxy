unit bgimPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,Themes;

type
  TTipoBitmap = (
    btmNone,
    btmPattern,
    btmStretch,
    btmNormal
  );
  TTipoGradiente = (
    TGNone,
    TGOriz,
    TGVert
  );

type
  THeaderBodyDrawEvent = procedure(Sender: TObject; TargetCanvas: TCanvas; aRect: TRect; HeaderColor: TColor) of object;
  TBackgroundDrawEvent = procedure(Sender: TObject; TargetCanvas: TCanvas; aRect: TRect; var ShouldContinue: Boolean) of object;
  TXPRoundDrawEvent = procedure(Sender: TObject; TargetCanvas: TCanvas; aRect: TRect; include_header: Boolean; var ShouldContinue: Boolean) of object;
  TOnAfterDrawEvent = procedure(Sender: TObject; TargetCanvas: TCanvas) of object;

  TBgImPanel = class(TPanel)
  private
    FAlignment: TAlignment;
    FTipoGradiente: TTipoGradiente;
    FColoreGradienteStart,FColoreGradienteEnd: TColor;
    FXPRoundCenter: Boolean;
    FXPRoundCenterHeader: Boolean;
    FXPRoundColor: TColor;
    FXPRoundWidth: Integer;
    FXPRoundHeight: Integer;
    FXPRoundLeft: Integer;
    FXPRoundTop: Integer;
    FDrawHeader: Boolean;
    FHeaderColor: TColor;
    FHeaderFont: TFont;
    FHeaderHeight: Integer;
    FHeaderCaption: WideString;
    FHeaderCaptionLeft: Integer;
    FHeaderCaptionTop: Integer;
    FWideCaption: WideString;
    FOwnerDraw: Boolean;
    FOnDrawHeaderBody: THeaderBodyDrawEvent;
    FOnDrawBackGround: TBackgroundDrawEvent;
    FOnXPDrawRound: TXPRoundDrawEvent;
    FOnAfterDraw: TOnAfterDrawEvent;
    procedure SetAlignment(Value: TAlignment);
    procedure draw_sfondo(ACanvas: TCanvas);
    procedure SetDrawHeader(Value: Boolean);
    procedure SetXPRoundCenterHeader(Value: Boolean);
    procedure SetHeaderColor(Value: TColor);
    procedure SetHeaderFont(Value: TFont);
    procedure SetHeaderHeight(Value: Integer);
    procedure SetHeaderCaption(Value: WideString);
    procedure SetWideCaption(Value: WideString);
    procedure HeaderDraw(ACanvas: TCanvas);
    procedure DrawHeaderBody(ACanvas: TCanvas);
    procedure SetTipoGradiente(Value: TTipoGradiente);
    procedure SetHeaderCaptionLeft(Value: Integer);
    procedure SetHeaderCaptionTop(Value: Integer);
    procedure SetColoreGradienteStart(Value: TColor);
    procedure SetColoreGradienteEnd(Value: TColor);
    procedure DrawXPRoundCenter(ACanvas: TCanvas);
    procedure SetXpRoundCenter(Value: Boolean);
    procedure SetXPRoundTop(Value: Integer);
    procedure SetXPRoundLeft(Value: Integer);
    procedure SetXPRoundWidth(Value: Integer);
    procedure SetXPRoundHeight(Value: Integer);
    procedure SetXPRoundColor(Value: TColor);
    procedure SetOwnerDraw(Value: Boolean);
    procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
  public
    constructor Create(AComponent: TComponent); override;
    procedure updateHeader;
    property canvas;
  published
    property HeaderCaption: WideString read FHeaderCaption write SetHeaderCaption;
    property WideCaption: WideString read FWideCaption write SetWideCaption;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property DrawHeader: Boolean read FDrawHeader write SetDrawHeader;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor;
    property HeaderCaptionLeft: Integer read FheaderCaptionLeft write SetHeaderCaptionLeft;
    property HeaderCaptionTop: Integer read FheaderCaptionTop write SetHeaderCaptionTop;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property tipo_gradiente: TTipoGradiente read FTipoGradiente write SetTipoGradiente;
    property ColoreGradienteStart: TColor read FColoreGradienteStart write SetColoreGradienteStart;
    property ColoreGradienteEnd: TColor read FColoreGradienteEnd write SetColoreGradienteEnd;
    property XPRoundCenter: Boolean read FXPRoundCenter write SetXPRoundCenter;
    property XPRoundTop: Integer read FXPRoundTop write SetXPRoundTop;
    property XPRoundLeft: Integer read FXPRoundLeft write SetXPRoundLeft;
    property XPRoundWidth: Integer read FXPRoundWidth write SetXPRoundWidth;
    property XPRoundHeight: Integer read FXPRoundHeight write SetXPRoundHeight;
    property XPRoundColor: TColor read FXPRoundColor write SetXPRoundColor;
    property IsOwnerDraw: Boolean read FOwnerDraw Write SetOwnerDraw;
    property XPRoundCenterHeader: Boolean read FXPRoundCenterHeader write SetXPRoundCenterHeader;
    property OnDrawHeaderBody: THeaderBodyDrawEvent read FOnDrawHeaderBody write FOnDrawHeaderBody;
    property OnDrawBackground: TBackGroundDrawEvent read FOnDrawBackGround write FOnDrawBackGround;
    property OnXPDrawRound: TXPRoundDrawEvent read FOnXPDrawRound write FOnXPDrawRound;
    property OnAfterDraw: TOnAfterDrawEvent read FOnAfterDraw write FOnAfterDraw;
  end;

procedure Register;

implementation

procedure TBgImPanel.WMEraseBkgnd(Var Msg : TMessage);
begin
  msg.result := 1;
end;

procedure TBgImPanel.SetHeaderCaptionLeft(Value: Integer);
begin
  FHeaderCaptionLeft := Value;
  HeaderDraw(canvas);
end;

procedure TBgImPanel.SetHeaderCaptionTop(Value: Integer);
begin
  FHeaderCaptionTop := Value;
  HeaderDraw(canvas);
end;

procedure TBgImPanel.SetXpRoundCenter(Value: Boolean);
begin
  FXPRoundCenter := Value;
  Invalidate;
end;

procedure TBgImPanel.SetXpRoundCenterHeader(Value: Boolean);
begin
  FXPRoundCenterHeader := Value;
  Invalidate;
end;

procedure TBgImPanel.SetXPRoundTop(Value: Integer);
begin
  FXPRoundTop := Value;
  Invalidate;
end;

procedure TBgImPanel.SetOwnerDraw(Value: Boolean);
var
  cst: TControlStyle;
begin
  FOwnerDraw := Value;
  cst := self.ControlStyle;
  if FOwnerDraw then
    Include(cst,CSOpaque)
  else
    EXclude(cst,CSOpaque);
  self.controlStyle := cst;

  Invalidate;
end;

procedure TBgImPanel.SetXPRoundLeft(Value: Integer);
begin
  FXPRoundLeft := Value;
  Invalidate;
end;

procedure TBgImPanel.SetXPRoundWidth(Value: Integer);
begin
  FXPRoundWidth := Value;
  Invalidate;
end;

procedure TBgImPanel.SetXPRoundHeight(Value: Integer);
begin
  FXPRoundHeight := Value;
  Invalidate;
end;

procedure TBgImPanel.SetXPRoundColor(Value: TColor);
begin
  FXPRoundColor := Value;
  Invalidate;
end;

procedure TBgImPanel.updateHeader;
begin
  DrawHeaderBody(canvas);
end;

procedure TBgImPanel.HeaderDraw(ACanvas: TCanvas);
var
  r: TRect;
begin
  DrawHeaderBody(ACanvas);
end;

procedure TBgImPanel.DrawHeaderBody(ACanvas: TCanvas);
var
  r: TRect;
  Details: TThemedElementDetails;
begin
  ACanvas.brush.color := color;
  ACanvas.pen.color := cl3ddkshadow;
  ACanvas.Rectangle(Rect(-1,-1,clientwidth,FHeaderHeight));

  r := Rect(0,0,clientwidth,FHeaderHeight);
  if Assigned(FonDrawHeaderBody) then
    FOnDrawHeaderBody(self,ACanvas,r,fheadercolor);

  ACanvas.font := FHeaderFont;
  r.left := FHeaderCaptionLeft+2;
  r.right := Width-2;
  r.top := FHeaderCaptionTop;
  r.bottom := FHeaderHeight;
  SetBkMode(ACanvas.Handle, TRANSPARENT);

  Windows.ExtTextOutW(ACanvas.Handle, 4, 4, 0, @R, PwideChar(FHeaderCaption),Length(FHeaderCaption), nil);
end;

procedure TBgImPanel.SetHeaderCaption(Value: WideString);
begin
  FHeaderCaption := Value;
  HeaderDraw(canvas);
end;

procedure TBgImPanel.SetWideCaption(Value: WideString);
begin
  FWideCaption := Value;
  Invalidate;
end;

procedure TBgImPanel.SetHeaderHeight(Value: Integer);
begin
  FHeaderHeight := Value;
  Invalidate;
end;

procedure TBgImPanel.SetHeaderFont(Value: TFont);
begin
  FHeaderFont := Value;
  Invalidate;
end;

procedure TBgImPanel.SetHeaderColor(Value: TColor);
begin
  FHeaderColor := Value;
  Invalidate;
end;

procedure TBgImPanel.SetDrawHeader(Value: Boolean);
begin
  FDrawHeader := Value;
  Invalidate;
end;

constructor TBgImPanel.Create(AComponent: TComponent);
//var cst: Tcontrolstyle;
begin
  inherited Create(AComponent);
  DoubleBuffered := True;

  FDrawHeader := False;
  FHeaderColor := color;
  FHeaderFont := font;
  FHeaderHeight := 20;
  FHeaderCaption := '';
  FHeaderCaptionTop := 2;
  FHeaderCaptionLeft := 2;

  ControlStyle := ControlStyle + [csOpaque];

  FOwnerDraw := False;
  FheaderFont := font;

  FTipoGradiente := TGNone;
  FColoreGradienteStart := $00F6F5F3;
  FColoreGradienteEnd := $00D6EAEE;

  FXPRoundCenter := False;
  FXPRoundCenterHeader := False;
  FXPRoundLeft := 10;
  FXPRoundTop := 10;
  FXPRoundWidth := Width-20;
  FXPRoundHeight := Height-20;
  FXPRoundColor := $00F7DFD6;
end;

procedure TBgImPanel.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TBgImPanel.DrawXPRoundCenter(ACanvas: TCanvas);
var
  OffsetY, i: Integer;
  Banda, rec: TRect;
  ShouldContinue: Boolean;
begin
  ShouldContinue := True;

  if Assigned(FOnXPDrawRound) then
  begin
    rec := Rect(FXPRoundLeft,FXPRoundTop,FXPRoundLeft+FXPRoundWidth,FXPRoundTop+FXPRoundHeight);
    FOnXPDrawRound(self,ACanvas,rec,FXPRoundCenterHeader,ShouldContinue);
  end;

  if not ShouldContinue then Exit;

  OffsetY := FXPRoundTop;

  ACanvas.Pen.color := clwhite;
  ACanvas.brush.color := FXPRoundColor;
  ACanvas.RoundRect(FXPRoundLeft,FXPRoundTop,FXPRoundLeft+FXPRoundWidth,FXPRoundTop+FXPRoundHeight,10,10);
end;

procedure TBgImPanel.Paint;
const
  Alignments: array [TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  i,j,k: Integer;
  x,y: Integer;
  r: TRect;
  FontHeight: Integer;
  flags: Integer;
begin
  if not FownerDraw then
  begin
    inherited Paint;
    Exit;
  end;

  inherited;
  if FDrawHeader then HeaderDraw(canvas);

  draw_sfondo(canvas);
  if FXpRoundCenter then DrawXPRoundCenter(canvas);

  if fwidecaption<>'' then
  begin
    Canvas.brush.style := bsclear;
    canvas.Font := Font;

    FontHeight := canvas.TextHeight('W');
    with R do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;

    Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[FAlignment];
    Flags := DrawTextBiDiModeFlags(Flags);

    r.Left := 0;
    r.top := 4;
    r.Right := Width;
    r.Bottom := Height;

    Windows.ExtTextOutW(canvas.Handle, 2, 3, 0, @R, PwideChar(FWideCaption),Length(FWideCaption), nil);
  end;

  if Assigned(FOnAfterDraw) then FOnAfterDraw(self,canvas);
end;

procedure TBgImPanel.SetTipoGradiente(Value: TTipoGradiente);
begin
  FTipoGradiente := Value;
  Invalidate;
end;

procedure TBgImPanel.SetColoreGradienteStart(Value: TColor);
begin
  FColoreGradienteStart := Value;
  Invalidate;
end;

procedure TBgImPanel.SetColoreGradienteEnd(Value: TColor);
begin
  FColoreGradienteEnd := Value;
  Invalidate;
end;

procedure TBgImPanel.draw_sfondo(ACanvas: TCanvas);    //qui riempiamo sfondo o disegniamo gradiente
var
  ShouldContinue: Boolean;
  r: TRect;
begin
  ShouldContinue := True;

  if Assigned(FOnDrawBackGround) then
  begin  //se non ho XP torno con ShouldContinue := True
    r := Rect(0,FHeaderHeight,Width,Height);
    FOnDrawBackGround(self,ACanvas,r,ShouldContinue);
  end;

  if not ShouldContinue then
    Exit;

  ACanvas.brush.color := color;
  ACanvas.pen.color := color;
  if FDrawHeader then
    ACanvas.Rectangle(0,FHeaderHeight{-1},Width,Height)
  else
    ACanvas.Rectangle(0,0,Width,Height);
end;

procedure Register;
begin
  RegisterComponents('Comet', [TBgImPanel]);
end;

end.
