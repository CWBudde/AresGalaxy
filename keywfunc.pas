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
 misc functions to split and handle keywords and filelist serialization
}

unit keywfunc;

interface

uses
 Windows, Classes2, SysUtils,ares_types,ares_objects,const_ares,
 utility_ares,tntsysutils,class_cmdlist,comettrees,helper_unicode,
 helper_strings,helper_base64_32,helper_urls,const_commands,
 helper_visual_library,const_client;

  const
tabella_stripper: array [0..127] of widechar =
(' '{0}  ,' '{1}  ,' '{2}  ,' '{3}  ,' '{4}  ,' '{5}  ,' '{6}  ,' '{7}  ,' '{8}  ,' '{9}  ,' '{10},
          ' '{11} ,' '{12} ,' '{13} ,' '{14} ,' '{15} ,' '{16} ,' '{17} ,' '{18} ,' '{19} ,' '{20},
          ' '{21} ,' '{22} ,' '{23} ,' '{24} ,' '{25} ,' '{26} ,' '{27} ,' '{28} ,' '{29} ,' '{30},
          ' '{31} ,' '{32} ,' '{33} ,' '{34} ,' '{35} ,' '{36} ,' '{37} ,'&'{38} ,''''{39} ,' '{40},
          ' '{41} ,' '{42} ,' '{43} ,' '{44} ,' '{45} ,' '{46} ,' '{47} ,'0'{48} ,'1'{49} ,'2'{50},
          '3'{51} ,'4'{52} ,'5'{53} ,'6'{54} ,'7'{55} ,'8'{56} ,'9'{57} ,' '{58} ,' '{59} ,' '{60},
          ' '{61} ,' '{62} ,' '{63} ,' '{64} ,'a'{65} ,'b'{66} ,'c'{67} ,'d'{68} ,'e'{69} ,'f'{70},
          'g'{71} ,'h'{72} ,'i'{73} ,'j'{74} ,'k'{75} ,'l'{76} ,'m'{77} ,'n'{78} ,'o'{79} ,'p'{80},
          'q'{81} ,'r'{82} ,'s'{83} ,'t'{84} ,'u'{85} ,'v'{86} ,'w'{87} ,'x'{88} ,'y'{89} ,'z'{90},
          ' '{91} ,' '{92} ,' '{93} ,' '{94} ,' '{95} ,' '{96} ,'a'{97} ,'b'{98} ,'c'{99} ,'d'{100},
          'e'{101},'f'{102},'g'{103},'h'{104},'i'{105},'j'{106},'k'{107},'l'{108},'m'{109},'n'{110},
          'o'{111},'p'{112},'q'{113},'r'{114},'s'{115},'t'{116},'u'{117},'v'{118},'w'{119},'x'{120},
          'y'{121},'z'{122},' '{123},' '{124},' '{125},' '{126},' '{127}); //

         //,'c'{128},'u'{129},'e'{130},
         // 'a'{131},'a'{132},'a'{133},'a'{134},'c'{135},'e'{136},'e'{137},'e'{138},'i'{139},'i'{140},
         // 'i'{141},'a'{142},'a'{143},'e'{144},'e'{145},'e'{146},'o'{147},'o'{148},'o'{149},'u'{150},
         // 'u'{151},'y'{152},'o'{153},'u'{154},'c'{155},'l'{156},'y'{157},'p'{158},'f'{159},'a'{160},
         // 'i'{161},'o'{162},'u'{163},'n'{164},'n'{165},'a'{166},'o'{167},' '{168},' '{169},' '{170},
         // ' '{171},' '{172},' '{173},' '{174},' '{175},' '{176},' '{177},' '{178},' '{179},' '{180},
         // ' '{181},' '{182},' '{183},' '{184},' '{185},' '{186},' '{187},' '{188},' '{189},' '{190},
         // ' '{191},' '{192},' '{193},' '{194},' '{195},' '{196},' '{197},' '{198},' '{199},' '{200},
         // ' '{201},' '{202},' '{203},' '{204},' '{205},' '{206},' '{207},' '{208},' '{209},' '{210},
         // ' '{211},' '{212},' '{213},' '{214},' '{215},' '{216},' '{217},' '{218},' '{219},' '{220},
         // ' '{221},' '{222},' '{223},' '{224},' '{225},' '{226},' '{227},' '{228},' '{229},' '{230},
         // ' '{231},' '{232},' '{233},' '{234},' '{235},' '{236},' '{237},' '{238},' '{239},' '{240},
         // ' '{241},' '{242},' '{243},' '{244},' '{245},' '{246},' '{247},' '{248},' '{249},' '{250},
         // ' '{251},' '{252},' '{253},' '{254},' '{255});

  FIELD_TITLE              =0;
  FIELD_ARTIST             =1;
  FIELD_ALBUM              =2;
  FIELD_CATEGORY           =3;
  FIELD_DATE               =4;
  FIELD_LANGUAGE           =5;

  MAX_HASH_REQUESTS           = 15;
  MAX_KEYWORDS                = 10; //max 10 indexed keywords (before 12-7-2005 #2998+ used to be 8)
  MAX_KEYWORDS3               = 30;

 KEYWORD_LEN_MAX              = 20; // maximum length of keyword
 KEYWORD_LEN_MIN              = 2; // minimum length of keyword. should be '2' or more
 MAX_KEYWORDS_SEARCH          = 8; // maximum keywords in search query
 KEYWORDS_FIRST               = '0123456789abcdefghijklmnopqrstuvwxyz''&'; // list of characters that can be first item of keyword
 KEYWORDS_SEPARATORS          = #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0A#$0B#$0C#$0D#$0E#$0F+
                                #$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F+
                                #$20'"()*+,./:;<=>?[\]_`'; // list of whitespaces. keyword ends as soon as any of these characters is found.
                                                                 // this list and KEYWORDS_FIRST list CANNOT contain any same character
 KEYWORDS_NOINDEX             = -1; // unknown index in keywords list

type
 precord_field=^record_field;
 record_field=packed record
 field: Byte;
end;

type
  PWordsArray = ^TWordsArray;
  TWordsArray = array [0..(MAX_KEYWORDS*3)-1] of Pointer;

 function GetKeywordIndex(keyword: String): Integer;
 function GetKeywordIndex2(keyword: String): Integer;
 function get_sharedfile_serializedstr(list: Tnapcmdlist; pfile:precord_file_library): string;
 function get_keywordsstr(list: Tnapcmdlist; pfile:precord_file_library): string;
 function get_chatserver_sharestring(pfile:precord_file_library; include_paths: Boolean; treeview2: Tcomettree): string;
 function get_serialize_keywords_chatroom(pfile:precord_file_library): string;
 function SplitToKeywords(str: String; list: TNapCmdList; limit: Integer; clearList:boolean=true): Integer;
 function splittokeywords_searchultra(str: String; list: Tnapcmdlist; limit:integer): Integer;
 function SplitToKeywords3(str: String): string;
 function utf8str_to_ascii(strin: string): string;
 function widestr_to_ascii(strin: WideString): string;
 function serialize_sharedfile(naplist_helper: TNapCmdList; pfile:precord_file_library): string;
 function get_formatted_searchstr(search_id: Word; mime: Byte; isadvanced: Boolean;
                                  general, title, artist, album, genre, language, date: WideString;
                                  typsize: Integer;  size: Int64;  typparam1,param1,  typparam3,param3: Integer;
                                  DHTFormat:boolean = false): string;
 function get_search_packet(src:precord_panel_search; DHTFormat:boolean = false): string; // in synch da cambiato form1
 function getLongestSearchKeyword(src:precord_panel_search): string;


implementation

uses
 dhttypes,securehash,dhtconsts,vars_global,helper_mimetypes,helper_combos,
 dhtkeywords;

function getLongestSearchKeyword(src:precord_panel_search): string;
var
str,keyw: string;
maxLen: Integer;
list: TNapCmdList;
begin
result := '';

 with src^ do begin
  if ((mime_search=ARES_MIME_GUI_ALL) or
      (not is_advanced)) then str := trim(widestrtoutf8str(combo_search_text)) else begin
         case src^.mime_search of
          ARES_MIME_MP3:str := trim(widestrtoutf8str(combotitsearch_text+' '+comboautsearch_text+' '+comboalbsearch_text));
          ARES_MIME_VIDEO:str := trim(widestrtoutf8str(combotitsearch_text+' '+comboautsearch_text));
          ARES_MIME_IMAGE:str := trim(widestrtoutf8str(combotitsearch_text+' '+comboautsearch_text+' '+comboalbsearch_text));
          ARES_MIME_SOFTWARE:str := trim(widestrtoutf8str(combotitsearch_text+' '+comboautsearch_text));
          ARES_MIME_DOCUMENT:str := trim(widestrtoutf8str(combotitsearch_text+' '+comboautsearch_text))
           else str := trim(widestrtoutf8str(combotitsearch_text));
         end;
    end;
 end;

 // extract keywords in list
 list := TNapCmdList.create;
 SplitToKeywords(str+' ',list,MAX_KEYWORDS,false);

 maxLen := 0;
 while (list.count>0) do begin
  keyw := list.Str(0);
        list.delete(0);
   if length(keyw)>maxLen then begin
    Result := keyw;
    maxLen := length(keyw);
   end;
 end;

 list.Free;
end;

function get_search_packet(src:precord_panel_search; DHTFormat:boolean = false): string; // in synch da cambiato form1
begin
try

result := '';


with src^ do begin

 case mime_search of

 ARES_MIME_GUI_ALL:begin  //generic
    Result := get_formatted_searchstr(src^.searchID,ARES_MIMECLTSRC_ALL,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
   end;

 ARES_MIME_MP3:begin  //audio search
     if not is_advanced then begin
        Result := get_formatted_searchstr(src^.searchID,ARES_MIME_MP3,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
     end else begin     //ricerca advanced
       Result := get_formatted_searchstr(src^.searchID,ARES_MIME_MP3,true,'',
                                                                combotitsearch_text,
                                                                comboautsearch_text,
                                                                comboalbsearch_text,
                                                                combocatsearch_text,
                                                                '',
                                                                combodatesearch_text,
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                combo_sel_quality_index,combo_index_to_bitrate(combo_wanted_quality_index),
                                                                combo_sel_duration_index,combo_index_to_duration(combo_wanted_duration_index),
                                                                DHTFormat);
     
     end;
 end;

 ARES_MIME_VIDEO:begin  //video
       if not is_advanced then begin
           Result := get_formatted_searchstr(src^.searchID,ARES_MIME_VIDEO,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
     end else begin
       Result := get_formatted_searchstr(src^.searchID,ARES_MIME_VIDEO,true,'',
                                                                combotitsearch_text,
                                                                comboautsearch_text,
                                                                '',
                                                                combocatsearch_text,
                                                                combo_lang_search_text,
                                                                combodatesearch_text,
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                combo_sel_quality_index,combo_index_to_resolution(combo_wanted_quality_index),
                                                                combo_sel_duration_index,combo_index_to_duration(combo_wanted_duration_index),
                                                                DHTFormat);


     end;
 end;

 ARES_MIME_IMAGE:begin  //image
    if not is_advanced then begin
         Result := get_formatted_searchstr(src^.searchID,ARES_MIME_IMAGE,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
    end else begin
       Result := get_formatted_searchstr(src^.searchID,ARES_MIME_IMAGE,true,'',
                                                                combotitsearch_text,
                                                                comboautsearch_text,
                                                                comboalbsearch_text,
                                                                combocatsearch_text,
                                                                '',
                                                                combodatesearch_text,
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                combo_sel_quality_index,combo_index_to_resolution(combo_wanted_quality_index),
                                                                -1,-1,
                                                                DHTFormat);

   end;
 end;

 ARES_MIME_SOFTWARE:begin   //software
       if not is_advanced then begin
           Result := get_formatted_searchstr(src^.searchID,ARES_MIME_SOFTWARE,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
     end else begin
       Result := get_formatted_searchstr(src^.searchID,ARES_MIME_SOFTWARE,true,'',
                                                                combotitsearch_text,
                                                                comboautsearch_text,
                                                                '',
                                                                combocatsearch_text,
                                                                combo_lang_search_text,
                                                                combodatesearch_text,
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                -1,-1,
                                                                -1,-1,
                                                                DHTFormat);

     end;
 end;

 ARES_MIME_DOCUMENT:begin   //documents
    if not is_advanced then begin
         Result := get_formatted_searchstr(src^.searchID,ARES_MIME_DOCUMENT,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
    end else begin
       Result := get_formatted_searchstr(src^.searchID,ARES_MIME_DOCUMENT,true,'',
                                                                combotitsearch_text,
                                                                comboautsearch_text,
                                                                '',
                                                                combocatsearch_text,
                                                                combo_lang_search_text,
                                                                combodatesearch_text,
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                -1,-1,
                                                                -1,-1,
                                                                DHTFormat);

     end;
 end else begin      //others
     if not is_advanced then begin
         Result := get_formatted_searchstr(src^.searchID,ARES_MIMESRC_OTHER,false,combo_search_text,'','','','','','',-1,-1,-1,-1,-1,-1);
    end else begin
       Result := get_formatted_searchstr(src^.searchID,ARES_MIMESRC_OTHER,true,'',
                                                                combotitsearch_text,
                                                                '',
                                                                '',
                                                                '',
                                                                '',
                                                                '',
                                                                combo_sel_size_index,combo_index_to_size(combo_wanted_size_index),
                                                                -1,-1,
                                                                -1,-1,
                                                                DHTFormat);

     end;
 end;
end;

end;



except
end;
end;

function serialize_sharedfile(naplist_helper: TNapCmdList; pfile:precord_file_library): string;
var
str_file: string;
begin

   str_file := keywfunc.get_sharedfile_serializedstr(naplist_helper,pfile);
     if length(str_file)<500 then begin
        Result := int_2_word_string(length(str_file))+
                               chr(MSG_CLIENT_ADD_CRCSHARE_KEY)+
                               str_file;
     end else Result := '';

end;

function get_formatted_searchstr(search_id: Word; mime: Byte; isadvanced: Boolean;
                                 general, title, artist, album, genre, language, date: WideString;
                                 typsize: Integer; size: Int64; typparam1,param1,  typparam3,param3: Integer;
                                 DHTFormat:boolean = false): string;
var
str,keyword: string;
list: TNapCmdList;
i: Integer;
begin


if ((isadvanced) and (not DHTFORMAT)) then begin  // to prevent bug in supernode parse complex_str before 2005-10-05
 Result := chr(mime)+
         chr(1)+
         int_2_word_string(search_id);
    if length(title)>1 then Result := result+chr(1)+widestr_to_ascii(title)+CHRNULL;
    if length(artist)>1 then Result := result+chr(2)+widestr_to_ascii(artist)+CHRNULL;
    if length(album)>1 then Result := result+chr(3)+widestr_to_ascii(album)+CHRNULL;
    if length(genre)>1 then Result := result+chr(4)+widestr_to_ascii(genre)+CHRNULL;
    if length(date)>1 then Result := result+chr(5)+widestr_to_ascii(date)+CHRNULL;
    if length(language)>1 then Result := result+chr(6)+widestr_to_ascii(language)+CHRNULL;
     if (((typsize>0) and (size<>-1)) or
         ((typparam1>0) and (param1<>-1)) or
         ((typparam3>0) and (param3<>-1))) then begin  //complex
       Result := result+chr(7);
       if ((typsize>0) and (size<>-1)) then Result := result+chr(typsize)+int_2_dword_string(size);
       if ((typparam3>0) and (param3<>-1)) then Result := result+chr(typparam3+9)+int_2_dword_string(param3);
       if ((typparam1>0) and (param1<>-1)) then Result := result+chr(typparam1+3)+int_2_word_string(param1)+CHRNULL+CHRNULL;
     end;

exit;
end;


 Result := chr(mime)+
         chr(15)+
         int_2_word_string(search_id); //high speed!?

list := TNapCmdList.create;
 if not isadvanced then begin

   if length(general)>1 then begin
     str := widestr_to_ascii(general);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(20)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end else
    if length(title)>1 then begin
      str := widestr_to_ascii(title);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(1)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end else begin
       str := widestr_to_ascii(artist);
       SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(2)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end;

 end else begin  //advanced

    if length(title)>1 then begin
      str := widestr_to_ascii(title);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(1)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end;
    if length(artist)>1 then begin
      list.clear;
      str := widestr_to_ascii(artist);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(2)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end;
    if length(album)>1 then begin
      list.clear;
      str := widestr_to_ascii(album);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(3)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end;
    if length(genre)>1 then begin
      list.clear;
      str := widestr_to_ascii(genre);
      SplitToKeywords(str+' ',list,MAX_KEYWORDS,true);
        for i := 0 to list.count-1 do begin
         keyword := list.str(i);
           Result := result+chr(4)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
        end;
    end;
    if length(date)>1 then begin
         str := widestr_to_ascii(date);
         keyword := SplitToKeywords3(str+' ');
           Result := result+chr(5)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
    end;
    if length(language)>1 then begin
         str := widestr_to_ascii(language);
         keyword := SplitToKeywords3(str+' ');
           Result := result+chr(6)+
                          chr(length(keyword))+
                          int_2_word_string(whl(keyword))+
                          keyword;
    end;
     if (((typsize>0) and (size<>-1)) or
         ((typparam1>0) and (param1<>-1)) or
         ((typparam3>0) and (param3<>-1))) then begin  //complex
       str := '';
       if ((typsize>0) and (size<>-1)) then begin
        if DHTFormat then str := str+chr(typsize)+int_2_Qword_string(size)
         else str := str+chr(typsize)+int_2_dword_string(size);
       end;

       if ((typparam3>0) and (param3<>-1)) then str := str+chr(typparam3+9)+int_2_dword_string(param3);
       if ((typparam1>0) and (param1<>-1)) then str := str+chr(typparam1+3)+int_2_word_string(param1)
                                                                          +CHRNULL+CHRNULL; // 2 NULL bytes added to fix bug in supernode's parse code (in case of 2 byte bitrate field)

       Result := result+chr(7)+
                      chr(length(str))+
                      str;
     end;
 end;

list.Free;
end;

function widestr_to_ascii(strin: WideString): string;
var
i: Integer;
begin
result := '';

for i := 1 to length(strin) do if integer(strin[i])<=127 then strin[i] := tabella_stripper[integer(strin[i])];

i := 1;
while (i<length(strin)) do begin
 if strin[i]=' ' then
  if strin[i+1]=' ' then begin
   strin := copy(strin,1,i)+copy(strin,i+2,length(strin));
   continue;
  end;

 inc(i);
end;

for i := 1 to length(strin) do if strin[i]<>' ' then begin //trim left
 strin := copy(strin,i,length(strin));
 break;
end;

for i := length(strin) downto 1 do if strin[i]<>' ' then begin //trim right
 strin := copy(strin,1,i);
 break;
end;

result := widestrtoutf8str(strin);
end;

function utf8str_to_ascii(strin: string): string;
var
widestr: WideString;
i: Integer;
begin
widestr := utf8strtowidestr(strin);

result := '';

for i := 1 to length(widestr) do if integer(widestr[i])<=127 then widestr[i] := tabella_stripper[integer(widestr[i])];

i := 1;
while (i<length(widestr)) do begin //togliamo doppi spazi
 if widestr[i]=' ' then
  if widestr[i+1]=' ' then begin
   widestr := copy(widestr,1,i)+copy(widestr,i+2,length(widestr));
   continue;
  end;

 inc(i);
end;

for i := 1 to length(widestr) do if widestr[i]<>' ' then begin //trim left
 widestr := copy(widestr,i,length(widestr));
 break;
end;

for i := length(widestr) downto 1 do if widestr[i]<>' ' then begin //trim right
 widestr := copy(widestr,1,i);
 break;
end;

result := widestrtoutf8str(widestr);

end;

function SplitToKeywords3(str: String): string;
var
 i, start, count: Integer;
 spacing: Boolean;
 c: Char;
 item: String;
begin // extract up to $limit keywords from string and add it to list with CRC
 // before calling this function you should add ' ' at the end of string or you might loose your last keyword
 Result := '';
 spacing := True;
 start := 0;

 for i := 1 to Length(str) do begin
   c := str[i];
   if spacing then begin // searching for beginning of keyword
     if pos(c,KEYWORDS_FIRST)>0 then begin
       start := i;
       spacing := False;
     end;
   end else begin // searching for end of keyword
     if pos(c,KEYWORDS_SEPARATORS)>0 then begin
       spacing := True;
       count := i-start;
       if count>=KEYWORD_LEN_MIN then begin
         if count>KEYWORD_LEN_MAX then count := KEYWORD_LEN_MAX;
         item := Copy(str,start,count);
         repeat
          if length(item)<KEYWORD_LEN_MIN then break;
          if pos(item[length(item)],KEYWORDS_FIRST)>0 then break;
          delete(item,length(item),1);
          until (not true);
          if length(item)<KEYWORD_LEN_MIN then continue;
         Result := item;
         break;
       end;
     end;
   end;
 end;
end;


function splittokeywords_searchultra(str: String; list: Tnapcmdlist; limit:integer): Integer;
var
 i, start, count: Integer;
 spacing: Boolean;
 c: Char;
 item: String;
 crc: Word;
begin // extract up to $limit keywords from string and add it to list with CRC
 // before calling this function you should add ' ' at the end of string or you might loose your last keyword
 list.clear;
 start := 0;
 Result := 0;
 spacing := True;
 for i := 1 to Length(str) do begin
   c := str[i];
   if spacing then begin // searching for beginning of keyword
     if pos(c,KEYWORDS_FIRST)>0 then begin
       start := i;
       spacing := False;
     end;
   end else begin // searching for end of keyword
     if pos(c,KEYWORDS_SEPARATORS)>0 then begin
       spacing := True;
       count := i-start;
       if count>=KEYWORD_LEN_MIN then begin
         if count>KEYWORD_LEN_MAX then count := KEYWORD_LEN_MAX;
         item := Copy(str,start,count);
         repeat
          if length(item)<KEYWORD_LEN_MIN then break;
          if pos(item[length(item)],KEYWORDS_FIRST)>0 then break;
          delete(item,length(item),1);
          until (not true);
          if length(item)<KEYWORD_LEN_MIN then continue;
           crc := whl(item); //da 2941 usiamo whl!
         if list.FindItem(crc,item)=-1 then begin
           list.AddCmd(crc,item);
           inc(result);
           if result>=limit then exit;
         end;
       end;
     end;
   end;
 end;
end;


function SplitToKeywords(str: String; list: TNapCmdList; limit: Integer; clearList:boolean=true): Integer;
var
 i, start, count,  crc: Integer;
 spacing: Boolean;
 c: Char;
 item: String;
begin // extract up to $limit keywords from string and add it to list with CRC
 // before calling this function you should add ' ' at the end of string or you might loose your last keyword
 if clearList then list.clear;

 start := 0;
 Result := 0;
 spacing := True;
 for i := 1 to Length(str) do begin
   c := str[i];
   if spacing then begin // searching for beginning of keyword
     if pos(c,KEYWORDS_FIRST)>0 then begin
       start := i;
       spacing := False;
     end;
   end else begin // searching for end of keyword
     if pos(c,KEYWORDS_SEPARATORS)>0 then begin
       spacing := True;
       count := i-start;
       if count>=KEYWORD_LEN_MIN then begin
         if count>KEYWORD_LEN_MAX then count := KEYWORD_LEN_MAX;
         item := Copy(str,start,count);
         repeat
          if length(item)<KEYWORD_LEN_MIN then break;
          if pos(item[length(item)],KEYWORDS_FIRST)>0 then break;
          delete(item,length(item),1);
          until (not true);
          if length(item)<KEYWORD_LEN_MIN then continue;
         crc := StringCRC(item,false);
         if list.FindItem(crc,item)=-1 then begin
           if not DHT_is_popularKeywords(item) then begin
            list.AddCmd(crc,item);
            inc(result);
            if result>=limit then exit;
           end;
         end;
       end;
     end;
   end;
 end;
end;


function get_keywordsstr(list: Tnapcmdlist; pfile:precord_file_library): string;
var
str,str1,strazz: string;
i,j: Integer;
title,artist,album,category,language,year: string;
begin
str := '';
j := MAX_KEYWORDS;

if length(pfile^.title)>1 then begin
title := utf8str_to_ascii(pfile^.title);
if splittokeywords(title+' ',list,j,true)>0 then begin //title
 for i := 0 to list.count-1 do begin
   strazz := list.str(i);
      dec(j);
      str := str+chr(1)+
               int_2_word_string(whl(strazz))+
               chr(length(strazz))+
               strazz;

     if j<=0 then begin
       Result := int_2_word_string(length(str))+
               str;
       exit;
     end;
 end;
end;
end;

if pfile^.amime=0 then begin
 Result := int_2_word_string(length(str))+
         str;
         exit;
end;

if length(pfile^.artist)>1 then begin
 artist := utf8str_to_ascii(pfile^.artist);
 if splittokeywords(artist+' ',list,j,true)>0 then begin  //artist
   for i := 0 to list.count-1 do begin
     strazz := list.str(i);
           dec(j);
             str := str+chr(2)+
                  int_2_word_string(whl(strazz))+
                  chr(length(strazz))+
                  strazz;

       if j<=0 then begin
          Result := int_2_word_string(length(str))+
          str;
          exit;
       end;
   end;
 end;
end;


if ((pfile^.amime=1) or (pfile^.amime=7) or (pfile^.amime=3)) then begin  //audio,image,exe
if length(pfile^.album)>1 then begin
 album := utf8str_to_ascii(pfile^.album);
 if splittokeywords(album+' ',list,j,true)>0 then begin
   for i := 0 to list.count-1 do begin
       strazz := list.str(i);
                dec(j);
                   str := str+chr(3)+
                        int_2_word_string(whl(strazz))+
                        chr(length(strazz))+
                        strazz;

         if j<=0 then begin
          Result := int_2_word_string(length(str))+
          str;
          exit;
        end;
   end;
end;
end;
end;

if length(pfile^.category)>1 then begin
 category := utf8str_to_ascii(pfile^.category);
 if splittokeywords(category+' ',list,j,true)>0 then begin  //category
    for i := 0 to list.count-1 do begin
        strazz := list.str(i);
             dec(j);
               str := str+chr(4)+
                        int_2_word_string(whl(strazz))+
                        chr(length(strazz))+
                        strazz;
              if j<=0 then begin
                Result := int_2_word_string(length(str))+
                str;
                exit;
              end;
    end;
 end;
end;


if ((pfile^.amime<>1) and (pfile^.amime<>7)) then begin
if length(pfile^.language)>1 then begin
 language := utf8str_to_ascii(pfile^.language);
 str1 := splittokeywords3(language+' ');  //language
   if length(str1)>1 then begin
            dec(j);
              str := str+chr(5)+
                       int_2_word_string(whl(str1))+
                       chr(length(str1))+
                       str1;

                 if j<=0 then begin
                  Result := int_2_word_string(length(str))+
                  str;
                  exit;
                 end;
   end;
end;
end;

if length(pfile^.year)>1 then begin
 year := utf8str_to_ascii(pfile^.year);
 str1 := splittokeywords3(year+' ');
    if length(str1)>1 then begin
           str := str+chr(6)+
                    int_2_word_string(whl(str1))+
                    chr(length(str1))+
                    str1;
   end;
end;

result := int_2_word_string(length(str))+
        str;

end;

function get_serialize_keywords_chatroom(pfile:precord_file_library): string;
var
strwide: WideString;
i,inizio: Integer;
path: string;
begin

path := copy(pfile^.path,1,length(pfile^.path)-length(pfile^.ext));
strwide := extract_fnameW(utf8strtowidestr(path));


 i := 1;
 while (i<length(strwide)) do begin
      if integer(strwide[i])=32 then
       if integer(strwide[i+1])=32 then begin
        delete(strwide,i,1);
        i := 0;
       end;
      inc(i);
 end;

 strwide := Tnt_WideLowerCase(strwide);


 if length(strwide)>0 then
  if integer(strwide[length(strwide)])=32 then delete(strwide,length(strwide),1);
 if length(strwide)>0 then
  if integer(strwide[1])=32 then delete(strwide,1,1);

  Result := '';
  strwide := strwide+' ';
  inizio := -1;
  for i := 1 to length(strwide) do begin
     if inizio=-1 then begin
      if integer(strwide[i])<>32 then inizio := i;
     end else begin
       if integer(strwide[i])=32 then begin
        Result := result+widestrtoutf8str(copy(strwide,inizio,i-inizio))+CHRNULL;
        inizio := -1;
       end;
     end;
  end;
end;

function get_chatserver_sharestring(pfile:precord_file_library; include_paths: Boolean; treeview2: Tcomettree): string;
begin
end;


function get_sharedfile_serializedstr(list: Tnapcmdlist; pfile:precord_file_library): string;
var
size32: Cardinal;
begin
try
result := get_keywordsstr(list,pfile);

 if pfile^.fsize>LIMIT_INTEGER then size32 := LIMIT_INTEGER-1 // standard per favorire ricerche per size
  else size32 := pfile^.fsize;

result := result+int_2_dword_string(pfile^.param1)+
        int_2_dword_string(pfile^.param2)+
        int_2_dword_string(pfile^.param3)+
        chr(pfile^.amime)+
        int_2_dword_string(size32)+
        pfile^.hash_sha1+
        pfile^.ext+CHRNULL+
        chr(CLIENT_RESULT_KEY1)+pfile^.title+CHRNULL;

if length(pfile^.artist)>1 then Result := result+chr(CLIENT_RESULT_KEY2)+pfile^.artist+CHRNULL;

 if ((pfile^.amime=1) or (pfile^.amime=7)) then begin
   if length(pfile^.album)>1 then Result := result+chr(CLIENT_RESULT_KEY3)+pfile^.album+CHRNULL;
 end else begin
   if length(pfile^.category)>1 then Result := result+chr(CLIENT_RESULT_KEY3)+pfile^.category+CHRNULL;
 end;


 Result := result+chr(CLIENT_RESULT_KEYEXT);
 if pfile^.amime=1 then Result := result+int_2_word_string(pfile^.param1)+
                                      int_2_dword_string(pfile^.param3) else
 if ((pfile^.amime=5) or (pfile^.amime=7)) then Result := result+int_2_word_string(pfile^.param1)+
                                                             int_2_word_string(pfile^.param2)+
                                                             int_2_dword_string(pfile^.param3);

 if ((pfile^.amime=1) or (pfile^.amime=7)) then begin
  if length(pfile^.category)>1 then Result := result+chr(CLIENT_RESULT_CATEGORY)+pfile^.category+CHRNULL;
 end else begin
  if length(pfile^.album)>1 then Result := result+chr(CLIENT_RESULT_ALBUM)+pfile^.album+CHRNULL;
 end;

if length(pfile^.language)>1 then Result := result+chr(CLIENT_RESULT_LANGUAGE)+pfile^.language+CHRNULL;
if length(pfile^.year)>1 then Result := result+chr(CLIENT_RESULT_YEAR)+pfile^.year+CHRNULL;
if length(pfile^.comment)>1 then Result := result+chr(CLIENT_RESULT_COMMENTS)+pfile^.comment+CHRNULL;
if length(pfile^.url)>1 then Result := result+chr(CLIENT_RESULT_URL)+pfile^.url+CHRNULL;
if ((pfile^.amime=1) and (length(pfile^.keywords_genre)>=2)) then Result := result+chr(CLIENT_RESULT_KEYWORD_GENRE)+pfile^.keywords_genre+CHRNULL;

   Result := result+chr(CLIENT_RESULT_FILENAME)+widestrtoutf8str(extract_fnameW(utf8strtowidestr(pfile^.path)))+CHRNULL;

   if pfile^.fsize>LIMIT_INTEGER then Result := result+chr(CLIENT_RESULT_INT64SIZE)+inttostr(pfile^.fsize)+CHRNULL; //2951+ 5-1-2004

   if length(pfile^.hash_of_phash)=20 then begin
    Result := result+chr(CLIENT_RESULT_HASHOFPHASH)+encodeBase64(pfile^.hash_of_phash)+CHRNULL;
   end;
except
end;
end;





function GetKeywordIndex(keyword: String): Integer; //first letter
// returns index of keyword or -1 if keyword is invalid
begin
 if Length(keyword)<2 then Result := KEYWORDS_NOINDEX
 else Result := pos(keyword[1],KEYWORDS_FIRST)-1;
end;

function GetKeywordIndex2(keyword: String): Integer; //last letter
// returns index of keyword or -1 if keyword is invalid
begin
 if Length(keyword)<2 then Result := KEYWORDS_NOINDEX
 else Result := pos(keyword[length(keyword)],KEYWORDS_FIRST)-1;
end;


end.
