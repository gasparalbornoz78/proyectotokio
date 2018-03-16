unit seguridad.Unit_FormLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormLogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    EditNombreUsuario: TEdit;
    EditPassword: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation
uses seguridad.UsuarioService;
{$R *.dfm}

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if  ModalResult=mrOk then
    begin
       if not UsuarioService.Login(EditNombreUsuario.Text,EditPassword.Text) then
          begin
            ModalResult:=mrNone;
            MessageDlg('Usuario o contraseña incorrectos',mtError,[mbOK],0,mbOk);
          end;
    end
  else
    Application.Terminate;
end;

end.
