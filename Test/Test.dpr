program Test;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form3},
  BDecode in '..\BitTorrent\BDecode.pas',
(*
  BitTorrentConst in '..\BitTorrent\BitTorrentConst.pas',
  BitTorrentStringfunc in '..\BitTorrent\BitTorrentStringfunc.pas',
  BitTorrentUtils in '..\BitTorrent\BitTorrentUtils.pas',
*)
  dht_consts in '..\BitTorrent\dht_consts.pas',
  dht_int160 in '..\BitTorrent\dht_int160.pas',
  dht_routingbin in '..\BitTorrent\dht_routingbin.pas',
  dht_search in '..\BitTorrent\dht_search.pas',
  dht_searchManager in '..\BitTorrent\dht_searchManager.pas',
  dht_socket in '..\BitTorrent\dht_socket.pas',
  dht_zones in '..\BitTorrent\dht_zones.pas',
  hashes in '..\BitTorrent\hashes.pas',
  thread_bitTorrent in '..\BitTorrent\thread_bitTorrent.pas',
  torrentparser in '..\BitTorrent\torrentparser.pas',
  helper_datetime in '..\helper_datetime.pas',
  const_ares in '..\const_ares.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

