// Copyright 2016 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfStructTree;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Function: FPDF_StructTree_GetForPage
//          Get the structure tree for a page.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          function.
// Return value:
//          A handle to the structure tree or NULL on error.

type TFPDF_StructTree_GetForPage = function(page: FPDF_PAGE): FPDF_STRUCTTREE; cdecl;

// Function: FPDF_StructTree_Close
//          Release the resource allocate by FPDF_StructTree_GetForPage.
// Parameters:
//          struct_tree -   Handle to the struct tree. Returned by
//          FPDF_StructTree_LoadPage function.
// Return value:
//          NULL

type TFPDF_StructTree_Close = procedure(struct_tree: FPDF_STRUCTTREE); cdecl;

// Function: FPDF_StructTree_CountChildren
//          Count the number of children for the structure tree.
// Parameters:
//          struct_tree -   Handle to the struct tree. Returned by
//          FPDF_StructTree_LoadPage function.
// Return value:
//          The number of children, or -1 on error.

type TFPDF_StructTree_CountChildren = function(struct_tree: FPDF_STRUCTTREE): Integer; cdecl;

// Function: FPDF_StructTree_GetChildAtIndex
//          Get a child in the structure tree.
// Parameters:
//          struct_tree -   Handle to the struct tree. Returned by
//          FPDF_StructTree_LoadPage function.
//          index       -   The index for the child, 0-based.
// Return value:
//          The child at the n-th index or NULL on error.

type TFPDF_StructTree_GetChildAtIndex = function(struct_tree: FPDF_STRUCTTREE; index: Integer): FPDF_STRUCTELEMENT; cdecl;

// Function: FPDF_StructElement_GetAltText
//          Get the alt text for a given element.
// Parameters:
//          struct_element -   Handle to the struct element.
//          buffer         -   A buffer for output the alt text. May be NULL.
//          buflen         -   The length of the buffer, in bytes. May be 0.
// Return value:
//          The number of bytes in the title, including the terminating NUL
//          character. The number of bytes is returned regardless of the
//          |buffer| and |buflen| parameters.
// Comments:
//          Regardless of the platform, the |buffer| is always in UTF-16LE
//          encoding. The string is terminated by a UTF16 NUL character. If
//          |buflen| is less than the required length, or |buffer| is NULL,
//          |buffer| will not be modified.

type TFPDF_StructElement_GetAltText = function(struct_element: FPDF_STRUCTELEMENT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Function: FPDF_StructElement_GetMarkedContentID
//          Get the marked content ID for a given element.
// Parameters:
//          struct_element -   Handle to the struct element.
// Return value:
//          The marked content ID of the element. If no ID exists, returns
//          -1.

type TFPDF_StructElement_GetMarkedContentID = function(struct_element: FPDF_STRUCTELEMENT): Integer; cdecl;

// Function: FPDF_StructElement_GetType
//           Get the type (/S) for a given element.
// Parameters:
//           struct_element - Handle to the struct element.
//           buffer        - A buffer for output. May be NULL.
//           buflen        - The length of the buffer, in bytes. May be 0.
// Return value:
//           The number of bytes in the type, including the terminating NUL
//           character. The number of bytes is returned regardless of the
//           |buffer| and |buflen| parameters.
// Comments:
//           Regardless of the platform, the |buffer| is always in UTF-16LE
//           encoding. The string is terminated by a UTF16 NUL character. If
//           |buflen| is less than the required length, or |buffer| is NULL,
//           |buffer| will not be modified.

type TFPDF_StructElement_GetType = function(struct_element: FPDF_STRUCTELEMENT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Function: FPDF_StructElement_GetTitle
//           Get the title (/T) for a given element.
// Parameters:
//           struct_element - Handle to the struct element.
//           buffer         - A buffer for output. May be NULL.
//           buflen         - The length of the buffer, in bytes. May be 0.
// Return value:
//           The number of bytes in the title, including the terminating NUL
//           character. The number of bytes is returned regardless of the
//           |buffer| and |buflen| parameters.
// Comments:
//           Regardless of the platform, the |buffer| is always in UTF-16LE
//           encoding. The string is terminated by a UTF16 NUL character. If
//           |buflen| is less than the required length, or |buffer| is NULL,
//           |buffer| will not be modified.

type TFPDF_StructElement_GetTitle = function(struct_element: FPDF_STRUCTELEMENT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

// Function: FPDF_StructElement_CountChildren
//          Count the number of children for the structure element.
// Parameters:
//          struct_element -   Handle to the struct element.
// Return value:
//          The number of children, or -1 on error.

type TFPDF_StructElement_CountChildren = function(struct_element: FPDF_STRUCTELEMENT): Integer; cdecl;

// Function: FPDF_StructElement_GetChildAtIndex
//          Get a child in the structure element.
// Parameters:
//          struct_tree -   Handle to the struct element.
//          index       -   The index for the child, 0-based.
// Return value:
//          The child at the n-th index or NULL on error.
// Comments:
//          If the child exists but is not an element, then this function will
//          return NULL. This will also return NULL for out of bounds indices.

type TFPDF_StructElement_GetChildAtIndex = function(struct_element: FPDF_STRUCTELEMENT; index: Integer): FPDF_STRUCTELEMENT; cdecl;

implementation

end.