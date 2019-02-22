unit VCHeaderPopup;

//----------------------------------------------------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is VTHeaderPopup.pas.
//
// The Initial Developer of the Original Code is Ralf Junker <delphi@zeitungsjunge.de>. All Rights Reserved.
//
// Modified 17 Feb 2002 by Jim Kueneman <jimdk@mindspring.com>.
//   Added the event to filter the items as they are added to the menu.
//
// Modified 23 Feb 2002 by Ralf Junker <delphi@zeitungsjunge.de>.
//   Added option to show menu items in the same order as the columns or in original order.
//   Added option to prevent the user to hide all columns.
//
// Modified 24 Feb 2002 by Ralf Junker <delphi@zeitungsjunge.de>.
//   Fixed a bug where the OnAddHeaderPopupItem would interfere with poAllowHideAll options.
//   All column indexes now consistently use TColumnIndex (instead of Integer).
//
// Modified 20 Oct 2002 by Borut Maricic <borut.maricic@pobox.com>.
//   Added the possibility to use Troy Wolbrink's Unicode aware popup menu. Define the compiler symbol TNT to enable it.
//   You can get Troy's Unicode controls collection from http://home.ccci.org/wolbrink/tnt/delphi_unicode_controls.htm).
//----------------------------------------------------------------------------------------------------------------------

{$I Compilers.inc}

interface

uses
  Menus, CometTrees;

type
  TVTHeaderPopupOption = (
    poOriginalOrder, // Show menu items in original column order as they were added to the tree.
    poAllowHideAll // Allows to hide all columns, including the last one.
  );
  TVTHeaderPopupOptions = set of TVTHeaderPopupOption;

  TAddPopupItemType = (
    apNormal,
    apDisabled,
    apHidden
  );

  TOnAddHeaderPopupItem = procedure(const Sender: TBaseCometTree; const Column: TColumnIndex; var Cmd: TAddPopupItemType) of object;

  TVTHeaderPopupMenu = class({$ifdef TNT} TTntPopupMenu {$else} TPopupMenu {$endif})
  private
    FOnAddHeaderPopupItem: TOnAddHeaderPopupItem;
    FOptions: TVTHeaderPopupOptions;
  protected
    procedure DoAddHeaderPopupItem(const Column: TColumnIndex; out Cmd: TAddPopupItemType);
    procedure OnMenuItemClick(Sender: TObject);
  public
    procedure Popup(x, y: Integer); override;
  published
    property OnAddHeaderPopupItem: TOnAddHeaderPopupItem read FOnAddHeaderPopupItem write FOnAddHeaderPopupItem;
    property Options: TVTHeaderPopupOptions read FOptions write FOptions;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  Classes;

type
  TVirtualTreeCast = class(TBaseCometTree); // Necessary to make the header accessible.

//----------------- TVTHeaderPopupMenu ---------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.DoAddHeaderPopupItem(const Column: TColumnIndex; out Cmd: TAddPopupItemType);

begin
  Cmd := apNormal;
  if Assigned(FOnAddHeaderPopupItem) then
    FOnAddHeaderPopupItem(TVirtualTreeCast(PopupComponent), Column, Cmd);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.OnMenuItemClick(Sender: TObject);

begin
  if PopupComponent = nil then
    Exit;

  with {$ifdef TNT} TTntMenuItem {$else} TMenuItem {$endif}(Sender), TVirtualTreeCast(PopupComponent).Header.Columns.Items[Tag] do
    if Checked then
      Options := Options - [coVisible]
    else
      Options := Options + [coVisible];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.Popup(x, y: Integer);

var
  i: Integer;
  ColPos: TColumnPosition;
  ColIdx: TColumnIndex;

  NewMenuItem: {$ifdef TNT} TTntMenuItem {$else} TMenuItem {$endif};
  Cmd: TAddPopupItemType;

  VisibleCounter: Cardinal;
  VisibleItem: {$ifdef TNT} TTntMenuItem {$else} TMenuItem {$endif};
  
begin
  if PopupComponent = nil then Exit;

  // Delete existing menu items.
  i := Items.Count;
  while i > 0 do begin
      Dec(i);
      Items[i].Free;
    end;

  // Add column menu items.
  with TVirtualTreeCast(PopupComponent).Header do
  begin
    if hoShowImages in Options then Self.Images := Images;
    VisibleItem := nil;
    VisibleCounter := 0;
    for ColPos := 0 to Columns.Count - 1 do
      begin
        if poOriginalOrder in FOptions then
          ColIdx := ColPos
        else
          ColIdx := Columns.ColumnFromPosition(ColPos);
        with Columns[ColIdx] do
          begin
            if coVisible in Options then Inc(VisibleCounter);
            DoAddHeaderPopupItem(ColIdx, Cmd);
            if Cmd <> apHidden then
              begin
                NewMenuItem := {$ifdef TNT} TTntMenuItem {$else} TMenuItem {$endif}.Create(Self);
                NewMenuItem.Tag := ColIdx;
                NewMenuItem.Caption := Text;
                NewMenuItem.Hint := Hint;
                NewMenuItem.ImageIndex := ImageIndex;
                NewMenuItem.Checked := coVisible in Options;
                NewMenuItem.OnClick := OnMenuItemClick;
                if Cmd = apDisabled then
                  NewMenuItem.Enabled := False
                else
                  if coVisible in Options then VisibleItem := NewMenuItem;
                Items.Add(NewMenuItem);
              end;
          end;
      end;
    // Conditionally disable menu item of last enabled column.
    if (VisibleCounter = 1) and (VisibleItem <> nil) and not (poAllowHideAll in FOptions) then
      VisibleItem.Enabled := False;
  end;

  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

end.
