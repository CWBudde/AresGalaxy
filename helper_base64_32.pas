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
base64 and base32 encoding/decond functions
}

unit helper_base64_32;

interface

uses
sysutils,const_ares;


function Encode3to4(const Value, Table: string): string;
function EncodeBase64(const Value: string): string;
function DecodeBase64(const Value: string): string;
function Decode4to3Ex(const Value, Table: string): string;
function EncodeBase32(strin: string): string;
function DecodeBase32(strin: string): string;

implementation

function DecodeBase32(strin: string): string;
var
base32Chars,stringa: string;
i,index,offset: Integer;
words: Byte;
begin
if length(strin)<32 then exit;

base32Chars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    for i := 1 to 20 do Result := result+CHRNULL;

    index := 0;
    offset := 1;
    for i := 1 to length(strin) do begin

        stringa := strin[i];
        words := pos(uppercase(stringa),base32Chars);
        if words<1 then begin
         continue;
        end;

        dec(words);
        if (index <= 3) then begin
            index :=  (index + 5) mod 8;
            if (index = 0) then begin
               result[offset] := chr(byte(ord(result[offset]) or words));
               inc(offset);
            end else result[offset] := chr(ord(result[offset]) or byte(words shl (8 - index)));
        end else begin
            index :=  (index + 5) mod 8;
            result[offset] := chr(ord(result[offset]) or byte(words shr index));
            inc(offset);
            result[offset] := chr(ord(result[offset]) or byte(words shl (8 - index)));
        end;
   end;
end;


function EncodeBase32(strin: string): string;
var i,index: Integer;
words: Byte;
base32Chars: string;
begin
if length(strin)<20 then exit;

base32Chars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    index := 0;
    i := 1;
    while (i<=length(strin)) do begin

        if (index > 3) then begin
            words :=  (ord(strin[i]) and ($FF shr index));
            index :=  (index + 5) mod 8;
            words := words shl index;
            if (i < length(strin)) then words := words or (ord(strin[i + 1]) shr (8 - index));

            inc(i);
        end else begin
            words :=  (ord(strin[i]) shr (8 - (index + 5))) and $1F;
            index :=  (index + 5) mod 8;
            if (index = 0) then inc(i);
        end;


         Result := result+base32Chars[words+1];

    end;
end;

function EncodeBase64(const Value: string): string;
const
  TableBase64 =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
begin
  Result := Encode3to4(Value, TableBase64);
end;

function DecodeBase64(const Value: string): string;
const
  ReTablebase64 =
    #$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$3E +#$40
    +#$40 +#$40 +#$3F +#$34 +#$35 +#$36 +#$37 +#$38 +#$39 +#$3A +#$3B +#$3C
    +#$3D +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$00 +#$01 +#$02 +#$03
    +#$04 +#$05 +#$06 +#$07 +#$08 +#$09 +#$0A +#$0B +#$0C +#$0D +#$0E +#$0F
    +#$10 +#$11 +#$12 +#$13 +#$14 +#$15 +#$16 +#$17 +#$18 +#$19 +#$40 +#$40
    +#$40 +#$40 +#$40 +#$40 +#$1A +#$1B +#$1C +#$1D +#$1E +#$1F +#$20 +#$21
    +#$22 +#$23 +#$24 +#$25 +#$26 +#$27 +#$28 +#$29 +#$2A +#$2B +#$2C +#$2D
    +#$2E +#$2F +#$30 +#$31 +#$32 +#$33 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40;
begin
  Result := Decode4to3Ex(Value, ReTableBase64);
end;

function Decode4to3Ex(const Value, Table: string): string;
type
  TDconvert = record
    case byte of
      0: (a0, a1, a2, a3: char);
      1: (i: integer);
  end;
var
  x, y, l, lv: Integer;
  d: TDconvert;
  dl: integer;
  c: byte;
  p: ^char;
begin
  lv := Length(Value);
  SetLength(Result, lv);
  x := 1;
  dl := 4;
  d.i := 0;
  p := pointer(result);
  while x <= lv do
  begin
    y := Ord(Value[x]);
    if y in [33..127] then
      c := Ord(Table[y - 32])
    else
      c := 64;
    Inc(x);
    if c > 63 then
      continue;
    d.i := (d.i shl 6) or c;
    dec(dl);
    if dl <> 0 then
      continue;
    p^ := d.a2;
    inc(p);
    p^ := d.a1;
    inc(p);
    p^ := d.a0;
    inc(p);
    d.i := 0;
    dl := 4;
  end;
  case dl of
    1:
      begin
        d.i := d.i shr 2;
        p^ := d.a1;
        inc(p);
        p^ := d.a0;
        inc(p);
      end;
    2:
      begin
        d.i := d.i shr 4;
        p^ := d.a0;
        inc(p);
      end;
  end;
  l := integer(p) - integer(pointer(result));
  SetLength(Result, l);
end;

function Encode3to4(const Value, Table: string): string;
var
  c: Byte;
  n, l: Integer;
  Count: Integer;
  DOut: array [0..3] of Byte;
begin
  SetLength(Result, ((Length(Value) + 2) div 3) * 4);
  l := 1;
  Count := 1;
  while Count <= Length(Value) do
  begin
    c := Ord(Value[Count]);
    Inc(Count);
    DOut[0] := (c and $FC) shr 2;
    DOut[1] := (c and $03) shl 4;
    if Count <= Length(Value) then
    begin
      c := Ord(Value[Count]);
      Inc(Count);
      DOut[1] := DOut[1] + (c and $F0) shr 4;
      DOut[2] := (c and $0F) shl 2;
      if Count <= Length(Value) then
      begin
        c := Ord(Value[Count]);
        Inc(Count);
        DOut[2] := DOut[2] + (c and $C0) shr 6;
        DOut[3] := (c and $3F);
      end
      else
      begin
        DOut[3] := $40;
      end;
    end
    else
    begin
      DOut[2] := $40;
      DOut[3] := $40;
    end;
    for n := 0 to 3 do
    begin
      Result[l] := Table[DOut[n] + 1];
      Inc(l);
    end;
  end;
end;


end.
