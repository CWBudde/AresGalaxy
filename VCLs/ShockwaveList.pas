unit ShockwaveList;

interface

uses
  SysUtils, Classes, Controls, OleCtrls, ShockwaveFlashObjects_TLB,
  ShockwaveEx, Messages, ActiveX, Dialogs, Graphics;

type
  TMoviesLayout=(mlSingle, mlMatrixLR, mlMatrixTB, mlDiagonal);

  TShockwaveFlashList = class;

  TSWFChildren = class(TShockwaveFlashEx)
  private
    FHost: TShockwaveFlashList;
  public
    constructor Create(AOwner: TComponent; AHost: TShockwaveFlashList); virtual;
  protected
    procedure WndProc(var Message: TMessage); override;
  published
    property FHost: TShockwaveFlashList read FHost write FHost;
end;

  TSWFItem = class(TCollectionItem)
  private
    FSWF: TSWFChildren;
    FSWFName: string;
    procedure SetFileName(const Value: TFileName);
    function GetFileName: TFileName;
    procedure SetName(const Value: TComponentName);
    function GetName: TComponentName;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property FileName: TFileName read GetFileName write SetFileName;
    property SWF: TSWFChildren read FSWF write FSWF;
    property Name: TComponentName read GetName write SetName stored False;
  end;

  TSWFCollection = class(TCollection)
  private
    FSWFList: TShockwaveFlashList;
    function GetItem(Index: Integer): TSWFItem;
    procedure SetItem(Index: Integer; const Value: TSWFItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(SWFList: TShockwaveFlashList);
    function Add: TSWFItem;
    procedure Delete(Index: Integer);
    property Items[Index: Integer]: TSWFItem read GetItem write SetItem; default;
  end;

  TShockwaveFlashList = class(TWinControl)
  private
    FItems: TSWFCollection;
    FItemIndex: integer;
    FHost: TComponent;
    FCurentMovie: TShockwaveFlashEx;
    FLockMouseClick: boolean;
    FQuality: Integer;
    FScaleMode: Integer;
    FAlignMode: Integer;
    FBackgroundColor: TColor;
    FMenu: boolean;
    FAllowFullScreen: Boolean;
    FMoviesLayout: TMoviesLayout;
    FMovieWidthToHeight: integer;
    FCountForLayout: integer;
    FKeepMoviesSize: boolean;
    FMoviesWidth: integer;
    FMoviesHeight: integer;
    FPlaying: boolean;
    FGleam: integer;
    procedure SetItems(const Value: TSWFCollection);
    procedure SetItem(const Value: integer);
    procedure SetLockMouseClick(const Value: boolean);
    procedure SetQuality(const Value: Integer);
    procedure SetScaleMode(const Value: Integer);
    procedure SetAlignMode(const Value: Integer);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetMenu(const Value: boolean);
    procedure SetAllowFullScreen(const value: boolean);
    procedure SetMoviesLayout(const Value: TMoviesLayout);
    procedure SetMovieWidthToHeight(const Value: integer);
    procedure SetCountForLayout(const Value: integer);
    procedure SetKeepMoviesSize(const Value: boolean);
    procedure SetMoviesHeight(const Value: integer);
    procedure SetMoviesWidth(const Value: integer);
    procedure SetPlaying(const Value: boolean);
    procedure SetGleam(const Value: integer);
  protected
    procedure LoadFromItems;
    procedure WndProc(var Message: TMessage); override;
    function TColorToSWFColor(Value: TColor): integer;
    function MessageSwfNeed(SWF: TSWFChildren; Value: TMessage): boolean; virtual;
  public
    property CurentMovie: TShockwaveFlashEx read FCurentMovie default nil;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer);
    procedure Zoom(factor: SYSINT);
    procedure Pan(x, y: Integer; mode: SYSINT);
    procedure Play;
    procedure Stop;
    procedure Back;
    procedure Forward;
    procedure Rewind;
    procedure StopPlay;
    procedure GotoFrame(FrameNum: Integer);
    function CurrentFrame: Integer;
    procedure LoadMovie(layer: SYSINT; const url: WideString);
    procedure RefreshMoviesLayout;
  published
    property Align;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Items: TSWFCollection read FItems write SetItems;
    property ItemIndex: integer read FItemIndex write SetItem default 0;
    property LockMouseClick: boolean read FLockMouseClick write SetLockMouseClick stored False;
    property Quality: Integer read FQuality write SetQuality default 0;
    property Playing: boolean read FPlaying write SetPlaying stored True;
    property ScaleMode: Integer read FScaleMode write SetScaleMode default 0;
    property AlignMode: Integer read FAlignMode write SetAlignMode default 0;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clWhite;
    property Menu: boolean read FMenu write SetMenu stored False;
    property AllowFullScreen: boolean read FAllowFullScreen write SetAllowFullScreen stored True;
    property MoviesLayout: TMoviesLayout read FMoviesLayout write SetMoviesLayout default mlSingle;
    property MovieWidthToHeight: integer read FMovieWidthToHeight write SetMovieWidthToHeight default 100;
    property CountForLayout: integer read FCountForLayout write SetCountForLayout default 0;
    property KeepMoviesSize: boolean read FKeepMoviesSize write SetKeepMoviesSize stored False;
    property MoviesWidth: integer read FMoviesWidth write SetMoviesWidth default 48;
    property MoviesHeight: integer read FMoviesHeight write SetMoviesHeight default 48;
    property Gleam: integer read FGleam write SetGleam default 0;
  end;

procedure Register;

implementation


uses
  Types;

procedure Register;
begin
  RegisterComponents('ActiveX', [TShockwaveFlashList]);
end;


{ TSWFItem }

constructor TSWFItem.Create(Collection: TCollection);
begin
  inherited;
end;

destructor TSWFItem.Destroy;
begin
  if (FSWF<>nil) and (csDesigning in FSWF.ComponentState) Then FSWF.Free;
  inherited;
end;

function TSWFItem.GetFileName: TFileName;
begin
  if FSWF<>nil Then Result := FSWF.Movie Else Result := '';
end;

function TSWFItem.GetName: TComponentName;
begin
  if FSWF<>nil Then Result := FSWF.Name Else Result := '';
end;

procedure TSWFItem.SetFileName(const Value: TFileName);
begin
  if FSWF<>nil Then
    begin
      FSWF.EmbedMovie := False;
      FSWF.Movie := Value;
      FSWF.EmbedMovie := True;
    end;
end;

procedure TSWFItem.SetName(const Value: TComponentName);
begin
  FSWFName := Value;
  if FSWF<>nil Then FSWF.Name := FSWFName;
end;

{ TSWFCollection }

function TSWFCollection.Add: TSWFItem;
begin
  Result := TSWFItem(inherited Add);
end;

constructor TSWFCollection.Create(SWFList: TShockwaveFlashList);
begin
  inherited Create(TSWFItem);
  FSWFList := SWFList;
end;

procedure TSWFCollection.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

function TSWFCollection.GetItem(Index: Integer): TSWFItem;
begin
  Result := TSWFItem(inherited GetItem(Index));
end;

function TSWFCollection.GetOwner: TPersistent;
begin
  Result := FSWFList;
end;

procedure TSWFCollection.SetItem(Index: Integer; const Value: TSWFItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSWFCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  FSWFList.Invalidate;
  FSWFList.LoadFromItems;
end;

{ TShockwaveFlashList }

procedure TShockwaveFlashList.Back;
begin
  if FCurentMovie<>nil Then FCurentMovie.Back;
end;

constructor TShockwaveFlashList.Create(AOwner: TComponent);
begin
  FHost := AOwner;
  inherited Create(AOwner);
  RegisterClass(TSWFChildren);
  Width := 192;
  Height := 192;
  FItems := TSWFCollection.Create(self);
  FBackgroundColor := clWhite;
  FMoviesWidth := 48;
  FMoviesHeight := 48;
  FPlaying := True;
end;

function TShockwaveFlashList.CurrentFrame: Integer;
begin
  if FCurentMovie<>nil Then Result := FCurentMovie.CurrentFrame Else Result := -1;
end;

destructor TShockwaveFlashList.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TShockwaveFlashList.Forward;
begin
  if FCurentMovie<>nil Then FCurentMovie.Forward;
end;

procedure TShockwaveFlashList.GotoFrame(FrameNum: Integer);
begin
  if FCurentMovie<>nil Then FCurentMovie.GotoFrame(FrameNum);
end;

procedure TShockwaveFlashList.LoadFromItems;
Var i: integer;
    SWF: TSWFChildren;
    p: pointer;
begin
if (csLoading in ComponentState) Then exit;
if (FItems<>nil) Then
  for i := 0 to FItems.Count-1 do
    begin
      p := self.FindComponent(FItems.Items[i].FSWFName);
      if (FItems.Items[i].FSWF=nil) and (p<>nil) Then FItems.Items[i].FSWF := p;
      if FItems.Items[i].FSWF=nil Then
        begin
          FItems.Items[i].FSWF := TSWFChildren.Create(FHost,self);
          SWF := FItems.Items[i].FSWF;
          SWF.Parent := self;
          SWF.Align := alClient;
          SWF.CreateWnd;
          if i>0 Then SWF.Visible := false Else SWF.Visible := True;
          SWF.Quality := Quality;
          SWF.ScaleMode := ScaleMode;
          SWF.AlignMode := AlignMode;
          SWF.Menu := Menu;
          SWF.AllowFullScreen := 'true';
          SWF.BackgroundColor := TColorToSWFColor(FBackgroundColor);
          FItems.Items[i].FSWFName := SWF.Name;
        end;
    end;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.LoadMovie(layer: SYSINT; const url: WideString);
begin
  if FCurentMovie<>nil Then FCurentMovie.LoadMovie(layer,url);
end;

function TShockwaveFlashList.MessageSwfNeed(SWF: TSWFChildren; Value: TMessage): boolean;
begin
  Result := False;
  Case Value.Msg of
    CM_MOUSELEAVE,
    WM_LBUTTONDOWN,
    WM_LBUTTONUP,
    WM_RBUTTONDOWN,
    WM_RBUTTONUP,
    WM_MOUSEMOVE,
    WM_MBUTTONDOWN,
    WM_MBUTTONUP: Result := True;
  end;
end;

procedure TShockwaveFlashList.Pan(x, y: Integer; mode: SYSINT);
begin
  if FCurentMovie<>nil Then FCurentMovie.Pan(x,y,mode);
end;

procedure TShockwaveFlashList.Play;
begin
  if FCurentMovie<>nil Then FCurentMovie.Play;
end;

procedure TShockwaveFlashList.RefreshMoviesLayout;
Var i: integer;
    Kw,Kh,W,H,n,Col,Row: integer;
begin
  if (csLoading in ComponentState) Then exit;
  if FItems.Count=0 Then exit;
  for i := 0 to FItems.Count-1 do
    begin
      FItems.Items[i].SWF.Visible := False;
      FItems.Items[i].SWF.CreateWnd;
    end;
  if FMovieWidthToHeight<=0 Then FMovieWidthToHeight := 100;
  if (FCountForLayout=0) or (FCountForLayout>FItems.Count) Then n := FItems.Count-FItemIndex
    Else n := FCountForLayout;
  Case FMoviesLayout of
    mlSingle:
      begin
        if FItems.Items[ItemIndex].SWF=nil Then exit;
        With FItems.Items[ItemIndex].SWF do
          begin
            Align := alNone;
            SetBounds(FGleam,FGleam,self.Width-2*FGleam,self.Height-2*FGleam);
            Visible := True;
            CreateWnd;
          end;
      end;
    mlMatrixLR, mlMatrixTB:
      begin
        if FKeepMoviesSize Then
          begin
            W := FMoviesWidth;
            H := FMoviesHeight;
          end
         Else
          begin
            H := Trunc(Sqrt(Width*Height*100/(FMovieWidthToHeight*n)));
            W := Trunc(H*FMovieWidthToHeight/100);
          end;
        Kw := Trunc((Width-FGleam)/(W+FGleam));
        Kh := Trunc((Height-FGleam)/(H+FGleam));
        if not FKeepMoviesSize Then
          begin
            if Kw*Kh<n Then Inc(Kw);
            if Kw*Kh<n Then Inc(Kh);
            H := Trunc((Height-FGleam*(Kh+1))/Kh);
            W := Trunc((Width-FGleam*(Kw+1))/Kw);
            if W>=Round(H*FMovieWidthToHeight/100) Then W := Round(H*FMovieWidthToHeight/100)
                                                   Else H := Round(W*100/FMovieWidthToHeight);
          end;
        Col := 1;
        Row := 1;
        i := FItemIndex;
        While i<=FItemIndex+n-1 do
          begin
            if Items.Items[i].SWF<>nil Then With Items.Items[i].SWF do
              begin
                Align := alNone;
                SetBounds(W*(Col-1)+FGleam*Col,H*(Row-1)+FGleam*Row,W,H);
                Visible := True;
                CreateWnd;
              end;
            if FMoviesLayout=mlMatrixLR Then
              begin
                Inc(Col);
                if Col>Kw Then begin Col := 1; Inc(Row) end;
              end;
            if FMoviesLayout=mlMatrixTB Then
              begin
                Inc(Row);
                if Row>Kh Then begin Row := 1; Inc(Col) end;
              end;
            Inc(i);
          end;
      end;
    mlDiagonal:
      begin
        if FKeepMoviesSize Then
          begin
            W := FMoviesWidth;
            H := FMoviesHeight;
          end
         Else
          begin
            W := Trunc((Width-FGleam*(n+1))/n);
            H := Trunc((Height-FGleam*(n+1))/n);
            if (W*100/FMovieWidthToHeight)<H Then H := Round(W*100/FMovieWidthToHeight)
              Else W := Round(H*FMovieWidthToHeight/100);
          end;
        i := 0;
        While i<=n-1 do
          begin
            if Items.Items[i].SWF<>nil Then With Items.Items[i+FItemIndex].SWF do
              begin
                Align := alNone;
                SetBounds(W*i+FGleam*(i+1),H*i+FGleam*(i+1),W,H);
                Visible := True;
                CreateWnd;
                Inc(i);
              end;
          end;
      end;
  end; {Case}
end;

procedure TShockwaveFlashList.Rewind;
begin
  if FCurentMovie<>nil Then FCurentMovie.Rewind;
end;

procedure TShockwaveFlashList.SetAlignMode(const Value: Integer);
Var i: integer;
begin
  FAlignMode := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.AlignMode := Value;
end;

procedure TShockwaveFlashList.SetBackgroundColor(const Value: TColor);
Var i: integer;
begin
  FBackgroundColor := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.BackgroundColor := TColorToSWFColor(Value);
end;

procedure TShockwaveFlashList.SetCountForLayout(const Value: integer);
begin
  FCountForLayout := Value;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetGleam(const Value: integer);
begin
  FGleam := Value;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetItem(const Value: integer);
begin
  if Value>FItems.Count-1 Then exit;
  FItemIndex := Value;
  FCurentMovie := FItems.Items[Value].FSWF;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetItems(const Value: TSWFCollection);
begin
  FItems.Assign(Value);
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetKeepMoviesSize(const Value: boolean);
begin
  FKeepMoviesSize := Value;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetLockMouseClick(const Value: boolean);
Var i: integer;
begin
  FLockMouseClick := Value;
  for i := 0 to FItems.Count-1 do
    if FItems.Items[i].FSWF<>nil Then FItems.Items[i].FSWF.LockMouseClick := Value;
end;

procedure TShockwaveFlashList.SetMenu(const Value: boolean);
Var i: integer;
begin
  FMenu := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.Menu := Value;
end;

procedure TShockwaveFlashList.SetAllowFullScreen(const Value: boolean);
Var i: integer;
begin
  FAllowFullScreen := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.AllowFullScreen := 'true';
end;

procedure TShockwaveFlashList.SetMoviesHeight(const Value: integer);
begin
  FMoviesHeight := Value;
  if FKeepMoviesSize Then RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetMoviesLayout(const Value: TMoviesLayout);
begin
  FMoviesLayout := Value;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetMoviesWidth(const Value: integer);
begin
  FMoviesWidth := Value;
  if FKeepMoviesSize Then RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetMovieWidthToHeight(const Value: integer);
begin
  FMovieWidthToHeight := Value;
  RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.SetPlaying(const Value: boolean);
Var i: integer;
begin
  FPlaying := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.Playing := Value;
end;

procedure TShockwaveFlashList.SetQuality(const Value: Integer);
Var i: integer;
begin
  FQuality := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.Quality := Value;
end;

procedure TShockwaveFlashList.SetScaleMode(const Value: Integer);
Var i: integer;
begin
  FScaleMode := Value;
  for i := 0 to FItems.Count-1 do
    if FItems[i].FSWF<>nil Then FItems[i].FSWF.ScaleMode := Value;
end;

procedure TShockwaveFlashList.SetZoomRect(left, top, right, bottom: Integer);
begin
  if FCurentMovie<>nil Then FCurentMovie.SetZoomRect(left,top,right,bottom);
end;

procedure TShockwaveFlashList.Stop;
begin
  if FCurentMovie<>nil Then FCurentMovie.Stop;
end;

procedure TShockwaveFlashList.StopPlay;
begin
  if FCurentMovie<>nil Then FCurentMovie.StopPlay;
end;

function TShockwaveFlashList.TColorToSWFColor(Value: TColor): integer;
Var R,G,B: byte;
begin
  B := Trunc(Value/sqr(256));
  G := Trunc((Value-B*sqr(256))/256);
  R := Trunc(Value-B*sqr(256)-G*256);
  Result := R shl 16 + G shl 8 + B;
end;

procedure TShockwaveFlashList.WndProc(var Message: TMessage);
begin
  inherited;
  if Message.Msg=WM_SIZE Then RefreshMoviesLayout;
end;

procedure TShockwaveFlashList.Zoom(factor: SYSINT);
begin
  if FCurentMovie<>nil Then FCurentMovie.Zoom(factor);
end;

{ TSWFChildren }

constructor TSWFChildren.Create(AOwner: TComponent; AHost: TShockwaveFlashList);
Var i: integer;
    p: pointer;
    s: string;
    AParent: TWinControl;
begin
  FHost := AHost;
  i := 1;
  Repeat
    s := self.ClassName+IntToStr(i);
    p := nil;
    AParent := FHost;
    While (p=nil) and (AParent<>nil) do
      begin
        p := AParent.FindComponent(s);
        AParent := AParent.Parent;
      end;
    Inc(i);
  Until p=nil;
  self.Name := s;
  inherited Create(AOwner);
end;

procedure TSWFChildren.WndProc(var Message: TMessage);
var
  oldX, oldY: integer;
begin
  if FHost<>nil Then
    begin
      if FHost.MessageSwfNeed(self,Message) Then
        begin
          oldX := TSmallPoint(Message.LParam).x;
          oldY := TSmallPoint(Message.LParam).y;
          TSmallPoint(Message.LParam).x := oldX+Left;
          TSmallPoint(Message.LParam).y := oldY+Top;
          FHost.WndProc(Message);
          TSmallPoint(Message.LParam).x := oldX;
          TSmallPoint(Message.LParam).y := oldY;
        end;
      if (csDesigning in ComponentState) and (FHost.MessageSwfNeed(self,Message)) Then
        begin
          Message.Result := 0;
          exit;
        end;
    end;
  inherited WndProc(Message);
end;

end.
