unit ufrmabout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TntStdCtrls;

type
  Tfrmabout = class(TForm)
    lbl_opt_gen_and: TLabel;
    lbl_opt_gen_eula: TLabel;
    lbl_opt_gen_privacy: TLabel;
    lbl_opt_homepage: TLabel;
    Image1: TImage;
    TntButton1: TTntButton;
    label_version: TLabel;
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbl_opt_homepageClick(Sender: TObject);
    procedure lbl_opt_homepageMouseLeave(Sender: TObject);
    procedure lbl_opt_homepageMouseEnter(Sender: TObject);
    procedure lbl_opt_gen_privacyClick(Sender: TObject);
    procedure lbl_opt_gen_eulaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TntButton1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmabout: Tfrmabout;

implementation

uses
 utility_ares,const_ares,ufrmmain;

{$R *.dfm}

procedure Tfrmabout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action := caFree;
end;

procedure Tfrmabout.lbl_opt_homepageMouseLeave(Sender: TObject);
begin
(sender as TLabel).font.style := [];
end;

procedure Tfrmabout.lbl_opt_homepageMouseEnter(Sender: TObject);
begin
(sender as TLabel).font.style := [fsUnderline];
end;

procedure Tfrmabout.lbl_opt_homepageClick(Sender: TObject);
begin
utility_ares.browser_go(STR_DEFAULT_WEBSITE);
end;

procedure Tfrmabout.lbl_opt_gen_privacyClick(Sender: TObject);
begin
utility_ares.browser_go(STR_PRIVACYPOLICY_WEBSITE);
end;

procedure Tfrmabout.lbl_opt_gen_eulaClick(Sender: TObject);
begin
utility_ares.browser_go(STR_EULA_WEBSITE);
end;

procedure Tfrmabout.FormShow(Sender: TObject);
begin
lbl_opt_homepage.caption := const_ares.STR_DEFAULT_WEBSITE;
label_version.caption := 'You are running Ares version '+const_ares.ARES_VERS;
//image1.Picture := imgscnlogo.Picture;
end;

procedure Tfrmabout.TntButton1Click(Sender: TObject);
begin
close;
end;

procedure Tfrmabout.FormDeactivate(Sender: TObject);
begin
close;
end;

end.
