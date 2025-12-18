import 'package:equatable/equatable.dart';

/// Entidade que representa a associação de um membro a um grupo-tarefa
class GrupoTarefaMembro extends Equatable {
  final String? id;
  final String numeroCadastro; // Do membro
  final String nome; // Auto-preenchido
  final String status; // Auto-preenchido do cadastro de membro
  final String grupoTarefa; // Grupo-Tarefa selecionado
  final String funcao; // Líder ou Membro
  final DateTime? dataUltimaAlteracao;

  const GrupoTarefaMembro({
    this.id,
    required this.numeroCadastro,
    required this.nome,
    required this.status,
    required this.grupoTarefa,
    required this.funcao,
    this.dataUltimaAlteracao,
  });

  @override
  List<Object?> get props => [
    id,
    numeroCadastro,
    nome,
    status,
    grupoTarefa,
    funcao,
    dataUltimaAlteracao,
  ];

  GrupoTarefaMembro copyWith({
    String? id,
    String? numeroCadastro,
    String? nome,
    String? status,
    String? grupoTarefa,
    String? funcao,
    DateTime? dataUltimaAlteracao,
  }) {
    return GrupoTarefaMembro(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      grupoTarefa: grupoTarefa ?? this.grupoTarefa,
      funcao: funcao ?? this.funcao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }
}
