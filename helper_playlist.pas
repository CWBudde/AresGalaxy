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
code of playlist 
}

unit helper_playlist;

interface

uses
classes,classes2,sysutils,ares_types,helper_player,windows,DSPack,forms,controls;

procedure playlist_addfolder(folder: WideString);
procedure playlist_addfile(filename: string; duration: Integer; silent: Boolean; strdisplay: string);
procedure playlist_loadm3u(filename: WideString; silent:boolean);
procedure playlist_savem3u(filename: WideString);
procedure playlist_select_prev;
function playlist_select_next: Boolean;
procedure playlist_playnext(filename: WideString);
procedure playlist_selectfile;           // se la playlist ÅEaperta selezioniamo quella che sta suonando? ma prima deselezioniamo gli altri
procedure toggle_playlist;
procedure playlist_loadpls(filename: WideString);
procedure playlist_loadwax(filename: WideString);


implementation

uses
 ufrmmain,helper_mimetypes,helper_diskio,comettrees,
 helper_unicode,vars_global,const_ares,helper_strings,
 vars_localiz,shoutcast,umediar,helper_bighints,uplaylistfrm,
 helper_skin;



procedure toggle_playlist;
//var
//bordWidth,captionHeight,bordheight: Integer;
begin
if playlist_visible then begin
 ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
 exit;
end;
//tasti

with ares_frmmain do begin

addfile1.caption := GetLangStringW(STR_ADD_FILETOPLAYLIST);
addfolder1.caption := GetLangStringW(STR_ADD_FOLDERTOPLAYLIST);
playlist_Removeselected1.caption := GetLangStringW(STR_DELETEFILEFROMPLAYLIST);
playlist_RemoveAll1.caption := GetLangStringW(STR_CLEARPLAYLIST);
//menu  load/save
Loadplaylist1.caption := GetLangStringW(STR_LOADPLAYLIST);
Saveplaylist1.caption := GetLangStringW(STR_SAVEPLAYLIST);
//popupmenu1
playlist_RemoveAll1.caption := GetLangStringW(STR_REMOVEALL);
playlist_Removeselected1.caption := GetLangStringW(STR_REMOVESELECTED);
playlist_openext.caption := GetLangStringW(STR_OPENEXTERNAL);
playlist_Locate.caption := GetLangStringW(STR_LOCATEFILE);
playlist_Sort1.caption := GetLangStringW(STR_SORT);
playlist_Alphasortasc.caption := GetLangStringW(STR_ALPHASORTASCENDING);
playlist_Alphasortdesc.caption := GetLangStringW(STR_ALPHASORTDESCENDING);
playlist_sortInv.caption := GetLangStringW(STR_SHUFFLELIST);
playlist_Randomplay1.caption := GetLangStringW(STR_SHUFFLE);
playlist_Continuosplay1.caption := GetLangStringW(STR_REPEAT);

 if widestrtoutf8str(tray_minimize.caption)=GetLangStringA(STR_SHOW_ARES) then ufrmmain.ares_frmmain.tray_MinimizeClick(nil);

 if blendPlaylistForm=nil then begin
  blendPlaylistForm := tPlaylistform.create(ares_frmmain);
  blendPlaylistForm.AlphaBlendValue := 0;
  blendPlaylistForm.AlphaBlend := True;
  panel_playlist.parent := blendPlaylistForm;
  panel_playlist.align := alClient;
  panel_playlist.visible := True;
  blendPlaylistForm.BorderStyle := bsNone;
  blendPlaylistForm.height := 350;
 end;

  if helper_skin.SkinnedFrameLoaded then begin
   blendPlaylistForm.top := (ares_frmmain.top+GetSystemMetrics(SM_CYSIZEFRAME)+Helper_skin.fcaptionHeight+ares_frmmain.trackbar_player.top)-350;
   blendPlaylistForm.left := ares_frmmain.left+ares_frmmain.clientPanel.left+GetSystemMetrics(SM_CXSIZEFRAME)-1;
   blendPlaylistForm.width := ares_frmmain.clientPanel.clientwidth;
  end else begin
   blendPlaylistForm.top := (ares_frmmain.top+GetSystemMetrics(SM_CYCAPTION)+GetSystemMetrics(SM_CYFRAME)+ares_frmmain.trackbar_player.top)-350;
   blendPlaylistForm.left := ares_frmmain.left+GetSystemMetrics(SM_CXFRAME);
   blendPlaylistForm.width := ares_frmmain.clientwidth;
  end;

  if ares_frmmain.tabs_pageview.activePage=IDTAB_SCREEN then blendPlaylistForm.color := $00292929
   else blendPlaylistForm.color := $00000000;
   ares_frmmain.panel_playlist.color := blendPlaylistForm.color;
   ares_frmmain.listview_playlist.color := blendPlaylistForm.color;
   ares_frmmain.listview_playlist.BGColor := ares_frmmain.listview_playlist.color;
   btn_playlist_close.colorbg := blendPlaylistForm.color;
   btn_playlist_close.color := blendPlaylistForm.color;
   

  blendPlaylistForm.OnDeactivate := ufrmmain.ares_frmmain.blendPlaylistFormDeactivate;

 playlist_visible := True;

 blendPlaylistForm.AlphaBlendValue := 0;
 blendPlaylistForm.visible := True;

while (blendPlaylistForm.AlphaBlendValue<200) do begin
 blendPlaylistForm.AlphaBlendValue := blendPlaylistForm.AlphaBlendValue+4;
 application.processmessages;
end;

 ufrmmain.ares_frmmain.panel_playlistResize(nil);

end;
end;


procedure playlist_selectfile;           // se la playlist ÅEaperta selezioniamo quella che sta suonando? ma prima deselezioniamo gli altri
var
 node:pCmtVnode;
 data:ares_types.precord_file_playlist;
 nomecomp: string;
begin
try
nomecomp := widestrtoutf8str(player_actualfile);

node := ares_frmmain.listview_playlist.getfirst;
while (node<>nil) do begin
 data := ares_frmmain.listview_playlist.getdata(node);
  if data^.filename=nomecomp then begin
   ares_frmmain.listview_playlist.selected[node] := True;
   exit;
  end;
node := ares_frmmain.listview_playlist.getnext(node);
end;

except
end;
end;

procedure playlist_playnext(filename: WideString);
begin
if filename<>'' then begin
 player_playnew(filename);
 exit;
end;

if playlist_select_next then
 ufrmmain.ares_frmmain.listview_playlistDblClick(nil);
end;

function playlist_select_next: Boolean;
var
i: Integer;
nodo,nodo1:pCmtVnode;
voluto: Integer;
begin
result := False;
if ares_frmmain.listview_playlist.rootnodecount<1 then exit;

nodo := ares_frmmain.listview_playlist.getfirstselected;
if nodo=nil then begin
 nodo := ares_frmmain.listview_playlist.getfirst;
 if nodo<>nil then ares_frmmain.listview_playlist.selected[nodo] := True;
 Result := True;
 exit;
end;


if ares_frmmain.playlist_Randomplay1.checked then begin
 voluto := random(ares_frmmain.listview_playlist.rootnodecount);
 i := 0;
 repeat
 if i=0 then nodo := ares_frmmain.listview_playlist.getfirst
  else nodo := ares_frmmain.listview_playlist.getnext(nodo);
 if nodo=nil then break;

  if i=voluto then begin
   ares_frmmain.listview_playlist.selected[nodo] := True;
   Result := True;
   exit;
  end;

  inc(i);
 until (not true);
exit;
end;

nodo := ares_frmmain.listview_playlist.getfirstselected;
if nodo=nil then exit;

nodo1 := ares_frmmain.listview_playlist.getnext(nodo);
if nodo1=nil then begin
  if not ares_frmmain.playlist_Continuosplay1.checked then exit; //non ripetere playlist o file

   nodo1 := ares_frmmain.listview_playlist.getfirst;
   ares_frmmain.listview_playlist.selected[nodo1] := True;
end else ares_frmmain.listview_playlist.selected[nodo1] := True;

result := True;

end;


procedure playlist_select_prev;
var
i: Integer;
nodo,nodo1,nodoroot:pCmtVnode;
voluto: Integer;
begin
if ares_frmmain.listview_playlist.rootnodecount<2 then exit;
nodo := ares_frmmain.listview_playlist.getfirstselected;

if nodo=nil then begin
 nodo := ares_frmmain.listview_playlist.getfirst;
 if nodo<>nil then ares_frmmain.listview_playlist.selected[nodo] := True;
 exit;
end;

if ares_frmmain.playlist_Randomplay1.checked then begin
 voluto := random(ares_frmmain.listview_playlist.rootnodecount);
 i := 0;
 repeat
 if i=0 then nodo := ares_frmmain.listview_playlist.getfirst
  else nodo := ares_frmmain.listview_playlist.getnext(nodo);
 if nodo=nil then break;

  if i=voluto then begin
   ares_frmmain.listview_playlist.selected[nodo] := True;
   exit;
  end;

  inc(i);
 until (not true);
end;


 nodoroot := ares_frmmain.listview_playlist.getfirst;
 if nodo=nodoroot then begin // se sono il primo seleziono l'ultimo
   repeat
   nodo1 := ares_frmmain.listview_playlist.getnext(nodo);
   if nodo1=nil then begin
    ares_frmmain.listview_playlist.Selected[nodo] := True;
    exit;
   end;
   nodo := nodo1;
   until (not true);
 end else begin        //altrimenti decremento e basta
  nodo1 := ares_frmmain.listview_playlist.GetPrevious(nodo);
  ares_frmmain.listview_playlist.Selected[nodo1] := True;
 end;

end;

procedure playlist_savem3u(filename: WideString);
var
nodo:pCmtVnode;
data:ares_types.precord_file_playlist;
stream: Thandlestream;
buffer: array [0..2047] of char;
str: string;
begin
try

  stream := myfileopen(filename,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
  if stream=nil then exit;

  str := '#EXTM3U'+CRLF;
  move(str[1],buffer,length(str));
  stream.write(buffer,length(str));

nodo := ares_frmmain.listview_playlist.getfirst;
while (nodo<>nil) do begin
 data := ares_frmmain.listview_playlist.getdata(nodo);

 str := '#EXTINF:'+
      inttostr(data^.length)+','+
      data^.displayName+CRLF+
      data^.filename+CRLF;
   move(str[1],buffer,length(str));
   stream.write(buffer,length(str));

 nodo := ares_frmmain.listview_playlist.getnext(nodo);
end;

FreeHandleStream(Stream);

except
end;
end;

procedure playlist_loadwax(filename: WideString);
var
 stringa: string;
 stream: Thandlestream;
 letti: Integer;
 temp_str: string;
 buffer: array [0..2047] of char;
 url: string;
begin
if not fileexistsW(filename) then exit;

  stream := myfileopen(filename,ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then exit;

  stringa := '';
 while (stream.position+1<stream.size) do begin
  letti := stream.read(buffer,sizeof(buffer));
  SetLength(temp_str,letti);
  move(buffer,temp_str[1],letti);
  stringa := stringa+temp_str;
 end;

 FreeHandleStream(Stream);

 if pos('<ref href',lowercase(stringa))=0 then exit; //wrong format
 delete(stringa,1,pos('<ref href',lowercase(stringa))+8);
 delete(stringa,1,pos('"',stringa));
 delete(stringa,pos('"',stringa),length(stringa));


 url := trim(stringa);

 shoutcast.openRadioUrl(url);

end;

procedure playlist_loadpls(filename: WideString);
var
 stringa: string;
 stream: Thandlestream;
 letti: Integer;
 temp_str: string;
 buffer: array [0..2047] of char;
 url: string;
 tmplist: TMyStringList;
 ind,i: Integer;
begin
try

if not fileexistsW(filename) then exit;



  stream := myfileopen(filename,ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then exit;

  stringa := '';
 while (stream.position+1<stream.size) do begin
  letti := stream.read(buffer,sizeof(buffer));
  SetLength(temp_str,letti);
  move(buffer,temp_str[1],letti);
  stringa := stringa+temp_str;
 end;

 FreeHandleStream(Stream);


 url := '';
 tmplist := tmyStringList.create;
 ind := pos(chr(10),stringa);
 while (ind>0) do begin
   tmplist.add(copy(stringa,1,ind-1));
   delete(stringa,1,ind);
    ind := pos(chr(10),stringa);
 end;

 for i := 0 to tmplist.count-1 do begin
   stringa := tmplist[i];

   if (pos('file1=',lowercase(stringa))=0) and
      (pos('file2=',lowercase(stringa))=0) then continue;
   delete(stringa,1,6);
   url := trim(copy(stringa,1,length(stringa)));
   break;
 end;

 tmplist.Free;
 //if pos('[playlist]',stringa)=0 then exit; //wrong format
 //delete(stringa,1,pos('[playlist]',stringa)+9);
 //if pos('file1=',lowercase(stringa))=0 then exit; //happens on shoutcast's website
 //delete(stringa,1,pos('file1=',lowercase(stringa))+5);
 //url := trim(copy(stringa,1,pos(chr(10),stringa)-1));
  {
  if ((shoutcast.isPlayingShoutcast) or
    (shoutcast.isConnectingShoutcast)) then begin
    shoutcast.nextstation := url;
    ares_frmmain.TmrNilAll.Enabled := True;
  end else }
  if length(url)>5 then shoutcast.openRadioUrl(url);

except
end;
end;

procedure playlist_loadm3u(filename: WideString; silent:boolean);
var

stringa: string;
strtempo: string;
stream: Thandlestream;
letti: Integer;
temp_str,strdisplay: string;
buffeR: array [0..2047] of char;
tempoi: Cardinal;
begin
try
if not fileexistsW(filename) then exit;

  stream := myfileopen(filename,ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then exit;

stringa := '';
while (stream.position+1<stream.size) do begin
 letti := stream.read(buffer,sizeof(buffer));
 SetLength(temp_str,letti);
 move(buffer,temp_str[1],letti);
 stringa := stringa+temp_str;
end;

FreeHandleStream(Stream);

if pos('http://',lowercase(copy(stringa,1,7)))=1 then begin  //instead of pls we may have a shoutcast link here
 delete(stringa,pos(chr(10),stringa),length(stringa));
 stringa := trim(stringa);
 shoutcast.OpenRadioUrl(stringa);
exit;
end;

if pos('#EXTM3U',stringa)<>1 then exit; //wrong format
delete(stringa,1,pos('#EXTINF',stringa)-1);


 while length(stringa)>0 do begin

 if pos('#EXTINF:',stringa)=1 then begin //ricaviamo tempo?
  delete(stringa,1,8);
  strtempo := copy(stringa,1,pos(',',stringa)-1);
  tempoi := strtointdef(strtempo,-1);
  delete(stringa,1,pos(',',stringa));
 strdisplay := copy(stringa,1,pos(CRLF,stringa)-1);
    delete(stringa,1,pos(CRLF,stringa)+1); //skip return
     filename := copy(stringa,1,pos(CRLF,stringa)-1);
    delete(stringa,1,pos(CRLF,stringa)+1); //skip filename
   if lowercase(copy(filename,1,7))='http://' then begin
    shoutcast.OpenRadioUrl(filename);
    exit;
   end;
   if pos(':\',filename)<>2 then filename := copy(data_path,1,2)+filename;
   playlist_addfile(filename,tempoi,silent,strdisplay);

 end else break;


end;

except
end;
end;

procedure playlist_addfile(filename: string; duration: Integer; silent: Boolean; strdisplay: string);

    function ricava_duration_da_file_video_o_audio(nome: WideString; mp3: TMPEGAudio): Integer;
     begin
     Result := 0;

     if mp3<>nil then
      if mp3.Valid then begin
       Result := trunc(mp3.Duration); //correct length
       exit;
      end;

      try

      with ares_frmmain do begin
       if filtro2=nil then filtro2 := TFilterGraph.create(ares_frmmain);
       with filtro2 do begin
        try
        active := False;
        active := True;
        RenderFile(nome);
        Result := (Duration div 1000);
        except
        end;
       active := False;
      end;
     end;

      except
      //dspack error?
      end;
    end;


var
estensione: string;
nodo:pCmtVnode;
data:ares_types.precord_file_playlist;
crcfilename: Word;
title,artist: string;
mp3: TMPEGAudio;
begin
try
estensione := lowercase(extractfileext(filename));
        if ((pos(estensione,PLAYABLE_AUDIO_EXT)=0) and
            (pos(estensione,PLAYABLE_VIDEO_EXT)=0)) then exit;


if not fileexistsW(utf8strtowidestr(filename)) then exit;

if ((not playlist_visible) and (not silent)) then begin
 helper_bighints.formhint_hide;
 toggle_playlist;
end;

 if estensione='.mp3' then begin
  mp3 := TMPEGAudio.create;
  mp3.ReadFromFile(utf8strtowidestr(filename));
 end else mp3 := nil;

 if duration=-1 then duration := ricava_duration_da_file_video_o_audio(utf8strtowidestr(filename),mp3);


 crcfilename := stringcrc(filename,true);

 nodo := ares_frmmain.listview_playlist.getfirst;
 while (nodo<>nil) do begin
  data := ares_frmmain.listview_playlist.getdata(nodo);
  if crcfilename=data^.crcfilename then
   if data^.filename=filename then begin
    if mp3<>nil then mp3.Free;
    exit; //ho gia
   end;
  nodo := ares_frmmain.listview_playlist.getnext(nodo);
 end;


nodo := ares_frmmain.listview_playlist.addchild(nil);
data := ares_frmmain.listview_playlist.getdata(nodo);

 data^.amime := extstr_to_mediatype(estensione);
 data^.filename := filename;
 data^.crcfilename := stringcrc(data^.filename,true);
 data^.length := duration;
 
 if length(strdisplay)=0 then begin

    if mp3<>nil then begin

          if mp3.Valid then begin
            if mp3.ID3v2.Exists then begin
             title := mp3.id3v2.title;
             artist := mp3.id3v2.artist;
            end;
            if mp3.ID3v1.Exists then begin
             if length(title)=0 then title := mp3.id3v1.title;
             if length(artist)=0 then artist := mp3.id3v1.artist;
            end;
          end;

    end;

    if (length(title)>0) and (length(artist)>0) then data^.displayName := artist+' - '+title
     else data^.displayName := widestrtoutf8str(get_player_displayname(utf8strtowidestr(filename),estensione));

 end else data^.displayName := strdisplay;


 if ((not silent) and (playlist_visible)) then ares_frmmain.listview_playlist.invalidatenode(nodo);


 if mp3<>nil then mp3.Free;

except
end;
end;

procedure playlist_addfolder(folder: WideString);
var
doserror: Integer;
dirinfo:ares_types.tsearchrecW;
estensione,nameutf8: string;
list: TMyStringList;
begin


list := tmyStringList.create;
list.add(widestrtoutf8str(folder));

 get_subdirs(list,folder);

 while (list.count>0) do begin

   doserror := helper_diskio.findfirstW(utf8strtowidestr(list.strings[0])+'\'+const_ares.STR_ANYFILE_DISKPATTERN,faanyfile,dirinfo);
   while doserror=0 do begin

     if ((dirinfo.name='.') or
         (dirinfo.name='..') or
         ((dirinfo.attr and FADIRECTORY)>0)) then begin
           doserror := helper_diskio.findnextW(dirinfo);
           continue;
     end;

        nameutf8 := widestrtoutf8str(dirinfo.name);
        estensione := lowercase(extractfileext(nameutf8));
        if ((pos(estensione,PLAYABLE_AUDIO_EXT)=0) and
            (pos(estensione,PLAYABLE_VIDEO_EXT)=0)) then begin
            doserror := helper_diskio.findnextW(dirinfo);
            continue;
       end;


     playlist_addfile(list.strings[0]+'\'+nameutf8,-1,false,'');

doserror := helper_diskio.findnextW(dirinfo);
end;

helper_diskio.findcloseW(dirinfo);

list.delete(0);
end;

list.Free;

end;


end.
