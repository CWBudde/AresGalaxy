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
ip format/convert misc functions
}

unit helper_ipfunc;

interface

uses
  Classes, Windows, Classes2, Sysutils, Synsock, Winsock, Blcksock,
  Helper_strings, Helper_crypt, Ares_types, vars_global, class_cmdlist;

const
  LOW_IP_LIMIT = 1;
  HIGH_IP_LIMIT = 223;

function ip_firewalled(ipC: Cardinal): Boolean; overload;
function ip_firewalled(const ipS: string): Boolean; overload;
function GetLocalIp: Cardinal;
function ipint_to_dotstring(ip: Cardinal): string;
function ipdotstring_to_anonnick(ip: string): string;
function ip_to_hex_str(ip: Cardinal): string;
function inet_addr(cp: PChar): u_long; stdcall; {PInAddr;}  { TInAddr }
function inet_ntoa(inaddr: TInAddr): PChar; stdcall;
function headercrypt_to_aresip(str: string): string;
function is_ip(stringa: string): Boolean;
function ip_int_to_dotted_reverse(ip: Cardinal): string;
function resolve_name_to_ip(dns: string): string;
function ipint_to_anonick(ip: Cardinal): string;
function is_banned_ip(ip: Cardinal): Boolean;
procedure add_ban(ip: Cardinal);
function isAntiP2PIP(ip: Cardinal): Boolean;
function serialize_myConDetails: string;
function isBlockedChat(ip: Cardinal): Boolean;

var
  lista_banned_ip: Tnapcmdlist;

implementation

uses
  ufrmmain, mysupernodes, const_ares;

function inet_addr; external 'wsock32.dll' name 'inet_addr';
function inet_ntoa; external 'wsock32.dll' name 'inet_ntoa';



function serialize_mycondetails: string;
begin
// do not include supernodes' infos if reachable by others
if not vars_global.im_firewalled then
 Result := int_2_dword_string(vars_global.localipC)+
         int_2_word_string(vars_global.myport)+
         int_2_dword_string(vars_global.LanIPC)
else
 Result := int_2_dword_string(vars_global.localipC)+
         int_2_word_string(vars_global.myport)+
         int_2_dword_string(vars_global.LanIPC)+
         mysupernodes.mysupernodes_serialize;
end;

function isBlockedChat(ip: Cardinal): Boolean;
var
buff: array [0..3] of Byte;
begin

Result := False;
move(ip,buff[0],4);

case buff[0] of
 50: Result := (buff[1]=97) or //softlayer 50.97.0.0/16
            (buff[1]=22) or (buff[1]=23); //softlayer 50.22.0.0/15
 64: Result := ((buff[1]=31) and (buff[2]<=63)) or //limestone            64.31.0.0 - 64.31.63.255
            ((buff[1]=32) and (buff[2]<=31));  // sharktech 64.32.0.0 - 64.32.31.255
 67: Result := ((buff[1]=21) and (buff[2]>=64) and (buff[2]<=95)) or //sharktech67.21.64.0 - 67.21.95.255
            (buff[1]=228); //softlayer 187.198.0.0/16
 69: Result := (buff[1]=162) and (buff[2]>=64); // limestone 69.162.64.0 - 69.162.127.255
 70: Result := ((buff[1]=39) and (buff[2]>=64) and (buff[2]<=127)); //sharktech 70.39.64.0 - 70.39.127.255
 74: Result := (buff[1]=63) and (buff[2]>=192); // Limestone Networks 74.63.192.0 - 74.63.255.255
 78: Result := (buff[1]=47) and (buff[2]=125); // bondhost 78.47.125.32 - 78.47.125.39
 107: Result := (buff[1]=167) and (buff[2]<=31); // Sharktech 107.167.0.0 - 107.167.31.255
 108: Result := (buff[1]=61) and (buff[2]=40); // game hosting 108.61.40.160
 173: Result := (buff[1]=193) and (buff[2]>=192); // softlayer 173.193.192.0/18
 174: Result := ((buff[1]=128) and (buff[2]>=224)); // Sharktech 174.128.224.0 - 174.128.255.255
 177: Result := (buff[1]=229) and (buff[2]<=30); //megared
 198: Result := ((buff[1]=148) and (buff[2]>=80) and (buff[2]<=95)); //sharktech 198.148.80.0 - 198.148.95.255
 199: Result := ((buff[1]=115) and (buff[2]>=96) and (buff[2]<=103)); //sharktech 199.115.96.0 - 199.115.103.255
 204: Result := ((buff[1]=188) and (buff[2]>=192)); // sharktech 204.188.192.0 - 204.188.255.255
 208: Result := ((buff[1]=98) and (buff[2]<=63)); //sharktech 208.98.0.0 - 208.98.63.255
end;

end;

function isAntiP2PIP(ip: Cardinal): Boolean;
var
buff: array [0..3] of Byte;
begin
 Result := False;
 
 move(ip,buff[0],4);


  //torrent
  case buff[0] of
   38: Result := (((buff[1]=118) and (buff[2]=11)) or
               ( (buff[1]=100) and ((buff[2]>=24) and (buff[2]<=27)) or ((buff[2]>=134) and (buff[2]<=135)) ) ); // cogent

   208: Result := ((buff[1]=10) and (buff[2]>=23) and (buff[2]<=29));   // sprint
  end;
  if Result then exit;

  // DHT
  case buff[0] of
   38: Result := ((buff[1]=99) and ((buff[2]=253) or (buff[2]=254))) or // 38.99.253.XX  Performance Systems International Inc.
              (buff[1]=102);  // Performance systems 38.102.xx.xx
   62: Result := ((buff[1]=241) and (buff[2]=52));  // 62.241.52.0 - 62.241.52.255  Planetwebhost
   208: Result := ((buff[1]=86) and (buff[2]=198));  //Quick Connect Hosting
  end;
  if Result then exit;

  // first type
  case buff[0] of
    8: Result := ((buff[1]=3) and (buff[2]=210)); //   8.3.210.xx level3  spammer
    38: Result := ((buff[1]=99) and (buff[2]=252)) or // 38.99.252.XX  Performance Systems International Inc.
                ((buff[1]=107) and ((buff[2]=162) or (buff[2]=161)) );  // 38.99.252.XX  Performance Systems International Inc.
    64: Result := ((buff[1]=62) and (buff[2]>=128)); // 64.62.128.0 - 64.62.255.255 Hurricane Electric
    65: Result := ((buff[1]=49) and (buff[2]=32)) or
               ((buff[1]=60) and (buff[2]<=63)) or  //zapshares FAKE bots 65.60.0.0 - 65.60.63.255
               ((buff[1]=99) and (buff[2]=204)) or // 65.99.204.0 - 65.99.204.255 Crucial Paradigm
               ((buff[1]=19) and (buff[2]>=128) and (buff[2]<=191)); // 65.19.128.0 - 65.19.191.255 Hurrican Electric
    66: Result := ( (buff[1]=45) and (buff[2]>=224)) or  // 66.45.224.0 - 66.45.255.255 Interserver SMPLAYER
               ( (buff[1]=117) and (buff[2]<=15) ) or //  66.117.5.xx Corporate Colocation Inc  66.117.0.0 - 66.117.15.255
               ( (buff[1]=160) and (buff[2]>=128) and (buff[2]<=207) ) or // 66.160.128.0 - 66.160.207.255 Hurricane Electric
               (((buff[1]>=166) and (buff[1]<=167))) or // Covad  66.166.0.0 - 66.167.255.255
               ( (buff[1]=180) and (buff[2]=205) ) or  //66.180.205.xx  Cyberverse Online Spammer
               ( (buff[1]=186) and (buff[2]>=192) and (buff[2]<=223) ) or // WV FIBER LLC  66.186.192.0 - 66.186.223.255
               ((buff[1]=187) and (buff[2]>=64) and (buff[2]<=79)) or //oplink 66.187.64.0 - 66.187.79.255 FAKE bots zapshares
               ( (buff[1]=198) and (buff[2]=35) ) or  // 66.198.35.104-107-110 TeleGlobe Montreal Spammer
               ((buff[1]=225) and (buff[2]>=254));   // singlehop zapshares SPAM bots 66.225.254.0 - 66.225.255.255

    67: Result := ((buff[1]>=100) and (buff[1]<=103)) or  // Covad Communications 67.100.0.0 - 67.103.255.255
               ((buff[1]=159) and (buff[2]<=63)) or    // FDCservers.net 67.159.0.0 - 67.159.63.255
               ((buff[1]=212) and (buff[2]>=160) and (buff[2]<=191)) or // singlehop zapshares 67.212.160.0 - 67.212.191.255
               ((buff[1]=215) and (buff[2]>=224)); // Secured Private Network 67.215.224.0 - 67.215.255.255
    68: Result := ((buff[1]=68) and (buff[2]>=32) and (buff[2]<=47)); // reliable hosting zapshares 68.68.32.0 - 68.68.47.255
    69: Result := (buff[1]=175) and (buff[2]<=127);    // zapshares.com       69.175.0.0 - 69.175.127.255
    70: Result := ((buff[1]=38) and (buff[2]<=127)) or  //iWeb Dedicated / Technologies
               (buff[1]=42); // FSH Network Services 70.42.0.0 - 70.42.255.255

    72: Result := (buff[1]=5) or  // FSH Networks / Internap 72.5.0.0 - 72.5.255.255
               ((buff[1]=55) and (buff[2]>=184) and (buff[2]<=191)) or  // 72.55.128.0 - 72.55.191.255  iWeb Technologies Inc
               ((buff[1]=232) and (buff[2]=105)) or
               ((buff[1]=172) and (buff[2]=92)) or  // Net2Ez
               ((buff[1]=172) and (buff[2]=90)) or
               ((buff[1]=232) and (buff[2]=94));  //  Layered Technologies, Inc. 72.232.0.0 - 72.232.255.255
    74: Result := ((buff[1]=206) and (buff[2]>=160) and (buff[2]<=191));   //MOJOHOST 74.206.160.0 - 74.206.191.25
    78: Result := ((buff[1]=129) and (buff[2]=150));
    81: Result := ((buff[1]=179) and (buff[2]=88) and (buff[3]=79)); // Pipex Dyn 81.179.88.79  ****
    83: Result := ((buff[1]=142) and (buff[2]>=224) and (buff[2]<=231)); // 83.142.224.0 - 83.142.231.255 Rapidswitch
    87: Result := ((buff[1]=239) and (buff[2]>=48) and (buff[2]<=55)) or  // Server Shed Limited  87.239.48.0 - 87.239.55.255
               ((buff[1]=117) and (buff[2]=230) and (buff[3]>=128)) or  // Rapidswitch  87.117.230.128 - 87.117.230.255
               ((buff[1]=117) and (buff[2]=231));           // Rapidswitch  87.117.231.0 - 87.117.231.255
    96: Result := (buff[1]=127) and (buff[2]>=128) and (buff[2]<=191); // 96.127.128.0 - 96.127.191.255  zapshares SPAMBOT publicidad de ares
    98: Result := (buff[1]=158) and (buff[2]>=112) and (buff[2]<=127); //reliable hosting zapshares 98.158.112.0 - 98.158.127.255
    99: Result := ((buff[1]=192) and (buff[2]>=128)) or // MOJOHOST Canada  99.192.128.0 - 99.192.255.255
               ((buff[1]=198) and (buff[2]>=96) and (buff[2]<=127));  // singlehop zapshares FAKE bots 99.198.96.0 - 99.198.127.255
    107: Result := (buff[1]=6) and (buff[2]>=128) and (buff[2]<=191); // singlehop zapshares Spam Bots 107.6.128.0 - 107.6.191.255
    108: Result := ((buff[1]=163) and (buff[2]>=192)) or // singlehop ZAPSHARES FAKE  Bots 108.163.192.0 - 108.163.255.255
                ((buff[1]=171) and (buff[2]>=96) and (buff[2]<=127)) or // reliable hosting zapshares 108.171.96.0 - 108.171.127.255
                ((buff[1]=178) and (buff[2]<=63)) or // 108.178.0.0 - 108.178.63.255 zapshares FAKE
                ((buff[1]=229) and (buff[2]<=127)); // 108.229.0.0 - 108.229.127.255 AT&T ATT-CLOUD
    162: Result := (buff[1]=218) and (buff[2]>=228) and (buff[2]<=231);  // oplink FAKE bots 162.218.228.0 - 162.218.231.255
    168: Result := (buff[1]=151);  // Intelligence Network, Inc. 168.151.0.0 - 168.151.255.255
    173: Result := ((buff[1]=195) and (buff[2]<=15)) or // reliable hosting zapshares 173.195.0.0 - 173.195.15.255
                (buff[1]=203) or   //173.203.0.0 - 173.203.255.255 Rackspace Hosting
                ((buff[1]=236) and (buff[2]<=127)) or  // 173.236.0.0 - 173.236.127.255  zapshares FAKE bots
                ((buff[1]=255) and (buff[2]>=160) and (buff[2]<=191)); // reliablehosting zapshares 173.255.160.0 - 173.255.191.255
    174: Result := ((buff[1]=36) or (buff[1]=37));  //SoftLayer Technologies Inc. 174.36.0.0 - 174.37.255.255
    184: Result := ((buff[1]=72) or (buff[1]=73)) or //AMAZON hosts 184.72.0.0 - 184.73.255.255
                (buff[1]=154);   //184.154.0.0/16 zapshares SingleHop, Inc.    SPAMBOT publicidad de ares
    189: Result := ((buff[1]=43) and ((buff[2]=25) or (buff[2]=26))); //Embratel BR 189.43.25.0/26
    192: Result := (buff[1]=200) and (buff[2]>=144) and (buff[2]<=159); //reliable hosting zapshares 192.200.144.0 - 192.200.159.255
    198: Result := ((buff[1]=20) and (buff[2]>=64) and (buff[2]<=127)) or  // zapshare FAKE bots 198.20.64.0 - 198.20.127.255
                ((buff[1]=143) and (buff[2]>=128) and (buff[2]<=191));  //singlehop Zapshares FAKE bots 198.143.128.0 - 198.143.191.255
    199: Result := ((buff[1]=116) and (buff[2]=75)) or // reliable hosting zapshares 199.116.75.0 - 199.116.75.255
                ((buff[1]=127) and (buff[2]>=248)) or // reliable hosting zapshares 199.127.248.0 - 199.127.255.255
                ((buff[1]=241) and (buff[2]=203)); // reliable hosting zapshares 199.241.203.0 - 199.241.203.255
    202: Result := ((buff[1]=167) and (buff[2]>=224)); // EQUINIXAP-NET 202.167.224.0 - 202.167.255.255
    204: Result := ((buff[1]=8) and (buff[2]>=32) and (buff[2]<=35)) or // Swift Ventures Inc DHT exe 204.8.32.0 - 204.8.35.255
                ((buff[1]=13) and (buff[2]>=164) and (buff[2]<=167)) or // Swift Ventures Inc DHT exe 204.13.164.0 - 204.13.167.255
                ((buff[1]=14) and (buff[2]>=120) and (buff[2]<=123)) or // AllHost.com "    "  "   "  204.14.120.0 - 204.14.123.255
                ((buff[1]=15) and (buff[2]>=224) and (buff[2]<=231)) or //     "   "       "         204.15.224.0 - 204.15.231.255
                ((buff[1]=193) and (buff[2]>=128) and (buff[2]<=159)) or  //GLOBIXBLK4 USA  204.193.128.0 - 204.193.159.255
                ((buff[1]=236) and (buff[2]>=128)); // Amazon Web Services  204.236.128.0 - 204.236.255.255

    205: Result := ((buff[1]=134) and ((buff[2]=238) or (buff[2]=239))) or   // xeex  205.134.238.0 - 205.134.239.255
                ((buff[1]=234) and (buff[2]=251)); //singlehop ZAPSHARES SPAM bots 205.234.251.0 - 205.234.251.255
    206: Result := (buff[1]=190) and (buff[2]>=128) and (buff[2]<=159); // 206.190.128.0 - 206.190.159.255   Hosting Services, Inc
    207: Result := ((buff[1]=7) and (buff[2]=136)) or
                ((buff[1]=171) and ((buff[2]>=61) or (buff[2]<=62))) or  // Regard Systems Integrators  207.171.61.0 - 207.171.61.255
                ((buff[1]=204) and (buff[2]=224)) or // reliable hosting zapshares 207.204.224.0 - 207.204.255.255
                ((buff[1]=212) and (buff[2]=26));    // PacificNet  207.212.26.0 - 207.212.26.255
    208: Result := ((buff[1]=69) and (buff[2]=41)) or // reliable hosting zapshares 208.69.41.0 - 208.69.41.255
                ((buff[1]=93) and (buff[2]>=4) and (buff[2]<=7)) or // hosting central 208.93.4.0 - 208.93.7.255
                ((buff[1]=99) and (buff[2]>=192) and (buff[2]<=233)); // Swift Ventures Inc DHT exe 208.99.192.0 - 208.99.223.255
    209:begin
        Result := (buff[1]=10) or   // GLOBIXBLK3 USA  209.10.0.0 - 209.10.255.255
                ((buff[1]=195) and (buff[2]<=63)) or// 209.195.0.0 - 209.195.63.255 ( Macrovision Corporation )
                ((buff[1]=51) and (buff[2]>=160) and (buff[2]<=191)); // 209.51.160.0 - 209.51.191.255 Hurrican Electric
        end;
    212:begin
        if buff[1]=71 then begin
          Result := (buff[2]>=224);  // Globix it   212.71.224.0 - 212.71.255.255
        end;
     end;
     213:begin
           if buff[1]=219 then begin
             if buff[2]=9 then begin
               Result := (buff[3]>=192);  // X Works  213.219.9.192 - 213.219.9.255
             end;
           end;
         end;
     216:begin
           Result := ((buff[1]=18) and (buff[2]>=224) and (buff[2]<=239)) or // allhost.com DHT spam EXE 216.18.224.0 - 216.18.239.255
                   ((buff[1]=58) and (buff[2]<=127)) or //216.58.0.0 - 216.58.127.255   Information Gateway Services
                   //((buff[1]=18) and (buff[2]=228) and (buff[3]<=95)) or  //216.18.228.0 - 216.18.228.95 PROTONSOLUTION-1
                   ((buff[1]=58) and (buff[2]=193)) or // 216.58.193.xx Fox Communications

                   ((buff[1]=66) and (buff[2]<=95)) or // 216.66.0.0 - 216.66.95.255 Hurrican Electric
                   ((buff[1]=104) and (buff[2]>=32) and (buff[2]<=47)) or  // zapshares FAKE files 216.104.32.0 - 216.104.47.255
                   ((buff[1]=131) and (buff[2]>=64) and (buff[2]<=127)) or // reliable hosting zapshares 216.131.64.0 - 216.131.127.255
                   ((buff[1]=169) and (buff[2]>=128) and (buff[2]<=143)) or //reliable hosting zapshares 216.169.128.0 - 216.169.143.255
                   ((buff[1]=218) and (buff[2]>=128)) or // 216.218.128.0 - 216.218.255.255   Hurrican Electric
                   ((buff[1]=230) and (buff[2]>=224) and (buff[2]<=239)); //216.230.224.0 - 216.230.239.255  	The Optimal Link Corporation FAKE bots zapshares
         end;


  end;
 if Result then exit;

 // second type
 case buff[0] of
   24: Result := ((buff[1]=76) and (buff[2]=251)); // SHAW Ottawa  24.76.251.x   *****
   63:begin
       Result :=  ((buff[1]>=216) and (buff[1]<=223)) or // Beyond the net 63.216.0.0 - 63.223.255.255
                ((buff[1]>=236) and (buff[1]<=239));  // QWEST COMUNICATION 63.236.0.0 - 63.239.255.255
      end;
   64:begin
        if buff[1]=70 then Result := (buff[2]<=111); //  Savvis  64.70.0.0 - 64.70.111.255
   end;
   66: Result := ( (buff[1]=172) or                       // Fastserve Network 66.172.0.0 - 66.172.63.255
                ((buff[1]=110) and (buff[2]<=127)) or  // TeleGlobe 66.110.0.0 - 66.110.127.255
                ((buff[1]=25) and (buff[2]=7)) );   // RR Houston TX   66.25.7.237 ****

   69:begin
        if buff[1]=26 then begin
           Result := ((buff[2]>=160) and (buff[2]<=191)); // Net Sentry Corp   69.26.160.0 - 69.26.191.255
        end;
    end;
   72:begin
     if buff[1]=35 then begin
       Result := ((buff[2]>=224) and (buff[2]<=239)); // FUZION COLO NV    72.35.224.0 - 72.35.239.255
     end;
   end;
   142: Result := (buff[1]=162); // Stentor National 142.162.0.0 - 142.162.255.255
   154: Result := (buff[1]=37);   // PERFORMANCE SYSTEM 154.37.0.0 - 154.37.255.255
   204:begin
         if buff[1]=11 then begin
          Result := ((buff[2]>=16) and (buff[2]<=19)); //Your OneStop Network, Inc  204.11.16.0 - 204.11.19.255
         end;
      end;
   205: Result := ((buff[1]=177) or // Beyond The net  205.177.0.0 - 205.177.255.255
                (buff[1]=252)); // Beyond The Network America, Inc  205.252.0.0 - 205.252.255.255
   206: Result := (buff[1]=161); // Beyond The Network America 206.161.0.0 - 206.161.255.255
   207: Result := (buff[1]=226); // Beyond The Network America  207.226.0.0 - 207.226.255.255
   208: Result := ((buff[1]>=48) and (buff[1]<=50)); // Global Crossing  208.48.224.0 - 208.50.127.255

   216:begin

       if buff[1]=8 then begin
         Result := (buff[2]>=192);   //  Cosmex Media      216.8.192.0 - 216.8.255.255
       end else
       if buff[1]=9 then begin
         Result := ((buff[2]>=160) and (buff[2]<=175)) or // Western PA Internet Access, Inc.  216.9.160.0 - 216.9.175.255
                 ((buff[2]>=192) and (buff[2]<=207)); // ASI comunication 216.9.192.0 - 216.9.207.255
       end else
       if buff[1]=151 then begin
         Result := ((buff[2]>=128) and (buff[2]<=159)); // xeen.net  216.151.128.0 - 216.151.159.255
       end else
        Result := (buff[1]=156); //XO Communications 216.156.0.0 - 216.156.255.255
   end;
   220: Result := (buff[1]=255); // SingNet Pte Ltd 220.255.0.0 - 220.255.255.255
   221: Result := (buff[1]=189); // NTT Communications Corporation 221.184.0.0 - 221.191.255.255  ****
 end;

end;

procedure add_ban(ip: Cardinal);
begin
if lista_banned_ip=nil then lista_banned_ip := tnapcmdlist.create;

if lista_banned_ip.FindById(ip)<>-1 then exit;
lista_banned_ip.addcmd(ip,'');
end;

function is_banned_ip(ip: Cardinal): Boolean;
begin
try
if lista_banned_ip=nil then begin
 Result := False;
 exit;
end;

Result := (lista_banned_ip.FindById(ip)<>-1);
except
Result := False;
end;
end;


function resolve_name_to_ip(dns: string): string;
var
lista: TMyStringList;
begin
Result := '';
   lista := tmyStringList.create;  //otteniamo ip reale per cript decript
  ResolveNameToIP(dns,lista);
  if lista.count<1 then begin
   lista.Free;
   exit;
  end;
  Result := lista.strings[0];
 lista.Free;
end;

function ip_int_to_dotted_reverse(ip: Cardinal): string;
var   ia:     in_addr;
ipi: Integer;
str: string;
begin
str := int_2_dword_string(ip);
str := reverse_order(str);
ipi := chars_2_dword(str);
ia.S_addr := ipi;
  Result := inet_ntoa(ia);
end;

function is_ip(stringa: string): Boolean;
var
i: Integer;
puntini: Byte;
begin
puntini := 0;

for i := 1 to length(stringa) do begin
if ((stringa[i]<>'0') and (stringa[i]<>'1') and
(stringa[i]<>'2') and (stringa[i]<>'3') and
(stringa[i]<>'4') and (stringa[i]<>'5') and
(stringa[i]<>'6') and (stringa[i]<>'7') and
(stringa[i]<>'8') and (stringa[i]<>'9') and
(stringa[i]<>'.')) then begin
Result := False;
exit;
end else if stringa[i]='.' then inc(puntini);
end;

Result := (puntini=3);
end;

function headercrypt_to_aresip(str: string): string;
var
ip,ip_server: Integer;
port,port_server: Word;
begin
if length(str)<>12 then begin
 Result := '';
 exit;
end;

str := hexstr_to_bytestr(str);
str := d54(str,3617);
               ip_server := chars_2_dword(copy(str,1,4));
               port_server := chars_2_word(copy(str,5,2));
               ip := chars_2_dword(copy(str,7,4));
               port := chars_2_word(copy(str,11,2));
Result := ipint_to_dotstring(ip_server)+':'+inttostr(port_server)+'|'+
        ipint_to_dotstring(ip)+':'+inttostr(port);
end;

function ip_to_hex_str(ip: Cardinal): string;
var i: Integer;
str: string;
begin
try
str := int_2_dword_string(ip);
Result := '';
for i := 1 to length(str) do Result := Result+inttohex(ord(str[i]),2);
Result := lowercase(Result);
except
end;
end;

function ipdotstring_to_anonnick(ip: string): string;
var
ipi: Integer;
begin
ipi := inet_addr(PChar(ip));
Result := STR_ANON+ip_to_hex_str(ipi);
end;

function ipint_to_anonick(ip: Cardinal): string;
begin
Result := STR_ANON+ip_to_hex_str(ip);
end;

function ipint_to_dotstring(ip: Cardinal): string;
var   ia:     in_addr;
begin
ia.S_addr := ip;
  Result := inet_ntoa(ia);
end;

function GetLocalIp: Cardinal;
{type
  sockaddr_in = record
    case Integer of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array [0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array [0..13] of Char)
  end;}
var
  s: string;
  hname: string;
  lista: TMyStringList;
begin


  Result := 0;
  try

  SetLength(s, 255);
  synsock.GetHostName(PChar(s), Length(s) - 1);
   hname := PChar(s);
 if hname = '' then Result := 0 else begin
     lista := tmyStringList.create;
     ResolveNameToIP(hname,lista);
     if lista.count>0 then Result := inet_addr(PChar(lista.strings[0])) else Result := 0;
     lista.Free;
  end;

  except
  end;
end;

function ip_firewalled(ipC: Cardinal): Boolean;
var
  buffer: array [0..3] of Byte;
begin
  Result := False;

  move(ipC,buffer[0],4);

  if buffer[0]>HIGH_IP_LIMIT then
  begin
    Result := True;
    exit;
  end;
  if buffer[0]<LOW_IP_LIMIT then
  begin
    Result := True;
    exit;
  end;

  case buffer[0] of
    10:
      Result := True;
    127:
      Result := ((buffer[1]=0) and (buffer[2]=0) and (buffer[3]=1));
    192:
      Result := (buffer[1]=168);
    172:
      Result := ((buffer[1]>=16) and (buffer[1]<=32));
  end;
end;

function ip_firewalled(const ipS: string): Boolean;
begin
  Result := ip_firewalled(inet_addr(PChar(ipS)));
end;

end.
