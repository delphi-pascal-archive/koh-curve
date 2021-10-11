object fMain: TfMain
  Left = 246
  Top = 126
  Width = 800
  Height = 733
  Caption = 'Courbe de Von Koch par Martin AJARD'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 50
    Align = alTop
    Caption = 'Courbe de Von Koch'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -28
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object sbAbout: TSpeedButton
      Left = 817
      Top = 10
      Width = 139
      Height = 33
      Caption = 'A propos ..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = sbAboutClick
    end
  end
  object pNiveau: TPanel
    Left = 0
    Top = 50
    Width = 792
    Height = 48
    Align = alTop
    Caption = 'Niveau : 1'
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      792
      48)
    object sbNext: TSpeedButton
      Left = 551
      Top = 10
      Width = 228
      Height = 29
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Niveau Suivant'
      OnClick = sbNextClick
    end
    object sbPrevious: TSpeedButton
      Left = 15
      Top = 10
      Width = 227
      Height = 29
      Caption = 'Niveau pr'#1081'c'#1081'dant'
      OnClick = sbPreviousClick
    end
  end
  object sg: TStringGrid
    Left = 0
    Top = 496
    Width = 792
    Height = 209
    Align = alBottom
    ColCount = 257
    DefaultColWidth = 32
    DefaultRowHeight = 18
    DefaultDrawing = False
    RowCount = 10
    TabOrder = 2
    OnDrawCell = sgDrawCell
  end
end
