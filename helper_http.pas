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
misc HTTP helper functions
}

unit helper_http;

interface

uses
  blcksock, classes2, helper_sockets, helper_urls, windows,
  winsock, SysUtils, utility_ares, helper_strings, const_ares;


const
  HTTPOK=0;
  HTTPBUSY=1;
  HTTPNOTFOUND=2;
  
  STR_HTTP_PLAIN='HTTP/';
  STR_HTTP1='HTTP/1.1 ';
  HTTP200='200 OK';
  HTTP206='206 OK';
  
  HTTPERROR403='403 Forbidden'; // banned
  HTTPERROR404='404 Not Found'; // file not available/shared
  HTTPERROR416='416 Requested Range Not Satisfiable'; // bad content range request doh
  HTTPERROR500='500 Internal Server Error'; // rehashing
  HTTPERROR501='501 Not Implemented'; // bad reques encryption
  HTTPERROR503='503 Busy';  // queued
  HTTPERROR510='510 Rehashing Library';  // queued
  
  STR_BITPART='X-BTrnt:';
  STR_XB64MYDET='X-ACDet:';
  
  
  TAG_ARESHEADER_NICKNAME      = 2;
  TAG_ARESHEADER_CRYPTBRANCH   = 50;
  TAG_ARESHEADER_WANTEDHASH    = 1;
  TAG_ARESHEADER_RANGE32       = 7;
  TAG_ARESHEADER_RANGE64       = 11;
  TAG_ARESHEADER_ALTSSRC       = 8;
  TAG_ARESHEADER_HOSTINFO1     = 3;
  TAG_ARESHEADER_HOSTINFO2     = 13;
  TAG_ARESHEADER_AGENT         = 9;
  TAG_ARESHEADER_ICHREQ        = 12;
  TAG_ARESHEADER_XSIZE         = 5;
  TAG_ARESHEADER_STTSWAREZOLD  = 6;
  TAG_ARESHEADER_XSTATS1       = 10;
  TAG_ARESHEADER_XSTATS2       = 14;

function get_text_webpage(var resCode: Byte; url: string; port: string = '80' ): string;
function HTTP_reply_code(const header: string): Byte;
function STR_CONTENT_RANGE: string;
function STR_X_TREE_ROOT: string;

function STR_X_EAS: string;
//function STR_XB64MYIP: string;
function STR_XB64STATS: string;
function STR_X64ALT: string;
function STR_X_ALT: string;
function STR_SERVER_ARES: string;
function STR_HTTP404_NOTFOUND: string;
function STR_MYNICKLO: string;
function STR_MYNICK: string;
function STR_CONTENT_LENGTH: string;
function STR_HERE_PHASH_INDEXS: string;
function STR_PHASH_SIZE: string;
 function STR_ARES_PGT: string;
 function STR_ARES_PGTOK: string;
 function STR_FIREWALLED_TEXT: string;
 
procedure ParseHTTPHeader(list: TMylist; header: string);
procedure FreeHTTPHeaderList(list: TMylist);
function FindHTTPValue(list: TMylist; Key: string): string;


implementation

uses
  ares_types,vars_global;

procedure FreeHTTPHeaderList(list: TMylist);
var
  Pitem: precord_httpheader_item;
begin
  while (list.count>0) do 
  begin
    Pitem := list[list.count-1];
        list.delete(list.count-1);
    Pitem^.key := '';
    Pitem^.value := '';
    FreeMem(pitem,sizeof(record_httpheader_item));
  end;
  list.Free;
end;

function FindHTTPValue(list: TMylist; Key: string): string;
var
Pitem:precord_httpheader_item;
i: Integer;
begin
result := '';
for i := 0 to list.count-1 do begin
 Pitem := list[i];

 if Pitem^.key=key then begin
  Result := Pitem^.value;

   list.delete(i);
   Pitem^.value := '';
   Pitem^.key := '';
   FreeMem(Pitem,sizeof(record_httpheader_item));
   
  exit;
 end;
end;
end;

procedure ParseHTTPHeader(list: TMylist; header: string);
var
line,key,Value: string;
Pitem:precord_httpheader_item;
begin
while (pos(CRLF,header)>0) do begin
  line := copy(header,1,pos(CRLF,header)-1);
   delete(header,1,pos(CRLF,header)+1);

  if pos(':',line)=0 then continue;

  Key := lowercase(Trim(copy(line,1,pos(':',line)-1)));
  Value := Trim(copy(line,pos(':',line)+1,length(line)));
  if length(key)=0 then continue;
  if length(Value)=0 then continue;

  Pitem := AllocMem(sizeof(record_httpheader_item));
   Pitem^.key := Key;
   Pitem^.value := Value;
  list.add(Pitem);
  
end;

end;

function STR_FIREWALLED_TEXT: string;
begin
//FIRETST
result := chr(70)+chr(73)+chr(82)+chr(69)+chr(84)+chr(83)+chr(84);
end;

function STR_ARES_PGTOK: string;
begin
//ARESPGTOK     
result := chr(65)+chr(82)+chr(69)+chr(83)+chr(80)+chr(71)+chr(84)+chr(79)+chr(75);
end;

function STR_ARES_PGT: string;
begin
//ARESPGT
result := chr(65)+chr(82)+chr(69)+chr(83)+chr(80)+chr(71)+chr(84);
end;



function STR_CONTENT_LENGTH: string;
begin
//Content-Length: '<-space
result := chr(67)+chr(111)+chr(110)+chr(116)+chr(101)+chr(110)+chr(116)+
chr(45)+chr(76)+chr(101)+chr(110)+chr(103)+chr(116)+chr(104)+chr(58)+chr(32);
end;

function STR_HERE_PHASH_INDEXS: string;
begin
//PHashIdx: '<-space
result := chr(80)+chr(72)+chr(97)+chr(115)+chr(104)+chr(73)+chr(100)+chr(120)+chr(58)+chr(32);
end;

function STR_PHASH_SIZE: string;
begin
//PHSize: '<-space
result := chr(80)+chr(72)+chr(83)+chr(105)+chr(122)+chr(101)+chr(58)+chr(32);
end;

function STR_HTTP200_OK: string;
begin
//HTTP/1.1 200 OK + CRLF;
result := chr(72)+chr(84)+chr(84)+chr(80)+chr(47)+chr(49)+chr(46)+chr(49)+
chr(32)+chr(50)+chr(48)+chr(48)+chr(32)+chr(79)+chr(75)+ CRLF;
end;





function STR_MYNICK: string;
begin
//X-My-Nick:
result := chr(88)+chr(45)+chr(77)+chr(121)+chr(45)+chr(78)+chr(105)+chr(99)+chr(107)+chr(58);
end;

function STR_MYNICKLO: string;
begin
//x-my-nick:
result := chr(120)+chr(45)+chr(109)+chr(121)+chr(45)+chr(110)+chr(105)+chr(99)+chr(107)+chr(58);
end;

function STR_HTTP404_NOTFOUND: string;
begin
//HTTP/1.1 404 Not Found + CRLF;
result := chr(72)+chr(84)+chr(84)+chr(80)+chr(47)+chr(49)+chr(46)+chr(49)+
chr(32)+chr(52)+chr(48)+chr(52)+chr(32)+chr(78)+chr(111)+chr(116)+chr(32)+
chr(70)+chr(111)+chr(117)+chr(110)+chr(100)+ CRLF;
end;

function STR_SERVER_ARES: string;
begin
//Server: Ares
result := chr(83)+chr(101)+chr(114)+chr(118)+chr(101)+chr(114)+chr(58)+chr(32)+APPNAME+chr(32);
//chr(65)+chr(114)+chr(101)+chr(115)+chr(32);
end;

function STR_X_ALT: string;
begin
//X-Alt:
result := chr(88)+chr(45)+chr(65)+chr(108)+chr(116)+chr(58);
end;

function STR_X64ALT: string;
begin
//X-B6s:
result := chr(88)+chr(45)+chr(66)+chr(54)+chr(115)+chr(58);
end; //alt sources

function STR_XB64STATS: string;
begin
//X-B6St:
result := chr(88)+chr(45)+chr(66)+chr(54)+chr(83)+chr(116)+chr(58);
end; //x statts base 64

//function STR_XB64MYIP: string;
//begin
//X-B6MI:
//result := chr(88)+chr(45)+chr(66)+chr(54)+chr(77)+chr(73)+chr(58);
//end; //x aresip base 64


function STR_X_EAS: string;
begin
//X-Eas:
result := chr(88)+chr(45)+chr(69)+chr(97)+chr(115)+chr(58);
end;

function STR_X_TREE_ROOT: string;  //2957+ cambiato da precedente
begin
//X-TAPG: --> X-TRPG:  (2958+ due to different en_parz)
result := chr(88)+chr(45)+chr(84)+chr(82)+chr(80)+chr(71)+chr(58);
end;

function STR_CONTENT_RANGE: string;
begin
//Content-range: bytes=
result := chr(67)+chr(111)+chr(110)+chr(116)+chr(101)+chr(110)+chr(116)+
        chr(45)+chr(114)+chr(97)+chr(110)+chr(103)+chr(101)+chr(58)+chr(32)+chr(98)+
        chr(121)+chr(116)+chr(101)+chr(115)+chr(61);
end;

function HTTP_reply_code(const header: string): Byte;
var
protocollo,risposta,stringa: string;
rispostai: Integer;
begin
stringa := header;

protocollo := copy(stringa,1,pos(' ',stringa)-1);
if pos('HTTP',uppercase(protocollo))<1 then begin
 Result := HTTPNOTFOUND;
 exit;
end;

risposta := copy(stringa,pos(' ',stringa)+1, length(stringa));
risposta := copy(risposta,1,3);

rispostai := strtointdef(risposta,404);

if ((rispostai>=200) and (rispostai<300)) then begin
 Result := HTTPOK;
 exit;
end else
 if ((rispostai>=300) and (rispostai<500)) then begin
  Result := HTTPNOTFOUND;
  exit;
 end else
  if ((rispostai>=500) and (rispostai<600)) then begin
   Result := HTTPBUSY;
   exit;
  end
   else Result := HTTPBUSY;

end;

function get_text_webpage(var resCode: Byte; url: string; port: string = '80' ): string;
var
site: TTCPBlockSocket;
str,siz: string;
len,er: Integer;  
previous_len: Integer;
ricevuto: string;
tempo: Cardinal;
sizi: Integer;
lung: Integer;

 chunked: Boolean;
 yet_to_receive: Integer;
 chunksizestr: string;
 ricevuto_header: Boolean;
 location,ips: string;
 lista: TMyStringList;

               procedure checkLocalIP;
               begin
                sleep(500);
                site.GetSinLocal;
                vars_global.LanIPs := site.GetLocalSinIP;
                vars_global.LANIPc := inet_addr(PChar(vars_global.LANIPs));

               end;

begin
resCode := 1; //can't connect?

result := '';
yet_to_receive := 0;

      try
site := TTCPBlockSocket.Create(true);
 assign_proxy_settings(site);
 ips := extract_dns_from_url(url);

if site.socksip<>'' then
 if site.FSockSType<>ST_Socks5 then begin
   lista := tmyStringList.create;
   ResolveNameToIP(ips,lista);
    if lista.count<1 then begin
     lista.Free;
     site.Free;
     exit;
    end;
    ips := lista.strings[0];
   lista.Free;
 end;

      site.ip := ips;
      site.port := 80;
      site.Connect(site.ip,port);
      sleep(100);

      tempo := gettickcount;
      while true do begin
       if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin
        site.Free;
        exit;
       end;
       er := TCPSocket_ISConnected(site);
       if er=0 then break else
        if er<>WSAEWOULDBLOCK then begin
          site.Free;
          exit;
        end;
        sleep(10);
      end;

      resCode := 2; //ok we are online....

      str := 'GET '+extract_document_from_url(url)+' HTTP/1.1'+CRLF+
           'Accept: */*'+CRLF+
           'Accept-Language: en-us'+CRLF+
           'User-Agent: Mozilla/4.0 (compatible; MSIE 6 0; Windows NT 5.1)'+CRLF+
           'Host: '+extract_dns_from_url(url)+CRLF+
           'Connection: Keep-Alive'+CRLF+CRLF;


       tempo := gettickcount;
      while (true) do begin
       if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin
        site.Free;
        exit;
       end;

       lung := TCPSocket_SendBuffer(site.socket,@str[1],length(str),er);
      if er=WSAEWOULDBLOCK then begin
       sleep(10);
       continue;
      end else
       if er<>0 then begin
        site.Free;
        exit;
       end;

       if lung<length(str) then begin
        delete(str,1,lung);
        continue;
       end else break;

      end;

      ricevuto := '';
       tempo := gettickcount;

      chunked := falsE;
      ricevuto_header := False;

while true do begin
       if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin   //timeout!!
        site.Free;
        exit;
       end;


       /////////////begin parse header
     if not ricevuto_header then begin
        if pos(CRLF+CRLF,ricevuto)>0 then begin
          ricevuto_header := True;

            if pos('HTTP/1.1 200 OK'+CRLF,ricevuto)<>1 then begin //wrong or redir
               site.Free;
                 if pos(CRLF+'location:',lowercase(ricevuto))<>0 then begin
                  location := copy(ricevuto,pos(CRLF+'location:',lowercase(ricevuto))+11,length(ricevuto));
                  delete(location,pos(chr(13),location),length(location));
                  location := trim(location);
                     if pos('http://',lowercase(location))<>1 then location := 'http://'+location;
                     if length(extract_document_from_url(location))<2 then location := location+extract_document_from_url(url);

                    Result := get_text_webpage(resCode,location,port);
                    exit;
                end;
                Result := ''; //error empty body
              exit;
            end;


                if pos(CRLF+'content-length:',lowercase(ricevuto))>0 then begin
                   siz := copy(ricevuto,pos(CRLF+'content-length:',lowercase(ricevuto))+17,length(ricevuto));
                   delete(siz,pos(chr(13),siz),length(siz));
                   siz := trim(siz);
                   sizi := strtointdef(siz,-1);
                    if sizi=-1 then begin 
                     site.Free;
                     exit;
                    end;
                    delete(ricevuto,1,pos(CRLF+CRLF,ricevuto)+3);
                     chunked := False;
                     Result := ricevuto;
                       if length(result)>=sizi then begin
                        checkLocalIP;
                        site.Free;
                        resCode := 0;
                        exit;
                       end;
                     yet_to_receive := sizi;
                     ricevuto := '';
                end else
                if ((pos(CRLF+'transfer-encoding: chunked'+CRLF,lowercase(ricevuto))<>0) or
                    (pos(CRLF+'transfer-encoding:chunked'+CRLF,lowercase(ricevuto))<>0)) then begin
                    delete(ricevuto,1,pos(CRLF+CRLF,ricevuto)+3);
                      chunked := True;
                      yet_to_receive := -1;
                   Result := '';
                end;

        end;
     end;


     
     ////////////////////begin parse body
     if ricevuto_header then begin

            if not chunked then begin
              Result := result+ricevuto;
              ricevuto := '';
             if length(result)>=yet_to_receive then begin
               checkLocalIP;
               site.Free;
               resCode := 0;
               exit;
             end;
            end else begin   //else chunked....

                    while (true) do begin

                         if yet_to_receive=-1 then begin
                             if pos(CRLF,ricevuto)>0 then begin
                              chunksizestr := copy(ricevuto,1,pos(CRLF,ricevuto)-1);
                              chunksizestr := trim(chunksizestr);
                              yet_to_receive := hextoint(chunksizestr);
                                if yet_to_receive=0 then begin
                                 checkLocalIP;
                                 site.Free;
                                 resCode := 0;
                                 exit;
                                end;
                               delete(ricevuto,1,pos(CRLF,ricevuto)+1);
                              end else break;
                          end;
                          if yet_to_receive<>-1 then begin
                             if length(ricevuto)>=yet_to_receive then begin
                                 Result := result+copy(ricevuto,1,yet_to_receive);
                                   delete(ricevuto,1,yet_to_receive+2); // CRLF
                                  yet_to_receive := -1;
                             end else break;
                          end;

                      end;  //end while parse
           end;  //end chunkeder

     end;   //end if got header....

    /////////////////////////////////////////////////end parse



       if not TCPSocket_CanRead(site.socket,0,er) then begin
         if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
          site.Free;
          exit;
         end;
        sleep(10);
        continue;
       end;

       previous_len := length(ricevuto);
       SetLength(ricevuto,previous_len+1024);
        len := TCPSocket_RecvBuffer(site.socket,@ricevuto[previous_len+1],1024,er);

     if er=WSAEWOULDBLOCK then begin
      SetLength(ricevuto,previous_len);
      sleep(10);
      continue;
     end;
     if er<>0 then begin
       site.Free;
       exit;
     end;

   if len<1 then begin
    SetLength(ricevuto,previous_len);
    sleep(10);
    continue;
   end;

   if length(ricevuto)>previous_len+len then SetLength(ricevuto,previous_len+len);

 end; //end while receive....




site.Free;



 except
 end;

end;

end.
