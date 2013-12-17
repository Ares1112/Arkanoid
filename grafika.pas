unit grafika;
interface
procedure rysuj_paletke();

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
  zgl_fx,
  zgl_render_2d,
  zgl_primitives_2d,
  zgl_math_2d,
  zgl_utils;
var
   roz_x,roz_y,dlugosc_paletki,pal_x,i : Integer;
   DirApp  : UTF8String;
   DirHome : UTF8String;

procedure rysuj_pilke(i : Integer);

  begin
    pr2d_Circle( 400+i, 300+i, 20, $000000, 155, 32, PR2D_FILL );
  end;

procedure rysuj_paletke();

  begin
    pal_x := pal_x + zmiana;
    Repeat
     Begin

     end;
  Until (keypressed);
  end;

procedure Init;
begin

end;

procedure Draw;
begin
  pr2d_Rect( 0, 0, 800, 600, $FFFFFF, 255, PR2D_FILL );
  rysuj_pilke(1);
end;

procedure Update( dt : Double );
begin

end;

procedure Timer;
begin
  if key_Press( K_ESCAPE ) Then zgl_Exit();

  key_ClearState();
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

  zgl_Reg( SYS_LOAD, @Init );
  zgl_Reg( SYS_DRAW, @Draw );
  zgl_Reg( SYS_UPDATE, @Update );
  zgl_Reg( SYS_EXIT, @Quit );

  wnd_SetCaption( 'Arkanoid' );

  scr_SetOptions( 800, 600, REFRESH_MAXIMUM, FALSE, FALSE );

  zgl_Init();
End.
