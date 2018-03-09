unit Unit_FormBuscarPorDescripcion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormBuscarPorDescripcion = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EditFiltro: TEdit;
    DBGrid: TDBGrid;
    DSBusqueda: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBuscarPorDescripcion: TFormBuscarPorDescripcion;

implementation

{$R *.dfm}

procedure TFormBuscarPorDescripcion.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
