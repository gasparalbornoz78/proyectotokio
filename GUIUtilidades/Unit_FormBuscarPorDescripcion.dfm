object FormBuscarPorDescripcion: TFormBuscarPorDescripcion
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'B'#250'squeda por Descripci'#243'n'
  ClientHeight = 400
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 89
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 104
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Filtro:'
    end
    object EditFiltro: TEdit
      Tag = 3
      Left = 152
      Top = 21
      Width = 169
      Height = 21
      TabOrder = 0
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 89
    Width = 520
    Height = 311
    TabStop = False
    Align = alClient
    DataSource = DSBusqueda
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGridDblClick
  end
  object BotonCancelar: TButton
    Left = 246
    Top = 375
    Width = 91
    Height = 25
    Caption = 'Bot'#243'n Cancelar'
    ModalResult = 2
    TabOrder = 2
    Visible = False
  end
  object DSBusqueda: TDataSource
    Left = 240
    Top = 152
  end
end
