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
drag&drop helper code
}

unit Drag_N_Drop;

interface

uses
Windows,ares_types,SysUtils;


type

  {$EXTERNALSYM HDROP}
  HDROP = Longint;
  PPWideChar = ^PWideChar;

 TDropGotFileProc = function(FileName : wideString;count : integer): Boolean;

 function DropPoint(dropmsg : TWMDropFiles) : TPoint;
 function DropFileCount(dropmsg : TWMDropFiles) : integer;
 function DropGetFile(dropmsg : TWMDropFiles) : widestring; overload;
 function DropGetFile(dropmsg : TWMDropFiles;index : integer) : widestring; overload;
 function DropGetFileExt(Dropmsg : TWMDropFiles) : string;overload;
 function DropGetFileExt(Dropmsg : TWMDropFiles; index : integer) : string;overload;
 function DropDifferentExt(Dropmsg : TWMDropFiles) : Boolean;
 procedure DropGetFiles(dropmsg : TWMDropFiles;GotFileProc : TDropGotFileProc);overload;
 procedure Dropped(dropmsg : TWMDropFiles);


 {$EXTERNALSYM DragQueryPoint}
 function DragQueryPoint(Drop: HDROP; var Point: TPoint): BOOL; stdcall;
 {$EXTERNALSYM DragQueryFile}
 function DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall;
 {$EXTERNALSYM DragQueryFileW}
 function DragQueryFileW(Drop: HDROP; FileIndex: UINT; FileName: PWideChar; cb: UINT): UINT; stdcall;
 {$EXTERNALSYM DragFinish}
 procedure DragFinish(Drop: HDROP); stdcall;
 
implementation

 function DragQueryPoint; external 'shell32.dll' name 'DragQueryPoint';
 function DragQueryFile; external 'shell32.dll' name 'DragQueryFileA';
 function DragQueryFileW; external 'shell32.dll' name 'DragQueryFileW';
 procedure DragFinish; external 'shell32.dll' name 'DragFinish';

 function DropPoint(dropmsg : TWMDropFiles) : TPoint;
 Begin
  DragQueryPoint(dropmsg.drop,result);
 end;

 function DropFileCount(dropmsg : TWMDropFiles) : integer;
 Begin
  Result := DragQueryFile(dropmsg.drop,$FFFFFFFF,nil,0);
 end;

 function DropGetFile(dropmsg : TWMDropFiles) : widestring; overload;
 Begin
  Result := DropGetfile(dropmsg,0);
 end;

 function DropGetFileExt(Dropmsg : TWMDropFiles) : string;
 begin
  Result := ExtractFileExt(DropGetFile(Dropmsg));
 end;

 function DropGetFileExt(Dropmsg : TWMDropFiles; index : integer) : string;
 begin
  Result := ExtractFileExt(DropGetFile(Dropmsg,index));
 end;

 function DropDifferentExt(Dropmsg : TWMDropFiles) : Boolean;
 var
  i : integer;
  tmp : string;
 Begin
  Result := False;
  tmp := DropGetFileExt(Dropmsg);
  for i := 1 to DropFileCount(dropmsg)-1 do
   if tmp <> DropGetFileExt(Dropmsg,i) then
   begin
    Result := True;
    exit;
   end;
 end;

function DropGetFile(dropmsg : TWMDropFiles; index : integer) : widestring; overload;
var
  p : Pwidechar;
Begin
  getmem(p,1024);
  DragQueryFileW(dropmsg.drop,index,p,1024);
  Result := p;
  freemem(p,1024);
end;


 procedure DropGetFiles(dropmsg : TWMDropFiles; GotFileProc : TDropGotFileProc);overload;
 var
  i : integer;
 Begin
  for i := 0 to DropFileCount(dropmsg)-1 do
   if not GotfileProc(DropGetFile(dropmsg,i),i) then exit;
 end;

 procedure Dropped(dropmsg : TWMDropFiles);
 begin
  Dragfinish(dropmsg.drop);
 end;

end.
