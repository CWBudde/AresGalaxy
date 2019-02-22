unit CometBtnEdit;

interface

uses
  SysUtils, Classes, Windows, Messages, Controls, Graphics, Clipbrd, Forms,
  StdCtrls;

type
  TCometBtnState = set of (csDown,csHover);
  TPaintEvent = procedure (Sender: TObject; aCanvas: TCanvas; paintRect: TRect;
    btnState: TCometBtnState) of object;

  TCometbtnEdit = class(TEdit)
  private
    FCanvas: TControlCanvas;
    FFocused: Boolean;
    FbtnVisible: Boolean;
    FbtnWidth: Integer;
    FBorderColor: Tcolor;
    FMouseInControl: Boolean;
    FMouseIsDown: Boolean;
    FAlignment : TAlignment;
    FOnPaint: TPaintEvent;
    FOnBtnClick: TNotifyEvent;
    FGlyphIndex: Integer;
    FBtnState: TCometBtnState;
    FOnBtnStateChange: TNotifyEvent;
    function GetTextMargins: TPoint;
    procedure PaintEdit;
    procedure SetEditRect;
    procedure SetbtnVisible(Value: Boolean);
    procedure SetBtnWidth(Value: Integer);
    procedure SetFocused(Value: Boolean);
    procedure SetGlyphIndex(value: Integer);
    procedure SetAlignment(Value: TAlignment);
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property BorderColor: Tcolor read FBorderColor write FBorderColor default clblack;
    property Canvas: TcontrolCanvas read FCanvas write FCanvas;
  protected
    procedure Loaded; override;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams);  override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ButtonClick;

    property MouseInControl: Boolean read FMouseInControl;
    property MouseIsDown: Boolean read FMouseIsDown;
  published
    property btnState: TcometBtnState read FBtnState write FBtnState;
    property OnPaint: TPaintEvent read FOnPaint write FOnPaint;
    property OnBtnClick: TNotifyEvent read FOnBtnClick write FOnBtnClick;
    property OnBtnStateChange: TNotifyEvent read FOnBtnStateChange write FOnBtnStateChange;
    property glyphIndex: Integer read FGlyphIndex write SetGlyphIndex;
    property btnWidth: Integer read FbtnWidth write SetbtnWidth default 16;
    property btnVisible: Boolean read FbtnVisible write SetbtnVisible default True;
  end;

procedure Register;

implementation

function ALMediumPos(LTotal, LBorder, LObject : Integer): Integer;
begin
  Result := (LTotal - (LBorder*2) - LObject) div 2 + LBorder;
end;

procedure DrawEditFace(edt: TCometBtnEdit);
var
  R: TRect;
begin
  with edt do
  begin
    if canvas = nil then
      exit;

    R := ClientRect;
    if not BtnVisible then exit;

    R.Left := R.Right - BtnWidth;

    if Assigned(FOnPaint) then
      FOnPaint(edt, canvas, r, FBtnState);
  end;
end;

procedure TCometBtnEdit.SetGlyphIndex(value: Integer);
begin
  FGlyphIndex := value;
  paintEdit;
end;

procedure TCometBtnEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if (x >= clientwidth - FBtnWidth) and (x <= clientwidth) and (y >= 0) and (y <= height) then
  begin
    include(FBtnState, csDown);
    if Assigned(FOnBtnStateChange) then
      FOnBtnStateChange(Self);
  end;
end;

procedure TCometBtnEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if (csDown in FBtnState) then
  begin
    Exclude(FBtnState,csDown);
    if Assigned(FOnBtnStateChange) then
      FOnBtnStateChange(Self);
  end;

  if (x >= clientwidth{ - FBtnWidth}) and (x <= clientwidth + FBtnWidth) and (y >= 0) and (y <= height) then
  begin
    // has capture
    if Assigned(FOnBtnClick) then
      FOnBtnClick(Self);
  end;

end;

procedure TCometBtnEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if x>=clientwidth-FBtnWidth then
  begin
    if not (csHover in FBtnState) then
    begin
      Include(FBtnState,csHover);
      if Assigned(FOnBtnStateChange) then
        FOnBtnStateChange(Self);
    end;
  end
  else
  begin
    if (csHover in FBtnState) then
    begin
      Exclude(FBtnState,csHover);
      if Assigned(FOnBtnStateChange) then
        FOnBtnStateChange(Self);
    end;
  end;
end;

procedure TCometBtnEdit.CMMouseLeave(var Msg: TMessage);
begin
  inherited;

  if (csHover in FBtnState) then
  begin
    Exclude(FBtnState,csHover);
    if Assigned(FOnBtnStateChange) then
      FOnBtnStateChange(Self);
  end;
end;

constructor TCometBtnEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCanvas := nil;
  FOnBtnStateChange := nil;
  FFocused := False;
  FbtnVisible := True;
  FbtnWidth :=  16;
  FBorderColor :=  clblack;
  FMouseInControl := False;
  FMouseIsDown := False;
  Falignment := taleftjustify;
  FBtnState := [];
  ParentCtl3D := False;
  Ctl3D := True;
  BevelInner := bvnone;
  BevelKind := bknone;
  BevelOuter := BVNone;
  BorderStyle := forms.bsSingle;
  BevelEdges := [];
  ParentBiDiMode := False;
  BiDiMode := bdLeftToRight;
  ImeMode := imDontCare;
  ImeName := '';
  Text := '';

  ControlStyle := ControlStyle - [csSetCaption];
end;

{*******************************}
destructor TCometBtnEdit.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

{**********************************************************************************}
procedure TCometBtnEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;

{*************************************************}
procedure TCometBtnEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if (FAlignment <> taLeftJustify) then Refresh;
  end;
end;

{**************************************************************}
procedure TCometBtnEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  // ES_password ne semble pas marcher avec ES_multiline (du moins en D7)
  // ES_password implique SetEditRect ne marche pas ...
  if passwordchar = #0 then
    Params.Style := Params.Style or ES_MULTILINE;
end;

{********************************}
procedure TCometBtnEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

{*****************************}
procedure TCometBtnEdit.loaded;
begin
  inherited;
  SetEditRect;
end;

{**********************************}
procedure TCometBtnEdit.SetEditRect;
var
  Loc: TRect;
  BordWidth: Integer;
begin
  //This function is not compatible with passwordchar (passwordchar work only on no multiline edit
  if (not (csloading in ComponentState)) and (passwordChar = #0) then
  begin
    SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
    Loc.Bottom := ClientHeight + 1;

    if FBorderColor <> clNone then
      BordWidth := 1
    else
      BordWidth := 0;

    if FBtnVisible then
      Loc.Right := ClientWidth - FBtnWidth - BordWidth
    else
      Loc.Right := ClientWidth;

    Loc.Top := 0;
    Loc.Left := 1;
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  end;
end;

{*****************************************************}
procedure TCometBtnEdit.WMPaint(var Message: TWMPaint);
const
  AlignStyle : array [Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  Left: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  AAlignment: TAlignment;
  BordWidth: Integer;
begin
  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;

  AAlignment := FAlignment;
  if (AAlignment = taLeftJustify) or FFocused then
  begin
    inherited;
    Paintedit;
    Exit;
  end;

{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }

  DC := Message.DC;
  if DC = 0 then DC := beginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;
    with FCanvas do
    begin
      R := ClientRect;
      if FBorderColor = ClNone then
        BordWidth := 0
      else
        BordWidth := 1;
      InflateRect(r, -BordWidth, -BordWidth);
      if BtnVisible then R.Right := R.Right - BtnWidth;

      Brush.Color := Color;
      S := Text;
      if PasswordChar <> #0 then
        FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case AAlignment of
        taRightJustify:
          Left := R.Right - R.Left - TextWidth(S) - Margins.X - 1;
        else
          Left := (R.Right - R.Left - TextWidth(S)) div 2;
      end;
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;

  Paintedit;
end;

procedure TCometBtnEdit.PaintEdit;
begin
  DrawEditFace(Self);
end;

procedure TCometBtnEdit.ButtonClick;
begin
  if not focused then
    SetFocus;
end;

procedure TCometBtnEdit.KeyPress(var Key: Char);
begin
  if key = chr(vk_return) then
    Key := #0;
  inherited KeyPress(Key);
end;

function TCometBtnEdit.GetTextMargins: TPoint;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  Result.X := 1;

  if NewStyleControls then Result.Y := 2
  else begin
    DC := GetDC(0);
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then I := Metrics.tmHeight;
    I := I div 4;
    Result.Y := I;
  end;
end;

procedure TCometBtnEdit.WndProc(var Message: TMessage);
var
  ClipBoardText: string;
  x, z: Integer;

  function GetBorderWidth: Integer;
  begin
    if BorderColor <> clNone then
      Result := 1
    else
      Result := 0;
  end;


begin
  case Message.Msg of
    WM_LButtonDown:
      begin
        x := selstart;
        z := sellength;
        inherited;
        if not (csDesigning in ComponentState) and FBtnVisible and
          (TWMLButtonDown(Message).XPos > width - FBtnWidth - 2*GetBorderWidth) then
        begin
          selstart := x;
          sellength := z;
          FMouseIsDown := True;
          paintEdit;
        end;
      end;

    WM_LButtonUp:
      begin
        if FMouseIsDown then begin
          if (TWMLButtonUP(Message).XPos > width - FBtnWidth - 2*GetBorderWidth) and
             (TWMLButtonUP(Message).XPos < width) and
             FmouseInControl then begin
               buttonClick;
               TWMLButtonUP(message).XPos := width+1 ;
             end;
          FMouseIsDown := False;
          PaintEdit;
        end;
        inherited;
      end;

    WM_LButtonDblClk:
      begin
        x := selstart;
        z := sellength;
        inherited;
        if not (csDesigning in ComponentState) and FBtnVisible and
           (TWMLButtonDown(Message).XPos > width - FBtnWidth - 2*GetBorderWidth) then
        begin
          selstart := x;
          sellength := z;
          FMouseIsDown := True;
          paintEdit;
        end
      end;

    CM_MouseEnter:
      begin
        inherited;
        FmouseinControl := True;
        Paintedit;
      end;

    CM_MouseLeave:
      begin
        inherited;
        FmouseinControl := False;
        Paintedit;
      end;

    CM_FontChanged:
      begin
        inherited;
        SetEditRect;
      end;

    CM_Enter:
      begin
        SetFocused(True);
        inherited;
        SelStart := Length(Text);
        Sellength := 0;
        Paintedit;
      end;

    CM_Exit:
      begin
        inherited;
        SetFocused(False);
        if FMouseIsDown then
          FMouseIsDown := False;
        Paintedit;
      end;

    WM_Size:
      begin
        inherited;
        SetEditRect;
        Paintedit;
      end;

    WM_MouseMove:
      begin
        inherited;
        if FBtnVisible then
        begin
          if TWMMouseMove(message).XPos > width - FBtnWidth - 2 * GetBorderWidth then
            cursor := crArrow
          else
            Cursor := crdefault;
        end;
      end;

    WM_PASTE:
      begin
        Clipboard.Open;
        if Clipboard.HasFormat(CF_TEXT) then
          ClipBoardText := Clipboard.AsText
        else
          ClipBoardText := '';
        Clipboard.Close;

        if (pos(#13,ClipBoardText) = 0) and (pos(#10,ClipBoardText) = 0) then
          inherited;
      end;

     else inherited;
  end;
end;

procedure TCometBtnEdit.SetbtnVisible(Value: Boolean);
begin
  if Value <> FbtnVisible then
  begin
    FbtnVisible := Value;
    SetEditRect;
    Refresh;
  end;
end;

procedure TCometBtnEdit.SetBtnWidth(Value: Integer);
begin
  if Value <> Fbtnwidth then
  begin
    Fbtnwidth := Value;
    SetEditRect;
    Refresh;
  end;
end;

procedure TCometBtnEdit.SetAlignment;
begin
   if FAlignment <> Value then
   begin
    FAlignment := Value;
    Refresh;
  end;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCometBtnEdit]);
end;

end.
