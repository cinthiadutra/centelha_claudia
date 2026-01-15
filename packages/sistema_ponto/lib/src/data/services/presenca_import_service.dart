import 'dart:convert';

import 'package:csv/csv.dart';

import '../models/presenca_import_model.dart';

/// Serviço para importar registros de presença de arquivos CSV/TXT
class PresencaImportService {
  /// Agrupa registros por data
  Map<DateTime, List<PresencaImportModel>> agruparPorData(
    List<PresencaImportModel> registros,
  ) {
    final Map<DateTime, List<PresencaImportModel>> agrupados = {};

    for (var registro in registros) {
      final data = registro.dataApenas;

      if (!agrupados.containsKey(data)) {
        agrupados[data] = [];
      }

      agrupados[data]!.add(registro);
    }

    return agrupados;
  }

  /// Agrupa registros por nome/código
  Map<String, List<PresencaImportModel>> agruparPorMembro(
    List<PresencaImportModel> registros,
  ) {
    final Map<String, List<PresencaImportModel>> agrupados = {};

    for (var registro in registros) {
      final chave = registro.codigoNome;

      if (!agrupados.containsKey(chave)) {
        agrupados[chave] = [];
      }

      agrupados[chave]!.add(registro);
    }

    return agrupados;
  }

  /// Carrega registros de presença de arquivo CSV/TXT
  ///
  /// Formato esperado: ra. No.;Nome;dept.;Tempo;Máquina No.
  /// Exemplo: 29;0498-THAYANA;Not Set1; 01/08/2025     17:38:10;1
  Future<List<PresencaImportModel>> carregarDeArquivo(
      String conteudoArquivo) async {
    try {
      // Converter para lista de linhas
      final linhas = const LineSplitter().convert(conteudoArquivo);

      if (linhas.isEmpty) {
        throw Exception('Arquivo vazio');
      }

      // Parse CSV com delimitador ;
      final csvData = const CsvToListConverter(
        fieldDelimiter: ';',
        eol: '\n',
      ).convert(conteudoArquivo);

      if (csvData.isEmpty) {
        throw Exception('Nenhum dado encontrado no arquivo');
      }

      final List<PresencaImportModel> registros = [];

      // Pular primeira linha (cabeçalho)
      for (int i = 1; i < csvData.length; i++) {
        try {
          final registro = PresencaImportModel.fromCsvRow(csvData[i]);
          registros.add(registro);
        } catch (e) {
          // Log erro mas continua processando
          print('⚠️ Erro na linha ${i + 1}: $e');
        }
      }

      if (registros.isEmpty) {
        throw Exception('Nenhum registro válido foi encontrado no arquivo');
      }

      return registros;
    } catch (e) {
      throw Exception('Erro ao processar arquivo: $e');
    }
  }

  /// Filtra registros por mês
  List<PresencaImportModel> filtrarPorMes(
    List<PresencaImportModel> registros,
    int mes,
    int ano,
  ) {
    return registros.where((r) {
      return r.dataHora.month == mes && r.dataHora.year == ano;
    }).toList();
  }

  /// Filtra registros por período
  List<PresencaImportModel> filtrarPorPeriodo(
    List<PresencaImportModel> registros,
    DateTime inicio,
    DateTime fim,
  ) {
    return registros.where((r) {
      return r.dataHora.isAfter(inicio.subtract(const Duration(days: 1))) &&
          r.dataHora.isBefore(fim.add(const Duration(days: 1)));
    }).toList();
  }

  /// Estatísticas dos registros
  Map<String, dynamic> obterEstatisticas(List<PresencaImportModel> registros) {
    if (registros.isEmpty) {
      return {
        'total': 0,
        'membros_unicos': 0,
        'datas_unicas': 0,
        'primeira_data': null,
        'ultima_data': null,
      };
    }

    final membrosUnicos = obterListaMembros(registros);
    final datas = registros.map((r) => r.dataApenas).toSet().toList()..sort();

    return {
      'total': registros.length,
      'membros_unicos': membrosUnicos.length,
      'datas_unicas': datas.length,
      'primeira_data': datas.first,
      'ultima_data': datas.last,
      'membros': membrosUnicos,
    };
  }

  /// Extrai lista única de nomes/códigos
  List<String> obterListaMembros(List<PresencaImportModel> registros) {
    final Set<String> nomes = {};

    for (var registro in registros) {
      nomes.add(registro.codigoNome);
    }

    return nomes.toList()..sort();
  }
}
