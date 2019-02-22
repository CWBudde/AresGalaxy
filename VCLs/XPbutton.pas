unit XPbutton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, ImgList;

type
  TCometBtnState = set of (csEnabled,csHover, csDown, csClicked);

type
  TXPButtonDrawEvent = procedure(Sender: TObject; TargetCanvas: TCanvas;
    Rect: TRect; state: TCometBtnState; var should_continue: Boolean) of object;

type
  TXPbutton = class(TPanel)
  private
    FImageList: TImageList;

    FIndex_down: Byte;
    FIndex_over: Byte;
    FIndex_off: Byte;

    FTextw,FTexth: Integer;

    FCaption: WideString;
    FColorBg: TColor;
    FBackBitmap: Graphics.TBitmap;
    FState: TCometBtnState;
    FImgLeft, FImgTop: Integer;

    FXPButtonOnDraw: TXPButtonDrawEvent;
    //FOnArrowClick: TXPButtonArrowClickEvent;
    //FOnNeutralClick: TXPButtonNeutralClickEvent;
    FOnClick: TNotifyEvent;

    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure SetFTextw(Value: Integer);
    procedure SetFTexth(Value: Integer);
    procedure SetEnableState(Value: Boolean);
    function GetEnableState: Boolean;
    procedure SetColorBg(Value: TColor);

    procedure SetDownState(Value: Boolean);
    function GetDownState: Boolean;
    procedure SetCaption(Value: string);
    function GetCaption: string;
    procedure SetState(Value: TCometBtnState);

  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMPosChg(var Msg : TMessage); message WM_WINDOWPOSCHANGED;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
  published
    property Enabled: Boolean read GetEnableState write SetEnableState;
    property index_down: Byte read FIndex_down write FIndex_down;
    property index_over: Byte read FIndex_over write FIndex_over;
    property index_off: Byte read FIndex_off write FIndex_off;
    property imagelist: TImageList read FImageList write FImageList;
    property caption: string read GetCaption write SetCaption;
    property textleft: Integer read FTextw write SetFTextw;
    property texttop: Integer read FTexth write SetFTexth;
    property imgleft: Integer read FImgLeft write FImgLeft;
    property imgtop: Integer read FImgTop write FImgTop;
    property colorbg: TColor read FColorBg write SetColorBg;
    property Hint;
    property Down: Boolean read GetDownState write SetDownState;
    property state: TCometBtnState read FState write SetState;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Font;

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnXPButtonDraw: TXPButtonDrawEvent read FXPButtonOnDraw write FXPButtonOnDraw;
  end;

procedure Register;
function utf8strtowidestr(strin: string): WideString;
function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: Integer; var unicodeBuf; var leftUTF8: Integer): Integer;
function WideStrToUtf8str(strin: WideString): string;
function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: Integer; var utf8Buf): Integer;

//{$R Data.res}

implementation

constructor TXPbutton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FState := [csEnabled];

  FImageList := nil;

  FImgTop := 1;
  FImgLeft := 7;
  FTexth := 3;

  Width := 120;
  Height := 50;
  FColorBg := clbtnface;
  FBackBitmap := graphics.tbitmap.create;
  FBackBitmap.pixelformat := pf24Bit;

  FOnClick := nil;

  invalidate;
end;

destructor TXPbutton.Destroy;
begin
  FBackBitmap.free;
  FCaption := '';
  inherited Destroy;
end;

procedure TXPbutton.SetState(Value: TCometBtnState);
begin
  FState := Value;
  Invalidate;
end;

function TXPbutton.GetDownState: Boolean;
begin
  Result := (csDown in FState);
end;

function TXPbutton.GetEnableState: Boolean;
begin
  Result := (csEnabled in FState);
end;

procedure TXPbutton.Loaded;
begin
  bevelOuter := bvNone;
  bevelInner := bvNone;
end;

procedure TXPbutton.WMEraseBkgnd(var Msg: TMessage);  //no flicker!
begin
  Msg.Result := 1;
end;

procedure TXPbutton.Paint;
var
  r: TRect;
  should_Continue: Boolean;
begin
  try
    r.left := 0;
    r.right := width;
    r.top := 0;
    r.bottom := height;

    if (csDesigning in componentstate) then
    begin
      Canvas.brush.color := clblack;
      Canvas.framerect(r);
      Exit;
    end;

    FBackBitmap.width := width;
    FBackBitmap.Height := height;

    if assigned(FXPButtonOnDraw) then
    begin
      r := rect(0,0,width,height);
      FXPButtonOnDraw(self,FBackBitmap.Canvas,r,FState,should_continue);
    end
    else
      should_continue := true;

    if should_continue then
    begin
      FBackBitmap.Canvas.brush.color := FColorBg;
      FBackBitmap.Canvas.pen.color := FColorBg;
      FBackBitmap.Canvas.rectangle(0,0,width,height);


      if (csDown in FState) or (csClicked in FState) then
      begin
        DrawEdge(FBackBitmap.Canvas.Handle, r, 2, BF_MIDDLE or BF_RECT);
        FBackBitmap.Canvas.Brush.Bitmap := AllocPatternBitmap(FColorBg, clBtnHighlight);
        FBackBitmap.Canvas.FillRect(rect(2,2,width-2,height-2));
      end
      else
      if (csHover in FState) then
      begin
        DrawEdge(FBackBitmap.Canvas.Handle, r, EDGE_RAISED, BF_RECT + BF_SOFT);
      end;
    end;

    //icons and text
    if (csDown in FState) or ((csClicked in FState)) and (csHover in FState) then
    begin
      if imagelist<>nil then
      begin
        imagelist.drawingstyle := dsTransparent;
        imagelist.draw(FBackBitmap.Canvas,imgleft+1,imgtop+1,FIndex_down,true);
      end;
      FBackBitmap.Canvas.Brush.Style := bsClear;
      FBackBitmap.Canvas.Font := Font;
      Windows.ExtTextOutW(FBackBitmap.Canvas.Handle, FTextw+1, FTexth+1, 0, nil, PWideChar(FCaption),Length(FCaption), nil);
    end
    else
    begin
      if imagelist<>nil then
      begin
        imagelist.drawingstyle := dsTransparent;
        if (csHover in FState) then
          imagelist.draw(FBackBitmap.Canvas,imgleft,imgtop,FIndex_over,true)
        else
          imagelist.draw(FBackBitmap.Canvas,imgleft,imgtop,FIndex_off,true);
      end;
      FBackBitmap.Canvas.Brush.Style := bsClear;
      FBackBitmap.Canvas.Font := Font;
      Windows.ExtTextOutW(FBackBitmap.Canvas.Handle, FTextw, FTexth, 0, nil, PWideChar(FCaption),Length(FCaption), nil);
    end;

    Canvas.lock;
    bitBlt(Canvas.Handle, 0, 0, width, height, FBackBitmap.Canvas.Handle, 0, 0, SRCCOPY);
    Canvas.unlock;
  except
  end;
end;


procedure TXPbutton.WMPosChg(var Msg : TMessage);
begin
  Invalidate;
  inherited;
end;

procedure TXPbutton.CMMouseLeave(var Msg: TMessage);
var
  shouldRedraw: Boolean;
begin
  if FState=[] then Exit;

  shouldRedraw := (csHover in FState);
  exclude(FState, csHover);

  if shouldRedraw then invalidate;
end;

procedure TXPbutton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  shouldRedraw: Boolean;
begin
  if (csHover in FState) then Exit;

  if (x<0) or (x>width) or (y<0) or (y>height) then
  begin
    shouldRedraw := (csHover in FState);
    exclude(FState,csHover);
  end
  else
  begin
    shouldRedraw := (not (csHover in FState));
    include(FState,csHover);
  end;

  if shouldRedraw then
    invalidate;
end;

procedure TXPbutton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (csClicked in FState) then Exit;

  include(FState, csClicked);
  invalidate;

  inherited;
end;

procedure TXPbutton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  shouldRedraw: Boolean;
begin
  if not (csClicked in FState) then Exit;

  if (x<0) or (x>width) or (y<0) or (y>height) then
  begin
    shouldRedraw := (csClicked in FState);
    exclude(FState,csClicked);
    if shouldRedraw then invalidate;
    Exit;
  end;

  if assigned(FOnClick) then
    FOnClick(self);

  exclude(FState, csClicked);
  invalidate;
end;

procedure TXPbutton.SetFTextw(Value: Integer);
begin
  FTextw := Value;
  invalidate;
end;

procedure TXPbutton.SetColorBg(Value: TColor);
begin
  FColorBg := Value;

  if imagelist<>nil then
  begin
    imagelist.blendcolor := FColorBg;
    imagelist.bkcolor := FColorBg;
  end;

  invalidate;
end;

procedure TXPbutton.SetFTexth(Value: Integer);
begin
  FTexth := Value;
  invalidate;
end;

procedure TXPbutton.SetEnableState(Value: Boolean);
begin
  if Value then
    include(FState,csEnabled)
  else
    FState := [];
  invalidate;
end;

procedure TXPbutton.SetDownState(Value: Boolean);
begin
  if Value then
    include(FState,csDown)
  else
    exclude(FState,csDown);

  invalidate;
end;

procedure TXPbutton.SetCaption(Value: string);
var
  Size: TSize;
begin
  FCaption := utf8strtowidestr(Value);

  if Length(Value) < 2 then Exit;

  Canvas.Font := Font;
  Size.cX := 0;
  Size.cY := 0;
  Windows.GetTextExtentPointW(Canvas.Handle, PWideChar(FCaption), Length(FCaption), Size);

  width := FTextw+Size.cX+6;

  invalidate;
end;

function TXPbutton.GetCaption: string;
begin
  Result := WideStrToUtf8str(FCaption);
end;

function WideStrToUtf8str(strin: WideString): string;
var
  lung: Integer;
begin
  if Length(strin)=0 then
  begin
    Result := '';
    Exit;
  end;
  SetLength(Result,Length(strin)*3);
  lung := WideCharBufToUTF8Buf(strin[1],Length(strin)*sizeof(widechar),Result[1]);
  SetLength(Result,lung);
end;

function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: Integer; var utf8Buf): Integer;
var
  iwc: Integer;
  pch: PChar;
  pwc: PWideChar;
  wc: Word;

  procedure AddByte(b: Byte);
  begin
    pch^ := char(b);
    Inc(pch);
  end; { AddByte }

begin { WideCharBufToUTF8Buf }
  pwc := @unicodeBuf;
  pch := @utf8Buf;
  for iwc := 1 to uniByteCount div SizeOf(WideChar) do begin
    wc := Ord(pwc^);
    Inc(pwc);
    if (wc >= $0001) and (wc <= $007F) then begin
      AddByte(wc AND $7F);
    end
    else if (wc >= $0080) and (wc <= $07FF) then begin
      AddByte($C0 OR ((wc SHR 6) AND $1F));
      AddByte($80 OR (wc AND $3F));
    end
    else begin // (wc >= $0800) and (wc <= $FFFF)
      AddByte($E0 OR ((wc SHR 12) AND $0F));
      AddByte($80 OR ((wc SHR 6) AND $3F));
      AddByte($80 OR (wc AND $3F));
    end;
  end; //for
  Result := Integer(pch) - Integer(@utf8Buf);
end; { WideCharBufToUTF8Buf }


function utf8strtowidestr(strin: string): WideString;
var
  lung, left: Integer;
begin
  if Length(strin)=0 then
  begin
    Result := '';
    Exit;
  end;
  SetLength(Result, Length(strin));
  lung := UTF8BufToWideCharBuf(strin[1],Length(strin),Result[1],left);
  SetLength(Result, lung div sizeof(widechar));
end;

function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: Integer; var unicodeBuf; var leftUTF8: Integer): Integer;
var
  c1 : Byte;
  c2 : Byte;
  ch : Byte;
  pch: PChar;
  pwc: PWideChar;
begin
  pch := @utf8Buf;
  pwc := @unicodeBuf;
  leftUTF8 := utfByteCount;
  while leftUTF8 > 0 do
  begin
    ch := Byte(pch^);
    Inc(pch);
    if (ch and $80) = 0 then
    begin // 1-Byte code
      Word(pwc^) := ch;
      Inc(pwc);
      Dec(leftUTF8);
    end
    else if (ch and $E0) = $C0 then
    begin // 2-Byte code
      if leftUTF8 < 2 then
        break;
      c1 := Byte(pch^);
      Inc(pch);
      Word(pwc^) := (Word(ch and $1F) shl 6) or (c1 and $3F);
      Inc(pwc);
      Dec(leftUTF8,2);
    end
    else
    begin // 3-Byte code
      if leftUTF8 < 3 then
        break;
      c1 := Byte(pch^);
      Inc(pch);
      c2 := Byte(pch^);
      Inc(pch);
      Word(pwc^)  :=
        (Word(ch and $0F) shl 12) or
        (Word(c1 and $3F) shl 6) or
        (c2 and $3F);
      Inc(pwc);
      Dec(leftUTF8,3);
    end;
  end; //while
  Result := Integer(pwc) - Integer(@unicodeBuf);
end; { UTF8BufToWideCharBuf }

procedure Register;
begin
  RegisterComponents('Comet', [TXPbutton]);
end;

end.
