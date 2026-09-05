import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

/// Gera e salva uma planilha Excel com dados tabulares.
/// Retorna false quando o usuario cancela a escolha do arquivo.
Future<bool> exportarParaExcel({
  required String nomeArquivo,
  required String nomePlanilha,
  required List<String> cabecalhos,
  required List<List<Object?>> linhas,
}) async {
  final planilha = Excel.createExcel();
  final nomePadrao = planilha.getDefaultSheet() ?? 'Sheet1';
  final sheet = planilha[nomePlanilha];

  if (nomePlanilha != nomePadrao) {
    planilha.delete(nomePadrao);
  }

  sheet.appendRow(cabecalhos.map(_paraCelula).toList());
  for (final linha in linhas) {
    sheet.appendRow(linha.map(_paraCelula).toList());
  }

  final bytes = planilha.encode();
  if (bytes == null) {
    throw StateError('Nao foi possivel gerar o arquivo Excel.');
  }

  final nomeComExtensao = nomeArquivo.toLowerCase().endsWith('.xlsx')
      ? nomeArquivo
      : '$nomeArquivo.xlsx';

  final caminho = await FilePicker.platform.saveFile(
    dialogTitle: 'Salvar relatorio Excel',
    fileName: nomeComExtensao,
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    bytes: Uint8List.fromList(bytes),
  );

  return caminho != null;
}

CellValue _paraCelula(Object? valor) {
  if (valor == null) return TextCellValue('');
  if (valor is bool) return BoolCellValue(valor);
  if (valor is int) return IntCellValue(valor);
  if (valor is double) return DoubleCellValue(valor);
  return TextCellValue(valor.toString());
}
