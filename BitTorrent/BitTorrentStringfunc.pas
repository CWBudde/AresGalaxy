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
main bittorrent string functions
}

unit BitTorrentStringfunc;

interface

uses
  Classes, Sysutils, Windows, Winsock, Btcore;

function chars_2_wordRev(const AString: string): Cardinal;
function chars_2_dwordRev(const AString: string): Cardinal;
function bool2verbose(Value:Boolean): string;
function GetHostFromUrl(Value: string): string;
function GetPortFromUrl(Value: string): Word;
function GetPathFromUrl(Value: string): string;
function GetScrapePathFromUrl(const Value: string): string;
function GetFullScrapeURL(const Value: string): string;

function fullUrlEncode(Value: string): string;
function GetRandomAsciiChars(HowMany: Integer): string;
function GetRandomChars(HowMany: Integer): string;
function int_2_dword_stringRev(const ANumber: Cardinal): string;
function int_2_word_stringRev(const ANumber: word): string;
function BTSourceStatusToStringW(Status: TBittorrentSourceStatus): WideString;
function StriPChar(inString: string; Character: string): string;
function BTIDtoClientName(const Value: string): string;
function BTBitStatustoString(data: PRecord_Displayed_source): WideString;
function GetSerialized4CharVersionNumber: string;
function BTSourceStatusToByte(Status: TBittorrentSourceStatus): Byte;
function BTProgressToFamiltyStrName(progress: Integer): WideString;
function AddBoolString(const Value: WideString; ShouldAdd:Boolean): WideString;
function AzAdvancedCommand_to_BittorrentCommand(const inValue: string): Byte;

implementation

uses
 vars_global,helper_strings,vars_localiz,const_ares,bittorrentConst;


function AzAdvancedCommand_to_BittorrentCommand(const inValue: string): Byte;
begin
  if inValue='REQUEST' then
    Result := CMD_BITTORRENT_REQUEST
  else
  if inValue='PIECE' then
    Result := CMD_BITTORRENT_PIECE
  else
  if inValue='HAVE' then
    Result := CMD_BITTORRENT_HAVE
  else
  if inValue='CANCEL' then
    Result := CMD_BITTORRENT_CANCEL
  else
  if inValue='CHOKE' then
    Result := CMD_BITTORRENT_CHOKE
  else
  if inValue='UNCHOKE' then
    Result := CMD_BITTORRENT_UNCHOKE
  else
  if inValue='INTERESTED' then
    Result := CMD_BITTORRENT_INTERESTED
  else
  if inValue='UNINTERESTED' then
    Result := CMD_BITTORRENT_NOTINTERESTED
  else
  if inValue='KEEP_ALIVE' then
    Result := CMD_BITTORRENT_KEEPALIVE
  else
  if inValue='BITFIELD' then
    Result := CMD_BITTORRENT_BITFIELD
  else
    Result := CMD_BITTORRENT_UNKNOWN;
end;

function GetSerialized4CharVersionNumber: string;
var
  lastnum: string;
begin        // 2.1.4.3038 -> 2148
  if length(versioneAres)<>10 then versioneAres := ARES_VERS;
  Result := StriPChar(versioneAres,'.');
  lastnum := Result[length(Result)];

  Delete(Result,4,length(Result));
  Result := Result+lastnum;
  if length(Result)<>4 then Result := '2148';
end;

function AddBoolString(const Value: WideString; ShouldAdd:Boolean): WideString;
begin
  if ShouldAdd then
    Result := Value
  else
    Result := '';
end;

function BTBitStatustoString(data:PRecord_Displayed_source): WideString;
begin
  Result := GetLangStringW(STR_UPLOAD)+': '+
           AddBoolString(GetLangStringW(STR_IDLE),(not data^.choked) and (not data^.interested))+
           AddBoolString(GetLangStringW(STR_TORRENT_CHOKED),data^.choked)+
           AddBoolString(GetLangStringW(STR_TORRENT_OPTUNCHOKE),(data^.isOptimistic) and (not data^.choked))+
           AddBoolString(', ',(((data^.choked) or (data^.isOptimistic)) and data^.interested))+
           AddBoolString(GetLangStringW(STR_TORRENT_INTERESTED),data^.interested)+'  -  '+
          GetLangStringW(STR_DOWNLOAD)+': '+
           AddBoolString(GetLangStringW(STR_IDLE),(not data^.weArechoked) and (not data^.weAreinterested))+
           AddBoolString(GetLangStringW(STR_TORRENT_CHOKED),data^.weAreChoked)+
           AddBoolString(', ',(data^.weArechoked and data^.weAreinterested))+
           AddBoolString(GetLangStringW(STR_TORRENT_INTERESTED),data^.weAreInterested);

end;

function BTIDtoClientName(const Value: string): string;
var
ClientPrefix,version: string;
i,ind: Integer;
isShareaza: Boolean;
begin
Result := '';

 if length(Value)<20 then begin
  Result := 'Unknown';
  Exit;
 end;

if ((Value[1]='-') and (Value[2]<>'-')) then begin //Azureus style  -AGxxxx {-xxxx...}
 ClientPrefix := copy(Value,2,2);
 version := copy(Value,4,4);
 for i := 1 to length(version) do Result := Result+version[i]+'.';
 Delete(Result,length(Result),1);
 version := Result;
 Result := '';

 if ClientPrefix='7T' then Result := 'aTorrent' //android
  else
 if ClientPrefix='AB' then Result := 'AnyEvent'
  else
 if ClientPrefix='AG' then Result := 'Ares'
  else
 if ClientPrefix='A~' then Result := 'Ares'
  else
 if ClientPrefix='AR' then Result := 'Arctic Torrent'
  else
 if ClientPrefix='AV' then Result := 'Avicora'
  else
 if ClientPrefix='AT' then Result := 'Artemis'
  else
 if ClientPrefix='AZ' then Result := 'Azureus'
  else
 if ClientPrefix='AX' then Result := 'BitPump'
  else
 if ClientPrefix='BB' then Result := 'BitBuddy'
  else
 if ClientPrefix='BC' then Result := 'BitComet'
  else
 if ClientPrefix='BE' then Result := 'BitTorrent SDK'
  else
 if ClientPrefix='BF' then Result := 'Bitflu'
  else
 if ClientPrefix='BG' then Result := 'BTGetit'
  else
 if ClientPrefix='BL' then Result := 'BitBlinder'
  else
 if ClientPrefix='BP' then Result := 'BitTorrent Pro'  //azureus+spyware
  else
 if ClientPrefix='bk' then Result := 'BitKitten (libtorrent)'
  else
 if ClientPrefix='BO' then begin
  if copy(Value,4,4)='WA0C' then version := '1.03'
   else
   if copy(Value,4,4)='WA0B' then version := '1.02'
    else version := '';
  Result := 'BitsOnWheels';
 end else
 if ClientPrefix='BR' then Result := 'BitRocket'
  else
 if ClientPrefix='BS' then Result := 'BTSlave' //BitSpirit
  else
 if ClientPrefix='BT' then Result := 'BitTornado' //BitSpirit
  else
 if ClientPrefix='BX' then Result := 'BittorrentX'
  else
 if ClientPrefix='CD' then Result := 'Enhanced CTorrent'
  else
 if ClientPrefix='CT' then Result := 'CTorrent'
  else
 if ClientPrefix='DE' then Result := 'DelugeTorrent' // ??
  else
  if ClientPrefix='DP' then Result := 'Propagate Data' // ??
  else
 if ClientPrefix='EB' then Result := 'EBit'
  else
 if ClientPrefix='ES' then Result := 'Electric sheep'
  else
 if ClientPrefix='eX' then Result := 'EXeem'
  else
 if ClientPrefix='FC' then Result := 'FileCroc'
  else
 if ClientPrefix='FG' then Result := 'FlashGet'
  else
 if ClientPrefix='FT' then Result := 'FoxTorrent'
  else
 if ClientPrefix='FX' then Result := 'Freebox'
  else
   if ClientPrefix='GS' then Result := 'GSTorrent'
  else
 if ClientPrefix='G3' then begin
  Result := 'G3 Torrent';
  version := '';
 end
  else
 if ClientPrefix='HK' then Result := 'Hekate'
  else
 if ClientPrefix='HL' then Result := 'Halite'
  else
 if ClientPrefix='HM' then Result := 'hMule'
  else
 if ClientPrefix='HN' then Result := 'Hydranode'
  else
 if ClientPrefix='IL' then Result := 'iLivid'
  else
 if ClientPrefix='JS' then Result := 'Justseedit'
  else
 if ClientPrefix='JT' then Result := 'Javatorrent'
  else
 if ClientPrefix='KG' then Result := 'KGet'
  else
 if ClientPrefix='KT' then Result := 'KTorrent'
  else
 if ClientPrefix='LC' then Result := 'LeechCraft'
  else
 if ClientPrefix='LH' then Result := 'LH-ABC'
  else                                        //-JB0300-??
 if ClientPrefix='LP' then Result := 'Lphant'
  else
 if ClientPrefix='LT' then Result := 'libtorrent (Rasterbar)'
  else
 if ClientPrefix='lt' then Result := 'libTorrent (Rakshasa)'
  else
 if ClientPrefix='LW' then Result := 'Limewire'
  else
 if ClientPrefix='MK' then Result := 'Meerkat'
  else
 if ClientPrefix='ML' then begin
  Result := 'MLDonkey';
  version := copy(Value,4,5);
 end
  else
 if ClientPrefix='MO' then Result := 'MonoTorrent'
  else
 if ClientPrefix='MP' then Result := 'MooPolice'
  else
  if ClientPrefix='MR' then Result := 'Miro'
  else
 if ClientPrefix='MT' then Result := 'MoonlightTorrent'
  else
  if ClientPrefix='NB' then Result := 'NetBitTorrent'
  else
 if ClientPrefix='NX' then Result := 'Net Transport'
  else
 if ClientPrefix='OP' then Result := 'Opera'
  else
 if ClientPrefix='OS' then Result := 'OneSwarm'
  else
 if ClientPrefix='OT' then Result := 'OmegaTorrent'
  else
 if ClientPrefix='PB' then Result := 'ProtocolBitTorrent'
  else
 if ClientPrefix='PC' then Result := 'CacheLogic'
  else
 if ClientPrefix='PD' then Result := 'Pando'
  else
 if ClientPrefix='PT' then Result := 'PHPTracker'
  else
 if ClientPrefix='qB' then Result := 'qBittorrent'
  else
  if ClientPrefix='QD' then Result := 'QQDownload'
  else
 if ClientPrefix='QT' then Result := 'Qt4 Torrent'
  else
 if ClientPrefix='RC' then Result := 'RC' //???
  else
 if ClientPrefix='RT' then Result := 'Retriever'
  else
 if ClientPrefix='RZ' then Result := 'RezTorrent'
  else
 if ClientPrefix='S~' then Result := 'Shareaza ab'  //shareaza 2.2.3.0 ?
  else
 if ClientPrefix='SB' then Result := 'Swiftbit'
  else
 if ClientPrefix='SD' then Result := 'Xunlei'  //http://dl.xunlei.com/)
  else
 if ClientPrefix='SM' then Result := 'SoMud'
  else
 if ClientPrefix='SN' then Result := 'ShareNET'
  else
 if ClientPrefix='SP' then Result := 'BitSpirit'
  else
 if ClientPrefix='SS' then Result := 'SwarmScope'
  else
 if ClientPrefix='ST' then Result := 'SymTorrent'
  else
  if ClientPrefix='st' then Result := 'SharkTorrent'
  else
 if ClientPrefix='SZ' then Result := 'Shareaza'
  else
 if ClientPrefix='TE' then Result := 'Terasaur Seed Bank'
  else
 if ClientPrefix='TL' then Result := 'Tribler'
  else
 if ClientPrefix='TN' then Result := 'Torrent.NET'
  else
 if ClientPrefix='TR' then Result := 'Transmission'
  else
 if ClientPrefix='TS' then Result := 'TorrentStorm'
  else
 if ClientPrefix='TT' then Result := 'TuoTu'
  else
 if ClientPrefix='UL' then Result := 'uLeecher!'
  else
 if ClientPrefix='UM' then Result := 'µTorrent Mac'
  else
 if ClientPrefix='UT' then Result := 'µTorrent'
  else
  if ClientPrefix='VG' then Result := 'Vagaa'
  else
 if ClientPrefix='ZT' then Result := 'ZipTorrent'
  else
 if ClientPrefix='WT' then Result := 'BitLet'
  else
  if ClientPrefix='WY' then Result := 'FireTorrent'
  else
  if ClientPrefix='XL' then Result := 'Xunlei'
  else
 if ClientPrefix='XT' then Result := 'XanTorrent'
  else
 if ClientPrefix='XX' then Result := 'XTorrent'
  else
 if ClientPrefix='ZT' then Result := 'ZipTorrent'
  else begin
   Result := 'Unknown ('+ClientPrefix+' '+version+')';
   Exit;
  end;
   Result := Result+' '+version;
   Exit;
end;

ind := pos('----',Value);
if ((ind>=5) and (ind<7)) then begin  //bittornado may be at pos 6 tornado style
   ClientPrefix := copy(Value,1,1);
   version := copy(Value,2,ind-2);
   for i := 1 to length(version) do Result := Result+version[i]+'.';
   Delete(Result,length(Result),1);
   version := Result;
   Result := '';

  if ClientPrefix='A' then Result := 'ABC'
   else
  if ClientPrefix='O' then Result := 'Osprey Permaseed'
   else
  if ClientPrefix='Q' then Result := 'BTQueue'
   else
  if ClientPrefix='R' then Result := 'Tribler'
   else
  if ClientPrefix='S' then Result := 'Shadown'
   else
  if ClientPrefix='T' then Result := 'BitTornado'
   else
  if ClientPrefix='U' then Result := 'UPnP NAT'
   else begin
     Result := 'Unknown ('+Value+')';
     Exit;
   end;
   Result := Result+' '+version;
   Exit;
end;

if copy(Value,1,8)='AZ2500BT' then begin
 Result := 'BitTyrant';
 Exit;
end;

if copy(Value,1,1)='M' then begin //Bram's
   version := StriPChar(copy(Value,2,7),'-');
   for i := 1 to length(version) do Result := Result+version[i]+'.';
   Delete(Result,length(Result),1);
   version := Result;
   Result := 'BitTorrent '+version;
 Exit;
end;


if copy(Value,6,7)='Azureus' then begin
 Result := 'Azureus 2.0.3.2';
 Exit;
end;

if copy(Value,1,6)='A310--' then begin
 Result := 'ABC 3.1';
 Exit;
end;

if copy(Value,1,2)='OP' then begin
  version := copy(Value,3,4);
  for i := 1 to length(version) do Result := Result+version[i]+'.';
  Delete(Result,length(Result),1);
  version := Result;
  Result := 'Opera '+version;
  Exit;
end;

if copy(Value,2,3)='BOW' then begin
 Result := 'BitsOnWheels '+copy(Value,4,3);
 Exit;
end;

if copy(Value,1,2)='eX' then begin
 Result := 'eXeem ['+copy(Value,3,18)+']';
 Exit;
end;

if copy(Value,1,7)='martini' then begin
 Result := 'Martini Man';
 Exit;
end;

if copy(Value,1,5)='oernu' then begin
 Result := 'BTugaXP';
 Exit;
end;

if copy(Value,1,6)='BTDWV-' then begin
 Result := 'Deadman Walking';
 Exit;
end;

if copy(Value,1,8)='PRC.P---' then begin
 Result := 'BitTorrent Plus! II';
 Exit;
end;

if copy(Value,1,8)='P87.P---' then begin
 Result := 'BitTorrent Plus!';
 Exit;
end;

if copy(Value,1,8)='S587Plus' then begin
 Result := 'BitTorrent Plus!';
 Exit;
end;

if copy(Value,5,6)='btfans' then begin
 Result := 'SimpleBT';
 Exit;
end;

if Lowercase(copy(Value,1,5))='btuga' then begin
 Result := 'BTugaXP';
 Exit;
end;

if copy(Value,1,10)='DansClient' then begin
 Result := 'XanTorrent';
 Exit;
end;

if copy(Value,1,16)='Deadman Walking-' then begin
 Result := 'Deadman';
 Exit;
end;


if copy(Value,1,4)='LIME' then begin
  Result := 'Limewire';
  Exit;
end;

if copy(Value,1,5)='Mbrst' then begin
  version := Value[6]+'.'+Value[8]+'.'+Value[10];
  Result := 'Burst '+version;
 Exit;
end;

if copy(Value,1,7)='turbobt' then begin
  Result := 'TurboBT '+copy(Value,8,5);
  Exit;
end;

if copy(Value,1,4)='btpd' then begin
 Result := 'BT Protocol Daemon '+copy(Value,5,3);
 Exit;
end;

if copy(Value,1,4)='Plus' then begin
 Result := 'Plus! '+Value[5]+'.'+Value[6]+'.'+Value[7];
 Exit;
end;

if copy(Value,1,3)='XBT' then begin
 Result := 'XBT '+Value[4]+'.'+Value[5]+'.'+Value[6];
 Exit;
end;

if copy(Value,3,2)='RS' then begin
  Result := 'Rufus '+inttostr(ord(Value[1]))+'.'+
                   inttostr(ord(Value[2]) div 10)+'.'+
                   inttostr(ord(Value[2]) mod 10);
  Exit;
end;

if ((copy(Value,1,4)='exbc') or
    (copy(Value,1,4)='FUTB') or
    (copy(Value,1,4)='xUTB')) then begin

  if copy(Value,7,4)='LORD' then begin
   if Value[5]=CHRNULL then version := inttostr(ord(Value[5]))+'.'+
                                     inttostr(ord(Value[6]) div 10)+
                                     inttostr(ord(Value[6]) mod 10)
                                     else
                            version := inttostr(ord(Value[5]))+'.'+
                                     inttostr(ord(Value[6]) mod 10);
   Result := 'BitLord '+version;
   Exit;
  end;

   version := inttostr(ord(Value[5]))+'.'+
            inttostr(ord(Value[6]) div 10)+
            inttostr(ord(Value[6]) mod 10);

  if copy(Value,1,4)='FUTB' then Result := 'BitComet Mod1 '+version
   else
    if copy(Value,1,4)='xUTB' then Result := 'BitComet Mod2 '+version
     else
      Result := 'BitComet '+version;
  Exit;
end;

if copy(Value,3,2)='BS' then begin
  version := 'v'+inttostr(ord(Value[2]));
  Result := 'BitSpirit '+version;
  Exit;
end;

if copy(Value,1,4)='346-' then begin
  Result := 'TorrentTopia';
  Exit;
end;

if copy(Value,1,4)='271-' then begin
 Result := 'GreedBT 2.7.1';
 Exit;
end;

if copy(Value,11,2)='BG' then begin
 Result := 'BTGetit';
 Exit;
end;

if copy(Value,1,7)='a00---0' then begin
 Result := 'Swarmy';
 Exit;
end;

if copy(Value,1,7)='a02---0' then begin
 Result := 'Swarmy';
 Exit;
end;

if copy(Value,1,7)='T00---0' then begin
 Result := 'Teeweety';
 Exit;
end;

if copy(Value,1,9)='10-------' then begin
 Result := 'JVTorrent';
 Exit;
end;

if copy(Value,1,3)='TIX' then begin //  TIX0196-a5a7g1c9j0d1
 Result := 'Tixati '+copy(Value,5,1)+'.'+copy(Value,6,2);
 Exit;
end;


if copy(Value,1,8)=CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL+CHRNULL then begin
  if copy(Value,17,4)='UDP0' then Result := 'BitComet UDP'
   else
    if copy(Value,15,6)='HTTPBT' then Result := 'BitComet HTTP';
    Exit;
end;

if Value[1]='S' then begin
    if Value[9]=chr(0) then begin
      Result := 'Shad0w '+inttostr(ord(Value[2]))+'.'+inttostr(ord(Value[3]));
    end else Result := 'Unknown ('+Value+')';
    Exit;
end;


if Value[1]<>chr(0) then begin
   isShareaza := True;
      for i := 2 to 16 do begin
       if Value[i]=chr(0) then begin
        isShareaza := False;
        break;
       end;
      end;
          if isShareaza then begin
            for i := 17 to 20 do begin
             if ord(Value[i])<>ord(Value[(i mod 17)+1]) xor ord(Value[16-(i mod 17)]) then begin
              isShareaza := False;
              break;
             end;
            end;
          end;
              if isShareaza then begin
               Result := 'Shareaza';
               Exit;
              end;
end;

   Result := 'Unknown ('+Value+')';


end;

function StriPChar(inString: string; Character: string): string;
begin
  Result := inString;

  while (pos(Character,Result)<>0) do
    Result := copy(Result,1,pos(Character,Result)-1) +
      copy(Result,pos(Character,Result)+length(Character),length(Result));
end;

function BTSourceStatusToStringW(Status: TBittorrentSourceStatus): WideString;
begin
  case Status of
    btSourceIdle: 
      Result := GetLangStringW(STR_IDLE);
    btSourceConnecting: 
      Result := GetLangStringW(STR_CONNECTING);
    btSourceReceivingHandshake: 
      Result := GetLangStringW(STR_REQUESTING);
    btSourceweMustSendHandshake: 
      Result := GetLangStringW(STR_REQUESTING);
    btSourceShouldDisconnect: 
      Result := 'Disconnecting';
    btSourceShouldRemove: 
      Result := 'Removing';
    btSourceConnected: 
      Result := GetLangStringW(STR_CONNECTED);
  end;
end;

function BTProgressToFamiltyStrName(progress: Integer): WideString;
begin
  if progress = 100 then
    Result := 'Seed'
  else
    Result := 'Leecher';
end;

function BTSourceStatusToByte(Status: TBittorrentSourceStatus): Byte;
begin
  case Status of
    btSourceShouldRemove:
      Result := 0;
    btSourceShouldDisconnect:
      Result := 1;
    btSourceIdle:
      Result := 2;
    btSourceConnecting:
      Result := 3;
    btSourceReceivingHandshake:
      Result := 4;
    btSourceweMustSendHandshake:
      Result := 5;
    btSourceConnected:
      Result := 6
    else
      Result := 0;
  end;
end;

function int_2_dword_stringRev(const ANumber: Cardinal): string;
var
  buff: array [0..3] of char;
begin
  move(ANumber,buff,4);

  SetLength(Result,4);
  Result[1] := buff[3];
  Result[2] := buff[2];
  Result[3] := buff[1];
  Result[4] := buff[0];
end;

function int_2_word_stringRev(const ANumber:word): string;
var
  buff: array [0..1] of char;
begin
  move(ANumber,buff,2);

  SetLength(Result,2);
  Result[1] := buff[1];
  Result[2] := buff[0];
end;

function GetRandomAsciiChars(HowMany: Integer): string;
const
  ALPHABET='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
var
  i: Integer;
begin
  for i := 1 to HowMany do
    Result := Result+alphabet[random(length(alphabet))+1];
end;

function GetRandomChars(HowMany: Integer): string;
var
  i: Integer;
begin
  for i := 1 to HowMany do
    Result := Result + chr(random(255));
end;

function fullUrlEncode(Value: string): string;
var
  i: Integer;
begin
  Result := '';

  for i := 1 to length(Value) do
    Result := Result+'%'+inttohex(ord(Value[i]),2);
end;

function GetPathFromUrl(Value: string): string;
var
  ind: Integer;
begin
  Result := '';

  ind := pos('http://',Lowercase(Value));
  if ind<>0 then
    Delete(Value,1,ind+6);

  ind := pos('/',Value);
  if ind<>0 then
  begin
    Delete(Value,1,ind-1);
    Result := Value;
  end;
end;

function GetFullScrapeURL(const Value: string): string;
begin
  Result := Value;
  Result := copy(Result,1,pos('/announce',Lowercase(Result)))+
    'scrape'+
    copy(Result,pos('/announce',Lowercase(Result))+9,length(Result));
end;

function GetScrapePathFromUrl(const Value: string): string;
begin
  Result := GetPathFromUrl(Value);
  Result := copy(Result,1,pos('/announce',Lowercase(Result)))+
    'scrape'+
    copy(Result,pos('/announce',Lowercase(Result))+9,length(Result));
end;

function GetHostFromUrl(Value: string): string;
var
  ind: Integer;
  lovalue: string;
begin    // http://www.host.com:81/index.html   --> www.host.com
  lovalue := Lowercase(Value);

  ind := pos('://',lovalue);
  if ind<>0 then Delete(lovalue,1,ind+2);

  ind := pos('/',lovalue);
  if ind<>0 then Delete(lovalue,ind,length(lovalue));

  ind := pos(':',lovalue);
  if ind<>0 then Delete(lovalue,ind,length(lovalue));

  Result := lovalue;
end;

function GetPortFromUrl(Value: string): Word;
var
  ind: Integer;
  lovalue: string;
begin    // http://www.host.com:81/index.html   --> 81
  lovalue := Lowercase(Value);

  ind := pos('://',lovalue);
  if ind<>0 then Delete(lovalue,1,ind+2);

  ind := pos('/',lovalue);
  if ind<>0 then Delete(lovalue,ind,length(lovalue));

  ind := pos(':',lovalue);
  if ind<>0 then Delete(lovalue,1,ind);

  Result := strtointdef(lovalue,80);
end;

function bool2verbose(Value: Boolean): string;
begin
  if Value then
    Result := 'Yes'
  else
    Result := 'No';
end;

function chars_2_dwordRev(const AString: string): Cardinal;
begin
  if length(AString)>=4 then
  begin
    Result := ord(AString[1]);
    Result := Result shl 8;
    Result := Result + ord(AString[2]);
    Result := Result shl 8;
    Result := Result + ord(AString[3]);
    Result := Result shl 8;
    Result := Result + ord(AString[4]);
  end
  else
    Result := 0;
end;

function chars_2_wordRev(const AString: string): Cardinal;
begin
  if length(AString)>=2 then
  begin
    Result := ord(AString[1]);
    Result := Result shl 8;
    Result := Result + ord(AString[2]);
  end
  else
    Result := 0;
end;

end.
