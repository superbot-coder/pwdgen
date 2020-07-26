unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, sMemo, Math,
  sCheckBox, sEdit, sSpinEdit, sLabel, sSkinManager, sDialogs;

type
  TMain = class(TForm)
    BtnStart: TsButton;
    mm: TsMemo;
    ChBoxAlphaL: TsCheckBox;
    ChBoxAlphaU: TsCheckBox;
    ChBoxDigital: TsCheckBox;
    ChBoxSpecialChar: TsCheckBox;
    SpEditLength: TsSpinEdit;
    SpEditCount: TsSpinEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    edCastomSpecialChar: TsEdit;
    ChBoxCastomChar: TsCheckBox;
    sSkinManager: TsSkinManager;
    BtnSave: TsButton;
    BtnClose: TsButton;
    sSaveDialog: TsSaveDialog;
    BtnClear: TsButton;
    ChBoxNumeric: TsCheckBox;
    ChBoxSorted: TsCheckBox;
    function GeneratePWD: AnsiString;
    function GetRandomChar(AStrValue: AnsiString): AnsiChar;
    procedure BtnStartClick(Sender: TObject);
    procedure ChBoxCastomCharClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

const
  AlphaL = 'abcdefghijklmnopqrstuvwxyz'; // Alfa LowerCase
  AlphaU = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // Alfa UpperCase
  Digital = '0123456789';                // Numeric
  Special = '!@#$%^&*()-_+=~`[]{}|\:;"''<>,.?/'; //Special Symbols
  Space   = ' ';

implementation

{$R *.dfm}

{ TMain }

procedure TMain.BtnClearClick(Sender: TObject);
begin
  mm.Lines.Clear;
end;

procedure TMain.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.BtnSaveClick(Sender: TObject);
begin
  sSaveDialog.FileName := 'NewPwdList.txt';
  if Not sSaveDialog.Execute then Exit;
  if Length(ExtractFileExt(sSaveDialog.FileName)) = 0 then
    sSaveDialog.FileName := sSaveDialog.FileName + '.txt';
  mm.Lines.SaveToFile(sSaveDialog.FileName);
end;

procedure TMain.BtnStartClick(Sender: TObject);
var
  i: SmallInt;
  ST: TStringList;
begin
  mm.Clear;

  ST := TStringList.Create;
  if ChBoxSorted.Checked then ST.Sorted := true else ST.Sorted := false;
  ST.CaseSensitive := true;
  ST.Duplicates    := dupIgnore;

  While ST.Count < SpEditCount.value do
  begin
    ST.Add(GeneratePWD);
  end;

  mm.Lines.BeginUpdate;

  for i := 0 to  ST.Count -1 do
  begin
   if ChBoxNumeric.Checked then
     mm.Lines.Add(IntToStr(succ(i)) + ' '+ST.Strings[i])
   else
     mm.Lines.Add(ST.Strings[i]);
  end;

  mm.Lines.EndUpdate;
  ST.free;

end;

procedure TMain.ChBoxCastomCharClick(Sender: TObject);
begin
  if ChBoxCastomChar.Checked then
  begin
    ChBoxSpecialChar.Enabled    := false;
    edCastomSpecialChar.Enabled := true;
  end
  else
  begin
    ChBoxSpecialChar.Enabled    := true;
    edCastomSpecialChar.Enabled := false;
  end;
end;

function TMain.GeneratePWD: AnsiString;
var
  AStr: AnsiString;
  i, x: ShortInt;
begin
  Result := '';
  AStr   := '';

  while true do
  begin
    if ChBoxAlphaL.Checked then AStr := AStr + GetRandomChar(AlphaL);
    if SpEditLength.Value = Length(AStr) then Break;

    if ChBoxAlphaU.Checked then AStr := AStr + GetRandomChar(AlphaU);
    if SpEditLength.Value = Length(AStr) then Break;

    if ChBoxDigital.Checked then AStr := AStr + GetRandomChar(Digital);
    if SpEditLength.Value = Length(AStr) then Break;

    if ChBoxSpecialChar.Checked and ChBoxSpecialChar.Enabled then AStr := AStr + GetRandomChar(Special);
    if SpEditLength.Value = Length(AStr) then Break;

    if ChBoxCastomChar.Checked and (edCastomSpecialChar.Text <> '') then AStr := AStr + GetRandomChar(edCastomSpecialChar.Text);
    if SpEditLength.Value = Length(AStr) then Break;
  end;

  Result := StringOfChar(#0, SpEditLength.Value);

  for i:=1 to SpEditLength.Value do
  begin
    while true do
    begin
      Randomize;
      x := RandomRange(1, SpEditLength.Value +1);
      if Result[x] = #0 then
      begin
        Result[x] := AStr[i];
        Break;
      end;
    end;
  end;

end;

function TMain.GetRandomChar(AStrValue: AnsiString): AnsiChar;
Var
  x: ShortInt;
begin
  Randomize;
  x :=  RandomRange(1, length(AStrValue)+1);
  Result :=  AStrValue[x];
end;

end.
