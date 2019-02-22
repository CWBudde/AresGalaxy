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

unit uplaylistfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ares_types;

type
  TPlaylistForm = class(TForm)
    procedure FormShow(Sender: TObject);
  protected
   procedure CreateParams(var Params: TCreateParams); override;
  private
   procedure DropFile(var message: ares_types.TWMDropFiles);  message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  PlaylistForm: TPlaylistForm;

implementation

{$R *.dfm}

uses
 ufrmmain,drag_n_drop;

procedure TPlaylistForm.CreateParams(var Params: TCreateParams);
begin
inherited CreateParams(Params);
Params.ExStyle := Params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TPlaylistForm.DropFile(var message: ares_types.TWMDropFiles);
var
   i : integer;
Begin
  for i := 0 to DropFileCount(message)-1 do
   if not ufrmmain.Drag_And_Drop_AddFile(DropGetFile(message,i),i) then exit;

 Dropped(message); // Very important
end;

procedure TPlaylistForm.FormShow(Sender: TObject);
begin
//DraGAcceptFiles(handle,true);
end;

end.
