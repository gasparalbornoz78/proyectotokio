unit seguridad.FormAltaUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, System.Actions, Vcl.ActnList, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFormAltaUsuario = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEditNombre: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Button1: TButton;
    Button2: TButton;
    FDMemTable: TFDMemTable;
    ActionList: TActionList;
    DSSource: TDataSource;
    FDMemTableNOMBRE: TStringField;
    FDMemTableNOMBRECOMPLETO: TStringField;
    FDMemTablePASSWORD: TStringField;
    FormAltaUsuario_ActionGuardar: TAction;
    FormAltaUsuario_ActionCancelar: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormAltaUsuario_ActionGuardarExecute(Sender: TObject);
    procedure FormAltaUsuario_ActionCancelarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAltaUsuario: TFormAltaUsuario;

implementation
  uses Unit_BasedeDatos,seguridad.UsuarioService;
{$R *.dfm}

procedure TFormAltaUsuario.FormAltaUsuario_ActionCancelarExecute(
  Sender: TObject);
begin
  close;
end;

procedure TFormAltaUsuario.FormAltaUsuario_ActionGuardarExecute(
  Sender: TObject);
  var id:integer;
begin
  FDMemTable.FieldByName('PASSWORD').AsString:=
      UsuarioService.EncriptarPassword(FDMemTable.FieldByName('PASSWORD').AsString);
  FDMemTable.Post;
  id:=ConexionDB.EjecutarInsertTabla(FDMemTable,'usuarios');
  showmessage('Id insertado: '+IntToStr(id));
  FDMemTable.Append;
  DBEditNombre.SetFocus;
end;

procedure TFormAltaUsuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TFormAltaUsuario.FormCreate(Sender: TObject);
begin
  FDMemTable.Open;
  FDMemTable.Append;
end;

end.
