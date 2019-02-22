{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 }

{
Description:
misc functions
}

unit Utility_ares;

interface

uses
classes,graphics,windows,DSPack,sysutils,const_ares,comettrees,tntwindows,
CmtVerNfo,const_win_messages,registry,ShlObj,ares_objects,btcore,controls,
SHDocVw_TLB,MSHTML,activeX,classes2, Variants;


type
TOperatingSystem = (osUnknown, osWin95, osWin98, osWin98SE, osWinME, osWinNT, osWin2K, osWinXP, osWinVista);

function format_speedW(bytes_sec: Integer; AddKB:boolean = true): WideString;   // conversione da 31021 a 31.02K/sec

function CoCreateGuid(out guid: TGUID): HResult; stdcall; external 'ole32.dll';

function gettextwidth(strin: WideString; canvas: Tcanvas): Integer;
function aresmime_to_imgindexbig(tipo: Byte): Byte;
function get_program_version: string;
function is_idle_cursor(increment:boolean): Boolean;
procedure hash_update_GUIpry;
procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; DnData:precord_displayed_download); overload;
procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; Data:precord_displayed_bittorrentTransfer); overload;
procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; Data:btcore.precord_displayed_source); overload;

procedure draw_progress_tran(canvas: Tcanvas; cellrect: TRect; startp,endp,tot: Int64; overlayed:boolean);
procedure draw_3d_progressframe(targetcanvas: Tcanvas; cellrect: TRect; colorbg: Tcolor = clwhite);
function GetWinAMPCaption: STRING;
function my_buildnumber: Word;
function SystemErrorMessage: string;
function GetLastErrorText(): string;
function GetItemIdListFromPath (path: WideString; var lpItemIdList:PItemIdList): Boolean;
procedure draw_progressbarDownload(treeview: TCometTree; node:PCmtVNode; TargetCanvas: TCanvas; CellRect: TRect; fProgress: Int64; fsize: Int64; fcolor: TColor);
procedure draw_percentage(TargetCanvas: TCanvas; CellRect: TRect; FProgress: Int64; Fsize: Int64; var newLeft:integer);
procedure draw_progressbarBitTorrent(treeview: TCometTree; node:PCmtVNode; TargetCanvas: TCanvas; CellRect: TRect; fcolor: TColor; data:precord_displayed_bittorrentTransfer); overload;
procedure draw_progressbarBitTorrent(treeview: TCometTree; node:PCmtVNode; TargetCanvas: TCanvas; CellRect: TRect; fcolor: TColor; data:btcore.precord_displayed_source); overload;
procedure draw_3d_progress(acanvas: TCanvas; height: Integer; cellrect: TRect; progress: Int64; size: Int64);
procedure WaitProcessing(amount:integer);
procedure browser_go(const url: string);
procedure clear_treeview(treeview: TCometTree; lockUpdate:boolean=true);
function WinOpSys: TOperatingSystem;
function WinOpToStr(os: TOperatingSystem): string;
function floor(a : single) : word;
function ceiling(a : single) : word;
procedure resizeBitmap(source:graphics.TBitmap; destination:graphics.TBitmap);
procedure drawAvatarFrame(tmpBitmap:graphics.TBitmap; drawInner:boolean);
function IsConnectedToInternet(lpdwFlags: LPDWORD): Boolean;
function isInternetConnectionOk: Boolean;
procedure debuglog(const txt: string);
function GetHWndByPID(const hPID: THandle): THandle;

implementation

uses
 ufrmmain,vars_global,helper_unicode,vars_localiz,forms,helper_diskio,ares_types;

function GetHWndByPID(const hPID: THandle): THandle;
    type
    PEnumInfo = ^TEnumInfo;
    TEnumInfo = record
    HWND: THandle;
    ProcessID: DWORD;
  end;
    function GetWindowClassName(const aHWND: HWND): String;
    var
     buf: array [0..255] of Char;  // Tip: Use a more appropriately sized array
    begin
     GetClassName(aHWND, @buf, Length(buf));
     Result := buf;
   end;

    function EnumWindowsProc(Wnd: DWORD; var EI: TEnumInfo): Bool; stdcall;
    var
        PID: DWORD;
        className: string;
    begin
        GetWindowThreadProcessID(Wnd, @PID);
        Result := (PID <> EI.ProcessID);{ or
                (not IsWindowVisible(WND)) or
                (not IsWindowEnabled(WND)); }

        if PID = EI.ProcessID then begin
         className := GetWindowClassName(WND);
        
         if className='Tmainform'{.UnicodeClass'} then begin
          EI.HWND := WND; //break on return FALSE
          
         end else Result := True;
        end;
    end;



    function FindMainWindow(PID: DWORD): DWORD;
    var
        EI: TEnumInfo;
    begin
        EI.ProcessID := PID;
        EI.HWND := 0;
        EnumWindows(@EnumWindowsProc, Integer(@EI));
        Result := EI.HWND;
    end;

begin
    Result := FindMainWindow(hPID)
end;

procedure debuglog(const txt: string);
begin
  outputdebugstring(PChar(formatdatetime('hh:nn:ss',now)+' '+txt));
end;


function isInternetConnectionOk: Boolean;
const
  INTERNET_CONNECTION_MODEM = 1;
  INTERNET_CONNECTION_LAN = 2;
  INTERNET_CONNECTION_PROXY = 4;
  INTERNET_CONNECTION_MODEM_BUSY = 8;
var
  dwConnectionTypes:DWORD;
begin
try
 dwConnectionTypes := INTERNET_CONNECTION_MODEM +
                    INTERNET_CONNECTION_LAN +
                    INTERNET_CONNECTION_PROXY;
 Result := IsConnectedToInternet(@dwConnectionTypes);
except
result := True;
end;
end;

function IsConnectedToInternet(lpdwFlags: LPDWORD): Boolean;
var
 hWininetDLL: THandle;
 dwReserved:DWORD;
 fn_InternetGetConnectedState: function(lpdwFlags: LPDWORD; dwReserved: DWORD): BOOL; stdcall;
begin
  Result := False;
  try

  dwReserved := 0;
  hWininetDLL := LoadLibrary(const_ares.WininetDLL);
  if hWininetDLL>0 then begin
    @fn_InternetGetConnectedState := GetProcAddress(hWininetDLL,'InternetGetConnectedState');
     if Assigned(fn_InternetGetConnectedState) then begin
      Result := fn_InternetGetConnectedState(lpdwFlags, dwReserved);
     end else Result := True;
    FreeLibrary(hWininetDLL);
  end else begin
   Result := True;
  end;

  except
   Result := True;
  end;
end;

procedure drawAvatarFrame(tmpBitmap:graphics.TBitmap; drawInner:boolean);
begin
 tmpBitmap.width := 98;
 tmpBitmap.height := 98;
 //draw frame
 tmpBitmap.Canvas.pen.color := ufrmmain.ares_frmmain.Color;
 tmpBitmap.Canvas.rectangle(0,0,tmpBitmap.width,tmpBitmap.height);
 tmpBitmap.canvas.brush.color := clWhite;
 tmpBitmap.canvas.pen.color := clSilver;
 tmpBitmap.canvas.roundRect(0,0,tmpBitmap.width,tmpBitmap.height,5,5);
 if drawInner then begin
  tmpBitmap.canvas.pen.color := clWhite;
  tmpBitmap.canvas.roundRect(1,1,tmpBitmap.width-1,tmpBitmap.height-1,5,5);
 end;
end;

function floor(a : single) : word;
//return a rounded down to integer
begin
 Result := trunc(a);
end;

function ceiling(a : single) : word;
//return a rounded up to integer
begin
 Result := trunc(a);
 if frac(a) > 0.0001 then inc(result); //fix acces violation if small fraction
end;

procedure resizeBitmap(source:graphics.TBitmap; destination:graphics.TBitmap);
var
 sx1,sy1,sx2,sy2: Single;    //source field positions
 x,y: Word;                  //dest field pixels
 destR,destG,destB: Single;  //destination colors
 sR,sG,sB: Byte;             //source colors
 f,fi2: Single;
 i,j: Word;
 dx,dy,PC: Single;
 color:longInt;
 hi: Integer;
begin
 f := source.width / destination.Width;
 fi2 := 1/f;
 fi2 := fi2*fi2;
// destHeight := trunc(source.height/f);
//---
 hi := 0;
 for y := 0 to destination.height-1 do         //vertical destination pixels
  begin
   sy1 := f * y;
   sy2 := sy1 + f;



   for x := 0 to destination.width-1 do        //horizontal destination pixels
    begin

   inc(hi);
   if (hi mod 700)=0 then begin
    screen.cursor := crHourglass;
    application.processMessages;
   end else
   if (hi mod 666)=0 then begin
    screen.cursor := crDefault;
    application.processmessages;
   end;

     sx1 := f * x;
     sx2 := sx1 + f;
     destR := 0;
     destG := 0;
     destB := 0;       //clear colors
     for j := floor(sy1) to ceiling(sy2)-1 do  //vertical source pixels
      begin



       dy := 1;
       if sy1>j then dy := dy-(sy1-j);
       if sy2 < j+1 then dy := dy-(j+1-sy2);
       for i := floor(sx1) to ceiling(sx2)-1 do //horizontal source pixels
        begin



         dx := 1;
         if sx1>i then dx := dx-(sx1-i);
         if sx2<i+1 then dx := dx-(i+1-sx2);
         color := source.canvas.pixels[i,j];
         sR := color and $ff;
         sG := (color shr 8) and $ff;
         sB := (color shr 16) and $ff;
         PC := dx*dy*fi2;
         destR := destR + sR*PC;
         destG := destG + sG*PC;
         destB := destB + sB*PC;
        end; //for i
      end; //for j
      destination.Canvas.pixels[x,y] := RGB(trunc(destR),trunc(destG),trunc(destB));
    end; //for x
  end; //for y
 //destination.canvas.draw(0,0,bm2);
end;



function WinOpToStr(os: TOperatingSystem): string;
begin
case os of
 osWin95: Result := '95';
 osWin98: Result := '98';
 osWinMe: Result := 'ME';
 osWinNT: Result := 'NT';
 osWinXP: Result := 'XP';
 osWin2k: Result := '2000';
 osWinVista: Result := 'Vista';
 else Result := 'Unknown';
end;
end;

function WinOpSys: TOperatingSystem;
begin
if (Win32MajorVersion=4) and (Win32MinorVersion=0) and (Win32Platform=VER_PLATFORM_WIN32_WINDOWS) then Result := osWin95
 else
if (Win32MajorVersion=4) and (Win32MinorVersion=10) and (Win32Platform=VER_PLATFORM_WIN32_WINDOWS) then Result := osWin98
 else
if (Win32MajorVersion=4) and (Win32MinorVersion=90) and (Win32Platform=VER_PLATFORM_WIN32_WINDOWS) then Result := osWinMe
 else
if (Win32MajorVersion=4) and (Win32MinorVersion=0) and (Win32Platform=VER_PLATFORM_WIN32_NT) then Result := osWinNT
 else
if (Win32MajorVersion=5) and (Win32MinorVersion=1) and (Win32Platform=VER_PLATFORM_WIN32_NT) then Result := osWinXP
 else
if (Win32MajorVersion=5) and (Win32MinorVersion=0) and (Win32Platform=VER_PLATFORM_WIN32_NT) then Result := osWin2k
 else
if (Win32MajorVersion=6) and (Win32Platform=VER_PLATFORM_WIN32_NT) then Result := osWinVista
 else
 Result := osUnknown;
    {
    if Win98 then
      if Win32CSDVersion[1] := 'A' then  // use if desired
         Result := osWin98SE
     }
end;

procedure clear_treeview(treeview: TCometTree; lockUpdate:boolean);
begin
   if lockUpdate then treeview.BeginUpdate;

  // node := treeview.getfirst;
  // while (node<>nil) do begin
  //  treeview.Expanded[node] := True;
  //  node := treeview.getnext(node);
  // end;

   treeview.clear;

   if lockUpdate then treeview.endUpdate;

end;

procedure browser_go(const url: string);
begin
Tnt_ShellExecuteW(0,'open',pwidechar(widestring(url)),'','',SW_SHOWNORMAL);
end;

procedure WaitProcessing(amount:integer);
var
 done: Integer;
 app:forms.TApplication;
begin
 done := 0;

 app := TApplication.create(nil);
  while (done<amount) do begin
   app.processmessages;
   sleep(25);
   inc(done,25);
  end;
  
 app.destroy;
end;

procedure draw_percentage(TargetCanvas: TCanvas; CellRect: TRect; FProgress: Int64; Fsize: Int64; var newLeft:integer);
var
str_percent: string;
progressPerc:double;
ind: Integer;
begin


with targetcanvas do begin
   brush.style := bsclear;
   progressPerc := fprogress;
   
   if progressPerc>0 then begin
    if fsize=0 then progressPerc := 100 else begin
     progressPerc := progressPerc/fsize;
     progressPerc := progressPerc*100;
    end;
   end else progressPerc := 0;
   str_percent := FloatToStrF(progressPerc, ffNumber, 18, 2);
   delete(str_percent,pos('.',str_percent),length(stR_percent));
   str_percent := str_percent+'%';
   if length(str_percent)=2 then begin //0..9%
    ind := (textwidth('0'+str_percent)-textwidth(str_percent)) div 2;
    TextRect(cellrect,cellrect.left+ind,cellrect.Top+2,str_percent);
    cellrect.left := cellrect.left+(textwidth('0'+str_percent)+2);
   end else begin
    TextRect(cellrect,cellrect.left,cellrect.Top+2,str_percent);
    cellrect.left := cellrect.left+(textwidth(str_percent)+2);
   end;
 end;

newLeft := cellrect.left;
end;

procedure draw_progressbarBitTorrent(treeview: TCometTree; node:PCmtVNode;
 TargetCanvas: TCanvas; CellRect: TRect; fcolor: TColor;
 data:precord_displayed_bittorrentTransfer);

var
oldcolor,oldpencolor,colosf: Tcolor;
newLeft: Integer;
begin
with targetcanvas do begin

oldcolor := Brush.Color;
oldpencolor := pen.color;

 if vars_global.check_opt_tran_perc_checked then begin
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext
   else TargetCanvas.font.color := treeview.font.color;
  draw_percentage(TargetCanvas,CellRect,data^.downloaded,data^.Size,newLeft);
  Cellrect.left := newleft;
 end;

   if SETTING_3D_PROGBAR then begin
    if ((node.parent=treeview.RootNode) and
       ((node.Index mod 2)=0)) then colosf := treeview.BGColor
     else
     if node.parent<>treeview.RootNode then begin  //child uguale a root
        if (node.parent.Index mod 2)=0 then colosf := treeview.BGColor
         else colosf := treeview.Color;
     end else colosf := treeview.Color;
   draw_3d_progressframe(targetcanvas,cellrect,colosf);
  end;

 if data^.size=0 then exit;

 if data^.bitfield<>nil then
  if length(Data^.bitfield)>0 then
   draw_transfer_bitfield(targetcanvas, (CellRect.Bottom-cellrect.top)-5, CellRect, Data);

  brush.color := fcolor;
  pen.color := fcolor;
  if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
  draw_progress_tran(TargetCanvas,Rect(cellrect.left,cellrect.top+8,cellrect.Right,cellrect.bottom),0,data^.downloaded,data^.size,false);



  brush.color := oldcolor;
  pen.color := oldpencolor;
end;
end;

procedure draw_progressbarBitTorrent(treeview: TCometTree; node:PCmtVNode;
 TargetCanvas: TCanvas; CellRect: TRect; fcolor: TColor;
 data:btcore.precord_displayed_source);

var
oldcolor,oldpencolor,colosf: Tcolor;
newLeft: Integer;
begin
with targetcanvas do begin

oldcolor := Brush.Color;
oldpencolor := pen.color;

 if vars_global.check_opt_tran_perc_checked then begin
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext
   else TargetCanvas.font.color := treeview.font.color;
  draw_percentage(TargetCanvas,CellRect,data^.progress,100,newLeft);
  Cellrect.left := newleft;
 end;

   if SETTING_3D_PROGBAR then begin
    if ((node.parent=treeview.RootNode) and
       ((node.Index mod 2)=0)) then colosf := treeview.BGColor
     else
     if node.parent<>treeview.RootNode then begin  //child uguale a root
        if (node.parent.Index mod 2)=0 then colosf := treeview.BGColor
         else colosf := treeview.Color;
     end else colosf := treeview.Color;
   draw_3d_progressframe(targetcanvas,cellrect,colosf);
  end;

 if data^.size=0 then exit;

 if data^.VisualBitfield<>nil then
  if length(Data^.VisualBitfield.bits)>0 then
    draw_transfer_bitfield(targetcanvas, (CellRect.Bottom-cellrect.top)-5, CellRect, Data);

  brush.color := fcolor;
  pen.color := fcolor;
 {
  if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
  draw_progress_tran(TargetCanvas,Rect(cellrect.left,cellrect.top+8,cellrect.Right,cellrect.bottom),0,data^.downloaded,data^.size,false);
 }


  brush.color := oldcolor;
  pen.color := oldpencolor;
end;
end;

procedure draw_progressbarDownload(treeview: TCometTree; node:PCmtVNode; TargetCanvas: TCanvas; CellRect: TRect; fProgress: Int64; fsize: Int64; fcolor: TColor);
var
oldcolor,oldpencolor,colosf: Tcolor;
newLeft: Integer;
begin
with targetcanvas do begin

oldcolor := Brush.Color;
oldpencolor := pen.color;

 if vars_global.check_opt_tran_perc_checked then begin
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext
   else TargetCanvas.font.color := treeview.font.color;
  draw_percentage(TargetCanvas,CellRect,fProgress,FSize,newLeft);
  Cellrect.left := newleft;
 end;

  if SETTING_3D_PROGBAR then begin
    if ((node.parent=treeview.RootNode) and
       ((node.Index mod 2)=0)) then colosf := treeview.BGColor
     else
     if node.parent<>treeview.RootNode then begin  //child uguale a root
        if (node.parent.Index mod 2)=0 then colosf := treeview.BGColor
         else colosf := treeview.Color;
     end else colosf := treeview.Color;
   draw_3d_progressframe(targetcanvas,cellrect,colosf);
  end;

 if fsize=0 then exit;


  brush.color := fcolor;
  pen.color := fcolor;
  if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
  draw_progress_tran(TargetCanvas,cellrect,0,fprogress,fsize,false);


 brush.color := oldcolor;
 pen.color := oldpencolor;

 end;

end;

procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; Data:precord_displayed_bittorrentTransfer);
var
i,h: Integer;
xl,xr: Int64;
sizechunk: Int64;
wid: Integer;
offset,offset2: Int64;
col1: TColor;
rect: TRect;
begin
col1 := $00C08000; //$00446F23;
//col2 := $00C08000; //$0087B367;
//col3 := $00C08000; //$00579328;

wid := (cellrect.right-cellrect.left)-6;
//lenArray := length(Data^.BitField);
//LeftGlobal := cellrect.left+3;

acanvas.pen.Style := psSolid;
//if wid>lenArray then penWidth := (wid div LenArray)+1
// else penWidth := 1;

i := 0;
while (i<=high(Data^.BitField)) do begin
 if not Data^.BitField[i] then begin
  inc(i);
  continue;
 end;

 offset := int64(i)*int64(data^.FPieceSize);
 if i=high(Data^.BitField) then sizechunk := data^.size-offset
  else sizechunk := data^.FPieceSize;


  h := i+1;
  while (h<=high(Data^.BitField)) do begin
    if not Data^.BitField[h] then break;

     if h=high(Data^.BitField) then begin
      offset2 := int64(h)*int64(data^.FPieceSize);
      inc(sizechunk,data^.size-offset2);
     end else inc(sizechunk,int64(data^.FPieceSize));
     
      inc(h);
      i := h;
  end; 

 xl := ((int64(wid)*offset) div data^.size);
 xr := ((int64(wid)*(offset+sizechunk)) div data^.size);
 //x := (wid*i) div lenarray;
 //inc(x,leftGlobal);
 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := (cellrect.Left+3)+xr;
  bottom := (CellRect.bottom-3);
 end;
 aCanvas.Brush.color := col1;
 acanvas.FillRect(rect);
{
 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col2;
 acanvas.FillRect(rect);

 with rect do begin
  left := (cellrect.Left+3)+xl+1;
  top := (CellRect.bottom-3)-Height+1;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col3;
 acanvas.FillRect(rect);
   }
 inc(i);
end;

end;

procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; Data:btcore.precord_displayed_source);
var
i,h: Integer;
xl,xr: Int64;
sizechunk: Int64;
wid: Integer;
offset,offset2: Int64;
col1: TColor;
rect: TRect;
begin
col1 := $00C08000; //$00446F23;
//col2 := $00C08000; //$0087B367;
//col3 := $00C08000; //$00579328;

wid := (cellrect.right-cellrect.left)-6;
//lenArray := length(Data^.VisualBitfield.bits);
//LeftGlobal := cellrect.left+3;

acanvas.pen.Style := psSolid;
//if wid>lenArray then penWidth := (wid div LenArray)+1
// else penWidth := 1;

i := 0;
while (i<=high(Data^.VisualBitfield.bits)) do begin
 if not Data^.VisualBitfield.bits[i] then begin
  inc(i);
  continue;
 end;

 offset := int64(i)*int64(data^.FPieceSize);
 if i=high(Data^.VisualBitfield.bits) then sizechunk := data^.size-offset
  else sizechunk := int64(data^.FPieceSize);


  h := i+1;
  while (h<=high(Data^.VisualBitfield.bits)) do begin
    if not Data^.VisualBitfield.bits[h] then break;

     if h=high(Data^.VisualBitfield.bits) then begin
      offset2 := int64(h)*int64(data^.FPieceSize);
      inc(sizechunk,data^.size-offset2);
     end else inc(sizechunk,int64(data^.FPieceSize));
     
      inc(h);
      i := h;
  end; 

 xl := ((int64(wid)*offset) div data^.size);
 xr := ((int64(wid)*(offset+sizechunk)) div data^.size);
 //x := (wid*i) div lenarray;
 //inc(x,leftGlobal);
 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := (cellrect.Left+3)+xr;
  bottom := (CellRect.bottom-3);
 end;
 aCanvas.Brush.color := col1;
 acanvas.FillRect(rect);
{
 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col2;
 acanvas.FillRect(rect);

 with rect do begin
  left := (cellrect.Left+3)+xl+1;
  top := (CellRect.bottom-3)-Height+1;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col3;
 acanvas.FillRect(rect);
   }
 inc(i);
end;

end;

function GetItemIdListFromPath (path: WideString; var lpItemIdList:PItemIdList): Boolean;
var
pShellFolder:IShellFolder;
hr:HRESULT;
chused: Cardinal;
attr: Cardinal;
begin
result := False;
pShellFolder := nil;
   // Get desktop IShellFolder interface
   if SHGetDesktopFolder(pShellFolder)<>NOERROR then exit;
   // convert the path to an ITEMIDLIST
   hr := pShellFolder.ParseDisplayName(0,nil{0},pwidechar(path),chused,lpitemidlist,attr);
   if FAILED(hr) then begin
      lpItemIdList := nil;
      exit;
   end;
   Result := True;
end;

function GetLastErrorText(): string;
var
  dwSize: DWORD;
  lpszTemp: PAnsiChar;
begin
  dwSize := 512;
  lpszTemp := nil;
  try
    GetMem(lpszTemp, dwSize);
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ARGUMENT_ARRAY,
      nil,
      GetLastError(),
      LANG_NEUTRAL,
      lpszTemp,
      dwSize,
      nil)
  finally
    Result := lpszTemp;
    FreeMem(lpszTemp)
  end
end;

function SystemErrorMessage: string;
var
  P: PChar;
begin
  if FormatMessage(Format_Message_Allocate_Buffer+Format_Message_From_System,
                   nil,
                   GetLastError,
                   0,
                   @P,
                   0,
                   nil) <> 0 then begin
    Result := P;
    LocalFree(Integer(P))
  end else Result := '';
end;

function my_buildnumber: Word;
var
str_temp: string;
begin
str_temp := vars_global.versioneares;      //1.8.1.2927
 delete(str_temp,1,pos(chr(46){'.'},str_temp));
 delete(str_temp,1,pos(chr(46){'.'},str_temp));
 delete(str_temp,1,pos(chr(46){'.'},str_temp));
result := word(strtointdef(str_temp,0));
if result=0 then Result := DEFAULT_BUILD_NO;
end;

function GetWinAMPCaption: STRING;
VAR
Title: array [0..255] OF Char;
TitleS: string;
hwndWinAMP: Thandle;
begin
hwndWinAMP := FindWindow('Winamp v1.x', nil);
if not Boolean(SendMessage(hwndWinamp,WM_USER,0,0)) then exit;

GetWindowText(hwndWinAMP,@Title,sizeof(Title));
 IF Title <> '' THEN begin
  TitleS := Title;
  if pos('. ',TitleS)<>0 then TitleS := copy(TitleS,pos('. ',TitleS)+2,length(TitleS));
  if pos('- winamp',lowercase(TitleS))<>0 then delete(TitleS,pos('- winamp',lowercase(TitleS)),length(TitleS));
  Result := {inttostr(Integer(SendMessage(hwndWinamp,WM_USER,0,125))+1)+'. '+}TitleS;
 end;
end;

procedure draw_3d_progressframe(targetcanvas: Tcanvas; cellrect: TRect; colorbg: Tcolor = clwhite);
var rc: TRect;
begin
 with targetcanvas do begin
       pen.color := clbtnface;
       brush.color := clbtnface;
       rectangle(cellrect.Left,cellrect.Top,cellrect.right,cellrect.Bottom);


       brush.color := colorbg;
       pen.color := colorbg;
       rectangle(cellrect.Left+2,cellrect.Top+1,cellrect.right-2,cellrect.Bottom-1);



       brush.color := clgray;
       pen.color := clgray;
      rc.left := cellrect.left+2;     //top grigio
      rc.right := cellrect.right-3;
      rc.top := cellrect.top+1;
      rc.bottom := cellrect.top+2;
       fillrect(rc);            //left grigio
      rc.right := rc.left+1;
      rc.bottom := cellrect.bottom-2;
       fillrect(rc);
       brush.color := clbtnface;
       pen.color := clbtnface;
      rc.left := cellrect.left+2;
      rc.right := cellrect.right-3;
      rc.top := cellrect.bottom-3;
      rc.bottom := rc.top+1;
       fillrect(rc);      //intermedio down bottom btnface
      rc.left := rc.right-1;
      rc.top := cellrect.top+2;
      fillrect(rc);
 end;
end;

procedure draw_transfer_bitfield(acanvas: TCanvas; Height: Integer; CellRect: TRect; DnData:precord_displayed_download);
var
i,h: Integer;
xl,xr: Int64;
sizechunk: Int64;
wid: Integer;
offset,offset2: Int64;
col1,col2,col3: TColor;
rect: TRect;
begin
col1 := $00446F23;
col2 := $0087B367;
col3 := $00579328;
//acanvas.Pen.color := COLORE_PHASH_VERIFY;
//acanvas.brush.color := COLORE_PHASH_VERIFY;
wid := (cellrect.right-cellrect.left)-6;
//lenArray := length(DnData^.VisualBitField);
//LeftGlobal := cellrect.left+3;

acanvas.pen.Style := psSolid;
//if wid>lenArray then penWidth := (wid div LenArray)+1
// else penWidth := 1;

i := 0;
while (i<=high(DnData^.VisualBitField)) do begin
 if not DnData^.VisualBitField[i] then begin
  inc(i);
  continue;
 end;

 offset := int64(i)*int64(DnData^.FPieceSize);
 if i=high(DnData^.VisualBitField) then sizechunk := DnData^.size-offset
  else sizechunk := int64(DnData^.FPiecesize);


  h := i+1;
  while (h<=high(DnData^.VisualBitField)) do begin
    if not DnData^.VisualBitField[h] then break;

     if h=high(DnData^.VisualBitField) then begin
      offset2 := int64(h)*int64(DnData^.FPieceSize);
      inc(sizechunk,DnData^.size-offset2);
     end else inc(sizechunk,int64(DnData^.FPiecesize));
     
      inc(h);
      i := h;
  end;

 xl := ((int64(wid)*offset) div DnData^.size);
 xr := ((int64(wid)*(offset+sizechunk)) div DnData^.size);
 //x := (wid*i) div lenarray;
 //inc(x,leftGlobal);
 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := (cellrect.Left+3)+xr;
  bottom := (CellRect.bottom-3);
 end;
 aCanvas.Brush.color := col1;
 acanvas.FillRect(rect);

 with rect do begin
  left := (cellrect.Left+3)+xl;
  top := (CellRect.bottom-3)-Height;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col2;
 acanvas.FillRect(rect);

 with rect do begin
  left := (cellrect.Left+3)+xl+1;
  top := (CellRect.bottom-3)-Height+1;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col3;
 acanvas.FillRect(rect);

 inc(i);
end;

end;

procedure draw_3d_progress(acanvas: TCanvas; height: Integer; cellrect: TRect; progress: Int64; size: Int64);
var
xr: Int64;
col1,col2,col3: TColor;
wid: Integer;
rect: TRect;
begin
col1 := $00446F23;
col2 := $0087B367;
col3 := $00579328;

 wid := (cellrect.right-cellrect.left)-6;
 xr := ((wid*progress) div size);


 with rect do begin
  left := (cellrect.Left+3);
  top := (CellRect.bottom-3)-Height;
  right := (cellrect.Left+3)+xr;
  bottom := (CellRect.bottom-3);
 end;
 aCanvas.Brush.color := col1;
 acanvas.FillRect(rect);


 with rect do begin
  left := (cellrect.Left+3);
  top := (CellRect.bottom-3)-Height;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col2;
 acanvas.FillRect(rect);


 with rect do begin
  left := (cellrect.Left+3)+1;
  top := (CellRect.bottom-3)-Height+1;
  right := ((cellrect.Left+3)+xr)-1;
  bottom := (CellRect.bottom-3)-1;
 end;
 aCanvas.Brush.color := col3;
 acanvas.FillRect(rect);
end;

procedure draw_progress_tran(canvas: Tcanvas; cellrect: TRect; startp,endp,tot: Int64; overlayed:boolean);
var
larghezzatot: Int64;
puntoxr,puntoxl: Int64;
begin
try

larghezzatot := (cellrect.right-cellrect.left)-6;
if ((larghezzatot<1) or (tot<1)) then exit;

 puntoxl := ((larghezzatot*startp) div tot);
 puntoxr := ((larghezzatot*endp) div tot);


 if overlayed then begin
       with canvas do begin
        brush.color := COLOR_OVERLAY_UPLOAD;
        pen.color := COLOR_OVERLAY_UPLOAD;
         rectangle((cellrect.Left+3),cellrect.Top+2,(cellrect.right-3) ,cellrect.Bottom-3);
        brush.color := COLOR_PROGRESS_UP;
        pen.color := COLOR_PROGRESS_UP;
       end;
 end;

 if puntoxr-puntoxl<1 then exit;

 canvas.rectangle((cellrect.Left+3)+puntoxl,cellrect.Top+2,(cellrect.left+3)+ puntoxr ,cellrect.Bottom-3);
except
end;
end;

procedure hash_update_GUIpry;
begin
with ares_frmmain do begin
 case ares_frmmain.hash_pri_trx.position of
  0:lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_IDLE);
  1:lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_LOWERST);
  2:lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_LOWER);
  3:lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_NORMAL);
  4:lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_HIGHER);
   else lbl_hash_pri.caption := GetLangStringW(STR_HASH_PRIORITY)+': '+GetLangStringW(STR_HIGHEST);
 end;
end;
end;

function is_idle_cursor(increment:boolean): Boolean;
var
punto: TPoint;
begin
getcursorpos(punto);

 if ((vars_global.prev_cursorpos.x=punto.x) and (vars_global.prev_cursorpos.y=punto.y)) then begin
  if increment then begin
   inc(vars_global.minutes_idle);
  end;
 end else begin
  vars_global.minutes_idle := 0;
  vars_global.prev_cursorpos.x := punto.x;
  vars_global.prev_cursorpos.y := punto.y;
 end;

result := (vars_global.minutes_idle>=10);
end;

function aresmime_to_imgindexbig(tipo: Byte): Byte;
begin
 case tipo of
  0: Result := 6;      //oth
  1,2,4: Result := 1;  //audio
  3: Result := 5;     //soft
  5: Result := 3;     //video
  6: Result := 4
  else //document
  Result := 2;   //image
 end;
end;


function get_program_version: string;
var
exe: TCmtVerNfo;
fv: string;
begin
fv := 'FileVersion';
 try
   exe := tCmtVerNfo.create(nil);

   if exe.HaveVersionInfo then begin
      if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
          Result := string(exe.GetValue(fv));
      end else begin
         Result := exe.GetValue(fv);
      end;
   end else Result := ARES_VERS;
   exe.Free;

 except
  Result := ARES_VERS;
 end;

if length(result)<1 then Result := ARES_VERS;
end;

function format_speedW(bytes_sec: Integer; AddKB:boolean = true): WideString;   // conversion  31021 -> 31.02K/sec
var
kbytes:double;
begin
if bytes_sec<1 then begin
 if AddKB then Result := '0.00'+GetLangStringW(STR_KB_SEC)
  else Result := '0.00';
 exit;
end;

kbytes := bytes_sec;
kbytes := kbytes / KBYTE;
if AddKb then Result := FloatToStrF(kbytes, ffNumber, 18, 2)+GetLangStringW(STR_KB_SEC)
 else Result := FloatToStrF(kbytes, ffNumber, 18, 2);
end;

function gettextwidth(strin: WideString; canvas: Tcanvas): Integer;
var size: Tsize;
begin
result := 0;
try
  size.cX := 0;
  size.cY := 0;
  Windows.GetTextExtentPointW(canvas.handle, PwideChar(strin), Length(strin), size);
  Result := size.cx;
except
end;
end;




end.



