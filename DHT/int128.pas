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

*****************************************************************
 The following delphi code is based on Emule (0.46.2.26) Kad's implementation http://emule.sourceforge.net
 and KadC library http://kadc.sourceforge.net/
*****************************************************************
 }

{
Description:
DHT special 128 bit integer functions
}


unit int128;

interface

uses
  SysUtils, Windows, SynSock;

type
  CU_INT128=array [0..3] of cardinal;
  pCU_INT128=^CU_INT128;
  pbytearray=^tbytearray;
  tbytearray=array [0..1023] of Byte;

procedure CU_INT128_xor(inValue:pCu_INT128; value:pCu_INT128);
function CU_INT128_tohexstr(value:pCu_INT128; reversed:boolean = true ): string;
procedure CU_INT128_fill(inValue:pCu_INT128; value:pCu_INT128); overload;
procedure CU_Int128_fill(m_data:pCU_INT128; value:pCU_INT128; numBits: Cardinal); overload;

function CU_INT128_Compare(Value1:pCu_INT128; value2:pCu_INT128): Boolean;
function CU_INT128_compareTo(m_data:pCU_INT128; value: Cardinal): Integer; overload;
function CU_Int128_compareTo(m_data:pCU_Int128; other:pCU_INT128): Integer; overload;

function CU_INT128_getBitNumber(m_data:pCU_INT128; bit: Cardinal): Cardinal;
procedure CU_Int128_setBitNumber(m_data:pCU_INT128; bit: Cardinal; value: Cardinal);
procedure CU_Int128_shiftLeft(m_data:pCU_INT128; bits: Cardinal);
procedure CU_Int128_setValue(m_data:pCU_INT128; value: Cardinal);
procedure CU_Int128_add(m_data:pCU_INT128; value:pCU_Int128); overload;
procedure CU_Int128_add(m_data:pCU_INT128; value: Cardinal); overload;
function CU_INT128_MinorOf(m_data:pCU_INT128; value: Cardinal): Boolean; overload;
function CU_INT128_MinorOf(m_data:pCU_INT128; value:pCU_INT128): Boolean; overload;
function CU_INT128_Majorof(m_data:pCU_INT128; value:pCU_INT128): Boolean;
procedure CU_Int128_toBinaryString(m_data:pCU_INT128; var str: string; trim:boolean=false);
procedure CU_Int128_setValueBE(m_data:pCU_INT128; valueBE:pbytearray);
procedure CU_INT128_fillNXor(Destination:pCU_INT128; initialValue:pCU_INT128; xorvalue:pCU_INT128);
procedure CU_INT128_copytoBuffer(source:pCU_INT128; destination:pbytearray);
procedure CU_INT128_copyFromBuffer(source:pbytearray; destination:pCU_INT128);

var
  m_data:CU_INT128;


implementation

uses
 dhtUtils, helper_strings;

procedure CU_INT128_copyFromBuffer(source:pbytearray; destination:pCU_INT128);
begin
  move(source[0], destination[0], 4);
  move(source[4], destination[1], 4);
  move(source[8], destination[2], 4);
  move(source[12], destination[3], 4);
end;

procedure CU_INT128_copytoBuffer(source:pCU_INT128; destination:pbytearray);
begin
  move(source[0], destination[0], 4);
  move(source[1], destination[4], 4);
  move(source[2], destination[8], 4);
  move(source[3], destination[12], 4);
end;

procedure CU_INT128_fillNXor(Destination:pCU_INT128; initialValue:pCU_INT128; xorvalue:pCU_INT128);
begin
  destination[0] := initialValue[0] xor xorvalue[0];
  destination[1] := initialValue[1] xor xorvalue[1];
  destination[2] := initialValue[2] xor xorvalue[2];
  destination[3] := initialValue[3] xor xorvalue[3];
end;

procedure CU_Int128_setValue(m_data:pCU_INT128; value: Cardinal);
begin
	m_data[0] := 0;
	m_data[1] := 0;
	m_data[2] := 0;
	m_data[3] := value;
end;

procedure CU_Int128_setValueBE(m_data:pCU_INT128; valueBE:pbytearray);
var
  i: Integer;
begin
	m_data[0] := 0;
	m_data[1] := 0;
	m_data[2] := 0;
	m_data[3] := 0;


	for i := 0 to 15 do
    m_data[i div 4] := m_data[i div 4] or (cardinal(valueBE[i]) shl (8*(3-(i mod 4))));
end;

procedure CU_Int128_shiftLeft(m_data:pCU_INT128; bits: Cardinal);
var
  temp:CU_INT128;
  indexShift,i: Integer;
  bit64Value,shifted: Int64;
begin
  if ((bits=0) or
       ( ((m_data[0]=0) and
          (m_data[1]=0) and
          (m_data[2]=0) and
          (m_data[3]=0))
       )
       ) then exit;

	if bits>127 then begin
		CU_Int128_setValue(m_data,0);
    exit;
	end;

  temp[0] := 0;
  temp[1] := 0;
  temp[2] := 0;
  temp[3] := 0;

	indexShift := integer(bits) div 32;
	shifted := 0;

  i := 3;
  while (i>=indexShift) do begin
    bit64Value := int64(m_data[i]);
		shifted := shifted+(bit64Value shl int64(bits mod 32));
		temp[i-indexShift] := cardinal(shifted);
		shifted := shifted shr 32;
    dec(i);
	end;

	for i := 0 to 3 do m_data[i] := temp[i];
end;

procedure CU_Int128_add(m_data:pCU_INT128; value:pCU_Int128);
var
  sum: Int64;
  i: Integer;
begin
	if CU_INT128_compareTo(value,0)=0 then exit;

	sum := 0;
	for i := 3 downto 0 do begin
		sum := sum+m_data[i];
		sum := sum+value[i];
		m_data[i] := cardinal(sum);
		sum := sum shr 32;
	end;
end;

procedure CU_Int128_add(m_data:pCU_INT128; value: Cardinal);
var
  temp:CU_INT128;
begin
	if value=0 then exit;

	CU_Int128_SetValue(@temp,value);
	CU_Int128_add(m_data,@temp);
end;


function CU_INT128_getBitNumber(m_data:pCU_INT128; bit: Cardinal): Cardinal;
var
  uLongNum, shift: integer;
begin
  Result := 0;
	if (bit>127) then exit;

  ulongNum := bit div 32;
	shift := 31-(bit mod 32);
	Result :=  ((m_data[ulongNum] shr shift) and 1);
end;

procedure CU_Int128_setBitNumber(m_data:pCU_INT128; bit: Cardinal; value: Cardinal);
var
  ulongNum, shift: integer;
begin
	ulongNum := bit div 32;
	shift := 31-(bit mod 32);
	m_data[ulongNum] := m_data[ulongNum] or (1 shl shift);
	if value=0 then
    m_data[ulongNum] := m_data[ulongNum] xor (1 shl shift);
end;

function CU_INT128_compareTo(m_data:pCU_INT128; value: Cardinal): Integer;
begin
	if ((m_data[0]>0) or
      (m_data[1]>0) or
      (m_data[2]>0) or
      (m_data[3]>value)) then begin
		Result := 1;
    exit;
  end;

	if m_data[3]<value then begin
		Result := -1;
    exit;
  end;

	Result := 0;
end;

function CU_INT128_Compare(Value1:pCu_INT128; value2:pCu_INT128): Boolean;
begin
 Result := ((Value1[0]=Value2[0]) and
          (Value1[1]=Value2[1]) and
          (Value1[2]=Value2[2]) and
          (Value1[3]=Value2[3]));
end;

procedure CU_INT128_xor(inValue:pCu_INT128; value:pCu_INT128);
begin
	inValue[0] := inValue[0] xor value[1];
  inValue[1] := inValue[1] xor value[1];
  inValue[2] := inValue[2] xor value[2];
  inValue[3] := inValue[3] xor value[3];
end;

procedure CU_INT128_fill(inValue:pCu_INT128; value:pCu_INT128);
begin
	inValue[0] := value[0];
  inValue[1] := value[1];
  inValue[2] := value[2];
  inValue[3] := value[3];
end;

procedure CU_Int128_fill(m_data:pCU_INT128; value:pCU_INT128; numBits: Cardinal);
var
  i: Integer;
  numULONGs: Cardinal;
begin
	// Copy the whole ULONGs
	numULONGs := numBits div 32;
	for i := 0 to numULONGs-1 do begin
   m_data[i] := value[i];
  end;

	// Copy the remaining bits
	for i := (32*numULONGs) to numBits-1 do CU_INT128_setBitNumber(m_data,i, CU_INT128_getBitNumber(value,i));
	// Pad with random bytes (Not seeding based on time to allow multiple different ones to be created in quick succession)
	for i := numBits to 127 do CU_INT128_setBitNumber(m_data,i, (random(2)));
end;

procedure CU_Int128_toBinaryString(m_data:pCU_INT128; var str: string; trim:boolean=false);
var
  b, i: Integer;
begin
	str := '';

	for i := 0 to 127 do begin
		b := CU_Int128_getBitNumber(m_data,i);
		if ((not trim) or (b<>0)) then begin
			str := str+Format('%d',[b]);
			trim := False;
		end;
	end;
	if length(str)=0 then str := '0';
end;


function CU_INT128_tohexstr(value:pCu_INT128; reversed:boolean = true): string;
var
  num: Cardinal;
begin
  SetLength(Result, 16);

  if reversed then
  begin
    num := synsock.ntohl(value[0]);
    move(num,Result[1],4);
    num := synsock.ntohl(value[1]);
    move(num,Result[5],4);
    num := synsock.ntohl(value[2]);
    move(num,Result[9],4);
    num := synsock.ntohl(value[3]);
    move(num,Result[13],4);
  end
  else
  begin
    move(value[0],Result[1],4);
    move(value[1],Result[5],4);
    move(value[2],Result[9],4);
    move(value[3],Result[13],4);
  end;

  Result := bytestr_to_hexstr(Result);
end;

function CU_INT128_MinorOf(m_data:pCU_INT128; value: Cardinal): Boolean;
begin
  Result := (CU_INT128_compareTo(m_data,value)<0);
end;

function CU_INT128_MinorOf(m_data:pCU_INT128; value:pCU_INT128): Boolean; overload;
begin
  Result := (CU_INT128_compareTo(m_data,value)<0);
end;

function CU_INT128_Majorof(m_data:pCU_INT128; value:pCU_INT128): Boolean; overload;
begin
  Result := (CU_INT128_compareTo(m_data,value)>0);
end;

function CU_Int128_compareTo(m_data:pCU_Int128; other:pCU_INT128): Integer;
var
  i: Integer;
begin
  Result := 0;

	for i := 0 to 3 do
  begin
	  if m_data[i]<other[i] then
    begin
      Result := -1;
      exit;
    end;
	  if m_data[i]>other[i] then
    begin
      Result := 1;
      exit;
    end;
	end;
end;

end.
