{
 Ce graphique illustre la courbe de Von Koch, vue sur le site d�di� aux math�matiques de Serge Mehl voir http://serge.mehl.free.fr/anx/flocon_koch.html

 Ce programme est une adaptation sous Delphi, de son programme initialement �crit en BASIC.
}

program PVonKoch;

uses
  Forms,
  uMain in 'uMain.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Courbe de Von Koch';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
