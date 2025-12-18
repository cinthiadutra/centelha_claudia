import '../models/usuario_model.dart';

/// Interface do datasource de usuários
abstract class UsuarioDatasource {
  Future<List<UsuarioModel>> getUsuarios();
  Future<UsuarioModel> getUsuarioById(String id);
  Future<UsuarioModel> createUsuario(UsuarioModel usuario);
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario);
  Future<void> deleteUsuario(String id);
}

/// Implementação mockada do datasource
/// Quando a API estiver pronta, criar UsuarioDatasourceRemote
class UsuarioDatasourceMock implements UsuarioDatasource {
  final List<UsuarioModel> _usuarios = [
    UsuarioModel(
      id: '1',
      nome: 'João Silva',
      cpf: '12345678900',
      numeroCadastro: '001/2024',
      dataNascimento: DateTime(1990, 5, 15),
      telefoneFixo: '1133334444',
      telefoneCelular: '11999999999',
      email: 'joao@email.com',
      endereco: 'Rua das Flores, 123 - São Paulo/SP',
      nucleoCadastro: 'Núcleo Central',
      dataCadastro: DateTime(2024, 1, 15),
      nucleoPertence: 'Núcleo Central',
      statusAtual: 'Ativo',
      classificacao: 'Médium',
      diaSessao: 'Quarta-feira',
      dataBatismo: DateTime(2024, 3, 20),
      mediumCelebranteBatismo: 'Ana Paula',
      padrinhoBatismo: 'Carlos Alberto',
      madrinhaBatismo: 'Fernanda Costa',
      primeiroContatoEmergencia: 'Maria Silva - (11) 98888-8888',
      inicioPrimeiroEstagio: DateTime(2024, 2, 1),
      primeiroRitoPassagem: DateTime(2024, 6, 15),
      dataJogoOrixa: DateTime(2024, 7, 10),
      primeiroOrixa: 'Oxalá',
      segundoOrixa: 'Iemanjá',
      atividadeEspiritual: 'Desenvolvimento Mediúnico',
      grupoAtividadeEspiritual: 'Grupo Estrela',
    ),
    UsuarioModel(
      id: '2',
      nome: 'Maria Santos',
      cpf: '98765432100',
      numeroCadastro: '002/2024',
      dataNascimento: DateTime(1985, 8, 22),
      telefoneFixo: '1144445555',
      telefoneCelular: '11988888888',
      email: 'maria@email.com',
      endereco: 'Av. Paulista, 1000 - São Paulo/SP',
      nucleoCadastro: 'Núcleo Sul',
      dataCadastro: DateTime(2024, 2, 20),
      nucleoPertence: 'Núcleo Sul',
      statusAtual: 'Ativo',
      classificacao: 'Consulente',
      diaSessao: 'Segunda-feira',
      primeiroContatoEmergencia: 'Pedro Santos - (11) 97777-7777',
      inicioPrimeiroEstagio: DateTime(2024, 3, 1),
    ),
  ];

  @override
  Future<List<UsuarioModel>> getUsuarios() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_usuarios);
  }

  @override
  Future<UsuarioModel> getUsuarioById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _usuarios.firstWhere((u) => u.id == id);
    } catch (e) {
      throw Exception('Usuário não encontrado');
    }
  }

  @override
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Gera um ID e número de cadastro mock
    final novoId = ((_usuarios.length + 1).toString());
    final ano = DateTime.now().year;
    final numeroSequencial = _usuarios.length + 1;
    final numeroCadastro = '${numeroSequencial.toString().padLeft(3, '0')}/$ano';
    
    final novoUsuario = UsuarioModel(
      id: novoId,
      nome: usuario.nome,
      cpf: usuario.cpf,
      numeroCadastro: numeroCadastro,
      dataNascimento: usuario.dataNascimento,
      telefoneFixo: usuario.telefoneFixo,
      telefoneCelular: usuario.telefoneCelular,
      email: usuario.email,
      nomeResponsavel: usuario.nomeResponsavel,
      endereco: usuario.endereco,
      nucleoCadastro: usuario.nucleoCadastro,
      dataCadastro: usuario.dataCadastro ?? DateTime.now(),
      nucleoPertence: usuario.nucleoPertence,
      statusAtual: usuario.statusAtual,
      classificacao: usuario.classificacao,
      diaSessao: usuario.diaSessao,
      dataBatismo: usuario.dataBatismo,
      mediumCelebranteBatismo: usuario.mediumCelebranteBatismo,
      guiaCelebranteBatismo: usuario.guiaCelebranteBatismo,
      padrinhoBatismo: usuario.padrinhoBatismo,
      madrinhaBatismo: usuario.madrinhaBatismo,
      dataPrimeiroCasamento: usuario.dataPrimeiroCasamento,
      nomePrimeiroConjuge: usuario.nomePrimeiroConjuge,
      mediumCelebrantePrimeiroCasamento: usuario.mediumCelebrantePrimeiroCasamento,
      padrinhoPrimeiroCasamento: usuario.padrinhoPrimeiroCasamento,
      madrinhaPrimeiroCasamento: usuario.madrinhaPrimeiroCasamento,
      dataSegundoCasamento: usuario.dataSegundoCasamento,
      nomeSegundoConjuge: usuario.nomeSegundoConjuge,
      mediumCelebranteSegundoCasamento: usuario.mediumCelebranteSegundoCasamento,
      padrinhoSegundoCasamento: usuario.padrinhoSegundoCasamento,
      madrinhaSegundoCasamento: usuario.madrinhaSegundoCasamento,
      primeiroContatoEmergencia: usuario.primeiroContatoEmergencia,
      segundoContatoEmergencia: usuario.segundoContatoEmergencia,
      inicioPrimeiroEstagio: usuario.inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio: usuario.desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: usuario.primeiroRitoPassagem,
      dataPrimeiroDesligamento: usuario.dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento: usuario.justificativaPrimeiroDesligamento,
      inicioSegundoEstagio: usuario.inicioSegundoEstagio,
      desistenciaSegundoEstagio: usuario.desistenciaSegundoEstagio,
      segundoRitoPassagem: usuario.segundoRitoPassagem,
      dataSegundoDesligamento: usuario.dataSegundoDesligamento,
      justificativaSegundoDesligamento: usuario.justificativaSegundoDesligamento,
      inicioTerceiroEstagio: usuario.inicioTerceiroEstagio,
      desistenciaTerceiroEstagio: usuario.desistenciaTerceiroEstagio,
      terceiroRitoPassagem: usuario.terceiroRitoPassagem,
      dataTerceiroDesligamento: usuario.dataTerceiroDesligamento,
      justificativaTerceiroDesligamento: usuario.justificativaTerceiroDesligamento,
      inicioQuartoEstagio: usuario.inicioQuartoEstagio,
      desistenciaQuartoEstagio: usuario.desistenciaQuartoEstagio,
      quartoRitoPassagem: usuario.quartoRitoPassagem,
      dataQuartoDesligamento: usuario.dataQuartoDesligamento,
      justificativaQuartoDesligamento: usuario.justificativaQuartoDesligamento,
      dataJogoOrixa: usuario.dataJogoOrixa,
      primeiroOrixa: usuario.primeiroOrixa,
      adjuntoPrimeiroOrixa: usuario.adjuntoPrimeiroOrixa,
      segundoOrixa: usuario.segundoOrixa,
      adjuntoSegundoOrixa: usuario.adjuntoSegundoOrixa,
      terceiroOrixa: usuario.terceiroOrixa,
      quartoOrixa: usuario.quartoOrixa,
      coroacaoSacerdote: usuario.coroacaoSacerdote,
      primeiraCamarinha: usuario.primeiraCamarinha,
      segundaCamarinha: usuario.segundaCamarinha,
      terceiraCamarinha: usuario.terceiraCamarinha,
      atividadeEspiritual: usuario.atividadeEspiritual,
      grupoAtividadeEspiritual: usuario.grupoAtividadeEspiritual,
      grupoTarefa: usuario.grupoTarefa,
      grupoAcaoSocial: usuario.grupoAcaoSocial,
      cargoLideranca: usuario.cargoLideranca,
    );
    
    _usuarios.add(novoUsuario);
    return novoUsuario;
  }

  @override
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index == -1) {
      throw Exception('Usuário não encontrado');
    }
    
    _usuarios[index] = usuario;
    return usuario;
  }

  @override
  Future<void> deleteUsuario(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _usuarios.removeWhere((u) => u.id == id);
  }
}
