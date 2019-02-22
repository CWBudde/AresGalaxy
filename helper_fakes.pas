unit helper_fakes;

interface

uses
 ares_types,helper_diskio,classes,sysutils,umediar,secureHash,helper_strings,const_ares;

 function isFakeFile(const filename: WideString): Boolean;
 function GetTagSize(const Tag: ID3v2TagInfo): Integer;
 function Swap32(const Figure: Integer): Integer;
 function checkFakeByComment(const comment: string): Boolean;

implementation

function checkFakeByComment(const comment: string): Boolean;
var
 i: Integer;
 temp,locomment: string;
 numbers:set of '0'..'9';
begin
result := False;


if length(comment)<1 then exit;
locomment := lowercase(comment);
if pos('aresads',locomment)<>0 then begin
 Result := True;
 exit;
end;

//if pos(' ',comment)=0 then exit;

  numbers := ['0'..'9'];

  temp := trim(helper_strings.strip_char(comment,' '));
  if length(temp)<1 then exit;
  
  for i := 1 to length(temp) do
   if not (temp[i] in numbers) then begin
    Result := False;
    exit;
   end;
   
  Result := True;
end;

function isFakeFile(const filename: WideString): Boolean;
var
 ext: string;
 stream: Thandlestream;
 count: Integer;
 buffer: array [0..149] of Byte;
 Data: array [1..100000] of Char;
 iwidth,iheight: Integer;
 wres,hres: Integer;
 Tag: ID3v2TagInfo;
 FVersionID: Byte;
 FSize: Integer;
 hashex: string;
 Frame: FrameHeaderNew;
 DataPosition, DataSize: Integer;
 sha1: Tsha1;
 //tof: Textfile;
 ssize: Int64;
begin
result := False;

stream := myfileopen(filename,ARES_READONLY_ACCESS);
if stream=nil then exit;
ssize := stream.size;
ext := lowercase(extractfileext(FileName));

if ext='.mp3' then begin
    count := stream.read(tag,10);
    Tag.FileSize := stream.size;;
    if count < 10 then begin
     FreeHandleStream(stream);
     exit;
    end;
    if Tag.ID=ID3V2_ID then begin
     FVersionID := Tag.Version;
     FSize := GetTagSize(Tag);
    
    { Get information from frames if version supported }
    if (FVersionID in [TAG_VERSION_2_2..TAG_VERSION_2_4]) and (FSize>0) then begin
      if FVersionID>TAG_VERSION_2_2 then begin
        try
         while (stream.Position<GetTagSize(Tag)) and (stream.position+1<stream.size) do begin
           FillChar(Data, SizeOf(Data), 0); { Read frame header and check frame ID }
           stream.read(Frame, 10);
           if not (Frame.ID[1] in ['A'..'Z']) then break;
           DataPosition := stream.Position; { Note data position and determine significant data size }
           if Swap32(Frame.Size)>SizeOf(Data) then DataSize := SizeOf(Data)
            else DataSize := Swap32(Frame.Size);

           { Read frame data and set tag item if frame supported }
           stream.read(data, DataSize);

           if (Frame.Flags and $8000<>$8000) and (frame.id='APIC') then begin
              sha1 := tsha1.create;
               sha1.Transform(data[15], DataSize-14);
              sha1.Complete;
              hashex := bytestr_to_hexstr(sha1.HashValue);
              sha1.Free;
              if (hashex='4A2141B7F7E2A6098AADDDCCD722C4541A1156BA') or
                 (hashex='0C587E43D8753ED58297792AA6041F5C1A2CA092') or
                 (hashex='C5BE00C9BE8E1A374E3FF2F14B76B126E0059A1A') or
                 (hashex='DD15EC62688247B4F819E96C19C1D96CC4BD6081') then begin
                  Result := True;
                  FreeHandleStream(stream);
                  exit;
              end else begin
              // assignfile(tof,'c:\users\alonzo\desktop\maybefake_'+extractfilename(filename)+'.log');
              // rewrite(tof);
              // writeln(tof,hashex);
              // closefile(tof);
              end;
            end;

          stream.seek( DataPosition + Swap32(Frame.Size),sofrombeginning);
        end;
       except
       end;
      end;
    end;
    end;

    FreeHandleStream(stream);
end else

if ext='.avi' then begin
  count := stream.Read(buffer,sizeof(buffer));
  FreeHandleStream(Stream);
  if count<>sizeof(buffer) then exit;
  wres := buffer[67];
  wres := wres shl 8;
  wres := wres + buffer[66];
  wres := wres shl 8;
  wres := wres + buffer[65];
  wres := wres shl 8;
  iwidth := wres + buffer[64];

  hres := buffer[71];
  hres := hres shl 8;
  hres := hres + buffer[70];
  hres := hres shl 8;
  hres := hres + buffer[69];
  hres := hres shl 8;
  iheight := hres + buffer[68];
  if ((buffer[128]=10) and (buffer[132]=75) or
      (buffer[128]=1) and (buffer[132]=1) or
      (buffer[128]=1) and (buffer[132]=5) or
      (buffer[128]=1) and (buffer[132]=6) or
      ((buffer[128]=1) and (buffer[132]=15) and (ssize<14*MEGABYTE))) and
      (iwidth=720) and (iheight=480) then begin
      Result := True;
      exit;
  end;
end;

end;

function Swap32(const Figure: Integer): Integer;
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

function GetTagSize(const Tag: ID3v2TagInfo): Integer;
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


end.
