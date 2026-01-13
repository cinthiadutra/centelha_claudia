import 'package:equatable/equatable.dart';

/// Atividade no calendário mensal
class AtividadeCalendario extends Equatable {
  final String? id;
  final DateTime data;
  final TipoAtividadeCalendario tipo;
  final String descricao;
  final String? diaSessao; // Terça CCU, Sábado CPO, etc.
  final String? grupoRelacionado;
  final bool realizada;
  
  const AtividadeCalendario({
    this.id,
    required this.data,
    required this.tipo,
    required this.descricao,
    this.diaSessao,
    this.grupoRelacionado,
    this.realizada = true,
  });

  @override
  List<Object?> get props => [
        id,
        data,
        tipo,
        descricao,
        diaSessao,
        grupoRelacionado,
        realizada,
      ];

  AtividadeCalendario copyWith({
    String? id,
    DateTime? data,
    TipoAtividadeCalendario? tipo,
    String? descricao,
    String? diaSessao,
    String? grupoRelacionado,
    bool? realizada,
  }) {
    return AtividadeCalendario(
      id: id ?? this.id,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      diaSessao: diaSessao ?? this.diaSessao,
      grupoRelacionado: grupoRelacionado ?? this.grupoRelacionado,
      realizada: realizada ?? this.realizada,
    );
  }
}

/// Registro de presença em uma atividade
class RegistroPresenca extends Equatable {
  final String? id;
  final String membroId;
  final String atividadeId;
  final bool presente;
  final String? justificativa;
  final bool trocouEscala; // Para cambonagem/arrumação
  
  const RegistroPresenca({
    this.id,
    required this.membroId,
    required this.atividadeId,
    required this.presente,
    this.justificativa,
    this.trocouEscala = false,
  });

  @override
  List<Object?> get props => [
        id,
        membroId,
        atividadeId,
        presente,
        justificativa,
        trocouEscala,
      ];
}

/// Tipo de atividade no calendário
enum TipoAtividadeCalendario {
  sessaoMedianica,
  atendimentoPublico,
  correnteOracaoRenovacao,
  encontroRamatis,
  grupoTrabalhoEspiritual,
  cambonagem,
  arrumacao,
  desarrumacao,
  outra,
}
