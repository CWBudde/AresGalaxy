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
string finalization procedures
}

unit helper_stringfinal;

interface

uses
ares_types,ares_objects,comettrees;

procedure reset_pfile_strings(pfile:precord_file_library);
procedure reset_pfile_trusted_strings(pfile:precord_file_trusted);
procedure finalize_file_library(sender: TBaseCometTree; node:PCmtVNode);
procedure finalize_chatchannel(Sender: TBaseCometTree; Node: PCmtVNode);
procedure finalize_displayed_treeviewupload(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_displayed_queued(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_displayed_download(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_virtualbrowse_entry(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_regular_browse_folder(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_file_playlist(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_mfolder(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_search_result(Sender: TBaseCometTree;Node: PCmtVNode);
procedure finalize_file_library_item(pfile:precord_file_library);
procedure finalize_chatfavorite(sender: TbaseCometTree; Node: PCmtVNode);


implementation

uses
vars_global,btcore,windows;

procedure finalize_chatfavorite(sender: TbaseCometTree; Node: PCmtVNode);
var
datao:precord_chat_favorite;
begin
datao := sender.getdata(node);
datao^.name := '';
datao^.topic := '';
datao^.stripped_topic := '';
end;

procedure finalize_search_result(Sender: TBaseCometTree;Node: PCmtVNode);
var
data:^record_search_result;
begin
try
data := sender.getdata(node);
with data^ do begin
 title := '';
 artist := '';
 album := '';
 filenameS := '';
 category := '';
 comments := '';
 language := '';
 url := '';
 year := '';
 hash_sha1 := '';
 hash_of_phash := '';
 keyword_genre := '';
 nickname := '';
end;

except
end;
end;

procedure finalize_mfolder(Sender: TBaseCometTree; Node: PCmtVNode);
var
  data:ares_types.precord_mfolder;
begin
data := sender.getdata(node);
data^.path := '';
end;

procedure finalize_file_playlist(Sender: TBaseCometTree; Node: PCmtVNode);
var
data:ares_types.precord_file_playlist;
begin
data := sender.getdata(node);

with data^ do begin
 displayName := '';
 filename := '';
end;

end;

procedure finalize_regular_browse_folder(Sender: TBaseCometTree; Node: PCmtVNode);
var
  data:ares_types.precord_cartella_share;
begin
 data := sender.getdata(node);
 with data^ do begin
  path := '';
  display_path := '';
  path_utf8 := '';
 end;
end;

procedure finalize_virtualbrowse_entry(Sender: TBaseCometTree; Node: PCmtVNode);
  var
  data:ares_types.precord_string;
begin
data := sender.getdata(node);
data^.str := '';
end;

procedure finalize_displayed_download(Sender: TBaseCometTree; Node: PCmtVNode);
var
dataNode:precord_data_node;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.precord_Displayed_source;
DsData:precord_displayed_downloadsource;
begin
dataNode := sender.getdata(node);

case dataNode^.m_type of

 dnt_bittorrentMain:begin
   BtData := dataNode^.data;
   with BtData^ do begin
     filename := '';
     hash_sha1 := '';
     path := '';
     trackerStr := '';
     SetLength(bitfield,0);
   end;
   FreeMem(BtData,sizeof(record_displayed_bittorrentTransfer));
 end;

 dnt_bittorrentSource:begin
  BtSrcData := dataNode^.data;
  with BtSrcData^ do begin
   ipS := '';
   ID := '';
   client := '';
   foundby := '';
   VisualBitField.Free;
  end;
  FreeMem(BtSrcData,sizeof(btcore.record_Displayed_source));
 end;

 dnt_downloadSource:begin
  DsData := dataNode^.data;
  with DsData^ do begin
   nomedisplayw := '';
   nickname := '';
   versionS := '';
  end;
  FreeMem(DsData,sizeof(record_displayed_downloadsource));
 end;

 dnt_download,
 dnt_partialDownload:begin
   DnData := dataNode^.data;
    with DnData^ do begin
     title := '';
     hash_sha1 := '';
     nomedisplayW := '';
     filename := '';
     artist := '';
     album := '';
     category := '';
     language := '';
     date := '';
     url := '';
     comments := '';
     keyword_genre := '';
     SetLength(visualbitfield,0);
    end;
    FreeMem(DnData,sizeof(record_displayed_download));
 end;
 
end;

end;

procedure finalize_displayed_queued(Sender: TBaseCometTree; Node: PCmtVNode);
var
data:precord_queued;
begin
data := sender.getdata(node);
with data^ do begin
 nomefile := '';
 user := '';
 his_agent := '';
end;
end;

procedure finalize_displayed_treeviewupload(Sender: TBaseCometTree; Node: PCmtVNode);
var
dataNode:precord_data_node;
UpData:precord_displayed_upload;
DnData:precord_displayed_download;
BtData:precord_displayed_bittorrentTransfer;
BtSrcData:btcore.precord_Displayed_source;
begin
dataNode := sender.getdata(node);

case dataNode^.m_type of

  dnt_bittorrentMain:begin
   BtData := dataNode^.data;
   with BtData^ do begin
     filename := '';
     hash_sha1 := '';
     path := '';
     trackerStr := '';
     SetLength(Bitfield,0);
   end;
   FreeMem(BtData,sizeof(record_displayed_bittorrentTransfer));
 end;

 dnt_bittorrentSource:begin
  BtSrcData := dataNode^.data;
  with btSrcData^ do begin
   ipS := '';
   ID := '';
   client := '';
   VisualBitField.Free;
  end;
  FreeMem(BtSrcData,sizeof(btcore.record_Displayed_source));
 end;

 dnt_upload:begin
   UpData := dataNode^.data;
     with UpData^ do begin
      nomefile := '';
      nickname := '';
      his_agent := '';
     end;
     FreeMem(UpData,sizeof(record_displayed_upload));
 end;

 dnt_Partialupload:begin
  DnData := dataNode^.data;
  with DnData^ do begin
    title := '';
    filename := '';
    artist := '';
    album := '';
    category := '';
    language := '';
    date := '';
    url := '';
    comments := '';
    keyword_genre := '';
  end;
  FreeMem(DnData,sizeof(record_displayed_download));
 end;

end;

end;

procedure finalize_chatchannel(Sender: TBaseCometTree; Node: PCmtVNode);
var
 data:^recorD_displayed_channel;
begin
data := sender.getdata(node);
with data^ do begin
 name := '';
 topic := '';
 language := '';
 stripped_topic := '';
end;
end;

procedure finalize_file_library(sender: TBaseCometTree; node:PCmtVNode);
var
data:^record_file_library;
begin
data := sender.getdata(node);
with data^ do begin
 album := '';
 artist := '';
 category := '';
 mediatype := '';
 vidinfo := '';
 comment := '';
 language := '';
 path := '';
 title := '';
 url := '';
 year := '';
 hash_sha1 := '';
 hash_of_phash := '';
 ext := '';
 keywords_genre := '';
end;
end;

procedure finalize_file_library_item(pfile:precord_file_library);
begin
with pfile^ do begin
 album := '';
 artist := '';
 category := '';
 mediatype := '';
 vidinfo := '';
 comment := '';
 language := '';
 path := '';
 title := '';
 url := '';
 year := '';
 hash_sha1 := '';
 hash_of_phash := '';
 ext := '';
 keywords_genre := '';
end;
end;

procedure reset_pfile_strings(pfile:precord_file_library);
begin
with pfile^ do begin
 title := '';
 artist := '';
 album := '';
 category := '';
 year := '';
 vidinfo := '';
 language := '';
 url := '';
 comment := '';
 mediatype := '';
 keywords_genre := '';
 hash_sha1 := '';
 hash_of_phash := '';
 path := '';
 ext := '';
end;
end;

procedure reset_pfile_trusted_strings(pfile:precord_file_trusted);
begin

with pfile^ do begin
 title := '';
 artist := '';
 album := '';
 category := '';
 year := '';
 vidinfo := '';
 language := '';
 url := '';
 comment := '';
 mediatype := '';
 keywords_genre := '';
 hash_sha1 := '';
 path := '';
end;
end;


end.
