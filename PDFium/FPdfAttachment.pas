// Copyright 2017 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

unit FPdfAttachment;

interface

uses FPdfView;

// Experimental API.
// Get the number of embedded files in |document|.
//
//   document - handle to a document.
//
// Returns the number of embedded files in |document|.

type TFPDFDoc_GetAttachmentCount = function(document: FPDF_DOCUMENT): Integer; cdecl;

// Experimental API.
// Add an embedded file with |name| in |document|. If |name| is empty, or if
// |name| is the name of a existing embedded file in |document|, or if
// |document|'s embedded file name tree is too deep (i.e. |document| has too
// many embedded files already), then a new attachment will not be added.
//
//   document - handle to a document.
//   name     - name of the new attachment.
//
// Returns a handle to the new attachment object, or NULL on failure.

type TFPDFDoc_AddAttachment = function(document: FPDF_DOCUMENT; name: FPDF_WIDESTRING): FPDF_ATTACHMENT; cdecl;

// Experimental API.
// Get the embedded attachment at |index| in |document|. Note that the returned
// attachment handle is only valid while |document| is open.
//
//   document - handle to a document.
//   index    - the index of the requested embedded file.
//
// Returns the handle to the attachment object, or NULL on failure.

type TFPDFDoc_GetAttachment = function(document: FPDF_DOCUMENT; index: Integer): FPDF_ATTACHMENT; cdecl;

// Experimental API.
// Delete the embedded attachment at |index| in |document|. Note that this does
// not remove the attachment data from the PDF file; it simply removes the
// file's entry in the embedded files name tree so that it does not appear in
// the attachment list. This behavior may change in the future.
//
//   document - handle to a document.
//   index    - the index of the embedded file to be deleted.
//
// Returns true if successful.

type TFPDFDoc_DeleteAttachment = function(document: FPDF_DOCUMENT; index: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Get the name of the |attachment| file. |buffer| is only modified if |buflen|
// is longer than the length of the file name. On errors, |buffer| is unmodified
// and the returned length is 0.
//
//   attachment - handle to an attachment.
//   buffer     - buffer for holding the file name, encoded in UTF-16LE.
//   buflen     - length of the buffer in bytes.
//
// Returns the length of the file name in bytes.

type TFPDFAttachment_GetName = function(attachment: FPDF_ATTACHMENT; var buffer: FPDF_WCHAR; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Check if the params dictionary of |attachment| has |key| as a key.
//
//   attachment - handle to an attachment.
//   key        - the key to look for, encoded in UTF-8.
//
// Returns true if |key| exists.

type TFPDFAttachment_HasKey = function(attachment: FPDF_ATTACHMENT; key: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Get the type of the value corresponding to |key| in the params dictionary of
// the embedded |attachment|.
//
//   attachment - handle to an attachment.
//   key        - the key to look for, encoded in UTF-8.
//
// Returns the type of the dictionary value.

type TFPDFAttachment_GetValueType = function(attachment: FPDF_ATTACHMENT; key: FPDF_BYTESTRING): FPDF_OBJECT_TYPE; cdecl;

// Experimental API.
// Set the string value corresponding to |key| in the params dictionary of the
// embedded file |attachment|, overwriting the existing value if any. The value
// type should be FPDF_OBJECT_STRING after this function call succeeds.
//
//   attachment - handle to an attachment.
//   key        - the key to the dictionary entry, encoded in UTF-8.
//   value      - the string value to be set, encoded in UTF-16LE.
//
// Returns true if successful.

type TFPDFAttachment_SetStringValue = function(attachment: FPDF_ATTACHMENT; key, value: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Get the string value corresponding to |key| in the params dictionary of the
// embedded file |attachment|. |buffer| is only modified if |buflen| is longer
// than the length of the string value. Note that if |key| does not exist in the
// dictionary or if |key|'s corresponding value in the dictionary is not a
// string (i.e. the value is not of type FPDF_OBJECT_STRING or
// FPDF_OBJECT_NAME), then an empty string would be copied to |buffer| and the
// return value would be 2. On other errors, nothing would be added to |buffer|
// and the return value would be 0.
//
//   attachment - handle to an attachment.
//   key        - the key to the requested string value, encoded in UTF-8.
//   buffer     - buffer for holding the string value encoded in UTF-16LE.
//   buflen     - length of the buffer in bytes.
//
// Returns the length of the dictionary value string in bytes.

type TFPDFAttachment_GetStringValue = function(attachment: FPDF_ATTACHMENT; key: FPDF_BYTESTRING; var buffer: FPDF_WCHAR; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Set the file data of |attachment|, overwriting the existing file data if any.
// The creation date and checksum will be updated, while all other dictionary
// entries will be deleted. Note that only contents with |len| smaller than
// INT_MAX is supported.
//
//   attachment - handle to an attachment.
//   contents   - buffer holding the file data to write to |attachment|.
//   len        - length of file data in bytes.
//
// Returns true if successful.

type TFPDFAttachment_SetFile = function(attachment: FPDF_ATTACHMENT; document: FPDF_DOCUMENT; contents: Pointer; len: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get the file data of |attachment|. |buffer| is only modified if |buflen| is
// longer than the length of the file. On errors, |buffer| is unmodified and the
// returned length is 0.
//
//   attachment - handle to an attachment.
//   buffer     - buffer for holding the file data from |attachment|.
//   buflen     - length of the buffer in bytes.
//
// Returns the length of the file.

type TFPDFAttachment_GetFile = function(attachment: FPDF_ATTACHMENT; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

implementation

end.