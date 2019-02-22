unit CometHint;
{
  Hint95 version 1.05 *** BETA ***

  by Torsten Detsch
  email: tdetsch@bigfoot.com


  You are free to use, modify and distribute this code as you like. But I
  ask you to send me a copy of new versions. And please give me credit when
  you use parts of my code in other components or applications.


  Credits: THint95 is based on TDanHint by Dan Ho (danho@cs.nthu.edu.tw).
  I also got some ideas from TToolbar97 by Jordan Russell (jordanr@iname.com).


  Changes to this version:

  1.05  Fixes and minor improvements:
          - Dropped some source code that was not necessary.
          - Joe Chizmas fixed a bug that caused Delphi 3 to loose its hints when
            used together with Hint95.
          - Changed the code for finding the font Tahoma again. Now there is a
            Boolean variable that holds the state of the font Tahoma. This var
            is updates whenever a WM_FONTCHANGE occurs.
          - Hopefully fixed a bug that caused the tooltips to have a wordbreak
            when there shouldn't be one. 

}

interface

uses
  Classes, Windows, Graphics, Messages, Controls, Forms, SysUtils;

type
  { THint95 }

// THintStyle = (hsFlat, hsOffice97, hsWindows95);

  TCmtHint = class(TComponent)
  private
    FHintFont: TFont;
    FWindowHandle: HWND;
    FOnShowHint: TShowHintEvent;
    FHintBgColor: TColor;
    procedure GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure GetTooltipFont;
    procedure WndProc(var Msg: TMessage);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
    property BGColor: TColor read FHintBgColor write FHintBgColor;
    property Font: TFont read FHintFont write FHintFont;
  end;

  { THintWindow95 }

  TCmtHintWindow = class(THintWindow)
  private
    FHint: TCmtHint;
    ACapt: string;
    FTextHeight, FTextWidth: Integer;
    function FindHint: TCmtHint;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); Override;
    function CalcHintRect(MaxWidth: Integer; const AHint: String; AData: Pointer): TRect; override;
  published
  end;


function UTF8StrtoWideStr(Text: string): WideString;
function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: Integer; var unicodeBuf; var leftUTF8: Integer): Integer;
procedure Register;

implementation

var
  HintControl: TControl; { control the tooltip belongs to }
  HintMaxWidth: Integer; { max width of the tooltip }

procedure Register;
begin
  RegisterComponents('Comet', [TCmtHint]);
end;

constructor TCmtHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if not (csDesigning in ComponentState) then begin
    HintWindowClass := TCmtHintWindow;
    FWindowHandle := AllocateHWnd(WndProc);

    with Application do begin
      ShowHint := not ShowHint;
      ShowHint := not ShowHint;
      OnShowHint := GetHintInfo;

      { NOTE: These values are similar to those Win95 uses. But Win95
        does only display a tooltip when the mouse cursor doesn't move
        on the control anymore. Delphi doesn't do this. }
      HintShortPause := 25;
      HintPause := 500;
      HintHidePause := 5000;
    end;
  end;

 // FHintStyle := hsWindows95;
  FHintFont := TFont.Create;
  FHintFont.Color := clInfoText;
  FHintBgColor := GetSysColor(COLOR_INFOBK);
 // GetTahomaAvail;
  GetTooltipFont;
end;

destructor TCmtHint.Destroy;
begin
  FHintFont.Free;
  if not (csDesigning in ComponentState) then DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TCmtHint.GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(FOnShowHint) then FOnShowHint(HintStr, CanShow, HintInfo);
  HintControl := HintInfo.HintControl;
  HintMaxWidth := HintInfo.HintMaxWidth;
end;

//procedure THint95.GetTahomaAvail;
//begin
 // FTahomaAvail := Screen.Fonts.IndexOf('Tahoma') <> -1;
//end;

procedure TCmtHint.GetTooltipFont;
var
  NCM: TNonClientMetrics;
begin
  { Get tooltip font using SystemParametersInfo }
  NCM.cbSize := SizeOf(TNonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, NCM.cbSize, @NCM, 0);
  with NCM.lfStatusFont, FHintFont do begin
    Name := lfFaceName;
    Height := lfHeight;
    Style := [];
    if lfWeight > FW_MEDIUM then Style := Style + [fsBold];
    if lfItalic <> 0 then Style := Style + [fsItalic];
    if lfUnderline <> 0 then Style := Style + [fsUnderline];
    if lfStrikeOut <> 0 then Style := Style + [fsStrikeOut];
    Pitch := TFontPitch(lfPitchAndFamily);
    {$IFNDEF VER90} { Delphi 3 or C++Builder }
    CharSet := TFontCharSet(lfCharSet);
    {$ENDIF}
  end;

  { Office 97 style? Then use Tahoma instead of MS Sans Serif }
  //if (FHintFont.Name='MS Sans Serif') and FTahomaAvail then FHintFont.Name := 'Tahoma';
end;

//procedure THint95.SetHintStyle(AHintStyle: THintStyle);
//begin
//  if AHintStyle <> FHintStyle then begin
//    FHintStyle := AHintStyle;
//    if FHintStyle = hsOffice97 then GetTooltipFont;
//  end;
//end;

procedure TCmtHint.WndProc(var Msg: TMessage);
begin
  with Msg do
    case Msg of
      WM_SETTINGCHANGE: GetTooltipFont;
      //WM_FONTCHANGE: GetTahomaAvail;
      { ^ Update TahomaAvail whenever a font was installed or removed. }
      else Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
    end;
end;

{ THintWindow95 }

function TCmtHintWindow.FindHint: TCmtHint;
var
  I: Integer;
begin
  Result := nil;

  with Application.MainForm do
  for I := 0 to ComponentCount-1 do
    if Components[I] is TCmtHint then begin
      Result := TCmtHint(Components[I]);
      Break;
    end;
end;

procedure TCmtHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;
end;

procedure TCmtHintWindow.Paint;
var
  DC: HDC;
  R, RD: TRect;
  //Brush, SaveBrush: HBRUSH;
  widestr: WideString;

  //str,str1: string;
 // i: Integer;
 // col: Cardinal;
  { DCFrame3D was taken from TToolbar97 by Jordan Russell }
  procedure DCFrame3D(var R: TRect; const TopLeftColor, BottomRightColor: TColor);
  { Similar to VCL's Frame3D function, but accepts a DC rather than a Canvas }
  var
    Pen, SavePen: HPEN;
    P: array [0..2] of TPoint;
  begin
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(TopLeftColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-2);
    P[1] := Point(R.Left, R.Top);
    P[2] := Point(R.Right-1, R.Top);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(BottomRightColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-1);
    P[1] := Point(R.Right-1, R.Bottom-1);
    P[2] := Point(R.Right-1, R.Top-1);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);
  end;

begin
  FHint := FindHint;
  Canvas.Font := FHint.FHintFont;

  DC := Canvas.Handle;
  R := ClientRect; RD := ClientRect;

  //col := Fhint.BGColor+16769256;
  //SetLength(str1,4);
  //move(col,str1[1],4);

  //str := '$';
  //for i := 1 to 4 do str := str+inttohex(ord(str1[i]),2);
                          //messagebox(0,PChar(str+' '+inttostr(cardinal(Fhint.BGColor))+'  '+inttostr(cardinal(clbtnface))),PChar('gf'),mb_ok);
  { Background }
  canvas.brush.color := FHint.BGColor;
  canvas.pen.color := FHint.BGColor;
  canvas.FillRect(r);
  //Brush := CreateSolidBrush(Fhint.BGColor);
  //SaveBrush := SelectObject(DC, Brush);
  //FillRect(DC, R, Brush);
  //SelectObject(DC, SaveBrush);
  //DeleteObject(Brush);

  { Border }
 // case FHint.FHintStyle of
   // hsFlat:
  // DCFrame3D(R, clWindowFrame, clWindowFrame);
  //  else
  DCFrame3D(R, cl3DLight, cl3DDkShadow);
 // end;

  { Caption }
  SetBkMode(DC, TRANSPARENT);
  RD.Left := R.Left + (R.Right-R.Left - FTextWidth) div 2;
  RD.Top := R.Top + (R.Bottom-R.Top - FTextHeight) div 2;
  RD.Bottom := RD.Top + FTextHeight;



  widestr := UTF8StrtoWideStr(ACapt);
   Windows.ExtTextOutW(DC, 3, 2, 0, @RD, @widestr[1],Length(widestr), nil);
   //DrawTextW(DC, @widestr[1], Length(widestr), RD, DT_NOPREFIX or DT_LEFT or DT_SINGLELINE);
end;

function TCmtHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: String; AData: Pointer): TRect;
var
  WideHintStr: WideString;
  Size: TSize;
begin
  Result := Rect(0, 0, MaxWidth, 0);

  FHint := FindHint;
  Canvas.Font := FHint.FHintFont;
  ACapt := Ahint;
  WideHintStr := UTF8StrtoWideStr(AHint);

  GetTextExtentPoint32W(Canvas.Handle,@WideHintstr[1],Length(WideHintStr), Size); //serve allargare?
  Result.Right := Result.Left+Size.cx;
  Result.Bottom := Result.Top+Size.cy;


  Inc(Result.Right, 6);
  Inc(Result.Bottom, 2);
end;

procedure TCmtHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  dx, dy, rch: Integer;
  Pnt: TPoint;
  II: TIconInfo;
  WideHintStr: WideString;
  Size: TSize;

  function RealCursorHeight(Cur: HBITMAP): Integer;
  { Scans a cursor bitmap to get its real height }
  var
    Bmp: TBitmap;
    x, y: Integer;
    found: Boolean;
  begin
    Result := 0;

    Bmp := TBitmap.Create;
    Bmp.Handle := Cur;

    { Scan the "normal" cursor mask (lines 1 to 32) }
    for y := 31 downto 0 do begin
      for x := 0 to 31 do begin
        found := GetPixel(Bmp.Canvas.Handle, x, y)=clBlack;
        if found then Break;
      end;

      if found then begin
        Result := y-II.yHotSpot;
        Break;
      end;
    end;

    { No Result? Then scan the inverted mask (lines 32 to 64) }
    if not found then
    for y := 63 downto 31 do begin
      for x := 0 to 31 do begin
        found := GetPixel(Bmp.Canvas.Handle, x, y)=clWhite;
        if found then Break;
      end;

      if found then begin
        Result := y-II.yHotSpot-32;
        Break;
      end;
    end;

    { No Result yet?! Ok, let's say the cursor height is 32 pixels... }
    if not found then Result := 32;

    Bmp.Free;
  end;

begin
  ACapt := Ahint;
  FHint := FindHint;
  Canvas.Font.Assign(FHint.FHintFont);
  WideHintStr := UTF8StrtoWideStr(AHint);

  dx := 6;
  dy := 6;

  { Calculate width and height }   // DrawText

  Rect.Right := Rect.Left + HintMaxWidth - dx; { this hopefully fixes the problem with HintMaxWidth }

  GetTextExtentPoint32W(Canvas.Handle, @WideHintStr[1], Length(WideHintStr), Size); //serve allargare?
  Rect.Right := Rect.Left + Size.cx;
  Rect.Bottom := Rect.Top + Size.cy;

  with Rect do
  begin
    Inc(Right, dx); Inc(Bottom, dy);
    FTextWidth := Right-Left-dx;
    FTextHeight := Bottom-Top-dy;

    { Calculate position }
    GetCursorPos(Pnt); GetIconInfo(GetCursor, II);
    Right := Right-Left + Pnt.X; Left := Pnt.X;
    rch := RealCursorHeight(II.hbmMask);
    Bottom := Bottom-Top + Pnt.Y + rch; Top := Pnt.Y + rch;

    { Make sure the tooltip is completely visible }
    if Right > Screen.Width then
    begin
      Left := Screen.Width - Right+Left;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > Screen.Height then
    begin
     // if (FHint.FHintStyle=hsOffice97) or (HintControl is TForm) then begin
        { Office 97 displays the tooltips 2 pixels above
          the cursor position.

          NOTE: Tooltips for forms are included here for 2 reasons:
          1. For forms "HintControl.Parent.ClientToScreen()" causes
             an exception.
          2. Forms are normally very big (at least bigger than buttons)
             and I don't think it looks good when the mouse cursor is
             at the Bottom of the screen and the tooltip is at the Top. }
        Bottom := Pnt.Y - 2;
        Top := Bottom - FTextHeight - dy;
     // end
     // else begin
        { Win95 and IE display the tooltips Right above the
          control they belong to. }
     //   if HintControl <> nil then begin
     //     P := HintControl.Parent.ClientToScreen(Point(0, HintControl.Top));
     //     Bottom := P.Y;
     //     Top := Bottom - FTextHeight - dy;
    //    end;
     // end;
    end;
  end;
  BoundsRect := Rect;

  Pnt := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, Pnt.X, Pnt.Y, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;

function UTF8StrtoWideStr(Text: string): WideString;
var
  lung, Left: Integer;
begin
  if Length(Text) = 0 then
  begin
    Result := '';
    exit;
  end;
  SetLength(Result, Length(Text));
  lung := UTF8BufToWideCharBuf(Text[1], Length(Text), Result[1], Left);
  SetLength(Result, lung div SizeOf(WideChar));
end;

function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: Integer;
  var unicodeBuf; var leftUTF8: Integer): Integer;
var
  c1: Byte;
  c2: Byte;
  ch: Byte;
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
      word(pwc^) := ch;
      Inc(pwc);
      Dec(leftUTF8);
    end
    else if (ch and $E0) = $C0 then
    begin // 2-Byte code
      if leftUTF8 < 2 then
        break;
      c1 := Byte(pch^);
      Inc(pch);
      word(pwc^) := (Word(ch and $1F) shl 6) or (c1 and $3F);
      Inc(pwc);
      Dec(leftUTF8, 2);
    end
    else
    begin // 3-Byte code
      if leftUTF8 < 3 then
        break;
      c1 := Byte(pch^);
      Inc(pch);
      c2 := Byte(pch^);
      Inc(pch);
      word(pwc^) := 
        (word(ch and $0F) shl 12) or
        (word(c1 and $3F) shl 6) or
        (c2 and $3F);
      Inc(pwc);
      Dec(leftUTF8, 3);
    end;
  end; //while

  Result := Integer(pwc) - Integer(@unicodeBuf);
end; { UTF8BufToWideCharBuf }


end.
