unit UPessoaIncluir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,

  // Classe Pessoa
  ClassePessoa;

type
  TfrmPessoaIncluir = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    edNome: TEdit;
    edIdade: TEdit;
    Panel2: TPanel;
    bIncluir: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure bIncluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    function DadosCorretos:Boolean;
    procedure IncluirPessoa;
    function NomeValido:Boolean;
    function IdadeValida:Boolean;
    function NaoInformou(pNomeCampo:String;pCampo:TEdit):Boolean;
    procedure LimpaTela;
  public
    { Public declarations }
  end;

var
  frmPessoaIncluir: TfrmPessoaIncluir;
  Pessoa: TPessoa;

implementation

{$R *.dfm}

procedure TfrmPessoaIncluir.bIncluirClick(Sender: TObject);
begin
  if not DadosCorretos then
     Abort;

  IncluirPessoa;
end;

function TfrmPessoaIncluir.DadosCorretos: Boolean;
begin
  result := false;

  if not NomeValido then
     Abort;

  if not IdadeValida then
     Abort;

  result := true;
end;

procedure TfrmPessoaIncluir.FormCreate(Sender: TObject);
begin
   Pessoa := TPessoa.Create;
end;

procedure TfrmPessoaIncluir.FormDestroy(Sender: TObject);
begin
   FreeAndNil(Pessoa);
end;

function TfrmPessoaIncluir.IdadeValida: Boolean;
begin
   Result := false;
   if NaoInformou('a Idade da Pessoa',edIdade) then
      Abort;
   Result := True;
end;

procedure TfrmPessoaIncluir.IncluirPessoa;
begin
   Pessoa.Nome := edNome.Text;
   Pessoa.Idade:= StrToInt(edIdade.Text);
   Pessoa.Incluir;
   LimpaTela;
end;

procedure TfrmPessoaIncluir.LimpaTela;
begin
   edNome.Text := '';
   edIdade.Text := '';
   edNome.SetFocus;
end;

function TfrmPessoaIncluir.NaoInformou(pNomeCampo: String;
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

function TfrmPessoaIncluir.NomeValido: Boolean;
begin
   Result := false;
   if NaoInformou('o Nome da Pessoa',edNome) then
      Abort;
   Result := True;
end;

procedure TfrmPessoaIncluir.SpeedButton1Click(Sender: TObject);
begin
   close;
end;

end.
