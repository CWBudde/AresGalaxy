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
code of .Arescol collection format, used to import multiple hashlinks at once
}

unit helper_arescol;

interface

uses
classes,classes2,windows,sysutils;

function arescol_get_meta(nomefile: WideString; var title,comment,url: string; var mime:integer): Boolean;
procedure arescol_download(str: string);
procedure arescol_parse_file(filename: WideString);


implementation

uses
helper_ipfunc,helper_diskio,helper_crypt,helper_strings,helper_unicode,
ares_types,helper_mimetypes,vars_global,ufrmmain,helper_download_misc,
ares_objects,const_ares;


procedure arescol_parse_file(filename: WideString);
var
stream: Thandlestream;
buffer: array [0..1023] of char;
len,previous_len: Integer;
str: string;
begin
stream := MyFileOpen(filename,ARES_READONLY_ACCESS);
if stream=nil then exit;

str := '';

with stream do begin
try

 while (position+1<size) do begin
  len := read(buffer,sizeof(buffer));

     previous_len := length(str);
     SetLength(str,previous_len+len);
     move(buffer,str[previous_len+1],len);

  if len<sizeof(buffer) then break;
 end;

 except
 end;
end;
FreeHandleStream(stream);

if pos('ARES.COLLECTIONLIST1.0'+CRLF,str)=1 then arescol_download(str);
end;

procedure arescol_download(str: string);
var
cont: string;
num: Byte;
lung: Word;
folder,filename,title,artist,album,category,language,date,comment,url,hash,str_temp: string;
ip_user,param1,param2,param3: Cardinal;
size: Int64;
port_user: Word;
down: Tdownload;
risorsa: Trisorsa_download;
pfile:precord_file_library;
lista_ip: TMyStringList;
begin
try
delete(str,1,24);

str := d67(str,15692); //small decrypt

          ip_user := 0; port_user := 0; url := ''; comment := '';
          date := ''; language := ''; category := ''; title := '';
          artist := ''; album := ''; folder := ''; language := '';
          hash := ''; filename := ''; size := 0;
          param1 := 0; param2 := 0; param3 := 0;
          lista_ip := nil;

while (length(str)>1) do begin
 num := ord(str[1]);
 lung := chars_2_word(copy(str,2,2));
  cont := copy(str,4,lung);
 delete(str,1,3+lung);

  case num of
   0:; //skip archive META details 
   1:folder := cont;
   2:size := chars_2_dword(copy(cont,1,4));
   3:filename := cont;
   4: Title := cont;
   5:artist := cont;
   6:album := cont;
   7:category := cont;
   8:language := cont;
   9:date := cont;
   10:comment := cont;
   11:url := cont;
   12:begin
        if lista_ip=nil then lista_ip := tmyStringList.create;
        lista_ip.add(copy(cont,1,6));
      end;
   13:param1 := chars_2_dword(copy(cont,1,4));
   14:param2 := chars_2_dword(copy(cont,1,4));
   15:param3 := chars_2_dword(copy(cont,1,4));
   16:size := chars_2_Qword(copy(cont,1,8)); //2951+
   50:begin

      pfile := AllocMem(sizeof(record_file_library));
       pfile^.hash_sha1 := copy(cont,1,20);
       pfile^.fsize := size;
       pfile^.path := filename;
       pfile^.ext := lowercase(extractfileext(filename));
       pfile^.amime := extstr_to_mediatype(pfile^.ext);
       pfile^.title := title;
       pfile^.artist := artist;
       pfile^.album := album;
       pfile^.category := category;
       pfile^.language := language;
       pfile^.year := date;
       pfile^.comment := comment;
       pfile^.url := url;
       pfile^.param1 := param1;
       pfile^.param2 := param2;
       pfile^.param3 := param3;

        down := start_download(pfile,utf8strtowidestr(folder));
        lista_down_temp.add(down);
        if lista_ip<>nil then begin
          while (lista_ip.count>0) do begin
           str_temp := lista_ip.strings[lista_ip.count-1];
             lista_ip.delete(lista_ip.count-1);
           ip_user := chars_2_dword(copy(str_temp,1,4));
           port_user := chars_2_word(copy(str_temp,5,2));
             if port_user<>0 then
              if ip_user<>0 then begin
              risorsa := trisorsa_download.create;
              with risorsa do begin
                handle_download := cardinal(down);
                ip := ip_user;
                porta := port_user;
                ip_interno := 0;
                nickname := STR_ANON+ip_to_hex_str(ip_user)+STR_UNKNOWNCLIENT;
                tick_attivazione := 0;
                socket := nil;
                download := down;
                AddVisualReference;
              end;
               down.lista_risorse.add(risorsa); //non può essere duplicata, nessun controllo necessario }
              end;
           end;
           lista_ip.Free;
           lista_ip := nil;
          end;
       with pfile^ do begin
        hash_sha1 := '';
        hash_of_phash := '';
        path := '';
        title := '';
        artist := '';
        album := '';
        category := '';
        language := '';
        year := '';
        comment := '';
        url := '';
       end;
        FreeMem(pfile,sizeof(record_file_library));

          ip_user := 0; port_user := 0; url := ''; comment := '';
          date := ''; language := ''; category := ''; title := '';
          artist := ''; album := ''; folder := ''; language := '';
          hash := ''; filename := ''; size := 0;
          param1 := 0; param2 := 0; param3 := 0;

      end;
  end;
end;

  if ares_frmmain.tabs_pageview.activepage<>IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activepage := IDTAB_TRANSFER;

except
end;
end;

function arescol_get_meta(nomefile: WideString; var title,comment,url: string; var mime:integer): Boolean;
  type
  precord_file=^record_file;
  record_file=record
   fname,hash_sha1,estensione: string;
   size: Int64;
   lista_sources: TStringList;
   title,
   artist,
   album,
   category,
   language,
   date,
   url,
   comments,folder: string;
   param1,param2,param3: Cardinal;
   imageindex: Byte;
  end;

var
stream: Thandlestream;
str: string;
previous_len,len: Integer;
buffer: array [0..1023] of char;


cont,cont2: string;
num,num2: Byte;
lung,lung2: Word;


begin
result := False;
title := ''; comment := ''; url := ''; mime := 0;


stream := MyFileOpen(nomefile,ARES_READONLY_ACCESS);
if stream=nil then exit;

with stream do begin

try
str := '';

while (position+1<size) do begin
  len := read(buffer,sizeof(buffer));

     previous_len := length(str);
     SetLength(str,previous_len+len);
     move(buffer,str[previous_len+1],len);

  if len<sizeof(buffer) then break;
end;

 except
 end;
end;
FreeHandleStream(stream);

 if pos('ARES.COLLECTIONLIST1.0'+CRLF,str)<>1 then exit;


delete(str,1,24);
str := d67(str,15692);

          while (length(str)>1) do begin
            num := ord(str[1]);
            lung := chars_2_word(copy(str,2,2));
            cont := copy(str,4,lung);
            delete(str,1,3+lung);

             case num of
              0:begin
                 while (length(cont)>3) do begin
                   num2 := ord(cont[1]);
                   lung2 := chars_2_word(copy(cont,2,2));
                   cont2 := copy(cont,4,lung2);
                   delete(cont,1,3+lung2);
                    case num2 of
                     1: Title := utf8strtowidestr(cont2);
                     2:comment := utf8strtowidestr(cont2);
                     5:url := cont2; //ansi normal
                     6:mime := ord(cont2[1]);
                    end;
                  end;
              end;
             end;
          end;
end;

end.
