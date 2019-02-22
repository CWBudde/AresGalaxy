unit CometTreesReg;

// This unit is an addendum to VirtualTrees.pas and contains code of design time editors as well as
// for theirs and the tree's registration.

interface

{$include Compilers.inc}

uses
  Windows, Classes, DesignIntf, DesignEditors, VCLEditors, PropertyCategories,
  ColnEdit, CometTrees, VCHeaderPopup;

type
  TVirtualTreeEditor = class (TDefaultEditor)
  public
    procedure Edit; override;
  end;

procedure Register;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  StrEdit, Dialogs, TypInfo, SysUtils, Graphics;

type
  // The usual trick to make a protected property accessible in the ShowCollectionEditor call below.
  TVirtualTreeCast = class(TBaseCometTree);
  TGetPropEditProc = TGetPropProc;
//----------------------------------------------------------------------------------------------------------------------

procedure TVirtualTreeEditor.Edit;
begin
  ShowCollectionEditor(Designer, Component, TVirtualTreeCast(Component).Header.Columns, 'Columns');
end;


procedure DrawBoolean(Checked: Boolean; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  BoxSize,
  EntryWidth: Integer;
  R: TRect;
  State: Cardinal;
begin
  with ACanvas do
  begin
    FillRect(ARect);

    BoxSize := ARect.Bottom - ARect.Top;
    EntryWidth := ARect.Right - ARect.Left;

    R := Rect(ARect.Left + (EntryWidth - BoxSize) div 2, ARect.Top, ARect.Left + (EntryWidth + BoxSize) div 2,
      ARect.Bottom);
    InflateRect(R, -1, -1);
    State := DFCS_BUTTONCHECK;
    if Checked then
      State := State or DFCS_CHECKED;
    DrawFrameControl(Handle, R, DFC_BUTTON, State);
  end;
end;

procedure Register;

begin
  RegisterComponents('comet', [TVirtualStringTree, TCometTree, TVTHeaderPopupMenu]);
  RegisterComponentEditor(TVirtualStringTree, TVirtualTreeEditor);
  RegisterComponentEditor(TCometTree, TVirtualTreeEditor);

  // Categories:
  RegisterPropertiesInCategory(sActionCategoryName, TBaseCometTree,
    ['ChangeDelay', 'EditDelay']);

  RegisterPropertiesInCategory(sDataCategoryName, TBaseCometTree,
    ['NodeDataSize',
     'RootNodeCount',
     'OnCompareNodes',
     'OnGetNodeDataSize',
     'OnInitNode',
     'OnInitChildren',
     'OnFreeNode',
     'OnGetNodeWidth',
     'OnGetPopupMenu',
     'OnLoadNode',
     'OnSaveNode',
     'OnResetNode',
     'OnNodeMov*',
     'OnStructureChange',
     'OnUpdating',
     'OnGetText',
     'OnNewText',
     'OnShortenString']);

  RegisterPropertiesInCategory(slayoutCategoryName, TBaseCometTree,
    ['AnimationDuration',
     'AutoExpandDelay',
     'AutoScroll*',
     'ButtonStyle',
     'DefaultNodeHeight',
     '*Images*', 'OnGetImageIndex',
     'Header',
     'Indent',
     'LineStyle', 'OnGetLineStyle',
     'CheckImageKind',
     'Options',
     'Margin',
     'NodeAlignment',
     'ScrollBarOptions',
     'SelectionCurveRadius',
     'TextMargin']);

  RegisterPropertiesInCategory(sVisualCategoryName, TBaseCometTree,
    ['Background*',
     'ButtonFillMode',
     'CustomCheckimages',
     'Colors',
     'LineMode']);

  RegisterPropertiesInCategory(sHelpCategoryName, TBaseCometTree,
    ['Hint*', 'On*Hint*', 'On*Help*']);

  RegisterPropertiesInCategory(sDragNDropCategoryName, TBaseCometTree,
    ['ClipboardFormats',
     'DefaultPasteMode',
     'OnCreateDataObject',
     'OnCreateDragManager',
     'OnGetUserClipboardFormats',
     'OnNodeCop*',
     'OnDragAllowed',
     'OnRenderOLEData']);

  RegisterPropertiesInCategory(sInputCategoryName, TBaseCometTree,
    ['DefaultText',
     'DrawSelectionMode',
     'WantTabs',
     'OnChang*',
     'OnCollaps*',
     'OnExpand*',
     'OnCheck*',
     'OnEdit*',
     'On*Click',
     'OnFocus*',
     'OnCreateEditor',
     'OnScroll',
     'OnHotChange']);
end;

//----------------------------------------------------------------------------------------------------------------------

end.
