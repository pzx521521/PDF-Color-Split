//---------------------------------------------------------------------
//
// PDFium Component Suite
//
// Copyright (c) 2014-2019 WINSOFT
//
//---------------------------------------------------------------------

unit PDFiumE;

interface

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}
{$endif}

procedure Register;

implementation

{$ifdef FPC}
uses Classes, PropEdits, ComponentEditors, lresources, SysUtils, Dialogs, PDFium;
{$else}
uses Classes, {$ifdef D6PLUS} DesignIntf, DesignEditors {$else} DsgnIntf {$endif D6PLUS}, SysUtils, Dialogs, PDFium;
{$endif FPC}

// ----- TDocumentNameProperty -----

type
  TFileNameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

function TFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

procedure TFileNameProperty.Edit;
const
  OpenFilter = 'PDF files (*.pdf)|*.pdf|All files (*.*)|*.*';
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := ExtractFileName(GetValue);
    InitialDir := ExtractFilePath(GetValue);
    Filter := OpenFilter;
    Options := Options + [ofPathMustExist, ofFileMustExist];
    if Execute then
      SetValue(FileName);
  finally
    Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('PDFium', [TPdf, TPdfView]);
  RegisterPropertyEditor(TypeInfo(string), TPdf, 'FileName', TFileNameProperty);
end;

{$ifdef FPC}
initialization
  {$i pdfiump.lrs}
{$endif FPC}
end.