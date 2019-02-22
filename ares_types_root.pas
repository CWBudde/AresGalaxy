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
application structures are listed here
}

unit ares_types_root;

interface

uses
  Windows;

type
  TNetStreamType=(
    nsTRoot,
    nsTMovies,
    nsTTv,
    nsTUnknown
  );

  PRecordNetStreamChannel=^RecordNetStreamChannel;
  RecordNetStreamChannel=record
    language: string;
    streamUrl: WideString;
    streamPlaypath: WideString;
    webCapt: WideString;
    webUrl: string;
    capt: WideString;
  end;

  TDataNodeType = (
    dnt_Null,
    dnt_download,
    dnt_PartialUpload,
    dnt_PartialDownload,
    dnt_downloadSource,
    dnt_upload,
    dnt_bittorrentMain,
    dnt_bittorrentSource
  );

  PRecord_data_node=^Record_data_node;
  Record_data_node=record
    m_type: TDataNodeType;
    data: Pointer;
  end;
  
  TArguments = array of string;

  PRecord_httpheader_item=^Record_httpheader_item;
  Record_httpheader_item=record
    key: string;
    value: string;
  end;

  // string structure for library categs
  precord_string = ^record_string;
  record_string = record
    str: string;
    counter: Integer;
    crc: Word;
    len: Byte;
  end;

  HINTERNET = pointer;

  //thread client, structure for HASH source/resume search
  precord_download_hash=^record_download_hash;
  record_download_hash = record
    hash: string;
    crchash: Word;
    handle_download: Cardinal;
  end;

  //thread_client avoid some dead loop while adding/removing hosts in discovery
  precord_nodo_provato=^record_nodo_provato;
  record_nodo_provato=record
    host: string;
    when: Cardinal;
    isBad: Boolean;
  end;

  TSocks_type = (
    SoctNone,
    SoctSock4,
    SoctSock5
  );

  // string parse helper structure
  precord_title_album_artist=^record_title_album_artist;
  record_title_album_artist=record
    artist,
    album,
    title: WideString;
  end;

implementation

end.

