unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, Soap.InvokeRegistry,
  System.Net.URLClient, Soap.Rio, Soap.SOAPHTTPClient,

  //Data Modulo
  Dados,
  // Classe Pessoa
  ClassePessoa, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  TFrmPrincipal = class(TForm)
    PnLista: TPanel;
    Qry1: TADOQuery;
    DataSource1: TDataSource;
    ListaPessoa: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    BtnExc: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LblQuant: TLabel;
    LblSoma: TLabel;
    LblMedia: TLabel;
    Label6: TLabel;
    LblParecer: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BtnExcClick(Sender: TObject);
  private
    { Private declarations }
    procedure Iniciar;
    procedure Terminar;
    procedure ConfigurarConexao;
    function ConectarAoBancoDados:Boolean;
    function AtualizarTabelaDePessoas:Boolean;
    procedure MostrarEstatistica;
    procedure AjustarTela;
    procedure IncluirPessoa;
    procedure AlterarPessoa;
    procedure ExcluirPessoa;
    procedure ConsumirWebService;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;
  Pessoa: TPessoa;

implementation

{$R *.dfm}

uses UPessoaIncluir, UPessoaAlterar, IDelphi1;

{ TFrmPrincipal }

procedure TFrmPrincipal.AjustarTela;
begin
   FrmPrincipal.Position := poOwnerFormCenter;
end;

procedure TFrmPrincipal.AlterarPessoa;
begin
   if Qry1.Eof Then
   begin
     ShowMessage('N�o h� cadastro a ser alterado');
     Abort;
   end;
   frmPessoaAlterar:= TfrmPessoaAlterar.Create(self);
   frmPessoaAlterar.edID.Text    := Qry1.FieldByName('ID'  ).AsString;
   frmPessoaAlterar.edNome.Text  := Qry1.FieldByName('NAME').AsString;
   frmPessoaAlterar.edIdade.Text := Qry1.FieldByName('AGE' ).AsString;
   frmPessoaAlterar.ShowModal;
end;

function TFrmPrincipal.AtualizarTabelaDePessoas: Boolean;
begin
    Pessoa.Todos(Qry1);
    Qry1.Open;
    MostrarEstatistica;
end;

procedure TFrmPrincipal.BtnExcClick(Sender: TObject);
begin
   ExcluirPessoa;
   AtualizarTabelaDePessoas;
end;

procedure TFrmPrincipal.Button1Click(Sender: TObject);
begin
   IncluirPessoa;
   AtualizarTabelaDePessoas;
end;

procedure TFrmPrincipal.Button2Click(Sender: TObject);
begin
   AlterarPessoa;
   AtualizarTabelaDePessoas;
end;

function TFrmPrincipal.ConectarAoBancoDados: Boolean;
begin
   if (DM.ADOConnection1.Connected) then
       DM.ADOConnection1.Close;

   ConfigurarConexao;

   try
      DM.AdoConnection1.Connected := true;
      result := true;
   except
      result := false;
   end;
end;

procedure TFrmPrincipal.ConfigurarConexao;
const
   servidor = 'bancobi.grupounicad.com.br,1433';
   usuario  = 'prova_delphi';
   senha    = 'Delphi@123';
   bd       = 'Teste';
var
   ConnectionString:String;
begin
  ConnectionString :=
     'Provider=SQLOLEDB.1;Persist Security Info=False;' +
     'User ID=%s;Password=%s;Data Source=%s;Use Procedure for Prepare=1;' +
     'Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;'+
     'Tag with column collation when possible=False';

  DM.AdoConnection1.ConnectionString :=Format(ConnectionString,[usuario, senha, servidor]);
  DM.AdoConnection1.LoginPrompt := False;
end;

procedure TFrmPrincipal.ConsumirWebService;
begin
  LblParecer.Caption := GetIDelphi(false,'http://www.grupounicad.com.br/cgi-bin/portalumais/Delphi_sql_Server/Delphi_API_Teste.dll/soap/IDelphi',nil).Verifica_Idades(LblMedia.Caption);
end;

procedure TFrmPrincipal.ExcluirPessoa;
begin
   if Qry1.Eof Then
   begin
     ShowMessage('N�o h� cadastro a ser exclu�do.');
     Abort;
   end;
   if MessageDlg('Deseja Excluir '+Qry1.FieldByName('Name').AsString+'?',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0) <> mrYes then
      Abort;
   Pessoa.Excluir(Qry1.FieldByName('Id').AsInteger);
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Terminar;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
   AjustarTela;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   Iniciar;
end;

procedure TFrmPrincipal.IncluirPessoa;
begin
   frmPessoaIncluir := TfrmPessoaIncluir.Create(self);
   frmPessoaIncluir.ShowModal;
   frmPessoaIncluir.Free;
end;

procedure TFrmPrincipal.Iniciar;
begin
   if not ConectarAoBancoDados then
   begin
     showMessage('Imposs�vel conectar ao banco de dados.');
     abort;
   end;
   if not AtualizarTabelaDePessoas then
   begin
     showMessage('Imposs�vel acessar tabela de Pessoas.');
     abort;
   end;
   Pessoa := TPessoa.Create;
end;

procedure TFrmPrincipal.MostrarEstatistica;
begin
    LblQuant.Caption := Pessoa.QuantidadeFormatada;
    LblSoma.Caption  := Pessoa.SomaIdadesFormatada;
    LblMedia.Caption := Pessoa.IdadeMediaFormatada;
    ConsumirWebService;
end;

procedure TFrmPrincipal.Terminar;
begin
   FreeAndNil(Pessoa);
end;

end.


