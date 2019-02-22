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
this code keeps track of cache_servers addresses to perform bootstrapping
without having to query too many times gwebcache
}

unit helper_host_discovery;

interface

uses
classes,classes2,helper_strings,registry,const_ares,helper_crypt,helper_datetime,sysutils,
helper_ipfunc,helper_http,zlib,vars_global,windows;

function get_ppca(ni: Cardinal): Word;
function cache_get_1host: string; //copia da hdata a cdata
function cache_get_3hosts: string;

procedure cache_add_cache_host_patch(hosts: string; lenhosts: Byte);

procedure cache_add_cache_host(host: string);

procedure cache_get_entrieslist(lista: TStringList; reg: Tregistry);
procedure cache_merge_hkey_local_machine_entries;

procedure cache_del_cache_host(host: string);

implementation

uses
ufrmmain,const_timeouts,helper_sorting;

function get_ppca(ni: Cardinal): Word;
var
primo{,secondo,terzo,quarto}: Cardinal;
str: string;
begin

   str := int_2_dword_string(ni);
      primo := ord(str[1]);        

     Result := (primo*primo)+wh(str);
     Result := result+(primo*primo)+wh(str);
     Result := result+(primo*primo)+wh(str);
     Result := result+wh(int_2_word_string(result)+
                    int_2_word_string(1214))+
                    wh(str);
     Result := result+22809; //18+22791;
     Result := result-(12*(primo-5))+52728;
      if result<1024 then Result := result+2048; //saltiamo di misura nota...
      if result=36278 then inc(result); //mai usare la porta uguale a prima (nel nuovo protocollo

end;


procedure cache_merge_hkey_local_machine_entries;
var
reg: Tregistry;
buffer: array [0..1203] of Byte; //max 200 caches
lun_to,lun_got: Integer;
begin
lun_got := 0;

reg := tregistry.create;   //prendiamo host presenti

with reg do begin

try

 if openkey(areskey+getdatastr,false) then begin
   if valueexists(GetAresNet1) then begin    //we already have our 'user' entries
        lun_to := GetDataSize(GetAresNet1);
        if lun_to>10 then begin
         closekey;
         destroy;
         exit;
        end;
   end;
   closekey;
  end;

 rootkey := HKEY_LOCAL_MACHINE;
 if not OpenKeyReadOnly(areskey+getdatastr) then begin
  destroy;
  exit;
 end;

 if not valueexists(GetAresNet1) then begin
  closekey;
  destroy;
  exit;
 end;

  lun_to := GetDataSize(GetAresNet1);
  if lun_to=0 then begin
   closekey;
   destroy;
   exit;
  end;

  if lun_to>sizeof(buffer) then lun_to := sizeof(buffer);

  lun_got := ReadBinaryData(GetAresNet1,buffer,lun_to);
  if lun_got<>lun_to then begin
   closekey;
   destroy;
   exit;
  end;

  closekey;
 except
 end;
  destroy;
end;

  if lun_got=0 then exit;

  reg := tregistry.create;
  with reg do begin
   try
    openkey(areskey+getdatastr,true);
     WriteBinaryData(GetAresNet1,buffer,lun_got);
    closekey;
   except
   end;

  destroy;
  end;

end;


procedure cache_del_cache_host(host: string);
var
reg: Tregistry;
i: Integer;
stringa,hostcmp: string;
buffer: array [0..1203] of Byte; //max 200 caches
lista: TStringList;
begin
try

if length(host)>4 then
 delete(host,5,length(host)); //ci interessa solo ip

stringa := '';
lista := tStringList.create;

reg := tregistry.create;   //prendiamo host presenti
with reg do begin
 openkey(areskey+getdatastr,true);

 cache_get_entrieslist(lista,reg);


 for i := 0 to lista.count-1 do begin  //already in?
  hostcmp := lista.strings[i];
  delete(hostcmp,5,2); //remove stats from new 6 byte format
  if host=hostcmp then begin
   lista.delete(i);
   break;
  end;
 end;


 stringa := int_2_dword_string(0); // first null entry in new serialized DB
 while (lista.count>0) do begin  //riscriviamo nostra history
   stringa := stringa+lista.strings[0];
    lista.delete(0);
    if length(stringa)>=sizeof(buffer) then break; //ok mi basta
 end;


 while (length(stringa)<sizeof(buffer)) do
  stringa := Stringa+int_2_dword_string(0)+int_2_word_string(0);


   stringa := e67(stringa,4978);
   move(stringa[1],buffer,sizeof(buffer));
   WriteBinaryData(GetAresNet1,buffer,sizeof(buffer));


 closekey;
 destroy;
end;

lista.Free;

 except
 end;
end;

procedure cache_add_cache_host(host: string);
var
reg: Tregistry;
i: Integer;
stringa,hostcmp: string;
buffer: array [0..1203] of Byte; //max 200 caches
lista: TStringList;
begin
try

if length(host)>4 then
 delete(host,5,length(host)); //ci interessa solo ip


stringa := '';
lista := tStringList.create;

reg := tregistry.create;   //prendiamo host presenti
with reg do begin
 openkey(areskey+getdatastr,true);

 cache_get_entrieslist(lista,reg);


 for i := 0 to lista.count-1 do begin  //already in?
  hostcmp := lista.strings[i];
  delete(hostcmp,5,2); //remove stats from new 6 byte format
  if host=hostcmp then begin
   lista.delete(i);
   break;
  end;
 end;


    if lista.count>0 then lista.insert(0,host+int_2_word_string(0))  //new entry has 0 as tries count
    else
    lista.Add(host+int_2_word_string(0)); //shuffle list


 stringa := int_2_dword_string(0); // first null entry in new serialized DB
 while (lista.count>0) do begin  //riscriviamo nostra history
   stringa := stringa+lista.strings[0];
    lista.delete(0);
    if length(stringa)>=sizeof(buffer) then break; //ok mi basta
 end;


 while (length(stringa)<sizeof(buffer)) do
  stringa := Stringa+int_2_dword_string(0)+int_2_word_string(0);


   stringa := e67(stringa,4978);
   move(stringa[1],buffer,sizeof(buffer));
   WriteBinaryData(GetAresNet1,buffer,sizeof(buffer));


 closekey;
 destroy;
end;

lista.Free;

 except
 end;
end;


procedure cache_get_entrieslist(lista: TStringList; reg: Tregistry);
var
lun_to,lun_got,i: Integer;
stringa: string;
buffer: array [0..1203] of Byte;   //max 200 hosts
begin
 with reg do begin

       if not valueexists(GetAresNet1) then exit;

        lun_to := GetDataSize(GetAresNet1);
        if lun_to=0 then exit;
        if lun_to>sizeof(buffer) then lun_to := sizeof(buffer);

           lun_got := ReadBinaryData(GetAresNet1,buffer,lun_to);
           if lun_got<>lun_to then exit;

            SetLength(stringa,lun_got);
            move(buffer,stringa[1],lun_got);
             stringa := d67(stringa,4978);


             if chars_2_dword(copy(stringa,1,4))=0 then begin  //first null 4 byte entry (new format since 2953+)
                 delete(stringa,1,4);   //skip marker
               i := 1;
               while (i+6<length(stringa)) do begin //parsiamo senza un casino di deallocazioni
                if copy(stringa,i,6)=chr(0)+chr(0)+chr(0)+chr(0)+chr(0)+chr(0) then break;  //till null entry is found
                lista.add(copy(stringa,i,6));
                 inc(i,6);
               end;

             end else begin
               i := 1;
               while (i+4<length(stringa)) do begin //parsiamo senza un casino di deallocazioni
                if copy(stringa,i,4)=chr(0)+chr(0)+chr(0)+chr(0) then break;  //last null 6 byte entry is found
                lista.add(copy(stringa,i,4)+chr(0)+chr(0)); //now 6 bytes!
                 inc(i,4);
               end;
             end;

 end;


end;

procedure cache_add_cache_host_patch(hosts: string; lenhosts: Byte);
var
reg: Tregistry;
i: Integer;
stringa: string;
//lun_to,lun_got,missing: Integer;
buffer: array [0..1203] of Byte;  //max 200 hosts
host,hostcmp: string;
lista: TStringList;
//oranow: Cardinal;
begin
try

stringa := '';
reg := tregistry.create;   //prendiamo host presenti
with reg do begin
 openkey(areskey+getdatastr,true);

// oranow := delphidatetimetounix(now); //set patch date
 //writestring('Ls.'+GetAresNet1,lowercase(bytestr_to_hexstr(e2(int_2_dword_string(oranow)+chr(random($ff))+chr(random($ff)),1986))));

 lista := tStringList.create;  //get entries in registry
 cache_get_entrieslist(lista,reg);


 while (length(hosts)>=lenhosts) do begin  // add those fresh entries
   host := copy(hosts,1,4);
         delete(hosts,1,lenhosts);

   if chars_2_dword(host)=0 then continue; //null entries not allowed here

    for i := 0 to lista.count-1 do begin //duplicated entry?
     hostcmp := lista.strings[i];
     delete(hostcmp,5,2); //remove stats
     if hostcmp=host then begin
      lista.delete(i);
      break;
     end;
    end;


   if lista.count>0 then lista.insert(0,host+int_2_word_string(0))  //new entry has 0 as tries count
    else
    lista.Add(host+int_2_word_string(0)); //shuffle list
 end;



 //serialize list
  stringa := int_2_dword_string(0); //new header new format
  while (lista.count>0) do begin  //riscriviamo nostra history
   stringa := stringa+lista.strings[lista.count-1];
    lista.delete(lista.count-1);
    if length(stringa)>=sizeof(buffer) then break; //ok mi basta
  end;

 while (length(stringa)<sizeof(buffer)) do
  stringa := Stringa+int_2_dword_string(0)+int_2_word_string(0); //trailer with null entries


   stringa := e67(stringa,4978);
   move(stringa[1],buffer,sizeof(buffer));
   WriteBinaryData(GetAresNet1,buffer,sizeof(buffer));


 closekey;
 destroy;
end;
lista.Free;

 except
 end;
end;


function cache_get_1host: string; //copia da hdata a cdata
var
reg: Tregistry;
stringa,host: string;
lista: TStringList;
num_try: Word;
buffer: array [0..1203] of Byte; //max 200 caches
begin
result := '';

try

stringa := '';
lista := tStringList.create;

reg := tregistry.create;   //prendiamo host presenti
with reg do begin
 openkey(areskey+getdatastr,true);

 cache_get_entrieslist(lista,reg);
 if lista.count=0 then begin
  closekey;
  destroy;
  exit;
 end;

  lista.customsort(sort_cache_str_tires);

  host := lista.strings[0];

   num_try := chars_2_word(copy(host,5,2)); //include incremented num try var
   if num_try<65000 then inc(num_try);
   host := copy(host,1,4)+int_2_word_string(num_try);

  lista.strings[0] := host;



   Result := ipint_to_dotstring(chars_2_dword(copy(host,1,4))); //get host output format = 212.212.23.24

   //now update DB TODO use sync to get this , multiple thread may fu
   stringa := int_2_dword_string(0); // first null entry in new serialized DB
   while (lista.count>0) do begin  //riscriviamo nostra history
     stringa := stringa+lista.strings[0];
     lista.delete(0);
     if length(stringa)>=sizeof(buffer) then break; //ok mi basta
   end;

   while (length(stringa)<sizeof(buffer)) do
    stringa := Stringa+int_2_dword_string(0)+int_2_word_String(0);

   stringa := e67(stringa,4978);
   move(stringa[1],buffer,sizeof(buffer));
   WriteBinaryData(GetAresNet1,buffer,sizeof(buffer));


 closekey;
 destroy;

end;

lista.Free;

except
end;
end;




function cache_get_3hosts: string;
var
reg: Tregistry;
stringa,host: string;
lista: TStringList;
num_try: Word;
buffer: array [0..1203] of Byte; //max 200 caches
begin
result := '';


try

stringa := '';
lista := tStringList.create;

reg := tregistry.create;   //prendiamo host presenti
with reg do begin
 openkey(areskey+getdatastr,true);

 cache_get_entrieslist(lista,reg);
 if lista.count=0 then begin
  closekey;
  destroy;
  exit;
 end;

    lista.customsort(sort_cache_str_tires);


   host := lista.strings[0];
   num_try := chars_2_word(copy(host,5,2)); //include incremented num try var
   if num_try<65000 then inc(num_try);
   host := copy(host,1,4)+int_2_word_string(num_try);
   lista.strings[0] := host;
     Result := result+copy(host,1,4); //get host output format = 212.212.23.24

    if lista.count>1 then begin
         host := lista.strings[1];
         num_try := chars_2_word(copy(host,5,2)); //include incremented num try var
         if num_try<65000 then inc(num_try);
         host := copy(host,1,4)+int_2_word_string(num_try);
         lista.strings[1] := host;
           Result := result+copy(host,1,4); //get host output format = 212.212.23.24

          if lista.count>2 then begin
           host := lista.strings[2];
           num_try := chars_2_word(copy(host,5,2)); //include incremented num try var
           if num_try<65000 then inc(num_try);
           host := copy(host,1,4)+int_2_word_string(num_try);
           lista.strings[2] := host;
             Result := result+copy(host,1,4); //get host output format = 212.212.23.24
          end;
    end;



   //now update DB TODO use sync to get this , multiple thread may fu
   stringa := int_2_dword_string(0); // first null entry in new serialized DB
   while (lista.count>0) do begin  //riscriviamo nostra history
     stringa := stringa+lista.strings[0];
     lista.delete(0);
     if length(stringa)>=sizeof(buffer) then break; //ok mi basta
   end;

   while (length(stringa)<sizeof(buffer)) do
    stringa := Stringa+int_2_dword_string(0)+int_2_word_string(0);


   stringa := e67(stringa,4978);
   move(stringa[1],buffer,sizeof(buffer));
   WriteBinaryData(GetAresNet1,buffer,sizeof(buffer));


 closekey;
 destroy;
   
end;

lista.Free;


except
end;

end;





end.
