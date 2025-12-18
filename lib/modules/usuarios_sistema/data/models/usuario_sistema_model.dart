import '../../domain/entities/usuario_sistema.dart';

/// Model para serialização/deserialização de UsuarioSistema
class UsuarioSistemaModel extends UsuarioSistema {
  const UsuarioSistemaModel({
    required super.id,
    required super.numeroCadastro,
    required super.nome,
    required super.email,
    required super.senha,
    required super.nivelPermissao,
    required super.ativo,
    required super.dataCriacao,
    super.dataUltimaAlteracao,
    super.observacoes,
  });

  factory UsuarioSistemaModel.fromEntity(UsuarioSistema entity) {
    return UsuarioSistemaModel(
      id: entity.id,
      numeroCadastro: entity.numeroCadastro,
      nome: entity.nome,
      email: entity.email,
      senha: entity.senha,
      nivelPermissao: entity.nivelPermissao,
      ativo: entity.ativo,
      dataCriacao: entity.dataCriacao,
      dataUltimaAlteracao: entity.dataUltimaAlteracao,
      observacoes: entity.observacoes,
    );
  }

  factory UsuarioSistemaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioSistemaModel(
      id: json['id'] as String,
      numeroCadastro: json['numeroCadastro'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      nivelPermissao: json['nivelPermissao'] as int,
      ativo: json['ativo'] as bool,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataUltimaAlteracao: json['dataUltimaAlteracao'] != null
          ? DateTime.parse(json['dataUltimaAlteracao'] as String)
          : null,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroCadastro': numeroCadastro,
      'nome': nome,
      'email': email,
      'senha': senha,
      'nivelPermissao': nivelPermissao,
      'ativo': ativo,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
      'observacoes': observacoes,
    };
  }
}
