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

 ######### NOTICE:  this comes from the SlavaNap source code. ###########

 Copyright 2001,2002 by SlavaNap development team
 Released under GNU General Public License

 Latest version is available at
 http://www.slavanap.org

**********************************************************

 Unit: class_cmdlist

 TNapCmd and TNapCmdList declarations

*********************************************************}

unit class_cmdlist;

interface

uses
 Windows, Classes2, SysUtils;

type
  TNapCmd         = record
       id       : Integer;
       cmd      : String;
  end;
  PNapCmd         = ^TNapCmd;
  TNapCmdList     = class(TMyList)
    function  Add(Value: TNapCmd): Integer;
    procedure Insert(Index: Integer; Value: TNapCmd);
    procedure Clear; override;
    procedure Delete(Index: Integer);
    function  AddCmd(id: Integer; cmd: string): Integer;
    function  Cmd(index: Integer): TNapCmd;
    function  Id(index: Integer): Integer;
    function  Str(index: Integer): String;
    function  FindByCmd(cmd: String; ignore_case: Boolean): Integer;
    function  FindById(id: Integer): Integer;
    function  FindItem(id: Integer; cmd: String): Integer;
    constructor Create;
    destructor Destroy; override;
    function  GetLength: Integer;
  end;

function  CreateCmdList: TNapCmdList;

implementation



function  CreateCmdList: TNapCmdList;
begin
  Result := TNapCmdList.Create;
end;

function CreateItem: PNapCmd;
var
 data: PNapCmd;
begin
  data := AllocMem(sizeof(TNapCmd));
  Pointer(data^.cmd) := nil;
 Result := data;
end;

procedure FreeItem(item: PNapCmd);
begin
 if Pointer(item^.cmd)<>nil then SetLength(item^.cmd,0);
 Finalize(item^);
 FreeMem(item,sizeof(TNapCmd));
end;

procedure DeleteItem(item: PNapCmd);
begin
 if Pointer(item^.cmd)<>nil then SetLength(item^.cmd,0);
 FreeItem(item);
end;

{* * * * *  TNapCmdList  * * * * *}

function TNapCmdList.Add(Value: TNapCmd): Integer;
var
 data:PNapCmd;
begin
 data := CreateItem;
 with data^ do
 begin
  cmd := Value.cmd;
  id := Value.id;
 end;
 Result := inherited Add(data);
end;

procedure TNapCmdList.Insert(Index: Integer; Value: TNapCmd);
var
 data:PNapCmd;
begin
 data := CreateItem;
 with data^ do
 begin
  cmd := Value.cmd;
  id := Value.id;
 end;
 inherited Insert(Index,data);
end;

procedure TNapCmdList.Clear;
begin
 while count>0 do
  Delete(count-1);
 inherited Clear;
end;

procedure TNapCmdList.Delete(Index: Integer);
begin
 if (Index<0) or (Index>=Count) then exit;
 if Items[Index]<>nil then
  DeleteItem(Items[Index]);
 Inherited Delete(index);
end;

function TNapCmdList.AddCmd(id: Integer; cmd: string): Integer;
var
 data: TNapCmd;
begin
 data.id := id;
 data.cmd := cmd;
 Result := Add(data);
end;

function TNapCmdList.Cmd(index :Integer): TNapCmd;
var
 data: TNapCmd;
begin
 if (index>=0) and (index<count) then
 begin
  Result := TNapCmd(Items[index]^);
  exit;
 end;
 data.id := -1;
 data.cmd := '';
 Result := data;
end;

function  TNapCmdList.Id(index: Integer): Integer;
var
 data:PNapCmd;
begin
 if (index>=0) and (index<count) then
 begin
  data := PNapCmd(Items[index]);
  Result := data^.id;
  exit;
 end;
 Result := -1;
end;

function  TNapCmdList.Str(index: Integer): String;
var
 data:PNapCmd;
begin
 if (index>=0) and (index<count) then
 begin
  data := PNapCmd(Items[index]);
  Result := data^.cmd;
  exit;
 end;
 Result := '';
end;

function  TNapCmdList.FindByCmd(cmd: String; ignore_case: Boolean): Integer;
var
 i, len: Integer;
begin
 len := Length(cmd);
 if ignore_case then
 begin
   cmd := lowercase(cmd);
   for i := 0 to count-1 do
    if Length(PNapCmd(Items[i])^.cmd)=len then
    if lowercase(PNapCmd(Items[i])^.cmd)=cmd then
    begin
      Result := i;
      exit;
    end;
   Result := -1;
   exit;
 end;
 for i := 0 to count-1 do
  if Length(PNapCmd(Items[i])^.cmd)=len then
  if PNapCmd(Items[i]).cmd=cmd then
  begin
    Result := i;
    exit;
  end;
 Result := -1;
end;

function  TNapCmdList.FindById(id: Integer): Integer;
var
 i: Integer;
begin
 for i := 0 to count-1 do
  if PNapCmd(Items[i]).id=id then
  begin
    Result := i;
    exit;
  end;
 Result := -1;
end;

function  TNapCmdList.FindItem(id: Integer; cmd: String): Integer;
var
 i, len: Integer;
begin
 len := Length(cmd);
 for i := 0 to count-1 do
  if PNapCmd(Items[i])^.id=id then
   if Length(PNapCmd(Items[i])^.cmd)=len then
   if PNapCmd(Items[i]).cmd=cmd then
   begin
     Result := i;
     exit;
   end;
 Result := -1;
end;

constructor TNapCmdList.Create;
begin
 inherited Create;
end;

destructor TNapCmdList.Destroy;
begin
 Clear;
 inherited Destroy;
end;

function  TNapCmdList.GetLength: Integer;
var
 i,j: Integer;
begin
 j := 0;
 for i := 0 to count-1 do
  inc(j,Length(PNapCmd(Items[i]).cmd));
 Result := j;
end;

end.
