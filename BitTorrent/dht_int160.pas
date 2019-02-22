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


unit dht_int160;

interface

uses
  SysUtils, Windows, Synsock;

type
  CU_INT160=array [0..4] of Cardinal;
  PCu_INT160=^CU_INT160;
  PByteArray=^TByteArray;
  TByteArray=array [0..1023] of Byte;

procedure CU_INT160_xor(inValue: PCu_INT160; Value: PCu_INT160);
function CU_INT160_tohexstr(Value: PCu_INT160; Reversed:Boolean = True ): string;
function CU_INT160_tohexbinstr(Value: PCu_INT160; doreverse:Boolean=True): string;

procedure CU_INT160_fill(inValue: PCu_INT160; Value: PCu_INT160); overload;
procedure CU_Int160_fill(m_data: PCu_INT160; Value: PCu_INT160; numBits: Cardinal); overload;

function CU_INT160_Compare(Value1: PCu_INT160; value2: PCu_INT160): Boolean;
function CU_INT160_compareTo(m_data: PCu_INT160; Value: Cardinal): Integer; overload;
function CU_Int160_compareTo(m_data: PCu_INT160; other: PCu_INT160): Integer; overload;

function CU_INT160_getBitNumber(m_data: PCu_INT160; bit: Cardinal): Cardinal;
procedure CU_Int160_setBitNumber(m_data: PCu_INT160; bit: Cardinal; Value: Cardinal);
procedure CU_Int160_shiftLeft(m_data: PCu_INT160; bits: Cardinal);
procedure CU_Int160_setValue(m_data: PCu_INT160; Value: Cardinal);
procedure CU_Int160_add(m_data: PCu_INT160; Value: PCu_INT160); overload;
procedure CU_Int160_add(m_data: PCu_INT160; Value: Cardinal); overload;
function CU_INT160_MinorOf(m_data: PCu_INT160; Value: Cardinal): Boolean; overload;
function CU_INT160_MinorOf(m_data: PCu_INT160; Value: PCu_INT160): Boolean; overload;
function CU_INT160_Majorof(m_data: PCu_INT160; Value: PCu_INT160): Boolean;
procedure CU_Int160_toBinaryString(m_data: PCu_INT160; var str: string; trim:Boolean=false);
procedure CU_Int160_setValueBE(m_data: PCu_INT160; valueBE:PByteArray);
procedure CU_INT160_fillNXor(Destination: PCu_INT160; initialValue: PCu_INT160; xorvalue: PCu_INT160);
procedure CU_INT160_copytoBuffer(source: PCu_INT160; destination:PByteArray);
procedure CU_INT160_copyFromBuffer(source:PByteArray; destination: PCu_INT160);
procedure CU_INT160_copyFromBufferRev(source:PByteArray; destination: PCu_INT160);

var
m_data:CU_INT160;


implementation

uses
  helper_strings;

procedure CU_INT160_copyFromBuffer(source:PByteArray; destination: PCu_INT160);
begin
  move(source[0],destination[0],4);
  move(source[4],destination[1],4);
  move(source[8],destination[2],4);
  move(source[12],destination[3],4);
  move(source[16],destination[4],4);
end;

procedure CU_INT160_copyFromBufferRev(source:PByteArray; destination: PCu_INT160);
begin
  move(source[0],destination[0],4);
  move(source[4],destination[1],4);
  move(source[8],destination[2],4);
  move(source[12],destination[3],4);
  move(source[16],destination[4],4);
  destination[0] := synsock.ntohl(destination[0]);
  destination[1] := synsock.ntohl(destination[1]);
  destination[2] := synsock.ntohl(destination[2]);
  destination[3] := synsock.ntohl(destination[3]);
  destination[4] := synsock.ntohl(destination[4]);
end;

procedure CU_INT160_copytoBuffer(source: PCu_INT160; destination:PByteArray);
begin
  move(source[0],destination[0],4);
  move(source[1],destination[4],4);
  move(source[2],destination[8],4);
  move(source[3],destination[12],4);
  move(source[4],destination[16],4);
end;

procedure CU_INT160_fillNXor(Destination: PCu_INT160; initialValue: PCu_INT160; xorvalue: PCu_INT160);
begin
  destination[0] := initialValue[0] xor xorvalue[0];
  destination[1] := initialValue[1] xor xorvalue[1];
  destination[2] := initialValue[2] xor xorvalue[2];
  destination[3] := initialValue[3] xor xorvalue[3];
  destination[4] := initialValue[4] xor xorvalue[4];
end;

procedure CU_Int160_setValue(m_data: PCu_INT160; Value: Cardinal);
begin
	m_data[0] := 0;
	m_data[1] := 0;
	m_data[2] := 0;
  m_data[3] := 0;
	m_data[4] := Value;
end;

procedure CU_Int160_setValueBE(m_data: PCu_INT160; valueBE:PByteArray);
var
i: Integer;
begin
	m_data[0] := 0;
	m_data[1] := 0;
	m_data[2] := 0;
	m_data[3] := 0;
  m_data[4] := 0;

	for i := 0 to 19 do
  m_data[i div 4] := m_data[i div 4] or (Cardinal(valueBE[i]) shl (8*(3-(i mod 4))));

end;

procedure CU_Int160_shiftLeft(m_data: PCu_INT160; bits: Cardinal);
var
temp:CU_INT160;
indexShift,i: Integer;
bit64Value,shifted: Int64;
begin
   if ((bits=0) or
       ( ((m_data[0]=0) and
          (m_data[1]=0) and
          (m_data[2]=0) and
          (m_data[3]=0) and
          (m_data[4]=0))
       )
       ) then Exit;

	if bits>159 then begin
		CU_Int160_setValue(m_data,0);
    Exit;
	end;

  temp[0] := 0;
  temp[1] := 0;
  temp[2] := 0;
  temp[3] := 0;
  temp[4] := 0;

	indexShift := integer(bits) div 32;
	shifted := 0;

  i := 4;
  while (i>=indexShift) do begin
    bit64Value := int64(m_data[i]);
		shifted := shifted+(bit64Value shl int64(bits mod 32));
		temp[i-indexShift] := Cardinal(shifted);
		shifted := shifted shr 32;
    dec(i);
	end;

	for i := 0 to 4 do m_data[i] := temp[i];

end;

procedure CU_Int160_add(m_data: PCu_INT160; Value: PCu_INT160);
var
  sum: Int64;
  i: Integer;
begin
	if CU_INT160_compareTo(Value,0)=0 then
    Exit;

	sum := 0;
	for i := 4 downto 0 do begin
		sum := sum+m_data[i];
		sum := sum+Value[i];
		m_data[i] := Cardinal(sum);
		sum := sum shr 32;
	end;

end;

procedure CU_Int160_add(m_data: PCu_INT160; Value: Cardinal);
var
  temp: CU_INT160;
begin
	if Value=0 then
    Exit;

	CU_Int160_SetValue(@temp,Value);
	CU_Int160_add(m_data,@temp);
end;


function CU_INT160_getBitNumber(m_data: PCu_INT160; bit: Cardinal): Cardinal;
var
  uLongNum, shift: Integer;
begin
  Result := 0;
	if (bit>159) then
    Exit;

  ulongNum := bit div 32;
	shift := 31-(bit mod 32);
	Result :=  ((m_data[ulongNum] shr shift) and 1);
end;

procedure CU_Int160_setBitNumber(m_data: PCu_INT160; bit: Cardinal; Value: Cardinal);
var
  ulongNum, shift: Integer;
begin
	ulongNum := bit div 32;
	shift := 31-(bit mod 32);
	m_data[ulongNum] := m_data[ulongNum] or (1 shl shift);
	if Value=0 then m_data[ulongNum] := m_data[ulongNum] xor (1 shl shift);
end;

function CU_INT160_compareTo(m_data: PCu_INT160; Value: Cardinal): Integer;
begin
	if ((m_data[0]>0) or
      (m_data[1]>0) or
      (m_data[2]>0) or
      (m_data[3]>0) or
      (m_data[4]>Value)) then begin
		Result := 1;
    Exit;
  end;

	if m_data[4]<Value then begin
		Result := -1;
    Exit;
  end;

	Result := 0;
end;

function CU_INT160_Compare(Value1: PCu_INT160; value2: PCu_INT160): Boolean;
begin
  Result := (
    (Value1[0] = Value2[0]) and
    (Value1[1] = Value2[1]) and
    (Value1[2] = Value2[2]) and
    (Value1[3] = Value2[3]) and
    (Value1[4] = Value2[4]));
end;

procedure CU_INT160_xor(inValue: PCu_INT160; Value: PCu_INT160);
begin
	inValue[0] := inValue[0] xor Value[1];
  inValue[1] := inValue[1] xor Value[1];
  inValue[2] := inValue[2] xor Value[2];
  inValue[3] := inValue[3] xor Value[3];
  inValue[4] := inValue[4] xor Value[4];
end;

procedure CU_INT160_fill(inValue: PCu_INT160; Value: PCu_INT160);
begin
	inValue[0] := Value[0];
  inValue[1] := Value[1];
  inValue[2] := Value[2];
  inValue[3] := Value[3];
  inValue[4] := Value[4];
end;

procedure CU_Int160_fill(m_data: PCu_INT160; Value: PCu_INT160; numBits: Cardinal);
var
  i: Integer;
  numULONGs: Cardinal;
begin
	// Copy the whole ULONGs
	numULONGs := numBits div 32;
	for i := 0 to numULONGs-1 do begin
   m_data[i] := Value[i];
  end;

	// Copy the remaining bits
	for i := (32*numULONGs) to numBits-1 do CU_INT160_setBitNumber(m_data,i, CU_INT160_getBitNumber(Value,i));
	// Pad with random bytes (Not seeding based on time to allow multiple different ones to be created in quick succession)
	for i := numBits to 159 do CU_INT160_setBitNumber(m_data,i, (random(2)));
end;

procedure CU_Int160_toBinaryString(m_data: PCu_INT160; var str: string; trim:Boolean=false);
var
  b, i: Integer;
begin
	str := '';

	for i := 0 to 159 do begin
		b := CU_Int160_getBitNumber(m_data,i);
		if ((not trim) or (b<>0)) then begin
			str := str+Format('%d',[b]);
			trim := False;
		end;
	end;
	if length(str)=0 then str := '0';
end;

function CU_INT160_tohexbinstr(Value: PCu_INT160; doreverse:Boolean=True): string;
var
  num: Cardinal;
begin
  SetLength(Result,20);
  if doreverse then
  begin
    num := synsock.htonl(Value[0]);
    move(num,Result[1],4);
    num := synsock.htonl(Value[1]);
    move(num,Result[5],4);
    num := synsock.htonl(Value[2]);
    move(num,Result[9],4);
    num := synsock.htonl(Value[3]);
    move(num,Result[13],4);
    num := synsock.htonl(Value[4]);
    move(num,Result[17],4);
  end
  else
  begin
    move(Value[1],Result[5],4);
    move(Value[2],Result[9],4);
    move(Value[3],Result[13],4);
    move(Value[4],Result[17],4);
  end;

//Result := Result;
end;

function CU_INT160_tohexstr(Value: PCu_INT160; Reversed:Boolean = True): string;
var
  num: Cardinal;
begin
  SetLength(Result, 20);

  if Reversed then
  begin
    num := synsock.ntohl(Value[0]);
    move(num, Result[1], 4);
    num := synsock.ntohl(Value[1]);
    move(num, Result[5], 4);
    num := synsock.ntohl(Value[2]);
    move(num, Result[9], 4);
    num := synsock.ntohl(Value[3]);
    move(num, Result[13], 4);
    num := synsock.ntohl(Value[4]);
    move(num, Result[17], 4);
  end
  else
  begin
    move(Value[0], Result[1], 4);
    move(Value[1], Result[5], 4);
    move(Value[2], Result[9], 4);
    move(Value[3], Result[13], 4);
    move(Value[4], Result[17], 4);
  end;

  Result := bytestr_to_hexstr(Result);
end;

function CU_INT160_MinorOf(m_data: PCu_INT160; Value: Cardinal): Boolean;
begin
  Result := (CU_INT160_compareTo(m_data,Value)<0);
end;

function CU_INT160_MinorOf(m_data: PCu_INT160; Value: PCu_INT160): Boolean; overload;
begin
  Result := (CU_INT160_compareTo(m_data,Value)<0);
end;

function CU_INT160_Majorof(m_data: PCu_INT160; Value: PCu_INT160): Boolean; overload;
begin
  Result := (CU_INT160_compareTo(m_data,Value)>0);
end;

function CU_Int160_compareTo(m_data: PCu_INT160; other: PCu_INT160): Integer;
var
  i: Integer;
begin
  Result := 0;

	for i := 0 to 4 do
  begin
    if m_data[i]<other[i] then
    begin
     Result := -1;
     Exit;
    end;
    if m_data[i]>other[i] then
    begin
     Result := 1;
     Exit;
    end;
	end;
end;

end.
