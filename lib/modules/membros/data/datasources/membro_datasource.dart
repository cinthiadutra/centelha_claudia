import '../../../../core/utils/string_utils.dart';
import '../models/membro_model.dart';

/// Datasource para operações com membros (mock)
abstract class MembroDatasource {
  void adicionarMembro(MembroModel membro);
  void atualizarMembro(MembroModel membro);
  MembroModel? getMembroPorCpf(String cpf);
  MembroModel? getMembroPorNumero(String numero);
  List<MembroModel> getMembros();
  List<MembroModel> pesquisarPorNome(String nome);
  void removerMembro(String numero);
}

/// Implementação mock do datasource
class MembroDatasourceImpl implements MembroDatasource {
  final List<MembroModel> _membros = [
    MembroModel(
      id: '1',
      numeroCadastro: 'M001',
      cpf: '12345678901',
      nome: 'Maria Silva Santos',
      nucleo: 'Casa Ubirajara',
      status: 'Membro ativo',
      funcao: 'Médium',
      classificacao: '4º Grau',
      diaSessao: 'Quarta-feira',
      primeiroContatoEmergencia: '(11) 98765-4321',
      segundoContatoEmergencia: '(11) 3456-7890',
      inicioPrimeiroEstagio: DateTime(2018, 3, 15),
      primeiroRitoPassagem: DateTime(2019, 6, 20),
      condicaoSegundoEstagio: 'Com restrições',
      inicioSegundoEstagio: DateTime(2019, 7, 1),
      segundoRitoPassagem: DateTime(2020, 12, 10),
      condicaoTerceiroEstagio: 'Sem restrições',
      inicioTerceiroEstagio: DateTime(2021, 1, 5),
      terceiroRitoPassagem: DateTime(2022, 8, 15),
      condicaoQuartoEstagio: 'Sem restrições',
      inicioQuartoEstagio: DateTime(2022, 9, 1),
      dataBatizado: DateTime(2018, 5, 20),
      padrinhoBatismo: 'João Pereira',
      madrinhaBatismo: 'Ana Costa',
      dataJogoOrixa: DateTime(2018, 4, 10),
      primeiraCamarinha: DateTime(2019, 11, 15),
      segundaCamarinha: DateTime(2021, 5, 20),
      atividadeEspiritual: 'Desenvolvimento mediúnico',
      grupoTrabalhoEspiritual: 'Grupo A - Terças',
      primeiroOrixa: 'Oxum',
      adjuntoPrimeiroOrixa: 'Iansã',
      segundoOrixa: 'Oxalá',
      terceiroOrixa: 'Iemanjá',
      dataCriacao: DateTime(2018, 3, 15),
      dataUltimaAlteracao: DateTime(2023, 6, 10),
    ),
    MembroModel(
      id: '2',
      numeroCadastro: 'M002',
      cpf: '98765432100',
      nome: 'José Oliveira',
      nucleo: 'Casa Pai Oxalá',
      status: 'Membro ativo',
      funcao: 'Cambono',
      classificacao: '7º Grau',
      diaSessao: 'Sexta-feira',
      primeiroContatoEmergencia: '(11) 91234-5678',
      inicioPrimeiroEstagio: DateTime(2015, 1, 10),
      primeiroRitoPassagem: DateTime(2016, 3, 15),
      condicaoSegundoEstagio: 'Sem restrições',
      inicioSegundoEstagio: DateTime(2016, 4, 1),
      segundoRitoPassagem: DateTime(2017, 9, 20),
      condicaoTerceiroEstagio: 'Sem restrições',
      inicioTerceiroEstagio: DateTime(2017, 10, 1),
      terceiroRitoPassagem: DateTime(2019, 2, 10),
      condicaoQuartoEstagio: 'Sem restrições',
      inicioQuartoEstagio: DateTime(2019, 3, 1),
      quartoRitoPassagem: DateTime(2021, 7, 15),
      dataBatizado: DateTime(2015, 4, 10),
      padrinhoBatismo: 'Carlos Souza',
      madrinhaBatismo: 'Márcia Lima',
      dataJogoOrixa: DateTime(2015, 2, 5),
      primeiraCamarinha: DateTime(2016, 8, 20),
      segundaCamarinha: DateTime(2018, 4, 15),
      terceiraCamarinha: DateTime(2020, 11, 10),
      atividadeEspiritual: 'Assistência espiritual',
      grupoTrabalhoEspiritual: 'Grupo B - Quintas',
      primeiroOrixa: 'Ogum',
      adjuntoPrimeiroOrixa: 'Xangô',
      segundoOrixa: 'Oxóssi',
      terceiroOrixa: 'Oxalá',
      quartoOrixa: 'Iemanjá',
      dataCriacao: DateTime(2015, 1, 10),
      dataUltimaAlteracao: DateTime(2023, 5, 20),
    ),
  ];

  @override
  void adicionarMembro(MembroModel membro) {
    _membros.add(membro);
  }

  @override
  void atualizarMembro(MembroModel membro) {
    final index = _membros.indexWhere((m) => m.id == membro.id);
    if (index != -1) {
      _membros[index] = membro;
    }
  }

  @override
  MembroModel? getMembroPorCpf(String cpf) {
    try {
      return _membros.firstWhere((m) => m.cpf == cpf);
    } catch (e) {
      return null;
    }
  }

  @override
  MembroModel? getMembroPorNumero(String numero) {
    try {
      return _membros.firstWhere((m) => m.numeroCadastro == numero);
    } catch (e) {
      return null;
    }
  }

  @override
  List<MembroModel> getMembros() => List.from(_membros);

  @override
  List<MembroModel> pesquisarPorNome(String nome) {
    final nomeNormalizado = normalizarParaBusca(nome);
    return _membros
        .where((m) => normalizarParaBusca(m.nome).contains(nomeNormalizado))
        .toList();
  }

  @override
  void removerMembro(String numero) {
    _membros.removeWhere((m) => m.numeroCadastro == numero);
  }
}
