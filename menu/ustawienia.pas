unit Ustawienia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TUstawie }

  TUstawie = class(TForm)
    Zapisz: TButton;
    Anuluj: TButton;
    Fullscreen: TCheckBox;
    Label1: TLabel;
    wysokosc: TLabel;
    szerokoscedit: TEdit;
    szerokosc: TLabel;
    wysokoscedit: TEdit;
    procedure AnulujClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ZapiszClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Ustawie: TUstawie;
  Wartownik : shortint = 1;
  Plik: TextFile;
  Linia: String;

implementation

{$R *.lfm}

{ TUstawie }

function IntToBool(liczba : shortint) : Boolean;
Begin
  If liczba = 0 then
    IntToBool := False
  else IntToBool := True;
end;

procedure TUstawie.FormCreate(Sender: TObject);
begin
  AssignFile(Plik,'..\pliki\ustawienia.txt');
  {$I-};
  Append(Plik);
  {$I+};
  If IOResult <> 0 Then Rewrite(Plik);
  Reset(Plik);
  Repeat
    Readln(Plik,Linia);
    if Wartownik = 1 then
      szerokoscedit.Text := Linia
    else if Wartownik = 2 then
      wysokoscedit.Text := Linia
    else if Wartownik = 3 then
      Fullscreen.Checked := IntToBool(StrToInt(Linia));
    Inc(Wartownik);
  Until (Eof(Plik));
  CloseFile(Plik);
end;

procedure TUstawie.AnulujClick(Sender: TObject);
begin
  Ustawie.Close;
end;

procedure TUstawie.Label1Click(Sender: TObject);
begin

end;

procedure TUstawie.ZapiszClick(Sender: TObject);
begin
  Wartownik := 1;
  AssignFile(Plik,'..\pliki\ustawienia.txt');
  {$I-};
  Append(Plik);
  {$I+};
  Rewrite(Plik);
  Repeat
    if Wartownik = 1 then
      Writeln(Plik, szerokoscedit.Text)
    else if Wartownik = 2 then
      Writeln(Plik, wysokoscedit.Text)
    else if Wartownik = 3 then begin
      if Fullscreen.Checked = True then
        Writeln(Plik, '1')
      else Writeln(Plik, '0');
    end;
    Inc(Wartownik);
  Until Wartownik = 4;
  CloseFile(Plik);
  Ustawie.Close;
end;

end.
