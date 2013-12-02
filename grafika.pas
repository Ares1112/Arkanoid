unit grafika;
interface
procedure rysuj_plansze();
procedure rysuj_paletke();

implementation
uses
  wincrt, graph, math, sysutils, sterowanie;
var
   roz_x,roz_y,dlugosc_paletki,pal_x,i : Integer;

procedure rysuj_plansze();

var
   sterownik,tryb_graficzny : smallint;

begin
   sterownik:=detect;
   tryb_graficzny:=m640x350;
   InitGraph(sterownik,tryb_graficzny,'');
   SetBkColor(white);
   cleardevice;
   roz_x := GetMaxX;
   roz_y := GetMaxY;
   pal_x := floor(roz_x/2);
   dlugosc_paletki := floor(roz_x/18);
end;

procedure rysuj_pilke(i : Integer);

  begin
    FillEllipse(floor(roz_x/2)+i, floor(roz_y/2)+i, 20,20);
    delay(10);
    SetVisualPage(1);
    SetActivePage(0);
    SetFillStyle(0,255);
    FillEllipse(floor(roz_x/2)+i-1, floor(roz_y/2)+i-1, 20,20);
    SetFillStyle(1,255);
  end;

procedure rysuj_paletke();

  begin
    pal_x := pal_x + zmiana;
    Repeat
     Begin
       SetVisualPage(0);
       SetActivePage(1);
       bar(pal_x-dlugosc_paletki,roz_y-30,pal_x+dlugosc_paletki, roz_y-20);
       SetFillStyle(0,255);
       if zmiana = 1 then
         bar(pal_x-dlugosc_paletki-zmiana,roz_y-30,pal_x-dlugosc_paletki, roz_y-20)
       else if zmiana = -1 then
         bar(pal_x+dlugosc_paletki,roz_y-30,pal_x+dlugosc_paletki+zmiana, roz_y-20);
       SetFillStyle(1,255);
       zmiana := 0;
       rysuj_pilke(i);
       i := i+1;
     end;
  Until (keypressed);
  end;

BEGIN
END.