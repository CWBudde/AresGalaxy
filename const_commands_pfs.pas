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
partial file sharing commands
}


unit const_commands_pfs;

interface

const

 CMD_PARTIAL_SENDME_HASH                     = 1;
 CMD_PARTIAL_IGOT_HASH                       = 2;
 CMD_PARTIAL_SENDME_CHUNK_8B                 = 13; //ex 3
 CMD_PARTIAL_BUSY                            = 14;
 CMD_PARTIAL_GOTO_CHILD                      = 4; //deprecated
 CMD_PARTIAL_MISSING_CHUNK                   = 5;
 CMD_PARTIAL_HERE_DATA                       = 6;
 CMD_PARTIAL_ALLOCATE_THIS_8B                = 17; //ex 7
 CMD_PARTIAL_HERE_MY_XIP                     = 8;
 CMD_PARTIAL_IMNOW_REGULARSOURCE             = 10;
 CMD_PARTIAL_HERE_DATA_8B                    = 12;
 CMD_PARTIAL_IMSLOW                          = 18;
 CMD_PARTIAL_BITFIELD                        = 20;

implementation

end.
