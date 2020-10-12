unit fSimpleD;

interface

{$I Task.inc}

uses
  Windows, Messages, Controls, SysUtils, Classes, Graphics, Forms, Dialogs, ROPasScript, Menus, Math, uTypes,
  kbmMemTable, kbmMemCSVStreamFormat, DB, FR_DSet, FR_DBSet, ComCtrls, StdCtrls, Buttons, Grids, DBGridEh, ExtCtrls,
  DBCtrlsEh, Mask, TB2Item, TB2Dock, TB2Toolbar, MetaTask, mPermit, Contnrs,ToolCtrlsEh, uProject, uProjectAll,
  SasaUtils, SasaIniFile, DbFunc, FuncPr, DBLookupEh, GridSetUp, SasaDbGrid, OpisEdit, AddEvents, uCheckKod,
  uSaveMemTable, DBCtrls, NewDialogs, ifpii_vadfunc, ReportTask, fSetNameDolg, fParamQuest, uDataSet2XML,
  Script, AdsTable, TB2ExtItems, sndkey32, mTempl,
  {$IFDEF VER150} Variants, {$ENDIF}
  {$IFDEF USE_FR3} frxClass, frxDBSet, frxPreView, {$ENDIF}
  {$IFDEF HUNSPELL} fEditMemoHS3, fEditMemoHS, fEnterAdresatHS, {$ELSE} fEditMemo, fEnterAdresat, {$ENDIF}
  ImgList,DateUtils, vchDBCtrls, VCLFixes, ZipForge;

const
  GISUN_GET=1;
  GISUN_POST=2;
  GISUN_CHECK=3;

type

//  HELPKEYWORD  !!!!

  TTabSheet = class(ComCtrls.TTabSheet)
  private
    FColor: TColor;
    procedure SetColor(Value: TColor);
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd);
      message WM_ERASEBKGND;
  public
    constructor Create(aOwner: TComponent); override;
    property Color: TColor read FColor write SetColor;
  end;

  TParRegGISUN = class(TObject)
  private
    FNames:TArrStrings;
    FValues:TArrVariant;
  public
    procedure SetPar(sName:String; vValue:Variant);
    function GetPar(sName:String; vDef:Variant):Variant;
    constructor Create;
    destructor Destroy; override;
  end;


  TCheckControl = record
    Cont1:TControl;
    Cont2:TControl;
    Cont1_:TControl;
  end;

  TInfoSaveDok = record
    NameFile:String;
    DateSave:TDateTime;
    Date:TDateTime;
    Nomer:String;
    Version:Integer;
    Error:String;
    TypeObj:Integer;
    ID:Integer;
    ID_SOURCE:Integer;
    ID_ZAGS:Integer;
    PODR:Integer;
    NAME_ZAGS:String;
  end;

  TDataSetDok = record
    DataSet:TDataSet;
    Name:String;
  end;

  TTypeEditMemo = (emSimple, emShablon);
  TChoiceRekv = record
    nType        : Integer;    // 0 - справочник  1-3 - шаблон
    nTypeSpr     : Integer;    // из какого справочника
    FieldName    : String;
    FieldNameBel : String;
    AddFieldsName: String;
    sPadeg       : String;
    TypeEdit     : TTypeEditMemo;
    DataSet      : TDataSet;
  end;
  TArrChoiceRekv = array of TChoiceRekv;

  TAddProperty = record
    FieldName : String;
    KodProp   : String;
    DataType  : TFieldType;
  end;
  TArrAddProperty = array of TAddProperty;

  TCheckBelField = record
    nTip         : Integer;
    lSelect      : Boolean;
    strFieldName : String;
    strFieldNameB: String;
  end;
  TArrCheckBelField = array of TCheckBelField;

  TfmSimpleD = class(TForm)
    pnTable: TPanel;
    sp: TSplitter;
    TBDock: TTBDock;
    sb: TScrollBox;
    TBToolbar: TTBToolbar;
    StBar: TStatusBar;
    TBItemPrint: TTBItem;
    TBItemWrite: TTBItem;
    TBItemCancel: TTBItem;
    TBItemSetUp: TTBItem;
    TBItemPreView: TTBItem;
    TBItemDesignReport: TTBItem;
    TBItemPerekl: TTBItem;
    TBItemDelList: TTBItem;
    dsDokument: TDataSource;
    TBItemAddList: TTBItem;
    Dokument: TkbmMemTable;
    frDBDokument: TfrDBDataSet;
    DokumentID: TIntegerField;
    TBItemZAGS: TTBItem;
    TBToolbarOrgan: TTBToolbar;
    TBControlItem1: TTBControlItem;
    TBControlItem2: TTBControlItem;
    lbOrgan: TLabel;
    edZAGS: TDBEditEh;
    TBControlItem3: TTBControlItem;
    DokumentNAME_ZAGS: TStringField;
    DokumentDateIzm: TDateField;
    DokumentPOVTOR: TBooleanField;
    DokumentNAME_ZAGS_B: TStringField;
    HistZAGS: TkbmMemTable;
    HistZAGSFieldName: TStringField;
    TBItemHist: TTBItem;
    HistZAGSValue: TStringField;
    HistZAGSStringValue: TStringField;
    TBItemAddHist1: TTBItem;
    HistZAGSDateIzm: TDateTimeField;
    TBItemAddSvid: TTBItem;
    TBItemShablon: TTBItem;
    TBItemOnlySvid: TTBItem;
    TBSubmenuTmp: TTBSubmenuItem;
    dsSeria: TDataSource;
    dsObl: TDataSource;
    DokumentIS_GOROD: TBooleanField;
    N_F_cbGorod: TDBCheckBoxEh;
    TBControlItem4: TTBControlItem;
    SvidPovtor: TkbmMemTable;
    SvidPovtorSVID_DATE: TDateField;
    SvidPovtorSVID_SERIA: TStringField;
    SvidPovtorSVID_NOMER: TStringField;
    dsPovtor: TDataSource;
    pnPovtor: TPanel;
    DbGridEh1: TDBGridEh;
    SvidPovtorSVID_SERIA_L: TStringField;
    TBItemDolg: TTBItem;
    btNewPovtor: TBitBtn;
    dsRN: TDataSource;
    btClearFirst: TBitBtn;
    dsGorod: TDataSource;
    dsRnGor: TDataSource;
    TBItemSvidIspor: TTBItem;
    ImGISUN: TImageList;
    dsVoenkom: TDataSource;
    dsRovd: TDataSource;
    frDBPovtSvid: TfrDBDataSet;
    DokumentDATE_ANUL: TDateField;
    TBSubmenuRun: TTBSubmenuItem;
    pnAdd: TPanel;
    lbAnnulir: TvchDBText;
    TBItemWord: TTBItem;
    TBItemEditMemo: TTBItem;
    TBItemTmpOffGISUN: TTBItem;
    TBSeparator2: TTBSeparatorItem;
    TBItemGetDataGISUN: TTBItem;
    TBSeparator1: TTBSeparatorItem;
    DokumentNOMER_EKZ: TIntegerField;
    DokumentTYPE_EKZ: TIntegerField;
    imBE: TImage;
    TBItemAdresat: TTBItem;
    TBItemFastPrint: TTBItem;
    kbmCSVStreamFormat1: TkbmCSVStreamFormat;
    DokumentPRINT_VOSSTAN: TBooleanField;
    DokumentDELETE_CRLF: TBooleanField;
    HistZAGSTypeDate: TSmallintField;
    HistZAGSDatePropis: TSmallintField;
    TBItemCkeckRegistr: TTBItem;
    N_F_cbPrintPovtor: TDBCheckBoxEh;
    DokumentPRINT_POVTOR: TBooleanField;
    TBItemAddLastDok: TTBItem;
    TBSeparatorItem: TTBSeparatorItem;
    SvidPovtorFIRST: TBooleanField;
    HistZAGSInfo: TStringField;
    TBItemSeekAkt: TTBItem;
    ImBtClear: TImage;
    btDelPovtor: TBitBtn;
    SvidPovtorWHO_SVID: TStringField;
    TBItemAddHist: TTBSubmenuItem;
    TBItemClearHist: TTBItem;
    DokumentREPORT_SIZE: TStringField;
    TBSubmenuPar: TTBSubmenuItem;
    TBItemCreateHist: TTBItem;
    TBItemNext: TTBItem;
    TBItemFirst: TTBItem;
    TBItemPrev: TTBItem;
    TBSeparatorMove1: TTBSeparatorItem;
    TBSeparatorMove2: TTBSeparatorItem;
    TBItemLast: TTBItem;
    TBItemNonQuery: TTBItem;
    DokumentSVID_GISRN: TBooleanField;
    DokumentLANG: TSmallintField;
    SvidPovtorGISRN: TSmallintField;
    Zip: TZipForge;
    DokumentRUKOV_D: TStringField;
    DokumentSPEC_D: TStringField;
    N_F_edTypeEkz: TComboBox;
    TBItemCopy: TTBItem;
    imOrg: TImage;
    DokumentCOVER_MESSAGE_ID: TStringField;
    DokumentCOVER_MESSAGE_TIME: TDateTimeField;
    DokumentREQUEST_IN: TStringField;
    TBItemSprAkt: TTBItem;
    tbReshSud: TkbmMemTable;
    tbReshSudTYPE_RESH: TSmallintField;
    tbReshSudDATE_RESH: TDateField;
    tbReshSudTEXT: TStringField;
    tbReshSudCANCEL: TBooleanField;
    tbReshSudID: TStringField;
    tbReshSudFIO: TStringField;
    tbReshSudSUD: TStringField;
    DokumentCOUNT_RESH_SUD: TIntegerField;
    DokumentDATE_POST_GIS: TDateTimeField;
    DokumentDATE_EDIT_GIS: TDateTimeField;
    TBItemDeclSvid: TTBItem;
    procedure TBItemSetUpClick(Sender: TObject);
    procedure TBItemDesignReportClick(Sender: TObject);
    procedure StBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure TBItemPereklClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TBItemDelListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TBItemReLoadClick(Sender: TObject);
    procedure TBItemWriteClick(Sender: TObject);
    procedure TBItemCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TBItemAddListClick(Sender: TObject);
    procedure dsDokumentDataChange(Sender: TObject; Field: TField);
    procedure TBItemCalcClick(Sender: TObject);
    procedure TBItemPreViewClick(Sender: TObject);
    procedure TBItemPrintClick(Sender: TObject);
    procedure TBItemZAGSClick(Sender: TObject);
    procedure edZAGSCheckDrawRequiredState(Sender: TObject; var DrawState: Boolean);
    procedure TBItemHistClick(Sender: TObject);
    procedure TBItemAddHist1Click(Sender: TObject);
    procedure TBItemAddSvidClick(Sender: TObject);
    procedure TBItemShablonClick(Sender: TObject);
    procedure dsPovtorDataChange(Sender: TObject; Field: TField);
    procedure TBItemDolgClick(Sender: TObject);
    procedure btNewPovtorClick(Sender: TObject);
    procedure btClearFirstClick(Sender: TObject);
    procedure TBItemSvidIsporClick(Sender: TObject);
    procedure DokumentBeforePost(DataSet: TDataSet);
    procedure Event_Annulir(Sender:TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TBItemWordClick(Sender: TObject);
    procedure lbAnnulirGetText(Sender: TObject; var Text: String);
    procedure TBSubmenuTmpClick(Sender: TObject);
    procedure TBItemEditMemoClick(Sender: TObject);
    procedure TBItemTmpOffGISUNClick(Sender: TObject);
    procedure TBItemGetDataGISUNClick(Sender: TObject);
    procedure N_F_edTypeEkzChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TBItemAdresatClick(Sender: TObject);
    procedure TBItemFastPrintClick(Sender: TObject);
    procedure TBItemCkeckRegistrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TBItemAddLastDokClick(Sender: TObject);
    procedure imBEClick(Sender: TObject);
    procedure TBItemSeekAktClick(Sender: TObject);
    procedure btDelPovtorClick(Sender: TObject);
    procedure TBItemAddHistClick(Sender: TObject);
    procedure TBItemClearHistClick(Sender: TObject);
    procedure TBItemCreateHistClick(Sender: TObject);
    procedure TBItemNextClick(Sender: TObject);
    procedure TBItemFirstClick(Sender: TObject);
    procedure TBItemLastClick(Sender: TObject);
    procedure TBItemPrevClick(Sender: TObject);
    procedure TBItemSprAktClick(Sender: TObject);
    procedure TBItemDeclSvidClick(Sender: TObject);
  private
    curID:Integer;
    curSource:Integer;
    curZags:Integer;
    curNomer:String;
    curSeria:String;
    curNSeria:String;
    curDateZ:TDateTime;
    curDolgR:String;
    curDolgS:String;

    FQueryExit: Boolean;
    FPar : TStringList;
    FClearKey : Boolean;
    FTypeObj: Integer;
    cbBel : TDBCheckBoxEh;
    lbBel : TLabel;
    procedure SetQueryExit(const Value: Boolean);
    procedure SetTabAsDown(const Value: Boolean);
    procedure SetTypeObj(const Value: Integer);
  public
    ds2xml:TDataSets2XML;
    pMessage:TMessageEvent;
    {$IFDEF USE_FR3}
//    frxDBDokument: TfrxDBDataset;
//    frxDBSvidPovtor: TfrxDBDataset;
    {$ENDIF}
    slGrid:TStringList;
    slGo:TStringList;
    FDefaultStatus:String;
    FRegisterNotRequired:Boolean;
    itNotRequired:TTbItem;
    itParCopy:TTbItem;
    FReportIN:Boolean;
    FShowOrgCaption:Boolean;
    FCheckPol : Boolean;
    FCountPodpis:Integer;
    FRefreshGurnal:Boolean;
    FCheckFieldGRN:Boolean;   // пропускать при переходе поля полученные из регистра
    FCheckSimFIO:Boolean;     // контрольввода символов в ФИО согласно поля (русское,белорусское)
    FLastError:String;
    FWriteAsXML:Boolean;
    FTabAsDown: Boolean;
    FLenSoato:Integer;
    FCurYear:Integer;
    FMinVoenkom:Integer;
    FMaxVoenkom:Integer;
    FWriteBeforeGisun:Boolean;
    FActiveOn:Boolean;
    FOnlySvid:Boolean;         // только cвидетельство
    FSimpleVvod:Boolean;       // упрощенный ввод
    FCheckSvidNomer:Boolean;
    FBOOKMARK_SVIDPOVTOR:String;
    FFieldDolgRuk:String;
    FFieldDolgSpec:String;
    FOldNomer:Integer;         // старый номер документа
    FCheckKeyGrid:Boolean;
    FBigTable:Integer;
    FVersionSave:Integer;
    FError:Integer;
    FCheckNewNomerAkt:Boolean;
    FFilterItems:TStringList;
    FProtokol:TStringList;
    FFontSize:Integer;
    FCurKeyBoard:LongWord;
    FCheckKeyboard:Boolean;
    FEnabledNomer:Boolean;
    //---  GISUN -------------------------------------
    MessageID : String;
    bit : TBitMap;
    FImageGisun:TImage;
    FPoleGRN:TField;
    FSubmenuGISUN: TTBSubmenuItem;
    //------------------------------------------------
    FCheckRegistr:Boolean;
    FTypeCheckRegistr:Integer;

    FedFirstEkz : TDbCheckBoxEh;

    FFirstControl:TWinControl;
    FCharCase:Integer;
    FCheckSVIDControl:Boolean;
    FArrControlUpperCase: array of TDbEditEh;   // список контролов для ввода только в верхнем регистре
    FArrCheckControl: array of TCheckControl;   // список контролов перемены местами (свидетельство)
    FAddNewDok:Boolean;
    FCheckLookupField:Boolean;
    FAddButtonMRUList:Boolean;
    FAddButtonMRUList_Punkt:Boolean;
    oldCurDok:TfmSimpleD;
    FTemplate: TTemplate;
    FEnableWrite:Boolean;
    FEnableSkip:Boolean;
    SkipDataSet:TDataSet;
    FActiveControlON : Boolean;
    FCurDolg:String;   // используется в ChoiceSpedD
    FVozrastPropis    : String;   // пока не изпользуется
    FVozrastPropisON  : String;   // возраст прописью у него в браке    Формируется в BeforePrint
    FVozrastPropisONA : String;   // возраст прописью у ee в браке      Формируется в BeforePrint
    Fdo18ON:String;               // сколько не хватает до 18 ему       Формируется в BeforePrint
    Fdo18ONA:String;              // сколько не хватает до 18 ей        Формируется в BeforePrint
    FEnabledSpecBel : Boolean;    // доступен ввод специалиста на белорусском языке в актовых записях
    FPrintSpecSvid : Boolean;     // в свидетельстве печатать специалиста
    FPrintSpecSprav : Integer;    // в справках печатать специалиста   (1-да 0-нет 2-только ФИО)
    FWordsLowerCase : String;
    FCheckOtmetka : String;
    RelationControl : TObjectList;
    H : THintWindow;
    FNewDataSet : TDataSet;
    FTypeNewDataSet : Integer;

    FArrCheckBelField : TArrCheckBelField;
    FArrCheckField    : TArrCheckBelField;
    FCheckBelName : Boolean;
    FCheckFamily  : Boolean;
    FFirstUpper : Boolean;
    FGrid     : TSasaDbGrid;
    FPageControl : TPageControl;
    FOldControl : TWinControl;
    FRun : Boolean;
    FRead : Boolean;
    FArrAddProperty : TArrAddProperty;
    FArrChoiceRekv : TArrChoiceRekv;
    FMainTable : TAdsTable;
    FAutoNum : Boolean;
    FDokZags : Boolean;
    FDokRegister : Boolean;
    FQuestAsNew:Boolean;
    FAutoVus:Boolean;     // автомат. определять военокомат
    FcbPovtor : TDbCheckBoxEh;
    FtsPovtor : TTabSheet;
    FNameRukZAGS  : String;
    FNameSpecZAGS : String;
//    FlbRuk  : TLabel;
//    FlbSpec : TLabel;
    IsCreateForm : Boolean;
    IsReadDokument : Boolean;
    IsCheckDokument:Boolean;

    property TypeObj : Integer read FTypeObj write SetTypeObj;

    procedure CMDialogKey( Var msg: TCMDialogKey );  message CM_DIALOGKEY;

    property TabAsDown:Boolean read FTabAsDown write SetTabAsDown;
    property QueryExit : Boolean read FQueryExit write SetQueryExit;
    procedure SetVisibleNomerEkz(pn:TPanel; ContLeft,ContCheck: TWinControl);
    procedure SetControlCharCase(cc : TEditCharCase; Params : array of TVarRec);
    procedure GrantSprav;

    procedure WriteForAllDok_BeforePost;

    function BeforeSkip : Boolean;
    procedure AfterSkip;
    procedure SkipDok(nType:Integer);
    procedure AfterReadDok; virtual;

    procedure UserAfterSkip;  virtual;
    procedure SetEnableSkip(lSet:Boolean);
    procedure SetSimpleVvod(sName:String); virtual;

    procedure SetOnlyPovtorSvid(lOnlyPovtor:Boolean; pc:TPageControl; ts:TWinControl; NonVisibleControls : array of TVarRec; lbSvid,lbNomer:TLabel); virtual;
    procedure CheckTsSvidPovtor; virtual;
    procedure cbPovtorOnClick(Sender:TObject);

    function  FindChoiceRekv(strFieldName:String; ds:TDataSet=nil):Integer;
    procedure InitArrChoiceRekv(n:Integer);

    function AddSvid(lAllRun:Boolean=false):String; virtual;
    function LoadAkt(nID:Integer):Boolean;


    procedure SetEvent; virtual;
    procedure ClearEvent; virtual;
    procedure AddCurList(Grid:TDbGridEh); virtual;

    procedure CreateButtonAddGrag(ed:TDbLookupComboboxEh);
    procedure EditAddGrag(ed:TDbLookupComboboxEh);
    procedure Event_GRAGEditButtonsClick(Sender: TObject; var Handled: Boolean);
    procedure NotStdSubmenuRun;


    procedure MsgHandler(var Msg: TMsg; var Handled: Boolean);

    procedure WM_RegisterAktGISUN(var rec:TMsg); message WM_REGISTER_AKT;
    function IsAktVosstan : Boolean;     // актовая запись восстановленная
    function IsChildGivorogd : Boolean;
    function GetLastAddDok:Integer;
    procedure SetLastAddDok(nId:Integer);
    function EmptyIzm:String; virtual;
    function RunReport: Integer;
    function GetParam(sParam,sDefault:String):String; // вернуть значение параметра из FPar
    procedure AssignPar(slPar:TStringList);     // прочить в переменную FPar список slPar
    function IsShowEdit: Boolean;
    function GetMaxYear:Integer;   // максимально возможный год актовой записи
    function GetMinYear:Integer;   //             возможный год актовой записи

    function CheckAllDokZags:Boolean;
    function CheckDokument(nType:Integer; lShowErr:Boolean; lClearProtokol:Boolean; lWriteDok:Boolean):Boolean; virtual;
    function CheckDokumentSimple(nType:Integer; lWriteDok:Boolean):Boolean; virtual;
    procedure CheckControlOnlyGod(lOnlyGod:Boolean; edDate:TDBDateTimeEditEh);
    procedure CheckControlOnlyGod2(vOnlyGod:Variant; edDate:TDBDateTimeEditEh);
    function CheckDateOnlyGod(dDate:TDateTime; vOnlyGod: Variant):TDateTime;

    procedure UlicaClick(Sender: TObject; var Handled: Boolean);
    function FindParentControl(c:TControl):Boolean;
    function CreateSubmenuRun:Boolean; virtual;
    procedure Event_ReadLastAddDok(Sender: TObject);
    procedure ReadLastAddDok; virtual;

    procedure AddButton_LoadIdentif(ed : TDbEditEh);
    procedure AddButton_Plus(ed : TDbEditEh;  onRunEvent: TButtonClickEventEh; sHint:String);

    procedure Event_LoadIdentif(Sender: TObject;  var Handled: Boolean);

    procedure AddSubmenu_ReadDolg;
    procedure AddSubmenu_ParCopy;
    procedure Event_ReadDolg(Sender: TObject);
    procedure Event_ParCopy(Sender: TObject);

    procedure Event_SetNotRequired(Sender: TObject);
    procedure AddSubMenu_NotRequired;
    procedure Check_NotRequired;

    function EnterDate(fld:TField; strCaption,strQuest:String):Boolean;
    procedure ActiveControlChanged(Sender: TObject);

    procedure CreateAll;
    constructor Create( Owner : TComponent); override;
    constructor CreateMDI(Owner: TComponent);
    destructor Destroy; override;

    //---  GISUN -------------------------------------
    procedure CheckImageGisun( fldPoleGrn : TField; im : TImage);
    procedure CheckImageCondIN_( edIN:TWinControl; sValue:String; im : TImage);


    function GisunOk(fldPoleGrn : TField) : Boolean;
    function ExitAsGISUN(lShow:Boolean=false) : Boolean;
    procedure CheckMenuGISUN(sVosstan:String='');
    function CreateParamRegistr : TParRegGisun; virtual;
    function IsRegisterGisun : Boolean; virtual;  // вазаимодействие с регистром для текущей записи разрешено
    procedure Event_GridColumnsGetPoleGrn(Sender: TObject;  EditMode: Boolean; Params: TColCellParamsEh);

    {$IFDEF GISUN}
    function AfterCreateFormGISUN:Boolean;
    function BeforeEditFormGISUN:Boolean;
    {$ENDIF}

    procedure ReadMessageID;
    procedure WriteMessageID;
    procedure WriteDateIzm;
    procedure WriteToDebug(arr:array of Variant);
    procedure WriteFieldToDebug(fld:TField);

    procedure AfterCheckAkt_GISUN(nType:Integer); virtual;
    function CheckAkt_GISUN(nType:Integer): Boolean;
    function GetDataFrom_GISUN(nType:Integer): Boolean;
    function RegisterAkt_GISUN(nType:Integer; Par:TParRegGisun=nil):Boolean;
    procedure WriteAfterRegister_GISUN; virtual;
    function IsSvidToGISUN(lQuery:Boolean) : Boolean;   // регистрировать свидетельство в регистре
    //------------------------------------------------

    function getGrag(strFieldName, strRazd: String): String;
    function getNation(strField, strFieldName: String): String;

    function  ChoiceSpecD(cont:TWinControl; lBel:Boolean=false): Boolean;
    procedure CheckCaretDokument(fldCheckEmpty,fldDokument : TField);
    function  IsAutoNumZAGS: Boolean;
    function CheckAddNomerAkt:Boolean;
    function CheckAddSvid:Boolean;

    procedure SetAddProperty( n : Integer; strFieldName : String; strKodProp : String; nType : TFieldType);
    procedure ReadDopProperty(nTypeObj,nKodObj : Integer; dDateSave : TDateTime);
    procedure WriteDopProperty(nTypeObj,nKodObj : Integer; dDateSave : TDateTime=0);

    procedure ReadOtherData(ds:TDataSet; sField:String);
    procedure WriteOtherData(ds:TDataSet; sField:String; sFields:String);

    function _getNameRukZAGS:String;
    function _getNameSpecZAGS:String;

//    procedure ReadAllDopProperty(nTypeObj,nKodObj : Integer; dDateSave : TDateTime);

    function getVoenkomat(strSoato:String; fldDC:TField; fldDR:TField; lCheckVozr:Boolean; nGrag:Integer=-1):Integer;

    function AddParEnterAdresat(slPar:TStringList; strFieldName:String=''):Boolean; virtual;
    function SaveToIni : Boolean; virtual;
    procedure LoadFromIni; virtual;
    procedure SetFlat( lFlat : Boolean);
    procedure SetRole;
    function  CheckDateEditGIS:Boolean; virtual;   // корректировались или нет поля отправляемые в регистр
    function  GetNameReport : String; virtual;
    procedure UpdateActions; override;
    function RunProcScript( strFuncName : String; var vResult : Variant ) : Boolean;
    function WriteDok : Boolean; virtual; abstract;
    function ReadDok( nID : Integer ) : Boolean; virtual;
    procedure ReadSvidPovtor(nTypeObj, nID: Integer);
    procedure WriteSvidPovtor(nTypeObj, nID: Integer);
    procedure SetIDZags(nID:Integer=-1);
    function NewDok( lAppend : Boolean ) : Boolean; virtual;
    function GetVid : String; virtual; abstract;
    function  BeforeReport : Boolean; virtual;
    procedure AfterReport; virtual;
    procedure RunCalc;
    function  BeforeEdit : Boolean; virtual;
    procedure AfterEdit; virtual;
    function EditModal : Boolean; virtual;
    procedure EditChild; virtual;
    function WriteField( fldTo, fldFrom : TField) : Boolean;
    {$IF Defined(ZAGS) or Defined(LAIS) }
    procedure ReadZapros(ds:TDataSet; nTypeObj:Integer; nID:Integer);
    procedure WriteZapros(ds:TDataSet; nTypeObj:Integer; nID:Integer);
    {$IFEND}
    procedure IN_UpdateData(Sender: TObject; var Handled: Boolean);
    procedure GridFIOUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    function CheckFIO:String; virtual;
    function CheckOneFIO(stext, sFamilia:String;sName:String;sOtch:String):String;
    procedure FIOUpdateData(Sender: TObject; var Handled: Boolean);
    procedure FIOUpdateDataP(Sender: TObject; var Handled: Boolean);

    procedure KeyPress_BLR(Sender: TObject; var Key: Char);
    procedure KeyPress_RU(Sender: TObject; var Key: Char);

    procedure CityUpdate(Sender: TObject; var Handled: Boolean); virtual;
    function SetNewNomerDok(lSetDate:Boolean=false):Integer; virtual;   // новый номер актовой записи

    function  LockAddDocument(nTypeObj:Integer):Boolean;  // блокировка добавления нового документа на время
    procedure UnLockAddDocument(nTypeObj:Integer);        // снятие блокировки добавления нового документа

    function LockOperation(nTypeOper:Integer; strOper:String):Boolean;
    procedure UnLockOperation(nTypeOper:Integer);

    function  GetHistValueField(strFieldName : String; nType : Integer; strAddStr:String='') : Variant;
    function  GetPrSmert(lKod : Boolean; strParam:String='') : String;
    function  GetHistPrSmert(strParam:String) : String;
    procedure CheckHistory(lClear:Boolean=FALSE);
    procedure ReadHistory( nID : Integer; nTypeObj : Integer); virtual;
    procedure WriteHistory( nID : Integer; nTypeObj : Integer); virtual;
    procedure CheckEnabledNameOrgan( lNew : Boolean; lChoiceZAGS:Boolean=true);
    function  EnableHistoryField( strFieldName : String) : Boolean;
    function  EnableHistoryControl( ActControl : TWinControl) : Boolean; virtual;
    procedure WriteToArrCheck( nInd, nType : Integer; lSelect : Boolean; strField,strFieldB : String);  overload;
    procedure WriteToArrCheck( nInd, nType : Integer; lSelect : Boolean; strField : String);  overload;
    procedure WriteForAll_Bel;
    procedure CheckForAll_Bel( fld : TField );
    procedure ChoiceMestWork( ed : TDbEditEh );
    procedure ChoiceDolg( ed : TDbEditEh );
    procedure ChoiceUl( ed : TDbEditEh );
    procedure AdditiveNewDok; virtual;
    procedure AdditiveReadDok; virtual;
    procedure AdditiveWriteDok; virtual;
    function  LoadTemplate( strName : String ) : Boolean; virtual;
//    function ChoiceShablonZAGS(dsDok:TdataSet=nil; strField:String='NAME_ZAGS'; strPadeg:String=''; strAddFields:String=''):Integer;
    function ChoiceShablonZAGS(dsDok:TDataSet; strField:String; strPadeg:String; strAddFields:String):Integer;
    procedure OnMenuWordClick(Sender: TObject);
//    function CheckSvid(TypeSvid : Integer;  strFieldDate : String;
//     strFieldSeria,strFieldNomer : String; var strBookMark : String) : String;
    procedure AddEditSvid( strBookMark : String );

    procedure SetPanelPovtor( ts : TTabSheet; cb : TDbCheckBoxEh; lbRuk,lbSpec : TLabel );  overload;
    procedure SetPanelPovtor( ts : ComCtrls.TTabSheet; cb : TDbCheckBoxEh; lbRuk,lbSpec : TLabel ); overload;

    procedure CheckListObl(Sender: TObject; NewText: String;
               var RecheckInList: Boolean);
    procedure CheckListRaion(Sender: TObject; NewText: String;
               var RecheckInList: Boolean);
    procedure CheckListRnGor(Sender: TObject; NewText: String;
               var RecheckInList: Boolean);
    procedure CheckLookupField;
    procedure FieldsAddHist(arrCont: array of TVarRec; lClear:Boolean);
    procedure FieldsClear(arrCont: array of TVarRec);
    function FieldAddHist(fld : TField; ActControl : TWinControl; var strErr : String) : Boolean;
    procedure FieldAddHistDop(fld : TField; ActControl:TWinControl); virtual;
    function  CreateHistRel(objDop:TWinControl; objParent:TWinControl):TAddControl;
    procedure AddUserHist; virtual;

    function ChoiceFromLookupSpr( strNameOpis : String; strFieldName : String; lString : Boolean; cont:TWinControl=nil):Boolean;
    function ChoiceFromAkt( nTypeAkt:Integer; var arrRec : TCurrentRecord; cont:TWinControl=nil ):Boolean;

    //---------------- save-load from file --------------------
    function  LoadDokumentFromFile(sFile:String):TInfoSaveDok;
    function  GetInfoSavedDok(sFile:String): TInfoSaveDok;
    function  SaveDokumentToFile:Boolean;
    procedure AddStdDataSetToXML;

    procedure CheckOtmenka_Load(edOtm,edOtm_ON,edOtm_ONA: TCustomDBEditEh; strField,strFieldON,strFieldONA: String; l1,l2 : TLabel; bt : TButton);
    procedure CheckOtmenka_Save;
    procedure WriteOTMETKA( strField, strOtm, strPol : String );

    procedure CheckEkz;

    procedure CheckValueInteger(nBigMin,nMin,nMax,nBigMax:Integer; edValue : TDbNumberEditEh; nType : Integer);
    procedure CheckValueDateZAGS(DateCheck:Variant; edDate:TDbDateTimeEditEh; nType:Integer; dDateB:TDateTime=0; dDateE:TDateTime=0);
    function  CheckFieldDate(fld:TField; nMinYear:Integer; nMaxYear:Integer; lYesNull:Boolean; sType:String; fld2:TField):String;

    function CheckAddPanel(var Text : String):Boolean; virtual;
    procedure SetFieldAddPanel(strField:String);

    procedure SetMRUList(ed:TDbEditEh;nLimit:Integer;nType:Integer;lAll:Boolean;lReload:Boolean;lBel:Boolean;lAddButton:Boolean;lPunktFromSpr:Boolean=false);
    procedure MRUListOpen(Sender: TObject;  var Handled: Boolean);
    procedure DbEditMRUList_Change(Sender: TObject);

    procedure ChoiceSpecClick(Sender: TObject;  var Handled: Boolean);
    procedure AddButton_ChoiceSpec(Params : array of TVarRec);
    procedure CheckPageControl(pc:TPageControl);
    procedure PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);

    procedure EditDokument; virtual;
    procedure PostDokument; virtual;
    procedure CheckAsNew; virtual;
    function GetAddPROP(sProp:String):Variant; virtual;

    procedure Init_ArrCheckControl(n: Integer);

    procedure   CheckUserName_frxDataSet;
    procedure UnCheckUserName_frxDataSet;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetVisibleImageBE;
    procedure SetcbBel(cb:TDbCheckBoxEh; lb:TLabel=nil);
    procedure FlushBuffers;

    procedure CheckLANG(nLang: Integer; lCheckValueField:Boolean); virtual;

    procedure ClearStatus( fldStatus:TField );
    function GetStatus( fldStatus:TField ):String;

    function CondIN(sFldIN:String):String;
    function IsSpecReg:Boolean;


    procedure SaveID;
    procedure RestID;

  end;

  TMyLookUpComboBox = class(TDBLookupComboboxEh)
  public
    property ListActive;
  end;
  TMyDateTimeEdit = class(TDBDateTimeEditEh)
  public
    property DropDownCalendar;
  end;

const
  _SHABLON_WORK = 1;
  _SHABLON_DOLG = 2;
  _SHABLON_UL   = 3;
  _SHABLON_WORK_DOLG = 4;
  _SHABLON_STRANA = 5;
  _SHABLON_ZAGS = 6;
  _SHABLON_MKB10 = 7;
  _SHABLON_VUS = 8;
var
  AsChild:Boolean;

implementation

uses fMain, dBase, fHist, SelLibFr, fShablon, fNewNomerAkt, fSimpleSeekAkt, fRunSprav, fHistory, fGurnal,
     {$IFDEF GISUN} fGetGISUNR, fGetGISUN1, fGetGISUN2, fGetGISUN, uGisun, {$ENDIF}
     uObjectsScript,
     {$IFDEF ZAGS} fZAGS_SprAkt, fZAGS_DeclSvid, {$ENDIF}
     TypInfo, StrUtils,fChoiceMenGISUN;

{$R *.DFM}

var
  lSetDecimal : Boolean;
  ListLastAddObj : TStringList;
//  IsWriteLastDok:Boolean;          // была запись последнего документа ис-ся в fGurnal.pas для перерисовки
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
constructor TTabSheet.Create(aOwner: TComponent);
begin
  inherited;
  FColor := clBtnFace;
end;

procedure TTabSheet.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Invalidate;
  end;
end;

procedure TTabSheet.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  if FColor = clBtnFace then
    inherited
  else
  begin
    Brush.Color := FColor;
    Windows.FillRect(Msg.dc, ClientRect, Brush.Handle);
    Msg.Result := 1;
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

{TParRegGISUN}

procedure TParRegGISUN.SetPar(sName:String; vValue:Variant);
var
  i,n:Integer;
begin
  n:=-1;
  for i:=0 to Length(FNames)-1 do begin
    if SameText(sName,FNames[i]) then begin
      n:=i;
      break;
    end;
  end;
  if n=-1 then begin
    SetLength(FNames,Length(FNames)+1);
    SetLength(FValues,Length(FNames)+1);
    n:=Length(FNames)-1;
  end;
  FNames[n]:=sName;
  FValues[n]:=vValue;
end;

function TParRegGISUN.GetPar(sName:String; vDef:Variant):Variant;
var
  i,n:Integer;
begin
  n:=-1;
  for i:=0 to Length(FNames)-1 do begin
    if SameText(sName,FNames[i]) then begin
      n:=i;
      break;
    end;
  end;
  if n=-1
    then Result:=vDef
    else Result:=FValues[n];
end;

constructor TParRegGISUN.Create;
begin
  SetLength(FNames,0);
  SetLength(FValues,0);
end;

destructor TParRegGISUN.Destroy;
begin
  SetLength(FNames,0);
  SetLength(FValues,0);
  inherited Destroy;
end;

//-------------------------------------------------------------------------------------

{ TfmSimple }

procedure TfmSimpleD.ClearStatus( fldStatus:TField );
begin
  if fldStatus.AsString<>'' then begin
    if Problem('Очистить значение поля "статус в ГИС РН" ?', mtConfirmation, self) then begin
      EditDataset(fldStatus.DataSet);
      fldStatus.AsString:='';
    end;
  end;
end;
//------------------------------------------
function TfmSimpleD.GetStatus( fldStatus:TField ):String;
begin
{$IFDEF GISUN}
  Result:=Gisun.Status2Str(fldStatus.AsString,FDefaultStatus);
{$ELSE}
  Result:='';
{$ENDIF}
end;

//------------------------------------------
procedure TfmSimpleD.SetControlCharCase(cc : TEditCharCase; Params : array of TVarRec);
//var
//  i : Integer;
begin
  {
  if (cc<>ecUpperCase) or GlobalTask.ParamAsBoolean('CONT_UPPER') then begin
    for i:=Low(Params) to High(Params) do begin
      with Params[i] do begin
        TDbEditEh(VObject).CharCase:=cc;
      end;
    end;
  end;
  }
end;
//------------------------------------------
procedure TfmSimpleD.SetOnlyPovtorSvid(lOnlyPovtor:Boolean; pc:TPageControl; ts: TWinControl;  NonVisibleControls: array of TVarRec; lbSvid,lbNomer:TLabel);
var
  i : Integer;
begin
  if lOnlyPovtor then begin
    Caption:='Повторное свидетельство '+Copy(Caption,12,200);
//    lbSvid.Caption:=' Повтор.свид-во';
    lbNomer.Caption:='з/а №';
    FOnlySvid:=true;
    FCheckSvidNomer:=GlobalTask.ParamAsBoolean('CH_POVT_SV');

    TBItemAddHist.Visible:=false;
    TBItemHist.Visible:=false;
    TBItemCreateHist.Visible:=false;
//    TBItemGetDataGISUN.Visible:=false;
    TBSubmenuRun.Visible:=false;
    TBItemTmpOffGISUN.Visible:=false;
    TBItemAdresat.Visible:=false;
    TBItemEditMemo.Visible:=false;
    TBItemDelList.Visible:=false;
    TBItemAddList.Visible:=false;
    TBItemPerekl.Visible:=false;

    for i:=0 to pc.PageCount-1 do begin
      pc.Pages[i].TabVisible:=false;
    end;
    pc.ActivePage:=TTabSheet(ts);

    for i:=Low(NonVisibleControls) to High(NonVisibleControls) do begin
      with NonVisibleControls[i] do begin
        TWinControl(VObject).Visible:=false;
      end;
    end;
    N_F_cbPrintPovtor.Parent:=ts;
    N_F_cbPrintPovtor.left:=5;
    N_F_cbPrintPovtor.top:=ts.Height-35;

  end else begin

  end;
end;
//------------------------------------------
procedure TfmSimpleD.WriteToArrCheck( nInd, nType : Integer; lSelect : Boolean; strField,strFieldB : String);
begin
  FArrCheckBelField[nInd].nTip    := nType;
  FArrCheckBelField[nInd].lSelect := lSelect;
  FArrCheckBelField[nInd].strFieldName  := strField;
  FArrCheckBelField[nInd].strFieldNameB := strFieldB;
end;
//-----------------------------------------------------------------------------
procedure TfmSimpleD.WriteToArrCheck( nInd, nType : Integer; lSelect : Boolean;
               strField : String);
begin
  FArrCheckField[nInd].nTip    := nType;
  FArrCheckField[nInd].lSelect := lSelect;
  FArrCheckField[nInd].strFieldName  := strField;
  FArrCheckField[nInd].strFieldNameB := '';
end;
//-----------------------------------------------------------------------------
procedure TfmSimpleD.WriteForAll_Bel;
var
  i : Integer;
begin    
  for i:=0 to Length(FArrCheckBelField)-1 do begin
    dmBase.CheckBelNazv(FArrCheckBelField[i].nTip, FArrCheckBelField[i].lSelect,
                        Dokument.FieldByName(FArrCheckBelField[i].strFieldName).AsString,
                        Dokument.FieldByName(FArrCheckBelField[i].strFieldNameB).AsString);
  end;   
  for i:=0 to Length(FArrCheckField)-1 do begin
    dmBase.CheckNazv(FArrCheckField[i].nTip, FArrCheckField[i].lSelect,
                        Dokument.FieldByName(FArrCheckField[i].strFieldName).AsString);
  end;
end;
//------------------------------------------
// проверка наличия в справочнике SprPerevod всех русских значений для подсветки в DbLookupEh
procedure TfmSimpleD.CheckLookupField;
var
  i : Integer;
begin
  if FCheckLookupField then begin
    for i:=0 to Length(FArrCheckBelField)-1 do begin
      // для названия города не проверяем
      if Pos('GOROD',FArrCheckBelField[i].strFieldName)=0 then begin
        dmBase.CheckNazv(FArrCheckBelField[i].nTip, FArrCheckBelField[i].lSelect,
                            Dokument.FieldByName(FArrCheckBelField[i].strFieldName).AsString);
      end;
    end;
    for i:=0 to Length(FArrCheckField)-1 do begin
      dmBase.CheckNazv(FArrCheckField[i].nTip, FArrCheckField[i].lSelect,
                          Dokument.FieldByName(FArrCheckField[i].strFieldName).AsString);
    end;
  end;
end;
//------------------------------------------
procedure TfmSimpleD.CheckForAll_Bel( fld : TField );
var
  i : Integer;
  s:String;
  procedure CheckBelRegister;
  begin
    if FDokZags then begin
      if LastSimIsLower(fld.AsString) then begin   // последний символ по русски на нижнем регистре
        if FCheckRegistr then begin  // контролировать регистр букв
          s:=CheckRegisterText(EC_FIRST,s);
        end;
      end else begin                               // последний символ по русски на верхнем регистре
        s:=ANSIUppercase(s);
      end;
    end;
  end;
begin
  EditDataSet(Dokument);
  if fld = nil then begin
    for i:=0 to Length(FArrCheckBelField)-1 do begin
      fld := Dokument.FindField(FArrCheckBelField[i].strFieldName);
      if (fld <> nil) and (Dokument.FieldByName(FArrCheckBelField[i].strFieldNameB).AsString='') then begin
        s:=dmBase.GetBelNazv(FArrCheckBelField[i].nTip, FArrCheckBelField[i].lSelect, fld.AsString);

        CheckBelRegister; // см. выше

        Dokument.FieldByName(FArrCheckBelField[i].strFieldNameB).AsString:=s;
      end;
    end;
  end else begin
    for i:=0 to Length(FArrCheckBelField)-1 do begin
      if fld.FieldName = FArrCheckBelField[i].strFieldName then begin
        s:=dmBase.GetBelNazv(FArrCheckBelField[i].nTip, FArrCheckBelField[i].lSelect, fld.AsString);

        CheckBelRegister;  // см. выше

        Dokument.FieldByName(FArrCheckBelField[i].strFieldNameB).AsString:=s;
        break;
      end;
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TfmSimpleD.CheckMenuGISUN(sVosstan:String);
var
  lVosst:Boolean;
  procedure SetV(l:Boolean);
  begin
    if l
      then TBItemGetDataGISUN.ShortCut:=TextToShortCut('F1')
      else TBItemGetDataGISUN.ShortCut:=TextToShortCut('');
    TBItemGetDataGISUN.Visible:=l;
    TBItemTmpOffGISUN.Visible:=l;
    TBSeparator1.Visible:=l;
    TBSeparator2.Visible:=l;
    if FSubmenuGISUN<>nil
      then FSubmenuGISUN.Visible:=l;
  end;
  procedure SetE(l:Boolean);
  begin
    TBItemGetDataGISUN.Enabled:=l;
    if FSubmenuGISUN<>nil
      then FSubmenuGISUN.Enabled:=l;
end;
begin
  {$IFDEF GISUN}
     if FEnableWrite then begin
       if IsActiveGISUN and (sVosstan='ZAPROS') then begin
         TBItemGetDataGISUN.Visible:=true;
         TBItemTmpOffGISUN.Visible:=false;
         TBSeparator1.Visible:=false;
         TBSeparator2.Visible:=false;
       end else if IsActiveGISUN and (FDokZags or FDokRegister) then begin
         if sVosstan='' then begin
           lVosst:=IsAktVosstan;
         end else if sVosstan='1' then begin
           lVosst:=true;
         end else begin
           lVosst:=false;
         end;
         Gisun.IsEnabled:=not TBItemTmpOffGISUN.Checked;
         if Gisun.IsEnableTypeAkt(FTypeObj,lVosst) then begin
           FImageGisun.Visible:=true;
           if FRegisterNotRequired then
             FImageGisun.OnClick:=Event_SetNotRequired;
           SetV(true);
           SetE(Gisun.IsEnabled);
         end else begin
           FImageGisun.Visible:=false;
           SetV(false);
         end;
         if not Gisun.IsVisibleTmpOff then begin
           TBItemTmpOffGISUN.Visible:=false;
         end;
       end else begin
         SetV(false);
       end;
     end else begin
       SetV(false);
     end;
  {$ELSE}
    SetV(false);
  {$ENDIF}
end;

//---------------------------------------------------------------------------------------------------
procedure TfmSimpleD.CreateAll;
var
 ListOpis : TListOpisEdit;
 n:Integer;
begin
  IsCreateForm:=true;
  //==было в FormCreate====================================================
  FFontSize:=8;
  {$IFDEF USE_FR3}

    CreatefrxDBdataSet(self,Dokument,'CurDok','Текущий документ');
    CreatefrxDBdataSet(self,SvidPovtor,'SvidPovtor','Повторные свидетельства');
    CreatefrxDBdataSet(self,HistZAGS,'HistZAGS','');

  {$ENDIF}
  if not Dokument.Active then Dokument.Active:=true;
  Dokument.Append;
  Dokument.Post;

  {$IFDEF ZAGS}
    TBItemAdresat.Visible:=( (Dokument.FindField('ARX_ADRESAT')<>nil) or (Dokument.FindField('ADRESAT')<>nil) );
  {$ELSE}
    TBItemAdresat.Visible:=false;
  {$ENDIF}
  //======================================================

  H:=nil;
  slGrid:=nil;
  slGo:=nil;
  FDefaultStatus:='';
  FReportIN:=false;
  FCountPodpis:=1;
  FLenSoato:=getLenSoato;
  FCurYear:=YearOf(Now);
  FMinVoenkom:=16;
  FMaxVoenkom:=65;
  FActiveOn:=false;

  FWriteBeforeGisun:=false;    // идет запись документа перед отправкой в регистр

  FFieldDolgRuk:='';
  FFieldDolgSpec:='';
  TBItemCancel.Visible:=not GlobalTask.ParamAsBoolean('NOT_CANCEL');
  FRefreshGurnal:=false;
  FCheckFieldGRN:=GlobalTask.ParamAsBoolean('CHECKFIELDGRN');
  FCheckSimFIO:=GlobalTask.ParamAsBoolean('CHECK_SIM_FIO');
  FOldNomer:=-1;
  FCheckKeyGrid:=false;
  FBigTable:=0;    // 1 - для GurnalRegist  (журнал учета заявлений)  2 - для AddDokZags
  FTabAsDown:=false;   // клавиша TAB действует как DOWN
  FWriteAsXML:=true;

  n:=Role.EnableEditForm(Self.Name,'');
  if (n=0)
    then FEnableWrite:=false
    else FEnableWrite:=true;

//  FTabAsDown:=true;

  FVersionSave:=1;    // версия для сохранения документа в файл ".SAV"
  FError:=0;
  FCheckNewNomerAkt:=false;
  ds2xml:=TDataSets2XML.Create;
  FFilterItems:=TStringList.Create;
  FProtokol:=TStringList.Create;
  FCurKeyBoard:=GetTypeKeyBoard;
  FCheckKeyboard:=GlobalTask.ParamAsBoolean('KEYBOARD');
  FEnabledNomer:=true;  // доступна корректировка номера актовой записи

  FImageGisun:=nil;
  FPoleGRN:=nil;
  FOnlySvid:=false;    // true если окно открывается только для выписки повторного свидетельства
  FSimpleVVod:=false;  // true если включен режим упрощенного ввода

  IsCheckDokument:=true;
  FRegisterNotRequired:=false;    // доступность установки значения "взаимодействие с ГИС РН не трубуется"
  itNotRequired:=nil;
  itParCopy:=nil;
  FCheckPol:=true;
  FShowOrgCaption:=true;

  FCharCase:=-1;

  FCheckRegistr:=true;
  FTypeCheckRegistr:=GlobalTask.ParamAsInteger('CONT_REG');

  FCheckSVIDControl:=false;
  FFirstControl:=nil;    // первый контрол для переключения по клавише Ctrl-0

  FTemplate:=nil;
  cbBel:=nil;
  lbBel:=nil;
  FAddNewDok:=false;
  FAddButtonMRUList:=true;   // создавать дополнительную кнопку для MRUList
  FAddButtonMRUList_Punkt:=true;
  FCheckLookupField:=true;   // выполнять CheckLookupField

  FEnableSkip:=false;
  SkipDataSet:=nil;
  FActiveControlON:=false;
  FWordsLowerCase := ','+StringReplace(ANSILowerCase(Trim(GlobalTask.ParamAsString('WORDS_LOWER'))),' ','',[rfReplaceAll])+',';
  FCheckOtmetka:='';
  FNewDataSet := nil;
  FTypeNewDataSet:=0;
  FTypeObj := 0;
  FRead := false;
  FDokZAGS := false;
  FDokRegister := false;
  FQuestAsNew:=true;
  pnPovtor.Visible:=false;
  pnPovtor.Parent := nil;
  dsSeria.DataSet := dmBase.SvidSeria;
  SetLength(FArrCheckBelField,0);
  FMainTable := nil;
  FAutoNum   := false;
  FAutoVus:=GlobalTask.ParamAsBoolean('VUS_SOATO');

  if not Dokument.Active then Dokument.Active:=true;
  Dokument.Tag:=Integer(Self);

  SetLength(FArrAddProperty,0);
  SetLength(FArrChoiceRekv,0);
  SetLength(FArrCheckControl,0);
  FGrid:=nil;
  FPageControl := nil;
  FClearKey:=false;
  SetRole;
  FCheckBelName := GlobalTask.ParamAsBoolean('CHECK_BEL_NAME');
  FCheckFamily  := GlobalTask.ParamAsBoolean('AUTO_FAMILY');

  FPrintSpecSvid:=GlobalTask.ParamAsBoolean('PR_SPEC_SVID');
  FEnabledSpecBel:=FPrintSpecSvid;

  FPrintSpecSprav:=GlobalTask.ParamAsInteger('PR_SPEC_SPRAV');
  FFirstUpper   := true;
  RelationControl := TObjectList.Create(true);

  TBItemSprAkt.Visible:=false;
  TBItemDeclSvid.Visible:=false;
  if not GlobalTask.ParamAsBoolean('CHECK_SVID') then begin
    TBItemSvidIspor.Visible := false;
  end;
  {$IFDEF ZAGS}
    if Dokument.FindField('ID_ZAGS')<>nil then begin
      TBItemZAGS.Visible:=true;
      TBItemZAGS.Enabled:=true;
    end else begin
      TBItemZAGS.Visible:=false;
      TBItemZAGS.Enabled:=false;
    end;
  {$ELSE}
    TBItemZAGS.Visible:=false;
    TBItemZAGS.Enabled:=false;
  {$ENDIF}
  if GlobalTask.DemoVersion then begin
    GlobalTask.SetEnablePrintReport(false);
    TBItemPrint.Enabled := false;
    TBItemPrint.Caption:='Демо-версия';              
    TBItemDesignReport.Visible := false;
  end;
  oldCurDok:=GetCurDok;
  SetCurDok( Self );
  ListOpis:=GlobalTask.CurrentOpisEdit;
  if ListOpis<>nil then
    ListOpis.SetKeyForm(Self,nil);

//  SetFlat(GlobalFlat);

  TBSubmenuTmp.Visible := LoadTemplate(Self.Name);

  if TBSubmenuRun.Visible then begin
    TBSubmenuRun.Visible:=CreateSubmenuRun;
  end;

  bit:=TBitmap.Create;
  Screen.OnActiveControlChange := ActiveControlChanged;

  TBItemFastPrint.Visible:=GlobalTask.ParamAsBoolean('PRINT_SPEED');
  TBItemFastPrint.Enabled:=TBItemFastPrint.Visible;

  if not TBItemFastPrint.Visible
    then TBItemFastPrint.ShortCut:=0;  //TextToShortCut('');

  SetEvent;
//  if Role.SystemAdmin then begin
//    TBItemTest.Visible:=true;
//  end else begin
//    TBItemTest.Visible:=false;
//  end;
end;

//---------------------------------------------------------------------------
constructor TfmSimpleD.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  CreateAll;
end;
//---------------------------------------------------------------------------
procedure TfmSimpleD.FormCreate(Sender: TObject);
begin
//  перенесено в CreateAll
end;
//---------------------------------------------------------------------------
constructor TfmSimpleD.CreateMDI(Owner: TComponent);
begin
  inherited Create(Owner);
//   FIsMDI:=True;
  FormStyle:=fsMDIChild;
  CreateAll;
end;

const
  PropForm = ',Left,Top,Width,Height,WindowState,';
  PropSP   = ',Top,';

destructor TfmSimpleD.Destroy;
begin
  Screen.OnActiveControlChange := nil;
  FPar.Free;
//  FCurKeyBoard
  SetLength(FArrCheckControl,0);
  ds2xml.Free;
  FFilterItems.Free;
  FProtokol.Free;
  SaveToIni;
  bit.Free;
  RelationControl.Free;
  inherited Destroy;
end;

procedure TfmSimpleD.FormDestroy(Sender: TObject);
begin
  if FCurKeyBoard>0 then
    ActivateKeyboardLayout(FCurKeyBoard,KLF_ACTIVATE);

  SetCurDok( oldCurDok );
  if FDokZags and N_F_edTypeEkz.Visible then begin
    if DokumentTYPE_EKZ.AsInteger>90  then begin
      GlobalTask.SetLastValueAsInteger('TYPE_EKZ',N_F_edTypeEkz.ItemIndex);
    end else begin
      GlobalTask.SetLastValueAsInteger('TYPE_EKZ',0);
    end;
  end;
//  FreeAndNil(frxDBDokument);
//  FreeAndNil(frxDBSvidPovtor);
end;
//-------------------------------------------------------------------------
function TfmSimpleD.GetMaxYear:Integer;
begin
  Result:=FCurYear+1;
end;

function TfmSimpleD.GetMinYear:Integer;
begin
  if dmBase.OblArxivZAGS
    then Result:=1500
    else Result:=FCurYear-100;
end;

//-------------------------------------------------------------------------
procedure TfmSimpleD.CheckImageCondIN_( edIN:TWinControl; sValue:String; im : TImage);
begin
{$IFDEF GISUN}
  if sValue='1' then begin
    ImGISUN.GetIcon(11,Im.Picture.Icon);
    if edIN<>nil then begin
      Im.Left:=edIN.Left+edIN.Width+2;
      Im.Top:=edIN.Top+Round((edIN.Height-Im.Height)/2);
    end;
    Im.Hint:='Идентификационный номер не подлежит печати';
    Im.Visible:=true;
    Im.Repaint;
  end else begin
    Im.Visible:=false;
    Im.Hint:='';
  end;
{$ENDIF}
end;

//-------------------------------------------------------------------------
procedure TfmSimpleD.CheckImageGisun( fldPoleGrn : TField; im : TImage);
{$IFDEF GISUN}
var
  i : Integer;
{$ENDIF}
begin
{$IFDEF GISUN}
  i := Gisun.GetPoleGrn(fldPoleGrn);
  if (i>0) and (i<4) then begin
//    ImGISUN.GetBitmap(i,Im.Picture.Bitmap);
    ImGISUN.GetIcon(i,Im.Picture.Icon);
  end else begin
//    ImGISUN.GetBitmap(0,Im.Picture.Bitmap);
    ImGISUN.GetIcon(0,Im.Picture.Icon);
  end;
//  Im.Transparent:=true;
  Im.Repaint;
//  Im.Picture.Bitmap:=bit;
  case i of
    0: Im.Hint := 'Взаимодействие с ГИС РН не осуществлялось';
    1: Im.Hint := 'Не подлежит отправке в ГИС РН';
    2: Im.Hint := 'Осуществлен только запрос данных из ГИС РН';
    3: Im.Hint := 'Данные отправленв в ГИС РН';
  end;
{$ENDIF}
end;

//-------------------------------------------------------------------------
// вазаимодействие с регистром завершено
function TfmSimpleD.GisunOk(fldPoleGrn : TField) : Boolean;
{$IFDEF GISUN}
var
  i : Integer;
{$ENDIF}
begin
{$IFDEF GISUN}
  Result:=false;
  i := Gisun.GetPoleGrn(fldPoleGrn);
  if (i=rPost) then begin
    Result:=true;
  end;
{$ELSE}
  Result:=false;
{$ENDIF}
end;

//-------------------------------------------------------------------------
// вазаимодействие с регистром для текущей записи разрешено
function TfmSimpleD.IsRegisterGisun : Boolean;
begin
  Result:=true;
end;
//-------------------------------------------------------------------------
procedure TfmSimpleD.Event_GridColumnsGetPoleGrn(Sender: TObject;  EditMode: Boolean; Params: TColCellParamsEh);
var
  n:Integer;
begin
{$IFDEF GISUN}
  if not EditMode then begin
    n:=Gisun.GetPoleGrn(TColumnEh(Sender).Field);
    Params.ImageIndex:=n;
    if not IsRegisterGisun
      then Params.ImageIndex:=6;
  end;
{$ENDIF}                                 
end;
//-------------------------------------------------------------------------
procedure TfmSimpleD.SetAddProperty( n : Integer; strFieldName : String;  strKodProp : String; nType : TFieldType);
begin
  FArrAddProperty[n].FieldName := strFieldName;
  FArrAddProperty[n].DataType  := nType;
  FArrAddProperty[n].KodProp   := strKodProp;
end;

procedure TfmSimpleD.LoadFromIni;
//var
//  n:Integer;
// ListOpis : TListOpisEdit;
begin
//  ListOpis:=GlobalTask.CurrentOpisEdit;
//  if ListOpis<>nil then
//    ListOpis.SetKeyForm(Self,nil);
  CompFromIni(Self,GlobalTask.iniFile('FORM'), Name, PropForm);
  if (WindowState<>wsNormal) and (WindowState<>wsMaximized) then begin
    WindowState:=wsNormal;
  end;
  if WindowState=wsMinimized then WindowState:=wsNormal;
  if WindowState<>wsMaximized then begin
    if (Left<2) or (Top<2) or (Top+Height>Screen.Height) or (Left+Width>Screen.Width) then begin
      Left:=10;
      Top:=10;
      if Constraints.MinWidth>0  then Width:=Constraints.MinWidth;
      if Constraints.MinHeight>0 then Height:=Constraints.MinHeight;
    end;
  end;
  CompFromIni(sb,GlobalTask.iniFile('FORM'), Name+'.Панель', ',Height,');
  QueryExit:=false;

  if FOnlySvid and not GlobalTask.ParamasBoolean('WRITE_ONLYSVID') then begin
    FEnableWrite:=false;
  end;

  if GetNameReport='' then begin
    TBItemPreView.Visible:=false;
    TBItemPrint.Visible:=false;
    stBar.Panels[0].Text:='<F2> записать  <Ctrl-F2> выход  <F10> выбор'
  end else begin
    TBItemPreView.Visible:=true;
    TBItemPrint.Visible:=true;
  end;

  if not FEnableWrite then begin
    CheckToolBar(TBToolbar, FEnableWrite);
//    TBItemWrite.Visible:=false;
//    TBItemCancel.Visible:=true;
  end;
end;
//------------------------------------------------------------------
function TfmSimpleD.SaveToIni : Boolean;
var
  ini : TSasaIniFile;
begin
  ini := GlobalTask.iniFile('FORM');
  if (WindowState<>wsNormal) and (WindowState<>wsMaximized) then begin
    WindowState:=wsNormal;
//    PutError('222222222222');
  end;
  CompToIni(Self, ini, Name, PropForm);
  CompToIni(sb, ini, Name+'.Панель', ',Height,');
  Result := true;
end;
//------------------------------------------------------------------
procedure TfmSimpleD.SetFlat( lFlat : Boolean);
begin
  // FCharCase   -1 или TEditCharCase=(0-ecNormal, 1-ecUpperCase, 2-ecLowerCase);
  SetFlatEhComp(Self,lFlat,FCharCase,FCheckSVIDControl);
end;
//------------------------------------------------------------------
procedure TfmSimpleD.GrantSprav;
var
//  lEnableEdit : Boolean;
  par : TParamGrantSprav;
  fld:TField;
  n:Integer;
begin
  if Role.SystemAdmin then begin
    par:=TParamGrantSprav.Create;
    par.EnableEdit:=true;
    par.TypeEditObj:= FTypeObj;
    par.Caption:='';
    par.KodGurnal:='';
    par.VUS:=false;
    fld:=Dokument.FindField('VUS');
    if fld<>nil then par.VUS:=fld.AsBoolean;
    par.OCHERED:=false;
    fld:=Dokument.FindField('OCHERED');
    if fld<>nil then par.OCHERED:=fld.AsBoolean;
    {$IFDEF ZAGS}
      n:=FTypeObj;
    {$ELSE}
      n:=0;
    {$ENDIF}
    if n>0 then begin
      par.Caption:='Получить отчет';
    end;
    ExecSprav(DokumentID.AsString,par,n,nil,false);
  end;
end;

procedure TfmSimpleD.TBItemSetUpClick(Sender: TObject);
begin
  if ActiveControl is TDbGridEh then begin
    SetUpGrid(TDbGridEh(ActiveControl),'',true);
  end else begin
    GrantSprav;
  end;
end;

procedure TfmSimpleD.SetRole;
begin
  TBItemSetUp.Visible:=Role.SystemAdmin or EnableReport; //Role.Enabled(toConfig);
  TBItemDesignReport.Visible:=Role.SystemAdmin or EnableReport; // or Role.Enabled(toDesignReport);
end;

procedure TfmSimpleD.TBItemDesignReportClick(Sender: TObject);
var
  s : String;
begin
  DestroyHint(H);
  PostDokument;
  s := GetNameReport;
  GlobalTask.DesignTailReport( s );
end;

procedure TfmSimpleD.StBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  PutStrHelp(Panel.Text, StatusBar.Canvas ,Rect);
end;

procedure TfmSimpleD.TBItemPereklClick(Sender: TObject);
begin
  DestroyHint(H);
  if FGrid<>nil then begin
    if ActiveControl is TSasaDbGrid then begin
      ActiveControl:=FOldControl;
    end else begin
      FOldControl:=ActiveControl;
      ActiveControl:=FGrid;
    end;
  end;
end;

procedure TfmSimpleD.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 lSetDecimal:=false;
 if Key = VK_DECIMAL then begin
   lSetDecimal:=true;
 end;
 // Ctrl-0
 if (Shift=[ssCtrl]) and ((Key=VK_LEFT) or (Key=VK_RIGHT)) then begin
   if FindParentControl(ActiveControl) then begin
     Key:=0;
   end;
 end else if (Shift=[ssCtrl]) and ((Key=188) or (Key=190)) then begin
   if ActiveControl is TDBEditEh then begin
     FRun:=true;
     if Key=188 then begin
       TDBEditEh(ActiveControl).Text:=FirstUpper(TDBEditEh(ActiveControl).Text);
     end else begin
       TDBEditEh(ActiveControl).Text:=ANSIUpperCase(TDBEditEh(ActiveControl).Text);
     end;
     FRun:=false;
   end;
 end else if (Shift=[ssCtrl]) and (Key=48) and (FFirstControl<>nil) then begin
   ActiveControl:=FFirstControl;
 end else if (Shift=[ssAlt]) then begin
   if (Key>=49) and (Key<=52) then begin
     if N_F_edTypeEkz.Visible and ( (Key-49)<N_F_edTypeEkz.Items.Count ) then begin
       N_F_edTypeEkz.ItemIndex:=Key-49;
       CheckEkz;
     end;
   end;       
 end else begin
   Event_FormKeyDown(Self, FClearKey, Sender, Key, Shift, FPageControl, FCheckKeyGrid,slGo);
 end;
end;

procedure TfmSimpleD.SetQueryExit(const Value: Boolean);
begin
  FQueryExit := Value;
end;

procedure TfmSimpleD.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if FClearKey then begin
    Key:=#0;
  end;
  FClearKey:=false;
  if lSetdecimal then begin
    Key := DecimalSeparator;
    lSetDecimal:=false;
  end;
//    TDBDateTimeEditEh(ActiveControl). CalendarVisible:=true;
//    SendMessage(TDBDateTimeEditEh(ActiveControl).Handle, CB_SHOWDROPDOWN, 1, 0);
//  end;
end;

procedure TfmSimpleD.TBItemDelListClick(Sender: TObject);
begin
  DestroyHint(H);
  if ActiveControl is TDbGridEh then begin
    if not TDbGridEh(ActiveControl).DataSource.DataSet.IsEmpty then begin
      if Problem(' Удалить текущую строку ? ',mtConfirmation,Self) then begin
        QueryExit:=true;
//        RunProcScript(KodJurnal+'_'+KodCurrentList+'BEFOREDELETE',v);
        TDbGridEh(ActiveControl).DataSource.DataSet.Delete;
//        RunProcScript(KodJurnal+'_'+KodCurrentList+'AFTERDELETE',v);
      end;
    end;
  end;
end;
//------------------------------------------------
// видимость закладки повторных свидетельств
procedure TfmSimpleD.CheckTsSvidPovtor;
begin
  if not FOnlySvid then begin
    {$IFDEF ZAGS}
      if (FcbPovtor<>nil) then  begin
        if not FOnlySvid then begin
          FtsPovtor.TabVisible:=FcbPovtor.Checked or not SvidPovtor.IsEmpty;
        end;
      end;
    {$ELSE}
      if (FcbPovtor<>nil) then  begin
        FtsPovtor.TabVisible:=false;
      end;
    {$ENDIF}
  end;
end;
//------------------------------------------------
procedure TfmSimpleD.UpdateActions;
begin
  inherited;
end;

function TfmSimpleD.RunProcScript(strFuncName: String; var vResult : Variant): Boolean;
begin
  //vResult:=null;
  Result:=false;
  if (GlobalTask.Script<>nil) and not FRun then begin
    FRun:=true;
    try
      Result := GlobalTask.Script.RunEx(strFuncName,[],vResult);
    finally
      FRun := false;
    end;
  end;
end;

procedure TfmSimpleD.FormClose(Sender: TObject; var Action: TCloseAction);
var
  n : Integer;
begin
//  if (Action = caFree)  then begin
//    ShowWindow(Application.Handle, SW_RESTORE);
//  end;

  DestroyHint(H);

  if FRun then begin  // если идет процесс
    Beep;
    Action:=Forms.caNone;
    exit;
  end;

  if not FEnableWrite then begin
    exit;
  end;
  PostDokument;
  if QueryExit then begin
    if not FQuestAsNew or (DokumentID.AsInteger=-1) or FOnlySvid or FDokZags or FDokRegister then begin
      n := QuestionPos(' Сохранить документ ? ',
        'Да;Нет; Продолжить ;','',-1,-1,qtConfirmation, Self);
      if n=3 then n:=4;
    end else begin
      n := QuestionPos(' Сохранить документ ? ',
        'Да;Нет; Как новый ; Продолжить ;','',-1,4,qtConfirmation,Self);
    end;
    if n=4 then begin
      Action:=Forms.caNone;
      exit;
    end;
    //----------- сохранить как новый -----------------
    if (n=3) and (DokumentID.AsInteger<>-1) then begin
      CheckAsNew;
      n:=1;
    end;
    //-------------------------------------------------
    if n=1 then begin //Problem('    Сохранить документ ?    ') then begin
      if not WriteDok then begin
        Action:=Forms.caNone;
      end else begin
        ModalResult:=mrOk;
      end;
    end else begin
      QueryExit:=false;
    end;
  end;
  // если выходим без сохранения и документ был новый проверим
  // попробуем отвернуть значение для автонумерации
  if (Action <> caFree) and (DokumentID.AsInteger=-1) then begin
//    Dokument.SetNextNumber( '' );
  end;
  {
    end else begin
      Close;
    end;
  end else begin
    Close;
  end;
  }
end;

procedure TfmSimpleD.TBItemReLoadClick(Sender: TObject);
//var
//  v : Variant;
begin
//  RunProcScript('CURRENTDOK',v);
end;


procedure TfmSimpleD.TBItemWriteClick(Sender: TObject);
begin
  DestroyHint(H);

  if FRun then begin  // если идет процесс
    Beep;
    exit;
  end;

  if not FEnableWrite then begin
    beep;
    exit;
  end;

  if WriteDok then ModalResult := mrOk;

end;

procedure TfmSimpleD.TBItemCancelClick(Sender: TObject);
begin
  PostDokument;
  Close;
end;
//--------------------------------------
function TfmSimpleD.BeforeSkip : Boolean;
var
  n : Integer;
begin
  if not FEnableSkip then begin
    Result:=false;
    exit;
  end;
  if not FEnableWrite then begin
    Result:=true;
    exit;
  end;              
  PostDokument;
  // когда документ новый перемещаться нельзя
  if DokumentID.AsInteger=-1 then begin
    Result := false;
  end else begin
    Result := true;
  end;
  if Result then begin
//    if CheckDokument(1,false,true,false) then begin
      if QueryExit then begin
        if TBItemNonQuery.Checked then begin
          n := 1;
        end else begin
          n := QuestionPos(' Сохранить документ ? ',
            'Да;Нет; Продолжить ;','',-1,-1,qtConfirmation,Self);
          if n=3 then begin
            Result := false;
            exit;
          end;
        end;
        //-------------------------------------------------
        if n=1 then begin //Problem('    Сохранить документ ?    ') then begin
          if not WriteDok then begin
            Result := false;
          end;
        end else begin
          QueryExit:=false;
        end;
      end;
//    end;
  end;
end;
//--------------------------------------
procedure TfmSimpleD.SkipDok(nType:Integer);
var
  n:Integer;
  fld:TField;
  sBookmark:TBookmarkStr;
begin
  if SkipDataSet<>nil then begin
    n:=SkipDataSet.FieldByName('ID').AsInteger;
    fld:=SkipDataSet.FindField('VOSSTAN');
    sBookmark:=SkipDataSet.Bookmark;
    if BeforeSkip then begin
 //     Dokument.DisableControls;
      case nType of
        1: SkipDataSet.First;
        2: SkipDataSet.Prior;
        3: SkipDataSet.Next;
        4: SkipDataSet.Last;
      end;
 //     Dokument.EnableControls;
      if fld<>nil then begin
        if fld.AsBoolean=true then begin
          case nType of
            1: while fld.AsBoolean=true do SkipDataSet.Next;
            2: begin
                 while not SkipDataSet.Bof and (fld.AsBoolean=true) do SkipDataSet.Prior;
                 if SkipDataSet.Bof then SkipDataSet.Bookmark:=sBookmark;
               end;
            3: begin
                 while not SkipDataSet.Eof and (fld.AsBoolean=true) do SkipDataSet.Next;
                 if SkipDataSet.Eof then SkipDataSet.Bookmark:=sBookmark;
               end;
            4: while fld.AsBoolean=true do SkipDataSet.Prior;
          end;
        end;
      end;
      if n<>SkipDataSet.FieldByName('ID').AsInteger then begin
        AfterSkip;
      end;
    end;
  end;
end;
//--------------------------------------
procedure TfmSimpleD.AfterSkip;
var
  lCheck:Boolean;
begin
  EditDataSet(Dokument);
  DokumentID.AsInteger := SkipDataSet.FieldByName('ID').AsInteger;
  PostDataSet(Dokument);
  lCheck:=dbDisableControls(Dokument);
  IsReadDokument:=true;
  CheckHistory(true);
  ReadDok( DokumentID.AsInteger );
  AfterReadDok;
  IsReadDokument:=false;
  dbEnableControls(Dokument,lCheck);
  UserAfterSkip;
  QueryExit:=false;
end;

//--------------------------------------
procedure TfmSimpleD.AfterReadDok;
begin
  TBItemZAGS.Visible:=false;
  CheckEnabledNameOrgan(false);
  {$IFDEF GISUN}
    CheckAkt_GISUN(0);
    BeforeEditFormGISUN;
  {$ENDIF}
end;

//--------------------------------------
procedure TfmSimpleD.SetSimpleVvod(sName:String);
begin
// своя прцедура для каждого типа объекта
  FSimpleVvod:=true;
end;

//--------------------------------------
procedure TfmSimpleD.SetEnableSkip(lSet:Boolean);
var
  sPoint:String;
  obj:TObject;
begin
  if lSet then begin
    sPoint:=GetParam('SKIP_POINTER','');
    if sPoint<>'' then begin
      try
        obj:=Pointer(StrToInt(sPoint));
        if obj is TDataSet then begin
          SkipDataSet:=Pointer(StrToInt(sPoint));
        end;
      except
      end;
    end;
    if SkipDataSet=nil
      then SkipDataSet:=DataSetCurGurnal;
    if SkipDataSet=nil then FEnableSkip:=false
                       else FEnableSkip:=true;
  end else begin
    FEnableSkip:=false;
    SkipDataSet:=nil;
  end;
  TBItemFirst.Visible:=FEnableSkip;
  TBItemPrev.Visible:=FEnableSkip;
  TBItemNext.Visible:=FEnableSkip;
  TBItemLast.Visible:=FEnableSkip;
  TBItemNonQuery.Visible:=FEnableSkip;
  TBSeparatorMove1.Visible:=FEnableSkip;
  TBSeparatorMove2.Visible:=FEnableSkip;
end;
//--------------------------------------
procedure TfmSimpleD.UserAfterSkip;
begin
//
end;
//--------------------------------------
procedure TfmSimpleD.TBItemAddListClick(Sender: TObject);
var
//  arrRec : TCurrentRecord;
  Grid : TDbGridEh;
begin
  DestroyHint(H);
  if ActiveControl is TDbGridEh then begin
    Grid := TDbGridEh(ActiveControl);
    AddCurList(Grid);
    {
    if not Grid.DataSource.DataSet.IsEmpty then begin
      if not Grid.EditorMode then begin
        GetCurrentRecord(Grid.DataSource.DataSet, '', arrRec);
        AddCurrentRecord(Grid.DataSource.DataSet, arrRec);
        Grid.SelectedIndex:=Grid.VisibleColumns.Items[0].Index;
      end;
    end;
    }
  end;
end;

procedure TfmSimpleD.AddCurList(Grid:TDbGridEh);
begin
  Grid.DataSource.DataSet.CheckBrowseMode;
  Grid.DataSource.DataSet.Append;
end;
//------------------------------------------------
function TfmSimpleD.CheckDateEditGIS:Boolean;
begin
  Result:=false;
end;
//------------------------------------------------
function TfmSimpleD.GetNameReport: String;
begin
  Result:=GetNameReportVid(getVid);
end;

procedure TfmSimpleD.dsDokumentDataChange(Sender: TObject; Field: TField);
var
  v : Variant;
  fld : TField;
  strField : String;
begin
  if (Field<>nil) and (Dokument<>nil) and not IsReadDokument then begin
    QueryExit := true;
    if FDokZags then begin
      strField := UpperCase(Field.FieldName);
      // что-бы при корректировки только поля "Копия" не выдавался запрос на сохранение
      if strField<>'COPIA' then QueryExit := true;
      //----- !!! если выписывается полная актовая запись, а не свидетельство !!!
      if not FOnlySvid then begin
        // из даты свидетельства в дату актовой записи
        if (strField='DATESV') then begin
          if (FTypeObj<>_TypeObj_ZRogd) and (FTypeObj<>_TypeObj_ZRast) then begin     // только не для рождения и расторжения
            fld := Field.DataSet.FindField('DATEZ');
            if (fld<>nil) and not Field.IsNull then begin
              fld.AsDateTime := Field.AsDateTime;
            end;
          end;
        // если корректируем дату актовой записи и дата выдачи свидетельства пуста
        end else if strField='DATEZ' then begin
          fld := Field.DataSet.FindField('DATESV');
          if (fld<>nil) and fld.IsNull then begin
            fld.AsDateTime := Field.AsDateTime;
          end;
        end;
      end;
      //--------------------------------------------------------------------
    end;
    RunProcScript(GetVid+'_'+UpperCase(Field.FieldName),v);
  end;
end;


procedure TfmSimpleD.RunCalc;
Var
//  w1: Word;
  p1,p2: array[0..100] of Char;
begin
  StrPcopy(p1,'CALC');
  IF GetModuleHandle(p1)=0 THEN begin
    StrPcopy(p2,'Calc.exe');
//    w1:=WinExec(p2,SW_Restore);
    WinExec(p2,SW_Restore);
  end;

  {
  ShellExecute(0 ,                 //hWnd: HWND;
               'open',                //Operation,
               'calc.exe', //FileName,
               Nil,                //Parameters,
               Nil,                //Directory: PChar;
               0                   //ShowCmd: Integer
                    );             //: HINST; stdcall;
  }
end;

{
  if FDokument.EnableNDS or FDokument.EnableAccount or FDokument.EnableConnDok then begin
    if FDokument.MakeStdList then begin
    end;
  end;
}

procedure TfmSimpleD.TBItemCalcClick(Sender: TObject);
begin
  DestroyHint(H);
  RunCalc;
end;

procedure TfmSimpleD.TBItemPreViewClick(Sender: TObject);
var
  strReport : String;
begin
  DestroyHint(H);
  PostDokument;
  if BeforeReport then begin
    strReport := GetNameReport;
    if strReport<>'' then begin
      GlobalTask.PreViewReport(strReport);
      AfterReport;
    end;
  end;
end;

procedure TfmSimpleD.TBItemPrintClick(Sender: TObject);
var
  strReport : String;
begin
  DestroyHint(H);
  PostDokument;
  if BeforeReport then begin
    strReport := GetNameReport;
    if strReport<>'' then begin
      GlobalTask.PrintReport(strReport);
      AfterReport;
    end;
  end;
end;

procedure TfmSimpleD.TBItemFastPrintClick(Sender: TObject);
var
  strReport : String;
begin
  DestroyHint(H);
  PostDokument;
  if BeforeReport then begin
    strReport := GetNameReport;
    if strReport<>'' then begin
      GlobalTask.FastPrintReport(strReport);
      AfterReport;
    end;
  end;
end;

//------------------------------------------------------------
//  после получения отчета
procedure TfmSimpleD.AfterReport;
begin
//
end;

//------------------------------------------------------------
//  перед получением отчета
function TfmSimpleD.BeforeReport: Boolean;
begin
//  Result:=true;
  fmMain.frxPDFExport.FileName:='';
  fmMain.frxPDFExport.Title:='';
  Result:=CheckDokument(1,true,true,false);
end;
//------------------------------------------------------------
function TfmSimpleD.EditModal: Boolean;
var
  s:String;
begin
  if FError=0 then begin
    LoadFromIni;
    BeforeEdit;
    SetFlat(GlobalFlat);

    if (GetParam('ENABLE_SKIP','0')='1') and (DokumentID.AsInteger>0)  then begin
      SetEnableSkip(true);
     end else begin
      SetEnableSkip(false);
    end;

    if GetParam('RUN_REPORT','0')='1' then begin
      RunReport;
    end;

    s:=Trim(GetParam('RUN_SIMPLE',''));
    if s<>''
      then SetSimpleVvod(s);

    if IsShowEdit then begin
      if (ShowModal=mrOk) or FRefreshGurnal then begin
        AfterEdit;
        Result := true;
      end else begin
        Result := false;
      end;
    end else begin
      Result:=false;
    end;
  end else begin
    Result:=false;
  end;
end;

//------------------------------------------------------------
procedure TfmSimpleD.EditChild;
begin
  if FError=0 then begin
    Visible:=true;
    Show;
    LoadFromIni;
    BeforeEdit;
    SetFlat(GlobalFlat);

    if GetParam('RUN_REPORT','0')='1' then begin
      RunReport;
    end;

    BringToFront;
  end;
end;
//------------------------------------------------------------
procedure TfmSimpleD.SetIDZags(nID:Integer);
var
  fld:TField;
  i:Integer;
  s:String;
begin
  fld:=Dokument.FindField('ID_ZAGS');
  if fld<>nil then begin    
    EditDataSet(Dokument);
    if nID>0 then begin      // перевыбираем ЗАГС
      fld.AsInteger := nID;
      DokumentNAME_ZAGS.AsString:='';
      DokumentNAME_ZAGS_B.AsString:='';
    end else begin
      if fld.IsNull or (fld.AsInteger=0) then begin
        {$IFDEF ZAH}
          fld.AsInteger := StrToIntDef(GlobalTask.ParamAsString('ID'),0);
        {$ELSE}
          fld.AsString := GlobalTask.ParamAsString('ID');
        {$ENDIF}
      end;
    end;
//    {$IFDEF GISUN}
//      Gisun.MessageSource:=fld.AsString;
//    {$ENDIF}
    {$IFDEF ZAGS}
    if FShowOrgCaption then begin
      i := Pos('(', Caption);
      s:=Trim(DokumentNAME_ZAGS.AsString);
      if i = 0 then begin
        Caption := Caption + '  ( ' + fmMain.SprNameOrg(fld.AsInteger,'','',s) + ' )';
      end else begin
        Caption := Copy(Caption,1,i-3) + '  ( ' + fmMain.SprNameOrg(fld.AsInteger,'','',s) + ' )';
      end;
      if s<>'' then begin
        Caption := Caption+ '  ОРГАН ВВЕДЕН ВРУЧНУЮ';
      end;
    end;
    {$ELSE}
    if FShowOrgCaption then begin
      i := Pos('(', Caption);
      if i = 0 then begin
        Caption := Caption + '  ( ' + fmMain.SprNameOrg(fld.AsInteger,'','') + ' )';
      end else begin
        Caption := Copy(Caption,1,i-3) + '  ( ' + fmMain.SprNameOrg(fld.AsInteger,'','') + ' )';
      end;
    end;
    {$ENDIF}
  end;
end;

//------------------------------------------------------------
function TfmSimpleD.NewDok( lAppend : Boolean ) : Boolean;
var
  v : Variant;
  lCheck:Boolean;
  nIDDok:Integer;
  {$IFNDEF ZAGS}
    n:Integer;
  {$ENDIF}                    
begin
  nIDDok:=0;
  if lAppend then
    FBOOKMARK_SVIDPOVTOR:='';              
  lCheck:=dbDisableControls(Dokument);
  Result := true;
  if GetVid <> '' then begin
    if FDokZags or FDokRegister then begin
      if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
        if not HistZAGS.Active then HistZAGS.Active:=true;
      end;
      if not SvidPovtor.Active then SvidPovtor.Active:=true;
      if FOnlySvid then begin
        EditDataSet(Dokument);
        DokumentPOVTOR.AsBoolean:=true;
      end;
    end;
    v := null;
    RunProcScript(GetVid+'_AfterCreate',v);
    if (v <> null) and (VarType(v)=varBoolean) then Result := v;
    if Result and lAppend then begin
      {$IFNDEF ZAGS}
        // если раздельный учет для города и села
        if FDokZAGS and GlobalTask.ParamAsBoolean('PLUS_GOROD') then begin
           n := QuestionPos(' Выберите тип актовой записи. ',
              '  Город  ;  Село  ','',1,1,qtConfirmation,Self);
           if n=-1 then n:=1;
//           EditDataSet(D)
           DokumentIS_GOROD.AsBoolean:= (n=1);
        end;
      {$ENDIF}
      AdditiveNewDok;
      nIDDok:=SetNewNomerDok(false);
    end;
    {$IFDEF ZAGS}
    if Result and GlobalTask.ParamAsBoolean('AUTO_POVTOR') then begin
//      Dokument.CheckBrowseMode;
//      Dokument.Edit;
      DokumentPOVTOR.AsBoolean := true;
     // Dokument.Post;
    end;
    DokumentPRINT_POVTOR.AsBoolean := true;
    {$ENDIF}
  end;
  if FDokZags and N_F_edTypeEkz.Visible then begin
    {$IFDEF ZAGS}
      N_F_edTypeEkz.ItemIndex:=GlobalTask.GetLastValueAsInteger('TYPE_EKZ');
    {$ELSE}
      N_F_edTypeEkz.ItemIndex:=0;
    {$ENDIF}
    CheckEkz;
  end;

  DokumentDELETE_CRLF.AsBoolean:=false;

  dbEnableControls(Dokument,lcheck);

  if FDokZags then begin
    if nIDDok>0 then begin
      LoadAkt(nIDDok);
    end;
  end;
end;
//------------------------------------------------------------
procedure TfmSimpleD.AfterEdit;
begin
//
end;
//------------------------------------------------------------
function TfmSimpleD.BeforeEdit: Boolean;
var
  s : String;
  i,n:Integer;
begin
  Result := true;
  if FDokZags then begin
    CheckLookupField;
//    dsObl.DataSet := nil;
//    dsObl.DataSet := dmBase.LookupObl;
//    dsRN.DataSet := nil;
//    dsRN.DataSet := dmBase.LookupRN;
    s := EM_NomerSvid;
    if FTypeObj=dmBase.TypeObj_ZRast then begin
      Dokument.FieldByName('ON_SVID_NOMER').EditMask := s;
      Dokument.FieldByName('ONA_SVID_NOMER').EditMask := s;
    end else if FTypeObj=dmBase.TypeObj_ZUstOtc then begin
      Dokument.FieldByName('SVID_NOMER2').EditMask := s;
    end;
    if Dokument.FindField('SVID_NOMER')<>nil then begin
      Dokument.FieldByName('SVID_NOMER').EditMask := s;
    end;
    if Dokument.FindField('NOMER')<>nil then begin
      Dokument.FieldByName('NOMER').EditMask := '99999;0;_';
    end;
  end;
  if Length(FArrCheckControl)>0 then begin
    for i:=0 to Length(FArrCheckControl)-1 do begin
      n:=FArrCheckControl[i].Cont1.Left;
      FArrCheckControl[i].Cont1.Left:=FArrCheckControl[i].Cont2.Left;
      FArrCheckControl[i].Cont2.Left:=n;
      if FArrCheckControl[i].Cont1_<>nil then begin
        FArrCheckControl[i].Cont1_.Left:=FArrCheckControl[i].Cont1.Left+FArrCheckControl[i].Cont1.Width+7;
      end;
    end;
  end;
end;

//------------------------------------------------------------
procedure TfmSimpleD.Init_ArrCheckControl(n: Integer);
begin
  SetLength(FArrCheckControl,n);
  for n:=0 to Length(FArrCheckControl)-1 do begin
    FArrCheckControl[n].Cont1:=nil;
    FArrCheckControl[n].Cont1_:=nil;
    FArrCheckControl[n].Cont2:=nil;
  end;
end;

//----------------------------------------------------------------------------------
function TfmSimpleD._getNameRukZAGS:String;
var
  fld:TField;
begin
  if FFieldDolgRuk<>'' then begin
    fld:=Dokument.FindField(FFieldDolgRuk);
    if (fld<>nil) and (fld.AsString<>'') then begin
      Result:=fld.AsString;
    end else begin
      Result:=FNameRukZags;
    end;
  end else begin
    Result:=FNameRukZags;
  end;
end;
//----------------------------------------------------------------------------------
function TfmSimpleD._getNameSpecZAGS:String;
var
  fld:TField;
begin
  if FFieldDolgSpec<>'' then begin
    fld:=Dokument.FindField(FFieldDolgSpec);
    if (fld<>nil) and (fld.AsString<>'') then begin
      Result:=fld.AsString;
    end else begin
      Result:=FNameSpecZags;
    end;
  end else begin
    Result:=FNameSpecZags;
  end;
end;
//----------------------------------------------------------------------------------
procedure TfmSimpleD.ReadOtherData(ds:TDataSet; sField:String);
var
  fld, fldVal:TField;
  i,n:Integer;
  arrVal:TArrStrings;
  sVal:String;
  AYear,AMonth,ADay,AHour,AMin,ASec:Word;
begin   
  fld:=ds.FindField(sField);
  if fld<>nil then begin
    StrToArr(fld.AsString, arrVal,#13#10, true);
    for i:=0 to Length(arrVal)-1 do begin
      n:=Pos('=', arrVal[i]);
      if n>0 then begin
        fldVal:=Dokument.FindField(Copy(arrVal[i],1,n-1));
        sVal:=Trim(Copy(arrVal[i],n+1,Length(arrVal[i])));
        if (fldVal<>nil) and (sVal<>'') then begin
          EditDataSet(fldVal.DataSet);
          if fldVal.DataType=ftDateTime then begin
            try
              AYear  :=StrToInt(string(copy(sVal, 1, 4)));
              AMonth :=StrToInt(string(copy(sVal, 6, 2)));
              ADay   :=StrToInt(string(copy(sVal, 9, 2)));
              if Length(sVal)>16 then begin
                AHour:=StrToInt(string(copy(sVal, 12, 2)));
                AMin :=StrToInt(string(copy(sVal, 15, 2)));
                ASec :=StrToIntDef(string(copy(sVal, 18, 2)), 0);
              end else begin
                AHour:=0;
                AMin :=0;
                ASec :=0;
              end;
              fldVal.AsDateTime:=EncodeDateTime(AYear,AMonth,ADay,AHour,AMin,ASec,0);
            except
              fldVal.AsString:='';
            end;
          end else begin
            fldVal.AsString:=Copy(arrVal[i],n+1,Length(arrVal[i]));
          end;
        end;  
      end;
    end;                        
  end;
end;
//----------------------------------------------------------------------------------
procedure TfmSimpleD.WriteOtherData(ds:TDataSet; sField:String; sFields:String);
var
  fld, fldVal:TField;
  i:Integer;                        
  arr:TArrStrings;
  s,sVal:String;
begin
  fldVal:=ds.FindField(sField);
  if fldVal<>nil then begin
    sVal:='';
    StrToArr(sFields, arr, ';', true);
    for i:=0 to Length(arr)-1 do begin
      fld:=Dokument.FindField(arr[i]);
      if (fld<>nil) and (fld.AsString<>'') then begin
        if fld.DataType=ftDateTime then begin
          if fld.AsDateTime>0 then begin
            s:=FormatDateTime('yyyy-mm-dd hh:nn:ss', fld.AsDateTime);
            sVal:=sVal+fld.FieldName+'='+s+#13#10;
          end;  
        end else begin
          s:=fld.AsString;
          sVal:=sVal+fld.FieldName+'='+s+#13#10;
        end;
      end;
    end;
    fldVal.AsString:=sVal;
  end;
end;
//------------------------------------------------------------
procedure TfmSimpleD.ReadDopProperty(nTypeObj,nKodObj : Integer; dDateSave : TDateTime);
var
  i : Integer;  
begin
  EditDataSet(Dokument);
  for i:=0 to Length(FArrAddProperty)-1 do begin
    Dokument.FieldByName(FArrAddProperty[i].FieldName).Value :=
    dmBase.ReadPropSimpleDok(nTypeObj, nKodObj, dDateSave, FArrAddProperty[i].FieldName,
                FArrAddProperty[i].DataType);
  end;
  ReadOtherData(Dokument, 'OTHER');
end;
//------------------------------------------------------------
procedure TfmSimpleD.WriteDopProperty(nTypeObj,nKodObj : Integer; dDateSave : TDateTime);
var
  i : Integer;
begin
  if dDateSave<=0 then begin
    dDateSave:=STOD(CURRENT_SOST,tdAds);
  end;
  for i:=0 to Length(FArrAddProperty)-1 do begin
    dmBase.WritePropSimpleDok(nTypeObj, nKodObj, dDateSave, FArrAddProperty[i].FieldName,
                Dokument.FieldByName(FArrAddProperty[i].FieldName));
  end;
end;
{$IF Defined(ZAGS) or Defined(LAIS) }
//------------------------------------------------------------
// Запросы для заявлений
procedure TfmSimpleD.ReadZapros(ds:TDataSet; nTypeObj:Integer; nID:Integer);
var
  arr:TArrStrings;
  i,j:Integer;
  strField,s:String;
begin
  with dmBase.tbSimplePropMemo do begin
    SetRange([nTypeObj,nID,STOD('18991230')],[nTypeObj,nID,STOD('18991230')]);
    while not Eof do begin
      if Copy(FieldByName('POKAZ').AsString,1,6)='ZAPROS' then begin
        StrToArr(FieldByName('VALUE').AsString, arr,#13#10,true);
        if Length(arr)>0 then begin
          ds.Append;
          for i:=Low(arr) to High(arr) do begin
            j:=Pos('=',arr[i]);
            strField:=Copy(arr[i],1,j-1);
            s:=Copy(arr[i],j+1,Length(arr[i]));
            if s<>'' then begin
              try
//                if (strField='FLD_DATEZ') or (strField='FLD_DATEO')
//                  then tbZapros.FieldByName(strField).AsDateTime:=STOD(s,tdAds)
                ds.FieldByName(strField).AsString:=s;
              except
              end;
            end;
          end;
          ds.Post;
        end;
      end;
      Next;
    end;
    CancelRange;
  end;
end;
//----- Запросы ----------------------------
procedure TfmSimpleD.WriteZapros(ds:TDataSet; nTypeObj:Integer; nID:Integer);
var
  s,strField:String;
  j,i:Integer;
begin
  s:='DELETE FROM BaseTextProp WHERE typeobj='+IntToStr(nTypeObj)+' and id='+IntToStr(nID)+' and dates=''1899-12-30'' and pokaz like ''ZAPROS%'' ';
  dmBase.AdsConnection.Execute(s);
  ds.First;
  j:=1;
  while not ds.Eof do begin
    s:='';
    for i:=0 to ds.FieldCount-1 do begin
      strField:=ds.Fields[i].FieldName;
//        if (strField='FLD_DATEZ') or (strField='FLD_DATEO')
//          then s:=s+strField+'='+DTOS(tbZapros.Fields[i].AsDateTime,tdAds)+#13#10
      s:=s+strField+'='+ds.Fields[i].AsString+#13#10;
    end;
    with dmBase.tbSimplePropMemo do begin
      Append;
      FieldByName('TYPEOBJ').AsInteger:=nTypeObj;
      FieldByName('ID').AsInteger:=nID;
      FieldByName('DATES').AsDateTime:=STOD('18991230');
      FieldByName('POKAZ').AsString:='ZAPROS'+IntToStr(j);
      FieldByName('VALUE').AsString:=s;
      Post;
    end;
    ds.Next;
    Inc(j,1);
  end;
  ds.First;
end;
{$IFEND}
//----------------------------------------------------------
function TfmSimpleD.WriteField(fldTo, fldFrom: TField): Boolean;
begin
  Result := true;
  if (fldTo<>nil) and (fldFrom<>nil) then begin
    if fldFrom.IsNull then begin
      try
        case fldFrom.DataType of
          ftBoolean : fldTo.Value := null;
          ftString  : fldTo.AsString := '';
//          ftInteger : fldTo.AsInteger:= 0;
          ftDate    : fldTo.AsString := '';
        else
          fldTo.Value := fldFrom.Value;
        end;
      except
        PutError(' Ошибка записи в поле <'+fldTo.FieldName+'> пустого значения. ',self);
        Result := false;
      end;
    end else begin
      try
        fldTo.Value := fldFrom.Value;
      except
        PutError(' Ошибка записи в поле <'+fldTo.FieldName+'> значения '+VarToStr(fldFrom.Value),self);
        Result := false;
      end;
    end;
  end;
end;
//------------------------------------------------------------
procedure TfmSimpleD.TBItemZAGSClick(Sender: TObject);
var
  fld : TField;
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
//  i:Integer;
begin
  DestroyHint(H);
  fld := Dokument.FindField('ID_ZAGS');
  if fld <> nil then begin
    Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_NAMEORG');
    if Opis<>nil then begin
      v := fld.Value;
      SetLength(arrRec,1);
      if Opis.ChoiceFromSprEx(nil, v, arrRec, nil) and (v<>null) then begin
        SetIDZags(v);
      end;
    end;
  end;
end;

function TfmSimpleD.ChoiceShablonZAGS(dsDok:TDataSet; strField:String; strPadeg:String; strAddFields:String):Integer;
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
  ID,i,n : Integer;
  fld:TField;
  lBel:Boolean;
  arr:TArrStrings;
begin
  Result:=0;
  DestroyHint(H);
  if dsDok=nil then begin
    dsDok:=Dokument;
  end;
  lBel:=false;
  if (Copy(strField,1,3)='<Б>') or (Copy(strField,1,3)='<B>') then begin
    strField:=Copy(strField,4,Length(strField));
    lBel:=true;
  end;
  fld:=dsDok.FindField(strField);
  if fld<>nil then begin
    if lBel
      then Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_NAMEORG_B')
      else Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_NAMEORG');
    if Opis<>nil then begin
      v := null;
      SetLength(arrRec,1);
      if Opis.ChoiceFromSprEx(nil, v, arrRec, nil) and (v<>null) then begin
        ID := StrToInt(VarToStr(v));
        EditDataSet(dsDok);
        if strField='NAME_ZAGS' then begin
          if lBel then begin
            dsDok.FieldByName('NAME_ZAGS').AsString:=fmMain.SprNameOrg(ID,'Б','');
          end else begin
            dsDok.FieldByName('NAME_ZAGS').AsString   := fmMain.SprNameOrg(ID,'',strPadeg);
            dsDok.FieldByName('NAME_ZAGS_B').AsString := fmMain.SprNameOrg(ID,'Б','');
          end;
        end else begin
          if (RightStr(strField,2)='_B') or lBel then begin
            fld.AsString:=fmMain.SprNameOrg(ID,'Б','');
          end else begin
            fld.AsString:=fmMain.SprNameOrg(ID,'',strPadeg);
            fld:=fld.DataSet.FindField(strField+'_B');
            if fld<>nil then begin
              fld.AsString:=fmMain.SprNameOrg(ID,'Б','');
            end;
          end;
        end;
        if strAddFields<>'' then begin
          StrToArr(strAddFields,arr,';',true);
          for i:=Low(arr) to High(arr) do begin
            n:=Pos('=',arr[i]);
            fld:=dsDok.FindField(Copy(arr[i],1,n-1));
            try
              if fld<>nil
                then GetValueFieldEx2(arrRec, Copy(arr[i],n+1,Length(arr[i])), fld);
            except
            end;
          end;
        end;
        dsDok.Post;
        Result:=ID;
      end;
    end;
  end;
end;

procedure TfmSimpleD.IN_UpdateData(Sender: TObject; var Handled: Boolean);
var
  ed : TDbEditEh;
  s : String;
begin
  ed := TDbEditEh(Sender);
  s  := Trim(ed.Text);
  if s<>'' then begin
    ed.Text:=CheckRUS2(s);
    if GlobalTask.ParamAsBoolean('KONT_IDENTIF') then begin
      ed.Text := CheckLichNom(true, ed.Text);
      s:=GetErrorCheck;
      if s<>'' then begin
        PutError(s,self);
        Activecontrol:=ed;
//        raise Exception.Create(s);
      end;
    end;
  end;
end;

const
  sss_err='Ошибочный символ "';
//---------------------------------------------------------------------
procedure TfmSimpleD.KeyPress_BLR(Sender: TObject; var Key: Char);
var
 c:Char;
begin
  if FCheckSimFIO and (Ord(Key)>32) and (Key<>#0) then begin
//    if (Key>='''') or (Key>='"') then  begin
//      Key:=#0;
//      PostMessage(TWinControl(Sender).Handle, WM_CHAR, Word(Key), 0);
//    end else begin
    c:=Key;
    if ((Key>='А') and (Key<='я')) or (Key in ['.','-',' ','І','і','Ў','ў','`','''','Ё','ё']) then  begin
      if Key in ['И','и','Щ','щ', 'Ъ','ъ'] then begin
        Key:=#0;
      end;
    end else begin
      Key:=#0;
    end;
    if Key=#0 then PutError(sss_err+c+'"',self);
//    end;
  end;
end;
//---------------------------------------------------------------------
procedure TfmSimpleD.KeyPress_RU(Sender: TObject; var Key: Char);
var
 c:Char;
begin
  if FCheckSimFIO and (Ord(Key)>32) and (Key<>#0) then begin
//    if (Key='''') or (Key='"') then  begin
//      Key:=#0;
//      PostMessage(TWinControl(Sender).Handle, WM_CHAR, Ord('`'), 0);
//    end else begin
    c:=Key;
    if ((Key>='А') and (Key<='я')) or (Key in ['.','-',' ','`','''','Ё','ё']) then  begin
    end else begin
      Key:=#0;
    end;
    if Key=#0 then PutError(sss_err+c+'"',self);
//    end;
  end;
end;
//---------------------------------------------------------------------
function TfmSimpleD.CheckFIO:String;
begin
  Result:='';
end;
//---------------------------------------------------------------------
function TfmSimpleD.CheckOneFIO(sText, sFamilia, sName, sOtch: String): String;
var
  n:Integer;
  procedure Check_(s:String; sss:String);
  begin
  if s<>'' then begin
    n:=Pos('-',s);
    if RightStr(s,1)='-' then begin
      Result:=Result+sText+'последний символ '+sss+' "-"'+chr(13)+chr(10);
    end else if Pos('--',s)>0 then begin
      Result:=Result+sText+'два символа подряд '+sss+' "--"'+chr(13)+chr(10);
    end;
  end;
  end;
begin
  Result:='';
  Check_(sFamilia, 'в фамилии');
  Check_(sName, 'в имени');
  Check_(sOtch, 'в отчестве');
end;

//---------------------------------------------------------------------
procedure TfmSimpleD.FIOUpdateData(Sender: TObject; var Handled: Boolean);
var
  ed : TDbEditEh;
  s,sField : String;
//  Pol:TPol;
//  fld:TField;
begin
  if FRun then exit;  // !!!

  ed := TDbEditEh(Sender);
  s:=DeleteAllSpace(ed.Text);
  sField:=UpperCase(ed.Field.FieldName);

  if FCheckRegistr then begin  // контролировать регистр букв
    ed.Text:=CheckRegisterText(FTypeCheckRegistr,s);
  end;
  {$IFDEF GISUN}
  {
     if FDokZags and IsActiveGISUN and Gisun.IsEnabled then begin
       if Gisun.IsEnableTypeAkt(FTypeObj,IsAktVosstan) then begin
         s:='';
       end;
     end;
  }
  {$ENDIF}
end;

procedure TfmSimpleD.FIOUpdateDataP(Sender: TObject; var Handled: Boolean);
var
  ed : TDbEditEh;
  s,sField,sName,sOtch : String;
//  Pol:TPol;
  fld:TField;
begin
  if FRun then exit;  // !!!

  ed := TDbEditEh(Sender);
  s:=DeleteAllSpace(ed.Text);
  sField:=UpperCase(ed.Field.FieldName);

  if FCheckRegistr then begin  // контролировать регистр букв
    ed.Text:=CheckRegisterText(FTypeCheckRegistr,s);
  end;
  {$IFDEF GISUN}
  {
     if FDokZags and IsActiveGISUN and Gisun.IsEnabled then begin
       if Gisun.IsEnableTypeAkt(FTypeObj,IsAktVosstan) then begin
         s:='';
       end;
     end;
  }
  {$ENDIF}
  if FCheckPol and (s<>'') then begin
    if (sField='NAME') or (sField='OTCH') then begin
      fld:=ed.Field.DataSet.FindField('POL');
      if fld<>nil then begin
        if sField='NAME' then sName:=s else sName:=ed.Field.DataSet.FieldByName('NAME').AsString;
        if sField='OTCH' then sOtch:=s else sOtch:=ed.Field.DataSet.FieldByName('OTCH').AsString;
        s:=PolFrom(sName,sOtch);
        if s<>'' then fld.AsString:=s;
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------------------------------
procedure TfmSimpleD.GridFIOUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  s : String;
  Pol:TPol;
  fld:TField;
  c:TColumnEh;
begin
  if FRun then exit;  // !!!
  UseText:=true;
  c := TColumnEh(Sender);
  s := Trim(Text);
  if FCheckRegistr then begin  // контролировать регистр букв
    if (Pos('-',s)=0) and (Pos(' ',s)=0) and (Pos(',',s)=0) then begin
      s := ANSIUpperCase(Copy(s,1,1))+ANSILowerCase(Copy(s,2,Length(s)-1));
      Text := s;
    end;
    if (UpperCase(c.FieldName)='NAME') and (s<>'') then begin
      fld:=c.Field.DataSet.FindField('POL');
      if fld<>nil then begin
        Pol:=tpNone;
        dmBase.CheckNameBel(Pol,s,'');
        if Pol<>tpNone then begin
          EditDataSet(c.Field.DataSet);
          if Pol=tpM
            then fld.AsString:='М'
            else fld.AsString:='Ж';
        end;
      end;
    end;
  end;
end;
//--------------------------------------------------------------------------------------
procedure TfmSimpleD.CityUpdate(Sender: TObject; var Handled: Boolean);
var
  ed : TDbEditEh;
  i,j : Integer;
  s,ss,s2 : String;
  arr,arr2 : TArrStrings;
begin        
  if FRun then exit;  // !!!
  ed := TDbEditEh(Sender);
  if Trim(ed.Text)=''
    then ed.Text:='';
  StrToArr(trim(ed.Text),arr,' ',true);
  ss:='';
  if FCheckRegistr then begin  // контролировать регистр букв
    for i:=0 to length(arr)-1 do begin
      s:=Trim(arr[i]);
      if i=0 then begin  // только первое слово
        if Pos('-',s)>0 then begin
          StrToArr(s,arr2,'-',true);
          for j:=0 to length(arr2)-1 do begin
            s2:=arr2[j];
            if (Pos(','+ANSILowerCase(s2)+',',FWordsLowerCase)=0) then begin
              ss:=ss+ANSIUpperCase(Copy(s2,1,1))+ANSILowerCase(Copy(s2,2,Length(s2)-1));
            end else begin
              ss:=ss+s2;
            end;
            if j<length(arr2)-1 then ss:=ss+'-' else ss:=ss+' ';
          end;
        end else begin
          if (Pos(','+ANSILowerCase(s)+',',FWordsLowerCase)=0) then begin
            ss:=ss+ANSIUpperCase(Copy(s,1,1))+ANSILowerCase(Copy(s,2,Length(s)-1))+' ';
          end else begin
            ss:=ss+s+' ';
          end;
        end;
      end else begin
        ss:=ss+s+' ';
      end;
    end;
  end;
  {$IFDEF GISUN}
  {
     if FDokZags and IsActiveGISUN and Gisun.IsEnabled then begin
       if Gisun.IsEnableTypeAkt(FTypeObj,IsAktVosstan) then begin
         ss:='';
       end;
     end;
  }
  {$ENDIF}
  if ss<>'' then begin
    ed.Text := Trim(ss);
  end;
end;

function TfmSimpleD.IsAutoNumZAGS: Boolean;
begin
  Result := GlobalTask.ParamAsBoolean('AUTO_NUM_ZAGS');
end;

//----------------------------------------------------------------
function TfmSimpleD.CheckAddNomerAkt:Boolean;
{$IFNDEF LAIS}
var
  fld:TField;
  sPar:String;
  lFix:Boolean;
{$ENDIF}
begin    
  {$IFNDEF LAIS}
    {$IFDEF ZAH}
      Result:=GlobalTask.ParamAsBoolean('FIKS_AKT'+IntToStr(FTypeObj));
//      Result:=GlobalTask.ParamAsBoolean('WRITE_NEW_AKT');
    {$ELSE}
      Result:=false;
      if GlobalTask.ParamAsBoolean('WRITE_NEW_AKT') then begin
        sPar:='FIKS_AKT'+IntToStr(FTypeObj);
        lFix:=GlobalTask.ParamAsBoolean(sPar);
        fld:=Dokument.FindField('Vosstan');
        if fld=nil then begin
          Result:=lFix;
        end else begin
          Result:=lFix and not fld.AsBoolean;
        end;
      end;
    {$ENDIF}
  {$ELSE}
    Result:=false;
  {$ENDIF}
end;
//----------------------------------------------------------------
function TfmSimpleD.CheckAddSvid:Boolean;
{$IFDEF ZAGS}
var
//  fld:TField;
  sPar:String;
//  lFix:Boolean;
{$ENDIF}
begin
  {$IFDEF ZAGS}
    Result:=false;
    if GlobalTask.ParamAsBoolean('WRITE_NEW_AKT') then begin
      sPar:='FIKS_SVID'+IntToStr(FTypeObj);
      Result:=GlobalTask.ParamAsBoolean(sPar);
    end;
  {$ELSE}
    Result:=false;
  {$ENDIF}
end;

//----------------------------------------------------------------
function TfmSimpleD.LockAddDocument(nTypeObj:Integer):Boolean;
var
  lOpenMessage,lMessage:Boolean;
begin
  Result:=true;
  lMessage:=false;
  if CheckAddNomerAkt then begin
    if not dmBase.LockTypeObj.Locate('TYPEOBJ', nTypeObj, []) then begin
      dmBase.LockTypeObj.Append;
      dmBase.LockTypeObj.FieldByName('TYPEOBJ').AsInteger:=nTypeObj;
      dmBase.LockTypeObj.Post;
    end;
    Result:=false;
    lOpenMessage:=false;
    while not Result do begin
      if lOpenMessage and not lMessage then begin
        OpenMessageEx('Другой пользователь создает запись ... ','Подождите пожалуйста',10,'  Прервать  ');
        lMessage:=true;
      end;
      try
        dmBase.LockTypeObj.Edit;                                         // запись блокируется
        Result:=true;
      except
        lOpenMessage:=true;
      end;
      Application.ProcessMessages;
      if lMessage and (GetResultMessage=0) then begin
        break;
      end;
    end;
    CloseMessage;
  end;
end;
//----------------------------------------------------------------
procedure TfmSimpleD.UnLockAddDocument(nTypeObj:Integer);
begin
  if dmBase.LockTypeObj.State=dsEdit then begin
    dmBase.LockTypeObj.Cancel;
  end;
end;
//----------------------------------------------------------------
function TfmSimpleD.LockOperation(nTypeOper:Integer; strOper:String):Boolean;
var
  lOpenMessage,lMessage:Boolean;
begin
  if strOper='' then strOper:='выполняет данную операцию';
  lMessage:=false;
//  Result:=true;
  if not dmBase.LockTypeObj.Locate('TYPEOBJ', nTypeOper, []) then begin
    dmBase.LockTypeObj.Append;
    dmBase.LockTypeObj.FieldByName('TYPEOBJ').AsInteger:=nTypeOper;
    dmBase.LockTypeObj.Post;
  end;
  Result:=false;
  lOpenMessage:=false;
  while not Result do begin
    if lOpenMessage and not lMessage then begin
      OpenMessageEx('Другой пользователь '+strOper+' ... ','Подождите пожалуйста',10,'  Прервать  ');
      lMessage:=true;
    end;
    try
      dmBase.LockTypeObj.Edit;                                         // запись блокируется
      Result:=true;
    except
      lOpenMessage:=true;
    end;
    Application.ProcessMessages;
    if lMessage and (GetResultMessage=0) then begin
      break;
    end;
  end;
  CloseMessage;
end;

//----------------------------------------------------------------
procedure TfmSimpleD.UnLockOperation(nTypeOper:Integer);
begin
  if dmBase.LockTypeObj.State=dsEdit then begin
    dmBase.LockTypeObj.Cancel;
  end;
end;
//---------------------------------------------------------------------------------
//      <<<<<   SetNewNomerDok   >>>>>
//---------------------------------------------------------------------------------

{$IFNDEF LAIS}
//   ДЛЯ ЗАГС, ЖКХ   (для захоронений см. fAktZ.pas)
function TfmSimpleD.SetNewNomerDok(lSetDate:Boolean):Integer;
var
  fld : TField;
  s,ss,sSvidSeria,sSvidNomer : String;
  cur : TCursor;
  lFind,lLock:Boolean;
  nYear,n,nNomer,nOrgan:Integer;
  fld2, fldD,fldDZ : TField;
  dDateZ:TDateTime;
  fldZags : TField;
  fldV    : TField;              
  nIDZAGS,nAddNomer:Integer;
begin           
  Result:=0;    
  FCheckNewNomerAkt:=false;
  nAddNomer:=-1;                      
  fldDZ:=nil;      
//  fld2:=nil;
  if FOnlySvid then begin
    if (FMainTable<>nil) and GlobalTask.ParamasBoolean('WRITE_ONLYSVID') then begin
      fld := Dokument.FindField('NOMER');
      //-------------------------------------------------
      if (fld<>nil) and CheckAddNomerAkt and CheckAddSvid then begin
        lLock:=LockAddDocument(FTypeObj);
        //-------------------------------------------------
        if not lLock then begin
          FError:=1;
          exit;
        end;
        dDateZ:=dmBase.GetCurDate;
        nOrgan:=0;
        if CheckAddSvid                              
          then AddSvid(true);    // запросим еще раз номера свидетельств
        sSvidNomer:=Dokument.FieldByName('SVID_NOMER').AsString;
        sSvidSeria:=Dokument.FieldByName('SVID_SERIA').AsString;
        nNomer:=0;
        n:=CreateNewAkt(true, Self, FTypeObj, nNomer, dDateZ, nOrgan,sSvidSeria,sSvidNomer,nAddNomer);
        if n>0 then begin
          EditDataSet(Dokument);
          fld.AsInteger:=nNomer;
          Dokument.FindField('DATEZ').AsDateTime:=dDateZ;
          Dokument.FindField('ID_ZAGS').AsInteger:=nOrgan;
          Dokument.FindField('ID').AsInteger:=n;
          Result:=n;  /// !!!
        end else begin
          FError:=2;
        end;
        //-------------------------------------------------
        UnLockAddDocument(FTypeObj);
        //-------------------------------------------------
      end;
    end;
  end else begin
    if FAutoNum and (FMainTable<>nil) then begin
      //-------------------------------------------------
      lLock:=LockAddDocument(FTypeObj);
      //-------------------------------------------------
      if not lLock then begin
        FError:=1;        
        exit;
      end;
      nIDZAGS:=GlobalTask.ParamAsInteger('ID');
      fld  := Dokument.FindField('NOMER');
      if GlobalTask.ParamAsBoolean('ADD_GL_NOMER')
        then fld2:=Dokument.FindField('NOMER2')
        else fld2:=nil;
      if fld <> nil then begin
        fldDZ   := Dokument.FindField('DATEZ');     // поле дата записи в новом документе
        fldD    := FMainTable.FindField('DATEZ');   // поле дата записи в таблице
        fldZags := FMainTable.FindField('ID_ZAGS');

        dDateZ:=0;
        FMainTable.IndexName := 'KEY_VIEW';
        FMainTable.First;
        nYear:=YearOf(dmBase.GetCurDate);        // текущий год выписки     !!! ИЗМЕНИТЬ !!!

        cur := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        lFind:=true;

        if (FBigTable=1) then begin   // GurnalRegist   FMainTable.IndexName='TYPEOBJ;GOD;Descend(NOMER)'
          FMainTable.SetRange([FTypeObj,nYear],[FTypeObj,nYear]);
//          if IsAllDigit(FMainTable.FieldByName('NOMER').AsString) then begin
          n:=FMainTable.FieldByName('NOMER').AsInteger;
          FMainTable.CancelRange;
          fld.AsInteger:=n+1;
//          end;
          {   ? поле номер символное ?
        end else if (FBigTable=2) then begin   // AddDokZags   FMainTable.IndexName='TYPEOBJ;GOD;Descend(NOMER)'
          FMainTable.SetRange([FTypeObj,nYear],[FTypeObj,nYear]);
          n:=FMainTable.FieldByName('NOMER').AsInteger;
          FMainTable.CancelRange;
          fld.AsInteger:=n+1;   }
        end else begin  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          if (FTypeObj=dmBase.TypeObj_ZBrak) or (FTypeObj=dmBase.TypeObj_ZRogd) or (FTypeObj=dmBase.TypeObj_ZSmert) then begin
            fldV := FMainTable.FindField('VOSSTAN');
            while (fldZags.AsInteger<>nIDZAGS) or (IsAktVosstan<>fldV.AsBoolean) do begin
              FMainTable.Next;
              if FMainTable.Eof or (YearOf(fldD.AsDateTime)<>nYear) then begin
                lFind:=false;
                break;
              end;
            end;
          end else begin
            while fldZags.AsInteger<>nIDZAGS do begin
              FMainTable.Next;
              if FMainTable.Eof or (YearOf(fldD.AsDateTime)<>nYear)  then begin
                lFind:=false;
                break;
              end;
            end;
          end;
          if lFind and not FMainTable.Eof and (fldZags.AsInteger=nIDZAGS) then begin
            s := FMainTable.FieldByName('NOMER').AsString;
            if fld2<>nil
              then ss:=FMainTable.FieldByName('NOMER2').AsString;
            if fldD<>nil
              then dDateZ:=fldD.AsDateTime;
            if s <> '' then begin
              try
                fld.AsInteger:=StrToInt(s)+1;
                if fld2<>nil
                  then fld2.AsInteger:=StrToInt(ss)+1;;
                if (dDateZ>0) and lSetDATE
                  then fldDZ.AsDateTime:=dDateZ;
              except
              end;
            end;
          end;
        end;   // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        Screen.Cursor := cur;
      end;

      //-------------------------------------------------
      if CheckAddNomerAkt then begin
        nNomer:=fld.AsInteger;
        if fld2<>nil
          then nAddNomer:=fld2.AsInteger;
        dDateZ:=fldDZ.AsDateTime;
        if dDateZ<dmBase.GetCurDate
          then dDateZ:=dmBase.GetCurDate;
        nOrgan:=0;
//        if (FTypeObj=_TypeObj_ZRogd) or (FTypeObj=_TypeObj_ZSmert) then begin
        if CheckAddSvid then begin
          AddSvid(true);    // запросим еще раз номера свидетельств
          sSvidNomer:=Dokument.FieldByName('SVID_NOMER').AsString;
          sSvidSeria:=Dokument.FieldByName('SVID_SERIA').AsString;
        end else begin
          sSvidNomer:='';
          sSvidSeria:='';
        end;
        n:=CreateNewAkt(false, Self, FTypeObj, nNomer, dDateZ, nOrgan,sSvidSeria,sSvidNomer,nAddNomer);
        if n>0 then begin
          fld.AsInteger:=nNomer;
          if (fld2<>nil) and (nAddNomer>0) then begin
            fld2.AsInteger:=nAddNomer;
          end;
          fldDZ.AsDateTime:=dDateZ;
          Dokument.FindField('ID_ZAGS').AsInteger:=nOrgan;
          Dokument.FindField('ID').AsInteger:=n;
          FCheckNewNomerAkt:=true;
          GlobalTask.LogFile.WriteToLogFile('Создание пустой з/а '+GlobalTask.CurrentOpisEdit.GetListOpisA('KEY_TYPEZAGS_FULL').Naim(FTypeObj,false)+
                                            ' №'+IntToStr(nNomer)+' от '+FormatDateTime('dd.mm.yyyy',dDateZ)+ '('+dmBase.UserID+')');
        end else begin
          FError:=2;
        end;
      end else begin
        if not fldDZ.IsNull and (fldDZ.AsDateTime<dmBase.GetCurDate)
          then fldDZ.AsDateTime:=dmBase.GetCurDate
      end;
      //-------------------------------------------------
      UnLockAddDocument(FTypeObj);
      //-------------------------------------------------
    end;
  end;
end;

{$ELSE}
//     ДЛЯ ЛАИС      (для захоронений см. fAktZ.pas)
//---------------------------------------------------------------------------------
function TfmSimpleD.SetNewNomerDok(lSetDate:Boolean):Integer;
var
  fld,fld2 : TField;
  s : String;
  cur : TCursor;
  lFind:Boolean;
  nYear,n:Integer;
  fldD,fldDZ : TField;
  dDateZ:TDateTime;
  fldGor : TField;                                  
begin                             
  Result:=0;             
  if FAutoNum and (FMainTable<>nil) then begin
    fld := Dokument.FindField('NOMER');
    if GlobalTask.ParamAsBoolean('ADD_GL_NOMER')
      then fld2:= Dokument.FindField('NOMER2')
      else fld2:=nil;
                                     
    if fld <> nil then begin
      lFind:=true;
      fldDZ := Dokument.FindField('DATEZ');
      dDateZ:=0;
      FMainTable.IndexName := 'KEY_VIEW';        //  !!! Изменить "Descend(DATEZ);Descend(NOMER)" на "Descend(Year(DATEZ));Descend(NOMER)"
      FMainTable.First;
      nYear:=YearOf(dmBase.GetCurDate);       
      fldD := FMainTable.FindField('DATEZ');
      // раздельный учет для города и села
      if FDokZAGS and GlobalTask.ParamAsBoolean('PLUS_GOROD') then begin
        cur := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        fldGor := FMainTable.FindField('IS_GOROD');
        while fldGor.AsBoolean<>N_F_cbGorod.Checked do begin
          FMainTable.Next;
          if FMainTable.Eof or (YearOf(fldD.AsDateTime)<>nYear)  then begin
            lFind:=false;
            break;
          end;
        end;
        if lFind and not FMainTable.Eof and (fldGor.AsBoolean=N_F_cbGorod.Checked) then begin
          s := FMainTable.FieldByName('NOMER').AsString;
          if fldD<>nil then dDateZ:=fldD.AsDateTime;
          if s <> '' then begin
            try
              fld.AsInteger := StrToInt(s)+1;
              if fldDZ<>nil then
                if (dDateZ>0) and lSetDATE then fldDZ.AsDateTime:=dDateZ;
            except
            end;
          end;
        end;
        Screen.Cursor := cur;
      end else begin
        s := FMainTable.FieldByName('NOMER').AsString;
        if fldD<>nil then dDateZ:=fldD.AsDateTime;
        if (YearOf(fldD.AsDateTime)<>nYear)  then begin
          s:='';
        end;
        if s <> '' then begin
          try
            if fld2<>nil then begin
              n:=FMainTable.FieldByName('NOMER2').AsInteger;
              fld2.AsInteger := n+1;
            end;
            fld.AsInteger := StrToInt(s)+1;
            if fldDZ<>nil then
              if (dDateZ>0) and lSetDATE then fldDZ.AsDateTime:=dDateZ;
          except
          end;
        end;
      end;
    end;

  end;
end;

{$ENDIF}

const
  NepKod   = 'PR_NEP';
  OsnKod   = 'PR_OSN';
  MestKod  = 'PR_MEST';
  NepName  = 'PR_NEP_NAME';
  OsnName  = 'PR_OSN_NAME';
  MestName = 'PR_MEST_NAME';
  NepName_B  = 'PR_NEP_NAME_B';
  OsnName_B  = 'PR_OSN_NAME_B';
  MestName_B = 'PR_MEST_NAME_B';

//--------------------------------------------------------------------------------
function TfmSimpleD.GetPrSmert(lKod : Boolean; strParam:String) : String;
var
  fld : TField;
  Nep, Osn, s,sAdd : String;
  kNep, kOsn, strLang : String;
  //-----------------------------------
  function GetKod(ss : String) : String;
  begin
    if lKod
      then result := Trim(Dokument.FieldByName(ss).AsString)
      else result:='';
  end;
  //-----------------------------------
begin
  Result := '';
  fld := Dokument.FindField(NepName);
  strLang:=CheckLangParam(strParam);
  if fld<>nil then begin     

    if Pos('B',strLang)>0
      then sAdd:='_B' else sAdd:='';

    Nep  := Dokument.FieldByName(NepName+sAdd).AsString;
    kNep := GetKod(NepKod);
    if (kNep<>'') or (Nep<>'') then begin
      Result := Trim(kNep + ' ' + Nep);
    end;

    Osn  := Dokument.FieldByName(OsnName+sAdd).AsString;
    kOsn := GetKod(OsnKod);
    if (kOsn<>'') or (Osn<>'') then begin
      s := Trim(kOsn + ' ' + Osn);
      if Result<>'' then Result := Result + ', ' + s
                    else Result := s;
    end;
    {
    Mest  := Dokument.FieldByName(MestName+sAdd).AsString;
    kMest := GetKod(MestKod);
    if (kMest<>'') or (Mest<>'') then begin
      s := Trim(kMest + ' ' + Mest);
      if Result<>'' then Result := Result + ', ' + s
                    else Result := s;
    end;
    }
  end;
end;
//--------------------------------------------------------------------------------
function TfmSimpleD.GetHistPrSmert(strParam:String) : String;
var
  fld : TField;
  HistNep, HistOsn, s,sAdd,strLang : String;
  kHistNep, kHistOsn : String;
  function GetHist(ss : String) : String;
  begin
    Result := '';
    if HistZAGS.RecordCount > 0 then begin
      HistZAGS.Filter   := 'FIELDNAME='+QStr(ss);
      HistZAGS.Filtered := true;
      HistZAGS.First;
      if not HistZAGS.Eof then Result := HISTZAGSStringValue.AsString;
      HistZAGS.Filtered:=false;
      HistZAGS.Filter:='';
    end;
  end;
begin
  Result := '';
  if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
    strLang:=CheckLangParam(strParam);

    if Pos('B',strLang)>0
      then sAdd:='_B' else sAdd:='';

    fld := Dokument.FindField(NepName+sAdd);
    if fld<>nil then begin

      kHistNep  := getHist(NepKod);
      HistNep   := getHist(NepName+sAdd);
      if (kHistNep<>'') or (HistNep<>'') then begin
        Result := Trim(kHistNep + ' ' + HistNep);
      end;

      kHistOsn  := getHist(OsnKod);
      HistOsn   := getHist(OsnName+sAdd);
      if (kHistOsn<>'') or (HistOsn<>'') then begin
        s := Trim(kHistOsn + ' ' + HistOsn);
        if Result<>'' then Result := Result + ', ' + s
                      else Result := s;
      end;

      {
      kHistMest := getHist(MestKod);
      HistMest  := getHist(MestName);
      if (kHistMest<>'') or (HistMest<>'') then begin
        s := Trim(kHistMest + ' ' + HistMest);
        if Result<>'' then Result := Result + ', ' + s
                      else Result := s;
      end;
      }
    end;
  end;
end;

//--------------------------------------------------------------------------------
procedure TfmSimpleD.ReadSvidPovtor(nTypeObj, nID: Integer);
begin
{$IFDEF ZAGS}
  if not SvidPovtor.Active then SvidPovtor.Active:=true;
  dmBase.SetDateFormat(SvidPovtor);
  SvidPovtorSVID_NOMER.EditMask := StringOfChar('9',SVID_LEN)+';0;_';
  SvidPovtor.EmptyTable;
  if nID > 0 then begin
    dmBase.SvidPovtor.IndexName:='PR_KEY';
    dmBase.SvidPovtor.SetRange([nTypeObj,nID], [nTypeObj,nID]);
    try
      while not dmBase.SvidPovtor.Eof do begin
        SvidPovtor.Append;
        WriteDateField( SvidPovtorSVID_DATE,
                dmBase.SvidPovtor.FieldByName('SVID_DATE'));

        SvidPovtorSVID_SERIA.AsString := dmBase.SvidPovtor.FieldByName('SVID_SERIA').AsString;
        SvidPovtorSVID_NOMER.AsString := dmBase.SvidPovtor.FieldByName('SVID_NOMER').AsString;
        if dmBase.SvidPovtor.FieldByName('FIRST').IsNull
          then SvidPovtorFIRST.AsBoolean:=false
          else SvidPovtorFIRST.AsBoolean:= dmBase.SvidPovtor.FieldByName('FIRST').AsBoolean;
        SvidPovtorWHO_SVID.AsString := dmBase.SvidPovtor.FieldByName('WHO_SVID').AsString;
        if dmBase.SvidPovtor.FieldByName('GISRN').IsNull
          then SvidPovtorGISRN.AsInteger:=0
          else SvidPovtorGISRN.AsInteger:=dmBase.SvidPovtor.FieldByName('GISRN').AsInteger;
        SvidPovtor.Post;
        dmBase.SvidPovtor.Next;
      end;
    finally
      dmBase.SvidPovtor.CancelRange;
    end;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------------------------
procedure TfmSimpleD.WriteForAllDok_BeforePost;
begin
  if FOnlySvid then begin
    if (FTypeObj=dmBase.TypeObj_ZRast) then begin

//    end else if (FTypeObj=dmBase.TypeObj_ZUstOtc) then begin

    end else  begin
//      EditDataSet(FMainTable);
//      FMainTable.FieldByName('DATESV').AsString:='';
//      FMainTable.FieldByName('SVID_NOMER').AsString:='';
//      FMainTable.FieldByName('SVID_SERIA').AsString:='';
    end;
  end;
end;

//------------------------------------------------------------------------------------------------
procedure TfmSimpleD.WriteSvidPovtor(nTypeObj, nID: Integer);
//var
//  lOk:Boolean;
//  sSeria,sNomer:String;
//  dDate:TDateTime;
begin
{$IFDEF ADD_ZAGS}
  if FOnlySvid then begin   // открыта форма только для выдачи свидетельства
    if not Dokument.FieldByName('DATESV').IsNull and (Dokument.FieldByName('SVID_NOMER').AsString<>'') then begin
      try
        if FBOOKMARK_SVIDPOVTOR='' then begin   // если не фиксировали выданное сидетельство
    //  м.б. лучше использовать:   SVID_KEY      SVID_TYPE;AKT_ID;SVID_SERIA;SVID_NOMER
          dmBase.SvidPovtor.IndexName:='PR_KEY';  //   'SVID_TYPE;AKT_ID;SVID_DATE;SVID_NOMER'
          if dmBase.SvidPovtor.FindKey([nTypeObj,nID,Dokument.FieldByName('DATESV').AsDateTime,Dokument.FieldByName('SVID_NOMER').AsString]) then begin
            dmBase.SvidPovtor.Edit;
          end else begin
            dmBase.SvidPovtor.Append;
            dmBase.SvidPovtor.FieldByName('SVID_TYPE').AsInteger := nTypeObj;
            dmBase.SvidPovtor.FieldByName('AKT_ID').AsInteger := nID;
          end;
        end else begin
          dmBase.SvidPovtor.Bookmark:=FBOOKMARK_SVIDPOVTOR;
          dmBase.SvidPovtor.Edit;
          dmBase.SvidPovtor.FieldByName('AKT_ID').AsInteger := nID;     // если з/а перепрочитали
          // svid_type д.б. уже проставлен
        end;
        WriteDateField( dmBase.SvidPovtor.FieldByName('SVID_DATE'), Dokument.FieldByName('DATESV'));
        dmBase.SvidPovtor.FieldByName('SVID_NOMER').AsString := Dokument.FieldByName('SVID_NOMER').AsString;
        dmBase.SvidPovtor.FieldByName('SVID_SERIA').AsString := Dokument.FieldByName('SVID_SERIA').AsString;
        dmBase.SvidPovtor.FieldByName('FIRST').AsBoolean:=false;
        if DokumentSVID_GISRN.AsBoolean
          then dmBase.SvidPovtor.FieldByName('GISRN').AsInteger:=1  // !!!
          else dmBase.SvidPovtor.FieldByName('GISRN').AsInteger:=0;  // !!!
        if TypeObj=_TypeObj_ZRast then begin
          dmBase.SvidPovtor.FieldByName('WHO_SVID').AsString:=Dokument.FieldByName('Who_Svid').AsString;
        end;
        dmBase.SvidPovtor.Post;              
      except
        on E: Exception do begin
          PutError('Ошибка записи в таблицу повторных свидетельств:'+chr(13)+E.Message,Self);
        end;
      end;
    end;

  // SVID_TYPE;AKT_ID;SVID_DATE;SVID_NOMER
    {  -------------------------------------------------------
       !!! ДОПИСАТЬ НЕ ТОЛЬКО ДЛЯ ПОВТОРНОГО СВИДЕТЕЛЬСТВА !!!
       -------------------------------------------------------
    dmBase.SvidPovtor.IndexName:='PR_KEY';
    dmBase.SvidPovtor.SetRange([nTypeObj,nID], [nTypeObj,nID]);
    lOk:=false;
    sSeria:=Dokument.FieldByName('SVID_SERIA').AsString;
    sNomer:=Dokument.FieldByName('SVID_SERIA').AsString;
    try
      dDate:=Dokument.FieldByName('DATESV').AsDateTime;
    except
      dDate:=0;
    end;
    while not dmBase.SvidPovtor.Eof do begin
      if (sSeria=dmBase.SvidPovtor.FieldByName('SVID_SERIA').AsString) and
         (sNomer=dmBase.SvidPovtor.FieldByName('SVID_NOMER').AsString) and
         (dDate=dmBase.SvidPovtor.FieldByName('SVID_DATE').AsDateTime) then begin
        lOk:=true;
      end;
      dmBase.SvidPovtor.Next;
    end;
    dmBase.SvidPovtor.CancelRange;
    SvidPovtor.First;
    if not lOk then begin
      dmBase.SvidPovtor.Append;
      dmBase.SvidPovtor.FieldByName('SVID_TYPE').AsInteger := nTypeObj;
      dmBase.SvidPovtor.FieldByName('AKT_ID').AsInteger := nID;
      WriteDateField( dmBase.SvidPovtor.FieldByName('SVID_DATE'), Dokument.FieldByName('DATESV') );
      dmBase.SvidPovtor.FieldByName('SVID_SERIA').AsString := Dokument.FieldByName('SVID_SERIA').AsString;
      dmBase.SvidPovtor.FieldByName('SVID_NOMER').AsString := Dokument.FieldByName('SVID_NOMER').AsString;
      dmBase.SvidPovtor.Post;
    end;
    }
  end else begin
    if not SvidPovtor.Active then exit;
    if nID > 0 then begin
      SvidPovtor.CheckBrowseMode;
      dmBase.SvidPovtor.IndexName:='PR_KEY';
      dmBase.SvidPovtor.SetRange([nTypeObj,nID], [nTypeObj,nID]);
      while not dmBase.SvidPovtor.Eof do begin
        dmBase.SvidPovtor.Delete;
      end;
      dmBase.SvidPovtor.CancelRange;
      SvidPovtor.First;
      while not SvidPovtor.Eof do begin
        if SvidPovtorSVID_NOMER.AsString<>'' then begin
          dmBase.SvidPovtor.Append;
          dmBase.SvidPovtor.FieldByName('SVID_TYPE').AsInteger := nTypeObj;
          dmBase.SvidPovtor.FieldByName('AKT_ID').AsInteger := nID;
          WriteDateField( dmBase.SvidPovtor.FieldByName('SVID_DATE'), SvidPovtorSVID_DATE);
          dmBase.SvidPovtor.FieldByName('SVID_SERIA').AsString := SvidPovtorSVID_SERIA.AsString;
          dmBase.SvidPovtor.FieldByName('SVID_NOMER').AsString := SvidPovtorSVID_NOMER.AsString;
          if SvidPovtorFIRST.IsNull
             then dmBase.SvidPovtor.FieldByName('FIRST').AsBoolean:=false
             else dmBase.SvidPovtor.FieldByName('FIRST').AsBoolean:=SvidPovtorFIRST.AsBoolean;
          dmBase.SvidPovtor.FieldByName('WHO_SVID').AsString:=SvidPovtorWho_Svid.AsString;
          dmBase.SvidPovtor.FieldByName('GISRN').AsInteger:=SvidPovtorGISRN.AsInteger;
          dmBase.SvidPovtor.Post;
        end;
        SvidPovtor.Next;
      end;
    end;
  end;
{$ENDIF}
end;
//-------------------------------------------------------------------------
function TfmSimpleD.ReadDok(nID: Integer): Boolean;
begin
  Result := true;
end;
//-------------------------------------------------------------------------
procedure TfmSimpleD.CheckEnabledNameOrgan(lNew : Boolean; lChoiceZAGS:Boolean);
var
  i:Integer;
begin
  if GlobalTask.ParamAsBoolean('NAME_ORGAN_ZAGS') then begin
    if Dokument.FindField('ID_ZAGS')<>nil then begin
      if Dokument.FieldByName('ID_ZAGS').IsNull or lNew or
         (DokumentNAME_ZAGS.AsString<>'') then begin
        TBToolBarOrgan.Visible := true;
      end else begin
        if dmBase.SprNames.Locate('ID',Dokument.FieldByName('ID_ZAGS').Value,[]) then begin
          TBToolBarOrgan.Visible := false;
        end else begin
          TBToolBarOrgan.Visible := true;
        end;
      end;
    end else begin
      TBToolBarOrgan.Visible := false;
    end;
  end else begin
    TBToolBarOrgan.Visible := false;
  end;

  {$IFDEF ZAGS}
    if FCheckNewNomerAkt then begin
      TBItemZAGS.Visible:=false;
      TBItemZAGS.Enabled:=false;
      for i:=0 to ComponentCount-1 do begin
        if (Components[i] is TDbEditEh) then begin
          if TDbEditEh(Components[i]).DataField='NOMER' then begin
            TDbEditEh(Components[i]).ReadOnly:=true;
            TDbEditEh(Components[i]).Color:=GetDisableColor;
          end;
        end else if (Components[i] is TDBDateTimeEditEh) then begin
          if TDBDateTimeEditEh(Components[i]).DataField='DATEZ' then begin
            TDBDateTimeEditEh(Components[i]).ReadOnly:=true;
            TDBDateTimeEditEh(Components[i]).Color:=GetDisableColor;
          end;
        end;
      end;
    end else begin
      TBItemZAGS.Visible:=lChoiceZAGS;
      TBItemZAGS.Enabled:=lChoiceZAGS;
    end;
  {$ELSE}
    TBItemZAGS.Visible:=false;
    TBItemZAGS.Enabled:=false;
  {$ENDIF}

  {$IFDEF ZAGS}
     N_F_cbGorod.Visible:=false;
  {$ELSE}
     if FDokZAGS and GlobalTask.ParamAsBoolean('PLUS_GOROD') then begin
       lbOrgan.Visible:=false;
       edZAGS.Visible:=false;
       N_F_cbGorod.Visible:=true;
       TBToolBarOrgan.Visible := true;
     end else begin
       N_F_cbGorod.Visible:=false;
       TBToolBarOrgan.Visible := false;
     end;
  {$ENDIF}
end;

procedure TfmSimpleD.edZAGSCheckDrawRequiredState(Sender: TObject; var DrawState: Boolean);
begin
  if cbBel<>nil then begin
    DrawState := cbBel.Checked;
  end else begin
    DrawState := false;
  end;
end;

//--------------------------------------------------------
procedure TfmSimpleD.CheckHistory(lClear:Boolean);
var
  i:Integer;
//  p : TPersistent;
begin
  if HistZAGS.Active then begin
    if lClear then begin
      for i:=0 to ComponentCount-1 do begin
        if Components[i] is TCustomDbEditEh then begin
          if GetColorProp(Components[i])=COLOR_HIST then begin
            SetPropertyObject( Components[i], 'Color', COLOR_NORM);
          end;
        end;
      end;
    end else begin
      HistZAGS.First;
      while not HistZAGS.Eof do begin
        for i:=0 to ComponentCount-1 do begin

          if Components[i] is TCustomDbEditEh then begin
            // находим самый первый компонент с полем занесенным в историю
            // существует потенциальная опасность если есть несколько контролов к которым подключено одно и тоже поле
            //  например: fmZapisRogd  (edON_NATION, edON_NATION_SV,edON_NATION_SV_B)=ON_NATION
            if UpperCase(TCustomDbEditEh(Components[i]).Field.FieldName) = HistZAGSFieldName.AsString then begin
  //            p := Components[i];

              SetPropertyObject( Components[i], 'Color', COLOR_HIST);
              break;
            end;
          end;
        end;
        HistZAGS.Next;
      end;
      HistZAGS.First;
    end;
  end;

end;

//--------------------------------------------------------
procedure TfmSimpleD.ReadHistory( nID : Integer; nTypeObj : Integer);
var
  i : Integer;
  strFieldName:String; //, strHint : String;
  p : TPersistent;
  fld : TField;
begin
  if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
    p := nil;                 
    if not HistZAGS.Active then HistZAGS.Active:=true;
    HistZAGS.EmptyTable;
    dmBase.tbHistoryZAGS.IndexName := 'PR_KEY';
    dmBase.tbHistoryZAGS.SetRange([nTypeObj,nID],[nTypeObj,nID]);
    try
      strFieldName := '###';
//      strHint      := '';
      while not dmBase.tbHistoryZAGS.Eof do begin
        HistZAGS.Append;
        HistZAGSFieldName.AsString   := UpperCase(dmBase.tbHistoryZAGS.FieldByName('FIELDNAME').AsString);
        if strFieldName<>HistZAGSFieldName.AsString then begin
//          if (p<>nil) and (strHint<>'') then begin
//            SetPropertyObject( p, 'Hint', Copy(strHint,3,200) );
//          end;
//          strHint := '';
          strFieldName:=HistZAGSFieldName.AsString;
          for i:=0 to ComponentCount-1 do begin
            if Components[i] is TCustomDbEditEh then begin
              // находим самый первый компонент с полем занесенным в историю
              // существует потенциальная опасность если есть несколько контролов к которым подключено одно и тоже поле
              //  например: fmZapisRogd  (edON_NATION, edON_NATION_SV,edON_NATION_SV_B)=ON_NATION
              if UpperCase(TCustomDbEditEh(Components[i]).Field.FieldName) = HistZAGSFieldName.AsString then begin
                p := Components[i];
                SetPropertyObject( Components[i], 'Color', COLOR_HIST);
                break;
              end;
            end;
          end;
        end;
        fld := Dokument.FindField(strFieldName);
//        strHint := strHint + ', '+ dmBase.tbHistoryZAGS.FieldByName('VALUE').AsString;
        HistZAGSValue.AsString:=dmBase.tbHistoryZAGS.FieldByName('VALUE').AsString;
        HistZAGSTypeDate.AsInteger:=dmBase.tbHistoryZAGS.FieldByName('TYPEDATE').AsInteger;
        HistZAGSDatePropis.AsInteger:=dmBase.tbHistoryZAGS.FieldByName('DATEPROPIS').AsInteger;
        HistZAGSInfo.AsString:=dmBase.tbHistoryZAGS.FieldByName('INFO').AsString;
        if HistZAGSDatePropis.AsInteger<0 then HistZAGSDatePropis.AsInteger:=0;
        HistZAGSStringValue.AsString:=HistZAGSValue.AsString;
        if fld.DataType=ftDate then begin
          if HistZAGSTypeDate.AsInteger<>999 then begin   // !!!!!!!!!!!!
            HistZAGSStringValue.AsString:=DatePropisEx(STOD( HistZAGSValue.AsString, tdAds),HistZAGSDatePropis.AsInteger,HistZAGSTypeDate.AsInteger);
          end;
        end else if fld.DataType=ftTime then begin
          HistZAGSStringValue.AsString:=FormatDateTime('hh час nn мин', STOT( HistZAGSValue.AsString ));
        end else if (p<>nil) and (p is TDBLookupComboboxEh ) then begin
          if TDBLookupComboboxEh(p).ListSource.DataSet.Locate(TDBLookupComboboxEh(p).KeyField,
                   HistZAGSValue.AsString, [])
            then HistZAGSStringValue.AsString:=TDBLookupComboboxEh(p).ListSource.DataSet.FieldByName(TDBLookupComboboxEh(p).ListField).AsString;
        end else if (p<>nil) and (p is TDBComboBoxEh ) then begin
          i := TDBComboBoxEh(p).KeyItems.IndexOf(HistZAGSValue.AsString);
          if i > -1 then begin
            HistZAGSStringValue.AsString:=TDBComboBoxEh(p).Items.Strings[i];
          end;
        end;
        WriteDateField( HistZAGSDateIzm, dmBase.tbHistoryZAGS.FieldByName('DATEIZM'));
        HistZAGS.Post;
        dmBase.tbHistoryZAGS.Next;
      end;
//      if (p<>nil) and (strHint<>'') then begin
//        SetPropertyObject( p, 'Hint', Copy(strHint,3,200));
//      end;
    finally
      dmBase.tbHistoryZAGS.CancelRange;
    end;
  end;
end;
//-----------------------------------------------------------------------------------
procedure TfmSimpleD.WriteHistory( nID : Integer; nTypeObj : Integer);
begin
  if GlobalTask.ParamAsBoolean('HIST_ZAGS') and HistZAGS.Active then begin
    dmBase.tbHistoryZAGS.IndexName := 'PR_KEY';
    dmBase.tbHistoryZAGS.SetRange([nTypeObj,nID],[nTypeObj,nID]);
    while not dmBase.tbHistoryZAGS.Eof do dmBase.tbHistoryZAGS.Delete;
    dmBase.tbHistoryZAGS.CancelRange;
    HistZAGS.First;
    while not HistZAGS.Eof do begin
      dmBase.tbHistoryZAGS.Append;
      dmBase.tbHistoryZAGS.FieldByName('TYPEOBJ').AsInteger := nTypeObj;
      dmBase.tbHistoryZAGS.FieldByName('ID').AsInteger := nID;
      dmBase.tbHistoryZAGS.FieldByName('FIELDNAME').AsString := UpperCase(HistZAGSFieldName.AsString);
      dmBase.tbHistoryZAGS.FieldByName('VALUE').AsString := HistZAGSValue.AsString;

      dmBase.tbHistoryZAGS.FieldByName('TYPEDATE').AsINteger := HistZAGSTypeDate.AsInteger;
      dmBase.tbHistoryZAGS.FieldByName('DATEPROPIS').AsString := HistZAGSDatePropis.AsString;
      dmBase.tbHistoryZAGS.FieldByName('INFO').AsString := HistZAGSInfo.AsString;
      if HistZAGSDateIzm.IsNull then begin
        dmBase.tbHistoryZAGS.FieldByName('DATEIZM').AsDateTime := dmBase.getCurDate;
      end else begin
        WriteDateField( dmBase.tbHistoryZAGS.FieldByName('DATEIZM'),  HistZAGSDateIzm );
      end;
      WriteDateField( dmBase.tbHistoryZAGS.FieldByName('DATEZ'),  Dokument.FieldByName('DATEZ') );
      dmBase.tbHistoryZAGS.FieldByName('NOMER').AsString := Dokument.FieldByName('NOMER').AsString;
      dmBase.tbHistoryZAGS.Post;
      HistZAGS.Next;
    end;
    HistZAGS.First;
  end;
end;
//------------------------------------------------------------------------------------
function TfmSimpleD.EnableHistoryControl( ActControl : TWinControl) : Boolean;
begin
  Result:=true;
end;
//------------------------------------------------------------------------------------
function TfmSimpleD.EnableHistoryField(strFieldName: String): Boolean;
var
  s : String;
  i : Integer;
begin
  Result := false;
  s := FMainTable.TableName;
  i := Pos('.',s);
  if i=0 then s := FMainTable.TableName
         else s := Copy(FMainTable.TableName,1,i-1);
  fmMain.mtTablesFields.IndexFieldNames:='TableName;FieldName';
  if fmMain.mtTablesFields.FindKey([s,strFieldName]) and
     fmMain.mtTablesFieldsEnableH.AsBoolean=true then begin
    Result := true;
  end;
end;

//-------------------------------------------------------------
function TfmSimpleD.GetParam(sParam,sDefault: String): String;
begin
  Result:=sDefault;
  if (FPar<>nil) and (FPar.Count>0) then begin
    Result:=FPar.Values[sParam];
    if Result=''
      then Result:=sDefault;
  end;
end;

//-------------------------------------------------------------
procedure TfmSimpleD.AssignPar(slPar: TStringList);
begin
  FPar:=TStringList.Create;
  if (slPar<>nil) and Assigned(slPar) then begin
    if (slPar.Count>0) then begin
      FPar.Assign(slPar);
    end;
  end;
end;

//-------------------------------------------------------------
// исп-ся при открытии формы только для получения отчета
function TfmSimpleD.IsShowEdit: Boolean;
begin
  Result:=true;
  if (GetParam('RUN_REPORT','0')='1') then begin    // если открываем для получения отчета
    if (GetParam('EDIT_AFTER_REPORT','0')='1') then begin // открыть форму после отчета

    end else begin
      Result:=false;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------
function TfmSimpleD.RunReport: Integer;
var
  sNameReport,sType,sID,sKod:String;
  {$IFDEF USE_TEMPLATE}
  Template:TTemplate;
  {$ENDIF}
  i:Integer;
  v:Variant;
  lOk:Boolean;
begin
  Result:=0;
  sNameReport:=ANSIUpperCase(GetParam('NAME_REPORT',''));
  sType:=GetParam('TYPE_REPORT','DOC');
  if sType='FR' then begin
    GetNameReport;
    for i:=0 to CountReports-1 do begin
      if MySameText(ReportName(i),sNameReport) then begin
        sNameReport:=ANSIUpperCase(ReportFile(i));
      end;
    end;
  end;
  if sNameReport<>'' then begin
//    if (sType='FR') or (Right(sNameReport,4)='.FR3') or (Right(sNameReport,4)='.FRF') then begin
//      sType:='FR';
//    end else begin
//      sType:=GetParam('TYPE_REPORT','DOC');
//    end;
    sID:=GetParam('ID','');
    if sID<>'' then begin
      FMainTable.Locate('ID', sID, []);
    end;
    lOk:=true;
    sKod:=GetParam('KOD_REPORT','');
    if (sKod<>'') then begin
      v:=null;
      try
        FRun:=false;
        RunFuncScript('RunReport_'+sKod,[StrToInt(GetParam('ID_REPORT','')),GetParam('NAME_REPORT','')],v,FRun);
        if (v<>null) then begin
          lOk:=v;
        end;
      finally
        FRun:=false;
      end;
    end;
    if lOk then begin
      if sType='DOC' then begin    // Template
        {$IFDEF USE_TEMPLATE}
        Template:=fmMain.TemplateInterface.GetTemplate(sNameReport);
        {$ELSE}
        Template:=nil;
        {$ENDIF}
        if Template=nil then begin
          Result:=-1;
        end else begin
          fmMain.OnTemplateMenuClick(Template);
          Result:=1;
        end;
      end else begin                                 // FastReport
        if (Copy(sNameReport,1,1)<>'&') and ((Right(sNameReport,4)='.FR3') or (Right(sNameReport,4)='.FRF')) then begin
          sNameReport:='&'+sNameReport;
        end;
        GlobalTask.PreViewReport(sNameReport);
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------
function TfmSimpleD.GetHistValueField(strFieldName: String; nType: Integer; strAddStr:String): Variant;
var
  fld : TField;
  strLang,sss:String;
//  lUpper:Boolean;
//  n:Integer;
  arr:TarrStrings;
//  ds:TDataSet;
begin
  Result := null;
  fld := Dokument.FindField(strFieldName);
  strLang:=CheckLangParam(strAddStr);
//  lUpper:=CheckUpperParam(strAddStr);
  {
  //
  n:=Pos(strAddStr,'<FLD=');
  if n>0 then begin
    sField:=Copy(strAddStr,n+5,100);
    n:=Pos(strAddStr,'>');
    if n>0 then begin
      sField:=Copy(sField,1,n-1);
    end;
    StrToArr(sField,arr,';',false);
    ds:=dmBase.GetDataSet(arr[0]);
    sField:=arr[1];
  end;                 
  }
  if fld<>nil then begin
    case nType of
      // вернуть текущее значение
      0 : Result := fld.Value;
      // вернуть все исторические значения
      1 : begin
            Result := '';
            if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
              if HistZAGS.RecordCount > 0 then begin
                HistZAGS.Filter   := 'FIELDNAME='+QStr(UpperCase(strFieldName));
                HistZAGS.Filtered := true;
                while not HistZAGS.Eof do begin
                  if fld.DataType=ftDate then begin
                    if HistZAGSTypeDate.AsInteger=999 then begin // !!!!!!!!!!!!!!!!!!
                       Result := Result + Trim(HistZAGSValue.AsString)+'  ';
                    end else begin
                      if Copy(strLang,1,1)='R'
                        then Result := Result + DatePropisEx(STOD( HistZAGSValue.AsString, tdAds),HistZAGSDatePropis.AsInteger,HistZAGSTypeDate.AsInteger)
                        else Result := Result + DatePropisExBel(STOD( HistZAGSValue.AsString, tdAds),HistZAGSDatePropis.AsInteger,HistZAGSTypeDate.AsInteger);
                    end;
                  end else begin
                    if HistZAGSInfo.AsString='' then begin
                      Result := Result + Trim(HistZAGSStringValue.AsString)+'  ';
                    end else begin
                      if Pos(';', HistZAGSInfo.AsString)>0 then begin
                        StrToArr(HistZAGSInfo.AsString,arr,';',false);
                        SetLength(arr,2);
                        if Copy(strLang,1,1)='B'
                          then sss:=arr[1]
                          else sss:=arr[0];
                      end else begin
                        sss:=HistZAGSInfo.AsString;
                      end;
                      Result := Result + sss+'  ';
                      {
                      sss:='';
                      StrToArr(HistZAGSInfo.AsString,arr,';',false);
                      if Length(arr)>4 then begin
                        if SameText('DS',arr[0]) then begin
                          ds:=dmBase.GetDataSet(arr[1]);
                          if ds<>nil then begin
                            if ds.Locate(arr[2],HistZAGSValue.AsString,[]) then begin
                              if strLang='B'
                                then sss:=ds.FieldByName(arr[4]).AsString
                                else sss:=ds.FieldByName(arr[3]).AsString;
                            end;
                          end;
                        end;
                      end;
                      }
                    end;
                  end;
                  HistZAGS.Next;
                end;
                HistZAGS.Filtered:=false;
                HistZAGS.Filter:='';
                Result := Trim(Result);
              end;
              if (Result<>'') and (strAddStr<>'') then Result:=Result+strAddStr;
            end;
          end;
      // вернуть первое историческое значения
      2 : begin
            Result := '';
            if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
              if HistZAGS.RecordCount > 0 then begin
                HistZAGS.Filter   := 'FIELDNAME='+QStr(UpperCase(strFieldName));
                HistZAGS.Filtered := true;
                HistZAGS.First;
                if not HistZAGS.Eof then begin
                  Result := HISTZAGSStringValue.AsString;
                end;
                HistZAGS.Filtered:=false;
                HistZAGS.Filter:='';
              end;
              if (Result<>'') and (strAddStr<>'') then Result:=Result+strAddStr;
            end;
          end;
      // вернуть значение для истории
      3 : begin
            Result := '';
            if GlobalTask.ParamAsBoolean('HIST_ZAGS') then begin
              if HistZAGS.RecordCount > 0 then begin
                HistZAGS.Filter   := 'FIELDNAME='+QStr(UpperCase(strFieldName));
                HistZAGS.Filtered := true;
                while not HistZAGS.Eof do begin
                  Result := Result + Trim(HistZAGSStringValue.AsString)+'  ';
                  HistZAGS.Next;
                end;
                HistZAGS.Filtered:=false;
                HistZAGS.Filter:='';
                Result := Trim(Result);
              end;
              if (Result<>'') and (strAddStr<>'') then Result:=Result+strAddStr;
            end;
          end;
    end;
  end;
end;

//---------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.FieldsAddHist(arrCont: array of TVarRec; lClear:Boolean);
var
  wc:TWinControl;
  ds:TDataSource;
  i:Integer;
  lOk:Boolean;
  sErr,sField:String;
  fld:TField;
begin
  for i:=Low(arrCont) to High(arrCont) do begin
    wc:=TWinControl(arrCont[i].VObject);
    sField:=Prop_tkString( wc, 'DataField', false, '', lOk);
    ds:=GetDataSource(wc);
    fld:=ds.DataSet.FieldByName(sField);
    if fld.IsNull or (fld.AsString='') then begin

    end else begin
      FieldAddHist(ds.DataSet.FieldByName(sField), wc, sErr);
    end;
  end;
  if lClear then begin
    for i:=Low(arrCont) to High(arrCont) do begin
      wc:=TWinControl(arrCont[i].VObject);
      sField:=Prop_tkString( wc, 'DataField', false, '', lOk);
      ds:=GetDataSource(wc);
      EditDataSet(ds.DataSet);
      ds.DataSet.FieldByName(sField).Value:=null;
    end;
  end;
end;
//---------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.FieldsClear(arrCont: array of TVarRec);
var
  wc:TWinControl;
  ds:TDataSource;
  i:Integer;
  lOk:Boolean;
  sField:String;
  fld:TField;
begin
  for i:=Low(arrCont) to High(arrCont) do begin
    wc:=TWinControl(arrCont[i].VObject);
    sField:=Prop_tkString( wc, 'DataField', false, '', lOk);
    ds:=GetDataSource(wc);
    fld:=ds.DataSet.FieldByName(sField);
    if fld.IsNull or (fld.AsString='') then begin
      fld.Value:=null;
    end;
  end;
end;
procedure TfmSimpleD.FieldAddHistDop(fld : TField; ActControl:TWinControl);
begin
// !!!
end;
//---------------------------------------------------------------------------------------------------------
function  TfmSimpleD.CreateHistRel(objDop:TWinControl; objParent:TWinControl):TAddControl;
begin
  Result:=TAddControl.Create(objDop); // ('область');
//  aw.ValueTrue:='вобласць';
  objParent.Tag:=Integer(Result);
  RelationControl.Add(Result);
end;
//---------------------------------------------------------------------------------------------------------
function TfmSimpleD.FieldAddHist(fld : TField; ActControl : TWinControl; var strErr : String) : Boolean;
var
  fldN : TField;
  s,ss,sInfo,sAddB,sAddE,sAdd,sParam,sField,sFieldB,sFieldKod,ssB : String;
  i,nTypeDate,nDatePropis : Integer;
  aw : TWinControl;
  ac : TAddControl;
  dtIzm : TDateTime;
  arr:TArrStrings;
  dsName:String;
  edD:TDBDateTimeEditEh;
  lFull:Boolean;
begin
//  Result := false;
//  if fld.IsNull then begin //and (fld.DataType<>ftDate) then begin
//    strErr := ' Пустое значение нельзя помещать в историю ! ';
//    exit;
//  end;
  sAddB:='';
  sAddE:='';
  sAdd:='';
//  vKeyValues := VarArrayCreate( [0, 1], varVariant);
//  vKeyValues[0] := fld.FieldName;
//  vKeyValues[1] := STOD(DTOS(dmBase.getCurDate));
//  vKeyValues[1] := DateTimeToStr(STOD(DTOS(dmBase.getCurDate)));
//  if HistZAGS.Locate('FIELDNAME;DATEIZM', vKeyValues, [loCaseInsensitive]) then begin
  dtIzm:=Now; // dmBase.getCurDate;
//  if HistZAGS.Locate('FIELDNAME;DATEIZM', VarArrayOf([fld.FieldName,STOD(DTOS(dmBase.getCurDate))]), [loCaseInsensitive]) then begin
  nTypeDate:=0;
  nDatePropis:=0;
  if HistZAGS.Locate('FIELDNAME;DATEIZM', VarArrayOf([fld.FieldName,dtIzm]), [loCaseInsensitive]) then begin
    HistZAGS.Edit;
  end else begin
    HistZAGS.Append;
  end;
  sParam:=Trim(ActControl.HelpKeyword);   // !!!!!!!!!!!!!!!!!!!!! HELPKEYWORD !!!!!!!!!!!!!
  lFull:=CheckParam('<FULL>', sParam);    // !!!
  StrToArr(sParam,arr,';',false);
  sField:='';
  sFieldB:='';
  sFieldKod:='';
  dsName:='';
  if Length(arr)>1 then begin
    SetLength(arr,3);
    if Sametext(arr[0],'DS') then begin // DATASET
      sField:=arr[1];
      sFieldB:=arr[2];
    end;
  end;
  sInfo:='';
  case fld.DataType of
    ftDate : begin
               sAdd:='';
               if sParam='' then begin   // !!!!!!!!!!!!!!!!!!!!! HELPKEYWORD !!!!!!!!!!!!!
                 nDatePropis:=3;
               end else begin
                 try
                   nDatePropis:=StrToInt(sParam);
                 except
                   nDatePropis:=3;
                 end;
               end;
               if ActControl.Tag>0 then begin
                 nTypeDate:=0;
                 if TObject(ActControl.Tag) is TDbComboBoxEh then begin
                   nTypeDate:=TDbComboBoxEh(ActControl.Tag).ItemIndex;
                   if nTypeDate<0 then nTypeDate:=0;
                 end else if TObject(ActControl.Tag) is TAddControl then begin
                   ac:=TAddControl(Pointer(ActControl.Tag));

                   if ac.EControl<>nil then begin
                     aw := TWinControl(ac.EControl);
                     if (aw is TDBDateTimeEditEh ) then begin
                       edD:=TDBDateTimeEditEh(aw);
                       if not edD.Field.IsNull and (edD.Field.DataType=ftTime) then begin
                         sAdd:=def_space+FormatDateTime(ac.ConstStr, edD.Field.AsDateTime);   // ac.ConstStr= 'H:NN'  !!!!!!!!!
                       end;
                     end else if (aw is TDBCheckBoxEh ) then begin
                       if TDBCheckBoxEh(aw).Checked then nTypeDate:=1   // ONLYGOD=true
                     end;
                   end;
                 end;
               end;
               s  := DTOS(fld.AsDateTime,tdAds);
               ss := DatePropisEx(fld.AsDateTime,nDatePropis,nTypeDate);
               if sAdd<>'' then begin
                 s:=DatePropisEx(fld.AsDateTime,nDatePropis,nTypeDate)+sAdd;
                 ss:=s;
                 nTypeDate:=999;
               end;
               sAdd:='';
             end;
    ftTime : begin
               s  := FormatDateTime('HH:NN:SS',fld.AsDateTime);
               ss := FormatDateTime('HH часов NN минут',fld.AsDateTime);
             end;
  else
    s  := fld.AsString;
    ss := s;
    //---------- если прикреплен еще один контрол ------------------
    if ActControl.Tag>0 then begin
      if TObject(ActControl.Tag) is TAddControl then begin
        ac := TAddControl(Pointer(ActControl.Tag));
        if ac.EControl=nil then begin
          if ac.FirstWord then sAddB:=ac.ConstStr+def_space  else sAddE:=def_space+ac.ConstStr;
        end else begin
          aw := TWinControl(ac.EControl);
          if (aw is TDBLookupComboboxEh ) then begin
            sAdd := TDBLookupComboboxEh(aw).Text+def_space;
    //         if TDbLookupComboboxEh(aw).ListSource.DataSet.Locate(TDBLookupComboboxEh(aw).KeyField, TDBLookupComboboxEh(aw).Field.AsString , [])
    //          then sAdd := TDBLookupComboboxEh(aw).ListSource.DataSet.FieldByName(TDBLookupComboboxEh(aw).ListField).AsString;
          end else if (aw is TDBCheckBoxEh ) then begin
            // поле "область(край)"
            if not (aw as TDBCheckBoxEh).Field.IsNull and (Pos('OBL',(aw as TDBCheckBoxEh).DataField) > 0) then begin
              if (aw as TDBCheckBoxEh).Checked
                then sAdd:=' '+ac.ValueTrue
                else sAdd:=' '+ac.ValueFalse;
            end;
          end;
          if ac.FirstWord then sAddB:=sAdd else sAddE:=sAdd;
        end;
      end;
    end;
    //--------------------------------------------------------------
    if (ActControl is TDBLookupComboboxEh ) then begin
      if TDbLookupComboboxEh(ActControl).ListSource.DataSet.Locate(TDBLookupComboboxEh(ActControl).KeyField, s, []) then  begin
        if sField=''
          then sField:=TDBLookupComboboxEh(ActControl).ListField;
        dsName:=TDBLookupComboboxEh(ActControl).ListSource.DataSet.Name;  // !!!
        sFieldKod:=TDBLookupComboboxEh(ActControl).KeyField;              // !!!
        ss  := TDBLookupComboboxEh(ActControl).ListSource.DataSet.FieldByName(sField).AsString;      // по-русски
        if sFieldB<>''
          then ssB:=TDBLookupComboboxEh(ActControl).ListSource.DataSet.FieldByName(sFieldB).AsString  // по-белорусски
          else ssB:='';
      end;
    end else if (ActControl is TDBComboBoxEh ) then begin
      i := TDBComboBoxEh(ActControl).KeyItems.IndexOf(s);
      if i > -1 then ss := TDBComboBoxEh(ActControl).Items.Strings[i];
    end;
    if sParam<>'' then begin
      if (sParam='DOM') or (sParam='KORP') or (sParam='KV')  then begin
        ss:=CreateNomerDKK(sParam, s);
        s:=ss;
      end;
    end;
  end;
  HistZAGSFieldName.AsString := UpperCase(fld.FieldName);
  HistZAGSTypeDate.AsInteger   := nTypeDate;
  HistZAGSDatePropis.AsInteger := nDatePropis;
  HistZAGSValue.AsString := s;
  if ((sField<>'') or (sFieldB<>'')) and (dsName<>'')  and (sFieldKod<>'') then begin
    HistZAGSInfo.AsString := ss+';'+ssB;
  end;
  if ss='-'
    then HistZAGSStringValue.AsString := ss  // типа пустое значение (например для области или района)
    else HistZAGSStringValue.AsString := sAddB+ss+sAddE; // ss;
  //----- !!! полное значение записшем в "просто" значение !!! -------
  if lFull
    then HistZAGSValue.AsString := HistZAGSStringValue.AsString;
  //------------------------------------------------------------------
  HistZAGSDateIzm.AsDateTime := dtIzm;
  HistZAGS.Post;
  SetPropertyObject( ActControl, 'Color', COLOR_HIST);
  QueryExit:=true;
  if FNewDataSet<>nil then begin
    fldN := FNewDataSet.FindField(fld.FieldName);
    if fldN<>nil then begin
      if fld.DataSet.State<>dsEdit then fld.DataSet.Edit;
      if fldN.AsString=''
        then fld.AsString := ''
        else fld.Value    := fldN.Value;
    end;
  end;
  Result := true;
end;

//--------------------------------------------------------------
procedure TfmSimpleD.TBItemAddHistClick(Sender: TObject);
var
  strErr : String;
  fld : TField;
begin
  if ActiveControl is TCustomDbEditEh then begin
    fld := TCustomDbEditEh(ActiveControl).Field;
    fld.DataSet.CheckBrowseMode;
    if EnableHistoryField(fld.FieldName) and EnableHistoryControl(ActiveControl) then begin
      if fld.IsNull or (fld.asString='') then begin
        PutError(' Пустое значение нельзя помещать в историю ! ',self);
        exit;
      end;
      if FieldAddHist(fld, ActiveControl, strErr) then begin
        FieldAddHistDop(fld, ActiveControl);
//        ShowMessage(' Значение добавлено в историю. ');
      end;
    end else begin
      Beep;
      ShowMessageCont(' Для текущего реквизита история не поддерживается ! ',self);
    end;
  end;
end;


//--------------------------------------------------------------------------
procedure TfmSimpleD.TBItemClearHistClick(Sender: TObject);
var
  i:Integer;
begin
  if GlobalTask.ParamAsBoolean('HIST_ZAGS') and HistZAGS.Active then begin
    if Problem('Очистить историю всех реквизитов ?',mtConfirmation,self) then begin
      QueryExit:=true;
      HistZAGS.EmptyTable;
      for i:=0 to ComponentCount-1 do begin
        if Components[i] is TCustomDbEditEh then begin
          if GetColorProp(Components[i])=COLOR_HIST then begin
            SetPropertyObject( Components[i], 'Color', COLOR_NORM);
          end;
        end;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------
procedure TfmSimpleD.TBItemAddHist1Click(Sender: TObject);
var
  strErr : String;
  fld : TField;
begin
  if ActiveControl is TCustomDbEditEh then begin
    fld := TCustomDbEditEh(ActiveControl).Field;
    fld.DataSet.CheckBrowseMode;
    if EnableHistoryControl(ActiveControl) then begin
      if EnableHistoryField(fld.FieldName) then begin
        if fld.IsNull then begin
          PutError(' Пустое значение нельзя помещать в историю ! ',self);
          exit;
        end;
        if FieldAddHist(fld, ActiveControl, strErr) then begin
  //        ShowMessage(' Значение добавлено в историю. ');
        end;
      end else begin
        Beep;
        ShowMessageCont(' Для текущего реквизита история не поддерживается ! ',self);
      end;
    end;
  end;
end;
//--------------------------------------------------------------------------
procedure TfmSimpleD.TBItemHistClick(Sender: TObject);
var
  fld : TField;
begin
  if ActiveControl is TCustomDbEditEh then begin
    fld := TCustomDbEditEh(ActiveControl).Field;
    if EnableHistoryField(fld.FieldName) and EnableHistoryControl(ActiveControl) then begin
      ShowHist( Self,TCustomDbEditEh(ActiveControl) );
    end;
  end;
end;
//--------------------------------------------------------------------------
procedure TfmSimpleD.btNewPovtorClick(Sender: TObject);
var
  strErr : String;
  strNewNomer,strNewSeria, s1, s2 : String;
begin
  if DokumentPOVTOR.AsBoolean then begin
    if (SvidPovtor.state<>dsEdit)	and (SvidPovtor.state<>dsInsert) then begin
      btNewPovtor.Enabled:=false;
      try
        if FTypeObj=dmBase.TypeObj_ZRast then begin
          {$IFDEF ZAGS}
          strErr := dmBase.GetNewNomerSvidR( strNewNomer, strNewSeria, s1, s2);
          {$ENDIF}
        end else begin
          strErr := dmBase.GetNewNomerSvid(FTypeObj, FMainTable, strNewNomer, strNewSeria);
        end;
        if strErr='' then begin
          if SvidPovtor.Locate('SVID_SERIA;SVID_NOMER', VarArrayOf([strNewSeria,strNewNomer]),[]) then begin
            ActiveControl:=DbGridEh1;
//            SvidPovtor.Append;
//            ActiveControl:=GridSvid;
//            SvidPovtorSVID_DATE.AsDateTime:=Date;
//            SvidPovtorGISRN.AsBoolean:=false;
          end else begin
            SvidPovtor.Append;
            SvidPovtorSVID_SERIA.AsString := strNewSeria;
            SvidPovtorSVID_NOMER.AsString := strNewNomer;
            SvidPovtorSVID_DATE.AsDateTime  := Date;
            SvidPovtorGISRN.AsInteger:=0;
            SvidPovtor.Post;
            ActiveControl:=DbGridEh1;
          end;
        end else begin
          PutError(strErr,self);
        end;
      finally
        btNewPovtor.Enabled:=true;
      end;
    end;
  end else begin
    ShowMessageCont('  Включите повторное свидетельство  ',self);
  end;
end;

procedure TfmSimpleD.btDelPovtorClick(Sender: TObject);
begin
//  if DokumentPOVTOR.AsBoolean then begin
    if not SvidPovtorSVID_DATE.IsNull or not SvidPovtorSVID_NOMER.IsNull then begin
      if Problem('Удалить повторное свидетельство '+SvidPovtorSVID_SERIA.AsString+' '+SvidPovtorSVID_NOMER.AsString+' ?',mtConfirmation,Self) then begin
        SvidPovtor.Delete;
        QueryExit:=true;
      end;
    end;
//  end;
end;

procedure TfmSimpleD.TBItemAddSvidClick(Sender: TObject);
var
  strErr : String;
begin
  strErr := AddSvid;
  if strErr<>'' then begin
    PutError(strErr,self);
  end;
end;

function TfmSimpleD.AddSvid(lAllRun:Boolean):String;
var
  fld : TField;
  d : TDateTime;
  strNewNomer, strNewSeria : String;
begin              
  Result := '';       
  fld := Dokument.FindField('DATEZ');
  if fld=nil then begin
    d := Date;
  end else begin
    if fld.IsNull then d := Date
                  else d := fld.AsDateTime;
  end;
  {$IFDEF ZAGS}
  if not dmBase.OblArxivZAGS then begin
  {$ELSE}

  {$ENDIF}
  if (Dokument.FieldByName('SVID_NOMER').AsString='') or lAllRun then begin
    Result := dmBase.getNewNomerSvid(FTypeObj, FMainTable, strNewNomer, strNewSeria);
    if (Result='') then begin
      EditDataSet(Dokument);
      Dokument.FieldByName('SVID_NOMER').AsString := strNewNomer;
      Dokument.FieldByName('SVID_SERIA').AsString := strNewSeria;
      fld := Dokument.FindField('DATESV');
      if FTypeObj=dmBase.TypeObj_ZBrak then begin
        if FOnlySvid then begin
          if fld<>nil then fld.AsDateTime := d;
        end;
      end else begin
        if fld<>nil then fld.AsDateTime := d;
      end;
    end;
  end else begin
    Result:='Номер свидетельства уже заполнен !';
  end;
  {$IFDEF ZAGS}
  end;
  {$ELSE}
  {$ENDIF}
end;

//-------------------------------------------------------------------------
procedure TfmSimpleD.InitArrChoiceRekv(n:Integer);
var
  i:Integer;
begin
  SetLength(FArrChoiceRekv,n);
  for i:=0 to Length(FArrChoiceRekv)-1 do begin
    FArrChoiceRekv[i].nType:=0;
    FArrChoiceRekv[i].TypeEdit:=emSimple;
    FArrChoiceRekv[i].nTypeSpr:=0;
    FArrChoiceRekv[i].DataSet:=nil;
    FArrChoiceRekv[i].AddFieldsName:='';
    FArrChoiceRekv[i].sPadeg:='';
    FArrChoiceRekv[i].FieldName:='';
    FArrChoiceRekv[i].FieldNameBel:='';
  end;
end;

//-------------------------------------------------------------------------
function TfmSimpleD.FindChoiceRekv(strFieldName:String; ds:TDataSet):Integer;
var
  i:Integer;
begin
  Result:=-1;
  strFieldName:=ANSIUpperCase(strFieldName);
  for i:=0 to Length(FArrChoiceRekv)-1 do begin
    if strFieldName=FArrChoiceRekv[i].FieldName then begin
      if ds=nil then begin
        Result:=i;
      end else begin
        if (FArrChoiceRekv[i].DataSet<>nil) and  (ds=FArrChoiceRekv[i].DataSet)
          then Result:=i;
      end;
      if Result>-1 then exit;
    end;
  end;
end;
//-------------------------------------------------------------------------
procedure TfmSimpleD.TBItemShablonClick(Sender: TObject);
var
  i,n,j,nID : Integer;
  strFieldName,s,s1,s2 : String;
  ds:TDataSet;
  ed : TDbEditEh;
//  edL: TDBLookupComboboxEh;
  Opis:TOpisEdit;
  v:Variant;
  arrRec:TCurrentRecord;
  arr1,arr2:TArrStrings;
  lOk:Boolean;
  edM:TDbMemo;
begin         
  if (ActiveControl is TDBMemo) then begin
    for i:=0 to Length(FArrChoiceRekv)-1 do begin
      edM:=TDBMemo(ActiveControl);
      strFieldName := ANSIUpperCase(edM.Field.FieldName);
      if strFieldName=FArrChoiceRekv[i].FieldName then begin
        if FArrChoiceRekv[i].nType>0 then begin // выбор из шаблона
          s:=ChoiceFromShablon(FArrChoiceRekv[i].nType);
          n:=edM.SelStart;
          edM.SelStart:=0;
          edM.SelLength:=0;
          s1:=Copy(edM.Text,1,n);
          s2:=Copy(edM.Text,n+1,Length(edM.Text));
          edM.Text := s1+s+s2;
          edM.SelStart:=Length(s1+s);
        end;
      end;
    end;
  end else if (ActiveControl is TDBGridEh) then begin
    i:=FindChoiceRekv(TDBGridEh(ActiveControl).SelectedField.FieldName, TDBGridEh(ActiveControl).DataSource.DataSet);
    if i>-1 then begin
      ChoiceShablonZAGS(TDBGridEh(ActiveControl).DataSource.DataSet,TDBGridEh(ActiveControl).SelectedField.FieldName,FArrChoiceRekv[i].sPadeg,FArrChoiceRekv[i].AddFieldsName);
    end;
  end else if (ActiveControl is TDBEditEh) or (ActiveControl is TDBLookupComboboxEh) then begin
    if not TDBEditEh(ActiveControl).ReadOnly then begin
      strFieldName := ANSIUpperCase(TDBEditEh(ActiveControl).Field.FieldName);
      if (strFieldName='NAME_ZAGS') or (strFieldName='ZAGS_NAME') or (strFieldName='NAME_ZAGS_B') then begin
        lOk:=false;   
        for i:=0 to Length(FArrChoiceRekv)-1 do begin
          if strFieldName=FArrChoiceRekv[i].FieldName then begin
            lOk:=true;
            if DokumentLANG.AsInteger=1 then s:='<B>' else s:='';
            ChoiceShablonZAGS(TDBEditEh(ActiveControl).Field.DataSet,s+strFieldName,FArrChoiceRekv[i].sPadeg,FArrChoiceRekv[i].AddFieldsName);
            break;      
          end;
        end;
        if not lOk then begin
          if DokumentLANG.AsInteger=1 then s:='<B>' else s:='';
          ChoiceShablonZAGS(nil, s+'NAME_ZAGS', '', '');
        end;
      end else begin
        for i:=0 to Length(FArrChoiceRekv)-1 do begin
          if strFieldName=FArrChoiceRekv[i].FieldName then begin
            if FArrChoiceRekv[i].nType>0 then begin // выбор из шаблона
              s:=ChoiceFromShablon(FArrChoiceRekv[i].nType);
              ed:=TDBEditEh(ActiveControl);
              //----- если есть дополнитнльные поля для записи из шаблона
              if FArrChoiceRekv[i].AddFieldsName<>'' then begin
                StrToArr(FArrChoiceRekv[i].FieldName+'#'+FArrChoiceRekv[i].AddFieldsName,arr1,'#',true);
                StrToArr(s,arr2,'#',false);
                SetLength(arr2,Length(arr1));
                EditdataSet(Dokument);
                for j:=Low(arr1) to High(arr1) do begin
                  Dokument.FieldByName(arr1[j]).AsString:=arr2[j];
                end;
              end else begin
                n:=ed.SelStart;
                ed.SelStart:=0;
                ed.SelLength:=0;
                s1:=Copy(ed.Text,1,n);
                s2:=Copy(ed.Text,n+1,Length(ed.Text));
                ed.Text := s1+s+s2;
                ed.SelStart:=Length(s1+s);
              end;

  //            eTDBEditEh(ActiveControl).Text := TDBEditEh(ActiveControl).Text + s;
  //            SendMessage(TDBEditEh(ActiveControl).Handle,  WM_SETTEXT,  0,  LParam(PChar(s)));
  //            if TDBEditEh(ActiveControl).WantReturns then begin
  //              SendKeys('{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{END}', false);
  //            end else begin
  //              SendKeys('{END}', false);
  //            end;
            end else begin
              if FArrChoiceRekv[i].nTypeSpr=_SHABLON_WORK then begin
                ChoiceMestWork( TDBEditEh(ActiveControl) );
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_ZAGS then begin
                ChoiceShablonZAGS(TDBEditEh(ActiveControl).Field.DataSet,TDBEditEh(ActiveControl).Field.FieldName,FArrChoiceRekv[i].sPadeg,FArrChoiceRekv[i].AddFieldsName);
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_ZAGS+100 then begin
                ChoiceShablonZAGS(TDBEditEh(ActiveControl).Field.DataSet,'<B>'+TDBEditEh(ActiveControl).Field.FieldName,FArrChoiceRekv[i].sPadeg,FArrChoiceRekv[i].AddFieldsName);
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_WORK_DOLG then begin
                if Pos(',', TDBEditEh(ActiveControl).Text)>0 then begin
                  ChoiceDolg( TDBEditEh(ActiveControl) );
                end else begin
                  ChoiceMestWork( TDBEditEh(ActiveControl) );
                end;
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_DOLG then begin
                ChoiceDolg( TDBEditEh(ActiveControl) );
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_UL then begin
                ChoiceUl( TDBEditEh(ActiveControl) );
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_STRANA then begin
                Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_STRANFULL');
                if Opis <> nil then begin
                  if TDBLookupComboboxEh(ActiveControl).ListVisible then begin
                    TDBLookupComboboxEh(ActiveControl).CloseUp(false);
                  end;
  //                TDBLookupComboboxEh(ActiveControl).DropDown;
                  if Opis.ChoiceFromSprEx(nil, v, arrRec, nil) and (v<>null) then begin
                    TDBLookupComboboxEh(ActiveControl).Value:=v;
                  end;
                end;
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_VUS then begin
                Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_VOENKOM');
                if Opis <> nil then begin
                  SetLength(arrRec,1);
                  if Opis.ChoiceFromSprEx(TDBEditEh(ActiveControl), v, arrRec, nil) and (v<>null) then begin
                    if ActiveControl is TDBEditEh
                      then TDBEditEh(ActiveControl).Value:=GetValueFieldEx(arrRec,'NAME','')
                    else if ActiveControl is TDBLookupComboboxEh
                      then TDBLookupComboboxEh(ActiveControl).Value:=GetValueFieldEx(arrRec,'ID','');
//                    s:=TDBEditEh(ActiveControl).Field.FieldName;
//                    ds:=TDBEditEh(ActiveControl).Field.DataSet;
//                    if ds.FindField(s+'_NAME')<>nil then begin
//                      ds.FindField(s+'_NAME').AsString:=GetValueFieldEx(arrRec,'NAME','');
//                    end;
                  end;
                end;
              end else if FArrChoiceRekv[i].nTypeSpr=_SHABLON_MKB10 then begin
                Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_MKB10');
                if Opis <> nil then begin
                  SetLength(arrRec,1);
                  if Opis.ChoiceFromSprEx(TDBEditEh(ActiveControl), v, arrRec, nil) and (v<>null) then begin
                    TDBEditEh(ActiveControl).Value:=v;
                    s:=TDBEditEh(ActiveControl).Field.FieldName;
                    ds:=TDBEditEh(ActiveControl).Field.DataSet;
                    if ds.FindField(s+'_NAME')<>nil then begin
                      ds.FindField(s+'_NAME').AsString:=GetValueFieldEx(arrRec,'NAME','');
                    end;
                  end;
                end;
              end;
              if TDBEditEh(ActiveControl).WantReturns then begin
                SendKeys('{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{END}', false);
              end else begin
                SendKeys('{END}', false);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmSimpleD.ChoiceMestWork( ed : TDbEditEh );
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
  old : TCursor;
  ParamFlt : TParamFieldFlt;
  s : String;
begin
  Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_WORK_ZAGS');
  if Opis<>nil then begin
    SetLength(arrRec,1);
    ParamFlt := TParamFieldFlt.Create;
    s := Trim(ed.Text);
    if (s<>'') and (Pos(' ',s)=0) then begin
      Opis.AutoFilter:=true;
      with ParamFlt do begin
        TypeSr:=tsAt;
        Value1:=s;
        CICharacter:=true;
        FieldName:=Opis.ResultField;
        OnlySet:=true;
      end;
    end;
    v:=null;
    if Opis.ChoiceFromSprEx(ed, v, arrRec, ParamFlt) then begin
      old := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      v := GetValueField(arrRec, Opis.ResultField);
      if VarToStr(v)='' then v := GetValueField(arrRec, 'NAME');
      if v <> null then ed.Text := v;
      Screen.Cursor := old;
    end;
    ParamFlt.Free;
  end;
end;

procedure TfmSimpleD.ChoiceUl( ed : TDbEditEh );
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
  old : TCursor;
  s,ss : String;
  ParamFlt : TParamFieldFlt;
begin
  Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_UL_SPR');
  if Opis<>nil then begin
    SetLength(arrRec,1);
    ParamFlt := TParamFieldFlt.Create;
    s := Trim(ed.Text);
    if (s<>'') and (Pos(' ',s)=0) then begin
      Opis.AutoFilter:=true;
      with ParamFlt do begin
        TypeSr:=tsBegin;
        Value1:=s;
        FieldName:='NAME';
        CICharacter:=true;
        OnlySet:=true;
      end;
    end;
    v:=null;
    if Opis.ChoiceFromSprEx(ed, v, arrRec, ParamFlt) then begin
      old := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      v := GetValueField(arrRec, 'TIP');
      ss := '';
      if v<>null then begin
        if dmBase.SprTypeUl.Locate('ID', v, []) then begin
          ss := dmBase.SprTypeUl.FieldByName('NAME').AsString+' ';
        end;
      end;
      v := GetValueField(arrRec, 'NAME');
      if v <> null then ed.Text := ss+VarToStr(v);
      Screen.Cursor := old;
    end;
    ParamFlt.Free;
  end;
end;

procedure TfmSimpleD.ChoiceDolg( ed : TDbEditEh );
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
  old : TCursor;
  s,ss : String;
  ParamFlt : TParamFieldFlt;
  i:Integer;
begin
  Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_DOLG_NAME_ZAGS');
  if Opis<>nil then begin
    SetLength(arrRec,1);
    ParamFlt := TParamFieldFlt.Create;
    ss := Trim(ed.Text);
    i:=Pos(',',ss);
    if i>0 then begin
      s:=Trim(Copy(ss,i+1,100))
    end else begin
      if ss<>'' then s:=ss else s:='';
    end;
    if (s<>'') then begin
      Opis.AutoFilter:=true;
      with ParamFlt do begin
        TypeSr:=tsBegin;
        Value1:=s;
        FieldName:='NAME';
        CICharacter:=true;
        OnlySet:=true;
      end;
    end;
    v:=null;
    if Opis.ChoiceFromSprEx(ed, v, arrRec, ParamFlt) then begin
      old := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      v := GetValueField(arrRec, 'NAME');
      if v <> null then begin
        if i>0 then ed.Text := Copy(ss,1,i)+' '+VarToStr(v)
               else ed.Text := VarToStr(v);
      end;
      Screen.Cursor := old;
    end;
    ParamFlt.Free;
  end;
end;

procedure TfmSimpleD.AdditiveNewDok;
begin
  {$IFDEF ZAGS}
    if dmBase.OblArxivZAGS then begin
      DokumentPOVTOR.AsBoolean := true;
    end;
  {$ELSE}
     if DokumentIS_GOROD.IsNull then DokumentIS_GOROD.AsBoolean:=false;
  {$ENDIF}
  if FDokZags then begin
    FNameRukZAGS   := GlobalTask.ParamAsString('DOLG_RUK_ZAGS');
    FNameSpecZAGS  := GlobalTask.ParamAsString('DOLG_SPEC');
  end;
  FAddNewDok:=true;
end;

procedure TfmSimpleD.AdditiveReadDok;
var
  fld:TField;
begin
  {$IFDEF ZAGS}
    if dmBase.OblArxivZAGS then begin
      DokumentPOVTOR.AsBoolean := true;
    end;
    if DokumentID.AsString<>'' then begin
      ReadSvidPovtor( FTypeObj, DokumentID.AsInteger );
    end;
    CheckTsSvidPovtor;
  {$ELSE}
     if DokumentIS_GOROD.IsNull then DokumentIS_GOROD.AsBoolean:=false;
  {$ENDIF}
  if FDokZags then begin
    FNameRukZAGS   := GlobalTask.ParamAsString('DOLG_RUK_ZAGS');
    FNameSpecZAGS  := GlobalTask.ParamAsString('DOLG_SPEC');
    fld:=Dokument.FindField('NOMER');
    if fld<>nil then FOldNomer:=fld.AsInteger;
    {$IFDEF LAIS}
      if (ItParCopy<>nil)
        then ItParCopy.Checked:=(GlobalTask.GetLastValueAsInteger('COPY_ZAGS_RUK_RN')=1);
    {$ENDIF}
  end;
  Check_NotRequired;
  IDLastDok:=DokumentID.AsInteger;
  FAddNewDok:=false;
  CheckEkz;
  if GlobalTask.GetLastValueAsString(GetVid+'DELETE_CRLF')='1'
    then DokumentDELETE_CRLF.AsBoolean:=true
    else DokumentDELETE_CRLF.AsBoolean:=false;
end;
//-----------------------------------------------------------
procedure TfmSimpleD.AdditiveWriteDok;
var
  s:String;
begin
  if FDokZags then begin
    if FAddNewDok
      then s:='Добавление'
      else s:='Корректировка';
    GlobalTask.LogFile.WriteToLogFile(s+' з/а '+GlobalTask.CurrentOpisEdit.GetListOpisA('KEY_TYPEZAGS_FULL').Naim(FTypeObj,false)+
       ' №'+Dokument.FieldByName('NOMER').AsString+' от '+FormatDateTime('dd.mm.yyyy',Dokument.FieldByName('DATEZ').AsDateTime)+ '('+dmBase.UserID+')');
  end;
  {$IFDEF ZAGS}

    if DokumentID.AsString<>'' then begin
      WriteSvidPovtor( FTypeObj, DokumentID.AsInteger );
    end;
  {$ELSE}
  {$ENDIF}
  if (DokumentID.AsInteger>-1) and not FOnlySvid then begin
    IDLastDok:=DokumentID.AsInteger;
    SetLastAddDok(DokumentID.AsInteger);
  end;
  //------- !!! -------------------------
  if Length(CurRecDok)>0 then begin
    GetCurrentRecord( Dokument, '', CurRecDok);
  end;
  //--------------------------------
  if DokumentDELETE_CRLF.AsBoolean=true
    then GlobalTask.SetLastValueAsString(GetVid+'DELETE_CRLF','1')
    else GlobalTask.SetLastValueAsString(GetVid+'DELETE_CRLF','0');

end;

procedure TfmSimpleD.TBItemWordClick(Sender: TObject);
var
  sFunc:String;
  v:Variant;
begin
  if FTemplate<>nil then begin
    PostDokument;
    sFunc:=FTemplate.ScriptName+'_UserForm';
    v:=true;
    RunProcScript(sFunc,v);
    if (v=true) then begin
      fmMain.TemplateInterface.SetParams(fmMain.DateFiks,0,0);
      fmMain.TemplateInterface.SetSimpleTemplate(FTemplate.FullName);
    end;
  end;
end;

function TfmSimpleD.LoadTemplate( strName : String ) : Boolean;
var
  i,nCount,nIndex:integer;
  s,ss:String;
begin
  nCount:=0;
  nIndex:=-1;
  ss:=UpperCase(strName);
  for i:=0 to fmMain.TemplateInterface.Engine.TemplateList.Count-1 do begin
    s:=ANSIUpperCase(fmMain.TemplateInterface.Engine.TemplateList[i].FullName);
    if (Pos(ss,s)>0) then begin
      nIndex:=i;
      Inc(nCount,1);
    end;
  end;
  if nCount=0 then begin
    Result:=false;
    TBItemWord.Visible:=false;
    TBItemWord.ShortCut:=0
  end else if nCount=1 then begin
    TBItemWord.Visible:=true;
    TBSubmenuTmp.ShortCut:=0;
    FTemplate:=fmMain.TemplateInterface.Engine.TemplateList[nIndex];
    Result:=false;
  end else begin
    TBItemWord.Visible:=false;
    TBItemWord.ShortCut:=0;
    Result := fmMain.TemplateInterface.BuildMenu(strName, TBSubmenuTmp, false, OnMenuWordClick);
    {$IFDEF ZAGS}
      if fmMain.TemplateInterface.BuildMenu(strName+'_ZAGS', TBSubmenuTmp, false, OnMenuWordClick) then begin
        Result := true;
      end;
    {$ELSE}
      if fmMain.TemplateInterface.BuildMenu(strName+'_SS', TBSubmenuTmp, false, OnMenuWordClick) then begin
        Result := true;
      end;
    {$ENDIF}
  end;
end;

procedure TfmSimpleD.OnMenuWordClick(Sender: TObject);
var
   Template: TTemplate;
begin
   if (Sender<>nil) and (Sender is TComponent) then begin
      if BeforeReport then begin
        PostDokument;
        Template:=TTemplate(TComponent(Sender).Tag);
        if Template<>nil then begin
           if Trim(fmMain.TemplateInterface.DefaultParameterIniFile)<>'' then begin
              fmMain.TemplateInterface.SetTemplate(fmMain.TemplateInterface.DefaultParameterIniFile,
                    fmMain.TemplateInterface.DefaultDatabaseName,
                    fmMain.TemplateInterface.DefaultScript, Template)
           end
           else begin
//              fmMain.TemplateInterface.SetTemplate(fmMain.TemplateInterface.TemplateDir+Template.TemplateFile,
               fmMain.TemplateInterface.SetTemplate(fmMain.TemplateInterface.GetFullNameFile(Template),
               fmMain.TemplateInterface.DefaultDatabaseName,
               fmMain.TemplateInterface.DefaultScript, Template)
           end;
        end;
      end;
   end;
end;

{
function TfmSimpleD.CheckSvid(TypeSvid : Integer; strFieldDate : String;
         strFieldSeria,strFieldNomer : String; var strBookMark : String ) : String;
var
  vKeyValues : Variant;
  strSeria,strNomer : String;
  dDateSvid : TDateTime;
begin
  strBookMark := '';
  Result := '';
  if GlobalTask.ParamAsBoolean('CHECK_SVID') then begin
    //$IFDEF ZAGS
      // если загс чужой, контроль и проведение документов не проводим
      if (Dokument.FieldByName('ID_ZAGS').AsString<>'') and
         (Dokument.FieldByName('ID_ZAGS').AsString<>GlobalTask.ParamAsString('ID')) then begin
        exit;
      end;
    //$ENDIF
    dDateSvid := 0;
    strSeria  := Trim(Dokument.FieldByName(strFieldSeria).AsString);
    strNomer  := Trim(Dokument.FieldByName(strFieldNomer).AsString);
    if not Dokument.FieldByName(strFieldDate).IsNull then begin
      dDateSvid := Dokument.FieldByName(strFieldDate).AsDateTime;
    end;
    if strNomer = '' then begin
      if (strSeria<>'') or (dDateSvid<>0) then begin
        Result := 'Не заполнен номер свидетельства';
      end;
    end else begin
      if strSeria='' then begin
        Result := 'Не заполнена серия свидетельства';
      end else if dDateSvid=0 then begin
        Result := 'Не заполнена дата свидетельства';
      end else begin
        vKeyValues := VarArrayCreate( [0, 2], varOleStr );
        vKeyValues[0] := TypeSvid;
        vKeyValues[1] := strSeria;
        vKeyValues[2] := strNomer;
        if dmBase.ListSvid.Locate('SVID_TYPE;SVID_SERIA;SVID_NOMER', vKeyValues,[]) then begin
          with dmBase.ListSvid do begin
            // свидетельство поступило позже даты его выдачи
            if FieldByName('DATEP').AsDateTime > dDateSvid then begin
              Result := 'В базе свидетельств текущее свидетельство поступило позже даты его выдачи';
            end else begin
              // свидетельство уже было израсходовано
  //            if not FieldByName('SOST').IsNull and (FieldByName('SOST').AsInteger<>0) then begin
              try
                Edit;
                //$IFDEF ZAGS
                  if DokumentPOVTOR.AsBoolean then begin
                    FieldByName('SOST').AsInteger := SVID_VIDANO_P;
                  end else begin
                    FieldByName('SOST').AsInteger := SVID_VIDANO;
                  end;
                //$ELSE
                  FieldByName('SOST').AsInteger := SVID_VIDANO;
                //$ENDIF
                FieldByName('DATER').AsDateTime    := dDateSvid;
                FieldByName('AKT_NOMER').AsInteger := Dokument.FieldByName('NOMER').AsInteger;
                FieldByName('AKT_DATE').AsDateTime := Dokument.FieldByName('DATEZ').AsDateTime;
                strBookMark := Bookmark;
                if DokumentID.AsInteger>0 then begin
                  FieldByName('AKT_ID').AsInteger := DokumentID.AsInteger;
                  strBookMark := '';  // необходимости записи ID нет
                end;
                Post;
              except
                PutError('Ошибка доступа к базе свидетельств !');
              end;
            end;
          end;
        end else begin
          Result := 'В базе свидетельств не найдено значение ' + strSeria + ' № ' + strNomer;
        end;
      end;
    end;
  end else begin

  end;
end;
}

procedure TfmSimpleD.AddEditSvid( strBookMark : String );
begin
  if (strBookMark<>'') and (DokumentID.AsInteger>0) then begin
    dmBase.ListSvid.Bookmark   := strBookMark;
    dmBase.ListSvid.Edit;
    dmBase.ListSvid.FieldByName('AKT_ID').AsInteger := DokumentID.AsInteger;
    dmBase.ListSvid.Post;
  end;
end;
//----------------------------------------------
procedure TfmSimpleD.SetPanelPovtor( ts : ComCtrls.TTabSheet; cb : TDbCheckBoxEh; lbRuk,lbSpec : TLabel );
begin
  {$IFDEF ZAGS}               
    if ts<>nil then begin
      FcbPovtor := cb;
      FcbPovtor.OnClick:=cbPovtorOnClick;
      FtsPovtor := TTabSheet(ts);
      ts.TabVisible := true;
      pnPovtor.Parent  := ts;
      pnPovtor.Visible := true;
      pnPovtor.Align   := alClient;
      pnPovtor.BevelOuter := bvNone;
      TBItemDolg.Visible := true;
//      TBItemDelList.Visible := true;
    end else begin
      FcbPovtor := nil;
      FtsPovtor := nil;
      ts.TabVisible := false;
      pnPovtor.Visible := false;
    end;
  {$ELSE}
    FcbPovtor := nil;
    FtsPovtor := nil;
    ts.TabVisible := false;
    pnPovtor.Visible := false;
  {$ENDIF}
//  FlbRuk  := lbRuk;
//  FlbSpec := lbSpec;
end;

procedure TfmSimpleD.SetPanelPovtor(ts: TTabSheet; cb : TDbCheckBoxEh; lbRuk,lbSpec : TLabel  );
begin
  {$IFDEF ZAGS}
    if ts<>nil then begin
      FcbPovtor := cb;
      FcbPovtor.OnClick:=cbPovtorOnClick;
      FtsPovtor := ts;
      ts.TabVisible := true;
      pnPovtor.Parent  := ts;
      pnPovtor.Visible := true;
      pnPovtor.Align   := alClient;
      pnPovtor.BevelOuter := bvNone;
      TBItemDolg.Visible := true;
//      TBItemDelList.Visible := true;
    end else begin
      FcbPovtor := nil;
      FtsPovtor := nil;
      ts.TabVisible := false;
      pnPovtor.Visible := false;
    end;
  {$ELSE}       
    FcbPovtor := nil;
    FtsPovtor := nil;
    ts.TabVisible := false;
    pnPovtor.Visible := false;
  {$ENDIF}
//FlbRuk  := lbRuk;
//FlbSpec := lbSpec;
end;


procedure TfmSimpleD.dsPovtorDataChange(Sender: TObject; Field: TField);
//var
//  v : Variant;
begin
  if (Field<>nil) and (Dokument<>nil) then begin
    QueryExit := true;
//    showmessage('Data Change '+Field.FieldName);
//    RunProcScript(GetVid+'_'+UpperCase(Field.FieldName),v);
  end;
end;

procedure TfmSimpleD.TBItemDolgClick(Sender: TObject);
begin
  if EditDolgZAGS( FNameRukZAGS, FNameSpecZAGS) then begin
    EditDataSet(Dokument);
    DokumentRUKOV_D.AsString:=FNameRukZAGS;
    DokumentSPEC_D.AsString:=FNameSpecZAGS;
    PostDataSet(Dokument);
  end;
end;

procedure TfmSimpleD.CheckListObl(Sender: TObject; NewText: String; var RecheckInList: Boolean);
var
  tb : TAdsTable;
begin
  if Trim(NewText)<>'' then begin
    NewText:=Trim(NewText);
    NewText := ANSIUpperCase(Copy(NewText,1,1))+ANSILowerCase(Copy(NewText,2,Length(NewText)-1));
    tb := TAdsTable(TDBLookupComboboxEh(Sender).ListSource.DataSet);
    if ANSIUpperCase(tb.TableName) = 'SPRPEREVOD' then begin
      tb.Append;
      tb.FieldByName('TIP').AsInteger := 1;
      tb.FieldByName(TDBLookupComboboxEh(Sender).KeyField).AsString := NewText;
      tb.Post;
      RecheckInList:=true;
    end;
  end;
end;

procedure TfmSimpleD.CheckListRaion(Sender: TObject; NewText: String;
  var RecheckInList: Boolean);
var
  tb : TAdsTable;
begin
  if Trim(NewText)<>'' then begin
    NewText:=Trim(NewText);
    NewText := ANSIUpperCase(Copy(NewText,1,1))+ANSILowerCase(Copy(NewText,2,Length(NewText)-1));
    tb := TAdsTable(TDBLookupComboboxEh(Sender).ListSource.DataSet);
    if ANSIUpperCase(tb.TableName) = 'SPRPEREVOD' then begin
      tb.Append;
      tb.FieldByName('TIP').AsInteger := 2;
      tb.FieldByName(TDBLookupComboboxEh(Sender).KeyField).AsString := NewText;
      tb.Post;
      RecheckInList:=true;
    end;
  end;
end;

procedure TfmSimpleD.CheckListRnGor(Sender: TObject; NewText: String;
  var RecheckInList: Boolean);
var
  tb : TAdsTable;
begin
  if Trim(NewText)<>'' then begin
    tb := TAdsTable(TDBLookupComboboxEh(Sender).ListSource.DataSet);
    if ANSIUpperCase(tb.TableName) = 'SPRPEREVOD' then begin
      tb.Append;
      tb.FieldByName('TIP').AsInteger := 4;
      tb.FieldByName(TDBLookupComboboxEh(Sender).KeyField).AsString := NewText;
      tb.Post;
      RecheckInList:=true;
    end;
  end;
end;

procedure TfmSimpleD.btClearFirstClick(Sender: TObject);
var
  fld : TField;
begin
  fld := Dokument.FindField('DATESV');
  if fld<>nil then begin
    if Problem('Удалить данные о первичном свидетельстве ?',mtConfirmation,Self) then begin
      Dokument.CheckBrowseMode;
      Dokument.Edit;
      fld.AsString := '';
      Dokument.FieldByName('SVID_SERIA').AsString := '';
      Dokument.FieldByName('SVID_NOMER').AsString := '';
    end;
  end;
end;

procedure TfmSimpleD.TBItemSvidIsporClick(Sender: TObject);
begin
  if not Dokzags.IsporSvid then begin
    PutError(Dokzags.GetLastError,self);
  end;
end;

function TfmSimpleD.ChoiceFromLookupSpr( strNameOpis : String; strFieldName : String; lString : Boolean; cont:TWinControl):Boolean;
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
  old : TCursor;
begin
  Result:=false;
  SetLength(arrRec,1);
  v := null;
  old := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA(strNameOpis);
  finally
    Screen.Cursor := old;
  end;
  if Opis <> nil then begin
    if Opis.ChoiceFromSprEx(cont, v, arrRec, nil) and (v<>null) then begin
      old := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      if v <> null then begin
        EditDataSet(Dokument);
        if lString
         then Dokument.FieldByName(strFieldName).AsString  := v
         else Dokument.FieldByName(strFieldName).AsInteger := v;
        Result:=true;
      end;
      Screen.Cursor := old;
    end;
  end;
end;
//----------------------------------------------------------------------------------
function TfmSimpleD.ChoiceFromAkt( nTypeAkt:Integer; var arrRec : TCurrentRecord; cont:TWinControl=nil ):Boolean;
var
  Opis : TOpisEdit;
  v : Variant;
//  old : TCursor;
  strNameOpis:String;
begin
  Result:=false;
  SetLength(arrRec,1);
  case nTypeAkt of
    _TypeObj_ZRogd  : strNameOpis:='LOOKUP_AKT_ROGD';
    _TypeObj_ZBrak  : strNameOpis:='LOOKUP_AKT_BRAK';
    _TypeObj_ZRast  : strNameOpis:='LOOKUP_AKT_RAST';
    _TypeObj_ZSmert : strNameOpis:='LOOKUP_AKT_SMERT';
    _TypeObj_ZUstOtc: strNameOpis:='LOOKUP_AKT_USTOTC';
    _TypeObj_ZUstMat: strNameOpis:='LOOKUP_AKT_USTMAT';
    _TypeObj_ZAdopt : strNameOpis:='LOOKUP_AKT_ADOPT';
    _TypeObj_ZChName: strNameOpis:='LOOKUP_AKT_CHNAME';
  end;
  v := null;
  Opis:=GlobalTask.CurrentOpisEdit.GetSprOpisA(strNameOpis);
  if Opis <> nil then begin
    if Opis.ChoiceFromSprEx(cont, v, arrRec, nil) and (v<>null) then begin
      Result:=true;
    end;
  end;
end;
//----------------------------------------------------------------------------------
procedure TfmSimpleD.ReadMessageID;
{$IFDEF GISUN}
var
  vKeyValues : Variant;
{$ENDIF}
begin
  MessageID:='';
{$IFDEF GISUN}
  if DokumentID.AsInteger>0 then begin
    vKeyValues := VarArrayCreate( [0, 2], varOleStr );
    vKeyValues[0] := FTypeObj;
    vKeyValues[1] := DokumentID.AsInteger;
    vKeyValues[2] := 1;
    if dmBase.MessageGisun.Locate('TYPEOBJ;ID;NOMER',vKeyvalues,[]) then begin
      MessageID := dmBase.MessageGisun.FieldByName('MESSAGEID').AsString;
    end;
  end;
{$ENDIF}
end;

procedure TfmSimpleD.WriteMessageID;
{$IFDEF GISUN}
var
  vKeyValues : Variant;
{$ENDIF}
begin
{$IFDEF GISUN}
  if (DokumentID.AsInteger>0) and (MessageID<>'') then begin
    vKeyValues := VarArrayCreate( [0, 2], varOleStr );
    vKeyValues[0] := FTypeObj;
    vKeyValues[1] := DokumentID.AsInteger;
    vKeyValues[2] := 1;
    if dmBase.MessageGisun.Locate('TYPEOBJ;ID;NOMER',vKeyvalues,[]) then begin
      dmBase.MessageGisun.Edit;
    end else begin
      dmBase.MessageGisun.Append;
      dmBase.MessageGisun.FieldByName('TYPEOBJ').AsInteger:=FTypeObj;
      dmBase.MessageGisun.FieldByName('ID').AsInteger:=DokumentID.AsInteger;
      dmBase.MessageGisun.FieldByName('NOMER').AsInteger:=1;
    end;
    dmBase.MessageGisun.FieldByName('MESSAGEID').AsString:=MessageID;
    dmBase.MessageGisun.Post;
  end;
{$ENDIF}
end;
//-----------------------------------------------
procedure TfmSimpleD.WriteDateIzm;
var
  fld:TField;
begin
 if (FMainTable<>nil) and FQueryExit then begin  // если были реальные изменения
   fld:=FMainTable.FindField('DATEIZM');
   if fld<>nil
     then fld.AsDateTime:=Date;
  end;
end;
//-----------------------------------------------
procedure TfmSimpleD.CheckCaretDokument(fldCheckEmpty,fldDokument: TField);
var
  s : String;
begin
  if fldCheckEmpty.AsString='' then begin
    s:=Trim(fldDokument.AsString);
    s:=StringReplace(s,chr(13),' ',[rfReplaceAll]);
    s:=StringReplace(s,chr(10),'',[rfReplaceAll]);
    fldDokument.AsString:=s;
  end;
end;
//------------------------------------------------------------------
procedure TfmSimpleD.CheckOtmenka_Load(edOtm,edOtm_ON,edOtm_ONA: TCustomDBEditEh;
       strField,strFieldON,strFieldONA: String; l1,l2 : TLabel; bt : TButton);
var
  i : Integer;
  ss,s1,s2 : String;
begin
  if GlobalTask.ParamAsBoolean('ALWAYS_RAZD')  then begin
    FCheckOtmetka:='';
    ss:=Trim(Dokument.FieldByName(strField).AsString);
    i:=Pos('#', ss);
//  if GlobalTask.ParamAsBoolean('ALWAYS_RAZD') or (i>0) then begin
    if (Length(ss)=0) or (i>0) then begin
      FCheckOtmetka:=strField+';'+strFieldON+';'+strFieldONA;
    end;
    if FCheckOtmetka<>'' then begin
      if bt<>nil then begin
        bt.Visible := false;
      end;
      edOtm.Visible:=false;
      edOtm_ONA.Visible:=true;
      edOtm_ON.Visible:=true;
      l1.Visible:=true;
      l2.Visible:=true;

      Dokument.CheckBrowseMode;
      Dokument.Edit;
      s1:=Trim(Copy(ss,1,i-1));
      s2:=Trim(Copy(ss,i+1,Length(ss)));
      s1:=StringReplace(s1,Chr(13),' ',[rfReplaceAll]);
      s2:=StringReplace(s2,Chr(13),' ',[rfReplaceAll]);
      s1:=StringReplace(s1,Chr(10),'',[rfReplaceAll]);
      s2:=StringReplace(s2,Chr(10),'',[rfReplaceAll]);

      Dokument.FieldByName(strFieldON).AsString   := Trim(s1);
      Dokument.FieldByName(strFieldONA).AsString  := Trim(s2);

      Dokument.Post;
    end;
//  end;
  end;
end;
//------------------------------------------------------------------
procedure TfmSimpleD.CheckOtmenka_Save;
var
  arr : TArrStrings;
begin
  if FCheckOtmetka<>'' then begin
    StrToArr(FCheckOtmetka,arr,';',false);
    Dokument.FieldByName(arr[0]).AsString:=Dokument.FieldByName(arr[1]).AsString+Chr(13)+Chr(10)+'#'+
                                           Dokument.FieldByName(arr[2]).AsString;
  end;
end;
//------------------------------------------------------------------
procedure TfmSimpleD.WriteOTMETKA( strField, strOtm, strPol : String );
var
  i : Integer;
  ss,s1,s2 : String;
  arr : TArrStrings;
begin
  if FCheckOtmetka<>'' then begin // раздельный ввод для мужщины и женщины
    StrToArr(FCheckOtmetka,arr,';',false);
    ss:=Trim(strOtm);
    ss:=StringReplace(ss,Chr(13),' ',[rfReplaceAll]);
    ss:=StringReplace(ss,Chr(10),'',[rfReplaceAll]);
    if strPol='' then begin
      i:=Pos('#', ss);
      if (i>0) then begin
        s1:=Trim(Copy(ss,1,i-1));
        s2:=Trim(Copy(ss,i+1,Length(ss)));
        s1:=StringReplace(s1,Chr(13),' ',[rfReplaceAll]);
        s2:=StringReplace(s2,Chr(13),' ',[rfReplaceAll]);
        s1:=StringReplace(s1,Chr(10),'',[rfReplaceAll]);
        s2:=StringReplace(s2,Chr(10),'',[rfReplaceAll]);
        Dokument.FieldByName(arr[0]).AsString := ss;
        Dokument.FieldByName(arr[1]).AsString := Trim(s1);
        Dokument.FieldByName(arr[2]).AsString := Trim(s2);
      end;
    end else begin
      if strPol='М' then begin
        Dokument.FieldByName(arr[1]).AsString := ss;
      end else begin
        Dokument.FieldByName(arr[2]).AsString := ss;
      end;
    end;
  end else begin
    if strPol='' then begin
      Dokument.FieldByName(strField).AsString := strOtm;
    end else begin
      if Dokument.FieldByName(strField).AsString<>'' then begin
        Dokument.FieldByName(strField).AsString := Dokument.FieldByName(strField).AsString+Chr(13)+Chr(10)+strOtm;
      end else begin
        Dokument.FieldByName(strField).AsString := strOtm;
      end;
    end;
  end;
end;

procedure TfmSimpleD.DokumentBeforePost(DataSet: TDataSet);
begin
  if not IsReadDokument then
    CheckOtmenka_Save;
end;

procedure TfmSimpleD.ActiveControlChanged(Sender: TObject);
var
  i:Integer;
  lEnabled : Boolean;
  kb:LongWord;
//  s:String;
begin
  if (Screen.ActiveForm is TfmParamQuest) and (Screen.ActiveForm.ActiveControl<>nil) then begin
    kb:=GetTypeKeyBoard;
    if Pos('BLR_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
      if kb<>BLR_LCID then ActivateBLRKeyboard;
    end else if Pos('ENG_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
      if kb<>ENG_LCID then ActivateENGKeyboard;
    end else if Pos('RUS_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
      if kb<>ENG_LCID then ActivateRUSKeyboard;
    end;
    exit;
  end;
  if (Screen.ActiveForm is TfmSimpleD) and (Screen.ActiveForm.ActiveControl<>nil) then begin
    if Pos('ON_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
      FActiveON:=true;
    end;
    if Pos('ONA_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
      FActiveON:=false;
    end;
    if FCheckKeyboard then begin
      kb:=GetTypeKeyBoard;
      if Pos('BLR_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
        if kb<>BLR_LCID then ActivateBLRKeyboard;
      end else if Pos('ENG_',Screen.ActiveForm.ActiveControl.Name)>0 then begin
        if kb<>ENG_LCID then ActivateENGKeyboard;
      end else begin
        if (cbBel=nil) then begin
          if kb<>RUS_LCID then ActivateRUSKeyboard;
        end else begin
          if not cbBel.Checked
            then if kb<>RUS_LCID
              then ActivateRUSKeyboard;
        end;
      end;
    end;

    if Pos('ON_',Screen.ActiveForm.ActiveControl.Name)>0 then FActiveControlON:=true else FActiveControlON:=false;

    if (slGrid<>nil) then begin
      if (ActiveControl is TDbGridEh) then begin
        if slGrid.IndexOfObject(ActiveControl)>-1 then begin
          TBItemDelList.Enabled:=true;
//          if TDbGridEh(ActiveControl).EditorMode then begin
//            TBItemAddList.Enabled:=false;
  //        end else begin
          TBItemAddList.Enabled:=true;
//          end;
        end else begin
          TBItemDelList.Enabled:=false;
          TBItemAddList.Enabled:=false;
        end;
      end else begin
        TBItemDelList.Enabled:=false;
        TBItemAddList.Enabled:=false;
      end;
    end;

    if (ActiveControl is TDbMemo) or (ActiveControl is TDbEditEh) or (ActiveControl is TDBLookupComboboxEh) then begin
//      if (ActiveControl is TDbEditEh) and TDbEditEh(ActiveControl).Field.FieldName='IDENTIF' then begin
//
//      end;
      lEnabled := false;
      if (ActiveControl is TDbMemo)  then begin
        for i:=0 to Length(FArrChoiceRekv)-1 do begin
          if FArrChoiceRekv[i].FieldName = ANSIUpperCase(TDbMemo(ActiveControl).Field.FieldName) then begin
            lEnabled := true;
            break;
          end;
        end;
      end else begin
        if TDbEditEh(ActiveControl).Field.FieldName='NAME_ZAGS' then begin
          lEnabled := true;
        end else begin
          for i:=0 to Length(FArrChoiceRekv)-1 do begin
            if FArrChoiceRekv[i].FieldName = ANSIUpperCase(TDbEditEh(ActiveControl).Field.FieldName) then begin
              lEnabled := true;
              break;
            end;
          end;
        end;
      end;
      TBItemShablon.Enabled := lEnabled;
      if ((ActiveControl is TDbEditEh) and Assigned(TDbEditEh(ActiveControl).OnDblClick)) or
         ((ActiveControl is TDbMemo) and Assigned(TDbMemo(ActiveControl).OnDblClick)) then begin
        TBItemEditmemo.Enabled:=true;
      end else begin
        TBItemEditmemo.Enabled:=false;
      end;
    //--------- для ГРИДА пока так  ------------------------------
    end else if (ActiveControl is TDbGridEh) then begin
    {
      s:=TDBGridEh(ActiveControl).SelectedField.FieldName;
      if (s='NAME_ZAGS') or (s='ZAGS_NAME') then begin
        TBItemShablon.Enabled:=true;
      end else begin
        TBItemShablon.Enabled:=false;
      end;
      }
    end else begin
      TBItemShablon.Enabled:=false;
      TBItemEditmemo.Enabled:=false;
    end;

  end;
end;

//---------------------------------------------------------------------------------
function TfmSimpleD.CheckFieldDate(fld:TField; nMinYear:Integer; nMaxYear:Integer; lYesNull:Boolean; sType:String; fld2:TField):String;
var
  nYear:Word;
  sDate:String;
begin
  Result:='';
  if fld.IsNull and not lYesNull  then begin
    Result:='пустое значение';
    exit;
  end;
  if not fld.IsNull then begin
    nYear:=YearOf(fld.AsDateTime);
    if (nMinYear>-1) and (nYear<nMinYear) then begin
      Result:='год "'+IntToStr(nYear)+'" меньше "'+IntToStr(nMinYear);
    end;
    if (nMaxYear>-1) and (nYear>nMaxYear) then begin
      Result:='год "'+IntToStr(nYear)+'" больше "'+IntToStr(nMaxYear);
    end;
    if (Result='') and (fld2<>nil) and (sType<>'') then begin
      if not fld2.IsNull then begin
        sDate:='"'+DatePropis(fld2.AsDateTime,3)+'"';
        if sType='<' then begin
          if fld.AsDateTime<fld2.AsDateTime then Result:='должна быть больше или равна '+sDate;
        end else if sType='<=' then begin
          if fld.AsDateTime<fld2.AsDateTime then Result:='должна быть больше '+sDate;
        end else if sType='>'  then begin
          if fld.AsDateTime<fld2.AsDateTime then Result:='должна быть меньше или равна '+sDate;
        end else if sType='>=' then begin
          if fld.AsDateTime<fld2.AsDateTime then Result:='должна быть меньше '+sDate;
        end else if sType='='  then begin
          if fld.AsDateTime<fld2.AsDateTime then Result:='должна быть равна '+sDate;
        end;
      end;
    end;
  end;
end;

//---------------------------------------------------------------------------------
//  nType=1   рождение
//  nType=2   смерть
//  nType=3   дата заявления
procedure TfmSimpleD.CheckValueDateZAGS(DateCheck:Variant; edDate : TDbDateTimeEditEh; nType : Integer; dDateB:TDateTime; dDateE:TDateTime);
var
  d,dz : TDateTime;
  lErr : Boolean;
  n : Integer;
  nYear, nMonth, nDay : Integer;
//  fld:TField;
begin
  if (edDate.Color=COLOR_HIST) or (edDate.Color=GetDisableColorGIS) then exit;

  if VarIsNull(DateCheck) or VarIsEmpty(DateCheck) or (VarToDateTime(DateCheck)=0) then begin
    edDate.Color:=clWindow;
    exit;
  end;
  lErr := false;
  d:=0;
  try
    d:=DateCheck;
  except
    lErr := true;
  end;
  if not lErr then begin
    if (YearOf(d)<GetMinYear) or (YearOf(d)>GetMaxYear) then begin
      Beep;
      edDate.Color:=colorError;
      lErr:=true;
    end;
    if not lErr and (d>0) then begin
      case nType of
        22: if (dDateB>0) and (d<dDateB) then lErr:=true;  // дата захоронения
        3 : if d>Date then lErr:=true;                //   дата заявления
      end;
      if lErr then begin
        Beep;
        edDate.Color:=colorError;
        lErr:=true;
      end;  
    end;
    if not lErr then begin
      if not IsAktVosstan and not Dokument.FieldByName('DATEZ').IsNull then begin
        dz:=Dokument.FieldByName('DATEZ').AsDateTime;
        //-----------------------
        if (nType=1) then begin //  дата рождения ребенка
          SubDate(dz, d, nYear, nMonth, nDay);
          if (Abs(nYear)<>0) or (Abs(nMonth)>2) or (d>dz) then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end;
        //-----------------------
        end else if (nType=11) then begin  //   мама ребенка
          n:=GetCountYear( dz, d);
          if (n<10) or (n>60) then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end;
          if not lErr then begin
            if (n<16) or (n>50) then begin
              Beep;
              edDate.Color:=colorWarning;
              lErr:=true;
            end;
          end;
        end else if (nType=12) then begin  //   папа ребенка
          n:=GetCountYear( dz, d);
          if (n<10) or (n>70) then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end;
          if not lErr then begin
            if (n<16) or (n>60) then begin
              Beep;
              edDate.Color:=colorWarning;
              lErr:=true;
            end;
          end;
        //-----------------------
        end else if nType=14 then begin  //  браки и расторжение брака
          n:=GetCountYear( dz, d);
          if (n<14) or (n>100) then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end;
          if not lErr then begin
            if (n<16) or (n>80) then begin
              Beep;
              edDate.Color:=colorWarning;
              lErr:=true;
            end;
          end;
        //-----------------------
        end else if nType=13 then begin  //  просто возраст
          n:=GetCountYear( dz, d);
          if (n<0) or (n>120) then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end;
          if not lErr then begin
            if (n<0) or (n>100) then begin
              Beep;
              edDate.Color:=colorWarning;
              lErr:=true;
            end;
          end;
        //-----------------------
        end else if (nType=2) then begin  // для даты смерти
          edDate.Hint:='';
          if d>dmBase.getCurDate then begin
            Beep;
            edDate.Color:=colorError;
            lErr:=true;
          end else begin
            SubDate(dz, d, nYear, nMonth, nDay);
            if (nYear>0) or (nMonth>0) or (nDay>7) then begin
              Beep;
              edDate.Color:=colorWarning;
              edDate.Hint:='Требуется письменное заявление';
              lErr:=true;
            end;
          end;
        end;
      end;
    end;
  end;
  if not lErr and (edDate.Color<>clWindow) then begin
    edDate.Color:=clWindow;
  end;
end;

//-----------------------------------------------------------------------------------------------------
procedure TfmSimpleD.CheckValueInteger(nBigMin,nMin,nMax,nBigMax:Integer; edValue : TDbNumberEditEh; nType : Integer);
var
  lErr : Boolean;
  n : Integer;
//  fld:TField;
begin
  if edValue.Color=COLOR_HIST then exit;

  if VarIsNull(edValue.Value) then begin
    edValue.Color:=clWindow;
    exit;
  end;
  n:=edValue.Value;
  lErr := false;
  if (n<nBigMin) or (n>nBigMax) then begin
    edValue.Color:=colorError;
    lErr:=true;
  end else if (n<nMin) or (n>nMax) then begin
    edValue.Color:=colorWarning;
    lErr:=true;
  end;
  if not lErr and (edValue.Color<>clWindow) then begin
    edValue.Color:=clWindow;
  end;
end;

//------------------------------------------------------------------------------
// анулирование актовой записи
//------------------------------------------------------------------------------
//'Вы хотите отменить аннулирование актовой записи ?'
function TfmSimpleD.EnterDate(fld:TField; strCaption,strQuest:String):Boolean;
var
  fmParam:TfmParamQuest;
  n:Integer;
begin
  Result:=false;
  if fld.IsNull then begin
    fmParam:=TfmParamQuest.Create(Self);
    fmParam.Caption:='Введите значение';
    fmParam.AddParamEx(dmBase.getCurDate, strCaption, 'DATE1' ,'TYPE=DATE');
    fmParam.AddButtons('Записать~Отказ',0);
    n:=fmParam.ShowQuest;
    if n=1 then begin
      Result:=true;
      EditDataSet(fld.DataSet);
      fld.AsDateTime:=fmParam.GetValue('DATE1', 'D');
    end;
    fmParam.Free;
  end else begin
    if Problem(strQuest,mtConfirmation,Self) then begin
      Result:=true;
      EditDataSet(fld.DataSet);
      fld.AsString:='';
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmSimpleD.AddSubmenu_ReadDolg;
var
 it : TTbItem;
begin
  it := TTbItem.Create(TBSubmenuRun);
  it.Caption:='Обновить должности из параметров';
  it.OnClick:=Event_ReadDolg;
  TBSubmenuRun.Add(it);
end;
procedure TfmSimpleD.Event_ReadDolg(Sender: TObject);
begin
  if Problem('Обновить должности руководителя и специалиста из параметров ?',mtConfirmation, Self) then begin
    EditDataSet(Dokument);
    DokumentRUKOV_D.AsString:=GlobalTask.ParamAsString('DOLG_RUK_ZAGS');
    DokumentSPEC_D.AsString:=GlobalTask.ParamAsString('DOLG_SPEC');
    PostDataSet(Dokument);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmSimpleD.AddSubmenu_ParCopy;
begin
  ItParCopy:=TTbItem.Create(TBSubmenuRun);
  ItParCopy.Caption:='Печать в копии руководителя районного ЗАГС';
  ItParCopy.OnClick:=Event_ParCopy;
  TBSubmenuRun.Add(ItParCopy);
end;
procedure TfmSimpleD.Event_ParCopy(Sender: TObject);
var
  n:Integer;
begin
  ItParCopy.Checked:=not ItParCopy.Checked;
  if ItParCopy.Checked then n:=1 else n:=0;
  GlobalTask.SetLastValueAsInteger('COPY_ZAGS_RUK_RN', n)
end;
//------------------------------------------------------------------------------------------
function TfmSimpleD.CreateSubmenuRun:Boolean;
//var
// it : TTbItem;
// sep : TTbSeparatorItem;
begin
  Result:=true;
//  it := TTbItem.Create(TBSubmenuRun);
//  it.Caption:='Загрузить последний добавленный документ';
//  it.OnClick:=;
//  TBSubmenuRun.Add(it);
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.TBItemAddLastDokClick(Sender: TObject);
begin
  Event_ReadLastAddDok(Sender);
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.NotStdSubmenuRun;
begin
  TBItemAddLastDok.Visible:=false;
  TBSeparatorItem.Visible:=false;
  TBItemCkeckRegistr.Visible:=false;
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.CreateButtonAddGrag(ed:TDbLookupComboboxEh);
var
  bt : TEditButtonEh;
begin
  bt:=ed.EditButtons.Add;
  bt.OnClick := Event_GRAGEditButtonsClick;
  bt.Visible := true;
  bt.Style   := ebsPlusEh;
  bt.Hint:='Дополнительное гражданство  (Ins)';
  bt.ShortCut:=TextToShortCut('Ins');
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.Event_GRAGEditButtonsClick(Sender: TObject; var Handled: Boolean);
var
  ed:TDbLookupComboboxEh;
begin
  ed:=TDbLookupComboboxEh(TEditButtonControlEh(sender).Owner);
  EditAddGrag(ed);
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.EditAddGrag(ed:TDbLookupComboboxEh);
var
  sValue,sField:String;
  slPar:TStringList;
  ds:TDataSet;
begin
  sField:=ed.Field.FieldName+'_ADD';   // ON_GRAG -> ON_GRAG_ADD
  ds:=ed.Field.DataSet;
  slPar:=TStringList.Create;
  slPar.Add('CAPTION=Дополнительное гражданство');
  slPar.Add('ONLY_SHABLON=1');
  slPar.Add('SHABLON='+IntToStr(SHABLON_ADD_GRAG));
  sValue:=ds.FieldByName(sField).AsString; //  DokumentON_GRAG_ADD.AsString;
  {$IFDEF HUNSPELL}
     sValue:=EnterAdresatHS(Self.Left+20,Self.Top+70,sValue,slPar);
  {$ELSE}
     sValue:=EnterAdresat(Self.Left+20,Self.Top+70,sValue,slPar);
  {$ENDIF}
  slPar.Free;
  //sValue := Trim(InputBox('ОН', 'Дополнительное гражданство', DokumentON_GRAG_ADD.AsString));
  EditDataSet(ds);
  ds.FieldByName(sField).AsString:=sValue;
  ed.Hint:=sValue;
end;

//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.Event_Annulir(Sender: TObject);
var
 s:String;
begin
  if EnterDate(DokumentDATE_ANUL, 'Дата аннулирования','Вы хотите отменить аннулирование актовой записи ?') then begin
    EditDataSet(lbAnnulir.Field.DataSet);
    pnAdd.Visible:=CheckAddPanel(s);
    lbAnnulir.Field.AsString:=lbAnnulir.Field.AsString;
  end;
end;

//----------------------------------------------------------------------------------------------------------
function TfmSimpleD.CheckAddPanel(var Text : String):Boolean;
var
  fld:TField;
begin
  if DokumentDATE_ANUL.IsNull then begin
    Result:=false;
    Text:='';
  end else begin
    Result:=true;
    Text:='Аннулирована '+FormatDateTime('dd.mm.yyyy', DokumentDATE_ANUL.AsDateTime);
  end;
  if FTypeObj=_TypeObj_ZRogd then begin
    fld:=Dokument.FindField('SVIDNOT');
    if fld<>nil then begin
      if fld.AsBoolean then begin
        Text:=Trim(Text +' Свидетельство не выдавать! ');
        Result:=true;
      end;
    end;
    fld:=Dokument.FindField('DATES');
    if fld<>nil then begin
      if not fld.IsNull then begin
        Text:=Trim(Text +' Дата смерти '+FormatDateTime('dd.mm.yyyy', fld.AsDateTime));
        Result:=true;
      end;
    end;
    fld:=Dokument.FindField('ON_DATE_LR');
    if (fld<>nil) and not fld.IsNull then begin
      Text:=Trim(Text +' Отец лишен родительских прав');
      Result:=true;
    end;
    fld:=Dokument.FindField('ONA_DATE_LR');
    if (fld<>nil) and not fld.IsNull then begin
      Text:=Trim(Text +' Мать лишена родительских прав');
      Result:=true;
    end;
  end else if (FTypeObj=_TypeObj_DBrak) or (FTypeObj=_TypeObj_DRast) then begin
    fld:=Dokument.FindField('OTKAZ');
    if fld<>nil then begin
      if not fld.IsNull and fld.AsBoolean then begin
        Text:=Trim(Text +' Отказ от регистрации');
        Result:=true;
      end;
    end;
  end else if (FTypeObj=_TypeObj_Opeka) then begin
    if tbReshSud.RecordCount>0 then begin
      Text:=Trim(Text +' ВНИМАНИЕ: есть решения суда!');
      Result:=true;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.SaveID;
begin
  curID:=DokumentID.AsInteger;
  if FDokZags then begin
    curSource:=Dokument.FieldByName('ID_SOURCE').AsInteger;
    curZags:=Dokument.FieldByName('ID_ZAGS').AsInteger;
    curNomer:=Dokument.FieldByName('NOMER').AsString;
    curSeria:=Dokument.FieldByName('SVID_SERIA').AsString;
    curNSeria:=Dokument.FieldByName('SVID_NOMER').AsString;
    curDateZ:=Dokument.FieldByName('DATESV').AsDateTime;
    curDolgR:=DokumentRUKOV_D.AsString;
    curDolgS:=DokumentSPEC_D.AsString;
  end;
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.RestID;
begin
  DokumentID.AsInteger:=curID;
  if FDokZags then begin
    Dokument.FieldByName('ID_SOURCE').AsInteger:=curSource;
    Dokument.FieldByName('ID_ZAGS').AsInteger:=curZags;
    Dokument.FieldByName('NOMER').AsString:=curNomer;
    Dokument.FieldByName('SVID_SERIA').AsString:=curSeria;
    Dokument.FieldByName('SVID_NOMER').AsString:=curNSeria;
    if curDateZ<=0
      then Dokument.FieldByName('DATESV').AsString:=''
      else Dokument.FieldByName('DATESV').AsDateTime:=curDateZ;
    DokumentRUKOV_D.AsString:=curDolgR;
    DokumentSPEC_D.AsString:=curDolgS;
  end;
end;
//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.lbAnnulirGetText(Sender: TObject; var Text: String);
begin
  pnAdd.Visible:=CheckAddPanel(Text);
end;

//----------------------------------------------------------------------------------------------------------
procedure TfmSimpleD.SetFieldAddPanel(strField: String);
begin
  lbAnnulir.DataField:=strField;
end;

procedure TfmSimpleD.PostDokument;
begin
  Dokument.CheckBrowseMode;
end;

procedure TfmSimpleD.EditDokument;
begin
  EditDataSet(Dokument);
end;

procedure TfmSimpleD.CheckAsNew;
begin
  EditDataSet(Dokument);
  DokumentID.AsInteger:=-1;
  Dokument.Post;
end;

procedure TfmSimpleD.TBSubmenuTmpClick(Sender: TObject);
begin
  PostDokument;
  Beep;
end;

procedure TfmSimpleD.TBItemEditMemoClick(Sender: TObject);
var
  ed  : TDbEditEh;
  ed2 : TDbMemo;
  sValue,s,ss : String;
  n:Integer;
  t:TTypeEditMemo;
  slPar:TStringList;
  sField:String;
begin
  ed2:= nil;
  ed := nil;
  if (ActiveControl is TDBEditEh) then begin
    ed := TDbEditEh(ActiveControl);
    sField:=ed.Field.FieldName;
    sValue := ed.Text;
  end else if  (ActiveControl is TDbMemo) then begin
    ed2:= TDbMemo(ActiveControl);
    sField:=ed2.Field.FieldName;
    sValue := ed2.Text;
  end;
  n:=FindChoiceRekv(sField);
  if n>-1 then begin
    t:=FArrChoiceRekv[n].TypeEdit;
  end else begin
    t:=emSimple;
  end;
//  s:='!!!';
  s:='';
  if (ed<>nil) then begin
    if Assigned(ed.OnDblClick) then begin
      if t=emSimple then begin
        {$IFDEF HUNSPELL}
        if TBItemEditMemo.Tag=3 then begin
          if TypeObj=_TypeObj_ZBrak then begin
            ss:='Значение;Жених;Невеста';
          end else if TypeObj=_TypeObj_ZRast then begin
            ss:='Значение;Он;Она';
          end else begin
            ss:='Значение;Отец;Мать';
          end;
          if EditMemoHS3(sValue, ss, nil, ed.Width+50) then s := sValue;
        end else begin
          if EditMemoHS(sValue, 'Значение', ed, ed.Width+50) then s := sValue;
        end;
        {$ELSE}
        if EditMemo(sValue, 'Значение', ed, ed.Width+50) then s := sValue;
        {$ENDIF}
      end else begin
        slPar:=TStringList.Create;
        if AddParEnterAdresat(slPar, ed.Field.FieldName) then begin
        {$IFDEF HUNSPELL}
          s:=EnterAdresatHS(Self.Left+20,Self.Top+70,sValue,slPar);
        {$ELSE}
          s:=EnterAdresat(Self.Left+20,Self.Top+70,sValue,slPar);
        {$ENDIF}
        end;
        FreeAndNil(slPar);
      end;
      if s<>'' then begin
        EditDataSet(ed.DataSource.DataSet);
        ed.Field.AsString:=s;
      end;
    end;
  end;

  if (ed2<>nil) then begin
    if Assigned(ed2.OnDblClick) then begin
      if t=emSimple then begin
        {$IFDEF HUNSPELL}
        if EditMemoHS(sValue, 'Значение', ed2, ed2.Width+50) then s := sValue;
        {$ELSE}
        if EditMemo(sValue, 'Значение', ed2, ed2.Width+50) then s := sValue;
        {$ENDIF}
      end else begin
        slPar:=TStringList.Create;
        if AddParEnterAdresat(slPar, sField) then begin
          {$IFDEF HUNSPELL}
            s:=EnterAdresatHS(Self.Left+20,Self.Top+70,sValue,slPar);
          {$ELSE}
            s:=EnterAdresat(Self.Left+20,Self.Top+70,sValue,slPar);
          {$ENDIF}
        end;
        FreeAndNil(slPar);
      end;
      if s<>'' then begin
        EditDataSet(ed2.DataSource.DataSet);
        ed2.Field.AsString:=s;
      end;
    end;
  end;
end;

procedure TfmSimpleD.SetMRUList(ed: TDbEditEh; nLimit, nType: Integer; lAll, lReload, lBel: Boolean;lAddButton:Boolean; lPunktFromSpr:Boolean);
var
  bt : TEditButtonEh;
begin
  if (nType=3) and lPunktFromSpr then begin  // загружать населенные путкты из спраочника нас. пунктов
    ed.MRUList.Items:=GetMRUName_Punkt(lBel,lReload);
  end else if (nType=4) then begin  //
    ed.MRUList.Items:=GetMRU_MKB10(false);
  end else begin
    ed.MRUList.Items:=GetMRUName(nType,lAll,lReload,lBel);
  end;
  if ed.MRUList.Items.Count>0 then begin
//    ed.OnChange:=DbEditMRUList_Change;
    ed.MRUList.Rows:=15;
    ed.MRUList.Active:=true;
    ed.MRUList.AutoAdd:=false;
    if nLimit>0 then  ed.MRUList.Limit:=nLimit;
    if lAddButton then begin
      if ed.EditButtons.Count=0 then begin
        bt := ed.EditButtons.Add;
      end else begin
        bt := ed.EditButtons[0];
      end;
      bt.OnClick := MRUListOpen;
      bt.Visible := true;
    end else begin
    end;
  end;
end;

//--------------------------------------------------------------------------
procedure TfmSimpleD.DbEditMRUList_Change(Sender: TObject);
{
  procedure KillMessage(Wnd: HWnd; Msg: Integer);
  // Delete the requested message from the queue, but throw back any WM_QUIT msgs that PeekMessage may also return
  var
    M: TMsg;
  begin
    M.Message := 0;
    if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
      PostQuitMessage(M.wparam);
  end;
}
var
  s:String;
  ed:TDbEditEh;
begin
  ed:=TDbEditEh(Sender);
  if not FRun and ed.MRUList.DroppedDown then begin
    s:=ed.Text;
    ed.MRUList.FilterItemsTo(FFilterItems,s);
    if FFilterItems.count=1 then begin
      FRun := true;
//      ed.Text:=FFilterItems.Strings[0];
//      ed.SelStart:=Length(s)+1;
//      ed.SelLength:=Length(ed.Text)-ed.SelStart;
//      ed.

//    PostMessage(ed.Handle, WM_CHAR, VK_ESCAPE, 0);  сразу записывается значение

//      KillMessage(ed.Handle, WM_CHAR);
//      PostMessage(edOBL_Sv.Handle, WM_CLOSE_MRULIST, 0, 0);
//      edObl_Sv.MRUList.DropDown;
//      edObl_Sv.MRUList.CloseUp(true);
    end;
    FRun:=false;
  end;
end;

//--------------------------------------------------------------------------
procedure TfmSimpleD.MRUListOpen(Sender: TObject;  var Handled: Boolean);
begin
  if Sender is TDbEditEh then begin
    if not TDbEditEh(Sender).MRUList.DroppedDown
      then TDbEditEh(Sender).MRUList.DropDown
      else TDbEditEh(Sender).MRUList.CloseUp(false);
  end else begin
    if not TDbEditEh(TControl(Sender).Parent).MRUList.DroppedDown
      then TDbEditEh(TControl(Sender).Parent).MRUList.DropDown
      else TDbEditEh(TControl(Sender).Parent).MRUList.CloseUp(false);
  end;
end;

//----------------------------------------------------------------
function TfmSimpleD.GetLastAddDok:Integer;
var
  n:Integer;
begin
  Result:=-1;
  n:=ListLastAddObj.IndexOf(IntToStr(FTypeObj));
  if n>-1 then begin
    Result:=Integer(ListLastAddObj.Objects[n]);
  end;
end;
//----------------------------------------------------------------
procedure TfmSimpleD.SetLastAddDok(nId:Integer);
var
  n:Integer;
begin
  if FAddNewDok then begin   // только в режиме добавления нового документа
    n:=ListLastAddObj.IndexOf(IntToStr(FTypeObj));
    if n=-1 then begin
      ListLastAddObj.AddObject(IntToStr(FTypeObj), Pointer(nID));
    end else begin
      ListLastAddObj.Objects[n]:=Pointer(nID);
    end;
  end;
end;

//----------------------------------------------------------------------------------
procedure TfmSimpleD.CheckControlOnlyGod(lOnlyGod:Boolean; edDate:TDBDateTimeEditEh);
begin
  if lOnlyGod then begin
    edDATE.EditButton.Visible:=false;
    edDATE.EditFormat:='YYYY';
  end else begin
    edDATE.EditButton.Visible:=true;
    edDATE.EditFormat:='DD/MM/YYYY';
  end;
end;

//----------------------------------------------------------------------------------
procedure TfmSimpleD.CheckControlOnlyGod2(vOnlyGod: Variant;  edDate: TDBDateTimeEditEh);
var
  s:String;
begin
  if vOnlyGod=null
    then s:='0'
    else s:=VarTostr(vOnlyGod);
  if s='2' then begin  // год и месяц
    edDATE.EditButton.Visible:=false;
    edDATE.EditFormat:='MM.YYYY';
  end else if s='1' then begin
    edDATE.EditButton.Visible:=false;
    edDATE.EditFormat:='YYYY';
  end else begin
    edDATE.EditButton.Visible:=true;
    edDATE.EditFormat:='DD/MM/YYYY';
  end;
end;
                      
//----------------------------------------------------------------------------------
function TfmSimpleD.CheckDateOnlyGod(dDate:TDateTime; vOnlyGod: Variant):TDateTime;
var
  s:String;
begin
  if dDate=0 then begin
    Result:=0;
  end else begin
    if vOnlyGod=null
      then s:='0'
      else s:=VarTostr(vOnlyGod);
    if s='2' then begin  // год и месяц
      Result:=STOD(FormatDateTime('YYYYMM',dDate)+'01',tdClipper);
    end else if s='1' then begin
      Result:=STOD(FormatDateTime('YYYY',dDate)+'0701',tdClipper);
    end else begin
      Result:=dDate;
    end;
  end;
end;

//----------------------------------------------------------------
procedure TfmSimpleD.Event_ReadLastAddDok(Sender: TObject);
var
  nID,nCurID:Integer;
  dDate,dDateSv:TDateTime;
  nNomer:Integer;
  sSvidNomer,sSvidSeria:String;
  fld:TField;
begin
  if ExitAsGISUN(true) then exit;

  nCurID:=DokumentID.AsInteger;

  nID:=GetLastAddDok;
  if nID>-1 then begin
    if not QueryExit or Problem('Вы ходите загрузить последний добавленный документ ?',mtConfirmation,Self) then begin
       FRun:=true;
       try
         dDateSv:=0;
         sSvidSeria:='*';
         sSvidNomer:='*';
         fld:=Dokument.FindField('SVID_SERIA');
         if fld<>nil then sSvidSeria:=fld.AsString;
         fld:=Dokument.FindField('SVID_NOMER');
         if fld<>nil then sSvidNomer:=fld.AsString;
         fld:=Dokument.FindField('DATESV');
         if (fld<>nil) and not fld.IsNull then dDateSv:=fld.AsDateTime;

         dDate:=0;
         if Dokument.FindField('DATEZ')<>nil then begin
           if Dokument.FieldByName('DATEZ').Value<>null
             then dDate:=Dokument.FieldByName('DATEZ').AsDateTime;
         end;
         nNomer:=0;
         if Dokument.FindField('NOMER')<>nil
           then nNomer:=Dokument.FieldByName('NOMER').AsInteger;

         ReadDok(nID);
         Dokument.CheckBrowseMode;
         Dokument.Edit;

         fld:=Dokument.FindField('SVID_SERIA');
         if (fld<>nil) and (sSvidSeria<>'*') then fld.AsString:=sSvidSeria;
         fld:=Dokument.FindField('SVID_NOMER');
         if (fld<>nil) and (sSvidNomer<>'*') then fld.AsString:=sSvidNomer;
         fld:=Dokument.FindField('DATESV');
         if (fld<>nil) and (dDateSv>0) then fld.AsDateTime:=dDateSv;

         if dDate>0  then Dokument.FieldByName('DATEZ').AsDateTime:=dDate;
         if nNomer>0 then Dokument.FieldByName('NOMER').AsInteger:=nNomer;

         DokumentID.AsInteger:=nCurID;
         fld:=Dokument.FindField('POLE_GRN');
         if fld<>nil then fld.AsInteger:=0;

         fld:=Dokument.FindField('IDENTIF');
         if fld<>nil then fld.AsString:='';

         fld:=Dokument.FindField('MEN_ID');
         if fld<>nil then Dokument.FieldByName('MEN_ID').AsString:='';

         fld:=Dokument.FindField('CHILD_ID');
         if fld<>nil then Dokument.FieldByName('CHILD_ID').AsString:='';

         ReadLastAddDok;

         Dokument.Post;
       finally
         FRun:=false;
       end;
    end;
  end else begin
    PutError('В текущем сеансе работы документы не добавлялись.',self);
  end;
end;

{$IFDEF GISUN}

function TfmSimpleD.AfterCreateFormGISUN:Boolean;
begin
  Result:=true;
end;
function TfmSimpleD.BeforeEditFormGISUN:Boolean;
begin
  Result:=true;
end;

{$ENDIF}

function TfmSimpleD.CreateParamRegistr:TParRegGisun;
begin
  Result:=nil;
end;

//-------------------------------------------------------------------------------------
function TfmSimpleD.CheckAkt_GISUN(nType:Integer): Boolean;
begin
  Result:=true;
  {$IFDEF GISUN}

//    FImageGisun.Enable:=flase;
//    FSubmenuGISUN.Enabled:=false;
    Gisun.CurAkt:=Self;

    if FPoleGRN=nil then begin
      FPoleGRN:=Dokument.FindField('POLE_GRN');
    end;
    if Gisun.IsDebug and (FImageGISUN=nil) then begin
      PutError('не определен ImageGISUN');
    end;
    //--- рождения ------------------------
    if FTypeObj=dmBase.TypeObj_ZRogd then begin
      if Dokument.FieldByName('VOSSTAN').AsBoolean and (Self.Name='fmZapisRogdV') then begin
        Gisun.CheckAktV(Self);
      end else begin
        Gisun.CheckAkt(Self);
      end;
    end else if FTypeObj=dmBase.TypeObj_ZSmert then begin
      if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
        Gisun.CheckSmertV(Self);
      end else begin
        Gisun.CheckSmert(Self);
      end;
    end else if FTypeObj=_TypeObj_AktZAH then begin
      {$IFDEF ADD_ZAH}
      Gisun.CheckAktZAH(Self);
      {$ENDIF}
    end else if FTypeObj=dmBase.TypeObj_ZBrak then begin
      if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
        Gisun.CheckMarriageV(Self);
      end else begin
        Gisun.CheckMarriage(Self);
      end;
    end else if FTypeObj=dmBase.TypeObj_ZRast then begin
      Gisun.CheckRastBrak(Self);
    end else if FTypeObj=dmBase.TypeObj_ZUstOtc then begin
      Gisun.CheckUstOtc(Self);
    end else if FTypeObj=dmBase.TypeObj_ZUstMat then begin
      Gisun.CheckUstMat(Self);
    end else if FTypeObj=dmBase.TypeObj_ZChName then begin
      Gisun.CheckChName(Self);
    end else if FTypeObj=dmBase.TypeObj_ZAdopt then begin
      Gisun.CheckAdopt(Self);
    end;
    if FImageGISUN<>nil then begin
      CheckImageGisun(FPoleGRN,FImageGISUN);
    end;
    CheckHistory;
    AfterCheckAkt_GISUN(nType);  // в з/а о смерти есть действие
    Gisun.CurAkt:=nil;
  {$ENDIF}
end;

//-------------------------------------------------------------------------------------
procedure TfmSimpleD.ReadLastAddDok;
begin
//  дописать про необходимости в потомках
end;

//-------------------------------------------------------------------------------------
procedure TfmSimpleD.AfterCheckAkt_GISUN(nType:Integer);
begin
//  дописать про необходимости в потомках
end;

//-------------------------------------------------------------------------------------
function TfmSimpleD.GetAddPROP(sProp:String):Variant;
begin
  Result:='';
end;

//-------------------------------------------------------------------------------
function TfmSimpleD.IsSvidToGISUN(lQuery:Boolean) : Boolean;   // регистрировать свидетельство в регистре
begin
  Result:=true;
{$IFDEF GISUN}
  if DokumentPOVTOR.AsBoolean and lQuery then begin
    if (FPoleGRN=nil) or GisunOk(FPoleGRN)  // если ранее регистрировали
      then Result:=Problem('Отправить данные повторного свидетельства в ГИС РН ?', mtConfirmation, self);
  end;
// было до 11.05.2017
//    if (TypeObj=_TypeObj_ZUstOtc) or (TypeObj=_TypeObj_ZUstMat) or (TypeObj=_TypeObj_ZRast)
//      then Result:=false;
//  end;
{$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmSimpleD.Check_NotRequired;
{$IFDEF GISUN}
var
  n:Integer;
{$ENDIF}
begin
{$IFDEF GISUN}
  if FRegisterNotRequired and (itNotRequired<>nil) then begin
    if FPoleGRN=nil then FPoleGRN:=Dokument.FindField('POLE_GRN');
    n:=Gisun.GetPoleGrn(FPoleGRN);
    if n=rPost then begin
      itNotRequired.Checked:=false;
      itNotRequired.Enabled:=false;    // уже отправили в регистр
    end else begin
      itNotRequired.Checked:=(n=rNotRequired);
      itNotRequired.Enabled:=true;
    end;
  end;
{$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmSimpleD.AddSubmenu_NotRequired;
begin
{$IFDEF GISUN}
  if FRegisterNotRequired then begin
    itNotRequired := TTbItem.Create(TBSubmenuRun);
    itNotRequired.Caption:= 'Отказаться от отправки в ГИС РН';
    itNotRequired.OnClick:=Event_SetNotRequired;
    TBSubmenuRun.Add(itNotRequired);
  end;
{$ENDIF}
end;
procedure TfmSimpleD.Event_SetNotRequired(Sender: TObject);
begin
{$IFDEF GISUN}
  if FRegisterNotRequired and FEnableWrite then begin
    if FPoleGRN=nil then FPoleGRN:=Dokument.FindField('POLE_GRN');
    EditDataSet(Dokument);
    if Gisun.GetPoleGrn(FPoleGRN)=rNotRequired then begin
      if Problem('Необходимо отправлять данные в ГИС РН ?', mtConfirmation, self) then begin
        Gisun.SetPoleGrn(FPOLEGRN, 0, 0);
        itNotRequired.Checked:=false;
      end;
    end else begin
      if Gisun.GetPoleGrn(FPoleGRN)<>rPost then begin
        if Problem('Отказаться от отправки в ГИС РН ?', mtConfirmation, self) then begin
          Gisun.SetPoleGrn(FPOLEGRN, 1, 0);
          itNotRequired.Checked:=true;
        end;
      end else begin
//        PutError('Данные уже отправлены в ГИС РН', self);
      end;
    end;
    CheckImageGisun(FPoleGRN,FImageGisun);
    PostDataSet(Dokument);
  end;
{$ENDIF}
end;

//------ ЗАПРОС ДАННЫХ ИЗ РЕГИСТРА -------------------------------------------------------------------------------
// nType=0  при вводе, открыта форма ввода
// nType=1  при запросе из реестра
function TfmSimpleD.GetDataFrom_GISUN(nType:Integer): Boolean;
var
  cur : TCursor;
  n:Integer;
  lOk,l:Boolean;
begin
  Result:=true;
  cur:=Screen.Cursor;
  Dokument.CheckBrowseMode;
  Screen.Cursor:=crHourGlass;
  try
  {$IFDEF GISUN}     
    Gisun.CurAkt:=Self;
    if FPoleGRN=nil then begin
      FPoleGRN:=Dokument.FindField('POLE_GRN');
    end;
    if Gisun.IsDebug and (FImageGISUN=nil) then begin
      PutError('не определен ImageGISUN');
    end;
    n:=Gisun.GetPoleGrn(Dokument);
    lOk:=true;
    if (n=rPost) then begin //and (FTypeObj<>_TypeObj_ZRogd) then begin
      //Gisun.ShowMessageErr(strErr:String);  !!!
      PutError('Нельзя запросить данные для зарегистрированной записи.',self);
      lOk:=false;
    end else if n=rResponse then begin
      //Gisun.ShowMessageErr(strErr:String);  !!!
      if not Problem('Запрос данных уже осуществлялся.'+#13+'Повторить ?',mtConfirmation,Self) then begin
        lOk:=false;
      end;
    end;
    if lOk then begin
      l:=dbDisableControls(Dokument);
      //--- рождения ------------------------
      if FTypeObj=dmBase.TypeObj_ZRogd then begin
        if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
          if GetInfoGISUNR(Self) then begin
            Gisun.GetIdentifChildV(Self);
            QueryExit:=true;
          end;
        end else begin
          if GetInfoGISUNR(Self) then begin
            Gisun.GetIdentifChild(Self);
            QueryExit:=true;
          end;
        end;
      end else if FTypeObj=dmBase.TypeObj_ZSmert then begin
        if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
          Gisun.GetSmertV(Self);
          QueryExit:=true;
        end else begin
          if GetInfoGISUN1(Self,'','DECL_IN') then begin
            Gisun.GetSmert(Self);
            QueryExit:=true;
          end;
        end;
      end else if FTypeObj=_TypeObj_AktZAH then begin
        {$IFDEF ADD_ZAH}
        // можно реализовать запрос данных для заявителя
        if GetInfoGISUN1(Self,'','DECL_IN') then begin
//        if GetInfoGISUN1(Self,'','') then begin
          Gisun.GetAktZAH(Self);
          QueryExit:=true;
        end;
        {$ENDIF}
      end else if FTypeObj=_TypeObj_Opeka then begin
        {$IFDEF ADD_OPEKA}
        if GetInfoGISUN(Self) then begin
          Gisun.GetAktOpeka(Self);
          QueryExit:=true;
        end;
        {$ENDIF}
      end else if FTypeObj=dmBase.TypeObj_ZBrak then begin
        if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
          Gisun.GetMarriageV(Self);
          QueryExit:=true;
        end else begin
          if GetInfoGISUN2(Self) then begin
            Gisun.GetMarriage(Self);
            QueryExit:=true;
          end;
        end;
      end else if FTypeObj=dmBase.TypeObj_ZRast then begin
        if GetInfoGISUN2(Self) then begin
          Gisun.GetRastBrak(Self);
          QueryExit:=true;
        end;
      end else if FTypeObj=dmBase.TypeObj_ZUstOtc then begin
        if GetInfoGISUNR(Self) then begin
          Gisun.GetUstOtc(self);
          QueryExit:=true;
        end;
      end else if FTypeObj=dmBase.TypeObj_ZUstMat then begin
        Gisun.GetUstMat(self);
        QueryExit:=true;
      end else if FTypeObj=dmBase.TypeObj_ZChName then begin
        if GetInfoGISUN1(Self,'','') then begin
          Gisun.GetChName(Self);
          QueryExit:=true;
        end;
      end else if FTypeObj=dmBase.TypeObj_ZAdopt then begin
        if GetInfoGISUN(Self) then begin
          Gisun.GetAdopt(Self);
          QueryExit:=true;
        end;
      end;
      CheckAkt_GISUN(GISUN_GET);
      dbEnableControls(Dokument,l);
    end;
    Gisun.CurAkt:=nil;
  {$ENDIF}
  finally
    Screen.Cursor:=cur;
  end;
end;

//------ РЕГИСТРАЦИЯ -------------------------------------------------------------------------------
// nType=0 с предварительной записью документа
// nType=1 без предварительной записи документа
function TfmSimpleD.RegisterAkt_GISUN(nType:Integer; Par:TParRegGISUN): Boolean;
var
  cur : TCursor;
  lNotSvid,lOk,lCheck,lEmptyPrSmert,lSeek:Boolean;
  n:Integer;
begin
  Result:=false;
  cur:=Screen.Cursor;
  Dokument.CheckBrowseMode;
  if SvidPovtor.Active then begin
    SvidPovtor.CheckBrowseMode;
    SvidPovtor.Last;
  end;
  Screen.Cursor:=crHourGlass;
  lOk:=true;
  try
    {$IFDEF GISUN}
      if IsSvidToGISUN(true) then begin
//        PutError('Для данного повторного свидетельства данные в ГИС РН не передаются.',self);
//      end else begin
        Gisun.CurAkt:=Self;
        if FPoleGRN=nil then begin
          FPoleGRN:=Dokument.FindField('POLE_GRN');
        end;
        n:=Gisun.GetPoleGrn(FPoleGRN);
        if n=rNotRequired then begin
          ShowMessageCont('Данные не предназначены для отправки в ГИС РН', self);
          lOk:=false;
        end;
        if Gisun.IsDebug and (FImageGISUN=nil) then begin
          PutError('не определен ImageGISUN');
        end;
        if lOk then begin
          if (nType=0) and FEnableWrite then begin
            FWriteBeforeGisun:=true;  // !!!!
            try
              lOk:=WriteDok;
            finally
              FWriteBeforeGisun:=false;
            end;
          end;
        end;
        if lOk then begin
          if nType=0
            then FRefreshGurnal:=true;

          {$IFDEF ADD_ZAGS}
          //--- рождения ------------------------
          if FTypeObj=dmBase.TypeObj_ZRogd then begin
            if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
              Result:=Gisun.RegisterChildV( Self);
            end else begin
              if Dokument.FieldByName('GIVOROGD').AsBoolean then begin
                if Par=nil then begin
                  lNotSvid:=false;
                end else begin
                  lNotSvid:=Par.GetPar('EMPTY_SVID', false);
                end;
                Result:=Gisun.RegisterChild(Self,lNotSvid);
              end else begin
                PutError('Запись акта о рождении мертворожденного ребенка не регистрируется.',self);
              end;
            end;
          end else if FTypeObj=dmBase.TypeObj_ZSmert then begin
            if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
              Result:=Gisun.RegisterSmertV(Self);
            end else begin
              //----- регистрация з/а о смерти ------
              lCheck:=false;
              if Par=nil then begin
                lEmptyPrSmert:=Dokument.FieldByName('EMPTY_PRICH').AsBoolean;
              end else begin
                lEmptyPrSmert:=Par.GetPar('EMPTY_PRICH', false);
                if not lEmptyPrSmert  // попробовать передавать с не пустой причиной смерти
                  then lCheck:=true;
              end;
              Result:=Gisun.RegisterSmert(Self,lEmptyPrSmert);
              if Result and lCheck then begin  // если удачно передали повторно с не пустой причиной, то переключим реквизит EMPTY_PRICH
                EditDataset(Dokument);
                Dokument.FieldByName('EMPTY_PRICH').AsBoolean:=false;
                Dokument.Post;
                if (nType=0) and FEnableWrite then begin
                  lSeek:=true;
                  if dmBase.tbZapisSmert.FieldByName('ID').AsInteger<>DokumentID.AsInteger then begin
                    if not dmBase.tbZapisSmert.Locate('ID', DokumentID.AsInteger, []) then begin
                      lSeek:=false;
                    end;
                  end;
                  if lSeek then begin
                    EditDataSet(dmBase.tbZapisSmert);
                    if Dokument.FieldByName('EMPTY_PRICH').AsBoolean
                      then dmBase.tbZapisSmert.FieldByName('LICH_ID').AsInteger:=1   // в регистр передана пустая причина смерти
                      else dmBase.tbZapisSmert.FieldByName('LICH_ID').AsInteger:=0;
                    dmBase.tbZapisSmert.Post;
                  end else begin
                    QueryExit:=true;
                  end;
                end else begin
                  QueryExit:=true;
                end;
              end;
              //---------------------------------
            end;
          end else if FTypeObj=dmBase.TypeObj_ZBrak then begin
            if Dokument.FieldByName('VOSSTAN').AsBoolean then begin
              Result:=Gisun.RegisterMarriageV(Self);
            end else begin
              Result:=Gisun.RegisterMarriage(Self);
            end;
          end else if FTypeObj=dmBase.TypeObj_ZRast then begin
            Result:=Gisun.RegisterRastBrak(Self);
          end else if FTypeObj=dmBase.TypeObj_ZUstOtc then begin
            Result:=Gisun.RegisterUstOtc(Self);
          end else if FTypeObj=dmBase.TypeObj_ZUstMat then begin
            Result:=Gisun.RegisterUstMat(Self);
          end else if FTypeObj=dmBase.TypeObj_ZChName then begin
            Result:=Gisun.RegisterChName(Self);
          end else if FTypeObj=dmBase.TypeObj_ZAdopt then begin
            Result:=Gisun.RegisterAdopt(Self);
          end;          
          {$ENDIF}

          {$IFDEF ADD_ZAH}
          if FTypeObj=_TypeObj_AktZah then begin
            Result:=Gisun.RegisterAktZAH(Self,false);
          end;
          {$ENDIF}
          {$IFDEF ADD_OPEKA}
          if FTypeObj=_TypeObj_Opeka then begin
            Result:=Gisun.RegisterAktOpeka(Self);
          end;
          {$ENDIF}

          CheckAkt_GISUN(GISUN_POST);
          if Result then begin // !!! было: and (nType=0) then begin
            if (FMainTable.FieldByName('ID').AsInteger=Dokument.FieldByName('ID').AsInteger) then begin
              lOk:=true;
            end else begin
              if FMainTable.Locate('ID',DokumentID.AsInteger,[]) then lOk:=true;
            end;
            if lOk then begin    // запишем поле взаимодействия с ГИС РН
              EditDataSet(FMainTable);
              FMainTable.FieldByName('POLE_GRN').AsInteger:=Dokument.FieldByName('POLE_GRN').AsInteger;
              WriteAfterRegister_GISUN;
              FMainTable.Post;
              QueryExit:=false;
            end;
          end;
          if Result then begin
            Gisun.CheckPovtorToGis(Self);
          end;
        end;
        Gisun.CurAkt:=nil;
      end;
    {$ENDIF}
  finally
    Screen.Cursor:=cur;
  end;
end;
//------------------------------------------------------------------------------------
procedure TfmSimpleD.WriteAfterRegister_GISUN;
begin
//
end;
//------------------------------------------------------------------------------------
function TfmSimpleD.IsAktVosstan : Boolean;
var
  fld:TField;
begin
  if FDokZags then begin
    fld:=Dokument.FindField('VOSSTAN');
    if (fld=nil) or (fld.AsBoolean=false)
      then Result:=false
      else Result:=true;
  end else begin
    Result:=false;
  end;
end;

//------------------------------------------------------------------------------------
function TfmSimpleD.IsChildGivorogd : Boolean;
var
  fld:TField;
begin
  if FDokZags then begin
    fld:=Dokument.FindField('GIVOROGD');
    if (fld=nil) or (fld.AsBoolean=true)
      then Result:=true
      else Result:=false;
  end else begin
    Result:=true;
  end;
end;

//------------------------------------------------------------------------------------
function TfmSimpleD.ExitAsGISUN(lShow:Boolean): Boolean;
begin
 {$IFDEF GISUN}
    Result:=false;
    if IsActiveGISUN and Gisun.IsEnabled then begin
      if Gisun.IsEnableTypeAkt(FTypeObj,IsAktVosstan) then begin
        if Gisun.GetPoleGrn(Dokument)<>rNone then begin
          Result:=true;  // прервать текущую операцию
          if lShow
            then PutError('После взаимодействии с ГИС РН данная операция недоступна.')
        end;
      end;
    end;
 {$ELSE}
    Result:=false;
 {$ENDIF}
end;

//------------------------------------------------------------------------------------
procedure TfmSimpleD.TBItemTmpOffGISUNClick(Sender: TObject);
begin
 {$IFDEF GISUN}
   TBItemTmpOffGISUN.Checked:=not TBItemTmpOffGISUN.Checked;
   CheckMenuGISUN;
   CheckAkt_GISUN(GISUN_CHECK);
 {$ENDIF}
//
end;

//------------------------------------------------------------------------------------
procedure TfmSimpleD.TBItemGetDataGISUNClick(Sender: TObject);
begin
 {$IFDEF GISUN}
   GetDataFrom_GISUN(0);
 {$ELSE}     
   //        
 {$ENDIF}
end;

//------------------------------------------------------------------------------------
procedure TfmSimpleD.WM_RegisterAktGISUN(var rec: TMsg);
begin
 {$IFDEF GISUN}
    RegisterAkt_GISUN(0);
 {$ELSE}
   //
 {$ENDIF}
end;

//----------------------------------------------------------------------
function TfmSimpleD.EmptyIzm: String;
begin
  Result:='';
end;

//-------------------------------------------------------------------------
procedure TfmSimpleD.CheckEkz;
begin
  if FDokZags and N_F_edTypeEkz.Visible then begin
    EditDataSet(Dokument);
    if N_F_edTypeEkz.ItemIndex=0 then begin
      DokumentTYPE_EKZ.AsInteger:=1;
      DokumentNOMER_EKZ.AsInteger:=1;
    end else if N_F_edTypeEkz.ItemIndex=1 then begin
      DokumentTYPE_EKZ.AsInteger:=2;
      DokumentNOMER_EKZ.AsInteger:=2;
    end else if N_F_edTypeEkz.ItemIndex=2 then begin  // два экземпляра
      DokumentTYPE_EKZ.AsInteger:=91;
      DokumentNOMER_EKZ.AsInteger:=1;
    end else if N_F_edTypeEkz.ItemIndex=3 then begin  // два экземпляра + копия
      DokumentTYPE_EKZ.AsInteger:=92;
      DokumentNOMER_EKZ.AsInteger:=1;
    end else if N_F_edTypeEkz.ItemIndex=4 then begin  // два экземпляра (1 сторона)
      DokumentTYPE_EKZ.AsInteger:=93;
      DokumentNOMER_EKZ.AsInteger:=1;
    end;
  end;
end;

//----------------------------------------------------------------------
procedure TfmSimpleD.N_F_edTypeEkzChange(Sender: TObject);
begin
  CheckEkz;
end;

//----------------------------------------------------------------------
procedure TfmSimpleD.SetVisibleNomerEkz(pn: TPanel; ContLeft,ContCheck: TWinControl);
begin
  if FDokZags then begin
    if ContCheck<>nil
      then ContCheck.Visible:=false;
    if ContLeft=nil then begin
      N_F_edTypeEkz.Parent:=pn;
      N_F_edTypeEkz.Top:=ContCheck.Top+Trunc((ContCheck.Height-ContCheck.Height)/2)+1;
      N_F_edTypeEkz.Left:=ContCheck.Left;
      N_F_edTypeEkz.Visible:=true;
    end else begin
      N_F_edTypeEkz.Parent:=pn;
      N_F_edTypeEkz.Top:=ContLeft.Top+Trunc((ContLeft.Height-ContLeft.Height)/2)+1;
      N_F_edTypeEkz.Left:=ContLeft.Left+ContLeft.Width+5;
      N_F_edTypeEkz.Visible:=true;
    end;
  end;
//  if GlobalTask.ParamAsBoolean('EKZ_1PAGE') then begin
//    N_F_edTypeEkz.Items.Add('два экз.(1 сторона)');
//  end;
end;

//---------------------------------------------------------------------------
procedure TfmSimpleD.AddStdDataSetToXML;
begin
 ds2xml.DS_Add(Dokument,true);
 ds2xml.DS_Add(SvidPovtor);
 ds2xml.DS_Add(HistZAGS);
end;
//---------------------------------------------------------------------------
function TfmSimpleD.SaveDokumentToFile: Boolean;
var
  sFile,sFormatDate,sDir,sDate,sIDZags:String;
  fld:TField;
//  sl:TStringList;
begin
  Result:=true;
  sFormatDate:='YYYY-MM-DD';
  sDate:=FormatDateTime(sFormatDate,dmBase.getCurDate);
  sIDZags:=Globaltask.ParamAsString('ID');
  with ds2xml.ListAttribute do begin
    Clear;
    ds2xml.ListAttribute.Add('DATE_SAVE='+sDate);
    fld:=Dokument.FindField('DATEZ');
    if fld<>nil then begin
      sDate:=FormatDateTime(sFormatDate,Dokument.FieldByName('DATEZ').AsDateTime);  // !!!
      Add('DATE_DOK='+sDate);
    end;
    if Dokument.FindField('NOMER')<>nil
      then Add('NOMER_DOK='+Dokument.FieldByName('NOMER').AsString);
    Add('TYPEOBJ='+IntToStr(FTypeObj));
    Add('ID_SOURCE='+sIDZags);
    fld:=Dokument.FindField('ID_ZAGS');
    if fld<>nil  then Add('ID_ZAGS='+fld.AsString);
    fld:=Dokument.FindField('NAME_ZAGS');
    if fld<>nil  then Add('NAME_ZAGS='+fld.AsString);
    Add('PODR='+Globaltask.ParamAsString('PODR'));
  end;
  ds2xml.Version:=IntToStr(FVersionSave);

  sDir:=dmBase.NameDirFromTypeObj(FTypeObj, 'SaveDok', Copy(sDate,1,7), true);
  sFile:=dmBase.TypeObj2Str(FTypeObj)+'_'+sIDZags+'_'+DokumentID.AsString+'.xml';
  if ForceDirectories(sDir) then begin
    DeleteFile(CheckSleshN(sDir)+sFile);
    if ds2xml.DataToXML then begin
      ds2xml.XMLToFile(CheckSleshN(sDir)+sFile);
    end else begin
      Result:=false;
      PutError(ds2xml.LastError);
    end;
  end;
end;

//---------------------------------------------------------------------------
function TfmSimpleD.GetInfoSavedDok(sFile:String): TInfoSaveDok;
//var
//  sNomer,sRazd:String;
//  i,j:Integer;
begin
  Result.Error:='';
  Result.NameFile:=sFile;
  Result.Version:=0;
  Result.ID:=0;
  Result.ID_ZAGS:=0;
  Result.ID_SOURCE:=0;
  Result.PODR:=0;
  Result.TYPEOBJ:=0;
  Result.NAME_ZAGS:='';
end;

//---------------------------------------------------------------------------
function TfmSimpleD.LoadDokumentFromFile(sFile:String):TInfoSaveDok;
var
  i:Integer;
  d2xml:TDataSet2XML;
  tb:TkbmMemTable;
begin
  for i:=0 to ds2xml.DS_Count-1 do begin
    d2xml:=ds2xml.DS(i);
    if d2xml.DataSet is TkbmMemTable then begin
      d2xml.DataSet.DisableControls;
      d2xml.FClearRecord:=false;
      tb:=TkbmMemTable(d2xml.DataSet);
      tb.EmptyTable;
      if d2xml.FOneRecord then begin
        tb.Append;
        tb.Post;
      end;
    end else begin
      PutError('ERROR READ FILE');
    end;
  end;
//  dsDokument.DataSet:=nil;
  IsReadDokument:=true;
  FRun:=true;
  try
    ds2xml.FileToXML(sFile);
    ds2xml.XMLToData;
  finally
    IsReadDokument:=false;
    FRun:=false;
  end;
//  dsDokument.DataSet:=Dokument;
  for i:=0 to ds2xml.DS_Count-1 do begin
    d2xml:=ds2xml.DS(i);
    if d2xml.DataSet is TkbmMemTable then begin
      d2xml.DataSet.EnableControls;
    end;
  end;

end;

//--------------------------------------------------------------
// для подключения выбора из справочника
procedure TfmSimpleD.ChoiceSpecClick(Sender: TObject;  var Handled: Boolean);
begin
  ChoiceSpecD(TDbEditEh(TEditButtonControlEh(Sender).Owner));
end;

//--------------------------------------------------------------
// для подключения выбора из справочника
procedure TfmSimpleD.AddButton_ChoiceSpec(Params : array of TVarRec);
var
  bt : TEditButtonEh;
  i : Integer;
begin
  for i:=Low(Params) to High(Params) do begin
    with Params[i] do begin
      bt := TDbEditEh(VObject).EditButtons.Add;
      bt.OnClick := ChoiceSpecClick;
      bt.Style   := ebsEllipsisEh;
      bt.Visible := true;
    end;
  end;
end;

//--------------------------------------------------------------
function TfmSimpleD.ChoiceSpecD(cont:TWinControl; lBel:Boolean): Boolean;
var
  sDolg,sDolg_B,sFIO,sFIO_B,sField:String;
  fld:TField;
begin
  Result:=false;
  if ChoiceSpec2(sDolg,sDolg_B,sFIO,sFIO_B,cont,lBel) then begin
    sField:='RUKOV';
    if cont is TDbEditEh then begin
      sField:=UpperCase(TDbEditEh(cont).Field.FieldName);
    end;
    if Copy(sField,1,5)='RUKOV' then begin
      EditDataset(Dokument);
      fld:=Dokument.FindField(sField);
      if fld<>nil then if lBel then fld.AsString:=sFIO_B else fld.AsString:=sFIO;
      fld:=Dokument.FindField(sField+'_B');
      if fld<>nil then fld.AsString:=sFIO_B;
      if FFieldDolgRuk=''
        then fld:=Dokument.FindField('DOLG_RUKOV')
        else fld:=Dokument.FindField(FFieldDolgRuk);
      if fld<>nil then if lBel then fld.AsString:=sDolg_B else fld.AsString:=sDolg;
      if FFieldDolgRuk=''
        then fld:=Dokument.FindField('DOLG_RUKOV_B')
        else fld:=Dokument.FindField(FFieldDolgRuk+'_B');
      if fld<>nil then fld.AsString:=sDolg_B;
    end else begin
      EditDataset(Dokument);
      fld:=Dokument.FindField('SPEC');
      if fld<>nil then fld.AsString:=sFIO;
      fld:=Dokument.FindField('SPEC_B');
      if fld<>nil then fld.AsString:=sFIO_B;
      if FFieldDolgSpec=''
        then fld:=Dokument.FindField('DOLG_SPEC')
        else fld:=Dokument.FindField(FFieldDolgSpec);
      if fld<>nil then fld.AsString:=sDolg;
//      fld:=Dokument.FindField('DOLG_SPEC_B');
//      if fld<>nil then fld.AsString:=sDolg_B;
    end;
    Result:=true;
  end;
end;

//----------------------------------------------------------------------
// для события на кнопку в контроле TDbEditEh для выбора улицы
procedure TfmSimpleD.UlicaClick(Sender: TObject; var Handled: Boolean);
var
  ed:TDbEditEh;
begin
  if Sender is TDbEditEh then begin
    ed:=TDbEditEh(Sender);
  end else begin
    ed:=TDbEditEh(TWinControl(Sender).Owner);   // sender кнопка
  end;
  ChoiceUL(ed);
end;

procedure TfmSimpleD.MsgHandler(var Msg: TMsg; var Handled: Boolean);
var
  n:LongWord;
begin
 if Msg.message = WM_INPUTLANGCHANGEREQUEST then begin
    if cbBel<>nil then begin
      n:=Msg.lParam;
      if (n=KEY_BLR) and not cbBel.Checked then begin
        cbBel.Checked:=true;
      end;
      if (n<>KEY_BLR) and cbBel.Checked then begin
        cbBel.Checked:=false;
      end;
//      ShowMessage(IntToStr(Msg.lParam));
    end;
  end;
//     Handled := true;
end;

procedure TfmSimpleD.FormActivate(Sender: TObject);
begin
  Screen.OnActiveControlChange := ActiveControlChanged;

{
      подключение события переключения cbBel при переключении клавиатуры
  pMessage:=Application.OnMessage;
  Application.OnMessage:=MsgHandler;
}
end;

procedure TfmSimpleD.FormDeactivate(Sender: TObject);
begin
{
  Application.OnMessage:=pMessage;
}
end;

procedure TfmSimpleD.SetVisibleImageBE;
begin
  if cbBel<>nil then begin
    imBE.Parent:=cbBel.Parent;
    imBE.Left:=cbBel.Left+22;
    imBE.Top:=cbBel.Top;
    imBE.Visible:=true;
    imBE.BringToFront;
    cbBel.Caption:='';
    cbBel.Width:=20;
  end;
end;

procedure TfmSimpleD.FormResize(Sender: TObject);
begin
  if (cbBel<>nil) and imBE.Visible then begin
    imBE.Left:=cbBel.Left+22;
  end;
end;

procedure TfmSimpleD.SetcbBel(cb: TDbCheckBoxEh; lb:TLabel);
begin
  cbBel:=cb;
  lbBel:=lb;
  if lb<>nil
    then lbBel.Caption:='на белорусском языке';
 // if cb<>nil then
  //  cbBel.Visible:=GlobalTask.ParamAsBoolean('CBBEL');
//  SetVisibleImageBE;
end;

procedure TfmSimpleD.CheckLANG(nLang: Integer; lCheckValueField:Boolean);
var
  sFldSeek,sFldGet1,sFldGet2:String;
begin
  if nLang=1 then begin
//    CheckForAll_Bel( nil );
    ActivateBLRKeyboard;
    EditDataSet(Dokument);
    DokumentLANG.AsInteger:=1;
    Dokument.Post;
//    edRukov.DataField       := 'RUKOV_B';
    if lbBel<>nil then lbBel.Enabled:=true;
    sFldSeek:='FIO';
    sFldGet1:='FIO_B';
    sFldGet2:='POST_B';
  end else begin
    ActivateRUSKeyboard;
    EditDataSet(Dokument);
    DokumentLANG.AsInteger:=0;
    Dokument.Post;
    if lbBel<>nil then lbBel.Enabled:=false;
//    edRukov.DataField := 'RUKOV';
    sFldSeek:='FIO_B';
    sFldGet1:='FIO';
    sFldGet2:='POST';
  end;
  if lCheckValueField then begin
    if (Dokument.FindField('RUKOV')<>nil) and (Dokument.FieldByName('RUKOV').AsString<>'') then begin
      if dmBase.SprDocOfficial.Locate(sFldSeek, Dokument.FieldByName('RUKOV').AsString, [loCaseInsensitive]) then begin
        EditDataSet(Dokument);
        Dokument.FindField('RUKOV').AsString:=dmBase.SprDocOfficial.FieldByName(sFldGet1).AsString;
        if (Dokument.FindField('DOLG_RUKOV')<>nil)
          then Dokument.FindField('DOLG_RUKOV').AsString:=dmBase.SprDocOfficial.FieldByName(sFldGet2).AsString;
        PostDataSet(Dokument);
      end;
    end;
  end;
end;

//--------------------------------------------------------------------
procedure TfmSimpleD.TBItemAdresatClick(Sender: TObject);
var
  slPar:TStringList;
  s:String;
  fld:TField;
begin
  fld:=Dokument.FindField('ARX_ADRESAT');
  if fld=nil then begin
    fld:=Dokument.FindField('ADRESAT');
  end;
  if fld<>nil then begin
    slPar:=TStringList.Create;
    if AddParEnterAdresat(slPar) then begin
      {$IFDEF HUNSPELL}
        s:=EnterAdresatHS(Self.Left+20,Self.Top+70,fld.AsString,slPar);
      {$ELSE}
        s:=EnterAdresat(Self.Left+20,Self.Top+70,fld.AsString,slPar);
      {$ENDIF}
      if s<>'' then begin
        EditDataSet(Dokument);
        fld.AsString:=s;
        TBItemAdresat.Hint:='Адресат:'+#13#10+s;
      end else begin
        TBItemAdresat.Hint:='Ввести адресата';
      end;
    end;
    FreeAndNil(slPar);
  end;
end;
//---------------
function TfmSimpleD.AddParEnterAdresat(slPar: TStringList; strFieldName:String): Boolean;
begin
  Result:=true;
end;

const
  SimAddUserName='_';       // дополнительный символ для TfrxDbDataSet.UserName

//------------------------------------------------------
procedure TfmSimpleD.CheckUserName_frxDataSet;
var
  i:Integer;
begin
  for i:=0 to ComponentCount-1 do begin
    if Components[i] is TfrxDBDataset then begin
      TfrxDBDataset(Components[i]).UserName:=TfrxDBDataset(Components[i]).UserName+SimAddUserName;
    end;
  end;
end;
//------------------------------------------------------
procedure TfmSimpleD.UnCheckUserName_frxDataSet;
var
  i,n:Integer;
  s:String;
begin
  n:=Length(SimAddUserName);
  for i:=0 to ComponentCount-1 do begin
    if Components[i] is TfrxDBDataset then begin
      s:=TfrxDBDataset(Components[i]).UserName;
      if RightStr(s,n)=SimAddUserName then begin
        TfrxDBDataset(Components[i]).UserName:=Copy(s,1,Length(s)-n);
      end;
    end;
  end;
end;

//-------------------------------------------------------------------
procedure TfmSimpleD.CMDialogKey(var msg: TCMDialogKey);
begin
{
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB;
}
  if TabAsDown then begin
    if msg.Charcode <> VK_TAB then begin
      inherited;
    end;
  end else begin
    inherited;
  end;
end;
//------------------------------------------------------------------------------
procedure TfmSimpleD.SetTabAsDown(const Value: Boolean);
begin
  FTabAsDown := Value;
end;
//------------------------------------------------------------------------------
function TfmSimpleD.CheckDokumentSimple(nType:Integer; lWriteDok:Boolean): Boolean;
var
  strErr,s:String;
  fld:TField;
  procedure AddErr(s:String); begin  strErr:=strErr+s+chr(13)+chr(10); end;
begin
  Result:=true;
  {$IFDEF ZAGS}
  strErr:='';                     

  if lWriteDok then begin

    if FTypeObj in [_TypeObj_DBrak, _TypeObj_DRast, _TypeObj_DChName] then begin
      fld:=Dokument.FieldByName('DATEZ');
      if fld<>nil then begin
        if not fld.IsNull and (fld.AsDateTime>Date) then begin
          AddErr('Дата заявления больше текущей');
        end;
      end;
    end;            

    if FOnlySvid and FDokZags then begin
      if FCheckSvidNomer then begin
        if Dokument.FieldByName('DATESV').IsNull          then AddErr(' Заполните дату выдачи свидетельства.');
        if Dokument.FieldByName('SVID_SERIA').AsString='' then AddErr(' Заполните серию свидетельства.');
        if Dokument.FieldByName('SVID_NOMER').AsString='' then AddErr(' Заполните номер свидетельства.');
      end;
    end;
    if not FOnlySvid and FDokZags then begin
      if SvidPovtor.Active then begin
        if SvidPovtor.RecordCount>0 then begin
          fld := Dokument.FindField('DATEZ');
          if fld<>nil then begin
            SvidPovtor.Last;
            s:=CheckFieldDate(SvidPovtorSVID_DATE,-1,YearOf(dmBase.GetCurDate),true,'<',fld);
            if s<>'' then  AddErr('Дата повторного свидетельства '+s);
          end;
        end;
      end;
    end;
  end;

  if strErr<>'' then begin
    FLastError:=strErr;
    Result:=false;
  end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TfmSimpleD.CheckAllDokZags:Boolean;
var
  sl:TStringList;
  s:String;
  n:Integer;
begin
  Result:=true;
  {$IFDEF ZAGS}  
  if SvidPovtor.Active then begin
    sl:=TStringList.Create;
    SvidPovtor.First;
    while not SvidPovtor.Eof do begin
      s:=PadRStr(SvidPovtorSVID_SERIA.AsString,10,'0')+PadLStr(SvidPovtorSVID_NOMER.AsString,15,'0');
      n:=sl.IndexOf(s);
      if n=-1 then begin
        sl.Add(s);
      end else begin
        Result:=false;
        FLastError:=FLastError+'Дублирование повторных свидетельств: '+
           SvidPovtorSVID_SERIA.AsString+' '+SvidPovtorSVID_NOMER.AsString+#13#10;
      end;
      SvidPovtor.Next;
    end;
    SvidPovtor.First;
    sl.Free;
  end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TfmSimpleD.CheckDokument(nType:Integer; lShowErr:Boolean; lClearProtokol:Boolean; lWriteDok:Boolean): Boolean;
var
  v:Variant;
  lRun:Boolean;
begin
  FLastError:='';
  FProtokol.Clear;
  Result:=true;
  if not IsCheckDokument then exit; // !!!
//  v:=null;
//  RunProcScript(GetVid+'_BeforeCheck',v);
//  if v<>null then Result:=v;
  if Result then begin
    if FDokZags then
      Result:=CheckAllDokZags;
    if Result then
      Result:=CheckDokumentSimple(nType,lWriteDok);
  end;
  lRun:=false;
  v:=null;
  RunFuncScript(GetVid+'_Check',[lWriteDok], v, lRun);
  if v<>null
    then Result:=v;
  if not Result and lShowErr and (FLastError<>'') then begin
    if FProtokol.Count>0 then begin
      ShowStrings(FProtokol,'Протокол ошибок');
    end else if (FLastError<>'') then begin
      PutError(FLastError,self);
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TfmSimpleD.SetTypeObj(const Value: Integer);
begin
  FTypeObj := Value;
  GlobalTask.SetKodCurDok(IntToStr(Value));
//  if IsAktVosstan
//    then GlobalTask.SetKodCurDok(IntToStr(Value)+'V')
//    else GlobalTask.SetKodCurDok(IntToStr(Value));
end;
//------------------------------------------------------------------------------
procedure TfmSimpleD.cbPovtorOnClick(Sender: TObject);
begin
  CheckTsSvidPovtor;
end;
//------------------------------------------------------------------------------
procedure TfmSimpleD.CheckPageControl(pc: TPageControl);
begin
  FPageControl:=pc;
  FPageControl.OwnerDraw:=true;
  FPageControl.OnDrawTab:=PageControlDrawTab;
end;

//----------------------------------------------------------------------
function TfmSimpleD.getGrag(strFieldName, strRazd: String): String;
var
  fld:TField;
begin
  Result:='';
  fld:=Dokument.FieldByName(strFieldName);
  if (fld<>nil) and (fld.AsString<>'') then begin
    Result:=dmBase.getGrag(fld.AsString);
  end;
  fld:=Dokument.FindField(strFieldName+'_ADD');   // может есть поле с дополнительными гражданствами
  if (fld<>nil) and (fld.AsString<>'') then begin
    if strRazd=''
      then strRazd:=' ';
    if Result=''
      then Result:=fld.AsString
      else Result:=Result+strRazd+fld.AsString;
  end;
end;

//----------------------------------------------------------------------
function TfmSimpleD.getNation(strField, strFieldName: String): String;
var
  fld:TField;
begin
  Result:='';
  fld:=Dokument.FieldByName(strField);
  if (fld.AsString<>'') then begin
    Result:=dmBase.getNation(fld.AsString,strFieldName);
  end;
  {
  fld:=Dokument.FindField(strFieldName+'_ADD');   // может есть поле с дополнительными гражданствами
  if (fld<>nil) and (fld.AsString<>'') then begin
    if strRazd=''
      then strRazd:=' ';
    if Result=''
      then Result:=fld.AsString
      else Result:=Result+strRazd+fld.AsString;
  end;
  }
end;

procedure TfmSimpleD.PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  AText: string;
  APoint: TPoint;
  i,j:Integer;
begin
  with (Control as TPageControl).Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(Rect);
    j:=-1;
    for i:=0 to TPageControl(Control).PageCount-1 do begin
      if TPageControl(Control).Pages[i].TabVisible then begin
        j:=j+1;
      end;
      if j=TabIndex then break;
    end;
    if j>-1 then begin
      AText := TPageControl(Control).Pages[i].Caption;
  //    AText := TPageControl(Control).Pages[TabIndex].Caption;
      with Control.Canvas do
      begin
        APoint.x := (Rect.Right - Rect.Left) div 2 - TextWidth(AText) div 2;
        APoint.y := (Rect.Bottom - Rect.Top) div 2 - TextHeight(AText) div 2;
        TextRect(Rect, Rect.Left + APoint.x, Rect.Top + APoint.y, AText);
      end;
    end;
  end;
end;

procedure TfmSimpleD.TBItemCkeckRegistrClick(Sender: TObject);
begin
  TBItemCkeckRegistr.Checked:=not TBItemCkeckRegistr.Checked;
  FCheckRegistr:=TBItemCkeckRegistr.Checked;
end;

procedure TfmSimpleD.AddButton_LoadIdentif(ed : TDbEditEh);
var
  bt:TEditButtonEh;
begin
  bt:=ed.EditButtons.Add;
  bt.OnClick := Event_LoadIdentif;
  bt.Style   := ebsPlusEh;
  bt.Visible := true;
  bt.ShortCut:= TextToShortCut('Ins');
  bt.Width:=20;
  bt.Hint:='Запросить ИН по ФИО и дате рождения (Insert)';
end;

procedure TfmSimpleD.AddButton_Plus(ed : TDbEditEh;  onRunEvent: TButtonClickEventEh; sHint:String);
var
  bt:TEditButtonEh;
begin
  bt:=ed.EditButtons.Add;
  bt.OnClick := onRunEvent;
  bt.Style   := ebsPlusEh;
  bt.Visible := true;
  bt.ShortCut:= TextToShortCut('Ins');
  bt.Width:=20;
  bt.Hint:=sHint;
end;

//--------------------------------------------------------------------------------------------------
procedure TfmSimpleD.Event_LoadIdentif(Sender: TObject;  var Handled: Boolean);
{$IFDEF GISUN}
var
  sFamilia,sName,sOtch,sField,sAdd,sAdd2,sAdd3:String;
  dDateR:TDateTime;
  nTypeDate:Integer;
  fld:TField;
  sl:TStringList;
  cur:TCursor;
  ed:TDbEditEh;
  lReport,lButton:Boolean;
  ds:TDataSet;
  f:TfmChoiceMenGISUN;
  p : TPassport;
{$ENDIF}
begin
  {$IFDEF GISUN}
    Dokument.CheckBrowseMode;
    if Sender is TDbEditEh then begin
      lButton:=false;
      ed:=TDbEditEh(Sender);
    end else begin
      lButton:=true;
      ed:=TDbEditEh(TWinControl(Sender).Owner);
    end;
    if ed.Text<>'' then begin
      if lButton then begin
        ShowMessageCont('Для запроса очистите значение.', self);
      end else begin
        SendKeys('{DOWN}',false);
      end;
    end else begin
      sField:=ed.Field.FieldName;
      if Dokument.FieldByName(sField).AsString='' then begin
        nTypeDate:=DATE_FULL;
        sl:=TStringList.Create;
        sAdd:='';
        sAdd2:='';
        sAdd3:='';
        if sField='IDENTIF' then begin
          sAdd:='';
        end else if sField='ON_IDENTIF' then begin
          sAdd:='ON_';
        end else if sField='IDENTIF_DO' then begin
          sAdd2:='Do';
          sAdd3:='_DO'
        end else if sField='ONA_IDENTIF' then begin
          sAdd:='ONA_';
        end else if sField='MAT_IDENTIF' then begin
          sAdd:='MAT_';
        end else if sField='OTEC_IDENTIF' then begin
          sAdd:='OTEC_';
        end;
        if (FTypeObj=_TypeObj_ZChName) or (FTypeObj=_TypeObj_DChName) then begin
          sAdd2:='Do';
        end else if (sField='IDENTIF') and ((FTypeObj=_TypeObj_ZUstOtc) or (FTypeObj=_TypeObj_ZUstMat)) then begin
          sAdd2:='Do';
        end;
        sFamilia:=Dokument.FieldByName(sAdd+'Familia'+sAdd2).AsString;
        sName:=Dokument.FieldByName(sAdd+'NAME'+sAdd2).AsString;
        sOtch:=Dokument.FieldByName(sAdd+'Otch'+sAdd2).AsString;
        dDateR:=Dokument.FieldByName(sAdd+'DATER'+sAdd3).AsDateTime;
        if (FTypeObj=_TypeObj_ZSmert) or (FTypeObj=_TypeObj_AktZAH) then begin
          fld:=Dokument.FindField('ONLYGOD_R');
          if fld<>nil then begin
            nTypeDate:=fld.AsInteger;
          end;
        end else begin    // актовая запись о браке
          fld:=Dokument.FindField(sAdd+'ONLYGOD');
          if fld<>nil then begin
            if fld.AsBoolean then nTypeDate:=DATE_GOD;
          end;
        end;

        cur:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        Gisun.CurAkt:=Self;
        lReport:=false;
        try
          if Gisun.LoadPersonalIdentif(sl,sFAMILIA,sName,sOtch, dDateR, nTypeDate) then begin
            Screen.Cursor:=cur;
            lReport:=true;
            if sl.Count=0 then begin
              ShowMessageCont('Данные по лицу не найдены.',self);
              Dokument.Edit;
              DokumentCOVER_MESSAGE_ID.AsString:=Gisun.RegInt.CoverMessageId;
              DokumentCOVER_MESSAGE_TIME.AsDateTime:=Gisun.RegInt.CoverMessageTime;
              DokumentREQUEST_IN.AsString:='';
              Dokument.Post;
            end else if sl.Count=1 then begin
              Dokument.Edit;
              DokumentCOVER_MESSAGE_ID.AsString:=Gisun.RegInt.CoverMessageId;
              DokumentCOVER_MESSAGE_TIME.AsDateTime:=Gisun.RegInt.CoverMessageTime;
              Dokument.FieldByName(sField).AsString:=sl.Strings[0];
              DokumentREQUEST_IN.AsString:=sl.Strings[0];
              if (FTypeObj=_TypeObj_ZAdopt) and (sField='IDENTIF_DO') then begin
                Dokument.FieldByName('IDENTIF_POSLE').AsString:=sl.Strings[0];
              end;
              Dokument.Post;
            end else if sl.Count>1 then begin
              if Problem('Количество найденных людей: '+IntToStr(sl.Count)+'. Загрузить данные ? ',mtConfirmation,Self) then begin
                Screen.Cursor:=crHourGlass;
                try
                  ds:=Gisun.LoadIdentifData(sl,nil,nil);
                finally
                  Screen.Cursor:=cur;
                end;
                if ds<>nil then begin
                  while not ds.Eof do begin
                    ds.Edit;
                    ds.FieldByName('ADRES_G').AsString:=dmBase.GetAdresAkt3(ds, '<UPPER>GOSUD_G,FName;OBL_G;RAION_G,RNGOROD_G;GOROD_G,TYPE_GOROG_G;ULICA_G,*_G',1,false);
                    ds.FieldByName('ADRES_R').AsString:=dmBase.GetAdresAkt3(ds, '<UPPER>GOSUD_R,FName;OBL_R;RAION_R;GOROD_R,TYPE_GOROD_R',1,true);
                    p:=dmBase.GetPasportAkt('','DOC=DOKUMENT;TYPE=DOK_TYPE;SERIA=DOK_SERIA;NOMER=DOK_NOMER;DATE=DOK_DATE',0,ds);
                    ds.FieldByName('DOC_NAME').AsString:=ANSIUpperCase(dmBase.PasportToText(p,0));
                    ds.Post;
                    ds.Next;
                  end;
                  ds.First;
                  f:=TfmChoiceMenGISUN.Create(nil);
                  f.DataSource.DataSet:=ds;
                  if f.ShowModal=mrOk then begin
                    Dokument.Edit;
                    Dokument.FieldByName(sField).AsString:=ds.FieldByName('IDENTIF').AsString;
                    if (FTypeObj=_TypeObj_ZAdopt) and (sField='IDENTIF_DO') then begin
                      Dokument.FieldByName('IDENTIF_POSLE').AsString:=Dokument.FieldByName(sField).AsString;
                    end;
                    Dokument.Post;
                  end;
                  f.Free;
                  ds.Free;
                end;
              end;
            end;
          end;
        finally
          Screen.Cursor:=cur;
          sl.Free;
          Gisun.CurAkt:=nil;
        end;
        if FReportIN and lReport then begin
          GlobalTask.PreViewReport('&Запрос ИН.fr3');
        end;
      end;
    end;
  {$ENDIF}
end;

procedure TfmSimpleD.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
//  if AsChild then
//    Params.Style := Params.Style or WS_CHILD;

//  Params.WndParent:= GetDesktopWindow; // дочерняя форма рабочего стола
//  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
// Params.ExStyle := Params.ExStyle or
//    WS_EX_TRANSPARENT;

end;

procedure TfmSimpleD.FormShow(Sender: TObject);
begin
//  ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TfmSimpleD.imBEClick(Sender: TObject);
begin
  if cbBel<>nil then begin
    cbBel.Checked:=not cbBel.Checked;
    cbBel.OnClick(nil);
  end;
end;

function TfmSimpleD.FindParentControl(c: TControl): Boolean;
var
  i:Integer;
  p:TWinControl;
  sField,sNewField:String;
begin
  Result:=false;
  if (c<>nil) and (c is TCustomDbEditEh) then begin
    p:=c.Parent;
    sField:=TCustomDbEditEh(c).DataField;
    if sField<>'' then begin
      if RightStr(sField,2)='_B' then begin
        sNewField:=Copy(sField,1,Length(sField)-2);
      end else begin
        sNewField:=sField+'_B';
      end;
      for i:=0 to p.ControlCount-1 do begin
        if (p.Controls[i] is TCustomDbEditEh) then begin
          if SameText(TCustomDbEditEh(p.Controls[i]).DataField,sNewField) then begin
            ActiveControl:=TWinControl(p.Controls[i]);
            exit;
          end;
        end;
      end;
    end;
  end;
end;

//--------------------------------------------------------------
// функция только для чтения актовых записей при выписке повторных свидетельств
function TfmSimpleD.LoadAkt(nID:Integer):Boolean;
var
  fld:TField;
  sSvidNomer,sSvidSeria,sRukov,sRukovB,sSpec,sSpecB:String;
  dSvidDate:TDateTime;
begin
 Result:=false;
 Dokument.CheckBrowseMode;
 if nID>0 then begin
   try
     IsReadDokument:=true;
     sSvidSeria:='';
     sSvidNomer:='';
     dSvidDate:=Now;
     fld:=Dokument.FindField('SVID_SERIA');
     if fld<>nil then sSvidSeria:=fld.AsString;
     fld:=Dokument.FindField('SVID_NOMER');
     if fld<>nil then sSvidNomer:=fld.AsString;
     fld:=Dokument.FindField('DATESV');
     if (fld<>nil) and not fld.IsNull then dSvidDate:=fld.AsDateTime;

     fld:=Dokument.FindField('RUKOV');
     if (fld<>nil) then sRukov:=fld.AsString;
     fld:=Dokument.FindField('RUKOV_B');
     if (fld<>nil) then sRukovB:=fld.AsString;
     fld:=Dokument.FindField('SPEC');
     if (fld<>nil) then sSpec:=fld.AsString;
     fld:=Dokument.FindField('SPEC_B');
     if (fld<>nil) then sSpecB:=fld.AsString;
    
     ReadDok( nID );
     if SvidPovtor.Active then SvidPovtor.EmptyTable;

     EditDataSet(Dokument);
     fld:=Dokument.FindField('SVID_SERIA');
     if fld<>nil then fld.AsString:=sSvidSeria;
     fld:=Dokument.FindField('SVID_NOMER');
     if fld<>nil then fld.AsString:=sSvidNomer;
     fld:=Dokument.FindField('DATESV');
     if (fld<>nil) and (dSvidDate>0) then fld.AsDateTime:=dSvidDate;
     fld:=Dokument.FindField('RUKOV');
     if fld<>nil then fld.AsString:=sRukov;
     fld:=Dokument.FindField('RUKOV_B');
     if fld<>nil then fld.AsString:=sRukovB;
     fld:=Dokument.FindField('SPEC');
     if fld<>nil then fld.AsString:=sSpec;
     fld:=Dokument.FindField('SPEC_B');
     if fld<>nil then fld.AsString:=sSpecB;

     if FOnlySvid then begin
       DokumentPOVTOR.AsBoolean:=true;
     end;
     PostDataSet(Dokument);
     {$IFDEF ZAGS}
     if FOnlySvid and (FBOOKMARK_SVIDPOVTOR<>'') then begin  // если фиксировали выдачу повторного свидетельства fNewNomerAkt
       dmBase.SvidPovtor.Bookmark:=FBOOKMARK_SVIDPOVTOR;
       dmBase.SvidPovtor.Edit;
       dmBase.SvidPovtor.FieldByName('AKT_ID').AsInteger := nID;
       dmBase.SvidPovtor.Post;
     end;
     {$ENDIF}
     Result:=true;
   finally
     IsReadDokument:=false;
     QueryExit:=true;
   end;
   {$IFDEF GISUN}
     CheckAkt_GISUN(GISUN_CHECK);
     BeforeEditFormGISUN;
   {$ENDIF}
 end;
end;

//--------------------------------------------------------------
procedure TfmSimpleD.TBItemSeekAktClick(Sender: TObject);
var
  nID,nGod,nNomer:Integer;
  arrRec:TCurrentRecord;
//  nTypeObj:Integer;
//  fld:TField;
//  sSvidNomer,sSvidSeria,sRukov,sRukovB:String;
//  dSvidDate:TDateTime;
begin
 FLastError:='';
 SetLength(arrRec,1);
 Dokument.CheckBrowseMode;
 try
   nNomer:=Dokument.FieldByName('NOMER').AsInteger;
   if Dokument.FieldByName('DATEZ').AsString=''
     then nGod:=0
     else nGod:=YearOf(Dokument.FieldByName('DATEZ').AsDateTime);
 except
   nNomer:=0;
   nGod:=YearOf(Now);
 end;
 if nGod>0 then nGod:=-1*nGod;
 nID:=SimpleSeekAkt(FTypeObj, 0, nGod, nNomer, arrRec);
 if nID>0 then begin
   if not LoadAkt(nID) then begin
     PutError(FLastError,self)
   end;
 end;
end;

//--------------------------------------------------------------
procedure TfmSimpleD.WriteToDebug(arr:array of Variant);
var
 lRun:Boolean;
 v:Variant;            
begin   
  RunFuncScript('WriteDebug_',arr,v,lRun);
end;
//--------------------------------------------------------------
procedure TfmSimpleD.WriteFieldToDebug(fld:TField);
begin
  WriteToDebug(
    [
     'AsString='+fld.AsString+chr(13)+
     'Text='+fld.Text+chr(13)+
     'NewValue='+fld.NewValue+chr(13)+
     'OldValue='+fld.OldValue+chr(13)+
     'Value='+VarToStr(fld.Value)
    ]);
end;
//------------------------------------------------
procedure TfmSimpleD.SetEvent;
begin
//
end;
//------------------------------------------------
procedure TfmSimpleD.ClearEvent;
begin
//
end;
//------------------------------------------------------------------------------
function TfmSimpleD.getVoenkomat(strSoato:String; fldDC:TField; fldDR:TField; lCheckVozr:Boolean; nGrag:Integer):Integer;
var
  nVozr,n:Integer;
begin
  Result:=0;
  nVozr:=-1;
  if lCheckVozr then begin
    if not fldDR.IsNull and not fldDC.IsNull then begin
      try
        nVozr:=GetCountYear( fldDC.AsDateTime, fldDR.AsDateTime);
      except
        nVozr:=0;
      end;
    end else begin
      //
    end;
  end;
  if strSOATO<>'' then begin
    if (nVozr=-1) or ((nVozr>=FMinVoenkom) and (nVozr<=FMaxVoenkom)) then begin
      if (nGrag=-1) or (nGrag=MY_GRAG) then begin
        n:=dmBase.VoenkomFromSOATO(strSOATO);
        if n>0 then begin
          Result:=n;
        end;
      end;
    end;
  end;
end;
//----------------------------------------------------------------
procedure TfmSimpleD.FlushBuffers;
begin
  if Globaltask.ParamAsBoolean('FLUSH_BUFFERS') then begin
    FMainTable.AdsFlushFileBuffers;
  end;
end;

procedure TfmSimpleD.AddUserHist;
begin
//
end;

procedure TfmSimpleD.TBItemCreateHistClick(Sender: TObject);
begin
  AddUserHist;
end;

procedure TfmSimpleD.TBItemFirstClick(Sender: TObject);
begin
  SkipDok(1);
end;
procedure TfmSimpleD.TBItemPrevClick(Sender: TObject);
begin
  SkipDok(2);
end;
procedure TfmSimpleD.TBItemNextClick(Sender: TObject);
begin
  SkipDok(3);
end;
procedure TfmSimpleD.TBItemLastClick(Sender: TObject);
begin
  SkipDok(4);
end;

//---------------------------------------------------------
procedure TfmSimpleD.TBItemSprAktClick(Sender: TObject);
{$IFDEF ZAGS}
var
  n:Integer;
  s:String;
  arrRec:TCurrentRecord;
begin
  if DokumentID.AsInteger>0 then begin
    CheckUserName_frxDataSet;
//    if WriteDok then begin
    Dokument.CheckBrowseMode;
      GetCurrentRecord(Dokument, '', arrRec);
      if (cbBel<>nil) and cbBel.Checked then  n:=1 else n:=0;
      SetValueFieldEx(arrRec, 'SET_LANG', n);
      if ActiveControl is TCustomDBEditEh then begin
        if Pos('ONA', TCustomDBEditEh(ActiveControl).DataField)>0
          then s:='ONA' else s:='ON';
        SetValueFieldEx(arrRec, 'ON_ONA', s);
      end;
      EditZAGS_SprAkt(-1, FTypeObj, arrRec);
//    end;
    UnCheckUserName_frxDataSet;
    SetCurDok(Self);
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}


procedure TfmSimpleD.TBItemDeclSvidClick(Sender: TObject);
{$IFDEF ZAGS}
var
  n:Integer;
  s:String;
  d:TDateTime;
  arrRec:TCurrentRecord;
  lWrite:Boolean;
begin
  if DokumentID.AsInteger>0 then begin
    lWrite:=false;
    CheckUserName_frxDataSet;
    Dokument.CheckBrowseMode;
    GetCurrentRecord(Dokument, '', arrRec);
    if (cbBel<>nil) and cbBel.Checked then  n:=1 else n:=0;
    SetValueFieldEx(arrRec, 'SET_LANG', n);
    if ActiveControl is TCustomDBEditEh then begin
      if Pos('ONA', TCustomDBEditEh(ActiveControl).DataField)>0
        then s:='ONA' else s:='ON';
      SetValueFieldEx(arrRec, 'ON_ONA', s);
    end;
    s:='';
    d:=0;
    if EditZAGS_DeclSvid(-1, FTypeObj, arrRec, Dokument) then begin
      s:=GetValueFieldEx(arrRec,'$SVID_NOMER','');
      d:=GetValueFieldEx(arrRec,'$SVID_DATE',0);
      if (s<>'') and (d>0)
        then lWrite:=true;
    end;
    UnCheckUserName_frxDataSet;
    SetCurDok(Self);
    if lWrite and not SvidPovtor.Locate('SVID_DATE;SVID_NOMER',VarArrayOf([d,s]),[]) then begin
      if Problem('Записать данные повторного свидетельства ?', mtConfirmation, Self) then begin
        EditDataSet(Dokument);
        DokumentPOVTOR.AsBoolean:=true;
        PostDataSet(Dokument);
        SvidPovtor.Append;
        SvidPovtorSVID_SERIA.AsString:=GetValueFieldEx(arrRec,'$SVID_SERIA','');
        SvidPovtorSVID_NOMER.AsString:=s;
        SvidPovtorSVID_DATE.AsDateTime:=d;
        SvidPovtorFIRST.AsBoolean:=false;
        SvidPovtorGISRN.AsInteger:=0;
        SvidPovtor.Post;
        CheckTsSvidPovtor;
      end;
    end;
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}
//==== специальная регистрация: ИН вносится вручную без печати в документах =====================
function TfmSimpleD.IsSpecReg:Boolean;
{$IF Defined(ZAGS) or Defined(LAIS) }
begin
  Result:=false;
  case FTypeObj of
    _TypeObj_ZSmert : Result:=(Dokument.FieldByName('LICH_NOMER_GIS').AsString='1');
    _TypeObj_ZBrak, _TypeObj_ZRast : Result:=( (Dokument.FieldByName('ON_IDENTIF_GIS').AsString='1') or (Dokument.FieldByName('ONA_IDENTIF_GIS').AsString='1') );
    _TypeObj_ZRogd  : Result:=false; // !!!
  end;
end;
{$ELSE}
begin
  Result:=false;
end;
{$IFEND}
// в зависимости от значения поля sFldIN+'_GIS' возвращать пусто или ИН
function TfmSimpleD.CondIN(sFldIN:String):String;
{$IF Defined(ZAGS) or Defined(LAIS) }
var
  f:TField;
  s:String;
begin
  Result:=Dokument.FieldByName(sFldIN).AsString;
  f:=Dokument.FindField(sFldIN+'_GIS');  // 'TYPEMESSAGE'
  if (f<>nil) then begin
    if Trim(f.AsString)='1'
      then Result:='';
  end;
end;
{$ELSE}
begin
  Result:=Dokument.FieldByName(sFldIN).AsString;
end;
{$IFEND}

initialization
  ListLastAddObj:=TStringList.Create;
  AsChild:=false;
finalization
  FreeAndNil(ListLastAddObj);
end.






