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
Ares supernode crypt
}
unit helper_supernode_crypt;

interface

uses
 classes,classes2,sysutils,winsock,blcksock,windows;

   type
  pac64=^ac64;
  ac64=array [0..63] of int64;

  pac32=^ac32;
  ac32=array [0..127] of cardinal;

  pac16=^ac16;
  ac16=array [0..255] of word;

  pac8=^ac8;
  ac8=array [0..511] of Byte;


function ROR1 (value: Int64; count: Byte): Int64;
function ROL1 (value: Int64; count: Byte): Int64;
function ROR2(value: Int64; count: Byte): Int64;
function ROL2(value: Int64; count: Byte): Int64;
procedure ECE27561(p: Pointer);
procedure C4458F13(p: Pointer);
procedure CA247B34(p: Pointer);
procedure E9EDD059(p: Pointer);
procedure D4C110A5(p: Pointer);
procedure D204A894(p: Pointer);
procedure E090216F(p: Pointer);
procedure A87AE6C6(p: Pointer);
procedure E83BDCFD(p: Pointer);
procedure FDE62AF8(p: Pointer);
procedure E267513A(p: Pointer);
procedure B076E2AA(p: Pointer);
procedure C73E5EB9(p: Pointer);
procedure FE35DDD2(p: Pointer);
procedure C53C522B(p: Pointer);
procedure B315E6D5(p: Pointer);
procedure A917D33F(p: Pointer);
procedure BA2BD887(p: Pointer);
procedure A6CD85C3(p: Pointer);
procedure FE1B8662(p: Pointer);
procedure D73DC481(p: Pointer);
procedure E4339548(p: Pointer);
procedure CAC344E4(p: Pointer);
procedure B35A7505(p: Pointer);
procedure C39B1843(p: Pointer);
procedure F75A99F9(p: Pointer);
procedure CFABD31D(p: Pointer);
procedure BDD8495E(p: Pointer);
procedure CCE17DA5(p: Pointer);
procedure FA522139(p: Pointer);
procedure CB877322(p: Pointer);
procedure B3E1922F(p: Pointer);
procedure EE6AB52A(p: Pointer);
procedure D4621862(p: Pointer);
procedure B4106018(p: Pointer);
procedure F67FDA06(p: Pointer);
procedure B4838104(p: Pointer);
procedure E608D1C9(p: Pointer);
procedure F6A66A73(p: Pointer);
procedure FE89C895(p: Pointer);
procedure E9352DE0(p: Pointer);
procedure B85BB9B6(p: Pointer);
procedure AFFCA0AA(p: Pointer);
procedure BED31595(p: Pointer);
procedure F4504EC7(p: Pointer);
procedure C7BE7494(p: Pointer);
procedure D5D625FF(p: Pointer);
procedure C0E8AA1C(p: Pointer);
procedure DFCBCC00(p: Pointer);
procedure C10174D6(p: Pointer);
procedure ABD58CCA(p: Pointer);
procedure CF1256D0(p: Pointer);
procedure CD436C85(p: Pointer);
procedure ECBEDA53(p: Pointer);
procedure BE76EB5C(p: Pointer);
procedure D1FA35D1(p: Pointer);
procedure A1CB5B08(p: Pointer);
procedure C5F36C6F(p: Pointer);
procedure E7661D8A(p: Pointer);
procedure AA919E7F(p: Pointer);
procedure DF0FE0A7(p: Pointer);
procedure CBACD1D7(p: Pointer);
procedure CB8FC803(p: Pointer);
procedure E0A80D78(p: Pointer);
procedure F3D3D36A(p: Pointer);
procedure D9A6B81C(p: Pointer);
procedure C641E71C(p: Pointer);
procedure D0A75576(p: Pointer);
procedure C71C03A4(p: Pointer);
procedure F692350D(p: Pointer);
procedure CEB47A26(p: Pointer);
procedure D1ED4B2D(p: Pointer);
procedure EDB1F62A(p: Pointer);
procedure BE309A6D(p: Pointer);
procedure E9BB683D(p: Pointer);
procedure CA6C5DB9(p: Pointer);
procedure DA32182C(p: Pointer);
procedure C0398AE3(p: Pointer);
procedure A018C4A9(p: Pointer);
procedure EE798AB9(p: Pointer);
procedure D374E274(p: Pointer);
procedure BA54F070(p: Pointer);
procedure DB3323E6(p: Pointer);
procedure B029F679(p: Pointer);
procedure B9097DF5(p: Pointer);
procedure D2215CD8(p: Pointer);
procedure C952FD73(p: Pointer);
procedure D2E7402D(p: Pointer);
procedure F9518419(p: Pointer);
procedure D279DF34(p: Pointer);
procedure B5429722(p: Pointer);
procedure A748F146(p: Pointer);
procedure E7C3D3C6(p: Pointer);
procedure BD7AE5F9(p: Pointer);
procedure DD194BE6(p: Pointer);
procedure E4CA915C(p: Pointer);
procedure E5673FE4(p: Pointer);
procedure FCF714F0(p: Pointer);
procedure FACBBA54(p: Pointer);
procedure E7E7C532(p: Pointer);
procedure D9DC8934(p: Pointer);
procedure D7020F08(p: Pointer);
procedure DA9765DE(p: Pointer);
procedure A1B6C6B2(p: Pointer);
procedure D0843B77(p: Pointer);
procedure AAF3F545(p: Pointer);
procedure AD0C273E(p: Pointer);
procedure ADF1DF83(p: Pointer);
procedure BE5F0BD6(p: Pointer);
procedure D86879BC(p: Pointer);
procedure D6A1CCAE(p: Pointer);
procedure BE2B5A8E(p: Pointer);
procedure C67227C5(p: Pointer);
procedure F2FB3E5E(p: Pointer);
procedure C4F54E6B(p: Pointer);
procedure C491C643(p: Pointer);
procedure E07B34A4(p: Pointer);
procedure D58951EB(p: Pointer);
procedure B5CE7FD5(p: Pointer);
procedure A810008D(p: Pointer);
procedure FD8B1CD4(p: Pointer);
procedure F0D6F924(p: Pointer);
procedure EE682519(p: Pointer);
procedure EBECA7BF(p: Pointer);
procedure AA38B2A9(p: Pointer);
procedure D940F478(p: Pointer);
procedure F662318F(p: Pointer);
procedure AA2C4F35(p: Pointer);
procedure CDA14A7E(p: Pointer);
procedure D0BBD7B0(p: Pointer);
procedure DB517D34(p: Pointer);
procedure E40E4FF0(p: Pointer);
procedure EF734C9D(p: Pointer);
procedure FF16DCE2(p: Pointer);
procedure F8392DEE(p: Pointer);
procedure CF42D5CA(p: Pointer);
procedure D0E5F592(p: Pointer);
procedure E41F62B3(p: Pointer);
procedure EF66B422(p: Pointer);
procedure D27BFAF3(p: Pointer);
procedure E0C6EE53(p: Pointer);
procedure A633F120(p: Pointer);
procedure D7E495DB(p: Pointer);
procedure D017AFE6(p: Pointer);
procedure ABDF8630(p: Pointer);
procedure E2E9486B(p: Pointer);
procedure ED60AD31(p: Pointer);
procedure B224E612(p: Pointer);
procedure DF6833CE(p: Pointer);
procedure BF620A05(p: Pointer);
procedure F8D065B9(p: Pointer);
procedure FBF06887(p: Pointer);
procedure E39A7C8A(p: Pointer);
procedure D5C973F8(p: Pointer);
procedure A19A9C69(p: Pointer);
procedure DEF0C5C9(p: Pointer);
procedure B94C1F74(p: Pointer);
procedure ED67C55B(p: Pointer);
procedure A7E514E2(p: Pointer);
procedure CEF72F50(p: Pointer);
procedure A2722456(p: Pointer);
procedure CDCC4482(p: Pointer);
procedure B78CF4DA(p: Pointer);
procedure E361701F(p: Pointer);
procedure FB81E6FB(p: Pointer);
procedure C791F951(p: Pointer);
procedure DB5770C0(p: Pointer);
procedure D469B9D0(p: Pointer);
procedure D3507FD5(p: Pointer);
procedure F67D5993(p: Pointer);
procedure E57ECE16(p: Pointer);
procedure CBD5777B(p: Pointer);
procedure C1019B4F(p: Pointer);
procedure FEBB6B79(p: Pointer);
procedure C7523873(p: Pointer);
procedure BFE643C7(p: Pointer);
procedure DD69EF27(p: Pointer);
procedure E8666789(p: Pointer);
procedure DF12A784(p: Pointer);
procedure B329165D(p: Pointer);
procedure CB8D3A28(p: Pointer);
procedure CEE12CC0(p: Pointer);
procedure F80874E2(p: Pointer);
procedure EEFABA92(p: Pointer);
procedure AD08A344(p: Pointer);
procedure CC3EE24B(p: Pointer);
procedure D2A55359(p: Pointer);
procedure B8E960E5(p: Pointer);
procedure B99D4182(p: Pointer);
procedure B96777CA(p: Pointer);
procedure ADA9C708(p: Pointer);
procedure F62AA173(p: Pointer);
procedure CF6F8A8F(p: Pointer);
procedure F3B49976(p: Pointer);
procedure B68F2907(p: Pointer);
procedure C0113E8F(p: Pointer);
procedure B86DF0E9(p: Pointer);
procedure A613F223(p: Pointer);
procedure AD4BF819(p: Pointer);
procedure BB9319A1(p: Pointer);



implementation



function ROR1 (value: Int64; count: Byte): Int64;
begin
	count :=  (count and $ff) mod 32;
	result :=  (value shr count) or (value shl (32 - count));
end;

function ROL1 (value: Int64; count: Byte): Int64;
begin
	count :=  (count and $ff) mod 32;
	result :=  (value shl count) or (value shr (32 - count));
end;

function ROR2(value: Int64; count: Byte): Int64;
begin
result := ((value) shr ((count) and $1f) or ((value) shl (32 - (((count) and $1f)))));
end;

function ROL2(value: Int64; count: Byte): Int64;
begin
result := ((value) shl ((count) and $1f) or ((value) shr (32 - (((count) and $1f)))))
end;


procedure ECE27561(p: Pointer);
var num: Int64;
begin


 if pac64(PChar(p)+21)^[0] < pac64(PChar(p)+57)^[0] then begin
   pac32(PChar(p)+258)^[0] := pac32(PChar(p)+258)^[0] - $5820;
   num := pac32(PChar(p)+102)^[0]; pac32(PChar(p)+102)^[0] := pac32(PChar(p)+324)^[0]; pac32(PChar(p)+324)^[0] := num;
   pac16(PChar(p)+252)^[0] := pac16(PChar(p)+252)^[0] or rol1(pac16(PChar(p)+95)^[0] , 8 );
 end;

 if pac16(PChar(p)+328)^[0] < pac16(PChar(p)+130)^[0] then pac16(PChar(p)+196)^[0] := pac16(PChar(p)+334)^[0] - $cc;

 if pac32(PChar(p)+336)^[0] < pac32(PChar(p)+370)^[0] then begin
   num := pac8(PChar(p)+51)^[0]; pac8(PChar(p)+51)^[0] := pac8(PChar(p)+341)^[0]; pac8(PChar(p)+341)^[0] := num;
   pac32(PChar(p)+341)^[0] := pac32(PChar(p)+341)^[0] + ror2(pac32(PChar(p)+5)^[0] , 2 );
 end;

 num := pac32(PChar(p)+73)^[0]; pac32(PChar(p)+73)^[0] := pac32(PChar(p)+508)^[0]; pac32(PChar(p)+508)^[0] := num;
 if pac16(PChar(p)+344)^[0] < pac16(PChar(p)+330)^[0] then begin  num := pac32(PChar(p)+24)^[0]; pac32(PChar(p)+24)^[0] := pac32(PChar(p)+10)^[0]; pac32(PChar(p)+10)^[0] := num; end else pac32(PChar(p)+239)^[0] := pac32(PChar(p)+239)^[0] or rol1(pac32(PChar(p)+146)^[0] , 1 );
 pac64(PChar(p)+290)^[0] := pac64(PChar(p)+290)^[0] or $98e8e7e71b3b;
 if pac64(PChar(p)+270)^[0] < pac64(PChar(p)+179)^[0] then pac32(PChar(p)+409)^[0] := pac32(PChar(p)+409)^[0] + rol1(pac32(PChar(p)+228)^[0] , 30 ) else begin  num := pac16(PChar(p)+103)^[0]; pac16(PChar(p)+103)^[0] := pac16(PChar(p)+62)^[0]; pac16(PChar(p)+62)^[0] := num; end;
 if pac32(PChar(p)+451)^[0] < pac32(PChar(p)+210)^[0] then pac64(PChar(p)+122)^[0] := pac64(PChar(p)+122)^[0] or (pac64(PChar(p)+111)^[0] xor $2c56804fbc1a) else pac16(PChar(p)+311)^[0] := pac16(PChar(p)+311)^[0] - ror1(pac16(PChar(p)+317)^[0] , 15 );

 if pac64(PChar(p)+47)^[0] < pac64(PChar(p)+459)^[0] then begin
   num := pac32(PChar(p)+273)^[0]; pac32(PChar(p)+273)^[0] := pac32(PChar(p)+7)^[0]; pac32(PChar(p)+7)^[0] := num;
   pac64(PChar(p)+380)^[0] := pac64(PChar(p)+380)^[0] - $14b588a9952e;
 end;

 pac64(PChar(p)+106)^[0] := pac64(PChar(p)+53)^[0] + (pac64(PChar(p)+319)^[0] or $6cb49ff7ff);
 pac64(PChar(p)+173)^[0] := pac64(PChar(p)+276)^[0] - $bc9a3abc7673;
 if pac64(PChar(p)+209)^[0] < pac64(PChar(p)+44)^[0] then pac32(PChar(p)+298)^[0] := pac32(PChar(p)+298)^[0] xor ror1(pac32(PChar(p)+367)^[0] , 15 ) else begin  num := pac32(PChar(p)+153)^[0]; pac32(PChar(p)+153)^[0] := pac32(PChar(p)+444)^[0]; pac32(PChar(p)+444)^[0] := num; end;
 if pac64(PChar(p)+461)^[0] < pac64(PChar(p)+434)^[0] then pac32(PChar(p)+51)^[0] := pac32(PChar(p)+51)^[0] or (pac32(PChar(p)+486)^[0] or $9ca336) else pac64(PChar(p)+78)^[0] := pac64(PChar(p)+78)^[0] xor $bcdececf;
 pac64(PChar(p)+145)^[0] := pac64(PChar(p)+145)^[0] - $ac495af0af;
 pac64(PChar(p)+1)^[0] := pac64(PChar(p)+1)^[0] + (pac64(PChar(p)+234)^[0] - $0c1687901d);
 pac64(PChar(p)+68)^[0] := pac64(PChar(p)+98)^[0] - $dc6777869be9;

 if pac64(PChar(p)+325)^[0] < pac64(PChar(p)+254)^[0] then begin
   if pac32(PChar(p)+213)^[0] > pac32(PChar(p)+210)^[0] then pac8(PChar(p)+401)^[0] := pac8(PChar(p)+401)^[0] - ror2(pac8(PChar(p)+476)^[0] , 2 ) else begin  num := pac8(PChar(p)+248)^[0]; pac8(PChar(p)+248)^[0] := pac8(PChar(p)+474)^[0]; pac8(PChar(p)+474)^[0] := num; end;
   num := pac16(PChar(p)+118)^[0]; pac16(PChar(p)+118)^[0] := pac16(PChar(p)+275)^[0]; pac16(PChar(p)+275)^[0] := num;
   num := pac32(PChar(p)+55)^[0]; pac32(PChar(p)+55)^[0] := pac32(PChar(p)+395)^[0]; pac32(PChar(p)+395)^[0] := num;
 end;


C4458F13(p);

end;

procedure C4458F13(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+180)^[0]; pac8(PChar(p)+180)^[0] := pac8(PChar(p)+46)^[0]; pac8(PChar(p)+46)^[0] := num;
 pac32(PChar(p)+249)^[0] := pac32(PChar(p)+249)^[0] xor ror1(pac32(PChar(p)+377)^[0] , 24 );
 num := pac8(PChar(p)+407)^[0]; pac8(PChar(p)+407)^[0] := pac8(PChar(p)+38)^[0]; pac8(PChar(p)+38)^[0] := num;
 if pac32(PChar(p)+227)^[0] < pac32(PChar(p)+401)^[0] then pac64(PChar(p)+441)^[0] := pac64(PChar(p)+441)^[0] - (pac64(PChar(p)+193)^[0] or $c89ca760ec) else begin  num := pac32(PChar(p)+97)^[0]; pac32(PChar(p)+97)^[0] := pac32(PChar(p)+259)^[0]; pac32(PChar(p)+259)^[0] := num; end;
 num := pac8(PChar(p)+282)^[0]; pac8(PChar(p)+282)^[0] := pac8(PChar(p)+268)^[0]; pac8(PChar(p)+268)^[0] := num;
 pac32(PChar(p)+36)^[0] := pac32(PChar(p)+36)^[0] + $08599a;

 if pac32(PChar(p)+181)^[0] > pac32(PChar(p)+403)^[0] then begin
   num := pac8(PChar(p)+81)^[0]; pac8(PChar(p)+81)^[0] := pac8(PChar(p)+291)^[0]; pac8(PChar(p)+291)^[0] := num;
   num := pac32(PChar(p)+71)^[0]; pac32(PChar(p)+71)^[0] := pac32(PChar(p)+168)^[0]; pac32(PChar(p)+168)^[0] := num;
   pac64(PChar(p)+477)^[0] := pac64(PChar(p)+477)^[0] xor (pac64(PChar(p)+129)^[0] - $d485f03f);
   pac32(PChar(p)+336)^[0] := pac32(PChar(p)+267)^[0] + $10e97f;
 end;

 pac8(PChar(p)+319)^[0] := pac8(PChar(p)+319)^[0] xor $74;

 if pac8(PChar(p)+274)^[0] > pac8(PChar(p)+402)^[0] then begin
   if pac64(PChar(p)+298)^[0] < pac64(PChar(p)+325)^[0] then pac32(PChar(p)+133)^[0] := pac32(PChar(p)+391)^[0] xor $847f else pac32(PChar(p)+488)^[0] := pac32(PChar(p)+488)^[0] + ror1(pac32(PChar(p)+121)^[0] , 19 );
   num := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := pac32(PChar(p)+277)^[0]; pac32(PChar(p)+277)^[0] := num;
   pac32(PChar(p)+486)^[0] := pac32(PChar(p)+486)^[0] or (pac32(PChar(p)+100)^[0] - $744a);
   pac8(PChar(p)+13)^[0] := pac8(PChar(p)+13)^[0] or ror2(pac8(PChar(p)+4)^[0] , 4 );
 end;

 num := pac8(PChar(p)+481)^[0]; pac8(PChar(p)+481)^[0] := pac8(PChar(p)+185)^[0]; pac8(PChar(p)+185)^[0] := num;

 if pac16(PChar(p)+35)^[0] > pac16(PChar(p)+242)^[0] then begin
   pac32(PChar(p)+151)^[0] := pac32(PChar(p)+151)^[0] or $c46eee;
   pac16(PChar(p)+504)^[0] := pac16(PChar(p)+504)^[0] or ror2(pac16(PChar(p)+265)^[0] , 14 );
   num := pac32(PChar(p)+324)^[0]; pac32(PChar(p)+324)^[0] := pac32(PChar(p)+452)^[0]; pac32(PChar(p)+452)^[0] := num;
   pac16(PChar(p)+157)^[0] := rol1(pac16(PChar(p)+505)^[0] , 11 );
   pac64(PChar(p)+362)^[0] := pac64(PChar(p)+362)^[0] xor $9012b6e67e81;
 end;


 if pac8(PChar(p)+53)^[0] > pac8(PChar(p)+486)^[0] then begin
   if pac16(PChar(p)+194)^[0] > pac16(PChar(p)+317)^[0] then pac8(PChar(p)+219)^[0] := pac8(PChar(p)+219)^[0] - ror2(pac8(PChar(p)+428)^[0] , 3 );
   pac64(PChar(p)+115)^[0] := pac64(PChar(p)+115)^[0] - (pac64(PChar(p)+377)^[0] xor $c85615aa8f);
   num := pac16(PChar(p)+407)^[0]; pac16(PChar(p)+407)^[0] := pac16(PChar(p)+48)^[0]; pac16(PChar(p)+48)^[0] := num;
 end;

 num := pac16(PChar(p)+10)^[0]; pac16(PChar(p)+10)^[0] := pac16(PChar(p)+483)^[0]; pac16(PChar(p)+483)^[0] := num;
 pac32(PChar(p)+171)^[0] := pac32(PChar(p)+171)^[0] xor (pac32(PChar(p)+92)^[0] + $bc59);

 if pac16(PChar(p)+177)^[0] > pac16(PChar(p)+426)^[0] then begin
   pac64(PChar(p)+282)^[0] := pac64(PChar(p)+282)^[0] - (pac64(PChar(p)+131)^[0] - $781c507c7e);
   pac32(PChar(p)+437)^[0] := pac32(PChar(p)+437)^[0] - (pac32(PChar(p)+219)^[0] xor $045a67);
   num := pac8(PChar(p)+27)^[0]; pac8(PChar(p)+27)^[0] := pac8(PChar(p)+197)^[0]; pac8(PChar(p)+197)^[0] := num;
 end;


CA247B34(p);

end;

procedure CA247B34(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+436)^[0] := pac64(PChar(p)+436)^[0] - $fc16f2a760;

 if pac64(PChar(p)+333)^[0] < pac64(PChar(p)+141)^[0] then begin
   if pac8(PChar(p)+268)^[0] < pac8(PChar(p)+144)^[0] then pac16(PChar(p)+423)^[0] := pac16(PChar(p)+423)^[0] xor (pac16(PChar(p)+430)^[0] xor $54);
   pac64(PChar(p)+150)^[0] := pac64(PChar(p)+150)^[0] - $4820f826;
 end;

 num := pac8(PChar(p)+36)^[0]; pac8(PChar(p)+36)^[0] := pac8(PChar(p)+46)^[0]; pac8(PChar(p)+46)^[0] := num;
 pac16(PChar(p)+213)^[0] := pac16(PChar(p)+213)^[0] - (pac16(PChar(p)+508)^[0] xor $38);
 pac64(PChar(p)+113)^[0] := pac64(PChar(p)+278)^[0] - (pac64(PChar(p)+130)^[0] or $6499185cf0);

 if pac16(PChar(p)+213)^[0] < pac16(PChar(p)+321)^[0] then begin
   pac64(PChar(p)+180)^[0] := pac64(PChar(p)+180)^[0] + $94942824d2bc;
   pac64(PChar(p)+188)^[0] := pac64(PChar(p)+199)^[0] + $9cd02db5;
 end;

 if pac64(PChar(p)+458)^[0] > pac64(PChar(p)+40)^[0] then pac32(PChar(p)+422)^[0] := pac32(PChar(p)+422)^[0] xor $90e2f4 else pac8(PChar(p)+27)^[0] := pac8(PChar(p)+27)^[0] - (pac8(PChar(p)+331)^[0] - $ec);
 pac32(PChar(p)+86)^[0] := pac32(PChar(p)+86)^[0] - rol1(pac32(PChar(p)+54)^[0] , 3 );
 if pac32(PChar(p)+396)^[0] > pac32(PChar(p)+272)^[0] then pac64(PChar(p)+461)^[0] := pac64(PChar(p)+120)^[0] - (pac64(PChar(p)+316)^[0] + $98cf21260f) else pac16(PChar(p)+408)^[0] := pac16(PChar(p)+408)^[0] or $60;
 pac8(PChar(p)+223)^[0] := pac8(PChar(p)+223)^[0] + (pac8(PChar(p)+448)^[0] xor $70);
 pac32(PChar(p)+421)^[0] := pac32(PChar(p)+421)^[0] - $88d8e3;
 if pac16(PChar(p)+130)^[0] < pac16(PChar(p)+62)^[0] then begin  num := pac32(PChar(p)+457)^[0]; pac32(PChar(p)+457)^[0] := pac32(PChar(p)+163)^[0]; pac32(PChar(p)+163)^[0] := num; end;

E9EDD059(p);

end;

procedure E9EDD059(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+154)^[0] := pac32(PChar(p)+410)^[0] + (pac32(PChar(p)+420)^[0] + $849b);
 num := pac32(PChar(p)+38)^[0]; pac32(PChar(p)+38)^[0] := pac32(PChar(p)+102)^[0]; pac32(PChar(p)+102)^[0] := num;
 pac32(PChar(p)+246)^[0] := rol1(pac32(PChar(p)+135)^[0] , 18 );
 pac32(PChar(p)+506)^[0] := pac32(PChar(p)+506)^[0] or (pac32(PChar(p)+224)^[0] xor $0479);
 pac32(PChar(p)+412)^[0] := pac32(PChar(p)+412)^[0] - rol1(pac32(PChar(p)+322)^[0] , 13 );
 if pac16(PChar(p)+81)^[0] > pac16(PChar(p)+394)^[0] then pac64(PChar(p)+432)^[0] := pac64(PChar(p)+432)^[0] - $e0350ea1 else pac32(PChar(p)+251)^[0] := pac32(PChar(p)+251)^[0] + (pac32(PChar(p)+161)^[0] - $f04ff6);
 num := pac8(PChar(p)+169)^[0]; pac8(PChar(p)+169)^[0] := pac8(PChar(p)+372)^[0]; pac8(PChar(p)+372)^[0] := num;
 pac8(PChar(p)+274)^[0] := pac8(PChar(p)+274)^[0] - (pac8(PChar(p)+433)^[0] - $84);
 num := pac16(PChar(p)+346)^[0]; pac16(PChar(p)+346)^[0] := pac16(PChar(p)+476)^[0]; pac16(PChar(p)+476)^[0] := num;
 if pac8(PChar(p)+510)^[0] > pac8(PChar(p)+349)^[0] then begin  num := pac16(PChar(p)+288)^[0]; pac16(PChar(p)+288)^[0] := pac16(PChar(p)+486)^[0]; pac16(PChar(p)+486)^[0] := num; end else begin  num := pac32(PChar(p)+275)^[0]; pac32(PChar(p)+275)^[0] := pac32(PChar(p)+153)^[0]; pac32(PChar(p)+153)^[0] := num; end;
 if pac64(PChar(p)+266)^[0] > pac64(PChar(p)+388)^[0] then pac64(PChar(p)+239)^[0] := pac64(PChar(p)+239)^[0] or $dc41f9c925;
 num := pac16(PChar(p)+25)^[0]; pac16(PChar(p)+25)^[0] := pac16(PChar(p)+359)^[0]; pac16(PChar(p)+359)^[0] := num;

D4C110A5(p);

end;

procedure D4C110A5(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+151)^[0] := pac32(PChar(p)+151)^[0] - (pac32(PChar(p)+170)^[0] - $50dd);
 num := pac8(PChar(p)+188)^[0]; pac8(PChar(p)+188)^[0] := pac8(PChar(p)+25)^[0]; pac8(PChar(p)+25)^[0] := num;
 if pac64(PChar(p)+130)^[0] > pac64(PChar(p)+203)^[0] then pac32(PChar(p)+47)^[0] := pac32(PChar(p)+10)^[0] - $d8b3;
 pac32(PChar(p)+283)^[0] := pac32(PChar(p)+283)^[0] - ror2(pac32(PChar(p)+160)^[0] , 11 );
 pac16(PChar(p)+234)^[0] := pac16(PChar(p)+440)^[0] + (pac16(PChar(p)+246)^[0] + $34);

 if pac64(PChar(p)+45)^[0] > pac64(PChar(p)+99)^[0] then begin
   num := pac32(PChar(p)+371)^[0]; pac32(PChar(p)+371)^[0] := pac32(PChar(p)+306)^[0]; pac32(PChar(p)+306)^[0] := num;
   pac32(PChar(p)+476)^[0] := ror1(pac32(PChar(p)+387)^[0] , 31 );
 end;

 pac32(PChar(p)+24)^[0] := pac32(PChar(p)+24)^[0] - ror2(pac32(PChar(p)+414)^[0] , 20 );

 if pac16(PChar(p)+51)^[0] < pac16(PChar(p)+36)^[0] then begin
   pac64(PChar(p)+484)^[0] := pac64(PChar(p)+484)^[0] - $c0c794a19b;
   if pac64(PChar(p)+145)^[0] < pac64(PChar(p)+270)^[0] then pac8(PChar(p)+259)^[0] := pac8(PChar(p)+259)^[0] or $90 else begin  num := pac32(PChar(p)+392)^[0]; pac32(PChar(p)+392)^[0] := pac32(PChar(p)+432)^[0]; pac32(PChar(p)+432)^[0] := num; end;
 end;


 if pac8(PChar(p)+467)^[0] < pac8(PChar(p)+486)^[0] then begin
   if pac64(PChar(p)+461)^[0] < pac64(PChar(p)+347)^[0] then pac64(PChar(p)+106)^[0] := pac64(PChar(p)+106)^[0] or (pac64(PChar(p)+396)^[0] or $e0fcad91) else pac32(PChar(p)+346)^[0] := pac32(PChar(p)+346)^[0] - $a473;
   if pac32(PChar(p)+496)^[0] < pac32(PChar(p)+447)^[0] then pac32(PChar(p)+201)^[0] := ror2(pac32(PChar(p)+287)^[0] , 23 ) else pac32(PChar(p)+235)^[0] := pac32(PChar(p)+235)^[0] + $6408a1;
   num := pac8(PChar(p)+154)^[0]; pac8(PChar(p)+154)^[0] := pac8(PChar(p)+194)^[0]; pac8(PChar(p)+194)^[0] := num;
   pac64(PChar(p)+339)^[0] := pac64(PChar(p)+339)^[0] or (pac64(PChar(p)+51)^[0] xor $20c58e703f);
   if pac16(PChar(p)+454)^[0] > pac16(PChar(p)+9)^[0] then pac16(PChar(p)+324)^[0] := pac16(PChar(p)+324)^[0] xor $58 else pac64(PChar(p)+394)^[0] := pac64(PChar(p)+138)^[0] xor $94d8bbf10b4e;
 end;

 pac64(PChar(p)+454)^[0] := pac64(PChar(p)+454)^[0] + $38da0291;
 if pac64(PChar(p)+390)^[0] < pac64(PChar(p)+23)^[0] then pac64(PChar(p)+311)^[0] := pac64(PChar(p)+311)^[0] + $f481b088 else pac16(PChar(p)+428)^[0] := pac16(PChar(p)+428)^[0] + $b0;
 pac16(PChar(p)+335)^[0] := pac16(PChar(p)+335)^[0] - rol1(pac16(PChar(p)+330)^[0] , 6 );
 pac64(PChar(p)+103)^[0] := pac64(PChar(p)+103)^[0] - $5c837bb4;
 pac64(PChar(p)+131)^[0] := pac64(PChar(p)+131)^[0] + $ec6487bd72;
 pac32(PChar(p)+371)^[0] := pac32(PChar(p)+371)^[0] xor (pac32(PChar(p)+276)^[0] xor $a00c);
 num := pac16(PChar(p)+487)^[0]; pac16(PChar(p)+487)^[0] := pac16(PChar(p)+261)^[0]; pac16(PChar(p)+261)^[0] := num;
 pac32(PChar(p)+158)^[0] := pac32(PChar(p)+158)^[0] + rol1(pac32(PChar(p)+140)^[0] , 4 );
 if pac16(PChar(p)+264)^[0] < pac16(PChar(p)+201)^[0] then pac32(PChar(p)+402)^[0] := pac32(PChar(p)+402)^[0] - ror1(pac32(PChar(p)+42)^[0] , 9 ) else pac16(PChar(p)+415)^[0] := pac16(PChar(p)+329)^[0] - (pac16(PChar(p)+308)^[0] - $e8);
 num := pac32(PChar(p)+329)^[0]; pac32(PChar(p)+329)^[0] := pac32(PChar(p)+468)^[0]; pac32(PChar(p)+468)^[0] := num;

D204A894(p);

end;

procedure D204A894(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+209)^[0] > pac32(PChar(p)+337)^[0] then pac32(PChar(p)+336)^[0] := pac32(PChar(p)+336)^[0] or (pac32(PChar(p)+201)^[0] xor $489b1d) else begin  num := pac8(PChar(p)+455)^[0]; pac8(PChar(p)+455)^[0] := pac8(PChar(p)+196)^[0]; pac8(PChar(p)+196)^[0] := num; end;

 if pac8(PChar(p)+224)^[0] < pac8(PChar(p)+396)^[0] then begin
   if pac8(PChar(p)+319)^[0] < pac8(PChar(p)+387)^[0] then pac32(PChar(p)+271)^[0] := pac32(PChar(p)+127)^[0] xor $006c66 else pac16(PChar(p)+446)^[0] := pac16(PChar(p)+446)^[0] or ror1(pac16(PChar(p)+173)^[0] , 7 );
   pac8(PChar(p)+477)^[0] := ror2(pac8(PChar(p)+161)^[0] , 2 );
   if pac64(PChar(p)+257)^[0] < pac64(PChar(p)+263)^[0] then pac16(PChar(p)+361)^[0] := pac16(PChar(p)+361)^[0] or $14 else pac64(PChar(p)+430)^[0] := pac64(PChar(p)+430)^[0] or $04e534d56587;
   if pac16(PChar(p)+111)^[0] < pac16(PChar(p)+326)^[0] then pac16(PChar(p)+243)^[0] := pac16(PChar(p)+243)^[0] - (pac16(PChar(p)+306)^[0] or $54);
   pac32(PChar(p)+356)^[0] := pac32(PChar(p)+252)^[0] xor $904a;
 end;

 pac16(PChar(p)+61)^[0] := pac16(PChar(p)+61)^[0] - rol1(pac16(PChar(p)+425)^[0] , 15 );
 pac64(PChar(p)+493)^[0] := pac64(PChar(p)+493)^[0] - $fce8344d7685;
 num := pac32(PChar(p)+196)^[0]; pac32(PChar(p)+196)^[0] := pac32(PChar(p)+433)^[0]; pac32(PChar(p)+433)^[0] := num;
 num := pac16(PChar(p)+386)^[0]; pac16(PChar(p)+386)^[0] := pac16(PChar(p)+105)^[0]; pac16(PChar(p)+105)^[0] := num;
 if pac32(PChar(p)+395)^[0] < pac32(PChar(p)+147)^[0] then pac8(PChar(p)+149)^[0] := pac8(PChar(p)+149)^[0] - rol1(pac8(PChar(p)+388)^[0] , 4 ) else pac64(PChar(p)+246)^[0] := pac64(PChar(p)+246)^[0] xor $c8025b1c58e6;
 if pac32(PChar(p)+358)^[0] < pac32(PChar(p)+477)^[0] then pac32(PChar(p)+355)^[0] := pac32(PChar(p)+31)^[0] + (pac32(PChar(p)+220)^[0] or $74f9) else pac16(PChar(p)+45)^[0] := pac16(PChar(p)+45)^[0] or (pac16(PChar(p)+449)^[0] + $5c);

 if pac8(PChar(p)+89)^[0] > pac8(PChar(p)+412)^[0] then begin
   pac32(PChar(p)+72)^[0] := pac32(PChar(p)+72)^[0] xor (pac32(PChar(p)+302)^[0] - $cc7deb);
   pac8(PChar(p)+110)^[0] := pac8(PChar(p)+110)^[0] - ror2(pac8(PChar(p)+399)^[0] , 2 );
   num := pac16(PChar(p)+490)^[0]; pac16(PChar(p)+490)^[0] := pac16(PChar(p)+365)^[0]; pac16(PChar(p)+365)^[0] := num;
   if pac32(PChar(p)+53)^[0] > pac32(PChar(p)+320)^[0] then pac32(PChar(p)+464)^[0] := pac32(PChar(p)+464)^[0] or (pac32(PChar(p)+151)^[0] or $ec23c6) else pac8(PChar(p)+69)^[0] := pac8(PChar(p)+69)^[0] - $38;
 end;

 num := pac8(PChar(p)+403)^[0]; pac8(PChar(p)+403)^[0] := pac8(PChar(p)+345)^[0]; pac8(PChar(p)+345)^[0] := num;

E090216F(p);

end;

procedure E090216F(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+197)^[0] := pac32(PChar(p)+381)^[0] + (pac32(PChar(p)+408)^[0] or $dc43);

 if pac64(PChar(p)+27)^[0] > pac64(PChar(p)+487)^[0] then begin
   pac64(PChar(p)+12)^[0] := pac64(PChar(p)+12)^[0] xor $68a0d6e9d81a;
   pac32(PChar(p)+80)^[0] := pac32(PChar(p)+80)^[0] + (pac32(PChar(p)+257)^[0] - $d88b);
   pac32(PChar(p)+404)^[0] := pac32(PChar(p)+404)^[0] - $687b;
   num := pac8(PChar(p)+502)^[0]; pac8(PChar(p)+502)^[0] := pac8(PChar(p)+462)^[0]; pac8(PChar(p)+462)^[0] := num;
   if pac8(PChar(p)+360)^[0] > pac8(PChar(p)+278)^[0] then pac32(PChar(p)+300)^[0] := pac32(PChar(p)+300)^[0] - (pac32(PChar(p)+244)^[0] xor $5428) else pac32(PChar(p)+202)^[0] := pac32(PChar(p)+202)^[0] xor $7cc2c2;
 end;

 pac8(PChar(p)+224)^[0] := pac8(PChar(p)+224)^[0] or (pac8(PChar(p)+140)^[0] or $a0);
 pac64(PChar(p)+124)^[0] := pac64(PChar(p)+59)^[0] xor $8cf06c4a;
 pac64(PChar(p)+151)^[0] := pac64(PChar(p)+151)^[0] xor (pac64(PChar(p)+127)^[0] - $ecaf2387bd);
 pac16(PChar(p)+287)^[0] := pac16(PChar(p)+287)^[0] + rol1(pac16(PChar(p)+8)^[0] , 1 );
 num := pac8(PChar(p)+358)^[0]; pac8(PChar(p)+358)^[0] := pac8(PChar(p)+2)^[0]; pac8(PChar(p)+2)^[0] := num;
 num := pac8(PChar(p)+444)^[0]; pac8(PChar(p)+444)^[0] := pac8(PChar(p)+67)^[0]; pac8(PChar(p)+67)^[0] := num;
 if pac64(PChar(p)+397)^[0] < pac64(PChar(p)+492)^[0] then pac32(PChar(p)+505)^[0] := pac32(PChar(p)+505)^[0] or ror2(pac32(PChar(p)+326)^[0] , 14 ) else begin  num := pac8(PChar(p)+496)^[0]; pac8(PChar(p)+496)^[0] := pac8(PChar(p)+113)^[0]; pac8(PChar(p)+113)^[0] := num; end;
 pac64(PChar(p)+305)^[0] := pac64(PChar(p)+305)^[0] or (pac64(PChar(p)+198)^[0] xor $3025dfbde1);
 pac64(PChar(p)+162)^[0] := pac64(PChar(p)+162)^[0] - $cc76fdff;
 num := pac8(PChar(p)+415)^[0]; pac8(PChar(p)+415)^[0] := pac8(PChar(p)+357)^[0]; pac8(PChar(p)+357)^[0] := num;
 pac32(PChar(p)+356)^[0] := pac32(PChar(p)+206)^[0] or (pac32(PChar(p)+324)^[0] xor $380d1a);
 pac64(PChar(p)+380)^[0] := pac64(PChar(p)+380)^[0] - $1859fa02;
 if pac8(PChar(p)+56)^[0] < pac8(PChar(p)+422)^[0] then pac32(PChar(p)+308)^[0] := ror1(pac32(PChar(p)+451)^[0] , 16 ) else pac16(PChar(p)+311)^[0] := pac16(PChar(p)+311)^[0] xor ror1(pac16(PChar(p)+400)^[0] , 8 );
 num := pac8(PChar(p)+296)^[0]; pac8(PChar(p)+296)^[0] := pac8(PChar(p)+376)^[0]; pac8(PChar(p)+376)^[0] := num;
 pac64(PChar(p)+252)^[0] := pac64(PChar(p)+252)^[0] xor $dcd94ea8;
 num := pac16(PChar(p)+458)^[0]; pac16(PChar(p)+458)^[0] := pac16(PChar(p)+145)^[0]; pac16(PChar(p)+145)^[0] := num;
 pac32(PChar(p)+447)^[0] := pac32(PChar(p)+447)^[0] or $34e4c2;

A87AE6C6(p);

end;

procedure A87AE6C6(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+420)^[0] := pac16(PChar(p)+420)^[0] or $18;
 pac64(PChar(p)+108)^[0] := pac64(PChar(p)+108)^[0] - $bc986801;

 if pac32(PChar(p)+111)^[0] > pac32(PChar(p)+50)^[0] then begin
   pac64(PChar(p)+135)^[0] := pac64(PChar(p)+150)^[0] + $f08612e52b;
   num := pac16(PChar(p)+13)^[0]; pac16(PChar(p)+13)^[0] := pac16(PChar(p)+83)^[0]; pac16(PChar(p)+83)^[0] := num;
   num := pac8(PChar(p)+182)^[0]; pac8(PChar(p)+182)^[0] := pac8(PChar(p)+205)^[0]; pac8(PChar(p)+205)^[0] := num;
   if pac16(PChar(p)+279)^[0] > pac16(PChar(p)+9)^[0] then pac32(PChar(p)+423)^[0] := pac32(PChar(p)+423)^[0] xor ror1(pac32(PChar(p)+191)^[0] , 19 ) else pac32(PChar(p)+237)^[0] := pac32(PChar(p)+237)^[0] xor ror2(pac32(PChar(p)+264)^[0] , 4 );
   pac32(PChar(p)+481)^[0] := pac32(PChar(p)+481)^[0] or ror2(pac32(PChar(p)+166)^[0] , 9 );
 end;

 num := pac16(PChar(p)+496)^[0]; pac16(PChar(p)+496)^[0] := pac16(PChar(p)+506)^[0]; pac16(PChar(p)+506)^[0] := num;
 num := pac8(PChar(p)+472)^[0]; pac8(PChar(p)+472)^[0] := pac8(PChar(p)+289)^[0]; pac8(PChar(p)+289)^[0] := num;
 pac32(PChar(p)+300)^[0] := pac32(PChar(p)+300)^[0] or rol1(pac32(PChar(p)+135)^[0] , 27 );
 pac32(PChar(p)+334)^[0] := pac32(PChar(p)+334)^[0] or (pac32(PChar(p)+174)^[0] xor $ac18);
 num := pac16(PChar(p)+345)^[0]; pac16(PChar(p)+345)^[0] := pac16(PChar(p)+172)^[0]; pac16(PChar(p)+172)^[0] := num;
 num := pac32(PChar(p)+348)^[0]; pac32(PChar(p)+348)^[0] := pac32(PChar(p)+171)^[0]; pac32(PChar(p)+171)^[0] := num;
 pac16(PChar(p)+389)^[0] := pac16(PChar(p)+389)^[0] or rol1(pac16(PChar(p)+98)^[0] , 6 );

 if pac8(PChar(p)+143)^[0] > pac8(PChar(p)+429)^[0] then begin
   if pac64(PChar(p)+59)^[0] > pac64(PChar(p)+21)^[0] then begin  num := pac8(PChar(p)+151)^[0]; pac8(PChar(p)+151)^[0] := pac8(PChar(p)+404)^[0]; pac8(PChar(p)+404)^[0] := num; end else pac64(PChar(p)+249)^[0] := pac64(PChar(p)+256)^[0] or $6c1b448e;
   num := pac16(PChar(p)+186)^[0]; pac16(PChar(p)+186)^[0] := pac16(PChar(p)+481)^[0]; pac16(PChar(p)+481)^[0] := num;
   if pac8(PChar(p)+139)^[0] > pac8(PChar(p)+367)^[0] then pac64(PChar(p)+394)^[0] := pac64(PChar(p)+394)^[0] or (pac64(PChar(p)+470)^[0] xor $c883fad4d34f) else begin  num := pac32(PChar(p)+110)^[0]; pac32(PChar(p)+110)^[0] := pac32(PChar(p)+364)^[0]; pac32(PChar(p)+364)^[0] := num; end;
   if pac64(PChar(p)+116)^[0] < pac64(PChar(p)+270)^[0] then pac32(PChar(p)+454)^[0] := pac32(PChar(p)+454)^[0] + ror1(pac32(PChar(p)+372)^[0] , 8 ) else begin  num := pac8(PChar(p)+79)^[0]; pac8(PChar(p)+79)^[0] := pac8(PChar(p)+124)^[0]; pac8(PChar(p)+124)^[0] := num; end;
   if pac16(PChar(p)+411)^[0] > pac16(PChar(p)+263)^[0] then pac16(PChar(p)+143)^[0] := pac16(PChar(p)+143)^[0] or (pac16(PChar(p)+413)^[0] - $f0) else pac32(PChar(p)+165)^[0] := pac32(PChar(p)+165)^[0] - rol1(pac32(PChar(p)+130)^[0] , 21 );
 end;

 num := pac8(PChar(p)+164)^[0]; pac8(PChar(p)+164)^[0] := pac8(PChar(p)+348)^[0]; pac8(PChar(p)+348)^[0] := num;

E83BDCFD(p);

end;

procedure E83BDCFD(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+160)^[0] := pac8(PChar(p)+160)^[0] - rol1(pac8(PChar(p)+24)^[0] , 3 );
 num := pac8(PChar(p)+105)^[0]; pac8(PChar(p)+105)^[0] := pac8(PChar(p)+138)^[0]; pac8(PChar(p)+138)^[0] := num;
 num := pac8(PChar(p)+80)^[0]; pac8(PChar(p)+80)^[0] := pac8(PChar(p)+74)^[0]; pac8(PChar(p)+74)^[0] := num;
 pac8(PChar(p)+492)^[0] := pac8(PChar(p)+492)^[0] xor (pac8(PChar(p)+492)^[0] + $e4);
 num := pac8(PChar(p)+114)^[0]; pac8(PChar(p)+114)^[0] := pac8(PChar(p)+95)^[0]; pac8(PChar(p)+95)^[0] := num;
 pac32(PChar(p)+345)^[0] := pac32(PChar(p)+345)^[0] + (pac32(PChar(p)+483)^[0] - $30c9);
 pac16(PChar(p)+443)^[0] := pac16(PChar(p)+443)^[0] or rol1(pac16(PChar(p)+162)^[0] , 8 );
 pac8(PChar(p)+366)^[0] := pac8(PChar(p)+366)^[0] xor rol1(pac8(PChar(p)+449)^[0] , 2 );
 pac64(PChar(p)+220)^[0] := pac64(PChar(p)+220)^[0] - $700467f8;
 pac8(PChar(p)+236)^[0] := pac8(PChar(p)+236)^[0] - rol1(pac8(PChar(p)+38)^[0] , 3 );
 pac8(PChar(p)+77)^[0] := pac8(PChar(p)+77)^[0] - ror2(pac8(PChar(p)+152)^[0] , 5 );
 pac16(PChar(p)+139)^[0] := pac16(PChar(p)+139)^[0] + (pac16(PChar(p)+36)^[0] - $60);

 if pac16(PChar(p)+56)^[0] < pac16(PChar(p)+242)^[0] then begin
   pac32(PChar(p)+243)^[0] := pac32(PChar(p)+243)^[0] xor ror2(pac32(PChar(p)+338)^[0] , 17 );
   pac32(PChar(p)+200)^[0] := pac32(PChar(p)+200)^[0] xor $94c2;
   pac16(PChar(p)+400)^[0] := pac16(PChar(p)+400)^[0] + $78;
   pac8(PChar(p)+413)^[0] := pac8(PChar(p)+413)^[0] + ror2(pac8(PChar(p)+475)^[0] , 3 );
   pac64(PChar(p)+36)^[0] := pac64(PChar(p)+472)^[0] + (pac64(PChar(p)+60)^[0] - $84d90228);
 end;

 if pac64(PChar(p)+319)^[0] > pac64(PChar(p)+374)^[0] then pac32(PChar(p)+471)^[0] := ror1(pac32(PChar(p)+395)^[0] , 5 ) else pac32(PChar(p)+343)^[0] := pac32(PChar(p)+90)^[0] + (pac32(PChar(p)+233)^[0] xor $2887);
 pac16(PChar(p)+424)^[0] := pac16(PChar(p)+424)^[0] - ror1(pac16(PChar(p)+159)^[0] , 10 );

FDE62AF8(p);

end;

procedure FDE62AF8(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+301)^[0] := pac32(PChar(p)+301)^[0] + rol1(pac32(PChar(p)+50)^[0] , 31 );
 num := pac32(PChar(p)+405)^[0]; pac32(PChar(p)+405)^[0] := pac32(PChar(p)+16)^[0]; pac32(PChar(p)+16)^[0] := num;
 pac32(PChar(p)+204)^[0] := pac32(PChar(p)+53)^[0] - $ac483d;
 num := pac32(PChar(p)+225)^[0]; pac32(PChar(p)+225)^[0] := pac32(PChar(p)+414)^[0]; pac32(PChar(p)+414)^[0] := num;
 pac8(PChar(p)+399)^[0] := pac8(PChar(p)+399)^[0] xor (pac8(PChar(p)+330)^[0] xor $54);
 num := pac8(PChar(p)+15)^[0]; pac8(PChar(p)+15)^[0] := pac8(PChar(p)+436)^[0]; pac8(PChar(p)+436)^[0] := num;
 if pac32(PChar(p)+62)^[0] > pac32(PChar(p)+69)^[0] then pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] xor ror1(pac32(PChar(p)+292)^[0] , 4 ) else begin  num := pac16(PChar(p)+160)^[0]; pac16(PChar(p)+160)^[0] := pac16(PChar(p)+214)^[0]; pac16(PChar(p)+214)^[0] := num; end;
 if pac32(PChar(p)+365)^[0] > pac32(PChar(p)+226)^[0] then begin  num := pac16(PChar(p)+296)^[0]; pac16(PChar(p)+296)^[0] := pac16(PChar(p)+349)^[0]; pac16(PChar(p)+349)^[0] := num; end else pac64(PChar(p)+101)^[0] := pac64(PChar(p)+257)^[0] + (pac64(PChar(p)+218)^[0] xor $00343778);
 pac32(PChar(p)+380)^[0] := pac32(PChar(p)+380)^[0] xor (pac32(PChar(p)+28)^[0] or $906d);
 pac64(PChar(p)+490)^[0] := pac64(PChar(p)+490)^[0] - (pac64(PChar(p)+68)^[0] + $00e244ef53);
 num := pac16(PChar(p)+145)^[0]; pac16(PChar(p)+145)^[0] := pac16(PChar(p)+193)^[0]; pac16(PChar(p)+193)^[0] := num;
 num := pac8(PChar(p)+347)^[0]; pac8(PChar(p)+347)^[0] := pac8(PChar(p)+219)^[0]; pac8(PChar(p)+219)^[0] := num;

 if pac64(PChar(p)+387)^[0] < pac64(PChar(p)+208)^[0] then begin
   pac8(PChar(p)+383)^[0] := pac8(PChar(p)+383)^[0] - ror2(pac8(PChar(p)+471)^[0] , 1 );
   pac32(PChar(p)+33)^[0] := pac32(PChar(p)+323)^[0] - (pac32(PChar(p)+194)^[0] + $549ad3);
 end;

 num := pac8(PChar(p)+368)^[0]; pac8(PChar(p)+368)^[0] := pac8(PChar(p)+298)^[0]; pac8(PChar(p)+298)^[0] := num;
 if pac8(PChar(p)+489)^[0] > pac8(PChar(p)+166)^[0] then begin  num := pac32(PChar(p)+169)^[0]; pac32(PChar(p)+169)^[0] := pac32(PChar(p)+261)^[0]; pac32(PChar(p)+261)^[0] := num; end else pac64(PChar(p)+87)^[0] := pac64(PChar(p)+87)^[0] xor (pac64(PChar(p)+411)^[0] xor $987c28e567);
 num := pac32(PChar(p)+497)^[0]; pac32(PChar(p)+497)^[0] := pac32(PChar(p)+132)^[0]; pac32(PChar(p)+132)^[0] := num;

E267513A(p);

end;

procedure E267513A(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+90)^[0] := pac64(PChar(p)+90)^[0] or (pac64(PChar(p)+396)^[0] xor $005377b00269);
 pac32(PChar(p)+72)^[0] := pac32(PChar(p)+72)^[0] + $38aad8;
 num := pac32(PChar(p)+91)^[0]; pac32(PChar(p)+91)^[0] := pac32(PChar(p)+217)^[0]; pac32(PChar(p)+217)^[0] := num;
 num := pac16(PChar(p)+193)^[0]; pac16(PChar(p)+193)^[0] := pac16(PChar(p)+72)^[0]; pac16(PChar(p)+72)^[0] := num;

 if pac64(PChar(p)+420)^[0] > pac64(PChar(p)+32)^[0] then begin
   pac64(PChar(p)+217)^[0] := pac64(PChar(p)+217)^[0] - (pac64(PChar(p)+105)^[0] xor $0473547b11);
   num := pac32(PChar(p)+228)^[0]; pac32(PChar(p)+228)^[0] := pac32(PChar(p)+356)^[0]; pac32(PChar(p)+356)^[0] := num;
 end;

 pac64(PChar(p)+22)^[0] := pac64(PChar(p)+22)^[0] or (pac64(PChar(p)+370)^[0] + $680480f2ee);

 if pac32(PChar(p)+218)^[0] < pac32(PChar(p)+169)^[0] then begin
   pac64(PChar(p)+384)^[0] := pac64(PChar(p)+384)^[0] - (pac64(PChar(p)+364)^[0] - $24bbb192df);
   pac64(PChar(p)+450)^[0] := pac64(PChar(p)+43)^[0] - (pac64(PChar(p)+266)^[0] - $54203ca3e10a);
   pac32(PChar(p)+435)^[0] := pac32(PChar(p)+435)^[0] or $28ce4d;
 end;


 if pac32(PChar(p)+495)^[0] > pac32(PChar(p)+6)^[0] then begin
   pac32(PChar(p)+417)^[0] := pac32(PChar(p)+417)^[0] - $60cf;
   pac16(PChar(p)+214)^[0] := pac16(PChar(p)+214)^[0] xor ror1(pac16(PChar(p)+320)^[0] , 12 );
 end;

 pac16(PChar(p)+486)^[0] := rol1(pac16(PChar(p)+261)^[0] , 11 );
 if pac16(PChar(p)+402)^[0] < pac16(PChar(p)+17)^[0] then pac16(PChar(p)+461)^[0] := pac16(PChar(p)+461)^[0] - $88 else pac64(PChar(p)+23)^[0] := pac64(PChar(p)+128)^[0] + (pac64(PChar(p)+231)^[0] or $e44312689bb4);
 pac16(PChar(p)+38)^[0] := pac16(PChar(p)+38)^[0] - ror1(pac16(PChar(p)+131)^[0] , 8 );
 num := pac8(PChar(p)+264)^[0]; pac8(PChar(p)+264)^[0] := pac8(PChar(p)+1)^[0]; pac8(PChar(p)+1)^[0] := num;

 if pac8(PChar(p)+475)^[0] > pac8(PChar(p)+396)^[0] then begin
   pac32(PChar(p)+369)^[0] := pac32(PChar(p)+369)^[0] or $789409;
   pac8(PChar(p)+485)^[0] := pac8(PChar(p)+485)^[0] or $d4;
   pac16(PChar(p)+472)^[0] := pac16(PChar(p)+472)^[0] xor (pac16(PChar(p)+304)^[0] xor $28);
   if pac32(PChar(p)+6)^[0] < pac32(PChar(p)+29)^[0] then pac64(PChar(p)+408)^[0] := pac64(PChar(p)+211)^[0] or $80505a9868 else pac32(PChar(p)+56)^[0] := pac32(PChar(p)+275)^[0] + $e86241;
   pac64(PChar(p)+332)^[0] := pac64(PChar(p)+332)^[0] xor $2c0425075fa9;
 end;

 pac32(PChar(p)+248)^[0] := pac32(PChar(p)+248)^[0] - ror1(pac32(PChar(p)+396)^[0] , 16 );
 pac8(PChar(p)+472)^[0] := pac8(PChar(p)+12)^[0] xor (pac8(PChar(p)+178)^[0] - $cc);

B076E2AA(p);

end;

procedure B076E2AA(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+337)^[0] < pac64(PChar(p)+463)^[0] then pac32(PChar(p)+16)^[0] := pac32(PChar(p)+16)^[0] - ror2(pac32(PChar(p)+180)^[0] , 19 ) else begin  num := pac16(PChar(p)+393)^[0]; pac16(PChar(p)+393)^[0] := pac16(PChar(p)+449)^[0]; pac16(PChar(p)+449)^[0] := num; end;
 num := pac16(PChar(p)+56)^[0]; pac16(PChar(p)+56)^[0] := pac16(PChar(p)+477)^[0]; pac16(PChar(p)+477)^[0] := num;
 if pac8(PChar(p)+441)^[0] < pac8(PChar(p)+376)^[0] then pac8(PChar(p)+116)^[0] := pac8(PChar(p)+116)^[0] - $b0 else pac8(PChar(p)+265)^[0] := pac8(PChar(p)+265)^[0] xor ror2(pac8(PChar(p)+489)^[0] , 6 );

 if pac64(PChar(p)+134)^[0] < pac64(PChar(p)+91)^[0] then begin
   if pac64(PChar(p)+167)^[0] < pac64(PChar(p)+198)^[0] then begin  num := pac8(PChar(p)+411)^[0]; pac8(PChar(p)+411)^[0] := pac8(PChar(p)+190)^[0]; pac8(PChar(p)+190)^[0] := num; end;
   if pac64(PChar(p)+439)^[0] < pac64(PChar(p)+239)^[0] then pac16(PChar(p)+510)^[0] := pac16(PChar(p)+510)^[0] + (pac16(PChar(p)+98)^[0] or $10);
   num := pac8(PChar(p)+261)^[0]; pac8(PChar(p)+261)^[0] := pac8(PChar(p)+66)^[0]; pac8(PChar(p)+66)^[0] := num;
   pac32(PChar(p)+106)^[0] := pac32(PChar(p)+106)^[0] + $8013a7;
   if pac16(PChar(p)+491)^[0] < pac16(PChar(p)+304)^[0] then pac64(PChar(p)+132)^[0] := pac64(PChar(p)+137)^[0] + (pac64(PChar(p)+405)^[0] + $f0434e3e) else pac8(PChar(p)+198)^[0] := pac8(PChar(p)+198)^[0] xor rol1(pac8(PChar(p)+461)^[0] , 6 );
 end;

 pac64(PChar(p)+95)^[0] := pac64(PChar(p)+95)^[0] or (pac64(PChar(p)+345)^[0] + $ace9348358);
 num := pac16(PChar(p)+391)^[0]; pac16(PChar(p)+391)^[0] := pac16(PChar(p)+335)^[0]; pac16(PChar(p)+335)^[0] := num;
 if pac32(PChar(p)+186)^[0] < pac32(PChar(p)+245)^[0] then pac32(PChar(p)+243)^[0] := pac32(PChar(p)+426)^[0] xor (pac32(PChar(p)+339)^[0] + $c8bd);
 pac8(PChar(p)+22)^[0] := pac8(PChar(p)+22)^[0] - rol1(pac8(PChar(p)+272)^[0] , 4 );
 num := pac16(PChar(p)+350)^[0]; pac16(PChar(p)+350)^[0] := pac16(PChar(p)+145)^[0]; pac16(PChar(p)+145)^[0] := num;

 if pac64(PChar(p)+370)^[0] > pac64(PChar(p)+400)^[0] then begin
   num := pac8(PChar(p)+306)^[0]; pac8(PChar(p)+306)^[0] := pac8(PChar(p)+262)^[0]; pac8(PChar(p)+262)^[0] := num;
   if pac32(PChar(p)+301)^[0] < pac32(PChar(p)+166)^[0] then pac64(PChar(p)+119)^[0] := pac64(PChar(p)+119)^[0] + $282cbf3f else begin  num := pac8(PChar(p)+111)^[0]; pac8(PChar(p)+111)^[0] := pac8(PChar(p)+35)^[0]; pac8(PChar(p)+35)^[0] := num; end;
   num := pac8(PChar(p)+0)^[0]; pac8(PChar(p)+0)^[0] := pac8(PChar(p)+234)^[0]; pac8(PChar(p)+234)^[0] := num;
   pac8(PChar(p)+481)^[0] := pac8(PChar(p)+481)^[0] or $58;
 end;

 pac16(PChar(p)+36)^[0] := pac16(PChar(p)+36)^[0] or $08;
 pac64(PChar(p)+404)^[0] := pac64(PChar(p)+404)^[0] or $5480834c31;
 pac16(PChar(p)+362)^[0] := pac16(PChar(p)+362)^[0] xor rol1(pac16(PChar(p)+436)^[0] , 5 );
 if pac16(PChar(p)+498)^[0] < pac16(PChar(p)+478)^[0] then pac32(PChar(p)+124)^[0] := pac32(PChar(p)+124)^[0] + $2c83 else pac64(PChar(p)+406)^[0] := pac64(PChar(p)+406)^[0] or $cc96fd591e44;
 pac16(PChar(p)+397)^[0] := pac16(PChar(p)+397)^[0] or rol1(pac16(PChar(p)+266)^[0] , 5 );

 if pac16(PChar(p)+195)^[0] > pac16(PChar(p)+265)^[0] then begin
   pac32(PChar(p)+339)^[0] := pac32(PChar(p)+339)^[0] or $1865a1;
   pac8(PChar(p)+454)^[0] := pac8(PChar(p)+66)^[0] or $14;
 end;


C73E5EB9(p);

end;

procedure C73E5EB9(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+167)^[0] := pac64(PChar(p)+167)^[0] or $44f505c0;

 if pac32(PChar(p)+219)^[0] < pac32(PChar(p)+97)^[0] then begin
   pac64(PChar(p)+194)^[0] := pac64(PChar(p)+194)^[0] - (pac64(PChar(p)+316)^[0] or $943177a164);
   pac8(PChar(p)+138)^[0] := pac8(PChar(p)+138)^[0] or (pac8(PChar(p)+500)^[0] or $5c);
   pac8(PChar(p)+192)^[0] := pac8(PChar(p)+192)^[0] - ror2(pac8(PChar(p)+338)^[0] , 7 );
   if pac32(PChar(p)+355)^[0] < pac32(PChar(p)+163)^[0] then begin  num := pac32(PChar(p)+35)^[0]; pac32(PChar(p)+35)^[0] := pac32(PChar(p)+221)^[0]; pac32(PChar(p)+221)^[0] := num; end else pac64(PChar(p)+66)^[0] := pac64(PChar(p)+374)^[0] xor (pac64(PChar(p)+483)^[0] xor $488f2644ee);
   pac16(PChar(p)+48)^[0] := pac16(PChar(p)+48)^[0] - $cc;
 end;

 pac8(PChar(p)+202)^[0] := pac8(PChar(p)+202)^[0] xor (pac8(PChar(p)+290)^[0] xor $28);
 num := pac8(PChar(p)+244)^[0]; pac8(PChar(p)+244)^[0] := pac8(PChar(p)+302)^[0]; pac8(PChar(p)+302)^[0] := num;
 if pac32(PChar(p)+330)^[0] > pac32(PChar(p)+195)^[0] then pac16(PChar(p)+269)^[0] := pac16(PChar(p)+269)^[0] xor (pac16(PChar(p)+190)^[0] or $f8);

 if pac16(PChar(p)+350)^[0] > pac16(PChar(p)+3)^[0] then begin
   if pac32(PChar(p)+438)^[0] > pac32(PChar(p)+308)^[0] then pac32(PChar(p)+295)^[0] := pac32(PChar(p)+295)^[0] - (pac32(PChar(p)+45)^[0] + $981e4a) else pac64(PChar(p)+490)^[0] := pac64(PChar(p)+357)^[0] xor $f0ce426b44;
   pac16(PChar(p)+243)^[0] := rol1(pac16(PChar(p)+259)^[0] , 4 );
   if pac8(PChar(p)+41)^[0] < pac8(PChar(p)+434)^[0] then begin  num := pac16(PChar(p)+201)^[0]; pac16(PChar(p)+201)^[0] := pac16(PChar(p)+81)^[0]; pac16(PChar(p)+81)^[0] := num; end else pac64(PChar(p)+493)^[0] := pac64(PChar(p)+493)^[0] - (pac64(PChar(p)+254)^[0] - $68447fccdbd4);
   pac16(PChar(p)+268)^[0] := pac16(PChar(p)+268)^[0] + $fc;
 end;


 if pac8(PChar(p)+365)^[0] > pac8(PChar(p)+389)^[0] then begin
   if pac8(PChar(p)+264)^[0] > pac8(PChar(p)+393)^[0] then pac8(PChar(p)+388)^[0] := pac8(PChar(p)+388)^[0] xor ror2(pac8(PChar(p)+249)^[0] , 3 ) else pac32(PChar(p)+495)^[0] := rol1(pac32(PChar(p)+407)^[0] , 19 );
   pac64(PChar(p)+182)^[0] := pac64(PChar(p)+182)^[0] xor $fc41d0467afd;
   pac16(PChar(p)+72)^[0] := pac16(PChar(p)+72)^[0] - ror2(pac16(PChar(p)+424)^[0] , 2 );
 end;

 pac32(PChar(p)+66)^[0] := pac32(PChar(p)+100)^[0] + (pac32(PChar(p)+222)^[0] or $bc82);
 pac32(PChar(p)+477)^[0] := pac32(PChar(p)+182)^[0] - (pac32(PChar(p)+355)^[0] + $2428f0);
 num := pac32(PChar(p)+170)^[0]; pac32(PChar(p)+170)^[0] := pac32(PChar(p)+163)^[0]; pac32(PChar(p)+163)^[0] := num;
 pac32(PChar(p)+162)^[0] := pac32(PChar(p)+162)^[0] xor ror2(pac32(PChar(p)+333)^[0] , 20 );
 if pac16(PChar(p)+325)^[0] > pac16(PChar(p)+48)^[0] then pac64(PChar(p)+23)^[0] := pac64(PChar(p)+23)^[0] + $e8d974f106 else pac32(PChar(p)+247)^[0] := pac32(PChar(p)+247)^[0] + ror2(pac32(PChar(p)+348)^[0] , 4 );
 if pac64(PChar(p)+277)^[0] > pac64(PChar(p)+477)^[0] then pac16(PChar(p)+463)^[0] := pac16(PChar(p)+463)^[0] - (pac16(PChar(p)+56)^[0] + $84) else pac64(PChar(p)+25)^[0] := pac64(PChar(p)+25)^[0] + $3085d2590f24;

 if pac64(PChar(p)+304)^[0] > pac64(PChar(p)+410)^[0] then begin
   if pac64(PChar(p)+292)^[0] > pac64(PChar(p)+432)^[0] then pac64(PChar(p)+216)^[0] := pac64(PChar(p)+216)^[0] + (pac64(PChar(p)+181)^[0] xor $fc3d99827b) else begin  num := pac8(PChar(p)+8)^[0]; pac8(PChar(p)+8)^[0] := pac8(PChar(p)+390)^[0]; pac8(PChar(p)+390)^[0] := num; end;
   pac8(PChar(p)+19)^[0] := pac8(PChar(p)+19)^[0] + ror2(pac8(PChar(p)+28)^[0] , 3 );
   pac16(PChar(p)+188)^[0] := pac16(PChar(p)+188)^[0] - (pac16(PChar(p)+218)^[0] + $54);
   pac32(PChar(p)+158)^[0] := pac32(PChar(p)+158)^[0] + ror2(pac32(PChar(p)+175)^[0] , 11 );
 end;

 pac8(PChar(p)+330)^[0] := pac8(PChar(p)+330)^[0] + $d0;

 if pac32(PChar(p)+38)^[0] > pac32(PChar(p)+34)^[0] then begin
   pac64(PChar(p)+398)^[0] := pac64(PChar(p)+489)^[0] + $00b69774d2;
   if pac64(PChar(p)+489)^[0] > pac64(PChar(p)+382)^[0] then pac32(PChar(p)+220)^[0] := rol1(pac32(PChar(p)+45)^[0] , 3 ) else pac16(PChar(p)+223)^[0] := pac16(PChar(p)+223)^[0] or rol1(pac16(PChar(p)+504)^[0] , 2 );
   pac32(PChar(p)+207)^[0] := pac32(PChar(p)+207)^[0] xor $1c5b;
   pac16(PChar(p)+180)^[0] := pac16(PChar(p)+180)^[0] or ror2(pac16(PChar(p)+109)^[0] , 12 );
   pac8(PChar(p)+398)^[0] := pac8(PChar(p)+398)^[0] + ror2(pac8(PChar(p)+482)^[0] , 1 );
 end;

 pac8(PChar(p)+374)^[0] := pac8(PChar(p)+374)^[0] + ror1(pac8(PChar(p)+337)^[0] , 3 );
 pac8(PChar(p)+80)^[0] := pac8(PChar(p)+80)^[0] - rol1(pac8(PChar(p)+198)^[0] , 6 );

FE35DDD2(p);

end;

procedure FE35DDD2(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+363)^[0] > pac16(PChar(p)+66)^[0] then begin
   pac16(PChar(p)+92)^[0] := pac16(PChar(p)+217)^[0] + $4c;
   pac8(PChar(p)+103)^[0] := pac8(PChar(p)+103)^[0] or ror1(pac8(PChar(p)+79)^[0] , 2 );
   pac8(PChar(p)+366)^[0] := pac8(PChar(p)+485)^[0] - (pac8(PChar(p)+295)^[0] - $70);
   pac32(PChar(p)+161)^[0] := pac32(PChar(p)+161)^[0] + rol1(pac32(PChar(p)+54)^[0] , 30 );
 end;

 pac16(PChar(p)+420)^[0] := pac16(PChar(p)+117)^[0] xor (pac16(PChar(p)+4)^[0] or $64);
 pac8(PChar(p)+276)^[0] := ror1(pac8(PChar(p)+110)^[0] , 2 );
 pac32(PChar(p)+491)^[0] := pac32(PChar(p)+491)^[0] xor rol1(pac32(PChar(p)+480)^[0] , 19 );
 pac16(PChar(p)+414)^[0] := ror2(pac16(PChar(p)+257)^[0] , 5 );
 pac16(PChar(p)+118)^[0] := pac16(PChar(p)+118)^[0] xor $f0;
 pac8(PChar(p)+42)^[0] := pac8(PChar(p)+42)^[0] - ror2(pac8(PChar(p)+405)^[0] , 3 );
 num := pac32(PChar(p)+299)^[0]; pac32(PChar(p)+299)^[0] := pac32(PChar(p)+396)^[0]; pac32(PChar(p)+396)^[0] := num;
 pac64(PChar(p)+46)^[0] := pac64(PChar(p)+46)^[0] xor $1ca62b34bf62;
 pac64(PChar(p)+198)^[0] := pac64(PChar(p)+198)^[0] or $b814453b;
 pac64(PChar(p)+225)^[0] := pac64(PChar(p)+225)^[0] - (pac64(PChar(p)+240)^[0] - $48a72f2fb0);
 num := pac16(PChar(p)+463)^[0]; pac16(PChar(p)+463)^[0] := pac16(PChar(p)+20)^[0]; pac16(PChar(p)+20)^[0] := num;
 num := pac8(PChar(p)+65)^[0]; pac8(PChar(p)+65)^[0] := pac8(PChar(p)+319)^[0]; pac8(PChar(p)+319)^[0] := num;

 if pac64(PChar(p)+7)^[0] < pac64(PChar(p)+204)^[0] then begin
   num := pac8(PChar(p)+153)^[0]; pac8(PChar(p)+153)^[0] := pac8(PChar(p)+256)^[0]; pac8(PChar(p)+256)^[0] := num;
   num := pac16(PChar(p)+24)^[0]; pac16(PChar(p)+24)^[0] := pac16(PChar(p)+49)^[0]; pac16(PChar(p)+49)^[0] := num;
   num := pac8(PChar(p)+132)^[0]; pac8(PChar(p)+132)^[0] := pac8(PChar(p)+302)^[0]; pac8(PChar(p)+302)^[0] := num;
   if pac64(PChar(p)+159)^[0] < pac64(PChar(p)+228)^[0] then pac8(PChar(p)+356)^[0] := pac8(PChar(p)+356)^[0] xor rol1(pac8(PChar(p)+18)^[0] , 3 ) else pac8(PChar(p)+391)^[0] := pac8(PChar(p)+369)^[0] or $0c;
   if pac16(PChar(p)+163)^[0] < pac16(PChar(p)+283)^[0] then begin  num := pac16(PChar(p)+332)^[0]; pac16(PChar(p)+332)^[0] := pac16(PChar(p)+72)^[0]; pac16(PChar(p)+72)^[0] := num; end else begin  num := pac16(PChar(p)+500)^[0]; pac16(PChar(p)+500)^[0] := pac16(PChar(p)+464)^[0]; pac16(PChar(p)+464)^[0] := num; end;
 end;

 pac32(PChar(p)+444)^[0] := pac32(PChar(p)+1)^[0] - (pac32(PChar(p)+119)^[0] - $308479);

C53C522B(p);

end;

procedure C53C522B(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+160)^[0] := pac64(PChar(p)+160)^[0] - $8887c77b412c;
 if pac32(PChar(p)+195)^[0] < pac32(PChar(p)+81)^[0] then begin  num := pac8(PChar(p)+487)^[0]; pac8(PChar(p)+487)^[0] := pac8(PChar(p)+414)^[0]; pac8(PChar(p)+414)^[0] := num; end else pac64(PChar(p)+391)^[0] := pac64(PChar(p)+391)^[0] - (pac64(PChar(p)+375)^[0] or $e0df7825dd);
 num := pac8(PChar(p)+325)^[0]; pac8(PChar(p)+325)^[0] := pac8(PChar(p)+273)^[0]; pac8(PChar(p)+273)^[0] := num;
 pac64(PChar(p)+32)^[0] := pac64(PChar(p)+32)^[0] + (pac64(PChar(p)+366)^[0] xor $0cf4fa03c8ba);
 pac8(PChar(p)+409)^[0] := pac8(PChar(p)+409)^[0] xor ror2(pac8(PChar(p)+399)^[0] , 5 );
 pac8(PChar(p)+331)^[0] := pac8(PChar(p)+331)^[0] xor ror1(pac8(PChar(p)+174)^[0] , 3 );
 pac16(PChar(p)+247)^[0] := pac16(PChar(p)+247)^[0] xor $58;

 if pac16(PChar(p)+466)^[0] < pac16(PChar(p)+59)^[0] then begin
   num := pac8(PChar(p)+279)^[0]; pac8(PChar(p)+279)^[0] := pac8(PChar(p)+47)^[0]; pac8(PChar(p)+47)^[0] := num;
   if pac32(PChar(p)+334)^[0] < pac32(PChar(p)+96)^[0] then pac64(PChar(p)+16)^[0] := pac64(PChar(p)+16)^[0] + $88efd3e89a else pac64(PChar(p)+43)^[0] := pac64(PChar(p)+43)^[0] or (pac64(PChar(p)+431)^[0] or $ac5a2f5ae720);
   num := pac8(PChar(p)+456)^[0]; pac8(PChar(p)+456)^[0] := pac8(PChar(p)+273)^[0]; pac8(PChar(p)+273)^[0] := num;
   pac16(PChar(p)+403)^[0] := pac16(PChar(p)+403)^[0] + (pac16(PChar(p)+334)^[0] or $ec);
   pac32(PChar(p)+371)^[0] := ror1(pac32(PChar(p)+303)^[0] , 16 );
 end;

 pac32(PChar(p)+134)^[0] := pac32(PChar(p)+134)^[0] - ror2(pac32(PChar(p)+245)^[0] , 15 );

 if pac64(PChar(p)+206)^[0] < pac64(PChar(p)+30)^[0] then begin
   pac32(PChar(p)+56)^[0] := pac32(PChar(p)+56)^[0] + ror2(pac32(PChar(p)+21)^[0] , 5 );
   pac64(PChar(p)+94)^[0] := pac64(PChar(p)+332)^[0] + (pac64(PChar(p)+35)^[0] + $5c083658e02f);
 end;


B315E6D5(p);

end;

procedure B315E6D5(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+202)^[0] := pac32(PChar(p)+202)^[0] + rol1(pac32(PChar(p)+468)^[0] , 11 );
 num := pac32(PChar(p)+427)^[0]; pac32(PChar(p)+427)^[0] := pac32(PChar(p)+426)^[0]; pac32(PChar(p)+426)^[0] := num;
 num := pac32(PChar(p)+443)^[0]; pac32(PChar(p)+443)^[0] := pac32(PChar(p)+288)^[0]; pac32(PChar(p)+288)^[0] := num;
 num := pac8(PChar(p)+463)^[0]; pac8(PChar(p)+463)^[0] := pac8(PChar(p)+126)^[0]; pac8(PChar(p)+126)^[0] := num;
 pac16(PChar(p)+154)^[0] := pac16(PChar(p)+154)^[0] xor rol1(pac16(PChar(p)+232)^[0] , 13 );
 num := pac32(PChar(p)+90)^[0]; pac32(PChar(p)+90)^[0] := pac32(PChar(p)+492)^[0]; pac32(PChar(p)+492)^[0] := num;
 pac32(PChar(p)+206)^[0] := pac32(PChar(p)+206)^[0] or (pac32(PChar(p)+460)^[0] + $4c4d84);
 pac32(PChar(p)+22)^[0] := pac32(PChar(p)+22)^[0] or $9c90e6;
 pac8(PChar(p)+407)^[0] := pac8(PChar(p)+407)^[0] + rol1(pac8(PChar(p)+435)^[0] , 2 );

 if pac32(PChar(p)+228)^[0] > pac32(PChar(p)+111)^[0] then begin
   pac64(PChar(p)+417)^[0] := pac64(PChar(p)+14)^[0] - (pac64(PChar(p)+350)^[0] + $58d82f550f05);
   pac8(PChar(p)+305)^[0] := ror2(pac8(PChar(p)+65)^[0] , 2 );
   pac64(PChar(p)+12)^[0] := pac64(PChar(p)+12)^[0] - $f8c2bfe1ba;
 end;

 pac64(PChar(p)+322)^[0] := pac64(PChar(p)+322)^[0] or $8c7f92a8;

A917D33F(p);

end;

procedure A917D33F(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+227)^[0] > pac8(PChar(p)+500)^[0] then pac64(PChar(p)+113)^[0] := pac64(PChar(p)+113)^[0] or $8885db8c else begin  num := pac32(PChar(p)+7)^[0]; pac32(PChar(p)+7)^[0] := pac32(PChar(p)+343)^[0]; pac32(PChar(p)+343)^[0] := num; end;
 pac64(PChar(p)+10)^[0] := pac64(PChar(p)+10)^[0] xor (pac64(PChar(p)+459)^[0] or $949229be);
 pac64(PChar(p)+37)^[0] := pac64(PChar(p)+37)^[0] + (pac64(PChar(p)+316)^[0] + $d4988463d6);
 pac16(PChar(p)+490)^[0] := pac16(PChar(p)+490)^[0] or (pac16(PChar(p)+499)^[0] - $6c);
 pac32(PChar(p)+133)^[0] := pac32(PChar(p)+133)^[0] xor rol1(pac32(PChar(p)+475)^[0] , 24 );
 pac64(PChar(p)+335)^[0] := pac64(PChar(p)+335)^[0] or $3c61057e47;
 pac64(PChar(p)+152)^[0] := pac64(PChar(p)+152)^[0] + (pac64(PChar(p)+341)^[0] - $0cc0ec6f37);
 pac8(PChar(p)+95)^[0] := pac8(PChar(p)+95)^[0] + $80;
 num := pac32(PChar(p)+174)^[0]; pac32(PChar(p)+174)^[0] := pac32(PChar(p)+125)^[0]; pac32(PChar(p)+125)^[0] := num;
 num := pac16(PChar(p)+482)^[0]; pac16(PChar(p)+482)^[0] := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := num;
 if pac8(PChar(p)+460)^[0] > pac8(PChar(p)+212)^[0] then pac64(PChar(p)+358)^[0] := pac64(PChar(p)+358)^[0] - (pac64(PChar(p)+140)^[0] + $584b41c4) else pac64(PChar(p)+175)^[0] := pac64(PChar(p)+175)^[0] + $e8930868;
 pac8(PChar(p)+505)^[0] := pac8(PChar(p)+505)^[0] xor rol1(pac8(PChar(p)+119)^[0] , 4 );
 num := pac16(PChar(p)+224)^[0]; pac16(PChar(p)+224)^[0] := pac16(PChar(p)+58)^[0]; pac16(PChar(p)+58)^[0] := num;
 num := pac16(PChar(p)+285)^[0]; pac16(PChar(p)+285)^[0] := pac16(PChar(p)+94)^[0]; pac16(PChar(p)+94)^[0] := num;
 num := pac8(PChar(p)+414)^[0]; pac8(PChar(p)+414)^[0] := pac8(PChar(p)+118)^[0]; pac8(PChar(p)+118)^[0] := num;
 pac64(PChar(p)+421)^[0] := pac64(PChar(p)+421)^[0] or $74c7800e;
 if pac32(PChar(p)+241)^[0] < pac32(PChar(p)+233)^[0] then pac16(PChar(p)+2)^[0] := ror2(pac16(PChar(p)+367)^[0] , 10 ) else pac8(PChar(p)+315)^[0] := pac8(PChar(p)+315)^[0] or $f0;

 if pac16(PChar(p)+351)^[0] < pac16(PChar(p)+54)^[0] then begin
   pac8(PChar(p)+343)^[0] := pac8(PChar(p)+343)^[0] - $94;
   if pac8(PChar(p)+425)^[0] < pac8(PChar(p)+389)^[0] then pac8(PChar(p)+306)^[0] := ror2(pac8(PChar(p)+244)^[0] , 4 ) else pac32(PChar(p)+199)^[0] := pac32(PChar(p)+199)^[0] - rol1(pac32(PChar(p)+488)^[0] , 12 );
 end;

 num := pac32(PChar(p)+504)^[0]; pac32(PChar(p)+504)^[0] := pac32(PChar(p)+57)^[0]; pac32(PChar(p)+57)^[0] := num;

BA2BD887(p);

end;

procedure BA2BD887(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+314)^[0] < pac8(PChar(p)+234)^[0] then begin
   num := pac8(PChar(p)+321)^[0]; pac8(PChar(p)+321)^[0] := pac8(PChar(p)+162)^[0]; pac8(PChar(p)+162)^[0] := num;
   pac32(PChar(p)+94)^[0] := pac32(PChar(p)+94)^[0] xor ror1(pac32(PChar(p)+471)^[0] , 1 );
   if pac8(PChar(p)+450)^[0] < pac8(PChar(p)+415)^[0] then pac64(PChar(p)+369)^[0] := pac64(PChar(p)+369)^[0] xor (pac64(PChar(p)+447)^[0] xor $bc6c93fb2f) else begin  num := pac8(PChar(p)+495)^[0]; pac8(PChar(p)+495)^[0] := pac8(PChar(p)+138)^[0]; pac8(PChar(p)+138)^[0] := num; end;
 end;


 if pac64(PChar(p)+330)^[0] < pac64(PChar(p)+310)^[0] then begin
   num := pac8(PChar(p)+218)^[0]; pac8(PChar(p)+218)^[0] := pac8(PChar(p)+206)^[0]; pac8(PChar(p)+206)^[0] := num;
   pac64(PChar(p)+43)^[0] := pac64(PChar(p)+43)^[0] or $f8e4691b;
   pac16(PChar(p)+158)^[0] := pac16(PChar(p)+158)^[0] or $64;
   pac64(PChar(p)+229)^[0] := pac64(PChar(p)+401)^[0] - (pac64(PChar(p)+425)^[0] or $74e7a49ed7d4);
 end;

 if pac8(PChar(p)+69)^[0] > pac8(PChar(p)+65)^[0] then begin  num := pac16(PChar(p)+432)^[0]; pac16(PChar(p)+432)^[0] := pac16(PChar(p)+67)^[0]; pac16(PChar(p)+67)^[0] := num; end;
 num := pac8(PChar(p)+171)^[0]; pac8(PChar(p)+171)^[0] := pac8(PChar(p)+145)^[0]; pac8(PChar(p)+145)^[0] := num;
 pac32(PChar(p)+28)^[0] := pac32(PChar(p)+19)^[0] - (pac32(PChar(p)+92)^[0] + $58fdb7);
 if pac64(PChar(p)+284)^[0] > pac64(PChar(p)+77)^[0] then pac32(PChar(p)+439)^[0] := pac32(PChar(p)+439)^[0] xor ror2(pac32(PChar(p)+478)^[0] , 31 ) else pac8(PChar(p)+129)^[0] := pac8(PChar(p)+129)^[0] - (pac8(PChar(p)+455)^[0] or $c8);

 if pac64(PChar(p)+286)^[0] > pac64(PChar(p)+319)^[0] then begin
   num := pac8(PChar(p)+344)^[0]; pac8(PChar(p)+344)^[0] := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := num;
   pac64(PChar(p)+352)^[0] := pac64(PChar(p)+352)^[0] + $a0af79b6;
   pac16(PChar(p)+470)^[0] := pac16(PChar(p)+83)^[0] - (pac16(PChar(p)+67)^[0] xor $0c);
   pac16(PChar(p)+104)^[0] := ror2(pac16(PChar(p)+458)^[0] , 1 );
   num := pac32(PChar(p)+14)^[0]; pac32(PChar(p)+14)^[0] := pac32(PChar(p)+153)^[0]; pac32(PChar(p)+153)^[0] := num;
 end;

 pac32(PChar(p)+54)^[0] := pac32(PChar(p)+54)^[0] + (pac32(PChar(p)+332)^[0] + $301abd);
 pac32(PChar(p)+57)^[0] := pac32(PChar(p)+57)^[0] xor ror2(pac32(PChar(p)+167)^[0] , 18 );
 pac64(PChar(p)+29)^[0] := pac64(PChar(p)+29)^[0] xor (pac64(PChar(p)+458)^[0] or $2820ba15);

 if pac8(PChar(p)+110)^[0] < pac8(PChar(p)+258)^[0] then begin
   num := pac16(PChar(p)+171)^[0]; pac16(PChar(p)+171)^[0] := pac16(PChar(p)+114)^[0]; pac16(PChar(p)+114)^[0] := num;
   pac8(PChar(p)+10)^[0] := pac8(PChar(p)+10)^[0] xor (pac8(PChar(p)+178)^[0] or $ec);
   num := pac16(PChar(p)+174)^[0]; pac16(PChar(p)+174)^[0] := pac16(PChar(p)+287)^[0]; pac16(PChar(p)+287)^[0] := num;
   pac8(PChar(p)+443)^[0] := pac8(PChar(p)+443)^[0] xor ror2(pac8(PChar(p)+164)^[0] , 6 );
   pac32(PChar(p)+363)^[0] := pac32(PChar(p)+363)^[0] - ror1(pac32(PChar(p)+448)^[0] , 16 );
 end;


 if pac16(PChar(p)+443)^[0] > pac16(PChar(p)+473)^[0] then begin
   if pac8(PChar(p)+17)^[0] < pac8(PChar(p)+467)^[0] then pac8(PChar(p)+153)^[0] := pac8(PChar(p)+153)^[0] or ror1(pac8(PChar(p)+432)^[0] , 2 ) else pac64(PChar(p)+79)^[0] := pac64(PChar(p)+79)^[0] + $18b65263;
   if pac64(PChar(p)+18)^[0] > pac64(PChar(p)+412)^[0] then pac64(PChar(p)+146)^[0] := pac64(PChar(p)+451)^[0] or (pac64(PChar(p)+469)^[0] + $a89841702b) else begin  num := pac16(PChar(p)+219)^[0]; pac16(PChar(p)+219)^[0] := pac16(PChar(p)+127)^[0]; pac16(PChar(p)+127)^[0] := num; end;
 end;

 pac32(PChar(p)+404)^[0] := pac32(PChar(p)+404)^[0] + ror1(pac32(PChar(p)+122)^[0] , 18 );
 pac16(PChar(p)+495)^[0] := pac16(PChar(p)+495)^[0] - $b8;
 pac64(PChar(p)+57)^[0] := pac64(PChar(p)+57)^[0] xor (pac64(PChar(p)+176)^[0] xor $a8fe60a1cd69);
 pac64(PChar(p)+209)^[0] := pac64(PChar(p)+209)^[0] xor (pac64(PChar(p)+261)^[0] or $f4d980736a);
 num := pac8(PChar(p)+147)^[0]; pac8(PChar(p)+147)^[0] := pac8(PChar(p)+497)^[0]; pac8(PChar(p)+497)^[0] := num;

A6CD85C3(p);

end;

procedure A6CD85C3(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+305)^[0]; pac8(PChar(p)+305)^[0] := pac8(PChar(p)+92)^[0]; pac8(PChar(p)+92)^[0] := num;
 pac32(PChar(p)+257)^[0] := pac32(PChar(p)+464)^[0] xor (pac32(PChar(p)+138)^[0] + $54cd4e);
 num := pac16(PChar(p)+362)^[0]; pac16(PChar(p)+362)^[0] := pac16(PChar(p)+298)^[0]; pac16(PChar(p)+298)^[0] := num;
 pac8(PChar(p)+270)^[0] := rol1(pac8(PChar(p)+366)^[0] , 2 );
 num := pac16(PChar(p)+255)^[0]; pac16(PChar(p)+255)^[0] := pac16(PChar(p)+406)^[0]; pac16(PChar(p)+406)^[0] := num;
 num := pac16(PChar(p)+301)^[0]; pac16(PChar(p)+301)^[0] := pac16(PChar(p)+340)^[0]; pac16(PChar(p)+340)^[0] := num;
 pac64(PChar(p)+257)^[0] := pac64(PChar(p)+257)^[0] + $fcbd3a43;
 pac64(PChar(p)+285)^[0] := pac64(PChar(p)+443)^[0] xor (pac64(PChar(p)+484)^[0] - $9c71218acb);
 if pac32(PChar(p)+143)^[0] < pac32(PChar(p)+263)^[0] then pac8(PChar(p)+443)^[0] := pac8(PChar(p)+443)^[0] or ror2(pac8(PChar(p)+396)^[0] , 1 ) else pac32(PChar(p)+256)^[0] := pac32(PChar(p)+256)^[0] + $c81305;
 if pac16(PChar(p)+451)^[0] < pac16(PChar(p)+181)^[0] then begin  num := pac16(PChar(p)+367)^[0]; pac16(PChar(p)+367)^[0] := pac16(PChar(p)+503)^[0]; pac16(PChar(p)+503)^[0] := num; end else pac64(PChar(p)+360)^[0] := pac64(PChar(p)+360)^[0] + (pac64(PChar(p)+465)^[0] or $7442585f);
 if pac16(PChar(p)+309)^[0] < pac16(PChar(p)+359)^[0] then pac16(PChar(p)+264)^[0] := pac16(PChar(p)+264)^[0] or ror2(pac16(PChar(p)+259)^[0] , 13 ) else pac8(PChar(p)+374)^[0] := pac8(PChar(p)+374)^[0] - ror1(pac8(PChar(p)+420)^[0] , 1 );

 if pac64(PChar(p)+431)^[0] < pac64(PChar(p)+16)^[0] then begin
   num := pac8(PChar(p)+370)^[0]; pac8(PChar(p)+370)^[0] := pac8(PChar(p)+110)^[0]; pac8(PChar(p)+110)^[0] := num;
   pac64(PChar(p)+271)^[0] := pac64(PChar(p)+271)^[0] - $285dff24b3;
   pac16(PChar(p)+4)^[0] := pac16(PChar(p)+4)^[0] or ror2(pac16(PChar(p)+3)^[0] , 2 );
   num := pac32(PChar(p)+496)^[0]; pac32(PChar(p)+496)^[0] := pac32(PChar(p)+111)^[0]; pac32(PChar(p)+111)^[0] := num;
   pac64(PChar(p)+450)^[0] := pac64(PChar(p)+450)^[0] + $845ad1ff;
 end;

 pac64(PChar(p)+346)^[0] := pac64(PChar(p)+346)^[0] - (pac64(PChar(p)+153)^[0] or $8035ff5b);

FE1B8662(p);

end;

procedure FE1B8662(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+67)^[0] := pac32(PChar(p)+67)^[0] - $f855;
 pac32(PChar(p)+99)^[0] := pac32(PChar(p)+99)^[0] or ror2(pac32(PChar(p)+266)^[0] , 24 );
 num := pac8(PChar(p)+413)^[0]; pac8(PChar(p)+413)^[0] := pac8(PChar(p)+265)^[0]; pac8(PChar(p)+265)^[0] := num;
 pac64(PChar(p)+501)^[0] := pac64(PChar(p)+501)^[0] - $04a3aa48;
 pac64(PChar(p)+23)^[0] := pac64(PChar(p)+23)^[0] + $145919f444;
 pac16(PChar(p)+476)^[0] := pac16(PChar(p)+476)^[0] or (pac16(PChar(p)+261)^[0] - $1c);

 if pac16(PChar(p)+168)^[0] < pac16(PChar(p)+62)^[0] then begin
   pac64(PChar(p)+162)^[0] := pac64(PChar(p)+88)^[0] xor (pac64(PChar(p)+482)^[0] or $3413a894);
   if pac32(PChar(p)+127)^[0] < pac32(PChar(p)+15)^[0] then begin  num := pac16(PChar(p)+404)^[0]; pac16(PChar(p)+404)^[0] := pac16(PChar(p)+36)^[0]; pac16(PChar(p)+36)^[0] := num; end else pac16(PChar(p)+438)^[0] := pac16(PChar(p)+438)^[0] xor ror1(pac16(PChar(p)+484)^[0] , 9 );
   pac8(PChar(p)+64)^[0] := rol1(pac8(PChar(p)+174)^[0] , 5 );
   if pac32(PChar(p)+504)^[0] > pac32(PChar(p)+378)^[0] then pac16(PChar(p)+161)^[0] := pac16(PChar(p)+161)^[0] xor $ec;
 end;

 pac64(PChar(p)+140)^[0] := pac64(PChar(p)+140)^[0] + $c472bdfe8c8a;

 if pac64(PChar(p)+152)^[0] < pac64(PChar(p)+58)^[0] then begin
   pac64(PChar(p)+292)^[0] := pac64(PChar(p)+292)^[0] xor (pac64(PChar(p)+176)^[0] xor $0c6bd351);
   num := pac32(PChar(p)+502)^[0]; pac32(PChar(p)+502)^[0] := pac32(PChar(p)+351)^[0]; pac32(PChar(p)+351)^[0] := num;
   num := pac32(PChar(p)+97)^[0]; pac32(PChar(p)+97)^[0] := pac32(PChar(p)+105)^[0]; pac32(PChar(p)+105)^[0] := num;
   pac32(PChar(p)+58)^[0] := pac32(PChar(p)+58)^[0] xor (pac32(PChar(p)+400)^[0] - $d495fe);
 end;

 pac64(PChar(p)+374)^[0] := pac64(PChar(p)+374)^[0] - $a4c5a954595e;
 pac32(PChar(p)+192)^[0] := pac32(PChar(p)+192)^[0] or rol1(pac32(PChar(p)+318)^[0] , 6 );
 pac8(PChar(p)+394)^[0] := pac8(PChar(p)+361)^[0] - (pac8(PChar(p)+431)^[0] + $18);

D73DC481(p);

end;

procedure D73DC481(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+345)^[0] := pac64(PChar(p)+345)^[0] or (pac64(PChar(p)+271)^[0] or $c85f4cb1358a);
 pac8(PChar(p)+119)^[0] := pac8(PChar(p)+119)^[0] - (pac8(PChar(p)+81)^[0] or $b8);
 pac32(PChar(p)+317)^[0] := pac32(PChar(p)+317)^[0] + (pac32(PChar(p)+307)^[0] + $005e8d);

 if pac16(PChar(p)+213)^[0] < pac16(PChar(p)+231)^[0] then begin
   pac64(PChar(p)+342)^[0] := pac64(PChar(p)+342)^[0] - $547d5712;
   pac32(PChar(p)+188)^[0] := pac32(PChar(p)+188)^[0] + ror2(pac32(PChar(p)+160)^[0] , 28 );
   pac16(PChar(p)+447)^[0] := pac16(PChar(p)+447)^[0] xor (pac16(PChar(p)+14)^[0] + $04);
 end;

 pac32(PChar(p)+194)^[0] := pac32(PChar(p)+194)^[0] or ror2(pac32(PChar(p)+3)^[0] , 31 );
 pac32(PChar(p)+9)^[0] := pac32(PChar(p)+9)^[0] or rol1(pac32(PChar(p)+77)^[0] , 17 );
 pac64(PChar(p)+149)^[0] := pac64(PChar(p)+18)^[0] - (pac64(PChar(p)+412)^[0] + $f0194ab52c);

 if pac32(PChar(p)+310)^[0] > pac32(PChar(p)+427)^[0] then begin
   num := pac16(PChar(p)+290)^[0]; pac16(PChar(p)+290)^[0] := pac16(PChar(p)+242)^[0]; pac16(PChar(p)+242)^[0] := num;
   pac8(PChar(p)+472)^[0] := pac8(PChar(p)+472)^[0] + (pac8(PChar(p)+270)^[0] + $80);
 end;

 if pac64(PChar(p)+205)^[0] < pac64(PChar(p)+289)^[0] then pac8(PChar(p)+367)^[0] := pac8(PChar(p)+266)^[0] xor $0c;
 pac64(PChar(p)+264)^[0] := pac64(PChar(p)+264)^[0] or $34c89a88;
 pac8(PChar(p)+456)^[0] := pac8(PChar(p)+456)^[0] - ror1(pac8(PChar(p)+508)^[0] , 4 );
 if pac16(PChar(p)+50)^[0] > pac16(PChar(p)+335)^[0] then pac8(PChar(p)+297)^[0] := pac8(PChar(p)+297)^[0] - rol1(pac8(PChar(p)+110)^[0] , 6 ) else pac8(PChar(p)+483)^[0] := pac8(PChar(p)+483)^[0] xor $20;
 pac64(PChar(p)+379)^[0] := pac64(PChar(p)+379)^[0] + (pac64(PChar(p)+464)^[0] xor $6c47ca28);
 pac32(PChar(p)+411)^[0] := pac32(PChar(p)+411)^[0] - ror1(pac32(PChar(p)+112)^[0] , 4 );
 pac64(PChar(p)+184)^[0] := pac64(PChar(p)+326)^[0] xor (pac64(PChar(p)+224)^[0] - $3c506ae9);
 pac16(PChar(p)+340)^[0] := pac16(PChar(p)+392)^[0] xor (pac16(PChar(p)+313)^[0] - $58);
 num := pac8(PChar(p)+358)^[0]; pac8(PChar(p)+358)^[0] := pac8(PChar(p)+77)^[0]; pac8(PChar(p)+77)^[0] := num;
 num := pac32(PChar(p)+352)^[0]; pac32(PChar(p)+352)^[0] := pac32(PChar(p)+488)^[0]; pac32(PChar(p)+488)^[0] := num;

E4339548(p);

end;

procedure E4339548(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+486)^[0] := pac16(PChar(p)+486)^[0] - rol1(pac16(PChar(p)+426)^[0] , 14 );
 pac8(PChar(p)+301)^[0] := ror1(pac8(PChar(p)+501)^[0] , 3 );
 pac8(PChar(p)+362)^[0] := pac8(PChar(p)+362)^[0] - (pac8(PChar(p)+319)^[0] xor $b0);
 if pac16(PChar(p)+176)^[0] < pac16(PChar(p)+419)^[0] then pac8(PChar(p)+468)^[0] := pac8(PChar(p)+468)^[0] xor ror1(pac8(PChar(p)+177)^[0] , 2 ) else pac8(PChar(p)+337)^[0] := pac8(PChar(p)+337)^[0] or $a8;
 pac32(PChar(p)+309)^[0] := pac32(PChar(p)+309)^[0] + rol1(pac32(PChar(p)+236)^[0] , 20 );
 pac64(PChar(p)+12)^[0] := pac64(PChar(p)+12)^[0] or (pac64(PChar(p)+479)^[0] + $80fc0f91);

 if pac64(PChar(p)+3)^[0] < pac64(PChar(p)+34)^[0] then begin
   pac64(PChar(p)+249)^[0] := pac64(PChar(p)+55)^[0] - $64c26b2887f9;
   pac8(PChar(p)+493)^[0] := pac8(PChar(p)+493)^[0] + (pac8(PChar(p)+8)^[0] xor $3c);
   if pac64(PChar(p)+396)^[0] < pac64(PChar(p)+262)^[0] then pac8(PChar(p)+81)^[0] := pac8(PChar(p)+81)^[0] + ror1(pac8(PChar(p)+428)^[0] , 6 ) else pac32(PChar(p)+76)^[0] := pac32(PChar(p)+76)^[0] or (pac32(PChar(p)+274)^[0] or $ac0e97);
 end;

 pac16(PChar(p)+222)^[0] := pac16(PChar(p)+222)^[0] xor ror2(pac16(PChar(p)+11)^[0] , 14 );
 num := pac8(PChar(p)+304)^[0]; pac8(PChar(p)+304)^[0] := pac8(PChar(p)+346)^[0]; pac8(PChar(p)+346)^[0] := num;
 pac32(PChar(p)+305)^[0] := pac32(PChar(p)+305)^[0] xor ror2(pac32(PChar(p)+78)^[0] , 10 );
 pac32(PChar(p)+278)^[0] := pac32(PChar(p)+278)^[0] xor (pac32(PChar(p)+485)^[0] + $bcd8);

CAC344E4(p);

end;

procedure CAC344E4(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+369)^[0] < pac16(PChar(p)+426)^[0] then begin
   pac16(PChar(p)+138)^[0] := pac16(PChar(p)+138)^[0] xor $f4;
   if pac64(PChar(p)+39)^[0] > pac64(PChar(p)+202)^[0] then begin  num := pac32(PChar(p)+331)^[0]; pac32(PChar(p)+331)^[0] := pac32(PChar(p)+296)^[0]; pac32(PChar(p)+296)^[0] := num; end else begin  num := pac8(PChar(p)+426)^[0]; pac8(PChar(p)+426)^[0] := pac8(PChar(p)+340)^[0]; pac8(PChar(p)+340)^[0] := num; end;
   pac16(PChar(p)+411)^[0] := pac16(PChar(p)+169)^[0] or (pac16(PChar(p)+37)^[0] xor $88);
   if pac32(PChar(p)+81)^[0] > pac32(PChar(p)+192)^[0] then pac64(PChar(p)+139)^[0] := pac64(PChar(p)+139)^[0] or (pac64(PChar(p)+306)^[0] or $2c01913b) else pac8(PChar(p)+82)^[0] := pac8(PChar(p)+82)^[0] or $a4;
   pac64(PChar(p)+488)^[0] := pac64(PChar(p)+488)^[0] + $ec2545b4;
 end;

 if pac8(PChar(p)+153)^[0] < pac8(PChar(p)+3)^[0] then begin  num := pac32(PChar(p)+485)^[0]; pac32(PChar(p)+485)^[0] := pac32(PChar(p)+84)^[0]; pac32(PChar(p)+84)^[0] := num; end else pac64(PChar(p)+168)^[0] := pac64(PChar(p)+168)^[0] - $c8d40de79f13;
 pac16(PChar(p)+450)^[0] := pac16(PChar(p)+450)^[0] or $98;
 pac8(PChar(p)+226)^[0] := pac8(PChar(p)+226)^[0] + (pac8(PChar(p)+371)^[0] xor $bc);
 pac32(PChar(p)+423)^[0] := pac32(PChar(p)+423)^[0] or (pac32(PChar(p)+87)^[0] or $d0dc9c);
 pac32(PChar(p)+428)^[0] := ror1(pac32(PChar(p)+365)^[0] , 11 );
 if pac16(PChar(p)+66)^[0] > pac16(PChar(p)+307)^[0] then begin  num := pac32(PChar(p)+147)^[0]; pac32(PChar(p)+147)^[0] := pac32(PChar(p)+475)^[0]; pac32(PChar(p)+475)^[0] := num; end else pac32(PChar(p)+306)^[0] := pac32(PChar(p)+306)^[0] or $f044bd;
 pac64(PChar(p)+36)^[0] := pac64(PChar(p)+36)^[0] + (pac64(PChar(p)+206)^[0] xor $d428038f82);
 pac64(PChar(p)+398)^[0] := pac64(PChar(p)+398)^[0] xor (pac64(PChar(p)+199)^[0] xor $247617cc58);
 if pac16(PChar(p)+334)^[0] > pac16(PChar(p)+162)^[0] then pac16(PChar(p)+120)^[0] := pac16(PChar(p)+120)^[0] or ror2(pac16(PChar(p)+384)^[0] , 3 );
 pac16(PChar(p)+149)^[0] := ror2(pac16(PChar(p)+371)^[0] , 15 );
 if pac16(PChar(p)+107)^[0] < pac16(PChar(p)+450)^[0] then pac32(PChar(p)+358)^[0] := pac32(PChar(p)+421)^[0] + $701a5f else pac64(PChar(p)+257)^[0] := pac64(PChar(p)+257)^[0] - $b85228ed7d58;
 num := pac16(PChar(p)+419)^[0]; pac16(PChar(p)+419)^[0] := pac16(PChar(p)+407)^[0]; pac16(PChar(p)+407)^[0] := num;
 num := pac16(PChar(p)+324)^[0]; pac16(PChar(p)+324)^[0] := pac16(PChar(p)+330)^[0]; pac16(PChar(p)+330)^[0] := num;
 num := pac8(PChar(p)+372)^[0]; pac8(PChar(p)+372)^[0] := pac8(PChar(p)+475)^[0]; pac8(PChar(p)+475)^[0] := num;
 num := pac16(PChar(p)+99)^[0]; pac16(PChar(p)+99)^[0] := pac16(PChar(p)+284)^[0]; pac16(PChar(p)+284)^[0] := num;
 pac16(PChar(p)+269)^[0] := ror2(pac16(PChar(p)+269)^[0] , 6 );
 pac64(PChar(p)+451)^[0] := pac64(PChar(p)+117)^[0] or (pac64(PChar(p)+294)^[0] or $4cf882f1ef09);

B35A7505(p);

end;

procedure B35A7505(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+216)^[0] < pac8(PChar(p)+507)^[0] then begin  num := pac32(PChar(p)+246)^[0]; pac32(PChar(p)+246)^[0] := pac32(PChar(p)+420)^[0]; pac32(PChar(p)+420)^[0] := num; end else pac64(PChar(p)+31)^[0] := pac64(PChar(p)+31)^[0] - (pac64(PChar(p)+215)^[0] + $d823732de1);
 pac16(PChar(p)+13)^[0] := pac16(PChar(p)+13)^[0] - (pac16(PChar(p)+443)^[0] + $d0);
 pac8(PChar(p)+133)^[0] := pac8(PChar(p)+133)^[0] - ror2(pac8(PChar(p)+1)^[0] , 7 );
 if pac32(PChar(p)+251)^[0] < pac32(PChar(p)+409)^[0] then pac64(PChar(p)+198)^[0] := pac64(PChar(p)+198)^[0] - (pac64(PChar(p)+474)^[0] or $78450161) else pac32(PChar(p)+218)^[0] := ror1(pac32(PChar(p)+16)^[0] , 15 );
 if pac8(PChar(p)+207)^[0] < pac8(PChar(p)+334)^[0] then pac32(PChar(p)+275)^[0] := pac32(PChar(p)+275)^[0] xor rol1(pac32(PChar(p)+43)^[0] , 3 ) else pac64(PChar(p)+496)^[0] := pac64(PChar(p)+67)^[0] + $4069fa1c;
 if pac64(PChar(p)+29)^[0] < pac64(PChar(p)+335)^[0] then begin  num := pac32(PChar(p)+174)^[0]; pac32(PChar(p)+174)^[0] := pac32(PChar(p)+99)^[0]; pac32(PChar(p)+99)^[0] := num; end else pac16(PChar(p)+69)^[0] := pac16(PChar(p)+69)^[0] + ror2(pac16(PChar(p)+430)^[0] , 15 );

 if pac32(PChar(p)+203)^[0] > pac32(PChar(p)+190)^[0] then begin
   if pac8(PChar(p)+237)^[0] > pac8(PChar(p)+360)^[0] then begin  num := pac8(PChar(p)+285)^[0]; pac8(PChar(p)+285)^[0] := pac8(PChar(p)+5)^[0]; pac8(PChar(p)+5)^[0] := num; end else pac32(PChar(p)+496)^[0] := pac32(PChar(p)+496)^[0] or $4cac29;
   pac32(PChar(p)+209)^[0] := pac32(PChar(p)+209)^[0] xor ror2(pac32(PChar(p)+14)^[0] , 1 );
   num := pac8(PChar(p)+128)^[0]; pac8(PChar(p)+128)^[0] := pac8(PChar(p)+26)^[0]; pac8(PChar(p)+26)^[0] := num;
 end;

 num := pac8(PChar(p)+415)^[0]; pac8(PChar(p)+415)^[0] := pac8(PChar(p)+61)^[0]; pac8(PChar(p)+61)^[0] := num;
 pac32(PChar(p)+402)^[0] := pac32(PChar(p)+402)^[0] or ror2(pac32(PChar(p)+241)^[0] , 21 );

 if pac64(PChar(p)+202)^[0] < pac64(PChar(p)+434)^[0] then begin
   pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] - rol1(pac32(PChar(p)+228)^[0] , 16 );
   if pac64(PChar(p)+112)^[0] > pac64(PChar(p)+389)^[0] then pac8(PChar(p)+430)^[0] := pac8(PChar(p)+430)^[0] or (pac8(PChar(p)+422)^[0] + $30) else pac16(PChar(p)+384)^[0] := pac16(PChar(p)+384)^[0] or ror1(pac16(PChar(p)+503)^[0] , 1 );
   pac8(PChar(p)+192)^[0] := pac8(PChar(p)+12)^[0] - $d4;
 end;


 if pac16(PChar(p)+27)^[0] < pac16(PChar(p)+202)^[0] then begin
   pac32(PChar(p)+430)^[0] := pac32(PChar(p)+419)^[0] or $cc2c27;
   pac64(PChar(p)+119)^[0] := pac64(PChar(p)+119)^[0] + $20162bd421;
   pac8(PChar(p)+369)^[0] := pac8(PChar(p)+369)^[0] or ror2(pac8(PChar(p)+148)^[0] , 4 );
   pac8(PChar(p)+182)^[0] := ror2(pac8(PChar(p)+222)^[0] , 7 );
 end;

 pac8(PChar(p)+239)^[0] := pac8(PChar(p)+239)^[0] xor ror2(pac8(PChar(p)+250)^[0] , 5 );
 if pac16(PChar(p)+109)^[0] > pac16(PChar(p)+460)^[0] then pac64(PChar(p)+234)^[0] := pac64(PChar(p)+234)^[0] - $38a6fe96;
 num := pac16(PChar(p)+76)^[0]; pac16(PChar(p)+76)^[0] := pac16(PChar(p)+441)^[0]; pac16(PChar(p)+441)^[0] := num;
 pac8(PChar(p)+57)^[0] := pac8(PChar(p)+57)^[0] xor ror2(pac8(PChar(p)+219)^[0] , 2 );

 if pac16(PChar(p)+8)^[0] > pac16(PChar(p)+41)^[0] then begin
   num := pac8(PChar(p)+64)^[0]; pac8(PChar(p)+64)^[0] := pac8(PChar(p)+319)^[0]; pac8(PChar(p)+319)^[0] := num;
   pac8(PChar(p)+33)^[0] := pac8(PChar(p)+33)^[0] or (pac8(PChar(p)+322)^[0] + $0c);
   pac32(PChar(p)+318)^[0] := pac32(PChar(p)+318)^[0] - $acf8;
 end;

 num := pac32(PChar(p)+73)^[0]; pac32(PChar(p)+73)^[0] := pac32(PChar(p)+297)^[0]; pac32(PChar(p)+297)^[0] := num;
 pac64(PChar(p)+403)^[0] := pac64(PChar(p)+199)^[0] or $60ee2489ed;
 pac32(PChar(p)+207)^[0] := pac32(PChar(p)+207)^[0] or rol1(pac32(PChar(p)+51)^[0] , 17 );

C39B1843(p);

end;

procedure C39B1843(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+242)^[0] := pac16(PChar(p)+242)^[0] xor $8c;
 if pac64(PChar(p)+123)^[0] < pac64(PChar(p)+383)^[0] then pac64(PChar(p)+352)^[0] := pac64(PChar(p)+352)^[0] or $48618a05dea5 else pac16(PChar(p)+85)^[0] := pac16(PChar(p)+85)^[0] - (pac16(PChar(p)+166)^[0] - $40);

 if pac16(PChar(p)+118)^[0] > pac16(PChar(p)+96)^[0] then begin
   pac32(PChar(p)+198)^[0] := pac32(PChar(p)+6)^[0] - $7c85;
   num := pac16(PChar(p)+96)^[0]; pac16(PChar(p)+96)^[0] := pac16(PChar(p)+21)^[0]; pac16(PChar(p)+21)^[0] := num;
   num := pac32(PChar(p)+294)^[0]; pac32(PChar(p)+294)^[0] := pac32(PChar(p)+48)^[0]; pac32(PChar(p)+48)^[0] := num;
 end;

 if pac16(PChar(p)+410)^[0] < pac16(PChar(p)+103)^[0] then pac16(PChar(p)+333)^[0] := pac16(PChar(p)+457)^[0] + $9c else begin  num := pac32(PChar(p)+309)^[0]; pac32(PChar(p)+309)^[0] := pac32(PChar(p)+437)^[0]; pac32(PChar(p)+437)^[0] := num; end;
 num := pac16(PChar(p)+322)^[0]; pac16(PChar(p)+322)^[0] := pac16(PChar(p)+479)^[0]; pac16(PChar(p)+479)^[0] := num;
 num := pac16(PChar(p)+341)^[0]; pac16(PChar(p)+341)^[0] := pac16(PChar(p)+286)^[0]; pac16(PChar(p)+286)^[0] := num;
 if pac8(PChar(p)+428)^[0] < pac8(PChar(p)+255)^[0] then pac8(PChar(p)+376)^[0] := ror2(pac8(PChar(p)+170)^[0] , 7 ) else begin  num := pac16(PChar(p)+358)^[0]; pac16(PChar(p)+358)^[0] := pac16(PChar(p)+157)^[0]; pac16(PChar(p)+157)^[0] := num; end;

 if pac16(PChar(p)+234)^[0] > pac16(PChar(p)+307)^[0] then begin
   pac8(PChar(p)+433)^[0] := pac8(PChar(p)+433)^[0] + rol1(pac8(PChar(p)+198)^[0] , 5 );
   pac16(PChar(p)+59)^[0] := pac16(PChar(p)+480)^[0] - $fc;
   if pac16(PChar(p)+363)^[0] < pac16(PChar(p)+49)^[0] then begin  num := pac32(PChar(p)+268)^[0]; pac32(PChar(p)+268)^[0] := pac32(PChar(p)+202)^[0]; pac32(PChar(p)+202)^[0] := num; end;
 end;

 if pac64(PChar(p)+238)^[0] > pac64(PChar(p)+473)^[0] then pac32(PChar(p)+224)^[0] := pac32(PChar(p)+224)^[0] xor ror2(pac32(PChar(p)+73)^[0] , 14 ) else pac64(PChar(p)+231)^[0] := pac64(PChar(p)+231)^[0] - (pac64(PChar(p)+17)^[0] or $7814cc85ec);
 num := pac32(PChar(p)+314)^[0]; pac32(PChar(p)+314)^[0] := pac32(PChar(p)+485)^[0]; pac32(PChar(p)+485)^[0] := num;

 if pac32(PChar(p)+305)^[0] > pac32(PChar(p)+373)^[0] then begin
   num := pac16(PChar(p)+250)^[0]; pac16(PChar(p)+250)^[0] := pac16(PChar(p)+262)^[0]; pac16(PChar(p)+262)^[0] := num;
   pac64(PChar(p)+36)^[0] := pac64(PChar(p)+36)^[0] xor $ccef4cb387;
 end;

 pac16(PChar(p)+209)^[0] := pac16(PChar(p)+209)^[0] or ror1(pac16(PChar(p)+230)^[0] , 13 );

 if pac8(PChar(p)+419)^[0] > pac8(PChar(p)+4)^[0] then begin
   pac64(PChar(p)+90)^[0] := pac64(PChar(p)+114)^[0] or $70c2e96622fc;
   pac32(PChar(p)+32)^[0] := pac32(PChar(p)+32)^[0] - $a87c5d;
 end;

 pac64(PChar(p)+165)^[0] := pac64(PChar(p)+165)^[0] or $88b73b16f9;

F75A99F9(p);

end;

procedure F75A99F9(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+68)^[0]; pac8(PChar(p)+68)^[0] := pac8(PChar(p)+188)^[0]; pac8(PChar(p)+188)^[0] := num;
 pac16(PChar(p)+481)^[0] := ror1(pac16(PChar(p)+155)^[0] , 6 );
 pac8(PChar(p)+295)^[0] := pac8(PChar(p)+295)^[0] + ror2(pac8(PChar(p)+229)^[0] , 7 );
 pac64(PChar(p)+214)^[0] := pac64(PChar(p)+214)^[0] or (pac64(PChar(p)+343)^[0] or $6056be2b38);
 if pac16(PChar(p)+480)^[0] < pac16(PChar(p)+245)^[0] then pac16(PChar(p)+198)^[0] := pac16(PChar(p)+198)^[0] + $58 else pac8(PChar(p)+439)^[0] := pac8(PChar(p)+439)^[0] + rol1(pac8(PChar(p)+272)^[0] , 1 );
 num := pac32(PChar(p)+120)^[0]; pac32(PChar(p)+120)^[0] := pac32(PChar(p)+455)^[0]; pac32(PChar(p)+455)^[0] := num;
 pac16(PChar(p)+40)^[0] := pac16(PChar(p)+40)^[0] xor $d8;
 pac8(PChar(p)+444)^[0] := pac8(PChar(p)+444)^[0] xor rol1(pac8(PChar(p)+114)^[0] , 1 );
 if pac16(PChar(p)+167)^[0] < pac16(PChar(p)+63)^[0] then pac8(PChar(p)+393)^[0] := rol1(pac8(PChar(p)+441)^[0] , 5 ) else pac64(PChar(p)+383)^[0] := pac64(PChar(p)+330)^[0] + $ec0995239e1e;

 if pac32(PChar(p)+483)^[0] > pac32(PChar(p)+175)^[0] then begin
   num := pac32(PChar(p)+232)^[0]; pac32(PChar(p)+232)^[0] := pac32(PChar(p)+331)^[0]; pac32(PChar(p)+331)^[0] := num;
   num := pac8(PChar(p)+363)^[0]; pac8(PChar(p)+363)^[0] := pac8(PChar(p)+48)^[0]; pac8(PChar(p)+48)^[0] := num;
 end;

 if pac32(PChar(p)+147)^[0] > pac32(PChar(p)+320)^[0] then begin  num := pac16(PChar(p)+26)^[0]; pac16(PChar(p)+26)^[0] := pac16(PChar(p)+167)^[0]; pac16(PChar(p)+167)^[0] := num; end else pac16(PChar(p)+375)^[0] := pac16(PChar(p)+375)^[0] + ror2(pac16(PChar(p)+138)^[0] , 1 );
 num := pac32(PChar(p)+330)^[0]; pac32(PChar(p)+330)^[0] := pac32(PChar(p)+363)^[0]; pac32(PChar(p)+363)^[0] := num;
 pac32(PChar(p)+56)^[0] := pac32(PChar(p)+56)^[0] or ror2(pac32(PChar(p)+416)^[0] , 20 );
 pac32(PChar(p)+192)^[0] := pac32(PChar(p)+192)^[0] xor $b8d6;

CFABD31D(p);

end;

procedure CFABD31D(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+50)^[0] := pac16(PChar(p)+50)^[0] + ror2(pac16(PChar(p)+48)^[0] , 1 );
 pac8(PChar(p)+79)^[0] := ror2(pac8(PChar(p)+35)^[0] , 7 );
 if pac8(PChar(p)+22)^[0] < pac8(PChar(p)+327)^[0] then begin  num := pac16(PChar(p)+290)^[0]; pac16(PChar(p)+290)^[0] := pac16(PChar(p)+459)^[0]; pac16(PChar(p)+459)^[0] := num; end else pac32(PChar(p)+188)^[0] := pac32(PChar(p)+188)^[0] or $a80e;
 pac8(PChar(p)+217)^[0] := pac8(PChar(p)+217)^[0] xor (pac8(PChar(p)+326)^[0] - $e8);
 pac64(PChar(p)+326)^[0] := pac64(PChar(p)+326)^[0] - (pac64(PChar(p)+362)^[0] xor $74bea0811a);
 if pac32(PChar(p)+188)^[0] > pac32(PChar(p)+29)^[0] then pac32(PChar(p)+336)^[0] := pac32(PChar(p)+336)^[0] or ror2(pac32(PChar(p)+80)^[0] , 11 ) else pac32(PChar(p)+44)^[0] := pac32(PChar(p)+44)^[0] or ror2(pac32(PChar(p)+451)^[0] , 22 );
 pac64(PChar(p)+350)^[0] := pac64(PChar(p)+350)^[0] + $10035332;

 if pac16(PChar(p)+248)^[0] < pac16(PChar(p)+195)^[0] then begin
   pac8(PChar(p)+296)^[0] := pac8(PChar(p)+296)^[0] xor $38;
   if pac16(PChar(p)+136)^[0] < pac16(PChar(p)+485)^[0] then pac64(PChar(p)+404)^[0] := pac64(PChar(p)+63)^[0] xor $04acff4ee52b else pac8(PChar(p)+138)^[0] := pac8(PChar(p)+138)^[0] + (pac8(PChar(p)+94)^[0] - $1c);
 end;

 num := pac8(PChar(p)+484)^[0]; pac8(PChar(p)+484)^[0] := pac8(PChar(p)+278)^[0]; pac8(PChar(p)+278)^[0] := num;
 pac32(PChar(p)+284)^[0] := pac32(PChar(p)+284)^[0] + $78689f;
 pac8(PChar(p)+400)^[0] := pac8(PChar(p)+148)^[0] xor (pac8(PChar(p)+127)^[0] - $b4);
 pac8(PChar(p)+173)^[0] := pac8(PChar(p)+173)^[0] xor ror1(pac8(PChar(p)+88)^[0] , 3 );
 pac8(PChar(p)+499)^[0] := pac8(PChar(p)+499)^[0] xor ror2(pac8(PChar(p)+162)^[0] , 6 );
 pac64(PChar(p)+233)^[0] := pac64(PChar(p)+168)^[0] + (pac64(PChar(p)+341)^[0] xor $549124f421);
 pac64(PChar(p)+89)^[0] := pac64(PChar(p)+89)^[0] xor (pac64(PChar(p)+335)^[0] or $84d11478);
 if pac64(PChar(p)+376)^[0] > pac64(PChar(p)+485)^[0] then pac64(PChar(p)+156)^[0] := pac64(PChar(p)+156)^[0] xor (pac64(PChar(p)+237)^[0] or $f472a65bea01) else pac16(PChar(p)+349)^[0] := rol1(pac16(PChar(p)+13)^[0] , 6 );
 pac64(PChar(p)+1)^[0] := pac64(PChar(p)+1)^[0] - (pac64(PChar(p)+42)^[0] - $540b85c6ecc3);

 if pac64(PChar(p)+416)^[0] < pac64(PChar(p)+440)^[0] then begin
   if pac64(PChar(p)+135)^[0] < pac64(PChar(p)+9)^[0] then pac16(PChar(p)+275)^[0] := pac16(PChar(p)+275)^[0] - ror2(pac16(PChar(p)+194)^[0] , 2 ) else pac32(PChar(p)+55)^[0] := pac32(PChar(p)+55)^[0] xor $38e6;
   if pac32(PChar(p)+22)^[0] > pac32(PChar(p)+188)^[0] then begin  num := pac16(PChar(p)+508)^[0]; pac16(PChar(p)+508)^[0] := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := num; end else pac64(PChar(p)+246)^[0] := pac64(PChar(p)+192)^[0] or $a0d1d33b1478;
 end;

 pac8(PChar(p)+397)^[0] := pac8(PChar(p)+397)^[0] xor (pac8(PChar(p)+387)^[0] or $cc);

BDD8495E(p);

end;

procedure BDD8495E(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+379)^[0]; pac32(PChar(p)+379)^[0] := pac32(PChar(p)+64)^[0]; pac32(PChar(p)+64)^[0] := num;
 pac64(PChar(p)+498)^[0] := pac64(PChar(p)+60)^[0] - (pac64(PChar(p)+66)^[0] + $1030a1f1);
 pac16(PChar(p)+147)^[0] := pac16(PChar(p)+122)^[0] - (pac16(PChar(p)+153)^[0] + $f8);
 num := pac8(PChar(p)+268)^[0]; pac8(PChar(p)+268)^[0] := pac8(PChar(p)+469)^[0]; pac8(PChar(p)+469)^[0] := num;
 pac32(PChar(p)+214)^[0] := pac32(PChar(p)+214)^[0] + $6857a0;
 pac16(PChar(p)+30)^[0] := pac16(PChar(p)+30)^[0] xor (pac16(PChar(p)+2)^[0] xor $f8);
 pac16(PChar(p)+263)^[0] := pac16(PChar(p)+263)^[0] - ror1(pac16(PChar(p)+229)^[0] , 3 );

 if pac32(PChar(p)+409)^[0] < pac32(PChar(p)+254)^[0] then begin
   if pac32(PChar(p)+443)^[0] < pac32(PChar(p)+451)^[0] then begin  num := pac8(PChar(p)+38)^[0]; pac8(PChar(p)+38)^[0] := pac8(PChar(p)+456)^[0]; pac8(PChar(p)+456)^[0] := num; end else pac16(PChar(p)+383)^[0] := pac16(PChar(p)+383)^[0] - (pac16(PChar(p)+316)^[0] + $f8);
   pac64(PChar(p)+321)^[0] := pac64(PChar(p)+321)^[0] or (pac64(PChar(p)+490)^[0] + $c0e8f1f503bf);
   pac8(PChar(p)+85)^[0] := pac8(PChar(p)+85)^[0] xor ror1(pac8(PChar(p)+93)^[0] , 6 );
   pac8(PChar(p)+380)^[0] := pac8(PChar(p)+380)^[0] - $14;
 end;


 if pac8(PChar(p)+251)^[0] < pac8(PChar(p)+408)^[0] then begin
   pac32(PChar(p)+234)^[0] := pac32(PChar(p)+234)^[0] or (pac32(PChar(p)+198)^[0] or $3408);
   pac64(PChar(p)+344)^[0] := pac64(PChar(p)+344)^[0] - $20bbef958a;
 end;

 pac16(PChar(p)+447)^[0] := ror2(pac16(PChar(p)+456)^[0] , 6 );
 pac8(PChar(p)+105)^[0] := pac8(PChar(p)+293)^[0] xor $14;

 if pac8(PChar(p)+413)^[0] < pac8(PChar(p)+505)^[0] then begin
   if pac8(PChar(p)+254)^[0] < pac8(PChar(p)+102)^[0] then pac64(PChar(p)+216)^[0] := pac64(PChar(p)+216)^[0] or $a0f0b2240c71;
   if pac32(PChar(p)+317)^[0] > pac32(PChar(p)+349)^[0] then pac64(PChar(p)+112)^[0] := pac64(PChar(p)+112)^[0] or $ece69e23a5db else pac32(PChar(p)+54)^[0] := pac32(PChar(p)+54)^[0] - (pac32(PChar(p)+116)^[0] + $0496c9);
   pac16(PChar(p)+421)^[0] := pac16(PChar(p)+111)^[0] or (pac16(PChar(p)+110)^[0] + $f0);
 end;

 if pac32(PChar(p)+353)^[0] < pac32(PChar(p)+486)^[0] then begin  num := pac32(PChar(p)+414)^[0]; pac32(PChar(p)+414)^[0] := pac32(PChar(p)+479)^[0]; pac32(PChar(p)+479)^[0] := num; end else pac64(PChar(p)+56)^[0] := pac64(PChar(p)+56)^[0] + $5cb0d0a5;
 pac8(PChar(p)+510)^[0] := pac8(PChar(p)+112)^[0] xor $34;
 pac8(PChar(p)+498)^[0] := pac8(PChar(p)+498)^[0] - (pac8(PChar(p)+91)^[0] xor $88);
 pac32(PChar(p)+185)^[0] := pac32(PChar(p)+31)^[0] xor $3067e7;

CCE17DA5(p);

end;

procedure CCE17DA5(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+378)^[0] := pac32(PChar(p)+378)^[0] or (pac32(PChar(p)+184)^[0] - $3cf1d5);
 if pac16(PChar(p)+39)^[0] < pac16(PChar(p)+107)^[0] then pac32(PChar(p)+234)^[0] := pac32(PChar(p)+234)^[0] - $f877bb;
 pac32(PChar(p)+205)^[0] := pac32(PChar(p)+205)^[0] xor ror2(pac32(PChar(p)+169)^[0] , 19 );
 pac16(PChar(p)+456)^[0] := pac16(PChar(p)+456)^[0] - (pac16(PChar(p)+165)^[0] xor $94);
 if pac8(PChar(p)+204)^[0] < pac8(PChar(p)+202)^[0] then pac32(PChar(p)+76)^[0] := pac32(PChar(p)+76)^[0] + ror2(pac32(PChar(p)+270)^[0] , 24 );

 if pac8(PChar(p)+440)^[0] > pac8(PChar(p)+315)^[0] then begin
   pac64(PChar(p)+170)^[0] := pac64(PChar(p)+170)^[0] or (pac64(PChar(p)+244)^[0] - $ecc8e6684c);
   pac16(PChar(p)+114)^[0] := pac16(PChar(p)+114)^[0] or $54;
   pac16(PChar(p)+407)^[0] := pac16(PChar(p)+407)^[0] or ror2(pac16(PChar(p)+187)^[0] , 7 );
   num := pac8(PChar(p)+382)^[0]; pac8(PChar(p)+382)^[0] := pac8(PChar(p)+90)^[0]; pac8(PChar(p)+90)^[0] := num;
 end;


 if pac64(PChar(p)+264)^[0] < pac64(PChar(p)+299)^[0] then begin
   pac8(PChar(p)+295)^[0] := pac8(PChar(p)+331)^[0] xor $c0;
   if pac64(PChar(p)+293)^[0] < pac64(PChar(p)+132)^[0] then pac16(PChar(p)+495)^[0] := pac16(PChar(p)+495)^[0] + $68 else begin  num := pac8(PChar(p)+337)^[0]; pac8(PChar(p)+337)^[0] := pac8(PChar(p)+114)^[0]; pac8(PChar(p)+114)^[0] := num; end;
 end;

 pac32(PChar(p)+422)^[0] := pac32(PChar(p)+422)^[0] + $c445;
 num := pac8(PChar(p)+339)^[0]; pac8(PChar(p)+339)^[0] := pac8(PChar(p)+320)^[0]; pac8(PChar(p)+320)^[0] := num;
 num := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := pac16(PChar(p)+223)^[0]; pac16(PChar(p)+223)^[0] := num;

 if pac32(PChar(p)+97)^[0] < pac32(PChar(p)+435)^[0] then begin
   pac64(PChar(p)+105)^[0] := pac64(PChar(p)+187)^[0] - $4cc04880d8;
   num := pac8(PChar(p)+6)^[0]; pac8(PChar(p)+6)^[0] := pac8(PChar(p)+43)^[0]; pac8(PChar(p)+43)^[0] := num;
   pac16(PChar(p)+131)^[0] := pac16(PChar(p)+131)^[0] or rol1(pac16(PChar(p)+87)^[0] , 2 );
 end;

 pac16(PChar(p)+403)^[0] := ror2(pac16(PChar(p)+29)^[0] , 2 );
 num := pac16(PChar(p)+94)^[0]; pac16(PChar(p)+94)^[0] := pac16(PChar(p)+131)^[0]; pac16(PChar(p)+131)^[0] := num;
 pac64(PChar(p)+141)^[0] := pac64(PChar(p)+141)^[0] - $d4be8b1b;
 pac32(PChar(p)+467)^[0] := pac32(PChar(p)+467)^[0] xor (pac32(PChar(p)+89)^[0] xor $a457cc);
 if pac16(PChar(p)+49)^[0] > pac16(PChar(p)+4)^[0] then pac64(PChar(p)+195)^[0] := pac64(PChar(p)+195)^[0] xor $d82044ce21;
 num := pac16(PChar(p)+51)^[0]; pac16(PChar(p)+51)^[0] := pac16(PChar(p)+342)^[0]; pac16(PChar(p)+342)^[0] := num;

FA522139(p);

end;

procedure FA522139(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+164)^[0] := pac64(PChar(p)+381)^[0] - $f42801c8;

 if pac16(PChar(p)+169)^[0] < pac16(PChar(p)+38)^[0] then begin
   pac16(PChar(p)+328)^[0] := pac16(PChar(p)+328)^[0] or ror2(pac16(PChar(p)+194)^[0] , 6 );
   num := pac16(PChar(p)+167)^[0]; pac16(PChar(p)+167)^[0] := pac16(PChar(p)+142)^[0]; pac16(PChar(p)+142)^[0] := num;
 end;

 pac64(PChar(p)+383)^[0] := pac64(PChar(p)+383)^[0] + $00279a91;
 num := pac32(PChar(p)+467)^[0]; pac32(PChar(p)+467)^[0] := pac32(PChar(p)+399)^[0]; pac32(PChar(p)+399)^[0] := num;
 pac64(PChar(p)+450)^[0] := pac64(PChar(p)+450)^[0] + $50c9ef4504;
 if pac64(PChar(p)+90)^[0] < pac64(PChar(p)+271)^[0] then pac32(PChar(p)+97)^[0] := pac32(PChar(p)+97)^[0] + $3c9065 else begin  num := pac8(PChar(p)+170)^[0]; pac8(PChar(p)+170)^[0] := pac8(PChar(p)+125)^[0]; pac8(PChar(p)+125)^[0] := num; end;
 pac32(PChar(p)+410)^[0] := pac32(PChar(p)+410)^[0] xor (pac32(PChar(p)+372)^[0] xor $4c56bf);
 pac64(PChar(p)+139)^[0] := pac64(PChar(p)+139)^[0] or (pac64(PChar(p)+134)^[0] or $004b3cbf38);
 pac32(PChar(p)+293)^[0] := pac32(PChar(p)+293)^[0] or (pac32(PChar(p)+221)^[0] + $aca691);
 num := pac16(PChar(p)+294)^[0]; pac16(PChar(p)+294)^[0] := pac16(PChar(p)+76)^[0]; pac16(PChar(p)+76)^[0] := num;
 pac32(PChar(p)+148)^[0] := pac32(PChar(p)+148)^[0] - $38e240;
 pac64(PChar(p)+293)^[0] := pac64(PChar(p)+293)^[0] + (pac64(PChar(p)+204)^[0] + $c4ab33cf48);
 pac8(PChar(p)+238)^[0] := pac8(PChar(p)+238)^[0] or $5c;
 pac32(PChar(p)+436)^[0] := pac32(PChar(p)+436)^[0] - (pac32(PChar(p)+103)^[0] xor $646e04);

 if pac8(PChar(p)+308)^[0] < pac8(PChar(p)+499)^[0] then begin
   if pac64(PChar(p)+9)^[0] > pac64(PChar(p)+253)^[0] then pac64(PChar(p)+499)^[0] := pac64(PChar(p)+499)^[0] + $14f60018 else pac8(PChar(p)+186)^[0] := ror2(pac8(PChar(p)+136)^[0] , 6 );
   num := pac8(PChar(p)+39)^[0]; pac8(PChar(p)+39)^[0] := pac8(PChar(p)+335)^[0]; pac8(PChar(p)+335)^[0] := num;
 end;

 pac64(PChar(p)+450)^[0] := pac64(PChar(p)+450)^[0] xor (pac64(PChar(p)+260)^[0] + $04529ac9b35c);
 if pac64(PChar(p)+146)^[0] < pac64(PChar(p)+500)^[0] then pac32(PChar(p)+435)^[0] := pac32(PChar(p)+435)^[0] - (pac32(PChar(p)+487)^[0] + $18a6f5) else begin  num := pac8(PChar(p)+189)^[0]; pac8(PChar(p)+189)^[0] := pac8(PChar(p)+289)^[0]; pac8(PChar(p)+289)^[0] := num; end;

CB877322(p);

end;

procedure CB877322(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+487)^[0]; pac32(PChar(p)+487)^[0] := pac32(PChar(p)+26)^[0]; pac32(PChar(p)+26)^[0] := num;
 pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] xor (pac32(PChar(p)+112)^[0] + $a87658);

 if pac32(PChar(p)+148)^[0] < pac32(PChar(p)+480)^[0] then begin
   pac32(PChar(p)+327)^[0] := pac32(PChar(p)+327)^[0] or ror2(pac32(PChar(p)+161)^[0] , 15 );
   if pac32(PChar(p)+212)^[0] > pac32(PChar(p)+311)^[0] then pac32(PChar(p)+463)^[0] := pac32(PChar(p)+463)^[0] + ror2(pac32(PChar(p)+360)^[0] , 15 ) else pac16(PChar(p)+467)^[0] := ror1(pac16(PChar(p)+309)^[0] , 8 );
 end;

 if pac64(PChar(p)+390)^[0] < pac64(PChar(p)+61)^[0] then pac32(PChar(p)+78)^[0] := pac32(PChar(p)+59)^[0] or (pac32(PChar(p)+183)^[0] - $5cbee9);
 pac64(PChar(p)+433)^[0] := pac64(PChar(p)+433)^[0] + (pac64(PChar(p)+81)^[0] + $8cc22f789775);
 pac64(PChar(p)+290)^[0] := pac64(PChar(p)+290)^[0] + $c838cce4caea;
 pac8(PChar(p)+22)^[0] := pac8(PChar(p)+22)^[0] xor (pac8(PChar(p)+349)^[0] - $8c);
 if pac64(PChar(p)+335)^[0] > pac64(PChar(p)+406)^[0] then pac32(PChar(p)+261)^[0] := pac32(PChar(p)+261)^[0] + $c02f22 else pac16(PChar(p)+218)^[0] := rol1(pac16(PChar(p)+249)^[0] , 1 );
 pac16(PChar(p)+140)^[0] := pac16(PChar(p)+140)^[0] xor ror2(pac16(PChar(p)+24)^[0] , 11 );
 pac32(PChar(p)+12)^[0] := pac32(PChar(p)+12)^[0] - $1cb507;
 num := pac16(PChar(p)+85)^[0]; pac16(PChar(p)+85)^[0] := pac16(PChar(p)+424)^[0]; pac16(PChar(p)+424)^[0] := num;
 if pac32(PChar(p)+121)^[0] > pac32(PChar(p)+497)^[0] then pac64(PChar(p)+237)^[0] := pac64(PChar(p)+237)^[0] xor (pac64(PChar(p)+222)^[0] - $141ad379aa);
 pac8(PChar(p)+340)^[0] := pac8(PChar(p)+340)^[0] - rol1(pac8(PChar(p)+95)^[0] , 4 );
 pac32(PChar(p)+293)^[0] := pac32(PChar(p)+293)^[0] or (pac32(PChar(p)+444)^[0] or $d8fb);
 pac8(PChar(p)+130)^[0] := rol1(pac8(PChar(p)+23)^[0] , 3 );
 num := pac16(PChar(p)+274)^[0]; pac16(PChar(p)+274)^[0] := pac16(PChar(p)+249)^[0]; pac16(PChar(p)+249)^[0] := num;
 num := pac32(PChar(p)+98)^[0]; pac32(PChar(p)+98)^[0] := pac32(PChar(p)+483)^[0]; pac32(PChar(p)+483)^[0] := num;

B3E1922F(p);

end;

procedure B3E1922F(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+346)^[0] < pac32(PChar(p)+66)^[0] then begin
   pac8(PChar(p)+359)^[0] := pac8(PChar(p)+322)^[0] + (pac8(PChar(p)+482)^[0] or $c4);
   num := pac32(PChar(p)+483)^[0]; pac32(PChar(p)+483)^[0] := pac32(PChar(p)+365)^[0]; pac32(PChar(p)+365)^[0] := num;
   if pac32(PChar(p)+107)^[0] < pac32(PChar(p)+379)^[0] then begin  num := pac8(PChar(p)+36)^[0]; pac8(PChar(p)+36)^[0] := pac8(PChar(p)+507)^[0]; pac8(PChar(p)+507)^[0] := num; end else begin  num := pac16(PChar(p)+428)^[0]; pac16(PChar(p)+428)^[0] := pac16(PChar(p)+414)^[0]; pac16(PChar(p)+414)^[0] := num; end;
 end;

 num := pac16(PChar(p)+29)^[0]; pac16(PChar(p)+29)^[0] := pac16(PChar(p)+170)^[0]; pac16(PChar(p)+170)^[0] := num;
 if pac32(PChar(p)+369)^[0] < pac32(PChar(p)+69)^[0] then pac64(PChar(p)+350)^[0] := pac64(PChar(p)+350)^[0] xor $00a10f363184 else pac64(PChar(p)+207)^[0] := pac64(PChar(p)+77)^[0] - (pac64(PChar(p)+360)^[0] xor $d0f703c1cf18);

 if pac16(PChar(p)+140)^[0] < pac16(PChar(p)+64)^[0] then begin
   if pac32(PChar(p)+81)^[0] < pac32(PChar(p)+339)^[0] then pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] + $243c else pac8(PChar(p)+253)^[0] := pac8(PChar(p)+253)^[0] + (pac8(PChar(p)+395)^[0] xor $38);
   num := pac8(PChar(p)+282)^[0]; pac8(PChar(p)+282)^[0] := pac8(PChar(p)+350)^[0]; pac8(PChar(p)+350)^[0] := num;
   if pac8(PChar(p)+264)^[0] < pac8(PChar(p)+439)^[0] then begin  num := pac32(PChar(p)+507)^[0]; pac32(PChar(p)+507)^[0] := pac32(PChar(p)+230)^[0]; pac32(PChar(p)+230)^[0] := num; end else pac64(PChar(p)+349)^[0] := pac64(PChar(p)+221)^[0] - $38cce1275052;
   pac32(PChar(p)+459)^[0] := pac32(PChar(p)+459)^[0] - (pac32(PChar(p)+190)^[0] + $34fa);
   pac8(PChar(p)+489)^[0] := pac8(PChar(p)+489)^[0] + $98;
 end;

 pac8(PChar(p)+384)^[0] := pac8(PChar(p)+384)^[0] + $80;
 pac8(PChar(p)+491)^[0] := pac8(PChar(p)+491)^[0] or ror2(pac8(PChar(p)+159)^[0] , 1 );
 num := pac16(PChar(p)+83)^[0]; pac16(PChar(p)+83)^[0] := pac16(PChar(p)+11)^[0]; pac16(PChar(p)+11)^[0] := num;
 pac8(PChar(p)+63)^[0] := pac8(PChar(p)+63)^[0] or ror2(pac8(PChar(p)+226)^[0] , 4 );
 pac8(PChar(p)+92)^[0] := pac8(PChar(p)+92)^[0] - ror2(pac8(PChar(p)+214)^[0] , 3 );
 if pac8(PChar(p)+300)^[0] > pac8(PChar(p)+245)^[0] then pac8(PChar(p)+29)^[0] := pac8(PChar(p)+29)^[0] + (pac8(PChar(p)+157)^[0] xor $c4) else pac32(PChar(p)+472)^[0] := ror2(pac32(PChar(p)+313)^[0] , 17 );
 pac32(PChar(p)+301)^[0] := pac32(PChar(p)+301)^[0] + (pac32(PChar(p)+378)^[0] - $acf5);
 pac32(PChar(p)+343)^[0] := pac32(PChar(p)+343)^[0] or ror2(pac32(PChar(p)+414)^[0] , 22 );

 if pac8(PChar(p)+30)^[0] < pac8(PChar(p)+471)^[0] then begin
   pac32(PChar(p)+488)^[0] := pac32(PChar(p)+488)^[0] - (pac32(PChar(p)+415)^[0] + $b4e8c7);
   if pac64(PChar(p)+74)^[0] < pac64(PChar(p)+27)^[0] then pac16(PChar(p)+345)^[0] := pac16(PChar(p)+345)^[0] or $14 else begin  num := pac8(PChar(p)+119)^[0]; pac8(PChar(p)+119)^[0] := pac8(PChar(p)+252)^[0]; pac8(PChar(p)+252)^[0] := num; end;
 end;

 pac32(PChar(p)+365)^[0] := pac32(PChar(p)+365)^[0] + (pac32(PChar(p)+169)^[0] + $8825);

EE6AB52A(p);

end;

procedure EE6AB52A(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+149)^[0] > pac8(PChar(p)+134)^[0] then begin
   num := pac32(PChar(p)+168)^[0]; pac32(PChar(p)+168)^[0] := pac32(PChar(p)+44)^[0]; pac32(PChar(p)+44)^[0] := num;
   num := pac32(PChar(p)+437)^[0]; pac32(PChar(p)+437)^[0] := pac32(PChar(p)+150)^[0]; pac32(PChar(p)+150)^[0] := num;
 end;

 num := pac32(PChar(p)+428)^[0]; pac32(PChar(p)+428)^[0] := pac32(PChar(p)+249)^[0]; pac32(PChar(p)+249)^[0] := num;
 pac32(PChar(p)+250)^[0] := pac32(PChar(p)+383)^[0] or (pac32(PChar(p)+247)^[0] or $84ca11);

 if pac8(PChar(p)+56)^[0] > pac8(PChar(p)+262)^[0] then begin
   if pac8(PChar(p)+310)^[0] < pac8(PChar(p)+202)^[0] then pac32(PChar(p)+232)^[0] := pac32(PChar(p)+232)^[0] xor (pac32(PChar(p)+471)^[0] or $98ca) else begin  num := pac32(PChar(p)+70)^[0]; pac32(PChar(p)+70)^[0] := pac32(PChar(p)+284)^[0]; pac32(PChar(p)+284)^[0] := num; end;
   pac16(PChar(p)+499)^[0] := pac16(PChar(p)+499)^[0] + ror2(pac16(PChar(p)+128)^[0] , 9 );
   pac64(PChar(p)+409)^[0] := pac64(PChar(p)+409)^[0] - (pac64(PChar(p)+410)^[0] + $94756d6f7f77);
 end;

 num := pac8(PChar(p)+210)^[0]; pac8(PChar(p)+210)^[0] := pac8(PChar(p)+490)^[0]; pac8(PChar(p)+490)^[0] := num;
 pac64(PChar(p)+214)^[0] := pac64(PChar(p)+302)^[0] or (pac64(PChar(p)+170)^[0] or $b8f6ff77e154);
 pac16(PChar(p)+496)^[0] := pac16(PChar(p)+496)^[0] or $dc;
 if pac8(PChar(p)+497)^[0] < pac8(PChar(p)+439)^[0] then pac64(PChar(p)+98)^[0] := pac64(PChar(p)+98)^[0] or (pac64(PChar(p)+20)^[0] + $d8ccee76005d) else pac64(PChar(p)+459)^[0] := pac64(PChar(p)+405)^[0] xor (pac64(PChar(p)+14)^[0] - $34cb7a309b78);
 pac32(PChar(p)+197)^[0] := pac32(PChar(p)+197)^[0] - ror1(pac32(PChar(p)+444)^[0] , 18 );
 pac32(PChar(p)+11)^[0] := pac32(PChar(p)+11)^[0] - ror2(pac32(PChar(p)+9)^[0] , 3 );
 pac64(PChar(p)+82)^[0] := pac64(PChar(p)+305)^[0] + (pac64(PChar(p)+228)^[0] - $d44dbfa865);

D4621862(p);

end;

procedure D4621862(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+104)^[0] < pac32(PChar(p)+379)^[0] then begin
   pac32(PChar(p)+167)^[0] := pac32(PChar(p)+167)^[0] + $58f4c9;
   pac64(PChar(p)+403)^[0] := pac64(PChar(p)+403)^[0] xor (pac64(PChar(p)+295)^[0] - $5c7922b8ed90);
 end;

 pac16(PChar(p)+257)^[0] := pac16(PChar(p)+257)^[0] - $0c;
 pac16(PChar(p)+244)^[0] := pac16(PChar(p)+244)^[0] xor (pac16(PChar(p)+6)^[0] - $26);
 num := pac32(PChar(p)+67)^[0]; pac32(PChar(p)+67)^[0] := pac32(PChar(p)+361)^[0]; pac32(PChar(p)+361)^[0] := num;
 if pac8(PChar(p)+36)^[0] < pac8(PChar(p)+227)^[0] then pac64(PChar(p)+387)^[0] := pac64(PChar(p)+96)^[0] or (pac64(PChar(p)+503)^[0] xor $2c7bdd5e);
 pac64(PChar(p)+454)^[0] := pac64(PChar(p)+454)^[0] or $1c45a5763f;

 if pac64(PChar(p)+222)^[0] > pac64(PChar(p)+205)^[0] then begin
   if pac64(PChar(p)+165)^[0] < pac64(PChar(p)+462)^[0] then pac8(PChar(p)+228)^[0] := pac8(PChar(p)+228)^[0] - $20 else begin  num := pac32(PChar(p)+37)^[0]; pac32(PChar(p)+37)^[0] := pac32(PChar(p)+461)^[0]; pac32(PChar(p)+461)^[0] := num; end;
   pac32(PChar(p)+124)^[0] := pac32(PChar(p)+124)^[0] + ror1(pac32(PChar(p)+294)^[0] , 21 );
   num := pac32(PChar(p)+421)^[0]; pac32(PChar(p)+421)^[0] := pac32(PChar(p)+463)^[0]; pac32(PChar(p)+463)^[0] := num;
   pac16(PChar(p)+150)^[0] := pac16(PChar(p)+150)^[0] + $6c;
 end;

 pac64(PChar(p)+130)^[0] := pac64(PChar(p)+130)^[0] xor (pac64(PChar(p)+331)^[0] + $445c40b2b2b7);

 if pac8(PChar(p)+287)^[0] > pac8(PChar(p)+82)^[0] then begin
   if pac8(PChar(p)+82)^[0] > pac8(PChar(p)+444)^[0] then pac16(PChar(p)+405)^[0] := ror2(pac16(PChar(p)+27)^[0] , 12 ) else pac16(PChar(p)+407)^[0] := pac16(PChar(p)+407)^[0] - ror2(pac16(PChar(p)+485)^[0] , 13 );
   if pac32(PChar(p)+174)^[0] < pac32(PChar(p)+412)^[0] then pac64(PChar(p)+297)^[0] := pac64(PChar(p)+297)^[0] + $d44a458885 else begin  num := pac32(PChar(p)+318)^[0]; pac32(PChar(p)+318)^[0] := pac32(PChar(p)+87)^[0]; pac32(PChar(p)+87)^[0] := num; end;
   num := pac32(PChar(p)+160)^[0]; pac32(PChar(p)+160)^[0] := pac32(PChar(p)+206)^[0]; pac32(PChar(p)+206)^[0] := num;
 end;

 pac16(PChar(p)+174)^[0] := ror2(pac16(PChar(p)+269)^[0] , 14 );
 pac32(PChar(p)+342)^[0] := pac32(PChar(p)+226)^[0] - (pac32(PChar(p)+116)^[0] xor $fc5a);
 pac8(PChar(p)+371)^[0] := pac8(PChar(p)+371)^[0] or (pac8(PChar(p)+484)^[0] or $1c);
 pac64(PChar(p)+269)^[0] := pac64(PChar(p)+269)^[0] + (pac64(PChar(p)+105)^[0] + $c4e35c41);
 num := pac8(PChar(p)+439)^[0]; pac8(PChar(p)+439)^[0] := pac8(PChar(p)+348)^[0]; pac8(PChar(p)+348)^[0] := num;
 pac16(PChar(p)+293)^[0] := ror2(pac16(PChar(p)+167)^[0] , 5 );

 if pac32(PChar(p)+377)^[0] > pac32(PChar(p)+102)^[0] then begin
   pac32(PChar(p)+28)^[0] := pac32(PChar(p)+28)^[0] or (pac32(PChar(p)+233)^[0] xor $6ca8);
   if pac32(PChar(p)+434)^[0] > pac32(PChar(p)+106)^[0] then pac16(PChar(p)+164)^[0] := pac16(PChar(p)+164)^[0] or ror2(pac16(PChar(p)+268)^[0] , 8 ) else pac64(PChar(p)+128)^[0] := pac64(PChar(p)+429)^[0] or (pac64(PChar(p)+84)^[0] - $5cc7eb5c2406);
 end;

 num := pac32(PChar(p)+49)^[0]; pac32(PChar(p)+49)^[0] := pac32(PChar(p)+466)^[0]; pac32(PChar(p)+466)^[0] := num;
 num := pac8(PChar(p)+400)^[0]; pac8(PChar(p)+400)^[0] := pac8(PChar(p)+347)^[0]; pac8(PChar(p)+347)^[0] := num;

B4106018(p);

end;

procedure B4106018(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+74)^[0]; pac16(PChar(p)+74)^[0] := pac16(PChar(p)+59)^[0]; pac16(PChar(p)+59)^[0] := num;
 num := pac32(PChar(p)+470)^[0]; pac32(PChar(p)+470)^[0] := pac32(PChar(p)+108)^[0]; pac32(PChar(p)+108)^[0] := num;

 if pac32(PChar(p)+424)^[0] < pac32(PChar(p)+440)^[0] then begin
   num := pac32(PChar(p)+267)^[0]; pac32(PChar(p)+267)^[0] := pac32(PChar(p)+465)^[0]; pac32(PChar(p)+465)^[0] := num;
   if pac8(PChar(p)+373)^[0] > pac8(PChar(p)+142)^[0] then begin  num := pac32(PChar(p)+388)^[0]; pac32(PChar(p)+388)^[0] := pac32(PChar(p)+147)^[0]; pac32(PChar(p)+147)^[0] := num; end else pac8(PChar(p)+196)^[0] := pac8(PChar(p)+196)^[0] + (pac8(PChar(p)+105)^[0] - $24);
   pac16(PChar(p)+223)^[0] := pac16(PChar(p)+223)^[0] or $b8;
   pac32(PChar(p)+420)^[0] := pac32(PChar(p)+420)^[0] or rol1(pac32(PChar(p)+296)^[0] , 15 );
 end;

 pac16(PChar(p)+484)^[0] := pac16(PChar(p)+484)^[0] or $c0;
 num := pac16(PChar(p)+124)^[0]; pac16(PChar(p)+124)^[0] := pac16(PChar(p)+297)^[0]; pac16(PChar(p)+297)^[0] := num;

 if pac32(PChar(p)+441)^[0] < pac32(PChar(p)+141)^[0] then begin
   pac16(PChar(p)+134)^[0] := pac16(PChar(p)+134)^[0] xor ror2(pac16(PChar(p)+1)^[0] , 15 );
   if pac32(PChar(p)+222)^[0] > pac32(PChar(p)+138)^[0] then pac32(PChar(p)+497)^[0] := pac32(PChar(p)+406)^[0] - $e43a33 else pac64(PChar(p)+186)^[0] := pac64(PChar(p)+186)^[0] or $3c584cadf9;
   num := pac16(PChar(p)+321)^[0]; pac16(PChar(p)+321)^[0] := pac16(PChar(p)+127)^[0]; pac16(PChar(p)+127)^[0] := num;
   if pac64(PChar(p)+197)^[0] > pac64(PChar(p)+49)^[0] then begin  num := pac8(PChar(p)+393)^[0]; pac8(PChar(p)+393)^[0] := pac8(PChar(p)+445)^[0]; pac8(PChar(p)+445)^[0] := num; end else pac8(PChar(p)+360)^[0] := pac8(PChar(p)+360)^[0] + ror2(pac8(PChar(p)+164)^[0] , 4 );
 end;

 pac16(PChar(p)+148)^[0] := pac16(PChar(p)+148)^[0] - ror1(pac16(PChar(p)+145)^[0] , 4 );
 num := pac8(PChar(p)+24)^[0]; pac8(PChar(p)+24)^[0] := pac8(PChar(p)+399)^[0]; pac8(PChar(p)+399)^[0] := num;
 pac16(PChar(p)+204)^[0] := pac16(PChar(p)+204)^[0] + rol1(pac16(PChar(p)+172)^[0] , 14 );
 pac8(PChar(p)+423)^[0] := ror2(pac8(PChar(p)+34)^[0] , 2 );
 pac32(PChar(p)+20)^[0] := pac32(PChar(p)+20)^[0] xor ror1(pac32(PChar(p)+193)^[0] , 14 );

 if pac32(PChar(p)+185)^[0] > pac32(PChar(p)+358)^[0] then begin
   pac64(PChar(p)+54)^[0] := pac64(PChar(p)+54)^[0] - (pac64(PChar(p)+448)^[0] + $0c2f0e27);
   num := pac16(PChar(p)+330)^[0]; pac16(PChar(p)+330)^[0] := pac16(PChar(p)+160)^[0]; pac16(PChar(p)+160)^[0] := num;
 end;

 pac32(PChar(p)+413)^[0] := pac32(PChar(p)+4)^[0] - (pac32(PChar(p)+350)^[0] or $680c);
 pac8(PChar(p)+218)^[0] := ror2(pac8(PChar(p)+316)^[0] , 2 );
 pac64(PChar(p)+470)^[0] := pac64(PChar(p)+470)^[0] + (pac64(PChar(p)+155)^[0] xor $3cf4cf42e6);

F67FDA06(p);

end;

procedure F67FDA06(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+189)^[0] < pac32(PChar(p)+171)^[0] then pac32(PChar(p)+223)^[0] := ror2(pac32(PChar(p)+142)^[0] , 26 ) else pac64(PChar(p)+299)^[0] := pac64(PChar(p)+299)^[0] - (pac64(PChar(p)+410)^[0] xor $10886f2467);

 if pac64(PChar(p)+393)^[0] > pac64(PChar(p)+327)^[0] then begin
   pac64(PChar(p)+490)^[0] := pac64(PChar(p)+490)^[0] + $e840285d;
   pac8(PChar(p)+287)^[0] := pac8(PChar(p)+287)^[0] or ror1(pac8(PChar(p)+13)^[0] , 5 );
   if pac8(PChar(p)+317)^[0] < pac8(PChar(p)+452)^[0] then begin  num := pac16(PChar(p)+46)^[0]; pac16(PChar(p)+46)^[0] := pac16(PChar(p)+35)^[0]; pac16(PChar(p)+35)^[0] := num; end else begin  num := pac8(PChar(p)+298)^[0]; pac8(PChar(p)+298)^[0] := pac8(PChar(p)+209)^[0]; pac8(PChar(p)+209)^[0] := num; end;
   num := pac32(PChar(p)+28)^[0]; pac32(PChar(p)+28)^[0] := pac32(PChar(p)+270)^[0]; pac32(PChar(p)+270)^[0] := num;
 end;

 num := pac16(PChar(p)+280)^[0]; pac16(PChar(p)+280)^[0] := pac16(PChar(p)+311)^[0]; pac16(PChar(p)+311)^[0] := num;
 num := pac8(PChar(p)+209)^[0]; pac8(PChar(p)+209)^[0] := pac8(PChar(p)+119)^[0]; pac8(PChar(p)+119)^[0] := num;
 pac32(PChar(p)+293)^[0] := pac32(PChar(p)+293)^[0] or rol1(pac32(PChar(p)+312)^[0] , 24 );

 if pac8(PChar(p)+459)^[0] < pac8(PChar(p)+281)^[0] then begin
   pac16(PChar(p)+387)^[0] := pac16(PChar(p)+387)^[0] - (pac16(PChar(p)+476)^[0] + $60);
   num := pac16(PChar(p)+204)^[0]; pac16(PChar(p)+204)^[0] := pac16(PChar(p)+77)^[0]; pac16(PChar(p)+77)^[0] := num;
 end;


 if pac16(PChar(p)+363)^[0] < pac16(PChar(p)+398)^[0] then begin
   pac8(PChar(p)+32)^[0] := rol1(pac8(PChar(p)+110)^[0] , 7 );
   pac32(PChar(p)+141)^[0] := pac32(PChar(p)+141)^[0] xor ror2(pac32(PChar(p)+269)^[0] , 7 );
   num := pac16(PChar(p)+86)^[0]; pac16(PChar(p)+86)^[0] := pac16(PChar(p)+247)^[0]; pac16(PChar(p)+247)^[0] := num;
 end;


 if pac32(PChar(p)+126)^[0] > pac32(PChar(p)+326)^[0] then begin
   pac64(PChar(p)+373)^[0] := pac64(PChar(p)+373)^[0] or (pac64(PChar(p)+267)^[0] xor $cc7aba9c);
   pac8(PChar(p)+319)^[0] := pac8(PChar(p)+319)^[0] or $b4;
   num := pac16(PChar(p)+229)^[0]; pac16(PChar(p)+229)^[0] := pac16(PChar(p)+170)^[0]; pac16(PChar(p)+170)^[0] := num;
 end;

 pac64(PChar(p)+126)^[0] := pac64(PChar(p)+126)^[0] xor $04c306e0;
 num := pac32(PChar(p)+160)^[0]; pac32(PChar(p)+160)^[0] := pac32(PChar(p)+435)^[0]; pac32(PChar(p)+435)^[0] := num;

B4838104(p);

end;

procedure B4838104(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+208)^[0] := pac64(PChar(p)+208)^[0] - (pac64(PChar(p)+374)^[0] - $5c70d9f616c9);
 pac64(PChar(p)+64)^[0] := pac64(PChar(p)+64)^[0] or (pac64(PChar(p)+367)^[0] xor $c8e2d7e15d76);
 if pac16(PChar(p)+434)^[0] < pac16(PChar(p)+99)^[0] then pac32(PChar(p)+46)^[0] := pac32(PChar(p)+46)^[0] xor (pac32(PChar(p)+86)^[0] xor $0c94b0) else pac64(PChar(p)+453)^[0] := pac64(PChar(p)+453)^[0] - $889f62b41055;
 if pac32(PChar(p)+42)^[0] < pac32(PChar(p)+285)^[0] then pac16(PChar(p)+417)^[0] := pac16(PChar(p)+417)^[0] xor ror2(pac16(PChar(p)+354)^[0] , 1 ) else pac8(PChar(p)+3)^[0] := pac8(PChar(p)+3)^[0] + (pac8(PChar(p)+442)^[0] - $fc);

 if pac64(PChar(p)+132)^[0] > pac64(PChar(p)+79)^[0] then begin
   pac32(PChar(p)+327)^[0] := pac32(PChar(p)+327)^[0] or $88ce;
   num := pac16(PChar(p)+157)^[0]; pac16(PChar(p)+157)^[0] := pac16(PChar(p)+131)^[0]; pac16(PChar(p)+131)^[0] := num;
   num := pac32(PChar(p)+168)^[0]; pac32(PChar(p)+168)^[0] := pac32(PChar(p)+406)^[0]; pac32(PChar(p)+406)^[0] := num;
   num := pac16(PChar(p)+281)^[0]; pac16(PChar(p)+281)^[0] := pac16(PChar(p)+80)^[0]; pac16(PChar(p)+80)^[0] := num;
   num := pac32(PChar(p)+7)^[0]; pac32(PChar(p)+7)^[0] := pac32(PChar(p)+97)^[0]; pac32(PChar(p)+97)^[0] := num;
 end;

 pac16(PChar(p)+371)^[0] := pac16(PChar(p)+371)^[0] or (pac16(PChar(p)+420)^[0] xor $f0);
 pac8(PChar(p)+137)^[0] := pac8(PChar(p)+137)^[0] - rol1(pac8(PChar(p)+359)^[0] , 5 );
 pac16(PChar(p)+249)^[0] := pac16(PChar(p)+249)^[0] - ror2(pac16(PChar(p)+466)^[0] , 14 );
 pac64(PChar(p)+448)^[0] := pac64(PChar(p)+448)^[0] or $4875a9ff;
 pac64(PChar(p)+266)^[0] := pac64(PChar(p)+266)^[0] + (pac64(PChar(p)+438)^[0] - $98b80bea);
 pac16(PChar(p)+423)^[0] := pac16(PChar(p)+174)^[0] + $40;

 if pac8(PChar(p)+95)^[0] > pac8(PChar(p)+362)^[0] then begin
   num := pac32(PChar(p)+324)^[0]; pac32(PChar(p)+324)^[0] := pac32(PChar(p)+60)^[0]; pac32(PChar(p)+60)^[0] := num;
   pac16(PChar(p)+153)^[0] := pac16(PChar(p)+153)^[0] or ror2(pac16(PChar(p)+450)^[0] , 15 );
   if pac64(PChar(p)+211)^[0] > pac64(PChar(p)+342)^[0] then pac64(PChar(p)+347)^[0] := pac64(PChar(p)+347)^[0] or (pac64(PChar(p)+8)^[0] + $4c892cab96f3) else begin  num := pac8(PChar(p)+342)^[0]; pac8(PChar(p)+342)^[0] := pac8(PChar(p)+414)^[0]; pac8(PChar(p)+414)^[0] := num; end;
 end;

 pac16(PChar(p)+268)^[0] := pac16(PChar(p)+268)^[0] xor ror2(pac16(PChar(p)+453)^[0] , 5 );
 pac32(PChar(p)+313)^[0] := pac32(PChar(p)+313)^[0] or (pac32(PChar(p)+457)^[0] - $b8a5);
 pac8(PChar(p)+220)^[0] := pac8(PChar(p)+220)^[0] + rol1(pac8(PChar(p)+216)^[0] , 6 );
 pac32(PChar(p)+435)^[0] := ror2(pac32(PChar(p)+76)^[0] , 6 );
 pac16(PChar(p)+35)^[0] := pac16(PChar(p)+35)^[0] xor ror1(pac16(PChar(p)+236)^[0] , 6 );
 num := pac32(PChar(p)+157)^[0]; pac32(PChar(p)+157)^[0] := pac32(PChar(p)+475)^[0]; pac32(PChar(p)+475)^[0] := num;

 if pac16(PChar(p)+437)^[0] > pac16(PChar(p)+213)^[0] then begin
   pac32(PChar(p)+290)^[0] := pac32(PChar(p)+290)^[0] xor (pac32(PChar(p)+62)^[0] + $58df97);
   if pac16(PChar(p)+340)^[0] < pac16(PChar(p)+140)^[0] then pac64(PChar(p)+230)^[0] := pac64(PChar(p)+319)^[0] - $202900e0c0b1 else pac32(PChar(p)+259)^[0] := pac32(PChar(p)+259)^[0] + $f45c;
   pac32(PChar(p)+318)^[0] := pac32(PChar(p)+318)^[0] - ror1(pac32(PChar(p)+372)^[0] , 19 );
   pac16(PChar(p)+448)^[0] := pac16(PChar(p)+58)^[0] or (pac16(PChar(p)+134)^[0] + $bc);
   pac16(PChar(p)+270)^[0] := pac16(PChar(p)+270)^[0] xor ror2(pac16(PChar(p)+137)^[0] , 2 );
 end;


E608D1C9(p);

end;

procedure E608D1C9(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+112)^[0]; pac32(PChar(p)+112)^[0] := pac32(PChar(p)+97)^[0]; pac32(PChar(p)+97)^[0] := num;
 pac16(PChar(p)+7)^[0] := rol1(pac16(PChar(p)+428)^[0] , 14 );
 pac64(PChar(p)+286)^[0] := pac64(PChar(p)+130)^[0] + $f8410956;

 if pac16(PChar(p)+373)^[0] < pac16(PChar(p)+26)^[0] then begin
   pac64(PChar(p)+18)^[0] := pac64(PChar(p)+30)^[0] xor $dc82bbf862c5;
   if pac8(PChar(p)+367)^[0] < pac8(PChar(p)+18)^[0] then pac32(PChar(p)+508)^[0] := pac32(PChar(p)+417)^[0] + $106cc1 else begin  num := pac32(PChar(p)+303)^[0]; pac32(PChar(p)+303)^[0] := pac32(PChar(p)+182)^[0]; pac32(PChar(p)+182)^[0] := num; end;
 end;

 pac64(PChar(p)+355)^[0] := pac64(PChar(p)+11)^[0] + (pac64(PChar(p)+448)^[0] xor $d090e8cc45d0);
 pac16(PChar(p)+128)^[0] := pac16(PChar(p)+128)^[0] xor $d4;
 num := pac16(PChar(p)+44)^[0]; pac16(PChar(p)+44)^[0] := pac16(PChar(p)+272)^[0]; pac16(PChar(p)+272)^[0] := num;
 pac32(PChar(p)+281)^[0] := pac32(PChar(p)+281)^[0] xor $9cf5;
 if pac32(PChar(p)+280)^[0] < pac32(PChar(p)+170)^[0] then pac8(PChar(p)+310)^[0] := pac8(PChar(p)+197)^[0] - (pac8(PChar(p)+202)^[0] + $80) else pac64(PChar(p)+117)^[0] := pac64(PChar(p)+117)^[0] + (pac64(PChar(p)+54)^[0] + $9027e62c);
 pac8(PChar(p)+443)^[0] := pac8(PChar(p)+443)^[0] xor ror2(pac8(PChar(p)+399)^[0] , 3 );
 if pac8(PChar(p)+459)^[0] > pac8(PChar(p)+340)^[0] then pac32(PChar(p)+298)^[0] := pac32(PChar(p)+298)^[0] or (pac32(PChar(p)+505)^[0] xor $7c3e32) else pac8(PChar(p)+414)^[0] := pac8(PChar(p)+414)^[0] + $18;

F6A66A73(p);

end;

procedure F6A66A73(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+444)^[0] < pac16(PChar(p)+101)^[0] then pac64(PChar(p)+310)^[0] := pac64(PChar(p)+310)^[0] + (pac64(PChar(p)+288)^[0] + $ecb81e1e1d) else begin  num := pac32(PChar(p)+53)^[0]; pac32(PChar(p)+53)^[0] := pac32(PChar(p)+90)^[0]; pac32(PChar(p)+90)^[0] := num; end;
 num := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := pac32(PChar(p)+334)^[0]; pac32(PChar(p)+334)^[0] := num;
 if pac32(PChar(p)+143)^[0] < pac32(PChar(p)+270)^[0] then pac16(PChar(p)+138)^[0] := pac16(PChar(p)+138)^[0] xor rol1(pac16(PChar(p)+242)^[0] , 13 ) else pac64(PChar(p)+397)^[0] := pac64(PChar(p)+397)^[0] or $c00b5b9e;
 pac16(PChar(p)+45)^[0] := pac16(PChar(p)+45)^[0] + $28;
 pac8(PChar(p)+331)^[0] := pac8(PChar(p)+439)^[0] - (pac8(PChar(p)+452)^[0] xor $8c);
 if pac8(PChar(p)+416)^[0] > pac8(PChar(p)+377)^[0] then pac64(PChar(p)+269)^[0] := pac64(PChar(p)+413)^[0] or (pac64(PChar(p)+119)^[0] or $607d568f11) else begin  num := pac8(PChar(p)+452)^[0]; pac8(PChar(p)+452)^[0] := pac8(PChar(p)+88)^[0]; pac8(PChar(p)+88)^[0] := num; end;
 pac32(PChar(p)+126)^[0] := pac32(PChar(p)+126)^[0] or rol1(pac32(PChar(p)+292)^[0] , 12 );
 pac32(PChar(p)+450)^[0] := ror2(pac32(PChar(p)+366)^[0] , 28 );
 pac32(PChar(p)+228)^[0] := pac32(PChar(p)+228)^[0] - (pac32(PChar(p)+474)^[0] xor $50800c);
 num := pac32(PChar(p)+64)^[0]; pac32(PChar(p)+64)^[0] := pac32(PChar(p)+507)^[0]; pac32(PChar(p)+507)^[0] := num;
 pac32(PChar(p)+375)^[0] := pac32(PChar(p)+375)^[0] xor rol1(pac32(PChar(p)+37)^[0] , 21 );

FE89C895(p);

end;

procedure FE89C895(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+176)^[0] := pac64(PChar(p)+176)^[0] xor (pac64(PChar(p)+222)^[0] + $009c2ec0);
 pac16(PChar(p)+332)^[0] := pac16(PChar(p)+332)^[0] xor (pac16(PChar(p)+311)^[0] - $68);
 num := pac32(PChar(p)+416)^[0]; pac32(PChar(p)+416)^[0] := pac32(PChar(p)+447)^[0]; pac32(PChar(p)+447)^[0] := num;
 if pac8(PChar(p)+445)^[0] > pac8(PChar(p)+130)^[0] then pac32(PChar(p)+226)^[0] := pac32(PChar(p)+226)^[0] xor $f4600d else pac64(PChar(p)+422)^[0] := pac64(PChar(p)+422)^[0] + (pac64(PChar(p)+66)^[0] xor $7cff3a7a);
 pac16(PChar(p)+261)^[0] := pac16(PChar(p)+261)^[0] + ror2(pac16(PChar(p)+282)^[0] , 2 );
 pac16(PChar(p)+356)^[0] := pac16(PChar(p)+322)^[0] + $e8;
 pac32(PChar(p)+131)^[0] := pac32(PChar(p)+131)^[0] or (pac32(PChar(p)+467)^[0] xor $887f);
 if pac8(PChar(p)+234)^[0] < pac8(PChar(p)+33)^[0] then pac8(PChar(p)+378)^[0] := pac8(PChar(p)+378)^[0] + ror2(pac8(PChar(p)+285)^[0] , 4 ) else begin  num := pac16(PChar(p)+191)^[0]; pac16(PChar(p)+191)^[0] := pac16(PChar(p)+403)^[0]; pac16(PChar(p)+403)^[0] := num; end;
 pac16(PChar(p)+138)^[0] := pac16(PChar(p)+138)^[0] - ror2(pac16(PChar(p)+226)^[0] , 6 );
 num := pac32(PChar(p)+60)^[0]; pac32(PChar(p)+60)^[0] := pac32(PChar(p)+213)^[0]; pac32(PChar(p)+213)^[0] := num;
 if pac8(PChar(p)+272)^[0] < pac8(PChar(p)+89)^[0] then pac8(PChar(p)+421)^[0] := pac8(PChar(p)+421)^[0] xor $50;
 if pac8(PChar(p)+295)^[0] > pac8(PChar(p)+124)^[0] then pac32(PChar(p)+305)^[0] := ror2(pac32(PChar(p)+360)^[0] , 9 ) else begin  num := pac32(PChar(p)+185)^[0]; pac32(PChar(p)+185)^[0] := pac32(PChar(p)+461)^[0]; pac32(PChar(p)+461)^[0] := num; end;

E9352DE0(p);

end;

procedure E9352DE0(p: Pointer);
var num: Int64;
begin


 if pac64(PChar(p)+299)^[0] < pac64(PChar(p)+426)^[0] then begin
   if pac16(PChar(p)+143)^[0] > pac16(PChar(p)+85)^[0] then pac64(PChar(p)+201)^[0] := pac64(PChar(p)+201)^[0] xor $dcde4d3f9a else begin  num := pac32(PChar(p)+98)^[0]; pac32(PChar(p)+98)^[0] := pac32(PChar(p)+75)^[0]; pac32(PChar(p)+75)^[0] := num; end;
   pac64(PChar(p)+307)^[0] := pac64(PChar(p)+307)^[0] xor $1800645f1a08;
   num := pac32(PChar(p)+427)^[0]; pac32(PChar(p)+427)^[0] := pac32(PChar(p)+489)^[0]; pac32(PChar(p)+489)^[0] := num;
   if pac32(PChar(p)+204)^[0] < pac32(PChar(p)+132)^[0] then pac32(PChar(p)+52)^[0] := pac32(PChar(p)+52)^[0] xor ror1(pac32(PChar(p)+457)^[0] , 22 ) else pac64(PChar(p)+316)^[0] := pac64(PChar(p)+316)^[0] + (pac64(PChar(p)+361)^[0] or $b0fec99f);
   if pac16(PChar(p)+80)^[0] > pac16(PChar(p)+101)^[0] then pac32(PChar(p)+272)^[0] := pac32(PChar(p)+272)^[0] or rol1(pac32(PChar(p)+214)^[0] , 4 ) else pac64(PChar(p)+370)^[0] := pac64(PChar(p)+370)^[0] xor (pac64(PChar(p)+74)^[0] - $c412bbc5b388);
 end;

 num := pac16(PChar(p)+411)^[0]; pac16(PChar(p)+411)^[0] := pac16(PChar(p)+155)^[0]; pac16(PChar(p)+155)^[0] := num;
 num := pac8(PChar(p)+349)^[0]; pac8(PChar(p)+349)^[0] := pac8(PChar(p)+502)^[0]; pac8(PChar(p)+502)^[0] := num;
 pac64(PChar(p)+84)^[0] := pac64(PChar(p)+448)^[0] xor (pac64(PChar(p)+62)^[0] xor $70a3c56d3b);
 pac64(PChar(p)+446)^[0] := pac64(PChar(p)+446)^[0] + (pac64(PChar(p)+55)^[0] or $3c7ebd52ce);
 if pac64(PChar(p)+301)^[0] < pac64(PChar(p)+453)^[0] then pac16(PChar(p)+101)^[0] := pac16(PChar(p)+101)^[0] xor rol1(pac16(PChar(p)+432)^[0] , 14 ) else pac8(PChar(p)+211)^[0] := pac8(PChar(p)+211)^[0] or ror1(pac8(PChar(p)+81)^[0] , 1 );
 pac8(PChar(p)+456)^[0] := pac8(PChar(p)+456)^[0] + ror2(pac8(PChar(p)+495)^[0] , 3 );

 if pac16(PChar(p)+240)^[0] < pac16(PChar(p)+128)^[0] then begin
   pac32(PChar(p)+479)^[0] := pac32(PChar(p)+479)^[0] or $3802;
   pac8(PChar(p)+470)^[0] := pac8(PChar(p)+498)^[0] - $bc;
 end;

 num := pac16(PChar(p)+464)^[0]; pac16(PChar(p)+464)^[0] := pac16(PChar(p)+471)^[0]; pac16(PChar(p)+471)^[0] := num;
 pac8(PChar(p)+114)^[0] := pac8(PChar(p)+114)^[0] - ror2(pac8(PChar(p)+65)^[0] , 2 );

B85BB9B6(p);

end;

procedure B85BB9B6(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+408)^[0] < pac8(PChar(p)+497)^[0] then begin
   pac32(PChar(p)+490)^[0] := pac32(PChar(p)+490)^[0] xor (pac32(PChar(p)+470)^[0] - $383e);
   pac8(PChar(p)+179)^[0] := pac8(PChar(p)+179)^[0] + ror2(pac8(PChar(p)+394)^[0] , 1 );
   pac32(PChar(p)+466)^[0] := pac32(PChar(p)+274)^[0] - (pac32(PChar(p)+90)^[0] + $7035);
   num := pac16(PChar(p)+179)^[0]; pac16(PChar(p)+179)^[0] := pac16(PChar(p)+261)^[0]; pac16(PChar(p)+261)^[0] := num;
 end;

 if pac32(PChar(p)+203)^[0] > pac32(PChar(p)+237)^[0] then begin  num := pac32(PChar(p)+259)^[0]; pac32(PChar(p)+259)^[0] := pac32(PChar(p)+359)^[0]; pac32(PChar(p)+359)^[0] := num; end else begin  num := pac32(PChar(p)+28)^[0]; pac32(PChar(p)+28)^[0] := pac32(PChar(p)+41)^[0]; pac32(PChar(p)+41)^[0] := num; end;

 if pac8(PChar(p)+492)^[0] > pac8(PChar(p)+226)^[0] then begin
   pac64(PChar(p)+84)^[0] := pac64(PChar(p)+173)^[0] or (pac64(PChar(p)+304)^[0] or $9053e0327050);
   pac32(PChar(p)+299)^[0] := ror2(pac32(PChar(p)+238)^[0] , 15 );
 end;


 if pac8(PChar(p)+306)^[0] < pac8(PChar(p)+510)^[0] then begin
   pac8(PChar(p)+180)^[0] := pac8(PChar(p)+180)^[0] + $24;
   pac32(PChar(p)+464)^[0] := pac32(PChar(p)+464)^[0] - (pac32(PChar(p)+474)^[0] xor $d4d1);
 end;

 pac32(PChar(p)+67)^[0] := pac32(PChar(p)+67)^[0] xor ror1(pac32(PChar(p)+23)^[0] , 17 );
 pac32(PChar(p)+283)^[0] := pac32(PChar(p)+283)^[0] or rol1(pac32(PChar(p)+393)^[0] , 29 );

 if pac32(PChar(p)+296)^[0] < pac32(PChar(p)+163)^[0] then begin
   pac16(PChar(p)+502)^[0] := pac16(PChar(p)+502)^[0] + rol1(pac16(PChar(p)+256)^[0] , 5 );
   pac32(PChar(p)+396)^[0] := pac32(PChar(p)+396)^[0] - ror1(pac32(PChar(p)+448)^[0] , 6 );
   pac16(PChar(p)+104)^[0] := ror1(pac16(PChar(p)+311)^[0] , 9 );
   num := pac8(PChar(p)+409)^[0]; pac8(PChar(p)+409)^[0] := pac8(PChar(p)+241)^[0]; pac8(PChar(p)+241)^[0] := num;
 end;

 pac16(PChar(p)+206)^[0] := pac16(PChar(p)+206)^[0] xor $6c;
 pac64(PChar(p)+277)^[0] := pac64(PChar(p)+277)^[0] xor (pac64(PChar(p)+295)^[0] xor $78a8664962c6);

 if pac8(PChar(p)+308)^[0] > pac8(PChar(p)+84)^[0] then begin
   pac64(PChar(p)+429)^[0] := pac64(PChar(p)+429)^[0] xor (pac64(PChar(p)+381)^[0] or $04db021b7c);
   pac32(PChar(p)+162)^[0] := pac32(PChar(p)+162)^[0] - $9800;
 end;

 pac8(PChar(p)+363)^[0] := rol1(pac8(PChar(p)+357)^[0] , 7 );

 if pac8(PChar(p)+229)^[0] > pac8(PChar(p)+56)^[0] then begin
   pac32(PChar(p)+45)^[0] := pac32(PChar(p)+45)^[0] or (pac32(PChar(p)+505)^[0] - $f8f8);
   if pac16(PChar(p)+272)^[0] < pac16(PChar(p)+495)^[0] then pac32(PChar(p)+284)^[0] := pac32(PChar(p)+284)^[0] or (pac32(PChar(p)+268)^[0] xor $7ccdcb) else pac64(PChar(p)+415)^[0] := pac64(PChar(p)+415)^[0] + $5c09b2394d;
   if pac32(PChar(p)+424)^[0] > pac32(PChar(p)+124)^[0] then pac16(PChar(p)+401)^[0] := pac16(PChar(p)+401)^[0] or (pac16(PChar(p)+295)^[0] or $50) else pac64(PChar(p)+470)^[0] := pac64(PChar(p)+470)^[0] xor $205ec4794cad;
   pac64(PChar(p)+326)^[0] := pac64(PChar(p)+326)^[0] or (pac64(PChar(p)+281)^[0] - $3c57d9d99e9c);
 end;

 num := pac16(PChar(p)+214)^[0]; pac16(PChar(p)+214)^[0] := pac16(PChar(p)+38)^[0]; pac16(PChar(p)+38)^[0] := num;
 pac64(PChar(p)+493)^[0] := pac64(PChar(p)+493)^[0] + $6c22f4f8993d;
 pac16(PChar(p)+440)^[0] := pac16(PChar(p)+440)^[0] - (pac16(PChar(p)+215)^[0] - $b4);
 pac64(PChar(p)+286)^[0] := pac64(PChar(p)+286)^[0] + $d49c367520dd;

AFFCA0AA(p);

end;

procedure AFFCA0AA(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+441)^[0] > pac8(PChar(p)+3)^[0] then begin  num := pac32(PChar(p)+76)^[0]; pac32(PChar(p)+76)^[0] := pac32(PChar(p)+128)^[0]; pac32(PChar(p)+128)^[0] := num; end;

 if pac32(PChar(p)+187)^[0] > pac32(PChar(p)+66)^[0] then begin
   pac32(PChar(p)+165)^[0] := pac32(PChar(p)+165)^[0] xor $74b45f;
   pac16(PChar(p)+491)^[0] := pac16(PChar(p)+491)^[0] - (pac16(PChar(p)+325)^[0] xor $04);
   pac64(PChar(p)+178)^[0] := pac64(PChar(p)+178)^[0] + (pac64(PChar(p)+41)^[0] or $8c254156);
   num := pac16(PChar(p)+340)^[0]; pac16(PChar(p)+340)^[0] := pac16(PChar(p)+90)^[0]; pac16(PChar(p)+90)^[0] := num;
   num := pac16(PChar(p)+69)^[0]; pac16(PChar(p)+69)^[0] := pac16(PChar(p)+288)^[0]; pac16(PChar(p)+288)^[0] := num;
 end;

 pac8(PChar(p)+151)^[0] := pac8(PChar(p)+151)^[0] or ror2(pac8(PChar(p)+322)^[0] , 3 );
 pac32(PChar(p)+367)^[0] := pac32(PChar(p)+367)^[0] + ror1(pac32(PChar(p)+182)^[0] , 21 );
 pac32(PChar(p)+182)^[0] := pac32(PChar(p)+182)^[0] + ror2(pac32(PChar(p)+256)^[0] , 6 );
 pac32(PChar(p)+329)^[0] := pac32(PChar(p)+356)^[0] + (pac32(PChar(p)+18)^[0] xor $3016);
 pac16(PChar(p)+241)^[0] := ror1(pac16(PChar(p)+232)^[0] , 13 );
 pac32(PChar(p)+93)^[0] := pac32(PChar(p)+93)^[0] + (pac32(PChar(p)+240)^[0] - $d442);

 if pac32(PChar(p)+118)^[0] > pac32(PChar(p)+423)^[0] then begin
   pac8(PChar(p)+192)^[0] := pac8(PChar(p)+192)^[0] xor ror1(pac8(PChar(p)+506)^[0] , 3 );
   pac8(PChar(p)+68)^[0] := pac8(PChar(p)+68)^[0] or (pac8(PChar(p)+372)^[0] + $6c);
 end;

 pac32(PChar(p)+432)^[0] := pac32(PChar(p)+94)^[0] - (pac32(PChar(p)+363)^[0] - $0c96);
 pac8(PChar(p)+336)^[0] := pac8(PChar(p)+336)^[0] or ror2(pac8(PChar(p)+37)^[0] , 4 );
 if pac32(PChar(p)+333)^[0] < pac32(PChar(p)+7)^[0] then pac8(PChar(p)+450)^[0] := pac8(PChar(p)+341)^[0] + $e0;
 if pac16(PChar(p)+208)^[0] < pac16(PChar(p)+23)^[0] then pac16(PChar(p)+477)^[0] := pac16(PChar(p)+477)^[0] or $34;
 pac64(PChar(p)+164)^[0] := pac64(PChar(p)+164)^[0] xor (pac64(PChar(p)+110)^[0] xor $7814bbca);
 num := pac16(PChar(p)+45)^[0]; pac16(PChar(p)+45)^[0] := pac16(PChar(p)+161)^[0]; pac16(PChar(p)+161)^[0] := num;
 pac64(PChar(p)+60)^[0] := pac64(PChar(p)+60)^[0] - $e47db8e5;

 if pac16(PChar(p)+420)^[0] < pac16(PChar(p)+10)^[0] then begin
   pac64(PChar(p)+87)^[0] := pac64(PChar(p)+15)^[0] + (pac64(PChar(p)+5)^[0] or $6862049a89);
   pac16(PChar(p)+29)^[0] := pac16(PChar(p)+29)^[0] xor (pac16(PChar(p)+185)^[0] or $7c);
   pac16(PChar(p)+329)^[0] := pac16(PChar(p)+329)^[0] xor ror2(pac16(PChar(p)+442)^[0] , 3 );
   pac8(PChar(p)+143)^[0] := pac8(PChar(p)+143)^[0] xor ror1(pac8(PChar(p)+4)^[0] , 5 );
 end;

 pac8(PChar(p)+158)^[0] := pac8(PChar(p)+158)^[0] or $d0;

BED31595(p);

end;

procedure BED31595(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+290)^[0] := pac32(PChar(p)+290)^[0] + rol1(pac32(PChar(p)+383)^[0] , 15 );
 num := pac8(PChar(p)+426)^[0]; pac8(PChar(p)+426)^[0] := pac8(PChar(p)+164)^[0]; pac8(PChar(p)+164)^[0] := num;
 num := pac32(PChar(p)+194)^[0]; pac32(PChar(p)+194)^[0] := pac32(PChar(p)+447)^[0]; pac32(PChar(p)+447)^[0] := num;
 pac8(PChar(p)+404)^[0] := pac8(PChar(p)+404)^[0] + ror1(pac8(PChar(p)+493)^[0] , 5 );
 pac64(PChar(p)+264)^[0] := pac64(PChar(p)+264)^[0] - (pac64(PChar(p)+446)^[0] xor $c06fbd4156);
 if pac16(PChar(p)+18)^[0] < pac16(PChar(p)+275)^[0] then pac8(PChar(p)+36)^[0] := pac8(PChar(p)+36)^[0] xor (pac8(PChar(p)+260)^[0] or $24) else pac8(PChar(p)+443)^[0] := pac8(PChar(p)+443)^[0] xor (pac8(PChar(p)+299)^[0] or $40);
 pac32(PChar(p)+360)^[0] := ror1(pac32(PChar(p)+44)^[0] , 12 );
 pac32(PChar(p)+118)^[0] := pac32(PChar(p)+118)^[0] xor $586ae4;

 if pac32(PChar(p)+241)^[0] < pac32(PChar(p)+109)^[0] then begin
   if pac16(PChar(p)+303)^[0] < pac16(PChar(p)+139)^[0] then pac64(PChar(p)+354)^[0] := pac64(PChar(p)+354)^[0] or (pac64(PChar(p)+96)^[0] or $5c2333b897) else pac64(PChar(p)+381)^[0] := pac64(PChar(p)+381)^[0] or $70372a969dda;
   pac32(PChar(p)+451)^[0] := pac32(PChar(p)+451)^[0] xor $208d;
   pac8(PChar(p)+442)^[0] := pac8(PChar(p)+442)^[0] - $04;
   pac16(PChar(p)+432)^[0] := pac16(PChar(p)+432)^[0] + ror1(pac16(PChar(p)+216)^[0] , 5 );
   pac8(PChar(p)+139)^[0] := pac8(PChar(p)+139)^[0] - ror1(pac8(PChar(p)+77)^[0] , 5 );
 end;

 pac32(PChar(p)+58)^[0] := pac32(PChar(p)+58)^[0] - (pac32(PChar(p)+388)^[0] - $a40d);

 if pac64(PChar(p)+472)^[0] < pac64(PChar(p)+483)^[0] then begin
   pac32(PChar(p)+469)^[0] := pac32(PChar(p)+469)^[0] + $c09fee;
   num := pac32(PChar(p)+58)^[0]; pac32(PChar(p)+58)^[0] := pac32(PChar(p)+445)^[0]; pac32(PChar(p)+445)^[0] := num;
   pac32(PChar(p)+325)^[0] := pac32(PChar(p)+325)^[0] + (pac32(PChar(p)+6)^[0] or $8cc25f);
   num := pac16(PChar(p)+355)^[0]; pac16(PChar(p)+355)^[0] := pac16(PChar(p)+182)^[0]; pac16(PChar(p)+182)^[0] := num;
   pac32(PChar(p)+306)^[0] := pac32(PChar(p)+306)^[0] - $40fc;
 end;

 pac8(PChar(p)+129)^[0] := pac8(PChar(p)+129)^[0] + ror1(pac8(PChar(p)+76)^[0] , 2 );
 pac32(PChar(p)+345)^[0] := pac32(PChar(p)+345)^[0] - ror1(pac32(PChar(p)+447)^[0] , 19 );
 pac32(PChar(p)+52)^[0] := pac32(PChar(p)+52)^[0] - rol1(pac32(PChar(p)+308)^[0] , 30 );
 pac16(PChar(p)+270)^[0] := pac16(PChar(p)+270)^[0] xor rol1(pac16(PChar(p)+171)^[0] , 5 );
 pac8(PChar(p)+488)^[0] := pac8(PChar(p)+488)^[0] or ror2(pac8(PChar(p)+32)^[0] , 5 );
 pac32(PChar(p)+85)^[0] := pac32(PChar(p)+85)^[0] + ror1(pac32(PChar(p)+191)^[0] , 28 );
 num := pac32(PChar(p)+505)^[0]; pac32(PChar(p)+505)^[0] := pac32(PChar(p)+262)^[0]; pac32(PChar(p)+262)^[0] := num;
 num := pac32(PChar(p)+129)^[0]; pac32(PChar(p)+129)^[0] := pac32(PChar(p)+308)^[0]; pac32(PChar(p)+308)^[0] := num;

F4504EC7(p);

end;

procedure F4504EC7(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+184)^[0] > pac16(PChar(p)+326)^[0] then pac8(PChar(p)+199)^[0] := pac8(PChar(p)+199)^[0] xor ror2(pac8(PChar(p)+248)^[0] , 2 ) else pac32(PChar(p)+194)^[0] := pac32(PChar(p)+194)^[0] + $04b059;
 pac64(PChar(p)+220)^[0] := pac64(PChar(p)+220)^[0] + (pac64(PChar(p)+411)^[0] - $c4033600);
 pac32(PChar(p)+37)^[0] := pac32(PChar(p)+37)^[0] xor $146939;
 num := pac16(PChar(p)+413)^[0]; pac16(PChar(p)+413)^[0] := pac16(PChar(p)+98)^[0]; pac16(PChar(p)+98)^[0] := num;
 if pac8(PChar(p)+461)^[0] > pac8(PChar(p)+15)^[0] then begin  num := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := pac16(PChar(p)+373)^[0]; pac16(PChar(p)+373)^[0] := num; end else begin  num := pac32(PChar(p)+13)^[0]; pac32(PChar(p)+13)^[0] := pac32(PChar(p)+104)^[0]; pac32(PChar(p)+104)^[0] := num; end;
 if pac64(PChar(p)+274)^[0] < pac64(PChar(p)+176)^[0] then begin  num := pac8(PChar(p)+232)^[0]; pac8(PChar(p)+232)^[0] := pac8(PChar(p)+466)^[0]; pac8(PChar(p)+466)^[0] := num; end else pac32(PChar(p)+25)^[0] := ror2(pac32(PChar(p)+6)^[0] , 29 );
 pac64(PChar(p)+79)^[0] := pac64(PChar(p)+79)^[0] or $5c93e750a9;

 if pac16(PChar(p)+210)^[0] > pac16(PChar(p)+325)^[0] then begin
   if pac32(PChar(p)+192)^[0] > pac32(PChar(p)+242)^[0] then pac32(PChar(p)+218)^[0] := pac32(PChar(p)+218)^[0] or ror2(pac32(PChar(p)+233)^[0] , 18 ) else pac64(PChar(p)+389)^[0] := pac64(PChar(p)+389)^[0] - $20d8dfc2fe;
   pac32(PChar(p)+36)^[0] := pac32(PChar(p)+454)^[0] - (pac32(PChar(p)+237)^[0] - $8827a6);
 end;

 pac32(PChar(p)+387)^[0] := pac32(PChar(p)+387)^[0] + ror2(pac32(PChar(p)+315)^[0] , 16 );

 if pac16(PChar(p)+303)^[0] < pac16(PChar(p)+292)^[0] then begin
   pac32(PChar(p)+309)^[0] := pac32(PChar(p)+309)^[0] or ror2(pac32(PChar(p)+91)^[0] , 6 );
   pac8(PChar(p)+464)^[0] := pac8(PChar(p)+464)^[0] xor (pac8(PChar(p)+37)^[0] - $18);
   if pac64(PChar(p)+71)^[0] < pac64(PChar(p)+446)^[0] then pac16(PChar(p)+369)^[0] := pac16(PChar(p)+369)^[0] + ror1(pac16(PChar(p)+66)^[0] , 13 ) else begin  num := pac8(PChar(p)+251)^[0]; pac8(PChar(p)+251)^[0] := pac8(PChar(p)+177)^[0]; pac8(PChar(p)+177)^[0] := num; end;
 end;


C7BE7494(p);

end;

procedure C7BE7494(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+267)^[0] := ror2(pac16(PChar(p)+207)^[0] , 13 );

 if pac32(PChar(p)+377)^[0] > pac32(PChar(p)+238)^[0] then begin
   if pac32(PChar(p)+262)^[0] < pac32(PChar(p)+254)^[0] then pac16(PChar(p)+189)^[0] := pac16(PChar(p)+189)^[0] or ror1(pac16(PChar(p)+494)^[0] , 8 ) else begin  num := pac8(PChar(p)+25)^[0]; pac8(PChar(p)+25)^[0] := pac8(PChar(p)+360)^[0]; pac8(PChar(p)+360)^[0] := num; end;
   num := pac32(PChar(p)+32)^[0]; pac32(PChar(p)+32)^[0] := pac32(PChar(p)+322)^[0]; pac32(PChar(p)+322)^[0] := num;
 end;

 pac32(PChar(p)+327)^[0] := pac32(PChar(p)+327)^[0] xor rol1(pac32(PChar(p)+129)^[0] , 17 );
 if pac64(PChar(p)+251)^[0] > pac64(PChar(p)+103)^[0] then pac32(PChar(p)+356)^[0] := pac32(PChar(p)+356)^[0] - ror1(pac32(PChar(p)+117)^[0] , 12 ) else pac32(PChar(p)+276)^[0] := pac32(PChar(p)+276)^[0] xor $ac82;
 pac32(PChar(p)+178)^[0] := pac32(PChar(p)+178)^[0] + (pac32(PChar(p)+503)^[0] xor $48e510);

 if pac16(PChar(p)+275)^[0] > pac16(PChar(p)+30)^[0] then begin
   num := pac32(PChar(p)+264)^[0]; pac32(PChar(p)+264)^[0] := pac32(PChar(p)+261)^[0]; pac32(PChar(p)+261)^[0] := num;
   pac64(PChar(p)+243)^[0] := pac64(PChar(p)+243)^[0] + (pac64(PChar(p)+400)^[0] xor $d8b6e8ee);
 end;

 pac32(PChar(p)+15)^[0] := pac32(PChar(p)+15)^[0] - (pac32(PChar(p)+211)^[0] xor $387f);
 pac32(PChar(p)+210)^[0] := ror2(pac32(PChar(p)+426)^[0] , 30 );
 if pac32(PChar(p)+7)^[0] > pac32(PChar(p)+38)^[0] then begin  num := pac16(PChar(p)+187)^[0]; pac16(PChar(p)+187)^[0] := pac16(PChar(p)+430)^[0]; pac16(PChar(p)+430)^[0] := num; end else pac32(PChar(p)+266)^[0] := pac32(PChar(p)+266)^[0] - ror1(pac32(PChar(p)+453)^[0] , 19 );
 pac32(PChar(p)+296)^[0] := pac32(PChar(p)+296)^[0] + ror2(pac32(PChar(p)+441)^[0] , 14 );
 if pac64(PChar(p)+467)^[0] < pac64(PChar(p)+331)^[0] then pac64(PChar(p)+130)^[0] := pac64(PChar(p)+130)^[0] - $90f49b126618;
 pac64(PChar(p)+492)^[0] := pac64(PChar(p)+492)^[0] - $dca488c1dfe6;
 pac32(PChar(p)+437)^[0] := pac32(PChar(p)+437)^[0] or $0411ce;
 pac64(PChar(p)+126)^[0] := pac64(PChar(p)+126)^[0] + (pac64(PChar(p)+127)^[0] xor $fc14bd87b5);

 if pac16(PChar(p)+272)^[0] < pac16(PChar(p)+166)^[0] then begin
   num := pac8(PChar(p)+57)^[0]; pac8(PChar(p)+57)^[0] := pac8(PChar(p)+39)^[0]; pac8(PChar(p)+39)^[0] := num;
   pac8(PChar(p)+97)^[0] := pac8(PChar(p)+97)^[0] xor rol1(pac8(PChar(p)+109)^[0] , 4 );
   pac32(PChar(p)+420)^[0] := ror2(pac32(PChar(p)+182)^[0] , 30 );
 end;

 pac32(PChar(p)+123)^[0] := pac32(PChar(p)+123)^[0] + (pac32(PChar(p)+18)^[0] - $e84dc6);
 if pac16(PChar(p)+428)^[0] < pac16(PChar(p)+230)^[0] then pac8(PChar(p)+456)^[0] := pac8(PChar(p)+456)^[0] - ror2(pac8(PChar(p)+65)^[0] , 7 ) else pac32(PChar(p)+13)^[0] := pac32(PChar(p)+467)^[0] xor (pac32(PChar(p)+471)^[0] + $1430);

D5D625FF(p);

end;

procedure D5D625FF(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+104)^[0]; pac8(PChar(p)+104)^[0] := pac8(PChar(p)+53)^[0]; pac8(PChar(p)+53)^[0] := num;
 if pac8(PChar(p)+310)^[0] > pac8(PChar(p)+115)^[0] then pac64(PChar(p)+152)^[0] := pac64(PChar(p)+152)^[0] xor $9064a1479c else pac64(PChar(p)+474)^[0] := pac64(PChar(p)+474)^[0] + (pac64(PChar(p)+313)^[0] or $a09cbb2a39);
 if pac64(PChar(p)+22)^[0] > pac64(PChar(p)+304)^[0] then begin  num := pac8(PChar(p)+503)^[0]; pac8(PChar(p)+503)^[0] := pac8(PChar(p)+353)^[0]; pac8(PChar(p)+353)^[0] := num; end else pac16(PChar(p)+501)^[0] := pac16(PChar(p)+501)^[0] - (pac16(PChar(p)+76)^[0] xor $34);
 if pac8(PChar(p)+126)^[0] < pac8(PChar(p)+140)^[0] then pac64(PChar(p)+227)^[0] := pac64(PChar(p)+227)^[0] - (pac64(PChar(p)+345)^[0] or $08f0152d);
 pac32(PChar(p)+468)^[0] := pac32(PChar(p)+468)^[0] + $00ef;
 pac32(PChar(p)+456)^[0] := pac32(PChar(p)+456)^[0] or (pac32(PChar(p)+430)^[0] xor $e461);
 pac32(PChar(p)+357)^[0] := pac32(PChar(p)+357)^[0] + (pac32(PChar(p)+54)^[0] or $6ca3d0);
 num := pac32(PChar(p)+285)^[0]; pac32(PChar(p)+285)^[0] := pac32(PChar(p)+82)^[0]; pac32(PChar(p)+82)^[0] := num;

 if pac16(PChar(p)+362)^[0] < pac16(PChar(p)+398)^[0] then begin
   pac64(PChar(p)+448)^[0] := pac64(PChar(p)+448)^[0] xor (pac64(PChar(p)+317)^[0] + $7c318ac693);
   pac16(PChar(p)+114)^[0] := pac16(PChar(p)+114)^[0] or ror1(pac16(PChar(p)+395)^[0] , 9 );
   pac64(PChar(p)+253)^[0] := pac64(PChar(p)+470)^[0] + $404859185a;
   if pac32(PChar(p)+448)^[0] < pac32(PChar(p)+283)^[0] then begin  num := pac16(PChar(p)+311)^[0]; pac16(PChar(p)+311)^[0] := pac16(PChar(p)+141)^[0]; pac16(PChar(p)+141)^[0] := num; end;
   pac32(PChar(p)+254)^[0] := pac32(PChar(p)+254)^[0] xor ror2(pac32(PChar(p)+488)^[0] , 21 );
 end;


 if pac32(PChar(p)+350)^[0] > pac32(PChar(p)+303)^[0] then begin
   num := pac32(PChar(p)+335)^[0]; pac32(PChar(p)+335)^[0] := pac32(PChar(p)+368)^[0]; pac32(PChar(p)+368)^[0] := num;
   pac8(PChar(p)+152)^[0] := pac8(PChar(p)+152)^[0] or ror1(pac8(PChar(p)+173)^[0] , 5 );
   pac64(PChar(p)+34)^[0] := pac64(PChar(p)+34)^[0] + (pac64(PChar(p)+471)^[0] + $8c695d80e749);
 end;

 num := pac16(PChar(p)+317)^[0]; pac16(PChar(p)+317)^[0] := pac16(PChar(p)+255)^[0]; pac16(PChar(p)+255)^[0] := num;
 num := pac32(PChar(p)+312)^[0]; pac32(PChar(p)+312)^[0] := pac32(PChar(p)+424)^[0]; pac32(PChar(p)+424)^[0] := num;
 pac16(PChar(p)+301)^[0] := pac16(PChar(p)+192)^[0] or (pac16(PChar(p)+94)^[0] xor $d0);
 num := pac8(PChar(p)+148)^[0]; pac8(PChar(p)+148)^[0] := pac8(PChar(p)+456)^[0]; pac8(PChar(p)+456)^[0] := num;

C0E8AA1C(p);

end;

procedure C0E8AA1C(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+297)^[0] := pac32(PChar(p)+297)^[0] or (pac32(PChar(p)+493)^[0] - $cced);
 pac64(PChar(p)+112)^[0] := pac64(PChar(p)+112)^[0] or $9c4fce599199;

 if pac16(PChar(p)+454)^[0] > pac16(PChar(p)+144)^[0] then begin
   if pac32(PChar(p)+92)^[0] < pac32(PChar(p)+464)^[0] then pac16(PChar(p)+202)^[0] := pac16(PChar(p)+202)^[0] - ror2(pac16(PChar(p)+94)^[0] , 13 ) else begin  num := pac16(PChar(p)+24)^[0]; pac16(PChar(p)+24)^[0] := pac16(PChar(p)+285)^[0]; pac16(PChar(p)+285)^[0] := num; end;
   pac32(PChar(p)+35)^[0] := pac32(PChar(p)+35)^[0] - (pac32(PChar(p)+335)^[0] or $889a);
 end;

 if pac16(PChar(p)+418)^[0] > pac16(PChar(p)+119)^[0] then pac32(PChar(p)+354)^[0] := pac32(PChar(p)+354)^[0] - $9cb92e;
 num := pac32(PChar(p)+118)^[0]; pac32(PChar(p)+118)^[0] := pac32(PChar(p)+209)^[0]; pac32(PChar(p)+209)^[0] := num;
 pac16(PChar(p)+79)^[0] := pac16(PChar(p)+79)^[0] xor ror2(pac16(PChar(p)+38)^[0] , 3 );
 if pac64(PChar(p)+163)^[0] > pac64(PChar(p)+466)^[0] then pac64(PChar(p)+150)^[0] := pac64(PChar(p)+150)^[0] - (pac64(PChar(p)+358)^[0] + $e0902dd70000) else begin  num := pac8(PChar(p)+229)^[0]; pac8(PChar(p)+229)^[0] := pac8(PChar(p)+432)^[0]; pac8(PChar(p)+432)^[0] := num; end;
 pac8(PChar(p)+275)^[0] := pac8(PChar(p)+275)^[0] - rol1(pac8(PChar(p)+213)^[0] , 6 );
 pac16(PChar(p)+287)^[0] := pac16(PChar(p)+179)^[0] - (pac16(PChar(p)+163)^[0] - $c0);
 if pac32(PChar(p)+16)^[0] > pac32(PChar(p)+487)^[0] then pac64(PChar(p)+15)^[0] := pac64(PChar(p)+15)^[0] or $a4ed989c else pac64(PChar(p)+42)^[0] := pac64(PChar(p)+400)^[0] xor $9811973954;
 num := pac32(PChar(p)+6)^[0]; pac32(PChar(p)+6)^[0] := pac32(PChar(p)+423)^[0]; pac32(PChar(p)+423)^[0] := num;
 pac16(PChar(p)+341)^[0] := pac16(PChar(p)+341)^[0] xor ror1(pac16(PChar(p)+489)^[0] , 11 );
 if pac16(PChar(p)+6)^[0] > pac16(PChar(p)+263)^[0] then pac16(PChar(p)+390)^[0] := pac16(PChar(p)+390)^[0] or $58 else begin  num := pac32(PChar(p)+480)^[0]; pac32(PChar(p)+480)^[0] := pac32(PChar(p)+435)^[0]; pac32(PChar(p)+435)^[0] := num; end;
 pac8(PChar(p)+246)^[0] := pac8(PChar(p)+246)^[0] + (pac8(PChar(p)+504)^[0] + $e8);

 if pac8(PChar(p)+159)^[0] < pac8(PChar(p)+181)^[0] then begin
   num := pac32(PChar(p)+404)^[0]; pac32(PChar(p)+404)^[0] := pac32(PChar(p)+292)^[0]; pac32(PChar(p)+292)^[0] := num;
   pac16(PChar(p)+313)^[0] := pac16(PChar(p)+285)^[0] or $d8;
 end;

 pac16(PChar(p)+168)^[0] := pac16(PChar(p)+168)^[0] or $c4;

DFCBCC00(p);

end;

procedure DFCBCC00(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+175)^[0] < pac32(PChar(p)+489)^[0] then begin
   pac64(PChar(p)+312)^[0] := pac64(PChar(p)+312)^[0] or $40dc672d;
   pac64(PChar(p)+339)^[0] := pac64(PChar(p)+339)^[0] or (pac64(PChar(p)+241)^[0] - $c092d519bc);
 end;


 if pac16(PChar(p)+101)^[0] < pac16(PChar(p)+86)^[0] then begin
   pac16(PChar(p)+364)^[0] := pac16(PChar(p)+42)^[0] + $f4;
   pac8(PChar(p)+140)^[0] := pac8(PChar(p)+140)^[0] + (pac8(PChar(p)+418)^[0] or $48);
   pac32(PChar(p)+182)^[0] := ror2(pac32(PChar(p)+338)^[0] , 24 );
   pac16(PChar(p)+400)^[0] := pac16(PChar(p)+400)^[0] - ror2(pac16(PChar(p)+201)^[0] , 2 );
   pac8(PChar(p)+214)^[0] := pac8(PChar(p)+214)^[0] - rol1(pac8(PChar(p)+275)^[0] , 5 );
 end;

 pac16(PChar(p)+428)^[0] := pac16(PChar(p)+428)^[0] + (pac16(PChar(p)+304)^[0] + $90);
 num := pac8(PChar(p)+178)^[0]; pac8(PChar(p)+178)^[0] := pac8(PChar(p)+15)^[0]; pac8(PChar(p)+15)^[0] := num;
 pac16(PChar(p)+462)^[0] := pac16(PChar(p)+462)^[0] or rol1(pac16(PChar(p)+71)^[0] , 14 );
 pac16(PChar(p)+169)^[0] := pac16(PChar(p)+169)^[0] or ror2(pac16(PChar(p)+443)^[0] , 4 );
 pac8(PChar(p)+495)^[0] := ror1(pac8(PChar(p)+6)^[0] , 6 );
 pac16(PChar(p)+166)^[0] := pac16(PChar(p)+166)^[0] xor (pac16(PChar(p)+146)^[0] xor $9c);
 if pac32(PChar(p)+70)^[0] < pac32(PChar(p)+199)^[0] then pac32(PChar(p)+192)^[0] := pac32(PChar(p)+311)^[0] - (pac32(PChar(p)+1)^[0] or $d05c1c) else begin  num := pac32(PChar(p)+258)^[0]; pac32(PChar(p)+258)^[0] := pac32(PChar(p)+263)^[0]; pac32(PChar(p)+263)^[0] := num; end;
 num := pac16(PChar(p)+7)^[0]; pac16(PChar(p)+7)^[0] := pac16(PChar(p)+437)^[0]; pac16(PChar(p)+437)^[0] := num;
 pac64(PChar(p)+41)^[0] := pac64(PChar(p)+41)^[0] xor (pac64(PChar(p)+406)^[0] xor $b0972e38cb03);
 num := pac16(PChar(p)+197)^[0]; pac16(PChar(p)+197)^[0] := pac16(PChar(p)+59)^[0]; pac16(PChar(p)+59)^[0] := num;
 pac8(PChar(p)+320)^[0] := pac8(PChar(p)+320)^[0] + ror1(pac8(PChar(p)+276)^[0] , 4 );

 if pac64(PChar(p)+2)^[0] < pac64(PChar(p)+47)^[0] then begin
   pac64(PChar(p)+50)^[0] := pac64(PChar(p)+50)^[0] + (pac64(PChar(p)+485)^[0] + $c8a82014);
   if pac64(PChar(p)+308)^[0] > pac64(PChar(p)+488)^[0] then begin  num := pac16(PChar(p)+408)^[0]; pac16(PChar(p)+408)^[0] := pac16(PChar(p)+480)^[0]; pac16(PChar(p)+480)^[0] := num; end;
   if pac64(PChar(p)+150)^[0] > pac64(PChar(p)+495)^[0] then pac16(PChar(p)+4)^[0] := pac16(PChar(p)+4)^[0] or ror2(pac16(PChar(p)+451)^[0] , 4 ) else begin  num := pac32(PChar(p)+219)^[0]; pac32(PChar(p)+219)^[0] := pac32(PChar(p)+304)^[0]; pac32(PChar(p)+304)^[0] := num; end;
   pac8(PChar(p)+426)^[0] := pac8(PChar(p)+426)^[0] + (pac8(PChar(p)+54)^[0] - $cc);
   num := pac16(PChar(p)+327)^[0]; pac16(PChar(p)+327)^[0] := pac16(PChar(p)+449)^[0]; pac16(PChar(p)+449)^[0] := num;
 end;

 pac64(PChar(p)+101)^[0] := pac64(PChar(p)+101)^[0] + (pac64(PChar(p)+89)^[0] + $2454099c);
 pac32(PChar(p)+43)^[0] := pac32(PChar(p)+43)^[0] xor $6c1c;
 pac8(PChar(p)+128)^[0] := pac8(PChar(p)+128)^[0] or ror2(pac8(PChar(p)+244)^[0] , 5 );

C10174D6(p);

end;

procedure C10174D6(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+386)^[0] := pac64(PChar(p)+386)^[0] or $407e6858;

 if pac64(PChar(p)+504)^[0] < pac64(PChar(p)+22)^[0] then begin
   pac64(PChar(p)+413)^[0] := pac64(PChar(p)+413)^[0] or (pac64(PChar(p)+340)^[0] or $449f4bea76);
   pac32(PChar(p)+61)^[0] := pac32(PChar(p)+258)^[0] or (pac32(PChar(p)+429)^[0] or $8c53fd);
   num := pac8(PChar(p)+12)^[0]; pac8(PChar(p)+12)^[0] := pac8(PChar(p)+87)^[0]; pac8(PChar(p)+87)^[0] := num;
   num := pac16(PChar(p)+113)^[0]; pac16(PChar(p)+113)^[0] := pac16(PChar(p)+242)^[0]; pac16(PChar(p)+242)^[0] := num;
 end;

 num := pac16(PChar(p)+345)^[0]; pac16(PChar(p)+345)^[0] := pac16(PChar(p)+288)^[0]; pac16(PChar(p)+288)^[0] := num;
 pac64(PChar(p)+449)^[0] := pac64(PChar(p)+217)^[0] xor $4cedbb78;
 pac64(PChar(p)+476)^[0] := pac64(PChar(p)+36)^[0] xor (pac64(PChar(p)+132)^[0] xor $dc985b30);
 pac32(PChar(p)+210)^[0] := pac32(PChar(p)+210)^[0] or (pac32(PChar(p)+405)^[0] or $f4e1);
 pac8(PChar(p)+288)^[0] := ror2(pac8(PChar(p)+325)^[0] , 2 );
 pac64(PChar(p)+479)^[0] := pac64(PChar(p)+479)^[0] or (pac64(PChar(p)+117)^[0] xor $28393070b173);

 if pac8(PChar(p)+501)^[0] > pac8(PChar(p)+407)^[0] then begin
   if pac16(PChar(p)+11)^[0] > pac16(PChar(p)+369)^[0] then pac64(PChar(p)+375)^[0] := pac64(PChar(p)+375)^[0] - $94ae13447503 else pac8(PChar(p)+109)^[0] := pac8(PChar(p)+109)^[0] or $c8;
   num := pac32(PChar(p)+108)^[0]; pac32(PChar(p)+108)^[0] := pac32(PChar(p)+255)^[0]; pac32(PChar(p)+255)^[0] := num;
   num := pac32(PChar(p)+431)^[0]; pac32(PChar(p)+431)^[0] := pac32(PChar(p)+323)^[0]; pac32(PChar(p)+323)^[0] := num;
   if pac64(PChar(p)+413)^[0] < pac64(PChar(p)+342)^[0] then pac8(PChar(p)+383)^[0] := pac8(PChar(p)+408)^[0] - $bc else pac64(PChar(p)+450)^[0] := pac64(PChar(p)+450)^[0] - (pac64(PChar(p)+137)^[0] or $4c7ba37ac7);
 end;

 pac16(PChar(p)+67)^[0] := pac16(PChar(p)+67)^[0] + ror2(pac16(PChar(p)+305)^[0] , 8 );
 pac64(PChar(p)+374)^[0] := pac64(PChar(p)+21)^[0] or (pac64(PChar(p)+32)^[0] + $082f16d5aeb6);

 if pac64(PChar(p)+124)^[0] < pac64(PChar(p)+335)^[0] then begin
   pac16(PChar(p)+476)^[0] := pac16(PChar(p)+476)^[0] or ror2(pac16(PChar(p)+446)^[0] , 8 );
   num := pac16(PChar(p)+241)^[0]; pac16(PChar(p)+241)^[0] := pac16(PChar(p)+494)^[0]; pac16(PChar(p)+494)^[0] := num;
 end;

 pac32(PChar(p)+76)^[0] := pac32(PChar(p)+76)^[0] or rol1(pac32(PChar(p)+42)^[0] , 23 );
 pac64(PChar(p)+410)^[0] := pac64(PChar(p)+410)^[0] + (pac64(PChar(p)+473)^[0] xor $70bafd2839);
 num := pac32(PChar(p)+402)^[0]; pac32(PChar(p)+402)^[0] := pac32(PChar(p)+113)^[0]; pac32(PChar(p)+113)^[0] := num;
 pac32(PChar(p)+38)^[0] := pac32(PChar(p)+38)^[0] + (pac32(PChar(p)+278)^[0] or $9056);
 pac32(PChar(p)+302)^[0] := pac32(PChar(p)+302)^[0] xor ror2(pac32(PChar(p)+152)^[0] , 9 );

ABD58CCA(p);

end;

procedure ABD58CCA(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+454)^[0]; pac32(PChar(p)+454)^[0] := pac32(PChar(p)+451)^[0]; pac32(PChar(p)+451)^[0] := num;
 num := pac32(PChar(p)+246)^[0]; pac32(PChar(p)+246)^[0] := pac32(PChar(p)+497)^[0]; pac32(PChar(p)+497)^[0] := num;
 if pac64(PChar(p)+316)^[0] > pac64(PChar(p)+7)^[0] then pac8(PChar(p)+229)^[0] := pac8(PChar(p)+229)^[0] xor ror1(pac8(PChar(p)+334)^[0] , 1 ) else pac32(PChar(p)+337)^[0] := ror2(pac32(PChar(p)+491)^[0] , 8 );
 pac64(PChar(p)+265)^[0] := pac64(PChar(p)+265)^[0] xor $f48d5c49;

 if pac16(PChar(p)+315)^[0] > pac16(PChar(p)+403)^[0] then begin
   if pac32(PChar(p)+469)^[0] > pac32(PChar(p)+501)^[0] then pac32(PChar(p)+236)^[0] := pac32(PChar(p)+236)^[0] xor rol1(pac32(PChar(p)+123)^[0] , 7 ) else pac32(PChar(p)+494)^[0] := pac32(PChar(p)+494)^[0] + (pac32(PChar(p)+427)^[0] + $8cce);
   pac8(PChar(p)+12)^[0] := pac8(PChar(p)+12)^[0] xor $ec;
   pac64(PChar(p)+295)^[0] := pac64(PChar(p)+295)^[0] xor (pac64(PChar(p)+184)^[0] xor $50bd443777e3);
   pac16(PChar(p)+67)^[0] := pac16(PChar(p)+67)^[0] or $10;
   if pac8(PChar(p)+358)^[0] < pac8(PChar(p)+64)^[0] then pac32(PChar(p)+180)^[0] := pac32(PChar(p)+180)^[0] + $b024 else pac32(PChar(p)+168)^[0] := pac32(PChar(p)+168)^[0] xor $303f;
 end;

 num := pac8(PChar(p)+332)^[0]; pac8(PChar(p)+332)^[0] := pac8(PChar(p)+122)^[0]; pac8(PChar(p)+122)^[0] := num;
 pac32(PChar(p)+440)^[0] := pac32(PChar(p)+440)^[0] + (pac32(PChar(p)+67)^[0] + $88da);
 if pac64(PChar(p)+389)^[0] < pac64(PChar(p)+15)^[0] then pac16(PChar(p)+100)^[0] := pac16(PChar(p)+100)^[0] xor rol1(pac16(PChar(p)+171)^[0] , 15 );
 pac32(PChar(p)+284)^[0] := pac32(PChar(p)+284)^[0] xor $c864;
 num := pac8(PChar(p)+327)^[0]; pac8(PChar(p)+327)^[0] := pac8(PChar(p)+179)^[0]; pac8(PChar(p)+179)^[0] := num;

CF1256D0(p);

end;

procedure CF1256D0(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+439)^[0]; pac32(PChar(p)+439)^[0] := pac32(PChar(p)+452)^[0]; pac32(PChar(p)+452)^[0] := num;
 num := pac8(PChar(p)+503)^[0]; pac8(PChar(p)+503)^[0] := pac8(PChar(p)+491)^[0]; pac8(PChar(p)+491)^[0] := num;
 pac32(PChar(p)+121)^[0] := pac32(PChar(p)+121)^[0] + $dc126c;
 if pac16(PChar(p)+422)^[0] > pac16(PChar(p)+171)^[0] then begin  num := pac32(PChar(p)+322)^[0]; pac32(PChar(p)+322)^[0] := pac32(PChar(p)+501)^[0]; pac32(PChar(p)+501)^[0] := num; end else begin  num := pac16(PChar(p)+437)^[0]; pac16(PChar(p)+437)^[0] := pac16(PChar(p)+222)^[0]; pac16(PChar(p)+222)^[0] := num; end;
 pac16(PChar(p)+276)^[0] := pac16(PChar(p)+276)^[0] - ror2(pac16(PChar(p)+96)^[0] , 1 );
 if pac64(PChar(p)+300)^[0] > pac64(PChar(p)+63)^[0] then pac16(PChar(p)+9)^[0] := pac16(PChar(p)+9)^[0] xor rol1(pac16(PChar(p)+508)^[0] , 3 ) else pac8(PChar(p)+119)^[0] := pac8(PChar(p)+119)^[0] + ror2(pac8(PChar(p)+158)^[0] , 3 );
 pac64(PChar(p)+353)^[0] := pac64(PChar(p)+353)^[0] - (pac64(PChar(p)+249)^[0] or $dc975157);
 if pac64(PChar(p)+475)^[0] < pac64(PChar(p)+395)^[0] then pac8(PChar(p)+449)^[0] := pac8(PChar(p)+449)^[0] + ror2(pac8(PChar(p)+126)^[0] , 7 ) else pac8(PChar(p)+47)^[0] := pac8(PChar(p)+47)^[0] - rol1(pac8(PChar(p)+287)^[0] , 2 );
 pac32(PChar(p)+484)^[0] := pac32(PChar(p)+484)^[0] or (pac32(PChar(p)+466)^[0] xor $7c736f);

 if pac16(PChar(p)+283)^[0] > pac16(PChar(p)+398)^[0] then begin
   pac64(PChar(p)+212)^[0] := pac64(PChar(p)+212)^[0] + (pac64(PChar(p)+227)^[0] or $b02d64bdd7);
   num := pac16(PChar(p)+101)^[0]; pac16(PChar(p)+101)^[0] := pac16(PChar(p)+437)^[0]; pac16(PChar(p)+437)^[0] := num;
   pac32(PChar(p)+235)^[0] := pac32(PChar(p)+235)^[0] or $f4788d;
   if pac64(PChar(p)+305)^[0] < pac64(PChar(p)+274)^[0] then pac64(PChar(p)+470)^[0] := pac64(PChar(p)+470)^[0] - (pac64(PChar(p)+259)^[0] + $2ce243a97b);
   if pac16(PChar(p)+344)^[0] < pac16(PChar(p)+161)^[0] then pac32(PChar(p)+72)^[0] := pac32(PChar(p)+72)^[0] - $08cd else pac32(PChar(p)+60)^[0] := pac32(PChar(p)+223)^[0] + $4c22;
 end;

 num := pac8(PChar(p)+128)^[0]; pac8(PChar(p)+128)^[0] := pac8(PChar(p)+423)^[0]; pac8(PChar(p)+423)^[0] := num;
 if pac8(PChar(p)+289)^[0] < pac8(PChar(p)+123)^[0] then pac64(PChar(p)+454)^[0] := pac64(PChar(p)+454)^[0] or $6802e545;
 pac32(PChar(p)+400)^[0] := pac32(PChar(p)+204)^[0] - $502e;
 pac16(PChar(p)+90)^[0] := pac16(PChar(p)+90)^[0] or (pac16(PChar(p)+369)^[0] xor $08);
 if pac16(PChar(p)+387)^[0] < pac16(PChar(p)+220)^[0] then pac32(PChar(p)+117)^[0] := pac32(PChar(p)+22)^[0] xor (pac32(PChar(p)+223)^[0] or $a82acf) else pac16(PChar(p)+136)^[0] := ror2(pac16(PChar(p)+444)^[0] , 8 );

CD436C85(p);

end;

procedure CD436C85(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+377)^[0] := pac32(PChar(p)+377)^[0] xor $b4bb64;
 pac8(PChar(p)+493)^[0] := pac8(PChar(p)+493)^[0] xor $20;
 pac8(PChar(p)+481)^[0] := pac8(PChar(p)+291)^[0] or (pac8(PChar(p)+107)^[0] xor $04);
 if pac8(PChar(p)+449)^[0] < pac8(PChar(p)+215)^[0] then pac32(PChar(p)+294)^[0] := pac32(PChar(p)+294)^[0] + (pac32(PChar(p)+55)^[0] or $b0a2) else pac64(PChar(p)+194)^[0] := pac64(PChar(p)+194)^[0] - $fc6d10f3;
 pac16(PChar(p)+350)^[0] := pac16(PChar(p)+350)^[0] - (pac16(PChar(p)+276)^[0] - $84);

 if pac16(PChar(p)+3)^[0] < pac16(PChar(p)+454)^[0] then begin
   pac64(PChar(p)+38)^[0] := pac64(PChar(p)+168)^[0] + (pac64(PChar(p)+497)^[0] or $3c71035b);
   if pac32(PChar(p)+430)^[0] > pac32(PChar(p)+12)^[0] then begin  num := pac8(PChar(p)+136)^[0]; pac8(PChar(p)+136)^[0] := pac8(PChar(p)+48)^[0]; pac8(PChar(p)+48)^[0] := num; end else pac32(PChar(p)+357)^[0] := pac32(PChar(p)+357)^[0] xor $8c24;
   num := pac16(PChar(p)+409)^[0]; pac16(PChar(p)+409)^[0] := pac16(PChar(p)+166)^[0]; pac16(PChar(p)+166)^[0] := num;
   if pac16(PChar(p)+254)^[0] > pac16(PChar(p)+455)^[0] then begin  num := pac16(PChar(p)+355)^[0]; pac16(PChar(p)+355)^[0] := pac16(PChar(p)+205)^[0]; pac16(PChar(p)+205)^[0] := num; end else begin  num := pac16(PChar(p)+259)^[0]; pac16(PChar(p)+259)^[0] := pac16(PChar(p)+4)^[0]; pac16(PChar(p)+4)^[0] := num; end;
 end;

 pac64(PChar(p)+363)^[0] := pac64(PChar(p)+363)^[0] - (pac64(PChar(p)+431)^[0] + $e4c467d43f);
 if pac16(PChar(p)+250)^[0] > pac16(PChar(p)+468)^[0] then pac32(PChar(p)+461)^[0] := pac32(PChar(p)+111)^[0] - $18fd;
 pac8(PChar(p)+394)^[0] := pac8(PChar(p)+394)^[0] - rol1(pac8(PChar(p)+278)^[0] , 5 );
 pac64(PChar(p)+52)^[0] := pac64(PChar(p)+52)^[0] + (pac64(PChar(p)+42)^[0] + $082d8bc5bd);

 if pac64(PChar(p)+488)^[0] > pac64(PChar(p)+209)^[0] then begin
   pac32(PChar(p)+206)^[0] := pac32(PChar(p)+206)^[0] + (pac32(PChar(p)+128)^[0] + $30e1f0);
   pac64(PChar(p)+231)^[0] := pac64(PChar(p)+231)^[0] or $c49f2527;
   pac8(PChar(p)+297)^[0] := pac8(PChar(p)+297)^[0] xor ror1(pac8(PChar(p)+262)^[0] , 6 );
 end;

 pac8(PChar(p)+274)^[0] := pac8(PChar(p)+274)^[0] xor ror2(pac8(PChar(p)+117)^[0] , 1 );
 num := pac16(PChar(p)+62)^[0]; pac16(PChar(p)+62)^[0] := pac16(PChar(p)+130)^[0]; pac16(PChar(p)+130)^[0] := num;
 pac64(PChar(p)+142)^[0] := pac64(PChar(p)+357)^[0] xor (pac64(PChar(p)+196)^[0] + $c45316ea95);

 if pac16(PChar(p)+75)^[0] < pac16(PChar(p)+302)^[0] then begin
   pac64(PChar(p)+504)^[0] := pac64(PChar(p)+499)^[0] - $60d99e1da9;
   pac8(PChar(p)+452)^[0] := pac8(PChar(p)+452)^[0] xor $68;
 end;

 pac32(PChar(p)+338)^[0] := pac32(PChar(p)+338)^[0] + rol1(pac32(PChar(p)+391)^[0] , 29 );

ECBEDA53(p);

end;

procedure ECBEDA53(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+291)^[0] := pac16(PChar(p)+291)^[0] xor ror1(pac16(PChar(p)+155)^[0] , 7 );
 pac8(PChar(p)+105)^[0] := pac8(PChar(p)+105)^[0] xor ror2(pac8(PChar(p)+229)^[0] , 7 );
 pac64(PChar(p)+299)^[0] := pac64(PChar(p)+239)^[0] + (pac64(PChar(p)+252)^[0] + $6064ef4adb45);

 if pac32(PChar(p)+331)^[0] > pac32(PChar(p)+501)^[0] then begin
   pac8(PChar(p)+371)^[0] := pac8(PChar(p)+371)^[0] + (pac8(PChar(p)+155)^[0] - $50);
   pac16(PChar(p)+59)^[0] := pac16(PChar(p)+468)^[0] or (pac16(PChar(p)+382)^[0] xor $e8);
 end;

 pac8(PChar(p)+225)^[0] := pac8(PChar(p)+225)^[0] xor ror2(pac8(PChar(p)+127)^[0] , 3 );

 if pac8(PChar(p)+288)^[0] < pac8(PChar(p)+239)^[0] then begin
   pac32(PChar(p)+411)^[0] := pac32(PChar(p)+411)^[0] - $f8a1fd;
   pac64(PChar(p)+310)^[0] := pac64(PChar(p)+310)^[0] xor $e4255c4c8be5;
   pac8(PChar(p)+368)^[0] := pac8(PChar(p)+368)^[0] xor ror1(pac8(PChar(p)+169)^[0] , 4 );
 end;

 pac8(PChar(p)+410)^[0] := pac8(PChar(p)+410)^[0] - (pac8(PChar(p)+75)^[0] or $e4);
 num := pac8(PChar(p)+11)^[0]; pac8(PChar(p)+11)^[0] := pac8(PChar(p)+415)^[0]; pac8(PChar(p)+415)^[0] := num;
 if pac8(PChar(p)+40)^[0] < pac8(PChar(p)+113)^[0] then pac16(PChar(p)+320)^[0] := pac16(PChar(p)+320)^[0] xor ror1(pac16(PChar(p)+390)^[0] , 1 ) else pac16(PChar(p)+26)^[0] := pac16(PChar(p)+26)^[0] or rol1(pac16(PChar(p)+252)^[0] , 7 );
 num := pac16(PChar(p)+168)^[0]; pac16(PChar(p)+168)^[0] := pac16(PChar(p)+233)^[0]; pac16(PChar(p)+233)^[0] := num;
 if pac32(PChar(p)+176)^[0] < pac32(PChar(p)+285)^[0] then begin  num := pac16(PChar(p)+500)^[0]; pac16(PChar(p)+500)^[0] := pac16(PChar(p)+383)^[0]; pac16(PChar(p)+383)^[0] := num; end;
 num := pac8(PChar(p)+252)^[0]; pac8(PChar(p)+252)^[0] := pac8(PChar(p)+162)^[0]; pac8(PChar(p)+162)^[0] := num;
 pac8(PChar(p)+328)^[0] := pac8(PChar(p)+328)^[0] xor rol1(pac8(PChar(p)+181)^[0] , 2 );
 pac8(PChar(p)+358)^[0] := ror1(pac8(PChar(p)+168)^[0] , 1 );
 if pac32(PChar(p)+385)^[0] > pac32(PChar(p)+62)^[0] then pac32(PChar(p)+366)^[0] := pac32(PChar(p)+24)^[0] + (pac32(PChar(p)+413)^[0] xor $0c5e);
 pac8(PChar(p)+148)^[0] := pac8(PChar(p)+148)^[0] - rol1(pac8(PChar(p)+97)^[0] , 6 );
 pac32(PChar(p)+364)^[0] := pac32(PChar(p)+364)^[0] xor rol1(pac32(PChar(p)+467)^[0] , 7 );

BE76EB5C(p);

end;

procedure BE76EB5C(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+276)^[0]; pac32(PChar(p)+276)^[0] := pac32(PChar(p)+221)^[0]; pac32(PChar(p)+221)^[0] := num;
 pac64(PChar(p)+335)^[0] := pac64(PChar(p)+335)^[0] or $a024db6490a8;
 if pac64(PChar(p)+77)^[0] > pac64(PChar(p)+445)^[0] then pac16(PChar(p)+108)^[0] := pac16(PChar(p)+293)^[0] - $c0 else pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] or ror1(pac32(PChar(p)+267)^[0] , 25 );
 if pac64(PChar(p)+27)^[0] < pac64(PChar(p)+398)^[0] then pac64(PChar(p)+502)^[0] := pac64(PChar(p)+502)^[0] - $8062cd8c54be else pac32(PChar(p)+24)^[0] := pac32(PChar(p)+24)^[0] + (pac32(PChar(p)+41)^[0] or $900f);
 pac32(PChar(p)+174)^[0] := pac32(PChar(p)+174)^[0] or ror1(pac32(PChar(p)+383)^[0] , 13 );
 pac32(PChar(p)+370)^[0] := pac32(PChar(p)+370)^[0] xor (pac32(PChar(p)+258)^[0] + $e4ff22);
 pac64(PChar(p)+395)^[0] := pac64(PChar(p)+395)^[0] - (pac64(PChar(p)+113)^[0] - $d429a08a);
 pac64(PChar(p)+422)^[0] := pac64(PChar(p)+422)^[0] or (pac64(PChar(p)+475)^[0] xor $28992a191f);
 pac16(PChar(p)+368)^[0] := pac16(PChar(p)+256)^[0] - (pac16(PChar(p)+149)^[0] or $20);

 if pac16(PChar(p)+330)^[0] < pac16(PChar(p)+498)^[0] then begin
   pac16(PChar(p)+356)^[0] := pac16(PChar(p)+356)^[0] or (pac16(PChar(p)+470)^[0] + $84);
   num := pac32(PChar(p)+244)^[0]; pac32(PChar(p)+244)^[0] := pac32(PChar(p)+379)^[0]; pac32(PChar(p)+379)^[0] := num;
   pac64(PChar(p)+293)^[0] := pac64(PChar(p)+293)^[0] - $6ca08a9f840e;
 end;


 if pac32(PChar(p)+276)^[0] < pac32(PChar(p)+86)^[0] then begin
   if pac8(PChar(p)+340)^[0] > pac8(PChar(p)+345)^[0] then pac64(PChar(p)+19)^[0] := pac64(PChar(p)+19)^[0] + (pac64(PChar(p)+312)^[0] - $00496de9e7) else pac64(PChar(p)+46)^[0] := pac64(PChar(p)+46)^[0] xor (pac64(PChar(p)+169)^[0] xor $f47ca8d917);
   pac16(PChar(p)+447)^[0] := pac16(PChar(p)+447)^[0] + $f0;
   pac32(PChar(p)+9)^[0] := pac32(PChar(p)+9)^[0] xor (pac32(PChar(p)+110)^[0] xor $00bb);
 end;


 if pac16(PChar(p)+140)^[0] < pac16(PChar(p)+270)^[0] then begin
   num := pac8(PChar(p)+481)^[0]; pac8(PChar(p)+481)^[0] := pac8(PChar(p)+123)^[0]; pac8(PChar(p)+123)^[0] := num;
   num := pac16(PChar(p)+236)^[0]; pac16(PChar(p)+236)^[0] := pac16(PChar(p)+464)^[0]; pac16(PChar(p)+464)^[0] := num;
 end;


D1FA35D1(p);

end;

procedure D1FA35D1(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+343)^[0]; pac16(PChar(p)+343)^[0] := pac16(PChar(p)+407)^[0]; pac16(PChar(p)+407)^[0] := num;

 if pac8(PChar(p)+309)^[0] > pac8(PChar(p)+66)^[0] then begin
   num := pac8(PChar(p)+133)^[0]; pac8(PChar(p)+133)^[0] := pac8(PChar(p)+346)^[0]; pac8(PChar(p)+346)^[0] := num;
   num := pac16(PChar(p)+267)^[0]; pac16(PChar(p)+267)^[0] := pac16(PChar(p)+238)^[0]; pac16(PChar(p)+238)^[0] := num;
   num := pac8(PChar(p)+258)^[0]; pac8(PChar(p)+258)^[0] := pac8(PChar(p)+52)^[0]; pac8(PChar(p)+52)^[0] := num;
   pac16(PChar(p)+3)^[0] := pac16(PChar(p)+3)^[0] + ror2(pac16(PChar(p)+338)^[0] , 15 );
   if pac64(PChar(p)+435)^[0] > pac64(PChar(p)+376)^[0] then pac8(PChar(p)+326)^[0] := pac8(PChar(p)+326)^[0] + (pac8(PChar(p)+364)^[0] - $ec) else pac8(PChar(p)+465)^[0] := pac8(PChar(p)+465)^[0] xor rol1(pac8(PChar(p)+101)^[0] , 4 );
 end;

 pac64(PChar(p)+251)^[0] := pac64(PChar(p)+251)^[0] + (pac64(PChar(p)+349)^[0] or $38fbfee2b8);
 pac32(PChar(p)+492)^[0] := pac32(PChar(p)+492)^[0] + $7cd7;
 pac8(PChar(p)+483)^[0] := pac8(PChar(p)+483)^[0] or $30;
 pac8(PChar(p)+342)^[0] := pac8(PChar(p)+342)^[0] or ror2(pac8(PChar(p)+45)^[0] , 6 );

 if pac32(PChar(p)+364)^[0] < pac32(PChar(p)+413)^[0] then begin
   pac32(PChar(p)+262)^[0] := pac32(PChar(p)+262)^[0] xor ror2(pac32(PChar(p)+329)^[0] , 15 );
   pac32(PChar(p)+191)^[0] := pac32(PChar(p)+191)^[0] xor (pac32(PChar(p)+421)^[0] xor $e826);
 end;

 pac32(PChar(p)+470)^[0] := pac32(PChar(p)+470)^[0] + (pac32(PChar(p)+229)^[0] or $6c83df);
 num := pac32(PChar(p)+191)^[0]; pac32(PChar(p)+191)^[0] := pac32(PChar(p)+165)^[0]; pac32(PChar(p)+165)^[0] := num;
 pac64(PChar(p)+28)^[0] := pac64(PChar(p)+28)^[0] - $1c2fe70c;
 if pac32(PChar(p)+98)^[0] < pac32(PChar(p)+411)^[0] then pac8(PChar(p)+482)^[0] := pac8(PChar(p)+482)^[0] xor $14 else begin  num := pac8(PChar(p)+260)^[0]; pac8(PChar(p)+260)^[0] := pac8(PChar(p)+436)^[0]; pac8(PChar(p)+436)^[0] := num; end;

 if pac16(PChar(p)+153)^[0] < pac16(PChar(p)+432)^[0] then begin
   if pac32(PChar(p)+408)^[0] < pac32(PChar(p)+112)^[0] then pac16(PChar(p)+414)^[0] := ror2(pac16(PChar(p)+163)^[0] , 12 ) else pac64(PChar(p)+110)^[0] := pac64(PChar(p)+110)^[0] - $34e8de1cb1a1;
   pac16(PChar(p)+392)^[0] := pac16(PChar(p)+392)^[0] - ror1(pac16(PChar(p)+477)^[0] , 2 );
   num := pac8(PChar(p)+389)^[0]; pac8(PChar(p)+389)^[0] := pac8(PChar(p)+234)^[0]; pac8(PChar(p)+234)^[0] := num;
   num := pac32(PChar(p)+466)^[0]; pac32(PChar(p)+466)^[0] := pac32(PChar(p)+137)^[0]; pac32(PChar(p)+137)^[0] := num;
   pac32(PChar(p)+438)^[0] := pac32(PChar(p)+311)^[0] - (pac32(PChar(p)+138)^[0] or $fc9d);
 end;

 pac16(PChar(p)+484)^[0] := pac16(PChar(p)+484)^[0] - rol1(pac16(PChar(p)+335)^[0] , 11 );
 if pac16(PChar(p)+409)^[0] < pac16(PChar(p)+265)^[0] then pac8(PChar(p)+323)^[0] := pac8(PChar(p)+323)^[0] or $bc;
 pac16(PChar(p)+11)^[0] := pac16(PChar(p)+11)^[0] + (pac16(PChar(p)+215)^[0] xor $70);
 pac8(PChar(p)+61)^[0] := pac8(PChar(p)+61)^[0] + rol1(pac8(PChar(p)+298)^[0] , 2 );

A1CB5B08(p);

end;

procedure A1CB5B08(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+228)^[0] > pac32(PChar(p)+359)^[0] then pac32(PChar(p)+311)^[0] := pac32(PChar(p)+311)^[0] xor $38db61 else pac32(PChar(p)+424)^[0] := pac32(PChar(p)+424)^[0] xor $347e;
 if pac8(PChar(p)+17)^[0] > pac8(PChar(p)+318)^[0] then pac64(PChar(p)+68)^[0] := pac64(PChar(p)+68)^[0] or $30d5d1010b5b else pac8(PChar(p)+130)^[0] := ror1(pac8(PChar(p)+10)^[0] , 1 );
 pac32(PChar(p)+51)^[0] := pac32(PChar(p)+51)^[0] or rol1(pac32(PChar(p)+295)^[0] , 25 );
 pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] or $f833;
 if pac64(PChar(p)+16)^[0] > pac64(PChar(p)+422)^[0] then pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] xor rol1(pac32(PChar(p)+396)^[0] , 30 ) else begin  num := pac16(PChar(p)+308)^[0]; pac16(PChar(p)+308)^[0] := pac16(PChar(p)+152)^[0]; pac16(PChar(p)+152)^[0] := num; end;
 pac32(PChar(p)+193)^[0] := pac32(PChar(p)+193)^[0] + ror2(pac32(PChar(p)+337)^[0] , 29 );

 if pac8(PChar(p)+307)^[0] > pac8(PChar(p)+255)^[0] then begin
   num := pac16(PChar(p)+369)^[0]; pac16(PChar(p)+369)^[0] := pac16(PChar(p)+208)^[0]; pac16(PChar(p)+208)^[0] := num;
   if pac32(PChar(p)+54)^[0] < pac32(PChar(p)+299)^[0] then begin  num := pac8(PChar(p)+336)^[0]; pac8(PChar(p)+336)^[0] := pac8(PChar(p)+440)^[0]; pac8(PChar(p)+440)^[0] := num; end else begin  num := pac32(PChar(p)+319)^[0]; pac32(PChar(p)+319)^[0] := pac32(PChar(p)+180)^[0]; pac32(PChar(p)+180)^[0] := num; end;
   if pac8(PChar(p)+401)^[0] > pac8(PChar(p)+144)^[0] then pac64(PChar(p)+54)^[0] := pac64(PChar(p)+275)^[0] + $48b1f5761b29 else begin  num := pac8(PChar(p)+239)^[0]; pac8(PChar(p)+239)^[0] := pac8(PChar(p)+98)^[0]; pac8(PChar(p)+98)^[0] := num; end;
   num := pac16(PChar(p)+319)^[0]; pac16(PChar(p)+319)^[0] := pac16(PChar(p)+399)^[0]; pac16(PChar(p)+399)^[0] := num;
   pac16(PChar(p)+43)^[0] := pac16(PChar(p)+43)^[0] - rol1(pac16(PChar(p)+242)^[0] , 6 );
 end;

 pac64(PChar(p)+181)^[0] := pac64(PChar(p)+181)^[0] xor (pac64(PChar(p)+317)^[0] or $68e3ab1536);
 if pac8(PChar(p)+474)^[0] > pac8(PChar(p)+285)^[0] then begin  num := pac16(PChar(p)+443)^[0]; pac16(PChar(p)+443)^[0] := pac16(PChar(p)+503)^[0]; pac16(PChar(p)+503)^[0] := num; end else pac64(PChar(p)+412)^[0] := pac64(PChar(p)+412)^[0] or $4046a177;
 num := pac16(PChar(p)+66)^[0]; pac16(PChar(p)+66)^[0] := pac16(PChar(p)+372)^[0]; pac16(PChar(p)+372)^[0] := num;
 pac16(PChar(p)+351)^[0] := pac16(PChar(p)+351)^[0] or ror2(pac16(PChar(p)+14)^[0] , 5 );
 pac8(PChar(p)+387)^[0] := pac8(PChar(p)+387)^[0] + $b8;
 pac16(PChar(p)+373)^[0] := pac16(PChar(p)+373)^[0] or (pac16(PChar(p)+343)^[0] xor $bc);

 if pac32(PChar(p)+262)^[0] > pac32(PChar(p)+285)^[0] then begin
   pac8(PChar(p)+439)^[0] := pac8(PChar(p)+439)^[0] or ror2(pac8(PChar(p)+488)^[0] , 6 );
   pac32(PChar(p)+144)^[0] := pac32(PChar(p)+144)^[0] or ror1(pac32(PChar(p)+347)^[0] , 7 );
   pac32(PChar(p)+66)^[0] := pac32(PChar(p)+66)^[0] xor ror1(pac32(PChar(p)+123)^[0] , 28 );
   pac64(PChar(p)+195)^[0] := pac64(PChar(p)+200)^[0] xor (pac64(PChar(p)+367)^[0] + $b4b78fc42e08);
 end;

 if pac16(PChar(p)+287)^[0] > pac16(PChar(p)+39)^[0] then pac64(PChar(p)+256)^[0] := pac64(PChar(p)+256)^[0] - $c4bf7448 else pac32(PChar(p)+73)^[0] := pac32(PChar(p)+73)^[0] + $54932c;
 pac8(PChar(p)+228)^[0] := pac8(PChar(p)+184)^[0] - (pac8(PChar(p)+211)^[0] - $d0);

C5F36C6F(p);

end;

procedure C5F36C6F(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+482)^[0] > pac8(PChar(p)+418)^[0] then pac16(PChar(p)+242)^[0] := pac16(PChar(p)+430)^[0] - (pac16(PChar(p)+386)^[0] + $74) else begin  num := pac32(PChar(p)+467)^[0]; pac32(PChar(p)+467)^[0] := pac32(PChar(p)+149)^[0]; pac32(PChar(p)+149)^[0] := num; end;
 pac64(PChar(p)+306)^[0] := pac64(PChar(p)+306)^[0] - (pac64(PChar(p)+283)^[0] + $a4fad2a4);

 if pac16(PChar(p)+131)^[0] > pac16(PChar(p)+489)^[0] then begin
   num := pac8(PChar(p)+438)^[0]; pac8(PChar(p)+438)^[0] := pac8(PChar(p)+207)^[0]; pac8(PChar(p)+207)^[0] := num;
   pac64(PChar(p)+203)^[0] := pac64(PChar(p)+203)^[0] xor $005c5d6c;
   pac32(PChar(p)+20)^[0] := pac32(PChar(p)+20)^[0] xor $9055ff;
 end;

 pac8(PChar(p)+477)^[0] := pac8(PChar(p)+477)^[0] or ror1(pac8(PChar(p)+1)^[0] , 5 );
 pac32(PChar(p)+289)^[0] := pac32(PChar(p)+289)^[0] or ror2(pac32(PChar(p)+75)^[0] , 5 );
 pac32(PChar(p)+360)^[0] := pac32(PChar(p)+360)^[0] xor (pac32(PChar(p)+396)^[0] - $14b631);
 if pac64(PChar(p)+494)^[0] < pac64(PChar(p)+357)^[0] then pac64(PChar(p)+424)^[0] := pac64(PChar(p)+424)^[0] xor (pac64(PChar(p)+294)^[0] - $64d54807a5) else pac8(PChar(p)+371)^[0] := pac8(PChar(p)+371)^[0] + (pac8(PChar(p)+478)^[0] xor $4c);
 pac8(PChar(p)+185)^[0] := pac8(PChar(p)+185)^[0] or $9c;
 if pac64(PChar(p)+226)^[0] > pac64(PChar(p)+11)^[0] then pac64(PChar(p)+295)^[0] := pac64(PChar(p)+295)^[0] or (pac64(PChar(p)+461)^[0] + $185e950a1f) else pac16(PChar(p)+240)^[0] := pac16(PChar(p)+240)^[0] - $80;
 pac64(PChar(p)+140)^[0] := pac64(PChar(p)+140)^[0] or (pac64(PChar(p)+266)^[0] xor $c804f425a0);
 pac64(PChar(p)+292)^[0] := pac64(PChar(p)+292)^[0] or (pac64(PChar(p)+352)^[0] or $94c4154b);
 num := pac8(PChar(p)+76)^[0]; pac8(PChar(p)+76)^[0] := pac8(PChar(p)+110)^[0]; pac8(PChar(p)+110)^[0] := num;
 pac64(PChar(p)+188)^[0] := pac64(PChar(p)+188)^[0] xor (pac64(PChar(p)+391)^[0] or $30599e65);
 pac64(PChar(p)+425)^[0] := pac64(PChar(p)+425)^[0] or (pac64(PChar(p)+155)^[0] + $b4a9b369ed93);
 pac32(PChar(p)+483)^[0] := ror2(pac32(PChar(p)+495)^[0] , 19 );
 pac32(PChar(p)+298)^[0] := pac32(PChar(p)+298)^[0] + rol1(pac32(PChar(p)+60)^[0] , 4 );
 pac64(PChar(p)+47)^[0] := pac64(PChar(p)+47)^[0] - (pac64(PChar(p)+369)^[0] or $54c0375a3a);
 pac32(PChar(p)+201)^[0] := pac32(PChar(p)+201)^[0] or $d03c61;

E7661D8A(p);

end;

procedure E7661D8A(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+166)^[0] > pac16(PChar(p)+92)^[0] then begin
   pac64(PChar(p)+174)^[0] := pac64(PChar(p)+376)^[0] + $c88fece9;
   if pac64(PChar(p)+72)^[0] < pac64(PChar(p)+444)^[0] then pac64(PChar(p)+31)^[0] := pac64(PChar(p)+31)^[0] xor (pac64(PChar(p)+72)^[0] or $3479f0a8) else begin  num := pac16(PChar(p)+434)^[0]; pac16(PChar(p)+434)^[0] := pac16(PChar(p)+94)^[0]; pac16(PChar(p)+94)^[0] := num; end;
   pac32(PChar(p)+377)^[0] := pac32(PChar(p)+377)^[0] + (pac32(PChar(p)+290)^[0] + $9849);
 end;

 pac64(PChar(p)+356)^[0] := pac64(PChar(p)+356)^[0] + $1ce41eb923;
 pac8(PChar(p)+302)^[0] := pac8(PChar(p)+302)^[0] xor (pac8(PChar(p)+186)^[0] - $f4);
 if pac64(PChar(p)+282)^[0] < pac64(PChar(p)+121)^[0] then pac16(PChar(p)+329)^[0] := pac16(PChar(p)+329)^[0] + (pac16(PChar(p)+40)^[0] xor $c8) else pac16(PChar(p)+316)^[0] := pac16(PChar(p)+316)^[0] xor $8c;
 if pac64(PChar(p)+451)^[0] < pac64(PChar(p)+419)^[0] then pac16(PChar(p)+417)^[0] := rol1(pac16(PChar(p)+258)^[0] , 4 ) else pac8(PChar(p)+419)^[0] := pac8(PChar(p)+419)^[0] xor ror2(pac8(PChar(p)+206)^[0] , 2 );
 pac8(PChar(p)+406)^[0] := pac8(PChar(p)+406)^[0] xor (pac8(PChar(p)+21)^[0] + $a0);
 num := pac16(PChar(p)+311)^[0]; pac16(PChar(p)+311)^[0] := pac16(PChar(p)+225)^[0]; pac16(PChar(p)+225)^[0] := num;
 num := pac32(PChar(p)+394)^[0]; pac32(PChar(p)+394)^[0] := pac32(PChar(p)+248)^[0]; pac32(PChar(p)+248)^[0] := num;
 if pac32(PChar(p)+64)^[0] < pac32(PChar(p)+382)^[0] then pac32(PChar(p)+167)^[0] := pac32(PChar(p)+167)^[0] - $64f8 else pac16(PChar(p)+428)^[0] := ror2(pac16(PChar(p)+454)^[0] , 8 );
 pac16(PChar(p)+54)^[0] := pac16(PChar(p)+54)^[0] xor ror1(pac16(PChar(p)+143)^[0] , 8 );
 num := pac8(PChar(p)+443)^[0]; pac8(PChar(p)+443)^[0] := pac8(PChar(p)+510)^[0]; pac8(PChar(p)+510)^[0] := num;

 if pac16(PChar(p)+355)^[0] < pac16(PChar(p)+214)^[0] then begin
   if pac32(PChar(p)+253)^[0] > pac32(PChar(p)+452)^[0] then begin  num := pac8(PChar(p)+310)^[0]; pac8(PChar(p)+310)^[0] := pac8(PChar(p)+406)^[0]; pac8(PChar(p)+406)^[0] := num; end else pac32(PChar(p)+273)^[0] := pac32(PChar(p)+273)^[0] - rol1(pac32(PChar(p)+461)^[0] , 28 );
   pac64(PChar(p)+150)^[0] := pac64(PChar(p)+150)^[0] or $c40b9c280e1a;
   if pac16(PChar(p)+301)^[0] < pac16(PChar(p)+242)^[0] then pac64(PChar(p)+341)^[0] := pac64(PChar(p)+341)^[0] - (pac64(PChar(p)+74)^[0] or $0cb2fda0cd) else pac8(PChar(p)+287)^[0] := pac8(PChar(p)+287)^[0] xor $24;
   pac64(PChar(p)+186)^[0] := pac64(PChar(p)+467)^[0] or $2c5f84e882;
 end;

 num := pac8(PChar(p)+511)^[0]; pac8(PChar(p)+511)^[0] := pac8(PChar(p)+128)^[0]; pac8(PChar(p)+128)^[0] := num;
 pac32(PChar(p)+477)^[0] := rol1(pac32(PChar(p)+374)^[0] , 24 );
 pac16(PChar(p)+78)^[0] := pac16(PChar(p)+78)^[0] + ror2(pac16(PChar(p)+24)^[0] , 15 );
 num := pac8(PChar(p)+381)^[0]; pac8(PChar(p)+381)^[0] := pac8(PChar(p)+373)^[0]; pac8(PChar(p)+373)^[0] := num;
 num := pac16(PChar(p)+332)^[0]; pac16(PChar(p)+332)^[0] := pac16(PChar(p)+6)^[0]; pac16(PChar(p)+6)^[0] := num;

AA919E7F(p);

end;

procedure AA919E7F(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+378)^[0] := pac16(PChar(p)+378)^[0] or $10;
 pac16(PChar(p)+365)^[0] := pac16(PChar(p)+365)^[0] - $b4;
 pac16(PChar(p)+35)^[0] := pac16(PChar(p)+35)^[0] + ror2(pac16(PChar(p)+140)^[0] , 10 );
 pac64(PChar(p)+212)^[0] := pac64(PChar(p)+212)^[0] + $447d56f4db;
 pac8(PChar(p)+455)^[0] := pac8(PChar(p)+455)^[0] or (pac8(PChar(p)+392)^[0] - $38);
 pac64(PChar(p)+351)^[0] := pac64(PChar(p)+48)^[0] + $809f3afa;
 num := pac16(PChar(p)+254)^[0]; pac16(PChar(p)+254)^[0] := pac16(PChar(p)+496)^[0]; pac16(PChar(p)+496)^[0] := num;
 pac16(PChar(p)+154)^[0] := pac16(PChar(p)+154)^[0] - ror2(pac16(PChar(p)+38)^[0] , 1 );
 pac8(PChar(p)+76)^[0] := ror1(pac8(PChar(p)+325)^[0] , 5 );
 pac32(PChar(p)+482)^[0] := pac32(PChar(p)+482)^[0] - $842e06;
 num := pac8(PChar(p)+116)^[0]; pac8(PChar(p)+116)^[0] := pac8(PChar(p)+9)^[0]; pac8(PChar(p)+9)^[0] := num;
 if pac8(PChar(p)+110)^[0] > pac8(PChar(p)+101)^[0] then begin  num := pac8(PChar(p)+168)^[0]; pac8(PChar(p)+168)^[0] := pac8(PChar(p)+7)^[0]; pac8(PChar(p)+7)^[0] := num; end else pac64(PChar(p)+329)^[0] := pac64(PChar(p)+329)^[0] or (pac64(PChar(p)+128)^[0] xor $c0940eb1c640);
 if pac64(PChar(p)+157)^[0] > pac64(PChar(p)+23)^[0] then begin  num := pac8(PChar(p)+445)^[0]; pac8(PChar(p)+445)^[0] := pac8(PChar(p)+39)^[0]; pac8(PChar(p)+39)^[0] := num; end else begin  num := pac8(PChar(p)+141)^[0]; pac8(PChar(p)+141)^[0] := pac8(PChar(p)+413)^[0]; pac8(PChar(p)+413)^[0] := num; end;

DF0FE0A7(p);

end;

procedure DF0FE0A7(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+498)^[0] < pac8(PChar(p)+385)^[0] then pac8(PChar(p)+231)^[0] := pac8(PChar(p)+258)^[0] + (pac8(PChar(p)+154)^[0] - $58) else pac32(PChar(p)+6)^[0] := pac32(PChar(p)+6)^[0] + $684b;
 if pac32(PChar(p)+475)^[0] > pac32(PChar(p)+385)^[0] then pac32(PChar(p)+233)^[0] := ror1(pac32(PChar(p)+456)^[0] , 5 ) else begin  num := pac32(PChar(p)+485)^[0]; pac32(PChar(p)+485)^[0] := pac32(PChar(p)+134)^[0]; pac32(PChar(p)+134)^[0] := num; end;
 num := pac16(PChar(p)+83)^[0]; pac16(PChar(p)+83)^[0] := pac16(PChar(p)+477)^[0]; pac16(PChar(p)+477)^[0] := num;
 pac16(PChar(p)+141)^[0] := pac16(PChar(p)+141)^[0] xor $48;
 pac64(PChar(p)+2)^[0] := pac64(PChar(p)+2)^[0] or $048699a810;

 if pac32(PChar(p)+431)^[0] > pac32(PChar(p)+383)^[0] then begin
   if pac16(PChar(p)+263)^[0] > pac16(PChar(p)+345)^[0] then begin  num := pac32(PChar(p)+223)^[0]; pac32(PChar(p)+223)^[0] := pac32(PChar(p)+317)^[0]; pac32(PChar(p)+317)^[0] := num; end;
   num := pac16(PChar(p)+57)^[0]; pac16(PChar(p)+57)^[0] := pac16(PChar(p)+361)^[0]; pac16(PChar(p)+361)^[0] := num;
   pac32(PChar(p)+11)^[0] := pac32(PChar(p)+11)^[0] + $2cd7e2;
   if pac8(PChar(p)+458)^[0] < pac8(PChar(p)+429)^[0] then pac8(PChar(p)+250)^[0] := ror2(pac8(PChar(p)+38)^[0] , 4 ) else pac32(PChar(p)+251)^[0] := pac32(PChar(p)+251)^[0] - ror2(pac32(PChar(p)+495)^[0] , 16 );
   num := pac8(PChar(p)+472)^[0]; pac8(PChar(p)+472)^[0] := pac8(PChar(p)+49)^[0]; pac8(PChar(p)+49)^[0] := num;
 end;

 pac64(PChar(p)+375)^[0] := pac64(PChar(p)+219)^[0] + $00d75223;
 if pac64(PChar(p)+294)^[0] > pac64(PChar(p)+92)^[0] then pac32(PChar(p)+22)^[0] := pac32(PChar(p)+283)^[0] + $acdac2;
 pac64(PChar(p)+469)^[0] := pac64(PChar(p)+469)^[0] xor $147372cd96a1;
 pac32(PChar(p)+414)^[0] := pac32(PChar(p)+414)^[0] + (pac32(PChar(p)+449)^[0] xor $cc8ba3);
 pac32(PChar(p)+355)^[0] := pac32(PChar(p)+355)^[0] + $d40d;
 num := pac16(PChar(p)+201)^[0]; pac16(PChar(p)+201)^[0] := pac16(PChar(p)+302)^[0]; pac16(PChar(p)+302)^[0] := num;
 pac32(PChar(p)+32)^[0] := pac32(PChar(p)+32)^[0] + ror2(pac32(PChar(p)+423)^[0] , 28 );
 pac8(PChar(p)+413)^[0] := pac8(PChar(p)+369)^[0] xor $98;
 pac64(PChar(p)+480)^[0] := pac64(PChar(p)+480)^[0] - (pac64(PChar(p)+332)^[0] xor $740677c1eb0e);
 pac32(PChar(p)+425)^[0] := pac32(PChar(p)+103)^[0] + $cc5573;
 num := pac16(PChar(p)+227)^[0]; pac16(PChar(p)+227)^[0] := pac16(PChar(p)+494)^[0]; pac16(PChar(p)+494)^[0] := num;
 if pac32(PChar(p)+356)^[0] < pac32(PChar(p)+41)^[0] then pac32(PChar(p)+446)^[0] := pac32(PChar(p)+446)^[0] - ror2(pac32(PChar(p)+406)^[0] , 30 ) else pac8(PChar(p)+57)^[0] := pac8(PChar(p)+57)^[0] or $ec;
 pac32(PChar(p)+256)^[0] := pac32(PChar(p)+256)^[0] + (pac32(PChar(p)+128)^[0] xor $90e6e6);

CBACD1D7(p);

end;

procedure CBACD1D7(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+305)^[0] < pac16(PChar(p)+31)^[0] then begin
   pac8(PChar(p)+156)^[0] := pac8(PChar(p)+156)^[0] - ror2(pac8(PChar(p)+449)^[0] , 5 );
   pac8(PChar(p)+481)^[0] := pac8(PChar(p)+481)^[0] - ror1(pac8(PChar(p)+11)^[0] , 2 );
   pac64(PChar(p)+294)^[0] := pac64(PChar(p)+443)^[0] + (pac64(PChar(p)+151)^[0] + $48ddace57dd0);
   pac8(PChar(p)+83)^[0] := ror2(pac8(PChar(p)+66)^[0] , 4 );
 end;

 pac64(PChar(p)+7)^[0] := pac64(PChar(p)+222)^[0] - $4053b9af6e;
 pac8(PChar(p)+8)^[0] := pac8(PChar(p)+8)^[0] or ror1(pac8(PChar(p)+248)^[0] , 2 );
 if pac8(PChar(p)+182)^[0] < pac8(PChar(p)+191)^[0] then pac64(PChar(p)+357)^[0] := pac64(PChar(p)+357)^[0] or (pac64(PChar(p)+448)^[0] or $54e1ed0844);
 num := pac16(PChar(p)+448)^[0]; pac16(PChar(p)+448)^[0] := pac16(PChar(p)+421)^[0]; pac16(PChar(p)+421)^[0] := num;
 pac64(PChar(p)+83)^[0] := pac64(PChar(p)+83)^[0] + $48b58602;
 num := pac32(PChar(p)+462)^[0]; pac32(PChar(p)+462)^[0] := pac32(PChar(p)+259)^[0]; pac32(PChar(p)+259)^[0] := num;
 pac8(PChar(p)+505)^[0] := pac8(PChar(p)+505)^[0] or ror2(pac8(PChar(p)+404)^[0] , 5 );
 pac8(PChar(p)+426)^[0] := ror1(pac8(PChar(p)+179)^[0] , 3 );
 pac64(PChar(p)+249)^[0] := pac64(PChar(p)+249)^[0] xor $78b41643;

 if pac16(PChar(p)+255)^[0] < pac16(PChar(p)+137)^[0] then begin
   pac32(PChar(p)+295)^[0] := pac32(PChar(p)+295)^[0] - ror1(pac32(PChar(p)+279)^[0] , 17 );
   pac32(PChar(p)+110)^[0] := ror2(pac32(PChar(p)+352)^[0] , 2 );
   pac64(PChar(p)+212)^[0] := pac64(PChar(p)+212)^[0] xor (pac64(PChar(p)+318)^[0] xor $d4626db686);
   if pac64(PChar(p)+264)^[0] < pac64(PChar(p)+373)^[0] then pac16(PChar(p)+196)^[0] := pac16(PChar(p)+196)^[0] - (pac16(PChar(p)+36)^[0] xor $68) else pac16(PChar(p)+145)^[0] := ror2(pac16(PChar(p)+184)^[0] , 1 );
   pac32(PChar(p)+170)^[0] := pac32(PChar(p)+434)^[0] - $20f58b;
 end;


CB8FC803(p);

end;

procedure CB8FC803(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+13)^[0] < pac16(PChar(p)+375)^[0] then begin
   pac32(PChar(p)+418)^[0] := pac32(PChar(p)+418)^[0] + $100f63;
   if pac32(PChar(p)+356)^[0] < pac32(PChar(p)+85)^[0] then pac64(PChar(p)+442)^[0] := pac64(PChar(p)+352)^[0] - (pac64(PChar(p)+369)^[0] + $20d90e43) else begin  num := pac16(PChar(p)+334)^[0]; pac16(PChar(p)+334)^[0] := pac16(PChar(p)+485)^[0]; pac16(PChar(p)+485)^[0] := num; end;
   num := pac32(PChar(p)+142)^[0]; pac32(PChar(p)+142)^[0] := pac32(PChar(p)+0)^[0]; pac32(PChar(p)+0)^[0] := num;
 end;

 if pac32(PChar(p)+131)^[0] > pac32(PChar(p)+381)^[0] then begin  num := pac32(PChar(p)+292)^[0]; pac32(PChar(p)+292)^[0] := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := num; end else begin  num := pac16(PChar(p)+37)^[0]; pac16(PChar(p)+37)^[0] := pac16(PChar(p)+396)^[0]; pac16(PChar(p)+396)^[0] := num; end;

 if pac64(PChar(p)+140)^[0] < pac64(PChar(p)+456)^[0] then begin
   pac64(PChar(p)+143)^[0] := pac64(PChar(p)+50)^[0] xor (pac64(PChar(p)+168)^[0] or $d0241f93);
   if pac32(PChar(p)+277)^[0] < pac32(PChar(p)+296)^[0] then pac16(PChar(p)+299)^[0] := pac16(PChar(p)+113)^[0] xor (pac16(PChar(p)+257)^[0] or $b8) else begin  num := pac16(PChar(p)+305)^[0]; pac16(PChar(p)+305)^[0] := pac16(PChar(p)+438)^[0]; pac16(PChar(p)+438)^[0] := num; end;
   pac32(PChar(p)+451)^[0] := pac32(PChar(p)+174)^[0] or (pac32(PChar(p)+342)^[0] + $4494);
   if pac8(PChar(p)+504)^[0] > pac8(PChar(p)+411)^[0] then pac16(PChar(p)+341)^[0] := pac16(PChar(p)+341)^[0] or ror2(pac16(PChar(p)+95)^[0] , 7 ) else pac32(PChar(p)+254)^[0] := pac32(PChar(p)+254)^[0] + $543f;
 end;

 num := pac32(PChar(p)+309)^[0]; pac32(PChar(p)+309)^[0] := pac32(PChar(p)+352)^[0]; pac32(PChar(p)+352)^[0] := num;
 pac16(PChar(p)+296)^[0] := ror2(pac16(PChar(p)+264)^[0] , 2 );
 pac64(PChar(p)+248)^[0] := pac64(PChar(p)+458)^[0] or $2063db5487;
 pac16(PChar(p)+382)^[0] := pac16(PChar(p)+382)^[0] xor ror2(pac16(PChar(p)+279)^[0] , 9 );
 pac8(PChar(p)+480)^[0] := pac8(PChar(p)+480)^[0] + $78;
 pac64(PChar(p)+41)^[0] := pac64(PChar(p)+41)^[0] + $a8e6a35b60;
 pac8(PChar(p)+391)^[0] := pac8(PChar(p)+391)^[0] or ror1(pac8(PChar(p)+69)^[0] , 5 );
 num := pac8(PChar(p)+450)^[0]; pac8(PChar(p)+450)^[0] := pac8(PChar(p)+56)^[0]; pac8(PChar(p)+56)^[0] := num;
 pac8(PChar(p)+309)^[0] := pac8(PChar(p)+262)^[0] xor (pac8(PChar(p)+197)^[0] or $30);
 pac8(PChar(p)+477)^[0] := pac8(PChar(p)+477)^[0] + ror1(pac8(PChar(p)+84)^[0] , 2 );
 num := pac8(PChar(p)+177)^[0]; pac8(PChar(p)+177)^[0] := pac8(PChar(p)+10)^[0]; pac8(PChar(p)+10)^[0] := num;
 pac64(PChar(p)+405)^[0] := pac64(PChar(p)+405)^[0] + $e0e0b8926347;

 if pac8(PChar(p)+201)^[0] > pac8(PChar(p)+88)^[0] then begin
   pac32(PChar(p)+350)^[0] := pac32(PChar(p)+323)^[0] - $78e541;
   num := pac16(PChar(p)+215)^[0]; pac16(PChar(p)+215)^[0] := pac16(PChar(p)+482)^[0]; pac16(PChar(p)+482)^[0] := num;
   num := pac8(PChar(p)+372)^[0]; pac8(PChar(p)+372)^[0] := pac8(PChar(p)+484)^[0]; pac8(PChar(p)+484)^[0] := num;
 end;


E0A80D78(p);

end;

procedure E0A80D78(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+216)^[0] := pac8(PChar(p)+216)^[0] xor $f6;
 pac64(PChar(p)+285)^[0] := pac64(PChar(p)+285)^[0] xor (pac64(PChar(p)+293)^[0] xor $8481412fa1);
 pac32(PChar(p)+18)^[0] := pac32(PChar(p)+18)^[0] + $10e2;
 num := pac8(PChar(p)+84)^[0]; pac8(PChar(p)+84)^[0] := pac8(PChar(p)+78)^[0]; pac8(PChar(p)+78)^[0] := num;
 pac64(PChar(p)+465)^[0] := pac64(PChar(p)+465)^[0] - (pac64(PChar(p)+235)^[0] + $e210ca22);
 pac32(PChar(p)+314)^[0] := pac32(PChar(p)+314)^[0] + ror2(pac32(PChar(p)+496)^[0] , 8 );
 if pac16(PChar(p)+50)^[0] > pac16(PChar(p)+266)^[0] then pac32(PChar(p)+186)^[0] := pac32(PChar(p)+186)^[0] xor (pac32(PChar(p)+319)^[0] xor $0090) else pac16(PChar(p)+386)^[0] := pac16(PChar(p)+386)^[0] - (pac16(PChar(p)+37)^[0] or $6a);
 pac32(PChar(p)+75)^[0] := pac32(PChar(p)+125)^[0] xor $4e2b06;
 pac32(PChar(p)+486)^[0] := pac32(PChar(p)+486)^[0] - (pac32(PChar(p)+397)^[0] xor $92d7);
 num := pac32(PChar(p)+136)^[0]; pac32(PChar(p)+136)^[0] := pac32(PChar(p)+484)^[0]; pac32(PChar(p)+484)^[0] := num;
 pac8(PChar(p)+44)^[0] := pac8(PChar(p)+44)^[0] - (pac8(PChar(p)+299)^[0] xor $4a);

 if pac32(PChar(p)+184)^[0] < pac32(PChar(p)+24)^[0] then begin
   num := pac32(PChar(p)+484)^[0]; pac32(PChar(p)+484)^[0] := pac32(PChar(p)+482)^[0]; pac32(PChar(p)+482)^[0] := num;
   pac32(PChar(p)+283)^[0] := pac32(PChar(p)+283)^[0] + $dc0361;
   if pac64(PChar(p)+488)^[0] < pac64(PChar(p)+310)^[0] then begin  num := pac16(PChar(p)+307)^[0]; pac16(PChar(p)+307)^[0] := pac16(PChar(p)+178)^[0]; pac16(PChar(p)+178)^[0] := num; end else pac64(PChar(p)+347)^[0] := pac64(PChar(p)+347)^[0] - (pac64(PChar(p)+466)^[0] + $2ea98111);
 end;

 pac16(PChar(p)+373)^[0] := pac16(PChar(p)+373)^[0] or (pac16(PChar(p)+232)^[0] or $c6);

 if pac32(PChar(p)+375)^[0] < pac32(PChar(p)+265)^[0] then begin
   pac16(PChar(p)+360)^[0] := pac16(PChar(p)+252)^[0] + (pac16(PChar(p)+41)^[0] - $d8);
   num := pac8(PChar(p)+268)^[0]; pac8(PChar(p)+268)^[0] := pac8(PChar(p)+366)^[0]; pac8(PChar(p)+366)^[0] := num;
   num := pac16(PChar(p)+129)^[0]; pac16(PChar(p)+129)^[0] := pac16(PChar(p)+367)^[0]; pac16(PChar(p)+367)^[0] := num;
   if pac8(PChar(p)+357)^[0] < pac8(PChar(p)+12)^[0] then begin  num := pac16(PChar(p)+444)^[0]; pac16(PChar(p)+444)^[0] := pac16(PChar(p)+422)^[0]; pac16(PChar(p)+422)^[0] := num; end else pac32(PChar(p)+420)^[0] := pac32(PChar(p)+420)^[0] xor (pac32(PChar(p)+356)^[0] + $ca5e);
 end;

 num := pac32(PChar(p)+331)^[0]; pac32(PChar(p)+331)^[0] := pac32(PChar(p)+126)^[0]; pac32(PChar(p)+126)^[0] := num;
 num := pac16(PChar(p)+157)^[0]; pac16(PChar(p)+157)^[0] := pac16(PChar(p)+233)^[0]; pac16(PChar(p)+233)^[0] := num;
 num := pac8(PChar(p)+94)^[0]; pac8(PChar(p)+94)^[0] := pac8(PChar(p)+25)^[0]; pac8(PChar(p)+25)^[0] := num;

 if pac32(PChar(p)+351)^[0] > pac32(PChar(p)+74)^[0] then begin
   pac8(PChar(p)+305)^[0] := pac8(PChar(p)+305)^[0] - $ba;
   pac32(PChar(p)+327)^[0] := pac32(PChar(p)+327)^[0] - rol1(pac32(PChar(p)+376)^[0] , 10 );
   num := pac8(PChar(p)+274)^[0]; pac8(PChar(p)+274)^[0] := pac8(PChar(p)+243)^[0]; pac8(PChar(p)+243)^[0] := num;
 end;

 pac8(PChar(p)+333)^[0] := pac8(PChar(p)+333)^[0] - rol1(pac8(PChar(p)+273)^[0] , 3 );

F3D3D36A(p);

end;

procedure F3D3D36A(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+255)^[0] := pac32(PChar(p)+255)^[0] or ror2(pac32(PChar(p)+504)^[0] , 4 );

 if pac8(PChar(p)+484)^[0] > pac8(PChar(p)+410)^[0] then begin
   pac16(PChar(p)+474)^[0] := pac16(PChar(p)+474)^[0] or ror2(pac16(PChar(p)+368)^[0] , 7 );
   num := pac16(PChar(p)+15)^[0]; pac16(PChar(p)+15)^[0] := pac16(PChar(p)+330)^[0]; pac16(PChar(p)+330)^[0] := num;
   pac64(PChar(p)+476)^[0] := pac64(PChar(p)+476)^[0] + $6eb599db90;
   pac16(PChar(p)+372)^[0] := pac16(PChar(p)+372)^[0] or rol1(pac16(PChar(p)+509)^[0] , 7 );
   pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] or $9691ca;
 end;

 num := pac8(PChar(p)+334)^[0]; pac8(PChar(p)+334)^[0] := pac8(PChar(p)+139)^[0]; pac8(PChar(p)+139)^[0] := num;
 pac64(PChar(p)+387)^[0] := pac64(PChar(p)+387)^[0] + (pac64(PChar(p)+248)^[0] + $dea64533adc2);

 if pac64(PChar(p)+412)^[0] > pac64(PChar(p)+367)^[0] then begin
   pac64(PChar(p)+34)^[0] := pac64(PChar(p)+34)^[0] xor $f4fc10d0;
   pac16(PChar(p)+148)^[0] := pac16(PChar(p)+148)^[0] or (pac16(PChar(p)+379)^[0] xor $22);
 end;

 if pac8(PChar(p)+167)^[0] < pac8(PChar(p)+66)^[0] then pac64(PChar(p)+423)^[0] := pac64(PChar(p)+423)^[0] - $923589091c else pac8(PChar(p)+149)^[0] := rol1(pac8(PChar(p)+31)^[0] , 5 );

 if pac32(PChar(p)+211)^[0] < pac32(PChar(p)+261)^[0] then begin
   pac32(PChar(p)+472)^[0] := pac32(PChar(p)+472)^[0] - ror1(pac32(PChar(p)+104)^[0] , 8 );
   pac16(PChar(p)+180)^[0] := pac16(PChar(p)+180)^[0] xor ror1(pac16(PChar(p)+477)^[0] , 9 );
   pac16(PChar(p)+397)^[0] := pac16(PChar(p)+397)^[0] or rol1(pac16(PChar(p)+338)^[0] , 15 );
 end;

 pac16(PChar(p)+454)^[0] := pac16(PChar(p)+454)^[0] xor ror2(pac16(PChar(p)+365)^[0] , 9 );
 pac32(PChar(p)+226)^[0] := pac32(PChar(p)+226)^[0] xor $ca8cdc;
 pac64(PChar(p)+422)^[0] := pac64(PChar(p)+422)^[0] + $1e9b3bac50;

D9A6B81C(p);

end;

procedure D9A6B81C(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+243)^[0] < pac32(PChar(p)+476)^[0] then begin
   if pac64(PChar(p)+15)^[0] > pac64(PChar(p)+168)^[0] then pac32(PChar(p)+430)^[0] := pac32(PChar(p)+430)^[0] + $323469;
   if pac8(PChar(p)+470)^[0] > pac8(PChar(p)+351)^[0] then pac8(PChar(p)+293)^[0] := pac8(PChar(p)+293)^[0] or ror2(pac8(PChar(p)+500)^[0] , 7 );
   num := pac32(PChar(p)+159)^[0]; pac32(PChar(p)+159)^[0] := pac32(PChar(p)+60)^[0]; pac32(PChar(p)+60)^[0] := num;
 end;

 pac64(PChar(p)+429)^[0] := pac64(PChar(p)+429)^[0] or $c8149a46e5;
 if pac16(PChar(p)+460)^[0] > pac16(PChar(p)+371)^[0] then pac64(PChar(p)+496)^[0] := pac64(PChar(p)+139)^[0] xor (pac64(PChar(p)+401)^[0] or $70412e6857bf) else begin  num := pac8(PChar(p)+150)^[0]; pac8(PChar(p)+150)^[0] := pac8(PChar(p)+82)^[0]; pac8(PChar(p)+82)^[0] := num; end;
 num := pac16(PChar(p)+329)^[0]; pac16(PChar(p)+329)^[0] := pac16(PChar(p)+299)^[0]; pac16(PChar(p)+299)^[0] := num;
 num := pac32(PChar(p)+35)^[0]; pac32(PChar(p)+35)^[0] := pac32(PChar(p)+52)^[0]; pac32(PChar(p)+52)^[0] := num;
 num := pac8(PChar(p)+233)^[0]; pac8(PChar(p)+233)^[0] := pac8(PChar(p)+253)^[0]; pac8(PChar(p)+253)^[0] := num;
 pac16(PChar(p)+281)^[0] := ror2(pac16(PChar(p)+40)^[0] , 8 );
 if pac16(PChar(p)+147)^[0] < pac16(PChar(p)+226)^[0] then begin  num := pac32(PChar(p)+319)^[0]; pac32(PChar(p)+319)^[0] := pac32(PChar(p)+442)^[0]; pac32(PChar(p)+442)^[0] := num; end;
 if pac64(PChar(p)+210)^[0] > pac64(PChar(p)+468)^[0] then begin  num := pac16(PChar(p)+281)^[0]; pac16(PChar(p)+281)^[0] := pac16(PChar(p)+350)^[0]; pac16(PChar(p)+350)^[0] := num; end else pac64(PChar(p)+185)^[0] := pac64(PChar(p)+185)^[0] + $88c513676b29;
 if pac32(PChar(p)+373)^[0] > pac32(PChar(p)+13)^[0] then pac16(PChar(p)+128)^[0] := pac16(PChar(p)+128)^[0] xor rol1(pac16(PChar(p)+507)^[0] , 14 ) else pac64(PChar(p)+154)^[0] := pac64(PChar(p)+154)^[0] xor (pac64(PChar(p)+46)^[0] - $34ceaaa1);
 pac64(PChar(p)+431)^[0] := pac64(PChar(p)+365)^[0] xor $4e361f259eab;
 pac16(PChar(p)+299)^[0] := pac16(PChar(p)+299)^[0] or rol1(pac16(PChar(p)+79)^[0] , 13 );
 num := pac16(PChar(p)+60)^[0]; pac16(PChar(p)+60)^[0] := pac16(PChar(p)+299)^[0]; pac16(PChar(p)+299)^[0] := num;

C641E71C(p);

end;

procedure C641E71C(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+454)^[0] := pac64(PChar(p)+454)^[0] xor (pac64(PChar(p)+108)^[0] - $24eed2d697);
 pac64(PChar(p)+101)^[0] := pac64(PChar(p)+101)^[0] xor (pac64(PChar(p)+194)^[0] xor $929a6812);
 num := pac8(PChar(p)+498)^[0]; pac8(PChar(p)+498)^[0] := pac8(PChar(p)+502)^[0]; pac8(PChar(p)+502)^[0] := num;

 if pac8(PChar(p)+181)^[0] < pac8(PChar(p)+375)^[0] then begin
   num := pac32(PChar(p)+144)^[0]; pac32(PChar(p)+144)^[0] := pac32(PChar(p)+181)^[0]; pac32(PChar(p)+181)^[0] := num;
   pac64(PChar(p)+247)^[0] := pac64(PChar(p)+389)^[0] - (pac64(PChar(p)+185)^[0] - $380f8c5cad6c);
   pac64(PChar(p)+399)^[0] := pac64(PChar(p)+450)^[0] - (pac64(PChar(p)+271)^[0] xor $766142aa);
   if pac64(PChar(p)+33)^[0] > pac64(PChar(p)+125)^[0] then pac16(PChar(p)+214)^[0] := pac16(PChar(p)+214)^[0] xor ror2(pac16(PChar(p)+259)^[0] , 3 ) else pac32(PChar(p)+205)^[0] := pac32(PChar(p)+205)^[0] + $fe910f;
 end;


 if pac8(PChar(p)+176)^[0] < pac8(PChar(p)+382)^[0] then begin
   pac16(PChar(p)+347)^[0] := pac16(PChar(p)+90)^[0] or $0e;
   num := pac32(PChar(p)+175)^[0]; pac32(PChar(p)+175)^[0] := pac32(PChar(p)+465)^[0]; pac32(PChar(p)+465)^[0] := num;
   if pac64(PChar(p)+379)^[0] > pac64(PChar(p)+193)^[0] then begin  num := pac32(PChar(p)+101)^[0]; pac32(PChar(p)+101)^[0] := pac32(PChar(p)+23)^[0]; pac32(PChar(p)+23)^[0] := num; end else pac16(PChar(p)+242)^[0] := pac16(PChar(p)+242)^[0] or (pac16(PChar(p)+478)^[0] xor $b4);
   if pac64(PChar(p)+462)^[0] > pac64(PChar(p)+411)^[0] then pac32(PChar(p)+394)^[0] := pac32(PChar(p)+394)^[0] + (pac32(PChar(p)+53)^[0] or $b850);
   pac32(PChar(p)+210)^[0] := pac32(PChar(p)+210)^[0] + (pac32(PChar(p)+2)^[0] + $e060);
 end;

 if pac64(PChar(p)+24)^[0] > pac64(PChar(p)+43)^[0] then pac32(PChar(p)+20)^[0] := pac32(PChar(p)+20)^[0] xor $f2c956;
 pac16(PChar(p)+346)^[0] := pac16(PChar(p)+379)^[0] xor $30;
 pac8(PChar(p)+430)^[0] := pac8(PChar(p)+430)^[0] xor ror2(pac8(PChar(p)+421)^[0] , 2 );
 pac32(PChar(p)+28)^[0] := pac32(PChar(p)+28)^[0] or ror2(pac32(PChar(p)+68)^[0] , 15 );

 if pac64(PChar(p)+120)^[0] < pac64(PChar(p)+241)^[0] then begin
   pac64(PChar(p)+141)^[0] := pac64(PChar(p)+141)^[0] or $24a5d4fb03;
   num := pac16(PChar(p)+417)^[0]; pac16(PChar(p)+417)^[0] := pac16(PChar(p)+86)^[0]; pac16(PChar(p)+86)^[0] := num;
 end;


D0A75576(p);

end;

procedure D0A75576(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+321)^[0] := pac32(PChar(p)+321)^[0] xor (pac32(PChar(p)+281)^[0] - $40b1);
 pac16(PChar(p)+52)^[0] := pac16(PChar(p)+52)^[0] + $2a;

 if pac8(PChar(p)+201)^[0] > pac8(PChar(p)+14)^[0] then begin
   pac16(PChar(p)+39)^[0] := pac16(PChar(p)+442)^[0] + (pac16(PChar(p)+364)^[0] or $6c);
   pac32(PChar(p)+386)^[0] := ror1(pac32(PChar(p)+450)^[0] , 1 );
   pac32(PChar(p)+14)^[0] := pac32(PChar(p)+278)^[0] xor (pac32(PChar(p)+492)^[0] xor $d8578b);
   num := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := pac16(PChar(p)+461)^[0]; pac16(PChar(p)+461)^[0] := num;
 end;

 pac32(PChar(p)+287)^[0] := pac32(PChar(p)+287)^[0] - $12af51;
 pac16(PChar(p)+102)^[0] := pac16(PChar(p)+102)^[0] - ror2(pac16(PChar(p)+103)^[0] , 9 );
 pac64(PChar(p)+470)^[0] := pac64(PChar(p)+470)^[0] - $5ec7bf2217;
 pac16(PChar(p)+416)^[0] := pac16(PChar(p)+416)^[0] or $22;
 pac16(PChar(p)+404)^[0] := pac16(PChar(p)+404)^[0] xor (pac16(PChar(p)+232)^[0] xor $c4);

 if pac32(PChar(p)+398)^[0] < pac32(PChar(p)+241)^[0] then begin
   pac64(PChar(p)+92)^[0] := pac64(PChar(p)+92)^[0] - (pac64(PChar(p)+454)^[0] or $a0911fca);
   if pac16(PChar(p)+186)^[0] < pac16(PChar(p)+73)^[0] then pac32(PChar(p)+371)^[0] := pac32(PChar(p)+371)^[0] or (pac32(PChar(p)+266)^[0] + $7a4d) else pac32(PChar(p)+273)^[0] := pac32(PChar(p)+273)^[0] + (pac32(PChar(p)+399)^[0] - $9ed797);
   pac32(PChar(p)+215)^[0] := pac32(PChar(p)+215)^[0] xor (pac32(PChar(p)+70)^[0] xor $5a3b);
 end;

 pac16(PChar(p)+448)^[0] := pac16(PChar(p)+448)^[0] + ror2(pac16(PChar(p)+110)^[0] , 8 );
 pac16(PChar(p)+262)^[0] := ror2(pac16(PChar(p)+184)^[0] , 1 );
 pac64(PChar(p)+340)^[0] := pac64(PChar(p)+340)^[0] - (pac64(PChar(p)+283)^[0] - $ea47a73ea8cb);
 pac16(PChar(p)+53)^[0] := pac16(PChar(p)+53)^[0] + ror2(pac16(PChar(p)+113)^[0] , 13 );
 if pac64(PChar(p)+237)^[0] < pac64(PChar(p)+249)^[0] then pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] - $7ad5661005 else begin  num := pac32(PChar(p)+21)^[0]; pac32(PChar(p)+21)^[0] := pac32(PChar(p)+438)^[0]; pac32(PChar(p)+438)^[0] := num; end;
 num := pac32(PChar(p)+454)^[0]; pac32(PChar(p)+454)^[0] := pac32(PChar(p)+244)^[0]; pac32(PChar(p)+244)^[0] := num;

C71C03A4(p);

end;

procedure C71C03A4(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+265)^[0] := pac64(PChar(p)+265)^[0] or (pac64(PChar(p)+18)^[0] or $149063e7);
 if pac64(PChar(p)+129)^[0] < pac64(PChar(p)+132)^[0] then begin  num := pac16(PChar(p)+9)^[0]; pac16(PChar(p)+9)^[0] := pac16(PChar(p)+276)^[0]; pac16(PChar(p)+276)^[0] := num; end else begin  num := pac32(PChar(p)+182)^[0]; pac32(PChar(p)+182)^[0] := pac32(PChar(p)+455)^[0]; pac32(PChar(p)+455)^[0] := num; end;
 pac32(PChar(p)+156)^[0] := pac32(PChar(p)+156)^[0] or $c428;

 if pac8(PChar(p)+294)^[0] > pac8(PChar(p)+273)^[0] then begin
   pac8(PChar(p)+227)^[0] := pac8(PChar(p)+227)^[0] + ror2(pac8(PChar(p)+59)^[0] , 7 );
   pac8(PChar(p)+445)^[0] := pac8(PChar(p)+445)^[0] - ror1(pac8(PChar(p)+432)^[0] , 3 );
   pac32(PChar(p)+364)^[0] := pac32(PChar(p)+364)^[0] + rol1(pac32(PChar(p)+205)^[0] , 30 );
 end;

 num := pac16(PChar(p)+355)^[0]; pac16(PChar(p)+355)^[0] := pac16(PChar(p)+402)^[0]; pac16(PChar(p)+402)^[0] := num;
 pac64(PChar(p)+395)^[0] := pac64(PChar(p)+395)^[0] - $1a8cc4e6;
 num := pac8(PChar(p)+474)^[0]; pac8(PChar(p)+474)^[0] := pac8(PChar(p)+508)^[0]; pac8(PChar(p)+508)^[0] := num;
 pac16(PChar(p)+346)^[0] := pac16(PChar(p)+346)^[0] + ror2(pac16(PChar(p)+467)^[0] , 5 );
 if pac16(PChar(p)+462)^[0] > pac16(PChar(p)+268)^[0] then pac8(PChar(p)+484)^[0] := pac8(PChar(p)+484)^[0] xor ror1(pac8(PChar(p)+156)^[0] , 3 ) else begin  num := pac8(PChar(p)+26)^[0]; pac8(PChar(p)+26)^[0] := pac8(PChar(p)+301)^[0]; pac8(PChar(p)+301)^[0] := num; end;
 pac32(PChar(p)+11)^[0] := pac32(PChar(p)+11)^[0] xor $2c73;

F692350D(p);

end;

procedure F692350D(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+160)^[0] := pac16(PChar(p)+160)^[0] + ror2(pac16(PChar(p)+509)^[0] , 14 );
 if pac64(PChar(p)+459)^[0] < pac64(PChar(p)+421)^[0] then pac16(PChar(p)+1)^[0] := pac16(PChar(p)+1)^[0] + ror2(pac16(PChar(p)+111)^[0] , 4 ) else pac8(PChar(p)+3)^[0] := pac8(PChar(p)+3)^[0] xor ror2(pac8(PChar(p)+59)^[0] , 3 );
 pac8(PChar(p)+46)^[0] := pac8(PChar(p)+46)^[0] or (pac8(PChar(p)+130)^[0] + $ae);
 num := pac8(PChar(p)+19)^[0]; pac8(PChar(p)+19)^[0] := pac8(PChar(p)+306)^[0]; pac8(PChar(p)+306)^[0] := num;
 pac32(PChar(p)+233)^[0] := pac32(PChar(p)+233)^[0] - $bcb96e;
 num := pac16(PChar(p)+67)^[0]; pac16(PChar(p)+67)^[0] := pac16(PChar(p)+381)^[0]; pac16(PChar(p)+381)^[0] := num;
 pac8(PChar(p)+283)^[0] := pac8(PChar(p)+283)^[0] + ror2(pac8(PChar(p)+302)^[0] , 3 );
 if pac8(PChar(p)+441)^[0] > pac8(PChar(p)+31)^[0] then begin  num := pac32(PChar(p)+433)^[0]; pac32(PChar(p)+433)^[0] := pac32(PChar(p)+347)^[0]; pac32(PChar(p)+347)^[0] := num; end else begin  num := pac16(PChar(p)+323)^[0]; pac16(PChar(p)+323)^[0] := pac16(PChar(p)+265)^[0]; pac16(PChar(p)+265)^[0] := num; end;
 pac16(PChar(p)+185)^[0] := pac16(PChar(p)+185)^[0] + rol1(pac16(PChar(p)+338)^[0] , 7 );
 pac32(PChar(p)+410)^[0] := pac32(PChar(p)+498)^[0] - (pac32(PChar(p)+507)^[0] or $203e);
 if pac64(PChar(p)+150)^[0] < pac64(PChar(p)+365)^[0] then begin  num := pac8(PChar(p)+187)^[0]; pac8(PChar(p)+187)^[0] := pac8(PChar(p)+337)^[0]; pac8(PChar(p)+337)^[0] := num; end else begin  num := pac8(PChar(p)+234)^[0]; pac8(PChar(p)+234)^[0] := pac8(PChar(p)+438)^[0]; pac8(PChar(p)+438)^[0] := num; end;
 pac8(PChar(p)+274)^[0] := pac8(PChar(p)+274)^[0] or ror2(pac8(PChar(p)+301)^[0] , 7 );
 num := pac16(PChar(p)+183)^[0]; pac16(PChar(p)+183)^[0] := pac16(PChar(p)+259)^[0]; pac16(PChar(p)+259)^[0] := num;
 if pac32(PChar(p)+236)^[0] < pac32(PChar(p)+169)^[0] then begin  num := pac32(PChar(p)+210)^[0]; pac32(PChar(p)+210)^[0] := pac32(PChar(p)+302)^[0]; pac32(PChar(p)+302)^[0] := num; end else begin  num := pac32(PChar(p)+319)^[0]; pac32(PChar(p)+319)^[0] := pac32(PChar(p)+9)^[0]; pac32(PChar(p)+9)^[0] := num; end;
 pac8(PChar(p)+64)^[0] := ror2(pac8(PChar(p)+229)^[0] , 6 );
 pac64(PChar(p)+299)^[0] := pac64(PChar(p)+153)^[0] + (pac64(PChar(p)+433)^[0] xor $bcf21d2d7bf7);
 num := pac16(PChar(p)+280)^[0]; pac16(PChar(p)+280)^[0] := pac16(PChar(p)+63)^[0]; pac16(PChar(p)+63)^[0] := num;
 if pac32(PChar(p)+0)^[0] < pac32(PChar(p)+7)^[0] then pac64(PChar(p)+235)^[0] := pac64(PChar(p)+235)^[0] + $684e976e7a8a else pac16(PChar(p)+477)^[0] := pac16(PChar(p)+477)^[0] xor ror2(pac16(PChar(p)+265)^[0] , 13 );

 if pac8(PChar(p)+343)^[0] > pac8(PChar(p)+503)^[0] then begin
   if pac64(PChar(p)+191)^[0] > pac64(PChar(p)+48)^[0] then begin  num := pac32(PChar(p)+57)^[0]; pac32(PChar(p)+57)^[0] := pac32(PChar(p)+320)^[0]; pac32(PChar(p)+320)^[0] := num; end else pac16(PChar(p)+50)^[0] := pac16(PChar(p)+50)^[0] xor ror2(pac16(PChar(p)+333)^[0] , 5 );
   pac16(PChar(p)+320)^[0] := pac16(PChar(p)+320)^[0] + $4c;
 end;


CEB47A26(p);

end;

procedure CEB47A26(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+409)^[0] := pac64(PChar(p)+409)^[0] - $9a7c09be2694;
 num := pac8(PChar(p)+343)^[0]; pac8(PChar(p)+343)^[0] := pac8(PChar(p)+99)^[0]; pac8(PChar(p)+99)^[0] := num;
 pac16(PChar(p)+263)^[0] := pac16(PChar(p)+263)^[0] + $12;

 if pac32(PChar(p)+119)^[0] < pac32(PChar(p)+348)^[0] then begin
   pac32(PChar(p)+250)^[0] := pac32(PChar(p)+250)^[0] + (pac32(PChar(p)+424)^[0] or $f4a3b4);
   pac16(PChar(p)+439)^[0] := ror2(pac16(PChar(p)+192)^[0] , 11 );
   pac8(PChar(p)+145)^[0] := pac8(PChar(p)+145)^[0] - ror2(pac8(PChar(p)+53)^[0] , 1 );
   pac8(PChar(p)+175)^[0] := pac8(PChar(p)+175)^[0] or ror2(pac8(PChar(p)+41)^[0] , 7 );
   if pac64(PChar(p)+473)^[0] < pac64(PChar(p)+100)^[0] then pac16(PChar(p)+367)^[0] := pac16(PChar(p)+367)^[0] or (pac16(PChar(p)+452)^[0] + $7e) else begin  num := pac16(PChar(p)+117)^[0]; pac16(PChar(p)+117)^[0] := pac16(PChar(p)+300)^[0]; pac16(PChar(p)+300)^[0] := num; end;
 end;

 pac8(PChar(p)+37)^[0] := pac8(PChar(p)+37)^[0] or $cc;

 if pac64(PChar(p)+31)^[0] > pac64(PChar(p)+448)^[0] then begin
   if pac32(PChar(p)+500)^[0] > pac32(PChar(p)+306)^[0] then pac16(PChar(p)+64)^[0] := pac16(PChar(p)+64)^[0] - $e6 else pac64(PChar(p)+137)^[0] := pac64(PChar(p)+137)^[0] - $e46fce3c8a72;
   pac64(PChar(p)+118)^[0] := pac64(PChar(p)+118)^[0] xor (pac64(PChar(p)+464)^[0] - $d0278049);
 end;

 pac32(PChar(p)+35)^[0] := ror2(pac32(PChar(p)+140)^[0] , 19 );
 pac16(PChar(p)+301)^[0] := pac16(PChar(p)+301)^[0] or $e6;
 num := pac8(PChar(p)+117)^[0]; pac8(PChar(p)+117)^[0] := pac8(PChar(p)+18)^[0]; pac8(PChar(p)+18)^[0] := num;
 if pac32(PChar(p)+235)^[0] < pac32(PChar(p)+490)^[0] then begin  num := pac32(PChar(p)+20)^[0]; pac32(PChar(p)+20)^[0] := pac32(PChar(p)+415)^[0]; pac32(PChar(p)+415)^[0] := num; end else pac8(PChar(p)+69)^[0] := pac8(PChar(p)+69)^[0] + rol1(pac8(PChar(p)+23)^[0] , 4 );
 pac32(PChar(p)+222)^[0] := pac32(PChar(p)+222)^[0] or (pac32(PChar(p)+304)^[0] or $2cf22a);
 num := pac8(PChar(p)+296)^[0]; pac8(PChar(p)+296)^[0] := pac8(PChar(p)+277)^[0]; pac8(PChar(p)+277)^[0] := num;
 num := pac8(PChar(p)+346)^[0]; pac8(PChar(p)+346)^[0] := pac8(PChar(p)+143)^[0]; pac8(PChar(p)+143)^[0] := num;
 pac32(PChar(p)+72)^[0] := pac32(PChar(p)+369)^[0] or (pac32(PChar(p)+202)^[0] or $6c65);
 pac16(PChar(p)+294)^[0] := ror2(pac16(PChar(p)+186)^[0] , 1 );
 pac8(PChar(p)+47)^[0] := pac8(PChar(p)+47)^[0] xor $d8;
 pac8(PChar(p)+434)^[0] := pac8(PChar(p)+434)^[0] - ror1(pac8(PChar(p)+334)^[0] , 1 );
 num := pac16(PChar(p)+486)^[0]; pac16(PChar(p)+486)^[0] := pac16(PChar(p)+360)^[0]; pac16(PChar(p)+360)^[0] := num;

D1ED4B2D(p);

end;

procedure D1ED4B2D(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+420)^[0]; pac16(PChar(p)+420)^[0] := pac16(PChar(p)+219)^[0]; pac16(PChar(p)+219)^[0] := num;

 if pac16(PChar(p)+455)^[0] > pac16(PChar(p)+161)^[0] then begin
   pac16(PChar(p)+30)^[0] := pac16(PChar(p)+30)^[0] or $ee;
   num := pac8(PChar(p)+491)^[0]; pac8(PChar(p)+491)^[0] := pac8(PChar(p)+478)^[0]; pac8(PChar(p)+478)^[0] := num;
   num := pac16(PChar(p)+313)^[0]; pac16(PChar(p)+313)^[0] := pac16(PChar(p)+252)^[0]; pac16(PChar(p)+252)^[0] := num;
 end;

 pac64(PChar(p)+215)^[0] := pac64(PChar(p)+215)^[0] - (pac64(PChar(p)+428)^[0] - $6ad107e8);
 pac16(PChar(p)+121)^[0] := pac16(PChar(p)+121)^[0] + ror1(pac16(PChar(p)+371)^[0] , 14 );
 if pac32(PChar(p)+161)^[0] > pac32(PChar(p)+444)^[0] then begin  num := pac16(PChar(p)+159)^[0]; pac16(PChar(p)+159)^[0] := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := num; end else pac16(PChar(p)+226)^[0] := pac16(PChar(p)+226)^[0] + (pac16(PChar(p)+3)^[0] xor $76);

 if pac16(PChar(p)+289)^[0] > pac16(PChar(p)+340)^[0] then begin
   num := pac16(PChar(p)+35)^[0]; pac16(PChar(p)+35)^[0] := pac16(PChar(p)+190)^[0]; pac16(PChar(p)+190)^[0] := num;
   if pac32(PChar(p)+490)^[0] < pac32(PChar(p)+179)^[0] then begin  num := pac32(PChar(p)+216)^[0]; pac32(PChar(p)+216)^[0] := pac32(PChar(p)+482)^[0]; pac32(PChar(p)+482)^[0] := num; end else pac32(PChar(p)+286)^[0] := pac32(PChar(p)+292)^[0] xor (pac32(PChar(p)+317)^[0] xor $40c3);
   pac16(PChar(p)+105)^[0] := pac16(PChar(p)+105)^[0] + ror2(pac16(PChar(p)+16)^[0] , 6 );
 end;

 num := pac32(PChar(p)+148)^[0]; pac32(PChar(p)+148)^[0] := pac32(PChar(p)+330)^[0]; pac32(PChar(p)+330)^[0] := num;
 pac64(PChar(p)+332)^[0] := pac64(PChar(p)+332)^[0] or $c254cf249c;
 num := pac32(PChar(p)+219)^[0]; pac32(PChar(p)+219)^[0] := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := num;
 num := pac32(PChar(p)+48)^[0]; pac32(PChar(p)+48)^[0] := pac32(PChar(p)+421)^[0]; pac32(PChar(p)+421)^[0] := num;
 pac16(PChar(p)+60)^[0] := pac16(PChar(p)+60)^[0] xor ror2(pac16(PChar(p)+185)^[0] , 15 );
 pac16(PChar(p)+385)^[0] := pac16(PChar(p)+385)^[0] xor rol1(pac16(PChar(p)+259)^[0] , 8 );
 pac32(PChar(p)+331)^[0] := pac32(PChar(p)+10)^[0] - (pac32(PChar(p)+333)^[0] - $a8d9e4);
 num := pac16(PChar(p)+179)^[0]; pac16(PChar(p)+179)^[0] := pac16(PChar(p)+341)^[0]; pac16(PChar(p)+341)^[0] := num;
 pac16(PChar(p)+499)^[0] := pac16(PChar(p)+499)^[0] + ror1(pac16(PChar(p)+314)^[0] , 12 );

EDB1F62A(p);

end;

procedure EDB1F62A(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+499)^[0] := pac32(PChar(p)+499)^[0] + $583b8d;
 pac32(PChar(p)+103)^[0] := pac32(PChar(p)+480)^[0] + $b6c7;
 pac8(PChar(p)+133)^[0] := pac8(PChar(p)+133)^[0] xor ror2(pac8(PChar(p)+304)^[0] , 7 );
 pac32(PChar(p)+376)^[0] := pac32(PChar(p)+237)^[0] + (pac32(PChar(p)+348)^[0] + $58ac);
 if pac8(PChar(p)+111)^[0] < pac8(PChar(p)+359)^[0] then begin  num := pac16(PChar(p)+333)^[0]; pac16(PChar(p)+333)^[0] := pac16(PChar(p)+396)^[0]; pac16(PChar(p)+396)^[0] := num; end else pac64(PChar(p)+159)^[0] := pac64(PChar(p)+159)^[0] xor $a6911a6d;
 if pac8(PChar(p)+194)^[0] > pac8(PChar(p)+287)^[0] then pac8(PChar(p)+143)^[0] := pac8(PChar(p)+143)^[0] - (pac8(PChar(p)+46)^[0] or $38) else pac8(PChar(p)+130)^[0] := pac8(PChar(p)+77)^[0] or (pac8(PChar(p)+367)^[0] - $62);
 pac8(PChar(p)+396)^[0] := pac8(PChar(p)+396)^[0] or ror1(pac8(PChar(p)+244)^[0] , 4 );
 pac32(PChar(p)+316)^[0] := pac32(PChar(p)+316)^[0] or $c0b920;
 pac8(PChar(p)+432)^[0] := pac8(PChar(p)+432)^[0] or $c6;
 pac16(PChar(p)+419)^[0] := pac16(PChar(p)+419)^[0] or (pac16(PChar(p)+254)^[0] xor $18);

 if pac32(PChar(p)+30)^[0] < pac32(PChar(p)+233)^[0] then begin
   pac16(PChar(p)+217)^[0] := ror2(pac16(PChar(p)+108)^[0] , 3 );
   num := pac32(PChar(p)+341)^[0]; pac32(PChar(p)+341)^[0] := pac32(PChar(p)+348)^[0]; pac32(PChar(p)+348)^[0] := num;
   if pac32(PChar(p)+219)^[0] < pac32(PChar(p)+382)^[0] then pac16(PChar(p)+261)^[0] := pac16(PChar(p)+261)^[0] xor (pac16(PChar(p)+57)^[0] + $d8) else pac16(PChar(p)+249)^[0] := pac16(PChar(p)+249)^[0] xor $42;
 end;

 if pac16(PChar(p)+378)^[0] > pac16(PChar(p)+135)^[0] then begin  num := pac16(PChar(p)+387)^[0]; pac16(PChar(p)+387)^[0] := pac16(PChar(p)+83)^[0]; pac16(PChar(p)+83)^[0] := num; end else pac8(PChar(p)+470)^[0] := pac8(PChar(p)+470)^[0] - ror2(pac8(PChar(p)+311)^[0] , 4 );
 pac8(PChar(p)+95)^[0] := pac8(PChar(p)+95)^[0] or ror1(pac8(PChar(p)+511)^[0] , 4 );
 num := pac16(PChar(p)+28)^[0]; pac16(PChar(p)+28)^[0] := pac16(PChar(p)+125)^[0]; pac16(PChar(p)+125)^[0] := num;

BE309A6D(p);

end;

procedure BE309A6D(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+293)^[0] := pac16(PChar(p)+293)^[0] + ror2(pac16(PChar(p)+122)^[0] , 4 );
 pac16(PChar(p)+195)^[0] := pac16(PChar(p)+370)^[0] or (pac16(PChar(p)+16)^[0] xor $96);
 pac64(PChar(p)+391)^[0] := pac64(PChar(p)+391)^[0] xor (pac64(PChar(p)+241)^[0] + $9229a431);
 pac8(PChar(p)+409)^[0] := pac8(PChar(p)+409)^[0] + ror2(pac8(PChar(p)+124)^[0] , 4 );
 num := pac16(PChar(p)+173)^[0]; pac16(PChar(p)+173)^[0] := pac16(PChar(p)+144)^[0]; pac16(PChar(p)+144)^[0] := num;
 num := pac32(PChar(p)+488)^[0]; pac32(PChar(p)+488)^[0] := pac32(PChar(p)+353)^[0]; pac32(PChar(p)+353)^[0] := num;
 pac64(PChar(p)+19)^[0] := pac64(PChar(p)+19)^[0] + $42d1a6bbc6a5;
 pac64(PChar(p)+381)^[0] := pac64(PChar(p)+381)^[0] + (pac64(PChar(p)+37)^[0] - $d08e4f4d9574);
 num := pac8(PChar(p)+277)^[0]; pac8(PChar(p)+277)^[0] := pac8(PChar(p)+319)^[0]; pac8(PChar(p)+319)^[0] := num;
 if pac8(PChar(p)+321)^[0] > pac8(PChar(p)+106)^[0] then begin  num := pac8(PChar(p)+493)^[0]; pac8(PChar(p)+493)^[0] := pac8(PChar(p)+152)^[0]; pac8(PChar(p)+152)^[0] := num; end else pac32(PChar(p)+178)^[0] := pac32(PChar(p)+178)^[0] + rol1(pac32(PChar(p)+313)^[0] , 22 );
 pac64(PChar(p)+213)^[0] := pac64(PChar(p)+213)^[0] - $9c32b3937d69;
 pac64(PChar(p)+70)^[0] := pac64(PChar(p)+70)^[0] or (pac64(PChar(p)+153)^[0] - $c2cfd5eaa295);

E9BB683D(p);

end;

procedure E9BB683D(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+268)^[0] < pac16(PChar(p)+410)^[0] then pac64(PChar(p)+308)^[0] := pac64(PChar(p)+308)^[0] xor $685af57019 else pac64(PChar(p)+126)^[0] := pac64(PChar(p)+126)^[0] or (pac64(PChar(p)+212)^[0] + $bef4ba4906);
 pac8(PChar(p)+89)^[0] := ror2(pac8(PChar(p)+108)^[0] , 7 );
 pac16(PChar(p)+56)^[0] := pac16(PChar(p)+56)^[0] - $64;

 if pac64(PChar(p)+323)^[0] < pac64(PChar(p)+64)^[0] then begin
   if pac16(PChar(p)+444)^[0] < pac16(PChar(p)+314)^[0] then pac64(PChar(p)+463)^[0] := pac64(PChar(p)+463)^[0] + (pac64(PChar(p)+334)^[0] or $62f9ed1952) else pac8(PChar(p)+318)^[0] := pac8(PChar(p)+318)^[0] - $a8;
   num := pac8(PChar(p)+33)^[0]; pac8(PChar(p)+33)^[0] := pac8(PChar(p)+140)^[0]; pac8(PChar(p)+140)^[0] := num;
   num := pac32(PChar(p)+422)^[0]; pac32(PChar(p)+422)^[0] := pac32(PChar(p)+197)^[0]; pac32(PChar(p)+197)^[0] := num;
   if pac32(PChar(p)+153)^[0] < pac32(PChar(p)+252)^[0] then begin  num := pac32(PChar(p)+463)^[0]; pac32(PChar(p)+463)^[0] := pac32(PChar(p)+135)^[0]; pac32(PChar(p)+135)^[0] := num; end else begin  num := pac16(PChar(p)+13)^[0]; pac16(PChar(p)+13)^[0] := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := num; end;
 end;

 pac8(PChar(p)+15)^[0] := pac8(PChar(p)+401)^[0] xor (pac8(PChar(p)+33)^[0] - $60);

 if pac64(PChar(p)+144)^[0] < pac64(PChar(p)+134)^[0] then begin
   pac16(PChar(p)+83)^[0] := pac16(PChar(p)+83)^[0] xor ror2(pac16(PChar(p)+2)^[0] , 10 );
   num := pac16(PChar(p)+364)^[0]; pac16(PChar(p)+364)^[0] := pac16(PChar(p)+316)^[0]; pac16(PChar(p)+316)^[0] := num;
 end;

 if pac16(PChar(p)+284)^[0] < pac16(PChar(p)+360)^[0] then begin  num := pac16(PChar(p)+72)^[0]; pac16(PChar(p)+72)^[0] := pac16(PChar(p)+42)^[0]; pac16(PChar(p)+42)^[0] := num; end else pac16(PChar(p)+249)^[0] := pac16(PChar(p)+249)^[0] or ror2(pac16(PChar(p)+190)^[0] , 7 );
 pac8(PChar(p)+387)^[0] := pac8(PChar(p)+387)^[0] + ror2(pac8(PChar(p)+390)^[0] , 4 );
 num := pac8(PChar(p)+322)^[0]; pac8(PChar(p)+322)^[0] := pac8(PChar(p)+138)^[0]; pac8(PChar(p)+138)^[0] := num;
 num := pac16(PChar(p)+310)^[0]; pac16(PChar(p)+310)^[0] := pac16(PChar(p)+108)^[0]; pac16(PChar(p)+108)^[0] := num;

 if pac8(PChar(p)+128)^[0] < pac8(PChar(p)+153)^[0] then begin
   if pac16(PChar(p)+188)^[0] < pac16(PChar(p)+248)^[0] then pac16(PChar(p)+238)^[0] := pac16(PChar(p)+238)^[0] or (pac16(PChar(p)+4)^[0] xor $12);
   pac64(PChar(p)+138)^[0] := pac64(PChar(p)+418)^[0] - $36d9d6912c5a;
   if pac32(PChar(p)+245)^[0] > pac32(PChar(p)+268)^[0] then pac8(PChar(p)+420)^[0] := pac8(PChar(p)+420)^[0] or $70 else pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] + ror1(pac32(PChar(p)+280)^[0] , 25 );
   num := pac8(PChar(p)+7)^[0]; pac8(PChar(p)+7)^[0] := pac8(PChar(p)+425)^[0]; pac8(PChar(p)+425)^[0] := num;
   num := pac16(PChar(p)+376)^[0]; pac16(PChar(p)+376)^[0] := pac16(PChar(p)+271)^[0]; pac16(PChar(p)+271)^[0] := num;
 end;

 pac8(PChar(p)+170)^[0] := pac8(PChar(p)+170)^[0] or $ec;
 pac64(PChar(p)+241)^[0] := pac64(PChar(p)+158)^[0] + (pac64(PChar(p)+480)^[0] xor $64d04f6f07);
 pac16(PChar(p)+6)^[0] := pac16(PChar(p)+6)^[0] - ror1(pac16(PChar(p)+483)^[0] , 2 );

CA6C5DB9(p);

end;

procedure CA6C5DB9(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+179)^[0] := pac32(PChar(p)+506)^[0] - (pac32(PChar(p)+406)^[0] xor $ca555d);
 if pac8(PChar(p)+433)^[0] > pac8(PChar(p)+167)^[0] then begin  num := pac8(PChar(p)+376)^[0]; pac8(PChar(p)+376)^[0] := pac8(PChar(p)+99)^[0]; pac8(PChar(p)+99)^[0] := num; end;

 if pac64(PChar(p)+337)^[0] > pac64(PChar(p)+132)^[0] then begin
   if pac8(PChar(p)+111)^[0] < pac8(PChar(p)+375)^[0] then begin  num := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := pac32(PChar(p)+126)^[0]; pac32(PChar(p)+126)^[0] := num; end else begin  num := pac8(PChar(p)+202)^[0]; pac8(PChar(p)+202)^[0] := pac8(PChar(p)+210)^[0]; pac8(PChar(p)+210)^[0] := num; end;
   pac8(PChar(p)+72)^[0] := ror2(pac8(PChar(p)+217)^[0] , 1 );
   pac32(PChar(p)+375)^[0] := pac32(PChar(p)+375)^[0] + (pac32(PChar(p)+14)^[0] xor $74c0b0);
   pac8(PChar(p)+347)^[0] := pac8(PChar(p)+347)^[0] xor rol1(pac8(PChar(p)+105)^[0] , 1 );
 end;


 if pac8(PChar(p)+119)^[0] > pac8(PChar(p)+467)^[0] then begin
   pac8(PChar(p)+323)^[0] := ror2(pac8(PChar(p)+472)^[0] , 3 );
   num := pac8(PChar(p)+495)^[0]; pac8(PChar(p)+495)^[0] := pac8(PChar(p)+133)^[0]; pac8(PChar(p)+133)^[0] := num;
   pac64(PChar(p)+283)^[0] := pac64(PChar(p)+283)^[0] or (pac64(PChar(p)+226)^[0] - $dcdf3128);
 end;

 num := pac16(PChar(p)+484)^[0]; pac16(PChar(p)+484)^[0] := pac16(PChar(p)+203)^[0]; pac16(PChar(p)+203)^[0] := num;
 pac64(PChar(p)+258)^[0] := pac64(PChar(p)+258)^[0] - (pac64(PChar(p)+354)^[0] + $c86b90a49d);
 pac8(PChar(p)+308)^[0] := ror2(pac8(PChar(p)+117)^[0] , 6 );
 pac64(PChar(p)+273)^[0] := pac64(PChar(p)+273)^[0] + $6413617cf2c4;

 if pac64(PChar(p)+371)^[0] < pac64(PChar(p)+345)^[0] then begin
   pac8(PChar(p)+286)^[0] := pac8(PChar(p)+286)^[0] + ror1(pac8(PChar(p)+431)^[0] , 1 );
   pac16(PChar(p)+504)^[0] := pac16(PChar(p)+310)^[0] xor (pac16(PChar(p)+105)^[0] + $a0);
   num := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := pac32(PChar(p)+102)^[0]; pac32(PChar(p)+102)^[0] := num;
 end;

 num := pac16(PChar(p)+414)^[0]; pac16(PChar(p)+414)^[0] := pac16(PChar(p)+27)^[0]; pac16(PChar(p)+27)^[0] := num;
 if pac64(PChar(p)+423)^[0] < pac64(PChar(p)+448)^[0] then begin  num := pac8(PChar(p)+383)^[0]; pac8(PChar(p)+383)^[0] := pac8(PChar(p)+171)^[0]; pac8(PChar(p)+171)^[0] := num; end else pac64(PChar(p)+467)^[0] := pac64(PChar(p)+467)^[0] or (pac64(PChar(p)+138)^[0] xor $2c1b4ac8c052);
 pac64(PChar(p)+363)^[0] := pac64(PChar(p)+363)^[0] - $6addb9c58819;
 num := pac32(PChar(p)+283)^[0]; pac32(PChar(p)+283)^[0] := pac32(PChar(p)+160)^[0]; pac32(PChar(p)+160)^[0] := num;
 if pac32(PChar(p)+508)^[0] < pac32(PChar(p)+72)^[0] then pac8(PChar(p)+4)^[0] := pac8(PChar(p)+4)^[0] - (pac8(PChar(p)+171)^[0] xor $70) else pac32(PChar(p)+289)^[0] := pac32(PChar(p)+7)^[0] - (pac32(PChar(p)+73)^[0] or $0822);
 pac32(PChar(p)+19)^[0] := pac32(PChar(p)+19)^[0] xor $923f6e;
 pac32(PChar(p)+132)^[0] := pac32(PChar(p)+69)^[0] or $c02d;
 pac32(PChar(p)+124)^[0] := pac32(PChar(p)+124)^[0] + ror2(pac32(PChar(p)+331)^[0] , 5 );

 if pac16(PChar(p)+381)^[0] < pac16(PChar(p)+230)^[0] then begin
   if pac16(PChar(p)+73)^[0] < pac16(PChar(p)+241)^[0] then pac64(PChar(p)+231)^[0] := pac64(PChar(p)+150)^[0] - $ea3eff207b79 else pac32(PChar(p)+130)^[0] := pac32(PChar(p)+130)^[0] or ror2(pac32(PChar(p)+175)^[0] , 9 );
   if pac8(PChar(p)+392)^[0] < pac8(PChar(p)+278)^[0] then begin  num := pac16(PChar(p)+253)^[0]; pac16(PChar(p)+253)^[0] := pac16(PChar(p)+170)^[0]; pac16(PChar(p)+170)^[0] := num; end else pac32(PChar(p)+214)^[0] := pac32(PChar(p)+214)^[0] xor ror2(pac32(PChar(p)+242)^[0] , 22 );
 end;


DA32182C(p);

end;

procedure DA32182C(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+319)^[0] := pac16(PChar(p)+278)^[0] xor $c8;
 num := pac32(PChar(p)+374)^[0]; pac32(PChar(p)+374)^[0] := pac32(PChar(p)+289)^[0]; pac32(PChar(p)+289)^[0] := num;
 pac8(PChar(p)+474)^[0] := pac8(PChar(p)+474)^[0] or $46;
 if pac8(PChar(p)+300)^[0] < pac8(PChar(p)+144)^[0] then pac16(PChar(p)+365)^[0] := pac16(PChar(p)+365)^[0] or ror2(pac16(PChar(p)+75)^[0] , 15 ) else pac16(PChar(p)+475)^[0] := pac16(PChar(p)+475)^[0] + ror1(pac16(PChar(p)+235)^[0] , 3 );
 if pac64(PChar(p)+207)^[0] > pac64(PChar(p)+475)^[0] then pac64(PChar(p)+50)^[0] := pac64(PChar(p)+50)^[0] + $20260b089e1e else pac32(PChar(p)+501)^[0] := pac32(PChar(p)+501)^[0] + (pac32(PChar(p)+224)^[0] + $0cdca0);
 pac16(PChar(p)+457)^[0] := pac16(PChar(p)+457)^[0] or ror2(pac16(PChar(p)+444)^[0] , 9 );
 if pac64(PChar(p)+74)^[0] < pac64(PChar(p)+394)^[0] then pac16(PChar(p)+84)^[0] := pac16(PChar(p)+84)^[0] + ror1(pac16(PChar(p)+133)^[0] , 9 ) else pac8(PChar(p)+301)^[0] := ror1(pac8(PChar(p)+506)^[0] , 7 );
 pac64(PChar(p)+277)^[0] := pac64(PChar(p)+277)^[0] + (pac64(PChar(p)+111)^[0] xor $00773bee);

 if pac32(PChar(p)+355)^[0] < pac32(PChar(p)+303)^[0] then begin
   pac64(PChar(p)+9)^[0] := pac64(PChar(p)+9)^[0] or $ccd779cb9326;
   num := pac8(PChar(p)+374)^[0]; pac8(PChar(p)+374)^[0] := pac8(PChar(p)+497)^[0]; pac8(PChar(p)+497)^[0] := num;
   pac16(PChar(p)+329)^[0] := pac16(PChar(p)+427)^[0] - $74;
 end;

 pac64(PChar(p)+267)^[0] := pac64(PChar(p)+267)^[0] xor (pac64(PChar(p)+413)^[0] or $3816e60be7c7);
 if pac16(PChar(p)+470)^[0] > pac16(PChar(p)+384)^[0] then begin  num := pac32(PChar(p)+478)^[0]; pac32(PChar(p)+478)^[0] := pac32(PChar(p)+438)^[0]; pac32(PChar(p)+438)^[0] := num; end else pac64(PChar(p)+33)^[0] := pac64(PChar(p)+33)^[0] - $8a3788e66b;

 if pac64(PChar(p)+493)^[0] > pac64(PChar(p)+287)^[0] then begin
   if pac16(PChar(p)+228)^[0] > pac16(PChar(p)+68)^[0] then begin  num := pac16(PChar(p)+423)^[0]; pac16(PChar(p)+423)^[0] := pac16(PChar(p)+338)^[0]; pac16(PChar(p)+338)^[0] := num; end;
   num := pac32(PChar(p)+111)^[0]; pac32(PChar(p)+111)^[0] := pac32(PChar(p)+320)^[0]; pac32(PChar(p)+320)^[0] := num;
   pac32(PChar(p)+128)^[0] := pac32(PChar(p)+128)^[0] or $e260;
   pac32(PChar(p)+29)^[0] := pac32(PChar(p)+29)^[0] + $d8efbb;
   pac8(PChar(p)+143)^[0] := pac8(PChar(p)+452)^[0] - (pac8(PChar(p)+61)^[0] xor $96);
 end;


C0398AE3(p);

end;

procedure C0398AE3(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+134)^[0] := pac32(PChar(p)+430)^[0] xor (pac32(PChar(p)+203)^[0] + $18aa);
 pac16(PChar(p)+375)^[0] := pac16(PChar(p)+375)^[0] or (pac16(PChar(p)+477)^[0] - $62);
 pac8(PChar(p)+375)^[0] := pac8(PChar(p)+375)^[0] + rol1(pac8(PChar(p)+276)^[0] , 6 );
 pac32(PChar(p)+295)^[0] := ror2(pac32(PChar(p)+51)^[0] , 16 );
 pac32(PChar(p)+336)^[0] := pac32(PChar(p)+336)^[0] or $708f0b;
 pac32(PChar(p)+59)^[0] := pac32(PChar(p)+59)^[0] or ror1(pac32(PChar(p)+449)^[0] , 16 );
 num := pac16(PChar(p)+138)^[0]; pac16(PChar(p)+138)^[0] := pac16(PChar(p)+468)^[0]; pac16(PChar(p)+468)^[0] := num;
 pac64(PChar(p)+336)^[0] := pac64(PChar(p)+336)^[0] or $7cc0b10201;
 pac16(PChar(p)+95)^[0] := pac16(PChar(p)+95)^[0] + ror1(pac16(PChar(p)+281)^[0] , 7 );
 pac16(PChar(p)+232)^[0] := pac16(PChar(p)+232)^[0] xor rol1(pac16(PChar(p)+481)^[0] , 7 );
 num := pac16(PChar(p)+105)^[0]; pac16(PChar(p)+105)^[0] := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := num;

A018C4A9(p);

end;

procedure A018C4A9(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+328)^[0] := pac8(PChar(p)+328)^[0] - ror2(pac8(PChar(p)+202)^[0] , 2 );
 if pac16(PChar(p)+89)^[0] < pac16(PChar(p)+446)^[0] then pac64(PChar(p)+226)^[0] := pac64(PChar(p)+226)^[0] + $506a566936c0 else pac64(PChar(p)+83)^[0] := pac64(PChar(p)+83)^[0] + $f668a4bc59;
 pac8(PChar(p)+365)^[0] := pac8(PChar(p)+365)^[0] xor $40;
 pac32(PChar(p)+138)^[0] := pac32(PChar(p)+138)^[0] + (pac32(PChar(p)+271)^[0] xor $0066);
 num := pac32(PChar(p)+418)^[0]; pac32(PChar(p)+418)^[0] := pac32(PChar(p)+165)^[0]; pac32(PChar(p)+165)^[0] := num;
 pac32(PChar(p)+476)^[0] := pac32(PChar(p)+476)^[0] xor rol1(pac32(PChar(p)+34)^[0] , 16 );
 pac16(PChar(p)+234)^[0] := pac16(PChar(p)+234)^[0] or (pac16(PChar(p)+28)^[0] or $7a);

 if pac64(PChar(p)+439)^[0] > pac64(PChar(p)+205)^[0] then begin
   pac64(PChar(p)+134)^[0] := pac64(PChar(p)+336)^[0] - $aef9fe246e;
   pac16(PChar(p)+77)^[0] := pac16(PChar(p)+77)^[0] xor (pac16(PChar(p)+342)^[0] - $22);
   pac32(PChar(p)+353)^[0] := pac32(PChar(p)+353)^[0] or ror2(pac32(PChar(p)+487)^[0] , 25 );
 end;

 pac16(PChar(p)+378)^[0] := pac16(PChar(p)+378)^[0] - (pac16(PChar(p)+420)^[0] - $46);
 pac16(PChar(p)+362)^[0] := pac16(PChar(p)+362)^[0] + ror2(pac16(PChar(p)+279)^[0] , 15 );
 pac16(PChar(p)+499)^[0] := ror1(pac16(PChar(p)+479)^[0] , 15 );
 num := pac8(PChar(p)+461)^[0]; pac8(PChar(p)+461)^[0] := pac8(PChar(p)+16)^[0]; pac8(PChar(p)+16)^[0] := num;

 if pac32(PChar(p)+324)^[0] > pac32(PChar(p)+456)^[0] then begin
   pac8(PChar(p)+263)^[0] := pac8(PChar(p)+263)^[0] - ror2(pac8(PChar(p)+368)^[0] , 7 );
   pac32(PChar(p)+142)^[0] := pac32(PChar(p)+142)^[0] xor (pac32(PChar(p)+116)^[0] + $4cf5d7);
   num := pac8(PChar(p)+282)^[0]; pac8(PChar(p)+282)^[0] := pac8(PChar(p)+270)^[0]; pac8(PChar(p)+270)^[0] := num;
   pac16(PChar(p)+295)^[0] := rol1(pac16(PChar(p)+250)^[0] , 14 );
   num := pac16(PChar(p)+493)^[0]; pac16(PChar(p)+493)^[0] := pac16(PChar(p)+325)^[0]; pac16(PChar(p)+325)^[0] := num;
 end;

 if pac64(PChar(p)+439)^[0] < pac64(PChar(p)+225)^[0] then begin  num := pac32(PChar(p)+472)^[0]; pac32(PChar(p)+472)^[0] := pac32(PChar(p)+46)^[0]; pac32(PChar(p)+46)^[0] := num; end else pac8(PChar(p)+166)^[0] := pac8(PChar(p)+166)^[0] or rol1(pac8(PChar(p)+352)^[0] , 1 );
 pac64(PChar(p)+40)^[0] := pac64(PChar(p)+40)^[0] - $f0f8485e75;
 pac64(PChar(p)+402)^[0] := pac64(PChar(p)+162)^[0] - (pac64(PChar(p)+133)^[0] - $8623657a);
 pac8(PChar(p)+348)^[0] := pac8(PChar(p)+348)^[0] xor $42;

EE798AB9(p);

end;

procedure EE798AB9(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+473)^[0] := pac8(PChar(p)+473)^[0] + (pac8(PChar(p)+274)^[0] - $de);
 pac32(PChar(p)+376)^[0] := pac32(PChar(p)+376)^[0] xor ror2(pac32(PChar(p)+74)^[0] , 4 );
 num := pac32(PChar(p)+107)^[0]; pac32(PChar(p)+107)^[0] := pac32(PChar(p)+388)^[0]; pac32(PChar(p)+388)^[0] := num;

 if pac64(PChar(p)+125)^[0] < pac64(PChar(p)+55)^[0] then begin
   pac32(PChar(p)+245)^[0] := pac32(PChar(p)+245)^[0] or ror2(pac32(PChar(p)+227)^[0] , 8 );
   num := pac16(PChar(p)+117)^[0]; pac16(PChar(p)+117)^[0] := pac16(PChar(p)+478)^[0]; pac16(PChar(p)+478)^[0] := num;
   pac16(PChar(p)+382)^[0] := pac16(PChar(p)+382)^[0] or (pac16(PChar(p)+488)^[0] or $16);
 end;

 num := pac8(PChar(p)+191)^[0]; pac8(PChar(p)+191)^[0] := pac8(PChar(p)+140)^[0]; pac8(PChar(p)+140)^[0] := num;
 num := pac8(PChar(p)+314)^[0]; pac8(PChar(p)+314)^[0] := pac8(PChar(p)+79)^[0]; pac8(PChar(p)+79)^[0] := num;
 num := pac32(PChar(p)+453)^[0]; pac32(PChar(p)+453)^[0] := pac32(PChar(p)+82)^[0]; pac32(PChar(p)+82)^[0] := num;
 if pac32(PChar(p)+229)^[0] > pac32(PChar(p)+262)^[0] then pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] + (pac32(PChar(p)+335)^[0] - $a6b8f9);

 if pac8(PChar(p)+23)^[0] < pac8(PChar(p)+141)^[0] then begin
   pac16(PChar(p)+120)^[0] := pac16(PChar(p)+120)^[0] xor $fe;
   pac8(PChar(p)+407)^[0] := pac8(PChar(p)+407)^[0] - (pac8(PChar(p)+233)^[0] or $f6);
   pac32(PChar(p)+94)^[0] := pac32(PChar(p)+94)^[0] + (pac32(PChar(p)+458)^[0] + $70a72f);
   pac8(PChar(p)+240)^[0] := pac8(PChar(p)+240)^[0] xor ror2(pac8(PChar(p)+122)^[0] , 7 );
   pac32(PChar(p)+493)^[0] := pac32(PChar(p)+493)^[0] xor (pac32(PChar(p)+402)^[0] or $103f);
 end;


 if pac32(PChar(p)+400)^[0] > pac32(PChar(p)+471)^[0] then begin
   if pac32(PChar(p)+180)^[0] > pac32(PChar(p)+440)^[0] then pac16(PChar(p)+273)^[0] := pac16(PChar(p)+273)^[0] - ror2(pac16(PChar(p)+5)^[0] , 13 ) else pac64(PChar(p)+163)^[0] := pac64(PChar(p)+163)^[0] xor $56d5a187ec4e;
   pac32(PChar(p)+145)^[0] := pac32(PChar(p)+396)^[0] - (pac32(PChar(p)+59)^[0] - $880258);
 end;

 pac32(PChar(p)+41)^[0] := pac32(PChar(p)+41)^[0] + (pac32(PChar(p)+98)^[0] - $2699e4);
 pac16(PChar(p)+367)^[0] := pac16(PChar(p)+367)^[0] - (pac16(PChar(p)+47)^[0] xor $8e);
 pac64(PChar(p)+55)^[0] := pac64(PChar(p)+172)^[0] xor $0257875b;
 if pac16(PChar(p)+205)^[0] < pac16(PChar(p)+404)^[0] then begin  num := pac8(PChar(p)+226)^[0]; pac8(PChar(p)+226)^[0] := pac8(PChar(p)+169)^[0]; pac8(PChar(p)+169)^[0] := num; end else pac64(PChar(p)+162)^[0] := pac64(PChar(p)+162)^[0] - $682c3a1b359f;
 if pac8(PChar(p)+120)^[0] > pac8(PChar(p)+449)^[0] then pac16(PChar(p)+483)^[0] := pac16(PChar(p)+483)^[0] + (pac16(PChar(p)+73)^[0] or $d0) else pac8(PChar(p)+259)^[0] := pac8(PChar(p)+259)^[0] + (pac8(PChar(p)+487)^[0] + $4a);
 if pac8(PChar(p)+511)^[0] > pac8(PChar(p)+94)^[0] then pac64(PChar(p)+407)^[0] := pac64(PChar(p)+407)^[0] + (pac64(PChar(p)+61)^[0] - $9e20cd1b3831) else begin  num := pac16(PChar(p)+307)^[0]; pac16(PChar(p)+307)^[0] := pac16(PChar(p)+135)^[0]; pac16(PChar(p)+135)^[0] := num; end;
 num := pac8(PChar(p)+45)^[0]; pac8(PChar(p)+45)^[0] := pac8(PChar(p)+386)^[0]; pac8(PChar(p)+386)^[0] := num;

D374E274(p);

end;

procedure D374E274(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+309)^[0] < pac64(PChar(p)+416)^[0] then pac8(PChar(p)+108)^[0] := pac8(PChar(p)+108)^[0] + (pac8(PChar(p)+98)^[0] or $86) else begin  num := pac8(PChar(p)+411)^[0]; pac8(PChar(p)+411)^[0] := pac8(PChar(p)+492)^[0]; pac8(PChar(p)+492)^[0] := num; end;
 pac8(PChar(p)+30)^[0] := pac8(PChar(p)+30)^[0] - rol1(pac8(PChar(p)+3)^[0] , 3 );

 if pac8(PChar(p)+314)^[0] < pac8(PChar(p)+500)^[0] then begin
   if pac16(PChar(p)+75)^[0] < pac16(PChar(p)+346)^[0] then begin  num := pac16(PChar(p)+327)^[0]; pac16(PChar(p)+327)^[0] := pac16(PChar(p)+61)^[0]; pac16(PChar(p)+61)^[0] := num; end else pac16(PChar(p)+114)^[0] := pac16(PChar(p)+114)^[0] + rol1(pac16(PChar(p)+70)^[0] , 12 );
   pac64(PChar(p)+477)^[0] := pac64(PChar(p)+477)^[0] - (pac64(PChar(p)+169)^[0] - $38d2907bf6);
   if pac32(PChar(p)+332)^[0] > pac32(PChar(p)+117)^[0] then pac64(PChar(p)+373)^[0] := pac64(PChar(p)+504)^[0] - $2634fad005 else pac8(PChar(p)+107)^[0] := pac8(PChar(p)+107)^[0] or $88;
   pac32(PChar(p)+72)^[0] := pac32(PChar(p)+72)^[0] xor ror2(pac32(PChar(p)+133)^[0] , 14 );
 end;

 if pac16(PChar(p)+60)^[0] > pac16(PChar(p)+500)^[0] then begin  num := pac32(PChar(p)+458)^[0]; pac32(PChar(p)+458)^[0] := pac32(PChar(p)+449)^[0]; pac32(PChar(p)+449)^[0] := num; end else pac32(PChar(p)+314)^[0] := pac32(PChar(p)+314)^[0] xor $70d6;
 pac8(PChar(p)+343)^[0] := pac8(PChar(p)+343)^[0] - $48;
 pac8(PChar(p)+85)^[0] := pac8(PChar(p)+85)^[0] or ror2(pac8(PChar(p)+331)^[0] , 5 );

 if pac32(PChar(p)+196)^[0] > pac32(PChar(p)+160)^[0] then begin
   pac32(PChar(p)+301)^[0] := ror1(pac32(PChar(p)+191)^[0] , 2 );
   pac16(PChar(p)+8)^[0] := pac16(PChar(p)+8)^[0] + ror1(pac16(PChar(p)+53)^[0] , 7 );
 end;

 pac64(PChar(p)+204)^[0] := pac64(PChar(p)+204)^[0] - (pac64(PChar(p)+206)^[0] or $8470d2d05ecd);
 if pac64(PChar(p)+492)^[0] > pac64(PChar(p)+187)^[0] then pac64(PChar(p)+100)^[0] := pac64(PChar(p)+307)^[0] - $a812abdc5eaa else pac8(PChar(p)+153)^[0] := ror2(pac8(PChar(p)+43)^[0] , 4 );

 if pac16(PChar(p)+423)^[0] > pac16(PChar(p)+225)^[0] then begin
   if pac32(PChar(p)+8)^[0] < pac32(PChar(p)+40)^[0] then begin  num := pac8(PChar(p)+234)^[0]; pac8(PChar(p)+234)^[0] := pac8(PChar(p)+265)^[0]; pac8(PChar(p)+265)^[0] := num; end else pac16(PChar(p)+237)^[0] := ror2(pac16(PChar(p)+110)^[0] , 1 );
   pac32(PChar(p)+429)^[0] := pac32(PChar(p)+429)^[0] - $d62e;
   pac16(PChar(p)+119)^[0] := pac16(PChar(p)+119)^[0] or $e8;
   pac16(PChar(p)+112)^[0] := pac16(PChar(p)+112)^[0] - ror2(pac16(PChar(p)+107)^[0] , 4 );
 end;

 pac32(PChar(p)+173)^[0] := pac32(PChar(p)+173)^[0] xor (pac32(PChar(p)+117)^[0] or $da0ccf);

 if pac32(PChar(p)+184)^[0] < pac32(PChar(p)+485)^[0] then begin
   pac64(PChar(p)+409)^[0] := pac64(PChar(p)+409)^[0] xor (pac64(PChar(p)+386)^[0] + $dcd660f191);
   if pac16(PChar(p)+376)^[0] < pac16(PChar(p)+131)^[0] then pac64(PChar(p)+96)^[0] := pac64(PChar(p)+96)^[0] + (pac64(PChar(p)+11)^[0] + $da222f13) else pac64(PChar(p)+333)^[0] := pac64(PChar(p)+333)^[0] + (pac64(PChar(p)+281)^[0] - $6cb2a5ef96ca);
   pac64(PChar(p)+19)^[0] := pac64(PChar(p)+19)^[0] xor (pac64(PChar(p)+411)^[0] - $d8f432c126);
   num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+168)^[0]; pac8(PChar(p)+168)^[0] := num;
   if pac8(PChar(p)+458)^[0] < pac8(PChar(p)+331)^[0] then pac32(PChar(p)+80)^[0] := pac32(PChar(p)+255)^[0] - (pac32(PChar(p)+221)^[0] + $6083aa) else pac8(PChar(p)+110)^[0] := pac8(PChar(p)+110)^[0] - ror1(pac8(PChar(p)+407)^[0] , 7 );
 end;

 pac64(PChar(p)+383)^[0] := pac64(PChar(p)+383)^[0] - (pac64(PChar(p)+390)^[0] xor $d418667e5504);

BA54F070(p);

end;

procedure BA54F070(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+212)^[0]; pac32(PChar(p)+212)^[0] := pac32(PChar(p)+110)^[0]; pac32(PChar(p)+110)^[0] := num;
 if pac32(PChar(p)+378)^[0] < pac32(PChar(p)+304)^[0] then pac32(PChar(p)+68)^[0] := pac32(PChar(p)+68)^[0] - $b83c else pac16(PChar(p)+268)^[0] := pac16(PChar(p)+268)^[0] - (pac16(PChar(p)+482)^[0] xor $14);

 if pac8(PChar(p)+436)^[0] < pac8(PChar(p)+408)^[0] then begin
   pac64(PChar(p)+502)^[0] := pac64(PChar(p)+502)^[0] - (pac64(PChar(p)+241)^[0] or $ce6bcf7c);
   num := pac8(PChar(p)+76)^[0]; pac8(PChar(p)+76)^[0] := pac8(PChar(p)+7)^[0]; pac8(PChar(p)+7)^[0] := num;
   num := pac16(PChar(p)+353)^[0]; pac16(PChar(p)+353)^[0] := pac16(PChar(p)+366)^[0]; pac16(PChar(p)+366)^[0] := num;
   num := pac32(PChar(p)+117)^[0]; pac32(PChar(p)+117)^[0] := pac32(PChar(p)+444)^[0]; pac32(PChar(p)+444)^[0] := num;
 end;

 pac16(PChar(p)+248)^[0] := ror2(pac16(PChar(p)+258)^[0] , 14 );
 pac8(PChar(p)+466)^[0] := pac8(PChar(p)+466)^[0] xor ror2(pac8(PChar(p)+120)^[0] , 2 );
 pac8(PChar(p)+280)^[0] := pac8(PChar(p)+280)^[0] xor rol1(pac8(PChar(p)+194)^[0] , 6 );
 pac16(PChar(p)+267)^[0] := pac16(PChar(p)+141)^[0] - (pac16(PChar(p)+357)^[0] - $ae);
 pac64(PChar(p)+462)^[0] := pac64(PChar(p)+139)^[0] + $92ba567c;
 num := pac16(PChar(p)+166)^[0]; pac16(PChar(p)+166)^[0] := pac16(PChar(p)+41)^[0]; pac16(PChar(p)+41)^[0] := num;
 pac32(PChar(p)+269)^[0] := pac32(PChar(p)+269)^[0] xor $5afb29;
 pac16(PChar(p)+158)^[0] := pac16(PChar(p)+158)^[0] xor ror2(pac16(PChar(p)+85)^[0] , 2 );

DB3323E6(p);

end;

procedure DB3323E6(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+221)^[0] := pac64(PChar(p)+221)^[0] or (pac64(PChar(p)+420)^[0] or $92f504f5);
 pac64(PChar(p)+288)^[0] := pac64(PChar(p)+288)^[0] xor $ca11776165;
 pac32(PChar(p)+443)^[0] := pac32(PChar(p)+443)^[0] or $1eda2b;
 pac16(PChar(p)+260)^[0] := pac16(PChar(p)+65)^[0] + (pac16(PChar(p)+360)^[0] xor $a6);
 pac32(PChar(p)+372)^[0] := pac32(PChar(p)+372)^[0] or $ecc1;
 num := pac8(PChar(p)+408)^[0]; pac8(PChar(p)+408)^[0] := pac8(PChar(p)+97)^[0]; pac8(PChar(p)+97)^[0] := num;

 if pac32(PChar(p)+292)^[0] < pac32(PChar(p)+386)^[0] then begin
   pac32(PChar(p)+228)^[0] := pac32(PChar(p)+228)^[0] - (pac32(PChar(p)+393)^[0] or $8482);
   pac16(PChar(p)+408)^[0] := pac16(PChar(p)+408)^[0] xor ror2(pac16(PChar(p)+44)^[0] , 4 );
   num := pac8(PChar(p)+83)^[0]; pac8(PChar(p)+83)^[0] := pac8(PChar(p)+291)^[0]; pac8(PChar(p)+291)^[0] := num;
 end;

 pac8(PChar(p)+192)^[0] := pac8(PChar(p)+129)^[0] xor $30;
 pac8(PChar(p)+179)^[0] := pac8(PChar(p)+179)^[0] - $fa;
 pac32(PChar(p)+94)^[0] := pac32(PChar(p)+94)^[0] or ror2(pac32(PChar(p)+166)^[0] , 29 );
 pac64(PChar(p)+481)^[0] := pac64(PChar(p)+481)^[0] xor (pac64(PChar(p)+313)^[0] or $de5ea77d11);
 if pac64(PChar(p)+348)^[0] > pac64(PChar(p)+78)^[0] then begin  num := pac16(PChar(p)+259)^[0]; pac16(PChar(p)+259)^[0] := pac16(PChar(p)+373)^[0]; pac16(PChar(p)+373)^[0] := num; end else begin  num := pac8(PChar(p)+12)^[0]; pac8(PChar(p)+12)^[0] := pac8(PChar(p)+49)^[0]; pac8(PChar(p)+49)^[0] := num; end;
 pac8(PChar(p)+243)^[0] := pac8(PChar(p)+243)^[0] or $a8;

B029F679(p);

end;

procedure B029F679(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+35)^[0]; pac32(PChar(p)+35)^[0] := pac32(PChar(p)+220)^[0]; pac32(PChar(p)+220)^[0] := num;
 pac64(PChar(p)+319)^[0] := pac64(PChar(p)+319)^[0] + (pac64(PChar(p)+245)^[0] or $fc1a73b764df);
 pac8(PChar(p)+347)^[0] := pac8(PChar(p)+347)^[0] xor ror1(pac8(PChar(p)+73)^[0] , 1 );
 if pac32(PChar(p)+19)^[0] < pac32(PChar(p)+92)^[0] then pac32(PChar(p)+186)^[0] := pac32(PChar(p)+186)^[0] + (pac32(PChar(p)+321)^[0] + $36272e) else pac8(PChar(p)+245)^[0] := pac8(PChar(p)+245)^[0] - ror2(pac8(PChar(p)+215)^[0] , 1 );
 pac8(PChar(p)+490)^[0] := pac8(PChar(p)+490)^[0] xor ror2(pac8(PChar(p)+116)^[0] , 2 );

 if pac64(PChar(p)+113)^[0] < pac64(PChar(p)+348)^[0] then begin
   if pac32(PChar(p)+353)^[0] < pac32(PChar(p)+120)^[0] then pac8(PChar(p)+224)^[0] := rol1(pac8(PChar(p)+17)^[0] , 3 ) else pac32(PChar(p)+224)^[0] := pac32(PChar(p)+224)^[0] - rol1(pac32(PChar(p)+474)^[0] , 14 );
   pac32(PChar(p)+375)^[0] := pac32(PChar(p)+375)^[0] xor $b064;
   if pac64(PChar(p)+427)^[0] < pac64(PChar(p)+500)^[0] then pac32(PChar(p)+123)^[0] := ror1(pac32(PChar(p)+105)^[0] , 13 );
   pac16(PChar(p)+260)^[0] := pac16(PChar(p)+260)^[0] xor rol1(pac16(PChar(p)+306)^[0] , 6 );
 end;

 pac16(PChar(p)+346)^[0] := rol1(pac16(PChar(p)+321)^[0] , 14 );
 num := pac8(PChar(p)+81)^[0]; pac8(PChar(p)+81)^[0] := pac8(PChar(p)+37)^[0]; pac8(PChar(p)+37)^[0] := num;
 pac32(PChar(p)+420)^[0] := pac32(PChar(p)+19)^[0] + (pac32(PChar(p)+358)^[0] xor $3280b7);
 pac32(PChar(p)+362)^[0] := pac32(PChar(p)+362)^[0] + $ec07;
 if pac16(PChar(p)+296)^[0] > pac16(PChar(p)+391)^[0] then pac8(PChar(p)+392)^[0] := pac8(PChar(p)+392)^[0] or $6e else pac64(PChar(p)+459)^[0] := pac64(PChar(p)+459)^[0] xor (pac64(PChar(p)+385)^[0] xor $3ce6ae3ea4);
 pac32(PChar(p)+444)^[0] := pac32(PChar(p)+444)^[0] + $08b2f5;

 if pac32(PChar(p)+91)^[0] < pac32(PChar(p)+42)^[0] then begin
   pac32(PChar(p)+48)^[0] := pac32(PChar(p)+48)^[0] - (pac32(PChar(p)+144)^[0] or $0e81);
   if pac32(PChar(p)+382)^[0] > pac32(PChar(p)+233)^[0] then pac64(PChar(p)+495)^[0] := pac64(PChar(p)+495)^[0] xor $5a4d9def;
   pac8(PChar(p)+443)^[0] := pac8(PChar(p)+443)^[0] or $6e;
   pac32(PChar(p)+216)^[0] := pac32(PChar(p)+216)^[0] - (pac32(PChar(p)+405)^[0] xor $9625);
   pac16(PChar(p)+297)^[0] := pac16(PChar(p)+297)^[0] or rol1(pac16(PChar(p)+331)^[0] , 3 );
 end;

 num := pac16(PChar(p)+98)^[0]; pac16(PChar(p)+98)^[0] := pac16(PChar(p)+81)^[0]; pac16(PChar(p)+81)^[0] := num;
 pac64(PChar(p)+53)^[0] := pac64(PChar(p)+53)^[0] or (pac64(PChar(p)+113)^[0] or $70b4922a);
 pac8(PChar(p)+386)^[0] := ror2(pac8(PChar(p)+294)^[0] , 5 );
 pac16(PChar(p)+155)^[0] := pac16(PChar(p)+155)^[0] or $60;

B9097DF5(p);

end;

procedure B9097DF5(p: Pointer);
var num: Int64;
begin


 if pac64(PChar(p)+480)^[0] < pac64(PChar(p)+267)^[0] then begin
   if pac64(PChar(p)+114)^[0] < pac64(PChar(p)+291)^[0] then pac64(PChar(p)+439)^[0] := pac64(PChar(p)+439)^[0] or (pac64(PChar(p)+76)^[0] or $6a1318840c67) else pac16(PChar(p)+500)^[0] := pac16(PChar(p)+500)^[0] or ror2(pac16(PChar(p)+0)^[0] , 13 );
   pac16(PChar(p)+342)^[0] := ror1(pac16(PChar(p)+114)^[0] , 3 );
   pac16(PChar(p)+156)^[0] := pac16(PChar(p)+156)^[0] + ror2(pac16(PChar(p)+188)^[0] , 11 );
   pac16(PChar(p)+43)^[0] := pac16(PChar(p)+503)^[0] - (pac16(PChar(p)+7)^[0] xor $d6);
 end;


 if pac32(PChar(p)+497)^[0] > pac32(PChar(p)+409)^[0] then begin
   pac64(PChar(p)+149)^[0] := pac64(PChar(p)+149)^[0] xor (pac64(PChar(p)+459)^[0] xor $b628c40e);
   pac8(PChar(p)+113)^[0] := pac8(PChar(p)+113)^[0] + ror2(pac8(PChar(p)+305)^[0] , 3 );
 end;

 pac32(PChar(p)+456)^[0] := pac32(PChar(p)+456)^[0] or (pac32(PChar(p)+126)^[0] + $f0fe);
 pac8(PChar(p)+334)^[0] := pac8(PChar(p)+334)^[0] - ror1(pac8(PChar(p)+60)^[0] , 6 );

 if pac16(PChar(p)+333)^[0] < pac16(PChar(p)+345)^[0] then begin
   pac8(PChar(p)+148)^[0] := pac8(PChar(p)+148)^[0] - ror2(pac8(PChar(p)+134)^[0] , 3 );
   pac32(PChar(p)+471)^[0] := rol1(pac32(PChar(p)+207)^[0] , 26 );
 end;

 num := pac8(PChar(p)+191)^[0]; pac8(PChar(p)+191)^[0] := pac8(PChar(p)+243)^[0]; pac8(PChar(p)+243)^[0] := num;

 if pac64(PChar(p)+243)^[0] < pac64(PChar(p)+131)^[0] then begin
   num := pac8(PChar(p)+456)^[0]; pac8(PChar(p)+456)^[0] := pac8(PChar(p)+16)^[0]; pac8(PChar(p)+16)^[0] := num;
   pac64(PChar(p)+266)^[0] := pac64(PChar(p)+266)^[0] or (pac64(PChar(p)+470)^[0] or $94c046075a);
   pac16(PChar(p)+293)^[0] := ror1(pac16(PChar(p)+124)^[0] , 8 );
   pac32(PChar(p)+494)^[0] := pac32(PChar(p)+494)^[0] + (pac32(PChar(p)+46)^[0] xor $5af4);
 end;


 if pac32(PChar(p)+102)^[0] < pac32(PChar(p)+77)^[0] then begin
   if pac32(PChar(p)+461)^[0] < pac32(PChar(p)+495)^[0] then pac16(PChar(p)+133)^[0] := pac16(PChar(p)+448)^[0] or (pac16(PChar(p)+38)^[0] - $e0) else begin  num := pac16(PChar(p)+387)^[0]; pac16(PChar(p)+387)^[0] := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := num; end;
   pac8(PChar(p)+223)^[0] := pac8(PChar(p)+223)^[0] or ror2(pac8(PChar(p)+201)^[0] , 3 );
 end;

 pac32(PChar(p)+55)^[0] := pac32(PChar(p)+55)^[0] - (pac32(PChar(p)+441)^[0] xor $060699);
 if pac32(PChar(p)+25)^[0] > pac32(PChar(p)+135)^[0] then begin  num := pac8(PChar(p)+238)^[0]; pac8(PChar(p)+238)^[0] := pac8(PChar(p)+85)^[0]; pac8(PChar(p)+85)^[0] := num; end else pac32(PChar(p)+460)^[0] := pac32(PChar(p)+460)^[0] - (pac32(PChar(p)+480)^[0] xor $3c0ea3);
 pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] + ror1(pac32(PChar(p)+104)^[0] , 25 );
 pac64(PChar(p)+176)^[0] := pac64(PChar(p)+162)^[0] xor (pac64(PChar(p)+53)^[0] + $c8c554338beb);

 if pac64(PChar(p)+265)^[0] < pac64(PChar(p)+386)^[0] then begin
   num := pac32(PChar(p)+234)^[0]; pac32(PChar(p)+234)^[0] := pac32(PChar(p)+133)^[0]; pac32(PChar(p)+133)^[0] := num;
   if pac64(PChar(p)+131)^[0] > pac64(PChar(p)+310)^[0] then pac64(PChar(p)+236)^[0] := pac64(PChar(p)+236)^[0] - (pac64(PChar(p)+365)^[0] + $f0bd4d46) else pac16(PChar(p)+296)^[0] := pac16(PChar(p)+296)^[0] - ror2(pac16(PChar(p)+267)^[0] , 5 );
 end;

 pac64(PChar(p)+330)^[0] := pac64(PChar(p)+330)^[0] + $a29dfeb8d904;

D2215CD8(p);

end;

procedure D2215CD8(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+394)^[0]; pac16(PChar(p)+394)^[0] := pac16(PChar(p)+500)^[0]; pac16(PChar(p)+500)^[0] := num;
 num := pac16(PChar(p)+9)^[0]; pac16(PChar(p)+9)^[0] := pac16(PChar(p)+337)^[0]; pac16(PChar(p)+337)^[0] := num;
 pac32(PChar(p)+256)^[0] := pac32(PChar(p)+256)^[0] - (pac32(PChar(p)+242)^[0] - $168847);
 pac8(PChar(p)+383)^[0] := pac8(PChar(p)+383)^[0] + ror2(pac8(PChar(p)+498)^[0] , 5 );
 if pac8(PChar(p)+304)^[0] < pac8(PChar(p)+18)^[0] then pac64(PChar(p)+99)^[0] := pac64(PChar(p)+99)^[0] + (pac64(PChar(p)+45)^[0] or $76fea52e) else begin  num := pac8(PChar(p)+376)^[0]; pac8(PChar(p)+376)^[0] := pac8(PChar(p)+58)^[0]; pac8(PChar(p)+58)^[0] := num; end;
 pac16(PChar(p)+227)^[0] := pac16(PChar(p)+227)^[0] + rol1(pac16(PChar(p)+506)^[0] , 1 );
 num := pac32(PChar(p)+449)^[0]; pac32(PChar(p)+449)^[0] := pac32(PChar(p)+35)^[0]; pac32(PChar(p)+35)^[0] := num;

 if pac16(PChar(p)+136)^[0] > pac16(PChar(p)+14)^[0] then begin
   pac8(PChar(p)+16)^[0] := pac8(PChar(p)+16)^[0] - (pac8(PChar(p)+356)^[0] or $b6);
   num := pac8(PChar(p)+213)^[0]; pac8(PChar(p)+213)^[0] := pac8(PChar(p)+376)^[0]; pac8(PChar(p)+376)^[0] := num;
   num := pac16(PChar(p)+167)^[0]; pac16(PChar(p)+167)^[0] := pac16(PChar(p)+277)^[0]; pac16(PChar(p)+277)^[0] := num;
   pac32(PChar(p)+123)^[0] := pac32(PChar(p)+123)^[0] xor $3ce1c1;
   if pac16(PChar(p)+474)^[0] > pac16(PChar(p)+256)^[0] then pac64(PChar(p)+359)^[0] := pac64(PChar(p)+359)^[0] or (pac64(PChar(p)+62)^[0] + $88a1b15528) else begin  num := pac16(PChar(p)+291)^[0]; pac16(PChar(p)+291)^[0] := pac16(PChar(p)+211)^[0]; pac16(PChar(p)+211)^[0] := num; end;
 end;

 pac8(PChar(p)+190)^[0] := pac8(PChar(p)+190)^[0] or ror2(pac8(PChar(p)+466)^[0] , 6 );
 pac64(PChar(p)+322)^[0] := pac64(PChar(p)+322)^[0] xor (pac64(PChar(p)+2)^[0] + $0edd9af2b992);
 if pac64(PChar(p)+159)^[0] > pac64(PChar(p)+386)^[0] then pac8(PChar(p)+196)^[0] := ror2(pac8(PChar(p)+308)^[0] , 7 );

C952FD73(p);

end;

procedure C952FD73(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+103)^[0] := pac64(PChar(p)+103)^[0] + $407c1faf;
 pac16(PChar(p)+277)^[0] := pac16(PChar(p)+277)^[0] or ror1(pac16(PChar(p)+132)^[0] , 3 );
 num := pac32(PChar(p)+65)^[0]; pac32(PChar(p)+65)^[0] := pac32(PChar(p)+318)^[0]; pac32(PChar(p)+318)^[0] := num;
 pac8(PChar(p)+492)^[0] := pac8(PChar(p)+203)^[0] xor (pac8(PChar(p)+379)^[0] - $e0);
 pac32(PChar(p)+150)^[0] := pac32(PChar(p)+150)^[0] + ror1(pac32(PChar(p)+180)^[0] , 13 );
 pac32(PChar(p)+72)^[0] := rol1(pac32(PChar(p)+465)^[0] , 3 );
 pac64(PChar(p)+324)^[0] := pac64(PChar(p)+324)^[0] + $9aa61019;

 if pac32(PChar(p)+433)^[0] > pac32(PChar(p)+160)^[0] then begin
   pac64(PChar(p)+351)^[0] := pac64(PChar(p)+351)^[0] xor (pac64(PChar(p)+446)^[0] or $2a0daacf89);
   pac16(PChar(p)+296)^[0] := pac16(PChar(p)+296)^[0] + (pac16(PChar(p)+121)^[0] + $96);
 end;

 pac32(PChar(p)+298)^[0] := ror2(pac32(PChar(p)+65)^[0] , 20 );
 pac64(PChar(p)+347)^[0] := pac64(PChar(p)+347)^[0] - (pac64(PChar(p)+337)^[0] xor $502cadb3);

 if pac8(PChar(p)+252)^[0] > pac8(PChar(p)+334)^[0] then begin
   if pac64(PChar(p)+398)^[0] > pac64(PChar(p)+34)^[0] then pac32(PChar(p)+196)^[0] := pac32(PChar(p)+196)^[0] xor rol1(pac32(PChar(p)+206)^[0] , 19 ) else pac64(PChar(p)+362)^[0] := pac64(PChar(p)+362)^[0] - (pac64(PChar(p)+6)^[0] + $dc57c83ad3);
   num := pac8(PChar(p)+403)^[0]; pac8(PChar(p)+403)^[0] := pac8(PChar(p)+276)^[0]; pac8(PChar(p)+276)^[0] := num;
   if pac32(PChar(p)+447)^[0] > pac32(PChar(p)+421)^[0] then pac32(PChar(p)+426)^[0] := pac32(PChar(p)+426)^[0] + (pac32(PChar(p)+321)^[0] or $7444ed) else begin  num := pac16(PChar(p)+448)^[0]; pac16(PChar(p)+448)^[0] := pac16(PChar(p)+402)^[0]; pac16(PChar(p)+402)^[0] := num; end;
   pac32(PChar(p)+407)^[0] := pac32(PChar(p)+407)^[0] + $e0a2;
   if pac32(PChar(p)+330)^[0] > pac32(PChar(p)+245)^[0] then pac64(PChar(p)+12)^[0] := pac64(PChar(p)+12)^[0] xor (pac64(PChar(p)+76)^[0] - $6e4daf82) else pac64(PChar(p)+334)^[0] := pac64(PChar(p)+369)^[0] or (pac64(PChar(p)+25)^[0] xor $bca70c0f);
 end;


D2E7402D(p);

end;

procedure D2E7402D(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+465)^[0] := pac32(PChar(p)+465)^[0] or $d4fc;
 pac64(PChar(p)+69)^[0] := pac64(PChar(p)+69)^[0] + (pac64(PChar(p)+501)^[0] xor $e2caac343b);
 pac64(PChar(p)+136)^[0] := pac64(PChar(p)+334)^[0] or $0af1eaea7e4f;
 num := pac8(PChar(p)+461)^[0]; pac8(PChar(p)+461)^[0] := pac8(PChar(p)+392)^[0]; pac8(PChar(p)+392)^[0] := num;
 pac64(PChar(p)+71)^[0] := pac64(PChar(p)+71)^[0] or $5e0a213e4e03;

 if pac64(PChar(p)+133)^[0] > pac64(PChar(p)+119)^[0] then begin
   pac64(PChar(p)+223)^[0] := pac64(PChar(p)+335)^[0] - (pac64(PChar(p)+67)^[0] xor $746a1bff);
   num := pac16(PChar(p)+419)^[0]; pac16(PChar(p)+419)^[0] := pac16(PChar(p)+246)^[0]; pac16(PChar(p)+246)^[0] := num;
 end;

 pac8(PChar(p)+115)^[0] := pac8(PChar(p)+115)^[0] or (pac8(PChar(p)+11)^[0] - $12);
 pac32(PChar(p)+180)^[0] := pac32(PChar(p)+180)^[0] - ror2(pac32(PChar(p)+313)^[0] , 21 );
 if pac64(PChar(p)+303)^[0] < pac64(PChar(p)+260)^[0] then pac32(PChar(p)+22)^[0] := ror1(pac32(PChar(p)+427)^[0] , 31 ) else pac8(PChar(p)+377)^[0] := pac8(PChar(p)+377)^[0] + $66;

 if pac64(PChar(p)+330)^[0] > pac64(PChar(p)+433)^[0] then begin
   pac16(PChar(p)+269)^[0] := pac16(PChar(p)+269)^[0] - ror2(pac16(PChar(p)+277)^[0] , 3 );
   pac16(PChar(p)+351)^[0] := pac16(PChar(p)+363)^[0] or (pac16(PChar(p)+174)^[0] - $e2);
 end;

 if pac8(PChar(p)+182)^[0] > pac8(PChar(p)+392)^[0] then pac64(PChar(p)+158)^[0] := pac64(PChar(p)+158)^[0] xor (pac64(PChar(p)+26)^[0] + $aaebc74b75) else pac32(PChar(p)+465)^[0] := pac32(PChar(p)+465)^[0] xor ror2(pac32(PChar(p)+398)^[0] , 29 );
 if pac64(PChar(p)+497)^[0] > pac64(PChar(p)+167)^[0] then pac32(PChar(p)+12)^[0] := pac32(PChar(p)+12)^[0] - ror1(pac32(PChar(p)+425)^[0] , 18 ) else begin  num := pac16(PChar(p)+392)^[0]; pac16(PChar(p)+392)^[0] := pac16(PChar(p)+395)^[0]; pac16(PChar(p)+395)^[0] := num; end;
 num := pac32(PChar(p)+53)^[0]; pac32(PChar(p)+53)^[0] := pac32(PChar(p)+283)^[0]; pac32(PChar(p)+283)^[0] := num;
 pac16(PChar(p)+24)^[0] := pac16(PChar(p)+24)^[0] + $fc;

F9518419(p);

end;

procedure F9518419(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+284)^[0] > pac32(PChar(p)+183)^[0] then pac64(PChar(p)+157)^[0] := pac64(PChar(p)+157)^[0] or $aca0b05d08 else begin  num := pac32(PChar(p)+169)^[0]; pac32(PChar(p)+169)^[0] := pac32(PChar(p)+66)^[0]; pac32(PChar(p)+66)^[0] := num; end;
 pac8(PChar(p)+0)^[0] := pac8(PChar(p)+0)^[0] xor ror2(pac8(PChar(p)+479)^[0] , 1 );
 num := pac32(PChar(p)+467)^[0]; pac32(PChar(p)+467)^[0] := pac32(PChar(p)+476)^[0]; pac32(PChar(p)+476)^[0] := num;
 num := pac32(PChar(p)+231)^[0]; pac32(PChar(p)+231)^[0] := pac32(PChar(p)+138)^[0]; pac32(PChar(p)+138)^[0] := num;
 num := pac8(PChar(p)+249)^[0]; pac8(PChar(p)+249)^[0] := pac8(PChar(p)+504)^[0]; pac8(PChar(p)+504)^[0] := num;
 num := pac8(PChar(p)+466)^[0]; pac8(PChar(p)+466)^[0] := pac8(PChar(p)+420)^[0]; pac8(PChar(p)+420)^[0] := num;
 if pac32(PChar(p)+503)^[0] < pac32(PChar(p)+66)^[0] then pac16(PChar(p)+329)^[0] := pac16(PChar(p)+329)^[0] xor ror2(pac16(PChar(p)+447)^[0] , 11 );
 pac8(PChar(p)+359)^[0] := pac8(PChar(p)+359)^[0] + rol1(pac8(PChar(p)+436)^[0] , 4 );
 if pac32(PChar(p)+453)^[0] > pac32(PChar(p)+158)^[0] then pac32(PChar(p)+37)^[0] := pac32(PChar(p)+37)^[0] or (pac32(PChar(p)+150)^[0] or $42b910) else pac32(PChar(p)+362)^[0] := pac32(PChar(p)+362)^[0] + $8ac7e4;
 pac64(PChar(p)+301)^[0] := pac64(PChar(p)+301)^[0] xor (pac64(PChar(p)+275)^[0] - $d6e3b840a6dc);
 pac32(PChar(p)+371)^[0] := pac32(PChar(p)+371)^[0] xor (pac32(PChar(p)+178)^[0] - $9ec8);
 pac8(PChar(p)+401)^[0] := pac8(PChar(p)+188)^[0] + $7e;
 num := pac32(PChar(p)+500)^[0]; pac32(PChar(p)+500)^[0] := pac32(PChar(p)+121)^[0]; pac32(PChar(p)+121)^[0] := num;

D279DF34(p);

end;

procedure D279DF34(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+177)^[0] := pac16(PChar(p)+190)^[0] or $64;
 pac8(PChar(p)+464)^[0] := pac8(PChar(p)+27)^[0] xor $ac;
 pac32(PChar(p)+176)^[0] := rol1(pac32(PChar(p)+139)^[0] , 28 );
 pac16(PChar(p)+394)^[0] := pac16(PChar(p)+394)^[0] or ror2(pac16(PChar(p)+1)^[0] , 4 );
 pac8(PChar(p)+208)^[0] := ror1(pac8(PChar(p)+75)^[0] , 6 );
 pac64(PChar(p)+232)^[0] := pac64(PChar(p)+232)^[0] xor (pac64(PChar(p)+125)^[0] xor $ca0f00eef8);
 pac16(PChar(p)+176)^[0] := pac16(PChar(p)+176)^[0] - (pac16(PChar(p)+306)^[0] xor $2e);

 if pac32(PChar(p)+258)^[0] > pac32(PChar(p)+442)^[0] then begin
   pac32(PChar(p)+375)^[0] := pac32(PChar(p)+478)^[0] + $1a06c5;
   pac32(PChar(p)+276)^[0] := pac32(PChar(p)+276)^[0] - $ced8;
   pac32(PChar(p)+488)^[0] := pac32(PChar(p)+488)^[0] or ror2(pac32(PChar(p)+264)^[0] , 30 );
 end;


 if pac16(PChar(p)+110)^[0] < pac16(PChar(p)+151)^[0] then begin
   pac8(PChar(p)+240)^[0] := pac8(PChar(p)+318)^[0] + $4c;
   pac8(PChar(p)+471)^[0] := pac8(PChar(p)+471)^[0] or ror2(pac8(PChar(p)+15)^[0] , 3 );
   pac32(PChar(p)+386)^[0] := pac32(PChar(p)+386)^[0] + $ba90c9;
 end;

 num := pac16(PChar(p)+291)^[0]; pac16(PChar(p)+291)^[0] := pac16(PChar(p)+273)^[0]; pac16(PChar(p)+273)^[0] := num;

 if pac16(PChar(p)+185)^[0] > pac16(PChar(p)+260)^[0] then begin
   num := pac8(PChar(p)+224)^[0]; pac8(PChar(p)+224)^[0] := pac8(PChar(p)+144)^[0]; pac8(PChar(p)+144)^[0] := num;
   pac32(PChar(p)+127)^[0] := ror2(pac32(PChar(p)+149)^[0] , 6 );
 end;

 pac32(PChar(p)+177)^[0] := pac32(PChar(p)+177)^[0] - $7e5a66;
 pac32(PChar(p)+320)^[0] := pac32(PChar(p)+320)^[0] or ror1(pac32(PChar(p)+376)^[0] , 26 );
 pac16(PChar(p)+451)^[0] := pac16(PChar(p)+178)^[0] xor (pac16(PChar(p)+389)^[0] + $70);
 pac8(PChar(p)+165)^[0] := pac8(PChar(p)+165)^[0] - ror2(pac8(PChar(p)+440)^[0] , 2 );
 pac8(PChar(p)+383)^[0] := pac8(PChar(p)+383)^[0] xor ror2(pac8(PChar(p)+301)^[0] , 4 );

 if pac64(PChar(p)+11)^[0] > pac64(PChar(p)+210)^[0] then begin
   num := pac32(PChar(p)+321)^[0]; pac32(PChar(p)+321)^[0] := pac32(PChar(p)+204)^[0]; pac32(PChar(p)+204)^[0] := num;
   if pac16(PChar(p)+125)^[0] < pac16(PChar(p)+279)^[0] then pac32(PChar(p)+224)^[0] := pac32(PChar(p)+224)^[0] + ror1(pac32(PChar(p)+360)^[0] , 29 );
 end;


B5429722(p);

end;

procedure B5429722(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+13)^[0] := pac64(PChar(p)+404)^[0] or $b6e110d8;
 pac64(PChar(p)+250)^[0] := pac64(PChar(p)+304)^[0] - $b2186dc34cca;
 pac32(PChar(p)+194)^[0] := pac32(PChar(p)+194)^[0] xor (pac32(PChar(p)+423)^[0] - $a68755);
 num := pac16(PChar(p)+149)^[0]; pac16(PChar(p)+149)^[0] := pac16(PChar(p)+288)^[0]; pac16(PChar(p)+288)^[0] := num;
 num := pac8(PChar(p)+362)^[0]; pac8(PChar(p)+362)^[0] := pac8(PChar(p)+332)^[0]; pac8(PChar(p)+332)^[0] := num;
 num := pac8(PChar(p)+48)^[0]; pac8(PChar(p)+48)^[0] := pac8(PChar(p)+183)^[0]; pac8(PChar(p)+183)^[0] := num;
 if pac32(PChar(p)+381)^[0] > pac32(PChar(p)+448)^[0] then pac32(PChar(p)+37)^[0] := pac32(PChar(p)+37)^[0] xor (pac32(PChar(p)+227)^[0] or $16bcc5) else pac32(PChar(p)+150)^[0] := pac32(PChar(p)+150)^[0] - (pac32(PChar(p)+268)^[0] + $c45f);
 pac8(PChar(p)+178)^[0] := pac8(PChar(p)+178)^[0] + $cc;
 pac8(PChar(p)+382)^[0] := pac8(PChar(p)+382)^[0] + rol1(pac8(PChar(p)+252)^[0] , 2 );
 pac64(PChar(p)+27)^[0] := pac64(PChar(p)+27)^[0] + (pac64(PChar(p)+22)^[0] - $04a280e1a3);
 if pac64(PChar(p)+30)^[0] > pac64(PChar(p)+403)^[0] then pac8(PChar(p)+280)^[0] := pac8(PChar(p)+280)^[0] + ror2(pac8(PChar(p)+394)^[0] , 1 );

A748F146(p);

end;

procedure A748F146(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+237)^[0]; pac32(PChar(p)+237)^[0] := pac32(PChar(p)+434)^[0]; pac32(PChar(p)+434)^[0] := num;
 num := pac8(PChar(p)+180)^[0]; pac8(PChar(p)+180)^[0] := pac8(PChar(p)+454)^[0]; pac8(PChar(p)+454)^[0] := num;
 if pac8(PChar(p)+269)^[0] > pac8(PChar(p)+5)^[0] then pac8(PChar(p)+16)^[0] := pac8(PChar(p)+16)^[0] xor ror1(pac8(PChar(p)+406)^[0] , 2 ) else pac64(PChar(p)+263)^[0] := pac64(PChar(p)+263)^[0] + (pac64(PChar(p)+389)^[0] or $5e10f040);
 pac32(PChar(p)+485)^[0] := pac32(PChar(p)+485)^[0] xor $9c0166;
 pac8(PChar(p)+90)^[0] := pac8(PChar(p)+238)^[0] or (pac8(PChar(p)+422)^[0] xor $12);
 pac32(PChar(p)+289)^[0] := pac32(PChar(p)+289)^[0] - $1e2203;
 if pac16(PChar(p)+211)^[0] > pac16(PChar(p)+429)^[0] then pac8(PChar(p)+444)^[0] := pac8(PChar(p)+444)^[0] - $d2 else begin  num := pac8(PChar(p)+173)^[0]; pac8(PChar(p)+173)^[0] := pac8(PChar(p)+407)^[0]; pac8(PChar(p)+407)^[0] := num; end;
 pac16(PChar(p)+10)^[0] := ror1(pac16(PChar(p)+299)^[0] , 14 );
 pac16(PChar(p)+459)^[0] := pac16(PChar(p)+459)^[0] or $0e;

 if pac16(PChar(p)+205)^[0] < pac16(PChar(p)+263)^[0] then begin
   if pac64(PChar(p)+240)^[0] > pac64(PChar(p)+369)^[0] then begin  num := pac32(PChar(p)+358)^[0]; pac32(PChar(p)+358)^[0] := pac32(PChar(p)+195)^[0]; pac32(PChar(p)+195)^[0] := num; end else pac64(PChar(p)+435)^[0] := pac64(PChar(p)+435)^[0] xor (pac64(PChar(p)+113)^[0] xor $40170b1bb2d8);
   pac64(PChar(p)+121)^[0] := pac64(PChar(p)+380)^[0] - $6c973664e3;
   num := pac16(PChar(p)+215)^[0]; pac16(PChar(p)+215)^[0] := pac16(PChar(p)+65)^[0]; pac16(PChar(p)+65)^[0] := num;
 end;

 pac64(PChar(p)+96)^[0] := pac64(PChar(p)+96)^[0] xor (pac64(PChar(p)+372)^[0] - $d831d28596b9);

 if pac64(PChar(p)+351)^[0] < pac64(PChar(p)+184)^[0] then begin
   num := pac32(PChar(p)+91)^[0]; pac32(PChar(p)+91)^[0] := pac32(PChar(p)+64)^[0]; pac32(PChar(p)+64)^[0] := num;
   pac8(PChar(p)+191)^[0] := pac8(PChar(p)+191)^[0] - ror2(pac8(PChar(p)+119)^[0] , 7 );
 end;


E7C3D3C6(p);

end;

procedure E7C3D3C6(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+77)^[0] > pac16(PChar(p)+408)^[0] then pac8(PChar(p)+305)^[0] := pac8(PChar(p)+305)^[0] xor rol1(pac8(PChar(p)+174)^[0] , 2 );
 if pac16(PChar(p)+313)^[0] < pac16(PChar(p)+155)^[0] then pac8(PChar(p)+254)^[0] := ror1(pac8(PChar(p)+501)^[0] , 6 ) else pac64(PChar(p)+442)^[0] := pac64(PChar(p)+442)^[0] + $6ef215c1;

 if pac8(PChar(p)+312)^[0] < pac8(PChar(p)+119)^[0] then begin
   num := pac16(PChar(p)+379)^[0]; pac16(PChar(p)+379)^[0] := pac16(PChar(p)+424)^[0]; pac16(PChar(p)+424)^[0] := num;
   num := pac8(PChar(p)+124)^[0]; pac8(PChar(p)+124)^[0] := pac8(PChar(p)+331)^[0]; pac8(PChar(p)+331)^[0] := num;
 end;

 if pac32(PChar(p)+219)^[0] < pac32(PChar(p)+144)^[0] then begin  num := pac32(PChar(p)+227)^[0]; pac32(PChar(p)+227)^[0] := pac32(PChar(p)+265)^[0]; pac32(PChar(p)+265)^[0] := num; end else pac32(PChar(p)+157)^[0] := pac32(PChar(p)+157)^[0] - (pac32(PChar(p)+56)^[0] or $cc1d7e);
 pac16(PChar(p)+311)^[0] := pac16(PChar(p)+311)^[0] - $10;
 pac32(PChar(p)+86)^[0] := pac32(PChar(p)+83)^[0] + $9af3;
 pac8(PChar(p)+28)^[0] := pac8(PChar(p)+28)^[0] xor ror1(pac8(PChar(p)+74)^[0] , 1 );

 if pac16(PChar(p)+171)^[0] < pac16(PChar(p)+329)^[0] then begin
   pac64(PChar(p)+146)^[0] := pac64(PChar(p)+146)^[0] or (pac64(PChar(p)+357)^[0] - $129b1dcb41);
   pac64(PChar(p)+298)^[0] := pac64(PChar(p)+298)^[0] or (pac64(PChar(p)+443)^[0] - $78f19e7d);
   if pac32(PChar(p)+269)^[0] < pac32(PChar(p)+205)^[0] then pac8(PChar(p)+283)^[0] := pac8(PChar(p)+283)^[0] or (pac8(PChar(p)+163)^[0] - $e2) else pac8(PChar(p)+444)^[0] := pac8(PChar(p)+444)^[0] + ror2(pac8(PChar(p)+58)^[0] , 1 );
   pac8(PChar(p)+258)^[0] := pac8(PChar(p)+258)^[0] - (pac8(PChar(p)+293)^[0] + $3e);
 end;

 pac32(PChar(p)+324)^[0] := pac32(PChar(p)+324)^[0] - (pac32(PChar(p)+192)^[0] - $565d78);
 pac32(PChar(p)+351)^[0] := pac32(PChar(p)+351)^[0] + $10d1e6;

 if pac8(PChar(p)+137)^[0] > pac8(PChar(p)+348)^[0] then begin
   pac8(PChar(p)+467)^[0] := pac8(PChar(p)+467)^[0] + $e6;
   if pac32(PChar(p)+132)^[0] > pac32(PChar(p)+193)^[0] then pac8(PChar(p)+404)^[0] := ror1(pac8(PChar(p)+69)^[0] , 6 ) else pac64(PChar(p)+311)^[0] := pac64(PChar(p)+351)^[0] or (pac64(PChar(p)+492)^[0] xor $5c004ab1eb);
   pac8(PChar(p)+87)^[0] := pac8(PChar(p)+87)^[0] - ror2(pac8(PChar(p)+297)^[0] , 4 );
   pac32(PChar(p)+410)^[0] := rol1(pac32(PChar(p)+369)^[0] , 31 );
   pac64(PChar(p)+439)^[0] := pac64(PChar(p)+251)^[0] - (pac64(PChar(p)+201)^[0] xor $c6e18631);
 end;


BD7AE5F9(p);

end;

procedure BD7AE5F9(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+39)^[0]; pac16(PChar(p)+39)^[0] := pac16(PChar(p)+487)^[0]; pac16(PChar(p)+487)^[0] := num;
 num := pac8(PChar(p)+208)^[0]; pac8(PChar(p)+208)^[0] := pac8(PChar(p)+131)^[0]; pac8(PChar(p)+131)^[0] := num;
 num := pac8(PChar(p)+281)^[0]; pac8(PChar(p)+281)^[0] := pac8(PChar(p)+473)^[0]; pac8(PChar(p)+473)^[0] := num;
 pac16(PChar(p)+144)^[0] := pac16(PChar(p)+144)^[0] + (pac16(PChar(p)+209)^[0] + $40);
 pac16(PChar(p)+452)^[0] := pac16(PChar(p)+452)^[0] - ror2(pac16(PChar(p)+258)^[0] , 14 );
 pac32(PChar(p)+245)^[0] := pac32(PChar(p)+245)^[0] or (pac32(PChar(p)+59)^[0] xor $188b);
 pac8(PChar(p)+274)^[0] := pac8(PChar(p)+201)^[0] xor (pac8(PChar(p)+426)^[0] or $10);
 pac32(PChar(p)+471)^[0] := pac32(PChar(p)+471)^[0] - $b4aedf;
 pac16(PChar(p)+288)^[0] := pac16(PChar(p)+447)^[0] xor (pac16(PChar(p)+90)^[0] xor $1c);
 pac64(PChar(p)+187)^[0] := pac64(PChar(p)+187)^[0] or (pac64(PChar(p)+221)^[0] or $502ef48851);
 num := pac32(PChar(p)+97)^[0]; pac32(PChar(p)+97)^[0] := pac32(PChar(p)+49)^[0]; pac32(PChar(p)+49)^[0] := num;

DD194BE6(p);

end;

procedure DD194BE6(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+384)^[0] := pac64(PChar(p)+384)^[0] xor (pac64(PChar(p)+38)^[0] xor $322dd099);
 pac16(PChar(p)+31)^[0] := pac16(PChar(p)+31)^[0] + $18;
 if pac32(PChar(p)+270)^[0] < pac32(PChar(p)+138)^[0] then begin  num := pac16(PChar(p)+235)^[0]; pac16(PChar(p)+235)^[0] := pac16(PChar(p)+405)^[0]; pac16(PChar(p)+405)^[0] := num; end else pac64(PChar(p)+478)^[0] := pac64(PChar(p)+25)^[0] + (pac64(PChar(p)+302)^[0] + $a46a7fc9287b);
 if pac16(PChar(p)+367)^[0] > pac16(PChar(p)+168)^[0] then begin  num := pac16(PChar(p)+419)^[0]; pac16(PChar(p)+419)^[0] := pac16(PChar(p)+393)^[0]; pac16(PChar(p)+393)^[0] := num; end else pac16(PChar(p)+280)^[0] := pac16(PChar(p)+280)^[0] - (pac16(PChar(p)+479)^[0] - $26);
 if pac32(PChar(p)+81)^[0] < pac32(PChar(p)+280)^[0] then begin  num := pac32(PChar(p)+416)^[0]; pac32(PChar(p)+416)^[0] := pac32(PChar(p)+210)^[0]; pac32(PChar(p)+210)^[0] := num; end else pac32(PChar(p)+260)^[0] := pac32(PChar(p)+27)^[0] - (pac32(PChar(p)+192)^[0] - $82c2);
 pac32(PChar(p)+288)^[0] := pac32(PChar(p)+288)^[0] + $62c1;

 if pac16(PChar(p)+342)^[0] > pac16(PChar(p)+186)^[0] then begin
   pac8(PChar(p)+277)^[0] := pac8(PChar(p)+274)^[0] xor $04;
   pac64(PChar(p)+346)^[0] := pac64(PChar(p)+346)^[0] xor $dc69d2317b;
   pac32(PChar(p)+395)^[0] := pac32(PChar(p)+395)^[0] - rol1(pac32(PChar(p)+376)^[0] , 22 );
   pac16(PChar(p)+210)^[0] := ror2(pac16(PChar(p)+451)^[0] , 4 );
 end;

 if pac8(PChar(p)+390)^[0] < pac8(PChar(p)+15)^[0] then pac32(PChar(p)+186)^[0] := pac32(PChar(p)+186)^[0] - rol1(pac32(PChar(p)+305)^[0] , 16 ) else pac64(PChar(p)+461)^[0] := pac64(PChar(p)+461)^[0] - (pac64(PChar(p)+385)^[0] xor $461c72ed6e);
 num := pac32(PChar(p)+353)^[0]; pac32(PChar(p)+353)^[0] := pac32(PChar(p)+365)^[0]; pac32(PChar(p)+365)^[0] := num;
 num := pac32(PChar(p)+135)^[0]; pac32(PChar(p)+135)^[0] := pac32(PChar(p)+38)^[0]; pac32(PChar(p)+38)^[0] := num;
 num := pac16(PChar(p)+114)^[0]; pac16(PChar(p)+114)^[0] := pac16(PChar(p)+244)^[0]; pac16(PChar(p)+244)^[0] := num;

 if pac64(PChar(p)+118)^[0] > pac64(PChar(p)+406)^[0] then begin
   num := pac32(PChar(p)+437)^[0]; pac32(PChar(p)+437)^[0] := pac32(PChar(p)+215)^[0]; pac32(PChar(p)+215)^[0] := num;
   pac16(PChar(p)+222)^[0] := rol1(pac16(PChar(p)+136)^[0] , 7 );
 end;

 if pac64(PChar(p)+160)^[0] > pac64(PChar(p)+502)^[0] then pac32(PChar(p)+198)^[0] := pac32(PChar(p)+198)^[0] xor ror2(pac32(PChar(p)+501)^[0] , 24 );
 num := pac32(PChar(p)+259)^[0]; pac32(PChar(p)+259)^[0] := pac32(PChar(p)+484)^[0]; pac32(PChar(p)+484)^[0] := num;
 num := pac16(PChar(p)+499)^[0]; pac16(PChar(p)+499)^[0] := pac16(PChar(p)+486)^[0]; pac16(PChar(p)+486)^[0] := num;
 if pac16(PChar(p)+256)^[0] < pac16(PChar(p)+502)^[0] then pac64(PChar(p)+308)^[0] := pac64(PChar(p)+308)^[0] - $c444e0345e6d else begin  num := pac8(PChar(p)+85)^[0]; pac8(PChar(p)+85)^[0] := pac8(PChar(p)+391)^[0]; pac8(PChar(p)+391)^[0] := num; end;
 pac16(PChar(p)+120)^[0] := pac16(PChar(p)+120)^[0] + $ac;
 pac32(PChar(p)+193)^[0] := pac32(PChar(p)+193)^[0] + $2298;

 if pac8(PChar(p)+374)^[0] > pac8(PChar(p)+53)^[0] then begin
   pac8(PChar(p)+373)^[0] := pac8(PChar(p)+373)^[0] or ror1(pac8(PChar(p)+481)^[0] , 6 );
   pac16(PChar(p)+341)^[0] := pac16(PChar(p)+341)^[0] + $72;
   pac32(PChar(p)+402)^[0] := pac32(PChar(p)+402)^[0] + ror2(pac32(PChar(p)+413)^[0] , 20 );
 end;


E4CA915C(p);

end;

procedure E4CA915C(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+242)^[0] := pac16(PChar(p)+242)^[0] xor (pac16(PChar(p)+250)^[0] + $46);
 pac32(PChar(p)+441)^[0] := pac32(PChar(p)+441)^[0] xor ror1(pac32(PChar(p)+354)^[0] , 17 );

 if pac32(PChar(p)+391)^[0] < pac32(PChar(p)+330)^[0] then begin
   if pac16(PChar(p)+396)^[0] > pac16(PChar(p)+65)^[0] then pac32(PChar(p)+342)^[0] := pac32(PChar(p)+185)^[0] xor (pac32(PChar(p)+101)^[0] or $eea5) else pac16(PChar(p)+206)^[0] := ror2(pac16(PChar(p)+244)^[0] , 8 );
   pac16(PChar(p)+20)^[0] := pac16(PChar(p)+20)^[0] - $6a;
 end;

 pac64(PChar(p)+466)^[0] := pac64(PChar(p)+466)^[0] xor $7e0ad52133ba;
 num := pac32(PChar(p)+493)^[0]; pac32(PChar(p)+493)^[0] := pac32(PChar(p)+239)^[0]; pac32(PChar(p)+239)^[0] := num;
 pac64(PChar(p)+153)^[0] := pac64(PChar(p)+153)^[0] or $1af602df7b;
 num := pac32(PChar(p)+162)^[0]; pac32(PChar(p)+162)^[0] := pac32(PChar(p)+472)^[0]; pac32(PChar(p)+472)^[0] := num;
 if pac64(PChar(p)+148)^[0] > pac64(PChar(p)+235)^[0] then begin  num := pac16(PChar(p)+414)^[0]; pac16(PChar(p)+414)^[0] := pac16(PChar(p)+510)^[0]; pac16(PChar(p)+510)^[0] := num; end else pac16(PChar(p)+31)^[0] := pac16(PChar(p)+31)^[0] xor ror2(pac16(PChar(p)+3)^[0] , 5 );
 pac16(PChar(p)+384)^[0] := pac16(PChar(p)+384)^[0] or ror1(pac16(PChar(p)+117)^[0] , 10 );
 pac16(PChar(p)+413)^[0] := pac16(PChar(p)+413)^[0] - ror2(pac16(PChar(p)+105)^[0] , 7 );

E5673FE4(p);

end;

procedure E5673FE4(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+434)^[0] < pac8(PChar(p)+293)^[0] then pac16(PChar(p)+430)^[0] := pac16(PChar(p)+430)^[0] + (pac16(PChar(p)+245)^[0] + $d2);
 num := pac32(PChar(p)+382)^[0]; pac32(PChar(p)+382)^[0] := pac32(PChar(p)+253)^[0]; pac32(PChar(p)+253)^[0] := num;
 num := pac8(PChar(p)+99)^[0]; pac8(PChar(p)+99)^[0] := pac8(PChar(p)+355)^[0]; pac8(PChar(p)+355)^[0] := num;
 pac64(PChar(p)+66)^[0] := pac64(PChar(p)+66)^[0] - $78a058f7;
 if pac8(PChar(p)+511)^[0] > pac8(PChar(p)+250)^[0] then pac32(PChar(p)+28)^[0] := ror1(pac32(PChar(p)+8)^[0] , 27 ) else pac8(PChar(p)+467)^[0] := pac8(PChar(p)+467)^[0] - $46;

 if pac64(PChar(p)+82)^[0] < pac64(PChar(p)+419)^[0] then begin
   if pac8(PChar(p)+282)^[0] < pac8(PChar(p)+297)^[0] then pac64(PChar(p)+403)^[0] := pac64(PChar(p)+403)^[0] or (pac64(PChar(p)+356)^[0] or $e27fafb76e) else pac32(PChar(p)+136)^[0] := pac32(PChar(p)+136)^[0] + $84a7;
   if pac16(PChar(p)+191)^[0] > pac16(PChar(p)+492)^[0] then pac16(PChar(p)+15)^[0] := pac16(PChar(p)+15)^[0] - ror1(pac16(PChar(p)+111)^[0] , 6 ) else pac16(PChar(p)+271)^[0] := pac16(PChar(p)+271)^[0] or (pac16(PChar(p)+434)^[0] + $74);
 end;

 pac64(PChar(p)+40)^[0] := pac64(PChar(p)+40)^[0] - (pac64(PChar(p)+238)^[0] - $aeb35fe5ab);
 if pac16(PChar(p)+188)^[0] > pac16(PChar(p)+139)^[0] then pac64(PChar(p)+106)^[0] := pac64(PChar(p)+106)^[0] - $e66778ba26d8 else pac8(PChar(p)+348)^[0] := pac8(PChar(p)+348)^[0] or $88;

 if pac32(PChar(p)+30)^[0] > pac32(PChar(p)+408)^[0] then begin
   if pac32(PChar(p)+412)^[0] < pac32(PChar(p)+251)^[0] then pac8(PChar(p)+163)^[0] := pac8(PChar(p)+163)^[0] xor $b0 else pac16(PChar(p)+323)^[0] := pac16(PChar(p)+40)^[0] + (pac16(PChar(p)+33)^[0] - $d4);
   pac32(PChar(p)+435)^[0] := pac32(PChar(p)+435)^[0] + $a24b;
 end;


 if pac16(PChar(p)+324)^[0] < pac16(PChar(p)+246)^[0] then begin
   if pac8(PChar(p)+179)^[0] > pac8(PChar(p)+55)^[0] then pac64(PChar(p)+118)^[0] := pac64(PChar(p)+162)^[0] - $96fd5dff57 else pac32(PChar(p)+202)^[0] := pac32(PChar(p)+202)^[0] - ror2(pac32(PChar(p)+232)^[0] , 20 );
   if pac64(PChar(p)+437)^[0] < pac64(PChar(p)+142)^[0] then pac32(PChar(p)+151)^[0] := ror2(pac32(PChar(p)+48)^[0] , 4 ) else begin  num := pac32(PChar(p)+301)^[0]; pac32(PChar(p)+301)^[0] := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := num; end;
   pac32(PChar(p)+208)^[0] := pac32(PChar(p)+208)^[0] + ror2(pac32(PChar(p)+75)^[0] , 24 );
   pac16(PChar(p)+361)^[0] := pac16(PChar(p)+361)^[0] - (pac16(PChar(p)+464)^[0] or $d6);
   pac16(PChar(p)+160)^[0] := pac16(PChar(p)+160)^[0] xor ror2(pac16(PChar(p)+349)^[0] , 5 );
 end;


FCF714F0(p);

end;

procedure FCF714F0(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+10)^[0] := pac32(PChar(p)+10)^[0] xor ror2(pac32(PChar(p)+414)^[0] , 21 );
 pac32(PChar(p)+190)^[0] := pac32(PChar(p)+190)^[0] xor (pac32(PChar(p)+174)^[0] + $c0d4);
 pac16(PChar(p)+392)^[0] := pac16(PChar(p)+392)^[0] + ror2(pac16(PChar(p)+6)^[0] , 13 );
 num := pac8(PChar(p)+227)^[0]; pac8(PChar(p)+227)^[0] := pac8(PChar(p)+81)^[0]; pac8(PChar(p)+81)^[0] := num;
 pac16(PChar(p)+45)^[0] := pac16(PChar(p)+45)^[0] or ror2(pac16(PChar(p)+246)^[0] , 10 );
 pac64(PChar(p)+316)^[0] := pac64(PChar(p)+316)^[0] or $5a016e9659ed;
 pac16(PChar(p)+261)^[0] := pac16(PChar(p)+261)^[0] + $ee;
 pac8(PChar(p)+36)^[0] := pac8(PChar(p)+36)^[0] xor (pac8(PChar(p)+475)^[0] xor $96);
 pac8(PChar(p)+83)^[0] := ror2(pac8(PChar(p)+23)^[0] , 5 );
 pac16(PChar(p)+482)^[0] := pac16(PChar(p)+482)^[0] or (pac16(PChar(p)+48)^[0] xor $5a);
 if pac32(PChar(p)+175)^[0] < pac32(PChar(p)+455)^[0] then begin  num := pac8(PChar(p)+183)^[0]; pac8(PChar(p)+183)^[0] := pac8(PChar(p)+468)^[0]; pac8(PChar(p)+468)^[0] := num; end else begin  num := pac8(PChar(p)+102)^[0]; pac8(PChar(p)+102)^[0] := pac8(PChar(p)+161)^[0]; pac8(PChar(p)+161)^[0] := num; end;
 pac16(PChar(p)+308)^[0] := pac16(PChar(p)+308)^[0] or ror2(pac16(PChar(p)+186)^[0] , 3 );
 if pac32(PChar(p)+386)^[0] < pac32(PChar(p)+273)^[0] then pac32(PChar(p)+298)^[0] := pac32(PChar(p)+298)^[0] or $96ccaa else pac16(PChar(p)+115)^[0] := pac16(PChar(p)+115)^[0] - (pac16(PChar(p)+440)^[0] + $7e);

FACBBA54(p);

end;

procedure FACBBA54(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+43)^[0] < pac8(PChar(p)+118)^[0] then pac32(PChar(p)+5)^[0] := pac32(PChar(p)+5)^[0] xor rol1(pac32(PChar(p)+208)^[0] , 30 );
 pac8(PChar(p)+197)^[0] := pac8(PChar(p)+197)^[0] + $e8;
 pac32(PChar(p)+481)^[0] := pac32(PChar(p)+247)^[0] + (pac32(PChar(p)+5)^[0] xor $a2a1);

 if pac64(PChar(p)+213)^[0] > pac64(PChar(p)+437)^[0] then begin
   if pac32(PChar(p)+177)^[0] < pac32(PChar(p)+384)^[0] then pac64(PChar(p)+419)^[0] := pac64(PChar(p)+419)^[0] - $ee6800c6 else pac32(PChar(p)+324)^[0] := pac32(PChar(p)+324)^[0] + (pac32(PChar(p)+318)^[0] + $629d);
   pac16(PChar(p)+127)^[0] := pac16(PChar(p)+127)^[0] + rol1(pac16(PChar(p)+54)^[0] , 7 );
   num := pac16(PChar(p)+257)^[0]; pac16(PChar(p)+257)^[0] := pac16(PChar(p)+136)^[0]; pac16(PChar(p)+136)^[0] := num;
   if pac64(PChar(p)+170)^[0] > pac64(PChar(p)+249)^[0] then pac32(PChar(p)+121)^[0] := pac32(PChar(p)+121)^[0] + (pac32(PChar(p)+491)^[0] - $6c1c71) else pac32(PChar(p)+23)^[0] := pac32(PChar(p)+23)^[0] + $da6b;
 end;

 pac64(PChar(p)+4)^[0] := pac64(PChar(p)+4)^[0] xor $3c931249;
 if pac8(PChar(p)+285)^[0] < pac8(PChar(p)+402)^[0] then pac8(PChar(p)+5)^[0] := ror2(pac8(PChar(p)+457)^[0] , 6 ) else pac8(PChar(p)+405)^[0] := pac8(PChar(p)+405)^[0] xor $8a;

 if pac32(PChar(p)+501)^[0] > pac32(PChar(p)+147)^[0] then begin
   num := pac32(PChar(p)+155)^[0]; pac32(PChar(p)+155)^[0] := pac32(PChar(p)+420)^[0]; pac32(PChar(p)+420)^[0] := num;
   pac32(PChar(p)+258)^[0] := pac32(PChar(p)+258)^[0] xor $7234;
 end;


 if pac16(PChar(p)+116)^[0] < pac16(PChar(p)+466)^[0] then begin
   pac16(PChar(p)+44)^[0] := pac16(PChar(p)+44)^[0] - ror2(pac16(PChar(p)+182)^[0] , 12 );
   pac32(PChar(p)+466)^[0] := pac32(PChar(p)+234)^[0] xor (pac32(PChar(p)+75)^[0] - $f040);
   num := pac16(PChar(p)+176)^[0]; pac16(PChar(p)+176)^[0] := pac16(PChar(p)+223)^[0]; pac16(PChar(p)+223)^[0] := num;
   pac64(PChar(p)+444)^[0] := pac64(PChar(p)+444)^[0] xor $3c258ea7;
 end;

 pac16(PChar(p)+510)^[0] := pac16(PChar(p)+297)^[0] + $74;
 pac16(PChar(p)+498)^[0] := pac16(PChar(p)+216)^[0] - (pac16(PChar(p)+426)^[0] xor $ee);
 if pac8(PChar(p)+70)^[0] > pac8(PChar(p)+106)^[0] then pac64(PChar(p)+224)^[0] := pac64(PChar(p)+224)^[0] xor (pac64(PChar(p)+185)^[0] or $10e387b229) else pac8(PChar(p)+64)^[0] := pac8(PChar(p)+64)^[0] xor rol1(pac8(PChar(p)+168)^[0] , 2 );

 if pac8(PChar(p)+272)^[0] < pac8(PChar(p)+497)^[0] then begin
   pac8(PChar(p)+13)^[0] := ror1(pac8(PChar(p)+495)^[0] , 5 );
   pac16(PChar(p)+143)^[0] := pac16(PChar(p)+143)^[0] xor (pac16(PChar(p)+497)^[0] xor $58);
   num := pac16(PChar(p)+194)^[0]; pac16(PChar(p)+194)^[0] := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := num;
 end;

 num := pac32(PChar(p)+428)^[0]; pac32(PChar(p)+428)^[0] := pac32(PChar(p)+96)^[0]; pac32(PChar(p)+96)^[0] := num;
 if pac32(PChar(p)+493)^[0] < pac32(PChar(p)+499)^[0] then pac32(PChar(p)+157)^[0] := pac32(PChar(p)+157)^[0] - $b275e6;
 pac64(PChar(p)+223)^[0] := pac64(PChar(p)+399)^[0] xor (pac64(PChar(p)+61)^[0] - $4a68345bd8);

 if pac16(PChar(p)+104)^[0] > pac16(PChar(p)+25)^[0] then begin
   num := pac32(PChar(p)+5)^[0]; pac32(PChar(p)+5)^[0] := pac32(PChar(p)+62)^[0]; pac32(PChar(p)+62)^[0] := num;
   pac16(PChar(p)+1)^[0] := pac16(PChar(p)+1)^[0] or ror1(pac16(PChar(p)+34)^[0] , 3 );
   pac8(PChar(p)+327)^[0] := pac8(PChar(p)+327)^[0] or ror2(pac8(PChar(p)+108)^[0] , 5 );
 end;

 pac16(PChar(p)+49)^[0] := pac16(PChar(p)+49)^[0] + $d6;
 if pac32(PChar(p)+193)^[0] > pac32(PChar(p)+433)^[0] then pac32(PChar(p)+162)^[0] := pac32(PChar(p)+162)^[0] + (pac32(PChar(p)+131)^[0] - $845f) else pac8(PChar(p)+174)^[0] := pac8(PChar(p)+174)^[0] xor ror1(pac8(PChar(p)+64)^[0] , 2 );

E7E7C532(p);

end;

procedure E7E7C532(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+335)^[0]; pac16(PChar(p)+335)^[0] := pac16(PChar(p)+236)^[0]; pac16(PChar(p)+236)^[0] := num;
 pac16(PChar(p)+158)^[0] := pac16(PChar(p)+87)^[0] + $fa;
 pac16(PChar(p)+110)^[0] := pac16(PChar(p)+110)^[0] or ror1(pac16(PChar(p)+146)^[0] , 1 );
 pac8(PChar(p)+32)^[0] := rol1(pac8(PChar(p)+433)^[0] , 5 );
 pac64(PChar(p)+290)^[0] := pac64(PChar(p)+290)^[0] or $ca06cdc1;

 if pac16(PChar(p)+156)^[0] > pac16(PChar(p)+70)^[0] then begin
   pac64(PChar(p)+22)^[0] := pac64(PChar(p)+431)^[0] - $1c840f43e934;
   if pac16(PChar(p)+51)^[0] < pac16(PChar(p)+206)^[0] then pac32(PChar(p)+4)^[0] := pac32(PChar(p)+4)^[0] + (pac32(PChar(p)+417)^[0] or $086b67) else pac8(PChar(p)+151)^[0] := rol1(pac8(PChar(p)+330)^[0] , 1 );
 end;


 if pac8(PChar(p)+263)^[0] < pac8(PChar(p)+2)^[0] then begin
   if pac32(PChar(p)+340)^[0] < pac32(PChar(p)+484)^[0] then begin  num := pac32(PChar(p)+477)^[0]; pac32(PChar(p)+477)^[0] := pac32(PChar(p)+480)^[0]; pac32(PChar(p)+480)^[0] := num; end else pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] or $9c6345;
   pac32(PChar(p)+205)^[0] := pac32(PChar(p)+205)^[0] + $30ac;
 end;

 pac8(PChar(p)+432)^[0] := pac8(PChar(p)+432)^[0] + ror2(pac8(PChar(p)+61)^[0] , 2 );
 pac32(PChar(p)+459)^[0] := pac32(PChar(p)+459)^[0] + (pac32(PChar(p)+57)^[0] + $7470c6);
 pac64(PChar(p)+483)^[0] := pac64(PChar(p)+483)^[0] xor (pac64(PChar(p)+418)^[0] - $dee21f21);
 pac8(PChar(p)+431)^[0] := pac8(PChar(p)+431)^[0] + (pac8(PChar(p)+92)^[0] - $0a);

D9DC8934(p);

end;

procedure D9DC8934(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+478)^[0] := pac64(PChar(p)+478)^[0] xor (pac64(PChar(p)+406)^[0] - $3c9ca949e51b);

 if pac32(PChar(p)+17)^[0] < pac32(PChar(p)+315)^[0] then begin
   pac16(PChar(p)+253)^[0] := pac16(PChar(p)+253)^[0] + (pac16(PChar(p)+218)^[0] xor $a4);
   pac8(PChar(p)+221)^[0] := pac8(PChar(p)+221)^[0] or ror2(pac8(PChar(p)+454)^[0] , 5 );
   num := pac32(PChar(p)+59)^[0]; pac32(PChar(p)+59)^[0] := pac32(PChar(p)+41)^[0]; pac32(PChar(p)+41)^[0] := num;
   pac8(PChar(p)+278)^[0] := ror1(pac8(PChar(p)+481)^[0] , 2 );
   pac16(PChar(p)+43)^[0] := pac16(PChar(p)+43)^[0] xor $18;
 end;

 num := pac8(PChar(p)+370)^[0]; pac8(PChar(p)+370)^[0] := pac8(PChar(p)+236)^[0]; pac8(PChar(p)+236)^[0] := num;
 num := pac32(PChar(p)+286)^[0]; pac32(PChar(p)+286)^[0] := pac32(PChar(p)+2)^[0]; pac32(PChar(p)+2)^[0] := num;
 if pac64(PChar(p)+282)^[0] > pac64(PChar(p)+303)^[0] then pac32(PChar(p)+18)^[0] := pac32(PChar(p)+18)^[0] - (pac32(PChar(p)+425)^[0] - $e4f477);
 if pac64(PChar(p)+370)^[0] < pac64(PChar(p)+196)^[0] then pac16(PChar(p)+384)^[0] := pac16(PChar(p)+384)^[0] or $aa else pac64(PChar(p)+243)^[0] := pac64(PChar(p)+243)^[0] or $d01693a126;
 if pac8(PChar(p)+199)^[0] > pac8(PChar(p)+16)^[0] then begin  num := pac32(PChar(p)+447)^[0]; pac32(PChar(p)+447)^[0] := pac32(PChar(p)+489)^[0]; pac32(PChar(p)+489)^[0] := num; end else pac64(PChar(p)+87)^[0] := pac64(PChar(p)+87)^[0] xor $c8d8745761;
 pac32(PChar(p)+218)^[0] := pac32(PChar(p)+218)^[0] or ror2(pac32(PChar(p)+241)^[0] , 12 );
 pac64(PChar(p)+102)^[0] := pac64(PChar(p)+102)^[0] or $cc2d9b49d3b7;
 if pac8(PChar(p)+39)^[0] > pac8(PChar(p)+192)^[0] then pac8(PChar(p)+171)^[0] := pac8(PChar(p)+171)^[0] - (pac8(PChar(p)+388)^[0] + $14);
 if pac64(PChar(p)+191)^[0] < pac64(PChar(p)+384)^[0] then pac8(PChar(p)+198)^[0] := pac8(PChar(p)+416)^[0] + (pac8(PChar(p)+243)^[0] - $24) else pac32(PChar(p)+482)^[0] := pac32(PChar(p)+482)^[0] or (pac32(PChar(p)+145)^[0] xor $9c81);
 num := pac8(PChar(p)+302)^[0]; pac8(PChar(p)+302)^[0] := pac8(PChar(p)+89)^[0]; pac8(PChar(p)+89)^[0] := num;

 if pac64(PChar(p)+411)^[0] < pac64(PChar(p)+316)^[0] then begin
   if pac16(PChar(p)+466)^[0] < pac16(PChar(p)+363)^[0] then begin  num := pac8(PChar(p)+480)^[0]; pac8(PChar(p)+480)^[0] := pac8(PChar(p)+114)^[0]; pac8(PChar(p)+114)^[0] := num; end else pac32(PChar(p)+160)^[0] := pac32(PChar(p)+160)^[0] or (pac32(PChar(p)+181)^[0] - $1a72d0);
   pac64(PChar(p)+101)^[0] := pac64(PChar(p)+101)^[0] xor $062662b35fe1;
   pac32(PChar(p)+187)^[0] := pac32(PChar(p)+187)^[0] + rol1(pac32(PChar(p)+43)^[0] , 8 );
 end;

 pac32(PChar(p)+493)^[0] := pac32(PChar(p)+493)^[0] - $f614;
 if pac8(PChar(p)+489)^[0] > pac8(PChar(p)+55)^[0] then pac64(PChar(p)+307)^[0] := pac64(PChar(p)+307)^[0] or (pac64(PChar(p)+156)^[0] + $5ecba2ab6725);
 if pac64(PChar(p)+158)^[0] < pac64(PChar(p)+487)^[0] then pac64(PChar(p)+203)^[0] := pac64(PChar(p)+203)^[0] - $127b2d1eb07b else pac8(PChar(p)+446)^[0] := pac8(PChar(p)+446)^[0] or $4e;
 pac8(PChar(p)+203)^[0] := pac8(PChar(p)+203)^[0] - ror2(pac8(PChar(p)+135)^[0] , 5 );
 pac64(PChar(p)+501)^[0] := pac64(PChar(p)+501)^[0] - (pac64(PChar(p)+272)^[0] + $96e7b94438e5);

D7020F08(p);

end;

procedure D7020F08(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+305)^[0] < pac8(PChar(p)+315)^[0] then pac32(PChar(p)+328)^[0] := pac32(PChar(p)+386)^[0] - (pac32(PChar(p)+400)^[0] - $aaa0) else pac64(PChar(p)+438)^[0] := pac64(PChar(p)+40)^[0] or $d830f8354e;

 if pac16(PChar(p)+312)^[0] > pac16(PChar(p)+440)^[0] then begin
   pac64(PChar(p)+0)^[0] := pac64(PChar(p)+0)^[0] xor $50dd0adf8be5;
   num := pac16(PChar(p)+1)^[0]; pac16(PChar(p)+1)^[0] := pac16(PChar(p)+51)^[0]; pac16(PChar(p)+51)^[0] := num;
 end;

 if pac32(PChar(p)+480)^[0] < pac32(PChar(p)+123)^[0] then begin  num := pac32(PChar(p)+373)^[0]; pac32(PChar(p)+373)^[0] := pac32(PChar(p)+61)^[0]; pac32(PChar(p)+61)^[0] := num; end else pac16(PChar(p)+267)^[0] := pac16(PChar(p)+267)^[0] or $82;
 pac32(PChar(p)+380)^[0] := pac32(PChar(p)+380)^[0] + $d0cf;
 pac8(PChar(p)+106)^[0] := pac8(PChar(p)+106)^[0] - rol1(pac8(PChar(p)+70)^[0] , 2 );
 num := pac8(PChar(p)+243)^[0]; pac8(PChar(p)+243)^[0] := pac8(PChar(p)+423)^[0]; pac8(PChar(p)+423)^[0] := num;

 if pac32(PChar(p)+68)^[0] > pac32(PChar(p)+464)^[0] then begin
   pac16(PChar(p)+486)^[0] := pac16(PChar(p)+486)^[0] xor rol1(pac16(PChar(p)+224)^[0] , 7 );
   num := pac16(PChar(p)+252)^[0]; pac16(PChar(p)+252)^[0] := pac16(PChar(p)+510)^[0]; pac16(PChar(p)+510)^[0] := num;
   pac16(PChar(p)+464)^[0] := pac16(PChar(p)+464)^[0] - (pac16(PChar(p)+77)^[0] + $dc);
 end;

 pac64(PChar(p)+20)^[0] := pac64(PChar(p)+20)^[0] or $44a4fa0c;
 pac64(PChar(p)+47)^[0] := pac64(PChar(p)+146)^[0] or (pac64(PChar(p)+340)^[0] - $a49dd2b6);

 if pac8(PChar(p)+298)^[0] > pac8(PChar(p)+442)^[0] then begin
   pac32(PChar(p)+200)^[0] := pac32(PChar(p)+209)^[0] or $f260e6;
   num := pac8(PChar(p)+510)^[0]; pac8(PChar(p)+510)^[0] := pac8(PChar(p)+256)^[0]; pac8(PChar(p)+256)^[0] := num;
   pac64(PChar(p)+475)^[0] := pac64(PChar(p)+475)^[0] - (pac64(PChar(p)+235)^[0] xor $fcd0e215b6);
 end;

 pac64(PChar(p)+411)^[0] := pac64(PChar(p)+411)^[0] xor $50c54adf18f1;

 if pac32(PChar(p)+12)^[0] > pac32(PChar(p)+175)^[0] then begin
   pac64(PChar(p)+58)^[0] := pac64(PChar(p)+58)^[0] or (pac64(PChar(p)+404)^[0] or $ce6fd742);
   if pac32(PChar(p)+475)^[0] < pac32(PChar(p)+244)^[0] then begin  num := pac16(PChar(p)+335)^[0]; pac16(PChar(p)+335)^[0] := pac16(PChar(p)+460)^[0]; pac16(PChar(p)+460)^[0] := num; end;
   num := pac8(PChar(p)+185)^[0]; pac8(PChar(p)+185)^[0] := pac8(PChar(p)+431)^[0]; pac8(PChar(p)+431)^[0] := num;
 end;

 pac32(PChar(p)+365)^[0] := pac32(PChar(p)+365)^[0] or (pac32(PChar(p)+71)^[0] + $c885);
 if pac64(PChar(p)+189)^[0] < pac64(PChar(p)+354)^[0] then pac64(PChar(p)+304)^[0] := pac64(PChar(p)+304)^[0] - $64315cbe else pac32(PChar(p)+122)^[0] := pac32(PChar(p)+122)^[0] - $2c2762;

 if pac8(PChar(p)+410)^[0] > pac8(PChar(p)+370)^[0] then begin
   if pac32(PChar(p)+278)^[0] > pac32(PChar(p)+254)^[0] then begin  num := pac8(PChar(p)+437)^[0]; pac8(PChar(p)+437)^[0] := pac8(PChar(p)+269)^[0]; pac8(PChar(p)+269)^[0] := num; end else pac64(PChar(p)+267)^[0] := pac64(PChar(p)+267)^[0] - $fa26caa98b;
   pac64(PChar(p)+124)^[0] := pac64(PChar(p)+124)^[0] or (pac64(PChar(p)+182)^[0] xor $e8f7fb7a9f);
 end;

 pac16(PChar(p)+131)^[0] := pac16(PChar(p)+131)^[0] or rol1(pac16(PChar(p)+146)^[0] , 9 );
 if pac8(PChar(p)+35)^[0] < pac8(PChar(p)+456)^[0] then pac64(PChar(p)+47)^[0] := pac64(PChar(p)+47)^[0] + $be43c8afd1b5 else pac16(PChar(p)+500)^[0] := pac16(PChar(p)+500)^[0] xor $52;
 if pac8(PChar(p)+119)^[0] > pac8(PChar(p)+257)^[0] then pac16(PChar(p)+302)^[0] := ror2(pac16(PChar(p)+229)^[0] , 8 );
 pac16(PChar(p)+223)^[0] := pac16(PChar(p)+223)^[0] or ror2(pac16(PChar(p)+4)^[0] , 3 );

DA9765DE(p);

end;

procedure DA9765DE(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+425)^[0] := pac64(PChar(p)+385)^[0] xor $9ce9b8f7f2;
 if pac32(PChar(p)+271)^[0] > pac32(PChar(p)+184)^[0] then pac16(PChar(p)+405)^[0] := rol1(pac16(PChar(p)+498)^[0] , 4 ) else pac64(PChar(p)+440)^[0] := pac64(PChar(p)+440)^[0] or $789d05f8cbd7;

 if pac64(PChar(p)+418)^[0] < pac64(PChar(p)+60)^[0] then begin
   if pac16(PChar(p)+404)^[0] < pac16(PChar(p)+301)^[0] then pac64(PChar(p)+127)^[0] := pac64(PChar(p)+127)^[0] + $d45d380ed5;
   num := pac16(PChar(p)+96)^[0]; pac16(PChar(p)+96)^[0] := pac16(PChar(p)+234)^[0]; pac16(PChar(p)+234)^[0] := num;
   pac8(PChar(p)+449)^[0] := pac8(PChar(p)+290)^[0] or $fc;
   pac32(PChar(p)+335)^[0] := pac32(PChar(p)+335)^[0] or ror2(pac32(PChar(p)+11)^[0] , 3 );
 end;

 pac32(PChar(p)+197)^[0] := pac32(PChar(p)+197)^[0] + $589a;
 num := pac32(PChar(p)+121)^[0]; pac32(PChar(p)+121)^[0] := pac32(PChar(p)+424)^[0]; pac32(PChar(p)+424)^[0] := num;

 if pac64(PChar(p)+164)^[0] < pac64(PChar(p)+199)^[0] then begin
   num := pac32(PChar(p)+21)^[0]; pac32(PChar(p)+21)^[0] := pac32(PChar(p)+484)^[0]; pac32(PChar(p)+484)^[0] := num;
   pac32(PChar(p)+7)^[0] := pac32(PChar(p)+7)^[0] xor $aa989a;
   num := pac8(PChar(p)+53)^[0]; pac8(PChar(p)+53)^[0] := pac8(PChar(p)+182)^[0]; pac8(PChar(p)+182)^[0] := num;
   num := pac32(PChar(p)+58)^[0]; pac32(PChar(p)+58)^[0] := pac32(PChar(p)+146)^[0]; pac32(PChar(p)+146)^[0] := num;
 end;


 if pac16(PChar(p)+120)^[0] < pac16(PChar(p)+18)^[0] then begin
   pac32(PChar(p)+81)^[0] := pac32(PChar(p)+81)^[0] - ror1(pac32(PChar(p)+108)^[0] , 16 );
   pac16(PChar(p)+299)^[0] := pac16(PChar(p)+299)^[0] xor rol1(pac16(PChar(p)+481)^[0] , 13 );
   pac8(PChar(p)+113)^[0] := ror2(pac8(PChar(p)+43)^[0] , 3 );
 end;

 if pac16(PChar(p)+237)^[0] > pac16(PChar(p)+52)^[0] then begin  num := pac8(PChar(p)+437)^[0]; pac8(PChar(p)+437)^[0] := pac8(PChar(p)+508)^[0]; pac8(PChar(p)+508)^[0] := num; end else pac8(PChar(p)+237)^[0] := pac8(PChar(p)+237)^[0] or (pac8(PChar(p)+444)^[0] + $3a);

 if pac8(PChar(p)+501)^[0] < pac8(PChar(p)+489)^[0] then begin
   if pac16(PChar(p)+290)^[0] < pac16(PChar(p)+446)^[0] then begin  num := pac16(PChar(p)+312)^[0]; pac16(PChar(p)+312)^[0] := pac16(PChar(p)+307)^[0]; pac16(PChar(p)+307)^[0] := num; end else pac32(PChar(p)+13)^[0] := pac32(PChar(p)+13)^[0] or ror2(pac32(PChar(p)+132)^[0] , 12 );
   pac8(PChar(p)+120)^[0] := pac8(PChar(p)+120)^[0] + (pac8(PChar(p)+292)^[0] xor $6a);
   pac32(PChar(p)+404)^[0] := pac32(PChar(p)+404)^[0] or (pac32(PChar(p)+193)^[0] or $5a77);
 end;


 if pac16(PChar(p)+389)^[0] < pac16(PChar(p)+237)^[0] then begin
   pac32(PChar(p)+263)^[0] := ror2(pac32(PChar(p)+385)^[0] , 21 );
   num := pac16(PChar(p)+383)^[0]; pac16(PChar(p)+383)^[0] := pac16(PChar(p)+331)^[0]; pac16(PChar(p)+331)^[0] := num;
   pac32(PChar(p)+105)^[0] := pac32(PChar(p)+105)^[0] or ror2(pac32(PChar(p)+499)^[0] , 31 );
   pac16(PChar(p)+430)^[0] := pac16(PChar(p)+430)^[0] or ror2(pac16(PChar(p)+63)^[0] , 8 );
 end;

 pac16(PChar(p)+303)^[0] := pac16(PChar(p)+155)^[0] - $e4;
 if pac64(PChar(p)+54)^[0] > pac64(PChar(p)+480)^[0] then pac16(PChar(p)+221)^[0] := pac16(PChar(p)+221)^[0] or ror2(pac16(PChar(p)+503)^[0] , 5 ) else begin  num := pac8(PChar(p)+102)^[0]; pac8(PChar(p)+102)^[0] := pac8(PChar(p)+158)^[0]; pac8(PChar(p)+158)^[0] := num; end;
 pac64(PChar(p)+19)^[0] := pac64(PChar(p)+19)^[0] - (pac64(PChar(p)+297)^[0] xor $9a4eb738);
 pac64(PChar(p)+342)^[0] := pac64(PChar(p)+342)^[0] xor (pac64(PChar(p)+245)^[0] or $78b755c2);
 if pac32(PChar(p)+52)^[0] > pac32(PChar(p)+355)^[0] then pac32(PChar(p)+200)^[0] := pac32(PChar(p)+360)^[0] + (pac32(PChar(p)+241)^[0] or $40effb) else pac32(PChar(p)+339)^[0] := pac32(PChar(p)+339)^[0] or ror2(pac32(PChar(p)+399)^[0] , 22 );
 pac16(PChar(p)+369)^[0] := pac16(PChar(p)+369)^[0] xor rol1(pac16(PChar(p)+388)^[0] , 9 );
 num := pac8(PChar(p)+486)^[0]; pac8(PChar(p)+486)^[0] := pac8(PChar(p)+172)^[0]; pac8(PChar(p)+172)^[0] := num;

A1B6C6B2(p);

end;

procedure A1B6C6B2(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+290)^[0] := pac32(PChar(p)+290)^[0] xor (pac32(PChar(p)+494)^[0] - $e609);
 num := pac8(PChar(p)+212)^[0]; pac8(PChar(p)+212)^[0] := pac8(PChar(p)+480)^[0]; pac8(PChar(p)+480)^[0] := num;
 if pac32(PChar(p)+388)^[0] < pac32(PChar(p)+436)^[0] then pac64(PChar(p)+218)^[0] := pac64(PChar(p)+218)^[0] or $3c35d177;
 pac64(PChar(p)+245)^[0] := pac64(PChar(p)+206)^[0] xor $04484371f7;
 pac16(PChar(p)+189)^[0] := pac16(PChar(p)+189)^[0] or (pac16(PChar(p)+9)^[0] - $e8);

 if pac16(PChar(p)+19)^[0] < pac16(PChar(p)+268)^[0] then begin
   pac8(PChar(p)+134)^[0] := pac8(PChar(p)+134)^[0] xor rol1(pac8(PChar(p)+177)^[0] , 2 );
   pac32(PChar(p)+350)^[0] := pac32(PChar(p)+350)^[0] or ror2(pac32(PChar(p)+38)^[0] , 18 );
   pac32(PChar(p)+164)^[0] := pac32(PChar(p)+164)^[0] or ror1(pac32(PChar(p)+111)^[0] , 3 );
 end;

 num := pac32(PChar(p)+256)^[0]; pac32(PChar(p)+256)^[0] := pac32(PChar(p)+212)^[0]; pac32(PChar(p)+212)^[0] := num;
 pac64(PChar(p)+165)^[0] := pac64(PChar(p)+165)^[0] + $c84e779c;
 pac64(PChar(p)+487)^[0] := pac64(PChar(p)+487)^[0] + $50cb0e90;
 pac32(PChar(p)+176)^[0] := pac32(PChar(p)+176)^[0] + ror2(pac32(PChar(p)+307)^[0] , 11 );
 if pac64(PChar(p)+6)^[0] < pac64(PChar(p)+430)^[0] then pac32(PChar(p)+205)^[0] := rol1(pac32(PChar(p)+294)^[0] , 6 ) else pac32(PChar(p)+242)^[0] := pac32(PChar(p)+111)^[0] + $fcd4c8;

 if pac64(PChar(p)+39)^[0] < pac64(PChar(p)+402)^[0] then begin
   if pac32(PChar(p)+83)^[0] < pac32(PChar(p)+243)^[0] then pac32(PChar(p)+223)^[0] := pac32(PChar(p)+498)^[0] + (pac32(PChar(p)+328)^[0] xor $2863) else begin  num := pac8(PChar(p)+164)^[0]; pac8(PChar(p)+164)^[0] := pac8(PChar(p)+161)^[0]; pac8(PChar(p)+161)^[0] := num; end;
   pac64(PChar(p)+203)^[0] := pac64(PChar(p)+203)^[0] + $32ab419858;
   num := pac8(PChar(p)+173)^[0]; pac8(PChar(p)+173)^[0] := pac8(PChar(p)+47)^[0]; pac8(PChar(p)+47)^[0] := num;
   pac64(PChar(p)+99)^[0] := pac64(PChar(p)+99)^[0] + $e84a41cd17;
   num := pac8(PChar(p)+440)^[0]; pac8(PChar(p)+440)^[0] := pac8(PChar(p)+122)^[0]; pac8(PChar(p)+122)^[0] := num;
 end;

 num := pac8(PChar(p)+149)^[0]; pac8(PChar(p)+149)^[0] := pac8(PChar(p)+281)^[0]; pac8(PChar(p)+281)^[0] := num;

D0843B77(p);

end;

procedure D0843B77(p: Pointer);
var num: Int64;
begin


 if pac64(PChar(p)+181)^[0] > pac64(PChar(p)+301)^[0] then begin
   pac32(PChar(p)+362)^[0] := pac32(PChar(p)+362)^[0] - $0849d6;
   pac16(PChar(p)+178)^[0] := pac16(PChar(p)+178)^[0] xor (pac16(PChar(p)+147)^[0] xor $d0);
   pac64(PChar(p)+79)^[0] := pac64(PChar(p)+79)^[0] xor $6e122911c9;
 end;

 if pac64(PChar(p)+264)^[0] < pac64(PChar(p)+69)^[0] then begin  num := pac32(PChar(p)+386)^[0]; pac32(PChar(p)+386)^[0] := pac32(PChar(p)+474)^[0]; pac32(PChar(p)+474)^[0] := num; end else pac64(PChar(p)+179)^[0] := pac64(PChar(p)+179)^[0] - $960f65b4;

 if pac64(PChar(p)+53)^[0] < pac64(PChar(p)+346)^[0] then begin
   pac16(PChar(p)+335)^[0] := pac16(PChar(p)+335)^[0] or (pac16(PChar(p)+218)^[0] xor $ca);
   if pac64(PChar(p)+146)^[0] > pac64(PChar(p)+269)^[0] then begin  num := pac32(PChar(p)+35)^[0]; pac32(PChar(p)+35)^[0] := pac32(PChar(p)+31)^[0]; pac32(PChar(p)+31)^[0] := num; end else pac64(PChar(p)+102)^[0] := pac64(PChar(p)+102)^[0] + $5471327e;
   num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+458)^[0]; pac8(PChar(p)+458)^[0] := num;
   pac16(PChar(p)+125)^[0] := pac16(PChar(p)+125)^[0] xor (pac16(PChar(p)+296)^[0] xor $ee);
 end;

 pac64(PChar(p)+105)^[0] := pac64(PChar(p)+105)^[0] xor (pac64(PChar(p)+10)^[0] xor $402b62ccbc0a);
 pac64(PChar(p)+494)^[0] := pac64(PChar(p)+494)^[0] xor $4063d7bc68e1;
 pac64(PChar(p)+141)^[0] := pac64(PChar(p)+141)^[0] or $7eebf23c5f;
 pac8(PChar(p)+84)^[0] := pac8(PChar(p)+150)^[0] - (pac8(PChar(p)+126)^[0] - $2a);

 if pac64(PChar(p)+191)^[0] < pac64(PChar(p)+429)^[0] then begin
   num := pac8(PChar(p)+4)^[0]; pac8(PChar(p)+4)^[0] := pac8(PChar(p)+417)^[0]; pac8(PChar(p)+417)^[0] := num;
   pac8(PChar(p)+451)^[0] := pac8(PChar(p)+451)^[0] + $b8;
   pac32(PChar(p)+473)^[0] := pac32(PChar(p)+473)^[0] + ror2(pac32(PChar(p)+224)^[0] , 8 );
   pac32(PChar(p)+288)^[0] := pac32(PChar(p)+288)^[0] + rol1(pac32(PChar(p)+297)^[0] , 25 );
   pac32(PChar(p)+73)^[0] := pac32(PChar(p)+73)^[0] or (pac32(PChar(p)+429)^[0] or $48ef09);
 end;

 num := pac16(PChar(p)+426)^[0]; pac16(PChar(p)+426)^[0] := pac16(PChar(p)+268)^[0]; pac16(PChar(p)+268)^[0] := num;
 pac32(PChar(p)+432)^[0] := pac32(PChar(p)+335)^[0] xor $488f;

 if pac16(PChar(p)+488)^[0] > pac16(PChar(p)+500)^[0] then begin
   pac8(PChar(p)+192)^[0] := pac8(PChar(p)+192)^[0] or ror1(pac8(PChar(p)+335)^[0] , 6 );
   pac32(PChar(p)+407)^[0] := pac32(PChar(p)+407)^[0] + rol1(pac32(PChar(p)+195)^[0] , 6 );
   num := pac16(PChar(p)+348)^[0]; pac16(PChar(p)+348)^[0] := pac16(PChar(p)+432)^[0]; pac16(PChar(p)+432)^[0] := num;
 end;


 if pac32(PChar(p)+340)^[0] < pac32(PChar(p)+92)^[0] then begin
   pac8(PChar(p)+117)^[0] := pac8(PChar(p)+117)^[0] or ror2(pac8(PChar(p)+5)^[0] , 5 );
   pac64(PChar(p)+373)^[0] := pac64(PChar(p)+373)^[0] or $e04d20f63d;
   if pac8(PChar(p)+334)^[0] > pac8(PChar(p)+410)^[0] then pac8(PChar(p)+15)^[0] := pac8(PChar(p)+15)^[0] xor ror1(pac8(PChar(p)+146)^[0] , 4 );
   pac8(PChar(p)+45)^[0] := pac8(PChar(p)+45)^[0] + ror2(pac8(PChar(p)+134)^[0] , 3 );
   pac32(PChar(p)+418)^[0] := pac32(PChar(p)+418)^[0] + $f4a0;
 end;

 pac8(PChar(p)+158)^[0] := pac8(PChar(p)+158)^[0] xor ror2(pac8(PChar(p)+189)^[0] , 5 );
 pac32(PChar(p)+261)^[0] := pac32(PChar(p)+95)^[0] xor $6c4d;
 pac16(PChar(p)+462)^[0] := pac16(PChar(p)+462)^[0] + $88;

 if pac32(PChar(p)+107)^[0] < pac32(PChar(p)+293)^[0] then begin
   pac16(PChar(p)+450)^[0] := pac16(PChar(p)+450)^[0] + (pac16(PChar(p)+364)^[0] or $d2);
   pac64(PChar(p)+137)^[0] := pac64(PChar(p)+137)^[0] + (pac64(PChar(p)+79)^[0] + $0c73ccff);
 end;

 if pac8(PChar(p)+21)^[0] < pac8(PChar(p)+70)^[0] then pac64(PChar(p)+73)^[0] := pac64(PChar(p)+73)^[0] - $c26b76cc74;

AAF3F545(p);

end;

procedure AAF3F545(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+209)^[0] := pac16(PChar(p)+209)^[0] + ror1(pac16(PChar(p)+110)^[0] , 15 );
 pac16(PChar(p)+396)^[0] := pac16(PChar(p)+396)^[0] + $66;
 pac8(PChar(p)+172)^[0] := pac8(PChar(p)+162)^[0] or $e0;
 pac8(PChar(p)+486)^[0] := pac8(PChar(p)+486)^[0] xor ror2(pac8(PChar(p)+458)^[0] , 7 );
 pac64(PChar(p)+230)^[0] := pac64(PChar(p)+230)^[0] - $0824f8a7b2e8;
 pac64(PChar(p)+382)^[0] := pac64(PChar(p)+382)^[0] xor (pac64(PChar(p)+304)^[0] - $e646ea45);
 pac8(PChar(p)+144)^[0] := pac8(PChar(p)+144)^[0] or ror2(pac8(PChar(p)+29)^[0] , 7 );
 num := pac32(PChar(p)+414)^[0]; pac32(PChar(p)+414)^[0] := pac32(PChar(p)+398)^[0]; pac32(PChar(p)+398)^[0] := num;
 if pac8(PChar(p)+38)^[0] < pac8(PChar(p)+167)^[0] then pac64(PChar(p)+305)^[0] := pac64(PChar(p)+305)^[0] - $1cf2aedb77 else begin  num := pac16(PChar(p)+63)^[0]; pac16(PChar(p)+63)^[0] := pac16(PChar(p)+488)^[0]; pac16(PChar(p)+488)^[0] := num; end;
 if pac64(PChar(p)+176)^[0] > pac64(PChar(p)+304)^[0] then pac64(PChar(p)+241)^[0] := pac64(PChar(p)+241)^[0] xor $523ff0fa3c0c else pac8(PChar(p)+129)^[0] := pac8(PChar(p)+129)^[0] or rol1(pac8(PChar(p)+185)^[0] , 3 );
 pac64(PChar(p)+380)^[0] := pac64(PChar(p)+380)^[0] or (pac64(PChar(p)+180)^[0] + $d8707f25);
 if pac16(PChar(p)+48)^[0] > pac16(PChar(p)+273)^[0] then pac32(PChar(p)+153)^[0] := pac32(PChar(p)+153)^[0] or $52eb;

AD0C273E(p);

end;

procedure AD0C273E(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+342)^[0] := pac32(PChar(p)+342)^[0] + $0c15;
 pac16(PChar(p)+32)^[0] := pac16(PChar(p)+32)^[0] - (pac16(PChar(p)+337)^[0] xor $ce);
 if pac8(PChar(p)+504)^[0] > pac8(PChar(p)+44)^[0] then pac32(PChar(p)+59)^[0] := pac32(PChar(p)+59)^[0] or (pac32(PChar(p)+191)^[0] or $98030f) else pac64(PChar(p)+466)^[0] := pac64(PChar(p)+466)^[0] + (pac64(PChar(p)+323)^[0] + $5cac8ff54990);
 pac16(PChar(p)+412)^[0] := pac16(PChar(p)+412)^[0] + ror2(pac16(PChar(p)+274)^[0] , 3 );

 if pac64(PChar(p)+228)^[0] > pac64(PChar(p)+208)^[0] then begin
   pac64(PChar(p)+49)^[0] := pac64(PChar(p)+49)^[0] or $fedb44365a;
   pac32(PChar(p)+288)^[0] := pac32(PChar(p)+288)^[0] xor (pac32(PChar(p)+258)^[0] - $409b);
   pac64(PChar(p)+188)^[0] := pac64(PChar(p)+188)^[0] or (pac64(PChar(p)+389)^[0] xor $8e289149);
 end;

 pac64(PChar(p)+85)^[0] := pac64(PChar(p)+85)^[0] or $f420d6f1;
 num := pac16(PChar(p)+194)^[0]; pac16(PChar(p)+194)^[0] := pac16(PChar(p)+306)^[0]; pac16(PChar(p)+306)^[0] := num;
 pac32(PChar(p)+425)^[0] := pac32(PChar(p)+425)^[0] - rol1(pac32(PChar(p)+364)^[0] , 16 );
 if pac32(PChar(p)+474)^[0] > pac32(PChar(p)+463)^[0] then pac32(PChar(p)+352)^[0] := pac32(PChar(p)+352)^[0] + $2601 else begin  num := pac8(PChar(p)+191)^[0]; pac8(PChar(p)+191)^[0] := pac8(PChar(p)+259)^[0]; pac8(PChar(p)+259)^[0] := num; end;
 pac64(PChar(p)+206)^[0] := pac64(PChar(p)+321)^[0] or (pac64(PChar(p)+42)^[0] - $5e9ccb4da377);

ADF1DF83(p);

end;

procedure ADF1DF83(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+83)^[0] < pac32(PChar(p)+326)^[0] then begin
   if pac16(PChar(p)+43)^[0] < pac16(PChar(p)+357)^[0] then pac16(PChar(p)+295)^[0] := pac16(PChar(p)+295)^[0] - $a2;
   pac16(PChar(p)+442)^[0] := pac16(PChar(p)+442)^[0] - rol1(pac16(PChar(p)+409)^[0] , 7 );
   if pac64(PChar(p)+484)^[0] > pac64(PChar(p)+138)^[0] then pac32(PChar(p)+309)^[0] := pac32(PChar(p)+309)^[0] xor $cc7ca0 else pac64(PChar(p)+209)^[0] := pac64(PChar(p)+209)^[0] or $d09d5c0d8d9f;
   pac16(PChar(p)+101)^[0] := pac16(PChar(p)+101)^[0] xor ror2(pac16(PChar(p)+491)^[0] , 6 );
 end;

 if pac64(PChar(p)+10)^[0] < pac64(PChar(p)+272)^[0] then pac32(PChar(p)+399)^[0] := pac32(PChar(p)+399)^[0] + ror2(pac32(PChar(p)+471)^[0] , 5 ) else pac16(PChar(p)+107)^[0] := ror2(pac16(PChar(p)+334)^[0] , 8 );
 num := pac32(PChar(p)+437)^[0]; pac32(PChar(p)+437)^[0] := pac32(PChar(p)+374)^[0]; pac32(PChar(p)+374)^[0] := num;
 pac64(PChar(p)+272)^[0] := pac64(PChar(p)+272)^[0] xor $4eccfe585735;
 pac64(PChar(p)+424)^[0] := pac64(PChar(p)+424)^[0] - (pac64(PChar(p)+369)^[0] - $043360dc);
 num := pac8(PChar(p)+487)^[0]; pac8(PChar(p)+487)^[0] := pac8(PChar(p)+205)^[0]; pac8(PChar(p)+205)^[0] := num;
 if pac8(PChar(p)+337)^[0] > pac8(PChar(p)+463)^[0] then pac32(PChar(p)+277)^[0] := pac32(PChar(p)+277)^[0] xor (pac32(PChar(p)+271)^[0] + $64f1) else pac64(PChar(p)+387)^[0] := pac64(PChar(p)+387)^[0] xor $da6930e24c;
 pac16(PChar(p)+420)^[0] := pac16(PChar(p)+420)^[0] - ror1(pac16(PChar(p)+459)^[0] , 9 );
 if pac8(PChar(p)+396)^[0] < pac8(PChar(p)+51)^[0] then begin  num := pac8(PChar(p)+123)^[0]; pac8(PChar(p)+123)^[0] := pac8(PChar(p)+383)^[0]; pac8(PChar(p)+383)^[0] := num; end else begin  num := pac32(PChar(p)+152)^[0]; pac32(PChar(p)+152)^[0] := pac32(PChar(p)+247)^[0]; pac32(PChar(p)+247)^[0] := num; end;
 pac8(PChar(p)+48)^[0] := pac8(PChar(p)+48)^[0] - ror2(pac8(PChar(p)+95)^[0] , 5 );

BE5F0BD6(p);

end;

procedure BE5F0BD6(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+412)^[0]; pac16(PChar(p)+412)^[0] := pac16(PChar(p)+114)^[0]; pac16(PChar(p)+114)^[0] := num;
 if pac16(PChar(p)+62)^[0] < pac16(PChar(p)+508)^[0] then pac32(PChar(p)+236)^[0] := pac32(PChar(p)+236)^[0] + $d6ed else pac16(PChar(p)+436)^[0] := pac16(PChar(p)+283)^[0] xor $72;
 pac64(PChar(p)+39)^[0] := pac64(PChar(p)+39)^[0] or (pac64(PChar(p)+365)^[0] xor $b02ec1c6c863);
 pac8(PChar(p)+107)^[0] := pac8(PChar(p)+107)^[0] xor $c8;
 num := pac32(PChar(p)+444)^[0]; pac32(PChar(p)+444)^[0] := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := num;
 pac32(PChar(p)+471)^[0] := pac32(PChar(p)+471)^[0] xor $a8fb;
 num := pac16(PChar(p)+273)^[0]; pac16(PChar(p)+273)^[0] := pac16(PChar(p)+424)^[0]; pac16(PChar(p)+424)^[0] := num;
 pac8(PChar(p)+29)^[0] := pac8(PChar(p)+29)^[0] + (pac8(PChar(p)+164)^[0] or $b0);
 pac16(PChar(p)+207)^[0] := pac16(PChar(p)+207)^[0] or rol1(pac16(PChar(p)+229)^[0] , 1 );

 if pac64(PChar(p)+401)^[0] < pac64(PChar(p)+52)^[0] then begin
   pac16(PChar(p)+236)^[0] := pac16(PChar(p)+236)^[0] - ror1(pac16(PChar(p)+217)^[0] , 14 );
   pac8(PChar(p)+291)^[0] := pac8(PChar(p)+291)^[0] - $1c;
   pac32(PChar(p)+65)^[0] := pac32(PChar(p)+65)^[0] + $8434;
   pac32(PChar(p)+108)^[0] := pac32(PChar(p)+108)^[0] xor rol1(pac32(PChar(p)+264)^[0] , 3 );
 end;

 pac64(PChar(p)+204)^[0] := pac64(PChar(p)+204)^[0] or $923b4a0f6285;
 pac64(PChar(p)+356)^[0] := pac64(PChar(p)+356)^[0] + $d837620b;
 pac64(PChar(p)+383)^[0] := pac64(PChar(p)+383)^[0] or $6281354e8f;
 pac16(PChar(p)+68)^[0] := pac16(PChar(p)+68)^[0] + rol1(pac16(PChar(p)+329)^[0] , 12 );

 if pac16(PChar(p)+265)^[0] < pac16(PChar(p)+378)^[0] then begin
   num := pac8(PChar(p)+365)^[0]; pac8(PChar(p)+365)^[0] := pac8(PChar(p)+508)^[0]; pac8(PChar(p)+508)^[0] := num;
   pac16(PChar(p)+357)^[0] := pac16(PChar(p)+209)^[0] xor (pac16(PChar(p)+482)^[0] or $fe);
   if pac8(PChar(p)+139)^[0] < pac8(PChar(p)+127)^[0] then pac16(PChar(p)+181)^[0] := ror1(pac16(PChar(p)+384)^[0] , 1 ) else pac32(PChar(p)+330)^[0] := pac32(PChar(p)+46)^[0] - (pac32(PChar(p)+101)^[0] xor $7a3004);
   pac32(PChar(p)+272)^[0] := pac32(PChar(p)+272)^[0] xor $56bf;
   num := pac8(PChar(p)+224)^[0]; pac8(PChar(p)+224)^[0] := pac8(PChar(p)+24)^[0]; pac8(PChar(p)+24)^[0] := num;
 end;


D86879BC(p);

end;

procedure D86879BC(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+262)^[0]; pac8(PChar(p)+262)^[0] := pac8(PChar(p)+489)^[0]; pac8(PChar(p)+489)^[0] := num;
 if pac32(PChar(p)+124)^[0] < pac32(PChar(p)+233)^[0] then pac16(PChar(p)+64)^[0] := pac16(PChar(p)+64)^[0] xor ror2(pac16(PChar(p)+170)^[0] , 7 );

 if pac16(PChar(p)+265)^[0] < pac16(PChar(p)+211)^[0] then begin
   pac16(PChar(p)+158)^[0] := pac16(PChar(p)+152)^[0] + $92;
   pac16(PChar(p)+145)^[0] := pac16(PChar(p)+145)^[0] or $14;
 end;


 if pac8(PChar(p)+507)^[0] > pac8(PChar(p)+269)^[0] then begin
   pac16(PChar(p)+1)^[0] := pac16(PChar(p)+214)^[0] or $92;
   num := pac8(PChar(p)+39)^[0]; pac8(PChar(p)+39)^[0] := pac8(PChar(p)+465)^[0]; pac8(PChar(p)+465)^[0] := num;
   if pac32(PChar(p)+486)^[0] > pac32(PChar(p)+287)^[0] then pac64(PChar(p)+277)^[0] := pac64(PChar(p)+277)^[0] - (pac64(PChar(p)+233)^[0] xor $2477a479);
 end;


 if pac32(PChar(p)+39)^[0] < pac32(PChar(p)+219)^[0] then begin
   pac32(PChar(p)+3)^[0] := pac32(PChar(p)+3)^[0] or $a0dfa4;
   num := pac32(PChar(p)+148)^[0]; pac32(PChar(p)+148)^[0] := pac32(PChar(p)+452)^[0]; pac32(PChar(p)+452)^[0] := num;
   pac64(PChar(p)+280)^[0] := pac64(PChar(p)+280)^[0] - $a816569aaf86;
   num := pac8(PChar(p)+152)^[0]; pac8(PChar(p)+152)^[0] := pac8(PChar(p)+497)^[0]; pac8(PChar(p)+497)^[0] := num;
 end;

 pac8(PChar(p)+471)^[0] := pac8(PChar(p)+471)^[0] xor (pac8(PChar(p)+258)^[0] - $26);
 num := pac32(PChar(p)+487)^[0]; pac32(PChar(p)+487)^[0] := pac32(PChar(p)+362)^[0]; pac32(PChar(p)+362)^[0] := num;
 pac8(PChar(p)+442)^[0] := pac8(PChar(p)+442)^[0] xor ror2(pac8(PChar(p)+113)^[0] , 3 );
 if pac32(PChar(p)+66)^[0] < pac32(PChar(p)+220)^[0] then begin  num := pac8(PChar(p)+78)^[0]; pac8(PChar(p)+78)^[0] := pac8(PChar(p)+107)^[0]; pac8(PChar(p)+107)^[0] := num; end;
 pac64(PChar(p)+93)^[0] := pac64(PChar(p)+93)^[0] + $36ea0147;

 if pac8(PChar(p)+190)^[0] > pac8(PChar(p)+82)^[0] then begin
   pac32(PChar(p)+419)^[0] := pac32(PChar(p)+419)^[0] or (pac32(PChar(p)+6)^[0] or $7efe97);
   pac64(PChar(p)+443)^[0] := pac64(PChar(p)+443)^[0] xor $263eb76e;
 end;

 pac16(PChar(p)+131)^[0] := pac16(PChar(p)+131)^[0] or (pac16(PChar(p)+504)^[0] + $aa);

 if pac8(PChar(p)+398)^[0] < pac8(PChar(p)+158)^[0] then begin
   pac64(PChar(p)+327)^[0] := pac64(PChar(p)+327)^[0] - $56ad927c;
   pac32(PChar(p)+325)^[0] := pac32(PChar(p)+325)^[0] + ror1(pac32(PChar(p)+357)^[0] , 24 );
 end;


D6A1CCAE(p);

end;

procedure D6A1CCAE(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+291)^[0] := pac16(PChar(p)+291)^[0] - $86;
 num := pac8(PChar(p)+366)^[0]; pac8(PChar(p)+366)^[0] := pac8(PChar(p)+302)^[0]; pac8(PChar(p)+302)^[0] := num;
 pac16(PChar(p)+146)^[0] := pac16(PChar(p)+211)^[0] + $2c;
 if pac16(PChar(p)+151)^[0] < pac16(PChar(p)+167)^[0] then begin  num := pac16(PChar(p)+121)^[0]; pac16(PChar(p)+121)^[0] := pac16(PChar(p)+411)^[0]; pac16(PChar(p)+411)^[0] := num; end else pac16(PChar(p)+67)^[0] := pac16(PChar(p)+67)^[0] + ror2(pac16(PChar(p)+1)^[0] , 11 );
 num := pac8(PChar(p)+1)^[0]; pac8(PChar(p)+1)^[0] := pac8(PChar(p)+322)^[0]; pac8(PChar(p)+322)^[0] := num;
 if pac16(PChar(p)+224)^[0] < pac16(PChar(p)+357)^[0] then pac32(PChar(p)+70)^[0] := ror2(pac32(PChar(p)+406)^[0] , 25 ) else begin  num := pac16(PChar(p)+288)^[0]; pac16(PChar(p)+288)^[0] := pac16(PChar(p)+76)^[0]; pac16(PChar(p)+76)^[0] := num; end;

 if pac16(PChar(p)+223)^[0] < pac16(PChar(p)+385)^[0] then begin
   pac32(PChar(p)+234)^[0] := ror2(pac32(PChar(p)+136)^[0] , 18 );
   if pac64(PChar(p)+251)^[0] < pac64(PChar(p)+331)^[0] then pac32(PChar(p)+263)^[0] := pac32(PChar(p)+263)^[0] - ror2(pac32(PChar(p)+123)^[0] , 13 ) else pac16(PChar(p)+482)^[0] := ror2(pac16(PChar(p)+496)^[0] , 12 );
 end;

 pac32(PChar(p)+350)^[0] := pac32(PChar(p)+350)^[0] xor $2add;
 pac32(PChar(p)+251)^[0] := pac32(PChar(p)+251)^[0] xor (pac32(PChar(p)+456)^[0] - $ce2b12);

 if pac16(PChar(p)+357)^[0] > pac16(PChar(p)+140)^[0] then begin
   pac8(PChar(p)+407)^[0] := pac8(PChar(p)+407)^[0] + $84;
   num := pac8(PChar(p)+27)^[0]; pac8(PChar(p)+27)^[0] := pac8(PChar(p)+188)^[0]; pac8(PChar(p)+188)^[0] := num;
   pac64(PChar(p)+343)^[0] := pac64(PChar(p)+343)^[0] + (pac64(PChar(p)+211)^[0] or $102270d6ad);
 end;

 num := pac16(PChar(p)+333)^[0]; pac16(PChar(p)+333)^[0] := pac16(PChar(p)+73)^[0]; pac16(PChar(p)+73)^[0] := num;
 pac64(PChar(p)+358)^[0] := pac64(PChar(p)+396)^[0] or $5a70c1906bcf;

BE2B5A8E(p);

end;

procedure BE2B5A8E(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+355)^[0] := pac64(PChar(p)+355)^[0] or (pac64(PChar(p)+275)^[0] + $307f868a05);
 num := pac16(PChar(p)+404)^[0]; pac16(PChar(p)+404)^[0] := pac16(PChar(p)+137)^[0]; pac16(PChar(p)+137)^[0] := num;
 pac8(PChar(p)+168)^[0] := pac8(PChar(p)+168)^[0] - $18;
 pac64(PChar(p)+448)^[0] := pac64(PChar(p)+448)^[0] + $382beadc63c9;
 pac16(PChar(p)+303)^[0] := pac16(PChar(p)+303)^[0] + ror2(pac16(PChar(p)+96)^[0] , 4 );
 num := pac8(PChar(p)+394)^[0]; pac8(PChar(p)+394)^[0] := pac8(PChar(p)+91)^[0]; pac8(PChar(p)+91)^[0] := num;
 pac16(PChar(p)+468)^[0] := pac16(PChar(p)+468)^[0] or ror2(pac16(PChar(p)+336)^[0] , 1 );
 pac64(PChar(p)+110)^[0] := pac64(PChar(p)+110)^[0] xor $f0301a596652;
 pac64(PChar(p)+262)^[0] := pac64(PChar(p)+262)^[0] xor (pac64(PChar(p)+378)^[0] - $ee8498fa);

 if pac32(PChar(p)+57)^[0] > pac32(PChar(p)+158)^[0] then begin
   pac16(PChar(p)+419)^[0] := pac16(PChar(p)+419)^[0] xor (pac16(PChar(p)+469)^[0] xor $24);
   pac64(PChar(p)+106)^[0] := pac64(PChar(p)+106)^[0] - $266ee92f;
   if pac16(PChar(p)+243)^[0] < pac16(PChar(p)+355)^[0] then begin  num := pac16(PChar(p)+173)^[0]; pac16(PChar(p)+173)^[0] := pac16(PChar(p)+369)^[0]; pac16(PChar(p)+369)^[0] := num; end else pac32(PChar(p)+374)^[0] := pac32(PChar(p)+374)^[0] - ror2(pac32(PChar(p)+214)^[0] , 7 );
 end;

 pac32(PChar(p)+282)^[0] := pac32(PChar(p)+282)^[0] + $ceca;

C67227C5(p);

end;

procedure C67227C5(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+253)^[0] < pac32(PChar(p)+324)^[0] then begin
   pac64(PChar(p)+213)^[0] := pac64(PChar(p)+10)^[0] + (pac64(PChar(p)+88)^[0] or $146a9bce);
   if pac8(PChar(p)+31)^[0] > pac8(PChar(p)+234)^[0] then begin  num := pac16(PChar(p)+111)^[0]; pac16(PChar(p)+111)^[0] := pac16(PChar(p)+134)^[0]; pac16(PChar(p)+134)^[0] := num; end else begin  num := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := pac16(PChar(p)+468)^[0]; pac16(PChar(p)+468)^[0] := num; end;
   pac16(PChar(p)+317)^[0] := pac16(PChar(p)+93)^[0] or $9c;
 end;

 num := pac32(PChar(p)+498)^[0]; pac32(PChar(p)+498)^[0] := pac32(PChar(p)+69)^[0]; pac32(PChar(p)+69)^[0] := num;
 pac64(PChar(p)+72)^[0] := pac64(PChar(p)+72)^[0] + $f00b408c5e;
 pac64(PChar(p)+100)^[0] := pac64(PChar(p)+100)^[0] or $da55ee489970;
 pac8(PChar(p)+341)^[0] := pac8(PChar(p)+341)^[0] xor (pac8(PChar(p)+196)^[0] xor $6c);
 if pac8(PChar(p)+75)^[0] < pac8(PChar(p)+294)^[0] then pac16(PChar(p)+368)^[0] := pac16(PChar(p)+368)^[0] + $64 else pac32(PChar(p)+17)^[0] := pac32(PChar(p)+462)^[0] xor (pac32(PChar(p)+231)^[0] - $8810f5);
 pac16(PChar(p)+171)^[0] := pac16(PChar(p)+171)^[0] xor (pac16(PChar(p)+319)^[0] - $e6);
 num := pac8(PChar(p)+366)^[0]; pac8(PChar(p)+366)^[0] := pac8(PChar(p)+256)^[0]; pac8(PChar(p)+256)^[0] := num;

 if pac16(PChar(p)+2)^[0] > pac16(PChar(p)+503)^[0] then begin
   pac32(PChar(p)+271)^[0] := pac32(PChar(p)+271)^[0] xor (pac32(PChar(p)+169)^[0] + $3ea8);
   pac8(PChar(p)+201)^[0] := pac8(PChar(p)+201)^[0] xor ror2(pac8(PChar(p)+174)^[0] , 3 );
 end;


 if pac64(PChar(p)+176)^[0] < pac64(PChar(p)+345)^[0] then begin
   num := pac16(PChar(p)+368)^[0]; pac16(PChar(p)+368)^[0] := pac16(PChar(p)+0)^[0]; pac16(PChar(p)+0)^[0] := num;
   if pac32(PChar(p)+415)^[0] < pac32(PChar(p)+121)^[0] then pac16(PChar(p)+407)^[0] := pac16(PChar(p)+407)^[0] xor (pac16(PChar(p)+481)^[0] - $8e);
   pac64(PChar(p)+305)^[0] := pac64(PChar(p)+305)^[0] or (pac64(PChar(p)+103)^[0] xor $9228bf547cc4);
   num := pac32(PChar(p)+317)^[0]; pac32(PChar(p)+317)^[0] := pac32(PChar(p)+151)^[0]; pac32(PChar(p)+151)^[0] := num;
 end;


F2FB3E5E(p);

end;

procedure F2FB3E5E(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+229)^[0] := pac64(PChar(p)+229)^[0] or $880b8ef345;
 if pac64(PChar(p)+277)^[0] > pac64(PChar(p)+350)^[0] then pac32(PChar(p)+423)^[0] := pac32(PChar(p)+423)^[0] + (pac32(PChar(p)+88)^[0] or $ccb29f) else pac8(PChar(p)+255)^[0] := pac8(PChar(p)+255)^[0] or ror2(pac8(PChar(p)+454)^[0] , 3 );
 pac64(PChar(p)+140)^[0] := pac64(PChar(p)+140)^[0] - $72abaf71a4c0;

 if pac32(PChar(p)+298)^[0] < pac32(PChar(p)+208)^[0] then begin
   pac8(PChar(p)+261)^[0] := pac8(PChar(p)+261)^[0] xor ror2(pac8(PChar(p)+296)^[0] , 4 );
   pac16(PChar(p)+369)^[0] := pac16(PChar(p)+502)^[0] or (pac16(PChar(p)+253)^[0] + $5e);
   if pac32(PChar(p)+330)^[0] < pac32(PChar(p)+27)^[0] then pac16(PChar(p)+396)^[0] := pac16(PChar(p)+396)^[0] + $06 else pac32(PChar(p)+454)^[0] := pac32(PChar(p)+454)^[0] + ror2(pac32(PChar(p)+468)^[0] , 5 );
 end;

 pac8(PChar(p)+245)^[0] := pac8(PChar(p)+245)^[0] xor ror2(pac8(PChar(p)+452)^[0] , 7 );
 num := pac32(PChar(p)+91)^[0]; pac32(PChar(p)+91)^[0] := pac32(PChar(p)+482)^[0]; pac32(PChar(p)+482)^[0] := num;
 pac64(PChar(p)+178)^[0] := pac64(PChar(p)+357)^[0] or (pac64(PChar(p)+90)^[0] + $8acc9d878cc9);
 if pac64(PChar(p)+474)^[0] > pac64(PChar(p)+184)^[0] then begin  num := pac8(PChar(p)+128)^[0]; pac8(PChar(p)+128)^[0] := pac8(PChar(p)+310)^[0]; pac8(PChar(p)+310)^[0] := num; end else pac16(PChar(p)+29)^[0] := pac16(PChar(p)+464)^[0] or $a2;
 if pac32(PChar(p)+399)^[0] < pac32(PChar(p)+370)^[0] then pac32(PChar(p)+14)^[0] := rol1(pac32(PChar(p)+182)^[0] , 1 ) else pac8(PChar(p)+131)^[0] := pac8(PChar(p)+36)^[0] xor $22;

 if pac8(PChar(p)+435)^[0] < pac8(PChar(p)+335)^[0] then begin
   pac32(PChar(p)+455)^[0] := pac32(PChar(p)+455)^[0] - (pac32(PChar(p)+298)^[0] or $8a05);
   pac32(PChar(p)+356)^[0] := pac32(PChar(p)+356)^[0] or $9ec9ff;
 end;

 pac32(PChar(p)+507)^[0] := ror1(pac32(PChar(p)+338)^[0] , 15 );
 pac16(PChar(p)+499)^[0] := pac16(PChar(p)+499)^[0] xor $6e;
 num := pac8(PChar(p)+136)^[0]; pac8(PChar(p)+136)^[0] := pac8(PChar(p)+288)^[0]; pac8(PChar(p)+288)^[0] := num;
 num := pac8(PChar(p)+7)^[0]; pac8(PChar(p)+7)^[0] := pac8(PChar(p)+506)^[0]; pac8(PChar(p)+506)^[0] := num;

C4F54E6B(p);

end;

procedure C4F54E6B(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+413)^[0] := rol1(pac8(PChar(p)+275)^[0] , 2 );
 pac32(PChar(p)+225)^[0] := pac32(PChar(p)+225)^[0] - ror1(pac32(PChar(p)+347)^[0] , 22 );
 pac16(PChar(p)+148)^[0] := rol1(pac16(PChar(p)+124)^[0] , 6 );
 if pac8(PChar(p)+472)^[0] < pac8(PChar(p)+319)^[0] then pac16(PChar(p)+285)^[0] := pac16(PChar(p)+285)^[0] xor ror2(pac16(PChar(p)+323)^[0] , 6 ) else pac8(PChar(p)+395)^[0] := pac8(PChar(p)+395)^[0] or ror1(pac8(PChar(p)+484)^[0] , 5 );

 if pac16(PChar(p)+370)^[0] < pac16(PChar(p)+180)^[0] then begin
   if pac8(PChar(p)+494)^[0] < pac8(PChar(p)+470)^[0] then pac8(PChar(p)+452)^[0] := ror2(pac8(PChar(p)+0)^[0] , 2 ) else begin  num := pac8(PChar(p)+210)^[0]; pac8(PChar(p)+210)^[0] := pac8(PChar(p)+484)^[0]; pac8(PChar(p)+484)^[0] := num; end;
   pac16(PChar(p)+105)^[0] := pac16(PChar(p)+105)^[0] + rol1(pac16(PChar(p)+240)^[0] , 1 );
   pac64(PChar(p)+310)^[0] := pac64(PChar(p)+310)^[0] - (pac64(PChar(p)+108)^[0] xor $1e0d6a5c21f2);
 end;

 pac32(PChar(p)+162)^[0] := pac32(PChar(p)+162)^[0] + $963950;

 if pac64(PChar(p)+464)^[0] > pac64(PChar(p)+207)^[0] then begin
   pac8(PChar(p)+277)^[0] := pac8(PChar(p)+277)^[0] + $bc;
   if pac32(PChar(p)+135)^[0] < pac32(PChar(p)+377)^[0] then pac32(PChar(p)+465)^[0] := ror1(pac32(PChar(p)+91)^[0] , 17 ) else pac32(PChar(p)+38)^[0] := pac32(PChar(p)+38)^[0] - (pac32(PChar(p)+271)^[0] xor $b60f);
   num := pac16(PChar(p)+444)^[0]; pac16(PChar(p)+444)^[0] := pac16(PChar(p)+406)^[0]; pac16(PChar(p)+406)^[0] := num;
   if pac32(PChar(p)+315)^[0] < pac32(PChar(p)+460)^[0] then pac32(PChar(p)+391)^[0] := pac32(PChar(p)+391)^[0] or rol1(pac32(PChar(p)+271)^[0] , 10 ) else pac16(PChar(p)+134)^[0] := pac16(PChar(p)+342)^[0] + $98;
   if pac32(PChar(p)+485)^[0] < pac32(PChar(p)+43)^[0] then begin  num := pac32(PChar(p)+138)^[0]; pac32(PChar(p)+138)^[0] := pac32(PChar(p)+343)^[0]; pac32(PChar(p)+343)^[0] := num; end else pac32(PChar(p)+504)^[0] := pac32(PChar(p)+504)^[0] - ror1(pac32(PChar(p)+326)^[0] , 19 );
 end;

 pac64(PChar(p)+305)^[0] := pac64(PChar(p)+178)^[0] - (pac64(PChar(p)+380)^[0] + $d6cbb6e0f1);
 pac64(PChar(p)+162)^[0] := pac64(PChar(p)+162)^[0] xor $a68e47b1;
 pac64(PChar(p)+189)^[0] := pac64(PChar(p)+189)^[0] - $d6222b9144;
 pac16(PChar(p)+89)^[0] := pac16(PChar(p)+89)^[0] or rol1(pac16(PChar(p)+132)^[0] , 4 );

 if pac8(PChar(p)+227)^[0] < pac8(PChar(p)+167)^[0] then begin
   pac64(PChar(p)+204)^[0] := pac64(PChar(p)+204)^[0] or $aafd3feeb52e;
   pac64(PChar(p)+356)^[0] := pac64(PChar(p)+356)^[0] or $3ec0f15f;
 end;


C491C643(p);

end;

procedure C491C643(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+202)^[0] > pac16(PChar(p)+305)^[0] then begin
   pac32(PChar(p)+11)^[0] := pac32(PChar(p)+204)^[0] + (pac32(PChar(p)+151)^[0] xor $201e);
   if pac16(PChar(p)+115)^[0] < pac16(PChar(p)+48)^[0] then pac32(PChar(p)+250)^[0] := pac32(PChar(p)+250)^[0] + (pac32(PChar(p)+422)^[0] or $fa0f56);
   pac64(PChar(p)+190)^[0] := pac64(PChar(p)+190)^[0] + $666d6d2c920b;
   pac64(PChar(p)+47)^[0] := pac64(PChar(p)+47)^[0] + $c424f0e1ffc6;
   pac64(PChar(p)+199)^[0] := pac64(PChar(p)+199)^[0] - $92febf08;
 end;

 if pac64(PChar(p)+271)^[0] < pac64(PChar(p)+64)^[0] then begin  num := pac16(PChar(p)+430)^[0]; pac16(PChar(p)+430)^[0] := pac16(PChar(p)+166)^[0]; pac16(PChar(p)+166)^[0] := num; end else begin  num := pac32(PChar(p)+327)^[0]; pac32(PChar(p)+327)^[0] := pac32(PChar(p)+90)^[0]; pac32(PChar(p)+90)^[0] := num; end;
 if pac64(PChar(p)+76)^[0] > pac64(PChar(p)+142)^[0] then pac64(PChar(p)+293)^[0] := pac64(PChar(p)+293)^[0] or (pac64(PChar(p)+434)^[0] xor $b22774c86568) else begin  num := pac16(PChar(p)+58)^[0]; pac16(PChar(p)+58)^[0] := pac16(PChar(p)+34)^[0]; pac16(PChar(p)+34)^[0] := num; end;
 pac16(PChar(p)+451)^[0] := pac16(PChar(p)+451)^[0] + rol1(pac16(PChar(p)+231)^[0] , 8 );
 pac8(PChar(p)+158)^[0] := pac8(PChar(p)+158)^[0] + rol1(pac8(PChar(p)+93)^[0] , 7 );
 pac32(PChar(p)+480)^[0] := pac32(PChar(p)+480)^[0] + ror1(pac32(PChar(p)+166)^[0] , 13 );
 pac64(PChar(p)+447)^[0] := pac64(PChar(p)+447)^[0] + (pac64(PChar(p)+0)^[0] or $74ceb2566b51);
 pac64(PChar(p)+304)^[0] := pac64(PChar(p)+304)^[0] or $b4441850b33b;
 if pac64(PChar(p)+414)^[0] < pac64(PChar(p)+295)^[0] then pac8(PChar(p)+277)^[0] := pac8(PChar(p)+277)^[0] + rol1(pac8(PChar(p)+502)^[0] , 3 ) else pac32(PChar(p)+492)^[0] := pac32(PChar(p)+492)^[0] - rol1(pac32(PChar(p)+361)^[0] , 21 );
 num := pac32(PChar(p)+370)^[0]; pac32(PChar(p)+370)^[0] := pac32(PChar(p)+75)^[0]; pac32(PChar(p)+75)^[0] := num;
 pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] - $54ad;

 if pac16(PChar(p)+108)^[0] < pac16(PChar(p)+510)^[0] then begin
   pac16(PChar(p)+418)^[0] := pac16(PChar(p)+418)^[0] - (pac16(PChar(p)+435)^[0] or $d0);
   num := pac16(PChar(p)+363)^[0]; pac16(PChar(p)+363)^[0] := pac16(PChar(p)+131)^[0]; pac16(PChar(p)+131)^[0] := num;
   pac64(PChar(p)+184)^[0] := pac64(PChar(p)+184)^[0] or (pac64(PChar(p)+240)^[0] or $805de1da);
   num := pac32(PChar(p)+140)^[0]; pac32(PChar(p)+140)^[0] := pac32(PChar(p)+70)^[0]; pac32(PChar(p)+70)^[0] := num;
 end;

 pac32(PChar(p)+360)^[0] := pac32(PChar(p)+360)^[0] + (pac32(PChar(p)+89)^[0] + $e819);
 pac16(PChar(p)+90)^[0] := pac16(PChar(p)+90)^[0] + (pac16(PChar(p)+362)^[0] - $f2);
 pac32(PChar(p)+274)^[0] := pac32(PChar(p)+274)^[0] + ror2(pac32(PChar(p)+289)^[0] , 1 );
 pac64(PChar(p)+274)^[0] := pac64(PChar(p)+274)^[0] or $48506c28f8;
 pac8(PChar(p)+219)^[0] := pac8(PChar(p)+219)^[0] + $c4;
 pac16(PChar(p)+206)^[0] := pac16(PChar(p)+206)^[0] + (pac16(PChar(p)+388)^[0] xor $84);
 pac64(PChar(p)+402)^[0] := pac64(PChar(p)+402)^[0] or (pac64(PChar(p)+103)^[0] or $98b6ed6a);

E07B34A4(p);

end;

procedure E07B34A4(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+13)^[0] < pac64(PChar(p)+342)^[0] then pac32(PChar(p)+56)^[0] := pac32(PChar(p)+56)^[0] xor (pac32(PChar(p)+243)^[0] - $24898c) else pac32(PChar(p)+162)^[0] := pac32(PChar(p)+162)^[0] - ror2(pac32(PChar(p)+380)^[0] , 6 );
 pac64(PChar(p)+280)^[0] := pac64(PChar(p)+167)^[0] xor $e0e4741c906e;
 pac32(PChar(p)+224)^[0] := pac32(PChar(p)+224)^[0] or $ec34c2;
 pac64(PChar(p)+124)^[0] := pac64(PChar(p)+124)^[0] or (pac64(PChar(p)+128)^[0] xor $1010a592c548);
 num := pac8(PChar(p)+483)^[0]; pac8(PChar(p)+483)^[0] := pac8(PChar(p)+312)^[0]; pac8(PChar(p)+312)^[0] := num;
 pac16(PChar(p)+229)^[0] := pac16(PChar(p)+229)^[0] or rol1(pac16(PChar(p)+147)^[0] , 1 );

 if pac64(PChar(p)+73)^[0] < pac64(PChar(p)+479)^[0] then begin
   pac32(PChar(p)+432)^[0] := pac32(PChar(p)+432)^[0] or (pac32(PChar(p)+301)^[0] or $8251ea);
   num := pac8(PChar(p)+148)^[0]; pac8(PChar(p)+148)^[0] := pac8(PChar(p)+25)^[0]; pac8(PChar(p)+25)^[0] := num;
   num := pac32(PChar(p)+435)^[0]; pac32(PChar(p)+435)^[0] := pac32(PChar(p)+344)^[0]; pac32(PChar(p)+344)^[0] := num;
   num := pac8(PChar(p)+30)^[0]; pac8(PChar(p)+30)^[0] := pac8(PChar(p)+370)^[0]; pac8(PChar(p)+370)^[0] := num;
   pac8(PChar(p)+55)^[0] := pac8(PChar(p)+55)^[0] + rol1(pac8(PChar(p)+418)^[0] , 6 );
 end;

 pac16(PChar(p)+485)^[0] := pac16(PChar(p)+113)^[0] or $42;
 pac32(PChar(p)+470)^[0] := pac32(PChar(p)+470)^[0] - $84c347;
 pac8(PChar(p)+9)^[0] := pac8(PChar(p)+9)^[0] xor rol1(pac8(PChar(p)+75)^[0] , 3 );
 if pac16(PChar(p)+55)^[0] < pac16(PChar(p)+355)^[0] then pac8(PChar(p)+255)^[0] := ror1(pac8(PChar(p)+488)^[0] , 4 ) else pac32(PChar(p)+255)^[0] := pac32(PChar(p)+255)^[0] - rol1(pac32(PChar(p)+433)^[0] , 19 );
 pac32(PChar(p)+499)^[0] := pac32(PChar(p)+499)^[0] xor ror1(pac32(PChar(p)+335)^[0] , 24 );

 if pac64(PChar(p)+354)^[0] < pac64(PChar(p)+271)^[0] then begin
   pac64(PChar(p)+405)^[0] := pac64(PChar(p)+405)^[0] or (pac64(PChar(p)+288)^[0] - $360a549073);
   num := pac16(PChar(p)+120)^[0]; pac16(PChar(p)+120)^[0] := pac16(PChar(p)+355)^[0]; pac16(PChar(p)+355)^[0] := num;
   pac8(PChar(p)+131)^[0] := rol1(pac8(PChar(p)+432)^[0] , 6 );
   num := pac32(PChar(p)+323)^[0]; pac32(PChar(p)+323)^[0] := pac32(PChar(p)+296)^[0]; pac32(PChar(p)+296)^[0] := num;
   if pac16(PChar(p)+42)^[0] < pac16(PChar(p)+499)^[0] then begin  num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+499)^[0]; pac8(PChar(p)+499)^[0] := num; end;
 end;

 pac16(PChar(p)+221)^[0] := pac16(PChar(p)+221)^[0] - $e4;

D58951EB(p);

end;

procedure D58951EB(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+315)^[0] := pac32(PChar(p)+455)^[0] or (pac32(PChar(p)+352)^[0] xor $14e5bb);
 pac32(PChar(p)+315)^[0] := pac32(PChar(p)+315)^[0] + ror2(pac32(PChar(p)+45)^[0] , 22 );
 pac16(PChar(p)+130)^[0] := pac16(PChar(p)+130)^[0] + rol1(pac16(PChar(p)+119)^[0] , 4 );
 pac8(PChar(p)+406)^[0] := pac8(PChar(p)+406)^[0] + (pac8(PChar(p)+14)^[0] xor $fe);
 pac16(PChar(p)+393)^[0] := pac16(PChar(p)+393)^[0] - (pac16(PChar(p)+334)^[0] + $50);
 pac32(PChar(p)+192)^[0] := ror2(pac32(PChar(p)+498)^[0] , 31 );
 if pac64(PChar(p)+18)^[0] > pac64(PChar(p)+376)^[0] then pac64(PChar(p)+482)^[0] := pac64(PChar(p)+482)^[0] + $68059d6c;
 pac32(PChar(p)+90)^[0] := pac32(PChar(p)+90)^[0] - rol1(pac32(PChar(p)+130)^[0] , 30 );
 pac16(PChar(p)+120)^[0] := pac16(PChar(p)+120)^[0] or ror1(pac16(PChar(p)+118)^[0] , 12 );
 if pac64(PChar(p)+237)^[0] > pac64(PChar(p)+23)^[0] then pac16(PChar(p)+365)^[0] := pac16(PChar(p)+365)^[0] + ror2(pac16(PChar(p)+19)^[0] , 15 ) else begin  num := pac8(PChar(p)+119)^[0]; pac8(PChar(p)+119)^[0] := pac8(PChar(p)+430)^[0]; pac8(PChar(p)+430)^[0] := num; end;
 if pac8(PChar(p)+131)^[0] < pac8(PChar(p)+218)^[0] then pac32(PChar(p)+86)^[0] := pac32(PChar(p)+86)^[0] xor (pac32(PChar(p)+21)^[0] - $0439) else pac16(PChar(p)+287)^[0] := pac16(PChar(p)+287)^[0] - $60;
 num := pac32(PChar(p)+183)^[0]; pac32(PChar(p)+183)^[0] := pac32(PChar(p)+222)^[0]; pac32(PChar(p)+222)^[0] := num;

 if pac16(PChar(p)+260)^[0] < pac16(PChar(p)+125)^[0] then begin
   if pac32(PChar(p)+344)^[0] > pac32(PChar(p)+370)^[0] then pac16(PChar(p)+161)^[0] := pac16(PChar(p)+161)^[0] or rol1(pac16(PChar(p)+302)^[0] , 14 ) else begin  num := pac32(PChar(p)+232)^[0]; pac32(PChar(p)+232)^[0] := pac32(PChar(p)+460)^[0]; pac32(PChar(p)+460)^[0] := num; end;
   pac16(PChar(p)+326)^[0] := pac16(PChar(p)+326)^[0] - ror1(pac16(PChar(p)+31)^[0] , 11 );
   pac8(PChar(p)+404)^[0] := pac8(PChar(p)+404)^[0] + (pac8(PChar(p)+275)^[0] or $5a);
   pac8(PChar(p)+391)^[0] := pac8(PChar(p)+391)^[0] - (pac8(PChar(p)+84)^[0] - $fc);
 end;

 pac16(PChar(p)+458)^[0] := pac16(PChar(p)+458)^[0] - (pac16(PChar(p)+495)^[0] - $84);
 pac32(PChar(p)+444)^[0] := pac32(PChar(p)+444)^[0] xor $1ee84c;
 num := pac32(PChar(p)+143)^[0]; pac32(PChar(p)+143)^[0] := pac32(PChar(p)+212)^[0]; pac32(PChar(p)+212)^[0] := num;
 num := pac16(PChar(p)+392)^[0]; pac16(PChar(p)+392)^[0] := pac16(PChar(p)+213)^[0]; pac16(PChar(p)+213)^[0] := num;

B5CE7FD5(p);

end;

procedure B5CE7FD5(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+358)^[0] := pac64(PChar(p)+358)^[0] + $7c2b3608e82f;
 if pac32(PChar(p)+229)^[0] > pac32(PChar(p)+225)^[0] then pac64(PChar(p)+44)^[0] := pac64(PChar(p)+44)^[0] xor (pac64(PChar(p)+191)^[0] or $6863b8ec) else pac8(PChar(p)+498)^[0] := pac8(PChar(p)+498)^[0] xor $cc;
 pac64(PChar(p)+394)^[0] := pac64(PChar(p)+394)^[0] or $eac23cc9;
 pac8(PChar(p)+445)^[0] := pac8(PChar(p)+445)^[0] xor ror2(pac8(PChar(p)+128)^[0] , 4 );
 pac64(PChar(p)+409)^[0] := pac64(PChar(p)+409)^[0] - $247c05988d49;
 if pac64(PChar(p)+301)^[0] > pac64(PChar(p)+309)^[0] then pac8(PChar(p)+263)^[0] := ror2(pac8(PChar(p)+96)^[0] , 1 ) else pac8(PChar(p)+264)^[0] := pac8(PChar(p)+264)^[0] + ror2(pac8(PChar(p)+44)^[0] , 1 );
 pac32(PChar(p)+454)^[0] := pac32(PChar(p)+454)^[0] or (pac32(PChar(p)+201)^[0] or $d8f5);
 if pac16(PChar(p)+66)^[0] < pac16(PChar(p)+120)^[0] then pac32(PChar(p)+310)^[0] := pac32(PChar(p)+310)^[0] - $1eeb;
 if pac32(PChar(p)+368)^[0] > pac32(PChar(p)+309)^[0] then pac64(PChar(p)+459)^[0] := pac64(PChar(p)+459)^[0] xor $147727050c;
 pac64(PChar(p)+106)^[0] := pac64(PChar(p)+106)^[0] xor $22406119;
 pac32(PChar(p)+49)^[0] := pac32(PChar(p)+381)^[0] + (pac32(PChar(p)+37)^[0] - $4e9f);
 if pac64(PChar(p)+5)^[0] < pac64(PChar(p)+342)^[0] then pac64(PChar(p)+495)^[0] := pac64(PChar(p)+495)^[0] xor (pac64(PChar(p)+215)^[0] xor $38bdb34f);
 pac8(PChar(p)+483)^[0] := pac8(PChar(p)+483)^[0] xor (pac8(PChar(p)+443)^[0] xor $44);
 pac32(PChar(p)+181)^[0] := ror1(pac32(PChar(p)+171)^[0] , 15 );
 num := pac32(PChar(p)+199)^[0]; pac32(PChar(p)+199)^[0] := pac32(PChar(p)+505)^[0]; pac32(PChar(p)+505)^[0] := num;

A810008D(p);

end;

procedure A810008D(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+341)^[0] < pac8(PChar(p)+457)^[0] then begin
   pac32(PChar(p)+374)^[0] := pac32(PChar(p)+374)^[0] - ror2(pac32(PChar(p)+397)^[0] , 4 );
   num := pac32(PChar(p)+279)^[0]; pac32(PChar(p)+279)^[0] := pac32(PChar(p)+17)^[0]; pac32(PChar(p)+17)^[0] := num;
   if pac8(PChar(p)+341)^[0] < pac8(PChar(p)+266)^[0] then pac8(PChar(p)+168)^[0] := pac8(PChar(p)+168)^[0] + $2c else pac32(PChar(p)+452)^[0] := pac32(PChar(p)+201)^[0] or $def5;
 end;


 if pac8(PChar(p)+377)^[0] > pac8(PChar(p)+482)^[0] then begin
   num := pac32(PChar(p)+197)^[0]; pac32(PChar(p)+197)^[0] := pac32(PChar(p)+183)^[0]; pac32(PChar(p)+183)^[0] := num;
   pac64(PChar(p)+299)^[0] := pac64(PChar(p)+299)^[0] xor $3c63458d;
   if pac32(PChar(p)+213)^[0] < pac32(PChar(p)+237)^[0] then begin  num := pac16(PChar(p)+162)^[0]; pac16(PChar(p)+162)^[0] := pac16(PChar(p)+175)^[0]; pac16(PChar(p)+175)^[0] := num; end;
   pac32(PChar(p)+255)^[0] := pac32(PChar(p)+255)^[0] or ror1(pac32(PChar(p)+237)^[0] , 15 );
   pac32(PChar(p)+13)^[0] := pac32(PChar(p)+13)^[0] xor $42ffa4;
 end;

 pac32(PChar(p)+503)^[0] := pac32(PChar(p)+469)^[0] + $0498;
 pac16(PChar(p)+194)^[0] := pac16(PChar(p)+194)^[0] or (pac16(PChar(p)+289)^[0] xor $70);
 pac32(PChar(p)+239)^[0] := pac32(PChar(p)+239)^[0] + ror2(pac32(PChar(p)+392)^[0] , 29 );

 if pac32(PChar(p)+221)^[0] > pac32(PChar(p)+33)^[0] then begin
   pac8(PChar(p)+468)^[0] := pac8(PChar(p)+227)^[0] + $da;
   pac16(PChar(p)+487)^[0] := pac16(PChar(p)+487)^[0] or ror2(pac16(PChar(p)+243)^[0] , 2 );
   pac64(PChar(p)+313)^[0] := pac64(PChar(p)+313)^[0] or $ca4b05529e;
   pac8(PChar(p)+258)^[0] := pac8(PChar(p)+311)^[0] or (pac8(PChar(p)+79)^[0] - $7e);
 end;

 num := pac16(PChar(p)+106)^[0]; pac16(PChar(p)+106)^[0] := pac16(PChar(p)+186)^[0]; pac16(PChar(p)+186)^[0] := num;
 pac64(PChar(p)+276)^[0] := pac64(PChar(p)+85)^[0] xor $d8e711c11732;
 pac64(PChar(p)+427)^[0] := pac64(PChar(p)+427)^[0] + (pac64(PChar(p)+431)^[0] - $f6678a29);
 pac8(PChar(p)+375)^[0] := pac8(PChar(p)+375)^[0] + $e0;
 num := pac16(PChar(p)+188)^[0]; pac16(PChar(p)+188)^[0] := pac16(PChar(p)+508)^[0]; pac16(PChar(p)+508)^[0] := num;

 if pac64(PChar(p)+214)^[0] < pac64(PChar(p)+106)^[0] then begin
   pac64(PChar(p)+311)^[0] := pac64(PChar(p)+311)^[0] - (pac64(PChar(p)+281)^[0] or $ecafa3f3);
   num := pac8(PChar(p)+342)^[0]; pac8(PChar(p)+342)^[0] := pac8(PChar(p)+49)^[0]; pac8(PChar(p)+49)^[0] := num;
   pac64(PChar(p)+208)^[0] := pac64(PChar(p)+148)^[0] xor $5a0635b5db;
 end;


 if pac32(PChar(p)+6)^[0] < pac32(PChar(p)+5)^[0] then begin
   pac8(PChar(p)+19)^[0] := pac8(PChar(p)+19)^[0] - $a2;
   if pac8(PChar(p)+508)^[0] < pac8(PChar(p)+430)^[0] then begin  num := pac16(PChar(p)+179)^[0]; pac16(PChar(p)+179)^[0] := pac16(PChar(p)+340)^[0]; pac16(PChar(p)+340)^[0] := num; end else pac64(PChar(p)+171)^[0] := pac64(PChar(p)+171)^[0] + (pac64(PChar(p)+260)^[0] or $28304494374b);
 end;


 if pac8(PChar(p)+30)^[0] > pac8(PChar(p)+106)^[0] then begin
   pac32(PChar(p)+225)^[0] := pac32(PChar(p)+225)^[0] + ror2(pac32(PChar(p)+233)^[0] , 6 );
   pac8(PChar(p)+308)^[0] := pac8(PChar(p)+308)^[0] + $98;
   pac32(PChar(p)+83)^[0] := pac32(PChar(p)+83)^[0] or (pac32(PChar(p)+476)^[0] xor $7804);
   pac64(PChar(p)+194)^[0] := pac64(PChar(p)+194)^[0] + $3678e8abb2;
   if pac64(PChar(p)+102)^[0] < pac64(PChar(p)+202)^[0] then pac32(PChar(p)+475)^[0] := pac32(PChar(p)+153)^[0] or (pac32(PChar(p)+325)^[0] or $388f) else begin  num := pac32(PChar(p)+145)^[0]; pac32(PChar(p)+145)^[0] := pac32(PChar(p)+491)^[0]; pac32(PChar(p)+491)^[0] := num; end;
 end;

 pac16(PChar(p)+162)^[0] := pac16(PChar(p)+162)^[0] xor rol1(pac16(PChar(p)+153)^[0] , 3 );
 num := pac8(PChar(p)+0)^[0]; pac8(PChar(p)+0)^[0] := pac8(PChar(p)+181)^[0]; pac8(PChar(p)+181)^[0] := num;

FD8B1CD4(p);

end;

procedure FD8B1CD4(p: Pointer);
begin

 pac8(PChar(p)+189)^[0] := pac8(PChar(p)+96)^[0] + (pac8(PChar(p)+299)^[0] + $b2);
 pac32(PChar(p)+200)^[0] := pac32(PChar(p)+200)^[0] + ror2(pac32(PChar(p)+387)^[0] , 6 );
 pac64(PChar(p)+37)^[0] := pac64(PChar(p)+37)^[0] - (pac64(PChar(p)+194)^[0] + $6a541dab67);
 pac8(PChar(p)+491)^[0] := pac8(PChar(p)+491)^[0] xor $f6;
 pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] or (pac32(PChar(p)+278)^[0] xor $d6e0);
 pac8(PChar(p)+346)^[0] := pac8(PChar(p)+346)^[0] xor ror1(pac8(PChar(p)+380)^[0] , 3 );
 pac64(PChar(p)+310)^[0] := pac64(PChar(p)+118)^[0] xor (pac64(PChar(p)+399)^[0] or $20e099b15569);
 pac8(PChar(p)+354)^[0] := pac8(PChar(p)+354)^[0] or rol1(pac8(PChar(p)+170)^[0] , 4 );
 if pac32(PChar(p)+484)^[0] < pac32(PChar(p)+398)^[0] then pac32(PChar(p)+282)^[0] := pac32(PChar(p)+282)^[0] or $66f4bb;
 pac16(PChar(p)+98)^[0] := pac16(PChar(p)+98)^[0] + (pac16(PChar(p)+387)^[0] - $6e);
 pac32(PChar(p)+387)^[0] := pac32(PChar(p)+387)^[0] + ror1(pac32(PChar(p)+508)^[0] , 15 );

F0D6F924(p);

end;

procedure F0D6F924(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+339)^[0] > pac16(PChar(p)+121)^[0] then pac64(PChar(p)+81)^[0] := pac64(PChar(p)+81)^[0] + $4c1ad7dd2f36 else pac64(PChar(p)+233)^[0] := pac64(PChar(p)+233)^[0] - $3a16c98177;
 num := pac32(PChar(p)+68)^[0]; pac32(PChar(p)+68)^[0] := pac32(PChar(p)+487)^[0]; pac32(PChar(p)+487)^[0] := num;
 pac16(PChar(p)+223)^[0] := pac16(PChar(p)+223)^[0] xor ror1(pac16(PChar(p)+470)^[0] , 1 );
 if pac64(PChar(p)+425)^[0] > pac64(PChar(p)+377)^[0] then pac8(PChar(p)+73)^[0] := pac8(PChar(p)+197)^[0] xor $e2 else pac8(PChar(p)+390)^[0] := pac8(PChar(p)+390)^[0] xor ror1(pac8(PChar(p)+146)^[0] , 7 );

 if pac16(PChar(p)+377)^[0] < pac16(PChar(p)+336)^[0] then begin
   pac8(PChar(p)+232)^[0] := pac8(PChar(p)+232)^[0] or rol1(pac8(PChar(p)+260)^[0] , 2 );
   pac32(PChar(p)+447)^[0] := ror2(pac32(PChar(p)+121)^[0] , 19 );
   pac16(PChar(p)+262)^[0] := pac16(PChar(p)+262)^[0] or ror1(pac16(PChar(p)+195)^[0] , 2 );
   pac16(PChar(p)+184)^[0] := pac16(PChar(p)+184)^[0] xor rol1(pac16(PChar(p)+481)^[0] , 12 );
   pac16(PChar(p)+256)^[0] := pac16(PChar(p)+256)^[0] xor $46;
 end;

 pac16(PChar(p)+486)^[0] := pac16(PChar(p)+486)^[0] xor rol1(pac16(PChar(p)+410)^[0] , 9 );
 num := pac8(PChar(p)+207)^[0]; pac8(PChar(p)+207)^[0] := pac8(PChar(p)+272)^[0]; pac8(PChar(p)+272)^[0] := num;
 pac16(PChar(p)+31)^[0] := pac16(PChar(p)+31)^[0] - ror2(pac16(PChar(p)+437)^[0] , 4 );
 pac64(PChar(p)+0)^[0] := pac64(PChar(p)+380)^[0] or (pac64(PChar(p)+211)^[0] + $1ac709d5d6);
 if pac8(PChar(p)+41)^[0] < pac8(PChar(p)+291)^[0] then pac64(PChar(p)+191)^[0] := pac64(PChar(p)+341)^[0] - (pac64(PChar(p)+341)^[0] + $b086898b) else pac8(PChar(p)+135)^[0] := pac8(PChar(p)+135)^[0] or (pac8(PChar(p)+14)^[0] - $ca);

 if pac8(PChar(p)+407)^[0] > pac8(PChar(p)+104)^[0] then begin
   pac32(PChar(p)+459)^[0] := pac32(PChar(p)+59)^[0] or $b25c;
   num := pac32(PChar(p)+193)^[0]; pac32(PChar(p)+193)^[0] := pac32(PChar(p)+280)^[0]; pac32(PChar(p)+280)^[0] := num;
   num := pac8(PChar(p)+460)^[0]; pac8(PChar(p)+460)^[0] := pac8(PChar(p)+29)^[0]; pac8(PChar(p)+29)^[0] := num;
 end;

 if pac16(PChar(p)+388)^[0] < pac16(PChar(p)+230)^[0] then begin  num := pac8(PChar(p)+194)^[0]; pac8(PChar(p)+194)^[0] := pac8(PChar(p)+445)^[0]; pac8(PChar(p)+445)^[0] := num; end else pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] or (pac32(PChar(p)+89)^[0] + $4eebc5);

 if pac16(PChar(p)+232)^[0] > pac16(PChar(p)+463)^[0] then begin
   pac8(PChar(p)+372)^[0] := pac8(PChar(p)+372)^[0] or (pac8(PChar(p)+177)^[0] - $c2);
   if pac32(PChar(p)+68)^[0] > pac32(PChar(p)+411)^[0] then begin  num := pac16(PChar(p)+253)^[0]; pac16(PChar(p)+253)^[0] := pac16(PChar(p)+4)^[0]; pac16(PChar(p)+4)^[0] := num; end;
 end;

 num := pac32(PChar(p)+430)^[0]; pac32(PChar(p)+430)^[0] := pac32(PChar(p)+488)^[0]; pac32(PChar(p)+488)^[0] := num;

EE682519(p);

end;

procedure EE682519(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+397)^[0] > pac16(PChar(p)+330)^[0] then begin
   pac32(PChar(p)+308)^[0] := pac32(PChar(p)+308)^[0] - $bc6163;
   pac32(PChar(p)+209)^[0] := pac32(PChar(p)+209)^[0] xor $5a03;
   pac8(PChar(p)+475)^[0] := pac8(PChar(p)+475)^[0] - ror2(pac8(PChar(p)+198)^[0] , 7 );
   num := pac8(PChar(p)+70)^[0]; pac8(PChar(p)+70)^[0] := pac8(PChar(p)+376)^[0]; pac8(PChar(p)+376)^[0] := num;
   pac16(PChar(p)+437)^[0] := pac16(PChar(p)+351)^[0] or (pac16(PChar(p)+462)^[0] + $c6);
 end;

 num := pac16(PChar(p)+57)^[0]; pac16(PChar(p)+57)^[0] := pac16(PChar(p)+185)^[0]; pac16(PChar(p)+185)^[0] := num;
 pac8(PChar(p)+349)^[0] := pac8(PChar(p)+349)^[0] + ror2(pac8(PChar(p)+194)^[0] , 1 );
 if pac16(PChar(p)+174)^[0] > pac16(PChar(p)+30)^[0] then pac32(PChar(p)+306)^[0] := pac32(PChar(p)+306)^[0] - (pac32(PChar(p)+120)^[0] or $8629e7) else pac64(PChar(p)+206)^[0] := pac64(PChar(p)+206)^[0] - $2c302a37741b;
 pac64(PChar(p)+63)^[0] := pac64(PChar(p)+451)^[0] - $bab986107d27;
 pac8(PChar(p)+304)^[0] := pac8(PChar(p)+355)^[0] - (pac8(PChar(p)+10)^[0] - $3c);
 pac32(PChar(p)+390)^[0] := pac32(PChar(p)+390)^[0] xor ror2(pac32(PChar(p)+324)^[0] , 8 );
 pac16(PChar(p)+98)^[0] := pac16(PChar(p)+98)^[0] xor ror1(pac16(PChar(p)+186)^[0] , 10 );
 pac16(PChar(p)+127)^[0] := ror2(pac16(PChar(p)+174)^[0] , 7 );
 if pac16(PChar(p)+348)^[0] < pac16(PChar(p)+469)^[0] then pac16(PChar(p)+479)^[0] := pac16(PChar(p)+479)^[0] - ror1(pac16(PChar(p)+288)^[0] , 12 );
 num := pac32(PChar(p)+479)^[0]; pac32(PChar(p)+479)^[0] := pac32(PChar(p)+102)^[0]; pac32(PChar(p)+102)^[0] := num;
 pac32(PChar(p)+80)^[0] := pac32(PChar(p)+80)^[0] - ror2(pac32(PChar(p)+394)^[0] , 1 );
 pac16(PChar(p)+405)^[0] := pac16(PChar(p)+405)^[0] - rol1(pac16(PChar(p)+469)^[0] , 9 );
 pac16(PChar(p)+330)^[0] := pac16(PChar(p)+330)^[0] or (pac16(PChar(p)+250)^[0] - $78);
 num := pac16(PChar(p)+457)^[0]; pac16(PChar(p)+457)^[0] := pac16(PChar(p)+398)^[0]; pac16(PChar(p)+398)^[0] := num;
 pac64(PChar(p)+58)^[0] := pac64(PChar(p)+355)^[0] + $529b7d76;

 if pac8(PChar(p)+37)^[0] < pac8(PChar(p)+284)^[0] then begin
   if pac64(PChar(p)+198)^[0] > pac64(PChar(p)+319)^[0] then pac16(PChar(p)+213)^[0] := pac16(PChar(p)+421)^[0] + $98;
   num := pac16(PChar(p)+236)^[0]; pac16(PChar(p)+236)^[0] := pac16(PChar(p)+11)^[0]; pac16(PChar(p)+11)^[0] := num;
   if pac32(PChar(p)+40)^[0] > pac32(PChar(p)+349)^[0] then pac32(PChar(p)+121)^[0] := pac32(PChar(p)+121)^[0] + ror2(pac32(PChar(p)+68)^[0] , 4 );
   pac16(PChar(p)+43)^[0] := pac16(PChar(p)+43)^[0] or ror1(pac16(PChar(p)+354)^[0] , 12 );
 end;


EBECA7BF(p);

end;

procedure EBECA7BF(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+449)^[0] > pac8(PChar(p)+184)^[0] then begin
   num := pac32(PChar(p)+379)^[0]; pac32(PChar(p)+379)^[0] := pac32(PChar(p)+353)^[0]; pac32(PChar(p)+353)^[0] := num;
   num := pac16(PChar(p)+468)^[0]; pac16(PChar(p)+468)^[0] := pac16(PChar(p)+168)^[0]; pac16(PChar(p)+168)^[0] := num;
 end;

 pac32(PChar(p)+151)^[0] := pac32(PChar(p)+151)^[0] - rol1(pac32(PChar(p)+201)^[0] , 12 );
 if pac16(PChar(p)+66)^[0] > pac16(PChar(p)+215)^[0] then pac16(PChar(p)+17)^[0] := pac16(PChar(p)+17)^[0] + (pac16(PChar(p)+185)^[0] + $88);
 if pac64(PChar(p)+468)^[0] < pac64(PChar(p)+257)^[0] then pac32(PChar(p)+371)^[0] := pac32(PChar(p)+371)^[0] xor ror2(pac32(PChar(p)+468)^[0] , 26 ) else pac16(PChar(p)+331)^[0] := pac16(PChar(p)+331)^[0] xor (pac16(PChar(p)+453)^[0] xor $fa);
 num := pac16(PChar(p)+287)^[0]; pac16(PChar(p)+287)^[0] := pac16(PChar(p)+369)^[0]; pac16(PChar(p)+369)^[0] := num;
 pac64(PChar(p)+308)^[0] := pac64(PChar(p)+308)^[0] xor (pac64(PChar(p)+166)^[0] or $3ce518d32d65);
 if pac16(PChar(p)+336)^[0] > pac16(PChar(p)+288)^[0] then pac64(PChar(p)+205)^[0] := pac64(PChar(p)+205)^[0] - $2a3264e43c19 else pac16(PChar(p)+148)^[0] := pac16(PChar(p)+501)^[0] or $5e;
 if pac64(PChar(p)+356)^[0] < pac64(PChar(p)+128)^[0] then begin  num := pac8(PChar(p)+143)^[0]; pac8(PChar(p)+143)^[0] := pac8(PChar(p)+322)^[0]; pac8(PChar(p)+322)^[0] := num; end else begin  num := pac32(PChar(p)+430)^[0]; pac32(PChar(p)+430)^[0] := pac32(PChar(p)+309)^[0]; pac32(PChar(p)+309)^[0] := num; end;
 if pac16(PChar(p)+370)^[0] > pac16(PChar(p)+276)^[0] then pac16(PChar(p)+462)^[0] := pac16(PChar(p)+155)^[0] xor (pac16(PChar(p)+144)^[0] xor $26) else begin  num := pac32(PChar(p)+246)^[0]; pac32(PChar(p)+246)^[0] := pac32(PChar(p)+18)^[0]; pac32(PChar(p)+18)^[0] := num; end;
 pac64(PChar(p)+228)^[0] := pac64(PChar(p)+228)^[0] or $8004702cc1;
 num := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := pac16(PChar(p)+289)^[0]; pac16(PChar(p)+289)^[0] := num;

 if pac64(PChar(p)+496)^[0] < pac64(PChar(p)+341)^[0] then begin
   if pac8(PChar(p)+77)^[0] < pac8(PChar(p)+472)^[0] then begin  num := pac16(PChar(p)+316)^[0]; pac16(PChar(p)+316)^[0] := pac16(PChar(p)+61)^[0]; pac16(PChar(p)+61)^[0] := num; end else pac32(PChar(p)+331)^[0] := pac32(PChar(p)+331)^[0] or (pac32(PChar(p)+312)^[0] - $185dc7);
   pac16(PChar(p)+53)^[0] := pac16(PChar(p)+53)^[0] or rol1(pac16(PChar(p)+486)^[0] , 3 );
 end;


AA38B2A9(p);

end;

procedure AA38B2A9(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+78)^[0] := pac16(PChar(p)+78)^[0] - ror2(pac16(PChar(p)+267)^[0] , 6 );
 pac8(PChar(p)+42)^[0] := pac8(PChar(p)+42)^[0] - $18;
 pac8(PChar(p)+325)^[0] := pac8(PChar(p)+325)^[0] - ror2(pac8(PChar(p)+116)^[0] , 4 );

 if pac8(PChar(p)+211)^[0] > pac8(PChar(p)+461)^[0] then begin
   pac64(PChar(p)+397)^[0] := pac64(PChar(p)+397)^[0] + $e6d98568;
   pac32(PChar(p)+216)^[0] := pac32(PChar(p)+216)^[0] or $cea576;
   pac32(PChar(p)+144)^[0] := pac32(PChar(p)+144)^[0] or ror2(pac32(PChar(p)+32)^[0] , 6 );
   num := pac16(PChar(p)+235)^[0]; pac16(PChar(p)+235)^[0] := pac16(PChar(p)+3)^[0]; pac16(PChar(p)+3)^[0] := num;
   num := pac8(PChar(p)+236)^[0]; pac8(PChar(p)+236)^[0] := pac8(PChar(p)+510)^[0]; pac8(PChar(p)+510)^[0] := num;
 end;

 if pac64(PChar(p)+282)^[0] > pac64(PChar(p)+2)^[0] then pac16(PChar(p)+200)^[0] := pac16(PChar(p)+200)^[0] - $a6 else pac64(PChar(p)+61)^[0] := pac64(PChar(p)+61)^[0] xor $bca14df515;
 if pac32(PChar(p)+201)^[0] < pac32(PChar(p)+422)^[0] then pac32(PChar(p)+507)^[0] := rol1(pac32(PChar(p)+340)^[0] , 24 ) else pac16(PChar(p)+0)^[0] := pac16(PChar(p)+0)^[0] xor rol1(pac16(PChar(p)+289)^[0] , 12 );

 if pac64(PChar(p)+444)^[0] < pac64(PChar(p)+108)^[0] then begin
   pac16(PChar(p)+137)^[0] := pac16(PChar(p)+137)^[0] + ror2(pac16(PChar(p)+489)^[0] , 12 );
   if pac64(PChar(p)+66)^[0] > pac64(PChar(p)+297)^[0] then begin  num := pac8(PChar(p)+19)^[0]; pac8(PChar(p)+19)^[0] := pac8(PChar(p)+248)^[0]; pac8(PChar(p)+248)^[0] := num; end;
   if pac16(PChar(p)+257)^[0] < pac16(PChar(p)+158)^[0] then pac16(PChar(p)+384)^[0] := pac16(PChar(p)+384)^[0] or (pac16(PChar(p)+115)^[0] or $40) else pac8(PChar(p)+160)^[0] := pac8(PChar(p)+160)^[0] xor (pac8(PChar(p)+18)^[0] - $62);
   num := pac32(PChar(p)+43)^[0]; pac32(PChar(p)+43)^[0] := pac32(PChar(p)+442)^[0]; pac32(PChar(p)+442)^[0] := num;
   pac64(PChar(p)+48)^[0] := pac64(PChar(p)+278)^[0] or $688695867a;
 end;


 if pac64(PChar(p)+413)^[0] > pac64(PChar(p)+149)^[0] then begin
   pac64(PChar(p)+278)^[0] := pac64(PChar(p)+278)^[0] or (pac64(PChar(p)+137)^[0] or $d4e31fc1);
   pac8(PChar(p)+425)^[0] := ror2(pac8(PChar(p)+11)^[0] , 1 );
   pac8(PChar(p)+171)^[0] := pac8(PChar(p)+171)^[0] - (pac8(PChar(p)+83)^[0] xor $a2);
   pac32(PChar(p)+369)^[0] := pac32(PChar(p)+140)^[0] xor $764804;
 end;

 if pac32(PChar(p)+38)^[0] < pac32(PChar(p)+74)^[0] then begin  num := pac8(PChar(p)+300)^[0]; pac8(PChar(p)+300)^[0] := pac8(PChar(p)+231)^[0]; pac8(PChar(p)+231)^[0] := num; end else pac64(PChar(p)+217)^[0] := pac64(PChar(p)+217)^[0] - $cc0e1fb9dd4f;
 num := pac16(PChar(p)+9)^[0]; pac16(PChar(p)+9)^[0] := pac16(PChar(p)+303)^[0]; pac16(PChar(p)+303)^[0] := num;
 num := pac8(PChar(p)+245)^[0]; pac8(PChar(p)+245)^[0] := pac8(PChar(p)+283)^[0]; pac8(PChar(p)+283)^[0] := num;
 pac32(PChar(p)+102)^[0] := pac32(PChar(p)+102)^[0] + $7c52;
 pac32(PChar(p)+89)^[0] := pac32(PChar(p)+89)^[0] xor $365d;
 pac8(PChar(p)+500)^[0] := pac8(PChar(p)+500)^[0] - rol1(pac8(PChar(p)+77)^[0] , 1 );

 if pac8(PChar(p)+215)^[0] > pac8(PChar(p)+120)^[0] then begin
   pac32(PChar(p)+448)^[0] := pac32(PChar(p)+448)^[0] or (pac32(PChar(p)+275)^[0] - $de7310);
   pac8(PChar(p)+47)^[0] := pac8(PChar(p)+47)^[0] xor ror2(pac8(PChar(p)+52)^[0] , 6 );
   pac32(PChar(p)+263)^[0] := ror1(pac32(PChar(p)+423)^[0] , 4 );
   pac16(PChar(p)+481)^[0] := pac16(PChar(p)+481)^[0] or ror1(pac16(PChar(p)+286)^[0] , 8 );
   num := pac16(PChar(p)+106)^[0]; pac16(PChar(p)+106)^[0] := pac16(PChar(p)+413)^[0]; pac16(PChar(p)+413)^[0] := num;
 end;

 pac32(PChar(p)+296)^[0] := pac32(PChar(p)+296)^[0] - ror2(pac32(PChar(p)+306)^[0] , 2 );

D940F478(p);

end;

procedure D940F478(p: Pointer);
var num: Int64;
begin

 num := pac32(PChar(p)+20)^[0]; pac32(PChar(p)+20)^[0] := pac32(PChar(p)+405)^[0]; pac32(PChar(p)+405)^[0] := num;
 pac8(PChar(p)+218)^[0] := pac8(PChar(p)+218)^[0] - ror2(pac8(PChar(p)+282)^[0] , 1 );
 pac16(PChar(p)+56)^[0] := pac16(PChar(p)+56)^[0] + $68;
 pac32(PChar(p)+130)^[0] := pac32(PChar(p)+130)^[0] or (pac32(PChar(p)+114)^[0] xor $fe5b);

 if pac64(PChar(p)+442)^[0] > pac64(PChar(p)+273)^[0] then begin
   pac8(PChar(p)+158)^[0] := pac8(PChar(p)+489)^[0] - (pac8(PChar(p)+482)^[0] or $80);
   pac32(PChar(p)+40)^[0] := pac32(PChar(p)+40)^[0] xor ror2(pac32(PChar(p)+145)^[0] , 25 );
   pac8(PChar(p)+340)^[0] := pac8(PChar(p)+340)^[0] + ror2(pac8(PChar(p)+127)^[0] , 4 );
 end;

 if pac64(PChar(p)+403)^[0] > pac64(PChar(p)+53)^[0] then begin  num := pac32(PChar(p)+131)^[0]; pac32(PChar(p)+131)^[0] := pac32(PChar(p)+175)^[0]; pac32(PChar(p)+175)^[0] := num; end else begin  num := pac8(PChar(p)+391)^[0]; pac8(PChar(p)+391)^[0] := pac8(PChar(p)+0)^[0]; pac8(PChar(p)+0)^[0] := num; end;
 pac16(PChar(p)+15)^[0] := pac16(PChar(p)+15)^[0] + (pac16(PChar(p)+459)^[0] + $ca);
 pac32(PChar(p)+346)^[0] := pac32(PChar(p)+346)^[0] + ror1(pac32(PChar(p)+426)^[0] , 23 );
 pac16(PChar(p)+53)^[0] := pac16(PChar(p)+53)^[0] - ror1(pac16(PChar(p)+289)^[0] , 2 );

 if pac8(PChar(p)+469)^[0] < pac8(PChar(p)+18)^[0] then begin
   pac32(PChar(p)+395)^[0] := pac32(PChar(p)+165)^[0] xor (pac32(PChar(p)+117)^[0] or $2cc631);
   pac16(PChar(p)+211)^[0] := pac16(PChar(p)+211)^[0] or (pac16(PChar(p)+65)^[0] + $d4);
   pac16(PChar(p)+199)^[0] := pac16(PChar(p)+330)^[0] or $ee;
   pac16(PChar(p)+468)^[0] := pac16(PChar(p)+468)^[0] xor ror1(pac16(PChar(p)+273)^[0] , 3 );
 end;

 pac16(PChar(p)+2)^[0] := pac16(PChar(p)+2)^[0] - (pac16(PChar(p)+143)^[0] + $f6);

F662318F(p);

end;

procedure F662318F(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+121)^[0] := ror2(pac8(PChar(p)+201)^[0] , 3 );
 pac32(PChar(p)+273)^[0] := pac32(PChar(p)+446)^[0] - $b21f;

 if pac64(PChar(p)+86)^[0] < pac64(PChar(p)+57)^[0] then begin
   pac32(PChar(p)+175)^[0] := pac32(PChar(p)+19)^[0] + (pac32(PChar(p)+332)^[0] or $187f37);
   if pac32(PChar(p)+302)^[0] < pac32(PChar(p)+52)^[0] then begin  num := pac32(PChar(p)+51)^[0]; pac32(PChar(p)+51)^[0] := pac32(PChar(p)+402)^[0]; pac32(PChar(p)+402)^[0] := num; end else pac64(PChar(p)+490)^[0] := pac64(PChar(p)+221)^[0] - $007c32ff9415;
   if pac32(PChar(p)+164)^[0] > pac32(PChar(p)+448)^[0] then pac8(PChar(p)+92)^[0] := pac8(PChar(p)+348)^[0] - (pac8(PChar(p)+132)^[0] or $c8) else pac8(PChar(p)+80)^[0] := pac8(PChar(p)+80)^[0] xor (pac8(PChar(p)+453)^[0] + $d2);
   pac16(PChar(p)+86)^[0] := pac16(PChar(p)+86)^[0] xor ror1(pac16(PChar(p)+107)^[0] , 3 );
   pac64(PChar(p)+474)^[0] := pac64(PChar(p)+264)^[0] or $c8efc540ad;
 end;


 if pac64(PChar(p)+278)^[0] < pac64(PChar(p)+93)^[0] then begin
   num := pac32(PChar(p)+287)^[0]; pac32(PChar(p)+287)^[0] := pac32(PChar(p)+40)^[0]; pac32(PChar(p)+40)^[0] := num;
   pac32(PChar(p)+155)^[0] := pac32(PChar(p)+155)^[0] + (pac32(PChar(p)+431)^[0] xor $5e66);
   pac8(PChar(p)+419)^[0] := pac8(PChar(p)+419)^[0] xor ror1(pac8(PChar(p)+483)^[0] , 6 );
   num := pac8(PChar(p)+28)^[0]; pac8(PChar(p)+28)^[0] := pac8(PChar(p)+336)^[0]; pac8(PChar(p)+336)^[0] := num;
   if pac32(PChar(p)+361)^[0] < pac32(PChar(p)+381)^[0] then pac16(PChar(p)+251)^[0] := pac16(PChar(p)+228)^[0] or (pac16(PChar(p)+188)^[0] or $b6) else begin  num := pac16(PChar(p)+70)^[0]; pac16(PChar(p)+70)^[0] := pac16(PChar(p)+112)^[0]; pac16(PChar(p)+112)^[0] := num; end;
 end;

 pac64(PChar(p)+394)^[0] := pac64(PChar(p)+394)^[0] xor (pac64(PChar(p)+177)^[0] or $cc7fbae1);
 if pac64(PChar(p)+104)^[0] > pac64(PChar(p)+39)^[0] then pac64(PChar(p)+165)^[0] := pac64(PChar(p)+45)^[0] + (pac64(PChar(p)+492)^[0] or $fea2be52de67) else pac64(PChar(p)+22)^[0] := pac64(PChar(p)+22)^[0] or $dc89f2e49c87;
 pac32(PChar(p)+89)^[0] := pac32(PChar(p)+89)^[0] or $14e6;
 pac16(PChar(p)+290)^[0] := pac16(PChar(p)+290)^[0] + $c0;
 pac16(PChar(p)+39)^[0] := pac16(PChar(p)+39)^[0] + rol1(pac16(PChar(p)+65)^[0] , 8 );
 pac8(PChar(p)+364)^[0] := pac8(PChar(p)+364)^[0] + ror1(pac8(PChar(p)+139)^[0] , 1 );
 pac32(PChar(p)+211)^[0] := pac32(PChar(p)+272)^[0] or (pac32(PChar(p)+2)^[0] xor $bec911);
 pac16(PChar(p)+27)^[0] := pac16(PChar(p)+27)^[0] or (pac16(PChar(p)+461)^[0] or $86);
 if pac64(PChar(p)+71)^[0] > pac64(PChar(p)+142)^[0] then begin  num := pac8(PChar(p)+465)^[0]; pac8(PChar(p)+465)^[0] := pac8(PChar(p)+329)^[0]; pac8(PChar(p)+329)^[0] := num; end;
 pac16(PChar(p)+346)^[0] := pac16(PChar(p)+346)^[0] xor ror2(pac16(PChar(p)+347)^[0] , 7 );

AA2C4F35(p);

end;

procedure AA2C4F35(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+99)^[0] > pac32(PChar(p)+147)^[0] then begin  num := pac32(PChar(p)+78)^[0]; pac32(PChar(p)+78)^[0] := pac32(PChar(p)+129)^[0]; pac32(PChar(p)+129)^[0] := num; end else pac32(PChar(p)+149)^[0] := pac32(PChar(p)+149)^[0] or $eaa326;
 pac32(PChar(p)+4)^[0] := pac32(PChar(p)+4)^[0] + (pac32(PChar(p)+407)^[0] - $40a4f2);
 num := pac8(PChar(p)+95)^[0]; pac8(PChar(p)+95)^[0] := pac8(PChar(p)+379)^[0]; pac8(PChar(p)+379)^[0] := num;
 if pac32(PChar(p)+177)^[0] > pac32(PChar(p)+235)^[0] then begin  num := pac32(PChar(p)+384)^[0]; pac32(PChar(p)+384)^[0] := pac32(PChar(p)+404)^[0]; pac32(PChar(p)+404)^[0] := num; end;
 pac8(PChar(p)+385)^[0] := pac8(PChar(p)+385)^[0] + ror2(pac8(PChar(p)+272)^[0] , 6 );
 pac32(PChar(p)+412)^[0] := pac32(PChar(p)+412)^[0] xor rol1(pac32(PChar(p)+258)^[0] , 22 );
 if pac8(PChar(p)+5)^[0] > pac8(PChar(p)+104)^[0] then begin  num := pac16(PChar(p)+278)^[0]; pac16(PChar(p)+278)^[0] := pac16(PChar(p)+88)^[0]; pac16(PChar(p)+88)^[0] := num; end else pac32(PChar(p)+283)^[0] := pac32(PChar(p)+283)^[0] - rol1(pac32(PChar(p)+359)^[0] , 27 );
 pac8(PChar(p)+262)^[0] := pac8(PChar(p)+262)^[0] - (pac8(PChar(p)+331)^[0] - $0a);
 pac64(PChar(p)+161)^[0] := pac64(PChar(p)+161)^[0] or $fe0d6f6b;

 if pac64(PChar(p)+209)^[0] > pac64(PChar(p)+419)^[0] then begin
   num := pac8(PChar(p)+226)^[0]; pac8(PChar(p)+226)^[0] := pac8(PChar(p)+379)^[0]; pac8(PChar(p)+379)^[0] := num;
   if pac8(PChar(p)+95)^[0] > pac8(PChar(p)+410)^[0] then begin  num := pac16(PChar(p)+396)^[0]; pac16(PChar(p)+396)^[0] := pac16(PChar(p)+3)^[0]; pac16(PChar(p)+3)^[0] := num; end else pac16(PChar(p)+264)^[0] := pac16(PChar(p)+264)^[0] xor $86;
   pac64(PChar(p)+407)^[0] := pac64(PChar(p)+407)^[0] - (pac64(PChar(p)+303)^[0] + $9c0f1100);
 end;

 if pac16(PChar(p)+164)^[0] < pac16(PChar(p)+170)^[0] then pac16(PChar(p)+8)^[0] := pac16(PChar(p)+8)^[0] - ror1(pac16(PChar(p)+261)^[0] , 9 ) else pac16(PChar(p)+118)^[0] := pac16(PChar(p)+118)^[0] or ror2(pac16(PChar(p)+420)^[0] , 12 );
 pac64(PChar(p)+318)^[0] := pac64(PChar(p)+318)^[0] + (pac64(PChar(p)+10)^[0] xor $aef722d56a);

CDA14A7E(p);

end;

procedure CDA14A7E(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+488)^[0] := pac32(PChar(p)+488)^[0] - (pac32(PChar(p)+104)^[0] + $48d46f);
 pac8(PChar(p)+345)^[0] := pac8(PChar(p)+345)^[0] xor ror2(pac8(PChar(p)+219)^[0] , 6 );
 if pac8(PChar(p)+344)^[0] > pac8(PChar(p)+410)^[0] then pac16(PChar(p)+120)^[0] := pac16(PChar(p)+457)^[0] or (pac16(PChar(p)+1)^[0] xor $26) else pac32(PChar(p)+508)^[0] := ror2(pac32(PChar(p)+405)^[0] , 18 );
 num := pac32(PChar(p)+389)^[0]; pac32(PChar(p)+389)^[0] := pac32(PChar(p)+31)^[0]; pac32(PChar(p)+31)^[0] := num;
 pac32(PChar(p)+270)^[0] := pac32(PChar(p)+270)^[0] + rol1(pac32(PChar(p)+346)^[0] , 17 );
 if pac8(PChar(p)+53)^[0] < pac8(PChar(p)+52)^[0] then pac16(PChar(p)+461)^[0] := pac16(PChar(p)+461)^[0] + $78 else pac64(PChar(p)+319)^[0] := pac64(PChar(p)+319)^[0] or (pac64(PChar(p)+210)^[0] + $cebe9b0ea8);

 if pac32(PChar(p)+324)^[0] < pac32(PChar(p)+366)^[0] then begin
   pac8(PChar(p)+92)^[0] := pac8(PChar(p)+92)^[0] - (pac8(PChar(p)+20)^[0] + $08);
   pac32(PChar(p)+40)^[0] := pac32(PChar(p)+40)^[0] xor ror2(pac32(PChar(p)+79)^[0] , 21 );
 end;

 if pac16(PChar(p)+379)^[0] > pac16(PChar(p)+33)^[0] then begin  num := pac16(PChar(p)+63)^[0]; pac16(PChar(p)+63)^[0] := pac16(PChar(p)+363)^[0]; pac16(PChar(p)+363)^[0] := num; end else pac64(PChar(p)+394)^[0] := pac64(PChar(p)+394)^[0] - $9aaf7d82;
 pac8(PChar(p)+21)^[0] := pac8(PChar(p)+21)^[0] xor ror2(pac8(PChar(p)+341)^[0] , 1 );
 pac64(PChar(p)+199)^[0] := pac64(PChar(p)+199)^[0] or (pac64(PChar(p)+457)^[0] + $44918c3e);
 pac8(PChar(p)+511)^[0] := pac8(PChar(p)+511)^[0] - ror1(pac8(PChar(p)+143)^[0] , 3 );

D0BBD7B0(p);

end;

procedure D0BBD7B0(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+5)^[0] > pac8(PChar(p)+477)^[0] then begin
   num := pac16(PChar(p)+80)^[0]; pac16(PChar(p)+80)^[0] := pac16(PChar(p)+15)^[0]; pac16(PChar(p)+15)^[0] := num;
   num := pac16(PChar(p)+338)^[0]; pac16(PChar(p)+338)^[0] := pac16(PChar(p)+252)^[0]; pac16(PChar(p)+252)^[0] := num;
   pac32(PChar(p)+39)^[0] := pac32(PChar(p)+69)^[0] or (pac32(PChar(p)+496)^[0] + $f420);
   num := pac16(PChar(p)+37)^[0]; pac16(PChar(p)+37)^[0] := pac16(PChar(p)+270)^[0]; pac16(PChar(p)+270)^[0] := num;
   num := pac16(PChar(p)+204)^[0]; pac16(PChar(p)+204)^[0] := pac16(PChar(p)+55)^[0]; pac16(PChar(p)+55)^[0] := num;
 end;

 pac32(PChar(p)+388)^[0] := pac32(PChar(p)+388)^[0] or rol1(pac32(PChar(p)+180)^[0] , 4 );

 if pac8(PChar(p)+100)^[0] < pac8(PChar(p)+484)^[0] then begin
   if pac32(PChar(p)+298)^[0] < pac32(PChar(p)+398)^[0] then pac64(PChar(p)+501)^[0] := pac64(PChar(p)+501)^[0] xor $6a2cfd4c4f else begin  num := pac32(PChar(p)+113)^[0]; pac32(PChar(p)+113)^[0] := pac32(PChar(p)+83)^[0]; pac32(PChar(p)+83)^[0] := num; end;
   pac8(PChar(p)+316)^[0] := pac8(PChar(p)+502)^[0] - $32;
   num := pac32(PChar(p)+14)^[0]; pac32(PChar(p)+14)^[0] := pac32(PChar(p)+353)^[0]; pac32(PChar(p)+353)^[0] := num;
 end;

 pac32(PChar(p)+480)^[0] := pac32(PChar(p)+480)^[0] xor ror2(pac32(PChar(p)+38)^[0] , 22 );
 num := pac8(PChar(p)+303)^[0]; pac8(PChar(p)+303)^[0] := pac8(PChar(p)+368)^[0]; pac8(PChar(p)+368)^[0] := num;
 pac32(PChar(p)+242)^[0] := pac32(PChar(p)+242)^[0] + ror2(pac32(PChar(p)+489)^[0] , 21 );
 if pac64(PChar(p)+384)^[0] > pac64(PChar(p)+61)^[0] then pac64(PChar(p)+178)^[0] := pac64(PChar(p)+335)^[0] - (pac64(PChar(p)+266)^[0] + $7ee33c566678) else begin  num := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := pac32(PChar(p)+10)^[0]; pac32(PChar(p)+10)^[0] := num; end;
 pac16(PChar(p)+8)^[0] := ror2(pac16(PChar(p)+327)^[0] , 11 );
 if pac16(PChar(p)+387)^[0] < pac16(PChar(p)+424)^[0] then pac16(PChar(p)+16)^[0] := pac16(PChar(p)+16)^[0] or $b6 else begin  num := pac16(PChar(p)+98)^[0]; pac16(PChar(p)+98)^[0] := pac16(PChar(p)+351)^[0]; pac16(PChar(p)+351)^[0] := num; end;

 if pac32(PChar(p)+152)^[0] < pac32(PChar(p)+67)^[0] then begin
   pac8(PChar(p)+170)^[0] := pac8(PChar(p)+170)^[0] + $0c;
   pac8(PChar(p)+43)^[0] := pac8(PChar(p)+43)^[0] or rol1(pac8(PChar(p)+158)^[0] , 5 );
 end;

 pac32(PChar(p)+396)^[0] := pac32(PChar(p)+396)^[0] + (pac32(PChar(p)+145)^[0] + $88d7da);
 pac16(PChar(p)+157)^[0] := pac16(PChar(p)+157)^[0] + ror1(pac16(PChar(p)+212)^[0] , 15 );

DB517D34(p);

end;

procedure DB517D34(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+85)^[0] := pac8(PChar(p)+85)^[0] xor ror2(pac8(PChar(p)+342)^[0] , 6 );

 if pac32(PChar(p)+385)^[0] > pac32(PChar(p)+74)^[0] then begin
   pac64(PChar(p)+410)^[0] := pac64(PChar(p)+410)^[0] xor $583a0d461316;
   num := pac16(PChar(p)+387)^[0]; pac16(PChar(p)+387)^[0] := pac16(PChar(p)+114)^[0]; pac16(PChar(p)+114)^[0] := num;
   pac64(PChar(p)+306)^[0] := pac64(PChar(p)+179)^[0] xor $06b1e6c33eb7;
   num := pac8(PChar(p)+143)^[0]; pac8(PChar(p)+143)^[0] := pac8(PChar(p)+189)^[0]; pac8(PChar(p)+189)^[0] := num;
   pac16(PChar(p)+119)^[0] := pac16(PChar(p)+119)^[0] - $ce;
 end;

 pac32(PChar(p)+392)^[0] := pac32(PChar(p)+392)^[0] xor ror2(pac32(PChar(p)+60)^[0] , 23 );
 if pac8(PChar(p)+204)^[0] < pac8(PChar(p)+331)^[0] then pac16(PChar(p)+380)^[0] := pac16(PChar(p)+380)^[0] - (pac16(PChar(p)+230)^[0] or $92) else pac8(PChar(p)+155)^[0] := pac8(PChar(p)+410)^[0] + (pac8(PChar(p)+133)^[0] + $82);
 pac64(PChar(p)+265)^[0] := pac64(PChar(p)+265)^[0] or (pac64(PChar(p)+172)^[0] xor $b8dd7fd3c348);
 if pac8(PChar(p)+248)^[0] < pac8(PChar(p)+330)^[0] then pac16(PChar(p)+165)^[0] := pac16(PChar(p)+165)^[0] or ror2(pac16(PChar(p)+250)^[0] , 14 );
 pac16(PChar(p)+25)^[0] := pac16(PChar(p)+25)^[0] xor $a4;
 if pac8(PChar(p)+381)^[0] > pac8(PChar(p)+424)^[0] then begin  num := pac16(PChar(p)+391)^[0]; pac16(PChar(p)+391)^[0] := pac16(PChar(p)+330)^[0]; pac16(PChar(p)+330)^[0] := num; end else pac64(PChar(p)+472)^[0] := pac64(PChar(p)+265)^[0] or $f03ee13d38;
 pac64(PChar(p)+328)^[0] := pac64(PChar(p)+328)^[0] or $46cd478143;
 pac64(PChar(p)+185)^[0] := pac64(PChar(p)+185)^[0] - (pac64(PChar(p)+463)^[0] - $d66a356ac7);
 num := pac16(PChar(p)+243)^[0]; pac16(PChar(p)+243)^[0] := pac16(PChar(p)+446)^[0]; pac16(PChar(p)+446)^[0] := num;
 pac16(PChar(p)+156)^[0] := pac16(PChar(p)+156)^[0] or $72;
 if pac64(PChar(p)+389)^[0] < pac64(PChar(p)+152)^[0] then pac64(PChar(p)+57)^[0] := pac64(PChar(p)+57)^[0] + $065258a07f81 else pac64(PChar(p)+84)^[0] := pac64(PChar(p)+84)^[0] or $d89f2c5a1a49;
 pac8(PChar(p)+408)^[0] := pac8(PChar(p)+408)^[0] or ror2(pac8(PChar(p)+452)^[0] , 6 );

 if pac64(PChar(p)+184)^[0] < pac64(PChar(p)+105)^[0] then begin
   pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] + (pac64(PChar(p)+476)^[0] or $be3c5830);
   if pac32(PChar(p)+6)^[0] < pac32(PChar(p)+233)^[0] then pac32(PChar(p)+378)^[0] := pac32(PChar(p)+378)^[0] xor (pac32(PChar(p)+473)^[0] + $ccd9b0) else pac64(PChar(p)+68)^[0] := pac64(PChar(p)+68)^[0] - (pac64(PChar(p)+189)^[0] - $1888702ecb);
 end;

 if pac64(PChar(p)+396)^[0] < pac64(PChar(p)+422)^[0] then begin  num := pac16(PChar(p)+114)^[0]; pac16(PChar(p)+114)^[0] := pac16(PChar(p)+224)^[0]; pac16(PChar(p)+224)^[0] := num; end else begin  num := pac32(PChar(p)+349)^[0]; pac32(PChar(p)+349)^[0] := pac32(PChar(p)+470)^[0]; pac32(PChar(p)+470)^[0] := num; end;

E40E4FF0(p);

end;

procedure E40E4FF0(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+124)^[0] := pac64(PChar(p)+124)^[0] - $10f92df7c0c5;

 if pac16(PChar(p)+465)^[0] < pac16(PChar(p)+90)^[0] then begin
   pac32(PChar(p)+192)^[0] := pac32(PChar(p)+192)^[0] - (pac32(PChar(p)+130)^[0] or $0838);
   pac32(PChar(p)+8)^[0] := pac32(PChar(p)+8)^[0] + $307f;
   pac16(PChar(p)+208)^[0] := pac16(PChar(p)+208)^[0] xor $7a;
 end;

 pac64(PChar(p)+148)^[0] := pac64(PChar(p)+148)^[0] or $2e4f6ddbfc;

 if pac32(PChar(p)+388)^[0] < pac32(PChar(p)+444)^[0] then begin
   pac16(PChar(p)+118)^[0] := pac16(PChar(p)+118)^[0] - ror1(pac16(PChar(p)+91)^[0] , 7 );
   pac32(PChar(p)+191)^[0] := pac32(PChar(p)+191)^[0] - (pac32(PChar(p)+5)^[0] - $a283);
 end;

 pac32(PChar(p)+180)^[0] := pac32(PChar(p)+180)^[0] xor ror2(pac32(PChar(p)+470)^[0] , 6 );
 pac32(PChar(p)+34)^[0] := pac32(PChar(p)+34)^[0] xor $e2b7;
 if pac16(PChar(p)+502)^[0] < pac16(PChar(p)+156)^[0] then begin  num := pac16(PChar(p)+394)^[0]; pac16(PChar(p)+394)^[0] := pac16(PChar(p)+368)^[0]; pac16(PChar(p)+368)^[0] := num; end else pac32(PChar(p)+313)^[0] := pac32(PChar(p)+313)^[0] xor (pac32(PChar(p)+125)^[0] + $f4285d);
 pac32(PChar(p)+55)^[0] := ror2(pac32(PChar(p)+466)^[0] , 14 );
 pac64(PChar(p)+326)^[0] := pac64(PChar(p)+326)^[0] xor (pac64(PChar(p)+298)^[0] xor $864404fe);
 pac32(PChar(p)+34)^[0] := pac32(PChar(p)+34)^[0] or rol1(pac32(PChar(p)+270)^[0] , 24 );
 pac16(PChar(p)+251)^[0] := pac16(PChar(p)+251)^[0] + rol1(pac16(PChar(p)+132)^[0] , 2 );
 pac16(PChar(p)+281)^[0] := pac16(PChar(p)+281)^[0] xor ror1(pac16(PChar(p)+120)^[0] , 15 );
 if pac64(PChar(p)+349)^[0] < pac64(PChar(p)+455)^[0] then pac64(PChar(p)+440)^[0] := pac64(PChar(p)+440)^[0] xor (pac64(PChar(p)+324)^[0] or $120b71c5) else pac64(PChar(p)+173)^[0] := pac64(PChar(p)+173)^[0] xor (pac64(PChar(p)+88)^[0] + $94847341eb9b);
 pac32(PChar(p)+397)^[0] := ror2(pac32(PChar(p)+69)^[0] , 10 );
 if pac64(PChar(p)+105)^[0] > pac64(PChar(p)+31)^[0] then begin  num := pac32(PChar(p)+10)^[0]; pac32(PChar(p)+10)^[0] := pac32(PChar(p)+303)^[0]; pac32(PChar(p)+303)^[0] := num; end else begin  num := pac32(PChar(p)+82)^[0]; pac32(PChar(p)+82)^[0] := pac32(PChar(p)+90)^[0]; pac32(PChar(p)+90)^[0] := num; end;
 pac32(PChar(p)+91)^[0] := pac32(PChar(p)+442)^[0] or (pac32(PChar(p)+397)^[0] + $446a0c);
 pac64(PChar(p)+117)^[0] := pac64(PChar(p)+117)^[0] - $2cdcfd51;
 pac64(PChar(p)+144)^[0] := pac64(PChar(p)+76)^[0] + (pac64(PChar(p)+108)^[0] xor $d66aa3cc08);

EF734C9D(p);

end;

procedure EF734C9D(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+250)^[0] < pac8(PChar(p)+3)^[0] then begin
   pac32(PChar(p)+242)^[0] := pac32(PChar(p)+242)^[0] - (pac32(PChar(p)+192)^[0] xor $b61d);
   pac64(PChar(p)+57)^[0] := pac64(PChar(p)+57)^[0] - (pac64(PChar(p)+139)^[0] or $a4c93030d12a);
 end;

 num := pac32(PChar(p)+273)^[0]; pac32(PChar(p)+273)^[0] := pac32(PChar(p)+31)^[0]; pac32(PChar(p)+31)^[0] := num;
 if pac8(PChar(p)+459)^[0] < pac8(PChar(p)+473)^[0] then pac32(PChar(p)+404)^[0] := pac32(PChar(p)+404)^[0] or (pac32(PChar(p)+358)^[0] + $2e538d) else pac64(PChar(p)+303)^[0] := pac64(PChar(p)+316)^[0] or $6206b89b0abd;
 pac16(PChar(p)+489)^[0] := pac16(PChar(p)+489)^[0] or rol1(pac16(PChar(p)+374)^[0] , 2 );
 pac16(PChar(p)+196)^[0] := pac16(PChar(p)+196)^[0] or rol1(pac16(PChar(p)+235)^[0] , 7 );
 pac8(PChar(p)+414)^[0] := pac8(PChar(p)+414)^[0] + ror2(pac8(PChar(p)+97)^[0] , 6 );
 pac32(PChar(p)+441)^[0] := pac32(PChar(p)+441)^[0] xor rol1(pac32(PChar(p)+84)^[0] , 20 );
 if pac32(PChar(p)+221)^[0] < pac32(PChar(p)+396)^[0] then pac64(PChar(p)+196)^[0] := pac64(PChar(p)+196)^[0] or (pac64(PChar(p)+417)^[0] + $9ee59b24) else pac32(PChar(p)+232)^[0] := pac32(PChar(p)+232)^[0] xor rol1(pac32(PChar(p)+13)^[0] , 14 );

 if pac16(PChar(p)+459)^[0] > pac16(PChar(p)+358)^[0] then begin
   pac16(PChar(p)+452)^[0] := pac16(PChar(p)+452)^[0] - ror2(pac16(PChar(p)+333)^[0] , 13 );
   pac32(PChar(p)+193)^[0] := pac32(PChar(p)+193)^[0] xor $d4a64f;
   num := pac8(PChar(p)+222)^[0]; pac8(PChar(p)+222)^[0] := pac8(PChar(p)+244)^[0]; pac8(PChar(p)+244)^[0] := num;
   pac8(PChar(p)+27)^[0] := pac8(PChar(p)+27)^[0] or ror2(pac8(PChar(p)+349)^[0] , 3 );
   pac64(PChar(p)+417)^[0] := pac64(PChar(p)+423)^[0] or $006d8476b1;
 end;


 if pac16(PChar(p)+380)^[0] < pac16(PChar(p)+487)^[0] then begin
   num := pac32(PChar(p)+203)^[0]; pac32(PChar(p)+203)^[0] := pac32(PChar(p)+111)^[0]; pac32(PChar(p)+111)^[0] := num;
   pac8(PChar(p)+98)^[0] := pac8(PChar(p)+347)^[0] or $4e;
   if pac8(PChar(p)+178)^[0] > pac8(PChar(p)+507)^[0] then pac32(PChar(p)+144)^[0] := pac32(PChar(p)+144)^[0] - ror2(pac32(PChar(p)+297)^[0] , 22 ) else pac64(PChar(p)+452)^[0] := pac64(PChar(p)+445)^[0] - (pac64(PChar(p)+325)^[0] or $6e2c0886);
   if pac64(PChar(p)+491)^[0] > pac64(PChar(p)+190)^[0] then pac32(PChar(p)+140)^[0] := pac32(PChar(p)+140)^[0] or $621855 else pac16(PChar(p)+180)^[0] := rol1(pac16(PChar(p)+128)^[0] , 10 );
   num := pac8(PChar(p)+145)^[0]; pac8(PChar(p)+145)^[0] := pac8(PChar(p)+417)^[0]; pac8(PChar(p)+417)^[0] := num;
 end;


FF16DCE2(p);

end;

procedure FF16DCE2(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+50)^[0] := pac32(PChar(p)+50)^[0] or ror2(pac32(PChar(p)+48)^[0] , 5 );
 pac8(PChar(p)+375)^[0] := pac8(PChar(p)+375)^[0] or $40;
 pac64(PChar(p)+482)^[0] := pac64(PChar(p)+482)^[0] or $b026bae6dc;
 pac32(PChar(p)+220)^[0] := pac32(PChar(p)+220)^[0] + ror2(pac32(PChar(p)+130)^[0] , 3 );
 num := pac32(PChar(p)+342)^[0]; pac32(PChar(p)+342)^[0] := pac32(PChar(p)+425)^[0]; pac32(PChar(p)+425)^[0] := num;
 pac64(PChar(p)+196)^[0] := pac64(PChar(p)+196)^[0] xor (pac64(PChar(p)+431)^[0] xor $a0c080cbca);
 num := pac8(PChar(p)+138)^[0]; pac8(PChar(p)+138)^[0] := pac8(PChar(p)+15)^[0]; pac8(PChar(p)+15)^[0] := num;
 pac8(PChar(p)+47)^[0] := pac8(PChar(p)+47)^[0] xor $e0;

 if pac64(PChar(p)+325)^[0] > pac64(PChar(p)+441)^[0] then begin
   pac16(PChar(p)+70)^[0] := pac16(PChar(p)+70)^[0] - rol1(pac16(PChar(p)+35)^[0] , 9 );
   pac32(PChar(p)+319)^[0] := pac32(PChar(p)+319)^[0] or (pac32(PChar(p)+47)^[0] - $f0f2);
   pac16(PChar(p)+156)^[0] := pac16(PChar(p)+156)^[0] xor rol1(pac16(PChar(p)+50)^[0] , 1 );
   pac32(PChar(p)+37)^[0] := pac32(PChar(p)+37)^[0] - (pac32(PChar(p)+129)^[0] or $d05298);
   if pac16(PChar(p)+449)^[0] < pac16(PChar(p)+318)^[0] then pac16(PChar(p)+231)^[0] := pac16(PChar(p)+231)^[0] xor (pac16(PChar(p)+261)^[0] or $f0) else pac16(PChar(p)+327)^[0] := pac16(PChar(p)+327)^[0] or ror2(pac16(PChar(p)+132)^[0] , 15 );
 end;

 pac32(PChar(p)+239)^[0] := pac32(PChar(p)+239)^[0] - (pac32(PChar(p)+340)^[0] + $90e0);
 pac32(PChar(p)+278)^[0] := pac32(PChar(p)+278)^[0] xor rol1(pac32(PChar(p)+352)^[0] , 17 );

F8392DEE(p);

end;

procedure F8392DEE(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+63)^[0] > pac16(PChar(p)+336)^[0] then begin
   if pac8(PChar(p)+346)^[0] > pac8(PChar(p)+466)^[0] then pac8(PChar(p)+179)^[0] := pac8(PChar(p)+179)^[0] + ror1(pac8(PChar(p)+131)^[0] , 7 ) else pac32(PChar(p)+502)^[0] := ror2(pac32(PChar(p)+203)^[0] , 14 );
   num := pac8(PChar(p)+64)^[0]; pac8(PChar(p)+64)^[0] := pac8(PChar(p)+9)^[0]; pac8(PChar(p)+9)^[0] := num;
 end;

 pac64(PChar(p)+262)^[0] := pac64(PChar(p)+262)^[0] - (pac64(PChar(p)+409)^[0] or $40945e372e);
 pac64(PChar(p)+329)^[0] := pac64(PChar(p)+329)^[0] xor $00931def7522;
 if pac64(PChar(p)+86)^[0] > pac64(PChar(p)+227)^[0] then pac8(PChar(p)+441)^[0] := pac8(PChar(p)+251)^[0] or (pac8(PChar(p)+261)^[0] or $70) else begin  num := pac16(PChar(p)+2)^[0]; pac16(PChar(p)+2)^[0] := pac16(PChar(p)+274)^[0]; pac16(PChar(p)+274)^[0] := num; end;

 if pac16(PChar(p)+62)^[0] < pac16(PChar(p)+119)^[0] then begin
   pac8(PChar(p)+415)^[0] := pac8(PChar(p)+415)^[0] + ror2(pac8(PChar(p)+30)^[0] , 5 );
   pac32(PChar(p)+227)^[0] := rol1(pac32(PChar(p)+104)^[0] , 6 );
 end;


 if pac16(PChar(p)+39)^[0] < pac16(PChar(p)+225)^[0] then begin
   pac64(PChar(p)+340)^[0] := pac64(PChar(p)+492)^[0] xor $80ea5d79689f;
   pac64(PChar(p)+197)^[0] := pac64(PChar(p)+197)^[0] xor (pac64(PChar(p)+369)^[0] - $70c50881c1dd);
   if pac16(PChar(p)+491)^[0] > pac16(PChar(p)+370)^[0] then pac32(PChar(p)+305)^[0] := pac32(PChar(p)+253)^[0] + (pac32(PChar(p)+318)^[0] - $b068) else begin  num := pac16(PChar(p)+212)^[0]; pac16(PChar(p)+212)^[0] := pac16(PChar(p)+182)^[0]; pac16(PChar(p)+182)^[0] := num; end;
   pac16(PChar(p)+414)^[0] := pac16(PChar(p)+414)^[0] xor $30;
   pac8(PChar(p)+190)^[0] := pac8(PChar(p)+190)^[0] + (pac8(PChar(p)+168)^[0] xor $b0);
 end;

 pac32(PChar(p)+301)^[0] := pac32(PChar(p)+301)^[0] or rol1(pac32(PChar(p)+170)^[0] , 6 );
 num := pac16(PChar(p)+432)^[0]; pac16(PChar(p)+432)^[0] := pac16(PChar(p)+69)^[0]; pac16(PChar(p)+69)^[0] := num;
 pac32(PChar(p)+409)^[0] := pac32(PChar(p)+500)^[0] - (pac32(PChar(p)+154)^[0] or $103b);

 if pac16(PChar(p)+304)^[0] > pac16(PChar(p)+212)^[0] then begin
   pac32(PChar(p)+304)^[0] := pac32(PChar(p)+32)^[0] - $c03e;
   if pac8(PChar(p)+325)^[0] > pac8(PChar(p)+1)^[0] then begin  num := pac8(PChar(p)+167)^[0]; pac8(PChar(p)+167)^[0] := pac8(PChar(p)+450)^[0]; pac8(PChar(p)+450)^[0] := num; end else pac32(PChar(p)+258)^[0] := rol1(pac32(PChar(p)+286)^[0] , 26 );
   pac64(PChar(p)+271)^[0] := pac64(PChar(p)+271)^[0] - $f0a3031b;
 end;

 num := pac8(PChar(p)+87)^[0]; pac8(PChar(p)+87)^[0] := pac8(PChar(p)+323)^[0]; pac8(PChar(p)+323)^[0] := num;
 pac8(PChar(p)+240)^[0] := ror1(pac8(PChar(p)+37)^[0] , 2 );
 num := pac16(PChar(p)+132)^[0]; pac16(PChar(p)+132)^[0] := pac16(PChar(p)+488)^[0]; pac16(PChar(p)+488)^[0] := num;
 num := pac16(PChar(p)+351)^[0]; pac16(PChar(p)+351)^[0] := pac16(PChar(p)+168)^[0]; pac16(PChar(p)+168)^[0] := num;
 pac64(PChar(p)+438)^[0] := pac64(PChar(p)+438)^[0] or $30fb0cd1;
 pac64(PChar(p)+465)^[0] := pac64(PChar(p)+459)^[0] or (pac64(PChar(p)+341)^[0] - $30f7a8121e);
 if pac32(PChar(p)+172)^[0] < pac32(PChar(p)+319)^[0] then pac64(PChar(p)+361)^[0] := pac64(PChar(p)+361)^[0] or $60d531f31e else begin  num := pac16(PChar(p)+478)^[0]; pac16(PChar(p)+478)^[0] := pac16(PChar(p)+256)^[0]; pac16(PChar(p)+256)^[0] := num; end;

 if pac32(PChar(p)+3)^[0] > pac32(PChar(p)+280)^[0] then begin
   pac16(PChar(p)+387)^[0] := pac16(PChar(p)+282)^[0] + (pac16(PChar(p)+144)^[0] - $f0);
   pac16(PChar(p)+257)^[0] := pac16(PChar(p)+257)^[0] xor ror2(pac16(PChar(p)+76)^[0] , 9 );
   pac8(PChar(p)+179)^[0] := ror2(pac8(PChar(p)+362)^[0] , 2 );
   pac32(PChar(p)+434)^[0] := pac32(PChar(p)+384)^[0] xor $c086;
 end;

 pac64(PChar(p)+117)^[0] := pac64(PChar(p)+117)^[0] or $60ec62e88dac;

CF42D5CA(p);

end;

procedure CF42D5CA(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+467)^[0] > pac16(PChar(p)+127)^[0] then pac16(PChar(p)+146)^[0] := pac16(PChar(p)+146)^[0] or ror1(pac16(PChar(p)+362)^[0] , 8 ) else pac8(PChar(p)+364)^[0] := pac8(PChar(p)+364)^[0] + rol1(pac8(PChar(p)+224)^[0] , 7 );

 if pac64(PChar(p)+268)^[0] > pac64(PChar(p)+412)^[0] then begin
   pac32(PChar(p)+336)^[0] := pac32(PChar(p)+336)^[0] or (pac32(PChar(p)+95)^[0] + $b08ba1);
   if pac8(PChar(p)+353)^[0] > pac8(PChar(p)+345)^[0] then begin  num := pac16(PChar(p)+438)^[0]; pac16(PChar(p)+438)^[0] := pac16(PChar(p)+139)^[0]; pac16(PChar(p)+139)^[0] := num; end else pac64(PChar(p)+440)^[0] := pac64(PChar(p)+219)^[0] - (pac64(PChar(p)+41)^[0] + $30a01aeefa);
   num := pac32(PChar(p)+135)^[0]; pac32(PChar(p)+135)^[0] := pac32(PChar(p)+400)^[0]; pac32(PChar(p)+400)^[0] := num;
 end;


 if pac16(PChar(p)+281)^[0] > pac16(PChar(p)+197)^[0] then begin
   num := pac32(PChar(p)+170)^[0]; pac32(PChar(p)+170)^[0] := pac32(PChar(p)+363)^[0]; pac32(PChar(p)+363)^[0] := num;
   pac64(PChar(p)+114)^[0] := pac64(PChar(p)+114)^[0] or $e050fa5c;
   pac32(PChar(p)+83)^[0] := pac32(PChar(p)+83)^[0] + ror2(pac32(PChar(p)+228)^[0] , 17 );
   pac16(PChar(p)+409)^[0] := pac16(PChar(p)+409)^[0] + rol1(pac16(PChar(p)+303)^[0] , 1 );
 end;

 num := pac8(PChar(p)+131)^[0]; pac8(PChar(p)+131)^[0] := pac8(PChar(p)+305)^[0]; pac8(PChar(p)+305)^[0] := num;
 pac32(PChar(p)+9)^[0] := pac32(PChar(p)+9)^[0] or ror1(pac32(PChar(p)+408)^[0] , 9 );
 pac64(PChar(p)+268)^[0] := pac64(PChar(p)+268)^[0] + $704cdbf6;
 num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+343)^[0]; pac8(PChar(p)+343)^[0] := num;
 pac32(PChar(p)+309)^[0] := pac32(PChar(p)+309)^[0] or rol1(pac32(PChar(p)+337)^[0] , 3 );
 num := pac32(PChar(p)+33)^[0]; pac32(PChar(p)+33)^[0] := pac32(PChar(p)+441)^[0]; pac32(PChar(p)+441)^[0] := num;
 num := pac32(PChar(p)+186)^[0]; pac32(PChar(p)+186)^[0] := pac32(PChar(p)+143)^[0]; pac32(PChar(p)+143)^[0] := num;
 pac32(PChar(p)+107)^[0] := pac32(PChar(p)+347)^[0] xor (pac32(PChar(p)+273)^[0] or $c062);
 num := pac8(PChar(p)+220)^[0]; pac8(PChar(p)+220)^[0] := pac8(PChar(p)+325)^[0]; pac8(PChar(p)+325)^[0] := num;
 num := pac32(PChar(p)+408)^[0]; pac32(PChar(p)+408)^[0] := pac32(PChar(p)+383)^[0]; pac32(PChar(p)+383)^[0] := num;
 pac16(PChar(p)+506)^[0] := pac16(PChar(p)+506)^[0] xor ror2(pac16(PChar(p)+3)^[0] , 12 );
 if pac16(PChar(p)+197)^[0] > pac16(PChar(p)+346)^[0] then pac16(PChar(p)+203)^[0] := pac16(PChar(p)+203)^[0] + $c0 else pac64(PChar(p)+63)^[0] := pac64(PChar(p)+63)^[0] + $f00362a635;

D0E5F592(p);

end;

procedure D0E5F592(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+25)^[0] > pac8(PChar(p)+321)^[0] then pac8(PChar(p)+263)^[0] := pac8(PChar(p)+263)^[0] - rol1(pac8(PChar(p)+497)^[0] , 6 ) else pac64(PChar(p)+143)^[0] := pac64(PChar(p)+143)^[0] or $201efbbc9a97;
 if pac64(PChar(p)+465)^[0] > pac64(PChar(p)+179)^[0] then pac8(PChar(p)+377)^[0] := pac8(PChar(p)+377)^[0] or ror1(pac8(PChar(p)+40)^[0] , 1 ) else begin  num := pac16(PChar(p)+159)^[0]; pac16(PChar(p)+159)^[0] := pac16(PChar(p)+34)^[0]; pac16(PChar(p)+34)^[0] := num; end;
 pac64(PChar(p)+191)^[0] := pac64(PChar(p)+191)^[0] - (pac64(PChar(p)+26)^[0] + $c07db327);
 num := pac8(PChar(p)+248)^[0]; pac8(PChar(p)+248)^[0] := pac8(PChar(p)+202)^[0]; pac8(PChar(p)+202)^[0] := num;
 num := pac16(PChar(p)+206)^[0]; pac16(PChar(p)+206)^[0] := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := num;
 if pac32(PChar(p)+475)^[0] > pac32(PChar(p)+434)^[0] then pac64(PChar(p)+115)^[0] := pac64(PChar(p)+468)^[0] or $3006c4a140 else pac32(PChar(p)+254)^[0] := pac32(PChar(p)+254)^[0] xor rol1(pac32(PChar(p)+440)^[0] , 13 );
 num := pac8(PChar(p)+231)^[0]; pac8(PChar(p)+231)^[0] := pac8(PChar(p)+446)^[0]; pac8(PChar(p)+446)^[0] := num;

 if pac8(PChar(p)+504)^[0] < pac8(PChar(p)+242)^[0] then begin
   pac32(PChar(p)+123)^[0] := pac32(PChar(p)+123)^[0] or rol1(pac32(PChar(p)+84)^[0] , 17 );
   num := pac16(PChar(p)+240)^[0]; pac16(PChar(p)+240)^[0] := pac16(PChar(p)+23)^[0]; pac16(PChar(p)+23)^[0] := num;
   pac16(PChar(p)+411)^[0] := pac16(PChar(p)+411)^[0] - (pac16(PChar(p)+414)^[0] or $50);
   pac32(PChar(p)+209)^[0] := pac32(PChar(p)+209)^[0] - rol1(pac32(PChar(p)+99)^[0] , 1 );
   num := pac32(PChar(p)+477)^[0]; pac32(PChar(p)+477)^[0] := pac32(PChar(p)+486)^[0]; pac32(PChar(p)+486)^[0] := num;
 end;

 pac64(PChar(p)+363)^[0] := pac64(PChar(p)+363)^[0] or (pac64(PChar(p)+255)^[0] xor $10c3012910b6);
 num := pac16(PChar(p)+332)^[0]; pac16(PChar(p)+332)^[0] := pac16(PChar(p)+125)^[0]; pac16(PChar(p)+125)^[0] := num;

E41F62B3(p);

end;

procedure E41F62B3(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] or (pac64(PChar(p)+145)^[0] xor $d0eff657989a);
 pac32(PChar(p)+81)^[0] := pac32(PChar(p)+81)^[0] + $9040;
 num := pac8(PChar(p)+430)^[0]; pac8(PChar(p)+430)^[0] := pac8(PChar(p)+411)^[0]; pac8(PChar(p)+411)^[0] := num;
 pac64(PChar(p)+233)^[0] := pac64(PChar(p)+233)^[0] or (pac64(PChar(p)+132)^[0] or $307bcd6360);
 pac16(PChar(p)+177)^[0] := pac16(PChar(p)+177)^[0] - (pac16(PChar(p)+314)^[0] + $10);

 if pac64(PChar(p)+491)^[0] < pac64(PChar(p)+174)^[0] then begin
   pac16(PChar(p)+136)^[0] := pac16(PChar(p)+136)^[0] + ror2(pac16(PChar(p)+164)^[0] , 15 );
   if pac32(PChar(p)+337)^[0] < pac32(PChar(p)+320)^[0] then pac16(PChar(p)+273)^[0] := pac16(PChar(p)+273)^[0] xor ror1(pac16(PChar(p)+364)^[0] , 15 ) else begin  num := pac8(PChar(p)+31)^[0]; pac8(PChar(p)+31)^[0] := pac8(PChar(p)+443)^[0]; pac8(PChar(p)+443)^[0] := num; end;
 end;

 num := pac8(PChar(p)+220)^[0]; pac8(PChar(p)+220)^[0] := pac8(PChar(p)+392)^[0]; pac8(PChar(p)+392)^[0] := num;
 pac8(PChar(p)+253)^[0] := pac8(PChar(p)+253)^[0] or (pac8(PChar(p)+295)^[0] - $b0);

 if pac64(PChar(p)+398)^[0] < pac64(PChar(p)+189)^[0] then begin
   pac8(PChar(p)+282)^[0] := pac8(PChar(p)+282)^[0] or rol1(pac8(PChar(p)+155)^[0] , 1 );
   if pac8(PChar(p)+426)^[0] > pac8(PChar(p)+30)^[0] then pac8(PChar(p)+15)^[0] := ror1(pac8(PChar(p)+56)^[0] , 3 );
   if pac8(PChar(p)+114)^[0] < pac8(PChar(p)+233)^[0] then pac64(PChar(p)+462)^[0] := pac64(PChar(p)+231)^[0] xor (pac64(PChar(p)+184)^[0] - $20bc0570) else begin  num := pac8(PChar(p)+480)^[0]; pac8(PChar(p)+480)^[0] := pac8(PChar(p)+314)^[0]; pac8(PChar(p)+314)^[0] := num; end;
 end;

 pac16(PChar(p)+424)^[0] := pac16(PChar(p)+460)^[0] + (pac16(PChar(p)+30)^[0] + $e0);
 pac32(PChar(p)+243)^[0] := pac32(PChar(p)+243)^[0] xor ror2(pac32(PChar(p)+113)^[0] , 28 );
 pac32(PChar(p)+329)^[0] := ror2(pac32(PChar(p)+128)^[0] , 12 );
 pac16(PChar(p)+252)^[0] := pac16(PChar(p)+252)^[0] xor ror2(pac16(PChar(p)+414)^[0] , 1 );
 pac64(PChar(p)+397)^[0] := pac64(PChar(p)+397)^[0] - $e0daa570;
 if pac64(PChar(p)+376)^[0] < pac64(PChar(p)+438)^[0] then pac32(PChar(p)+364)^[0] := ror2(pac32(PChar(p)+467)^[0] , 11 ) else pac64(PChar(p)+412)^[0] := pac64(PChar(p)+412)^[0] xor $3056de367a34;

 if pac32(PChar(p)+404)^[0] > pac32(PChar(p)+306)^[0] then begin
   if pac64(PChar(p)+474)^[0] > pac64(PChar(p)+192)^[0] then pac32(PChar(p)+13)^[0] := pac32(PChar(p)+319)^[0] xor $303e else pac32(PChar(p)+1)^[0] := pac32(PChar(p)+1)^[0] + $c0e3;
   if pac64(PChar(p)+283)^[0] < pac64(PChar(p)+502)^[0] then pac32(PChar(p)+375)^[0] := ror2(pac32(PChar(p)+154)^[0] , 19 ) else pac16(PChar(p)+379)^[0] := pac16(PChar(p)+379)^[0] or ror1(pac16(PChar(p)+102)^[0] , 10 );
   pac16(PChar(p)+3)^[0] := pac16(PChar(p)+3)^[0] + $a0;
   if pac8(PChar(p)+277)^[0] < pac8(PChar(p)+17)^[0] then pac32(PChar(p)+117)^[0] := pac32(PChar(p)+117)^[0] + $901c else pac64(PChar(p)+398)^[0] := pac64(PChar(p)+401)^[0] + $a061ae896fa7;
 end;


EF66B422(p);

end;

procedure EF66B422(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+201)^[0] < pac32(PChar(p)+77)^[0] then pac64(PChar(p)+98)^[0] := pac64(PChar(p)+76)^[0] + $f0fcfa88 else begin  num := pac16(PChar(p)+386)^[0]; pac16(PChar(p)+386)^[0] := pac16(PChar(p)+408)^[0]; pac16(PChar(p)+408)^[0] := num; end;
 if pac64(PChar(p)+202)^[0] > pac64(PChar(p)+144)^[0] then begin  num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+336)^[0]; pac8(PChar(p)+336)^[0] := num; end else pac16(PChar(p)+280)^[0] := pac16(PChar(p)+280)^[0] - ror2(pac16(PChar(p)+74)^[0] , 13 );
 num := pac8(PChar(p)+6)^[0]; pac8(PChar(p)+6)^[0] := pac8(PChar(p)+90)^[0]; pac8(PChar(p)+90)^[0] := num;
 pac16(PChar(p)+339)^[0] := rol1(pac16(PChar(p)+49)^[0] , 8 );

 if pac32(PChar(p)+202)^[0] < pac32(PChar(p)+416)^[0] then begin
   pac32(PChar(p)+122)^[0] := pac32(PChar(p)+122)^[0] xor $a0b922;
   pac8(PChar(p)+398)^[0] := pac8(PChar(p)+398)^[0] or ror2(pac8(PChar(p)+24)^[0] , 2 );
   num := pac16(PChar(p)+33)^[0]; pac16(PChar(p)+33)^[0] := pac16(PChar(p)+355)^[0]; pac16(PChar(p)+355)^[0] := num;
 end;

 if pac8(PChar(p)+437)^[0] < pac8(PChar(p)+142)^[0] then pac32(PChar(p)+45)^[0] := pac32(PChar(p)+385)^[0] - $607c13;
 num := pac32(PChar(p)+280)^[0]; pac32(PChar(p)+280)^[0] := pac32(PChar(p)+141)^[0]; pac32(PChar(p)+141)^[0] := num;
 pac8(PChar(p)+27)^[0] := pac8(PChar(p)+27)^[0] or $30;
 num := pac8(PChar(p)+372)^[0]; pac8(PChar(p)+372)^[0] := pac8(PChar(p)+24)^[0]; pac8(PChar(p)+24)^[0] := num;
 num := pac32(PChar(p)+163)^[0]; pac32(PChar(p)+163)^[0] := pac32(PChar(p)+267)^[0]; pac32(PChar(p)+267)^[0] := num;

 if pac8(PChar(p)+11)^[0] > pac8(PChar(p)+468)^[0] then begin
   if pac8(PChar(p)+190)^[0] > pac8(PChar(p)+421)^[0] then begin  num := pac8(PChar(p)+460)^[0]; pac8(PChar(p)+460)^[0] := pac8(PChar(p)+379)^[0]; pac8(PChar(p)+379)^[0] := num; end else pac64(PChar(p)+291)^[0] := pac64(PChar(p)+291)^[0] + $903294e9;
   pac32(PChar(p)+234)^[0] := pac32(PChar(p)+469)^[0] - (pac32(PChar(p)+190)^[0] - $f0c4);
   pac32(PChar(p)+50)^[0] := pac32(PChar(p)+50)^[0] - $305a;
   num := pac32(PChar(p)+498)^[0]; pac32(PChar(p)+498)^[0] := pac32(PChar(p)+121)^[0]; pac32(PChar(p)+121)^[0] := num;
 end;

 if pac64(PChar(p)+364)^[0] > pac64(PChar(p)+496)^[0] then begin  num := pac16(PChar(p)+489)^[0]; pac16(PChar(p)+489)^[0] := pac16(PChar(p)+156)^[0]; pac16(PChar(p)+156)^[0] := num; end else begin  num := pac8(PChar(p)+93)^[0]; pac8(PChar(p)+93)^[0] := pac8(PChar(p)+338)^[0]; pac8(PChar(p)+338)^[0] := num; end;
 pac32(PChar(p)+442)^[0] := pac32(PChar(p)+165)^[0] xor (pac32(PChar(p)+496)^[0] + $e019);

 if pac8(PChar(p)+213)^[0] > pac8(PChar(p)+145)^[0] then begin
   pac64(PChar(p)+46)^[0] := pac64(PChar(p)+326)^[0] - (pac64(PChar(p)+28)^[0] - $9089fc33d7);
   pac32(PChar(p)+285)^[0] := pac32(PChar(p)+285)^[0] - (pac32(PChar(p)+300)^[0] xor $f074);
   pac8(PChar(p)+218)^[0] := pac8(PChar(p)+218)^[0] or ror2(pac8(PChar(p)+188)^[0] , 5 );
   pac8(PChar(p)+435)^[0] := pac8(PChar(p)+435)^[0] + ror1(pac8(PChar(p)+49)^[0] , 7 );
   pac32(PChar(p)+355)^[0] := pac32(PChar(p)+355)^[0] or ror1(pac32(PChar(p)+334)^[0] , 21 );
 end;

 pac16(PChar(p)+317)^[0] := pac16(PChar(p)+317)^[0] + (pac16(PChar(p)+141)^[0] or $a0);

 if pac16(PChar(p)+47)^[0] > pac16(PChar(p)+337)^[0] then begin
   pac8(PChar(p)+282)^[0] := ror2(pac8(PChar(p)+5)^[0] , 3 );
   num := pac32(PChar(p)+130)^[0]; pac32(PChar(p)+130)^[0] := pac32(PChar(p)+368)^[0]; pac32(PChar(p)+368)^[0] := num;
 end;

 num := pac32(PChar(p)+252)^[0]; pac32(PChar(p)+252)^[0] := pac32(PChar(p)+388)^[0]; pac32(PChar(p)+388)^[0] := num;
 pac16(PChar(p)+205)^[0] := ror2(pac16(PChar(p)+239)^[0] , 3 );
 num := pac8(PChar(p)+79)^[0]; pac8(PChar(p)+79)^[0] := pac8(PChar(p)+102)^[0]; pac8(PChar(p)+102)^[0] := num;

D27BFAF3(p);

end;

procedure D27BFAF3(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+430)^[0] < pac64(PChar(p)+128)^[0] then begin  num := pac16(PChar(p)+259)^[0]; pac16(PChar(p)+259)^[0] := pac16(PChar(p)+285)^[0]; pac16(PChar(p)+285)^[0] := num; end else pac32(PChar(p)+312)^[0] := pac32(PChar(p)+473)^[0] or (pac32(PChar(p)+232)^[0] or $10ad);
 if pac32(PChar(p)+431)^[0] < pac32(PChar(p)+273)^[0] then pac64(PChar(p)+501)^[0] := pac64(PChar(p)+430)^[0] xor $f0808a9445e5 else begin  num := pac32(PChar(p)+34)^[0]; pac32(PChar(p)+34)^[0] := pac32(PChar(p)+94)^[0]; pac32(PChar(p)+94)^[0] := num; end;
 if pac64(PChar(p)+35)^[0] < pac64(PChar(p)+297)^[0] then pac64(PChar(p)+267)^[0] := pac64(PChar(p)+188)^[0] - (pac64(PChar(p)+76)^[0] xor $8086a861c1) else begin  num := pac8(PChar(p)+94)^[0]; pac8(PChar(p)+94)^[0] := pac8(PChar(p)+353)^[0]; pac8(PChar(p)+353)^[0] := num; end;
 pac8(PChar(p)+377)^[0] := pac8(PChar(p)+377)^[0] - ror2(pac8(PChar(p)+205)^[0] , 2 );
 pac32(PChar(p)+278)^[0] := pac32(PChar(p)+278)^[0] - $20afb3;
 if pac16(PChar(p)+464)^[0] > pac16(PChar(p)+84)^[0] then begin  num := pac32(PChar(p)+453)^[0]; pac32(PChar(p)+453)^[0] := pac32(PChar(p)+54)^[0]; pac32(PChar(p)+54)^[0] := num; end else pac16(PChar(p)+194)^[0] := pac16(PChar(p)+194)^[0] - ror2(pac16(PChar(p)+174)^[0] , 13 );
 num := pac32(PChar(p)+28)^[0]; pac32(PChar(p)+28)^[0] := pac32(PChar(p)+61)^[0]; pac32(PChar(p)+61)^[0] := num;
 if pac64(PChar(p)+484)^[0] < pac64(PChar(p)+425)^[0] then pac16(PChar(p)+494)^[0] := ror2(pac16(PChar(p)+155)^[0] , 10 ) else begin  num := pac32(PChar(p)+54)^[0]; pac32(PChar(p)+54)^[0] := pac32(PChar(p)+420)^[0]; pac32(PChar(p)+420)^[0] := num; end;
 num := pac32(PChar(p)+13)^[0]; pac32(PChar(p)+13)^[0] := pac32(PChar(p)+118)^[0]; pac32(PChar(p)+118)^[0] := num;
 if pac8(PChar(p)+404)^[0] < pac8(PChar(p)+406)^[0] then pac8(PChar(p)+230)^[0] := pac8(PChar(p)+230)^[0] xor ror2(pac8(PChar(p)+4)^[0] , 6 ) else begin  num := pac16(PChar(p)+424)^[0]; pac16(PChar(p)+424)^[0] := pac16(PChar(p)+403)^[0]; pac16(PChar(p)+403)^[0] := num; end;
 num := pac8(PChar(p)+429)^[0]; pac8(PChar(p)+429)^[0] := pac8(PChar(p)+364)^[0]; pac8(PChar(p)+364)^[0] := num;
 if pac64(PChar(p)+398)^[0] < pac64(PChar(p)+27)^[0] then begin  num := pac16(PChar(p)+498)^[0]; pac16(PChar(p)+498)^[0] := pac16(PChar(p)+332)^[0]; pac16(PChar(p)+332)^[0] := num; end else pac8(PChar(p)+505)^[0] := pac8(PChar(p)+505)^[0] xor ror1(pac8(PChar(p)+404)^[0] , 6 );

E0C6EE53(p);

end;

procedure E0C6EE53(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+215)^[0] > pac8(PChar(p)+297)^[0] then begin
   pac64(PChar(p)+59)^[0] := pac64(PChar(p)+59)^[0] - $30c5832cc9;
   num := pac32(PChar(p)+382)^[0]; pac32(PChar(p)+382)^[0] := pac32(PChar(p)+403)^[0]; pac32(PChar(p)+403)^[0] := num;
   if pac32(PChar(p)+376)^[0] > pac32(PChar(p)+241)^[0] then pac64(PChar(p)+290)^[0] := pac64(PChar(p)+290)^[0] or $10283468 else pac8(PChar(p)+480)^[0] := pac8(PChar(p)+480)^[0] + ror2(pac8(PChar(p)+195)^[0] , 2 );
 end;

 if pac16(PChar(p)+321)^[0] < pac16(PChar(p)+33)^[0] then begin  num := pac16(PChar(p)+453)^[0]; pac16(PChar(p)+453)^[0] := pac16(PChar(p)+242)^[0]; pac16(PChar(p)+242)^[0] := num; end else pac8(PChar(p)+298)^[0] := pac8(PChar(p)+298)^[0] + ror2(pac8(PChar(p)+164)^[0] , 7 );
 if pac64(PChar(p)+305)^[0] < pac64(PChar(p)+100)^[0] then pac8(PChar(p)+247)^[0] := pac8(PChar(p)+247)^[0] + rol1(pac8(PChar(p)+490)^[0] , 3 ) else pac32(PChar(p)+355)^[0] := ror2(pac32(PChar(p)+138)^[0] , 17 );
 num := pac32(PChar(p)+453)^[0]; pac32(PChar(p)+453)^[0] := pac32(PChar(p)+439)^[0]; pac32(PChar(p)+439)^[0] := num;
 num := pac32(PChar(p)+254)^[0]; pac32(PChar(p)+254)^[0] := pac32(PChar(p)+266)^[0]; pac32(PChar(p)+266)^[0] := num;
 if pac16(PChar(p)+159)^[0] > pac16(PChar(p)+463)^[0] then pac16(PChar(p)+64)^[0] := ror1(pac16(PChar(p)+458)^[0] , 15 ) else begin  num := pac8(PChar(p)+420)^[0]; pac8(PChar(p)+420)^[0] := pac8(PChar(p)+212)^[0]; pac8(PChar(p)+212)^[0] := num; end;
 pac16(PChar(p)+486)^[0] := pac16(PChar(p)+486)^[0] or $90;
 pac64(PChar(p)+343)^[0] := pac64(PChar(p)+343)^[0] or (pac64(PChar(p)+500)^[0] xor $30fc242ba3);
 pac8(PChar(p)+100)^[0] := pac8(PChar(p)+100)^[0] - ror1(pac8(PChar(p)+289)^[0] , 7 );
 if pac8(PChar(p)+329)^[0] < pac8(PChar(p)+145)^[0] then pac8(PChar(p)+237)^[0] := pac8(PChar(p)+237)^[0] or rol1(pac8(PChar(p)+489)^[0] , 7 ) else pac32(PChar(p)+237)^[0] := pac32(PChar(p)+237)^[0] - rol1(pac32(PChar(p)+434)^[0] , 30 );
 num := pac8(PChar(p)+216)^[0]; pac8(PChar(p)+216)^[0] := pac8(PChar(p)+194)^[0]; pac8(PChar(p)+194)^[0] := num;

 if pac32(PChar(p)+153)^[0] < pac32(PChar(p)+456)^[0] then begin
   pac16(PChar(p)+162)^[0] := pac16(PChar(p)+162)^[0] xor ror2(pac16(PChar(p)+158)^[0] , 11 );
   num := pac16(PChar(p)+164)^[0]; pac16(PChar(p)+164)^[0] := pac16(PChar(p)+437)^[0]; pac16(PChar(p)+437)^[0] := num;
   if pac32(PChar(p)+162)^[0] > pac32(PChar(p)+130)^[0] then pac16(PChar(p)+31)^[0] := pac16(PChar(p)+31)^[0] or ror2(pac16(PChar(p)+312)^[0] , 12 ) else pac8(PChar(p)+260)^[0] := pac8(PChar(p)+260)^[0] - $e0;
   pac64(PChar(p)+159)^[0] := pac64(PChar(p)+159)^[0] + (pac64(PChar(p)+324)^[0] xor $00ae072a);
 end;


 if pac32(PChar(p)+59)^[0] < pac32(PChar(p)+12)^[0] then begin
   pac16(PChar(p)+418)^[0] := pac16(PChar(p)+418)^[0] + ror2(pac16(PChar(p)+256)^[0] , 2 );
   pac64(PChar(p)+326)^[0] := pac64(PChar(p)+326)^[0] + (pac64(PChar(p)+78)^[0] - $80d77037);
   pac32(PChar(p)+270)^[0] := pac32(PChar(p)+270)^[0] xor (pac32(PChar(p)+258)^[0] xor $e085);
 end;


 if pac32(PChar(p)+465)^[0] > pac32(PChar(p)+97)^[0] then begin
   if pac32(PChar(p)+425)^[0] > pac32(PChar(p)+489)^[0] then pac32(PChar(p)+52)^[0] := pac32(PChar(p)+52)^[0] or rol1(pac32(PChar(p)+245)^[0] , 8 ) else pac64(PChar(p)+316)^[0] := pac64(PChar(p)+316)^[0] or $80b45cce115f;
   num := pac8(PChar(p)+316)^[0]; pac8(PChar(p)+316)^[0] := pac8(PChar(p)+144)^[0]; pac8(PChar(p)+144)^[0] := num;
   pac64(PChar(p)+376)^[0] := pac64(PChar(p)+62)^[0] - $c0c83ff7;
   pac16(PChar(p)+385)^[0] := pac16(PChar(p)+385)^[0] or ror1(pac16(PChar(p)+110)^[0] , 14 );
   if pac32(PChar(p)+31)^[0] < pac32(PChar(p)+67)^[0] then pac16(PChar(p)+334)^[0] := ror1(pac16(PChar(p)+436)^[0] , 7 ) else pac64(PChar(p)+379)^[0] := pac64(PChar(p)+379)^[0] - (pac64(PChar(p)+173)^[0] xor $f0089bd8bc);
 end;


 if pac32(PChar(p)+499)^[0] < pac32(PChar(p)+290)^[0] then begin
   pac32(PChar(p)+286)^[0] := pac32(PChar(p)+286)^[0] or ror2(pac32(PChar(p)+145)^[0] , 31 );
   pac16(PChar(p)+220)^[0] := pac16(PChar(p)+220)^[0] or $70;
 end;

 pac32(PChar(p)+372)^[0] := pac32(PChar(p)+372)^[0] or (pac32(PChar(p)+478)^[0] or $201b);
 pac64(PChar(p)+186)^[0] := pac64(PChar(p)+46)^[0] or $6099839c6756;
 pac64(PChar(p)+338)^[0] := pac64(PChar(p)+107)^[0] + $808df0f51e;
 pac16(PChar(p)+323)^[0] := pac16(PChar(p)+323)^[0] + (pac16(PChar(p)+229)^[0] - $e0);

A633F120(p);

end;

procedure A633F120(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+406)^[0] := pac64(PChar(p)+406)^[0] + $10e19b31bd;
 num := pac16(PChar(p)+82)^[0]; pac16(PChar(p)+82)^[0] := pac16(PChar(p)+93)^[0]; pac16(PChar(p)+93)^[0] := num;
 pac64(PChar(p)+329)^[0] := pac64(PChar(p)+329)^[0] - (pac64(PChar(p)+1)^[0] + $80bd3475b68e);

 if pac32(PChar(p)+285)^[0] > pac32(PChar(p)+8)^[0] then begin
   pac32(PChar(p)+399)^[0] := pac32(PChar(p)+399)^[0] or $c097;
   pac16(PChar(p)+89)^[0] := pac16(PChar(p)+48)^[0] - $60;
   pac32(PChar(p)+445)^[0] := pac32(PChar(p)+445)^[0] + ror1(pac32(PChar(p)+162)^[0] , 20 );
 end;

 pac64(PChar(p)+18)^[0] := pac64(PChar(p)+18)^[0] + $900e7ec99442;
 pac32(PChar(p)+469)^[0] := pac32(PChar(p)+469)^[0] xor $30519c;
 pac64(PChar(p)+367)^[0] := pac64(PChar(p)+367)^[0] xor (pac64(PChar(p)+427)^[0] xor $5048cce7fddd);
 pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] + $80b93d798f;
 num := pac32(PChar(p)+253)^[0]; pac32(PChar(p)+253)^[0] := pac32(PChar(p)+488)^[0]; pac32(PChar(p)+488)^[0] := num;
 pac16(PChar(p)+302)^[0] := pac16(PChar(p)+302)^[0] + ror2(pac16(PChar(p)+420)^[0] , 4 );

D7E495DB(p);

end;

procedure D7E495DB(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+440)^[0] > pac8(PChar(p)+430)^[0] then begin  num := pac32(PChar(p)+440)^[0]; pac32(PChar(p)+440)^[0] := pac32(PChar(p)+248)^[0]; pac32(PChar(p)+248)^[0] := num; end else begin  num := pac32(PChar(p)+409)^[0]; pac32(PChar(p)+409)^[0] := pac32(PChar(p)+322)^[0]; pac32(PChar(p)+322)^[0] := num; end;
 pac64(PChar(p)+419)^[0] := pac64(PChar(p)+419)^[0] xor (pac64(PChar(p)+232)^[0] + $905849721f80);
 pac32(PChar(p)+489)^[0] := pac32(PChar(p)+133)^[0] xor (pac32(PChar(p)+134)^[0] + $50c3);
 pac64(PChar(p)+93)^[0] := pac64(PChar(p)+93)^[0] - $80b1e47195;
 pac32(PChar(p)+259)^[0] := pac32(PChar(p)+259)^[0] + ror1(pac32(PChar(p)+418)^[0] , 2 );
 num := pac16(PChar(p)+215)^[0]; pac16(PChar(p)+215)^[0] := pac16(PChar(p)+390)^[0]; pac16(PChar(p)+390)^[0] := num;

 if pac8(PChar(p)+3)^[0] > pac8(PChar(p)+238)^[0] then begin
   pac64(PChar(p)+390)^[0] := pac64(PChar(p)+390)^[0] - $209c425d83;
   pac16(PChar(p)+375)^[0] := pac16(PChar(p)+375)^[0] + ror2(pac16(PChar(p)+423)^[0] , 6 );
   pac32(PChar(p)+494)^[0] := pac32(PChar(p)+494)^[0] + $e01ade;
 end;

 num := pac32(PChar(p)+313)^[0]; pac32(PChar(p)+313)^[0] := pac32(PChar(p)+64)^[0]; pac32(PChar(p)+64)^[0] := num;
 num := pac16(PChar(p)+369)^[0]; pac16(PChar(p)+369)^[0] := pac16(PChar(p)+316)^[0]; pac16(PChar(p)+316)^[0] := num;
 pac32(PChar(p)+140)^[0] := pac32(PChar(p)+140)^[0] xor rol1(pac32(PChar(p)+258)^[0] , 14 );
 pac32(PChar(p)+331)^[0] := pac32(PChar(p)+331)^[0] xor $b067;
 pac16(PChar(p)+494)^[0] := pac16(PChar(p)+494)^[0] - ror2(pac16(PChar(p)+320)^[0] , 12 );
 pac16(PChar(p)+308)^[0] := rol1(pac16(PChar(p)+394)^[0] , 5 );
 pac64(PChar(p)+495)^[0] := pac64(PChar(p)+495)^[0] - (pac64(PChar(p)+74)^[0] + $3088b40250af);
 if pac64(PChar(p)+57)^[0] > pac64(PChar(p)+232)^[0] then pac32(PChar(p)+481)^[0] := pac32(PChar(p)+159)^[0] - (pac32(PChar(p)+299)^[0] + $c00784) else pac8(PChar(p)+50)^[0] := pac8(PChar(p)+50)^[0] xor rol1(pac8(PChar(p)+85)^[0] , 5 );

D017AFE6(p);

end;

procedure D017AFE6(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+24)^[0] > pac16(PChar(p)+111)^[0] then begin  num := pac8(PChar(p)+10)^[0]; pac8(PChar(p)+10)^[0] := pac8(PChar(p)+11)^[0]; pac8(PChar(p)+11)^[0] := num; end else pac32(PChar(p)+400)^[0] := ror2(pac32(PChar(p)+134)^[0] , 4 );
 pac16(PChar(p)+36)^[0] := pac16(PChar(p)+36)^[0] or (pac16(PChar(p)+293)^[0] - $70);
 pac64(PChar(p)+233)^[0] := pac64(PChar(p)+233)^[0] + $501f38f9;

 if pac64(PChar(p)+289)^[0] > pac64(PChar(p)+443)^[0] then begin
   pac32(PChar(p)+33)^[0] := pac32(PChar(p)+33)^[0] - rol1(pac32(PChar(p)+177)^[0] , 8 );
   if pac32(PChar(p)+233)^[0] > pac32(PChar(p)+314)^[0] then pac32(PChar(p)+170)^[0] := ror2(pac32(PChar(p)+376)^[0] , 8 ) else begin  num := pac8(PChar(p)+26)^[0]; pac8(PChar(p)+26)^[0] := pac8(PChar(p)+375)^[0]; pac8(PChar(p)+375)^[0] := num; end;
   num := pac32(PChar(p)+6)^[0]; pac32(PChar(p)+6)^[0] := pac32(PChar(p)+30)^[0]; pac32(PChar(p)+30)^[0] := num;
   pac8(PChar(p)+175)^[0] := ror2(pac8(PChar(p)+273)^[0] , 3 );
 end;

 pac32(PChar(p)+213)^[0] := pac32(PChar(p)+213)^[0] + $9080;
 pac8(PChar(p)+73)^[0] := pac8(PChar(p)+73)^[0] xor rol1(pac8(PChar(p)+414)^[0] , 2 );
 pac32(PChar(p)+396)^[0] := ror2(pac32(PChar(p)+485)^[0] , 25 );
 pac32(PChar(p)+136)^[0] := pac32(PChar(p)+136)^[0] or (pac32(PChar(p)+18)^[0] xor $d040);
 pac16(PChar(p)+456)^[0] := pac16(PChar(p)+456)^[0] or rol1(pac16(PChar(p)+462)^[0] , 8 );
 pac64(PChar(p)+25)^[0] := pac64(PChar(p)+2)^[0] - (pac64(PChar(p)+467)^[0] - $00e03da5);
 if pac64(PChar(p)+485)^[0] > pac64(PChar(p)+489)^[0] then pac16(PChar(p)+59)^[0] := pac16(PChar(p)+59)^[0] - ror1(pac16(PChar(p)+6)^[0] , 12 ) else pac16(PChar(p)+168)^[0] := pac16(PChar(p)+168)^[0] xor ror2(pac16(PChar(p)+166)^[0] , 15 );

 if pac64(PChar(p)+33)^[0] < pac64(PChar(p)+192)^[0] then begin
   pac64(PChar(p)+67)^[0] := pac64(PChar(p)+67)^[0] or (pac64(PChar(p)+497)^[0] + $a08699582e31);
   pac32(PChar(p)+49)^[0] := pac32(PChar(p)+49)^[0] - $701cfc;
   pac16(PChar(p)+282)^[0] := pac16(PChar(p)+282)^[0] xor (pac16(PChar(p)+395)^[0] + $50);
   pac8(PChar(p)+479)^[0] := pac8(PChar(p)+479)^[0] or ror1(pac8(PChar(p)+397)^[0] , 7 );
 end;

 pac32(PChar(p)+204)^[0] := pac32(PChar(p)+169)^[0] xor $00e697;
 pac16(PChar(p)+135)^[0] := pac16(PChar(p)+135)^[0] - ror1(pac16(PChar(p)+20)^[0] , 13 );
 if pac8(PChar(p)+115)^[0] > pac8(PChar(p)+343)^[0] then pac16(PChar(p)+192)^[0] := pac16(PChar(p)+192)^[0] + ror2(pac16(PChar(p)+48)^[0] , 7 ) else pac8(PChar(p)+302)^[0] := pac8(PChar(p)+302)^[0] xor ror1(pac8(PChar(p)+208)^[0] , 5 );

ABDF8630(p);

end;

procedure ABDF8630(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+139)^[0] := pac32(PChar(p)+139)^[0] + (pac32(PChar(p)+449)^[0] - $40fe0e);
 num := pac32(PChar(p)+251)^[0]; pac32(PChar(p)+251)^[0] := pac32(PChar(p)+175)^[0]; pac32(PChar(p)+175)^[0] := num;
 pac64(PChar(p)+244)^[0] := pac64(PChar(p)+244)^[0] - (pac64(PChar(p)+392)^[0] + $c08bf801);
 pac32(PChar(p)+449)^[0] := pac32(PChar(p)+449)^[0] - ror2(pac32(PChar(p)+485)^[0] , 4 );
 pac64(PChar(p)+49)^[0] := pac64(PChar(p)+312)^[0] or (pac64(PChar(p)+152)^[0] or $50ade8a2);
 pac8(PChar(p)+1)^[0] := pac8(PChar(p)+1)^[0] + rol1(pac8(PChar(p)+410)^[0] , 6 );

 if pac32(PChar(p)+49)^[0] < pac32(PChar(p)+314)^[0] then begin
   pac8(PChar(p)+398)^[0] := pac8(PChar(p)+339)^[0] - (pac8(PChar(p)+373)^[0] + $90);
   pac32(PChar(p)+85)^[0] := pac32(PChar(p)+85)^[0] + (pac32(PChar(p)+89)^[0] - $704c96);
 end;

 if pac8(PChar(p)+439)^[0] < pac8(PChar(p)+276)^[0] then pac8(PChar(p)+279)^[0] := pac8(PChar(p)+279)^[0] + ror1(pac8(PChar(p)+194)^[0] , 7 ) else pac64(PChar(p)+349)^[0] := pac64(PChar(p)+349)^[0] - $502ccb711570;
 if pac32(PChar(p)+352)^[0] < pac32(PChar(p)+158)^[0] then pac64(PChar(p)+35)^[0] := pac64(PChar(p)+35)^[0] xor $307fbc2b else pac16(PChar(p)+150)^[0] := pac16(PChar(p)+177)^[0] or (pac16(PChar(p)+390)^[0] + $a0);

 if pac32(PChar(p)+21)^[0] > pac32(PChar(p)+131)^[0] then begin
   num := pac32(PChar(p)+6)^[0]; pac32(PChar(p)+6)^[0] := pac32(PChar(p)+296)^[0]; pac32(PChar(p)+296)^[0] := num;
   num := pac8(PChar(p)+85)^[0]; pac8(PChar(p)+85)^[0] := pac8(PChar(p)+272)^[0]; pac8(PChar(p)+272)^[0] := num;
   if pac64(PChar(p)+367)^[0] < pac64(PChar(p)+477)^[0] then begin  num := pac16(PChar(p)+446)^[0]; pac16(PChar(p)+446)^[0] := pac16(PChar(p)+105)^[0]; pac16(PChar(p)+105)^[0] := num; end;
   num := pac32(PChar(p)+264)^[0]; pac32(PChar(p)+264)^[0] := pac32(PChar(p)+485)^[0]; pac32(PChar(p)+485)^[0] := num;
 end;

 pac64(PChar(p)+269)^[0] := pac64(PChar(p)+269)^[0] + $f009a0b85a;

E2E9486B(p);

end;

procedure E2E9486B(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+312)^[0] := pac64(PChar(p)+312)^[0] - $502eb2c85a20;
 pac64(PChar(p)+168)^[0] := pac64(PChar(p)+379)^[0] - $906d72839b68;
 pac64(PChar(p)+320)^[0] := pac64(PChar(p)+440)^[0] xor $308073d6;
 pac64(PChar(p)+347)^[0] := pac64(PChar(p)+259)^[0] xor (pac64(PChar(p)+167)^[0] xor $000e9c9188);

 if pac8(PChar(p)+132)^[0] < pac8(PChar(p)+7)^[0] then begin
   pac64(PChar(p)+414)^[0] := pac64(PChar(p)+414)^[0] xor (pac64(PChar(p)+68)^[0] xor $401f53340e40);
   pac16(PChar(p)+505)^[0] := pac16(PChar(p)+505)^[0] or ror2(pac16(PChar(p)+487)^[0] , 6 );
 end;

 if pac64(PChar(p)+295)^[0] < pac64(PChar(p)+321)^[0] then begin  num := pac32(PChar(p)+465)^[0]; pac32(PChar(p)+465)^[0] := pac32(PChar(p)+65)^[0]; pac32(PChar(p)+65)^[0] := num; end else pac8(PChar(p)+422)^[0] := pac8(PChar(p)+142)^[0] or (pac8(PChar(p)+54)^[0] xor $a0);

 if pac64(PChar(p)+458)^[0] > pac64(PChar(p)+72)^[0] then begin
   num := pac8(PChar(p)+72)^[0]; pac8(PChar(p)+72)^[0] := pac8(PChar(p)+352)^[0]; pac8(PChar(p)+352)^[0] := num;
   num := pac8(PChar(p)+78)^[0]; pac8(PChar(p)+78)^[0] := pac8(PChar(p)+126)^[0]; pac8(PChar(p)+126)^[0] := num;
   pac32(PChar(p)+58)^[0] := pac32(PChar(p)+58)^[0] xor (pac32(PChar(p)+45)^[0] - $10d37e);
   pac64(PChar(p)+112)^[0] := pac64(PChar(p)+112)^[0] xor $e02fdad1;
 end;

 pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] + $2057;
 if pac8(PChar(p)+157)^[0] > pac8(PChar(p)+134)^[0] then pac8(PChar(p)+461)^[0] := pac8(PChar(p)+461)^[0] or $b0 else begin  num := pac8(PChar(p)+459)^[0]; pac8(PChar(p)+459)^[0] := pac8(PChar(p)+504)^[0]; pac8(PChar(p)+504)^[0] := num; end;
 pac8(PChar(p)+316)^[0] := pac8(PChar(p)+316)^[0] or (pac8(PChar(p)+480)^[0] - $20);

 if pac32(PChar(p)+365)^[0] < pac32(PChar(p)+151)^[0] then begin
   pac64(PChar(p)+424)^[0] := pac64(PChar(p)+424)^[0] xor (pac64(PChar(p)+9)^[0] xor $9050503ce779);
   pac64(PChar(p)+281)^[0] := pac64(PChar(p)+281)^[0] + (pac64(PChar(p)+2)^[0] xor $d07cf1f4a9);
   if pac8(PChar(p)+212)^[0] > pac8(PChar(p)+155)^[0] then pac64(PChar(p)+472)^[0] := pac64(PChar(p)+472)^[0] - $b0d326e1 else pac16(PChar(p)+81)^[0] := pac16(PChar(p)+81)^[0] + (pac16(PChar(p)+176)^[0] + $20);
   if pac32(PChar(p)+435)^[0] < pac32(PChar(p)+266)^[0] then pac32(PChar(p)+147)^[0] := pac32(PChar(p)+107)^[0] + $e053f8 else pac64(PChar(p)+49)^[0] := pac64(PChar(p)+49)^[0] - (pac64(PChar(p)+208)^[0] - $805a8d466e8d);
   pac64(PChar(p)+450)^[0] := pac64(PChar(p)+450)^[0] - (pac64(PChar(p)+246)^[0] - $f0495c56bac1);
 end;

 pac8(PChar(p)+154)^[0] := pac8(PChar(p)+154)^[0] - ror1(pac8(PChar(p)+305)^[0] , 5 );
 pac16(PChar(p)+79)^[0] := pac16(PChar(p)+79)^[0] + (pac16(PChar(p)+50)^[0] xor $70);
 pac32(PChar(p)+212)^[0] := ror2(pac32(PChar(p)+278)^[0] , 11 );
 pac64(PChar(p)+139)^[0] := pac64(PChar(p)+139)^[0] or (pac64(PChar(p)+362)^[0] - $c03422f9988e);

ED60AD31(p);

end;

procedure ED60AD31(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+184)^[0] := pac8(PChar(p)+184)^[0] + (pac8(PChar(p)+89)^[0] xor $a0);
 pac32(PChar(p)+381)^[0] := pac32(PChar(p)+381)^[0] - ror2(pac32(PChar(p)+296)^[0] , 13 );
 pac32(PChar(p)+370)^[0] := pac32(PChar(p)+477)^[0] + (pac32(PChar(p)+125)^[0] - $c04c2b);
 num := pac16(PChar(p)+466)^[0]; pac16(PChar(p)+466)^[0] := pac16(PChar(p)+122)^[0]; pac16(PChar(p)+122)^[0] := num;
 pac32(PChar(p)+199)^[0] := pac32(PChar(p)+199)^[0] - rol1(pac32(PChar(p)+265)^[0] , 1 );
 if pac32(PChar(p)+441)^[0] < pac32(PChar(p)+143)^[0] then pac32(PChar(p)+167)^[0] := pac32(PChar(p)+167)^[0] xor $6044 else pac8(PChar(p)+368)^[0] := pac8(PChar(p)+368)^[0] + (pac8(PChar(p)+15)^[0] + $30);
 pac8(PChar(p)+183)^[0] := pac8(PChar(p)+339)^[0] or $70;
 pac16(PChar(p)+453)^[0] := pac16(PChar(p)+453)^[0] xor rol1(pac16(PChar(p)+469)^[0] , 6 );

 if pac16(PChar(p)+130)^[0] < pac16(PChar(p)+36)^[0] then begin
   num := pac8(PChar(p)+392)^[0]; pac8(PChar(p)+392)^[0] := pac8(PChar(p)+133)^[0]; pac8(PChar(p)+133)^[0] := num;
   pac16(PChar(p)+198)^[0] := pac16(PChar(p)+198)^[0] + (pac16(PChar(p)+138)^[0] or $d0);
   if pac8(PChar(p)+194)^[0] < pac8(PChar(p)+410)^[0] then pac32(PChar(p)+224)^[0] := pac32(PChar(p)+224)^[0] or $90e56f else begin  num := pac8(PChar(p)+261)^[0]; pac8(PChar(p)+261)^[0] := pac8(PChar(p)+468)^[0]; pac8(PChar(p)+468)^[0] := num; end;
   pac32(PChar(p)+206)^[0] := pac32(PChar(p)+206)^[0] xor (pac32(PChar(p)+218)^[0] - $a0a4);
   pac8(PChar(p)+234)^[0] := pac8(PChar(p)+234)^[0] + $70;
 end;

 pac8(PChar(p)+389)^[0] := pac8(PChar(p)+389)^[0] - ror1(pac8(PChar(p)+388)^[0] , 3 );
 pac32(PChar(p)+460)^[0] := pac32(PChar(p)+422)^[0] xor (pac32(PChar(p)+155)^[0] + $d01c59);
 pac32(PChar(p)+258)^[0] := pac32(PChar(p)+258)^[0] + ror1(pac32(PChar(p)+487)^[0] , 15 );

 if pac64(PChar(p)+433)^[0] < pac64(PChar(p)+49)^[0] then begin
   pac32(PChar(p)+263)^[0] := pac32(PChar(p)+77)^[0] or $2081fa;
   num := pac8(PChar(p)+134)^[0]; pac8(PChar(p)+134)^[0] := pac8(PChar(p)+498)^[0]; pac8(PChar(p)+498)^[0] := num;
   pac64(PChar(p)+328)^[0] := pac64(PChar(p)+299)^[0] xor $e0789afb;
 end;


B224E612(p);

end;

procedure B224E612(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+266)^[0] > pac64(PChar(p)+36)^[0] then pac16(PChar(p)+433)^[0] := rol1(pac16(PChar(p)+466)^[0] , 8 ) else pac8(PChar(p)+436)^[0] := pac8(PChar(p)+436)^[0] or rol1(pac8(PChar(p)+415)^[0] , 4 );
 pac8(PChar(p)+61)^[0] := pac8(PChar(p)+61)^[0] + ror2(pac8(PChar(p)+103)^[0] , 4 );
 num := pac8(PChar(p)+220)^[0]; pac8(PChar(p)+220)^[0] := pac8(PChar(p)+101)^[0]; pac8(PChar(p)+101)^[0] := num;
 if pac64(PChar(p)+461)^[0] < pac64(PChar(p)+232)^[0] then pac64(PChar(p)+378)^[0] := pac64(PChar(p)+378)^[0] or $206e7706 else pac8(PChar(p)+202)^[0] := pac8(PChar(p)+202)^[0] or ror1(pac8(PChar(p)+198)^[0] , 5 );
 if pac64(PChar(p)+208)^[0] < pac64(PChar(p)+185)^[0] then pac16(PChar(p)+366)^[0] := pac16(PChar(p)+366)^[0] - ror2(pac16(PChar(p)+438)^[0] , 7 );
 pac32(PChar(p)+126)^[0] := pac32(PChar(p)+126)^[0] xor (pac32(PChar(p)+371)^[0] xor $50c9);
 pac32(PChar(p)+405)^[0] := pac32(PChar(p)+405)^[0] or (pac32(PChar(p)+179)^[0] or $103b73);

 if pac16(PChar(p)+396)^[0] > pac16(PChar(p)+369)^[0] then begin
   pac64(PChar(p)+134)^[0] := pac64(PChar(p)+134)^[0] or $2096a00b9b;
   pac8(PChar(p)+376)^[0] := pac8(PChar(p)+376)^[0] - $f0;
   pac8(PChar(p)+364)^[0] := pac8(PChar(p)+228)^[0] - (pac8(PChar(p)+24)^[0] xor $80);
   if pac8(PChar(p)+369)^[0] > pac8(PChar(p)+402)^[0] then pac32(PChar(p)+91)^[0] := pac32(PChar(p)+91)^[0] - (pac32(PChar(p)+296)^[0] or $e0c27c) else pac16(PChar(p)+37)^[0] := rol1(pac16(PChar(p)+205)^[0] , 9 );
 end;

 num := pac8(PChar(p)+320)^[0]; pac8(PChar(p)+320)^[0] := pac8(PChar(p)+148)^[0]; pac8(PChar(p)+148)^[0] := num;
 pac32(PChar(p)+339)^[0] := pac32(PChar(p)+229)^[0] - $1025ae;
 pac32(PChar(p)+47)^[0] := pac32(PChar(p)+47)^[0] - ror2(pac32(PChar(p)+452)^[0] , 24 );
 pac32(PChar(p)+370)^[0] := rol1(pac32(PChar(p)+17)^[0] , 10 );
 pac32(PChar(p)+176)^[0] := pac32(PChar(p)+176)^[0] xor (pac32(PChar(p)+356)^[0] xor $10e4);

DF6833CE(p);

end;

procedure DF6833CE(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+7)^[0] := pac8(PChar(p)+7)^[0] or $30;
 pac8(PChar(p)+439)^[0] := pac8(PChar(p)+439)^[0] or ror1(pac8(PChar(p)+294)^[0] , 1 );
 if pac32(PChar(p)+489)^[0] > pac32(PChar(p)+378)^[0] then pac8(PChar(p)+173)^[0] := ror2(pac8(PChar(p)+195)^[0] , 3 );
 if pac16(PChar(p)+180)^[0] < pac16(PChar(p)+72)^[0] then pac8(PChar(p)+309)^[0] := pac8(PChar(p)+309)^[0] - (pac8(PChar(p)+48)^[0] or $57) else begin  num := pac8(PChar(p)+447)^[0]; pac8(PChar(p)+447)^[0] := pac8(PChar(p)+303)^[0]; pac8(PChar(p)+303)^[0] := num; end;
 num := pac16(PChar(p)+340)^[0]; pac16(PChar(p)+340)^[0] := pac16(PChar(p)+383)^[0]; pac16(PChar(p)+383)^[0] := num;
 pac8(PChar(p)+284)^[0] := pac8(PChar(p)+284)^[0] - $60;
 pac16(PChar(p)+271)^[0] := pac16(PChar(p)+271)^[0] + (pac16(PChar(p)+499)^[0] xor $30);

 if pac16(PChar(p)+348)^[0] > pac16(PChar(p)+132)^[0] then begin
   pac64(PChar(p)+170)^[0] := pac64(PChar(p)+170)^[0] - (pac64(PChar(p)+120)^[0] or $50f5523413);
   pac64(PChar(p)+27)^[0] := pac64(PChar(p)+27)^[0] + $5096daf2f8;
   pac32(PChar(p)+266)^[0] := pac32(PChar(p)+196)^[0] or $60cd;
   pac64(PChar(p)+166)^[0] := pac64(PChar(p)+166)^[0] - (pac64(PChar(p)+11)^[0] xor $80cd343d);
 end;

 if pac32(PChar(p)+481)^[0] > pac32(PChar(p)+192)^[0] then begin  num := pac16(PChar(p)+405)^[0]; pac16(PChar(p)+405)^[0] := pac16(PChar(p)+219)^[0]; pac16(PChar(p)+219)^[0] := num; end else pac64(PChar(p)+181)^[0] := pac64(PChar(p)+181)^[0] + (pac64(PChar(p)+185)^[0] + $e0935b1865);
 pac32(PChar(p)+95)^[0] := pac32(PChar(p)+95)^[0] or rol1(pac32(PChar(p)+164)^[0] , 25 );
 num := pac16(PChar(p)+470)^[0]; pac16(PChar(p)+470)^[0] := pac16(PChar(p)+441)^[0]; pac16(PChar(p)+441)^[0] := num;
 pac8(PChar(p)+369)^[0] := pac8(PChar(p)+369)^[0] + ror2(pac8(PChar(p)+106)^[0] , 6 );
 if pac8(PChar(p)+464)^[0] < pac8(PChar(p)+49)^[0] then begin  num := pac16(PChar(p)+413)^[0]; pac16(PChar(p)+413)^[0] := pac16(PChar(p)+33)^[0]; pac16(PChar(p)+33)^[0] := num; end else pac32(PChar(p)+318)^[0] := ror2(pac32(PChar(p)+378)^[0] , 9 );
 pac32(PChar(p)+68)^[0] := pac32(PChar(p)+68)^[0] + $0005;

 if pac16(PChar(p)+108)^[0] < pac16(PChar(p)+504)^[0] then begin
   pac16(PChar(p)+268)^[0] := pac16(PChar(p)+268)^[0] - (pac16(PChar(p)+248)^[0] or $20);
   pac16(PChar(p)+219)^[0] := rol1(pac16(PChar(p)+468)^[0] , 5 );
   if pac8(PChar(p)+417)^[0] > pac8(PChar(p)+336)^[0] then begin  num := pac16(PChar(p)+465)^[0]; pac16(PChar(p)+465)^[0] := pac16(PChar(p)+462)^[0]; pac16(PChar(p)+462)^[0] := num; end else pac16(PChar(p)+111)^[0] := pac16(PChar(p)+111)^[0] + (pac16(PChar(p)+51)^[0] - $a0);
 end;

 if pac8(PChar(p)+206)^[0] < pac8(PChar(p)+371)^[0] then begin  num := pac32(PChar(p)+178)^[0]; pac32(PChar(p)+178)^[0] := pac32(PChar(p)+318)^[0]; pac32(PChar(p)+318)^[0] := num; end else pac64(PChar(p)+295)^[0] := pac64(PChar(p)+295)^[0] + (pac64(PChar(p)+87)^[0] + $400eabcc);
 num := pac32(PChar(p)+192)^[0]; pac32(PChar(p)+192)^[0] := pac32(PChar(p)+5)^[0]; pac32(PChar(p)+5)^[0] := num;

BF620A05(p);

end;

procedure BF620A05(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+303)^[0]; pac8(PChar(p)+303)^[0] := pac8(PChar(p)+141)^[0]; pac8(PChar(p)+141)^[0] := num;

 if pac16(PChar(p)+385)^[0] < pac16(PChar(p)+419)^[0] then begin
   num := pac32(PChar(p)+395)^[0]; pac32(PChar(p)+395)^[0] := pac32(PChar(p)+68)^[0]; pac32(PChar(p)+68)^[0] := num;
   pac64(PChar(p)+246)^[0] := pac64(PChar(p)+443)^[0] + $108391b875;
   if pac8(PChar(p)+39)^[0] < pac8(PChar(p)+288)^[0] then pac16(PChar(p)+230)^[0] := pac16(PChar(p)+230)^[0] xor $20;
   pac64(PChar(p)+130)^[0] := pac64(PChar(p)+403)^[0] or $900569f1f767;
   pac64(PChar(p)+282)^[0] := pac64(PChar(p)+282)^[0] + (pac64(PChar(p)+480)^[0] - $30e07751);
 end;

 pac8(PChar(p)+307)^[0] := pac8(PChar(p)+307)^[0] xor (pac8(PChar(p)+246)^[0] - $40);
 pac32(PChar(p)+301)^[0] := pac32(PChar(p)+301)^[0] xor ror2(pac32(PChar(p)+207)^[0] , 20 );

 if pac32(PChar(p)+383)^[0] > pac32(PChar(p)+126)^[0] then begin
   if pac64(PChar(p)+156)^[0] > pac64(PChar(p)+216)^[0] then pac8(PChar(p)+109)^[0] := pac8(PChar(p)+109)^[0] or (pac8(PChar(p)+3)^[0] + $d0) else begin  num := pac8(PChar(p)+381)^[0]; pac8(PChar(p)+381)^[0] := pac8(PChar(p)+485)^[0]; pac8(PChar(p)+485)^[0] := num; end;
   pac64(PChar(p)+384)^[0] := pac64(PChar(p)+384)^[0] xor $a0a2e9b2;
   pac64(PChar(p)+412)^[0] := pac64(PChar(p)+23)^[0] - $2086eaa5;
   pac64(PChar(p)+439)^[0] := pac64(PChar(p)+439)^[0] xor (pac64(PChar(p)+30)^[0] xor $e04d107dee);
   pac32(PChar(p)+86)^[0] := pac32(PChar(p)+411)^[0] xor (pac32(PChar(p)+117)^[0] or $506f41);
 end;

 pac64(PChar(p)+192)^[0] := pac64(PChar(p)+192)^[0] + (pac64(PChar(p)+63)^[0] xor $10634b3ed7);
 pac32(PChar(p)+190)^[0] := pac32(PChar(p)+190)^[0] - rol1(pac32(PChar(p)+346)^[0] , 6 );
 num := pac32(PChar(p)+308)^[0]; pac32(PChar(p)+308)^[0] := pac32(PChar(p)+257)^[0]; pac32(PChar(p)+257)^[0] := num;
 num := pac16(PChar(p)+233)^[0]; pac16(PChar(p)+233)^[0] := pac16(PChar(p)+62)^[0]; pac16(PChar(p)+62)^[0] := num;
 if pac8(PChar(p)+18)^[0] > pac8(PChar(p)+151)^[0] then pac8(PChar(p)+370)^[0] := pac8(PChar(p)+370)^[0] or (pac8(PChar(p)+422)^[0] + $68) else begin  num := pac32(PChar(p)+434)^[0]; pac32(PChar(p)+434)^[0] := pac32(PChar(p)+463)^[0]; pac32(PChar(p)+463)^[0] := num; end;
 pac8(PChar(p)+265)^[0] := pac8(PChar(p)+265)^[0] - (pac8(PChar(p)+461)^[0] or $f0);
 pac16(PChar(p)+147)^[0] := rol1(pac16(PChar(p)+464)^[0] , 13 );
 pac64(PChar(p)+321)^[0] := pac64(PChar(p)+321)^[0] or (pac64(PChar(p)+262)^[0] xor $c06181360824);
 pac16(PChar(p)+449)^[0] := pac16(PChar(p)+449)^[0] - ror2(pac16(PChar(p)+393)^[0] , 10 );
 num := pac8(PChar(p)+4)^[0]; pac8(PChar(p)+4)^[0] := pac8(PChar(p)+122)^[0]; pac8(PChar(p)+122)^[0] := num;
 pac64(PChar(p)+357)^[0] := pac64(PChar(p)+357)^[0] + (pac64(PChar(p)+198)^[0] + $60dd30bb);

 if pac8(PChar(p)+482)^[0] > pac8(PChar(p)+88)^[0] then begin
   pac16(PChar(p)+4)^[0] := pac16(PChar(p)+174)^[0] xor $d0;
   pac8(PChar(p)+291)^[0] := pac8(PChar(p)+11)^[0] or (pac8(PChar(p)+190)^[0] xor $d0);
   if pac8(PChar(p)+223)^[0] < pac8(PChar(p)+268)^[0] then pac32(PChar(p)+305)^[0] := rol1(pac32(PChar(p)+86)^[0] , 9 );
 end;


F8D065B9(p);

end;

procedure F8D065B9(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+474)^[0] < pac8(PChar(p)+60)^[0] then pac32(PChar(p)+500)^[0] := pac32(PChar(p)+500)^[0] xor (pac32(PChar(p)+480)^[0] - $b04524) else pac32(PChar(p)+104)^[0] := pac32(PChar(p)+104)^[0] + (pac32(PChar(p)+12)^[0] xor $a058);
 pac64(PChar(p)+45)^[0] := pac64(PChar(p)+45)^[0] or (pac64(PChar(p)+189)^[0] or $80c14b6f);

 if pac16(PChar(p)+485)^[0] > pac16(PChar(p)+377)^[0] then begin
   pac32(PChar(p)+324)^[0] := ror1(pac32(PChar(p)+73)^[0] , 21 );
   pac64(PChar(p)+230)^[0] := pac64(PChar(p)+230)^[0] or (pac64(PChar(p)+226)^[0] xor $206fb429553f);
   if pac64(PChar(p)+84)^[0] < pac64(PChar(p)+269)^[0] then pac32(PChar(p)+223)^[0] := pac32(PChar(p)+223)^[0] or ror2(pac32(PChar(p)+213)^[0] , 20 ) else pac64(PChar(p)+370)^[0] := pac64(PChar(p)+370)^[0] + (pac64(PChar(p)+123)^[0] + $a0a934cc71);
   pac32(PChar(p)+416)^[0] := rol1(pac32(PChar(p)+440)^[0] , 9 );
   pac8(PChar(p)+422)^[0] := rol1(pac8(PChar(p)+337)^[0] , 3 );
 end;

 pac64(PChar(p)+190)^[0] := pac64(PChar(p)+190)^[0] + $006d830356ba;
 pac64(PChar(p)+341)^[0] := pac64(PChar(p)+383)^[0] xor (pac64(PChar(p)+142)^[0] - $f006a3dc);
 pac32(PChar(p)+108)^[0] := pac32(PChar(p)+108)^[0] xor $00daf6;
 pac32(PChar(p)+9)^[0] := pac32(PChar(p)+9)^[0] or (pac32(PChar(p)+499)^[0] xor $a0c7);

 if pac64(PChar(p)+117)^[0] < pac64(PChar(p)+20)^[0] then begin
   num := pac16(PChar(p)+136)^[0]; pac16(PChar(p)+136)^[0] := pac16(PChar(p)+113)^[0]; pac16(PChar(p)+113)^[0] := num;
   pac64(PChar(p)+496)^[0] := pac64(PChar(p)+496)^[0] - $008f5e25;
   num := pac16(PChar(p)+414)^[0]; pac16(PChar(p)+414)^[0] := pac16(PChar(p)+236)^[0]; pac16(PChar(p)+236)^[0] := num;
   pac8(PChar(p)+484)^[0] := pac8(PChar(p)+484)^[0] or (pac8(PChar(p)+442)^[0] xor $50);
 end;

 num := pac32(PChar(p)+13)^[0]; pac32(PChar(p)+13)^[0] := pac32(PChar(p)+176)^[0]; pac32(PChar(p)+176)^[0] := num;
 pac64(PChar(p)+288)^[0] := pac64(PChar(p)+184)^[0] xor (pac64(PChar(p)+290)^[0] xor $901452a3);
 if pac16(PChar(p)+250)^[0] > pac16(PChar(p)+78)^[0] then pac8(PChar(p)+128)^[0] := pac8(PChar(p)+128)^[0] xor ror2(pac8(PChar(p)+446)^[0] , 4 ) else begin  num := pac8(PChar(p)+177)^[0]; pac8(PChar(p)+177)^[0] := pac8(PChar(p)+396)^[0]; pac8(PChar(p)+396)^[0] := num; end;
 pac8(PChar(p)+292)^[0] := ror2(pac8(PChar(p)+175)^[0] , 3 );

 if pac8(PChar(p)+235)^[0] < pac8(PChar(p)+396)^[0] then begin
   pac32(PChar(p)+400)^[0] := pac32(PChar(p)+400)^[0] xor rol1(pac32(PChar(p)+333)^[0] , 16 );
   num := pac32(PChar(p)+89)^[0]; pac32(PChar(p)+89)^[0] := pac32(PChar(p)+483)^[0]; pac32(PChar(p)+483)^[0] := num;
   if pac8(PChar(p)+66)^[0] > pac8(PChar(p)+94)^[0] then pac64(PChar(p)+482)^[0] := pac64(PChar(p)+482)^[0] + (pac64(PChar(p)+406)^[0] xor $e011863f) else pac64(PChar(p)+300)^[0] := pac64(PChar(p)+300)^[0] - (pac64(PChar(p)+354)^[0] or $20a7e4ba);
 end;


 if pac8(PChar(p)+388)^[0] < pac8(PChar(p)+272)^[0] then begin
   num := pac32(PChar(p)+440)^[0]; pac32(PChar(p)+440)^[0] := pac32(PChar(p)+310)^[0]; pac32(PChar(p)+310)^[0] := num;
   pac64(PChar(p)+485)^[0] := pac64(PChar(p)+485)^[0] or $003a78cc6ac0;
   num := pac8(PChar(p)+325)^[0]; pac8(PChar(p)+325)^[0] := pac8(PChar(p)+90)^[0]; pac8(PChar(p)+90)^[0] := num;
 end;

 pac16(PChar(p)+149)^[0] := pac16(PChar(p)+149)^[0] xor ror2(pac16(PChar(p)+379)^[0] , 15 );

FBF06887(p);

end;

procedure FBF06887(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+304)^[0] := pac64(PChar(p)+304)^[0] or $4055434be324;
 if pac8(PChar(p)+377)^[0] < pac8(PChar(p)+86)^[0] then pac16(PChar(p)+117)^[0] := pac16(PChar(p)+117)^[0] - (pac16(PChar(p)+259)^[0] or $80) else pac8(PChar(p)+254)^[0] := rol1(pac8(PChar(p)+317)^[0] , 7 );
 pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] - (pac32(PChar(p)+109)^[0] xor $4073);
 num := pac16(PChar(p)+18)^[0]; pac16(PChar(p)+18)^[0] := pac16(PChar(p)+83)^[0]; pac16(PChar(p)+83)^[0] := num;
 num := pac32(PChar(p)+444)^[0]; pac32(PChar(p)+444)^[0] := pac32(PChar(p)+139)^[0]; pac32(PChar(p)+139)^[0] := num;
 num := pac8(PChar(p)+255)^[0]; pac8(PChar(p)+255)^[0] := pac8(PChar(p)+374)^[0]; pac8(PChar(p)+374)^[0] := num;

 if pac32(PChar(p)+197)^[0] > pac32(PChar(p)+193)^[0] then begin
   num := pac16(PChar(p)+0)^[0]; pac16(PChar(p)+0)^[0] := pac16(PChar(p)+474)^[0]; pac16(PChar(p)+474)^[0] := num;
   pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] - (pac64(PChar(p)+279)^[0] or $e0c69d42);
 end;

 pac32(PChar(p)+333)^[0] := pac32(PChar(p)+333)^[0] - $20ea;
 num := pac32(PChar(p)+293)^[0]; pac32(PChar(p)+293)^[0] := pac32(PChar(p)+463)^[0]; pac32(PChar(p)+463)^[0] := num;

 if pac64(PChar(p)+40)^[0] < pac64(PChar(p)+335)^[0] then begin
   pac8(PChar(p)+28)^[0] := pac8(PChar(p)+28)^[0] + rol1(pac8(PChar(p)+402)^[0] , 2 );
   pac64(PChar(p)+497)^[0] := pac64(PChar(p)+497)^[0] + (pac64(PChar(p)+393)^[0] xor $60bed5e1bd36);
   pac32(PChar(p)+59)^[0] := pac32(PChar(p)+422)^[0] xor $a0e8;
   num := pac8(PChar(p)+0)^[0]; pac8(PChar(p)+0)^[0] := pac8(PChar(p)+404)^[0]; pac8(PChar(p)+404)^[0] := num;
   pac32(PChar(p)+424)^[0] := pac32(PChar(p)+424)^[0] xor $50e5;
 end;

 pac16(PChar(p)+367)^[0] := pac16(PChar(p)+367)^[0] or rol1(pac16(PChar(p)+108)^[0] , 1 );
 pac32(PChar(p)+181)^[0] := pac32(PChar(p)+181)^[0] or $f0bcd7;
 pac16(PChar(p)+508)^[0] := pac16(PChar(p)+508)^[0] xor (pac16(PChar(p)+367)^[0] xor $30);

E39A7C8A(p);

end;

procedure E39A7C8A(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+182)^[0] < pac16(PChar(p)+453)^[0] then pac32(PChar(p)+386)^[0] := pac32(PChar(p)+386)^[0] - ror1(pac32(PChar(p)+487)^[0] , 20 ) else pac16(PChar(p)+350)^[0] := pac16(PChar(p)+510)^[0] - $90;
 pac32(PChar(p)+462)^[0] := pac32(PChar(p)+462)^[0] xor $80f8;
 pac16(PChar(p)+475)^[0] := pac16(PChar(p)+475)^[0] + rol1(pac16(PChar(p)+451)^[0] , 3 );
 pac8(PChar(p)+290)^[0] := ror2(pac8(PChar(p)+14)^[0] , 5 );
 pac64(PChar(p)+172)^[0] := pac64(PChar(p)+172)^[0] or (pac64(PChar(p)+273)^[0] xor $6044e07e064b);
 num := pac32(PChar(p)+323)^[0]; pac32(PChar(p)+323)^[0] := pac32(PChar(p)+272)^[0]; pac32(PChar(p)+272)^[0] := num;

 if pac64(PChar(p)+67)^[0] > pac64(PChar(p)+86)^[0] then begin
   if pac32(PChar(p)+459)^[0] < pac32(PChar(p)+449)^[0] then begin  num := pac8(PChar(p)+286)^[0]; pac8(PChar(p)+286)^[0] := pac8(PChar(p)+365)^[0]; pac8(PChar(p)+365)^[0] := num; end else pac32(PChar(p)+269)^[0] := pac32(PChar(p)+269)^[0] + ror2(pac32(PChar(p)+274)^[0] , 2 );
   if pac64(PChar(p)+144)^[0] < pac64(PChar(p)+140)^[0] then pac64(PChar(p)+89)^[0] := pac64(PChar(p)+89)^[0] + (pac64(PChar(p)+74)^[0] xor $a08bdef5) else pac32(PChar(p)+167)^[0] := pac32(PChar(p)+167)^[0] + ror1(pac32(PChar(p)+415)^[0] , 1 );
   pac32(PChar(p)+436)^[0] := pac32(PChar(p)+436)^[0] xor (pac32(PChar(p)+292)^[0] xor $30f5);
   pac8(PChar(p)+466)^[0] := pac8(PChar(p)+107)^[0] - $f0;
 end;

 num := pac8(PChar(p)+29)^[0]; pac8(PChar(p)+29)^[0] := pac8(PChar(p)+115)^[0]; pac8(PChar(p)+115)^[0] := num;
 pac32(PChar(p)+152)^[0] := pac32(PChar(p)+152)^[0] + ror2(pac32(PChar(p)+61)^[0] , 14 );
 num := pac32(PChar(p)+256)^[0]; pac32(PChar(p)+256)^[0] := pac32(PChar(p)+408)^[0]; pac32(PChar(p)+408)^[0] := num;
 pac16(PChar(p)+388)^[0] := pac16(PChar(p)+388)^[0] + $f0;
 pac64(PChar(p)+456)^[0] := pac64(PChar(p)+456)^[0] + (pac64(PChar(p)+37)^[0] xor $e06c29fdf3f1);
 pac32(PChar(p)+401)^[0] := pac32(PChar(p)+401)^[0] + ror2(pac32(PChar(p)+315)^[0] , 23 );

D5C973F8(p);

end;

procedure D5C973F8(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+277)^[0] := pac32(PChar(p)+277)^[0] + (pac32(PChar(p)+48)^[0] or $2029);
 if pac16(PChar(p)+178)^[0] < pac16(PChar(p)+396)^[0] then pac64(PChar(p)+427)^[0] := pac64(PChar(p)+427)^[0] + (pac64(PChar(p)+133)^[0] + $9057a3499a) else pac32(PChar(p)+160)^[0] := pac32(PChar(p)+160)^[0] - (pac32(PChar(p)+406)^[0] - $20e3);

 if pac16(PChar(p)+112)^[0] < pac16(PChar(p)+32)^[0] then begin
   pac32(PChar(p)+135)^[0] := pac32(PChar(p)+135)^[0] - ror1(pac32(PChar(p)+399)^[0] , 26 );
   pac64(PChar(p)+259)^[0] := pac64(PChar(p)+259)^[0] - (pac64(PChar(p)+255)^[0] or $20ffa5136f);
 end;

 if pac8(PChar(p)+167)^[0] < pac8(PChar(p)+71)^[0] then pac32(PChar(p)+408)^[0] := pac32(PChar(p)+114)^[0] + (pac32(PChar(p)+249)^[0] or $9044) else pac16(PChar(p)+99)^[0] := pac16(PChar(p)+99)^[0] or $e0;
 pac64(PChar(p)+295)^[0] := pac64(PChar(p)+295)^[0] - $c01cba2e;
 pac8(PChar(p)+16)^[0] := pac8(PChar(p)+16)^[0] xor rol1(pac8(PChar(p)+240)^[0] , 2 );
 num := pac32(PChar(p)+115)^[0]; pac32(PChar(p)+115)^[0] := pac32(PChar(p)+185)^[0]; pac32(PChar(p)+185)^[0] := num;
 pac64(PChar(p)+389)^[0] := pac64(PChar(p)+155)^[0] or $d07ede6f81a7;
 num := pac32(PChar(p)+131)^[0]; pac32(PChar(p)+131)^[0] := pac32(PChar(p)+125)^[0]; pac32(PChar(p)+125)^[0] := num;

 if pac16(PChar(p)+359)^[0] > pac16(PChar(p)+293)^[0] then begin
   num := pac8(PChar(p)+375)^[0]; pac8(PChar(p)+375)^[0] := pac8(PChar(p)+380)^[0]; pac8(PChar(p)+380)^[0] := num;
   pac8(PChar(p)+432)^[0] := pac8(PChar(p)+432)^[0] + rol1(pac8(PChar(p)+224)^[0] , 2 );
   pac32(PChar(p)+137)^[0] := rol1(pac32(PChar(p)+85)^[0] , 20 );
   pac32(PChar(p)+461)^[0] := pac32(PChar(p)+461)^[0] - ror1(pac32(PChar(p)+158)^[0] , 5 );
   pac64(PChar(p)+230)^[0] := pac64(PChar(p)+230)^[0] or (pac64(PChar(p)+151)^[0] or $4046d319);
 end;

 pac16(PChar(p)+254)^[0] := pac16(PChar(p)+254)^[0] + (pac16(PChar(p)+423)^[0] or $d0);
 pac32(PChar(p)+121)^[0] := pac32(PChar(p)+121)^[0] - ror1(pac32(PChar(p)+240)^[0] , 3 );
 if pac16(PChar(p)+25)^[0] > pac16(PChar(p)+106)^[0] then pac64(PChar(p)+436)^[0] := pac64(PChar(p)+436)^[0] + (pac64(PChar(p)+455)^[0] xor $f0de336a) else pac32(PChar(p)+255)^[0] := pac32(PChar(p)+255)^[0] - (pac32(PChar(p)+406)^[0] or $303bce);

A19A9C69(p);

end;

procedure A19A9C69(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+37)^[0]; pac8(PChar(p)+37)^[0] := pac8(PChar(p)+462)^[0]; pac8(PChar(p)+462)^[0] := num;
 num := pac8(PChar(p)+28)^[0]; pac8(PChar(p)+28)^[0] := pac8(PChar(p)+300)^[0]; pac8(PChar(p)+300)^[0] := num;
 pac64(PChar(p)+322)^[0] := pac64(PChar(p)+82)^[0] - (pac64(PChar(p)+366)^[0] + $f050461c892b);
 pac32(PChar(p)+306)^[0] := pac32(PChar(p)+471)^[0] + $d0a052;
 pac16(PChar(p)+122)^[0] := pac16(PChar(p)+122)^[0] + $c0;
 pac8(PChar(p)+25)^[0] := pac8(PChar(p)+25)^[0] or rol1(pac8(PChar(p)+409)^[0] , 1 );
 num := pac8(PChar(p)+228)^[0]; pac8(PChar(p)+228)^[0] := pac8(PChar(p)+48)^[0]; pac8(PChar(p)+48)^[0] := num;

 if pac64(PChar(p)+222)^[0] > pac64(PChar(p)+363)^[0] then begin
   num := pac8(PChar(p)+126)^[0]; pac8(PChar(p)+126)^[0] := pac8(PChar(p)+249)^[0]; pac8(PChar(p)+249)^[0] := num;
   num := pac16(PChar(p)+451)^[0]; pac16(PChar(p)+451)^[0] := pac16(PChar(p)+283)^[0]; pac16(PChar(p)+283)^[0] := num;
   if pac8(PChar(p)+348)^[0] < pac8(PChar(p)+458)^[0] then pac32(PChar(p)+124)^[0] := pac32(PChar(p)+124)^[0] + $3036a6 else pac32(PChar(p)+461)^[0] := pac32(PChar(p)+461)^[0] - ror2(pac32(PChar(p)+26)^[0] , 28 );
   num := pac32(PChar(p)+250)^[0]; pac32(PChar(p)+250)^[0] := pac32(PChar(p)+268)^[0]; pac32(PChar(p)+268)^[0] := num;
 end;

 if pac32(PChar(p)+335)^[0] > pac32(PChar(p)+234)^[0] then pac8(PChar(p)+1)^[0] := pac8(PChar(p)+1)^[0] xor $b0;
 pac16(PChar(p)+148)^[0] := pac16(PChar(p)+148)^[0] or rol1(pac16(PChar(p)+201)^[0] , 9 );
 if pac32(PChar(p)+23)^[0] < pac32(PChar(p)+405)^[0] then pac64(PChar(p)+101)^[0] := pac64(PChar(p)+101)^[0] - $706ada011083 else pac32(PChar(p)+43)^[0] := pac32(PChar(p)+353)^[0] or (pac32(PChar(p)+311)^[0] + $d09b01);
 pac16(PChar(p)+409)^[0] := pac16(PChar(p)+409)^[0] xor $40;
 pac16(PChar(p)+160)^[0] := pac16(PChar(p)+160)^[0] + ror2(pac16(PChar(p)+397)^[0] , 13 );
 pac16(PChar(p)+485)^[0] := rol1(pac16(PChar(p)+471)^[0] , 6 );

DEF0C5C9(p);

end;

procedure DEF0C5C9(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+479)^[0]; pac8(PChar(p)+479)^[0] := pac8(PChar(p)+440)^[0]; pac8(PChar(p)+440)^[0] := num;

 if pac16(PChar(p)+278)^[0] > pac16(PChar(p)+259)^[0] then begin
   pac64(PChar(p)+497)^[0] := pac64(PChar(p)+497)^[0] or (pac64(PChar(p)+13)^[0] - $80207609);
   pac8(PChar(p)+88)^[0] := pac8(PChar(p)+88)^[0] + ror2(pac8(PChar(p)+146)^[0] , 5 );
   if pac32(PChar(p)+66)^[0] > pac32(PChar(p)+272)^[0] then begin  num := pac8(PChar(p)+46)^[0]; pac8(PChar(p)+46)^[0] := pac8(PChar(p)+432)^[0]; pac8(PChar(p)+432)^[0] := num; end else begin  num := pac16(PChar(p)+201)^[0]; pac16(PChar(p)+201)^[0] := pac16(PChar(p)+125)^[0]; pac16(PChar(p)+125)^[0] := num; end;
   pac64(PChar(p)+289)^[0] := pac64(PChar(p)+289)^[0] + $309af455;
 end;

 if pac8(PChar(p)+446)^[0] > pac8(PChar(p)+308)^[0] then begin  num := pac32(PChar(p)+347)^[0]; pac32(PChar(p)+347)^[0] := pac32(PChar(p)+288)^[0]; pac32(PChar(p)+288)^[0] := num; end else pac32(PChar(p)+499)^[0] := rol1(pac32(PChar(p)+181)^[0] , 20 );
 pac8(PChar(p)+170)^[0] := pac8(PChar(p)+170)^[0] xor $60;
 pac16(PChar(p)+452)^[0] := pac16(PChar(p)+452)^[0] xor ror1(pac16(PChar(p)+455)^[0] , 3 );
 pac64(PChar(p)+18)^[0] := pac64(PChar(p)+340)^[0] xor (pac64(PChar(p)+251)^[0] - $b0905c6a);
 if pac16(PChar(p)+152)^[0] > pac16(PChar(p)+24)^[0] then pac16(PChar(p)+458)^[0] := pac16(PChar(p)+458)^[0] + rol1(pac16(PChar(p)+298)^[0] , 5 ) else pac8(PChar(p)+57)^[0] := pac8(PChar(p)+57)^[0] - ror1(pac8(PChar(p)+459)^[0] , 4 );
 num := pac16(PChar(p)+278)^[0]; pac16(PChar(p)+278)^[0] := pac16(PChar(p)+284)^[0]; pac16(PChar(p)+284)^[0] := num;
 pac16(PChar(p)+14)^[0] := pac16(PChar(p)+14)^[0] - (pac16(PChar(p)+143)^[0] or $80);
 pac64(PChar(p)+422)^[0] := pac64(PChar(p)+422)^[0] xor (pac64(PChar(p)+274)^[0] - $d0fe2c47c82c);

B94C1F74(p);

end;

procedure B94C1F74(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+65)^[0] := pac16(PChar(p)+65)^[0] xor $e0;
 pac8(PChar(p)+352)^[0] := pac8(PChar(p)+494)^[0] - $a0;

 if pac8(PChar(p)+499)^[0] < pac8(PChar(p)+106)^[0] then begin
   if pac16(PChar(p)+46)^[0] < pac16(PChar(p)+139)^[0] then pac64(PChar(p)+459)^[0] := pac64(PChar(p)+459)^[0] xor $b028824da2 else pac64(PChar(p)+277)^[0] := pac64(PChar(p)+387)^[0] - $703f4c04cb;
   pac32(PChar(p)+432)^[0] := pac32(PChar(p)+452)^[0] xor $50531f;
   pac64(PChar(p)+331)^[0] := pac64(PChar(p)+25)^[0] - (pac64(PChar(p)+439)^[0] xor $e05e7365962f);
 end;

 pac8(PChar(p)+456)^[0] := pac8(PChar(p)+456)^[0] + ror2(pac8(PChar(p)+271)^[0] , 7 );
 if pac32(PChar(p)+414)^[0] > pac32(PChar(p)+242)^[0] then pac8(PChar(p)+189)^[0] := pac8(PChar(p)+189)^[0] - ror2(pac8(PChar(p)+172)^[0] , 1 ) else pac64(PChar(p)+327)^[0] := pac64(PChar(p)+147)^[0] xor $b014c6e58a;
 pac32(PChar(p)+483)^[0] := pac32(PChar(p)+483)^[0] + (pac32(PChar(p)+419)^[0] - $90caeb);
 if pac64(PChar(p)+338)^[0] > pac64(PChar(p)+451)^[0] then pac32(PChar(p)+425)^[0] := pac32(PChar(p)+425)^[0] + $7051 else pac64(PChar(p)+199)^[0] := pac64(PChar(p)+199)^[0] or $3049a84e14;
 if pac16(PChar(p)+197)^[0] > pac16(PChar(p)+14)^[0] then pac64(PChar(p)+390)^[0] := pac64(PChar(p)+493)^[0] or (pac64(PChar(p)+122)^[0] or $c07d9e48);

 if pac16(PChar(p)+41)^[0] < pac16(PChar(p)+9)^[0] then begin
   if pac64(PChar(p)+151)^[0] > pac64(PChar(p)+425)^[0] then pac8(PChar(p)+377)^[0] := pac8(PChar(p)+377)^[0] or (pac8(PChar(p)+350)^[0] + $b0) else begin  num := pac32(PChar(p)+313)^[0]; pac32(PChar(p)+313)^[0] := pac32(PChar(p)+278)^[0]; pac32(PChar(p)+278)^[0] := num; end;
   pac32(PChar(p)+129)^[0] := ror2(pac32(PChar(p)+442)^[0] , 6 );
   if pac8(PChar(p)+502)^[0] > pac8(PChar(p)+166)^[0] then pac32(PChar(p)+158)^[0] := pac32(PChar(p)+158)^[0] + rol1(pac32(PChar(p)+430)^[0] , 1 ) else pac64(PChar(p)+79)^[0] := pac64(PChar(p)+79)^[0] - $804dc46b;
   if pac8(PChar(p)+145)^[0] > pac8(PChar(p)+367)^[0] then pac32(PChar(p)+459)^[0] := rol1(pac32(PChar(p)+359)^[0] , 26 ) else pac32(PChar(p)+306)^[0] := pac32(PChar(p)+306)^[0] xor $200e;
   pac8(PChar(p)+305)^[0] := pac8(PChar(p)+305)^[0] xor ror2(pac8(PChar(p)+422)^[0] , 2 );
 end;

 pac8(PChar(p)+363)^[0] := pac8(PChar(p)+363)^[0] + $d0;
 pac32(PChar(p)+502)^[0] := pac32(PChar(p)+502)^[0] or $505b;

 if pac64(PChar(p)+151)^[0] > pac64(PChar(p)+268)^[0] then begin
   pac16(PChar(p)+193)^[0] := pac16(PChar(p)+193)^[0] - $80;
   if pac16(PChar(p)+41)^[0] < pac16(PChar(p)+452)^[0] then pac64(PChar(p)+388)^[0] := pac64(PChar(p)+55)^[0] or $e0fae398 else pac32(PChar(p)+293)^[0] := pac32(PChar(p)+293)^[0] + $c0e1;
   pac16(PChar(p)+408)^[0] := pac16(PChar(p)+408)^[0] or rol1(pac16(PChar(p)+475)^[0] , 1 );
   pac64(PChar(p)+247)^[0] := pac64(PChar(p)+247)^[0] xor $00d74d192d;
   pac16(PChar(p)+192)^[0] := pac16(PChar(p)+192)^[0] - (pac16(PChar(p)+31)^[0] xor $a0);
 end;

 pac16(PChar(p)+94)^[0] := pac16(PChar(p)+94)^[0] + ror1(pac16(PChar(p)+87)^[0] , 12 );
 num := pac8(PChar(p)+228)^[0]; pac8(PChar(p)+228)^[0] := pac8(PChar(p)+249)^[0]; pac8(PChar(p)+249)^[0] := num;
 pac32(PChar(p)+154)^[0] := pac32(PChar(p)+154)^[0] or $b04c31;
 num := pac16(PChar(p)+75)^[0]; pac16(PChar(p)+75)^[0] := pac16(PChar(p)+429)^[0]; pac16(PChar(p)+429)^[0] := num;
 if pac64(PChar(p)+496)^[0] > pac64(PChar(p)+266)^[0] then begin  num := pac8(PChar(p)+199)^[0]; pac8(PChar(p)+199)^[0] := pac8(PChar(p)+505)^[0]; pac8(PChar(p)+505)^[0] := num; end else pac8(PChar(p)+216)^[0] := pac8(PChar(p)+216)^[0] or (pac8(PChar(p)+287)^[0] - $70);

ED67C55B(p);

end;

procedure ED67C55B(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+336)^[0] := pac64(PChar(p)+226)^[0] or $20f8e580f6;
 pac32(PChar(p)+492)^[0] := pac32(PChar(p)+289)^[0] + $70ad39;
 pac16(PChar(p)+309)^[0] := pac16(PChar(p)+309)^[0] - (pac16(PChar(p)+505)^[0] xor $40);
 num := pac16(PChar(p)+48)^[0]; pac16(PChar(p)+48)^[0] := pac16(PChar(p)+263)^[0]; pac16(PChar(p)+263)^[0] := num;
 num := pac32(PChar(p)+492)^[0]; pac32(PChar(p)+492)^[0] := pac32(PChar(p)+461)^[0]; pac32(PChar(p)+461)^[0] := num;
 if pac32(PChar(p)+16)^[0] < pac32(PChar(p)+427)^[0] then begin  num := pac16(PChar(p)+110)^[0]; pac16(PChar(p)+110)^[0] := pac16(PChar(p)+330)^[0]; pac16(PChar(p)+330)^[0] := num; end;

 if pac8(PChar(p)+115)^[0] < pac8(PChar(p)+199)^[0] then begin
   num := pac8(PChar(p)+498)^[0]; pac8(PChar(p)+498)^[0] := pac8(PChar(p)+0)^[0]; pac8(PChar(p)+0)^[0] := num;
   if pac32(PChar(p)+461)^[0] < pac32(PChar(p)+410)^[0] then pac16(PChar(p)+387)^[0] := pac16(PChar(p)+387)^[0] - ror2(pac16(PChar(p)+145)^[0] , 2 ) else begin  num := pac16(PChar(p)+327)^[0]; pac16(PChar(p)+327)^[0] := pac16(PChar(p)+434)^[0]; pac16(PChar(p)+434)^[0] := num; end;
 end;


 if pac16(PChar(p)+279)^[0] > pac16(PChar(p)+266)^[0] then begin
   pac32(PChar(p)+252)^[0] := pac32(PChar(p)+252)^[0] + (pac32(PChar(p)+158)^[0] xor $7092);
   pac32(PChar(p)+67)^[0] := pac32(PChar(p)+67)^[0] - (pac32(PChar(p)+106)^[0] or $30b6);
   pac64(PChar(p)+389)^[0] := pac64(PChar(p)+389)^[0] + $00656ff50ef3;
   pac32(PChar(p)+334)^[0] := pac32(PChar(p)+334)^[0] + (pac32(PChar(p)+233)^[0] - $e0c9b9);
 end;

 pac64(PChar(p)+142)^[0] := pac64(PChar(p)+142)^[0] or (pac64(PChar(p)+86)^[0] - $a0476c92b42f);
 pac32(PChar(p)+211)^[0] := pac32(PChar(p)+211)^[0] or $e060;

A7E514E2(p);

end;

procedure A7E514E2(p: Pointer);
var num: Int64;
begin


 if pac8(PChar(p)+275)^[0] < pac8(PChar(p)+251)^[0] then begin
   pac8(PChar(p)+402)^[0] := ror2(pac8(PChar(p)+420)^[0] , 3 );
   pac16(PChar(p)+281)^[0] := pac16(PChar(p)+281)^[0] or $90;
   pac32(PChar(p)+137)^[0] := pac32(PChar(p)+137)^[0] xor rol1(pac32(PChar(p)+267)^[0] , 17 );
   pac16(PChar(p)+59)^[0] := pac16(PChar(p)+59)^[0] - ror2(pac16(PChar(p)+44)^[0] , 4 );
 end;

 pac32(PChar(p)+142)^[0] := pac32(PChar(p)+142)^[0] + ror2(pac32(PChar(p)+111)^[0] , 21 );
 num := pac16(PChar(p)+452)^[0]; pac16(PChar(p)+452)^[0] := pac16(PChar(p)+266)^[0]; pac16(PChar(p)+266)^[0] := num;
 pac64(PChar(p)+52)^[0] := pac64(PChar(p)+52)^[0] - (pac64(PChar(p)+250)^[0] xor $209f3763bcd7);
 num := pac8(PChar(p)+289)^[0]; pac8(PChar(p)+289)^[0] := pac8(PChar(p)+426)^[0]; pac8(PChar(p)+426)^[0] := num;
 pac32(PChar(p)+496)^[0] := pac32(PChar(p)+496)^[0] xor (pac32(PChar(p)+337)^[0] xor $c03f);
 pac64(PChar(p)+310)^[0] := pac64(PChar(p)+310)^[0] xor $80144104bca8;
 num := pac16(PChar(p)+448)^[0]; pac16(PChar(p)+448)^[0] := pac16(PChar(p)+35)^[0]; pac16(PChar(p)+35)^[0] := num;
 num := pac16(PChar(p)+265)^[0]; pac16(PChar(p)+265)^[0] := pac16(PChar(p)+12)^[0]; pac16(PChar(p)+12)^[0] := num;
 pac32(PChar(p)+287)^[0] := pac32(PChar(p)+287)^[0] or $a0cd;

 if pac64(PChar(p)+40)^[0] > pac64(PChar(p)+328)^[0] then begin
   pac32(PChar(p)+189)^[0] := pac32(PChar(p)+189)^[0] + $001032;
   if pac32(PChar(p)+501)^[0] > pac32(PChar(p)+240)^[0] then pac8(PChar(p)+461)^[0] := ror1(pac8(PChar(p)+131)^[0] , 6 ) else pac8(PChar(p)+292)^[0] := pac8(PChar(p)+292)^[0] or $40;
   pac32(PChar(p)+8)^[0] := pac32(PChar(p)+8)^[0] xor ror2(pac32(PChar(p)+106)^[0] , 15 );
   num := pac8(PChar(p)+175)^[0]; pac8(PChar(p)+175)^[0] := pac8(PChar(p)+396)^[0]; pac8(PChar(p)+396)^[0] := num;
 end;

 num := pac32(PChar(p)+301)^[0]; pac32(PChar(p)+301)^[0] := pac32(PChar(p)+229)^[0]; pac32(PChar(p)+229)^[0] := num;

CEF72F50(p);

end;

procedure CEF72F50(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+425)^[0] := pac16(PChar(p)+425)^[0] xor ror2(pac16(PChar(p)+37)^[0] , 10 );
 num := pac32(PChar(p)+85)^[0]; pac32(PChar(p)+85)^[0] := pac32(PChar(p)+502)^[0]; pac32(PChar(p)+502)^[0] := num;
 if pac32(PChar(p)+259)^[0] > pac32(PChar(p)+58)^[0] then pac32(PChar(p)+507)^[0] := pac32(PChar(p)+507)^[0] - ror2(pac32(PChar(p)+104)^[0] , 2 ) else pac16(PChar(p)+265)^[0] := pac16(PChar(p)+265)^[0] - (pac16(PChar(p)+405)^[0] or $50);
 pac8(PChar(p)+80)^[0] := pac8(PChar(p)+80)^[0] xor $10;
 pac32(PChar(p)+365)^[0] := pac32(PChar(p)+365)^[0] xor $d021;

 if pac16(PChar(p)+481)^[0] < pac16(PChar(p)+276)^[0] then begin
   if pac32(PChar(p)+314)^[0] < pac32(PChar(p)+282)^[0] then pac16(PChar(p)+95)^[0] := pac16(PChar(p)+95)^[0] - (pac16(PChar(p)+18)^[0] or $80) else pac8(PChar(p)+382)^[0] := pac8(PChar(p)+455)^[0] or $70;
   pac64(PChar(p)+489)^[0] := pac64(PChar(p)+489)^[0] or $0000d5e1da0b;
 end;

 pac16(PChar(p)+304)^[0] := pac16(PChar(p)+304)^[0] xor $c0;
 pac16(PChar(p)+47)^[0] := pac16(PChar(p)+47)^[0] - ror2(pac16(PChar(p)+79)^[0] , 5 );
 pac64(PChar(p)+151)^[0] := pac64(PChar(p)+151)^[0] - $80226fc1e589;
 pac64(PChar(p)+303)^[0] := pac64(PChar(p)+303)^[0] or (pac64(PChar(p)+307)^[0] - $e0857484);

 if pac16(PChar(p)+65)^[0] > pac16(PChar(p)+362)^[0] then begin
   pac8(PChar(p)+248)^[0] := pac8(PChar(p)+248)^[0] xor (pac8(PChar(p)+491)^[0] + $83);
   pac8(PChar(p)+275)^[0] := pac8(PChar(p)+275)^[0] + (pac8(PChar(p)+346)^[0] or $f0);
   if pac8(PChar(p)+222)^[0] < pac8(PChar(p)+371)^[0] then pac64(PChar(p)+4)^[0] := pac64(PChar(p)+4)^[0] + $a05b897b else pac8(PChar(p)+118)^[0] := pac8(PChar(p)+118)^[0] - $70;
   pac64(PChar(p)+229)^[0] := pac64(PChar(p)+229)^[0] xor (pac64(PChar(p)+187)^[0] xor $402d6200e48a);
   pac16(PChar(p)+0)^[0] := pac16(PChar(p)+296)^[0] + (pac16(PChar(p)+507)^[0] xor $f0);
 end;


 if pac16(PChar(p)+176)^[0] > pac16(PChar(p)+209)^[0] then begin
   if pac64(PChar(p)+252)^[0] < pac64(PChar(p)+67)^[0] then begin  num := pac16(PChar(p)+73)^[0]; pac16(PChar(p)+73)^[0] := pac16(PChar(p)+356)^[0]; pac16(PChar(p)+356)^[0] := num; end else begin  num := pac8(PChar(p)+434)^[0]; pac8(PChar(p)+434)^[0] := pac8(PChar(p)+465)^[0]; pac8(PChar(p)+465)^[0] := num; end;
   pac64(PChar(p)+474)^[0] := pac64(PChar(p)+474)^[0] + $909a6131e128;
   pac32(PChar(p)+453)^[0] := pac32(PChar(p)+453)^[0] - $301e;
   if pac64(PChar(p)+221)^[0] > pac64(PChar(p)+400)^[0] then pac32(PChar(p)+31)^[0] := ror2(pac32(PChar(p)+481)^[0] , 16 ) else begin  num := pac8(PChar(p)+436)^[0]; pac8(PChar(p)+436)^[0] := pac8(PChar(p)+200)^[0]; pac8(PChar(p)+200)^[0] := num; end;
   pac32(PChar(p)+409)^[0] := pac32(PChar(p)+409)^[0] + ror2(pac32(PChar(p)+125)^[0] , 20 );
 end;

 if pac8(PChar(p)+388)^[0] < pac8(PChar(p)+349)^[0] then pac8(PChar(p)+11)^[0] := pac8(PChar(p)+11)^[0] + ror2(pac8(PChar(p)+233)^[0] , 7 ) else pac8(PChar(p)+121)^[0] := pac8(PChar(p)+121)^[0] - ror1(pac8(PChar(p)+393)^[0] , 1 );
 pac64(PChar(p)+80)^[0] := pac64(PChar(p)+35)^[0] or $006becbb;
 pac64(PChar(p)+318)^[0] := pac64(PChar(p)+440)^[0] - $708c51a32101;
 pac64(PChar(p)+469)^[0] := pac64(PChar(p)+469)^[0] + (pac64(PChar(p)+303)^[0] - $50bc2370);

A2722456(p);

end;

procedure A2722456(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+301)^[0] := pac16(PChar(p)+301)^[0] - ror2(pac16(PChar(p)+213)^[0] , 3 );
 num := pac32(PChar(p)+119)^[0]; pac32(PChar(p)+119)^[0] := pac32(PChar(p)+88)^[0]; pac32(PChar(p)+88)^[0] := num;
 if pac8(PChar(p)+323)^[0] < pac8(PChar(p)+144)^[0] then pac64(PChar(p)+67)^[0] := pac64(PChar(p)+67)^[0] - $a0c5bee4 else pac16(PChar(p)+11)^[0] := pac16(PChar(p)+11)^[0] xor ror2(pac16(PChar(p)+480)^[0] , 10 );
 num := pac32(PChar(p)+422)^[0]; pac32(PChar(p)+422)^[0] := pac32(PChar(p)+441)^[0]; pac32(PChar(p)+441)^[0] := num;
 pac64(PChar(p)+416)^[0] := pac64(PChar(p)+416)^[0] or $a0767168;

 if pac16(PChar(p)+25)^[0] > pac16(PChar(p)+48)^[0] then begin
   pac32(PChar(p)+150)^[0] := pac32(PChar(p)+150)^[0] - $10d5;
   num := pac8(PChar(p)+153)^[0]; pac8(PChar(p)+153)^[0] := pac8(PChar(p)+410)^[0]; pac8(PChar(p)+410)^[0] := num;
   if pac16(PChar(p)+410)^[0] < pac16(PChar(p)+433)^[0] then pac16(PChar(p)+430)^[0] := pac16(PChar(p)+430)^[0] + $c0 else pac16(PChar(p)+428)^[0] := pac16(PChar(p)+428)^[0] - ror2(pac16(PChar(p)+411)^[0] , 12 );
   if pac32(PChar(p)+40)^[0] > pac32(PChar(p)+73)^[0] then pac64(PChar(p)+224)^[0] := pac64(PChar(p)+224)^[0] or (pac64(PChar(p)+196)^[0] + $70974d7755d4) else pac16(PChar(p)+494)^[0] := pac16(PChar(p)+494)^[0] xor (pac16(PChar(p)+326)^[0] xor $d0);
   pac16(PChar(p)+440)^[0] := pac16(PChar(p)+440)^[0] xor ror1(pac16(PChar(p)+97)^[0] , 1 );
 end;

 pac32(PChar(p)+38)^[0] := pac32(PChar(p)+38)^[0] or (pac32(PChar(p)+36)^[0] + $400f4a);
 pac16(PChar(p)+42)^[0] := pac16(PChar(p)+42)^[0] + ror2(pac16(PChar(p)+152)^[0] , 5 );
 pac8(PChar(p)+260)^[0] := pac8(PChar(p)+260)^[0] - ror2(pac8(PChar(p)+13)^[0] , 5 );
 pac8(PChar(p)+478)^[0] := pac8(PChar(p)+478)^[0] - ror1(pac8(PChar(p)+386)^[0] , 1 );
 pac32(PChar(p)+183)^[0] := pac32(PChar(p)+183)^[0] xor ror1(pac32(PChar(p)+246)^[0] , 12 );

 if pac8(PChar(p)+53)^[0] > pac8(PChar(p)+431)^[0] then begin
   pac64(PChar(p)+107)^[0] := pac64(PChar(p)+107)^[0] + (pac64(PChar(p)+427)^[0] + $20b02e03db7c);
   pac32(PChar(p)+268)^[0] := pac32(PChar(p)+268)^[0] + rol1(pac32(PChar(p)+261)^[0] , 27 );
   pac16(PChar(p)+83)^[0] := pac16(PChar(p)+83)^[0] + ror2(pac16(PChar(p)+335)^[0] , 6 );
   pac32(PChar(p)+18)^[0] := pac32(PChar(p)+18)^[0] or (pac32(PChar(p)+135)^[0] or $60ad);
   pac32(PChar(p)+343)^[0] := pac32(PChar(p)+395)^[0] + $204e;
 end;

 if pac16(PChar(p)+222)^[0] > pac16(PChar(p)+322)^[0] then pac32(PChar(p)+238)^[0] := pac32(PChar(p)+238)^[0] + $70a9 else pac32(PChar(p)+257)^[0] := pac32(PChar(p)+257)^[0] + ror1(pac32(PChar(p)+312)^[0] , 12 );
 num := pac8(PChar(p)+493)^[0]; pac8(PChar(p)+493)^[0] := pac8(PChar(p)+411)^[0]; pac8(PChar(p)+411)^[0] := num;

 if pac64(PChar(p)+81)^[0] < pac64(PChar(p)+106)^[0] then begin
   num := pac8(PChar(p)+116)^[0]; pac8(PChar(p)+116)^[0] := pac8(PChar(p)+233)^[0]; pac8(PChar(p)+233)^[0] := num;
   pac64(PChar(p)+415)^[0] := pac64(PChar(p)+415)^[0] xor (pac64(PChar(p)+64)^[0] - $8037ef2c207a);
   if pac64(PChar(p)+316)^[0] < pac64(PChar(p)+335)^[0] then pac16(PChar(p)+158)^[0] := pac16(PChar(p)+158)^[0] xor ror2(pac16(PChar(p)+402)^[0] , 6 ) else begin  num := pac16(PChar(p)+6)^[0]; pac16(PChar(p)+6)^[0] := pac16(PChar(p)+290)^[0]; pac16(PChar(p)+290)^[0] := num; end;
   pac32(PChar(p)+321)^[0] := pac32(PChar(p)+321)^[0] + ror2(pac32(PChar(p)+130)^[0] , 6 );
 end;


CDCC4482(p);

end;

procedure CDCC4482(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+154)^[0] := pac64(PChar(p)+117)^[0] xor $a0daaaebf5;
 num := pac16(PChar(p)+42)^[0]; pac16(PChar(p)+42)^[0] := pac16(PChar(p)+356)^[0]; pac16(PChar(p)+356)^[0] := num;
 pac32(PChar(p)+263)^[0] := pac32(PChar(p)+263)^[0] - (pac32(PChar(p)+314)^[0] xor $a0e9);
 num := pac16(PChar(p)+165)^[0]; pac16(PChar(p)+165)^[0] := pac16(PChar(p)+318)^[0]; pac16(PChar(p)+318)^[0] := num;

 if pac8(PChar(p)+313)^[0] < pac8(PChar(p)+48)^[0] then begin
   pac64(PChar(p)+452)^[0] := pac64(PChar(p)+452)^[0] or $806ec518e1;
   num := pac8(PChar(p)+64)^[0]; pac8(PChar(p)+64)^[0] := pac8(PChar(p)+507)^[0]; pac8(PChar(p)+507)^[0] := num;
 end;

 pac8(PChar(p)+71)^[0] := pac8(PChar(p)+71)^[0] xor rol1(pac8(PChar(p)+307)^[0] , 5 );

 if pac8(PChar(p)+500)^[0] > pac8(PChar(p)+295)^[0] then begin
   if pac8(PChar(p)+464)^[0] < pac8(PChar(p)+428)^[0] then pac32(PChar(p)+504)^[0] := pac32(PChar(p)+504)^[0] + $b09bdd;
   if pac8(PChar(p)+79)^[0] < pac8(PChar(p)+141)^[0] then begin  num := pac8(PChar(p)+280)^[0]; pac8(PChar(p)+280)^[0] := pac8(PChar(p)+260)^[0]; pac8(PChar(p)+260)^[0] := num; end else pac16(PChar(p)+189)^[0] := pac16(PChar(p)+265)^[0] - $50;
   if pac16(PChar(p)+313)^[0] < pac16(PChar(p)+51)^[0] then begin  num := pac16(PChar(p)+367)^[0]; pac16(PChar(p)+367)^[0] := pac16(PChar(p)+468)^[0]; pac16(PChar(p)+468)^[0] := num; end else pac32(PChar(p)+255)^[0] := pac32(PChar(p)+488)^[0] + $1003fa;
   if pac16(PChar(p)+4)^[0] < pac16(PChar(p)+272)^[0] then pac8(PChar(p)+266)^[0] := pac8(PChar(p)+185)^[0] or (pac8(PChar(p)+175)^[0] - $b0) else pac8(PChar(p)+253)^[0] := pac8(PChar(p)+104)^[0] or $e0;
   num := pac16(PChar(p)+306)^[0]; pac16(PChar(p)+306)^[0] := pac16(PChar(p)+125)^[0]; pac16(PChar(p)+125)^[0] := num;
 end;

 pac32(PChar(p)+68)^[0] := ror2(pac32(PChar(p)+95)^[0] , 11 );
 if pac16(PChar(p)+292)^[0] > pac16(PChar(p)+21)^[0] then pac8(PChar(p)+422)^[0] := pac8(PChar(p)+413)^[0] - $20 else begin  num := pac16(PChar(p)+314)^[0]; pac16(PChar(p)+314)^[0] := pac16(PChar(p)+95)^[0]; pac16(PChar(p)+95)^[0] := num; end;
 num := pac8(PChar(p)+280)^[0]; pac8(PChar(p)+280)^[0] := pac8(PChar(p)+397)^[0]; pac8(PChar(p)+397)^[0] := num;
 num := pac8(PChar(p)+9)^[0]; pac8(PChar(p)+9)^[0] := pac8(PChar(p)+462)^[0]; pac8(PChar(p)+462)^[0] := num;
 num := pac16(PChar(p)+326)^[0]; pac16(PChar(p)+326)^[0] := pac16(PChar(p)+60)^[0]; pac16(PChar(p)+60)^[0] := num;
 pac32(PChar(p)+91)^[0] := pac32(PChar(p)+91)^[0] - $f0c8;
 num := pac8(PChar(p)+336)^[0]; pac8(PChar(p)+336)^[0] := pac8(PChar(p)+360)^[0]; pac8(PChar(p)+360)^[0] := num;
 pac8(PChar(p)+159)^[0] := pac8(PChar(p)+159)^[0] xor (pac8(PChar(p)+88)^[0] or $30);
 pac8(PChar(p)+165)^[0] := pac8(PChar(p)+165)^[0] xor ror1(pac8(PChar(p)+360)^[0] , 1 );
 if pac16(PChar(p)+445)^[0] > pac16(PChar(p)+510)^[0] then pac8(PChar(p)+410)^[0] := pac8(PChar(p)+410)^[0] or ror2(pac8(PChar(p)+261)^[0] , 2 ) else begin  num := pac8(PChar(p)+125)^[0]; pac8(PChar(p)+125)^[0] := pac8(PChar(p)+96)^[0]; pac8(PChar(p)+96)^[0] := num; end;
 pac64(PChar(p)+409)^[0] := pac64(PChar(p)+148)^[0] xor (pac64(PChar(p)+25)^[0] or $40baca15);

B78CF4DA(p);

end;

procedure B78CF4DA(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+441)^[0] := pac16(PChar(p)+441)^[0] xor ror1(pac16(PChar(p)+326)^[0] , 1 );
 pac16(PChar(p)+363)^[0] := pac16(PChar(p)+363)^[0] - ror1(pac16(PChar(p)+101)^[0] , 11 );
 pac64(PChar(p)+383)^[0] := pac64(PChar(p)+193)^[0] + $707728f6;
 pac64(PChar(p)+410)^[0] := pac64(PChar(p)+410)^[0] or (pac64(PChar(p)+468)^[0] - $309c43df5e);
 if pac16(PChar(p)+24)^[0] > pac16(PChar(p)+62)^[0] then pac16(PChar(p)+130)^[0] := pac16(PChar(p)+130)^[0] - ror2(pac16(PChar(p)+396)^[0] , 12 ) else pac8(PChar(p)+240)^[0] := pac8(PChar(p)+240)^[0] xor rol1(pac8(PChar(p)+45)^[0] , 7 );
 num := pac16(PChar(p)+129)^[0]; pac16(PChar(p)+129)^[0] := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := num;
 pac16(PChar(p)+199)^[0] := pac16(PChar(p)+55)^[0] or $40;
 pac16(PChar(p)+186)^[0] := pac16(PChar(p)+186)^[0] xor $40;
 pac8(PChar(p)+464)^[0] := pac8(PChar(p)+464)^[0] xor ror2(pac8(PChar(p)+260)^[0] , 4 );
 pac64(PChar(p)+35)^[0] := pac64(PChar(p)+35)^[0] - $801bdfc09a4b;
 pac8(PChar(p)+275)^[0] := pac8(PChar(p)+487)^[0] xor (pac8(PChar(p)+437)^[0] xor $f0);
 if pac64(PChar(p)+51)^[0] < pac64(PChar(p)+183)^[0] then pac64(PChar(p)+280)^[0] := pac64(PChar(p)+280)^[0] + $50762c981c8b else begin  num := pac32(PChar(p)+423)^[0]; pac32(PChar(p)+423)^[0] := pac32(PChar(p)+73)^[0]; pac32(PChar(p)+73)^[0] := num; end;
 pac16(PChar(p)+132)^[0] := pac16(PChar(p)+132)^[0] or $90;

 if pac32(PChar(p)+283)^[0] > pac32(PChar(p)+190)^[0] then begin
   if pac8(PChar(p)+8)^[0] > pac8(PChar(p)+348)^[0] then pac16(PChar(p)+459)^[0] := pac16(PChar(p)+18)^[0] xor (pac16(PChar(p)+363)^[0] or $50);
   num := pac16(PChar(p)+416)^[0]; pac16(PChar(p)+416)^[0] := pac16(PChar(p)+266)^[0]; pac16(PChar(p)+266)^[0] := num;
   num := pac8(PChar(p)+238)^[0]; pac8(PChar(p)+238)^[0] := pac8(PChar(p)+294)^[0]; pac8(PChar(p)+294)^[0] := num;
 end;

 pac64(PChar(p)+212)^[0] := pac64(PChar(p)+212)^[0] or $3075fa0580;
 pac8(PChar(p)+169)^[0] := pac8(PChar(p)+169)^[0] + ror1(pac8(PChar(p)+369)^[0] , 5 );
 if pac64(PChar(p)+344)^[0] > pac64(PChar(p)+208)^[0] then pac8(PChar(p)+431)^[0] := pac8(PChar(p)+492)^[0] xor $80 else pac64(PChar(p)+498)^[0] := pac64(PChar(p)+243)^[0] - (pac64(PChar(p)+374)^[0] xor $90d72caa8d);

E361701F(p);

end;

procedure E361701F(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+387)^[0] < pac16(PChar(p)+61)^[0] then begin
   pac8(PChar(p)+89)^[0] := pac8(PChar(p)+89)^[0] + (pac8(PChar(p)+71)^[0] xor $70);
   if pac64(PChar(p)+196)^[0] > pac64(PChar(p)+265)^[0] then pac32(PChar(p)+409)^[0] := pac32(PChar(p)+409)^[0] - rol1(pac32(PChar(p)+241)^[0] , 13 ) else pac16(PChar(p)+103)^[0] := pac16(PChar(p)+103)^[0] - $e0;
   pac8(PChar(p)+430)^[0] := pac8(PChar(p)+430)^[0] + (pac8(PChar(p)+194)^[0] xor $a0);
   if pac16(PChar(p)+379)^[0] > pac16(PChar(p)+299)^[0] then pac16(PChar(p)+457)^[0] := pac16(PChar(p)+457)^[0] + $10 else pac16(PChar(p)+44)^[0] := pac16(PChar(p)+44)^[0] or ror2(pac16(PChar(p)+232)^[0] , 9 );
 end;


 if pac16(PChar(p)+405)^[0] < pac16(PChar(p)+131)^[0] then begin
   num := pac8(PChar(p)+486)^[0]; pac8(PChar(p)+486)^[0] := pac8(PChar(p)+197)^[0]; pac8(PChar(p)+197)^[0] := num;
   pac32(PChar(p)+464)^[0] := pac32(PChar(p)+464)^[0] - $70d5;
   pac16(PChar(p)+155)^[0] := pac16(PChar(p)+154)^[0] xor $60;
 end;

 if pac16(PChar(p)+259)^[0] < pac16(PChar(p)+436)^[0] then pac16(PChar(p)+1)^[0] := pac16(PChar(p)+1)^[0] or ror1(pac16(PChar(p)+348)^[0] , 4 );
 num := pac16(PChar(p)+347)^[0]; pac16(PChar(p)+347)^[0] := pac16(PChar(p)+342)^[0]; pac16(PChar(p)+342)^[0] := num;
 pac32(PChar(p)+203)^[0] := pac32(PChar(p)+257)^[0] or $c083;

 if pac8(PChar(p)+22)^[0] < pac8(PChar(p)+163)^[0] then begin
   pac16(PChar(p)+403)^[0] := pac16(PChar(p)+403)^[0] or (pac16(PChar(p)+198)^[0] or $b0);
   pac16(PChar(p)+359)^[0] := pac16(PChar(p)+359)^[0] xor ror2(pac16(PChar(p)+305)^[0] , 11 );
   if pac16(PChar(p)+318)^[0] > pac16(PChar(p)+330)^[0] then pac16(PChar(p)+206)^[0] := pac16(PChar(p)+423)^[0] or $a0;
   num := pac8(PChar(p)+248)^[0]; pac8(PChar(p)+248)^[0] := pac8(PChar(p)+187)^[0]; pac8(PChar(p)+187)^[0] := num;
 end;

 pac64(PChar(p)+173)^[0] := pac64(PChar(p)+173)^[0] or $b028a3dce93c;
 pac64(PChar(p)+29)^[0] := pac64(PChar(p)+29)^[0] or $00d9788f6af2;
 pac64(PChar(p)+391)^[0] := pac64(PChar(p)+391)^[0] - (pac64(PChar(p)+483)^[0] - $50179e23efa3);
 pac8(PChar(p)+165)^[0] := pac8(PChar(p)+165)^[0] xor $80;
 pac32(PChar(p)+487)^[0] := pac32(PChar(p)+487)^[0] - ror2(pac32(PChar(p)+449)^[0] , 9 );
 pac32(PChar(p)+301)^[0] := rol1(pac32(PChar(p)+14)^[0] , 25 );
 pac8(PChar(p)+387)^[0] := pac8(PChar(p)+387)^[0] or (pac8(PChar(p)+284)^[0] xor $20);
 pac8(PChar(p)+146)^[0] := ror2(pac8(PChar(p)+75)^[0] , 2 );

 if pac16(PChar(p)+252)^[0] < pac16(PChar(p)+476)^[0] then begin
   num := pac32(PChar(p)+301)^[0]; pac32(PChar(p)+301)^[0] := pac32(PChar(p)+32)^[0]; pac32(PChar(p)+32)^[0] := num;
   pac16(PChar(p)+401)^[0] := pac16(PChar(p)+401)^[0] or $e5;
   pac32(PChar(p)+427)^[0] := pac32(PChar(p)+427)^[0] xor (pac32(PChar(p)+312)^[0] xor $803389);
   pac16(PChar(p)+208)^[0] := pac16(PChar(p)+208)^[0] - rol1(pac16(PChar(p)+456)^[0] , 14 );
 end;

 pac64(PChar(p)+222)^[0] := pac64(PChar(p)+222)^[0] xor (pac64(PChar(p)+481)^[0] or $60f29a09547f);

 if pac64(PChar(p)+357)^[0] < pac64(PChar(p)+461)^[0] then begin
   num := pac8(PChar(p)+263)^[0]; pac8(PChar(p)+263)^[0] := pac8(PChar(p)+246)^[0]; pac8(PChar(p)+246)^[0] := num;
   pac8(PChar(p)+325)^[0] := pac8(PChar(p)+325)^[0] - ror1(pac8(PChar(p)+459)^[0] , 2 );
 end;


FB81E6FB(p);

end;

procedure FB81E6FB(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+136)^[0] := pac8(PChar(p)+136)^[0] - (pac8(PChar(p)+127)^[0] + $90);
 pac64(PChar(p)+37)^[0] := pac64(PChar(p)+37)^[0] xor (pac64(PChar(p)+258)^[0] - $a0a1664e);
 num := pac8(PChar(p)+466)^[0]; pac8(PChar(p)+466)^[0] := pac8(PChar(p)+163)^[0]; pac8(PChar(p)+163)^[0] := num;
 pac8(PChar(p)+184)^[0] := pac8(PChar(p)+184)^[0] or rol1(pac8(PChar(p)+231)^[0] , 7 );
 pac16(PChar(p)+6)^[0] := pac16(PChar(p)+6)^[0] xor $c0;
 if pac8(PChar(p)+162)^[0] > pac8(PChar(p)+376)^[0] then pac32(PChar(p)+349)^[0] := rol1(pac32(PChar(p)+417)^[0] , 23 ) else pac64(PChar(p)+361)^[0] := pac64(PChar(p)+394)^[0] + (pac64(PChar(p)+192)^[0] xor $0039f32ae3);
 num := pac8(PChar(p)+308)^[0]; pac8(PChar(p)+308)^[0] := pac8(PChar(p)+493)^[0]; pac8(PChar(p)+493)^[0] := num;
 pac32(PChar(p)+169)^[0] := ror1(pac32(PChar(p)+333)^[0] , 12 );
 if pac32(PChar(p)+217)^[0] < pac32(PChar(p)+96)^[0] then pac64(PChar(p)+233)^[0] := pac64(PChar(p)+233)^[0] xor (pac64(PChar(p)+359)^[0] - $000008b54633);

 if pac16(PChar(p)+95)^[0] > pac16(PChar(p)+194)^[0] then begin
   if pac64(PChar(p)+35)^[0] < pac64(PChar(p)+145)^[0] then pac8(PChar(p)+344)^[0] := pac8(PChar(p)+344)^[0] or (pac8(PChar(p)+310)^[0] - $80) else begin  num := pac8(PChar(p)+147)^[0]; pac8(PChar(p)+147)^[0] := pac8(PChar(p)+462)^[0]; pac8(PChar(p)+462)^[0] := num; end;
   num := pac32(PChar(p)+416)^[0]; pac32(PChar(p)+416)^[0] := pac32(PChar(p)+296)^[0]; pac32(PChar(p)+296)^[0] := num;
   pac32(PChar(p)+66)^[0] := pac32(PChar(p)+66)^[0] xor (pac32(PChar(p)+485)^[0] - $a03b);
 end;

 if pac8(PChar(p)+241)^[0] < pac8(PChar(p)+455)^[0] then begin  num := pac16(PChar(p)+99)^[0]; pac16(PChar(p)+99)^[0] := pac16(PChar(p)+412)^[0]; pac16(PChar(p)+412)^[0] := num; end else pac16(PChar(p)+213)^[0] := pac16(PChar(p)+213)^[0] or rol1(pac16(PChar(p)+466)^[0] , 8 );
 pac64(PChar(p)+153)^[0] := pac64(PChar(p)+153)^[0] or (pac64(PChar(p)+145)^[0] - $d07ff9b3fa);
 pac16(PChar(p)+96)^[0] := pac16(PChar(p)+96)^[0] - (pac16(PChar(p)+326)^[0] xor $70);

 if pac8(PChar(p)+491)^[0] < pac8(PChar(p)+202)^[0] then begin
   pac64(PChar(p)+502)^[0] := pac64(PChar(p)+502)^[0] xor (pac64(PChar(p)+455)^[0] or $50ab2fa2ef);
   pac16(PChar(p)+450)^[0] := pac16(PChar(p)+450)^[0] - $30;
 end;


C791F951(p);

end;

procedure C791F951(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+341)^[0] < pac8(PChar(p)+24)^[0] then begin  num := pac16(PChar(p)+249)^[0]; pac16(PChar(p)+249)^[0] := pac16(PChar(p)+85)^[0]; pac16(PChar(p)+85)^[0] := num; end;
 if pac32(PChar(p)+421)^[0] < pac32(PChar(p)+253)^[0] then begin  num := pac16(PChar(p)+509)^[0]; pac16(PChar(p)+509)^[0] := pac16(PChar(p)+245)^[0]; pac16(PChar(p)+245)^[0] := num; end else pac32(PChar(p)+95)^[0] := pac32(PChar(p)+95)^[0] xor (pac32(PChar(p)+137)^[0] or $10e963);
 pac64(PChar(p)+371)^[0] := pac64(PChar(p)+186)^[0] or (pac64(PChar(p)+451)^[0] or $405f0aad1d);
 pac64(PChar(p)+228)^[0] := pac64(PChar(p)+228)^[0] xor (pac64(PChar(p)+444)^[0] + $90739fe804);
 if pac32(PChar(p)+78)^[0] > pac32(PChar(p)+204)^[0] then pac32(PChar(p)+121)^[0] := ror1(pac32(PChar(p)+211)^[0] , 13 ) else pac64(PChar(p)+367)^[0] := pac64(PChar(p)+367)^[0] xor $1057fadf;

 if pac32(PChar(p)+70)^[0] > pac32(PChar(p)+378)^[0] then begin
   pac32(PChar(p)+100)^[0] := pac32(PChar(p)+100)^[0] or ror2(pac32(PChar(p)+14)^[0] , 23 );
   pac64(PChar(p)+87)^[0] := pac64(PChar(p)+129)^[0] + (pac64(PChar(p)+423)^[0] + $b0001ff0d1e4);
   if pac8(PChar(p)+34)^[0] < pac8(PChar(p)+368)^[0] then pac64(PChar(p)+279)^[0] := pac64(PChar(p)+279)^[0] + $1056598236 else pac32(PChar(p)+377)^[0] := pac32(PChar(p)+377)^[0] or ror1(pac32(PChar(p)+308)^[0] , 26 );
 end;


 if pac8(PChar(p)+161)^[0] < pac8(PChar(p)+214)^[0] then begin
   pac8(PChar(p)+59)^[0] := pac8(PChar(p)+59)^[0] - ror2(pac8(PChar(p)+78)^[0] , 3 );
   pac64(PChar(p)+150)^[0] := pac64(PChar(p)+474)^[0] - $c0f04cd11c21;
   if pac64(PChar(p)+486)^[0] > pac64(PChar(p)+50)^[0] then begin  num := pac32(PChar(p)+229)^[0]; pac32(PChar(p)+229)^[0] := pac32(PChar(p)+284)^[0]; pac32(PChar(p)+284)^[0] := num; end else pac16(PChar(p)+308)^[0] := pac16(PChar(p)+308)^[0] or ror2(pac16(PChar(p)+386)^[0] , 10 );
   pac32(PChar(p)+74)^[0] := pac32(PChar(p)+74)^[0] + $507f;
 end;

 if pac64(PChar(p)+138)^[0] < pac64(PChar(p)+136)^[0] then pac8(PChar(p)+182)^[0] := pac8(PChar(p)+182)^[0] + $90 else pac64(PChar(p)+253)^[0] := pac64(PChar(p)+253)^[0] - (pac64(PChar(p)+53)^[0] xor $606fb0796108);
 if pac64(PChar(p)+283)^[0] < pac64(PChar(p)+91)^[0] then pac32(PChar(p)+276)^[0] := pac32(PChar(p)+276)^[0] xor $907f14;
 pac8(PChar(p)+243)^[0] := pac8(PChar(p)+243)^[0] - rol1(pac8(PChar(p)+305)^[0] , 5 );

 if pac64(PChar(p)+317)^[0] < pac64(PChar(p)+424)^[0] then begin
   pac8(PChar(p)+379)^[0] := pac8(PChar(p)+379)^[0] xor (pac8(PChar(p)+175)^[0] + $50);
   num := pac16(PChar(p)+402)^[0]; pac16(PChar(p)+402)^[0] := pac16(PChar(p)+259)^[0]; pac16(PChar(p)+259)^[0] := num;
   pac8(PChar(p)+234)^[0] := pac8(PChar(p)+234)^[0] + (pac8(PChar(p)+169)^[0] - $60);
   pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] or (pac32(PChar(p)+394)^[0] xor $401708);
   num := pac8(PChar(p)+179)^[0]; pac8(PChar(p)+179)^[0] := pac8(PChar(p)+320)^[0]; pac8(PChar(p)+320)^[0] := num;
 end;

 if pac16(PChar(p)+145)^[0] < pac16(PChar(p)+144)^[0] then pac32(PChar(p)+235)^[0] := pac32(PChar(p)+235)^[0] - $f0ad5b else pac32(PChar(p)+392)^[0] := pac32(PChar(p)+392)^[0] xor ror2(pac32(PChar(p)+137)^[0] , 29 );
 num := pac8(PChar(p)+468)^[0]; pac8(PChar(p)+468)^[0] := pac8(PChar(p)+267)^[0]; pac8(PChar(p)+267)^[0] := num;
 num := pac8(PChar(p)+64)^[0]; pac8(PChar(p)+64)^[0] := pac8(PChar(p)+220)^[0]; pac8(PChar(p)+220)^[0] := num;
 pac16(PChar(p)+457)^[0] := pac16(PChar(p)+457)^[0] - $10;

 if pac16(PChar(p)+2)^[0] < pac16(PChar(p)+197)^[0] then begin
   if pac32(PChar(p)+493)^[0] > pac32(PChar(p)+245)^[0] then pac32(PChar(p)+59)^[0] := pac32(PChar(p)+323)^[0] + (pac32(PChar(p)+181)^[0] or $20ac) else pac64(PChar(p)+171)^[0] := pac64(PChar(p)+171)^[0] - $604f827648;
   pac64(PChar(p)+238)^[0] := pac64(PChar(p)+238)^[0] + $a03601c655b8;
   pac64(PChar(p)+390)^[0] := pac64(PChar(p)+390)^[0] xor (pac64(PChar(p)+207)^[0] - $00693d36);
 end;


DB5770C0(p);

end;

procedure DB5770C0(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+389)^[0] < pac16(PChar(p)+321)^[0] then pac64(PChar(p)+272)^[0] := pac64(PChar(p)+272)^[0] + $d0e15146 else pac64(PChar(p)+299)^[0] := pac64(PChar(p)+299)^[0] - (pac64(PChar(p)+372)^[0] xor $d02b1038);
 pac32(PChar(p)+72)^[0] := pac32(PChar(p)+72)^[0] - $408c;
 num := pac32(PChar(p)+23)^[0]; pac32(PChar(p)+23)^[0] := pac32(PChar(p)+119)^[0]; pac32(PChar(p)+119)^[0] := num;
 num := pac32(PChar(p)+135)^[0]; pac32(PChar(p)+135)^[0] := pac32(PChar(p)+337)^[0]; pac32(PChar(p)+337)^[0] := num;
 pac32(PChar(p)+401)^[0] := pac32(PChar(p)+401)^[0] xor ror2(pac32(PChar(p)+304)^[0] , 26 );
 num := pac8(PChar(p)+68)^[0]; pac8(PChar(p)+68)^[0] := pac8(PChar(p)+129)^[0]; pac8(PChar(p)+129)^[0] := num;
 pac64(PChar(p)+454)^[0] := pac64(PChar(p)+454)^[0] xor (pac64(PChar(p)+442)^[0] or $c03e0856);
 num := pac8(PChar(p)+218)^[0]; pac8(PChar(p)+218)^[0] := pac8(PChar(p)+494)^[0]; pac8(PChar(p)+494)^[0] := num;
 pac8(PChar(p)+491)^[0] := pac8(PChar(p)+491)^[0] xor ror1(pac8(PChar(p)+269)^[0] , 3 );
 pac8(PChar(p)+256)^[0] := pac8(PChar(p)+256)^[0] xor (pac8(PChar(p)+110)^[0] + $a0);
 num := pac8(PChar(p)+395)^[0]; pac8(PChar(p)+395)^[0] := pac8(PChar(p)+208)^[0]; pac8(PChar(p)+208)^[0] := num;

 if pac8(PChar(p)+58)^[0] < pac8(PChar(p)+260)^[0] then begin
   pac16(PChar(p)+93)^[0] := pac16(PChar(p)+93)^[0] + ror2(pac16(PChar(p)+323)^[0] , 10 );
   pac64(PChar(p)+392)^[0] := pac64(PChar(p)+70)^[0] + (pac64(PChar(p)+6)^[0] xor $f0c47dd13dd3);
   pac32(PChar(p)+462)^[0] := pac32(PChar(p)+462)^[0] + (pac32(PChar(p)+416)^[0] or $b0a9);
 end;

 pac64(PChar(p)+440)^[0] := pac64(PChar(p)+440)^[0] or (pac64(PChar(p)+130)^[0] or $503ffc92);
 pac32(PChar(p)+51)^[0] := ror2(pac32(PChar(p)+385)^[0] , 10 );
 pac64(PChar(p)+245)^[0] := pac64(PChar(p)+245)^[0] or $10f72fc2;
 pac16(PChar(p)+218)^[0] := pac16(PChar(p)+218)^[0] xor ror2(pac16(PChar(p)+63)^[0] , 3 );
 if pac64(PChar(p)+320)^[0] < pac64(PChar(p)+243)^[0] then pac32(PChar(p)+388)^[0] := pac32(PChar(p)+388)^[0] or (pac32(PChar(p)+295)^[0] + $904a28);
 if pac16(PChar(p)+504)^[0] > pac16(PChar(p)+89)^[0] then begin  num := pac8(PChar(p)+352)^[0]; pac8(PChar(p)+352)^[0] := pac8(PChar(p)+504)^[0]; pac8(PChar(p)+504)^[0] := num; end;
 if pac16(PChar(p)+405)^[0] < pac16(PChar(p)+497)^[0] then begin  num := pac16(PChar(p)+286)^[0]; pac16(PChar(p)+286)^[0] := pac16(PChar(p)+358)^[0]; pac16(PChar(p)+358)^[0] := num; end else pac32(PChar(p)+317)^[0] := pac32(PChar(p)+317)^[0] xor $2009;

D469B9D0(p);

end;

procedure D469B9D0(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+20)^[0] := pac16(PChar(p)+20)^[0] or rol1(pac16(PChar(p)+188)^[0] , 3 );
 if pac8(PChar(p)+343)^[0] < pac8(PChar(p)+290)^[0] then pac32(PChar(p)+387)^[0] := pac32(PChar(p)+387)^[0] or (pac32(PChar(p)+170)^[0] xor $40cf43);
 pac16(PChar(p)+322)^[0] := pac16(PChar(p)+322)^[0] or ror2(pac16(PChar(p)+117)^[0] , 15 );

 if pac32(PChar(p)+446)^[0] > pac32(PChar(p)+183)^[0] then begin
   pac8(PChar(p)+490)^[0] := pac8(PChar(p)+490)^[0] or $0b;
   num := pac8(PChar(p)+258)^[0]; pac8(PChar(p)+258)^[0] := pac8(PChar(p)+298)^[0]; pac8(PChar(p)+298)^[0] := num;
   num := pac32(PChar(p)+18)^[0]; pac32(PChar(p)+18)^[0] := pac32(PChar(p)+285)^[0]; pac32(PChar(p)+285)^[0] := num;
   num := pac8(PChar(p)+155)^[0]; pac8(PChar(p)+155)^[0] := pac8(PChar(p)+319)^[0]; pac8(PChar(p)+319)^[0] := num;
 end;


 if pac64(PChar(p)+481)^[0] > pac64(PChar(p)+310)^[0] then begin
   if pac64(PChar(p)+241)^[0] > pac64(PChar(p)+128)^[0] then pac16(PChar(p)+492)^[0] := pac16(PChar(p)+345)^[0] + $e0 else begin  num := pac8(PChar(p)+69)^[0]; pac8(PChar(p)+69)^[0] := pac8(PChar(p)+177)^[0]; pac8(PChar(p)+177)^[0] := num; end;
   pac8(PChar(p)+12)^[0] := pac8(PChar(p)+12)^[0] + rol1(pac8(PChar(p)+135)^[0] , 6 );
   pac64(PChar(p)+206)^[0] := pac64(PChar(p)+206)^[0] + $f007eac8d2;
 end;


 if pac64(PChar(p)+343)^[0] > pac64(PChar(p)+349)^[0] then begin
   pac32(PChar(p)+314)^[0] := pac32(PChar(p)+314)^[0] or (pac32(PChar(p)+35)^[0] or $409f);
   pac32(PChar(p)+216)^[0] := pac32(PChar(p)+216)^[0] or (pac32(PChar(p)+168)^[0] + $90f87a);
   num := pac16(PChar(p)+71)^[0]; pac16(PChar(p)+71)^[0] := pac16(PChar(p)+97)^[0]; pac16(PChar(p)+97)^[0] := num;
   num := pac16(PChar(p)+244)^[0]; pac16(PChar(p)+244)^[0] := pac16(PChar(p)+47)^[0]; pac16(PChar(p)+47)^[0] := num;
 end;

 pac32(PChar(p)+350)^[0] := pac32(PChar(p)+350)^[0] or ror2(pac32(PChar(p)+351)^[0] , 19 );
 if pac8(PChar(p)+3)^[0] < pac8(PChar(p)+433)^[0] then pac32(PChar(p)+41)^[0] := pac32(PChar(p)+307)^[0] xor (pac32(PChar(p)+196)^[0] xor $c097) else pac16(PChar(p)+241)^[0] := pac16(PChar(p)+241)^[0] or $a0;
 pac64(PChar(p)+436)^[0] := pac64(PChar(p)+436)^[0] - $40599dbe;
 pac16(PChar(p)+200)^[0] := pac16(PChar(p)+200)^[0] + ror1(pac16(PChar(p)+256)^[0] , 2 );
 pac8(PChar(p)+418)^[0] := ror1(pac8(PChar(p)+117)^[0] , 4 );
 pac32(PChar(p)+16)^[0] := pac32(PChar(p)+16)^[0] xor ror2(pac32(PChar(p)+276)^[0] , 21 );
 num := pac8(PChar(p)+121)^[0]; pac8(PChar(p)+121)^[0] := pac8(PChar(p)+402)^[0]; pac8(PChar(p)+402)^[0] := num;

 if pac16(PChar(p)+505)^[0] < pac16(PChar(p)+322)^[0] then begin
   num := pac16(PChar(p)+139)^[0]; pac16(PChar(p)+139)^[0] := pac16(PChar(p)+224)^[0]; pac16(PChar(p)+224)^[0] := num;
   pac8(PChar(p)+100)^[0] := pac8(PChar(p)+100)^[0] xor ror2(pac8(PChar(p)+345)^[0] , 1 );
 end;

 pac8(PChar(p)+265)^[0] := pac8(PChar(p)+265)^[0] + ror2(pac8(PChar(p)+74)^[0] , 7 );

 if pac64(PChar(p)+289)^[0] < pac64(PChar(p)+437)^[0] then begin
   pac16(PChar(p)+147)^[0] := pac16(PChar(p)+147)^[0] + (pac16(PChar(p)+18)^[0] - $f0);
   if pac64(PChar(p)+106)^[0] < pac64(PChar(p)+303)^[0] then pac64(PChar(p)+258)^[0] := pac64(PChar(p)+258)^[0] or (pac64(PChar(p)+58)^[0] xor $00404d8ed03e) else pac32(PChar(p)+201)^[0] := pac32(PChar(p)+201)^[0] - $608518;
 end;


 if pac64(PChar(p)+132)^[0] > pac64(PChar(p)+238)^[0] then begin
   pac64(PChar(p)+306)^[0] := pac64(PChar(p)+306)^[0] - $e0ed7895ee;
   if pac32(PChar(p)+77)^[0] < pac32(PChar(p)+330)^[0] then pac64(PChar(p)+163)^[0] := pac64(PChar(p)+163)^[0] - $702c68f9 else pac8(PChar(p)+66)^[0] := pac8(PChar(p)+66)^[0] xor $d0;
   pac8(PChar(p)+54)^[0] := pac8(PChar(p)+54)^[0] or (pac8(PChar(p)+122)^[0] xor $80);
 end;


D3507FD5(p);

end;

procedure D3507FD5(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+212)^[0] < pac32(PChar(p)+266)^[0] then pac32(PChar(p)+485)^[0] := pac32(PChar(p)+485)^[0] - (pac32(PChar(p)+337)^[0] + $60e092) else begin  num := pac32(PChar(p)+48)^[0]; pac32(PChar(p)+48)^[0] := pac32(PChar(p)+435)^[0]; pac32(PChar(p)+435)^[0] := num; end;
 pac8(PChar(p)+378)^[0] := rol1(pac8(PChar(p)+296)^[0] , 5 );
 pac32(PChar(p)+83)^[0] := pac32(PChar(p)+83)^[0] xor rol1(pac32(PChar(p)+156)^[0] , 1 );
 pac32(PChar(p)+5)^[0] := pac32(PChar(p)+5)^[0] - ror2(pac32(PChar(p)+441)^[0] , 22 );
 pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] + $a075;
 pac16(PChar(p)+467)^[0] := pac16(PChar(p)+467)^[0] or ror2(pac16(PChar(p)+206)^[0] , 4 );
 pac64(PChar(p)+395)^[0] := pac64(PChar(p)+395)^[0] - (pac64(PChar(p)+26)^[0] or $b09ff62613);
 num := pac32(PChar(p)+388)^[0]; pac32(PChar(p)+388)^[0] := pac32(PChar(p)+193)^[0]; pac32(PChar(p)+193)^[0] := num;
 num := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := pac16(PChar(p)+388)^[0]; pac16(PChar(p)+388)^[0] := num;
 if pac64(PChar(p)+329)^[0] > pac64(PChar(p)+155)^[0] then pac32(PChar(p)+46)^[0] := pac32(PChar(p)+46)^[0] + ror2(pac32(PChar(p)+115)^[0] , 24 ) else begin  num := pac8(PChar(p)+26)^[0]; pac8(PChar(p)+26)^[0] := pac8(PChar(p)+433)^[0]; pac8(PChar(p)+433)^[0] := num; end;
 num := pac8(PChar(p)+30)^[0]; pac8(PChar(p)+30)^[0] := pac8(PChar(p)+467)^[0]; pac8(PChar(p)+467)^[0] := num;
 pac16(PChar(p)+132)^[0] := pac16(PChar(p)+132)^[0] xor ror2(pac16(PChar(p)+131)^[0] , 4 );
 pac64(PChar(p)+327)^[0] := pac64(PChar(p)+327)^[0] + $209945c4;
 pac32(PChar(p)+145)^[0] := pac32(PChar(p)+371)^[0] xor (pac32(PChar(p)+458)^[0] xor $e00759);
 pac32(PChar(p)+87)^[0] := pac32(PChar(p)+87)^[0] + (pac32(PChar(p)+128)^[0] or $4006);

 if pac8(PChar(p)+418)^[0] < pac8(PChar(p)+497)^[0] then begin
   num := pac16(PChar(p)+32)^[0]; pac16(PChar(p)+32)^[0] := pac16(PChar(p)+472)^[0]; pac16(PChar(p)+472)^[0] := num;
   pac32(PChar(p)+451)^[0] := pac32(PChar(p)+495)^[0] xor (pac32(PChar(p)+121)^[0] or $10ca);
 end;

 pac8(PChar(p)+256)^[0] := pac8(PChar(p)+256)^[0] xor ror2(pac8(PChar(p)+435)^[0] , 6 );
 pac32(PChar(p)+295)^[0] := pac32(PChar(p)+295)^[0] xor (pac32(PChar(p)+434)^[0] - $50a7);
 pac32(PChar(p)+196)^[0] := pac32(PChar(p)+196)^[0] + $e0f8f1;

F67D5993(p);

end;

procedure F67D5993(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+254)^[0] := pac32(PChar(p)+254)^[0] - $a05d;
 if pac64(PChar(p)+166)^[0] < pac64(PChar(p)+202)^[0] then pac32(PChar(p)+110)^[0] := pac32(PChar(p)+110)^[0] - $e087 else pac32(PChar(p)+98)^[0] := pac32(PChar(p)+363)^[0] + $e013;
 pac32(PChar(p)+50)^[0] := pac32(PChar(p)+50)^[0] xor ror2(pac32(PChar(p)+125)^[0] , 12 );
 if pac32(PChar(p)+313)^[0] > pac32(PChar(p)+354)^[0] then pac32(PChar(p)+272)^[0] := pac32(PChar(p)+272)^[0] - (pac32(PChar(p)+361)^[0] - $a01620) else begin  num := pac8(PChar(p)+398)^[0]; pac8(PChar(p)+398)^[0] := pac8(PChar(p)+180)^[0]; pac8(PChar(p)+180)^[0] := num; end;
 pac64(PChar(p)+81)^[0] := pac64(PChar(p)+403)^[0] - $60f2ab8e46c5;
 pac32(PChar(p)+384)^[0] := pac32(PChar(p)+384)^[0] - ror2(pac32(PChar(p)+446)^[0] , 3 );
 if pac8(PChar(p)+446)^[0] > pac8(PChar(p)+505)^[0] then pac32(PChar(p)+440)^[0] := pac32(PChar(p)+440)^[0] + ror1(pac32(PChar(p)+474)^[0] , 23 ) else pac32(PChar(p)+335)^[0] := pac32(PChar(p)+335)^[0] - $f0e581;
 pac64(PChar(p)+275)^[0] := pac64(PChar(p)+275)^[0] or (pac64(PChar(p)+328)^[0] - $1011ac3845c5);

 if pac8(PChar(p)+462)^[0] < pac8(PChar(p)+85)^[0] then begin
   pac8(PChar(p)+102)^[0] := pac8(PChar(p)+102)^[0] - ror1(pac8(PChar(p)+47)^[0] , 5 );
   pac64(PChar(p)+119)^[0] := pac64(PChar(p)+119)^[0] - $5087b6310536;
   if pac16(PChar(p)+490)^[0] < pac16(PChar(p)+443)^[0] then begin  num := pac8(PChar(p)+216)^[0]; pac8(PChar(p)+216)^[0] := pac8(PChar(p)+2)^[0]; pac8(PChar(p)+2)^[0] := num; end else pac8(PChar(p)+243)^[0] := pac8(PChar(p)+243)^[0] or ror2(pac8(PChar(p)+142)^[0] , 6 );
   pac32(PChar(p)+466)^[0] := pac32(PChar(p)+105)^[0] xor $00fd41;
 end;

 if pac64(PChar(p)+415)^[0] > pac64(PChar(p)+304)^[0] then pac32(PChar(p)+222)^[0] := pac32(PChar(p)+222)^[0] or ror1(pac32(PChar(p)+401)^[0] , 3 );
 num := pac16(PChar(p)+12)^[0]; pac16(PChar(p)+12)^[0] := pac16(PChar(p)+241)^[0]; pac16(PChar(p)+241)^[0] := num;
 pac32(PChar(p)+91)^[0] := ror1(pac32(PChar(p)+46)^[0] , 7 );
 num := pac8(PChar(p)+21)^[0]; pac8(PChar(p)+21)^[0] := pac8(PChar(p)+330)^[0]; pac8(PChar(p)+330)^[0] := num;
 pac32(PChar(p)+73)^[0] := pac32(PChar(p)+73)^[0] xor $70fd37;
 pac32(PChar(p)+499)^[0] := pac32(PChar(p)+499)^[0] or ror2(pac32(PChar(p)+186)^[0] , 6 );
 pac64(PChar(p)+258)^[0] := pac64(PChar(p)+349)^[0] + (pac64(PChar(p)+411)^[0] + $005a8d5218);

E57ECE16(p);

end;

procedure E57ECE16(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+45)^[0] := pac16(PChar(p)+45)^[0] or ror2(pac16(PChar(p)+134)^[0] , 8 );

 if pac32(PChar(p)+180)^[0] > pac32(PChar(p)+389)^[0] then begin
   pac32(PChar(p)+333)^[0] := pac32(PChar(p)+333)^[0] - (pac32(PChar(p)+223)^[0] or $607ec2);
   if pac16(PChar(p)+194)^[0] < pac16(PChar(p)+345)^[0] then pac64(PChar(p)+397)^[0] := pac64(PChar(p)+397)^[0] - (pac64(PChar(p)+122)^[0] or $a083f06c) else begin  num := pac32(PChar(p)+496)^[0]; pac32(PChar(p)+496)^[0] := pac32(PChar(p)+389)^[0]; pac32(PChar(p)+389)^[0] := num; end;
   pac32(PChar(p)+210)^[0] := pac32(PChar(p)+210)^[0] - (pac32(PChar(p)+486)^[0] or $6081);
   pac8(PChar(p)+436)^[0] := ror1(pac8(PChar(p)+26)^[0] , 6 );
 end;

 if pac64(PChar(p)+154)^[0] > pac64(PChar(p)+363)^[0] then pac16(PChar(p)+8)^[0] := pac16(PChar(p)+8)^[0] xor ror1(pac16(PChar(p)+93)^[0] , 5 ) else pac8(PChar(p)+118)^[0] := pac8(PChar(p)+118)^[0] + ror2(pac8(PChar(p)+253)^[0] , 4 );
 pac32(PChar(p)+146)^[0] := rol1(pac32(PChar(p)+239)^[0] , 10 );
 if pac16(PChar(p)+410)^[0] > pac16(PChar(p)+29)^[0] then pac32(PChar(p)+283)^[0] := pac32(PChar(p)+283)^[0] + ror2(pac32(PChar(p)+439)^[0] , 10 ) else pac16(PChar(p)+394)^[0] := pac16(PChar(p)+394)^[0] - ror1(pac16(PChar(p)+89)^[0] , 8 );
 pac16(PChar(p)+20)^[0] := pac16(PChar(p)+20)^[0] or rol1(pac16(PChar(p)+289)^[0] , 8 );
 num := pac32(PChar(p)+304)^[0]; pac32(PChar(p)+304)^[0] := pac32(PChar(p)+474)^[0]; pac32(PChar(p)+474)^[0] := num;
 num := pac32(PChar(p)+271)^[0]; pac32(PChar(p)+271)^[0] := pac32(PChar(p)+477)^[0]; pac32(PChar(p)+477)^[0] := num;
 if pac8(PChar(p)+73)^[0] > pac8(PChar(p)+356)^[0] then pac32(PChar(p)+345)^[0] := ror1(pac32(PChar(p)+309)^[0] , 3 ) else pac64(PChar(p)+255)^[0] := pac64(PChar(p)+255)^[0] or $3024fc157f;
 num := pac16(PChar(p)+26)^[0]; pac16(PChar(p)+26)^[0] := pac16(PChar(p)+450)^[0]; pac16(PChar(p)+450)^[0] := num;
 num := pac8(PChar(p)+478)^[0]; pac8(PChar(p)+478)^[0] := pac8(PChar(p)+429)^[0]; pac8(PChar(p)+429)^[0] := num;

 if pac64(PChar(p)+157)^[0] < pac64(PChar(p)+270)^[0] then begin
   pac16(PChar(p)+435)^[0] := pac16(PChar(p)+435)^[0] - rol1(pac16(PChar(p)+273)^[0] , 10 );
   pac8(PChar(p)+249)^[0] := pac8(PChar(p)+249)^[0] - ror2(pac8(PChar(p)+347)^[0] , 1 );
   pac32(PChar(p)+121)^[0] := pac32(PChar(p)+121)^[0] - (pac32(PChar(p)+50)^[0] + $6077aa);
 end;

 if pac8(PChar(p)+346)^[0] < pac8(PChar(p)+450)^[0] then pac32(PChar(p)+14)^[0] := pac32(PChar(p)+14)^[0] xor ror2(pac32(PChar(p)+182)^[0] , 6 );
 pac32(PChar(p)+381)^[0] := pac32(PChar(p)+381)^[0] xor (pac32(PChar(p)+83)^[0] + $c01b7f);
 pac32(PChar(p)+409)^[0] := pac32(PChar(p)+409)^[0] or $30e132;

CBD5777B(p);

end;

procedure CBD5777B(p: Pointer);
var num: Int64;
begin


 if pac16(PChar(p)+5)^[0] > pac16(PChar(p)+80)^[0] then begin
   pac32(PChar(p)+106)^[0] := rol1(pac32(PChar(p)+417)^[0] , 16 );
   if pac32(PChar(p)+355)^[0] > pac32(PChar(p)+21)^[0] then begin  num := pac32(PChar(p)+19)^[0]; pac32(PChar(p)+19)^[0] := pac32(PChar(p)+217)^[0]; pac32(PChar(p)+217)^[0] := num; end else pac64(PChar(p)+356)^[0] := pac64(PChar(p)+356)^[0] + $10a54eeb816c;
 end;

 num := pac32(PChar(p)+288)^[0]; pac32(PChar(p)+288)^[0] := pac32(PChar(p)+136)^[0]; pac32(PChar(p)+136)^[0] := num;
 num := pac16(PChar(p)+93)^[0]; pac16(PChar(p)+93)^[0] := pac16(PChar(p)+422)^[0]; pac16(PChar(p)+422)^[0] := num;
 pac16(PChar(p)+157)^[0] := pac16(PChar(p)+157)^[0] - $80;

 if pac8(PChar(p)+430)^[0] < pac8(PChar(p)+397)^[0] then begin
   pac32(PChar(p)+229)^[0] := pac32(PChar(p)+118)^[0] - $c081;
   pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] or $b0ab;
   pac32(PChar(p)+204)^[0] := pac32(PChar(p)+204)^[0] xor (pac32(PChar(p)+307)^[0] or $e0b4);
   pac8(PChar(p)+233)^[0] := pac8(PChar(p)+233)^[0] - $a0;
   if pac8(PChar(p)+31)^[0] < pac8(PChar(p)+509)^[0] then pac64(PChar(p)+132)^[0] := pac64(PChar(p)+132)^[0] xor $f0939096 else pac8(PChar(p)+35)^[0] := pac8(PChar(p)+35)^[0] xor (pac8(PChar(p)+432)^[0] xor $d0);
 end;

 num := pac32(PChar(p)+65)^[0]; pac32(PChar(p)+65)^[0] := pac32(PChar(p)+418)^[0]; pac32(PChar(p)+418)^[0] := num;

 if pac16(PChar(p)+143)^[0] < pac16(PChar(p)+84)^[0] then begin
   pac32(PChar(p)+308)^[0] := pac32(PChar(p)+308)^[0] - $80f8;
   pac8(PChar(p)+409)^[0] := pac8(PChar(p)+409)^[0] + ror2(pac8(PChar(p)+84)^[0] , 1 );
   pac64(PChar(p)+366)^[0] := pac64(PChar(p)+366)^[0] - (pac64(PChar(p)+454)^[0] + $b01423575c);
   pac32(PChar(p)+99)^[0] := pac32(PChar(p)+99)^[0] - $607b;
 end;

 num := pac32(PChar(p)+406)^[0]; pac32(PChar(p)+406)^[0] := pac32(PChar(p)+381)^[0]; pac32(PChar(p)+381)^[0] := num;
 num := pac8(PChar(p)+88)^[0]; pac8(PChar(p)+88)^[0] := pac8(PChar(p)+92)^[0]; pac8(PChar(p)+92)^[0] := num;

 if pac64(PChar(p)+177)^[0] < pac64(PChar(p)+164)^[0] then begin
   pac8(PChar(p)+74)^[0] := pac8(PChar(p)+74)^[0] + (pac8(PChar(p)+352)^[0] + $80);
   pac16(PChar(p)+474)^[0] := pac16(PChar(p)+474)^[0] - ror2(pac16(PChar(p)+360)^[0] , 14 );
 end;

 num := pac8(PChar(p)+372)^[0]; pac8(PChar(p)+372)^[0] := pac8(PChar(p)+81)^[0]; pac8(PChar(p)+81)^[0] := num;

 if pac32(PChar(p)+67)^[0] < pac32(PChar(p)+58)^[0] then begin
   num := pac8(PChar(p)+192)^[0]; pac8(PChar(p)+192)^[0] := pac8(PChar(p)+71)^[0]; pac8(PChar(p)+71)^[0] := num;
   pac16(PChar(p)+79)^[0] := pac16(PChar(p)+79)^[0] - rol1(pac16(PChar(p)+363)^[0] , 4 );
   pac8(PChar(p)+138)^[0] := pac8(PChar(p)+475)^[0] or (pac8(PChar(p)+142)^[0] or $90);
 end;

 pac32(PChar(p)+32)^[0] := pac32(PChar(p)+32)^[0] - rol1(pac32(PChar(p)+73)^[0] , 26 );

C1019B4F(p);

end;

procedure C1019B4F(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+172)^[0] < pac32(PChar(p)+120)^[0] then begin
   pac16(PChar(p)+178)^[0] := rol1(pac16(PChar(p)+441)^[0] , 11 );
   pac32(PChar(p)+4)^[0] := pac32(PChar(p)+4)^[0] + $70cd;
   num := pac8(PChar(p)+100)^[0]; pac8(PChar(p)+100)^[0] := pac8(PChar(p)+141)^[0]; pac8(PChar(p)+141)^[0] := num;
 end;

 if pac16(PChar(p)+159)^[0] > pac16(PChar(p)+484)^[0] then begin  num := pac16(PChar(p)+389)^[0]; pac16(PChar(p)+389)^[0] := pac16(PChar(p)+419)^[0]; pac16(PChar(p)+419)^[0] := num; end else pac32(PChar(p)+316)^[0] := pac32(PChar(p)+316)^[0] xor $602f;
 pac64(PChar(p)+426)^[0] := pac64(PChar(p)+442)^[0] xor (pac64(PChar(p)+318)^[0] xor $304ac67ad9);
 num := pac16(PChar(p)+451)^[0]; pac16(PChar(p)+451)^[0] := pac16(PChar(p)+299)^[0]; pac16(PChar(p)+299)^[0] := num;
 num := pac16(PChar(p)+3)^[0]; pac16(PChar(p)+3)^[0] := pac16(PChar(p)+101)^[0]; pac16(PChar(p)+101)^[0] := num;
 if pac8(PChar(p)+363)^[0] > pac8(PChar(p)+156)^[0] then pac64(PChar(p)+61)^[0] := pac64(PChar(p)+61)^[0] or (pac64(PChar(p)+215)^[0] + $c06f8a35) else pac32(PChar(p)+386)^[0] := pac32(PChar(p)+386)^[0] + (pac32(PChar(p)+165)^[0] - $805cfd);
 pac8(PChar(p)+30)^[0] := pac8(PChar(p)+30)^[0] + (pac8(PChar(p)+253)^[0] xor $50);

 if pac8(PChar(p)+363)^[0] > pac8(PChar(p)+139)^[0] then begin
   pac8(PChar(p)+18)^[0] := pac8(PChar(p)+18)^[0] - $1f;
   num := pac32(PChar(p)+490)^[0]; pac32(PChar(p)+490)^[0] := pac32(PChar(p)+70)^[0]; pac32(PChar(p)+70)^[0] := num;
   pac32(PChar(p)+171)^[0] := pac32(PChar(p)+171)^[0] - $6015;
 end;

 pac64(PChar(p)+361)^[0] := pac64(PChar(p)+361)^[0] or (pac64(PChar(p)+277)^[0] + $40307de568);

 if pac8(PChar(p)+4)^[0] < pac8(PChar(p)+159)^[0] then begin
   pac32(PChar(p)+94)^[0] := pac32(PChar(p)+94)^[0] + $b0ed;
   pac8(PChar(p)+82)^[0] := pac8(PChar(p)+82)^[0] + (pac8(PChar(p)+363)^[0] xor $e0);
   if pac8(PChar(p)+371)^[0] > pac8(PChar(p)+310)^[0] then pac64(PChar(p)+488)^[0] := pac64(PChar(p)+488)^[0] - (pac64(PChar(p)+491)^[0] or $b045cceb) else begin  num := pac16(PChar(p)+247)^[0]; pac16(PChar(p)+247)^[0] := pac16(PChar(p)+290)^[0]; pac16(PChar(p)+290)^[0] := num; end;
 end;

 pac64(PChar(p)+25)^[0] := pac64(PChar(p)+25)^[0] + $903ee899e96b;
 if pac16(PChar(p)+463)^[0] > pac16(PChar(p)+133)^[0] then begin  num := pac16(PChar(p)+491)^[0]; pac16(PChar(p)+491)^[0] := pac16(PChar(p)+271)^[0]; pac16(PChar(p)+271)^[0] := num; end;

 if pac16(PChar(p)+120)^[0] < pac16(PChar(p)+264)^[0] then begin
   pac64(PChar(p)+295)^[0] := pac64(PChar(p)+295)^[0] + (pac64(PChar(p)+237)^[0] xor $00db11ebe166);
   pac16(PChar(p)+46)^[0] := pac16(PChar(p)+46)^[0] + ror2(pac16(PChar(p)+68)^[0] , 6 );
   num := pac16(PChar(p)+167)^[0]; pac16(PChar(p)+167)^[0] := pac16(PChar(p)+487)^[0]; pac16(PChar(p)+487)^[0] := num;
   if pac32(PChar(p)+455)^[0] < pac32(PChar(p)+497)^[0] then pac32(PChar(p)+344)^[0] := pac32(PChar(p)+344)^[0] xor ror1(pac32(PChar(p)+49)^[0] , 5 ) else pac32(PChar(p)+122)^[0] := pac32(PChar(p)+122)^[0] or (pac32(PChar(p)+267)^[0] + $e0acbc);
 end;

 pac32(PChar(p)+58)^[0] := pac32(PChar(p)+58)^[0] + (pac32(PChar(p)+351)^[0] + $00c4b7);
 num := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := pac32(PChar(p)+188)^[0]; pac32(PChar(p)+188)^[0] := num;
 pac16(PChar(p)+87)^[0] := ror1(pac16(PChar(p)+252)^[0] , 7 );
 num := pac8(PChar(p)+143)^[0]; pac8(PChar(p)+143)^[0] := pac8(PChar(p)+486)^[0]; pac8(PChar(p)+486)^[0] := num;
 pac16(PChar(p)+440)^[0] := pac16(PChar(p)+440)^[0] + rol1(pac16(PChar(p)+365)^[0] , 12 );

 if pac8(PChar(p)+348)^[0] > pac8(PChar(p)+363)^[0] then begin
   if pac64(PChar(p)+341)^[0] < pac64(PChar(p)+352)^[0] then pac32(PChar(p)+266)^[0] := pac32(PChar(p)+266)^[0] - (pac32(PChar(p)+148)^[0] xor $40e886) else pac16(PChar(p)+82)^[0] := pac16(PChar(p)+82)^[0] xor (pac16(PChar(p)+97)^[0] or $50);
   pac8(PChar(p)+409)^[0] := pac8(PChar(p)+409)^[0] + $10;
   pac32(PChar(p)+182)^[0] := pac32(PChar(p)+182)^[0] xor (pac32(PChar(p)+456)^[0] xor $103a);
   if pac8(PChar(p)+233)^[0] < pac8(PChar(p)+292)^[0] then pac8(PChar(p)+374)^[0] := pac8(PChar(p)+374)^[0] + ror2(pac8(PChar(p)+337)^[0] , 5 );
   num := pac8(PChar(p)+63)^[0]; pac8(PChar(p)+63)^[0] := pac8(PChar(p)+171)^[0]; pac8(PChar(p)+171)^[0] := num;
 end;


FEBB6B79(p);

end;

procedure FEBB6B79(p: Pointer);
var num: Int64;
begin

 num := pac8(PChar(p)+499)^[0]; pac8(PChar(p)+499)^[0] := pac8(PChar(p)+430)^[0]; pac8(PChar(p)+430)^[0] := num;

 if pac32(PChar(p)+230)^[0] < pac32(PChar(p)+463)^[0] then begin
   pac32(PChar(p)+19)^[0] := ror1(pac32(PChar(p)+142)^[0] , 3 );
   num := pac16(PChar(p)+203)^[0]; pac16(PChar(p)+203)^[0] := pac16(PChar(p)+80)^[0]; pac16(PChar(p)+80)^[0] := num;
   pac64(PChar(p)+497)^[0] := pac64(PChar(p)+497)^[0] + $a0f51eb6;
   if pac16(PChar(p)+184)^[0] < pac16(PChar(p)+13)^[0] then pac16(PChar(p)+145)^[0] := pac16(PChar(p)+145)^[0] - $f0 else pac64(PChar(p)+6)^[0] := pac64(PChar(p)+6)^[0] - (pac64(PChar(p)+294)^[0] - $8079d6d90a);
   pac16(PChar(p)+33)^[0] := pac16(PChar(p)+33)^[0] + ror2(pac16(PChar(p)+286)^[0] , 6 );
 end;

 pac16(PChar(p)+354)^[0] := pac16(PChar(p)+354)^[0] or (pac16(PChar(p)+6)^[0] xor $c0);
 pac32(PChar(p)+340)^[0] := pac32(PChar(p)+340)^[0] + (pac32(PChar(p)+325)^[0] + $b04daf);
 pac32(PChar(p)+497)^[0] := pac32(PChar(p)+497)^[0] xor ror2(pac32(PChar(p)+453)^[0] , 30 );

 if pac8(PChar(p)+310)^[0] > pac8(PChar(p)+133)^[0] then begin
   pac32(PChar(p)+315)^[0] := pac32(PChar(p)+315)^[0] xor (pac32(PChar(p)+454)^[0] or $50da79);
   num := pac32(PChar(p)+164)^[0]; pac32(PChar(p)+164)^[0] := pac32(PChar(p)+454)^[0]; pac32(PChar(p)+454)^[0] := num;
 end;

 pac32(PChar(p)+128)^[0] := pac32(PChar(p)+128)^[0] + ror1(pac32(PChar(p)+39)^[0] , 2 );
 num := pac32(PChar(p)+379)^[0]; pac32(PChar(p)+379)^[0] := pac32(PChar(p)+407)^[0]; pac32(PChar(p)+407)^[0] := num;
 pac64(PChar(p)+184)^[0] := pac64(PChar(p)+46)^[0] + $006e3fc8;

 if pac16(PChar(p)+129)^[0] > pac16(PChar(p)+350)^[0] then begin
   pac16(PChar(p)+109)^[0] := pac16(PChar(p)+109)^[0] - ror2(pac16(PChar(p)+300)^[0] , 7 );
   pac64(PChar(p)+160)^[0] := pac64(PChar(p)+160)^[0] xor (pac64(PChar(p)+241)^[0] - $207f128b32);
   num := pac8(PChar(p)+407)^[0]; pac8(PChar(p)+407)^[0] := pac8(PChar(p)+49)^[0]; pac8(PChar(p)+49)^[0] := num;
 end;

 pac64(PChar(p)+430)^[0] := pac64(PChar(p)+430)^[0] or (pac64(PChar(p)+461)^[0] + $50ecf4f9);
 num := pac16(PChar(p)+472)^[0]; pac16(PChar(p)+472)^[0] := pac16(PChar(p)+318)^[0]; pac16(PChar(p)+318)^[0] := num;

 if pac64(PChar(p)+432)^[0] < pac64(PChar(p)+48)^[0] then begin
   pac8(PChar(p)+174)^[0] := rol1(pac8(PChar(p)+118)^[0] , 2 );
   pac32(PChar(p)+175)^[0] := pac32(PChar(p)+175)^[0] xor rol1(pac32(PChar(p)+65)^[0] , 8 );
   pac32(PChar(p)+138)^[0] := pac32(PChar(p)+138)^[0] xor $20c8;
 end;

 pac64(PChar(p)+289)^[0] := pac64(PChar(p)+289)^[0] or $70ad1dcaf667;
 pac16(PChar(p)+234)^[0] := pac16(PChar(p)+439)^[0] + $50;

C7523873(p);

end;

procedure C7523873(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+14)^[0] := pac64(PChar(p)+14)^[0] - (pac64(PChar(p)+305)^[0] or $e09913ba45);
 if pac8(PChar(p)+295)^[0] > pac8(PChar(p)+61)^[0] then begin  num := pac16(PChar(p)+158)^[0]; pac16(PChar(p)+158)^[0] := pac16(PChar(p)+29)^[0]; pac16(PChar(p)+29)^[0] := num; end else pac32(PChar(p)+367)^[0] := pac32(PChar(p)+367)^[0] or ror2(pac32(PChar(p)+458)^[0] , 12 );
 pac16(PChar(p)+505)^[0] := ror1(pac16(PChar(p)+149)^[0] , 6 );
 num := pac16(PChar(p)+364)^[0]; pac16(PChar(p)+364)^[0] := pac16(PChar(p)+463)^[0]; pac16(PChar(p)+463)^[0] := num;
 pac32(PChar(p)+473)^[0] := pac32(PChar(p)+473)^[0] xor (pac32(PChar(p)+58)^[0] - $204b);
 pac8(PChar(p)+190)^[0] := pac8(PChar(p)+190)^[0] or ror2(pac8(PChar(p)+324)^[0] , 1 );
 pac16(PChar(p)+99)^[0] := pac16(PChar(p)+99)^[0] xor $a0;
 num := pac32(PChar(p)+40)^[0]; pac32(PChar(p)+40)^[0] := pac32(PChar(p)+390)^[0]; pac32(PChar(p)+390)^[0] := num;
 pac8(PChar(p)+493)^[0] := pac8(PChar(p)+493)^[0] or ror2(pac8(PChar(p)+253)^[0] , 6 );

 if pac64(PChar(p)+498)^[0] > pac64(PChar(p)+294)^[0] then begin
   num := pac16(PChar(p)+58)^[0]; pac16(PChar(p)+58)^[0] := pac16(PChar(p)+470)^[0]; pac16(PChar(p)+470)^[0] := num;
   pac64(PChar(p)+310)^[0] := pac64(PChar(p)+310)^[0] xor $b0be815190;
   num := pac32(PChar(p)+237)^[0]; pac32(PChar(p)+237)^[0] := pac32(PChar(p)+222)^[0]; pac32(PChar(p)+222)^[0] := num;
   pac8(PChar(p)+340)^[0] := pac8(PChar(p)+340)^[0] xor rol1(pac8(PChar(p)+209)^[0] , 3 );
 end;


BFE643C7(p);

end;

procedure BFE643C7(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+492)^[0] > pac8(PChar(p)+158)^[0] then pac32(PChar(p)+501)^[0] := pac32(PChar(p)+501)^[0] + $304997 else begin  num := pac16(PChar(p)+105)^[0]; pac16(PChar(p)+105)^[0] := pac16(PChar(p)+377)^[0]; pac16(PChar(p)+377)^[0] := num; end;
 if pac8(PChar(p)+420)^[0] < pac8(PChar(p)+219)^[0] then pac32(PChar(p)+83)^[0] := pac32(PChar(p)+83)^[0] xor ror1(pac32(PChar(p)+225)^[0] , 13 ) else pac64(PChar(p)+86)^[0] := pac64(PChar(p)+86)^[0] + (pac64(PChar(p)+357)^[0] or $f061b6e488);

 if pac32(PChar(p)+454)^[0] > pac32(PChar(p)+74)^[0] then begin
   if pac64(PChar(p)+50)^[0] > pac64(PChar(p)+204)^[0] then pac8(PChar(p)+9)^[0] := pac8(PChar(p)+9)^[0] - rol1(pac8(PChar(p)+408)^[0] , 2 ) else pac64(PChar(p)+265)^[0] := pac64(PChar(p)+265)^[0] xor $40f5b062;
   pac32(PChar(p)+123)^[0] := pac32(PChar(p)+123)^[0] - (pac32(PChar(p)+295)^[0] xor $80a8c4);
 end;


 if pac64(PChar(p)+376)^[0] < pac64(PChar(p)+204)^[0] then begin
   pac64(PChar(p)+58)^[0] := pac64(PChar(p)+58)^[0] xor $2017c008;
   pac32(PChar(p)+383)^[0] := pac32(PChar(p)+83)^[0] or (pac32(PChar(p)+327)^[0] xor $e05148);
 end;

 num := pac8(PChar(p)+294)^[0]; pac8(PChar(p)+294)^[0] := pac8(PChar(p)+478)^[0]; pac8(PChar(p)+478)^[0] := num;
 pac8(PChar(p)+447)^[0] := pac8(PChar(p)+447)^[0] - $a0;
 pac32(PChar(p)+55)^[0] := pac32(PChar(p)+55)^[0] or ror2(pac32(PChar(p)+432)^[0] , 12 );
 pac64(PChar(p)+291)^[0] := pac64(PChar(p)+291)^[0] + $60aa5796;
 pac64(PChar(p)+23)^[0] := pac64(PChar(p)+23)^[0] xor (pac64(PChar(p)+301)^[0] - $5036bad1c2ca);

 if pac64(PChar(p)+124)^[0] < pac64(PChar(p)+269)^[0] then begin
   pac8(PChar(p)+91)^[0] := pac8(PChar(p)+91)^[0] - $90;
   pac32(PChar(p)+334)^[0] := rol1(pac32(PChar(p)+164)^[0] , 16 );
 end;

 if pac32(PChar(p)+34)^[0] < pac32(PChar(p)+273)^[0] then pac8(PChar(p)+289)^[0] := pac8(PChar(p)+289)^[0] - rol1(pac8(PChar(p)+387)^[0] , 1 );
 pac8(PChar(p)+426)^[0] := pac8(PChar(p)+426)^[0] or ror2(pac8(PChar(p)+75)^[0] , 1 );
 num := pac32(PChar(p)+74)^[0]; pac32(PChar(p)+74)^[0] := pac32(PChar(p)+179)^[0]; pac32(PChar(p)+179)^[0] := num;
 if pac16(PChar(p)+216)^[0] > pac16(PChar(p)+120)^[0] then pac64(PChar(p)+436)^[0] := pac64(PChar(p)+436)^[0] or $a02f3a43df82;
 num := pac16(PChar(p)+269)^[0]; pac16(PChar(p)+269)^[0] := pac16(PChar(p)+435)^[0]; pac16(PChar(p)+435)^[0] := num;

 if pac8(PChar(p)+215)^[0] < pac8(PChar(p)+155)^[0] then begin
   pac32(PChar(p)+30)^[0] := pac32(PChar(p)+30)^[0] or rol1(pac32(PChar(p)+77)^[0] , 12 );
   pac64(PChar(p)+150)^[0] := pac64(PChar(p)+150)^[0] or $90bf65f91f;
   pac8(PChar(p)+392)^[0] := pac8(PChar(p)+392)^[0] - $60;
   pac8(PChar(p)+379)^[0] := pac8(PChar(p)+379)^[0] or (pac8(PChar(p)+479)^[0] xor $70);
 end;


 if pac64(PChar(p)+197)^[0] > pac64(PChar(p)+226)^[0] then begin
   pac64(PChar(p)+146)^[0] := pac64(PChar(p)+146)^[0] - (pac64(PChar(p)+282)^[0] xor $00330a6d);
   pac32(PChar(p)+89)^[0] := pac32(PChar(p)+89)^[0] or $a0f3;
 end;

 if pac16(PChar(p)+73)^[0] > pac16(PChar(p)+276)^[0] then pac8(PChar(p)+507)^[0] := pac8(PChar(p)+507)^[0] or ror2(pac8(PChar(p)+496)^[0] , 2 ) else pac16(PChar(p)+144)^[0] := pac16(PChar(p)+144)^[0] + (pac16(PChar(p)+175)^[0] - $70);
 pac8(PChar(p)+269)^[0] := pac8(PChar(p)+269)^[0] or rol1(pac8(PChar(p)+384)^[0] , 2 );

DD69EF27(p);

end;

procedure DD69EF27(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+491)^[0] < pac32(PChar(p)+58)^[0] then begin  num := pac32(PChar(p)+205)^[0]; pac32(PChar(p)+205)^[0] := pac32(PChar(p)+36)^[0]; pac32(PChar(p)+36)^[0] := num; end else pac16(PChar(p)+352)^[0] := pac16(PChar(p)+352)^[0] xor $10;
 pac64(PChar(p)+80)^[0] := pac64(PChar(p)+80)^[0] xor (pac64(PChar(p)+55)^[0] xor $e069b91835);

 if pac32(PChar(p)+287)^[0] < pac32(PChar(p)+501)^[0] then begin
   num := pac8(PChar(p)+508)^[0]; pac8(PChar(p)+508)^[0] := pac8(PChar(p)+59)^[0]; pac8(PChar(p)+59)^[0] := num;
   pac8(PChar(p)+402)^[0] := pac8(PChar(p)+402)^[0] - (pac8(PChar(p)+421)^[0] - $20);
 end;

 pac8(PChar(p)+17)^[0] := pac8(PChar(p)+17)^[0] or ror1(pac8(PChar(p)+297)^[0] , 3 );
 pac64(PChar(p)+365)^[0] := pac64(PChar(p)+365)^[0] or $90e9aa409c;
 if pac64(PChar(p)+428)^[0] < pac64(PChar(p)+408)^[0] then begin  num := pac16(PChar(p)+489)^[0]; pac16(PChar(p)+489)^[0] := pac16(PChar(p)+350)^[0]; pac16(PChar(p)+350)^[0] := num; end else begin  num := pac8(PChar(p)+356)^[0]; pac8(PChar(p)+356)^[0] := pac8(PChar(p)+16)^[0]; pac8(PChar(p)+16)^[0] := num; end;

 if pac64(PChar(p)+128)^[0] > pac64(PChar(p)+391)^[0] then begin
   if pac8(PChar(p)+29)^[0] < pac8(PChar(p)+47)^[0] then pac64(PChar(p)+210)^[0] := pac64(PChar(p)+210)^[0] xor $905f33b530;
   pac8(PChar(p)+325)^[0] := pac8(PChar(p)+325)^[0] - ror2(pac8(PChar(p)+68)^[0] , 3 );
 end;

 pac16(PChar(p)+9)^[0] := pac16(PChar(p)+129)^[0] xor (pac16(PChar(p)+431)^[0] xor $20);

 if pac16(PChar(p)+386)^[0] < pac16(PChar(p)+299)^[0] then begin
   pac8(PChar(p)+331)^[0] := ror2(pac8(PChar(p)+422)^[0] , 3 );
   pac32(PChar(p)+70)^[0] := pac32(PChar(p)+70)^[0] + (pac32(PChar(p)+235)^[0] xor $7090);
 end;

 pac32(PChar(p)+474)^[0] := pac32(PChar(p)+354)^[0] xor $9073;

 if pac64(PChar(p)+191)^[0] < pac64(PChar(p)+271)^[0] then begin
   if pac32(PChar(p)+244)^[0] > pac32(PChar(p)+421)^[0] then begin  num := pac16(PChar(p)+485)^[0]; pac16(PChar(p)+485)^[0] := pac16(PChar(p)+379)^[0]; pac16(PChar(p)+379)^[0] := num; end else pac16(PChar(p)+124)^[0] := pac16(PChar(p)+124)^[0] + ror2(pac16(PChar(p)+245)^[0] , 5 );
   num := pac32(PChar(p)+501)^[0]; pac32(PChar(p)+501)^[0] := pac32(PChar(p)+53)^[0]; pac32(PChar(p)+53)^[0] := num;
   pac32(PChar(p)+311)^[0] := pac32(PChar(p)+311)^[0] xor (pac32(PChar(p)+492)^[0] xor $20dba9);
 end;

 pac8(PChar(p)+189)^[0] := pac8(PChar(p)+189)^[0] + ror2(pac8(PChar(p)+63)^[0] , 1 );
 if pac8(PChar(p)+407)^[0] > pac8(PChar(p)+3)^[0] then pac64(PChar(p)+469)^[0] := pac64(PChar(p)+132)^[0] - $f0de46df0036;
 pac16(PChar(p)+244)^[0] := pac16(PChar(p)+244)^[0] xor (pac16(PChar(p)+468)^[0] - $f0);
 pac8(PChar(p)+360)^[0] := pac8(PChar(p)+360)^[0] + ror2(pac8(PChar(p)+145)^[0] , 1 );

E8666789(p);

end;

procedure E8666789(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+388)^[0] := pac64(PChar(p)+388)^[0] xor (pac64(PChar(p)+128)^[0] + $d0ee5379ce78);
 pac32(PChar(p)+201)^[0] := ror2(pac32(PChar(p)+372)^[0] , 27 );

 if pac64(PChar(p)+65)^[0] > pac64(PChar(p)+200)^[0] then begin
   pac8(PChar(p)+448)^[0] := pac8(PChar(p)+448)^[0] xor $60;
   pac16(PChar(p)+340)^[0] := pac16(PChar(p)+340)^[0] xor ror1(pac16(PChar(p)+10)^[0] , 14 );
   pac32(PChar(p)+83)^[0] := pac32(PChar(p)+211)^[0] xor (pac32(PChar(p)+341)^[0] - $9048f0);
   if pac8(PChar(p)+28)^[0] < pac8(PChar(p)+375)^[0] then pac16(PChar(p)+450)^[0] := pac16(PChar(p)+450)^[0] + (pac16(PChar(p)+336)^[0] - $c0) else begin  num := pac16(PChar(p)+153)^[0]; pac16(PChar(p)+153)^[0] := pac16(PChar(p)+218)^[0]; pac16(PChar(p)+218)^[0] := num; end;
 end;

 pac32(PChar(p)+383)^[0] := pac32(PChar(p)+383)^[0] - (pac32(PChar(p)+418)^[0] - $207baf);
 if pac8(PChar(p)+72)^[0] < pac8(PChar(p)+190)^[0] then begin  num := pac32(PChar(p)+370)^[0]; pac32(PChar(p)+370)^[0] := pac32(PChar(p)+24)^[0]; pac32(PChar(p)+24)^[0] := num; end else pac32(PChar(p)+365)^[0] := pac32(PChar(p)+365)^[0] - (pac32(PChar(p)+134)^[0] - $00a5);
 pac16(PChar(p)+95)^[0] := pac16(PChar(p)+95)^[0] or $90;

 if pac16(PChar(p)+213)^[0] < pac16(PChar(p)+281)^[0] then begin
   pac64(PChar(p)+462)^[0] := pac64(PChar(p)+462)^[0] - (pac64(PChar(p)+490)^[0] + $40866315fe);
   if pac16(PChar(p)+418)^[0] > pac16(PChar(p)+72)^[0] then pac8(PChar(p)+417)^[0] := ror1(pac8(PChar(p)+24)^[0] , 7 ) else pac32(PChar(p)+417)^[0] := pac32(PChar(p)+417)^[0] - rol1(pac32(PChar(p)+480)^[0] , 31 );
   pac8(PChar(p)+171)^[0] := pac8(PChar(p)+171)^[0] or (pac8(PChar(p)+389)^[0] + $b0);
 end;

 pac8(PChar(p)+129)^[0] := ror2(pac8(PChar(p)+239)^[0] , 3 );
 pac64(PChar(p)+394)^[0] := pac64(PChar(p)+394)^[0] - (pac64(PChar(p)+465)^[0] xor $90c13e08);

 if pac32(PChar(p)+205)^[0] > pac32(PChar(p)+132)^[0] then begin
   pac32(PChar(p)+401)^[0] := pac32(PChar(p)+401)^[0] - ror1(pac32(PChar(p)+127)^[0] , 14 );
   num := pac32(PChar(p)+109)^[0]; pac32(PChar(p)+109)^[0] := pac32(PChar(p)+256)^[0]; pac32(PChar(p)+256)^[0] := num;
   pac32(PChar(p)+351)^[0] := ror2(pac32(PChar(p)+452)^[0] , 29 );
   pac32(PChar(p)+329)^[0] := pac32(PChar(p)+329)^[0] or rol1(pac32(PChar(p)+255)^[0] , 8 );
 end;

 num := pac8(PChar(p)+351)^[0]; pac8(PChar(p)+351)^[0] := pac8(PChar(p)+358)^[0]; pac8(PChar(p)+358)^[0] := num;
 if pac16(PChar(p)+41)^[0] > pac16(PChar(p)+20)^[0] then pac32(PChar(p)+97)^[0] := pac32(PChar(p)+97)^[0] or ror1(pac32(PChar(p)+40)^[0] , 10 ) else pac32(PChar(p)+199)^[0] := pac32(PChar(p)+199)^[0] or (pac32(PChar(p)+102)^[0] or $b0dd15);
 if pac8(PChar(p)+325)^[0] > pac8(PChar(p)+403)^[0] then pac16(PChar(p)+394)^[0] := pac16(PChar(p)+394)^[0] - (pac16(PChar(p)+234)^[0] or $90) else begin  num := pac8(PChar(p)+15)^[0]; pac8(PChar(p)+15)^[0] := pac8(PChar(p)+431)^[0]; pac8(PChar(p)+431)^[0] := num; end;

 if pac32(PChar(p)+136)^[0] < pac32(PChar(p)+228)^[0] then begin
   pac64(PChar(p)+161)^[0] := pac64(PChar(p)+161)^[0] + $600abe7dcc;
   pac8(PChar(p)+104)^[0] := pac8(PChar(p)+104)^[0] - $c0;
   pac32(PChar(p)+388)^[0] := pac32(PChar(p)+388)^[0] + (pac32(PChar(p)+123)^[0] xor $c061);
 end;


 if pac16(PChar(p)+99)^[0] > pac16(PChar(p)+176)^[0] then begin
   pac16(PChar(p)+385)^[0] := pac16(PChar(p)+385)^[0] xor ror2(pac16(PChar(p)+73)^[0] , 10 );
   num := pac32(PChar(p)+369)^[0]; pac32(PChar(p)+369)^[0] := pac32(PChar(p)+139)^[0]; pac32(PChar(p)+139)^[0] := num;
 end;


DF12A784(p);

end;

procedure DF12A784(p: Pointer);
var num: Int64;
begin


 if pac32(PChar(p)+457)^[0] < pac32(PChar(p)+108)^[0] then begin
   if pac32(PChar(p)+276)^[0] < pac32(PChar(p)+380)^[0] then begin  num := pac8(PChar(p)+169)^[0]; pac8(PChar(p)+169)^[0] := pac8(PChar(p)+104)^[0]; pac8(PChar(p)+104)^[0] := num; end else pac64(PChar(p)+420)^[0] := pac64(PChar(p)+420)^[0] xor $a09c838a6f71;
   pac32(PChar(p)+318)^[0] := pac32(PChar(p)+318)^[0] xor $50ba;
   pac32(PChar(p)+306)^[0] := pac32(PChar(p)+306)^[0] + $a07e;
   pac16(PChar(p)+497)^[0] := pac16(PChar(p)+497)^[0] or ror2(pac16(PChar(p)+295)^[0] , 6 );
   pac64(PChar(p)+69)^[0] := pac64(PChar(p)+69)^[0] or (pac64(PChar(p)+324)^[0] + $702e5b8b3c28);
 end;


 if pac32(PChar(p)+346)^[0] < pac32(PChar(p)+335)^[0] then begin
   if pac8(PChar(p)+170)^[0] > pac8(PChar(p)+445)^[0] then pac32(PChar(p)+468)^[0] := pac32(PChar(p)+468)^[0] - (pac32(PChar(p)+270)^[0] or $f0d615);
   pac32(PChar(p)+409)^[0] := pac32(PChar(p)+409)^[0] or $0058;
   pac32(PChar(p)+397)^[0] := pac32(PChar(p)+424)^[0] xor $9088;
   pac32(PChar(p)+2)^[0] := pac32(PChar(p)+2)^[0] + ror1(pac32(PChar(p)+384)^[0] , 21 );
 end;

 pac64(PChar(p)+28)^[0] := pac64(PChar(p)+28)^[0] - $100fd28b5e3e;
 pac32(PChar(p)+56)^[0] := pac32(PChar(p)+222)^[0] + $d0e7;
 pac32(PChar(p)+44)^[0] := pac32(PChar(p)+44)^[0] - (pac32(PChar(p)+331)^[0] xor $20d0);
 pac32(PChar(p)+454)^[0] := pac32(PChar(p)+454)^[0] xor (pac32(PChar(p)+464)^[0] or $5013b2);
 num := pac8(PChar(p)+261)^[0]; pac8(PChar(p)+261)^[0] := pac8(PChar(p)+4)^[0]; pac8(PChar(p)+4)^[0] := num;
 if pac16(PChar(p)+167)^[0] > pac16(PChar(p)+464)^[0] then begin  num := pac8(PChar(p)+152)^[0]; pac8(PChar(p)+152)^[0] := pac8(PChar(p)+385)^[0]; pac8(PChar(p)+385)^[0] := num; end else begin  num := pac16(PChar(p)+172)^[0]; pac16(PChar(p)+172)^[0] := pac16(PChar(p)+136)^[0]; pac16(PChar(p)+136)^[0] := num; end;

 if pac16(PChar(p)+452)^[0] < pac16(PChar(p)+239)^[0] then begin
   if pac64(PChar(p)+26)^[0] > pac64(PChar(p)+271)^[0] then begin  num := pac8(PChar(p)+218)^[0]; pac8(PChar(p)+218)^[0] := pac8(PChar(p)+380)^[0]; pac8(PChar(p)+380)^[0] := num; end else begin  num := pac32(PChar(p)+422)^[0]; pac32(PChar(p)+422)^[0] := pac32(PChar(p)+53)^[0]; pac32(PChar(p)+53)^[0] := num; end;
   pac16(PChar(p)+159)^[0] := ror2(pac16(PChar(p)+61)^[0] , 2 );
   pac64(PChar(p)+219)^[0] := pac64(PChar(p)+219)^[0] - $c03dd723;
   num := pac16(PChar(p)+5)^[0]; pac16(PChar(p)+5)^[0] := pac16(PChar(p)+180)^[0]; pac16(PChar(p)+180)^[0] := num;
   num := pac32(PChar(p)+142)^[0]; pac32(PChar(p)+142)^[0] := pac32(PChar(p)+363)^[0]; pac32(PChar(p)+363)^[0] := num;
 end;

 num := pac16(PChar(p)+117)^[0]; pac16(PChar(p)+117)^[0] := pac16(PChar(p)+508)^[0]; pac16(PChar(p)+508)^[0] := num;

 if pac64(PChar(p)+232)^[0] < pac64(PChar(p)+207)^[0] then begin
   pac32(PChar(p)+401)^[0] := pac32(PChar(p)+401)^[0] + $f03c12;
   pac64(PChar(p)+90)^[0] := pac64(PChar(p)+90)^[0] xor $d0103ee45d;
   pac16(PChar(p)+388)^[0] := pac16(PChar(p)+388)^[0] - rol1(pac16(PChar(p)+119)^[0] , 11 );
   num := pac32(PChar(p)+245)^[0]; pac32(PChar(p)+245)^[0] := pac32(PChar(p)+343)^[0]; pac32(PChar(p)+343)^[0] := num;
   if pac16(PChar(p)+197)^[0] > pac16(PChar(p)+107)^[0] then pac64(PChar(p)+479)^[0] := pac64(PChar(p)+479)^[0] - $5031351f8f;
 end;

 if pac16(PChar(p)+204)^[0] < pac16(PChar(p)+10)^[0] then pac8(PChar(p)+208)^[0] := pac8(PChar(p)+208)^[0] or rol1(pac8(PChar(p)+35)^[0] , 3 ) else pac32(PChar(p)+492)^[0] := pac32(PChar(p)+188)^[0] xor $30add2;
 pac64(PChar(p)+10)^[0] := pac64(PChar(p)+10)^[0] + $f03b3a89;

B329165D(p);

end;

procedure B329165D(p: Pointer);
var num: Int64;
begin

 if pac16(PChar(p)+499)^[0] < pac16(PChar(p)+188)^[0] then begin  num := pac16(PChar(p)+76)^[0]; pac16(PChar(p)+76)^[0] := pac16(PChar(p)+446)^[0]; pac16(PChar(p)+446)^[0] := num; end else begin  num := pac32(PChar(p)+407)^[0]; pac32(PChar(p)+407)^[0] := pac32(PChar(p)+31)^[0]; pac32(PChar(p)+31)^[0] := num; end;
 pac32(PChar(p)+463)^[0] := pac32(PChar(p)+463)^[0] + $607ba4;
 num := pac16(PChar(p)+371)^[0]; pac16(PChar(p)+371)^[0] := pac16(PChar(p)+465)^[0]; pac16(PChar(p)+465)^[0] := num;
 if pac64(PChar(p)+148)^[0] < pac64(PChar(p)+233)^[0] then pac64(PChar(p)+395)^[0] := pac64(PChar(p)+395)^[0] - $8078b2cf else pac8(PChar(p)+177)^[0] := pac8(PChar(p)+177)^[0] + rol1(pac8(PChar(p)+215)^[0] , 7 );
 if pac64(PChar(p)+113)^[0] < pac64(PChar(p)+83)^[0] then begin  num := pac8(PChar(p)+485)^[0]; pac8(PChar(p)+485)^[0] := pac8(PChar(p)+320)^[0]; pac8(PChar(p)+320)^[0] := num; end else pac16(PChar(p)+73)^[0] := pac16(PChar(p)+73)^[0] xor ror1(pac16(PChar(p)+408)^[0] , 14 );
 pac64(PChar(p)+11)^[0] := pac64(PChar(p)+100)^[0] xor $90eb851215a7;
 pac64(PChar(p)+373)^[0] := pac64(PChar(p)+373)^[0] xor (pac64(PChar(p)+288)^[0] - $908b0778c4ec);

 if pac32(PChar(p)+348)^[0] > pac32(PChar(p)+116)^[0] then begin
   if pac32(PChar(p)+380)^[0] < pac32(PChar(p)+490)^[0] then pac64(PChar(p)+269)^[0] := pac64(PChar(p)+269)^[0] xor $806124e7b33b else begin  num := pac16(PChar(p)+268)^[0]; pac16(PChar(p)+268)^[0] := pac16(PChar(p)+41)^[0]; pac16(PChar(p)+41)^[0] := num; end;
   num := pac32(PChar(p)+215)^[0]; pac32(PChar(p)+215)^[0] := pac32(PChar(p)+257)^[0]; pac32(PChar(p)+257)^[0] := num;
   num := pac32(PChar(p)+69)^[0]; pac32(PChar(p)+69)^[0] := pac32(PChar(p)+133)^[0]; pac32(PChar(p)+133)^[0] := num;
   num := pac16(PChar(p)+466)^[0]; pac16(PChar(p)+466)^[0] := pac16(PChar(p)+308)^[0]; pac16(PChar(p)+308)^[0] := num;
 end;

 pac32(PChar(p)+174)^[0] := pac32(PChar(p)+174)^[0] + ror2(pac32(PChar(p)+4)^[0] , 22 );
 pac32(PChar(p)+498)^[0] := rol1(pac32(PChar(p)+77)^[0] , 7 );
 pac32(PChar(p)+448)^[0] := pac32(PChar(p)+448)^[0] + (pac32(PChar(p)+161)^[0] - $200950);
 num := pac32(PChar(p)+198)^[0]; pac32(PChar(p)+198)^[0] := pac32(PChar(p)+247)^[0]; pac32(PChar(p)+247)^[0] := num;
 pac32(PChar(p)+343)^[0] := pac32(PChar(p)+329)^[0] or (pac32(PChar(p)+199)^[0] - $c013b1);
 pac8(PChar(p)+136)^[0] := pac8(PChar(p)+136)^[0] - ror2(pac8(PChar(p)+15)^[0] , 3 );

 if pac16(PChar(p)+391)^[0] < pac16(PChar(p)+45)^[0] then begin
   if pac64(PChar(p)+201)^[0] < pac64(PChar(p)+10)^[0] then pac64(PChar(p)+422)^[0] := pac64(PChar(p)+422)^[0] xor $e01d26201282 else pac16(PChar(p)+369)^[0] := pac16(PChar(p)+369)^[0] - (pac16(PChar(p)+456)^[0] - $c0);
   pac8(PChar(p)+198)^[0] := pac8(PChar(p)+198)^[0] xor rol1(pac8(PChar(p)+397)^[0] , 2 );
   pac16(PChar(p)+171)^[0] := pac16(PChar(p)+171)^[0] + (pac16(PChar(p)+213)^[0] + $d8);
   if pac32(PChar(p)+219)^[0] > pac32(PChar(p)+487)^[0] then pac16(PChar(p)+26)^[0] := pac16(PChar(p)+26)^[0] - (pac16(PChar(p)+207)^[0] + $40) else pac32(PChar(p)+18)^[0] := pac32(PChar(p)+18)^[0] + rol1(pac32(PChar(p)+311)^[0] , 26 );
   pac32(PChar(p)+369)^[0] := pac32(PChar(p)+369)^[0] - ror2(pac32(PChar(p)+424)^[0] , 5 );
 end;

 pac32(PChar(p)+492)^[0] := pac32(PChar(p)+492)^[0] + $30e5;
 if pac32(PChar(p)+245)^[0] > pac32(PChar(p)+391)^[0] then begin  num := pac32(PChar(p)+102)^[0]; pac32(PChar(p)+102)^[0] := pac32(PChar(p)+232)^[0]; pac32(PChar(p)+232)^[0] := num; end else begin  num := pac32(PChar(p)+472)^[0]; pac32(PChar(p)+472)^[0] := pac32(PChar(p)+210)^[0]; pac32(PChar(p)+210)^[0] := num; end;

CB8D3A28(p);

end;

procedure CB8D3A28(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+125)^[0] := pac8(PChar(p)+125)^[0] - $10;
 pac8(PChar(p)+221)^[0] := pac8(PChar(p)+221)^[0] or ror1(pac8(PChar(p)+445)^[0] , 1 );
 pac8(PChar(p)+7)^[0] := pac8(PChar(p)+7)^[0] or $90;
 num := pac32(PChar(p)+105)^[0]; pac32(PChar(p)+105)^[0] := pac32(PChar(p)+309)^[0]; pac32(PChar(p)+309)^[0] := num;
 pac8(PChar(p)+307)^[0] := pac8(PChar(p)+307)^[0] - ror1(pac8(PChar(p)+461)^[0] , 5 );
 pac16(PChar(p)+22)^[0] := pac16(PChar(p)+22)^[0] - $60;
 pac16(PChar(p)+445)^[0] := pac16(PChar(p)+445)^[0] - rol1(pac16(PChar(p)+96)^[0] , 10 );
 num := pac8(PChar(p)+109)^[0]; pac8(PChar(p)+109)^[0] := pac8(PChar(p)+138)^[0]; pac8(PChar(p)+138)^[0] := num;
 pac64(PChar(p)+247)^[0] := pac64(PChar(p)+247)^[0] + (pac64(PChar(p)+232)^[0] or $c07811d0a3);

 if pac32(PChar(p)+12)^[0] < pac32(PChar(p)+22)^[0] then begin
   pac32(PChar(p)+182)^[0] := rol1(pac32(PChar(p)+402)^[0] , 28 );
   num := pac8(PChar(p)+127)^[0]; pac8(PChar(p)+127)^[0] := pac8(PChar(p)+315)^[0]; pac8(PChar(p)+315)^[0] := num;
 end;


CEE12CC0(p);

end;

procedure CEE12CC0(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+112)^[0] := pac32(PChar(p)+112)^[0] or $904c7a;
 pac8(PChar(p)+345)^[0] := pac8(PChar(p)+345)^[0] xor ror1(pac8(PChar(p)+353)^[0] , 1 );
 pac64(PChar(p)+336)^[0] := pac64(PChar(p)+336)^[0] xor (pac64(PChar(p)+76)^[0] or $70e6c3dc9628);
 num := pac32(PChar(p)+284)^[0]; pac32(PChar(p)+284)^[0] := pac32(PChar(p)+472)^[0]; pac32(PChar(p)+472)^[0] := num;
 pac16(PChar(p)+405)^[0] := pac16(PChar(p)+405)^[0] - ror2(pac16(PChar(p)+275)^[0] , 13 );

 if pac8(PChar(p)+386)^[0] > pac8(PChar(p)+388)^[0] then begin
   pac8(PChar(p)+475)^[0] := pac8(PChar(p)+475)^[0] xor (pac8(PChar(p)+390)^[0] + $f0);
   pac16(PChar(p)+168)^[0] := pac16(PChar(p)+168)^[0] + ror1(pac16(PChar(p)+163)^[0] , 13 );
 end;

 if pac16(PChar(p)+503)^[0] < pac16(PChar(p)+304)^[0] then begin  num := pac16(PChar(p)+473)^[0]; pac16(PChar(p)+473)^[0] := pac16(PChar(p)+90)^[0]; pac16(PChar(p)+90)^[0] := num; end else pac16(PChar(p)+397)^[0] := pac16(PChar(p)+397)^[0] + (pac16(PChar(p)+283)^[0] - $30);
 if pac8(PChar(p)+95)^[0] > pac8(PChar(p)+417)^[0] then pac8(PChar(p)+68)^[0] := pac8(PChar(p)+68)^[0] xor ror2(pac8(PChar(p)+253)^[0] , 6 ) else pac64(PChar(p)+112)^[0] := pac64(PChar(p)+105)^[0] xor (pac64(PChar(p)+361)^[0] or $90ebff29);
 pac64(PChar(p)+179)^[0] := pac64(PChar(p)+179)^[0] xor (pac64(PChar(p)+262)^[0] + $d029c3972395);
 pac32(PChar(p)+247)^[0] := pac32(PChar(p)+247)^[0] - $1031;
 pac16(PChar(p)+448)^[0] := pac16(PChar(p)+448)^[0] - (pac16(PChar(p)+393)^[0] xor $30);
 pac64(PChar(p)+345)^[0] := pac64(PChar(p)+345)^[0] xor (pac64(PChar(p)+16)^[0] or $d04b5ee948);

 if pac16(PChar(p)+211)^[0] > pac16(PChar(p)+443)^[0] then begin
   num := pac16(PChar(p)+35)^[0]; pac16(PChar(p)+35)^[0] := pac16(PChar(p)+508)^[0]; pac16(PChar(p)+508)^[0] := num;
   pac8(PChar(p)+159)^[0] := pac8(PChar(p)+335)^[0] - (pac8(PChar(p)+381)^[0] or $10);
   pac16(PChar(p)+170)^[0] := rol1(pac16(PChar(p)+358)^[0] , 10 );
   pac8(PChar(p)+388)^[0] := pac8(PChar(p)+388)^[0] - ror2(pac8(PChar(p)+220)^[0] , 1 );
 end;

 pac32(PChar(p)+286)^[0] := pac32(PChar(p)+286)^[0] + $e092;
 num := pac8(PChar(p)+127)^[0]; pac8(PChar(p)+127)^[0] := pac8(PChar(p)+133)^[0]; pac8(PChar(p)+133)^[0] := num;
 pac16(PChar(p)+448)^[0] := pac16(PChar(p)+448)^[0] + ror1(pac16(PChar(p)+142)^[0] , 12 );

F80874E2(p);

end;

procedure F80874E2(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+265)^[0] := pac16(PChar(p)+265)^[0] or (pac16(PChar(p)+201)^[0] - $60);
 num := pac8(PChar(p)+342)^[0]; pac8(PChar(p)+342)^[0] := pac8(PChar(p)+337)^[0]; pac8(PChar(p)+337)^[0] := num;
 num := pac8(PChar(p)+499)^[0]; pac8(PChar(p)+499)^[0] := pac8(PChar(p)+456)^[0]; pac8(PChar(p)+456)^[0] := num;
 pac8(PChar(p)+499)^[0] := pac8(PChar(p)+499)^[0] xor $40;
 pac8(PChar(p)+88)^[0] := pac8(PChar(p)+88)^[0] - ror2(pac8(PChar(p)+487)^[0] , 1 );
 pac64(PChar(p)+48)^[0] := pac64(PChar(p)+275)^[0] - $8055bedd5d1e;
 pac64(PChar(p)+200)^[0] := pac64(PChar(p)+336)^[0] xor $30076290;
 pac64(PChar(p)+254)^[0] := pac64(PChar(p)+254)^[0] - (pac64(PChar(p)+485)^[0] or $40c56d334869);
 pac32(PChar(p)+324)^[0] := pac32(PChar(p)+324)^[0] - (pac32(PChar(p)+390)^[0] or $80af);
 pac64(PChar(p)+138)^[0] := pac64(PChar(p)+138)^[0] xor $c092b8299b10;
 pac64(PChar(p)+500)^[0] := pac64(PChar(p)+77)^[0] xor $3048535b5f2b;
 pac64(PChar(p)+357)^[0] := pac64(PChar(p)+357)^[0] xor (pac64(PChar(p)+323)^[0] - $a0f7914240d8);
 pac8(PChar(p)+130)^[0] := pac8(PChar(p)+17)^[0] + (pac8(PChar(p)+134)^[0] xor $b0);
 pac64(PChar(p)+31)^[0] := pac64(PChar(p)+31)^[0] - (pac64(PChar(p)+265)^[0] or $503cd49421);
 num := pac32(PChar(p)+267)^[0]; pac32(PChar(p)+267)^[0] := pac32(PChar(p)+198)^[0]; pac32(PChar(p)+198)^[0] := num;
 pac64(PChar(p)+137)^[0] := pac64(PChar(p)+137)^[0] xor (pac64(PChar(p)+212)^[0] or $5089d6629bd1);
 pac32(PChar(p)+99)^[0] := pac32(PChar(p)+99)^[0] + rol1(pac32(PChar(p)+417)^[0] , 2 );
 pac64(PChar(p)+486)^[0] := pac64(PChar(p)+282)^[0] - (pac64(PChar(p)+17)^[0] - $1000c9b0f63a);

EEFABA92(p);

end;

procedure EEFABA92(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+458)^[0] := pac64(PChar(p)+394)^[0] xor $c0772bb2e888;
 pac32(PChar(p)+443)^[0] := pac32(PChar(p)+443)^[0] + $a05435;
 pac32(PChar(p)+259)^[0] := pac32(PChar(p)+12)^[0] + $e091d3;
 pac32(PChar(p)+372)^[0] := pac32(PChar(p)+175)^[0] or (pac32(PChar(p)+62)^[0] xor $5016);
 if pac16(PChar(p)+340)^[0] > pac16(PChar(p)+247)^[0] then pac32(PChar(p)+228)^[0] := pac32(PChar(p)+228)^[0] - (pac32(PChar(p)+56)^[0] or $c025) else pac32(PChar(p)+129)^[0] := pac32(PChar(p)+400)^[0] xor (pac32(PChar(p)+190)^[0] + $606480);
 pac32(PChar(p)+494)^[0] := pac32(PChar(p)+34)^[0] - $20397e;
 pac8(PChar(p)+99)^[0] := pac8(PChar(p)+99)^[0] or (pac8(PChar(p)+225)^[0] xor $d0);
 pac32(PChar(p)+273)^[0] := pac32(PChar(p)+273)^[0] xor ror2(pac32(PChar(p)+0)^[0] , 18 );
 if pac8(PChar(p)+169)^[0] > pac8(PChar(p)+235)^[0] then begin  num := pac32(PChar(p)+290)^[0]; pac32(PChar(p)+290)^[0] := pac32(PChar(p)+384)^[0]; pac32(PChar(p)+384)^[0] := num; end else pac16(PChar(p)+154)^[0] := pac16(PChar(p)+343)^[0] or $60;
 if pac16(PChar(p)+124)^[0] < pac16(PChar(p)+257)^[0] then begin  num := pac32(PChar(p)+67)^[0]; pac32(PChar(p)+67)^[0] := pac32(PChar(p)+387)^[0]; pac32(PChar(p)+387)^[0] := num; end else pac32(PChar(p)+48)^[0] := pac32(PChar(p)+48)^[0] or $006dae;
 if pac64(PChar(p)+197)^[0] < pac64(PChar(p)+231)^[0] then pac16(PChar(p)+338)^[0] := ror1(pac16(PChar(p)+328)^[0] , 6 ) else pac64(PChar(p)+273)^[0] := pac64(PChar(p)+273)^[0] + $f018f5c361;

 if pac64(PChar(p)+404)^[0] > pac64(PChar(p)+49)^[0] then begin
   pac8(PChar(p)+45)^[0] := pac8(PChar(p)+45)^[0] xor $70;
   num := pac32(PChar(p)+58)^[0]; pac32(PChar(p)+58)^[0] := pac32(PChar(p)+319)^[0]; pac32(PChar(p)+319)^[0] := num;
   pac64(PChar(p)+348)^[0] := pac64(PChar(p)+348)^[0] + $108c756f;
 end;

 pac8(PChar(p)+382)^[0] := pac8(PChar(p)+382)^[0] or rol1(pac8(PChar(p)+461)^[0] , 4 );
 pac32(PChar(p)+195)^[0] := pac32(PChar(p)+195)^[0] or ror2(pac32(PChar(p)+22)^[0] , 1 );
 pac8(PChar(p)+96)^[0] := pac8(PChar(p)+267)^[0] or (pac8(PChar(p)+486)^[0] or $30);

AD08A344(p);

end;

procedure AD08A344(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+239)^[0] < pac64(PChar(p)+76)^[0] then begin  num := pac8(PChar(p)+150)^[0]; pac8(PChar(p)+150)^[0] := pac8(PChar(p)+345)^[0]; pac8(PChar(p)+345)^[0] := num; end else pac64(PChar(p)+52)^[0] := pac64(PChar(p)+52)^[0] - (pac64(PChar(p)+325)^[0] xor $f0515963ea77);
 num := pac16(PChar(p)+95)^[0]; pac16(PChar(p)+95)^[0] := pac16(PChar(p)+218)^[0]; pac16(PChar(p)+218)^[0] := num;
 num := pac16(PChar(p)+265)^[0]; pac16(PChar(p)+265)^[0] := pac16(PChar(p)+458)^[0]; pac16(PChar(p)+458)^[0] := num;
 pac32(PChar(p)+490)^[0] := pac32(PChar(p)+490)^[0] - (pac32(PChar(p)+317)^[0] + $10a4bb);
 pac32(PChar(p)+9)^[0] := pac32(PChar(p)+9)^[0] or (pac32(PChar(p)+173)^[0] - $a0b81f);
 pac32(PChar(p)+334)^[0] := pac32(PChar(p)+452)^[0] + (pac32(PChar(p)+121)^[0] xor $e0cb9d);
 if pac64(PChar(p)+226)^[0] > pac64(PChar(p)+347)^[0] then pac32(PChar(p)+140)^[0] := pac32(PChar(p)+140)^[0] + ror2(pac32(PChar(p)+189)^[0] , 6 ) else pac64(PChar(p)+346)^[0] := pac64(PChar(p)+346)^[0] xor $7066c3c2;
 pac16(PChar(p)+504)^[0] := pac16(PChar(p)+251)^[0] + (pac16(PChar(p)+384)^[0] - $e0);

 if pac32(PChar(p)+294)^[0] > pac32(PChar(p)+73)^[0] then begin
   if pac64(PChar(p)+353)^[0] > pac64(PChar(p)+445)^[0] then pac32(PChar(p)+20)^[0] := pac32(PChar(p)+20)^[0] - $a0d2ff;
   num := pac32(PChar(p)+277)^[0]; pac32(PChar(p)+277)^[0] := pac32(PChar(p)+38)^[0]; pac32(PChar(p)+38)^[0] := num;
 end;

 num := pac8(PChar(p)+442)^[0]; pac8(PChar(p)+442)^[0] := pac8(PChar(p)+192)^[0]; pac8(PChar(p)+192)^[0] := num;
 pac64(PChar(p)+35)^[0] := pac64(PChar(p)+35)^[0] or $80eba4bf;
 pac64(PChar(p)+62)^[0] := pac64(PChar(p)+62)^[0] + (pac64(PChar(p)+266)^[0] xor $c0b038c885);

 if pac64(PChar(p)+232)^[0] > pac64(PChar(p)+469)^[0] then begin
   pac64(PChar(p)+424)^[0] := pac64(PChar(p)+271)^[0] or (pac64(PChar(p)+259)^[0] xor $b0228cc5e4);
   pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] or (pac32(PChar(p)+348)^[0] or $20273a);
   num := pac8(PChar(p)+422)^[0]; pac8(PChar(p)+422)^[0] := pac8(PChar(p)+246)^[0]; pac8(PChar(p)+246)^[0] := num;
 end;

 if pac8(PChar(p)+14)^[0] < pac8(PChar(p)+260)^[0] then begin  num := pac16(PChar(p)+52)^[0]; pac16(PChar(p)+52)^[0] := pac16(PChar(p)+211)^[0]; pac16(PChar(p)+211)^[0] := num; end else pac8(PChar(p)+62)^[0] := pac8(PChar(p)+62)^[0] - rol1(pac8(PChar(p)+213)^[0] , 5 );
 pac8(PChar(p)+307)^[0] := pac8(PChar(p)+307)^[0] xor ror1(pac8(PChar(p)+114)^[0] , 6 );

 if pac16(PChar(p)+390)^[0] < pac16(PChar(p)+240)^[0] then begin
   num := pac16(PChar(p)+454)^[0]; pac16(PChar(p)+454)^[0] := pac16(PChar(p)+175)^[0]; pac16(PChar(p)+175)^[0] := num;
   pac32(PChar(p)+352)^[0] := pac32(PChar(p)+352)^[0] - $d0d5;
   if pac64(PChar(p)+143)^[0] < pac64(PChar(p)+217)^[0] then begin  num := pac32(PChar(p)+388)^[0]; pac32(PChar(p)+388)^[0] := pac32(PChar(p)+304)^[0]; pac32(PChar(p)+304)^[0] := num; end else pac64(PChar(p)+331)^[0] := pac64(PChar(p)+173)^[0] - (pac64(PChar(p)+362)^[0] or $30c44d9e);
   pac32(PChar(p)+103)^[0] := pac32(PChar(p)+103)^[0] - $f078;
   pac16(PChar(p)+304)^[0] := pac16(PChar(p)+304)^[0] or $90;
 end;

 if pac8(PChar(p)+230)^[0] > pac8(PChar(p)+87)^[0] then pac8(PChar(p)+1)^[0] := pac8(PChar(p)+1)^[0] + ror1(pac8(PChar(p)+26)^[0] , 5 ) else pac16(PChar(p)+186)^[0] := pac16(PChar(p)+443)^[0] or (pac16(PChar(p)+250)^[0] xor $90);
 pac32(PChar(p)+213)^[0] := pac32(PChar(p)+213)^[0] + $d0dd02;
 if pac8(PChar(p)+487)^[0] > pac8(PChar(p)+417)^[0] then pac32(PChar(p)+438)^[0] := ror2(pac32(PChar(p)+155)^[0] , 15 ) else pac32(PChar(p)+102)^[0] := pac32(PChar(p)+102)^[0] + $c028;

CC3EE24B(p);

end;

procedure CC3EE24B(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+128)^[0] := pac32(PChar(p)+128)^[0] - rol1(pac32(PChar(p)+224)^[0] , 8 );
 num := pac16(PChar(p)+336)^[0]; pac16(PChar(p)+336)^[0] := pac16(PChar(p)+169)^[0]; pac16(PChar(p)+169)^[0] := num;
 pac64(PChar(p)+460)^[0] := pac64(PChar(p)+18)^[0] - (pac64(PChar(p)+437)^[0] - $309ad513c7);

 if pac64(PChar(p)+433)^[0] > pac64(PChar(p)+248)^[0] then begin
   pac8(PChar(p)+407)^[0] := pac8(PChar(p)+407)^[0] or (pac8(PChar(p)+111)^[0] xor $50);
   if pac16(PChar(p)+240)^[0] < pac16(PChar(p)+469)^[0] then pac8(PChar(p)+407)^[0] := pac8(PChar(p)+407)^[0] - ror2(pac8(PChar(p)+9)^[0] , 3 ) else pac8(PChar(p)+169)^[0] := pac8(PChar(p)+169)^[0] xor $e0;
   pac8(PChar(p)+225)^[0] := pac8(PChar(p)+225)^[0] - ror2(pac8(PChar(p)+490)^[0] , 7 );
 end;

 pac32(PChar(p)+343)^[0] := pac32(PChar(p)+343)^[0] - $10ebab;

 if pac16(PChar(p)+410)^[0] > pac16(PChar(p)+365)^[0] then begin
   pac8(PChar(p)+446)^[0] := pac8(PChar(p)+446)^[0] xor ror2(pac8(PChar(p)+246)^[0] , 3 );
   if pac8(PChar(p)+166)^[0] < pac8(PChar(p)+163)^[0] then begin  num := pac16(PChar(p)+149)^[0]; pac16(PChar(p)+149)^[0] := pac16(PChar(p)+397)^[0]; pac16(PChar(p)+397)^[0] := num; end else begin  num := pac32(PChar(p)+358)^[0]; pac32(PChar(p)+358)^[0] := pac32(PChar(p)+318)^[0]; pac32(PChar(p)+318)^[0] := num; end;
   num := pac16(PChar(p)+119)^[0]; pac16(PChar(p)+119)^[0] := pac16(PChar(p)+213)^[0]; pac16(PChar(p)+213)^[0] := num;
   pac16(PChar(p)+433)^[0] := pac16(PChar(p)+433)^[0] xor (pac16(PChar(p)+352)^[0] xor $e0);
 end;

 pac32(PChar(p)+79)^[0] := rol1(pac32(PChar(p)+234)^[0] , 17 );
 num := pac8(PChar(p)+297)^[0]; pac8(PChar(p)+297)^[0] := pac8(PChar(p)+253)^[0]; pac8(PChar(p)+253)^[0] := num;
 num := pac8(PChar(p)+501)^[0]; pac8(PChar(p)+501)^[0] := pac8(PChar(p)+41)^[0]; pac8(PChar(p)+41)^[0] := num;
 pac8(PChar(p)+510)^[0] := pac8(PChar(p)+24)^[0] xor $80;
 if pac16(PChar(p)+470)^[0] < pac16(PChar(p)+318)^[0] then begin  num := pac16(PChar(p)+18)^[0]; pac16(PChar(p)+18)^[0] := pac16(PChar(p)+472)^[0]; pac16(PChar(p)+472)^[0] := num; end else pac32(PChar(p)+132)^[0] := pac32(PChar(p)+473)^[0] + (pac32(PChar(p)+133)^[0] + $00422e);
 pac32(PChar(p)+497)^[0] := pac32(PChar(p)+497)^[0] + $004ecc;
 pac16(PChar(p)+314)^[0] := pac16(PChar(p)+314)^[0] or (pac16(PChar(p)+75)^[0] xor $70);

 if pac64(PChar(p)+218)^[0] < pac64(PChar(p)+91)^[0] then begin
   pac8(PChar(p)+74)^[0] := pac8(PChar(p)+74)^[0] + ror2(pac8(PChar(p)+129)^[0] , 2 );
   pac64(PChar(p)+200)^[0] := pac64(PChar(p)+350)^[0] - (pac64(PChar(p)+18)^[0] - $f0647de2416a);
   pac32(PChar(p)+183)^[0] := pac32(PChar(p)+183)^[0] - $c0b581;
   pac8(PChar(p)+298)^[0] := pac8(PChar(p)+298)^[0] or (pac8(PChar(p)+285)^[0] xor $30);
 end;


 if pac8(PChar(p)+483)^[0] < pac8(PChar(p)+28)^[0] then begin
   pac8(PChar(p)+193)^[0] := pac8(PChar(p)+439)^[0] or (pac8(PChar(p)+324)^[0] xor $20);
   pac16(PChar(p)+62)^[0] := pac16(PChar(p)+62)^[0] - rol1(pac16(PChar(p)+180)^[0] , 11 );
   pac8(PChar(p)+387)^[0] := pac8(PChar(p)+387)^[0] - ror1(pac8(PChar(p)+255)^[0] , 2 );
   pac8(PChar(p)+309)^[0] := pac8(PChar(p)+309)^[0] + ror1(pac8(PChar(p)+29)^[0] , 7 );
   pac16(PChar(p)+103)^[0] := pac16(PChar(p)+103)^[0] + $60;
 end;

 pac32(PChar(p)+170)^[0] := pac32(PChar(p)+170)^[0] or $a0fb24;

D2A55359(p);

end;

procedure D2A55359(p: Pointer);
var num: Int64;
begin

 pac16(PChar(p)+62)^[0] := pac16(PChar(p)+62)^[0] + ror2(pac16(PChar(p)+32)^[0] , 15 );
 pac8(PChar(p)+92)^[0] := pac8(PChar(p)+92)^[0] or rol1(pac8(PChar(p)+19)^[0] , 6 );
 if pac32(PChar(p)+144)^[0] < pac32(PChar(p)+159)^[0] then pac32(PChar(p)+132)^[0] := pac32(PChar(p)+132)^[0] or (pac32(PChar(p)+433)^[0] + $9090) else pac64(PChar(p)+244)^[0] := pac64(PChar(p)+244)^[0] xor (pac64(PChar(p)+470)^[0] - $8045ddc8);
 num := pac32(PChar(p)+166)^[0]; pac32(PChar(p)+166)^[0] := pac32(PChar(p)+110)^[0]; pac32(PChar(p)+110)^[0] := num;
 pac16(PChar(p)+505)^[0] := pac16(PChar(p)+505)^[0] xor ror1(pac16(PChar(p)+55)^[0] , 13 );
 pac64(PChar(p)+207)^[0] := pac64(PChar(p)+495)^[0] - (pac64(PChar(p)+410)^[0] - $70b84d05d62a);
 pac64(PChar(p)+358)^[0] := pac64(PChar(p)+358)^[0] or $903c5a5b;

 if pac8(PChar(p)+71)^[0] > pac8(PChar(p)+342)^[0] then begin
   pac8(PChar(p)+111)^[0] := pac8(PChar(p)+111)^[0] + ror2(pac8(PChar(p)+5)^[0] , 2 );
   pac64(PChar(p)+373)^[0] := pac64(PChar(p)+373)^[0] - $f01b5d752e;
 end;

 num := pac16(PChar(p)+96)^[0]; pac16(PChar(p)+96)^[0] := pac16(PChar(p)+138)^[0]; pac16(PChar(p)+138)^[0] := num;
 pac32(PChar(p)+14)^[0] := pac32(PChar(p)+14)^[0] + (pac32(PChar(p)+157)^[0] + $602d);
 pac8(PChar(p)+42)^[0] := pac8(PChar(p)+42)^[0] or (pac8(PChar(p)+12)^[0] - $a0);
 pac8(PChar(p)+29)^[0] := pac8(PChar(p)+29)^[0] + (pac8(PChar(p)+334)^[0] xor $b0);
 pac32(PChar(p)+314)^[0] := pac32(PChar(p)+314)^[0] or (pac32(PChar(p)+235)^[0] + $b0b5);
 pac64(PChar(p)+333)^[0] := pac64(PChar(p)+333)^[0] + (pac64(PChar(p)+500)^[0] or $c0654430);
 pac64(PChar(p)+360)^[0] := pac64(PChar(p)+360)^[0] or (pac64(PChar(p)+357)^[0] + $d0793e6cba);

B8E960E5(p);

end;

procedure B8E960E5(p: Pointer);
var num: Int64;
begin

 pac64(PChar(p)+121)^[0] := pac64(PChar(p)+257)^[0] + $80c50241f0;
 pac8(PChar(p)+403)^[0] := pac8(PChar(p)+403)^[0] xor (pac8(PChar(p)+338)^[0] - $90);
 pac16(PChar(p)+464)^[0] := pac16(PChar(p)+464)^[0] xor ror2(pac16(PChar(p)+218)^[0] , 9 );
 num := pac8(PChar(p)+355)^[0]; pac8(PChar(p)+355)^[0] := pac8(PChar(p)+258)^[0]; pac8(PChar(p)+258)^[0] := num;
 pac16(PChar(p)+37)^[0] := pac16(PChar(p)+37)^[0] - ror2(pac16(PChar(p)+285)^[0] , 1 );
 pac32(PChar(p)+60)^[0] := pac32(PChar(p)+60)^[0] xor (pac32(PChar(p)+88)^[0] + $d081);
 pac8(PChar(p)+88)^[0] := pac8(PChar(p)+88)^[0] or $d0;
 pac8(PChar(p)+76)^[0] := pac8(PChar(p)+76)^[0] xor (pac8(PChar(p)+264)^[0] xor $20);
 pac64(PChar(p)+482)^[0] := pac64(PChar(p)+482)^[0] or $d064cf1b;
 if pac32(PChar(p)+138)^[0] > pac32(PChar(p)+122)^[0] then pac32(PChar(p)+256)^[0] := pac32(PChar(p)+487)^[0] - $e0b9;
 pac64(PChar(p)+71)^[0] := pac64(PChar(p)+71)^[0] - $d0b650e11337;
 pac16(PChar(p)+299)^[0] := pac16(PChar(p)+299)^[0] - ror1(pac16(PChar(p)+225)^[0] , 9 );
 pac16(PChar(p)+299)^[0] := pac16(PChar(p)+299)^[0] - $30;
 if pac32(PChar(p)+394)^[0] < pac32(PChar(p)+252)^[0] then begin  num := pac16(PChar(p)+268)^[0]; pac16(PChar(p)+268)^[0] := pac16(PChar(p)+116)^[0]; pac16(PChar(p)+116)^[0] := num; end else begin  num := pac8(PChar(p)+293)^[0]; pac8(PChar(p)+293)^[0] := pac8(PChar(p)+194)^[0]; pac8(PChar(p)+194)^[0] := num; end;
 pac8(PChar(p)+469)^[0] := pac8(PChar(p)+469)^[0] + ror1(pac8(PChar(p)+361)^[0] , 4 );

B99D4182(p);

end;

procedure B99D4182(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+71)^[0] := pac32(PChar(p)+71)^[0] or ror2(pac32(PChar(p)+19)^[0] , 8 );
 pac16(PChar(p)+208)^[0] := pac16(PChar(p)+208)^[0] - ror2(pac16(PChar(p)+219)^[0] , 4 );
 num := pac32(PChar(p)+23)^[0]; pac32(PChar(p)+23)^[0] := pac32(PChar(p)+88)^[0]; pac32(PChar(p)+88)^[0] := num;
 pac64(PChar(p)+283)^[0] := pac64(PChar(p)+283)^[0] - (pac64(PChar(p)+100)^[0] or $80ef125408);

 if pac16(PChar(p)+264)^[0] < pac16(PChar(p)+39)^[0] then begin
   num := pac8(PChar(p)+282)^[0]; pac8(PChar(p)+282)^[0] := pac8(PChar(p)+278)^[0]; pac8(PChar(p)+278)^[0] := num;
   pac64(PChar(p)+429)^[0] := pac64(PChar(p)+361)^[0] + $3099c2ab987f;
   num := pac8(PChar(p)+105)^[0]; pac8(PChar(p)+105)^[0] := pac8(PChar(p)+366)^[0]; pac8(PChar(p)+366)^[0] := num;
 end;


 if pac32(PChar(p)+57)^[0] > pac32(PChar(p)+89)^[0] then begin
   num := pac32(PChar(p)+482)^[0]; pac32(PChar(p)+482)^[0] := pac32(PChar(p)+378)^[0]; pac32(PChar(p)+378)^[0] := num;
   pac32(PChar(p)+229)^[0] := pac32(PChar(p)+229)^[0] xor $40a687;
   pac8(PChar(p)+345)^[0] := pac8(PChar(p)+345)^[0] xor $f0;
   pac32(PChar(p)+119)^[0] := pac32(PChar(p)+119)^[0] or (pac32(PChar(p)+209)^[0] xor $7078);
   num := pac8(PChar(p)+107)^[0]; pac8(PChar(p)+107)^[0] := pac8(PChar(p)+331)^[0]; pac8(PChar(p)+331)^[0] := num;
 end;

 if pac8(PChar(p)+73)^[0] > pac8(PChar(p)+138)^[0] then pac16(PChar(p)+125)^[0] := pac16(PChar(p)+125)^[0] xor rol1(pac16(PChar(p)+346)^[0] , 10 ) else pac8(PChar(p)+236)^[0] := pac8(PChar(p)+236)^[0] or ror2(pac8(PChar(p)+507)^[0] , 6 );

 if pac32(PChar(p)+86)^[0] < pac32(PChar(p)+503)^[0] then begin
   pac32(PChar(p)+406)^[0] := pac32(PChar(p)+406)^[0] + $60be;
   pac16(PChar(p)+97)^[0] := pac16(PChar(p)+97)^[0] xor $c0;
   pac32(PChar(p)+27)^[0] := pac32(PChar(p)+27)^[0] - ror1(pac32(PChar(p)+381)^[0] , 21 );
 end;


 if pac32(PChar(p)+495)^[0] < pac32(PChar(p)+211)^[0] then begin
   num := pac32(PChar(p)+20)^[0]; pac32(PChar(p)+20)^[0] := pac32(PChar(p)+462)^[0]; pac32(PChar(p)+462)^[0] := num;
   if pac16(PChar(p)+379)^[0] > pac16(PChar(p)+478)^[0] then begin  num := pac32(PChar(p)+44)^[0]; pac32(PChar(p)+44)^[0] := pac32(PChar(p)+67)^[0]; pac32(PChar(p)+67)^[0] := num; end else begin  num := pac32(PChar(p)+328)^[0]; pac32(PChar(p)+328)^[0] := pac32(PChar(p)+316)^[0]; pac32(PChar(p)+316)^[0] := num; end;
   pac32(PChar(p)+462)^[0] := pac32(PChar(p)+462)^[0] - rol1(pac32(PChar(p)+53)^[0] , 13 );
   pac64(PChar(p)+125)^[0] := pac64(PChar(p)+125)^[0] - $f01f5d68;
 end;

 pac16(PChar(p)+148)^[0] := pac16(PChar(p)+148)^[0] xor (pac16(PChar(p)+435)^[0] xor $40);
 pac8(PChar(p)+232)^[0] := pac8(PChar(p)+232)^[0] - ror1(pac8(PChar(p)+348)^[0] , 4 );

 if pac16(PChar(p)+199)^[0] < pac16(PChar(p)+394)^[0] then begin
   pac32(PChar(p)+152)^[0] := pac32(PChar(p)+152)^[0] + ror1(pac32(PChar(p)+122)^[0] , 6 );
   pac64(PChar(p)+489)^[0] := pac64(PChar(p)+269)^[0] - $40f1a65a2f2c;
   num := pac8(PChar(p)+150)^[0]; pac8(PChar(p)+150)^[0] := pac8(PChar(p)+402)^[0]; pac8(PChar(p)+402)^[0] := num;
   num := pac32(PChar(p)+315)^[0]; pac32(PChar(p)+315)^[0] := pac32(PChar(p)+489)^[0]; pac32(PChar(p)+489)^[0] := num;
 end;

 pac32(PChar(p)+462)^[0] := pac32(PChar(p)+462)^[0] - (pac32(PChar(p)+177)^[0] + $307201);

 if pac16(PChar(p)+175)^[0] < pac16(PChar(p)+82)^[0] then begin
   pac32(PChar(p)+244)^[0] := pac32(PChar(p)+244)^[0] + rol1(pac32(PChar(p)+490)^[0] , 25 );
   pac32(PChar(p)+59)^[0] := pac32(PChar(p)+59)^[0] + ror1(pac32(PChar(p)+54)^[0] , 10 );
 end;

 if pac16(PChar(p)+316)^[0] < pac16(PChar(p)+141)^[0] then pac64(PChar(p)+35)^[0] := pac64(PChar(p)+35)^[0] - $c051f823a8 else pac8(PChar(p)+276)^[0] := pac8(PChar(p)+276)^[0] + $d0;

B96777CA(p);

end;

procedure B96777CA(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+242)^[0] > pac8(PChar(p)+212)^[0] then pac16(PChar(p)+435)^[0] := pac16(PChar(p)+435)^[0] + ror1(pac16(PChar(p)+164)^[0] , 10 ) else pac8(PChar(p)+358)^[0] := pac8(PChar(p)+358)^[0] or rol1(pac8(PChar(p)+451)^[0] , 3 );
 if pac64(PChar(p)+129)^[0] < pac64(PChar(p)+134)^[0] then pac8(PChar(p)+179)^[0] := pac8(PChar(p)+179)^[0] - $60;
 pac64(PChar(p)+79)^[0] := pac64(PChar(p)+79)^[0] xor $8089fa38;
 pac8(PChar(p)+420)^[0] := pac8(PChar(p)+420)^[0] + ror2(pac8(PChar(p)+321)^[0] , 1 );
 num := pac32(PChar(p)+65)^[0]; pac32(PChar(p)+65)^[0] := pac32(PChar(p)+240)^[0]; pac32(PChar(p)+240)^[0] := num;
 if pac64(PChar(p)+320)^[0] > pac64(PChar(p)+280)^[0] then pac16(PChar(p)+208)^[0] := pac16(PChar(p)+208)^[0] xor ror2(pac16(PChar(p)+302)^[0] , 13 ) else pac64(PChar(p)+456)^[0] := pac64(PChar(p)+9)^[0] or (pac64(PChar(p)+488)^[0] + $102fd94dd8);
 pac16(PChar(p)+106)^[0] := ror2(pac16(PChar(p)+443)^[0] , 12 );
 pac8(PChar(p)+216)^[0] := pac8(PChar(p)+216)^[0] or ror1(pac8(PChar(p)+92)^[0] , 7 );

 if pac64(PChar(p)+421)^[0] < pac64(PChar(p)+272)^[0] then begin
   pac64(PChar(p)+288)^[0] := pac64(PChar(p)+496)^[0] + $e02efe4d7b;
   if pac16(PChar(p)+201)^[0] < pac16(PChar(p)+171)^[0] then begin  num := pac16(PChar(p)+498)^[0]; pac16(PChar(p)+498)^[0] := pac16(PChar(p)+198)^[0]; pac16(PChar(p)+198)^[0] := num; end else pac16(PChar(p)+357)^[0] := pac16(PChar(p)+357)^[0] - ror2(pac16(PChar(p)+187)^[0] , 1 );
 end;

 pac64(PChar(p)+41)^[0] := pac64(PChar(p)+41)^[0] - (pac64(PChar(p)+138)^[0] + $c0bb13b01a);
 pac32(PChar(p)+94)^[0] := pac32(PChar(p)+94)^[0] xor ror2(pac32(PChar(p)+492)^[0] , 10 );
 num := pac32(PChar(p)+293)^[0]; pac32(PChar(p)+293)^[0] := pac32(PChar(p)+324)^[0]; pac32(PChar(p)+324)^[0] := num;
 num := pac32(PChar(p)+200)^[0]; pac32(PChar(p)+200)^[0] := pac32(PChar(p)+316)^[0]; pac32(PChar(p)+316)^[0] := num;
 pac8(PChar(p)+98)^[0] := pac8(PChar(p)+98)^[0] xor ror2(pac8(PChar(p)+390)^[0] , 3 );

 if pac64(PChar(p)+364)^[0] < pac64(PChar(p)+133)^[0] then begin
   num := pac16(PChar(p)+399)^[0]; pac16(PChar(p)+399)^[0] := pac16(PChar(p)+264)^[0]; pac16(PChar(p)+264)^[0] := num;
   pac8(PChar(p)+205)^[0] := pac8(PChar(p)+205)^[0] + (pac8(PChar(p)+307)^[0] xor $10);
   pac16(PChar(p)+192)^[0] := pac16(PChar(p)+192)^[0] + $10;
 end;

 pac8(PChar(p)+350)^[0] := ror2(pac8(PChar(p)+133)^[0] , 5 );
 if pac64(PChar(p)+209)^[0] < pac64(PChar(p)+123)^[0] then pac64(PChar(p)+414)^[0] := pac64(PChar(p)+414)^[0] xor (pac64(PChar(p)+196)^[0] xor $4034912c) else begin  num := pac16(PChar(p)+336)^[0]; pac16(PChar(p)+336)^[0] := pac16(PChar(p)+211)^[0]; pac16(PChar(p)+211)^[0] := num; end;
 pac16(PChar(p)+490)^[0] := pac16(PChar(p)+490)^[0] + ror2(pac16(PChar(p)+228)^[0] , 12 );

ADA9C708(p);

end;

procedure ADA9C708(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+454)^[0] < pac32(PChar(p)+296)^[0] then begin  num := pac16(PChar(p)+107)^[0]; pac16(PChar(p)+107)^[0] := pac16(PChar(p)+472)^[0]; pac16(PChar(p)+472)^[0] := num; end else pac16(PChar(p)+476)^[0] := pac16(PChar(p)+476)^[0] xor (pac16(PChar(p)+460)^[0] xor $20);

 if pac8(PChar(p)+173)^[0] > pac8(PChar(p)+42)^[0] then begin
   if pac32(PChar(p)+231)^[0] < pac32(PChar(p)+297)^[0] then pac64(PChar(p)+32)^[0] := pac64(PChar(p)+32)^[0] xor (pac64(PChar(p)+356)^[0] xor $6055715f) else begin  num := pac16(PChar(p)+47)^[0]; pac16(PChar(p)+47)^[0] := pac16(PChar(p)+221)^[0]; pac16(PChar(p)+221)^[0] := num; end;
   pac8(PChar(p)+442)^[0] := pac8(PChar(p)+442)^[0] - ror1(pac8(PChar(p)+353)^[0] , 4 );
   pac64(PChar(p)+126)^[0] := pac64(PChar(p)+126)^[0] + $b03ee8396e;
   pac8(PChar(p)+368)^[0] := pac8(PChar(p)+368)^[0] - $c2;
 end;

 pac8(PChar(p)+209)^[0] := pac8(PChar(p)+209)^[0] - ror2(pac8(PChar(p)+137)^[0] , 5 );
 pac32(PChar(p)+424)^[0] := pac32(PChar(p)+424)^[0] xor ror2(pac32(PChar(p)+507)^[0] , 31 );
 pac32(PChar(p)+131)^[0] := ror2(pac32(PChar(p)+369)^[0] , 12 );
 pac16(PChar(p)+242)^[0] := pac16(PChar(p)+242)^[0] + ror2(pac16(PChar(p)+19)^[0] , 9 );
 num := pac32(PChar(p)+420)^[0]; pac32(PChar(p)+420)^[0] := pac32(PChar(p)+106)^[0]; pac32(PChar(p)+106)^[0] := num;

 if pac64(PChar(p)+435)^[0] < pac64(PChar(p)+29)^[0] then begin
   pac64(PChar(p)+46)^[0] := pac64(PChar(p)+46)^[0] or $d0c1642db1;
   if pac64(PChar(p)+393)^[0] < pac64(PChar(p)+500)^[0] then pac32(PChar(p)+200)^[0] := pac32(PChar(p)+200)^[0] or $c042ff else pac64(PChar(p)+396)^[0] := pac64(PChar(p)+396)^[0] - (pac64(PChar(p)+211)^[0] - $50fc3939f8);
   num := pac32(PChar(p)+215)^[0]; pac32(PChar(p)+215)^[0] := pac32(PChar(p)+126)^[0]; pac32(PChar(p)+126)^[0] := num;
 end;

 pac32(PChar(p)+500)^[0] := pac32(PChar(p)+500)^[0] + $9085a3;
 pac64(PChar(p)+398)^[0] := pac64(PChar(p)+398)^[0] - $0031e69474da;
 pac16(PChar(p)+181)^[0] := pac16(PChar(p)+181)^[0] xor rol1(pac16(PChar(p)+344)^[0] , 10 );
 pac64(PChar(p)+203)^[0] := pac64(PChar(p)+487)^[0] or $40c194d09afd;
 pac8(PChar(p)+446)^[0] := pac8(PChar(p)+392)^[0] - $a0;
 pac32(PChar(p)+220)^[0] := pac32(PChar(p)+227)^[0] + (pac32(PChar(p)+131)^[0] xor $e0b6);
 if pac8(PChar(p)+17)^[0] < pac8(PChar(p)+298)^[0] then pac8(PChar(p)+248)^[0] := pac8(PChar(p)+248)^[0] or $e0 else pac16(PChar(p)+408)^[0] := pac16(PChar(p)+147)^[0] - $10;

F62AA173(p);

end;

procedure F62AA173(p: Pointer);
var num: Int64;
begin


 if pac64(PChar(p)+335)^[0] < pac64(PChar(p)+253)^[0] then begin
   pac8(PChar(p)+218)^[0] := pac8(PChar(p)+218)^[0] - $b0;
   pac8(PChar(p)+206)^[0] := pac8(PChar(p)+367)^[0] xor (pac8(PChar(p)+12)^[0] xor $80);
   num := pac32(PChar(p)+114)^[0]; pac32(PChar(p)+114)^[0] := pac32(PChar(p)+15)^[0]; pac32(PChar(p)+15)^[0] := num;
 end;

 pac64(PChar(p)+53)^[0] := pac64(PChar(p)+53)^[0] or $c01ef7f4;
 pac8(PChar(p)+125)^[0] := pac8(PChar(p)+125)^[0] or ror1(pac8(PChar(p)+168)^[0] , 2 );
 pac16(PChar(p)+21)^[0] := pac16(PChar(p)+21)^[0] + ror2(pac16(PChar(p)+361)^[0] , 3 );

 if pac8(PChar(p)+85)^[0] < pac8(PChar(p)+111)^[0] then begin
   if pac64(PChar(p)+454)^[0] > pac64(PChar(p)+303)^[0] then pac64(PChar(p)+470)^[0] := pac64(PChar(p)+470)^[0] - (pac64(PChar(p)+123)^[0] + $80603f345b98) else pac64(PChar(p)+326)^[0] := pac64(PChar(p)+385)^[0] + $f0cb75deec;
   pac64(PChar(p)+183)^[0] := pac64(PChar(p)+183)^[0] + $704288940d;
   pac64(PChar(p)+0)^[0] := pac64(PChar(p)+0)^[0] xor (pac64(PChar(p)+59)^[0] xor $a0740702);
 end;

 pac16(PChar(p)+495)^[0] := pac16(PChar(p)+495)^[0] or ror1(pac16(PChar(p)+320)^[0] , 14 );
 pac64(PChar(p)+389)^[0] := pac64(PChar(p)+389)^[0] or $202e283c37;
 if pac64(PChar(p)+417)^[0] > pac64(PChar(p)+152)^[0] then pac64(PChar(p)+246)^[0] := pac64(PChar(p)+246)^[0] or $1041efa6;
 pac64(PChar(p)+273)^[0] := pac64(PChar(p)+187)^[0] xor $a020b7bb32;
 pac32(PChar(p)+479)^[0] := ror2(pac32(PChar(p)+422)^[0] , 13 );
 pac16(PChar(p)+73)^[0] := pac16(PChar(p)+313)^[0] or $f0;

 if pac64(PChar(p)+324)^[0] > pac64(PChar(p)+402)^[0] then begin
   pac16(PChar(p)+1)^[0] := ror2(pac16(PChar(p)+359)^[0] , 5 );
   if pac16(PChar(p)+374)^[0] < pac16(PChar(p)+377)^[0] then pac64(PChar(p)+133)^[0] := pac64(PChar(p)+133)^[0] xor (pac64(PChar(p)+243)^[0] - $00c5850c6acd) else pac32(PChar(p)+75)^[0] := pac32(PChar(p)+75)^[0] or $20dbad;
   num := pac32(PChar(p)+346)^[0]; pac32(PChar(p)+346)^[0] := pac32(PChar(p)+256)^[0]; pac32(PChar(p)+256)^[0] := num;
 end;

 pac64(PChar(p)+220)^[0] := pac64(PChar(p)+220)^[0] or $50c963d0e0;
 pac8(PChar(p)+391)^[0] := pac8(PChar(p)+391)^[0] xor ror2(pac8(PChar(p)+251)^[0] , 5 );

CF6F8A8F(p);

end;

procedure CF6F8A8F(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+312)^[0] := pac8(PChar(p)+312)^[0] xor ror1(pac8(PChar(p)+441)^[0] , 4 );
 pac8(PChar(p)+342)^[0] := pac8(PChar(p)+342)^[0] or $40;
 pac16(PChar(p)+329)^[0] := pac16(PChar(p)+329)^[0] or (pac16(PChar(p)+294)^[0] xor $d0);
 pac16(PChar(p)+357)^[0] := pac16(PChar(p)+91)^[0] - (pac16(PChar(p)+149)^[0] or $10);
 pac64(PChar(p)+255)^[0] := pac64(PChar(p)+255)^[0] xor (pac64(PChar(p)+280)^[0] + $00dda540cfb6);
 num := pac32(PChar(p)+201)^[0]; pac32(PChar(p)+201)^[0] := pac32(PChar(p)+422)^[0]; pac32(PChar(p)+422)^[0] := num;
 num := pac32(PChar(p)+32)^[0]; pac32(PChar(p)+32)^[0] := pac32(PChar(p)+424)^[0]; pac32(PChar(p)+424)^[0] := num;

 if pac16(PChar(p)+137)^[0] > pac16(PChar(p)+133)^[0] then begin
   pac64(PChar(p)+355)^[0] := pac64(PChar(p)+355)^[0] xor (pac64(PChar(p)+132)^[0] or $c0123ead);
   pac32(PChar(p)+115)^[0] := ror2(pac32(PChar(p)+2)^[0] , 20 );
   num := pac32(PChar(p)+477)^[0]; pac32(PChar(p)+477)^[0] := pac32(PChar(p)+111)^[0]; pac32(PChar(p)+111)^[0] := num;
   pac64(PChar(p)+449)^[0] := pac64(PChar(p)+449)^[0] - (pac64(PChar(p)+396)^[0] - $c0c604a20261);
 end;

 pac16(PChar(p)+303)^[0] := pac16(PChar(p)+303)^[0] - (pac16(PChar(p)+299)^[0] + $80);
 if pac8(PChar(p)+193)^[0] < pac8(PChar(p)+506)^[0] then pac64(PChar(p)+31)^[0] := pac64(PChar(p)+31)^[0] + $901ec752 else pac64(PChar(p)+354)^[0] := pac64(PChar(p)+354)^[0] + $d0334123;

 if pac32(PChar(p)+266)^[0] < pac32(PChar(p)+129)^[0] then begin
   if pac32(PChar(p)+252)^[0] > pac32(PChar(p)+255)^[0] then pac8(PChar(p)+349)^[0] := pac8(PChar(p)+349)^[0] or rol1(pac8(PChar(p)+466)^[0] , 3 );
   pac64(PChar(p)+447)^[0] := pac64(PChar(p)+447)^[0] xor $50307b94d644;
   if pac32(PChar(p)+247)^[0] > pac32(PChar(p)+462)^[0] then pac32(PChar(p)+432)^[0] := pac32(PChar(p)+432)^[0] - (pac32(PChar(p)+498)^[0] or $b01fa9) else pac16(PChar(p)+249)^[0] := pac16(PChar(p)+249)^[0] - (pac16(PChar(p)+448)^[0] + $f0);
 end;


 if pac32(PChar(p)+483)^[0] > pac32(PChar(p)+363)^[0] then begin
   num := pac16(PChar(p)+75)^[0]; pac16(PChar(p)+75)^[0] := pac16(PChar(p)+100)^[0]; pac16(PChar(p)+100)^[0] := num;
   pac32(PChar(p)+223)^[0] := pac32(PChar(p)+223)^[0] + (pac32(PChar(p)+67)^[0] or $50999e);
   if pac32(PChar(p)+460)^[0] > pac32(PChar(p)+166)^[0] then pac64(PChar(p)+288)^[0] := pac64(PChar(p)+288)^[0] + (pac64(PChar(p)+473)^[0] + $90317aba) else begin  num := pac32(PChar(p)+480)^[0]; pac32(PChar(p)+480)^[0] := pac32(PChar(p)+481)^[0]; pac32(PChar(p)+481)^[0] := num; end;
   num := pac8(PChar(p)+288)^[0]; pac8(PChar(p)+288)^[0] := pac8(PChar(p)+500)^[0]; pac8(PChar(p)+500)^[0] := num;
   if pac32(PChar(p)+178)^[0] < pac32(PChar(p)+385)^[0] then pac32(PChar(p)+431)^[0] := pac32(PChar(p)+431)^[0] - (pac32(PChar(p)+373)^[0] xor $80c729) else begin  num := pac16(PChar(p)+243)^[0]; pac16(PChar(p)+243)^[0] := pac16(PChar(p)+127)^[0]; pac16(PChar(p)+127)^[0] := num; end;
 end;

 pac64(PChar(p)+443)^[0] := pac64(PChar(p)+443)^[0] + $e0ad74ba;

F3B49976(p);

end;

procedure F3B49976(p: Pointer);
var num: Int64;
begin

 pac8(PChar(p)+425)^[0] := pac8(PChar(p)+425)^[0] + $70;
 pac64(PChar(p)+26)^[0] := pac64(PChar(p)+26)^[0] + $605e3674baae;
 pac8(PChar(p)+375)^[0] := pac8(PChar(p)+375)^[0] + ror2(pac8(PChar(p)+394)^[0] , 7 );
 pac8(PChar(p)+82)^[0] := pac8(PChar(p)+82)^[0] xor $b0;
 if pac64(PChar(p)+408)^[0] > pac64(PChar(p)+86)^[0] then pac8(PChar(p)+17)^[0] := pac8(PChar(p)+17)^[0] or $50 else begin  num := pac32(PChar(p)+146)^[0]; pac32(PChar(p)+146)^[0] := pac32(PChar(p)+134)^[0]; pac32(PChar(p)+134)^[0] := num; end;
 pac32(PChar(p)+437)^[0] := pac32(PChar(p)+437)^[0] + rol1(pac32(PChar(p)+210)^[0] , 22 );
 pac32(PChar(p)+197)^[0] := pac32(PChar(p)+197)^[0] - (pac32(PChar(p)+371)^[0] + $0024);
 num := pac16(PChar(p)+374)^[0]; pac16(PChar(p)+374)^[0] := pac16(PChar(p)+124)^[0]; pac16(PChar(p)+124)^[0] := num;
 pac32(PChar(p)+7)^[0] := pac32(PChar(p)+7)^[0] - $4030a4;
 pac8(PChar(p)+121)^[0] := pac8(PChar(p)+121)^[0] xor $30;
 pac8(PChar(p)+451)^[0] := pac8(PChar(p)+451)^[0] - ror2(pac8(PChar(p)+407)^[0] , 7 );
 num := pac8(PChar(p)+150)^[0]; pac8(PChar(p)+150)^[0] := pac8(PChar(p)+239)^[0]; pac8(PChar(p)+239)^[0] := num;
 pac64(PChar(p)+207)^[0] := pac64(PChar(p)+207)^[0] or $00653db7d6a9;

B68F2907(p);

end;

procedure B68F2907(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+68)^[0] := pac32(PChar(p)+68)^[0] + $d0546a;

 if pac16(PChar(p)+124)^[0] < pac16(PChar(p)+206)^[0] then begin
   pac64(PChar(p)+304)^[0] := pac64(PChar(p)+304)^[0] - (pac64(PChar(p)+356)^[0] xor $f6917e0c74);
   pac32(PChar(p)+416)^[0] := pac32(PChar(p)+416)^[0] xor ror1(pac32(PChar(p)+374)^[0] , 9 );
   pac32(PChar(p)+361)^[0] := pac32(PChar(p)+361)^[0] xor (pac32(PChar(p)+70)^[0] + $dccf);
 end;

 if pac64(PChar(p)+474)^[0] > pac64(PChar(p)+115)^[0] then pac64(PChar(p)+84)^[0] := pac64(PChar(p)+84)^[0] - $20725844868e else pac8(PChar(p)+132)^[0] := pac8(PChar(p)+132)^[0] or rol1(pac8(PChar(p)+27)^[0] , 6 );
 pac64(PChar(p)+224)^[0] := pac64(PChar(p)+224)^[0] - $d0043cbd;

 if pac16(PChar(p)+341)^[0] < pac16(PChar(p)+165)^[0] then begin
   pac64(PChar(p)+251)^[0] := pac64(PChar(p)+251)^[0] - (pac64(PChar(p)+504)^[0] or $686d281182);
   pac32(PChar(p)+406)^[0] := pac32(PChar(p)+406)^[0] - (pac32(PChar(p)+85)^[0] + $6a590f);
   num := pac16(PChar(p)+69)^[0]; pac16(PChar(p)+69)^[0] := pac16(PChar(p)+506)^[0]; pac16(PChar(p)+506)^[0] := num;
 end;

 pac32(PChar(p)+37)^[0] := pac32(PChar(p)+37)^[0] or rol1(pac32(PChar(p)+467)^[0] , 30 );
 pac64(PChar(p)+327)^[0] := pac64(PChar(p)+327)^[0] + (pac64(PChar(p)+484)^[0] - $74b8dd6c);
 pac8(PChar(p)+272)^[0] := pac8(PChar(p)+272)^[0] xor (pac8(PChar(p)+159)^[0] - $88);

 if pac8(PChar(p)+26)^[0] < pac8(PChar(p)+171)^[0] then begin
   if pac8(PChar(p)+477)^[0] < pac8(PChar(p)+400)^[0] then pac32(PChar(p)+1)^[0] := pac32(PChar(p)+1)^[0] or $dece43 else pac64(PChar(p)+408)^[0] := pac64(PChar(p)+408)^[0] or (pac64(PChar(p)+54)^[0] + $f8242c3efc74);
   pac32(PChar(p)+393)^[0] := pac32(PChar(p)+393)^[0] xor $6ebfa5;
 end;

 if pac16(PChar(p)+238)^[0] < pac16(PChar(p)+296)^[0] then pac64(PChar(p)+201)^[0] := pac64(PChar(p)+201)^[0] - $266dd617185a else pac32(PChar(p)+144)^[0] := pac32(PChar(p)+144)^[0] xor $42d587;
 pac64(PChar(p)+380)^[0] := pac64(PChar(p)+73)^[0] - (pac64(PChar(p)+74)^[0] - $c05f8cc6ec);
 num := pac32(PChar(p)+42)^[0]; pac32(PChar(p)+42)^[0] := pac32(PChar(p)+323)^[0]; pac32(PChar(p)+323)^[0] := num;
 pac16(PChar(p)+233)^[0] := pac16(PChar(p)+233)^[0] or $b0;

C0113E8F(p);

end;

procedure C0113E8F(p: Pointer);
var num: Int64;
begin

 num := pac16(PChar(p)+479)^[0]; pac16(PChar(p)+479)^[0] := pac16(PChar(p)+492)^[0]; pac16(PChar(p)+492)^[0] := num;
 pac64(PChar(p)+387)^[0] := pac64(PChar(p)+387)^[0] - (pac64(PChar(p)+85)^[0] or $22ccdfd53b);
 pac16(PChar(p)+373)^[0] := pac16(PChar(p)+373)^[0] xor $f0;
 if pac16(PChar(p)+377)^[0] > pac16(PChar(p)+450)^[0] then pac32(PChar(p)+485)^[0] := pac32(PChar(p)+485)^[0] + (pac32(PChar(p)+351)^[0] - $f22e) else pac32(PChar(p)+217)^[0] := pac32(PChar(p)+217)^[0] or ror1(pac32(PChar(p)+386)^[0] , 4 );

 if pac64(PChar(p)+102)^[0] < pac64(PChar(p)+151)^[0] then begin
   pac64(PChar(p)+76)^[0] := pac64(PChar(p)+76)^[0] + (pac64(PChar(p)+200)^[0] or $9a1e11c1b2);
   num := pac16(PChar(p)+26)^[0]; pac16(PChar(p)+26)^[0] := pac16(PChar(p)+14)^[0]; pac16(PChar(p)+14)^[0] := num;
   num := pac8(PChar(p)+307)^[0]; pac8(PChar(p)+307)^[0] := pac8(PChar(p)+20)^[0]; pac8(PChar(p)+20)^[0] := num;
 end;

 num := pac8(PChar(p)+450)^[0]; pac8(PChar(p)+450)^[0] := pac8(PChar(p)+289)^[0]; pac8(PChar(p)+289)^[0] := num;

 if pac64(PChar(p)+437)^[0] < pac64(PChar(p)+126)^[0] then begin
   pac16(PChar(p)+282)^[0] := pac16(PChar(p)+282)^[0] or ror2(pac16(PChar(p)+206)^[0] , 14 );
   num := pac16(PChar(p)+231)^[0]; pac16(PChar(p)+231)^[0] := pac16(PChar(p)+247)^[0]; pac16(PChar(p)+247)^[0] := num;
   pac64(PChar(p)+230)^[0] := pac64(PChar(p)+230)^[0] - (pac64(PChar(p)+271)^[0] + $60141bdd3d);
   pac32(PChar(p)+100)^[0] := pac32(PChar(p)+100)^[0] or ror2(pac32(PChar(p)+174)^[0] , 16 );
   pac16(PChar(p)+130)^[0] := pac16(PChar(p)+130)^[0] xor rol1(pac16(PChar(p)+162)^[0] , 6 );
 end;

 if pac16(PChar(p)+167)^[0] > pac16(PChar(p)+496)^[0] then pac64(PChar(p)+141)^[0] := pac64(PChar(p)+59)^[0] or $f6b840abfa2c else begin  num := pac32(PChar(p)+63)^[0]; pac32(PChar(p)+63)^[0] := pac32(PChar(p)+22)^[0]; pac32(PChar(p)+22)^[0] := num; end;
 pac64(PChar(p)+162)^[0] := pac64(PChar(p)+162)^[0] - $3c4d60ad;

 if pac64(PChar(p)+399)^[0] > pac64(PChar(p)+20)^[0] then begin
   pac16(PChar(p)+278)^[0] := pac16(PChar(p)+510)^[0] xor $a6;
   if pac32(PChar(p)+412)^[0] < pac32(PChar(p)+508)^[0] then pac64(PChar(p)+177)^[0] := pac64(PChar(p)+177)^[0] or $c267018852 else pac8(PChar(p)+173)^[0] := pac8(PChar(p)+173)^[0] or ror2(pac8(PChar(p)+294)^[0] , 4 );
   pac32(PChar(p)+279)^[0] := pac32(PChar(p)+279)^[0] - (pac32(PChar(p)+273)^[0] or $f20530);
 end;

 if pac32(PChar(p)+5)^[0] > pac32(PChar(p)+216)^[0] then begin  num := pac8(PChar(p)+442)^[0]; pac8(PChar(p)+442)^[0] := pac8(PChar(p)+401)^[0]; pac8(PChar(p)+401)^[0] := num; end;

 if pac8(PChar(p)+14)^[0] < pac8(PChar(p)+330)^[0] then begin
   if pac32(PChar(p)+219)^[0] < pac32(PChar(p)+41)^[0] then pac64(PChar(p)+292)^[0] := pac64(PChar(p)+406)^[0] or $f6b63dce else begin  num := pac16(PChar(p)+403)^[0]; pac16(PChar(p)+403)^[0] := pac16(PChar(p)+12)^[0]; pac16(PChar(p)+12)^[0] := num; end;
   pac16(PChar(p)+277)^[0] := pac16(PChar(p)+289)^[0] + (pac16(PChar(p)+164)^[0] xor $34);
 end;

 pac32(PChar(p)+343)^[0] := pac32(PChar(p)+343)^[0] + (pac32(PChar(p)+64)^[0] xor $9ccc5d);

B86DF0E9(p);

end;

procedure B86DF0E9(p: Pointer);
var num: Int64;
begin

 if pac32(PChar(p)+68)^[0] < pac32(PChar(p)+354)^[0] then begin  num := pac32(PChar(p)+22)^[0]; pac32(PChar(p)+22)^[0] := pac32(PChar(p)+386)^[0]; pac32(PChar(p)+386)^[0] := num; end else pac16(PChar(p)+164)^[0] := pac16(PChar(p)+164)^[0] xor $4a;
 num := pac8(PChar(p)+158)^[0]; pac8(PChar(p)+158)^[0] := pac8(PChar(p)+113)^[0]; pac8(PChar(p)+113)^[0] := num;
 pac16(PChar(p)+7)^[0] := pac16(PChar(p)+7)^[0] + $ea;
 pac64(PChar(p)+80)^[0] := pac64(PChar(p)+497)^[0] xor (pac64(PChar(p)+81)^[0] xor $2230e60aa9f6);
 if pac16(PChar(p)+28)^[0] < pac16(PChar(p)+36)^[0] then pac16(PChar(p)+401)^[0] := pac16(PChar(p)+401)^[0] - (pac16(PChar(p)+446)^[0] xor $1a) else begin  num := pac32(PChar(p)+51)^[0]; pac32(PChar(p)+51)^[0] := pac32(PChar(p)+327)^[0]; pac32(PChar(p)+327)^[0] := num; end;
 pac64(PChar(p)+377)^[0] := pac64(PChar(p)+377)^[0] - (pac64(PChar(p)+158)^[0] xor $e87b2c69970f);
 if pac16(PChar(p)+72)^[0] < pac16(PChar(p)+362)^[0] then begin  num := pac8(PChar(p)+359)^[0]; pac8(PChar(p)+359)^[0] := pac8(PChar(p)+36)^[0]; pac8(PChar(p)+36)^[0] := num; end else pac64(PChar(p)+398)^[0] := pac64(PChar(p)+357)^[0] xor (pac64(PChar(p)+426)^[0] xor $6e707014);
 if pac32(PChar(p)+175)^[0] > pac32(PChar(p)+194)^[0] then pac8(PChar(p)+385)^[0] := pac8(PChar(p)+385)^[0] xor (pac8(PChar(p)+145)^[0] xor $d2);
 pac64(PChar(p)+492)^[0] := pac64(PChar(p)+492)^[0] - $8cd89450b645;
 if pac64(PChar(p)+217)^[0] > pac64(PChar(p)+454)^[0] then pac64(PChar(p)+114)^[0] := pac64(PChar(p)+114)^[0] or $3cf9eed4b0 else pac64(PChar(p)+437)^[0] := pac64(PChar(p)+37)^[0] xor $7491030d;

A613F223(p);

end;

procedure A613F223(p: Pointer);
var num: Int64;
begin

 if pac8(PChar(p)+43)^[0] > pac8(PChar(p)+109)^[0] then pac32(PChar(p)+389)^[0] := ror2(pac32(PChar(p)+88)^[0] , 22 ) else pac64(PChar(p)+370)^[0] := pac64(PChar(p)+370)^[0] or $4c3d6544a8;

 if pac16(PChar(p)+114)^[0] < pac16(PChar(p)+3)^[0] then begin
   pac32(PChar(p)+143)^[0] := pac32(PChar(p)+143)^[0] or (pac32(PChar(p)+313)^[0] xor $447e);
   pac32(PChar(p)+382)^[0] := pac32(PChar(p)+382)^[0] + (pac32(PChar(p)+76)^[0] or $aac09a);
 end;

 pac64(PChar(p)+485)^[0] := pac64(PChar(p)+485)^[0] - (pac64(PChar(p)+22)^[0] or $820143c9);
 pac64(PChar(p)+217)^[0] := pac64(PChar(p)+217)^[0] xor $e0e3b6a97670;
 pac64(PChar(p)+369)^[0] := pac64(PChar(p)+369)^[0] xor $c251cc0121;
 pac8(PChar(p)+315)^[0] := pac8(PChar(p)+315)^[0] + (pac8(PChar(p)+50)^[0] - $f6);
 pac32(PChar(p)+3)^[0] := pac32(PChar(p)+3)^[0] xor $6c9684;
 num := pac8(PChar(p)+205)^[0]; pac8(PChar(p)+205)^[0] := pac8(PChar(p)+128)^[0]; pac8(PChar(p)+128)^[0] := num;
 pac32(PChar(p)+391)^[0] := pac32(PChar(p)+391)^[0] + ror1(pac32(PChar(p)+282)^[0] , 16 );

 if pac16(PChar(p)+226)^[0] < pac16(PChar(p)+103)^[0] then begin
   pac64(PChar(p)+267)^[0] := pac64(PChar(p)+179)^[0] xor (pac64(PChar(p)+401)^[0] + $286d6d7367ca);
   pac32(PChar(p)+504)^[0] := pac32(PChar(p)+504)^[0] xor ror2(pac32(PChar(p)+337)^[0] , 25 );
   num := pac16(PChar(p)+123)^[0]; pac16(PChar(p)+123)^[0] := pac16(PChar(p)+309)^[0]; pac16(PChar(p)+309)^[0] := num;
 end;

 pac32(PChar(p)+146)^[0] := pac32(PChar(p)+101)^[0] - (pac32(PChar(p)+158)^[0] - $18f932);
 pac64(PChar(p)+172)^[0] := pac64(PChar(p)+172)^[0] + (pac64(PChar(p)+13)^[0] xor $0e13f6c2);

if pac16(PChar(p)+126)^[0] < pac16(PChar(p)+303)^[0] then AD4BF819(p)
 else BB9319A1(p);

end;

procedure AD4BF819(p: Pointer);
var num: Int64;
begin

 if pac64(PChar(p)+219)^[0] < pac64(PChar(p)+495)^[0] then pac64(PChar(p)+275)^[0] := pac64(PChar(p)+275)^[0] xor $22d28654 else begin  num := pac8(PChar(p)+299)^[0]; pac8(PChar(p)+299)^[0] := pac8(PChar(p)+88)^[0]; pac8(PChar(p)+88)^[0] := num; end;
 num := pac8(PChar(p)+42)^[0]; pac8(PChar(p)+42)^[0] := pac8(PChar(p)+271)^[0]; pac8(PChar(p)+271)^[0] := num;

 if pac64(PChar(p)+501)^[0] < pac64(PChar(p)+138)^[0] then begin
   pac8(PChar(p)+167)^[0] := pac8(PChar(p)+167)^[0] xor $9c;
   if pac64(PChar(p)+97)^[0] > pac64(PChar(p)+411)^[0] then begin  num := pac32(PChar(p)+478)^[0]; pac32(PChar(p)+478)^[0] := pac32(PChar(p)+303)^[0]; pac32(PChar(p)+303)^[0] := num; end;
   pac8(PChar(p)+62)^[0] := pac8(PChar(p)+62)^[0] xor $de;
 end;

 num := pac32(PChar(p)+297)^[0]; pac32(PChar(p)+297)^[0] := pac32(PChar(p)+458)^[0]; pac32(PChar(p)+458)^[0] := num;
 pac16(PChar(p)+136)^[0] := pac16(PChar(p)+136)^[0] xor rol1(pac16(PChar(p)+170)^[0] , 10 );

 if pac16(PChar(p)+161)^[0] < pac16(PChar(p)+378)^[0] then begin
   pac32(PChar(p)+242)^[0] := pac32(PChar(p)+242)^[0] xor $1018;
   pac16(PChar(p)+443)^[0] := pac16(PChar(p)+443)^[0] + (pac16(PChar(p)+1)^[0] xor $bc);
   pac64(PChar(p)+340)^[0] := pac64(PChar(p)+340)^[0] - $a846c56043;
   if pac16(PChar(p)+206)^[0] > pac16(PChar(p)+191)^[0] then begin  num := pac16(PChar(p)+103)^[0]; pac16(PChar(p)+103)^[0] := pac16(PChar(p)+59)^[0]; pac16(PChar(p)+59)^[0] := num; end else pac64(PChar(p)+66)^[0] := pac64(PChar(p)+66)^[0] + (pac64(PChar(p)+309)^[0] or $2c42b289);
   num := pac8(PChar(p)+435)^[0]; pac8(PChar(p)+435)^[0] := pac8(PChar(p)+47)^[0]; pac8(PChar(p)+47)^[0] := num;
 end;

 pac16(PChar(p)+234)^[0] := pac16(PChar(p)+234)^[0] + ror2(pac16(PChar(p)+381)^[0] , 6 );
 pac64(PChar(p)+364)^[0] := pac64(PChar(p)+364)^[0] or $1843346c;
 if pac32(PChar(p)+302)^[0] < pac32(PChar(p)+387)^[0] then pac16(PChar(p)+132)^[0] := ror2(pac16(PChar(p)+11)^[0] , 6 ) else pac16(PChar(p)+470)^[0] := pac16(PChar(p)+470)^[0] - $98;

 if pac16(PChar(p)+285)^[0] < pac16(PChar(p)+265)^[0] then begin
   pac8(PChar(p)+83)^[0] := pac8(PChar(p)+83)^[0] - ror2(pac8(PChar(p)+285)^[0] , 7 );
   num := pac8(PChar(p)+487)^[0]; pac8(PChar(p)+487)^[0] := pac8(PChar(p)+32)^[0]; pac8(PChar(p)+32)^[0] := num;
 end;

 num := pac32(PChar(p)+160)^[0]; pac32(PChar(p)+160)^[0] := pac32(PChar(p)+211)^[0]; pac32(PChar(p)+211)^[0] := num;

 if pac16(PChar(p)+500)^[0] > pac16(PChar(p)+273)^[0] then begin
   if pac16(PChar(p)+453)^[0] < pac16(PChar(p)+366)^[0] then begin  num := pac32(PChar(p)+312)^[0]; pac32(PChar(p)+312)^[0] := pac32(PChar(p)+222)^[0]; pac32(PChar(p)+222)^[0] := num; end else pac8(PChar(p)+385)^[0] := pac8(PChar(p)+385)^[0] - ror2(pac8(PChar(p)+214)^[0] , 5 );
   pac8(PChar(p)+414)^[0] := pac8(PChar(p)+414)^[0] xor (pac8(PChar(p)+407)^[0] xor $40);
   pac32(PChar(p)+102)^[0] := pac32(PChar(p)+102)^[0] + $2cf662;
   pac32(PChar(p)+215)^[0] := pac32(PChar(p)+501)^[0] - $4ede;
   pac16(PChar(p)+416)^[0] := pac16(PChar(p)+503)^[0] or (pac16(PChar(p)+391)^[0] xor $84);
 end;

 pac64(PChar(p)+222)^[0] := pac64(PChar(p)+222)^[0] xor (pac64(PChar(p)+241)^[0] xor $a20a817aa3);
 pac8(PChar(p)+506)^[0] := pac8(PChar(p)+505)^[0] + $8a;
 num := pac32(PChar(p)+62)^[0]; pac32(PChar(p)+62)^[0] := pac32(PChar(p)+297)^[0]; pac32(PChar(p)+297)^[0] := num;
 pac64(PChar(p)+146)^[0] := pac64(PChar(p)+146)^[0] + (pac64(PChar(p)+136)^[0] or $d4508e7f3309);

BB9319A1(p);

end;

procedure BB9319A1(p: Pointer);
var num: Int64;
begin

 pac32(PChar(p)+228)^[0] := pac32(PChar(p)+228)^[0] - $a80f22;
 num := pac8(PChar(p)+448)^[0]; pac8(PChar(p)+448)^[0] := pac8(PChar(p)+427)^[0]; pac8(PChar(p)+427)^[0] := num;
 pac32(PChar(p)+342)^[0] := pac32(PChar(p)+342)^[0] - rol1(pac32(PChar(p)+374)^[0] , 13 );
 num := pac16(PChar(p)+55)^[0]; pac16(PChar(p)+55)^[0] := pac16(PChar(p)+101)^[0]; pac16(PChar(p)+101)^[0] := num;
 pac8(PChar(p)+429)^[0] := pac8(PChar(p)+429)^[0] + rol1(pac8(PChar(p)+444)^[0] , 6 );
 pac8(PChar(p)+162)^[0] := ror1(pac8(PChar(p)+345)^[0] , 7 );

 if pac64(PChar(p)+184)^[0] > pac64(PChar(p)+96)^[0] then begin
   pac32(PChar(p)+331)^[0] := pac32(PChar(p)+331)^[0] xor (pac32(PChar(p)+489)^[0] - $d2c7a5);
   if pac8(PChar(p)+484)^[0] < pac8(PChar(p)+291)^[0] then begin  num := pac32(PChar(p)+472)^[0]; pac32(PChar(p)+472)^[0] := pac32(PChar(p)+391)^[0]; pac32(PChar(p)+391)^[0] := num; end else pac16(PChar(p)+222)^[0] := pac16(PChar(p)+222)^[0] + ror2(pac16(PChar(p)+267)^[0] , 11 );
   if pac16(PChar(p)+387)^[0] > pac16(PChar(p)+132)^[0] then pac64(PChar(p)+501)^[0] := pac64(PChar(p)+261)^[0] xor $3c819a35290d else pac16(PChar(p)+356)^[0] := pac16(PChar(p)+356)^[0] - $ec;
   pac8(PChar(p)+171)^[0] := pac8(PChar(p)+171)^[0] - (pac8(PChar(p)+184)^[0] xor $a4);
 end;

 pac32(PChar(p)+363)^[0] := pac32(PChar(p)+363)^[0] xor $d00a;

 if pac64(PChar(p)+116)^[0] > pac64(PChar(p)+205)^[0] then begin
   pac32(PChar(p)+265)^[0] := pac32(PChar(p)+265)^[0] + (pac32(PChar(p)+448)^[0] or $9cffbc);
   num := pac32(PChar(p)+206)^[0]; pac32(PChar(p)+206)^[0] := pac32(PChar(p)+93)^[0]; pac32(PChar(p)+93)^[0] := num;
   pac64(PChar(p)+369)^[0] := pac64(PChar(p)+369)^[0] or $8ca1639196;
 end;

 pac8(PChar(p)+140)^[0] := pac8(PChar(p)+140)^[0] - ror2(pac8(PChar(p)+395)^[0] , 1 );

 if pac32(PChar(p)+265)^[0] < pac32(PChar(p)+160)^[0] then begin
   num := pac32(PChar(p)+246)^[0]; pac32(PChar(p)+246)^[0] := pac32(PChar(p)+431)^[0]; pac32(PChar(p)+431)^[0] := num;
   if pac64(PChar(p)+48)^[0] < pac64(PChar(p)+211)^[0] then begin  num := pac8(PChar(p)+282)^[0]; pac8(PChar(p)+282)^[0] := pac8(PChar(p)+5)^[0]; pac8(PChar(p)+5)^[0] := num; end else pac32(PChar(p)+465)^[0] := pac32(PChar(p)+465)^[0] or ror2(pac32(PChar(p)+414)^[0] , 21 );
   num := pac16(PChar(p)+495)^[0]; pac16(PChar(p)+495)^[0] := pac16(PChar(p)+94)^[0]; pac16(PChar(p)+94)^[0] := num;
 end;


 if pac16(PChar(p)+80)^[0] > pac16(PChar(p)+429)^[0] then begin
   pac32(PChar(p)+284)^[0] := rol1(pac32(PChar(p)+383)^[0] , 8 );
   pac16(PChar(p)+502)^[0] := pac16(PChar(p)+502)^[0] + rol1(pac16(PChar(p)+246)^[0] , 10 );
   pac16(PChar(p)+316)^[0] := ror1(pac16(PChar(p)+320)^[0] , 2 );
 end;

 pac32(PChar(p)+472)^[0] := pac32(PChar(p)+472)^[0] - (pac32(PChar(p)+120)^[0] + $aa34a8);

 if pac8(PChar(p)+460)^[0] < pac8(PChar(p)+25)^[0] then begin
   num := pac32(PChar(p)+486)^[0]; pac32(PChar(p)+486)^[0] := pac32(PChar(p)+381)^[0]; pac32(PChar(p)+381)^[0] := num;
   if pac8(PChar(p)+293)^[0] < pac8(PChar(p)+224)^[0] then pac16(PChar(p)+196)^[0] := pac16(PChar(p)+498)^[0] xor $3e;
   pac32(PChar(p)+309)^[0] := pac32(PChar(p)+309)^[0] xor $885e;
   pac32(PChar(p)+87)^[0] := pac32(PChar(p)+87)^[0] + ror2(pac32(PChar(p)+508)^[0] , 10 );
   pac32(PChar(p)+116)^[0] := ror2(pac32(PChar(p)+495)^[0] , 5 );
 end;

 pac8(PChar(p)+180)^[0] := pac8(PChar(p)+30)^[0] - (pac8(PChar(p)+509)^[0] + $18);
 pac64(PChar(p)+290)^[0] := pac64(PChar(p)+290)^[0] + (pac64(PChar(p)+38)^[0] - $a05c49041320);
 if pac32(PChar(p)+372)^[0] < pac32(PChar(p)+393)^[0] then pac64(PChar(p)+186)^[0] := pac64(PChar(p)+186)^[0] or (pac64(PChar(p)+77)^[0] - $ec0e79771f58);
 pac32(PChar(p)+264)^[0] := pac32(PChar(p)+264)^[0] - ror1(pac32(PChar(p)+381)^[0] , 12 );
 if pac32(PChar(p)+153)^[0] < pac32(PChar(p)+388)^[0] then pac32(PChar(p)+508)^[0] := pac32(PChar(p)+508)^[0] xor ror2(pac32(PChar(p)+283)^[0] , 17 ) else begin  num := pac32(PChar(p)+110)^[0]; pac32(PChar(p)+110)^[0] := pac32(PChar(p)+295)^[0]; pac32(PChar(p)+295)^[0] := num; end;

end;


end.


























