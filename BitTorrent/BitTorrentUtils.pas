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
misc stuff 
}

unit BitTorrentUtils;

interface

uses
  Classes, Classes2, Windows, SysUtils, Btcore, TorrentParser, Ares_objects;

type
  TBitTorrentTransferCreator = class(tthread)
  protected
    BitTorrentTransfer: TBittorrentTransfer;
    procedure execute; override;
    procedure start_thread; //sync
    procedure AddVisualTransferReference;
  public
    path: WideString;
  end;


//procedure parseMetaTorrent(info: TTorrentParser);
procedure loadTorrent(filename: WideString);
procedure check_bittorrentTransfers;
function BTRatioToEmotIndex(uploaded: Int64; downloaded: Int64): Integer;
procedure hash_compute(const FileName: widestring; fsize: Int64; var sha1: string; var hash_of_phash: string; var point_of_insertion: Cardinal);
procedure loadmagnetTorrent(ahash: string; const suggestedName: string; suggestedMime: Integer; const trackers: string);
function bittorrentStatetoByte(state: TDownloadState): Byte;
function BytetoBittorrentState(inb: Byte): TDownloadState;
function torrentSeedtoLeechRatioToNumStars(seeds: Integer; leeches:integer): Integer;
function torrentavailibility_to_str(seeds: Integer; leeches:integer): WideString;

implementation

uses
  helper_diskio, ares_types, helper_unicode,
  tntwindows, ufrmmain, vars_global, helper_ICH,
  BitTorrentDlDb,thread_bittorrent,helper_strings,const_ares,
  bittorrentConst,comettrees,helper_urls,helper_base64_32,
  helper_mimetypes,dhtkeywords,helper_share_misc,secureHash,
  vars_localiz;

function bittorrentStatetoByte(state: TDownloadState): Byte;
begin
 case state of
  dlprocessing,dldownloading: Result := 0;
  dlPaused: Result := 1;
  dlSeeding: Result := 2
   else Result := 0;
  end;
end;

function BytetoBittorrentState(inb: Byte): TDownloadState;
begin
 case inb of
  0: Result := dlProcessing;
  1: Result := dlPaused;
  2: Result := dlSeeding;
  else Result := dlProcessing;
 end;
end;

function torrentSeedtoLeechRatioToNumStars(seeds: Integer; leeches:integer): Integer;
begin
if seeds<2 then Result := 1 else
if seeds<10 then Result := 2 else
if seeds<80 then Result := 3 else
result := 4;
end;

function torrentavailibility_to_str(seeds: Integer; leeches:integer): WideString;
var
 strleech: string;
begin
if leeches>0 then strleech := '/'+inttostr(leeches) else strleech := '';

 if seeds>500 then Result := GetLangStringW(STR_VERYGOOD) else
 if seeds>100 then Result := GetLangStringW(STR_GOOD) else
 if seeds>20 then Result := GetLangStringW(STR_AVERAGE) else
 if seeds>0 then Result := GetLangStringW(STR_POOR) else begin
  Result := GetLangStringW(STR_OFFLINE);
  exit;
 end;
 Result := result+' ('+inttostr(seeds)+strleech+')';
end;

procedure loadmagnetTorrent(ahash: string; const suggestedName: string; suggestedMime: Integer; const trackers: string);
var
 BitTorrentTransfer: TBittorrentTransfer;
 node:pcmtvnode;
 dataNode:ares_types.precord_data_node;
 data:precord_displayed_bittorrentTransfer;
 afile: TBitTorrentFile;
 tracker: TbittorrentTracker;
 ind: Integer;
 ext,tmp,trackerUrl: string;
begin
 if length(ahash)<>40 then begin
  ahash := bytestr_to_hexstr(helper_base64_32.DecodeBase32(ahash));
  if length(ahash)<>40 then begin

   exit;
  end;
 end;
 trackerUrl := trackers;

 BitTorrentTransfer := tBittorrentTransfer.create;
 BitTorrentTransfer.fhashvalue := helper_strings.hexstr_to_bytestr(ahash);
 BitTorrentTransfer.ffileS := tmylist.create;
 BitTorrentTransfer.suggestedMime := suggestedMime;
 
 outputdebugstring(PChar('bittorrentUtils suggested mime:'+inttostr(suggestedmime)));

 if length(suggestedName)=0 then BitTorrentTransfer.fname := 'Magnet URI:'+ahash
  else BitTorrentTransfer.fname := suggestedName;

 if length(trackerURL)>0 then begin
     ind := pos(CHRNULL,trackerURL);
    if ind>0 then begin
     while (length(trackerURL)>0) do begin
       if ind>0 then begin
        tmp := copy(trackerURL,1,ind-1);
             delete(trackerURL,1,ind);
             BittorrentTransfer.addTracker(tmp);
             outputdebugstring(PChar('bittorrentUtils adding multiple tracker:'+tmp));
        end else begin
            BittorrentTransfer.addTracker(trackerURL);
            outputdebugstring(PChar('bittorrentUtils adding multiple tracker:'+trackerurl));
            break;
        end;
         ind := pos(CHRNULL,trackerURL);
     end;
    end else begin
     BittorrentTransfer.addTracker(trackerURL);
     outputdebugstring(PChar('bittorrentUtils adding single tracker:'+trackerurl));
    end;
 end;

 bittorrentTransfer.fstate := dlBittorrentMagnetDiscovery;


  /////////////////////////// VISUAL //////////////////////////////////////////
       node := ares_frmmain.treeview_download.AddChild(nil);
       dataNode := ares_frmmain.treeview_download.getdata(Node);

      dataNode^.m_type := dnt_bittorrentMain;

      data := AllocMem(sizeof(record_displayed_bittorrentTransfer));
      dataNode^.data := Data;

     bittorrentTransfer.visualNode := node;
     bittorrentTransfer.visualData := data;
     bittorrentTransfer.visualData^.handle_obj := longint(bittorrentTransfer);
     bittorrentTransfer.visualData^.FileName := BitTorrentTransfer.fname;
     bittorrentTransfer.visualData^.Size := 0;
     bittorrentTransfer.visualData^.downloaded := 0;
     bittorrentTransfer.visualData^.uploaded := 0;
     bittorrentTransfer.visualData^.hash_sha1 := bittorrentTransfer.fhashvalue;
     bittorrentTransfer.visualData^.crcsha1 := crcstring(bittorrentTransfer.fhashvalue);
     bittorrentTransfer.visualData^.SpeedDl := 0;
     bittorrentTransfer.visualData^.SpeedUl := 0;
     bittorrentTransfer.visualData^.want_cancelled := False;
     bittorrentTransfer.visualData^.want_paused := False;
     bittorrentTransfer.visualData^.want_changeView := False;
     bittorrentTransfer.visualData^.want_cleared := False;
     bittorrentTransfer.visualData^.num_Sources := 0;
     bittorrentTransfer.visualData^.ercode := 0;
     bittorrentTransfer.visualData^.state := bittorrentTransfer.fstate;
     if bittorrentTransfer.trackers.count>0 then begin
      tracker := bittorrentTransfer.trackers[bittorrentTransfer.trackerIndex];
      bittorrentTransfer.visualData^.trackerStr := tracker.URL;
     end else bittorrentTransfer.visualData^.trackerStr := '';
     bittorrentTransfer.visualData^.Fpiecesize := 0;
     bittorrentTransfer.visualData^.NumLeechers := 0;
     bittorrentTransfer.visualData^.NumSeeders := 0;
     if bittorrentTransfer.ffiles.count=1 then begin
       afile := bittorrentTransfer.ffiles[0];
       bittorrentTransfer.visualData^.path := afile.ffilename;
     end else bittorrentTransfer.visualData^.path := bittorrentTransfer.fname;
     bittorrentTransfer.visualData^.NumConnectedSeeders := 0;
     bittorrentTransfer.visualData^.NumConnectedLeechers := 0;
    SetLength(bittorrentTransfer.visualData^.bitfield,length(bittorrentTransfer.FPieces));

   btcore.CloneBitField(bittorrentTransfer);
   /////////////////////////////////////////////////////////////////////////////////////////

 if vars_global.BitTorrentTempList=nil then vars_global.BitTorrentTempList := tmylist.create;
 if vars_global.bittorrent_Accepted_sockets=nil then vars_global.bittorrent_Accepted_sockets := tmylist.create;

  if vars_global.thread_bittorrent=nil then begin
    vars_global.thread_bittorrent := tthread_bitTorrent.create(true);
     vars_global.thread_bittorrent.BittorrentTransfers := tmylist.create;
     vars_global.thread_bittorrent.resume;
  end;
  vars_global.BitTorrentTempList.add(bittorrentTransfer);

 if ares_frmmain.tabs_pageview.activePage<>IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activePage := IDTAB_TRANSFER;

end;

function BTRatioToEmotIndex(uploaded: Int64; downloaded: Int64): Integer;
begin
if ((uploaded>=downloaded) and (uploaded>0)) then Result := 0
 else Result := 9;
end;

procedure check_bittorrentTransfers;
var
 doserror: Integer;
 dirinfo:ares_types.TSearchRecW;
 BitTorrentTransfer: TBittorrentTransfer;
 str: string;
 iterations: Integer;
 tempList: TMylist;
begin
   iterations := 0;
   tempList := tmylist.create;

   
   dosError := helper_diskio.FindFirstW(vars_global.data_Path+'\Data\TempDl\PBTHash_*.dat', faAnyfile, dirInfo);
   while (DosError=0) do begin
       if (((dirinfo.Attr and faDirectory)>0) or
            (dirinfo.name='.') or
            (dirinfo.name='..')) then begin
              DosError := helper_diskio.FindNextW(dirinfo);
              continue;
       end;

       str := dirinfo.name;
       delete(str,1,8);
       delete(str,length(str)-3,4);

       if length(str)=40 then begin

          BitTorrentTransfer := tBitTorrentTransfer.create;
          BitTorrentTransfer.fhashvalue := helper_strings.hexstr_to_bytestr(str);

          BitTorrentDlDb.BitTorrentDb_load(BitTorrentTransfer);


          if ((BitTorrentTransfer.ferrorCode>0) and
              (BitTorrentTransfer.ferrorCode<BT_DBERROR_FILES_LOCKED)) then begin
            BitTorrentTransfer.Free;
            DosError := helper_diskio.FindNextW(dirinfo);
            continue;
          end;

          tempList.add(bittorrentTransfer);
          
       end;

       DosError := helper_diskio.FindNextW(dirinfo);

       inc(iterations);
       if iterations>500 then break;
   end;

   
   helper_diskio.FindCloseW(dirinfo);


  if tempList.count>0 then begin
   ufrmmain.ares_frmmain.timer_start_bittorrent.Tag := integer(tempList);
   ufrmmain.ares_frmmain.timer_start_bittorrent.enabled := True;


  end else tempList.Free;
  //if vars_global.thread_bittorrent<>nil then vars_global.thread_bittorrent.resume;
end;

{procedure parseMetaTorrent(info: TTorrentParser);
var
 i: Integer;
 maxSize: Int64;
 ThisFile: TTorrentSubFile;
 thefilename: string;
begin
maxSize := 0;
 for i := 0 to info.Files.count-1 do begin
  thisfile := (info.Files[i] as TTorrentSubFile);

   thisfile.Name := StripIllegalFileChars(thisfile.Name);
   if length(thisfile.Name)>200 then thisfile.name := copy(thisfile.name,1,200);
    if thisfile.Length>maxSize then begin
     maxSize := thisfile.Length;
     thefilename := thisfile.name;
    end;
  end;


end; }

procedure TBitTorrentTransferCreator.execute;
var
stream: Thandlestream;
Parser: TTorrentParser;

torrentName,tmpPath: string;
buffer: array [0..2] of Byte;
i: Integer;
ffile: TBittorrentFile;
begin
priority := tpnormal;
freeonterminate := True;

stream := MyFileOpen(path,ARES_READONLY_BUT_SEQUENTIAL);
if stream=nil then exit;


Parser := TTorrentParser.Create;
 if not Parser.Load(stream) then begin
  parser.Free;
  FreeHandleStream(Stream);
  exit;
 end;

 torrentName := parser.name;
 TorrentName := StripIllegalFileChars(TorrentName);
 if length(TorrentName)>200 then delete(TorrentName,200,length(TorrentName));

   if length(torrentName)=0 then begin
     tmpPath := widestrtoutf8str(path);
     for i := length(tmpPath) downto 1 do if tmpPath[i]='\' then break;
     if i>1 then delete(TmpPath,1,i);
     torrentName := tmpPath;
     for i := length(torrentName) downto 1 do
      if torrentName[i]='.' then begin  // remove .torrent ext
       delete(TorrentName,i,length(TorrentName));
       break;
      end;
   end;

   
 {Torrent name already in download?}
   if direxistsW(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)) then begin
     if fileexistsW(vars_global.data_Path+'\Data\TempDl\PBTHash_'+bytestr_to_hexstr(parser.hashValue)+'.dat') then begin
       parser.Free;
       FreeHandleStream(Stream);
       exit;
     end;

   torrentName := torrentName+inttohex(random($ff),2)+inttohex(random($ff),2);
   end;
   while direxistsW(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)) do
    torrentName := copy(torrentName,1,length(torrentName)-4)+inttohex(random($ff),2)+inttohex(random($ff),2);
  //////////////////////////////////////////

 tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder),nil);
 if parser.Files.count>1 then tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder+'\'+utf8strtowidestr(torrentName)),nil);

 BitTorrentTransfer := tBittorrentTransfer.create;
 BitTorrentTransfer.init(widestrtoutf8str(vars_global.my_torrentFolder)+'\'+torrentName,
                                          Parser);

//parseMetaTorrent(parser);
parser.Free;
FreeHandleStream(Stream);


 if ((BitTorrentTransfer.ferrorCode>0) and
     (BitTorrentTransfer.ferrorCode<BT_DBERROR_FILES_LOCKED)) then begin
     BitTorrentTransfer.Free;
     exit;
 end;



buffer[0] := 0;

synchronize(AddVisualTransferReference);

// let thread_bittorrent know when file is ready for writing
for i := 0 to bittorrentTransfer.ffiles.count-1 do begin
 ffile := bittorrentTransfer.ffiles[i];

 FreeHandleStream(ffile.fstream);
 while true do begin
 ffile.fstream := MyFileOpen(utf8strtowidestr(ffile.ffilename),ARES_WRITE_EXISTING);
 if ffile.fstream<>nil then break else sleep(10);
 end;
{
 if ffile.fstream.size>0 then begin
  helper_diskio.MyFileSeek(ffile.fstream,ffile.fsize-1,ord(soFromBeginning));
    while (true) do begin
     if helper_diskio.MyFileSeek(ffile.fstream,0,ord(soCurrent))<>ffile.fsize-1 then begin
      helper_diskio.MyFileSeek(ffile.fstream,ffile.fsize-1,ord(soFromBeginning));
      sleep(50);
      continue;
     end else break;
    end;

    ffile.fstream.Write(buffer,1);
  end; }
 

 end;


//end;
bittorrentTransfer.fstate := dlProcessing;




synchronize(start_thread);
end;


procedure tBittorrentTransferCreator.start_thread; //sync
begin

if vars_global.BitTorrentTempList=nil then vars_global.BitTorrentTempList := tmylist.create;
if vars_global.bittorrent_Accepted_sockets=nil then vars_global.bittorrent_Accepted_sockets := tmylist.create;

  if vars_global.thread_bittorrent=nil then begin
    vars_global.thread_bittorrent := tthread_bitTorrent.create(true);
     vars_global.thread_bittorrent.BittorrentTransfers := tmylist.create;
 //    vars_global.thread_bittorrent.BittorrentTransfers.add(bittorrentTransfer);
     vars_global.thread_bittorrent.resume;
  end;
  vars_global.BitTorrentTempList.add(bittorrentTransfer);

if ares_frmmain.tabs_pageview.activePage<>IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activePage := IDTAB_TRANSFER;
end;

procedure tBittorrentTransferCreator.AddVisualTransferReference;
var
 dataNode:ares_types.precord_data_node;
 node:PCMtVNode;
 data:precord_displayed_bittorrentTransfer;
 afile: TBitTorrentFile;
 tracker: TbittorrentTracker;
begin

     if bittorrentTransfer.UploadTreeview then begin
       node := ares_frmmain.treeview_upload.AddChild(nil);
       dataNode := ares_frmmain.treeview_upload.getdata(Node);
     end else begin
       node := ares_frmmain.treeview_download.AddChild(nil);
       dataNode := ares_frmmain.treeview_download.getdata(Node);
      end;
      dataNode^.m_type := dnt_bittorrentMain;

      data := AllocMem(sizeof(record_displayed_bittorrentTransfer));
      dataNode^.data := Data;

     bittorrentTransfer.visualNode := node;
     bittorrentTransfer.visualData := data;
     bittorrentTransfer.visualData^.handle_obj := longint(bittorrentTransfer);
     bittorrentTransfer.visualData^.FileName := widestrtoutf8str(helper_urls.extract_fnameW(utf8strtowidestr(bittorrentTransfer.fname)));
     bittorrentTransfer.visualData^.Size := bittorrentTransfer.fsize;
     bittorrentTransfer.visualData^.downloaded := bittorrentTransfer.fdownloaded;
     bittorrentTransfer.visualData^.uploaded := bittorrentTransfer.fuploaded;
     bittorrentTransfer.visualData^.hash_sha1 := bittorrentTransfer.fhashvalue;
     bittorrentTransfer.visualData^.crcsha1 := crcstring(bittorrentTransfer.fhashvalue);
     bittorrentTransfer.visualData^.SpeedDl := 0;
     bittorrentTransfer.visualData^.SpeedUl := 0;
     bittorrentTransfer.visualData^.want_cancelled := False;
     bittorrentTransfer.visualData^.want_paused := False;
     bittorrentTransfer.visualData^.want_changeView := False;
     bittorrentTransfer.visualData^.want_cleared := False;
     bittorrentTransfer.visualData^.uploaded := bittorrentTransfer.fuploaded;
     bittorrentTransfer.visualData^.downloaded := bittorrentTransfer.fdownloaded;
     bittorrentTransfer.visualData^.num_Sources := 0;
     bittorrentTransfer.visualData^.ercode := 0;
     bittorrentTransfer.visualData^.state := bittorrentTransfer.fstate;
     if bittorrentTransfer.trackers.count>0 then begin
      tracker := bittorrentTransfer.trackers[bittorrentTransfer.trackerIndex];
      bittorrentTransfer.visualData^.trackerStr := tracker.URL;
     end else bittorrentTransfer.visualData^.trackerStr := '';
     bittorrentTransfer.visualData^.Fpiecesize := bittorrentTransfer.fpieceLength;
     bittorrentTransfer.visualData^.NumLeechers := 0;
     bittorrentTransfer.visualData^.NumSeeders := 0;
     if bittorrentTransfer.ffiles.count=1 then begin
       afile := bittorrentTransfer.ffiles[0];
       bittorrentTransfer.visualData^.path := afile.ffilename;
     end else bittorrentTransfer.visualData^.path := bittorrentTransfer.fname;
     bittorrentTransfer.visualData^.NumConnectedSeeders := bittorrentTransfer.NumConnectedSeeders;
     bittorrentTransfer.visualData^.NumConnectedLeechers := bittorrentTransfer.NumConnectedLeechers;
    SetLength(bittorrentTransfer.visualData^.bitfield,length(bittorrentTransfer.FPieces));

   btcore.CloneBitField(bittorrentTransfer);
end;




procedure loadTorrent(filename: WideString);
var
 theName,hash_sha1,hash_of_phash: string;
 pfilez:precord_file_library;
 fsize: Int64;
 point_of_insertion: Cardinal;
 crcsha1: Word;
begin

if not FileExistsW(filename) then exit;
if GetHugeFileSize(filename)<20 then exit;

with TBitTorrentTransferCreator.Create(true) do begin
 path := filename;
 resume;
end;

try
 thename := extractfilename(widestrtoutf8str(filename));
 if FileExistsW(myshared_folder+utf8strtowidestr(thename)) then exit;
 copyFileW(pwidechar(filename),pwidechar(myshared_folder+'\'+utf8strtowidestr(thename)),false);
 fsize := getHugeFileSize(filename);
 filename := myshared_folder+'\'+utf8strtowidestr(thename);
 
 hash_compute(filename,fsize,hash_sha1,hash_of_phash,point_of_insertion);
 if length(hash_sha1)<>20 then exit;
 crcsha1 := crcstring(hash_sha1);


 pfilez := AllocMem(sizeof(record_file_library));
  pfilez^.hash_of_phash := hash_of_phash;
  pfilez^.hash_sha1 := hash_sha1;
  pfilez^.crcsha1 := crcsha1;
  pfilez^.path := widestrtoutf8str(filename);
  pfilez^.ext := '.torrent';
  pfilez^.amime := ARES_MIME_OTHER;
  pfilez^.corrupt := False;

  pfilez^.title := trim(widestrtoutf8str(extract_fnameW(filename)));
  delete(pfilez^.title,length(pfilez^.title)-7,8);
  pfilez^.artist := '';
  pfilez^.album := '';
  pfilez^.category := '';
  pfilez^.year := '';
  pfilez^.language := '';
  pfilez^.comment := '';
  pfilez^.url := '';
  pfilez^.keywords_genre := '';
  pfilez^.fsize := fsize;
  pfilez^.param1 := 0;
  pfilez^.param2 := 0;
  pfilez^.param3 := 0;
  pfilez^.filedate := now;
  pfilez^.vidinfo := '';
  pfilez^.mediatype := mediatype_to_str(ARES_MIME_OTHER);
  pfilez^.shared := True;
  pfilez^.write_to_disk := True;
  pfilez^.phash_index := point_of_insertion; //2956+

  dhtkeywords.DHT_addFileOntheFly(pfilez,false);
  vars_global.lista_shared.add(pfilez);
  inc(vars_global.my_shared_count);
  helper_share_misc.addfile_tofresh_downloads(pfilez);
except
end;
end;

procedure hash_compute(const FileName: widestring; fsize: Int64; var sha1: string; var hash_of_phash: string; var point_of_insertion: Cardinal);
var
  stream: Thandlestream;
  NumBytes: Integer;
  buffer: array [1..1024] of char;
  csha1: Tsha1;

  i: Integer;
  last_sync: Cardinal;
  divisore: Integer;
//  attesa: Word;

  phash_value: string;
  buffer_phash: array [0..19] of char;
  phash_sha1: Tsha1;
  stream_phash: Thandlestream;
  phash_chunk_size: Cardinal;
  bytes_processed_phash: Cardinal;
begin


    stream := MyFileOpen(FileName,ARES_READONLY_BUT_SEQUENTIAL);
    if stream=nil then exit;

    if stream.size<fsize then begin
      FreeHandleStream(Stream);
    exit;
    end;



   i := 0;
   divisore := 25;
    last_sync := gettickcount;

   cSHA1 := TSHA1.Create;

   bytes_processed_phash := 0;

    if fsize>ICH_MIN_FILESIZE then begin
     phash_chunk_size := ICH_calc_chunk_size(fsize);
     phash_sha1 := tsha1.create;

      stream_phash := MyFileOpen(data_path+'\Data\TempPHash.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream_phash=nil then begin
        FreeHandleStream(stream);
       exit;
      end;
    end else begin
     phash_chunk_size := 0;
     stream_phash := nil;
     phash_sha1 := nil;
    end;


  repeat


        NumBytes := stream.read(Buffer, SizeOf(Buffer));

        cSHA1.Transform(Buffer, NumBytes);

        if phash_sha1<>nil then begin

         phash_sha1.Transform(buffer, NumBytes);

         inc(bytes_processed_phash,NumBytes);
         if bytes_processed_phash=phash_chunk_size then begin
              phash_sha1.Complete;
                phash_value := phash_sha1.HashValue;
                move(phash_value[1],buffer_phash,20);
                stream_phash.write(buffer_phash,20);
              phash_sha1.Free;
              phash_sha1 := Tsha1.create;
              bytes_processed_phash := 0;
         end;
        end;


      until (numbytes<>sizeof(buffer));

   FreeHandleStream(Stream);
   
  cSHA1.Complete;
   sha1 := cSHA1.HashValue;
  cSHA1.Free;

  if phash_sha1<>nil then begin
   if bytes_processed_phash>0 then begin
     phash_sha1.Complete;
      phash_value := phash_sha1.HashValue;
      move(phash_value[1],buffer_phash,20);
      stream_phash.write(buffer_phash,20);
                //FlushFileBuffers(stream.handle);
   end;

    phash_sha1.Free;
    FreeHandleStream(stream_phash);

   hash_of_phash := ICH_get_hash_of_phash(sha1);
   point_of_insertion := ICH_copy_temp_to_tmp_db(sha1);
  end;

end;

end.
