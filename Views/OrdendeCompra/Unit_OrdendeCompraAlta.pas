unit Unit_OrdendeCompraAlta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.Mask,Unit_Utilidades, FireDAC.Stan.Async, FireDAC.DApt,
  System.Actions, Vcl.ActnList;

  const ALTA='ALTA';
  const MODIFICACION='MODIFICACION';


type
  TFormAltaOrdendeCompra = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    DBGridDetalle: TDBGrid;
    DSDetalle: TDataSource;
    FDMemTDetalle: TFDMemTable;
    FDMemTCabecera: TFDMemTable;
    Button1: TButton;
    Button2: TButton;
    FDMemTCabeceraFechaEntrega: TDateField;
    FDMemTCabeceraidProveedor: TIntegerField;
    FDMemTCabeceraFecha: TDateField;
    FDMemTCabeceraObservacion: TStringField;
    FDMemTCabeceraTotal: TFloatField;
    FDMemTCabeceraIvaRet: TFloatField;
    FDMemTCabeceraImpInterno: TFloatField;
    FDMemTCabeceraIVA21: TFloatField;
    FDMemTCabeceraIVA105: TFloatField;
    FDMemTCabeceraIngBruto: TFloatField;
    FDMemTCabeceraANULADA: TBooleanField;
    FDMemTCabeceraSatisfecha: TBooleanField;
    FDMemTCabeceraOBCONDICIONES: TStringField;
    FDMemTCabeceraIDUSUARIODESC: TIntegerField;
    FDMemTCabeceraFECHADESC: TDateField;
    FDMemTCabeceraIDPROVPARTICULAR: TIntegerField;
    FDMemTCabeceraidPROCESOSVERDURA: TIntegerField;
    FDMemTDetalleidPRODUCTOS: TIntegerField;
    FDMemTDetalleCANTIDAD: TIntegerField;
    FDMemTDetalleCANTIDADBONIFICADA: TFloatField;
    FDMemTDetalleCANTIDADSATISFECHA: TFloatField;
    FDMemTDetalleCANTIDADBONIFICADASATISFECHA: TFloatField;
    FDMemTDetalleCOSTO: TFloatField;
    FDMemTDetalleTOTALDESCUENTO: TFloatField;
    FDMemTDetalleCANTIDADBULTO: TFloatField;
    FDMemTDetalleCANTIDADBONIFBULTO: TFloatField;
    FDMemTDetalleTOTALDESCUENTOMONTO: TFloatField;
    FDMemTDetalleBULTOPROV: TFloatField;
    FDMemTDetalleCOSTOCONDESCUENTO: TFloatField;
    FDMemTDetalleSUBTOTAL: TFloatField;
    FDMemTDetalleDIASSTOCK: TFloatField;
    FDMemTDetalleCOSTODESCBONIFICACION: TFloatField;
    DBEditProveedor: TDBEdit;
    DBText1: TDBText;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    DBText2: TDBText;
    DBEditFechaEngrega: TDBEdit;
    DSCabecera: TDataSource;
    FDMemTCabeceraidCONDICIONES: TIntegerField;
    FDMemTCabeceraRazonSocialProveedor: TStringField;
    FDMemTDetalleDetalle: TStringField;
    FDMemTCabeceraNUMERO: TIntegerField;
    DataSource1: TDataSource;
    ActionList1: TActionList;
    ActionOC_save: TAction;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FDMemTDetalleBeforePost(DataSet: TDataSet);
    procedure ActionOC_saveExecute(Sender: TObject);
  private
    { Private declarations }
    GUIBuscarPorDescripcion: TGUIBuscarPorDescripcion;
    TipoMovimiento:string;
    idNumerodeOrden:integer;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);overload; override;
    constructor Create(AOwner:TComponent;idOrden_par:longint);overload;
  end;

var
  FormAltaOrdendeCompra: TFormAltaOrdendeCompra;

implementation
  uses  unit_BasedeDatos;

{$R *.dfm}

constructor TFormAltaOrdendeCompra.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    TipoMovimiento:=ALTA;
end;

constructor TFormAltaOrdendeCompra.Create(AOwner: TComponent
            ;idOrden_par:longint);
begin
    inherited Create(AOwner);
    TipoMovimiento:=MODIFICACION;
    idNumerodeOrden:=idOrden_par;
end;

procedure TFormAltaOrdendeCompra.ActionOC_saveExecute(Sender: TObject);
begin
    ShowMessage('Action en formulario: '+TAction(Sender).Name);
end;

procedure TFormAltaOrdendeCompra.Button1Click(Sender: TObject);
var I:integer;
begin
//  FDMemTCabecera.Post;
  if (FDMemTDetalle.State=dsEdit) or (FDMemTDetalle.State=dsInsert) then
      FDMemTDetalle.Post;

  if TipoMovimiento=ALTA then
    begin
      I:=ConexionDB.EjecutarInsertMaestroDetalle(FDMemTCabecera
          ,FDMemTDetalle,'ordendecompra','detalleordendecompra','NUMERO');
      ShowMessage('Id Maestro de alta: '+IntToStr(I));
    end;
  if TipoMovimiento=MODIFICACION then
    begin
      I:=ConexionDB.EjecutarUpdateMaestroDetalle(FDMemTCabecera
          ,FDMemTDetalle,'ordendecompra','detalleordendecompra','NUMERO'
          ,'NUMERO',idNumerodeOrden);
      ShowMessage('Cantidad de Filas afectadas: '+IntToStr(I));
    end;

  FDMemTCabecera.Close;
  FDMemTCabecera.Open;
  FDMemTDetalle.Close;
  FDMemTDetalle.Open;
  DBEditFechaEngrega.SetFocus;

end;

procedure TFormAltaOrdendeCompra.FDMemTDetalleBeforePost(DataSet: TDataSet);
begin
if FDMemTDetalle.FieldByName('Detalle').AsString.Trim='' then
  begin
    MessageDlg('Ingrese un código de producto válido',mtError,[mbOk],0, mbOk);
    Abort
  end;

end;

procedure TFormAltaOrdendeCompra.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TFormAltaOrdendeCompra.FormCreate(Sender: TObject);
begin



  with FDMemTCabeceraRazonSocialProveedor do
    begin
      FieldKind:=fkLookup;
      KeyFields:='idProveedor';
      Tag:=1;
      LookupDataSet:=ConexionDB.CrearDataSetLookup(self,'proveedores'
        ,'idProveedor','RazonSocial','');
      LookupKeyFields:='idProveedor';
      LookupResultField:='RazonSocial';
    end;
  with FDMemTDetalleDetalle do
    begin
      FieldKind:=fkLookup;
      KeyFields:='idPRODUCTOS';
      Tag:=1;
      LookupDataSet:=ConexionDB.CrearDataSetLookup(self,'productos'
        ,'idPRODUCTOS','DETALLESUCURSALES','');
      LookupKeyFields:='idPRODUCTOS';
      LookupResultField:='DETALLESUCURSALES';
    end;
  FDMemTCabecera.Open;
  FDMemTDetalle.Open;
  FDMemTCabecera.Append;
  FDMemTDetalle.Append;


  if TipoMovimiento=MODIFICACION  then
    begin
        ConexionDB.RecuperarMaestroDetalle(FDMemTCabecera
            ,FDMemTDetalle,'ordendecompra','detalleordendecompra','NUMERO'
            ,'NUMERO',idNumerodeOrden);
    end;


  {esto es para la ventana de búsqueda con f3}
  GUIBuscarPorDescripcion:= TGUIBuscarPorDescripcion.Create(FDMemTCabecera
      ,DBEditProveedor
      ,'idProveedor','Codigo'
      ,'SELECT idProveedor as Codigo,RazonSocial as Nombre FROM proveedores WHERE RazonSocial LIKE #s');
  GUIBuscarPorDescripcion:= TGUIBuscarPorDescripcion.Create(FDMemTDetalle
      ,DBGridDetalle
      ,'idPRODUCTOS','Codigo'
      ,'SELECT idPRODUCTOS AS Codigo,DETALLE as Descripcion FROM productos WHERE DETALLE LIKE #s');

end;



end.


