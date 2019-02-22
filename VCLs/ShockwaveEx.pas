//*******************************************************//
//                                                       //
//                      DelphiFlash.com                  //
//         Copyright (c) 2004-2007 FeatherySoft, Inc.    //
//                    info@delphiflash.com               //
//                                                       //
//*******************************************************//

//  Description: Extended ShockwaveFlash visual control
//  update: 20 July 2006 by Cga - added ShiftState
//  update: 23 oct 2006
//  Last date update: 2 may 2007 - added LoadMovieFromStream

unit ShockwaveEx;

interface

uses
  Windows, SysUtils, Classes, Controls, OleCtrls, ShockwaveFlashObjects_TLB,
  Messages{$IFNDEF VER130}, Types{$ENDIF}, Forms, ActiveX;

type
  TShockwaveFlashEx = class(TShockwaveFlash)
  private
    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnClick: TNotifyEvent;
    FLockMouseClick: Boolean;
    FWasDown: Boolean;
    FOleObject: IOleObject;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
    procedure InitControlInterface(const Obj: IUnknown); override;
  public
    procedure CreateWnd; override;
    procedure LoadMovieFromStream(Src: TStream);
  published
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property LockMouseClick: Boolean read FLockMouseClick write FLockMouseClick default False;
  end;

procedure Register;

implementation

uses
 zlib;

procedure TShockwaveFlashEx.CreateWnd;
begin
  inherited;
end;

procedure TShockwaveFlashEx.InitControlInterface(const Obj: IUnknown);
begin
  FOleObject := Obj as IOleObject;
end;

procedure TShockwaveFlashEx.LoadMovieFromStream(Src: TStream);
 var
   unCompress: TStream;
   Mem, Mem2: TMemoryStream;
   SRCSize: longint;
   PersistStream: IPersistStreamInit;
   SAdapt: TStreamAdapter;
   ISize: int64;
   B: byte;
   ASign: array [0..2] of char;
   isCompress: Boolean;
   ZStream: TZDeCompressionStream;

begin
  // prepare src movie
  Src.Read(ASign, 3);
  isCompress := ASign = 'CWS';
  if isCompress then
    begin
      unCompress := TMemoryStream.Create;
      ASign := 'FWS';
      unCompress.Write(ASign, 3);
      unCompress.CopyFrom(Src, 1); // version
      SRC.Read(SRCSize, 4);
      unCompress.Write(SRCSize, 4);
      ZStream := TZDeCompressionStream.Create(Src);
      try
        unCompress.CopyFrom(ZStream, SRCSize - 8);
      finally
        ZStream.Free;
      end;
      unCompress.Position := 0;
    end else
    begin
      Src.Position := Src.Position - 3;
      SRCSize := Src.Size - Src.Position;
      unCompress := Src;
    end;

  // store "template"
  EmbedMovie := False;
  FOleObject.QueryInterface(IPersistStreamInit, PersistStream);
  PersistStream.GetSizeMax(ISize);
  Mem := TMemoryStream.Create;
  Mem.SetSize(ISize);
  SAdapt := TStreamAdapter.Create(Mem);
  PersistStream.Save(SAdapt, true);
  SAdapt.Free;

  // insetr movie to "template"
  Mem.Position := 1;
  Mem2 := TMemoryStream.Create;
  B := $66; // magic flag: "f" - embed swf; "g" - without swf;
  Mem2.Write(B, 1);
  Mem2.CopyFrom(Mem, 3);
  Mem2.Write(SRCSize, 4);
  Mem2.CopyFrom(unCompress, SRCSize);
  Mem2.CopyFrom(Mem, Mem.Size - Mem.Position);

  // load activeX data
  Mem2.Position := 0;
  SAdapt := TStreamAdapter.Create(Mem2);
  PersistStream.Load(SAdapt);
  SAdapt.Free;

  // free all
  Mem2.Free;
  Mem.Free;
  PersistStream := nil;
  if isCompress then unCompress.Free;
end;

procedure TShockwaveFlashEx.WndProc(var Message: TMessage);
Var x,y: integer;
    xy: TPoint;
    ShiftState: TShiftState; //cga
begin

  if (Message.Msg >= WM_MOUSEFIRST) and (Message.Msg <= WM_MOUSELAST) then//cga
    if not (csDesigning in ComponentState) then begin
      ShiftState := KeysToShiftState(TWMMouse(Message).Keys); //cga
      x := TSmallPoint(Message.LParam).x;
      y := TSmallPoint(Message.LParam).y;
      case Message.Msg of
        CM_MOUSELEAVE: FWasDown := False;
        WM_LBUTTONDOWN:
        begin
          MouseDown(mbLeft,ShiftState,x,y);
          FWasDown := True;
        end;
        WM_RBUTTONDOWN: FWasDown := True;
        WM_RBUTTONUP:
        if (PopupMenu<>nil) and (FWasDown) then begin
          FWasDown := False;
          xy.X := x;
          xy.Y := y;
          xy := ClientToScreen(xy);
          PopupMenu.Popup(xy.X,xy.Y);
        end;
        WM_LBUTTONUP:
        begin
          MouseUp(mbLeft,ShiftState,x,y);
          FWasDown := False;
        end;
        WM_MOUSEMOVE: MouseMove(ShiftState,x,y);
      end;
      //
      if (((Message.Msg=WM_RBUTTONDOWN) or (Message.Msg=WM_RBUTTONDOWN)) and (not Menu)) or
         (((Message.Msg=WM_RBUTTONUP) or (Message.Msg=WM_LBUTTONUP) or (Message.Msg=WM_LBUTTONDOWN)
          or (Message.Msg=WM_LBUTTONDBLCLK))
          and FLockMouseClick)
      then
        Message.Result := 0
      else
        inherited WndProc(Message);
      Exit;
    end;
  inherited WndProc(Message);
end;

procedure TShockwaveFlashEx.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then
    begin
      FOnMouseDown(Self, Button, Shift, X, Y);
    end;
end;

procedure TShockwaveFlashEx.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then
    begin
      FOnMouseUp(Self, Button, Shift, X, Y);
    end;
  if FWasDown Then Click;
end;

procedure TShockwaveFlashEx.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then FOnMouseMove(Self, Shift, X, Y);
end;

procedure TShockwaveFlashEx.Click;
begin
  if Assigned(FOnClick) then FOnClick(Self);
end;

procedure Register;
begin
  RegisterComponents('Flash', [TShockwaveFlashEx]);
end;

initialization
  RegisterClass(TShockwaveFlashEx);

finalization
  UnRegisterClass(TShockwaveFlashEx);

end.
