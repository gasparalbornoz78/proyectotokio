unit Unit_FormListadoUsuarios ;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Actions, Vcl.ActnList;

type
  TFormListadoUsuarios = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Editfiltro: TEdit;
    ButtonBuscar: TButton;
    GroupBox1: TGroupBox;
    gridusuarios: TDBGrid;
    DSusuarios: TDataSource;
    ActionList1: TActionList;
    ActionBuscarUsuario: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionBuscarUsuarioExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormListadoUsuarios: TFormListadoUsuarios;

implementation
uses Unit_BasedeDatos;
{$R *.dfm}

procedure TFormListadoUsuarios.ActionBuscarUsuarioExecute(Sender: TObject);
var sql:string;
begin
  if Trim(Editfiltro.Text)<>'' then
    begin
      sql:='SELECT idusuarios,nombre,nombrecompleto FROM usuarios where nombrecompleto like "%'+trim(Editfiltro.Text)+'%"';
    end
  else
    begin
      sql:='SELECT idusuarios,nombre,nombrecompleto FROM usuarios';
    end;

  with ConexionDB do
    begin
      EjecutarSelect(sql,DSusuarios);
      DSusuarios.DataSet.First;
    end;

end;

procedure TFormListadoUsuarios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=caFree;
end;

end.
