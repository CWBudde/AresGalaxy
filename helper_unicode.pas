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
unicode <--> UTF-8 conversions
}

unit helper_unicode;

interface

uses
helper_strings;

function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;
function utf8strtowidestr(const strin: string): WideString;
function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: integer; var utf8Buf): integer;
function widestrtoutf8str(const strin: WideString): string;
function strtowide(const strin: string): WideString;
function widetostr(const strin: WideString): string;
procedure normalize_special_unicode(var strin: WideString);


implementation

procedure normalize_special_unicode(var strin: WideString);
var
i,num: Integer;
begin
if length(strin)<1 then exit;

i := 1;
while (i<=length(strin)) do begin

  num := integer(strin[i]);
  if (num<48) and (num<>36) then begin
   delete(strin,i,1);
   continue;
  end;
  if num>57 then if num<64 then begin
   delete(strin,i,1);
   continue;
  end;
  if num>90 then if num<97 then begin
   delete(strin,i,1);
   continue;
  end;

  case num of

     52, 64,  97,  65,192..198,224..230,256..261,461,462,506,509,902,913,923,945,1040,1072,4315,7840..7863,8710,8704,8743,8895,
     9372,9398,9424,65131,65312,65313,65345:strin[i] := 'a';
    98,  66,223,914,946,1041,1042,1066..1068,1074,1079,1098..1100,3647,4309,4316,9373,9399,9425,65314,65346:strin[i] := 'b';
    99,  67,162,169,199,231,262..269,1057,1089,9374,9426,65315,65347:strin[i] := 'c';
    100, 68,208,270..273,9375,9427,65316,65348:strin[i] := 'd';
    51, 101, 69,128,200..203,232..235,274..283,904,917,926{},941,949,1025,1028,1045,1077,1105,1108,7864..7879,8712,9376,9428,21508,{e}40451,65317,65349:strin[i] := 'e';
    102, 70,131,402,9377,9429,65318,65350:strin[i] := 'f';
    103, 71,284..291,403,9378,9430,65319,65351:strin[i] := 'g';
    104, 72,292..295,905,919,1034,1035,1053,1085, 1115,1186,1187,1210,1211,9379,9405,9431,65320,65352:strin[i] := 'h';
     49, 105, 73,161,204..207,236..239,296..305,314,316,318,320,322,407,912,921,938,943,953,970,1030,1031,1110,1111,7880..7883,
     8544,8560,9406,9432,65321,65353:strin[i] := 'i';
    106, 74,306..309,455..460,496,1032,1112,9381,9407,9433,65322,65354:strin[i] := 'j';
    107, 75,310..312,408..409,489,670,922,1036,1050,1082,1116,1178..1181,9382,9408,9434,65323,65355:strin[i] := 'k';
    108, 76,163,313,317,319,321,410..411,619..622,671,737,1340,9383,9409,9435,65324,65356:strin[i] := 'l';
    109, 77,623..625,924,1052,1084,9384,9410,9436,65325,65357:strin[i] := 'm';
    110, 78,209,241,324..331,413..414,504..505,626..628,925,942,951,9385,9411,9437,65326,65358:strin[i] := 'n';
     111, 48,79,210..216,242..248,334..339,390,415..417,465..466,490..493,510..511,524..527,554..561,596,908,920,927,
     959,972,1054,1086,1256,1257,1342,1365,1413,2848,2918,3302,3360,3664,3792,7884..7907,9386,9412,9438,65296,65327,65359:strin[i] := 'o';
    112, 80,254,929,961,1056,1088,9387,9413,9439,65328,65360:strin[i] := 'p';
    113, 81,672,1379,9388,9414,9440,65329,65361:strin[i] := 'q';
    114, 82,174,340..345,528..531,636..638,1103,9389,9415,9441,65330,65362:strin[i] := 'r';
    115, 36, 83,138,154,167{},346..353,642,931,962,1029,1109,1359,9390,9416,9442,43270,65331,65363:strin[i] := 's';
    116, 84,354..359,932,964,1058,1090,1196,1197,9391,9417,9443,65332,65364:strin[i] := 't';
     117, 85,217..220,249..252,360..371,431..433,467..476,532..535,649..650,956,965,971,1262..1267,1329,1348,1357,1396,1398,
     1405,1415,9392,9418,9444,65333,65365:strin[i] := 'u';
    118, 86,434,651,957,973,8548,8564,9393,9419,9445,65334,65366:strin[i] := 'v';
    119, 87,372..373,1064..1065,1096,1097,9394,9420,9446,65335,65367:strin[i] := 'w';
    120, 88,739,935,967,1046{},1061,1093,1202..1203,8553,8569,9395,9421,9447,65336,65368:strin[i] := 'x';
     121, 89,159,165,221,253,374..376,422,435..436,540..541,562..563,654..655,696,910,933,939,947,968,1038,1059,1063,
     1091,1095,1118,1126..1133,1198..1201,9396,9422,9448,65337,65369:strin[i] := 'y';
    122, 90,142,158,378..382,437..438,548..549,656..657,918,9397,9423,9449,65338,65370:strin[i] := 'z'
     else begin
      delete(strin,i,1);
      continue;
     end;
  end;
  
inc(i);
end;


end;

function widetostr(const strin: WideString): string;
var
i: Integer;
begin
result := '';
for i := 1 to length(strin) do
 Result := result+chr(integer(strin[i]));
end;

function strtowide(const strin: string): WideString;
var
position: Integer;
begin
result := '';

position := 1;
while (position<=length(strin)) do begin
 Result := result+
         widechar( chars_2_word( copy(strin,position,2) ) );
 inc(position,2);
end;

end;

function widestrtoutf8str(const strin: WideString): string;
var
lung: Integer;
begin
if length(strin)=0 then begin
result := '';
exit;
end;

 SetLength(result,length(strin)*3);
 lung := WideCharBufToUTF8Buf(strin[1],length(strin)*sizeof(widechar),result[1]);
 SetLength(result,lung);
end;



function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: integer; var utf8Buf): integer;
var
  iwc: integer;
  pch: PChar;
  pwc: PWideChar;
  wc : word;

  procedure AddByte(b: byte);
  begin
    pch^ := char(b);
    Inc(pch);
  end; { AddByte }

begin { WideCharBufToUTF8Buf }
  pwc := @unicodeBuf;
  pch := @utf8Buf;
  for iwc := 1 to uniByteCount div SizeOf(WideChar) do begin
    wc := Ord(pwc^);
    Inc(pwc);
    if (wc >= $0001) and (wc <= $007F) then begin
      AddByte(wc AND $7F);
    end
    else if (wc >= $0080) and (wc <= $07FF) then begin
      AddByte($C0 OR ((wc SHR 6) AND $1F));
      AddByte($80 OR (wc AND $3F));
    end
    else begin // (wc >= $0800) and (wc <= $FFFF)
      AddByte($E0 OR ((wc SHR 12) AND $0F));
      AddByte($80 OR ((wc SHR 6) AND $3F));
      AddByte($80 OR (wc AND $3F));
    end;
  end; //for
  Result := integer(pch)-integer(@utf8Buf);
end; { WideCharBufToUTF8Buf }

function utf8strtowidestr(const strin: string): WideString;
var
 lung,left: Integer;
begin
if length(strin)=0 then begin
result := '';
exit;
end;

 SetLength(result,length(strin));
 lung := UTF8BufToWideCharBuf(strin[1],length(strin),result[1],left);
 SetLength(result,lung div sizeof(widechar));
end;

function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;
var
  c1 : byte;
  c2 : byte;
  ch : byte;
  pch: PChar;
  pwc: PWideChar;
begin
  pch := @utf8Buf;
  pwc := @unicodeBuf;
  leftUTF8 := utfByteCount;
  while leftUTF8 > 0 do begin
    ch := byte(pch^);
    Inc(pch);
    if (ch AND $80) = 0 then begin // 1-byte code
      word(pwc^) := ch;
      Inc(pwc);
      Dec(leftUTF8);
    end
    else if (ch AND $E0) = $C0 then begin // 2-byte code
      if leftUTF8 < 2 then
        break;
      c1 := byte(pch^);
      Inc(pch);
      word(pwc^) := (word(ch AND $1F) SHL 6) OR (c1 AND $3F);
      Inc(pwc);
      Dec(leftUTF8,2);
    end
    else begin // 3-byte code
      if leftUTF8 < 3 then
        break;
      c1 := byte(pch^);
      Inc(pch);
      c2 := byte(pch^);
      Inc(pch);
      word(pwc^) := 
        (word(ch AND $0F) SHL 12) OR
        (word(c1 AND $3F) SHL 6) OR
        (c2 AND $3F);
      Inc(pwc);
      Dec(leftUTF8,3);
    end;
  end; //while
  Result := integer(pwc)-integer(@unicodeBuf);
end; { UTF8BufToWideCharBuf }


end.
