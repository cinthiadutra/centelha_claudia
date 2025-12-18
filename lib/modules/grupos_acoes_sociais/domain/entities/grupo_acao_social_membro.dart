import 'package:equatable/equatable.dart';

/// Entidade que representa a participação de um membro em um grupo de ação social
class GrupoAcaoSocialMembro extends Equatable {
  final String numeroCadastro;
  final String nome;
  final String status;
  final String grupoAcaoSocial;
  final String funcao;
  final DateTime? dataUltimaAlteracao;

  const GrupoAcaoSocialMembro({
    required this.numeroCadastro,
    required this.nome,
    required this.status,
    required this.grupoAcaoSocial,
    required this.funcao,
    this.dataUltimaAlteracao,
  });

  @override
  List<Object?> get props => [
    numeroCadastro,
    nome,
    status,
    grupoAcaoSocial,
    funcao,
    dataUltimaAlteracao,
  ];

  GrupoAcaoSocialMembro copyWith({
    String? numeroCadastro,
    String? nome,
    String? status,
    String? grupoAcaoSocial,
    String? funcao,
    DateTime? dataUltimaAlteracao,
  }) {
    return GrupoAcaoSocialMembro(
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      grupoAcaoSocial: grupoAcaoSocial ?? this.grupoAcaoSocial,
      funcao: funcao ?? this.funcao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }
}
