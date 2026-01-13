import '../../domain/entities/registro_ponto.dart';

class RegistroPontoModel extends RegistroPonto {
  const RegistroPontoModel({
    super.id,
    required super.membroId,
    required super.membroNome,
    required super.dataHora,
    required super.tipo,
    super.localizacao,
    super.observacao,
    super.justificativa,
    super.manual,
    super.registradoPor,
    super.criadoEm,
    super.atualizadoEm,
  });

  factory RegistroPontoModel.fromJson(Map<String, dynamic> json) {
    return RegistroPontoModel(
      id: json['id']?.toString(),
      membroId: json['membro_id']?.toString() ?? '',
      membroNome: json['membro_nome']?.toString() ?? '',
      dataHora: DateTime.parse(json['data_hora']),
      tipo: _parseTipoPonto(json['tipo']),
      localizacao: json['localizacao']?.toString(),
      observacao: json['observacao']?.toString(),
      justificativa: json['justificativa']?.toString(),
      manual: json['manual'] ?? false,
      registradoPor: json['registrado_por']?.toString(),
      criadoEm: json['criado_em'] != null 
          ? DateTime.parse(json['criado_em']) 
          : null,
      atualizadoEm: json['atualizado_em'] != null 
          ? DateTime.parse(json['atualizado_em']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'membro_id': membroId,
      'membro_nome': membroNome,
      'data_hora': dataHora.toIso8601String(),
      'tipo': _tipoToString(tipo),
      if (localizacao != null) 'localizacao': localizacao,
      if (observacao != null) 'observacao': observacao,
      if (justificativa != null) 'justificativa': justificativa,
      'manual': manual,
      if (registradoPor != null) 'registrado_por': registradoPor,
      if (criadoEm != null) 'criado_em': criadoEm!.toIso8601String(),
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm!.toIso8601String(),
    };
  }

  factory RegistroPontoModel.fromEntity(RegistroPonto entity) {
    return RegistroPontoModel(
      id: entity.id,
      membroId: entity.membroId,
      membroNome: entity.membroNome,
      dataHora: entity.dataHora,
      tipo: entity.tipo,
      localizacao: entity.localizacao,
      observacao: entity.observacao,
      justificativa: entity.justificativa,
      manual: entity.manual,
      registradoPor: entity.registradoPor,
      criadoEm: entity.criadoEm,
      atualizadoEm: entity.atualizadoEm,
    );
  }

  static TipoPonto _parseTipoPonto(String? tipo) {
    switch (tipo) {
      case 'entrada':
        return TipoPonto.entrada;
      case 'saida':
        return TipoPonto.saida;
      case 'entrada_almoco':
        return TipoPonto.entradaAlmoco;
      case 'saida_almoco':
        return TipoPonto.saidaAlmoco;
      default:
        return TipoPonto.entrada;
    }
  }

  static String _tipoToString(TipoPonto tipo) {
    switch (tipo) {
      case TipoPonto.entrada:
        return 'entrada';
      case TipoPonto.saida:
        return 'saida';
      case TipoPonto.entradaAlmoco:
        return 'entrada_almoco';
      case TipoPonto.saidaAlmoco:
        return 'saida_almoco';
    }
  }
}
