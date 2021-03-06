unit podzespoly;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, dos, wincrt, statystyki, ustawienia, Instr;

type

  { TForm1 }

  TForm1 = class(TForm)
    Instrukcja: TButton;
    Statystyki: TButton;
    Ustawienia: TButton;
    Graj: TButton;
    Wyjscie: TButton;
    Tlo: TImage;
    procedure GrajClick(Sender: TObject);
    procedure InstrukcjaClick(Sender: TObject);
    procedure StatystykiClick(Sender: TObject);
    procedure TloClick(Sender: TObject);
    procedure WyjscieClick(Sender: TObject);
    procedure UstawnieniaClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Plik: TextFile;
  Linia: String;
  Wartownik : shortint = 1;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.WyjscieClick(Sender: TObject);
begin
  Halt(0);
end;

procedure TForm1.GrajClick(Sender: TObject);
begin
  Exec('..\arkanoid.exe','');
end;

procedure TForm1.InstrukcjaClick(Sender: TObject);
begin
  Inst.ShowModal();
end;

procedure TForm1.UstawnieniaClick(Sender: TObject);
begin
  Ustawie.ShowModal();
end;

procedure TForm1.StatystykiClick(Sender: TObject);
begin
  AssignFile(Plik,'..\pliki\statystyki.txt');
  {$I-};
  Append(Plik);
  {$I+};
  If IOResult <> 0 Then Rewrite(Plik);
  Reset(Plik);
  Repeat
    Readln(Plik,Linia);
    if Wartownik = 1 then
      Staty.Tekst.Caption := 'Liczba rozegranych gier: ' + Linia + #10 + #10 + 'Najwyzsze wyniki' + #10 + #10
    else Staty.Tekst.Caption := Staty.Tekst.Caption + Linia + #10;
    Inc(Wartownik);
  Until (Eof(Plik)) OR (Wartownik = 12);
  CloseFile(Plik);
  Staty.ShowModal;
end;

procedure TForm1.TloClick(Sender: TObject);
begin

end;

end.

