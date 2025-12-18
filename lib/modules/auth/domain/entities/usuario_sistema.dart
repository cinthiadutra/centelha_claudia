import 'package:equatable/equatable.dart';

/// Níveis de acesso do sistema
enum NivelAcesso {
  nivel1, // Membros ativos
  nivel2, // Membros da secretaria
  nivel3, // Pais e Mães de terreiro
  nivel4, // Administrador do sistema
}

/// Entidade de Usuário do Sistema (não confundir com cadastro de membros)
class UsuarioSistema extends Equatable {
  final String id;
  final String nome;
  final String login;
  final String email;
  final NivelAcesso nivelAcesso;
  final bool ativo;
  final DateTime? ultimoAcesso;

  const UsuarioSistema({
    required this.id,
    required this.nome,
    required this.login,
    required this.email,
    required this.nivelAcesso,
    this.ativo = true,
    this.ultimoAcesso,
  });

  String get nivelAcessoDescricao {
    switch (nivelAcesso) {
      case NivelAcesso.nivel1:
        return 'Membro Ativo';
      case NivelAcesso.nivel2:
        return 'Membro da Secretaria';
      case NivelAcesso.nivel3:
        return 'Pai/Mãe de Terreiro';
      case NivelAcesso.nivel4:
        return 'Administrador';
    }
  }

  bool temPermissao(NivelAcesso nivelRequerido) {
    return nivelAcesso.index >= nivelRequerido.index;
  }

  @override
  List<Object?> get props => [id, nome, login, email, nivelAcesso, ativo, ultimoAcesso];
}
