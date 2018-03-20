object FormAltaUsuario: TFormAltaUsuario
  Left = 0
  Top = 0
  Caption = 'Alta de Usuario'
  ClientHeight = 262
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 586
    Height = 221
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 136
    ExplicitTop = -6
    object Label1: TLabel
      Left = 111
      Top = 64
      Width = 41
      Height = 13
      Caption = 'Nombre:'
    end
    object Label2: TLabel
      Left = 111
      Top = 104
      Width = 85
      Height = 13
      Caption = 'Nombre Completo'
    end
    object Label3: TLabel
      Left = 111
      Top = 144
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object DBEditNombre: TDBEdit
      Left = 232
      Top = 61
      Width = 121
      Height = 21
      DataField = 'NOMBRE'
      DataSource = DSSource
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 232
      Top = 104
      Width = 121
      Height = 21
      DataField = 'NOMBRECOMPLETO'
      DataSource = DSSource
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 232
      Top = 141
      Width = 121
      Height = 21
      DataField = 'PASSWORD'
      DataSource = DSSource
      PasswordChar = '*'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 221
    Width = 586
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 288
    ExplicitTop = 200
    ExplicitWidth = 185
    object Button1: TButton
      Left = 32
      Top = 6
      Width = 75
      Height = 25
      Action = FormAltaUsuario_ActionGuardar
      TabOrder = 0
    end
    object Button2: TButton
      Left = 480
      Top = 6
      Width = 75
      Height = 25
      Action = FormAltaUsuario_ActionCancelar
      TabOrder = 1
    end
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 440
    Top = 128
    object FDMemTableNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 60
    end
    object FDMemTableNOMBRECOMPLETO: TStringField
      FieldName = 'NOMBRECOMPLETO'
      Size = 60
    end
    object FDMemTablePASSWORD: TStringField
      FieldName = 'PASSWORD'
      Size = 60
    end
  end
  object ActionList: TActionList
    Left = 288
    Top = 216
    object FormAltaUsuario_ActionGuardar: TAction
      Caption = 'Guardar'
      OnExecute = FormAltaUsuario_ActionGuardarExecute
    end
    object FormAltaUsuario_ActionCancelar: TAction
      Caption = 'Cancelar'
      OnExecute = FormAltaUsuario_ActionCancelarExecute
    end
  end
  object DSSource: TDataSource
    DataSet = FDMemTable
    Left = 512
    Top = 152
  end
end
