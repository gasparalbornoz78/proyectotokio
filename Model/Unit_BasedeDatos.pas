unit Unit_BasedeDatos;

interface
uses SysUtils,Classes,SqlExpr,Variants,DB,Windows,
  Contnrs,IniFiles,
    ActiveX,Dialogs,ComObj,Controls,FireDAC.Comp.Client
  ,FireDAC.Stan.StorageJSON, REST.Response.Adapter, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
    Vcl.Grids, Vcl.DBGrids, System.IOUtils, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.DApt,
  Vcl.DBCtrls, FireDAC.Comp.UI, FireDAC.VCLUI.Async;


const ADO='ADO';
const FDAC='FDAC';
const MySQL='MySQL';
const Advantage='Advantage';
const ArchivoIni='config.ini';
const StrDataDirectory='DataDirectory';
const StrDefaultDir='DefaultDir';
const DRIVERID='DriverId';
const CODIGOXOR='998672';

const StrServer='SERVER';
const BDE='BDE';
const NumColumnas=7;
const AnchoTexto=80;

//-------tipos para impresi�n DOS-----

type TColumna = Record
       XPosicion: word;
       Ancho: word;
     End;


type TPrintDOS=class
  private
    Linea:String;
    Columnas: Array[1..NumColumnas] of TColumna;
  public
    constructor Create;
    procedure AbrirImpresion;
    procedure CerrarImpresion;
    procedure CrearColumna(Numero:word;Posicion:word;ancho:word);
    procedure AgregarTexto(columna:word;texto:string);
    procedure SaltarLinea;
    procedure ImprimirLinea;
end;

//----------------------------------

type
 TAfterInsertEventConexion = procedure (SentenciaSQL:String;
      SentenciaNum:integer) of object;
 TConexionDB= class
  private
    Conexion:TCustomConnection;
    TipoConexion:String;
    BasedeDatos:String;
    NombreBasedeDatos:string;
    StrSQL:TStrings;
    ConnectionString:WideString;
    ActiveTrans:boolean;
    SucursalActiva:Integer;
    Server:string;
    User:string;
    password:string;
    constructor Create;overload;
    procedure ConexionCerrada(Sender:TObject);
    function InsertAdvantage:Integer;
    function InsertMysql(StrSQL:TStrings):Integer;
    procedure ManejadorErrorTransaccion(E:Exception);
    //function GetConexion:TADOConnection;
    function EjecutarFireDACParamAct(StrSql:string
        ;const Parametros: array of Variant):Integer;overload;
    function RetornarValorStrSqlDeCampo(Field:TField):string;

  public
    EventoDespuesInsertar:TAfterInsertEventConexion;
    ODBC:String;
//    property AccesoADO:TADOConnection read GetConexion;
    property Sucursal:integer read SucursalActiva;
    constructor Create(ConexionTipo:String;TipoDB:String;
            ConnectionStr:WideString);overload;
    constructor Create(ConexionTipo:String;TipoDB:String;//ACTUALIZAR 06-07-06
            ConnectionStr:WideString;ODBC:string
            ;DirPedidosSuc:string;ConexionCerrada:boolean);overload;
    destructor Destroy; override;
    procedure DBConectar;
    procedure CerrarConexion;
    procedure EjecutarSelect(StrSql:wideString;DBSource:TComponent);overload;

        function XorStr(Stri, Strk: String): String;


    function EjecutarSelect(StrSql:wideString;Cerrado:boolean):TDataSet;overload;
    function EjecutarAct(StrSql:widestring):Integer;overload;
    function EjecutarAct(StrSQL:TStrings):Integer;overload;
    function EjecutarAct:Integer;overload;
    function EjecutarUpdateMaestroDetalle(DataSetMaestro: TDataSet
              ; DataSetDetalle: TDataSet; NombreTablaMaestro: string
              ; NombreTablaDetalle: string;  CampoDetalleFK: string;CampoMaestroPK:string
              ; IdMaestro:integer):integer;

    function EjecutarInsertTabla(DataSetTabla:TDataSet;TablaNombre:string):integer;

    function EjecutarInsertMaestroDetalle(DataSetMaestro:TDataSet
        ;DataSetDetalle:TDataSet;NombreTablaMaestro:string;NombreTablaDetalle:string
        ;CampoFK:string):integer;

    procedure RecuperarMaestroDetalle(DataSetMaestro:TDataSet
          ;DataSetDetalle:TDataSet;NombreTablaMaestro:string
          ;NombreTablaDetalle:string;CampoPK:string;CampoFK:string;idMaestro:integer);
    function CrearDataSetLookup(Owner:TComponent;TableName:string;CampoClave:string
        ;CampoDescriptivo:string;Filtro:string):TDataSet;

    procedure CrearLookupField(DataSetSource:TDataSet
        ;NombreTablaLookup:string ;CampoNombre:string;KeyField:string
        ;CampoClave:string;CampoDescriptivo:string;Filtro:string);


    function StrConexion(Directorio:WideString):WideString;
    procedure AddAct(sql:String);
    procedure IniciarTransaccion;
    procedure CerrarTransaccion;
    procedure DesHacerTransaccion;
 end;

procedure SetPaperSize (ancho,largo: Integer);
function StrConexion(Directorio:WideString):WideString;
function StrConexionODBCWindows(Directorio:WideString):WideString;
function StationNumber:byte;
//Function GetNetUserName : String;                              no se de que es
//Function GetNetFullName(User_Name : String) : String;          no se de que es


var
  ConexionDB:TConexionDB;
  ConexionDBAdvPedidosSuc:TConexionDB;
  AplicacionIni:TIniFile;
  ArchivoPrn:TextFile;
  varPERCEPCIONIVA:real;
  varPERCEPCIONIVAMONTOMAX:real;
  DirectorioPedidosSuc:String;
  DirectorioRemitosIngresoSuc:String;
implementation
 uses Printers,Provider;

//*************Procedimientos y Funciones de la Clase TConexionDB****



constructor TConexionDB.Create;
var separadordecimal:char;
    fs:TFormatSettings;
begin
  inherited create;
  fs:=TFormatSettings.Create();
  StrSQL:=TStringList.Create;
  TipoConexion:=AplicacionIni.ReadString('DataBase','Acceso','ADO');
  BasedeDatos:=AplicacionIni.ReadString('DataBase','TipoDB','Advantage');
  NombreBasedeDatos:=AplicacionIni.ReadString('DataBase','DataBaseName','');
  ConnectionString:=AplicacionIni.ReadString(BasedeDatos,
        'ConnectionString','Advantage');
  ODBC:=AplicacionIni.ReadString('ODBC','DSN','');
  separadordecimal:= fs.DecimalSeparator;
  fs.DecimalSeparator:=separadordecimal;
  DirectorioRemitosIngresoSuc:=AplicacionIni.ReadString('Directorios','RemitoIngresoSuc','');
  Server:=AplicacionIni.ReadString('MySQL','Server','');
  User := AplicacionIni.ReadString('MySQL','User','');
  password := AplicacionIni.ReadString('MySQL','password','');
  DBConectar;
end;

constructor TConexionDB.Create(ConexionTipo:String;TipoDB:String;
      ConnectionStr:WideString;ODBC:string
      {Este constructor no es usado actualmente su estado es Deprecated}
      ;DirPedidosSuc:string;ConexionCerrada:boolean);//ACTUALIZAR 06-07-06
begin
 inherited Create;
 StrSQL:=TStringList.Create;
 TipoConexion:=ConexionTipo;
 BasedeDatos:=TipoDB;
 ConnectionString:=ConnectionStr;
 self.ODBC:=ODBC;
 CoInitialize(nil);
 if Not ConexionCerrada then
     DBConectar;
 DirectorioPedidosSuc:=DirPedidosSuc;



end;

constructor TConexionDB.Create(ConexionTipo:String;TipoDB:String;
      ConnectionStr:WideString);
begin
 inherited Create;
 StrSQL:=TStringList.Create; 
 TipoConexion:=ConexionTipo;
 BasedeDatos:=TipoDB;
 ConnectionString:=ConnectionStr;
 DBConectar;
end;



destructor TConexionDB.Destroy;
begin
 FreeAndNil(Conexion);
 StrSql.Free;
 inherited Destroy;

end;

function TConexionDB.XorStr(Stri: string; Strk: string):string;
var
    Longkey: string;
    I: Integer;
    Next: char;
begin
    for I := 0 to (Length(Stri) div Length(Strk)) do
    Longkey := Longkey + Strk;
    for I := 1 to length(Stri) do
    begin
        Next := chr((ord(Stri[i]) xor ord(Longkey[i])));
        Result := Result + Next;
    end;
end;


function TConexionDB.CrearDataSetLookup(Owner:TComponent;TableName:string;CampoClave:string
        ;CampoDescriptivo:string;Filtro:string):TDataSet;
var DataSetResult:TDataSet;
    StrSQL:string;
begin
  if Trim(Filtro)<>'' then
    StrSQL:=format('SELECT %s, %s FROM %s WHERE %s',[CampoClave,CampoDescriptivo,TableName,Filtro])
  else
    StrSQL:=format('SELECT %s, %s FROM %s',[CampoClave,CampoDescriptivo,TableName]);

    DataSetResult := TFDQuery.Create(Owner);
    with TFDQuery(DataSetResult) do
      begin
        Connection:=TFDConnection(Conexion);
        close;
        SQL.Clear;
        sql.Add(StrSQL);
        Open;
      end;
  Result:=DataSetResult;
end;

procedure TConexionDB.CrearLookupField(DataSetSource:TDataSet
        ;NombreTablaLookup:string ;CampoNombre:string;KeyField:string
        ;CampoClave:string;CampoDescriptivo:string;Filtro:string);
 var LookupField:TField;
begin
  LookupField := TStringField.Create(DataSetSource);
  with LookupField do
    begin
      FieldName:=CampoNombre;
      KeyFields:=KeyFields;
      Size:=60;
      LookupDataSet:=CrearDataSetLookup(DataSetSource,NombreTablaLookup,CampoClave
          ,CampoDescriptivo,Filtro);
      LookupKeyFields:=CampoClave;
      LookupResultField:=CampoDescriptivo;
      FieldKind:=fkLookup;
      DataSet:=DataSetSource;
      Name:=DataSetSource.Name+FieldName;
      DataSetSource.FieldDefs.Add(CampoNombre,ftString,0,false);


    end;

end;


function TConexionDB.StrConexion(Directorio:WideString):WideString;
var indexInicio,indexFinal:integer;
    ArchIni:TIniFile;
    StringConexion:WideString;
begin
{  StringConexion:=ArchIni.ReadString('Advantage','ConnectionString','');
  indexInicio:=Pos(StrDataDirectory,ConnectionString);
  indexInicio:=indexInicio+length(StrDataDirectory);
  indexFinal:=Pos(StrServer,ConnectionString);
  Delete(ConnectionString,indexInicio,indexfinal-indexinicio);
  Insert('='+directorio+';',ConnectionString,indexInicio);
  Result:=ConnectionString;
  ArchIni.Free;}
end;

procedure TConexionDB.CerrarConexion;
begin
 {if TipoConexion=BDE then
   TDataBase(Conexion).Connected:=false;}
 if TipoConexion=ADO then
   //TADOConnection(Conexion).Close;
 if TipoConexion=FDAC then
   TFDConnection(Conexion).Close;
end;


{function TConexionDB.GetConexion:TADOConnection;
begin
  Result:=TADOConnection(Conexion);
end;
}


procedure TConexionDB.ConexionCerrada(Sender:TObject);
begin
  ShowMessage('La Conexi�n con la Base de Datos se Perdi�');
end;


procedure TConexionDB.DBConectar;
var strxor:string;
begin



 if Trim(ConnectionString)='' then
     raise Exception.Create('La cadena de conexi�n, AliasName o Nombre de la Conexi�n es incorrecto');
 //----- Conexi�n segun ADO----
 {if TipoConexion =ADO then
  begin
   Conexion:=TADOConnection.Create(nil);
   //Conexion.AfterDisconnect:=ConexionCerrada;
   //if AplicacionIni.ReadString('DataBase','TipoDB','Advantage') ='MySQL' then
   if BasedeDatos=MySQL then
      //TADOConnection(Conexion).ConnectionString :='Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data Source=conectar;Extended Properties="DATABASE=test;DSN=conectar;OPTION=2048;PORT=0;SERVER=192.160.0.165;UID=root"';
     begin
      TADOConnection(Conexion).ConnectionString :=
        //AplicacionIni.ReadString('MySQL','ConnectionString','');
        ConnectionString;
      //TADOConnection(Conexion).DefaultDatabase :='test';
     end;
   if BasedeDatos =Advantage then
      TADOConnection(Conexion).ConnectionString :=
        //AplicacionIni.ReadString('Advantage','ConnectionString','');
        ConnectionString;

   TADOConnection(Conexion).LoginPrompt:=false;
   try
     TADOConnection(Conexion).connected:=true;
   except
      on E:EOleException do
          begin
            ShowMessage('EL MENSAJE DE ERROR ES: '+
              E.Message);
            Halt;
          end;
      on E:Exception do
        begin
          raise Exception.Create(E.Message);
        end;

   end;
  end;
  }
  //---------------------FIN ADO


  //-----------Conexi�n seg�n FireDAC
  if TipoConexion=FDAC then
    begin

        //strxor:=  XorStr(Password,CODIGOXOR);
        strxor:='luque';
        Conexion:=TFDConnection.Create(nil);
        TFDConnection(Conexion).DriverName:= MySQL;
        with TFDConnection(Conexion).Params do
          begin
            clear;
            Add('DriverID='+BasedeDatos);
            Add('Server='+Server);
            Add('DataBase='+NombreBasedeDatos);
            Add('User_Name='+User);
            Add('Password='+strxor);
          end;

        try
          TFDConnection(Conexion).Connected:=True;
        except
          on E:Exception  do
            begin
              ShowMessage('EL MENSAJE DE ERROR ES: '
                  +E.message);
              Halt;
            end;
        end;

    end;


 //-----------CONEXION BDE----------
{ if TipoConexion = BDE then
  begin
    if Trim(ODBC)='' then
            raise Exception.Create('No puede Realizarse la '
              +' Conexi�n con el Servidor. Archivo de Inicializaci�n Inexistente'
              +' o tiene datos Incorrectos.');
    Conexion:=TDataBase.Create(nil);
    //if BasedeDatos=Advantage then
    //  begin
        Conexion.LoginPrompt:=false;
        TDataBase(Conexion).AliasName:=ODBC;
        TDataBase(Conexion).DatabaseName:='DBLOCAL';
        TDataBase(Conexion).LoginPrompt:=false;
        //TDataBase(Conexion).Params.Add('USER NAME=ADSSYS');
        try
          TDataBase(Conexion).Open;
        except
          on E:EDataBaseError do
           begin
            MessageDlg(PChar('Ocurri�n un Error al Conectarse con '
              +' la base de datos. Consulte con su Administrador'
              +'. El mensaje de error es: '+E.Message
              )
              , mtError,[mbOk], 0);
              Halt;
           end;
          on E:Exception do
            begin
              DataBaseError(E.Message,Conexion);
            end;
        end;


  end;} //end del BDE
  //---------------FIN BDE------
end;

//function TConexionDB.EjecutarSelect (StrSql:String):TDataSet;
//var Consulta:TADOQuery;
//begin
// Consulta:=nil;
// if AplicacionIni.ReadString('DataBase','Acceso','ADO') ='ADO' then
//  begin
//   Consulta:=TADOQuery.Create(nil);
//   TADOQuery(Consulta).Connection:=TADOConnection(Conexion);
//   EjecutarSelect(StrSQL,Consulta);
//  end;
//  Result:=Consulta;
//end;
//
{function TConexionDB.EjecutarSelect(StrSql:String;AOwner:TComponent):TDataSet;
var DataSet:TDataSet;
begin
 //DataSet:=nil;
 //------Conexion segun ADO------
 if TipoConexion=ADO then
    begin
      Dataset:= TADOQuery.Create(AOwner);
      with TADOQuery(DataSet) do
         begin
          Connection:=TADOConnection(Conexion);
          close;
          sql.Clear;
          sql.Add(StrSql);
          Open;
         end;
     end;
 //-----------------------
 //----------------Conexion Segun BDE------------
 if TipoConexion=BDE then
    begin
      DataSet:=TQuery.Create(AOwner);
      with TQuery(DataSet) do
        begin
          DatabaseName:=TDataBase(Conexion).DatabaseName;
          sql.Clear;
          sql.Add(StrSql);
          try
            Open;
          except
            on E:EDataBaseError do
             begin
                  DatabaseError('Error al Consultar la base de datos.'
                    +' Consulte con su Administrador.'
                    +' C�digo de error: '
                    +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                    +'. Mensaje: '+E.Message
                    ,DataSet);
              end;
            on E:Exception do
                begin
                  raise Exception.Create(E.Message);
                end;
          end;
        end;
    end;
 //----------------------------------------------
 Result:=DataSet;

end; }

function TConexionDB.EjecutarSelect(StrSql:wideString;Cerrado:boolean):TDataSet;
var DataSet:TDataSet;
begin
 //DataSet:=nil;
 //------Conexion segun ADO------
 {if TipoConexion=ADO then
    begin
      Dataset:= TADOQuery.Create(nil);
      with TADOQuery(DataSet) do
         begin
          Connection:=TADOConnection(Conexion);
          close;
          Parameters.ParseSQL(StrSql,True);
          sql.Clear;
          sql.Add(StrSql);
          if Not Cerrado then
              Open;
         end;
     end;
    }
 DataSet:=nil;
 if TipoConexion=FDAC then
    begin
      DataSet:= TFDQuery.Create(nil);
      with TFDQuery(DataSet) do
        begin
          Connection:=TFDConnection(Conexion);
          close;
          SQL.Clear;
          SQL.Add(StrSql);
          if Not Cerrado then
              DataSet.Open;
        end;
    end;
 //-----------------------
 //----------------Conexion Segun BDE------------
{ if TipoConexion=BDE then
    begin
      DataSet:=TQuery.Create(nil);
      with TQuery(DataSet) do
        begin
          DatabaseName:=TDataBase(Conexion).DatabaseName;
          sql.Clear;
          sql.Add(StrSql);
          try
            Open;
          except
            on E:EDataBaseError do
             begin
//                if E is EDBEngineError then
//                  begin
//                    if EDBEngineError(E).Errors[0].ErrorCode=1 then
//                      MessageDlg(PChar('Ocurri�n un Error al Conectarse con '
//                        +' la base de datos. Consulte con su Administrador')
//                        , mtError,[mbOk], 0);
//                  end
//                else
                  DatabaseError('Error al Consultar la base de datos.'
                    +' Consulte con su Administrador.'
                    +' C�digo de error: '
                    +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                    +'. Mensaje: '+E.Message
                    ,DataSet);
              end;
            on E:Exception do
                begin
                  raise Exception.Create(E.Message);
                end;
          end;
        end;
    end; }
 //----------------------------------------------
 Result:=DataSet;
end;

procedure TConexionDB.EjecutarSelect(StrSql:WideString;
    DBSource:TComponent);
begin
 if DBSource is TDataSource then
 with TDataSource(DBSource) Do
  begin
   //if AplicacionIni.ReadString('DataBase','Acceso','ADO') ='ADO' then
   {if TipoConexion=ADO then
      begin
        if DataSet = nil  then
          Dataset:= TADOQuery.Create(DBSource);
        with TADOQuery(DataSet) do
           begin
            Connection:=TADOConnection(Conexion);
            close;
            sql.Clear;
            sql.Add(StrSql);
            Open;
        end;
     end;
     }
   if TipoConexion=FDAC then
      begin
        if DataSet = nil then
          DataSet := TFDQuery.Create(DBSource);
        with TFDQuery(DataSet) do
          begin
            Connection:=TFDConnection(Conexion);
            close;
            SQL.Clear;
            sql.Add(StrSql);
            Open;
          end;

      end;

     //----------------Conexion Segun BDE------------
   {if TipoConexion=BDE then
     begin
        if DataSet = nil then
          begin
            DataSet:=TQuery.Create(nil);
            TQuery(DataSet).DatabaseName:=TDataBase(Conexion).DatabaseName;
          end;
        with TQuery(DataSet) do
          begin
            close;
            sql.Clear;
            sql.Add(StrSql);
            try
              Open;
            except
              on E:EDataBaseError do
               begin
                  //if E is EDBEngineError then
                  //  if EDBEngineError(E).Errors[0].ErrorCode=1 then

                  DatabaseError('Ocurri�n un Error al Conectarse con '
                        +' la base de datos. Consulte con su Administrador.'
                        +' C�digo de error: '
                        +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                        +'. Mensaje: '+E.Message
                        ,Conexion);
               end;
            end;
          end;
      end; }
     //----------------------------------------------
  end;// end del  With Datasource do

 if DBSource is TDataSetProvider then
 with TDataSetProvider(DBSource) Do
  begin
   //if AplicacionIni.ReadString('DataBase','Acceso','ADO') ='ADO' then
   if Assigned(TDataSetProvider(DBSource).DataSet) then
      TDataSetProvider(DBSource).DataSet.Free;
  { if TipoConexion=ADO then
      begin
        if DataSet = nil  then
          Dataset:= TADOQuery.Create(DBSource);
        with TADOQuery(DataSet) do
           begin
            Connection:=TADOConnection(Conexion);
            close;
            sql.Clear;
            sql.Add(StrSql);
            Open;
           end;
      end;
      }
     //----------------Conexion Segun BDE------------
   {if TipoConexion=BDE then
     begin
        if DataSet = nil then
          begin
            DataSet:=TQuery.Create(nil);
            TQuery(DataSet).DatabaseName:=TDataBase(Conexion).DatabaseName;
          end;
        with TQuery(DataSet) do
          begin
            close;
            sql.Clear;
            sql.Add(StrSql);
            try
              Open;
            except
              on E:EDataBaseError do
               begin
                  //if E is EDBEngineError then
                  //  if EDBEngineError(E).Errors[0].ErrorCode=1 then

                  DatabaseError('Ocurri�n un Error al Conectarse con '
                        +' la base de datos. Consulte con su Administrador.'
                        +' C�digo de error: '
                        +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                        +'. Mensaje: '+E.Message
                        ,Conexion);
               end;
            end;
          end;
      end;  }
     //----------------------------------------------
  end;// end del  With Datasource do


end;




procedure TConexionDB.AddAct(sql:string);
begin
  StrSQL.Add(sql);
end;

function TConexionDB.EjecutarAct:Integer;
var filasafectadas:integer;
begin
      if BasedeDatos=Advantage then
        filasafectadas:=InsertAdvantage;
      if BasedeDatos=MySQL then
        filasafectadas:=InsertMysql(StrSql);
  StrSql.Clear;      
  Result:=filasafectadas;      
end;



function TConexionDB.EjecutarAct(StrSql:TStrings):Integer;
//var  ADOquery:TADOQuery;
    // Query:TQuery;
      //EMsg:String;
var     i:integer;
     filasafectadas:integer;
begin
//  if AplicacionIni.ReadString('DataBase','Acceso','ADO') ='ADO' then
//  if TipoConexion=ADO then
//    begin
      //if AplicacionIni.ReadString('DataBase','DataBase','Advantage') ='MySQL' then
      if BasedeDatos=Advantage then
        filasafectadas:=InsertAdvantage;
      //if AplicacionIni.ReadString('DataBase','DataBase','Advantage') ='Advantage' then
      if BasedeDatos=MySQL then
        filasafectadas:=InsertMysql(StrSql);
   StrSQL.Clear;
   Result:=Filasafectadas;
//    end;
end;


function TConexionDB.EjecutarFireDACParamAct(StrSql:string
    ;const Parametros: array of Variant):Integer;
 var p:array of Variant;
      I:integer;
begin
    for I := 0 to length(Parametros) do
      p[I]:=Parametros[I];

      with TFDConnection(Conexion) do
        begin
          try
            ExecSQL('set wait_timeout=280');
          except
            on E: Exception do
              ShowMessage('Error de Base de Datos: '+e.Message);
          end;
          try
            StartTransaction;
            ExecSQL(StrSQL,p);
            Commit;

          except
            on E: Exception do
              begin
                Rollback;
                ExecSQL('set wait_timeout=2800');
                ShowMessage('Error de Base de Datos: '+e.Message);
              end;
          end;


        end;

end;

function TConexionDB.RetornarValorStrSqlDeCampo(Field:TField):string;

begin
  if Field.DataType=ftString then
    Result := QuotedStr(Field.AsString)
  else
    begin
      if (Field.DataType=ftDate)  then
        Result:=QuotedStr(FormatDateTime('yyyy-mm-dd',Field.AsDateTime))
      else
        if Field.DataType=ftDateTime then
          Result:=QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',Field.AsDateTime))
        else
          Result:=Field.AsString;
    End;
end;




function TConexionDB.EjecutarUpdateMaestroDetalle(DataSetMaestro: TDataSet
    ; DataSetDetalle: TDataSet; NombreTablaMaestro: string
    ; NombreTablaDetalle: string; CampoDetalleFK: string;CampoMaestroPK:string
      ; IdMaestro:integer):integer;
var TMaestroFD:TFDMemTable;
    TDetalleFD:TFDMemTable;
    SqlList:TStringList;
    StrSql:string;
    I:integer;
begin
  SqlList:=TStringList.Create();
  if TipoConexion=FDAC then
    begin
      TMaestroFD:=TFDMemTable(DataSetMaestro);
      TDetalleFD:=TFDMemTable(DataSetDetalle);
      if TMaestroFD.Fields.Count=0 then
          raise Exception.Create('La tabla maestro no tiene campos definidos');
      if TDetalleFD.Fields.Count=0 then
          raise Exception.Create('La tabla detalle no tiene campos definidos');
      with TMaestroFD do
        begin
          StrSql:='UPDATE '+NombreTablaMaestro+' SET ';
          StrSql:=StrSql+Fields[0].FieldName+'= '+RetornarValorStrSqlDeCampo(Fields[0]);

          for I:=1 to Fields.Count-1 do
            begin
              if  (Fields[I].Tag=0) then
                StrSql:=StrSql+','+Fields[I].FieldName+'= '+RetornarValorStrSqlDeCampo(Fields[I]);
            end;
          StrSql:=StrSql+' WHERE '+CampoMaestroPK+'='+IntToStr(IdMaestro);
          SqlList.Add(StrSql);
          StrSql:='';
        end;

      SqlList.Add('DELETE FROM '+NombreTablaDetalle+' WHERE '+CampoDetalleFK
                +'='+IntToStr(IdMaestro));

      with TDetalleFD do
        begin
          //metiendo el detalle - definicion de campos
          StrSql:='INSERT INTO '+NombreTablaDetalle+'('+CampoDetalleFK;
          for I := 0 to Fields.Count-1 do
            begin
              if(Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+Fields[I].FieldName;
                end;
            end;
          First;
          StrSql:=StrSql+') VALUES';

          //metiendo el valor del detalle - primer valor
          StrSql:=StrSql+'(';
          StrSql:=StrSql+IntToStr(IdMaestro);
          for I := 0 to Fields.Count-1 do
            begin
              if  (Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
            end;
          StrSql:=StrSql+')';
          Next;
          while not Eof do
            begin
              StrSql:=StrSql+',('+IntToStr(IdMaestro);
              for I := 0 to Fields.Count-1 do
                begin
                  if (Fields[I].Tag=0) then
                      StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
              StrSql:=StrSql+')';
              Next;
            end;
            SqlList.Add(StrSql);
        end;
    end;
  Result:=EjecutarAct(SqlList);
  SqlList.Free;
end;


procedure TConexionDB.RecuperarMaestroDetalle(DataSetMaestro:TDataSet
          ;DataSetDetalle:TDataSet;NombreTablaMaestro:string
          ;NombreTablaDetalle:string;CampoPK:string;CampoFK:string;idMaestro:integer
          );
  var DataSetAux:TDataSet;
      I:integer;
begin
  if (Trim(NombreTablaMaestro)='') or (Trim(NombreTablaDetalle)='') then
      raise Exception.Create('Indicar los nombres de las tablas maestro y detalle');

  DataSetAux:=EjecutarSelect('SELECT * FROM '+NombreTablaMaestro+' WHERE '
         +CampoPK+' = '+IntToStr(idMaestro)
        ,false);

  with DataSetAux do
    begin
      first;
      while not eof do
        begin
          DataSetMaestro.Append;
          for I := 0 to Fields.Count-1 do
            begin
              if (DataSetMaestro.FindField(Fields[I].FieldName)<>nil) and  (DataSetMaestro.FieldByName(Fields[I].FieldName).FieldKind=fkData) then
                begin
                  DataSetMaestro.FieldByName(Fields[I].FieldName).AsVariant:=
                      Fields[I].AsVariant;
                end;
            end;
          DataSetMaestro.Post;
          next;
        end;
    end;

  FreeAndNil(DataSetAux);

  DataSetAux:=EjecutarSelect('SELECT * FROM '+NombreTablaDetalle+' WHERE '+CampoPK+'='
      +IntToStr(idMaestro)
      ,false);


  with DataSetAux do
    begin
      first;
      while not eof do
        begin
          DataSetDetalle.Append;
          for I := 0 to Fields.Count-1 do
            begin
              if (DataSetDetalle.FindField(Fields[I].FieldName)<>nil)
                  and  (DataSetDetalle.FieldByName(Fields[I].FieldName).FieldKind=fkData) then
                begin
                  DataSetDetalle.FieldByName(Fields[I].FieldName).AsVariant:=
                      Fields[I].AsVariant;
                end;
            end;
          DataSetDetalle.Post;
          next;
        end;
    end;


  FreeAndNil(DataSetAux);


end;


function TConexionDB.EjecutarInsertTabla(DataSetTabla:TDataSet;TablaNombre:string):integer;
var TablaFD:TFDMemTable;
    DataSetAux:TDataSet;
    StrSql:string;
    SqlList:TStringList;
    I:integer;
begin
  SqlList:=TStringList.Create;

  if TipoConexion=FDAC then
    begin
      TablaFD:=TFDMemTable(DataSetTabla);
      if TablaFD.Fields.Count=0 then
          raise Exception.Create('La tabla notiene campos definidos');
      with TablaFD do
        begin
          StrSql:='INSERT INTO '+TablaNombre+'(';

          StrSql:=StrSql+Fields[0].FieldName;

          for I:=1 to Fields.Count-1 do
            begin
              if  (Fields[I].Tag=0) then
                StrSql:=StrSql+','+Fields[I].FieldName;
            end;
          StrSql:=StrSql+')';

          StrSql:=StrSql+' VALUES (';
         // if Fields[0] then

          StrSql:=StrSql+RetornarValorStrSqlDeCampo(Fields[0]);
          for I:=1  to Fields.Count-1 do
            begin
              if (Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
            end;
          StrSql:=StrSql+')';
          SqlList.Add(StrSql);
          SqlList.Add('SET @idCabecera=LAST_INSERT_ID()');

        end;
    end;
  EjecutarAct(SqlList);
  DataSetAux:=EjecutarSelect('SELECT @idCabecera AS ID',false);
  //devuelvo el id del registro Maestro insertado
  Result:=DataSetAux.FieldByName('ID').AsInteger;
  FreeAndNil(DataSetAux);
  FreeAndNil(SqlList);


end;

function TConexionDB.EjecutarInsertMaestroDetalle(DataSetMaestro:TDataSet
    ;DataSetDetalle:TDataSet;NombreTablaMaestro:string;NombreTablaDetalle:string
    ;CampoFK:string):integer;
var TMaestroFD:TFDMemTable;
    TDetalleFD:TFDMemTable;
    DataSetAux:TDataSet;
    SqlList:TStringList;
    StrSql:string;
    I:integer;
begin
  SqlList:=TStringList.Create();

  if TipoConexion=FDAC then
    begin
      TMaestroFD:=TFDMemTable(DataSetMaestro);
      TDetalleFD:=TFDMemTable(DataSetDetalle);
      if TMaestroFD.Fields.Count=0 then
          raise Exception.Create('La tabla maestro no tiene campos definidos');
      if TDetalleFD.Fields.Count=0 then
          raise Exception.Create('La tabla detalle no tiene campos definidos');

      with TMaestroFD do
        begin
          StrSql:= 'INSERT INTO '+NombreTablaMaestro+'(';

          StrSql:=StrSql+Fields[0].FieldName;

          for I:=1 to Fields.Count-1 do
            begin
              if  (Fields[I].Tag=0) then
                StrSql:=StrSql+','+Fields[I].FieldName;
            end;
          StrSql:=StrSql+')';

          StrSql:=StrSql+' VALUES (';
         // if Fields[0] then

          StrSql:=StrSql+RetornarValorStrSqlDeCampo(Fields[0]);
          for I:=1  to Fields.Count-1 do
            begin
              if (Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
            end;
          StrSql:=StrSql+')';
          SqlList.Add(StrSql+';');
        end;
      SqlList.Add('SET @idCabecera=LAST_INSERT_ID()');
      StrSql:='';
      with TDetalleFD do
        begin
          //metiendo el detalle - definicion de campos
          StrSql:='INSERT INTO '+NombreTablaDetalle+'('+CampoFK;
          for I := 0 to Fields.Count-1 do
            begin
              if(Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+Fields[I].FieldName;
                end;
            end;
          First;
          StrSql:=StrSql+') VALUES';

          //metiendo el valor del detalle - primer valor
          StrSql:=StrSql+'(';
          StrSql:=StrSql+'@idCabecera';
          for I := 0 to Fields.Count-1 do
            begin
              if  (Fields[I].Tag=0) then
                begin
                  StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
            end;
          StrSql:=StrSql+')';
          Next;
          while not Eof do
            begin
              StrSql:=StrSql+',(@idCabecera';
              for I := 0 to Fields.Count-1 do
                begin
                  if (Fields[I].Tag=0) then
                      StrSql:=StrSql+','+RetornarValorStrSqlDeCampo(Fields[I]);
                end;
              StrSql:=StrSql+')';
              Next;
            end;
          SqlList.Add(StrSql);

        end;

    end;
  EjecutarAct(SqlList);
  DataSetAux:=EjecutarSelect('SELECT @idCabecera AS ID',false);
  //devuelvo el id del registro Maestro insertado
  Result:=DataSetAux.FieldByName('ID').AsInteger;
  FreeAndNil(DataSetAux);
  FreeAndNil(SqlList);
end;


function TConexionDB.InsertMysql(StrSQL:TStrings):Integer;
var //ADOQuery:TADOQuery;
  //  Query:TQuery;
    i:integer;
    EMsg:String;
    afectados:integer;
begin
  afectados:=0;
  {if TipoConexion=ADO then
   begin
      ADOQuery:=TADOQuery.Create(nil);
      ADOQuery.Connection:=TADOConnection(Conexion);
      ADOQuery.ParamCheck:=False;
      ADOQuery.ExecuteOptions:=[eoExecuteNoRecords ]	;
      try
        with ADOQuery do
         begin
           SQL.Text:='set wait_timeout=280';
           ExecSQL;
           TADOConnection(Conexion).BeginTrans;
           for i:=0 to StrSql.Count-1 do
           begin
             SQL.Clear;
             SQL.Add(StrSQL[i]);
             ADOQuery.ExecSQL;;
             afectados:=RowsAffected;
             if Assigned(EventoDespuesInsertar) then
               EventoDespuesInsertar(StrSql[i],i);
            end;
           TADOConnection(Conexion).CommitTrans;
           StrSQL.Clear;
         end;
      except
         on E:EOleException do
            begin
              TADOConnection(Conexion).RollbackTrans;
              StrSQL.Clear;
              EMsg:=E.Message+'. EL NUMERO DE LINEA CON ERRORES ES: '+IntToStr(i);
              if Pos('Lost connection',EMsg)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                DataBaseError(EMsg,Conexion);
            end;
      end;
      ADOQuery.sql.Clear;
      Result:=ADOQuery.RowsAffected;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add('set wait_timeout=28800');
      ADOQuery.ExecSQL;
      ADOQuery.free;
   end; //FIN DEL IF DE ADO
   }

  if TipoConexion=FDAC then
    begin
      with TFDConnection(Conexion) do
        begin
          try
            ExecSQL('set wait_timeout=280');
          except
            on E: Exception do
              ShowMessage('Error de Base de Datos: '+e.Message);
          end;
          try
            StartTransaction;
            for i:=0 to StrSql.Count-1 do
               begin
                  afectados := afectados + ExecSQL(StrSQL[i]);
               end;
            Commit;
            ExecSQL('set wait_timeout=2800');
          except
            on E: Exception do
              begin
                Rollback;
                ExecSQL('set wait_timeout=2800');
                ShowMessage('Error de Base de Datos: '+e.Message);
              end;
          end;


        end;
    end;

            //si la conexi�n es BDE se hace lo siguiente
 { if TipoConexion=BDE then
    begin
      Query:=TQuery.Create(nil);
      Query.DataBaseName:=TDataBase(Conexion).DatabaseName;
      try
      with Query do
         begin
           SQL.Add('set wait_timeout=2800;');
           TDataBase(Conexion).StartTransaction;
           for i:=0 to StrSql.Count-1 do
           begin
             SQL.Add(StrSql[i]);
             ExecSQL;
             afectados:=Query.RowsAffected;
             if Assigned(EventoDespuesInsertar) then
               EventoDespuesInsertar(StrSql[i],i);
            end;
           TDataBase(Conexion).Commit;
           StrSql.Clear;
         end;
      except
         on E:EDataBaseError do
            begin
              if E is EDBEngineError then
                begin
                //  if EDBEngineError(E).Errors[0].ErrorCode=1 then
                //    begin
                    StrSQL.Clear;
                    DatabaseError('Ocurri�n un Error al Modificar '
                          +' los datos. Consulte con su Administrador.'
                          +' El c�digo de error es: '
                          +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                          +'. Mensaje: '+E.Message
                          ,Conexion);
                 //     Halt;
                //    end;
                end
              else
                DatabaseError(E.Message,Conexion);
            end;
         on E:Exception do
          begin
            raise Exception.Create(E.Message);
          end;
      end;
      //ADOQuery.sql.Clear;
      //ADOQuery.SQL.Add('set wait_timeout=28800');
      //ADOQuery.ExecSQL;
      ADOQuery.free;
    end;}//en del BDE
  Result:=afectados;
end;

procedure TConexionDB.ManejadorErrorTransaccion(E:Exception);
begin
{  if self.TipoConexion=BDE then
    begin
      TDataBase(Conexion).Rollback;
      if E is EDataBaseError then
        DataBaseError(E.Message,Conexion);
    end;     }
end;

function TConexionDB.InsertAdvantage:Integer;
var //ADOQuery:TADOQuery;
   // Query:TQuery;
    EMsg:String;
    i:integer;
    filasafectadas:integer;
begin
   //----Conexion segun ADO-------
  {if TipoConexion=ADO then
   begin
      ADOQuery:=TADOQuery.Create(nil);
      ADOQuery.Connection:=TADOConnection(Conexion);
      try
        with ADOQuery do
         begin
           //if TADOConnection(Conexion).InTransaction then
           //   TADOConnection(Conexion).RollbackTrans;
           //TADOConnection(Conexion).BeginTrans;
           for i:=0 to StrSql.Count-1 do
            begin
             sql.Clear;
             sql.Add(StrSql[i]);
               filasafectadas:=ExecSQL;
             if Assigned(EventoDespuesInsertar) then
                EventoDespuesInsertar(StrSql[i],i);
            end;
           //TADOConnection(Conexion).CommitTrans;

         end;
      except
         on E:EOleException do
            begin
              EMsg:=E.Message;
              if Pos('Lost connection',EMsg)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                begin
                 DataBaseError(EMsg,Conexion);
                 //TADOConnection(Conexion).RollbackTrans;
                end;
            end;
         on E:Exception do
          begin
            raise Exception.Create(E.Message);
          end;
      end;
     ADOQuery.free;
   end;
   }

 //--------------------------------------------
 //--------Conexi�n  segun BDE ---------

 { if TipoConexion=BDE then
    begin
      Query:=TQuery.Create(nil);
      try
        with Query do
         begin
           //if TDataBase(Conexion).InTransaction then
              //TDataBase(Conexion).Rollback;
           //TDataBase(Conexion).StartTransaction;
           Query.DatabaseName:=TDataBase(Conexion).DatabaseName;
           for i:=0 to StrSql.Count-1 do
            begin
             sql.Clear;
             sql.Add(StrSql[i]);
             ExecSQL;
             filasafectadas:=StrSQL.Count;
             if Assigned(EventoDespuesInsertar) then
                EventoDespuesInsertar(StrSql[i],i);
            end;
           //TDataBase(Conexion).Commit;
         end;
      except
         on E:EDataBaseError do
            begin
              if E is EDBEngineError then
                begin
                //  if EDBEngineError(E).Errors[0].ErrorCode=1 then
                //    begin
                    StrSQL.Clear;
                    DatabaseError('Ocurri�n un Error al Modificar '
                          +' los datos. Consulte con su Administrador.'
                          +' El c�digo de error es: '
                          +inttostr(EDBEngineError(E).Errors[0].ErrorCode)
                          +'. Mensaje: '+E.Message
                          ,Conexion);
                 //     Halt;
                //    end;
                end
              else
                DatabaseError(E.Message,Conexion);
            end;
         on E:Exception do
          begin
            raise Exception.Create(E.Message);
          end;
      end;
     Query.free;
    end; }
  //-----------------------------------------
  Result:=filasafectadas;
end;


procedure TConexionDB.IniciarTransaccion;
//var ADOQuery:TADOQuery;
begin
  {if TipoConexion=ADO then
   begin
      ADOQuery:=TADOQuery.Create(nil);
      ADOQuery.Connection:=TADOConnection(Conexion);
      ADOQuery.ParamCheck:=False;
      ADOQuery.ExecuteOptions:=[eoExecuteNoRecords ]	;
      try
        with ADOQuery do
         begin
           SQL.Text:='set wait_timeout=2800';
           ExecSQL;
           TADOConnection(Conexion).BeginTrans;
         end;
      except
         on E:EOleException do
            begin
              TADOConnection(Conexion).RollbackTrans;
              //StrSQL.Clear;
              if Pos('Lost connection',E.Message)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                DataBaseError(E.Message,Conexion);
            end;
      end;
      ADOQuery.free;
   end; //FIN DEL IF DE ADO
   }
  
end;

procedure TConexionDB.CerrarTransaccion;
//var ADOQuery:TADOQuery;
begin
  {if TipoConexion=ADO then
   begin
      ADOQuery:=TADOQuery.Create(nil);
      ADOQuery.Connection:=TADOConnection(Conexion);
      ADOQuery.ParamCheck:=False;
      ADOQuery.ExecuteOptions:=[eoExecuteNoRecords ]	;
      try
        if TADOConnection(Conexion).InTransaction then
         TADOConnection(Conexion).CommitTrans;
      except
         on E:EOleException do
            begin
              if TADOConnection(Conexion).InTransaction then
                TADOConnection(Conexion).RollbackTrans;
              if Pos('Lost connection',E.Message)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                DataBaseError(E.Message,Conexion);
            end;
      end;
      ADOQuery.sql.Clear;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add('set wait_timeout=28800');
      ADOQuery.ExecSQL;
      ADOQuery.free;
   end; //FIN DEL IF DE ADO
   }

end;


procedure TConexionDB.DeshacerTransaccion;
//var ADOQuery:TADOQuery;
begin
  {if TipoConexion=ADO then
   begin
      try
         if TADOConnection(Conexion).InTransaction then
           TADOConnection(Conexion).RollbackTrans;
      except
         on E:EOleException do
            begin
              if Pos('Lost connection',E.Message)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                DataBaseError(E.Message,Conexion);
            end;
      end;
   end; //FIN DEL IF DE ADO
   }

end;


function TConexionDB.EjecutarAct(StrSql:widestring):Integer;
//var ADOQuery:TADOQuery;
begin
  {if TipoConexion=ADO then
   begin
      ADOQuery:=TADOQuery.Create(nil);
      ADOQuery.Connection:=TADOConnection(Conexion);
      ADOQuery.ParamCheck:=False;
      ADOQuery.ExecuteOptions:=[eoExecuteNoRecords ]	;
      try
        with ADOQuery do
         begin
            SQL.Text:=StrSql;
            Result:=ADOQuery.ExecSQL;
         end;
      except
         on E:EOleException do
            begin
              if TADOConnection(Conexion).InTransaction then
                  TADOConnection(Conexion).RollbackTrans;
              if Pos('Lost connection',E.Message)>0 then
                 ShowMessage('La conexi�n con el servidor se Perdi�')
              else
                //DataBaseError(E.Message,Conexion);
                raise Exception.Create(E.message);
            end;
      end;
      ADOQuery.free;
   end; //FIN DEL IF DE ADO
   }

  if TipoConexion=FDAC then
    begin

    end;


end;




//-------------------------------------Funciones y Proc de TPrintDOS

constructor TPrintDOS.Create;
begin
 inherited create;
 linea:=StringOfChar(' ',80);
end;


procedure TPrintDOS.AgregarTexto(columna:word;texto:string);
var ancho,index,i,j:word;

begin
 j:=0;

 index:= Columnas[columna].xposicion;
 ancho:= Columnas[columna].ancho;
 for i:=index to index+ancho do
    begin
      inc(j);
      if j>length(texto) then
          break;
      linea[i]:=texto[j];
    end;
end;

procedure TPrintDOS.ImprimirLinea;
var lprint:string;
begin
  lprint:=linea;
  if trim(linea)<>'' then
    begin
      WriteLn(ArchivoPrn,lprint);
      linea:=StringOfChar(' ',80);
    end;
end;

procedure TPrintDOS.SaltarLinea;
begin
  WriteLn(ArchivoPrn,#10)
end;

procedure TPrintDOS.CrearColumna(Numero:word;Posicion:word;ancho:word);
begin
 if Posicion>Anchotexto then
    Posicion:=AnchoTexto;
 Columnas[Numero].XPosicion:=Posicion;
 if Posicion+ancho > AnchoTexto then
    ancho:=0;
 Columnas[Numero].Ancho:=AnchoTexto;
end;

procedure TPrintDOS.AbrirImpresion;
begin
  AssignPrn(ArchivoPrn);
  Rewrite(ArchivoPrn);
end;

procedure TPrintDOS.CerrarImpresion;
begin
 System.CloseFile(ArchivoPrn);
end;

procedure SetPaperSize (ancho,largo : Integer);
{aqui se define el tama�o del papel}
var
   ADevice, ADriver, APort : array [0..255] of Char;
   ADeviceMode : THandle;
   DevMode : PDevMode;
begin
   with Printer do
      begin
         GetPrinter (ADevice, ADriver, APort, ADeviceMode);
         SetPrinter (ADevice, ADriver, APort, 0);
         GetPrinter (ADevice, ADriver, APort, ADeviceMode);
         DevMode := GlobalLock(ADeviceMode);
         if not Assigned(DevMode) then
            ShowMessage('Ha entrado en -> if not Assigned(DevMode) ...')
         else
            begin
               with DevMode^ do
                  begin
                     dmPaperSize := DMPAPER_User;
                     dmPaperLength := largo;
                     dmPaperWidth:= ancho;
                	   dmFields := dmFields or DM_PAPERSIZE or DM_PAPERLength or DM_PAPERWidth;
                  end;
               GlobalUnLock(ADeviceMode);
               SetPrinter(ADevice, ADriver, APort, ADeviceMode);
           end;
      end;
  SetMapMode(Printer.Handle,MM_LoMetric);
end;


function StrConexion(Directorio:WideString):WideString;
var indexInicio,indexFinal:integer;
    ArchIni:TIniFile;
    ConnectionString:WideString;
begin
{  ArchIni:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + ArchivoIni);
  ConnectionString:=ArchIni.ReadString('Advantage','ConnectionString','');
  if Trim(ConnectionString)='' then
    begin
      ConnectionString:=ArchIni.ReadString('Advantage','ConnectionStringODBC','');
      indexInicio:=Pos(StrDefaultDir,ConnectionString);
      indexInicio:=indexInicio+length(StrDefaultDir);
      indexFinal:=Pos(DRIVERID,ConnectionString);
    end
  else
    begin
      indexInicio:=Pos(StrDataDirectory,ConnectionString);
      indexInicio:=indexInicio+length(StrDataDirectory);
      indexFinal:=Pos(StrServer,ConnectionString);
    end;
  Delete(ConnectionString,indexInicio,indexfinal-indexinicio);
  Insert('='+directorio+';',ConnectionString,indexInicio);
  Result:=ConnectionString;
  ArchIni.Free;    }
end;

function StrConexionODBCWindows(Directorio:WideString):WideString;
var indexInicio,indexFinal:integer;
    ArchIni:TIniFile;
    ConnectionString:WideString;
begin
{  ArchIni:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + ArchivoIni);
  ConnectionString:=ArchIni.ReadString('ODBCDBF','ConnectionString','');
  indexInicio:=Pos(StrDefaultDir,ConnectionString);
  indexInicio:=indexInicio+length(StrDefaultDir);
  indexFinal:=Pos(StrServer,ConnectionString);
  Delete(ConnectionString,indexInicio,indexfinal-indexinicio);
  Insert('='+directorio+';',ConnectionString,indexInicio);
  Result:=ConnectionString;
  ArchIni.Free;}
end;



{
  Uses: IdHashMessageDigest

  var
      Md5 : TidHashMessageDigest5
      Str : string; //cadena a cifrar con MD5
      Salida: string
      begin
          Md5 : TidHashMessageDigest5.create
          salida:= Md5.HashStringAsHex(str)
      end;
}


//---- funciones para nw----------------------------------

function StationNumber:byte;  { MY logical Station(connection)-Number }
var
 RetVal : Byte;
begin
 asm
   MOV AH, $DC;
   INT 21H
   MOV RetVal, AL;
 end;
 Result := Retval;
end;


//----------------------------------------------


initialization
  AplicacionIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + ArchivoIni);
  CoInitialize(nil);
  SysUtils.FormatSettings.DecimalSeparator:='.';
  ConexionDB:=TConexionDB.Create;
  AplicacionIni.Free;
finalization
  ConexionDB.Free;






end.
