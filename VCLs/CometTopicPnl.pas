unit CometTopicPnl;

interface

uses
  Windows, Graphics, ExtCtrls, Classes, Controls, Messages, Forms;

type
  TCmtPaintEvent = procedure(Sender: TObject; Acanvas: TCanvas; capt: WideString; var ShouldContinue: Boolean) of object;
  TCmtUrlClickEvent = procedure(Sender: TObject; const URLText: String; Button: TMouseButton) of object;

  TCometTopicPnl = class(TPanel)
  protected
    FCaptTop: Integer;
    FCapt: WideString;
    FCaptLeft: Integer;
    FOnPaint: TCmtPaintEvent;
    procedure invalidate_caption;
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure paint; override;
    procedure SetCapt(value: WideString);
  public
    constructor Create(AComponent: TComponent); override;
  published
    property Capt: WideString read FCapt write setcapt;
    property Canvas;
    property OnPaint: TCmtPaintEvent read FOnPaint write FOnPaint;
    property CaptionLeft: Integer read FCaptLeft write FCaptLeft default 0;
    property CaptTop: Integer read FCaptTop write FCaptTop;
  end;

  TCometPlayerPanel = class(TCometTopicPnl)
  protected
    FUrl: string;
    FUrlCaption: WideString;
    FOnUrlClick: TCmtUrlClickEvent;
    FUrlPosx, FUrlWidth, FUrlheight: Integer;
    procedure paint; override;
    procedure SetUrl(const valueUrl: string);
    procedure SetCaptionUrl(const valueCaption: WideString);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    procedure Invalidate_url;
  published
    property url: string read FUrl write SetUrl;
    property captionurl: WideString read FUrlCaption write SetCaptionUrl;
    property OnUrlClick: TCmtUrlClickEvent read FOnUrlClick write FOnUrlClick;
  end;

procedure Register;

implementation

////////// TCometPlayerPanel
procedure TCometPlayerPanel.paint;
begin
  inherited paint;

  if ((length(FUrl)>0) and (length(FUrlCaption)>0)) then
    Invalidate_url;
end;

procedure TCometPlayerPanel.SetUrl(const valueUrl: string);
begin
  FUrl := valueUrl;

  if length(FUrl)=0 then
  begin
   FUrlPosx := 0;
   FUrlWidth := 0;
  end;

  Invalidate;
end;

procedure TCometPlayerPanel.SetCaptionUrl(const valueCaption: WideString);
begin
  FUrlCaption := valueCaption;
  Invalidate;
end;

procedure TCometPlayerPanel.Invalidate_url;
var
  r: TRect;
  Size: TSize;
begin
  Canvas.Font.Name := Font.Name;
  Canvas.Font.Size := Font.Size;
  Canvas.Font.Style := Font.Style;
  Canvas.Font.Color := Font.Color;
  Size.cX := 0;
  Size.cY := 0;
  Windows.GetTextExtentPointW(Canvas.Handle, PWideChar(FCapt), Length(FCapt), Size);

  FUrlPosx := Size.cx+CaptionLeft+10;

  Canvas.Font.Style := [fsUnderline];
  Canvas.Font.Color := clblue;
  Size.cX := 0;
  Size.cY := 0;
  Windows.GetTextExtentPointW(Canvas.Handle, PWideChar(furlCaption), Length(furlCaption), Size);

  FUrlWidth := Size.cx;
  FUrlheight := Size.cy;

  r.left := FUrlPosx;
  r.right := clientwidth-3;
  r.top := 0;
  r.bottom := clientHeight;
  Windows.ExtTextOutW(Canvas.Handle, FUrlPosx, FCaptTop, ETO_CLIPPED, @R,
    PWideChar(FUrlCaption),Length(FUrlCaption), nil);
end;

procedure TCometPlayerPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if ((x>=FUrlPosx) and
    (x<=FUrlPosx+FUrlWidth) and
    (y>=FCaptTop) and
    (y<=FCaptTop+FUrlheight)) then cursor := crHandpoint
     else cursor := crDefault;

  inherited;
end;

procedure TCometPlayerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Btn: TMouseButton;
begin
  if not assigned(FOnUrlClick) then
  begin
    inherited;
    exit;
  end;

  if ((x>=FUrlPosx) and
    (x<=FUrlPosx+FUrlWidth) and
    (y>=FCaptTop) and
    (y<=FCaptTop+FUrlheight)) then
    FOnUrlClick(self,FUrl,Btn)
  else
    inherited;
end;


//////// TCometTopicPnl

constructor TCometTopicPnl.Create(AComponent: TComponent);
begin
  inherited Create(AComponent);
  ControlStyle := ControlStyle + [csOpaque];
  Color := clBtnface;
  doublebuffered := True;
  FCaptTop := 4;
end;

procedure TCometTopicPnl.paint;
var
  ShouldContinue: Boolean;
begin
  inherited paint;

  Canvas.pen.Color := Color;
  Canvas.brush.Color := Color;    //nessun override di colore!
  if ((bevelinner=bvnone) and (bevelouter=bvnone)) then
    Canvas.rectangle(0,0,width,height)
  else
    Canvas.rectangle(2,2,width-2,height-2);

  if Assigned(FOnPaint) then
  begin
    FOnPaint(self,Canvas,FCapt,ShouldContinue);
    if not ShouldContinue then
      exit;
  end;

  if length(FCapt) = 0 then
    exit;

  invalidate_caption;
end;

procedure TCometTopicPnl.invalidate_caption;
var
  r: TRect;
begin
  Canvas.Font.Name := Font.Name;
  Canvas.Font.Size := Font.Size;
  Canvas.Font.Style := Font.Style;
  Canvas.Font.Color := Font.Color;

  r.left := FCaptLeft;
  r.right := width - 3;
  r.top := 0;
  r.bottom := Height;

  SetBkMode(Canvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(Canvas.Handle, FCaptLeft + 4, FCaptTop, ETO_CLIPPED, @R,
    PWideChar(FCapt),Length(FCapt), nil);
end;

procedure TCometTopicPnl.SetCapt(Value: WideString);
begin
  FCapt := value;
  Invalidate;
end;

procedure TCometTopicPnl.WMEraseBkgnd(var Msg: TMessage); //reduce flicker;
begin
  msg.result := 1;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCometTopicPnl, TCometPlayerPanel]);
end;


end.
