unit Ustawienia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LclIntf;

type

  { TUstawie }

  TUstawie = class(TForm)
    pseudo: TEdit;
    Pseudonim: TLabel;
    paletka: TButton;
    ColorDialog2: TColorDialog;
    pilka: TButton;
    ColorDialog1: TColorDialog;
    Zapisz: TButton;
    Anuluj: TButton;
    Fullscreen: TCheckBox;
    Label1: TLabel;
    wysokosc: TLabel;
    szerokoscedit: TEdit;
    szerokosc: TLabel;
    wysokoscedit: TEdit;
    procedure AnulujClick(Sender: TObject);
    procedure ColorDialog1Close(Sender: TObject);
    procedure ColorDialog2Close(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure paletkaClick(Sender: TObject);
    procedure pilkaClick(Sender: TObject);
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
  kolor : String;
  kolor_menu : Integer;
  kolorp : String;
  kolorp_menu : Integer;
  R,G,B : Integer;

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
      Fullscreen.Checked := IntToBool(StrToInt(Linia))
    else if Wartownik = 4 then
      kolor := Linia
    else if Wartownik = 5 then begin
      ColorDialog1.Color := StrToInt(Linia);
      kolor_menu := StrToInt(Linia);
      end
    else if Wartownik = 6 then
      kolorp := Linia
    else if Wartownik = 7 then begin
      ColorDialog2.Color := StrToInt(Linia);
      kolorp_menu := StrToInt(Linia);
    end
    else if Wartownik = 8 then
      pseudo.Text := Linia;
    Inc(Wartownik);
  Until (Eof(Plik));
  CloseFile(Plik);
end;

procedure TUstawie.paletkaClick(Sender: TObject);
begin
  ColorDialog2.Execute;
end;


procedure TUstawie.AnulujClick(Sender: TObject);
begin
  Ustawie.Close;
end;

procedure TUstawie.ColorDialog1Close(Sender: TObject);
begin
  R := GetRValue(ColorDialog1.Color);
  G := GetGValue(ColorDialog1.Color);
  B := GetBValue(ColorDialog1.Color);
  kolor:='$'+IntToHex(R,2)+IntToHex(G,2)+IntToHex(B,2);
  kolor_menu := ColorDialog1.Color;
end;

procedure TUstawie.ColorDialog2Close(Sender: TObject);
begin
  R := GetRValue(ColorDialog2.Color);
  G := GetGValue(ColorDialog2.Color);
  B := GetBValue(ColorDialog2.Color);
  kolorp:='$'+IntToHex(R,2)+IntToHex(G,2)+IntToHex(B,2);
  kolorp_menu := ColorDialog2.Color;
end;

procedure TUstawie.pilkaClick(Sender: TObject);
begin
  ColorDialog1.Execute;
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
    end
    else if Wartownik = 4 then
      Writeln(Plik, kolor)
    else if Wartownik = 5 then
      Writeln(Plik, kolor_menu)
    else if Wartownik = 6 then
      Writeln(Plik, kolorp)
    else if Wartownik = 7 then
      Writeln(Plik, kolorp_menu)
    else if Wartownik = 8 then
      Writeln(Plik, pseudo.Text);
    Inc(Wartownik);
  Until Wartownik = 9;
  CloseFile(Plik);
  Ustawie.Close;
end;

end.

