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
used by thread_upload (acceptor), gives the ability to import a list of blocked IPs (peerguardian format eg: 12.150.191.0-12.150.191.255 )
}

unit peerguard;

interface

uses
classes,vars_global,helper_diskio,windows,sysutils,class_cmdlist,
const_ares;

const
   LOW_IP_LIMIT=1;
   HIGH_IP_LIMIT=223;

   type
  precord_ban=^record_ban;
  record_ban=record
   down_range: Byte;
   up_range: Byte;
   first_child:precord_ban;
   next:precord_ban;
  end;
  
   function peerguard_is_blocked(ipS: string): Boolean; overload;
   function peerguard_is_blocked(ipC: Cardinal): Boolean; overload;
   procedure peerguard_load;
   procedure peerguard_free_bans;
   procedure peerguard_free_ban(ban:precord_ban);
   procedure peerguard_add_ban(prima,seconda1,seconda2,terza1,terza2,quarta1,quarta2: Byte);
   procedure peerguard_parse_line(str: string);
   function is_banned_ip(ip: Cardinal): Boolean;
   procedure add_ban(ip: Cardinal);

   var
    db_bans: array [LOW_IP_LIMIT..HIGH_IP_LIMIT] of pointer;
    peerguard_slots,peerguard_bytes: Integer;
    lista_banned_ip: Tnapcmdlist;
    
implementation

uses
 winsock;
 
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

result := (lista_banned_ip.FindById(ip)<>-1);
except
result := False;
end;
end;

function peerguard_is_blocked(ipS: string): Boolean;
begin
result := peerguard_is_blocked(inet_addr(PChar(ipS)));
end;

function peerguard_is_blocked(ipC: Cardinal): Boolean;
var
root,secondo_ban,terzo_ban,quarto_ban:precord_ban;
buffer: array [0..3] of Byte;
begin
result := False;


move(ipC,buffer[0],4);

if db_bans[buffer[0]]=nil then begin
exit;
end;

   root := db_bans[buffer[0]];
   if root^.first_child=nil then begin
    Result := True;
    exit;
   end;


   
   secondo_ban := root^.first_child;
   while (secondo_ban<>nil) do begin

    if secondo_ban^.down_range<=buffer[1] then
     if secondo_ban^.up_range>=buffer[1] then
       if secondo_ban^.first_child=nil then begin
        Result := True;
        exit;
       end else begin  //non è un range di livello, continuiamo al prox(terzo)

          terzo_ban := secondo_ban^.first_child;
          while (terzo_ban<>nil) do begin
              if terzo_ban^.down_range<=buffer[2] then
               if terzo_ban^.up_range>=buffer[2] then
                 if terzo_ban^.first_child=nil then begin
                   Result := True;
                    exit;
                 end else begin //non è un range di livello, continuiamo al prox(quarto)

                            quarto_ban := terzo_ban^.first_child;
                            while (quarto_ban<>nil) do begin
                               if quarto_ban^.down_range<=buffer[3] then
                                if quarto_ban^.up_range>=buffer[3] then begin
                                 Result := True;
                                 exit;
                                end;
                             quarto_ban := quarto_ban^.next;
                           end;

                 end;

           terzo_ban := terzo_ban^.next;
          end;

       end;

     secondo_ban := secondo_ban^.next;
   end;


end;

procedure peerguard_load;
var
 filename: WideString;
 numero: Cardinal;
 stream: Thandlestream;
 letti: Integer;
 str_big: string;
 str: string;
 buffer: array [0..1023] of char;
begin


try

peerguard_free_bans;
  
 peerguard_add_ban(38,113,119,0,255,0,255);   //sexytime 2964
   peerguard_add_ban(72,20,20,63,63,0,255);  //+ 10-6-2005
   peerguard_add_ban(72,35,35,224,224,0,255);
   peerguard_add_ban(69,26,26,174,174,0,255);
   peerguard_add_ban(66,198,198,35,35,0,255);
   peerguard_add_ban(66,110,110,61,61,0,255);
   peerguard_add_ban(64,86,86,234,234,0,255);
   peerguard_add_ban(64,86,86,230,230,0,255);
   peerguard_add_ban(64,70,70,7,7,0,255);
   peerguard_add_ban(64,70,70,6,6,0,255);
   peerguard_add_ban(64,70,70,45,45,0,255);
   peerguard_add_ban(63,236,236,161,161,0,255);
   peerguard_add_ban(63,222,222,6,6,0,255);
   peerguard_add_ban(63,217,217,27,27,0,255);
   peerguard_add_ban(63,216,216,76,76,0,255);
   peerguard_add_ban(216,156,156,142,142,0,255);
   peerguard_add_ban(216,151,151,141,141,0,255);
   peerguard_add_ban(209,247,247,161,161,0,255);
   peerguard_add_ban(207,45,45,196,196,0,255);
   peerguard_add_ban(207,226,226,112,112,0,255);
   peerguard_add_ban(207,218,218,30,30,0,255);
   peerguard_add_ban(207,176,176,22,22,0,255);
   peerguard_add_ban(206,161,161,11,11,0,255);
   peerguard_add_ban(205,252,252,0,0,0,255);
   peerguard_add_ban(205,177,177,3,3,0,255);
   peerguard_add_ban(204,11,11,19,19,0,255);

   
  filename := vars_global.data_path+'\Data\Blocked.txt';

  if not fileexistsW(filename) then exit;

  stream := MyFileOpen(filename,ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then exit;

   numero := 0;
   str_big := '';
while (stream.position<stream.Size-1) do begin
  letti := stream.Read(buffer,sizeof(buffer));

  SetLength(str,letti);
  move(buffer[0],str[1],letti);
  str_big := str_big+str;
   while (pos(CRLF,str_big)>0) do begin
     str := copy(str_big,1,pos(CRLF,str_big)-1);
          delete(str_big,1,pos(CRLF,str_big)+1);
        if length(str)>1 then begin //commants?
         if str[1]='#' then continue else
          if str[1]='/' then continue else
           if str[1]=';' then continue;
        end;
          inc(numero);
           peerguard_parse_line(str);
   end;

  if letti<sizeof(buffer) then break;
end;

FreeHandleStream(Stream);

except
end;
end;

procedure peerguard_parse_line(str: string);
var
ip_range,host_inizio,host_fine: string;
prima1,seconda1,terza1,quarta1: Integer;
{prima2,}seconda2,terza2,quarta2: Integer;
begin
try
   if pos(':',str)>0 then ip_range := copy(str,pos(':',str)+1,length(str)) else ip_range := str;
   ip_range := trim(ip_range);

    if pos('-',ip_range)>0 then begin
     host_inizio := copy(ip_range,1,pos('-',ip_range)-1);
     host_fine := copy(ip_range,pos('-',ip_range)+1,length(ip_range));
    end else begin
     host_inizio := ip_range;
     host_fine := ip_range;
    end;

     prima1 := strtointdef(copy(host_inizio,1,pos('.',host_inizio)-1),0);
      delete(host_inizio,1,pos('.',host_inizio));
     seconda1 := strtointdef(copy(host_inizio,1,pos('.',host_inizio)-1),0);
      delete(host_inizio,1,pos('.',host_inizio));
     terza1 := strtointdef(copy(host_inizio,1,pos('.',host_inizio)-1),0);
      delete(host_inizio,1,pos('.',host_inizio));
     quarta1 := strtointdef(host_inizio,0);

    // prima2 := strtointdef(copy(host_fine,1,pos('.',host_fine)-1),0);
      delete(host_fine,1,pos('.',host_fine));
     seconda2 := strtointdef(copy(host_fine,1,pos('.',host_fine)-1),0);
      delete(host_fine,1,pos('.',host_fine));
     terza2 := strtointdef(copy(host_fine,1,pos('.',host_fine)-1),0);
      delete(host_fine,1,pos('.',host_fine));
     quarta2 := strtointdef(host_fine,0);
      peerguard_add_ban(prima1,seconda1,seconda2,terza1,terza2,quarta1,quarta2);
 except
 end;
end;

procedure peerguard_free_bans;
var
i: Integer;
ban1:precord_ban;
begin
 for i := low(db_bans) to high(db_bans) do begin
  if db_bans[i]=nil then continue;
     ban1 := db_bans[i];
     peerguard_free_ban(ban1);
     db_bans[i] := nil;
 end;

 peerguard_slots := 0;
 peerguard_bytes := 0;
end;

procedure peerguard_free_ban(ban:precord_ban);
var
nextban:precord_ban;
begin
   while (ban<>nil) do begin
       nextban := ban^.next;
        if ban^.first_child<>nil then peerguard_free_ban(ban^.first_child);
        FreeMem(ban,sizeof(record_ban));
        ban := nextban;
   end;
end;

procedure peerguard_add_ban(prima,seconda1,seconda2,terza1,terza2,quarta1,quarta2: Byte);
var
root:precord_ban;
secondo,terzo,quarto:precord_ban;
trovato: Boolean;
begin
 if prima>high(db_bans) then exit;
 if prima<low(db_bans) then exit;
 
 if db_bans[prima]=nil then begin  //aggiungiamo root
  root := AllocMem(sizeof(record_ban));
  root^.first_child := nil;
  root^.next := nil;
  db_bans[prima] := root;
  inc(peerguard_slots);
  inc(peerguard_bytes,sizeof(record_ban));
 end else root := db_bans[prima];

  if seconda2-seconda1=255 then begin  //inutile aggiungere child a root
   // memo1.lines.add('ban primo tutto range:'+inttostr(prima)+'.0.0.0');
    exit;
  end;

  /////////////////////////////////////////////////////////////seconda otteto
  trovato := False;
   secondo := root^.first_child;
   while (secondo<>nil) do begin
      if secondo^.up_range<seconda2 then begin
       secondo := secondo^.next;
       continue;
      end;
      if secondo^.down_range>seconda1 then begin
       secondo := secondo^.next;
       continue;
      end;
      trovato := True;
      break;
   end;

   if not trovato then begin
    secondo := AllocMem(sizeof(record_ban));
     secondo^.down_range := seconda1;
     secondo^.up_range := seconda2;
     secondo^.first_child := nil;
     secondo^.next := root^.first_child;
     root^.first_child := secondo;
       inc(peerguard_slots);
  inc(peerguard_bytes,sizeof(record_ban));
   end;

   if terza2-terza1=255 then begin
     if secondo^.first_child<>nil then begin
       peerguard_free_ban(secondo^.first_child);
       secondo^.first_child := nil;
     end;
    exit; //mi fermo, inutile aggiungere child
   end;

   //////////////////////////////////////terzo
  trovato := False;
   terzo := secondo^.first_child;
   while (terzo<>nil) do begin
      if terzo^.up_range<terza2 then begin
       terzo := terzo^.next;
       continue;
      end;
      if terzo^.down_range>terza1 then begin
       terzo := terzo^.next;
       continue;
      end;
      trovato := True;
      break;
   end;

   if not trovato then begin
    terzo := AllocMem(sizeof(record_ban));
     terzo^.down_range := terza1;
     terzo^.up_range := terza2;
     terzo^.first_child := nil;
     terzo^.next := secondo^.first_child;
     secondo^.first_child := terzo;
       inc(peerguard_slots);
  inc(peerguard_bytes,sizeof(record_ban));
   end;

   if quarta2-quarta1=255 then begin
     if terzo^.first_child<>nil then begin
       peerguard_free_ban(terzo^.first_child);
       terzo^.first_child := nil;
     end;
    exit; //mi fermo, inutile aggiungere child
   end;

   ///////////////////////////////////////////////////////////////////quarta
  trovato := False;
   quarto := terzo^.first_child;
   while (quarto<>nil) do begin
      if quarto^.up_range<quarta2 then begin
       quarto := quarto^.next;
       continue;
      end;
      if quarto^.down_range>quarta1 then begin
       quarto := quarto^.next;
       continue;
      end;
      trovato := True;
      break;
   end;

   if not trovato then begin
    quarto := AllocMem(sizeof(record_ban));
     quarto^.down_range := quarta1;
     quarto^.up_range := quarta2;
     quarto^.first_child := nil;
     quarto^.next := terzo^.first_child;
     terzo^.first_child := quarto;
       inc(peerguard_slots);
      inc(peerguard_bytes,sizeof(record_ban));
   end;
end;

end.
