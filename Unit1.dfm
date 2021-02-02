object Form1: TForm1
  Left = 426
  Top = 101
  Width = 1409
  Height = 841
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblSSovCode: TLabel
    Left = 944
    Top = 12
    Width = 83
    Height = 13
    Caption = #1050#1086#1076' '#1086#1090#1076#1077#1083#1072' '#1043#1080#1052
  end
  object lblIndNum: TLabel
    Left = 1232
    Top = 12
    Width = 105
    Height = 13
    Caption = #1048#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081' '#8470
  end
  object lblNsiType: TLabel
    Left = 1088
    Top = 12
    Width = 88
    Height = 13
    Caption = #1050#1086#1076' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  end
  object lblFirst: TLabel
    Left = 944
    Top = 92
    Width = 60
    Height = 13
    Caption = #1053#1072#1095#1072#1090#1100' '#1089' ...'
  end
  object lblCount: TLabel
    Left = 1088
    Top = 92
    Width = 87
    Height = 13
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1079#1072#1087#1080#1089#1077#1081
  end
  object Button1: TButton
    Left = 16
    Top = 9
    Width = 75
    Height = 25
    Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object edMemo: TMemo
    Left = 8
    Top = 153
    Width = 921
    Height = 225
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object edFile: TDBEditEh
    Left = 104
    Top = 11
    Width = 281
    Height = 21
    EditButtons = <>
    TabOrder = 2
    Text = 'GET.json'
    Visible = True
  end
  object edURL: TDBEditEh
    Left = 178
    Top = 51
    Width = 714
    Height = 21
    EditButtons = <>
    TabOrder = 3
    Text = 
      'https://a.todes.by:13555/village-council-service/api/v1/movement' +
      's/sys_organ/11/period/06.10.2020/08.10.2020?first=1&count=7'
    Visible = True
  end
  object Button2: TButton
    Left = 16
    Top = 49
    Width = 75
    Height = 25
    Caption = 'HTTP RUN'
    TabOrder = 4
    OnClick = Button2Click
  end
  object edMetod: TDBComboBoxEh
    Left = 104
    Top = 51
    Width = 65
    Height = 21
    EditButtons = <>
    Items.Strings = (
      'GET'
      'POST')
    KeyItems.Strings = (
      'GET'
      'POST')
    TabOrder = 5
    Text = 'GET'
    Visible = True
  end
  object gdIDs: TDBGridEh
    Left = 8
    Top = 418
    Width = 465
    Height = 128
    DataSource = DataSource1
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button3: TButton
    Left = 16
    Top = 121
    Width = 121
    Height = 25
    Caption = 'getMovements'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 320
    Top = 570
    Width = 75
    Height = 25
    Caption = 'test date'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 423
    Top = 572
    Width = 201
    Height = 21
    TabOrder = 9
    Text = '2018-10-24T23:05:26.000+0300'
  end
  object Edit2: TEdit
    Left = 856
    Top = 572
    Width = 185
    Height = 21
    TabOrder = 10
    Text = 'Edit2'
  end
  object ComboBox1: TComboBox
    Left = 672
    Top = 572
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 11
    Text = 'ISO'
    Items.Strings = (
      'ISO'
      'Java')
  end
  object btnSort: TButton
    Left = 8
    Top = 562
    Width = 75
    Height = 25
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
    TabOrder = 12
    OnClick = btnSortClick
  end
  object Button6: TButton
    Left = 184
    Top = 121
    Width = 75
    Height = 25
    Caption = 'getDoc'
    TabOrder = 13
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 416
    Top = 121
    Width = 75
    Height = 25
    Caption = 'test create'
    TabOrder = 14
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 304
    Top = 121
    Width = 75
    Height = 25
    Caption = 'saveDoc'
    TabOrder = 15
    OnClick = Button8Click
  end
  object GridTalon: TDBGridEh
    Left = 8
    Top = 618
    Width = 1209
    Height = 177
    DataSource = DataSource2
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 16
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object cbCreateSO: TCheckBox
    Left = 504
    Top = 125
    Width = 153
    Height = 17
    Caption = 'Create Super Object'
    TabOrder = 17
  end
  object gdDocs: TDBGridEh
    Left = 487
    Top = 418
    Width = 320
    Height = 128
    DataSource = dsDocs
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 18
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object gdChild: TDBGridEh
    Left = 819
    Top = 418
    Width = 320
    Height = 128
    DataSource = dsChild
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 19
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnGetDocs: TButton
    Left = 944
    Top = 173
    Width = 121
    Height = 25
    Caption = 'GET- '#1091#1073#1099#1074#1096#1080#1077' - BB'
    TabOrder = 20
    OnClick = btnGetDocsClick
  end
  object dtBegin: TDBDateTimeEditEh
    Left = 944
    Top = 64
    Width = 121
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 21
    Visible = True
  end
  object dtEnd: TDBDateTimeEditEh
    Left = 1088
    Top = 64
    Width = 121
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 22
    Visible = True
  end
  object edOrgan: TDBEditEh
    Left = 944
    Top = 30
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 23
    Text = '11'
    Visible = True
  end
  object edFirst: TDBEditEh
    Left = 944
    Top = 110
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 24
    Text = '1'
    Visible = True
  end
  object edCount: TDBEditEh
    Left = 1088
    Top = 110
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 25
    Text = '14'
    Visible = True
  end
  object btnPostDoc: TButton
    Left = 1088
    Top = 213
    Width = 119
    Height = 25
    Caption = 'POST-DOC-BB'
    TabOrder = 26
    OnClick = btnPostDocClick
  end
  object btnGetActual: TButton
    Left = 1088
    Top = 173
    Width = 121
    Height = 25
    Caption = 'GET- '#1072#1082#1090#1091#1072#1083#1100#1085#1099#1077' - BB'
    TabOrder = 27
    OnClick = btnGetActualClick
  end
  object lstINs: TListBox
    Left = 1232
    Top = 60
    Width = 121
    Height = 73
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 28
  end
  object edtIN: TDBEditEh
    Left = 1232
    Top = 30
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 29
    Text = '3141066C030PB2'
    Visible = True
  end
  object btnGetNSI: TButton
    Left = 1232
    Top = 173
    Width = 121
    Height = 25
    Caption = 'GET- '#1053#1057#1048' - BB'
    TabOrder = 30
    OnClick = btnGetNSIClick
  end
  object edNsiType: TDBEditEh
    Left = 1088
    Top = 30
    Width = 65
    Height = 21
    EditButtons = <>
    TabOrder = 31
    Visible = True
  end
  object gdNsi: TDBGridEh
    Left = 944
    Top = 280
    Width = 422
    Height = 121
    DataSource = dsNsi
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 32
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edNsiCode: TDBEditEh
    Left = 1168
    Top = 30
    Width = 41
    Height = 21
    EditButtons = <>
    TabOrder = 33
    Visible = True
  end
  object cbSrcPost: TDBComboBoxEh
    Left = 944
    Top = 215
    Width = 121
    Height = 21
    EditButtons = <>
    Items.Strings = (
      #1058#1077#1082#1091#1097#1080#1081' DSD'
      #1042#1089#1077' DSD'
      'J4Post.json'
      'J4PostNoPasp.json'
      'J4PostNoIN.json')
    TabOrder = 34
    Text = 'cbSrcPost'
    Visible = True
  end
  object cbAdsCvrt: TDBCheckBoxEh
    Left = 1232
    Top = 216
    Width = 97
    Height = 17
    Caption = 'ADS-'#1082#1086#1087#1080#1103
    TabOrder = 35
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbESTP: TDBCheckBoxEh
    Left = 944
    Top = 248
    Width = 121
    Height = 17
    Caption = #1069#1062#1055' '#1076#1083#1103' POST'
    TabOrder = 36
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbClearLog: TDBCheckBoxEh
    Left = 824
    Top = 120
    Width = 97
    Height = 17
    Caption = #1054#1095#1080#1089#1090#1082#1072' '#1083#1086#1075#1072
    Checked = True
    State = cbChecked
    TabOrder = 37
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DataSource1: TDataSource
    Left = 112
    Top = 442
  end
  object AdsConnection: TAdsConnection
    ConnectPath = 'D:\App\'#1051#1040#1048#1057#1095'\Data\SelSovet.add'
    AdsServerTypes = [stADS_LOCAL]
    LoginPrompt = False
    Username = 'adssys'
    Password = 'sysdba'
    StoreConnected = False
    Left = 1088
    Top = 573
  end
  object DataSource2: TDataSource
    DataSet = tbTalonPrib
    Left = 160
    Top = 682
  end
  object tbTalonPrib: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103
    IndexCollationMismatch = icmIgnore
    Left = 1144
    Top = 573
  end
  object tbTalonPribDeti: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103#1044#1077#1090#1080
    IndexCollationMismatch = icmIgnore
    Left = 1192
    Top = 573
  end
  object dsDocs: TDataSource
    Left = 616
    Top = 469
  end
  object dsChild: TDataSource
    Left = 992
    Top = 485
  end
  object dsNsi: TDataSource
    Left = 1209
    Top = 297
  end
  object cnctNsi: TAdsConnection
    ConnectPath = 'D:\App\'#1051#1040#1048#1057#1095'\Spr\ROC\'
    AdsServerTypes = [stADS_LOCAL]
    Left = 1160
    Top = 304
  end
end
