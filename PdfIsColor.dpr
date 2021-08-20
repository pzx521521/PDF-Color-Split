program PdfIsColor;

uses
  Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  FPdfAnnot in 'PDFium\FPdfAnnot.pas',
  FPdfAttachment in 'PDFium\FPdfAttachment.pas',
  FPdfCatalog in 'PDFium\FPdfCatalog.pas',
  FPdfDataAvail in 'PDFium\FPdfDataAvail.pas',
  FPdfDoc in 'PDFium\FPdfDoc.pas',
  FPdfEdit in 'PDFium\FPdfEdit.pas',
  FPdfExt in 'PDFium\FPdfExt.pas',
  FPdfFlatten in 'PDFium\FPdfFlatten.pas',
  FPdfFormFill in 'PDFium\FPdfFormFill.pas',
  FPdfFWLEvent in 'PDFium\FPdfFWLEvent.pas',
  FPdfPpo in 'PDFium\FPdfPpo.pas',
  FPdfProgressive in 'PDFium\FPdfProgressive.pas',
  FPdfSave in 'PDFium\FPdfSave.pas',
  FPdfSearchEx in 'PDFium\FPdfSearchEx.pas',
  FPdfStructTree in 'PDFium\FPdfStructTree.pas',
  FPdfSysFontInfo in 'PDFium\FPdfSysFontInfo.pas',
  FPdfText in 'PDFium\FPdfText.pas',
  FPdfThumbnail in 'PDFium\FPdfThumbnail.pas',
  FPdfTransformPage in 'PDFium\FPdfTransformPage.pas',
  FPdfView in 'PDFium\FPdfView.pas',
  PDFium in 'PDFium\PDFium.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
