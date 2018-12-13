{   ����������� :

    S   |  V   | F/m | t
    X1  |  X2  |  U  | t
   Y[1] | Y[2] |  U  | x0

   dX1/dt=F[1] - ������ ����� 1-�� ���������
   dX2/dt=F[2] - ������ ����� 2-�� ���������}

unit Diff_Equations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, VclTee.TeeGDIPlus, VCLTee.Series, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel2: TPanel;
    Label5: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    Button1: TButton;
    Chart1: TChart;
    Series1: TPointSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
  private
    procedure KeyPress(var Key: Char);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  x0,
  x0z,
  xk,
  x,
  x1,
  x2,
  U,
  h,
  hz,
  eps,
  K:                Extended;

  n:                Byte;

  y,
  yz,
  y0,
  y0z,
  f:                Array [1..5] of double;

implementation

{$R *.dfm}

procedure equation(x: real);
begin
  if y[1] <= 0 then                                                             // ������������ ����������
    k := 1
  else
    k := -1;

  if (k * sqrt( abs(2 * y[1]) ) - y[2]) >= 0 then
    u := 1
  else
    u := -1;

   f[1] := y[2];                                                                // ��������� �������� �������
   f[2] := u;
end;

procedure Euler(x0: real);                                                      // ��������� ��������� � ������ ������ 1-�� �������
var
  x:                Double;
  i:                Byte;
begin
  equation(x0);
  for i := 1 to n do
    y[i] := y0[i] + h * f[i];
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,
  j:                Integer;
begin

  case Button1.Tag of
    0 : begin
          Button1.Tag := 1;
          Button1Click(Sender);
        end;
    1 : begin
          Button1.Tag := 0;
        end;
  end;

//================= ����������� ��������� ������� ==============================

  n := StrToInt(Edit3.Text);                                                    // ������� ������� ���������
  x0 := StrToInt(Edit4.Text);                                                   // ��������� ����� ��������
  xk := StrToInt(Edit5.Text);                                                   // �������� ����� ��������
  h := StrToFloat(Edit6.Text);                                                  // ��������� ��� ��������������
  eps := StrToFloat(Edit7.Text);                                                // ������������� �����������
  y0[1] := StrToFloat(Edit1.Text);                                              // ��������� ���������� ������� - X1
  y0[2] := StrToFloat(Edit2.Text);                                              // ��������� ���������� ������� - X2

//==============================================================================

  hz := h;                                                                      // ��������� ���������� ���� �������������� � �����
  x0z := x0;                                                                    // ��������� ���������� ������� �������� � �����

  x := x0;

  while (sqr( y0[1]) + sqr(y0[2]) ) > 0.001 do                                  // ������� ����������� �����
    begin
      Euler(x0);                                                                // 1-� ��� �� �������� h �� ��������� �����

      for i := 1 to n do
        yz[i] := y[i];                                                          // ����������� �������� Y[i]

      h := h / 2;                                                               // ���������� �������� ���� � ����
      Euler(x0);                                                                // 2-� ��� �� �������� h/2 �� ��������� �����

      for i := 1 to n do
        y0[i] := y[i];                                                          // ������������ ����� ��������� ������� ��� Y0[i]

      x0 := x0 + h;                                                             // ������������ ����� ��������� ������� ��� x0

      Euler(x0);                                                                // 3-� ��� �� �������� h/2 �� �������� �������

      j := 0;                                                                   // �������� ������������ ����� ������� ��������� N

      for i := 1 to n do                                                        // �������� ����������� �������� �� ���� ����������
        if abs( yz[i] - y[i] ) < (eps * abs(yz[i])) then
          inc(j);

      if j = n then                                                             // ������� ���������� ��������
        begin
          x0 := x0 + h;                                                         // ������������ ����� ��������� �������
          x0z := x0;                                                            // ����������� ����� ��������� �������

          for i:=1 to n do
            begin
              y0[i] := y[i];
              y0z[i] := y[i];
            end;

          h := hz;                                                              // �������������� ��������� �������� ���� ��������������

          Chart1.Series[0].AddXY(y[1],y[2]);                                    // ����� ����������� ������� �� ������

          Chart1.Series[1].AddXY(0,y0[2]);                                      // ��� ������
          Chart1.Series[1].AddXY(0,-y0[2]);

          Chart1.Series[2].AddXY(-y0[1],0);                                     // ��� �������
          Chart1.Series[2].AddXY(y0[1],0);

          //Chart1.Series[1].AddXY(x0,y[1]);
          //Chart1.Series[2].AddXY(x0,y[2]);

          Chart1.Refresh;                                                       // ���������� �������
        end
      else                                                                      // � ������, ���� �������� �� ���������� ���������� ������� � �������� ����� � ��������� ����������
        begin
          x0 := x0z;
          x := x0;
          for i := 1 to n do
            y0[i] := y0z[i];
        end;
    end;

  Chart1.SaveToBitmapFile('Phase_Trajectories.bmp');                            // ���������� �����������
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TForm1.KeyPress(var Key: Char);
begin
  if not (Key in ['0'..'9',',',#8,'-']) then
    Key := #0;
end;

end.
