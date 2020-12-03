object Form1: TForm1
  Left = 426
  Top = 101
  Width = 1241
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
    Lines.Strings = (
      'edMemo')
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
    Top = 390
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
    Top = 542
    Width = 75
    Height = 25
    Caption = 'test date'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 423
    Top = 544
    Width = 201
    Height = 21
    TabOrder = 9
    Text = '2018-10-24T23:05:26.000+0300'
  end
  object Edit2: TEdit
    Left = 856
    Top = 544
    Width = 185
    Height = 21
    TabOrder = 10
    Text = 'Edit2'
  end
  object ComboBox1: TComboBox
    Left = 672
    Top = 544
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
    Top = 534
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
    Top = 590
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
  object btnGetCurID: TButton
    Left = 1096
    Top = 355
    Width = 121
    Height = 25
    Caption = 'GET '#1090#1077#1082#1091#1097#1080#1081' ID'
    TabOrder = 17
    OnClick = btnGetCurIDClick
  end
  object cbCreateSO: TCheckBox
    Left = 744
    Top = 117
    Width = 153
    Height = 17
    Caption = 'Create Super Object'
    TabOrder = 18
  end
  object btnGetList: TButton
    Left = 1096
    Top = 320
    Width = 121
    Height = 25
    Caption = 'GET '#1057#1087#1080#1089#1086#1082' ID'
    TabOrder = 19
    OnClick = btnGetListClick
  end
  object gdDocs: TDBGridEh
    Left = 487
    Top = 390
    Width = 320
    Height = 128
    DataSource = dsDocs
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 20
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object gdChild: TDBGridEh
    Left = 819
    Top = 390
    Width = 320
    Height = 128
    DataSource = dsChild
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    TabOrder = 21
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnGetWithPars: TButton
    Left = 939
    Top = 320
    Width = 121
    Height = 25
    Caption = 'GET with Pars'
    TabOrder = 22
    OnClick = btnGetWithParsClick
  end
  object btnGetDocs: TButton
    Left = 1088
    Top = 184
    Width = 121
    Height = 25
    Caption = 'GET-DOCS-BB'
    TabOrder = 23
    OnClick = btnGetDocsClick
  end
  object dtBegin: TDBDateTimeEditEh
    Left = 944
    Top = 44
    Width = 121
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 24
    Visible = True
  end
  object dtEnd: TDBDateTimeEditEh
    Left = 1088
    Top = 44
    Width = 121
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 25
    Visible = True
  end
  object edOrgan: TDBEditEh
    Left = 944
    Top = 13
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 26
    Text = '11'
    Visible = True
  end
  object edFirst: TDBEditEh
    Left = 944
    Top = 90
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 27
    Text = '1'
    Visible = True
  end
  object edCount: TDBEditEh
    Left = 1088
    Top = 90
    Width = 121
    Height = 21
    EditButtons = <>
    TabOrder = 28
    Text = '14'
    Visible = True
  end
  object btnPostDoc: TButton
    Left = 1088
    Top = 223
    Width = 121
    Height = 25
    Caption = 'POST-DOC-BB'
    TabOrder = 29
    OnClick = btnPostDocClick
  end
  object DataSource1: TDataSource
    Left = 112
    Top = 414
  end
  object AdsConnection: TAdsConnection
    ConnectPath = 'D:\App\'#1051#1040#1048#1057#1095'\Data\SelSovet.add'
    AdsServerTypes = [stADS_LOCAL]
    LoginPrompt = False
    Username = 'adssys'
    Password = 'sysdba'
    StoreConnected = False
    Left = 1088
    Top = 545
  end
  object DataSource2: TDataSource
    DataSet = tbTalonPrib
    Left = 160
    Top = 654
  end
  object tbTalonPrib: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103
    IndexCollationMismatch = icmIgnore
    Left = 1144
    Top = 545
  end
  object tbTalonPribDeti: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103#1044#1077#1090#1080
    IndexCollationMismatch = icmIgnore
    Left = 1192
    Top = 545
  end
  object dsDocs: TDataSource
    Left = 616
    Top = 441
  end
  object dsChild: TDataSource
    Left = 992
    Top = 457
  end
end
