import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/calendario.dart';

/// Modelo para importar calendário do JSON
class CalendarioImportModel {
  final String data;
  final String? diaSessao;
  final String? tipoAtividade;
  final String? observacoes;

  CalendarioImportModel({
    required this.data,
    this.diaSessao,
    this.tipoAtividade,
    this.observacoes,
  });

  factory CalendarioImportModel.fromJson(Map<String, dynamic> json) {
    return CalendarioImportModel(
      data: json['data']?.toString() ?? '',
      diaSessao: json['dia_sessao']?.toString(),
      tipoAtividade: json['tipo_atividade']?.toString(),
      observacoes: json['observacoes']?.toString(),
    );
  }

  /// Converte para AtividadeCalendario do domínio
  AtividadeCalendario? toEntity() {
    try {
      // Parse da data (formato esperado: DD/MM/YYYY ou YYYY-MM-DD)
      final DateTime dataAtividade = _parseData(data);

      // Determinar tipo de atividade
      final TipoAtividadeCalendario tipo = _parseTipo(tipoAtividade, diaSessao);

      // Criar descrição
      final String descricao = _criarDescricao(tipo, diaSessao, observacoes);

      return AtividadeCalendario(
        data: dataAtividade,
        tipo: tipo,
        descricao: descricao,
        diaSessao: diaSessao,
        realizada: true, // Será atualizado conforme acontece
      );
    } catch (e) {
      print('Erro ao converter atividade: $e');
      return null;
    }
  }

  String _criarDescricao(
    TipoAtividadeCalendario tipo,
    String? diaSessao,
    String? observacoes,
  ) {
    final parts = <String>[];

    // Adicionar tipo
    switch (tipo) {
      case TipoAtividadeCalendario.sessaoMedianica:
        parts.add('Sessão Mediúnica');
        break;
      case TipoAtividadeCalendario.atendimentoPublico:
        parts.add('Atendimento Público');
        break;
      case TipoAtividadeCalendario.correnteOracaoRenovacao:
        parts.add('Corrente de Oração e Renovação');
        break;
      case TipoAtividadeCalendario.encontroRamatis:
        parts.add('Encontro dos Amigos de Ramatis');
        break;
      case TipoAtividadeCalendario.grupoTrabalhoEspiritual:
        parts.add('Grupo de Trabalho Espiritual');
        break;
      case TipoAtividadeCalendario.cambonagem:
        parts.add('Escala de Cambonagem');
        break;
      case TipoAtividadeCalendario.arrumacao:
        parts.add('Escala de Arrumação');
        break;
      case TipoAtividadeCalendario.desarrumacao:
        parts.add('Escala de Desarrumação');
        break;
      default:
        parts.add('Atividade');
    }

    // Adicionar dia de sessão se houver
    if (diaSessao != null && diaSessao.isNotEmpty) {
      parts.add('- $diaSessao');
    }

    // Adicionar observações se houver
    if (observacoes != null && observacoes.isNotEmpty) {
      parts.add('($observacoes)');
    }

    return parts.join(' ');
  }

  DateTime _parseData(String dataStr) {
    // Remover espaços
    dataStr = dataStr.trim();

    // Tentar formato DD/MM/YYYY
    if (dataStr.contains('/')) {
      final parts = dataStr.split('/');
      if (parts.length == 3) {
        final dia = int.parse(parts[0]);
        final mes = int.parse(parts[1]);
        final ano = int.parse(parts[2]);
        return DateTime(ano, mes, dia);
      }
    }

    // Tentar formato YYYY-MM-DD
    if (dataStr.contains('-')) {
      return DateTime.parse(dataStr);
    }

    throw FormatException('Formato de data inválido: $dataStr');
  }

  TipoAtividadeCalendario _parseTipo(String? tipo, String? diaSessao) {
    if (tipo == null && diaSessao == null) {
      return TipoAtividadeCalendario.outra;
    }

    final tipoLower = (tipo ?? '').toLowerCase();
    final diaLower = (diaSessao ?? '').toLowerCase();

    // Identificar por palavras-chave
    if (tipoLower.contains('sessão') ||
        tipoLower.contains('sessao') ||
        diaLower.contains('terça') ||
        diaLower.contains('terca') ||
        diaLower.contains('quarta') ||
        diaLower.contains('sexta') ||
        diaLower.contains('sábado') ||
        diaLower.contains('sabado')) {
      return TipoAtividadeCalendario.sessaoMedianica;
    }

    if (tipoLower.contains('atendimento público') ||
        tipoLower.contains('atendimento publico') ||
        tipoLower.contains('público') ||
        tipoLower.contains('publico')) {
      return TipoAtividadeCalendario.atendimentoPublico;
    }

    if (tipoLower.contains('cor') ||
        tipoLower.contains('corrente') ||
        tipoLower.contains('oração') ||
        tipoLower.contains('oracao')) {
      return TipoAtividadeCalendario.correnteOracaoRenovacao;
    }

    if (tipoLower.contains('ramatis') || tipoLower.contains('ramati')) {
      return TipoAtividadeCalendario.encontroRamatis;
    }

    if (tipoLower.contains('grupo') ||
        tipoLower.contains('trabalho espiritual')) {
      return TipoAtividadeCalendario.grupoTrabalhoEspiritual;
    }

    if (tipoLower.contains('cambonagem') || tipoLower.contains('cambono')) {
      return TipoAtividadeCalendario.cambonagem;
    }

    if (tipoLower.contains('arrumação') ||
        tipoLower.contains('arrumacao') ||
        tipoLower.contains('desarrumação') ||
        tipoLower.contains('desarrumacao')) {
      return tipoLower.contains('des')
          ? TipoAtividadeCalendario.desarrumacao
          : TipoAtividadeCalendario.arrumacao;
    }

    if (tipoLower.contains('antigoécia') || tipoLower.contains('antigoecia')) {
      return TipoAtividadeCalendario
          .outra; // Pode criar um tipo específico se necessário
    }

    return TipoAtividadeCalendario.outra;
  }
}

/// Serviço para importar calendário do JSON
class CalendarioImportService {
  /// Carrega calendário do arquivo JSON
  Future<List<AtividadeCalendario>> carregarDeJson(String jsonPath) async {
    try {
      // Carregar arquivo JSON
      final String jsonString = await rootBundle.loadString(jsonPath);
      final dynamic jsonData = json.decode(jsonString);

      // Parse das atividades
      final List<AtividadeCalendario> atividades = [];

      if (jsonData is Map<String, dynamic>) {
        // Verificar se tem array de atividades ou meses
        if (jsonData.containsKey('atividades')) {
          final List<dynamic> atividadesJson = jsonData['atividades'];
          for (var item in atividadesJson) {
            final model = CalendarioImportModel.fromJson(item);
            final atividade = model.toEntity();
            if (atividade != null) {
              atividades.add(atividade);
            }
          }
        } else if (jsonData.containsKey('meses')) {
          // Se estiver organizado por mês
          final Map<String, dynamic> meses = jsonData['meses'];
          for (var mesData in meses.values) {
            if (mesData is List) {
              for (var item in mesData) {
                final model = CalendarioImportModel.fromJson(item);
                final atividade = model.toEntity();
                if (atividade != null) {
                  atividades.add(atividade);
                }
              }
            }
          }
        }
      } else if (jsonData is List) {
        // JSON é uma lista direta
        for (var item in jsonData) {
          final model = CalendarioImportModel.fromJson(item);
          final atividade = model.toEntity();
          if (atividade != null) {
            atividades.add(atividade);
          }
        }
      }

      // Ordenar por data
      atividades.sort((a, b) => a.data.compareTo(b.data));

      return atividades;
    } catch (e) {
      throw Exception('Erro ao carregar calendário: $e');
    }
  }

  /// Gera relatório de atividades por tipo
  Map<TipoAtividadeCalendario, int> contarPorTipo(
    List<AtividadeCalendario> atividades,
  ) {
    final Map<TipoAtividadeCalendario, int> contagem = {};

    for (var atividade in atividades) {
      contagem[atividade.tipo] = (contagem[atividade.tipo] ?? 0) + 1;
    }

    return contagem;
  }

  /// Filtra atividades por mês
  List<AtividadeCalendario> filtrarPorMes(
    List<AtividadeCalendario> atividades,
    int mes,
    int ano,
  ) {
    return atividades.where((a) {
      return a.data.month == mes && a.data.year == ano;
    }).toList();
  }
}
