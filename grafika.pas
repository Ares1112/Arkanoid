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
   ruch_x : Integer;
   ruch_y : Integer;
   wektor_x, wektor_y : shortint;
type
   kafelek = record
     pozycja_x : Integer;
     pozycja_y : Integer;
     kolor : LongWord;
   end;
VAR
   kafelki : ARRAY [1..50] of kafelek;

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
  pr2d_Rect( x, y, Ceil(szerokosc/15), Ceil(wysokosc/28), kolor, 255, PR2D_FILL );
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
  ruch_x := pal_x + Ceil(dlugosc_paletki/2);
  ruch_y := wysokosc-Ceil(wysokosc/20) - 10;
  //pierwsze pietro kafelkow
  for i := 1 to 10 do begin
  with kafelki[i] do begin
    pozycja_x :=  Ceil(szerokosc/15)+(Ceil(szerokosc/15) * i)+5*i;
    pozycja_y := Ceil(wysokosc/2);
    kolor := $ff0000;
  end;
  end;
  //drugie pietro kafelkow
  for i := 11 to 19 do begin
  with kafelki[i] do begin
    pozycja_x := Ceil((szerokosc/15)/2)+Ceil(szerokosc/15)+(Ceil(szerokosc/15) * (i-10))+ 5*(i-10);
    pozycja_y := Ceil(wysokosc/2)-10-Ceil(wysokosc/28);
    kolor := $0000ff;
  end;
  end;
  //trzecie
  for i := 20 to 29 do begin
  with kafelki[i] do begin
    pozycja_x :=  Ceil(szerokosc/15)+(Ceil(szerokosc/15) * (i-19))+5*(i-19);
    pozycja_y := Ceil(wysokosc/2)-20-Ceil(wysokosc/28)*2;
    kolor := $00ff00;
  end;
  end;
  //czwarte
  for i := 30 to 38 do begin
  with kafelki[i] do begin
    pozycja_x := Ceil((szerokosc/15)/2)+Ceil(szerokosc/15)+(Ceil(szerokosc/15) * (i-29))+ 5*(i-29);
    pozycja_y := Ceil(wysokosc/2)-30-Ceil(wysokosc/28)*3;
    kolor := $ffff00;
  end;
  end;
  //piąte
  for i := 39 to 48 do begin
  with kafelki[i] do begin
    pozycja_x :=  Ceil(szerokosc/15)+(Ceil(szerokosc/15) * (i-38))+5*(i-38);
    pozycja_y := Ceil(wysokosc/2)-40-Ceil(wysokosc/28)*4;
    kolor := $00ffff;
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
  for i := 1 to 48 do
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
  if (ruch_x <= pal_x+dlugosc_paletki) and (ruch_x >= pal_x) and (ruch_y = wysokosc-Ceil(wysokosc/20)-5) then wektor_y := wektor_y*(-1);
  //gdy pilka w ruchu
  if rusz = 1 then begin
    ruch_x := ruch_x + wektor_x;
    ruch_y := ruch_y + wektor_y;
  end
  //gdy pilka przylepiona do paletki
  else begin
    ruch_x := pal_x+Ceil(dlugosc_paletki/2);
  end;
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
