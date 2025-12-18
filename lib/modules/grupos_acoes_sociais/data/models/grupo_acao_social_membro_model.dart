import '../../domain/entities/grupo_acao_social_membro.dart';

/// Model para serialização/deserialização de GrupoAcaoSocialMembro
class GrupoAcaoSocialMembroModel extends GrupoAcaoSocialMembro {
  const GrupoAcaoSocialMembroModel({
    required super.numeroCadastro,
    required super.nome,
    required super.status,
    required super.grupoAcaoSocial,
    required super.funcao,
    super.dataUltimaAlteracao,
  });

  factory GrupoAcaoSocialMembroModel.fromEntity(GrupoAcaoSocialMembro entity) {
    return GrupoAcaoSocialMembroModel(
      numeroCadastro: entity.numeroCadastro,
      nome: entity.nome,
      status: entity.status,
      grupoAcaoSocial: entity.grupoAcaoSocial,
      funcao: entity.funcao,
      dataUltimaAlteracao: entity.dataUltimaAlteracao,
    );
  }

  factory GrupoAcaoSocialMembroModel.fromJson(Map<String, dynamic> json) {
    return GrupoAcaoSocialMembroModel(
      numeroCadastro: json['numeroCadastro'] as String,
      nome: json['nome'] as String,
      status: json['status'] as String,
      grupoAcaoSocial: json['grupoAcaoSocial'] as String,
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
      'grupoAcaoSocial': grupoAcaoSocial,
      'funcao': funcao,
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
    };
  }
}
