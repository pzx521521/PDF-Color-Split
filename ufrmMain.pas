unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, PDFium, Types, IOUtils;

type
  TForm1 = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    img1: TImage;
    btn1: TButton;
    btn3: TButton;
    chk1: TCheckBox;
    lbl1: TLabel;
    edt1: TEdit;
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    files: TStringDynArray;
    PdfView: TPdfView;
    pdf: TPdf;
    offset: Integer;
    procedure DoFile(sFileName: string);
    procedure DoFileSplite(sFileName: string);
    procedure SavePdf(sFileName, sRange: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  FileCtrl;
{$R *.dfm}

function isColorful(Color: TColor; offset: Integer): Boolean;
var
  R, G, B: Byte;
begin
  Result := False;
  R := Color and $FF;
  G := (Color and $FF00) shr 8;
  B := (Color and $FF0000) shr 16;
  if (abs(R-B)>offset) or (abs(R-G)>offset) or (abs(B-G)>offset) then
    Exit(True)
end;

function isColorPage(aBitmap: TBitmap; offset: Integer): Boolean;
var
  h, w: Integer;
begin
  Result := False;
  for h := 0 to aBitmap.Height - 1 do
  begin
    for w := 0 to aBitmap.Width - 1 do
    begin
      if isColorful(aBitmap.Canvas.Pixels[w, h], offset) then
      begin
        aBitmap.Canvas.Pixels[w, h] := clRed;
        Exit(True)
      end;
    end;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  sFile: string;
begin
  offset := StrToIntDef(edt1.Text, 0);
  for sFile in files do
  begin
    if chk1.Checked then
      DoFileSplite(sFile)
    else
      DoFile(sFile)
  end;
  ShowMessage('OK');
end;

procedure TForm1.btn3Click(Sender: TObject);
var
  TmpDir: string;
begin
  TmpDir := ExtractFilePath(ParamStr(0));
  if not SelectDirectory('请选择文件夹', '', TmpDir) then
    exit;
  files := TDirectory.GetFiles(TmpDir, '*.pdf', TSearchOption.soAllDirectories);
  Caption := '共' + IntToStr(Length(files)) + '个文件'
end;

procedure TForm1.SavePdf(sFileName: string; sRange: string);
var
  newPdf: TPdf;
begin
  if sRange = '' then  Exit;
  newPdf := TPdf.Create(nil);
  try
    newPdf.CreateDocument;
    newPdf.ImportPages(pdf, sRange);
    newPdf.SaveAs(sFileName);
  finally
    newPdf.Active := False;
    newPdf.Free;
  end;
end;

procedure TForm1.DoFileSplite(sFileName: string);
var
  I: Integer;
  pdfColorful, pdfGray: TPdf;
  RangeColorful, RangeGray: string;

  function AddRange(index: Integer; sRange: string): string;
  begin
    if sRange = '' then
      Result := IntToStr(I)
    else
      Result := sRange + ',' + IntToStr(I);
  end;

begin
  pdf.FileName := sFileName;
  pdf.Active := True;
  PdfView.Pdf := pdf;
  for I := 1 to pdf.PageCount do
  begin
    pdf.PageNumber := I;
    PdfView.PageNumber := I;
    PdfView.Active := True;
    PdfView.ReloadPage;
    img1.Picture.Bitmap.Free;
    img1.Picture.Bitmap := PdfView.RenderPage(0, 0, Trunc(pdf.PageWidth), Trunc(pdf.PageHeight));
    if isColorPage(img1.Picture.Bitmap, offset) then
      RangeColorful := AddRange(I, RangeColorful)
    else
      RangeGray := AddRange(I, RangeGray);
    Application.ProcessMessages;
  end;
  SavePdf(ExtractFilePath(sFileName) + ChangeFileExt(ExtractFileName(sFileName),
    '') + '_Colorful' + ExtractFileExt(sFileName), RangeColorful);
  SavePdf(ExtractFilePath(sFileName) + ChangeFileExt(ExtractFileName(sFileName),
    '') + '_Gray' + ExtractFileExt(sFileName), RangeGray);
  pdf.Active := False;
end;

procedure TForm1.DoFile(sFileName: string);
var
  I: Integer;
begin
  pdf.FileName := sFileName;
  pdf.Active := True;
  PdfView.Pdf := pdf;
  for I := 1 to pdf.PageCount do
  begin
    pdf.PageNumber := I;
    PdfView.PageNumber := I;
    PdfView.Active := True;
    PdfView.ReloadPage;
    img1.Picture.Bitmap.Free;
    img1.Picture.Bitmap := PdfView.RenderPage(0, 0, Trunc(pdf.PageWidth), Trunc(pdf.PageHeight));
    if isColorPage(img1.Picture.Bitmap, offset) then
    begin
      pdf.Active := False;
      RenameFile(sFileName, ExtractFilePath(sFileName) + ChangeFileExt(ExtractFileName
        (sFileName), '') + '_Colorful' + ExtractFileExt(sFileName));
      Exit();
    end;
    Application.ProcessMessages;
  end;
  RenameFile(sFileName, ExtractFilePath(sFileName) + ChangeFileExt(ExtractFileName
    (sFileName), '') + '_Gray' + ExtractFileExt(sFileName));
  pdf.Active := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  TmpDir: string;
begin
  PdfView := TPdfView.Create(nil);
  pdf := TPdf.Create(nil);
  TmpDir := ExtractFilePath(ParamStr(0));
  files := TDirectory.GetFiles(TmpDir, '*.pdf', TSearchOption.soAllDirectories);
  Caption := '共' + IntToStr(Length(files)) + '个文件'
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  pdf.Free;
  PdfView.Free;
end;

end.

