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

uses const_ares,sysutils,windows,tntsystem,SyncObjs,
  comobj,ShlObj,ActiveX,helper_strings,umediar;

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
function flashize_filename(filename: WideString): WideString;


implementation

function flashize_filename(filename: WideString): WideString;
var i: Integer;
begin
result := const_ares.STR_BROWSER_LOCALFILEURL;
 for i := 1 to length(filename) do begin
   if filename[i]=':' then Result := result+'|' else
   if filename[i]='\' then Result := result+'/' else Result := result+filename[i];
 end;
end;

function Get_App_DataPath: WideString;
type
PSHGetFolderPathW=function(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
   SHGFP_TYPE_CURRENT = 0;
   CSIDL_LOCAL_APPDATA = $001C;
var
 GetFold:PSHGetFolderPathW;
 path: array [0..260] of widechar;
 hand:hwnd;
begin
result := '';

   Hand := SafeLoadLibrary('SHFolder.dll');
   if Hand=0 then exit;
   GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
    if @GetFold=nil then begin
      FreeLibrary(Hand);
      exit;
    end;

   GetFold(0,CSIDL_LOCAL_APPDATA,0,SHGFP_TYPE_CURRENT,@path[0]);
   Result := path;

end;

function Get_Programs_Path: WideString;
type
PSHGetFolderPathW=function(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
   SHGFP_TYPE_CURRENT = 0;
   CSIDL_PROGRAM_FILES =$0026;

var
 GetFold:PSHGetFolderPathW;
 path: array [0..260] of widechar;
 hand:hwnd;
begin
result := '';

   Hand := SafeLoadLibrary('SHFolder.dll');
   if Hand=0 then exit;
   GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
    if @GetFold=nil then begin
      FreeLibrary(Hand);
      exit;
    end;

   GetFold(0,CSIDL_PROGRAM_FILES,0,SHGFP_TYPE_CURRENT,@path[0]);
   Result := path;
end;

function Get_Desktop_Path: WideString;
type
PSHGetFolderPathW=function(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: PAnsiChar): HRESULT; stdcall;
const
   SHGFP_TYPE_CURRENT = 0;
   CSIDL_PROGRAM_FILES =$0010;

var
 GetFold:PSHGetFolderPathW;
 path: array [0..260] of widechar;
 hand:hwnd;
begin
result := '';

   Hand := SafeLoadLibrary('SHFolder.dll');
   if Hand=0 then exit;
   GetFold := GetProcAddress(Hand,'SHGetFolderPathW');
    if @GetFold=nil then begin
      FreeLibrary(Hand);
      exit;
    end;

   GetFold(0,CSIDL_DESKTOPDIRECTORY,0,SHGFP_TYPE_CURRENT,@path[0]);
   Result := path;
end;

function get_app_path: WideString;
begin
  Result := extract_fpathW(get_app_name);
end;



function estrai_path_da_lnk(filen: WideString): WideString;
var
  AnObj: IUnknown;
  ShLink: IShellLinkW;
  PFile: IPersistFile;
  Data: TWin32FindData;
  Buffer: array [0..255] of widechar;
begin
result := '';
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
result := '';
i := 1;
repeat
if i>length(stringa) then break;
 if stringa[i]='%' then begin
  Result := result+chr(hextoint(copy(stringa,i+1,2)));
  inc(i,3);
 end else begin
  Result := result+stringa[i];
  inc(i);
 end;
until (not true);

except
result := '';
end;
end;



function URLencode(stringa: string): string;                { Found or not found that's the question }
var i,intk: Integer;
begin
try
result := '';

for i := 1 to length(stringa) do begin
intk := ord(stringa[i]);

if ((intk>44) and (intk<47)) then begin // - .
 Result := result+stringa[i];
 continue;
end;

if ((intk=41) or (intk=40) or (intk=95) or(intk=91) or (intk=93)) then begin // ( )  _ [ ]
 Result := result+stringa[i];
 continue;
end;

    if ((intk<48) or
        ((intk>57) and (intk<65)) or
        ((intk>90) and (intk<97)) or
        (intk>122)) then Result := result+'%'+inttohex(intk,2) else Result := result+stringa[i];
end;
except
result := '';
end;
end;

function normalizza_nomefile(nomefile: WideString): WideString;
const
CP_OEMCP                 = 1;
var
i: Integer;
stringa: WideString;
begin
stringa := copy(nomefile,1,2);

for i := 3 to length(nomefile) do begin
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
    (ord(nomefile[i])>=32)) then stringa := stringa+nomefile[i]
     else stringa := stringa+' ';
end;

i := 1;
while (i<length(stringa)) do begin//strip doppi spazi
 if stringa[i]=' ' then
  if stringa[i+1]=' ' then begin
   delete(stringa,i,1);
   continue;
  end;
 inc(i);
end;

while true do begin //strip spazi iniziale
 if length(stringa)>1 then begin
  if stringa[1]=' ' then delete(stringa,1,1) else break;
 end else break;
end;

while true do begin //strip spazi finale
 if length(stringa)>1 then begin
  if stringa[length(stringa)]=' ' then delete(stringa,length(stringa),1) else break;
 end else break;
end;

nomefile := stringa;
if length(nomefile)>140 then SetLength(nomefile,140); //copy(nomefile,1,140);

if (Win32Platform<>VER_PLATFORM_WIN32_NT) then begin //conversione nome su sitemi non NT
 try
 nomefile := tntsystem.StringToWideStringEx(
                                          tntsystem.WideStringToStringEx(nomefile,CP_OEMCP),
                                          CP_OEMCP);
 except
 end;
end;
result := nomefile;
end;


function extract_fnameW(nomefile: WideString): WideString;
var z: Integer;
begin
result := nomefile;
for z := length(result) downto 1 do if ((result[z]='\') or (result[z]='/')) then begin
 Result := copy(result,z+1,length(result));
 break;
end;

end;


function extract_fpathW(strin: WideString): WideString;
var i: Integer;
begin
result := strin;

for i := length(result) downto 1 do if result[i]='\' then begin
 delete(result,i,length(result));
 exit;
end;

end;

function estrai_dns_da_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
var i: Integer;
begin
result := url;
result := copy(result,pos('://',result)+3,length(result));
for i := 1 to length(result) do if result[i]='/' then begin
result := copy(result,1,i-1);
exit;
end;

end;

function extract_dns_from_url(url: string): string;  //http://www.altavista.com/page.php -->>  www.altavista.com
var i: Integer;
str: string;
begin
result := '';
try
str := url;

if pos(STR_HTTP_LOWER,lowercase(str))=1 then delete(str,1,7);

if pos('/',str)=0 then begin
 Result := str;
 exit;
end;

for i := 1 to length(str) do if str[i]='/' then begin
 Result := copy(str,1,i-1);
 exit;
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
result := '';
try
str := url;
if pos(STR_HTTP_LOWER,lowercase(str))=1 then inizio := 8 else inizio := 1;

for i := inizio to length(str) do if str[i]='/' then begin
 Result := copY(str,i,length(str));
 exit;
end;

result := '/';

except
end;
end;

function extract_path_from_url(url: string): string; 
var i: Integer;
str: string;
begin
result := '';
try
str := url;
if length(str)<2 then exit;
for i := length(str) downto 1 do if str[i]='/' then break;
result := copy(str,1,i-1);
except
end;
end;

function estrai_documento_da_url(url: string): string; //http://www.altavista.com/index.html -->  /index.html
var i: Integer;
begin
result := url;
for i := 8 to length(result) do if result[i]='/' then break;
result := copY(result,i,length(result));
end;

end.
