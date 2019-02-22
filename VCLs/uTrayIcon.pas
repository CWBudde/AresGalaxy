{*****************************************************************}
{ This is a component for placing icons in the notification area  }
{ of the Windows taskbar (aka. the traybar).                      }
{                                                                 }
{ The component is freeware. Feel free to use and improve it.     }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - delphiuser@get2net.dk                         }
{ Copyright (c) 2002                                              }
{                                                                 }
{ Portions by Jouni Airaksinen - mintus@codefield.com             }
{*****************************************************************}

unit uTrayIcon;

{$T-}  // Use untyped pointers as we override TNotifyIconData with TNotifyIconDataEx

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ExtCtrls, ComCtrls;

const
  // User-defined message sent by the trayicon
  WM_TRAYNOTIFY         = WM_USER + 1024;
  // Constants used for balloon hint feature
  _NIIF_NONE            = $00000000;
  _NIIF_INFO            = $00000001;
  _NIIF_WARNING         = $00000002;
  _NIIF_ERROR           = $00000003;
  _NIIF_ICON_MASK       = $0000000F;   // Reserved for WinXP
  _NIIF_NOSOUND         = $00000010;   // Reserved for WinXP
  // Events returned by balloon hint
  _NIN_BALLOONSHOW      = WM_USER + 2;
  _NIN_BALLOONHIDE      = WM_USER + 3;
  _NIN_BALLOONTIMEOUT   = WM_USER + 4;
  _NIN_BALLOONUSERCLICK = WM_USER + 5;
  // Additional uFlags constants for TNotifyIconDataEx
  _NIF_STATE            = $00000008;
  _NIF_INFO             = $00000010;
  _NIF_GUID             = $00000020;
  // Additional dwMessage constants for Shell_NotifyIcon
  _NIM_SETFOCUS         = $00000003;
  _NIM_SETVERSION       = $00000004;
  NOTIFYICON_VERSION    = 3;           // Used with the NIM_SETVERSION message

  const
  // Tooltip constants
  TOOLTIPS_CLASS = 'tooltips_class32';
  TTS_NOPREFIX = 2;

  { Tray notification definitions }

type
  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconDataW = ^TNotifyIconDataW;
  PNotifyIconData = PNotifyIconDataA;
  {$EXTERNALSYM _NOTIFYICONDATAA}
  _NOTIFYICONDATAA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..63] of AnsiChar;
  end;
  {$EXTERNALSYM _NOTIFYICONDATAW}
  _NOTIFYICONDATAW = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..63] of WideChar;
  end;
  {$EXTERNALSYM _NOTIFYICONDATA}
  _NOTIFYICONDATA = _NOTIFYICONDATAA;
  TNotifyIconDataA = _NOTIFYICONDATAA;
  TNotifyIconDataW = _NOTIFYICONDATAW;
  TNotifyIconData = TNotifyIconDataA;
  {$EXTERNALSYM NOTIFYICONDATAA}
  NOTIFYICONDATAA = _NOTIFYICONDATAA;
  {$EXTERNALSYM NOTIFYICONDATAW}
  NOTIFYICONDATAW = _NOTIFYICONDATAW;
  {$EXTERNALSYM NOTIFYICONDATA}
  NOTIFYICONDATA = NOTIFYICONDATAA;

  const
  {$EXTERNALSYM NIM_ADD}
  NIM_ADD         = $00000000;
  {$EXTERNALSYM NIM_MODIFY}
  NIM_MODIFY      = $00000001;
  {$EXTERNALSYM NIM_DELETE}
  NIM_DELETE      = $00000002;

  {$EXTERNALSYM NIF_MESSAGE}
  NIF_MESSAGE     = $00000001;
  {$EXTERNALSYM NIF_ICON}
  NIF_ICON        = $00000002;
  {$EXTERNALSYM NIF_TIP}
  NIF_TIP         = $00000004;

var
  WM_TASKBARCREATED: Cardinal;
  SHELL_VERSION: Integer;

type
  TTimeoutOrVersion = record
    case Integer of          // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT);   // Only used when sending a NIM_SETVERSION message
  end;

  { You can use the TNotifyIconData record structure defined in shellapi.pas.
    However, WinME, Win2000, and WinXP have expanded this structure, so in
    order to implement their new features we define a similar structure,
    TNotifyIconDataEx. }
  { The old TNotifyIconData record contains a field called Wnd in Delphi
    and hWnd in C++ Builder. The compiler directive DFS_CPPB_3_UP was used
    to distinguish between the two situations, but is no longer necessary
    when we define our own record, TNotifyIconDataEx. }
  TNotifyIconDataEx = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
{$IFDEF _WIN32_IE_600}
    guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
{$ENDIF}
  end;

  TBalloonHintIcon = (bitNone, bitInfo, bitWarning, bitError);
  TBalloonHintTimeOut = 10..60;   // Windows defines 10-60 secs. as min-max

//  THintString = String[127];      // 128 bytes, last char should be #0
  THintString = ShortString;      // 128 bytes, last char should be #0

  TCycleEvent = procedure(Sender: TObject; NextIndex: Integer) of object;
  TStartupEvent = procedure(Sender: TObject; var ShowMainForm: Boolean) of object;
 // TEndSessionEvent = procedure(Sender: TObject) of object;

  TTrayIcon = class(TComponent)
  private
    FEnabled: Boolean;
    FIcon: TIcon;
    FIconID: Cardinal;
    FIconVisible: Boolean;
    FHint: wideString;
    FShowHint: Boolean;
    FPopupMenu: TPopupMenu;
    FOnDblClick: TNotifyEvent;
    FOnStartup: TStartupEvent;
    FMinimizeToTray: Boolean;
    FClickReady: Boolean;
    IsDblClick: Boolean;
    FDesignPreview: Boolean;
    SettingPreview: Boolean;           // Internal status flag
    SettingMDIForm: Boolean;           // Internal status flag
    Fhandle:HWND;
    FHandle_main:HWND;
    //FOnEndSession: TEndSessionEvent;
    procedure SetDesignPreview(Value: Boolean);
    function InitIcon: Boolean;
    procedure SetIcon(Value: TIcon);
    procedure SetIconVisible(Value: Boolean);
    procedure SetHint(Value: wideString);
    procedure SetShowHint(Value: Boolean);
    procedure IconChanged(Sender: TObject);
    function IsWinNT: Boolean;
  protected
    IconDataW: TNotifyIconDataW;//TNotifyIconDataEx;       // Data of the tray icon wnd.
    IconDataA: TNotifyIconDataEx;       // Data of the tray icon wnd.
    procedure Loaded; override;
    function LoadDefaultIcon: Boolean; virtual;
    function ShowIcon: Boolean; virtual;
    function HideIcon: Boolean; virtual;
    function ModifyIcon: Boolean; virtual;
    procedure DblClick; dynamic;
    procedure DoMinimizeToTray; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
     //determiniamo quando windows vuole chiderci!
    //property HandleW: HWND read IconDataW.Wnd;
    //property HandleA: HWND read IconDataA.Wnd;
    property Handle: HWND read Fhandle;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Refresh: Boolean;
    procedure PopupAtCursor;
    function BitmapToIcon(const Bitmap: TBitmap; const Icon: TIcon;
      MaskColor: TColor): Boolean;
    function GetClientIconPos(X, Y: Integer): TPoint;
    //function GetTooltipHandle: HWND;
    //----- SPECIAL: methods that only apply when owner is a form -----
    procedure ShowMainForm;
    procedure HideMainForm;
    //----- END SPECIAL -----
  published
    // Properties:
    property DesignPreview: Boolean read FDesignPreview write SetDesignPreview default False;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Hintw: wideString read FHint write SetHint;
    property ShowHint: Boolean read FShowHint write SetShowHint default True;
    property Icon: TIcon read FIcon write SetIcon;
    property IconVisible: Boolean read FIconVisible write SetIconVisible
      default False;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    //----- SPECIAL: properties that only apply when owner is a form -----
    property MinimizeToTray: Boolean read FMinimizeToTray write FMinimizeToTray
      default False;             // Minimize main form to tray when minimizing?
    //----- END SPECIAL -----
    // Events:
   // property OnEndSession: TEndSessionEvent read FOnEndSession write FOnEndSession;
    property handle_main:hwnd read FHandle_main write FHandle_main default 0;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    //----- SPECIAL: events that only apply when owner is a form -----
   // property OnStartup: TStartupEvent read FOnStartup write FOnStartup;
    //----- END SPECIAL -----
  end;

  type
  TTrayIconHandler = class(TObject)
  private
    RefCount: Cardinal;
    FHandle: HWND;
    Cool: TTrayIcon;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add;
    procedure Remove;
    procedure HandleIconMessage(var Msg: TMessage);
  end;

 var
  TrayIconHandler: TTrayIconHandler = nil;
  WinNT: Boolean = False;              // For Win NT
  HComCtl32: Cardinal = $7FFFFFFF;     // For Win NT
  shellwd:hwnd;

{$EXTERNALSYM Shell_NotifyIcon}
Shell_NotifyIcon: function (dwMessage: DWORD; lpData: PNotifyIconData): BOOL; stdcall;
{$EXTERNALSYM Shell_NotifyIconW}
Shell_NotifyIconW: function (dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL; stdcall;

procedure Register;
  
implementation


{------------------ TTrayIconHandler ------------------}

constructor TTrayIconHandler.Create;
begin
  inherited Create;
  RefCount := 0;
  FHandle := Classes.AllocateHWnd(HandleIconMessage);
end;


destructor TTrayIconHandler.Destroy;
begin
  Classes.DeallocateHWnd(FHandle);     // Free the tray window
  inherited Destroy;
end;


procedure TTrayIconHandler.Add;
begin
  Inc(RefCount);
end;


procedure TTrayIconHandler.Remove;
begin
  if RefCount > 0 then Dec(RefCount);
end;


{ HandleIconMessage handles messages that go to the shell notification
  window (tray icon) itself. Most messages are passed through WM_TRAYNOTIFY.
  In these cases we use lParam to get the actual message, eg. WM_MOUSEMOVE.
  The method fires the appropriate event methods like OnClick and OnMouseMove. }

{ The message always goes through the container, TrayIconHandler.
  Msg.wParam contains the ID of the TTrayIcon instance, which we stored
  as the object pointer Self in the TTrayIcon constructor. It is therefore
  safe to cast wParam to a TTrayIcon instance. }

procedure TTrayIconHandler.HandleIconMessage(var Msg: TMessage);

  function ShiftState: TShiftState;
  // Return the state of the shift, ctrl, and alt keys
  begin
    Result := [];
    if GetAsyncKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
    if GetAsyncKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
    if GetAsyncKeyState(VK_MENU) < 0 then Include(Result, ssAlt);
  end;

var
  Shift: TShiftState;
  I: Integer;
  M: TMenuItem;
  InitComCtl32: procedure;
begin
  if Msg.Msg = WM_TRAYNOTIFY then
  // Take action if a message from the tray icon comes through
  begin
    with TTrayIcon(Msg.wParam) do  // Cast to a TTrayIcon instance
    begin
      case Msg.lParam of

        WM_RBUTTONDOWN:
          if FEnabled then begin
            Shift := ShiftState + [ssRight];
            PopupAtCursor;
          end;

        WM_LBUTTONDBLCLK:
          if FEnabled then begin
            FClickReady := False;
            IsDblClick := True;
            DblClick;
            { Handle default menu items. But only if LeftPopup is false, or it
              will conflict with the popupmenu, when it is called by a click event. }
            M := nil;
            if Assigned(FPopupMenu) then
              if FPopupMenu.AutoPopup then
                for I := PopupMenu.Items.Count -1 downto 0 do begin
                  if PopupMenu.Items[I].Default then M := PopupMenu.Items[I];
                end;
            if M <> nil then M.Click;
          end;

      end;
    end;
  end

  else             // Messages that didn't go through the icon
    case Msg.Msg of
      WM_USERCHANGED:
        if WinNt then begin
          // Special handling for Win NT: Load/unload common controls library
          if HComCtl32 = 0 then begin
            // Load and initialize common controls library
            HComCtl32 := LoadLibrary('comctl32.dll');
            { We load the entire dll. This is probably unnecessary.
              The InitCommonControlsEx method may be more appropriate. }
            InitComCtl32 := GetProcAddress(HComCtl32, 'InitCommonControls');
            InitComCtl32;
          end else begin
            // Unload common controls library (if it is loaded)
            if HComCtl32 <> $7FFFFFFF then FreeLibrary(HComCtl32);
            HComCtl32 := 0;
          end;
          Msg.Result := 1;
        end;

    else      // Handle all other messages with the default handler
      Msg.Result := DefWindowProc(FHandle, Msg.Msg, Msg.wParam, Msg.lParam);
    end;
end;

{---------------- Container management ----------------}

procedure AddTrayIcon(value: TTrayIcon);
begin
  if not Assigned(TrayIconHandler) then
    // Create new handler
    TrayIconHandler := TTrayIconHandler.Create;

  TrayIconHandler.cool:=value;
  TrayIconHandler.Add;
end;

procedure RemoveTrayIcon;
begin
  if Assigned(TrayIconHandler) then
  begin
    TrayIconHandler.Remove;
    if TrayIconHandler.RefCount = 0 then
    begin
      // Destroy handler
      TrayIconHandler.Free;
      TrayIconHandler := nil;
    end;
  end;
end;

{------------------- TTrayIcon --------------------}

constructor TTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WinNT:=isWinNT;

  AddTrayIcon(self);               // Container management
  FIconID := Cardinal(Self); // Use Self object pointer as ID

  SettingMDIForm := True;
  FEnabled := True;          // Enabled by default
  FShowHint := True;         // Show hint by default
  SettingPreview := False;
  FIcon := TIcon.Create;
  FIcon.OnChange := IconChanged;

  if WinNT then
  begin
     FillChar(IconDataW, SizeOf(IconDataW), 0);
     IconDataW.cbSize := SizeOf(TNotifyIconDataW);//TNotifyIconDataEx);
    { IconData.hWnd points to procedure to receive callback messages from the icon.
      We set it to our TrayIconHandler instance. }
     IconDataW.Wnd := TrayIconHandler.FHandle;
    // Add an id for the tray icon
     IconDataW.uId := FIconID;
    // We want icon, message handling, and tooltips by default
     IconDataW.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
    // Message to send to IconData.hWnd when event occurs
    IconDataW.uCallbackMessage:=WM_TRAYNOTIFY;
    Fhandle:=IconDataW.Wnd;
  end
  else
  begin
      FillChar(IconDataA, SizeOf(TnotifyIconDataW), 0);
      IconDataA.cbSize := SizeOf(TnotifyIconDataEx);
      IconDataA.hWnd:= TrayIconHandler.FHandle;
      IconDataA.uId := FIconID;
      IconDataA.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
      IconDataA.uCallbackMessage:=WM_TRAYNOTIFY;
    Fhandle:=IconDataA.hWnd;
  end;

  SetDesignPreview(false);
end;

destructor TTrayIcon.Destroy;
begin
  try
    SetIconVisible(False);        // Remove the icon from the tray
    SetDesignPreview(False);      // Remove any DesignPreview icon
    try
      FIcon.Free;
    except
      on Exception do
        // Do nothing; the icon seems to be invalid
    end;
  finally
    // It is important to unhook any hooked processes
    RemoveTrayIcon;               // Container management
    inherited Destroy;
  end
end;

procedure TTrayIcon.Loaded;
{ This method is called when all properties of the component have been
  initialized. The method SetIconVisible must be called here, after the
  tray icon (FIcon) has loaded itself. Otherwise, the tray icon will
  be blank (no icon image).
  Other boolean values must also be set here. }
var
  Show: Boolean;
begin
  inherited Loaded;          // Always call inherited Loaded first

  if Owner is TWinControl then
    if not (csDesigning in ComponentState) then begin
      Show := True;
      if Assigned(FOnStartup) then FOnStartup(Self, Show);
      if not Show then begin
        Application.ShowMainForm := False;
        HideMainForm;
      end;
    end;

  ModifyIcon;
  SetIconVisible(FIconVisible);
end;

function TTrayIcon.LoadDefaultIcon: Boolean;
{ This method is called to determine whether to assign a default icon to
  the component. Descendant classes (like TextTrayIcon) can override the
  method to change this behavior. }
begin
  Result := True;
end;

procedure TTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // Check if either the imagelist or the popup menu is about to be deleted
  if (AComponent = PopupMenu) and (Operation = opRemove) then begin
    FPopupMenu := nil;
    PopupMenu := nil;
  end;
end;

procedure TTrayIcon.IconChanged(Sender: TObject);
begin
  ModifyIcon;
end;

{ For MinimizeToTray to work, we need to know when the form is minimized
  (happens when either the application or the main form minimizes).
  The straight-forward way is to make TTrayIcon trap the
  Application.OnMinimize event. However, if you also make use of this
  event in the application, the OnMinimize code used by TTrayIcon
  is discarded.
  The solution is to hook into the app.'s message handling (via HookApp).
  You can then catch any message that goes through the app. and still
  use the OnMinimize event. }


{ All app. messages pass through HookAppProc. You can override the messages
  by not passing them along to Windows (via CallWindowProc). }

{ You can hook into the main form (or any other window) just as easily as
  hooking into the app., allowing you to handle any message that window processes.
  This is necessary in order to properly handle when the user minimizes the form
  using the TASKBAR icon. }



{ All main form messages pass through HookFormProc. You can override the
  messages by not passing them along to Windows (via CallWindowProc).
  You should be careful with the graphical messages, though. }

procedure TTrayIcon.SetIcon(Value: TIcon);
begin
  FIcon.OnChange := nil;
  FIcon.Assign(Value);
  FIcon.OnChange := IconChanged;
  ModifyIcon;
end;

procedure TTrayIcon.SetIconVisible(Value: Boolean);
begin
  if Value then ShowIcon
   else HideIcon;
end;

procedure TTrayIcon.SetDesignPreview(Value: Boolean);
begin
  FDesignPreview := Value;
  SettingPreview := True;         // Raise flag
   {Assign a default icon if Icon property is empty. This will assign
    an icon to the component when it is created for the very first time.
    When the user assigns another icon it will not be overwritten next
    time the project loads. HOWEVER, if the user has decided explicitly
    to have no icon a default icon will be inserted regardless.
    I figured this was a tolerable price to pay. }
  if (csDesigning in ComponentState) then
    if FIcon.Handle = 0 then
      if LoadDefaultIcon then
        FIcon.Handle := LoadIcon(0, IDI_WINLOGO);
   {It is tempting to assign the application's icon (Application.Icon)
    as a default icon. The problem is there's no Application instance
    at design time. Or is there? Yes there is: the Delphi editor!
    Application.Icon is the icon found in delphi32.exe. How to use:
      FIcon.Assign(Application.Icon);
    Seems to work, but I don't recommend doing it. }
  SetIconVisible(Value);
  SettingPreview := False;        // Clear flag
end;

procedure TTrayIcon.SetHint(Value: wideString);
begin
  FHint := Value;
  ModifyIcon;
end;

procedure TTrayIcon.SetShowHint(Value: Boolean);
begin
  FShowHint := Value;
  ModifyIcon;
end;

function TTrayIcon.InitIcon: Boolean;
// Set icon and tooltip
var
  ok: Boolean;
  i: integer;
  str: string;
begin
  Result := False;
  ok := True;
  if (csDesigning in ComponentState) then
    ok := ((SettingPreview) or (FDesignPreview));

  if WinNT then
  begin
    if ok then
    begin
      try
        IconDataW.hIcon := FIcon.Handle;
      except
        on EReadError do begin
          IconDataW.hIcon := 0;
  //        Exit;
        end;
      end;

      if (FHint <> '') and (FShowHint) then begin
       if length(Fhint)>63 then delete(FHint,64,length(FHint));
        for i:=0 to 63 do icondataW.szTip[i]:=#0;
         move(Fhint[1],icondataW.sztip,length(Fhint)*sizeof(widechar));
      end else begin
        for i:=0 to 63 do icondataW.szTip[i]:=#0;
      end;
      Result := True;
    end;
  end
  else
  begin//win98
    if ok then
    begin
      try
        IconDataA.hIcon := FIcon.Handle;
      except
        on EReadError do begin
          IconDataA.hIcon := 0;
        end;
      end;

      if (FHint <> '') and (FShowHint) then begin
       //if length(Fhint)>63 then delete(FHint,64,length(FHint));
        //for i:=0 to 63 do icondataA.szTip[i]:=#0;
        str:=FHint;
        StrLCopy(IconDataA.szTip, PAnsiChar(String(str)), SizeOf(IconDataA.szTip) - 1);
        //Fhint:=strpas(str);
        //move(str[1],icondataA.szTip,length(str));
      end else begin
       IconDataA.szTip := '';
       // for i:=0 to 63 do icondataA.szTip[i]:=#0;  //azzeriamo
      end;
      Result := True;
    end;
  end;
end;

function TTrayIcon.ShowIcon: Boolean;
// Add/show the icon on the tray
begin
  Result := False;
  if not SettingPreview then FIconVisible := True;
  begin
      if InitIcon then begin
         if WinNT then begin
          if @Shell_NotifyIconW<>nil then Result:=Shell_NotifyIconW(NIM_ADD,@IconDataW);
         end else begin
          if @Shell_NotifyIcon<>nil then Result:=Shell_NotifyIcon(NIM_ADD,@IconDataA);
         end;
      end;
  end;
end;

function TTrayIcon.HideIcon: Boolean;
// Remove/hide the icon from the tray
begin
  Result := False;
  if not SettingPreview then FIconVisible := False;
  begin
    if InitIcon then begin
      if WinNT then begin
       if @Shell_NotifyIconW<>nil then Result:=Shell_NotifyIconW(NIM_DELETE, @IconDataW);
      end else begin
       if @Shell_NotifyIcon<>nil then Result:=Shell_NotifyIcon(NIM_DELETE, @IconDataA);
      end;
    end;
  end;
end;

function TTrayIcon.ModifyIcon: Boolean;
// Change icon or tooltip if icon already placed
begin
  Result := False;    
  if InitIcon then begin
     if WinNT then begin
       if @Shell_NotifyIconW<>nil then Result:=Shell_NotifyIconW(NIM_MODIFY, @IconDataW);
     end else begin
       if @Shell_NotifyIcon<>nil then Result:=Shell_NotifyIcon(NIM_MODIFY, @IconDataA);
     end;
  end;
end;

function TTrayIcon.BitmapToIcon(const Bitmap: TBitmap;
  const Icon: TIcon; MaskColor: TColor): Boolean;
{ Render an icon from a 16x16 bitmap. Return false if error.
  MaskColor is a color that will be rendered transparently. Use clNone for
  no transparency. }
var
  BitmapImageList: TImageList;
begin
  BitmapImageList := TImageList.CreateSize(16, 16);
  try
    Result := False;
    BitmapImageList.AddMasked(Bitmap, MaskColor);
    BitmapImageList.GetIcon(0, Icon);
    Result := True;
  finally
    BitmapImageList.Free;
  end;
end;

function TTrayIcon.GetClientIconPos(X, Y: Integer): TPoint;
// Return the cursor position inside the tray icon
const
  IconBorder = 1;
//  IconSize = 16;
var
  H: HWND;
  P: TPoint;
  IconSize: Integer;
begin
{ The CoolTrayIcon.Handle property is not the window handle of the tray icon.
  We can find the window handle via WindowFromPoint when the mouse is over
  the tray icon. (It can probably be found via GetWindowLong as well).

  BTW: The parent of the tray icon is the TASKBAR - not the traybar, which
  contains the tray icons and the clock. The traybar seems to be a canvas,
  not a real window (?). }

  // Get the icon size
  IconSize := GetSystemMetrics(SM_CYCAPTION) - 3;

  P.X := X;
  P.Y := Y;
  H := WindowFromPoint(P);
  { Convert current cursor X,Y coordinates to tray client coordinates.
    Add borders to tray icon size in the calculations. }
  Windows.ScreenToClient(H, P);
  P.X := (P.X mod ((IconBorder*2)+IconSize)) -1;
  P.Y := (P.Y mod ((IconBorder*2)+IconSize)) -1;
  Result := P;
end;

function TTrayIcon.Refresh: Boolean;
// Refresh the icon
begin
  Result := ModifyIcon;
end;

procedure TTrayIcon.PopupAtCursor;
var
  CursorPos: TPoint;
begin
  if Assigned(PopupMenu) then
    if PopupMenu.AutoPopup then
      if GetCursorPos(CursorPos) then begin
        // Bring the main form (or its modal dialog) to the foreground
        SetForegroundWindow(Application.Handle);
        { Win98 (unlike other Windows versions) empties a popup menu before
          closing it. This is a problem when the menu is about to display
          while it already is active (two click-events in succession). The
          menu will flicker annoyingly. Calling ProcessMessages fixes this. }
        Application.ProcessMessages;
        // Now make the menu pop up
        PopupMenu.PopupComponent := Self;
        PopupMenu.Popup(CursorPos.X, CursorPos.Y);
        // Remove the popup again in case user deselects it
        if Owner is TWinControl then   // Owner might be of type TService
          // Post an empty message to the owner form so popup menu disappears
          PostMessage((Owner as TWinControl).Handle, WM_NULL, 0, 0)
{
        else
          // Owner is not a form; send the empty message to the app.
          PostMessage(Application.Handle, WM_NULL, 0, 0);
}
      end;
end;


procedure TTrayIcon.DblClick;
begin
  // Execute user-assigned method
  if Assigned(FOnDblClick) then  FOnDblClick(Self);
end;

function TTrayIcon.IsWinNT: Boolean;
var
  ovi: TOSVersionInfo;
  rc: Boolean;
begin
  rc := False;
  ovi.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(ovi) then
  begin
    rc := (ovi.dwPlatformId = VER_PLATFORM_WIN32_NT) ;//and (ovi.dwMajorVersion <= 4);
  end;
  Result := rc;
end;

procedure TTrayIcon.DoMinimizeToTray;
begin
  // Override this method to change automatic tray minimizing behavior
  HideMainForm;
  IconVisible := True;
end;

procedure TTrayIcon.ShowMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then begin
      // Show application's TASKBAR icon (not the tray icon)
      ShowWindow(Application.Handle, SW_RESTORE);
//        ShowWindow(Application.Handle, SW_SHOWNORMAL);
//        Application.Restore;
      // Show the form itself
      Application.MainForm.Visible := True;
//        ShowWindow((Owner as TWinControl).Handle, SW_RESTORE);
      if Application.MainForm.WindowState = wsMinimized then
        Application.MainForm.WindowState := wsNormal;
      // Bring the main form (or its modal dialog) to the foreground
      SetForegroundWindow(Application.Handle);
    end;
end;

procedure TTrayIcon.HideMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then begin
      // Hide the form itself (and thus any child windows)
      Application.MainForm.Visible := False;
      { Hide application's TASKBAR icon (not the tray icon). Do this AFTER
        the mainform is hidden, or any child windows will redisplay the
        taskbar icon if they are visible. }
      ShowWindow(Application.Handle, SW_HIDE);
    end;
end;


procedure Register;
begin
  RegisterComponents('Comet', [TTrayIcon]);
end;

initialization
  Shell_NotifyIcon:=nil;
  Shell_NotifyIconW:=nil;

  shellwd := LoadLibrary('shell32.dll');
  if shellwd<>0 then
  begin
    Shell_NotifyIcon:=GetProcAddress(shellwd,'Shell_NotifyIconA');
    Shell_NotifyIconW:=GetProcAddress(shellwd,'Shell_NotifyIconW');
  end;

  // Get shell version
  SHELL_VERSION := GetComCtlVersion;
  // Use the TaskbarCreated message available from Win98/IE4+
  if SHELL_VERSION >= ComCtlVersionIE4 then
    WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');

finalization
  if Assigned(TrayIconHandler) then
  begin
    // Destroy handler
    TrayIconHandler.Free;
    TrayIconHandler := nil;
  end;

end.
