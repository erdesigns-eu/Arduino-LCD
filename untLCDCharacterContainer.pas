unit untLCDCharacterContainer;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, untLCDCharacters;

type
  TCharacterChangeEvent = procedure(Sender: TObject; Row: Integer; Col: Integer; State: Boolean) of object;

  TLCDCharacterContainer = class(TCustomControl)
  private
    { Private declarations }
    FOnCharacterChange: TCharacterChangeEvent;

    { Buffer - Avoid flickering }
    FBuffer      : TBitmap;
    FUpdateRect  : TRect;
    FRedraw      : Boolean;

    FLCDONColor  : TColor;
    FLCDOFFColor : TColor;

    FCharSize    : Integer;
    FCharacters  : TLCDCharacterArray;
    FCharRects   : TLCDCharacterRectArray;

    FMouseDown   : Boolean;
    FMouseRow    : Integer;
    FMouseCol    : Integer;

    procedure SetLCDONColor(const C: TColor);
    procedure SetLCDOFFColor(const C: TColor);
    procedure SetCharSize(const I: Integer);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    function MouseInCell(const X: Integer; const Y : Integer; var Row: Integer; var Col: Integer) : Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InvertSelection;
    procedure Clear;
    procedure LoadCharacter(const C: TLCDCharacterArray);

    property RedrawContainer: Boolean read FRedraw write FRedraw;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
    property Characters: TLCDCharacterArray read FCharacters write FCharacters;
  published
    { Published declarations }
    property OnCharacterChange: TCharacterChangeEvent read FOnCharacterChange write FOnCharacterChange;

    property LCDOnColor: TColor read FLCDONColor write SetLCDONColor default clWhite;
    property LCDOffColor: TColor read FLCDOffColor write SetLCDOffColor default $00DE800C;

    property CharacterSize: Integer read FCharSize write SetCharSize default 20;

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
(*  LCD Character Container (TLCDCharacterContainer)
(*
(******************************************************************************)
constructor TLCDCharacterContainer.Create(AOwner: TComponent);
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
  Width  := 150;
  Height := 200;
  Color  := $00F39621;

  { Defaults }
  FLCDOnColor  := clWhite;
  FLCDOffColor := $00DE800C;
  FCharSize    := 20;

  { Initial Draw }
  RedrawContainer := True;

  if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, -1, -1, False);
end;

destructor TLCDCharacterContainer.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  inherited Destroy;
end;

procedure TLCDCharacterContainer.InvertSelection;
var
  R, C : Integer;
begin
  for R := 0 to 7 do
  for C := 0 to 4 do
  FCharacters[R][C] := not FCharacters[R][C];
  if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, -1, -1, False);
  Invalidate;
end;

procedure TLCDCharacterContainer.Clear;
var
  R, C : Integer;
begin
  for R := 0 to 7 do
  for C := 0 to 4 do
  FCharacters[R][C] := False;
  if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, -1, -1, False);
  Invalidate;
end;

procedure TLCDCharacterContainer.LoadCharacter(const C: TLCDCharacterArray);
var
  Row, Col : Integer;
begin
  for Row := 0 to 7 do
  for Col := 0 to 4 do
  FCharacters[Row][Col] := C[Row][Col];
  if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, -1, -1, False);
  Invalidate;
end;

procedure TLCDCharacterContainer.SetLCDONColor(const C: TColor);
begin
  if FLCDONColor <> C then
  begin
    FLCDOnColor := C;
    RedrawContainer := True;
    Invalidate;
  end;
end;

procedure TLCDCharacterContainer.SetLCDOFFColor(const C: TColor);
begin
  if FLCDOffColor <> C then
  begin
    FLCDOffColor := C;
    RedrawContainer := True;
    Invalidate;
  end;
end;

procedure TLCDCharacterContainer.SetCharSize(const I: Integer);
begin
  if FCharSize <> I then
  begin
    FCharSize := I;
    RedrawContainer := True;
    Invalidate;
  end;
end;

procedure TLCDCharacterContainer.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TLCDCharacterContainer.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TLCDCharacterContainer.Paint;
var
  WorkRect : TRect;

  procedure DrawBackground;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Color := Color;
      FillRect(ClipRect);
    end;
  end;

  procedure CalculateCharacters;
  var
    Space: Integer;
    R, C : Integer;
    X, Y : Integer;
    T, L : Integer;
  begin
    Space := CharacterSize div 4;
    T := (WorkRect.Height - ((8 * CharacterSize) + (7 * Space))) div 2;
    L := (WorkRect.Width - ((5 * CharacterSize) + (4 * Space))) div 2;
    for R := 0 to 7 do
    for C := 0 to 4 do
    begin
      X := L + (C * CharacterSize) + (C * Space);
      Y := T + (R * CharacterSize) + (R * Space);
      FCharRects[R][C] := Rect(X, Y, X + CharacterSize, Y + CharacterSize);
    end;
  end;

  procedure DrawCharacter(const Row: Integer; const Col: Integer; const State: Boolean);
  begin
    with FBuffer.Canvas do
    begin
      if State then
      begin
        Brush.Color := FLCDOnColor;
      end else
      begin
        Brush.Color := FLCDOffColor;
      end;
      FillRect(FCharRects[Row][Col]);
    end;
  end;

var
  X, Y, W, H : Integer;
  R, C       : Integer;
begin
  if RedrawContainer then
  begin
    RedrawContainer := False;

    {  Create toggle clientrect }
    WorkRect := ClientRect;

    { Set Buffer size }
    FBuffer.SetSize(ClientWidth, ClientHeight);

    { Calculate Rect for the characters pixels }
    CalculateCharacters;

    { Background }
    DrawBackground;
  end;

  { Draw Character Pixels }
  for R := 0 to 7 do
  for C := 0 to 4 do
  DrawCharacter(R, C, FCharacters[R][C]);

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

procedure TLCDCharacterContainer.Resize;
begin
  RedrawContainer := True;
  Invalidate;
  inherited;
end;

procedure TLCDCharacterContainer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TLCDCharacterContainer.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED:
      begin
        RedrawContainer := True;
        Invalidate;
      end;

    { Focus is lost }
    WM_KILLFOCUS:
      begin
        RedrawContainer := True;
        Invalidate;
      end;

    { Focus is set }
    WM_SETFOCUS:
      begin
        RedrawContainer := True;
        Invalidate;
      end;

    { The color changed }
    CM_COLORCHANGED:
      begin
        RedrawContainer := True;
        Invalidate;
      end;

    { Font changed }
    CM_FONTCHANGED:
      begin
        RedrawContainer := True;
        Invalidate;
      end;

  end;
end;

function TLCDCharacterContainer.MouseInCell(const X: Integer; const Y : Integer;
  var Row: Integer; var Col: Integer) : Boolean;
var
  R, C : Integer;
begin
  Result := False;
  for R := 0 to 7 do
  for C := 0 to 4 do
  if PTInRect(FCharRects[R][C], Point(X, Y)) then
  begin
    Result := True;
    Row := R;
    Col := C;
    Break;
  end;
end;

procedure TLCDCharacterContainer.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  Row, Col : Integer;
begin
  if not Enabled then Exit;
  FMouseDown := True;
  if MouseInCell(X, Y, Row, Col) then
  begin
    FCharacters[Row][Col] := not FCharacters[Row][Col];
    if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, Row, Col, FCharacters[Row][Col]);
    FMouseRow := Row;
    FMouseCol := Col;
    Invalidate;
  end;
  if (not Focused) and CanFocus then SetFocus;
  inherited;
end;

procedure TLCDCharacterContainer.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  Row, Col : Integer;
begin
  if not Enabled then Exit;
  if MouseInCell(X, Y, Row, Col) and FMouseDown then
  begin
    if (Row <> FMouseRow) or (Col <> FMouseCol) then
    begin
      FMouseRow := Row;
      FMouseCol := Col;
      FCharacters[Row][Col] := True;
      if Assigned(FOnCharacterChange) then FOnCharacterChange(Self, Row, Col, FCharacters[Row][Col]);
      Invalidate;
    end;
  end;
  inherited;
end;

procedure TLCDCharacterContainer.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  FMouseDown := False;
  inherited;
end;

procedure Register;
begin
  RegisterComponents('ERDesigns Arduino', [TLCDCharacterContainer]);
end;

end.
