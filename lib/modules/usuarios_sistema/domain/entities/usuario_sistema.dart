import 'package:equatable/equatable.dart';

/// Entidade que representa um usuário do sistema
/// Diferente do Usuario (cadastro geral), este é para acesso ao sistema
class UsuarioSistema extends Equatable {
  final String id;
  final String numeroCadastro; // Link com cadastro de membro
  final String nome;
  final String email;
  final String senha; // Em produção, deve ser hash
  final int nivelPermissao; // 1, 2, 3 ou 4
  final bool ativo;
  final DateTime dataCriacao;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const UsuarioSistema({
    required this.id,
    required this.numeroCadastro,
    required this.nome,
    required this.email,
    required this.senha,
    required this.nivelPermissao,
    required this.ativo,
    required this.dataCriacao,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        numeroCadastro,
        nome,
        email,
        senha,
        nivelPermissao,
        ativo,
        dataCriacao,
        dataUltimaAlteracao,
        observacoes,
      ];

  UsuarioSistema copyWith({
    String? id,
    String? numeroCadastro,
    String? nome,
    String? email,
    String? senha,
    int? nivelPermissao,
    bool? ativo,
    DateTime? dataCriacao,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return UsuarioSistema(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      nivelPermissao: nivelPermissao ?? this.nivelPermissao,
      ativo: ativo ?? this.ativo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  String get nivelPermissaoTexto {
    switch (nivelPermissao) {
      case 1:
        return 'Nível 1 - Acesso próprio';
      case 2:
        return 'Nível 2 - Secretaria';
      case 3:
        return 'Nível 3 - Líder espiritual';
      case 4:
        return 'Nível 4 - Administrador';
      default:
        return 'Nível desconhecido';
    }
  }
}
