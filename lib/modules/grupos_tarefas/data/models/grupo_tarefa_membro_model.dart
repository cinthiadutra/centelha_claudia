import '../../domain/entities/grupo_tarefa_membro.dart';

/// Model para serialização/deserialização de GrupoTarefaMembro
class GrupoTarefaMembroModel extends GrupoTarefaMembro {
  const GrupoTarefaMembroModel({
    super.id,
    required super.numeroCadastro,
    required super.nome,
    required super.status,
    required super.grupoTarefa,
    required super.funcao,
    super.dataUltimaAlteracao,
  });

  factory GrupoTarefaMembroModel.fromEntity(GrupoTarefaMembro entity) {
    return GrupoTarefaMembroModel(
      id: entity.id,
      numeroCadastro: entity.numeroCadastro,
      nome: entity.nome,
      status: entity.status,
      grupoTarefa: entity.grupoTarefa,
      funcao: entity.funcao,
      dataUltimaAlteracao: entity.dataUltimaAlteracao,
    );
  }

  factory GrupoTarefaMembroModel.fromJson(Map<String, dynamic> json) {
    return GrupoTarefaMembroModel(
      id: json['id'] as String?,
      numeroCadastro: json['numeroCadastro'] as String,
      nome: json['nome'] as String,
      status: json['status'] as String,
      grupoTarefa: json['grupoTarefa'] as String,
      funcao: json['funcao'] as String,
      dataUltimaAlteracao: json['dataUltimaAlteracao'] != null
          ? DateTime.parse(json['dataUltimaAlteracao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroCadastro': numeroCadastro,
      'nome': nome,
      'status': status,
      'grupoTarefa': grupoTarefa,
      'funcao': funcao,
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
    };
  }
}
