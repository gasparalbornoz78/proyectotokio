unit views.FormOrdendeCompraListado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFormListadoOrden = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    DBGridCabecera: TDBGrid;
    DBGridDetalle: TDBGrid;
    DSCabecera: TDataSource;
    DSDetalle: TDataSource;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridCabeceraDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure AfterScroll(DataSet:TDataSet);
  public
    { Public declarations }
  end;

var
  FormListadoOrden: TFormListadoOrden;

implementation
uses Unit_BasedeDatos, Unit_OrdendeCompraAlta;
{$R *.dfm}

procedure TFormListadoOrden.Button1Click(Sender: TObject);
begin
  with ConexionDB do
    begin
      EjecutarSelect('SELECT * FROM ordendecompra',DSCabecera);;
      if not Assigned(DSCabecera.DataSet.AfterScroll) then
         DSCabecera.DataSet.AfterScroll:=AfterScroll;
      DSCabecera.DataSet.First;
    end;
end;

procedure TFormListadoOrden.DBGridCabeceraDblClick(Sender: TObject);
begin
    FormAltaOrdendeCompra:=TFormAltaOrdendeCompra.Create(self
        ,DSCabecera.DataSet.FieldByName('numero').asinteger);
    FormAltaOrdendeCompra.Show;
end;

procedure TFormListadoOrden.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action:=caFree;
end;

procedure TFormListadoOrden.AfterScroll(DataSet:TDataSet);
begin
    ConexionDB.EjecutarSelect('SELECT * FROM detalleordendecompra WHERE NUMERO='
        +DSCabecera.DataSet.FieldByName('NUMERO').AsString
        ,DSDetalle);
end;

end.
