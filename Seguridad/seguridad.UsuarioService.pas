unit seguridad.UsuarioService;

interface
uses FireDAC.Comp.Client,System.SysUtils;

type

  TUsuarioService = class
      private
        UserId: integer;
        NameUser:string;
        NameUserCompleto:string;
        IsAdmin: boolean;
        DataSetAcciones:TFDMemTable;
      public
        property Id: integer read UserId;
        property Nombre:string read NameUser;
        property NombreCompleto:string read NameUserCompleto;
        property EsAdministrador:boolean read IsAdmin;
        procedure AutorizarAcciones;
        constructor Create;
        destructor Destroy;
  end;

implementation

constructor TUsuarioService.Create;
begin
  DataSetAcciones:= TFDMemTable.Create(nil);

end;

destructor TUsuarioService.Destroy;
begin
  DataSetAcciones.Close;
  FreeAndNil(DataSetAcciones);;
end;

procedure TUsuarioService.AutorizarAcciones;
begin


end;

end.
