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
meta and media informations extraction routines
}

unit umediar;

interface

uses
 Classes, SysUtils, utility_ares,windows,helper_unicode,helper_diskio,helper_strings,ares_types,ares_objects,math,
 TntSysUtils,  DirectDraw, Directshow9, Dspack,olectrls,SyncObjs,comobj,ShlObj,graphics,forms,tntwindows,classes2;


function ricava_dati_mov(nomefile: WideString):record_audioinfo;
function ricava_dati_avi(nomefile: WideString):record_audioinfo;
function get_flv_infos(filename: WideString):record_audioinfo;
function ricava_dati_psp(nomefile: WideString):record_audioinfo;
function ricava_dati_psd(nomefile: WideString):record_audioinfo;
procedure estrai_titolo_artista_album_da_stringa(risultato:precord_title_album_artist; titlez: WideString);
function GetMediaInfo(FileName: WideString): TDSMediaInfo;
function ottieni_data_exe(nome: WideString): string;
function MyGetModuleFileNameW(hModule: HINST; lpFilename: PWideChar; nSize: DWORD): widestring;
function get_app_name: WideString;



///////////////////////////////////////////////IMAGES
const
TIFF_WIDTH = 256;
TIFF_HEIGHT = 257;
TIFF_BITSPERSAMPLE = 258;
TIFF_BYTE = 1;
TIFF_WORD = 3;
TIFF_DWORD = 4;

const
  { Tag ID }
  ID3V1_ID = 'TAG';                                                   { ID3v1 }
  APE_ID = 'APETAGEX';                                                  { APE }

  { Size constants }
  ID3V1_TAG_SIZE = 128;                                           { ID3v1 tag }
  APE_TAG_FOOTER_SIZE = 32;                                  { APE tag footer }
  APE_TAG_HEADER_SIZE = 32;                                  { APE tag header }

  { First version of APE tag }
  APE_VERSION_1_0 = 1000;

  { Max. number of supported tag fields }
  APE_FIELD_COUNT = 8;

  { Names of supported tag fields }
  APE_FIELD: array [1..APE_FIELD_COUNT] of string =
    ('Title', 'Artist', 'Album', 'Track', 'Year', 'Genre',
     'Comment', 'Copyright');

     const
  { Twin VQ header ID }
  TWIN_ID = 'TWIN';

  { Max. number of supported tag-chunks }
  TWIN_CHUNK_COUNT = 6;

  { Names of supported tag-chunks }
  TWIN_CHUNK: array [1..TWIN_CHUNK_COUNT] of string =
    ('NAME', 'COMT', 'AUTH', '(c) ', 'FILE', 'ALBM');

type
  { TwinVQ chunk header }
  TwinVQChunkHeader = record
    ID: array [1..4] of Char;                                      { Chunk ID }
    Size: Cardinal;                                              { Chunk size }
  end;

  { File header data - for internal use }
  TwinVQHeaderInfo = record
    { Real structure of TwinVQ file header }
    ID: array [1..4] of Char;                                 { Always "TWIN" }
    Version: array [1..8] of Char;                               { Version ID }
    Size: int64;                                             { Header size }
    Common: TwinVQChunkHeader;                                { Common chunk header }
    ChannelMode: Cardinal;               { Channel mode: 0 - mono, 1 - stereo }
    BitRate: Cardinal;                                       { Total bit rate }
    SampleRate: Cardinal;                                 { Sample rate (khz) }
    SecurityLevel: Cardinal;                                       { Always 0 }
    { Extended data }
    FileSize: int64;                                   { File size (bytes) }
    Tag: array [1..TWIN_CHUNK_COUNT] of string;             { Tag information }
  end;
{*******************************************************************************
image type enumeration
*******************************************************************************}
type
  TImageType = (itUnknown, itGIF, itJPEG, itPNG, itBMP, itPCX, itTIFF);

  type
  { APE tag data - for internal use }
  APETagInfo = record
    { Real structure of APE footer }
    ID: array [1..8] of Char;                             { Always "APETAGEX" }
    Version: Integer;                                           { Tag version }
    Size: Int64;                                { Tag size including footer }
    Fields: Integer;                                       { Number of fields }
    Flags: Integer;                                               { Tag flags }
    Reserved: array [1..8] of Char;                  { Reserved for later use }
    { Extended data }
    DataShift: Byte;                                { Used if ID3v1 tag found }
    FileSize: Int64;                                    { File size (bytes) }
    Field: array [1..APE_FIELD_COUNT] of string;    { Information from fields }
  end;
{*******************************************************************************
class declaration
*******************************************************************************}
type
  TDCImageInfo = Class(TObject)
  private
    ImageFile: THandleStream;
    FWidth: integer;
    FHeight: integer;
    FDepth: integer;
    FImageType: TImageType;
    FFileSize: int64;
    procedure ReadPNG;
    procedure ReadGIF;
    procedure ReadBMP;
    procedure ReadPCX;
    procedure ReadLETIFF;
    procedure ReadBETIFF;
    procedure ReadJPEG;
    procedure ResetValues;
    function Swap32(Value: Integer): Integer;

  public
    property Width: integer read FWidth;
    property Height: integer read FHeight;
    property Depth: integer read FDepth;
    property ImageType: TImageType read FImageType;
    property FileSize: int64 read FFileSize;
    procedure ReadFile(const FileName: wideString);

end;




////////////////////////////////////////////AUDIO
const
  MAX_MUSIC_GENRES = 148;                       { Max. number of music genres }
  DEFAULT_GENRE = 255;                              { Index for default genre }

  { Used with VersionID property }
  TAG_VERSION_1_0 = 1;                                { Index for ID3v1.0 tag }
  TAG_VERSION_1_1 = 2;                                { Index for ID3v1.1 tag }

var
  MusicGenre: array [0..MAX_MUSIC_GENRES - 1] of string;        { Genre names }

 type
  { Real structure of ID3v1 tag }
  TagRecord = record
    Header: array [1..3] of Char;                { Tag header - must be "TAG" }
    Title: array [1..30] of Char;                                { Title data }
    Artist: array [1..30] of Char;                              { Artist data }
    Album: array [1..30] of Char;                                { Album data }
    Year: array [1..4] of Char;                                   { Year data }
    Comment: array [1..30] of Char;                            { Comment data }
    Genre: Byte;                                                 { Genre data }
  end;

type
  { Used in TID3v1 class }
  //String04 = string[4];                          { String with max. 4 symbols }
 // String30 = string[30];                        { String with max. 30 symbols }

  { Class TID3v1 }
  TID3v1 = class(TObject)
    private
      { Private declarations }
      FExists: Boolean;
      FVersionID: Byte;
      FTitle: String;
      FArtist: String;
      FAlbum: String;
      FYear: String;
      FComment: String;
      FTrack: Byte;
      FGenreID: Byte;

      procedure FSetTitle(const NewTitle: String);
      procedure FSetArtist(const NewArtist: String);
      procedure FSetAlbum(const NewAlbum: String);
      procedure FSetYear(const NewYear: String);
      procedure FSetComment(const NewComment: String);
      procedure FSetTrack(const NewTrack: Byte);
      procedure FSetGenreID(const NewGenreID: Byte);
      function FGetGenre: string;
      function ReadTag(var TagData: TagRecord; stream: Thandlestream): Boolean;
      function convert_oem(strin: array of char; max:integer=30): string;

    public
      { Public declarations }
      constructor Create;                                     { Create object }
      procedure ResetData;                                   { Reset all data }
      function ReadFromFile(stream: Thandlestream): Boolean;      { Load tag }
    //  function RemoveFromFile(const FileName: string): Boolean;  { Delete tag }
     // function SaveToFile(const FileName: string): Boolean;        { Save tag }
      property Exists: Boolean read FExists;              { True if tag found }
      property VersionID: Byte read FVersionID;                { Version code }
      property Title: String read FTitle write FSetTitle;      { Song title }
      property Artist: String read FArtist write FSetArtist;  { Artist name }
      property Album: String read FAlbum write FSetAlbum;      { Album name }
      property Year: String read FYear write FSetYear;               { Year }
      property Comment: String read FComment write FSetComment;   { Comment }
      property Track: Byte read FTrack write FSetTrack;        { Track number }
      property GenreID: Byte read FGenreID write FSetGenreID;    { Genre code }
      property Genre: string read FGetGenre;                     { Genre name }
  end;


 const
  TAG_VERSION_2_2 = 2;                               { Code for ID3v2.2.x tag }
  TAG_VERSION_2_3 = 3;                               { Code for ID3v2.3.x tag }
  TAG_VERSION_2_4 = 4;                               { Code for ID3v2.4.x tag }

  const
  { ID3v2 tag ID }
  ID3V2_ID = 'ID3';

  { Max. number of supported tag frames }
  ID3V2_FRAME_COUNT = 16;

  { Names of supported tag frames (ID3v2.3.x & ID3v2.4.x) }
  ID3V2_FRAME_NEW: array [1..ID3V2_FRAME_COUNT] of string =
    ('TIT2', 'TPE1', 'TALB', 'TRCK', 'TYER', 'TCON', 'COMM', 'TCOM', 'TENC',
     'TCOP', 'TLAN', 'WXXX', 'TDRC', 'TOPE', 'TIT1', 'TOAL');

  { Names of supported tag frames (ID3v2.2.x) }
  ID3V2_FRAME_OLD: array [1..ID3V2_FRAME_COUNT] of string =
    ('TT2', 'TP1', 'TAL', 'TRK', 'TYE', 'TCO', 'COM', 'TCM', 'TEN',
     'TCR', 'TLA', 'WXX', 'TOR', 'TOA', 'TT1', 'TOT');

  { Max. tag size for saving }
  ID3V2_MAX_SIZE = 4096;

  { Unicode ID }
  UNICODE_ID = #1;

type
  { Frame header (ID3v2.3.x & ID3v2.4.x) }
  FrameHeaderNew = record
    ID: array [1..4] of Char;                                      { Frame ID }
    Size: cardinal; //Int64;                                    { Size excluding header }
    Flags: Word;                                                      { Flags }
  end;

  { Frame header (ID3v2.2.x) }
  FrameHeaderOld = record
    ID: array [1..3] of Char;                                      { Frame ID }
    Size: array [1..3] of Byte;                       { Size excluding header }
  end;

  { ID3v2 header data - for internal use }
  ID3v2TagInfo = record
    { Real structure of ID3v2 header }
    ID: array [1..3] of Char;                                  { Always "ID3" }
    Version: Byte;                                           { Version number }
    Revision: Byte;                                         { Revision number }
    Flags: Byte;                                               { Flags of tag }
    Size: array [1..4] of Byte;                   { Tag size excluding header }
    { Extended data }
    FileSize: Int64;                                    { File size (bytes) }
    Frame: array [1..ID3V2_FRAME_COUNT] of string;  { Information from frames }
    NeedRewrite: Boolean;                           { Tag should be rewritten }
    PaddingSize: Integer;                              { Padding size (bytes) }
  end;

type
  { Class TID3v2 }
  TID3v2 = class(TObject)
    private
      { Private declarations }
      FExists: Boolean;
      FVersionID: Byte;
      FSize: Integer;
      FTitle: string;
      FArtist: string;
      FAlbum: string;
      FTrack: Word;
      FTrackString: string;
      FYear: string;
      FGenre: string;
      FComment: string;
      FComposer: string;
      FEncoder: string;
      FCopyright: string;
      FLanguage: string;
      FLink: string;
      function ReadHeader(var Tag: ID3v2TagInfo; stream: Thandlestream): Boolean;
      procedure ReadFramesNew(var Tag: ID3v2TagInfo; stream: Thandlestream);
      procedure ReadFramesOld(var Tag: ID3v2TagInfo; stream: Thandlestream);
      function GetANSI(const Source: string): string;
      function GetContent(const Content1, Content2: string): string;
      function ExtractTrack(const TrackString: string): Word;
      function ExtractYear(const YearString, DateString: string): string;
      function ExtractGenre(const GenreString: string): string;
      function ExtractText(const SourceString: string; LanguageID: Boolean): string;
    //  procedure BuildHeader(var Tag: ID3v2TagInfo);

      procedure FSetTitle(const NewTitle: string);
      procedure FSetArtist(const NewArtist: string);
      procedure FSetAlbum(const NewAlbum: string);
      procedure FSetTrack(const NewTrack: Word);
      procedure FSetYear(const NewYear: string);
      procedure FSetGenre(const NewGenre: string);
      procedure FSetComment(const NewComment: string);
      procedure FSetComposer(const NewComposer: string);
      procedure FSetEncoder(const NewEncoder: string);
      procedure FSetCopyright(const NewCopyright: string);
      procedure FSetLanguage(const NewLanguage: string);
      procedure FSetLink(const NewLink: string);

      function GetTagSize(const Tag: ID3v2TagInfo): Integer;
      procedure SetTagItem(const ID, Data: string; var Tag: ID3v2TagInfo);
      function Swap32(const Figure: Integer): Integer;

    public
      { Public declarations }
      constructor Create;                                     { Create object }
      procedure ResetData;                                   { Reset all data }
      function ReadFromFile(stream: Thandlestream): Boolean;      { Load tag }
     // function SaveToFile(const FileName: string): Boolean;        { Save tag }
      //function RemoveFromFile(const FileName: string): Boolean;  { Delete tag }
      property Exists: Boolean read FExists;              { True if tag found }
      property VersionID: Byte read FVersionID;                { Version code }
      property Size: Integer read FSize;                     { Total tag size }
      property Title: string read FTitle write FSetTitle;        { Song title }
      property Artist: string read FArtist write FSetArtist;    { Artist name }
      property Album: string read FAlbum write FSetAlbum;       { Album title }
      property Track: Word read FTrack write FSetTrack;        { Track number }
      property TrackString: string read FTrackString; { Track number (string) }
      property Year: string read FYear write FSetYear;         { Release year }
      property Genre: string read FGenre write FSetGenre;        { Genre name }
      property Comment: string read FComment write FSetComment;     { Comment }
      property Composer: string read FComposer write FSetComposer; { Composer }
      property Encoder: string read FEncoder write FSetEncoder;     { Encoder }
      property Copyright: string read FCopyright write FSetCopyright;   { (c) }
      property Language: string read FLanguage write FSetLanguage; { Language }
      property Link: string read FLink write FSetLink;             { URL link }
  end;
   
type
  { Class TAPEtag }
  TAPEtag = class(TObject)
    private
      { Private declarations }
      FExists: Boolean;
      FVersion: Integer;
      FSize: Int64;
      FTitle: string;
      FArtist: string;
      FAlbum: string;
      FTrack: Byte;
      FYear: string;
      FGenre: string;
      FComment: string;
      FCopyright: string;
      procedure FSetTitle(const NewTitle: string);
      procedure FSetArtist(const NewArtist: string);
      procedure FSetAlbum(const NewAlbum: string);
      procedure FSetTrack(const NewTrack: Byte);
      procedure FSetYear(const NewYear: string);
      procedure FSetGenre(const NewGenre: string);
      procedure FSetComment(const NewComment: string);
      procedure FSetCopyright(const NewCopyright: string);
       function ReadFooter(stream: Thandlestream; var Tag: APETagInfo): Boolean;
    //   function ConvertFromUTF8(const Source: string): string;
       procedure SetTagItem(const FieldName, FieldValue: string; var Tag: APETagInfo);
       procedure ReadFields(stream: Thandlestream; var Tag: APETagInfo);
       function GetTrack(const TrackString: string): Byte;
   //    function TruncateFile(const FileName: string; TagSize: Integer): Boolean;
   //    procedure BuildFooter(var Tag: APETagInfo);
   //    function AddToFile(const FileName: string; TagData: TStream): Boolean;
  //     function SaveTag(const FileName: string; Tag: APETagInfo): Boolean;

    public
      { Public declarations }
      constructor Create;                                     { Create object }
      procedure ResetData;                                   { Reset all data }
      function ReadFromFile(stream: Thandlestream): Boolean;      { Load tag }
      //function RemoveFromFile(const FileName: string): Boolean;  { Delete tag }
      //function SaveToFile(const FileName: string): Boolean;        { Save tag }
      property Exists: Boolean read FExists;              { True if tag found }
      property Version: Integer read FVersion;                  { Tag version }
      property Size: Int64 read FSize;                     { Total tag size }
      property Title: string read FTitle write FSetTitle;        { Song title }
      property Artist: string read FArtist write FSetArtist;    { Artist name }
      property Album: string read FAlbum write FSetAlbum;       { Album title }
      property Track: Byte read FTrack write FSetTrack;        { Track number }
      property Year: string read FYear write FSetYear;         { Release year }
      property Genre: string read FGenre write FSetGenre;        { Genre name }
      property Comment: string read FComment write FSetComment;     { Comment }
      property Copyright: string read FCopyright write FSetCopyright;   { (c) }
  end;


  type
TFlacVorbisTag = class(TObject)
 private
  FTitle,
  FArtist,
  FAlbum,
  FGenre,
  FYear,
  FComment,
  FURL: string;
  FExists: Boolean;
  procedure ResetData;
  function parse_tags(strin: string): Boolean;
  function chars_2_dword(stringa: string): Integer;
  function ReadFromFile(stream: Thandlestream): Boolean;
 public
  constructor Create;
  property Title: string read FTitle;
  property Artist: string read FArtist;
  property Album: string read FAlbum;
  property Genre: string read FGenre;
  property Year: string read FYear;
  property Comment: string read FComment;
  property URL: string read FUrl;
  property Exists:boolean read FExists;
end;

type
  { Class TFLACfile }
  TFLACfile = class(TObject)
    private
      { Private declarations }
      FChannels: Byte;
      FSampleRate: Integer;
      FBitsPerSample: Byte;
      FFileLength: Integer;
      FSamples: Integer;
      FID3v1: TID3v1;
      FID3v2: TID3v2;
      FFlacVorbisTag: TFlacVorbisTag;
      procedure FResetData;
      function FIsValid: Boolean;
      function FGetDuration: Double;
      function FGetRatio: Double;
      function FGetBitrate: Integer;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property Channels: Byte read FChannels;            { Number of channels }
      property SampleRate: Integer read FSampleRate;       { Sample rate (hz) }
      property BitsPerSample: Byte read FBitsPerSample;     { Bits per sample }
      property FileLength: Integer read FFileLength;    { File length (bytes) }
      property Samples: Integer read FSamples;            { Number of samples }
      property ID3v1: TID3v1 read FID3v1;                    { ID3v1 tag data }
      property ID3v2: TID3v2 read FID3v2;                    { ID3v2 tag data }
      property Valid: Boolean read FIsValid;           { True if header valid }
      property Duration: Double read FGetDuration;       { Duration (seconds) }
      property Ratio: Double read FGetRatio;          { Compression ratio (%) }
      property Bitrate:integer read FGetBitrate;
      property FlacVorbisTag: TFlacVorbisTag read FFlacVorbisTag;
  end;


  const
  { Compression level codes }
  MONKEY_COMPRESSION_FAST = 1000;                               { Fast (poor) }
  MONKEY_COMPRESSION_NORMAL = 2000;                           { Normal (good) }
  MONKEY_COMPRESSION_HIGH = 3000;                          { High (very good) }
  MONKEY_COMPRESSION_EXTRA_HIGH = 4000;                   { Extra high (best) }

  { Compression level names }
  MONKEY_COMPRESSION: array [0..4] of string =
    ('Unknown', 'Fast', 'Normal', 'High', 'Extra High');

  { Format flags }
  MONKEY_FLAG_8_BIT = 1;                                        { Audio 8-bit }
  MONKEY_FLAG_CRC = 2;                            { New CRC32 error detection }
  MONKEY_FLAG_PEAK_LEVEL = 4;                             { Peak level stored }
  MONKEY_FLAG_24_BIT = 8;                                      { Audio 24-bit }
  MONKEY_FLAG_SEEK_ELEMENTS = 16;            { Number of seek elements stored }
  MONKEY_FLAG_WAV_NOT_STORED = 32;                    { WAV header not stored }

  { Channel mode names }
  MONKEY_MODE: array [0..2] of string =
    ('Unknown', 'Mono', 'Stereo');

type
  { Real structure of Monkey's Audio header }
  MonkeyHeader = record
    ID: array [1..4] of Char;                                 { Always "MAC " }
    VersionID: Word;                    { Version number * 1000 (3.91 = 3910) }
    CompressionID: Word;                             { Compression level code }
    Flags: Word;                                           { Any format flags }
    Channels: Word;                                      { Number of channels }
    SampleRate: Integer;                                   { Sample rate (hz) }
    HeaderBytes: Integer;                 { Header length (without header ID) }
    TerminatingBytes: Integer;                                { Extended data }
    Frames: Integer;                           { Number of frames in the file }
    FinalSamples: Integer;             { Number of samples in the final frame }
    PeakLevel: Integer;                              { Peak level (if stored) }
    SeekElements: Integer;              { Number of seek elements (if stored) }
  end;

  { Class TMonkey }
  TMonkey = class(TObject)
    private
      { Private declarations }
      FFileLength: Integer;
      FHeader: MonkeyHeader;
      FID3v1: TID3v1;
      FID3v2: TID3v2;
      FAPEtag: TAPEtag;
      procedure FResetData;
      function FGetValid: Boolean;
      function FGetVersion: string;
      function FGetCompression: string;
      function FGetBits: Byte;
      function FGetChannelMode: string;
      function FGetPeak: Double;
      function FGetSamplesPerFrame: Integer;
      function FGetSamples: Integer;
      function FGetBitrate: integer;
      function FGetDuration: Double;
      function FGetRatio: Double;
      function FGetSampleRate: Integer;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property FileLength: Integer read FFileLength;    { File length (bytes) }
      property Header: MonkeyHeader read FHeader;     { Monkey's Audio header }
      property ID3v1: TID3v1 read FID3v1;                    { ID3v1 tag data }
      property ID3v2: TID3v2 read FID3v2;                    { ID3v2 tag data }
      property APEtag: TAPEtag read FAPEtag;                   { APE tag data }
      property Valid: Boolean read FGetValid;          { True if header valid }
      property Version: string read FGetVersion;            { Encoder version }
      property Compression: string read FGetCompression;  { Compression level }
      property Bits: Byte read FGetBits;                    { Bits per sample }
      property ChannelMode: string read FGetChannelMode;       { Channel mode }
      property Peak: Double read FGetPeak;             { Peak level ratio (%) }
      property Samples: Integer read FGetSamples;         { Number of samples }
      property Bitrate:integer read FGetBitrate;
      property Duration: Double read FGetDuration;       { Duration (seconds) }
      property Ratio: Double read FGetRatio;          { Compression ratio (%) }
      property SampleRate:integer read FGetSampleRate;
  end;


  type
  { Class TMonkey }
  TMPCfile = class(TObject)
    private
      { Private declarations }
      FID3v1: TID3v1;
      FAPEtag: TAPEtag;
      FBitrate,
      FDuration,
      FSampleRate: Integer;
      Fvalid: Boolean;
      procedure FResetData;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property ID3v1: TID3v1 read FID3v1;                    { ID3v1 tag data }
      property APEtag: TAPEtag read FAPEtag;                   { APE tag data }
      property Bitrate:integer read FBitrate;
      property Duration: integer read FDuration;       { Duration (seconds) }
      property SampleRate:integer read FSampleRate;
      property Valid:boolean read FValid;
  end;


  ///////mp3
  const
  { Table for bit rates }
  MPEG_BIT_RATE: array [0..3, 0..3, 0..15] of Word =
    (
    { For MPEG 2.5 }
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0),
    (0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0),
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, 0)),
    { Reserved }
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
    { For MPEG 2 }
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0),
    (0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0),
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, 0)),
    { For MPEG 1 }
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 0),
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, 0),
    (0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 0))
    );

  { Sample rate codes }
  MPEG_SAMPLE_RATE_LEVEL_3 = 0;                                     { Level 3 }
  MPEG_SAMPLE_RATE_LEVEL_2 = 1;                                     { Level 2 }
  MPEG_SAMPLE_RATE_LEVEL_1 = 2;                                     { Level 1 }
  MPEG_SAMPLE_RATE_UNKNOWN = 3;                               { Unknown value }

  { Table for sample rates }
  MPEG_SAMPLE_RATE: array [0..3, 0..3] of Word =
    (
    (11025, 12000, 8000, 0),                                   { For MPEG 2.5 }
    (0, 0, 0, 0),                                                  { Reserved }
    (22050, 24000, 16000, 0),                                    { For MPEG 2 }
    (44100, 48000, 32000, 0)                                     { For MPEG 1 }
    );

  { VBR header ID for Xing/FhG }
  VBR_ID_XING = 'Xing';                                         { Xing VBR ID }
  VBR_ID_FHG = 'VBRI';                                           { FhG VBR ID }

  { MPEG version codes }
  MPEG_VERSION_2_5 = 0;                                            { MPEG 2.5 }
  MPEG_VERSION_UNKNOWN = 1;                                 { Unknown version }
  MPEG_VERSION_2 = 2;                                                { MPEG 2 }
  MPEG_VERSION_1 = 3;                                                { MPEG 1 }

  { MPEG version names }
  MPEG_VERSION: array [0..3] of string =
    ('MPEG 2.5', 'MPEG ?', 'MPEG 2', 'MPEG 1');

  { MPEG layer codes }
  MPEG_LAYER_UNKNOWN = 0;                                     { Unknown layer }
  MPEG_LAYER_III = 1;                                             { Layer III }
  MPEG_LAYER_II = 2;                                               { Layer II }
  MPEG_LAYER_I = 3;                                                 { Layer I }

  { MPEG layer names }
  MPEG_LAYER: array [0..3] of string =
    ('Layer ?', 'Layer III', 'Layer II', 'Layer I');

  { Channel mode codes }
  MPEG_CM_STEREO = 0;                                                { Stereo }
  MPEG_CM_JOINT_STEREO = 1;                                    { Joint Stereo }
  MPEG_CM_DUAL_CHANNEL = 2;                                    { Dual Channel }
  MPEG_CM_MONO = 3;                                                    { Mono }
  MPEG_CM_UNKNOWN = 4;                                         { Unknown mode }

  { Channel mode names }
  MPEG_CM_MODE: array [0..4] of string =
    ('Stereo', 'Joint Stereo', 'Dual Channel', 'Mono', 'Unknown');

  { Extension mode codes (for Joint Stereo) }
  MPEG_CM_EXTENSION_OFF = 0;                        { IS and MS modes set off }
  MPEG_CM_EXTENSION_IS = 1;                             { Only IS mode set on }
  MPEG_CM_EXTENSION_MS = 2;                             { Only MS mode set on }
  MPEG_CM_EXTENSION_ON = 3;                          { IS and MS modes set on }
  MPEG_CM_EXTENSION_UNKNOWN = 4;                     { Unknown extension mode }

  { Emphasis mode codes }
  MPEG_EMPHASIS_NONE = 0;                                              { None }
  MPEG_EMPHASIS_5015 = 1;                                          { 50/15 ms }
  MPEG_EMPHASIS_UNKNOWN = 2;                               { Unknown emphasis }
  MPEG_EMPHASIS_CCIT = 3;                                         { CCIT J.17 }

  { Emphasis names }
  MPEG_EMPHASIS: array [0..3] of string =
    ('None', '50/15 ms', 'Unknown', 'CCIT J.17');

  { Encoder codes }
  MPEG_ENCODER_UNKNOWN = 0;                                 { Unknown encoder }
  MPEG_ENCODER_XING = 1;                                               { Xing }
  MPEG_ENCODER_FHG = 2;                                                 { FhG }
  MPEG_ENCODER_LAME = 3;                                               { LAME }
  MPEG_ENCODER_BLADE = 4;                                             { Blade }
  MPEG_ENCODER_GOGO = 5;                                               { GoGo }
  MPEG_ENCODER_SHINE = 6;                                             { Shine }
  MPEG_ENCODER_QDESIGN = 7;                                         { QDesign }

  { Encoder names }
  MPEG_ENCODER: array [0..7] of string =
    ('Unknown', 'Xing', 'FhG', 'LAME', 'Blade', 'GoGo', 'Shine', 'QDesign');

type
  { Xing/FhG VBR header data }
  VBRData = record
    Found: Boolean;                                { True if VBR header found }
    ID: array [1..4] of Char;                   { Header ID: "Xing" or "VBRI" }
    Frames: Integer;                                 { Total number of frames }
    Bytes: Integer;                                   { Total number of bytes }
    Scale: Byte;                                         { VBR scale (1..100) }
    VendorID: string;                                { Vendor ID (if present) }
  end;

  { MPEG frame header data}
  FrameData = record
    Found: Boolean;                                     { True if frame found }
    Position: Integer;                           { Frame position in the file }
    Size: Word;                                          { Frame size (bytes) }
    Xing: Boolean;                                     { True if Xing encoder }
    Data: array [1..4] of Byte;                 { The whole frame header data }
    VersionID: Byte;                                        { MPEG version ID }
    LayerID: Byte;                                            { MPEG layer ID }
    ProtectionBit: Boolean;                        { True if protected by CRC }
    BitRateID: Word;                                            { Bit rate ID }
    SampleRateID: Word;                                      { Sample rate ID }
    PaddingBit: Boolean;                               { True if frame padded }
    PrivateBit: Boolean;                                  { Extra information }
    ModeID: Byte;                                           { Channel mode ID }
    ModeExtensionID: Byte;             { Mode extension ID (for Joint Stereo) }
    CopyrightBit: Boolean;                        { True if audio copyrighted }
    OriginalBit: Boolean;                            { True if original media }
    EmphasisID: Byte;                                           { Emphasis ID }
  end;

  { Class TMPEGaudio }
  TMPEGaudio = class(TObject)
    private
      { Private declarations }
      FFileLength: Int64;
      FVendorID: string;
      FVBR: VBRData;
      FFrame: FrameData;
      FID3v1: TID3v1;
      FID3v2: TID3v2;
      procedure FResetData;
      function FGetVersion: string;
      function FGetLayer: string;
      function FGetBitRate: Word;
      function FGetSampleRate: Word;
      function FGetChannelMode: string;
      function FGetEmphasis: string;
      function FGetFrames: Integer;
      function FGetDuration: Double;
      function FGetVBREncoderID: Byte;
      function FGetCBREncoderID: Byte;
      function FGetEncoderID: Byte;
      function FGetEncoder: string;
      function FGetValid: Boolean;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;     { Load data }
      property FileLength: Int64 read FFileLength;    { File length (bytes) }
      property VBR: VBRData read FVBR;                      { VBR header data }
      property Frame: FrameData read FFrame;              { Frame header data }
      property ID3v1: TID3v1 read FID3v1;                    { ID3v1 tag data }
      property ID3v2: TID3v2 read FID3v2;                    { ID3v2 tag data }
      property Version: string read FGetVersion;          { MPEG version name }
      property Layer: string read FGetLayer;                { MPEG layer name }
      property BitRate: Word read FGetBitRate;            { Bit rate (kbit/s) }
      property SampleRate: Word read FGetSampleRate;       { Sample rate (hz) }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property Emphasis: string read FGetEmphasis;            { Emphasis name }
      property Frames: Integer read FGetFrames;      { Total number of frames }
      property Duration: Double read FGetDuration;      { Song duration (sec) }
      property EncoderID: Byte read FGetEncoderID;       { Guessed encoder ID }
      property Encoder: string read FGetEncoder;       { Guessed encoder name }
      property Valid: Boolean read FGetValid;       { True if MPEG file valid }
  end;


  const
  { Used with ChannelModeID property }
  VORBIS_CM_MONO = 1;                                    { Code for mono mode }
  VORBIS_CM_STEREO = 2;                                { Code for stereo mode }

  { Channel mode names }
  VORBIS_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');

    //////////////////////////////ogg vorbis audio
type
  { Class TOggVorbis }
  TOggVorbis = class(TObject)
    private
      { Private declarations }
      FFileSize: Integer;
      FChannelModeID: Byte;
      FSampleRate: Word;
      FBitRateNominal: Word;
      FSamples: Integer;
      FID3v2Size: Integer;
      FTitle: string;
      FArtist: string;
      FAlbum: string;
      FTrack: Word;
      FDate: string;
      FGenre: string;
      FComment: string;
      FVendor: string;
      procedure FResetData;
      function FGetChannelMode: string;
      function FGetDuration: Double;
      function FGetBitRate: Word;
      function FHasID3v2: Boolean;
      function FIsValid: Boolean;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;     { Load data }
      //function SaveTag(const FileName: string): Boolean;      { Save tag data }
     // function ClearTag(const FileName: widestring): Boolean;    { Clear tag data }
      property FileSize: Integer read FFileSize;          { File size (bytes) }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property SampleRate: Word read FSampleRate;          { Sample rate (hz) }
      property BitRateNominal: Word read FBitRateNominal;  { Nominal bit rate }
      property Title: string read FTitle write FTitle;           { Song title }
      property Artist: string read FArtist write FArtist;       { Artist name }
      property Album: string read FAlbum write FAlbum;           { Album name }
      property Track: Word read FTrack write FTrack;           { Track number }
      property Date: string read FDate write FDate;                    { Year }
      property Genre: string read FGenre write FGenre;           { Genre name }
      property Comment: string read FComment write FComment;        { Comment }
      property Vendor: string read FVendor;                   { Vendor string }
      property Duration: Double read FGetDuration;       { Duration (seconds) }
      property BitRate: Word read FGetBitRate;             { Average bit rate }
      property ID3v2: Boolean read FHasID3v2;      { True if ID3v2 tag exists }
      property Valid: Boolean read FIsValid;             { True if file valid }
  end;


  /////////////////////////////////////TWINVQ
  const
  { Used with ChannelModeID property }
  TWIN_CM_MONO = 1;                                     { Index for mono mode }
  TWIN_CM_STEREO = 2;                                 { Index for stereo mode }

  { Channel mode names }
  TWIN_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');

type
  { Class TTwinVQ }
  TTwinVQ = class(TObject)
    private
      { Private declarations }
      FValid: Boolean;
      FChannelModeID: Byte;
      FBitRate: Byte;
      FSampleRate: Word;
      FFileSize: Cardinal;
      FDuration: Double;
      FTitle: string;
      FComment: string;
      FAuthor: string;
      FCopyright: string;
      FOriginalFile: string;
      FAlbum: string;
      procedure FResetData;
      function FGetChannelMode: string;
      function FIsCorrupted: Boolean;
       function ReadHeader(const stream: Thandlestream; var Header: TwinVQHeaderInfo): Boolean;
       function GetChannelModeID(const Header: TwinVQHeaderInfo): Byte;
       function GetBitRate(const Header: TwinVQHeaderInfo): Byte;
       function GetSampleRate(const Header: TwinVQHeaderInfo): Word;
       function GetDuration(const Header: TwinVQHeaderInfo): Double;
       function HeaderEndReached(const Chunk: TwinVQChunkHeader): Boolean;
       procedure SetTagItem(const ID, Data: string; var Header: TwinVQHeaderInfo);
       function converti_oemtoutf8(source: string): string;
       procedure ReadTag(const stream: Thandlestream; var Header: TwinVQHeaderInfo);

    public
      { Public declarations }
      constructor Create;                                     { Create object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property Valid: Boolean read FValid;             { True if header valid }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property BitRate: Byte read FBitRate;                  { Total bit rate }
      property SampleRate: Word read FSampleRate;          { Sample rate (hz) }
      property FileSize: Cardinal read FFileSize;         { File size (bytes) }
      property Duration: Double read FDuration;          { Duration (seconds) }
      property Title: string read FTitle;                        { Title name }
      property Comment: string read FComment;                       { Comment }
      property Author: string read FAuthor;                     { Author name }
      property Copyright: string read FCopyright;                 { Copyright }
      property OriginalFile: string read FOriginalFile;  { Original file name }
      property Album: string read FAlbum;                       { Album title }
      property Corrupted: Boolean read FIsCorrupted; { True if file corrupted }
  end;

  /////////////////////////////////7WAV
  const
  { Used with ChannelMode property }
  CHANNEL_MODE_MONO = 1;                                { Index for mono mode }
  CHANNEL_MODE_STEREO = 2;                            { Index for stereo mode }

  { Channel mode names }
  CHANNEL_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');

type
  { Class TWAVFile }
  TWAVFile = class(TObject)
    private
      { Private declarations }
      FValid: Boolean;
      FChannelModeID: Byte;
      FSampleRate: Word;
      FBitsPerSample: Byte;
      FFileSize: Cardinal;
      procedure FResetData;
      function FGetChannelMode: string;
      function FGetDuration: Double;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property Valid: Boolean read FValid;             { True if header valid }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property SampleRate: Word read FSampleRate;          { Sample rate (hz) }
      property BitsPerSample: Byte read FBitsPerSample;     { Bits per sample }
      property FileSize: Cardinal read FFileSize;         { File size (bytes) }
      property Duration: Double read FGetDuration;       { Duration (seconds) }
  end;

   /////////////////////////////////WMA
   const
  { Channel modes }
  WMA_CM_UNKNOWN = 0;                                               { Unknown }
  WMA_CM_MONO = 1;                                                     { Mono }
  WMA_CM_STEREO = 2;                                                 { Stereo }

  { Channel mode names }
  WMA_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');

type
  { Class TWMAfile }
  TWMAfile = class(TObject)
    private
      { Private declarations }
      FValid: Boolean;
      FFileSize: Int64;
      FChannelModeID: Byte;
      FSampleRate: Integer;
      FDuration: Double;
      FBitRate: Integer;
      FTitle: WideString;
      FArtist: WideString;
      FAlbum: WideString;
      FTrack: Integer;
      FYear: WideString;
      FGenre: WideString;
      FComment: WideString;
      procedure FResetData;
      function FGetChannelMode: string;
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      function ReadFromFile(const FileName: widestring): Boolean;     { Load data }
      property Valid: Boolean read FValid;               { True if valid data }
      property FileSize: Int64 read FFileSize;          { File size (bytes) }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property SampleRate: Integer read FSampleRate;       { Sample rate (hz) }
      property Duration: Double read FDuration;          { Duration (seconds) }
      property BitRate: Integer read FBitRate;              { Bit rate (kbit) }
      property Title: WideString read FTitle;                    { Song title }
      property Artist: WideString read FArtist;                 { Artist name }
      property Album: WideString read FAlbum;                    { Album name }
      property Track: Integer read FTrack;                     { Track number }
      property Year: WideString read FYear;                            { Year }
      property Genre: WideString read FGenre;                    { Genre name }
      property Comment: WideString read FComment;                   { Comment }
  end;
  
  /////////////////////////////////AAC
const
  { Header type codes }
  AAC_HEADER_TYPE_UNKNOWN = 0;                                      { Unknown }
  AAC_HEADER_TYPE_ADIF = 1;                                            { ADIF }
  AAC_HEADER_TYPE_ADTS = 2;                                            { ADTS }

  { Header type names }
  AAC_HEADER_TYPE: array [0..2] of string =
    ('Unknown', 'ADIF', 'ADTS');

  { MPEG version codes }
  AAC_MPEG_VERSION_UNKNOWN = 0;                                     { Unknown }
  AAC_MPEG_VERSION_2 = 1;                                            { MPEG-2 }
  AAC_MPEG_VERSION_4 = 2;                                            { MPEG-4 }

  { MPEG version names }
  AAC_MPEG_VERSION: array [0..2] of string =
    ('Unknown', 'MPEG-2', 'MPEG-4');

  { Profile codes }
  AAC_PROFILE_UNKNOWN = 0;                                          { Unknown }
  AAC_PROFILE_MAIN = 1;                                                { Main }
  AAC_PROFILE_LC = 2;                                                    { LC }
  AAC_PROFILE_SSR = 3;                                                  { SSR }
  AAC_PROFILE_LTP = 4;                                                  { LTP }

  { Profile names }
  AAC_PROFILE: array [0..4] of string =
    ('Unknown', 'AAC Main', 'AAC LC', 'AAC SSR', 'AAC LTP');

  { Bit rate type codes }
  AAC_BITRATE_TYPE_UNKNOWN = 0;                                     { Unknown }
  AAC_BITRATE_TYPE_CBR = 1;                                             { CBR }
  AAC_BITRATE_TYPE_VBR = 2;                                             { VBR }

  { Bit rate type names }
  AAC_BITRATE_TYPE: array [0..2] of string =
    ('Unknown', 'CBR', 'VBR');

type
  { Class TAACfile }
  TAACfile = class(TObject)
    private
      { Private declarations }
      FFileSize: Int64;
      FHeaderTypeID: Byte;
      FMPEGVersionID: Byte;
      FProfileID: Byte;
      FChannels: Byte;
      FSampleRate: Integer;
      FBitRate: Integer;
      FBitRateTypeID: Byte;
      FID3v1: TID3v1;
      FID3v2: TID3v2;
      procedure FResetData;
      function FGetHeaderType: string;
      function FGetMPEGVersion: string;
      function FGetProfile: string;
      function FGetBitRateType: string;
      function FGetDuration: Double;
      function FIsValid: Boolean;
      function FRecognizeHeaderType(const Source: THandleStream): Byte;
      procedure FReadADIF(const Source: THandleStream);
      procedure FReadADTS(const Source: THandleStream);
        function ReadBits(Source: THandleStream; Position, Count: Integer): Integer;

    public
      { Public declarations }
      constructor Create;                                     { Create object }
      destructor Destroy; override;                          { Destroy object }
      function ReadFromFile(const FileName: widestring): Boolean;   { Load header }
      property FileSize: Int64 read FFileSize;          { File size (bytes) }
      property HeaderTypeID: Byte read FHeaderTypeID;      { Header type code }
      property HeaderType: string read FGetHeaderType;     { Header type name }
      property MPEGVersionID: Byte read FMPEGVersionID;   { MPEG version code }
      property MPEGVersion: string read FGetMPEGVersion;  { MPEG version name }
      property ProfileID: Byte read FProfileID;                { Profile code }
      property Profile: string read FGetProfile;               { Profile name }
      property Channels: Byte read FChannels;            { Number of channels }
      property SampleRate: Integer read FSampleRate;       { Sample rate (hz) }
      property BitRate: Integer read FBitRate;             { Bit rate (bit/s) }
      property BitRateTypeID: Byte read FBitRateTypeID;  { Bit rate type code }
      property BitRateType: string read FGetBitRateType; { Bit rate type name }
      property Duration: Double read FGetDuration;       { Duration (seconds) }
      property Valid: Boolean read FIsValid;             { True if data valid }
      property ID3v1: TID3v1 read FID3v1;                    { ID3v1 tag data }
      property ID3v2: TID3v2 read FID3v2;                    { ID3v2 tag data }
  end;


  //MP$ ***********************************************************************
    type
 tatomtype=(at_ftyp,at_moov,at_mdat,at_pdin,at_moof,at_mfhd,at_traf,at_tfhd,
            at_trun,at_mfra,at_tfra,at_mfro,at_free,at_skip,at_uuid,at_mvhd,
            at_iods,at_drm,at_trak,at_tkhd,at_tref,at_mdia,at_tapt,at_clef,
            at_prof,at_enof,at_mdhd,at_minf,at_hdlr,at_vmhd,at_smhd,at_hmdh,
            at_gmhd,at_dinf,at_url,at_urn,at_dref,at_stbl,at_stts,at_ctts,
            at_stsd,at_stsz,at_stz2,at_stsc,at_stco,at_co64,at_stss,at_stsh,
            at_stdp,at_padb,at_sdtp,at_sbgp,at_stps,at_edts,at_elst,at_udta,
            at_meta,at_mvex,at_mehd,at_trex,at_stsl,at_subs,at_xml,at_bxml,
            at_iloc,at_pitm,at_ipro,at_infe,at_iinf,at_sinf,at_frma,at_imif,
            at_schm,at_schi,at_skcr,at_user,at_key,at_iviv,at_righ,at_name,
            at_priv,at_iKMS,at_iSFM,at_IKEY,at_hint,at_dpnd,at_ipir,at_mpod,
            at_sync,at_chap,at_ipmc,at_tims,at_tsro,at_snro,at_srpp,at_hnti,
            at_rtp,at_snp,at_hinf,at_trpy,at_nump,at_tpyl,at_totl,
            at_npck,at_maxr,at_dmed,at_dimm,at_drep,at_tmin,at_tmax,at_pmax,
            at_dmax,at_payt,at_drms,at_drmi,at_alac,at_mp4a,at_mp4s,at_mp4v,
            at_avc1,at_avcp,at_text,at_jpeg,at_tx3g,at_srtp,at_enca,
            at_encv,at_enct,at_encs,at_samr,at_sawb,at_sawp,at_s263,at_sevc,
            at_sqcp,at_ssmv,at_tmcd,at_avcC,at_damr,at_d263,at_dawp,
            at_devc,at_dqcp,at_dsmv,at_bitr,at_btrt,at_m4ds,at_ftab,at_cprt,
            at_titl,at_auth,at_perf,at_gnre,at_dscp,at_albm,at_yrrc,at_rtng,
            at_clsf,at_kywd,at_loci,at_ID32,at_ilst,at_____,at_mean,at_esds,
            at_data,
            at_gsst,at_gstd,at_gssd,at_gspu,at_gspm,at_gshh, //YT?
            at_ctoo,
            at_unknown);

            type
            tatomRequirement=(UNKNOWN_REQUIREMENTS,REQUIRED_ONCE,REQUIRED_ONE,OPTIONAL_MANY,OPTIONAL_ONCE,OPTIONAL_ONE);
            tatomBoxType=(SIMPLE_ATOM,CHILD_ATOM,PARENT_ATOM,DUAL_STATE_ATOM,VERSIONED_ATOM);
            
  type
 tatom = class(TObject)
  private


  // mrequirement: TatomRequirement;

   mparent: Tatom;
  // mheaderPosition: Cardinal;
   msize: Cardinal;
   function HeadertoBoxType: TatomboxType;
   procedure assignType(const header: string);
  public
  mtype: Tatomtype;
  mchilds: TMylist;
  mboxtype: TatomBoxType;
  constructor create(const atomHeader: string; atomparent: Tatom; atomsize: Cardinal);
  destructor destroy; override;
 end;

  type tparserState=( PARSER_PROCESSING,PARSER_ERROR,PARSER_COMPLETE);
 type
  TMP4Parser = class(TObject)
   private
    atoms: TMylist;
    bufferHeader: ThandleStream;
    offsetMDAT: Int64;
    lenMDAT: Int64;
    fcurrentState: TparserState;
    faudiosamplingRate,fAudioChannels: Integer;
    fsample_bytes_per_sample: Integer;
    hasMDAT: Boolean;
    procedure freeAtoms(list: TMylist);
    procedure readAtom(parentAtom: Tatom; sizeAvailable: Int64; tabbing: Cardinal);
//    function checkHasMDAT: Boolean;
    function getCurrentState: TparserState;
    procedure setCurrentState(value: TparserState);
    procedure Error(const errorS: string);
    procedure read_mvhd(lenAvailable: Cardinal);
    procedure read_tkhd(lenAvailable: Cardinal);
    procedure read_uuid(lenAvailable: Cardinal);
    procedure read_avc1(lenAvailable: Cardinal);

    procedure startReading;

   public
    fwidth,fheight,fduration: Integer;
    faudioFound,fvideoFound: Boolean;
     property currentState: TparserState read getCurrentState write setCurrentState;
    constructor create();
    procedure readFile(const filename: WideString);
    destructor destroy; override;
  end;

implementation

uses
helper_urls;

///////////////////////////////7IMAGES
{*******************************************************************************
ReadFile
*******************************************************************************}
  procedure TDCImageInfo.ReadFile(const FileName: wideString);
  var
    Buffer: array [0..2] of Byte;
  begin

    // Clear any left over data...
    ResetValues;

    // Open the file
    ImageFile := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if ImageFile=nil then exit;

    FFileSize := ImageFile.Size;

     if FFileSize<16 then begin
      FreeHandleStream(Imagefile);
     exit;
     end;

    // read the first 3 bytes to determine file type
    Try
      ImageFile.Readbuffer(Buffer, 3);
    Except;
      FreeHandleStream(Imagefile);
      Exit;
    End;

    // check for PNG
    if (Buffer[0] = 137) and (Buffer[1] = 80) and (Buffer[2] = 78) Then
    begin
      Try
        ReadPNG;
      Except
        ResetValues;
      End;
    end;

    // check for GIF
    if (Buffer[0] = 71) and (Buffer[1] = 73) and (Buffer[2] = 70) Then
    begin
      Try
        ReadGIF;
      Except
        ResetValues;
      End;
    end;

    // check for BMP
    if (Buffer[0] = 66) and (Buffer[1] = 77) Then
    begin
      Try
        ReadBMP;
      Except
        ResetValues;
      End;
    end;

    // check for PCX
    if (Buffer[0] = 10) Then
    begin
      Try
        ReadPCX;
      Except
        ResetValues;
      End;
    end;

    // check for TIFF (little endian)
    if (Buffer[0] = 73) and (Buffer[1] = 73) and (Buffer[2] = 42) Then
    begin
      Try
        ReadLETIFF;
      Except
        ResetValues;
      End;
    end;

    // check for TIFF (big endian)
    if (Buffer[0] = 77) and (Buffer[1] = 77) and (Buffer[2] = 42) Then
    begin
      Try
        ReadBETIFF;
      Except
        ResetValues;
      End;
    end;

    // if we haven't found the correct type by now, it's either invalid or
    // a JPEG
    if FImageType = itUnknown Then
    begin
      Try
        ReadJPEG;
      Except
        ResetValues;
      End;
    end;

    // clean up
    closehandle(imagefile.handle);
    ImageFile.Free;

  end;

{*******************************************************************************
ReadPNG
*******************************************************************************}
  procedure TDCImageInfo.ReadPNG;
  var
    b: Byte;
    c: Byte;
    w: Word;
    buffer: array [0..1] of Byte;
  begin
    FImageType := itPNG;
    ImageFile.Position := 24;

    ImageFile.Read(buffer,2);
    b := buffer[0];
    c := buffer[1];


    // color depth
    Case c Of
      0: FDepth := b;  // greyscale
      2: FDepth := b * 3; // RGB
      3: FDepth := 8; // Palette based
      4: FDepth := b * 2; // greyscale with alpha
      6: FDepth := b * 4; // RGB with alpha
    Else
      FImageType := itUnknown;
    End;
    
    If FImageType = itPNG Then
    begin
      ImageFile.Position := 18;
      ImageFile.ReadBuffer(w, 2);
      FWidth := Swap(w);
      ImageFile.Position := 22;
      ImageFile.ReadBuffer(w, 2);
      FHeight := Swap(w);
    end;
  end;

{*******************************************************************************
ReadGIF
*******************************************************************************}
  procedure TDCImageInfo.ReadGIF;
  var
    buffer: array [0..4] of Byte;
  begin
    FImageType := itGIF;
    ImageFile.Position := 6;

    ImageFile.Read(buffer, 5);

        FWidth := buffer[1];
        FWidth := FWidth shl 8;
        FWidth := FWidth + buffer[0];

        FHeight := buffer[3];
        FHeight := FHeight shl 8;
        FHeight := FHeight + buffer[2];


    FDepth := (buffer[4] and 7) + 1;
  end;

{*******************************************************************************
ReadBMP
*******************************************************************************}
  procedure TDCImageInfo.ReadBMP;
  var
    b: Byte;
    w: Word;
       buffer: array [0..10] of Byte;
  begin
    FImageType := itBMP;

    ImageFile.Position := 18;
    ImageFile.Read(buffer,11);

    move(buffer[0],w,2);
    //ImageFile.ReadBuffer(w, 2);
    FWidth := w;
    move(buffer[4],w,2);

    //ImageFile.Position := 22;
    //ImageFile.ReadBuffer(w, 2);
    FHeight := w;
    b := buffer[10];
    //ImageFile.Position := 28;
    //ImageFile.ReadBuffer(b, 1);
    FDepth := b;
  end;


{*******************************************************************************
ReadPCX
*******************************************************************************}
  procedure TDCImageInfo.ReadPCX;
  var
    b1: Byte;
    b2: Byte;
    X1: Word;
    X2: Word;
    Y1: Word;
    Y2: Word;

  begin
    FImageType := itPCX;

    ImageFile.Position := 3;
    ImageFile.ReadBuffer(b1, 1);
    ImageFile.ReadBuffer(X1, 2);
    ImageFile.ReadBuffer(Y1, 2);
    ImageFile.ReadBuffer(X2, 2);
    ImageFile.ReadBuffer(Y2, 2);
    ImageFile.Position := 65;
    ImageFile.ReadBuffer(b2, 1);

    FWidth := (X2 - X1) + 1;
    FHeight := (Y2 - Y1) + 1;
    FDepth := b1 * b2;
  end;

{*******************************************************************************
ReadLETIFF (little endian TIFF)
*******************************************************************************}
  procedure TDCImageInfo.ReadLETIFF;
  var
  pIFD: Integer;
  pEntry: Integer;
  NumEntries: Word;
  i: Integer;
  b: Byte;
  w: Word;
  w2: Word;
  w3: Word;
  dw: Integer;

  begin
    FImageType := itTIFF;

    // get pointer to IFD
    ImageFile.Position := 4;
    ImageFile.ReadBuffer(pIFD, 4);

    // get number of entries in the IFD
    ImageFile.Position := pIFD;
    ImageFile.ReadBuffer(NumEntries, 2);

    // loop through each entry
    For i := 0 to NumEntries - 1 do begin
      pEntry := pIFD + 2 + (12 * i);

      ImageFile.Position := pEntry;
      ImageFile.ReadBuffer(w, 2);

      // width
      if w = TIFF_WIDTH then begin
        ImageFile.ReadBuffer(w2, 2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FWidth := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FWidth := w3;
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FWidth := dw;
          end;
        Else
        FWidth := 0;
        end;
      end;   // end of TIFF_WIDTH

      // Height
      if w = TIFF_HEIGHT then
      begin
        ImageFile.ReadBuffer(w2, 2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FHeight := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FHeight := w3;
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FHeight := dw;
          end;
        Else
        FHeight := 0;
        end;
      end;   // end of TIFF_HEIGHT

      // Depth
      if w = TIFF_BITSPERSAMPLE then
      begin
        ImageFile.ReadBuffer(w2, 2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FDepth := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FDepth := w3;
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FDepth := dw;
          end;
        Else
        FDepth := 0;
        end;
      end;   // end of TIFF_BITSPERSAMPLE

    end; // end of loop

    if not((FWidth > 0) and (FHeight > 0) and (FDepth > 0)) then
      ResetValues;

  end;  // end of procedure

{*******************************************************************************
ReadBETIFF (big endian TIFF)
*******************************************************************************}
  procedure TDCImageInfo.ReadBETIFF;
  var
  pIFD: Integer;
  pEntry: Integer;
  NumEntries: Word;
  i: Integer;
  b: Byte;
  w: Word;
  w2: Word;
  w3: Word;
  dw: Integer;

  begin
    FImageType := itTIFF;

    // get pointer to IFD
    ImageFile.Position := 4;
    ImageFile.ReadBuffer(pIFD, 4);
    pIFD := Swap32(pIFD);

    // get number of entries in the IFD
    ImageFile.Position := pIFD;
    ImageFile.ReadBuffer(NumEntries, 2);
    NumEntries := Swap(NumEntries);

    // loop through each entry
    For i := 0 to NumEntries - 1 do
    begin
      pEntry := pIFD + 2 + (12 * i);

      ImageFile.Position := pEntry;
      ImageFile.ReadBuffer(w, 2);
      w := Swap(w);

      // width
      if w = TIFF_WIDTH then
      begin
        ImageFile.ReadBuffer(w2, 2);
        w2 := Swap(w2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FWidth := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FWidth := Swap(w3);
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FWidth := Swap32(dw);
          end;
        Else
        FWidth := 0;
        end;
      end;   // end of TIFF_WIDTH

      // Height
      if w = TIFF_HEIGHT then
      begin
        ImageFile.ReadBuffer(w2, 2);
        w2 := Swap(w2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FHeight := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FHeight := Swap(w3);
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FHeight := Swap32(dw);
          end;
        Else
        FHeight := 0;
        end;
      end;   // end of TIFF_HEIGHT

      // Depth
      if w = TIFF_BITSPERSAMPLE then
      begin
        ImageFile.ReadBuffer(w2, 2);
        w2 := Swap(w2);
        ImageFile.Position := pEntry + 8;
        Case w2 of
          TIFF_BYTE:
          begin
            ImageFile.ReadBuffer(b, 1);
            FDepth := b;
          end;
          TIFF_WORD:
          begin
            ImageFile.ReadBuffer(w3, 2);
            FDepth := Swap(w3);
          end;
          TIFF_DWORD:
          begin
            ImageFile.ReadBuffer(dw, 4);
            FDepth := Swap32(dw);
          end;
        Else
        FDepth := 0;
        end;
      end;   // end of TIFF_BITSPERSAMPLE

    end; // end of loop

    if not((FWidth > 0) and (FHeight > 0) and (FDepth > 0)) then
      ResetValues;

  end;  // end of procedure

{*******************************************************************************
ReadJPEG
*******************************************************************************}
  procedure TDCImageInfo.ReadJPEG;
  var
    Pos,len,cicli: Integer;
    w: Word;
    b: Byte;
    Buffer: array [0..4] of Byte;

  begin
    Pos := 0;
    cicli := 0;
    // find beginning of JPEG stream
    While True do begin
       if pos>=imagefile.size then begin
        fdepth := 0;
        fwidth := 0;
        fheight := 0;
        exit;
       end;
      ImageFile.Position := Pos;
       if imagefile.position+3>=imagefile.size then exit;
      ImageFile.Read(Buffer, 3);
      if (Buffer[0] = $FF) and (Buffer[1] = $D8) and (Buffer[2] = $FF) then break;
      Pos := Pos + 1;
    end;

    Pos := Pos +1;

    // loop through each marker until we find the C0 marker (or C1 or C2) which
    // has the image information
    While True do begin

      // find beginning of next marker
      While True do begin
       if pos>=imagefile.size then begin
        fdepth := 0;
        fwidth := 0;
        fheight := 0;
       exit;
       end;
        imagefile.seek(pos,soFromBeginning);


        if imagefile.position+2>=imagefile.size then exit;
        ImageFile.Read(Buffer, 2);

        if ((Buffer[0] = $FF) and (Buffer[1] <> $FF)) then break;
        Pos := Pos + 1;
      end;

      // exit the loop if we've found the correct marker
      b := Buffer[1];
      if (b = $C0) or (b = $C1) or (b = $c2) or (b = $C3) then break;


      imagefile.seek(pos+2,soFromBeginning);

      if imagefile.position+2>=imagefile.size then exit;
      len := ImageFile.Read(buffer, 2);

        w := buffer[0];
        w := w shl 8;
        w := w + buffer[1];
         pos := imagefile.position-2;
         inc(Pos,w);
           inc(cicli);
           if cicli>2000 then exit;
    end;

    // if we haven't errored by this point then we're at the right
    // marker, and can retrieve the info

    FImageType := itJPEG;

    ImageFile.Position := Pos + 5;
    if imagefile.position+5>=imagefile.size then exit;

    ImageFile.Read(buffer, 5);

     FHeight := buffer[0];
     FHeight := FHeight shl 8;
     FHeight := FHeight + buffer[1];

     FWidth := buffer[2];
     FWidth := FWidth shl 8;
     FWidth := FWidth + buffer[3];

     FDepth := buffer[4] * 8;

  end;

{*******************************************************************************
ResetValues
*******************************************************************************}
  procedure TDCImageInfo.ResetValues;
  begin
    FImageType := itUnknown;
    FWidth := 0;
    FHeight := 0;
    FDepth := 0;
  end;

{*******************************************************************************
Swap32
*******************************************************************************}
  function TDCImageInfo.Swap32(Value: Integer): Integer;
  var
    b1: Integer;
    b2: Integer;
    b3: Integer;
    b4: Integer;
    r: Integer;
  begin
    b1 := Value and 255;
    b2 := (Value shr 8) and 255;
    b3 := (Value shr 16) and 255;
    b4 := (Value shr 24) and 255;

    b1 := b1 shl 24;
    b2 := b2 shl 16;
    b3 := b3 shl 8;

    r := b1 or b2 or b3 or b4;

    Result := r;
  end;



  
///////////////////////////////////////////7AUDIO
const
  { Sample rate values }
  SAMPLE_RATE: array [0..15] of Integer =
    (96000, 88200, 64000, 48000, 44100, 32000,
    24000, 22050, 16000, 12000, 11025, 8000, 0, 0, 0, 0);

{ ********************* Auxiliary functions & procedures ******************** }

function TAACfile.ReadBits(Source: THandleStream; Position, Count: Integer): Integer;
var
  Buffer: array [1..4] of Byte;
begin
  { Read a number of bits from file at the given position }
  Source.Seek(Position div 8, soFromBeginning);
  Source.Read(Buffer, SizeOf(Buffer));
  Result := 
    Buffer[1] * $1000000 +
    Buffer[2] * $10000 +
    Buffer[3] * $100 +
    Buffer[4];
  Result := (Result shl (Position mod 8)) shr (32 - Count);
end;

{ ********************** Private functions & procedures ********************* }

procedure TAACfile.FResetData;
begin
  { Reset all variables }
  FFileSize := 0;
  FHeaderTypeID := AAC_HEADER_TYPE_UNKNOWN;
  FMPEGVersionID := AAC_MPEG_VERSION_UNKNOWN;
  FProfileID := AAC_PROFILE_UNKNOWN;
  FChannels := 0;
  FSampleRate := 0;
  FBitRate := 0;
  FBitRateTypeID := AAC_BITRATE_TYPE_UNKNOWN;
  FID3v1.ResetData;
  FID3v2.ResetData;
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FGetHeaderType: string;
begin
  { Get header type name }
  Result := AAC_HEADER_TYPE[FHeaderTypeID];
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FGetMPEGVersion: string;
begin
  { Get MPEG version name }
  Result := AAC_MPEG_VERSION[FMPEGVersionID];
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FGetProfile: string;
begin
  { Get profile name }
  Result := AAC_PROFILE[FProfileID];
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FGetBitRateType: string;
begin
  { Get bit rate type name }
  Result := AAC_BITRATE_TYPE[FBitRateTypeID];
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FGetDuration: Double;
begin
  { Calculate duration time }
  if FBitRate = 0 then Result := 0
  else Result := 8 * (FFileSize - ID3v2.Size) / FBitRate;
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FIsValid: Boolean;
begin
  { Check for file correctness }
  Result := (FHeaderTypeID <> AAC_HEADER_TYPE_UNKNOWN) and
    (FChannels > 0) and (FSampleRate > 0) and (FBitRate > 0);
end;

{ --------------------------------------------------------------------------- }

function TAACfile.FRecognizeHeaderType(const Source: THandleStream): Byte;
var
  Header: array [1..4] of Char;
begin
  { Get header type of the file }
  Result := AAC_HEADER_TYPE_UNKNOWN;
  Source.Seek(FID3v2.Size, soFromBeginning);
  Source.Read(Header, SizeOf(Header));
  if Header[1] + Header[2] + Header[3] + Header[4] = 'ADIF' then
    Result := AAC_HEADER_TYPE_ADIF
  else if (Byte(Header[1]) = $FF) and (Byte(Header[1]) and $F0 = $F0) then
    Result := AAC_HEADER_TYPE_ADTS;
end;

{ --------------------------------------------------------------------------- }

procedure TAACfile.FReadADIF(const Source: THandleStream);
var
  Position: Integer;
begin
  { Read ADIF header data }
  Position := FID3v2.Size * 8 + 32;
  if ReadBits(Source, Position, 1) = 0 then Inc(Position, 3)
  else Inc(Position, 75);
  if ReadBits(Source, Position, 1) = 0 then
    FBitRateTypeID := AAC_BITRATE_TYPE_CBR
  else
    FBitRateTypeID := AAC_BITRATE_TYPE_VBR;
  Inc(Position, 1);
  FBitRate := ReadBits(Source, Position, 23);
  if FBitRateTypeID = AAC_BITRATE_TYPE_CBR then Inc(Position, 51)
  else Inc(Position, 31);
  FMPEGVersionID := AAC_MPEG_VERSION_4;
  FProfileID := ReadBits(Source, Position, 2) + 1;
  Inc(Position, 2);
  FSampleRate := SAMPLE_RATE[ReadBits(Source, Position, 4)];
  Inc(Position, 4);
  Inc(FChannels, ReadBits(Source, Position, 4));
  Inc(Position, 4);
  Inc(FChannels, ReadBits(Source, Position, 4));
  Inc(Position, 4);
  Inc(FChannels, ReadBits(Source, Position, 4));
  Inc(Position, 4);
  Inc(FChannels, ReadBits(Source, Position, 2));
end;

{ --------------------------------------------------------------------------- }

procedure TAACfile.FReadADTS(const Source: THandleStream);
var
  Frames, TotalSize, Position: Integer;
begin
  { Read ADTS header data }
  Frames := 0;
  TotalSize := 0;
  repeat
    Inc(Frames);
    Position := (FID3v2.Size + TotalSize) * 8;
    if ReadBits(Source, Position, 12) <> $FFF then break;
    Inc(Position, 12);
    if ReadBits(Source, Position, 1) = 0 then
      FMPEGVersionID := AAC_MPEG_VERSION_4
    else
      FMPEGVersionID := AAC_MPEG_VERSION_2;
    Inc(Position, 4);
    FProfileID := ReadBits(Source, Position, 2) + 1;
    Inc(Position, 2);
    FSampleRate := SAMPLE_RATE[ReadBits(Source, Position, 4)];
    Inc(Position, 5);
    FChannels := ReadBits(Source, Position, 3);
    if FMPEGVersionID = AAC_MPEG_VERSION_4 then Inc(Position, 9)
    else Inc(Position, 7);
    Inc(TotalSize, ReadBits(Source, Position, 13));
    Inc(Position, 13);
    if ReadBits(Source, Position, 11) = $7FF then
      FBitRateTypeID := AAC_BITRATE_TYPE_VBR
    else
      FBitRateTypeID := AAC_BITRATE_TYPE_CBR;
    if FBitRateTypeID = AAC_BITRATE_TYPE_CBR then break;
  until (Frames = 1000) or (Source.Size <= FID3v2.Size + TotalSize);
  FBitRate := Round(8 * TotalSize / 1024 / Frames * FSampleRate);
end;

{ ********************** Public functions & procedures ********************** }

constructor TAACfile.Create;
begin
  { Create object }
  FID3v1 := TID3v1.Create;
  FID3v2 := TID3v2.Create;
  FResetData;
  inherited;
end;

{ --------------------------------------------------------------------------- }

destructor TAACfile.Destroy;
begin
  { Destroy object }
  FID3v1.Free;
  FID3v2.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TAACfile.ReadFromFile(const FileName: widestring): Boolean;
var
  stream: ThandleStream;

begin
  { Read data from file }
  Result := False;
  FResetData;

    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

   stream.seek(0,sofrombeginning);
   
  { At first search for tags, then try to recognize header type }
  if (FID3v2.ReadFromFile(stream)) and (FID3v1.ReadFromFile(stream)) then begin
    try
      FFileSize := stream.Size;
      stream.seek(0,sofrombeginning);

      FHeaderTypeID := FRecognizeHeaderType(stream);
      { Read header data }
      if FHeaderTypeID = AAC_HEADER_TYPE_ADIF then FReadADIF(stream);
      if FHeaderTypeID = AAC_HEADER_TYPE_ADTS then FReadADTS(stream);

      FreeHandleStream(stream);
      Result := True;
    except
    end;

  end else FreeHandleStream(stream);
end;






{ ********************* Auxiliary functions & procedures ******************** }

function TAPETag.ReadFooter(stream: Thandlestream; var Tag: APETagInfo): Boolean;
var
  TagID: array [1..3] of Char;
  Transferred: Integer;
begin
  { Load footer from file to variable }
  try
    Result := True;
    { Set read-access and open file }
    Tag.FileSize := stream.Size;
    { Check for existing ID3v1 tag }
    stream.Seek(Tag.FileSize - ID3V1_TAG_SIZE,sofrombeginning);
    stream.Read(TagID, SizeOf(TagID));
    if TagID = ID3V1_ID then Tag.DataShift := ID3V1_TAG_SIZE;
    { Read footer data }
    stream.Seek(Tag.FileSize - Tag.DataShift - APE_TAG_FOOTER_SIZE,sofrombeginning);
    Transferred := stream.Read(Tag, APE_TAG_FOOTER_SIZE);
    { if transfer is not complete }
    if Transferred < APE_TAG_FOOTER_SIZE then Result := False;
  except
    { Error }
    Result := False;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.SetTagItem(const FieldName, FieldValue: string; var Tag: APETagInfo);
var
  Iterator: Byte;
  len: Integer;
  widestr: WideString;
begin
  { Set tag item if supported field found }
  for Iterator := 1 to APE_FIELD_COUNT do
    if UpperCase(FieldName) = UpperCase(APE_FIELD[Iterator]) then
      if Tag.Version > APE_VERSION_1_0 then
        Tag.Field[Iterator] := FieldValue //output in utf8 siamo a cavallo
      else begin
        //FieldValue := trim(FieldValue); //output in locales

        if length(FieldValue)=0 then exit;
        if length(FieldValue)>100 then exit;
        SetLength(widestr,length(FieldValue)*2);    //CP_OEMCP
         len := MultiByteToWideChar(CP_OEMCP, 0, pansichar(FieldValue), Length(FieldValue), pwidechar(widestr),length(widestr));
         if len<>0 then SetLength(widestr,len);
          Tag.Field[Iterator] := widestrtoutf8str(widestr);
      end;
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.ReadFields(stream: Thandlestream; var Tag: APETagInfo);
var
  FieldName: string;
  FieldValue: array [1..250] of Char;
  NextChar: Char;
  Iterator, ValueSize, ValuePosition, FieldFlags: Integer;
begin
  try
    { Set read-access, open file }

    stream.Seek(Tag.FileSize - Tag.DataShift - Tag.Size,sofrombeginning);
    { Read all stored fields }
    for Iterator := 1 to Tag.Fields do
    begin
      FillChar(FieldValue, SizeOf(FieldValue), 0);
      stream.Read(ValueSize, SizeOf(ValueSize));
      stream.Read(FieldFlags, SizeOf(FieldFlags));
      FieldName := '';
      repeat
        stream.Read(NextChar, SizeOf(NextChar));
        FieldName := FieldName + NextChar;
      until Ord(NextChar) = 0;
      ValuePosition := stream.Position;
      stream.Read(FieldValue, ValueSize mod SizeOf(FieldValue));
      SetTagItem(Trim(FieldName), Trim(FieldValue), Tag);
      stream.Seek(ValuePosition + ValueSize,sofrombeginning);
    end;

  except
  end;
end;

{ --------------------------------------------------------------------------- }

function TAPEtag.GetTrack(const TrackString: string): Byte;
var
  Index, Value, Code: Integer;
begin
  { Get track from string }
  Index := Pos('/', TrackString);
  if Index = 0 then Val(TrackString, Value, Code)
  else Val(Copy(TrackString, 1, Index - 1), Value, Code);
  if Code = 0 then Result := Value
  else Result := 0;
end;

{ ********************** Private functions & procedures ********************* }

procedure TAPEtag.FSetTitle(const NewTitle: string);
begin
  { Set song title }
  FTitle := Trim(NewTitle);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetArtist(const NewArtist: string);
begin
  { Set artist name }
  FArtist := Trim(NewArtist);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetAlbum(const NewAlbum: string);
begin
  { Set album title }
  FAlbum := Trim(NewAlbum);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetTrack(const NewTrack: Byte);
begin
  { Set track number }
  FTrack := NewTrack;
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetYear(const NewYear: string);
begin
  { Set release year }
  FYear := Trim(NewYear);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetGenre(const NewGenre: string);
begin
  { Set genre name }
  FGenre := Trim(NewGenre);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetComment(const NewComment: string);
begin
  { Set comment }
  FComment := Trim(NewComment);
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.FSetCopyright(const NewCopyright: string);
begin
  { Set copyright information }
  FCopyright := Trim(NewCopyright);
end;

{ ********************** Public functions & procedures ********************** }

constructor TAPEtag.Create;
begin
  { Create object }
  inherited;
  ResetData;
end;

{ --------------------------------------------------------------------------- }

procedure TAPEtag.ResetData;
begin
  { Reset all variables }
  FExists := False;
  FVersion := 0;
  FSize := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FYear := '';
  FGenre := '';
  FComment := '';
  FCopyright := '';
end;

{ --------------------------------------------------------------------------- }

function TAPEtag.ReadFromFile(stream: Thandlestream): Boolean;
var
  Tag: APETagInfo;
begin
  { Reset data and load footer from file to variable }
  ResetData;
  FillChar(Tag, SizeOf(Tag), 0);
  Result := ReadFooter(stream, Tag);
  { Process data if loaded and footer valid }
  if (Result) and (Tag.ID = APE_ID) then begin
    FExists := True;
    { Fill properties with footer data }
    FVersion := Tag.Version;
    FSize := Tag.Size;
    { Get information from fields }
    ReadFields(stream, Tag);
    FTitle := Tag.Field[1];
    FArtist := Tag.Field[2];
    FAlbum := Tag.Field[3];
    FTrack := GetTrack(Tag.Field[4]);
    FYear := Tag.Field[5];
    FGenre := Tag.Field[6];
    FComment := Tag.Field[7];
    FCopyright := Tag.Field[8];
  end;
end;


function tid3v1.ReadTag(var TagData: TagRecord; stream: Thandlestream): Boolean;
begin
  try
    Result := True;
    { Set read-access and open file }

    { Read tag }
    stream.Seek(stream.size - 128,sofrombeginning);
    stream.read(TagData, 128);

  except
    { Error }
    Result := False;
  end;
end;

function GetTagVersion(const TagData: TagRecord): Byte;
begin
  Result := TAG_VERSION_1_0;
  { Terms for ID3v1.1 }
  if ((TagData.Comment[28] = #0) and (TagData.Comment[29] <> #0)) or
    ((TagData.Comment[28] = #32) and (TagData.Comment[29] <> #32)) then
    Result := TAG_VERSION_1_1;
end;

{ ********************** Private functions & procedures ********************* }

procedure TID3v1.FSetTitle(const NewTitle: String);
begin
  FTitle := TrimRight(NewTitle);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetArtist(const NewArtist: String);
begin
  FArtist := TrimRight(NewArtist);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetAlbum(const NewAlbum: String);
begin
  FAlbum := TrimRight(NewAlbum);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetYear(const NewYear: String);
begin
  FYear := TrimRight(NewYear);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetComment(const NewComment: String);
begin
  FComment := TrimRight(NewComment);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetTrack(const NewTrack: Byte);
begin
  FTrack := NewTrack;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.FSetGenreID(const NewGenreID: Byte);
begin
  FGenreID := NewGenreID;
end;

{ --------------------------------------------------------------------------- }

function TID3v1.FGetGenre: string;
begin
  Result := '';
  { Return an empty string if the current GenreID is not valid }
  if FGenreID in [0..MAX_MUSIC_GENRES - 1] then Result := MusicGenre[FGenreID];
end;

{ ********************** Public functions & procedures ********************** }

constructor TID3v1.Create;
begin
  inherited;
  ResetData;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v1.ResetData;
begin
  FExists := False;
  FVersionID := TAG_VERSION_1_0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FYear := '';
  FComment := '';
  FTrack := 0;
  FGenreID := DEFAULT_GENRE;
end;

{ --------------------------------------------------------------------------- }

function TID3v1.ReadFromFile(stream: Thandlestream): Boolean;
var
  TagData: TagRecord;
begin
  { Reset and load tag data from file to variable }
  ResetData;
  Result := ReadTag(TagData, stream);

  { Process data if loaded and tag header OK }
  if TagData.Header='TAG' then begin

    FExists := True;
    //delete(ftitle,pos(chr(0),Ftitle),length(FTitle));
    //FVersionID := GetTagVersion(TagData);
    { Fill properties with tag data }

    FTitle := convert_oem({TrimRight(}TagData.Title);
    FArtist := convert_oem(TagData.Artist);
    FAlbum := convert_oem(TagData.Album);
    FYear := convert_oem(TagData.Year);

    //if FVersionID = TAG_VERSION_1_0 then
      //FComment := convert_oem(TagData.Comment)
   // else
    //begin
      //FComment := convert_oem(TagData.Comment,28);
      //FTrack := Ord(TagData.Comment[29]);
   // end;
    FGenreID := TagData.Genre;
 end;
end;

function TID3v1.convert_oem(strin: array of char; max:integer=30): string;
var
i: Integer;
begin
    for i := 1 to max do begin
     if strin[i]=chr(0) then break;
    end;
    if i=max then SetLength(result,i) else SetLength(result,i-1);
    move(strin[0],result[1],length(result));
    
    exit;
  //  SetLength(widestr,length(strin)*2);    //CP_OEMCP
   // len := MultiByteToWideChar(CP_ACP{CP_OEMCP}, 0, pansichar(strin), Length(strin), pwidechar(widestr),length(widestr));
   // if len<>0 then SetLength(widestr,len);

   // Result :=  widestrtoutf8str(widestr);
end;


function tid3v2.ReadHeader(var Tag: ID3v2TagInfo; stream: Thandlestream): Boolean;
var

  Transferred: Integer;
begin
  try
    Result := True;
    { Set read-access and open file }
    Transferred := stream.read(tag,10);
    { Read header and get file size }
    Tag.FileSize := stream.size;;


    { if transfer is not complete }
    if Transferred < 10 then Result := False;

  except
    { Error }
    Result := False;
  end;
end;

{ --------------------------------------------------------------------------- }

function tid3v2.GetTagSize(const Tag: ID3v2TagInfo): Integer;
begin
  { Get total tag size }
  Result := 
    Tag.Size[1] * $200000 +
    Tag.Size[2] * $4000 +
    Tag.Size[3] * $80 +
    Tag.Size[4] + 10;
  if Tag.Flags and $10 = $10 then Inc(Result, 10);
  if Result > Tag.FileSize then Result := 0;
end;

{ --------------------------------------------------------------------------- }
procedure StrSwapByteOrder(Str: PWideChar);

// exchanges in each character of the given string the low order and high order
// byte to go from LSB to MSB and vice versa.
// EAX contains address of string

asm
         PUSH ESI
         PUSH EDI
         MOV ESI, EAX
         MOV EDI, ESI
         XOR EAX, EAX  // clear high order byte to be able to use 32bit operand below
@@1:     LODSW
         OR EAX, EAX
         JZ @@2
         XCHG AL, AH
         STOSW
         JMP @@1

@@2:     POP EDI
         POP ESI
end;

procedure tid3v2.SetTagItem(const ID, Data: string; var Tag: ID3v2TagInfo);
var
  Iterator: Byte;
  FrameID,temp: string;
  wstr: WideString;
  shouldswap: Boolean;
  i: Integer;
  char1,char2:char;
begin
  { Set tag item if supported frame found }
  if length(data)<1 then exit;

  for Iterator := 1 to ID3V2_FRAME_COUNT{16} do begin
    if Tag.Version>TAG_VERSION_2_2 then FrameID := ID3V2_FRAME_NEW[Iterator]
     else FrameID := ID3V2_FRAME_OLD[Iterator];

    if FrameID=ID then begin

      if length(data)<1 then begin
       Tag.Frame[Iterator] := '';
       continue;
      end;

     if Data[1]<=UNICODE_ID then begin
      if data[1]=chr(0) then begin
       Tag.Frame[Iterator] := PChar(copy(data,2,length(data)));
      end else begin
        if length(data)<3 then begin  // should contain at least unicode BOM
         Tag.Frame[Iterator] := '';
         continue;
        end;
        // search for BOM
        if ((data[2]<>chr($ff)) and (data[3]<>chr($fe))) then
         if ((data[2]<>chr($fe)) and (data[3]<>chr($ff))) then begin
          Tag.Frame[Iterator] := '';
          continue;
         end;

        shouldswap := ((data[2]=chr($FE)) and (data[3]=chr($FF)));

        temp := copy(data,4,length(data)); //skip unicode BOM

        if shouldSwap then begin
         i := 1;
          while (i+1<=length(temp)) do begin
           char1 := temp[i];
           char2 := temp[i+1];
           temp[i] := char2;
           temp[i+1] := char1;
           inc(i,2);
          end;
        end;

        wstr := pwidechar(temp);
        for i := 1 to length(wstr) do if integer(wstr[i])=0 then begin
         delete(wstr,i,length(wstr));
         break;
        end;

        Tag.Frame[Iterator] := widestrtoutf8str(wstr);
        
      end;
     end else Tag.Frame[Iterator] := data; // ISO-8859-1  if not specified

    end;

  end;
end;

{ --------------------------------------------------------------------------- }

function tid3v2.Swap32(const Figure: Integer): Integer;
var
  ByteArray: array [1..4] of Byte absolute Figure;
begin
  { Swap 4 bytes }
  Result := 
    Bytearray [1] * $1000000 +
    Bytearray [2] * $10000 +
    Bytearray [3] * $100 +
    Bytearray [4];
end;

{ --------------------------------------------------------------------------- }

procedure tid3v2.ReadFramesNew(var Tag: id3v2TagInfo; stream: Thandlestream);
var
  Frame: FrameHeaderNew;
  Data: array [1..500] of Char;
  //buffer: array [0..500] of Byte;
  DataPosition, DataSize: Integer;
begin

{FrameHeaderNew
    ID: array [1..4] of Char;  Frame ID
    Size: cardinal; //Int64;     Size excluding header
    Flags: Word;                Flags
}

  { Get information from frames (ID3v2.3.x & ID3v2.4.x) }
  try
    { Set read-access, open file }
    while (stream.Position < GetTagSize(Tag)) and (stream.position+1<stream.size) do
    begin

      FillChar(Data, SizeOf(Data), 0);
      { Read frame header and check frame ID }
      stream.read(Frame, 10);
      if not (Frame.ID[1] in ['A'..'Z']) then break;
      { Note data position and determine significant data size }
      DataPosition := stream.Position;
      if Swap32(Frame.Size)>SizeOf(Data) then DataSize := SizeOf(Data)
       else DataSize := Swap32(Frame.Size);

      { Read frame data and set tag item if frame supported }
      stream.read(data, DataSize);

      if Frame.Flags and $8000 <> $8000 then SetTagItem(Frame.ID, Data, Tag);
      stream.seek( DataPosition + Swap32(Frame.Size),sofrombeginning);
    end;

  except
  end;

end;

{ --------------------------------------------------------------------------- }

procedure tid3v2.ReadFramesOld(var Tag: id3v2TagInfo; stream: Thandlestream);
var
  Frame: FrameHeaderOld;
  Data: array [1..500] of Char;
  DataPosition, FrameSize, DataSize: Integer;
begin
  { Get information from frames (ID3v2.2.x) }
  try
    while (stream.position < GetTagSize(Tag)) and (stream.position+1<stream.size) do
    begin
      FillChar(Data, SizeOf(Data), 0);
      { Read frame header and check frame ID }
      stream.Read(Frame, 6);
      if not (Frame.ID[1] in ['A'..'Z']) then break;
      { Note data position and determine significant data size }
      DataPosition := stream.position;
      FrameSize := Frame.Size[1] shl 16 + Frame.Size[2] shl 8 + Frame.Size[3];
      if FrameSize > SizeOf(Data) then DataSize := SizeOf(Data)
      else DataSize := FrameSize;
      { Read frame data and set tag item if frame supported }
      stream.Read(Data, DataSize);
      SetTagItem(Frame.ID, Data, Tag);
      stream.Seek(DataPosition + FrameSize,sofrombeginning);
    end;
  except
  end;
end;

{ --------------------------------------------------------------------------- }

function tid3v2.GetANSI(const Source: string): string;
const
IS_TEXT_UNICODE_STATISTICS=2;
IS_TEXT_UNICODE_UNICODE_MASK=$f;
var
  Index,len: Integer;
  FirstByte, SecondByte: Byte;
  UnicodeChar: WideChar;
  widestr: WideString;
  sources: string;
begin
  { Convert string from unicode if needed and trim spaces }
  if (Length(Source) > 0) and (Source[1] = UNICODE_ID) then
  begin
    widestr := '';
    for Index := 1 to ((Length(Source)-1) div 2) do
    begin
      FirstByte := Ord(Source[Index * 2]);
      SecondByte := Ord(Source[Index * 2 + 1]);
      UnicodeChar := WideChar(FirstByte or (SecondByte shl 8));
      if UnicodeChar=#0 then break; //fine stringa
      if FirstByte<$FF then widestr := widestr+UnicodeChar;
    end;
    Result := widestrtoutf8str(widestr);
  end
  else begin
    Result := '';
    sources := trim(source);
    if length(sources)=0 then exit;

        if length(sources)>100 then exit;
        SetLength(widestr,length(sources)*2);    //CP_OEMCP
        len := MultiByteToWideChar(CP_ACP{CP_OEMCP}, 0, pansichar(sources), Length(sources), pwidechar(widestr),length(widestr));
        if len<>0 then SetLength(widestr,len);

    Result :=  widestrtoutf8str(widestr);
  end;
end;

{ --------------------------------------------------------------------------- }

function tid3v2.GetContent(const Content1, Content2: string): string;
begin
  { Get content preferring the first content }
  Result := {GetANSI(}Content1{)}; 
  if Result='' then Result := {GetANSI(}Content2{)};
end;

{ --------------------------------------------------------------------------- }

function tid3v2.ExtractTrack(const TrackString: string): Word;
var
  Track: string;
  Index, Value, Code: Integer;
begin
  { Extract track from string }
  Track := GetANSI(TrackString);
  Index := Pos('/', Track);
  if Index = 0 then Val(Track, Value, Code)
  else Val(Copy(Track, 1, Index - 1), Value, Code);
  if Code = 0 then Result := Value
  else Result := 0;
end;

{ --------------------------------------------------------------------------- }

function tid3v2.ExtractYear(const YearString, DateString: string): string;
begin
  { Extract year from strings }
  Result := GetANSI(YearString);
  if Result = '' then Result := Copy(GetANSI(DateString), 1, 4);
end;

{ --------------------------------------------------------------------------- }

function tid3v2.ExtractGenre(const GenreString: string): string;
begin
  { Extract genre from string }
  Result := GetANSI(GenreString);
  if Pos(')', Result) > 0 then Delete(Result, 1, LastDelimiter(')', Result));
end;

{ --------------------------------------------------------------------------- }

function tid3v2.ExtractText(const SourceString: string; LanguageID: Boolean): string;
var
  Source, Separator: string;
  EncodingID: Char;
begin
  { Extract significant text data from a complex field }
  Source := SourceString;
  Result := '';
  if Length(Source) > 0 then
  begin
    EncodingID := Source[1];
    if EncodingID = UNICODE_ID then Separator := #0#0
    else Separator := #0;
    if LanguageID then  Delete(Source, 1, 4)
    else Delete(Source, 1, 1);
    Delete(Source, 1, Pos(Separator, Source) + Length(Separator) - 1);
    Result := GetANSI(EncodingID + Source);
  end;
end;

{ ********************** Private functions & procedures ********************* }

procedure TID3v2.FSetTitle(const NewTitle: string);
begin
  { Set song title }
  FTitle := Trim(NewTitle);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetArtist(const NewArtist: string);
begin
  { Set artist name }
  FArtist := Trim(NewArtist);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetAlbum(const NewAlbum: string);
begin
  { Set album title }
  FAlbum := Trim(NewAlbum);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetTrack(const NewTrack: Word);
begin
  { Set track number }
  FTrack := NewTrack;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetYear(const NewYear: string);
begin
  { Set release year }
  FYear := Trim(NewYear);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetGenre(const NewGenre: string);
begin
  { Set genre name }
  FGenre := Trim(NewGenre);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetComment(const NewComment: string);
begin
  { Set comment }
  FComment := Trim(NewComment);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetComposer(const NewComposer: string);
begin
  { Set composer name }
  FComposer := Trim(NewComposer);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetEncoder(const NewEncoder: string);
begin
  { Set encoder name }
  FEncoder := Trim(NewEncoder);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetCopyright(const NewCopyright: string);
begin
  { Set copyright information }
  FCopyright := Trim(NewCopyright);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetLanguage(const NewLanguage: string);
begin
  { Set language }
  FLanguage := Trim(NewLanguage);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetLink(const NewLink: string);
begin
  { Set URL link }
  FLink := Trim(NewLink);
end;

{ ********************** Public functions & procedures ********************** }

constructor TID3v2.Create;
begin
  { Create object }
  inherited;
  ResetData;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.ResetData;
begin
  { Reset all variables }
  FExists := False;
  FVersionID := 0;
  FSize := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FTrackString := '';
  FYear := '';
  FGenre := '';
  FComment := '';
  FComposer := '';
  FEncoder := '';
  FCopyright := '';
  FLanguage := '';
  FLink := '';
end;

{ --------------------------------------------------------------------------- }

function TID3v2.ReadFromFile(stream: Thandlestream ): Boolean;
var
  Tag: ID3v2TagInfo;
begin
  { Reset data and load header from file to variable }
  ResetData;
  Result := ReadHeader(Tag ,stream);
  { Process data if loaded and header valid }
  if (Result) and (Tag.ID = ID3V2_ID) then
  begin
    FExists := True;
    { Fill properties with header data }
    FVersionID := Tag.Version;
    FSize := GetTagSize(Tag);
    
    { Get information from frames if version supported }
    if (FVersionID in [TAG_VERSION_2_2..TAG_VERSION_2_4]) and (FSize > 0) then begin
      if FVersionID > TAG_VERSION_2_2 then ReadFramesNew(Tag,stream)
       else ReadFramesOld(Tag,stream);
      FTitle := GetContent(Tag.Frame[1], Tag.Frame[15]);
      FArtist := GetContent(Tag.Frame[2], Tag.Frame[14]);
      FAlbum := GetContent(Tag.Frame[3], Tag.Frame[16]);
      FTrack := ExtractTrack(Tag.Frame[4]);
      FTrackString := GetANSI(Tag.Frame[4]);
      FYear := ExtractYear(Tag.Frame[5], Tag.Frame[13]);
      FGenre := ExtractGenre(Tag.Frame[6]);
      FComment := ExtractText(Tag.Frame[7], true);
      FComposer := GetANSI(Tag.Frame[8]);
      FEncoder := GetANSI(Tag.Frame[9]);
      FCopyright := GetANSI(Tag.Frame[10]);
      FLanguage := GetANSI(Tag.Frame[11]);
      FLink := ExtractText(Tag.Frame[12], false);
    end;
  end;
end;


{ ********************** Private functions & procedures ********************* }

procedure TFLACfile.FResetData;
begin
  { Reset data }
  FChannels := 0;
  FSampleRate := 0;
  FBitsPerSample := 0;
  FFileLength := 0;
  FSamples := 0;
  FID3v1.ResetData;
  FID3v2.ResetData;
end;

{ --------------------------------------------------------------------------- }

function TFLACfile.FIsValid: Boolean;
begin
  { Check for right FLAC file data }
  Result := 
    (FChannels > 0) and
    (FSampleRate > 0) and
    (FBitsPerSample > 0) and
    (FSamples > 0);
end;

{ --------------------------------------------------------------------------- }

function TFLACfile.FGetDuration: Double;
begin
  { Get song duration }
  if FIsValid then
    Result := FSamples / FSampleRate
  else
    Result := 0;
end;

function TFLACfile.FGetBitrate: Integer;
begin
  { Get song duration }
  if FIsValid then
    Result := trunc( (FFileLength/FSamples)*(SampleRate/1000)*8)
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TFLACfile.FGetRatio: Double;
begin
  { Get compression ratio }
  if FIsValid then
    Result := FFileLength / (FSamples * FChannels * FBitsPerSample / 8) * 100
  else
    Result := 0;
end;

{ ********************** Public functions & procedures ********************** }

constructor TFLACfile.Create;
begin
  { Create object }
  inherited;
  FID3v1 := TID3v1.Create;
  FID3v2 := TID3v2.Create;
  FFlacVorbisTag := TFlacVorbisTag.create;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

destructor TFLACfile.Destroy;
begin
  { Destroy object }
  FID3v1.Free;
  FID3v2.Free;
  FFlacVorbisTag.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TFLACfile.ReadFromFile(const FileName: widestring): Boolean;
var
  stream: Thandlestream;
  Hdr: array [1..26] of Byte;
begin
  { Reset and load header data from file to array }
  FResetData;
  FillChar(Hdr, SizeOf(Hdr), 0);
  try
    Result := True;
    { Set read-access and open file }
    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

    FFlacVorbisTag.ReadFromFile(stream);
       stream.seek(0,sofrombeginning);
    FID3v2.ReadFromFile(stream); //cerchiamo id3
    FID3v1.ReadFromFile(stream);

    { Read header data }

    stream.seek(0,sofrombeginning);
    stream.Read(Hdr, SizeOf(Hdr));
    FFileLength := stream.Size;

    FreeHandleStream(stream);

    { Process data if loaded and header valid }
    if Hdr[1] + Hdr[2] + Hdr[3] + Hdr[4] = 342 then
    begin
      FChannels := Hdr[21] shr 1 and $7 + 1;
      FSampleRate := Hdr[19] shl 12 + Hdr[20] shl 4 + Hdr[21] shr 4;
      FBitsPerSample := Hdr[21] and 1 shl 4 + Hdr[22] shr 4 + 1;
      FSamples := Hdr[23] shl 24 + Hdr[24] shl 16 + Hdr[25] shl 8 + Hdr[26];
    end;
  except
    { Error }
    Result := False;
  end;
end;

constructor TFlacVorbisTag.Create;
begin
  { Create object }
  inherited;
  ResetData;
end;



function TFlacVorbisTag.ReadFromFile(stream: Thandlestream): Boolean;
var
buffer: array [0..2047] of char;
str: string;
tipo,tries: Byte;
lun: Integer;
begin
result := False;

if stream.read(buffer,4)<4 then exit;
SetLength(str,4);
 move(buffer,str[1],4);
if str<>'fLaC' then exit;

tries := 0;

while (stream.position<stream.size) do begin
 if stream.read(buffer,4)<4 then exit;
  SetLength(str,4);
  move(buffer,str[1],4);
   tipo := ord(str[1]);
  delete(str,1,1);
   lun := chars_2_dword(str);

  if tipo<>4 then begin
   stream.seek(stream.position+lun,sofrombeginning);
   inc(tries);
   if tries>10 then exit;
   continue;
  end;

  if lun>2048 then exit; //troppo lunghi...
  stream.read(buffer,lun);
  SetLength(str,lun);
  move(buffer,str[1],lun);
   Result := parse_tags(str);
exit;

end;

end;


procedure TFlacVorbisTag.ResetData;
begin
FTitle := '';
FArtist := '';
FAlbum := '';
FGenre := '';
FYear := '';
FComment := '';
FURL := '';
FExists := False;
end;

function TFlacVorbisTag.parse_tags(strin: string): Boolean;
var
lun,cicli,i: Integer;
vendors,field: string;
begin
//extract vendor
lun := chars_2_dword(copy(strin,1,4));
 delete(strin,1,4);
vendors := copy(strin,1,lun);
 delete(strin,1,lun);
cicli := chars_2_dword(copy(strin,1,4));
 delete(strin,1,4);

 for i := 1 to cicli do begin
  lun := chars_2_dword(copy(strin,1,4));
    delete(strin,1,4);
   field := copy(strin,1,lun);
    delete(strin,1,lun);

   if pos('TITLE=',field)=1 then FTitle := copy(Field,7,length(Field)) else
   if pos('ALBUM=',field)=1 then begin
    FAlbum := copy(Field,7,length(Field));
    end else
   if pos('ARTIST=',field)=1 then FArtist := copy(Field,8,length(Field)) else
   if pos('DESCRIPTION=',field)=1 then FComment := copy(Field,13,length(Field)) else
   if pos('GENRE=',field)=1 then FGenre := copy(Field,7,length(Field)) else
   if pos('DATE=',field)=1 then FYear := copy(Field,6,length(Field)) else
   if pos('CONTACT=',field)=1 then FURL := copy(Field,9,length(Field));

 end;

  Result := True;
  FExists := True;
end;

function TFlacVorbisTag.chars_2_dword(stringa: string): Integer;
begin
 if length(stringa)=3 then begin
  Result := 0;
  Result := Result shl 8;
  Result := ord(stringa[1]);
  Result := Result shl 8;
  Result := Result + ord(stringa[2]);
  Result := Result shl 8;
  Result := Result + ord(stringa[3]);
 end else
 if length(stringa)=4 then begin
  Result := ord(stringa[4]);
  Result := Result shl 8;
  Result := Result + ord(stringa[3]);
  Result := Result shl 8;
  Result := Result + ord(stringa[2]);
  Result := Result shl 8;
  Result := Result + ord(stringa[1]);
 end else Result := 0;
end;


{ ********************** Private functions & procedures ********************* }

procedure TMonkey.FResetData;
begin
  { Reset data }
  FFileLength := 0;
  FillChar(FHeader, SizeOf(FHeader), 0);
  FID3v1.ResetData;
  FID3v2.ResetData;
  FAPEtag.ResetData;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetValid: Boolean;
begin
  { Check for right Monkey's Audio file data }
  Result := 
    (FHeader.ID = 'MAC ') and
    (FHeader.SampleRate > 0) and
    (FHeader.Channels > 0);
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetVersion: string;
begin
  { Get encoder version }
  if FHeader.VersionID = 0 then Result := ''
  else Str(FHeader.VersionID / 1000 : 4 : 2, Result);
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetCompression: string;
begin
  { Get compression level }
  Result := MONKEY_COMPRESSION[FHeader.CompressionID div 1000];
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetBits: Byte;
begin
  { Get number of bits per sample }
  if FGetValid then
  begin
    Result := 16;
    if FHeader.Flags and MONKEY_FLAG_8_BIT > 0 then Result := 8;
    if FHeader.Flags and MONKEY_FLAG_24_BIT > 0 then Result := 24;
  end
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetChannelMode: string;
begin
  { Get channel mode }
  Result := MONKEY_MODE[FHeader.Channels];
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetPeak: Double;
begin
  { Get peak level ratio }
  if (FGetValid) and (FHeader.Flags and MONKEY_FLAG_PEAK_LEVEL > 0) then
    case FGetBits of
      16: Result := FHeader.PeakLevel / 32768 * 100;
      24: Result := FHeader.PeakLevel / 8388608 * 100;
      else Result := FHeader.PeakLevel / 128 * 100;
    end
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetSamplesPerFrame: Integer;
begin
  { Get number of samples in a frame }
  if FGetValid then
    if (FHeader.VersionID >= 3950) then
      Result := 9216 * 32
    else if (FHeader.VersionID >= 3900) or
      ((FHeader.VersionID >= 3800) and
      (FHeader.CompressionID = MONKEY_COMPRESSION_EXTRA_HIGH)) then
      Result := 9216 * 8
    else
      Result := 9216
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetSamples: Integer;
begin
  { Get number of samples }
  if FGetValid then
    Result := (FHeader.Frames - 1) * FGetSamplesPerFrame + FHeader.FinalSamples
  else
    Result := 0;
end;

function tmonkey.FGetSampleRate: Integer;
begin
result := FHeader.SampleRate;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.FGetDuration: Double;
begin
  { Get song duration }
  if FGetValid then Result := FGetSamples / FHeader.SampleRate
  else Result := 0;
end;

function TMonkey.FGetBitrate: integer;
begin
  { Get song duration }
  if FGetValid then Result := trunc( (FFileLength/FGetSamples)*(FHeader.SampleRate/1000)*8)
   else Result := 0;
end;



{ --------------------------------------------------------------------------- }

function TMonkey.FGetRatio: Double;
begin
  { Get compression ratio }
  if FGetValid then
    Result := FFileLength /
      (FGetSamples * FHeader.Channels * FGetBits / 8 + 44) * 100
  else
    Result := 0;
end;

{ ********************** Public functions & procedures ********************** }

constructor TMonkey.Create;
begin
  { Create object }
  inherited;
  FID3v1 := TID3v1.Create;
  FID3v2 := TID3v2.Create;
  FAPEtag := TAPEtag.Create;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

destructor TMonkey.Destroy;
begin
  { Destroy object }
  FID3v1.Free;
  FID3v2.Free;
  FAPEtag.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TMonkey.ReadFromFile(const FileName: widestring): Boolean;
var
  stream: Thandlestream;
begin
  try
    { Reset data and search for file tag }
    FResetData;

    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

    stream.seek(0,sofrombeginning);
    
    FID3v1.ReadFromFile(stream);
    FID3v2.ReadFromFile(stream);
    FAPEtag.ReadFromFile(stream);

    { Set read-access, open file and get file length }

    FFileLength := stream.Size;
    { Read Monkey's Audio header data }
    stream.Seek(ID3v2.Size,sofrombeginning);
    stream.Read(FHeader, SizeOf(FHeader));

    if FHeader.Flags and MONKEY_FLAG_PEAK_LEVEL = 0 then FHeader.PeakLevel := 0;
    if FHeader.Flags and MONKEY_FLAG_SEEK_ELEMENTS = 0 then FHeader.SeekElements := 0;

        FreeHandleStream(stream);
    Result := True;
  except
    FResetData;
    Result := False;
  end;
end;

{ ********************** Private functions & procedures ********************* }

procedure TMPCfile.FResetData;
begin
  Fduration := 0;
  FSampleRate := 0;
  FBitrate := 0;
  FID3v1.ResetData;
  FAPEtag.ResetData;
end;

{ --------------------------------------------------------------------------- }


{ ********************** Public functions & procedures ********************** }

constructor TMPCfile.Create;
begin
  { Create object }
  inherited;
  FID3v1 := TID3v1.Create;
  FAPEtag := TAPEtag.Create;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

destructor TMPCfile.Destroy;
begin
  { Destroy object }
  FID3v1.Free;
  FAPEtag.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TMPCfile.ReadFromFile(const FileName: widestring): Boolean;
var
  stream: Thandlestream;
  num: Integer;
  str: string;
  buffer: array [0..11] of char;
  frames: Integer;
  sampleratei,samples,versi,majorv: Integer;
begin
result := False;
  try
    { Reset data and search for file tag }
    FResetData;
    FValid := False;

    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;



    { Set read-access, open file and get file length }
    stream.seek(0,sofrombeginning);
     if stream.read(buffer,12)<12 then FreeHandleStream(Stream);

   SetLength(str,12);
   move(buffer,str[1],12);
   
     if copy(str,1,3)<>'MP+' then begin  //check header
        FreeHandleStream(stream);
       exit;
     end;

     versi := ord(str[4]);
     majorv := (versi and $0F);
     


  if majorv=7 then begin  //versione 7 al momento
     frames := chars_2_dword(copy(str,5,4));
      samples := (frames*1152);
     num := chars_2_dword(copy(str,9,4));
      // (num and $00F00000) shr 20; //profile
    sampleratei := (num and $00030000) shr 16; //sample rate
    case sampleratei of
     0:Fsamplerate := 44100;
     1:Fsamplerate := 48000;
     2:Fsamplerate := 37800;
     3:Fsamplerate := 32000 else Fsamplerate := 0;
    end;
   Fduration := samples div Fsamplerate;
   Fbitrate := trunc( (stream.Size/Samples)*(FSampleRate/1000)*8);
  end else
  if majorv=8 then begin  
  end;
    { Read Monkey's Audio header data }


    FAPEtag.ReadFromFile(stream);
    FID3v1.ReadFromFile(stream);

    FreeHandleStream(stream);

    Result := True;
    FValid := ((Fbitrate>0) and (Fduration>0) and (FSampleRate>0));
  except
    FResetData;
    Result := False;
  end;
end;


const
  { Limitation constants }
  MAX_MPEG_FRAME_LENGTH = 1729;                      { Max. MPEG frame length }
  MIN_MPEG_BIT_RATE = 8;                                { Min. bit rate value }
  MAX_MPEG_BIT_RATE = 448;                              { Max. bit rate value }
  MIN_ALLOWED_DURATION = 0.1;                      { Min. song duration value }

  { VBR Vendor ID strings }
  VENDOR_ID_LAME = 'LAME';                                         { For LAME }
  VENDOR_ID_GOGO_NEW = 'GOGO';                               { For GoGo (New) }
  VENDOR_ID_GOGO_OLD = 'MPGE';                               { For GoGo (Old) }

{ ********************* Auxiliary functions & procedures ******************** }

function IsFrameHeader(const HeaderData: array of Byte): Boolean;
begin
  { Check for valid frame header }
  if ((HeaderData[0] and $FF) <> $FF) or
    ((HeaderData[1] and $E0) <> $E0) or
    (((HeaderData[1] shr 3) and 3) = 1) or
    (((HeaderData[1] shr 1) and 3) = 0) or
    ((HeaderData[2] and $F0) = $F0) or
    ((HeaderData[2] and $F0) = 0) or
    (((HeaderData[2] shr 2) and 3) = 3) or
    ((HeaderData[3] and 3) = 2) then
    Result := false
  else
    Result := True;
end;

{ --------------------------------------------------------------------------- }

procedure DecodeHeader(const HeaderData: array of Byte; var Frame: FrameData);
begin
  { Decode frame header data }
  Move(HeaderData, Frame.Data, SizeOf(Frame.Data));
  Frame.VersionID := (HeaderData[1] shr 3) and 3;
  Frame.LayerID := (HeaderData[1] shr 1) and 3;
  Frame.ProtectionBit := (HeaderData[1] and 1) <> 1;
  Frame.BitRateID := HeaderData[2] shr 4;
  Frame.SampleRateID := (HeaderData[2] shr 2) and 3;
  Frame.PaddingBit := ((HeaderData[2] shr 1) and 1) = 1;
  Frame.PrivateBit := (HeaderData[2] and 1) = 1;
  Frame.ModeID := (HeaderData[3] shr 6) and 3;
  Frame.ModeExtensionID := (HeaderData[3] shr 4) and 3;
  Frame.CopyrightBit := ((HeaderData[3] shr 3) and 1) = 1;
  Frame.OriginalBit := ((HeaderData[3] shr 2) and 1) = 1;
  Frame.EmphasisID := HeaderData[3] and 3;
end;

{ --------------------------------------------------------------------------- }

function ValidFrameAt(const Index: Word; Data: array of Byte): Boolean;
var
  HeaderData: array [1..4] of Byte;
begin
  { Check for frame at given position }
  HeaderData[1] := Data[Index];
  HeaderData[2] := Data[Index + 1];
  HeaderData[3] := Data[Index + 2];
  HeaderData[4] := Data[Index + 3];
  if IsFrameHeader(HeaderData) then Result := true
  else Result := False;
end;

{ --------------------------------------------------------------------------- }

function GetCoefficient(const Frame: FrameData): Byte;
begin
  { Get frame size coefficient }
  if Frame.VersionID = MPEG_VERSION_1 then
    if Frame.LayerID = MPEG_LAYER_I then Result := 48
    else Result := 144
  else
    if Frame.LayerID = MPEG_LAYER_I then Result := 24
    else if Frame.LayerID = MPEG_LAYER_II then Result := 144
    else Result := 72;
end;

{ --------------------------------------------------------------------------- }

function GetBitRate(const Frame: FrameData): Word;
begin
  { Get bit rate }
  Result := MPEG_BIT_RATE[Frame.VersionID, Frame.LayerID, Frame.BitRateID];
end;

{ --------------------------------------------------------------------------- }

function GetSampleRate(const Frame: FrameData): Word;
begin
  { Get sample rate }
  Result := MPEG_SAMPLE_RATE[Frame.VersionID, Frame.SampleRateID];
end;

{ --------------------------------------------------------------------------- }

function GetPadding(const Frame: FrameData): Byte;
begin
  { Get frame padding }
  if Frame.PaddingBit then
    if Frame.LayerID = MPEG_LAYER_I then Result := 4
    else Result := 1
  else Result := 0;
end;

{ --------------------------------------------------------------------------- }

function GetFrameLength(const Frame: FrameData): Word;
var
  Coefficient, BitRate, SampleRate, Padding: Word;
begin
  { Calculate MPEG frame length }
  Coefficient := GetCoefficient(Frame);
  BitRate := GetBitRate(Frame);
  SampleRate := GetSampleRate(Frame);
  Padding := GetPadding(Frame);
  Result := Trunc(Coefficient * BitRate * 1000 / SampleRate) + Padding;
end;

{ --------------------------------------------------------------------------- }

function IsXing(const Index: Word; Data: array of Byte): Boolean;
begin
  { Get true if Xing encoder }
  Result := 
    (Data[Index] = 0) and
    (Data[Index + 1] = 0) and
    (Data[Index + 2] = 0) and
    (Data[Index + 3] = 0) and
    (Data[Index + 4] = 0) and
    (Data[Index + 5] = 0);
end;

{ --------------------------------------------------------------------------- }

function GetXingInfo(const Index: Word; Data: array of Byte): VBRData;
begin
  { Extract Xing VBR info at given position }
  FillChar(Result, SizeOf(Result), 0);
  Result.Found := True;
  Result.ID := VBR_ID_XING;
  Result.Frames := 
    Data[Index + 8] * $1000000 +
    Data[Index + 9] * $10000 +
    Data[Index + 10] * $100 +
    Data[Index + 11];
  Result.Bytes := 
    Data[Index + 12] * $1000000 +
    Data[Index + 13] * $10000 +
    Data[Index + 14] * $100 +
    Data[Index + 15];
  Result.Scale := Data[Index + 119];
  { Vendor ID can be not present }
  Result.VendorID := 
    Chr(Data[Index + 120]) +
    Chr(Data[Index + 121]) +
    Chr(Data[Index + 122]) +
    Chr(Data[Index + 123]) +
    Chr(Data[Index + 124]) +
    Chr(Data[Index + 125]) +
    Chr(Data[Index + 126]) +
    Chr(Data[Index + 127]);
end;

{ --------------------------------------------------------------------------- }

function GetFhGInfo(const Index: Word; Data: array of Byte): VBRData;
begin
  { Extract FhG VBR info at given position }
  FillChar(Result, SizeOf(Result), 0);
  Result.Found := True;
  Result.ID := VBR_ID_FHG;
  Result.Scale := Data[Index + 9];
  Result.Bytes := 
    Data[Index + 10] * $1000000 +
    Data[Index + 11] * $10000 +
    Data[Index + 12] * $100 +
    Data[Index + 13];
  Result.Frames := 
    Data[Index + 14] * $1000000 +
    Data[Index + 15] * $10000 +
    Data[Index + 16] * $100 +
    Data[Index + 17];
end;

{ --------------------------------------------------------------------------- }

function FindVBR(const Index: Word; Data: array of Byte): VBRData;
begin
  { Check for VBR header at given position }
  FillChar(Result, SizeOf(Result), 0);
  if Chr(Data[Index]) +
    Chr(Data[Index + 1]) +
    Chr(Data[Index + 2]) +
    Chr(Data[Index + 3]) = VBR_ID_XING then Result := GetXingInfo(Index, Data);
  if Chr(Data[Index]) +
    Chr(Data[Index + 1]) +
    Chr(Data[Index + 2]) +
    Chr(Data[Index + 3]) = VBR_ID_FHG then Result := GetFhGInfo(Index, Data);
end;

{ --------------------------------------------------------------------------- }

function GetVBRDeviation(const Frame: FrameData): Byte;
begin
  { Calculate VBR deviation }
  if Frame.VersionID = MPEG_VERSION_1 then
    if Frame.ModeID <> MPEG_CM_MONO then Result := 36
    else Result := 21
  else
    if Frame.ModeID <> MPEG_CM_MONO then Result := 21
    else Result := 13;
end;

{ --------------------------------------------------------------------------- }

function FindFrame(const Data: array of Byte; var VBR: VBRData): FrameData;
var
  HeaderData: array [1..4] of Byte;
  Iterator: Integer;
begin
  { Search for valid frame }
  FillChar(Result, SizeOf(Result), 0);
  Move(Data, HeaderData, SizeOf(HeaderData));
  for Iterator := 0 to SizeOf(Data) - MAX_MPEG_FRAME_LENGTH do
  begin
    { Decode data if frame header found }
    if IsFrameHeader(HeaderData) then
    begin
      DecodeHeader(HeaderData, Result);
      { Check for next frame and try to find VBR header }
      if ValidFrameAt(Iterator + GetFrameLength(Result), Data) then
      begin
        Result.Found := True;
        Result.Position := Iterator;
        Result.Size := GetFrameLength(Result);
        Result.Xing := IsXing(Iterator + SizeOf(HeaderData), Data);
        VBR := FindVBR(Iterator + GetVBRDeviation(Result), Data);
        break;
      end;
    end;
    { Prepare next data block }
    HeaderData[1] := HeaderData[2];
    HeaderData[2] := HeaderData[3];
    HeaderData[3] := HeaderData[4];
    HeaderData[4] := Data[Iterator + SizeOf(HeaderData)];
  end;
end;

{ --------------------------------------------------------------------------- }

function FindVendorID(const Data: array of Byte; Size: Word): string;
var
  Iterator: Integer;
  VendorID: string;
begin
  { Search for vendor ID }
  Result := '';
  if (SizeOf(Data) - Size - 8) < 0 then Size := SizeOf(Data) - 8;
  for Iterator := 0 to Size do
  begin
    VendorID := 
      Chr(Data[SizeOf(Data) - Iterator - 8]) +
      Chr(Data[SizeOf(Data) - Iterator - 7]) +
      Chr(Data[SizeOf(Data) - Iterator - 6]) +
      Chr(Data[SizeOf(Data) - Iterator - 5]);
    if VendorID = VENDOR_ID_LAME then
    begin
      Result := VendorID +
        Chr(Data[SizeOf(Data) - Iterator - 4]) +
        Chr(Data[SizeOf(Data) - Iterator - 3]) +
        Chr(Data[SizeOf(Data) - Iterator - 2]) +
        Chr(Data[SizeOf(Data) - Iterator - 1]);
      break;
    end;
    if VendorID = VENDOR_ID_GOGO_NEW then
    begin
      Result := VendorID;
      break;
    end;
  end;
end;

{ ********************** Private functions & procedures ********************* }

procedure TMPEGaudio.FResetData;
begin
  { Reset all variables }
  FFileLength := 0;
  FVendorID := '';
  FillChar(FVBR, SizeOf(FVBR), 0);
  FillChar(FFrame, SizeOf(FFrame), 0);
  FFrame.VersionID := MPEG_VERSION_UNKNOWN;
  FFrame.SampleRateID := MPEG_SAMPLE_RATE_UNKNOWN;
  FFrame.ModeID := MPEG_CM_UNKNOWN;
  FFrame.ModeExtensionID := MPEG_CM_EXTENSION_UNKNOWN;
  FFrame.EmphasisID := MPEG_EMPHASIS_UNKNOWN;
  FID3v1.ResetData;
  FID3v2.ResetData;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetVersion: string;
begin
  { Get MPEG version name }
  Result := MPEG_VERSION[FFrame.VersionID];
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetLayer: string;
begin
  { Get MPEG layer name }
  Result := MPEG_LAYER[FFrame.LayerID];
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetBitRate: Word;
begin
  { Get bit rate, calculate average bit rate if VBR header found }
  if (FVBR.Found) and (FVBR.Frames > 0) then
    Result := Round((FVBR.Bytes / FVBR.Frames - GetPadding(FFrame)) *
      GetSampleRate(FFrame) / GetCoefficient(FFrame) / 1000)
  else
    Result := GetBitRate(FFrame);
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetSampleRate: Word;
begin
  { Get sample rate }
  Result := GetSampleRate(FFrame);
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetChannelMode: string;
begin
  { Get channel mode name }
  Result := MPEG_CM_MODE[FFrame.ModeID];
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetEmphasis: string;
begin
  { Get emphasis name }
  Result := MPEG_EMPHASIS[FFrame.EmphasisID];
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetFrames: Integer;
var
  MPEGSize: Integer;
begin
  { Get total number of frames, calculate if VBR header not found }
  if FVBR.Found then
    Result := FVBR.Frames
  else
  begin
    if FID3v1.Exists then MPEGSize := FFileLength - FID3v2.Size - 128
    else MPEGSize := FFileLength - FID3v2.Size;
    Result := (MPEGSize - FFrame.Position) div GetFrameLength(FFrame);
  end;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetDuration: Double;
var
  MPEGSize: Integer;
begin
  { Calculate song duration }
  if FFrame.Found then
    if (FVBR.Found) and (FVBR.Frames > 0) then
      Result := FVBR.Frames * GetCoefficient(FFrame) * 8 /
        GetSampleRate(FFrame)
    else
    begin
      if FID3v1.Exists then MPEGSize := FFileLength - FID3v2.Size - 128
      else MPEGSize := FFileLength - FID3v2.Size;
      Result := (MPEGSize - FFrame.Position) / GetBitRate(FFrame) / 1000 * 8;
    end
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetVBREncoderID: Byte;
begin
  { Guess VBR encoder and get ID }
  Result := 0;
  if Copy(FVBR.VendorID, 1, 4) = VENDOR_ID_LAME then
    Result := MPEG_ENCODER_LAME;
  if Copy(FVBR.VendorID, 1, 4) = VENDOR_ID_GOGO_NEW then
    Result := MPEG_ENCODER_GOGO;
  if Copy(FVBR.VendorID, 1, 4) = VENDOR_ID_GOGO_OLD then
    Result := MPEG_ENCODER_GOGO;
  if (FVBR.ID = VBR_ID_XING) and
    (Copy(FVBR.VendorID, 1, 4) <> VENDOR_ID_LAME) and
    (Copy(FVBR.VendorID, 1, 4) <> VENDOR_ID_GOGO_NEW) and
    (Copy(FVBR.VendorID, 1, 4) <> VENDOR_ID_GOGO_OLD) then
    Result := MPEG_ENCODER_XING;
  if FVBR.ID = VBR_ID_FHG then
    Result := MPEG_ENCODER_FHG;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetCBREncoderID: Byte;
begin
  { Guess CBR encoder and get ID }
  Result := MPEG_ENCODER_FHG;
  if (FFrame.OriginalBit) and
    (FFrame.ProtectionBit) then
    Result := MPEG_ENCODER_LAME;
  if (GetBitRate(FFrame) <= 160) and
    (FFrame.ModeID = MPEG_CM_STEREO) then
    Result := MPEG_ENCODER_BLADE;
  if (FFrame.CopyrightBit) and
    (FFrame.OriginalBit) and
    (not FFrame.ProtectionBit) then
    Result := MPEG_ENCODER_XING;
  if (FFrame.Xing) and
    (FFrame.OriginalBit) then
    Result := MPEG_ENCODER_XING;
  if FFrame.LayerID = MPEG_LAYER_II then
    Result := MPEG_ENCODER_QDESIGN;
  if (FFrame.ModeID = MPEG_CM_DUAL_CHANNEL) and
    (FFrame.ProtectionBit) then
    Result := MPEG_ENCODER_SHINE;
  if Copy(FVendorID, 1, 4) = VENDOR_ID_LAME then
    Result := MPEG_ENCODER_LAME;
  if Copy(FVendorID, 1, 4) = VENDOR_ID_GOGO_NEW then
    Result := MPEG_ENCODER_GOGO;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetEncoderID: Byte;
begin
  { Get guessed encoder ID }
  if FFrame.Found then
    if FVBR.Found then Result := FGetVBREncoderID
    else Result := FGetCBREncoderID
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetEncoder: string;
var
  VendorID: string;
begin
  { Get guessed encoder name and encoder version for LAME }
  Result := MPEG_ENCODER[FGetEncoderID];
  if FVBR.VendorID <> '' then VendorID := FVBR.VendorID;
  if FVendorID <> '' then VendorID := FVendorID;
  if (FGetEncoderID = MPEG_ENCODER_LAME) and
    (Length(VendorID) >= 8) and
    (VendorID[5] in ['0'..'9']) and
    (VendorID[6] = '.') and
    (VendorID[7] in ['0'..'9']) and
    (VendorID[8] in ['0'..'9']) then
    Result := 
      Result + #32 +
      VendorID[5] +
      VendorID[6] +
      VendorID[7] +
      VendorID[8];
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.FGetValid: Boolean;
begin
  { Check for right MPEG file data }
  Result := 
    (FFrame.Found) and
    (FGetBitRate >= MIN_MPEG_BIT_RATE) and
    (FGetBitRate <= MAX_MPEG_BIT_RATE) and
    (FGetDuration >= MIN_ALLOWED_DURATION);
end;

{ ********************** Public functions & procedures ********************** }

constructor TMPEGaudio.Create;
begin
  { Object constructor }
  inherited;
  FID3v1 := TID3v1.Create;
  FID3v2 := TID3v2.Create;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

destructor TMPEGaudio.Destroy;
begin
  { Object destructor }
  FID3v1.Free;
  FID3v2.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TMPEGaudio.ReadFromFile(const FileName: widestring): Boolean;
var
  stream: Thandlestream;

  Data: array [1..MAX_MPEG_FRAME_LENGTH * 2] of Byte;
  Transferred: Integer;
begin
  Result := False;
  FResetData;
  { At first search for tags, then search for a MPEG frame and VBR data }
    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

  if (FID3v2.ReadFromFile(stream)) and (FID3v1.ReadFromFile(stream)) then
    try
      { Open file, read first block of data and search for a frame }

      FFileLength := stream.Size;
      stream.Seek(FID3v2.Size,sofrombeginning);  // skip id3 v2

      Transferred := stream.Read(Data, SizeOf(Data));
      FFrame := FindFrame(Data, FVBR);
      { Try to search in the middle if no frame at the beginning found }
      if (not FFrame.Found) and (Transferred = SizeOf(Data)) then begin
        stream.Seek((FFileLength - FID3v2.Size) div 2,sofrombeginning);
        Transferred := stream.Read(Data, SizeOf(Data));
        FFrame := FindFrame(Data, FVBR);
      end;
      { Search for vendor ID at the end if CBR encoded }
      if (FFrame.Found) and (not FVBR.Found) then begin
        if not FID3v1.Exists then stream.Seek( FFileLength - SizeOf(Data),sofrombeginning)
         else stream.Seek(FFileLength - SizeOf(Data) - 128,sofrombeginning);
        Transferred := stream.Read(Data, SizeOf(Data));
        FVendorID := FindVendorID(Data, FFrame.Size * 5);
      end;

      Result := True;
    except
    end;
      FreeHandleStream(stream);

  if not FFrame.Found then FResetData;
end;


////////////////////////OGG

const
  { Ogg page header ID }
  OGG_PAGE_ID = 'OggS';

  { Vorbis parameter frame ID }
  VORBIS_PARAMETERS_ID = #1 + 'vorbis';

  { Vorbis tag frame ID }
  VORBIS_TAG_ID = #3 + 'vorbis';

  { Max. number of supported comment fields }
  VORBIS_FIELD_COUNT = 9;

  { Names of supported comment fields }
  VORBIS_FIELD: array [1..VORBIS_FIELD_COUNT] of string =
    ('TITLE', 'ARTIST', 'ALBUM', 'TRACKNUMBER', 'DATE', 'GENRE', 'COMMENT',
    'PERFORMER', 'DESCRIPTION');

  { CRC table for checksum calculating }
  CRC_TABLE: array [0..$FF] of Cardinal = (
    $00000000, $04C11DB7, $09823B6E, $0D4326D9, $130476DC, $17C56B6B,
    $1A864DB2, $1E475005, $2608EDB8, $22C9F00F, $2F8AD6D6, $2B4BCB61,
    $350C9B64, $31CD86D3, $3C8EA00A, $384FBDBD, $4C11DB70, $48D0C6C7,
    $4593E01E, $4152FDA9, $5F15ADAC, $5BD4B01B, $569796C2, $52568B75,
    $6A1936C8, $6ED82B7F, $639B0DA6, $675A1011, $791D4014, $7DDC5DA3,
    $709F7B7A, $745E66CD, $9823B6E0, $9CE2AB57, $91A18D8E, $95609039,
    $8B27C03C, $8FE6DD8B, $82A5FB52, $8664E6E5, $BE2B5B58, $BAEA46EF,
    $B7A96036, $B3687D81, $AD2F2D84, $A9EE3033, $A4AD16EA, $A06C0B5D,
    $D4326D90, $D0F37027, $DDB056FE, $D9714B49, $C7361B4C, $C3F706FB,
    $CEB42022, $CA753D95, $F23A8028, $F6FB9D9F, $FBB8BB46, $FF79A6F1,
    $E13EF6F4, $E5FFEB43, $E8BCCD9A, $EC7DD02D, $34867077, $30476DC0,
    $3D044B19, $39C556AE, $278206AB, $23431B1C, $2E003DC5, $2AC12072,
    $128E9DCF, $164F8078, $1B0CA6A1, $1FCDBB16, $018AEB13, $054BF6A4,
    $0808D07D, $0CC9CDCA, $7897AB07, $7C56B6B0, $71159069, $75D48DDE,
    $6B93DDDB, $6F52C06C, $6211E6B5, $66D0FB02, $5E9F46BF, $5A5E5B08,
    $571D7DD1, $53DC6066, $4D9B3063, $495A2DD4, $44190B0D, $40D816BA,
    $ACA5C697, $A864DB20, $A527FDF9, $A1E6E04E, $BFA1B04B, $BB60ADFC,
    $B6238B25, $B2E29692, $8AAD2B2F, $8E6C3698, $832F1041, $87EE0DF6,
    $99A95DF3, $9D684044, $902B669D, $94EA7B2A, $E0B41DE7, $E4750050,
    $E9362689, $EDF73B3E, $F3B06B3B, $F771768C, $FA325055, $FEF34DE2,
    $C6BCF05F, $C27DEDE8, $CF3ECB31, $CBFFD686, $D5B88683, $D1799B34,
    $DC3ABDED, $D8FBA05A, $690CE0EE, $6DCDFD59, $608EDB80, $644FC637,
    $7A089632, $7EC98B85, $738AAD5C, $774BB0EB, $4F040D56, $4BC510E1,
    $46863638, $42472B8F, $5C007B8A, $58C1663D, $558240E4, $51435D53,
    $251D3B9E, $21DC2629, $2C9F00F0, $285E1D47, $36194D42, $32D850F5,
    $3F9B762C, $3B5A6B9B, $0315D626, $07D4CB91, $0A97ED48, $0E56F0FF,
    $1011A0FA, $14D0BD4D, $19939B94, $1D528623, $F12F560E, $F5EE4BB9,
    $F8AD6D60, $FC6C70D7, $E22B20D2, $E6EA3D65, $EBA91BBC, $EF68060B,
    $D727BBB6, $D3E6A601, $DEA580D8, $DA649D6F, $C423CD6A, $C0E2D0DD,
    $CDA1F604, $C960EBB3, $BD3E8D7E, $B9FF90C9, $B4BCB610, $B07DABA7,
    $AE3AFBA2, $AAFBE615, $A7B8C0CC, $A379DD7B, $9B3660C6, $9FF77D71,
    $92B45BA8, $9675461F, $8832161A, $8CF30BAD, $81B02D74, $857130C3,
    $5D8A9099, $594B8D2E, $5408ABF7, $50C9B640, $4E8EE645, $4A4FFBF2,
    $470CDD2B, $43CDC09C, $7B827D21, $7F436096, $7200464F, $76C15BF8,
    $68860BFD, $6C47164A, $61043093, $65C52D24, $119B4BE9, $155A565E,
    $18197087, $1CD86D30, $029F3D35, $065E2082, $0B1D065B, $0FDC1BEC,
    $3793A651, $3352BBE6, $3E119D3F, $3AD08088, $2497D08D, $2056CD3A,
    $2D15EBE3, $29D4F654, $C5A92679, $C1683BCE, $CC2B1D17, $C8EA00A0,
    $D6AD50A5, $D26C4D12, $DF2F6BCB, $DBEE767C, $E3A1CBC1, $E760D676,
    $EA23F0AF, $EEE2ED18, $F0A5BD1D, $F464A0AA, $F9278673, $FDE69BC4,
    $89B8FD09, $8D79E0BE, $803AC667, $84FBDBD0, $9ABC8BD5, $9E7D9662,
    $933EB0BB, $97FFAD0C, $AFB010B1, $AB710D06, $A6322BDF, $A2F33668,
    $BCB4666D, $B8757BDA, $B5365D03, $B1F740B4);

type
  { Ogg page header }
  OggHeader = packed record
    ID: array [1..4] of Char;                                 { Always "OggS" }
    StreamVersion: Byte;                           { Stream structure version }
    TypeFlag: Byte;                                        { Header type flag }
    AbsolutePosition: Int64;                      { Absolute granule position }
    Serial: Integer;                                   { Stream serial number }
    PageNumber: Integer;                               { Page sequence number }
    Checksum: Integer;                                        { Page checksum }
    Segments: Byte;                                 { Number of page segments }
    LacingValues: array [1..$FF] of Byte;     { Lacing values - segment sizes }
  end;

  { Vorbis parameter header }
  VorbisHeader = packed record
    ID: array [1..7] of Char;                          { Always #1 + "vorbis" }
    BitstreamVersion: array [1..4] of Byte;        { Bitstream version number }
    ChannelMode: Byte;                                   { Number of channels }
    SampleRate: Integer;                                   { Sample rate (hz) }
    BitRateMaximal: Integer;                           { Bit rate upper limit }
    BitRateNominal: Integer;                               { Nominal bit rate }
    BitRateMinimal: Integer;                           { Bit rate lower limit }
    BlockSize: Byte;                   { Coded size for small and long blocks }
    StopFlag: Byte;                                                { Always 1 }
  end;

  { Vorbis tag data }
  VorbisTag = record
    ID: array [1..7] of Char;                          { Always #3 + "vorbis" }
    Fields: Integer;                                   { Number of tag fields }
    FieldData: array [0..VORBIS_FIELD_COUNT] of string;      { Tag field data }
  end;

  { File data }
  FileInfo = record
    FPage, SPage, LPage: OggHeader;             { First, second and last page }
    Parameters: VorbisHeader;                       { Vorbis parameter header }
    Tag: VorbisTag;                                         { Vorbis tag data }
    FileSize: Integer;                                    { File size (bytes) }
    Samples: Integer;                               { Total number of samples }
    ID3v2Size: Integer;                              { ID3v2 tag size (bytes) }
    SPagePos: Integer;                          { Position of second Ogg page }
    TagEndPos: Integer;                                    { Tag end position }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function DecodeUTF8(const Source: string): WideString;
var
  Index, SourceLength, FChar, NChar: Cardinal;
begin
  { Convert UTF-8 to unicode }
  Result := '';
  Index := 0;
  SourceLength := Length(Source);
  while Index < SourceLength do
  begin
    Inc(Index);
    FChar := Ord(Source[Index]);
    if FChar >= $80 then
    begin
      Inc(Index);
      if Index > SourceLength then exit;
      FChar := FChar and $3F;
      if (FChar and $20) <> 0 then
      begin
        FChar := FChar and $1F;
        NChar := Ord(Source[Index]);
        if (NChar and $C0) <> $80 then  exit;
        FChar := (FChar shl 6) or (NChar and $3F);
        Inc(Index);
        if Index > SourceLength then exit;
      end;
      NChar := Ord(Source[Index]);
      if (NChar and $C0) <> $80 then exit;
      Result := Result + WideChar((FChar shl 6) or (NChar and $3F));
    end
    else
      Result := Result + WideChar(FChar);
  end;
end;

{ --------------------------------------------------------------------------- }

function EncodeUTF8(const Source: WideString): string;
var
  Index, SourceLength, CChar: Cardinal;
begin
  { Convert unicode to UTF-8 }
  Result := '';
  Index := 0;
  SourceLength := Length(Source);
  while Index < SourceLength do
  begin
    Inc(Index);
    CChar := Cardinal(Source[Index]);
    if CChar <= $7F then
      Result := Result + Source[Index]
    else if CChar > $7FF then
    begin
      Result := Result + Char($E0 or (CChar shr 12));
      Result := Result + Char($80 or ((CChar shr 6) and $3F));
      Result := Result + Char($80 or (CChar and $3F));
    end
    else
    begin
      Result := Result + Char($C0 or (CChar shr 6));
      Result := Result + Char($80 or (CChar and $3F));
    end;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetID3v2Size(const Source: THandleStream): Integer;
type
  ID3v2Header = record
    ID: array [1..3] of Char;
    Version: Byte;
    Revision: Byte;
    Flags: Byte;
    Size: array [1..4] of Byte;
  end;
var
  Header: ID3v2Header;
begin
  { Get ID3v2 tag size (if exists) }
  Result := 0;
  Source.Seek(0, soFromBeginning);
  Source.Read(Header, SizeOf(Header));
  if Header.ID = 'ID3' then
  begin
    Result := 
      Header.Size[1] * $200000 +
      Header.Size[2] * $4000 +
      Header.Size[3] * $80 +
      Header.Size[4] + 10;
    if Header.Flags and $10 = $10 then Inc(Result, 10);
    if Result > Source.Size then Result := 0;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure SetTagItem(const Data: string; var Info: FileInfo);
var
  Separator, Index: Integer;
  FieldID, FieldData: string;
begin
  { Set Vorbis tag item if supported comment field found }
  Separator := Pos('=', Data);
  if Separator > 0 then
  begin
    FieldID := UpperCase(Copy(Data, 1, Separator - 1));
    FieldData := Copy(Data, Separator + 1, Length(Data) - Length(FieldID));
    for Index := 1 to VORBIS_FIELD_COUNT do
      if VORBIS_FIELD[Index] = FieldID then
        Info.Tag.FieldData[Index] := DecodeUTF8(Trim(FieldData));
  end
  else
    if Info.Tag.FieldData[0] = '' then Info.Tag.FieldData[0] := Data;
end;

{ --------------------------------------------------------------------------- }

procedure ReadTag(const Source: ThandleStream; var Info: FileInfo);
var
  Index, Size, Position: Integer;
  Data: array [1..250] of Char;
begin
  { Read Vorbis tag }
  Index := 0;
  repeat
    FillChar(Data, SizeOf(Data), 0);
    Source.Read(Size, SizeOf(Size));
    Position := Source.Position;
    if Size > SizeOf(Data) then Source.Read(Data, SizeOf(Data))
    else Source.Read(Data, Size);
    { Set Vorbis tag item }
    SetTagItem(Trim(Data), Info);
    Source.Seek(Position + Size, soFromBeginning);
    if Index = 0 then Source.Read(Info.Tag.Fields, SizeOf(Info.Tag.Fields));
    Inc(Index);
  until Index > Info.Tag.Fields;
  Info.TagEndPos := Source.Position;
end;

{ --------------------------------------------------------------------------- }

function GetSamples(const Source: ThandleStream): Integer;
var
  Index, DataIndex, Iterator: Integer;
  Data: array [0..250] of Char;
  Header: OggHeader;
begin
  { Get total number of samples }
  Result := 0;
  for Index := 1 to 50 do
  begin
    DataIndex := Source.Size - (SizeOf(Data) - 10) * Index - 10;
    Source.Seek(DataIndex, soFromBeginning);
    Source.Read(Data, SizeOf(Data));
    { Get number of PCM samples from last Ogg packet header }
    for Iterator := SizeOf(Data) - 10 downto 0 do
      if Data[Iterator] +
        Data[Iterator + 1] +
        Data[Iterator + 2] +
        Data[Iterator + 3] = OGG_PAGE_ID then
      begin
        Source.Seek(DataIndex + Iterator, soFromBeginning);
        Source.Read(Header, SizeOf(Header));
        Result := Header.AbsolutePosition;
        exit;
      end;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetInfo(const FileName: widestring; var Info: FileInfo): Boolean;
var
  stream: THandleStream;
begin
  { Get info from file }
  Result := False;

  stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

   try
    Info.FileSize := stream.Size;
    Info.ID3v2Size := GetID3v2Size(stream);
    stream.Seek(Info.ID3v2Size, soFromBeginning);
    stream.Read(Info.FPage, SizeOf(Info.FPage));
    if Info.FPage.ID <> OGG_PAGE_ID then exit;
    stream.Seek(Info.ID3v2Size + Info.FPage.Segments + 27, soFromBeginning);
    { Read Vorbis parameter header }
    stream.Read(Info.Parameters, SizeOf(Info.Parameters));
    if Info.Parameters.ID <> VORBIS_PARAMETERS_ID then exit;
    Info.SPagePos := stream.Position;
    stream.Read(Info.SPage, SizeOf(Info.SPage));
    stream.Seek(Info.SPagePos + Info.SPage.Segments + 27, soFromBeginning);
    stream.Read(Info.Tag.ID, SizeOf(Info.Tag.ID));
    { Read Vorbis tag }
    if Info.Tag.ID = VORBIS_TAG_ID then ReadTag(stream, Info);
    { Get total number of samples }
    Info.Samples := GetSamples(stream);
    Result := True;
  finally
    FreeHandleStream(stream);
  end;
end;

{ --------------------------------------------------------------------------- }

function GetTrack(const TrackString: string): Byte;
var
  Index, Value, Code: Integer;
begin
  { Extract track from string }
  Index := Pos('/', TrackString);
  if Index = 0 then Val(TrackString, Value, Code)
  else Val(Copy(TrackString, 1, Index), Value, Code);
  if Code = 0 then Result := Value
  else Result := 0;
end;

{ --------------------------------------------------------------------------- }

function BuildTag(const Info: FileInfo): TStringStream;
var
  Index, Fields, Size: Integer;
  FieldData: string;
begin
  { Build Vorbis tag }
  Result := TStringStream.Create('');
  Fields := 0;
  for Index := 1 to VORBIS_FIELD_COUNT do
    if Info.Tag.FieldData[Index] <> '' then Inc(Fields);
  { Write frame ID, vendor info and number of fields }
  Result.Write(Info.Tag.ID, SizeOf(Info.Tag.ID));
  Size := Length(Info.Tag.FieldData[0]);
  Result.Write(Size, SizeOf(Size));
  Result.WriteString(Info.Tag.FieldData[0]);
  Result.Write(Fields, SizeOf(Fields));
  { Write tag fields }
  for Index := 1 to VORBIS_FIELD_COUNT do
    if Info.Tag.FieldData[Index] <> '' then
    begin
      FieldData := VORBIS_FIELD[Index] +
        '=' + EncodeUTF8(Info.Tag.FieldData[Index]);
      Size := Length(FieldData);
      Result.Write(Size, SizeOf(Size));
      Result.WriteString(FieldData);
    end;
end;

{ --------------------------------------------------------------------------- }

procedure SetLacingValues(var Info: FileInfo; const NewTagSize: Integer);
var
  Index, Position, Value: Integer;
  Buffer: array [1..$FF] of Byte;
begin
  { Set new lacing values for the second Ogg page }
  Position := 1;
  Value := 0;
  for Index := Info.SPage.Segments downto 1 do
  begin
    if Info.SPage.LacingValues[Index] < $FF then
    begin
      Position := Index;
      Value := 0;
    end;
    Inc(Value, Info.SPage.LacingValues[Index]);
  end;
  Value := Value + NewTagSize -
    (Info.TagEndPos - Info.SPagePos - Info.SPage.Segments - 27);
  { Change lacing values at the beginning }
  for Index := 1 to Value div $FF do Buffer[Index] := $FF;
  Buffer[(Value div $FF) + 1] := Value mod $FF;
  if Position < Info.SPage.Segments then
    for Index := Position + 1 to Info.SPage.Segments do
      Buffer[Index - Position + (Value div $FF) + 1] := 
        Info.SPage.LacingValues[Index];
  Info.SPage.Segments := Info.SPage.Segments - Position + (Value div $FF) + 1;
  for Index := 1 to Info.SPage.Segments do
    Info.SPage.LacingValues[Index] := Buffer[Index];
end;

{ --------------------------------------------------------------------------- }

procedure CalculateCRC(var CRC: Cardinal; const Data; Size: Cardinal);
var
  Buffer: ^Byte;
  Index: Cardinal;
begin
  { Calculate CRC through data }
  Buffer := Addr(Data);
  for Index := 1 to Size do
  begin
    CRC := (CRC shl 8) xor CRC_TABLE[((CRC shr 24) and $FF) xor Buffer^];
    Inc(Buffer);
  end;
end;

{ --------------------------------------------------------------------------- }

procedure SetCRC(const Destination: TFileStream; Info: FileInfo);
var
  Index: Integer;
  Value: Cardinal;
  Data: array [1..$FF] of Byte;
begin
  { Calculate and set checksum for Vorbis tag }
  Value := 0;
  CalculateCRC(Value, Info.SPage, Info.SPage.Segments + 27);
  Destination.Seek(Info.SPagePos + Info.SPage.Segments + 27, soFromBeginning);
  for Index := 1 to Info.SPage.Segments do
    if Info.SPage.LacingValues[Index] > 0 then
    begin
      Destination.Read(Data, Info.SPage.LacingValues[Index]);
      CalculateCRC(Value, Data, Info.SPage.LacingValues[Index]);
    end;
  Destination.Seek(Info.SPagePos + 22, soFromBeginning);
  Destination.Write(Value, SizeOf(Value));
end;

{ --------------------------------------------------------------------------- }

{function RebuildFile(FileName: string; Tag: TStream; Info: FileInfo): Boolean;
var
  Source, Destination: TFileStream;
  BufferName: string;
begin
   Rebuild the file with the new Vorbis tag
  Result := False;
  if (not FileExists(FileName)) or (FileSetAttr(FileName, 0) <> 0) then exit;
  try
     Create file streams
    BufferName := FileName + '~';
    Source := TFileStream.Create(FileName, fmOpenRead);
    Destination := TFileStream.Create(BufferName, fmCreate);
     Copy data blocks
    Destination.CopyFrom(Source, Info.SPagePos);
    Destination.Write(Info.SPage, Info.SPage.Segments + 27);
    Destination.CopyFrom(Tag, 0);
    Source.Seek(Info.TagEndPos, soFromBeginning);
    Destination.CopyFrom(Source, Source.Size - Info.TagEndPos);
    SetCRC(Destination, Info);
    Source.Free;
    Destination.Free;
     Replace old file and delete temporary file
    if (DeleteFile(FileName)) and (RenameFile(BufferName, FileName)) then
      Result := true
    else
      raise Exception.Create('');
  except
     Access error
    if FileExists(BufferName) then DeleteFile(BufferName);
  end;
end; }

{ ********************** Private functions & procedures ********************* }

procedure TOggVorbis.FResetData;
begin
  { Reset variables }
  FFileSize := 0;
  FChannelModeID := 0;
  FSampleRate := 0;
  FBitRateNominal := 0;
  FSamples := 0;
  FID3v2Size := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FDate := '';
  FGenre := '';
  FComment := '';
  FVendor := '';
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.FGetChannelMode: string;
begin
  { Get channel mode name }
  Result := VORBIS_MODE[FChannelModeID];
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.FGetDuration: Double;
begin
  { Calculate duration time }
  if FSamples > 0 then
    if FSampleRate > 0 then
      Result := FSamples / FSampleRate
    else
      Result := 0
  else
    if (FBitRateNominal > 0) and (FChannelModeID > 0) then
      Result := (FFileSize - FID3v2Size) /
        FBitRateNominal / FChannelModeID / 125 * 2
    else
      Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.FGetBitRate: Word;
begin
  { Calculate average bit rate }
  Result := 0;
  if FGetDuration > 0 then
    Result := Round((FFileSize - FID3v2Size) / FGetDuration / 125);
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.FHasID3v2: Boolean;
begin
  { Check for ID3v2 tag }
  Result := FID3v2Size > 0;
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.FIsValid: Boolean;
begin
  { Check for file correctness }
  Result := (FChannelModeID in [VORBIS_CM_MONO, VORBIS_CM_STEREO]) and
    (FSampleRate > 0) and (FGetDuration > 0.1) and (FGetBitRate > 0);
end;

{ ********************** Public functions & procedures ********************** }

constructor TOggVorbis.Create;
begin
  { Object constructor }
  FResetData;
  inherited;
end;

{ --------------------------------------------------------------------------- }

destructor TOggVorbis.Destroy;
begin
  { Object destructor }
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TOggVorbis.ReadFromFile(const FileName: widestring): Boolean;
var
  Info: FileInfo;
begin
  { Read data from file }
  Result := False;
  FResetData;
  FillChar(Info, SizeOf(Info), 0);
  if GetInfo(Filename,Info) then
  begin
    { Fill variables }
    FFileSize := Info.FileSize;
    FChannelModeID := Info.Parameters.ChannelMode;
    FSampleRate := Info.Parameters.SampleRate;
    FBitRateNominal := Round(Info.Parameters.BitRateNominal / 1000);
    FSamples := Info.Samples;
    FID3v2Size := Info.ID3v2Size;
    FTitle := Info.Tag.FieldData[1];
    if Info.Tag.FieldData[2] <> '' then FArtist := Info.Tag.FieldData[2]
    else FArtist := Info.Tag.FieldData[8];
    FAlbum := Info.Tag.FieldData[3];
    FTrack := GetTrack(Info.Tag.FieldData[4]);
    FDate := Info.Tag.FieldData[5];
    FGenre := Info.Tag.FieldData[6];
    if Info.Tag.FieldData[7] <> '' then FComment := Info.Tag.FieldData[7]
    else FComment := Info.Tag.FieldData[9];
    FVendor := Info.Tag.FieldData[0];
    Result := True;
  end;
end;

///////////////////////////////////////TWINVQ


{ ********************* Auxiliary functions & procedures ******************** }

function TTwinVQ.ReadHeader(const stream: Thandlestream; var Header: TWINVQHeaderInfo): Boolean;
var
  Transferred: Integer;
begin
  try
    Result := True;
    { Set read-access and open file }

    { Read header and get file size }
    Transferred := stream.Read(Header, 40);
    Header.FileSize := stream.Size;
    { if transfer is not complete }
    if Transferred < 40 then Result := False;
  except
    { Error }
    Result := False;
  end;
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.GetChannelModeID(const Header: TwinVQHeaderInfo): Byte;
begin
  { Get channel mode from header }
  case Swap(Header.ChannelMode shr 16) of
    0: Result := TWIN_CM_MONO;
    1: Result := TWIN_CM_STEREO
    else Result := 0;
  end;
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.GetBitRate(const Header: TwinVQHeaderInfo): Byte;
begin
  { Get bit rate from header }
  Result := Swap(Header.BitRate shr 16);
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.GetSampleRate(const Header: TwinVQHeaderInfo): Word;
begin
  { Get real sample rate from header }
  Result := Swap(Header.SampleRate shr 16);
  case Result of
    11: Result := 11025;
    22: Result := 22050;
    44: Result := 44100;
    else Result := Result * 1000;
  end;
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.GetDuration(const Header: TwinVQHeaderInfo): Double;
begin
  { Get duration from header }
  Result := Abs((Header.FileSize - Swap(Header.Size shr 16) - 20)) / 125 /
    Swap(Header.BitRate shr 16);
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.HeaderEndReached(const Chunk: TwinVQChunkHeader): Boolean;
begin
  { Check for header end }
  Result := (Ord(Chunk.ID[1]) < 32) or
    (Ord(Chunk.ID[2]) < 32) or
    (Ord(Chunk.ID[3]) < 32) or
    (Ord(Chunk.ID[4]) < 32) or
    (Chunk.ID = 'DATA');
end;

{ --------------------------------------------------------------------------- }
function TTwinVQ.converti_oemtoutf8(source: string): string;
var
len: Integer;
sources: string;
widestr: WideString;
begin
sources := trim(source);
result := '';

    if length(sources)=0 then exit;
    if length(sources)>100 then exit;
    SetLength(widestr,length(sources)*2);    //CP_OEMCP
    len := MultiByteToWideChar(CP_OEMCP, 0, pansichar(sources), Length(sources), pwidechar(widestr),length(widestr));
    if len<>0 then SetLength(widestr,len);

    Result :=  widestrtoutf8str(widestr);
end;

procedure TTwinVQ.SetTagItem(const ID, Data: string; var Header: TwinVQHeaderInfo);
var
  Iterator: Byte;
begin
  { Set tag item if supported tag-chunk found }
  for Iterator := 1 to TWIN_CHUNK_COUNT do
    if TWIN_CHUNK[Iterator] = ID then Header.Tag[Iterator] := converti_oemtoutf8(Data);
end;



{ --------------------------------------------------------------------------- }

procedure TTwinVQ.ReadTag(const stream: Thandlestream; var Header: TwinVQHeaderInfo);
var
  Chunk: TwinVQChunkHeader;
  Data: array [1..250] of Char;
begin
  try
    { Set read-access, open file }

    stream.Seek(16,sofrombeginning);
    repeat
    begin
      FillChar(Data, SizeOf(Data), 0);
      { Read chunk header }
      stream.Read(Chunk, 8);
      { Read chunk data and set tag item if chunk header valid }
      if HeaderEndReached(Chunk) then break;
      stream.Read(Data, Swap(Chunk.Size shr 16) mod SizeOf(Data));
      SetTagItem(Chunk.ID, Data, Header);
    end;
    until (stream.position>=stream.size);
  except
  end;
end;

{ ********************** Private functions & procedures ********************* }

procedure TTwinVQ.FResetData;
begin
  FValid := False;
  FChannelModeID := 0;
  FBitRate := 0;
  FSampleRate := 0;
  FFileSize := 0;
  FDuration := 0;
  FTitle := '';
  FComment := '';
  FAuthor := '';
  FCopyright := '';
  FOriginalFile := '';
  FAlbum := '';
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.FGetChannelMode: string;
begin
  Result := TWIN_MODE[FChannelModeID];
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.FIsCorrupted: Boolean;
begin
  { Check for file corruption }
  Result := (FValid) and
    ((FChannelModeID = 0) or
    (FBitRate < 8) or (FBitRate > 192) or
    (FSampleRate < 8000) or (FSampleRate > 44100) or
    (FDuration < 0.1) or (FDuration > 10000));
end;

{ ********************** Public functions & procedures ********************** }

constructor TTwinVQ.Create;
begin
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.ReadFromFile(const FileName: widestring): Boolean;
var
  Header: TwinVQHeaderInfo;
  stream: Thandlestream;
begin
  { Reset data and load header from file to variable }
  FResetData;

    stream := helper_diskio.MyFileOpen(FileName,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

  Result := ReadHeader(stream, Header);
  { Process data if loaded and header valid }
  if (Result) and (Header.ID = TWIN_ID) then begin
    FValid := True;
    { Fill properties with header data }
    FChannelModeID := GetChannelModeID(Header);
    FBitRate := GetBitRate(Header);
    FSampleRate := GetSampleRate(Header);
    FFileSize := Header.FileSize;
    FDuration := GetDuration(Header);
    { Get tag information and fill properties }
    ReadTag(stream, Header);
    FTitle := Trim(Header.Tag[1]);
    FComment := Trim(Header.Tag[2]);
    FAuthor := Trim(Header.Tag[3]);
    FCopyright := Trim(Header.Tag[4]);
    FOriginalFile := Trim(Header.Tag[5]);
    FAlbum := Trim(Header.Tag[6]);
  end;

      FreeHandleStream(stream);
end;

///////////////////////////////WAV
type
  { Real structure of WAV file header }
  WAVRecord = record
    { RIFF file header }
    RIFFHeader: array [1..4] of Char;                        { Must be "RIFF" }
    FileSize: Integer;                           { Must be "RealFileSize - 8" }
    WAVEHeader: array [1..4] of Char;                        { Must be "WAVE" }
    { Format information }
    FormatHeader: array [1..4] of Char;                      { Must be "fmt " }
    FormatSize: Integer;                               { Must be 16 (decimal) }
    FormatCode: Word;                                             { Must be 1 }
    ChannelNumber: Word;                                 { Number of channels }
    SampleRate: Integer;                                   { Sample rate (hz) }
    BytesPerSecond: Integer;                               { Bytes per second }
    BytesPerSample: Word;                                  { Bytes per Sample }
    BitsPerSample: Word;                                    { Bits per sample }
    { Data area }
    DataHeader: array [1..4] of Char;                        { Must be "data" }
    DataSize: Integer;                                            { Data size }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadWAV(const FileName: widestring; var WAVData: WAVRecord): Boolean;
var
  stream: Thandlestream;
  Transferred: Int64;
begin
  try
    Result := True;
    { Set read-access and open file }
    stream := helper_diskio.MyFileOpen(Filename,ARES_READONLY_ACCESS);
    if stream=nil then begin
     Result := False;
     exit;
    end;

    { Read header }
    Transferred := stream.Read( WAVData, 44);

    FreeHandleStream(Stream);
    { if transfer is not complete }
    if Transferred < 44 then Result := False;

  except
    { Error }
    Result := False;
  end;
end;

{ --------------------------------------------------------------------------- }

function HeaderIsValid(const WAVData: WAVRecord): Boolean;
begin
  Result := True;
  { Validation }
  if WAVData.RIFFHeader <> 'RIFF' then Result := False;
  if WAVData.WAVEHeader <> 'WAVE' then Result := False;
  if WAVData.FormatHeader <> 'fmt ' then Result := False;
  if WAVData.FormatSize <> 16 then Result := False;
  if WAVData.FormatCode <> 1 then Result := False;
  if WAVData.DataHeader <> 'data' then Result := False;
  if (WAVData.ChannelNumber <> CHANNEL_MODE_MONO) and
    	(WAVData.ChannelNumber <> CHANNEL_MODE_STEREO) then Result := False;
end;

{ ********************** Private functions & procedures ********************* }

procedure TWAVFile.FResetData;
begin
  FValid := False;
  FChannelModeID := 0;
  FSampleRate := 0;
  FBitsPerSample := 0;
  FFileSize := 0;
end;

{ --------------------------------------------------------------------------- }

function TWAVFile.FGetChannelMode: string;
begin
  Result := CHANNEL_MODE[FChannelModeID];
end;

{ --------------------------------------------------------------------------- }

function TWAVFile.FGetDuration: Double;
begin
  if FValid then
    Result := (FFileSize - 44) * 8 /
      FSampleRate / FBitsPerSample / FChannelModeID
  else
    Result := 0;
end;

{ ********************** Public functions & procedures ********************** }

constructor TWAVFile.Create;
begin
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TWAVFile.ReadFromFile(const FileName: widestring): Boolean;
var
  WAVData: WAVRecord;
begin
  { Reset and load header data from file to variable }
  FResetData;
  Result := ReadWAV(FileName, WAVData);
  { Process data if loaded and header valid }
  if (Result) and (HeaderIsValid(WAVData)) then
  begin
    FValid := True;
    { Fill properties with header data }
    FChannelModeID := WAVData.ChannelNumber;
    FSampleRate := WAVData.SampleRate;
    FBitsPerSample := WAVData.BitsPerSample;
    FFileSize := WAVData.FileSize + 8;
  end;
end;

/////////////////////////////////////////////WMA
const
  { Object IDs }
  WMA_HEADER_ID =
    #48#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108;
  WMA_FILE_PROPERTIES_ID =
    #161#220#171#140#71#169#207#17#142#228#0#192#12#32#83#101;
  WMA_STREAM_PROPERTIES_ID =
    #145#7#220#183#183#169#207#17#142#230#0#192#12#32#83#101;
  WMA_CONTENT_DESCRIPTION_ID =
    #51#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108;
  WMA_EXTENDED_CONTENT_DESCRIPTION_ID =
    #64#164#208#210#7#227#210#17#151#240#0#160#201#94#168#80;

  { Max. number of supported comment fields }
  WMA_FIELD_COUNT = 7;

  { Names of supported comment fields }
  WMA_FIELD_NAME: array [1..WMA_FIELD_COUNT] of WideString =
    ('WM/TITLE', 'WM/AUTHOR', 'WM/ALBUMTITLE', 'WM/TRACK', 'WM/YEAR',
     'WM/GENRE', 'WM/DESCRIPTION');

  { Max. number of characters in tag field }
  WMA_MAX_STRING_SIZE = 250;

type
  { Object ID }
  ObjectID = array [1..16] of Char;

  { Tag data }
  TagData = array [1..WMA_FIELD_COUNT] of WideString;

  { File data - for internal use }
  FileData = record
    FileSize: Integer;                                    { File size (bytes) }
    MaxBitRate: Integer;                                { Max. bit rate (bps) }
    Channels: Word;                                      { Number of channels }
    SampleRate: Integer;                                   { Sample rate (hz) }
    ByteRate: Integer;                                            { Byte rate }
    Tag: TagData;                                       { WMA tag information }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadFieldString(const Source: THandleStream; DataSize: Word): WideString;
var
  Iterator, StringSize: Integer;
  FieldData: array [1..WMA_MAX_STRING_SIZE * 2] of Byte;
begin
  { Read field data and convert to Unicode string }
  Result := '';
  StringSize := DataSize div 2;
  if StringSize > WMA_MAX_STRING_SIZE then StringSize := WMA_MAX_STRING_SIZE;
  Source.ReadBuffer(FieldData, StringSize * 2);
  Source.Seek(DataSize - StringSize * 2, soFromCurrent);
  for Iterator := 1 to StringSize do
    Result := Result +
      WideChar(FieldData[Iterator * 2 - 1] + (FieldData[Iterator * 2] shl 8));
end;

{ --------------------------------------------------------------------------- }

procedure ReadTagStandard(const Source: THandleStream; var Tag: TagData);
var
  Iterator: Integer;
  FieldSize: array [1..5] of Word;
  FieldValue: WideString;
begin
  { Read standard tag data }
  Source.ReadBuffer(FieldSize, SizeOf(FieldSize));
  for Iterator := 1 to 5 do
    if FieldSize[Iterator] > 0 then
    begin
      { Read field value }
      FieldValue := ReadFieldString(Source, FieldSize[Iterator]);
      { Set corresponding tag field if supported }
      case Iterator of
        1: Tag[1] := FieldValue;
        2: Tag[2] := FieldValue;
        4: Tag[7] := FieldValue;
      end;
    end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadTagExtended(const Source: THandleStream; var Tag: TagData);
var
  Iterator1, Iterator2, FieldCount, DataSize, DataType: Word;
  FieldName, FieldValue: WideString;
begin
  { Read extended tag data }
  Source.ReadBuffer(FieldCount, SizeOf(FieldCount));
  for Iterator1 := 1 to FieldCount do
  begin
    { Read field name }
    Source.ReadBuffer(DataSize, SizeOf(DataSize));
    FieldName := ReadFieldString(Source, DataSize);
    { Read value data type }
    Source.ReadBuffer(DataType, SizeOf(DataType));
    { Read field value only if string }
    if DataType = 0 then
    begin
      Source.ReadBuffer(DataSize, SizeOf(DataSize));
      FieldValue := ReadFieldString(Source, DataSize);
    end
    else
      Source.Seek(DataSize, soFromCurrent);
    { Set corresponding tag field if supported }
    for Iterator2 := 1 to WMA_FIELD_COUNT do
      if UpperCase(Trim(FieldName)) = WMA_FIELD_NAME[Iterator2] then
        Tag[Iterator2] := FieldValue;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadObject(const ID: ObjectID; Source: THandleStream; var Data: FileData);
begin
  { Read data from header object if supported }
  if ID = WMA_FILE_PROPERTIES_ID then
  begin
    { Read file properties }
    Source.Seek(80, soFromCurrent);
    Source.ReadBuffer(Data.MaxBitRate, SizeOf(Data.MaxBitRate));
  end;
  if ID = WMA_STREAM_PROPERTIES_ID then begin
    { Read stream properties }
    Source.Seek(60, soFromCurrent);
    Source.ReadBuffer(Data.Channels, SizeOf(Data.Channels));
    Source.ReadBuffer(Data.SampleRate, SizeOf(Data.SampleRate));
    Source.ReadBuffer(Data.ByteRate, SizeOf(Data.ByteRate));
  end;
  if ID = WMA_CONTENT_DESCRIPTION_ID then begin
    { Read standard tag data }
    Source.Seek(4, soFromCurrent);
    ReadTagStandard(Source, Data.Tag);
  end;
  if ID = WMA_EXTENDED_CONTENT_DESCRIPTION_ID then begin
    { Read extended tag data }
    Source.Seek(4, soFromCurrent);
    ReadTagExtended(Source, Data.Tag);
  end;
end;

{ --------------------------------------------------------------------------- }

function ReadData(const FileName: widestring; var Data: FileData): Boolean;
var
  Stream: ThandleStream;
  ID: ObjectID;
  Iterator, ObjectCount, ObjectSize, Position: Integer;
begin
  { Read file data }
  try
    stream := helper_diskio.MyFileOpen(Filename,0);
    if stream=nil then begin
     Result := False;
     exit;
    end;

    Data.FileSize := stream.Size;
    { Check for existing header }
    stream.ReadBuffer(ID, SizeOf(ID));
    if ID = WMA_HEADER_ID then begin
      stream.Seek(8, soFromCurrent);
      stream.ReadBuffer(ObjectCount, SizeOf(ObjectCount));
      stream.Seek(2, soFromCurrent);
      { Read all objects in header and get needed data }
      for Iterator := 1 to ObjectCount do begin
        Position := stream.Position;
        stream.ReadBuffer(ID, SizeOf(ID));
        stream.ReadBuffer(ObjectSize, SizeOf(ObjectSize));
        ReadObject(ID, stream, Data);
        stream.Seek(Position + ObjectSize, soFromBeginning);
      end;
    end;

    FreeHandleStream(Stream);
    Result := True;
  except
    Result := False;
  end;
end;

{ --------------------------------------------------------------------------- }

function IsValid(const Data: FileData): Boolean;
begin
  { Check for data validity }
  Result := 
    (Data.MaxBitRate > 0) and (Data.MaxBitRate < 320000) and
    ((Data.Channels = WMA_CM_MONO) or (Data.Channels = WMA_CM_STEREO)) and
    (Data.SampleRate >= 8000) and (Data.SampleRate <= 96000) and
    (Data.ByteRate > 0) and (Data.ByteRate < 40000);
end;

{ --------------------------------------------------------------------------- }

function ExtractTrack(const TrackString: WideString): Integer;
var
  Value, Code: Integer;
begin
  { Extract track from string }
  Result := 0;
  Val(TrackString, Value, Code);
  if Code = 0 then Result := Value;
end;

{ ********************** Private functions & procedures ********************* }

procedure TWMAfile.FResetData;
begin
  { Reset variables }
  FValid := False;
  FFileSize := 0;
  FChannelModeID := WMA_CM_UNKNOWN;
  FSampleRate := 0;
  FDuration := 0;
  FBitRate := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FYear := '';
  FGenre := '';
  FComment := '';
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.FGetChannelMode: string;
begin
  { Get channel mode name }
  Result := WMA_MODE[FChannelModeID];
end;

{ ********************** Public functions & procedures ********************** }

constructor TWMAfile.Create;
begin
  { Create object }
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TWMAfile.ReadFromFile(const FileName: widestring): Boolean;
var
  Data: FileData;
begin
  { Reset variables and load file data }
  FResetData;
  FillChar(Data, SizeOf(Data), 0);
  Result := ReadData(FileName, Data);
  { Process data if loaded and valid }
  if Result and IsValid(Data) then
  begin
    FValid := True;
    { Fill properties with loaded data }
    FFileSize := Data.FileSize;
    FChannelModeID := Data.Channels;
    FSampleRate := Data.SampleRate;
    FDuration := Data.FileSize * 8 / Data.MaxBitRate;
    FBitRate := Data.ByteRate * 8 div 1000;
    FTitle := Trim(Data.Tag[1]);
    FArtist := Trim(Data.Tag[2]);
    FAlbum := Trim(Data.Tag[3]);
    FTrack := ExtractTrack(Trim(Data.Tag[4]));
    FYear := Trim(Data.Tag[5]);
    FGenre := Trim(Data.Tag[6]);
    FComment := Trim(Data.Tag[7]);
  end;
end;


function ricava_dati_mov(nomefile: WideString):record_audioinfo;
var
stream: Thandlestream;
buffer: array [0..88]of Byte;
wres,hres,posizione: Integer;
count:longint;
timescale:longint;
begin
result.duration := 0;
result.bitrate := 0;
result.frequency := 0;
result.codec := '';

    stream := MyFileOpen(nomefile, ARES_READONLY_ACCESS);
    if stream=nil then exit;

try
        // cerchiamo tkhd trovato il punto che equivale alla pos 1 proseguiamo con l'header

 // cerchiamo timescale
  count := 0;
 posizione := 0;
 while count<>-1 do begin
 if posizione>=1024 then begin

  FreeHandleStream(Stream);
  exit;  // errore :)
 end;
 stream.seek(posizione,sofrombeginning);
 count := stream.Read(buffer,4);                         //mvhd
 if ((buffer[0]=109) and (buffer[1]=118) and (buffer[2]=104) and (buffer[3]=100)) then break else inc(posizione);
 end; // fine while

      if posizione=-1 then begin

        FreeHandleStream(Stream);
      exit;
      end;

      stream.seek(posizione+16,sofrombeginning);
        stream.Read(buffer,8);
        timescale := buffer[0];
timescale := timescale shl 8;
timescale := timescale + buffer[1];
timescale := timescale shl 8;
timescale := timescale + buffer[2];
timescale := timescale shl 8;
timescale := timescale + buffer[3];
count := buffer[4];
count := count shl 8;
count := count + buffer[5];
count := count shl 8;
count := count + buffer[6];
count := count shl 8;
count := count + buffer[7];
result.duration := count div timescale;
    // ora cerchiamo trkheader
 count := 0;
 posizione := 88;       // saltiamo in toto il movie header
 while count<>-1 do begin
  if posizione>=1024 then begin
        FreeHandleStream(Stream);
 exit;  // errore :)
 end;
 
 stream.seek(posizione,sofrombeginning);
 count := stream.Read(buffer,4);                       //tkhd
 if ((buffer[0]=116) and (buffer[1]=107) and (buffer[2]=104) and (buffer[3]=100)) then break else
 inc(posizione);
 end; // fine while

      if posizione=-1 then begin
        FreeHandleStream(Stream);
      exit;
      end;

        stream.seek(posizione,sofrombeginning);
        stream.Read(buffer,88);

          FreeHandleStream(Stream);


wres := buffer[78];
wres := wres shl 8;
wres := wres + buffer[79];
wres := wres shl 8;
wres := wres + buffer[80];
wres := wres shl 8;
result.bitrate := wres + buffer[81];

hres := buffer[82];
hres := hres shl 8;
hres := hres + buffer[83];
hres := hres shl 8;
hres := hres + buffer[84];
hres := hres shl 8;
result.frequency := hres + buffer[85];

result.codec := '';


 except
          FreeHandleStream(Stream);
 end;

end;

function int64todouble(in64: Int64):double;
var
flag: Integer;
d:double;
begin

 flag := 0;

  if in64<0 then begin
   flag := 1;
   in64 := -in64;
  end;

  d := cardinal(in64 shr 32);

  d := d* (1 shl 16);
  d := d* (1 shl 16);
  d := d+   cardinal(in64   and   $FFFFFFFF);
  if flag=1 then d := -d;
  Result := d;
end;

function get_flv_infos(filename: WideString):record_audioinfo;
var
 stream: Thandlestream;
 buffer: array [0..1023] of Byte;
 FLV_HEADER1: string;
 FLV_HEADER2: string;
 bodylen,timestamp,sizeprevious: Cardinal;
 metaType,tagType: Byte;
 indexBuffer,lenread: Integer;
 lastTimestamp: Cardinal;
 
      procedure parseVideo;
      var
       codec,ttype: Byte;
       frametype: Byte;
      //wid,hei,tmp: Cardinal;
       bit: Tbitclass;
       str: string;
       adjW,adjH: Integer;
      begin
       try
       frameType := ((buffer[indexBuffer] and $f0) shr 4);
       if frameType<>1 then exit; //we need a keyframe to extract width X height 

       codec := (buffer[indexBuffer] and $f);

       bit := tbitclass.create;
       SetLength(str,15);
       move(buffer[indexBuffer+1],str[1],15);
       bit.load(str);

       case codec of

        2:begin     // CODEC_SORENSON_H263
          result.codec := 'H.263';
            if bit.getint(17)<>1 then begin
             bit.Free;
             exit;
            end;
            bit.seek(5+8);
            ttype := bit.getint(3);
             case ttype of
               0:begin
                  result.bitrate := bit.getint(8);
                  result.frequency := bit.getint(8);
                 end;
               1:begin
                 result.bitrate := bit.getint(16);
                 result.frequency := bit.getint(16);
                end;
               2:begin
                 result.bitrate := 352;
                 result.frequency := 288;
                 end;
               3:begin
                 result.bitrate := 176;
                 result.frequency := 144;
                end;
               4:begin
                result.bitrate := 128;
                result.frequency := 96;
               end;
               5:begin
                result.bitrate := 320;
                result.frequency := 240;
                end;
               6:begin
                result.bitrate := 160;
                result.frequency := 120;
                end;
             end;

          end;

        3:begin // CODEC_SORENSON
          result.codec := 'Video';
            bit.seek(4);
            result.bitrate := bit.getint(12);
            bit.seek(4);
            result.frequency := bit.getint(12);
          end;

        4:begin //CODEC_ON2_VP6
          result.codec := 'On2 VP6';
          adjW := bit.getInt(4);
					adjH := bit.getInt(4);
					 if (bit.getInt(1)=0) then begin
						bit.seek(15);
						result.frequency := bit.getInt(8) * 16 - adjH;
						result.bitrate :=  bit.getInt(8) * 16 - adjW;
					 end;
          end;

        5:begin //CODEC_ON2_VP6ALPHA
          result.codec := 'On2 VP6a';
          adjW := bit.getInt(4);
					adjH := bit.getInt(4);
					 if (bit.getInt(1)=0) then begin
						bit.seek(39);
						result.frequency := bit.getInt(8) * 16 - adjH;
						result.bitrate :=  bit.getInt(8) * 16 - adjW;
					 end;
          end;

        6:begin  //CODEC_SCREENVIDEO_2
          result.codec := 'Video2';
          result.bitrate := bit.getint(12);
          result.frequency := bit.getint(12);
          end;
       end;
       bit.Free;
       except
       end;
      end;


      procedure parseMeta;
      var
       str,backupstr: string;
       ind: Integer;
       tmpbuf: array [0..7] of Byte;
       num64: Int64;
       //num321,num322: Cardinal;
       d:double;

        function parseString: string;
        var
        sizestr: Word;
        begin
          try
             sizestr := buffer[indexBuffer];
             sizestr := sizestr shl 8;
             sizestr := sizestr+buffer[indexBuffer+1];
           inc(indexBuffer,2);
             SetLength(result,sizestr);
             move(buffer[indexBuffer],result[1],sizestr);
           inc(indexBuffer,sizestr);
          except
          end;
        end;


      begin
        try
        metaType := buffer[indexBuffer];
        if metaType<>2 then exit;
        inc(indexbuffer);

        if parseString<>'onMetaData' then exit;
        
        SetLength(str,bodylen-(indexBuffer+1));
        move(buffer[indexBuffer],str[1],length(str));
        backupstr := str;
       ind := pos(chr(0)+chr(8)+'duration'+chr(0),str);
       if ind<>0 then begin
        delete(str,1,ind+10);
        delete(str,9,length(str));

        tmpbuf[7] := ord(str[1]);
        tmpbuf[6] := ord(str[2]);
        tmpbuf[5] := ord(str[3]);
        tmpbuf[4] := ord(str[4]);
        tmpbuf[3] := ord(str[5]);
        tmpbuf[2] := ord(str[6]);
        tmpbuf[1] := ord(str[7]);
        tmpbuf[0] := ord(str[8]);

        move(tmpbuf[0],num64,8);

        d := ldexp(((num64 and ((int64(1) shl 52)-1)) + (int64(1) shl 52)) * (num64 shr 63 or 1),
                 (num64 shr 52 and $7FF)-1075);

        result.duration := trunc(d);

        // fix for broken movies that reports wrong meta duration  (check file by last timestamp)
        if result.duration>650 then
         if stream.size<25277476 then result.duration := 0;
        end;

       str := backupstr;
       ind := pos(chr(0)+chr(5)+'width'+chr(0),str);
       if ind<>0 then begin
        delete(str,1,ind+7);
        delete(str,9,length(str));

        tmpbuf[7] := ord(str[1]);
        tmpbuf[6] := ord(str[2]);
        tmpbuf[5] := ord(str[3]);
        tmpbuf[4] := ord(str[4]);
        tmpbuf[3] := ord(str[5]);
        tmpbuf[2] := ord(str[6]);
        tmpbuf[1] := ord(str[7]);
        tmpbuf[0] := ord(str[8]);

        move(tmpbuf[0],num64,8);

        d := ldexp(((num64 and ((int64(1) shl 52)-1)) + (int64(1) shl 52)) * (num64 shr 63 or 1),
                 (num64 shr 52 and $7FF)-1075);

        result.bitrate := trunc(d);
        end;

       str := backupstr;
       ind := pos(chr(0)+chr(6)+'height'+chr(0),str);
       if ind<>0 then begin
        delete(str,1,ind+8);
        delete(str,9,length(str));

        tmpbuf[7] := ord(str[1]);
        tmpbuf[6] := ord(str[2]);
        tmpbuf[5] := ord(str[3]);
        tmpbuf[4] := ord(str[4]);
        tmpbuf[3] := ord(str[5]);
        tmpbuf[2] := ord(str[6]);
        tmpbuf[1] := ord(str[7]);
        tmpbuf[0] := ord(str[8]);

        move(tmpbuf[0],num64,8);

        d := ldexp(((num64 and ((int64(1) shl 52)-1)) + (int64(1) shl 52)) * (num64 shr 63 or 1),
                 (num64 shr 52 and $7FF)-1075);

        result.frequency := trunc(d);
        end;

        except
        end;
       end;

begin
result.duration := 0;
result.bitrate := 0;
result.frequency := 0;
result.codec := '';

lastTimestamp := 0;
stream := MyFileOpen(filename, ARES_READONLY_ACCESS);
if stream=nil then exit;

try
if stream.read(buffer,9)<>9 then begin
 FreeHandleStream(stream);
 exit;
end;

flv_header1 := 'FLV'#1;
flv_header2 := #0#0#0#9;

 if (not comparemem(@buffer[0],@flv_header1[1],4)) or
    (not comparemem(@buffer[5],@flv_header2[1],4)) then begin
   FreeHandleStream(stream);
   exit;
  end;

if (buffer[4] and 5)=0 then
 if (buffer[4] and 1)=0 then begin
  FreeHandleStream(stream);
  exit;
 end;

while (stream.position<stream.size) do begin

 if stream.Read(buffer,15)<>15 then break;

  sizeprevious := buffer[0];
  sizeprevious := sizeprevious shl 8;
  sizeprevious := sizeprevious+buffer[1];
  sizeprevious := sizeprevious shl 8;
  sizeprevious := sizeprevious+buffer[2];
  sizeprevious := sizeprevious shl 8;
  sizeprevious := sizeprevious+buffer[3];

  tagType := buffer[4];

  //24 bit bodylen
  bodylen := buffer[5];
  bodylen := bodylen shl 8;
  bodylen := bodylen+buffer[6];
  bodylen := bodylen shl 8;
  bodylen := bodylen+buffer[7];

  //24 bit timestamp
  timestamp := buffer[8];
  timestamp := timestamp shl 8;
  timestamp := timestamp+buffer[9];
  timestamp := timestamp shl 8;
  timestamp := timestamp+buffer[10];

 if bodylen>sizeof(buffer) then begin    //skip this tag
  lenread := stream.read(buffer,sizeof(buffer));
           stream.seek(bodylen-sizeof(buffer),soFromCurrent);
  bodylen := sizeof(buffer);
 end else lenread := stream.read(buffer,bodylen);

 if lenread<>bodylen then begin
  break;
 end;

  indexBuffer := 0;

  case tagtype of
  // $8:; //AUDIO
   $9:begin
        if length(result.codec)=0 then parseVideo else begin
         if result.duration>0 then break; //VIDEO
        end;
        lastTimestamp := timestamp;
      end;
   $12:parseMeta; //META
  end;

  if result.duration>0 then
   if length(result.codec)>0 then break;

end;

  if result.duration=0 then begin
   if lastTimestamp>1000 then
    if lastTimestamp<1200000{20mins} then result.duration := lastTimestamp div 1000;
  end;

except
end;
FreeHandleStream(Stream);


end;


function ricava_dati_avi(nomefile: WideString):record_audioinfo;
var
 stream : Thandlestream;
 buffer: array [0..116]of Byte;
 framerate,wres,hres: Integer;
 codec: string;
 count:longint;
begin
result.duration := 0;
result.bitrate := 0;
result.frequency := 0;
result.codec := '';

    stream := MyFileOpen(nomefile, ARES_READONLY_ACCESS);
    if stream=nil then exit;


count := stream.Read(buffer,116);

FreeHandleStream(Stream);

if count<>116 then exit;



count := buffer[35];
count := count shl 8;
count := count + buffer[34];
count := count shl 8;
count := count + buffer[33];
count := count shl 8;
count := count + buffer[32];
if count>0 then framerate := 1000000 div count else framerate := 0; // 24000 fotogrammi al millesimo di secondo
if framerate=0 then begin
exit;
end;
count := buffer[51];
count := count shl 8;
count := count + buffer[50];
count := count shl 8;
count := count + buffer[49];
count := count shl 8;
count := count + buffer[48];
count := count * 1000; // perchè non ho mollato il framerate
result.duration := (count div (framerate)) div 1000;

wres := buffer[67];
wres := wres shl 8;
wres := wres + buffer[66];
wres := wres shl 8;
wres := wres + buffer[65];
wres := wres shl 8;
result.bitrate := wres + buffer[64];

hres := buffer[71];
hres := hres shl 8;
hres := hres + buffer[70];
hres := hres shl 8;
hres := hres + buffer[69];
hres := hres shl 8;
result.frequency := hres + buffer[68];
codec := '';
codec := codec+chr(ord(buffer[112]));
codec := codec+chr(ord(buffer[113]));
codec := codec+chr(ord(buffer[114]));
result.codec := codec+chr(ord(buffer[115]));
end;

function ricava_dati_psp(nomefile: WideString):record_audioinfo;
var
stream: Thandlestream;
buffer: array [0..71]of Byte;
count:longint;
begin
result.duration := 0;
result.bitrate := 0;
result.frequency := 0;
result.codec := '';

    stream := MyFileOpen(nomefile, ARES_READONLY_ACCESS);
    if stream=nil then exit;


stream.Read(buffer,71);


FreeHandleStream(Stream);


count := buffer[53];
count := count shl 8;
count := count + buffer[52];
count := count shl 8;
count := count + buffer[51];
count := count shl 8;
count := count + buffer[50];
result.bitrate := count;
count := buffer[57];
count := count shl 8;
count := count + buffer[56];
count := count shl 8;
count := count + buffer[55];
count := count shl 8;
count := count + buffer[54];
result.frequency := count;
count := buffer[70];
count := count shl 8;
count := count + buffer[69];
result.duration := count;

end;

function ricava_dati_psd(nomefile: WideString):record_audioinfo;
var
stream : Thandlestream;
buffer: array [0..26]of Byte;
count:longint;
begin
result.duration := 0;
result.bitrate := 0;
result.frequency := 0;
result.codec := '';

    stream := MyFileOpen(nomefile, ARES_READONLY_ACCESS);
    if stream=nil then exit;

stream.Read(buffer,26);


FreeHandleStream(Stream);


count := buffer[14];
count := count shl 8;
count := count + buffer[15];
count := count shl 8;
count := count + buffer[16];
count := count shl 8;
count := count + buffer[17];
result.bitrate := count;
count := buffer[18];
count := count shl 8;
count := count + buffer[19];
count := count shl 8;
count := count + buffer[20];
count := count shl 8;
count := count + buffer[21];
result.frequency := count;
count := buffer[22];
count := count shl 8;
count := count + buffer[23];
result.duration := count;
end;

procedure estrai_titolo_artista_album_da_stringa(risultato:precord_title_album_artist; titlez: WideString);
var i,h: Integer;
num_trattini: Byte;
stringa,
estensione,
artist,
album,
title,
temp: WideString;
begin
title := extract_fnameW(titlez);
estensione := extractfileext(title);

title := copy(title,1,length(title)-length(estensione));

  num_trattini := 0;
  for i := 1 to length(title) do if title[i]='-' then begin
  temp := copy(title,2,length(title));
   for h := 1 to length(temp) do if temp[h]='-' then begin   // troviamo punto finale
    temp := copy(temp,1,h-1);
    break;
   end;

  if temp<>' ' then inc(num_trattini);   // ho qualche cosa?
  end;

   if num_trattini=1 then begin
   stringa := title;
    artist := copy(stringa,1,TntSysUtils.WideTextPos('-',Stringa)-1);
   stringa := copy(stringa,TntSysUtils.WideTextPos('-',Stringa)+1,length(stringa));
    title := stringa;
  end else if num_trattini>1 then begin
   stringa := title;
    artist := copy(stringa,1,TntSysUtils.WideTextPos('-',Stringa)-1);
   stringa := copy(stringa,TntSysUtils.WideTextPos('-',Stringa)+1,length(stringa));
    album := copy(stringa,1,TntSysUtils.WideTextPos('-',Stringa)-1);
   stringa := copy(stringa,TntSysUtils.WideTextPos('-',Stringa)+1,length(stringa));
    title := stringa;
  end;

 if length(title)=0 then begin
  title := extract_fnameW(titlez);
  estensione := extractfileext(title);
  title := copy(title,1,length(title)-length(estensione));
 end; // togliamo parentesi


  risultato.title := strippa_parentesi(title);
  risultato.album := strippa_parentesi(album);
  risultato.artist := strippa_parentesi(artist);

 end;

function GetMediaInfo(FileName: WideString): TDSMediaInfo;
var
  DirectDraw: IDirectDraw;
  AMStream: IAMMultiMediaStream;
  MMStream: IMultiMediaStream;
  PrimaryVidStream: IMediaStream;
  DDStream: IDirectDrawMediaStream;
  GraphBuilder: IGraphBuilder;
  MediaSeeking: IMediaSeeking;
  DesiredSurface: TDDSurfaceDesc;
  DDSurface: IDirectDrawSurface;
  sttim:STREAM_TIME;
begin
try


  OleCheck(DirectDrawCreate(nil, DirectDraw, nil));
  DirectDraw.SetCooperativeLevel(GetDesktopWindow(), DDSCL_NORMAL);

  AMStream := IAMMultiMediaStream(CreateComObject(CLSID_AMMultiMediaStream));
  OleCheck(AMStream.Initialize(STREAMTYPE_READ, AMMSF_NOGRAPHTHREAD, nil));
  OleCheck(AMStream.AddMediaStream(DirectDraw, @MSPID_PrimaryVideo, 0, IMediaStream(nil^)));


  result.FileSize := GetHugeFileSize(FileName);
  OleCheck(AMStream.OpenFile(PWideChar(FileName), AMMSF_NOCLOCK));


  AMStream.GetFilterGraph(GraphBuilder);
  MediaSeeking := GraphBuilder as IMediaSeeking;
  MediaSeeking.GetDuration(result.MediaLength);
  MMStream := AMStream as IMultiMediaStream;
  OleCheck(MMStream.GetMediaStream(MSPID_PrimaryVideo, PrimaryVidStream));
  DDStream := PrimaryVidStream as IDirectDrawMediaStream;


  DDStream.GetTimePerFrame(sttim);
  result.AvgTimePerFrame := sttim;
  {Result.FrameCount := Result.MediaLength div Result.AvgTimePerFrame;}
  { TODO : Test for better accuracy }
  if (result.AvgTimePerFrame>0) and (result.MediaLength>0) then
  result.FrameCount := Round(result.MediaLength / result.AvgTimePerFrame)
   else result.FrameCount := 0;


  result.MediaLength := result.FrameCount * result.AvgTimePerFrame;
  ZeroMemory(@DesiredSurface, SizeOf(DesiredSurface));
  DesiredSurface.dwSize := Sizeof(DesiredSurface);
  OleCheck(DDStream.GetFormat(TDDSurfaceDesc(nil^), IDirectDrawPalette(nil^),DesiredSurface, DWord(nil^)));
  result.SurfaceDesc := DesiredSurface;
  DesiredSurface.ddsCaps.dwCaps := DesiredSurface.ddsCaps.dwCaps or
                               DDSCAPS_OFFSCREENPLAIN or DDSCAPS_SYSTEMMEMORY;
  DesiredSurface.dwFlags := DesiredSurface.dwFlags or DDSD_CAPS or DDSD_PIXELFORMAT;
  {Create a surface here to get vital statistics}
  OleCheck(DirectDraw.CreateSurface(DesiredSurface, DDSurface, nil));
  OleCheck(DDSurface.GetSurfaceDesc(DesiredSurface));
  result.Pitch := DesiredSurface.lPitch;
  if DesiredSurface.ddpfPixelFormat.dwRGBBitCount = 24 then
   result.PixelFormat := pf24bit
  else
    if DesiredSurface.ddpfPixelFormat.dwRGBBitCount = 32 then
      result.PixelFormat := pf32bit;
   result.Width := DesiredSurface.dwWidth;
    result.Height := DesiredSurface.dwHeight;
    except
    end;


end;

function ottieni_data_exe(nome: WideString): string;
var
hwndfile: Cardinal;
ftCreate, ftLocal:FILETIME;
stCreate:SYSTEMTIME;
begin
result := '';

   hwndfile := tntwindows.Tnt_CreateFileW(PwideChar(nome), GENERIC_READ , FILE_SHARE_READ or FILE_SHARE_WRITE , nil, OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);
   if hwndfile=INVALID_HANDLE_VALUE then exit;

try
   if GetFileTime(hwndfile, @ftCreate, nil, nil) then begin
   if FileTimeToLocalFileTime(ftcreate, ftLocal) then begin
   FileTimeToSystemTime(ftLocal, stCreate);
   if stcreate.wmonth<10 then Result := '0'+inttostr(stcreate.wmonth)+'/' else Result := inttostr(stcreate.wmonth)+'/';
   if stcreate.wday<10 then Result := result+'0'+inttostr(stcreate.wday)+'/' else Result := result+inttostr(stcreate.wday)+'/';
   Result := result+inttostr(stcreate.wyear);
   end;
   end;  // se ho exe info
except
end;
    closehandle(hwndfile);

end;

function MyGetModuleFileNameW(hModule: HINST; lpFilename: PWideChar; nSize: DWORD): widestring;
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT{Win32PlatformIsUnicode} then GetModuleFileNameW{TNT-ALLOW GetModuleFileNameW}(hModule, lpFilename, nSize)
  else begin
    Result := application.exename;
  end;
end;

function get_app_name: WideString;
begin
 SetLength(result,MAX_PATH-1);
 Result := MyGetModuleFileNameW(0,@result[1],length(result));

 if result='' then Result := application.exename; //emergenza?
end;








// mp4 basic infos ********************************************************************
constructor tatom.create(const atomHeader: string; atomParent: Tatom; atomSize: Cardinal);
begin
 mchilds := tmylist.create;
 //mtype := atomType;
 mparent := atomParent;
 if mparent<>nil then mparent.mchilds.add(self);
 msize := atomSize;
 assignType(atomHeader);
 mboxtype := HeadertoBoxType;
end;

procedure tatom.assignType(const Header: string);
begin
if header='ftyp' then mtype := at_ftyp else
if header='uuid' then mtype := at_uuid else
if header='moov' then mtype := at_moov else
if header='mdat' then mtype := at_mdat else
if header='mvhd' then mtype := at_mvhd else
if header='iods' then mtype := at_iods else
if header='trak' then mtype := at_trak else
if header='tkhd' then mtype := at_tkhd else
if header='mdia' then mtype := at_mdia else
if header='mdhd' then mtype := at_mdhd else
if header='hdlr' then mtype := at_hdlr else
if header='minf' then mtype := at_minf else
if header='vmhd' then mtype := at_vmhd else
if header='dinf' then mtype := at_dinf else
if header='dref' then mtype := at_dref else
if header='stbl' then mtype := at_stbl else
if header='url ' then mtype := at_url else
if header='stsd' then mtype := at_stsd else
if header=chr(0)+chr(0)+chr(0)+chr(1) then mtype := at_unknown else //in sttd
if header='avc1' then mtype := at_avc1 else
if header='avcC' then mtype := at_avcC else
if header='btrt' then mtype := at_btrt else
if header='stts' then mtype := at_stts else
if header='stss' then mtype := at_stss else
if header='stsc' then mtype := at_stsc else
if header='stsz' then mtype := at_stsz else
if header='stco' then mtype := at_stco else
if header='smhd' then mtype := at_smhd else
if header='mp4a' then mtype := at_mp4a else
if header='esds' then mtype := at_esds else
if header='udta' then mtype := at_udta else
if header='meta' then mtype := at_meta else
if header='ilst' then mtype := at_ilst else
if header='gsst' then mtype := at_gsst else
if header='data' then mtype := at_data else
if header='gstd' then mtype := at_gstd else
if header='gssd' then mtype := at_gssd else
if header='gspu' then mtype := at_gspu else
if header='gspm' then mtype := at_gspm else
if header='gshh' then mtype := at_gshh else
if header='ctoo' then mtype := at_ctoo else
if header='data' then mtype := at_data else
mtype := at_unknown;
end;

function tatom.HeadertoBoxType: TatomboxType;
begin
case mtype of
 at_ftyp,at_mdat,at_mvhd,at_iods,at_tkhd,at_mdhd,at_hdlr,at_vmhd,at_smhd,at_avcC,at_btrt,
 at_stts,at_stss,at_stsc,at_stsz,at_stco,
 at_esds,at_url: Result := CHILD_ATOM;

 at_stsd,at_mp4a: Result := DUAL_STATE_ATOM;

 at_moov,at_trak,at_mdia,at_minf,at_stbl,
 at_gsst,at_gstd,at_gssd,at_gspu,at_gspm,at_gshh: Result := PARENT_ATOM;

 at_avc1,at_udta,at_ilst,at_meta,at_free,at_data,at_dinf,at_dref,at_ctoo: Result := CHILD_ATOM // dont care

  else Result := CHILD_ATOM;
end;
//
end;

destructor tatom.destroy;
var
 i: Integer;
 atom: Tatom;
begin
for i := 0 to mchilds.count-1 do begin
 atom := mchilds[i];
 atom.Free;
end;

 mchilds.Free;
end;

procedure TMP4Parser.Error(const errorS: string);
begin
fcurrentState := PARSER_ERROR;
//form1.memo1.lines.add('ERROR: '+errorS);
end;

constructor TMP4Parser.create();
begin
//log('MP4Parser create');
atoms := tmylist.create;

end;

procedure TMP4Parser.readFile(const filename: WideString);
begin
freeAtoms(atoms);
hasMDAT := False;
fwidth := 0;
fheight := 0;
fduration := 0;
offsetMDAT := -1;
faudioFound := False;
fvideoFound := False;

bufferHeader := myfileopen(filename,ARES_READONLY_ACCESS);
if bufferHeader=nil then exit;

   //bufferHeader.Seek(0,soFromBeginning);
   //readAtom(nil,bufferHeader.size,0);
 startReading;
 //checkHasMDAT;

freehandlestream(bufferHEader);
 if not hasMDAT then begin
  fwidth := 0;
  fheight := 0;
  fduration := 0;
 end;
end;

destructor TMP4Parser.destroy;
//var
// dwWrite: Cardinal;
// err: Integer;
begin
 freeAtoms(atoms);
atoms.Free;
end;

procedure TMP4Parser.freeAtoms(list: TMylist);
var
 i: Integer;
 atom: Tatom;
begin
for i := 0 to list.count-1 do begin
 atom := list[i];
 atom.Free;
end;
list.clear;
end;

function TMP4Parser.getCurrentState: TparserState;
begin
result := fcurrentState;
end;

procedure TMP4Parser.setCurrentState(value: TparserState);
begin
fcurrentState := value;
end;

procedure TMP4Parser.readAtom(parentAtom: Tatom; sizeAvailable: Int64; tabbing: Cardinal);
var
 currentPosition: Int64;
 atomHeader: array [0..7] of char;
 atomLenBuf: array [0..3] of char;
 lenAtomC: Cardinal;
 lenAtom64: Int64;
 atom: Tatom;
 atomName: string;
 bytesRead: Int64;
 mp4a_buffer: array [0..27] of char;
 tmpBuffer: array [0..1] of Byte;
 numW: Word;
 len: Int64;
// res: Byte;
 tmp64buf1,tmp64buf2: array [0..7] of Byte;
begin
if currentState=PARSER_ERROR then exit;
 try
currentPosition := bufferHeader.position;

bytesRead := 0;
while (bytesRead+8<sizeAvailable) do begin

if currentState=PARSER_ERROR then exit;

 //log('Level'+inttostr(tabbing)+' CurrentPosition:'+inttostr(currentPosition)+' read '+inttostr(bytesRead)+' of '+inttostr(sizeAvailable));
 bufferHeader.seek(currentPosition,soFromBeginning);
 if bufferHeader.read(atomHeader,8)<>8 then begin
  error('readAtom reading atom length at byte:'+inttostr(bufferHeader.position));
  break;
 end;



 atomLenBuf[0] := atomHeader[3];
 atomLenBuf[1] := atomHeader[2];
 atomLenBuf[2] := atomHeader[1];
 atomLenBuf[3] := atomHeader[0];
 move(atomLenBuf,lenAtomC,4);
 lenAtom64 := lenAtomC;

 SetLength(atomName,4);
 move(atomHeader[4],atomName[1],4);

 //showmessage(atomName+' '+inttostr(lenAtom));
 //if atomName='mdat' then begin
 // log('readAtom reached MDAT at '+inttostr(bufferHeader.position)+' supposedPosition:'+inttostr(offsetMDAT));
  //break;
 //end;
 if (lenAtomC=1) and (atomName='mdat') then begin
     if bufferHeader.read(tmp64buf1[0],8)=8 then begin
       tmp64buf2[0] := tmp64buf1[7];
       tmp64buf2[1] := tmp64buf1[6];
       tmp64buf2[2] := tmp64buf1[5];
       tmp64buf2[3] := tmp64buf1[4];
       tmp64buf2[4] := tmp64buf1[3];
       tmp64buf2[5] := tmp64buf1[2];
       tmp64buf2[6] := tmp64buf1[1];
       tmp64buf2[7] := tmp64buf1[0];
       move(tmp64buf2[0],lenAtom64,8);
     end;
   end;

 if (bytesRead+lenAtom64>sizeAvailable) then begin
  error('readAtom reading atom file truncated:'+atomName+' '+inttostr(lenAtom64)+' '+inttostr(sizeAvailable));
  atomName := '';
  exit;
 end;



 atom := tatom.create(atomName,parentAtom,lenAtom64);
 if (parentAtom=nil) then atoms.add(atom);


 {if atom.mtype<>at_unknown then log(tabbingToStr(tabbing)+atomName+' @ '+
                                                          inttostr(currentPosition)+' len:'+inttostr(lenAtom64)+
                                                          ' ends @ '+inttostr(currentPosition+lenAtom64)) else begin
  log(tabbingToStr(tabbing)+atomName+' UNKNOWN @ '+inttostr(currentPosition)+' len:'+inttostr(lenAtom64)+' ends @ '+inttostr(currentPosition+lenAtom64))
 end;}

  if atom.mboxtype=PARENT_ATOM then readAtom(atom,lenAtom64,tabbing+1) else
  if atom.mboxtype=DUAL_STATE_ATOM then begin
   if atom.mtype=at_avc1 then begin
     fvideoFound := True;
     bufferHeader.seek(78,soFromcurrent);
     readAtom(atom,lenAtom64-78,tabbing+1);
   end else
   if atom.mtype=at_mp4a then begin
    faudioFound := True;
    bufferHeader.read(mp4a_buffer,sizeof(mp4a_buffer));
    fAudioChannels := ord(mp4a_buffer[17]);
     fsample_bytes_per_sample := ord(mp4a_buffer[19]);
     fsample_bytes_per_sample := fsample_bytes_per_sample div 8;

     tmpBuffer[0] := ord(mp4a_buffer[25]);
     tmpBuffer[1] := ord(mp4a_buffer[24]);
     move(tmpBuffer,numW,2);
    faudiosamplingRate := numW;




     //showmessage('Channels:'+inttostr(aacaudioChannels)+' SamplingRate:'+inttostr(aacsamplingRate));
    //thefile.seek(28,soFromcurrent);
    readAtom(atom,lenAtom64-28,tabbing+1); //look for esds
   end else begin
    bufferHeader.seek(8,soFromcurrent);
    readAtom(atom,lenAtom64-8,tabbing+1);
   end;
  end else begin   //child atom!
    if atom.mtype=at_mvhd then read_mvhd(lenAtom64-8) else
    if atom.mtype=at_tkhd then read_tkhd(lenAtom64-8) else
    if atom.mtype=at_uuid then read_uuid(lenAtom64-8) else
    if atom.mtype=at_mdat then hasMDAT := true else
    if atom.mtype=at_avc1 then read_avc1(lenAtom64-8);
   {if (atom.mtype=at_stco) and (audioFound) and (not has_stco) then read_stco(lenAtom-8) else
   if (atom.mtype=at_stsc) and (audioFound) and (not has_stsc) then read_stsc(lenAtom-8) else
   if (atom.mtype=at_stsz) and (audioFound) and (not has_stsz) then read_stsz(lenAtom-8) else
   if atom.mtype=at_mdat then offsetMDAT := currentPosition+8 else
   if (atom.mtype=at_esds) and (audioFound) then begin
    read_esds(lenAtom-8);
        log('readAtom got mp4a samplingRate:'+inttostr(audiosamplingRate)+
            '   Channels:'+inttostr(AudioChannels)+
            ' bytesPerSample:'+inttostr(sample_bytes_per_sample));

   end; }
  end;


  if lenAtom64<8 then begin

   error('readAtom atom len<8:'+inttostr(lenAtom64));
   lenAtom64 := 8;
   atomName := '';
   exit;
  end;

  inc(currentPosition,lenAtom64);
  inc(bytesRead,lenAtom64);
  atomName := '';

end;

except
 error('readAtom try/except readAtom');
 lenAtom64 := 8;
 atomName := '';
 exit;
end;

end;

procedure TMP4Parser.read_uuid(lenAvailable: Cardinal);
var
 str: string;
 ind: Integer;
 tmp,tmp2: string;
 duration,scale,val1,val2: Integer;
begin
if lenAvailable>4096 then lenAvailable := 4096;
if lenAvailable<200 then exit;
SetLength(str,lenAvailable);
bufferHeader.read(str[1],lenAvailable);

ind := pos('<xmpDM:duration'+chr(10)+'    xmpDM:value="',str);
if ind<>0 then begin
 tmp := copy(str,ind+33,100);
 tmp2 := copy(tmp,1,pos('"',tmp)-1);
 delete(tmp,1,pos('"1/',tmp)+2);
 delete(tmp,pos('"',tmp),length(tmp));
 val1 := strtointdef(tmp2,0);
 val2 := strtointdef(tmp,0);
 if (val1>0) and (val2>0) then begin
  fduration := val1 div val2;
  //log('duration:'+inttostr( fduration ));
 end;
end;

ind := pos('<xmpDM:videoFrameSize'+chr(10)+'    stDim:w="',str);
if ind<>0 then begin
 tmp := copy(str,ind+35,100);
 tmp2 := copy(tmp,1,pos('"',tmp)-1);
 delete(tmp,1,pos('stDim:h="',tmp)+8);
 delete(tmp,pos('"',tmp),length(tmp));
 //log(tmp2+' '+tmp);
 val1 := strtointdef(tmp2,0);
 val2 := strtointdef(tmp,0);
 if (val1>0) and (val2>0) then begin
  fwidth := val1;
  fheight := val2;
  //log('Width:'+inttostr(val1)+' height:'+inttostr(val2));
 end;
end;

 str := '';
//log('UUID len:'+trim(str));
end;

procedure TMP4Parser.read_avc1(lenAvailable: Cardinal);
var
 buffer: array of Byte;
 offset: Integer;
 tmp1,tmp2: array [0..1] of Byte;
 tmpwidth,tmpheight: Word;
begin
if lenAvailable<28 then exit;

SetLength(buffer,lenAvailable);

bufferHeader.read(buffer[0],lenAvailable);

offset := 4; //skip flags+version
inc(offset,20);
 move(buffer[offset],tmp1[0],2);
 tmp2[0] := tmp1[1];
 tmp2[1] := tmp1[0];
 move(tmp2[0],tmpwidth,2);
inc(offset,2);
 move(buffer[offset],tmp1[0],2);
 tmp2[0] := tmp1[1];
 tmp2[1] := tmp1[0];
 move(tmp2[0],tmpheight,2);

 //log('readAVC1'+inttostr(tmpwidth)+' '+inttostr(tmpheight));
 if (tmpwidth>0) and (tmpheight>0) then begin
  fwidth := tmpwidth;
  fheight := tmpheight;
 end;


end;

procedure TMP4Parser.read_tkhd(lenAvailable: Cardinal);
var
 buffer: array of Byte;
 offset: Integer;
 tmp1,tmp2: array [0..3] of Byte;
 tmpwidth,tmpheight: Cardinal;
begin
if lenAvailable<82 then exit;
SetLength(buffer,lenAvailable);
bufferHeader.read(buffer[0],lenAvailable);
offset := 4; //skip flags+version
inc(offset,8); //skip creation time + modification time
inc(offset,12); //skip trackID,reserved,duration
inc(offset,9); //skip reserved,layer,alt group,volume,reserved
inc(offset,41); //skip matrix

move(buffer[offset],tmp1[0],4);
tmp2[0] := tmp1[3];
tmp2[1] := tmp1[2];
tmp2[2] := tmp1[1];
tmp2[3] := tmp1[0];
move(tmp2,tmpwidth,4);
inc(offset,4);

move(buffer[offset],tmp1[0],4);
tmp2[0] := tmp1[3];
tmp2[1] := tmp1[2];
tmp2[2] := tmp1[1];
tmp2[3] := tmp1[0];
move(tmp2,tmpheight,4);

if (tmpwidth>0) and (tmpheight>0) then begin
 fwidth := tmpwidth;
 fheight := tmpheight;
 //log('Width:'+inttostr(fwidth)+' Height:'+inttostr(fheight));
end;

end;

procedure TMP4Parser.read_mvhd(lenAvailable: Cardinal);
var
 buffer: array of Byte;
 offset: Integer;
 timeScale: Cardinal;
 duration: Cardinal;
 tmp1,tmp2: array [0..3] of Byte;
begin
if lenAvailable<20 then exit;
SetLength(buffer,lenAvailable);
bufferHeader.read(buffer[0],lenAvailable);

offset := 4; //skip flags+version
inc(offset,8); //skip creation time + modification time
move(buffer[offset],tmp1[0],4);
tmp2[0] := tmp1[3];
tmp2[1] := tmp1[2];
tmp2[2] := tmp1[1];
tmp2[3] := tmp1[0];
move(tmp2,timescale,4);
inc(offset,4);

move(buffer[offset],tmp1[0],4);
tmp2[0] := tmp1[3];
tmp2[1] := tmp1[2];
tmp2[2] := tmp1[1];
tmp2[3] := tmp1[0];
move(tmp2,duration,4);

fduration := duration div timescale;
//log('Duration:'+inttostr(fduration));
end;

{function TMP4Parser.checkHasMDAT: Boolean;
var
 atomHeader: array [0..7] of char;
 atomLenBuf: array [0..3] of char;
 lenAtom,currentPosition: Cardinal;
 atomName: string;
begin
result := False;
//log('checkHasMDAT headersize:'+inttostr(bufferHeader.Size));
//look for ftyp
try
bufferHeader.Seek(0,soFromBeginning);
if bufferHeader.read(atomHeader,8)<>8 then exit;

 atomLenBuf[0] := atomHeader[3];
 atomLenBuf[1] := atomHeader[2];
 atomLenBuf[2] := atomHeader[1];
 atomLenBuf[3] := atomHeader[0];
 move(atomLenBuf,lenAtom,4);


 SetLength(atomName,4);
 move(atomHeader[4],atomName[1],4);
 if atomName<>'ftyp' then begin
  error('checkHasMDAT ftyp not found!');
  exit;
 end;


 //look for moov
   if lenAtom+8>bufferHeader.size then exit;
   currentPosition := lenAtom;
   bufferHeader.Seek(currentPosition,soFromBeginning);
   if bufferHeader.read(atomHeader,8)<>8 then exit;

   atomLenBuf[0] := atomHeader[3];
   atomLenBuf[1] := atomHeader[2];
   atomLenBuf[2] := atomHeader[1];
   atomLenBuf[3] := atomHeader[0];
   move(atomLenBuf,lenAtom,4);



   move(atomHeader[4],atomName[1],4);
   if (atomName<>'moov') and (atomName<>'uuid') then begin

   // if atomName='uuid' then begin //after effects?
     //read_uuid(lenAtom-8);
    // Result := True;
    // startReading;
    // exit;
    //end else

    error('checkHasMDAT moov not found! found:'+atomName);
    exit;
   end;

   //look for mdat
   if currentPosition+lenAtom+8>bufferHeader.size then exit;

   inc(currentPosition,lenAtom);
   bufferHeader.Seek(currentPosition,soFromBeginning);
   if bufferHeader.read(atomHeader,8)<>8 then exit;

   atomLenBuf[0] := atomHeader[3];
   atomLenBuf[1] := atomHeader[2];
   atomLenBuf[2] := atomHeader[1];
   atomLenBuf[3] := atomHeader[0];
   move(atomLenBuf,lenAtom,4);
   move(atomHeader[4],atomName[1],4);

   if atomName='free' then begin
    inc(currentPosition,lenAtom);
    bufferHeader.Seek(currentPosition,soFromBeginning);
    if bufferHeader.read(atomHeader,8)<>8 then exit;
       atomLenBuf[0] := atomHeader[3];
       atomLenBuf[1] := atomHeader[2];
       atomLenBuf[2] := atomHeader[1];
       atomLenBuf[3] := atomHeader[0];
       move(atomLenBuf,lenAtom,4);
       move(atomHeader[4],atomName[1],4);
   end;

   if atomName<>'mdat' then begin
    error('checkHasMDAT mdat not found!');
    exit;
   end;
   offsetMDAT := currentPosition+8; //found it!
   lenMDAT := lenAtom;
  // beginningOfMemory := offsetMDAT;

  // log('Found MDAT at '+inttostr(offsetMDAT)+
  //    ' Size:'+inttostr(lenMDAT)+
  //    ' DataComplete at '+inttostr(offsetMDAT+lenMDAT));
    startReading;


   Result := True;
except
end;

end; }

procedure TMP4Parser.startReading;
begin
bufferHeader.Seek(0,soFromBeginning);
readAtom(nil,bufferHeader.size,0);
end;


//*************************************************************************************************



initialization
begin
  { Standard genres }
  MusicGenre[0] := 'Blues';
  MusicGenre[1] := 'Classic Rock';
  MusicGenre[2] := 'Country';
  MusicGenre[3] := 'Dance';
  MusicGenre[4] := 'Disco';
  MusicGenre[5] := 'Funk';
  MusicGenre[6] := 'Grunge';
  MusicGenre[7] := 'Hip-Hop';
  MusicGenre[8] := 'Jazz';
  MusicGenre[9] := 'Metal';
  MusicGenre[10] := 'New Age';
  MusicGenre[11] := 'Oldies';
  MusicGenre[12] := 'Other';
  MusicGenre[13] := 'Pop';
  MusicGenre[14] := 'R&B';
  MusicGenre[15] := 'Rap';
  MusicGenre[16] := 'Reggae';
  MusicGenre[17] := 'Rock';
  MusicGenre[18] := 'Techno';
  MusicGenre[19] := 'Industrial';
  MusicGenre[20] := 'Alternative';
  MusicGenre[21] := 'Ska';
  MusicGenre[22] := 'Death Metal';
  MusicGenre[23] := 'Pranks';
  MusicGenre[24] := 'Soundtrack';
  MusicGenre[25] := 'Euro-Techno';
  MusicGenre[26] := 'Ambient';
  MusicGenre[27] := 'Trip-Hop';
  MusicGenre[28] := 'Vocal';
  MusicGenre[29] := 'Jazz+Funk';
  MusicGenre[30] := 'Fusion';
  MusicGenre[31] := 'Trance';
  MusicGenre[32] := 'Classical';
  MusicGenre[33] := 'Instrumental';
  MusicGenre[34] := 'Acid';
  MusicGenre[35] := 'House';
  MusicGenre[36] := 'Game';
  MusicGenre[37] := 'Sound Clip';
  MusicGenre[38] := 'Gospel';
  MusicGenre[39] := 'Noise';
  MusicGenre[40] := 'AlternRock';
  MusicGenre[41] := 'Bass';
  MusicGenre[42] := 'Soul';
  MusicGenre[43] := 'Punk';
  MusicGenre[44] := 'Space';
  MusicGenre[45] := 'Meditative';
  MusicGenre[46] := 'Instrumental Pop';
  MusicGenre[47] := 'Instrumental Rock';
  MusicGenre[48] := 'Ethnic';
  MusicGenre[49] := 'Gothic';
  MusicGenre[50] := 'Darkwave';
  MusicGenre[51] := 'Techno-Industrial';
  MusicGenre[52] := 'Electronic';
  MusicGenre[53] := 'Pop-Folk';
  MusicGenre[54] := 'Eurodance';
  MusicGenre[55] := 'Dream';
  MusicGenre[56] := 'Southern Rock';
  MusicGenre[57] := 'Comedy';
  MusicGenre[58] := 'Cult';
  MusicGenre[59] := 'Gangsta';
  MusicGenre[60] := 'Top 40';
  MusicGenre[61] := 'Christian Rap';
  MusicGenre[62] := 'Pop/Funk';
  MusicGenre[63] := 'Jungle';
  MusicGenre[64] := 'Native American';
  MusicGenre[65] := 'Cabaret';
  MusicGenre[66] := 'New Wave';
  MusicGenre[67] := 'Psychadelic';
  MusicGenre[68] := 'Rave';
  MusicGenre[69] := 'Showtunes';
  MusicGenre[70] := 'Trailer';
  MusicGenre[71] := 'Lo-Fi';
  MusicGenre[72] := 'Tribal';
  MusicGenre[73] := 'Acid Punk';
  MusicGenre[74] := 'Acid Jazz';
  MusicGenre[75] := 'Polka';
  MusicGenre[76] := 'Retro';
  MusicGenre[77] := 'Musical';
  MusicGenre[78] := 'Rock & Roll';
  MusicGenre[79] := 'Hard Rock';
  { Extended genres }
  MusicGenre[80] := 'Folk';
  MusicGenre[81] := 'Folk-Rock';
  MusicGenre[82] := 'National Folk';
  MusicGenre[83] := 'Swing';
  MusicGenre[84] := 'Fast Fusion';
  MusicGenre[85] := 'Bebob';
  MusicGenre[86] := 'Latin';
  MusicGenre[87] := 'Revival';
  MusicGenre[88] := 'Celtic';
  MusicGenre[89] := 'Bluegrass';
  MusicGenre[90] := 'Avantgarde';
  MusicGenre[91] := 'Gothic Rock';
  MusicGenre[92] := 'Progessive Rock';
  MusicGenre[93] := 'Psychedelic Rock';
  MusicGenre[94] := 'Symphonic Rock';
  MusicGenre[95] := 'Slow Rock';
  MusicGenre[96] := 'Big Band';
  MusicGenre[97] := 'Chorus';
  MusicGenre[98] := 'Easy Listening';
  MusicGenre[99] := 'Acoustic';
  MusicGenre[100] :=  'Humour';
  MusicGenre[101] :=  'Speech';
  MusicGenre[102] :=  'Chanson';
  MusicGenre[103] :=  'Opera';
  MusicGenre[104] :=  'Chamber Music';
  MusicGenre[105] :=  'Sonata';
  MusicGenre[106] :=  'Symphony';
  MusicGenre[107] :=  'Booty Bass';
  MusicGenre[108] :=  'Primus';
  MusicGenre[109] :=  'Porn Groove';
  MusicGenre[110] :=  'Satire';
  MusicGenre[111] :=  'Slow Jam';
  MusicGenre[112] :=  'Club';
  MusicGenre[113] :=  'Tango';
  MusicGenre[114] :=  'Samba';
  MusicGenre[115] :=  'Folklore';
  MusicGenre[116] :=  'Ballad';
  MusicGenre[117] :=  'Power Ballad';
  MusicGenre[118] :=  'Rhythmic Soul';
  MusicGenre[119] :=  'Freestyle';
  MusicGenre[120] :=  'Duet';
  MusicGenre[121] :=  'Punk Rock';
  MusicGenre[122] :=  'Drum Solo';
  MusicGenre[123] :=  'A capella';
  MusicGenre[124] :=  'Euro-House';
  MusicGenre[125] :=  'Dance Hall';
  MusicGenre[126] :=  'Goa';
  MusicGenre[127] :=  'Drum & Bass';
  MusicGenre[128] :=  'Club-House';
  MusicGenre[129] :=  'Hardcore';
  MusicGenre[130] :=  'Terror';
  MusicGenre[131] :=  'Indie';
  MusicGenre[132] :=  'BritPop';
  MusicGenre[133] :=  'Negerpunk';
  MusicGenre[134] :=  'Polsk Punk';
  MusicGenre[135] :=  'Beat';
  MusicGenre[136] :=  'Christian Gangsta Rap';
  MusicGenre[137] :=  'Heavy Metal';
  MusicGenre[138] :=  'Black Metal';
  MusicGenre[139] :=  'Crossover';
  MusicGenre[140] :=  'Contemporary Christian';
  MusicGenre[141] :=  'Christian Rock';
  MusicGenre[142] :=  'Merengue';
  MusicGenre[143] :=  'Salsa';
  MusicGenre[144] :=  'Trash Metal';
  MusicGenre[145] :=  'Anime';
  MusicGenre[146] :=  'JPop';
  MusicGenre[147] :=  'Synthpop';
end;




end.