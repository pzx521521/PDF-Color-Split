object Form1: TForm1
  Left = 340
  Top = 291
  Caption = 'PDF Color Split'
  ClientHeight = 506
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 512
    Top = 0
    Width = 134
    Height = 506
    Align = alRight
    TabOrder = 0
    object lbl1: TLabel
      Left = 6
      Top = 184
      Width = 108
      Height = 13
      Caption = #33394#24425#20559#24046'('#36755#20837'0-255)'
    end
    object btn1: TButton
      Left = 32
      Top = 448
      Width = 75
      Height = 25
      Caption = #25191#34892
      TabOrder = 0
      OnClick = btn1Click
    end
    object btn3: TButton
      Left = 32
      Top = 33
      Width = 75
      Height = 25
      Caption = #23548#20837#25991#20214#22841
      TabOrder = 1
      OnClick = btn3Click
    end
    object chk1: TCheckBox
      Left = 6
      Top = 77
      Width = 121
      Height = 81
      Caption = #20998#21106'PDF('#21246#36873#27492#39033#21518#20250#23558'pdf'#20998#21106#20026'2'#20010#25991#20214#24182#20998#21035#20445#23384', '#21542#21017#30340#35805#23558#37325#21629#21517#28304#25991#20214')'
      TabOrder = 2
      WordWrap = True
    end
    object edt1: TEdit
      Left = 8
      Top = 208
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '0'
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 506
    Align = alClient
    Caption = #35831#23548#20837#25991#20214#22841#24182#28857#20987#25191#34892
    TabOrder = 1
    ExplicitLeft = 488
    ExplicitTop = 304
    ExplicitWidth = 185
    ExplicitHeight = 137
    object img1: TImage
      Left = 1
      Top = 1
      Width = 510
      Height = 504
      Align = alClient
      ExplicitWidth = 320
    end
  end
end
