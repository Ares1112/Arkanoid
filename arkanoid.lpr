program arkanoid;
{$APPTYPE GUI}
{$I zglCustomConfig.cfg}
uses
  wincrt,
  grafika,
  sterowanie,
  sysutils,
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
var
   DirApp  : UTF8String;
   DirHome : UTF8String;
   fullscreen : Boolean;

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

begin
  {$IFNDEF USE_ZENGL_STATIC}
    if not zglLoad( libZenGL ) Then exit;
  {$ENDIF}

  DirApp  := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_APPLICATION ) ) );
  DirHome := utf8_Copy( PAnsiChar( zgl_Get( DIRECTORY_HOME ) ) );

  wnd_SetCaption('Arkanoid');
  odczyt_ustawien();
  scr_SetOptions( szerokosc, wysokosc, REFRESH_MAXIMUM, fullscreen, FALSE );

  zgl_Init();
end.

