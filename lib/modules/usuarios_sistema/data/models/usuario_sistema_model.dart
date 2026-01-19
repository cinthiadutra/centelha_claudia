import '../../domain/entities/usuario_sistema.dart';

/// Model para serialização/deserialização de UsuarioSistema
class UsuarioSistemaModel extends UsuarioSistema {
  const UsuarioSistemaModel({
    required super.id,
    required super.numeroCadastro,
    required super.nome,
    super.username,
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
      username: entity.username,
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
      numeroCadastro: (json['numero_cadastro'] as String?) ?? '',
      nome: json['nome'] as String,
      username: json['username'] as String?,
      email: json['email'] as String,
      senha: (json['senha_hash'] as String?) ?? '',
      nivelPermissao: json['nivel_permissao'] as int,
      ativo: json['ativo'] as bool? ?? true,
      dataCriacao: DateTime.parse(json['created_at'] as String),
      dataUltimaAlteracao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_cadastro': numeroCadastro,
      'nome': nome,
      'username': username,
      'email': email,
      'senha_hash': senha,
      'nivel_permissao': nivelPermissao,
      'ativo': ativo,
      'created_at': dataCriacao.toIso8601String(),
      'updated_at': dataUltimaAlteracao?.toIso8601String(),
      'observacoes': observacoes,
    };
  }
}
