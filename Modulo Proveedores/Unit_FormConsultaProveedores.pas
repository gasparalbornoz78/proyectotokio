unit Unit_FormConsultaProveedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids;

type
  TFormConsultaProveedores = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    CheckBoxcuit: TCheckBox;
    Editcuit: TEdit;
    CheckBoxrazon: TCheckBox;
    Editrazon: TEdit;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DSCONSULTA: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConsultaProveedores: TFormConsultaProveedores;

implementation

{$R *.dfm}

procedure TFormConsultaProveedores.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=caFree;
end;

end.
