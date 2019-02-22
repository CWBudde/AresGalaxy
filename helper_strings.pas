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
various string manipulation functions
}

unit helper_strings;

interface

uses
  SysUtils, Classes, Classes2, Const_Ares, SynSock, Windows, Ares_types;

const
  STR_UTF8BOM = chr($ef) + chr($bb) + chr($bf);

function HTMLDecode(const AStr: String): String;
function sizeVerbosetoBytes(const sizestr: string): Int64;
function stringtoarray(value: string; delimiter : string): TMyStringList;
function reverse_order(const strin: string): string;
function get_first_word(const strin: string): string;
function chars_2_qword(const stringa: string): Int64;
function chars_2_dword(const stringa: string): Cardinal;
function chars_2_word(const stringa: string): Word;
function int_2_qword_string(const numero: Int64): string;
function int_2_dword_string(const numero: Cardinal): string;
function int_2_word_string(const numero:word): string;
function hexstr_to_bytestr(const strin: string): string;
function bytestr_to_hexstr(const strin: string): string;
function bytestr_to_hexstr_bigend(const strin: string): string;
function isxdigit(Ch : char) : Boolean;
function isdigit(Ch : char) : boolean;
function xdigit(Ch : char) : Integer;
function HexToInt(const HexString : String) : cardinal;
function HexToInt_no_check(const HexString : String) : cardinal;
function caption_double_amperstand(strin: WideString): WideString;
function strip_at(const strin: string): string;
function strip_at_reverse(const strin: string): string;
function StripIllegalFileChars(const value: string): string;

function SplitString(str: string; lista: TMyStringList): Integer;
function strippa_fastidiosi2(strin: WideString): WideString;
function strippa_fastidiosi(strin: WideString;con:widechar): WideString;
function strip_apos_amp(const str: string): string;
function ucfirst(const stringa: string): string;
function strip_track(const strin: string): string;
function trim_extended(stringa: string): string;
function format_currency(numero: Int64): string;
function whl(const x: string): Word; //X arriva già lowercase da supernodo
function wh(const xS: string): Word;
function whlBuff(buff: Pointer; len: Byte): Word; //X arriva già lowercase da supernodo
function StringCRC(const str: string; lower_case: Boolean): Word; //keyword slava
function crcstring(const strin: string): Word;
function strip_nl(linea: WideString): WideString;
function strip_returns(strin: WideString): WideString;
function strippa_parentesi(strin: WideString): WideString;
function get_player_displayname(filename: WideString; const estensione: string): WideString;
function strip_incomplete(nomefile: WideString): WideString;
function strip_vers(const strin: string): string;
function getfirstNumberStr(const strin: string): string;
function right_strip_at_agent(const strin: string): string;
function strip_websites_str(value: string): string;
function strip_char(const strin: string; illegalChar: string): string;
function bool_string(condition: Boolean; trueString: string='On'; falseString: string='Off'): string;
function deUrlNick(nick: string): string;
function reverseorder(num: Cardinal): Cardinal; overload;
function reverseorder(num:word): Word; overload;
function reverseorder(num: Int64): Int64; overload;
function explode(str: string; separator: string): Targuments;
function rpos(const needle: string; const strin: string): Integer;
function StripHTMLTags(const s: string): string;
function escapeHTMLtags(const Data: string): string;
function escapeQuotes(const Data: string): string;
function randomstring(strLen: Integer): string;

implementation

uses
  helper_urls, helper_unicode, umediar;

function StripHTMLTags(const s: string): string;
var
i,currIndex: Integer;
InTag: Boolean;
begin
SetLength(Result,length(s));
InTag := False;
currIndex := 1;
for i := 1 to Length(s) do begin
 if s[i]='<' then inTag := True
 else
  if s[i]='>' then inTag := False
  else
   if not InTag then begin
    Result[currIndex] := s[i];
    inc(currIndex);
   end;
end;
SetLength(result,currIndex-1);
end;

function escapeHTMLtags(const Data: string): string;
var
  iPos, i,lenMax: Integer;

  procedure Encode(const AStr: String);
  begin
    Move(AStr[1], result[iPos], Length(AStr) * SizeOf(Char));
    Inc(iPos, Length(AStr));
  end;

begin
  SetLength(result, Length(Data) * 5);
  iPos := 1;
  lenMax := length(data);
  for i := 1 to lenMax do
    case Data[i] of
      '<': Encode('&lt;');
      '>': Encode('&gt;');
      '&': Encode('&amp;');
      //' ': Encode('&nbsp;');
    else
      result[iPos] := Data[i];
      Inc(iPos);
    end;
  SetLength(result, iPos - 1);
end;

function escapeQuotes(const Data: string): string;
var
  iPos, i,lenMax: Integer;

  procedure Encode(const AStr: String);
  begin
    Move(AStr[1], result[iPos], Length(AStr) * SizeOf(Char));
    Inc(iPos, Length(AStr));
  end;

begin
  SetLength(result, Length(Data) * 6);
  iPos := 1;
  lenMax := length(data);
  for i := 1 to lenMax do
    case Data[i] of
      '"': Encode('&quot;');
      '''': Encode('&apos;');
    else
      result[iPos] := Data[i];
      Inc(iPos);
    end;
  SetLength(result, iPos - 1);
end;


function explode(str: string; separator: string): Targuments;
var
 previouslen,ind: Integer;
begin

 if pos('&',str)=0 then begin
  SetLength(result,1);
  result[0] := str;
  exit;
 end;

 previouslen := 1;
 while (length(str)>0) do begin

   SetLength(result,previouslen);

  ind := pos('&',str);
  if ind<>0 then begin
   result[previouslen-1] := copy(str,1,ind-1);
   delete(str,1,ind);
  end else begin
   result[previouslen-1] := str;
   break;
  end;

  inc(previouslen);
 end;

end;

function deUrlNick(nick: string): string;
begin
try

 while (pos('\',nick)>0) do begin
  nick := copy(nick,1,pos('\',nick)-1)+ '.' + copy(nick,pos('\',nick)+1,length(nick));
 end;
 while (pos('/',nick)>0) do begin
  nick := copy(nick,1,pos('/',nick)-1)+ '.' + copy(nick,pos('/',nick)+1,length(nick));
 end;

if pos(':',nick)>0 then begin
 while (pos('http:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('http:',lowercase(nick))+3)+ '.' + copy(nick,pos('http:',lowercase(nick))+5,length(nick));
 end;
 while (pos('https:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('https:',lowercase(nick))+4)+ '.' + copy(nick,pos('https:',lowercase(nick))+6,length(nick));
 end;
 while (pos('file:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('file:',lowercase(nick))+3)+ '.' + copy(nick,pos('file:',lowercase(nick))+5,length(nick));
 end;
 while (pos('nntp:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('nntp:',lowercase(nick))+3)+ '.' + copy(nick,pos('nntp:',lowercase(nick))+5,length(nick));
 end;
 while (pos('news:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('news:',lowercase(nick))+3)+ '.' + copy(nick,pos('news:',lowercase(nick))+5,length(nick));
 end;
 while (pos('wais:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('wais:',lowercase(nick))+3)+ '.' + copy(nick,pos('wais:',lowercase(nick))+5,length(nick));
 end;
 while (pos('mailto:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('mailto:',lowercase(nick))+5)+ '.' + copy(nick,pos('mailto:',lowercase(nick))+7,length(nick));
 end;
 while (pos('gopher:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('gopher:',lowercase(nick))+5)+ '.' + copy(nick,pos('gopher:',lowercase(nick))+7,length(nick));
 end;
 while (pos('telnet:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('telnet:',lowercase(nick))+5)+ '.' + copy(nick,pos('telnet:',lowercase(nick))+7,length(nick));
 end;
 while (pos('ftp:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('ftp:',lowercase(nick))+2)+ '.' + copy(nick,pos('ftp:',lowercase(nick))+4,length(nick));
 end;
 while (pos('prospero:',lowercase(nick))>0) do begin
  nick := copy(nick,1,pos('prospero:',lowercase(nick))+7)+ '.' + copy(nick,pos('prospero:',lowercase(nick))+9,length(nick));
 end;
end;

except
end;
 Result := nick;
end;

function sizeVerbosetoBytes(const sizestr: string): Int64;
var
 varpart,unitpart: string;
begin
varpart := copy(sizestr,1,pos(' ',sizestr)-1);
unitpart := trim(lowercase(copy(sizestr,length(varpart)+2,length(sizestr))));
DecimalSeparator := '.';
if (unitpart='gb') or (unitpart='gib') then Result := trunc(strtofloatdef(trim(varpart),0.0)*GIGABYTE) else
if (unitpart='mb') or (unitpart='mib') then Result := trunc(strtofloatdef(trim(varpart),0.0)*MEGABYTE) else
if (unitpart='kb') or (unitpart='kib') then Result := trunc(strtofloatdef(trim(varpart),0.0)*KBYTE) else
result := strtointdef(trim(varpart),0);
end;

function bool_string(condition: Boolean; trueString: string='On'; falseString: string='Off'): string;
begin
if condition then Result := trueString
 else Result := falseString;
end;

function right_strip_at_agent(const strin: string): string;
var
i: Integer;
begin
result := '';

for i := length(strin) downto 1 do
 if strin[i]='@' then begin
  Result := copy(strin,1,i-1);
  exit;
 end;

end;

function rpos(const needle: string; const strin: string): Integer;
var
 i: Integer;
begin
result := 0;

if length(needle)>length(strin) then exit;
if length(needle)=length(strin) then begin
 if needle<>strin then exit;
end;

for i := length(strin) downto 1 do
 if copy(strin,i,length(needle))=needle then begin
  Result := i;
  exit;
 end;
end;

function getfirstNumberStr(const strin: string): string;
var
i: Integer;
begin
result := '';

for i := 1 to length(strin) do
 if ((ord(strin[i])>=48) and
     (ord(strin[i])<=57)) then begin
  Result := copy(strin,i,length(strin));
  break;
 end;
end;

function strip_incomplete(nomefile: WideString): WideString;
var
lonomefile: string;
begin
lonomefile := lowercase(widestrtoutf8str(nomefile));
          if pos('__incomplete_____',lonomefile)=1 then delete(lonomefile,1,17) else
          if pos('__incomplete____',lonomefile)=1 then delete(lonomefile,1,16) else
          if pos('__incomplete___',lonomefile)=1 then delete(lonomefile,1,15) else
          if pos('__incomplete__',lonomefile)=1 then delete(lonomefile,1,14) else
          if pos('___incomplete____',lonomefile)=1 then delete(lonomefile,1,16) else
          if pos('___arestra___',lonomefile)=1 then delete(lonomefile,1,13);
result := utf8strtowidestr(lonomefile);
end;

function get_player_displayname(filename: WideString; const estensione: string): WideString;
var
 rec:ares_types.precord_title_album_artist;
 title,artist,album: string;
begin
result := extract_fnameW(filename);

if pos('___ARESTRA___',widestrtoutf8str(result))=1 then delete(result,1,13); // eventually remove ___ARESTRA___

rec := AllocMem(sizeof(ares_types.record_title_album_artist));
try
umediar.estrai_titolo_artista_album_da_stringa(rec,result);
 artist := trim(widestrtoutf8str(rec^.artist));
 album := trim(widestrtoutf8str(rec^.album));
 title := trim(widestrtoutf8str(rec^.title));
except
end;
FreeMem(rec,sizeof(record_title_album_artist));

 

delete(result,(length(result)-length(estensione))+1,length(estensione)); // remove extension

if ((length(title)>0) and (length(artist)>0) and (length(album)>0)) then Result := utf8strtowidestr(artist)+' - '+utf8strtowidestr(album)+' - '+utf8strtowidestr(title)
 else
if ((length(title)>0) and (length(artist)>0)) then Result := utf8strtowidestr(artist)+' - '+utf8strtowidestr(title);

end;



function strippa_parentesi(strin: WideString): WideString;
var
i: Integer;

begin
result := '';
 for i := 1 to length(strin) do begin
  if strin[i]='(' then Result := result+' ' else
   if strin[i]=')' then Result := result+' ' else
    if strin[i]='{' then Result := result+' ' else
     if strin[i]='}' then Result := result+' ' else
      if strin[i]='[' then Result := result+' ' else
       if strin[i]=']' then Result := result+' ' else
        if strin[i]='"' then Result := result+' ' else
         if strin[i]='''' then Result := result+' ' else
          if strin[i]='_' then Result := result+' ' else
          Result := result+strin[i];
 end;
end;

function strip_returns(strin: WideString): WideString;
var
i: Integer;
begin
result := strin;
 for i := 1 to length(result) do
  if ((result[i]=chr(13)) or (result[i]=chr(10))) then result[i] := ' ';
end;

function strip_nl(linea: WideString): WideString;
begin
result := linea;
while (pos('\nl',result)<>0) do
 Result := copy(result,1,pos('\nl',result)-1)+
         CRLF+
         copy(result,pos('\nl',result)+3,length(result));
end;


function crcstring(const strin: string): Word;    // for sha1 hashes
begin
result := 0;
if length(strin)<8 then exit;

 inc(result,ord(strin[1]));
 inc(result,ord(strin[2]));
 inc(result,ord(strin[3]));
 inc(result,ord(strin[4]));
 inc(result,ord(strin[5]));
 inc(result,ord(strin[6]));
 inc(result,ord(strin[7]));
 inc(result,ord(strin[8]));

end;

function  StringCRC(const str: String; lower_case: Boolean): Word; //keyword slava
var
 c: Char;
begin // counts 2-byte CRC of string. used for faster comparison
 Result := Length(str);
 if result>0 then begin
   c := str[result];
   if lower_case then
     if (c >= 'A') and (c <= 'Z') then inc(c, 32);
   Result := Ord(c)+256*result;
 end;
 // using last character of string instead of first because almost all databases are already sorted by first character
end;

function wh(const xS: string): Word;  //gnutella query routing word hashing
var
xors: Integer;
x: string;
j,b: Integer;
i: Integer;
prod,ret: Int64;
bits: Byte;
begin
     bits := 16;
     //log (2) 655354  = 16 14;

    x := lowercase(xS);
    xors := 0;
    j := 0;

    for i := 1 to length(x) do begin
        b := ord(x[i]) and $FF;
        b := b shl (j * 8);
        xors := xors xor b;
        j := (j + 1) mod 4;
    end;

    prod := xors * $4F1BBCDC;
    ret := prod shl 32;
    ret := ret shr (32 + (32 - bits));
    Result :=  word(ret);
end;

function whlBuff(buff: Pointer; len: Byte): Word; //X arriva già lowercase da supernodo
var
xors: Integer;
j,b: Integer;
i: Integer;
prod,ret: Int64;
bits: Byte;
begin

     bits := 16; //log2(size);
     //14; //    log (2) 655354  = 16 14;   //<--- limewire  log (2) 16384

    xors := 0;
    j := 0;

    for i := 0 to len-1 do begin
        b := pbytearray(buff)[i] and $FF;
        b := b shl (j * 8);
        xors := xors xor b;
        j := (j + 1) mod 4;
    end;

    prod := xors * $4F1BBCDC;
    ret := prod shl 32;                  //  4
    ret := ret shr (32 + (32 - bits)); // >>> ?  bits=16
    Result :=  word(ret);
end;


function whl(const x: string): Word; //X arriva già lowercase da supernodo
var
xors: Integer;
j,b: Integer;
i: Integer;
prod,ret: Int64;
bits: Byte;
begin
     bits := 16; //log2(size);
     //14; //    log (2) 655354  = 16 14;   //<--- limewire  log (2) 16384

    xors := 0;
    j := 0;

    for i := 1 to length(x) do begin
        b := ord(x[i]) and $FF;
        b := b shl (j * 8);
        xors := xors xor b;
        j := (j + 1) mod 4;
    end;

    prod := xors * $4F1BBCDC;
    ret := prod shl 32;                  //  4
    ret := ret shr (32 + (32 - bits)); // >>> ?  bits=16
    Result :=  word(ret);
end;

function format_currency(numero: Int64): string;
var
numeroi:Extended;
begin
numeroi := numero;
 Result := format('%0.n',[numeroi]);
end;

function StripIllegalFileChars(const value: string): string;
var
 i: Integer;
begin
  Result := '';
  
  for i := 1 to length(value) do begin

   if value[i]='\' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='/' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]=':' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='*' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='?' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='"' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='<' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='>' then begin
    Result := result+'_';
    continue;
   end;

   if value[i]='|' then begin
    Result := result+'_';
    continue;
   end;

   Result := result+value[i];
  end;

end;

function trim_extended(stringa: string): string;
var
i,rnum: Integer;
c:char;
begin                                      
result := '';
for i := 1 to length(stringa) do begin
 if ((stringa[i]='ì') or
     (stringa[i]='í') or
     (stringa[i]='î') or
     (stringa[i]='ï')) then stringa[i] := 'i' else
 if ((stringa[i]='è') or
     (stringa[i]='é') or
     (stringa[i]='ê') or
     (stringa[i]='ë')) then stringa[i] := 'e' else
 if ((stringa[i]='à') or
     (stringa[i]='á') or
     (stringa[i]='ê')) then stringa[i] := 'a' else
 if ((stringa[i]='ù') or
     (stringa[i]='ü')) then stringa[i] := 'u' else
 if ((stringa[i]='ò') or
     (stringa[i]='ó')) then stringa[i] := 'o' else
if stringa[i]='ç' then stringa[i] := 'c' else
if stringa[i]='ñ' then stringa[i] := 'n' else
if stringa[i]='"' then stringa[i] := '''';

rnum := ord(stringa[i]);

 if ((rnum<48) or
     ((rnum > 57) and (rnum < 65)) or
     ((rnum > 90) and (rnum < 97)) or
     (rnum > 122)) then begin
         c := stringa[i];
         if (c in ['(',')','@','^','?','<','>','*','|','!',',',':','/','\','#','.','=','?','_']) then Result := result+' ' else Result := result+stringa[i];
end else Result := result+stringa[i];
end;

while (pos('  ',result)<>0) do begin  // togliamo doppi spazi
result := copy(result,1,pos('  ',result))+copy(result,pos('  ',result)+2,length(result));
end;

 Result := trim(result);

end;

function strip_track(const strin: string): string;
begin
result := strin;

while (pos('Track',result)<>0) do
 Result := copy(result,1,pos('Track',result)-1)+copy(result,pos('Track',result)+5,length(result));

end;

function ucfirst(const stringa: string): string;
var
str: string;
begin
result := stringa;
if length(result)>0 then begin
 str := uppercase(copy(result,1,1));
 Result := str+copy(result,2,length(result));
end;
end;

function strip_apos_amp(const str: string): string;
begin
result := str;
      while pos('&apos;',result)>0 do
      Result := copy(result,1,pos('&apos;',result)-1)+''''+copy(result,pos('&apos;',result)+6,length(result));

      while pos('&amp;',result)>0 do
      Result := copy(result,1,pos('&amp;',result)-1)+'&'+copy(result,pos('&amp;',result)+5,length(result));
end;

function strip_websites_str(value: string): string;
begin
 Result := value;
if pos('www.',result)<>0 then Result := ''
 else
  if pos('.com',result)<>0 then Result := '';
end;

function strippa_fastidiosi(strin: WideString;con:widechar): WideString;
var
i: Integer;
begin
result := strin;
try
for i := 1 to length(result) do
 if ((integer(result[i])<33) or (integer(result[i])=160)) then result[i] := con; //strippiamo caratteri fastidiosi
 except
 end;
end;

function strippa_fastidiosi2(strin: WideString): WideString;
var
i: Integer;
num: Integer;
begin
result := strin;
try
for i := 1 to length(result) do begin
num := integer(result[i]);
 if ((num<33) or (num=160)) then
  if ((num>9) or (num<2)) then result[i] := ' '; //strippiamo caratteri fastidiosi
end;
 except
 end;
end;

function SplitString(str: string; lista: TMyStringList): Integer;
var
 c:Char;
 str1,str2: string;
 j,num,max: Integer;
 b: Boolean;
begin
 lista.clear;
 str1 := '';
 str2 := Trim(str);
 if str2='' then begin
  Result := 0;
  exit;
 end;
 max := Length(str)+128;
 num := 0;
 j := 0;
 b := False; // makes compiler happy
 repeat
  if Length(str2)>0 then begin
   b := False;
   str2 := Trim(str2);
   j := pos(' ',str2);
   c := str2[1];
   if c='"' then begin
    j := Pos('"',Copy(str2,2,max))+2;
    b := True;
   end;
   if j=0 then j := Length(str2)
   else begin
    str := Trim(Copy(str2,1,j));
    if str[1]='"' then if str[Length(str)]='"' then str := Copy(str,2,Length(str)-2);
    lista.add(str);
    str2 := Trim(Copy(str2,j,max));
    inc(num);
    j := 0;
   end;
  end else break;
 until j=Length(str2);
 if not b then lista.add(Trim(str2));
 Result := num+1;
end;


function strip_at(const strin: string): string;
var
i: Integer;
begin
try
result := '';
for i := 1 to length(strin) do if ((strin[i]<>'@') and (strin[i]<>CHRNULL)) then Result := result+strin[i];
except
end;
end;

function strip_char(const strin: string; illegalChar: string): string;
var
i: Integer;
begin
try
result := '';
for i := 1 to length(strin) do if strin[i]<>illegalChar then Result := result+strin[i];
except
end;
end;

function HTMLDecode(const AStr: String): String;
var
  Sp, Rp, Cp, Tp: PChar;
  S: String;
  I, Code: Integer;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
  Cp := Sp;
  try
    while Sp^ <> #0 do
    begin
      case Sp^ of
        '&': begin
               Cp := Sp;
               Inc(Sp);
               case Sp^ of
                 'a': if AnsiStrPos(Sp, 'amp;') = Sp then  { do not localize }
                      begin
                        Inc(Sp, 3);
                        Rp^ := '&';
                      end;
                 'l',
                 'g': if (AnsiStrPos(Sp, 'lt;') = Sp) or (AnsiStrPos(Sp, 'gt;') = Sp) then { do not localize }
                      begin
                        Cp := Sp;
                        Inc(Sp, 2);
                        while (Sp^ <> ';') and (Sp^ <> #0) do
                          Inc(Sp);
                        if Cp^ = 'l' then
                          Rp^ := '<'
                        else
                          Rp^ := '>';
                      end;
                 'n': if AnsiStrPos(Sp, 'nbsp;') = Sp then  { do not localize }
                      begin
                        Inc(Sp, 4);
                        Rp^ := ' ';
                      end;
                 'q': if AnsiStrPos(Sp, 'quot;') = Sp then  { do not localize }
                      begin
                        Inc(Sp,4);
                        Rp^ := '"';
                      end;
                 '#': begin
                        Tp := Sp;
                        Inc(Tp);
                        while (Sp^ <> ';') and (Sp^ <> #0) do
                          Inc(Sp);
                        SetString(S, Tp, Sp - Tp);
                        Val(S, I, Code);
                        Rp^ := Chr((I));
                      end;
                 else
                   Exit;
               end;
           end
      else
        Rp^ := Sp^;
      end;
      Inc(Rp);
      Inc(Sp);
    end;
  except
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function strip_at_reverse(const strin: string): string;
var
i: Integer;
begin
try

if pos('@',strin)=0 then begin
 Result := strin;
 exit;
end;

result := '';

for i := length(strin) downto 1 do if strin[i]='@' then begin
 Result := copy(strin,1,i-1);
 break;
end;

except
end;
end;

function caption_double_amperstand(strin: WideString): WideString;   // fixes some component default textdrawing (accelerator keys)
var
i: Integer;
begin
result := strin;
  i := 1;

while (i<=length(result)) do begin  //doppio amperstand nel caso
 if result[i]='&' then begin


    Result := copy(result,1,i)+'&'+copy(result,i+1,length(result));
    inc(i,2);

  continue;
 end else inc(i);
end;
end;

function randomstring(strLen: Integer): string;
var
 str: string;
begin
//randomize;

str := 'abcdefghijklmnopqrstuvwxyz';
result := '';
 repeat
  Result := result+str[random(Length(str))+1];
 until (Length(result)=strLen)
end;

function xdigit(Ch : char) : Integer;
begin
    if ch in ['0'..'9'] then
        Result := ord(Ch) - ord('0')
    else
        Result := (ord(Ch) and 15) + 9;
end;

function isdigit(Ch : char) : boolean;
begin
    Result := (ch in ['0'..'9']);
end;

function isxdigit(Ch : char) : Boolean;
begin
    Result := (ch in ['0'..'9']) or (ch in ['a'..'z']) or (ch in ['A'..'Z']);
end;

function HexToInt(const HexString : String) : cardinal;
var
  sss : string;
  i: Integer;
begin
result := 0;

  try

 if length(HexString)=0 then exit;
 for i := 1 to length(HexString) do if not isxdigit(HexString[i]) then exit;

  except
  end;
  sss := '$' + HexString;
  Result := StrToIntdef(sss,0);

end;

function HexToInt_no_check(const HexString : String) : cardinal;
var
  s : string;
begin
  s := '$' + HexString;
  Result := StrToIntdef(s,0);
end;

function int_2_word_string(const numero:word): string;
begin
  SetLength(result,2);
  move(numero,result[1],2);
end;

function int_2_qword_string(const numero: Int64): string;
begin
  SetLength(result,8);
  move(numero,result[1],8);
end;

function stringtoarray(value: string; delimiter : string): TMyStringList;
var
   dx : integer;
   ns : string;
   txt : string;
   sl : TmyStringList;
   delta : integer;
begin
   sl := TmyStringList.create;
   delta := Length(delimiter) ;
   txt := value + delimiter;
   sl.BeginUpdate;
   sl.Clear;
   try
     while Length(txt) > 0 do
     begin
       dx := Pos(delimiter, txt) ;
       ns := Copy(txt,0,dx-1) ;
       sl.Add(ns) ;
       txt := Copy(txt,dx+delta,MaxInt) ;
     end;
   finally
     sl.EndUpdate;
   end;
  Result := sl;

end;

function int_2_dword_string(const numero: Cardinal): string;
begin
  SetLength(result,4);
  move(numero,result[1],4);
end;

function bytestr_to_hexstr(const strin: string): string;
var
i: Integer;
begin
result := '';
for i := 1 to length(strin) do Result := result+inttohex(ord(strin[i]),2);
end;

function bytestr_to_hexstr_bigend(const strin: string): string;
var
i: Integer;
tempstr: string;
num32: Cardinal;
begin

if length(strin)<16 then begin
 Result := bytestr_to_hexstr(strin);
 exit;
end;

tempstr := strin;

move(tempstr[1],num32,4);
num32 := synsock.ntohl(num32);
move(num32,tempstr[1],4);

move(tempstr[5],num32,4);
num32 := synsock.ntohl(num32);
move(num32,tempstr[5],4);

move(tempstr[9],num32,4);
num32 := synsock.ntohl(num32);
move(num32,tempstr[9],4);

move(tempstr[13],num32,4);
num32 := synsock.ntohl(num32);
move(num32,tempstr[13],4);

result := '';
for i := 1 to length(tempstr) do Result := result+inttohex(ord(tempstr[i]),2);
end;

function hexstr_to_bytestr(const strin: string): string;
var
i: Integer;
begin
result := '';
try
i := 1;
repeat
if i>=length(strin) then break;
result := result+chr(hextoint(copy(strin,i,2)));
inc(i,2);
until (not true);
except
end;
end;

function chars_2_word(const stringa: string): Word;
begin
if length(stringa)>=2 then begin
result := ord(stringa[2]);
result := Result shl 8;
result := Result + ord(stringa[1]);
end else Result := 0;
end;

function chars_2_qword(const stringa: string): Int64;
begin
 if length(stringa)>=8 then begin
  fillchar(result,8,0);
  move(stringa[1],result,8);
 end else Result := 0;
end;

function chars_2_dword(const stringa: string): Cardinal;
begin
if length(stringa)>=4 then begin
result := ord(stringa[4]);
result := Result shl 8;
result := Result + ord(stringa[3]);
result := Result shl 8;
result := Result + ord(stringa[2]);
result := Result shl 8;
result := Result + ord(stringa[1]);
end else Result := 0;
end;

function reverseorder(num: Cardinal): Cardinal;
var
 buffer,buffer2: array [0..3] of Byte;
begin
move(num,buffer,4);
buffer2[0] := buffer[3];
buffer2[1] := buffer[2];
buffer2[2] := buffer[1];
buffer2[3] := buffer[0];
move(buffer2,result,4);
end;

function reverseorder(num: Int64): Int64;
var
 buffer,buffer2: array [0..7] of Byte;
begin
move(num,buffer,8);
buffer2[0] := buffer[7];
buffer2[1] := buffer[6];
buffer2[2] := buffer[5];
buffer2[3] := buffer[4];
buffer2[4] := buffer[3];
buffer2[5] := buffer[2];
buffer2[6] := buffer[1];
buffer2[7] := buffer[0];
move(buffer2,result,8);
end;

function reverseorder(num:word): Word;
var
 buffer,buffer2: array [0..1] of Byte;
begin
move(num,buffer,2);
buffer2[0] := buffer[1];
buffer2[1] := buffer[0];
move(buffer2,result,2);
end;

function strip_vers(const strin: string): string;
var
i: Integer;
begin
result := strin;
for i := 1 to length(result) do
           if ((not (result[i] in ['a'..'z'])) and
                (not (result[i] in ['A'..'Z']))) then begin
                             Result := copy(result,1,i-1);
                            break;
            end;
end;

function get_first_word(const strin: string): string;
var i: Integer;
begin
 Result := strin;
 for i := 1 to length(result) do if ((result[i]=' ') or (result[i]='/')) then begin
  Result := copy(result,1,i-1);
  exit;
 end;
end;


function reverse_order(const strin: string): string;
var i: Integer;
begin
result := '';
for i := length(strin) downto 1 do Result := result+strin[i];
end;

end.
