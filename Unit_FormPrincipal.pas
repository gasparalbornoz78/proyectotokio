unit Unit_FormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, System.Actions, Vcl.ActnList
  ,Vcl.DBGrids,Vcl.DBCtrls,Data.DB, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.StdCtrls;

type
  TFormPrincipal = class(TForm)
    MenuPrincipal: TMainMenu;
    OrdendeCompra1: TMenuItem;
    AltadeOrdendeCompra1: TMenuItem;
    ActionListPrincipal: TActionList;
    ActionAltaOrdendeCompra: TAction;
    ActionListadoOrdendeCompra: TAction;
    ActionToolBar1: TActionToolBar;
    Button1: TButton;
    ActionAltadeUsuario: TAction;
    AltadeUsuario1: TMenuItem;
    AltadeUsuario2: TMenuItem;
    CosultadeUsuario1: TMenuItem;
    ActionListadodeUsuarios: TAction;
    Proveedores1: TMenuItem;
    ConsultadeProveddores1: TMenuItem;
    Salir1: TMenuItem;
    ActionConsultaProveedores: TAction;
    ActionSalir: TAction;
    procedure ActionAltaOrdendeCompraExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionListadoOrdendeCompraExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ActionAltadeUsuarioExecute(Sender: TObject);
    procedure ActionListadodeUsuariosExecute(Sender: TObject);
    procedure ActionSalirExecute(Sender: TObject);
    procedure ActionConsultaProveedoresExecute(Sender: TObject);

  private
    { Private declarations }
      procedure AppMessage(var Msg:TMsg;var Handled:Boolean);
      procedure AppException(Sender:TObject;E:Exception);
      procedure AppActionExecute(Action:TBasicAction;var handled:boolean);

  public
    { Public declarations }
  end;
//prueba alejandro  modificación desde daniel medina
var
  FormPrincipal: TFormPrincipal;

implementation
  uses Unit_OrdendeCompraAlta, views.FormOrdendeCompraListado,
  seguridad.Unit_FormLogin,seguridad.UsuarioService,Unit_BasedeDatos,
  seguridad.FormAltaUsuario, Unit_FormListadoUsuarios,
  Unit_FormConsultaProveedores;
//    ,seguridad.UsuarioService, seguridad.FormLogin;
{$R *.dfm}

procedure TFormPrincipal.ActionListadodeUsuariosExecute(Sender: TObject);
begin
  FormListadoUsuarios:=TFormListadoUsuarios.Create(self);
  FormListadoUsuarios.Show;
end;

procedure TFormPrincipal.ActionListadoOrdendeCompraExecute(Sender: TObject);
begin
  FormListadoOrden:=TFormListadoOrden.Create(self);
  FormListadoOrden.Show;

end;

procedure TFormPrincipal.ActionSalirExecute(Sender: TObject);
begin
  CLOSE;
end;

procedure TFormPrincipal.AppException(Sender:TObject;E:Exception);
begin
  //showmessage(e.StackTrace);
  if E is EConvertError then
    begin
        if sender is TDBEdit then
          begin
            if TDBEdit(Sender).Field.DataType=ftDate then
              begin
                MessageDlg('Ingrese una fecha correcta en formato DD/MM/AAAA', mtError,
                    [mbOk], 0, mbOk);
                exit;
              end;
          end;
    end;

    MessageDlg('Error no controlado: '+E.Message,mtError,[mbOk],0,mbOk);


end;


procedure TFormPrincipal.AppActionExecute(Action:TBasicAction;var handled:boolean);
begin
  //showmessage('Action en TApplication: '+TAction(Action).Name);
end;


procedure TFormPrincipal.AppMessage(var Msg:TMsg;var Handled:Boolean);
var control:TWinControl;
    i:integer;
    banderagrid:boolean;
begin
 if Msg.Message = WM_KEYDOWN then
  begin
    control:=Screen.ActiveControl;
    if (Msg.wParam = VK_Return) and (Control.Tag<>2) then
      begin
        if Control is TDBCheckBox then
            Msg.wParam:=VK_TAB;

        {if (Control is TCheckBox)  then
            Msg.wParam:=VK_TAB;

        if (Control is TRadioGroup) then
            Msg.wParam:=VK_TAB;

        if (Control is TEdit)  and (TEdit(Control).Tag<>3) then
            Msg.wParam:=VK_TAB;


        if (Control is TMemo) then
            exit;}
        if ((Control is TDBEdit) or (Control is TEdit)) and (TDBEdit(Control).Tag<>3) then
           Msg.wParam:=VK_TAB;


        if (Control is TDBComboBox) then
          if TDBComboBox(Control).DroppedDown then
            begin
              if Assigned(TDBComboBox(Control).OnClick) then
                  TDBComboBox(Control).OnClick(Control);
            end
          else
            Msg.wParam:=VK_TAB;


        if (Control is TDBLookupComboBox) then
          if TDBLookupComboBox(Control).ListVisible then
            TDBLookupComboBox(Control).CloseUp(true)
          else
            if Assigned(TDBLookupComboBox(Control).OnExit) then
              TDBLookupComboBox(Control).OnExit(Control);

        {if  (control is TDCDateEdit) then
          if TDCDateEdit(Control).DroppedDown then
            begin
              if Assigned(TDCDateEdit(Control).OnClick) then
                TDCDateEdit(Control).Onclick(Control);
            end
          else
              Msg.wParam:=VK_TAB; }

      end;//end del if del keydown = VK_Return
    if (Msg.wParam = VK_Return) then
      begin
        if Control is TDBGrid then
          if Assigned(TDBGrid(Control).DataSource) then
          begin
            if TDBGrid(Control).Tag=0 then
              exit;

            if (TDBGrid(Control).ReadOnly) or
               (HiWord(GetKeyState(VK_CONTROL)) = 0) then
               //Msg.wParam := VK_TAB
              begin


                if TDBGrid(Control).selectedindex < (TDBGrid(Control).fieldcount -1) then
                  begin
                    if TDBGrid(Control).Columns[TDBGrid(Control).selectedindex +1].Visible then
                      begin
                        TDBGrid(Control).selectedindex := TDBGrid(Control).selectedindex +1;
                        exit;
                      end
                    else
                      for i:=TDBGrid(Control).selectedindex +1 to TDBGrid(Control).fieldcount -1 do
                         if TDBGrid(Control).Columns[i].Visible then
                            TDBGrid(Control).SelectedIndex:=i;
                   banderagrid:=false;
                   if TDBGrid(Control).DataSource.DataSet.Fields[0].Value<>NULL then
                          banderagrid:=true;
                   if (Banderagrid) and
                      (TDBGrid(Control).selectedindex = (TDBGrid(Control).Columns.Count -1)) then
                      begin
                       if (TDBGrid(Control).DataSource.DataSet.RecNo=
                            TDBGrid(Control).DataSource.DataSet.RecordCount)
                          or (TDBGrid(Control).DataSource.DataSet.RecordCount=1 )
                          then
                         begin
                           //if Control is TJvDBUltimGrid then
                            if Control.Tag IN [1,2] then
                             begin
                               if Control.Tag=1 then
                                 TDBGrid(Control).SelectedIndex:=0;
                               //if Control.Tag=2 then
                               //  TDBGrid(Control).SelectedIndex:=0;
                               TDBGrid(Control).DataSource.DataSet.Append;
                               SendMessage(Control.Handle,WM_CHAR,Word(#13),0);
                             end;
                         end
                       else
                        begin
                           TDBGrid(Control).DataSource.DataSet.Next;
                           if Control.Tag=1 then
                               TDBGrid(Control).SelectedIndex:=0;
                           SendMessage(Control.Handle,WM_CHAR,Word(#13),0);
                        end;
                      end;
                  end
                else
                  begin
                   //TDBGrid(Control).selectedindex := 0;
                   banderagrid:=false;
                   //for i:=0 to TDBGrid(Control).DataSource.DataSet.FieldCount-1 do
                   //   begin
                   //     if NOT(TDBGrid(Control).DataSource.DataSet.Fields[i]
                   //         is TDataSetField) then
                         if TDBGrid(Control).DataSource.DataSet.Fields[0].Value<>NULL then
                          banderagrid:=true;
                   //   end;
                   {if Banderagrid then
                      begin
                       if (TDBGrid(Control).DataSource.DataSet.RecNo=
                            TDBGrid(Control).DataSource.DataSet.RecordCount)
                          or (TDBGrid(Control).DataSource.DataSet.RecordCount=1 )
                          then
                         begin
                           if Control is TJvDBUltimGrid then
                            if Control.Tag IN [1,2] then
                             begin
                               if Control.Tag=1 then
                                 TDBGrid(Control).SelectedIndex:=0;
                               //if Control.Tag=2 then
                               //  TDBGrid(Control).SelectedIndex:=0;
                               TDBGrid(Control).DataSource.DataSet.Append;
                               SendMessage(Control.Handle,WM_CHAR,Word(#13),0);
                             end;
                         end
                       else
                        begin
                           TDBGrid(Control).DataSource.DataSet.Next;
                           if Control.Tag=1 then
                               TDBGrid(Control).SelectedIndex:=0;
                           SendMessage(Control.Handle,WM_CHAR,Word(#13),0);
                        end;
                      end;}
                      //TDBGrid(Control).DataSource.DataSet.Next;
                  end;

            end
          else
             if not(HiWord(GetKeyState(VK_SHIFT)) = 0) then
                begin
                if TDBGrid(Control).selectedindex > 0 then
                   TDBGrid(Control).selectedindex := TDBGrid(Control).selectedindex -1
                else
                   TDBGrid(Control).selectedindex := TDBGrid(Control).fieldcount -1;
                end
             else
                begin
                if TDBGrid(Control).selectedindex < (TDBGrid(Control).fieldcount -1) then
                   TDBGrid(Control).selectedindex := TDBGrid(Control).selectedindex +1
                else
                   //TDBGrid(Control).selectedindex := 0;
                   //TDBGrid(Control).DataSource.dataset.Append;
                end;
          end;
      end;//end del if para saber si presionó la tecla enter
      end;// end del if key down
end;



procedure TFormPrincipal.Button1Click(Sender: TObject);

var clave:string;
begin

 clave:=ConexionDB.XorStr('luque',CODIGOXOR);
 showmessage(clave);

end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  Application.OnMessage:=AppMessage;
  Application.OnException:=AppException;
  Application.OnActionExecute:=AppActionExecute;
  FormLogin:=TFormLogin.Create(self);
  FormLogin.ShowModal;
  //UsuarioService.AutorizarAcciones(ActionListPrincipal);


end;

procedure TFormPrincipal.ActionAltadeUsuarioExecute(Sender: TObject);
begin
  FormAltaUsuario:=TFormAltaUsuario.Create(self);
  FormAltaUsuario.Show;
end;

procedure TFormPrincipal.ActionAltaOrdendeCompraExecute(Sender: TObject);
begin
  FormAltaOrdendeCompra:=TFormAltaOrdendeCompra.create(self);
  FormAltaOrdendeCompra.Show;
end;

procedure TFormPrincipal.ActionConsultaProveedoresExecute(Sender: TObject);
begin
  FormConsultaProveedores:=TFormConsultaProveedores.Create(self);
  FormConsultaProveedores.Show;

end;

end.
