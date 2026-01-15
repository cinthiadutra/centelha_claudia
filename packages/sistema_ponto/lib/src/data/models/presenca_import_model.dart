import '../../domain/entities/presenca_registro.dart';

/// Modelo para importar registros de presença de arquivo CSV/TXT
class PresencaImportModel {
  final int raNumero;
  final String codigoNome; // Ex: "0498-THAYANA"
  final String departamento;
  final DateTime dataHora;
  final int maquinaNumero;

  PresencaImportModel({
    required this.raNumero,
    required this.codigoNome,
    required this.departamento,
    required this.dataHora,
    required this.maquinaNumero,
  });

  /// Parse de linha CSV: ra. No.;Nome;dept.;Tempo;Máquina No.
  /// Exemplo: 29;0498-THAYANA;Not Set1; 01/08/2025     17:38:10;1
  factory PresencaImportModel.fromCsvRow(List<dynamic> row) {
    if (row.length < 5) {
      throw FormatException(
          'Linha CSV inválida: ${row.length} colunas encontradas (esperado 5)');
    }

    try {
      final raNumero = int.parse(row[0].toString().trim());
      final codigoNome = row[1].toString().trim();
      final departamento = row[2].toString().trim();
      final tempoStr = row[3].toString().trim();
      final maquinaNumero = int.parse(row[4].toString().trim());

      // Parse data/hora: " 01/08/2025     17:38:10"
      final dataHora = _parseDataHora(tempoStr);

      return PresencaImportModel(
        raNumero: raNumero,
        codigoNome: codigoNome,
        departamento: departamento,
        dataHora: dataHora,
        maquinaNumero: maquinaNumero,
      );
    } catch (e) {
      throw FormatException('Erro ao parsear linha CSV: $e\nDados: $row');
    }
  }

  /// Extrai código do formato "CODIGO-NOME"
  String get codigo {
    if (codigoNome.contains('-')) {
      return codigoNome.split('-').first.trim();
    }
    // Alguns podem estar no formato "NOMECODIGO"
    final match = RegExp(r'(\d+)').firstMatch(codigoNome);
    return match?.group(0) ?? '';
  }

  /// Apenas a data (sem hora)
  DateTime get dataApenas {
    return DateTime(dataHora.year, dataHora.month, dataHora.day);
  }

  /// Extrai nome do formato "CODIGO-NOME"
  String get nome {
    if (codigoNome.contains('-')) {
      return codigoNome.split('-').last.trim();
    }
    // Remove números do início
    return codigoNome.replaceAll(RegExp(r'^\d+'), '').trim();
  }

  /// Converte para entidade de domínio
  PresencaRegistro toEntity({
    required String membroId,
    required String atividadeId,
  }) {
    return PresencaRegistro(
      membroId: membroId,
      atividadeId: atividadeId,
      dataHora: dataHora,
      presente: true,
      codigo: codigo,
      nomeRegistrado: nome,
    );
  }

  @override
  String toString() {
    return 'PresencaImportModel(ra: $raNumero, codigo: $codigo, nome: $nome, data: ${dataHora.toString()})';
  }

  static DateTime _parseDataHora(String tempoStr) {
    // Formato: " 01/08/2025     17:38:10"
    final cleaned = tempoStr.trim();
    final parts = cleaned.split(RegExp(r'\s+'));

    if (parts.length < 2) {
      throw FormatException('Formato de tempo inválido: $tempoStr');
    }

    final dataPart = parts[0]; // "01/08/2025"
    final horaPart = parts[1]; // "17:38:10"

    // Parse data DD/MM/YYYY
    final dateParts = dataPart.split('/');
    if (dateParts.length != 3) {
      throw FormatException('Formato de data inválido: $dataPart');
    }

    final dia = int.parse(dateParts[0]);
    final mes = int.parse(dateParts[1]);
    final ano = int.parse(dateParts[2]);

    // Parse hora HH:MM:SS
    final timeParts = horaPart.split(':');
    if (timeParts.length != 3) {
      throw FormatException('Formato de hora inválido: $horaPart');
    }

    final hora = int.parse(timeParts[0]);
    final minuto = int.parse(timeParts[1]);
    final segundo = int.parse(timeParts[2]);

    return DateTime(ano, mes, dia, hora, minuto, segundo);
  }
}
