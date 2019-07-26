unit life;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons; 

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    Timer2: TTimer;
    Label11: TLabel;
    ScrollBar5: TScrollBar;
    Label12: TLabel;
    Button4: TButton;
    ProbCorrupt: TScrollBar;
    Label13: TLabel;
    CurrProbLabel: TLabel;
    Button5: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Mem1: TButton;
    Mem2: TButton;
    Mem3: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Bevel3: TBevel;
    Button9: TButton;
    Label10: TLabel;
    Button11: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Bevel4: TBevel;
    CheckBox2: TCheckBox;
    Button3: TButton;
    Button10: TButton;
    procedure Button10Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Mem3Click(Sender: TObject);
    procedure Mem2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Mem1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    procedure ProbCorruptChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ScrollBar5Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);




    procedure FormCreate(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  A:array[0..50,0..50] of integer;
  B:array[0..50,0..50] of integer;   (*это образы*)
  C:array[0..50,0..50] of integer;
  D:array[0..50,0..50] of integer;          (*да, всего три*)
  flip, numNeuron, learnt: integer;
  W:array[0..2500,0..2500] of Real;
  V:array[0..2500] of integer;
  VV:array[0..2500] of integer;
  ptG: TPoint;           (* положение курсора (для рисовалки)*)
  drawing: Boolean;
  myFile : TextFile;


implementation

{$R *.dfm}


 procedure TForm1.FormCreate(Sender: TObject);
begin
AssignFile(myFile, 'Test.txt');
Label12.Caption:=IntToStr(ScrollBar5.Position*ScrollBar5.Position)+': '+
IntToStr(ScrollBar5.Position)+ ' X ' +IntToStr(ScrollBar5.Position);
Form1.CurrProbLabel.Caption:=FloatToStr((ProbCorrupt.Position-500)/1000);
drawing:=False;
numNeuron:=3;
Label2.Caption:=FloatToStr(1-ScrollBar1.Position/1000);
learnt:=0;
end;

procedure TForm1.Mem1Click(Sender: TObject);
var  i,j: integer;
      begin
   for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
        begin
         B[i,j]:=A[i,j];
        end;
        end;
end;

procedure TForm1.Mem2Click(Sender: TObject);
var  i,j: integer;
      begin
   for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
        begin
         C[i,j]:=A[i,j];
        end;
        end;
end;

procedure TForm1.Mem3Click(Sender: TObject);
var  i,j: integer;
      begin
   for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
        begin
         D[i,j]:=A[i,j];
        end;
        end;
end;

procedure DrawField(n:integer);   (*как рисовать квадраты в зависимости от их рамзера*)
var  i,j,rectDim: integer;
      begin
rectDim:=Trunc(Form1.PaintBox1.Width/numNeuron);
   for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
        begin
        If A[i,j]=1 then
         begin
          Form1.PaintBox1.Canvas.Pen.Width:=1;
          Form1.PaintBox1.Canvas.Pen.Color:=clBlack;
          Form1.PaintBox1.Canvas.Brush.Color:=clGreen;
          Form1.PaintBox1.Canvas.Rectangle(2+i*rectDim,2+j*rectDim,rectDim+i*rectDim,rectDim+j*rectDim);
           end else
                begin
                  Form1.PaintBox1.Canvas.Pen.Width:=0;
                  Form1.PaintBox1.Canvas.Brush.Color:=clwhite;
                  Form1.PaintBox1.Canvas.Rectangle(2+i*rectDim,2+j*rectDim,rectDim+i*rectDim,rectDim+j*rectDim);
                end;
          end;
        end;
end;




procedure TForm1.Button1Click(Sender: TObject);  (*случайный массив*)
var i,j:integer;
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
         If Random(1000)>500 then A[i,j]:=1 else A[i,j]:=0;
       end;
    end;
    DrawField(1);
 end;

procedure TForm1.Button4Click(Sender: TObject); (*с вероятностью -> corrupt*)
  var i,j: integer;
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
            If Random(Form1.ProbCorrupt.Position)>500 then
            begin      (*переворот*)
              If A[i,j]=1 then
                begin
                A[i,j]:=0;
                end
                  else   A[i,j]:=1;
                 (*   If A[i,j]=0 then
                    begin
                    A[i,j]:=1;
                    end;  *)
            end;
       end;
    end;
  end;
  DrawField(1);
end;

procedure TForm1.Button5Click(Sender: TObject);   (*инверсировать картину*)
 var i,j: integer;
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
                  If A[i,j]=1 then
                begin
                A[i,j]:=0
                end
                  else   A[i,j]:=1;
       end;
    end;
  end;
  DrawField(1);
end;


procedure TForm1.Button6Click(Sender: TObject);
  var i,j: integer;
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
       A[i,j]:=B[i,j];
       end;
       end;
DrawField(1);
end;
end;

procedure TForm1.Button7Click(Sender: TObject);
  var i,j: integer;
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
       A[i,j]:=C[i,j];
       end;
       end;
DrawField(1);
end;
end;
procedure TForm1.Button8Click(Sender: TObject); (*очистить веса*)
  var i,j: integer;
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
       A[i,j]:=D[i,j];
       end;
       end;
DrawField(1);
end;
end;

procedure TForm1.Button9Click(Sender: TObject);
  var i,j: integer; myFile : TextFile;
begin
learnt:=learnt+1;
AssignFile(myFile, 'weights.txt');
ReWrite(myFile);
Label10.Caption:='';
for j := 0 to numNeuron-1 do
   begin
      for i:=0 to numNeuron-1 do
       begin
       V[j*numNeuron+i]:=A[i,j];          (*превращаем матрицу в 1D массив
       1 2 3
       4 5 6
       7 8 9

       if i<numNeuron-1 then
       begin
       Label10.Caption:=Label10.Caption+' '+ IntToStr(A[i,j]); end   else
       begin
       Label10.Caption:=Label10.Caption+' '+ IntToStr(A[i,j])+'  ';
       end;  *)
       end;
   end;
for j := 0 to numNeuron*numNeuron-1 do
   begin
      for i:=j+1 to numNeuron*numNeuron-1 do
       begin
       W[i,j]:=W[i,j]+(2*V[i]-1)*(2*V[j]-1);
       W[j,i]:=W[i,j];
       end;
       end;
for j := 0 to numNeuron*numNeuron-1 do
begin
  for i := 0 to numNeuron*numNeuron-1 do
begin
 Write(myFile, FloatToStr(W[i,j]) + ' ');
end;
  WriteLn(myFile, '');
end;
CloseFile(myFile);
Mem3.Click;
Button2.Click;
end;





procedure TForm1.Button10Click(Sender: TObject);
var i,j:integer;
begin
for i := 0 to numNeuron*numNeuron-1 do
begin
    for j := 0 to numNeuron*numNeuron-1 do      begin
      W[i,j]:=  W[i,j]/learnt;
    end;
end;

end;

procedure TForm1.Button11Click(Sender: TObject);
var i,j,iter:integer;
summa:Real;
begin
(*синхронный метод++++++++++++++++++++*)
for j := 0 to numNeuron-1 do
   begin
      for i:=0 to numNeuron-1 do
       begin
       V[j*numNeuron+i]:=A[i,j];
       end;
   end;
  for j := 0 to numNeuron*numNeuron-1 do
    begin
      summa:=0;
      begin
        for i := 0 to numNeuron*numNeuron-1 do
          begin
          summa:=summa + W[i,j]*(2*V[i]-1);
          end;
               if summa >= 0 then
                  begin
                  VV[j]:=1;
                   end else
                    VV[j]:=0;
       end;
  end;
  (*асинхронно*)
  if CheckBox1.Checked then  begin
for iter := 1 to StrToInt(Edit1.Text) do
begin
    for j := 0 to numNeuron-1 do
   begin
      for i:=0 to numNeuron-1 do
      if Random(1000)>ScrollBar1.Position then
       A[i,j]:=VV[j*numNeuron+i];
   end;
   if CheckBox2.Checked then     begin
        DrawField(1);
   end;
end;
  DrawField(1);
end
(*асинхронно*)
else begin
  for j := 0 to numNeuron-1 do
   begin
      for i:=0 to numNeuron-1 do
       A[i,j]:=VV[j*numNeuron+i];
   end;
  DrawField(1);
end;
end;
    









procedure TForm1.ProbCorruptChange(Sender: TObject);    (*вероятность изменения
тут только для отображения*)
begin
Form1.CurrProbLabel.Caption:=FloatToStr((ProbCorrupt.Position-500)/1000);
end;

 procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
Label2.Caption:=FloatToStr(1-ScrollBar1.Position/1000);
end;

procedure TForm1.ScrollBar5Change(Sender: TObject);   (*количество нодов*)
begin
PaintBox1.Refresh;
numNeuron:=ScrollBar5.Position;
Label12.Caption:=IntToStr(ScrollBar5.Position*ScrollBar5.Position)+': '+
IntToStr(ScrollBar5.Position)+ ' X ' +IntToStr(ScrollBar5.Position);
Form1.CurrProbLabel.Caption:=FloatToStr((ProbCorrupt.Position-500)/1000);
DrawField(1);
end;


procedure TForm1.Button2Click(Sender: TObject);
var i,j:integer;                 (*все стереть*)
begin
  begin
    for j:=0 to numNeuron-1 do
    begin
      for i:=0 to numNeuron-1 do
       begin
         A[i,j]:=0
       end;
    end;
   DrawField(1);
end;
end;






procedure TForm1.Button3Click(Sender: TObject);
var i,j:integer;                 (*убрать из памяти сети*)
begin
  begin
    for j:=0 to numNeuron*numNeuron-1 do
    begin
      for i:=0 to numNeuron*numNeuron-1 do
       begin
         W[i,j]:=0
       end;
    end;
end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin           (*чтобы нарисовать ноды после запуска (красиво)*)
Sleep(5);
Timer2.Enabled:=False;
DrawField(1);
end;



 procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
drawing:=False;
end;



procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  drawing:=True;
   ptG := Mouse.CursorPos;
    ptG := PaintBox1.ScreenToClient(ptG);
    If    (ssLeft in Shift)      then
       A[Trunc((ptG.X)/Trunc(Form1.PaintBox1.Width/numNeuron)),
       Trunc((ptG.Y)/Trunc(Form1.PaintBox1.Width/numNeuron))]:=1     else begin
        A[Trunc((ptG.X)/Trunc(Form1.PaintBox1.Width/numNeuron)),
       Trunc((ptG.Y)/Trunc(Form1.PaintBox1.Width/numNeuron))]:=0;
       end;
       DrawField(1);
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject;
 Shift: TShiftState;
X,  Y: Integer);         (*рисовать левой, чистить правой клик мыши*)
begin
if drawing then
       begin
       ptG := Mouse.CursorPos;
       ptG := PaintBox1.ScreenToClient(ptG);
       (*Label10.Caption:=IntToStr(ptG.X)+ ' ' + IntToStr(ptG.Y);      *)
          If    (ssLeft in Shift)      then
       A[Trunc((ptG.X)/Trunc(Form1.PaintBox1.Width/numNeuron)),
       Trunc((ptG.Y)/Trunc(Form1.PaintBox1.Width/numNeuron))]:=1     else begin
        A[Trunc((ptG.X)/Trunc(Form1.PaintBox1.Width/numNeuron)),
       Trunc((ptG.Y)/Trunc(Form1.PaintBox1.Width/numNeuron))]:=0;
       end;
       DrawField(1);
      end;
end;







end.



