// Copyright 2017 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

unit FPdfAnnot;

interface

uses FPdfView, FPdfDoc;

const
  FPDF_ANNOT_UNKNOWN = 0;
  FPDF_ANNOT_TEXT = 1;
  FPDF_ANNOT_LINK = 2;
  FPDF_ANNOT_FREETEXT = 3;
  FPDF_ANNOT_LINE = 4;
  FPDF_ANNOT_SQUARE = 5;
  FPDF_ANNOT_CIRCLE = 6;
  FPDF_ANNOT_POLYGON = 7;
  FPDF_ANNOT_POLYLINE = 8;
  FPDF_ANNOT_HIGHLIGHT = 9;
  FPDF_ANNOT_UNDERLINE = 10;
  FPDF_ANNOT_SQUIGGLY = 11;
  FPDF_ANNOT_STRIKEOUT = 12;
  FPDF_ANNOT_STAMP = 13;
  FPDF_ANNOT_CARET = 14;
  FPDF_ANNOT_INK = 15;
  FPDF_ANNOT_POPUP = 16;
  FPDF_ANNOT_FILEATTACHMENT = 17;
  FPDF_ANNOT_SOUND = 18;
  FPDF_ANNOT_MOVIE = 19;
  FPDF_ANNOT_WIDGET = 20;
  FPDF_ANNOT_SCREEN = 21;
  FPDF_ANNOT_PRINTERMARK = 22;
  FPDF_ANNOT_TRAPNET = 23;
  FPDF_ANNOT_WATERMARK = 24;
  FPDF_ANNOT_THREED = 25;
  FPDF_ANNOT_RICHMEDIA = 26;
  FPDF_ANNOT_XFAWIDGET = 27;

// Refer to PDF Reference (6th edition) table 8.16 for all annotation flags.
  FPDF_ANNOT_FLAG_NONE = 0;
  FPDF_ANNOT_FLAG_INVISIBLE = 1 shl 0;
  FPDF_ANNOT_FLAG_HIDDEN = 1 shl 1;
  FPDF_ANNOT_FLAG_PRINT = 1 shl 2;
  FPDF_ANNOT_FLAG_NOZOOM = 1 shl 3;
  FPDF_ANNOT_FLAG_NOROTATE = 1 shl 4;
  FPDF_ANNOT_FLAG_NOVIEW = 1 shl 5;
  FPDF_ANNOT_FLAG_READONLY = 1 shl 6;
  FPDF_ANNOT_FLAG_LOCKED = 1 shl 7;
  FPDF_ANNOT_FLAG_TOGGLENOVIEW = 1 shl 8;

  FPDF_ANNOT_APPEARANCEMODE_NORMAL = 0;
  FPDF_ANNOT_APPEARANCEMODE_ROLLOVER = 1;
  FPDF_ANNOT_APPEARANCEMODE_DOWN = 2;
  FPDF_ANNOT_APPEARANCEMODE_COUNT = 3;

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

// Refer to PDF Reference version 1.7 table 8.70 for field flags common to all
// interactive form field types.
  FPDF_FORMFLAG_NONE = 0;
  FPDF_FORMFLAG_READONLY = 1 shl 0;
  FPDF_FORMFLAG_REQUIRED = 1 shl 1;
  FPDF_FORMFLAG_NOEXPORT = 1 shl 2;

// Refer to PDF Reference version 1.7 table 8.77 for field flags specific to
// interactive form text fields.
  FPDF_FORMFLAG_TEXT_MULTILINE = 1 shl 12;

// Refer to PDF Reference version 1.7 table 8.79 for field flags specific to
// interactive form choice fields.
  FPDF_FORMFLAG_CHOICE_COMBO = 1 shl 17;
  FPDF_FORMFLAG_CHOICE_EDIT = 1 shl 18;

type
  FPDFANNOT_COLORTYPE = (FPDFANNOT_COLORTYPE_Color {= 0}, FPDFANNOT_COLORTYPE_InteriorColor);

// Experimental API.
// Check if an annotation subtype is currently supported for creation.
// Currently supported subtypes: circle, highlight, ink, popup, square,
// squiggly, stamp, strikeout, text, and underline.
//
//   subtype   - the subtype to be checked.
//
// Returns true if this subtype supported.

type TFPDFAnnot_IsSupportedSubtype = function(subtype: FPDF_ANNOTATION_SUBTYPE): FPDF_BOOL; cdecl;

// Experimental API.
// Create an annotation in |page| of the subtype |subtype|. If the specified
// subtype is illegal or unsupported, then a new annotation will not be created.
// Must call FPDFPage_CloseAnnot() when the annotation returned by this
// function is no longer needed.
//
//   page      - handle to a page.
//   subtype   - the subtype of the new annotation.
//
// Returns a handle to the new annotation object, or NULL on failure.

type TFPDFPage_CreateAnnot = function(page: FPDF_PAGE; subtype: FPDF_ANNOTATION_SUBTYPE): FPDF_ANNOTATION; cdecl;

// Experimental API.
// Get the number of annotations in |page|.
//
//   page   - handle to a page.
//
// Returns the number of annotations in |page|.

type TFPDFPage_GetAnnotCount = function(page: FPDF_PAGE): Integer; cdecl;

// Experimental API.
// Get annotation in |page| at |index|. Must call FPDFPage_CloseAnnot() when the
// annotation returned by this function is no longer needed.
//
//   page  - handle to a page.
//   index - the index of the annotation.
//
// Returns a handle to the annotation object, or NULL on failure.

type TFPDFPage_GetAnnot = function(page: FPDF_PAGE; index: Integer): FPDF_ANNOTATION; cdecl;

// Experimental API.
// Get the index of |annot| in |page|. This is the opposite of
// FPDFPage_GetAnnot().
//
//   page  - handle to the page that the annotation is on.
//   annot - handle to an annotation.
//
// Returns the index of |annot|, or -1 on failure.

type TFPDFPage_GetAnnotIndex = function(page: FPDF_PAGE; annot: FPDF_ANNOTATION): Integer; cdecl;

// Experimental API.
// Close an annotation. Must be called when the annotation returned by
// FPDFPage_CreateAnnot() or FPDFPage_GetAnnot() is no longer needed. This
// function does not remove the annotation from the document.
//
//   annot  - handle to an annotation.

type TFPDFPage_CloseAnnot = procedure(annot: FPDF_ANNOTATION); cdecl;

// Experimental API.
// Remove the annotation in |page| at |index|.
//
//   page  - handle to a page.
//   index - the index of the annotation.
//
// Returns true if successful.

type TFPDFPage_RemoveAnnot = function(page: FPDF_PAGE; index: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Get the subtype of an annotation.
//
//   annot  - handle to an annotation.
//
// Returns the annotation subtype.

type TFPDFAnnot_GetSubtype = function(annot: FPDF_ANNOTATION): FPDF_ANNOTATION_SUBTYPE; cdecl;

// Experimental API.
// Check if an annotation subtype is currently supported for object extraction,
// update, and removal.
// Currently supported subtypes: ink and stamp.
//
//   subtype   - the subtype to be checked.
//
// Returns true if this subtype supported.

type TFPDFAnnot_IsObjectSupportedSubtype = function(subtype: FPDF_ANNOTATION_SUBTYPE): FPDF_BOOL; cdecl;

// Experimental API.
// Update |obj| in |annot|. |obj| must be in |annot| already and must have
// been retrieved by FPDFAnnot_GetObject(). Currently, only ink and stamp
// annotations are supported by this API. Also note that only path, image, and
// text objects have APIs for modification; see FPDFPath_*(), FPDFText_*(), and
// FPDFImageObj_*().
//
//   annot  - handle to an annotation.
//   obj    - handle to the object that |annot| needs to update.
//
// Return true if successful.

type TFPDFAnnot_UpdateObject = function(annot: FPDF_ANNOTATION; obj: FPDF_PAGEOBJECT): FPDF_BOOL; cdecl;

// Experimental API.
// Add |obj| to |annot|. |obj| must have been created by
// FPDFPageObj_CreateNew{Path|Rect}() or FPDFPageObj_New{Text|Image}Obj(), and
// will be owned by |annot|. Note that an |obj| cannot belong to more than one
// |annot|. Currently, only ink and stamp annotations are supported by this API.
// Also note that only path, image, and text objects have APIs for creation.
//
//   annot  - handle to an annotation.
//   obj    - handle to the object that is to be added to |annot|.
//
// Return true if successful.

type TFPDFAnnot_AppendObject = function(annot: FPDF_ANNOTATION; obj: FPDF_PAGEOBJECT): FPDF_BOOL; cdecl;

// Experimental API.
// Get the total number of objects in |annot|, including path objects, text
// objects, external objects, image objects, and shading objects.
//
//   annot  - handle to an annotation.
//
// Returns the number of objects in |annot|.

type TFPDFAnnot_GetObjectCount = function(annot: FPDF_ANNOTATION): Integer; cdecl;

// Experimental API.
// Get the object in |annot| at |index|.
//
//   annot  - handle to an annotation.
//   index  - the index of the object.
//
// Return a handle to the object, or NULL on failure.

type TFPDFAnnot_GetObject = function(annot: FPDF_ANNOTATION; index: Integer): FPDF_PAGEOBJECT; cdecl;

// Experimental API.
// Remove the object in |annot| at |index|.
//
//   annot  - handle to an annotation.
//   index  - the index of the object to be removed.
//
// Return true if successful.

type TFPDFAnnot_RemoveObject = function(annot: FPDF_ANNOTATION; index: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Set the color of an annotation. Fails when called on annotations with
// appearance streams already defined; instead use
// FPDFPath_Set{Stroke|Fill}Color().
//
//   annot    - handle to an annotation.
//   type     - type of the color to be set.
//   R, G, B  - buffer to hold the RGB value of the color. Ranges from 0 to 255.
//   A        - buffer to hold the opacity. Ranges from 0 to 255.
//
// Returns true if successful.

type TFPDFAnnot_SetColor = function(annot: FPDF_ANNOTATION; type_: FPDFANNOT_COLORTYPE; R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Get the color of an annotation. If no color is specified, default to yellow
// for highlight annotation, black for all else. Fails when called on
// annotations with appearance streams already defined; instead use
// FPDFPath_Get{Stroke|Fill}Color().
//
//   annot    - handle to an annotation.
//   type     - type of the color requested.
//   R, G, B  - buffer to hold the RGB value of the color. Ranges from 0 to 255.
//   A        - buffer to hold the opacity. Ranges from 0 to 255.
//
// Returns true if successful.

type TFPDFAnnot_GetColor = function(annot: FPDF_ANNOTATION; type_: FPDFANNOT_COLORTYPE; var R, G, B, A: LongWord): FPDF_BOOL; cdecl;

// Experimental API.
// Check if the annotation is of a type that has attachment points
// (i.e. quadpoints). Quadpoints are the vertices of the rectangle that
// encompasses the texts affected by the annotation. They provide the
// coordinates in the page where the annotation is attached. Only text markup
// annotations (i.e. highlight, strikeout, squiggly, and underline) and link
// annotations have quadpoints.
//
//   annot  - handle to an annotation.
//
// Returns true if the annotation is of a type that has quadpoints, false
// otherwise.

type TFPDFAnnot_HasAttachmentPoints = function(annot: FPDF_ANNOTATION): FPDF_BOOL; cdecl;

// Experimental API.
// Replace the attachment points (i.e. quadpoints) set of an annotation at
// |quad_index|. This index needs to be within the result of
// FPDFAnnot_CountAttachmentPoints().
// If the annotation's appearance stream is defined and this annotation is of a
// type with quadpoints, then update the bounding box too if the new quadpoints
// define a bigger one.
//
//   annot       - handle to an annotation.
//   quad_index  - index of the set of quadpoints.
//   quad_points - the quadpoints to be set.
//
// Returns true if successful.

type TFPDFAnnot_SetAttachmentPoints = function(annot: FPDF_ANNOTATION; quad_index: size_t; var quad_points: FS_QUADPOINTSF): FPDF_BOOL; cdecl;

// Experimental API.
// Append to the list of attachment points (i.e. quadpoints) of an annotation.
// If the annotation's appearance stream is defined and this annotation is of a
// type with quadpoints, then update the bounding box too if the new quadpoints
// define a bigger one.
//
//   annot       - handle to an annotation.
//   quad_points - the quadpoints to be set.
//
// Returns true if successful.

type TFPDFAnnot_AppendAttachmentPoints = function(annot: FPDF_ANNOTATION; {const} var quad_points: FS_QUADPOINTSF): FPDF_BOOL; cdecl;

// Experimental API.
// Get the number of sets of quadpoints of an annotation.
//
//   annot  - handle to an annotation.
//
// Returns the number of sets of quadpoints, or 0 on failure.

type TFPDFAnnot_CountAttachmentPoints = function(annot: FPDF_ANNOTATION): size_t; cdecl;

// Experimental API.
// Get the attachment points (i.e. quadpoints) of an annotation.
//
//   annot       - handle to an annotation.
//   quad_index  - index of the set of quadpoints.
//   quad_points - receives the quadpoints; must not be NULL.
//
// Returns true if successful.

type TFPDFAnnot_GetAttachmentPoints = function(annot: FPDF_ANNOTATION; quad_index: size_t; var quad_points: FS_QUADPOINTSF): FPDF_BOOL; cdecl;

// Experimental API.
// Set the annotation rectangle defining the location of the annotation. If the
// annotation's appearance stream is defined and this annotation is of a type
// without quadpoints, then update the bounding box too if the new rectangle
// defines a bigger one.
//
//   annot  - handle to an annotation.
//   rect   - the annotation rectangle to be set.
//
// Returns true if successful.

type TFPDFAnnot_SetRect = function(annot: FPDF_ANNOTATION; var rect: FS_RECTF): FPDF_BOOL; cdecl;

// Experimental API.
// Get the annotation rectangle defining the location of the annotation.
//
//   annot  - handle to an annotation.
//   rect   - receives the rectangle; must not be NULL.
//
// Returns true if successful.

type TFPDFAnnot_GetRect = function(annot: FPDF_ANNOTATION; var rect: FS_RECTF): FPDF_BOOL; cdecl;

// Experimental API.
// Check if |annot|'s dictionary has |key| as a key.
//
//   annot  - handle to an annotation.
//   key    - the key to look for, encoded in UTF-8.
//
// Returns true if |key| exists.

type TFPDFAnnot_HasKey = function(annot: FPDF_ANNOTATION; key: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Get the type of the value corresponding to |key| in |annot|'s dictionary.
//
//   annot  - handle to an annotation.
//   key    - the key to look for, encoded in UTF-8.
//
// Returns the type of the dictionary value.

type TFPDFAnnot_GetValueType = function(annot: FPDF_ANNOTATION; key: FPDF_BYTESTRING): FPDF_OBJECT_TYPE; cdecl;

// Experimental API.
// Set the string value corresponding to |key| in |annot|'s dictionary,
// overwriting the existing value if any. The value type would be
// FPDF_OBJECT_STRING after this function call succeeds.
//
//   annot  - handle to an annotation.
//   key    - the key to the dictionary entry to be set, encoded in UTF-8.
//   value  - the string value to be set, encoded in UTF-16LE.
//
// Returns true if successful.

type TFPDFAnnot_SetStringValue = function(annot: FPDF_ANNOTATION; key, value: FPDF_BYTESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Get the string value corresponding to |key| in |annot|'s dictionary. |buffer|
// is only modified if |buflen| is longer than the length of contents. Note that
// if |key| does not exist in the dictionary or if |key|'s corresponding value
// in the dictionary is not a string (i.e. the value is not of type
// FPDF_OBJECT_STRING or FPDF_OBJECT_NAME), then an empty string would be copied
// to |buffer| and the return value would be 2. On other errors, nothing would
// be added to |buffer| and the return value would be 0.
//
//   annot  - handle to an annotation.
//   key    - the key to the requested dictionary entry, encoded in UTF-8.
//   buffer - buffer for holding the value string, encoded in UTF-16LE.
//   buflen - length of the buffer in bytes.
//
// Returns the length of the string value in bytes.

type TFPDFAnnot_GetStringValue = function(annot: FPDF_ANNOTATION; key: FPDF_BYTESTRING; buffer: PWideChar; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Get the float value corresponding to |key| in |annot|'s dictionary. Writes
// value to |value| and returns True if |key| exists in the dictionary and
// |key|'s corresponding value is a number (FPDF_OBJECT_NUMBER), False
// otherwise.
//
//   annot  - handle to an annotation.
//   key    - the key to the requested dictionary entry, encoded in UTF-8.
//   value  - receives the value, must not be NULL.
//
// Returns True if value found, False otherwise.

type TFPDFAnnot_GetNumberValue = function(annot: FPDF_ANNOTATION; key: FPDF_BYTESTRING; var value: Single): FPDF_BOOL; cdecl;

// Experimental API.
// Set the AP (appearance string) in |annot|'s dictionary for a given
// |appearanceMode|.
//
//   annot          - handle to an annotation.
//   appearanceMode - the appearance mode (normal, rollover or down) for which
//                    to get the AP.
//   value          - the string value to be set, encoded in UTF-16LE. If
//                    nullptr is passed, the AP is cleared for that mode. If the
//                    mode is Normal, APs for all modes are cleared.
//
// Returns true if successful.

type TFPDFAnnot_SetAP = function(annot: FPDF_ANNOTATION; appearanceMode: FPDF_ANNOT_APPEARANCEMODE; value: FPDF_WIDESTRING): FPDF_BOOL; cdecl;

// Experimental API.
// Get the AP (appearance string) from |annot|'s dictionary for a given
// |appearanceMode|.
// |buffer| is only modified if |buflen| is large enough to hold the whole AP
// string. If |buflen| is smaller, the total size of the AP is still returned,
// but nothing is copied.
// If there is no appearance stream for |annot| in |appearanceMode|, an empty
// string is written to |buf| and 2 is returned.
// On other errors, nothing is written to |buffer| and 0 is returned.
//
//   annot          - handle to an annotation.
//   appearanceMode - the appearance mode (normal, rollover or down) for which
//                    to get the AP.
//   buffer         - buffer for holding the value string, encoded in UTF-16LE.
//   buflen         - length of the buffer in bytes.
//
// Returns the length of the string value in bytes

type TFPDFAnnot_GetAP = function(annot: FPDF_ANNOTATION; appearanceMode: FPDF_ANNOT_APPEARANCEMODE; buffer: PWideChar; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Get the annotation corresponding to |key| in |annot|'s dictionary. Common
// keys for linking annotations include "IRT" and "Popup". Must call
// FPDFPage_CloseAnnot() when the annotation returned by this function is no
// longer needed.
//
//   annot  - handle to an annotation.
//   key    - the key to the requested dictionary entry, encoded in UTF-8.
//
// Returns a handle to the linked annotation object, or NULL on failure.

type TFPDFAnnot_GetLinkedAnnot = function(annot: FPDF_ANNOTATION; key: FPDF_BYTESTRING): FPDF_ANNOTATION; cdecl;

// Experimental API.
// Get the annotation flags of |annot|.
//
//   annot    - handle to an annotation.
//
// Returns the annotation flags.

type TFPDFAnnot_GetFlags = function(annot: FPDF_ANNOTATION): Integer; cdecl;

// Experimental API.
// Set the |annot|'s flags to be of the value |flags|.
//
//   annot      - handle to an annotation.
//   flags      - the flag values to be set.
//
// Returns true if successful.

type TFPDFAnnot_SetFlags = function(annot: FPDF_ANNOTATION; flags: Integer): FPDF_BOOL; cdecl;

// Experimental API.
// Get the annotation flags of |annot|.
//
//    hHandle     -   handle to the form fill module, returned by
//                    FPDFDOC_InitFormFillEnvironment().
//    annot       -   handle to an interactive form annotation.
//
// Returns the annotation flags specific to interactive forms.

type TFPDFAnnot_GetFormFieldFlags = function(handle: FPDF_FORMHANDLE; annot: FPDF_ANNOTATION): Integer; cdecl;

// Experimental API.
// Retrieves an interactive form annotation whose rectangle contains a given
// point on a page. Must call FPDFPage_CloseAnnot() when the annotation returned
// is no longer needed.
//
//
//    hHandle     -   handle to the form fill module, returned by
//                    FPDFDOC_InitFormFillEnvironment().
//    page        -   handle to the page, returned by FPDF_LoadPage function.
//    page_x      -   X position in PDF "user space".
//    page_y      -   Y position in PDF "user space".
//
// Returns the interactive form annotation whose rectangle contains the given
// coordinates on the page. If there is no such annotation, return NULL.

type TFPDFAnnot_GetFormFieldAtPoint = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; page_x, page_y: Double): FPDF_ANNOTATION; cdecl;

// Experimental API.
// Get the number of options in the |annot|'s "Opt" dictionary. Intended for
// use with listbox and combobox widget annotations.
//
//   hHandle - handle to the form fill module, returned by
//             FPDFDOC_InitFormFillEnvironment.
//   annot   - handle to an annotation.
//
// Returns the number of options in "Opt" dictionary on success. Return value
// will be -1 if annotation does not have an "Opt" dictionary or other error.

type TFPDFAnnot_GetOptionCount = function(hHandle: FPDF_FORMHANDLE; annot: FPDF_ANNOTATION): Integer; cdecl;

// Experimental API.
// Get the string value for the label of the option at |index| in |annot|'s
// "Opt" dictionary. Intended for use with listbox and combobox widget
// annotations. |buffer| is only modified if |buflen| is longer than the length
// of contents. If index is out of range or in case of other error, nothing
// will be added to |buffer| and the return value will be 0. Note that
// return value of empty string is 2 for "\0\0".
//
//   hHandle - handle to the form fill module, returned by
//             FPDFDOC_InitFormFillEnvironment.
//   annot   - handle to an annotation.
//   index   - numeric index of the option in the "Opt" array
//   buffer  - buffer for holding the value string, encoded in UTF-16LE.
//   buflen  - length of the buffer in bytes.
//
// Returns the length of the string value in bytes.
// If |annot| does not have an "Opt" array, |index| is out of range or if any
// other error occurs, returns 0.

type TFPDFAnnot_GetOptionLabel = function(hHandle: FPDF_FORMHANDLE; annot: FPDF_ANNOTATION; index: Integer; buffer: PWideChar; buflen: LongWord): LongWord; cdecl;

// Experimental API.
// Get the float value of the font size for an |annot| with variable text.
// If 0, the font is to be auto-sized: its size is computed as a function of
// the height of the annotation rectangle.
//
//   hHandle - handle to the form fill module, returned by
//             FPDFDOC_InitFormFillEnvironment.
//   annot   - handle to an annotation.
//   value   - Required. Float which will be set to font size on success.
//
// Returns true if the font size was set in |value|, false on error or if
// |value| not provided.

type TFPDFAnnot_GetFontSize = function(hHandle: FPDF_FORMHANDLE; annot: FPDF_ANNOTATION; var value: Single): FPDF_BOOL; cdecl;

// Experimental API.
// Determine if |annot| is a form widget that is checked. Intended for use with
// checkbox and radio button widgets.
//
//   hHandle - handle to the form fill module, returned by
//             FPDFDOC_InitFormFillEnvironment.
//   annot   - handle to an annotation.
//
// Returns true if |annot| is a form widget and is checked, false otherwise.

type TFPDFAnnot_IsChecked = function(hHandle: FPDF_FORMHANDLE; annot: FPDF_ANNOTATION): FPDF_BOOL; cdecl;

implementation

end.