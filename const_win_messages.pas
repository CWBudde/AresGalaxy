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
 custom and well known message consts
}

unit const_win_messages;

interface

uses
 windows;

const
  WM_NCPAINT                             =          $0085;
  WM_SYSCOMMAND                          =          $0112;
  WM_USER                                =          $0400;
  WM_CLOSE                               =          $0010;
  WM_DROPFILES                           =          $0233;
  WM_ACTIVATE                            =          $0006;
  WM_COPYDATA                            =          $004A;
  MM_MCINOTIFY                           =          $3B9;
  WM_THREADSEARCHDIR_END                 =          WM_USER+2;
  WM_USERSHOW                            =          WM_USER+3;
  WM_THREAD_PRIVCHAT_END                 =          wm_user+15;
  WM_PRIVCHAT_SHOWTRANVIEW               =          wm_user+19;
  WM_USER_QUIT                           =          WM_USER+43;
  WM_PREVIEW_START                       =          WM_USER+143;
  WM_PRIVATECHAT_EVENT                   =          WM_USER+144;
  WM_THREADSHARE_END                     =          WM_USER+147;
  WM_THREADCHATSERVER_END                =          WM_USER+148;
  WM_THREADCHATCLIENT_END                =          WM_USER+149;
  WM_ADDSKIN                             =          WM_USER+150;
  WM_TERMINATECHAT                       =          WM_USER+151;
  WM_SHOWCHATCHAT                        =          WM_USER+152;
  WM_ERASEBKGND                          =          $0014;
  WM_UPDATEUISTATE                       =          $0128;

  SC_MYMAXIMIZE = WM_USER+200;
  SC_MYMINIMIZE = WM_USER+201;
  SC_MYCLOSE    = WM_USER+202;
  SC_MYRESTORE  = WM_USER+203;

implementation

end.
