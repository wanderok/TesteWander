object DM: TDM
  OldCreateOrder = False
  Height = 108
  Width = 124
  object AdoConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=prova_d' +
      'elphi;Initial Catalog=Teste;Data Source=bancobi.grupounicad.com.' +
      'br,1433;Initial File Name="";Server SPN=""'
    ConnectionTimeout = 30
    DefaultDatabase = 'Teste'
    IsolationLevel = ilChaos
    Provider = 'SQLNCLI11.1'
    Left = 39
    Top = 22
  end
end
