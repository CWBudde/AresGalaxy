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
misc download functions, covers download logic and chunk selection
}

unit helper_download_misc;

interface

uses
ares_types,ares_objects,sysutils,tntwindows,classes2,thread_download,
blcksock,windows,registry,synsock;

function start_download(datao:precord_search_result): Tdownload; overload;
function start_download(datao:precord_file_library; folder: WideString): Tdownload; overload;
function calc_netx_end(punto: Int64; dimensione_chunks: Cardinal; size: Int64): Int64;
function downloadStatetoStrW(DnData:precord_displayed_download): WideString; overload;
function downloadStatetoStrW(BtData:precord_displayed_bittorrentTransfer): WideString; overload;

function sourcestate_to_byte(DsData:precord_displayed_downloadsource): Byte;
function downloadstate_to_byte(state: TDownloadState): Byte;
function source_startbyte_assign(download: Tdownload; risorsa: Trisorsa_download): Boolean;

function handle_to_download(down_handle: Cardinal): Tdownload;
function duplicate_source_nickname(risorsa: Trisorsa_download): Boolean;
function stats_to_str(download: Tdownload; isFirewalled: Boolean; isnew:boolean): string; overload;
function stats_to_str(download: Tdownload): string; overload;
procedure out_http_get_req_str(var destinationStr: string; download: Tdownload;risorsa: Trisorsa_download);
function source_connect(downloa: Tdownload;risorsa: Trisorsa_download): Boolean;
function sources_activecount(risorsa: Trisorsa_download): Integer;
function activedownload_count: Integer;
function encap_new_stat_string(stat_string: string): string;   //2948+ 26/12/2004
function get_out_push_string(hash_sha1: string; randoms: string): string;
function get_out_privchat_req: string;
function get_out_privchat_pushreq(randoms: string): string;
function get_queued_str(posit:integer): WideString;
function max_sources_per_download: Integer;
procedure UpdateVisualBitField(download: TDownload); //sync
procedure seek_suitable_filename(filename: string; const title,artist,album: WideString; download: TDownload);
function isdownloadActive(download: TDownload): Boolean; overload;
function isdownloadActive(DnData:precord_displayed_download): Boolean; overload;

function isDownloadState(download: TDownload; state: TDownloadState): Boolean; overload;
function isDownloadState(download: TDownload; states: TDownloadStates): Boolean; overload;
function isDownloadTerminated(download: TDownload): Boolean; overload;
function isDownloadTerminated(DnData:precord_displayed_download): Boolean; overload;
function isDownloadPaused(download: TDownload): Boolean;
function isSourceState(source: TRisorsa_download; state: TSourceState): Boolean; overload;
function isSourceState(source: TRisorsa_download; states: TSourceStates): Boolean; overload;

function SourceStateToStrW(DsData:precord_displayed_downloadsource): WideString;
procedure UpdateVisualDownload(Download: TDownload);
function isSourceUDPTrying(source: TRisorsa_download): Boolean;
procedure setFocus;

implementation

uses
 ufrmmain,helper_unicode,helper_diskio,vars_global,helper_urls,helper_strings,
 helper_ipfunc,const_ares,helper_sockets,helper_base64_32,helper_crypt,helper_mimetypes,
 helper_altsources,helper_download_disk,helper_http,helpeR_sorting,vars_localiz;

procedure setFocus;
var
point: TPoint;
begin

 GetCursorPos(point);
 ScreenToClient(ares_frmmain.treeview_download.handle,point);
 if (point.x>=0) and
    (point.x<=ares_frmmain.treeview_download.width) and
    (point.y>=0) and
    (point.y<=ares_frmmain.treeview_download.height) then ares_frmmain.treeview_download.SetFocus
     else begin
        if ares_frmmain.treeview_upload.Visible then ares_frmmain.treeview_upload.setfocus else
         if ares_frmmain.treeview_queue.Visible then ares_frmmain.treeview_queue.setfocus
    end;
end;

function isSourceUDPTrying(source: TRisorsa_download): Boolean;
begin
result := ((source.state=srs_UDPPushing) or
         (source.state=srs_waitingForUserUdpAck) or
         (source.state=srs_waitingForUserUDPPieceAck) or
         (source.state=srs_UDPDownloading) or
         (source.state=srs_UDPreceivingICH));
end;

procedure UpdateVisualDownload(Download: TDownload);
var
i: Integer;
piece: TDownloadPiece;
nomedisplay: string;
begin
   with download.display_data^ do begin
      lastDHTCheckForSources := 0;
      filename := download.filename;
      handle_obj := cardinal(download);

      if download.FPieceSize>0 then begin
       SetLength(VisualBitfield,(download.size div download.FPieceSize)+1);
       FPieceSize := download.FPieceSize;
        SetLength(VisualBitField,length(download.FPieces));
        for i := 0 to high(download.FPieces) do begin
         Piece := download.FPieces[i];
         VisualBitField[i] := piece.FDone;
        end;
      end;

     nomedisplay := widestrtoutf8str(helper_urls.extract_fnameW(utf8strtowidestr(download.filename)));
     if ansipos('___arestra___',lowercase(nomedisplay))=1 then delete(nomedisplay,1,13);
      nomedisplayw := utf8strtowidestr(nomedisplay);
     numInDown := download.num_in_down;
     tipo := download.tipo;
     title := download.title;
     artist := download.artist;
     album := download.album;
     category := download.category;
     language := download.language;
     date := download.date;
     param1 := download.param1;
     param2 := download.param2;
     param3 := download.param3;
     url := download.url;
     comments := download.comments;
     keyword_genre := download.keyword_genre;
     num_sources := download.lista_risorse.count;
     num_partial_sources := 0;
     want_cancelled := False;
     change_paused := False;
     hash_sha1 := download.hash_sha1;
     crcsha1 := download.crcsha1;
     state := download.state;
     progress := download.progress;
     size := download.size;

     velocita := download.speed;
     if download.state=dlPaused then state := dlPaused
      else state := dlProcessing;

  end;
end;

function isDownloadState(download: TDownload; state: TDownloadState): Boolean;
begin
result := (download.state=state);
end;
                                                
function isDownloadState(download: TDownload; states: TDownloadStates): Boolean;
begin
result := (download.state in states);
end;

function isSourceState(source: TRisorsa_download; states: TSourceStates): Boolean;
begin
result := (source.state in states);
end;

function isSourceState(source: TRisorsa_download; state: TSourceState): Boolean;
begin
result := (source.state=state);
end;

function isDownloadPaused(download: TDownload): Boolean;
begin
result := ((download.state=dlPaused) or
         (download.state=dlLeechPaused) or
         (download.state=dlLocalPaused))
end;

function isdownloadActive(DnData:precord_displayed_download): Boolean;
begin
result := ((DnData^.state=dlProcessing) or
         (DnData^.state=dlDownloading) or
         (DnData^.state=dlAllocating) or
         (DnData^.state=dlFinishedAllocating));
end;

function isdownloadActive(download: TDownload): Boolean;
begin
result := ((download.state=dlProcessing) or
         (download.state=dlDownloading));
end;

function isDownloadTerminated(download: TDownload): Boolean;
begin
result := ((download.state=dlCompleted) or
         (download.state=dlCancelled) or
         (download.state=dlRebuilding));
end;

function isDownloadTerminated(DnData:precord_displayed_download): Boolean;
begin
result := ((DnData^.state=dlCompleted) or
         (DnData^.state=dlCancelled));
end;


procedure UpdateVisualBitField(download: TDownload); //sync
var
i: Integer;
piece: TDownloadPiece;
begin
if download.FPieceSize=0 then exit;

 download.display_data^.FPieceSize := download.FPieceSize;
 SetLength(download.display_data.VisualBitField,length(download.FPieces));
 for i := 0 to high(download.FPieces) do begin
   Piece := download.FPieces[i];
   download.display_data.VisualBitField[i] := piece.FDone;
 end;

 //ares_frmmain.treeview_download.invalidatenode(down_general.display_node);
end;


function max_sources_per_download: Integer;
begin
   if vars_global.velocita_down<8000 then Result := 2
    else
    if vars_global.velocita_down<15000 then Result := 4
     else
     if vars_global.velocita_down<45000 then Result := 6
      else Result := 8;
end;

function activedownload_count: Integer;
var
i: Integer;
download: Tdownload;
begin
result := 0;
 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
   if isDownloadActive(download) then inc(result);
 end;
end;

function sources_activecount(risorsa: Trisorsa_download): Integer;
var
i,h: Integer;
risorsa_check: Trisorsa_download;
download: Tdownload;
begin
result := 0;

for i := 0 to lista_download.count-1 do begin
 download := lista_download[i];
 if not isDownloadActive(download) then continue;

    for h := 0 to download.lista_risorse.count-1 do begin
     risorsa_check := download.lista_risorse[h];
       if not risorsa_check.attivato_ip then continue;

       if risorsa_check=risorsa then continue; //non contiamo noi stessi
         if risorsa_check.porta<>risorsa.porta then continue;
         if risorsa_check.ip<>risorsa.ip then continue;
          if risorsa_check.num_fail>=20 then continue; //risorsa scartata da prossimi poll...chissene

          inc(result);
    end;

end;

end;

function source_connect(downloa: Tdownload; risorsa: Trisorsa_download): Boolean;
var
ip_ris: string;
ip_risC: Cardinal;
begin
result := False;

with risorsa do begin

ip_ris := ipint_to_dotstring(ip);
ip_risC := ip;

if ip_ris=vars_global.localip then begin
 if ip_interno=vars_global.LanIPC then begin
  Result := False;
  exit;
 end else ip_ris := ipint_to_dotstring(ip_interno); // devo per forza usare ip interno, sono su stesso NAT fastweb!
end else
if ((ip<>ip_interno) and (ip_interno<>0)) then begin
    if ((has_tried_extIP) and (not failed_ipint)) then begin  //con meno di tre tentativi ip interno falliti posso ancora provare
       //if random(100)>50 then
       ip_ris := ipint_to_dotstring(ip_interno); // uno e uno
       ip_risC := ip_interno;
    end;
end else has_tried_extIP := True;


attivato_ip := True;
state := srs_connecting;
out_buf := '';
progress := 0;
queued_position := 0;

socket := ttcpblocksocket.create(true);
 socket.buffstr := '';


 tick_attivazione := gettickcount;  // per controllo connessione    timeout 15 sec
 if ip_risC=ip_interno then begin
   if ip_interno<>ip then begin
     socket.SocksIP := '';
     socket.SocksPort := '0';
   end;
 end else assign_proxy_settings(socket);

  socket.ip := ip_ris;
  socket.port := risorsa.porta;
  socket.Connect(ip_ris,inttostr(porta));

  
end;

result := True;

end;


procedure out_http_get_req_str(var destinationStr: string; download: Tdownload; risorsa: Trisorsa_download);
var
str_want_size_magnet,stringa_stats,statsold,stringa_range,
str_risorse_alt,str,str_mydet,TempStr,skipStr: string;
numero_skip: Byte;
i: Integer;
begin


           if download.size>0 then begin
             str_want_size_magnet := '';
             stringa_stats := encap_new_stat_string(stats_to_str(download,false,true));  //2947+ 26/12/2004 2949 a nuovi client mando vero partecipation level
             stringa_range := chr(16)+CHRNULL+chr(TAG_ARESHEADER_RANGE64)+int_2_Qword_string(risorsa.start_byte)+int_2_Qword_string(risorsa.end_byte); //2951+
           end else begin
            stringa_stats := '';
            if risorsa.piece=nil then str_want_size_magnet := chr(1)+CHRNULL+chr(TAG_ARESHEADER_XSIZE)+chr(1);
            //chr(8)+CHRNULL+chr(TAG_ARES_HEADER_RANGE32=7)+int_2_dword_string(risorsa.start_byte)+int_2_dword_string(risorsa.end_byte)+
            stringa_range := chr(16)+CHRNULL+chr(TAG_ARESHEADER_RANGE64)+int_2_Qword_string(0)+int_2_Qword_string(0); //2951+
           end;

           str_risorse_alt := helper_altsources.get_altsource_string(download,risorsa,true);
           str_risorse_alt := int_2_word_string(length(str_risorse_alt))+chr(TAG_ARESHEADER_ALTSSRC)+str_risorse_alt;

           str_mydet := helper_ipfunc.serialize_myConDetails;
           str_mydet := int_2_word_string(length(str_mydet))+chr(TAG_ARESHEADER_HOSTINFO2)+str_mydet;  // NOTE since we don't use TAG#3 we wont receive XQUEUED header but only busy replies (because of old thread_upload code)


     numero_skip := random(16)+1;
      SetLength(skipStr,3);
      skipStr[1] := chr(random(255));
      skipStr[2] := chr(random(255));
      skipStr[3] := chr(numero_skip);
      for i := 1 to numero_skip do skipStr := skipStr+chr(random(255));

          str := chr(1)+ //message type = encrypted get request
               chr(3)+CHRNULL+chr(TAG_ARESHEADER_CRYPTBRANCH)+
                        chr(risorsa.encryption_branch)+int_2_word_string(risorsa.actual_decrypt_key)+

               chr(20)+CHRNULL+chr(TAG_ARESHEADER_WANTEDHASH)+
                         download.hash_sha1+
               str_mydet;

               TempStr := vars_global.mynick;
               str := str+int_2_word_string(length(TempStr))+chr(TAG_ARESHEADER_NICKNAME)+
                        TempStr;

               TempStr := appname+CHRSPACE+vars_global.versioneares;
               str := str+int_2_word_string(length(TempStr))+chr(TAG_ARESHEADER_AGENT)+
                        TempStr;

               str := str+str_want_size_magnet+
                        stringa_stats+
                        stringa_range+
                        str_risorse_alt;

                        
  if risorsa.his_servers.count<2 then begin
   // old servers need ip and port information in order to add downloaders to queue list
   str := str+chr(16)+CHRNULL+chr(TAG_ARESHEADER_HOSTINFO1)+int_2_dword_string(0)+
                                   int_2_word_string(0)+
                                   int_2_dword_string(vars_global.localipC)+
                                   int_2_word_string(vars_global.myport)+
                                   int_2_dword_string(0); 
   // warez p2p appears to parse only old 'xstats' headers, causing peers to remain queued forever
   statsold := stats_to_str(download,false,false);
   str := str+int_2_word_string(length(statsold))+chr(TAG_ARESHEADER_STTSWAREZOLD)+statsold;
  end;


          if length(download.FPieces)=0 then
           if download.FPieceSize>0 then str := Str+chr(1)+CHRNULL+chr(TAG_ARESHEADER_ICHREQ)+chr(1);

        Str := int_2_word_string(length(str))+
             e12(str,16298);
        destinationStr := e3a(SkipStr+Str,23836);
        
end;

function get_out_push_string(hash_sha1: string; randoms: string): string;
var
str,randomstr: string;
numero_skip: Byte;
i,ra: Integer;
begin

ra := random(8)+1;
randomstr := '';
for i := 0 to ra do randomstr := randomstr+chr(random(256));


   numero_skip := random(16)+1;
   SetLength(result,3);
   result[1] := chr(random(255));
   result[2] := chr(random(255));
   result[3] := chr(numero_skip);
   for i := 1 to numero_skip do Result := result+chr(random(255));

          str := chr(2)+ //message type  = encrypted push
               chr(length(randoms))+CHRNULL+chr(1)+randoms+
               chr(20)+CHRNULL+chr(2)+hash_sha1+
               randomstr;

   Result := result+int_2_word_string(length(str))+e12(str,16298);
   Result := e3a(result,23836);

end;

function get_out_privchat_req: string;
var
str: string;
numero_skip: Byte;
i: Integer;
begin

   numero_skip := random(16)+1;
   SetLength(result,3);
   result[1] := chr(random(255));
   result[2] := chr(random(255));
   result[3] := chr(numero_skip);
   for i := 1 to numero_skip do Result := result+chr(random(255));

          str := chr(3)+chr(4)+CHRNULL+chr(1)+int_2_dword_string(0);

   Result := result+int_2_word_string(length(str))+e12(str,16298);
   Result := e3a(result,23836);

end;

function get_out_privchat_pushreq(randoms: string): string;
var
str: string;
numero_skip: Byte;
i: Integer;
begin

   numero_skip := random(16)+1;
   SetLength(result,3);
   result[1] := chr(random(255));
   result[2] := chr(random(255));
   result[3] := chr(numero_skip);
   for i := 1 to numero_skip do Result := result+chr(random(255));

          str := chr(4)+chr(16)+CHRNULL+chr(1)+randoms;

   Result := result+int_2_word_string(length(str))+e12(str,16298);
   Result := e3a(result,23836);

end;


function encap_new_stat_string(stat_string: string): string;   //2948+ 26/12/2004
var
num: Cardinal;
begin
//  BYTE(random)    DWORD(random)    NULL    BYTE(random)    WH(DWORD(random)+21)    PAYLOAD
num := gettickcount;
result := chr(random(255))+
        int_2_dword_string(num)+
        CHRNULL+
        chr(random(255))+
        int_2_word_string(wh(int_2_dword_string(num))+21)+
        stat_string; //<---stat string Ë gi‡ criptata con e2 (bug 2947-2948)

 Result := e64(e67(result,5593),24384);

 Result := int_2_word_string(length(result))+chr(TAG_ARESHEADER_XSTATS1)+
         result;
end;

function stats_to_str(download: Tdownload; isFirewalled: Boolean; isnew:boolean): string;
var
str: string;
prog:double;
progi,num_available: Integer;
begin

try
if download.size>0 then begin
prog := (download.progress / download.size)*100;
progi := trunc(prog);
end else progi := 0;

 str := chr(not integer(vars_global.im_firewalled));

num_available := download.lista_risorse.count;
if num_available>255 then num_available := 255;

 if not isnew then begin
  str := str+int_2_word_string(loc_velocita_up)+  //mia velocit‡ up
           int_2_word_string(speed_down_max div 100)+       //mia velocit‡ down
           chr(num_available)+          //numero sources
           chr({99}progi)+                                  //progresso attuale
           int_2_dword_string(0)+            //minuti et‡ download  download.age
           int_2_dword_string(loc_ksent)+      //k uploadati in questa sessione
           int_2_word_string(loc_muptime)+
           chr(17)+
           int_2_word_string(random(255)+250{loc_files_condivisi})+
           chr(random(10)+5{loc_numero_uploads})+
           chr(0{numero_down})+
           chr(255{ex_loc_pl}); //calcolato in gestisci stats  //checksum :)                     // media uptime, Ë uno zingaro?

       Result := e2(str,45876);  //encrypt and INTTOHEX
 end else begin
  str := str+int_2_word_string(loc_velocita_up)+  //mia velocit‡ up
           int_2_word_string(speed_down_max div 100)+       //mia velocit‡ down
           chr(num_available)+          //numero sources
           chr(progi)+                                  //progresso attuale
           int_2_dword_string(download.speed)+            //minuti et‡ download  download.age  diventa velocit‡ da 2957+
           int_2_dword_string(loc_ksent)+      //k uploadati in questa sessione
           int_2_word_string(loc_muptime)+
           chr(17)+
           int_2_word_string(loc_files_condivisi)+
           chr(10{loc_numero_uploads})+
           chr(1{loc_numero_down})+
           chr(255{ex_loc_pl}); //calcolato in gestisci stats  //checksum :)                     // media uptime, Ë uno zingaro?

       Result := e2(str,45876);  //encrypt and INTTOHEX
 end;

except
end;
end;

function stats_to_str(download: Tdownload): string;
var
prog:double;
progi,num_available: Integer;
begin

try
if download.size>0 then begin
prog := (download.progress / download.size)*100;
progi := trunc(prog);
end else progi := 0;

num_available := download.lista_risorse.count;
if num_available>255 then num_available := 255;

result := chr(not integer(vars_global.im_firewalled))+
        int_2_word_string(loc_velocita_up)+  //mia velocit‡ up
        int_2_word_string(speed_down_max div 100)+       //mia velocit‡ down
        chr(num_available)+          //numero sources
        chr(progi)+                                  //progresso attuale
        int_2_dword_string(download.speed)+            //minuti et‡ download  download.age  diventa velocit‡ da 2957+
        int_2_dword_string(loc_ksent)+      //k uploadati in questa sessione
        int_2_word_string(loc_muptime)+
        chr(17)+
        int_2_word_string(loc_files_condivisi)+
        chr(10{loc_numero_uploads})+
        chr(1{loc_numero_down})+
        chr(255{ex_loc_pl});
except
end;
end;


function duplicate_source_nickname(risorsa: Trisorsa_download): Boolean;
var         //2963 per prevenire lame attacchi 'sexytime' evitiamo in toto duplicati nickname
download: Tdownload;
i,len: Integer;
ris: Trisorsa_download;
fname: string;
begin
result := False;
try


download := risorsa.download;
len := length(risorsa.nickname);
fname := lowercase(risorsa.nickname);

for i := 0 to download.lista_risorse.count-1 do begin
 ris := download.lista_risorse[i];
  //if ris.stato<>STATO_RECEIVING then
   //if ris.queued_position=0 then continue;

   if ris=risorsa then continue; //questo non dovrebbe mai capitare, perchË chiamiamo appena prima di diventare receiving
    //if ris.porta<>risorsa.porta then continue;
    if len<>length(risorsa.nickname) then continue;

     if lowercase(ris.nickname)=fname then begin
      Result := True;
      exit;
    end;
end;

except
end;
end;


function handle_to_download(down_handle: Cardinal): Tdownload;
var
i: Integer;
download: Tdownload;
begin
result := nil;

 for i := 0 to lista_download.count-1 do begin
   download := lista_download[i];
    if cardinal(download)=down_handle then begin
     Result := download;
     break;
    end;
 end;

end;

function source_startbyte_assign(download: Tdownload; risorsa: Trisorsa_download): Boolean;
var
i,ran: Integer;
piece: TDownloadPiece;
found: Boolean;
thisPieceSize: Int64;
begin
result := False;

// IDLE download
if not isDownloadActive(download) then exit;

if download.size=0 then begin  //hashlink
 risorsa.start_byte := 0;
 risorsa.end_byte := 2;
 risorsa.global_size := (risorsa.end_byte-risorsa.start_byte)+1;
 Result := True;
 exit;
end;

if download.FPieceSize=0 then begin // small files (without ICH) always have this
 risorsa.start_byte := download.progress;
 risorsa.end_byte := (download.size-download.progress)-1;
 risorsa.global_size := (risorsa.end_byte-risorsa.start_byte)+1;
 Result := True;
 exit;
end;


// we don't have ICH checksums yet
if length(download.FPieces)=0 then exit;


// if it's an AVI we try to get first chunk (containing headers) and idx1 data in order to make preview simpler)
if download.aviHeaderState=aviStateIsAvi then
 if download.AviIDX1At>0 then
   for i := high(download.FPieces) downto 0 do begin
    piece := download.FPieces[i];

    thisPieceSize := download.FPieceSize;
    if piece.FOffset+thisPieceSize>=download.size then thisPieceSize := download.size-piece.FOffset;

    if piece.FOffset+thisPieceSize<int64(download.AviIDX1At) then break; // we already have idx1
     if piece.FInUse then continue;
      if piece.FDone then continue;

       risorsa.start_byte := piece.FOffset+int64(piece.FProgress);
       risorsa.end_byte := (risorsa.start_byte+(int64(download.FPieceSize)-int64(piece.FProgress)))-1;
       if risorsa.end_byte>=download.size then risorsa.end_byte := download.size-1;
       risorsa.global_size := (risorsa.end_byte-risorsa.start_byte)+1;
       risorsa.piece := piece;
       piece.FInUse := True;

       Result := True;
       exit;
   end;


// first get pieces half completed
for i := 0 to high(download.FPieces) do begin
 piece := download.FPieces[i];
 if piece.FInUse then continue;
  if piece.FDone then continue;
   if piece.FProgress=0 then continue;

    risorsa.start_byte := piece.FOffset+int64(piece.FProgress);
    risorsa.end_byte := (risorsa.start_byte+(int64(download.FPieceSize)-int64(piece.FProgress)))-1;
    if risorsa.end_byte>=download.size then risorsa.end_byte := download.size-1;
    risorsa.global_size := (risorsa.end_byte-risorsa.start_byte)+1;
    risorsa.piece := piece;
    piece.FInUse := True;

    Result := True;
    exit;
end;



// try to get the first piece  (preview)
 piece := download.FPieces[0];
if not piece.FInUse then
 if not piece.FDone then begin
  risorsa.start_byte := piece.FOffset+int64(piece.FProgress);
  risorsa.end_byte := (risorsa.start_byte+(int64(download.FPieceSize)-int64(piece.FProgress)))-1;
  if risorsa.end_byte>=download.size then risorsa.end_byte := download.size-1;
  risorsa.Global_size := (risorsa.end_byte-risorsa.start_byte)+1;
  risorsa.piece := piece;
  piece.FInUse := True;

  Result := True;
  exit;
 end;
 


// try to get the last 3 pieces  (AVI preview)
if download.tipo=ARES_MIME_VIDEO then
 for i := high(download.FPieces) downto 0 do begin
  if i<high(download.FPieces)-2 then break;

  piece := download.FPieces[i];

  if piece.FInUse then continue;
  if piece.FDone then continue;

   risorsa.start_byte := piece.FOffset+int64(piece.FProgress);
   risorsa.end_byte := (risorsa.start_byte+(int64(download.FPieceSize)-int64(piece.FProgress)))-1;
   if risorsa.end_byte>=download.size then risorsa.end_byte := download.size-1;
   risorsa.Global_size := (risorsa.end_byte-risorsa.start_byte)+1;
   risorsa.piece := piece;
   piece.FInUse := True;

   Result := True;
   exit;
 end;





// get the first empty chunk
ran := random(high(download.FPieces)+1);

found := False;
for i := ran to high(download.FPieces) do begin
 piece := download.FPieces[i];
 if piece.FInUse then continue;
  if piece.FDone then continue;
  found := True;
  break;
end;

if not found then begin // if we din't make it before, go backward
  for i := ran downto 0 do begin
   piece := download.FPieces[i];
   if piece.FInUse then continue;
    if piece.FDone then continue;
    found := True;
    break;
   end;
end;

if not found then exit;


 risorsa.start_byte := piece.FOffset+int64(piece.FProgress);
 risorsa.end_byte := (risorsa.start_byte+int64(download.FPieceSize))-1;
 if risorsa.end_byte>=download.size then risorsa.end_byte := download.size-1;
 risorsa.global_size := (risorsa.end_byte-risorsa.start_byte)+1;

 risorsa.piece := piece;
 piece.FInUse := True;

 Result := True;

end;

function partial_is_chunkavailable(download: Tdownload; startp: Int64; endp: Int64): Boolean;
var
i,strIdx: Integer;
piece: TDownloadPiece;
pieceEnd: Int64;
begin
result := False;

if length(download.FPieces)=0 then exit; //no ICH

strIdx := (endp div download.FPieceSize)+2;
if strIdx>high(download.FPieces) then strIDx := high(download.FPieces);

for i := strIdx downto 0 do begin
 piece := download.FPieces[i];
 if piece.FOffset>startp then continue;

  if not piece.FDone then exit;

    if piece.FOffset+int64(download.FPieceSize)>download.size then pieceEnd := (download.size-piece.FOffset)-1
     else pieceEnd := (piece.FOffSet+download.FPieceSize)-1;

     Result := (pieceEnd>=endp);

  Break;
 end;

end;

function get_queued_str(posit:integer): WideString;
begin
if posit<102 then Result := GetLangStringW(STR_QUEUED_STATUS)+' ('+inttostr(posit)+')' else
 case posit of
  103: Result := GetLangStringW(STR_BUSY)+chr(32)+chr(40)+'MaxIP'+chr(41);
  104: Result := GetLangStringW(STR_BUSY)+chr(32)+chr(40)+'Leech'+chr(41);
   else Result := GetLangStringW(STR_BUSY);
 end;
end;

function downloadstate_to_byte(state: TDownloadState): Byte;
begin
  case state of
   dlSeeding: Result := 0;
   dlCompleted: Result := 1;
   dlRebuilding: Result := 2;
   dlDownloading: Result := 3;
   dlUploading: Result := 4;
   dlQueuedSource: Result := 5;  // sorting sources
   dlProcessing: Result := 6;
   dlPaused: Result := 7;
   dlLeechPaused: Result := 8;
   dlLocalPaused: Result := 9;
   dlCancelled: Result := 10
    else Result := 11;
  end;
end;

function sourcestate_to_byte(DsData:precord_displayed_downloadsource): Byte;
begin
result := 0;

 case DsData^.state of
  srs_receivingICH: Result := 0;
  srs_receiving: Result := 0;
  srs_UDPDownloading: Result := 0;
  srs_UDPreceivingICH: Result := 0;

  srs_ReceivingReply: Result := 1;
  srs_connected: Result := 1;
  srs_connecting: Result := 1;
  srs_readytorequest: Result := 1;

  srs_waitingPush: Result := 1;
  srs_TCPpushing: Result := 1;
  srs_waitingIcomingConnection: Result := 1;
  srs_waitingForUserUdpAck: Result := 1;
  srs_UDPpushing: Result := 1;
  srs_waitingForUserUDPPieceAck: Result := 1;

  srs_idle:if DsData^.queued_position=0 then Result := 1
            else Result := 1;
  srs_paused: Result := 2;
 end;
end;

function SourceStateToStrW(DsData:precord_displayed_downloadsource): WideString;
begin

 case DsData^.State of
   srs_paused: Result := GetLangStringW(STR_PAUSED);
   srs_idle:begin
           if DsData^.queued_position>0 then begin
             if DsData^.queued_position=102 then Result := GetLangStringW(STR_BUSY)
              else
               if DsData^.queued_position=103 then Result := GetLangStringW(STR_BUSY)+' (MaxIP)'
                else
                 if DsData^.queued_position=104 then Result := GetLangStringW(STR_BUSY)+' (Leech)'
                  else
                   Result := GetLangStringW(STR_QUEUED_STATUS)+' ('+inttostr(DsData^.queued_position)+')';
           end else Result := GetLangStringW(STR_IDLE);
       end;
   srs_connecting: Result := GetLangStringW(STR_CONNECTING);
   srs_receiving,
   srs_UDPDownloading: Result := GetLangStringW(STR_DOWNLOADING);
   srs_waitingPush: Result := GetLangStringW(STR_PUSHING);
   srs_TCPpushing: Result := GetLangStringW(STR_PUSHING)+'(TCP)';
   srs_UDPpushing: Result := GetLangStringW(STR_PUSHING)+'(UDP)';
   srs_waitingForUserUdpAck: Result := GetLangStringW(STR_WAITINGFORPEERACK)+'(UDP)';
   srs_waitingIcomingConnection: Result := GetLangStringW(STR_WAITINGFORPEERACK)+'(TCP)';
   srs_connected: Result := GetLangStringW(STR_REQUESTING);
   srs_ReceivingReply,
   srs_readytorequest,
   srs_waitingForUserUDPPieceAck: Result := GetLangStringW(STR_REQUESTING);
   srs_receivingICH,
   srs_UDPreceivingICH: Result := GetLangStringW(STR_DOWNLOADING)+'(ICH)';
 end;
end;

function downloadStatetoStrW(BtData:precord_displayed_bittorrentTransfer): WideString;
begin
case BtData^.state of
   dlBittorrentMagnetDiscovery: Result := GetLangStringW(STR_SEARCHING);
   dlSeeding: Result := 'Seeding';
   dlAllocating: Result := GetLangStringW(STR_SEARCHING);
   dlFinishedAllocating: Result := GetLangStringW(STR_SEARCHING);
   dlCompleted,
   dlRebuilding,
   dlJustCompleted: Result := GetLangStringW(STR_COMPLETED);
   dlDownloading: Result := GetLangStringW(STR_DOWNLOADING);
   dlUploading: Result := GetLangStringW(STR_UPLOADING);
   dlQueuedSource: Result := GetLangStringW(STR_BUSY);  //solo per sorting sources
   dlProcessing:if BtData^.num_Sources>0 then Result := GetLangStringW(STR_CONNECTING)
                 else Result := GetLangStringW(STR_SEARCHING);
   dlPaused: Result := GetLangStringW(STR_PAUSED);
   dlLeechPaused: Result := GetLangStringW(STR_LEECH_PAUSED);
   dlLocalPaused: Result := GetLangStringW(STR_LOCAL_PAUSED);
   dlCancelled: Result := GetLangStringW(STR_CANCELLED);
   dlFileError:if BtData^.ercode<15800 then Result := GetLangStringW(STR_ERROR_FILELOCKED)+' ('+inttostr(BtData^.ercode)+')'
                else Result := GetLangStringW(STR_ERROR_FILECORRUPTED)+' ('+inttostr(BtData^.ercode)+')';
  end;
end;

function downloadStatetoStrW(DnData:precord_displayed_download): WideString;
begin
  case DnData^.state of
   dlAllocating: Result := GetLangStringW(STR_SEARCHING);
   dlFinishedAllocating: Result := GetLangStringW(STR_SEARCHING);
   dlCompleted,
   dlRebuilding,
   dlJustCompleted: Result := GetLangStringW(STR_COMPLETED);
   dlDownloading: Result := GetLangStringW(STR_DOWNLOADING);
   dlUploading: Result := GetLangStringW(STR_UPLOADING);
   dlQueuedSource: Result := GetLangStringW(STR_BUSY);  //solo per sorting sources
   dlProcessing:if DnData^.num_Sources>0 then Result := GetLangStringW(STR_CONNECTING)
                 else Result := GetLangStringW(STR_SEARCHING);
   dlPaused: Result := GetLangStringW(STR_PAUSED);
   dlLeechPaused: Result := GetLangStringW(STR_LEECH_PAUSED);
   dlLocalPaused: Result := GetLangStringW(STR_LOCAL_PAUSED);
   dlCancelled: Result := GetLangStringW(STR_CANCELLED);
   dlFileError:if DnData^.ercode<15800 then Result := GetLangStringW(STR_ERROR_FILELOCKED)+' ('+inttostr(DnData^.ercode)+')'
                else Result := GetLangStringW(STR_ERROR_FILECORRUPTED)+' ('+inttostr(DnData^.ercode)+')';
  end;
end;

function calc_netx_end(punto: Int64; dimensione_chunks: Cardinal; size: Int64): Int64;
begin
result := punto+(dimensione_chunks-1);
if result+1>size then Result := size-1;
end;

function start_download(datao:precord_file_library; folder: WideString): Tdownload;
begin
try

result := tdownload.create;
helper_download_misc.seek_suitable_filename(extractfilename(datao^.path),
                                            utf8strtowidestr(datao^.title),
                                            utf8strtowidestr(datao^.artist),
                                            utf8strtowidestr(datao^.album),
                                            result);

with Result do begin
 in_subfolder := widestrtoutf8str(folder);
 hash_sha1 := datao^.hash_sha1;
 crcsha1 := crcstring(datao^.hash_sha1);
 tipo := datao^.amime;
 size := datao^.fsize;
 param1 := datao^.param1;
 param2 := datao^.param2;
 param3 := datao^.param3;
 title := datao^.title;
 artist := datao^.artist;
 album := datao^.album;
 category := datao^.category;
 date := datao^.year;
 language := datao^.language;
 url := datao^.url;
 comments := datao^.comment;
 keyword_genre := datao^.keywords_genre;
 AddVisualReference;
end;

exit;

except
end;
result := nil;
end;

procedure seek_suitable_filename(filename: string; const title,artist,album: WideString; download: TDownload);
var
ext: string;
nomefile,aggiunta: WideString;
r: Integer;
begin
nomefile := utf8strtowidestr(filename);

ext := lowercase(extractfileext(filename));
if ((length(ext)>10) or (length(ext)<1)) then ext := '.raw';

nomefile := normalizza_nomefile(nomefile);
nomefile := strip_incomplete(nomefile);


if nomefile='' then begin
 if ((length(album)>0) and (length(title)>0) and (length(artist)>0)) then nomefile := artist+' - '+album+chr(32)+chr(45)+chr(32){' - '}+title else
 if ((length(title)>0) and (length(artist)>0)) then nomefile := artist+' - '+title else
 nomefile := title;
end else nomefile := copy(nomefile,1,length(nomefile)-length(ext));

tntwindows.Tnt_createdirectoryW(pwidechar(myshared_folder),nil);
aggiunta := '';
r := 2;
repeat
if ((not fileexistsW(myshared_folder+'\'+nomefile+aggiunta+ext)) and
    (not fileexistsW(myshared_folder+'\___ARESTRA___'+nomefile+aggiunta+ext))) then break;
aggiunta := '('+inttostr(r)+')';
inc(r);
until (not true);

download.filename := widestrtoutf8str(myshared_folder+'\___ARESTRA___'+nomefile+aggiunta+ext);
download.tipo := helper_mimetypes.extstr_to_mediatype(ext);
if download.tipo<>ARES_MIME_VIDEO then download.aviHeaderState := aviStateNotAvi;
end;

function start_download(datao:precord_search_result): Tdownload;
begin
try

result := tdownload.create;
helper_download_misc.seek_suitable_filename(datao^.filenameS,
                                            utf8strtowidestr(datao^.title),
                                            utf8strtowidestr(datao^.artist),
                                            utf8strtowidestr(datao^.album),
                                            result);

with Result do begin
 hash_of_phash := datao^.hash_of_phash;
 hash_sha1 := datao^.hash_sha1;
 crcsha1 := crcstring(datao^.hash_sha1);
 tipo := datao^.amime;
 size := datao^.fsize;
 param1 := datao^.param1;
 param2 := datao^.param2;
 param3 := datao^.param3;
 title := datao^.title;
 artist := datao^.artist;
 album := datao^.album;
 category := datao^.category;
 date := datao^.year;
 language := datao^.language;
 url := datao^.url;
 comments := datao^.comments;
 keyword_genre := datao^.keyword_genre;
 AddVisualReference;
end;

exit; //

except
end;
result := nil; //altrimenti ÅEnil
end;



end.
