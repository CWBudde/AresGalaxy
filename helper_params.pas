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
used to extract widestring comand line parameters
}

unit helper_params;

interface

uses
windows,tntsysutils;

function WideParamStr(Index: Integer): WideString;
function WideParamCount: Integer;
function WideGetParamStr(P: PWideChar; var Param: WideString): PWideChar;
function should_hide_in_params: Boolean;


implementation

function should_hide_in_params: Boolean;
var
   i: Integer;
begin
   Result := False;
     for I := 1 to wideParamCount do begin
      if wideparamstr(i)='-h' then begin
       Result := True;
       break;
      end;
     end;
end;

function WideParamCount: Integer;
var
  P: PWideChar;
  S: WideString;
begin         
  P := WideGetParamStr(GetCommandLineW,S);
  Result := 0;
  while True do begin
    P := WideGetParamStr(P, S);
    if S = '' then Break;
    Inc(Result);
  end;
end;

function WideGetParamStr(P: PWideChar; var Param: WideString): PWideChar;
var
  Len: Integer;
  Buffer: array [0..4095] of WideChar;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while (P[0] > ' ') and (Len < SizeOf(Buffer)) do
    if P[0] = '"' then
    begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end else
    begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function WideParamStr(Index: Integer): WideString;
var
  P: PWideChar;
begin
  if Index = 0 then
    Result := WideGetModuleFileName(0)
  else begin
    P := GetCommandLineW;
    while True do begin
      P := WideGetParamStr(P, Result);
      if (Index = 0) or (Result = '') then Break;
      Dec(Index);
    end;
  end;
end;

end.
