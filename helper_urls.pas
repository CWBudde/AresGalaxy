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
paths/URLs misc functions
}

unit helper_urls;

interface

uses
  SysUtils, Windows, SyncObjs, ComObj, ShlObj, ActiveX,
  Const_Ares, Helper_strings;

function estrai_documento_da_url(url: string): string; //http://www.altavista.com/index.html -->  /index.html
function extract_path_from_url(url: string): string; //http://www.aresgalaxy.org/ares/index.php -->> http://www.aresgalaxy.org/ares
function extract_document_from_url(url: string): string; //http://www.altavista.com/index.html -->  /index.html
function extract_dns_from_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
function estrai_dns_da_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
function extract_fpathW(strin: WideString): WideString;
function extract_fnameW(nomefile: WideString): WideString;
function normalizza_nomefile(nomefile: WideString): WideString;
function URLencode(stringa: string): string;                { Found or not found that's the question }
function URLdecode(stringa: string): string;                { Found or not found that's the question }
function estrai_path_da_lnk(filen: WideString): WideString;
function get_app_path: WideString;
function Get_App_DataPath: WideString;
function Get_Programs_Path: WideString;
function Get_Desktop_Path: WideString;
function Flashize_Filename(Filename: WideString): WideString;

implementation

function Flashize_Filename(Filename: WideString): WideString;
var
  i: Integer;
begin
  Result := Const_Ares.STR_BROWSER_LOCALFILEURL;
  for i := 1 to Length(Filename) do
  begin
    if Filename[i]=':' then Result := Result+'|' else
    if Filename[i]='\' then Result := Result+'/' else Result := Result+Filename[i];
  end;
end;

function Get_App_DataPath: WideString;
type
  PSHGetFolderPathW = function(Hwnd: Hwnd; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
  SHGFP_TYPE_CURRENT = 0;
  CSIDL_LOCAL_APPDATA = $001C;
var
 GetFold: PSHGetFolderPathW;
 Path: array [0..260] of widechar;
 Hand: Hwnd;
begin
  Result := '';

  Hand := SafeLoadLibrary('SHFolder.dll');
  if Hand=0 then
    Exit;

  GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
  if @GetFold=nil then
  begin
    FreeLibrary(Hand);
    Exit;
  end;

  GetFold(0,CSIDL_LOCAL_APPDATA,0,SHGFP_TYPE_CURRENT,@Path[0]);
  Result := Path;
end;

function Get_Programs_Path: WideString;
type
  PSHGetFolderPathW = function(Hwnd: Hwnd; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
  SHGFP_TYPE_CURRENT = 0;
  CSIDL_PROGRAM_FILES =$0026;
var
 GetFold:PSHGetFolderPathW;
 Path: array [0..260] of widechar;
 Hand:Hwnd;
begin
  Result := '';

  Hand := SafeLoadLibrary('SHFolder.dll');
  if Hand=0 then
    Exit;

  GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
  if @GetFold=nil then begin
    FreeLibrary(Hand);
    Exit;
  end;

  GetFold(0,CSIDL_PROGRAM_FILES,0,SHGFP_TYPE_CURRENT,@Path[0]);
  Result := Path;
end;

function Get_Desktop_Path: WideString;
type
  PSHGetFolderPathW = function(Hwnd: Hwnd; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
  SHGFP_TYPE_CURRENT = 0;
  CSIDL_PROGRAM_FILES =$0010;
var
  GetFold:PSHGetFolderPathW;
  Path: array [0..260] of widechar;
  Hand:Hwnd;
begin
  Result := '';

  Hand := SafeLoadLibrary('SHFolder.dll');
  if Hand=0 then
    Exit;

  GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
  if @GetFold=nil then begin
    FreeLibrary(Hand);
    Exit;
  end;

  GetFold(0,CSIDL_DESKTOPDIRECTORY,0,SHGFP_TYPE_CURRENT,@Path[0]);
  Result := Path;
end;

function get_app_path: WideString;
begin
  // TODO Result := extract_fpathW(get_app_name);
end;



function estrai_path_da_lnk(filen: WideString): WideString;
var
  AnObj: IUnknown;
  ShLink: IShellLinkW;
  PFile: IPersistFile;
  Data: TWin32FindData;
  Buffer: array [0..255] of widechar;
begin
  Result := '';
  try
    AnObj := CreateComObject(CLSID_ShellLink);
    ShLink := AnObj as IShellLinkW;
    PFile := AnObj as IPersistFile;

    PFile.Load(PWChar(FileN), STGM_READ);


    ShLink.GetPath(Buffer, Sizeof(Buffer), Data, SLGP_UNCPRIORITY);
    Result := Buffer;
  except
  end;
end;

function URLdecode(stringa: string): string;                { Found or not found that's the question }
var
  i: Integer;
begin
  try
    Result := '';
    i := 1;
    repeat
      if i>Length(stringa) then
        break;
      if stringa[i]='%' then
      begin
        Result := Result+chr(hextoint(copy(stringa,i+1,2)));
        inc(i,3);
      end
      else
      begin
        Result := Result+stringa[i];
        inc(i);
      end;
    until (not true);
  except
    Result := '';
  end;
end;

function URLencode(stringa: string): string; { Found or not found that's the question }
var
  i,intk: Integer;
begin
  try
    Result := '';

    for i := 1 to Length(stringa) do
    begin
      intk := ord(stringa[i]);

      if ((intk>44) and (intk<47)) then
      begin // - .
        Result := Result+stringa[i];
        continue;
      end;

      if ((intk=41) or (intk=40) or (intk=95) or(intk=91) or (intk=93)) then
      begin // ( )  _ [ ]
        Result := Result+stringa[i];
        continue;
      end;

      if ((intk<48) or
        ((intk>57) and (intk<65)) or
        ((intk>90) and (intk<97)) or
        (intk>122)) then
        Result := Result+'%'+inttohex(intk,2) else Result := Result+stringa[i];
    end;
  except
    Result := '';
  end;
end;

function normalizza_nomefile(nomefile: WideString): WideString;
const
  CP_OEMCP = 1;
var
  i: Integer;
  stringa: WideString;
begin
  stringa := copy(nomefile,1,2);

  for i := 3 to Length(nomefile) do
  begin
    if ((nomefile[i]<>'\') and
      (nomefile[i]<>'/') and
      (nomefile[i]<>':') and
      (nomefile[i]<>'*') and
      (nomefile[i]<>'?') and
      (nomefile[i]<>'"') and
      (nomefile[i]<>'<') and
      (nomefile[i]<>'>') and
      (nomefile[i]<>'|') and
      (nomefile[i]<>'.') and
      (ord(nomefile[i])>=32)) then
      stringa := stringa+nomefile[i]
    else
      stringa := stringa + ' ';
  end;

  i := 1;
  while (i<Length(stringa)) do
  begin//strip doppi spazi
    if stringa[i]=' ' then
      if stringa[i+1]=' ' then
      begin
        delete(stringa,i,1);
        continue;
      end;
    inc(i);
  end;

  while true do
  begin //strip spazi iniziale
    if Length(stringa)>1 then
    begin
      if stringa[1] = ' ' then
        delete(stringa,1,1)
      else
        break;
    end
    else
      break;
  end;

  while true do
  begin //strip spazi finale
    if Length(stringa)>1 then
    begin
      if stringa[Length(stringa)]=' ' then delete(stringa,Length(stringa),1) else break;
    end
    else
      break;
  end;

  nomefile := stringa;
  if Length(nomefile)>140 then
    SetLength(nomefile,140); //copy(nomefile,1,140);

  if (Win32Platform<>VER_PLATFORM_WIN32_NT) then
  begin //conversione nome su sitemi non NT
    try
(* TODO:
      nomefile := tntsystem.StringToWideStringEx(
        tntsystem.WideStringToStringEx(nomefile,CP_OEMCP), CP_OEMCP);
*)
    except
    end;
  end;
  Result := nomefile;
end;


function extract_fnameW(nomefile: WideString): WideString;
var
  z: Integer;
begin
  Result := nomefile;
  for z := Length(Result) downto 1 do if ((Result[z]='\') or (Result[z]='/')) then
  begin
    Result := copy(Result,z+1,Length(Result));
    break;
  end;
end;


function extract_fpathW(strin: WideString): WideString;
var
  i: Integer;
begin
  Result := strin;

  for i := Length(Result) downto 1 do if Result[i]='\' then
  begin
    delete(Result,i,Length(Result));
    Exit;
  end;
end;

function estrai_dns_da_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
var
  i: Integer;
begin
  Result := url;
  Result := copy(Result,pos('://',Result)+3,Length(Result));
  for i := 1 to Length(Result) do if Result[i]='/' then
  begin
    Result := copy(Result,1,i-1);
    Exit;
  end;
end;

function extract_dns_from_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
var
  i: Integer;
  str: string;
begin
  Result := '';
  try
    str := url;

    if pos(STR_HTTP_LOWER,lowercase(str))=1 then delete(str,1,7);

    if pos('/',str)=0 then
    begin
      Result := str;
      Exit;
    end;

    for i := 1 to Length(str) do if str[i]='/' then
    begin
      Result := copy(str,1,i-1);
      Exit;
    end;
  except
  end;
end;

function extract_document_from_url(url: string): string; //http://www.altavista.com/index.html -->  /index.html
var
  i: Integer;
  str: string;
  inizio: Integer;
begin
  Result := '';
  try
    str := url;
    if pos(STR_HTTP_LOWER,lowercase(str))=1 then
      inizio := 8
    else
      inizio := 1;

    for i := inizio to Length(str) do if str[i]='/' then
    begin
      Result := copY(str,i,Length(str));
      Exit;
    end;

    Result := '/';
  except
  end;
end;

function extract_path_from_url(url: string): string;
var
  i: Integer;
  str: string;
begin
  Result := '';
  try
    str := url;
    if Length(str) < 2 then
      Exit;
    for i := Length(str) downto 1 do
      if str[i]='/' then
        break;
    Result := Copy(str, 1, i - 1);
  except
  end;
end;

function estrai_documento_da_url(url: string): string; //http://www.altavista.com/index.html -->  /index.html
var
  i: Integer;
begin
  Result := url;
  for i := 8 to Length(Result) do
    if Result[i]='/' then
      break;
  Result := copy(Result, i, Length(Result));
end;

end.
