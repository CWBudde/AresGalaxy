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
this code is part of 'MakeTorrent' at http://sourceforge.net/projects/burst/
BDecode.pas -- BitTorrent BDecoding Routines
Original Coding by Knowbuddy, 2003-03-19
}

unit BDecode;


interface

uses
  SysUtils, Classes, Contnrs, Hashes;

type
  TISType=(tisString = 0, tisInt);

  TIntString = class(TObject)
  public
    StringPart: String;
    IntPart: Int64;
    ISType: TISType;
    destructor destroy; override;
  end;

function bdecodeStream(s: TStream): TObject;
function bdecodeInt64(s: TStream): TIntString;
function bdecodeHash(s: TStream): TObjectHash;
function bdecodeString(s: TStream; i:Integer=0): TIntString;
function bdecodeList(s: TStream): TObjectList;
function bin2hex(s: string; m:Integer=999): string;

var
  hexchars: array [0..15] of Char='0123456789abcdef';

implementation

uses
  Windows;

destructor TIntString.destroy;
begin
  StringPart := '';
  inherited;
end;

function bin2hex(s: string; m:Integer=999): string;
var
  i,j,k,l: Integer;
  r: array of Char;
begin
  l := Length(s);
  if (m<l) then l :=  m;
  SetLength(r,l * 2);
  for i := 1 to l do begin
    j := Ord(s[i]);
    k := (i-1)*2;
    r[k] := hexchars[j div 16];
    r[k+1] := hexchars[j mod 16];
  end;
  bin2hex := String(r);
end;

function bdecodeStream(s: TStream): TObject;
var
  r: TObject;
  c:Char;
  n: Integer;
begin
  n := s.Read(c,1);
  if (n>0) then begin
    case c of
     'd':r := bdecodeHash(s);
     'l':r := bdecodeList(s);
     'i':r := bdecodeInt64(s);
     '0'..'9':r := bdecodeString(s,StrToInt(c));
      else begin

       r := nil;
      end;
    end;
  end else begin
  
   r := nil;
  end;
  bdecodeStream := r;
end;

function bdecodeHash(s: TStream): TObjectHash;
var
  r: TObjectHash;
  o: TObject;
  n,st: Integer;
  c:Char;
  k,l: TIntString;
begin
  r := TObjectHash.Create();
  n := s.Read(c,1);
  while ((n>0) and (c<>'e') and (c>='0') and (c<='9')) do begin
    n := StrToInt(c);
    
    k := bdecodeString(s, n);
    if (k<>nil) then begin
      st := s.Position;
      o := bdecodeStream(s);
      if ((o<>nil) and (k.StringPart<>'')) then r[k.StringPart] := o;
      if (k.StringPart='pieces') then k.StringPart := 'pieces';
      if (k.StringPart='info') then begin
        l := TIntString.Create();
        l.IntPart := st;
        r['_info_start'] := l;
        l := TIntString.Create();
        l.IntPart := s.Position-st;
        r['_info_length'] := l;
      end;

      //k.StringPart := '';
      k.Free;

    end;

    n := s.Read(c, 1);   // endof

  end;


  if ((c<'0') or (c>'9')) and (c<>'e') then bdecodeHash := nil
   else bdecodeHash := r;
end;

function bdecodeList(s: TStream): TObjectList;
var
  r: TObjectList;
  o: TObject;
  n: Integer;
  c:Char;
begin
  r := TObjectList.Create();
  n := s.Read(c, 1);
  while ((n>0) and (c<>'e')) do begin
    s.Seek(-1,soFromCurrent);
    o := bdecodeStream(s);
    if (o<>nil) then r.Add(o);
    n := s.Read(c, 1);
  end;
  bdecodeList := r;
end;

function bdecodeString(s: TStream; i:Integer=0): TIntString;
var
  r: TIntString;
  t: string;
  c:Char;
  n: Integer;
begin
  c := '0';
  n := s.Read(c,1);
  while ((n >0) and (c>='0') and (c<='9')) do begin
    i := (i * 10)+StrToInt(c);
    n := s.Read(c,1);
  end;

  SetLength(t,i);
 // n := 
  s.Read(PChar(t)^,i);

  r := TIntString.Create();
  r.StringPart := copy(t,1,length(t));
  r.ISType := tisString;
  SetLength(t,0);

  bdecodeString := r;
end;

function bdecodeInt64(s: TStream): TIntString;
var
  r: TIntString;
  i: Int64;
  c:Char;
  n: Integer;
  neg: Boolean;
begin
  i := 0;
  c := '0';
  neg := False;
  repeat
    if c='-' then neg := true else i := (i*10)+StrToInt(c);
    n := s.Read(c,1);
  until not ((n>0) and (((c>='0') and (c<='9')) or (c='-')));

  if neg then i := -i;

  r := TIntString.Create();
  r.IntPart := i;
  r.ISType := tisInt;
  
  bdecodeInt64 := r;
end;

end.
