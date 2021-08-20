// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfFlatten;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

const
  // Result codes.
  FLATTEN_FAIL        = 0; // Flatten operation failed.
  FLATTEN_SUCCESS     = 1; // Flatten operation succeed.
  FLATTEN_NOTHINGTODO = 2; // There is nothing to be flattened.

  // Flags.
  FLAT_NORMALDISPLAY = 0;
  FLAT_PRINT         = 1;

// Function: FPDFPage_Flatten
//          Make annotations and form fields become part of the page contents itself.
// Parameters:
//          page  - Handle to the page, as returned by FPDF_LoadPage().
//          nFlag - Intended use of the flattened result: 0 for normal display, 1 for printing.
// Return value:
//          Either FLATTEN_FAIL, FLATTEN_SUCCESS, or FLATTEN_NOTHINGTODO (see above).
// Comments:
//          Currently, all failures return FLATTEN_FAIL, with no indication for the reason
//          for the failure.

type TFPDFPage_Flatten = function(page: FPDF_PAGE; nFlag: Integer): Integer; cdecl;

implementation

end.