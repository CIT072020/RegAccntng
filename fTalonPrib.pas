unit fTalonPrib;

interface

{$I Task.inc}
{$include ver.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF LEVEL6} Variants, {$ENDIF}
  fSimpleD, Db, kbmMemTable, ComCtrls, TB2Item, TB2Dock, TB2Toolbar,
  {$IFDEF GISUN} uGisun, fGetGisun1, {$ENDIF}
  ExtCtrls, StdCtrls, DBLookupEh, DBCtrlsEh, Mask, FuncPr, dbFunc, dMen, uTypes,
  OpisEdit, MetaTask, Grids, DBGridEh, Buttons, vchDBCtrls, FR_DSet, uCheckKod, uProject, ifpii_dbfunc,
  FR_DBSet, ToolCtrlsEh, ImgList, kbmMemCSVStreamFormat, ZipForge;

type
  TfmTalonPrib = class(TfmSimpleD)
    pn: TPanel;
    edDate_SOST: TDBDateTimeEditEh;
    pc: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    Label17: TLabel;
    Label41: TLabel;
    edRukov: TDBEditEh;
    dsStran: TDataSource;
    dsNation: TDataSource;
    Label19: TLabel;
    edIst: TDBLookupComboboxEh;
    edDateZ: TDBDateTimeEditEh;
    gbDeti: TGroupBox;
    GridDeti: TDBGridEh;
    dsDeti: TDataSource;
    Label38: TLabel;
    mtDeti: TkbmMemTable;
    mtDetiNAME: TStringField;
    DokumentNOMER: TIntegerField;
    DokumentDATEZ: TDateField;
    DokumentFamilia: TStringField;
    DokumentName: TStringField;
    DokumentOtch: TStringField;
    DokumentDateR: TDateField;
    DokumentSOATO_R: TStringField;
    DokumentGOSUD_R: TIntegerField;
    DokumentOBL_R: TStringField;
    DokumentRAION_R: TStringField;
    DokumentGOROD_R: TStringField;
    DokumentSELO_R: TStringField;
    DokumentPOL: TStringField;
    DokumentNATION: TIntegerField;
    DokumentOBRAZ: TIntegerField;
    DokumentSEM: TIntegerField;
    DokumentSOATO: TStringField;
    DokumentADRES_ID: TIntegerField;
    DokumentADRES_NAME: TMemoField;
    DokumentORGAN: TMemoField;
    DokumentSOATO_O: TStringField;
    DokumentGOSUD_O: TIntegerField;
    DokumentOBL_O: TStringField;
    DokumentRAION_O: TStringField;
    DokumentGOROD_O: TStringField;
    DokumentSELO_O: TStringField;
    DokumentDATE_O: TDateField;
    DokumentDRUG_PRICH: TMemoField;
    DokumentCEL: TIntegerField;
    DokumentSROK: TStringField;
    DokumentISTOC: TIntegerField;
    DokumentDETI: TSmallintField;
    DokumentLICH_NOMER: TStringField;
    DokumentPASP_SERIA: TStringField;
    DokumentPASP_NOMER: TStringField;
    DokumentPASP_DATE: TDateField;
    DokumentDATE_SOST: TDateField;
    DokumentRUKOV: TStringField;
    DokumentMEN_ID: TIntegerField;
    DokumentLICH_ID: TIntegerField;
    dsCel: TDataSource;
    dsIst: TDataSource;
    mtDetiCHILD_ID: TIntegerField;
    mtDetiPOL: TStringField;
    mtDetiDATER: TDateField;
    mtDetiOTCH: TStringField;
    DokumentWORK_DOLG_OLD: TMemoField;
    edWorkOLD: TDBEditEh;
    Label7: TLabel;
    DokumentPROV: TBooleanField;
    DokumentWORK_NAME: TStringField;
    DokumentDOLG_NAME: TStringField;
    Label31: TLabel;
    DokumentSUPRUG: TBooleanField;
    DokumentPASP_VIDAN: TStringField;
    DokumentOLD_UL: TStringField;
    DokumentOLD_FIO: TStringField;
    DokumentOLD_ADRES_ID: TIntegerField;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    edOldUL: TDBEditEh;
    edOldFIO: TDBEditEh;
    edDrugPrich: TDBEditEh;
    DokumentCITIZEN: TIntegerField;
    dsCitizen: TDataSource;
    Label37: TLabel;
    edOldDom: TDBEditEh;
    Label39: TLabel;
    edOldKorp: TDBEditEh;
    Label40: TLabel;
    edOldKv: TDBEditEh;
    DokumentOLD_DOM: TStringField;
    DokumentOLD_KORP: TStringField;
    DokumentOLD_KV: TStringField;
    mtDetiFAMILIA: TStringField;
    Panel1: TPanel;
    btAddChild: TBitBtn;
    btDelChild: TBitBtn;
    frDBDeti: TfrDBDataSet;
    DokumentDATE_SROK: TDateField;
    DokumentPASP_UDOST: TSmallintField;
    TBItemUbit: TTBItem;
    DokumentB_OBL_O: TBooleanField;
    DokumentB_OBL_R: TBooleanField;
    DokumentGOROD_R_B: TIntegerField;
    DokumentGOROD_O_B: TIntegerField;
    mtDetiOTNOSH: TIntegerField;
    DokumentOTNOSH: TIntegerField;
    DokumentVUS: TMemoField;
    Label43: TLabel;
    edVUS: TDBEditEh;
    DokumentUL_O: TStringField;
    edWork_Name: TDBEditEh;
    edDolg_Name: TDBEditEh;
    DokumentDOLG_SPR: TIntegerField;
    DokumentWORK_SPR: TIntegerField;
    DokumentIS_VUS: TBooleanField;
    DokumentZVAN: TIntegerField;
    DokumentPRIB_DATE: TDateField;
    Label44: TLabel;
    edZvan: TDBComboBoxEh;
    N_F_cbIsVUS: TDBCheckBoxEh;
    edVUSDate: TDBDateTimeEditEh;
    Label45: TLabel;
    dsOtnosh: TDataSource;
    mtDetiOTNOSH_NAME: TStringField;
    DokumentTYPEREG: TSmallintField;
    edTypeReg: TDBComboBoxEh;
    DokumentNOMER_SEM: TSmallintField;
    DokumentOSNOV_ID: TIntegerField;
    DokumentOSNOV_DATE: TDateField;
    DokumentOSNOV: TMemoField;
    pnLast: TPanel;
    Label35: TLabel;
    Label24: TLabel;
    BtRB: TImage;
    btRF: TImage;
    btU: TImage;
    gbPribil: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label5: TLabel;
    Label21: TLabel;
    edGOSUD_O: TDBLookupComboboxEh;
    edGOROD_O: TDBEditEh;
    edDate_O: TDBDateTimeEditEh;
    DBCheckBoxEh1: TDBCheckBoxEh;
    edGOROD_O_B: TDBLookupComboboxEh;
    edUlDom_O: TDBEditEh;
    edRAION_O: TDBEditEh;
    edOBL_O: TDBEditEh;
    edOrgan: TDBEditEh;
    edCel: TDBLookupComboboxEh;
    pnLic: TPanel;
    lbOSNOV_ID: TLabel;
    edOSNOV_ID: TDBComboBoxEh;
    edDate_Osnov: TDBDateTimeEditEh;
    edOsnov: TDBEditEh;
    lbOSNOV_DATE: TLabel;
    pnNewLic: TPanel;
    N_F_cbNewLich: TDBCheckBoxEh;
    lbOtnosh: TLabel;
    edOTNOSH: TDBLookupComboboxEh;
    N_F_edNomerSem: TDBCheckBoxEh;
    DokumentTELEFON: TStringField;
    DokumentDATE_SROK_DN: TDateField;
    Label47: TLabel;
    edDateSrokDog: TDBDateTimeEditEh;
    lbNomer_osnov: TLabel;
    edNomer_Osnov: TDBEditEh;
    DokumentOSNOV_NOMER: TStringField;
    pnMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label20: TLabel;
    Label6: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label36: TLabel;
    Label46: TLabel;
    edName: TDBEditEh;
    edOtch: TDBEditEh;
    edPol: TDBComboBoxEh;
    edNATION: TDBLookupComboboxEh;
    edDateR: TDBDateTimeEditEh;
    edObraz: TDBComboBoxEh;
    edSem: TDBComboBoxEh;
    N_F_edSuprug: TDBCheckBoxEh;
    edCitizen: TDBLookupComboboxEh;
    edFamilia: TDBEditEh;
    edTelefon: TDBEditEh;
    gbPasp: TGroupBox;
    Label8: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    ENG_edLichNomer: TDBEditEh;
    edPasp_Seria: TDBEditEh;
    edPasp_Nomer: TDBEditEh;
    edPasp_Date: TDBDateTimeEditEh;
    edPasp_Organ: TDBEditEh;
    edUdost: TDBComboBoxEh;
    gbRogd: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edGOSUD_R: TDBLookupComboboxEh;
    edGOROD_R: TDBEditEh;
    DBCheckBoxEh3: TDBCheckBoxEh;
    edB_GOROD_R: TDBLookupComboboxEh;
    edRAION_R: TDBEditEh;
    edOBL_R: TDBEditEh;
    Label15: TLabel;
    TextAdres: TvchDBText;
    btAdres: TBitBtn;
    Label26: TLabel;
    edDeti: TDBNumberEditEh;
    Label25: TLabel;
    edSrok: TDBEditEh;
    Label42: TLabel;
    edDateSrok: TDBDateTimeEditEh;
    DokumentADRESAT: TMemoField;
    Label48: TLabel;
    edADRESAT: TDBEditEh;
    DokumentPASP_SROK: TDateField;
    Label113: TLabel;
    edPasp_Srok: TDBDateTimeEditEh;
    DokumentGOD_PROG: TStringField;
    edGodProg: TDBEditEh;
    procedure edPolChange(Sender: TObject);
    procedure dsDokumentDataChange(Sender: TObject; Field: TField);
    procedure TextAdresGetText(Sender: TObject; var Text: String);
    procedure btAdresClick(Sender: TObject);
    procedure edFamiliaEditButtons0Click(Sender: TObject;  var Handled: Boolean);
    procedure GridDetiColumns1EditButtons0Click(Sender: TObject;  var Handled: Boolean);
    procedure btAddChildClick(Sender: TObject);
    procedure btDelChildClick(Sender: TObject);
    procedure dsDetiDataChange(Sender: TObject; Field: TField);
    procedure TBItemUbitClick(Sender: TObject);
//    procedure edRAION_RNotInList(Sender: TObject; NewText: String;   var RecheckInList: Boolean);
//    procedure edOBL_RNotInList(Sender: TObject; NewText: String;     var RecheckInList: Boolean);
    procedure edPasp_OrganEditButtons0Click(Sender: TObject;  var Handled: Boolean);
    procedure ENG_edLichNomerUpdateData(Sender: TObject; var Handled: Boolean);
    procedure edDolg_NameEditButtons1Click(Sender: TObject; var Handled: Boolean);
    procedure edWork_NameEditButtons1Click(Sender: TObject; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure edUdostEditButtons0Click(Sender: TObject; var Handled: Boolean);
    procedure edOTNOSHEditButtons0Click(Sender: TObject; var Handled: Boolean);
    procedure N_F_cbNewLichClick(Sender: TObject);
    procedure GridDetiColumns0EditButtons0Click(Sender: TObject; var Handled: Boolean);
    procedure edNameUpdateData(Sender: TObject; var Handled: Boolean);
    procedure edOsnovEditButtons0Click(Sender: TObject; var Handled: Boolean);
    procedure edTypeRegChange(Sender: TObject);
    procedure edTypeRegUpdateData(Sender: TObject; var Handled: Boolean);
    procedure TBItemGetDataGISUNClick(Sender: TObject);
  private
    { Private declarations }
//    FBitRB : TBitMap;
  public
    { Public declarations }
    FCurLic : Integer;
    FRunTalonUbit : Boolean;
    FFromMen:Boolean;
    FCopyMen:Boolean;
    FSaveMigr:Boolean;
    procedure CheckEnabledDeti;
    procedure SetEnabledPanelLic(l:Boolean);
    procedure CheckPanelLic;
    procedure WriteDvigMen( nIDMen : Integer);
    procedure WriteDokumentFromArr(arrRec : TCurrentRecord; lDeti:Boolean);

    function WriteDok : Boolean; override;
    function ReadDok(nID : Integer) : Boolean; override;
    function NewDok( lAppend : Boolean ) : Boolean; override;
    function GetVid : String; override;
//    function GetNameReport : String; override;
    procedure UpdateActions; override;
    function BeforeEdit: Boolean; override;
    constructor Create(Owner : TComponent); override;
    function GetDateProp:TDateTime;

    procedure SetRB_OnClick(Sender: TObject;  var Handled: Boolean);
    procedure SetRF_OnClick(Sender: TObject;  var Handled: Boolean);
    procedure SetU_OnClick(Sender: TObject;  var Handled: Boolean);
    function ProvDvig : Boolean;
    function AddLicTP : Boolean;
    function GetDvig:Integer;
    function EmptyLICH_ID: Boolean;

  end;

  procedure TalonPribFromMen(dmMen:TdmMen;lDeti:Boolean);
  function TalonPribFromDeclRegist(fS:TfmSimpleD; lSem:Boolean):Integer;
  procedure TalonPribFromPassport(fS:TfmSimpleD; lDeti:Boolean);

var
  fmTalonPrib: TfmTalonPrib;

const
  IZM_MEN=2;     // изменить данные о человеке   [KEY_TYPEREG_TALON]
  NOT_DVIG=3;    // не проводить                 [KEY_TYPEREG_TALON]

implementation

uses dBase, fChoiceAdres, fMain, fAddLic, fChoiceNasel, fShablon, fDeclRegistr; //, fPassport, fVidGit;

{$R *.DFM}

function TalonPribFromDeclRegist(fS:TfmSimpleD; lSem:Boolean):Integer;
var
  n,nVozr:Integer;
  f:TfmDeclRegistr;
  sBookMark:String;
begin
  Result:=0;
  f:=TfmDeclRegistr(fS);

  fmTalonPrib := TfmTalonPrib.Create(nil);
  fmTalonPrib.TBItemUbit.Visible:=false;
  fmTalonPrib.edFamilia.EditButtons[0].Visible:=false;
  fmTalonPrib.pc.ActivePageIndex:=0;

//  fmTalonPrib.FFromMen:=true;
// см. BeforeEdit  fmTalonPrib.FEnableWrite:=false;
  try
    fmTalonPrib.IsReadDokument:=true;
    fmTalonPrib.NewDok(true);

    with fmTalonPrib do begin
    //  DokumentMEN_ID.AsInteger := dmMen.mtDokumentID.AsInteger;
//      WriteField( DokumentNATION, dmMen.mtDokumentNATION ); //   , lErr);
//      WriteField( DokumentOBRAZ, dmMen.mtDokumentOBRAZ ); //   , lErr);
//      WriteField( DokumentSEM, dmMen.mtDokumentSEM ); //   , lErr);

      if lSem then begin

        fmTalonPrib.pnLic.Visible:=false;   // !!!

        DokumentFamilia.AsString:=f.tbSemFAMILIA.AsString;
        DokumentName.AsString:=f.tbSemNAME.AsString;
        DokumentOtch.AsString:=f.tbSemOTCH.AsString;
        DokumentPOL.AsString:=f.tbSemPOL.AsString;
        WriteDateField(DokumentDateR, f.tbSemDATER);
      end else begin
        DokumentFamilia.AsString:=f.DokumentFamilia.AsString;
        DokumentName.AsString:=f.DokumentNAME.AsString;
        DokumentOtch.AsString:=f.DokumentOTCH.AsString;
        DokumentPOL.AsString:=f.DokumentPOL.AsString;
        WriteDateField(DokumentDateR, f.DokumentDATER);
        DokumentLICH_NOMER.AsString  := f.DokumentLICH_NOMER.AsString;
        DokumentPASP_UDOST.AsInteger := f.DokumentPASP_UDOST.AsInteger;
        DokumentPASP_SERIA.AsString  := f.DokumentPASP_SERIA.AsString;
        DokumentPASP_NOMER.AsString  := f.DokumentPASP_NOMER.AsString;
        DokumentPASP_VIDAN.AsString  := f.DokumentPASP_VIDAN.AsString;
        WriteDateField(DokumentPASP_DATE, f.DokumentPASP_DATE );

        // основание заселения только для первого заявителя,
        // для того чтобы записать если будет создаваться новый лицевой счет
        DokumentOSNOV_ID.AsInteger := f.DokumentOSNOV_ID.AsInteger;
        DokumentOSNOV_NOMER.AsString := f.DokumentOSNOV_NOMER.AsString;
        WriteDateField(DokumentOSNOV_DATE, f.DokumentOSNOV_DATE);
        DokumentOSNOV.AsString := f.DokumentOSNOV.AsString;

      end;
      DokumentADRES_ID.AsInteger := f.DokumentADRES_ID.AsInteger;
      DokumentLICH_ID.AsInteger  := f.DokumentLICH_ID.AsInteger;

      if not f.DokumentMEN_ID.IsNull and (f.DokumentMEN_ID.AsInteger>0) then begin
        DokumentMEN_ID.AsInteger :=f.DokumentMEN_ID.AsInteger;
        DokumentTYPEREG.AsInteger:=IZM_MEN;
      end else begin
        DokumentTYPEREG.AsInteger  := f.DokumentTYPEREG.AsInteger;
      end;

      DokumentNOMER_SEM.AsInteger  := f.DokumentNOMER_SEM.AsInteger;
      DokumentNOMER_SEM.AsInteger  := f.DokumentNOMER_SEM.AsInteger;

      WriteDateField( DokumentDATE_SROK_DN, f.DokumentDATE_SROK_DN ); //   , lErr);

      WriteField( DokumentGOSUD_O   , f.DokumentGOSUD_O)  ; //     , lErr);
      WriteField( DokumentB_OBL_O   , f.DokumentB_OBL_O ); //   , lErr);
      WriteField( DokumentOBL_O     , f.DokumentOBL_O)  ; //     , lErr);
      WriteField( DokumentRAION_O   , f.DokumentRAION_O ); //   , lErr);
      WriteField( DokumentGOROD_O_B , f.DokumentGOROD_O_B); // , lErr);
      WriteField( DokumentGOROD_O   , f.DokumentGOROD_O ); //   , lErr);
      WriteField( DokumentUL_O   , f.DokumentUL_O ); //   , lErr);

      DokumentSROK.AsString:=f.DokumentSROK.AsString;
      WriteDateField(DokumentDATE_SROK, f.DokumentDATE_SROK );
      DokumentORGAN.AsString:=f.DokumentORGAN.AsString;

    end;

    fmTalonPrib.Dokument.Post;

    n:=0;
    //----------- соберем детей -------------------
    if not lSem then begin
      sBookMark:=f.tbSem.Bookmark;
      f.tbSem.First;
      while not f.tbSem.Eof do begin
        if f.tbSemDATER.IsNull then begin
          nVozr:=99;
        end else begin
          nVozr:=GetCountYear(dmBase.GetCurDate,f.tbSemDATER.AsDateTime);
        end;
        if (nVozr<14) then begin
           fmTalonPrib.mtDeti.Append;
           fmTalonPrib.mtDetiFAMILIA.AsString:=f.tbSemFAMILIA.AsString;
           fmTalonPrib.mtDetiNAME.AsString:=f.tbSemNAME.AsString;
           fmTalonPrib.mtDetiOTCH.AsString:=f.tbSemOTCH.AsString;
           fmTalonPrib.mtDetiPOL.AsString:=f.tbSemPOL.AsString;
           fmTalonPrib.mtDetiOTNOSH.AsString:=f.tbSemOTNOSH.AsString;
           fmTalonPrib.mtDetiDATER.AsDateTime:=f.tbSemDATER.AsDateTime;
           fmTalonPrib.mtDeti.Post;
           n:=n+1;
        end;
        f.tbSem.Next;
      end;
      f.tbSem.Bookmark:=sBookMark;
    end;
    //--------------------------------------------
    if n>0 then begin
      fmTalonPrib.Dokument.Edit;
      fmTalonPrib.DokumentDETI.AsInteger:=n;
      fmTalonPrib.Dokument.Post;
    end;

    fmTalonPrib.IsReadDokument:=false;
    fmTalonPrib.QueryExit:=false;
    fmTalonPrib.EditModal;
    if fmTalonPrib.DokumentID.AsInteger>0 then begin
      Result:=fmTalonPrib.DokumentID.AsInteger;
    end;
  finally
    fmTalonPrib.Free;
    fmTalonPrib:=nil;
  end;
end;

//-----------------------------------------------------------------------
procedure TalonPribFromPassport(fS:TfmSimpleD; lDeti:Boolean);
var
  n,nVozr,nID:Integer;
//  f:TfmPassport;
  sBookMark:String;
  arr:TCurrentRecord;
  ds:TDataSet;
begin
  nID:=fs.Dokument.FieldByName('ID_MEN').AsInteger;
  if nID>0 then begin
    ds:=dmBase.GetMen(fmMain.DateFiks,IntToStr(nID));
    GetCurrentRecord( ds, '', arr);

    fmTalonPrib := TfmTalonPrib.Create(nil);
    fmTalonPrib.TBItemUbit.Visible:=false;
    fmTalonPrib.TBSubmenuRun.Visible:=false;
    fmTalonPrib.edFamilia.EditButtons[0].Visible:=false;
    fmTalonPrib.pc.ActivePageIndex:=0;
//  fmTalonPrib.edTypeReg.Enabled:=false;

//  fmTalonPrib.FFromMen:=true;
// см. BeforeEdit  fmTalonPrib.FEnableWrite:=false;
    try
      fmTalonPrib.IsReadDokument:=true;
      fmTalonPrib.NewDok(true);

      EditDataSet(fmTalonPrib.Dokument);
      fmTalonPrib.WriteDokumentFromArr(arr,true);
      fmTalonPrib.DokumentTYPEREG.AsInteger:=IZM_MEN;
      fmTalonPrib.Dokument.Post;
      fmTalonPrib.IsReadDokument:=false;
      fmTalonPrib.QueryExit:=false;
      fmTalonPrib.EditModal;

    finally
      fmTalonPrib.Free;
      fmTalonPrib:=nil;
    end;
  end else begin
    PutError('В заявлении на паспорт человек должен быть выбран из населения!');
  end;
end;
//--------------------------------------------------------------
procedure TalonPribFromMen(dmMen:TdmMen;lDeti:Boolean);
var
  n:Integer;
begin
  fmTalonPrib := TfmTalonPrib.Create(nil);
  fmTalonPrib.FFromMen:=true;
  fmTalonPrib.pnLic.Visible:=false;
// см. BeforeEdit  fmTalonPrib.FEnableWrite:=false;
//  fmTalonPrib.pc.ActivePageIndex:=1;
  try
    fmTalonPrib.IsReadDokument:=true;
    fmTalonPrib.NewDok(true);

    fmTalonPrib.DokumentFamilia.AsString:=dmMen.mtDokumentFAMILIA.AsString;
    fmTalonPrib.DokumentName.AsString:=dmMen.mtDokumentName.AsString;
    fmTalonPrib.DokumentOtch.AsString:=dmMen.mtDokumentOtch.AsString;
    fmTalonPrib.DokumentPOL.AsString:=dmMen.mtDokumentPOL.AsString;
    with fmTalonPrib do begin
      DokumentMEN_ID.AsInteger := dmMen.mtDokumentID.AsInteger;
      WriteDateField(DokumentDateR, dmMen.mtDokumentDATER );
      WriteField( DokumentNATION, dmMen.mtDokumentNATION ); //   , lErr);
      WriteField( DokumentOBRAZ, dmMen.mtDokumentOBRAZ ); //   , lErr);
      WriteField( DokumentSEM, dmMen.mtDokumentSEM ); //   , lErr);
      DokumentADRES_ID.AsInteger := dmMen.mtDokumentADRES_ID.AsInteger;
      DokumentLICH_ID.AsInteger  := dmMen.mtDokumentLIC_ID.AsInteger;

      DokumentCITIZEN.AsString:= dmMen.mtDokumentCITIZEN.AsString;

      DokumentLICH_NOMER.AsString:= dmMen.mtDokumentLICH_NOMER.AsString;
      DokumentPASP_UDOST.AsInteger := dmMen.mtDokumentPASP_UDOST.AsInteger;
      DokumentPASP_SERIA.AsString  := dmMen.mtDokumentPASP_SERIA.AsString;
      DokumentPASP_NOMER.AsString  := dmMen.mtDokumentPASP_NOMER.AsString;
      DokumentPASP_VIDAN.AsString  := dmMen.mtDokumentPASP_VIDAN.AsString;
      WriteDateField(DokumentPASP_SROK, dmMen.mtDokumentPASP_SROK );
      WriteDateField(DokumentPASP_DATE, dmMen.mtDokumentPASP_DATE );

      DokumentWORK_SPR.AsString  := dmMen.mtDokumentWORK_SPR.AsString;
      DokumentWORK_NAME.AsString := dmMen.mtDokumentWORK_NAME.AsString;
      DokumentDOLG_SPR.AsString  := dmMen.mtDokumentDOLG_SPR.AsString;
      DokumentDOLG_NAME.AsString := dmMen.mtDokumentDOLG_NAME.AsString;
      DokumentNOMER_SEM.AsString := dmMen.mtDokumentNOMER_SEM.AsString;
      DokumentTELEFON.AsString   := dmMen.mtDokumentTELEFON.AsString;

      WriteField( DokumentGOSUD_R   , dmMen.mtDokumentMR_GOSUD ); //   , lErr);
      WriteField( DokumentB_OBL_R   , dmMen.mtDokumentMR_B_OBL ); //   , lErr);
      WriteField( DokumentOBL_R     , dmMen.mtDokumentMR_OBL   ); //     , lErr);
      WriteField( DokumentRAION_R   , dmMen.mtDokumentMR_RAION ); //   , lErr);
      WriteField( DokumentGOROD_R_B , dmMen.mtDokumentMR_B_GOROD); // , lErr);
      WriteField( DokumentGOROD_R   , dmMen.mtDokumentMR_GOROD ); //   , lErr);

      WriteField( DokumentGOSUD_O   , dmMen.mtDokumentOP_GOSUD ); //   , lErr);
      WriteField( DokumentB_OBL_O   , dmMen.mtDokumentOP_B_OBL ); //   , lErr);
      WriteField( DokumentOBL_O     , dmMen.mtDokumentOP_OBL   ); //     , lErr);
      WriteField( DokumentRAION_O   , dmMen.mtDokumentOP_RAION ); //   , lErr);
      WriteField( DokumentGOROD_O_B , dmMen.mtDokumentOP_B_GOROD); // , lErr);
      WriteField( DokumentGOROD_O   , dmMen.mtDokumentOP_GOROD  ); //   , lErr);
      WriteField( DokumentDATE_O    , dmMen.mtDokumentOP_DATE  ); //   , lErr);

      if dmMen.mtDokumentVUS.AsBoolean then begin
        n:=dmMen.mtDokumentVOENKOM.AsInteger;
        if n=0
          then n:=GlobalTask.ParamAsInteger('ID_VOENKOM');
        if dmBase.SprVoenkom.Locate('ID',n,[]) then begin
          DokumentVUS.AsString:=dmBase.SprVoenkom.FieldByName('NAME').AsString;
        end else begin
          DokumentVUS.AsString:='ВОЕННООБЯЗАННЫЙ';
        end;
        if not dmMen.mtDokumentPRIB_DATE.IsNull then begin
          DokumentVUS.AsString:=DokumentVUS.AsString+'  принят на учет '+DATEPROPIS(dmMen.mtDokumentPRIB_DATE.AsDateTime,1);
        end;
        if not dmMen.mtDokumentUBIT_DATE.IsNull then begin
          DokumentVUS.AsString:=DokumentVUS.AsString+'  снят с учета '+DATEPROPIS(dmMen.mtDokumentUBIT_DATE.AsDateTime,1);
        end;
      end else begin
        if dmMen.mtDokumentPOL.AsString='М'
          then DokumentVUS.AsString:='НЕ ВОЕННООБЯЗАННЫЙ';
      end;
    end;
    // !!! Отношение к воиской службе

    fmTalonPrib.Dokument.Post;

    fmTalonPrib.IsReadDokument:=false;
    fmTalonPrib.QueryExit:=false;
    fmTalonPrib.EditModal;
//    l:=fmTalonPrib.FRunTalonUbit;
//    nID := fmTalonPrib.DokumentID.AsInteger;
  finally
    fmTalonPrib.Free;
    fmTalonPrib:=nil;
  end;
//  if l then begin
//    TalonUbitFromTalonPrib(nID);
//  end;
end;

{
[KEY_TYPEREG_TALON]
1=регистрация по месту жительства
0=регистрация по месту пребывания
2=изменить данные о человеке
3=не проводить
}
//---------------------------------------------------------
function TfmTalonPrib.GetDvig:Integer;
begin
  Result:=NOT_DVIG;
  if edTypeReg.Visible then begin
    if edTypeReg.ItemIndex=-1 then begin
      Result:=NOT_DVIG;
    end else if edTypeReg.ItemIndex=0 then begin
      Result:=MESTO_GIT;
    end else if edTypeReg.ItemIndex=1 then begin
      Result:=MESTO_PREB;
    end else if edTypeReg.ItemIndex=2 then begin
      Result:=IZM_MEN;
    end else if edTypeReg.ItemIndex=3 then begin
      Result:=NOT_DVIG;
    end;
  end;
end;
//---------------------------------------------------------
function TfmTalonPrib.ProvDvig: Boolean;
begin
  if GetDvig=NOT_DVIG then begin
    Result := false;
  end else begin
    Result := true;
  end;
end;
//---------------------------------------------------------
constructor TfmTalonPrib.Create(Owner: TComponent);
var
  bt : TEditButtonEh;
begin
  inherited;
  FCopyMen:=false;
  FSaveMigr:=false;
  FCheckLookupField:=false;
  FMainTable := dmBase.tbTalonPrib;
  dmBase.SetDateFormat(mtDeti);
  mtDeti.Open;
  pc.ActivePageIndex:=0;
  FPageControl := pc;
  FRunTalonUbit := false;
  FFromMen:=False;
  if not GlobalTask.ParamAsBoolean('AUTO_PRIB') then begin
    edTypeReg.Visible:=false;
    edTypeReg.ItemIndex:=-1;
  end;
  FCurLic:=0;
  edFamilia.OnUpdateData:=FIOUpdateData;
  edName.OnUpdateData:=FIOUpdateData;
  edOtch.OnUpdateData:=FIOUpdateData;

//  fmMain.SetCurrentDokument(Dokument);

  fmMain.ImageList.GetBitmap(IL_ADD_MEN,btAddChild.Glyph);
  fmMain.ImageList.GetBitmap(IL_DEL_MEN,btDelChild.Glyph);

  bt := edGOSUD_R.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetRB_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtRB.Picture.Bitmap;
  bt := edGOSUD_O.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetRB_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtRB.Picture.Bitmap;

  bt := edGOSUD_R.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetRF_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtRF.Picture.Bitmap;
  bt := edGOSUD_O.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetRF_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtRF.Picture.Bitmap;

  bt := edGOSUD_R.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetU_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtU.Picture.Bitmap;
  bt := edGOSUD_O.EditButtons.Add;
  bt.Visible := true;
  bt.OnClick := SetU_OnClick;
  bt.Visible := true;
  bt.Style   := ebsGlyphEh;
  bt.Glyph   := BtU.Picture.Bitmap;

  SetLength(FArrChoiceRekv,2);

  FArrChoiceRekv[0].nType:=SHABLON_DRUG_PR;
  FArrChoiceRekv[0].FieldName:='DRUG_PRICH';

  FArrChoiceRekv[1].nType:=SHABLON_OSNOV_PRED;
  FArrChoiceRekv[1].FieldName:='OSNOV';
end;

{
function TfmTalonPrib.GetNameReport: String;
begin
  Result := '&Листок прибытия.frf';
end;
}
function TfmTalonPrib.GetVid: String;
begin
  Result := 'TalonPrib';
end;
//----------------------------------------------------------------
function TfmTalonPrib.NewDok( lAppend : Boolean ): Boolean;
begin
  Dokument.EmptyTable;
  Dokument.Append;
  DokumentID.AsInteger := -1;
  DokumentPOL.AsString := 'М';
  DokumentSUPRUG.AsBoolean := false;
  DokumentPROV.AsBoolean := false;
  DokumentTYPEREG.AsInteger := MESTO_GIT;
  DokumentNOMER_SEM.AsInteger:=0;
  mtDeti.EmptyTable;
  FCopyMen:=false;
  FSaveMigr:=false;
  FCurLic:=0;
  inherited NewDok(lAppend);
  QueryExit:=false;
  Result := true;
  SetEnabledPanelLic(false);
end;
//----------------------------------------------------------------
procedure TfmTalonPrib.SetEnabledPanelLic(l:Boolean);
begin
  pnLic.Enabled:=l;
  lbOSNOV_ID.Enabled:=l;
  edOSNOV_ID.Enabled:=l;

  lbOSNOV_DATE.Enabled:=l;
  edDATE_OSNOV.Enabled:=l;

  lbNomer_OSNOV.Enabled:=l;
  edNOMER_OSNOV.Enabled:=l;

  edOSNOV.Enabled:=l;
end;
//----------------------------------------------------------------
procedure TfmTalonPrib.CheckPanelLic;
var
  l:Boolean;
begin
  if ProvDvig and (EmptyLICH_ID or (N_F_cbNewLich.Enabled and N_F_cbNewLich.Checked)) then begin
    SetEnabledPanelLic(true);
  end else begin
    SetEnabledPanelLic(false);
  end;
  N_F_cbNewLich.Enabled := not EmptyLICH_ID and ((GetDvig=MESTO_GIT) or (GetDvig=MESTO_PREB));
  if (EmptyLICH_ID and (GetDvig<>MESTO_GIT)) or (DokumentADRES_ID.AsString='') then begin
    l:=false;
  end else begin
    l:=true;
  end;
  lbOtnosh.Enabled:=l;
  edOtnosh.Enabled:=l;
  try
    if GridDeti.Columns[0].Visible then GridDeti.FieldColumns['OTNOSH_NAME'].Visible:=l;
  except

  end;
end;
//----------------------------------------------------------------
function TfmTalonPrib.ReadDok(nID: Integer): Boolean;
var
  i : Integer;
  fld : TField;
  strField : String;
begin
  NewDok(false);
  Result := true;
  if not dmBase.tbTalonPrib.Locate('ID', nID, []) then begin
    Result := false;
    exit;
  end;
  //------- читаем карточку -----------
  Dokument.Edit;
  for i:=0 to dmBase.tbTalonPrib.FieldCount-1 do begin
    strField := dmBase.tbTalonPrib.Fields[i].FieldName;
    fld := Dokument.FindField(strField);
    if fld <> nil then begin
      fld.Value := dmBase.tbTalonPrib.Fields[i].Value;
    end;
  end;
  if DokumentPROV.IsNull then DokumentPROV.AsBoolean:=true;
  if DokumentPASP_UDOST.IsNull then DokumentPASP_UDOST.AsInteger:=1;
  if DokumentIS_VUS.IsNull then DokumentIS_VUS.AsBoolean:=false;
  if DokumentNOMER_SEM.IsNull then DokumentNOMER_SEM.AsInteger:=0;
  if DokumentTYPEREG.IsNull then DokumentTYPEREG.AsInteger:=NOT_DVIG;

  Dokument.Post;
  if DokumentID.AsInteger > 0 then begin
    dmBase.tbTalonPribDeti.IndexName := 'PR_KEY';
    dmBase.tbTalonPribDeti.SetRange([DokumentID.AsInteger],[DokumentID.AsInteger]);
    with dmBase.tbTalonPribDeti do begin
      while not Eof do begin
        mtDeti.Append;
        mtDetiFAMILIA.AsString  := FieldByName('FAMILIA').AsString;
        mtDetiNAME.AsString     := FieldByName('NAME').AsString;
        mtDetiOTCH.AsString     := FieldByName('OTCH').AsString;
        mtDetiPOL.AsString      := FieldByName('POL').AsString;
        mtDetiDATER.AsString    := FieldByName('DATER').AsString;
        mtDetiOTNOSH.AsString   := FieldByName('OTNOSH').AsString;
        mtDetiCHILD_ID.AsString := FieldByName('CHILD_ID').AsString;
        mtDeti.Post;
        Next;
      end;
    end;
    dmBase.tbTalonPribDeti.CancelRange;
  end;
end;

//---------------------------------------------------------------
function TfmTalonPrib.AddLicTP: Boolean;
var
  ID : Integer;
begin
  ID:=AddLic(DokumentADRES_ID.AsString, DokumentDATEZ.AsDateTime);
  if (ID>0) then begin
    Dokument.CheckBrowseMode;
    Dokument.Edit;
    DokumentLICH_ID.AsInteger := ID;
    Dokument.Post;
    Result := true
  end else begin
    Result := false;
  end;
end;

//---------------------------------------------------------------
function TfmTalonPrib.EmptyLICH_ID: Boolean;
begin
  if (DokumentLICH_ID.AsString='') or (DokumentLICH_ID.AsString='0')
    then Result:=true
    else result:=false;
end;

//---------------------------------------------------------------
function TfmTalonPrib.WriteDok: Boolean;
var
  i, nID : Integer;
  fld : TField;
  strField, strErr : String;
  vKeyValues : Variant;
  dLastSost : TDateTime;
  lCheckEn, lAdd, lChangeLic, lAddLic, lCloseLic, lSeekMen : Boolean;
  nIdChild, nIdMen : Integer;
  s,strSoob, strLich, strOldLic, sKodOtnosh : String;
  nCurNomer:Integer;
  recID:TID;
begin
  lCheckEn:=false;
  strSoob := '';
  PostDataSet(Dokument);
  PostDataSet(mtDeti);
  Result := true;
  //--------------- проверка на ошибки ввода -------------
  strErr := '';
//  if DokumentDATEZ.IsNull then begin
//    strErr := ' Заполните дату проверки талона. ';
//  end else if DokumentDATE_SOST.AsString='' then begin
//    strErr := ' Заполните дату составления талона. ';
  if (DokumentADRES_ID.AsString='') or (DokumentADRES_ID.AsString='0') then begin
    strErr := ' Заполните адрес прописки. ';
  end else if DokumentCEL.AsString='' then begin
    strErr := ' Заполните цель приезда. ';
  end else if DokumentDATE_SOST.AsString='' then begin
    strErr := ' Заполните дату составления талона. ';
  end else if DokumentDATEZ.AsString='' then begin
    strErr := ' Заполните дату прописки. ';
  end else if (DokumentFAMILIA.AsString='') or (DokumentNAME.AsString='') then begin
    strErr := ' Заполните Фамилия, Имя. ';
  end else if (DokumentDETI.AsString <> '') or
              (mtDeti.RecordCount>0) then begin
    if (mtDeti.RecordCount>0) and (DokumentDETI.AsInteger<>mtDeti.RecordCount) then begin
      strErr := ' Количество детей не совпадает с реально введеным. ';
    end;
  end;
  if not DokumentDATE_SROK.IsNull and not DokumentDATEZ.IsNull then begin
    if DokumentDATE_SROK.AsDateTime < DokumentDATEZ.AsDateTime then begin
      strErr := ' Срок регистрации не может быть меньше даты прописки. ';
    end;
  end;
  if not DokumentDATE_SROK.IsNull and (GetDvig=MESTO_GIT) then begin
    strErr := ' Срок регистрации не может быть заполнен при регистрации по месту жительства. ';
  end;
  if strErr<>'' then begin
    PutError(strErr);
    Result := false;
    exit;
  end;
  nIdMen := -1;
  lAddLic := false;
  nCurNomer:=100;
  strOldLic := '';
  dLastSost := dmBase.LastDateSost;
  // если люди пепеезжают или создают новый личевой счет из существующего
  if ProvDvig and not EmptyLICH_ID then begin
    strOldLic := DokumentLICH_ID.AsString;
  end;
  //-------------------------------------------------------
  // если проводить вижение и не выбран лицевой счет
// было  if ProvDvig and (EmptyLICH_ID or (N_F_cbNewLich.Enabled and N_F_cbNewLich.Checked)) then begin
  if (GetDvig=MESTO_GIT) and (EmptyLICH_ID or (N_F_cbNewLich.Enabled and N_F_cbNewLich.Checked)) then begin
    if ((dLastSost = dmBase.GetDateCurrentSost) or (DokumentDATEZ.AsDateTime >= dLastSost)) then begin
      lAddLic := AddLicTP;
      if not lAddLic then begin
        Result := false;
        exit;
      end;
    end;
  end;

  if FCopyMen and (FCurLic=DokumentLICH_ID.AsInteger) then begin
    PutError('Нельзя скопировать человека на старый лицевой счет.');
    Result := false;
    exit;
  end;

  //-------------------------------------------------------
  // пропускаем поле ID
  if DokumentID.AsInteger = -1 then  begin
    dmBase.tbTalonPrib.Append;
    dmBase.tbTalonPrib.Post;
    nID := dmBase.tbTalonPrib.FieldByName('ID').AsInteger;
  end else begin
    nID := DokumentID.AsInteger;
    if not dmBase.tbTalonPrib.Locate('ID', nID, []) then begin
      Result := false;
    end;
  end;
  if Result then  begin
    EditDataSet(Dokument);
    DokumentID.AsInteger := nID;
    Dokument.Post;
    dmBase.tbTalonPrib.Edit;
    for i:=1 to dmBase.tbTalonPrib.FieldCount-1 do begin
      strField := dmBase.tbTalonPrib.Fields[i].FieldName;
      fld := Dokument.FindField(strField);
      if fld <> nil then begin
        dmBase.tbTalonPrib.Fields[i].Value := fld.Value;
      end;
    end;
    if DokumentADRES_ID.AsString<>''
      then dmBase.tbTalonPrib.FieldByName('ADRES_NAME').AsString:=dmBase.AdresFromID( dmBase.GetDateCurrentSost, DokumentADRES_ID.AsString)
      else dmBase.tbTalonPrib.FieldByName('ADRES_NAME').AsString:='';

    dmBase.tbTalonPrib.Post;

    AdditiveWriteDok;

    mtDeti.First;

    lChangeLic := false;
    strLich:='';
    if ProvDvig then begin
      lAdd := false;
//  было    if not EmptyLICH_ID and ( (dLastSost = dmBase.GetDateCurrentSost) or
//          (DokumentDATEZ.AsDateTime >= dLastSost) or ( (GetDvig=IZM_MEN) and (DokumentMEN_ID.AsInteger>0) )) then begin
      if ( (dLastSost=dmBase.GetDateCurrentSost) or (DokumentDATEZ.AsDateTime>=dLastSost) or ( (GetDvig=IZM_MEN) and (DokumentMEN_ID.AsInteger>0) ))
      then begin

        //------------------------------------------------------
        // проверим льготу, есть такая-же проверка после записи в базу
        if ((GetDvig=MESTO_GIT) or (GetDvig=MESTO_PREB)) and not lCheckEn
          then lCheckEn:=dmBase.CheckRunMen(_TypeObj_TalonPrib, CHECK_EN, DokumentMEN_ID.AsInteger, recID);
        //-------------------------------------------------------

        if EmptyLICH_ID then begin
          nCurNomer:=1;
          strLich:='Без лицевого счета';
        end else begin
          nCurNomer:=dmBase.CountMensEx(dmBase.GetDateCurrentSost, DokumentLICH_ID.AsString,'000',nil);
          nCurNomer:=nCurNomer+1;
          vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, DokumentLICH_ID.AsInteger);
          if dmBase.tbLich.Locate('DATE_FIKS;ID',vKeyValues,[]) then begin
            strLich := 'Лицевой счет '+Trim(dmBase.tbLich.FieldByName('NOMER').AsString);
          end;
        end;
        lSeekMen:=false;
        //------- копируем человека -----------------------------------------------------------
        if FCopyMen and (DokumentMEN_ID.AsInteger>0) then begin
          dmBase.CopyMen(fmMain.DateFiks,DokumentMEN_ID.AsString,DokumentLICH_ID.AsString,DokumentADRES_ID.AsString,0,FSaveMigr);
          nIdMen:=DokumentMEN_ID.AsInteger;
          if dmBase.tbMens.Locate('DATE_FIKS;ID',VarArrayOf([dmBase.GetDateCurrentSost,nIdMen]),[]) then begin
            EditDataSet(Dokument);
            DokumentMEN_ID.AsString:='';    // очистим старое значение ID, новое запишется ниже
            Dokument.Post;
            lSeekMen:=true;
          end;
        end;
        //---------------------------------------------------------------------------------------

        // человек еще не записывался  или сформирован путем копирования
        if (DokumentMEN_ID.AsString='') then begin
          // если есть лицевой счет
          if strLich<>'' then begin
            if nIdMen<=0 then begin
              nIdMen := dmBase.GetNewID(dmBase.TypeObj_Nasel);
            end;
            if nIdMen > -1 then begin
              // если был создан лицевой счет
              if lAddLic then begin
                nCurNomer:=1;
                EditDataSet(dmBase.tbLich);
                dmBase.tbLich.FieldByName('FIRST').AsInteger := nIdMen;
                dmBase.tbLich.FieldByName('OSNOV_ID').AsString := DokumentOSNOV_ID.AsString;
                dmBase.tbLich.FieldByName('OSNOV_NOMER').AsString := DokumentOSNOV_NOMER.AsString;
                WriteDateField(dmBase.tbLich.FieldByName('OSNOV_DATE'), DokumentOSNOV_DATE);
                dmBase.WriteValueProp('DOGOVOR', DokumentOSNOV.AsString, dmBase.GetDateCurrentSost,
                       dmBase.tbLich.FieldByName('ID').AsInteger, dmBase.TypeObj_Lich, ftMemo);
                dmBase.tbLich.Post;
              end;

              if lSeekMen
                then dmBase.tbMens.Edit
                else dmBase.tbMens.Append;

              // если был создан лицевой счет
              if lAddLic then begin
                dmBase.tbMens.FieldByName('FIRST').AsBoolean := true;
              end;
              dmBase.tbMens.FieldByName('DATE_FIKS').AsDateTime := dmBase.GetDateCurrentSost;
              dmBase.tbMens.FieldByName('ID').AsInteger         := nIdMen;
              if EmptyLICH_ID then begin
                dmBase.tbMens.FieldByName('LIC_ID').AsInteger:=0;
                dmBase.tbMens.FieldByName('NSTR').AsInteger:=1;
              end else begin
                dmBase.tbMens.FieldByName('LIC_ID').AsString:=DokumentLICH_ID.AsString;
                dmBase.tbMens.FieldByName('NSTR').AsInteger :=nCurNomer;
              end;
              nCurNomer:=nCurNomer+1;
              dmBase.tbMens.Post;
              lAdd := true;
              EditDataSet(Dokument);
              DokumentMEN_ID.AsInteger := nIdMen;
              DokumentPROV.AsBoolean:=true;
              PostDataSet(Dokument);
              EditDataSet(dmBase.tbTalonPrib);
              dmBase.tbTalonPrib.FieldByName('MEN_ID').AsInteger :=nIdMen;
              dmBase.tbTalonPrib.FieldByName('PROV').AsBoolean   :=true;
              dmBase.tbTalonPrib.FieldByName('TYPEREG').AsInteger:=IZM_MEN;
              PostDataSet(dmBase.tbTalonPrib);
            end;
          end;
        end else begin
          vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, DokumentMEN_ID.AsInteger);
          if dmBase.tbMens.Locate('DATE_FIKS;ID',vKeyValues,[]) then begin
            nIdMen := DokumentMEN_ID.AsInteger;
          end;
        end;
        if nIDMen > 0 then begin
          //--------- запишем в базу движний человека ------------------
          if not lAdd and (GetDvig=IZM_MEN) then begin // изменить данные о человеке
           // не пишем движение при изменении данных о человеке
          end else begin
            WriteDvigMen(nIdMen);
          end;

          // запишем откуда прибыл в адрес регистрации вне террритории совета
          if GetDvig=MESTO_PREB then begin
            s:=dmBase.GetMestoFromFields(Dokument,';GOSUD_O;B_OBL_O;OBL_O;RAION_O;GOROD_O_B;GOROD_O',false,0);
            if (DokumentUL_O.AsString<>'') and (s<>'') then s:=s+','+DokumentUL_O.AsString;
            dmBase.WriteValueProp('ADRES_PROP', s, dmBase.GetDateCurrentSost, nIdMen, _TypeObj_Nasel, ftMemo);
          end;

          dmBase.tbMens.Edit;

          // может человек сменил адрес и переехал на другой лицевой счет
          if not EmptyLICH_ID then begin
            if dmBase.tbMens.FieldByName('LIC_ID').AsString<>DokumentLICH_ID.AsString then begin
              vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, dmBase.tbMens.FieldByName('LIC_ID').AsInteger);
              // если есть лицевой счет
              if dmBase.tbLich.Locate('DATE_FIKS;ID',vKeyValues,[]) then begin
                if (dmBase.tbLich.FieldByName('FIRST').AsString<>'') and
                   (dmBase.tbLich.FieldByName('FIRST').AsInteger=nIdMen) then begin
                  dmBase.tbLich.Edit;
                  dmBase.tbLich.FieldByName('FIRST').AsString := '';
                  dmBase.tbLich.Post;
                end;
              end;
              dmBase.tbMens.FieldByName('LIC_ID').AsString := DokumentLICH_ID.AsString;
              lChangeLic := true;
            end;
          end;

          dmBase.tbMens.FieldByName('FAMILIA').AsString := DokumentFamilia.AsString;
          dmBase.tbMens.FieldByName('NAME').AsString    := DokumentName.AsString;
          dmBase.tbMens.FieldByName('OTCH').AsString    := DokumentOtch.AsString;
          dmBase.tbMens.FieldByName('DATER').AsDateTime := DokumentDateR.AsDateTime;
          dmBase.tbMens.FieldByName('POL').AsString     := DokumentPOL.AsString;
          if DokumentTELEFON.AsString<>''
            then dmBase.tbMens.FieldByName('TELEFON').AsString := DokumentTELEFON.AsString;
          dmBase.tbMens.FieldByName('OBRAZ').AsString   := DokumentOBRAZ.AsString;
          dmBase.tbMens.FieldByName('NATION').AsString  := DokumentNATION.AsString;
          dmBase.tbMens.FieldByName('CITIZEN').AsString := DokumentCITIZEN.AsString;
          dmBase.tbMens.FieldByName('SEM').AsString     := DokumentSEM.AsString;
// было         if not lAddLic and not EmptyLICH_ID and (DokumentOTNOSH.AsString<>'') then begin
          if (not EmptyLICH_ID or lAddLic) and (DokumentOTNOSH.AsString<>'') then begin
            dmBase.tbMens.FieldByName('OTNOSH').AsString  := DokumentOTNOSH.AsString;
          end;

          dmBase.tbMens.FieldByName('PASP_UDOST').AsString := DokumentPASP_UDOST.AsString;
          dmBase.tbMens.FieldByName('PASP_SERIA').AsString := DokumentPASP_SERIA.AsString;
          dmBase.tbMens.FieldByName('PASP_NOMER').AsString := DokumentPASP_NOMER.AsString;
          dmBase.tbMens.FieldByName('PASP_DATE').AsString  := DokumentPASP_DATE.AsString;
          dmBase.tbMens.FieldByName('PASP_SROK').AsString  := DokumentPASP_SROK.AsString;
          dmBase.tbMens.FieldByName('LICH_NOMER').AsString := DokumentLICH_NOMER.AsString;

          if DokumentWORK_SPR.AsString<>'' then begin
            if dmBase.SprWork.Locate('ID', DokumentWORK_SPR.AsString, []) then begin
              dmBase.tbMens.FieldByName('WORK_SPR').AsString := DokumentWORK_SPR.AsString;
            end else begin
              dmBase.tbMens.FieldByName('WORK_SPR').AsString := '';
            end;
          end else begin
            dmBase.WriteProp(dmBase.GetDateCurrentSost, nIDMen, Dokument, 'WORK_NAME', dmBase.TypeObj_Nasel);
          end;

          dmBase.tbMens.FieldByName('DOLG_NAME').AsString  := DokumentDOLG_NAME.AsString;
          if DokumentDOLG_SPR.AsString<>''
            then dmBase.tbMens.FieldByName('DOLG_SPR').AsString  := DokumentDOLG_SPR.AsString;

          if DokumentWORK_NAME.AsString<>'' then begin
            dmBase.tbMens.FieldByName('ISWORK').AsInteger  := 1;
          end;
          dmBase.tbMens.FieldByName('PENS_TIP').AsString  := '';
          if DokumentISTOC.AsString = '1' then begin // пенсионер
            dmBase.tbMens.FieldByName('PENS_TIP').AsString  := '1';
          end else if DokumentISTOC.AsString = '2' then begin // учится
          end else begin
          end;

          dmBase.WriteProp(dmBase.GetDateCurrentSost, nIDMen, Dokument, 'PASP_VIDAN', dmBase.TypeObj_Nasel);
//        dmBase.WriteProp(DateFiks, ID, mtDokument, 'WORK_NAME', dmBase.TypeObj_Nasel);

          if EmptyLICH_ID then begin
            dmBase.tbMens.FieldByName('KATEG').AsInteger:=ADRES_NOTREG; //человек без регистр. и без лицевого, но фактически проживает
          end else begin
            if GetDvig=MESTO_GIT
              then dmBase.tbMens.FieldByName('KATEG').AsInteger := LIC_REG      // человек на лицевом с регистрацией
              else dmBase.tbMens.FieldByName('KATEG').AsInteger := LIC_NOTREG;  // человек на лицевом без регистрации
          end;
          // --- региcтрация ---------------------------------------------------------------------------
          if not lAdd and ProvDvig and (GetDvig=IZM_MEN) then begin // изменить данные о человеке
           // не пишем дату прописки при изменении данных о человеке
          end else begin
            dmBase.tbMens.FieldByName('DATEP').AsDateTime := GetDateProp;
            dmBase.tbMens.FieldByName('DATEV').AsString   := '';
          end;
          dmBase.tbMens.FieldByName('NOMER_SEM').AsInteger:=DokumentNOMER_SEM.AsInteger;
          dmBase.tbMens.FieldByName('PRESENT').AsBoolean:=true;

          if (GetDvig=MESTO_GIT) then begin
            dmBase.tbMens.FieldByName('PROPIS').AsBoolean:=true;
            WriteDateField(dmBase.tbMens.FieldByName('DATE_SROK_DN'), DokumentDATE_SROK_DN);
          end else if (GetDvig=MESTO_PREB) then begin
            dmBase.tbMens.FieldByName('PROPIS').AsBoolean:=false;
            WriteDateField(dmBase.tbMens.FieldByName('DATE_SROK'), DokumentDATE_SROK);
          end;
          //--------------------------------------------------------------------------------------------

          dmBase.tbMens.FieldByName('CANDELETE').AsBoolean := false;
          dmBase.tbMens.FieldByName('ADRES_ID').AsString   := DokumentADRES_ID.AsString;
          dmBase.tbMens.Post;

          //------ ВУС ------------------------------------
          if DokumentIS_VUS.AsBoolean then begin
            if not dmBase.tbVUS.Locate('ID', nIDMen,[]) then begin
              dmBase.tbVUS.Append;
              dmBase.tbVUS.FieldByName('ID').AsInteger:=nIDMen;
              dmBase.tbVUS.FieldByName('PRIZ').AsBoolean:=false;
              dmBase.tbVUS.FieldByName('ZVAN').Asstring:=DokumentZVAN.AsString;
              WriteDateField(dmBase.tbVUS.FindField('PRIB_DATE'),DokumentPRIB_DATE);
              dmBase.tbVUS.Post;
            end else begin
              dmBase.tbVUS.Edit;
              if dmBase.tbVUS.FieldByName('ZVAN').AsString=''
                then dmBase.tbVUS.FieldByName('ZVAN').Asstring:=DokumentZVAN.AsString;
              if dmBase.tbVUS.FindField('PRIB_DATE').IsNull
                then WriteDateField(dmBase.tbVUS.FindField('PRIB_DATE'),DokumentPRIB_DATE);
              dmBase.tbVUS.Post;
            end;
            dmBase.tbMens.Edit;
            dmBase.tbMens.FieldByName('VUS').AsBoolean:=true;
            dmBase.tbMens.Post;
          end;

          //------ запишем место рождения человека ------------
          with dmBase.tbMensAdd do begin
            if not Locate('ID', nIDMen, []) then begin
              Append;
              FieldByName('ID').AsInteger:=nIDMen;
              Post;
            end;
            Edit;
            if (DokumentOBL_R.AsString<>'') or (DokumentRAION_R.AsString<>'') or (DokumentGOROD_R.AsString<>'') then begin
              FieldByName('MR_B_RESP').AsString:='';
              WriteField( FieldByName('MR_GOSUD')  , DokumentGOSUD_R); //   , lErr);
              WriteField( FieldByName('MR_B_OBL')  , DokumentB_OBL_R); //   , lErr);
              WriteField( FieldByName('MR_OBL')    , DokumentOBL_R); //     , lErr);
              WriteField( FieldByName('MR_RAION')  , DokumentRAION_R); //   , lErr);
              WriteField( FieldByName('MR_B_GOROD'), DokumentGOROD_R_B); // , lErr);
              WriteField( FieldByName('MR_GOROD')  , DokumentGOROD_R); //   , lErr);
            end;
            if dmBase.CheckWriteOtkudaPrib(dmBase.tbMensAdd) then begin
              FieldByName('OP_B_RESP').AsString:='';
              WriteField( FieldByName('OP_GOSUD')  , DokumentGOSUD_O); //   , lErr);
              WriteField( FieldByName('OP_B_OBL')  , DokumentB_OBL_O); //   , lErr);
              WriteField( FieldByName('OP_OBL')    , DokumentOBL_O); //     , lErr);
              WriteField( FieldByName('OP_RAION')  , DokumentRAION_O); //   , lErr);
              WriteField( FieldByName('OP_B_GOROD'), DokumentGOROD_O_B); // , lErr);
              WriteField( FieldByName('OP_GOROD')  , DokumentGOROD_O); //   , lErr);
              WriteField( FieldByName('OP_DATE')   , DokumentDATE_O); //   , lErr);
            end;

            Post;
          end;
          //------------------------------------------------------
          // может что-то поменялось после записи в базу, есть такая-же проверка до записи в базу
          if ((GetDvig=MESTO_GIT) or (GetDvig=MESTO_PREB)) and not lCheckEn
            then lCheckEn:=dmBase.CheckRunMen(_TypeObj_TalonPrib,CHECK_EN,nIDMen,recID);
          //-------------------------------------------------------

          strSoob := strSoob + DokumentFamilia.AsString+' '+DokumentName.AsString+' '+DokumentOtch.AsString+' ';
          if DokumentPOL.AsString='М' then begin
            if lChangeLic then begin
              strSoob := strSoob + 'перемещен '+#13
            end else begin
              if lAdd
                then strSoob := strSoob + 'добавлен '+#13
                else strSoob := strSoob + 'скорректирован '+#13;
            end;
          end else begin
            if lChangeLic then begin
              strSoob := strSoob + 'перемещена '+#13
            end else begin
              if lAdd
                then strSoob := strSoob + 'добавлена '+#13
                else strSoob := strSoob + 'скорректирована '+#13;
            end;
          end;
        end else begin // человека не нашли, а уже записывался ОШИБКА!!!
          strSoob := ' Невозможно провести заново талон прибытия.'+Chr(13)+
                     ' Человек в базе населения не найден! ';
        end;
      end;
    end;

    //-----------------------------------------------------------
    //-------------- ЗАПИСЬ ДЕТЕЙ -------------------------------
    //-----------------------------------------------------------
    while dmBase.tbTalonPribDeti.Locate('ID',DokumentID.AsInteger,[])
      do dmBase.tbTalonPribDeti.Delete;
    with dmBase.tbTalonPribDeti do begin
      while not mtDeti.Eof do begin
        nIdChild := -1;
        lAdd := false;
        if ProvDvig then begin
          if not EmptyLICH_ID and
             ((dLastSost = dmBase.GetDateCurrentSost) or (DokumentDATEZ.AsDateTime >= dLastSost)) then begin
             //=== 05.09.2018 =========================
            lSeekMen:=false;
            if FCopyMen and (mtDetiCHILD_ID.AsInteger>0) then begin  //------- копируем ребенка
              dmBase.CopyMen(fmMain.DateFiks,mtDetiCHILD_ID.AsString,DokumentLICH_ID.AsString,DokumentADRES_ID.AsString,0,FSaveMigr);
              nIdChild:=mtDetiCHILD_ID.AsInteger;
              if dmBase.tbMens.Locate('DATE_FIKS;ID',VarArrayOf([dmBase.GetDateCurrentSost,nIdChild]),[]) then begin
                EditDataSet(mtDeti);
                mtDetiCHILD_ID.AsString:='';    // очистим старое значение ID, новое запишется ниже
                mtDeti.Post;
                lSeekMen:=true;
              end;
            end;
            //=========================================
            // у ребенка нет ид. и он не записывался
            if mtDetiCHILD_ID.AsString='' then begin
              vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, DokumentLICH_ID.AsInteger);
              if dmBase.tbLich.Locate('DATE_FIKS;ID',vKeyValues,[]) then begin
                //=== 05.09.2018 ===========================
                if nIdChild<=0 then begin
                  nIdChild := dmBase.GetNewID(dmBase.TypeObj_Nasel);
                end;
                //!!!nIdChild := dmBase.GetNewID(dmBase.TypeObj_Nasel);
                //==========================================
                if nIdChild > -1 then begin
                  //=== 05.09.2018 =======================
                  if lSeekMen
                    then dmBase.tbMens.Edit
                    else dmBase.tbMens.Append;
                  //!!!dmBase.tbMens.Append;
                  //======================================
                  dmBase.tbMens.FieldByName('DATE_FIKS').AsDateTime := dmBase.GetDateCurrentSost;
                  dmBase.tbMens.FieldByName('ID').AsInteger         := nIdChild;
                  dmBase.tbMens.FieldByName('LIC_ID').AsString      := DokumentLICH_ID.AsString;

                  dmBase.tbMens.FieldByName('NSTR').AsInteger       := nCurNomer;
                  nCurNomer:=nCurNomer+1;

                  // если добавили новый лицевой счет, то дети должны иметь отношение как: сын, дочь
                  if lAddLic then begin
                    sKodOtnosh:='';
                    if mtDetiOTNOSH.AsString='' then begin
                      if mtDetiPOL.AsString='М' then begin
                        if dmBase.SprOtnosh.Locate('NAME','сын',[loCaseInsensitive])
                          then sKodOtnosh:=dmBase.SprOtnosh.FieldByName('ID').AsString;
                      end else begin
                        if dmBase.SprOtnosh.Locate('NAME','дочь',[loCaseInsensitive])
                          then sKodOtnosh:=dmBase.SprOtnosh.FieldByName('ID').AsString;
                      end;
                    end else begin
                      sKodOtnosh := mtDetiOTNOSH.AsString;
                    end;
                    if sKodOtnosh<>''
                      then dmBase.tbMens.FieldByName('OTNOSH').AsString := sKodOtnosh;
                  end else begin
                    if mtDetiOTNOSH.AsString<>'' then
                      dmBase.tbMens.FieldByName('OTNOSH').AsString := mtDetiOTNOSH.AsString;
                  end;

                  dmBase.tbMens.Post;
                  lAdd := true;
                  EditDataSet(mtDeti);
                  mtDetiCHILD_ID.AsInteger := nIdChild;
                  PostDataSet(mtDeti);
                end;
              end;
            end else begin
              vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, mtDetiCHILD_ID.AsInteger);
              if dmBase.tbMens.Locate('DATE_FIKS;ID',vKeyValues,[]) then begin
                nIdChild := mtDetiCHILD_ID.AsInteger;
              end;
            end;
            if nIdChild > 0 then begin
              dmBase.tbMens.Edit;
              if not lAdd and ProvDvig and (GetDvig=IZM_MEN) then begin // изменить данные о человеке
                // не пишем движение при изменении данных о человеке
              end else begin
                WriteDvigMen(nIdChild);
                dmBase.tbMens.FieldByName('DATEP').AsDateTime := GetDateProp;
                dmBase.tbMens.FieldByName('DATEV').AsString   := '';
              end;
              if mtDetiFamilia.AsString='' then begin
                dmBase.tbMens.FieldByName('FAMILIA').AsString := DokumentFamilia.AsString;
              end else begin
                dmBase.tbMens.FieldByName('FAMILIA').AsString := mtDetiFamilia.AsString;
              end;
              dmBase.tbMens.FieldByName('NAME').AsString    := mtDetiName.AsString;
              dmBase.tbMens.FieldByName('OTCH').AsString    := mtDetiOTCH.AsString;
              dmBase.tbMens.FieldByName('DATER').AsDateTime := mtDetiDATER.AsDateTime;
              if mtDetiOTNOSH.AsString<>'' then
                 dmBase.tbMens.FieldByName('OTNOSH').AsString := mtDetiOTNOSH.AsString;
              dmBase.tbMens.FieldByName('POL').AsString     := mtDetiPOL.AsString;
              dmBase.tbMens.FieldByName('KATEG').AsInteger := LIC_REG;
              dmBase.tbMens.FieldByName('NOMER_SEM').AsInteger := DokumentNOMER_SEM.AsInteger;
              dmBase.tbMens.FieldByName('PRESENT').AsBoolean   := true;
              if DokumentTYPEREG.AsInteger=MESTO_GIT then begin
                dmBase.tbMens.FieldByName('PROPIS').AsBoolean:=true;
                WriteDateField(dmBase.tbMens.FieldByName('DATE_SROK_DN'), DokumentDATE_SROK_DN);
              end else if (GetDvig=MESTO_PREB) then begin
                dmBase.tbMens.FieldByName('PROPIS').AsBoolean:=false;
                WriteDateField(dmBase.tbMens.FieldByName('DATE_SROK'), DokumentDATE_SROK);
              end;
              //------------------------------------------------------------------------------
              dmBase.tbMens.FieldByName('CANDELETE').AsBoolean := false;
              dmBase.tbMens.FieldByName('ADRES_ID').AsString   := DokumentADRES_ID.AsString;
              dmBase.tbMens.FieldByName('LIC_ID').AsString     := DokumentLICH_ID.AsString;

              dmBase.tbMens.FieldByName('LIC_ID').AsString     := DokumentLICH_ID.AsString;

              if nIdMen>-1 then begin
                if DokumentPOL.AsString='Ж'
                  then dmBase.tbMens.FieldByName('MA_ID').AsInteger := nIdMen
                  else dmBase.tbMens.FieldByName('PA_ID').AsInteger := nIdMen;
              end;


              dmBase.tbMens.Post;

              //------ запишем откуда прибыл для ребенка ------------
              with dmBase.tbMensAdd do begin
                if not Locate('ID', nIdChild, []) then begin
                  Append;
                  FieldByName('ID').AsInteger:=nIdChild;
                  Post;
                end;
                Edit;
                if dmBase.CheckWriteOtkudaPrib(dmBase.tbMensAdd) then begin
                  FieldByName('OP_B_RESP').AsString:='';
                  WriteField( FieldByName('OP_GOSUD')  , DokumentGOSUD_O); //   , lErr);
                  WriteField( FieldByName('OP_B_OBL')  , DokumentB_OBL_O); //   , lErr);
                  WriteField( FieldByName('OP_OBL')    , DokumentOBL_O); //     , lErr);
                  WriteField( FieldByName('OP_RAION')  , DokumentRAION_O); //   , lErr);
                  WriteField( FieldByName('OP_B_GOROD'), DokumentGOROD_O_B); // , lErr);
                  WriteField( FieldByName('OP_GOROD')  , DokumentGOROD_O); //   , lErr);
                  WriteField( FieldByName('OP_DATE')   , DokumentDATE_O); //   , lErr);
                end;
                Post;
              end;
              //------------------------------------------------------

              strSoob := strSoob + dmBase.tbMens.FieldByName('FAMILIA').AsString+' '+mtDetiName.AsString+' '+mtDetiOTCH.AsString+' ';
              if mtDetiPOL.AsString='М' then begin
                if lChangeLic then begin
                  strSoob := strSoob + 'перемещен '+#13
                end else begin
                  if lAdd
                    then strSoob := strSoob + 'добавлен '+#13
                    else strSoob := strSoob + 'скорретирован '+#13;
                end;
              end else begin
                if lChangeLic then begin
                  strSoob := strSoob + 'перемещена '+#13
                end else begin
                  if lAdd
                    then strSoob := strSoob + 'добавлена '+#13
                    else strSoob := strSoob + 'скорретирована '+#13;
                end;
              end;
            end else begin

            end;
          end;
        end;
        Append;
        FieldByName('ID').Value := nID;
        if mtDetiFamilia.AsString='' then begin
          FieldByName('FAMILIA').AsString:= DokumentFamilia.AsString;
        end else begin
          FieldByName('FAMILIA').AsString:= mtDetiFamilia.AsString;
        end;
        FieldByName('NAME').AsString   := mtDetiNAME.AsString;
        FieldByName('OTCH').AsString   := mtDetiOTCH.AsString;
        FieldByName('POL').AsString    := mtDetiPOL.AsString;
        FieldByName('OTNOSH').AsString := mtDetiOTNOSH.AsString;
        FieldByName('DATER').AsString  := mtDetiDATER.AsString;
        FieldByName('CHILD_ID').AsString  := mtDetiCHILD_ID.AsString;
        Post;
        mtDeti.Next;
      end;
    end;
    mtDeti.First;
    //------------- конец записи детей ---------------------------------------

    //------ может надо ликвидировть лиц. счет --------------------------------------
    if (strOldLic<>'') and (lAddLic or lChangeLic) then begin
      //-------- убыл последний член хозяйства --------
      if dmBase.CountMens(dmBase.GetDateCurrentSost, strOldLic)=0
        then lCloseLic := true
        else lCloseLic := false;
      vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, StrToInt(strOldLic));
      //------------------------------------------------
      if dmBase.tbLich.Locate('DATE_FIKS;ID', vKeyValues, []) then begin
        if lCloseLic then begin
          dmBase.tbLich.Edit;
          dmBase.tbLich.FieldByName('CANDELETE').AsBoolean  := true;
          dmBase.tbLich.FieldByName('DATE_LIKV').AsDateTime := DokumentDATEZ.AsDateTime;
          dmBase.tbLich.Post;
          strSoob := ' С лицевого счета <'+dmBase.tbLich.FieldByName('NOMER').AsString+'> убыл последний человек ! '#13'Лицевой счет ликвидирован.';
        end;
      end;
    end;
    //---------------------------------------------------------------------
    if strSoob <> '' then begin
      ShowMessage(strLich + #13 + strSoob);
    end;
    if Result then QueryExit:=false;
  end;
  if lCheckEn then begin
    SystemProg.SetRunMenReport(recID, 2{'SprMGS'});
  end;
end;

//-----------------------------------------------------------
function TfmTalonPrib.GetDateProp:TDateTime;
begin
  Result:=DokumentDATEZ.AsDateTime;
end;

//-----------------------------------------------------------
// записать движение человека
procedure TfmTalonPrib.WriteDvigMen( nIDMen : Integer);
var
  vKeyValues, vKeyValuesD : Variant;
  lSeek : Boolean;
begin
  lSeek := false;
  vKeyValues := VarArrayCreate( [0, 3], varOleStr );
  vKeyValues[0] := dmBase.GetDateCurrentSost;
  vKeyValues[1] := nIdMen;
  vKeyValues[2] := 1; // прибыл
  vKeyValues[3] := DokumentID.AsInteger;
  if dmBase.tbMensDvig.Locate('DATE_FIKS;ID;TIP;TALON', vKeyValues,[]) then begin
    lSeek := true;
  end else begin
    vKeyValuesD := VarArrayCreate( [0, 3], varOleStr );
    vKeyValuesD[0] := dmBase.GetDateCurrentSost;
    vKeyValuesD[1] := nIdMen;
    vKeyValuesD[2] := DokumentDATEZ.AsDateTime;
    if dmBase.tbMensDvig.Locate('DATE_FIKS;ID;DATE', vKeyValuesD,[]) then begin
      lSeek := true;
    end;
  end;
  if lSeek then begin
    dmBase.tbMensDvig.Edit;
  end else begin
    dmBase.tbMensDvig.Append;
    dmBase.tbMensDvig.FieldByName('DATE_FIKS').AsDateTime := dmBase.GetDateCurrentSost;
    dmBase.tbMensDvig.FieldByName('ID').AsInteger         := nIdMen;
  end;
  dmBase.tbMensDvig.FieldByName('TIP').AsInteger    := 1;  // прибыл
  dmBase.tbMensDvig.FieldByName('TALON').AsInteger  := DokumentID.AsInteger;
  dmBase.tbMensDvig.FieldByName('DATE').AsDateTime  := GetDateProp;
  dmBase.tbMensDvig.FieldByName('PRICH').AsInteger  := DokumentCEL.AsInteger;
  dmBase.tbMensDvig.FieldByName('ORGAN').AsString   := DokumentORGAN.AsString;
  if DokumentTYPEREG.AsInteger=MESTO_GIT
    then dmBase.tbMensDvig.FieldByName('CONTANT').AsString:='1'
    else dmBase.tbMensDvig.FieldByName('CONTANT').AsString:='0';
  if edDateSrok.Field.IsNull
    then dmBase.tbMensDvig.FieldByName('DATE_SROK').AsString:=''
    else dmBase.tbMensDvig.FieldByName('DATE_SROK').AsdateTime:=edDateSrok.Field.AsDateTime;
  dmBase.tbMensDvig.FieldByName('OP_B_RESP').AsString:='';
  dmBase.tbMensDvig.FieldByName('OP_GOSUD').AsString:=DokumentGOSUD_O.AsString;
  dmBase.tbMensDvig.FieldByName('OP_B_OBL').AsBoolean:=DokumentB_OBL_O.AsBoolean;
  dmBase.tbMensDvig.FieldByName('OP_OBL').AsString:=DokumentOBL_O.AsString;
  dmBase.tbMensDvig.FieldByName('OP_RAION').AsString:=DokumentRAION_O.AsString;
  dmBase.tbMensDvig.FieldByName('OP_B_GOROD').AsString:=DokumentGOROD_O_B.AsString;
  dmBase.tbMensDvig.FieldByName('OP_GOROD').AsString:=DokumentGOROD_O.AsString;

  dmBase.tbMensDvig.FieldByName('KOMM').AsString:=dmBase.GetMestoFromFields(Dokument,';GOSUD_O;B_OBL_O;OBL_O;RAION_O;GOROD_O_B;GOROD_O',false,0);
  dmBase.tbMensDvig.Post;
end;

procedure TfmTalonPrib.edPolChange(Sender: TObject);
begin
  if edPol.Value<>null then begin
    if edPol.Value='М' then begin
      edNATION.ListField:='NAME_M'
    end else if edPol.Value='Ж' then begin
      edNATION.ListField:='NAME_G'
    end else begin
    edNATION.ListField:='NAME'
    end;
  end else begin
    edNATION.ListField:='NAME'
  end;
end;

procedure TfmTalonPrib.UpdateActions;
begin
  inherited;
  if edSem.ItemIndex <> 0 then begin
    N_F_edSuprug.Enabled := false;
    if DokumentSUPRUG.AsBoolean then begin
      EditDataSet(Dokument);
      DokumentSUPRUG.AsBoolean := false;
    end;
  end else begin
    N_F_edSuprug.Enabled := true;
  end;
  if DokumentWORK_SPR.AsString='' then begin
    if edWork_Name.Font.Style <> [] then edWork_Name.Font.Style := [];
  end else begin
    if edWork_Name.Font.Style <> [fsBold] then edWork_Name.Font.Style := [fsBold];
  end;

  if DokumentDOLG_SPR.AsString='' then begin
    if edDolg_Name.Font.Style <> [] then edDolg_Name.Font.Style := [];
  end else begin
    if edDolg_Name.Font.Style <> [fsBold] then edDolg_Name.Font.Style := [fsBold];
  end;

//  if DokumentMEN_ID.AsString='' then begin
//    edFamilia.Font.Color := clBlack;
//  end else begin
//    edFamilia.Font.Color := clRed;
//  end;
end;

procedure TfmTalonPrib.dsDokumentDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  if Field <> nil then begin
  end;
end;

procedure TfmTalonPrib.TextAdresGetText(Sender: TObject; var Text: String);
var
  vKeyValues : Variant;
begin
  if DokumentADRES_ID.AsString<>'' then begin
    Text := dmBase.AdresFromID( dmBase.GetDateCurrentSost, DokumentADRES_ID.AsString );
    if not EmptyLICH_ID then begin
      vKeyValues := dmBase.CreateSeek( dmBase.GetDateCurrentSost, DokumentLICH_ID.AsInteger);
      if dmBase.tbLich.Locate('DATE_FIKS;ID', vKeyValues, []) then begin
        Text := 'Лиц.счет '+Trim(dmBase.tbLich.FieldByName('NOMER').AsString)+' : '+Text;
      end;
    end;
  end;
end;

procedure TfmTalonPrib.edTypeRegChange(Sender: TObject);
begin
  N_F_cbNewLich.Checked:=false;
  CheckPanelLic;
end;

procedure TfmTalonPrib.edTypeRegUpdateData(Sender: TObject; var Handled: Boolean);
begin
  if GetDvig=MESTO_GIT then begin
    edSrok.Text:='';
    edDateSrok.Text:='';
  end;
end;

procedure TfmTalonPrib.btAdresClick(Sender: TObject);
var
  nIDAdres:Integer;
//  strLich : string;
begin
  nIDAdres:=0;
  if fmChoiceAdres= nil then begin
    fmChoiceAdres := TfmChoiceAdres.Create(nil);
  end;
  fmChoiceAdres.DateFiks := dmBase.GetDateCurrentSost;
  fmChoiceAdres.ChoiceLich := true;
  if fmChoiceAdres.ShowModal = mrOk then begin
    nIDADRES := fmChoiceAdres.IDAdres;
  end;
  if nIDAdres>0 then begin
    N_F_cbNewLich.Checked:=false;
    EditDataSet(Dokument);
    DokumentADRES_ID.AsInteger := fmChoiceAdres.IDAdres;
    DokumentOTNOSH.AsString:='';
    {$IFNDEF GKH}
    if edTypeReg.Visible then begin
//      edDvig.Enabled := true;
      if GetDvig=NOT_DVIG
        then edTypeReg.ItemIndex:=0;
    end;
    {$ENDIF}
    if fmChoiceAdres.IDLich > 0 then begin
      DokumentLICH_ID.AsInteger := fmChoiceAdres.IDLich;
    end else begin
      DokumentLICH_ID.AsString  := '0';
    end;
    PostDataSet(Dokument);
    CheckPanelLic;
  end;
end;

function TfmTalonPrib.BeforeEdit: Boolean;
var
  n:Integer;
begin
  Result := inherited BeforeEdit;
  if Result then begin
  {
    if DokumentID.AsInteger>0 then begin
      if edTypeReg.Visible and edTypeReg.Enabled then begin
        EditDataSet(Dokument);
        if DokumentPROV.AsBoolean
          then edTypereg.ItemIndex := 1
          else edDvig.ItemIndex := 0;
      end;
    end;
  }
  end;
  if FFromMen then begin
    FEnableWrite:=false;
    TBItemUbit.Visible:=false;
    TBItemWrite.Visible:=false;
    edTypeReg.Visible:=false;
    edFamilia.EditButtons[0].Visible:=false;
  end;
// в методе Create отключена проверка FCheckLookupField:=false
  n:=LimitMRUList(3);
  SetMRUList(edGOROD_R,n,3,true,false,false,FAddButtonMRUList_Punkt);
  SetMRUList(edGOROD_O,n,3,true,false,false,FAddButtonMRUList_Punkt);

  n:=LimitMRUList(1);
  SetMRUList(edOBL_R,n,1,true,false,false,FAddButtonMRUList);
  SetMRUList(edOBL_O,n,1,true,false,false,FAddButtonMRUList);

  n:=LimitMRUList(2);
  SetMRUList(edRAION_R,n,2,true,false,false,FAddButtonMRUList);
  SetMRUList(edRAION_O,n,2,true,false,false,FAddButtonMRUList);

end;

procedure TfmTalonPrib.CheckEnabledDeti;
begin
{
  if FCopyMen then begin
    mtDeti.EmptyTable;
    mtDeti.ReadOnly:=true;
    GridDeti.Enabled:=false;
    btAddChild.Enabled:=false;
    btDelChild.Enabled:=false;
  end else begin
    mtDeti.ReadOnly:=false;
    GridDeti.Enabled:=true;
    btAddChild.Enabled:=true;
    btDelChild.Enabled:=true;
  end;
}
end;

//------------------------------------------------------------------------------------
procedure TfmTalonPrib.WriteDokumentFromArr(arrRec : TCurrentRecord; lDeti:Boolean);
var
  v : Variant;
  nID : Integer;
  p : TPassport;
  ListDeti:TDataSet;
  sKodOtnosh:String;
begin
   nID:=GetValueFieldEx(arrRec, 'ID', 0);
   if nID >0 then begin
      EditDataSet(Dokument);
      DokumentMEN_ID.AsInteger := nID;
      v := GetValueField(arrRec, 'FAMILIA');
      if v = null then DokumentFAMILIA.AsString := ''
                  else DokumentFAMILIA.AsString := v;
      v := GetValueField(arrRec, 'NAME');
      if v = null then DokumentNAME.AsString := ''
                  else DokumentNAME.AsString := v;
      v := GetValueField(arrRec, 'OTCH');
      if v = null then DokumentOTCH.AsString := ''
                  else DokumentOTCH.AsString := v;
      v := GetValueField(arrRec, 'DATER');
      if v = null then DokumentDateR.AsString := ''
                  else DokumentDateR.Value    := v;
      v := GetValueField(arrRec, 'NATION');
      if v = null then DokumentNATION.AsInteger:= 0
                  else DokumentNATION.Value    := v;
      v := GetValueField(arrRec, 'CITIZEN');
      if v = null then DokumentCITIZEN.AsInteger:= 0
                  else DokumentCITIZEN.Value    := v;
      v := GetValueField(arrRec, 'OBRAZ');
      if v = null then DokumentOBRAZ.AsString := ''
                  else DokumentOBRAZ.Value    := v;
      v := GetValueField(arrRec, 'POL');
      if v <> null then DokumentPOL.Value := v;
      v := GetValueField(arrRec, 'SEM');
      if v = null then DokumentSEM.AsString := ''
                  else DokumentSEM.Value    := v;

      v := GetValueField(arrRec, 'TELEFON');
      if v = null then DokumentTELEFON.AsString := ''
                  else DokumentTELEFON.Value    := v;

      nID := DokumentMEN_ID.AsInteger;

      DokumentWORK_NAME.AsString := dmBase.GetWork(nId, arrRec);
      v:=GetValueFieldEx(arrRec, 'WORK_SPR',0);
      if v>0 then DokumentWORK_SPR.AsInteger:=v;

      DokumentDOLG_NAME.AsString := dmBase.GetDolg(nID, arrRec);
      v:=GetValueFieldEx(arrRec, 'DOLG_SPR',0);
      if v>0 then DokumentDOLG_SPR.AsInteger:=v;

      p := dmBase.GetRecPasport(nID, arrRec);
      if p.Nomer <> '' then begin
        DokumentPASP_UDOST.AsInteger := p.UdostKod;
        DokumentPASP_SERIA.AsString := p.Seria;
        DokumentPASP_NOMER.AsString := p.Nomer;
        DokumentPASP_VIDAN.AsString := p.Organ;
        DokumentLICH_NOMER.AsString := p.LichNomer;
        DokumentPASP_DATE.AsDateTime := p.Date;
        if p.Srok<>0
          then  DokumentPASP_SROK.AsDateTime := p.Srok;
      end;
//      adr := dmBase.AdresMen( dmBase.GetDateCurrentSost, IntToStr(nID), strName);
//      DokumentADRES_ID.AsInteger := adr.AdresID;
//      DokumentLICH_ID.AsInteger  := adr.LicID;
//      FCurLic:=adr.LicID;

      DokumentADRES_ID.AsInteger := GetValueFieldEx(arrRec, 'ADRES_ID',0);
      DokumentLICH_ID.AsInteger  := GetValueFieldEx(arrRec, 'LIC_ID',0);
      FCurLic:=DokumentLICH_ID.AsInteger;

      //------ запишем место рождения человека ------------
      with dmBase.tbMensAdd do begin
        if Locate('ID', DokumentMEN_ID.AsInteger, []) then begin
          WriteField( DokumentGOSUD_R   , FieldByName('MR_GOSUD')  ); //   , lErr);
          WriteField( DokumentB_OBL_R   , FieldByName('MR_B_OBL')  ); //   , lErr);
          WriteField( DokumentOBL_R     , FieldByName('MR_OBL')    ); //     , lErr);
          WriteField( DokumentRAION_R   , FieldByName('MR_RAION')  ); //   , lErr);
          WriteField( DokumentGOROD_R_B , FieldByName('MR_B_GOROD')); // , lErr);
          WriteField( DokumentGOROD_R   , FieldByName('MR_GOROD')  ); //   , lErr);

          WriteField( DokumentGOSUD_O   , FieldByName('OP_GOSUD')  ); //   , lErr);
          WriteField( DokumentB_OBL_O   , FieldByName('OP_B_OBL')  ); //   , lErr);
          WriteField( DokumentOBL_O     , FieldByName('OP_OBL')    ); //     , lErr);
          WriteField( DokumentRAION_O   , FieldByName('OP_RAION')  ); //   , lErr);
          WriteField( DokumentGOROD_O_B , FieldByName('OP_B_GOROD')); // , lErr);
          WriteField( DokumentGOROD_O   , FieldByName('OP_GOROD')  ); //   , lErr);
          WriteField( DokumentDATE_O    , FieldByName('OP_DATE')  ); //   , lErr);
        end;
      end;
      //------------------------------------------------------
      if lDeti then begin
        ListDeti:=dbCreateListDeti;
        dmBase.GetDeti(ListDeti,DokumentMEN_ID.AsString,DokumentPOL.AsString,0,14,false,false);
        mtDeti.EmptyTable;
        while not ListDeti.Eof do begin
          mtDeti.Append;
          mtDetiFAMILIA.AsString:=ListDeti.FieldByName('FAMILIA').AsString;
          mtDetiNAME.AsString:=ListDeti.FieldByName('NAME').AsString;
          mtDetiOTCH.AsString:=ListDeti.FieldByName('OTCH').AsString;
          mtDetiPOL.AsString:=ListDeti.FieldByName('POL').AsString;
          sKodOtnosh:='';
          if mtDetiPOL.AsString='М' then begin
            if dmBase.SprOtnosh.Locate('NAME','сын',[loCaseInsensitive])
              then sKodOtnosh:=dmBase.SprOtnosh.FieldByName('ID').AsString;
          end else begin
            if dmBase.SprOtnosh.Locate('NAME','дочь',[loCaseInsensitive])
              then sKodOtnosh:=dmBase.SprOtnosh.FieldByName('ID').AsString;
          end;
          if sKodOtnosh<>'' then mtDetiOTNOSH.AsString:=sKodOtnosh;
         if not ListDeti.FieldByName('DATER').IsNull then begin
            mtDetiDATER.AsDateTime:=ListDeti.FieldByName('DATER').AsDateTime;
          end;
          mtDeti.Post;
          ListDeti.Next;
        end;
        dbClose(ListDeti);
      end;
   end;
end;

//------------------------------------------------------------------------------------
procedure TfmTalonPrib.edFamiliaEditButtons0Click(Sender: TObject; var Handled: Boolean);
var
  v : Variant;
  arrRec : TCurrentRecord;
  nID : Integer;
  old : TCursor;
  p : TPassport;
  par:TParamsChoiceMen;
begin
  par:=TParamsChoiceMen.Create;
  par.lEnabledCopyMen:=true;
  if ChoiceMenEx( TControl(Sender), Trim(edFamilia.Text), 'empty(dates)', arrRec, par) then begin
      if GetValueFieldEx(arrRec,'ID',0)>0  then begin
        //------- если копирует красного человека создадим новый ID  ------
        if edTypeReg.Visible and GetValueFieldEx(arrRec, '_COPYMEN', false)=true then begin
          FSaveMigr:=false;
          FCopyMen:=true;
          edTypeReg.ItemIndex:=0;
          edTypeReg.Items[0]:='скопировать человека';
          edTypeReg.Enabled:=false;
          if GetValueFieldEx(arrRec, '_LOADMIGR', false)=true then begin
            FSaveMigr:=true;
          end;
        end else begin
          FSaveMigr:=false;
          FCopyMen:=false;
          edTypeReg.ItemIndex:=0;
          edTypeReg.Items[0]:='регистрация по месту жительства';
          edTypeReg.Enabled:=true;
        end;
        //-------------------------------------------------------------------
        old := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        try
          EditDataSet(Dokument);
          if edTypeReg.Visible and edTypeReg.Enabled
            then DokumentTYPEREG.AsInteger:=IZM_MEN;

          WriteDokumentFromArr(arrRec, false);

          PostDataSet(Dokument);
          CheckPanelLic;
        finally
          Screen.Cursor := old;
        end;
      end;
  end;
  CheckEnabledDeti;
end;

procedure TfmTalonPrib.SetRB_OnClick(Sender: TObject;
  var Handled: Boolean);
begin
  TDBLookupComboBoxEh(TWinControl(Sender).Parent).Value:=112;
  Handled:=true;
end;

procedure TfmTalonPrib.SetRF_OnClick(Sender: TObject;
  var Handled: Boolean);
begin
  TDBLookupComboBoxEh(TWinControl(Sender).Parent).Value:=643;
  Handled:=true;
end;

procedure TfmTalonPrib.SetU_OnClick(Sender: TObject; var Handled: Boolean);
begin
  TDBLookupComboBoxEh(TWinControl(Sender).Parent).Value:=804;
  Handled:=true;
end;

procedure TfmTalonPrib.GridDetiColumns0EditButtons0Click(Sender: TObject;  var Handled: Boolean);
var
  Opis : TOpisEdit;
  v : Variant;
  arrRec : TCurrentRecord;
begin
  SetLength(arrRec,1);
  Opis := GlobalTask.CurrentOpisEdit.GetSprOpisA('LOOKUP_OTNOSH');
  if Opis <> nil then begin
    v := null;
    if Opis.ChoiceFromSprEx(nil, v, arrRec, nil) and (v<>null) then begin
      if v <> null then begin
        EditDataSet(mtDeti);
        mtDetiOTNOSH.AsString:=v;
      end;
    end;
  end;
end;

procedure TfmTalonPrib.GridDetiColumns1EditButtons0Click(Sender: TObject; var Handled: Boolean);
var
  v : Variant;
  arrRec : TCurrentRecord;
  old : TCursor;
  lFilterTemp:Boolean;
  strFilter,strSeek:String;
begin
  if DokumentLICH_ID.AsInteger>0 then begin
    lFilterTemp:=true;
    strFilter:='LIC_ID='+DokumentLICH_ID.AsString;
    if FCopyMen then
      strFilter:=strFilter+' and CANDELETE=true';
    strSeek:='';
  end else begin
    lFilterTemp:=false;
    strSeek:='';
    strFilter:='';
  end;
  if ChoiceMen( TControl(Sender), strSeek, strFilter, arrRec, lFilterTemp) then begin
    if FCopyMen and (GetValueFieldEx(arrRec, 'CANDELETE', false)=false) then begin
      PutError('Режим копирования: выберите выписанного человека',self);
    end else begin
      old := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      EditDataSet(mtDeti);
      v := GetValueField(arrRec, 'ID');
      mtDetiCHILD_ID.AsInteger := v;
      v := GetValueField(arrRec, 'FAMILIA');
      if v = null then mtDetiFAMILIA.AsString := ''
                  else mtDetiFAMILIA.AsString := v;
      v := GetValueField(arrRec, 'NAME');
      if v = null then mtDetiNAME.AsString := ''
                  else mtDetiNAME.AsString := v;
      v := GetValueField(arrRec, 'OTCH');
      if v = null then mtDetiOTCH.AsString := ''
                  else mtDetiOTCH.AsString := v;
      v := GetValueField(arrRec, 'DATER');
      if v = null then mtDetiDateR.AsString := ''
                  else mtDetiDateR.Value    := v;
      v := GetValueField(arrRec, 'POL');
      if v <> null then mtDetiPOL.Value := v;
      QueryExit:=true;
      Screen.Cursor := old;
    end;
  end;
end;

procedure TfmTalonPrib.btAddChildClick(Sender: TObject);
begin
  mtDeti.Append;
end;

procedure TfmTalonPrib.btDelChildClick(Sender: TObject);
begin
  if mtDeti.RecordCount>0 then begin
    mtDeti.Delete;
  end;
end;

procedure TfmTalonPrib.dsDetiDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if Field<>nil then begin
    QueryExit := true;
  end;
end;

procedure TfmTalonPrib.TBItemUbitClick(Sender: TObject);
begin
  DestroyHint(H);
  if not FEnableWrite then begin
    beep;
    exit;
  end;
  if WriteDok then begin
    FRunTalonUbit := true;
    ModalResult   := mrOk;
  end;
end;
{
procedure TfmTalonPrib.edRAION_RNotInList(Sender: TObject; NewText: String; var RecheckInList: Boolean);
begin
  CheckListRaion(Sender,NewText,RecheckInList);
end;

procedure TfmTalonPrib.edOBL_RNotInList(Sender: TObject; NewText: String; var RecheckInList: Boolean);
begin
  CheckListObl(Sender,NewText,RecheckInList);
end;
}
procedure TfmTalonPrib.edPasp_OrganEditButtons0Click(Sender: TObject; var Handled: Boolean);
var
 s:String;
begin
 s:=ChoiceFromShablon(SHABLON_ROVD,Trim(edPasp_Organ.Text));
 if s<>'' then begin
   edPasp_Organ.Text:=s;
 end;
end;

procedure TfmTalonPrib.ENG_edLichNomerUpdateData(Sender: TObject;  var Handled: Boolean);
var
  s:String;
begin
  if GlobalTask.ParamAsBoolean('KONT_IDENTIF') then begin
    if (edUdost.Field.AsInteger=PASP_GR_RB) and (edCitizen.Field.Value=MY_GRAG) or edCitizen.Field.IsNull then begin
      ENG_edLichNomer.text := CheckLichNom(true, ENG_edLichNomer.Text);
      s:=GetErrorCheck;
      if s<>'' then begin
        PutError(s);
      end;
    end; 
  end;
end;

procedure TfmTalonPrib.edDolg_NameEditButtons1Click(Sender: TObject; var Handled: Boolean);
begin
  Handled := true;
  EditDataSet(Dokument);
  DokumentDOLG_SPR.AsString:='';
  DokumentDOLG_NAME.AsString:='';
end;

procedure TfmTalonPrib.edWork_NameEditButtons1Click(Sender: TObject; var Handled: Boolean);
begin
  Handled := true;
  EditDataSet(Dokument);
  DokumentWORK_SPR.AsString:='';
  DokumentWORK_NAME.AsString:='';
end;

procedure TfmTalonPrib.FormCreate(Sender: TObject);
begin
  inherited;
  {$IFDEF USE_FR3}
    CreatefrxDBdataSet(self,mtDeti,'Deti','Дети');
  {$ENDIF}
end;

procedure TfmTalonPrib.edUdostEditButtons0Click(Sender: TObject;  var Handled: Boolean);
begin
  edUdost.ItemIndex:=-1;
  edPasp_Seria.Text:='';
  edPasp_Nomer.Text:='';
  edPasp_Organ.Text:='';
  edPasp_Date.Value:=null;
  edDateZ.Value:=null;
end;

procedure TfmTalonPrib.edOTNOSHEditButtons0Click(Sender: TObject;  var Handled: Boolean);
begin
  ChoiceFromLookupSpr( 'LOOKUP_OTNOSH', 'OTNOSH', false);
  Handled := true;
end;

procedure TfmTalonPrib.N_F_cbNewLichClick(Sender: TObject);
begin
  edOTNOSH.Value:=null;
  CheckPanelLic;
end;

procedure TfmTalonPrib.edNameUpdateData(Sender: TObject; var Handled: Boolean);
var
  s:String;
begin
  s:=PolFromName(edName.Text);
  if s<>'' then DokumentPOL.AsString:=s;
end;

procedure TfmTalonPrib.edOsnovEditButtons0Click(Sender: TObject; var Handled: Boolean);
begin
  TBItemShablonClick(Sender);
end;


procedure TfmTalonPrib.TBItemGetDataGISUNClick(Sender: TObject);
var
  arr:TCurrentRecord;
//  sl:TStringList;
//  i:Integer;
  cur:TCursor;
  sl:TStringList;
  ds:TDataSet;
begin
{$IFDEF GISUN}
  if not TBItemGetDataGISUN.Visible then exit;
  
  cur:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  Gisun.CurAkt:=Self;    // !!! важно
  try
    if GetInfoGISUN1(Self,'LICH_NOMER','') then begin
      sl:=TStringList.Create;
      if ENG_edLichNomer.Text<>'' then begin
        sl.Add(ENG_edLichNomer.Text);
      end;
      ds:=Gisun.LoadIdentifData(sl,nil,nil);
      if ds<>nil then begin
        ds.First;
        EditDataSet(Dokument);

        DokumentFamilia.AsString:=ds.FieldByName('FAMILIA').AsString;
        DokumentNAME.AsString:=ds.FieldByName('NAME').AsString;
        DokumentOTCH.AsString:=ds.FieldByName('OTCH').AsString;
        WriteField(DokumentDATER,ds.FieldByName('DATER'));
        DokumentCITIZEN.AsString:=ds.FieldByName('GRAG').AsString;

        DokumentPASP_UDOST.AsString:=ds.FieldByName('DOK_TYPE').AsString;
        WriteField(DokumentPASP_DATE,ds.FieldByName('DOK_DATE'));
        DokumentPASP_SERIA.AsString:=ds.FieldByName('DOK_SERIA').AsString;
        DokumentPASP_NOMER.AsString:=ds.FieldByName('DOK_NOMER').AsString;
        DokumentPASP_VIDAN.AsString:=ds.FieldByName('DOKUMENT').AsString;

        DokumentGOSUD_R.AsString:=ds.FieldByName('GOSUD_R').AsString;
        DokumentOBL_R.AsString:=ds.FieldByName('OBL_R').AsString;
        DokumentB_OBL_R.AsString:=ds.FieldByName('B_OBL_R').AsString; // !!!
        DokumentRAION_R.AsString:=ds.FieldByName('RAION_R').AsString;
        DokumentGOROD_R_B.AsString:=ds.FieldByName('TYPE_GOROD_R').AsString;
        DokumentGOROD_R.AsString:=ds.FieldByName('GOROD_R').AsString;


        DokumentGOSUD_O.AsString:=ds.FieldByName('GOSUD_G').AsString;
        DokumentOBL_O.AsString:=ds.FieldByName('OBL_G').AsString;
        DokumentB_OBL_O.AsBoolean:=true; // !!!
        DokumentRAION_O.AsString:=ds.FieldByName('RAION_G').AsString;
        DokumentGOROD_O_B.AsString:=ds.FieldByName('TYPE_GOROD_G').AsString;
        DokumentGOROD_O.AsString:=ds.FieldByName('GOROD_G').AsString;
        DokumentUL_O.AsString:=ds.FieldByName('ULICA_G').AsString;
        if ds.FieldByName('DOM_G').AsString<>''
          then DokumentUL_O.AsString:=DokumentUL_O.AsString+', '+sokrDom+' '+ds.FieldByName('DOM_G').AsString;
        if ds.FieldByName('KORP_G').AsString<>''
          then DokumentUL_O.AsString:=DokumentUL_O.AsString+', '+sokrKorp+' '+ds.FieldByName('KORP_G').AsString;
        if ds.FieldByName('KV_G').AsString<>''
          then DokumentUL_O.AsString:=DokumentUL_O.AsString+', '+sokrKv+' '+ds.FieldByName('KV_G').AsString;

        PostDataSet(Dokument);
        ds.Free;
      end;
      sl.Free;
    end;
  finally
    Gisun.CurAkt:=nil;
    Screen.Cursor:=cur;
  end;
{$ENDIF}
//
end;

end.
