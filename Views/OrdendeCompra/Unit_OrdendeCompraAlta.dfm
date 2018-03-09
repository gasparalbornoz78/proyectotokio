object FormAltaOrdendeCompra: TFormAltaOrdendeCompra
  Left = 0
  Top = 0
  Caption = 'Alta Orden de Compra'
  ClientHeight = 475
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 193
    Align = alTop
    TabOrder = 0
    ExplicitTop = -6
    object Label1: TLabel
      Left = 16
      Top = 50
      Width = 54
      Height = 13
      Caption = 'Proveedor:'
    end
    object DBText1: TDBText
      Left = 179
      Top = 50
      Width = 406
      Height = 17
      DataField = 'RazonSocialProveedor'
      DataSource = DSCabecera
    end
    object Label2: TLabel
      Left = 16
      Top = 9
      Width = 74
      Height = 13
      Caption = 'Fecha Entrega:'
    end
    object Label3: TLabel
      Left = 16
      Top = 90
      Width = 61
      Height = 13
      Caption = 'Condiciones:'
    end
    object DBText2: TDBText
      Left = 179
      Top = 90
      Width = 65
      Height = 17
      DataSource = DSCabecera
    end
    object DBEditProveedor: TDBEdit
      Left = 96
      Top = 47
      Width = 77
      Height = 21
      DataField = 'idProveedor'
      DataSource = DSCabecera
      TabOrder = 1
    end
    object DBEdit2: TDBEdit
      Left = 96
      Top = 87
      Width = 77
      Height = 21
      DataField = 'idCONDICIONES'
      DataSource = DSCabecera
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 96
      Top = 6
      Width = 77
      Height = 21
      DataField = 'FechaEntrega'
      DataSource = DSCabecera
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 415
    Width = 664
    Height = 60
    Align = alBottom
    TabOrder = 2
    object Button1: TButton
      Left = 155
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Guardar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 416
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 1
    end
  end
  object DBGridDetalle: TDBGrid
    Tag = 1
    Left = 0
    Top = 193
    Width = 664
    Height = 222
    Align = alClient
    DataSource = DSDetalle
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'idPRODUCTOS'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CODIGOPRODUCTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Detalle'
        ReadOnly = True
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDAD'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDADSATISFECHA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDADBONIFICADA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDADBONIFICADASATISFECHA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COSTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTALDESCUENTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDADBULTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CANTIDADBONIFBULTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTALDESCUENTOMONTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BULTOPROV'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COSTOCONDESCUENTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SUBTOTAL'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DIASSTOCK'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COSTODESCBONIFICACION'
        Visible = True
      end>
  end
  object DSDetalle: TDataSource
    DataSet = FDMemTDetalle
    Left = 360
    Top = 136
  end
  object FDMemTDetalle: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 136
    object FDMemTDetalleidPRODUCTOS: TIntegerField
      FieldName = 'idPRODUCTOS'
    end
    object FDMemTDetalleCODIGOPRODUCTO: TIntegerField
      Tag = 1
      FieldName = 'CODIGOPRODUCTO'
    end
    object FDMemTDetalleDetalle: TStringField
      FieldName = 'Detalle'
      Size = 60
    end
    object FDMemTDetalleCANTIDAD: TIntegerField
      DefaultExpression = '0'
      FieldName = 'CANTIDAD'
    end
    object FDMemTDetalleCANTIDADSATISFECHA: TFloatField
      DefaultExpression = '0'
      FieldName = 'CANTIDADSATISFECHA'
    end
    object FDMemTDetalleCANTIDADBONIFICADA: TFloatField
      DefaultExpression = '0'
      FieldName = 'CANTIDADBONIFICADA'
    end
    object FDMemTDetalleCANTIDADBONIFICADASATISFECHA: TFloatField
      DefaultExpression = '0'
      FieldName = 'CANTIDADBONIFSATISFECHA'
    end
    object FDMemTDetalleCOSTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'COSTO'
    end
    object FDMemTDetalleTOTALDESCUENTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'TOTALDESCUENTO'
    end
    object FDMemTDetalleCANTIDADBULTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'CANTIDADBULTO'
    end
    object FDMemTDetalleCANTIDADBONIFBULTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'CANTIDADBONIFBULTO'
    end
    object FDMemTDetalleTOTALDESCUENTOMONTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'TOTALDESCUENTOMONTO'
    end
    object FDMemTDetalleBULTOPROV: TFloatField
      DefaultExpression = '0'
      FieldName = 'BULTOPROV'
    end
    object FDMemTDetalleCOSTOCONDESCUENTO: TFloatField
      DefaultExpression = '0'
      FieldName = 'COSTOCONDESCUENTO'
    end
    object FDMemTDetalleSUBTOTAL: TFloatField
      DefaultExpression = '0'
      FieldName = 'SUBTOTAL'
    end
    object FDMemTDetalleDIASSTOCK: TFloatField
      DefaultExpression = '0'
      FieldName = 'DIASSTOCK'
    end
    object FDMemTDetalleCOSTODESCBONIFICACION: TFloatField
      DefaultExpression = '0'
      FieldName = 'COSTODESCBONIFICACION'
    end
  end
  object FDMemTCabecera: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 544
    Top = 57
    object FDMemTCabeceraFechaEntrega: TDateField
      FieldName = 'FechaEntrega'
    end
    object FDMemTCabeceraidProveedor: TIntegerField
      FieldName = 'idProveedor'
    end
    object FDMemTCabeceraFecha: TDateField
      FieldName = 'Fecha'
    end
    object FDMemTCabeceraObservacion: TStringField
      FieldName = 'Observacion'
      Size = 60
    end
    object FDMemTCabeceraTotal: TFloatField
      DefaultExpression = '0'
      FieldName = 'Total'
    end
    object FDMemTCabeceraIvaRet: TFloatField
      DefaultExpression = '0'
      FieldName = 'IvaRet'
    end
    object FDMemTCabeceraImpInterno: TFloatField
      DefaultExpression = '0'
      FieldName = 'ImpInterno'
    end
    object FDMemTCabeceraIVA21: TFloatField
      DefaultExpression = '0'
      FieldName = 'IVA21'
    end
    object FDMemTCabeceraIVA105: TFloatField
      DefaultExpression = '0'
      FieldName = 'IVA105'
    end
    object FDMemTCabeceraIngBruto: TFloatField
      DefaultExpression = '0'
      FieldName = 'IngBruto'
    end
    object FDMemTCabeceraANULADA: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'ANULADA'
    end
    object FDMemTCabeceraSatisfecha: TBooleanField
      DefaultExpression = 'false'
      FieldName = 'Satisfecha'
    end
    object FDMemTCabeceraOBCONDICIONES: TStringField
      FieldName = 'OBCONDICIONES'
      Size = 60
    end
    object FDMemTCabeceraIDUSUARIODESC: TIntegerField
      DefaultExpression = '0'
      FieldName = 'IDUSUARIODESC'
    end
    object FDMemTCabeceraFECHADESC: TDateField
      FieldName = 'FECHADESC'
    end
    object FDMemTCabeceraIDPROVPARTICULAR: TIntegerField
      DefaultExpression = '0'
      FieldName = 'IDPROVPARTICULAR'
    end
    object FDMemTCabeceraidPROCESOSVERDURA: TIntegerField
      DefaultExpression = '0'
      FieldName = 'idPROCESOSVERDURA'
    end
    object FDMemTCabeceraidCONDICIONES: TIntegerField
      DefaultExpression = '0'
      FieldName = 'idCONDICIONES'
    end
    object FDMemTCabeceraRazonSocialProveedor: TStringField
      FieldName = 'RazonSocialProveedor'
      Size = 60
    end
    object FDMemTCabeceraNUMERO: TIntegerField
      Tag = 1
      FieldName = 'NUMERO'
    end
  end
  object DSCabecera: TDataSource
    DataSet = FDMemTCabecera
    Left = 352
    Top = 40
  end
  object DataSource1: TDataSource
    DataSet = FDMemTCabecera
    Left = 424
    Top = 80
  end
end
