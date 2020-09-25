unit untLCDCharacters;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types;

type
  TLCDCharacterArray       = array [0..7] of array [0..4] of Boolean;
  TLCDCharacterRectArray   = array [0..7] of array [0..4] of TRect;
  TLCDCharacterArrayArray  = array of TLCDCharacterArray;

  TLCDDisplayCharArray     = array of array of Boolean;
  TLCDDisplayCharRectArray = array of array of TRect;

  TLCDDisplayCharRow       = array of TLCDDisplayCharArray;
  TLCDDisplayCharRowRects  = array of TLCDDisplayCharRectArray;

  TLCDDisplayCharacters    = array of TLCDDisplayCharRow;
  TLCDDisplayRects         = array of TLCDDisplayCharRowRects;

const
  LCD_Lowercase: array ['a'..'z'] of TLCDCharacterArray = (

    // A
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,false,false,true,false),
      (false,true,true,true,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // B
    (
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,true,true,false,false),
      (false,false,false,false,false)
    ),

    // C
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,false,false),
      (true,false,false,true,false),
      (false,true,true,false,false),
      (false,false,false,false,false)
    ),

    // D
    (
      (false,false,false,true,false),
      (false,false,false,true,false),
      (false,false,false,true,false),
      (false,true,true,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // E
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (true,false,false,true,false),
      (true,true,true,true,false),
      (true,false,false,false,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // F
    (
      (false,false,true,true,false),
      (false,true,false,false,true),
      (false,true,false,false,false),
      (true,true,true,true,false),
      (false,true,false,false,false),
      (false,true,false,false,false),
      (false,true,false,false,false),
      (false,false,false,false,false)
    ),

    // G
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,true,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,true,false),
      (true,true,true,false,false),
      (false,false,false,false,false)
    ),

    // H
    (
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,false,false,false,false)
    ),

    // I
    (
      (false,false,false,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // J
    (
      (false,false,false,true,false),
      (false,false,false,false,false),
      (false,true,true,true,false),
      (false,false,false,true,false),
      (false,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,false,false),
      (false,false,false,false,false)
    ),

    // K
    (
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,true,false),
      (true,false,true,false,false),
      (true,true,false,false,false),
      (true,false,true,false,false),
      (true,false,false,true,false),
      (false,false,false,false,false)
    ),

    // L
    (
      (false,true,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // M
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,true,false,true,false),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (false,false,false,false,false)
    ),

    // N
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,false,false,false,false)
    ),

    // O
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,false,false),
      (false,false,false,false,false)
    ),

    // P
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,true,true,false,false),
      (true,false,false,true,false),
      (true,true,true,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (false,false,false,false,false)
    ),

    // Q
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,true,false),
      (false,false,false,true,false),
      (false,false,false,false,false)
    ),

    // R
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,true,true,false),
      (true,true,false,false,true),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (false,false,false,false,false)
    ),

    // S
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (true,false,false,false,false),
      (false,true,true,false,false),
      (false,false,false,true,false),
      (true,true,true,false,false),
      (false,false,false,false,false)
    ),

    // T
    (
      (false,true,false,false,false),
      (false,true,false,false,false),
      (true,true,true,true,false),
      (false,true,false,false,false),
      (false,true,false,false,false),
      (false,true,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // U
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // V
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,false,true,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // W
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (false,true,false,true,false),
      (false,false,false,false,false)
    ),

    // X
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,false,false,false,false)
    ),

    // Y
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,false,false,true,false),
      (true,false,false,true,false),
      (false,true,true,true,false),
      (false,false,false,true,false),
      (true,true,true,false,false),
      (false,false,false,false,false)
    ),

    // Z
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,true,true,true,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    )
  );

  LCD_Uppercase: array ['A'..'Z'] of TLCDCharacterArray = (

    // A
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // B
    (
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,false),
      (false,false,false,false,false)
    ),

    // C
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // D
    (
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,false),
      (false,false,false,false,false)
    ),

    // E
    (
      (true,true,true,true,true),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,true,true,true,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    ),

    // F
    (
      (true,true,true,true,true),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,true,true,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (false,false,false,false,false)
    ),

    // G
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,false),
      (true,false,false,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // H
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // I
    (
      (true,true,true,true,true),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    ),

    // J
    (
      (true,true,true,true,true),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // K
    (
      (true,false,false,false,true),
      (true,false,false,true,false),
      (true,false,true,false,false),
      (true,true,false,false,false),
      (true,false,true,false,false),
      (true,false,false,true,false),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // L
    (
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,true),
      (true,true,true,true,true),
      (false,false,false,false,false)
    ),

    // M
    (
      (true,false,false,false,true),
      (true,true,false,true,true),
      (true,false,true,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // N
    (
      (true,false,false,false,true),
      (true,true,false,false,true),
      (true,true,false,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (true,false,false,true,true),
      (true,false,false,true,true),
      (false,false,false,false,false)
    ),

    // O
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // P
    (
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (true,false,false,false,false),
      (false,false,false,false,false)
    ),

    // Q
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,true,false,true),
      (true,false,false,true,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // R
    (
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,true,true,true,false),
      (true,false,true,false,false),
      (true,false,false,true,false),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // S
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,false),
      (false,true,true,true,false),
      (false,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // T
    (
      (true,true,true,true,true),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // U
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // V
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,false,true,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // W
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (true,true,false,true,true),
      (false,false,false,false,false)
    ),

    // X
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,false,true,false),
      (false,false,true,false,false),
      (false,true,false,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,false,false)
    ),

    // Y
    (
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,false,true,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // Z
    (
      (true,true,true,true,true),
      (false,false,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (true,false,false,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    )
  );

  LCD_Decimal: array ['0'..'9'] of TLCDCharacterArray = (

    // 0
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // 1
    (
      (false,false,false,false,true),
      (false,false,false,true,true),
      (false,false,true,false,true),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (false,false,false,false,false)
    ),

    // 2
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    ),

    // 3
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (false,false,false,false,true),
      (false,false,true,true,false),
      (false,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // 4
    (
      (false,false,false,true,false),
      (false,false,true,true,false),
      (false,true,false,true,false),
      (true,false,false,true,false),
      (true,true,true,true,true),
      (false,false,false,true,false),
      (false,false,false,true,false),
      (false,false,false,false,false)
    ),

    // 5
    (
      (true,true,true,true,true),
      (true,false,false,false,false),
      (true,true,true,true,false),
      (false,false,false,false,true),
      (false,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // 6
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,false),
      (true,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // 7
    (
      (true,true,true,true,true),
      (false,false,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // 8
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // 9
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,true),
      (false,false,false,false,true),
      (true,false,false,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    )
  );

  LCD_Special_Characters: array [0..18] of TLCDCharacterArray = (

    // $
    (
      (false,false,true,false,false),
      (false,true,true,true,true),
      (true,false,true,false,false),
      (false,true,true,true,false),
      (false,false,true,false,true),
      (true,true,true,true,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // %
    (
      (true,true,false,false,false),
      (true,true,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (true,false,false,true,true),
      (false,false,false,true,true),
      (false,false,false,false,false)
    ),

    // &
    (
      (false,true,true,false,false),
      (true,false,false,true,false),
      (true,false,true,false,false),
      (false,true,false,false,false),
      (true,false,true,false,true),
      (true,false,false,true,false),
      (false,true,true,false,true),
      (false,false,false,false,false)
    ),

    // '
    (
      (false,true,true,false,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // @
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (false,false,false,false,true),
      (false,true,true,false,true),
      (true,false,true,false,true),
      (true,false,true,false,true),
      (false,true,true,true,false),
      (false,false,false,false,false)
    ),

    // \
    (
      (false,false,false,false,false),
      (true,false,false,false,false),
      (false,true,false,false,false),
      (false,false,true,false,false),
      (false,false,false,true,false),
      (false,false,false,false,true),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // /
    (
      (false,false,false,false,false),
      (false,false,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (true,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // ,
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (false,false,false,false,false)
    ),

    // #
    (
      (false,true,false,true,false),
      (false,true,false,true,false),
      (true,true,true,true,true),
      (false,true,false,true,false),
      (true,true,true,true,true),
      (false,true,false,true,false),
      (false,true,false,true,false),
      (false,false,false,false,false)
    ),

    // .
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,true,true,false,false),
      (false,false,false,false,false)
    ),

    // :
    (
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,true,true,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,true,true,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // ;
    (
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,true,true,false,false),
      (false,false,false,false,false),
      (false,true,true,false,false),
      (false,false,true,false,false),
      (false,true,false,false,false),
      (false,false,false,false,false)
    ),

    // !
    (
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // +
    (
      (false,false,false,false,false),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (true,true,true,true,true),
      (false,false,true,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // ?
    (
      (false,true,true,true,false),
      (true,false,false,false,true),
      (true,false,false,false,true),
      (false,false,false,true,false),
      (false,false,true,false,false),
      (false,false,false,false,false),
      (false,false,true,false,false),
      (false,false,false,false,false)
    ),

    // ^
    (
      (false,false,true,false,false),
      (false,true,false,true,false),
      (true,false,false,false,true),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // _
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (true,true,true,true,true),
      (false,false,false,false,false)
    ),

    // °
    (
      (false,true,true,true,false),
      (false,true,false,true,false),
      (false,true,true,true,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    ),

    // -- Space --
    (
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false),
      (false,false,false,false,false)
    )
  );

  function CharToLCDChar(const C: Char) : TLCDCharacterArray;

implementation

function CharToLCDChar(const C: Char) : TLCDCharacterArray;
begin
  if C in ['a'..'z'] then
    Result := LCD_Lowercase[C]
  else
  if C in ['A'..'Z'] then
    Result := LCD_Uppercase[C]
  else
  if C in ['0'..'9'] then
    Result := LCD_Decimal[C]
  else
  case C of
    '$' : Result := LCD_Special_Characters[0];
    '%' : Result := LCD_Special_Characters[1];
    '&' : Result := LCD_Special_Characters[2];
    '''': Result := LCD_Special_Characters[3];
    '@' : Result := LCD_Special_Characters[4];
    '\' : Result := LCD_Special_Characters[5];
    '/' : Result := LCD_Special_Characters[6];
    ',' : Result := LCD_Special_Characters[7];
    '#' : Result := LCD_Special_Characters[8];
    '.' : Result := LCD_Special_Characters[9];
    ':' : Result := LCD_Special_Characters[10];
    ';' : Result := LCD_Special_Characters[11];
    '!' : Result := LCD_Special_Characters[12];
    '+' : Result := LCD_Special_Characters[13];
    '?' : Result := LCD_Special_Characters[14];
    '^' : Result := LCD_Special_Characters[15];
    '_' : Result := LCD_Special_Characters[16];
    '°' : Result := LCD_Special_Characters[17];
    else  Result := LCD_Special_Characters[18];
  end;

end;

end.
