// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfEdit;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

function FPDF_ARGB(a, r, g, b: Byte): LongWord;
function FPDF_GetBValue(argb: LongWord): Byte;
function FPDF_GetGValue(argb: LongWord): Byte;
function FPDF_GetRValue(argb: LongWord): Byte;
function FPDF_GetAValue(argb: LongWord): Byte;

// Refer to PDF Reference version 1.7 table 4.12 for all color space families.
const
  FPDF_COLORSPACE_UNKNOWN = 0;
  FPDF_COLORSPACE_DEVICEGRAY = 1;
  FPDF_COLORSPACE_DEVICERGB = 2;
  FPDF_COLORSPACE_DEVICECMYK = 3;
  FPDF_COLORSPACE_CALGRAY = 4;
  FPDF_COLORSPACE_CALRGB = 5;
  FPDF_COLORSPACE_LAB = 6;
  FPDF_COLORSPACE_ICCBASED = 7;
  FPDF_COLORSPACE_SEPARATION = 8;
  FPDF_COLORSPACE_DEVICEN = 9;
  FPDF_COLORSPACE_INDEXED = 10;
  FPDF_COLORSPACE_PATTERN = 11;

// The page object constants.
const
  FPDF_PAGEOBJ_UNKNOWN = 0;
  FPDF_PAGEOBJ_TEXT    = 1;
  FPDF_PAGEOBJ_PATH    = 2;
  FPDF_PAGEOBJ_IMAGE   = 3;
  FPDF_PAGEOBJ_SHADING = 4;
  FPDF_PAGEOBJ_FORM    = 5;

// The path segment constants.
const
  FPDF_SEGMENT_UNKNOWN = -1;
  FPDF_SEGMENT_LINETO = 0;
  FPDF_SEGMENT_BEZIERTO = 1;
  FPDF_SEGMENT_MOVETO = 2;

  FPDF_FILLMODE_NONE = 0;
  FPDF_FILLMODE_ALTERNATE = 1;
  FPDF_FILLMODE_WINDING   = 2;

  FPDF_FONT_TYPE1    = 1;
  FPDF_FONT_TRUETYPE = 2;

  FPDF_LINECAP_BUTT = 0;
  FPDF_LINECAP_ROUND = 1;
  FPDF_LINECAP_PROJECTING_SQUARE = 2;

  FPDF_LINEJOIN_MITER = 0;
  FPDF_LINEJOIN_ROUND = 1;
  FPDF_LINEJOIN_BEVEL = 2;

  FPDF_PRINTMODE_EMF = 0;
  FPDF_PRINTMODE_TEXTONLY = 1;
  FPDF_PRINTMODE_POSTSCRIPT2 = 2;
  FPDF_PRINTMODE_POSTSCRIPT3 = 3;
  FPDF_PRINTMODE_POSTSCRIPT2_PASSTHROUGH = 4;
  FPDF_PRINTMODE_POSTSCRIPT3_PASSTHROUGH = 5;

  FPDF_TEXTRENDERMODE_FILL = 0;
  FPDF_TEXTRENDERMODE_STROKE = 1;
  FPDF_TEXTRENDERMODE_FILL_STROKE = 2;
  FPDF_TEXTRENDERMODE_INVISIBLE = 3;
  FPDF_TEXTRENDERMODE_FILL_CLIP = 4;
  FPDF_TEXTRENDERMODE_STROKE_CLIP = 5;
  FPDF_TEXTRENDERMODE_FILL_STROKE_CLIP = 6;
  FPDF_TEXTRENDERMODE_CLIP = 7;

type
  FPDF_IMAGEOBJ_METADATA = record
    // The image width in pixels.
    width: LongWord;
    // The image height in pixels.
    height: LongWord;
    // The image's horizontal pixel-per-inch.
    horizontal_dpi: Single;
    // The image's vertical pixel-per-inch.
    vertical_dpi: Single;
    // The number of bits used to represent each pixel.
    bits_per_pixel: LongWord;
    // The image's colorspace. See above for the list of FPDF_COLORSPACE_*.
    colorspace: Integer;
    // The image's marked content ID. Useful for pairing with associated alt-text.
    // A value of -1 indicates no ID.
    marked_content_id: Integer;
  end;

// Create a new PDF document.
//
// Returns a handle to a new document, or NULL on failure.

type TFPDF_CreateNewDocument = function: FPDF_DOCUMENT; cdecl;

// Create a new PDF page.
//
//   document   - handle to document.
//   page_index - suggested 0-based index of the page to create. If it is larger
//                than document's current last index(L), the created page index
//                is the next available index -- L+1.
//   width      - the page width in points.
//   height     - the page height in points.
//
// Returns the handle to the new page or NULL on failure.
//
// The page should be closed with FPDF_ClosePage() when finished as
// with any other page in the document.

type TFPDFPage_New = function(document: FPDF_DOCUMENT; page_index: Integer; width, height: Double): FPDF_PAGE; cdecl;

// Delete the page at |page_index|.
//
//   document   - handle to document.
//   page_index - the index of the page to delete.

type TFPDFPage_Delete = procedure(document: FPDF_DOCUMENT; page_index: Integer); cdecl;

// Get the rotation of |page|.
//
//   page - handle to a page
//
// Returns one of the following indicating the page rotation:
//   0 - No rotation.
//   1 - Rotated 90 degrees clockwise.
//   2 - Rotated 180 degrees clockwise.
//   3 - Rotated 270 degrees clockwise.

type TFPDFPage_GetRotation = function(page: FPDF_PAGE): Integer; cdecl;

// Set rotation for |page|.
//
//   page   - handle to a page.
//   rotate - the rotation value, one of:
//              0 - No rotation.
//              1 - Rotated 90 degrees clockwise.
//              2 - Rotated 180 degrees clockwise.
//              3 - Rotated 270 degrees clockwise.

type TFPDFPage_SetRotation = procedure(page: FPDF_PAGE; rotate: Integer); cdecl;

// Insert |page_obj| into |page|.
//
//   page     - handle to a page
//   page_obj - handle to a page object. The |page_obj| will be automatically
//              freed.

type TFPDFPage_InsertObject = procedure(page: FPDF_PAGE; page_obj: FPDF_PAGEOBJECT); cdecl;

// Experimental API.
// Remove |page_obj| from |page|.
//
//   page     - handle to a page
//   page_obj - handle to a page object to be removed.
//
// Returns TRUE on success.
//
// Ownership is transferred to the caller. Call FPDFPageObj_Destroy() to free
// it.

type TFPDFPage_RemoveObject = function(page: FPDF_PAGE; page_obj: FPDF_PAGEOBJECT): FPDF_BOOL; cdecl;

// Get number of page objects inside |page|.
//
//   page - handle to a page.
//
// Returns the number of objects in |page|.

type TFPDFPage_CountObjects = function(page: FPDF_PAGE): Integer; cdecl;

// Get object in |page| at |index|.
//
//   page  - handle to a page.
//   index - the index of a page object.
//
// Returns the handle to the page object, or NULL on failed.

type TFPDFPage_GetObject = function(page: FPDF_PAGE; index: Integer): FPDF_PAGEOBJECT; cdecl;

// Checks if |page| contains transparency.
//
//   page - handle to a page.
//
// Returns TRUE if |page| contains transparency.

type TFPDFPage_HasTransparency = function(page: FPDF_PAGE): FPDF_BOOL; cdecl;

// Generate the content of |page|.
//
//   page - handle to a page.
//
// Returns TRUE on success.
//
// Before you save the page to a file, or reload the page, you must call
// |FPDFPage_GenerateContent| or any changes to |page| will be lost.

type TFPDFPage_GenerateContent = function(page: FPDF_PAGE): FPDF_BOOL; cdecl;

// Destroy |page_obj| by releasing its resources. |page_obj| must have been
// created by FPDFPageObj_CreateNew{Path|Rect}() or
// FPDFPageObj_New{Text|Image}Obj(). This function must be called on
// newly-created objects if they are not added to a page through
// FPDFPage_InsertObject() or to an annotation through FPDFAnnot_AppendObject().
//
//   page_obj - handle to a page object.

type TFPDFPageObj_Destroy = procedure(page_obj: FPDF_PAGEOBJECT); cdecl;

// Checks if |page_object| contains transparency.
//
//   page_object - handle to a page object.
//
// Returns TRUE if |page_object| contains transparency.

type TFPDFPageObj_HasTransparency = function(page_object: FPDF_PAGEOBJECT): FPDF_BOOL; cdecl;

// Get type of |page_object|.
//
//   page_object - handle to a page object.
//
// Returns one of the FPDF_PAGEOBJ_* values on success, FPDF_PAGEOBJ_UNKNOWN on
// error.

type TFPDFPageObj_GetType = function(page_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Transform |page_object| by the given matrix.
//
//   page_object - handle to a page object.
//   a           - matrix value.
//   b           - matrix value.
//   c           - matrix value.
//   d           - matrix value.
//   e           - matrix value.
//   f           - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and can be used to scale, rotate, shear and translate the |page_object|.

type TFPDFPageObj_Transform = procedure(page_object: FPDF_PAGEOBJECT; a, b, c, d, e, f: Double); cdecl;

// Transform all annotations in |page|.
//
//   page - handle to a page.
//   a    - matrix value.
//   b    - matrix value.
//   c    - matrix value.
//   d    - matrix value.
//   e    - matrix value.
//   f    - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and can be used to scale, rotate, shear and translate the |page| annotations.

type TFPDFPage_TransformAnnots = procedure(page: FPDF_PAGE; a, b, c, d, e, f: Double); cdecl;

// Create a new image object.
//
//   document - handle to a document.
//
// Returns a handle to a new image object.

type TFPDFPageObj_NewImageObj = function(document: FPDF_DOCUMENT): FPDF_PAGEOBJECT; cdecl;

// Experimental API.
// Get number of content marks in |page_object|.
//
//   page_object - handle to a page object.
//
// Returns the number of content marks in |page_object|, or -1 in case of
// failure.

type TFPDFPageObj_CountMarks = function(page_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Experimental API.
// Get content mark in |page_object| at |index|.
//
//   page_object - handle to a page object.
//   index       - the index of a page object.
//
// Returns the handle to the content mark, or NULL on failure. The handle is
// still owned by the library, and it should not be freed directly. It becomes
// invalid if the page object is destroyed, either directly or indirectly by
// unloading the page.

type TFPDFPageObj_GetMark = function(page_object: FPDF_PAGEOBJECT; index: LongWord): FPDF_PAGEOBJECTMARK; cdecl;

// Experimental API.
// Add a new content mark to a |page_object|.
//
//   page_object - handle to a page object.
//   name        - the name (tag) of the mark.
//
// Returns the handle to the content mark, or NULL on failure. The handle is
// still owned by the library, and it should not be freed directly. It becomes
// invalid if the page object is destroyed, either directly or indirectly by
// unloading the page.

type TFPDFPageObj_AddMark = function(page_object: FPDF_PAGEOBJECT; name: FPDF_BYTESTRING): FPDF_PAGEOBJECTMARK; cdecl;

// Experimental API.
// Removes a content |mark| from a |page_object|.
// The mark handle will be invalid after the removal.
//
//   page_object - handle to a page object.
//   mark        - handle to a content mark in that object to remove.
//
// Returns TRUE if the operation succeeded, FALSE if it failed.

type TFPDFPageObj_RemoveMark = function(page_object: FPDF_PAGEOBJECT; mark: FPDF_PAGEOBJECTMARK): FPDF_BOOL; cdecl;

// Experimental API.
// Get the name of a content mark.
//
//   mark       - handle to a content mark.
//   buffer     - buffer for holding the returned name in UTF-16LE. This is only
//                modified if |buflen| is longer than the length of the name.
//                Optional, pass null to just retrieve the size of the buffer
//                needed.
//   buflen     - length of the buffer.
//   out_buflen - pointer to variable that will receive the minimum buffer size
//                to contain the name. Not filled if FALSE is returned.
//
// Returns TRUE if the operation succeeded, FALSE if it failed.

type TFPDFPageObjMark_GetName = function(mark: FPDF_PAGEOBJECTMARK; buffer: Pointer; buflen: LongWord; out out_buflen: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get the number of key/value pair parameters in |mark|.
//
//   mark   - handle to a content mark.
//
// Returns the number of key/value pair parameters |mark|, or -1 in case of
// failure.

type TFPDFPageObjMark_CountParams = function(mark: FPDF_PAGEOBJECTMARK): Integer; cdecl;

// Experimental API.
// Get the key of a property in a content mark.
//
//   mark       - handle to a content mark.
//   index      - index of the property.
//   buffer     - buffer for holding the returned key in UTF-16LE. This is only
//                modified if |buflen| is longer than the length of the key.
//                Optional, pass null to just retrieve the size of the buffer
//                needed.
//   buflen     - length of the buffer.
//   out_buflen - pointer to variable that will receive the minimum buffer size
//                to contain the key. Not filled if FALSE is returned.
//
// Returns TRUE if the operation was successful, FALSE otherwise.

type TFPDFPageObjMark_GetParamKey = function(mark: FPDF_PAGEOBJECTMARK; index: LongWord; buffer: Pointer; buflen: LongWord; out out_buflen: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get the type of the value of a property in a content mark by key.
//
//   mark   - handle to a content mark.
//   key    - string key of the property.
//
// Returns the type of the value, or FPDF_OBJECT_UNKNOWN in case of failure.

type TFPDFPageObjMark_GetParamValueType = function(mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING): FPDF_OBJECT_TYPE; cdecl;

// Experimental API.
// Get the value of a number property in a content mark by key as int.
// FPDFPageObjMark_GetParamValueType() should have returned FPDF_OBJECT_NUMBER
// for this property.
//
//   mark      - handle to a content mark.
//   key       - string key of the property.
//   out_value - pointer to variable that will receive the value. Not filled if
//               false is returned.
//
// Returns TRUE if the key maps to a number value, FALSE otherwise.

type TFPDFPageObjMark_GetParamIntValue = function(mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; out out_value: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Get the value of a string property in a content mark by key.
//
//   mark       - handle to a content mark.
//   key        - string key of the property.
//   buffer     - buffer for holding the returned value in UTF-16LE. This is
//                only modified if |buflen| is longer than the length of the
//                value.
//                Optional, pass null to just retrieve the size of the buffer
//                needed.
//   buflen     - length of the buffer.
//   out_buflen - pointer to variable that will receive the minimum buffer size
//                to contain the value. Not filled if FALSE is returned.
//
// Returns TRUE if the key maps to a string/blob value, FALSE otherwise.

type TFPDFPageObjMark_GetParamStringValue = function(mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; buffer: Pointer; buflen: LongWord; out out_buflen: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get the value of a blob property in a content mark by key.
//
//   mark       - handle to a content mark.
//   key        - string key of the property.
//   buffer     - buffer for holding the returned value. This is only modified
//                if |buflen| is at least as long as the length of the value.
//                Optional, pass null to just retrieve the size of the buffer
//                needed.
//   buflen     - length of the buffer.
//   out_buflen - pointer to variable that will receive the minimum buffer size
//                to contain the value. Not filled if FALSE is returned.
//
// Returns TRUE if the key maps to a string/blob value, FALSE otherwise.

type TFPDFPageObjMark_GetParamBlobValue = function(mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; buffer: Pointer; buflen: LongWord; out out_buflen: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Set the value of an int property in a content mark by key. If a parameter
// with key |key| exists, its value is set to |value|. Otherwise, it is added as
// a new parameter.
//
//   document    - handle to the document.
//   page_object - handle to the page object with the mark.
//   mark        - handle to a content mark.
//   key         - string key of the property.
//   value       - int value to set.
//
// Returns TRUE if the operation succeeded, FALSE otherwise.

type TFPDFPageObjMark_SetIntParam = function(document: FPDF_DOCUMENT; page_object: FPDF_PAGEOBJECT; mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; value: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Set the value of a string property in a content mark by key. If a parameter
// with key |key| exists, its value is set to |value|. Otherwise, it is added as
// a new parameter.
//
//   document    - handle to the document.
//   page_object - handle to the page object with the mark.
//   mark        - handle to a content mark.
//   key         - string key of the property.
//   value       - string value to set.
//
// Returns TRUE if the operation succeeded, FALSE otherwise.

type TFPDFPageObjMark_SetStringParam = function(document: FPDF_DOCUMENT; page_object: FPDF_PAGEOBJECT; mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; value: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Set the value of a blob property in a content mark by key. If a parameter
// with key |key| exists, its value is set to |value|. Otherwise, it is added as
// a new parameter.
//
//   document    - handle to the document.
//   page_object - handle to the page object with the mark.
//   mark        - handle to a content mark.
//   key         - string key of the property.
//   value       - pointer to blob value to set.
//   value_len   - size in bytes of |value|.
//
// Returns TRUE if the operation succeeded, FALSE otherwise.

type TFPDFPageObjMark_SetBlobParam = function(document: FPDF_DOCUMENT; page_object: FPDF_PAGEOBJECT; mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING; value: Pointer; value_len: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Removes a property from a content mark by key.
//
//   page_object - handle to the page object with the mark.
//   mark        - handle to a content mark.
//   key         - string key of the property.
//
// Returns TRUE if the operation succeeded, FALSE otherwise.

type TFPDFPageObjMark_RemoveParam = function(page_object: FPDF_PAGEOBJECT; mark: FPDF_PAGEOBJECTMARK; key: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Load an image from a JPEG image file and then set it into |image_object|.
//
//   pages        - pointer to the start of all loaded pages, may be NULL.
//   count        - number of |pages|, may be 0.
//   image_object - handle to an image object.
//   file_access  - file access handler which specifies the JPEG image file.
//
// Returns TRUE on success.
//
// The image object might already have an associated image, which is shared and
// cached by the loaded pages. In that case, we need to clear the cached image
// for all the loaded pages. Pass |pages| and page count (|count|) to this API
// to clear the image cache. If the image is not previously shared, or NULL is a
// valid |pages| value.

type
  PFPDF_PAGE = ^FPDF_PAGE;

type TFPDFImageObj_LoadJpegFile = function(pages: PFPDF_PAGE; count: Integer; image_object: FPDF_PAGEOBJECT; var file_access: FPDF_FILEACCESS): FPDF_BOOL; cdecl;

// Load an image from a JPEG image file and then set it into |image_object|.
//
//   pages        - pointer to the start of all loaded pages, may be NULL.
//   count        - number of |pages|, may be 0.
//   image_object - handle to an image object.
//   file_access  - file access handler which specifies the JPEG image file.
//
// Returns TRUE on success.
//
// The image object might already have an associated image, which is shared and
// cached by the loaded pages. In that case, we need to clear the cached image
// for all the loaded pages. Pass |pages| and page count (|count|) to this API
// to clear the image cache. If the image is not previously shared, or NULL is a
// valid |pages| value. This function loads the JPEG image inline, so the image
// content is copied to the file. This allows |file_access| and its associated
// data to be deleted after this function returns.

type TFPDFImageObj_LoadJpegFileInline = function(pages: PFPDF_PAGE; count: Integer; image_object: FPDF_PAGEOBJECT; var file_access: FPDF_FILEACCESS): FPDF_BOOL; cdecl;

// Experimental API.
// Get the transform matrix of an image object.
//
//   image_object - handle to an image object.
//   a            - matrix value.
//   b            - matrix value.
//   c            - matrix value.
//   d            - matrix value.
//   e            - matrix value.
//   f            - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and used to scale, rotate, shear and translate the image.
//
// Returns TRUE on success.

type TFPDFImageObj_GetMatrix = function(image_object: FPDF_PAGEOBJECT; out a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;

// Set the transform matrix of |image_object|.
//
//   image_object - handle to an image object.
//   a            - matrix value.
//   b            - matrix value.
//   c            - matrix value.
//   d            - matrix value.
//   e            - matrix value.
//   f            - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and can be used to scale, rotate, shear and translate the |image_object|.
//
// Returns TRUE on success.

type TFPDFImageObj_SetMatrix = function(image_object: FPDF_PAGEOBJECT; a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;

// Set |bitmap| to |image_object|.
//
//   pages        - pointer to the start of all loaded pages, may be NULL.
//   count        - number of |pages|, may be 0.
//   image_object - handle to an image object.
//   bitmap       - handle of the bitmap.
//
// Returns TRUE on success.

type TFPDFImageObj_SetBitmap = function(pages: PFPDF_PAGE; count: Integer; image_object: FPDF_PAGEOBJECT; bitmap: FPDF_BITMAP): FPDF_BOOL; cdecl;

// Get a bitmap rasterisation of |image_object|. The returned bitmap will be
// owned by the caller, and FPDFBitmap_Destroy() must be called on the returned
// bitmap when it is no longer needed.
//
//   image_object - handle to an image object.
//
// Returns the bitmap.

type TFPDFImageObj_GetBitmap = function(image_object: FPDF_PAGEOBJECT): FPDF_BITMAP; cdecl;

// Get the decoded image data of |image_object|. The decoded data is the
// uncompressed image data, i.e. the raw image data after having all filters
// applied. |buffer| is only modified if |buflen| is longer than the length of
// the decoded image data.
//
//   image_object - handle to an image object.
//   buffer       - buffer for holding the decoded image data.
//   buflen       - length of the buffer in bytes.
//
// Returns the length of the decoded image data.

type TFPDFImageObj_GetImageDataDecoded = function(image_object: FPDF_PAGEOBJECT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Get the raw image data of |image_object|. The raw data is the image data as
// stored in the PDF without applying any filters. |buffer| is only modified if
// |buflen| is longer than the length of the raw image data.
//
//   image_object - handle to an image object.
//   buffer       - buffer for holding the raw image data.
//   buflen       - length of the buffer in bytes.
//
// Returns the length of the raw image data.

type TFPDFImageObj_GetImageDataRaw = function(image_object: FPDF_PAGEOBJECT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Get the number of filters (i.e. decoders) of the image in |image_object|.
//
//   image_object - handle to an image object.
//
// Returns the number of |image_object|'s filters.

type TFPDFImageObj_GetImageFilterCount = function(image_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Get the filter at |index| of |image_object|'s list of filters. Note that the
// filters need to be applied in order, i.e. the first filter should be applied
// first, then the second, etc. |buffer| is only modified if |buflen| is longer
// than the length of the filter string.
//
//   image_object - handle to an image object.
//   index        - the index of the filter requested.
//   buffer       - buffer for holding filter string, encoded in UTF-8.
//   buflen       - length of the buffer.
//
// Returns the length of the filter string.

type TFPDFImageObj_GetImageFilter = function(image_object: FPDF_PAGEOBJECT; index: Integer; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Get the image metadata of |image_object|, including dimension, DPI, bits per
// pixel, and colorspace. If the |image_object| is not an image object or if it
// does not have an image, then the return value will be false. Otherwise,
// failure to retrieve any specific parameter would result in its value being 0.
//
//   image_object - handle to an image object.
//   page         - handle to the page that |image_object| is on. Required for
//                  retrieving the image's bits per pixel and colorspace.
//   metadata     - receives the image metadata; must not be NULL.
//
// Returns true if successful.

type TFPDFImageObj_GetImageMetadata = function(image_object: FPDF_PAGEOBJECT; page: FPDF_PAGE; var metadata: FPDF_IMAGEOBJ_METADATA): FPDF_BOOL; cdecl;

// Create a new path object at an initial position.
//
//   x - initial horizontal position.
//   y - initial vertical position.
//
// Returns a handle to a new path object.

type TFPDFPageObj_CreateNewPath = function(x, y: Single): FPDF_PAGEOBJECT; cdecl;

// Create a closed path consisting of a rectangle.
//
//   x - horizontal position for the left boundary of the rectangle.
//   y - vertical position for the bottom boundary of the rectangle.
//   w - width of the rectangle.
//   h - height of the rectangle.
//
// Returns a handle to the new path object.

type TFPDFPageObj_CreateNewRect = function(x, y, w, h: Single): FPDF_PAGEOBJECT; cdecl;

// Get the bounding box of |page_object|.
//
// page_object  - handle to a page object.
// left         - pointer where the left coordinate will be stored
// bottom       - pointer where the bottom coordinate will be stored
// right        - pointer where the right coordinate will be stored
// top          - pointer where the top coordinate will be stored
//
// Returns TRUE on success.

type TFPDFPageObj_GetBounds = function(page_object: FPDF_PAGEOBJECT; var left, bottom, right, top: Single): FPDF_BOOL; cdecl;

// Set the blend mode of |page_object|.
//
// page_object  - handle to a page object.
// blend_mode   - string containing the blend mode.
//
// Blend mode can be one of following: Color, ColorBurn, ColorDodge, Darken,
// Difference, Exclusion, HardLight, Hue, Lighten, Luminosity, Multiply, Normal,
// Overlay, Saturation, Screen, SoftLight

type TFPDFPageObj_SetBlendMode = procedure(page_object: FPDF_PAGEOBJECT; blend_mode: FPDF_BYTESTRING); cdecl;

// Set the stroke RGBA of a page object. Range of values: 0 - 255.
//
// page_object  - the handle to the page object.
// R            - the red component for the object's stroke color.
// G            - the green component for the object's stroke color.
// B            - the blue component for the object's stroke color.
// A            - the stroke alpha for the object.
//
// Returns TRUE on success.

type TFPDFPageObj_SetStrokeColor = function(page_object: FPDF_PAGEOBJECT; R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Get the stroke RGBA of a page object. Range of values: 0 - 255.
//
// page_object  - the handle to the page object.
// R            - the red component of the path stroke color.
// G            - the green component of the object's stroke color.
// B            - the blue component of the object's stroke color.
// A            - the stroke alpha of the object.
//
// Returns TRUE on success.

type TFPDFPageObj_GetStrokeColor = function(page_object: FPDF_PAGEOBJECT; var R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Set the stroke width of a page object.
//
// path   - the handle to the page object.
// width  - the width of the stroke.
//
// Returns TRUE on success

type TFPDFPageObj_SetStrokeWidth = function(page_object: FPDF_PAGEOBJECT; width: Single): FPDF_BOOL; cdecl;

// Experimental API.
// Get the stroke width of a page object.
//
// path   - the handle to the page object.
// width  - the width of the stroke.
//
// Returns TRUE on success

type TFPDFPageObj_GetStrokeWidth = function(page_object: FPDF_PAGEOBJECT; var width: Single): FPDF_BOOL; cdecl;

// Get the line join of |page_object|.
//
// page_object  - handle to a page object.
//
// Returns the line join, or -1 on failure.
// Line join can be one of following: FPDF_LINEJOIN_MITER, FPDF_LINEJOIN_ROUND,
// FPDF_LINEJOIN_BEVEL

type TFPDFPageObj_GetLineJoin = function(page_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Set the line join of |page_object|.
//
// page_object  - handle to a page object.
// line_join    - line join
//
// Line join can be one of following: FPDF_LINEJOIN_MITER, FPDF_LINEJOIN_ROUND,
// FPDF_LINEJOIN_BEVEL

type TFPDFPageObj_SetLineJoin = function(page_object: FPDF_PAGEOBJECT; line_join: Integer): FPDF_BOOL; cdecl;

// Get the line cap of |page_object|.
//
// page_object - handle to a page object.
//
// Returns the line cap, or -1 on failure.
// Line cap can be one of following: FPDF_LINECAP_BUTT, FPDF_LINECAP_ROUND,
// FPDF_LINECAP_PROJECTING_SQUARE

type TFPDFPageObj_GetLineCap = function(page_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Set the line cap of |page_object|.
//
// page_object - handle to a page object.
// line_cap    - line cap
//
// Line cap can be one of following: FPDF_LINECAP_BUTT, FPDF_LINECAP_ROUND,
// FPDF_LINECAP_PROJECTING_SQUARE

type TFPDFPageObj_SetLineCap = function(page_object: FPDF_PAGEOBJECT; line_cap: Integer): FPDF_BOOL; cdecl;

// Set the fill RGBA of a page object. Range of values: 0 - 255.
//
// page_object  - the handle to the page object.
// R            - the red component for the object's fill color.
// G            - the green component for the object's fill color.
// B            - the blue component for the object's fill color.
// A            - the fill alpha for the object.
//
// Returns TRUE on success.

type TFPDFPageObj_SetFillColor = function(page_object: FPDF_PAGEOBJECT; R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Get the fill RGBA of a page object. Range of values: 0 - 255.
//
// page_object  - the handle to the page object.
// R            - the red component of the object's fill color.
// G            - the green component of the object's fill color.
// B            - the blue component of the object's fill color.
// A            - the fill alpha of the object.
//
// Returns TRUE on success.

type TFPDFPageObj_GetFillColor = function(page_object: FPDF_PAGEOBJECT; var R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get number of segments inside |path|.
//
//   path - handle to a path.
//
// A segment is a command, created by e.g. FPDFPath_MoveTo(),
// FPDFPath_LineTo() or FPDFPath_BezierTo().
//
// Returns the number of objects in |path| or -1 on failure.

type TFPDFPath_CountSegments = function(path: FPDF_PAGEOBJECT): Integer; cdecl;

// Experimental API.
// Get segment in |path| at |index|.
//
//   path  - handle to a path.
//   index - the index of a segment.
//
// Returns the handle to the segment, or NULL on faiure.

type TFPDFPath_GetPathSegment = function(path: FPDF_PAGEOBJECT; index: Integer): FPDF_PATHSEGMENT; cdecl;

// Experimental API.
// Get coordinates of |segment|.
//
//   segment  - handle to a segment.
//   x      - the horizontal position of the segment.
//   y      - the vertical position of the segment.
//
// Returns TRUE on success, otherwise |x| and |y| is not set.

type TFPDFPathSegment_GetPoint = function(segment: FPDF_PATHSEGMENT; var x, y: Single): FPDF_BOOL; cdecl;

// Experimental API.
// Get type of |segment|.
//
//   segment - handle to a segment.
//
// Returns one of the FPDF_SEGMENT_* values on success,
// FPDF_SEGMENT_UNKNOWN on error.

type TFPDFPathSegment_GetType = function(segment: FPDF_PATHSEGMENT): Integer; cdecl;

// Experimental API.
// Gets if the |segment| closes the current subpath of a given path.
//
//   segment - handle to a segment.
//
// Returns close flag for non-NULL segment, FALSE otherwise.

type TFPDFPathSegment_GetClose = function(segment: FPDF_PATHSEGMENT): FPDF_BOOL; cdecl;

// Move a path's current point.
//
// path   - the handle to the path object.
// x      - the horizontal position of the new current point.
// y      - the vertical position of the new current point.
//
// Note that no line will be created between the previous current point and the
// new one.
//
// Returns TRUE on success

type TFPDFPath_MoveTo = function(path: FPDF_PAGEOBJECT; x, y: Single): FPDF_BOOL; cdecl;

// Add a line between the current point and a new point in the path.
//
// path   - the handle to the path object.
// x      - the horizontal position of the new point.
// y      - the vertical position of the new point.
//
// The path's current point is changed to (x, y).
//
// Returns TRUE on success

type TFPDFPath_LineTo = function(path: FPDF_PAGEOBJECT; x, y: Single): FPDF_BOOL; cdecl;

// Add a cubic Bezier curve to the given path, starting at the current point.
//
// path   - the handle to the path object.
// x1     - the horizontal position of the first Bezier control point.
// y1     - the vertical position of the first Bezier control point.
// x2     - the horizontal position of the second Bezier control point.
// y2     - the vertical position of the second Bezier control point.
// x3     - the horizontal position of the ending point of the Bezier curve.
// y3     - the vertical position of the ending point of the Bezier curve.
//
// Returns TRUE on success

type TFPDFPath_BezierTo = function(path: FPDF_PAGEOBJECT; x1, y1, x2, y2, x3, y3: Single): FPDF_BOOL; cdecl;

// Close the current subpath of a given path.
//
// path   - the handle to the path object.
//
// This will add a line between the current point and the initial point of the
// subpath, thus terminating the current subpath.
//
// Returns TRUE on success

type TFPDFPath_Close = function(path: FPDF_PAGEOBJECT): FPDF_BOOL; cdecl;

// Set the drawing mode of a path.
//
// path     - the handle to the path object.
// fillmode - the filling mode to be set: one of the FPDF_FILLMODE_* flags.
// stroke   - a boolean specifying if the path should be stroked or not.
//
// Returns TRUE on success

type TFPDFPath_SetDrawMode = function(path: FPDF_PAGEOBJECT; fillmode: Integer; stroke: FPDF_BOOL): FPDF_BOOL; cdecl;

// Experimental API.
// Get the drawing mode of a path.
//
// path     - the handle to the path object.
// fillmode - the filling mode of the path: one of the FPDF_FILLMODE_* flags.
// stroke   - a boolean specifying if the path is stroked or not.
//
// Returns TRUE on success

type TFPDFPath_GetDrawMode = function(path: FPDF_PAGEOBJECT; out fillmode: Integer; out stroke: FPDF_BOOL): FPDF_BOOL; cdecl;

// Experimental API.
// Get the transform matrix of a path.
//
//   path - handle to a path.
//   a    - matrix value.
//   b    - matrix value.
//   c    - matrix value.
//   d    - matrix value.
//   e    - matrix value.
//   f    - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and used to scale, rotate, shear and translate the path.
//
// Returns TRUE on success.

type TFPDFPath_GetMatrix = function(path: FPDF_PAGEOBJECT; out a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;

// Experimental API.
// Set the transform matrix of a path.
//
//   path - handle to a path.
//   a    - matrix value.
//   b    - matrix value.
//   c    - matrix value.
//   d    - matrix value.
//   e    - matrix value.
//   f    - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and can be used to scale, rotate, shear and translate the path.
//
// Returns TRUE on success.

type TFPDFPath_SetMatrix = function(path: FPDF_PAGEOBJECT; a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;

// Create a new text object using one of the standard PDF fonts.
//
// document   - handle to the document.
// font       - string containing the font name, without spaces.
// font_size  - the font size for the new text object.
//
// Returns a handle to a new text object, or NULL on failure

type TFPDFPageObj_NewTextObj = function(document: FPDF_DOCUMENT; font: FPDF_BYTESTRING; font_size: Single): FPDF_PAGEOBJECT; cdecl;

// Set the text for a textobject. If it had text, it will be replaced.
//
// text_object  - handle to the text object.
// text         - the UTF-16LE encoded string containing the text to be added.
//
// Returns TRUE on success

type TFPDFText_SetText = function(text_object: FPDF_PAGEOBJECT; text: FPDF_WIDESTRING): FPDF_BOOL; cdecl;

// Returns a font object loaded from a stream of data. The font is loaded
// into the document.
//
// document   - handle to the document.
// data       - the stream of data, which will be copied by the font object.
// size       - size of the stream, in bytes.
// font_type  - FPDF_FONT_TYPE1 or FPDF_FONT_TRUETYPE depending on the font
// type.
// cid        - a boolean specifying if the font is a CID font or not.
//
// The loaded font can be closed using FPDFFont_Close.
//
// Returns NULL on failure

type TFPDFText_LoadFont = function(document: FPDF_DOCUMENT; const data: PByte; size: LongWord; font_type: Integer; cid: FPDF_BOOL): FPDF_FONT; cdecl;

// Experimental API.
// Loads one of the standard 14 fonts per PDF spec 1.7 page 416. The preferred
// way of using font style is using a dash to separate the name from the style,
// for example 'Helvetica-BoldItalic'.
//
// document   - handle to the document.
// font       - string containing the font name, without spaces.
//
// The loaded font can be closed using FPDFFont_Close.
//
// Returns NULL on failure.

type TFPDFText_LoadStandardFont = function(document: FPDF_DOCUMENT; font: FPDF_BYTESTRING): FPDF_FONT; cdecl;

// Experimental API.
// Get the transform matrix of a text object.
//
//   text - handle to a text.
//   a    - matrix value.
//   b    - matrix value.
//   c    - matrix value.
//   d    - matrix value.
//   e    - matrix value.
//   f    - matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and used to scale, rotate, shear and translate the text.
//
// Returns TRUE on success.

type TFPDFText_GetMatrix = function(text: FPDF_PAGEOBJECT; out  a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;

// Experimental API.
// Get the font size of a text object.
//
//   text - handle to a text.
//
// Returns the font size of the text object, measured in points (about 1/72
// inch) on success; 0 on failure.

type TFPDFTextObj_GetFontSize = function(text: FPDF_PAGEOBJECT): Double; cdecl;

// Close a loaded PDF font.
//
// font   - Handle to the loaded font.

type TFPDFFont_Close = procedure(font: FPDF_FONT); cdecl;

// Create a new text object using a loaded font.
//
// document   - handle to the document.
// font       - handle to the font object.
// font_size  - the font size for the new text object.
//
// Returns a handle to a new text object, or NULL on failure

type TFPDFPageObj_CreateTextObj = function(document: FPDF_DOCUMENT; font: FPDF_FONT; font_size: Single): FPDF_PAGEOBJECT; cdecl;

// Experimental API.
// Get the text rendering mode of a text object.
//
// text     - the handle to the text object.
//
// Returns one of the FPDF_TEXTRENDERMODE_* flags on success, -1 on error.

type TFPDFText_GetTextRenderMode = function(text: FPDF_PAGEOBJECT): Integer; cdecl;

// Experimental API.
// Get the font name of a text object.
//
// text             - the handle to the text object.
// buffer           - the address of a buffer that receives the font name.
// length           - the size, in bytes, of |buffer|.
//
// Returns the number of bytes in the font name (including the trailing NUL
// character) on success, 0 on error.
//
// Regardless of the platform, the |buffer| is always in UTF-8 encoding.
// If |length| is less than the returned length, or |buffer| is NULL, |buffer|
// will not be modified.

type TFPDFTextObj_GetFontName = function(text: FPDF_PAGEOBJECT; buffer: Pointer; length: LongWord): LongWord; cdecl;

// Experimental API.
// Get the text of a text object.
//
// text_object      - the handle to the text object.
// text_page        - the handle to the text page.
// buffer           - the address of a buffer that receives the text.
// length           - the size, in bytes, of |buffer|.
//
// Returns the number of bytes in the text (including the trailing NUL
// character) on success, 0 on error.
//
// Regardless of the platform, the |buffer| is always in UTF-16LE encoding.
// If |length| is less than the returned length, or |buffer| is NULL, |buffer|
// will not be modified.

type TFPDFTextObj_GetText = function(text_object: FPDF_PAGEOBJECT; text_page: FPDF_TEXTPAGE; buffer: Pointer; length: LongWord): LongWord; cdecl;

// Experimental API.
// Get number of page objects inside |form_object|.
//
//   form_object - handle to a form object.
//
// Returns the number of objects in |form_object| on success, -1 on error.

type TFPDFFormObj_CountObjects = function(form_object: FPDF_PAGEOBJECT): Integer; cdecl;

// Experimental API.
// Get page object in |form_object| at |index|.
//
//   form_object - handle to a form object.
//   index       - the 0-based index of a page object.
//
// Returns the handle to the page object, or NULL on error.

type TFPDFFormObj_GetObject = function(form_object: FPDF_PAGEOBJECT; index: LongWord): FPDF_PAGEOBJECT; cdecl;

// Experimental API.
// Get the transform matrix of a form object.
//
//   form_object - handle to a form.
//   a           - pointer to out variable to receive matrix value.
//   b           - pointer to out variable to receive matrix value.
//   c           - pointer to out variable to receive matrix value.
//   d           - pointer to out variable to receive matrix value.
//   e           - pointer to out variable to receive matrix value.
//   f           - pointer to out variable to receive matrix value.
//
// The matrix is composed as:
//   |a c e|
//   |b d f|
// and used to scale, rotate, shear and translate the form object.
//
// Returns TRUE on success.

type TFPDFFormObj_GetMatrix = function(form_object: FPDF_PAGEOBJECT; var a, b, c, d, e, f: Double): FPDF_BOOL; cdecl;


//type TFPDFPageObj_GetObjectType = function(page_object: FPDF_PAGEOBJECT): Integer; cdecl;

type TFPDFPageObj_GetImage = function(page_object: FPDF_PAGEOBJECT; var pixelHeight, pixelWidth: Integer; var size: LongWord; data: Pointer): FPDF_BOOL; cdecl;

type TFPDFPageObj_GetDIB = function(page_object: FPDF_PAGEOBJECT; var height, width, bpp, scanLineSize: Integer; data: Pointer): FPDF_BOOL; cdecl;

//type TFPDFPageObj_GetBoundingBox = function(page_object: FPDF_PAGEOBJECT; var left, top, right, bottom: Single): FPDF_BOOL; cdecl;

implementation

function FPDF_ARGB(a, r, g, b: Byte): LongWord;
begin
  Result := b or (LongWord(g) shl 8) or (LongWord(r) shl 16) or (LongWord(a) shl 24);
end;

function FPDF_GetBValue(argb: LongWord): Byte;
begin
  Result := Byte(argb);
end;

function FPDF_GetGValue(argb: LongWord): Byte;
begin
  Result := Byte(argb shr 8);
end;

function FPDF_GetRValue(argb: LongWord): Byte;
begin
  Result := Byte(argb shr 16);
end;

function FPDF_GetAValue(argb: LongWord): Byte;
begin
  Result := Byte(argb shr 24);
end;

end.