// Copyright 2019 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

unit FPdfThumbnail;

interface

uses FPdfView;

// Experimental API.
// Gets the decoded data from the thumbnail of |page| if it exists.
// This only modifies |buffer| if |buflen| less than or equal to the
// size of the decoded data. Returns the size of the decoded
// data or 0 if thumbnail DNE. Optional, pass null to just retrieve
// the size of the buffer needed.
//
//   page    - handle to a page.
//   buffer  - buffer for holding the decoded image data.
//   buflen  - length of the buffer in bytes.

type TFPDFPage_GetDecodedThumbnailData = function(page: FPDF_PAGE; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Gets the raw data from the thumbnail of |page| if it exists.
// This only modifies |buffer| if |buflen| is less than or equal to
// the size of the raw data. Returns the size of the raw data or 0
// if thumbnail DNE. Optional, pass null to just retrieve the size
// of the buffer needed.
//
//   page    - handle to a page.
//   buffer  - buffer for holding the raw image data.
//   buflen  - length of the buffer in bytes.

type TFPDFPage_GetRawThumbnailData = function(page: FPDF_PAGE; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Returns the thumbnail of |page| as a FPDF_BITMAP. Returns a nullptr
// if unable to access the thumbnail's stream.
//
//   page - handle to a page.

type TFPDFPage_GetThumbnailAsBitmap = function(page: FPDF_PAGE): FPDF_BITMAP; cdecl;

implementation

end.