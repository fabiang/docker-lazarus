program gui_app;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
end.
