unit UPessoaAlterar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,

  // Classe Pessoa
  ClassePessoa;

type
  TfrmPessoaAlterar = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    edNome: TEdit;
    edIdade: TEdit;
    Panel2: TPanel;
    bAlterar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    edID: TEdit;
    procedure bAlterarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    function DadosCorretos:Boolean;
    procedure AlterarPessoa;
    function NomeValido:Boolean;
    function IdadeValida:Boolean;
    function NaoInformou(pNomeCampo:String;pCampo:TEdit):Boolean;
    procedure LimpaTela;
  public
    { Public declarations }
  end;

var
  frmPessoaAlterar: TfrmPessoaAlterar;
  Pessoa: TPessoa;

implementation

{$R *.dfm}

procedure TfrmPessoaAlterar.bAlterarClick(Sender: TObject);
begin
  if not DadosCorretos then
     Abort;

  AlterarPessoa;
end;

function TfrmPessoaAlterar.DadosCorretos: Boolean;
begin
  result := false;

  if not NomeValido then
     Abort;

  if not IdadeValida then
     Abort;

  result := true;
end;

procedure TfrmPessoaAlterar.FormCreate(Sender: TObject);
begin
   Pessoa := TPessoa.Create;
end;

procedure TfrmPessoaAlterar.FormDestroy(Sender: TObject);
begin
   FreeAndNil(Pessoa);
end;

function TfrmPessoaAlterar.IdadeValida: Boolean;
begin
   Result := false;
   if NaoInformou('a Idade da Pessoa',edIdade) then
      Abort;
   Result := True;
end;

procedure TfrmPessoaAlterar.AlterarPessoa;
var id,Idade : Integer;
begin
   try
       id := StrToInt(edId.Text);
   except
     ShowMessage('ID inválido.');
     Abort;
   end;
   try
       Idade := StrToInt(edIdade.Text)
   except
     ShowMessage('Idade inválida.');
     Abort;
   end;

   Pessoa.Alterar(Id,edNome.Text,Idade);
   ShowMessage('Dados alterados com Sucesso!');
   Close;
end;

procedure TfrmPessoaAlterar.LimpaTela;
begin
   edNome.Text := '';
   edIdade.Text := '';
   edNome.SetFocus;
end;

function TfrmPessoaAlterar.NaoInformou(pNomeCampo: String;
  pCampo: TEdit): Boolean;
begin
   Result := true;
   if pCampo.text = '' then
   begin
     ShowMessage('Informe '+pNomeCampo);
     pCampo.SetFocus;
     abort;
   end;
   Result := False;
end;

function TfrmPessoaAlterar.NomeValido: Boolean;
begin
   Result := false;
   if NaoInformou('o Nome da Pessoa',edNome) then
      Abort;
   Result := True;
end;

procedure TfrmPessoaAlterar.SpeedButton1Click(Sender: TObject);
begin
   close;
end;

end.
