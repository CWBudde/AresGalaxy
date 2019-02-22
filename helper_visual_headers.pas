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
GUI code to allow fast visualization of fields in treeviews
}

unit helper_visual_headers;

interface

uses ares_types,comettrees,helper_unicode,vars_localiz,registry,const_ares,sysutils,
classes,windows;

 const
  search_header_inprog: Tstato_search_header  =(COLUMN_NULL, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,       COLUMN_NULL,     COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_INPROGRESS);
  search_header_browse: Tstato_search_header  =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_TYPE,     COLUMN_SIZE,       COLUMN_FILENAME, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL);
  search_header_all: Tstato_search_header     =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_TYPE,     COLUMN_SIZE,     COLUMN_STATUS,     COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL);
  search_header_audio: Tstato_search_header   =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_ALBUM,    COLUMN_CATEGORY, COLUMN_QUALITY,    COLUMN_LENGTH,   COLUMN_SIZE,   COLUMN_STATUS,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  search_header_video: Tstato_search_header   =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_LANGUAGE, COLUMN_LENGTH,     COLUMN_RESOLUTION,COLUMN_SIZE,  COLUMN_STATUS,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  search_header_image: Tstato_search_header   =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_ALBUM,    COLUMN_CATEGORY, COLUMN_RESOLUTION, COLUMN_COLORS,   COLUMN_SIZE,   COLUMN_STATUS,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  search_header_document: Tstato_search_header=(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_LANGUAGE, COLUMN_DATE,       COLUMN_SIZE,     COLUMN_STATUS, COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL);
  search_header_software: Tstato_search_header=(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_DATE,     COLUMN_VERSION,    COLUMN_LANGUAGE, COLUMN_SIZE,   COLUMN_STATUS,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  search_header_other: Tstato_search_header   =(COLUMN_TITLE,COLUMN_FILETYPE,COLUMN_SIZE,    COLUMN_STATUS,   COLUMN_USER,       COLUMN_FILENAME, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL);

  chat_search_header_inprog: Tstato_header_chat   =(COLUMN_NULL, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,       COLUMN_NULL,     COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_INPROGRESS);
  chat_search_header_all: Tstato_header_chat      =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_TYPE,     COLUMN_SIZE,     COLUMN_USER,       COLUMN_FILENAME, COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL);
  chat_search_header_audio: Tstato_header_chat    =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_ALBUM,    COLUMN_CATEGORY, COLUMN_QUALITY,    COLUMN_LENGTH,   COLUMN_SIZE,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  chat_search_header_video: Tstato_header_chat    =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_LANGUAGE, COLUMN_LENGTH,     COLUMN_RESOLUTION,COLUMN_SIZE,  COLUMN_USER,     COLUMN_FORMAT,   COLUMN_FILENAME);
  chat_search_header_image: Tstato_header_chat    =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_ALBUM,    COLUMN_CATEGORY, COLUMN_RESOLUTION, COLUMN_COLORS,   COLUMN_SIZE,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  chat_search_header_document: Tstato_header_chat =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_LANGUAGE, COLUMN_DATE,       COLUMN_SIZE,     COLUMN_USER,   COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL);
  chat_search_header_software: Tstato_header_chat =(COLUMN_TITLE,COLUMN_ARTIST, COLUMN_CATEGORY, COLUMN_DATE,     COLUMN_VERSION,    COLUMN_LANGUAGE, COLUMN_SIZE,   COLUMN_USER,     COLUMN_FILENAME, COLUMN_NULL);
  chat_search_header_other: Tstato_header_chat    =(COLUMN_TITLE,COLUMN_FILETYPE,COLUMN_SIZE,    COLUMN_USER,     COLUMN_FILENAME,   COLUMN_NULL,     COLUMN_NULL,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL);

  library_header_browse_in_prog: Tstato_library_header         = (COLUMN_NULL,         COLUMN_NULL,     COLUMN_NULL,      COLUMN_NULL,       COLUMN_NULL,       COLUMN_NULL,       COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_TITLE);

  library_header_your_library: Tstato_library_header           = (COLUMN_YOUR_LIBRARY, COLUMN_NULL,     COLUMN_NULL,      COLUMN_NULL,       COLUMN_NULL,       COLUMN_NULL,       COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
  library_header_all: Tstato_library_header                    = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_MEDIATYPE, COLUMN_CATEGORY,   COLUMN_SIZE,       COLUMN_FILENAME,   COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);

   library_header_audio_gnull: Tstato_library_header           = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_ALBUM,     COLUMN_CATEGORY,   COLUMN_LENGTH,     COLUMN_QUALITY,    COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);
    library_header_audio_gbyartist: Tstato_library_header      = (COLUMN_TITLE,        COLUMN_NULL,     COLUMN_ALBUM,     COLUMN_CATEGORY,   COLUMN_LENGTH,     COLUMN_QUALITY,    COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);
    library_header_audio_gbyalbum: Tstato_library_header       = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_NULL,      COLUMN_CATEGORY,   COLUMN_LENGTH,     COLUMN_QUALITY,    COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);
    library_header_audio_gbygenre: Tstato_library_header       = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_ALBUM,     COLUMN_NULL,       COLUMN_LENGTH,     COLUMN_QUALITY,    COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);

   library_header_document_gnull: Tstato_library_header        = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_CATEGORY,  COLUMN_LANGUAGE,   COLUMN_DATE,       COLUMN_SIZE,       COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
    library_header_document_gbyauthor: Tstato_library_header   = (COLUMN_TITLE,        COLUMN_NULL,     COLUMN_CATEGORY,  COLUMN_LANGUAGE,   COLUMN_DATE,       COLUMN_SIZE,       COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
    library_header_document_gbycategory: Tstato_library_header = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_NULL,      COLUMN_LANGUAGE,   COLUMN_DATE,       COLUMN_SIZE,       COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);

   library_header_image_gnull: Tstato_library_header           = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_ALBUM,     COLUMN_CATEGORY,   COLUMN_DATE,       COLUMN_RESOLUTION, COLUMN_COLORS,   COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);
    library_header_image_gbyalbum: Tstato_library_header       = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_NULL,      COLUMN_CATEGORY,   COLUMN_DATE,       COLUMN_RESOLUTION, COLUMN_COLORS,   COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);
    library_header_image_gbycategory: Tstato_library_header    = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_ALBUM,     COLUMN_NULL,       COLUMN_DATE,       COLUMN_RESOLUTION, COLUMN_COLORS,   COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,    COLUMN_NULL);

   library_header_other: Tstato_library_header                 = (COLUMN_TITLE,        COLUMN_FILETYPE, COLUMN_SIZE,      COLUMN_FILENAME,   COLUMN_NULL,       COLUMN_NULL,       COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
   library_header_recent: Tstato_library_header                = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_MEDIATYPE, COLUMN_CATEGORY,   COLUMN_SIZE,       COLUMN_FILEDATE,   COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);

   library_header_software_gnull: Tstato_library_header        = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_CATEGORY,  COLUMN_DATE,       COLUMN_LANGUAGE,   COLUMN_VERSION,    COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
    library_header_software_gbycompany: Tstato_library_header  = (COLUMN_TITLE,        COLUMN_NULL,     COLUMN_CATEGORY,  COLUMN_DATE,       COLUMN_LANGUAGE,   COLUMN_VERSION,    COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);
    library_header_software_gbycategory: Tstato_library_header = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_NULL,      COLUMN_DATE,       COLUMN_LANGUAGE,   COLUMN_VERSION,    COLUMN_SIZE,     COLUMN_FILENAME, COLUMN_NULL,     COLUMN_NULL,    COLUMN_NULL);

   library_header_video_gnull: Tstato_library_header           = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_CATEGORY,  COLUMN_LENGTH,     COLUMN_RESOLUTION, COLUMN_LANGUAGE,   COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FORMAT,   COLUMN_FILENAME, COLUMN_NULL);
    library_header_video_gbycategory: Tstato_library_header    = (COLUMN_TITLE,        COLUMN_ARTIST,   COLUMN_NULL,      COLUMN_LENGTH,     COLUMN_RESOLUTION, COLUMN_LANGUAGE,   COLUMN_DATE,     COLUMN_SIZE,     COLUMN_FORMAT,   COLUMN_FILENAME, COLUMN_NULL);

CAT_YOUR_LIBRARY=0;
CAT_ALL=1;
CAT_AUDIO=2;
CAT_VIDEO=3;
CAT_IMAGE=4;
CAT_DOCUMENT=5;
CAT_SOFTWARE=6;
CAT_OTHER=7;
CAT_RECENT=8;

CAT_GROUPBY_ARTIST=0;
CAT_GROUPBY_ALBUM   =1;
CAT_GROUPBY_GENRE  =2;
CAT_GROUPBY_CATEGORY=3;
CAT_GROUPBY_COMPANY=4;
CAT_GROUPBY_AUTHOR=5;
CAT_NOGROUP=6;

function header_library_show(regname1,regname2: string; tree: Tcomettree; str_general: string; categoria: Byte; esclusione: Byte): Tstato_library_header;
procedure header_library_load(regname1,regname2: string; tree: Tcomettree; categoria: Byte; esclusione: Byte);
procedure header_search_load(listview: Tcomettree);
procedure header_search_show(src:precord_panel_search);
procedure header_download_load;
procedure header_upload_load;

procedure header_download_save;
procedure header_upload_save;
procedure header_library_save(regname1,regname2: string; tree: Tcomettree);
procedure header_search_save;


var
stato_header_library: Tstato_library_header;


implementation

uses
ufrmmain,vars_global;


procedure header_upload_save;
var
reg: Tregistry;
stringa: string;
i: Integer;
begin
reg := tregistry.create;
try

with reg do begin
 openkey(areskey+'Columns\Transfers\',true);
  with ares_frmmain.treeview_upload.Header.columns do
   stringa := inttostr(Items[0].width)+','+
            inttostr(Items[1].width)+','+
            inttostr(Items[2].width)+','+
            inttostr(Items[3].width)+','+
            inttostr(Items[4].width)+','+
            inttostr(Items[5].width)+','+
            inttostr(Items[6].width)+','+
            inttostr(Items[7].width)+',';
 writestring('Upload',stringa);

 with ares_frmmain.treeview_queue.Header.columns do
   stringa := inttostr(Items[0].width)+','+
            inttostr(Items[1].width)+','+
            inttostr(Items[2].width)+',';
 writestring('Queue',stringa);
 closekey;

//ora salva posizioni!
 stringa := '';
 openkey(areskey+'Positions\Transfers',true);
 for i := 0 to 7 do stringa := stringa+inttostr(ares_frmmain.treeview_upload.Header.Columns.Items[i].position)+',';
 writestring('Upload',stringa);

 stringa := '';
 for i := 0 to 2 do stringa := stringa+inttostr(ares_frmmain.treeview_queue.Header.Columns.Items[i].position)+',';
 writestring('Queue',stringa);
 closekey;
end;

except
end;
reg.destroy;
end;

procedure header_download_save;
var
reg: Tregistry;
stringa: string;
i: Integer;
begin
reg := tregistry.create;
with reg do begin
 try
 openkey(areskey+'Columns\Transfers\',true);
 with ares_frmmain.treeview_download.header.columns do
  stringa := inttostr(Items[0].width)+','+
          inttostr(Items[1].width)+','+
          inttostr(Items[2].width)+','+
          inttostr(Items[3].width)+','+
          inttostr(Items[4].width)+','+
          inttostr(Items[5].width)+','+
          inttostr(Items[6].width)+','+
          inttostr(Items[7].width)+',';
  writestring('Download',stringa);
  closekey;

  openkey(areskey+'Positions\Transfers',true);
  stringa := '';
  for i := 0 to 7 do stringa := stringa+inttostr(ares_frmmain.treeview_download.Header.Columns.Items[i].position)+',';
   writestring('Download',stringa);
   closekey;
 except
 end;
 destroy;
end;

end;


procedure header_upload_load;
var
reg: Tregistry;
stringa: string;
elemento,i: Integer;
begin
reg := tregistry.create;
with reg do begin
try
 openkey(areskey+'Columns\Transfers',true);
 stringa := readstring('Upload');
if stringa='' then stringa := '300,60,110,80,90,80,90,130,';
  for i := 0 to 7 do begin
   elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),70);
   stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
    if ares_frmmain.treeview_upload.Header.Columns.Items[i].text<>'' then begin
     if elemento<10 then elemento := 10;
     ares_frmmain.treeview_upload.Header.Columns.Items[i].width := elemento;
    end else ares_frmmain.treeview_upload.Header.Columns.Items[i].width := 0;
   end;

 stringa := readstring('Queue');
 if stringa='' then stringa := '150,290,100,';
 for i := 0 to 2 do begin
  elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),70);
  stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
   if ares_frmmain.treeview_queue.Header.Columns.Items[i].text<>'' then begin
    if elemento<30 then elemento := 30;
    ares_frmmain.treeview_queue.Header.Columns.Items[i].width := elemento;
   end else ares_frmmain.treeview_queue.Header.Columns.Items[i].width := 0;
 end;
 closekey;


//ora prendi posizioni!
 openkey(areskey+'Positions\Transfers',true);
 stringa := reg.readstring('Upload');
 if stringa='' then stringa := '0,1,2,3,4,5,6,7,';
  for i := 0 to 7 do begin
   elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),-1);
   if elemento=-1 then break;
   stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
   ares_frmmain.treeview_upload.Header.Columns.Items[i].position := elemento;
  end;

//ora prendi posizioni queue!
 stringa := readstring('Queue');
 if stringa='' then stringa := '0,1,2,';
 for i := 0 to 2 do begin
  elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),-1);
  if elemento=-1 then break;
  stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
  ares_frmmain.treeview_queue.Header.Columns.Items[i].position := elemento;
 end;
closekey;

except
end;
destroy;
end;

end;

procedure header_download_load;
var
reg: Tregistry;
stringa: string;
elemento,i: Integer;
begin
reg := tregistry.create;
with reg do begin
 try
 openkey(areskey+'Columns\Transfers',true);
 stringa := readstring('Download');
 if stringa='' then stringa := '300,60,110,80,90,80,90,130,';
 for i := 0 to 7 do begin
  elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),70);
  stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
   if ares_frmmain.treeview_download.Header.Columns.Items[i].text<>'' then begin
    if elemento<30 then elemento := 30;
    ares_frmmain.treeview_download.Header.Columns.Items[i].width := elemento;
   end else ares_frmmain.treeview_download.Header.Columns.Items[i].width := 0;
 end;
 closekey;

//ora prendi posizioni!
 openkey(areskey+'Positions\Transfers',true);
 stringa := readstring('Download');
 if stringa='' then stringa := '0,1,2,3,4,5,6,7,';
  for i := 0 to 7 do begin
   elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),-1);
   if elemento=-1 then break;
   stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
   ares_frmmain.treeview_download.Header.Columns.Items[i].position := elemento;
  end;
 closekey;

except
end;
destroy;
end;

end;


procedure header_search_save; //save column positions of the last search
var
reg: Tregistry;
last_seen: string;
stringa: string;
i: Integer;
src:precord_panel_search;
begin
if vars_global.src_panel_list.count=0 then exit;

reg := tregistry.create;
with reg do begin
try
 openkey(areskey,true);
 last_seen := readstring('GUI.LastSearch');

 if last_seen='' then begin
  closekey;
  destroy;
  exit;
 end;

 closekey;
 openkey(areskey+'Columns\Search\',true);

src := src_panel_list[src_panel_list.count-1];
with src^.listview.header.columns do
 stringa := inttostr(Items[0].width)+','+
          inttostr(Items[1].width)+','+
          inttostr(Items[2].width)+','+
          inttostr(Items[3].width)+','+
          inttostr(Items[4].width)+','+
          inttostr(Items[5].width)+','+
          inttostr(Items[6].width)+','+
          inttostr(Items[7].width)+','+
          inttostr(Items[8].width)+','+
          inttostr(Items[9].width)+',';

 writestring(last_seen,stringa);
 closekey;

//ora salva posizioni!
 openkey(areskey+'Positions\Search',true);
stringa := '';
for i := 0 to 9 do stringa := stringa+inttostr(src^.listview.Header.Columns.Items[i].position)+',';
 writestring(last_seen,stringa);

 closekey;
 except
 end;
 destroy;
end;

end;

procedure header_search_load(listview: Tcomettree);
var
reg: Tregistry;
stringa: string;
elemento,i: Integer;categoria: string;
begin
with ares_frmmain do begin
 if radio_srcmime_all.checked then categoria := 'all' else
 if radio_srcmime_audio.checked then categoria := 'aud' else
 if radio_srcmime_video.checked then categoria := 'vid' else
 if radio_srcmime_image.checked then categoria := 'ima' else
 if radio_srcmime_document.checked then categoria := 'doc' else
 if radio_srcmime_software.checked then categoria := 'sof' else
  categoria := 'oth';
end;


reg := tregistry.create;
with reg do begin
 try
 openkey(areskey+'Columns\Search',true);
 stringa := readstring(categoria);
 if stringa='' then stringa := '0,0,0,0,0,0,0,0,0,0';
 for i := 0 to 9 do begin
 elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),70);
 stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
 if listview.Header.Columns.Items[i].text<>'' then begin
 if elemento<30 then elemento := 30;
  listview.Header.Columns.Items[i].width := elemento;
 end else begin
  listview.Header.Columns.Items[i].width := 0;
 end;
 end;
 closekey;

//ora prendi posizioni!
 openkey(areskey+'Positions\Search',true);
 stringa := readstring(categoria);
 if stringa='' then stringa := '0,1,2,3,4,5,6,7,8,9,';
 for i := 0 to 9 do begin
 elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),-1);
 if elemento=-1 then break;
 stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
 listview.Header.Columns.Items[i].position := elemento;
 end;
 closekey;

 openkey(areskey,true);
 writestring('GUI.LastSearch',categoria);
 closekey;
except
end;
 destroy;
end;
end;

procedure header_search_show(src:precord_panel_search);
var
i: Integer;
begin
with src^.listview do begin

header_search_save;

Clear;
selectable := True;
header.options := [hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];

header.AutoSizeIndex := -1;
for i := 0 to 10 do header.columns.items[i].MaxWidth := 2000; //begin


 if ares_frmmain.radio_srcmime_all.checked then begin   //all
   src^.stato_header := search_header_all;
   with header.columns do begin
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 170;
    Items[1].text := GetLangStringW(STR_AUTHOR);
     items[1].Alignment := taLeftJustify;
     Items[1].MinWidth := 100;
    Items[2].text := GetLangStringW(STR_TYPE);
     items[2].Alignment := taCenter;
     Items[2].MinWidth := 60;
    Items[3].text := GetLangStringW(STR_SIZE);
     items[3].Alignment := taRightJustify;
     Items[3].MinWidth := 75;
    Items[4].text := GetLangStringW(STR_STATUS);
     items[4].Alignment := taLeftJustify;
     Items[4].MinWidth := 55;
     Items[4].MaxWidth := 55;
    Items[5].text := GetLangStringW(STR_USER);
     items[5].Alignment := taLeftJustify;
     Items[5].MinWidth := 120;
    Items[6].text := GetLangStringW(STR_FILENAME);
     items[6].Alignment := taLeftJustify;
     Items[6].MinWidth := 400;
    Items[7].text := '';
     Items[7].MinWidth := 0;
     items[7].MaxWidth := 0;
     Items[7].width := 10;
    Items[8].text := '';
     Items[8].MinWidth := 0;
     items[8].MaxWidth := 0;
     Items[8].width := 0;
    Items[9].text := '';
     Items[9].MinWidth := 0;
     items[9].MaxWidth := 0;
     Items[9].width := 0;
    Items[10].text := '';
     Items[10].MinWidth := 0;
     items[10].MaxWidth := 0;
     Items[10].width := 0;
     header.AutoSizeIndex := -1;
   end;
 end else
 if ares_frmmain.radio_srcmime_audio.checked then begin    //audio
    src^.stato_header := search_header_audio;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 170;
     Items[1].text := GetLangStringW(STR_ARTIST);
      items[1].Alignment := taLeftJustify;
      Items[1].MinWidth := 100;
     Items[2].text := GetLangStringW(STR_ALBUM);
      items[2].Alignment := taLeftJustify;
      Items[2].MinWidth := 100;
     Items[3].text := GetLangStringW(STR_GENRE);
      items[3].Alignment := taLeftJustify;
      Items[3].MinWidth := 60;
     Items[4].text := GetLangStringW(STR_QUALITY);
      items[4].Alignment := taCenter;
      Items[4].MinWidth := 50;
     Items[5].text := GetLangStringW(STR_LENGTH);
      items[5].Alignment := taRightJustify;
      Items[5].MinWidth := 55;
     Items[6].text := GetLangStringW(STR_SIZE);
      items[6].Alignment := taRightJustify;
      Items[6].MinWidth := 75;
     Items[7].text := GetLangStringW(STR_STATUS);
      items[7].Alignment := taLeftJustify;
      Items[7].MinWidth := 55;
      Items[7].MaxWidth := 55;
     Items[8].text := GetLangStringW(STR_USER);
      items[8].Alignment := taLeftJustify;
      Items[8].MinWidth := 120;
     Items[9].text := GetLangStringW(STR_FILENAME);
      items[9].Alignment := taLeftJustify;
      Items[9].MinWidth := 400;
     Items[10].text := '';
      items[10].MinWidth := 0;
      Items[10].width := 10;
      header.AutoSizeIndex := -1; //10;
    end;
 end else
 if ares_frmmain.radio_srcmime_video.checked then begin  // video
    src^.stato_header := search_header_video;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 200;
     Items[1].text := GetLangStringW(STR_AUTHOR);
      items[1].Alignment := taLeftJustify;
      Items[1].MinWidth := 90;
     Items[2].text := GetLangStringW(STR_CATEGORY);
      items[2].Alignment := taLeftJustify;
      Items[2].MinWidth := 60;
     Items[3].text := GetLangStringW(STR_LANGUAGE);
      items[3].Alignment := taLeftJustify;
      Items[3].MinWidth := 60;
     Items[4].text := GetLangStringW(STR_LENGTH);
      items[4].Alignment := taRightJustify;
      Items[4].MinWidth := 55;
     Items[5].text := GetLangStringW(STR_RESOLUTION);
      items[5].Alignment := taCenter;
      Items[5].MinWidth := 70;
     Items[6].text := GetLangStringW(STR_SIZE);
      items[6].Alignment := taRightJustify;
      Items[6].MinWidth := 75;
     Items[7].text := GetLangStringW(STR_STATUS);
      items[7].Alignment := taLeftJustify;
      Items[7].MinWidth := 55;
      items[7].MaxWidth := 55;
     Items[8].text := GetLangStringW(STR_USER);
      items[8].Alignment := taLeftJustify;
      Items[8].MinWidth := 120;
     Items[9].text := GetLangStringW(STR_FILENAME);
      items[9].Alignment := taLeftJustify;
      Items[9].MinWidth := 400;
     Items[10].text := '';
      Items[10].MinWidth := 0;
      Items[10].width := 10;
     header.AutoSizeIndex := -1; //10;
    end;
 end else
 if ares_frmmain.radio_srcmime_image.checked then begin // images
    src^.stato_header := search_header_image;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 200;
     Items[1].text := GetLangStringW(STR_ARTIST);
      items[1].Alignment := taLeftJustify;
      Items[1].MinWidth := 60;
     Items[2].text := GetLangStringW(STR_ALBUM);
      items[2].Alignment := taLeftJustify;
      Items[2].MinWidth := 60;
     Items[3].text := GetLangStringW(STR_CATEGORY);
      items[3].Alignment := taLeftJustify;
      Items[3].MinWidth := 60;
     Items[4].text := GetLangStringW(STR_RESOLUTION);
      items[4].Alignment := taCenter;
      Items[4].MinWidth := 90;
     Items[5].text := GetLangStringW(STR_COLOURS);
      items[5].Alignment := taCenter;
      Items[5].MinWidth := 60;
     Items[6].text := GetLangStringW(STR_SIZE);
      items[6].Alignment := taRightJustify;
      Items[6].MinWidth := 75;
     Items[7].text := GetLangStringW(STR_STATUS);
      items[7].Alignment := taLeftJustify;
      Items[7].MinWidth := 55;
      Items[7].MaxWidth := 55;
     Items[8].text := GetLangStringW(STR_USER);
      items[8].Alignment := taLeftJustify;
      Items[8].MinWidth := 120;
     Items[9].text := GetLangStringW(STR_FILENAME);
      items[9].Alignment := taLeftJustify;
      Items[9].MinWidth := 400;
     Items[10].text := '';
      Items[10].MinWidth := 0;
      Items[10].width := 10;
      header.AutoSizeIndex := -1; //10;
    end;
 end else
 if ares_frmmain.radio_srcmime_document.checked then begin  //documents
    src^.stato_header := search_header_document;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 170;
     Items[1].text := GetLangStringW(STR_AUTHOR);
      items[1].Alignment := taLeftJustify;
      Items[1].MinWidth := 110;
     Items[2].text := GetLangStringW(STR_CATEGORY);
      items[2].Alignment := taLeftJustify;
      Items[2].MinWidth := 110;
     Items[3].text := GetLangStringW(STR_LANGUAGE);
      items[3].Alignment := taLeftJustify;
      Items[3].MinWidth := 60;
     Items[4].text := GetLangStringW(STR_DATE_COLUMN);
      items[4].Alignment := taCenter;
      Items[4].MinWidth := 90;
     Items[5].text := GetLangStringW(STR_SIZE);
      items[5].Alignment := taRightJustify;
      Items[5].MinWidth := 75;
     Items[6].text := GetLangStringW(STR_STATUS);
      items[6].Alignment := taLeftJustify;
      Items[6].MinWidth := 55;
      Items[6].MaxWidth := 55;
     Items[7].text := GetLangStringW(STR_USER);
      items[7].Alignment := taLeftJustify;
      Items[7].MinWidth := 120;
     Items[8].text := GetLangStringW(STR_FILENAME);
      items[8].Alignment := taLeftJustify;
      Items[8].MinWidth := 400;
     Items[9].text := '';
      Items[9].MinWidth := 0;
      Items[9].width := 10;
     Items[10].text := '';
      Items[10].MinWidth := 0;
      Items[10].width := 0;
      header.AutoSizeIndex := -1; //9;
    end;
 end else
 if ares_frmmain.radio_srcmime_software.checked then begin // software
    src^.stato_header := search_header_software;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 200;
     Items[1].text := GetLangStringW(STR_COMPANY);
      items[1].Alignment := taLeftJustify;
      Items[1].MinWidth := 100;
     Items[2].text := GetLangStringW(STR_CATEGORY);
      items[2].Alignment := taLeftJustify;
      Items[2].MinWidth := 70;
     Items[3].text := GetLangStringW(STR_DATE_COLUMN);
      items[3].Alignment := taCenter;
      Items[3].MinWidth := 70;
     Items[4].text := GetLangStringW(STR_VERSION);
      items[4].Alignment := taLeftJustify;
      Items[4].MinWidth := 75;
     Items[5].text := GetLangStringW(STR_LANGUAGE);
      items[5].Alignment := taLeftJustify;
      Items[5].MinWidth := 60;
     Items[6].text := GetLangStringW(STR_SIZE);
      items[6].Alignment := taRightJustify;
      Items[6].MinWidth := 75;
     Items[7].text := GetLangStringW(STR_STATUS);
      items[7].Alignment := taLeftJustify;
      Items[7].MinWidth := 55;
      Items[7].MaxWidth := 55;
     Items[8].text := GetLangStringW(STR_USER);
      items[8].Alignment := taLeftJustify;
      Items[8].MinWidth := 120;
     Items[9].text := GetLangStringW(STR_FILENAME);
      items[9].Alignment := taLeftJustify;
      Items[9].MinWidth := 400;
     Items[10].text := '';
      Items[10].MinWidth := 0;
      Items[10].width := 10;
      header.AutoSizeIndex := -1; //10;
    end;
 end else
  if ares_frmmain.radio_srcmime_other.checked then begin // software
    src^.stato_header := search_header_other;
    with header.columns do begin
     Items[0].text := GetLangStringW(STR_TITLE);
      items[0].Alignment := taLeftJustify;
      Items[0].MinWidth := 250;
     Items[1].text := GetLangStringW(STR_FILETYPE);
      items[1].Alignment := taCenter;
      Items[1].MinWidth := 50;
     Items[2].text := GetLangStringW(STR_SIZE);
      items[2].Alignment := taRightJustify;
      Items[2].MinWidth := 75;
     Items[3].text := GetLangStringW(STR_STATUS);
      items[3].Alignment := taLeftJustify;
      Items[3].MinWidth := 55;
      Items[3].MaxWidth := 55;
     Items[4].text := GetLangStringW(STR_USER);
      items[4].Alignment := taLeftJustify;
      Items[4].MinWidth := 120;
     Items[5].text := GetLangStringW(STR_FILENAME);
      items[5].Alignment := taLeftJustify;
      Items[5].MinWidth := 400;
     Items[6].text := '';
      Items[6].MinWidth := 0;
      Items[6].width := 10;
     Items[7].text := '';
      Items[7].MinWidth := 0;
      Items[7].width := 0;
     Items[8].text := '';
      Items[8].MinWidth := 0;
      Items[8].width := 0;
     Items[9].text := '';
      Items[9].MinWidth := 0;
      Items[9].width := 0;
     Items[10].text := '';
      Items[10].MinWidth := 0;
      Items[10].width := 0;
      header.AutoSizeIndex := -1; //6;
    end;
 end;


 if Header.sortcolumn=-1 then begin //restore ascending descending
  with header do
   for i := 0 to 10 do if widestrtoutf8str(columns.Items[i].text)=GetLangStringA(STR_STATUS) then begin
    sortcolumn := i;
    sortdirection := sddescending;
    break;
   end;
 end;

with header.columns do
  for i := 0 to 10 do begin
   Items[i].imageindex := 1000;
   if Items[i].text='' then begin
    Items[i].Options := [coEnabled,coParentBidiMode,coParentColor,coVisible];
    Items[i].MinWidth := 0;
    Items[i].width := 0;
   end else Items[i].Options := [coAllowClick,coDraggable,coEnabled,coParentBidiMode,coParentColor,coResizable,coShowDropMark,coVisible];
end;

end;


header_search_load(src^.listview);


end;

function header_library_show(regname1,regname2: string; tree: Tcomettree; str_general: string; categoria: Byte; esclusione: Byte): Tstato_library_header;
var
i: Integer;
begin

header_library_save(regname1,regname2,tree);

tree.header.AutoSizeIndex := -1;
for i := 0 to 9 do tree.Header.Columns.Items[i].MinWidth := 0;
//tree.header.AutoSizeIndex := 9;

 with tree.header.columns do begin

if categoria=CAT_YOUR_LIBRARY then begin
result := library_header_your_library;
    Items[0].text := utf8strtowidestr(str_general);
    items[0].Alignment := taLeftJustify;
    Items[1].text := '';
     Items[1].MinWidth := 0;
    Items[2].text := '';
     Items[2].MinWidth := 0;
    Items[3].text := '';
     Items[3].MinWidth := 0;
    Items[4].text := '';
     Items[4].MinWidth := 0;
    Items[5].text := '';
     Items[5].MinWidth := 0;
    Items[6].text := '';
     Items[6].MinWidth := 0;
    Items[7].text := '';
     Items[7].MinWidth := 0;
    Items[8].text := '';
     Items[8].MinWidth := 0;
    Items[9].text := '';
     Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 0;
end else
if categoria=CAT_ALL then begin
result := library_header_all;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 200;
    Items[1].text := GetLangStringW(STR_ARTIST);
     items[1].Alignment := taLeftJustify;
     Items[1].MinWidth := 100;
    Items[2].text := GetLangStringW(STR_MEDIATYPE);
     items[2].Alignment := taCenter;
     Items[2].MinWidth := 60;
    Items[3].text := GetLangStringW(STR_CATEGORY);
     items[3].Alignment := taLeftJustify;
     Items[3].MinWidth := 60;
    Items[4].text := GetLangStringW(STR_SIZE);
     items[4].Alignment := taRightJustify;
     Items[4].MinWidth := 75;
    Items[5].text := GetLangStringW(STR_FILENAME);
     items[5].Alignment := taLeftJustify;
     Items[5].MinWidth := 150;
    Items[6].text := '';
    Items[6].MinWidth := 0;
    Items[7].text := '';
    Items[7].MinWidth := 0;
    Items[8].text := '';
    Items[8].MinWidth := 0;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 5;
end else
if categoria=CAT_RECENT then begin
result := library_header_recent;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 150;
    Items[1].text := GetLangStringW(STR_ARTIST);
     items[1].Alignment := taLeftJustify;
     Items[1].MinWidth := 100;
    Items[2].text := GetLangStringW(STR_MEDIATYPE);
     items[2].Alignment := taCenter;
     Items[2].MinWidth := 60;
    Items[3].text := GetLangStringW(STR_CATEGORY);
     items[3].Alignment := taLeftJustify;
     Items[3].MinWidth := 80;
    Items[4].text := GetLangStringW(STR_SIZE);
     items[4].Alignment := taRightJustify;
     Items[4].MinWidth := 75;
    Items[5].text := GetLangStringW(STR_DOWNLOADED_ON);
     items[5].Alignment := taCenter;
     Items[5].MinWidth := 120;
    Items[6].text := GetLangStringW(STR_FILENAME);
     items[6].Alignment := taLeftJustify;
     Items[6].MinWidth := 150;
    Items[7].text := '';
    Items[7].MinWidth := 0;
    Items[8].text := '';
    Items[8].MinWidth := 0;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 6;
end else
if categoria=CAT_AUDIO then begin
 if esclusione=CAT_NOGROUP then Result := library_header_audio_gnull else
  if esclusione=CAT_GROUPBY_ARTIST then Result := library_header_audio_gbyartist else
   if esclusione=CAT_GROUPBY_ALBUM then Result := library_header_audio_gbyalbum else
    if esclusione=CAT_GROUPBY_GENRE then Result := library_header_audio_gbygenre;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 150;
    if esclusione=CAT_GROUPBY_ARTIST then Items[1].text := '' else Items[1].text := GetLangStringW(STR_ARTIST);
    if items[1].text<>'' then Items[1].MinWidth := 100 else items[1].MinWidth := 0;
     items[1].Alignment := taLeftJustify;
    if esclusione=CAT_GROUPBY_ALBUM then Items[2].text := '' else Items[2].text := GetLangStringW(STR_ALBUM);
    if items[2].text<>'' then Items[2].MinWidth := 100 else items[2].MinWidth := 0;
     items[2].Alignment := taLeftJustify;
    if esclusione=CAT_GROUPBY_GENRE then Items[3].text := '' else Items[3].text := GetLangStringW(STR_GENRE);
     if items[3].text<>'' then Items[3].MinWidth := 60 else items[3].MinWidth := 0;
     items[3].Alignment := taLeftJustify;
    Items[4].text := GetLangStringW(STR_LENGTH);
     items[4].Alignment := taRightJustify;
     Items[4].MinWidth := 55;
    Items[5].text := GetLangStringW(STR_QUALITY);
     items[5].Alignment := taCenter;
     Items[5].MinWidth := 50;
    Items[6].text := GetLangStringW(STR_YEAR);
     items[6].Alignment := taCenter;
     Items[6].MinWidth := 40;
    Items[7].text := GetLangStringW(STR_SIZE);
     items[7].Alignment := taRightJustify;
     Items[7].MinWidth := 75;
    Items[8].text := GetLangStringW(STR_FILENAME);
     items[8].Alignment := taLeftJustify;
     Items[8].MinWidth := 150;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 8;
end else
if categoria=CAT_DOCUMENT then begin
 if esclusione=CAT_NOGROUP then Result := library_header_document_gnull else
  if esclusione=CAT_GROUPBY_AUTHOR then Result := library_header_document_gbyauthor else
   if esclusione=CAT_GROUPBY_CATEGORY then Result := library_header_document_gbycategory;
   Items[0].text := GetLangStringW(STR_TITLE);
    items[0].Alignment := taLeftJustify;
    Items[0].MinWidth := 150;
    if esclusione=CAT_GROUPBY_AUTHOR then Items[1].text := '' else Items[1].text := GetLangStringW(STR_AUTHOR);
    if items[1].text<>'' then Items[1].MinWidth := 100 else items[1].MinWidth := 0;
     items[1].Alignment := taLeftJustify;
    if esclusione=CAT_GROUPBY_CATEGORY then Items[2].text := '' else Items[2].text := GetLangStringW(STR_CATEGORY);
    if items[2].text<>'' then Items[2].MinWidth := 100 else items[2].MinWidth := 0;
     items[2].Alignment := taLeftJustify;
    Items[3].text := GetLangStringW(STR_LANGUAGE);
     items[3].Alignment := taLeftJustify;
     Items[3].MinWidth := 70;
    Items[4].text := GetLangStringW(STR_DATE_COLUMN);
     items[4].Alignment := taCenter;
     Items[4].MinWidth := 80;
    Items[5].text := GetLangStringW(STR_SIZE);
     items[5].Alignment := taRightJustify;
     Items[5].MinWidth := 75;
    Items[6].text := GetLangStringW(STR_FILENAME);
     items[6].Alignment := taLeftJustify;
     Items[6].MinWidth := 150;
    Items[7].text := '';
    Items[7].MinWidth := 0;
    Items[8].text := '';
    Items[8].MinWidth := 0;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 6;
end else
if categoria=CAT_IMAGE then begin
 if esclusione=CAT_NOGROUP then Result := library_header_image_gnull else
  if esclusione=CAT_GROUPBY_ALBUM then Result := library_header_image_gbyalbum else
   if esclusione=CAT_GROUPBY_CATEGORY then Result := library_header_image_gbycategory;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 100;
    Items[1].text := GetLangStringW(STR_ARTIST);
     items[1].Alignment := taLeftJustify;
     Items[1].MinWidth := 50;
    if esclusione=CAT_GROUPBY_ALBUM then Items[2].text := '' else Items[2].text := GetLangStringW(STR_ALBUM);
    if items[2].text<>'' then Items[2].MinWidth := 50 else items[2].MinWidth := 0;
     items[2].Alignment := taLeftJustify;
    if esclusione=CAT_GROUPBY_CATEGORY then Items[3].text := '' else Items[3].text := GetLangStringW(STR_CATEGORY);
    if items[3].text<>'' then Items[3].MinWidth := 50 else items[3].MinWidth := 0;
     items[3].Alignment := taLeftJustify;
    Items[4].text := GetLangStringW(STR_DATE_COLUMN);
     items[4].Alignment := taCenter;
     Items[4].MinWidth := 80;
    Items[5].text := GetLangStringW(STR_RESOLUTION);
     items[5].Alignment := taCenter;
     Items[5].MinWidth := 70;
    Items[6].text := GetLangStringW(STR_COLOURS);
     items[6].Alignment := taCenter;
     Items[6].MinWidth := 50;
    Items[7].text := GetLangStringW(STR_SIZE);
     items[7].Alignment := taRightJustify;
     Items[7].MinWidth := 70;
    Items[8].text := GetLangStringW(STR_FILENAME);
     items[8].Alignment := taLeftJustify;
     Items[8].MinWidth := 150;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 8;
end else
if categoria=CAT_OTHER then begin
result := library_header_other;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 150;
    Items[1].text := GetLangStringW(STR_FILETYPE);
     items[1].Alignment := taCenter;
     Items[1].MinWidth := 60;
    Items[2].text := GetLangStringW(STR_SIZE);
     items[2].Alignment := taRightJustify;
     Items[2].MinWidth := 75;
    Items[3].text := GetLangStringW(STR_FILENAME);
     items[3].Alignment := taLeftJustify;
     Items[3].MinWidth := 150;
    Items[4].text := '';
    Items[4].MinWidth := 0;
    Items[5].text := '';
    Items[5].MinWidth := 0;
    Items[6].text := '';
    Items[6].MinWidth := 0;
    Items[7].text := '';
    Items[7].MinWidth := 0;
    Items[8].text := '';
    Items[8].MinWidth := 0;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 3;
end else

if categoria=CAT_SOFTWARE then begin
 if esclusione=CAT_NOGROUP then Result := library_header_software_gnull else
  if esclusione=CAT_GROUPBY_COMPANY then Result := library_header_software_gbycompany else
   if esclusione=CAT_GROUPBY_CATEGORY then Result := library_header_software_gbycategory;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 150;
    if esclusione=CAT_GROUPBY_COMPANY then Items[1].text := '' else Items[1].text := GetLangStringW(STR_COMPANY);
    if items[1].text<>'' then Items[1].MinWidth := 100 else items[1].MinWidth := 0;
     items[1].Alignment := taLeftJustify;
    if esclusione=CAT_GROUPBY_CATEGORY then Items[2].text := '' else Items[2].text := GetLangStringW(STR_CATEGORY);
    if items[2].text<>'' then Items[2].MinWidth := 100 else items[2].MinWidth := 0;
     items[2].Alignment := taLeftJustify;
    Items[3].text := GetLangStringW(STR_DATE_COLUMN);
     items[3].Alignment := taCenter;
     Items[3].MinWidth := 80;
    Items[4].text := GetLangStringW(STR_LANGUAGE);
     items[4].Alignment := taLeftJustify;
     Items[4].MinWidth := 70;
    Items[5].text := GetLangStringW(STR_VERSION);
     items[5].Alignment := taCenter;
     Items[5].MinWidth := 70;
    Items[6].text := GetLangStringW(STR_SIZE);
     items[6].Alignment := taRightJustify;
     Items[6].MinWidth := 75;
    Items[7].text := GetLangStringW(STR_FILENAME);
     items[7].Alignment := taLeftJustify;
    Items[8].text := '';
    Items[8].MinWidth := 0;
    Items[9].text := '';
    Items[9].MinWidth := 0;
     tree.header.AutoSizeIndex := 7;
end else
if categoria=CAT_VIDEO then begin
 if esclusione=CAT_NOGROUP then Result := library_header_video_gnull else
  if esclusione=CAT_GROUPBY_CATEGORY then Result := library_header_video_gbycategory;
    Items[0].text := GetLangStringW(STR_TITLE);
     items[0].Alignment := taLeftJustify;
     Items[0].MinWidth := 150;
    Items[1].text := GetLangStringW(STR_AUTHOR);
     items[1].Alignment := taLeftJustify;
     Items[1].MinWidth := 100;
    if esclusione=CAT_GROUPBY_CATEGORY then Items[2].text := '' else Items[2].text := GetLangStringW(STR_CATEGORY);
    if items[2].text<>'' then Items[2].MinWidth := 100 else items[2].MinWidth := 0;
     items[2].Alignment := taLeftJustify;
    Items[3].text := GetLangStringW(STR_LENGTH);
     items[3].Alignment := taRightJustify;
     Items[3].MinWidth := 55;
    Items[4].text := GetLangStringW(STR_RESOLUTION);
     items[4].Alignment := taCenter;
     Items[4].MinWidth := 70;
    Items[5].text := GetLangStringW(STR_LANGUAGE);
     items[5].Alignment := taLeftJustify;
     Items[5].MinWidth := 70;
    Items[6].text := GetLangStringW(STR_DATE_COLUMN);
     items[6].Alignment := taCenter;
     Items[6].MinWidth := 80;
    Items[7].text := GetLangStringW(STR_SIZE);
     items[7].Alignment := taRightJustify;
     Items[7].MinWidth := 75;
    Items[8].text := GetLangStringW(STR_FORMAT);
     items[8].Alignment := taCenter;
     Items[8].MinWidth := 50;
    Items[9].text := GetLangStringW(STR_FILENAME);
     items[9].Alignment := taLeftJustify;
     Items[9].MinWidth := 150;
      tree.header.AutoSizeIndex := 9;
end;


 for i := 0 to 9 do begin
  Items[i].imageindex := 1000;
  if Items[i].text='' then Items[i].Options := []
  else Items[i].Options := [coAllowClick,coDraggable,coEnabled,coParentBidiMode,coParentColor,coResizable,coShowDropMark,coVisible];
 end;

end;

 header_library_load(regname1,regname2,tree,categoria,esclusione);

end;

procedure header_library_load(regname1,regname2: string; tree: Tcomettree; categoria: Byte; esclusione: Byte);
var
reg: Tregistry;
stringa: string;
elemento,i: Integer;
categoriastr,esclusionestr: string;
begin

case categoria of
 CAT_ALL:categoriastr := 'all';
 CAT_AUDIO:categoriastr := 'aud';
 CAT_VIDEO:categoriastr := 'vid';
 CAT_IMAGE:categoriastr := 'ima';
 CAT_DOCUMENT:categoriastr := 'doc';
 CAT_SOFTWARE:categoriastr := 'sof';
 CAT_OTHER:categoriastr := 'oth';
 CAT_RECENT:categoriastr := 'rec' else
 categoriastr := 'gen';
end;

case esclusione of
 CAT_GROUPBY_ARTIST:esclusionestr := 'art';
 CAT_GROUPBY_ALBUM:esclusionestr := 'alb';
 CAT_GROUPBY_GENRE:esclusionestr := 'gnr';
 CAT_GROUPBY_CATEGORY:esclusionestr := 'cat';
 CAT_GROUPBY_COMPANY:esclusionestr := 'com';
 CAT_GROUPBY_AUTHOR:esclusionestr := 'aut' else
  esclusionestr := 'nog';
end;


reg := tregistry.create;
with reg do begin
try                            //PMBrowse
 openkey(areskey+'Columns\'+regname1,true);
 stringa := readstring(categoriastr+'.'+esclusionestr);
if stringa='' then stringa := '0,0,0,0,0,0,0,0,0,0';
 for i := 0 to 9 do begin
 elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),70);
 stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
  if tree.Header.Columns.Items[i].text<>'' then begin
   if elemento<30 then elemento := 30;
     if categoriastr<>'gen' then
      if elemento>=tree.clientwidth then elemento := 70;
    tree.Header.Columns.Items[i].width := elemento;
  end else begin
   tree.Header.Columns.Items[i].width := 0;
  end;
 end;
 closekey;


//ora prendi posizioni!
 openkey(areskey+'Positions\'+regname1,true);
 stringa := readstring(categoriastr+'.'+esclusionestr);
 if stringa='' then stringa := '0,1,2,3,4,5,6,7,8,9,';
 for i := 0 to 9 do begin
 elemento := strtointdef(copy(stringa,1,pos(',',stringa)-1),-1);
 if elemento=-1 then break;
 stringa := copy(stringa,pos(',',stringa)+1,length(stringa));
 tree.Header.Columns.Items[i].position := elemento;
 end;
 closekey;

 openkey(areskey,true);  //LastPMBrowse'
 writestring('GUI.Last'+regname2,categoriastr+'.'+esclusionestr);
 closekey;
except
end;
 destroy;
end;

end;

procedure header_library_save(regname1,regname2: string; tree: Tcomettree);
var
reg: Tregistry;
last_seen: string;
stringa: string;
i: Integer;
begin
if tree.Header.height>=30 then exit; //non general!

reg := tregistry.create;
with reg do begin
 try
 openkey(areskey,true);
 last_seen := readstring('GUI.Last'+regname2);
 if last_seen<>'' then begin
 closekey;
 openkey(areskey+'Columns\'+regname1,true);
 with tree.header.columns do
 stringa := inttostr(Items[0].width)+','+
          inttostr(Items[1].width)+','+
          inttostr(Items[2].width)+','+
          inttostr(Items[3].width)+','+
          inttostr(Items[4].width)+','+
          inttostr(Items[5].width)+','+
          inttostr(Items[6].width)+','+
          inttostr(Items[7].width)+','+
          inttostr(Items[8].width)+','+
          inttostr(Items[9].width)+',';
 writestring(last_seen,stringa);
 end;
 closekey;


//ora salva posizioni!
 openkey(areskey+'Positions\'+regname1,true);
 stringa := '';
 for i := 0 to 9 do stringa := stringa+inttostr(tree.Header.Columns.Items[i].position)+',';
 writestring(last_seen,stringa);
 except
 end;
 destroy;
end;

end;


end.
