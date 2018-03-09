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
  object MenuPrincipal: TMainMenu
    Left = 504
    Top = 80
    object OrdendeCompra1: TMenuItem
      Caption = 'Orden de Compra'
      object AltadeOrdendeCompra1: TMenuItem
        Action = ActionAltaOrdendeCompra
      end
      object ListadodeOrdendeCompra1: TMenuItem
        Action = ActionListadoOrdendeCompra
      end
    end
  end
  object ActionListPrincipal: TActionList
    Left = 368
    Top = 64
    object ActionAltaOrdendeCompra: TAction
      Caption = 'Alta de Orden de Compra'
      OnExecute = ActionAltaOrdendeCompraExecute
    end
    object ActionListadoOrdendeCompra: TAction
      Caption = 'Listado de Orden de Compra'
      OnExecute = ActionListadoOrdendeCompraExecute
    end
  end
end
