// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfTransformPage;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

{
 Set "MediaBox" entry to the page dictionary.

 page   - Handle to a page.
 left   - The left of the rectangle.
 bottom - The bottom of the rectangle.
 right  - The right of the rectangle.
 }

type TFPDFPage_SetMediaBox = procedure(page: FPDF_PAGE; left, bottom, right, top: Single); cdecl;

{
 Set "CropBox" entry to the page dictionary.

 page   - Handle to a page.
 left   - The left of the rectangle.
 bottom - The bottom of the rectangle.
 right  - The right of the rectangle.
 top    - The top of the rectangle.
}

type TFPDFPage_SetCropBox = procedure(page: FPDF_PAGE; left, bottom, right, top: Single); cdecl;

{
 Set "BleedBox" entry to the page dictionary.

 page   - Handle to a page.
 left   - The left of the rectangle.
 bottom - The bottom of the rectangle.
 right  - The right of the rectangle.
 top    - The top of the rectangle.
}

type TFPDFPage_SetBleedBox = procedure(page: FPDF_PAGE; left, bottom, right, top: Single); cdecl;

{
 Set "TrimBox" entry to the page dictionary.

 page   - Handle to a page.
 left   - The left of the rectangle.
 bottom - The bottom of the rectangle.
 right  - The right of the rectangle.
 top    - The top of the rectangle.
}

type TFPDFPage_SetTrimBox = procedure(page: FPDF_PAGE; left, bottom, right, top: Single); cdecl;

{
 Set "ArtBox" entry to the page dictionary.

 page   - Handle to a page.
 left   - The left of the rectangle.
 bottom - The bottom of the rectangle.
 right  - The right of the rectangle.
 top    - The top of the rectangle.
}

type TFPDFPage_SetArtBox = procedure(page: FPDF_PAGE; left, bottom, right, top: Single); cdecl;

{
 Get "MediaBox" entry from the page dictionary.

 page   - Handle to a page.
 left   - Pointer to a float value receiving the left of the rectangle.
 bottom - Pointer to a float value receiving the bottom of the rectangle.
 right  - Pointer to a float value receiving the right of the rectangle.
 top    - Pointer to a float value receiving the top of the rectangle.

 On success, return true and write to the out parameters. Otherwise return
 false and leave the out parameters unmodified.
}

type TFPDFPage_GetMediaBox = function(page: FPDF_PAGE; var left, bottom, right, top: Single): FPDF_BOOL; cdecl;

{
 Get "CropBox" entry from the page dictionary.

 page   - Handle to a page.
 left   - Pointer to a float value receiving the left of the rectangle.
 bottom - Pointer to a float value receiving the bottom of the rectangle.
 right  - Pointer to a float value receiving the right of the rectangle.
 top    - Pointer to a float value receiving the top of the rectangle.

 On success, return true and write to the out parameters. Otherwise return
 false and leave the out parameters unmodified.
}

type TFPDFPage_GetCropBox = function(page: FPDF_PAGE; out left, bottom, right, top: Single): FPDF_BOOL; cdecl;

{
 Get "BleedBox" entry from the page dictionary.

 page   - Handle to a page.
 left   - Pointer to a float value receiving the left of the rectangle.
 bottom - Pointer to a float value receiving the bottom of the rectangle.
 right  - Pointer to a float value receiving the right of the rectangle.
 top    - Pointer to a float value receiving the top of the rectangle.

 On success, return true and write to the out parameters. Otherwise return
 false and leave the out parameters unmodified.
}

type TFPDFPage_GetBleedBox = function(page: FPDF_PAGE; out left, bottom, right, top: Single): FPDF_BOOL; cdecl;

{
 Get "TrimBox" entry from the page dictionary.

 page   - Handle to a page.
 left   - Pointer to a float value receiving the left of the rectangle.
 bottom - Pointer to a float value receiving the bottom of the rectangle.
 right  - Pointer to a float value receiving the right of the rectangle.
 top    - Pointer to a float value receiving the top of the rectangle.

 On success, return true and write to the out parameters. Otherwise return
 false and leave the out parameters unmodified.
}

type TFPDFPage_GetTrimBox = function(page: FPDF_PAGE; out left, bottom, right, top: Single): FPDF_BOOL; cdecl;

{
 Get "ArtBox" entry from the page dictionary.

 page   - Handle to a page.
 left   - Pointer to a float value receiving the left of the rectangle.
 bottom - Pointer to a float value receiving the bottom of the rectangle.
 right  - Pointer to a float value receiving the right of the rectangle.
 top    - Pointer to a float value receiving the top of the rectangle.

 On success, return true and write to the out parameters. Otherwise return
 false and leave the out parameters unmodified.
}

type TFPDFPage_GetArtBox = function(page: FPDF_PAGE; out left, bottom, right, top: Single): FPDF_BOOL; cdecl;

{
 Apply transforms to |page|.

 If |matrix| is provided it will be applied to transform the page.
 If |clipRect| is provided it will be used to clip the resulting page.
 If neither |matrix| or |clipRect| are provided this method returns |false|.
 Returns |true| if transforms are applied.

 This function will transform the whole page, and would take effect to all the
 objects in the page.

 page        - Page handle.
 matrix      - Transform matrix.
 clipRect    - Clipping rectangle.
}

type TFPDFPage_TransFormWithClip = function(page: FPDF_PAGE; var matrix: FS_MATRIX; var clipRect: FS_RECTF): FPDF_BOOL; cdecl;

{
 Transform (scale, rotate, shear, move) the clip path of page object.
 page_object - Handle to a page object. Returned by
 FPDFPageObj_NewImageObj().

 a  - The coefficient "a" of the matrix.
 b  - The coefficient "b" of the matrix.
 c  - The coefficient "c" of the matrix.
 d  - The coefficient "d" of the matrix.
 e  - The coefficient "e" of the matrix.
 f  - The coefficient "f" of the matrix.
}

type TFPDFPageObj_TransformClipPath = procedure(page_object: FPDF_PAGEOBJECT; a, b, c, d, e, f: Double); cdecl;

// Experimental API.
// Get the clip path of the page object.
//
//   page object - Handle to a page object. Returned by e.g.
//                 FPDFPage_GetObject().
//
// Caller does not take ownership of the returned FPDF_CLIPPATH. Instead, it
// remains valid until FPDF_ClosePage() is called for the page containing
// page_object.

type TFPDFPageObj_GetClipPath = function(page_object: FPDF_PAGEOBJECT): FPDF_CLIPPATH; cdecl;

// Experimental API.
// Get number of paths inside |clip_path|.
//
//   clip_path - handle to a clip_path.
//
// Returns the number of objects in |clip_path| or -1 on failure.

type TFPDFClipPath_CountPaths = function(clip_path: FPDF_CLIPPATH): Integer; cdecl;

// Experimental API.
// Get number of segments inside one path of |clip_path|.
//
//   clip_path  - handle to a clip_path.
//   path_index - index into the array of paths of the clip path.
//
// Returns the number of segments or -1 on failure.

type TFPDFClipPath_CountPathSegments = function(clip_path: FPDF_CLIPPATH; path_index: Integer): Integer; cdecl;

// Experimental API.
// Get segment in one specific path of |clip_path| at index.
//
//   clip_path     - handle to a clip_path.
//   path_index    - the index of a path.
//   segment_index - the index of a segment.
//
// Returns the handle to the segment, or NULL on failure.  The caller does not
// take ownership of the returned FPDF_CLIPPATH. Instead, it remains valid until
// FPDF_ClosePage() is called for the page containing page_object.

type TFPDFClipPath_GetPathSegment = function(clip_path: FPDF_CLIPPATH; path_index, segment_index: Integer): FPDF_PATHSEGMENT; cdecl;

{
 Create a new clip path, with a rectangle inserted.

 Caller takes ownership of the returned FPDF_CLIPPATH. It should be freed with
 FPDF_DestroyClipPath().

 left   - The left of the clip box.
 bottom - The bottom of the clip box.
 right  - The right of the clip box.
 top    - The top of the clip box.
}

type TFPDF_CreateClipPath = function(left, bottom, right, top: Single): FPDF_CLIPPATH; cdecl;

{
 Destroy the clip path.

 clipPath - A handle to the clip path. It will be invalid after this call.
}

type TFPDF_DestroyClipPath = procedure(clipPath: FPDF_CLIPPATH); cdecl;

{
 Clip the page content, the page content that outside the clipping region
 become invisible.

 A clip path will be inserted before the page content stream or content array.
 In this way, the page content will be clipped by this clip path.

 page        - A page handle.
 clipPath    - A handle to the clip path. (Does not take ownership.)
}

type TFPDFPage_InsertClipPath = procedure(page: FPDF_PAGE; clipPath: FPDF_CLIPPATH); cdecl;

implementation

end.