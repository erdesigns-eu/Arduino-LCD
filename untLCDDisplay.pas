unit untLCDDisplay;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, untLCDCharacters;

type
  TLCDDisplay = class(TCustomControl)
  private
    { Private declarations }

    { Buffer - Avoid flickering }
    FBuffer     : TBitmap;
    FUpdateRect : TRect;
    FRedraw     : Boolean;

    // Columns and Rows - 20*4 or 16*2
    FColumns    : Integer;
    FRows       : Integer;

    // Horizontal and Vertical pixels 5*8 or 5*7
    FHorPixels  : Integer;
    FVertPixels : Integer;

    // Size of the pixels
    FPixelSize  : Integer;

    // Pixel colors
    FOffColor   : TColor;
    FOnColor    : TColor;

    // Characters and Character pixel Rects
    FCharacters: TLCDDisplayCharacters;
    FPixelRects: TLCDDisplayRects;

    procedure SetColumns(const I: Integer);
    procedure SetRows(const I: Integer);
    procedure SetHorPixels(const I: Integer);
    procedure SetVertPixels(const I: Integer);
    procedure SetPixelSize(const I: Integer);
    procedure SetOffColor(const C: TColor);
    procedure SetOnColor(const C: TColor);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    { Protected declarations }
    procedure ForceRedraw;
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ClearAll;
    procedure ClearCharacter(const Row: Integer; const Col: Integer);
    procedure ClearRow(const Row: Integer);
    procedure LoadCharacter(const C: TLCDDisplayCharArray; const Row: Integer; const Col: Integer); overload;
    procedure LoadCharacter(const C: TLCDCharacterArray; const Row: Integer; const Col: Integer); overload;
    procedure LoadText(const Text: string; const Row: Integer; const Col: Integer); overload;
    procedure LoadText(const Text: TLCDCharacterArrayArray; const Row: Integer; const Col: Integer); overload;

    property RedrawDisplay: Boolean read FRedraw write FRedraw;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;

    property Characters: TLCDDisplayCharacters read FCharacters write FCharacters;
    property PixelRects: TLCDDisplayRects read FPixelRects write FPixelRects;
  published
    { Published declarations }
    property Columns: Integer read FColumns write SetColumns default 16;
    property Rows: Integer read FRows write SetRows default 2;

    property HorizontalPixels: Integer read FHorPixels write SetHorPixels default 5;
    property VerticalPixels: Integer read FVertPixels write SetVertPixels default 8;

    property PixelSize: Integer read FPixelSize write SetPixelSize default 3;

    property LCDOnColor: TColor read FOnColor write SetOnColor default clWhite;
    property LCDOffColor: TColor read FOffColor write SetOffColor default $00DE800C;

    property Align;
    property Anchors;
    property Color default $00F39621;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

procedure Register;

implementation

(******************************************************************************)
(*
(*  LCD Display (TLCDDisplay)
(*
(******************************************************************************)
constructor TLCDDisplay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We dont want the control to accept controls. offcourse we
    like to get click, double click and mouse events. }
  ControlStyle := ControlStyle + [csOpaque{, csAcceptsControls},
    csCaptureMouse, csClickEvents, csDoubleClicks];

  { We do want to be able to get focus }
  TabStop := True;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;

  { Width / Height }
  Width  := 385;
  Height := 97;
  Color  := $00F39621;

  { Defaults }
  FColumns    := 16;
  FRows       := 2;
  FHorPixels  := 5;
  FVertPixels := 8;
  FPixelSize  := 3;
  FOnColor    := clWhite;
  FOffColor   := $00DE800C;

  { Initial Draw }
  RedrawDisplay := True;
end;

destructor TLCDDisplay.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  inherited Destroy;
end;

procedure TLCDDisplay.SetColumns(const I: Integer);
begin
  if FColumns <> I then
  begin
    FColumns := I;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetRows(const I: Integer);
begin
  if FRows <> I then
  begin
    FRows := I;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetHorPixels(const I: Integer);
begin
  if FHorPixels <> I then
  begin
    FHorPixels := I;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetVertPixels(const I: Integer);
begin
  if FVertPixels <> I then
  begin
    FVertPixels := I;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetPixelSize(const I: Integer);
begin
  if FPixelSize <> I then
  begin
    FPixelSize := I;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetOffColor(const C: TColor);
begin
  if FOffColor <> C then
  begin
    FOffColor := C;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.SetOnColor(const C: TColor);
begin
  if FOnColor <> C then
  begin
    FOnColor := C;
    ForceRedraw;
  end;
end;

procedure TLCDDisplay.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TLCDDisplay.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TLCDDisplay.ClearAll;
begin
  SetLength(FCharacters, 0, 0, VerticalPixels, HorizontalPixels);
  SetLength(FCharacters, Rows, Columns, VerticalPixels, HorizontalPixels);
  ForceRedraw;
end;

procedure TLCDDisplay.ClearCharacter(const Row: Integer; const Col: Integer);
begin
  LoadCharacter(CharToLCDChar(' '), Row, Col);
  ForceRedraw;
end;

procedure TLCDDisplay.ClearRow(const Row: Integer);
var
  I : Integer;
begin
  for I := 0 to Columns -1 do
  LoadCharacter(CharToLCDChar(' '), Row, I);
  ForceRedraw;
end;

procedure TLCDDisplay.LoadCharacter(const C: TLCDDisplayCharArray; const Row: Integer; const Col: Integer);
var
  CR, CC : Integer;
begin
  for CR := 0 to FHorPixels -1 do
  for CC := 0 to FVertPixels -1 do
  FCharacters[Row][Col][CR][CC] := C[CR][CC];
  ForceRedraw;
end;

procedure TLCDDisplay.LoadCharacter(const C: TLCDCharacterArray; const Row: Integer; const Col: Integer);
var
  CR, CC : Integer;
begin
  for CR := 0 to 7 do
  for CC := 0 to 4 do
  FCharacters[Row][Col][CR][CC] := C[CR][CC];
  ForceRedraw;
end;

procedure TLCDDisplay.LoadText(const Text: string; const Row: Integer; const Col: Integer);

  procedure LoadChar(const C: TLCDCharacterArray; const Column: Integer);
  var
    CR, CC : Integer;
  begin
    for CR := 0 to 7 do
    for CC := 0 to 4 do
    FCharacters[Row][Column][CR][CC] := C[CR][CC];
  end;

var
  I, C : Integer;
begin
  C := Col;
  for I := 1 to Length(Text) do
  if C < Columns then
  begin
    LoadChar(CharToLCDChar(Text[I]), C);
    Inc(C);
  end;
  ForceRedraw;
end;

procedure TLCDDisplay.LoadText(const Text: TLCDCharacterArrayArray; const Row: Integer; const Col: Integer);

  procedure LoadChar(const C: TLCDCharacterArray; const Column: Integer);
  var
    CR, CC : Integer;
  begin
    for CR := 0 to 7 do
    for CC := 0 to 4 do
    FCharacters[Row][Column][CR][CC] := C[CR][CC];
  end;

var
  I, C : Integer;
begin
  C := Col;
  for I := 0 to Length(Text) -1 do
  if C < Columns then
  begin
    LoadChar(Text[I], C);
    Inc(C);
  end;
  ForceRedraw;
end;

procedure TLCDDisplay.ForceRedraw;
begin
  RedrawDisplay := True;
  Invalidate;
end;

procedure TLCDDisplay.Paint;
var
  WorkRect  : TRect;
  RowHeight : Integer;
  CoLWidth  : Integer;

  AbsoluteLeft   : Integer;
  AbsoluteTop    : Integer;
  AbsoluteWidth  : Integer;
  AbsoluteHeight : Integer;

  procedure DrawBackground;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Color := Color;
      FillRect(ClipRect);
    end;
  end;

  procedure CalculatePixelsForCharacter(const Row: Integer; const Col: Integer);
  var
    RowTop, ColumnLeft  : Integer;
    PixelRow, PixelCol  : Integer;
    X, Y                : Integer;
  begin
    RowTop       := AbsoluteTop + (RowHeight * Row) + (FPixelSize * Row);
    ColumnLeft   := AbsoluteLeft + (ColWidth * Col) + (FPixelSize * Col);
    for PixelRow := 0 to FVertPixels -1 do
    for PixelCol := 0 to FHorPixels -1 do
    begin
      Y := RowTop + (PixelRow * FPixelSize) + (PixelRow -1);
      X := ColumnLeft + (PixelCol * FPixelSize) + (PixelCol -1);
      FPixelRects[Row][Col][PixelRow][PixelCol] := Rect(X, Y, X + FPixelSize, Y + FPixelSize);
    end;
  end;

  procedure CalculatePixels;
  var
    Row, Col : Integer;
  begin
    SetLength(FPixelRects, Rows, Columns, VerticalPixels, HorizontalPixels);
    SetLength(FCharacters, Rows, Columns, VerticalPixels, HorizontalPixels);
    for Row := 0 to Rows -1 do
    for Col := 0 to Columns -1 do
    CalculatePixelsForCharacter(Row, Col);
  end;

  procedure DrawPixels;
  var
    Row, Col, CharRow, CharCol: Integer;
  begin
    with FBuffer.Canvas do
    begin
      for Row := 0 to Rows -1 do
      for Col := 0 to Columns -1 do
      for CharRow := 0 to VerticalPixels -1 do
      for CharCol := 0 to HorizontalPixels -1 do
      begin
        if Characters[Row][Col][CharRow][CharCol] then
          Brush.Color := LCDOnColor
        else
          Brush.Color := LCDOffColor;
        FillRect(PixelRects[Row][Col][CharRow][CharCol]);
      end;
    end;
  end;

var
  X, Y, W, H : Integer;
begin
  if RedrawDisplay then
  begin
    RedrawDisplay := False;

    { Create toggle clientrect }
    WorkRect := ClientRect;

    { Calculate Absolute position and width/height of the displayed characters / pixels }
    RowHeight := (FPixelSize * FVertPixels) + (FVertPixels -1);
    ColWidth  := (FPixelSize * FHorPixels) + (FHorPixels -1);

    AbsoluteWidth  := (ColWidth * Columns) + (FPixelSize * (Columns -1));
    AbsoluteHeight := (RowHeight * Rows) + (FPixelSize * (Rows -1));

    AbsoluteLeft   := WorkRect.Left + ((WorkRect.Width div 2) - (AbsoluteWidth div 2));
    AbsoluteTop    := WorkRect.Top + ((WorkRect.Height div 2) - (AbsoluteHeight div 2));

    { Set Buffer size }
    FBuffer.SetSize(ClientWidth, ClientHeight);

    { Calculate Rect for the characters pixels }
    CalculatePixels;

    { Background }
    DrawBackground;

    { Draw Pixels }
    DrawPixels;
  end;

  { Draw Character Pixels }
  {for R := 0 to 7 do
  for C := 0 to 4 do
  DrawCharacter(R, C, FCharacters[R][C]);}

  { Now draw the Buffer to the components surface }
  X := UpdateRect.Left;
  Y := UpdateRect.Top;
  W := UpdateRect.Right - UpdateRect.Left;
  H := UpdateRect.Bottom - UpdateRect.Top;
  if (W <> 0) and (H <> 0) then
    { Only update part - invalidated }
    BitBlt(Canvas.Handle, X, Y, W, H, FBuffer.Canvas.Handle, X,  Y, SRCCOPY)
  else
    { Repaint the whole buffer to the surface }
    BitBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, X,  Y, SRCCOPY);

  inherited;
end;

procedure TLCDDisplay.Resize;
begin
  RedrawDisplay := True;
  Invalidate;
  inherited;
end;

procedure TLCDDisplay.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TLCDDisplay.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED: ForceRedraw;

    { Focus is lost }
    WM_KILLFOCUS: ForceRedraw;

    { Focus is set }
    WM_SETFOCUS: ForceRedraw;

    { The color changed }
    CM_COLORCHANGED: ForceRedraw;

    { Font changed }
    CM_FONTCHANGED: ForceRedraw;

  end;
end;

procedure Register;
begin
  RegisterComponents('ERDesigns Arduino', [TLCDDisplay]);
end;

end.
