program menu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, podzespoly, statystyki, ustawienia, Instr
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TStaty, Staty);
  Application.CreateForm(TUstawie, Ustawie);
  Application.CreateForm(TInst, Inst);
  Application.Run;
end.

