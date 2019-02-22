{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )
}

unit AsyncExTypes;

(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Copyright (C) 2004 - 2006 Martin Offenwanger                             *
 *  Mail: coder@dsplayer.de                                                  *
 *  Web:  http://www.dsplayer.de                                             *
 *                                                                           *
 *  This Program is free software; you can redistribute it and/or modify     *
 *  it under the terms of the GNU General Public License as published by     *
 *  the Free Software Foundation; either version 2, or (at your option)      *
 *  any later version.                                                       *
 *                                                                           *
 *  This Program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the             *
 *  GNU General Public License for more details.                             *
 *                                                                           *
 *  You should have received a copy of the GNU General Public License        *
 *  along with GNU Make; see the file COPYING.  If not, write to             *
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.    *
 *  http://www.gnu.org/copyleft/gpl.html                                     *
 *                                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
{
@author(Martin Offenwanger: coder@dsplayer.de)
@created(Apr 22, 2004)
@lastmod(Apr 02, 2005)
}

interface

uses ActiveX;

const
  AsyncExFileName = 'AsyncEx.ax';
  AsyncExFilterID = 'AsyncEx';
  AsyncExPinID = 'StreamOut';
  CLSID_AsyncEx: TGUID = '{3E0FA044-926C-42d9-BA12-EF16E980913B}';
  IID_AsyncExControl: TGUID = '{3E0FA056-926C-43d9-BA18-EF16E980913B}';
  IID_AsyncExCallBack: TGUID = '{3E0FB667-956C-43d9-BA18-EF16E980913B}';
  PinID = 'StreamOut';
  FilterID = 'AsyncEx';
  
type
  IAsyncExCallBack = interface(IUnknown)
    ['{3E0FB667-956C-43d9-BA18-EF16E980913B}']
    function AsyncExFilterState(Buffering: LongBool; PreBuffering: LongBool; Connecting: LongBool; Playing: LongBool; BufferState: integer): HRESULT; stdcall;
    function AsyncExICYNotice(IcyItemName: PChar; ICYItem: PChar): HRESULT; stdcall;
    function AsyncExMetaData(Title: PChar; URL: PChar): HRESULT; stdcall;
    function AsyncExSockError(ErrString: PChar): HRESULT; stdcall;
  end;

  IAsyncExControl = interface(IUnknown)
    ['{3E0FA056-926C-43d9-BA18-EF16E980913B}']
    function SetLoadFromStream(Stream: IStream; Length: int64): HRESULT; stdcall;
    function SetConnectToIp(Host: PChar; Port: PChar; Location: PChar; AgentName:pchar): HRESULT; stdcall;
    function SetConnectToURL(URL: PChar; AgentName:pchar): HRESULT; stdcall;
    function SetBuffersize(BufferSize: integer): HRESULT; stdcall;
    function GetBuffersize(out BufferSize: integer): HRESULT; stdcall;
    function SetRipStream(Ripstream: LongBool; Path: PwideChar; Filename: PwideChar): HRESULT; stdcall;
    function GetRipStream(out Ripstream: LongBool; out FileO: PwideChar): HRESULT; stdcall;
    function SetCallBack(CallBack: IAsyncExCallBack): HRESULT; stdcall;
    function FreeCallback(): HRESULT; stdcall;
    function ExitAllLoops(): HRESULT; stdcall;
  end;

implementation

end.

