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
load/save shared folder(s) list
}

unit helper_share_settings;

interface

uses
ares_types,sysutils,classes,helper_urls,helper_diskio,windows,
helper_unicode,helper_strings,classes2,tntwindows,vars_global,
const_ares;

procedure write_to_file_shared_folders(prima_cartella:precord_cartella_share); // synchro
function add_this_shared_folder(var prima_cartella_shared:precord_cartella_share; folder: WideString):precord_cartella_share;
procedure get_shared_folders(var prima_cartella_shared:precord_cartella_share; add_defaults:boolean); // synchro


implementation

uses
ufrmmain;

procedure add_default_paths(var prima_cartella_shared:precord_cartella_share);
const
MY_SHARED_FOLDER='\'+STR_MYSHAREDFOLDER;
INCOMING='\Incoming';
var
app_paths,path: WideString;
begin
  app_paths := Get_Programs_Path+'\';
  
       path := app_paths+'Ares'+MY_SHARED_FOLDER;
       if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
        path := app_paths+'eMule'+INCOMING;
        if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
         path := app_paths+'Shareaza\Downloads';
         if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
          path := app_paths+'KaZaA'+MY_SHARED_FOLDER;;
          if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
           path := app_paths+'KaZaa Lite'+MY_SHARED_FOLDER;;
           if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
            path := app_paths+'BearShare\Shared';
            if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
             path := app_paths+'Morpheus'+MY_SHARED_FOLDER;;
             if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
              path := app_paths+'direct connect\received files';
              if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
               path := app_paths+'gnucleus\downloads';
               if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                path := app_paths+'grokster\my grokster';
                if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                 path := app_paths+'icq\shared files';
                 if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                  path := app_paths+'limeWire\shared';
                  if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                   path := app_paths+'edonkey2000'+INCOMING;;
                   if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                    path := app_paths+'Overnet'+INCOMING;;
                    if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                    path := app_paths+'Lopster\complete';
                     if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                     path := app_paths+'KCEasy'+MY_SHARED_FOLDER;;
                      if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                      path := app_paths+'Warez P2P Client'+MY_SHARED_FOLDER;;
                       if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
                       path := app_paths+'FileCroc'+MY_SHARED_FOLDER;;
                        if direxistsW(path) then add_this_shared_folder(prima_cartella_shared,path);
end;

procedure get_shared_folders(var prima_cartella_shared:precord_cartella_share; add_defaults:boolean); // synchro
var
i: Integer;
str: string;
previous_len: Integer;
widestr: WideString;
stream: Thandlestream;
len: Integer;
buffer: array [0..1023] of char;
begin
 if add_defaults then add_default_paths(prima_cartella_shared);


  stream := MyFileOpen(data_path+'\data\Shared Folders.txt',ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then exit;

  str := '';
  while (stream.position+1<stream.size) do begin
    len := stream.read(buffer,sizeof(buffer));
    if len>0 then begin
     previous_len := length(str);
     SetLength(str,previous_len+len);
     move(buffer,str[previous_len+1],len);
    end else break;
  end;

FreeHandleStream(Stream);

//parsiamo str...

if length(str)=0 then exit;
  widestr := utf8strtowidestr(str);

  while (length(widestr)>0) do begin
    for i := 1 to length(widestr)-1 do begin
      if integer(widestr[i])=13 then
       if integer(widestr[i+1])=10 then begin
       // if i>3 then
        add_this_shared_folder(prima_cartella_shared,copy(widestr,1,i-1));

       // else begin //se è un drive intero
          //  DriveType := GetDriveType(PChar(widestrtoutf8str(copy(widestr,1,i-1))));
           // if DriveType<>DRIVE_FIXED then
         //   add_this_shared_folder(prima_cartella_shared,copy(widestr,1,i-1)); //cdrom lo permettiamo tutto
       // end;
        delete(widestr,1,i+1);
        break;
       end;
    end;
  end;


end;


function add_this_shared_folder(var prima_cartella_shared:precord_cartella_share; folder: WideString):precord_cartella_share;
 var
 cartella:precord_cartella_share;
 crcpath: Word;
 path_utf8,lopath: string;
 begin
 Result := nil;
 if length(folder)<3 then begin
 exit;
 end;

   path_utf8 := widestrtoutf8str(folder);
   lopath := lowercase(path_utf8);
   crcpath := stringcrc(lopath,true);


   if prima_cartella_shared<>nil then begin   //check already existing?
      cartella := prima_cartella_shared;
      while (cartella<>nil) do begin

       if length(lopath)>length(cartella^.path_utf8) then
          if copy(lopath,1,length(cartella^.path_utf8)+1)=lowercase(cartella^.path_utf8)+'\' then exit; //ho già parent

        if cartella^.crcpath=crcpath then
          if lowercase(cartella^.path_utf8)=lopath then exit; //altready there

          cartella := cartella^.next;
      end;
    end;

      cartella := AllocMem(sizeof(record_cartella_share));
        cartella^.prev := nil;
        cartella^.first_child := nil;
        cartella.parent := nil;

       cartella^.path_utf8 := path_utf8;
       cartella^.crcpath := crcpath;
       cartella^.items := 0;
       cartella^.items_shared := 0;
       cartella^.path := folder;
           cartella^.next := prima_cartella_shared; //agganciamo a precedente
           if prima_cartella_shared<>nil then prima_cartella_shared^.prev := cartella;
           prima_cartella_shared := cartella;

           Result := cartella;
 end;


procedure write_to_file_shared_folders(prima_cartella:precord_cartella_share); // synchro
   procedure scrivi_su_file_prima_cartella(prima_cartella:precord_cartella_share; lista: TMyStringList);
    var cartella:precord_cartella_share;
    begin
      cartella := prima_cartella;
     while (cartella<>nil) do begin
         if cartella^.first_child<>nil then scrivi_su_file_prima_cartella(cartella^.first_child,lista);
              lista.add(cartella^.path_utf8);

          cartella := cartella^.next;
     end;
    end;

var
i,h: Integer;
stream: Thandlestream;
lista: TMyStringList;
str,str1,str2: string;
to_delete: Boolean;
    buffer: array [0..1024] of char;
begin
 tntwindows.Tnt_CreateDirectoryW(pwidechar(data_path+'\Data'),nil);


stream := MyFileOpen(data_path+'\Data\Shared Folders.txt',ARES_CREATE_ALWAYSAND_WRITETHROUGH);
if stream=nil then exit;

stream.size := 0; //cancelliamo contenuto file

lista := tmyStringList.create;
try

scrivi_su_file_prima_cartella(prima_cartella,lista);

/////////////////////////////////////////togliamo doppi share!!!
i := 0;
while (i<lista.count) do begin
  str1 := lista.strings[i];
  to_deletE := falsE;
     for h := 0 to lista.count-1 do begin
        if h=i then continue;
          str2 := lowercase(lista.strings[h]);
           if lowercase(copy(str1,1,length(str2)+1))=str2+'\' then begin
            to_delete := True;
            break;
           end;
    end;
    if to_delete then lista.delete(i) else inc(i);
end;
////////////////////////////////////////////////////


///////////////////////////////ora scriviamo su disco
while (lista.count>0) do begin
 str := lista.strings[lista.count-1]+CRLF;
  lista.delete(lista.count-1);
    move(str[1],buffer,length(str));
    stream.Write(buffer,length(str));
    FlushFileBuffers(stream.handle);
end;

except
end;

FreeHandleStream(Stream);
lista.Free;
end;


end.
