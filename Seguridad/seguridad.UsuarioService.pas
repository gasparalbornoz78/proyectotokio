unit seguridad.UsuarioService;

interface
uses FireDAC.Comp.Client,System.SysUtils,Data.DB,Vcl.ActnList;

type

  TUsuarioService = class
      private
        UserId: integer;
        UserName:string;
        UserNameCompleto:string;
        IsAdmin: boolean;
        DataSetAcciones:TFDMemTable;
      public
        property Id: integer read UserId;
        property Nombre:string read UserName;
        property NombreCompleto:string read UserNameCompleto;
        property EsAdministrador:boolean read IsAdmin;
        procedure AutorizarAcciones(Acciones:TActionList);
        function Login(NombreUsuario:string;Password:string):boolean;

        function EncriptarPassword(pass:string):string;

        constructor Create;
        destructor Destroy;
  end;
  var UsuarioService:TUsuarioService;
implementation
uses Unit_BasedeDatos,IdHashMessageDigest;

constructor TUsuarioService.Create;
begin
  DataSetAcciones:= TFDMemTable.Create(nil);
  with DataSetAcciones do
    with FieldDefs do
      begin
        Add('idACCION',ftString,60,false);
        FieldDefs[0].CreateField(DataSetAcciones);
        Add('DESCRIPCION',ftString,60,false);
        FieldDefs[1].CreateField(DataSetAcciones);
      end;
  DataSetAcciones.Open;
end;

destructor TUsuarioService.Destroy;
begin
  DataSetAcciones.Close;
  FreeAndNil(DataSetAcciones);;
end;

procedure TUsuarioService.AutorizarAcciones(Acciones:TActionList);
var I:integer;
begin
  with DataSetAcciones do
    begin
      first;
      while not Eof do
        begin
          for I := 0 to Acciones.ActionCount-1 do
            begin
                if Acciones.Actions[I].Name =FieldbyName('idACCION').AsString then
                  Acciones.Actions[I].Visible:=true
                else
                  Acciones.Actions[I].Visible:=false;
            end;
          Next;
        end;
    end;
end;


function TUsuarioService.Login(NombreUsuario:string;Password:string):boolean;
var DataSetAuxAcciones,DataSetUsuario:TDataSet;
begin
    Result:=false;
    DataSetUsuario:=ConexionDB.EjecutarSelect(
        'SELECT * FROM usuarios WHERE NOMBRE='+QuotedStr(NombreUsuario)
        +' AND PASSWORD='+QuotedStr(EncriptarPassword(Password)),false);
    if Not (DataSetUsuario.IsEmpty) THEN
      begin
            Result:=true;

            UserId:=DataSetUsuario.FieldByName('idUSUARIOS').AsInteger;
            UserName:=DataSetUsuario.FieldByName('NOMBRE').AsString;
            UserNameCompleto:=DataSetUsuario.FieldByName('NOMBRECOMPLETO').AsString;
            IsAdmin:=DataSetUsuario.FieldByName('ADMINISTRADOR').AsBoolean;
            DataSetAuxAcciones:=ConexionDB.EjecutarSelect(
                'SELECT a.* FROM usuarios_perfiles up'
                +' INNER JOIN perfiles_roles pr ON up.idPERFIL=pr.idPERFIL'
                +' INNER JOIN roles_acciones ra ON pr.idROLE=ra.idROL'
                +' INNER JOIN acciones a ON ra.idACCION = a.idACCION'
                +' WHERE up.idUSUARIO='+IntToStr(UserId)

                ,false);
            while not DataSetAuxAcciones.Eof do
              begin
                DataSetAcciones.Append;
                DataSetAcciones.FieldByName('idACCION').AsString:=
                    DataSetAuxAcciones.FieldByName('idACCION').AsString;
                DataSetAcciones.FieldByName('DESCRIPCION').AsString:=
                    DataSetAuxAcciones.FieldByName('DESCRIPCION').AsString;
                DataSetAcciones.Post;
                DataSetAuxAcciones.Next;
              end;
      end;
    FreeAndNil(DataSetAuxAcciones);


end;


function TUsuarioService.EncriptarPassword(pass:string):string;
var MD5:TidHashMessageDigest5;
begin
  MD5:=TidHashMessageDigest5.create;
  Result:=MD5.HashStringAsHex(pass);
end;



//----------------------------------
initialization
  UsuarioService:=TUsuarioService.Create;
finalization
  FreeAndNil(UsuarioService);

end.
