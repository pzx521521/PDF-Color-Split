// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfView;

{$WEAKPACKAGEUNIT}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}
{$endif}

interface

uses Windows;

{$ifndef D6PLUS}
type
  PByte = ^Byte;
{$endif D6PLUS}

type
  {$ifndef DXE2PLUS}
  NativeUInt = LongWord;
  {$endif DXE2PLUS}
  size_t = NativeUInt;

// PDF object types
const
  FPDF_OBJECT_UNKNOWN = 0;
  FPDF_OBJECT_BOOLEAN = 1;
  FPDF_OBJECT_NUMBER = 2;
  FPDF_OBJECT_STRING = 3;
  FPDF_OBJECT_NAME = 4;
  FPDF_OBJECT_ARRAY = 5;
  FPDF_OBJECT_DICTIONARY = 6;
  FPDF_OBJECT_STREAM = 7;
  FPDF_OBJECT_NULLOBJ = 8;
  FPDF_OBJECT_REFERENCE = 9;

// PDF types - use incomplete types (never completed) just for API type safety.
type
  FPDF_ACTION = Pointer;
  FPDF_ANNOTATION = Pointer;
  FPDF_ATTACHMENT = Pointer;
  FPDF_BITMAP = Pointer;
  FPDF_BOOKMARK = Pointer;
  FPDF_CLIPPATH = Pointer;
  FPDF_DEST = Pointer;
  FPDF_DOCUMENT = Pointer;
  FPDF_FONT = Pointer;
  FPDF_FORMHANDLE = Pointer;
  FPDF_LINK = Pointer;
  FPDF_PAGE = Pointer;
  FPDF_PAGELINK = Pointer;
  FPDF_PAGEOBJECT = Pointer; // Page object(text, path, etc)
  FPDF_PAGEOBJECTMARK = Pointer;
  FPDF_PAGERANGE = Pointer;
  FPDF_RECORDER = Pointer;
  FPDF_SCHHANDLE = Pointer;
  FPDF_STRUCTELEMENT = Pointer;
  FPDF_STRUCTTREE = Pointer;
  FPDF_TEXTPAGE = Pointer;
  FPDF_PATHSEGMENT = Pointer;

// Basic data types
type
  FPDF_BOOL = Integer;
  FPDF_ERROR = Integer;
  FPDF_DWORD = LongWord;

  FS_FLOAT = Single;

// Duplex types
type
  FPDF_DUPLEXTYPE = (DuplexUndefined { = 0}, Simplex, DuplexFlipShortEdge, DuplexFlipLongEdge);

// String types
type
  FPDF_WCHAR = Word;
  FPDF_LPCBYTE = ^Byte;

// FPDFSDK may use three types of strings: byte string, wide string (UTF-16LE encoded), and platform dependent string
type
  FPDF_BYTESTRING = PAnsiChar;

  // FPDFSDK always uses UTF-16LE encoded wide strings, each character uses 2
  // bytes (except surrogation), with the low byte first.
  FPDF_WIDESTRING = PWideChar;

  // For Windows programmers: In most cases it's OK to treat FPDF_WIDESTRING as a
  // Windows unicode string, however, special care needs to be taken if you
  // expect to process Unicode larger than 0xffff.
  // For Linux/Unix programmers: most compiler/library environments use 4 bytes
  // for a Unicode character, and you have to convert between FPDF_WIDESTRING and
  // system wide string by yourself.
  FPDF_STRING = PAnsiChar;

// Matrix for transformation, in the form [a b c d e f], equivalent to:
// | a  b  0 |
// | c  d  0 |
// | e  f  1 |
//
// Translation is performed with [1 0 0 1 tx ty].
// Scaling is performed with [sx 0 0 sy 0 0].
// See PDF Reference 1.7, 4.2.2 Common Transformations for more.
type
  FS_MATRIX = record
    a: Single;
    b: Single;
    c: Single;
    d: Single;
    e: Single;
    f: Single;
  end;

// Rectangle area(float) in device or page coordinate system.
type
  FS_RECTF = record
    left: Single; // The x-coordinate of the left-top corner.
    top: Single; // The y-coordinate of the left-top corner.
    right: Single; // The x-coordinate of the right-bottom corner.
    bottom: Single; // The y-coordinate of the right-bottom corner.
  end;

  FS_LPRECTF = ^FS_RECTF;
  FS_LPCRECTF = ^FS_RECTF;

// Annotation enums.

  FPDF_ANNOTATION_SUBTYPE = Integer;
  FPDF_ANNOT_APPEARANCEMODE = Integer;

// Dictionary value types.

  FPDF_OBJECT_TYPE = Integer;

// Exported Functions

// Function: FPDF_InitLibrary
//          Initialize the FPDFSDK library
// Parameters:
//          None
// Return value:
//          None.
// Comments:
//          Convenience function to call FPDF_InitLibraryWithConfig() for
//          backwards comatibility purposes.

type TFPDF_InitLibrary = procedure; cdecl;

// Process-wide options for initializing the library.
type
  FPDF_LIBRARY_CONFIG = record
    // Version number of the interface. Currently must be 2.
    Version: Integer;

    // Array of paths to scan in place of the defaults when using built-in
    // FXGE font loading code. The array is terminated by a NULL pointer.
    // The Array may be NULL itself to use the default paths. May be ignored
    // entirely depending upon the platform.
    m_pUserFontPaths: ^PAnsiChar;

    // Version 2.

    // pointer to the v8::Isolate to use, or NULL to force PDFium to create one.
    m_pIsolate: Pointer;

    // The embedder data slot to use in the v8::Isolate to store PDFium's
    // per-isolate data. The value needs to be between 0 and
    // v8::Internals::kNumIsolateDataLots (exclusive). Note that 0 is fine
    // for most embedders.
    m_v8EmbedderSlot: LongWord;
  end;

// Function: FPDF_InitLibraryWithConfig
//          Initialize the FPDFSDK library
// Parameters:
//          config - configuration information as above.
// Return value:
//          None.
// Comments:
//          You have to call this function before you can call any PDF
//          processing functions.

type TFPDF_InitLibraryWithConfig = procedure(var Config: FPDF_LIBRARY_CONFIG); cdecl;

// Function: FPDF_DestroyLibary
//          Release all resources allocated by the FPDFSDK library.
// Parameters:
//          None.
// Return value:
//          None.
// Comments:
//          You can call this function to release all memory blocks allocated by
//          the library.
//          After this function is called, you should not call any PDF
//          processing functions.

type TFPDF_DestroyLibrary = procedure; cdecl;

// Policy for accessing the local machine time.
const
  FPDF_POLICY_MACHINETIME_ACCESS = 0;

// Function: FPDF_SetSandBoxPolicy
//          Set the policy for the sandbox environment.
// Parameters:
//          policy -   The specified policy for setting, for example:
//                     FPDF_POLICY_MACHINETIME_ACCESS.
//          enable -   True to enable, false to disable the policy.
// Return value:
//          None.

type TFPDF_SetSandBoxPolicy = procedure(policy: FPDF_DWORD; enable: FPDF_BOOL); cdecl;

{
// Pointer to a helper function to make |font| with |text| of |text_length|
// accessible when printing text with GDI. This is useful in sandboxed
// environments where PDFium's access to GDI may be restricted.

type TPDFiumEnsureTypefaceCharactersAccessible = procedure(font: PLOGFONT; text: PWideChar; text_length: LongWord); cdecl;

// Function: FPDF_SetTypefaceAccessibleFunc
//          Set the function pointer that makes GDI fonts available in sandboxed
//          environments. Experimental API.
// Parameters:
//          func -   A function pointer. See description above.
// Return value:
//          None.

type TFPDF_SetTypefaceAccessibleFunc = procedure(func: TPDFiumEnsureTypefaceCharactersAccessible); cdecl;

// Function: FPDF_SetPrintTextWithGDI
//          Set whether to use GDI to draw fonts when printing on Windows.
//          Experimental API.
// Parameters:
//          use_gdi -   Set to true to enable printing text with GDI.
// Return value:
//          None.

type TFPDF_SetPrintTextWithGDI = procedure(use_gdi: FPDF_BOOL); cdecl;

// Function: FPDF_SetPrintMode
//          Set printing mode when printing on Windows.
//          Experimental API.
// Parameters:
//          mode - FPDF_PRINTMODE_EMF to output EMF (default)
//                 FPDF_PRINTMODE_TEXTONLY to output text only (for charstream
//                 devices)
//                 FPDF_PRINTMODE_POSTSCRIPT2 to output level 2 PostScript into
//                 EMF as a series of GDI comments.
//                 FPDF_PRINTMODE_POSTSCRIPT3 to output level 3 PostScript into
//                 EMF as a series of GDI comments.
//                 FPDF_PRINTMODE_POSTSCRIPT2_PASSTHROUGH to output level 2
//                 PostScript via ExtEscape() in PASSTHROUGH mode.
//                 FPDF_PRINTMODE_POSTSCRIPT3_PASSTHROUGH to output level 3
//                 PostScript via ExtEscape() in PASSTHROUGH mode.
// Return value:
//          True if successful, false if unsuccessful (typically invalid input).

type TFPDF_SetPrintMode = function(mode: Integer): FPDF_BOOL; cdecl;
}

// Function: FPDF_LoadDocument
//          Open and load a PDF document.
// Parameters:
//          file_path -  Path to the PDF file (including extension).
//          password  -  A string used as the password for the PDF file.
//                       If no password is needed, empty or NULL can be used.
//                       See comments below regarding the encoding.
// Return value:
//          A handle to the loaded document, or NULL on failure.
// Comments:
//          Loaded document can be closed by FPDF_CloseDocument().
//          If this function fails, you can use FPDF_GetLastError() to retrieve
//          the reason why it failed.
//
//          The encoding for |password| can be either UTF-8 or Latin-1. PDFs,
//          depending on the security handler revision, will only accept one or
//          the other encoding. If |password|'s encoding and the PDF's expected
//          encoding do not match, FPDF_LoadDocument() will automatically
//          convert |password| to the other encoding.

type TFPDF_LoadDocument = function(file_path: FPDF_STRING; password: FPDF_BYTESTRING): FPDF_DOCUMENT; cdecl;

// Function: FPDF_LoadMemDocument
//          Open and load a PDF document from memory.
// Parameters:
//          data_buf    -   Pointer to a buffer containing the PDF document.
//          size        -   Number of bytes in the PDF document.
//          password    -   A string used as the password for the PDF file.
//                          If no password is needed, empty or NULL can be used.
// Return value:
//          A handle to the loaded document, or NULL on failure.
// Comments:
//          The memory buffer must remain valid when the document is open.
//          The loaded document can be closed by FPDF_CloseDocument.
//          If this function fails, you can use FPDF_GetLastError() to retrieve
//          the reason why it failed.
//
//          See the comments for FPDF_LoadDocument() regarding the encoding for
//          |password|.
// Notes:
//          If PDFium is built with the XFA module, the application should call
//          FPDF_LoadXFA() function after the PDF document loaded to support XFA
//          fields defined in the fpdfformfill.h file.

type TFPDF_LoadMemDocument = function(data_buf: Pointer; size: Integer; password: FPDF_BYTESTRING): FPDF_DOCUMENT; cdecl;

// Structure for custom file access.
type
  m_GetBlock = function(param: Pointer; position: LongWord; pBuf: PByte; size: LongWord): Integer; cdecl;

  FPDF_FILEACCESS = record
    m_FileLen: LongWord; // File length, in bytes.

    // A function pointer for getting a block of data from a specific position.
    // Position is specified by byte offset from the beginning of the file.
    // The pointer to the buffer is never NULL and the size is never 0.
    // It may be possible for FPDFSDK to call this function multiple times for
    // the same position.
    // Return value: should be non-zero if successful, zero for error.
    m_GetBlock: m_GetBlock;

    // A custom pointer for all implementation specific data.  This pointer will
    // be used as the first parameter to the m_GetBlock callback.
    m_Param: Pointer;
  end;

  PFPDF_FILEACCESS = ^FPDF_FILEACCESS;

// Function: FPDF_LoadCustomDocument
//          Load PDF document from a custom access descriptor.
// Parameters:
//          pFileAccess -   A structure for accessing the file.
//          password    -   Optional password for decrypting the PDF file.
// Return value:
//          A handle to the loaded document, or NULL on failure.
// Comments:
//          The application must keep the file resources |pFileAccess| points to
//          valid until the returned FPDF_DOCUMENT is closed. |pFileAccess|
//          itself does not need to outlive the FPDF_DOCUMENT.
//
//          The loaded document can be closed with FPDF_CloseDocument().
//
//          See the comments for FPDF_LoadDocument() regarding the encoding for
//          |password|.
// Notes:
//          If PDFium is built with the XFA module, the application should call
//          FPDF_LoadXFA() function after the PDF document loaded to support XFA
//          fields defined in the fpdfformfill.h file.

type TFPDF_LoadCustomDocument = function(pFileAccess: PFPDF_FILEACCESS; password: FPDF_BYTESTRING): FPDF_DOCUMENT; cdecl;

// Function: FPDF_GetFileVersion
//          Get the file version of the given PDF document.
// Parameters:
//          doc         -   Handle to a document.
//          fileVersion -   The PDF file version. File version: 14 for 1.4, 15
//                          for 1.5, ...
// Return value:
//          True if succeeds, false otherwise.
// Comments:
//          If the document was created by FPDF_CreateNewDocument,
//          then this function will always fail.

type TFPDF_GetFileVersion = function(doc: FPDF_DOCUMENT; var fileVersion: Integer): FPDF_BOOL; cdecl;

const
  FPDF_ERR_SUCCESS  = 0; // No error.
  FPDF_ERR_UNKNOWN  = 1; // Unknown error.
  FPDF_ERR_FILE     = 2; // File not found or could not be opened.
  FPDF_ERR_FORMAT   = 3; // File not in PDF format or corrupted.
  FPDF_ERR_PASSWORD = 4; // Password required or incorrect password.
  FPDF_ERR_SECURITY = 5; // Unsupported security scheme.
  FPDF_ERR_PAGE     = 6; // Page not found or content error.

// Function: FPDF_GetLastError
//          Get last error code when a function fails.
// Parameters:
//          None.
// Return value:
//          A 32-bit integer indicating error code as defined above.
// Comments:
//          If the previous SDK call succeeded, the return value of this
//          function is not defined.

type TFPDF_GetLastError = function: LongWord; cdecl;

// Function: FPDF_DocumentHasValidCrossReferenceTable
//          Whether the document's cross reference table is valid or not.
//          Experimental API.
// Parameters:
//          document    -   Handle to a document. Returned by FPDF_LoadDocument.
// Return value:
//          True if the PDF parser did not encounter problems parsing the cross
//          reference table. False if the parser could not parse the cross
//          reference table and the table had to be rebuild from other data
//          within the document.
// Comments:
//          The return value can change over time as the PDF parser evolves.

type TFPDF_DocumentHasValidCrossReferenceTable = function(document: FPDF_DOCUMENT): FPDF_BOOL; cdecl;

// Function: FPDF_GetDocPermission
//          Get file permission flags of the document.
// Parameters:
//          document    -   Handle to a document. Returned by FPDF_LoadDocument.
// Return value:
//          A 32-bit integer indicating permission flags. Please refer to the
//          PDF Reference for detailed descriptions. If the document is not
//          protected, 0xffffffff will be returned.

type TFPDF_GetDocPermissions = function(document: FPDF_DOCUMENT): LongWord; cdecl;

// Function: FPDF_GetSecurityHandlerRevision
//          Get the revision for the security handler.
// Parameters:
//          document    -   Handle to a document. Returned by FPDF_LoadDocument.
// Return value:
//          The security handler revision number. Please refer to the PDF
//          Reference for a detailed description. If the document is not
//          protected, -1 will be returned.

type TFPDF_GetSecurityHandlerRevision = function(document: FPDF_DOCUMENT): Integer; cdecl;

// Function: FPDF_GetPageCount
//          Get total number of pages in the document.
// Parameters:
//          document    -   Handle to document. Returned by FPDF_LoadDocument.
// Return value:
//          Total number of pages in the document.

type TFPDF_GetPageCount = function(document: FPDF_DOCUMENT): Integer; cdecl;

// Function: FPDF_LoadPage
//          Load a page inside the document.
// Parameters:
//          document    -   Handle to document. Returned by FPDF_LoadDocument
//          page_index  -   Index number of the page. 0 for the first page.
// Return value:
//          A handle to the loaded page, or NULL if page load fails.
// Comments:
//          The loaded page can be rendered to devices using FPDF_RenderPage.
//          The loaded page can be closed using FPDF_ClosePage.

type TFPDF_LoadPage = function(document: FPDF_DOCUMENT; page_index: Integer): FPDF_PAGE; cdecl;

// Function: FPDF_GetPageWidth
//          Get page width.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
// Return value:
//          Page width (excluding non-displayable area) measured in points.
//          One point is 1/72 inch (around 0.3528 mm).

type TFPDF_GetPageWidth = function(page: FPDF_PAGE): Double; cdecl;

// Function: FPDF_GetPageHeight
//          Get page height.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
// Return value:
//          Page height (excluding non-displayable area) measured in points.
//          One point is 1/72 inch (around 0.3528 mm)

type TFPDF_GetPageHeight = function(page: FPDF_PAGE): Double; cdecl;

// Experimental API.
// Function: FPDF_GetPageBoundingBox
//          Get the bounding box of the page. This is the intersection between
//          its media box and its crop box.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
//          rect        -   Pointer to a rect to receive the page bounding box.
//                          On an error, |rect| won't be filled.
// Return value:
//          True for success.

type TFPDF_GetPageBoundingBox = function(page: FPDF_PAGE; var rect: FS_RECTF): FPDF_BOOL; cdecl;

// Function: FPDF_GetPageSizeByIndex
//          Get the size of the page at the given index.
// Parameters:
//          document    -   Handle to document. Returned by FPDF_LoadDocument.
//          page_index  -   Page index, zero for the first page.
//          width       -   Pointer to a double to receive the page width
//                          (in points).
//          height      -   Pointer to a double to receive the page height
//                          (in points).
// Return value:
//          Non-zero for success. 0 for error (document or page not found).

type TFPDF_GetPageSizeByIndex = function(document: FPDF_DOCUMENT; page_index: Integer; var width, height: Double): Integer; cdecl;

// Page rendering flags. They can be combined with bit OR.
const
  FPDF_ANNOT         = $01; // Set if annotations are to be rendered.
  FPDF_LCD_TEXT      = $02; // Set if using text rendering optimized for LCD display.
  FPDF_NO_NATIVETEXT = $04; // Don't use the native text output available on some platforms
  FPDF_GRAYSCALE     = $08; // Grayscale output.
  FPDF_DEBUG_INFO    = $80; // Set if you want to get some debug info.
                            // Please discuss with Foxit first if you need to collect debug info.
  FPDF_NO_CATCH                 = $100;  // Set if you don't want to catch exceptions.
  FPDF_RENDER_LIMITEDIMAGECACHE = $200;  // Limit image cache size.
  FPDF_RENDER_FORCEHALFTONE     = $400;  // Always use halftone for image stretching.
  FPDF_PRINTING                 = $800;  // Render for printing.
  FPDF_RENDER_NO_SMOOTHTEXT     = $1000; // Set to disable anti-aliasing on text.
  FPDF_RENDER_NO_SMOOTHIMAGE    = $2000; // Set to disable anti-aliasing on images.
  FPDF_RENDER_NO_SMOOTHPATH     = $4000; // Set to disable anti-aliasing on paths.
  FPDF_REVERSE_BYTE_ORDER       = $10;   // set whether render in a reverse Byte order, this flag is only
                                         // used when renderint to a bitmap.

// Function: FPDF_RenderPage
//          Render contents of a page to a device (screen, bitmap, or printer).
//          This function is only supported on Windows.
// Parameters:
//          dc          -   Handle to the device context.
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
//          start_x     -   Left pixel position of the display area in
//                          device coordinates.
//          start_y     -   Top pixel position of the display area in device
//                          coordinates.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation:
//                            0 (normal)
//                            1 (rotated 90 degrees clockwise)
//                            2 (rotated 180 degrees)
//                            3 (rotated 90 degrees counter-clockwise)
//          flags       -   0 for normal display, or combination of the Page
//                          Rendering flags defined above. With the FPDF_ANNOT
//                          flag, it renders all annotations that do not require
//                          user-interaction, which are all annotations except
//                          widget and popup annotations.
// Return value:
//          None.

type TFPDF_RenderPage = procedure(dc: HDC; page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, flags: Integer); cdecl;

// Function: FPDF_RenderPageBitmap
//          Render contents of a page to a device independent bitmap.
// Parameters:
//          bitmap      -   Handle to the device independent bitmap (as the
//                          output buffer). The bitmap handle can be created
//                          by FPDFBitmap_Create or retrieved from an image
//                          object by FPDFImageObj_GetBitmap.
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          start_x     -   Left pixel position of the display area in
//                          bitmap coordinates.
//          start_y     -   Top pixel position of the display area in bitmap
//                          coordinates.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation:
//                            0 (normal)
//                            1 (rotated 90 degrees clockwise)
//                            2 (rotated 180 degrees)
//                            3 (rotated 90 degrees counter-clockwise)
//          flags       -   0 for normal display, or combination of flags
//                          defined above. With FPDF_ANNOT flag, it renders all
//                          annotations that does not require user-interaction,
//                          which are all annotations except widget and popup
//                          annotations.
// Return value:
//          None.

type TFPDF_RenderPageBitmap = procedure(bitmap: FPDF_BITMAP; page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, flags: Integer); cdecl;

// Function: FPDF_RenderPageBitmapWithMatrix
//          Render contents of a page to a device independent bitmap.
// Parameters:
//          bitmap      -   Handle to the device independent bitmap (as the
//                          by FPDFBitmap_Create or retrieved by
//                          FPDFImageObj_GetBitmap.
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          matrix      -   The transform matrix, which must be invertible.
//                          See PDF Reference 1.7, 4.2.2 Common Transformations.
//          clipping    -   The rect to clip to in device coords.
//          flags       -   0 for normal display, or combination of the Page
//                          Rendering flags defined above. With the FPDF_ANNOT
//                          flag, it renders all annotations that do not require
//                          user-interaction, which are all annotations except
//                          widget and popup annotations.
// Return value:
//          None. Note that behavior is undefined if det of |matrix| is 0.

type TFPDF_RenderPageBitmapWithMatrix = procedure(bitmap: FPDF_BITMAP; page: FPDF_PAGE; var matrix: FS_MATRIX; var clipping: FS_RECTF; flags: Integer); cdecl;

// Function: FPDF_ClosePage
//          Close a loaded PDF page.
// Parameters:
//          page        -   Handle to the loaded page.
// Return value:
//          None.

type TFPDF_ClosePage = procedure(page: FPDF_PAGE); cdecl;

// Function: FPDF_CloseDocument
//          Close a loaded PDF document.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          None.

type TFPDF_CloseDocument = procedure(document: FPDF_DOCUMENT); cdecl;

// Function: FPDF_DeviceToPage
//          Convert the screen coordinates of a point to page coordinates.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
//          start_x     -   Left pixel position of the display area in
//                          device coordinates.
//          start_y     -   Top pixel position of the display area in device
//                          coordinates.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation:
//                            0 (normal)
//                            1 (rotated 90 degrees clockwise)
//                            2 (rotated 180 degrees)
//                            3 (rotated 90 degrees counter-clockwise)
//          device_x    -   X value in device coordinates to be converted.
//          device_y    -   Y value in device coordinates to be converted.
//          page_x      -   A pointer to a double receiving the converted X
//                          value in page coordinates.
//          page_y      -   A pointer to a double receiving the converted Y
//                          value in page coordinates.
// Return value:
//          Returns true if the conversion succeeds, and |page_x| and |page_y|
//          successfully receives the converted coordinates.
// Comments:
//          The page coordinate system has its origin at the left-bottom corner
//          of the page, with the X-axis on the bottom going to the right, and
//          the Y-axis on the left side going up.
//
//          NOTE: this coordinate system can be altered when you zoom, scroll,
//          or rotate a page, however, a point on the page should always have
//          the same coordinate values in the page coordinate system.
//
//          The device coordinate system is device dependent. For screen device,
//          its origin is at the left-top corner of the window. However this
//          origin can be altered by the Windows coordinate transformation
//          utilities.
//
//          You must make sure the start_x, start_y, size_x, size_y
//          and rotate parameters have exactly same values as you used in
//          the FPDF_RenderPage() function call.

type TFPDF_DeviceToPage = function(page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, device_x, device_y: Integer; out page_x, page_y: Double): FPDF_BOOL; cdecl;

// Function: FPDF_PageToDevice
//          Convert the page coordinates of a point to screen coordinates.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
//          start_x     -   Left pixel position of the display area in
//                          device coordinates.
//          start_y     -   Top pixel position of the display area in device
//                          coordinates.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation:
//                            0 (normal)
//                            1 (rotated 90 degrees clockwise)
//                            2 (rotated 180 degrees)
//                            3 (rotated 90 degrees counter-clockwise)
//          page_x      -   X value in page coordinates.
//          page_y      -   Y value in page coordinate.
//          device_x    -   A pointer to an integer receiving the result X
//                          value in device coordinates.
//          device_y    -   A pointer to an integer receiving the result Y
//                          value in device coordinates.
// Return value:
//          Returns true if the conversion succeeds, and |device_x| and
//          |device_y| successfully receives the converted coordinates.
// Comments:
//          See comments for FPDF_DeviceToPage().

type TFPDF_PageToDevice = function(page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate: Integer; page_x, page_y: Double; out device_x, device_y: Integer): FPDF_BOOL; cdecl;

// Function: FPDFBitmap_Create
//          Create a device independent bitmap (FXDIB).
// Parameters:
//          width       -   The number of pixels in width for the bitmap.
//                          Must be greater than 0.
//          height      -   The number of pixels in height for the bitmap.
//                          Must be greater than 0.
//          alpha       -   A flag indicating whether the alpha channel is used.
//                          Non-zero for using alpha, zero for not using.
// Return value:
//          The created bitmap handle, or NULL if a parameter error or out of
//          memory.
// Comments:
//          The bitmap always uses 4 bytes per pixel. The first byte is always
//          double word aligned.
//
//          The byte order is BGRx (the last byte unused if no alpha channel) or
//          BGRA.
//
//          The pixels in a horizontal line are stored side by side, with the
//          left most pixel stored first (with lower memory address).
//          Each line uses width * 4 bytes.
//
//          Lines are stored one after another, with the top most line stored
//          first. There is no gap between adjacent lines.
//
//          This function allocates enough memory for holding all pixels in the
//          bitmap, but it doesn't initialize the buffer. Applications can use
//          FPDFBitmap_FillRect to fill the bitmap using any color.

type TFPDFBitmap_Create = function(width, height, alpha: Integer): FPDF_BITMAP; cdecl;

// More DIB formats
const
  FPDFBitmap_Unknown = 0; // Unknown or unsupported format.
  FPDFBitmap_Gray    = 1; // Gray scale bitmap, one byte per pixel.
  FPDFBitmap_BGR     = 2; // 3 bytes per pixel, byte order: blue, green, red.
  FPDFBitmap_BGRx    = 3; // 4 bytes per pixel, byte order: blue, green, red, unused.
  FPDFBitmap_BGRA    = 4; // 4 bytes per pixel, byte order: blue, green, red, alpha.

// Function: FPDFBitmap_CreateEx
//          Create a device independent bitmap (FXDIB)
// Parameters:
//          width       -   The number of pixels in width for the bitmap.
//                          Must be greater than 0.
//          height      -   The number of pixels in height for the bitmap.
//                          Must be greater than 0.
//          format      -   A number indicating for bitmap format, as defined
//                          above.
//          first_scan  -   A pointer to the first byte of the first line if
//                          using an external buffer. If this parameter is NULL,
//                          then the a new buffer will be created.
//          stride      -   Number of bytes for each scan line, for external
//                          buffer only.
// Return value:
//          The bitmap handle, or NULL if parameter error or out of memory.
// Comments:
//          Similar to FPDFBitmap_Create function, but allows for more formats
//          and an external buffer is supported. The bitmap created by this
//          function can be used in any place that a FPDF_BITMAP handle is
//          required.
//
//          If an external buffer is used, then the application should destroy
//          the buffer by itself. FPDFBitmap_Destroy function will not destroy
//          the buffer.

type TFPDFBitmap_CreateEx = function(width, height, format: Integer; first_scan: Pointer; stride: Integer): FPDF_BITMAP; cdecl;

// Function: FPDFBitmap_GetFormat
//          Get the format of the bitmap.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The format of the bitmap.
// Comments:
//          Only formats supported by FPDFBitmap_CreateEx are supported by this
//          function; see the list of such formats above.

type TFPDFBitmap_GetFormat = function(bitmap: FPDF_BITMAP): Integer; cdecl;

// Function: FPDFBitmap_FillRect
//          Fill a rectangle in a bitmap.
// Parameters:
//          bitmap      -   The handle to the bitmap. Returned by
//                          FPDFBitmap_Create.
//          left        -   The left position. Starting from 0 at the
//                          left-most pixel.
//          top         -   The top position. Starting from 0 at the
//                          top-most line.
//          width       -   Width in pixels to be filled.
//          height      -   Height in pixels to be filled.
//          color       -   A 32-bit value specifing the color, in 8888 ARGB
//                          format.
// Return value:
//          None.
// Comments:
//          This function sets the color and (optionally) alpha value in the
//          specified region of the bitmap.
//
//          NOTE: If the alpha channel is used, this function does NOT
//          composite the background with the source color, instead the
//          background will be replaced by the source color and the alpha.
//
//          If the alpha channel is not used, the alpha parameter is ignored.

type TFPDFBitmap_FillRect = procedure(bitmap: FPDF_BITMAP; left, top, width, height, color: FPDF_DWORD); cdecl;

// Function: FPDFBitmap_GetBuffer
//          Get data buffer of a bitmap.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The pointer to the first byte of the bitmap buffer.
// Comments:
//          The stride may be more than width * number of bytes per pixel
//
//          Applications can use this function to get the bitmap buffer pointer,
//          then manipulate any color and/or alpha values for any pixels in the
//          bitmap.
//
//          The data is in BGRA format. Where the A maybe unused if alpha was
//          not specified.

type TFPDFBitmap_GetBuffer = function(bitmap: FPDF_BITMAP): Pointer; cdecl;

// Function: FPDFBitmap_GetWidth
//          Get width of a bitmap.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The width of the bitmap in pixels.

type TFPDFBitmap_GetWidth = function(bitmap: FPDF_BITMAP): Integer; cdecl;

// Function: FPDFBitmap_GetHeight
//          Get height of a bitmap.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The height of the bitmap in pixels.

type TFPDFBitmap_GetHeight = function(bitmap: FPDF_BITMAP): Integer; cdecl;

// Function: FPDFBitmap_GetStride
//          Get number of bytes for each line in the bitmap buffer.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The number of bytes for each line in the bitmap buffer.
// Comments:
//          The stride may be more than width * number of bytes per pixel.

type TFPDFBitmap_GetStride = function(bitmap: FPDF_BITMAP): Integer; cdecl;

// Function: FPDFBitmap_Destroy
//          Destroy a bitmap and release all related buffers.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          None.
// Comments:
//          This function will not destroy any external buffers provided when
//          the bitmap was created.

type TFPDFBitmap_Destroy = procedure(bitmap: FPDF_BITMAP); cdecl;

// Function: FPDF_VIEWERREF_GetPrintScaling
//          Whether the PDF document prefers to be scaled or not.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          None.

type TFPDF_VIEWERREF_GetPrintScaling = function(document: FPDF_DOCUMENT): FPDF_BOOL; cdecl;

// Function: FPDF_VIEWERREF_GetNumCopies
//          Returns the number of copies to be printed.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          The number of copies to be printed.

type TFPDF_VIEWERREF_GetNumCopies = function(document: FPDF_DOCUMENT): Integer; cdecl;

// Function: FPDF_VIEWERREF_GetPrintPageRange
//          Page numbers to initialize print dialog box when file is printed.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          The print page range to be used for printing.

type TFPDF_VIEWERREF_GetPrintPageRange = function(document: FPDF_DOCUMENT): FPDF_PAGERANGE; cdecl;

// Function: FPDF_VIEWERREF_GetPrintPageRangeCount
//          Returns the number of elements in a FPDF_PAGERANGE.
//          Experimental API.
// Parameters:
//          pagerange   -   Handle to the page range.
// Return value:
//          The number of elements in the page range. Returns 0 on error.

type TFPDF_VIEWERREF_GetPrintPageRangeCount = function(pagerange: FPDF_PAGERANGE): size_t; cdecl;

// Function: FPDF_VIEWERREF_GetPrintPageRangeElement
//          Returns an element from a FPDF_PAGERANGE.
//          Experimental API.
// Parameters:
//          pagerange   -   Handle to the page range.
//          index       -   Index of the element.
// Return value:
//          The value of the element in the page range at a given index.
//          Returns -1 on error.

type TFPDF_VIEWERREF_GetPrintPageRangeElement = function(pagerange: FPDF_PAGERANGE; index: size_t): Integer; cdecl;

// Function: FPDF_VIEWERREF_GetDuplex
//          Returns the paper handling option to be used when printing from
//          the print dialog.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          The paper handling option to be used when printing.

type TFPDF_VIEWERREF_GetDuplex = function(document: FPDF_DOCUMENT): FPDF_DUPLEXTYPE; cdecl;

// Function: FPDF_VIEWERREF_GetName
//          Gets the contents for a viewer ref, with a given key. The value must
//          be of type "name".
// Parameters:
//          document    -   Handle to the loaded document.
//          key         -   Name of the key in the viewer pref dictionary,
//                          encoded in UTF-8.
//          buffer      -   A string to write the contents of the key to.
//          length      -   Length of the buffer.
// Return value:
//          The number of bytes in the contents, including the NULL terminator.
//          Thus if the return value is 0, then that indicates an error, such
//          as when |document| is invalid or |buffer| is NULL. If |length| is
//          less than the returned length, or |buffer| is NULL, |buffer| will
//          not be modified.

type TFPDF_VIEWERREF_GetName = function(document: FPDF_DOCUMENT; key: FPDF_BYTESTRING; buffer: PAnsiChar; length: LongWord): LongWord; cdecl;

// Function: FPDF_CountNamedDests
//          Get the count of named destinations in the PDF document.
// Parameters:
//          document    -   Handle to a document
// Return value:
//          The count of named destinations.

type TFPDF_CountNamedDests = function(document: FPDF_DOCUMENT): FPDF_DWORD; cdecl;

// Function: FPDF_GetNamedDestByName
//          Get a the destination handle for the given name.
// Parameters:
//          document    -   Handle to the loaded document.
//          name        -   The name of a destination.
// Return value:
//          The handle to the destination.

type TFPDF_GetNamedDestByName = function(document: FPDF_DOCUMENT; name: FPDF_BYTESTRING): FPDF_DEST; cdecl;

// Function: FPDF_GetNamedDest
//          Get the named destination by index.
// Parameters:
//          document        -   Handle to a document
//          index           -   The index of a named destination.
//          buffer          -   The buffer to store the destination name,
//                              used as wchar_t*.
//          buflen [in/out] -   Size of the buffer in bytes on input,
//                              length of the result in bytes on output
//                              or -1 if the buffer is too small.
// Return value:
//          The destination handle for a given index, or NULL if there is no
//          named destination corresponding to |index|.
// Comments:
//          Call this function twice to get the name of the named destination:
//            1) First time pass in |buffer| as NULL and get buflen.
//            2) Second time pass in allocated |buffer| and buflen to retrieve
//               |buffer|, which should be used as wchar_t*.
//
//         If buflen is not sufficiently large, it will be set to -1 upon
//         return.

type TFPDF_GetNamedDest = function(document: FPDF_DOCUMENT; index: Integer; buffer: Pointer; var buflen: LongWord): FPDF_DEST; cdecl;

implementation

end.