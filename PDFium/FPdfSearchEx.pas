// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
 
// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfSearchEx;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Get the character index in |text_page| internal character list.
//
//   text_page  - a text page information structure.
//   nTextIndex - index of the text returned from FPDFText_GetText().
//
// Returns the index of the character in internal character list. -1 for error.

type TFPDFText_GetCharIndexFromTextIndex = function(text_page: FPDF_TEXTPAGE; nTextIndex: Integer): Integer; cdecl;

// Get the text index in |text_page| internal character list.
//
//   text_page  - a text page information structure.
//   nCharIndex - index of the character in internal character list.
//
// Returns the index of the text returned from FPDFText_GetText(). -1 for error.

type TFPDFText_GetTextIndexFromCharIndex = function(text_page: FPDF_TEXTPAGE; nCharIndex: Integer): Integer; cdecl;

implementation

end.