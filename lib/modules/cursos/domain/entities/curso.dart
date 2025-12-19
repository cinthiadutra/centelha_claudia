import 'package:equatable/equatable.dart';

/// Entidade que representa um curso ou treinamento
class Curso extends Equatable {
  final String id;
  final String titulo;
  final String descricao;
  final String instrutor;
  final String? instrutorCadastro;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String local;
  final int cargaHoraria; // Em horas
  final int vagasDisponiveis;
  final int vagasOcupadas;
  final bool ativo;
  final String? materiaisNecessarios;
  final String? prerequisitos;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const Curso({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.instrutor,
    this.instrutorCadastro,
    required this.dataInicio,
    required this.dataFim,
    required this.local,
    required this.cargaHoraria,
    required this.vagasDisponiveis,
    required this.vagasOcupadas,
    required this.ativo,
    this.materiaisNecessarios,
    this.prerequisitos,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        descricao,
        instrutor,
        instrutorCadastro,
        dataInicio,
        dataFim,
        local,
        cargaHoraria,
        vagasDisponiveis,
        vagasOcupadas,
        ativo,
        materiaisNecessarios,
        prerequisitos,
        dataUltimaAlteracao,
        observacoes,
      ];

  Curso copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? instrutor,
    String? instrutorCadastro,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? local,
    int? cargaHoraria,
    int? vagasDisponiveis,
    int? vagasOcupadas,
    bool? ativo,
    String? materiaisNecessarios,
    String? prerequisitos,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return Curso(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      instrutor: instrutor ?? this.instrutor,
      instrutorCadastro: instrutorCadastro ?? this.instrutorCadastro,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      local: local ?? this.local,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      vagasDisponiveis: vagasDisponiveis ?? this.vagasDisponiveis,
      vagasOcupadas: vagasOcupadas ?? this.vagasOcupadas,
      ativo: ativo ?? this.ativo,
      materiaisNecessarios: materiaisNecessarios ?? this.materiaisNecessarios,
      prerequisitos: prerequisitos ?? this.prerequisitos,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  int get vagasRestantes => vagasDisponiveis - vagasOcupadas;
  bool get lotado => vagasOcupadas >= vagasDisponiveis;
  int get duracaoDias => dataFim.difference(dataInicio).inDays + 1;
}
