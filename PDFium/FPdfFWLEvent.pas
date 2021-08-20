// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

unit FPdfFWLEvent;

{$WEAKPACKAGEUNIT}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}
{$endif}

interface

uses FPdfView;

type
  FPDF_INT32 = Integer;
  FPDF_UINT32 = LongWord;
  FPDF_FLOAT = Single;

// Event types.
type
  FWL_EVENTTYPE = (FWL_EVENTTYPE_Mouse {$ifdef D6PLUS} = 0 {$endif D6PLUS}, FWL_EVENTTYPE_MouseWheel, FWL_EVENTTYPE_Key);

{$ifdef D6PLUS}

// Key flags.
type
  FWL_EVENTFLAG =
  (
    FWL_EVENTFLAG_ShiftKey         = 1 shl 0,
    FWL_EVENTFLAG_ControlKey       = 1 shl 1,
    FWL_EVENTFLAG_AltKey           = 1 shl 2,
    FWL_EVENTFLAG_MetaKey          = 1 shl 3,
    FWL_EVENTFLAG_KeyPad           = 1 shl 4,
    FWL_EVENTFLAG_AutoRepeat       = 1 shl 5,
    FWL_EVENTFLAG_LeftButtonDown   = 1 shl 6,
    FWL_EVENTFLAG_MiddleButtonDown = 1 shl 7,
    FWL_EVENTFLAG_RightButtonDown  = 1 shl 8
  );

{$else}

// Key flags.
const
  FWL_EVENTFLAG_ShiftKey         = 1 shl 0;
  FWL_EVENTFLAG_ControlKey       = 1 shl 1;
  FWL_EVENTFLAG_AltKey           = 1 shl 2;
  FWL_EVENTFLAG_MetaKey          = 1 shl 3;
  FWL_EVENTFLAG_KeyPad           = 1 shl 4;
  FWL_EVENTFLAG_AutoRepeat       = 1 shl 5;
  FWL_EVENTFLAG_LeftButtonDown   = 1 shl 6;
  FWL_EVENTFLAG_MiddleButtonDown = 1 shl 7;
  FWL_EVENTFLAG_RightButtonDown  = 1 shl 8;

{$endif D6PLUS}

{$ifdef D6PLUS}

// Mouse messages.
type
  FWL_EVENT_MOUSECMD =
  (
    FWL_EVENTMOUSECMD_LButtonDown = 1,
    FWL_EVENTMOUSECMD_LButtonUp,
    FWL_EVENTMOUSECMD_LButtonDblClk,
    FWL_EVENTMOUSECMD_RButtonDown,
    FWL_EVENTMOUSECMD_RButtonUp,
    FWL_EVENTMOUSECMD_RButtonDblClk,
    FWL_EVENTMOUSECMD_MButtonDown,
    FWL_EVENTMOUSECMD_MButtonUp,
    FWL_EVENTMOUSECMD_MButtonDblClk,
    FWL_EVENTMOUSECMD_MouseMove,
    FWL_EVENTMOUSECMD_MouseEnter,
    FWL_EVENTMOUSECMD_MouseHover,
    FWL_EVENTMOUSECMD_MouseLeave
  );

{$endif D6PLUS}

// Mouse events.
type
  FWL_EVENT_MOUSE = record
    command: FPDF_UINT32;
    flag: FPDF_DWORD;
    x: FPDF_FLOAT;
    y: FPDF_FLOAT;
  end;

// Mouse wheel events.
type
  FWL_EVENT_MOUSEWHEEL = record
    flag: FPDF_DWORD;
    x: FPDF_FLOAT;
    y: FPDF_FLOAT;
    deltaX: FPDF_FLOAT;
    deltaY: FPDF_FLOAT;
  end;

{$ifdef D6PLUS}

// Virtual keycodes.
type
  FWL_VKEYCODE =
  (
    FWL_VKEY_Back = $08,
    FWL_VKEY_Tab = $09,
    FWL_VKEY_NewLine = $0A,
    FWL_VKEY_Clear = $0C,
    FWL_VKEY_Return = $0D,
    FWL_VKEY_Shift = $10,
    FWL_VKEY_Control = $11,
    FWL_VKEY_Menu = $12,
    FWL_VKEY_Pause = $13,
    FWL_VKEY_Capital = $14,
    FWL_VKEY_Kana = $15,
    FWL_VKEY_Hangul = $15,
    FWL_VKEY_Junja = $17,
    FWL_VKEY_Final = $18,
    FWL_VKEY_Hanja = $19,
    FWL_VKEY_Kanji = $19,
    FWL_VKEY_Escape = $1B,
    FWL_VKEY_Convert = $1C,
    FWL_VKEY_NonConvert = $1D,
    FWL_VKEY_Accept = $1E,
    FWL_VKEY_ModeChange = $1F,
    FWL_VKEY_Space = $20,
    FWL_VKEY_Prior = $21,
    FWL_VKEY_Next = $22,
    FWL_VKEY_End = $23,
    FWL_VKEY_Home = $24,
    FWL_VKEY_Left = $25,
    FWL_VKEY_Up = $26,
    FWL_VKEY_Right = $27,
    FWL_VKEY_Down = $28,
    FWL_VKEY_Select = $29,
    FWL_VKEY_Print = $2A,
    FWL_VKEY_Execute = $2B,
    FWL_VKEY_Snapshot = $2C,
    FWL_VKEY_Insert = $2D,
    FWL_VKEY_Delete = $2E,
    FWL_VKEY_Help = $2F,
    FWL_VKEY_0 = $30,
    FWL_VKEY_1 = $31,
    FWL_VKEY_2 = $32,
    FWL_VKEY_3 = $33,
    FWL_VKEY_4 = $34,
    FWL_VKEY_5 = $35,
    FWL_VKEY_6 = $36,
    FWL_VKEY_7 = $37,
    FWL_VKEY_8 = $38,
    FWL_VKEY_9 = $39,
    FWL_VKEY_A = $41,
    FWL_VKEY_B = $42,
    FWL_VKEY_C = $43,
    FWL_VKEY_D = $44,
    FWL_VKEY_E = $45,
    FWL_VKEY_F = $46,
    FWL_VKEY_G = $47,
    FWL_VKEY_H = $48,
    FWL_VKEY_I = $49,
    FWL_VKEY_J = $4A,
    FWL_VKEY_K = $4B,
    FWL_VKEY_L = $4C,
    FWL_VKEY_M = $4D,
    FWL_VKEY_N = $4E,
    FWL_VKEY_O = $4F,
    FWL_VKEY_P = $50,
    FWL_VKEY_Q = $51,
    FWL_VKEY_R = $52,
    FWL_VKEY_S = $53,
    FWL_VKEY_T = $54,
    FWL_VKEY_U = $55,
    FWL_VKEY_V = $56,
    FWL_VKEY_W = $57,
    FWL_VKEY_X = $58,
    FWL_VKEY_Y = $59,
    FWL_VKEY_Z = $5A,
    FWL_VKEY_LWin = $5B,
    FWL_VKEY_Command = $5B,
    FWL_VKEY_RWin = $5C,
    FWL_VKEY_Apps = $5D,
    FWL_VKEY_Sleep = $5F,
    FWL_VKEY_NumPad0 = $60,
    FWL_VKEY_NumPad1 = $61,
    FWL_VKEY_NumPad2 = $62,
    FWL_VKEY_NumPad3 = $63,
    FWL_VKEY_NumPad4 = $64,
    FWL_VKEY_NumPad5 = $65,
    FWL_VKEY_NumPad6 = $66,
    FWL_VKEY_NumPad7 = $67,
    FWL_VKEY_NumPad8 = $68,
    FWL_VKEY_NumPad9 = $69,
    FWL_VKEY_Multiply = $6A,
    FWL_VKEY_Add = $6B,
    FWL_VKEY_Separator = $6C,
    FWL_VKEY_Subtract = $6D,
    FWL_VKEY_Decimal = $6E,
    FWL_VKEY_Divide = $6F,
    FWL_VKEY_F1 = $70,
    FWL_VKEY_F2 = $71,
    FWL_VKEY_F3 = $72,
    FWL_VKEY_F4 = $73,
    FWL_VKEY_F5 = $74,
    FWL_VKEY_F6 = $75,
    FWL_VKEY_F7 = $76,
    FWL_VKEY_F8 = $77,
    FWL_VKEY_F9 = $78,
    FWL_VKEY_F10 = $79,
    FWL_VKEY_F11 = $7A,
    FWL_VKEY_F12 = $7B,
    FWL_VKEY_F13 = $7C,
    FWL_VKEY_F14 = $7D,
    FWL_VKEY_F15 = $7E,
    FWL_VKEY_F16 = $7F,
    FWL_VKEY_F17 = $80,
    FWL_VKEY_F18 = $81,
    FWL_VKEY_F19 = $82,
    FWL_VKEY_F20 = $83,
    FWL_VKEY_F21 = $84,
    FWL_VKEY_F22 = $85,
    FWL_VKEY_F23 = $86,
    FWL_VKEY_F24 = $87,
    FWL_VKEY_NunLock = $90,
    FWL_VKEY_Scroll = $91,
    FWL_VKEY_LShift = $A0,
    FWL_VKEY_RShift = $A1,
    FWL_VKEY_LControl = $A2,
    FWL_VKEY_RControl = $A3,
    FWL_VKEY_LMenu = $A4,
    FWL_VKEY_RMenu = $A5,
    FWL_VKEY_BROWSER_Back = $A6,
    FWL_VKEY_BROWSER_Forward = $A7,
    FWL_VKEY_BROWSER_Refresh = $A8,
    FWL_VKEY_BROWSER_Stop = $A9,
    FWL_VKEY_BROWSER_Search = $AA,
    FWL_VKEY_BROWSER_Favorites = $AB,
    FWL_VKEY_BROWSER_Home = $AC,
    FWL_VKEY_VOLUME_Mute = $AD,
    FWL_VKEY_VOLUME_Down = $AE,
    FWL_VKEY_VOLUME_Up = $AF,
    FWL_VKEY_MEDIA_NEXT_Track = $B0,
    FWL_VKEY_MEDIA_PREV_Track = $B1,
    FWL_VKEY_MEDIA_Stop = $B2,
    FWL_VKEY_MEDIA_PLAY_Pause = $B3,
    FWL_VKEY_MEDIA_LAUNCH_Mail = $B4,
    FWL_VKEY_MEDIA_LAUNCH_MEDIA_Select = $B5,
    FWL_VKEY_MEDIA_LAUNCH_APP1 = $B6,
    FWL_VKEY_MEDIA_LAUNCH_APP2 = $B7,
    FWL_VKEY_OEM_1 = $BA,
    FWL_VKEY_OEM_Plus = $BB,
    FWL_VKEY_OEM_Comma = $BC,
    FWL_VKEY_OEM_Minus = $BD,
    FWL_VKEY_OEM_Period = $BE,
    FWL_VKEY_OEM_2 = $BF,
    FWL_VKEY_OEM_3 = $C0,
    FWL_VKEY_OEM_4 = $DB,
    FWL_VKEY_OEM_5 = $DC,
    FWL_VKEY_OEM_6 = $DD,
    FWL_VKEY_OEM_7 = $DE,
    FWL_VKEY_OEM_8 = $DF,
    FWL_VKEY_OEM_102 = $E2,
    FWL_VKEY_ProcessKey = $E5,
    FWL_VKEY_Packet = $E7,
    FWL_VKEY_Attn = $F6,
    FWL_VKEY_Crsel = $F7,
    FWL_VKEY_Exsel = $F8,
    FWL_VKEY_Ereof = $F9,
    FWL_VKEY_Play = $FA,
    FWL_VKEY_Zoom = $FB,
    FWL_VKEY_NoName = $FC,
    FWL_VKEY_PA1 = $FD,
    FWL_VKEY_OEM_Clear = $FE,
    FWL_VKEY_Unknown = 0
  );

// Key event commands.
type
  FWL_EVENTKEYCMD =
  (
    FWL_EVENTKEYCMD_KeyDown = 1,
    FWL_EVENTKEYCMD_KeyUp,
    FWL_EVENTKEYCMD_Char
  );

{$endif D6PLUS}

// Key events.
type
  FWL_EVENT_KEY = record
    command: FPDF_UINT32;
    flag: FPDF_DWORD;
    case {code} Boolean of // union
      False:(vkcode: FPDF_UINT32); // Virtual key code.
      True: (charcode: FPDF_DWORD); // Character code.
  end;

// Event types.
type
  FWL_EVENT = record
    size: FPDF_UINT32; // Structure size.
    type_: FPDF_UINT32; // FWL_EVENTTYPE.
    case {s} Integer of
      0: (mouse: FWL_EVENT_MOUSE);
      1: (wheel: FWL_EVENT_MOUSEWHEEL);
      2: (key: FWL_EVENT_KEY);
  end;

implementation

end.