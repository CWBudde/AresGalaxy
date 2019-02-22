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
shows status of the AVI rebuild and/or file preview copy progress
}

unit ufrmpreview;

interface

uses
  Windows, {Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,const_ares, TntStdCtrls,tntforms,helper_unicode,vars_localiz;

type
  Tfrmpreview = class(TTntForm)
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    btn_open: TTntButton;
    btn_cancel: TTntButton;
    procedure btn_cancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_openClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
  private
    fcancella: Boolean;
    fokstop: Boolean;
  public
    property cancella:boolean read fcancella write fcancella;
    property okstop:boolean read fokstop write fokstop;
  end;

var
  frmpreview: Tfrmpreview;

implementation

uses utility_ares, ufrmmain;
{$R *.DFM}

procedure Tfrmpreview.btn_cancelClick(Sender: TObject);
begin
visible := False;
cancella := True;
end;

procedure Tfrmpreview.FormCreate(Sender: TObject);
begin
cancella := False;
okstop := False;
btn_cancel.onclick := btn_cancelClick;
btn_open.onclick := btn_openClick;
try
formstyle := fsStayOnTop;
except
end;
end;

procedure Tfrmpreview.btn_openClick(Sender: TObject);
begin
okstop := True;
end;

procedure Tfrmpreview.TntFormShow(Sender: TObject);
begin
 font := ares_FrmMain.font;
btn_cancel.caption := GetLangStringW(STR_CANCEL);
btn_open.caption := GetLangStringW(STR_OKOPENIT);
caption := GetLangStringW(STR_COPYINGFILE);
end;

procedure Tfrmpreview.TntFormResize(Sender: TObject);
begin
btn_cancel.left := (clientwidth div 2)-87;
btn_open.left := (clientwidth div 2)+5;
ProgressBar1.Width := clientwidth-8;
end;

end.
