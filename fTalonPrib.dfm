inherited fmTalonPrib: TfmTalonPrib
  Left = 377
  Top = 97
  Caption = #1058#1072#1083#1086#1085' '#1087#1088#1080#1073#1099#1090#1080#1103
  ClientHeight = 691
  ClientWidth = 737
  Constraints.MinHeight = 706
  Constraints.MinWidth = 753
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000444
    60000044400000AA400000024000000246000002400000022400006A60000000
    AA4462A4000000002AA222460000000006AAA22660000044466AA4064000006A
    246A240640000000A24AA442400000000A2AA2AA000000000022AAA400000000
    0044A40000000000006A240000000000006AA4000000000000066600000087C7
    0000C7E70000E3E70000E3C70000F00F0000F00F0000F8070000C0270000C027
    0000F0070000F80F0000FC0F0000FC3F0000FC3F0000FC3F0000FE3F0000}
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited sp: TSplitter
    Top = 669
    Width = 737
    Height = 0
    Align = alBottom
    Visible = False
  end
  inherited pnTable: TPanel
    Top = 669
    Width = 737
    Height = 0
    Align = alBottom
    Visible = False
  end
  inherited TBDock: TTBDock
    Width = 737
    inherited TBToolbar: TTBToolbar
      object TBItemUbit: TTBItem [9]
        Caption = #1058#1072#1083#1086#1085' '#1091#1073#1099#1090#1080#1103
        HelpContext = 1
        Hint = #1042#1099#1087#1080#1089#1072#1090#1100' '#1090#1072#1083#1086#1085' '#1091#1073#1099#1090#1080#1103
        ImageIndex = 47
        OnClick = TBItemUbitClick
      end
      inherited TBItemPerekl: TTBItem
        Visible = False
      end
      inherited TBItemShablon: TTBItem
        Visible = True
      end
      inherited TBToolbarOrgan: TTBToolbar
        Left = 733
        Top = 22
      end
    end
  end
  inherited sb: TScrollBox
    Width = 737
    Height = 619
    Align = alClient
    inherited pnPovtor: TPanel
      TabOrder = 2
    end
    inherited N_F_edTypeEkz: TComboBox
      TabOrder = 3
    end
    object pn: TPanel
      Left = 0
      Top = 0
      Width = 737
      Height = 33
      Align = alTop
      TabOrder = 0
      object Label38: TLabel
        Left = 13
        Top = 9
        Width = 99
        Height = 13
        Caption = #1058#1072#1083#1086#1085' '#1089#1086#1089#1090#1072#1074#1083#1077#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edDate_SOST: TDBDateTimeEditEh
        Left = 127
        Top = 5
        Width = 119
        Height = 26
        DataField = 'DATE_SOST'
        DataSource = dsDokument
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        Kind = dtkDateEh
        ParentFont = False
        TabOrder = 0
        Visible = True
      end
      object edTypeReg: TDBComboBoxEh
        Left = 402
        Top = 5
        Width = 316
        Height = 26
        DataField = 'TYPEREG'
        DataSource = dsDokument
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = True
        OnChange = edTypeRegChange
        OnUpdateData = edTypeRegUpdateData
      end
    end
    object pc: TPageControl
      Left = 0
      Top = 33
      Width = 737
      Height = 586
      ActivePage = ts1
      Align = alClient
      TabOrder = 1
      object ts1: TTabSheet
        Caption = #1063#1072#1089#1090#1100' 1'
        object pnLast: TPanel
          Left = 0
          Top = 382
          Width = 729
          Height = 171
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object Label35: TLabel
            Left = 12
            Top = 5
            Width = 204
            Height = 13
            Caption = #1054#1088#1075#1072#1085' '#1086#1092#1086#1088#1084#1083#1103#1102#1097#1080#1081' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1102
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label24: TLabel
            Left = 6
            Top = 149
            Width = 82
            Height = 13
            Caption = #1062#1077#1083#1100' '#1087#1088#1080#1077#1079#1076#1072
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BtRB: TImage
            Left = 49
            Top = 136
            Width = 13
            Height = 17
            Picture.Data = {
              07544269746D6170E6000000424DE60000000000000076000000280000000A00
              00000E0000000100040000000000700000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFF000000FFFFFFFFFF000000F000000FFF000000F0FFFFF0FF00
              0000F0FFFFF0FF000000F0FFFFF0FF000000F0FFFFF0FF000000F000000FFF00
              0000F0FFFFFFFF000000F0FFFFFFFF000000F0FFFFFFFF000000F000000FFF00
              0000FFFFFFFFFF000000FFFFFFFFFF000000}
            Visible = False
          end
          object btRF: TImage
            Left = 5
            Top = 136
            Width = 13
            Height = 17
            Picture.Data = {
              07544269746D6170E6000000424DE60000000000000076000000280000000A00
              00000E0000000100040000000000700000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFF000000FFFFFFFFFF000000FFF0FFFFFF000000FFF0FFFFFF00
              0000FFF0FFFFFF000000FFF0FFFFFF000000FFF00000FF000000FFF0FFF0FF00
              0000FFF0FFF0FF000000FFF0FFF0FF000000FFF0FFF0FF000000FFF00000FF00
              0000FFFFFFFFFF000000FFFFFFFFFF000000}
            Visible = False
          end
          object btU: TImage
            Left = 29
            Top = 136
            Width = 13
            Height = 17
            Picture.Data = {
              07544269746D6170E6000000424DE60000000000000076000000280000000A00
              00000E0000000100040000000000700000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFF000000FFFFFFFFFF000000FFF00000FF000000FFFFFFF0FF00
              0000FFFFFFF0FF000000FFFFFFF0FF000000FFF00000FF000000FFF0FFF0FF00
              0000FFF0FFF0FF000000FFF0FFF0FF000000FFF0FFF0FF000000FFF0FFF0FF00
              0000FFFFFFFFFF000000FFFFFFFFFF000000}
            Visible = False
          end
          object Label25: TLabel
            Left = 366
            Top = 149
            Width = 27
            Height = 13
            Caption = #1089#1088#1086#1082
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label42: TLabel
            Left = 548
            Top = 149
            Width = 16
            Height = 13
            Caption = #1076#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object gbPribil: TGroupBox
            Left = 0
            Top = 28
            Width = 725
            Height = 99
            Caption = ' '#1054#1090#1082#1091#1076#1072' '#1087#1088#1080#1073#1099#1083' '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            object Label13: TLabel
              Left = 8
              Top = 16
              Width = 134
              Height = 13
              Caption = #1056#1077#1089#1087#1091#1073#1083#1080#1082#1072' ('#1075#1086#1089#1091#1076#1072#1088#1089#1090#1074#1086')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 406
              Top = 16
              Width = 76
              Height = 13
              Caption = #1086#1073#1083#1072#1089#1090#1100' ('#1082#1088#1072#1081')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label22: TLabel
              Left = 110
              Top = 47
              Width = 30
              Height = 13
              Caption = #1088#1072#1081#1086#1085
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label23: TLabel
              Left = 406
              Top = 47
              Width = 82
              Height = 13
              Caption = #1075#1086#1088#1086#1076' ('#1089#1077#1083#1077#1085#1080#1077')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 268
              Top = 75
              Width = 28
              Height = 13
              Caption = #1076#1072#1090#1072' '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label21: TLabel
              Left = 437
              Top = 75
              Width = 79
              Height = 13
              Caption = #1087#1088#1086#1078#1080#1074#1072#1083' '#1090#1072#1084' '#1089
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object edGOSUD_O: TDBLookupComboboxEh
              Left = 152
              Top = 13
              Width = 207
              Height = 26
              DataField = 'GOSUD_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              KeyField = 'ID'
              ListField = 'NAME'
              ListSource = dsStran
              ParentFont = False
              TabOrder = 0
              Visible = True
            end
            object edGOROD_O: TDBEditEh
              Left = 577
              Top = 41
              Width = 131
              Height = 26
              DataField = 'GOROD_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Visible = True
            end
            object edDate_O: TDBDateTimeEditEh
              Left = 303
              Top = 69
              Width = 105
              Height = 26
              DataField = 'DATE_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              Visible = True
              EditFormat = 'DD/MM/YYYY      '
            end
            object DBCheckBoxEh1: TDBCheckBoxEh
              Left = 488
              Top = 15
              Width = 15
              Height = 17
              AllowGrayed = True
              DataField = 'B_OBL_O'
              DataSource = dsDokument
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 7
              TabStop = False
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
            object edGOROD_O_B: TDBLookupComboboxEh
              Left = 510
              Top = 41
              Width = 55
              Height = 26
              Alignment = taRightJustify
              DataField = 'GOROD_O_B'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              KeyField = 'ID'
              ListField = 'NAME'
              ListSource = dsTypeGorod
              ParentFont = False
              TabOrder = 3
              Visible = True
            end
            object edUlDom_O: TDBEditEh
              Left = 14
              Top = 69
              Width = 199
              Height = 26
              Hint = #1059#1083#1080#1094#1072', '#1076#1086#1084', '#1082#1086#1088#1087#1091#1089', '#1082#1074#1072#1088#1090#1080#1088#1072' '#1075#1076#1077' '#1087#1088#1086#1078#1080#1074#1072#1083
              DataField = 'UL_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Visible = True
            end
            object edRAION_O: TDBEditEh
              Left = 152
              Top = 41
              Width = 207
              Height = 26
              DataField = 'RAION_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Visible = True
            end
            object edOBL_O: TDBEditEh
              Left = 510
              Top = 13
              Width = 198
              Height = 26
              DataField = 'OBL_O'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Visible = True
            end
            object edGodProg: TDBEditEh
              Left = 534
              Top = 69
              Width = 127
              Height = 26
              DataField = 'GOD_PROG'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              Visible = True
            end
          end
          object edOrgan: TDBEditEh
            Left = 231
            Top = 1
            Width = 436
            Height = 26
            DataField = 'ORGAN'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object edCel: TDBLookupComboboxEh
            Left = 99
            Top = 143
            Width = 249
            Height = 26
            DataField = 'CEL'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            KeyField = 'ID'
            ListField = 'NAME'
            ListSource = dsCel
            ParentFont = False
            TabOrder = 2
            Visible = True
          end
          object edSrok: TDBEditEh
            Left = 406
            Top = 143
            Width = 127
            Height = 26
            DataField = 'SROK'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
          end
          object edDateSrok: TDBDateTimeEditEh
            Left = 574
            Top = 143
            Width = 116
            Height = 26
            HelpContext = 999
            DataField = 'DATE_SROK'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            Kind = dtkDateEh
            ParentFont = False
            TabOrder = 4
            Visible = True
          end
        end
        object pnLic: TPanel
          Left = 0
          Top = 324
          Width = 729
          Height = 58
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object lbOSNOV_ID: TLabel
            Left = 10
            Top = 8
            Width = 246
            Height = 13
            Caption = #1046#1080#1083#1086#1077' '#1087#1086#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1086' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lbOSNOV_DATE: TLabel
            Left = 533
            Top = 8
            Width = 12
            Height = 13
            Caption = #1086#1090
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lbNomer_osnov: TLabel
            Left = 534
            Top = 36
            Width = 13
            Height = 13
            Caption = #8470
          end
          object edOSNOV_ID: TDBComboBoxEh
            Left = 276
            Top = 2
            Width = 239
            Height = 26
            DataField = 'OSNOV_ID'
            DataSource = dsDokument
            DropDownBox.Rows = 15
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object edDate_Osnov: TDBDateTimeEditEh
            Left = 555
            Top = 2
            Width = 116
            Height = 26
            DataField = 'OSNOV_DATE'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = True
            EditFormat = 'DD/MM/YYYY      '
          end
          object edOsnov: TDBEditEh
            Left = 10
            Top = 30
            Width = 505
            Height = 26
            DataField = 'OSNOV'
            DataSource = dsDokument
            EditButtons = <
              item
                Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1072
                Style = ebsEllipsisEh
                OnClick = edOsnovEditButtons0Click
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Visible = True
          end
          object edNomer_Osnov: TDBEditEh
            Left = 556
            Top = 30
            Width = 112
            Height = 26
            DataField = 'OSNOV_NOMER'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
          end
        end
        object pnNewLic: TPanel
          Left = 0
          Top = 293
          Width = 729
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lbOtnosh: TLabel
            Left = 196
            Top = 10
            Width = 58
            Height = 13
            Caption = #1054#1090#1085#1086#1096#1077#1085#1080#1077
          end
          object Label47: TLabel
            Left = 532
            Top = 10
            Width = 13
            Height = 13
            Caption = #1076#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object N_F_cbNewLich: TDBCheckBoxEh
            Left = 9
            Top = 8
            Width = 173
            Height = 17
            Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1083#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090
            Enabled = False
            TabOrder = 0
            TabStop = False
            ValueChecked = 'True'
            ValueUnchecked = 'False'
            OnClick = N_F_cbNewLichClick
          end
          object edOTNOSH: TDBLookupComboboxEh
            Left = 263
            Top = 4
            Width = 166
            Height = 26
            Hint = #1054#1090#1085#1086#1096#1077#1085#1080#1077' '#1082' '#1075#1083#1072#1074#1077' '#1083#1080#1094#1077#1074#1086#1075#1086' '#1089#1095#1077#1090#1072
            HelpContext = 888
            DataField = 'OTNOSH'
            DataSource = dsDokument
            DropDownBox.Rows = 20
            EditButtons = <
              item
                Style = ebsEllipsisEh
                OnClick = edOTNOSHEditButtons0Click
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            KeyField = 'ID'
            ListField = 'NAME'
            ListSource = dsOtnosh
            ParentFont = False
            TabOrder = 1
            Visible = True
          end
          object N_F_edNomerSem: TDBCheckBoxEh
            Left = 444
            Top = 8
            Width = 82
            Height = 17
            Caption = #1082#1074#1072#1088#1090#1080#1088#1072#1085#1090
            DataField = 'NOMER_SEM'
            DataSource = dsDokument
            TabOrder = 2
            TabStop = False
            ValueChecked = '1'
            ValueUnchecked = '0'
          end
          object edDateSrokDog: TDBDateTimeEditEh
            Left = 556
            Top = 4
            Width = 115
            Height = 26
            Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1085#1072#1081#1084#1072' '#1076#1083#1103' '#1082#1074#1072#1088#1090#1080#1088#1072#1085#1090#1072
            DataField = 'DATE_SROK_DN'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
            EditFormat = 'DD/MM/YYYY      '
          end
        end
        object pnMain: TPanel
          Left = 0
          Top = 0
          Width = 729
          Height = 293
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 12
            Top = 7
            Width = 50
            Height = 13
            Caption = #1060#1072#1084#1080#1083#1080#1103
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object Label2: TLabel
            Left = 264
            Top = 7
            Width = 23
            Height = 13
            Caption = #1048#1084#1103
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 455
            Top = 7
            Width = 56
            Height = 13
            Caption = #1054#1090#1095#1077#1089#1090#1074#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 12
            Top = 35
            Width = 22
            Height = 13
            Caption = #1055#1086#1083
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label20: TLabel
            Left = 12
            Top = 62
            Width = 98
            Height = 13
            Caption = #1053#1072#1094#1080#1086#1085#1072#1083#1100#1085#1086#1089#1090#1100
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 169
            Top = 35
            Width = 95
            Height = 13
            Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label18: TLabel
            Left = 12
            Top = 88
            Width = 76
            Height = 13
            Caption = #1054#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label16: TLabel
            Left = 300
            Top = 88
            Width = 125
            Height = 13
            Caption = #1057#1077#1084#1077#1081#1085#1086#1077' '#1087#1086#1083#1086#1078#1077#1085#1080#1077
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label36: TLabel
            Left = 292
            Top = 62
            Width = 81
            Height = 13
            Caption = #1043#1088#1072#1078#1076#1072#1085#1089#1090#1074#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label46: TLabel
            Left = 408
            Top = 35
            Width = 51
            Height = 13
            Caption = #1058#1077#1083#1077#1092#1086#1085
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label15: TLabel
            Left = 11
            Top = 273
            Width = 155
            Height = 13
            Caption = #1055#1088#1086#1087#1080#1089#1099#1074#1072#1077#1090#1089#1103' '#1087#1086' '#1072#1076#1088#1077#1089#1091
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object TextAdres: TvchDBText
            Left = 179
            Top = 270
            Width = 435
            Height = 18
            Color = clWhite
            DataField = 'ADRES_ID'
            DataSource = dsDokument
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Transparent = False
            OnGetText = TextAdresGetText
          end
          object edName: TDBEditEh
            Left = 302
            Top = 1
            Width = 121
            Height = 26
            DataField = 'Name'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = True
            OnUpdateData = edNameUpdateData
          end
          object edOtch: TDBEditEh
            Left = 523
            Top = 1
            Width = 121
            Height = 26
            DataField = 'Otch'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Visible = True
          end
          object edPol: TDBComboBoxEh
            Left = 46
            Top = 28
            Width = 100
            Height = 26
            DataField = 'POL'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
            OnChange = edPolChange
          end
          object edNATION: TDBLookupComboboxEh
            Left = 122
            Top = 55
            Width = 143
            Height = 26
            DataField = 'NATION'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            KeyField = 'ID'
            ListField = 'NAME_M'
            ListSource = dsNation
            ParentFont = False
            TabOrder = 6
            Visible = True
          end
          object edDateR: TDBDateTimeEditEh
            Left = 275
            Top = 28
            Width = 103
            Height = 26
            DataField = 'DateR'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Visible = True
            EditFormat = 'DD/MM/YYYY      '
          end
          object edObraz: TDBComboBoxEh
            Left = 99
            Top = 81
            Width = 183
            Height = 26
            DataField = 'OBRAZ'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            Visible = True
          end
          object edSem: TDBComboBoxEh
            Left = 434
            Top = 81
            Width = 131
            Height = 26
            DataField = 'SEM'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 9
            Visible = True
          end
          object N_F_edSuprug: TDBCheckBoxEh
            Left = 576
            Top = 86
            Width = 119
            Height = 17
            Caption = #1074#1084#1077#1089#1090#1077' '#1089' '#1089#1091#1087#1088#1091#1075#1086#1084
            DataField = 'SUPRUG'
            DataSource = dsDokument
            TabOrder = 10
            TabStop = False
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object edCitizen: TDBLookupComboboxEh
            Left = 382
            Top = 55
            Width = 221
            Height = 26
            DataField = 'CITIZEN'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            KeyField = 'ID'
            ListField = 'NAME'
            ListSource = dsCitizen
            ParentFont = False
            TabOrder = 7
            Visible = True
          end
          object edFamilia: TDBEditEh
            Left = 80
            Top = 1
            Width = 151
            Height = 26
            HelpContext = 888
            DataField = 'Familia'
            DataSource = dsDokument
            EditButtons = <
              item
                Glyph.Data = {
                  42020000424D4202000000000000420000002800000010000000100000000100
                  1000030000000002000000000000000000000000000000000000007C0000E003
                  00001F0000001863186318631863186318631863186318631863186318631863
                  1863186318631863186310420040004010421042100010001042100010001042
                  1863186318631863186318631042004010420040104210001042100010421863
                  1863186318631863186318631863004010420040104210001042100010421863
                  1863186318631863186318631863004010420040104210001042100010421863
                  1863186318631863186318631863004000400040104210001000100010421863
                  1863186318631863186318631863004000400040104210001000100010421863
                  1042104218631863004010421863004010001042104210001000100010421042
                  1000104218631863004000401042004010001000104210001000100010421000
                  1000186318631863186300400040004000401000100010001000100010001000
                  1863186318631863186318630040004000400040100010001000100010001863
                  1863186318631863186318631863186300401042104218631000104210421863
                  1863186318631863186318631863004000400040104210001000100010421863
                  1863186318631863186318631863004000400040104210001000100010421863
                  1863186318631863186318631863104200400040186310421000100018631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  186318631863}
                Style = ebsGlyphEh
                Width = 20
                OnClick = edFamiliaEditButtons0Click
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object edTelefon: TDBEditEh
            Left = 476
            Top = 28
            Width = 121
            Height = 26
            DataField = 'TELEFON'
            DataSource = dsDokument
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Visible = True
            OnUpdateData = edNameUpdateData
          end
          object gbPasp: TGroupBox
            Left = 0
            Top = 114
            Width = 725
            Height = 77
            Caption = ' '#1055#1072#1089#1087#1086#1088#1090' '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 12
            object Label8: TLabel
              Left = 289
              Top = 28
              Width = 31
              Height = 13
              Caption = #1057#1077#1088#1080#1103
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label27: TLabel
              Left = 387
              Top = 28
              Width = 31
              Height = 13
              Caption = #1053#1086#1084#1077#1088
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 528
              Top = 28
              Width = 26
              Height = 13
              Caption = #1044#1072#1090#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label29: TLabel
              Left = 10
              Top = 54
              Width = 73
              Height = 13
              Caption = #1054#1088#1075#1072#1085' '#1074#1099#1076#1072#1095#1080
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 10
              Top = 28
              Width = 115
              Height = 13
              Caption = #1053#1086#1084#1077#1088' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1080
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label113: TLabel
              Left = 479
              Top = 54
              Width = 76
              Height = 13
              Caption = #1057#1088#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Visible = False
            end
            object ENG_edLichNomer: TDBEditEh
              Left = 135
              Top = 22
              Width = 136
              Height = 26
              CharCase = ecUpperCase
              DataField = 'LICH_NOMER'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Visible = True
              OnUpdateData = ENG_edLichNomerUpdateData
            end
            object edPasp_Seria: TDBEditEh
              Left = 326
              Top = 22
              Width = 45
              Height = 26
              CharCase = ecUpperCase
              DataField = 'PASP_SERIA'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Visible = True
            end
            object edPasp_Nomer: TDBEditEh
              Left = 427
              Top = 22
              Width = 71
              Height = 26
              DataField = 'PASP_NOMER'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Visible = True
            end
            object edPasp_Date: TDBDateTimeEditEh
              Left = 561
              Top = 22
              Width = 121
              Height = 26
              DataField = 'PASP_DATE'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              Kind = dtkDateEh
              ParentFont = False
              TabOrder = 3
              Visible = True
            end
            object edPasp_Organ: TDBEditEh
              Left = 96
              Top = 48
              Width = 353
              Height = 26
              DataField = 'PASP_VIDAN'
              DataSource = dsDokument
              EditButtons = <
                item
                  Style = ebsEllipsisEh
                  OnClick = edPasp_OrganEditButtons0Click
                end>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Visible = True
            end
            object edPasp_Srok: TDBDateTimeEditEh
              Left = 564
              Top = 48
              Width = 121
              Height = 26
              DataField = 'PASP_SROK'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              Kind = dtkDateEh
              ParentFont = False
              TabOrder = 5
              Visible = False
            end
          end
          object edUdost: TDBComboBoxEh
            Left = 12
            Top = 110
            Width = 281
            Height = 24
            DataField = 'PASP_UDOST'
            DataSource = dsDokument
            EditButtons = <
              item
                Glyph.Data = {
                  C6000000424DC60000000000000076000000280000000A0000000A0000000100
                  0400000000005000000000000000000000001000000000000000000000000000
                  8000008000000080800080000000800080008080000080808000C0C0C0000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888800
                  0000008888880800000080088880080000008000880088000000880000088800
                  0000888000888800000088000008880000008000880088000000800888800800
                  00008088888888000000}
                Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
                Style = ebsGlyphEh
                OnClick = edUdostEditButtons0Click
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 11
            Visible = True
          end
          object gbRogd: TGroupBox
            Left = 0
            Top = 191
            Width = 725
            Height = 71
            Caption = ' '#1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103' '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 13
            object Label9: TLabel
              Left = 10
              Top = 16
              Width = 134
              Height = 13
              Caption = #1056#1077#1089#1087#1091#1073#1083#1080#1082#1072' ('#1075#1086#1089#1091#1076#1072#1088#1089#1090#1074#1086')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label10: TLabel
              Left = 407
              Top = 16
              Width = 76
              Height = 13
              Caption = #1086#1073#1083#1072#1089#1090#1100' ('#1082#1088#1072#1081')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 111
              Top = 46
              Width = 30
              Height = 13
              Caption = #1088#1072#1081#1086#1085
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 407
              Top = 46
              Width = 82
              Height = 13
              Caption = #1075#1086#1088#1086#1076' ('#1089#1077#1083#1077#1085#1080#1077')'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object edGOSUD_R: TDBLookupComboboxEh
              Left = 154
              Top = 13
              Width = 207
              Height = 26
              DataField = 'GOSUD_R'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              KeyField = 'ID'
              ListField = 'NAME'
              ListSource = dsStran
              ParentFont = False
              TabOrder = 0
              Visible = True
            end
            object edGOROD_R: TDBEditEh
              Left = 577
              Top = 40
              Width = 131
              Height = 26
              DataField = 'GOROD_R'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Visible = True
            end
            object DBCheckBoxEh3: TDBCheckBoxEh
              Left = 488
              Top = 15
              Width = 15
              Height = 17
              AllowGrayed = True
              DataField = 'B_OBL_R'
              DataSource = dsDokument
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              TabStop = False
              ValueChecked = 'True'
              ValueUnchecked = 'False'
            end
            object edB_GOROD_R: TDBLookupComboboxEh
              Left = 510
              Top = 40
              Width = 55
              Height = 26
              Alignment = taRightJustify
              DataField = 'GOROD_R_B'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              KeyField = 'ID'
              ListField = 'NAME'
              ListSource = dsTypeGorod
              ParentFont = False
              TabOrder = 3
              Visible = True
            end
            object edRAION_R: TDBEditEh
              Left = 154
              Top = 40
              Width = 207
              Height = 26
              DataField = 'RAION_R'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Visible = True
            end
            object edOBL_R: TDBEditEh
              Left = 510
              Top = 13
              Width = 198
              Height = 26
              DataField = 'OBL_R'
              DataSource = dsDokument
              EditButtons = <>
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Visible = True
            end
          end
          object btAdres: TBitBtn
            Left = 627
            Top = 268
            Width = 31
            Height = 22
            Hint = #1042#1099#1073#1088#1072#1090#1100' '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
            TabOrder = 14
            TabStop = False
            OnClick = btAdresClick
            Glyph.Data = {
              D6000000424DD600000000000000560000002800000010000000100000000100
              040000000000800000000000000000000000080000000800000004020400FCFE
              04000402840004868400FC02FC0004FEFC000402FC0084868400444444444444
              4444440000000000074444055555055037444400000505503744440011050550
              3744440011050550374444000005000037444003333333333774402266666666
              2674440226000262674444402261062674444444022662677444444440222607
              7444444444026707744444444440740004444444444444444444}
          end
        end
      end
      object ts2: TTabSheet
        Caption = #1063#1072#1089#1090#1100' 2'
        ImageIndex = 1
        DesignSize = (
          729
          558)
        object Label17: TLabel
          Left = 5
          Top = 146
          Width = 88
          Height = 13
          Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label41: TLabel
          Left = 11
          Top = 511
          Width = 259
          Height = 13
          Caption = #1057#1074#1077#1076#1077#1085#1080#1103' '#1087#1088#1086#1074#1077#1088#1080#1083' '#1080' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1102' '#1086#1092#1086#1088#1084#1080#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label19: TLabel
          Left = 25
          Top = 199
          Width = 150
          Height = 13
          Caption = #1080#1083#1080' '#1080#1089#1090#1086#1095#1085#1080#1082' '#1089#1091#1097#1077#1089#1090#1074#1086#1074#1072#1085#1080#1103
        end
        object Label7: TLabel
          Left = 5
          Top = 120
          Width = 220
          Height = 13
          Caption = #1043#1076#1077' '#1080' '#1082#1077#1084' '#1088#1072#1073#1086#1090#1072#1083' '#1085#1072' '#1087#1088#1077#1078#1085#1077#1084' '#1084#1077#1089#1090#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label31: TLabel
          Left = 5
          Top = 173
          Width = 69
          Height = 13
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label32: TLabel
          Left = 5
          Top = 10
          Width = 224
          Height = 13
          Caption = #1055#1077#1088#1077#1077#1093#1072#1083' '#1074' '#1090#1086#1084' '#1078#1077' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1084' '#1087#1091#1085#1082#1090#1077' '#1089' '#1091#1083'.'
        end
        object Label33: TLabel
          Left = 5
          Top = 67
          Width = 212
          Height = 13
          Caption = #1080#1083#1080' '#1087#1077#1088#1077#1084#1077#1085#1080#1083' '#1092#1072#1084#1080#1083#1080#1102', '#1080#1084#1103', '#1086#1090#1095#1077#1089#1090#1074#1086' '#1089
        end
        object Label34: TLabel
          Left = 5
          Top = 93
          Width = 84
          Height = 13
          Caption = #1044#1088#1091#1075#1080#1077' '#1087#1088#1080#1095#1080#1085#1099
        end
        object Label37: TLabel
          Left = 262
          Top = 40
          Width = 35
          Height = 13
          Caption = #1076#1086#1084' '#8470
        end
        object Label39: TLabel
          Left = 366
          Top = 40
          Width = 28
          Height = 13
          Caption = #1082#1086#1088#1087'.'
        end
        object Label40: TLabel
          Left = 472
          Top = 40
          Width = 16
          Height = 13
          Caption = #1082#1074'.'
        end
        object Label43: TLabel
          Left = 5
          Top = 226
          Width = 179
          Height = 13
          Caption = #1054#1090#1085#1086#1096#1077#1085#1080#1077' '#1082' '#1074#1086#1080#1085#1089#1082#1086#1081' '#1089#1083#1091#1078#1073#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label44: TLabel
          Left = 145
          Top = 253
          Width = 85
          Height = 13
          Caption = #1042#1086#1080#1085#1089#1082#1086#1077' '#1079#1074#1072#1085#1080#1077
        end
        object Label45: TLabel
          Left = 422
          Top = 253
          Width = 88
          Height = 13
          Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080
        end
        object Label26: TLabel
          Left = 11
          Top = 455
          Width = 167
          Height = 13
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1077#1090#1077#1081' '#1076#1086' 14 '#1083#1077#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label48: TLabel
          Left = 11
          Top = 483
          Width = 144
          Height = 13
          Caption = #1040#1076#1088#1077#1089#1072#1090' '#1076#1083#1103' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edRukov: TDBEditEh
          Left = 295
          Top = 504
          Width = 206
          Height = 26
          DataField = 'RUKOV'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
          Visible = True
        end
        object edIst: TDBLookupComboboxEh
          Left = 249
          Top = 192
          Width = 225
          Height = 26
          DataField = 'ISTOC'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          KeyField = 'ID'
          ListField = 'NAME'
          ListSource = dsIst
          ParentFont = False
          TabOrder = 9
          Visible = True
        end
        object edDateZ: TDBDateTimeEditEh
          Left = 522
          Top = 504
          Width = 121
          Height = 26
          HelpContext = 999
          DataField = 'DATEZ'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkDateEh
          ParentFont = False
          TabOrder = 17
          Visible = True
        end
        object gbDeti: TGroupBox
          Left = 6
          Top = 278
          Width = 707
          Height = 161
          Caption = ' '#1044#1077#1090#1080' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 18
          DesignSize = (
            707
            161)
          object GridDeti: TDBGridEh
            Left = 7
            Top = 15
            Width = 648
            Height = 138
            Anchors = [akLeft, akTop, akRight, akBottom]
            DataSource = dsDeti
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'Tahoma'
            FooterFont.Style = []
            HorzScrollBar.Visible = False
            ParentFont = False
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            UseMultiTitle = True
            VertScrollBar.VisibleMode = sbNeverShowEh
            Columns = <
              item
                EditButtons = <
                  item
                    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
                    Style = ebsEllipsisEh
                    OnClick = GridDetiColumns0EditButtons0Click
                  end>
                FieldName = 'OTNOSH_NAME'
                Footers = <>
                Title.Caption = #1054#1090#1085#1086#1096#1077#1085#1080#1077' '#1082' '#1075#1083#1072#1074#1077
                Title.Hint = #1054#1090#1085#1086#1096#1077#1085#1080#1077' '#1082' '#1075#1083#1072#1074#1077' '#1083#1080#1094#1077#1074#1086#1075#1086' '#1089#1095#1077#1090#1072
                Width = 107
              end
              item
                EditButtons = <
                  item
                    Glyph.Data = {
                      42020000424D4202000000000000420000002800000010000000100000000100
                      1000030000000002000000000000000000000000000000000000007C0000E003
                      00001F0000001863186318631863186318631863186318631863186318631863
                      1863186318631863186310420040004010421042100010001042100010001042
                      1863186318631863186318631042004010420040104210001042100010421863
                      1863186318631863186318631863004010420040104210001042100010421863
                      1863186318631863186318631863004010420040104210001042100010421863
                      1863186318631863186318631863004000400040104210001000100010421863
                      1863186318631863186318631863004000400040104210001000100010421863
                      1042104218631863004010421863004010001042104210001000100010421042
                      1000104218631863004000401042004010001000104210001000100010421000
                      1000186318631863186300400040004000401000100010001000100010001000
                      1863186318631863186318630040004000400040100010001000100010001863
                      1863186318631863186318631863186300401042104218631000104210421863
                      1863186318631863186318631863004000400040104210001000100010421863
                      1863186318631863186318631863004000400040104210001000100010421863
                      1863186318631863186318631863104200400040186310421000100018631863
                      1863186318631863186318631863186318631863186318631863186318631863
                      186318631863}
                    Style = ebsGlyphEh
                    Width = 16
                    OnClick = GridDetiColumns1EditButtons0Click
                  end>
                FieldName = 'FAMILIA'
                Footers = <>
                Title.Caption = #1060#1072#1084#1080#1083#1080#1103
                Width = 123
              end
              item
                EditButtons = <>
                FieldName = 'NAME'
                Footers = <>
                Title.Caption = #1048#1084#1103
                Width = 93
              end
              item
                EditButtons = <>
                FieldName = 'OTCH'
                Footers = <>
                Title.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
                Width = 100
              end
              item
                EditButtons = <>
                FieldName = 'POL'
                Footers = <>
                KeyList.Strings = (
                  #1052
                  #1046)
                PickList.Strings = (
                  #1052#1091#1078#1089#1082#1086#1081
                  #1046#1077#1085#1089#1082#1080#1081)
                Title.Caption = #1055#1086#1083
                Width = 73
              end
              item
                EditButtons = <>
                FieldName = 'DATER'
                Footers = <>
                Title.Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
                Width = 118
              end>
          end
          object Panel1: TPanel
            Left = 659
            Top = 15
            Width = 46
            Height = 144
            Align = alRight
            BevelOuter = bvNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            object btAddChild: TBitBtn
              Left = 8
              Top = 0
              Width = 28
              Height = 28
              Hint = #1044#1086#1073#1072#1074#1080#1090#1100
              TabOrder = 0
              OnClick = btAddChildClick
            end
            object btDelChild: TBitBtn
              Left = 8
              Top = 39
              Width = 28
              Height = 28
              Hint = #1059#1076#1072#1083#1080#1090#1100
              TabOrder = 1
              OnClick = btDelChildClick
            end
          end
        end
        object edWorkOLD: TDBEditEh
          Left = 248
          Top = 113
          Width = 390
          Height = 26
          DataField = 'WORK_DOLG_OLD'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          Visible = True
        end
        object edOldUL: TDBEditEh
          Left = 248
          Top = 7
          Width = 263
          Height = 26
          HelpContext = 888
          DataField = 'OLD_UL'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Visible = True
        end
        object edOldFIO: TDBEditEh
          Left = 248
          Top = 60
          Width = 234
          Height = 26
          DataField = 'OLD_FIO'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Visible = True
        end
        object edDrugPrich: TDBEditEh
          Left = 248
          Top = 86
          Width = 390
          Height = 26
          DataField = 'DRUG_PRICH'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Visible = True
        end
        object edOldDom: TDBEditEh
          Left = 303
          Top = 33
          Width = 41
          Height = 26
          DataField = 'OLD_DOM'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Visible = True
        end
        object edOldKorp: TDBEditEh
          Left = 402
          Top = 33
          Width = 41
          Height = 26
          DataField = 'OLD_KORP'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = True
        end
        object edOldKv: TDBEditEh
          Left = 496
          Top = 33
          Width = 41
          Height = 26
          DataField = 'OLD_KV'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Visible = True
        end
        object edVUS: TDBEditEh
          Left = 248
          Top = 219
          Width = 390
          Height = 26
          DataField = 'VUS'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          Visible = True
        end
        object edWork_Name: TDBEditEh
          Left = 248
          Top = 139
          Width = 390
          Height = 21
          DataField = 'WORK_NAME'
          DataSource = dsDokument
          EditButtons = <
            item
              Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
              Style = ebsEllipsisEh
            end
            item
              Glyph.Data = {
                C6000000424DC60000000000000076000000280000000A0000000A0000000100
                0400000000005000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888800
                0000008888880800000080088880080000008000880088000000880000088800
                0000888000888800000088000008880000008000880088000000800888800800
                00008088888888000000}
              Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077
              Style = ebsGlyphEh
              OnClick = edWork_NameEditButtons1Click
            end>
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          Visible = True
        end
        object edDolg_Name: TDBEditEh
          Left = 248
          Top = 166
          Width = 225
          Height = 21
          DataField = 'DOLG_NAME'
          DataSource = dsDokument
          EditButtons = <
            item
              Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
              Style = ebsEllipsisEh
            end
            item
              Glyph.Data = {
                C6000000424DC60000000000000076000000280000000A0000000A0000000100
                0400000000005000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888800
                0000008888880800000080088880080000008000880088000000880000088800
                0000888000888800000088000008880000008000880088000000800888800800
                00008088888888000000}
              Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077
              Style = ebsGlyphEh
              OnClick = edDolg_NameEditButtons1Click
            end>
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          Visible = True
        end
        object edZvan: TDBComboBoxEh
          Left = 248
          Top = 246
          Width = 148
          Height = 26
          DataField = 'ZVAN'
          DataSource = dsDokument
          DropDownBox.Rows = 25
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          Visible = True
        end
        object N_F_cbIsVUS: TDBCheckBoxEh
          Left = 9
          Top = 251
          Width = 129
          Height = 17
          Caption = #1042#1086#1077#1085#1085#1086#1086#1073#1103#1079#1072#1085#1085#1099#1081
          DataField = 'IS_VUS'
          DataSource = dsDokument
          TabOrder = 12
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object edVUSDate: TDBDateTimeEditEh
          Left = 526
          Top = 246
          Width = 121
          Height = 26
          DataField = 'PRIB_DATE'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkDateEh
          ParentFont = False
          TabOrder = 13
          Visible = True
        end
        object edDeti: TDBNumberEditEh
          Left = 191
          Top = 448
          Width = 33
          Height = 26
          DataField = 'DETI'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          Visible = True
        end
        object edADRESAT: TDBEditEh
          Left = 169
          Top = 476
          Width = 474
          Height = 26
          Anchors = [akLeft, akTop, akRight]
          DataField = 'ADRESAT'
          DataSource = dsDokument
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 15
          Visible = True
        end
      end
    end
  end
  inherited StBar: TStatusBar
    Top = 669
    Width = 737
  end
  inherited pnAdd: TPanel
    Width = 737
  end
  inherited dsDokument: TDataSource
    Left = 496
    Top = 82
  end
  inherited Dokument: TkbmMemTable
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
        Name = 'POVTOR'
        DataType = ftBoolean
      end
      item
        Name = 'NOMER'
        DataType = ftInteger
      end
      item
        Name = 'DATEZ'
        DataType = ftDate
      end
      item
        Name = 'Familia'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Otch'
        DataType = ftString
        Size = 30
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
        Name = 'DateR'
        DataType = ftDate
      end
      item
        Name = 'SOATO_R'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'GOSUD_R'
        DataType = ftInteger
      end
      item
        Name = 'OBL_R'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'RAION_R'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'GOROD_R'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SELO_R'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'POL'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'NATION'
        DataType = ftInteger
      end
      item
        Name = 'OBRAZ'
        DataType = ftInteger
      end
      item
        Name = 'SEM'
        DataType = ftInteger
      end
      item
        Name = 'SOATO'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ADRES_ID'
        DataType = ftInteger
      end
      item
        Name = 'ADRES_NAME'
        DataType = ftMemo
        Size = 1
      end
      item
        Name = 'ORGAN'
        DataType = ftMemo
        Size = 1
      end
      item
        Name = 'SOATO_O'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'GOSUD_O'
        DataType = ftInteger
      end
      item
        Name = 'OBL_O'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'RAION_O'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'GOROD_O'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'UL_O'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SELO_O'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DATE_O'
        DataType = ftDate
      end
      item
        Name = 'GOD_PROG'
        DataType = ftSmallint
      end
      item
        Name = 'DRUG_PRICH'
        DataType = ftMemo
        Size = 1
      end
      item
        Name = 'CEL'
        DataType = ftInteger
      end
      item
        Name = 'SROK'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'WORK_DOLG_OLD'
        DataType = ftMemo
      end
      item
        Name = 'ISTOC'
        DataType = ftInteger
      end
      item
        Name = 'DETI'
        DataType = ftSmallint
      end
      item
        Name = 'LICH_NOMER'
        DataType = ftString
        Size = 14
      end
      item
        Name = 'PASP_SERIA'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'PASP_NOMER'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PASP_DATE'
        DataType = ftDate
      end
      item
        Name = 'DATE_SOST'
        DataType = ftDate
      end
      item
        Name = 'RUKOV'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'MEN_ID'
        DataType = ftInteger
      end
      item
        Name = 'LICH_ID'
        DataType = ftInteger
      end
      item
        Name = 'PROV'
        DataType = ftBoolean
      end
      item
        Name = 'WORK_NAME'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'DOLG_NAME'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SUPRUG'
        DataType = ftBoolean
      end
      item
        Name = 'PASP_VIDAN'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'OLD_ADRES_ID'
        DataType = ftInteger
      end
      item
        Name = 'OLD_UL'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'OLD_FIO'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'CITIZEN'
        DataType = ftInteger
      end
      item
        Name = 'OLD_DOM'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'OLD_KORP'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'OLD_KV'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DATE_SROK'
        DataType = ftDate
      end
      item
        Name = 'TYPEREG'
        DataType = ftSmallint
      end
      item
        Name = 'PASP_UDOST'
        DataType = ftSmallint
      end
      item
        Name = 'B_OBL_O'
        DataType = ftBoolean
      end
      item
        Name = 'B_OBL_R'
        DataType = ftBoolean
      end
      item
        Name = 'GOROD_R_B'
        DataType = ftInteger
      end
      item
        Name = 'GOROD_O_B'
        DataType = ftInteger
      end
      item
        Name = 'OTNOSH'
        DataType = ftInteger
      end
      item
        Name = 'VUS'
        DataType = ftMemo
      end
      item
        Name = 'DOLG_SPR'
        DataType = ftInteger
      end
      item
        Name = 'WORK_SPR'
        DataType = ftInteger
      end
      item
        Name = 'IS_VUS'
        DataType = ftBoolean
      end
      item
        Name = 'ZVAN'
        DataType = ftInteger
      end
      item
        Name = 'PRIB_DATE'
        DataType = ftDate
      end
      item
        Name = 'NOMER_SEM'
        DataType = ftSmallint
      end
      item
        Name = 'OSNOV_ID'
        DataType = ftInteger
      end
      item
        Name = 'OSNOV_DATE'
        DataType = ftDate
      end
      item
        Name = 'OSNOV_NOMER'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'OSNOV'
        DataType = ftMemo
      end
      item
        Name = 'TELEFON'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'DATE_SROK_DN'
        DataType = ftDate
      end
      item
        Name = 'ADRESAT'
        DataType = ftMemo
      end>
    Left = 544
    Top = 82
    inherited DokumentPOVTOR: TBooleanField [3]
    end
    object DokumentNOMER: TIntegerField [4]
      FieldName = 'NOMER'
    end
    object DokumentDATEZ: TDateField [5]
      FieldName = 'DATEZ'
    end
    object DokumentFamilia: TStringField [6]
      FieldName = 'Familia'
      Size = 50
    end
    object DokumentName: TStringField [7]
      FieldName = 'Name'
      Size = 30
    end
    object DokumentOtch: TStringField [8]
      FieldName = 'Otch'
      Size = 30
    end
    inherited DokumentDateIzm: TDateField [9]
    end
    inherited DokumentNOMER_EKZ: TIntegerField [10]
    end
    object DokumentDateR: TDateField
      FieldName = 'DateR'
    end
    object DokumentSOATO_R: TStringField
      FieldName = 'SOATO_R'
      Size = 10
    end
    object DokumentGOSUD_R: TIntegerField
      FieldName = 'GOSUD_R'
    end
    object DokumentOBL_R: TStringField
      FieldName = 'OBL_R'
      Size = 30
    end
    object DokumentRAION_R: TStringField
      FieldName = 'RAION_R'
      Size = 30
    end
    object DokumentGOROD_R: TStringField
      FieldName = 'GOROD_R'
      Size = 30
    end
    object DokumentSELO_R: TStringField
      FieldName = 'SELO_R'
      Size = 30
    end
    object DokumentPOL: TStringField
      FieldName = 'POL'
      Size = 1
    end
    object DokumentNATION: TIntegerField
      FieldName = 'NATION'
    end
    object DokumentOBRAZ: TIntegerField
      FieldName = 'OBRAZ'
    end
    object DokumentSEM: TIntegerField
      FieldName = 'SEM'
    end
    object DokumentSOATO: TStringField
      FieldName = 'SOATO'
      Size = 10
    end
    object DokumentADRES_ID: TIntegerField
      FieldName = 'ADRES_ID'
    end
    object DokumentADRES_NAME: TMemoField
      FieldName = 'ADRES_NAME'
      BlobType = ftMemo
      Size = 1
    end
    object DokumentORGAN: TMemoField
      FieldName = 'ORGAN'
      BlobType = ftMemo
      Size = 1
    end
    object DokumentSOATO_O: TStringField
      FieldName = 'SOATO_O'
      Size = 10
    end
    object DokumentGOSUD_O: TIntegerField
      FieldName = 'GOSUD_O'
    end
    object DokumentOBL_O: TStringField
      FieldName = 'OBL_O'
      Size = 30
    end
    object DokumentRAION_O: TStringField
      FieldName = 'RAION_O'
      Size = 30
    end
    object DokumentGOROD_O: TStringField
      FieldName = 'GOROD_O'
      Size = 30
    end
    object DokumentUL_O: TStringField
      FieldName = 'UL_O'
      Size = 50
    end
    object DokumentSELO_O: TStringField
      FieldName = 'SELO_O'
      Size = 30
    end
    object DokumentDATE_O: TDateField
      FieldName = 'DATE_O'
    end
    object DokumentDRUG_PRICH: TMemoField
      FieldName = 'DRUG_PRICH'
      BlobType = ftMemo
      Size = 1
    end
    object DokumentCEL: TIntegerField
      FieldName = 'CEL'
    end
    object DokumentSROK: TStringField
      FieldName = 'SROK'
    end
    object DokumentWORK_DOLG_OLD: TMemoField
      FieldName = 'WORK_DOLG_OLD'
      BlobType = ftMemo
    end
    object DokumentISTOC: TIntegerField
      FieldName = 'ISTOC'
    end
    object DokumentDETI: TSmallintField
      FieldName = 'DETI'
    end
    object DokumentLICH_NOMER: TStringField
      FieldName = 'LICH_NOMER'
      Size = 14
    end
    object DokumentPASP_SERIA: TStringField
      FieldName = 'PASP_SERIA'
      Size = 5
    end
    object DokumentPASP_NOMER: TStringField
      FieldName = 'PASP_NOMER'
      Size = 10
    end
    object DokumentPASP_DATE: TDateField
      FieldName = 'PASP_DATE'
    end
    object DokumentDATE_SOST: TDateField
      FieldName = 'DATE_SOST'
    end
    object DokumentRUKOV: TStringField
      FieldName = 'RUKOV'
      Size = 50
    end
    object DokumentMEN_ID: TIntegerField
      FieldName = 'MEN_ID'
    end
    object DokumentLICH_ID: TIntegerField
      FieldName = 'LICH_ID'
    end
    object DokumentPROV: TBooleanField
      FieldName = 'PROV'
    end
    object DokumentWORK_NAME: TStringField
      FieldName = 'WORK_NAME'
      Size = 200
    end
    object DokumentDOLG_NAME: TStringField
      FieldName = 'DOLG_NAME'
      Size = 50
    end
    object DokumentSUPRUG: TBooleanField
      FieldName = 'SUPRUG'
    end
    object DokumentPASP_VIDAN: TStringField
      FieldName = 'PASP_VIDAN'
      Size = 200
    end
    object DokumentOLD_ADRES_ID: TIntegerField
      FieldName = 'OLD_ADRES_ID'
    end
    object DokumentOLD_UL: TStringField
      FieldName = 'OLD_UL'
      Size = 40
    end
    object DokumentOLD_FIO: TStringField
      FieldName = 'OLD_FIO'
      Size = 60
    end
    object DokumentCITIZEN: TIntegerField
      FieldName = 'CITIZEN'
    end
    object DokumentOLD_DOM: TStringField
      FieldName = 'OLD_DOM'
      Size = 5
    end
    object DokumentOLD_KORP: TStringField
      FieldName = 'OLD_KORP'
    end
    object DokumentOLD_KV: TStringField
      FieldName = 'OLD_KV'
    end
    object DokumentDATE_SROK: TDateField
      FieldName = 'DATE_SROK'
    end
    object DokumentTYPEREG: TSmallintField
      FieldName = 'TYPEREG'
    end
    object DokumentPASP_UDOST: TSmallintField
      FieldName = 'PASP_UDOST'
    end
    object DokumentB_OBL_O: TBooleanField
      FieldName = 'B_OBL_O'
    end
    object DokumentB_OBL_R: TBooleanField
      FieldName = 'B_OBL_R'
    end
    object DokumentGOROD_R_B: TIntegerField
      FieldName = 'GOROD_R_B'
    end
    object DokumentGOROD_O_B: TIntegerField
      FieldName = 'GOROD_O_B'
    end
    object DokumentOTNOSH: TIntegerField
      FieldName = 'OTNOSH'
    end
    object DokumentVUS: TMemoField
      FieldName = 'VUS'
      BlobType = ftMemo
    end
    object DokumentDOLG_SPR: TIntegerField
      FieldName = 'DOLG_SPR'
    end
    object DokumentWORK_SPR: TIntegerField
      FieldName = 'WORK_SPR'
    end
    object DokumentIS_VUS: TBooleanField
      FieldName = 'IS_VUS'
    end
    object DokumentZVAN: TIntegerField
      FieldName = 'ZVAN'
    end
    object DokumentPRIB_DATE: TDateField
      FieldName = 'PRIB_DATE'
    end
    object DokumentNOMER_SEM: TSmallintField
      FieldName = 'NOMER_SEM'
    end
    object DokumentOSNOV_ID: TIntegerField
      FieldName = 'OSNOV_ID'
    end
    object DokumentOSNOV_DATE: TDateField
      FieldName = 'OSNOV_DATE'
    end
    object DokumentOSNOV_NOMER: TStringField
      FieldName = 'OSNOV_NOMER'
      Size = 15
    end
    object DokumentOSNOV: TMemoField
      FieldName = 'OSNOV'
      BlobType = ftMemo
    end
    object DokumentTELEFON: TStringField
      FieldName = 'TELEFON'
      Size = 15
    end
    object DokumentDATE_SROK_DN: TDateField
      FieldName = 'DATE_SROK_DN'
    end
    object DokumentADRESAT: TMemoField
      FieldName = 'ADRESAT'
      BlobType = ftMemo
    end
    object DokumentPASP_SROK: TDateField
      FieldName = 'PASP_SROK'
    end
    object DokumentGOD_PROG: TStringField
      FieldName = 'GOD_PROG'
    end
  end
  inherited frDBDokument: TfrDBDataSet
    Left = 448
    Top = 74
  end
  inherited SvidPovtor: TkbmMemTable
    Left = 608
    Top = 90
  end
  inherited dsPovtor: TDataSource
    Left = 616
    Top = 162
  end
  inherited dsTypeGorod: TDataSource
    Left = 632
    Top = 130
  end
  inherited ImGISUN: TImageList
    Left = 396
    Top = 83
  end
  inherited tbReshSud: TkbmMemTable
    Left = 699
    Top = 199
  end
  object dsStran: TDataSource
    DataSet = dmBase.SprStran
    Left = 452
    Top = 9
  end
  object dsNation: TDataSource
    DataSet = dmBase.SprNac
    Left = 492
    Top = 9
  end
  object dsDeti: TDataSource
    DataSet = mtDeti
    OnDataChange = dsDetiDataChange
    Left = 516
    Top = 145
  end
  object mtDeti: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'FAMILIA'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'NAME'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'OTCH'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'POL'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'DATER'
        DataType = ftDate
      end
      item
        Name = 'CHILD_ID'
        DataType = ftInteger
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
    Left = 536
    Top = 114
    object mtDetiFAMILIA: TStringField
      FieldName = 'FAMILIA'
      Size = 30
    end
    object mtDetiNAME: TStringField
      FieldName = 'NAME'
      Size = 30
    end
    object mtDetiOTCH: TStringField
      FieldName = 'OTCH'
      Size = 30
    end
    object mtDetiPOL: TStringField
      FieldName = 'POL'
      Size = 1
    end
    object mtDetiDATER: TDateField
      FieldName = 'DATER'
    end
    object mtDetiCHILD_ID: TIntegerField
      FieldName = 'CHILD_ID'
    end
    object mtDetiOTNOSH: TIntegerField
      FieldName = 'OTNOSH'
    end
    object mtDetiOTNOSH_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'OTNOSH_NAME'
      LookupDataSet = dmBase.SprOtnosh
      LookupKeyFields = 'ID'
      LookupResultField = 'NAME'
      KeyFields = 'OTNOSH'
      Size = 40
      Lookup = True
    end
  end
  object dsCel: TDataSource
    DataSet = dmBase.SprTypeMigr
    Left = 524
    Top = 1
  end
  object dsIst: TDataSource
    DataSet = dmBase.SprIst
    Left = 404
    Top = 9
  end
  object dsCitizen: TDataSource
    DataSet = dmBase.LookUpCitizen
    Left = 364
    Top = 9
  end
  object frDBDeti: TfrDBDataSet
    DataSet = mtDeti
    Left = 428
    Top = 89
  end
  object dsOtnosh: TDataSource
    DataSet = dmBase.SprOtnosh
    Left = 348
    Top = 207
  end
end
