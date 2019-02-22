unit CometPageView;

interface

uses
  Classes, ExtCtrls, Windows, Graphics, Messages, Controls, SysUtils;

type
  TPaintBtnFrameEvent = procedure (Sender: TObject; aCanvas: TCanvas; paintRect: TRect)  of object;
  TPaintButtonEvent = procedure (Sender: TObject; aPanel: TObject; aCanvas: TCanvas; paintRect: TRect) of object;
  TCustomPanelShow = procedure (Sender: TObject; aPanel: TObject) of object;
  TCustomPanelClose = procedure (Sender: TObject; aPanel: TObject; var Proceed: Boolean) of object;

  TCometPagePanelIDx = (
    IdxBtnWeb,
    IdxBtnLibrary,
    IdxBtnScreen,
    IdxBtnSearch,
    IdxBtnTransfer,
    IdxBtnChat,
    IdxBtnOptions,
    IDNone,
    IDXChatPvt,
    IDXChatMain,
    IDXChatBrowse,
    IDXChatSearch,
    IDXSearch
  );

  TCometPageBtnState = set of (csHover, csDown, csClicked);
  TCometPageCloseBtnState = set of (bsHover);

  TCometPagePanel = class(TObject)
    ID: TCometPagePanelIDx;
    BtnState: TCometPageBtnState;
    Panel: TPanel;
    FCaption: WideString;
    BtnHitRect: TRect;
    HasCloseButton: Boolean;
    rcCloseButton: TRect;
    CloseBtnState: TCometPageCloseBtnState;
    Owner: TPanel;
    FImageIndex: Integer;
    FData: Pointer;
    PaintRow: Integer;
    procedure SetCaption(value: WideString);
    procedure SetImageIndex(value: Integer);
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property BtnCaption: WideString read FCaption write SetCaption;
  end;

  TCometPagePanelList = array of TCometPagePanel;

  TCometPageView = class(TPanel)
  private
    FPanels: TCometPagePanelList;
    FButtonsLeft: Integer;
    FButtonsLeftMargin, FButtonsTopMargin, FButtonsRightMargin: Integer;
    FButtonsHeight: Integer;
    FActivePage: Integer;
    FHorizBtnSpacing: Integer;
    FCloseButtonTopMargin,
    FCloseButtonLeftMargin,
    FCloseButtonWidth,
    FCloseButtonHeight: Integer;
    FOnPaintButtonFrame: TPaintBtnFrameEvent;
    FOnPaintButton: TPaintButtonEvent;
    FOnPanelShow: TCustomPanelShow;
    FDrawMargin: Boolean;
    FSwitchOnDown: Boolean;
    FWrappable: Boolean;
    FOnPanelClose: TCustomPanelClose;
    FButtonsTopHitPoint: Integer;
    FTabsVisible,FHideTabsOnSigle: Boolean;
    FOnPaintCloseButton: TPaintButtonEvent;
    FColorFrame: TColor;
    FNumRows: Integer;
    FWidestTab: Integer;

    procedure SetButtonsHeight(value: Integer);
    procedure SetButtonsTopMargin(value: Integer);
    procedure SetButtonsLeftMargin(value: Integer);
    procedure SetButtonsRightMargin(value: Integer);
    procedure SetActivePage(value: Integer);
    procedure SetButtonsLeft(value: Integer);
    procedure SetCloseButtonTopMargin(value: Integer);
    procedure SetCloseButtonLeftMargin(value: Integer);
    procedure SetCloseButtonWidth(value: Integer);
    procedure SetCloseButtonHeight(value: Integer);
    function HasAnyDown: Boolean;
    function GlyphWidth(Pnl: TCometPagePanel): Integer;
    function GetActivePanel: TPanel;
    procedure SetActivePanel(value: TPanel);
    procedure SetDrawMargin(value: Boolean);
    procedure SetTabsVisible(value: Boolean);
    procedure SetColorFrame(value: TColor);
    procedure ExcludeDowns(ExceptPanel: TCometPagePanel);
    procedure ResizeControl;
    procedure ResizePanels;
    function ResizeTabsSimple: Boolean;
    procedure ResizeTabsWrappable;
    procedure SetWrappable(value: Boolean);
    procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure Paint; override;
    procedure PaintButton(Pnl: TCometPagePanel);
    procedure CheckInvalidate;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Resize; override;
    function AddPanel(ID: TCometPagePanelIDx; BtnCaption: WideString; BtnState: TCometPageBtnState;
      Panel: TPanel; aData: Pointer; withCloseButton: Boolean=false; imageIndex: Integer=-1; killAutoSwitch: Boolean=false): TCometPagePanel;
    function DeletePanel(panelIndex: Integer; Notify: Boolean=true): Integer; overload;
    function DeletePanel(Panel: TCometPagePanel): Integer; overload;
    function PanelsCount: Integer;
    function GetPagePanel(Panel: TPanel): TCometPagePanel;
    function GetPagePanelIndex(Panel: TPanel): Integer;
  published
    property Wrappable: Boolean read FWrappable write SetWrappable;
    property ColorFrame: TColor read FColorFrame write SetColorFrame;
    property HideTabsOnSingle: Boolean read FHideTabsOnSigle write FHideTabsOnSigle default false;
    property TabsVisible: Boolean read FTabsVisible write SetTabsVisible;
    property SwitchOnDown: Boolean read FSwitchOnDown write FSwitchOnDown;
    property DrawMargin: Boolean read FDrawMargin write SetDrawMargin;
    property Panels: TCometPagePanelList read FPanels;
    property ActivePanel: TPanel read GetActivePanel write SetActivePanel;
    property ButtonsHeight: Integer read FButtonsHeight write SetButtonsHeight;
    property ButtonsLeft: Integer read FButtonsLeft write SetButtonsLeft;
    property ButtonsLeftMargin: Integer read FButtonsLeftMargin write SetButtonsLeftMargin;
    property ButtonsRightMargin: Integer read FButtonsRightMargin write SetButtonsRightMargin;
    property ButtonsTopMargin: Integer read FButtonsTopMargin write SetButtonsTopMargin;
    property CloseButtonTopMargin: Integer read FCloseButtonTopMargin write SetCloseButtonTopMargin;
    property CloseButtonLeftMargin: Integer read FCloseButtonLeftMargin write SetCloseButtonLeftMargin;
    property CloseButtonWidth: Integer read FCloseButtonWidth write SetCloseButtonWidth;
    property CloseButtonHeight: Integer read FCloseButtonHeight write SetCloseButtonHeight;
    property ActivePage: Integer read FActivePage write SetActivePage;
    property ButtonsHorizSpacing: Integer read FHorizBtnSpacing write FHorizBtnSpacing;
    property ButtonsTopHitPoint: Integer read FButtonsTopHitPoint write FButtonsTopHitPoint;

    property OnPaintButtonFrame: TPaintBtnFrameEvent read FOnPaintButtonFrame write FOnPaintButtonFrame;
    property OnPaintButton: TPaintButtonEvent read FOnPaintButton write FOnPaintButton;
    property OnPaintCloseButton: TPaintButtonEvent read FOnPaintCloseButton write FOnPaintCloseButton;
    property OnPanelShow: TCustomPanelShow read FOnPanelShow write FOnPanelShow;
    property OnPanelClose: TCustomPanelClose read FOnPanelClose write FOnPanelClose;
  end;

procedure Register;

implementation

procedure TCometPagePanel.SetCaption(value: WideString);
var
  Size: TSize;
  WidthBefore, WidthAfter: Integer;
begin
  Size.cX := 0;
  if length(BtnCaption)>0 then
  begin
    Size.cY := 0;
    Windows.GetTextExtentPointW((Owner as TCometPageView).Canvas.handle, PwideChar(BtnCaption), Length(BtnCaption), Size);
  end;
  WidthBefore := Size.cX;

  Size.cX := 0;
  if length(value)>0 then
  begin
    Size.cY := 0;
    Windows.GetTextExtentPointW((Owner as TCometPageView).Canvas.handle, PwideChar(value), Length(value), Size);
  end;
  WidthAfter := Size.cX;

  FCaption := value;

  if WidthBefore=WidthAfter then
    (Owner as TCometPageView).PaintButton(Self)
  else
    (Owner as TCometPageView).Resize;
end;

procedure TCometPagePanel.SetImageIndex(value: Integer);
begin
  FImageIndex := value;
  (Owner as TCometPageView).PaintButton(Self);
end;

//////////////////////////// tcometpageview

procedure TCometPageView.SetWrappable(value: Boolean);
begin
  FWrappable := value;
  Resize;
end;


procedure TCometPageView.SetTabsVisible(value: Boolean);
begin
  FTabsVisible := value;
  Resize;
end;

procedure TCometPageView.SetColorFrame(value: TColor);
begin
  FColorFrame := value;
  CheckInvalidate;
end;

procedure TCometPageView.SetDrawMargin(value: Boolean);
begin
  FDrawMargin := value;
  CheckInvalidate;
end;

function TCometPageView.GetPagePanel(Panel: TPanel): TCometPagePanel;
var
  Pnl: TCometPagePanel;
  i: Integer;
begin
  Result := nil;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    if Pnl.Panel=Panel then
    begin
      Result := Pnl;
      Exit;
    end;
  end;
end;

function TCometPageView.GetPagePanelIndex(Panel: TPanel): Integer;
var
  Pnl: TCometPagePanel;
  i: Integer;
begin
  Result := -1;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    if Pnl.Panel=Panel then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TCometPageView.PanelsCount: Integer;
begin
  Result := length(FPanels);
end;

function TCometPageView.GetActivePanel: TPanel;
var
  Pnl: TCometPagePanel;
begin
  if length(FPanels)=0 then
  begin
    Result := nil;
    Exit;
  end;
  Pnl := FPanels[FActivePage];
  Result := Pnl.Panel;
end;

procedure TCometPageView.SetActivePanel(value: TPanel);
var
  Pnl: TCometPagePanel;
  i: Integer;
begin
  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    if Pnl.Panel=value then
    begin
      ActivePage := i;
      Exit;
    end;
  end;
end;

procedure TCometPageView.SetCloseButtonLeftMargin(value: Integer);
begin
  FCloseButtonLeftMargin := value;
  Resize;
end;

procedure TCometPageView.SetCloseButtonTopMargin(value: Integer);
begin
  FCloseButtonTopMargin := value;
  Resize;
end;

procedure TCometPageView.SetCloseButtonWidth(value: Integer);
begin
  FCloseButtonWidth := value;
  Resize;
end;

procedure TCometPageView.SetCloseButtonHeight(value: Integer);
begin
  FCloseButtonHeight := value;
  Resize;
end;

function TCometPageView.AddPanel(ID: TCometPagePanelIDx; BtnCaption: WideString; BtnState: TCometPageBtnState;
 Panel: TPanel; aData: Pointer; withCloseButton: Boolean=false; imageIndex: Integer=-1; killAutoSwitch: Boolean=false): TCometPagePanel;
var
  Pnl: TCometPagePanel;
  CurrentActivePanel: Integer;
begin
  //if killAutoSwitch then
  CurrentActivePanel := FActivePage;

  Pnl := TCometPagePanel.Create;
  Pnl.PaintRow := 0;
  SetLength(FPanels,length(FPanels)+1);
  FPanels[High(FPanels)] := Pnl;

  Pnl.Owner := Self;
  Panel.Parent := Self;

  Pnl.ID := ID;
  Pnl.BtnState := BtnState;
  Pnl.BtnCaption := BtnCaption;
  Pnl.Panel := Panel;
  Pnl.HasCloseButton := withCloseButton;
  Pnl.FimageIndex := imageIndex;
  Pnl.FData := aData;

  if Pnl.Panel<>nil then
  begin
    Pnl.Panel.Top := FButtonsHeight+Integer(FDrawMargin);
    Pnl.Panel.Left := Integer(FDrawMargin);
    Pnl.Panel.Width := ClientWidth-(Integer(FDrawMargin)*2);
    Pnl.Panel.Height := (clientheight-FButtonsHeight)-Integer(FDrawMargin);
  end;

  Result := Pnl;

  if killAutoSwitch then
    ActivePage := CurrentActivePanel
  else
    ActivePage := High(FPanels);

  Resize;
end;

function TCometPageView.DeletePanel(Panel: TCometPagePanel): Integer;
var
  i: Integer;
  tempPnl: TCometPagePanel;
begin
  Result := -1;

  for i := 0 to High(FPanels) do
  begin
    tempPnl := FPanels[i];
    if tempPnl=Panel then
    begin
      Result := deletePanel(i);
      Exit;
    end;
  end;
end;

function TCometPageView.DeletePanel(panelIndex: Integer; Notify: Boolean): Integer;
var
  i: Integer;
  Pnl: TCometPagePanel;
  proceed: Boolean;
begin
  Result := -1;
  if (panelIndex<0) or (panelIndex>High(FPanels)) then
    Exit;

  Pnl := FPanels[panelIndex];
  proceed := true;

  if notify and Assigned(FOnPanelClose) then
    FOnPanelClose(Self,Pnl,proceed);

  if not proceed then
    Exit;

  Pnl.FCaption := '';
  Pnl.Free;

  if panelIndex<High(panelIndex) then
    for i := panelIndex to High(FPanels)-1 do
    begin
      Pnl := FPanels[i+1];
      FPanels[i] := Pnl;
    end;

  SetLength(FPanels,High(FPanels));

  Result := length(FPanels);

  if (panelIndex>0) and (panelIndex-1<length(FPanels)) then
    ActivePage := panelIndex-1
  else
    ActivePage := 0;

  if FHideTabsOnSigle and (length(FPanels)=1) then
    TabsVisible := false;

  Resize;
end;

procedure TCometPageView.setActivePage(value: Integer);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw: Boolean;
begin
  if value > High(FPanels) then
    value := High(FPanels);
  if value < 0 then
    value := 0;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];

    if value<>i then
    begin
      ShouldRedraw := (csDown in Pnl.BtnState);
      exclude(Pnl.BtnState,csDown);
      if ShouldRedraw then PaintButton(Pnl);
      // if Pnl.Panel<>nil then Pnl.Panel.visible := false;
    end
    else
    begin
      Include(Pnl.BtnState,csDown);

      if Pnl.Panel<>nil then
      begin
        if FWrappable then
          Pnl.Panel.Top := (Integer(FTabsVisible)*(FButtonsHeight*FNumRows))+Integer(FDrawMargin)
        else
          Pnl.Panel.Top := (Integer(FTabsVisible)*(FButtonsHeight))+Integer(FDrawMargin);
        Pnl.Panel.Left := 0;//Integer(FDrawMargin);
        Pnl.Panel.Width := ClientWidth;//-(Integer(FDrawMargin)*2);
        Pnl.Panel.Height := clientheight-Pnl.Panel.Top;
        Pnl.Panel.visible := true;
        FActivePage := i;
      end;

      if assigned(FOnPanelShow) then
        FOnPanelShow(Self,Pnl);
      PaintButton(Pnl);
    end;
  end;


  for i := 0 to High(FPanels) do
  begin
   Pnl := FPanels[i];
   if not (csDown in Pnl.BtnState) then
     if Pnl.Panel<>nil then
       Pnl.Panel.visible := false;
  end;

  if FWrappable then Resize;  // got to take care of paintRow# assignment
end;

procedure TCometPageView.WMEraseBkgnd(Var Msg : TMessage);
begin
  msg.Result := 1;
end;

procedure TCometPageView.Resize;
begin
  inherited;
  reSizeControl;
  Invalidate;
end;

procedure TCometPageView.ResizeControl;
begin
  Canvas.Font.Name := Self.Font.Name;
  Canvas.Font.Size := Self.Font.Size;
  Canvas.Font.Style := Self.Font.Style;


  if not FWrappable then
    ResizeTabsSimple
  else
    if not ResizeTabsSimple then ResizeTabsWrappable;

  ResizePanels;
end;

procedure TCometPageView.ResizeTabsWrappable;
var
  i,OffsetX,wid: Integer;
  Pnl: TCometPagePanel;
  Size: TSize;
  TabsPerRow,DownRow,TabsInActualRow,ActualRow: Integer;
begin
  FNumRows := 1;
  OffsetX := FButtonsLeft;
  FWidestTab := 0;

  for i := 0 to High(FPanels) do
  begin  // get width of widest tab
    Pnl := FPanels[i];

    Size.cX := 0;
    if length(Pnl.BtnCaption)>0 then
    begin
      Size.cY := 0;
      Windows.GetTextExtentPointW(Canvas.handle, PwideChar(Pnl.BtnCaption), Length(Pnl.BtnCaption), Size);
    end;

    if Pnl.HasCloseButton then
      wid := GlyphWidth(Pnl)+Size.cX+(FButtonsLeftMargin+FButtonsRightMargin)+FCloseButtonWidth+2
    else
      wid := GlyphWidth(Pnl)+Size.cX+(FButtonsLeftMargin+FButtonsRightMargin);

    Inc(wid,FHorizBtnSpacing);
    if FWidestTab<wid then FWidestTab := wid;
  end;

  TabsPerRow := (ClientWidth-(FButtonsLeft*2)) div (FWidestTab+FHorizBtnSpacing);
  if tabsPerRow=0 then TabsPerRow := 1;

  FWidestTab := (ClientWidth-(FButtonsLeft*2)) div TabsPerRow;

  if FWidestTab>(ClientWidth-(FButtonsLeft*2)) then FWidestTab := (ClientWidth-(FButtonsLeft*2));

  if (length(FPanels) mod TabsPerRow)=0 then
    FnumRows := (length(FPanels) div TabsPerRow)
  else
    FnumRows := (length(FPanels) div TabsPerRow)+1;


  // now assign new widths and temporary tab's paintrow
  downrow := 0;
  FNumRows := 1;
  OffsetX := FButtonsLeft;
  for i := 0 to High(FPanels) do
  begin  // get width of widest tab
    Pnl := FPanels[i];

    if OffsetX+FWidestTab+FButtonsLeft>ClientWidth then
    begin
      OffsetX := FButtonsLeft;
      Inc(FNumRows);
    end;

    with Pnl.BtnHitRect do
    begin
      left := OffsetX;
      right := OffsetX+FWidestTab;
    end;

    Pnl.paintRow := FNumRows-1;
    if (csDown in Pnl.BtnState) then
      DownRow := Pnl.paintRow;
    Inc(OffsetX,FWidestTab);
  end;

  // get down row
  ActualRow := 0;
  TabsInActualRow := 0;
  for i := 0 to High(FPanels) do
  begin  // get width of widest tab
    Pnl := FPanels[i];

    if Pnl.PaintRow=DownRow then
      Pnl.paintRow := FNumRows-1
    else
    begin
      Inc(TabsInActualRow);
      if TabsInActualRow>TabsPerRow then
      begin
        TabsInActualRow := 1;
        Inc(ActualRow);
      end;
      Pnl.paintRow := ActualRow;
    end;

    Pnl.BtnHitRect.Top := Pnl.paintRow*FbuttonsHeight;
    Pnl.BtnHitRect.bottom := Pnl.BtnHitRect.top+FButtonsHeight;
    if Pnl.HasCloseButton then
      Pnl.rcCloseButton := rect(
        Pnl.BtnHitRect.right-FCloseButtonLeftMargin,
        Pnl.BtnHitRect.top+FCloseButtonTopMargin,
        Pnl.BtnHitRect.right-FCloseButtonLeftMargin+FCloseButtonWidth,
        Pnl.BtnHitRect.top+FCloseButtonTopMargin+FCloseButtonHeight
      );
  end;

end;

function TCometPageView.ResizeTabsSimple: Boolean;
var
  i: Integer;
  Pnl: TCometPagePanel;
  Size: TSize;
  OffsetX: Integer;
begin
  Result := true;

  FNumRows := 1;
  OffsetX := FButtonsLeft;

  for i := 0 to High(FPanels) do
  begin  // copy buttons on a list
    Pnl := FPanels[i];
    Pnl.PaintRow := 0;

    Size.cX := 0;
    if length(Pnl.BtnCaption)>0 then
    begin
      Size.cY := 0;
      Windows.GetTextExtentPointW(Canvas.handle, PwideChar(Pnl.BtnCaption), Length(Pnl.BtnCaption), Size);
    end;

    with Pnl.BtnHitRect do
    begin
      left := OffsetX;
      top := 0;
      bottom := top+FbuttonsHeight;

      if Pnl.HasCloseButton then
      begin
        right := OffsetX+GlyphWidth(Pnl)+Size.cX+(FButtonsLeftMargin+FButtonsRightMargin)+FCloseButtonWidth+2;
              Pnl.rcCloseButton := rect(Pnl.BtnHitRect.right-FCloseButtonLeftMargin,
                                      Pnl.BtnHitRect.top+FCloseButtonTopMargin,
                                      Pnl.BtnHitRect.right-FCloseButtonLeftMargin+FCloseButtonWidth,
                                      Pnl.BtnHitRect.top+FCloseButtonTopMargin+FCloseButtonHeight);
      end
      else
        right := OffsetX+GlyphWidth(Pnl)+Size.cX+(FButtonsLeftMargin+FButtonsRightMargin);
    end;


    Inc(OffsetX,(Pnl.BtnHitRect.Right-Pnl.BtnHitRect.left)+FHorizBtnSpacing);

    if OffsetX>ClientWidth then
    begin
      Result := false;
      if FWrappable then break; //Resize tabsWrappable will take care of everything
    end;
  end;
end;

procedure TCometPageView.ResizePanels;
var
  i: Integer;
  Pnl: TCometPagePanel;
begin
  for i := 0 to High(FPanels) do
  begin
   Pnl := FPanels[i];

   //if (csDown in Pnl.BtnState) then
    if Pnl.Panel<>nil then
    begin
      if FWrappable then
        Pnl.Panel.Top := (Integer(FTabsVisible)*(FButtonsHeight*FNumRows))+Integer(FDrawMargin)
      else
        Pnl.Panel.Top := (Integer(FTabsVisible)*(FButtonsHeight))+Integer(FDrawMargin);
      Pnl.Panel.Left := 0;//Integer(FDrawMargin);
      Pnl.Panel.Width := ClientWidth;//-(Integer(FDrawMargin)*2);
      Pnl.Panel.Height := clientheight-Pnl.Panel.Top;
    end;
  end;
end;


procedure TCometPageView.CMMouseLeave(var Msg: TMessage);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw,shouldRedrawClose: Boolean;
begin
  //inherited;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    shouldRedrawClose := (bsHover in Pnl.CloseBtnState) and (Pnl.HasCloseButton);
    ShouldRedraw := (csHover in Pnl.BtnState);
    exclude(Pnl.BtnState,csHover);
    if ShouldRedraw or shouldRedrawClose then
      PaintButton(Pnl);
  end;
  //repaint;
end;

procedure TCometPageView.PaintButton(Pnl: TCometPagePanel);
var
  TempBitmap: graphics.TBitmap;
  rc,rcCloseButton, TextRect: TRect;
begin
  TempBitmap := graphics.TBitmap.Create;
  TempBitmap.width := Pnl.BtnHitRect.right-Pnl.BtnHitRect.left;
  TempBitmap.height := FbuttonsHeight;
  TempBitmap.pixelformat := pf24Bit;

  TempBitmap.Canvas.Font.Name := Self.Font.Name;
  TempBitmap.Canvas.Font.Size := Self.Font.Size;
  TempBitmap.Canvas.Font.Style := Self.Font.Style;
  TempBitmap.Canvas.Font.Color := Self.Font.Color;
  TempBitmap.Canvas.Brush.Color := Self.Color;

  rc := rect(0,0,TempBitmap.width,TempBitmap.height);

  if Assigned(FOnPaintButton) then
    FOnPaintButton(Self,Pnl,TempBitmap.Canvas,rc);

  if Pnl.HasCloseButton then
  begin
    rcCloseButton := rect(rc.right-FCloseButtonLeftMargin,rc.top+FCloseButtonTopMargin,rc.right-FCloseButtonLeftMargin+FCloseButtonWidth,rc.top+FCloseButtonTopMargin+FCloseButtonHeight);

    if Assigned(FOnPaintCloseButton) then
      FOnPaintCloseButton(Self,Pnl,TempBitmap.Canvas,rcCloseButton);
  end;

  SetBkMode(TempBitmap.Canvas.Handle, TRANSPARENT);

  TextRect := rect(rc.left, 0,
    (rc.right-((FCloseButtonWidth+2)*Integer(Pnl.HasCloseButton)))-5, rc.bottom);


  Windows.ExtTextOutW(TempBitmap.Canvas.Handle, FButtonsLeftMargin + 1 +
    GlyphWidth(Pnl), FButtonsTopMargin, ETO_CLIPPED, @textRect,
    PwideChar(Pnl.BtnCaption),Length(Pnl.BtnCaption), nil);

  Canvas.lock;

  BitBlt(Canvas.handle,Pnl.BtnHitRect.left,Pnl.BtnHitRect.top,Pnl.BtnHitRect.right-Pnl.BtnHitRect.left,Pnl.BtnHitRect.bottom-Pnl.BtnHitRect.top,
    TempBitmap.Canvas.handle,0,0,SRCCopy);

  Canvas.unlock;

  TempBitmap.Free;
end;

procedure TCometPageView.SetButtonsHeight(value: Integer);
begin
  FButtonsHeight := value;
  Resize;
end;

procedure TCometPageView.SetButtonsLeft(value: Integer);
begin
  FButtonsLeft := value;
  Resize;
end;

procedure TCometPageView.SetButtonsLeftMargin(value: Integer);
begin
  FButtonsLeftMargin := value;
  FButtonsRightMargin := value;
  Resize;
end;

procedure TCometPageView.SetButtonsRightMargin(value: Integer);
begin
  FButtonsRightMargin := value;
  Resize;
end;


procedure TCometPageView.SetButtonsTopMargin(value: Integer);
begin
  FButtonsTopMargin := value;
  Resize;
end;

function TCometPageView.HasAnyDown: Boolean;
var
  i: Integer;
  Pnl: TCometPagePanel;
begin
  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    if (csDown in Pnl.BtnState) then
    begin
      Result := true;
      Exit;
    end;
  end;

  Result := False;
end;

procedure TCometPageView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw: Boolean;
begin
  //someDown := HasAnyDown;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];

    //if ((y>FButtonsHeight) or (y<FButtonsTopHitPoint)) then begin
    if ((y>Pnl.BtnHitRect.bottom) or (y<Pnl.BtnHitRect.top)) then
    begin
      ShouldRedraw := (csHover in Pnl.BtnState) or (csClicked in Pnl.BtnState);
      exclude(Pnl.BtnState,csHover);
      Exclude(Pnl.BtnState,csClicked);
      // if not (csClicked in Pnl.BtnState) then begin
      //  if Pnl.Panel<>nil then Pnl.Panel.Visible := false;
      // end;
      if ShouldRedraw then
        PaintButton(Pnl);
      continue;
    end;

    if ((x<Pnl.BtnHitRect.left) or
       (x>=Pnl.btnHitRect.Right)) then
    begin
      ShouldRedraw := (csHover in Pnl.BtnState) or (csClicked in Pnl.BtnState);
      exclude(Pnl.BtnState,csHover);
      Exclude(Pnl.BtnState,csClicked);
      // if not (csClicked in Pnl.BtnState) then begin
      // if Pnl.Panel<>nil then Pnl.Panel.Visible := false;
      // end;
      if ShouldRedraw then PaintButton(Pnl);
      continue;
    end;

    if (csClicked in Pnl.BtnState) then
    begin
      Exclude(Pnl.BtnState,csClicked);
      Include(Pnl.BtnState,csDown);
      ExcludeDowns(Pnl);
      ActivePage := i;
    end;

  end;

  if not HasAnyDown then
    ActivePage := 0;
end;

procedure TCometPageView.ExcludeDowns(ExceptPanel: TCometPagePanel);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw: Boolean;
begin
  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    if Pnl=ExceptPanel then continue;
    ShouldRedraw := (csDown in Pnl.BtnState);
    exclude(Pnl.BtnState,csDown);
    if ShouldRedraw then PaintButton(Pnl);
  end;
end;

procedure TCometPageView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw,shouldRedrawClose: Boolean;
begin
  //if y>FButtonsHeight then Exit;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];

    // if ((y>FButtonsHeight) or (y<FButtonsTopHitPoint)) then begin
    if ((y>Pnl.BtnHitRect.bottom) or (y<Pnl.BtnHitRect.top)) then
    begin
      shouldRedrawClose := (bsHover in Pnl.CloseBtnState) and (Pnl.HasCloseButton);
      ShouldRedraw := ((csHover in Pnl.BtnState) or (csClicked in Pnl.BtnState));
      exclude(Pnl.BtnState,csHover);
      exclude(Pnl.BtnState,csClicked);
      if ShouldRedraw or shouldRedrawClose then
        PaintButton(Pnl);
      //if Pnl.Panel<>nil then Pnl.Panel.Visible := false;
      continue;
    end;

    if ((x<Pnl.BtnHitRect.left) or
       (x>=Pnl.btnHitRect.Right)) then
    begin
      shouldRedrawClose := (bsHover in Pnl.CloseBtnState) and (Pnl.HasCloseButton);
      ShouldRedraw := ((csHover in Pnl.BtnState) or (csClicked in Pnl.BtnState));
      exclude(Pnl.BtnState,csHover);
      exclude(Pnl.BtnState,csClicked);
      if ShouldRedraw or shouldRedrawClose then
        PaintButton(Pnl);
      //if Pnl.Panel<>nil then Pnl.Panel.Visible := false;
      continue;
    end;

    if (Pnl.HasCloseButton) and (FActivePage=i) then
      if ((x>=Pnl.rcCloseButton.left) and (x<Pnl.rcCloseButton.right) and
        (y>=Pnl.rcCloseButton.top) and (y<=Pnl.rcCloseButton.Bottom)) then
      begin
        DeletePanel(i);
        break;
      end;

    if FSwitchOnDown then
    begin
      Exclude(Pnl.BtnState,csClicked);
      Include(Pnl.BtnState,csDown);
      ExcludeDowns(Pnl);
      ActivePage := i;
      break;
    end;

    ShouldRedraw := (not (csClicked in Pnl.BtnState));
    Include(Pnl.BtnState,csClicked);
    if ShouldRedraw then PaintButton(Pnl);
  end;

end;

procedure TCometPageView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  Pnl: TCometPagePanel;
  ShouldRedraw: Boolean;
  overCloseButton,shouldRedrawClose: Boolean;
begin
  //if y>FButtonsHeight then Exit;
  overCloseButton := false;
  shouldRedrawClose := false;

  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];

    if ((y>Pnl.BtnHitRect.bottom) or (y<Pnl.BtnHitRect.top)) then
    begin
      ShouldRedraw := (csHover in Pnl.BtnState);
      if Pnl.HasCloseButton then
      begin
        if (bsHover in Pnl.CloseBtnState) then
          ShouldRedraw := true;
        exclude(Pnl.CloseBtnState,bsHover);
      end;
      exclude(Pnl.BtnState,csHover);
      if ShouldRedraw then PaintButton(Pnl);
      continue;
    end;

    if ((x<Pnl.BtnHitRect.left) or
        (x>=Pnl.btnHitRect.Right)) then
    begin
      ShouldRedraw := (csHover in Pnl.BtnState);
      if Pnl.HasCloseButton then
      begin
        if (bsHover in Pnl.CloseBtnState) then
          ShouldRedraw := true;
        exclude(Pnl.CloseBtnState,bsHover);
      end;
      exclude(Pnl.BtnState,csHover);
      if ShouldRedraw then PaintButton(Pnl);
      continue;
    end;

   if (Pnl.HasCloseButton) and (FActivePage=i) then
   begin
     if ((x>=Pnl.rcCloseButton.left) and (x<Pnl.rcCloseButton.right) and
        (y>=Pnl.rcCloseButton.top) and (y<=Pnl.rcCloseButton.Bottom)) then
     begin
       overCloseButton := true;
       shouldRedrawClose := not (bsHover in Pnl.CloseBtnState);
       Include(Pnl.CloseBtnState,bsHover);
     end
     else
     begin
       overCloseButton := false;
       shouldRedrawClose := (bsHover in Pnl.CloseBtnState);
       exclude(Pnl.CloseBtnState,bsHover);
     end;
   end;

   ShouldRedraw := (not (csHover in Pnl.BtnState)) or (shouldRedrawClose);
   if not overCloseButton then
     Include(Pnl.BtnState,csHover);
   if ShouldRedraw then
     PaintButton(Pnl);
end;

end;

constructor TCometPageView.Create;
begin
  inherited;

  FOnPaintButtonFrame := nil;
  FOnPaintButton := nil;
  FOnPanelShow := nil;
  FOnPaintCloseButton := nil;
  FOnPanelClose := nil;

  FNumRows := 1;
  FWrappable := false;
  FTabsVisible := true;
  FHideTabsOnSigle := false;
  FDrawMargin := false;
  FButtonsTopHitPoint := 4;
  FHorizBtnSpacing := 4;
  FActivePage := 0;
  FButtonsLeft := 5;
  FButtonsLeftMargin := 10;
  FButtonsTopMargin := 8;
  FButtonsHeight := 30;
  FColorFrame := $00262423;
  FCloseButtonLeftMargin := 15;
  FCloseButtonTopMargin := 10;
  FCloseButtonWidth := 13;
  FCloseButtonHeight := 13;
  FSwitchOnDown := true;

  SetLength(FPanels,0);
end;

destructor TCometPageView.Destroy;
var
  i: Integer;
  Pnl: TCometPagePanel;
begin
  for i := 0 to High(FPanels) do
  begin
    Pnl := FPanels[i];
    Pnl.Free;
  end;
  SetLength(FPanels,0);

  inherited;
end;

function TCometPageView.GlyphWidth(Pnl: TCometPagePanel): Integer;
begin
  if (Pnl.imageIndex=-1) or (not Pnl.HasCloseButton) then
    Result := 0
  else
    Result := 18;
end;

procedure TCometPageView.CheckInvalidate;
begin
  if visible then
    invalidate;
end;

procedure TCometPageView.Paint;
var
 i: Integer;
 Pnl: TCometPagePanel;
 TempBitmap:Graphics.TBitmap;
 textrect: TRect;
begin

  if (csDesigning in componentState) then
  begin
    inherited;
    Exit;
  end;

  TempBitmap := nil;

  if FTabsVisible then
  begin
    TempBitmap := TBitmap.Create;
    TempBitmap.pixelformat := pf24Bit;

    TempBitmap.width := ClientWidth;
    TempBitmap.Height := FButtonsHeight*FNumRows;

    if Assigned(FOnPaintButtonFrame) then
      FOnPaintButtonFrame(Self,TempBitmap.Canvas,rect(0,0,TempBitmap.width,TempBitmap.Height));

    TempBitmap.Canvas.Font.Name := Self.Font.Name;
    TempBitmap.Canvas.Font.Size := Self.Font.Size;
    TempBitmap.Canvas.Font.Style := Self.Font.Style;
    TempBitmap.Canvas.Font.Color := Self.Font.Color;
    TempBitmap.Canvas.Brush.Color := Self.Color;


    for i := 0 to High(FPanels) do
    begin
      Pnl := FPanels[i];

      if Assigned(FOnPaintButton) then
        FOnPaintButton(Self,Pnl,TempBitmap.Canvas,Pnl.BtnHitRect);

      if Pnl.HasCloseButton then
        if Assigned(FOnPaintCloseButton) then
          FOnPaintCloseButton(Self,Pnl,TempBitmap.Canvas,Pnl.rcCloseButton);


      SetBkMode(TempBitmap.Canvas.Handle, TRANSPARENT);

      TextRect := rect(Pnl.BtnHitRect.left,
                    Pnl.BtnHitRect.top,
                    (Pnl.BtnHitRect.right-((FCloseButtonWidth+2)*Integer(Pnl.HasCloseButton)))-5,
                    Pnl.BtnHitRect.bottom);

      Windows.ExtTextOutW(TempBitmap.Canvas.Handle,
                         Pnl.BtnHitRect.left+FButtonsLeftMargin+1+GlyphWidth(Pnl),Pnl.BtnHitRect.top+FButtonsTopMargin,
                         ETO_CLIPPED, @textrect,
                         PwideChar(Pnl.BtnCaption),Length(Pnl.BtnCaption),
                         nil);

    end;
  end;  // endof FTabsVisible

  if FDrawMargin or FTabsVisible then
  begin
   Canvas.Lock;

    if FTabsVisible then BitBlt(Canvas.handle,0,0,TempBitmap.Width,TempBitmap.height,
         TempBitmap.Canvas.handle,0,0,SRCCopy);

    if FDrawMargin then begin
      Canvas.Brush.Color := FColorFrame;
      Canvas.frameRect(rect(-1,FbuttonsHeight,ClientWidth+1,clientheight+1));
    end;

    Canvas.Unlock;
  end;

 if TempBitmap<>nil then
   TempBitmap.Free;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCometPageView]);
end;

end.
