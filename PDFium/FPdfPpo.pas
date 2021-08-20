// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
 
// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfPpo;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Function: FPDF_ImportPages
//          Import some pages to a PDF document.
// Parameters:
//          dest_doc    -   The destination document which add the pages.
//          src_doc     -   A document to be imported.
//          pagerange   -   A page range string, Such as "1,3,5-7".
//                          If this parameter is NULL, it would import all pages
//                          in src_doc.
//          index       -   The page index wanted to insert from.
// Return value:
//          TRUE for succeed, FALSE for Failed.

type TFPDF_ImportPages = function(dest_doc, src_doc: FPDF_DOCUMENT; pagerange: FPDF_BYTESTRING; index: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Create a new document from |src_doc|.  The pages of |src_doc| will be
// combined to provide |num_pages_on_x_axis x num_pages_on_y_axis| pages per
// |output_doc| page.
//
//   src_doc             - The document to be imported.
//   output_width        - The output page width in PDF "user space" units.
//   output_height       - The output page height in PDF "user space" units.
//   num_pages_on_x_axis - The number of pages on X Axis.
//   num_pages_on_y_axis - The number of pages on Y Axis.
//
// Return value:
//   A handle to the created document, or NULL on failure.
//
// Comments:
//   number of pages per page = num_pages_on_x_axis * num_pages_on_y_axis
//

type TFPDF_ImportNPagesToOne = function(src_doc: FPDF_DOCUMENT; output_width, output_height: Single; num_pages_on_x_axis, num_pages_on_y_axis: size_t): FPDF_DOCUMENT; cdecl;

// Function: FPDF_CopyViewerPreferences
//          Copy the viewer preferences from one PDF document to another.#endif
// Parameters:
//          dest_doc    -   Handle to document to write the viewer preferences
//          to.
//          src_doc     -   Handle to document with the viewer preferences.
// Return value:
//          TRUE for success, FALSE for failure.

type TFPDF_CopyViewerPreferences = function(dest_doc, src_doc: FPDF_DOCUMENT): FPDF_BOOL; cdecl;

implementation

end.