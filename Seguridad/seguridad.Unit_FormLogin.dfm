object FormLogin: TFormLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Ingreso al Sistema'
  ClientHeight = 241
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 515
    Height = 200
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 88
      Top = 69
      Width = 95
      Height = 13
      Caption = 'Nombre de Usuario:'
    end
    object Label2: TLabel
      Left = 88
      Top = 131
      Width = 60
      Height = 13
      Caption = 'Contrase'#241'a:'
    end
    object EditNombreUsuario: TEdit
      Left = 189
      Top = 66
      Width = 196
      Height = 21
      TabOrder = 0
    end
    object EditPassword: TEdit
      Left = 189
      Top = 128
      Width = 196
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 200
    Width = 515
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 40
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ingresar'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 384
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
