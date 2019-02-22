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
related to mime types handling
}

unit helper_mimetypes;

interface

uses
sysutils,helper_unicode,vars_localiz,const_ares;

const
SHARED_AUDIO_EXT='.mp3 .vqf .wav .voc .mod .ra .ram .mid .au .ogg .mp2 .mpc .ape .flac .shn .mmf .m4p .m4a .aiff';  //.wma
SHARED_VIDEO_EXT='.flv .mp4 .mkv .avi .mov .mpg .3gp .divx .fli .flc .lsf .m1v .mpa .mpe .mpeg .ogm .qt .rm .ts .viv .vivo .wmv';
SHARED_IMAGE_EXT='.bmp .gif .jpeg .jpg .png .psd .psp .tga .tif .tiff';
SHARED_DOCUMENT_EXT='.book .doc .hlp .lit .pdf .pps .ppt .ps .rtf .txt .wri';
SHARED_OTHER_EXT='.ace .ashdisc .arescol .b5i .bin .bwi .c2d .cab .cdi .cif .cue .cif .daa .dxf .dwg .fla .fcd .gz .hqx .img .iso '+
                 '.lcd .md5 .mdf .mds .msi .ncd .nes .nrg .p01 .pdi .pxi .rar .ratdvd .rip .rmp .rv .sit .swf .tar .torrent .vcd .zip .wsz';
SHARED_SOFTWARE_EXT='.bat .com .exe .msi .pif  .scr .vbs';
STR_EXE_EXTENS='.asf .dll .exe .ocx .gz .doc .sit .tar .jpg .js .lnk .msi .wmv .reg .wma .wm .vbs .com .rar .zip'; //dangerous when in generic search

function mediatype_to_str(tipo: Byte): string;
function mediatype_to_widestr(tipo: Byte): WideString;
function DocumentToContentType(FileName : wideString) : String;
function extstr_to_mediatype(const estensione: string): Byte;
function clienttype_to_shareservertype(tipo: Byte): Byte;
function clienttype_to_searchservertype(tipo: Byte): Byte;
function amime_to_imgindexsmall(amime: Byte): Byte;
function serversharetype_to_clienttype(tipo: Byte): Byte;   //tipo 8 è passato per intendere solo other


implementation

function clienttype_to_searchservertype(tipo: Byte): Byte;   //tipo 8 è passato per intendere solo other
begin
case tipo of
 ARES_MIME_MP3: Result := 1;
 ARES_MIME_AUDIOOTHER1: Result := 1;
 ARES_MIME_SOFTWARE: Result := 2; //soft
 ARES_MIME_AUDIOOTHER2: Result := 1;
 ARES_MIME_VIDEO: Result := 3; //video
 ARES_MIME_DOCUMENT: Result := 4; //doc
 ARES_MIME_IMAGE: Result := 5;    //image
 ARES_MIMESRC_OTHER: Result := ARES_MIME_OTHER else    //other clientSRC 8->0 serverType
 Result := ARES_MIMESRC_ALL255;
end;
end;

function serversharetype_to_clienttype(tipo: Byte): Byte;   //tipo 8 è passato per intendere solo other
begin
 case tipo of
  1: Result := ARES_MIME_MP3;
  2: Result := ARES_MIME_SOFTWARE; //soft
  3: Result := ARES_MIME_VIDEO; //video
  4: Result := ARES_MIME_DOCUMENT; //doc
  5: Result := ARES_MIME_IMAGE;    //image
   else Result := ARES_MIME_OTHER;
 end;
end;

function clienttype_to_shareservertype(tipo: Byte): Byte;
begin
case tipo of
 ARES_MIME_MP3: Result := 1;
 ARES_MIME_AUDIOOTHER1: Result := 1;
 ARES_MIME_SOFTWARE: Result := 2; //soft
 ARES_MIME_AUDIOOTHER2: Result := 1;
 ARES_MIME_VIDEO: Result := 3; //video
 ARES_MIME_DOCUMENT: Result := 4; //doc
 ARES_MIME_IMAGE: Result := 5 else    //image
  Result := ARES_MIME_OTHER; // 0 servertype
 end;
end;

function amime_to_imgindexsmall(amime: Byte): Byte;
begin
 case amime of
  ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2: Result := 3;
  ARES_MIME_VIDEO: Result := 4;
  ARES_MIME_DOCUMENT: Result := 7;
  ARES_MIME_SOFTWARE: Result := 6;
  ARES_MIME_IMAGE: Result := 5
   else Result := 2;
 end;
end;

function extstr_to_mediatype(const estensione: string): Byte;
begin
  if pos(estensione,SHARED_AUDIO_EXT)>0 then Result := ARES_MIME_MP3 else  // video
  if pos(estensione,SHARED_VIDEO_EXT)>0 then Result := ARES_MIME_VIDEO else
  if pos(estensione,SHARED_IMAGE_EXT)>0 then Result := ARES_MIME_IMAGE else
  if pos(estensione,SHARED_DOCUMENT_EXT)>0 then Result := ARES_MIME_DOCUMENT else
  if pos(estensione,SHARED_SOFTWARE_EXT)>0 then Result := ARES_MIME_SOFTWARE else Result := ARES_MIME_OTHER;
end;

function DocumentToContentType(FileName : wideString) : String;
var
    Ext : String;
begin
    Ext := LowerCase(ExtractFileExt(widestrtoutf8str(FileName)));
    if (ext='.aif') or (ext='.aiff') or (ext='.aifc') then Result := 'audio/x-aiff' else
    if ((Ext = '.asf') or (ext='.asx')) then Result := 'video/x-ms-asf' else
    if (ext='.au') or (ext='.snd') then Result := 'audio/basic' else
    if ext='.avi' then Result := 'video/x-msvideo' else
    if ext='.book' then Result := 'application/book' else
    if ext='.bmp' then Result := 'image/x-MS-bmp' else
    if Ext = '.doc' then Result := 'application/msword' else
    if (ext='.exe') or (ext='.bin') then Result := 'application/octet-stream' else
    if ext='.flv' then Result := 'video/x-flv' else
    if Ext = '.gif' then Result := 'image/gif' else
    if ext='.gz' then Result := 'application/x-gzip' else
    if Ext = '.hlp' then Result := 'application/winhlp' else
    if (Ext = '.htm') or (Ext = '.html') or (ext ='.mdl') then Result := 'text/html' else
    if (ext='.jpg') or (ext='.jpeg') then Result := 'image/jpeg' else
    if ((ext='.mid') or (ext='.midi')) then Result := 'audio/midi' else
    if ext='.mp4' then Result := 'video/mp4' else
    if ((ext='.mov') or (ext='.qt')) then Result := 'video/quicktime' else
    if ext='.mp3' then Result := 'audio/x-mpeg' else
    if (ext='.mpeg') or (ext='.mpg') or (result='.mpe') then Result := 'video/mpeg' else
    if ext='.pdf' then Result := 'application/pdf' else
    if (ext='.qt') or (ext='.mov') then Result := 'video/quicktime' else
    if ext='.rm' then Result := 'audio/x-pn-realaudio-plugin' else
    if ext='.rtf' then Result := 'application/rtf' else
    if ext='.sit' then Result := 'application/x-stuffit' else
    if ext='.swf' then Result := 'application/x-shockwave-flash' else
    if ext='.tar' then Result := 'application/x-tar' else
    if (ext='.tiff') or (ext='.tif') then Result := 'image/tiff' else
    if Ext = '.txt' then Result := 'text/plain' else
    if ext='.zip' then Result := 'application/x-zip-compressed' else
    if ext='.wav' then Result := 'audio/x-wav' else

        Result := 'application/octet-stream';
end;

function mediatype_to_str(tipo: Byte): string;
 begin
    case tipo of
     ARES_MIME_OTHER: Result := GetLangStringA(STR_OTHERMIME);
     ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2: Result := GetLangStringA(STR_AUDIOMIME);
     ARES_MIME_SOFTWARE: Result := GetLangStringA(STR_SOFTWAREMIME);
     ARES_MIME_VIDEO: Result := GetLangStringA(STR_VIDEOMIME);
     ARES_MIME_DOCUMENT: Result := GetLangStringA(STR_DOCUMENTMIME);
     ARES_MIME_IMAGE: Result := GetLangStringA(STR_IMAGEMIME) else
     Result := GetLangStringA(STR_OTHERMIME);
    end;
  end;

 function mediatype_to_widestr(tipo: Byte): WideString;
 begin
   case tipo of
     ARES_MIME_OTHER: Result := GetLangStringW(STR_OTHERMIME);
     ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2: Result := GetLangStringW(STR_AUDIOMIME);
     ARES_MIME_SOFTWARE: Result := GetLangStringW(STR_SOFTWAREMIME);
     ARES_MIME_VIDEO: Result := GetLangStringW(STR_VIDEOMIME);
     ARES_MIME_DOCUMENT: Result := GetLangStringW(STR_DOCUMENTMIME);
     ARES_MIME_IMAGE: Result := GetLangStringW(STR_IMAGEMIME) else
      Result := GetLangStringW(STR_OTHERMIME);
     end;
  end;

end.
