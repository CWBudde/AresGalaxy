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
some lame filtering (used by thread_client to filter some listing)
TODO: add an importable file to allow custom filtering
}

unit helper_filtering;

interface

uses
sysutils,classes2,classes,windows;

function is_copyrighted_content(const key: string): Boolean;
function is_teen_content(const key: string): Boolean;
function str_isWebSpam(const strin: string): Boolean;
function strip_spamcomments(comments: string): string;
procedure init_keywfilter(const filterbranch: string; list: TMyStringList);
function is_filtered_text(const lostr: string; filtered_strings: TMyStringList): Boolean;


implementation

uses
 helper_diskio,vars_global,const_ares;


function is_filtered_text(const lostr: string; filtered_strings: TMyStringList): Boolean;
var
i: Integer;
lofiltered: string;
begin
result := True;

 for i := 0 to filtered_strings.count-1 do begin
  lofiltered := filtered_strings[i];

  if pos(lofiltered,lostr)<>0 then begin
   exit;
  end;

 end;

 Result := False;
end;

procedure init_keywfilter(const filterbranch: string; list: TMyStringList);
var
 stream: Thandlestream;
 str,keywordstr: string;
 buffer: array [0..1023] of char;
 previous_len,red: Integer;
begin

if filterbranch='ChanListFilter' then begin
 with list do begin
  add('sex');
  add('racis');
  add('porn');
  add('shemale');
  add('fetish');
  add('incest');
  add('gangbang');
  add('masochist');
  add('razors');
 end;
end;

    stream := MyFileOpen(vars_global.app_path+'\Data\'+filterbranch+'.txt',ARES_READONLY_BUT_SEQUENTIAL);
    if stream=nil then exit;

   with stream do begin
   str := '';
    while (position<size) do begin
      red := read(buffer,sizeof(buffer));
      if red<1 then break;

      previous_len := length(str);
      SetLength(str,previous_len+red);
      move(buffer,str[previous_len+1],red);
    end;
   end;
   FreeHandleStream(stream);

    if length(str)>0 then begin

     if copy(str,1,3)=chr($ef)+chr($bb)+chr($bf) then delete(str,1,3); //strip utf-8 header
     while (pos('#',str)=1) do delete(str,1,pos(CRLF,str)+1);


      while (length(str)>0) do begin
         if pos(',',str)>0 then begin
           keywordstr := copy(str,1,pos(',',str)-1);
           delete(str,1,pos(',',str));
         end else begin
           keywordstr := str;
           str := '';
         end;
         list.add(keywordstr);
      end;
    end;

   
end;


function strip_spamcomments(comments: string): string;
var
locom: string;
begin
result := '';
   locom := lowercase(comments);
    if pos('quickmusic',locom)=0 then
     if pos('supermusic',locom)=0 then
      if pos('elitemusic',locom)=0 then
       if pos('musictiger',locom)=0 then
        if pos('mp3finder',locom)=0 then
         if pos('mp3advance',locom)=0 then
          if pos('simplemp3',locom)=0 then
           if pos('popgal',locom)=0 then
            if pos('mp3',locom)=0 then
             if pos('.com',locom)=0 then
              if pos('www.',locom)=0 then
              Result := comments;
end;

function str_isWebSpam(const strin: string): Boolean;
begin
 Result := False;
 if pos('.com',strin)<>0 then Result := true else
  if pos('www.',strin)<>0 then Result := true else
   if pos('http',strin)<>0 then Result := True;
end;

function is_copyrighted_content(const key: string): Boolean;
begin

  if length(key)<12 then begin
   Result := False;
   exit;
  end;

  Result := True;

   if pos('nathan stone',key)<>0 then exit;

  Result := False;
end;

function is_teen_content(const key: string): Boolean;
 var
 lokey: string;
begin

  if length(key)<=2 then begin
   Result := False;
   exit;
  end;
  Result := True;
  lokey := lowercase(key);
          if pos('teen',lokey)<>0 then exit else
          if pos('deflor',lokey)<>0 then exit else
          if pos('pedo',lokey)<>0 then exit else
          if pos('bambi',lokey)<>0 then exit else
          if pos('tiny',lokey)<>0 then exit else
          //if pos('r@ygold',lokey)<>0 then exit else
          //if pos('roygold',lokey)<>0 then exit else
          if pos('ygold',lokey)<>0 then exit else
          if pos('child',lokey)<>0 then exit else
          if pos('underage',lokey)<>0 then exit else
          if pos('kiddy',lokey)<>0 then exit else
          if pos('kiddie',lokey)<>0 then exit else
          if pos('lolita',lokey)<>0 then exit else
          if pos('incest',lokey)<>0 then exit else
          if pos('rape',lokey)<>0 then exit else
          if pos('legal',lokey)<>0 then exit else
          if pos('babysitter',lokey)<>0 then exit else
           if pos('1yo',lokey)<>0 then exit else
           if pos('2yo',lokey)<>0 then exit else
           if pos('3yo',lokey)<>0 then exit else
           if pos('4yo',lokey)<>0 then exit else
           if pos('5yo',lokey)<>0 then exit else
           if pos('6yo',lokey)<>0 then exit else
           if pos('7yo',lokey)<>0 then exit else
           if pos('8yo',lokey)<>0 then exit else
           if pos('9yo',lokey)<>0 then exit else
           if pos('0yo',lokey)<>0 then exit else
           if pos('petit',lokey)<>0 then exit;
          Result := False;
  end;

end.