object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema Tokio'
  ClientHeight = 465
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MenuPrincipal
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 691
    Height = 29
    Caption = 'ActionToolBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Spacing = 0
  end
  object Button1: TButton
    Left = 248
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Alta de Usuario'
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object MenuPrincipal: TMainMenu
    Left = 472
    Top = 248
    object OrdendeCompra1: TMenuItem
      Caption = 'Orden de Compra'
      object AltadeOrdendeCompra1: TMenuItem
        Action = ActionAltaOrdendeCompra
      end
      object ListadodeOrdendeCompra1: TMenuItem
        Action = ActionListadoOrdendeCompra
      end
    end
    object AltadeUsuario1: TMenuItem
      Caption = 'Usuarios'
      OnClick = ActionAltadeUsuarioExecute
      object AltadeUsuario2: TMenuItem
        Action = ActionAltadeUsuario
      end
    end
  end
  object ActionListPrincipal: TActionList
    Left = 256
    Top = 152
    object ActionAltaOrdendeCompra: TAction
      Category = 'Orden de Compra'
      Caption = 'Alta de Orden de Compra'
      OnExecute = ActionAltaOrdendeCompraExecute
    end
    object ActionListadoOrdendeCompra: TAction
      Category = 'Orden de Compra'
      Caption = 'Listado de Orden de Compra'
      OnExecute = ActionListadoOrdendeCompraExecute
    end
    object ActionAltadeUsuario: TAction
      Category = 'Usuarios'
      Caption = 'Alta de Usuario'
      OnExecute = ActionAltadeUsuarioExecute
    end
  end
end
