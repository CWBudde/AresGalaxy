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
search_panel GUI stuff
}

unit helper_search_gui;

interface

uses
comettrees,controls,classes,registry,graphics,windows,ares_types,sysutils,
ComObj, ActiveX,classes2,TntComCtrls,TntExtCtrls,TntStdCtrls,forms,extctrls,
cometPageView;

procedure mainGui_invalidate_searchpanel;
procedure searchpanel_hide_togglemoreopt;
procedure gui_start_search;
procedure gui_stop_search;
function clear_search_history: Boolean;
procedure clear_search_fields;
procedure search_toggle_moreopt;
procedure search_toggle_back;
procedure searchpanel_invalidatemimeicon(cat: Byte);
procedure searchhistory_newitem_add;
procedure searchpanel_invalidate_moreopt;
procedure reg_erase_lastsearch;
procedure searchpanel_add_histories;
procedure clear_backup_results(src:precord_panel_search);
procedure add_search_result(listview: Tcomettree; result_search:precord_search_result);
procedure unbold_results;
procedure put_backup_results_inprogress(src:precord_panel_search; datao:precord_search_result);
function gui_create_new_SRCtab(search_str: string):precord_panel_search;
procedure init_srcTab_vars(src:precord_panel_search; search_str: string);
procedure zero_header_search(listview: Tcomettree);
procedure enable_search_fields;
function check_complex_search(src:precord_panel_Search; result_search:precord_search_result): Boolean;
function check_matching_srcmime(src:precord_panel_search; result_search:precord_search_result): Boolean;
function FindMatchingSearchResult(listview: TComettree; nresult:precord_search_result; var error:boolean):pcmtvnode;
procedure FillMissingSearchMeta(source,destination:precord_search_result);
procedure copy_node_src(listview: TCometTree; ExistentNode,NewNode:pcmtvnode);
procedure copy_node_dataNParentAttributes(listview: TCometTree; ParentNode:PcmtVnode; sresult:precord_search_result; DestinationNode:pcmtVnode);
procedure copy_node_data(src:precord_panel_search; sresult:precord_search_result; DestinationNode:pcmtVnode);
function IP_excedeedPublishLimit(list: TMylist; ip: Cardinal): Boolean;
procedure SetFocusSrc;
function isSrcComboFocused: Boolean;


implementation

uses
ufrmmain,vars_global,vars_localiz,helper_unicode,
const_ares,helper_combos,helper_strings,helper_bighints,
helper_visual_headers,helper_registry,helper_mimetypes,
helper_share_misc,dhtutils{,thread_webtorrent};

procedure copy_node_src(listview: TCometTree; ExistentNode,NewNode:pcmtvnode);
var
ExistentData,NewData:precord_search_result;
begin
ExistentData := Listview.getData(ExistentNode);
NewData := Listview.GetData(NewNode);

with NewData^ do begin
 DHTLoad := ExistentData^.DHTLoad;
 bold_font := ExistentData^.bold_font;
 hash_sha1 := ExistentData^.hash_sha1;
 crcsha1 := ExistentData^.crcsha1;
 nickname := ExistentData^.nickname;
 filenameS := ExistentData^.filenameS;
 ip_alt := ExistentData^.ip_alt;
 ip_user := ExistentData^.ip_user;
 ip_server := ExistentData^.ip_server;
 port_user := ExistentData^.port_user;
 port_server := ExistentData^.port_server;
 hash_of_phash := ExistentData^.hash_of_phash;
 title := ExistentData^.title;
 artist := ExistentData^.artist;
 album := ExistentData^.album;
 keyword_genre := ExistentData^.keyword_genre;
 category := ExistentData^.category;
 comments := ExistentData^.comments;
 language := ExistentData^.language;
 url := ExistentData^.url;
 year := ExistentData^.year;
 fsize := ExistentData^.fsize;
 param1 := ExistentData^.param1;
 param2 := ExistentData^.param2;
 param3 := ExistentData^.param3;
 amime := ExistentData^.amime;
 being_downloaded := ExistentData^.being_downloaded;
 already_in_lib := ExistentData^.already_in_lib;
 downloaded := ExistentData^.downloaded;
 isTorrent := ExistentData^.isTorrent;
 imageindex := ExistentData^.imageindex;
end;

with ExistentData^ do begin
 nickname := '';
 ip_alt := 0;
 port_server := 0;
 ip_server := 0;
 ip_user := 0;
 port_user := 0;
end;

end;

procedure copy_node_data(src:precord_panel_search; sresult:precord_search_result; DestinationNode:pcmtVnode);
var
destinationData:precord_search_result;
begin
destinationData := src^.listview.getData(DestinationNode);

with DestinationData^ do begin
 bold_font := ((ares_frmmain.tabs_pageview.activepage<>IDTAB_SEARCH) or (src^.containerPanel<>ares_frmmain.pagesrc.activepanel));
 DHTLoad := sresult^.DHTLoad;
 hash_sha1 := sresult^.hash_sha1;
 crcsha1 := sresult^.crcsha1;
 nickname := sresult^.nickname;
 filenameS := sresult^.filenameS;
 ip_alt := sresult^.ip_alt;
 ip_user := sresult^.ip_user;
 ip_server := sresult^.ip_server;
 port_user := sresult^.port_user;
 port_server := sresult^.port_server;
 hash_of_phash := sresult^.hash_of_phash;
 title := sresult^.title;
 artist := sresult^.artist;
 album := sresult^.album;
 keyword_genre := sresult^.keyword_genre;
 category := sresult^.category;
 comments := sresult^.comments;
 language := sresult^.language;
 url := sresult^.url;
 year := sresult^.year;
 fsize := sresult^.fsize;
 param1 := sresult^.param1;
 param2 := sresult^.param2;
 param3 := sresult^.param3;
 amime := sresult^.amime;
 being_downloaded := sresult^.being_downloaded;
 already_in_lib := sresult^.already_in_lib;
 downloaded := sresult^.downloaded;
 isTorrent := sresult^.isTorrent;
 imageindex := sresult^.imageindex;
end;

end;

procedure copy_node_dataNParentAttributes(listview: TCometTree; ParentNode:PcmtVnode; sresult:precord_search_result; DestinationNode:pcmtVnode);
var
destinationData,parentData:precord_search_result;
begin
destinationData := listview.getData(DestinationNode);
parentData := listview.getData(ParentNode);

with DestinationData^ do begin
 DHTLoad := parentData^.DHTLoad;
 bold_font := parentData^.bold_font;
 hash_sha1 := sresult^.hash_sha1;
 crcsha1 := sresult^.crcsha1;
 nickname := sresult^.nickname;
 filenameS := sresult^.filenameS;
 ip_alt := sresult^.ip_alt;
 ip_user := sresult^.ip_user;
 ip_server := sresult^.ip_server;
 port_user := sresult^.port_user;
 port_server := sresult^.port_server;
 hash_of_phash := sresult^.hash_of_phash;
 title := sresult^.title;
 artist := sresult^.artist;
 album := sresult^.album;
 keyword_genre := sresult^.keyword_genre;
 category := sresult^.category;
 comments := sresult^.comments;
 language := sresult^.language;
 url := sresult^.url;
 year := sresult^.year;
 fsize := sresult^.fsize;
 param1 := sresult^.param1;
 param2 := sresult^.param2;
 param3 := sresult^.param3;
 amime := sresult^.amime;
 being_downloaded := sresult^.being_downloaded;
 already_in_lib := sresult^.already_in_lib;
 downloaded := sresult^.downloaded;
 isTorrent := sresult^.isTorrent;
end;

end;

procedure SetFocusSrc;
var
i: Integer;
src:precord_panel_search;
begin
try

for i := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[i];
 if src^.containerPanel=ares_frmmain.pagesrc.ActivePanel then begin
  src^.listview.SetFocus;
 break;
 end;
end;

except
end;
end;

function isSrcComboFocused: Boolean;
begin
if (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_search) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_lang_search) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_sel_duration) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_sel_quality) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_sel_size) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_wanted_duration) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combo_wanted_quality) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.comboalbsearch) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.comboautsearch) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combocatsearch) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combodatesearch) or
   (ufrmmain.ares_frmmain.ActiveControl=ufrmmain.ares_frmmain.combotitsearch) then Result := true else Result := False;
end;

function FindMatchingSearchResult(listview: TComettree; nresult:precord_search_result; var error:boolean):pcmtvnode;

   function has_alreadyip(ip: Cardinal; node:pcmtvnode): Boolean;
   var
   childnode:pcmtvnode;
   datachild:precord_search_result;
   begin
    Result := False;
      childnode := listview.getfirstchild(node);
      while (childnode<>nil) do begin
        datachild := listview.getdata(childnode);
        if datachild^.ip_user=ip then begin
         Result := True;
         exit;
        end;
      childnode := listview.getnextsibling(childnode);
      end;
   end;
   

var
compData:precord_search_result;
begin
error := True;

   Result := listview.GetFirst;
   while (result<>nil) do begin

     compData := listview.getdata(result);

     if nresult^.fsize<>compData^.fsize then begin
      Result := listview.GetNextSibling(result);
      continue;
     end;

       if nresult^.crcsha1=compData^.crcsha1 then
         if nresult^.hash_sha1=compData^.hash_sha1 then begin

            if result^.childcount=0 then begin
               if nresult^.ip_user=compData^.ip_user then exit;
            end else
            if has_alreadyip(nresult^.ip_user,result) then exit;
            FillMissingSearchMeta(nresult,compData);

            error := False;
           exit;
         end;

       Result := listview.GetNextSibling(result);
   end;

error := False;
end;

function IP_excedeedPublishLimit(list: TMylist; ip: Cardinal): Boolean;
var
hit:precord_search_result;
instances,i: Integer;
begin
result := False;

instances := 0;
  for i := 0 to list.count-1 do begin
   hit := list[i];
   if hit^.ip_user<>ip then continue;

    inc(instances);
    if instances>=2 then begin
     Result := True;
     exit;
    end;
   end;
end;

procedure FillMissingSearchMeta(source,destination:precord_search_result);
begin
if destination^.param1=0 then destination^.param1 := source^.param1;
if destination^.param2=0 then destination^.param2 := source^.param2;
if destination^.param3=0 then destination^.param3 := source^.param3;

if destination^.category='' then destination^.category := source^.category;
if destination^.filenameS='' then destination^.filenameS := source^.filenameS;
if destination^.language='' then destination^.language := source^.language;
if destination^.year='' then destination^.year := source^.year;
if destination^.url='' then destination^.url := source^.url;
if destination^.comments='' then destination^.comments := source^.comments;
if destination^.keyword_genre='' then destination^.keyword_genre := source^.keyword_genre;
if destination^.album='' then destination^.album := source^.album;
if destination^.artist='' then destination^.artist := source^.artist;
end;

function check_matching_srcmime(src:precord_panel_search; result_search:precord_search_result): Boolean;
begin
result := False;
  with result_search^ do begin
      if src^.mime_search=ARES_MIME_GUI_ALL then begin
         if (amime=ARES_MIME_SOFTWARE) or (amime=ARES_MIME_OTHER) then begin
          //if fsize<10*MEGABYTE then exit;
          exit;
         end;
      end else
      if src^.mime_search=ARES_MIME_MP3 then begin
         if amime<>ARES_MIME_MP3 then exit;
      end else
      if src^.mime_search=ARES_MIME_VIDEO then begin
         if amime<>ARES_MIME_VIDEO then exit;
      end else
      if src^.mime_search=ARES_MIME_IMAGE then begin
         if amime<>ARES_MIME_IMAGE then exit;
      end else
      if src^.mime_search=ARES_MIME_DOCUMENT then begin
        if amime<>ARES_MIME_DOCUMENT then exit;
      end else
      if src^.mime_search=ARES_MIME_SOFTWARE then begin
        if amime<>ARES_MIME_SOFTWARE then
         if amime<>ARES_MIME_OTHER then exit;
      end else
      if src^.mime_search=ARES_MIME_OTHER then begin
        if amime<>ARES_MIME_OTHER then exit;
      end;
  end;
  Result := True;
end;

function check_complex_search(src:precord_panel_Search; result_search:precord_search_result): Boolean;
var
  num: Cardinal;
begin
  Result := False;


   if src^.combo_sel_duration_index>0 then
    if src^.combo_wanted_duration_index>0 then
     if ((result_search^.amime=ARES_MIME_MP3) or (result_search^.amime=ARES_MIME_VIDEO)) then begin
        num := combo_index_to_duration(src^.combo_wanted_duration_index);
        case src^.combo_sel_duration_index of
         1:if result_search^.param3>num then exit;
         2:begin
           if result_search^.param3>num+(num div 10) then exit;
           if result_search^.param3<num-(num div 10) then exit;
         end else begin
          if result_search^.param3<num then exit;
         end;
        end;
    end;




    if src^.combo_sel_quality_index>0 then
     if src^.combo_wanted_quality_index>0 then
      if result_search^.amime=ARES_MIME_MP3 then begin
       num := combo_index_to_bitrate(src^.combo_wanted_quality_index);
       case src^.combo_sel_quality_index of
        1:if result_search^.param1>num then exit;
        2:begin
          if result_search^.param1<>num then exit;
         end else begin
          if result_search^.param1<num then exit;
         end;
        end;
      end else
      if ((result_search^.amime=ARES_MIME_IMAGE) or (result_search^.amime=ARES_MIME_VIDEO)) then begin
        num := combo_index_to_resolution(src^.combo_wanted_quality_index);
        case src^.combo_sel_quality_index of
         1:if result_search^.param1>num then exit;
         2:begin
           if result_search^.param1<>num then exit;
          end else begin
           if result_search^.param1<num then exit;
          end;
         end;
      end;



       ////////////////////// check size
      if src^.combo_sel_size_index>0 then
       if src^.combo_wanted_size_index>0 then begin
        num := combo_index_to_size(src^.combo_wanted_size_index);
        case src^.combo_sel_size_index of
         1:if result_search^.fsize>num then exit;
         2:begin
           if result_search^.fsize>num+(num div 10) then exit;
           if result_search^.fsize<num-(num div 10) then exit;
          end else begin
           if result_search^.fsize<num then exit;
          end;
         end;
      end;

      
    Result := True;

end;

procedure add_search_result(listview: Tcomettree; result_search:precord_search_result);
var
nodedata,newdata1,newdata2,data_child:precord_search_result;
scannode,node_child,newnode1,newnode2:pCmtVnode;
begin

with listview do begin

  try

   scannode := GetFirst;
   while (scannode<>nil) do begin

     nodedata := getdata(scannode);

       if result_search^.fsize<>nodedata^.fsize then begin
        scannode := GetNextSibling(scannode);
        continue;
       end;

       if result_search^.crcsha1<>0 then
        if result_search^.crcsha1=nodedata^.crcsha1 then
         if result_search^.hash_sha1=nodedata^.hash_sha1 then begin

              node_child := getfirstchild(scannode);
              while (node_child<>nil) do begin
                data_child := getdata(node_child);
                 if data_child^.ip_user=result_search^.ip_user then
                  if data_child^.port_user=result_search^.port_user then exit;
               node_child := getnextsibling(node_child);
              end;



             if scannode^.childcount=0 then begin
               newnode1 := addchild(scannode);
                newdata1 := getdata(newnode1);
                with newdata1^ do begin
                 nickname := nodedata^.nickname;
                 filenameS := nodedata^.filenameS;
                  ip_alt := nodedata^.ip_alt;
                  ip_user := nodedata^.ip_user;
                  ip_server := nodedata^.ip_server;
                  port_user := nodedata^.port_user;
                  port_server := nodedata^.port_server;
                 title := nodedata^.title;
                 artist := nodedata^.artist;
                 album := nodedata^.album;
                 keyword_genre := nodedata^.keyword_genre;
                 category := nodedata^.category;
                 comments := nodedata^.comments;
                 language := nodedata^.language;
                 url := nodedata^.url;
                 year := nodedata^.year;
                 fsize := nodedata^.fsize;
                 param1 := nodedata^.param1;
                 param2 := nodedata^.param2;
                 param3 := nodedata^.param3;
                 amime := nodedata^.amime;
                 being_downloaded := nodedata^.being_downloaded;
                 already_in_lib := nodedata^.already_in_lib;
                 downloaded := nodedata^.downloaded;
                end;

              nodedata^.nickname := '';
              nodedata^.ip_alt := 0;
              nodedata^.port_server := 0;
              nodedata^.ip_server := 0;
              nodedata^.ip_user := 0;
              nodedata^.port_user := 0;

               newnode2 := addchild(scannode);
                newdata2 := getdata(newnode2);
                 with newdata2^ do begin
                 nickname := result_search^.nickname;
                 filenameS := result_search^.filenameS;
                  ip_alt := result_search^.ip_alt;
                  ip_user := result_search^.ip_user;
                  ip_server := result_search^.ip_server;
                  port_user := result_search^.port_user;
                  port_server := result_search^.port_server;
                 hash_of_phash := result_search^.hash_of_phash;
                 hash_sha1 := result_search^.hash_sha1;
                 crcsha1 := result_search^.crcsha1;
                 title := result_search^.title;
                 artist := result_search^.artist;
                 album := result_search^.album;
                 keyword_genre := result_search^.keyword_genre;
                 category := result_search^.category;
                 comments := result_search^.comments;
                 language := result_search^.language;
                 url := result_search^.url;
                 year := result_search^.year;
                 fsize := result_search^.fsize;
                 param1 := result_search^.param1;
                 param2 := result_search^.param2;
                 param3 := result_search^.param3;
                 amime := nodedata^.amime;
                 being_downloaded := nodedata^.being_downloaded;
                 already_in_lib := nodedata^.already_in_lib;
                 downloaded := nodedata^.downloaded;
                end;
             end else begin
               newnode1 := addchild(scannode);
                newdata1 := getdata(newnode1);
                 with newdata1^ do begin
                 nickname := result_search^.nickname;
                 filenameS := result_search^.filenameS;
                  ip_alt := result_search^.ip_alt;
                  ip_user := result_search^.ip_user;
                  ip_server := result_search^.ip_server;
                  port_user := result_search^.port_user;
                  port_server := result_search^.port_server;
                 hash_of_phash := result_search^.hash_of_phash;
                 hash_sha1 := result_search^.hash_sha1;
                 crcsha1 := result_search^.crcsha1;
                 title := result_search^.title;
                 artist := result_search^.artist;
                 album := result_search^.album;
                 keyword_genre := result_search^.keyword_genre;
                 category := result_search^.category;
                 comments := result_search^.comments;
                 language := result_search^.language;
                 url := result_search^.url;
                 year := result_search^.year;
                 fsize := result_search^.fsize;
                 param1 := result_search^.param1;
                 param2 := result_search^.param2;
                 param3 := result_search^.param3;
                 amime := nodedata^.amime;
                 being_downloaded := nodedata^.being_downloaded;
                 already_in_lib := nodedata^.already_in_lib;
                 downloaded := nodedata^.downloaded;
                end;
             end;

      exit;
      end;
     scannode := GetNextSibling(scannode);
     end;

     except
     end;
    //end if equal hash to another



    newnode1 := AddChild(nil);
    NodeData := GetData(newnode1);

    with nodedata^ do begin
       artist := result_search^.artist;
       title := result_search^.title;
       album := result_search^.album;
       hash_of_phash := result_search^.hash_of_phash;
       hash_sha1 := result_search^.hash_sha1;
       crcsha1 := result_search^.crcsha1;
       already_in_lib := (is_in_lib_sha1(result_search^.hash_sha1));
       being_downloaded := (is_in_progress_sha1(result_search^.hash_sha1));
       amime := result_search^.amime;
       filenameS := result_search^.filenameS;
       nickname := result_search^.nickname;
                  ip_alt := result_search^.ip_alt;
                  ip_user := result_search^.ip_user;
                  ip_server := result_search^.ip_server;
                  port_user := result_search^.port_user;
                  port_server := result_search^.port_server;
       downloaded := result_search^.downloaded;
       fsize := result_search^.fSize;
       param1 := result_search^.param1;
       param2 := result_search^.param2;
       param3 := result_search^.param3;
       keyword_genre := result_search^.keyword_genre;
       category := result_search^.category;
       comments := result_search^.comments;
       language := result_search^.language;
       year := result_search^.year;
       url := result_search^.url;
       imageindex := amime_to_imgindexsmall(result_search^.amime);
     end;

end;

end;

procedure put_backup_results_inprogress(src:precord_panel_search; datao:precord_search_result);
var                      //set downloaded flag to true in order to restore 'downloaded' flag in case of filter search on results
i: Integer;
resul:precord_search_result;
begin

 for i := 0 to src^.backup_results.count-1 do begin
 resul := src^.backup_results[i];
  if resul^.crcsha1=datao^.crcsha1 then
   if resul^.hash_sha1=datao^.hash_sha1 then resul^.downloaded := True;
 end;

end;

procedure unbold_results;
var
src:precord_panel_search;
node:pcmtvnode;
datao:precord_search_result;
pnl: TCometPagePanel;
begin
try
if src_panel_list=nil then exit;

if not vars_global.was_on_src_tab then exit;


if last_shown_SRCtab=0 then exit;
if last_shown_SRCtab>=ares_frmmain.pagesrc.PanelsCount then exit;

 pnl := ares_frmmain.pagesrc.panels[last_shown_SRCtab];
 src := pnl.FData;

  with src^.listview do begin

  node := getfirst;
  while (node<>nil) do begin
    datao := getdata(node);
    datao^.bold_font := False;
    src^.listview.invalidateNode(node);
   node := getnext(node);
  end;

  end;

  except
  end;
end;

procedure clear_backup_results(src:precord_panel_search);
var
res:precorD_search_result;
begin


try

while (src^.backup_results.count>0) do begin
res := src^.backup_results[src^.backup_results.count-1];
     src^.backup_results.delete(src^.backup_results.count-1);
 with res^ do begin
   title := '';
   artist := '';
   album := '';
   filenameS := '';
   keyword_genre := '';
   category := '';
   comments := '';
   language := '';
   url := '';
   year := '';
   hash_sha1 := '';
   hash_of_phash := '';
   nickname := '';
end;
FreeMem(res,sizeof(record_search_result));

end;

FreeAndNil(src^.backup_results);
except
end;




end;


procedure reg_erase_lastsearch;
var
reg: Tregistry;
begin
reg := tregistry.create;

with reg do begin
 openkey(areskey,true);
  writestring('GUI.LastSearch','');
 closekey;
 destroy;
end;

end;






procedure searchpanel_invalidate_moreopt;
var
aggiunta: Byte;
begin
with ares_frmmain do begin

if radio_srcmime_all.checked then begin
// lbl_src_hint.top := 54;
// lbl_src_hint.left := 10;
 combo_search.left := 8;
 combo_search.top := 25;

 Btn_start_search.top := combo_search.top+combo_search.height+8;
 btn_stop_search.top := Btn_start_search.top;

if not ThemeServices.ThemesEnabled then aggiunta := 0 else aggiunta := 1;


 radio_srcmime_all.top := btn_stop_search.top+btn_stop_search.height+10;
  lbl_srcmime_all.top := radio_srcmime_all.top+1+aggiunta;

 radio_srcmime_audio.top := radio_srcmime_all.top+20;
  lbl_srcmime_audio.top := radio_srcmime_audio.top+1+aggiunta;

 radio_srcmime_video.top := radio_srcmime_audio.top+20;
  lbl_srcmime_video.top := radio_srcmime_video.top+1+aggiunta;

 radio_srcmime_image.top := radio_srcmime_video.top+20;
  lbl_srcmime_image.top := radio_srcmime_image.top+1+aggiunta;

 radio_srcmime_document.top := radio_srcmime_image.top+20;
  lbl_srcmime_document.top := radio_srcmime_document.top+1+aggiunta;

 radio_srcmime_software.top := radio_srcmime_document.top+20;
  lbl_srcmime_software.top := radio_srcmime_software.top+1+aggiunta;

 radio_srcmime_other.top := radio_srcmime_software.top+20;
  lbl_srcmime_other.top := radio_srcmime_other.top+1+aggiunta;


 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<radio_srcmime_other.top+20 then lbl_src_status.top := radio_srcmime_other.top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;

 radio_srcmime_all.left := 12;
 radio_srcmime_audio.left := radio_srcmime_all.left;
 radio_srcmime_video.left := radio_srcmime_all.left;
 radio_srcmime_image.left := radio_srcmime_all.left;
 radio_srcmime_document.left := radio_srcmime_all.left;
 radio_srcmime_software.left := radio_srcmime_all.left;
 radio_srcmime_other.left := radio_srcmime_all.left;
  lbl_srcmime_all.left := 28;
  lbl_srcmime_audio.left := lbl_srcmime_all.left;
  lbl_srcmime_video.left := lbl_srcmime_all.left;
  lbl_srcmime_image.left := lbl_srcmime_all.left;
  lbl_srcmime_document.left := lbl_srcmime_all.left;
  lbl_srcmime_software.left := lbl_srcmime_all.left;
  lbl_srcmime_other.left := lbl_srcmime_all.left;

end else
if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
// lbl_src_hint.top := 54;
// lbl_src_hint.left := 10;
 combo_search.left := 8;
 combo_search.top := 25;

 //if not radio_srcmime_other.checked then begin
  Btn_start_search.top := combo_search.top+combo_search.height+8;
  btn_stop_search.top := Btn_start_search.top;


 label_back_src.left := 34;
 label_more_searchopt.left := 34;

 image_back_top := Btn_start_search.top+Btn_start_search.height+5;
 label_back_src.top := image_back_top+2;
 image_more_top := image_back_top+20;
 image_less_top := image_more_top;
 label_more_searchopt.top := image_more_top+2;


 image_less_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_more_top+20 then lbl_src_status.top := image_more_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;

end else begin //advanced search
if radio_srcmime_audio.checked then begin  // audio  tit,auth,cat,album   date,quality,length,size
Label_title_search.top := 35;
 combotitsearch.top := Label_title_search.top-4;

Label_auth_search.top := Label_title_search.top+24;
 comboautsearch.top := Label_auth_search.top-4;
label_cat_search.top := Label_auth_search.top+24;
combocatsearch.Top := label_cat_search.top-4;
label_album_search.top := label_cat_search.top+24;
 comboalbsearch.top := label_album_search.top-4;
label_date_search.top := label_album_search.top+24;
 combodatesearch.top := label_date_search.top-4;
label_sel_duration.top := label_date_search.top+24;
combo_sel_duration.top := label_sel_duration.top-4;
combo_wanted_duration.top := combo_sel_duration.top;
label_sel_quality.top := label_sel_duration.top+24;
combo_sel_quality.top := label_sel_quality.top-4;
combo_wanted_quality.top := combo_sel_quality.top;
label_sel_size.top := label_sel_quality.top+24;
combo_sel_size.top := label_sel_size.top-4;
combo_wanted_size.top := combo_sel_size.top;

Btn_start_search.top := label_sel_size.top+26;
btn_stop_search.top := Btn_start_search.top;
image_back_top := Btn_start_search.top+Btn_start_search.height+5;
label_back_src.top := image_back_top+2;
image_more_top := image_back_top+20;
image_less_top := image_more_top;
label_more_searchopt.top := image_more_top+2;


label_back_src.left := 34;
label_more_searchopt.left := label_back_src.left;
//image_less.visible := True;
image_more_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
//panel_search.XPRoundHeight := 300;
end else
if radio_srcmime_video.checked then begin  // video   tit,auth,cat,date,   lang,res,length,size
Label_title_search.top := 35;
 combotitsearch.top := Label_title_search.top-4;
Label_auth_search.top := Label_title_search.top+24;
 comboautsearch.top := Label_auth_search.top-4;
label_cat_search.top := Label_auth_search.top+24;
 combocatsearch.Top := label_cat_search.top-4;
label_lang_search.top := label_cat_search.top+24;
 combo_lang_search.top := label_lang_search.top-4;
label_date_search.top := label_lang_search.top+24;
 combodatesearch.top := label_date_search.top-4;
label_sel_duration.top := label_date_search.top+24;
combo_sel_duration.top := label_sel_duration.top-4;
combo_wanted_duration.top := combo_sel_duration.top;
label_sel_quality.top := label_sel_duration.top+24;
combo_sel_quality.top := label_sel_quality.top-4;
combo_wanted_quality.top := combo_sel_quality.top;
label_sel_size.top := label_sel_quality.top+24;
combo_sel_size.top := label_sel_size.top-4;
combo_wanted_size.top := combo_sel_size.top;

Btn_start_search.top := label_sel_size.top+26;
btn_stop_search.top := Btn_start_search.top;
image_back_top := Btn_start_search.top+Btn_start_search.height+5;
label_back_src.top := image_back_top+2;
image_more_top := image_back_top+20;
image_less_top := image_more_top;
label_more_searchopt.top := image_more_top+2;


label_back_src.left := 34;
label_more_searchopt.left := label_back_src.left;
image_more_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;

//panel_search.XPRoundHeight := 300;
end else
if radio_srcmime_image.checked then begin  // images tit,auth,cat,album, date,res,size
Label_title_search.top := 35;
 combotitsearch.top := Label_title_search.top-4;
Label_auth_search.top := Label_title_search.top+24;
 comboautsearch.top := Label_auth_search.top-4;
label_cat_search.top := Label_auth_search.top+24;
 combocatsearch.Top := label_cat_search.top-4;
label_album_search.top := label_cat_search.top+24;
 comboalbsearch.top := label_album_search.top-4;
label_date_search.top := label_album_search.top+24;
combodatesearch.top := label_date_search.top-4;
label_sel_quality.top := label_date_search.top+24; //184;
combo_sel_quality.top := label_sel_quality.top-4; //180;
combo_wanted_quality.top := combo_sel_quality.top; //180;
label_sel_size.top := label_sel_quality.top+24; //208;
combo_sel_size.top := label_sel_size.top-4; //204;
combo_wanted_size.top := combo_sel_size.top; //204;

Btn_start_search.top := label_sel_size.top+26;
btn_stop_search.top := Btn_start_search.top;
image_back_top := Btn_start_search.top+Btn_start_search.height+5;
label_back_src.top := image_back_top+2;
image_more_top := image_back_top+20;
image_less_top := image_more_top;
label_more_searchopt.top := image_more_top+2;


label_back_src.left := 34;
label_more_searchopt.left := label_back_src.left;
image_more_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
//panel_search.XPRoundHeight := 276;
 end else
if ((radio_srcmime_document.checked) or (radio_srcmime_software.checked)) then begin  // document or soft   title,author,category,date,language,size
Label_title_search.top := 35;
 combotitsearch.top := Label_title_search.top-4;
Label_auth_search.top := Label_title_search.top+24;
 comboautsearch.top := Label_auth_search.top-4;
label_cat_search.top := Label_auth_search.top+24;
 combocatsearch.Top := label_cat_search.top-4;
label_lang_search.top := label_cat_search.top+24;
 combo_lang_search.top := label_lang_search.top-4;
label_date_search.top := label_lang_search.top+24;
 combodatesearch.top := label_date_search.top-4;
label_sel_size.top := label_date_search.top+24;
 combo_sel_size.top := label_sel_size.top-4;
 combo_wanted_size.top := combo_sel_size.top;


Btn_start_search.top := label_sel_size.top+26;
btn_stop_search.top := Btn_start_search.top;
image_back_top := Btn_start_search.top+Btn_start_search.height+5;
label_back_src.top := image_back_top+2;
image_more_top := image_back_top+20;
image_less_top := image_more_top;
label_more_searchopt.top := image_more_top+2;


label_back_src.left := 34;
label_more_searchopt.left := label_back_src.left;
image_more_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
//panel_search.XPRoundHeight := 252;
 end else
 if radio_srcmime_other.checked then begin  // document or soft   title,author,category,date,language,size
Label_title_search.top := 35;
 combotitsearch.top := Label_title_search.top-4;
label_sel_size.top := label_title_search.top+24;
 combo_sel_size.top := label_sel_size.top-4;
 combo_wanted_size.top := combo_sel_size.top;


Btn_start_search.top := label_sel_size.top+26;
btn_stop_search.top := Btn_start_search.top;
image_back_top := Btn_start_search.top+Btn_start_search.height+5;
label_back_src.top := image_back_top+2;
image_more_top := image_back_top+20;
image_less_top := image_more_top;
label_more_searchopt.top := image_more_top+2;


label_back_src.left := 34;
label_more_searchopt.left := label_back_src.left;
image_more_top := -1;

 lbl_src_status.top := ((panel_search.clientheight-edit_src_filter.height)-20)-lbl_src_status.height;
 if lbl_src_status.top<image_less_top+20 then lbl_src_status.top := image_less_top+20;
 edit_src_filter.top := lbl_src_status.top+lbl_src_status.height+10;
//panel_search.XPRoundHeight := 152;
 end;
end;

end;

end;


procedure searchhistory_newitem_add;
var
reg: Tregistry;
tit,aut,gen,alb,dat: string;
lista: TStringList;
begin
with ares_frmmain do begin

if radio_srcmime_all.checked then begin
    gen := 'gen';
    tit := '';
    aut := '';
    dat := '';
    alb := '';
end else
if radio_srcmime_audio.checked then begin
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'audio';
     tit := '';
     aut := '';
     dat := '';
     alb := '';

   end else begin
     gen := '';
     tit := 'audio';
     aut := 'audio';
     dat := 'audio';
     alb := 'audio';
   end;
end else
if radio_srcmime_video.checked then begin
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'video';
     tit := '';
     aut := '';
     dat := '';
     alb := '';
   end else begin
     gen := '';
     tit := 'video';
     aut := 'video';
     dat := 'video';
     alb := '';
   end;
end else
if radio_srcmime_image.checked then begin   //image
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'image';
     tit := '';
     aut := '';
     dat := '';
     alb := '';
   end else begin
     gen := '';
     tit := 'image';
     aut := 'image';
     dat := 'image';
     alb := 'image';
   end;
end else
if radio_srcmime_software.checked then begin
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'software';
     tit := '';
     aut := '';
     dat := '';
     alb := '';
   end else begin
     gen := '';
     tit := 'software';
     aut := 'software';
     dat := 'software';
     alb := '';
   end;
end else
if radio_srcmime_document.checked then begin
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'document';
     tit := '';
     aut := '';
     dat := '';
     alb := '';
   end else begin
     gen := '';
     tit := 'document';
     aut := 'document';
     dat := 'document';
     alb := '';
   end;
end else
if radio_srcmime_other.checked then begin
   if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     gen := 'other';
     tit := '';
     aut := '';
     dat := '';
     alb := '';
   end else begin
     gen := '';
     tit := 'other';
     aut := '';
     dat := '';
     alb := '';
   end;
end;

lista := tStringList.create;
reg := tregistry.create;

if length(tit)>1 then begin
   reg.openkey(areskey+'Search.History\'+tit+'.tit',true);
   reg.getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.clear;
 if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
  if add_tntcombo_history(combotitsearch) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(combotitsearch.text)),'');
 end else begin
  if add_tntcombo_history(combo_search) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(combo_search.text)),'');
 end;
   reg.closekey;
end;

if length(aut)>1 then begin
   reg.openkey(areskey+'Search.History\'+aut+'.aut',true);
   reg.getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.clear;
 if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
   if add_tntcombo_history(comboautsearch) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(comboautsearch.text)),'');
 end else begin
   if add_tntcombo_history(combo_search) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(combo_search.text)),'');
 end;
   reg.closekey;
end;

if length(gen)>1 then begin
   reg.openkey(areskey+'Search.History\'+gen+'.gen',true);
   reg.getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.clear;
   if add_tntcombo_history(combo_search) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(combo_search.text)),'');
 reg.closekey;
end;

if length(alb)>1 then begin
   reg.openkey(areskey+'Search.History\'+alb+'.alb',true);
   reg.getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.clear;
   if add_tntcombo_history(comboalbsearch) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(comboalbsearch.text)),'');
 reg.closekey;
end;


if length(dat)>1 then begin
   reg.openkey(areskey+'Search.History\'+dat+'.dat',true);
   reg.getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.clear;
   if add_tntcombo_history(combodatesearch) then reg.writestring(bytestr_to_hexstr(widestrtoutf8str(combodatesearch.text)),'');
 reg.closekey;
end;


reg.closekey;
reg.destroy;

lista.Free;

end;
end;

procedure searchpanel_invalidatemimeicon(cat: Byte);
var
btmap:graphics.TBitmap;
begin
with ares_frmmain do begin

try
btmap := graphics.TBitmap.create;
with img_mime_small do begin
 blendcolor := clfuchsia;
 bkcolor := clfuchsia;
  case cat of
   0:GetBitmap(2,btmap);
   1:GetBitmap(3,btmap);
   5:GetBitmap(4,btmap);
   7:GetBitmap(5,btmap);
   6:GetBitmap(7,btmap);
   3:GetBitmap(6,btmap);
   8:GetBitmap(2,btmap);
  end;
end;

with icon_mime_search.picture do begin
 bitmap.freeimage;
 bitmap := btmap;
 bitmap.transparent := True;
 bitmap.transparentcolor := clfuchsia;
end;

with img_mime_small do begin
 blendcolor := $00FEFFFF;
 bkcolor := clnone;
end;

btmap.Free;
except
end;
end;

end;

procedure search_toggle_back;
begin
with ares_frmmain do begin
 radio_srcmime_all.checked := True;
 radio_srcmime_audio.checked := False;
 radio_srcmime_video.checked := False;
 radio_srcmime_image.checked := False;
 radio_srcmime_document.checked := False;
 radio_srcmime_software.checked := False;
end;
ufrmmain.ares_frmmain.radiosearchmimeclick(nil);

end;

procedure search_toggle_moreopt;
begin

with ares_frmmain do begin


 if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then label_more_searchopt.caption := GetLangStringW(LESS_SEARCH_OPTION_STR)
  else label_more_searchopt.caption := GetLangStringW(MORE_SEARCH_OPTION_STR);

  label_more_searchopt.hint := label_more_searchopt.caption;
end;


ufrmmain.ares_frmmain.RadiosearchmimeClick(nil);

end;

procedure clear_search_fields;
begin
with ares_frmmain do begin
 comboautsearch.text := '';
 combotitsearch.text := '';
 comboalbsearch.text := '';
 combodatesearch.text := '';
 combo_lang_search.text := '';

 combocatsearch.itemindex := -1;
 combo_lang_search.itemindex := -1;
 combo_sel_duration.itemindex := -1;
 combo_wanted_duration.itemindex := -1;
 combo_sel_quality.itemindex := -1;
 combo_wanted_quality.itemindex := -1;
 combo_sel_size.itemindex := -1;
 combo_wanted_size.itemindex := -1;
end;

end;

function clear_search_history: Boolean;
var
reg: Tregistry;
begin
result := False;
if messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_SURE_TO_ERASE_HISTORY)),pwidechar(appname+chr(58)+chr(32){': '}+GetLangStringW(STR_ERASE_HISTORY)),mb_yesno+mb_iconquestion)=ID_NO then exit;

result := True;

reg := tregistry.create;
with reg do begin
 OpenKey(areskey,true);
 deletekey('Search.History');
 closekey;
 destroy;
end;

clear_search_fields;

with ares_frmmain do begin
 with comboautsearch.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with combotitsearch.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with comboalbsearch.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with combodatesearch.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with combo_lang_search.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with combocatsearch.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
 with combo_search.items do begin
  beginupdate;
  clear;
  endupdate;
 end;
end;
end;



procedure gui_stop_search;
var
nodo:pCmtVnode;
data:^record_search_result;
i: Integer;
src:precord_panel_search;
found: Boolean;
begin
with ares_frmmain do begin
 if Btn_start_search.enabled then exit;

  Btn_start_search.enabled := True;
  btn_stop_search.enabled := False;

 found := False;
src := nil;

if src_panel_list<>nil then
for i := 0 to src_panel_list.count-1 do begin
 src := src_panel_list[i];
 if src^.containerPanel<>pagesrc.ActivePanel then continue;

 src^.started := 0;
 src^.pnl.btncaption := utf8strtowidestr(src^.search_string)+' ('+inttostr(src^.numresults)+')';
 if src^.numresults>1 then src^.lbl_src_status_caption := inttostr(src^.numresults)+' ('+inttostr(src^.numhits)+') '+GetLangStringW(STR_RESULTS_FOR)+' '+utf8strtowidestr(src^.search_string) else
 if src^.numresults=1 then src^.lbl_src_status_caption := '1 ('+inttostr(src^.numhits)+') '+GetLangStringW(STR_RESULT_FOR)+' '+utf8strtowidestr(src^.search_string) else begin
 src^.lbl_src_status_caption := '0 '+GetLangStringW(STR_RESULTS_FOR)+' '+utf8strtowidestr(src^.search_string);
  with src^.listview do begin
   nodo := GetFirst;
   data := getdata(nodo);
   data^.title := GetLangStringA(STR_SEARCHING_THE_NET_NO_RESULT);
   invalidatenode(nodo);
  end;
 end;
 lbl_src_status.caption := src^.lbl_src_status_caption;

 found := True;
 break;
end;
end;


cambiato_search := True;   //let the client know we halted this one
if src=nil then exit;

vars_global.was_on_src_tab := False; // leave results bold, block unbolding
if found then ufrmmain.ares_frmmain.pagesrcPanelShow(ares_frmmain.pageSrc,src^.pnl);
vars_global.was_on_src_tab := True; // leave results bold
end;

procedure enable_search_fields;
begin
with ares_frmmain do begin
          lbl_srcmime_video.enabled := btn_start_search.enabled;
          lbl_srcmime_software.enabled := btn_start_search.enabled;
          lbl_srcmime_other.enabled := btn_start_search.enabled;
          lbl_srcmime_image.enabled := btn_start_search.enabled;
          lbl_srcmime_document.enabled := btn_start_search.enabled;
          lbl_srcmime_audio.enabled := btn_start_search.enabled;
          lbl_srcmime_all.enabled := btn_start_search.enabled;
         // lbl_src_hint.enabled := btn_start_search.enabled;
          label_title_search.enabled := btn_start_search.enabled;
          label_sel_size.enabled := btn_start_search.enabled;
          label_sel_quality.enabled := btn_start_search.enabled;
          label_sel_duration.enabled := btn_start_search.enabled;
          label_more_searchopt.enabled := btn_start_search.enabled;
          label_lang_search.enabled := btn_start_search.enabled;
          label_date_search.enabled := btn_start_search.enabled;
          label_cat_search.enabled := btn_start_search.enabled;
          label_back_src.enabled := btn_start_search.enabled;
          label_auth_search.enabled := btn_start_search.enabled;
      label_album_search.enabled := btn_start_search.enabled;
      combotitsearch.enabled := btn_start_search.enabled;
      combodatesearch.enabled := btn_start_search.enabled;
      combocatsearch.enabled := btn_start_search.enabled;
      comboautsearch.enabled := btn_start_search.enabled;
      comboalbsearch.enabled := btn_start_search.enabled;
      combo_wanted_size.enabled := btn_start_search.enabled;
      combo_wanted_quality.enabled := btn_start_search.enabled;
      combo_wanted_duration.enabled := btn_start_search.enabled;
      combo_sel_size.enabled := btn_start_search.enabled;
      combo_sel_quality.enabled := btn_start_search.enabled;
      combo_sel_duration.enabled := btn_start_search.enabled;
      combo_search.enabled := btn_start_search.enabled;
      combo_lang_search.enabled := btn_start_search.enabled;
      radio_srcmime_all.enabled := btn_start_search.enabled;
      radio_srcmime_audio.enabled := btn_start_search.enabled;
      radio_srcmime_document.enabled := btn_start_search.enabled;
      radio_srcmime_image.enabled := btn_start_search.enabled;
      radio_srcmime_other.enabled := btn_start_search.enabled;
      radio_srcmime_software.enabled := btn_start_search.enabled;
      radio_srcmime_video.enabled := btn_start_search.enabled;
      end;
end;

procedure init_srcTab_vars(src:precord_panel_search; search_str: string);
begin

header_search_save;
reg_erase_lastsearch;

with ares_frmmain do begin

with src^ do begin
 stato_header := search_header_inprog;
 numresults := 0;
 numhits := 0;
  if backup_results<>nil then clear_backup_results(src);
  backup_results := tmylist.create;
  
 searchID := random($ffff);
 search_string := search_str;
 lbl_src_status_caption := search_str;
 is_advanced := (widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(LESS_SEARCH_OPTION_STR));

  if radio_srcmime_all.checked then mime_search := ARES_MIME_GUI_ALL else
  if radio_srcmime_audio.checked then mime_search := ARES_MIME_MP3 else
  if radio_srcmime_video.checked then mime_search := ARES_MIME_VIDEO else
  if radio_srcmime_image.checked then mime_search := ARES_MIME_IMAGE else
  if radio_srcmime_document.Checked then mime_search := ARES_MIME_DOCUMENT else
  if radio_srcmime_software.checked then mime_search := ARES_MIME_SOFTWARE else
  mime_search := ARES_MIME_OTHER;


   // remember panel_search's status
   combo_lang_search_text := ares_frmmain.combo_lang_search.text;
   combo_search_text := ares_frmmain.combo_search.text;
   combo_sel_duration_index := ares_frmmain.combo_sel_duration.itemindex;
   combo_sel_quality_index := ares_frmmain.combo_sel_quality.itemindex;
   combo_sel_size_index := ares_frmmain.combo_sel_size.itemindex;
   combo_wanted_duration_index := ares_frmmain.combo_wanted_duration.itemindex;
   combo_wanted_quality_index := ares_frmmain.combo_wanted_quality.itemindex;
   combo_wanted_size_index := ares_frmmain.combo_wanted_size.itemindex;
   comboalbsearch_text := ares_frmmain.comboalbsearch.text;
   comboautsearch_text := ares_frmmain.comboautsearch.text;
   combocatsearch_text := ares_frmmain.combocatsearch.text;
   combodatesearch_text := ares_frmmain.combodatesearch.text;
   combotitsearch_text := ares_frmmain.combotitsearch.text;
end;
end;
end;

function gui_create_new_SRCtab(search_str: string):precord_panel_search;
var
i: Integer;
NewColumn: TvirtualtreeColumn;
begin

with ares_frmmain do begin

ares_frmmain.pagesrc.wrappable := True;

result := AllocMem(sizeof(record_panel_search));
result^.backup_results := nil;

init_srcTab_vars(result,search_str);

with result^ do begin

  containerPanel := tpanel.create(ares_frmmain);
  containerPanel.parent := pagesrc;
  containerPanel.caption := '';
  containerPanel.BevelOuter := bvNone;


  listview := tcomettree.create(containerPanel);
  with listview do begin
   parent := containerPanel;
   Align := alclient;
   Tag := longint(result); //per velocizzare ritrovamento stato header in get node
   PopupMenu := ares_frmmain.popup_search;
   bevelEdges := [];
    ongetsize := ufrmmain.ares_frmmain.listview_srcGetSize;
    onPaintHeader := ufrmmain.ares_frmmain.listview_libPaintHeader;
    ongettext := ufrmmain.ares_frmmain.listview_srcGetText;
    OnCompareNodes := ufrmmain.ares_frmmain.listview_srcCompareNodes;
    ongetimageindex := ufrmmain.ares_frmmain.listview_srcGetImageIndex;
    onheaderclick := ufrmmain.ares_frmmain.TreeviewHeaderClick;
    onfreenode := ufrmmain.ares_frmmain.listview_srcFreeNode;
    onpainttext := ufrmmain.ares_frmmain.listview_srcPaintText;
    OnDblClick := ufrmmain.ares_frmmain.listview_srcDblClick;
    onaftercellpaint := ufrmmain.ares_frmmain.listview_srcAfterCellPaint;
    onmousedown := ufrmmain.ares_frmmain.listview_srcMouseDown;
    onmouseup := ufrmmain.ares_frmmain.listview_srcMouseUp;
    onhintstart := ufrmmain.ares_frmmain.treeview_downloadHintStart;
    onhintstop := ufrmmain.ares_frmmain.treeview_downloadHintStop;
    Images := ares_frmmain.img_mime_small;
    BGColor := COLORE_ALTERNATE_ROW; //16775142;
    colors.HotColor := COLORE_LISTVIEW_HOT;
    BorderStyle := bsNone;
    BevelKind := bkFlat;
    CanBgColor := False;
    Ctl3D := True;
    font.name := ares_frmmain.font.name;
    font.size := ares_frmmain.font.size;
    //font.color := COLORE_LISTVIEWS_HEADERFONT;
    color := COLORE_LISTVIEWS_BG;
    font.color := COLORE_LISTVIEWS_FONT;
    Colors.GridLineColor := COLORE_LISTVIEWS_GRIDLINES;
    Colors.TreeLineColor := COLORE_LISTVIEWS_TREELINES;

    showhint := True;
    ParentBiDiMode := False;
    ParentCtl3D := False;
    ParentFont := False;
    ParentShowHint := False;

   with treeoptions do begin
    StringOptions := [];
    selectionoptions := [toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toMultiSelect, toRightClickSelect, toCenterScrollIntoView];
      if VARS_THEMED_HEADERS then PaintOptions := [toShowButtons, toShowRoot, toHotTrack,toShowTreeLines, toThemeAware]
       else PaintOptions := [toShowButtons,toShowRoot,toHotTrack,toShowTreeLines];
    MiscOptions := [toInitOnSave];
    Autooptions := [toAutoScroll];
    animationoptions := [];
   end;

    with header do begin
     Options := [hoDrag,hoRestrictDrag,hoVisible];
     style := hsFlatButtons;
     background := COLORE_LISTVIEWS_HEADERBK;
     font.name := ares_frmmain.font.name;
     font.size := ares_frmmain.font.size;
     font.color := COLORE_LISTVIEWS_HEADERFONT;
     background := COLORE_LISTVIEWS_HEADERBK;
     font.color := COLORE_LISTVIEWS_HEADERFONT;
     height := 21;
    end;


    for i := 0 to 9 do begin
    NewColumn := header.Columns.Add;
     with NewColumn do begin
      options := [];
      text := '';
      style := vstext;
      MaxWidth := 10000;
      Position := i;
      MinWidth := 0;
      spacing := 0;
      margin := 4;
      width := 0;
      style := vstext;
      layout := blglyphleft;
     end;
    end;
    NewColumn := header.Columns.Add;
     with NewColumn do begin
      options := [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible];
      text := '';
      style := vstext;
      MaxWidth := 10000;
      Position := 10;
      MinWidth := 0;
      spacing := 0;
      margin := 4;
      width := 0;
      style := vstext;
      layout := blglyphleft;
     end;
    //WideDefaultText := ' ';
 zero_header_search(listview);


 end;


end;

end;

result^.pnl := ares_frmmain.pagesrc.AddPanel(IDXSearch,'',[csDown],result^.containerPanel,result,true,-1);
ares_frmmain.pagesrc.tabsVisible := True;
src_panel_list.add(result);

end;

procedure zero_header_search(listview: Tcomettree);
var
i: Integer;
begin
with listview do begin
  for i := 0 to 10 do Header.Columns.items[i].options := [coEnabled,coParentBidiMode,coParentColor,coVisible];
  header.AutoSizeIndex := -1;

  with header.columns do begin
   for i := 0 to 9 do begin
    Items[i].MinWidth := 0;
    Items[i].width := 0;
    Items[i].text := '';
   end;
   Items[10].MinWidth := 0;
   Items[10].width := listview.width;
   Items[10].text := '';
  end;
  header.AutoSizeIndex := 10;
  end;

end;

procedure gui_start_search;
var
nodo:pCmtVnode;
datao:precord_search_result;
src:precord_panel_search;
search_string: string;
i: Integer;
begin
try

formhint_hide;

with ares_frmmain do begin


if ((radio_srcmime_all.checked) and (length(combo_search.text)<2)) then exit;

if not radio_srcmime_all.checked then begin
 if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
  if length(combo_search.text)<2 then exit;
 end else begin
  if radio_srcmime_audio.checked then begin //audio
   if ((length(combotitsearch.text)<2) and
       (length(comboautsearch.text)<2) and
       (length(comboalbsearch.text)<2) and
       (length(combocatsearch.text)<2) and
       (length(combodatesearch.text)<2) and
       ((combo_sel_duration.itemindex<1) or (combo_wanted_duration.itemindex<1)) and
       ((combo_sel_quality.itemindex<1) or (combo_wanted_quality.itemindex<1)) and
       ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end else
  if radio_srcmime_video.checked then begin // video
     if ((length(combotitsearch.text)<2) and
         (length(comboautsearch.text)<2) and
         (length(combocatsearch.text)<2) and
         (length(combodatesearch.text)<2) and
         (length(combo_lang_search.text)<2) and
         ((combo_sel_duration.itemindex<1) or (combo_wanted_duration.itemindex<1)) and
         ((combo_sel_quality.itemindex<1) or (combo_wanted_quality.itemindex<1)) and
         ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end else
  if radio_srcmime_image.checked then begin // image
     if ((length(combotitsearch.text)<2) and
         (length(comboautsearch.text)<2) and
         (length(comboalbsearch.text)<2) and
         (length(combocatsearch.text)<2) and
         (length(combodatesearch.text)<2) and
         ((combo_sel_quality.itemindex<1) or (combo_wanted_quality.itemindex<1)) and
         ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end else
  if radio_srcmime_document.checked then begin  //docs
     if ((length(combotitsearch.text)<2) and
         (length(comboautsearch.text)<2) and
         (length(combocatsearch.text)<2) and
         (length(combodatesearch.text)<2) and
         (length(combo_lang_search.text)<2) and
         ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end else
  if radio_srcmime_software.checked then begin   // soft
       if ((length(combotitsearch.text)<2) and
           (length(comboautsearch.text)<2) and
           (length(combocatsearch.text)<2) and
           (length(combodatesearch.text)<2) and
           (length(combo_lang_search.text)<2) and
           ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end else
    if radio_srcmime_other.checked then begin   // soft
       if ((length(combotitsearch.text)<2) and
           ((combo_sel_size.itemindex<1) or (combo_wanted_size.itemindex<1))) then exit;
  end;
 end;
end;

if radio_srcmime_all.checked then search_string := widestrtoutf8str(combo_search.text) else begin
 if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then search_string := widestrtoutf8str(combo_search.text) else begin
  if ares_frmmain.radio_srcmime_audio.checked then begin //audio extended
   search_string := widestrtoutf8str(combotitsearch.text+' '+comboautsearch.text+' '+comboalbsearch.text+' '+combocatsearch.text+' '+combodatesearch.text+' '+combo_lang_search.text);
  end else
  if radio_srcmime_video.checked then begin
     search_string := widestrtoutf8str(combotitsearch.text+' '+comboautsearch.text+' '+combocatsearch.text+' '+combodatesearch.text+' '+combo_lang_search.text);
  end else
  if radio_srcmime_image.checked then begin
     search_string := widestrtoutf8str(combotitsearch.text+' '+comboautsearch.text+' '+comboalbsearch.text+' '+combocatsearch.text+' '+combodatesearch.text);
  end else
  if radio_srcmime_document.checked then begin
     search_string := widestrtoutf8str(combotitsearch.text+' '+comboautsearch.text+' '+combocatsearch.text+' '+combodatesearch.text+' '+combo_lang_search.text);
  end else
  if radio_srcmime_software.checked then begin
     search_string := widestrtoutf8str(combotitsearch.text+' '+comboautsearch.text+' '+combocatsearch.text+' '+combodatesearch.text+' '+combo_lang_search.text);
  end else
  if radio_srcmime_other.checked then begin
     search_string := widestrtoutf8str(combotitsearch.text);
  end;
 end;
end;

while (pos('  ',search_string)<>0) do search_string := copy(search_string,1,pos('  ',search_string)-1)+copy(search_string,pos('  ',search_string)+1,length(search_string));
src := nil;
if ares_frmmain.pagesrc.activepage>0 then begin  //search again in the same tab
 for i := 0 to src_panel_list.count-1 do begin
  src := src_panel_list[i];
  if src^.containerPanel=pagesrc.activepanel then begin
    init_srcTab_vars(src,search_string);
    src^.listview.clear;
    zero_header_search(src^.listview);

  break;
  end;
 end;
end else src := gui_create_new_SRCtab(search_string);
  if src=nil then exit;
  src^.started := gettickcount;
  src^.pnl.btncaption := utf8strtowidestr(search_string);
  
  searchhistory_newitem_add;

  if length(search_string)<1 then search_string := GetLangStringA(STR_ANYTHING);
  src^.search_string := search_string;


  Btn_start_search.enabled := False;
  btn_stop_search.enabled := True;
  with src^.listview do begin
  clear;
   // if rootnodecount=0 then begin
     canbgcolor := False;
     Header.Options := [hoAutoResize,hoColumnResize,hoDrag,hoRestrictDrag,hoShowImages,hoVisible];
      nodo := addchild(nil);
       datao := getdata(nodo);
       with datao^ do begin
        hash_sha1 := '1234567';
        title := GetLangStringA(STR_SEARCHING_THE_NET);
        imageindex := 10000;
       end;
       invalidatenode(nodo);
       selectable := False;
   // end;
  end;

src^.lbl_src_status_caption := '0:00   '+GetLangStringW(STR_SEARCHING_FOR)+chr(32)+
                             utf8strtowidestr(search_string)+chr(44)+chr(32){', '}+
                             GetLangStringW(STR_PLEASE_WAIT);

lbl_src_status.caption := src^.lbl_src_status_caption;


 //tabsrc_defaultShow(src^.tabsheet);
 {if (not radio_srcmime_other.checked) and
    (not radio_srcmime_image.checked) and
    (vars_global.thread_webtorrent=nil) then begin
   vars_global.thread_webtorrent := tthread_webtorrent.create(false); 5-2-2014 on->28-3-2014 off
 end;}

 cambiato_search := True;
 
end;

except
end;
end;


procedure searchpanel_hide_togglemoreopt;
begin
with ares_frmmain do begin

  if ((radio_srcmime_all.checked) or (widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
 //  lbl_src_hint.visible := True;
   combo_search.visible := True;
   //panel_src_top.visible := (not radio_srcmime_other.checked);
  // if not panel_src_top.visible then begin
  // end else begin
  // end;
  end else begin
  // lbl_src_hint.visible := False;
   combo_search.visible := False;
  // panel_src_top.visible := False;
  end;

if ((radio_srcmime_all.checked) or (widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
 label_title_search.visible := False;
  combotitsearch.visible := False;
 label_auth_search.visible := False;
  comboautsearch.visible := False;
 label_cat_search.visible := False;
  combocatsearch.visible := False;
 label_album_search.visible := False;
  comboalbsearch.visible := False;
 label_date_search.visible := False;
  combodatesearch.visible := False;
 label_lang_search.visible := False;
  combo_lang_search.visible := False;
 label_sel_quality.visible := False;
  combo_sel_quality.visible := False;
  combo_wanted_quality.visible := False;
 label_sel_duration.visible := False;
  combo_sel_duration.visible := False;
  combo_wanted_duration.visible := False;
 label_sel_size.visible := False;
  combo_sel_size.visible := False;
  combo_wanted_size.visible := False;
  exit;
end;

if ((radio_srcmime_audio.checked) and (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //audio:  tit,auth,cat,album   date,quality,length,size, nascondiamo language
  label_auth_search.caption := GetLangStringW(STR_ARTIST);
  if not label_auth_search.visible then label_auth_search.visible := True;
  if not comboautsearch.visible then comboautsearch.visible := True;
  label_cat_search.caption := GetLangStringW(STR_GENRE);
  if not label_cat_search.visible then label_cat_search.visible := True;
  if not combocatsearch.visible then combocatsearch.visible := True;
  label_album_search.caption := GetLangStringW(STR_ALBUM);
  if not label_album_search.visible then label_album_search.visible := True;
  if not comboalbsearch.visible then comboalbsearch.visible := True;
  label_date_search.caption := GetLangStringW(STR_DATE);
  if not label_date_search.visible then label_date_search.visible := True;
  if not combodatesearch.visible then combodatesearch.visible := True;
  label_sel_quality.caption := GetLangStringW(STR_QUALITY);
  if not label_sel_quality.visible then label_sel_quality.visible := True;
  if not combo_sel_quality.visible then combo_sel_quality.visible := True;
  if not combo_wanted_quality.visible then combo_wanted_quality.visible := True;
  label_sel_duration.caption := GetLangStringW(STR_LENGTH);
  if not label_sel_duration.visible then label_sel_duration.visible := True;
  if not combo_sel_duration.visible then combo_sel_duration.visible := True;
  if not combo_wanted_duration.visible then combo_wanted_duration.visible := True;
  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.Visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;

   if label_lang_search.visible then label_lang_search.visible := False;
   if combo_lang_search.visible then combo_lang_search.visible := False;
end else
if ((radio_srcmime_video.checked) and (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //video:  tit,auth,cat,date,   lang,res,length,size nascondiamo album
  label_auth_search.caption := GetLangStringW(STR_AUTHOR);
  if not label_auth_search.visible then label_auth_search.visible := True;
  if not comboautsearch.visible then comboautsearch.visible := True;
  label_cat_search.caption := GetLangStringW(STR_CATEGORY);
  if not label_cat_search.visible then label_cat_search.visible := True;
  if not combocatsearch.visible then combocatsearch.visible := True;
  label_lang_search.caption := GetLangStringW(STR_LANGUAGE);
  if not label_lang_search.visible then label_lang_search.visible := True;
  if not combo_lang_search.visible then combo_lang_search.visible := True;
  label_date_search.caption := GetLangStringW(STR_DATE);
  if not label_date_search.visible then label_date_search.visible := True;
  if not combodatesearch.visible then combodatesearch.visible := True;
  label_sel_quality.caption := GetLangStringW(STR_RESOLUTION);
  if not label_sel_quality.visible then label_sel_quality.visible := True;
  if not combo_sel_quality.visible then combo_sel_quality.visible := True;
  if not combo_wanted_quality.visible then combo_wanted_quality.visible := True;
  label_sel_duration.caption := GetLangStringW(STR_LENGTH);
  if not label_sel_duration.visible then label_sel_duration.visible := True;
  if not combo_sel_duration.visible then combo_sel_duration.visible := True;
  if not combo_wanted_duration.visible then combo_wanted_duration.visible := True;
  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;

  if label_album_search.visible then label_album_search.visible := False;
  if comboalbsearch.visible then comboalbsearch.visible := False;
end else
if ((radio_srcmime_image.checked) and (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //image:  tit,auth,cat,album,  date,resol,size  nascondiamo language e duration
  label_auth_search.caption := GetLangStringW(STR_AUTHOR);

  label_album_search.caption := GetLangStringW(STR_ALBUM);
  if not label_auth_search.visible then label_auth_search.visible := True;
  if not comboautsearch.visible then comboautsearch.visible := True;
    label_cat_search.caption := GetLangStringW(STR_CATEGORY);
  if not label_cat_search.visible then label_cat_search.visible := True;
  if not combocatsearch.visible then combocatsearch.visible := True;
  label_date_search.caption := GetLangStringW(STR_DATE);
  if not label_date_search.visible then label_date_search.visible := True;
  if not combodatesearch.visible then combodatesearch.visible := True;
  label_sel_quality.caption := GetLangStringW(STR_RESOLUTION);
  if not label_sel_quality.visible then label_sel_quality.visible := True;
  if not combo_sel_quality.visible then combo_sel_quality.visible := True;
  if not combo_wanted_quality.visible then combo_wanted_quality.visible := True;
  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;
  if not label_album_search.visible then label_album_search.visible := True;
  if not comboalbsearch.visible then comboalbsearch.visible := True;

  if label_lang_search.visible then label_lang_search.visible := False;
  if combo_lang_search.visible then combo_lang_search.visible := False;
  if label_sel_duration.visible then label_sel_duration.visible := False;
  if combo_sel_duration.visible then combo_sel_duration.visible := False;
  if combo_wanted_duration.visible then combo_wanted_duration.visible := False;
end else
if ((radio_srcmime_document.checked) and (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //docs:   tit,auth,cat,date,   lang,size  nascondiamo duration,quality e album
  label_auth_search.caption := GetLangStringW(STR_AUTHOR);
  if not label_auth_search.visible then label_auth_search.visible := True;
  if not comboautsearch.visible then comboautsearch.visible := True;
    label_cat_search.caption := GetLangStringW(STR_CATEGORY);
  if not label_cat_search.visible then label_cat_search.visible := True;
  if not combocatsearch.visible then combocatsearch.visible := True;
  label_date_search.caption := GetLangStringW(STR_DATE);
  if not label_date_search.visible then label_date_search.visible := True;
  if not combodatesearch.visible then combodatesearch.visible := True;
  label_lang_search.caption := GetLangStringW(STR_LANGUAGE);
  if not label_lang_search.visible then label_lang_search.visible := True;
  if not combo_lang_search.visible then combo_lang_search.visible := True;
  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;

  if label_album_search.visible then label_album_search.visible := False;
  if comboalbsearch.visible then comboalbsearch.visible := False;
  if label_sel_quality.visible then label_sel_quality.visible := False;
  if combo_sel_quality.visible then combo_sel_quality.visible := False;
  if label_sel_duration.visible then label_sel_duration.visible := False;
  if combo_sel_duration.visible then combo_sel_duration.visible := False;
  if combo_wanted_quality.visible then combo_wanted_quality.visible := False;
  if combo_wanted_duration.visible then combo_wanted_duration.visible := False;
end else
if ((radio_srcmime_software.checked) and
    (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //soft:   tit,auth,cat,date,   lang,size  nascondiamo duration,quality e album
  label_auth_search.caption := GetLangStringW(STR_COMPANY);
  if not label_auth_search.visible then label_auth_search.visible := True;
  if not comboautsearch.visible then comboautsearch.visible := True;
    label_cat_search.caption := GetLangStringW(STR_CATEGORY);
  if not label_cat_search.visible then label_cat_search.visible := True;
  if not combocatsearch.visible then combocatsearch.visible := True;
  label_date_search.caption := GetLangStringW(STR_DATE);
  if not label_date_search.visible then label_date_search.visible := True;
  if not combodatesearch.visible then combodatesearch.visible := True;
  label_lang_search.caption := GetLangStringW(STR_LANGUAGE);
  if not label_lang_search.visible then label_lang_search.visible := True;
  if not combo_lang_search.visible then combo_lang_search.visible := True;

  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;

  if label_album_search.visible then label_album_search.visible := False;
  if comboalbsearch.visible then comboalbsearch.visible := False;
  if label_sel_quality.visible then label_sel_quality.visible := False;
  if combo_sel_quality.visible then combo_sel_quality.visible := False;
  if label_sel_duration.visible then label_sel_duration.visible := False;
  if combo_sel_duration.visible then combo_sel_duration.visible := False;
  if combo_wanted_quality.visible then combo_wanted_quality.visible := False;
  if combo_wanted_duration.visible then combo_wanted_duration.visible := False;
end else
if ((radio_srcmime_other.checked) and
    (widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR))) then begin
  label_title_search.caption := GetLangStringW(STR_TITLE);
  if not label_title_search.visible then label_title_search.visible := True;
  if not combotitsearch.visible then combotitsearch.visible := True;           //soft:   tit,auth,cat,date,   lang,size  nascondiamo duration,quality e album
  //label_auth_search.caption := utf8strtowidestr(STR_COMPANY);
  if label_auth_search.visible then label_auth_search.visible := False;
  if comboautsearch.visible then comboautsearch.visible := False;
   // label_cat_search.caption := utf8strtowidestr(STR_CATEGORY);
  if label_cat_search.visible then label_cat_search.visible := False;
  if combocatsearch.visible then combocatsearch.visible := False;
  //label_date_search.caption := utf8strtowidestr(STR_DATE);
  if label_date_search.visible then label_date_search.visible := False;
  if combodatesearch.visible then combodatesearch.visible := False;
 // label_lang_search.caption := utf8strtowidestr(STR_LANGUAGE);
  if label_lang_search.visible then label_lang_search.visible := False;
  if combo_lang_search.visible then combo_lang_search.visible := False;

  label_sel_size.caption := GetLangStringW(STR_SIZE);
  if not label_sel_size.visible then label_sel_size.visible := True;
  if not combo_sel_size.visible then combo_sel_size.visible := True;
  if not combo_wanted_size.visible then combo_wanted_size.visible := True;

  if label_album_search.visible then label_album_search.visible := False;
  if comboalbsearch.visible then comboalbsearch.visible := False;
  if label_sel_quality.visible then label_sel_quality.visible := False;
  if combo_sel_quality.visible then combo_sel_quality.visible := False;
  if label_sel_duration.visible then label_sel_duration.visible := False;
  if combo_sel_duration.visible then combo_sel_duration.visible := False;
  if combo_wanted_quality.visible then combo_wanted_quality.visible := False;
  if combo_wanted_duration.visible then combo_wanted_duration.visible := False;
end;


end;
end;


procedure mainGui_invalidate_searchpanel;
begin

//if ares_frmmain.top<>10000 then lockwindowupdate(ares_frmmain.handle);

 try

with ares_frmmain do begin
 radio_srcmime_all.visible := radio_srcmime_all.checked;
 radio_srcmime_audio.visible := radio_srcmime_all.checked;
 radio_srcmime_video.visible := radio_srcmime_all.checked;
 radio_srcmime_image.visible := radio_srcmime_all.checked;
 radio_srcmime_document.visible := radio_srcmime_all.checked;
 radio_srcmime_software.visible := radio_srcmime_all.checked;
 radio_srcmime_other.visible := radio_srcmime_all.checked;
 lbl_srcmime_all.visible := radio_srcmime_all.checked;
 lbl_srcmime_audio.visible := radio_srcmime_all.checked;
 lbl_srcmime_video.visible := radio_srcmime_all.checked;
 lbl_srcmime_image.visible := radio_srcmime_all.checked;
 lbl_srcmime_document.visible := radio_srcmime_all.checked;
 lbl_srcmime_software.visible := radio_srcmime_all.checked;
 lbl_srcmime_other.visible := radio_srcmime_all.checked;

 if radio_srcmime_all.checked then begin //mostriamo immagini
  searchpanel_invalidatemimeicon(0);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_GENERIC_MEDIA);
  end else
 if radio_srcmime_audio.checked then begin
   searchpanel_invalidatemimeicon(1);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_AUDIO_FILES);
 end else
 if radio_srcmime_video.checked then begin
  searchpanel_invalidatemimeicon(5);
 lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_VIDEO_FILES);
 end else
 if radio_srcmime_image.checked then begin
  searchpanel_invalidatemimeicon(7);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_IMAGE_FILES);
 end else
 if radio_srcmime_document.checked then begin
  searchpanel_invalidatemimeicon(6);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_DOCUMENTS);
 end else
  if radio_srcmime_software.checked then begin
   if vars_global.Check_opt_hlink_filterexe_checked then messageboxW(handle,pwidechar(GetLangStringW(STR_ARES_IS_CONFIGURED_TO_BLOCK_THIS)),pwidechar(appname+': '+GetLangStringW(STR_FILTERED_MEDIATYPE)),mb_ok+mb_iconinformation);
  searchpanel_invalidatemimeicon(3);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_SOFTWARES);
 end else
 if radio_srcmime_other.checked then begin
  searchpanel_invalidatemimeicon(8);
  lbl_capt_search.caption := GetLangStringW(STR_SEARCH_FOR_OTHERS);
 end;

 if radio_srcmime_all.checked then begin
  image_back_top := -1;
  image_more_top := -1;
  image_less_top := -1;
 end;
 label_more_searchopt.visible := not radio_srcmime_all.checked;
 label_back_src.visible := not radio_srcmime_all.checked;


  if radio_srcmime_all.checked then begin
   label_more_searchopt.caption := GetLangStringW(MORE_SEARCH_OPTION_STR); // al prox nascondiamo
  end;
end;

searchpanel_hide_togglemoreopt;
searchpanel_invalidate_moreopt;

searchpanel_add_histories;

ares_frmmain.panel_search.invalidate;
except
end;

//if ares_frmmain.top<>10000 then lockwindowupdate(0);

end;


procedure searchpanel_add_histories;
begin
with ares_frmmain do begin
 if radio_srcmime_all.checked then begin
   combo_add_history(combo_search,0,HISTORY_GENERAL);
   combo_search.visible := True;
  end else
  if radio_srcmime_audio.checked then begin
     if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
      combo_add_bitrates(combo_wanted_quality);
      if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
      combo_add_categories(combocatsearch,1);
      combo_add_history(combotitsearch,1,HISTORY_TITLE);
      combo_add_history(comboautsearch,1,HISTORY_AUTHOR);
      combo_add_history(comboalbsearch,1,HISTORY_ALBUM);
      combo_add_history(combodatesearch,1,HISTORY_DATE);
     end else begin//audio not advanced
      combo_add_history(combo_search,1,HISTORY_GENERAL);
     end;
  end else
  if radio_srcmime_video.checked then begin //video
   if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
    combo_add_resolutions(combo_wanted_quality);
    if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
    if combo_lang_search.items.count=0 then combo_add_languages(combo_lang_search);
    combo_add_categories(combocatsearch,5);
    combo_add_history(combotitsearch,5,HISTORY_TITLE);
    combo_add_history(comboautsearch,5,HISTORY_AUTHOR);
    combo_add_history(combodatesearch,5,HISTORY_DATE);
   end else begin
    combo_add_history(combo_search,5,HISTORY_GENERAL);
   end;
  end else
  if radio_srcmime_image.checked then begin  //image
   if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
     combo_add_resolutions(combo_wanted_quality);
     if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
     combo_add_categories(combocatsearch,7);
     combo_add_history(combotitsearch,7,HISTORY_TITLE);
     combo_add_history(comboautsearch,7,HISTORY_AUTHOR);
     combo_add_history(comboalbsearch,7,HISTORY_ALBUM);
     combo_add_history(combodatesearch,7,HISTORY_DATE);
   end else begin
        combo_add_history(combo_search,7,HISTORY_GENERAL);
   end;
  end else
  if radio_srcmime_document.checked then begin //document
   if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
    combo_add_categories(combocatsearch,6);
    if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
    if combo_lang_search.items.count=0 then combo_add_languages(combo_lang_search);
    combo_add_history(combotitsearch,6,HISTORY_TITLE);
    combo_add_history(comboautsearch,6,HISTORY_AUTHOR);
    combo_add_history(combodatesearch,6,HISTORY_DATE);
   end else begin
       combo_add_history(combo_search,6,HISTORY_GENERAL);
   end;
  end else
  if radio_srcmime_software.checked then begin  //software
      if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
       combo_add_categories(combocatsearch,3);
       if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
       if combo_lang_search.items.count=0 then combo_add_languages(combo_lang_search);
       combo_add_history(combotitsearch,3,HISTORY_TITLE);
       combo_add_history(comboautsearch,3,HISTORY_AUTHOR);
       combo_add_history(combodatesearch,3,HISTORY_DATE);
      end else begin
          combo_add_history(combo_search,3,HISTORY_GENERAL);
      end;
  end else
  if radio_srcmime_other.checked then begin  //software
      if widestrtoutf8str(label_more_searchopt.caption)<>GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
       if combo_wanted_size.items.count=0 then combo_add_size(combo_wanted_size);
       combo_add_history(combotitsearch,8,HISTORY_TITLE);
      end else begin
          combo_add_history(combo_search,8,HISTORY_GENERAL);
      end;
  end;
end;
end;


end.
