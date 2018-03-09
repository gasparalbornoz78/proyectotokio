unit Utilidades.JSONDataset;

interface

uses
    System.JSON, FireDAC.Comp.Client, System.SysUtils,Data.DB
    ,System.Classes,Vcl.Dialogs,System.IOUtils;

type
  TJSONDataSet = class
      private
        RawString  : TBytes;
        DatosArray : TJSONArray;
        DataSetJson : TFDMemTable;
        DataSet : TDataSet;
        function GetDataSet:TDataSet;
        function GetDataSetJson:TDataSet;
        procedure SetDataSet(Source:TDataSet);
        procedure createDataSetJsonFields(JSONArray:TJSONArray);
      protected

      public
         constructor Create;
         destructor Destroy;

         property DataSetAParsear:TDataSet read GetDataSet  write SetDataSet;
         property DataSetParseado:TDataSet read GetDataSetJson;

         procedure GenerarArchivo(Path:string;FileName:string);
         procedure CrearDataSetJson(Path:string;FileName:string);


  end;

implementation

constructor TJSONDataSet.Create;
begin
  inherited Create;
  self.DataSetJson:=TFDMemTable.Create(nil);

end;

destructor TJSONDataSet.Destroy;
begin
  self.DataSetJson.Free;
  self.DatosArray.Free;
  inherited Destroy;
end;

procedure TJSONDataSet.generarArchivo(Path:string;FileName:string);
  var
      Campos: TStringList;
      I:integer;
      JSONObject : TJSONObject;
      JSONArray : TJSONArray;
      StringListFile : TStringList;
begin
  StringListFile := TStringList.Create;

  if not Assigned(DataSet) then
    begin
      raise Exception.Create('No se puede generar el archivo JSON si no hay un DataSet asignado');
    end;

  JSONArray:=TJSONArray.Create;
  Campos := TStringList.Create;


  with DataSet do
    begin
      Fields.GetFieldNames(Campos);
      First;
      while not Eof do
        begin
          JSONObject := TJSONObject.Create;
          for I := 0 to Campos.Count-1 do
            begin
              //TODO validar los valores nulos
              JSONObject.AddPair(Campos[I],FieldByName(Campos[I]).Value)
            end;
          JSONArray.AddElement(JSONObject);
          Next;
        end;
    end;

    StringListFile.Text := JSONArray.ToJSON;
    StringListFile.SaveToFile(Path+FileName);
    campos.Free;
    StringListFile.Free;

end;



function TJSONDataSet.GetDataSetJson;
begin
  result:=DataSetJson;
end;




function TJSONDataset.GetDataSet:TDataSet;
begin
  Result:=DataSet;
end;

procedure TJSONDataSet.SetDataSet(Source:TDataSet);
begin
  self.DataSet:=Source;

end;


procedure TJSONDataSet.createDataSetJsonFields(JSONArray:TJSONArray);
var //Field:TField;
    JSONObject : TJSONObject;
    I:integer;

begin
  if  (JSONArray.Count<=0) then
      raise Exception.Create('No se puede generar la estructura de campos en una array vacío');
  JSONObject := JSONArray.Items[0] as TJSONObject;
  with self.DataSetJson do
    begin
      if Active then
        ClearFields;
      for I:=0 to JSONObject.Size-1 do
        begin

          if JSONObject.Pairs[I].JsonValue is TJSONNumber then
            begin
              //Field := TFloatField.Create(DataSetJson);
              Self.DataSetJson.FieldDefs.Add(JSONObject.Pairs[I].JsonString.ToString.Replace('"',''),ftFloat,0,false);
              Self.DataSetJson.FieldDefs[I].CreateField(DataSetJson);
            end
          else
            begin
              //Field := TStringField.Create(DataSetJson);
              Self.DataSetJson.FieldDefs.Add(JSONObject.Pairs[I].JsonString.ToString.Replace('"',''),ftString,60,false);
              Self.DataSetJson.FieldDefs[I].CreateField(DataSetJson);
            end;
          //Field.FieldName:=JSONObject.Pairs[I].JsonString.ToString.Replace('"','');

          //Self.DataSetJson.Fields.Add(field);
        end;
        CreateDataSet;
        Self.DataSetJson.Open;
    end;
end;


procedure TJSONDataSet.CrearDataSetJson(Path: string; FileName: string);
 var data: TBytes;
      JSONArray : TJSONArray;
      I,J, K : Integer;

      Car, JSONPrice: TJSONObject;//eliminar luego

      JSONObject : TJSONObject;

      CarPrice: Double;
      s, CarName, CarManufacturer, CarCurrencyType: string;

begin
        data := TEncoding.ASCII.GetBytes(TFile.ReadAllText(path+FileName));
        s := '';
        JSONArray := TJSONObject.ParseJSONValue(data,0)
        as TJSONArray;
        if not Assigned(JSONArray) then
            raise Exception.Create('No es un archivo JSON Válido');
        createDataSetJsonFields(JSONArray);
        try
          for I := 0 to JSONArray.Count - 1 do
            begin
              {Car := JSONArray.Items[I] as TJSONObject;
              CarName := Car.GetValue('name').Value;
              CarManufacturer := Car.GetValue('manufacturer').Value;
              JSONPrice := Car.GetValue('price') as TJSONObject;
              CarPrice := (JSONPrice.GetValue('value') as TJSONNumber).AsDouble;
              CarCurrencyType := JSONPrice.GetValue('currency').Value;
              }
              DataSetJson.Append;
              JSONObject := (JSONArray.Items[I] as TJSONObject);
              for J := 0 to JSONObject.Size-1 do
                begin

                  with DataSetParseado as TFDMemTable do
                    begin
                      if JSONObject.Pairs[J].JsonValue is TJSONNumber then
                          FieldByName(JSONObject.Pairs[J].JsonString.ToString.Replace('"','')).AsFloat:=
                              (JSONObject.Pairs[J].JsonValue as TJSONNumber).AsDouble
                      else
                        begin
                          FieldByName(JSONObject.Pairs[J].JsonString.ToString.Replace('"','')).AsString:=
                              (JSONObject.Pairs[J].JsonValue as TJSONString).Value;

                        end;
                    end;
                end;
              DataSetJson.Post;
            end;

        finally
          JSONArray.Free;
        end;


end;


end.
