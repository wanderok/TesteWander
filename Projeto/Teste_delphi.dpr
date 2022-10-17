program Teste_delphi;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {FrmPrincipal},
  ClassePessoa in 'ClassePessoa.pas',
  Dados in 'Dados.pas' {DM: TDataModule},
  UPessoaAlterar in 'UPessoaAlterar.pas' {frmPessoaAlterar},
  UPessoaIncluir in 'UPessoaIncluir.pas' {frmPessoaIncluir},
  IDelphi1 in 'IDelphi1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
