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
manual configuration of shared folders, visual component called 'mfolder' in the main GUI
}

unit helper_manual_share;

interface

uses
 comettrees,classes,classes2,windows,sysutils,ares_types,
 forms,controls,ufrm_settings;

  const
  STATO_NOT_CHECKED     = 0;
  STATO_CHECKED         = 1;
  STATO_GREY_CHECKED    = 2;
  WORKSTATION_ICON      = 0;
  DRIVE_ICON            = 7;
  FOLDER_NORMAL         = 1;
  FOLDER_SELECTED       = 4;
  CDROM_ICON            = 10;
  NETWORK_ICON          = 13;

Procedure mfolder_EnumerateFolder(node:PCmtVNode);
procedure mfolder_LoadChecksFromDisk;
procedure mfolder_CheckParentFolder ( node : PCmtVNode );
Procedure mfolder_Init;
procedure mfolder_CheckFolder(node:PCmtVNode);
function mfolder_ProofStates(node : PCmtVNode): Boolean;
function mfolder_CheckSibling(node:PCmtVNode): Boolean;
procedure mfolder_CheckSubFolder ( node : PCmtVNode );
function mfolder_FindNodeInTreeView(StartNode:PCmtVNode; crcpath: Word; path: string) : PCmtVNode;
procedure mfolder_AddSubNodesWithFolder(path: string);
procedure mfolder_add_first_child(node:PCmtVNode);
procedure mainGUI_init_manual_share;
Procedure mfolder_SaveChecksToDisk; //tTreeView


implementation

uses
 ufrmmain,vars_global,helper_share_settings,helper_unicode,
 helper_visual_library,helper_diskio,helper_strings,
 helper_urls,helper_registry,const_ares;


Procedure mfolder_SaveChecksToDisk; //tTreeView
var
  data:ares_types.precord_mfolder;
  node:pCmtVnode;
  prima_cartella:precord_cartella_sharE;
Begin
  prima_cartella := nil;
  try

  // store checked folder
  node := frm_settings.mfolder.getfirst;
  node := frm_settings.mfolder.getnext(node);
  while (node<>nil) do begin
   data := frm_settings.mfolder.getdata(node);
    if data^.stato<>STATO_CHECKED then begin
     node := frm_settings.mfolder.getnext(node);
     continue;
    end;
     helper_share_settings.add_this_shared_folder(prima_cartella,utf8strtowidestr(data^.path));
     node := frm_settings.mfolder.getnext(node);
  end;

   //cancelliamo old

   helper_share_settings.write_to_file_shared_folders(prima_cartella);
   cancella_cartella_per_treeview2(prima_cartella);
   

  except
  end;

End;

procedure mainGUI_init_manual_share;
begin
if frm_settings=nil then exit;
 try
     if frm_settings.mfolder.RootNodeCount=0 then begin
      mfolder_init;
      mfolder_LoadChecksFromDisk;
     end;
 except
 end;
end;

procedure mfolder_add_first_child(node:pCmtVnode);
var
 doserror: Integer;
 searchrec:ares_types.tsearchrecW;
 data,data1:ares_types.precord_mfolder;
 node_new:pCmtVnode;
 nomeutf8: string;
 directory: WideString;
 crcpath: Word;
begin

data := frm_settings.mfolder.getdata(node);

directory := utf8strtowidestr(data^.path);

     try
      DosError := helper_diskio.FindFirstW(directory+'\'+const_ares.STR_ANYFILE_DISKPATTERN, faAnyFile, SearchRec);
      while DosError=0 do begin

       if (SearchRec.attr and faDirectory)=0 then begin  //non e directory continuiamo...
        DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
        continue;
       end;

       if ((SearchRec.name='.') or
           (SearchRec.name='..')) then begin
                 DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
                 continue;
       end;

           nomeutf8 := data^.path+'\'+widestrtoutf8str(searchrec.name);
           crcpath := stringcrc(nomeutf8,true);
            node_new := mfolder_findnodeintreeview(node,crcpath,nomeutf8);


            if node_new=nil then begin
             node_new := frm_settings.mfolder.addchild(node);
              data1 := frm_settings.mfolder.getdata(node_new);
              data1^.path := nomeutf8;
              data1^.crcpath := crcpath;
              if data^.stato=STATO_CHECKED then data1^.stato := STATO_CHECKED
               else data1^.stato := STATO_NOT_CHECKED;
              frm_settings.mfolder.invalidatenode(node_new);
            end; // else node_new := mfolder.items.item[index];

      DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
     end;

     finally
     helper_diskio.FindCloseW(SearchRec);
     end;
end;


procedure mfolder_AddSubNodesWithFolder(path: string);
var
  node : pCmtVnode;
  path1: string;
  crcpath: Word;
Begin
path1 := widestrtoutf8str(extract_fpathW(utf8strtowidestr(path)));
crcpath := stringcrc(path1,true);

  node := mfolder_FindNodeInTreeView(nil,crcpath,path1);

  if node=nil then begin

  exit;
  end;

  mfolder_EnumerateFolder(node);
End;

function mfolder_FindNodeInTreeView(StartNode:pCmtVnode; crcpath: Word; path: string) : pCmtVnode;
var
  node : pCmtVnode;
  data:ares_types.precord_mfolder;
  lopath: string;
Begin
  Result := nil;
try
  lopath := lowercase(path);

  if startnode=nil then startnode := frm_settings.mfolder.getfirst;

  node := frm_settings.mfolder.getfirstchild(startnode);

  while (node<>nil) do begin

  data := frm_settings.mfolder.getdata(node);
   if crcpath=data^.crcpath then
    if lowercase(data^.path)=lopath then begin
     Result := node;
     exit;
    end;

   node := frm_settings.mfolder.getnext(node);
 end;

except
end;
End;

procedure mfolder_CheckSubFolder ( node : pCmtVnode );
var
 node1:pCmtVnode;
 data,data1:ares_types.precord_mfolder;
 level: Cardinal;
Begin
try

  level := frm_settings.mfolder.getnodelevel(node);
  data := frm_settings.mfolder.getdata(node);

  node1 := frm_settings.mfolder.GetFirstChild(node);

  while node1 <> nil do begin
   data1 := frm_settings.mfolder.getdata(node1);

      data1.stato := data^.stato;
      frm_settings.mfolder.invalidatenode(node1);

    Node1 := frm_settings.mfolder.getnext(Node1);   //tutti anche child di child...finchè non arrivo a parent o sibling
    if node1=nil then exit;

    if frm_settings.mfolder.getnodelevel(node1)<=level then break;  //ok tutti i child...
  end;


except
end;
End;

function mfolder_CheckSibling(node:pCmtVnode): Boolean;
var
 node1:pCmtVnode;
 data:ares_types.precord_mfolder;
Begin
  Result := True; // if all folders are checked
  FSomeFolderChecked := False;

  Node1 := frm_settings.mfolder.getfirstchild(Node);

  while node1<>nil do begin
    data := frm_settings.mfolder.getdata(node1);

    if data^.stato=STATO_CHECKED then FSomeFolderChecked := true else
    if data^.stato=STATO_GREY_CHECKED then begin
      FSomeFolderChecked := True;
      Result := False;
      break;
    end else
    if data.Stato=STATO_NOT_CHECKED then Result := False;

    Node1 := frm_settings.mfolder.getnextsibling(Node1);
   end;
End;

function mfolder_ProofStates(node : pCmtVnode): Boolean;
var
 data:ares_types.precord_mfolder;
Begin
  Result := False;
try
data := frm_settings.mfolder.getdata(node);

  if ((data^.stato=STATO_NOT_CHECKED) or
     (data^.stato=STATO_GREY_CHECKED)) then begin
    data^.stato := STATO_CHECKED;
    frm_settings.mfolder.invalidatenode(node);
    Result := True;
  end else
  if (data^.stato=STATO_CHECKED) then begin
   data^.stato := STATO_NOT_CHECKED;
   frm_settings.mfolder.invalidatenode(node);
  end;

     mfolder_CheckParentFolder(node);
     mfolder_CheckSubFolder(node);


  cambiato_manual_folder_share := True; //rescan library on apply
except
end;
End;


procedure mfolder_CheckFolder(node:pCmtVnode);
var
 data:ares_types.precord_mfolder;
begin
data := frm_settings.mfolder.getdata(node);
data^.stato := STATO_CHECKED;

  mfolder_CheckParentFolder ( node );
  mfolder_CheckSubFolder ( node );

end;

Procedure mfolder_Init;
var
  DriveNum: Integer;
  DriveChar: Char;
  DriveType: cardinal;
  DriveBits: set of 0..25;
  str: string;
  node,rootn:pCmtVnode;
  data:ares_types.precord_mfolder;
begin
frm_settings.mfolder.onexpanding := nil;

frm_settings.mfolder.header.columns[0].width := frm_settings.mfolder.width;

   rootn := frm_settings.mfolder.Addchild(nil);
    data := frm_settings.mfolder.getdata(rootn);
    data^.path := '';
    data^.stato := -1;

   seterrormode(SEM_FAILCRITICALERRORS);
                          //get logical drive.....
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do begin
    if not (DriveNum in DriveBits) then Continue;
    DriveChar := Char(DriveNum + Ord('a'));
    DriveType := GetDriveType(PChar(DriveChar + ':\'));
     if ((DriveType=DRIVE_FIXED) or
         (DriveType=DRIVE_REMOTE) or
         (DriveType=DRIVE_CDROM) or
         (DriveType=DRIVE_RAMDISK)) then begin
         str := drivechar+':';
              if setcurrentdirectory(PChar(str)) then begin
                node := frm_settings.mfolder.AddChild(rootn);
                 data := frm_settings.mfolder.getdata(node);
                 data^.drivetype := DriveType;
                 data^.path := str; //'Disk ('+uppercase(DriveChar+':)');
                 data^.crcpath := stringcrc(str,true);
                 data^.stato := 0;
                  frm_settings.mfolder.invalidatenode(node);
              end;
     end;
  end;

 frm_settings.mfolder.fullexpand;
 

node := frm_settings.mfolder.getfirstchild(rootn);
repeat
if node=nil then break;
  mfolder_EnumerateFolder(node);
  node := frm_settings.mfolder.getnextsibling(node);
until (not true);

frm_settings.mfolder.onexpanding := ufrm_settings.frm_settings.mfolderExpanding;

End;


procedure mfolder_CheckParentFolder ( node : pCmtVnode );
var
  AllFolderChecked : boolean;
  node1:pCmtVnode;
  data:ares_types.precord_mfoldeR;
Begin
try

node1 := node.parent;

  while frm_settings.mfolder.getnodelevel(node1) >= 1 do begin

    AllFolderChecked := mfolder_CheckSibling(node1);  //sono gli altri child selezionati?

    data := frm_settings.mfolder.getdata(node1);

    if (not AllFolderChecked) and
       (not FSomeFolderChecked) then begin
          data^.Stato := STATO_NOT_CHECKED;
          frm_settings.mfolder.invalidatenode(node1);
    end else
    if FSomeFolderChecked then begin
         data^.Stato := STATO_GREY_CHECKED;
         frm_settings.mfolder.invalidatenode(node1);
    end;

    node1 := node1.parent;
    if node1=nil then exit;
  end;

  except
  end;
End;

procedure mfolder_LoadChecksFromDisk;
   procedure mfolder_SplitPathToList ( path : string; list : tmyStringList );
    var
    i : integer;
    str: WideString;
   begin
    str := utf8strtowidestr(path);

    for i := 1 to length(str) do begin
     if str[i]='\' then begin
      if i>3 then list.add(widestrtoutf8str(copy(str,1,i-1)));
     end;
    end;
     list.add(path);
   end;
var
  k : integer;
  SplitPathList : tmyStringList;
  path : string;
  prima_cartella:precord_cartella_share;
  cartella:precord_cartella_share;
   noder,node:pCmtVnode;
Begin
try
  screen.cursor := crHourGlass;
  application.processmessages;

  SplitPathList := tmyStringList.create;

  try

  prima_cartella := nil;
  helper_share_settings.get_shared_folders(prima_cartella,not reg_getever_configured_share);


   add_this_shared_folder(prima_cartella,vars_global.myshared_folder);

  // add nodes if necessary
  cartella := prima_cartella;
  while (cartella<>nil) do begin
    SplitPathList.clear;
    path := cartella^.path_utf8;
    mfolder_SplitPathToList(path,SplitPathList);
    // add nodes without Sub-Nodes
    for k := 0 to SplitPathList.count-1 do begin
         //sho/wmessage(SplitPathList.strings[k]);
     mfolder_AddSubNodesWithFolder(SplitPathList.strings[k]);
      Application.ProcessMessages;
    end;

    cartella := cartella^.next;

  end;
  // check nodes if necessary
    noder := frm_settings.mfolder.getfirst;
    if prima_cartella=nil then exit;

     cartella := prima_cartella;
     while (cartella<>nil) do begin

      node :=  mfolder_FindNodeInTreeView(noder,cartella^.crcpath,cartella^.path_utf8);
      if node<>nil then mfolder_CheckFolder(node); // else s/howmessage('not adding checks on:'+cartella^.path_utf8);
       Application.ProcessMessages;
       cartella := cartella^.next;
     end;


  except
  end;


  SplitPathList.Free;


  if prima_cartella<>nil then cancella_cartella_per_treeview2(prima_cartella);

 except
 end;
 screen.cursor := crDefault;
 frm_settings.mfolder.invalidate;
End;


Procedure mfolder_EnumerateFolder(node:pCmtVnode);
var
 node_new:pCmtVnode;
begin
try

if frm_settings.mfolder.getnodelevel(node)=0 then exit;

if frm_settings.mfolder.getfirstchild(node)=nil then begin
 mfolder_add_first_child(node);
 frm_settings.mfolder.sort(node,0,sdascending);
end;


node_new := frm_settings.mfolder.getfirstchild(node);
while (node_new<>nil) do begin

 if frm_settings.mfolder.getfirstchild(node_new)=nil then begin
  mfolder_add_first_child(node_new);
  frm_settings.mfolder.sort(node_new,0,sdascending);
 end;

 node_new := frm_settings.mfolder.getnextsibling(node_new);
 
end;

except
end;
End;


end.