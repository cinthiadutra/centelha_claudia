import '../models/organizacao_centelha_model.dart';

/// Interface do datasource de organização
abstract class OrganizacaoCentelhaDatasource {
  Future<void> atualizar(OrganizacaoCentelhaModel organizacao);
  Future<OrganizacaoCentelhaModel> getOrganizacao();
}

/// Implementação mock do datasource
/// Na prática, deve haver apenas uma organização
class OrganizacaoCentelhaDatasourceImpl implements OrganizacaoCentelhaDatasource {
  OrganizacaoCentelhaModel _organizacao = OrganizacaoCentelhaModel(
    id: '1',
    nome: 'CENTELHA - Centro Espírita',
    cnpj: '00.000.000/0001-00',
    endereco: 'Rua Principal, 123',
    cidade: 'São Paulo',
    estado: 'SP',
    cep: '01234-567',
    telefone: '(11) 1234-5678',
    email: 'contato@centelha.org',
    siteWeb: 'www.centelha.org',
    presidenteNome: 'João Silva',
    presidenteCadastro: '00001',
    vicepresidenteNome: 'Maria Santos',
    vicepresidenteCadastro: '00002',
    secretarioNome: 'Pedro Oliveira',
    secretarioCadastro: '00003',
    tesoureiroNome: 'Ana Costa',
    tesoureiroCadastro: '00004',
    dataFundacao: DateTime(2000, 1, 1),
    observacoes: 'Organização dedicada ao estudo e prática da doutrina espírita',
  );

  @override
  Future<void> atualizar(OrganizacaoCentelhaModel organizacao) async {
    _organizacao = organizacao;
  }

  @override
  Future<OrganizacaoCentelhaModel> getOrganizacao() async {
    return _organizacao;
  }
}
