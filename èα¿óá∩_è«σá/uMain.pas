unit uMain;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, Dialogs, Buttons, ExtCtrls, Sysutils,
  Grids;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    pNiveau: TPanel;
    sbNext: TSpeedButton;
    sbPrevious: TSpeedButton;
    sg: TStringGrid;
    sbAbout: TSpeedButton;
    procedure sbPreviousClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbNextClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sbAboutClick(Sender: TObject);
  private
    { Déclarations privées }
    n,
    Niveau: integer;
    co, si : real;
    dx,dy: integer;
    x,y : array[0..64000] of integer;
  public
    { Déclarations publiques }
    procedure DessinerGrille;
    procedure CalculerVecteurs;
    procedure RemplirTable;
    procedure DessinerCourbeVanKoch(old: boolean);
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
begin
  Niveau:=1;    n:=1;
  co:=0.5; si:=sqrt(3)/2;
  x[0]:=100; y[0]:=300;
  x[1]:=700; y[1]:=300;    // côté initial clientWidth-100;

  RemplirTable;
  DessinerGrille; //CourbeVanKoch(false)
end;

procedure TfMain.FormPaint(Sender: TObject);
begin
  DessinerGrille;
  DessinerCourbeVanKoch(false)
end;

procedure TfMain.sbPreviousClick(Sender: TObject);
var
  i: integer;
begin
  if Niveau>1 then
  begin
    // Redessiner l'ancienne en hachuré
    DessinerCourbeVanKoch(true);

    Dec(Niveau); n:=n div 4;  sg.ColCount:=n*4+2;
    for i:=1 to n do       // Ordre décroissant sinon on écrase les valeurs
    begin
      x[i]:=x[i*4];
      y[i]:=y[i*4];
    end;
//    CalculerVecteurs;
//    RemplirTable;
    DessinerCourbeVanKoch(false)
  end
end;

procedure TfMain.sbNextClick(Sender: TObject);
var
  i: integer;
begin
  if Niveau<6 then
  begin
    // Redessiner l'ancienne en hachuré
    DessinerCourbeVanKoch(true);

    for i:=n downto 1 do       // Ordre décroissant sinon on écrase les valeurs
    begin
      x[4*i]:=x[i];
      y[4*i]:=y[i];
    end;
    Inc(Niveau);  n:=4*n;  sg.ColCount:=n+2;
    CalculerVecteurs;
    RemplirTable;
    DessinerCourbeVanKoch(false);
  end
end;

procedure TfMain.CalculerVecteurs;
var
  i: integer;
begin
  if Niveau=1 then begin n:=1; exit end;

  // on obtient le nouveau point, sommet du triangle équilatéral par rotation de 60°.
  i:=0;   // on subdivise par 4   n:=4*n;
  repeat
    dx:=(x[i+4]-x[i]) div 3;  // on coupe en 3
    dy:=(y[i+4]-y[i]) div 3;

    x[i+1]:=x[i]+dx;
    x[i+2]:=x[i+1] + trunc(co*dx - si*dy);
    x[i+3]:=x[i]+2*dx;       // on part du 1/3 et on termine aux 2/3

    y[i+1]:=y[i]+dy;
    y[i+2]:=y[i+1] + trunc(si*dx + co*dy);
    y[i+3]:=y[i]+2*dy;

    inc(i,4)
  until i>4*n;
end;

procedure TfMain.RemplirTable;
var
  i: integer;
begin
  sg.Cells[0,1+2*(niveau-1)]:=format('N=%d', [niveau]);
  sg.Cells[0,1+2*(niveau-1)+1]:=format('N=%d', [niveau]);

  for i:=0 to n do sg.Cells[i+1,0]:=format('%d', [i]);

  for i:=0 to n do
  begin
    sg.Cells[i+1,1+2*(niveau-1)]:=format('%d', [x[i]]);
    sg.Cells[i+1,2+2*(niveau-1)]:=format('%d', [y[i]]);
  end
end;

procedure TfMain.DessinerGrille;
var i : byte;
begin
  with Canvas do
  begin
    Pen.Color:=clWhite;
    Pen.Width:=1;
    Pen.Style:=psDot; //	psDash;
    for i:=1 to 5 do
    begin
      Canvas.TextOut(80, i*100, format('%d', [i*100]));
      MoveTo(100,i*100);  LineTo(700,i*100);
    end;
    for i:=1 to 7 do
    begin
      Canvas.TextOut(i*100-10, 80, format('%d', [i*100]));
      MoveTo(i*100,100);  LineTo(i*100,500);
    end;
  end;
end;

procedure TfMain.DessinerCourbeVanKoch(old: boolean);
var
  i: integer;
begin
  //DessinerGrille;
  Canvas.Pen.Width:=2;
  if old
   then Canvas.Pen.Style:=psDash
   else Canvas.Pen.Style:=psSolid;

  if old
   then Canvas.Pen.Color:=clGreen
   else Canvas.Pen.Color:=clYellow;

//  Canvas.Rectangle(0,0,ClientWidth,ClientHeight);

  pNiveau.Caption:=format('Niveau : %d', [Niveau]);
  // point de départ, puis 1, 2, 3,..., n points
  Canvas.Moveto(x[0],y[0]);
  for i:=1 to n do Canvas.LineTo(x[i],y[i]);

  // point de départ, puis 1, 2, 3,..., n points symétriques
  Canvas.Moveto(x[0],y[0]);
  for i:=1 to n do Canvas.LineTo(x[i],600-y[i]);
end;

procedure TfMain.sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 with TStringGrid(sender) do
 begin
   if (ACol-1) mod 4 = 0 then
   begin
     Canvas.Font.style:=[fsBold];
     Canvas.Font.Color:=clBlue;
   end
   else
   if (Acol>0) and (Cells[Acol, ARow]<>'') and (StrtoInt(Cells[Acol, ARow])>10000) then
   begin
     Canvas.Font.style:=[fsBold];
     Canvas.Font.Color:=clRed;
   end
   else
   begin
     Canvas.Font.style:=[];
     Canvas.Font.Color:=clBlack
   end;

   Canvas.FillRect(Rect);
   Canvas.TextOut(Rect.Left+8, Rect.Top+2, Cells[Acol, ARow]);
  end
end;

procedure TfMain.sbAboutClick(Sender: TObject);
begin
  ShowMessage('Ce graphique montre la courbe de Von Koch,'^M^M
              +'vue sur le site dédié aux mathématiques de Serge Mehl voir http://serge.mehl.free.fr/anx/flocon_koch.html'^M^M
              +'Ce programme est une adaptation sous Delphi, de son programme initialement écrit en BASIC.')
end;

end.

// programme initialement écrit en BASIC

DIM x[4096),y[4096)                    'nombre de points. Au-delà, on ne distingue plus rien
n=1
co=.5 : si=SQR(3)/2                   'cosinus et sinus de la rotation
x[0]:=100:y[0]:=350:x[1]:=500:y[1]:=350    'côté initial

WHILE 1
CLS
MOVETO x[0),y[0)                   'point de départ, puis 1, 4, 16,..., ..., 4n points
  FOR i=1 TO n
  LINETO x[i),y[i]
NEXT i

WHILE INKEY$="":WEND
  FOR i=n TO 1 STEP -1            'on boucle en décroissant
  x[4*i]:=x[i):y[4*i]:=y[i]              'sinon on écrase les valeurs
  NEXT i

  n= 4*n                           'on subdivise
  FOR i=0 TO n-4 STEP 4
    dx:=(x[i+4)-x[i])/3; dy=(y[i+4]-y[i])/3      'on coupe en 3
    x[i+1]:=x[i)+dx; x[i+3]:=x[i)+2*dx         'on part du 1/3 et on termine aux 2/3
    y[i+1]:=y[i]+dy; y[i+3]:=y[i]+2*dy
    x[i+2]:=co*dx-si*dy+x[i+1);              'on obtient le nouveau point,
    y[i+2]:=si*dx+co*dy+y[i+1);              'sommet du triangle équilatéral
  NEXT i                                 'par rotation de 60°.

WEND

{
    i:=n;
    repeat    // extension  x4
      x[4*i]:=x[i];  y[4*i]:=y[i];            // sinon on écrase les valeurs
      dec(i);
    until i=0;
    i:=n;
    repeat    // extension
      x[i]:=x[4*i];  y[i]:=y[4*i];            // sinon on écrase les valeurs
      dec(i);
    until i=0;
}
