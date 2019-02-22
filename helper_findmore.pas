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
audio->find more of the same artist/genre, prepare search panel and start new search
}

unit helper_findmore;

interface

uses
ares_types,comettrees;

procedure mainGui_findartist_frombrowse;
procedure mainGui_findgenre_frombrowse;
procedure searchpanel_setfindmore_gen(genre: string);
procedure searchpanel_setfindmore_art(artist: string);


implementation

uses
 ufrmmain,helper_search_gui,vars_global,helper_unicode,vars_localiz,
 const_ares,cometpageview;


procedure searchpanel_setfindmore_gen(genre: string);
begin
with ares_frmmain do begin
 if not radio_srcmime_audio.checked then begin
  radio_srcmime_all.checked := False;
  radio_srcmime_audio.checked := True;
  radio_srcmime_video.checked := False;
  radio_srcmime_image.checked := False;
  radio_srcmime_document.checked := False;
  radio_srcmime_software.checked := False;
ufrmmain.ares_frmmain.radiosearchmimeClick(nil);
end;

if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then ufrmmain.ares_frmmain.label_more_searchoptClick(nil);

 combotitsearch.text := '';
 comboautsearch.text := '';
 combocatsearch.text := utf8strtowidestr(genre);

 combodatesearch.text := '';
 combo_lang_search.itemindex := 0;
 combo_sel_duration.itemindex := 0;
 combo_sel_quality.itemindex := 0;
 combo_sel_size.itemindex := 0;
end;

ufrmmain.ares_frmmain.Btn_start_searchclick(nil);
end;


procedure searchpanel_setfindmore_art(artist: string);
begin
with ares_frmmain do begin
 if not radio_srcmime_audio.checked then begin
  radio_srcmime_all.checked := False;
  radio_srcmime_audio.checked := True;
  radio_srcmime_video.checked := False;
  radio_srcmime_image.checked := False;
  radio_srcmime_document.checked := False;
  radio_srcmime_software.checked := False;
 ufrmmain.ares_frmmain.RadiosearchmimeClick(nil);
 end;

if widestrtoutf8str(label_more_searchopt.caption)=GetLangStringA(MORE_SEARCH_OPTION_STR) then ufrmmain.ares_frmmain.label_more_searchoptClick(nil);


 combotitsearch.text := '';
 comboautsearch.text := utf8strtowidestr(artist);
 combocatsearch.text := '';

 combodatesearch.text := '';
 combo_lang_search.itemindex := 0;
 combo_sel_duration.itemindex := 0;
 combo_sel_quality.itemindex := 0;
 combo_sel_size.itemindex := 0;
end;

ufrmmain.ares_frmmain.Btn_start_searchclick(nil);
end;

procedure mainGui_findgenre_frombrowse;
begin
end;

procedure mainGui_findartist_frombrowse;
begin
end;

end.
