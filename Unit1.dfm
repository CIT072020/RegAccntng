object Form1: TForm1
  Left = 426
  Top = 162
  Width = 1241
  Height = 780
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
    Top = 16
    Width = 75
    Height = 25
    Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object edMemo: TMemo
    Left = 8
    Top = 120
    Width = 1193
    Height = 225
    Lines.Strings = (
      'edMemo')
    TabOrder = 1
  end
  object edFile: TDBEditEh
    Left = 152
    Top = 16
    Width = 281
    Height = 21
    EditButtons = <>
    TabOrder = 2
    Text = 'GET.json'
    Visible = True
  end
  object edURL: TDBEditEh
    Left = 223
    Top = 58
    Width = 642
    Height = 21
    EditButtons = <>
    TabOrder = 3
    Text = 
      'https://a.todes.by:13555/village-council-service/v1/data?identif' +
      'ier=3140462K000VF6'
    Visible = True
  end
  object Button2: TButton
    Left = 24
    Top = 56
    Width = 75
    Height = 25
    Caption = 'HTTP RUN'
    TabOrder = 4
    OnClick = Button2Click
  end
  object edMetod: TDBComboBoxEh
    Left = 128
    Top = 58
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
  object Grid: TDBGridEh
    Left = 8
    Top = 357
    Width = 1201
    Height = 120
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
    Left = 24
    Top = 88
    Width = 121
    Height = 25
    Caption = 'getMovements'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 40
    Top = 501
    Width = 75
    Height = 25
    Caption = 'test date'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 143
    Top = 503
    Width = 201
    Height = 21
    TabOrder = 9
    Text = '2018-10-24T23:05:26.000+0300'
  end
  object Edit2: TEdit
    Left = 616
    Top = 503
    Width = 185
    Height = 21
    TabOrder = 10
    Text = 'Edit2'
  end
  object ComboBox1: TComboBox
    Left = 392
    Top = 503
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
  object Button5: TButton
    Left = 912
    Top = 501
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 12
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 184
    Top = 88
    Width = 75
    Height = 25
    Caption = 'getDoc'
    TabOrder = 13
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 416
    Top = 88
    Width = 75
    Height = 25
    Caption = 'test create'
    TabOrder = 14
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 304
    Top = 88
    Width = 75
    Height = 25
    Caption = 'saveDoc'
    TabOrder = 15
    OnClick = Button8Click
  end
  object GridTalon: TDBGridEh
    Left = 8
    Top = 557
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
  object Button9: TButton
    Left = 704
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button9'
    TabOrder = 17
    OnClick = Button9Click
  end
  object cbCreateSO: TCheckBox
    Left = 896
    Top = 60
    Width = 153
    Height = 17
    Caption = 'Create Super Object'
    TabOrder = 18
  end
  object btnGetList: TButton
    Left = 1112
    Top = 24
    Width = 75
    Height = 25
    Caption = 'GET '#1057#1087#1080#1089#1086#1082
    TabOrder = 19
    OnClick = btnGetListClick
  end
  object DataSource1: TDataSource
    Left = 112
    Top = 381
  end
  object AdsConnection: TAdsConnection
    ConnectPath = 'D:\App\'#1051#1040#1048#1057#1095'\Data\SelSovet.add'
    AdsServerTypes = [stADS_LOCAL]
    LoginPrompt = False
    Username = 'adssys'
    Password = 'sysdba'
    StoreConnected = False
    Left = 688
    Top = 8
  end
  object DataSource2: TDataSource
    DataSet = tbTalonPrib
    Left = 160
    Top = 621
  end
  object tbTalonPrib: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103
    IndexCollationMismatch = icmIgnore
    Left = 744
    Top = 8
  end
  object tbTalonPribDeti: TAdsTable
    IndexName = 'ADS_DEFAULT'
    StoreActive = False
    AdsConnection = AdsConnection
    TableName = #1058#1072#1083#1086#1085#1099#1055#1088#1080#1073#1099#1090#1080#1103#1044#1077#1090#1080
    IndexCollationMismatch = icmIgnore
    Left = 792
    Top = 8
  end
end
