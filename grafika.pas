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
  Classes,
  zgl_main,
  zgl_screen,
  zgl_resources,
  zgl_window,
  zgl_memory,
  zgl_file,
  zgl_timers,
  zgl_keyboard,
  zgl_render_2d,
  zgl_sprite_2d,
  zgl_fx,
  zgl_types,
  zgl_textures,
  zgl_textures_tga,
  zgl_textures_jpg,
  zgl_textures_png,
  zgl_primitives_2d,
  zgl_font,
  zgl_text,
  zgl_math_2d,
  zgl_utils;
var
   ruch_x, ruch_y : double;
   wektor_x, wektor_y : double;
   ilosc_zyc:shortint;
   wynik : Integer;
   memory : zglTMemory;
   texSerce : zglPTexture;
   fntMain  : zglPFont;
type
   kafelek = record
     pozycja_x : Integer;
     pozycja_y : Integer;
     kolor : LongWord;
   end;
VAR
   kafelki : ARRAY [1..50] of kafelek;

procedure rysuj_pilke(x : double; y : double);
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

procedure Init;
VAR
  i : Integer;
  memStream : TMemoryStream;
begin
  ilosc_zyc := 3;
  wynik := 0;
  wektor_x := 1;
  wektor_y := -1;
  pal_x := 100;
  fntMain  := font_LoadFromFile( PAnsiChar( zgl_Get( DIRECTORY_APPLICATION ) ) + 'grafika\font.zfi' ); //czcionka
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
  //ladowanie tekstury serduszek
  memStream := TMemoryStream.Create();
  memStream.LoadFromFile( PAnsiChar( zgl_Get( DIRECTORY_APPLICATION ) ) + 'grafika\serce.png' );
  memory.Position := memStream.Position;
  memory.Memory   := memStream.Memory;
  memory.Size     := memStream.Size;
  texSerce := tex_LoadFromMemory( memory, 'PNG' );
  memStream.Free();
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
  for i := 1 to ilosc_zyc do
  ssprite2d_Draw( texSerce, szerokosc-(32*i), wysokosc-32, 32, 32, 0 );
  text_DrawEx( fntMain, 0, wysokosc-16,1,1,'Wynik: '+ IntToStr(wynik),255, $000000, 0);
end;

procedure Update( dt : Double );
begin

end;

procedure Timer;
begin

end;

procedure Timer_pilka;
  Var i : Integer;
begin
  if (ruch_x >= szerokosc-15) or (ruch_x <= 15) then wektor_x := wektor_x * (-1);
  if (ruch_y <= 15) then wektor_y := wektor_y * (-1);
  if (ruch_y >= wysokosc-15) then begin
    Dec(ilosc_zyc);
    rusz := 0;
  end;
  for i := 1 to 48 do begin
    //sprawdzenie odbicia w kafelek od lewej
    if (ruch_x <= kafelki[i].pozycja_x -1 ) and
    (ruch_x >= kafelki[i].pozycja_x) and
    (ruch_y >= kafelki[i].pozycja_y) and
    (ruch_y <= kafelki[i].pozycja_y + Ceil(wysokosc/28)) then begin
      wektor_x := wektor_x * (-1);
      kafelki[i].pozycja_x := 20000;
      wynik := wynik + 100;
    end
    //sprawdzenie odbicia w kafelek od prawej
    else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc/15) ) and
    (ruch_x >= kafelki[i].pozycja_x + Ceil(szerokosc/15) - 1) and
    (ruch_y >= kafelki[i].pozycja_y) and
    (ruch_y <= kafelki[i].pozycja_y + Ceil(wysokosc/28)) then begin
      wektor_x := wektor_x * (-1);
      kafelki[i].pozycja_x := 20000;
      wynik := wynik + 100;
    end
    //sprawdzenie udrzenia w kafelek od dolu
    else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc/15)) and
    (ruch_x >= kafelki[i].pozycja_x) and
    (ruch_y <= kafelki[i].pozycja_y  + Ceil(wysokosc/28) + 5) and
    (ruch_y >= kafelki[i].pozycja_y) then begin
      wektor_y := wektor_y * (-1);
      kafelki[i].pozycja_x := 20000;
      wynik := wynik + 100;
    end
    //sprawdzenie odbicia w kafelek od gory
    else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc/15)) and
    (ruch_x >= kafelki[i].pozycja_x) and
    (ruch_y <= kafelki[i].pozycja_y) and
    (ruch_y >= kafelki[i].pozycja_y - 1) then begin
      wektor_y := wektor_y * (-1);
      kafelki[i].pozycja_x := 20000;
      wynik := wynik + 100;
    end;
  end;
  if (ruch_x <= pal_x+dlugosc_paletki) and (ruch_x >= pal_x) and (ruch_y >= wysokosc-Ceil(wysokosc/20)-5) then wektor_y := wektor_y*(-1);
  //gdy pilka w ruchu
  if rusz = 1 then begin
    ruch_x := ruch_x + wektor_x;
    ruch_y := ruch_y + wektor_y;
  end
  //gdy pilka przylepiona do paletki
  else begin
    ruch_x := pal_x+Ceil(dlugosc_paletki/2);
    ruch_y := wysokosc-Ceil(wysokosc/20) - 10;
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

  timer_Add( @Timer, 1000 );
  timer_Add( @Timer_pilka, 13);
  timer_Add( @Timer_paletka, 10);

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );
  zgl_Reg( SYS_UPDATE, @Update );
  zgl_Reg( SYS_EXIT, @Quit );

End.
