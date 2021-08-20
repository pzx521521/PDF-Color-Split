//---------------------------------------------------------------------
//
// PDFium Component Suite
//
// Copyright (c) 2014-2019 WINSOFT
//
//---------------------------------------------------------------------

//{$define TRIAL} // trial version, comment this line for full version

unit PDFium;

{$ifdef VER130} // Delphi 5
  {$define D5}
{$endif}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}

  {$if CompilerVersion >= 15}
    {$define D7PLUS} // Delphi 7 or higher
  {$ifend}

  {$if CompilerVersion >= 20}
    {$define D2009PLUS} // Delphi 2009 or higher
    {$WARN SYMBOL_PLATFORM OFF}
  {$ifend}

  {$if CompilerVersion >= 21}
    {$define D2010PLUS} // Delphi 2010 or higher
  {$ifend}

  {$if CompilerVersion >= 23}
    {$define DXE2PLUS} // Delphi XE2 or higher
  {$ifend}
{$endif}

{$ifdef WIN64}
{$HPPEMIT '#pragma link "PDFiumP.a"'}
{$else}
{$HPPEMIT '#pragma link "PDFiumP.lib"'}
{$endif WIN64}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls,
  FPdfView, FPdfText, FPdfPpo, FPdfSysFontInfo, FPdfSave, FPdfDoc,
  FPdfDataAvail, FPdfProgressive, FPdfTransformPage, FPdfExt, FPdfEdit,
  FPdfFormFill, FPdfSearchEx, FPdfFlatten, FPdfStructTree, FPdfAnnot,
  FPdfAttachment, FPdfCatalog, FPdfThumbnail;

{$HPPEMIT '#define NativeUInt Fpdfview::NativeUInt'}

type
  WString = {$ifdef D2009PLUS} string {$else} WideString {$endif D2009PLUS};

{$ifndef D2009PLUS}
  TBytes = array of Byte;
{$endif D2009PLUS}

  EPdfError = class(Exception)
  end;

  TRotation = (ro0, ro90, ro180, ro270);

  TRenderOption = (reAnnotations, reLcd, reNoNativeText, reGrayscale, reDebugInfo,
    reNoCatchException, reLimitCache, reHalftone, rePrinting, reReverseByteOrder,
    reNoSmoothText, reNoSmoothImage, reNoSmoothPath);
  TRenderOptions = set of TRenderOption;

  TPageMode = (pmNone, pmOutline, pmThumbs, pmFullScreen, pmOptionalContentGroup, pmAttachments, pmUnknown);

  TSearchOption = (seCaseSensitive, seWholeWord, seConsecutive);
  TSearchOptions = set of TSearchOption;

  TSaveOption = (saNone, saIncremental, saNoIncremental, saRemoveSecurity);

  TPdfAction = (acUnsupported, acGoto, acGotoRemote, acUri, acLaunch);

  TPdfVersion = (pvUnknown, pv10, pv11, pv12, pv13, pv14, pv15, pv16, pv17);

  TObjectType = (otUnknown, otText, otPath, otImage, otShading, otForm);

  TPrintPaperHandling = (phUndefined, phSimplex, phDuplexFlipShortEdge, phDuplexFlipLongEdge);

  TPdfFormFieldFlag = (ffReadOnly, ffRequired, ffNoExport, ffMultiline, ffChoiceCombo, ffChoiceEdit);
  TPdfFormFieldFlags = set of TPdfFormFieldFlag;

  TPdfPoint = record
    X, Y: Double;
  end;

  TPdfRectangle = record
    Left, Top, Right, Bottom: Double;
  end;

  TPdfRectangles = array of TPdfRectangle;

  TBookmark = record
    Handle: FPDF_BOOKMARK;
    Title: WString;
    PageNumber: Integer;
    Action: TPdfAction;
    ActionPageNumber: Integer;
  end;

  TBookmarks = array of TBookmark;

  TQuadrilateralPoint = array [1..4] of TPdfPoint;

  TLinkAnnotation = record
    Handle: FPDF_LINK;
    Rectangle: TPdfRectangle;
    PageNumber: Integer;
    Action: TPdfAction;
    ActionPageNumber: Integer;
    ActionPath: WString;
    Points: array of TQuadrilateralPoint;
  end;

  TLinkAnnotations = array of TLinkAnnotation;

  TWebLink = record
    Url: WString;
    Rectangles: TPdfRectangles;
  end;

  TWebLinks = array of TWebLink;

  TDestination = record
    Handle: FPDF_DEST;
    Name: WString;
    PageNumber: Integer;
    HasX: Boolean;
    X: Single;
    HasY: Boolean;
    Y: Single;
    HasZoom: Boolean;
    Zoom: Single;
  end;

  TPdfImage = record
    Width: Integer;
    Height: Integer;
    Data: TBytes;
  end;

  TPdfFeature = (feUnknown, feXfaForm, fePortableCollection, feAttachment, feSecurity,
    feSharedReview, feSharedFormAcrobat, feSharedFormFilesystem, feSharedFormEmail,
    fe3dAnnotation, feMovieAnnotation, feSoundAnnotation, feScreenMediaAnnotation,
    feScreenRichMediaAnnotation, feAttachmentAnnotation, feSignatureAnnotation);

  TPdfUnsupportedFeatureEvent = procedure(Sender: TObject; Feature: TPdfFeature) of object;

  TPdfFormFieldEnterEvent = procedure(Sender: TObject; const Text: WString) of object;

  TPdfBlendMode = (bmDefault, bmColor, bmColorBurn, bmColorDodge, bmDarken, bmDifference,
    bmExclusion, bmHardLight, bmHue, bmLighten, bmLuminosity, bmMultiply, bmNormal,
    bmOverlay, bmSaturation, bmScreen, bmSoftLight);

  TPdfLineJoin = (ljDefault, ljMiter, ljRound, ljBevel);

  TPdfLineCap = (lcDefault, lcButt, lcRound, lcProjectingSquare);

  TPdf = class;

  TPdfFormFillInfo = packed record
    Info: FPDF_FORMFILLINFO;
    Pdf: TPdf;
  end;
  PPdfFormFillInfo = ^TPdfFormFillInfo;

  TPdfFillMode = (fmNone, fmAlternate, fmWinding);

  TPdfAnnotationSubtype = (anUnknown, anText, anLink, anFreeText, anLine,
    anSquare, anCircle, anPolygon, anPolyLine, anHighlight, anUnderline,
    anSquiggly, anStrikeout, anStamp, anCaret, anInk, anPopup, anFileAttachment,
    anSound, anMovie, anWidget, anScreen, anPrinterMark, anTrapNet,
    anWaterMark, anThreed, anRichMedia, anXfaWidget);

  TPdfAnnotationFlag = (afInvisible, afHidden, afPrint, afNoZoom, afNoRotate,
    afNoView, afReadOnly, afLocked, afToggleNoView);

  TPdfAnnotationFlags = set of TPdfAnnotationFlag;

  TPdfAnnotation = record
    Subtype: TPdfAnnotationSubtype;
    Flags: TPdfAnnotationFlags;
    HasColor: Boolean;
    Color: TColor;
    ColorAlpha: Byte;
    HasInteriorColor: Boolean;
    InteriorColor: TColor;
    InteriorColorAlpha: Byte;
    HasAttachmentPoints: Boolean;
    AttachmentPoints: TQuadrilateralPoint;
    Rectangle: TPdfRectangle;
    ContentsText: WString;
    AuthorText: WString;
  end;

  TPdfFormType = (ftUnknown, ftNone, ftAcroForm, ftXfaFull, ftXfaForeground);

  {$ifdef DXE2PLUS}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$endif DXE2PLUS}
  TPdf = class(TComponent)
  private
    FActive: Boolean;
    FDocument: FPDF_DOCUMENT;
    FFileName: string;
    FFind: FPDF_SCHHANDLE;
    FFormFill: Boolean;
    FFormFillInfo: TPdfFormFillInfo;
    FFormHandle: FPDF_FORMHANDLE;
    FLinkAnnotations: TLinkAnnotations;
    FPage: FPDF_PAGE;
    FPageNumber: Integer;
    FPassword: string;
    FPath: FPDF_PAGEOBJECT;
    FPdfViews: TList;
    FTextPage: FPDF_TEXTPAGE;
    FTimer: TTimer;
    FTimerCallback: TimerCallback;
    FWebLinks: TWebLinks;

    FOnFormFieldEnter: TPdfFormFieldEnterEvent;
    FOnFormFieldExit: TNotifyEvent;
    FOnPageChange: TNotifyEvent;
    FOnUnsupportedFeature: TPdfUnsupportedFeatureEvent;

    procedure CheckActive;
    procedure CheckFindActive;
    procedure CheckInactive;
    procedure CheckPageActive;
    procedure CheckPathCreated;
    procedure ExitFormFill;
    function GetAbout: string;
    function GetActive: Boolean;
    function GetAnnotation(Index: Integer): TPdfAnnotation;
    function GetAnnotationCount: Integer;
    function GetAuthor: WString;
    function GetBitmap(Index: Integer): TBitmap;
    function GetBitmapCount: Integer;
    function GetBookmark(const Title: WString): TBookmark;
    function GetBookmarkChildren(const Bookmark: TBookmark): TBookmarks;
    function GetBookmarks: TBookmarks;
    function GetCharacter(Index: Integer): WideChar;
    function GetCharacterCount: Integer;
    function GetCharacterOrigin(Index: Integer): TPdfPoint;
    function GetCharacterRectangle(Index: Integer): TPdfRectangle;
    function GetCharcode(Index: Integer): WideChar;
    function GetCreationDate: WString;
    function GetCreator: WString;
    function GetDestination(Index: Integer): TDestination;
    function GetDestinationByName(const Name: WString): TDestination;
    function GetDestinationCount: Integer;
    function GetFontSize(Index: Integer): Double;
    function GetFormField(Index: Integer): WString;
    function GetFormFieldCount: Integer;
    function GetFormFieldFlags(Index: Integer): TPdfFormFieldFlags;
    function GetFormType: TPdfFormType;
    function GetHasBookmarkChildren(const Bookmark: TBookmark): Boolean;
    function GetImage(Index: Integer): TPdfImage;
    function GetImageCount: Integer;
    function GetIsTagged: Boolean;
    function GetKeywords: WString;
    function GetLinkAnnotation(Index: Integer): TLinkAnnotation;
    function GetLinkAnnotationCount: Integer;
    function GetLinkAnnotations: TLinkAnnotations;
    function GetMetaText(const Tag: string): WString;
    function GetModifiedDate: WString;
    function GetNestedBookmarks(Bookmark: FPDF_BOOKMARK): TBookmarks;
    function GetObjectBitmap(Index: Integer): TBitmap;
    function GetObjectBounds(Index: Integer): TPdfRectangle;
    function GetObjectCount: Integer;
    function GetObjectHandle(Index: Integer): Pointer;
    function GetObjectTransparent(Index: Integer): Boolean;
    function GetObjectType(Index: Integer): TObjectType;
    function GetPageBounds: TPdfRectangle;
    function GetPageCount: Integer;
    function GetPageHeight: Double;
    function GetPageLabel(PageNumber: Integer): WString;
    function GetPageMode: TPageMode;
    function GetPageRotation: TRotation;
    function GetPageWidth: Double;
    function GetPdfVersion: TPdfVersion;
    function GetPermissions: LongWord;
    function GetPrintCopies: Integer;
//    function GetPrintPageRange: FPDF_PAGERANGE;
    function GetPrintPaperHandling: TPrintPaperHandling;
    function GetPrintScaling: Boolean;
    function GetProducer: WString;
    function GetRectangle(Index: Integer): TPdfRectangle;
    function GetSubject: WString;
    function GetTitle: WString;
    function GetTransparent: Boolean;
    function GetViewerPreference(const Key: string): WString;
    function GetWebLink(Index: Integer): TWebLink;
    function GetWebLinkCount: Integer;
    function GetWebLinks: TWebLinks;
    function GetXFA: Boolean;
    function ImageIndexToObjectIndex(Index: Integer): Integer;
    procedure InitializeFormFill;
    procedure OnTimer(Sender: TObject);
    function RetrieveDestination(Handle: FPDF_DEST; const Name: WString): TDestination;
    procedure SetAbout(const Value: string);
    procedure SetActive(Value: Boolean);
    procedure SetAnnotation(Index: Integer; const Value: TPdfAnnotation);
    procedure SetBookmarkData(Bookmark: FPDF_BOOKMARK; var Data: TBookmark);
    procedure SetFileName(const Value: string);
    procedure SetFormField(Index: Integer; const Value: WString);
    procedure SetFormFill(Value: Boolean);
    procedure SetPageNumber(Value: Integer);
    procedure SetPageRotation(Value: TRotation);
    procedure SetPassword(const Value: string);
    procedure SetTextFieldFocus(value: FPDF_WIDESTRING; valueLen: FPDF_DWORD; is_focus: FPDF_BOOL);
  protected
    procedure LoadDocument; overload;
    procedure Loaded; override;
    procedure LoadTextPage;
    procedure ReloadFind(const Text: WString; Options: TSearchOptions; StartIndex: Integer);
    procedure UnloadDocument;
    procedure UnloadFind;
    procedure UnloadPage;
    procedure UnloadTextPage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function AddJpegImage(JpegImage: TStream; X, Y, Width, Height: Double): Boolean;
    procedure AddPage(PageNumber: Integer; Width, Height: Double);
    procedure AddPath;
    procedure AddPicture(Picture: TPicture; X, Y: Double); overload;
    procedure AddPicture(Picture: TPicture; X, Y, Width, Height: Double); overload;
    procedure AddText(const Text, Font: WString; FontSize: Single; X, Y: Double; Color: TColor = clBlack; Alpha: Byte = $FF);
    procedure BezierTo(X1, Y1, X2, Y2, X3, Y3: Single);
    function CharacterIndexAtPos(X, Y, ToleranceX, ToleranceY: Double): Integer;
    procedure ClosePath;
    procedure CreateAnnotation(const Annotation: TPdfAnnotation);
    procedure CreateDocument;
    procedure CreatePath(X, Y: Single;
      FillMode: TPdfFillMode = fmNone; FillColor: TColor = clBlack; FillAlpha: Byte = $FF;
      Stroke: Boolean = True; StrokeColor: TColor = clBlack; StrokeAlpha: Byte = $FF; StrokeWidth: Single = 1.0;
      LineCap: TPdfLineCap = lcDefault; LineJoin: TPdfLineJoin = ljDefault; BlendMode: TPdfBlendMode = bmDefault); overload;
    procedure CreatePath(X, Y, Width, Height: Single;
      FillMode: TPdfFillMode = fmNone; FillColor: TColor = clBlack; FillAlpha: Byte = $FF;
      Stroke: Boolean = True; StrokeColor: TColor = clBlack; StrokeAlpha: Byte = $FF; StrokeWidth: Single = 1.0;
      LineCap: TPdfLineCap = lcDefault; LineJoin: TPdfLineJoin = ljDefault; BlendMode: TPdfBlendMode = bmDefault); overload;
    procedure DeleteAnnotation(Index: Integer);
    procedure DeletePage(PageNumber: Integer);
    function DeviceToPage(X, Y, Left, Top, Width, Height: Integer; Rotation: TRotation; out PageX, PageY: Double): Boolean;
    function FindFirst(const Text: WString; Options: TSearchOptions = []; StartIndex: Integer = 0; DirectionUp: Boolean = True): Integer;
    function FindNext: Integer;
    function FindPrevious: Integer;
    function ImportPages(Pdf: TPdf; const Range: string; PageNumber: Integer = 1): Boolean;
    function ImportPreferences(Pdf: TPdf): Boolean;
    procedure LineTo(X, Y: Single);
    procedure LoadDocument(Data: Pointer; Size: Integer); overload;
    procedure LoadDocument(const Data: TBytes); overload;
    procedure LoadDocument(Data: TMemoryStream); overload;
    procedure MoveTo(X, Y: Single);
    function PageToDevice(PageX, PageY: Double; Left, Top, Width, Height: Integer; Rotation: TRotation; out X, Y: Integer): Boolean;
    function RectangleCount(StartIndex: Integer = 0; Count: Integer = MaxInt): Integer;
    procedure ReloadPage;
    procedure RenderPage(DeviceContext: HDC; Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []); overload;
    function RenderPage(Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []; Color: TColor = clWhite): TBitmap; overload;
    procedure RenderPage(Bitmap: TBitmap; Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []; Color: TColor = clWhite); overload;
    function SaveAs(Stream: TStream; Option: TSaveOption = saNone; PdfVersion: TPdfVersion = pvUnknown): Boolean; overload;
    function SaveAs(const FileName: string; Option: TSaveOption = saNone; PdfVersion: TPdfVersion = pvUnknown): Boolean; overload;
    procedure SetText(ObjectIndex: Integer; const Text: WString); // undocumented, could cause formatting problems
    function Text(StartIndex: Integer = 0; Count: Integer = MaxInt): WString;
    function TextInRectangle(Left, Top, Right, Bottom: Double): WString; overload;
    function TextInRectangle(Rectangle: TPdfRectangle): WString; overload;
    procedure UpdatePage;

    property Annotation[Index: Integer]: TPdfAnnotation read GetAnnotation write SetAnnotation;
    property AnnotationCount: Integer read GetAnnotationCount;
    property Author: WString read GetAuthor;
    property Bitmap[Index: Integer]: TBitmap read GetBitmap;
    property BitmapCount: Integer read GetBitmapCount;
    property Bookmark[const Title: WString]: TBookmark read GetBookmark;
    property BookmarkChildren[const Bookmark: TBookmark]: TBookmarks read GetBookmarkChildren;
    property Bookmarks: TBookmarks read GetBookmarks;
    property Character[Index: Integer]: WideChar read GetCharacter;
    property CharacterCount: Integer read GetCharacterCount;
    property CharacterOrigin[Index: Integer]: TPdfPoint read GetCharacterOrigin;
    property CharacterRectangle[Index: Integer]: TPdfRectangle read GetCharacterRectangle;
    property Charcode[Index: Integer]: WideChar read GetCharcode;
    property CreationDate: WString read GetCreationDate;
    property Creator: WString read GetCreator;
    property Destination[Index: Integer]: TDestination read GetDestination;
    property DestinationByName[const Name: WString]: TDestination read GetDestinationByName;
    property DestinationCount: Integer read GetDestinationCount;
    property Document: FPDF_DOCUMENT read FDocument;
    property Find: FPDF_SCHHANDLE read FFind;
    property FontSize[Index: Integer]: Double read GetFontSize;
    property FormHandle: FPDF_FORMHANDLE read FFormHandle;
    property FormField[Index: Integer]: WString read GetFormField write SetFormField;
    property FormFieldFlags[Index: Integer]: TPdfFormFieldFlags read GetFormFieldFlags;
    property FormFieldCount: Integer read GetFormFieldCount;
    property FormType: TPdfFormType read GetFormType;
    property HasBookmarkChildren[const Bookmark: TBookmark]: Boolean read GetHasBookmarkChildren;
    property Image[Index: Integer]: TPdfImage read GetImage;
    property ImageCount: Integer read GetImageCount;
    property IsTagged: Boolean read GetIsTagged;
    property Keywords: WString read GetKeywords;
    property LinkAnnotation[Index: Integer]: TLinkAnnotation read GetLinkAnnotation;
    property LinkAnnotationCount: Integer read GetLinkAnnotationCount;
    property MetaText[const Tag: string]: WString read GetMetaText;
    property ModifiedDate: WString read GetModifiedDate;
    property ObjectBitmap[Index: Integer]: TBitmap read GetObjectBitmap;
    property ObjectBounds[Index: Integer]: TPdfRectangle read GetObjectBounds;
    property ObjectCount: Integer read GetObjectCount;
    property ObjectHandle[Index: Integer]: Pointer read GetObjectHandle;
    property ObjectTransparent[Index: Integer]: Boolean read GetObjectTransparent;
    property ObjectType[Index: Integer]: TObjectType read GetObjectType;
    property Page: FPDF_PAGE read FPage;
    property PageBounds: TPdfRectangle read GetPageBounds;
    property PageCount: Integer read GetPageCount;
    property PageHeight: Double read GetPageHeight;
    property PageLabel[PageNumber: Integer]: WString read GetPageLabel;
    property PageMode: TPageMode read GetPageMode;
    property PageRotation: TRotation read GetPageRotation write SetPageRotation;
    property PageWidth: Double read GetPageWidth;
    property PdfVersion: TPdfVersion read GetPdfVersion;
    property Permissions: LongWord read GetPermissions;
    property PrintCopies: Integer read GetPrintCopies;
//    property PrintPageRange: FPDF_PAGERANGE read GetPrintPageRange;
    property PrintPaperHandling: TPrintPaperHandling read GetPrintPaperHandling;
    property PrintScaling: Boolean read GetPrintScaling;
    property Producer: WString read GetProducer;
    property Rectangle[Index: Integer]: TPdfRectangle read GetRectangle;
    property Subject: WString read GetSubject;
    property TextPage: FPDF_TEXTPAGE read FTextPage;
    property Title: WString read GetTitle;
    property Transparent: Boolean read GetTransparent;
    property ViewerPreference[const Key: string]: WString read GetViewerPreference;
    property WebLink[Index: Integer]: TWebLink read GetWebLink;
    property WebLinkCount: Integer read GetWebLinkCount;
    property XFA: Boolean read GetXFA;
  published
    property About: string read GetAbout write SetAbout stored False;
    property Active: Boolean read GetActive write SetActive default False;
    property FileName: string read FFileName write SetFileName;
    property FormFill: Boolean read FFormFill write SetFormFill default True;
    property PageNumber: Integer read FPageNumber write SetPageNumber default 0;
    property Password: string read FPassword write SetPassword;

    property OnFormFieldEnter: TPdfFormFieldEnterEvent read FOnFormFieldEnter write FOnFormFieldEnter;
    property OnFormFieldExit: TNotifyEvent read FOnFormFieldExit write FOnFormFieldExit;
    property OnPageChange: TNotifyEvent read FOnPageChange write FOnPageChange;
    property OnUnsupportedFeature: TPdfUnsupportedFeatureEvent read FOnUnsupportedFeature write FOnUnsupportedFeature;
  end;

  {$ifdef DXE2PLUS}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$endif DXE2PLUS}
  TPdfView = class(TCustomControl)
  private
    FActive: Boolean;
    FCache: Boolean;
    FCachedBitmap: TBitmap;
    FCachedWidth: Integer;
    FCachedHeight: Integer;
    FFind: FPDF_SCHHANDLE;
    FLinkAnnotations: TLinkAnnotations;
    FOptions: TRenderOptions;
    FPage: FPDF_PAGE;
    FPageNumber: Integer;
    FPdf: TPdf;
    FRotation: TRotation;
    FTextPage: FPDF_TEXTPAGE;
    FWebLinks: TWebLinks;
    FOnPaint: TNotifyEvent;
    FOnPageChange: TNotifyEvent;
    procedure CheckActive;
    procedure CheckFindActive;
    procedure CheckInactive;
    procedure ClearCache;
    function GetAbout: string;
    procedure SetAbout(const Value: string);
    function GetActive: Boolean;
    function GetAnnotation(Index: Integer): TPdfAnnotation;
    function GetAnnotationCount: Integer;
    function GetBitmap(Index: Integer): TBitmap;
    function GetBitmapCount: Integer;
    function GetCharacter(Index: Integer): WideChar;
    function GetCharacterCount: Integer;
    function GetCharacterOrigin(Index: Integer): TPoint;
    function GetCharacterRectangle(Index: Integer): TRect;
    function GetCharcode(Index: Integer): WideChar;
    function GetFontSize(Index: Integer): Double;
    function GetFormField(Index: Integer): WString;
    function GetFormFieldCount: Integer;
    function GetFormFieldFlags(Index: Integer): TPdfFormFieldFlags;
    function GetFormHandle: FPDF_FORMHANDLE;
    function GetImage(Index: Integer): TPdfImage;
    function GetImageCount: Integer;
    function GetLinkAnnotation(Index: Integer): TLinkAnnotation;
    function GetLinkAnnotationCount: Integer;
    function GetLinkAnnotations: TLinkAnnotations;
    function GetObjectBitmap(Index: Integer): TBitmap;
    function GetObjectBounds(Index: Integer): TPdfRectangle;
    function GetObjectCount: Integer;
    function GetObjectHandle(Index: Integer): Pointer;
    function GetObjectTransparent(Index: Integer): Boolean;
    function GetObjectType(Index: Integer): TObjectType;
    function GetPageBounds: TPdfRectangle;
    function GetPageCount: Integer;
    function GetPageHeight: Double;
    function GetPageLabel: WString;
    function GetPageRotation: TRotation;
    function GetPageWidth: Double;
    function GetRectangle(Index: Integer): TRect;
    function GetTransparent: Boolean;
    function GetWebLinks: TWebLinks;
    function GetWebLinkCount: Integer;
    function GetWebLink(Index: Integer): TWebLink;
    function ImageIndexToObjectIndex(Index: Integer): Integer;
    function IsFormFillEdit: Boolean;
    procedure SetActive(Value: Boolean);
    procedure SetAnnotation(Index: Integer; const Value: TPdfAnnotation);
    procedure SetCache(Value: Boolean);
    procedure SetFormField(Index: Integer; const Value: WString);
    procedure SetOptions(Value: TRenderOptions);
    procedure SetPageNumber(Value: Integer);
    procedure SetPageRotation(Value: TRotation);
    procedure SetPdf(Value: TPdf);
    procedure SetRotation(Value: TRotation);

    property FormHandle: FPDF_FORMHANDLE read GetFormHandle;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure LoadTextPage;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure ReloadFind(const Text: WString; Options: TSearchOptions; StartIndex: Integer);
    procedure UnloadFind;
    procedure UnloadPage;
    procedure UnloadTextPage;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddPicture(Picture: TPicture; X, Y: Integer); overload;
    procedure AddPicture(Picture: TPicture; X, Y, Width, Height: Integer); overload;
    function CharacterIndexAtPos(X, Y: Integer; ToleranceX, ToleranceY: Double): Integer;
    procedure CreateAnnotation(const Annotation: TPdfAnnotation);
    procedure DeleteAnnotation(Index: Integer);
    function DeviceToPage(X, Y: Integer; out PageX, PageY: Double): Boolean; overload;
    function DeviceToPage(Rectangle: TRect): TPdfRectangle; overload;
    function FindFirst(const Text: WString; Options: TSearchOptions = []; StartIndex: Integer = 0; DirectionUp: Boolean = True): Integer;
    function FindNext: Integer;
    function FindPrevious: Integer;
    function LinkAnnotationAtPos(X, Y: Integer): Integer;
    function PageToDevice(PageX, PageY: Double; out X, Y: Integer): Boolean; overload;
    function PageToDevice(Rectangle: TPdfRectangle): TRect; overload;
    procedure PaintSelection(SelectionStart, SelectionEnd: Integer; Mask: TColor);
    function RectangleCount(StartIndex: Integer = 0; Count: Integer = MaxInt): Integer;
    procedure ReloadPage;
    procedure RenderPage(DeviceContext: HDC; Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []); overload;
    function RenderPage(Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []): TBitmap; overload;
    procedure RenderPage(Bitmap: TBitmap; Left, Top, Width, Height: Integer; Rotation: TRotation = ro0; Options: TRenderOptions = []); overload;
    function Text(StartIndex: Integer = 0; Count: Integer = MaxInt): WString;
    function TextInRectangle(Left, Top, Right, Bottom: Integer): WString; overload;
    function TextInRectangle(Rectangle: TRect): WString; overload;
    procedure UpdatePage;
    function WebLinkAtPos(X, Y: Integer): Integer;

    property Annotation[Index: Integer]: TPdfAnnotation read GetAnnotation write SetAnnotation;
    property AnnotationCount: Integer read GetAnnotationCount;
    property Bitmap[Index: Integer]: TBitmap read GetBitmap;
    property BitmapCount: Integer read GetBitmapCount;
    property Canvas;
    property Character[Index: Integer]: WideChar read GetCharacter;
    property CharacterCount: Integer read GetCharacterCount;
    property CharacterOrigin[Index: Integer]: TPoint read GetCharacterOrigin;
    property CharacterRectangle[Index: Integer]: TRect read GetCharacterRectangle;
    property Charcode[Index: Integer]: WideChar read GetCharcode;
    property Find: FPDF_SCHHANDLE read FFind;
    property FontSize[Index: Integer]: Double read GetFontSize;
    property FormField[Index: Integer]: WString read GetFormField write SetFormField;
    property FormFieldCount: Integer read GetFormFieldCount;
    property FormFieldFlags[Index: Integer]: TPdfFormFieldFlags read GetFormFieldFlags;
    property Image[Index: Integer]: TPdfImage read GetImage;
    property ImageCount: Integer read GetImageCount;
    property LinkAnnotation[Index: Integer]: TLinkAnnotation read GetLinkAnnotation;
    property LinkAnnotationCount: Integer read GetLinkAnnotationCount;
    property ObjectBitmap[Index: Integer]: TBitmap read GetObjectBitmap;
    property ObjectBounds[Index: Integer]: TPdfRectangle read GetObjectBounds;
    property ObjectCount: Integer read GetObjectCount;
    property ObjectHandle[Index: Integer]: Pointer read GetObjectHandle;
    property ObjectTransparent[Index: Integer]: Boolean read GetObjectTransparent;
    property ObjectType[Index: Integer]: TObjectType read GetObjectType;
    property Page: FPDF_PAGE read FPage;
    property PageBounds: TPdfRectangle read GetPageBounds;
    property PageCount: Integer read GetPageCount;
    property PageHeight: Double read GetPageHeight;
    property PageLabel: WString read GetPageLabel;
    property PageRotation: TRotation read GetPageRotation write SetPageRotation;
    property PageWidth: Double read GetPageWidth;
    property Rectangle[Index: Integer]: TRect read GetRectangle;
    property TextPage: FPDF_TEXTPAGE read FTextPage;
    property Transparent: Boolean read GetTransparent;
    property WebLink[Index: Integer]: TWebLink read GetWebLink;
    property WebLinkCount: Integer read GetWebLinkCount;
    property WindowHandle;
  published
    property About: string read GetAbout write SetAbout stored False;
    property Active: Boolean read GetActive write SetActive default False;
    property Align;
    property Anchors;
    property Cache: Boolean read FCache write SetCache default True;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Options: TRenderOptions read FOptions write SetOptions default [reLCD];
    property PageNumber: Integer read FPageNumber write SetPageNumber default 1;
    property ParentShowHint;
    property Pdf: TPdf read FPdf write SetPdf;
    property PopupMenu;
    property Rotation: TRotation read FRotation write SetRotation default ro0;
    property ShowHint;
    property TabOrder;
    property TabStop;
{$ifdef D2010PLUS}
    property Touch;
{$endif D2010PLUS}
    property Visible;

{$ifndef FPC}
    property OnCanResize;
{$endif FPC}
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
{$ifdef D2010PLUS}
    property OnGesture;
{$endif D2010PLUS}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
{$ifdef D2009PLUS}
    property OnMouseActivate;
{$endif D2009PLUS}
    property OnMouseDown;
{$ifdef D2009PLUS}
    property OnMouseEnter;
    property OnMouseLeave;
{$endif D2009PLUS}
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPageChange: TNotifyEvent read FOnPageChange write FOnPageChange;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

var
  LibraryName: string = 'pdfium.dll';

function Loaded: Boolean;
procedure LoadLibrary;
procedure UnloadLibrary;

function DecodeDate(const Value: string; out DateTime: TDateTime; out DateTimeOffset: Integer): Boolean;

type TFPDFText_GetCharcode = function(text_page: FPDF_TEXTPAGE; index: Integer): LongWord; cdecl;

var
  PDFiumLibrary: HMODULE;
  // FPdfView
  FPDF_InitLibrary: TFPDF_InitLibrary;
  FPDF_InitLibraryWithConfig: TFPDF_InitLibraryWithConfig;
  FPDF_DestroyLibrary: TFPDF_DestroyLibrary;
  FPDF_SetSandBoxPolicy: TFPDF_SetSandBoxPolicy;
  FPDF_LoadDocument: TFPDF_LoadDocument;
  FPDF_LoadMemDocument: TFPDF_LoadMemDocument;
  FPDF_LoadCustomDocument: TFPDF_LoadCustomDocument;
  FPDF_GetFileVersion: TFPDF_GetFileVersion;
  FPDF_GetLastError: TFPDF_GetLastError;
  FPDF_DocumentHasValidCrossReferenceTable: TFPDF_DocumentHasValidCrossReferenceTable;
  FPDF_GetDocPermissions: TFPDF_GetDocPermissions;
  FPDF_GetSecurityHandlerRevision: TFPDF_GetSecurityHandlerRevision;
  FPDF_GetPageCount: TFPDF_GetPageCount;
  FPDF_LoadPage: TFPDF_LoadPage;
  FPDF_GetPageWidth: TFPDF_GetPageWidth;
  FPDF_GetPageHeight: TFPDF_GetPageHeight;
  FPDF_GetPageBoundingBox: TFPDF_GetPageBoundingBox;
  FPDF_GetPageSizeByIndex: TFPDF_GetPageSizeByIndex;
  FPDF_RenderPage: TFPDF_RenderPage;
  FPDF_RenderPageBitmap: TFPDF_RenderPageBitmap;
  FPDF_RenderPageBitmapWithMatrix: TFPDF_RenderPageBitmapWithMatrix;
  FPDF_ClosePage: TFPDF_ClosePage;
  FPDF_CloseDocument: TFPDF_CloseDocument;
  FPDF_DeviceToPage: TFPDF_DeviceToPage;
  FPDF_PageToDevice: TFPDF_PageToDevice;
  FPDFBitmap_Create: TFPDFBitmap_Create;
  FPDFBitmap_CreateEx: TFPDFBitmap_CreateEx;
  FPDFBitmap_GetFormat: TFPDFBitmap_GetFormat;
  FPDFBitmap_FillRect: TFPDFBitmap_FillRect;
  FPDFBitmap_GetBuffer: TFPDFBitmap_GetBuffer;
  FPDFBitmap_GetWidth: TFPDFBitmap_GetWidth;
  FPDFBitmap_GetHeight: TFPDFBitmap_GetHeight;
  FPDFBitmap_GetStride: TFPDFBitmap_GetStride;
  FPDFBitmap_Destroy: TFPDFBitmap_Destroy;
  FPDF_VIEWERREF_GetPrintScaling: TFPDF_VIEWERREF_GetPrintScaling;
  FPDF_VIEWERREF_GetNumCopies: TFPDF_VIEWERREF_GetNumCopies;
  FPDF_VIEWERREF_GetPrintPageRange: TFPDF_VIEWERREF_GetPrintPageRange;
  FPDF_VIEWERREF_GetPrintPageRangeCount: TFPDF_VIEWERREF_GetPrintPageRangeCount;
  FPDF_VIEWERREF_GetPrintPageRangeElement: TFPDF_VIEWERREF_GetPrintPageRangeElement;
  FPDF_VIEWERREF_GetDuplex: TFPDF_VIEWERREF_GetDuplex;
  FPDF_VIEWERREF_GetName: TFPDF_VIEWERREF_GetName;
  FPDF_CountNamedDests: TFPDF_CountNamedDests;
  FPDF_GetNamedDestByName: TFPDF_GetNamedDestByName;
  FPDF_GetNamedDest: TFPDF_GetNamedDest;
  // FPdfText
  FPDFText_LoadPage: TFPDFText_LoadPage;
  FPDFText_ClosePage: TFPDFText_ClosePage;
  FPDFText_CountChars: TFPDFText_CountChars;
  FPDFText_GetUnicode: TFPDFText_GetUnicode;
  FPDFText_GetCharcode: TFPDFText_GetCharcode;
  FPDFText_GetFontSize: TFPDFText_GetFontSize;
  FPDFText_GetFontInfo: TFPDFText_GetFontInfo;
  FPDFText_GetCharAngle: TFPDFText_GetCharAngle;
  FPDFText_GetCharBox: TFPDFText_GetCharBox;
  FPDFText_GetCharOrigin: TFPDFText_GetCharOrigin;
  FPDFText_GetCharIndexAtPos: TFPDFText_GetCharIndexAtPos;
  FPDFText_GetText: TFPDFText_GetText;
  FPDFText_CountRects: TFPDFText_CountRects;
  FPDFText_GetRect: TFPDFText_GetRect;
  FPDFText_GetBoundedText: TFPDFText_GetBoundedText;
  FPDFText_FindStart: TFPDFText_FindStart;
  FPDFText_FindNext: TFPDFText_FindNext;
  FPDFText_FindPrev: TFPDFText_FindPrev;
  FPDFText_GetSchResultIndex: TFPDFText_GetSchResultIndex;
  FPDFText_GetSchCount: TFPDFText_GetSchCount;
  FPDFText_FindClose: TFPDFText_FindClose;
  FPDFLink_LoadWebLinks: TFPDFLink_LoadWebLinks;
  FPDFLink_CountWebLinks: TFPDFLink_CountWebLinks;
  FPDFLink_GetURL: TFPDFLink_GetURL;
  FPDFLink_CountRects: TFPDFLink_CountRects;
  FPDFLink_GetRect: TFPDFLink_GetRect;
  FPDFLink_GetTextRange: TFPDFLink_GetTextRange;
  FPDFLink_CloseWebLinks: TFPDFLink_CloseWebLinks;
  // FPdfPpo
  FPDF_ImportPages: TFPDF_ImportPages;
  FPDF_ImportNPagesToOne: TFPDF_ImportNPagesToOne;
  FPDF_CopyViewerPreferences: TFPDF_CopyViewerPreferences;
  // FPdfSysFontInfo
  FPDF_GetDefaultTTFMap: TFPDF_GetDefaultTTFMap;
  FPDF_AddInstalledFont: TFPDF_AddInstalledFont;
  FPDF_SetSystemFontInfo: TFPDF_SetSystemFontInfo;
  FPDF_GetDefaultSystemFontInfo: TFPDF_GetDefaultSystemFontInfo;
  FPDF_FreeDefaultSystemFontInfo: TFPDF_FreeDefaultSystemFontInfo;
  // FPdfSave
  FPDF_SaveAsCopy: TFPDF_SaveAsCopy;
  FPDF_SaveWithVersion: TFPDF_SaveWithVersion;
  // FPdfDoc
  FPDFBookmark_GetFirstChild: TFPDFBookmark_GetFirstChild;
  FPDFBookmark_GetNextSibling: TFPDFBookmark_GetNextSibling;
  FPDFBookmark_GetTitle: TFPDFBookmark_GetTitle;
  FPDFBookmark_Find: TFPDFBookmark_Find;
  FPDFBookmark_GetDest: TFPDFBookmark_GetDest;
  FPDFBookmark_GetAction: TFPDFBookmark_GetAction;
  FPDFAction_GetType: TFPDFAction_GetType;
  FPDFAction_GetDest: TFPDFAction_GetDest;
  FPDFAction_GetFilePath: TPDFAction_GetFilePath;
  FPDFAction_GetURIPath: TFPDFAction_GetURIPath;
  FPDFDest_GetDestPageIndex: TFPDFDest_GetDestPageIndex;
  FPDFDest_GetView: TFPDFDest_GetView;
  FPDFDest_GetLocationInPage: TFPDFDest_GetLocationInPage;
  FPDFLink_GetLinkAtPoint: TFPDFLink_GetLinkAtPoint;
  FPDFLink_GetLinkZOrderAtPoint: TFPDFLink_GetLinkZOrderAtPoint;
  FPDFLink_GetDest: TFPDFLink_GetDest;
  FPDFLink_GetAction: TFPDFLink_GetAction;
  FPDFLink_Enumerate: TFPDFLink_Enumerate;
  FPDFLink_GetAnnotRect: TFPDFLink_GetAnnotRect;
  FPDFLink_CountQuadPoints: TFPDFLink_CountQuadPoints;
  FPDFLink_GetQuadPoints: TFPDFLink_GetQuadPoints;
  FPDF_GetMetaText: TFPDF_GetMetaText;
  FPDF_GetPageLabel: TFPDF_GetPageLabel;
  // FPdfDataAvail
  FPDFAvail_Create: TFPDFAvail_Create;
  FPDFAvail_Destroy: TFPDFAvail_Destroy;
  FPDFAvail_IsDocAvail: TFPDFAvail_IsDocAvail;
  FPDFAvail_GetDocument: TFPDFAvail_GetDocument;
  FPDFAvail_GetFirstPageNum: TFPDFAvail_GetFirstPageNum;
  FPDFAvail_IsPageAvail: TFPDFAvail_IsPageAvail;
  FPDFAvail_IsFormAvail: TFPDFAvail_IsFormAvail;
  FPDFAvail_IsLinearized: TFPDFAvail_IsLinearized;
  // FPdfProgressive
  FPDF_RenderPageBitmap_Start: TFPDF_RenderPageBitmap_Start;
  FPDF_RenderPage_Continue: TFPDF_RenderPage_Continue;
  FPDF_RenderPage_Close: TFPDF_RenderPage_Close;
  // FPdfTransformPage
  FPDFPage_SetMediaBox: TFPDFPage_SetMediaBox;
  FPDFPage_SetCropBox: TFPDFPage_SetCropBox;
  FPDFPage_SetBleedBox: TFPDFPage_SetBleedBox;
  FPDFPage_SetTrimBox: TFPDFPage_SetTrimBox;
  FPDFPage_SetArtBox: TFPDFPage_SetArtBox;
  FPDFPage_GetMediaBox: TFPDFPage_GetMediaBox;
  FPDFPage_GetCropBox: TFPDFPage_GetCropBox;
  FPDFPage_GetBleedBox: TFPDFPage_GetBleedBox;
  FPDFPage_GetTrimBox: TFPDFPage_GetTrimBox;
  FPDFPage_GetArtBox: TFPDFPage_GetArtBox;
  FPDFPage_TransFormWithClip: TFPDFPage_TransFormWithClip;
  FPDFPageObj_TransformClipPath: TFPDFPageObj_TransformClipPath;
  FPDFPageObj_GetClipPath: TFPDFPageObj_GetClipPath;
  FPDFClipPath_CountPaths: TFPDFClipPath_CountPaths;
  FPDFClipPath_CountPathSegments: TFPDFClipPath_CountPathSegments;
  FPDFClipPath_GetPathSegment: TFPDFClipPath_GetPathSegment;
  FPDF_CreateClipPath: TFPDF_CreateClipPath;
  FPDF_DestroyClipPath: TFPDF_DestroyClipPath;
  FPDFPage_InsertClipPath: TFPDFPage_InsertClipPath;
  // FPdfExt
  FSDK_SetUnSpObjProcessHandler: TFSDK_SetUnSpObjProcessHandler;
  FSDK_SetTimeFunction: TFSDK_SetTimeFunction;
  FSDK_SetLocaltimeFunction: TFSDK_SetLocaltimeFunction;
  FPDFDoc_GetPageMode: TFPDFDoc_GetPageMode;
  // FPdfEdit
  FPDF_CreateNewDocument: TFPDF_CreateNewDocument;
  FPDFPage_New: TFPDFPage_New;
  FPDFPage_Delete: TFPDFPage_Delete;
  FPDFPage_GetRotation: TFPDFPage_GetRotation;
  FPDFPage_SetRotation: TFPDFPage_SetRotation;
  FPDFPage_InsertObject: TFPDFPage_InsertObject;
  FPDFPage_RemoveObject: TFPDFPage_RemoveObject;
  FPDFPage_CountObjects: TFPDFPage_CountObjects;
  FPDFPage_GetObject: TFPDFPage_GetObject;
  FPDFPage_HasTransparency: TFPDFPage_HasTransparency;
  FPDFPage_GenerateContent: TFPDFPage_GenerateContent;
  FPDFPageObj_Destroy: TFPDFPageObj_Destroy;
  FPDFPageObj_HasTransparency: TFPDFPageObj_HasTransparency;
  FPDFPageObj_GetType: TFPDFPageObj_GetType;
  FPDFPageObj_Transform: TFPDFPageObj_Transform;
  FPDFPage_TransformAnnots: TFPDFPage_TransformAnnots;
  FPDFPageObj_NewImageObj: TFPDFPageObj_NewImageObj;
  FPDFPageObj_CountMarks: TFPDFPageObj_CountMarks;
  FPDFPageObj_GetMark: TFPDFPageObj_GetMark;
  FPDFPageObj_AddMark: TFPDFPageObj_AddMark;
  FPDFPageObj_RemoveMark: TFPDFPageObj_RemoveMark;
  FPDFPageObjMark_GetName: TFPDFPageObjMark_GetName;
  FPDFPageObjMark_CountParams: TFPDFPageObjMark_CountParams;
  FPDFPageObjMark_GetParamKey: TFPDFPageObjMark_GetParamKey;
  FPDFPageObjMark_GetParamValueType: TFPDFPageObjMark_GetParamValueType;
  FPDFPageObjMark_GetParamIntValue: TFPDFPageObjMark_GetParamIntValue;
  FPDFPageObjMark_GetParamStringValue: TFPDFPageObjMark_GetParamStringValue;
  FPDFPageObjMark_GetParamBlobValue: TFPDFPageObjMark_GetParamBlobValue;
  FPDFPageObjMark_SetIntParam: TFPDFPageObjMark_SetIntParam;
  FPDFPageObjMark_SetStringParam: TFPDFPageObjMark_SetStringParam;
  FPDFPageObjMark_SetBlobParam: TFPDFPageObjMark_SetBlobParam;
  FPDFPageObjMark_RemoveParam: TFPDFPageObjMark_RemoveParam;
  FPDFImageObj_LoadJpegFile: TFPDFImageObj_LoadJpegFile;
  FPDFImageObj_LoadJpegFileInline: TFPDFImageObj_LoadJpegFileInline;
  FPDFImageObj_GetMatrix: TFPDFImageObj_GetMatrix;
  FPDFImageObj_SetMatrix: TFPDFImageObj_SetMatrix;
  FPDFImageObj_SetBitmap: TFPDFImageObj_SetBitmap;
  FPDFImageObj_GetBitmap: TFPDFImageObj_GetBitmap;
  FPDFImageObj_GetImageDataDecoded: TFPDFImageObj_GetImageDataDecoded;
  FPDFImageObj_GetImageDataRaw: TFPDFImageObj_GetImageDataRaw;
  FPDFImageObj_GetImageFilterCount: TFPDFImageObj_GetImageFilterCount;
  FPDFImageObj_GetImageFilter: TFPDFImageObj_GetImageFilter;
  FPDFImageObj_GetImageMetadata: TFPDFImageObj_GetImageMetadata;
  FPDFPageObj_CreateNewPath: TFPDFPageObj_CreateNewPath;
  FPDFPageObj_CreateNewRect: TFPDFPageObj_CreateNewRect;
  FPDFPageObj_GetBounds: TFPDFPageObj_GetBounds;
  FPDFPageObj_SetBlendMode: TFPDFPageObj_SetBlendMode;
  FPDFPageObj_SetStrokeColor: TFPDFPageObj_SetStrokeColor;
  FPDFPageObj_GetStrokeColor: TFPDFPageObj_GetStrokeColor;
  FPDFPageObj_SetStrokeWidth: TFPDFPageObj_SetStrokeWidth;
  FPDFPageObj_GetStrokeWidth: TFPDFPageObj_GetStrokeWidth;
  FPDFPageObj_GetLineJoin: TFPDFPageObj_GetLineJoin;
  FPDFPageObj_SetLineJoin: TFPDFPageObj_SetLineJoin;
  FPDFPageObj_GetLineCap: TFPDFPageObj_GetLineCap;
  FPDFPageObj_SetLineCap: TFPDFPageObj_SetLineCap;
  FPDFPageObj_SetFillColor: TFPDFPageObj_SetFillColor;
  FPDFPageObj_GetFillColor: TFPDFPageObj_GetFillColor;
  FPDFPath_CountSegments: TFPDFPath_CountSegments;
  FPDFPath_GetPathSegment: TFPDFPath_GetPathSegment;
  FPDFPathSegment_GetPoint: TFPDFPathSegment_GetPoint;
  FPDFPathSegment_GetType: TFPDFPathSegment_GetType;
  FPDFPathSegment_GetClose: TFPDFPathSegment_GetClose;
  FPDFPath_MoveTo: TFPDFPath_MoveTo;
  FPDFPath_LineTo: TFPDFPath_LineTo;
  FPDFPath_BezierTo: TFPDFPath_BezierTo;
  FPDFPath_Close: TFPDFPath_Close;
  FPDFPath_SetDrawMode: TFPDFPath_SetDrawMode;
  FPDFPath_GetDrawMode: TFPDFPath_GetDrawMode;
  FPDFPath_GetMatrix: TFPDFPath_GetMatrix;
  FPDFPath_SetMatrix: TFPDFPath_SetMatrix;
  FPDFPageObj_NewTextObj: TFPDFPageObj_NewTextObj;
  FPDFText_SetText: TFPDFText_SetText;
  FPDFText_LoadFont: TFPDFText_LoadFont;
  FPDFText_LoadStandardFont: TFPDFText_LoadStandardFont;
  FPDFText_GetMatrix: TFPDFText_GetMatrix;
  FPDFTextObj_GetFontSize: TFPDFTextObj_GetFontSize;
  FPDFFont_Close: TFPDFFont_Close;
  FPDFPageObj_CreateTextObj: TFPDFPageObj_CreateTextObj;
  FPDFText_GetTextRenderMode: TFPDFText_GetTextRenderMode;
  FPDFTextObj_GetFontName: TFPDFTextObj_GetFontName;
  FPDFTextObj_GetText: TFPDFTextObj_GetText;
  FPDFFormObj_CountObjects: TFPDFFormObj_CountObjects;
  FPDFFormObj_GetObject: TFPDFFormObj_GetObject;
  FPDFFormObj_GetMatrix: TFPDFFormObj_GetMatrix;
//  FPDFPageObj_GetObjectType: TFPDFPageObj_GetObjectType;
  FPDFPageObj_GetImage: TFPDFPageObj_GetImage;
  FPDFPageObj_GetDIB: TFPDFPageObj_GetDIB;
//  FPDFPageObj_GetBoundingBox: TFPDFPageObj_GetBoundingBox;
  // FPdfFormFill
  FPDFDOC_InitFormFillEnvironment: TFPDFDOC_InitFormFillEnvironment;
  FPDFDOC_ExitFormFillEnvironment: TFPDFDOC_ExitFormFillEnvironment;
  FORM_OnAfterLoadPage: TFORM_OnAfterLoadPage;
  FORM_OnBeforeClosePage: TFORM_OnBeforeClosePage;
  FORM_DoDocumentJSAction: TFORM_DoDocumentJSAction;
  FORM_DoDocumentOpenAction: TFORM_DoDocumentOpenAction;
  FORM_DoDocumentAAction: TFORM_DoDocumentAAction;
  FORM_DoPageAAction: TFORM_DoPageAAction;
  FORM_OnMouseMove: TFORM_OnMouseMove;
  FORM_OnFocus: TFORM_OnFocus;
  FORM_OnLButtonDown: TFORM_OnLButtonDown;
  FORM_OnLButtonUp: TFORM_OnLButtonUp;
  FORM_OnLButtonDoubleClick: TFORM_OnLButtonDoubleClick;
  FORM_OnKeyDown: TFORM_OnKeyDown;
  FORM_OnKeyUp: TFORM_OnKeyUp;
  FORM_OnChar: TFORM_OnChar;
  FORM_GetFocusedText:  TFORM_GetFocusedText;
  FORM_GetSelectedText: TFORM_GetSelectedText;
  FORM_ReplaceSelection: TFORM_ReplaceSelection;
  FORM_CanUndo: TFORM_CanUndo;
  FORM_CanRedo: TFORM_CanRedo;
  FORM_Undo: TFORM_Undo;
  FORM_Redo: TFORM_Redo;
  FORM_ForceToKillFocus: TFORM_ForceToKillFocus;
  FPDFPage_HasFormFieldAtPoint: TFPDFPage_HasFormFieldAtPoint;
  FPDFPage_FormFieldZOrderAtPoint: TFPDFPage_FormFieldZOrderAtPoint;
  FPDF_SetFormFieldHighlightColor: TFPDF_SetFormFieldHighlightColor;
  FPDF_SetFormFieldHighlightAlpha: TFPDF_SetFormFieldHighlightAlpha;
  FPDF_RemoveFormFieldHighlight: TFPDF_RemoveFormFieldHighlight;
  FPDF_FFLDraw: TFPDF_FFLDraw;
  FPDF_GetFormType: TFPDF_GetFormType;
  FORM_SetIndexSelected: TFORM_SetIndexSelected;
  FORM_IsIndexSelected: TFORM_IsIndexSelected;
  FPDF_LoadXFA: TFPDF_LoadXFA;
  // FPdfSearchEx
  FPDFText_GetCharIndexFromTextIndex: TFPDFText_GetCharIndexFromTextIndex;
  FPDFText_GetTextIndexFromCharIndex: TFPDFText_GetTextIndexFromCharIndex;
  // FPdfFlatten
  FPDFPage_Flatten: TFPDFPage_Flatten;
  // FPdfStructTree
  FPDF_StructTree_GetForPage: TFPDF_StructTree_GetForPage;
  FPDF_StructTree_Close: TFPDF_StructTree_Close;
  FPDF_StructTree_CountChildren: TFPDF_StructTree_CountChildren;
  FPDF_StructTree_GetChildAtIndex: TFPDF_StructTree_GetChildAtIndex;
  FPDF_StructElement_GetAltText: TFPDF_StructElement_GetAltText;
  FPDF_StructElement_GetMarkedContentID: TFPDF_StructElement_GetMarkedContentID;
  FPDF_StructElement_GetType: TFPDF_StructElement_GetType;
  FPDF_StructElement_GetTitle: TFPDF_StructElement_GetTitle;
  FPDF_StructElement_CountChildren: TFPDF_StructElement_CountChildren;
  FPDF_StructElement_GetChildAtIndex: TFPDF_StructElement_GetChildAtIndex;
  // FPdfAnnot
  FPDFAnnot_IsSupportedSubtype: TFPDFAnnot_IsSupportedSubtype;
  FPDFPage_CreateAnnot: TFPDFPage_CreateAnnot;
  FPDFPage_GetAnnotCount: TFPDFPage_GetAnnotCount;
  FPDFPage_GetAnnot: TFPDFPage_GetAnnot;
  FPDFPage_GetAnnotIndex: TFPDFPage_GetAnnotIndex;
  FPDFPage_CloseAnnot: TFPDFPage_CloseAnnot;
  FPDFPage_RemoveAnnot: TFPDFPage_RemoveAnnot;
  FPDFAnnot_GetSubtype: TFPDFAnnot_GetSubtype;
  FPDFAnnot_IsObjectSupportedSubtype: TFPDFAnnot_IsObjectSupportedSubtype;
  FPDFAnnot_UpdateObject: TFPDFAnnot_UpdateObject;
  FPDFAnnot_AppendObject: TFPDFAnnot_AppendObject;
  FPDFAnnot_GetObjectCount: TFPDFAnnot_GetObjectCount;
  FPDFAnnot_GetObject: TFPDFAnnot_GetObject;
  FPDFAnnot_RemoveObject: TFPDFAnnot_RemoveObject;
  FPDFAnnot_SetColor: TFPDFAnnot_SetColor;
  FPDFAnnot_GetColor: TFPDFAnnot_GetColor;
  FPDFAnnot_HasAttachmentPoints: TFPDFAnnot_HasAttachmentPoints;
  FPDFAnnot_SetAttachmentPoints: TFPDFAnnot_SetAttachmentPoints;
  FPDFAnnot_AppendAttachmentPoints: TFPDFAnnot_AppendAttachmentPoints;
  FPDFAnnot_CountAttachmentPoints: TFPDFAnnot_CountAttachmentPoints;
  FPDFAnnot_GetAttachmentPoints: TFPDFAnnot_GetAttachmentPoints;
  FPDFAnnot_SetRect: TFPDFAnnot_SetRect;
  FPDFAnnot_GetRect: TFPDFAnnot_GetRect;
  FPDFAnnot_HasKey: TFPDFAnnot_HasKey;
  FPDFAnnot_GetValueType: TFPDFAnnot_GetValueType;
  FPDFAnnot_SetStringValue: TFPDFAnnot_SetStringValue;
  FPDFAnnot_GetStringValue: TFPDFAnnot_GetStringValue;
  FPDFAnnot_GetNumberValue: TFPDFAnnot_GetNumberValue;
  FPDFAnnot_SetAP: TFPDFAnnot_SetAP;
  FPDFAnnot_GetAP: TFPDFAnnot_GetAP;
  FPDFAnnot_GetLinkedAnnot: TFPDFAnnot_GetLinkedAnnot;
  FPDFAnnot_GetFlags: TFPDFAnnot_GetFlags;
  FPDFAnnot_SetFlags: TFPDFAnnot_SetFlags;
  FPDFAnnot_GetFormFieldFlags: TFPDFAnnot_GetFormFieldFlags;
  FPDFAnnot_GetFormFieldAtPoint: TFPDFAnnot_GetFormFieldAtPoint;
  FPDFAnnot_GetOptionCount: TFPDFAnnot_GetOptionCount;
  FPDFAnnot_GetOptionLabel: TFPDFAnnot_GetOptionLabel;
  FPDFAnnot_GetFontSize: TFPDFAnnot_GetFontSize;
  FPDFAnnot_IsChecked: TFPDFAnnot_IsChecked;
  // FPdfAttachment
  FPDFDoc_GetAttachmentCount: TFPDFDoc_GetAttachmentCount;
  FPDFDoc_AddAttachment: TFPDFDoc_AddAttachment;
  FPDFDoc_GetAttachment: TFPDFDoc_GetAttachment;
  FPDFDoc_DeleteAttachment: TFPDFDoc_DeleteAttachment;
  FPDFAttachment_GetName: TFPDFAttachment_GetName;
  FPDFAttachment_HasKey: TFPDFAttachment_HasKey;
  FPDFAttachment_GetValueType: TFPDFAttachment_GetValueType;
  FPDFAttachment_SetStringValue: TFPDFAttachment_SetStringValue;
  FPDFAttachment_GetStringValue: TFPDFAttachment_GetStringValue;
  FPDFAttachment_SetFile: TFPDFAttachment_SetFile;
  FPDFAttachment_GetFile: TFPDFAttachment_GetFile;
  // FPdfCatalog
  FPDFCatalog_IsTagged: TFPDFCatalog_IsTagged;
  // FPdfThumbnail
  FPDFPage_GetDecodedThumbnailData: TFPDFPage_GetDecodedThumbnailData;
  FPDFPage_GetRawThumbnailData: TFPDFPage_GetRawThumbnailData;
  FPDFPage_GetThumbnailAsBitmap: TFPDFPage_GetThumbnailAsBitmap;

implementation

uses {$ifdef D6PLUS} DateUtils, {$endif D6PLUS} Forms, FPdfFWLEvent {$ifdef FPC}, LMessages {$endif FPC};

const
  AboutInfo = 'Version 5.4, Copyright (c) 2014-2019 WINSOFT, https://www.winsoft.sk';

{$ifdef D5} // Delphi 5
function Get8087CW: Word;
asm
  PUSH    0
  FNSTCW  [ESP].Word
  POP     EAX
end;
{$endif D5}

type
  TArithmeticMask = record
    Fpu: Word;
    Sse: Word;
  end;

function SetArithmeticMask: TArithmeticMask;
var ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Result.Fpu := ControlWord and $3F;
  Set8087CW(ControlWord or $3F);

{$ifdef FPC}
  ControlWord := GetSSECSR;
  Result.Sse := ControlWord and $1F80;
  SetSSECSR(ControlWord or $1F80);
{$else}
  {$ifdef CPUX64}
  ControlWord := GetMXCSR;
  Result.Sse := ControlWord and $1F80;
  SetMXCSR(ControlWord or $1F80);
  {$endif CPUX64}
{$endif FPC}
end;

procedure RestoreArithmeticMask(Mask: TArithmeticMask);
var ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Set8087CW((ControlWord and (not $3F)) or Mask.Fpu);

{$ifdef FPC}
  ControlWord := GetSSECSR;
  SetSSECSR((ControlWord and (not $1F80)) or Mask.Sse);
{$else}
  {$ifdef CPUX64}
  ControlWord := GetMXCSR;
  SetMXCSR((ControlWord and (not $1F80)) or Mask.Sse);
  {$endif CPUX64}
{$endif FPC}
end;

function IsDigit(Value: Char): Boolean;
begin
  Result := (Value >= '0') and (Value <= '9');
end;

function ToDigit(Value: Char): Integer;
begin
  Result := Ord(Value) - Ord('0');
end;

function DecodeDate(const Value: string; out DateTime: TDateTime; out DateTimeOffset: Integer): Boolean;
var
  Year, Month, Day, Hour, Minute, Second, MilliSecond, HourOffset, MinuteOffset: Integer;
begin
  Result := False;
  if Length(Value) <> 23 then
    Exit;
  if (Value[1] <> 'D') or (Value[2] <> ':') then
    Exit;

  if not IsDigit(Value[3]) or not IsDigit(Value[4]) or not IsDigit(Value[5]) or not IsDigit(Value[6]) then
    Exit;
  Year := 1000 * ToDigit(Value[3]) + 100 * ToDigit(Value[4]) + 10 * ToDigit(Value[5]) + ToDigit(Value[6]);

  if not IsDigit(Value[7]) or not IsDigit(Value[8]) then
    Exit;
  Month := 10 * ToDigit(Value[7]) + ToDigit(Value[8]);

  if not IsDigit(Value[9]) or not IsDigit(Value[10]) then
    Exit;
  Day := 10 * ToDigit(Value[9]) + ToDigit(Value[10]);

  if not IsDigit(Value[11]) or not IsDigit(Value[12]) then
    Exit;
  Hour := 10 * ToDigit(Value[11]) + ToDigit(Value[12]);

  if not IsDigit(Value[13]) or not IsDigit(Value[14]) then
    Exit;
  Minute := 10 * ToDigit(Value[13]) + ToDigit(Value[14]);

  if not IsDigit(Value[15]) or not IsDigit(Value[16]) then
    Exit;
  Second := 10 * ToDigit(Value[15]) + ToDigit(Value[16]);

  MilliSecond := 0;

{$ifdef D6PLUS}
  if not TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MilliSecond, DateTime) then
    Exit;
{$else}
  try
    DateTime := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, MilliSecond);
  except
    on E: Exception do
      Exit;
  end;
{$endif D6PLUS}

  if (Value[17] <> '+') and (Value[17] <> '-') and (Value[17] <> 'Z') then
    Exit;

  if not IsDigit(Value[18]) or not IsDigit(Value[19]) or (Value[20] <> '''') then
    Exit;
  HourOffset := 10 * ToDigit(Value[18]) + ToDigit(Value[19]);
  if HourOffset > 23 then
    Exit;

  if not IsDigit(Value[21]) or not IsDigit(Value[22]) or (Value[23] <> '''') then
    Exit;
  MinuteOffset := 10 * ToDigit(Value[21]) + ToDigit(Value[22]);
  if MinuteOffset > 59 then
    Exit;

  DateTimeOffset := HourOffset * 60 + MinuteOffset;
  case Value[17] of
    '-': DateTimeOffset := -DateTimeOffset;
    'Z': if DateTimeOffset <> 0 then Exit;
  end;

  Result := True;
end;

const
  BlendModes: array [TPdfBlendMode] of AnsiString = (
    '', 'Color', 'ColorBurn', 'ColorDodge', 'Darken', 'Difference',
    'Exclusion', 'HardLight', 'Hue', 'Lighten', 'Luminosity', 'Multiply', 'Normal',
    'Overlay', 'Saturation', 'Screen', 'SoftLight');

function EncodeBlendMode(BlendMode: TPdfBlendMode): AnsiString;
begin
  Result := BlendModes[BlendMode];
end;

function EncodeLineCap(LineCap: TPdfLineCap): Integer;
begin
  case LineCap of
    lcButt: Result := FPDF_LINECAP_BUTT;
    lcRound: Result := FPDF_LINECAP_ROUND;
    lcProjectingSquare: Result := FPDF_LINECAP_PROJECTING_SQUARE;
    else Result := FPDF_LINECAP_BUTT;
  end;
end;

function EncodeLineJoin(LineJoin: TPdfLineJoin): Integer;
begin
  case LineJoin of
   ljMiter: Result := FPDF_LINEJOIN_MITER;
   ljRound: Result := FPDF_LINEJOIN_ROUND;
   ljBevel: Result := FPDF_LINEJOIN_BEVEL;
   else Result := FPDF_LINEJOIN_MITER;
  end;
end;

function DecodeAnnotationSubtype(Subtype: Integer): TPdfAnnotationSubtype;
begin
  case Subtype of
    FPDF_ANNOT_UNKNOWN: Result := anUnknown;
    FPDF_ANNOT_TEXT: Result := anText;
    FPDF_ANNOT_LINK: Result := anLink;
    FPDF_ANNOT_FREETEXT: Result := anFreeText;
    FPDF_ANNOT_LINE: Result := anLine;
    FPDF_ANNOT_SQUARE: Result := anSquare;
    FPDF_ANNOT_CIRCLE: Result := anCircle;
    FPDF_ANNOT_POLYGON: Result := anPolygon;
    FPDF_ANNOT_POLYLINE: Result := anPolyLine;
    FPDF_ANNOT_HIGHLIGHT: Result := anHighlight;
    FPDF_ANNOT_UNDERLINE: Result := anUnderline;
    FPDF_ANNOT_SQUIGGLY: Result := anSquiggly;
    FPDF_ANNOT_STRIKEOUT: Result := anStrikeout;
    FPDF_ANNOT_STAMP: Result := anStamp;
    FPDF_ANNOT_CARET: Result := anCaret;
    FPDF_ANNOT_INK: Result := anInk;
    FPDF_ANNOT_POPUP: Result := anPopup;
    FPDF_ANNOT_FILEATTACHMENT: Result := anFileAttachment;
    FPDF_ANNOT_SOUND: Result := anSound;
    FPDF_ANNOT_MOVIE: Result := anMovie;
    FPDF_ANNOT_WIDGET: Result := anWidget;
    FPDF_ANNOT_SCREEN: Result := anScreen;
    FPDF_ANNOT_PRINTERMARK: Result := anPrinterMark;
    FPDF_ANNOT_TRAPNET: Result := anTrapNet;
    FPDF_ANNOT_WATERMARK: Result := anWaterMark;
    FPDF_ANNOT_THREED: Result := anThreed;
    FPDF_ANNOT_RICHMEDIA: Result := anRichMedia;
    FPDF_ANNOT_XFAWIDGET: Result := anXfaWidget;
    else Result := anUnknown;
  end;
end;

function EncodeAnnotationSubtype(Subtype: TPdfAnnotationSubtype): Integer;
begin
  case Subtype of
    anUnknown: Result := FPDF_ANNOT_UNKNOWN;
    anText: Result := FPDF_ANNOT_TEXT;
    anLink: Result := FPDF_ANNOT_LINK;
    anFreeText: Result := FPDF_ANNOT_FREETEXT;
    anLine: Result := FPDF_ANNOT_LINE;
    anSquare: Result := FPDF_ANNOT_SQUARE;
    anCircle: Result := FPDF_ANNOT_CIRCLE;
    anPolygon: Result := FPDF_ANNOT_POLYGON;
    anPolyLine: Result := FPDF_ANNOT_POLYLINE;
    anHighlight: Result := FPDF_ANNOT_HIGHLIGHT;
    anUnderline: Result := FPDF_ANNOT_UNDERLINE;
    anSquiggly: Result := FPDF_ANNOT_SQUIGGLY;
    anStrikeout: Result := FPDF_ANNOT_STRIKEOUT;
    anStamp: Result := FPDF_ANNOT_STAMP;
    anCaret: Result := FPDF_ANNOT_CARET;
    anInk: Result := FPDF_ANNOT_INK;
    anPopup: Result := FPDF_ANNOT_POPUP;
    anFileAttachment: Result := FPDF_ANNOT_FILEATTACHMENT;
    anSound: Result := FPDF_ANNOT_SOUND;
    anMovie: Result := FPDF_ANNOT_MOVIE;
    anWidget: Result := FPDF_ANNOT_WIDGET;
    anScreen: Result := FPDF_ANNOT_SCREEN;
    anPrinterMark: Result := FPDF_ANNOT_PRINTERMARK;
    anTrapNet: Result := FPDF_ANNOT_TRAPNET;
    anWaterMark: Result := FPDF_ANNOT_WATERMARK;
    anThreed: Result := FPDF_ANNOT_THREED;
    anRichMedia: Result := FPDF_ANNOT_RICHMEDIA;
    anXfaWidget: Result := FPDF_ANNOT_XFAWIDGET;
    else Result := FPDF_ANNOT_UNKNOWN;
  end;
end;

function DecodeAnnotationFlags(Flags: Integer): TPdfAnnotationFlags;
begin
  Result := [];
  if (Flags and FPDF_ANNOT_FLAG_INVISIBLE) <> 0 then
    Result := Result + [afInvisible];
  if (Flags and FPDF_ANNOT_FLAG_HIDDEN) <> 0 then
    Result := Result + [afHidden];
  if (Flags and FPDF_ANNOT_FLAG_PRINT) <> 0 then
    Result := Result + [afPrint];
  if (Flags and FPDF_ANNOT_FLAG_NOZOOM) <> 0 then
    Result := Result + [afNoZoom];
  if (Flags and FPDF_ANNOT_FLAG_NOROTATE) <> 0 then
    Result := Result + [afNoRotate];
  if (Flags and FPDF_ANNOT_FLAG_NOVIEW) <> 0 then
    Result := Result + [afNoView];
  if (Flags and FPDF_ANNOT_FLAG_READONLY) <> 0 then
    Result := Result + [afReadOnly];
  if (Flags and FPDF_ANNOT_FLAG_LOCKED) <> 0 then
    Result := Result + [afLocked];
  if (Flags and FPDF_ANNOT_FLAG_TOGGLENOVIEW) <> 0 then
    Result := Result + [afToggleNoView];
end;

function EncodeAnnotationFlags(Flags: TPdfAnnotationFlags): Integer;
begin
  Result := 0;
  if afInvisible in Flags then
    Result := Result or FPDF_ANNOT_FLAG_INVISIBLE;
  if afHidden in Flags then
    Result := Result or FPDF_ANNOT_FLAG_HIDDEN;
  if afPrint in Flags then
    Result := Result or FPDF_ANNOT_FLAG_PRINT;
  if afNoZoom in Flags then
    Result := Result or FPDF_ANNOT_FLAG_NOZOOM;
  if afNoRotate in Flags then
    Result := Result or FPDF_ANNOT_FLAG_NOROTATE;
  if afNoView in Flags then
    Result := Result or FPDF_ANNOT_FLAG_NOVIEW;
  if afReadOnly in Flags then
    Result := Result or FPDF_ANNOT_FLAG_READONLY;
  if afLocked in Flags then
    Result := Result or FPDF_ANNOT_FLAG_LOCKED;
  if afToggleNoView in Flags then
    Result := Result or FPDF_ANNOT_FLAG_TOGGLENOVIEW;
end;

function EncodeRenderOptions(Options: TRenderOptions): Integer;
begin
  Result := 0;
  if reAnnotations in Options then
    Result := Result or FPDF_ANNOT;
  if reLcd in Options then
    Result := Result or FPDF_LCD_TEXT;
  if reNoNativeText in Options then
    Result := Result or FPDF_NO_NATIVETEXT;
  if reGrayscale in Options then
    Result := Result or FPDF_GRAYSCALE;
  if reDebugInfo in Options then
    Result := Result or FPDF_DEBUG_INFO;
  if reNoCatchException in Options then
    Result := Result or FPDF_NO_CATCH;
  if reLimitCache in Options then
    Result := Result or FPDF_RENDER_LIMITEDIMAGECACHE;
  if reHalftone in Options then
    Result := Result or FPDF_RENDER_FORCEHALFTONE;
  if rePrinting in Options then
    Result := Result or FPDF_PRINTING;
  if reReverseByteOrder in Options then
    Result := Result or FPDF_REVERSE_BYTE_ORDER;
  if reNoSmoothText in Options then
    Result := Result or FPDF_RENDER_NO_SMOOTHTEXT;
  if reNoSmoothImage in Options then
    Result := Result or FPDF_RENDER_NO_SMOOTHIMAGE;
  if reNoSmoothPath in Options then
    Result := Result or FPDF_RENDER_NO_SMOOTHPATH;
end;

function EncodeSearchOptions(Options: TSearchOptions): Integer;
begin
  Result := 0;
  if seCaseSensitive in Options then
    Result := Result or FPDF_MATCHCASE;
  if seWholeWord in Options then
    Result := Result or FPDF_MATCHWHOLEWORD;
  if seConsecutive in Options then
    Result := Result or FPDF_CONSECUTIVE;
end;

function EncodeSaveOption(Option: TSaveOption): Integer;
begin
  case Option of
    saIncremental: Result := FPDF_INCREMENTAL;
    saNoIncremental: Result := FPDF_NO_INCREMENTAL;
    saRemoveSecurity: Result := FPDF_REMOVE_SECURITY;
    else Result := 0;
  end;
end;

function EncodePdfVersion(PdfVersion: TPdfVersion): Integer;
begin
  case PdfVersion of
    pv10: Result := 10;
    pv11: Result := 11;
    pv12: Result := 12;
    pv13: Result := 13;
    pv14: Result := 14;
    pv15: Result := 15;
    pv16: Result := 16;
    pv17: Result := 17;
    else Result := 0;
  end;
end;

function DecodePdfVersion(Code: Integer): TPdfVersion;
begin
  case Code of
    10: Result := pv10;
    11: Result := pv11;
    12: Result := pv12;
    13: Result := pv13;
    14: Result := pv14;
    15: Result := pv15;
    16: Result := pv16;
    17: Result := pv17;
    else Result := pvUnknown;
  end;
end;

function DecodePageMode(Code: Integer): TPageMode;
begin
  case Code of
    PAGEMODE_UNKNOWN: Result := pmUnknown;
    PAGEMODE_USENONE: Result := pmNone;
    PAGEMODE_USEOUTLINES: Result := pmOutline;
    PAGEMODE_USETHUMBS: Result := pmThumbs;
    PAGEMODE_FULLSCREEN: Result := pmFullScreen;
    PAGEMODE_USEOC: Result := pmOptionalContentGroup;
    PAGEMODE_USEATTACHMENTS: Result := pmAttachments;
    else Result := pmUnknown;
  end;
end;

function DecodeObjectType(Code: Integer): TObjectType;
begin
  case Code of
    FPDF_PAGEOBJ_TEXT: Result := otText;
    FPDF_PAGEOBJ_PATH: Result := otPath;
    FPDF_PAGEOBJ_IMAGE: Result := otImage;
    FPDF_PAGEOBJ_SHADING: Result := otShading;
    FPDF_PAGEOBJ_FORM: Result := otForm;
    else Result := otUnknown;
  end;
end;

function DecodeFeature(Feature: Integer): TPdfFeature;
begin
  case Feature of
    FPDF_UNSP_DOC_XFAFORM: Result := feXfaForm;
    FPDF_UNSP_DOC_PORTABLECOLLECTION: Result := fePortableCollection;
    FPDF_UNSP_DOC_ATTACHMENT: Result := feAttachment;
    FPDF_UNSP_DOC_SECURITY: Result := feSecurity;
    FPDF_UNSP_DOC_SHAREDREVIEW: Result := feSharedReview;
    FPDF_UNSP_DOC_SHAREDFORM_ACROBAT: Result := feSharedFormAcrobat;
    FPDF_UNSP_DOC_SHAREDFORM_FILESYSTEM: Result := feSharedFormFilesystem;
    FPDF_UNSP_DOC_SHAREDFORM_EMAIL: Result := feSharedFormEmail;
    FPDF_UNSP_ANNOT_3DANNOT: Result := fe3dAnnotation;
    FPDF_UNSP_ANNOT_MOVIE: Result := feMovieAnnotation;
    FPDF_UNSP_ANNOT_SOUND: Result := feSoundAnnotation;
    FPDF_UNSP_ANNOT_SCREEN_MEDIA: Result := feScreenMediaAnnotation;
    FPDF_UNSP_ANNOT_SCREEN_RICHMEDIA: Result := feScreenRichMediaAnnotation;
    FPDF_UNSP_ANNOT_ATTACHMENT: Result := feAttachmentAnnotation;
    FPDF_UNSP_ANNOT_SIG: Result := feSignatureAnnotation;
    else Result := feUnknown;
  end;
end;

function EncodeFillMode(FillMode: TPdfFillMode): Integer;
begin
  case FillMode of
    fmAlternate: Result := FPDF_FILLMODE_ALTERNATE;
    fmWinding: Result := FPDF_FILLMODE_WINDING;
    else {fmNone} Result := FPDF_FILLMODE_NONE;
  end;
end;

{
function DecodeCursor(CursorType: Integer): TCursor;
begin
  case CursorType of
    FXCT_ARROW: Result := crArrow;
    FXCT_NESW: Result := crSizeNESW;
    FXCT_NWSE: Result := crSizeNWSE;
    FXCT_VBEAM: Result := crIBeam;
    FXCT_HBEAM: Result := crIBeam;
    FXCT_HAND: Result := crHourGlass;
    else Result := crDefault;
  end;
end;
}

function DecodeFormType(FormType: Integer): TPdfFormType;
begin
  case FormType of
    FORMTYPE_NONE: Result := ftNone;
    FORMTYPE_ACRO_FORM: Result := ftAcroForm;
    FORMTYPE_XFA_FULL: Result := ftXfaFull;
    FORMTYPE_XFA_FOREGROUND: Result := ftXfaForeground;
    else Result := ftUnknown;
  end;
end;

function DecodeFormFieldFlags(Flags: Integer): TPdfFormFieldFlags;
begin
  Result := [];
  if (Flags and FPDF_FORMFLAG_READONLY) <> 0 then
    Result := Result + [ffReadOnly];
  if (Flags and FPDF_FORMFLAG_REQUIRED) <> 0 then
    Result := Result + [ffRequired];
  if (Flags and FPDF_FORMFLAG_NOEXPORT) <> 0 then
    Result := Result + [ffNoExport];
  if (Flags and FPDF_FORMFLAG_TEXT_MULTILINE) <> 0 then
    Result := Result + [ffMultiline];
  if (Flags and FPDF_FORMFLAG_CHOICE_COMBO) <> 0 then
    Result := Result + [ffChoiceCombo];
  if (Flags and FPDF_FORMFLAG_CHOICE_EDIT) <> 0 then
    Result := Result + [ffChoiceEdit];
end;

procedure Check(Value: Boolean; const Message: string);
begin
  if not Value then
    raise EPdfError.Create(Message);
end;

function LastPdfError: string;
begin
  case Integer(FPDF_GetLastError) of
    FPDF_ERR_SUCCESS: Result := '';
    FPDF_ERR_UNKNOWN: Result := 'Unknown error';
    FPDF_ERR_FILE: Result := 'File not found or could not be opened';
    FPDF_ERR_FORMAT: Result := 'File not in PDF format or corrupted';
    FPDF_ERR_PASSWORD: Result := 'Password required or incorrect password';
    FPDF_ERR_SECURITY: Result := 'Unsupported security scheme';
    FPDF_ERR_PAGE: Result := 'Page not found or content error';
    else Result := 'Unknown error'
  end;
end;

procedure CheckPdf(Value: Boolean; const ErrorMessage: string);
begin
  if not Value then
    if LastPdfError <> '' then
      Check(Value, LastPdfError)
    else
      Check(Value, ErrorMessage);
end;

function GetWebLinks(TextPage: FPDF_TEXTPAGE): TWebLinks;
var
  PageLink: FPDF_PAGELINK;
  I, J, WebLinkCount: Integer;
  Url: WString;
  Rectangles: TPdfRectangles;
begin
  Result := nil;
  PageLink := FPDFLink_LoadWebLinks(TextPage);
  if PageLink <> nil then
  try
    WebLinkCount := FPDFLink_CountWebLinks(PageLink);
    if WebLinkCount > 0 then // note: WebLinkCount could be -1
    begin
      SetLength(Result, WebLinkCount);
      for I := 0 to Length(Result) - 1 do
      begin
        SetLength(Url, FPDFLink_GetURL(PageLink, I, nil, 0) - 1);
        FPDFLink_GetURL(PageLink, I, PWideChar(Url), Length(Url));
        Result[I].Url := Url;

        SetLength(Rectangles, FPDFLink_CountRects(PageLink, I));
        for J := 0 to Length(Rectangles) - 1 do
          FPDFLink_GetRect(PageLink, I, J, Rectangles[J].Left, Rectangles[J].Top, Rectangles[J].Right, Rectangles[J].Bottom);
        Result[I].Rectangles := Rectangles;
      end;
    end;
  finally
    FPDFLink_CloseWebLinks(PageLink);
  end;
end;

function GetLinkAnnotations(Document: FPDF_DOCUMENT; Page: FPDF_PAGE): TLinkAnnotations;
var
  LinkAnnotation: FPDF_LINK;
  LinkCount, LinkPosition, I, J: Integer;
  Destination: FPDF_DEST;
  Action: FPDF_ACTION;
  Rectangle: FS_RECTF;
  QuadPoints: FS_QUADPOINTSF;
  Buffer: AnsiString;
  Size: LongWord;
begin
  LinkCount := 0;
  LinkPosition := 0;
  while FPDFLink_Enumerate(Page, LinkPosition, LinkAnnotation) <> 0 do
    Inc(LinkCount);

  SetLength(Result, LinkCount);
  LinkPosition := 0;
  for I := 0 to Length(Result) - 1 do
  begin
    if FPDFLink_Enumerate(Page, LinkPosition, LinkAnnotation) <> 0 then
    begin
      Result[I].Handle := LinkAnnotation;

      if FPDFLink_GetAnnotRect(LinkAnnotation, Rectangle) <> 0 then
      begin
        Result[I].Rectangle.Left := Rectangle.left;
        Result[I].Rectangle.Top := Rectangle.top;
        Result[I].Rectangle.Right := Rectangle.right;
        Result[I].Rectangle.Bottom := Rectangle.bottom;
      end;

      Destination := FPDFLink_GetDest(Document, LinkAnnotation);
      if Destination <> nil then
        Result[I].PageNumber := FPDFDest_GetDestPageIndex(Document, Destination) + 1;

      Action := FPDFLink_GetAction(LinkAnnotation);
      if Action <> nil then
      begin
        Result[I].Action := TPdfAction(FPDFAction_GetType(Action));

        Destination := FPDFAction_GetDest(Document, Action);
        if Destination <> nil then
          Result[I].ActionPageNumber := FPDFDest_GetDestPageIndex(Document, Destination) + 1;

        case Result[I].Action of
          acUri:
          begin
            Size := FPDFAction_GetURIPath(Document, Action, nil, 0);
            if Size >= 1 then
            begin
              SetLength(Buffer, Size - 1);
              FPDFAction_GetURIPath(Document, Action, PAnsiChar(Buffer), Size);
              Result[I].ActionPath := WString(Buffer);
            end;
          end;

          acLaunch, acGotoRemote:
          begin
            Size := FPDFAction_GetFilePath(Action, nil, 0);
            if Size >= 1 then
            begin
              SetLength(Buffer, Size - 1);
              FPDFAction_GetFilePath(Action, PAnsiChar(Buffer), Size);
              Result[I].ActionPath := WString(Buffer);
            end;
          end;
        end;  
      end;

      SetLength(Result[I].Points, FPDFLink_CountQuadPoints(LinkAnnotation));
      for J := 0 to Length(Result[I].Points) - 1 do
        if FPDFLink_GetQuadPoints(LinkAnnotation, J, QuadPoints) <> 0 then
        begin
          Result[I].Points[J][1].X := QuadPoints.x1;
          Result[I].Points[J][1].Y := QuadPoints.y1;
          Result[I].Points[J][2].X := QuadPoints.x2;
          Result[I].Points[J][2].Y := QuadPoints.y2;
          Result[I].Points[J][3].X := QuadPoints.x3;
          Result[I].Points[J][3].Y := QuadPoints.y3;
          Result[I].Points[J][4].X := QuadPoints.x4;
          Result[I].Points[J][4].Y := QuadPoints.y4;
        end;
    end;
  end;
end;

function GetText(TextPage: FPDF_TEXTPAGE; StartIndex, Count: Integer): WString;
var MaxCount, CharacterCount: Integer;
begin
  Result := '';
  MaxCount := FPDFText_CountChars(TextPage);
  if StartIndex + Count > MaxCount then
    Count := MaxCount - StartIndex;
  if Count > 0 then
  begin
    SetLength(Result, Count);
    CharacterCount := FPDFText_GetText(TextPage, StartIndex, Count, PWideChar(Result));
    if CharacterCount <> Count + 1 then
      SetLength(Result, CharacterCount - 1);
  end;    
end;

function ColorToARGB(Color: TColor; Alpha: Byte = $FF): FPDF_DWORD;
{$ifndef D7PLUS}
const
  clSystemColor = $FF000000;
{$endif D7PLUS}
var RGBColor: DWORD;
begin
  if (DWORD(Color) and clSystemColor) = clSystemColor then
    RGBColor := GetSysColor(DWORD(Color) and $FFFFFF)
  else
    RGBColor := DWORD(Color);

  Result := FPDF_ARGB(Alpha, RGBColor and $FF, (RGBColor and $FF00) shr 8, (RGBColor and $FF0000) shr 16);
end;

procedure ToBitmap(Bitmap: FPDF_BITMAP; Result: TBitmap);
var
  Format, Width, Height, Stride, BytesPerPixel, Y: Integer;
  Buffer: Pointer;
begin
  Format := FPDFBitmap_GetFormat(Bitmap);
  Width := FPDFBitmap_GetWidth(Bitmap);
  Height := FPDFBitmap_GetHeight(Bitmap);
  Stride := FPDFBitmap_GetStride(Bitmap);
  Buffer := FPDFBitmap_GetBuffer(Bitmap);

  case Format of
    FPDFBitmap_Unknown:
      Exit;
      
    FPDFBitmap_Gray:
    begin
      Result.PixelFormat := pf8bit;
      BytesPerPixel := 1;
    end;
      
    FPDFBitmap_BGR:
    begin
      Result.PixelFormat := pf24bit;
      BytesPerPixel := 3;
    end;

    else
    begin
      Result.PixelFormat := pf32bit;
      BytesPerPixel := 4;
    end;  
  end;

{$ifdef D2009PLUS}
  Result.SetSize(Width, Height);
{$else}
  Result.Width := Width;
  Result.Height := Height;
{$endif D2009PLUS}

  for Y := 0 to Height - 1 do
  begin
    Move(Buffer^, Result.ScanLine[Y]^, BytesPerPixel * Width);
    Inc(PByte(Buffer), Stride);
  end;
end;

function RenderPage(FormHandle: FPDF_FORMHANDLE; ResultBitmap: TBitmap; Page: FPDF_PAGE; Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions; Color: TColor): TBitmap;
var
  HasTransparency: Boolean;
  Bitmap: FPDF_BITMAP;
  FillColor: FPDF_DWORD;
  ArithmeticMask: TArithmeticMask;
begin
  ArithmeticMask := SetArithmeticMask;
  try
    HasTransparency := FPDFPage_HasTransparency(Page) <> 0;
    Bitmap := FPDFBitmap_Create(Width, Height, Ord(HasTransparency));
    CheckPdf(Bitmap <> nil, 'Cannot create bitmap');
  //  if HasTransparency then
      FillColor := ColorToARGB(Color);
  //  else
  //    FillColor := $FFFFFFFF;
    FPDFBitmap_FillRect(Bitmap, 0, 0, Width, Height, FillColor);
    try
      FPDF_RenderPageBitmap(Bitmap, Page, Left, Top, Width, Height, Ord(Rotation), EncodeRenderOptions(Options));
      if FormHandle <> nil then
      begin
        if rePrinting in Options then
          FPDF_RemoveFormFieldHighlight(FormHandle); // remove field hightlight

        FPDF_FFLDraw(FormHandle, Bitmap, Page, Left, Top, Width, Height, Ord(Rotation), EncodeRenderOptions(Options));

        if rePrinting in Options then
        begin
          // restore field highlight
          FPDF_SetFormFieldHighlightColor(FormHandle, 0, $FFE4DD);
          FPDF_SetFormFieldHighlightAlpha(FormHandle, 100);
        end;
      end;

      if ResultBitmap = nil then
        Result := TBitmap.Create
      else
        Result := ResultBitmap;

      ToBitmap(Bitmap, Result);
    finally
      FPDFBitmap_Destroy(Bitmap);
    end;
  finally
    RestoreArithmeticMask(ArithmeticMask);
  end;
end;

function PictureToBitmap(Picture: TPicture): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf32bit;
  Result.Width := Picture.Width;
  Result.Height := Picture.Height;
  Result.Canvas.Draw(0, 0, Picture.Graphic);
end;

procedure AddBitmap(Document: FPDF_DOCUMENT; Page: FPDF_PAGE; Bitmap: TBitmap; X, Y, Width, Height: Double);
var
  PdfImage: FPDF_PAGEOBJECT;
  PdfBitmap: FPDF_BITMAP;
  BitmapData: array of Byte;
  ScanLineSize: Integer;
  Index: Integer;
begin
  Check(Bitmap.PixelFormat = pf32bit, 'Unsupported pixel format');

  ScanLineSize := 4 * Bitmap.Width;
  SetLength(BitmapData, ScanLineSize * Bitmap.Height);
  for Index := 0 to Bitmap.Height - 1 do
    Move(Bitmap.ScanLine[Index]^, BitmapData[Index * ScanLineSize], ScanLineSize);

  PdfImage := FPDFPageObj_NewImageObj(Document);
  CheckPdf(PdfImage <> nil, 'Cannot create image object');
  PdfBitmap := FPDFBitmap_CreateEx(Bitmap.Width, Bitmap.Height, FPDFBitmap_BGRx, BitmapData, ScanLineSize);
  CheckPdf(PdfBitmap <> nil, 'Cannot create bitmap');
  try
    CheckPdf(FPDFImageObj_SetBitmap(@Page, 1, PdfImage, PdfBitmap) <> 0, 'Cannot assign bitmap');
//    FPDFPageObj_Transform(PdfImage, Width, 0, 0, Height, Left, FPDF_GetPageHeight(Page) - Top - Height);
    CheckPdf(FPDFImageObj_SetMatrix(PdfImage, Width, 0, 0, Height, X, Y) <> 0, 'Cannot set matrix');
    FPDFPage_InsertObject(Page, PdfImage);
    CheckPdf(FPDFPage_GenerateContent(Page) <> 0, 'Cannot create page content');
  finally
    FPDFBitmap_Destroy(PdfBitmap);
  end;
end;

function GetImage(ObjectHandle: Pointer): TPdfImage;
var Size: LongWord;
begin
  Check(FPDFPageObj_GetImage(ObjectHandle, Result.Height, Result.Width, Size, nil) <> 0, 'Cannot retrieve image data');
  SetLength(Result.Data, Size);
  Check(FPDFPageObj_GetImage(ObjectHandle, Result.Height, Result.Width, Size, PByte(Result.Data)) <> 0, 'Cannot retrieve image data');
end;

function GetBitmap(ObjectHandle: Pointer): TBitmap;
var
  DibHeight, DibWidth, DibBpp, DibScanLineSize, Y: Integer;
  Data: TBytes;
begin
  Check(FPDFPageObj_GetDIB(ObjectHandle, DibHeight, DibWidth, DibBpp, DibScanLineSize, nil) <> 0, 'Cannot retrieve image data');
  SetLength(Data, DibHeight * DibScanLineSize);
  Check(FPDFPageObj_GetDIB(ObjectHandle, DibHeight, DibWidth, DibBpp, DibScanLineSize, Data) <> 0, 'Cannot retrieve image data');

  Result := TBitmap.Create;
  if DibBpp = 8 then
    Result.PixelFormat := pf8bit
  else if DibBpp = 16 then
    Result.PixelFormat := pf16bit
  else if DibBpp = 24 then
    Result.PixelFormat := pf24bit
  else if DibBpp = 32 then
    Result.PixelFormat := pf32bit;
  Result.Width := DibWidth;
  Result.Height := DibHeight;

  for Y := 0 to DibHeight - 1 do
    Move(Data[Y * DibScanLineSize], Result.ScanLine[Y]^, DibScanLineSize);
end;

//---------------------------------------------------------------------
//
// TPdf
//

type
  TUnsupportInfo = packed record
    Info: UNSUPPORT_INFO;
    Pdf: TPdf;
  end;
  PUnsupportInfo = ^TUnsupportInfo;

var
  UnsupportInfo: TUnsupportInfo;

procedure UnsupportedFeatureHandler(pThis: PUNSUPPORT_INFO; nType: Integer); cdecl;
var Pdf: TPdf;
begin
  Pdf := PUnsupportInfo(pThis).Pdf;
  if Assigned(Pdf.OnUnsupportedFeature) then
    Pdf.OnUnsupportedFeature(Pdf, DecodeFeature(nType));
end;

procedure SetUnsupportedFeatureHandler(Pdf: TPdf);
begin
  UnsupportInfo.Info.version := 1;
  UnsupportInfo.Info.FSDK_UnSupport_Handler := UnsupportedFeatureHandler;
  UnsupportInfo.Pdf := Pdf;
  CheckPdf(FSDK_SetUnSpObjProcessHandler(UnsupportInfo.Info) <> 0, 'Cannot set unsupported feature handler');
end;

constructor TPdf.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFormFill := True;
  FPdfViews := TList.Create;
end;

destructor TPdf.Destroy;
begin
  FTimer.Free;
  Active := False;
  FPdfViews.Free;
  inherited Destroy;
end;

function TPdf.GetAbout: string;
begin
  Result := AboutInfo;
end;

procedure TPdf.SetAbout(const Value: string);
begin
end;

procedure TPdf.CheckActive;
begin
  if not (csDesigning in ComponentState) then
    Check(Active, 'Cannot perform this operation on an inactive ' + Name + ' component');
end;

procedure TPdf.CheckInactive;
begin
  if not (csDesigning in ComponentState) then
    Check(not Active, 'Cannot perform this operation on an active ' + Name + ' component');
end;

procedure TPdf.CheckPageActive;
begin
  CheckActive;
  Check(FPage <> nil, 'Cannot perform this operation on an inactive page');
end;

procedure TPdf.CheckFindActive;
begin
  CheckPageActive;
  Check(FFind <> nil, 'Uninitialized search');
end;

procedure TPdf.SetFileName(const Value: string);
begin
  CheckInactive;
  FFileName := Value;
end;

procedure TPdf.SetFormFill(Value: Boolean);
begin
  CheckInactive;
  FFormFill := Value;
end;

procedure TPdf.SetPassword(const Value: string);
begin
  CheckInactive;
  FPassword := Value;
end;

function TPdf.GetPdfVersion: TPdfVersion;
var Value: Integer;
begin
  CheckActive;
  CheckPdf(FPDF_GetFileVersion(FDocument, Value) <> 0, 'Cannot retrieve PDF version');
  Result := DecodePdfVersion(Value);
end;

function TPdf.GetPageCount: Integer;
begin
  CheckActive;
  Result := FPDF_GetPageCount(FDocument);
end;

function TPdf.GetPageWidth: Double;
begin
  CheckPageActive;
  Result := FPDF_GetPageWidth(FPage);
end;

function TPdf.GetPageHeight: Double;
begin
  CheckPageActive;
  Result := FPDF_GetPageHeight(FPage);
end;

function TPdf.GetPageBounds: TPdfRectangle;
var Rectangle: FS_RECTF;
begin
  CheckPageActive;
  CheckPdf(FPDF_GetPageBoundingBox(FPage, Rectangle) <> 0, 'Cannot retrieve page bounds');
  Result.Left := Rectangle.left;
  Result.Top := Rectangle.top;
  Result.Right := Rectangle.right;
  Result.Bottom := Rectangle.bottom;
end;

function TPdf.GetPermissions: LongWord;
begin
  CheckActive;
  Result := FPDF_GetDocPermissions(FDocument);
end;

function TPdf.GetPrintScaling: Boolean;
begin
  CheckActive;
  Result := FPDF_VIEWERREF_GetPrintScaling(FDocument) <> 0;
end;

function TPdf.GetPrintCopies: Integer;
begin
  CheckActive;
  Result := FPDF_VIEWERREF_GetNumCopies(FDocument);
end;

function TPdf.GetPrintPaperHandling: TPrintPaperHandling;
begin
  CheckActive;
  Result := TPrintPaperHandling(FPDF_VIEWERREF_GetDuplex(FDocument));
end;

{
function TPdf.GetPrintPageRange: FPDF_PAGERANGE;
begin
  CheckActive;
  Result := FPDF_VIEWERREF_GetPrintPageRange(FDocument);
end;
}

procedure FormFillInvalidate(FormFillInfo: PFPDF_FORMFILLINFO; Page: FPDF_PAGE; Left, Top, Right, Bottom: Double); cdecl;
var
  Pdf: TPdf;
  PdfView: TPdfView;
  I: Integer;
begin
  Pdf := PPdfFormFillInfo(FormFillInfo).Pdf;
  for I := 0 to Pdf.FPdfViews.Count - 1 do
  begin
    PdfView := Pdf.FPdfViews[I];
    if PdfView.Page = Page then
    begin
      PdfView.Invalidate;
      Exit;
    end;
  end;
end;

function FormFillSetTimer(FormFillInfo: PFPDF_FORMFILLINFO; Elapse: Integer; TimerFunc: TimerCallback): Integer; cdecl;
var Pdf: TPdf;
begin
  Pdf := PPdfFormFillInfo(FormFillInfo).Pdf;
  if Pdf.FTimer = nil then
    Pdf.FTimer := TTimer.Create(Pdf);
  Pdf.FTimerCallback := TimerFunc;
  Pdf.FTimer.OnTimer := Pdf.OnTimer;
  Pdf.FTimer.Interval := Elapse;
  Pdf.FTimer.Enabled := True;
  Result := Integer(Pdf);
end;

procedure FormFillKillTimer(FormFillInfo: PFPDF_FORMFILLINFO; TimerID: Integer); cdecl;
var Pdf: TPdf;
begin
  Pdf := PPdfFormFillInfo(FormFillInfo).Pdf;
  if TimerID = Integer(Pdf) then
    Pdf.FTimer.Enabled := False;
end;

procedure TPdf.OnTimer(Sender: TObject);
begin
  FTimerCallback(Integer(Self));
end;

{
procedure FormFillSetCursor(FormFillInfo: PFPDF_FORMFILLINFO; CursorType: Integer); cdecl;
begin
  Screen.Cursor := DecodeCursor(CursorType);
end;
}

procedure FormFillSetTextFieldFocus(FormFillInfo: PFPDF_FORMFILLINFO; value: FPDF_WIDESTRING; valueLen: FPDF_DWORD; is_focus: FPDF_BOOL); cdecl;
var Pdf: TPdf;
begin
  Pdf := PPdfFormFillInfo(FormFillInfo).Pdf;
  Pdf.SetTextFieldFocus(value, valueLen, is_focus);
end;

procedure TPdf.SetTextFieldFocus(value: FPDF_WIDESTRING; valueLen: FPDF_DWORD; is_focus: FPDF_BOOL);
var Text: WString;
begin
  if (is_focus <> 0) and Assigned(OnFormFieldEnter) then
  begin
    SetLength(Text, valueLen);
    if valueLen > 0 then
      Move(value^, Text[1], 2 * valueLen);
    OnFormFieldEnter(Self, Text);
  end
  else if (is_focus = 0) and Assigned(OnFormFieldExit) then
    OnFormFieldExit(Self);
end;

procedure TPdf.InitializeFormFill;
begin
  if FormFill then
  begin
    FillChar(FFormFillInfo, SizeOf(FFormFillInfo), 0);
    FFormFillInfo.Pdf := Self;
    if XFA then
      FFormFillInfo.Info.version := 2
    else
      FFormFillInfo.Info.version := 1;

    FFormFillInfo.Info.FFI_Invalidate := FormFillInvalidate;
    FFormFillInfo.Info.FFI_SetTimer := FormFillSetTimer;
    FFormFillInfo.Info.FFI_KillTimer := FormFillKillTimer;
//    FFormFillInfo.Info.FFI_SetCursor := FormFillSetCursor;
    FFormFillInfo.Info.FFI_SetTextFieldFocus := FormFillSetTextFieldFocus;
    FFormHandle := FPDFDOC_InitFormFillEnvironment(FDocument, FFormFillInfo.Info);
    CheckPdf(FFormHandle <> nil, 'Cannot initialize form fill environment');
    FPDF_SetFormFieldHighlightColor(FFormHandle, 0, $FFE4DD);
    FPDF_SetFormFieldHighlightAlpha(FFormHandle, 100);
    FORM_DoDocumentJSAction(FFormHandle);
    FORM_DoDocumentOpenAction(FFormHandle);
  end;

  if XFA then
    if FormType in [ftXfaFull, ftXfaForeground] then
//    Check(FPDF_LoadXFA(FDocument) <> 0, 'Cannot initialize XFA');
      FPDF_LoadXFA(FDocument);
end;

procedure TPdf.ExitFormFill;
begin
  if FFormHandle <> nil then
  begin
    FPDFDOC_ExitFormFillEnvironment(FFormHandle);
    FFormHandle := nil;
  end;
end;

procedure TPdf.LoadDocument;
begin
  CheckInactive;
  LoadLibrary;

  if Assigned(OnUnsupportedFeature) then
    SetUnsupportedFeatureHandler(Self);

  FDocument := FPDF_LoadDocument(PAnsiChar(AnsiString(FFileName)), FPDF_BYTESTRING(AnsiString(FPassword)));
  CheckPdf(FDocument <> nil, 'Cannot load PDF document ' + FFileName);
  InitializeFormFill;
  ReloadPage;
end;

procedure TPdf.LoadDocument(Data: Pointer; Size: Integer);
begin
  CheckInactive;
  LoadLibrary;

  if Assigned(OnUnsupportedFeature) then
    SetUnsupportedFeatureHandler(Self);

  FDocument := FPDF_LoadMemDocument(Data, Size, FPDF_BYTESTRING(AnsiString(FPassword)));
  CheckPdf(FDocument <> nil, 'Cannot load PDF document');
  InitializeFormFill;
  ReloadPage;
end;

procedure TPdf.LoadDocument(const Data: TBytes);
begin
  LoadDocument(PByte(Data), Length(Data));
end;

procedure TPdf.LoadDocument(Data: TMemoryStream);
begin
  LoadDocument(Data.Memory, Data.Size);
end;

procedure TPdf.UnloadDocument;
var I: Integer;
begin
  UnloadPage;

  for I := FPdfViews.Count - 1 downto 0 do
    TPdfView(FPdfViews.Items[I]).Active := False;

  if FDocument <> nil then
  begin
    if FormHandle <> nil then
      FORM_DoDocumentAAction(FormHandle, FPDFDOC_AACTION_WC);
    ExitFormFill;
    FPDF_CloseDocument(FDocument);
    FDocument := nil;
  end;
end;

procedure TPdf.CreateDocument;
begin
  CheckInactive;
  LoadLibrary;

  if Assigned(OnUnsupportedFeature) then
    SetUnsupportedFeatureHandler(Self);

  FDocument := FPDF_CreateNewDocument;
  CheckPdf(FDocument <> nil, 'Cannot create PDF document');
  InitializeFormFill;
end;

procedure TPdf.ReloadPage;
begin
  UnloadPage;
  CheckActive;

  if FPageNumber <> 0 then
  begin
    FPage := FPDF_LoadPage(FDocument, FPageNumber - 1);
    CheckPdf(FPage <> nil, 'Cannot open page ' + IntToStr(FPageNumber));
  end;

  if Assigned(OnPageChange) then
    FOnPageChange(Self);
end;

procedure TPdf.UnloadPage;
begin
  FPath := nil;
  UnloadTextPage;
  if FPage <> nil then
  begin
    FPDF_ClosePage(FPage);
    FPage := nil;
    FLinkAnnotations := nil;
  end;
end;

procedure TPdf.AddPage(PageNumber: Integer; Width, Height: Double);
begin
  CheckActive;
  UnloadPage;
  FPageNumber := PageNumber;
  FPage := FPDFPage_New(FDocument, PageNumber - 1, Width, Height);
  CheckPdf(FPage <> nil, 'Cannot create PDF page');
end;

procedure TPdf.UpdatePage;
begin
  CheckPageActive;
  CheckPdf(FPDFPage_GenerateContent(FPage) <> 0, 'Cannot create page content');
end;

procedure TPdf.DeletePage(PageNumber: Integer);
begin
  CheckActive;
  UnloadPage;
  FPDFPage_Delete(FDocument, PageNumber - 1);
  ReloadPage;
end;

procedure TPdf.LoadTextPage;
var ArithmeticMask: TArithmeticMask;
begin
  CheckPageActive;
  if FTextPage = nil then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      FTextPage := FPDFText_LoadPage(FPage);
      CheckPdf(FTextPage <> nil, 'Cannot open text page');
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;
  end
end;

procedure TPdf.UnloadTextPage;
begin
  UnloadFind;
  if FTextPage <> nil then
  begin
    FPDFText_ClosePage(FTextPage);
    FTextPage := nil;
    FWebLinks := nil;
  end;
end;

procedure TPdf.ReloadFind(const Text: WString; Options: TSearchOptions; StartIndex: Integer);
begin
  UnloadFind;
  LoadTextPage;
  FFind := FPDFText_FindStart(FTextPage, PWideChar(Text), EncodeSearchOptions(Options), StartIndex);
  CheckPdf(FFind <> nil, 'Cannot start find');
end;

procedure TPdf.UnloadFind;
begin
  if FFind <> nil then
  begin
    FPDFText_FindClose(FFind);
    FFind := nil;
  end;
end;

procedure TPdf.Loaded;
var
  PdfView: TPdfView;
  I: Integer;
begin
  inherited Loaded;
  SetActive(FActive);

  for I := FPdfViews.Count - 1 downto 0 do
  begin
    PdfView := TPdfView(FPdfViews.Items[I]);
    PdfView.SetActive(PdfView.FActive);
  end;
end;

function TPdf.GetActive: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FDocument <> nil
  else
    Result := FActive;
end;

procedure TPdf.SetActive(Value: Boolean);
begin
  if Active <> Value then
    if not (csDesigning in ComponentState) then
      if not (csLoading in ComponentState) then
        if Value then
        begin
          LoadDocument;
          ReloadPage;
        end
        else
          UnloadDocument;

  FActive := Value;
end;

procedure TPdf.SetPageNumber(Value: Integer);
begin
  if Value <> FPageNumber then
  begin
    FPageNumber := Value;
    if Active then
      if not (csDesigning in ComponentState) then
        if not (csLoading in ComponentState) then
          ReloadPage;
  end;
end;

function TPdf.GetCharacterCount: Integer;
begin
  LoadTextPage;
  Result := FPDFText_CountChars(FTextPage);
end;

function TPdf.GetPageLabel(PageNumber: Integer): WString;
var BufferLength: LongWord;
begin
  CheckActive;
  Check((PageNumber >= 1) and (PageNumber <= PageCount), 'Incorrect page number');
  Result := '';
  BufferLength := FPDF_GetPageLabel(FDocument, PageNumber - 1, nil, 0);
  if BufferLength > 2 then
  begin
    SetLength(Result, BufferLength div 2 - 1);
    FPDF_GetPageLabel(FDocument, PageNumber - 1, PWideChar(Result), BufferLength)
  end;
end;

function TPdf.GetPageMode: TPageMode;
begin
  CheckActive;
  Result := DecodePageMode(FPDFDoc_GetPageMode(FDocument));
end;

function TPdf.GetCharacter(Index: Integer): WideChar;
begin
  LoadTextPage;
  Result := WideChar(FPDFText_GetUnicode(FTextPage, Index));
end;

function TPdf.GetCharcode(Index: Integer): WideChar;
begin
  LoadTextPage;
  Result := WideChar(FPDFText_GetCharcode(FTextPage, Index));
end;

function TPdf.GetFontSize(Index: Integer): Double;
begin
  LoadTextPage;
  Result := FPDFText_GetFontSize(FTextPage, Index);
end;

function TPdf.GetCharacterOrigin(Index: Integer): TPdfPoint;
begin
  LoadTextPage;
  FPDFText_GetCharOrigin(FTextPage, Index, Result.X, Result.Y);
end;

function TPdf.GetCharacterRectangle(Index: Integer): TPdfRectangle;
begin
  LoadTextPage;
  CheckPdf(FPDFText_GetCharBox(FTextPage, Index, Result.Left, Result.Right, Result.Bottom, Result.Top) <> 0, 'Cannot retrieve character rectangle');
end;

function TPdf.CharacterIndexAtPos(X, Y, ToleranceX, ToleranceY: Double): Integer;
begin
  LoadTextPage;
  Result := FPDFText_GetCharIndexAtPos(FTextPage, X, Y, ToleranceX, ToleranceY);
end;

function TPdf.Text(StartIndex, Count: Integer): WString;
begin
  LoadTextPage;
  Result := GetText(FTextPage, StartIndex, Count);
end;

function TPdf.RectangleCount(StartIndex, Count: Integer): Integer;
begin
  LoadTextPage;
  Result := FPDFText_CountRects(FTextPage, StartIndex, Count);
end;

function TPdf.GetRectangle(Index: Integer): TPdfRectangle;
begin
  LoadTextPage;
  CheckPdf(FPDFText_GetRect(FTextPage, Index, Result.Left, Result.Top, Result.Right, Result.Bottom) <> 0, 'Cannot retrieve rectangle');
end;

function TPdf.TextInRectangle(Left, Top, Right, Bottom: Double): WString;
var Count: Integer;
begin
  Result := '';
  LoadTextPage;
  Count := FPDFText_GetBoundedText(FTextPage, Left, Top, Right, Bottom, nil, 0);
  if Count > 0 then
  begin
    SetLength(Result, Count);
    FPDFText_GetBoundedText(FTextPage, Left, Top, Right, Bottom, PWideChar(Result), Count);
  end;
end;

function TPdf.TextInRectangle(Rectangle: TPdfRectangle): WString;
begin
  Result := TextInRectangle(Rectangle.Left, Rectangle.Top, Rectangle.Right, Rectangle.Bottom);
end;

procedure TPdf.RenderPage(DeviceContext: HDC; Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions);
begin
  CheckPageActive;
  FPDF_RenderPage(DeviceContext, FPage, Left, Top, Width, Height, Ord(Rotation), EncodeRenderOptions(Options));
end;

function TPdf.RenderPage(Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions; Color: TColor): TBitmap;
begin
  CheckPageActive;
  Result := PDFium.RenderPage(FFormHandle, nil, FPage, Left, Top, Width, Height, Rotation, Options, Color);
end;

procedure TPdf.RenderPage(Bitmap: TBitmap; Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions; Color: TColor);
begin
  CheckPageActive;
  if Bitmap <> nil then
    PDFium.RenderPage(FFormHandle, Bitmap, FPage, Left, Top, Width, Height, Rotation, Options, Color);
end;

function TPdf.FindFirst(const Text: WString; Options: TSearchOptions = []; StartIndex: Integer = 0; DirectionUp: Boolean = True): Integer;
begin
  ReloadFind(Text, Options, StartIndex);
  if DirectionUp then
    Result := FindNext
  else
    Result := FindPrevious
end;

function TPdf.FindNext: Integer;
begin
  CheckFindActive;
  if FPDFText_FindNext(FFind) = 0 then
    Result := -1
  else
    Result := FPDFText_GetSchResultIndex(FFind);
end;

function TPdf.FindPrevious: Integer;
begin
  CheckFindActive;
  if  FPDFText_FindPrev(FFind) = 0 then
    Result := -1
  else
    Result := FPDFText_GetSchResultIndex(FFind);
end;

function TPdf.ImportPages(Pdf: TPdf; const Range: string; PageNumber: Integer): Boolean;
begin
  CheckActive;
  Pdf.Active := True;
  UnloadPage;
  Result := FPDF_ImportPages(FDocument, Pdf.FDocument, FPDF_BYTESTRING(AnsiString(Range)), PageNumber - 1) <> 0;
  ReloadPage;
end;

function TPdf.ImportPreferences(Pdf: TPdf): Boolean;
begin
  CheckActive;
  Pdf.Active := True;
  Result := FPDF_CopyViewerPreferences(FDocument, Pdf.FDocument) <> 0;
end;

function TPdf.GetPageRotation: TRotation;
begin
  CheckPageActive;
  Result := TRotation(FPDFPage_GetRotation(FPage));
end;

procedure TPdf.SetPageRotation(Value: TRotation);
begin
  CheckPageActive;
  FPDFPage_SetRotation(FPage, Ord(Value));
  ReloadPage;
end;

function TPdf.GetObjectCount: Integer;
begin
  CheckPageActive;
  Result := FPDFPage_CountObjects(FPage);
end;

function TPdf.GetObjectHandle(Index: Integer): Pointer;
begin
  CheckPageActive;
  Check((Index >= 0) and (Index < ObjectCount), 'Incorrect index');
  Result := FPDFPage_GetObject(FPage, Index);
end;

function TPdf.GetObjectType(Index: Integer): TObjectType;
begin
  Result := DecodeObjectType(FPDFPageObj_GetType(GetObjectHandle(Index)));
end;

function TPdf.GetObjectBitmap(Index: Integer): TBitmap;
var Bitmap: FPDF_BITMAP;
begin
  Result := nil;
  Bitmap := FPDFImageObj_GetBitmap(GetObjectHandle(Index));
  if Bitmap <> nil then
  try
    Result := TBitmap.Create;
    ToBitmap(Bitmap, Result);
  finally
    FPDFBitmap_Destroy(Bitmap);
  end;
end;

function TPdf.GetObjectBounds(Index: Integer): TPdfRectangle;
var Left, Top, Right, Bottom: Single;
begin
  Check(FPDFPageObj_GetBounds(GetObjectHandle(Index), Left, Bottom, Right, Top) <> 0, 'Cannot retrieve data');
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function TPdf.GetObjectTransparent(Index: Integer): Boolean;
begin
  Result := FPDFPageObj_HasTransparency(GetObjectHandle(Index)) <> 0;
end;

function TPdf.GetImageCount: Integer;
var I: Integer;
begin
  Result := 0;
  for I := ObjectCount - 1 downto 0 do
    if ObjectType[I] = otImage then
      Inc(Result);
end;

function TPdf.ImageIndexToObjectIndex(Index: Integer): Integer;
var I: Integer;
begin
  for I := 0 to ObjectCount - 1 do
    if ObjectType[I] = otImage then
      if Index > 0 then
        Dec(Index)
      else
      begin
        Result := I;
        Exit;
      end;

  Result := -1;
end;

function TPdf.GetImage(Index: Integer): TPdfImage;
var ObjectIndex: Integer;
begin
  ObjectIndex := ImageIndexToObjectIndex(Index);
  Check(ObjectIndex <> -1, 'Incorrect index');
  Result := PDFium.GetImage(ObjectHandle[ObjectIndex]);
end;

function TPdf.GetBitmapCount: Integer;
begin
  Result := ImageCount;
end;

function TPdf.GetBitmap(Index: Integer): TBitmap;
var ObjectIndex: Integer;
begin
  ObjectIndex := ImageIndexToObjectIndex(Index);
  Check(ObjectIndex <> -1, 'Incorrect index');
  Result := PDFium.GetBitmap(ObjectHandle[ObjectIndex]);
end;

function TPdf.GetTransparent: Boolean;
begin
  CheckPageActive;
  Result := FPDFPage_HasTransparency(FPage) <> 0;
end;

type
  TPdfWrite = packed record
    Write: FPDF_FILEWRITE;
    Stream: TStream;
  end;
  PPdfWrite = ^TPdfWrite;

function WriteBlock(pThis: PFPDF_FILEWRITE; pData: Pointer; size: LongWord): Integer; cdecl;
begin
  PPdfWrite(pThis).Stream.WriteBuffer(pData^, size);
  Result := 1;
end;

function TPdf.SaveAs(Stream: TStream; Option: TSaveOption; PdfVersion: TPdfVersion): Boolean;
var PdfWrite: TPdfWrite;
begin
  CheckActive;
  FillChar(PdfWrite, Sizeof(PdfWrite), 0);
  PdfWrite.Write.version := 1;
  PdfWrite.Write.WriteBlock := WriteBlock;
  PdfWrite.Stream := Stream;
  if PdfVersion = pvUnknown then
    Result := FPDF_SaveAsCopy(FDocument, PdfWrite.Write, EncodeSaveOption(Option)) <> 0
  else
    Result := FPDF_SaveWithVersion(FDocument, PdfWrite.Write, EncodeSaveOption(Option), EncodePdfVersion(PdfVersion)) <> 0;
end;

function TPdf.SaveAs(const FileName: string; Option: TSaveOption; PdfVersion: TPdfVersion): Boolean;
var Stream: TStream;
begin
  CheckActive;
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    Result := SaveAs(Stream, Option, PdfVersion);
  finally
    Stream.Free;
  end;
end;

type
  TPdfFileAccess = packed record
    FileAccess: FPDF_FILEACCESS;
    Stream: TStream;
  end;
  PPdfFileAccess = ^TPdfFileAccess;

function GetBlock(param: Pointer; position: LongWord; pBuf: PByte; size: LongWord): Integer; cdecl;
var Stream: TStream;
begin
  Stream := PPdfFileAccess(param).Stream;
  Stream.Position := position;
  Stream.ReadBuffer(pBuf^, size);
  Result := 1;
end;

function TPdf.AddJpegImage(JpegImage: TStream; X, Y, Width, Height: Double): Boolean;
var
  PdfImage: FPDF_PAGEOBJECT;
  PdfFileAccess: TPdfFileAccess;
begin
  CheckPageActive;

  PdfImage := FPDFPageObj_NewImageObj(Document);
  CheckPdf(PdfImage <> nil, 'Cannot create image object');

  FillChar(PdfFileAccess, Sizeof(PdfFileAccess), 0);
  PdfFileAccess.FileAccess.m_FileLen := JpegImage.Size;
  PdfFileAccess.FileAccess.m_GetBlock := GetBlock;
  PdfFileAccess.FileAccess.m_Param := @PdfFileAccess;
  PdfFileAccess.Stream := JpegImage;

  Result := FPDFImageObj_LoadJpegFileInline(@Page, 1, PdfImage, PdfFileAccess.FileAccess) <> 0;
  if Result then
  begin
//    FPDFPageObj_Transform(PdfImage, Width, 0, 0, Height, X, Y);
    CheckPdf(FPDFImageObj_SetMatrix(PdfImage, Width, 0, 0, Height, X, Y) <> 0, 'Cannot set matrix');
    FPDFPage_InsertObject(Page, PdfImage);
    CheckPdf(FPDFPage_GenerateContent(Page) <> 0, 'Cannot create page content');
  end;
end;

function TPdf.DeviceToPage(X, Y, Left, Top, Width, Height: Integer; Rotation: TRotation; out PageX, PageY: Double): Boolean;
begin
  CheckPageActive;
  Result := FPDF_DeviceToPage(FPage, Left, Top, Width, Height, Ord(Rotation), X, Y, PageX, PageY) <> 0;
end;

function TPdf.PageToDevice(PageX, PageY: Double; Left, Top, Width, Height: Integer; Rotation: TRotation; out X, Y: Integer): Boolean;
begin
  CheckPageActive;
  Result := FPDF_PageToDevice(FPage, Left, Top, Width, Height, Ord(Rotation), PageX, PageY, X, Y) <> 0;
end;

function TPdf.GetMetaText(const Tag: string): WString;
var Size: LongWord;
begin
  CheckActive;
  Result := '';
  Size := FPDF_GetMetaText(FDocument, PAnsiChar(AnsiString(Tag)), nil, 0);
  if Size >= 4 then
  begin
    SetLength(Result, Size div 2 - 1);
    FPDF_GetMetaText(FDocument, PAnsiChar(AnsiString(Tag)), PWideChar(Result), Size);
  end;
end;

function TPdf.GetViewerPreference(const Key: string): WString;
var
  Size: LongWord;
  Buffer: AnsiString;
begin
  CheckActive;
  Result := '';
  Size := FPDF_VIEWERREF_GetName(FDocument, PAnsiChar(AnsiString(Key)), nil, 0);
  if Size >= 1 then
  begin
    SetLength(Buffer, Size - 1);
    FPDF_VIEWERREF_GetName(FDocument, PAnsiChar(AnsiString(Key)), PAnsiChar(Buffer), Size);
    Result := WString(Buffer);
  end;
end;

function TPdf.GetAuthor: WString;
begin
  Result := MetaText['Author'];
end;

function TPdf.GetTitle: WString;
begin
  Result := MetaText['Title'];
end;

function TPdf.GetSubject: WString;
begin
  Result := MetaText['Subject'];
end;

function TPdf.GetKeywords: WString;
begin
  Result := MetaText['Keywords'];
end;

function TPdf.GetCreator: WString;
begin
  Result := MetaText['Creator'];
end;

function TPdf.GetProducer: WString;
begin
  Result := MetaText['Producer'];
end;

function TPdf.GetCreationDate: WString;
begin
  Result := MetaText['CreationDate'];
end;

function TPdf.GetModifiedDate: WString;
begin
  Result := MetaText['ModDate'];
end;

procedure TPdf.SetBookmarkData(Bookmark: FPDF_BOOKMARK; var Data: TBookmark);
var
  BufferSize: LongWord;
  Destination: FPDF_DEST;
  Action: FPDF_ACTION;
begin
  FillChar(Data, SizeOf(Data), 0);
  Data.Handle := Bookmark;
  if Bookmark <> nil then
  begin
    BufferSize := FPDFBookmark_GetTitle(Bookmark, nil, 0);
    if BufferSize > 2 then
    begin
      SetLength(Data.Title, BufferSize div 2 - 1);
      FPDFBookmark_GetTitle(Bookmark, PWideChar(Data.Title), BufferSize);
    end;

    Destination := FPDFBookmark_GetDest(FDocument, Bookmark);
    if Destination <> nil then
      Data.PageNumber := FPDFDest_GetDestPageIndex(FDocument, Destination) + 1;

    Action := FPDFBookmark_GetAction(Bookmark);
    if Action <> nil then
    begin
      Data.Action := TPdfAction(FPDFAction_GetType(Action));

      Destination := FPDFAction_GetDest(FDocument, Action);
      if Destination <> nil then
        Data.ActionPageNumber := FPDFDest_GetDestPageIndex(FDocument, Destination) + 1;
    end;
  end;
end;

function TPdf.GetBookmark(const Title: WString): TBookmark;
begin
  CheckActive;
  SetBookmarkData(FPDFBookmark_Find(FDocument, PWideChar(Title)), Result);
end;

function TPdf.GetNestedBookmarks(Bookmark: FPDF_BOOKMARK): TBookmarks;
var
  NextBookmark: FPDF_BOOKMARK;
  BookmarkCount, I: Integer;
begin
  CheckActive;
  BookmarkCount := 0;
  NextBookmark := FPDFBookmark_GetFirstChild(FDocument, Bookmark);
  while NextBookmark <> nil do
  begin
    Inc(BookmarkCount);
    NextBookmark := FPDFBookmark_GetNextSibling(FDocument, NextBookmark);
  end;

  SetLength(Result, BookmarkCount);
  NextBookmark := FPDFBookmark_GetFirstChild(FDocument, Bookmark);
  for I := 0 to Length(Result) - 1 do
  begin
    SetBookmarkData(NextBookmark, Result[I]);
    NextBookmark := FPDFBookmark_GetNextSibling(FDocument, NextBookmark);
  end;
end;

function TPdf.GetBookmarks: TBookmarks;
begin
  Result := GetNestedBookmarks(nil);
end;

function TPdf.GetBookmarkChildren(const Bookmark: TBookmark): TBookmarks;
begin
  if Bookmark.Handle <> nil then
    Result := GetNestedBookmarks(Bookmark.Handle);
end;

function TPdf.GetHasBookmarkChildren(const Bookmark: TBookmark): Boolean;
begin
  CheckActive;
  if Bookmark.Handle = nil then
    Result := False
  else
    Result := FPDFBookmark_GetFirstChild(FDocument, Bookmark.Handle) <> nil;
end;

function TPdf.GetLinkAnnotations: TLinkAnnotations;
begin
  if FLinkAnnotations = nil then
  begin
    CheckPageActive;
    FLinkAnnotations := PDFium.GetLinkAnnotations(FDocument, FPage);
  end;
  Result := FLinkAnnotations;
end;

function TPdf.GetLinkAnnotationCount: Integer;
begin
  Result := Length(GetLinkAnnotations);
end;

function TPdf.GetLinkAnnotation(Index: Integer): TLinkAnnotation;
begin
  Check((Index >= 0) and (Index < LinkAnnotationCount), 'Incorrect index');
  Result := GetLinkAnnotations[Index];
end;

function TPdf.GetWebLinks: TWebLinks;
begin
  if FWebLinks = nil then
  begin
    LoadTextPage;
    FWebLinks := PDFium.GetWebLinks(FTextPage);
  end;
  Result := FWebLinks;
end;

function TPdf.GetWebLinkCount: Integer;
begin
  Result := Length(GetWebLinks);
end;

function TPdf.GetWebLink(Index: Integer): TWebLink;
begin
  Check((Index >= 0) and (Index < WebLinkCount), 'Incorrect index');
  Result := GetWebLinks[Index];
end;

function TPdf.GetDestinationCount: Integer;
begin
  CheckActive;
  Result := FPDF_CountNamedDests(FDocument);
end;

function TPdf.RetrieveDestination(Handle: FPDF_DEST; const Name: WString): TDestination;
var
  HasX, HasY, HasZoom: FPDF_BOOL;
  X, Y, Zoom: Single;
begin
  Result.Handle := Handle;
  if Handle <> nil then
  begin
    Result.Name := Name;
    Result.PageNumber := FPDFDest_GetDestPageIndex(FDocument, Handle) + 1;
    Result.HasX := False;
    Result.HasY := False;
    Result.HasZoom := False;
    Result.X := 0;
    Result.Y := 0;
    Result.Zoom := 0;
    if FPDFDest_GetLocationInPage(Handle, HasX, HasY, HasZoom, X, Y, Zoom) <> 0 then
    begin
      Result.HasX := HasX <> 0;
      Result.HasY := HasY <> 0;
      Result.HasZoom := HasZoom <> 0;
      if Result.HasX then
        Result.X := X;
      if Result.HasY then
        Result.Y := Y;
      if Result.HasZoom then
        Result.Zoom := Zoom;
    end;
  end;
end;

function TPdf.GetDestination(Index: Integer): TDestination;
var
  Handle: FPDF_DEST;
  BufferLength: LongWord;
  Name: WString;
begin
  Check((Index >= 0) and (Index < DestinationCount), 'Incorrect index');
  Name := '';
  Handle := FPDF_GetNamedDest(FDocument, Index, nil, BufferLength);
  if Handle <> nil then
    if BufferLength > 2 then
    begin
      SetLength(Name, BufferLength div 2 - 1);
      FPDF_GetNamedDest(FDocument, Index, PWideChar(Name), BufferLength);
    end;
  Result := RetrieveDestination(Handle, Name);
end;

function TPdf.GetDestinationByName(const Name: WString): TDestination;
begin
  Result := RetrieveDestination(FPDF_GetNamedDestByName(FDocument, PAnsiChar(AnsiString(Name))), Name);
end;

procedure TPdf.AddPicture(Picture: TPicture; X, Y: Double);
begin
  AddPicture(Picture, X, Y, Picture.Width, Picture.Height);
end;

procedure TPdf.AddPicture(Picture: TPicture; X, Y, Width, Height: Double);
var Bitmap: TBitmap;
begin
  CheckPageActive;
  Bitmap := PictureToBitmap(Picture);
  try
    AddBitmap(FDocument, FPage, Bitmap, X, Y, Width, Height);
  finally
    Bitmap.Free;
  end;
end;

procedure TPdf.CheckPathCreated;
begin
  Check(FPath <> nil, 'Path was not created');
end;

procedure TPdf.CreatePath(X, Y: Single; FillMode: TPdfFillMode; FillColor: TColor; FillAlpha: Byte;
  Stroke: Boolean; StrokeColor: TColor; StrokeAlpha: Byte; StrokeWidth: Single;
  LineCap: TPdfLineCap; LineJoin: TPdfLineJoin; BlendMode: TPdfBlendMode);
var ARGB: FPDF_DWORD;
begin
  CheckPageActive;
  Check(FPath = nil, 'Path was already created');
  FPath := FPDFPageObj_CreateNewPath(X, Y);
  CheckPdf(FPath <> nil, 'Cannot create path');

  FPDFPath_SetDrawMode(FPath, EncodeFillMode(FillMode), Ord(Stroke));

  ARGB := ColorToARGB(FillColor, FillAlpha);
  FPDFPageObj_SetFillColor(FPath, FPDF_GetRValue(ARGB), FPDF_GetGValue(ARGB), FPDF_GetBValue(ARGB), FPDF_GetAValue(ARGB));

  if Stroke then
  begin
    ARGB := ColorToARGB(StrokeColor, StrokeAlpha);
    FPDFPageObj_SetStrokeColor(FPath, FPDF_GetRValue(ARGB), FPDF_GetGValue(ARGB), FPDF_GetBValue(ARGB), FPDF_GetAValue(ARGB));

    if StrokeWidth <> 1.0 then
      CheckPdf(FPDFPageObj_SetStrokeWidth(FPath, StrokeWidth) <> 0, 'Cannot set stroke width');
  end;

  if LineCap <> lcDefault then
    FPDFPageObj_SetLineCap(FPath, EncodeLineCap(LineCap));

  if LineJoin <> ljDefault then
    FPDFPageObj_SetLineJoin(FPath, EncodeLineJoin(LineJoin));

  if BlendMode <> bmDefault then
    FPDFPageObj_SetBlendMode(FPath, PAnsiChar(EncodeBlendMode(BlendMode)));
end;

procedure TPdf.CreatePath(X, Y, Width, Height: Single; FillMode: TPdfFillMode; FillColor: TColor; FillAlpha: Byte; Stroke: Boolean; StrokeColor: TColor; StrokeAlpha: Byte; StrokeWidth: Single;
  LineCap: TPdfLineCap; LineJoin: TPdfLineJoin; BlendMode: TPdfBlendMode);
var ARGB: FPDF_DWORD;
begin
  CheckPageActive;
  Check(FPath = nil, 'Path was already created');
  FPath := FPDFPageObj_CreateNewRect(X, Y, Width, Height);
  CheckPdf(FPath <> nil, 'Cannot create path');

  FPDFPath_SetDrawMode(FPath, EncodeFillMode(FillMode), Ord(Stroke));

  ARGB := ColorToARGB(FillColor, FillAlpha);
  FPDFPageObj_SetFillColor(FPath, FPDF_GetRValue(ARGB), FPDF_GetGValue(ARGB), FPDF_GetBValue(ARGB), FPDF_GetAValue(ARGB));

  if Stroke then
  begin
    ARGB := ColorToARGB(StrokeColor, StrokeAlpha);
    FPDFPageObj_SetStrokeColor(FPath, FPDF_GetRValue(ARGB), FPDF_GetGValue(ARGB), FPDF_GetBValue(ARGB), FPDF_GetAValue(ARGB));

    if StrokeWidth <> 1.0 then
      CheckPdf(FPDFPageObj_SetStrokeWidth(FPath, StrokeWidth) <> 0, 'Cannot set stroke width');
  end;

  if LineCap <> lcDefault then
    FPDFPageObj_SetLineCap(FPath, EncodeLineCap(LineCap));

  if LineJoin <> ljDefault then
    FPDFPageObj_SetLineJoin(FPath, EncodeLineJoin(LineJoin));

  if BlendMode <> bmDefault then
    FPDFPageObj_SetBlendMode(FPath, PAnsiChar(EncodeBlendMode(BlendMode)));
end;

procedure TPdf.AddPath;
begin
  CheckPathCreated;
  FPDFPage_InsertObject(Page, FPath);
  FPath := nil;
  UpdatePage;
end;

procedure TPdf.MoveTo(X, Y: Single);
begin
  CheckPathCreated;
  CheckPdf(FPDFPath_MoveTo(FPath, X, Y) <> 0, 'Cannot move');
end;

procedure TPdf.LineTo(X, Y: Single);
begin
  CheckPathCreated;
  CheckPdf(FPDFPath_LineTo(FPath, X, Y) <> 0, 'Cannot add line');
end;

procedure TPdf.BezierTo(X1, Y1, X2, Y2, X3, Y3: Single);
begin
  CheckPathCreated;
  CheckPdf(FPDFPath_BezierTo(FPath, X1, Y1, X2, Y2, X3, Y3) <> 0, 'Cannot add Bezier curve');
end;

procedure TPdf.ClosePath;
begin
  CheckPathCreated;
  CheckPdf(FPDFPath_Close(FPath) <> 0, 'Cannot close path');
end;

procedure TPdf.AddText(const Text, Font: WString; FontSize: Single; X, Y: Double; Color: TColor; Alpha: Byte);
var
  TextObject: FPDF_PAGEOBJECT;
  ARGB: FPDF_DWORD;
begin
  CheckPageActive;
  TextObject := FPDFPageObj_NewTextObj(Document, FPDF_BYTESTRING(AnsiString(Font)), FontSize);
  CheckPdf(TextObject <> nil, 'Cannot create text object');
  CheckPdf(FPDFText_SetText(TextObject, FPDF_WIDESTRING(WideString(Text))) <> 0, 'Cannot set text');
  ARGB := ColorToARGB(Color, Alpha);
  CheckPdf(FPDFPageObj_SetFillColor(TextObject, FPDF_GetRValue(ARGB), FPDF_GetGValue(ARGB), FPDF_GetBValue(ARGB), FPDF_GetAValue(ARGB)) <> 0, 'Cannot set color');
  FPDFPageObj_Transform(TextObject, 1, 0, 0, 1, X, Y);
  FPDFPage_InsertObject(Page, TextObject);
  UpdatePage;
end;

procedure TPdf.SetText(ObjectIndex: Integer; const Text: WString);
begin
  CheckPageActive;
  Check(ObjectType[ObjectIndex] = otText, 'Text object required');
  CheckPdf(FPDFText_SetText(ObjectHandle[ObjectIndex], FPDF_WIDESTRING(WideString(Text))) <> 0, 'Cannot set text');
  UpdatePage;
end;

const
  FPDFANNOT_TEXTTYPE_Contents = 'Contents';
  FPDFANNOT_TEXTTYPE_Author = 'T';

procedure SetAnnotationData(Annotation: FPDF_ANNOTATION; const Value: TPdfAnnotation);
var
  Color: FPDF_DWORD;
  QuadPoints: FS_QUADPOINTSF;
  Rectangle: FS_RECTF;
begin
  Check(FPDFAnnot_SetFlags(Annotation, EncodeAnnotationFlags(Value.Flags)) <> 0, 'Cannot set flags');

  if Value.HasColor then
  begin
    Color := ColorToARGB(Value.Color, Value.ColorAlpha);
    Check(FPDFAnnot_SetColor(Annotation, FPDFANNOT_COLORTYPE_Color, FPDF_GetRValue(Color), FPDF_GetGValue(Color), FPDF_GetBValue(Color), FPDF_GetAValue(Color)) <> 0, 'Cannot set color');
  end;

  if Value.HasInteriorColor then
  begin
    Color := ColorToARGB(Value.InteriorColor, Value.InteriorColorAlpha);
    Check(FPDFAnnot_SetColor(Annotation, FPDFANNOT_COLORTYPE_InteriorColor, FPDF_GetRValue(Color), FPDF_GetGValue(Color), FPDF_GetBValue(Color), FPDF_GetAValue(Color)) <> 0, 'Cannot set interior color');
  end;

  if Value.HasAttachmentPoints then
  begin
    QuadPoints.x1 := Value.AttachmentPoints[1].X;
    QuadPoints.y1 := Value.AttachmentPoints[1].Y;
    QuadPoints.x2 := Value.AttachmentPoints[2].X;
    QuadPoints.y2 := Value.AttachmentPoints[2].Y;
    QuadPoints.x3 := Value.AttachmentPoints[3].X;
    QuadPoints.y3 := Value.AttachmentPoints[3].Y;
    QuadPoints.x4 := Value.AttachmentPoints[4].X;
    QuadPoints.y4 := Value.AttachmentPoints[4].Y;
    Check(FPDFAnnot_SetAttachmentPoints(Annotation, 0, QuadPoints) <> 0, 'Cannot set attachment points');
  end;

  Rectangle.left := Value.Rectangle.Left;
  Rectangle.top := Value.Rectangle.Top;
  Rectangle.right := Value.Rectangle.Right;
  Rectangle.bottom := Value.Rectangle.Bottom;
  Check(FPDFAnnot_SetRect(Annotation, Rectangle) <> 0, 'Cannot set rectangle');

  Check(FPDFAnnot_SetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Contents, Pointer(Value.ContentsText)) <> 0, 'Cannot set contents text');
  Check(FPDFAnnot_SetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Author, Pointer(Value.AuthorText)) <> 0, 'Cannot set author text');
end;

procedure CreateAnnotation(Page: FPDF_PAGE; const Annotation: TPdfAnnotation);
var Handle: FPDF_ANNOTATION;
begin
  Check(FPDFAnnot_IsSupportedSubtype(EncodeAnnotationSubtype(Annotation.Subtype)) <> 0, 'Unsupported annotation subtype');
  Handle := FPDFPage_CreateAnnot(Page, EncodeAnnotationSubtype(Annotation.Subtype));
  Check(Handle <> nil, 'Cannot create annotation');
  try
    SetAnnotationData(Handle, Annotation);
  finally
    FPDFPage_CloseAnnot(Handle);
  end;
end;

procedure DeleteAnnotation(Page: FPDF_PAGE; Index: Integer);
begin
  Check((Index >= 0) and (Index < FPDFPage_GetAnnotCount(Page)), 'Incorrect index');
  CheckPdf(FPDFPage_RemoveAnnot(Page, Index) <> 0, 'Cannot delete annotation');
end;

function GetAnnotation(Page: FPDF_PAGE; Index: Integer): TPdfAnnotation;
var
  Annotation: FPDF_ANNOTATION;
  R, G, B, A: LongWord;
  QuadPoints: FS_QUADPOINTSF;
  Rectangle: FS_RECTF;
  ContentLength: LongWord;
begin
  Check((Index >= 0) and (Index < FPDFPage_GetAnnotCount(Page)), 'Incorrect index');
  Annotation := FPDFPage_GetAnnot(Page, Index);
  Check(Annotation <> nil, 'Cannot retrieve annotation');
  try
    FillChar(Result, SizeOf(Result), 0);
    Result.Subtype := DecodeAnnotationSubtype(FPDFAnnot_GetSubtype(Annotation));
    Result.Flags := DecodeAnnotationFlags(FPDFAnnot_GetFlags(Annotation));

    Result.HasColor := FPDFAnnot_GetColor(Annotation, FPDFANNOT_COLORTYPE_Color, R, G, B, A) <> 0;
    if Result.HasColor then
    begin
      Result.Color := Byte(R) or (Byte(G) shl 8) or (Byte(B) shl 16);
      Result.ColorAlpha := Byte(A);
    end;

    Result.HasInteriorColor := FPDFAnnot_GetColor(Annotation, FPDFANNOT_COLORTYPE_InteriorColor, R, G, B, A) <> 0;
    if Result.HasInteriorColor then
    begin
      Result.InteriorColor := Byte(R) or (Byte(G) shl 8) or (Byte(B) shl 16);
      Result.InteriorColorAlpha := Byte(A);
    end;

    Result.HasAttachmentPoints := False;
    if FPDFAnnot_HasAttachmentPoints(Annotation) <> 0 then
      if FPDFAnnot_GetAttachmentPoints(Annotation, 0, QuadPoints) <> 0 then
      begin
        Result.HasAttachmentPoints := True;
        Result.AttachmentPoints[1].X := QuadPoints.x1;
        Result.AttachmentPoints[1].Y := QuadPoints.y1;
        Result.AttachmentPoints[2].X := QuadPoints.x2;
        Result.AttachmentPoints[2].Y := QuadPoints.y2;
        Result.AttachmentPoints[3].X := QuadPoints.x3;
        Result.AttachmentPoints[3].Y := QuadPoints.y3;
        Result.AttachmentPoints[4].X := QuadPoints.x4;
        Result.AttachmentPoints[4].Y := QuadPoints.y4;
      end;

    Check(FPDFAnnot_GetRect(Annotation, Rectangle) <> 0, 'Cannot retrieve rectangle');
    Result.Rectangle.Left := Rectangle.left;
    Result.Rectangle.Top := Rectangle.top;
    Result.Rectangle.Right := Rectangle.right;
    Result.Rectangle.Bottom := Rectangle.bottom;

    ContentLength := FPDFAnnot_GetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Contents, nil, 0);
    if ContentLength > 0 then
    begin
      SetLength(Result.ContentsText, ContentLength div 2 - 1);
      FPDFAnnot_GetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Contents, Pointer(Result.ContentsText), ContentLength);
    end;

    ContentLength := FPDFAnnot_GetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Author, nil, 0);
    if ContentLength > 0 then
    begin
      SetLength(Result.AuthorText, ContentLength div 2 - 1);
      FPDFAnnot_GetStringValue(Annotation, FPDFANNOT_TEXTTYPE_Author, Pointer(Result.AuthorText), ContentLength);
    end;
  finally
    FPDFPage_CloseAnnot(Annotation);
  end;
end;

procedure SetAnnotation(Page: FPDF_PAGE; Index: Integer; const Value: TPdfAnnotation);
var Annotation: FPDF_ANNOTATION;
begin
  Check((Index >= 0) and (Index < FPDFPage_GetAnnotCount(Page)), 'Incorrect index');
  Annotation := FPDFPage_GetAnnot(Page, Index);
  Check(Annotation <> nil, 'Cannot retrieve annotation');
  try
    Check(Value.Subtype = DecodeAnnotationSubtype(FPDFAnnot_GetSubtype(Annotation)), 'Incorrect annotation subtype');
    SetAnnotationData(Annotation, Value);
  finally
    FPDFPage_CloseAnnot(Annotation);
  end;
end;

function TPdf.GetAnnotationCount: Integer;
begin
  CheckPageActive;
  Result := FPDFPage_GetAnnotCount(Page);
end;

function TPdf.GetAnnotation(Index: Integer): TPdfAnnotation;
begin
  CheckPageActive;
  Result := PDFium.GetAnnotation(Page, Index);
end;

procedure TPdf.SetAnnotation(Index: Integer; const Value: TPdfAnnotation);
begin
  CheckPageActive;
  PDFium.SetAnnotation(Page, Index, Value);
end;

procedure TPdf.CreateAnnotation(const Annotation: TPdfAnnotation);
begin
  CheckPageActive;
  PDFium.CreateAnnotation(Page, Annotation);
end;

procedure TPdf.DeleteAnnotation(Index: Integer);
begin
  CheckPageActive;
  PDFium.DeleteAnnotation(Page, Index);
end;

function TPdf.GetFormType: TPdfFormType;
begin
  CheckActive;
  Result := DecodeFormType(FPDF_GetFormType(FDocument));
end;

function TPdf.GetIsTagged: Boolean;
begin
  CheckActive;
  Result := FPDFCatalog_IsTagged(FDocument) <> 0;
end;

function TPdf.GetFormFieldCount: Integer;
begin
  Result := AnnotationCount;
end;

function GetFormField(Page: FPDF_PAGE; Index: Integer): WString;
var
  Annotation: FPDF_ANNOTATION;
  ContentLength: LongWord;
begin
  Result := '';
  Annotation := FPDFPage_GetAnnot(Page, Index);
  Check(Annotation <> nil, 'Cannot retrieve annotation');
  try
    ContentLength := FPDFAnnot_GetStringValue(Annotation, 'V', nil, 0);
    if ContentLength > 0 then
    begin
      SetLength(Result, ContentLength div 2 - 1);
      FPDFAnnot_GetStringValue(Annotation, 'V', Pointer(Result), ContentLength);
    end;
  finally
    FPDFPage_CloseAnnot(Annotation);
  end;
end;

function TPdf.GetFormField(Index: Integer): WString;
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  Result := PDFium.GetFormField(Page, Index);
end;

procedure SetFormField(Page: FPDF_PAGE; Index: Integer; const Value: WString);
var Annotation: FPDF_ANNOTATION;
begin
  Annotation := FPDFPage_GetAnnot(Page, Index);
  Check(Annotation <> nil, 'Cannot retrieve annotation');
  try
    Check(FPDFAnnot_SetStringValue(Annotation, 'V', Pointer(Value)) <> 0, 'Cannot set form field value');
  finally
    FPDFPage_CloseAnnot(Annotation);
  end;
end;

procedure TPdf.SetFormField(Index: Integer; const Value: WString);
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  PDFium.SetFormField(Page, Index, Value);
end;

function GetFormFieldFlags(FormHandle: FPDF_FORMHANDLE; Page: FPDF_PAGE; Index: Integer): TPdfFormFieldFlags;
var Annotation: FPDF_ANNOTATION;
begin
  Annotation := FPDFPage_GetAnnot(Page, Index);
  Check(Annotation <> nil, 'Cannot retrieve annotation');
  try
    Result := DecodeFormFieldFlags(FPDFAnnot_GetFormFieldFlags(FormHandle, Annotation));
  finally
    FPDFPage_CloseAnnot(Annotation);
  end;
end;

function TPdf.GetFormFieldFlags(Index: Integer): TPdfFormFieldFlags;
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  Result := PDFium.GetFormFieldFlags(FormHandle, Page, Index);
end;

function TPdf.GetXFA: Boolean;
begin
  Result := @FPDF_LoadXFA <> nil;
end;

//---------------------------------------------------------------------
//
// TPdfView
//

constructor TPdfView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCache := True;
  FPageNumber := 1;
  Color := clWhite;
  DoubleBuffered := True;
  Options := [reLcd];
end;

destructor TPdfView.Destroy;
begin
  Active := False;
  inherited Destroy;
end;

function TPdfView.GetAbout: string;
begin
  Result := AboutInfo;
end;

procedure TPdfView.SetAbout(const Value: string);
begin
end;

procedure TPdfView.CheckActive;
begin
  if not (csDesigning in ComponentState) then
    Check(Active, 'Cannot perform this operation on an inactive ' + Name + ' component');
end;

procedure TPdfView.CheckInactive;
begin
  if not (csDesigning in ComponentState) then
    Check(not Active, 'Cannot perform this operation on an active ' + Name + ' component');
end;

procedure TPdfView.CheckFindActive;
begin
  CheckActive;
  Check(FFind <> nil, 'Uninitialized search');
end;

procedure TPdfView.ClearCache;
begin
  FreeAndNil(FCachedBitmap);
end;

procedure TPdfView.Loaded;
begin
  inherited Loaded;
  SetActive(FActive);
end;

function TPdfView.GetActive: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FPage <> nil
  else
    Result := FActive;
end;

procedure TPdfView.SetActive(Value: Boolean);
begin
  if Active <> Value then
    if not (csDesigning in ComponentState) then
      if not (csLoading in ComponentState) then
        if Value then
        begin
          if FPdf <> nil then
          begin
            if csLoading in FPdf.ComponentState then
              Exit;
            FPdf.Active := True;
            CheckPdf(FPageNumber <> 0, 'Incorrect page number');
            ReloadPage;
          end;
        end
        else
          UnloadPage;

  FActive := Value;
end;

procedure TPdfView.SetOptions(Value: TRenderOptions);
begin
  if Value <> FOptions then
  begin
    FOptions := Value;
    ClearCache;
    Invalidate;
  end;
end;

procedure TPdfView.SetRotation(Value: TRotation);
begin
  if Value <> FRotation then
  begin
    FRotation := Value;
    ClearCache;
    Invalidate;
  end;
end;

procedure TPdfView.SetCache(Value: Boolean);
begin
  FCache := Value;
  if not FCache then
    ClearCache;
end;

procedure TPdfView.Paint;
var Bitmap: TBitmap;
begin
//  Canvas.Brush.Color := Color;
  if csDesigning in ComponentState then
  begin
    with Canvas do
    begin
      Pen.Style := psDash;
//      Brush.Style := bsClear;
      Rectangle(0, 0, Self.Width, Self.Height);
    end;
  end
  else
  begin
    with Canvas do
    begin
      if Active then
        if (FormHandle = nil) and not Cache then
          RenderPage(Canvas.Handle, 0, 0, Self.Width, Self.Height, Rotation, Options)
        else
        begin
          if (FormHandle = nil) and Cache and (FCachedBitmap <> nil) and (FCachedWidth = Self.Width) and (FCachedHeight = Self.Height) then
            Bitmap := FCachedBitmap
          else
          begin
            ClearCache;
            Bitmap := RenderPage(0, 0, Self.Width, Self.Height, Rotation, Options);
            if Cache then
            begin
              FCachedBitmap := Bitmap;
              FCachedWidth := Self.Width;
              FCachedHeight := Self.Height;
            end;
          end;

          try
            Canvas.Draw(0, 0, Bitmap);
          finally
            if not Cache then
              FreeAndNil(Bitmap);
          end;
        end
    end;
  end;
  if Assigned(FOnPaint) then
    FOnPaint(Self);
end;

procedure TPdfView.PaintSelection(SelectionStart, SelectionEnd: Integer; Mask: TColor);
var
  OldPenMode: TPenMode;
  RectangleCount, I: Integer;
begin
  if (SelectionStart <> -1) and (SelectionEnd <> -1) then
  begin
    OldPenMode := Canvas.Pen.Mode;
    try
      Canvas.Pen.Mode := pmMask;
      Canvas.Pen.Color := Mask;

      Canvas.Brush.Color := Mask;
      Canvas.Brush.Style := bsSolid;

      if SelectionEnd < SelectionStart then
        RectangleCount := Self.RectangleCount(SelectionEnd, SelectionStart - SelectionEnd + 1)
      else
        RectangleCount := Self.RectangleCount(SelectionStart, SelectionEnd - SelectionStart + 1);

      for I := 0 to RectangleCount - 1 do
        Canvas.Rectangle(Rectangle[I]);
    finally
      Canvas.Pen.Mode := OldPenMode;
    end
  end;
end;

procedure TPdfView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FPdf) then
  begin
    Active := False;
    FPdf.FPdfViews.Remove(Self);
    FPdf := nil;
  end;
end;

procedure TPdfView.SetPdf(Value: TPdf);
begin
  if not (csDesigning in ComponentState) then
    if not (csLoading in ComponentState) then
      CheckInactive;

  if FPdf <> Value then
  begin
    if FPdf <> nil then
      FPdf.FPdfViews.Remove(Self);
    FPdf := Value;
    if FPdf <> nil then
      FPdf.FPdfViews.Add(Self);
  end;
end;

function TPdfView.DeviceToPage(X, Y: Integer; out PageX, PageY: Double): Boolean;
begin
  CheckActive;
  Result := FPDF_DeviceToPage(FPage, 0, 0, Self.Width, Self.Height, Ord(Rotation), X, Y, PageX, PageY) <> 0;
end;

function TPdfView.DeviceToPage(Rectangle: TRect): TPdfRectangle;
begin
  Check(DeviceToPage(Rectangle.Left, Rectangle.Top, Result.Left, Result.Top), 'Cannot convert to page coordinates');
  Check(DeviceToPage(Rectangle.Right, Rectangle.Bottom, Result.Right, Result.Bottom), 'Cannot convert to page coordinates');
end;

function TPdfView.PageToDevice(PageX, PageY: Double; out X, Y: Integer): Boolean;
begin
  CheckActive;
  Result := FPDF_PageToDevice(FPage, 0, 0, Self.Width, Self.Height, Ord(Rotation), PageX, PageY, X, Y) <> 0;
end;

function TPdfView.PageToDevice(Rectangle: TPdfRectangle): TRect;
begin
  Check(PageToDevice(Rectangle.Left, Rectangle.Top, Result.Left, Result.Top), 'Cannot convert to device coordinates');
  Check(PageToDevice(Rectangle.Right, Rectangle.Bottom, Result.Right, Result.Bottom), 'Cannot convert to device coordinates');
end;

function TPdfView.CharacterIndexAtPos(X, Y: Integer; ToleranceX, ToleranceY: Double): Integer;
var PageX, PageY: Double;
begin
  LoadTextPage;
  if not DeviceToPage(X, Y, PageX, PageY) then
    Result := -3
  else
    Result := FPDFText_GetCharIndexAtPos(FTextPage, PageX, PageY, ToleranceX, ToleranceY);
end;

function TPdfView.WebLinkAtPos(X, Y: Integer): Integer;
var
  PageX, PageY: Double;
  I, J: Integer;
  Rectangles: TPdfRectangles;
  Rectangle: TPdfRectangle;
begin
  Rectangles := nil; // to avoid warning

  if WebLinkCount > 0 then
    if DeviceToPage(X, Y, PageX, PageY) then
      for I := 0 to WebLinkCount - 1 do
      begin
        Rectangles := WebLink[I].Rectangles;
        for J := 0 to Length(Rectangles) - 1 do
        begin
          Rectangle := Rectangles[J];
          if (PageX >= Rectangle.Left) and (PageX <= Rectangle.Right) then
            if (PageY <= Rectangle.Top) and (PageY >= Rectangle.Bottom) then
            begin
              Result := I;
              Exit;
            end;
        end;
      end;

  Result := -1;
end;

function TPdfView.LinkAnnotationAtPos(X, Y: Integer): Integer;
var
  PageX, PageY: Double;
  I: Integer;
  Rectangle: TPdfRectangle;
begin
  if LinkAnnotationCount > 0 then
    if DeviceToPage(X, Y, PageX, PageY) then
      for I := 0 to LinkAnnotationCount - 1 do
      begin
        Rectangle := LinkAnnotation[I].Rectangle;
        if (PageX >= Rectangle.Left) and (PageX <= Rectangle.Right) then
          if (PageY <= Rectangle.Top) and (PageY >= Rectangle.Bottom) then
          begin
            Result := I;
            Exit;
          end;
      end;

  Result := -1;
end;

function TPdfView.GetPageCount: Integer;
begin
  if FPdf <> nil then
    Result := FPdf.PageCount
  else
    Result := 0;
end;

function TPdfView.GetPageBounds: TPdfRectangle;
var Rectangle: FS_RECTF;
begin
  CheckActive;
  CheckPdf(FPDF_GetPageBoundingBox(FPage, Rectangle) <> 0, 'Cannot retrieve page bounds');
  Result.Left := Rectangle.left;
  Result.Top := Rectangle.top;
  Result.Right := Rectangle.right;
  Result.Bottom := Rectangle.bottom;
end;

function TPdfView.GetPageHeight: Double;
begin
  CheckActive;
  Result := FPDF_GetPageHeight(FPage);
end;

function TPdfView.GetPageWidth: Double;
begin
  CheckActive;
  Result := FPDF_GetPageWidth(FPage);
end;

function TPdfView.GetPageLabel: WString;
begin
  CheckActive;
  Result := FPdf.PageLabel[PageNumber];
end;

function TPdfView.GetCharacterCount: Integer;
begin
  LoadTextPage;
  Result := FPDFText_CountChars(FTextPage);
end;

function TPdfView.GetCharacter(Index: Integer): WideChar;
begin
  LoadTextPage;
  Result := WideChar(FPDFText_GetUnicode(FTextPage, Index));
end;

function TPdfView.GetCharcode(Index: Integer): WideChar;
begin
  LoadTextPage;
  Result := WideChar(FPDFText_GetCharcode(FTextPage, Index));
end;

function TPdfView.GetFontSize(Index: Integer): Double;
begin
  LoadTextPage;
  Result := FPDFText_GetFontSize(FTextPage, Index);
end;

function TPdfView.GetCharacterOrigin(Index: Integer): TPoint;
var Point: TPdfPoint;
begin
  LoadTextPage;
  FPDFText_GetCharOrigin(FTextPage, Index, Point.X, Point.Y);
  Check(PageToDevice(Point.X, Point.Y, Result.X, Result.Y), 'Cannot convert to device coordinates');
end;

function TPdfView.GetCharacterRectangle(Index: Integer): TRect;
var Rectangle: TPdfRectangle;
begin
  LoadTextPage;
  FPDFText_GetCharBox(FTextPage, Index, Rectangle.Left, Rectangle.Right, Rectangle.Bottom, Rectangle.Top);
  Result := PageToDevice(Rectangle);
end;

function TPdfView.RectangleCount(StartIndex: Integer = 0; Count: Integer = MaxInt): Integer;
begin
  LoadTextPage;
  Result := FPDFText_CountRects(FTextPage, StartIndex, Count);
end;

function TPdfView.GetRectangle(Index: Integer): TRect;
var Rectangle: TPdfRectangle;
begin
  LoadTextPage;
  FPDFText_GetRect(FTextPage, Index, Rectangle.Left, Rectangle.Top, Rectangle.Right, Rectangle.Bottom);
  Result := PageToDevice(Rectangle);
end;

function TPdfView.GetTransparent: Boolean;
begin
  CheckActive;
  Result := FPDFPage_HasTransparency(FPage) <> 0;
end;

procedure TPdfView.SetPageNumber(Value: Integer);
begin
  if Value <> FPageNumber then
  begin
    FPageNumber := Value;
    if (FPdf <> nil) and (FPdf.Active) then
      if not (csDesigning in ComponentState) then
        if not (csLoading in ComponentState) then
          ReloadPage;
  end;
end;

procedure TPdfView.ReloadPage;
begin
  UnloadPage;
  Check(Pdf <> nil, 'Pdf property not set');
  Pdf.CheckActive;

  if FPageNumber <> 0 then
  begin
    FPage := FPDF_LoadPage(Pdf.FDocument, FPageNumber - 1);
    CheckPdf(FPage <> nil, 'Cannot open page ' + IntToStr(FPageNumber));

    if Pdf.FFormHandle <> nil then
    begin
      FORM_OnAfterLoadPage(FPage, Pdf.FFormHandle);
      FORM_DoPageAAction(FPage, Pdf.FFormHandle, FPDFPAGE_AACTION_OPEN);
    end;
  end;

  if Assigned(OnPageChange) then
    FOnPageChange(Self)
  else
    Invalidate;
end;

procedure TPdfView.UnloadPage;
begin
  ClearCache;
  UnloadTextPage;
  if FPage <> nil then
  begin
    if (Pdf <> nil) and (Pdf.FFormHandle <> nil) then
    begin
      FORM_DoPageAAction(FPage, Pdf.FFormHandle, FPDFPAGE_AACTION_CLOSE);
      FORM_OnBeforeClosePage(FPage, Pdf.FFormHandle);
    end;
    FPDF_ClosePage(FPage);
    FPage := nil;
    FLinkAnnotations := nil;
  end;
end;

procedure TPdfView.LoadTextPage;
var ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if FTextPage = nil then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      FTextPage := FPDFText_LoadPage(FPage);
      CheckPdf(FTextPage <> nil, 'Cannot open text page');
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;
  end
end;

procedure TPdfView.UnloadTextPage;
begin
  UnloadFind;
  if FTextPage <> nil then
  begin
    FPDFText_ClosePage(FTextPage);
    FTextPage := nil;
    FWebLinks := nil;
  end;
end;

procedure TPdfView.ReloadFind(const Text: WString; Options: TSearchOptions; StartIndex: Integer);
begin
  UnloadFind;
  LoadTextPage;
  FFind := FPDFText_FindStart(FTextPage, PWideChar(Text), EncodeSearchOptions(Options), StartIndex);
  CheckPdf(FFind <> nil, 'Cannot start find');
end;

procedure TPdfView.UnloadFind;
begin
  if FFind <> nil then
  begin
    FPDFText_FindClose(FFind);
    FFind := nil;
  end;
end;

procedure TPdfView.RenderPage(DeviceContext: HDC; Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions);
begin
  CheckActive;
  FPDF_RenderPage(DeviceContext, FPage, Left, Top, Width, Height, Ord(Rotation), EncodeRenderOptions(Options));
end;

function TPdfView.RenderPage(Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions): TBitmap;
begin
  CheckActive;
  Result := PDFium.RenderPage(FormHandle, nil, FPage, Left, Top, Width, Height, Rotation, Options, Color);
end;

procedure TPdfView.RenderPage(Bitmap: TBitmap; Left, Top, Width, Height: Integer; Rotation: TRotation; Options: TRenderOptions);
begin
  CheckActive;
  if Bitmap <> nil then
    PDFium.RenderPage(FormHandle, Bitmap, FPage, Left, Top, Width, Height, Rotation, Options, Color);
end;

function TPdfView.Text(StartIndex, Count: Integer): WString;
begin
  LoadTextPage;
  Result := GetText(FTextPage, StartIndex, Count);
end;

function TPdfView.GetWebLinks: TWebLinks;
begin
  if FWebLinks = nil then
  begin
    LoadTextPage;
    FWebLinks := PDFium.GetWebLinks(FTextPage);
  end;
  Result := FWebLinks;
end;

function TPdfView.GetWebLinkCount: Integer;
begin
  Result := Length(GetWebLinks);
end;

function TPdfView.GetWebLink(Index: Integer): TWebLink;
begin
  Check((Index >= 0) and (Index < WebLinkCount), 'Incorrect index');
  Result := GetWebLinks[Index];
end;

function TPdfView.GetLinkAnnotations: TLinkAnnotations;
begin
  if FLinkAnnotations = nil then
  begin
    CheckActive;
    FLinkAnnotations := PDFium.GetLinkAnnotations(FPdf.FDocument, FPage);
  end;
  Result := FLinkAnnotations;
end;

function TPdfView.GetLinkAnnotationCount: Integer;
begin
  Result := Length(GetLinkAnnotations);
end;

function TPdfView.GetLinkAnnotation(Index: Integer): TLinkAnnotation;
begin
  Check((Index >= 0) and (Index < LinkAnnotationCount), 'Incorrect index');
  Result := GetLinkAnnotations[Index];
end;

function TPdfView.GetPageRotation: TRotation;
begin
  CheckActive;
  Result := TRotation(FPDFPage_GetRotation(FPage));
end;

procedure TPdfView.SetPageRotation(Value: TRotation);
begin
  CheckActive;
  FPDFPage_SetRotation(FPage, Ord(Value));
  ReloadPage;
end;

function TPdfView.GetObjectCount: Integer;
begin
  CheckActive;
  Result := FPDFPage_CountObjects(FPage);
end;

function TPdfView.GetObjectHandle(Index: Integer): Pointer;
begin
  CheckActive;
  Check((Index >= 0) and (Index < ObjectCount), 'Incorrect index');
  Result := FPDFPage_GetObject(FPage, Index);
end;

function TPdfView.GetObjectType(Index: Integer): TObjectType;
begin
  Result := DecodeObjectType(FPDFPageObj_GetType(GetObjectHandle(Index)));
end;

function TPdfView.GetObjectBitmap(Index: Integer): TBitmap;
var Bitmap: FPDF_BITMAP;
begin
  Result := nil;
  Bitmap := FPDFImageObj_GetBitmap(GetObjectHandle(Index));
  if Bitmap <> nil then
  try
    Result := TBitmap.Create;
    ToBitmap(Bitmap, Result);
  finally
    FPDFBitmap_Destroy(Bitmap);
  end;
end;

function TPdfView.GetObjectBounds(Index: Integer): TPdfRectangle;
var Left, Top, Right, Bottom: Single;
begin
  Check(FPDFPageObj_GetBounds(GetObjectHandle(Index), Left, Bottom, Right, Top) <> 0, 'Cannot retrieve data');
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function TPdfView.GetObjectTransparent(Index: Integer): Boolean;
begin
  Result := FPDFPageObj_HasTransparency(GetObjectHandle(Index)) <> 0;
end;

function TPdfView.GetImageCount: Integer;
var I: Integer;
begin
  Result := 0;
  for I := ObjectCount - 1 downto 0 do
    if ObjectType[I] = otImage then
      Inc(Result);
end;

function TPdfView.ImageIndexToObjectIndex(Index: Integer): Integer;
var I: Integer;
begin
  for I := 0 to ObjectCount - 1 do
    if ObjectType[I] = otImage then
      if Index > 0 then
        Dec(Index)
      else
      begin
        Result := I;
        Exit;
      end;

  Result := -1;
end;

function TPdfView.GetImage(Index: Integer): TPdfImage;
var ObjectIndex: Integer;
begin
  ObjectIndex := ImageIndexToObjectIndex(Index);
  Check(ObjectIndex <> -1, 'Incorrect index');
  Result := PDFium.GetImage(ObjectHandle[ObjectIndex]);
end;

function TPdfView.FindFirst(const Text: WString; Options: TSearchOptions = []; StartIndex: Integer = 0; DirectionUp: Boolean = True): Integer;
begin
  ReloadFind(Text, Options, StartIndex);
  if DirectionUp then
    Result := FindNext
  else
    Result := FindPrevious
end;

function TPdfView.FindNext: Integer;
begin
  CheckFindActive;
  if FPDFText_FindNext(FFind) = 0 then
    Result := -1
  else
    Result := FPDFText_GetSchResultIndex(FFind);
end;

function TPdfView.FindPrevious: Integer;
begin
  CheckFindActive;
  if  FPDFText_FindPrev(FFind) = 0 then
    Result := -1
  else
    Result := FPDFText_GetSchResultIndex(FFind);
end;

function TPdfView.TextInRectangle(Left, Top, Right, Bottom: Integer): WString;
var
  Count: Integer;
  PageLeft, PageTop, PageRight, PageBottom: Double;
begin
  Result := '';

  if not DeviceToPage(Left, Top, PageLeft, PageTop) then
    Exit;

  if not DeviceToPage(Right, Bottom, PageRight, PageBottom) then
    Exit;

  LoadTextPage;
  Count := FPDFText_GetBoundedText(FTextPage, PageLeft, PageTop, PageRight, PageBottom, nil, 0);
  if Count > 0 then
  begin
    SetLength(Result, Count);
    FPDFText_GetBoundedText(FTextPage, PageLeft, PageTop, PageRight, PageBottom, PWideChar(Result), Count);
  end;
end;

function TPdfView.TextInRectangle(Rectangle: TRect): WString;
begin
  Result := TextInRectangle(Rectangle.Left, Rectangle.Top, Rectangle.Right, Rectangle.Bottom);
end;

procedure TPdfView.AddPicture(Picture: TPicture; X, Y: Integer);
begin
  AddPicture(Picture, X, Y, Picture.Width, Picture.Height);
end;

procedure TPdfView.AddPicture(Picture: TPicture; X, Y, Width, Height: Integer);
var
  Bitmap: TBitmap;
  PageX, PageY, PageRight, PageTop: Double;
begin
  CheckActive;
  Bitmap := PictureToBitmap(Picture);
  try
    Check(DeviceToPage(X, Y, PageX, PageY), 'Cannot convert to page coordinates');
    Check(DeviceToPage(X + Width, Y - Height, PageRight, PageTop), 'Cannot convert to page coordinates');

    AddBitmap(FPdf.FDocument, FPage, Bitmap, PageX, PageY, PageRight - PageX, PageTop - PageY);
  finally
    Bitmap.Free;
  end;
end;

function TPdfView.GetBitmapCount: Integer;
begin
  Result := ImageCount;
end;

function TPdfView.GetBitmap(Index: Integer): TBitmap;
var ObjectIndex: Integer;
begin
  ObjectIndex := ImageIndexToObjectIndex(Index);
  Check(ObjectIndex <> -1, 'Incorrect index');
  Result := PDFium.GetBitmap(ObjectHandle[ObjectIndex]);
end;

procedure TPdfView.UpdatePage;
begin
  CheckActive;
  CheckPdf(FPDFPage_GenerateContent(FPage) <> 0, 'Cannot create page content');
end;

function TPdfView.GetAnnotationCount: Integer;
begin
  CheckActive;
  Result := FPDFPage_GetAnnotCount(Page);
end;

function TPdfView.GetAnnotation(Index: Integer): TPdfAnnotation;
begin
  CheckActive;
  Result := PDFium.GetAnnotation(Page, Index);
end;

procedure TPdfView.SetAnnotation(Index: Integer; const Value: TPdfAnnotation);
begin
  CheckActive;
  PDFium.SetAnnotation(Page, Index, Value);
end;

procedure TPdfView.CreateAnnotation(const Annotation: TPdfAnnotation);
begin
  CheckActive;
  PDFium.CreateAnnotation(Page, Annotation);
end;

procedure TPdfView.DeleteAnnotation(Index: Integer);
begin
  CheckActive;
  PDFium.DeleteAnnotation(Page, Index);
end;

function TPdfView.GetFormFieldCount: Integer;
begin
  Result := AnnotationCount;
end;

function TPdfView.GetFormField(Index: Integer): WString;
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  Result := PDFium.GetFormField(Page, Index);
end;

procedure TPdfView.SetFormField(Index: Integer; const Value: WString);
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  PDFium.SetFormField(Page, Index, Value);
end;

function TPdfView.GetFormFieldFlags(Index: Integer): TPdfFormFieldFlags;
begin
  Check((Index >= 0) and (Index < FormFieldCount), 'Incorrect index');
  Result := PDFium.GetFormFieldFlags(FormHandle, Page, Index);
end;

function TPdfView.GetFormHandle: FPDF_FORMHANDLE;
begin
  if Pdf = nil then
    Result := nil
  else
    Result := Pdf.FormHandle;
end;

function EncodeShiftState(Shift: TShiftState): Integer;
begin
  Result := 0;
  if ssShift in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_ShiftKey);
  if ssAlt in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_AltKey);
  if ssCtrl in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_ControlKey);
  if ssLeft in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_LeftButtonDown);
  if ssRight in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_RightButtonDown);
  if ssMiddle in Shift then
    Result := Result or Ord(FWL_EVENTFLAG_MiddleButtonDown);
end;

procedure TPdfView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var PageX, PageY: Double;
begin
  if Button = mbLeft then
    if FormHandle <> nil then
      if DeviceToPage(X, Y, PageX, PageY) then
        if ssDouble in Shift then
          FORM_OnLButtonDoubleClick(FormHandle, Page, EncodeShiftState(Shift), PageX, PageY)
        else
          FORM_OnLButtonDown(FormHandle, Page, EncodeShiftState(Shift), PageX, PageY);

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TPdfView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var PageX, PageY: Double;
begin
  if Button = mbLeft then
    if FormHandle <> nil then
      if DeviceToPage(X, Y, PageX, PageY) then
        FORM_OnLButtonUp(FormHandle, Page, EncodeShiftState(Shift), PageX, PageY);

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TPdfView.MouseMove(Shift: TShiftState; X, Y: Integer);
var PageX, PageY: Double;
begin
  if FormHandle <> nil then
    if DeviceToPage(X, Y, PageX, PageY) then
      FORM_OnMouseMove(FormHandle, Page, EncodeShiftState(Shift), PageX, PageY);

  inherited MouseMove(Shift, X, Y);
end;

procedure TPdfView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FormHandle <> nil then
  begin
    if Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_DELETE] then
      Shift := Shift + [ssAlt];
    FORM_OnKeyDown(FormHandle, Page, Key, EncodeShiftState(Shift));
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TPdfView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if FormHandle <> nil then
  begin
    if Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_DELETE] then
      Shift := Shift + [ssAlt];
    FORM_OnKeyUp(FormHandle, Page, Key, EncodeShiftState(Shift));
  end;
  inherited KeyUp(Key, Shift);
end;

procedure TPdfView.KeyPress(var Key: Char);
begin
  if FormHandle <> nil then
    FORM_OnChar(FormHandle, Page, Ord(Key), 0);
  inherited KeyPress(Key)
end;

function TPdfView.IsFormFillEdit: Boolean;
begin
  Result := (FormHandle <> nil) and (Pdf.FTimer <> nil) and Pdf.FTimer.Enabled;
end;

procedure TPdfView.WndProc(var Message: TMessage);
var
  Form: TCustomForm;
  OriginalKeyPreview: Boolean;
begin
  if IsFormFillEdit then
    case Message.Msg of
      WM_KILLFOCUS:
        if FormHandle <> nil then
          FORM_ForceToKillFocus(FormHandle);

      CN_KEYDOWN:
        case Message.WParam of
          VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_TAB, VK_DELETE:
          begin
            if IsFormFillEdit then
              Form := GetParentForm(Self)
            else
              Form := nil;

            OriginalKeyPreview := False; // to avoid warning
            if Form <> nil then
            begin
              OriginalKeyPreview := Form.KeyPreview;
              Form.KeyPreview := False;
            end;

            try
              {$ifdef FPC}
                DoRemainingKeyDown(TLMKeyDown(Message));
              {$else}
                DoKeyDown(TWMKey(Message));
              {$endif FPC}
            finally
              if Form <> nil then
                Form.KeyPreview := OriginalKeyPreview;
            end;

            Message.Result := 1;
            Exit;
          end;
        end;

      CN_KEYUP:
        case Message.WParam of
          VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_TAB, VK_DELETE:
          begin
            if IsFormFillEdit then
              Form := GetParentForm(Self)
            else
              Form := nil;

            OriginalKeyPreview := False; // to avoid warning
            if Form <> nil then
            begin
              OriginalKeyPreview := Form.KeyPreview;
              Form.KeyPreview := False;
            end;

            try
              {$ifdef FPC}
                DoRemainingKeyUp(TLMKeyDown(Message));
              {$else}
                DoKeyUp(TWMKey(Message));
              {$endif FPC}
            finally
              if Form <> nil then
                Form.KeyPreview := OriginalKeyPreview;
            end;

            Message.Result := 1;
            Exit;
          end;
        end;
    end;

  inherited WndProc(Message);
end;

// PDFium library

function Loaded: Boolean;
begin
  Result := PDFiumLibrary <> 0;
end;

procedure UnloadLibrary;
begin
  if Loaded then
  begin
    if Assigned(FPDF_DestroyLibrary) then
      FPDF_DestroyLibrary;
    FreeLibrary(PDFiumLibrary);
    PDFiumLibrary := 0;
  end;
end;

procedure CheckLoadLibrary(const Name: string);
begin
  PDFiumLibrary := Windows.LoadLibrary(PChar(Name));
  Check(PDFiumLibrary <> 0, SysErrorMessage(GetLastError) + ': ' + Name);
end;

function CheckGetProcAddress(const Name: string): Pointer;
var ErrorMessage: string;
begin
  Result := GetProcAddress(PDFiumLibrary, PChar(Name));
  if Result = nil then
  begin
    ErrorMessage := SysErrorMessage(GetLastError) + ': ' + Name;
    UnloadLibrary;
    raise EPdfError.Create(ErrorMessage);
  end;
end;

procedure LoadLibrary;
begin
  if not Loaded then
  begin
{$ifdef TRIAL}
  MessageBox({$ifdef FPC} 0 {$else} Application.Handle {$endif FPC},
    'A trial version of PDFium Component Suite started.' + #13#13 +
    'Please note that trial version is supposed to be used for evaluation only. ' +
    'If you wish to distribute PDFium Component Suite as part of your ' +
    'application, you must register from website at https://www.winsoft.sk.' + #13#13 +
    'Thank you for trialing PDFium Component Suite.',
    'PDFium Component Suite, Copyright (c) 2014-2019 WINSOFT', MB_OK or MB_ICONINFORMATION);
{$endif TRIAL}

    CheckLoadLibrary(LibraryName);

    FPDF_InitLibrary := CheckGetProcAddress('FPDF_InitLibrary');
    FPDF_InitLibraryWithConfig := CheckGetProcAddress('FPDF_InitLibraryWithConfig');
    FPDF_DestroyLibrary := CheckGetProcAddress('FPDF_DestroyLibrary');
    FPDF_SetSandBoxPolicy := CheckGetProcAddress('FPDF_SetSandBoxPolicy');
    FPDF_LoadDocument := CheckGetProcAddress('FPDF_LoadDocument');
    FPDF_LoadMemDocument := CheckGetProcAddress('FPDF_LoadMemDocument');
    FPDF_LoadCustomDocument := CheckGetProcAddress('FPDF_LoadCustomDocument');
    FPDF_GetFileVersion := CheckGetProcAddress('FPDF_GetFileVersion');
    FPDF_GetLastError := CheckGetProcAddress('FPDF_GetLastError');
    FPDF_DocumentHasValidCrossReferenceTable := CheckGetProcAddress('FPDF_DocumentHasValidCrossReferenceTable');
    FPDF_GetDocPermissions := CheckGetProcAddress('FPDF_GetDocPermissions');
    FPDF_GetSecurityHandlerRevision := CheckGetProcAddress('FPDF_GetSecurityHandlerRevision');
    FPDF_GetPageCount := CheckGetProcAddress('FPDF_GetPageCount');
    FPDF_LoadPage := CheckGetProcAddress('FPDF_LoadPage');
    FPDF_GetPageWidth := CheckGetProcAddress('FPDF_GetPageWidth');
    FPDF_GetPageHeight := CheckGetProcAddress('FPDF_GetPageHeight');
    FPDF_GetPageBoundingBox := CheckGetProcAddress('FPDF_GetPageBoundingBox');
    FPDF_GetPageSizeByIndex := CheckGetProcAddress('FPDF_GetPageSizeByIndex');
    FPDF_RenderPage := CheckGetProcAddress('FPDF_RenderPage');
    FPDF_RenderPageBitmap := CheckGetProcAddress('FPDF_RenderPageBitmap');
    FPDF_RenderPageBitmapWithMatrix := CheckGetProcAddress('FPDF_RenderPageBitmapWithMatrix');
    FPDF_ClosePage := CheckGetProcAddress('FPDF_ClosePage');
    FPDF_CloseDocument := CheckGetProcAddress('FPDF_CloseDocument');
    FPDF_DeviceToPage := CheckGetProcAddress('FPDF_DeviceToPage');
    FPDF_PageToDevice := CheckGetProcAddress('FPDF_PageToDevice');
    FPDFBitmap_Create := CheckGetProcAddress('FPDFBitmap_Create');
    FPDFBitmap_CreateEx := CheckGetProcAddress('FPDFBitmap_CreateEx');
    FPDFBitmap_GetFormat := CheckGetProcAddress('FPDFBitmap_GetFormat');
    FPDFBitmap_FillRect := CheckGetProcAddress('FPDFBitmap_FillRect');
    FPDFBitmap_GetBuffer := CheckGetProcAddress('FPDFBitmap_GetBuffer');
    FPDFBitmap_GetWidth := CheckGetProcAddress('FPDFBitmap_GetWidth');
    FPDFBitmap_GetHeight := CheckGetProcAddress('FPDFBitmap_GetHeight');
    FPDFBitmap_GetStride := CheckGetProcAddress('FPDFBitmap_GetStride');
    FPDFBitmap_Destroy := CheckGetProcAddress('FPDFBitmap_Destroy');
    FPDF_VIEWERREF_GetPrintScaling := CheckGetProcAddress('FPDF_VIEWERREF_GetPrintScaling');
    FPDF_VIEWERREF_GetNumCopies := CheckGetProcAddress('FPDF_VIEWERREF_GetNumCopies');
    FPDF_VIEWERREF_GetPrintPageRange := CheckGetProcAddress('FPDF_VIEWERREF_GetPrintPageRange');
    FPDF_VIEWERREF_GetPrintPageRangeCount := CheckGetProcAddress('FPDF_VIEWERREF_GetPrintPageRangeCount');
    FPDF_VIEWERREF_GetPrintPageRangeElement := CheckGetProcAddress('FPDF_VIEWERREF_GetPrintPageRangeElement');
    FPDF_VIEWERREF_GetDuplex := CheckGetProcAddress('FPDF_VIEWERREF_GetDuplex');
    FPDF_VIEWERREF_GetName := CheckGetProcAddress('FPDF_VIEWERREF_GetName');
    FPDF_CountNamedDests := CheckGetProcAddress('FPDF_CountNamedDests');
    FPDF_GetNamedDestByName := CheckGetProcAddress('FPDF_GetNamedDestByName');
    FPDF_GetNamedDest := CheckGetProcAddress('FPDF_GetNamedDest');

    FPDFText_LoadPage := CheckGetProcAddress('FPDFText_LoadPage');
    FPDFText_ClosePage := CheckGetProcAddress('FPDFText_ClosePage');
    FPDFText_CountChars := CheckGetProcAddress('FPDFText_CountChars');
    FPDFText_GetUnicode := CheckGetProcAddress('FPDFText_GetUnicode');
    FPDFText_GetCharcode := CheckGetProcAddress('FPDFText_GetCharcode');
    FPDFText_GetFontSize := CheckGetProcAddress('FPDFText_GetFontSize');
    FPDFText_GetFontInfo := CheckGetProcAddress('FPDFText_GetFontInfo');
    FPDFText_GetCharAngle := CheckGetProcAddress('FPDFText_GetCharAngle');
    FPDFText_GetCharBox := CheckGetProcAddress('FPDFText_GetCharBox');
    FPDFText_GetCharOrigin := CheckGetProcAddress('FPDFText_GetCharOrigin');
    FPDFText_GetCharIndexAtPos := CheckGetProcAddress('FPDFText_GetCharIndexAtPos');
    FPDFText_GetText := CheckGetProcAddress('FPDFText_GetText');
    FPDFText_CountRects := CheckGetProcAddress('FPDFText_CountRects');
    FPDFText_GetRect := CheckGetProcAddress('FPDFText_GetRect');
    FPDFText_GetBoundedText := CheckGetProcAddress('FPDFText_GetBoundedText');
    FPDFText_FindStart := CheckGetProcAddress('FPDFText_FindStart');
    FPDFText_FindNext := CheckGetProcAddress('FPDFText_FindNext');
    FPDFText_FindPrev := CheckGetProcAddress('FPDFText_FindPrev');
    FPDFText_GetSchResultIndex := CheckGetProcAddress('FPDFText_GetSchResultIndex');
    FPDFText_GetSchCount := CheckGetProcAddress('FPDFText_GetSchCount');
    FPDFText_FindClose := CheckGetProcAddress('FPDFText_FindClose');
    FPDFLink_LoadWebLinks := CheckGetProcAddress('FPDFLink_LoadWebLinks');
    FPDFLink_CountWebLinks := CheckGetProcAddress('FPDFLink_CountWebLinks');
    FPDFLink_GetURL := CheckGetProcAddress('FPDFLink_GetURL');
    FPDFLink_CountRects := CheckGetProcAddress('FPDFLink_CountRects');
    FPDFLink_GetRect := CheckGetProcAddress('FPDFLink_GetRect');
    FPDFLink_GetTextRange := CheckGetProcAddress('FPDFLink_GetTextRange');
    FPDFLink_CloseWebLinks := CheckGetProcAddress('FPDFLink_CloseWebLinks');

    FPDF_ImportPages := CheckGetProcAddress('FPDF_ImportPages');
    FPDF_ImportNPagesToOne := CheckGetProcAddress('FPDF_ImportNPagesToOne');
    FPDF_CopyViewerPreferences := CheckGetProcAddress('FPDF_CopyViewerPreferences');

    FPDF_GetDefaultTTFMap := CheckGetProcAddress('FPDF_GetDefaultTTFMap');
    FPDF_AddInstalledFont := CheckGetProcAddress('FPDF_AddInstalledFont');
    FPDF_SetSystemFontInfo := CheckGetProcAddress('FPDF_SetSystemFontInfo');
    FPDF_GetDefaultSystemFontInfo := CheckGetProcAddress('FPDF_GetDefaultSystemFontInfo');
    FPDF_FreeDefaultSystemFontInfo := CheckGetProcAddress('FPDF_FreeDefaultSystemFontInfo');

    FPDF_SaveAsCopy := CheckGetProcAddress('FPDF_SaveAsCopy');
    FPDF_SaveWithVersion := CheckGetProcAddress('FPDF_SaveWithVersion');

    FPDFBookmark_GetFirstChild := CheckGetProcAddress('FPDFBookmark_GetFirstChild');
    FPDFBookmark_GetNextSibling := CheckGetProcAddress('FPDFBookmark_GetNextSibling');
    FPDFBookmark_GetTitle := CheckGetProcAddress('FPDFBookmark_GetTitle');
    FPDFBookmark_Find := CheckGetProcAddress('FPDFBookmark_Find');
    FPDFBookmark_GetDest := CheckGetProcAddress('FPDFBookmark_GetDest');
    FPDFBookmark_GetAction := CheckGetProcAddress('FPDFBookmark_GetAction');
    FPDFAction_GetType := CheckGetProcAddress('FPDFAction_GetType');
    FPDFAction_GetDest := CheckGetProcAddress('FPDFAction_GetDest');
    FPDFAction_GetFilePath := CheckGetProcAddress('FPDFAction_GetFilePath');
    FPDFAction_GetURIPath := CheckGetProcAddress('FPDFAction_GetURIPath');
    FPDFDest_GetDestPageIndex := CheckGetProcAddress('FPDFDest_GetDestPageIndex');
    FPDFDest_GetView := CheckGetProcAddress('FPDFDest_GetView');
    FPDFDest_GetLocationInPage := CheckGetProcAddress('FPDFDest_GetLocationInPage');
    FPDFLink_GetLinkAtPoint := CheckGetProcAddress('FPDFLink_GetLinkAtPoint');
    FPDFLink_GetLinkZOrderAtPoint := CheckGetProcAddress('FPDFLink_GetLinkZOrderAtPoint');
    FPDFLink_GetDest := CheckGetProcAddress('FPDFLink_GetDest');
    FPDFLink_GetAction := CheckGetProcAddress('FPDFLink_GetAction');
    FPDFLink_Enumerate := CheckGetProcAddress('FPDFLink_Enumerate');
    FPDFLink_GetAnnotRect := CheckGetProcAddress('FPDFLink_GetAnnotRect');
    FPDFLink_CountQuadPoints := CheckGetProcAddress('FPDFLink_CountQuadPoints');
    FPDFLink_GetQuadPoints := CheckGetProcAddress('FPDFLink_GetQuadPoints');
    FPDF_GetMetaText := CheckGetProcAddress('FPDF_GetMetaText');
    FPDF_GetPageLabel := CheckGetProcAddress('FPDF_GetPageLabel');

    FPDFAvail_Create := CheckGetProcAddress('FPDFAvail_Create');
    FPDFAvail_Destroy := CheckGetProcAddress('FPDFAvail_Destroy');
    FPDFAvail_IsDocAvail := CheckGetProcAddress('FPDFAvail_IsDocAvail');
    FPDFAvail_GetDocument := CheckGetProcAddress('FPDFAvail_GetDocument');
    FPDFAvail_GetFirstPageNum := CheckGetProcAddress('FPDFAvail_GetFirstPageNum');
    FPDFAvail_IsPageAvail := CheckGetProcAddress('FPDFAvail_IsPageAvail');
    FPDFAvail_IsFormAvail := CheckGetProcAddress('FPDFAvail_IsFormAvail');
    FPDFAvail_IsLinearized := CheckGetProcAddress('FPDFAvail_IsLinearized');

    FPDF_RenderPageBitmap_Start := CheckGetProcAddress('FPDF_RenderPageBitmap_Start');
    FPDF_RenderPage_Continue := CheckGetProcAddress('FPDF_RenderPage_Continue');
    FPDF_RenderPage_Close := CheckGetProcAddress('FPDF_RenderPage_Close');

    FPDFPage_SetMediaBox := CheckGetProcAddress('FPDFPage_SetMediaBox');
    FPDFPage_SetCropBox := CheckGetProcAddress('FPDFPage_SetCropBox');
    FPDFPage_SetBleedBox := CheckGetProcAddress('FPDFPage_SetBleedBox');
    FPDFPage_SetTrimBox := CheckGetProcAddress('FPDFPage_SetTrimBox');
    FPDFPage_SetArtBox := CheckGetProcAddress('FPDFPage_SetArtBox');
    FPDFPage_GetMediaBox := CheckGetProcAddress('FPDFPage_GetMediaBox');
    FPDFPage_GetCropBox := CheckGetProcAddress('FPDFPage_GetCropBox');
    FPDFPage_GetBleedBox := CheckGetProcAddress('FPDFPage_GetBleedBox');
    FPDFPage_GetTrimBox := CheckGetProcAddress('FPDFPage_GetTrimBox');
    FPDFPage_GetArtBox := CheckGetProcAddress('FPDFPage_GetArtBox');
    FPDFPage_TransFormWithClip := CheckGetProcAddress('FPDFPage_TransFormWithClip');
    FPDFPageObj_TransformClipPath := CheckGetProcAddress('FPDFPageObj_TransformClipPath');
    FPDFPageObj_GetClipPath := CheckGetProcAddress('FPDFPageObj_GetClipPath');
    FPDFClipPath_CountPaths := CheckGetProcAddress('FPDFClipPath_CountPaths');
    FPDFClipPath_CountPathSegments := CheckGetProcAddress('FPDFClipPath_CountPathSegments');
    FPDFClipPath_GetPathSegment := CheckGetProcAddress('FPDFClipPath_GetPathSegment');
    FPDF_CreateClipPath := CheckGetProcAddress('FPDF_CreateClipPath');
    FPDF_DestroyClipPath := CheckGetProcAddress('FPDF_DestroyClipPath');
    FPDFPage_InsertClipPath := CheckGetProcAddress('FPDFPage_InsertClipPath');

    FSDK_SetUnSpObjProcessHandler := CheckGetProcAddress('FSDK_SetUnSpObjProcessHandler');
    FSDK_SetTimeFunction := CheckGetProcAddress('FSDK_SetTimeFunction');
    FSDK_SetLocaltimeFunction := CheckGetProcAddress('FSDK_SetLocaltimeFunction');
    FPDFDoc_GetPageMode := CheckGetProcAddress('FPDFDoc_GetPageMode');

    FPDF_CreateNewDocument := CheckGetProcAddress('FPDF_CreateNewDocument');
    FPDFPage_New := CheckGetProcAddress('FPDFPage_New');
    FPDFPage_Delete := CheckGetProcAddress('FPDFPage_Delete');
    FPDFPage_GetRotation := CheckGetProcAddress('FPDFPage_GetRotation');
    FPDFPage_SetRotation := CheckGetProcAddress('FPDFPage_SetRotation');
    FPDFPage_InsertObject := CheckGetProcAddress('FPDFPage_InsertObject');
    FPDFPage_RemoveObject := CheckGetProcAddress('FPDFPage_RemoveObject');
    FPDFPage_CountObjects := CheckGetProcAddress('FPDFPage_CountObjects');
    FPDFPage_GetObject := CheckGetProcAddress('FPDFPage_GetObject');
    FPDFPage_HasTransparency := CheckGetProcAddress('FPDFPage_HasTransparency');
    FPDFPage_GenerateContent := CheckGetProcAddress('FPDFPage_GenerateContent');
    FPDFPageObj_Destroy := CheckGetProcAddress('FPDFPageObj_Destroy');
    FPDFPageObj_HasTransparency := CheckGetProcAddress('FPDFPageObj_HasTransparency');
    FPDFPageObj_GetType := CheckGetProcAddress('FPDFPageObj_GetType');
    FPDFPageObj_Transform := CheckGetProcAddress('FPDFPageObj_Transform');
    FPDFPage_TransformAnnots := CheckGetProcAddress('FPDFPage_TransformAnnots');
    FPDFPageObj_NewImageObj := CheckGetProcAddress('FPDFPageObj_NewImageObj');
    FPDFPageObj_CountMarks := CheckGetProcAddress('FPDFPageObj_CountMarks');
    FPDFPageObj_GetMark := CheckGetProcAddress('FPDFPageObj_GetMark');
    FPDFPageObj_AddMark := CheckGetProcAddress('FPDFPageObj_AddMark');
    FPDFPageObj_RemoveMark := CheckGetProcAddress('FPDFPageObj_RemoveMark');
    FPDFPageObjMark_GetName := CheckGetProcAddress('FPDFPageObjMark_GetName');
    FPDFPageObjMark_CountParams := CheckGetProcAddress('FPDFPageObjMark_CountParams');
    FPDFPageObjMark_GetParamKey := CheckGetProcAddress('FPDFPageObjMark_GetParamKey');
    FPDFPageObjMark_GetParamValueType := CheckGetProcAddress('FPDFPageObjMark_GetParamValueType');
    FPDFPageObjMark_GetParamIntValue := CheckGetProcAddress('FPDFPageObjMark_GetParamIntValue');
    FPDFPageObjMark_GetParamStringValue := CheckGetProcAddress('FPDFPageObjMark_GetParamStringValue');
    FPDFPageObjMark_GetParamBlobValue := CheckGetProcAddress('FPDFPageObjMark_GetParamBlobValue');
    FPDFPageObjMark_SetIntParam := CheckGetProcAddress('FPDFPageObjMark_SetIntParam');
    FPDFPageObjMark_SetStringParam := CheckGetProcAddress('FPDFPageObjMark_SetStringParam');
    FPDFPageObjMark_SetBlobParam := CheckGetProcAddress('FPDFPageObjMark_SetBlobParam');
    FPDFPageObjMark_RemoveParam := CheckGetProcAddress('FPDFPageObjMark_RemoveParam');
    FPDFImageObj_LoadJpegFile := CheckGetProcAddress('FPDFImageObj_LoadJpegFile');
    FPDFImageObj_LoadJpegFileInline := CheckGetProcAddress('FPDFImageObj_LoadJpegFileInline');
    FPDFImageObj_GetMatrix := CheckGetProcAddress('FPDFImageObj_GetMatrix');
    FPDFImageObj_SetMatrix := CheckGetProcAddress('FPDFImageObj_SetMatrix');
    FPDFImageObj_SetBitmap := CheckGetProcAddress('FPDFImageObj_SetBitmap');
    FPDFImageObj_GetBitmap := CheckGetProcAddress('FPDFImageObj_GetBitmap');
    FPDFImageObj_GetImageDataDecoded := CheckGetProcAddress('FPDFImageObj_GetImageDataDecoded');
    FPDFImageObj_GetImageDataRaw := CheckGetProcAddress('FPDFImageObj_GetImageDataRaw');
    FPDFImageObj_GetImageFilterCount := CheckGetProcAddress('FPDFImageObj_GetImageFilterCount');
    FPDFImageObj_GetImageFilter := CheckGetProcAddress('FPDFImageObj_GetImageFilter');
    FPDFImageObj_GetImageMetadata := CheckGetProcAddress('FPDFImageObj_GetImageMetadata');
    FPDFPageObj_CreateNewPath := CheckGetProcAddress('FPDFPageObj_CreateNewPath');
    FPDFPageObj_CreateNewRect := CheckGetProcAddress('FPDFPageObj_CreateNewRect');
    FPDFPageObj_GetBounds := CheckGetProcAddress('FPDFPageObj_GetBounds');
    FPDFPageObj_SetBlendMode := CheckGetProcAddress('FPDFPageObj_SetBlendMode');
    FPDFPageObj_SetStrokeColor := CheckGetProcAddress('FPDFPageObj_SetStrokeColor');
    FPDFPageObj_GetStrokeColor := CheckGetProcAddress('FPDFPageObj_GetStrokeColor');
    FPDFPageObj_SetStrokeWidth := CheckGetProcAddress('FPDFPageObj_SetStrokeWidth');
    FPDFPageObj_GetStrokeWidth := CheckGetProcAddress('FPDFPageObj_GetStrokeWidth');
    FPDFPageObj_GetLineJoin := CheckGetProcAddress('FPDFPageObj_GetLineJoin');
    FPDFPageObj_SetLineJoin := CheckGetProcAddress('FPDFPageObj_SetLineJoin');
    FPDFPageObj_GetLineCap := CheckGetProcAddress('FPDFPageObj_GetLineCap');
    FPDFPageObj_SetLineCap := CheckGetProcAddress('FPDFPageObj_SetLineCap');
    FPDFPageObj_SetFillColor := CheckGetProcAddress('FPDFPageObj_SetFillColor');
    FPDFPageObj_GetFillColor := CheckGetProcAddress('FPDFPageObj_GetFillColor');
    FPDFPath_CountSegments := CheckGetProcAddress('FPDFPath_CountSegments');
    FPDFPath_GetPathSegment := CheckGetProcAddress('FPDFPath_GetPathSegment');
    FPDFPathSegment_GetPoint := CheckGetProcAddress('FPDFPathSegment_GetPoint');
    FPDFPathSegment_GetType := CheckGetProcAddress('FPDFPathSegment_GetType');
    FPDFPathSegment_GetClose := CheckGetProcAddress('FPDFPathSegment_GetClose');
    FPDFPath_MoveTo := CheckGetProcAddress('FPDFPath_MoveTo');
    FPDFPath_LineTo := CheckGetProcAddress('FPDFPath_LineTo');
    FPDFPath_BezierTo := CheckGetProcAddress('FPDFPath_BezierTo');
    FPDFPath_Close := CheckGetProcAddress('FPDFPath_Close');
    FPDFPath_SetDrawMode := CheckGetProcAddress('FPDFPath_SetDrawMode');
    FPDFPath_GetDrawMode := CheckGetProcAddress('FPDFPath_GetDrawMode');
    FPDFPath_GetMatrix := CheckGetProcAddress('FPDFPath_GetMatrix');
    FPDFPath_SetMatrix := CheckGetProcAddress('FPDFPath_SetMatrix');
    FPDFPageObj_NewTextObj := CheckGetProcAddress('FPDFPageObj_NewTextObj');
    FPDFText_SetText := CheckGetProcAddress('FPDFText_SetText');
    FPDFText_LoadFont := CheckGetProcAddress('FPDFText_LoadFont');
    FPDFText_LoadStandardFont := CheckGetProcAddress('FPDFText_LoadStandardFont');
    FPDFText_GetMatrix := CheckGetProcAddress('FPDFText_GetMatrix');
    FPDFTextObj_GetFontSize := CheckGetProcAddress('FPDFTextObj_GetFontSize');
    FPDFFont_Close := CheckGetProcAddress('FPDFFont_Close');
    FPDFPageObj_CreateTextObj := CheckGetProcAddress('FPDFPageObj_CreateTextObj');
    FPDFText_GetTextRenderMode := CheckGetProcAddress('FPDFText_GetTextRenderMode');
    FPDFTextObj_GetFontName := CheckGetProcAddress('FPDFTextObj_GetFontName');
    FPDFTextObj_GetText := CheckGetProcAddress('FPDFTextObj_GetText');
    FPDFFormObj_CountObjects := CheckGetProcAddress('FPDFFormObj_CountObjects');
    FPDFFormObj_GetObject := CheckGetProcAddress('FPDFFormObj_GetObject');
    FPDFFormObj_GetMatrix := CheckGetProcAddress('FPDFFormObj_GetMatrix');
//    FPDFPageObj_GetObjectType := CheckGetProcAddress('FPDFPageObj_GetObjectType');
    FPDFPageObj_GetImage := CheckGetProcAddress('FPDFPageObj_GetImage');
    FPDFPageObj_GetDIB := CheckGetProcAddress('FPDFPageObj_GetDIB');
//    FPDFPageObj_GetBoundingBox := CheckGetProcAddress('FPDFPageObj_GetBoundingBox');

    FPDFDOC_InitFormFillEnvironment := CheckGetProcAddress('FPDFDOC_InitFormFillEnvironment');
    FPDFDOC_ExitFormFillEnvironment := CheckGetProcAddress('FPDFDOC_ExitFormFillEnvironment');
    FORM_OnAfterLoadPage := CheckGetProcAddress('FORM_OnAfterLoadPage');
    FORM_OnBeforeClosePage := CheckGetProcAddress('FORM_OnBeforeClosePage');
    FORM_DoDocumentJSAction := CheckGetProcAddress('FORM_DoDocumentJSAction');
    FORM_DoDocumentOpenAction := CheckGetProcAddress('FORM_DoDocumentOpenAction');
    FORM_DoDocumentAAction := CheckGetProcAddress('FORM_DoDocumentAAction');
    FORM_DoPageAAction := CheckGetProcAddress('FORM_DoPageAAction');
    FORM_OnMouseMove := CheckGetProcAddress('FORM_OnMouseMove');
    FORM_OnFocus := CheckGetProcAddress('FORM_OnFocus');
    FORM_OnLButtonDown := CheckGetProcAddress('FORM_OnLButtonDown');
    FORM_OnLButtonUp := CheckGetProcAddress('FORM_OnLButtonUp');
    FORM_OnLButtonDoubleClick := CheckGetProcAddress('FORM_OnLButtonDoubleClick');
    FORM_OnKeyDown := CheckGetProcAddress('FORM_OnKeyDown');
    FORM_OnKeyUp := CheckGetProcAddress('FORM_OnKeyUp');
    FORM_OnChar := CheckGetProcAddress('FORM_OnChar');
    FORM_GetFocusedText := CheckGetProcAddress('FORM_GetFocusedText');
    FORM_GetSelectedText := CheckGetProcAddress('FORM_GetSelectedText');
    FORM_ReplaceSelection := CheckGetProcAddress('FORM_ReplaceSelection');
    FORM_CanUndo := CheckGetProcAddress('FORM_CanUndo');
    FORM_CanRedo := CheckGetProcAddress('FORM_CanRedo');
    FORM_Undo := CheckGetProcAddress('FORM_Undo');
    FORM_Redo := CheckGetProcAddress('FORM_Redo');
    FORM_ForceToKillFocus := CheckGetProcAddress('FORM_ForceToKillFocus');
    FPDFPage_HasFormFieldAtPoint := CheckGetProcAddress('FPDFPage_HasFormFieldAtPoint');
    FPDFPage_FormFieldZOrderAtPoint := CheckGetProcAddress('FPDFPage_FormFieldZOrderAtPoint');
    FPDF_SetFormFieldHighlightColor := CheckGetProcAddress('FPDF_SetFormFieldHighlightColor');
    FPDF_SetFormFieldHighlightAlpha := CheckGetProcAddress('FPDF_SetFormFieldHighlightAlpha');
    FPDF_RemoveFormFieldHighlight := CheckGetProcAddress('FPDF_RemoveFormFieldHighlight');
    FPDF_FFLDraw := CheckGetProcAddress('FPDF_FFLDraw');
    FPDF_GetFormType := CheckGetProcAddress('FPDF_GetFormType');
    FORM_SetIndexSelected := CheckGetProcAddress('FORM_SetIndexSelected');
    FORM_IsIndexSelected := CheckGetProcAddress('FORM_IsIndexSelected');
    FPDF_LoadXFA := GetProcAddress(PDFiumLibrary, 'FPDF_LoadXFA'); // available in XFA DLL only

    FPDFText_GetCharIndexFromTextIndex := CheckGetProcAddress('FPDFText_GetCharIndexFromTextIndex');
    FPDFText_GetTextIndexFromCharIndex := CheckGetProcAddress('FPDFText_GetTextIndexFromCharIndex');

    FPDFPage_Flatten := CheckGetProcAddress('FPDFPage_Flatten');

    FPDF_StructTree_GetForPage := CheckGetProcAddress('FPDF_StructTree_GetForPage');
    FPDF_StructTree_Close := CheckGetProcAddress('FPDF_StructTree_Close');
    FPDF_StructTree_CountChildren := CheckGetProcAddress('FPDF_StructTree_CountChildren');
    FPDF_StructTree_GetChildAtIndex := CheckGetProcAddress('FPDF_StructTree_GetChildAtIndex');
    FPDF_StructElement_GetAltText := CheckGetProcAddress('FPDF_StructElement_GetAltText');
    FPDF_StructElement_GetMarkedContentID := CheckGetProcAddress('FPDF_StructElement_GetMarkedContentID');
    FPDF_StructElement_GetType := CheckGetProcAddress('FPDF_StructElement_GetType');
    FPDF_StructElement_GetTitle := CheckGetProcAddress('FPDF_StructElement_GetTitle');
    FPDF_StructElement_CountChildren := CheckGetProcAddress('FPDF_StructElement_CountChildren');
    FPDF_StructElement_GetChildAtIndex := CheckGetProcAddress('FPDF_StructElement_GetChildAtIndex');

    FPDFAnnot_IsSupportedSubtype := CheckGetProcAddress('FPDFAnnot_IsSupportedSubtype');
    FPDFPage_CreateAnnot := CheckGetProcAddress('FPDFPage_CreateAnnot');
    FPDFPage_GetAnnotCount := CheckGetProcAddress('FPDFPage_GetAnnotCount');
    FPDFPage_GetAnnot := CheckGetProcAddress('FPDFPage_GetAnnot');
    FPDFPage_GetAnnotIndex := CheckGetProcAddress('FPDFPage_GetAnnotIndex');
    FPDFPage_CloseAnnot := CheckGetProcAddress('FPDFPage_CloseAnnot');
    FPDFPage_RemoveAnnot := CheckGetProcAddress('FPDFPage_RemoveAnnot');
    FPDFAnnot_GetSubtype := CheckGetProcAddress('FPDFAnnot_GetSubtype');
    FPDFAnnot_IsObjectSupportedSubtype := CheckGetProcAddress('FPDFAnnot_IsObjectSupportedSubtype');
    FPDFAnnot_UpdateObject := CheckGetProcAddress('FPDFAnnot_UpdateObject');
    FPDFAnnot_AppendObject := CheckGetProcAddress('FPDFAnnot_AppendObject');
    FPDFAnnot_GetObjectCount := CheckGetProcAddress('FPDFAnnot_GetObjectCount');
    FPDFAnnot_GetObject := CheckGetProcAddress('FPDFAnnot_GetObject');
    FPDFAnnot_RemoveObject := CheckGetProcAddress('FPDFAnnot_RemoveObject');
    FPDFAnnot_SetColor := CheckGetProcAddress('FPDFAnnot_SetColor');
    FPDFAnnot_GetColor := CheckGetProcAddress('FPDFAnnot_GetColor');
    FPDFAnnot_HasAttachmentPoints := CheckGetProcAddress('FPDFAnnot_HasAttachmentPoints');
    FPDFAnnot_SetAttachmentPoints := CheckGetProcAddress('FPDFAnnot_SetAttachmentPoints');
    FPDFAnnot_AppendAttachmentPoints := CheckGetProcAddress('FPDFAnnot_AppendAttachmentPoints');
    FPDFAnnot_CountAttachmentPoints := CheckGetProcAddress('FPDFAnnot_CountAttachmentPoints');
    FPDFAnnot_GetAttachmentPoints := CheckGetProcAddress('FPDFAnnot_GetAttachmentPoints');
    FPDFAnnot_SetRect := CheckGetProcAddress('FPDFAnnot_SetRect');
    FPDFAnnot_GetRect := CheckGetProcAddress('FPDFAnnot_GetRect');
    FPDFAnnot_HasKey := CheckGetProcAddress('FPDFAnnot_HasKey');
    FPDFAnnot_GetValueType := CheckGetProcAddress('FPDFAnnot_GetValueType');
    FPDFAnnot_SetStringValue := CheckGetProcAddress('FPDFAnnot_SetStringValue');
    FPDFAnnot_GetStringValue := CheckGetProcAddress('FPDFAnnot_GetStringValue');
    FPDFAnnot_GetNumberValue := CheckGetProcAddress('FPDFAnnot_GetNumberValue');
    FPDFAnnot_SetAP := CheckGetProcAddress('FPDFAnnot_SetAP');
    FPDFAnnot_GetAP := CheckGetProcAddress('FPDFAnnot_GetAP');
    FPDFAnnot_GetLinkedAnnot := CheckGetProcAddress('FPDFAnnot_GetLinkedAnnot');
    FPDFAnnot_GetFlags := CheckGetProcAddress('FPDFAnnot_GetFlags');
    FPDFAnnot_SetFlags := CheckGetProcAddress('FPDFAnnot_SetFlags');
    FPDFAnnot_GetFormFieldFlags := CheckGetProcAddress('FPDFAnnot_GetFormFieldFlags');
    FPDFAnnot_GetFormFieldAtPoint := CheckGetProcAddress('FPDFAnnot_GetFormFieldAtPoint');
    FPDFAnnot_GetOptionCount := CheckGetProcAddress('FPDFAnnot_GetOptionCount');
    FPDFAnnot_GetOptionLabel := CheckGetProcAddress('FPDFAnnot_GetOptionLabel');
    FPDFAnnot_GetFontSize := CheckGetProcAddress('FPDFAnnot_GetFontSize');
    FPDFAnnot_IsChecked := CheckGetProcAddress('FPDFAnnot_IsChecked');

    FPDFDoc_GetAttachmentCount := CheckGetProcAddress('FPDFDoc_GetAttachmentCount');
    FPDFDoc_AddAttachment := CheckGetProcAddress('FPDFDoc_AddAttachment');
    FPDFDoc_GetAttachment := CheckGetProcAddress('FPDFDoc_GetAttachment');
    FPDFDoc_DeleteAttachment := CheckGetProcAddress('FPDFDoc_DeleteAttachment');
    FPDFAttachment_GetName := CheckGetProcAddress('FPDFAttachment_GetName');
    FPDFAttachment_HasKey := CheckGetProcAddress('FPDFAttachment_HasKey');
    FPDFAttachment_GetValueType := CheckGetProcAddress('FPDFAttachment_GetValueType');
    FPDFAttachment_SetStringValue := CheckGetProcAddress('FPDFAttachment_SetStringValue');
    FPDFAttachment_GetStringValue := CheckGetProcAddress('FPDFAttachment_GetStringValue');
    FPDFAttachment_SetFile := CheckGetProcAddress('FPDFAttachment_SetFile');
    FPDFAttachment_GetFile := CheckGetProcAddress('FPDFAttachment_GetFile');

    FPDFCatalog_IsTagged := CheckGetProcAddress('FPDFCatalog_IsTagged');

    FPDFPage_GetDecodedThumbnailData := CheckGetProcAddress('FPDFPage_GetDecodedThumbnailData');
    FPDFPage_GetRawThumbnailData := CheckGetProcAddress('FPDFPage_GetRawThumbnailData');
    FPDFPage_GetThumbnailAsBitmap := CheckGetProcAddress('FPDFPage_GetThumbnailAsBitmap');

    {$ifdef FPC}
      SetMXCSR(GetMXCSR or $1F80);
    {$endif FPC}

    FPDF_InitLibrary;
  end;
end;

end.