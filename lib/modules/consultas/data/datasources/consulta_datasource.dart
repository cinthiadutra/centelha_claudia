import '../models/consulta_model.dart';

/// Datasource para operações com consultas (mock)
abstract class ConsultaDatasource {
  List<ConsultaModel> getConsultas();
  ConsultaModel? getConsultaPorNumero(String numero);
  List<ConsultaModel> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  });
  void adicionarConsulta(ConsultaModel consulta);
  String gerarProximoNumero();
}

/// Implementação mock do datasource
class ConsultaDatasourceImpl implements ConsultaDatasource {
  final List<ConsultaModel> _consultas = [
    ConsultaModel(
      id: '1',
      numeroConsulta: '00001',
      data: DateTime(2024, 12, 10),
      horaInicio: '19:30',
      cadastroConsulente: '001',
      cadastroCambono: 'M001',
      cadastroMedium: 'M002',
      nomeConsulente: 'João Silva Santos',
      nomeCambono: 'Maria Silva Santos',
      nomeMedium: 'José Oliveira',
      nomeEntidade: 'Caboclo Pena Branca',
      descricaoConsulta: 'Consulta sobre saúde e orientações espirituais. O consulente relatou dores constantes e foi orientado sobre tratamento espiritual complementar.',
      dataCriacao: DateTime(2024, 12, 10, 20, 15),
    ),
    ConsultaModel(
      id: '2',
      numeroConsulta: '00002',
      data: DateTime(2024, 12, 12),
      horaInicio: '20:00',
      cadastroConsulente: '002',
      cadastroCambono: 'M002',
      cadastroMedium: 'M001',
      nomeConsulente: 'Ana Costa Silva',
      nomeCambono: 'José Oliveira',
      nomeMedium: 'Maria Silva Santos',
      nomeEntidade: 'Preto Velho Pai João',
      descricaoConsulta: 'Orientações sobre questões familiares e desenvolvimento espiritual. Recomendadas orações e passes.',
      dataCriacao: DateTime(2024, 12, 12, 21, 30),
    ),
  ];

  @override
  List<ConsultaModel> getConsultas() => List.from(_consultas);

  @override
  ConsultaModel? getConsultaPorNumero(String numero) {
    try {
      return _consultas.firstWhere((c) => c.numeroConsulta == numero);
    } catch (e) {
      return null;
    }
  }

  @override
  List<ConsultaModel> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  }) {
    var resultado = List<ConsultaModel>.from(_consultas);

    if (cadastroConsulente != null && cadastroConsulente.isNotEmpty) {
      resultado = resultado
          .where((c) => c.cadastroConsulente == cadastroConsulente)
          .toList();
    }

    if (cadastroMedium != null && cadastroMedium.isNotEmpty) {
      resultado = resultado
          .where((c) => c.cadastroMedium == cadastroMedium)
          .toList();
    }

    if (nomeEntidade != null && nomeEntidade.isNotEmpty) {
      resultado = resultado
          .where((c) => c.nomeEntidade == nomeEntidade)
          .toList();
    }

    return resultado;
  }

  @override
  void adicionarConsulta(ConsultaModel consulta) {
    _consultas.add(consulta);
  }

  @override
  String gerarProximoNumero() {
    if (_consultas.isEmpty) {
      return '00001';
    }

    // Pega o maior número e incrementa
    final numeros = _consultas.map((c) => int.parse(c.numeroConsulta)).toList();
    final maiorNumero = numeros.reduce((a, b) => a > b ? a : b);
    final proximoNumero = maiorNumero + 1;

    return proximoNumero.toString().padLeft(5, '0');
  }
}
