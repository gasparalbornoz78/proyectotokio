unit Unit_Producto;

interface
uses Unit_BasedeDatos,Controls,DB,Classes,Provider,DBClient,StrUtils, {dbtables,} adodb;

type  TProducto=class
      private
      public
        constructor Create;
        destructor Destroy;
        procedure ingresoPRODUCTOS(nombre:string;CODIGO:string);
        procedure eliminarproductos(idproductos:integer);
end;

implementation

uses SysUtils;

Constructor Tproducto.Create;
begin
  inherited Create;
end;

destructor Tproducto.Destroy;
begin
  inherited Destroy;
end;

procedure Tproducto.eliminarproductos(idproductos:integer);
var sql:string;
begin
  sql:=' update productos set eliminado=1,fechamodi=now()'
      +' where idproductos='+IntToStr(idproductos);
  ConexionDB.EjecutarAct(sql);
end;

procedure Tproducto.ingresoproductos(nombre:string;codigo:string);
var sql:TStringList;
begin
  sql:=TStringList.Create();
  sql.Add(' insert into productos (idproductos,descripcion,codigo,fechaalta) values ('
         +'null,'
         +QuotedStr(nombre)+','
         +(CODIGO)+','
         +'now()'
         +');'
         );

  ConexionDB.EjecutarAct(sql);
  sql.Free;
end;

end.
