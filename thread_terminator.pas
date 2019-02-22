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
if anything goes wrong don't leave Ares running(freezed) in taskmanager
}

unit thread_terminator;

interface
uses classes,windows,tntwindows;

  type
  tthread_terminator = class(tthread)
  protected
  procedure execute; override;
  private
  ffast: Boolean;
  public
   property fast:boolean read ffast write ffast default False;
  end;

implementation

procedure tthread_terminator.execute;
var
i: Byte;
id:hwnd;
code: Cardinal;
begin
freeonterminate := True;
priority := tphighest;
code := 0;

 if not ffast then begin

  i := 0;
  while (i<60) do begin
  if not terminated then sleep(500) else break;
  inc(i);
  end;

 end else i := 60;

 if i>=59 then begin
 try
  id := getcurrentprocess;
  while not terminateprocess(id,code) do sleep(10);
  except
  end;
 end else freeonterminate := False;
 
end;

end.
