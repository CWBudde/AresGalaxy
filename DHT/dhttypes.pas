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

*****************************************************************
 The following delphi code is based on Emule (0.46.2.26) Kad's implementation http://emule.sourceforge.net
 and KadC library http://kadc.sourceforge.net/
*****************************************************************
 }

{
Description:
DHT types
}

unit DhtTypes;

interface

uses
  Classes, Classes2, Int128, SysUtils, Contnrs, DhtUtils, Windows, Keywfunc,
  Blcksock;

type
  precord_DHT_keywordFilePublishReq=^record_DHT_keywordFilePublishReq;
  record_DHT_keywordFilePublishReq=record
    keyW: string;
    crc: Word;  // last two bytes of 20 byte sha1
    fileHashes: TMyStringList;
  end;

  precord_dht_source=^record_dht_source;
  record_dht_source=record
    ip: Cardinal;
    raw: string;
    lastSeen: Cardinal;
    prev,next:precord_dht_source;
  end;

  precord_dht_outpacket=^record_dht_outpacket;
  record_dht_outpacket=record
    destIP: Cardinal;
    destPort: Word;
    buffer: string;
  end;

  precord_DHT_firewallcheck=^record_DHT_firewallcheck;
  record_DHT_firewallcheck=record
    RemoteIp: Cardinal;
    RemoteUDPPort: Word;
    RemoteTCPPort: Word;
    started: Cardinal;
    sockt:HSocket;
  end;

  precord_DHT_hash=^record_dht_hash;
  record_dht_hash=record
    hashValue: array [0..19] of Byte;
    crc: Word;
    count: Word; // number of items
    lastSeen: Cardinal;
    firstSource:precord_dht_source;
    prev,next:precord_dht_hash;
  end;

  precord_DHT_hashfile=^record_DHT_hashfile;
  record_DHT_hashfile=record
    HashValue: array [0..19] of Byte;
  end;

  precord_dht_storedfile=^record_dht_storedfile;
  record_dht_storedfile=record
    hashValue: array [0..19] of Byte;
    crc: Word;

    amime: Byte;
    ip: Cardinal; //last publish source is available immediately
    port: Word;

    count: Word;
    lastSeen: Cardinal;

    fsize: Int64;
    param1,param3: Cardinal;
    info: string;

    numKeywords: Byte;
    keywords:PWordsArray;

    prev,next:precord_dht_storedfile;
  end;

  PDHTKeyWordItem=^TDHTKeyWordItem;
  TDHTKeywordItem = packed record
    share     : precord_dht_storedfile;
    prev, next: PDHTKeywordItem;
  end;

  PDHTKeyword = ^TDHTKeyword;
  TDHTKeyword = packed record // structure that manages one keyword
    keyword   : array of char; // keyword
    count     : cardinal;
    crc       : word;
    firstitem : PDHTKeywordItem; // pointer to first full item
    prev, next: PDHTKeyword; // pointer to previous and next PKeyword items in global list
  end;

type
  tdhtsearchtype=(
    UNDEFINED,
    NODE,
    NODECOMPLETE,
    KEYWORD,
    STOREFILE,
    STOREKEYWORD,
    FINDSOURCE
  );


implementation

end.
