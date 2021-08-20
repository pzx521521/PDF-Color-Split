// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfProgressive;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Flags for progressive process status.
const
  FPDF_RENDER_READY         = 0;
  FPDF_RENDER_TOBECONTINUED = 1;
  FPDF_RENDER_DONE          = 2;
  FPDF_RENDER_FAILED        = 3;

//IFPDF_RENDERINFO interface.
type
  PIFSDK_PAUSE = ^IFSDK_PAUSE;
  NeedToPauseNow = function(pThis: PIFSDK_PAUSE): FPDF_BOOL; cdecl;

  IFSDK_PAUSE = record
    // Version number of the interface. Currently must be 1.
    version: Integer;

    {
     Method: NeedToPauseNow
               Check if we need to pause a progressive process now.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
     Return Value:
                Non-zero for pause now, 0 for continue.
    }

    NeedToPauseNow: NeedToPauseNow;

    // A user defined data pointer, used by user's application. Can be NULL.
    user: Pointer;
  end;

// Function: FPDF_RenderPageBitmap_Start
//          Start to render page contents to a device independent bitmap
//          progressively.
// Parameters:
//          bitmap      -   Handle to the device independent bitmap (as the
//          output buffer).
//                          Bitmap handle can be created by FPDFBitmap_Create
//                          function.
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          function.
//          start_x     -   Left pixel position of the display area in the
//          bitmap coordinate.
//          start_y     -   Top pixel position of the display area in the bitmap
//          coordinate.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation: 0 (normal), 1 (rotated 90 degrees
//          clockwise),
//                              2 (rotated 180 degrees), 3 (rotated 90 degrees
//                              counter-clockwise).
//          flags       -   0 for normal display, or combination of flags
//                          defined in fpdfview.h. With FPDF_ANNOT flag, it
//                          renders all annotations that does not require
//                          user-interaction, which are all annotations except
//                          widget and popup annotations.
//          pause       -   The IFSDK_PAUSE interface.A callback mechanism
//          allowing the page rendering process
// Return value:
//          Rendering Status. See flags for progressive process status for the
//          details.

type TFPDF_RenderPageBitmap_Start = function(bitmap: FPDF_BITMAP; page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, flags: Integer; var pause: IFSDK_PAUSE): Integer; cdecl;

// Function: FPDF_RenderPage_Continue
//          Continue rendering a PDF page.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          function.
//          pause       -   The IFSDK_PAUSE interface.A callback mechanism
//          allowing the page rendering process
//                          to be paused before it's finished. This can be NULL
//                          if you don't want to pause.
// Return value:
//          The rendering status. See flags for progressive process status for
//          the details.

type TFPDF_RenderPage_Continue = function(page: FPDF_PAGE; var pause: IFSDK_PAUSE): Integer; cdecl;

// Function: FPDF_RenderPage_Close
//          Release the resource allocate during page rendering. Need to be
//          called after finishing rendering or
//          cancel the rendering.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          function.
// Return value:
//          NULL

type TFPDF_RenderPage_Close = procedure(page: FPDF_PAGE); cdecl;

implementation

end.