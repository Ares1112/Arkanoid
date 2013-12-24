unit grafika;

interface

var
  pal_x: integer;
  szerokosc, wysokosc: integer;
  dlugosc_paletki: integer;
  kolor_pilki: String;

implementation

{$I zglCustomConfig.cfg}
//{$R *.res}

uses
  wincrt,
  Math,
  SysUtils,
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
  ruch_x, ruch_y: double;
  wektor_x, wektor_y: double;
  ilosc_zyc: shortint;
  bonus: shortint;
  bonusy: array [1..50, 1..4] of integer;
  wynik: integer;
  szybkosc_pilki: integer = 13;
  memory: zglTMemory;
  texSerce: zglPTexture;
  fntMain: zglPFont;

type
  kafelek = record
    pozycja_x: integer;
    pozycja_y: integer;
    kolor: longword;
  end;

var
  kafelki: array [1..50] of kafelek;

procedure wczytaj_kafelki();
var
  i: integer;
begin
  //pierwsze pietro kafelkow
  for i := 1 to 10 do
  begin
    with kafelki[i] do
    begin
      pozycja_x := Ceil(szerokosc / 15) + (Ceil(szerokosc / 15) * i) + 5 * i;
      pozycja_y := Ceil(wysokosc / 2);
      kolor := $ff0000;
    end;
  end;
  //drugie pietro kafelkow
  for i := 11 to 19 do
  begin
    with kafelki[i] do
    begin
      pozycja_x := Ceil((szerokosc / 15) / 2) + Ceil(szerokosc / 15) +
        (Ceil(szerokosc / 15) * (i - 10)) + 5 * (i - 10);
      pozycja_y := Ceil(wysokosc / 2) - 10 - Ceil(wysokosc / 28);
      kolor := $0000ff;
    end;
  end;
  //trzecie
  for i := 20 to 29 do
  begin
    with kafelki[i] do
    begin
      pozycja_x := Ceil(szerokosc / 15) + (Ceil(szerokosc / 15) * (i - 19)) +
        5 * (i - 19);
      pozycja_y := Ceil(wysokosc / 2) - 20 - Ceil(wysokosc / 28) * 2;
      kolor := $00ff00;
    end;
  end;
  //czwarte
  for i := 30 to 38 do
  begin
    with kafelki[i] do
    begin
      pozycja_x := Ceil((szerokosc / 15) / 2) + Ceil(szerokosc / 15) +
        (Ceil(szerokosc / 15) * (i - 29)) + 5 * (i - 29);
      pozycja_y := Ceil(wysokosc / 2) - 30 - Ceil(wysokosc / 28) * 3;
      kolor := $ffff00;
    end;
  end;
  //piąte
  for i := 39 to 48 do
  begin
    with kafelki[i] do
    begin
      pozycja_x := Ceil(szerokosc / 15) + (Ceil(szerokosc / 15) * (i - 38)) +
        5 * (i - 38);
      pozycja_y := Ceil(wysokosc / 2) - 40 - Ceil(wysokosc / 28) * 4;
      kolor := $00ffff;
    end;
  end;
end;

procedure rysuj_pilke(x: double; y: double);
begin
  pr2d_Circle(x, y, 10, StrToInt64(kolor_pilki), 255, 32, PR2D_FILL);
end;

procedure rysuj_paletke(x: integer);
begin
  pr2d_Rect(x, wysokosc - Ceil(wysokosc / 20), dlugosc_paletki, 15,
    $000000, 255, PR2D_FILL);
end;

procedure rysuj_kafelek(x: integer; y: integer; kolor: longword);
begin
  pr2d_Rect(x, y, Ceil(szerokosc / 15), Ceil(wysokosc / 28), kolor, 255, PR2D_FILL);
end;

procedure rysuj_bonus(jaki: shortint; x: integer; y: integer);
begin
  case jaki of
    {'wieksza'} 1: text_DrawEx(fntMain, x, y, 1, 1, 'W', 255, $00FF00, 0);
    {'szybsza'} 2: text_DrawEx(fntMain, x, y, 1, 1, 'S', 255, $00FF00, 0);
    {'szybsza_pilka'} 3: text_DrawEx(fntMain, x, y, 1, 1, 'SP', 255, $FF0000, 0);
    {'punkty'} 4: text_DrawEx(fntMain, x, y, 1, 1, '100', 255, $0000FF, 0);
    {'zycie'} 5: ssprite2d_Draw(texSerce, x, y, 16, 16, 0);
  end;
end;

procedure losuj_bonus(x: integer; y: integer);
var
  i: integer;
begin
  Randomize;
  i := Random(40) + 1;
  if i <= 5 then
  begin
    Inc(bonus);
    bonusy[bonus][1] := i;
    bonusy[bonus][2] := x;
    bonusy[bonus][3] := y;
  end;

end;

procedure zniszcz_bonus();
var
  i: integer;
begin
  for i := 1 to bonus do
  begin
    if (bonusy[i][2] >= pal_x) and (bonusy[i][2] <= (pal_x + dlugosc_paletki)) and
      (bonusy[i][3] >= (wysokosc - Ceil(wysokosc / 20))) and
      (bonusy[i][3] <= wysokosc - 15) then
    begin
      bonusy[i][2] := 10000;
      bonusy[i][4] := 10;
      case bonusy[i][1] of
        1: dlugosc_paletki := dlugosc_paletki + 30;
        2: szybkosc_paletki := szybkosc_paletki + 2;
        3: szybkosc_pilki := szybkosc_pilki - 2;
        4: wynik := wynik + 100;
        5: Inc(ilosc_zyc);
      end;
    end;
  end;
end;

procedure sprawdz_odbicie_paletki(i: integer);
begin
  //sprawdzenie odbicia w kafelek od lewej
  if (ruch_x <= kafelki[i].pozycja_x - 1) and (ruch_x >= kafelki[i].pozycja_x) and
    (ruch_y >= kafelki[i].pozycja_y) and (ruch_y <= kafelki[i].pozycja_y +
    Ceil(wysokosc / 28)) then
  begin
    wektor_x := wektor_x * (-1);
    kafelki[i].pozycja_x := 20000;
    wynik := wynik + 100;
    losuj_bonus(Ceil(ruch_x), Ceil(ruch_y));
  end
  //sprawdzenie odbicia w kafelek od prawej
  else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc / 15)) and
    (ruch_x >= kafelki[i].pozycja_x + Ceil(szerokosc / 15) - 1) and
    (ruch_y >= kafelki[i].pozycja_y) and (ruch_y <= kafelki[i].pozycja_y +
    Ceil(wysokosc / 28)) then
  begin
    wektor_x := wektor_x * (-1);
    kafelki[i].pozycja_x := 20000;
    wynik := wynik + 100;
    losuj_bonus(Ceil(ruch_x), Ceil(ruch_y));
  end
  //sprawdzenie udrzenia w kafelek od dolu
  else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc / 15)) and
    (ruch_x >= kafelki[i].pozycja_x) and (ruch_y <= kafelki[i].pozycja_y +
    Ceil(wysokosc / 28) + 5) and (ruch_y >= kafelki[i].pozycja_y) then
  begin
    wektor_y := wektor_y * (-1);
    kafelki[i].pozycja_x := 20000;
    wynik := wynik + 100;
    losuj_bonus(Ceil(ruch_x), Ceil(ruch_y));
  end
  //sprawdzenie odbicia w kafelek od gory
  else if (ruch_x <= kafelki[i].pozycja_x + Ceil(szerokosc / 15)) and
    (ruch_x >= kafelki[i].pozycja_x) and (ruch_y <= kafelki[i].pozycja_y) and
    (ruch_y >= kafelki[i].pozycja_y - 1) then
  begin
    wektor_y := wektor_y * (-1);
    kafelki[i].pozycja_x := 20000;
    wynik := wynik + 100;
    losuj_bonus(Ceil(ruch_x), Ceil(ruch_y));
  end;
end;

procedure Init;
var
  i: integer;
  memStream: TMemoryStream;
begin
  ilosc_zyc := 3;
  wynik := 0;
  bonus := 0;
  wektor_x := 1;
  wektor_y := -1;
  pal_x := 100;
  fntMain := font_LoadFromFile(PAnsiChar(zgl_Get(DIRECTORY_APPLICATION)) +
    'grafika\font.zfi'); //czcionka
  dlugosc_paletki := Ceil(szerokosc / 8);
  ruch_x := pal_x + Ceil(dlugosc_paletki / 2);
  ruch_y := wysokosc - Ceil(wysokosc / 20) - 10;
  wczytaj_kafelki();
  //ladowanie tekstury serduszek
  memStream := TMemoryStream.Create();
  memStream.LoadFromFile(PAnsiChar(zgl_Get(DIRECTORY_APPLICATION)) +
    'grafika\serce.png');
  memory.Position := memStream.Position;
  memory.Memory := memStream.Memory;
  memory.Size := memStream.Size;
  texSerce := tex_LoadFromMemory(memory, 'PNG');
  memStream.Free();
end;

procedure Draw;
var
  i: integer;
begin
  pr2d_Rect(0, 0, szerokosc, wysokosc, $FFFFFF, 255, PR2D_FILL);
  if ilosc_zyc >= 1 then
  begin
    rysuj_pilke(ruch_x, ruch_y);
    rysuj_paletke(pal_x);
    for i := 1 to 48 do
      rysuj_kafelek(kafelki[i].pozycja_x, kafelki[i].pozycja_y, kafelki[i].kolor);
    for i := 1 to ilosc_zyc do
      ssprite2d_Draw(texSerce, szerokosc - (32 * i), wysokosc - 32, 32, 32, 0);
    text_DrawEx(fntMain, 0, wysokosc - 16, 1, 1, 'Wynik: ' + IntToStr(wynik),
      255, $000000, 0);
    if bonus > 0 then
    begin
      for i := 1 to bonus do
      begin
        rysuj_bonus(bonusy[i][1], bonusy[i][2], bonusy[i][3]);

      end;
    end;
  end
  else
  begin
    text_DrawEx(fntMain, Ceil(szerokosc / 5), Ceil(wysokosc / 2), 2,
      1, 'Koniec gry, wynik: ' + IntToStr(wynik) + '  Nacisnij ESC aby wyjsc',
      255, $000000, 0);
  end;
end;

procedure Timer_bonus;
var
  i: integer;
begin
  if bonus >= 1 then
  begin
    for i := 1 to bonus do
    begin
      Inc(bonusy[i][3]);
    end;
  end;
end;

procedure Timer_pilka;
var
  i: integer;
begin
  if (ruch_x >= szerokosc - 15) or (ruch_x <= 15) then
    wektor_x := wektor_x * (-1);
  if (ruch_y <= 15) then
    wektor_y := wektor_y * (-1);
  if (ruch_y >= wysokosc - 15) then
  begin
    Dec(ilosc_zyc);
    rusz := 0;
    wektor_x := 1;
    wektor_y := -1;
  end;
  for i := 1 to 48 do
  begin
    sprawdz_odbicie_paletki(i);
  end;
  //udzerzenie pilki od paletki(lewa polowa)
  if (ruch_x <= pal_x + (dlugosc_paletki / 2)) and (ruch_x >= pal_x) and
    (ruch_y >= wysokosc - Ceil(wysokosc / 20) - 5) then
  begin
    wektor_y := -1.5 + ((pal_x + dlugosc_paletki - ruch_x) / dlugosc_paletki);
    wektor_x := -((pal_x + dlugosc_paletki - ruch_x) / dlugosc_paletki);
  end//prawa polowa
  else if (ruch_x <= pal_x + (dlugosc_paletki)) and
    (ruch_x > pal_x + (dlugosc_paletki / 2)) and (ruch_y >= wysokosc -
    Ceil(wysokosc / 20) - 5) then
  begin
    wektor_y := -1 * ((pal_x + dlugosc_paletki - ruch_x) / dlugosc_paletki) - 0.5;
    wektor_x := 1 + -1 * ((pal_x + dlugosc_paletki - ruch_x) / dlugosc_paletki);
  end;
  //gdy pilka w ruchu
  if rusz = 1 then
  begin
    ruch_x := ruch_x + wektor_x;
    ruch_y := ruch_y + wektor_y;
  end
  //gdy pilka przylepiona do paletki
  else
  begin
    ruch_x := pal_x + Ceil(dlugosc_paletki / 2);
    ruch_y := wysokosc - Ceil(wysokosc / 20) - 10;
  end;
  zniszcz_bonus();
end;

procedure Timer_paletka;
begin
  steruj_paletka();
end;

procedure Timer_bonus_skoncz;
var
  i: integer;
begin
  for i := 1 to bonus do
  begin
    if bonusy[i][4] > 1 then
      Dec(bonusy[i][4])
    else if bonusy[i][4] = 1 then
    begin
      case bonusy[i][1] of
        1: dlugosc_paletki := dlugosc_paletki - 30;
        2: szybkosc_paletki := szybkosc_paletki - 2;
        3: szybkosc_pilki := szybkosc_pilki + 2;
      end;
      Dec(bonusy[i][4]);
    end;
  end;
end;

procedure Quit;
begin

end;

begin

  timer_Add(@Timer_bonus, 40);
  timer_Add(@Timer_pilka, szybkosc_pilki);
  timer_Add(@Timer_paletka, 5);
  timer_Add(@Timer_bonus_skoncz, 1000);

  zgl_Reg(SYS_LOAD, @Init);
  zgl_Reg(SYS_DRAW, @Draw);
  zgl_Reg(SYS_EXIT, @Quit);

end.
