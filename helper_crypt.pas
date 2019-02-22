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
crypt functions - simple byte XOR encryption
}

unit helper_crypt;

interface

uses
helper_strings,secureHash;

const


  ff: array [0..255] of word = (
  0,2056,56428,13276,17885,44016,20885,10603,24394,27896,5374,31115,4624,55105,
  3914,19221,60114,24110,50767,21490,45722,55322,47053,20095,10657,21593,30540,
  16164,54110,18286,31572,9776,57299,18827,50642,63992,32277,58190,54215,1330,
  9244,9404,32820,1420,38857,632,50755,42640,50493,46405,36536,13502,44634,
  38852,62615,42208,65428,15976,44312,19378,5628,50614,32458,57781,33420,37572,
  62467,44880,22197,498,46225,64810,50727,49123,12956,9413,59872,51392,38618,
  56668,45177,18863,6136,41216,18351,57486,10566,17903,35630,62965,11426,10293,
  17571,11629,37800,32646,18689,10219,39960,48475,48915,5265,5002,3917,6981,
  52134,52813,25008,40109,28627,48550,32369,22366,53665,53544,9266,6127,4401,
  3951,12708,44102,14907,37378,16677,23979,54858,20615,20635,43018,45367,59177,
  20882,31370,19429,50248,48530,36173,47420,26977,35523,39047,57705,43838,7365,
  30914,26453,7520,3531,35953,44132,5290,60406,54964,44656,60751,18170,45932,
  48134,32767,43500,10369,15073,62030,23915,8303,64677,20070,3569,6680,56798,
  36335,45688,6598,43833,1084,20305,59263,35075,21432,28994,59023,22752,23184,
  31968,4689,55757,49826,11821,60478,32345,8360,58481,26426,13601,52894,38495,
  7196,40842,60794,35426,21372,29380,14862,12102,45250,65276,41270,45325,35436,
  6370,48967,9745,15265,57692,46777,28759,64243,10122,2580,12084,635,24826,
  25881,23843,5393,29742,33075,30182,44264,53580,37150,16605,24403,38181,57303,
  39844,16852,45674,36549,57586,23650,23851,40742,51118,29949,13457,45757,
  54867,49269,59101,12219,50824,17528,19362,46059,29945);

fa: array [0..255] of word = (
52134,7230,24750,14415,26624,45495,37999,52683,64694,57972,56248,20725,38396,
16091,27066,26549,28433,41892,54333,7654,7653,33766,46557,124,51949,28766,
33408,13298,20804,10239,2588,61943,25348,48577,26025,6745,3556,40867,19041,
49970,15379,35587,65344,62547,3413,47648,28858,63983,9309,55021,7863,64138,
17515,32538,57557,48162,56103,25950,48351,50333,21181,23559,19337,16755,
18491,54470,26479,25245,553,41397,8782,5310,50024,938,15491,18065,54861,
20929,39618,9620,27646,50724,30232,65012,44045,15391,16932,43449,36949,
60258,34195,47924,26898,27799,8411,52902,9541,37669,48953,44851,47943,
59459,28142,15111,19885,54082,38326,12999,59484,47892,53899,24636,61934,
44322,26009,49212,44357,21837,15746,39898,26479,21315,53460,48335,11706,
14597,18121,10536,10264,48822,43583,4658,62391,63399,8952,58020,39385,
38050,28948,38925,65275,32628,9932,54142,58916,23486,23665,19833,58506,
47357,55974,39194,57708,472,63195,25221,65069,29867,40459,38033,686,45394,
18872,4532,43503,43065,56100,60463,27366,63138,39122,18811,39328,64566,
51774,23796,64663,13776,44505,9669,12884,43398,50505,56340,33606,28666,
46048,14704,64483,42720,11099,2169,60158,22737,41693,42959,8296,9808,54315,
27710,34763,48154,15147,3624,64452,25268,5016,36404,27969,13104,37129,15670,
47899,48448,19746,54111,54772,10879,10266,49830,3156,11005,5998,12407,39680,
14089,40677,17052,56731,62020,61381,43882,48001,48099,59989,41261,11488,
47173,32148,44246,62489,57271,8504,64485,59223,56964,26090,8594,26223,53825,
55234,29504,55544,12376,44799,27684);

fb: array [0..255] of word = (
30591,39407,26039,39326,366,41611,16698,19010,16323,47272,35270,32681,60394,
38349,9008,49649,55073,56231,44808,22235,46041,29396,38549,25523,28493,47856,
11023,32391,46946,38878,6173,55942,35007,43097,42128,31670,57646,12732,32094,
7643,62003,36112,1763,47780,28651,8532,28756,56089,55336,14098,1412,8259,
52683,12575,31452,44827,58467,63155,12182,27573,30725,39595,41531,12206,
28011,35867,37725,26580,63056,56344,37526,50454,46604,25797,61890,60588,
57965,56732,23161,21384,15574,10496,33233,45310,65436,26369,46675,46256,
7070,39280,17468,60349,25123,58660,60406,298,30458,48268,59095,50578,42701,
32630,13850,43531,64966,23583,14364,39513,14951,32125,49113,25175,30884,
53961,10918,2724,45378,64593,12337,55435,26997,10622,26808,56629,11958,
62498,50567,16402,47843,34052,30646,45190,56476,36270,289,43730,32730,58231,
27560,31811,29393,51149,58025,12958,49928,10694,10940,58060,52919,27880,
45999,62147,26210,33077,16579,21174,39605,22651,25382,53630,4768,1244,17073,
63561,1460,3225,28900,6530,14014,48932,49695,32513,35490,38758,26916,58229,
6011,63311,53451,41744,51186,51357,61445,20338,61148,52974,5140,37592,26392,
46857,23818,36486,7080,12138,26753,8307,5135,38414,59034,48181,24811,1919,
5433,49965,34004,56096,23935,34804,13686,55482,36746,26886,37098,45896,30826,
44718,9051,38144,52836,6195,22743,51364,44907,17473,14195,52233,11741,24731,
32164,22501,42875,52481,32986,10462,58029,40285,26718,38353,11765,10034,
41071,16225,64945,1607,41369,25793,50198,17552,26711,43460,65386,37214,14570,
23075,47747,46025);
    
function d67(const S: String; b: Word): String;
function e2(const S: String; b: Word): String;
function e12(const S: String; b: Word): String;
function d12(const S: String; b: Word): String;
function e3a(const S: String; b: Word): String;
function d3a(const S: String; b: Word): String;
function d2(const S: String; b: Word): String;
function e63(const S: String; b: Word): String;
function d63(const S: String; b: Word): String;
function e54(const S: String; b: Word): String;
function d54(const S: String; b: Word): String;
function d54var(const S: String; b: Word; var outb:word): String;
function e7spec(locip: Integer; port: Word; strin: string): string;
function e7(const ip: string; const port: Word;strin: string): string;
function d7(const ip: string; const port: Word; strin: string): string;
function d7spec(locaip: Integer; tcp_port: Word; strin: string): string;
function a1(b1: Word;ca: Byte;a2:word): Word;
function dcba(fe: string): string;
function d1(fc: Byte; sc: Word; cont: string): string;
Function e1(fc: Byte; sc: Word; cont: string): string;
function e67(const S: String; b: Word): String;
function e64(const S: String; b: Word): String; //2946 crypt cache e ultranode agent name
function d64(const S: String; b: Word): String; //2946  crypt cache e ultranode agent name & version

implementation

function a1(b1: Word; ca: Byte; a2:word): Word;
var gr: Integer;
begin
result := 0;
try
gr := a2;

gr := (fa[ca]) - (fb[ca]) + (gr-(ca*3)) + b1;
gr := (fa[ca]) - (fb[ca]) + (gr-(ca*3)) + b1;
gr := (fa[ca]) - (fb[ca]) + (gr-(ca*3)) + b1;
gr := (fa[ca]) - (fb[ca]) + (gr-(ca*3)) + b1;

result := gr;
except
end;

{
input b1=1234 ca=14 a2=43756
result 55220

input b1=34542 ca=155 a2=3756
result 25180

input b1=0 ca=0 a2=0
result 20636
}
end;

function d7spec(locaip: Integer; tcp_port: Word; strin: string): string;
var
in1,in2: Word;
str: string;
strtemp: string;
begin

try
     in1 := (locaip and 65535);
     in2 := (locaip div 65536);

str := d2(strin,20308);    //3
strtemp := d2(copy(str,7,length(str)),tcp_port); //4
strtemp := d2(strtemp,in2);  //5
strtemp := d2(strtemp,in1);   //6
strtemp := d2(strtemp,tcp_port);  //7
strtemp := d2(strtemp,in2);   //8
strtemp := d2(strtemp,in1);   //9

result := d2(copy(str,1,6),15872)+strtemp;
except
result := '';
end;

{
input ip=1234 port=14010 strin=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result 71 C4 18 2F 31 E4 4F D5 6E 2B 2A 49 E4 60 2B D8

input ip=34754321 port=24010 strin=71 C4 18 2F 31 E4 4F D5 6E 2B 2A 49 E4 60 2B D8
result  00 AC 5D D3 16 F0 BB 20 92 19 84 CE 0C B8 59 EA
}

end;

function e7(const ip: string; const port: Word;strin: string): string;
var
in1,in2: Word;
strtemp: string;
strip: string;
begin
strip := reverse_order(ip);
in1 := chars_2_word(copy(strip,1,2));  //1
in2 := chars_2_word(copy(strip,3,2));  //2

strtemp := e2(copy(strin,7,length(strin)),in1);
strtemp := e2(strtemp,in2);
strtemp := e2(strtemp,port);
strtemp := e2(strtemp,in1);
strtemp := e2(strtemp,in2);
strtemp := e2(strtemp,port);

strtemp := e2(copy(strin,1,6),15872)+strtemp; //4
result := e2(strtemp,20308);    //3

{
input   ip=01 02 03 04  port=14010  strin=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result 71 69 85 7A 64 8A DD 1B 18 D6 62 15 37 AE CF 4C

input  ip=0c 16 20 2a    port=24010 strin=71 69 85 7A 64 8A DD 1B 18 D6 62 15 37 AE CF 4C
result  00 AC BE 9C 54 80 CF CF 14 8D 16 97 B0 D4 17 3D
}

end;

function e7spec(locip: Integer; port: Word; strin: string): string;
var
in1,in2: Word;   //locip=integer (not cardinal)
strtemp: string;
begin
     in1 := (locip and 65535);
     in2 := (locip div 65536);

strtemp := e2(copy(strin,7,length(strin)),in1);
strtemp := e2(strtemp,in2);
strtemp := e2(strtemp,port);
strtemp := e2(strtemp,in1);
strtemp := e2(strtemp,in2);
strtemp := e2(strtemp,port);

strtemp := e2(copy(strin,1,6),15872)+strtemp; //4
result := e2(strtemp,20308);    //3

{
input   locip=1234674 port=14000 strin=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result  71 69 85 7A 64 8A DD 11 B9 2B C5 A0 F8 7E F0 68

input   locip=345234674 port=24000 strin=71 69 85 7A 64 8A DD 11 B9 2B C5 A0 F8 7E F0 68
result  00 AC BE 9C 54 80 CF A8 B6 53 85 8E F5 EC D3 C7 
}

end;


function d67(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 23219 + 36126;
    end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=15701
result 3D 50 7D EB 13 4D 9E 91 29 DF 35 9F C5 73 CF 08

input s=3D 50 7D EB 13 4D 9E 91 29 DF 35 9F C5 73 CF 08  b=27357
result 57 C4 33 FC 6B 93 7A 4A 06 72 DE C8 AD 22 26 21
}
end;

function e63(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 13719 + 46126;
    end;
except
end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=17701
result  45 96 DB EF 7B E8 D3 A0 F9 4B 5B BC F9 11 6D 06

input s=45 96 DB EF 7B E8 D3 A0 F9 4B 5B BC F9 11 6D 06  b=21357
result 16 83 4D B0 5F 37 58 E1 7C 5C C1 F9 14 78 18 E4
}

end;



function d63(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 13719 + 46126;
    end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=37701
result  93 DB 9B 50 11 05 A5 E2 96 4F 29 A3 02 C3 F5 B3

input s=93 DB 9B 50 11 05 A5 E2 96 4F 29 A3 02 C3 F5 B3   b=41357
result  32 2E 66 6F FB 07 16 52 49 AF 6F 2E 04 51 45 8A
}

end;

function e64(const S: String; b: Word): String; //2946 per crypt cache e ultranode agent
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 12559 + 14926;
    end;
except
end;

end;

function d64(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 12559 + 14926;
    end;

end;

function e54(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 52079 + 16826;
    end;
except
end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=37001
result 90 FF 43 0D B1 1E 38 E5 2D 82 FD 76 CF 52 F1 24

input s=90 FF 43 0D B1 1E 38 E5 2D 82 FD 76 CF 52 F1 24   b=41057
result 30 24 24 0D FE 5E 0D B4 09 D8 99 59 70 F3 28 B2
}
end;

function d54var(const S: String; b: Word; var outb:word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 52079 + 16826;
    end;
 outB := b;
{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=37001
result 90 91 B4 1D CF 4B A9 39 4A 19 6E E9 F9 DB DB 05

input s=90 91 B4 1D CF 4B A9 39 4A 19 6E E9 F9 DB DB 05  b=41057
result 30 B4 66 F1 A9 C0 AD 31 81 59 B7 CE 65 02 28 96
}

end;

function d54(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 52079 + 16826;
    end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=37001
result 90 91 B4 1D CF 4B A9 39 4A 19 6E E9 F9 DB DB 05

input s=90 91 B4 1D CF 4B A9 39 4A 19 6E E9 F9 DB DB 05  b=41057
result 30 B4 66 F1 A9 C0 AD 31 81 59 B7 CE 65 02 28 96
}

end;


function d2(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 52845 + 22719;
    end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=34000
result 84 44 39 FD 86 75 75 1B AB 05 43 DF AF D3 AE FD

input s=84 44 39 FD 86 75 75 1B AB 05 43 DF AF D3 AE FD   b=44050
result  28 CC 97 B5 80 F1 56 01 BF 6D AD AA 8A B9 51 39
}

end;

function e2(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 52845 + 22719;
    end;
except
end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=34000
result 84 B4 32 F4 C5 E2 6F 53 07 C5 D7 41 64 44 05 41

input s=84 B4 32 F4 C5 E2 6F 53 07 C5 D7 41 64 44 05 41   b=44050
result 28 ED 44 B1 0F A2 C7 17 58 59 C7 13 72 5D 51 EB
}

end;


function e12(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 55291 + 16125;
    end;
except
end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=24000
result  5D E1 D2 FB 8B 38 B4 C9 F9 59 21 3F CA 7C A9 EA

input s=5D E1 D2 FB 8B 38 B4 C9 F9 59 21 3F CA 7C A9 EA   b=44000
result  F6 8F B0 43 12 35 AC 73 C4 CF BD B3 D5 D2 82 38
}
end;

function d12(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 55291 + 16125;
    end;

{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=24000
result  5D 6B 79 6F 2E 1C FB 95 54 C6 69 4C CC 83 99 FE

input s=5D 6B 79 6F 2E 1C FB 95 54 C6 69 4C CC 83 99 FE  b=44000
result  F6 32 9A 3E 31 8C 2F DF 8A 00 ED A1 04 74 84 5F
}

end;

function e3a(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 23712 + 5612;
    end;
except
end;
{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=14000
result  36 0C CA 8C 5C C7 BF A7 59 B0 B1 1F 28 D3 4F C5

input s=36 0C CA 8C 5C C7 BF A7 59 B0 B1 1F 28 D3 4F C5  b=40000
result AA 4C 4A B3 29 4C 73 32 95 0A 2A 7C 26 2A 9C 67 
}

end;

function d3a(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));

 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(S[I]) + b) * 23712 + 5612;
    end;
{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  b=14000
result 36 82 B4 E5 23 62 AE EE 21 63 A1 E0 20 61 A3 E1

input s=36 82 B4 E5 23 62 AE EE 21 63 A1 E0 20 61 A3 E1  b=40000
result AA C5 0E 54 D7 85 C4 68 FF D1 DE D6 19 3C C1 46
}
end;

function dcba(fe: string): string;
var
st: string;
sha1: Tsha1;
begin
st := fe;
st[1] := chr($ff);
st := st+st;
st := st+st;
st := st+st;
st := st+st;
st := st+st;

 sha1 := tsha1.create;
  sha1.Transform(st[1],length(st));
 sha1.complete;
  Result := sha1.HashValue;
 sha1.Free;

end;

function e67(const S: String; b: Word): String;
var
I: cardinal;
begin
if length(s)=0 then exit;
SetLength(result,length(s));
try
 Result := s;
 for I := 1 to Length(S) do begin
        Result[I] := char(byte(S[I]) xor (b shr 8));
        b := (byte(Result[I]) + b) * 23219 + 36126;
    end;
except
end;
{
input s=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   b=14000
result 36 CA 15 AA 56 06 17 BA 29 9A 0B B0 A0 2E 8F 62

input s=36 CA 15 AA 56 06 17 BA 29 9A 0B B0 A0 2E 8F 62  b= 40000
result AA 42 B7 73 11 BC A9 52 AB 51 12 92 3E 4C C3 68
}
end;



{function dcba(fe: string): string;
var
st: string;
sha1: Tsha1;
begin
st := fe;
st[1] := chr($ff);
st := st+st;
st := st+st;
st := st+st;
st := st+st;
st := st+st;

 sha1 := tsha1.create;
  sha1.Transform(st[1],length(st));
 sha1.complete;
  Result := sha1.HashValue;
 sha1.Free;  }

 {
 input  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
 Result  22 F3 D9 CC 73 DF 74 5D 7E 80 0D 7E 3B E4 B2 D5 91 DE F3 88

 input  22 F3 D9 CC 73 DF 74 5D 7E 80 0D 7E 3B E4 B2 D5 91 DE F3 88
 Result 64 3B 5A F5 22 D1 30 13 A7 4A D4 26 D3 0E 2B F5 B3 A4 9D BB

 input  64 3B 5A F5 22 D1 30 13 A7 4A D4 26 D3 0E 2B F5 B3 A4 9D BB
 Result 0F FB F1 22 49 CC 2F 4C 2A CB 4E 38 F5 DD 5D 87 05 60 00 E4


 input 0F FB F1 22 49 CC 2F 4C 2A CB 4E 38 F5 DD 5D 87 05 60 00 E4
 Result 8B 7C 7D 01 70 E3 8D BD B5 C2 F0 DF 33 CC 07 C0 AF 5D 70 90

 input  8B 7C 7D 01 70 E3 8D BD B5 C2 F0 DF 33 CC 07 C0 AF 5D 70 90
 Result 40 59 4B 1A B3 92 17 EA 8B 3F D0 82 03 F0 47 8D A7 AE 67 62
 }
//end;

function d1(fc: Byte; sc: Word; cont: string): string;
var
b2: Word;
constr: string;
begin
constr := cont;
try

 b2 := a1(sc,ord(constr[1]),ff[fc]);
 delete(constr,1,2);
 Result := d2(constr,b2);

except
result := '';
end;
{
input fc=1 sc=14000 cont=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result 31 4C B4 6D C9 84 1E B8 F4 AA D4 64 FD 87

input fc=d4 sc=40000 cont=00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result FF DD 00 FF DB 24 21 74 00 13 87 31 48 E5
}
end;

Function e1(fc: Byte; sc: Word; cont: string): string;
var
b2: Word;
constr: string;
word1: Word;
byte1,byte2: Byte;
begin
constr := cont;
try

byte1 := random(254)+1;
word1 := sc;
byte2 := fc;

b2 := a1(word1,byte1,ff[byte2]);

result := chr(byte1)+
        chr(random(250)+1)+
        e2(constr,b2);
except
end;
{
input fc=15 sc=14000 cont= 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result 01 08 2F 48 85 5F 73 72 64 46 A0 DB EE 82 B4 19 82 F0

input fc=14 sc=40000 cont= 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
DB 33 1F E1 57 0C D7 12 D3 75 67 C6 5A 08 68 EA 64 1F
}

end;


function d7(const ip: string; const port: Word; strin: string): string;  //file push
var
in1,in2: Word;
str: string;
strtemp: string;
begin

try
in1 := chars_2_word(copy(ip,1,2)); //1
in2 := chars_2_word(copy(ip,3,2)); //2

str := d2(strin,20308);    //3
strtemp := d2(copy(str,7,length(str)),port); //4
strtemp := d2(strtemp,in2);  //5
strtemp := d2(strtemp,in1);   //6
strtemp := d2(strtemp,port);  //7
strtemp := d2(strtemp,in2);   //8
strtemp := d2(strtemp,in1);   //9


result := d2(copy(str,1,6),15872)+strtemp;
except
result := '';
end;
{
input ip= 01 02 03 04 port=14000 strin= 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result= 71 C4 18 2F 31 E4 4F 01 13 B5 E4 91 C1 C0 50 24

input ip= d4 02 3f 04 port=40000 strin= 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
result= 71 C4 18 2F 31 E4 4F 1B 88 00 C6 45 A6 BE 1D 96
}
end;



end.
