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

unit uWhatImListeningTo;

interface

uses
 windows,umediar;

 procedure UpdateWhatImListeningTo(strTitle,strArtist,strAlbum: string; enabled:boolean = true); overload;
 procedure UpdateWhatImListeningTo(strIn: string; radioName: string); overload;
 procedure UpdateWhatImListeningTo(mp3: TmpegAudio); overload;
 function StripMsnIllegalChars(strIn: string): string;

// var
// stringBuffer: array [0..127] of WideChar;

implementation

uses
 const_win_messages,ufrmMain,sysutils,vars_global,helper_strings,helper_registry,helper_channellist,const_ares;


procedure UpdateWhatImListeningTo(mp3: TmpegAudio);
var
 title,artist,album: string;
begin
if not vars_global.check_opt_chat_whatsong_checked then exit;

title := '';
artist := '';
album := '';

if mp3.Valid then begin

 if mp3.ID3v2.Exists then begin
  title := mp3.id3v2.title;
  artist := mp3.id3v2.artist;
  album := mp3.id3v2.album;
 end;

 if mp3.ID3v1.Exists then begin
  if length(title)=0 then title := mp3.id3v1.title;
  if length(artist)=0 then artist := mp3.id3v1.artist;
  if length(album)=0 then album := mp3.id3v1.album;
 end;

end;

 if ((length(title)=0) or
    (length(artist)=0)) then UpdateWhatImListeningTo(vars_global.caption_player,'')
  else begin
     vars_global.caption_player := artist+' - '+title;
    UpdateWhatImListeningTo(title,artist,'');
  end;
end;

procedure UpdateWhatImListeningTo(strIn: string; radioName: string);
var
 ind: Integer;
 artist,title: string;
begin
if not vars_global.check_opt_chat_whatsong_checked then exit;

strIn := StripMsnIllegalChars(strIn);
radioName := StripMsnIllegalChars(radioName);

 ind := pos(' - ',strIn);

 if ind>0 then begin
  artist := Trim(copy(strIn,1,ind-1));
  title := Trim(copy(strIn,ind+3,length(strIn)));

  if length(title)=0 then begin
   title := copy(radioName,1,30);
  end;
  
  UpdateWhatImListeningTo(title,artist,'');
 end else begin
   if strIn='' then UpdateWhatImListeningTo(radioName,'','')
    else UpdateWhatImListeningTo(strIn,'','');
 end;
 
end;

function StripMsnIllegalChars(strIn: string): string;
begin
result := strIn;

while (pos('\0',result)>0) do
 Result := copy(result,1,pos('\0',result)-1) +
         copy(result,pos('\0',result)+2,length(result));

while (pos('http://',lowercase(result))>0) do
 Result := copy(result,1,pos('http://',lowercase(result))-1)+
         copy(result,pos('http://',lowercase(result))+7,length(result));

end;

procedure UpdateWhatImListeningTo(strTitle,strArtist,strAlbum: string; enabled:boolean = true);
var
 //handleMSN: THandle;
// structCopy: TCopyDataStruct;
 stringChat: string;
begin

 // Flush the array.
// FillChar(stringBuffer,SizeOf(stringBuffer),#0);

 strTitle := Trim(copy(strTitle,1,90));
  strArtist := Trim(copy(strArtist,1,90));
   stralbum := Trim(copy(strAlbum,1,90));
   stringChat := '';
 // The first Music can be changed to Games, Office, or Empty.
  if ((length(strTitle)>0) and (length(strArtist)>0) and (length(strAlbum)>0)) then begin
  // StringToWideChar('\0Music\0'+inttostr(integer(enabled))+'\0'+'{1} - {2} - {0}'+'\0'+strTitle+'\0'+strArtist+'\0'+strAlbum+'\0'+'WMContentID'+#0,@stringBuffer[0],128);
   stringChat := strTitle+' - '+strArtist+' - '+strAlbum;
 end else
 if ((length(strTitle)>0) and (length(strArtist)>0)) then begin
 // StringToWideChar('\0Music\0'+inttostr(integer(enabled))+'\0'+'{1} - {0}'+'\0'+strTitle+'\0'+strArtist+'\0'+'WMContentID'+#0,@stringBuffer[0],128);
  stringChat := strTitle+' - '+strArtist;
 end else begin
     if length(strTitle)>0 then begin
     // StringToWideChar('\0Music\0'+inttostr(integer(enabled))+'\0'+'{0} {1}'+'\0'+strTitle+'\0\0WMContentID'+#0,@stringBuffer[0],128);
      stringChat := strTitle;
     end else
     if length(strArtist)>0 then begin
     // StringToWideChar('\0Music\0'+inttostr(integer(enabled))+'\0'+'{1} {0}'+'\0\0'+strArtist+'\0WMContentID'+#0,@stringBuffer[0],128);
      stringChat := strArtist;
     end else begin
      if enabled then exit;
     // StringToWideChar('\0Music\0'+inttostr(integer(enabled))+'\0'+'{1} {0}'+'\0\0\0WMContentID'+#0,@stringBuffer[0],128);
      stringChat := '';
     end;
  end;

 //if list_chatchan_visual.count>0 then begin //send this in chatrooms as well
 if high(ares_frmmain.panel_chat.panels)>0 then begin
  if length(stringChat)>0 then helper_channellist.broadCastChildChatrooms('PERSMSG'+chr(7)+stringChat+CHRNULL)
   else helper_channellist.broadCastChildChatrooms('PERSMSG'+get_regString('Personal.CustomMessage')+CHRNULL);
 end;

{ // Set up the structure to hold the WM_COPYDATA and set the values.
 FillChar(structCopy,SizeOf(TCopyDataStruct),#0);
 with structCopy do
 begin
   cbData := SizeOf(stringBuffer);
   dwData := $547;
   lpData := @stringBuffer[0];
 end;

 // Iterate through (for poloygamy) the MSN windows sending WM_COPYDATA to each
 handleMSN := FindWindowEx(0,0,'MsnMsgrUIManager',nil);
 while handleMSN <> 0 do
 begin
   SendMessage(handleMSN,WM_COPYDATA,0,Integer(@structCopy));

   handleMSN := FindWindowEx(0,handleMSN,'MsnMsgrUIManager',nil);
 end; }
end;

end.
 