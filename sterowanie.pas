unit sterowanie;

interface
procedure steruj_paletka();
var zmiana : Integer;
implementation

uses wincrt;

procedure steruj_paletka();
  var
    klawisz : Char;
  begin
    klawisz:=ReadKey;
    if klawisz = #75 then zmiana := -1
    else if klawisz = #77 then zmiana := 1;
  end;
begin
end.

