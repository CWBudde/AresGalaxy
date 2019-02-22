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
obtain list of available channels(client) and add/update and entry in it(server)

20 Nov 08 channellist is now shared among chatrooms using UDP protocol

}


unit helper_channellist;

interface

uses
  Classes,utility_ares,zlib,windows,const_ares,
  blcksock,sysutils,ares_types,comettrees,winsock,
  synsock,classes2,registry,tntwindows,math,cometPageView,
  graphics,controls,extctrls,const_win_messages,forms;

const
  OP_SERVERLIST_SENDINFO=2;
  OP_SERVERLIST_ACKINFO=3;
  OP_SERVERLIST_SENDNODES=21;
  OP_SERVERLIST_ACKNODES=22;
  MAX_SERVERS_TO_SCAN=5000;
  MAX_SAVED_SERVERS=400;

type
precord_server_list=^record_server_list;
record_server_list=record
 ipC: Cardinal;
 portW: Word;
 acked,onfile: Boolean;
 score: Word;
end;

type
 tthread_udp_channellist = class(tthread)
 protected
  UDP_socket:Hsocket;
  UDP_Buffer: array [0..9999] of Byte;
  UDP_RemoteSin: TVarSin;
  UDP_len_recvd: Integer;
  serverIPlist: TMylist;
    ipC: Cardinal;
    portW,statusW: Word;
    chname,topic,languageS: string;
    stripped_topic: WideString;
    has_colors_intopic: Boolean;
    buildNo: Word;
    filtered_strings: TMyStringList;
    has_prepared_first: Boolean;
    index_scan: Integer;
    listReached: TMylist;
    UDP_len_tosend: Integer;
    shouldRefreshSupernodes: Boolean;
    countRecvdSupernodes: Integer;
  procedure createListener;
  procedure execute; override;
  procedure UDP_Receive;
  procedure loadIPs;
  procedure handler_channel_info;
  procedure handler_suggested_supernodes;
  procedure putsessionStopAsking; //sync
  procedure add_channel; //synch
  procedure GUI_searching;
  procedure checkShouldRefreshSupernodes; //synch through GUI_Searching
  procedure WriteChannelsToDisk;
  procedure prepare_header; //synch
  procedure endSearch;  //synch
  procedure finalizeIPs;
  procedure parse_alt_servers(index: Integer; numEntries:integer);
  procedure readOwnConf;
  procedure add_2_reached_servers;
 end;

  function chat_status_toImgindex(status:word):double;
  procedure clear_chanlist_backup;
  procedure mainGui_trigger_channelfilter;
  procedure export_channellist;
  procedure export_channel_hashlink;
  function channel_to_arlnk(chan:precord_displayed_channel; plaintext:boolean=false): string;
  procedure join_arlnk_chat(serialized: string; isPlaintext:boolean=false);
  procedure join_channel(datas:precord_displayed_channel);
  function fav_channel_to_arlnk(chan:precord_chat_favorite; plaintext:boolean=false): string;
  procedure export_favorite_channel_hashlink; //export single channel hashlink
  function add_channel(ip: Cardinal; port: Word; const language: string; status: Word; const chname,topic: string;
  stripped_topic: WideString; has_colors_intopic: Boolean; addBackup:boolean=true; checkFilter:boolean=true; killduplicates:boolean=true; buildNo:word=0): Boolean;

  procedure add_channel_fromreg;
  procedure ChatListPutStats;
  function channellist_find_root(ip: Cardinal; var Oldchildnode:pcmtvnode):pcmtvnode;
  function checkChatUserFilter(split_string: TMyStringList; const matchStr: string): Boolean;
  function chatlist_getrealcount: Integer;
  procedure add_mandatory_channels;
  procedure strip_tags_from_name(var sname: string; var stopic: string);
  function chatLanguageByteToStr(const langByte: Byte): string;
  function strip_color_string(const text: WideString; var stripped:boolean): WideString;
  procedure canvas_draw_topic(ACanvas: TCanvas; cellrect: TRect; imglist: Timagelist; widestr: WideString; forecolor,backcolor,forecolor_gen,backcolor_gen: TColor; offsetxiniz:integer);
  function emoticonstr_to_index(const str: string; var lung:integer): Integer;
  procedure canvas_draw_chat_text(acanvas: Tcanvas; x,y: Integer; cliprect: TRect; widestr: WideString; forecolor,backcolor: Tcolor;  bold,underline,italic:boolean);
  function color_irc_to_color(const colorin: WideString): Tcolor;
  procedure updateChatCaption(pnl: TCometPagePanel; chatWinHandle: THandle);
  function findChatPanel(Hwn: Thandle): TCometPagePanel;
  procedure tryFixChatHandle(processData:precord_chatProcessData);
  procedure attach_chatrooms;
  procedure attach_chatroom(processData:precord_chatProcessData);
  procedure detach_chatroom(processData:precord_chatProcessData; pnl: TCometPagePanel; terminateProc:boolean);
  procedure detach_chatrooms(terminateProc:boolean = false);
  procedure sendChildChatroom(hand: THandle; const msg: string);
  procedure broadCastChildChatrooms(const msg: string);
  procedure SendNoticeHasFocus(FocusedPnl: TCometPagePanel);
  procedure SetFocus;

implementation

uses
 ufrmmain,helper_crypt,const_timeouts,helper_unicode,vars_localiz,
 helper_strings,helper_sockets,helper_ipfunc,
 vars_global,helper_sorting,helper_skin,
 helper_base64_32,helper_gui_misc,helper_datetime,
 helper_diskio,helper_filtering,helper_registry,
 helper_urls,helper_ares_nodes,umediar,messages;

function emoticonstr_to_index(const str: string; var lung:integer): Integer;
var
 lenStr: Integer;
 str2,str3: string;
begin
 lung := 3;
 Result := -1;
 lenStr := length(str);

if (lenStr>=2) and (str[1]=':') then begin
 str2 := copy(str,2,2);
  if (length(str2)=2) and (str2[1]='-') then begin
    case str2[2] of
       ')': Result := 0;  // :-)
       'D': Result := 1;  // :-D
       'O','o': Result := 3;  // :-O
       'P','p': Result := 4;  // :-p
       '@': Result := 6;      // :-@
       '$': Result := 7;      // :-$
       'S','s': Result := 8;  // :-S
       '(': Result := 9;      // :-(
       '|': Result := 11;     // :-|
       '[': Result := 42;     // :-[
    end;
  end else
  if (length(str2)=1) or (str2[1]<>'-') then begin
    case str2[1] of
     ')':begin           // :)
        Result := 0;
        lung := 2;
         end;
     'D','d':begin       // :D
        Result := 1;
        lung := 2;
       end;
     'O','o':begin      // :O
        Result := 3;
        lung := 2;
        end;
      'P','p':begin     // :P
        Result := 4;
        lung := 2;
       end;
      '@':begin        // :@
        Result := 6;
        lung := 2;
       end;
       '$':begin      // :$
         Result := 7;
         lung := 2;
         end;
       'S','s':begin  // :S
         Result := 8;
         lung := 2;
         end;
       '(':begin     // :(
         Result := 9;
         lung := 2;
         end;
       '|':begin     // :|
          Result := 11;
          lung := 2;
          end;
       '[':begin     // :[
          Result := 42;
          lung := 2;
          end;
       end;
    if str2='''(' then Result := 10;  // :'(
   end;
end else
if (lenStr>=3) and (str[1]='(') and (str[3]=')') then begin
       case str[2] of
        'H','h': Result := 5;     // (H)
        '6': Result := 12;        // (6)
        'A','a': Result := 13;    // (A)
        'L','l': Result := 14;    // (L)
        'U','u': Result := 15;    // (U)
        'M','m': Result := 16;    // (M)
        '@': Result := 17;        // (@)
        '&': Result := 18;        // (&)
        'S': Result := 19;        // (S)
        '*': Result := 20;        // (*)
        '~': Result := 21;        // (~)
        'E','e': Result := 22;    // (E)
        '8': Result := 23;        // (8)
        'F','f': Result := 24;    // (F)
        'W','w': Result := 25;    // (W)
        'O','o': Result := 26;    // (O)
        'K','k': Result := 27;    // (K)
        'G','g': Result := 28;    // (G)
        '^': Result := 29;        // (^)
        'P','p': Result := 30;    // (P)
        'I','i': Result := 31;    // (I)
        'C','c': Result := 32;    // (C)
        'T','t': Result := 33;    // (T)
        '{': Result := 34;        // ({)
        '}': Result := 35;        // (})
        'B','b': Result := 36;    // (B)
        'D','d': Result := 37;    // (D)
        'Z','z': Result := 38;    // (Z)
        'X','x': Result := 39;    // (Z)
        'Y','y': Result := 40;    // (Y)
        'N','n': Result := 41;    // (N)
        '1': Result := 43;        // (1)
        '2': Result := 44;        // (2)
        '3': Result := 45;        // (3)
        '4': Result := 46;        // (4)
        '5': Result := 49;        // (5)
        '7': Result := 47;        // (6)
        '9': Result := 48;        // (7)
        '!': Result := 50;        // (8)
      end;
end else begin
 str2 := copy(str,1,2);
 str3 := copy(str,1,3);
   if str2='=)'  then begin
                     Result := 0;
                     lung := 2;
                     end else
    if str3=';-)' then Result := 2 else
     if str2=';)'  then begin
                       Result := 2;
                       lung := 2;
                       end else
      if str3='8-)' then Result := 5 else
       if str3='B-)' then Result := 5;
end;

end;

procedure canvas_draw_chat_text(acanvas: Tcanvas; x,y: Integer; cliprect: TRect; widestr: WideString; forecolor,backcolor: Tcolor;  bold,underline,italic:boolean);
begin


 Windows.ExtTextOutW(aCanvas.Handle,
                     x,
                     y,
                     0,
                     @ClipRect,
                     PwideChar(widestr),
                     Length(widestr),
                      nil);
end;

function color_irc_to_color(const colorin: WideString): Tcolor;
const
 arconv: array [0..15] of tcolor = ($00FEFFFF,
                                  clblack,
                                  clnavy,
                                  clgreen,
                                  clred,
                                  clmaroon,
                                  clpurple,
                                  $000080FF,
                                  clyellow,
                                  cllime,
                                  clteal,
                                  claqua,
                                  clblue,
                                  clfuchsia,
                                  clgray,
                                  clsilver);
var
num: Integer;
begin
num := strtointdef(colorin,0);

 if ((num<0) or
     (num>high(arconv))) then begin
  Result := clblack;
  exit;
 end;

result := tcolor(arconv[num]);

{
case num of
 0: Result := $00FEFFFF;
 1: Result := clblack;
 2: Result := clnavy;
 3: Result := clgreen;
 4: Result := clred;
 5: Result := clmaroon;
 6: Result := clpurple;
 7: Result := $000080FF;
 8: Result := clyellow;
 9: Result := cllime;
 10: Result := clteal;
 11: Result := claqua;
 12: Result := clblue;
 13: Result := clfuchsia;
 14: Result := clgray;
 15: Result := clsilver else Result := clblack;
end;  }

end;

procedure canvas_draw_topic(ACanvas: TCanvas; cellrect: TRect; imglist: Timagelist; widestr: WideString; forecolor,backcolor,forecolor_gen,backcolor_gen: TColor; offsetxiniz:integer);
var
dascrivere: WideString;
  h,fatti,posizione_in_real,offsetx,prossima_variazione: Integer;
  bold,underline,italic: Boolean;
  color1,color2: Tcolor;
  num: Integer;
  bmp:graphics.TBitmap;
  str1: string;
  lungemotic,imgindex,widthdascrivere: Integer;
  stile: TFontStyles;
begin
try
bold := False;
underline := False;
italic := False;

             dascrivere := '';
             h := 1;
             offsetx := offsetxiniz;
              while h<=length(widestr) do begin //scan stringa completa
               num := integer(widestr[h]);
                case num of
                  40,58,59,61,56,66:begin //'(:;=8B' emoticon?

                    str1 := copy(widestr,h,3);
                     if length(str1)>=2 then begin
                      imgindex := emoticonstr_to_index(str1,lungemotic);
                      if imgindex<>-1 then begin //è un emoticon! calcoliamo di quanto è lungo...per quelli solo di due
                            if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                        if cellrect.Bottom-cellrect.top<16 then begin
                         bmp := graphics.TBitmap.create;
                         imglist.geTBitmap(imgindex,bmp);
                          with acanvas do begin
                           brush.color := backcolor;
                           fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top));
                           brush.style := bsclear;
                           StretchDraw(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top),bmp);
                          end;
                         bmp.Free;
                        end else begin
                         with acanvas do begin
                          brush.color := backcolor;
                          fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top));
                          brush.style := bsclear;
                         end;
                         if cellrect.bottom-cellrect.top<20 then imglist.draw(Acanvas,cellrect.left+offsetx,cellrect.top,imgindex)
                          else imglist.draw(Acanvas,cellrect.left+offsetx,cellrect.top+2,imgindex);
                        end;
                        inc(h,lungemotic); //skippiamo di quello che ci serviva
                        inc(offsetx,16);
                        continue;
                      end;
                     end;

                     dascrivere := dascrivere+widestr[h];
                     inc(h); //non è emoticon superiamo semplicemente carattere
                     continue;
                  end;
                  2:begin //close fore color
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                    forecolor := forecolor_gen;
                    inc(h);
                    continue;
                  end;
                  3:begin //fore color  chr(3)
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                   forecolor := color_irc_to_color(copy(widestr,h+1,2));
                   inc(h,3);
                   continue;
                  end;
                  4:begin //close back color
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                    backcolor := backcolor_gen;
                    inc(h);
                    continue;
                  end;
                  5:begin //back color
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                   font.Style := stile;
                                   widthdascrivere := gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                   backcolor := color_irc_to_color(copy(widestr,h+1,2));
                   inc(h,3);
                   continue;
                  end;
                  6:begin //bold
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                  brush.color := backcolor;
                                  font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                    bold := not bold;
                    inc(h);
                    continue;
                  end;
                  7:begin //underline
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                  brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                    underline := not underline;
                    inc(h);
                    continue;
                  end;
                  8:begin //inverse
                              if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 acanvas.font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                   color1 := forecolor;
                   color2 := backcolor;
                   backcolor := color1;
                   forecolor := color2;
                    inc(h);
                    continue;
                  end;
                  9:begin //italic
                              if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style := stile;
                                  widthdascrivere := gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere := '';
                            end;
                    italic := not italic;
                    inc(h);
                    continue;
                  end else begin   //semplice avanzamento a prox char
                     dascrivere := dascrivere+widestr[h];
                     inc(h);
                     continue;
                  end;
              end; //fine case
          end;

                             //scriviamo testo precedente!

                             if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 font.Style := stile;
                                widthdascrivere := gettextwidth(dascrivere,acanvas);
                                fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                  //inc(offsetx,widthdascrivere);
                                 // dascrivere := '';
                                end;
                            end;

                          { continue line?

                             while offsetx<cellrect.Right do begin
                                with acanvas do begin
                                 brush.color := backcolor;
                                 font.color := forecolor;
                                 stile := [];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 font.Style := stile;
                                 if dascrivere='' then dascrivere := ' ';
                                widthdascrivere := gettextwidth(dascrivere,acanvas);
                                fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                brush.style := bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+1,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                                if widthdascrivere>0 then inc(offsetx,widthdascrivere) else inc(offsetx,10);
                            end;
                        }
except
end;
end;
function strip_color_string(const text: WideString; var stripped:boolean): WideString;
const
arconv: array [0..9] of byte = (1,1,
                              1,3,1,3,1,1,1,1);
var
i: Integer;
num: Integer;
begin
stripped := False;

i := 1;
result := '';
 while i<=length(text) do begin
    num := integer(text[i]);
    if num>high(arconv) then begin
     Result := result+text[i];
     inc(i);
     continue;
    end;

    stripped := True;

    inc(i,arconv[num]);

   { case num of
     2:inc(i);
     3:inc(i,3);
     4:inc(i);
     5:inc(i,3);
     6:inc(i);
     7:inc(i);
     8:inc(i);
     9:inc(i) else inc(i);
    end; }
 end;

end;

function chatLanguageByteToStr(const langByte: Byte): string;
begin

 case langByte of
  10: Result := 'English';
  11: Result := 'Arabic';
  12: Result := 'Chinese_cn';
  13: Result := 'Chinese_tw';
  14: Result := 'Czech';
  15: Result := 'Dansk';
  16: Result := 'Dutch';
  17: Result := 'Japanese';
  18: Result := 'Kurdish';
  19: Result := 'Kyrgyz';
  20: Result := 'Polish';
  21: Result := 'Portugues';
  22: Result := 'Slovak';
  23: Result := 'Spanish';
  24: Result := 'SpanishLA';
  25: Result := 'Swedish';
  26: Result := 'Turkish';
  27: Result := 'Finnish';
  28: Result := 'French';
  29: Result := 'German';
  30: Result := 'Italian';
  31: Result := 'Russian';
   else Result := 'English';
 end;
 

end;

procedure tthread_udp_channellist.createListener;
var
 sin: TVarSin;
 num,er: Integer;
begin
num := 2;
FillChar(Sin, Sizeof(Sin), 0);
 Sin.sin_family := AF_INET;
 Sin.sin_port := synsock.htons(vars_global.myport+num);
 Sin.sin_addr.s_addr := 0;

 UDP_socket := synsock.socket(PF_INET,integer(SOCK_DGRAM),IPPROTO_UDP);

{
 x := 1; other processes are already using our UDP local endpoint?
 synsock.SetSockOpt(DHT_socket, SOL_SOCKET, SO_REUSEADDR, @x, SizeOf(x));
 }

 er := synsock.Bind(UDP_socket,@Sin,SizeOfVarSin(Sin));
 if er<>0 then begin      
  inc(num);
  Sin.sin_port := synsock.htons(vars_global.myport+num);
  er := synsock.Bind(UDP_socket,@Sin,SizeOfVarSin(Sin));
  if er<>0 then terminate;
 end;


end;

function chat_status_toImgindex(status:word):double;
var
 statusf,maxf,value:double;
begin
result := 0;

statusf := status;
maxf := vars_global.maxScoreChannellist;
if maxf=0 then maxf := 1;
if maxf<statusf then maxf := statusf;

value := statusf/maxf;

result := value;

end;

procedure tthread_udp_channellist.loadIPs;
var
 stream: ThandleStream;
 str_tot: string;
 str: string;
 lun,i: Integer;
 aServer:precord_server_list;
 buffer: array [0..2047] of char;
 ipC: Cardinal;
 portW,score: Word;
 found: Boolean;
 sizeRecord: Byte;
 hasStarted,need_downscore: Boolean;
 filename: WideString;
begin
vars_global.maxScoreChannellist := 1;

serverIPlist := tmylist.create;


if (not fileexistsW(vars_global.data_path+'\Data\ChatroomIPs.dat')) or
   (helper_registry.reg_first_load_chatroom) or
   (GetHugeFileSize(vars_global.data_path+'\Data\ChatroomIPs.dat')<600) then filename := vars_global.app_path+'\Data\ChatroomIPs.dat'
   else filename := vars_global.data_path+'\Data\ChatroomIPs.dat';

      stream := MyFileOpen(filename,ARES_READONLY_BUT_SEQUENTIAL);
      if stream=nil then begin
       exit;
      end;

      str_tot := '';
      with stream do begin
        while (position+1<size) do begin
         lun := read(buffer,sizeof(buffer));
         SetLength(str,lun);
         move(buffer,str[1],lun);
          str_tot := str_tot+
                   str;
        end;
      end;
      FreeHandleStream(stream);

score := 1;
hasStarted := True;
sizeRecord := 6;
need_downscore := False;
while (length(str_tot)>=sizeRecord) do begin

  str := copy(str_tot,1,sizeRecord);
       delete(str_tot,1,sizeRecord);
  ipC := chars_2_dword(copy(str,1,4));
  portW := chars_2_word(copy(str,5,2));
  if sizeRecord>=8 then begin
   score := chars_2_word(copy(str,7,2));
   if score=65000 then need_downscore := True;
  end;


 if ipC=0 then begin
  if not hasStarted then continue;
  sizerecord := ord(str[5]); //first byte of port value
  hasStarted := False;
  continue;
 end;
 hasStarted := False;
 if portW=0 then continue;
 if ip_firewalled(ipC) then continue;

 found := False;
 for i := 0 to serverIPlist.count-1 do begin
  aServer := serverIPlist[i];
  if aServer^.ipC=ipC then begin
   found := True;
   break;
  end;
 end;
 if found then continue;
 aServer := AllocMem(sizeof(record_server_list));
  aServer^.ipC := ipC;
  aServer^.portW := portW;
  aServer^.acked := False;
  aServer^.score := score;
  aServer^.onFile := True;
 serverIPlist.add(aServer);
 if score>vars_global.maxScoreChannellist then vars_global.maxScoreChannellist := score;
end;

if need_downscore then begin
  for i := 0 to serverIPlist.count-1 do begin
   aServer := serverIPlist[i];
   if aServer^.score>=2 then aServer^.score := aServer^.Score div 2
    else aServer^.score := 0;
  end;
end;

shuffle_mylist(serverIPlist,0);

index_scan := 0;
inc(vars_global.maxScoreChannellist);
end;

procedure tthread_udp_channellist.execute;
var
 lastSend,endTime,startTime: Cardinal;
 aServer:precord_server_list;
 finished: Boolean;
begin
priority := tpnormal;
freeonterminate := False;

has_prepared_first := False;
createListener;
LoadIPs;

filtered_strings := tmyStringList.create;
init_keywfilter('ChanListFilter',filtered_strings);
//filtered_strings.add('[dg-x]');
//filtered_strings.add('[ds]');
//filtered_strings.add('sb0t');

listReached := tmylist.create;

synchronize(GUI_searching);

endTime := 0;
lastSend := 0;
countRecvdSupernodes := 0;
finished := False;
startTime := gettickcount;

while (not terminated) do begin
 UDP_Receive;
 sleep(10);

 if gettickcount-lastSend<200 then continue;

  lastSend := gettickcount;
  if lastSend-startTime>=300000 then begin //running for over 5 minutes?
   terminate;
   break;
  end;

  if index_scan>=serverIPlist.count then begin
    finished := True;
    if endTime=0 then endTime := lastSend else
     if lastSend-endTime>15000 then begin
      terminate;
      break;
     end;
  end else begin
    aServer := serverIPlist[index_scan];
    inc(index_scan);

    UDP_RemoteSin.sin_family := AF_INET;
    UDP_RemoteSin.sin_port := synsock.htons(aServer^.portW);
    UDP_RemoteSin.sin_addr.s_addr := aServer^.ipC;
    UDP_Buffer[0] := OP_SERVERLIST_SENDINFO;
    UDP_len_tosend := 1;
    if listReached.count>=2 then add_2_reached_servers;

    synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_tosend,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));

    if shouldRefreshSupernodes then begin
      UDP_Buffer[0] := OP_SERVERLIST_SENDNODES;
      synsock.SendTo(UDP_socket,UDP_buffer,UDP_len_tosend,0,@UDP_RemoteSin,SizeOf(UDP_RemoteSin));
    end;

  end;

end;

if (finished) or (listReached.count>100) then WriteChannelsToDisk;
finalizeIPs;
TCPSocket_Free(UDP_socket);
filtered_strings.Free;
listReached.Free;
synchronize(endSearch);
end;

procedure tthread_udp_channellist.add_2_reached_servers;
var
 posi,i: Integer;
 aServer:precord_server_list;
begin
 posi := random(listReached.count-1);
 if posi<0 then posi := 0;
 for i := 0 to 1 do begin
  aServer := listReached[posi+i];
  move(aServer^.ipC,UDP_buffer[UDP_len_tosend],4);
  move(aServer^.portW,UDP_buffer[UDP_len_tosend+4],2);
  inc(UDP_len_tosend,6);
 end;
end;

procedure tthread_udp_channellist.finalizeIPs;
var
 aServer:precord_server_list;
begin

 while (serverIPlist.count>0) do begin
  aServer := serverIPlist[serverIPlist.count-1];
           serverIPlist.delete(serverIPlist.count-1);
  FreeMem(aServer,sizeof(record_server_list));
 end;
serverIPlist.Free;
end;

procedure tthread_udp_channellist.endSearch;  //synch
begin
helper_channellist.chatListPutStats;
end;

procedure tthread_udp_channellist.putsessionStopAsking;  //sync
begin
vars_global.StopAskingChatServers := True;
end;

procedure tthread_udp_channellist.handler_suggested_supernodes;
var
 recvdCount: Integer;
 list: TMyStringList;
 index,i: Integer;
 portW: Word;
 ipC: Cardinal;
begin

recvdCount := UDP_len_recvd div 6;
if recvdCount>20 then recvdCount := 20;
inc(countRecvdSupernodes,recvdCount);

 if countRecvdSupernodes>=200 then begin
  shouldRefreshSupernodes := False; //stop asking
  synchronize(putsessionStopAsking);
 end;

list := tmyStringList.create;

index := 3;
for i := 1 to recvdCount do begin
 move(UDP_buffer[index],ipC,4);
 inc(index,4);
 move(UDP_buffer[index],portW,2);
 inc(index,2);
 list.add(int_2_dword_string(ipC)+
          int_2_word_string(portW));
end;

if list.count>0 then helper_ares_nodes.aresnodes_add_candidates(list,ares_aval_nodes);

list.Free;
end;

procedure tthread_udp_channellist.handler_channel_info;
var
 index: Integer;
 lenW: Word;
 str,lostr: string;
 widest: WideString;
 i,numEntries: Integer;
 aServer:precord_server_list;
 found: Boolean;
 usersW: Word;
begin
// set to 'acked'
aServer := nil;
found := False;
for i := 0 to serverIPlist.count-1 do begin
 aServer := serverIPlist[i];
 if aServer^.ipC<>cardinal(UDP_remoteSin.sin_addr.S_addr) then continue;

  if aServer^.acked then begin
   if aServer^.score>1 then begin
    dec(aServer^.score);
   end;
   continue;
  end;
  
  aServer^.acked := True;
  listReached.add(aServer);

  if aServer^.onfile then inc(aServer^.score);
  found := True;
  break;

end;
if not found then exit;

if not has_prepared_first then begin //done here in order to eventually add hosted room
 has_prepared_first := True;
 synchronize(prepare_header);
end;

index := 1;
ipC := UDP_remoteSin.sin_addr.S_addr;
if helper_ipfunc.isBlockedChat(ipC) then begin
 exit;
end;

move(UDP_buffer[index],portW,2);
 inc(index,2);
move(UDP_buffer[index],usersW,2);
 inc(index,2);
statusW := aServer^.score;

if usersW<2 then
 if (statusW*2)>=vars_global.maxScoreChannellist then statusW := vars_global.maxScoreChannellist div 2;
 
//name
move(UDP_buffer[index],lenW,2);
if lenW<MIN_CHAT_NAME_LEN then begin
 exit;
end;
if lenW>MAX_CHAT_NAME_LEN*2 then begin
 exit;
end;

 inc(index,2);
SetLength(str,lenW);
move(UDP_buffer[index],str[1],lenW);
 inc(index,lenW);
 if lenW>MAX_CHAT_NAME_LEN then delete(str,MAX_CHAT_NAME_LEN+1,length(str));
chname := str;


//topic
move(UDP_buffer[index],lenW,2);
if lenW>MAX_CHAT_TOPIC_LEN*2 then begin
 exit;
end;

 inc(index,2);
SetLength(str,lenW);
move(UDP_buffer[index],str[1],lenW);
 inc(index,lenW);
if lenW>MAX_CHAT_TOPIC_LEN then delete(str,MAX_CHAT_TOPIC_LEN+1,length(str));
topic := str;

languageS := chatLanguageByteToStr(UDP_buffer[index]);
inc(index); //skip language byte
move(UDP_buffer[index],lenW,2);
inc(index,2);
SetLength(str,lenW);
move(UDP_buffer[index],str[1],lenW);

inc(index,lenW); //skip version

numEntries := UDP_buffer[index];
inc(index);

if numEntries>10 then numEntries := 10;
if numEntries>0 then parse_alt_servers(index,numEntries);

if is_filtered_text(lowercase(topic),filtered_strings) then begin
 exit;  //filtering?
end;
if chname='TestChannel' then exit;
if chname='TestRoom' then exit;
//lostr := lowercase(chname);


widest := utf8strtowidestr(chname)+' '+utf8strtowidestr(topic);
normalize_special_unicode(widest);

lostr := lowercase(widestrtoutf8str(widest));
if is_filtered_text(lostr,filtered_strings) then begin
 exit;  //filtering?
end;
if pos(' anal',lostr)>0 then exit;
if pos('erotic',lostr)>0 then exit;
if pos('caliente',lostr)>0 then exit;
if pos('ardiente',lostr)>0 then exit;
if pos('pervertido',lostr)>0 then exit;
if pos('xxx',lostr)>0 then exit;
if pos('ninfoma',lostr)>0 then exit;
if pos('erotico',lostr)>0 then exit;


strip_Tags_From_Name(chname,topic);
if length(chname)<4 then begin
 exit; //another can't be
end;
 stripped_topic := strip_color_string(utf8strtowidestr(topic),has_colors_intopic);


 synchronize(add_channel);
end;

procedure tthread_udp_channellist.parse_alt_servers(index: Integer; numEntries:integer);
var
 i,h: Integer;
 aServer:precord_server_list;
 ipC: Cardinal;
 portW: Word;
 found: Boolean;
begin
if serverIPlist.count>=MAX_SERVERS_TO_SCAN then exit; //hardlimit

 for i := 1 to numEntries do begin
  move(UDP_buffer[index],ipC,4);
  move(UDP_buffer[index+4],portW,2);
  inc(index,6);

   found := False;
   for h := 0 to serverIPlist.count-1 do begin
    aServer := serverIPlist[h];
    if aServer^.ipC=ipC then begin
     found := True;
     break;
    end;
   end;
   if not found then begin
    aServer := AllocMem(sizeof(record_server_list));
     aServer^.ipC := ipC;
     aServer^.portW := portW;
     aServer^.acked := False;
     aServer^.score := 1;
     aServer^.onfile := False;
    serverIPlist.add(aServer);
   end;

 end;
end;

procedure tthread_udp_channellist.add_channel; //synch
begin
 if helper_channellist.add_channel(ipC,
                                   portW,
                                   languageS,
                                   statusW,
                                   chname,
                                   topic,
                                   stripped_topic,
                                   has_colors_intopic,
                                   true,
                                   true,
                                   true,
                                   buildNo) then begin
 if ares_frmmain.listview_chat_channel.header.sortcolumn>=0 then
 ares_frmmain.listview_chat_channel.sort(nil,ares_frmmain.listview_chat_channel.header.sortcolumn,ares_frmmain.listview_chat_channel.header.sortdirection);
end;
end;

procedure tthread_udp_channellist.WriteChannelsToDisk;
var
 buffer: array [0..1023] of Byte;
 strin: string;
 doneCount,i,possible: Integer;
 db: ThandleStream;
 aServer:precord_server_list;
begin
possible := 0;
for i := 0 to serverIPlist.count-1 do begin
 aServer := serverIPlist[i];
 if not aServer^.acked then continue;
 inc(possible);
end;
if possible<100 then exit;
try
db := MyFileOpen(data_path+'\Data\ChatroomIPs.dat',ARES_OVERWRITE_EXISTING);
if db=nil then exit;
           
doneCount := 0;

//header
strin := int_2_dword_string(0)+
       chr(12)+ //size of records
       chr(0);
move(strin[1],buffer,length(strin));
db.write(buffer,length(strin));

for i := 0 to serverIPlist.count-1 do begin
 aServer := serverIPlist[i];
 if not aServer^.acked then continue;

 strin := int_2_dword_string(aServer^.ipC)+
        int_2_word_string(aServer^.portW)+
        int_2_word_string(aServer^.score)+
        chr(0)+chr(0)+chr(0)+chr(0);

 move(strin[1],buffer,length(strin));
 db.write(buffer,length(strin));
 inc(doneCount);
 if doneCount>=MAX_SAVED_SERVERS then break;
end;

FreeHandleStream(db);
except
end;
end;

procedure tthread_udp_channellist.UDP_Receive;
var
 er,len: Integer;
begin

 if not TCPSocket_canRead(UDP_socket,0,er) then exit;
 Len := SizeOf(UDP_RemoteSin);

 UDP_len_recvd := synsock.RecvFrom(UDP_socket,
                                 UDP_Buffer,
                                 sizeof(UDP_buffer),
                                 0,
                                 @UDP_RemoteSin,
                                 Len);


 if UDP_len_recvd<10 then begin
  exit;
 end;

 if isAntiP2PIP(UDP_remoteSin.sin_addr.S_addr) then begin
  exit;
 end;

 if ip_firewalled(UDP_remoteSin.sin_addr.S_addr) then begin
  exit;
 end;

 if UDP_buffer[0]<>OP_SERVERLIST_ACKINFO then begin
  if UDP_buffer[0]=OP_SERVERLIST_ACKNODES then handler_suggested_supernodes;
  exit;
 end;
 handler_channel_info;
end;



procedure strip_tags_from_name(var sname: string; var stopic: string);
var
i: Integer;
lochname: string;
begin


while true do begin
 lochname := lowercase(sname);

 i := pos('Â -',lochname);
 if i>0 then begin
  delete(sname,i,3);
  continue;
 end;

 i := pos('Â ',lochname);
 if i>0 then begin
  delete(sname,i,2);
  continue;
 end;

 i := pos('[is]',lochname);
 if i>0 then begin
  delete(sname,i,4);
  stopic := '[is] '+stopic;
  continue;
 end;

 i := pos('[asax]',lochname);
 if i>0 then begin
  delete(sname,i,6);
  stopic := '[ASAX] '+stopic;
  continue;
 end;

 i := pos('[dg-x]',lochname);
 if i>0 then begin
  delete(sname,i,6);
  stopic := '[Dg-x] '+stopic;
  continue;
 end;

 i := pos('[Î£k]',lochname);
 if i>0 then begin
  delete(sname,i,5);
  stopic := '[Î£K] '+stopic;
  continue;
 end;

 i := pos('[ae]',lochname);
 if i>0 then begin
  delete(sname,i,4);
  stopic := '[AE] '+stopic;
  continue;
 end;

 i := pos(chr(160),lochname);
 if i>0 then delete(lochname,i,1);

 break;
end;

end;


function channel_to_arlnk(chan:precord_displayed_channel; plaintext:boolean=false): string;
var
str: string;
begin
if plaintext then begin
 Result := const_ares.STR_ARLNK_LOWER+'Chatroom:'+ipint_to_dotstring(chan^.ip)+':'+inttostr(chan^.port)+'|'+
         chan^.name+' '+
         widestrtoutf8str(chan^.stripped_topic);
 exit;
end;

   str := CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        'CHATCHANNEL'+CHRNULL+
        int_2_dword_string(chan^.ip)+
        int_2_word_string(chan^.port)+
        int_2_dword_string(0)+
        chan^.name+CHRNULL+
        //chan^.topic+    // 12/26/2005 removed topic , shorter hashlink
        CHRNULL;

str := zcompressstr(str);
str := e67(str,28435);

result := const_ares.STR_ARLNK_LOWER+encodebase64(str);
end;

function fav_channel_to_arlnk(chan:precord_chat_favorite; plaintext:boolean=false): string;
var
str: string;
begin
if plaintext then begin
 Result := const_ares.STR_ARLNK_LOWER+'Chatroom:'+ipint_to_dotstring(chan^.ip)+':'+inttostr(chan^.port)+'|'+chan^.name;
 exit;
end;

   str := CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        CHRNULL+CHRNULL+CHRNULL+CHRNULL+
        'CHATCHANNEL'+CHRNULL+
        int_2_dword_string(chan^.ip)+
        int_2_word_string(chan^.port)+
        int_2_dword_string(0)+
        chan^.name+CHRNULL+
        //chan^.topic+
        CHRNULL;

str := zcompressstr(str);
str := e67(str,28435);

result := const_ares.STR_ARLNK_LOWER+encodebase64(str);
end;



procedure join_arlnk_chat(serialized: string; isPlaintext:boolean=false);
var
 ip: Cardinal;
 locrc,port: Word;
 chname,topic,ips,lochname,urlDeco: string;
 chan:precord_displayed_channel;
 has_colors_intopic: Boolean;
begin

if isPlainText then begin
 ips := copy(serialized,1,pos(':',serialized)-1);
 ip := inet_addr(PChar(ips));
     delete(serialized,1,pos(':',serialized));
 port := strtointdef(copy(serialized,1,pos('|',serialized)-1),0);
     delete(serialized,1,pos('|',serialized));
 if serialized[length(serialized)]='/' then delete(serialized,length(serialized),1);
 urlDeco := helper_urls.urldecode(serialized);

 if length(urlDeco)=length(serialized) then chname := serialized
  else chname := urldeco;  //browser urlencodes UTF-8

 topic := '';

end else begin
 ip := chars_2_dword(copy(serialized,1,4));
 port := chars_2_word(copy(serialized,5,2));
 //alt_ip := chars_2_dword(copy(serialized,7,4));
 if port=0 then exit;
 if ip=0 then exit;

 delete(serialized,1,10);
  chname := copy(serialized,1,pos(CHRNULL,serialized)-1);
 if length(chname)<MIN_CHAT_NAME_LEN then exit;

 delete(serialized,1,pos(CHRNULL,serialized));
  topic := copy(serialized,1,pos(CHRNULL,serialized)-1);
  ips := ipint_to_dotstring(ip);
end;

 lochname := lowercase(chname);
 locrc := stringcrc(lochname,true);

 chan := AllocMem(sizeof(record_displayed_channel));
  chan^.ip := ip;
  chan^.port := port;
  chan^.name := chname;
  chan^.locrc := locrc;
  chan^.topic := topic;
  chan^.stripped_topic := strip_color_string(utf8strtowidestr(topic),has_colors_intopic);
  chan^.has_colors_intopic := has_colors_intopic;
  chan^.enableJSTemplate := vars_global.chat_enabled_remoteJSTemplate;

 join_channel(chan);
 if ares_frmmain.tabs_pageview.activepage<>IDTAB_CHAT then ares_frmmain.tabs_pageview.activepage := IDTAB_CHAT;
 ares_frmmain.panel_chat.activePage := ares_frmmain.panel_chat.PanelsCount-1;
 
 with chan^ do begin
  name := '';
  topic := '';
  stripped_topic := '';
 end;
  FreeMem(chan,sizeof(record_displayed_channel));
end;

function findChatPanel(Hwn: Thandle): TCometPagePanel;
var
 i: Integer;
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin
result := nil;
try
if high(ares_frmmain.panel_chat.panels)=0 then exit;

    for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
       pnl := ares_frmmain.panel_chat.panels[i];
       if pnl.id<>IDXChatMain then continue;
        processData := pnl.fData;
        if processData^.wnhandle=Hwn then begin
          Result := pnl;
          exit;
        end;
    end;
except
end;
end;

procedure updateChatCaption(pnl: TCometPagePanel; chatWinHandle: THandle);
var
 len: Integer;
 titleW: WideString;
begin
try
 if not isWindow(chatWinHandle) then exit;
 Len := GetWindowTextLengthW(chatWinHandle)+1;
 SetLength(titleW,Len);
 GetWindowTextW(chatWinHandle, PWideChar(TitleW), Len);
 if length(titleW)>0 then if titleW[length(titleW)]=char(0) then delete(titleW,length(titleW),1);
 pnl.FCaption := TitleW;
except
end;
end;

procedure detach_chatroom(processData:precord_chatProcessData; pnl: TCometPagePanel; terminateProc:boolean);
begin
try
  if isWindow(processData^.wnhandle) then begin
    if not terminateProc then sendChildChatroom(processData^.wnhandle,'SKINBEGIN');
   SetWindowPos(processData^.wnhandle,0,0,0,0,0,SWP_NOZORDER);
   Windows.SetParent(processData^.wnhandle,processData^.oldParentWn);
   UpdateWindow(processData^.wnhandle);
   AttachThreadInput(GetCurrentThreadId, processData^.FAppThreadID, false);
   SetWindowLong(processData^.containerPnl.Handle, GWL_STYLE, GetWindowLong(processData^.containerPnl.Handle,GWL_STYLE) - WS_CLIPCHILDREN);
   try
   if terminateProc then begin
    postMessage(processData^.wnhandle,WM_TERMINATECHAT,0,0);
    pnl.ID := IDNone;
    pnl.FData := nil;
    FreeMem(processData,sizeof(record_chatProcessData));
   end;
   except
   end;
  end;
  except
  end;
end;

procedure detach_chatrooms(terminateProc:boolean);
var
 i: Integer;
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin
if ares_frmmain.panel_chat.panelsCount<=1 then exit;

  for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
   pnl := ares_frmmain.panel_chat.panels[i];
   if pnl.id<>IDXChatMain then continue;
   processData := pnl.fdata;
   detach_chatroom(processData,pnl,terminateProc);
  end;

end;

procedure sendChildChatroom(hand: THandle; const msg: string);
var
 payload: string;
 rec: TRectoPass;
 cd: TCopyDataStruct;
begin
try
payload := msg;
rec.s := payLoad;
rec.i := 32;
cd.dwData := 3232;
cd.cbData := sizeof(rec);
cd.lpData := @rec;

sendMessage(hand,WM_COPYDATA,ares_frmmain.Handle, LongInt(@cd));
except
end;
end;

procedure broadCastChildChatrooms(const msg: string);
var
 i: Integer;
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin
try
if high(ares_frmmain.panel_chat.panels)<1 then exit;

for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
  pnl := ares_frmmain.panel_chat.panels[i];
  if pnl.id<>IDXChatMain then continue;
   processData := pnl.fData;
   if not isWindow(processData^.wnhandle) then continue;
   sendChildChatroom(processData^.wnhandle,msg);
end;
except
end;
end;

procedure attach_chatroom(processData:precord_chatProcessData);
begin
   try
    if isWindow(processData^.wnhandle) then begin
     sendChildChatroom(processData^.wnhandle,'SKINEND'+int_2_dword_string(ares_frmmain.handle));
     AttachThreadInput(GetCurrentThreadId, processData^.FAppThreadID, True);
     Windows.SetParent(processData^.wnhandle,processData^.containerPnl.Handle);

     SendMessage(processData^.containerPnl.Handle, WM_UPDATEUISTATE, UIS_INITIALIZE, 0);
     UpdateWindow(processData^.wnhandle);

     SetWindowLong(processData^.containerPnl.Handle, GWL_STYLE, GetWindowLong(processData^.containerPnl.Handle,GWL_STYLE) or WS_CLIPCHILDREN);
     SetWindowPos(processData^.wnhandle,0,0,0,ares_frmmain.panel_chat.ClientWidth,ares_frmmain.panel_chat.ClientHeight,SWP_NOZORDER);

    end;
   except
   end;
end;

procedure attach_chatrooms;
var
 i: Integer;
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin
if ares_frmmain.panel_chat.panelsCount<=1 then exit;

  for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
   pnl := ares_frmmain.panel_chat.panels[i];
   if pnl.id<>IDXChatMain then continue;
   processData := pnl.fdata;
   attach_chatroom(processData);
  end;

end;

procedure SendNoticeHasFocus(FocusedPnl: TCometPagePanel);
var
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
 i: Integer;
begin
try
 if high(ares_frmmain.panel_chat.panels)<1 then exit;

 for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
  pnl := ares_frmmain.panel_chat.panels[i];
  if pnl.ID<>IDXChatMain then continue;
  processData := pnl.FData;

  if processData^.hasFocus<>(pnl=focusedPnl) then begin

    if (processData^.wnhandle<>0) and
       (isWindow(processData^.wnhandle)) then begin
        processData^.hasFocus := (pnl=focusedPnl);
        sendChildChatroom(processData^.wnhandle,'FOCUS'+chr(integer(pnl=focusedPnl)));
    end;
    
  end;

 end;
except
end;
end;

procedure SetFocus;
var
 point: TPoint;
 pnl: TCometPagePanel;
 processData:precord_chatProcessData;
begin

if ares_frmmain.panel_chat.activePage=0 then begin
 GetCursorPos(point);
 ScreenToClient(ares_frmmain.listview_chat_channel.handle,point);
 if (point.y>0) and (point.y<ares_frmmain.listview_chat_channel.height) then begin
  ares_frmmain.listview_chat_channel.setFocus;
  exit;
 end;
 if point.y>ares_frmmain.listview_chat_channel.height+30 then begin
  ares_frmmain.treeview_chat_favorites.setFocus;
  exit;
 end;
exit;
end;

{pnl := ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
if pnl.id<>IDXChatMain then exit;
 processData := pnl.fdata;
// SetWindowPos(processData^.wnhandle,0,0,0,processData^.containerPnl.ClientWidth,processData^.containerPnl.ClientHeight,SWP_NOZORDER);
//  WM_LBUTTONDOWN       0x0201;
 SendMessage(processData^.wnhandle,$0201, 0, 0); }
end;

//join channel triggered event
procedure join_channel(datas:precord_displayed_channel);
var
  cmdline: WideString;
  StartupInfo: TStartupInfoW;
  ProcessInformation: TProcessInformation;
  punto: TPoint;
  dwI: Cardinal;
  WindowStyle,i : Integer;
  winHandle: THandle;
  pnl: TCometPagePanel;
  processData:precord_chatProcessData;
begin

 if high(ares_frmmain.panel_chat.panels)>0 then
  for i := 1 to high(ares_frmmain.panel_chat.panels) do begin
   pnl := ares_frmmain.panel_chat.panels[i];
   if pnl.ID<>IDXChatMain then continue;
   processData := pnl.FData;
   if datas^.ip=processData^.ip then begin
     ares_frmmain.panel_chat.activePage := i;
     exit;
   end;
  end;


   processData := AllocMem(sizeof(record_chatProcessData));
   processData.wnhandle := 0;
    processData^.containerPnl := Tpanel.create(ares_frmmain);
    processData^.containerPnl.parent := ares_frmmain.panel_chat;
    processData^.containerPnl.BevelOuter := bvnone;
    processData^.hasFocus := False;
    processData^.initialized := False;
    processData^.containerPnl.caption := '';
    processData^.containerPnl.color := COLORE_PANELS_BG;
    processData^.ip := datas^.ip;

   pnl := ares_frmmain.panel_chat.AddPanel(IDXChatMain,utf8strtowidestr(datas^.name),[],processData^.containerPnl,processData,true,2);
   ares_frmmain.panel_chat.wrappable := True;

try

  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcessInformation, SizeOf(TProcessInformation), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOWNORMAL;

  cmdline := '- '+inttostr(ares_frmmain.handle)+'|'+
           helper_ipfunc.ipint_to_dotstring(vars_global.localipC)+'|'+
           ipint_to_dotstring(datas^.ip)+'|'+
           inttostr(datas^.port)+'|'+
           inttostr(integer(datas^.enableJSTemplate))+'|'+
           helper_urls.urlencode(datas^.name);

  //UniqueString(cmdline);
  
  if CreateProcessW(PwideChar(vars_global.app_path+'\'+const_ares.CHATCLIENT_EXENAME), pwidechar(cmdline),nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInformation) then begin
    //WaitForSingleObject(ProcInfo.hProcess, 500);
    outputdebugstring(PChar('ProcessID:'+inttostr(processInformation.dwProcessId)));
    winHandle := utility_ares.GetHWndByPID(processInformation.dwProcessId);
    while (winHandle=0) or (not isWindow(winHandle)) do begin
     sleep(50);
     winHandle := utility_ares.GetHWndByPID(processInformation.dwProcessId);
   end;
   processData^.wnhandle := winHandle;
   outputdebugstring(PChar('WindowHandle:'+inttostr(processData^.wnhandle)));
   //messagebox(0,PChar('found'),PChar('gf'),mb_ok);
  processData^.procID := processInformation.dwProcessId;

  // Attach container app input thread to the running app input thread, so that
  //  the running app receives user input.
  processData^.FAppThreadID := GetWindowThreadProcessId(processData^.wnhandle, nil);
  AttachThreadInput(GetCurrentThreadId, processData^.FAppThreadID, True);


  processData^.oldParentWn := windows.GetParent(processData^.wnhandle);
  /// Changing parent of the running app to our provided container control
  SetWindowPos(processData^.wnhandle,0,0,0,0,0,SWP_NOZORDER or SWP_HIDEWINDOW);
  Windows.SetParent(processData^.wnhandle,processData^.containerPnl.Handle);
  SendMessage(processData^.containerPnl.Handle, WM_UPDATEUISTATE, UIS_INITIALIZE, 0);
  UpdateWindow(processData^.wnhandle);

  /// This prevents the parent control to redraw on the area of its child windows (the running app)
  SetWindowLong(processData^.containerPnl.Handle, GWL_STYLE, GetWindowLong(processData^.containerPnl.Handle,GWL_STYLE) or WS_CLIPCHILDREN);
  /// Make the running app to fill all the client area of the container
  SetWindowPos(processData^.wnhandle,0,0,0,ares_frmmain.panel_chat.ClientWidth,ares_frmmain.panel_chat.ClientHeight,SWP_NOZORDER or SWP_SHOWWINDOW);

  SetForegroundWindow(processData^.wnhandle);
  if not helper_skin.skinnedFrameLoaded then SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, 1, 0);

       CloseHandle(processInformation.hProcess);
       CloseHandle(processInformation.hThread);

         processData^.containerPnl.OnResize := ufrmmain.ares_frmmain.resizeChatChannel;

          processData^.initialized := True;
          ares_frmmain.timerSetChatIDX.enabled := True;
    end;

except
end;

end;

procedure tryFixChatHandle(processData:precord_chatProcessData);
var
 winHandle: Thandle;
begin
    winHandle := utility_ares.GetHWndByPID(processData^.procID);
    while (winHandle=0) or (not isWindow(winHandle)) do begin
     sleep(50);
     winHandle := utility_ares.GetHWndByPID(processData^.procID);
    end;
    processData^.wnhandle := winHandle;
    //detach_chatroom(processData,pnl,false);
    attach_chatroom(processData);
    outputdebugstring(PChar('reassingned handle!'));
end;



procedure export_favorite_channel_hashlink; //export single channel hashlink
var
node:pcmtvnode;
chan:precord_chat_favorite;
buffer: array [0..500] of char;
stream: Thandlestream;
str: string;
filenw: WideString;
begin
with ares_frmmain do begin
  node := treeview_chat_favorites.getfirstselected;
  if node=nil then exit;

 filenw := vars_global.data_path+'\Temp\'+formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' Channel Hashlink.txt';

   tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);

    stream := MyFileOpen(filenw,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream=nil then exit;

 with stream do begin
   chan := treeview_chat_favorites.getdata(node);
     str := chan^.name+CRLF+
          fav_channel_to_arlnk(chan)+CRLF+CRLF;
   move(str[1],buffer,length(str));
   write(buffer,length(str));
 end;
 FreeHandleStream(stream);
end;

 Tnt_ShellExecuteW(0,'open',pwidechar(widestring('notepad')),pwidechar(filenw),nil,SW_SHOW);
end;

procedure export_channel_hashlink; //export single channel hashlink
var
 node:pcmtvnode;
 chan:precord_displayed_channel;
 buffer: array [0..500] of char;
 stream: Thandlestream;
 str: string;
 filenw: WideString;
begin
with ares_frmmain do begin
  node := listview_chat_channel.getfirstselected;
  if node=nil then exit;

 filenw := vars_global.data_path+'\Temp\'+formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' Channel Hashlink.txt';

   tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);

    stream := MyFileOpen(filenw,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream=nil then exit;

 with stream do begin
   chan := listview_chat_channel.getdata(node);
     str := chan^.name+CRLF+
          channel_to_arlnk(chan)+CRLF;

    if vars_global.IDEIsRunning then 
     str := str+
          channel_to_arlnk(chan,true)+CRLF+CRLF
         else
         str := str+CRLF;

   move(str[1],buffer,length(str));
   write(buffer,length(str));
 end;
 FreeHandleStream(stream);
end;

 Tnt_ShellExecuteW(0,'open',pwidechar(widestring('notepad')),pwidechar(filenw),nil,SW_SHOW);
end;

// export channellist , this list may be of some use to website-chat owners
procedure export_channellist;
var
 node:pcmtvnode;
 chan:precord_displayed_channel;
 buffer: array [0..1023] of char;
 stream: Thandlestream;
 str: string;
 filenw: WideString;
begin
with ares_frmmain do begin

if listview_chat_channel.rootnodecount=0 then exit;
 filenw := vars_global.data_path+'\Temp\'+formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' Ares ChannelList.txt';

   tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);


    stream := MyFileOpen(filenw,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream=nil then exit;

 with stream do begin

  node := listview_chat_channel.getfirst;
  while (node<>nil) do begin

   if node.childcount>0 then begin
    node := listview_chat_channel.getnext(node);
    continue;
   end;

   chan := listview_chat_channel.getdata(node);
     str := chan^.name+CRLF+
          chan^.topic+CRLF+
          chan^.language+CRLF+
          channel_to_arlnk(chan)+CRLF;

     if vars_global.IDEIsRunning then str := str+
                               channel_to_arlnk(chan,true)+CRLF
          else
          str := str+CRLF;

          try
    move(str[1],buffer,length(str));
    write(buffer,length(str));
         except
         end;

      node := listview_chat_channel.getnext(node);
  end;

 end;
 FreeHandleStream(stream);
end;

 Tnt_ShellExecuteW(0,'open',pwidechar(widestring('notepad')),pwidechar(filenw),nil,SW_SHOW);
end;

procedure clear_chanlist_backup;
var
 canale:precord_displayed_channel;
begin

while (vars_global.chat_chanlist_backup.count>0) do begin
 canale := vars_global.chat_chanlist_backup[vars_global.chat_chanlist_backup.count-1];
    vars_global.chat_chanlist_backup.delete(vars_global.chat_chanlist_backup.count-1);
      with canale^ do begin
       topic := '';
       name := '';
       language := '';
       stripped_topic := '';
      end;
FreeMem(canale,sizeof(record_displayed_channel));
end;

end;

procedure mainGui_trigger_channelfilter;
var
 i: Integer;
 canale:precord_displayed_channel;
 search_str: string;
 split_string,filtered_strings: TMyStringList;
 added: Integer;
begin

with ares_frmmain do begin
 with listview_chat_channel do begin
   BeginUpdate;
   Clear;

if length(edit_chat_chanfilter.text)<1 then begin
  for i := 0 to vars_global.chat_chanlist_backup.count-1 do begin
    canale := vars_global.chat_chanlist_backup[i];
    add_channel(canale^.ip,
                canale^.port,
                canale^.language,
                canale^.status,
                canale^.name,
                canale^.topic,
                canale^.stripped_topic,
                canale^.has_colors_intopic,
                false,false,false,canale^.buildNo);
  end;
  if header.sortcolumn>=0 then sort(nil,header.sortcolumn,header.sortdirection);
  EndUpdate;
  (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(vars_global.chat_chanlist_backup.count)+')';
  ares_frmmain.panel_chat.invalidate;
    ares_frmmain.edit_chat_chanfilter.glyphindex := 12;
    ares_frmmain.edit_chat_chanfilter.text := '';
exit;
end;

   ares_frmmain.edit_chat_chanfilter.glyphIndex := 11;
   search_str := lowercase(widestrtoutf8str(edit_chat_chanfilter.text));



 filtered_strings := tmyStringList.create;
 init_keywfilter('ChanListFilter',filtered_strings);
 if is_filtered_text(search_str,filtered_strings) then begin
 filtered_strings.Free;
      for i := 0 to vars_global.chat_chanlist_backup.count-1 do begin
      canale := vars_global.chat_chanlist_backup[i];
      add_channel(canale^.ip,
                  canale^.port,
                  canale^.language,
                  canale^.status,
                  canale^.name,
                  canale^.topic,
                  canale^.stripped_topic,
                  canale^.has_colors_intopic,
                  false,false,false,canale^.buildNo);
   end;
   if header.sortcolumn>=0 then sort(nil,header.sortcolumn,header.sortdirection);
   EndUpdate;
   (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(vars_global.chat_chanlist_backup.count)+')';
    ares_frmmain.panel_chat.invalidate;
    exit;
 end else filtered_strings.Free;

 

   split_string := tmyStringList.create;
   SplitString(search_str,split_string);
   added := 0;

for i := 0 to vars_global.chat_chanlist_backup.count-1 do begin
    canale := vars_global.chat_chanlist_backup[i];

    if not checkChatUserFilter(split_string,lowercase(canale^.name+' '+canale^.topic)) then continue;

    add_channel(canale^.ip,
                canale^.port,
                canale^.language,
                canale^.status,
                canale^.name,
                canale^.topic,
                canale^.stripped_topic,
                canale^.has_colors_intopic,
                false,false,false,canale^.buildNo);
    inc(added);
    
end;

if header.sortcolumn>=0 then sort(nil,header.sortcolumn,header.sortdirection);
endupdate;
end;
end;

split_string.Free;

if ares_frmmain.listview_chat_channel.rootnodecount=cardinal(vars_global.chat_chanlist_backup.count) then
(ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(vars_global.chat_chanlist_backup.count)+')'
else
 (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(added)+'/'+inttostr(vars_global.chat_chanlist_backup.count)+')';

  ares_frmmain.panel_chat.invalidate;
end;

procedure ChatListPutStats;
begin
try
with ares_frmmain do begin

 with listview_chat_channel do begin
  //endupdate;
    if vars_global.chat_chanlist_backup.count=0 then
     if RootNodeCount=1 then clear;
     
    if header.sortcolumn>=0 then sort(nil,header.sortcolumn,header.sortdirection);

    edit_chat_chanfilter.enabled := True; //impediamo search while listing
    if ((length(edit_chat_chanfilter.text)>1) and (edit_chat_chanfilter.glyphindex<>12) and (edit_chat_chanfilter.glyphindex>0)) then (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(chatlist_getrealcount)+'/'+inttostr(vars_global.chat_chanlist_backup.count)+')'
     else (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS)+' ('+inttostr(vars_global.chat_chanlist_backup.count)+')';
     ares_frmmain.panel_chat.invalidate;

 end;

end;

except
end;

end;

procedure add_mandatory_channels;
begin
end;

function chatlist_getrealcount: Integer;
var
node:pcmtVnode;
begin
result := 0;

with ares_frmmain.listview_chat_channel do begin

 node := getfirst;
 while (node<>nil) do begin
  if node.childcount=0 then inc(result);
  node := getNext(node);
 end;

end;

end;


procedure tthread_udp_channellist.prepare_header; //synch
var
 mutex_chat: string;
 hGMutex:hwnd;
begin
with ares_frmmain do begin
 with listview_chat_channel do begin
   beginupdate;

   Clear;
   canbgcolor := True;
   selectable := True;
   with header.columns do begin
    Items[0].text := GetLangStringW(STR_NAME);
    Items[1].text := GetLangStringW(STR_LANGUAGE);
    Items[2].text := GetLangStringW(STR_AVAILIBILITY);
    Items[3].text := GetLangStringW(STR_TOPIC);

     Items[0].width := gettextwidth( Items[0].text,ares_FrmMain.canvas)+30;
    if Items[0].width<170 then Items[0].width := 170;
    Items[1].width := gettextwidth(Items[1].text,ares_FrmMain.canvas)+5;
    Items[2].width := gettextwidth(Items[2].text,ares_FrmMain.canvas);
    Items[3].width := (listview_chat_channel.width-(Items[0].width+Items[1].width+Items[0].width+Items[2].width))-35;
   end;
   endupdate;
 end;

end;

mutex_chat := 'AresChatGlbMtx';
hGMutex := OpenMutex(windows.SYNCHRONIZE,FALSE,PChar(mutex_chat));
if (hGMutex<>0) then begin
  CloseHandle(hGMutex);
  ReadOwnConf;
end else begin
  ReleaseMutex(hGMutex);
  CloseHandle(hGMutex);
end;

end;

procedure tthread_udp_channellist.readOwnConf;
var
 tof: Textfile;
 lineStr,varName,varValue: string;
begin
try


if not fileExistsW(app_path+'\Data\ChatConf.txt') then exit;
portW := 0;
chname := '';
SetCurrentDirectoryW(pwidechar(app_path+'\Data'));
assignfile(tof,'ChatConf.txt');
reset(tof);

while (not eof(tof)) do begin

 readln(tof,lineStr);
 linestr := trim(lineStr);

 if pos('#',linestr)=1 then continue;
 if pos(' ',linestr)=1 then continue;
 if pos('/',lineStr)=1 then continue;
 if pos(';',lineStr)=1 then continue;
 
 if length(lineStr)=0 then continue;

 varName := lowercase(copy(linestr,1,pos('=',linestr)-1));
 if length(varName)=0 then continue;
 if pos(STR_UTF8BOM,varName)=1 then delete(varName,1,3);

 varValue := trim(copy(linestr,pos('=',linestr)+1,length(linestr)));
 if length(varValue)=0 then continue;

 if varName='channelport' then begin
  portW := strtointdef(varValue,5000);
  end
  else
 if varName='channelname' then begin
  chname := varValue;
  end
  else
 if varName='channeltopic' then begin
  Topic := hexstr_to_bytestr(varValue);
  end else
 if varName='channellanguage' then begin
  languageS := varValue;
 end;


end;

closefile(tof);

 if portW>1024 then begin
   chname := 'Hosted: '+chname;
   ipC := inet_addr(PChar('127.0.0.1'));
   statusW := 65535;
   buildNo := 3035;
   stripped_topic := strip_color_string(utf8strtowidestr(topic),has_colors_intopic);
    synchronize(add_channel)
 end;
except
end;
end;

procedure tthread_udp_channellist.checkShouldRefreshSupernodes; //sync
var
 reg: Tregistry;
begin
shouldRefreshSupernodes := False;
if vars_global.StopAskingChatServers then exit;

reg := tregistry.create;
 with reg do begin
 openkey(areskey,true);
 if valueExists('Stats.LstConnect') then begin
  shouldRefreshSupernodes := ((DelphiDateTimeToUnix(now)-readInteger('Stats.LstConnect'))>5184000{60 days});
 end else shouldRefreshSupernodes := True;
 closekey;
 destroy;
 end;
 if shouldRefreshSupernodes then vars_global.ever_pressed_chat_list := True;
end;

procedure tthread_udp_channellist.GUI_searching; //synch
var
 nodo:pCmtVnode;
 datao:precord_displayed_channel;
begin
 checkShouldRefreshSupernodes;

 with areS_frmmain do begin
 clear_chanlist_backup;
 (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS);
  with listview_chat_channel do begin
   Clear;
   with header.columns do begin
    Items[0].width := width;
    Items[1].width := 0;
    Items[2].width := 0;
    Items[3].width := 0;
    Items[0].text := '';
    Items[1].text := '';
    Items[2].text := '';
    Items[3].text := '';
   end;

   selectable := False;
   canbgcolor := False;

   nodo := addchild(nil);
     datao := getdata(nodo);
     with datao^ do begin
      name := GetLangStringA(STR_RETRIEVINGLIST_PLEASEWAIT);
      topic := '';
      language := '';
      ip := 0;
      port := 0;
     end;

   end;
 end;
 


end;

function checkChatUserFilter(split_string: TMyStringList; const matchStr: string): Boolean;
var
h: Integer;
search_str: string;
deleteit: Boolean;
begin
result := True;

    if split_string=nil then begin
     deleteit := True;
     search_str := lowercase(widestrtoutf8str(ares_frmmain.edit_chat_chanfilter.text));
     split_string := tmyStringList.create;
     SplitString(search_str,split_string);
    end else deleteit := False;

     for h := 0 to split_string.count-1 do begin
      if pos(split_string.strings[h],matchstr)=0 then begin
       Result := False;
       break;
      end;
     end;
     
    if deleteit then split_string.Free;

end;

function add_channel(ip: Cardinal; port: Word; const language: string; status: Word; const chname,topic: string;
  stripped_topic: WideString; has_colors_intopic: Boolean; addBackup:boolean=true; checkFilter:boolean=true;
  killduplicates:boolean=true; buildNo:word=0): Boolean;
var
 ips: string;
 lochname: string;
 locrc: Word;
 canale,canale_backup:precord_displayed_channel;
 node:pCmtVnode;
 i: Integer;
//is_firewalled: Boolean;
begin
//is_firewalled := False;
result := False;

lochname := lowercase(chname);
locrc := stringcrc(lochname,true);

with ares_frmmain do begin
 with listview_chat_channel do begin

if KillDuplicates then begin
  // use backup list if we're adding channels by threads
  for i := 0 to vars_global.chat_chanlist_backup.count-1 do begin
   canale := vars_global.chat_chanlist_backup[i];
    if canale^.ip=ip then exit;
  end;

end else begin
  // compare using listview if we're called by filter triggers
  node := Getfirst;
  while (node<>nil) do begin
      canale := GetData(node);
      if canale^.ip=ip then exit;
   node := getNextSibling(node);
  end;

end;

 ips := ipint_to_dotstring(ip);

 if addbackup then begin
  canale_backup := AllocMem(sizeof(record_displayed_channel));
   canale_backup^.ip := ip;
   canale_backup^.port := port;
   canale_backup^.name := chname;
   canale_backup^.locrc := locrc;
   canale_backup^.topic := topic;
   canale_backup^.language := language;
   canale_backup^.stripped_topic := stripped_topic;
   canale_backup^.has_colors_intopic := has_colors_intopic;
   canale_backup^.status := status;
   canale_backup^.buildNo := buildNo;
    vars_global.chat_chanlist_backup.add(canale_backup);
  end;

if (edit_chat_chanfilter.glyphindex<>12) and
   (edit_chat_chanfilter.glyphindex>0) then
 if checkFilter then
  if length(ares_frmmain.edit_chat_chanfilter.text)>0 then
   if not checkChatUserFilter(nil,lochname+' '+lowercase(topic)) then exit;

  node := AddChild(nil);
   canale := getdata(node);
    canale^.ip := ip;
    canale^.port := port;
    canale^.name := chname;
    canale^.language := language;
    canale^.locrc := locrc;
    canale^.topic := topic;
    canale^.stripped_topic := stripped_topic;
    canale^.has_colors_intopic := has_colors_intopic;
    canale^.status := status;
    canale^.buildNo := buildNo;
    Result := True;
 end;
end;
end;


function channellist_find_root(ip: Cardinal; var Oldchildnode:pcmtvnode):pcmtvnode;
var
 datac:precord_displayed_channel;
begin
result := nil;
try
oldChildNode := nil;

with ares_frmmain.listview_chat_channel do begin
   Result := getFirst;
    while (result<>nil) do begin
     datac := getData(result);
     if dataC^.ip=ip then begin

       if result.childcount=0 then begin  // this is not a parent node...
        OldChildNode := result;
        Result := nil;
       end;

       exit;
     end;
      Result := GetNextSibling(result);
    end;
end;
except
end;
end;

procedure add_channel_fromreg;
var
fname,ports,ips: string;
reg: Tregistry;

ip: Cardinal;
port: Word;
begin
try

 reg := tregistry.create;
 with reg do begin
  openkey(areskey,true);

  fname := readstring('ch_name');
  ips := readstring('ch_ip');
  ports := readstring('ch_port');

  closekey;
  destroy;
 end;

if length(fname)>0 then
 if length(ports)>0 then
  if length(ips)>0 then begin
     ip := inet_addr(PChar(ips));
     port := strtointdef(ports,6666);
      add_channel(ip,port,'',1,fname,'','',false);
end;


except
end;
end;



end.
