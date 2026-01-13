import 'package:equatable/equatable.dart';

class RegistroPonto extends Equatable {
  final String? id;
  final String membroId;
  final String membroNome;
  final DateTime dataHora;
  final TipoPonto tipo;
  final String? localizacao;
  final String? observacao;
  final String? justificativa;
  final bool manual; // Se foi registrado manualmente ou pelo sistema
  final String? registradoPor; // ID do usuário que registrou (caso manual)
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  const RegistroPonto({
    this.id,
    required this.membroId,
    required this.membroNome,
    required this.dataHora,
    required this.tipo,
    this.localizacao,
    this.observacao,
    this.justificativa,
    this.manual = false,
    this.registradoPor,
    this.criadoEm,
    this.atualizadoEm,
  });

  @override
  List<Object?> get props => [
        id,
        membroId,
        membroNome,
        dataHora,
        tipo,
        localizacao,
        observacao,
        justificativa,
        manual,
        registradoPor,
        criadoEm,
        atualizadoEm,
      ];

  RegistroPonto copyWith({
    String? id,
    String? membroId,
    String? membroNome,
    DateTime? dataHora,
    TipoPonto? tipo,
    String? localizacao,
    String? observacao,
    String? justificativa,
    bool? manual,
    String? registradoPor,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return RegistroPonto(
      id: id ?? this.id,
      membroId: membroId ?? this.membroId,
      membroNome: membroNome ?? this.membroNome,
      dataHora: dataHora ?? this.dataHora,
      tipo: tipo ?? this.tipo,
      localizacao: localizacao ?? this.localizacao,
      observacao: observacao ?? this.observacao,
      justificativa: justificativa ?? this.justificativa,
      manual: manual ?? this.manual,
      registradoPor: registradoPor ?? this.registradoPor,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

enum TipoPonto {
  entrada,
  saida,
  entradaAlmoco,
  saidaAlmoco,
}
