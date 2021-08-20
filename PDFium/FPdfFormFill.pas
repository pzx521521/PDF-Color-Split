// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfFormFill;

{$WEAKPACKAGEUNIT}

interface

uses FPdfView;

// These values are return values for a public API, so should not be changed
// other than the count when adding new values.

const
  FORMTYPE_NONE = 0;           // Document contains no forms
  FORMTYPE_ACRO_FORM = 1;      // Forms are specified using AcroForm spec
  FORMTYPE_XFA_FULL = 2;       // Forms are specified using the entire XFA spec
  FORMTYPE_XFA_FOREGROUND = 3; // Forms are specified using the XFAF subset of XFA spec
  FORMTYPE_COUNT = 4;          // The number of form types

  JSPLATFORM_ALERT_BUTTON_OK = 0;           // OK button
  JSPLATFORM_ALERT_BUTTON_OKCANCEL = 1;     // OK & Cancel buttons
  JSPLATFORM_ALERT_BUTTON_YESNO = 2;        // Yes & No buttons
  JSPLATFORM_ALERT_BUTTON_YESNOCANCEL = 3;  // Yes, No & Cancel buttons
  JSPLATFORM_ALERT_BUTTON_DEFAULT = JSPLATFORM_ALERT_BUTTON_OK;

  JSPLATFORM_ALERT_ICON_ERROR = 0;     // Error
  JSPLATFORM_ALERT_ICON_WARNING = 1;   // Warning
  JSPLATFORM_ALERT_ICON_QUESTION = 2;  // Question
  JSPLATFORM_ALERT_ICON_STATUS = 3;    // Status
  JSPLATFORM_ALERT_ICON_ASTERISK = 4;  // Asterisk
  JSPLATFORM_ALERT_ICON_DEFAULT = JSPLATFORM_ALERT_ICON_ERROR;

  JSPLATFORM_ALERT_RETURN_OK = 1;      // OK
  JSPLATFORM_ALERT_RETURN_CANCEL = 2;  // Cancel
  JSPLATFORM_ALERT_RETURN_NO = 3;      // No
  JSPLATFORM_ALERT_RETURN_YES = 4;     // Yes

  JSPLATFORM_BEEP_ERROR = 0;     // Error
  JSPLATFORM_BEEP_WARNING = 1;   // Warning
  JSPLATFORM_BEEP_QUESTION = 2;  // Question
  JSPLATFORM_BEEP_STATUS = 3;    // Status
  JSPLATFORM_BEEP_DEFAULT = 4;   // Default

type
  PIPDF_JsPlatform = ^IPDF_JsPlatform;
  app_alert = function(pThis: PIPDF_JsPlatform; Msg: FPDF_WIDESTRING; Title: FPDF_WIDESTRING; Type_, Icon: Integer): Integer; cdecl;
  app_beep = procedure(pThis: PIPDF_JsPlatform; nType: Integer); cdecl;
  app_response = function(pThis: PIPDF_JsPlatform; Question: FPDF_WIDESTRING; Title, Default, cLabel: FPDF_WIDESTRING; bPassword: FPDF_BOOL; response: Pointer; length: Integer): Integer; cdecl;
  Doc_getFilePath = function(pThis: PIPDF_JsPlatform; filePath: Pointer; length: Integer): Integer; cdecl;
  Doc_mail = procedure(pThis: PIPDF_JsPlatform; mailData: Pointer; length: Integer; bUI: FPDF_BOOL; To_, Subject, CC, BCC, Msg: FPDF_WIDESTRING); cdecl;
  Doc_print = procedure(pThis: PIPDF_JsPlatform; bUI: FPDF_BOOL; nStart, nEnd: Integer; bSilent, bShrinkToFit, bPrintAsImage, bReverse, bAnnotations: FPDF_BOOL); cdecl;
  Doc_submitForm = procedure(pThis: PIPDF_JsPlatform; formData: Pointer; length: Integer; URL: FPDF_WIDESTRING); cdecl;
  Doc_gotoPage = procedure(pThis: PIPDF_JsPlatform; nPageNum: Integer); cdecl;
  Field_browse = function(pThis: PIPDF_JsPlatform; filePath: Pointer; length: Integer): Integer; cdecl;

  IPDF_JSPLATFORM = record
    // Version number of the interface. Currently must be 2.
    version: Integer;

    // Version 1.

    {
     Method: app_alert
               pop up a dialog to show warning or hint.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself.
               Msg         -   A string containing the message to be displayed.
               Title       -   The title of the dialog.
               Type        -   The type of button group, see
                               JSPLATFORM_ALERT_BUTTON_* above.
               nIcon       -   The icon type, see see
                               JSPLATFORM_ALERT_ICON_* above .

     Return Value:
               Option selected by user in dialogue, see
               JSPLATFORM_ALERT_RETURN_* above.
    }

    app_alert: app_alert;

    {
     Method: app_beep
               Causes the system to play a sound.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               nType       -   The sound type, see see JSPLATFORM_BEEP_TYPE_*
                               above.

     Return Value:
               None
    }

    app_beep: app_beep;

    {
     Method: app_response
               Displays a dialog box containing a question and an entry field for
     the user to reply to the question.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               Question    -   The question to be posed to the user.
               Title       -   The title of the dialog box.
               Default     -   A default value for the answer to the question. If
     not specified, no default value is presented.
               cLabel      -   A short string to appear in front of and on the
     same line as the edit text field.
               bPassword   -   If true, indicates that the user's response should
     show as asterisks (*) or bullets (?) to mask the response, which might be
     sensitive information. The default is false.
               response    -   A string buffer allocated by SDK, to receive the
     user's response.
               length      -   The length of the buffer, number of bytes.
     Currently, It's always be 2048.
     Return Value:
           Number of bytes the complete user input would actually require, not
     including trailing zeros, regardless of the value of the length
           parameter or the presence of the response buffer.
     Comments:
           No matter on what platform, the response buffer should be always
     written using UTF-16LE encoding. If a response buffer is
           present and the size of the user input exceeds the capacity of the
     buffer as specified by the length parameter, only the
           first "length" bytes of the user input are to be written to the
     buffer.
    }

    app_response: app_response;

    {
     Method: Doc_getFilePath
               Get the file path of the current document.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               filePath    -   The string buffer to receive the file path. Can be
     NULL.
               length      -   The length of the buffer, number of bytes. Can be
     0.
     Return Value:
           Number of bytes the filePath consumes, including trailing zeros.
     Comments:
           The filePath should be always input in local encoding.

           The return value always indicated number of bytes required for the
     buffer, even when there is
           no buffer specified, or the buffer size is less then required. In this
     case, the buffer will not
           be modified.
    }

    Doc_getFilePath: Doc_getFilePath;

    {
     Method: Doc_mail
               Mails the data buffer as an attachment to all recipients, with or
     without user interaction.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               mailData    -   Pointer to the data buffer to be sent.Can be NULL.
               length      -   The size,in bytes, of the buffer pointed by
     mailData parameter.Can be 0.
               bUI         -   If true, the rest of the parameters are used in a
     compose-new-message window that is displayed to the user. If false, the cTo
     parameter is required and all others are optional.
               To          -   A semicolon-delimited list of recipients for the
     message.
               Subject     -   The subject of the message. The length limit is 64
     KB.
               CC          -   A semicolon-delimited list of CC recipients for
     the message.
               BCC         -   A semicolon-delimited list of BCC recipients for
     the message.
               Msg         -   The content of the message. The length limit is 64
     KB.
     Return Value:
               None.
     Comments:
               If the parameter mailData is NULL or length is 0, the current
     document will be mailed as an attachment to all recipients.
    }

    Doc_mail: Doc_mail;

    {
     Method: Doc_print
               Prints all or a specific number of pages of the document.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself.
               bUI         -   If true, will cause a UI to be presented to the
     user to obtain printing information and confirm the action.
               nStart      -   A 0-based index that defines the start of an
     inclusive range of pages.
               nEnd        -   A 0-based index that defines the end of an
     inclusive page range.
               bSilent     -   If true, suppresses the cancel dialog box while
     the document is printing. The default is false.
               bShrinkToFit    -   If true, the page is shrunk (if necessary) to
     fit within the imageable area of the printed page.
               bPrintAsImage   -   If true, print pages as an image.
               bReverse    -   If true, print from nEnd to nStart.
               bAnnotations    -   If true (the default), annotations are
     printed.
    }

    Doc_print: Doc_print;

    {
     Method: Doc_submitForm
               Send the form data to a specified URL.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               formData    -   Pointer to the data buffer to be sent.
               length      -   The size,in bytes, of the buffer pointed by
     formData parameter.
               URL         -   The URL to send to.
     Return Value:
               None.
    }

    Doc_submitForm: Doc_submitForm;

    {
     Method: Doc_gotoPage
               Jump to a specified page.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself
               nPageNum    -   The specified page number, zero for the first
     page.
     Return Value:
               None.
    }

    Doc_gotoPage: Doc_gotoPage;

    {
     Method: Field_browse
               Show a file selection dialog, and return the selected file path.
     Interface Version:
               1
     Implementation Required:
               yes
     Parameters:
               pThis       -   Pointer to the interface structure itself.
               filePath    -   Pointer to the data buffer to receive the file
     path.Can be NULL.
               length      -   The length of the buffer, number of bytes. Can be
     0.
     Return Value:
           Number of bytes the filePath consumes, including trailing zeros.
     Comments:
           The filePath shoule be always input in local encoding.
    }

    Field_browse: Field_browse;

    // pointer to FPDF_FORMFILLINFO interface.
    m_pFormfillinfo: Pointer;

    // Version 2.

    m_isolate: Pointer;         // Unused in v3, retain for compatibility
    m_v8EmbedderSlot: LongWord; // Unused in v3, retain for compatibility

    // Version 3.
    // Version 3 moves m_Isolate and m_v8EmbedderSlot to FPDF_LIBRARY_CONFIG.
  end;

// Flags for Cursor type
const
  FXCT_ARROW = 0;
  FXCT_NESW  = 1;
  FXCT_NWSE  = 2;
  FXCT_VBEAM = 3;
  FXCT_HBEAM = 4;
  FXCT_HAND  = 5;

// Function signature for the callback function passed to the FFI_SetTimer
// method.
// Parameters:
//          idEvent     -   Identifier of the timer.
// Return value:
//          None.
type
  TimerCallback = procedure(idEvent: Integer); cdecl;

// Declares of a struct type to the local system time.

type
  FPDF_SYSTEMTIME = record
    wYear: Word;         // years since 1900
    wMonth: Word;        // months since January - [0,11]
    wDayOfWeek: Word;    // days since Sunday - [0,6]
    wDay: Word;          // day of the month - [1,31]
    wHour: Word;         // hours since midnight - [0,23]
    wMinute: Word;       // minutes after the hour - [0,59]
    wSecond: Word;       // seconds after the minute - [0,59]
    wMilliseconds: Word; // milliseconds after the second - [0,999]
  end;

  PFPDF_FORMFILLINFO = ^FPDF_FORMFILLINFO;
  Release = procedure(pThis: PFPDF_FORMFILLINFO); cdecl;
  FFI_Invalidate = procedure(pThis: PFPDF_FORMFILLINFO; page: FPDF_PAGE; left, top, right, bottom: Double); cdecl;
  FFI_OutputSelectedRect = procedure(pThis: PFPDF_FORMFILLINFO; page: FPDF_PAGE; left, top, right, bottom: Double); cdecl;
  FFI_SetCursor = procedure(pThis: PFPDF_FORMFILLINFO; nCursorType: Integer); cdecl;
  FFI_SetTimer = function(pThis: PFPDF_FORMFILLINFO; uElapse: Integer; lpTimerFunc: TimerCallback): Integer; cdecl;
  FFI_KillTimer = procedure(pThis: PFPDF_FORMFILLINFO; nTimerID: Integer); cdecl;
  FFI_GetLocalTime = function(pThis: PFPDF_FORMFILLINFO): FPDF_SYSTEMTIME; cdecl;
  FFI_OnChange = procedure(pThis: PFPDF_FORMFILLINFO); cdecl;
  FFI_GetPage = function(pThis: PFPDF_FORMFILLINFO; document: FPDF_DOCUMENT; nPageIndex: Integer): FPDF_PAGE; cdecl;
  FFI_GetCurrentPage = function(pThis: PFPDF_FORMFILLINFO; document: FPDF_DOCUMENT): FPDF_PAGE; cdecl;
  FFI_GetRotation = function(pThis: PFPDF_FORMFILLINFO; page: FPDF_PAGE): Integer; cdecl;
  FFI_ExecuteNamedAction = procedure(pThis: PFPDF_FORMFILLINFO; namedAction: FPDF_BYTESTRING); cdecl;
  FFI_SetTextFieldFocus = procedure(pThis: PFPDF_FORMFILLINFO; value: FPDF_WIDESTRING; valueLen: FPDF_DWORD; is_focus: FPDF_BOOL); cdecl;
  FFI_DoURIAction = procedure(pThis: PFPDF_FORMFILLINFO; bsURI: FPDF_BYTESTRING); cdecl;
  FFI_DoGoToAction = procedure(pThis: PFPDF_FORMFILLINFO; nPageIndex, zoomMode: Integer; var fPosArray: Single; sizeofArray: Integer); cdecl;

  FPDF_FORMFILLINFO = record

    // Version number of the interface. Currently must be 1 (when PDFium is built
    //  without the XFA module) or must be 2 (when built with the XFA module).
    version: Integer;

    // Version 1.

    {
      Method: Release
          Give the implementation a chance to release any resources after the
          interface is no longer used.
      Interface Version:
          1
      Implementation Required:
          No
      Comments:
          Called by PDFium during the final cleanup process.
      Parameters:
          pThis       -   Pointer to the interface structure itself
      Return Value:
          None
    }

    Release: Release;

    {
      Method: FFI_Invalidate
          Invalidate the client area within the specified rectangle.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          page        -   Handle to the page. Returned by FPDF_LoadPage().
          left        -   Left position of the client area in PDF page
                          coordinates.
          top         -   Top position of the client area in PDF page
                          coordinates.
          right       -   Right position of the client area in PDF page
                          coordinates.
          bottom      -   Bottom position of the client area in PDF page
                          coordinates.
      Return Value:
          None.

      Comments:
          All positions are measured in PDF "user space".
          Implementation should call FPDF_RenderPageBitmap() for repainting the
          specified page area.
    }

    FFI_Invalidate: FFI_Invalidate;

    {
      Method: FFI_OutputSelectedRect
          When the user selects text in form fields with the mouse, this
          callback function will be invoked with the selected areas.

      Interface Version:
          1
      Implementation Required:
          No
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          page        -   Handle to the page. Returned by FPDF_LoadPage()/
          left        -   Left position of the client area in PDF page
                          coordinates.
          top         -   Top position of the client area in PDF page
                          coordinates.
          right       -   Right position of the client area in PDF page
                          coordinates.
          bottom      -   Bottom position of the client area in PDF page
                          coordinates.
      Return Value:
          None.

      Comments:
          This callback function is useful for implementing special text
          selection effects. An implementation should first record the returned
          rectangles, then draw them one by one during the next painting period.
          Lastly, it should remove all the recorded rectangles when finished
          painting.
    }

    FFI_OutputSelectedRect: FFI_OutputSelectedRect;

    {
      Method: FFI_SetCursor
          Set the Cursor shape.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          nCursorType -   Cursor type, see Flags for Cursor type for the details.
      Return value:
          None.
    }

    FFI_SetCursor: FFI_SetCursor;

    {
      Method: FFI_SetTimer
          This method installs a system timer. An interval value is specified,
          and every time that interval elapses, the system must call into the
          callback function with the timer ID as returned by this function.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          uElapse     -   Specifies the time-out value, in milliseconds.
          lpTimerFunc -   A pointer to the callback function-TimerCallback.
      Return value:
          The timer identifier of the new timer if the function is successful.
          An application passes this value to the FFI_KillTimer method to kill
          the timer. Nonzero if it is successful; otherwise, it is zero.
    }

    FFI_SetTimer: FFI_SetTimer;

    {
      Method: FFI_KillTimer
          This method uninstalls a system timer, as set by an earlier call to
          FFI_SetTimer.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          nTimerID    -   The timer ID returned by FFI_SetTimer function.
      Return value:
          None.
    }

    FFI_KillTimer: FFI_KillTimer;

    {
      Method: FFI_GetLocalTime
          This method receives the current local time on the system.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
      Return value:
          The local time. See FPDF_SYSTEMTIME above for details.
      Note: Unused.
    }

    FFI_GetLocalTime: FFI_GetLocalTime;

    {
      Method: FFI_OnChange
          This method will be invoked to notify the implementation when the
          value of any FormField on the document had been changed.
      Interface Version:
          1
      Implementation Required:
          no
      Parameters:
          pThis       -   Pointer to the interface structure itself.
      Return value:
          None.
    }

    FFI_OnChange: FFI_OnChange;

    {
      Method: FFI_GetPage
          This method receives the page handle associated with a specified page
          index.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          document    -   Handle to document. Returned by FPDF_LoadDocument().
          nPageIndex  -   Index number of the page. 0 for the first page.
      Return value:
          Handle to the page, as previously returned to the implementation by
          FPDF_LoadPage().
      Comments:
          The implementation is expected to keep track of the page handles it
          receives from PDFium, and their mappings to page numbers.
          In some cases, the document-level JavaScript action may refer to a
          page which hadn't been loaded yet. To successfully run the Javascript
          action, the implementation need to load the page.
    }

    FFI_GetPage: FFI_GetPage;

    {
      Method: FFI_GetCurrentPage
          This method receives the handle to the current page.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          document    -   Handle to document. Returned by FPDF_LoadDocument().
      Return value:
          Handle to the page. Returned by FPDF_LoadPage().
      Comments:
          The implementation is expected to keep track of the current page. e.g.
          The current page can be the one that is most visible on screen.
    }

    FFI_GetCurrentPage: FFI_GetCurrentPage;

    {
      Method: FFI_GetRotation
          This method receives currently rotation of the page view.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis       -   Pointer to the interface structure itself.
          page        -   Handle to page. Returned by FPDF_LoadPage function.
      Return value:
          A number to indicate the page rotation in 90 degree increments in a
          clockwise direction:
          0 - 0 degrees
          1 - 90 degrees
          2 - 180 degrees
          3 - 270 degrees
      Note: Unused.
    }

    FFI_GetRotation: FFI_GetRotation;

    {
      Method: FFI_ExecuteNamedAction
          This method will execute a named action.
      Interface Version:
          1
      Implementation Required:
          yes
      Parameters:
          pThis           -   Pointer to the interface structure itself.
          namedAction     -   A byte string which indicates the named action,
                              terminated by 0.
      Return value:
          None.
      Comments:
          See the named actions description of <<PDF Reference, version 1.7>>
          for more details.
    }

    FFI_ExecuteNamedAction: FFI_ExecuteNamedAction;

    {
      Method: FFI_SetTextFieldFocus
          Called when a text field is getting or losing focus.
      Interface Version:
          1
      Implementation Required:
          no
      Parameters:
          pThis           -   Pointer to the interface structure itself.
          value           -   The string value of the form field, in UTF-16LE
                              format.
          valueLen        -   The length of the string value. This is the number
                              of characters, not bytes.
          is_focus        -   True if the form field is getting focus, False if
                              the form field is losing focus.
      Return value:
          None.
      Comments:
          Only supports text fields and combobox fields.
    }

    FFI_SetTextFieldFocus: FFI_SetTextFieldFocus;

    {
      Method: FFI_DoURIAction
          Ask the implementation to navigate to a uniform resource identifier.
      Interface Version:
          1
      Implementation Required:
          No
      Parameters:
          pThis           -   Pointer to the interface structure itself.
          bsURI           -   A byte string which indicates the uniform resource
                              identifier, terminated by 0.
      Return value:
          None.
      Comments:
          See the URI actions description of <<PDF Reference, version 1.7>> for
          more details.
    }

    FFI_DoURIAction: FFI_DoURIAction;

    {
      Method: FFI_DoGoToAction
          This action changes the view to a specified destination.
      Interface Version:
          1
      Implementation Required:
          No
      Parameters:
          pThis           -   Pointer to the interface structure itself.
          nPageIndex      -   The index of the PDF page.
          zoomMode        -   The zoom mode for viewing page. See below.
          fPosArray       -   The float array which carries the position info.
          sizeofArray     -   The size of float array.

      PDFZoom values:
        - XYZ = 1
        - FITPAGE = 2
        - FITHORZ = 3
        - FITVERT = 4
        - FITRECT = 5
        - FITBBOX = 6
        - FITBHORZ = 7
        - FITBVERT = 8

      Return value:
          None.
      Comments:
          See the Destinations description of <<PDF Reference, version 1.7>> in
          8.2.1 for more details.
    }

    FFI_DoGoToAction: FFI_DoGoToAction;

    {
      Pointer to IPDF_JSPLATFORM interface.
      Unused if PDFium is built without V8 support. Otherwise, if NULL, then
      JavaScript will be prevented from executing while rendering the document.
    }
    m_pJsPlatform: ^IPDF_JSPLATFORM;
  end;

{
  Function: FPDFDOC_InitFormFillEnvironment
           Init form fill environment.
  Comments:
           This function should be called before any form fill operation.
  Parameters:
           document        -   Handle to document. Returned by
 FPDF_LoadDocument function.
           pFormFillInfo   -   Pointer to a FPDF_FORMFILLINFO structure.
  Return Value:
           Return handler to the form fill module. NULL means fails.
}

type TFPDFDOC_InitFormFillEnvironment = function(document: FPDF_DOCUMENT; var formInfo: FPDF_FORMFILLINFO): FPDF_FORMHANDLE; cdecl;

{
  Function: FPDFDOC_ExitFormFillEnvironment
           Exit form fill environment.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
  Return Value:
           NULL.
}

type TFPDFDOC_ExitFormFillEnvironment = procedure(hHandle: FPDF_FORMHANDLE); cdecl;

{
  Function: FORM_OnAfterLoadPage
           This method is required for implementing all the form related
 functions. Should be invoked after user
           successfully loaded a PDF page, and method
 FPDFDOC_InitFormFillEnvironment had been invoked.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
  Return Value:
           NONE.
}

type TFORM_OnAfterLoadPage = procedure(page: FPDF_PAGE; hHandle: FPDF_FORMHANDLE); cdecl;

{
  Function: FORM_OnBeforeClosePage
           This method is required for implementing all the form related
 functions. Should be invoked before user
           close the PDF page.
  Parameters:
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
  Return Value:
           NONE.
}

type TFORM_OnBeforeClosePage = procedure(page: FPDF_PAGE; hHandle: FPDF_FORMHANDLE); cdecl;

{
 Function: FORM_DoDocumentJSAction
           This method is required for performing Document-level JavaScript
action. It should be invoked after the PDF document
           had been loaded.
 Parameters:
           hHandle     -   Handle to the form fill module. Returned by
FPDFDOC_InitFormFillEnvironment.
 Return Value:
           NONE
 Comments:
           If there is Document-level JavaScript action embedded in the
document, this method will execute the javascript action;
           otherwise, the method will do nothing.
}

type TFORM_DoDocumentJSAction = procedure (hHandle: FPDF_FORMHANDLE); cdecl;

{
 Function: FORM_DoDocumentOpenAction
           This method is required for performing open-action when the document
is opened.
 Parameters:
           hHandle     -   Handle to the form fill module. Returned by
FPDFDOC_InitFormFillEnvironment.
 Return Value:
           NONE
 Comments:
           This method will do nothing if there is no open-actions embedded in
the document.
}

type TFORM_DoDocumentOpenAction = procedure(hHandle: FPDF_FORMHANDLE); cdecl;

// Additional actions type of document:
//   WC, before closing document, JavaScript action.
//   WS, before saving document, JavaScript action.
//   DS, after saving document, JavaScript action.
//   WP, before printing document, JavaScript action.
//   DP, after printing document, JavaScript action.

const
  FPDFDOC_AACTION_WC = $10;
  FPDFDOC_AACTION_WS = $11;
  FPDFDOC_AACTION_DS = $12;
  FPDFDOC_AACTION_WP = $13;
  FPDFDOC_AACTION_DP = $14;

{
  Function: FORM_DoDocumentAAction
            This method is required for performing the document's
            additional-action.
  Parameters:
            hHandle     -   Handle to the form fill module. Returned by
                            FPDFDOC_InitFormFillEnvironment.
            aaType      -   The type of the additional-actions which defined
                            above.
  Return Value:
            NONE
  Comments:
            This method will do nothing if there is no document
            additional-action corresponding to the specified aaType.
}

type TFORM_DoDocumentAAction = procedure(hHandle: FPDF_FORMHANDLE; aaType: Integer); cdecl;

// Additional-action types of page object:
//   OPEN (/O) -- An action to be performed when the page is opened
//   CLOSE (/C) -- An action to be performed when the page is closed

const
  FPDFPAGE_AACTION_OPEN  = 0;
  FPDFPAGE_AACTION_CLOSE = 1;

{
  Function: FORM_DoPageAAction
            This method is required for performing the page object's
            additional-action when opened or closed.
  Parameters:
            page        -   Handle to the page. Returned by FPDF_LoadPage
                            function.
            hHandle     -   Handle to the form fill module. Returned by
                            FPDFDOC_InitFormFillEnvironment.
            aaType      -   The type of the page object's additional-actions
                            which defined above.
  Return Value:
            NONE
  Comments:
            This method will do nothing if no additional-action corresponding
            to the specified aaType exists.
}

type TFORM_DoPageAAction = procedure(page: FPDF_PAGE; hHandle: FPDF_FORMHANDLE; aaType: Integer); cdecl;

{
  Function: FORM_OnMouseMove
           You can call this member function when the mouse cursor moves.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           modifier        -   Indicates whether various virtual keys are down.
           page_x      -   Specifies the x-coordinate of the cursor in PDF user
 space.
           page_y      -   Specifies the y-coordinate of the cursor in PDF user
 space.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnMouseMove = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; modifier: Integer; page_x, page_y: Double): FPDF_BOOL; cdecl;

{
  Function: FORM_OnFocus
           This function focuses the form annotation at a given point. If the
           annotation at the point already has focus, nothing happens. If there
           is no annotation at the point, remove form focus.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage.
           modifier    -   Indicates whether various virtual keys are down.
           page_x      -   Specifies the x-coordinate of the cursor in PDF user
                           space.
           page_y      -   Specifies the y-coordinate of the cursor in PDF user
                           space.
  Return Value:
           TRUE if there is an annotation at the given point and it has focus.
}

type TFORM_OnFocus = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; modifier: Integer; page_x, page_y: Double): FPDF_BOOL; cdecl;

{
  Function: FORM_OnLButtonDown
           You can call this member function when the user presses the left
           mouse button.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment().
           page        -   Handle to the page. Returned by FPDF_LoadPage
                           function.
           modifier    -   Indicates whether various virtual keys are down.
           page_x      -   Specifies the x-coordinate of the cursor in PDF user
                           space.
           page_y      -   Specifies the y-coordinate of the cursor in PDF user
                           space.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnLButtonDown = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; modifier: Integer; page_x, page_y: Double): FPDF_BOOL; cdecl;

{
  Function: FORM_OnLButtonUp
           You can call this member function when the user releases the left
           mouse button.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment().
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           modifier    -   Indicates whether various virtual keys are down.
           page_x      -   Specifies the x-coordinate of the cursor in device.
           page_y      -   Specifies the y-coordinate of the cursor in device.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnLButtonUp = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; modifier: Integer; page_x, page_y: Double): FPDF_BOOL; cdecl;

{
  Function: FORM_OnLButtonDoubleClick
           You can call this member function when the user double clicks the
           left mouse button.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment().
           page        -   Handle to the page. Returned by FPDF_LoadPage
                           function.
           modifier    -   Indicates whether various virtual keys are down.
           page_x      -   Specifies the x-coordinate of the cursor in PDF user
                           space.
           page_y      -   Specifies the y-coordinate of the cursor in PDF user
                           space.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnLButtonDoubleClick = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; modifier: Integer; page_x, page_y: Double): FPDF_BOOL; cdecl;

{
  Function: FORM_OnKeyDown
           You can call this member function when a nonsystem key is pressed.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           nKeyCode    -   Indicates whether various virtual keys are down.
           modifier    -   Contains the scan code, key-transition code,
 previous key state, and context code.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnKeyDown = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; nKeyCode, modifier: Integer): FPDF_BOOL; cdecl;

{
  Function: FORM_OnKeyUp
           You can call this member function when a nonsystem key is released.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           nKeyCode    -   The virtual-key code of the given key.
           modifier    -   Contains the scan code, key-transition code,
 previous key state, and context code.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnKeyUp = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; nKeyCode, modifier: Integer): FPDF_BOOL; cdecl;

{
  Function: FORM_OnChar
           You can call this member function when a keystroke translates to a
 nonsystem character.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
 function.
           nChar       -   The character code value of the key.
           modifier    -   Contains the scan code, key-transition code,
 previous key state, and context code.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_OnChar = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; nChar, modifier: Integer): FPDF_BOOL; cdecl;

{
  Experimental API
  Function: FORM_GetFocusedText
           You can call this function to obtain the text within the current
           focused field, if any.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
                           function.
           buffer      -   Buffer for holding the form text, encoded in
                           UTF-16LE. If NULL, |buffer| is not modified.
           buflen      -   Length of |buffer| in bytes. If |buflen| is less
                           than the length of the form text string, |buffer| is
                           not modified.
  Return Value:
           Length in bytes for the text in the focused field.
}

type TFORM_GetFocusedText = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

{
  Function: FORM_GetSelectedText
           You can call this function to obtain selected text within
           a form text field or form combobox text field.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
                           function.
           buffer      -   Buffer for holding the selected text, encoded in
                           UTF-16LE. If NULL, |buffer| is not modified.
           buflen      -   Length of |buffer| in bytes. If |buflen| is less
                           than the length of the selected text string,
                           |buffer| is not modified.

  Return Value:
           Length in bytes of selected text in form text field or form combobox
           text field.
}

type TFORM_GetSelectedText = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; buffer: Pointer; buflen: LongWord): LongWord; cdecl;

{
  Function: FORM_ReplaceSelection
           You can call this function to replace the selected text in a form
           text field or user-editable form combobox text field with another
           text string (which can be empty or non-empty). If there is no
           selected text, this function will append the replacement text after
           the current caret position.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
                           FPDFDOC_InitFormFillEnvironment.
           page        -   Handle to the page. Returned by FPDF_LoadPage
                           function.
           wsText      -   The text to be inserted, in UTF-16LE format.
  Return Value:
           None.
}

type TFORM_ReplaceSelection = procedure(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; wsText: FPDF_WIDESTRING); cdecl;

{
 Function: FORM_CanUndo
          Find out if it is possible for the current focused widget in a given
          form to perform an undo operation.
 Parameters:
          hHandle     -   Handle to the form fill module. Returned by
                          FPDFDOC_InitFormFillEnvironment.
          page        -   Handle to the page. Returned by FPDF_LoadPage
                          function.
 Return Value:
          True if it is possible to undo.
}

type TFORM_CanUndo = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE): FPDF_BOOL; cdecl;

{
 Function: FORM_CanRedo
          Find out if it is possible for the current focused widget in a given
          form to perform a redo operation.
 Parameters:
          hHandle     -   Handle to the form fill module. Returned by
                          FPDFDOC_InitFormFillEnvironment.
          page        -   Handle to the page. Returned by FPDF_LoadPage
                          function.
 Return Value:
          True if it is possible to redo.
}

type TFORM_CanRedo = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE): FPDF_BOOL; cdecl;

{
 Function: FORM_Undo
          Make the current focussed widget perform an undo operation.
 Parameters:
          hHandle     -   Handle to the form fill module. Returned by
                          FPDFDOC_InitFormFillEnvironment.
          page        -   Handle to the page. Returned by FPDF_LoadPage
                          function.
 Return Value:
          True if the undo operation succeeded.
}

type TFORM_Undo = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE): FPDF_BOOL; cdecl;

{
 Function: FORM_Redo
          Make the current focussed widget perform a redo operation.
 Parameters:
          hHandle     -   Handle to the form fill module. Returned by
                          FPDFDOC_InitFormFillEnvironment.
          page        -   Handle to the page. Returned by FPDF_LoadPage
                          function.
 Return Value:
          True if the redo operation succeeded.
}

type TFORM_Redo = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE): FPDF_BOOL; cdecl;

{
  Function: FORM_ForceToKillFocus.
           You can call this member function to force to kill the focus of the
 form field which got focus.
           It would kill the focus on the form field, save the value of form
 field if it's changed by user.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
  Return Value:
           TRUE indicates success; otherwise false.
}

type TFORM_ForceToKillFocus = function(hHandle: FPDF_FORMHANDLE): FPDF_BOOL; cdecl;

// Form Field Types
// The names of the defines are stable, but the specific values associated with
// them are not, so do not hardcode their values.
const
  FPDF_FORMFIELD_UNKNOWN     = 0; // Unknown.
  FPDF_FORMFIELD_PUSHBUTTON  = 1; // push button type.
  FPDF_FORMFIELD_CHECKBOX    = 2; // check box type.
  FPDF_FORMFIELD_RADIOBUTTON = 3; // radio button type.
  FPDF_FORMFIELD_COMBOBOX    = 4; // combo box type.
  FPDF_FORMFIELD_LISTBOX     = 5; // list box type.
  FPDF_FORMFIELD_TEXTFIELD   = 6; // text field type.
  FPDF_FORMFIELD_SIGNATURE   = 7; // text field type.

  FPDF_FORMFIELD_COUNT = 8;

{
  Function: FPDFPage_HasFormFieldAtPoint
      Get the form field type by point.
  Parameters:
      hHandle     -   Handle to the form fill module. Returned by
                      FPDFDOC_InitFormFillEnvironment().
      page        -   Handle to the page. Returned by FPDF_LoadPage().
      page_x      -   X position in PDF "user space".
      page_y      -   Y position in PDF "user space".
  Return Value:
      Return the type of the form field; -1 indicates no field.
      See field types above.
}

type TFPDFPage_HasFormFieldAtPoint = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; page_x, page_y: Double): Integer; cdecl;

{
  Function: FPDFPage_FormFieldZOrderAtPoint
      Get the form field z-order by point.
  Parameters:
      hHandle     -   Handle to the form fill module. Returned by
                      FPDFDOC_InitFormFillEnvironment().
      page        -   Handle to the page. Returned by FPDF_LoadPage().
      page_x      -   X position in PDF "user space".
      page_y      -   Y position in PDF "user space".
  Return Value:
      Return the z-order of the form field; -1 indicates no field.
      Higher numbers are closer to the front.
}

type TFPDFPage_FormFieldZOrderAtPoint = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; page_x, page_y: Double): Integer; cdecl;

{
  Function: FPDF_SetFormFieldHighlightColor
           Set the highlight color of specified or all the form fields in the
 document.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           doc         -   Handle to the document. Returned by
 FPDF_LoadDocument function.
           fieldType   -   A 32-bit integer indicating the type of a form
 field(defined above).
           color       -   The highlight color of the form field.Constructed by
 0xxxrrggbb.
  Return Value:
           NONE.
  Comments:
           When the parameter fieldType is set to FPDF_FORMFIELD_UNKNOWN, the
           highlight color will be applied to all the form fields in the
           document.
           Please refresh the client window to show the highlight immediately
           if necessary.
}

type TFPDF_SetFormFieldHighlightColor = procedure(hHandle: FPDF_FORMHANDLE; fieldType: Integer; color: LongWord); cdecl;

{
  Function: FPDF_SetFormFieldHighlightAlpha
           Set the transparency of the form field highlight color in the
 document.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
           doc         -   Handle to the document. Returned by
 FPDF_LoadDocument function.
           alpha       -   The transparency of the form field highlight color.
 between 0-255.
  Return Value:
           NONE.
}

type TFPDF_SetFormFieldHighlightAlpha = procedure(hHandle: FPDF_FORMHANDLE; alpha: Byte); cdecl;

{
  Function: FPDF_RemoveFormFieldHighlight
           Remove the form field highlight color in the document.
  Parameters:
           hHandle     -   Handle to the form fill module. Returned by
 FPDFDOC_InitFormFillEnvironment.
  Return Value:
           NONE.
  Comments:
           Please refresh the client window to remove the highlight immediately
 if necessary.
}

type TFPDF_RemoveFormFieldHighlight = procedure(hHandle: FPDF_FORMHANDLE); cdecl;

{
 Function: FPDF_FFLDraw
           Render FormFields and popup window on a page to a device independent
bitmap.
 Parameters:
           hHandle     -   Handle to the form fill module. Returned by
FPDFDOC_InitFormFillEnvironment.
           bitmap      -   Handle to the device independent bitmap (as the
output buffer).
                           Bitmap handle can be created by FPDFBitmap_Create
function.
           page        -   Handle to the page. Returned by FPDF_LoadPage
function.
           start_x     -   Left pixel position of the display area in the
device coordinate.
           start_y     -   Top pixel position of the display area in the device
coordinate.
           size_x      -   Horizontal size (in pixels) for displaying the page.
           size_y      -   Vertical size (in pixels) for displaying the page.
           rotate      -   Page orientation: 0 (normal), 1 (rotated 90 degrees
clockwise),
                               2 (rotated 180 degrees), 3 (rotated 90 degrees
counter-clockwise).
           flags       -   0 for normal display, or combination of flags
defined above.
 Return Value:
           None.
 Comments:
           This function is designed to render annotations that are
user-interactive, which are widget annotation (for FormFields) and popup
annotation.
           With FPDF_ANNOT flag, this function will render popup annotation
when users mouse-hover on non-widget annotation. Regardless of FPDF_ANNOT flag,
this function will always render widget annotations for FormFields.
           In order to implement the FormFill functions, implementation should
call this function after rendering functions, such as FPDF_RenderPageBitmap or
FPDF_RenderPageBitmap_Start, finish rendering the page contents.
}

type TFPDF_FFLDraw = procedure(hHandle: FPDF_FORMHANDLE; bitmap: FPDF_BITMAP; page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, flags: Integer); cdecl;

{
  Experimental API
  Function: FPDF_GetFormType
            Returns the type of form contained in the PDF document.
  Parameters:
            document - Handle to document.
  Return Value:
            Integer value representing one of the FORMTYPE_ values.
  Comments:
            If |document| is NULL, then the return value is FORMTYPE_NONE.
}

type TFPDF_GetFormType = function(document: FPDF_DOCUMENT): Integer; cdecl;

{
  Experimental API
  Function: FORM_SetIndexSelected
            Selects/deselects the value at the given |index| of the focused
            annotation.
  Parameters:
            hHandle     -   Handle to the form fill module. Returned by
                            FPDFDOC_InitFormFillEnvironment.
            page        -   Handle to the page. Returned by FPDF_LoadPage
            index       -   0-based index of value to be set as
                            selected/unselected
            selected    -   true to select, false to deselect
  Return Value:
            TRUE if the operation succeeded.
            FALSE if the operation failed or widget is not a supported type.
  Comments:
            Intended for use with listbox/combobox widget types. Comboboxes
            have at most a single value selected at a time which cannot be
            deselected. Deselect on a combobox is a no-op that returns false.
            Default implementation is a no-op that will return false for
            other types.
            Not currently supported for XFA forms - will return false.
}

type TFORM_SetIndexSelected = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; index: Integer; selected: FPDF_BOOL): FPDF_BOOL; cdecl;

{
  Experimental API
  Function: FORM_IsIndexSelected
            Returns whether or not the value at |index| of the focused
            annotation is currently selected.
  Parameters:
            hHandle     -   Handle to the form fill module. Returned by
                            FPDFDOC_InitFormFillEnvironment.
            page        -   Handle to the page. Returned by FPDF_LoadPage
            index       -   0-based Index of value to check
  Return Value:
            TRUE if value at |index| is currently selected.
            FALSE if value at |index| is not selected or widget is not a
            supported type.
  Comments:
            Intended for use with listbox/combobox widget types. Default
            implementation is a no-op that will return false for other types.
            Not currently supported for XFA forms - will return false.
}

type TFORM_IsIndexSelected = function(hHandle: FPDF_FORMHANDLE; page: FPDF_PAGE; index: Integer): FPDF_BOOL; cdecl;

{
  Function: FPDF_LoadXFA
           If the document consists of XFA fields, there should call this
 method to load XFA fields.
  Parameters:
           document        -   Handle to document. Returned by
 FPDF_LoadDocument function.
  Return Value:
           TRUE indicates success,otherwise FALSE.
}

type TFPDF_LoadXFA = function(document: FPDF_DOCUMENT): FPDF_BOOL; cdecl;

implementation

end.