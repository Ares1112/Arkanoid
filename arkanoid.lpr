program arkanoid;

uses
  wincrt, graph, grafika, sterowanie;

begin
  rysuj_plansze();
  while(true) do begin
    rysuj_paletke();
    steruj_paletka();
  end;
end.

