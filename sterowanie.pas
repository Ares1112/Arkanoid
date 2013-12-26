unit sterowanie;

interface
procedure steruj_paletka();
var
  zmiana : Integer;
  rusz : shortint;
  szybkosc_paletki : Integer = 5;
implementation

uses
  wincrt,
  sysutils,
  grafika,
  zgl_main,
  zgl_screen,
  zgl_window,
  zgl_timers,
  zgl_keyboard,
  zgl_render_2d,
  zgl_fx,
  zgl_primitives_2d,
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils;

procedure steruj_paletka();
begin
  if (key_Press(K_RIGHT)) and (pal_x < szerokosc-dlugosc_paletki) then pal_x := pal_x + szybkosc_paletki
  else if (key_Press(K_LEFT)) and (pal_x >= 0) then pal_x := pal_x - szybkosc_paletki;
  if key_Press( K_SPACE) then rusz := 1;
  if key_Press( K_ESCAPE ) Then zgl_Exit();
  key_ClearState();
end;
begin
end.

