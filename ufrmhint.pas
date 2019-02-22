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
the 'bighint' window topmost and with an eyecandy transparency on 2k/XP platforms
}

unit ufrmhint;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,comettrees,messages,ares_types;

type
  Tfrmhint = class(tform)
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
  public
   posXgraph: Integer;
   posYgraph: Integer;
   GraphWidth: Integer;
   bitMapGraph: TBitmap;
   procedure appear;
   procedure blend;
  end;

var
  frmhint: Tfrmhint;


implementation

uses
ufrmmain,vars_global,utility_ares,helper_bighints,const_ares;

{$R *.DFM}

procedure tfrmhint.WMEraseBkgnd(Var Msg : TMessage);
begin
msg.result := 1;
end;


procedure Tfrmhint.FormCreate(Sender: TObject);
begin
alphablendvalue := 230;
alphablend := True;
posXgraph := 14;
GraphWidth := self.width-12;
bitMapGraph := TBitmap.create;
with bitMapGraph do begin
 pixelformat := pf24bit;
 width := self.width-2;
 height := 44;
end;

end;

procedure tfrmhint.appear;
var
  i: Integer;
begin

try

for i := 3 to 23 do begin
   alphablendvalue := i*10;
   sleep(8);
end;

except
end;
end;

procedure tfrmhint.blend;
begin
  alphablendvalue := 1;
end;

procedure Tfrmhint.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
punto,punto1: TPoint;
nodo:pCmtVnode;
src:precord_panel_search;
i: Integer;
begin
getcursorpos(punto);

try

if ares_frmmain.tabs_pageview.activepage=IDTAB_SEARCH then begin
 for i := 0 to src_panel_list.count-1 do begin
  src := src_panel_list[i];
  if src^.containerPanel<>ares_frmmain.pagesrc.activepanel then continue;

  punto1 := src^.listview.screentoclient(punto);
  nodo := src^.listview.GetNodeAt(punto1.x,punto1.y);
   if nodo<>nil then begin
    setwindowpos(ares_FrmMain.handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
     src^.listview.ClearSelection;
     src^.listview.Selected[nodo] := True;
   end;
  break;
 end;
end else
if ares_frmmain.tabs_pageview.activepage=IDTAB_LIBRARY then begin
 punto1 := ares_FrmMain.listview_lib.screentoclient(punto);
 nodo := ares_FrmMain.listview_lib.GetNodeAt(punto1.x,punto1.y);
 if nodo<>nil then begin
    setwindowpos(ares_FrmMain.handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
   ares_FrmMain.listview_lib.ClearSelection;
   ares_FrmMain.listview_lib.Selected[nodo] := True;

 end;
end else
if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then begin
 punto1 := ares_FrmMain.treeview_download.screentoclient(punto);
 nodo := ares_FrmMain.treeview_download.GetNodeAt(punto1.x,punto1.y);
 if nodo<>nil then begin
    setwindowpos(ares_FrmMain.handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
   ares_FrmMain.treeview_download.ClearSelection;
   ares_FrmMain.treeview_download.Selected[nodo] := True;
  end else begin
   punto1 := ares_FrmMain.treeview_upload.screentoclient(punto);
   nodo := ares_FrmMain.treeview_upload.GetNodeAt(punto1.x,punto1.y);
   if Nodo<>nil then begin
     setwindowpos(ares_FrmMain.handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
        ares_FrmMain.treeview_upload.ClearSelection;
        ares_FrmMain.treeview_upload.Selected[nodo] := True;
      end else begin
         punto1 := ares_FrmMain.treeview_queue.screentoclient(punto);
         nodo := ares_FrmMain.treeview_queue.GetNodeAt(punto1.x,punto1.y);
         if Nodo<>nil then begin
           setwindowpos(ares_FrmMain.handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOOWNERZORDER);
           ares_FrmMain.treeview_queue.ClearSelection;
           ares_FrmMain.treeview_queue.Selected[nodo] := True;
         end;

      end;
  end;
end;
except
end;
formhint_hide;
end;

procedure Tfrmhint.FormResize(Sender: TObject);
begin
GraphWidth := self.width-12;
BitMapGraph.width := self.width-2;
BitMapGraph.height := 44;
end;

procedure Tfrmhint.FormDestroy(Sender: TObject);
begin
bitMapGraph.Free;
end;

end.
