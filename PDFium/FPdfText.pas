// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfText;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// Function: FPDFText_LoadPage
//          Prepare information about all characters in a page.
// Parameters:
//          page    -   Handle to the page. Returned by FPDF_LoadPage function
//          (in FPDFVIEW module).
// Return value:
//          A handle to the text page information structure.
//          NULL if something goes wrong.
// Comments:
//          Application must call FPDFText_ClosePage to release the text page
//          information.
//

type TFPDFText_LoadPage = function(page: FPDF_PAGE): FPDF_TEXTPAGE; cdecl;

// Function: FPDFText_ClosePage
//          Release all resources allocated for a text page information
//          structure.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
// Return Value:
//          None.
//

type TFPDFText_ClosePage = procedure(text_page: FPDF_TEXTPAGE); cdecl;

// Function: FPDFText_CountChars
//          Get number of characters in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
// Return value:
//          Number of characters in the page. Return -1 for error.
//          Generated characters, like additional space characters, new line
//          characters, are also counted.
// Comments:
//          Characters in a page form a "stream", inside the stream, each
//          character has an index.
//          We will use the index parameters in many of FPDFTEXT functions. The
//          first character in the page
//          has an index value of zero.
//

type TFPDFText_CountChars = function(text_page: FPDF_TEXTPAGE): Integer; cdecl;

// Function: FPDFText_GetUnicode
//          Get Unicode of a character in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return value:
//          The Unicode of the particular character.
//          If a character is not encoded in Unicode and Foxit engine can't
//          convert to Unicode,
//          the return value will be zero.
//

type TFPDFText_GetUnicode = function(text_page: FPDF_TEXTPAGE; index: Integer): LongWord; cdecl;

// Function: FPDFText_GetFontSize
//          Get the font size of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return value:
//          The font size of the particular character, measured in points (about
//          1/72 inch).
//          This is the typographic size of the font (so called "em size").
//

type TFPDFText_GetFontSize = function(text_page: FPDF_TEXTPAGE; index: Integer): Double; cdecl;

// Experimental API.
// Function: FPDFText_GetFontInfo
//          Get the font name and flags of a particular character.
// Parameters:
//          text_page - Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          index     - Zero-based index of the character.
//          buffer    - A buffer receiving the font name.
//          buflen    - The length of |buffer| in bytes.
//          flags     - Optional pointer to an int receiving the font flags.
//          These flags should be interpreted per PDF spec 1.7 Section 5.7.1
//          Font Descriptor Flags.
// Return value:
//          On success, return the length of the font name, including the
//          trailing NUL character, in bytes. If this length is less than or
//          equal to |length|, |buffer| is set to the font name, |flags| is
//          set to the font flags. |buffer| is in UTF-8 encoding. Return 0 on
//          failure.

type TFPDFText_GetFontInfo = function(text_page: FPDF_TEXTPAGE; index: Integer; buffer: Pointer; buflen: LongWord; var flags: Integer): LongWord; cdecl;

// Experimental API.
// Function: FPDFText_GetCharAngle
//          Get character rotation angle.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return Value:
//          On success, return the angle value in radian. Value will always be
//          greater or equal to 0. If |text_page| is invalid, or if |index| is
//          out of bounds, then return -1.

type TFPDFText_GetCharAngle = function(text_page: FPDF_TEXTPAGE; index: Integer): Double; cdecl;

// Function: FPDFText_GetCharBox
//          Get bounding box of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
//          left        -   Pointer to a double number receiving left position
//          of the character box.
//          right       -   Pointer to a double number receiving right position
//          of the character box.
//          bottom      -   Pointer to a double number receiving bottom position
//          of the character box.
//          top         -   Pointer to a double number receiving top position of
//          the character box.
// Return Value:
//          On success, return TRUE and fill in |left|, |right|, |bottom|, and
//          |top|. If |text_page| is invalid, or if |index| is out of bounds,
//          then return FALSE, and the out parameters remain unmodified.
// Comments:
//          All positions are measured in PDF "user space".
//

type TFPDFText_GetCharBox = function(text_page: FPDF_TEXTPAGE; index: Integer; var left, right, bottom, top: Double): FPDF_BOOL; cdecl;

// Function: FPDFText_GetCharOrigin
//          Get origin of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
//          x           -   Pointer to a double number receiving x coordinate of
//          the character origin.
//          y           -   Pointer to a double number receiving y coordinate of
//          the character origin.
// Return Value:
//          Whether the call succeeded. If false, x and y are unchanged.
// Comments:
//          All positions are measured in PDF "user space".
//

type TFPDFText_GetCharOrigin = function(text_page: FPDF_TEXTPAGE; index: Integer; var x, y: Double): FPDF_BOOL; cdecl;

// Function: FPDFText_GetCharIndexAtPos
//          Get the index of a character at or nearby a certain position on the
//          page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          x           -   X position in PDF "user space".
//          y           -   Y position in PDF "user space".
//          xTolerance  -   An x-axis tolerance value for character hit
//          detection, in point unit.
//          yTolerance  -   A y-axis tolerance value for character hit
//          detection, in point unit.
// Return Value:
//          The zero-based index of the character at, or nearby the point (x,y).
//          If there is no character at or nearby the point, return value will
//          be -1.
//          If an error occurs, -3 will be returned.
//

type TFPDFText_GetCharIndexAtPos = function(text_page: FPDF_TEXTPAGE; x, y, xTolerance, yTolerance: Double): Integer; cdecl;

// Function: FPDFText_GetText
//          Extract unicode text string from the page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          start_index -   Index for the start characters.
//          count       -   Number of characters to be extracted.
//          result      -   A buffer (allocated by application) receiving the
//          extracted unicodes.
//                          The size of the buffer must be able to hold the
//                          number of characters plus a terminator.
// Return Value:
//          Number of characters written into the result buffer, including the
//          trailing terminator.
// Comments:
//          This function ignores characters without unicode information.
//

type TFPDFText_GetText = function(text_page: FPDF_TEXTPAGE; start_index, count: Integer; result: PWideChar): Integer; cdecl;

// Function: FPDFText_CountRects
//          Count number of rectangular areas occupied by a segment of texts.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          start_index -   Index for the start characters.
//          count       -   Number of characters.
// Return value:
//          Number of rectangles. Zero for error.
// Comments:
//          This function, along with FPDFText_GetRect can be used by
//          applications to detect the position
//          on the page for a text segment, so proper areas can be highlighted
//          or something.
//          FPDFTEXT will automatically merge small character boxes into bigger
//          one if those characters
//          are on the same line and use same font settings.
//

type TFPDFText_CountRects = function(text_page: FPDF_TEXTPAGE; start_index, count: Integer): Integer; cdecl;

// Function: FPDFText_GetRect
//          Get a rectangular area from the result generated by
//          FPDFText_CountRects.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          rect_index  -   Zero-based index for the rectangle.
//          left        -   Pointer to a double value receiving the rectangle
//          left boundary.
//          top         -   Pointer to a double value receiving the rectangle
//          top boundary.
//          right       -   Pointer to a double value receiving the rectangle
//          right boundary.
//          bottom      -   Pointer to a double value receiving the rectangle
//          bottom boundary.
// Return Value:
//          On success, return TRUE and fill in |left|, |top|, |right|, and
//          |bottom|. If |text_page| is invalid then return FALSE, and the out
//          parameters remain unmodified. If |text_page| is valid but
//          |rect_index| is out of bounds, then return FALSE and set the out
//          parameters to 0.
//

type TFPDFText_GetRect = function(text_page: FPDF_TEXTPAGE; rect_index: Integer; var left, top, right, bottom: Double): FPDF_BOOL; cdecl;

// Function: FPDFText_GetBoundedText
//          Extract unicode text within a rectangular boundary on the page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          left        -   Left boundary.
//          top         -   Top boundary.
//          right       -   Right boundary.
//          bottom      -   Bottom boundary.
//          buffer      -   A unicode buffer.
//          buflen      -   Number of characters (not bytes) for the buffer,
//          excluding an additional terminator.
// Return Value:
//          If buffer is NULL or buflen is zero, return number of characters
//          (not bytes) of text present within
//          the rectangle, excluding a terminating NUL.  Generally you should
//          pass a buffer at least one larger
//          than this if you want a terminating NUL, which will be provided if
//          space is available.
//          Otherwise, return number of characters copied into the buffer,
//          including the terminating NUL
//          when space for it is available.
// Comment:
//          If the buffer is too small, as much text as will fit is copied into
//          it.
//

type TFPDFText_GetBoundedText = function(text_page: FPDF_TEXTPAGE; left, top, right, bottom: Double; buffer: PWideChar; buflen: Integer): Integer; cdecl;

// Flags used by FPDFText_FindStart function.
//
// If not set, it will not match case by default.
const FPDF_MATCHCASE = $00000001;
// If not set, it will not match the whole word by default.
const FPDF_MATCHWHOLEWORD = $00000002;
// If not set, it will skip past the current match to look for the next match.
const FPDF_CONSECUTIVE = $00000004;

// Function: FPDFText_FindStart
//          Start a search.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
//          findwhat    -   A unicode match pattern.
//          flags       -   Option flags.
//          start_index -   Start from this character. -1 for end of the page.
// Return Value:
//          A handle for the search context. FPDFText_FindClose must be called
//          to release this handle.
//

type TFPDFText_FindStart = function(text_page: FPDF_TEXTPAGE; findwhat: FPDF_WIDESTRING; flags: LongWord; start_index: Integer): FPDF_SCHHANDLE; cdecl;

// Function: FPDFText_FindNext
//          Search in the direction from page start to end.
// Parameters:
//          handle      -   A search context handle returned by
//          FPDFText_FindStart.
// Return Value:
//          Whether a match is found.
//

type TFPDFText_FindNext = function(handle: FPDF_SCHHANDLE): FPDF_BOOL; cdecl;

// Function: FPDFText_FindPrev
//          Search in the direction from page end to start.
// Parameters:
//          handle      -   A search context handle returned by
//          FPDFText_FindStart.
// Return Value:
//          Whether a match is found.
//

type TFPDFText_FindPrev = function(handle: FPDF_SCHHANDLE): FPDF_BOOL; cdecl;

// Function: FPDFText_GetSchResultIndex
//          Get the starting character index of the search result.
// Parameters:
//          handle      -   A search context handle returned by
//          FPDFText_FindStart.
// Return Value:
//          Index for the starting character.
//

type TFPDFText_GetSchResultIndex = function(handle: FPDF_SCHHANDLE): Integer; cdecl;

// Function: FPDFText_GetSchCount
//          Get the number of matched characters in the search result.
// Parameters:
//          handle      -   A search context handle returned by
//          FPDFText_FindStart.
// Return Value:
//          Number of matched characters.
//

type TFPDFText_GetSchCount = function(handle: FPDF_SCHHANDLE): Integer; cdecl;

// Function: FPDFText_FindClose
//          Release a search context.
// Parameters:
//          handle      -   A search context handle returned by
//          FPDFText_FindStart.
// Return Value:
//          None.
//

type TFPDFText_FindClose = procedure(handle: FPDF_SCHHANDLE); cdecl;

// Function: FPDFLink_LoadWebLinks
//          Prepare information about weblinks in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//          Returned by FPDFText_LoadPage function.
// Return Value:
//          A handle to the page's links information structure.
//          NULL if something goes wrong.
// Comments:
//          Weblinks are those links implicitly embedded in PDF pages. PDF also
//          has a type of
//          annotation called "link", FPDFTEXT doesn't deal with that kind of
//          link.
//          FPDFTEXT weblink feature is useful for automatically detecting links
//          in the page
//          contents. For example, things like "http://www.foxitsoftware.com"
//          will be detected,
//          so applications can allow user to click on those characters to
//          activate the link,
//          even the PDF doesn't come with link annotations.
//
//          FPDFLink_CloseWebLinks must be called to release resources.
//

type TFPDFLink_LoadWebLinks = function(text_page: FPDF_TEXTPAGE): FPDF_PAGELINK; cdecl;

// Function: FPDFLink_CountWebLinks
//          Count number of detected web links.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
// Return Value:
//          Number of detected web links.
//

type TFPDFLink_CountWebLinks = function(link_page: FPDF_PAGELINK): Integer; cdecl;

// Function: FPDFLink_GetURL
//          Fetch the URL information for a detected web link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
//          buffer      -   A unicode buffer.
//          buflen      -   Number of characters (not bytes) for the buffer,
//          including an additional terminator.
// Return Value:
//          If buffer is NULL or buflen is zero, return number of characters
//          (not bytes and an additional terminator is also counted) needed,
//          otherwise, return number of characters copied into the buffer.
//

type TFPDFLink_GetURL = function(link_page: FPDF_PAGELINK; link_index: Integer; buffer: PWideChar; buflen: Integer): Integer; cdecl;

// Function: FPDFLink_CountRects
//          Count number of rectangular areas for the link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
// Return Value:
//          Number of rectangular areas for the link.
//

type TFPDFLink_CountRects = function(link_page: FPDF_PAGELINK; link_index: Integer): Integer; cdecl;

// Function: FPDFLink_GetRect
//          Fetch the boundaries of a rectangle for a link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
//          rect_index  -   Zero-based index for a rectangle.
//          left        -   Pointer to a double value receiving the rectangle
//          left boundary.
//          top         -   Pointer to a double value receiving the rectangle
//          top boundary.
//          right       -   Pointer to a double value receiving the rectangle
//          right boundary.
//          bottom      -   Pointer to a double value receiving the rectangle
//          bottom boundary.
// Return Value:
//          On success, return TRUE and fill in |left|, |top|, |right|, and
//          |bottom|. If |link_page| is invalid or if |link_index| does not
//          correspond to a valid link, then return FALSE, and the out
//          parameters remain unmodified.
//

type TFPDFLink_GetRect = function(link_page: FPDF_PAGELINK; link_index, rect_index: Integer; var left, top, right, bottom: Double): FPDF_BOOL; cdecl;

// Experimental API.
// Function: FPDFLink_GetTextRange
//          Fetch the start char index and char count for a link.
// Parameters:
//          link_page         -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index        -   Zero-based index for the link.
//          start_char_index  -   pointer to int receiving the start char index
//          char_count        -   pointer to int receiving the char count
// Return Value:
//          On success, return TRUE and fill in |start_char_index| and
//          |char_count|. if |link_page| is invalid or if |link_index| does
//          not correspond to a valid link, then return FALSE and the out
//          parameters remain unmodified.
//

type TFPDFLink_GetTextRange = function(link_page: FPDF_PAGELINK; link_index: Integer; out start_char_index: Integer; out char_count: Integer): FPDF_BOOL; cdecl;

// Function: FPDFLink_CloseWebLinks
//          Release resources used by weblink feature.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
// Return Value:
//          None.
//

type TFPDFLink_CloseWebLinks = procedure(link_page: FPDF_PAGELINK); cdecl;

implementation

end.