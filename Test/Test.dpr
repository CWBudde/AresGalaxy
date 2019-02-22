program Test;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form3},
  BDecode in '..\BitTorrent\BDecode.pas',
  classes2 in '..\classes2.pas',
  dht_consts in '..\BitTorrent\dht_consts.pas',
  dht_search in '..\BitTorrent\dht_search.pas',
  dht_searchManager in '..\BitTorrent\dht_searchManager.pas',
  dht_socket in '..\BitTorrent\dht_socket.pas',
  dht_zones in '..\BitTorrent\dht_zones.pas',
  hashes in '..\BitTorrent\hashes.pas',
  thread_bitTorrent in '..\BitTorrent\thread_bitTorrent.pas',
  torrentparser in '..\BitTorrent\torrentparser.pas',
  helper_datetime in '..\helper_datetime.pas',
  const_ares in '..\const_ares.pas',
  dht_int160 in '..\BitTorrent\dht_int160.pas',
  helper_strings in '..\helper_strings.pas',
  ares_types in '..\ares_types.pas',
  ares_types_root in '..\ares_types_root.pas',
  helper_urls in '..\helper_urls.pas',
  helper_unicode in '..\helper_unicode.pas',
  helpeR_ipfunc in '..\helpeR_ipfunc.pas',
  helper_crypt in '..\helper_crypt.pas',
  securehash in '..\securehash.pas',
  umediar in '..\umediar.pas',
  helper_diskio in '..\helper_diskio.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

