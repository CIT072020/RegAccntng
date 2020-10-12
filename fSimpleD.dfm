object fmSimpleD: TfmSimpleD
  Left = 405
  Top = 211
  HelpType = htKeyword
  AutoScroll = False
  ClientHeight = 465
  ClientWidth = 799
  Color = clBtnFace
  Constraints.MinHeight = 493
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sp: TSplitter
    Left = 0
    Top = 370
    Width = 799
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnTable: TPanel
    Left = 0
    Top = 373
    Width = 799
    Height = 70
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object TBDock: TTBDock
    Left = 0
    Top = 0
    Width = 799
    Height = 26
    AllowDrag = False
    object TBToolbar: TTBToolbar
      Left = 0
      Top = 0
      Caption = #1052#1077#1085#1102
      DockPos = 8
      FullSize = True
      Images = fmMain.ImageList
      ProcessShortCuts = True
      TabOrder = 0
      object TBItemPreView: TTBItem
        Caption = #1055'&'#1088#1086#1089#1084#1086#1090#1088
        Hint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        ImageIndex = 31
        ShortCut = 116
        OnClick = TBItemPreViewClick
      end
      object TBItemPrint: TTBItem
        Caption = '&'#1055#1077#1095#1072#1090#1100
        Hint = #1055#1077#1095#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        ImageIndex = 24
        ShortCut = 117
        OnClick = TBItemPrintClick
      end
      object TBItemFastPrint: TTBItem
        Caption = #1041#1099#1089#1090#1088#1072#1103' '#1087#1077#1095#1072#1090#1100
        Enabled = False
        Hint = #1055#1077#1095#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1085#1072' '#1087#1088#1080#1085#1090#1077#1088' '#1073#1077#1079' '#1086#1082#1085#1072' '#1076#1080#1072#1083#1086#1075#1072
        ImageIndex = 6
        ShortCut = 118
        Visible = False
        OnClick = TBItemFastPrintClick
      end
      object TBItemWord: TTBItem
        Caption = 'Word-&'#1076#1086#1082#1091#1084#1077#1085#1090
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' Word-'#1076#1086#1082#1091#1084#1077#1085#1090
        ImageIndex = 95
        ShortCut = 119
        Visible = False
        OnClick = TBItemWordClick
      end
      object TBSubmenuTmp: TTBSubmenuItem
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' Word'
        ImageIndex = 95
        ShortCut = 119
        OnClick = TBSubmenuTmpClick
      end
      object TBSeparator1: TTBSeparatorItem
        Visible = False
      end
      object TBItemGetDataGISUN: TTBItem
        Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
        HelpContext = 1
        Hint = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1043#1048#1057' '#1056#1053
        ImageIndex = 114
        ShortCut = 112
        Visible = False
        OnClick = TBItemGetDataGISUNClick
      end
      object TBItemTmpOffGISUN: TTBItem
        Caption = #1042#1088#1077#1084#1077#1085#1085#1086' '#1086#1090#1082#1083#1102#1095#1080#1090#1100
        HelpContext = 1
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1074#1079#1072#1080#1084#1086#1076#1077#1081#1089#1090#1074#1080#1077' '#1089' '#1043#1048#1057' '#1056#1053
        ImageIndex = 4
        Images = ImGISUN
        Visible = False
        OnClick = TBItemTmpOffGISUNClick
      end
      object TBSeparator2: TTBSeparatorItem
        Visible = False
      end
      object TBItemDelList: TTBItem
        Caption = '&'#1059#1076#1072#1083#1080#1090#1100
        HelpContext = 1
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1089#1090#1088#1086#1082#1091' '#1089#1087#1080#1089#1082#1072
        ImageIndex = 41
        ShortCut = 16430
        Visible = False
        OnClick = TBItemDelListClick
      end
      object TBItemAddList: TTBItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        HelpContext = 1
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091' '#1089#1087#1080#1089#1082#1072
        ImageIndex = 127
        Visible = False
        OnClick = TBItemAddListClick
      end
      object TBItemPerekl: TTBItem
        Caption = #1055#1077#1088#1077#1082#1083#1102#1095#1077#1085#1080#1077
        Hint = #1055#1077#1088#1077#1082#1083#1102#1095#1077#1085#1080#1077' '#1084#1077#1078#1076#1091' '#1082#1072#1088#1090#1086#1095#1082#1086#1081' '#1080' '#1089#1087#1080#1089#1082#1086#1084
        ImageIndex = 40
        OnClick = TBItemPereklClick
      end
      object TBItemAddHist: TTBSubmenuItem
        Caption = #1044#1086#1073'&'#1072#1074#1080#1090#1100' '#1074' '#1080#1089#1090#1086#1088#1080#1102
        DropdownCombo = True
        ImageIndex = 101
        ShortCut = 16449
        Visible = False
        OnClick = TBItemAddHistClick
        object TBItemClearHist: TTBItem
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1102' '#1080#1089#1090#1086#1088#1080#1102
          ImageIndex = 32
          OnClick = TBItemClearHistClick
        end
      end
      object TBItemAddHist1: TTBItem
        Caption = #1044#1086#1073'&'#1072#1074#1080#1090#1100' '#1074' '#1080#1089#1090#1086#1088#1080#1102
        HelpContext = 1
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1080#1089#1090#1086#1088#1080#1102
        ImageIndex = 101
        Visible = False
        OnClick = TBItemAddHist1Click
      end
      object TBItemHist: TTBItem
        Caption = '&'#1048#1089#1090#1086#1088#1080#1103
        Hint = #1048#1089#1090#1086#1088#1080#1103' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1088#1077#1082#1074#1080#1079#1080#1090#1072
        ImageIndex = 3
        Visible = False
        OnClick = TBItemHistClick
      end
      object TBItemCreateHist: TTBItem
        Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
        ImageIndex = 57
        Visible = False
        OnClick = TBItemCreateHistClick
      end
      object TBItemAddSvid: TTBItem
        Caption = '&'#1057#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086
        HelpContext = 1
        Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1072
        ImageIndex = 4
        Visible = False
        OnClick = TBItemAddSvidClick
      end
      object TBSubmenuRun: TTBSubmenuItem
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
        HelpContext = 1
        ImageIndex = 22
        object TBItemAddLastDok: TTBItem
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
          OnClick = TBItemAddLastDokClick
        end
        object TBSeparatorItem: TTBSeparatorItem
        end
        object TBItemCkeckRegistr: TTBItem
          Caption = #1050#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088' '#1073#1091#1082#1074
          Checked = True
          Images = ImGISUN
          OnClick = TBItemCkeckRegistrClick
        end
      end
      object TBItemSeekAkt: TTBItem
        Caption = #1053#1072#1081#1090#1080' '#1072#1090#1086#1074#1091#1102' '#1079#1072#1087#1080#1089#1100
        Hint = #1053#1072#1081#1090#1080' '#1072#1090#1086#1074#1091#1102' '#1079#1072#1087#1080#1089#1100' '#1087#1086' '#1085#1086#1084#1077#1088#1091' '#1080' '#1076#1072#1090#1077' '#1079'/'#1072
        ImageIndex = 7
        Visible = False
        OnClick = TBItemSeekAktClick
      end
      object TBItemZAGS: TTBItem
        Caption = #1054#1090#1076#1077#1083' '#1047#1040#1043#1057
        HelpContext = 1
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1047#1040#1043#1057' '#1074#1099#1087#1080#1089#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        ImageIndex = 42
        ShortCut = 115
        OnClick = TBItemZAGSClick
      end
      object TBItemShablon: TTBItem
        Caption = #1064#1072#1073#1083#1086#1085
        HelpContext = 1
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1072
        ImageIndex = 106
        ShortCut = 121
        Visible = False
        OnClick = TBItemShablonClick
      end
      object TBItemEditMemo: TTBItem
        Caption = #1041#1086#1083#1100#1096#1086#1081' '#1090#1077#1082#1089#1090
        Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1073#1086#1083#1100#1096#1086#1075#1086' '#1090#1077#1082#1089#1090#1072' '#1074' '#1086#1090#1076#1077#1083#1100#1085#1086#1084' '#1086#1082#1085#1077
        ImageIndex = 136
        Visible = False
        OnClick = TBItemEditMemoClick
      end
      object TBItemAdresat: TTBItem
        Caption = #1040#1076#1088#1077#1089#1072#1090
        HelpContext = 1
        Hint = #1042#1074#1077#1089#1090#1080' '#1072#1076#1088#1077#1089#1072#1090#1072
        ImageIndex = 63
        ShortCut = 122
        OnClick = TBItemAdresatClick
      end
      object TBItemSprAkt: TTBItem
        Caption = #1057#1087#1088#1072#1074#1082#1072' '#1086' '#1079#1072#1087#1080#1089#1080' '#1072#1082#1090#1072
        Hint = #1057#1087#1088#1072#1074#1082#1072' '#1086' '#1079#1072#1087#1080#1089#1080' '#1072#1082#1090#1072
        ImageIndex = 17
        OnClick = TBItemSprAktClick
      end
      object TBItemDeclSvid: TTBItem
        Caption = #1047#1072#1103#1074#1083#1077#1085#1080#1077' '#1085#1072' '#1087#1086#1074#1090#1086#1088#1085#1086#1077' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086
        Hint = #1047#1072#1103#1074#1083#1077#1085#1080#1077' '#1085#1072' '#1074#1099#1076#1072#1095#1091' '#1087#1086#1074#1090#1086#1088#1085#1086#1075#1086' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1072
        ImageIndex = 72
        OnClick = TBItemDeclSvidClick
      end
      object TBItemOnlySvid: TTBItem
        Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086
        HelpContext = 1
        Hint = #1042#1099#1087#1080#1089#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086
        ImageIndex = 53
        Visible = False
      end
      object TBItemDolg: TTBItem
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        HelpContext = 1
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1083#1078#1085#1086#1089#1090#1100' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103' '#1080' '#1089#1087#1077#1094#1080#1072#1083#1080#1089#1090#1072
        ImageIndex = 11
        Visible = False
        OnClick = TBItemDolgClick
      end
      object TBItemSvidIspor: TTBItem
        Caption = #1057#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086' '#1080#1089#1087#1086#1088#1095#1077#1085#1086
        HelpContext = 1
        Hint = #1057#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086' '#1080#1089#1087#1086#1088#1095#1077#1085#1086
        ImageIndex = 61
        Visible = False
        OnClick = TBItemSvidIsporClick
      end
      object TBSubmenuPar: TTBSubmenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
        Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072
        ImageIndex = 23
        Visible = False
      end
      object TBItemWrite: TTBItem
        Caption = '&'#1047#1072#1087#1080#1089#1072#1090#1100
        HelpContext = 1
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1074' '#1073#1072#1079#1077
        ImageIndex = 36
        ShortCut = 113
        OnClick = TBItemWriteClick
      end
      object TBItemCancel: TTBItem
        Caption = '&'#1054#1090#1082#1072#1079
        Hint = #1042#1099#1081#1090#1080' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
        ImageIndex = 37
        ShortCut = 16497
        OnClick = TBItemCancelClick
      end
      object TBItemSetUp: TTBItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' ADSSYS'
        ImageIndex = 23
        OnClick = TBItemSetUpClick
      end
      object TBItemDesignReport: TTBItem
        Caption = #1056#1072#1079#1088#1072#1073#1086#1090#1072#1090#1100
        Hint = #1056#1072#1079#1088#1072#1073#1086#1090#1072#1090#1100' '#1086#1090#1095#1077#1090
        ImageIndex = 12
        OnClick = TBItemDesignReportClick
      end
      object TBSeparatorMove1: TTBSeparatorItem
        Visible = False
      end
      object TBItemFirst: TTBItem
        Caption = #1074' '#1085#1072#1095#1072#1083#1086
        Hint = #1074' '#1085#1072#1095#1072#1083#1086
        ImageIndex = 0
        Images = fmMain.ImageListMove
        ShortCut = 16417
        Visible = False
        OnClick = TBItemFirstClick
      end
      object TBItemPrev: TTBItem
        Caption = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081
        Hint = #1087#1088#1077#1076#1099#1076#1091#1097#1080#1081
        ImageIndex = 1
        Images = fmMain.ImageListMove
        ShortCut = 33
        Visible = False
        OnClick = TBItemPrevClick
      end
      object TBItemNext: TTBItem
        Caption = #1089#1083#1077#1076#1091#1102#1097#1080#1081
        Hint = #1089#1083#1077#1076#1091#1102#1097#1080#1081
        ImageIndex = 2
        Images = fmMain.ImageListMove
        ShortCut = 34
        Visible = False
        OnClick = TBItemNextClick
      end
      object TBItemLast: TTBItem
        Caption = #1074' '#1082#1086#1085#1077#1094
        Hint = #1074' '#1082#1086#1085#1077#1094
        ImageIndex = 3
        Images = fmMain.ImageListMove
        ShortCut = 16418
        Visible = False
        OnClick = TBItemLastClick
      end
      object TBItemNonQuery: TTBItem
        AutoCheck = True
        Caption = #1073#1077#1079' '#1079#1072#1087#1088#1086#1089#1072
        Hint = #1047#1072#1087#1080#1089#1100' '#1073#1077#1079' '#1079#1072#1087#1088#1086#1089#1072'  '#1087#1088#1080'  '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080
        ImageIndex = 99
        Visible = False
      end
      object TBSeparatorMove2: TTBSeparatorItem
        Visible = False
      end
      object TBControlItem1: TTBControlItem
        Control = TBToolbarOrgan
      end
      object TBItemCopy: TTBItem
        Caption = '!!!'
        Hint = #1077#1089#1090#1100' '#1089#1089#1099#1083#1082#1080' '#1074' '#1076#1088#1091#1075#1080#1093' '#1092#1086#1088#1084#1072#1093
        Visible = False
      end
      object TBToolbarOrgan: TTBToolbar
        Left = 299
        Top = 1
        Width = 466
        Height = 19
        TabOrder = 0
        Visible = False
        object TBControlItem2: TTBControlItem
          Control = lbOrgan
        end
        object TBControlItem3: TTBControlItem
          Control = edZAGS
        end
        object TBControlItem4: TTBControlItem
          Control = N_F_cbGorod
        end
        object lbOrgan: TLabel
          Left = 0
          Top = 3
          Width = 78
          Height = 13
          Caption = '  '#1054#1088#1075#1072#1085' '#1047#1040#1043#1057'  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edZAGS: TDBEditEh
          Left = 78
          Top = 0
          Width = 305
          Height = 19
          DataField = 'NAME_ZAGS'
          DataSource = dsDokument
          EditButtons = <>
          Flat = True
          TabOrder = 0
          Visible = True
          OnCheckDrawRequiredState = edZAGSCheckDrawRequiredState
        end
        object N_F_cbGorod: TDBCheckBoxEh
          Left = 383
          Top = 1
          Width = 83
          Height = 17
          Alignment = taLeftJustify
          Caption = '    '#1043#1086#1088#1086#1076
          DataField = 'IS_GOROD'
          DataSource = dsDokument
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
    end
  end
  object sb: TScrollBox
    Left = 0
    Top = 50
    Width = 799
    Height = 320
    Align = alTop
    BorderStyle = bsNone
    Constraints.MinHeight = 100
    TabOrder = 1
    object ImBtClear: TImage
      Left = 552
      Top = 8
      Width = 17
      Height = 17
      Picture.Data = {
        07544269746D6170C6000000424DC60000000000000076000000280000000A00
        00000A0000000100040000000000500000000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00888888888800000000888888080000008008888008000000800088008800
        0000880000088800000088800088880000008800000888000000800088008800
        000080088880080000008088888888000000}
      Visible = False
    end
    object imOrg: TImage
      Left = 680
      Top = 200
      Width = 17
      Height = 17
      Picture.Data = {
        055449636F6E0000010001000E0E000001001800C80200001600000028000000
        0E0000001C000000010018000000000068020000000000000000000000000000
        00000000000000824E0C7440006D3A00794C0F896029522D006443166A491C75
        5226522A00774B1085531100000000008C540D633904FFFFDDFFFFDBFFFED9FF
        FFDCFFFFDBFFFFDFFFF5D3FFFFF0FFFFF0FFFFE7FFFDCB844B0000007C410088
        5F2862451EFFFFE1775E3CFFFFD1674210FFFFDC6A5333FBF3E2484033FFFFED
        735123975C0D00009353008D59166D4209FFFFD868430FFFFFD2794F14FFFFD1
        75582CFFFFE7564427FFFFE07249128D51000000A3610893590D87540EFFFFCD
        885A1AFFFFCA895917FFFFC97D5824FFFFDF6E5229FFFCCB8E6124955A0A0000
        9E5E098F54049B6316FFFFC4986418FFFCB18B5710FFFFCD80581EFFFFCE8665
        34FFFFD48C602388530A0000A3630EA26B208D5C18FFFFC3946724FFFFC19969
        27FFFFD07D5A28FFFFE06C552FFFFFDD845F279A661F0000B4741F83571A8164
        37FFFFDB725C38FFFFDC79582AFFFFDB736247FFFFF84C4D44FFFFF0765D3397
        641B0000B873129E6E2CFFFFDCFFFFE9FFFFEDFFFDE0FFFFEAFFFFF0F8F6EBF8
        FFFFFBFFFEFFF9E3FFFFD9AD711D0000D37F0F9F5C00996822FFFFDBFFFFE8FF
        FFF2F5F9F4F1F9F9F7FFFFFFFFFBFFFAE2FFFFD8935D10CC7F180000D68006D6
        8310C37B16B78134FFFFD6FFFFF1EDF3F2F4FFFFF5F9F4FFFFE7FFFFD1AA701E
        C97E17BA65000000D9850EDC7900FB9810C67200AB701AFFFFD6FFFFF4FFFFF8
        FFFFEAFFFFC3C6821FE28910E28605EC951F0000BE7610F3940FE37B00E88701
        DC9125A47B3CFFFFDAFFFFE4FFFFD8B27317D7840BEF900BD17500C87D110000
        000000D78D23E38B0FD87C00D07D09C78B32AA7C35FFFFC0B18032D38D28D888
        15D4810DCB811700000000008004000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        80040000}
      Visible = False
    end
    object pnPovtor: TPanel
      Left = 15
      Top = 64
      Width = 602
      Height = 233
      TabOrder = 0
      object imBE: TImage
        Left = 496
        Top = 136
        Width = 15
        Height = 17
        Hint = #1055#1077#1088#1077#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1085#1072' '#1073#1077#1083#1086#1088#1091#1089#1089#1082#1091#1102' '#1088#1072#1089#1082#1083#1072#1076#1082#1091' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
        Picture.Data = {
          07544269746D617066030000424D660300000000000036000000280000000F00
          0000110000000100180000000000300300000000000000000000000000000000
          0000E06326E06326E06326E06326E06326E06326E06326E06326E06326E06326
          E06326E06326E06326E06326E06326000000C56A31C56A31C56A31C56A31C56A
          31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A3100
          0000C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31
          C56A31C56A31C56A31C56A31C56A31000000C56A31C56A31C56A31C56A31C56A
          31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A3100
          0000C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31
          C56A31C56A31C56A31C56A31C56A31000000C56A31E28331FFFFDDFFFFFFFFFF
          FFECFFFFC56A76E28331FFFFDDFFFFFFFFFFFFFFFFFFF5FFFFC58398C56A3100
          0000C56A31E28331E2E6DDC56A53C56A31EC9C31E2E6FFE28353E2E6DDC56A53
          C56A31C56A31C56A31C56A31C56A31000000C56A31E28331E2E6DDC56A53C56A
          31D86A31ECFFBAE28376E2E6DDC56A53C56A31C56A31C56A31C56A31C56A3100
          0000C56A31E28331E2E6DDC56A53C56A31E28331E2E6DDE28353E2E6DDC56A53
          C56A31C56A31C56A31C56A31C56A31000000C56A31E28331FFFFDDFFFFFFFFFF
          FFF5FFFFC58398E28331FFFFDDFFFFFFFFFFFFFFFFFFE2E6FFC56A53C56A3100
          0000C56A31E28331E2E6DDC56A53C56A31EC9C31D8CDFFE28331E2E6DDC56A53
          C56A31C56A31C56A31C56A31C56A31000000C56A31E28331E2E6DDC56A53C56A
          31E28331E2E6DDE28353E2E6DDC56A53C56A31C56A31C56A31C56A31C56A3100
          0000C56A31E28331FFFFDDFFFFFFFFFFFFFFFFFFC59CBAE28331FFFFDDFFFFFF
          FFFFFFFFFFFFF5FFFFC58398C56A31000000C56A31C56A31C56A31C56A31C56A
          31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A3100
          0000C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31
          C56A31C56A31C56A31C56A31C56A31000000C56A31C56A31C56A31C56A31C56A
          31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A3100
          0000C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31C56A31
          C56A31C56A31C56A31C56A31C56A31000000}
        Visible = False
        OnClick = imBEClick
      end
      object DbGridEh1: TDBGridEh
        Left = 19
        Top = 7
        Width = 395
        Height = 137
        DataSource = dsPovtor
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'SVID_DATE'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Width = 90
          end
          item
            EditButtons = <>
            FieldName = 'SVID_SERIA_L'
            Footers = <>
            Title.Caption = #1057#1077#1088#1080#1103
            Width = 58
          end
          item
            EditButtons = <>
            FieldName = 'SVID_NOMER'
            Footers = <>
            Title.Caption = #1053#1086#1084#1077#1088
            Width = 93
          end
          item
            EditButtons = <>
            FieldName = 'FIRST'
            Footers = <>
            Title.Caption = #1055#1077#1088#1074'.'
            Visible = False
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'WHO_SVID'
            Footers = <>
            KeyList.Strings = (
              #1052
              #1046)
            PickList.Strings = (
              #1052#1091#1078'.'
              #1046#1077#1085'.')
            Title.Caption = #1050#1086#1084#1091
            Visible = False
            Width = 45
          end
          item
            EditButtons = <>
            FieldName = 'GISRN'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            PickList.Strings = (
              #1044#1072
              #1053#1077#1090)
            ReadOnly = True
            Title.Caption = #1043#1048#1057' '#1056#1053
            Width = 49
          end>
      end
      object btNewPovtor: TBitBtn
        Left = 442
        Top = 16
        Width = 145
        Height = 25
        Hint = #1053#1086#1074#1086#1077' '#1087#1086#1074#1090#1086#1088#1085#1086#1077' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1086
        Caption = #1042#1099#1076#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1085#1086#1077'  '
        TabOrder = 1
        OnClick = btNewPovtorClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000000000000000000000000000000000007F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F00FF0000FF0017AE177F7F7F7F7F7F7F7F7F7F7F7F
          A5A5A5A9A9A9AAAAAAAAAAAAAAAAAAA8A9A8A8A9A8A6AAA69FAA9F00FF0000FF
          0013B0137F7F7F7F7F7F7F7F7F00000000000000000080808000000000000000
          0200000700000D006F876F00FF0000FF000CB30C688A687F7F7F7F7F7F808080
          F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F4F7F400FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF007F7F7F000000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F4
          F7F400FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF007F7F7F000000
          F8F8F8F8F8F88080808080808080807E807E7A827AE5F3E5D8F0D800FF0000FF
          000CB30C698B697F7F7F7F7F7F000000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F7
          F7F7F5F7F5F2F6F2E9F4E900FF0000FF0013B0137F7F7F7F7F7F7F7F7F808080
          00000000000000000080808000000000000000000080808000040000FF0000FF
          001BAD1B7F7F7F7F7F7F7F7F7F000000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
          F8F8F8F8F8F8F8F8F5F7F50007009EAB9E7D897D7F7F7F7F7F7F7F7F7F000000
          F8F8F8808080808080808080808080808080808080808080F7F7F7000200A7A9
          A77F7F7F7F7F7F7F7F7F7F7F7F000000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
          F8F8F8F8F8F8F8F8F8F8F8000000AAAAAA7F7F7F7F7F7F7F7F7F7F7F7F808080
          000000000000000000000000000000808080000000808080000000000000A9A9
          A97F7F7F7F7F7F7F7F7F7F7F7F000000F8F8F8F8F8F880808080808080808080
          8080808080F8F8F8F8F8F8000000A5A5A57F7F7F7F7F7F7F7F7F7F7F7F808080
          0000000000000000008080800000000000000000008080800000008080807F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F}
      end
      object btClearFirst: TBitBtn
        Left = 442
        Top = 51
        Width = 145
        Height = 25
        Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1077#1088#1074#1080#1095#1085#1086#1084' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1077
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1077#1088#1074#1080#1095#1085#1086#1077
        TabOrder = 2
        OnClick = btClearFirstClick
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          0800000000000001000000000000000000000001000000000000000000000000
          0200020205000303070004040A0007070F000909140014142C007F7F7F007F7F
          80007F7F83007F7F84007F7F88007F7F8C007F7F94005656B7005A5ABF000000
          FF007D7DCE006767DA007B7BD3007B7BD8007979DB007B7BE0007A7AE1007A7A
          E2007A7AE3008080800085858D0084848F0085858F0085859100858593008484
          940084849C009E9EBD00A5A5A500A6A6AE00A9A9A900A8A8AA00A8A8AB00AAAA
          AA00A5A5B100A1A1B400A1A1B600A2A2B600A1A1B8008888DE008888E2008181
          EC00C0C0C000E0E0F900E4E4F900E9E9F800EAEAF800ECECF800EDEDF800F1F1
          F800F4F4F800F5F5F800F7F7F800F8F8F8000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000009020
          940000000000E538F8000000AF00C821AF00000000006C2094008806AF002021
          9400952BF8002039F800FFFFFF003021940040B7FC007813AF00D021AF000000
          000091B6FC000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000D021AF0000000000000000000000
          0000000000000000000000000000BC1E940000ECFD00020000000000AF004500
          000000000A00D8B1F8003E00000001000000F4B5E800A0209400010101003823
          9400952BF8001836F800FFFFFF00AC21940008B6E800AC2194002FB6E8000000
          0000020000002823940001000000180000000000000090219400420000000000
          0000742194000000000000000000000000000C0000000200000001019400573E
          F80000ECFD00000000000200000046001A00D021AF007FFFFF0000000000D021
          AF0005000000A677E800D02194009AB6E8005401000000000000000000000000
          000002000000000000000000000010239400CF034B0098D0B100000000000000
          0000042394000200000080000000000000000001000098239400153AE100463A
          5C00726F6A006374730053656C006F7665005C646F0044656C00626D70008806
          A800C4229400952BF8002039F800FFFFFF00D422940040B7FC00D807A8004046
          B700000000004046B700153AE100F80D040000000000C0E8AE000000A8008022
          94004D73E100D304E2000000A800000000000700000000000000010000000022
          940007000000D304E200F8EBFD00000000004046B7003800000097B1FC000000
          A8000700000000229400952BF8000836F80001FFFF00F4229400442294000101
          01000C239400952BF8001836F800FFFFFF001C239400A80349000000A8000000
          00004046B7000000000064239400153AE10028000000F234F400010000003A09
          00000C00000000000000010000000F000000F61B460098D0B100080808080808
          190E0808080808081608080808080820111722211E1D0814110808082426282A
          111131232E2B2F110808080000000905071111131A0F11080808081B3D3D3C39
          3432111111112D1C080808003D3D3B383332321111102C1D080808003D3D0A0D
          151811111111301F080808003D3D3A3711111135361111120808081B0000020C
          1111060B03042511080808003D3D3C3B3A3A3B3C3D012708080808003D1B1B1B
          1B1B1B1B3D002908080808003D3D3D3D3D3D3D3D3D0029080808081B00000000
          001B001B00002608080808003D3D1B1B1B1B1B3D3D0024080808081B0000001B
          0000001B001B0808080808080808080808080808080808080808}
      end
      object N_F_cbPrintPovtor: TDBCheckBoxEh
        Left = 13
        Top = 192
        Width = 451
        Height = 17
        Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074#1077' '#1089#1083#1086#1074#1072' "'#1087#1086#1074#1090#1086#1088#1085#1086#1077'"'
        DataField = 'PRINT_POVTOR'
        DataSource = dsDokument
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object btDelPovtor: TBitBtn
        Left = 442
        Top = 88
        Width = 149
        Height = 25
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1089#1090#1088#1086#1082#1091'  '#1089#1087#1080#1089#1082#1072' '#1087#1086#1074#1090#1086#1088#1085#1099#1093' '#1089#1074#1080#1076#1077#1090#1077#1083#1100#1089#1090#1074
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091'         '
        TabOrder = 4
        OnClick = btDelPovtorClick
        Glyph.Data = {
          BE000000424DF600000000000000760000002800000010000000100000000100
          040000000000800000000000000000000000020000000200000004020400C4C2
          C400111111111111111111111111111111111111111111111011111011111111
          1111110001111111011111000111111011111110001111001111111100011001
          1111111110000011111111111100011111111111100000111111111100011011
          1111110000111100111110000111111001111001111111110011111111111111
          1111}
      end
    end
    object N_F_edTypeEkz: TComboBox
      Left = 680
      Top = 108
      Width = 115
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      ItemHeight = 13
      TabOrder = 1
      TabStop = False
      Visible = False
      OnChange = N_F_edTypeEkzChange
      Items.Strings = (
        '1-'#1081' '#1101#1082#1079#1077#1084#1087#1083#1103#1088
        '2-'#1081' '#1101#1082#1079#1077#1084#1087#1083#1103#1088
        #1076#1074#1072' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072
        #1076#1074#1072' '#1101#1082#1079'.+'#1082#1086#1087#1080#1103
        #1076#1074#1072' '#1101#1082#1079'.(1 '#1089#1090#1086#1088#1086#1085#1072')')
    end
  end
  object StBar: TStatusBar
    Left = 0
    Top = 443
    Width = 799
    Height = 22
    Panels = <
      item
        Style = psOwnerDraw
        Text = 
          '<F2> '#1079#1072#1087#1080#1089#1072#1090#1100'  <F5> '#1087#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088'  <F6> '#1087#1077#1095#1072#1090#1100'    <Ctrl-F2> '#1074#1099#1093#1086#1076 +
          '    <F10> '#1074#1099#1073#1086#1088
        Width = 50
      end>
    OnDrawPanel = StBarDrawPanel
  end
  object pnAdd: TPanel
    Left = 0
    Top = 26
    Width = 799
    Height = 24
    Align = alTop
    TabOrder = 4
    object lbAnnulir: TvchDBText
      Left = 7
      Top = 2
      Width = 690
      Height = 17
      DataField = 'DATE_ANUL'
      DataSource = dsDokument
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnGetText = lbAnnulirGetText
    end
  end
  object dsDokument: TDataSource
    DataSet = Dokument
    OnDataChange = dsDokumentDataChange
    Left = 448
    Top = 58
  end
  object Dokument: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME_ZAGS'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'NAME_ZAGS_B'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'DateIzm'
        DataType = ftDate
      end
      item
        Name = 'NOMER_EKZ'
        DataType = ftInteger
      end
      item
        Name = 'POVTOR'
        DataType = ftBoolean
      end
      item
        Name = 'TYPE_EKZ'
        DataType = ftInteger
      end
      item
        Name = 'IS_GOROD'
        DataType = ftBoolean
      end
      item
        Name = 'DATE_ANUL'
        DataType = ftDate
      end
      item
        Name = 'PRINT_VOSSTAN'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.52'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    DefaultFormat = kbmCSVStreamFormat1
    CommaTextFormat = kbmCSVStreamFormat1
    PersistentFormat = kbmCSVStreamFormat1
    AllDataFormat = kbmCSVStreamFormat1
    BeforePost = DokumentBeforePost
    Left = 504
    Top = 58
    object DokumentID: TIntegerField
      FieldName = 'ID'
    end
    object DokumentNAME_ZAGS: TStringField
      FieldName = 'NAME_ZAGS'
      Size = 200
    end
    object DokumentNAME_ZAGS_B: TStringField
      FieldName = 'NAME_ZAGS_B'
      Size = 200
    end
    object DokumentDateIzm: TDateField
      FieldName = 'DateIzm'
    end
    object DokumentNOMER_EKZ: TIntegerField
      FieldName = 'NOMER_EKZ'
    end
    object DokumentPOVTOR: TBooleanField
      FieldName = 'POVTOR'
    end
    object DokumentIS_GOROD: TBooleanField
      FieldName = 'IS_GOROD'
    end
    object DokumentTYPE_EKZ: TIntegerField
      FieldName = 'TYPE_EKZ'
    end
    object DokumentDATE_ANUL: TDateField
      FieldName = 'DATE_ANUL'
    end
    object DokumentPRINT_VOSSTAN: TBooleanField
      FieldName = 'PRINT_VOSSTAN'
    end
    object DokumentDELETE_CRLF: TBooleanField
      FieldName = 'DELETE_CRLF'
    end
    object DokumentPRINT_POVTOR: TBooleanField
      FieldName = 'PRINT_POVTOR'
    end
    object DokumentREPORT_SIZE: TStringField
      FieldName = 'REPORT_SIZE'
      Size = 5
    end
    object DokumentSVID_GISRN: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'SVID_GISRN'
    end
    object DokumentLANG: TSmallintField
      FieldName = 'LANG'
    end
    object DokumentRUKOV_D: TStringField
      FieldName = 'RUKOV_D'
      Size = 200
    end
    object DokumentSPEC_D: TStringField
      FieldName = 'SPEC_D'
      Size = 200
    end
    object DokumentCOVER_MESSAGE_ID: TStringField
      FieldName = 'COVER_MESSAGE_ID'
      Size = 36
    end
    object DokumentCOVER_MESSAGE_TIME: TDateTimeField
      FieldName = 'COVER_MESSAGE_TIME'
    end
    object DokumentREQUEST_IN: TStringField
      FieldName = 'REQUEST_IN'
      Size = 14
    end
    object DokumentCOUNT_RESH_SUD: TIntegerField
      FieldName = 'COUNT_RESH_SUD'
    end
    object DokumentDATE_POST_GIS: TDateTimeField
      FieldName = 'DATE_POST_GIS'
    end
    object DokumentDATE_EDIT_GIS: TDateTimeField
      FieldName = 'DATE_EDIT_GIS'
    end
  end
  object frDBDokument: TfrDBDataSet
    DataSet = Dokument
    Left = 512
    Top = 98
  end
  object HistZAGS: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexName = 'HistZAGSIndex'
    IndexDefs = <
      item
        Name = 'HistZAGSIndex'
        Fields = 'fieldname;dateizm'
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.52'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 360
    Top = 66
    object HistZAGSFieldName: TStringField
      FieldName = 'FieldName'
      Size = 15
    end
    object HistZAGSValue: TStringField
      FieldName = 'Value'
      Size = 70
    end
    object HistZAGSStringValue: TStringField
      FieldName = 'StringValue'
      Size = 200
    end
    object HistZAGSDateIzm: TDateTimeField
      FieldName = 'DateIzm'
    end
    object HistZAGSTypeDate: TSmallintField
      FieldName = 'TypeDate'
    end
    object HistZAGSDatePropis: TSmallintField
      FieldName = 'DatePropis'
    end
    object HistZAGSInfo: TStringField
      FieldName = 'Info'
      Size = 200
    end
  end
  object dsSeria: TDataSource
    Left = 640
    Top = 210
  end
  object dsObl: TDataSource
    DataSet = dmBase.LookupObl
    Left = 464
    Top = 234
  end
  object SvidPovtor: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexFieldNames = 'SVID_DATE;SVID_NOMER'
    IndexDefs = <
      item
        Name = 'SvidPovtorIndex1'
        Fields = 'SVID_DATE;SVID_NOMER'
        Options = [ixUnique]
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.52'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 696
    Top = 50
    object SvidPovtorSVID_DATE: TDateField
      FieldName = 'SVID_DATE'
    end
    object SvidPovtorSVID_SERIA: TStringField
      FieldName = 'SVID_SERIA'
      Size = 6
    end
    object SvidPovtorSVID_NOMER: TStringField
      FieldName = 'SVID_NOMER'
      Size = 7
    end
    object SvidPovtorSVID_SERIA_L: TStringField
      FieldKind = fkLookup
      FieldName = 'SVID_SERIA_L'
      LookupDataSet = dmBase.SvidSeria
      LookupKeyFields = 'SERIA'
      LookupResultField = 'SERIA'
      KeyFields = 'SVID_SERIA'
      Size = 6
      Lookup = True
    end
    object SvidPovtorFIRST: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'FIRST'
    end
    object SvidPovtorWHO_SVID: TStringField
      FieldName = 'WHO_SVID'
      Size = 1
    end
    object SvidPovtorGISRN: TSmallintField
      DefaultExpression = '0'
      FieldName = 'GISRN'
    end
  end
  object dsPovtor: TDataSource
    DataSet = SvidPovtor
    OnDataChange = dsPovtorDataChange
    Left = 592
    Top = 130
  end
  object dsRN: TDataSource
    DataSet = dmBase.LookupRN
    Left = 640
    Top = 162
  end
  object dsGorod: TDataSource
    DataSet = dmBase.LookupGorod
    Left = 600
    Top = 250
  end
  object dsRnGor: TDataSource
    DataSet = dmBase.LookupRnGor
    Left = 552
    Top = 234
  end
  object dsTypeGorod: TDataSource
    DataSet = dmBase.TypePunkt
    Left = 648
    Top = 114
  end
  object ImGISUN: TImageList
    Left = 404
    Top = 75
    Bitmap = {
      494C01010C000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFBFF00FFF9FC00FFFEFF00FFFF
      FE00FAFBF900FBFFFC006C767000F6FFFC00F4FFFE00F4FFFF00E9F1F100F8FE
      FF00FAFCFF00FBFCFF00F9F4FF00FFFAFF000000000000000000000000000000
      0000000000000000000000000000000000000000000086595900865959000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFCFF00FFFCFF00F0ECF200E4E5
      E900FAFFFF00697275009AA7A900D8E7E900E6F5F700F3FFFF00F4FFFF00E7ED
      F200FBFDFF00FDFCFF00F6F1FA00FFFBFF000000000000000000000000000000
      0000000000000000000000000000000000006D485B000F0A6400634356008659
      5900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D6A5B00806D5F00816F600082706100000000000000
      000000000000000000000000000000000000F3F3FF00EEEFFD00F6FCFF00F3FC
      FF00EDFCFF00EAFAFF004C61700071869500EAFDFF00ECFEFF00E3EFF900F5FD
      FF00FDFEFF00F9F6F800FFFEFE00FFFEFE000000000000000000000000000000
      00000000000000000000000000006D485B000705650016168E00070565006343
      5600865959000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2BBAF00D1C3B200DECCBE00C7B5A600AE9B8C00A79C91000000
      000000000000000000000000000000000000F3FBFF00F1FBFF00DBEAFD008C9E
      B50050668200445E7C00627E9D00334F6E004A658000E4FAFF00ECFCFF00949D
      A7007F808400FFFFFC00FFFEF500FFFBF1000000000000000000000000000000
      000000000000000000006E4A5D000E0B6D003030B0004848D6003030B0000E0B
      6D00644457008659590000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000A2988B00A1978B00A0978B00A39A8D00A79E9200927F6F000000
      000000000000000000000000000000000000E4F5FF00E4F7FF00E3FAFF004762
      84005D7DA6002A4C7A003D6294007699CB005778A600DCF6FF005B708C00818E
      9E00FBFEFF00FFFFF900F4EBDD00FFFFF0000000000000000000000000000000
      000000000000734E6300252389004141BF005555DD005555DD005555DD004141
      BF002523890069495D0086595900000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      000000000000BFB19C00CFBFAD00DBC7B700C4B0A000AC978700947D6B000000
      000000000000000000000000000000000000E8FCFF0060788C00DCF7FF005E7E
      A200002557006890CA001F4A89001D4788005E85C3006B8DC200708AB2008395
      AC00ECF4FB00FFFFFB00FFFFF200FFFFE8000000000000000000000000008E65
      650062455A0038369F005A5AD4007575EB007272EA006363E4007272EA007575
      EB005A5AD4003937A0006D4D62008C5D5D000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000AB937F00A4928100A2928200A3938300A796860096755E000000
      00000000000000000000000000000000000070858D00748B9A005A758F005C7E
      A20043699F001F4B8B0071A0EA001D4E9A0027549D00739BDC00597AAC00425B
      7D00EDFDFF00FAFFFF00FCFBED00FFFEE900000000000000000000000000365E
      5A004349B3004747BB004747BB004747BB009393F4007171EB009393F4004747
      BB004747BB004747BB004C49B60000000000000000000000000080808000FFFF
      FF00000000000000000000FFFF0000808000008080000000000000000000FFFF
      FF00808080008080800000000000000000000000000000000000000000000000
      00000000FF00DADAFF00EFEFFF00EFEFFF00EFEFFF00EFEFFF00DADAFF000000
      FF0000000000000000000000000000000000F1FFFF00E3F5FC0070889A004968
      89007297CB00174383002354A00073A5F7003768B8002E59A20088ADE7005D7B
      A40050657B0079858B008F978D00B4B7A7000000000000000000000000000066
      330000BF7F0000B9670000BF7F005555CC00ABABF9007E7EF200ABABF9005555
      CC00895C5C0000000000000000000000000000000000000000000000000000FF
      FF000000000000FFFF000080800000FFFF0000808000008080000000000000FF
      FF00000000008080800000000000000000000000000000000000000000000000
      FF00BABAFF00A6D1DA00DADAFF00DADAFF00DADAFF00DADAFF00A7D1DA00EFEF
      FF000000FF00000000000000000000000000F9FFF700F6FFFE00E0F1FA006980
      9A007796C3005F87C2001A479000396ABA006E9FEF004F7CC6006089C70089AB
      D9006D87A5008A9DAA007D8B8A00F8FFFB000000000000000000000000000067
      340000C07F0000AB650000C07F006060D900BBBBFC008C8CF800BBBBFC006060
      D900895C5C0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF000080800000000000FFFF
      FF000000000080808000000000000000000000000000000000000000FF009595
      FF00BABAFF008EB9BD00DADAFF00DADAFF00DADAFF00DADAFF008EB9BD00BABA
      FF009595FF000000FF000000000000000000FFFFF400FCFFF500F6FFFF00D6E6
      F700DDF7FF007A9BCD00739BDC003560A9004471BB007FABF2006189C400BADC
      FF00AAC6E500D8EEFF00EDFFFF0098A8A700885F5F007A5252007A5252000069
      360000DFA40000BE7C0000DFA4006767E200C3C3FF00B9B9FF00C3C3FF006767
      E2009362620000000000000000000000000000000000FFFFFF000000000000FF
      FF0000000000FFFFFF0000FFFF0000FFFF000080800000FFFF000000000000FF
      FF000000000000000000000000000000000000000000000000000000FF00BABA
      FF00BABAFF007DABB300BABAFF0082B3BB0082B3BB00BABAFF007DABB300BABA
      FF00BABAFF000000FF000000000000000000FBF4E100FFFFF500FFFFFC00F4FD
      FF00687993007D97BF005B7CAE007DA3DD00658CCA0086AEE900C3E8FF00B8D8
      FF00DCF6FF00A1B6CB00E9F9FF008292980000996600006D3A00006D3A00006D
      3A0000E8B00000D1940000E8B000436BA5006A6AE5006A6AE5006A6AE5007469
      B3000000000000000000000000000000000000000000FFFFFF0080808000FFFF
      FF000000000000000000FFFFFF00FFFFFF0000FFFF000000000000000000FFFF
      FF008080800000000000000000000000000000000000000000000000FF00BABA
      FF00BABAFF00DADAFF0089B9C300DADAFF00DADAFF0089B9C300DADAFF00BABA
      FF00BABAFF000000FF000000000000000000FFFFF200FFFFF500FFFFFB009A9E
      A300828F9F0095A8C3006680A5004E6E99007293C000B6D8FF00BBD8FF00DFF8
      FF00677B940000081900EEFAFF0099A4AC007C685F000099660000E5B10000EE
      B70000E3AA0000E3AA0000E3AA0000EEB70000E5B100009966007C685F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000000000000000FF00BABA
      FF00BABAFF00DADAFF00DADAFF00DADAFF00DADAFF00DADAFF00DADAFF00BABA
      FF00BABAFF000000FF000000000000000000FFFFF800FFFFF900FFFCFB00A6A7
      AB00F4FDFF00DAE9F900E8FBFF005A728A009CB3CD00A7BDD600E1F6FF004F5E
      7100030E1C00444B540054585D0080838700000000007C6A60000099660000FF
      CC0000F9C50000F5C00000F9C50000FFCC00009966007C6A6000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF009595
      FF00BABAFF00DADAFF00DADAFF00DADAFF00DADAFF00DADAFF00DADAFF00BABA
      FF009595FF000000FF000000000000000000FEF3F500FFFBFC00FFFDFF00FDFE
      FF00E8EEF300F4FEFF00EFFFFF0093A4AD0095A4AD00D7E3ED00F3FEFF004147
      4C0035363A007B787A00716B6C00968E8E0000000000000000007C6B62000099
      660000FFCC0000FFCC0000FFCC00009966007C6B620000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF009595FF00EFEFFF00EFEFFF00EFEFFF00EFEFFF00EFEFFF00EFEFFF009595
      FF000000FF00000000000000000000000000FFFBFF00F0EBF400FFFDFF00FDFD
      FF00F1F6F900F0F8F800BDC8C6007C8784009FA9A300F8FEF900FAFCF600FFFF
      F900564E4700877B7500FFFFF900FFFEF9000000000000000000000000007C6E
      64000099660000FFCC00009966007C6E64000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF009595FF00F4FEFF00FFFFFF00FFFFFF00F4FEFF009595FF000000
      FF0000000000000000000000000000000000F4EFFE00FFFBFF00F1F0FA00E9EC
      F100FBFFFF00EDF4F100FAFFFB00D8E0D500FBFFF600FFFFF700BDBCAE00C4BE
      B100BAAEA200B4A49800FFFCF400FFFEF6000000000000000000000000000000
      00007C706600009966007C706600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000008BA5F2006F6CCF00BFB2
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFED00FFF6D600FFC48C00DE9C
      4D00D5933400D7992F00D39D3200C4932700C6922700CF972C00DC9A3100E39E
      3D00DD954800FFD09900FFE9CA00FFFFED000000000000000000000000000000
      00000000000000000000D2D4FF0032347B0030327900CACCFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002F6E30000F690F00006E0000007A00000075000000600000136D13001251
      1300000000000000000000000000000000007891E1002C3D9300232280002A22
      7900BEBEFE006169A50027368500081B6C006476B700C8D6FF00000000000000
      000000000000000000000000000000000000FFE9C500D09A6B00B4732F00D188
      3400E1943400E99D3900F1AA4900E29E3F00EAA54800F0A64600E8973400E290
      3100C4762300BC753200C88D5F00FFF6D1000000000000000000000000000000
      000000000000B8BBF2003D3E88006568B9005B5EAF0033368000C3C6FD000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003877390081D97F0061D05E0069E4660074EF710069D866008BE389002463
      250000000000000000000000000000000000191679006462C200494AA4003B43
      9C00000E6F0009208D002742BB001931AD0016249500676FBC00F5FAFF000000
      000000000000000000000000000000000000FFD78E00C1843400D1822700FDA1
      4200ED862900E67C2500F38A4100E57C3900DD733300EE853C00F3863000FF9E
      4100FFB05100E1923700B7782800FFCF83000000000000000000000000000000
      0000CACEFF003D438A005D5FBD005051B900494AB2005557B50041458C00C2C9
      FB00000000000000000000000000000000000000000000000000000000000000
      0000185515007CD379003BA4350037AB300046BA3F0053BC4D0082D97F000C49
      090000000000000000000000000000000000AC9BF6002D247F007C84DE002037
      9A00284DBD000730AE00153AC4002B48D3004754D6006064BD00959CAD000000
      000000000000000000000000000000000000D08C3300BD711700E2882900EC89
      2D00D66D1C00E87F3C00FC966600F1906A00FB9A7400FF9E6E00F1894600E37D
      2B00F9993C00F19B3B00C27B2000D6973D00000000000000000000000000C0CA
      F2003B4287005459B4004C4EBE002427A1002A2DA7004549B9004B50AB003139
      7C00C1C8F3000000000000000000000000000000000000000000000000000000
      000033722D0090E5890046AC3D0036A42C003BA931005EC5560089DE82002665
      200000000000000000000000000000000000000000009695D900202F95001F43
      B5001D56C3001C5BCB001749C7002243C2005D6BDC00292D7B00ECF2FF000000
      000000000000000000000000000000000000EA8D3E00E1823200E5823000D071
      2700EB955900FFDEB400FFF2DF00FFF6EE00FFFCF400FFF8E400FFE3B700EA9D
      5F00D9833700EB933F00E8964400E99847000000000000000000C1CBF3003B44
      83005B60BB00464CBD001D21A500181BA6001E21AC001F23A7004246B700555D
      B7003A438200C0CAF20000000000000000000000000000000000000000000000
      000032742C008FE587003A9D2F0038A32E0039A42F0051B7480080D678002163
      1B0000000000000000000000000000000000000000006B71B4002A3FB200345C
      DD00104FC1001151C100305CD900728CFF002F3A96009BA0DF0000000000E4E9
      FE00A0A6B900000000000000000000000000F48D3E00E27E2C00DC792700C66E
      2200F3A96F00FFF7D000FFFCEC00FFFEF900FFFEF900FFFDEC00FFFED500F5B7
      7B00DA8F4100E08D3800E7934100DF8B390000000000BEC2FC004C529500575C
      B1004344B6002A2EB200171BA9001B1FB300171BAF001E22B0002F31B500474B
      BC005358AD003B418400C2C4FE00000000000000000000000000000000000000
      00002770200084DE7B00288C1C004CB63E004DB73F003EA2320078D26F001760
      1000000000000000000000000000000000000000000039469C003049C9002A50
      DE002B5EDD004C78F5006979FF0023269900A1A5E60000000000BFC3FF002C30
      7F001A1C7A006B70C500AEB9EB0000000000EB8A3000D8791C00F0923300E18B
      3100F6B06300FFFFC700FFFFDF00FFFCE100FFFFEA00FFFFE200FFFFC600E6AD
      5E00E5A04300EBA03E00E89B3E00E2983A00C3B8FF00382F90006C68C8005E5D
      CB003935BC003130C2001D1FB3001017AA000910A3001E22B6002B2ABC003F3B
      C2005F5CCA005B59B9003D349500CBC0FF000000000000000000000000000000
      0000398B320083DF78002088130036A3290039A62C00319924007BD770002678
      1F0000000000000000000000000000000000000000000C1D7400677DFF004964
      F4005174F400657EF600282B9E009A96F60000000000C5C9FF00101B7700101D
      9100313BC400222DA6005D6CB50000000000FA9B3A00D6781500F1942D00D17C
      1800D28B3400FFF1AA00FFF7C600D9C59C00D5C29C00FFFFCB00FFF6AF00CB93
      3A00E3A03900EDA33900DE942E00DC942E003E2B9F007E6EDD008A80EA00807B
      EE008981FF006E69FF002727B900161CAB00161CAB002225B6005550E700867E
      FF008B83F8008780E9008878E7003A2899003E723C003973380030712C003783
      31001D7616007DE0740037A32B00249418002D9D210046B23A0076D96D000059
      0000236F1D001F601B001D571C00255C25000000000012216A007580FA007B85
      FF007D8AFE001F2A8600A3A7E80000000000B7B2FF00171A8D00132CA4001033
      B3002A45D5002A40C2000818710000000000FE9A3400DC791100ED8B1F00E188
      2000E79C4000C48C3F00BE9A6400FFE8BA00FFEBBE00CFB27900C1934600E5A8
      4A00E49C3100F0A13200E6982D00E69B2F00442E9800332388002F2681002C25
      8D0022169E008078FF001B1AA6001A1DA4001C1FA6002A29B500594FE2001C12
      9A003B349D002C237E00311F8400453097003A76390086C9860093DD910078CC
      740073D16C0061C958002A991F00249718002497180037A62C005EC6550073D1
      6C006EC26A0077C175007ABD7A002564260000000000B9C4F600262B80006F71
      CF003A3E8D00AAAEEF0000000000AFB3F400131689002737BF002450CD001245
      C4001036C4005069E9001E2B810000000000F68D2600ED871D00FFA23600EF91
      2D00CC7E2400D2974F00FFECBB00FFFBD300FFFFD700FFFFD200D6A55B00CD8C
      3000F2A33C00FFB44600F9A43700E8942A000000000000000000000000000000
      00002E239F007F74FF00171198001D1D9F0018189A00110E93005C50DE003C31
      AD0000000000000000000000000000000000BEFABD00387B380078C276007BCF
      77005FBD580059C0510042B33A0039AE31002FA427003AAB32003CA3340046A4
      3F0064B860005FA95D0034773400B4F3B5000000000000000000E1E5F8008B91
      A400DFE4F90000000000BCC1FF001D288400253FB500214DCA000C4CBC002B6A
      DC002E56D700354ABD00696FB20000000000FF902F00F3842200F68A2500F693
      3700DC883C00D6965C00FFFFDE00FFFFEB00FFFFEB00FFFFE200E2AA6F00EAA2
      5400FFAA4C00FA9B3400F5953100ED8D29000000000000000000000000000000
      000021167E009286FF00554DCF005551CF004541BF003A33B2006E60E4002B22
      8A000000000000000000000000000000000000000000ADE7AD00478A450076C3
      720078D273005FC359003EAB37003FB0370049BA410041AE3A004BAF450067C1
      62006DBA690043864100B6F0B600000000000000000000000000000000000000
      00000000000000000000292D7B002C3AAB003253D2002456D4002B6ADA001A53
      C0003357C90023329800ADACF00000000000F58F2F00F68F2E00F0852300F089
      2C00F99C4D00D6864B00FEBF9900FFF9DE00FFFFE600FFD2AB00E0945900F7A2
      5200ED8F3000F2922E00FFA34000F69E3A000000000000000000000000000000
      00002A207D008D7FFD006058D5004741BE004741BE005A52CF007769E700352B
      8800000000000000000000000000000000000000000000000000BCF0BA004B8B
      490081CF7C0077D172004CB1470047B0410049B2430048AD430069C3640075C5
      720047874500BAEEB80000000000000000000000000000000000000000000000
      000000000000AEB5C6003F439C007683FF004966F1003257E1005982FF006F94
      FF006077DA005058B2001D146F00AE9FFA00DB943200E5973200FFAA3E00F28C
      2200FF933400F3863800F8905500FFB98800FFBE8C00FF9A5F00FF994B00FFA3
      4400FF9F3400FFBF5300ECA23C00D89630000000000000000000000000000000
      00003C338E008E7FFF006159D6005D57D4005B55D2006D65E2008172F2003E35
      900000000000000000000000000000000000000000000000000000000000BCEB
      BA004482400075C2710081DA7D0063C35F0054B4500070C96C006AB766003A7A
      3800BAE9B8000000000000000000000000000000000000000000000000000000
      000000000000000000007981CE00606EDF008EA6FF007C97FF00384FBC002738
      99007D85DE008081DB009492F20028258800F8C77900B1782300E2963600F79D
      3800FFA03D00FFA04500FF9C4D00FC964E00F48E4600FF984900FFAE5300FFAD
      4A00FFAD4800F4A84800AE721E00EDBA6A000000000000000000000000000000
      00002A2281008A7CFF005A51D000736FEC00605CD9005D56D5007C6EF200261E
      7D00000000000000000000000000000000000000000000000000000000000000
      0000B9EAB800458543007CC9780077CD750078CB760077C4730049894700B8E9
      B700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000ABB9E3007486C7001C2F800029388700777FBB00B3B3
      F300282077007D7CDA003F50A600859EEE00FFF6D400BA906300BD864300DF9E
      4D00F3AE5100E7A24100E8AA4C00D59A3D00E3A84B00E8AA4C00EAA34200E198
      3C00CB863600BE824000BC8B5F00FFFFE0000000000000000000000000000000
      000033299400897CFF00726DEE008684FF008381FD007570F1008B7CFF003C34
      9F00000000000000000000000000000000000000000000000000000000000000
      000000000000B3E7B1004285400076C1750080C9800040833E00BAEEB8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C4B4FF006967C70099B2FF0000000000FFF7E900FFF1D700E4B78400C08D
      4400CB963C00B4821E00C99F3A00C49E3800BB952F00C2983300CB943100D79E
      4300C78C4600EEBB8900FFE2CA00FFF3E7000000000000000000000000000000
      0000291F91003B2DBB003631B4002929A5003434B0002E29AC00382AB8003329
      9B00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C7FFC600337933003D833D00C4FFC300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00808080008080800080808000808080008080800000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000FFFFFF00FFFFFF00FFFFFF00808080008080
      800000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      000000000000FFFFFF00808080008080800080808000FFFFFF00FFFFFF00FFFF
      FF008080800000000000FFFFFF00000000000000000000000000000000000000
      0000000000008080800000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000080808000FFFFFF000000
      000080808000808080008080800080808000808080008080800080808000FFFF
      FF00FFFFFF0080808000FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF00FAAA0400FFFFFF00FAAA0400FFFFFF00000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000FF00FFFFFF000000FF00FFFFFF00000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FF0000FFFFFF0000FF0000FFFFFF00000000008080
      8000808080000000000000000000000000000000000080808000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000FFFFFF008080800000000000FFFFFF000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      00008080800000000000000000000000000080808000FFFFFF00000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000FFFFFF00FFFFFF0080808000FFFFFF00000000000000000080808000FFFF
      FF000000000000000000FAAA0400FF000000FF0000000000000000000000FFFF
      FF0080808000808080000000000000000000000000000000000080808000FFFF
      FF0000000000000000000000FF0000008000000080000000000000000000FFFF
      FF0080808000808080000000000000000000000000000000000080808000FFFF
      FF00000000000000000000FF000000800000008000000000000000000000FFFF
      FF008080800080808000000000000000000080808000FFFFFF00808080008080
      800080808000FFFFFF0000000000000000000000000000000000808080008080
      800080808000FFFFFF0080808000FFFFFF00000000000000000000000000FAAA
      040000000000FAAA0400FF000000FAAA0400FF000000FF00000000000000FAAA
      0400000000008080800000000000000000000000000000000000000000000000
      FF00000000000000FF00000080000000FF000000800000008000000000000000
      FF000000000080808000000000000000000000000000000000000000000000FF
      00000000000000FF00000080000000FF000000800000008000000000000000FF
      00000000000080808000000000000000000080808000FFFFFF00808080008080
      800080808000FFFFFF0000000000000000000000000000000000808080008080
      800080808000FFFFFF0080808000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FAAA0400FAAA0400FAAA0400FAAA0400FF00000000000000FFFF
      FF000000000080808000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000FF000000FF000000FF000000FF000000800000000000FFFF
      FF000000000080808000000000000000000000000000FFFFFF0000000000FFFF
      FF000000000000FF000000FF000000FF000000FF00000080000000000000FFFF
      FF000000000080808000000000000000000080808000FFFFFF00808080008080
      800080808000FFFFFF00FFFFFF00000000000000000000000000808080008080
      8000808080000000000080808000FFFFFF0000000000FFFFFF0000000000FAAA
      040000000000FFFFFF00FAAA0400FAAA0400FF000000FAAA040000000000FAAA
      04000000000000000000000000000000000000000000FFFFFF00000000000000
      FF0000000000FFFFFF000000FF000000FF00000080000000FF00000000000000
      FF000000000000000000000000000000000000000000FFFFFF000000000000FF
      000000000000FFFFFF0000FF000000FF00000080000000FF00000000000000FF
      0000000000000000000000000000000000008080800000000000FFFFFF008080
      80008080800080808000FFFFFF00FFFFFF00FFFFFF0080808000808080008080
      8000FFFFFF0000000000808080000000000000000000FFFFFF0080808000FFFF
      FF000000000000000000FFFFFF00FFFFFF00FAAA04000000000000000000FFFF
      FF008080800000000000000000000000000000000000FFFFFF0080808000FFFF
      FF000000000000000000FFFFFF00FFFFFF000000FF000000000000000000FFFF
      FF008080800000000000000000000000000000000000FFFFFF0080808000FFFF
      FF000000000000000000FFFFFF00FFFFFF0000FF00000000000000000000FFFF
      FF00808080000000000000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000808080008080800080808000808080008080
      80000000000080808000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00808080008080800080808000808080008080800080808000808080000000
      0000000000008080800000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF00FAAA0400FFFFFF00FAAA0400FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF000000FF00FFFFFF000000FF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000FF0000FFFFFF0000FF0000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000FFFFFF00FFFFFF008080800080808000808080000000000000000000FFFF
      FF0080808000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      80008080800000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF9FFFFFFFFF0000FF0FF83FFC3F
      0000FE07E60FF81F0000FC03D807F81F0000F801B003F81F0000E000A003F81F
      0000E0014001F00F0000E0074001E0070000E0070001C003000000070005C003
      0000000F0005C0030000001FA00BC0030000803F901BC0030000C07FC837E007
      0000E0FFE0CFF00F0000F1FFF83FF81F8FFF0000FC3FF00F003F0000F81FF00F
      001F0000F00FF00F001F0000E007F00F801F0000C003F00F802700008001F00F
      804100000000F00F8081000000000000810100000000000082010000F00F0000
      C4010000F00F8001FC010000F00FC003F8000000F00FE007FC000000F00FF00F
      FC000000F00FF81FFFF10000F00FFC3FFC1FFFFFFFFFFFFFF027F83FF83FF83F
      E60BE60FE60FE60FD805D807D807D8079001B003B003B003A002A003A003A003
      238040014001400103C040014001400103C000010001000101C4000500050005
      40050005000500058009A00BA00BA00BA01B901B901B901BD067C837C837C837
      E40FE0CFE0CFE0CFF83FF83FF83FF83F00000000000000000000000000000000
      000000000000}
  end
  object dsVoenkom: TDataSource
    DataSet = dmBase.SprVoenkom
    Left = 680
    Top = 90
  end
  object dsRovd: TDataSource
    DataSet = dmBase.SprRovd
    Left = 688
    Top = 122
  end
  object frDBPovtSvid: TfrDBDataSet
    DataSet = SvidPovtor
    Left = 592
    Top = 58
  end
  object kbmCSVStreamFormat1: TkbmCSVStreamFormat
    CSVQuote = #0
    CSVFieldDelimiter = #20
    CSVRecordDelimiter = #0
    CSVTrueString = 'True'
    CSVFalseString = 'False'
    sfLocalFormat = []
    sfQuoteOnlyStrings = []
    sfNoHeader = []
    Version = '3.00'
    sfData = [sfSaveData, sfLoadData]
    sfCalculated = []
    sfLookup = []
    sfNonVisible = [sfSaveNonVisible, sfLoadNonVisible]
    sfBlobs = [sfSaveBlobs, sfLoadBlobs]
    sfDef = []
    sfIndexDef = [sfSaveIndexDef, sfLoadIndexDef]
    sfPlaceHolders = []
    sfFiltered = [sfSaveFiltered]
    sfIgnoreRange = [sfSaveIgnoreRange]
    sfIgnoreMasterDetail = [sfSaveIgnoreMasterDetail]
    sfDeltas = []
    sfDontFilterDeltas = []
    sfAppend = []
    sfFieldKind = [sfSaveFieldKind]
    sfFromStart = [sfLoadFromStart]
    Left = 632
    Top = 58
  end
  object Zip: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clFastest
    CompressionMode = 1
    CurrentVersion = '4.03 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = False
    SpanningOptions.VolumeSize = vsAutoDetect
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    Zip64Mode = zmDisabled
    UnicodeFilenames = True
    EncryptionMethod = caPkzipClassic
    Left = 760
    Top = 74
  end
  object tbReshSud: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.52'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 720
    Top = 298
    object tbReshSudFIO: TStringField
      FieldName = 'FIO'
      Size = 60
    end
    object tbReshSudID: TStringField
      FieldName = 'ID'
    end
    object tbReshSudTYPE_RESH: TSmallintField
      FieldName = 'TYPE_RESH'
    end
    object tbReshSudDATE_RESH: TDateField
      FieldName = 'DATE_RESH'
    end
    object tbReshSudSUD: TStringField
      FieldName = 'SUD'
      Size = 200
    end
    object tbReshSudTEXT: TStringField
      FieldName = 'TEXT'
      Size = 500
    end
    object tbReshSudCANCEL: TBooleanField
      FieldName = 'CANCEL'
    end
  end
end
