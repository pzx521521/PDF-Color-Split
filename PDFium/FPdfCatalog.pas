// Copyright 2017 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

unit FPdfCatalog;

interface

uses FPdfView;

{
  Experimental API.

  Determine if |document| represents a tagged PDF.

  For the definition of tagged PDF, See (see 10.7 "Tagged PDF" in PDF
  Reference 1.7).

    document - handle to a document.

  Returns |true| iff |document| is a tagged PDF.
}

type TFPDFCatalog_IsTagged = function(document: FPDF_DOCUMENT): FPDF_BOOL; cdecl;

implementation

end.