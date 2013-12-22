unit grafika;
interface
var
  pal_x : integer;
  szerokosc, wysokosc : Integer;
  dlugosc_paletki : Integer;

implementation

{$I zglCustomConfig.cfg}
//{$R *.res}

uses
  wincrt,
  math,
  sysutils,
  sterowanie,
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
var
   DirApp  : UTF8String;
   DirHome : UTF8String;
   fullscreen : Boolean;
   ruch_x : Integer = 100;
   ruch_y : Integer = 100;
   wektor_x, wektor_y : shortint;
type
   kafelek = record
     pozycja_x : Integer;
     pozycja_y : Integer;
     kolor : LongWord;
   end;
VAR
   kafelki : ARRAY [1..20] of kafelek;

procedure rysuj_pilke(x : Integer; y : Integer);
begin
  pr2d_Circle( x, y, 10, $000000, 255, 32, PR2D_FILL);
end;

procedure rysuj_paletke(x : Integer);
begin
  pr2d_Rect( x, wysokosc-Ceil(wysokosc/20), dlugosc_paletki, 15, $000000, 255, PR2D_FILL );
end;

procedure rysuj_kafelek(x : Integer; y: Integer; kolor : LongWord);
Begin
  pr2d_Rect( x, y, Ceil(szerokosc/15), Ceil(wysokosc/25), kolor, 255, PR2D_FILL );
end;

function IntToBool(liczba : shortint) : Boolean;
Begin
  If liczba = 0 then
    IntToBool := False
  else IntToBool := True;
end;

procedure odczyt_ustawien();
VAR
  Plik: TextFile;
  Linia: String;
  Wartownik : shortint = 1;

begin
AssignFile(Plik,DirApp+'pliki\ustawienia.txt');
  {$I-};
  Append(Plik);
  {$I+};
  If IOResult <> 0 Then Rewrite(Plik);
  Reset(Plik);
  Repeat
    Readln(Plik,Linia);
      if Wartownik = 1 then
        szerokosc := StrToInt(Linia)
      else if Wartownik = 2 then
        wysokosc := StrToInt(Linia)
      else if Wartownik = 3 then
        fullscreen := IntToBool(StrToInt(Linia));
    Inc(Wartownik);
  Until (Eof(Plik));
  CloseFile(Plik);
end;

procedure Init;
VAR
  i : Integer;
begin
  wektor_x := 1;
  wektor_y := 1;
  pal_x := 100;
  dlugosc_paletki := Ceil(szerokosc/8);
  //pierwsze pietro kafelkow
  for i := 1 to 10 do begin
  with kafelki[i] do begin
    pozycja_x := Ceil(szerokosc/15) + (60 * i);
    pozycja_y := 100;
    kolor := $ff0000;
  end;
  end;
  //drugie pietro kafelkow
  for i := 11 to 19 do begin
  with kafelki[i] do begin
    pozycja_x := (60 * i) - szerokosc + Ceil(szerokosc/2.8);
    pozycja_y := 150;
    kolor := $0000ff;
  end;
  end;
end;

procedure Draw;
VAR
  i : Integer;
begin
  pr2d_Rect( 0, 0, szerokosc, wysokosc, $FFFFFF, 255, PR2D_FILL );
  rysuj_pilke(ruch_x,ruch_y);
  rysuj_paletke(pal_x);
  for i := 1 to 10 do
    rysuj_kafelek(kafelki[i].pozycja_x,kafelki[i].pozycja_y,kafelki[i].kolor);
  for i := 11 to 20 do
     rysuj_kafelek(kafelki[i].pozycja_x,kafelki[i].pozycja_y,kafelki[i].kolor);
end;

procedure Update( dt : Double );
begin

end;

procedure Timer;
begin

end;

procedure Timer_pilka;
begin
  if (ruch_x = szerokosc-15) or (ruch_x = 15) then wektor_x := wektor_x * (-1);
  if (ruch_y = wysokosc-15) or (ruch_y = 15) then wektor_y := wektor_y * (-1);
  ruch_x := ruch_x + wektor_x;
  ruch_y := ruch_y + wektor_y;
end;

procedure Timer_paletka;
begin
  steruj_paletka();
end;

procedure Quit;
begin

end;

Begin

  {$IFNDEF USE_ZENGL_STATIC}
    if not zglLoad( libZenGL ) Then exit;
  {$ENDIF}

  DirApp  := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_APPLICATION ) ) );
  DirHome := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_HOME ) ) );

  timer_Add( @Timer, 1000 );
  timer_Add( @Timer_pilka, 14);
  timer_Add( @Timer_paletka, 10);

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );
  zgl_Reg( SYS_UPDATE, @Update );
  zgl_Reg( SYS_EXIT, @Quit );

  wnd_SetCaption('Arkanoid');
  odczyt_ustawien();
  scr_SetOptions( szerokosc, wysokosc, REFRESH_MAXIMUM, fullscreen, FALSE );

  zgl_Init();
End.
