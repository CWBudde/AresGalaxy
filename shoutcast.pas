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
shoutcast player
works with AsyncEx filter by Martin Offenwanger
 Mail: coder@dsplayer.de
 Web:  http://www.dsplayer.de
see also AsyncExTypes.pas
}

unit shoutcast;

interface

uses
 classes,classes2,ActiveX,DirectShow9,AsyncExTypes,DSUtil,sysutils,mmsystem;

 type
 Precord_radio_station=^record_radio_station;
 record_radio_station=record
 rtime: Cardinal;
 radioName: string;
 radioUrl: string;
 end;


procedure OpenRadioUrl(const furl: string);
procedure ShoutCast_NillVars;
procedure SetRipStream(shouldRip:boolean);
procedure AddMenuRadio(const radioName: string; const url: string); overload;
procedure AddMenuRadio(addStation:Precord_radio_station=nil); overload; // add latest radios

procedure OpenRadioStation(const RadioName: string);
procedure UpdateCaptionShoutcast(BufferState:integer=-2);
procedure arlnk_addradio(url: string);
procedure export_radioArlnk(url: string);

function SortRadioNewerFirst(item1,item2: Pointer): Integer;
function SortRadioAlphaFirst(item1,item2: Pointer): Integer;
procedure connectMp3;
procedure connectAac;


var
 isPlayingShoutcast,isConnectingShoutcast,isReconnecting: Boolean;
 radioURL: string;
 titleStream: string;
 CurrentPos: Cardinal;
 hasEverStartedRip: Boolean;
 RenderError: Boolean;
 renderingMp3Stream: Boolean;

implementation

uses
 helper_player,ufrmmain,vars_localiz,vars_global,tntwindows,helper_datetime,
 registry,const_ares,tntmenus,helper_unicode,windows,helper_registry,
 bittorrentstringfunc,helper_diskio,helper_sorting,tntsystem;

function SortRadioNewerFirst(item1,item2: Pointer): Integer;
var
radio1,radio2:Precord_radio_station;
begin
 radio1 := item1;
 radio2 := item2;
 Result := integer(radio2^.rtime) - integer(radio1^.rtime);
end;

function SortRadioAlphaFirst(item1,item2: Pointer): Integer;
var
radio1,radio2:Precord_radio_station;
begin
 radio1 := item1;
 radio2 := item2;
 Result := compareText(radio1^.radioName,radio2^.radioName);
end;

procedure arlnk_addradio(url: string);
begin
if length(url)<10 then exit;

if url[length(url)]='/' then delete(url,length(url),1);

OpenRadioUrl(url);
end;

procedure export_radioArlnk(url: string);
var
str: string;
nomefile: WideString;
stream: Thandlestream;
begin
str := const_ares.STR_ARLNK_LOWER+'Radio:'+url;

 tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);
 nomefile := formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' hashlink temp.txt';



      stream := MyFileOpen(data_path+'\Temp\'+nomefile,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream=nil then exit;
      with stream do write(str[1],length(str));
      FreeHandleStream(stream);
      
     Tnt_ShellExecuteW(ares_frmmain.handle,'open',pwidechar(widestring('notepad')),pwidechar(data_path+'\Temp\'+nomefile),nil,SW_SHOW);
end;

procedure OpenRadioUrl(const furl: string);
var
hr:HResult;
tmpUrl: string;
begin
try

  tmpUrl := trim(furl);
  
  if pos('icyx://',lowercase(tmpUrl))=1 then begin
    delete(tmpUrl,1,7);
    tmpUrl := 'http://'+tmpUrl;
  end;

  if pos('http://',lowercase(tmpUrl))=0 then tmpUrl := 'http://'+tmpUrl;
  tmpUrl := copy(tmpUrl,pos('http://',lowercase(tmpUrl)),length(tmpUrl));
  if length(tmpUrl)<10 then exit;

  if helper_player.m_GraphBuilder<>nil then helper_player.Player_NilLAll;

  shoutcast.radioUrl := tmpUrl;

  vars_global.caption_player := GetLangStringW(STR_CONNECTING)+'  '+radioUrl;
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;

  isvideoplaying := False;
  isReconnecting := False;
  isPlayingShoutcast := True;
  isConnectingShoutcast := True;
  shoutcast.RenderError := False;
  ares_frmmain.trackbar_player.TrackbarEnabled := False;
  ares_frmmain.trackbar_player.position := 0;
  titleStream := '';
  ares_frmmain.mplayerpanel1.TimeCaption := '';
  ares_frmmain.mplayerpanel1.urlCaption := '';
  ares_frmmain.mplayerpanel1.url := '';
  shoutcast.CurrentPos := 0;
  hasEverStartedRip := False;
  ares_frmmain.ExportHashlink7.visible := False;
  helper_player.player_actualfile := '';
  file_visione_da_copiatore := ''; // allow to cycle through playlist cause we're not previewing files

  if imgscnlogo<>nil then imgscnlogo.visible := True;

hr := CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC,TGUID(IID_IGraphBuilder), m_GraphBuilder);
 if FAILED(HR) then begin
  vars_global.caption_player := 'GraphBuilder Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
  exit;
 end;

hr := helpeR_player.m_GraphBuilder.QueryInterface(IID_IMediaControl, helper_player.m_MediaControl);
 if FAILED(HR) then begin
  vars_global.caption_player := 'MediaControl Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
 end;

hr := CoCreateInstance(CLSID_AsyncEx, nil, CLSCTX_INPROC,IID_IBaseFilter, helper_player.m_AsyncEx);
 if FAILED(HR) then begin
  vars_global.caption_player := 'BTAsyncEx Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
 end;
// create mp3 filters

hr := helper_player.m_AsyncEx.QueryInterface(IID_AsyncExControl,m_AsyncExControl);
 if FAILED(HR) then begin
  vars_global.caption_player := 'AsyncExControl Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
 end;

  if assigned(m_AsyncExControl) then begin
    hr := m_AsyncExControl.SetCallBack(ares_frmmain);
    if FAILED(hr) then begin
      vars_global.caption_player := 'AsyncExControl SetCallBack Error: '+DSUtil.GetErrorString(HR);
      ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
      exit;
    end;
  end;

 if ares_frmmain.Enable1.checked then SetRipStream(ares_frmmain.Enable1.checked);


  if assigned(m_AsyncExControl) then begin
      if FAILED(m_AsyncExControl.SetConnectToURL(PChar(shoutcast.radioUrl),PChar(const_ares.APPNAME+' '+vars_global.versioneares))) then begin
       //vars_global.caption_player := 'SetConnectToURL Error '+DSUtil.GetErrorString(HR);
        //ares_frmmain.panel_player_capt.capt := vars_global.caption_player;
        shoutcast.RenderError := True;
        exit;
      end;
  end;

  if assigned(helper_player.m_AsyncEx) then begin
    hr := helper_player.m_AsyncEx.FindPin(PinID, helper_player.m_Pin);
     if FAILED(hr) then begin
        shoutcast.RenderError := True;
        vars_global.caption_player := 'AsyncEx PinID Error: '+DSUtil.GetErrorString(HR);
        ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
        exit;
     end;
  end;

  if assigned(helper_player.m_GraphBuilder) then begin
    hr := helper_player.m_GraphBuilder.AddFilter(helper_player.m_AsyncEx,StringToOleStr(FilterID));
     if FAILED(hr) then begin
        shoutcast.RenderError := True;
        vars_global.caption_player := 'GraphBuilder FilterID Error: '+DSUtil.GetErrorString(HR);
        ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
        exit;
     end;
  end;



except
end;
end;

procedure connectAac;
begin
renderingMp3Stream := False;
end;

procedure connectMp3;
var
 hr:hresult;
begin
renderingMp3Stream := True;

hr := CoCreateInstance(CLSID_Mp3Dec, nil, CLSCTX_INPROC,IID_IBaseFilter, helper_player.m_Mp3Dec);
 if FAILED(HR) then begin
  vars_global.caption_player := 'Mp3Dec Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
  shoutcast.RenderError := True;
  exit;
 end;
 
hr := CoCreateInstance(CLSID_Mpeg1Split, nil, CLSCTX_INPROC,IID_IBaseFilter, helper_player.m_Mpeg1Splitter);
 if FAILED(HR) then begin
  vars_global.caption_player := 'Mpeg1Splitter create Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
  shoutcast.RenderError := True;
  exit;
 end;

 hr := helper_player.m_GraphBuilder.AddFilter(helper_player.m_Mpeg1Splitter, 'MPEG1 Splitter');
 if FAILED(HR) then begin
  vars_global.caption_player := 'Mpeg1Splitter Error: '+DSUtil.GetErrorString(HR);
  ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
  shoutcast.RenderError := True;
  exit;
 end;

  if assigned(helper_player.m_Mp3Dec) then begin
    hr := helper_player.m_GraphBuilder.AddFilter(helper_player.m_Mp3Dec,StringToOleStr('MP3 Dec'));
     if FAILED(hr) then begin
        shoutcast.RenderError := True;
        vars_global.caption_player := 'GraphBuilder MP3 Decoder Error: '+DSUtil.GetErrorString(hr);
        ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
        exit;
     end;
  end;

end;

procedure ShoutCast_NillVars;
begin

 isPlayingShoutcast := False;

  radioURL := '';
  titleStream := '';

  isConnectingShoutcast := False;

  hasEverStartedRip := False;

  //ares_frmmain.Riptodisk1.visible := False;
  ares_frmmain.ExportHashlink7.visible := False;
end;

procedure SetRipStream(shouldRip:boolean);
var
Riptitle: WideString;
//hr:HResult;
begin
if not assigned(helper_player.m_AsyncExControl) then exit;

if shouldRip then tntwindows.tnt_createdirectoryW(pwidechar(vars_global.myshared_folder+'\Radio'),nil);

RipTitle := titleStream;
if length(RipTitle)=0 then RipTitle := 'Rip '+formatdatetime('yyyy mm dd hh:nn',now);

 //hr := 
 helper_player.m_AsyncExControl.SetRipStream(shouldRip, PWideChar(vars_global.myshared_folder+'\Radio'), PWideChar(Riptitle));
end;

procedure AddMenuRadio(const radioName: string; const url: string);
var
str,urlstr: string;
radioSt:precord_radio_station;
begin
 if length(url)<6 then exit;
 if length(radioName)=0 then exit;
 if radioName='N/A' then exit;

 urlStr := copy(url,pos('http://',lowercase(url)),length(url));

 str := RadioName;
 if length(str)>50 then delete(str,51,length(str));

   radioSt := AllocMem(sizeof(record_radio_station));
    radioSt^.rtime := DelphiDateTimeToUnix(now);
    radioSt^.RadioName := str;
    radioSt^.RadioUrl := UrlStr;

  while (ares_frmmain.ListentoRadio1.Count>5) do ares_frmmain.ListentoRadio1.Delete(5);

 AddMenuRadio(radioSt);

end;

procedure AddMenuRadio(addStation:Precord_radio_station=nil);  // add latest radios
var
reg: Tregistry;
list: TStringList;
listS: TMylist;
item: TTntMenuItem;
i,h,ind: Integer;
str,strUrl,strName: string;
rtime: Cardinal;
radioSt:Precord_radio_station;
canAdd: Boolean;
begin
reg := Tregistry.create;


list := tStringList.create;
listS := tmylist.create;
if addStation<>nil then listS.add(addStation);

with reg do begin
 openkey(areskey+'\Radio',true);

 getValueNames(list);

 for i := 0 to list.count-1 do begin
  str := list[i];

  StrUrl := ReadString(str);
          deleteValue(str);

  ind := pos(chr(254)+chr(254),str);
  if ind>0 then begin
   strName := copy(str,ind+2,length(str));
   rtime := strToIntDef(copy(str,1,ind-1),0);
  end else begin
   StrName := str;
   rtime := DelphiDateTimeToUnix(now);
  end;


  canAdd := True;
  for h := 0 to listS.count-1 do begin
   radioSt := listS[h];
   if radioSt^.RadioName=strName then begin
    canAdd := False;
    break;
   end;
   if radioSt^.radioUrl=strUrl then begin
    canAdd := False;
    break;
   end;
  end;

  if canAdd then begin
   radioSt := AllocMem(sizeof(record_radio_station));
    radioSt^.rtime := rtime;
    radioSt^.RadioName := strName;
    radioSt^.RadioUrl := strUrl;
   listS.add(radioSt);
  end;
 end;

 list.Free;


 listS.sort(SortRadioNewerFirst);  
 while (listS.count>6) do begin
  radioSt := listS[6];
           listS.delete(6);
  radioSt^.radioName := '';
  radioSt^.radioUrl := '';
  FreeMem(radioSt,sizeof(record_radio_station));
 end;
 
 listS.sort(SortRadioAlphaFirst); // alphabetically or latest first?


 while (listS.count>0) do begin
  radioSt := listS[0];
           listS.delete(0);

  if length(radioSt^.radioName)>50 then delete(radioSt^.radioName,51,length(radioSt^.radioName));

  ares_frmmain.n20.visible := True;

  item := TTntMenuItem.Create(ares_frmmain);
   item.Caption := utf8strtowidestr(radioSt^.radioName);
   item.OnClick := ufrmmain.ares_frmmain.radiostationclick;
  ares_frmmain.ListentoRadio1.Add(item);

    writestring(inttostr(radioSt^.rtime)+
                chr(254)+chr(254)+
                radioSt^.radioName,
                radioSt^.radioUrl);

  radioSt^.radioName := '';
  radioSt^.radioUrl := '';
  FreeMem(radioSt,sizeof(record_radio_station));

 end;


 closekey;
 destroy;
end;

 listS.Free;
end;

procedure OpenRadioStation(const RadioName: string);
var
reg: Tregistry;
str,strName,radioUrl: string;
list: TStringList;
i,ind: Integer;
begin
reg := Tregistry.create;
list := TStringList.create;

with reg do begin
 openkey(areskey+'\Radio',true);

 getValueNames(list);

 for i := 0 to list.count-1 do begin
  str := list[i];

  ind := pos(chr(254)+chr(254),str);

   if ind>0 then begin
    strName := copy(str,ind+2,length(str));

    if strName=RadioName then begin
     radioUrl := ReadString(str);
     OpenRadioUrl(radioUrl);
     deleteValue(str);
     writestring(inttostr(DelphiDateTimeToUnix(now))+
                 chr(254)+chr(254)+
                 strName,radioUrl);
     break;
    end;

   end;

 end;





  closekey;
  destroy;
 end;
list.Free;

end;


procedure UpdateCaptionShoutcast(BufferState:integer=-2);
begin
vars_global.caption_player := AddBoolString('Connecting to '+shoutcast.radioUrl+'  ',(BufferState=-1))+
                            AddBoolString('Buffering '+inttostr(BufferState)+'% '+shoutcast.radioUrl+'  ',(BufferState>=0))+
                            shoutcast.titleStream+
                            AddBoolString('  ('+ares_frmmain.mplayerpanel1.urlCaption+')',(length(ares_frmmain.mplayerpanel1.urlCaption)>0) and (length(ares_frmmain.mplayerpanel1.url)=0));
ares_frmmain.mplayerpanel1.wCaption := vars_global.caption_player;
end;


end.