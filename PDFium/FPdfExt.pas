// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfExt;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// flags for type of unsupport object.
const
  FPDF_UNSP_DOC_XFAFORM               = 1; // Unsupported XFA form.
  FPDF_UNSP_DOC_PORTABLECOLLECTION    = 2; // Unsupported portable collection.
  FPDF_UNSP_DOC_ATTACHMENT            = 3; // Unsupported attachment.
  FPDF_UNSP_DOC_SECURITY              = 4; // Unsupported security.
  FPDF_UNSP_DOC_SHAREDREVIEW          = 5; // Unsupported shared review.
  FPDF_UNSP_DOC_SHAREDFORM_ACROBAT    = 6; // Unsupported shared form, acrobat.
  FPDF_UNSP_DOC_SHAREDFORM_FILESYSTEM = 7; // Unsupported shared form, filesystem.
  FPDF_UNSP_DOC_SHAREDFORM_EMAIL      = 8; // Unsupported shared form, email.
  FPDF_UNSP_ANNOT_3DANNOT             = 11; // Unsupported 3D annotation.
  FPDF_UNSP_ANNOT_MOVIE               = 12; // Unsupported movie annotation.
  FPDF_UNSP_ANNOT_SOUND               = 13; // Unsupported sound annotation.
  FPDF_UNSP_ANNOT_SCREEN_MEDIA        = 14; // Unsupported screen media annotation.
  FPDF_UNSP_ANNOT_SCREEN_RICHMEDIA    = 15; // Unsupported screen rich media annotation.
  FPDF_UNSP_ANNOT_ATTACHMENT          = 16; // Unsupported attachment annotation.
  FPDF_UNSP_ANNOT_SIG                 = 17; // Unsupported signature annotation.

type
  PUNSUPPORT_INFO = ^UNSUPPORT_INFO;
  FSDK_UnSupport_Handler = procedure(pThis: PUNSUPPORT_INFO; nType: Integer); cdecl;

  // Interface for unsupported feature notifications.
  UNSUPPORT_INFO = record
    // Version number of the interface. Must be 1.
    version: Integer;

    // Unsupported object notification function.
    // Interface Version: 1
    // Implementation Required: Yes
    //
    //   pThis - pointer to the interface structure.
    //   nType - the type of unsupported object. One of the |FPDF_UNSP_*| entries.
    FSDK_UnSupport_Handler: FSDK_UnSupport_Handler;
  end;

// Setup an unsupported object handler.
//
//   unsp_info - Pointer to an UNSUPPORT_INFO structure.
//
// Returns TRUE on success.

type TFSDK_SetUnSpObjProcessHandler = function(var unsp_info: UNSUPPORT_INFO): FPDF_BOOL; cdecl;

// Set replacement function for calls to time().
//
// This API is intended to be used only for testing, thus may cause PDFium to
// behave poorly in production environments.
//
//   func - Function pointer to alternate implementation of time(), or
//          NULL to restore to actual time() call itself.

type TFSDK_SetTimeFunction = procedure({ time_t (*func)()} func: Pointer); cdecl;

// Set replacement function for calls to localtime().
//
// This API is intended to be used only for testing, thus may cause PDFium to
// behave poorly in production environments.
//
//   func - Function pointer to alternate implementation of localtime(), or
//          NULL to restore to actual localtime() call itself.

type TFSDK_SetLocaltimeFunction = procedure({struct tm* (*func)(const time_t*)} func: Pointer); cdecl;

const
  PAGEMODE_UNKNOWN        = -1; // Unknown page mode.
  PAGEMODE_USENONE        = 0; // Document outline, and thumbnails hidden.
  PAGEMODE_USEOUTLINES    = 1; // Document outline visible.
  PAGEMODE_USETHUMBS      = 2; // Thumbnail images visible.
  PAGEMODE_FULLSCREEN     = 3; // Full-screen mode, no menu bar, window controls, or other decorations visible.
  PAGEMODE_USEOC          = 4; // Optional content group panel visible.
  PAGEMODE_USEATTACHMENTS = 5; // Attachments panel visible.

// Get the document's PageMode.
//
//   doc - Handle to document.
//
// Returns one of the |PAGEMODE_*| flags defined above.
//
// The page mode defines how the document should be initially displayed.

type TFPDFDoc_GetPageMode = function(document: FPDF_DOCUMENT): Integer; cdecl;

implementation

end.