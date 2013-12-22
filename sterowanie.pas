unit sterowanie;

interface
procedure steruj_paletka();
var zmiana : Integer;
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
  zgl_camera_2d,
  zgl_render_2d,
  zgl_fx,
  zgl_textures,
  zgl_textures_png,
  zgl_textures_jpg,
  zgl_sprite_2d,
  zgl_primitives_2d,
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils;

procedure steruj_paletka();
begin
  if (key_Press(K_RIGHT)) and (pal_x < szerokosc-dlugosc_paletki) then pal_x := pal_x + 3
  else if (key_Press(K_LEFT)) and (pal_x >= 0) then pal_x := pal_x - 3;
  if key_Press( K_ESCAPE ) Then zgl_Exit();
  key_ClearState();
end;
begin
end.

