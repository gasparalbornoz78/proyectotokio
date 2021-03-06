program TokioProject;

uses
  Vcl.Forms,
  Unit_FormPrincipal in 'Unit_FormPrincipal.pas' {FormPrincipal},
  Vcl.Themes,
  Vcl.Styles,
  Unit_BasedeDatos in 'Model\Unit_BasedeDatos.pas',
  Unit_FormBuscarPorDescripcion in 'GUIUtilidades\Unit_FormBuscarPorDescripcion.pas' {FormBuscarPorDescripcion},
  Unit_ConstantesGenerales in 'Model\Unit_ConstantesGenerales.pas',
  Unit_Utilidades in 'Model\Unit_Utilidades.pas',
  Service.OrdendeCompra in 'Service\OrdendeCompra\Service.OrdendeCompra.pas',
  Utilidades.JSONDataset in 'Service\transferenciaarchivos\json\Utilidades.JSONDataset.pas',
  Unit_OrdendeCompraAlta in 'Views\OrdendeCompra\Unit_OrdendeCompraAlta.pas' {FormAltaOrdendeCompra},
  views.FormOrdendeCompraListado in 'Views\OrdendeCompra\views.FormOrdendeCompraListado.pas' {FormListadoOrden},
  seguridad.Unit_FormLogin in 'Seguridad\seguridad.Unit_FormLogin.pas' {FormLogin},
  seguridad.UsuarioService in 'Seguridad\seguridad.UsuarioService.pas',
  seguridad.FormAltaUsuario in 'Seguridad\seguridad.FormAltaUsuario.pas' {FormAltaUsuario};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
