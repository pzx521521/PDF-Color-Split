// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfSave;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Structure for custom file write
type
  PFPDF_FILEWRITE = ^FPDF_FILEWRITE;
  WriteBlock = function(pThis: PFPDF_FILEWRITE; pData: Pointer; size: LongWord): Integer; cdecl;

  FPDF_FILEWRITE = record
    // Version number of the interface. Currently must be 1.
    version: Integer;

    // Method: WriteBlock
    //          Output a block of data in your custom way.
    // Interface Version:
    //          1
    // Implementation Required:
    //          Yes
    // Comments:
    //          Called by function FPDF_SaveDocument
    // Parameters:
    //          pThis       -   Pointer to the structure itself
    //          pData       -   Pointer to a buffer to output
    //          size        -   The size of the buffer.
    // Return value:
    //          Should be non-zero if successful, zero for error.
    //
    WriteBlock: WriteBlock;
  end;

const
  FPDF_INCREMENTAL = 1;
  FPDF_NO_INCREMENTAL = 2;
  FPDF_REMOVE_SECURITY = 3;

// Function: FPDF_SaveAsCopy
//          Saves the copy of specified document in custom way.
// Parameters:
//          document        -   Handle to document. Returned by
//          FPDF_LoadDocument and FPDF_CreateNewDocument.
//          pFileWrite      -   A pointer to a custom file write structure.
//          flags           -   The creating flags.
// Return value:
//          TRUE for succeed, FALSE for failed.
//

type TFPDF_SaveAsCopy = function(document: FPDF_DOCUMENT; var pFileWrite: FPDF_FILEWRITE; flags: FPDF_DWORD): FPDF_BOOL; cdecl;

// Function: FPDF_SaveWithVersion
//          Same as function ::FPDF_SaveAsCopy, except the file version of the
//          saved document could be specified by user.
// Parameters:
//          document        -   Handle to document.
//          pFileWrite      -   A pointer to a custom file write structure.
//          flags           -   The creating flags.
//          fileVersion     -   The PDF file version. File version: 14 for 1.4,
//          15 for 1.5, ...
// Return value:
//          TRUE if succeed, FALSE if failed.
//

type TFPDF_SaveWithVersion = function(document: FPDF_DOCUMENT; var pFileWrite: FPDF_FILEWRITE; flags: FPDF_DWORD; fileVersion: Integer): FPDF_BOOL; cdecl;

implementation

end.