object frm_settings: Tfrm_settings
  Left = 337
  Top = 120
  BorderStyle = bsNone
  ClientHeight = 425
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object settings_control: TCometPageView
    Left = 0
    Top = 0
    Width = 682
    Height = 425
    Align = alClient
    ParentColor = True
    TabOrder = 0
    wrappable = False
    ColorFrame = 2499619
    tabsVisible = True
    switchOnDown = True
    drawMargin = False
    buttonsHeight = 30
    buttonsLeft = 5
    buttonsLeftMargin = 10
    buttonsRightMargin = 10
    buttonsTopMargin = 8
    closeButtonTopMargin = 10
    closeButtonLeftMargin = 15
    closeButtonWidth = 13
    closeButtonHeight = 13
    activePage = 0
    buttonsHorizSpacing = 0
    buttonsTopHitPoint = 4
    object pnl_opt_skin: TCometTopicPnl
      Left = 0
      Top = 36
      Width = 653
      Height = 337
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 5
      bottomShadow = True
      topShadow = True
      capttop = 4
      object lbl_opt_skin_author: TTntLabel
        Left = 196
        Top = 36
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object lbl_opt_skin_version: TTntLabel
        Left = 196
        Top = 56
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object lbl_opt_skin_title: TTntLabel
        Left = 196
        Top = 16
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object lbl_opt_skin_url: TTntLabel
        Left = 224
        Top = 96
        Width = 3
        Height = 13
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
        ShowAccelChar = False
      end
      object lbl_opt_skin_urlcap: TTntLabel
        Left = 196
        Top = 96
        Width = 28
        Height = 13
        Caption = 'URL: '
        ShowAccelChar = False
      end
      object lbl_opt_skin_comments: TTntLabel
        Left = 196
        Top = 116
        Width = 317
        Height = 177
        AutoSize = False
        ShowAccelChar = False
        WordWrap = True
      end
      object lbl_opt_skin_date: TTntLabel
        Left = 196
        Top = 76
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object lstbox_opt_skin: TTntListBox
        Left = 16
        Top = 16
        Width = 165
        Height = 289
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object pnl_opt_sharing: TCometTopicPnl
      Left = 0
      Top = 32
      Width = 913
      Height = 397
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 7
      bottomShadow = True
      topShadow = True
      capttop = 4
      object btn_shareset_ok: TTntButton
        Left = 528
        Top = 320
        Width = 75
        Height = 25
        TabOrder = 0
      end
      object btn_shareset_cancel: TTntButton
        Left = 616
        Top = 320
        Width = 75
        Height = 25
        TabOrder = 1
      end
      object pgctrl_shareset: TCometPageView
        Left = 0
        Top = 31
        Width = 497
        Height = 317
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        wrappable = False
        ColorFrame = 2499619
        tabsVisible = True
        switchOnDown = True
        drawMargin = False
        buttonsHeight = 30
        buttonsLeft = 5
        buttonsLeftMargin = 10
        buttonsRightMargin = 10
        buttonsTopMargin = 8
        closeButtonTopMargin = 10
        closeButtonLeftMargin = 15
        closeButtonWidth = 13
        closeButtonHeight = 13
        activePage = 0
        buttonsHorizSpacing = 0
        buttonsTopHitPoint = 4
        object pnl_shareset_autoscan: TCometTopicPnl
          Left = 0
          Top = 36
          Width = 509
          Height = 309
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          bottomShadow = True
          topShadow = True
          capttop = 4
          object pnl_shareset_auto: TPanel
            Left = 8
            Top = 7
            Width = 353
            Height = 24
            Alignment = taLeftJustify
            BevelInner = bvLowered
            BevelOuter = bvLowered
            TabOrder = 0
            object lbl_shareset_auto: TTntLabel
              Left = 4
              Top = 4
              Width = 345
              Height = 13
              AutoSize = False
              ShowAccelChar = False
            end
          end
          object progbar_shareset_auto: TProgressBar
            Left = 8
            Top = 33
            Width = 353
            Height = 12
            TabOrder = 1
          end
          object chklstbx_shareset_auto: TCheckListBox
            Left = 8
            Top = 48
            Width = 353
            Height = 169
            Cursor = crHourGlass
            Color = clWhite
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Pitch = fpFixed
            Font.Style = []
            ItemHeight = 16
            ParentFont = False
            ParentShowHint = False
            ShowHint = False
            Style = lbOwnerDrawFixed
            TabOrder = 2
          end
          object btn_shareset_atuostart: TTntButton
            Left = 8
            Top = 232
            Width = 75
            Height = 24
            TabOrder = 3
          end
          object btn_shareset_atuostop: TTntButton
            Left = 88
            Top = 232
            Width = 75
            Height = 24
            Enabled = False
            TabOrder = 4
          end
          object btn_shareset_atuocheckall: TTntButton
            Left = 176
            Top = 232
            Width = 93
            Height = 24
            Enabled = False
            TabOrder = 5
          end
          object btn_shareset_atuoUncheckall: TTntButton
            Left = 272
            Top = 232
            Width = 89
            Height = 24
            Enabled = False
            TabOrder = 6
          end
        end
        object pnl_shareset_manual: TCometTopicPnl
          Left = 36
          Top = 68
          Width = 509
          Height = 301
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          bottomShadow = True
          topShadow = True
          capttop = 4
          object lbl_shareset_manuhint: TTntLabel
            Left = 8
            Top = 3
            Width = 345
            Height = 13
            AutoSize = False
            ShowAccelChar = False
          end
          object mfolder: TCometTree
            Left = 4
            Top = 22
            Width = 361
            Height = 127
            BiDiMode = bdLeftToRight
            BevelEdges = []
            BevelKind = bkFlat
            BGColor = 16775142
            BorderStyle = bsNone
            CanBgColor = False
            Color = clWhite
            DefaultNodeHeight = 16
            Header.AutoSizeIndex = 1
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clBlack
            Header.Font.Height = -13
            Header.Font.Name = 'Tahoma'
            Header.Font.Pitch = fpFixed
            Header.Font.Style = []
            Header.Height = 19
            Header.Options = [hoAutoResize, hoColumnResize, hoHotTrack, hoRestrictDrag, hoShowHint]
            Images = ares_frmmain.imglist_mfolder
            ParentBiDiMode = False
            Selectable = True
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoScroll, toAutoSpanColumns]
            TreeOptions.MiscOptions = [toInitOnSave]
            TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toThemeAware]
            TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMiddleClickSelect]
            TreeOptions.StringOptions = []
            Columns = <
              item
                Position = 0
                Width = 361
              end>
            WideDefaultText = ' '
          end
          object grpbx_shareset_manuhint: TTntGroupBox
            Left = 4
            Top = 158
            Width = 362
            Height = 51
            TabOrder = 1
            object img_shareset_manuhint1: TImage
              Left = 10
              Top = 17
              Width = 13
              Height = 13
              Picture.Data = {
                07544269746D6170C2010000424DC20100000000000036000000280000000B00
                00000B00000001001800000000008C0100000000000000000000000000000000
                00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
                0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
                FF0000FF0000FF0000000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFF0000FF0000FF0000000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFF0000FF0000FF0000000000FF0000FFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000000000FF0000FFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000000000FF0000FF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000000000
                FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF00
                00000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
                0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
                FF0000FF0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF00
                00FF0000FF0000FF0000FF000000}
            end
            object img_shareset_manuhint2: TImage
              Left = 10
              Top = 34
              Width = 13
              Height = 13
              Picture.Data = {
                07544269746D6170C2010000424DC20100000000000036000000280000000B00
                00000B00000001001800000000008C0100000000000000000000000000000000
                00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
                0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
                FF0000FF0000FF0000000000FF0000FFFFFFFFFFFFFF848284FFFFFFFFFFFFFF
                FFFFFFFFFF0000FF0000FF0000000000FF0000FFFFFFFF848284848284848284
                FFFFFFFFFFFFFFFFFF0000FF0000FF0000000000FF0000FF8482848482848482
                84848284848284FFFFFFFFFFFF0000FF0000FF0000000000FF0000FF84828484
                8284FFFFFF848284848284848284FFFFFF0000FF0000FF0000000000FF0000FF
                848284FFFFFFFFFFFFFFFFFF8482848482848482840000FF0000FF0000000000
                FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8482848482840000FF0000FF00
                00000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8482840000FF
                0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
                FF0000FF0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF00
                00FF0000FF0000FF0000FF000000}
            end
            object lbl_shareset_manuhint1: TTntLabel
              Left = 28
              Top = 16
              Width = 325
              Height = 13
              AutoSize = False
              ShowAccelChar = False
            end
            object lbl_shareset_manuhint2: TTntLabel
              Left = 28
              Top = 33
              Width = 325
              Height = 13
              AutoSize = False
              ShowAccelChar = False
            end
          end
        end
      end
    end
    object pnl_opt_network: TCometTopicPnl
      Left = 4
      Top = 28
      Width = 665
      Height = 353
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      bottomShadow = True
      topShadow = True
      capttop = 4
      object check_opt_net_nosprnode: TTntCheckBox
        Left = 16
        Top = 42
        Width = 517
        Height = 17
        TabOrder = 0
      end
      object grpbx_opt_proxy: TTntGroupBox
        Left = 16
        Top = 68
        Width = 441
        Height = 233
        TabOrder = 1
        object lbl_opt_proxy_addr: TTntLabel
          Left = 8
          Top = 100
          Width = 149
          Height = 13
          AutoSize = False
          ShowAccelChar = False
        end
        object lbl_opt_proxy_login: TTntLabel
          Left = 8
          Top = 132
          Width = 149
          Height = 13
          AutoSize = False
          ShowAccelChar = False
        end
        object lbl_opt_proxy_pass: TTntLabel
          Left = 8
          Top = 164
          Width = 149
          Height = 13
          AutoSize = False
          ShowAccelChar = False
        end
        object lbl_opt_proxy_check: TTntLabel
          Left = 184
          Top = 204
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object radiobtn_noproxy: TTntRadioButton
          Left = 8
          Top = 24
          Width = 309
          Height = 17
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object radiobtn_proxy4: TTntRadioButton
          Left = 8
          Top = 48
          Width = 293
          Height = 17
          TabOrder = 1
        end
        object radiobtn_proxy5: TTntRadioButton
          Left = 8
          Top = 72
          Width = 309
          Height = 17
          TabOrder = 2
        end
        object Edit_opt_proxy_addr: TEdit
          Left = 160
          Top = 96
          Width = 237
          Height = 21
          MaxLength = 30
          TabOrder = 3
        end
        object edit_opt_proxy_login: TTntEdit
          Left = 160
          Top = 128
          Width = 237
          Height = 21
          TabOrder = 4
        end
        object edit_opt_proxy_pass: TTntEdit
          Left = 160
          Top = 160
          Width = 237
          Height = 21
          TabOrder = 5
          PasswordCharW = '*'
        end
        object btn_opt_proxy_check: TTntButton
          Left = 8
          Top = 196
          Width = 153
          Height = 25
          TabOrder = 6
        end
      end
      object edit_opt_network_yourip: TEdit
        Left = 16
        Top = 14
        Width = 441
        Height = 21
        BorderStyle = bsNone
        ParentColor = True
        TabOrder = 2
        Text = 'IP: '
      end
    end
    object pnl_opt_chat: TCometTopicPnl
      Left = 8
      Top = -9
      Width = 653
      Height = 458
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      bottomShadow = True
      topShadow = True
      capttop = 4
      object grpbx_opt_chat: TTntGroupBox
        Left = 10
        Top = 146
        Width = 619
        Height = 199
        TabOrder = 0
        object TntLabel2: TTntLabel
          Left = 328
          Top = 26
          Width = 99
          Height = 13
          Caption = 'Auto-login Password:'
        end
        object check_opt_chat_joinpart: TTntCheckBox
          Left = 10
          Top = 20
          Width = 299
          Height = 17
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object Check_opt_chat_time: TTntCheckBox
          Left = 10
          Top = 40
          Width = 299
          Height = 17
          TabOrder = 1
        end
        object Check_opt_chatroom_nopm: TTntCheckBox
          Left = 10
          Top = 80
          Width = 299
          Height = 17
          TabOrder = 2
        end
        object check_opt_chat_noemotes: TTntCheckBox
          Left = 10
          Top = 100
          Width = 299
          Height = 17
          TabOrder = 3
        end
        object edit_opt_chat_autolog: TTntEdit
          Left = 436
          Top = 22
          Width = 165
          Height = 21
          TabOrder = 4
          PasswordCharW = '*'
        end
        object check_opt_chat_keepAlive: TTntCheckBox
          Left = 10
          Top = 140
          Width = 185
          Height = 17
          TabOrder = 5
        end
        object check_opt_chat_joinremotetemplate: TTntCheckBox
          Left = 326
          Top = 50
          Width = 275
          Height = 17
          TabOrder = 6
        end
        object check_opt_chat_msnsong: TTntCheckBox
          Left = 10
          Top = 120
          Width = 295
          Height = 17
          TabOrder = 7
        end
        object btn_opt_chat_font: TBitBtn
          Left = 8
          Top = 162
          Width = 89
          Height = 25
          Caption = ' Font '
          TabOrder = 8
        end
        object check_opt_chat_browsable: TTntCheckBox
          Left = 10
          Top = 60
          Width = 275
          Height = 17
          TabOrder = 9
        end
        object Memo_opt_chat_away: TTntMemo
          Left = 326
          Top = 92
          Width = 275
          Height = 97
          TabOrder = 10
        end
        object Check_opt_chat_isaway: TTntCheckBox
          Left = 326
          Top = 70
          Width = 283
          Height = 17
          TabOrder = 11
        end
      end
      object GrpBx_nick: TTntGroupBox
        Left = 10
        Top = 20
        Width = 619
        Height = 117
        TabOrder = 1
        object lbl_opt_gen_nick: TTntLabel
          Left = 12
          Top = 20
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object img_opt_avatar: TImage
          Left = 496
          Top = 12
          Width = 98
          Height = 98
          Cursor = crHandPoint
          OnClick = btn_opt_avatar_loadClick
        end
        object lbl_opt_chat_avatar: TTntLabel
          Left = 384
          Top = 20
          Width = 3
          Height = 13
        end
        object lbl_opt_chat_age: TTntLabel
          Left = 240
          Top = 20
          Width = 3
          Height = 13
        end
        object lbl_opt_chat_sex: TTntLabel
          Left = 12
          Top = 44
          Width = 3
          Height = 13
        end
        object lbl_opt_chat_country: TTntLabel
          Left = 12
          Top = 68
          Width = 3
          Height = 13
        end
        object lbl_opt_chat_statecity: TLabel
          Left = 12
          Top = 92
          Width = 3
          Height = 13
        end
        object lbl_opt_chat_message: TTntLabel
          Left = 236
          Top = 72
          Width = 3
          Height = 13
        end
        object edit_opt_gen_nick: TTntEdit
          Left = 68
          Top = 16
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object btn_opt_avatar_load: TTntButton
          Left = 396
          Top = 44
          Width = 93
          Height = 25
          TabOrder = 1
          OnClick = btn_opt_avatar_loadClick
        end
        object btn_opt_avatar_clr: TTntButton
          Left = 396
          Top = 76
          Width = 93
          Height = 25
          TabOrder = 2
          OnClick = btn_opt_avatar_clrClick
        end
        object cmbo_opt_chat_country: TComboBox
          Left = 68
          Top = 64
          Width = 153
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnClick = cmbo_opt_chat_countryClick
        end
        object edit_opt_chat_statecity: TTntEdit
          Left = 68
          Top = 88
          Width = 153
          Height = 21
          MaxLength = 30
          TabOrder = 4
        end
        object cmbo_opt_chat_sex: TTntComboBox
          Left = 68
          Top = 40
          Width = 153
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
        end
        object edit_opt_chat_message: TTntEdit
          Left = 236
          Top = 88
          Width = 145
          Height = 21
          MaxLength = 180
          TabOrder = 6
        end
        object edit_opt_chat_age: TMaskEdit
          Left = 268
          Top = 16
          Width = 29
          Height = 21
          MaxLength = 3
          ReadOnly = True
          TabOrder = 7
          Text = '0'
        end
        object UpDown4: TUpDown
          Left = 297
          Top = 16
          Width = 16
          Height = 21
          Associate = edit_opt_chat_age
          Max = 120
          TabOrder = 8
        end
      end
    end
    object pnl_opt_transfer: TCometTopicPnl
      Left = 0
      Top = 32
      Width = 661
      Height = 345
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      bottomShadow = True
      topShadow = True
      capttop = 4
      object lbl_opt_tran_port: TTntLabel
        Left = 16
        Top = 20
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object grpbx_opt_tran_shfolder: TTntGroupBox
        Left = 16
        Top = 216
        Width = 591
        Height = 121
        TabOrder = 0
        object lbl_opt_tran_shfolder: TTntLabel
          Left = 12
          Top = 20
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object lbl_opt_tran_disksp: TTntLabel
          Left = 12
          Top = 60
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object btn_opt_tran_chshfold: TTntButton
          Left = 16
          Top = 84
          Width = 169
          Height = 25
          TabOrder = 0
        end
        object btn_opt_tran_defshfold: TTntButton
          Left = 196
          Top = 84
          Width = 173
          Height = 25
          TabOrder = 1
        end
        object edit_opt_tran_shfolder: TTntEdit
          Left = 12
          Top = 36
          Width = 565
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
      end
      object Edit_opt_tran_port: TEdit
        Left = 77
        Top = 16
        Width = 45
        Height = 21
        BiDiMode = bdLeftToRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        MaxLength = 5
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 1
        Text = '80'
      end
      object check_opt_tran_warncanc: TTntCheckBox
        Left = 16
        Top = 64
        Width = 445
        Height = 17
        TabOrder = 2
      end
      object check_opt_tran_perc: TTntCheckBox
        Left = 16
        Top = 44
        Width = 437
        Height = 17
        TabOrder = 3
      end
      object grpbx_opt_tran_band: TTntGroupBox
        Left = 316
        Top = 108
        Width = 291
        Height = 93
        TabOrder = 4
        object lbl_opt_tran_upband: TTntLabel
          Left = 8
          Top = 21
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object lbl_opt_tran_dnband: TTntLabel
          Left = 8
          Top = 68
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object check_opt_tran_inconidle: TTntCheckBox
          Left = 8
          Top = 41
          Width = 261
          Height = 17
          TabOrder = 0
        end
        object Edit_opt_tran_upband: TEdit
          Left = 124
          Top = 16
          Width = 33
          Height = 21
          MaxLength = 4
          TabOrder = 1
          Text = '0'
        end
        object Edit_opt_tran_dnband: TEdit
          Left = 144
          Top = 64
          Width = 33
          Height = 21
          MaxLength = 4
          TabOrder = 2
          Text = '0'
        end
      end
      object grpbx_opt_tran_sims: TTntGroupBox
        Left = 16
        Top = 108
        Width = 293
        Height = 93
        TabOrder = 5
        object Label_max_uploads: TTntLabel
          Left = 51
          Top = 20
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object label_max_upperip: TTntLabel
          Left = 51
          Top = 44
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object label_max_dl: TTntLabel
          Left = 51
          Top = 68
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object Edit_opt_tran_limup: TEdit
          Left = 8
          Top = 17
          Width = 24
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ReadOnly = True
          TabOrder = 0
          Text = '4'
        end
        object UpDown1: TUpDown
          Left = 32
          Top = 17
          Width = 16
          Height = 21
          Associate = Edit_opt_tran_limup
          Min = 1
          Max = 30
          Position = 4
          TabOrder = 1
          Thousands = False
        end
        object Edit_opt_tran_upip: TEdit
          Left = 8
          Top = 41
          Width = 24
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ReadOnly = True
          TabOrder = 2
          Text = '0'
        end
        object UpDown2: TUpDown
          Left = 32
          Top = 41
          Width = 16
          Height = 21
          Associate = Edit_opt_tran_upip
          Max = 10
          TabOrder = 3
          Thousands = False
        end
        object Edit_opt_tran_limdn: TEdit
          Left = 8
          Top = 65
          Width = 24
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ReadOnly = True
          TabOrder = 4
          Text = '10'
        end
        object UpDown3: TUpDown
          Left = 32
          Top = 65
          Width = 16
          Height = 21
          Associate = Edit_opt_tran_limdn
          Min = 1
          Position = 10
          TabOrder = 5
          Thousands = False
        end
      end
      object Check_opt_tran_filterexe: TTntCheckBox
        Left = 16
        Top = 84
        Width = 401
        Height = 17
        TabOrder = 6
      end
    end
    object pnl_opt_hashlinks: TCometTopicPnl
      Left = 0
      Top = 36
      Width = 657
      Height = 369
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      bottomShadow = True
      topShadow = True
      capttop = 4
      object Memo_opt_hlink: TTntMemo
        Left = 16
        Top = 24
        Width = 405
        Height = 141
        HideSelection = False
        ScrollBars = ssVertical
        TabOrder = 0
        WantReturns = False
      end
      object btn_opt_hlink_down: TTntButton
        Left = 16
        Top = 172
        Width = 169
        Height = 25
        TabOrder = 1
      end
    end
    object pnl_opt_bittorrent: TCometTopicPnl
      Left = 0
      Top = 44
      Width = 677
      Height = 329
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      bottomShadow = True
      topShadow = True
      capttop = 4
      object grpbx_opt_bittorrent_dlfolder: TTntGroupBox
        Left = 16
        Top = 26
        Width = 577
        Height = 121
        TabOrder = 0
        object lbl_opt_torrent_shfolder: TTntLabel
          Left = 12
          Top = 20
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object lbl_opt_torrent_disksp: TTntLabel
          Left = 12
          Top = 60
          Width = 3
          Height = 13
          ShowAccelChar = False
        end
        object btn_opt_torrent_chshfold: TTntButton
          Left = 16
          Top = 84
          Width = 157
          Height = 25
          TabOrder = 0
        end
        object btn_opt_torrent_defshfold: TTntButton
          Left = 180
          Top = 84
          Width = 157
          Height = 25
          TabOrder = 1
        end
        object edit_opt_bittorrent_dlfolder: TTntEdit
          Left = 12
          Top = 36
          Width = 553
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
      end
    end
    object pnl_opt_general: TCometTopicPnl
      Left = 4
      Top = 40
      Width = 681
      Height = 341
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      bottomShadow = True
      topShadow = True
      capttop = 4
      object lbl_opt_gen_lan: TTntLabel
        Left = 14
        Top = 20
        Width = 3
        Height = 13
        ShowAccelChar = False
      end
      object Combo_opt_gen_gui_lang: TTntComboBox
        Left = 112
        Top = 16
        Width = 201
        Height = 21
        AutoComplete = False
        ItemHeight = 13
        TabOrder = 0
      end
      object check_opt_gen_autostart: TTntCheckBox
        Left = 14
        Top = 54
        Width = 345
        Height = 17
        TabOrder = 1
      end
      object check_opt_gen_autoconnect: TTntCheckBox
        Left = 14
        Top = 74
        Width = 337
        Height = 17
        TabOrder = 2
      end
      object check_opt_gen_gclose: TTntCheckBox
        Left = 14
        Top = 114
        Width = 333
        Height = 17
        TabOrder = 3
      end
      object check_opt_gen_nohint: TTntCheckBox
        Left = 14
        Top = 134
        Width = 333
        Height = 17
        TabOrder = 4
      end
      object check_opt_gen_pausevid: TTntCheckBox
        Left = 14
        Top = 154
        Width = 333
        Height = 17
        TabOrder = 5
      end
      object check_opt_gen_capt: TTntCheckBox
        Left = 14
        Top = 94
        Width = 333
        Height = 17
        TabOrder = 6
      end
      object btn_opt_gen_about: TTntBitBtn
        Left = 14
        Top = 184
        Width = 91
        Height = 29
        Caption = 'About Ares'
        TabOrder = 7
        OnClick = btn_opt_gen_aboutClick
        Glyph.Data = {
          E6040000424DE604000000000000360000002800000014000000140000000100
          180000000000B0040000C40E0000C40E000000000000000000007D3B137D3B13
          7D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B
          137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B13FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEA
          E0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FA
          EAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0
          FAEAE0FAEAE0666666666666666666666666666666FAEAE0FAEAE0FAEAE0FAEA
          E0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD
          5825BD5825BD5825BD5825BD5825FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0
          FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD58
          25BD5825BD5825666666FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D
          3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825
          BD5825666666FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B
          13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825BD582566
          6666FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFF
          FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825BD5825666666FAEA
          E0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FA
          EAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825BD5825666666FAEAE0FAEAE0
          FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEA
          E0FAEAE0FAEAE0FAEAE0BD5825BD5825BD5825666666FAEAE0FAEAE0FAEAE0FA
          EAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0
          FAEAE0FAEAE0BD5825BD5825BD5825666666FAEAE0FAEAE0FAEAE0FAEAE0FAEA
          E0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD
          5825BD5825BD5825BD5825FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0
          FFFFFF7D3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEA
          E0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D
          3B137D3B13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825
          BD5825666666FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B
          13FFFFFFFAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0BD5825BD5825BD5825FA
          EAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFF
          FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEA
          E0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFAEAE0FA
          EAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0FAEAE0
          FAEAE0FAEAE0FAEAE0FAEAE0FFFFFF7D3B137D3B13FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF7D3B137D3B137D3B137D3B137D3B137D3B137D3B13
          7D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B137D3B
          137D3B137D3B137D3B13}
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdEffects, fdForceFontExist]
    Left = 500
    Top = 72
  end
  object Fold: TBrowseForFolder
    StatusText = 'Please select folder'
    FolderName = 'C:\'
    Flags = [bf_DontGoBelowDomain]
    Root = bl_STANDART
    Caption = 'Select Folder'
    Left = 480
    Top = 124
  end
end
