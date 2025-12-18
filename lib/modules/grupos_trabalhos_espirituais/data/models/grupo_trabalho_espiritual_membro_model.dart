import '../../domain/entities/grupo_trabalho_espiritual_membro.dart';

/// Model para serialização/deserialização de GrupoTrabalhoEspiritualMembro
class GrupoTrabalhoEspiritualMembroModel extends GrupoTrabalhoEspiritualMembro {
  const GrupoTrabalhoEspiritualMembroModel({
    required super.numeroCadastro,
    required super.nome,
    required super.status,
    required super.atividadeEspiritual,
    required super.grupoTrabalho,
    required super.funcao,
    super.dataUltimaAlteracao,
  });

  factory GrupoTrabalhoEspiritualMembroModel.fromJson(Map<String, dynamic> json) {
    return GrupoTrabalhoEspiritualMembroModel(
      numeroCadastro: json['numeroCadastro'] as String,
      nome: json['nome'] as String,
      status: json['status'] as String,
      atividadeEspiritual: json['atividadeEspiritual'] as String,
      grupoTrabalho: json['grupoTrabalho'] as String,
      funcao: json['funcao'] as String,
      dataUltimaAlteracao: json['dataUltimaAlteracao'] != null
          ? DateTime.parse(json['dataUltimaAlteracao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroCadastro': numeroCadastro,
      'nome': nome,
      'status': status,
      'atividadeEspiritual': atividadeEspiritual,
      'grupoTrabalho': grupoTrabalho,
      'funcao': funcao,
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
    };
  }

  factory GrupoTrabalhoEspiritualMembroModel.fromEntity(GrupoTrabalhoEspiritualMembro entity) {
    return GrupoTrabalhoEspiritualMembroModel(
      numeroCadastro: entity.numeroCadastro,
      nome: entity.nome,
      status: entity.status,
      atividadeEspiritual: entity.atividadeEspiritual,
      grupoTrabalho: entity.grupoTrabalho,
      funcao: entity.funcao,
      dataUltimaAlteracao: entity.dataUltimaAlteracao,
    );
  }
}
