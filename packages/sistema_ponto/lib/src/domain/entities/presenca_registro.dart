import 'package:equatable/equatable.dart';

/// Atividade do calendário 2026
class AtividadeCalendario2026 extends Equatable {
  final String? id;
  final String data; // Ex: "26-1-1" (formato do banco)
  final String? diaSemana; // Ex: "QUINTA-FEIRA"
  final String? nucleo; // Ex: "CCU", "CPO"
  final String? inicio; // Ex: "19h00"
  final String? atividade; // Ex: "Sessão de Festa de Oxóssi"
  final String? vibracoes;
  final String? responsavel;
  final String? gruposTrabalho;
  final int? vibracaoNumero;

  const AtividadeCalendario2026({
    this.id,
    required this.data,
    this.diaSemana,
    this.nucleo,
    this.inicio,
    this.atividade,
    this.vibracoes,
    this.responsavel,
    this.gruposTrabalho,
    this.vibracaoNumero,
  });

  /// Parse data do formato "26-1-1" para DateTime
  DateTime? get dataAsDateTime {
    try {
      final parts = data.split('-');
      if (parts.length != 3) return null;
      
      final ano = int.parse(parts[0]) + 2000; // 26 -> 2026
      final mes = int.parse(parts[1]);
      final dia = int.parse(parts[2]);
      
      return DateTime(ano, mes, dia);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        data,
        diaSemana,
        nucleo,
        inicio,
        atividade,
        vibracoes,
        responsavel,
        gruposTrabalho,
        vibracaoNumero,
      ];
}

/// Entidade representando um registro de presença
class PresencaRegistro extends Equatable {
  final String? id;
  final String membroId;
  final String atividadeId;
  final DateTime dataHora;
  final bool presente;
  final String? codigo; // Código do membro no sistema de ponto
  final String? nomeRegistrado; // Nome como aparece no registro
  final String? justificativa;

  const PresencaRegistro({
    this.id,
    required this.membroId,
    required this.atividadeId,
    required this.dataHora,
    required this.presente,
    this.codigo,
    this.nomeRegistrado,
    this.justificativa,
  });

  @override
  List<Object?> get props => [
        id,
        membroId,
        atividadeId,
        dataHora,
        presente,
        codigo,
        nomeRegistrado,
        justificativa,
      ];

  PresencaRegistro copyWith({
    String? id,
    String? membroId,
    String? atividadeId,
    DateTime? dataHora,
    bool? presente,
    String? codigo,
    String? nomeRegistrado,
    String? justificativa,
  }) {
    return PresencaRegistro(
      id: id ?? this.id,
      membroId: membroId ?? this.membroId,
      atividadeId: atividadeId ?? this.atividadeId,
      dataHora: dataHora ?? this.dataHora,
      presente: presente ?? this.presente,
      codigo: codigo ?? this.codigo,
      nomeRegistrado: nomeRegistrado ?? this.nomeRegistrado,
      justificativa: justificativa ?? this.justificativa,
    );
  }
}
