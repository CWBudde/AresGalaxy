object frmpreview: Tfrmpreview
  Left = 486
  Top = 177
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  ClientHeight = 91
  ClientWidth = 230
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnResize = TntFormResize
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 225
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 4
    Top = 24
    Width = 3
    Height = 13
  end
  object ProgressBar1: TProgressBar
    Left = 4
    Top = 44
    Width = 221
    Height = 13
    TabOrder = 0
  end
  object btn_open: TTntButton
    Left = 120
    Top = 64
    Width = 81
    Height = 21
    TabOrder = 1
    OnClick = btn_openClick
  end
  object btn_cancel: TTntButton
    Left = 28
    Top = 64
    Width = 81
    Height = 21
    TabOrder = 2
  end
end
