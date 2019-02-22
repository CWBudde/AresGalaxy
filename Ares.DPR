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
init application, get commandline params(any magnet URI?), look for concurrent instances
}

program Ares;

uses
  FastMM4 in 'FastMM4.pas',
  tntforms,
  Forms,
  windows,
  sysutils,
  ares_objects in 'ares_objects.pas',
  vars_global in 'vars_global.pas',
  helper_unicode in 'helper_unicode.pas',
  helper_params in 'helper_params.pas',
  ufrmmain in 'ufrmmain.pas' {ares_frmmain},
  ufrmhint in 'ufrmhint.pas' {frmhint},
  uctrvol in 'uctrvol.pas' {frmctrlvol},
  ufrmpreview in 'ufrmpreview.pas' {frmpreview},
  const_win_messages in 'const_win_messages.pas',
  const_ares in 'const_ares.pas',
  uWhatImListeningTo in 'uWhatImListeningTo.pas',
  uplaylistfrm in 'uplaylistfrm.pas' {PlaylistForm},
  ufrm_settings in 'ufrm_settings.pas' {frm_settings},
  ufrmabout in 'ufrmabout.pas' {frmabout};

{$R *.res}
//{$E .exe}
//{$R ares.RES}

const
 STR_ARES_GLBMTX='AresGlbMtx_';

var
 adata,buf:string;
 p:pointer;
 hGlobalMutex:hwnd;
 ARES_GLOBAL_MUTEX_NAME:string;


Function GetUsrName:string;
Var
   UserName : string;
   UserNameLen : Dword;
Begin
   UserNameLen := 255;
   SetLength(userName, UserNameLen) ;
   If GetUserName(PChar(UserName), UserNameLen) Then Result := Copy(UserName,1,UserNameLen - 1)
    else Result := STR_UNKNOWNS;
End;

procedure DoneApplication;
begin
  with Application do
  begin
    if Handle <> 0 then ShowOwnedPopups(Handle, False);
    ShowHint := False;
    Destroying;
    DestroyComponents;
  end;
end;

begin
IsMultiThread:=True;

 ARES_GLOBAL_MUTEX_NAME:=STR_ARES_GLBMTX+GetUsrName;
hGlobalMutex:=OpenMutex(SYNCHRONIZE,FALSE,pchar(ARES_GLOBAL_MUTEX_NAME));

if hGlobalMutex<>0  then begin

  CloseHandle(hGlobalMutex);

       adata:='';
       if WideParamCount=1 then adata:=widestrtoutf8str(Wideparamstr(1)) else
       if WideParamCount=2 then adata:=widestrtoutf8str(Wideparamstr(2));

  if length(adata)>0 then begin
    if length(adata)>512 then delete(adata,513,length(adata));
    setlength(buf,512);
    fillchar(buf[1],512,0);
    move(adata[1],buf[1],length(adata));

   vars_global.glob_shared_mem:=tsharedmemory.create;
   vars_global.glob_shared_mem.OpenMap;


    vars_global.glob_shared_mem.LockMap;
     p:=pointer(cardinal(vars_global.glob_shared_mem.PMapData));
     copymemory(p, @buf[1], 512);
    vars_global.glob_shared_mem.unLockMap;

   sleep(500); // enough time to create form?
   vars_global.glob_shared_mem.CloseMap;
   vars_global.glob_shared_mem.free;
   adata:='';
  end;

  ARES_GLOBAL_MUTEX_NAME:='';
  exit;

end else begin

    hGlobalMutex:=CreateMutex(nil,TRUE,pchar(ARES_GLOBAL_MUTEX_NAME));

     vars_global.glob_shared_mem:=tsharedmemory.create;
     vars_global.glob_shared_mem.OpenMap;

    try

    application.Initialize;
    application.Title:=' Ares ';
    application.ShowMainForm:=false;
    Application.CreateForm(Tares_frmmain, ares_frmmain);
  application.run;
       
    except
    end;

    vars_global.glob_shared_mem.CloseMap;
    vars_global.glob_shared_mem.free;

    ReleaseMutex(hGlobalMutex);
    CloseHandle(hGlobalMutex);
    ARES_GLOBAL_MUTEX_NAME:='';


  end;


end.
