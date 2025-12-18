import 'package:equatable/equatable.dart';

/// Entidade que representa a participação de um membro em um grupo de trabalho espiritual
class GrupoTrabalhoEspiritualMembro extends Equatable {
  final String numeroCadastro;
  final String nome;
  final String status;
  final String atividadeEspiritual;
  final String grupoTrabalho;
  final String funcao;
  final DateTime? dataUltimaAlteracao;

  const GrupoTrabalhoEspiritualMembro({
    required this.numeroCadastro,
    required this.nome,
    required this.status,
    required this.atividadeEspiritual,
    required this.grupoTrabalho,
    required this.funcao,
    this.dataUltimaAlteracao,
  });

  @override
  List<Object?> get props => [
        numeroCadastro,
        nome,
        status,
        atividadeEspiritual,
        grupoTrabalho,
        funcao,
        dataUltimaAlteracao,
      ];

  GrupoTrabalhoEspiritualMembro copyWith({
    String? numeroCadastro,
    String? nome,
    String? status,
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
    DateTime? dataUltimaAlteracao,
  }) {
    return GrupoTrabalhoEspiritualMembro(
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      atividadeEspiritual: atividadeEspiritual ?? this.atividadeEspiritual,
      grupoTrabalho: grupoTrabalho ?? this.grupoTrabalho,
      funcao: funcao ?? this.funcao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }
}
