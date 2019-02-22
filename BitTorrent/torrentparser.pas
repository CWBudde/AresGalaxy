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
.torrent file parser
this code is part of 'MakeTorrent' at http://sourceforge.net/projects/burst/
}

unit TorrentParser;

interface

uses
  SysUtils, Classes, Windows, StrUtils, Contnrs, Classes2, Securehash, Hashes;


type
  TTorrentPiece = class(TObject)
    hashValue: array [0..19] of Byte;
    constructor create(const hash: string);
  end;

  TBitTorrentBitfield=array of boolean;
  TTorrentSubFile = class(TObject)
  private
    _Name: string;
    _Path: string;
    _Filename: string;
    _Length: Int64;
    _Offset: Int64;
    _Left: Int64;
  public
    property Name: string read _Name write _Name;
    property Path: string read _Path write _Path;
    property Length: Int64 read _Length;
    property Offset: Int64 read _Offset;
    property Left: Int64 read _Left write _Left;
    property Filename: string read _Filename write _Filename;
    constructor Create(const Name: string; const Path: string; Length: Int64; Offset: Int64);
  end;

  TTorrentParser = class(TObject)
  private

    _Name: string;
    _Comment: string;
    _FSize: Int64;
    _Date: TDateTime;
    _Count: Integer;
    _Err: TStringList;
    
    _HashValue: string;
    _Encoding: string;
    _Multifile: Boolean;
    _Files: TObjectList;
  public
    _Announce: string;
    _Announces: TStringList;
    Pieces: array of TTorrentPiece;
    PieceLength: Integer;
    isPrivate: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure Clear();
    function Load(Stream: TStream): Boolean;
    procedure Init(const Announce, Name, Comment, HashValue: string; Size: Int64; Multifile:Boolean);

    property Name: string read _Name write _Name;
    property Date: TDateTime read _Date write _Date;
    property Size: Int64 read _FSize;
    property Count:Integer read _Count;
    //property Tree: TObjectHash read _Tree;
    property Errors: TStringList read _Err;
    property Comment: string read _Comment write _Comment;
    property HashValue: string read _HashValue;
    property Multifile: Boolean read _Multifile;
    property Files: TObjectList read _Files write _Files;
  end;

implementation

uses
  BDecode, helper_datetime, BittorrentStringfunc, helper_unicode;


constructor TTorrentPiece.create(const Hash: string);
begin
  move(hash[1], hashValue[0], Sizeof(HashValue));
end;



{ TTorrentSubFile }

constructor TTorrentSubFile.Create(const Name, Path: String; Length: Int64; Offset: Int64);
begin
  _Name := Name;
  _Path := Path;
  _Length := Length;
  _Offset := Offset;
  _Left := Length;
  
  inherited Create();
end;

{ TTorrentFile }

procedure TTorrentParser.Clear();
var
i: Integer;
begin
  _Announce := '';
  _Name := '';
  _FSize := 0;
  _Count := 0;
  _Files.Clear();
 // _Tree.Clear();
  _Err.Clear();
  for i := Low(Pieces) to High(Pieces) do FreeAndNil(Pieces[i]);
  SetLength(Pieces,0);
  _Multifile := False;
end;

constructor TTorrentParser.Create();
begin
  _Files := TObjectList.Create();
 // _Tree := TObjectHash.Create();
  _Err := TStringList.Create();
  _Announce := '';
  _Announces := TStringList.create;
  inherited Create();
end;

destructor TTorrentParser.Destroy();
begin
  Clear();
  FreeAndNil(_Files);
  FreeAndNil(_Err);
  FreeAndNil(_Announces);
  _Announce := '';
  _Encoding := '';
  inherited;
end;

procedure TTorrentParser.Init(const Announce, Name, Comment, HashValue: string; Size: Int64; Multifile:Boolean);
begin
  _Name := Name;
  _Comment := Comment;
  _HashValue := HashValue;
  _FSize := Size;
  _Multifile := Multifile;
  _Date := Now;
  _Announce := Announce;
end;

function TTorrentParser.Load(Stream: TStream): Boolean;
var
  info,thisfile: TObjectHash;
  files,path,trackers,trackerurllist: TObjectList;
  fp,fn,thistrackerurl: string;
  i,j,pcount: Integer;
  sz,fs,fo: Int64;
  sha: TSHA1;
  r: Boolean;
  o: TObject;
  s: string;
  _Tree: TObjectHash;
  lenR,lenLoop: Integer;
  buffer: array [0..1023] of Byte;
begin
result := False;

  Clear();
  r := False;
  info := nil;
  sz := 0;
  fo := 0;
  try
    try
      sha := TSHA1.Create();
      

      o := bdecodeStream(Stream);

      if Assigned(o) then begin
        _Tree := o as TObjectHash;
        
        if(_Tree.Exists('announce')) then _Announce := ((_Tree['announce'] as TIntString).StringPart)
         else begin
          _Err.Add('Corrupt File: Missing "announce" segment');
          info := _tree;
        end;

       if(_Tree.Exists('announce-list')) then begin
             trackers := _Tree['announce-list'] as TObjectList;
              for i := 0 to trackers.Count-1 do begin
                trackerurllist := trackers[i] as TObjectList;
                thistrackerurl := (trackerurllist[0] as TIntString).Stringpart;
                _Announces.add(thistrackerurl);
              end;
       end;

        if _Tree.Exists('comment') then _Comment := (_Tree['comment'] as TIntString).StringPart;

        if _Tree.Exists('creation date') then _Date := UnixTimeToDateTime((_Tree['creation date'] as TIntString).IntPart);
        if _Tree.Exists('encoding') then begin
         _Encoding := (_Tree['encoding'] as TIntString).StringPart;
        end;
        if info=nil then
          if _Tree.Exists('info') then begin
          info := _Tree['info'] as TObjectHash;
        end;
        if info<>nil then begin
          if info.Exists('name') then begin
            _Name := (info['name'] as TIntString).StringPart;
            if copy(_Name,system.length(_Name)-7,8)='.torrent' then _Name := copy(_Name,0,system.length(_Name)-8);
          end else _Err.Add('Corrupt File: Missing "info.name" segment');

          if info.Exists('piece length') then PieceLength := (info['piece length'] as TIntString).IntPart
           else _Err.Add('Corrupt File: Missing "info.piece length" segment');

         if info.Exists('private') then isPrivate := ((info['private'] as TIntString).IntPart=1)
          else isPrivate := False;

          if info.Exists('pieces') then begin
            fp := (info['pieces'] as TIntString).StringPart;
            pcount := System.Length(fp) div 20;
            SetLength(Pieces,pcount);
            for i := 0 to pcount-1 do begin
              s := copy(fp,(i * 20) + 1,20);
              Pieces[i] := TTorrentPiece.Create(s);
            end;
          end else _Err.Add('Corrupt File: Missing "info.pieces" segment');

          if info.Exists('length') then begin // single-file archive
            sz := (info['length'] as TIntString).IntPart;
            _Count := 1;
            _Files.Add(TTorrentSubFile.Create(_Name,'',sz,Int64(0)));
          end else begin
            if(info.Exists('files')) then begin
              _Multifile := True;
              files := info['files'] as TObjectList;
              for i := 0 to files.Count-1 do begin
                thisfile := files[i] as TObjectHash;
                if thisfile.Exists('length') then fs := (thisfile['length'] as TIntString).IntPart
                else begin
                  fs := Int64(0);
                  _Err.Add('Corrupt File: files[' + IntToStr(i) + '] is missing a "length" segment');
                end;
                fp := '';
                fn := '';

                if(thisfile.Exists('path')) then begin
                  path := thisfile['path'] as TObjectList;
                  for j := 0 to path.Count - 2 do
                    fp := fp+(path[j] as TIntString).StringPart+'\';
                  if path.Count>0 then fn := (path[path.Count-1] as TIntString).StringPart;
                end else _Err.Add('Corrupt File: files['+IntToStr(i)+'] is missing a "path" segment');
                
                _Files.Add(TTorrentSubFile.Create(fn,fp,fs,sz));
                sz := sz+fs;
              end;
              _Count := _Files.Count;
            end else _Err.Add('Corrupt File: Missing both "info.length" and "info.files" segments (should have one or the other)');

          end;

          if (_Tree.Exists('_info_start') and _Tree.Exists('_info_length')) then begin
            fo := Stream.Position;
            Stream.Seek((_Tree['_info_start'] as TIntString).IntPart,soFromBeginning);
            fs := (_Tree['_info_length'] as TIntString).IntPart;
            
          end else begin
           stream.seek(0,soFromBeginning);
           fs := stream.size;
          end;
          
            while (fs>0) do begin
              lenLoop := fs;
              if LenLoop>sizeof(Buffer) then LenLoop := sizeof(buffer);
              LenR := Stream.Read(Buffer,lenLoop);
              sha.Transform(buffer,lenR);
              dec(fs,LenR);
            end;

            sha.Complete;
            _HashValue := sha.hashvalue;
            Stream.Seek(fo,soFromBeginning);
          end;

       // end else _Err.Add('Corrupt File: Missing "info" segment');

        _FSize := sz;
        _Tree.Free;

        r := True;
      end else _Err.Add('Error parsing file; does not appear to be valid bencoded metainfo');


    finally
      FreeAndNil(sha);
    end;

  except
    _Err.Add('Something bad happened while trying to load the file, probably corrupt metainfo');
  end;

  Result := r;
end;

end.
