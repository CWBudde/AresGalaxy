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

unit helper_chat_favorites;

interface

uses
registry,classes,ares_types,const_ares,comettrees,controls,windows,sysutils;

procedure save_favorite_channel(dataf:precord_chat_favorite; oldip: Cardinal=0; oldport:word=0);
procedure load_favorite_channels;
procedure update_FAVchannel_last(dataf:precord_chat_favorite; datas:precord_displayed_channel);
procedure ShowChatFavorites;
procedure AutoJoinRooms;
procedure setAutoJoin(dataf:precord_chat_favorite; Value:boolean);




implementation

uses
helper_strings,helper_unicode,ufrmmain,helper_datetime,
vars_global,helper_channellist;



procedure ShowChatFavorites;
var
reg: Tregistry;
begin
with ares_frmmain do begin

  reg := tregistry.create;
  with reg do begin
   openkey(areskey,true);
   if valueexists('ChatRoom.PanelFavHeight') then vars_global.chat_favorite_height := readinteger('ChatRoom.PanelFavHeight')
    else vars_global.chat_favorite_height := 200;
   closekey;
   destroy;
  end;
  if vars_global.chat_favorite_height>panel_chat.Height-100 then vars_global.chat_favorite_height := panel_chat.height-100;


  if treeview_chat_favorites.rootnodecount=0 then load_favorite_channels;

end;

end;

procedure save_favorite_channel(dataf:precord_chat_favorite; oldip: Cardinal=0; oldport:word=0);
var
reg: Tregistry;
str,oldkeyname: string;
buffer: array [0..1023] of char;
begin

 reg := tregistry.create;
 with reg do begin

  if ((oldip<>0) and (oldport<>0)) then begin   //remove old entry...
    oldkeyname := bytestr_to_hexstr(int_2_dword_string(dataf^.ip)+int_2_word_string(dataf^.port));
    if openkey(areskey+'\ChatFavorites\',false) then begin
       if keyexists(oldkeyname) then
        deletekey(oldkeyname);
     closekey;
    end;
  end;

  openkey(areskey+'\ChatFavorites\'+bytestr_to_hexstr(int_2_dword_string(dataf^.ip)+int_2_word_string(dataf^.port)),true);

  writeinteger('IP',dataf^.ip);
  //writeinteger('IPInt',dataf^.alt_ip);
  writeinteger('Port',dataf^.port);
  writeinteger('Last',dataf^.last_joined);
  writeinteger('Lo',dataf^.locrc);
  writeinteger('CInTpc',integer(dataf^.has_colors_intopic));
  writeinteger('AutoJoin',integer(dataf^.autojoin));
  
  if length(dataf^.name)>2 then begin
   move(dataf^.name[1],buffer,length(dataf^.name));
   writebinarydata('Name',buffer,length(dataf^.name));
  end;

  if length(dataf^.topic)>2 then begin
   if length(dataf^.topic)<sizeof(buffer) then begin
    move(dataf^.topic[1],buffer,length(dataf^.topic));
    writebinarydata('Topic',buffer,length(dataf^.topic));
   end;
  end;

  if length(dataf^.stripped_topic)>2 then begin
   str := widestrtoutf8str(dataf^.stripped_topic);
   if length(str)<sizeof(buffer) then begin
    move(str[1],buffer,length(str));
    writebinarydata('STopic',buffer,length(str));
   end;
  end;

  closekey;
  destroy;
 end;
end;

procedure setAutoJoin(dataf:precord_chat_favorite; Value:boolean);
var
reg: Tregistry;
begin
reg := tregistry.create;
 with reg do begin
  openkey(areskey+'\ChatFavorites\'+bytestr_to_hexstr(int_2_dword_string(dataf^.ip)+int_2_word_string(dataf^.port)),true);
  writeinteger('AutoJoin',integer(Value));
  closekey;
  destroy;
 end;
end;

procedure update_FAVchannel_last(dataf:precord_chat_favorite; datas:precord_displayed_channel);
var
reg: Tregistry;
node:pCmtVNode;
begin
try

if dataf<>nil then begin


 dataf^.last_joined := DelphiDateTimeToUnix(now);

 reg := tregistry.create;
 with reg do begin
  openkey(areskey+'\ChatFavorites\'+bytestr_to_hexstr(int_2_dword_string(dataf^.ip)+int_2_word_string(dataf^.port)),true);
  writeinteger('Last',dataf^.last_joined);
  closekey;
  destroy;
 end;


end else
if datas<>nil then begin


  reg := tregistry.create;
   with reg do begin
    if not openkey(areskey+'\ChatFavorites\'+bytestr_to_hexstr(int_2_dword_string(datas^.ip)+int_2_word_string(datas^.port)),false) then begin
      closekey;
      destroy;
      exit;
    end;
    writeinteger('Last',DelphiDateTimeToUnix(now));
    closekey;
    destroy;


    if ares_frmmain.treeview_chat_favorites.rootnodecount>0 then begin  //upgrade data?
      node := ares_frmmain.treeview_chat_favorites.getfirst;
      while (node<>nil) do begin
         dataf := ares_frmmain.treeview_chat_favorites.getdata(node);
         if dataf^.ip=datas^.ip then
          if dataf^.port=datas^.port then begin
             dataf^.last_joined := DelphiDateTimeToUnix(now);
             if ares_frmmain.btn_chat_fav.down then ares_frmmain.treeview_chat_favorites.invalidatenode(node);
           break;
          end;
       node := ares_frmmain.treeview_chat_favorites.getnext(node);
      end;
    end;


 end;


end;

except
end;
end;


procedure AutoJoinRooms;
var
 reg: Tregistry;

 ip: Cardinal;
 port,locrc: Word;
 lun_to,lun_got: Integer;
 buffer: array [0..1023] of char;

 chname,chtopic,str: string;
 stripped_topic: WideString;
 datas:precord_displayed_channel;
 has_colors_intopic: Boolean;
 list: TStringList;
begin

 reg := tregistry.create;
 with reg do begin
  if not openkey(areskey+'\ChatFavorites\',false) then begin
   closekey;
   destroy;
   exit;
  end;

  list := tStringList.create;
  getkeynames(list);

  while (list.count>0) do begin
    closekey;
    openkey(areskey+'\ChatFavorites\'+list.strings[0],true);
     list.delete(0);

    if not valueexists('AutoJoin') then continue;
    if readinteger('AutoJoin')<>1 then continue;


      ip := readinteger('IP');
      port := readinteger('Port');

      if valueexists('Name') then begin
        lun_to := GetDataSize('Name');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('Name',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(chname,lun_got);
            move(buffer,chname[1],lun_got);
           end;
         end;
      end;

      if valueexists('Topic') then begin
        lun_to := GetDataSize('Topic');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('Topic',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(chtopic,lun_got);
            move(buffer,chtopic[1],lun_got);
           end;
         end;
      end;

       if valueexists('STopic') then begin
        lun_to := GetDataSize('STopic');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('STopic',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(str,lun_got);
            move(buffer,str[1],lun_got);
            stripped_topic := utf8strtowidestr(str);
           end;
         end;
      end;

      locrc := readinteger('Lo');
      has_colors_intopic := (readinteger('CInTpc')=1);

       datas := AllocMem(sizeof(record_displayed_channel));
        datas^.ip := ip;
        datas^.port := port;
        datas^.language := '';
        datas^.name := chname;
        datas^.topic := chtopic;
        datas^.locrc := locrc;
        datas^.stripped_topic := stripped_topic;
        datas^.has_colors_intopic := has_colors_intopic;
        datas^.enableJSTemplate := vars_global.chat_enabled_remoteJSTemplate;

        helper_channellist.join_channel(datas);

        datas^.name := '';
        datas^.topic := '';
        datas^.stripped_topic := '';
        FreeMem(datas,sizeof(record_displayed_channel));

  end;

  closekey;
  destroy;

  list.Free;
 end;
 
end;

procedure load_favorite_channels;
var
reg: Tregistry;
buffer: array [0..1023] of char;
list: TStringList;
node:pCmtVNode;
dataf:precord_chat_favorite;
lun_to,lun_got: Integer;
str: string;
fautoJoin: Boolean;
begin

 reg := tregistry.create;
 with reg do begin
  if not openkey(areskey+'\ChatFavorites\',false) then begin
   closekey;
   destroy;
   exit;
  end;

  list := tStringList.create;
  getkeynames(list);

  while (list.count>0) do begin
    closekey;
    openkey(areskey+'\ChatFavorites\'+list.strings[0],true);
     list.delete(0);

    if valueexists('AutoJoin') then fautoJoin := (readinteger('AutoJoin')=1)
     else fautoJoin := False;

     node := ares_frmmain.treeview_chat_favorites.AddChild(nil);
      dataf := ares_frmmain.treeview_chat_favorites.getdata(node);
      dataf^.ip := readinteger('IP');
     // dataf^.alt_ip := readinteger('IPInt');
      dataf^.last_joined := readinteger('Last');
      dataf^.port := readinteger('Port');
      dataf^.locrc := readinteger('Lo');
      dataf^.has_colors_intopic := (readinteger('CInTpc')=1);
      dataf^.autoJoin := fautojoin;

       if valueexists('Name') then begin
        lun_to := GetDataSize('Name');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('Name',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(dataf^.name,lun_got);
            move(buffer,dataf^.name[1],lun_got);
           end;
         end;
      end;

      if valueexists('Topic') then begin
        lun_to := GetDataSize('Topic');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('Topic',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(dataf^.topic,lun_got);
            move(buffer,dataf^.topic[1],lun_got);
           end;
         end;
      end;

       if valueexists('STopic') then begin
        lun_to := GetDataSize('STopic');
        if lun_to>0 then
         if lun_to<sizeof(buffer) then begin
           lun_got := ReadBinaryData('STopic',buffer,lun_to);
           if lun_got=lun_to then begin
            SetLength(str,lun_got);
            move(buffer,str[1],lun_got);
            dataf^.stripped_topic := utf8strtowidestr(str);
           end;
         end;
      end;

  end;

  list.Free;
  closekey;
  destroy;
 end;

end;


end.