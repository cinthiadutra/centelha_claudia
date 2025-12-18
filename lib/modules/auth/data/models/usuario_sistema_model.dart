import '../../domain/entities/usuario_sistema.dart';

class UsuarioSistemaModel extends UsuarioSistema {
  const UsuarioSistemaModel({
    required super.id,
    required super.nome,
    required super.login,
    required super.email,
    required super.nivelAcesso,
    super.ativo,
    super.ultimoAcesso,
  });

  factory UsuarioSistemaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioSistemaModel(
      id: json['id'],
      nome: json['nome'],
      login: json['login'],
      email: json['email'],
      nivelAcesso: NivelAcesso.values[json['nivelAcesso']],
      ativo: json['ativo'] ?? true,
      ultimoAcesso: json['ultimoAcesso'] != null
          ? DateTime.parse(json['ultimoAcesso'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'login': login,
      'email': email,
      'nivelAcesso': nivelAcesso.index,
      'ativo': ativo,
      'ultimoAcesso': ultimoAcesso?.toIso8601String(),
    };
  }
}
