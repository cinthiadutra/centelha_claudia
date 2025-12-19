import 'package:equatable/equatable.dart';

/// Entidade que representa uma coroação sacerdotal
class CoroacaoSacerdotal extends Equatable {
  final String id;
  final String numeroCadastro;
  final String nomeMembro;
  final DateTime dataCoroacao;
  final String localCoroacao;
  final String sacerdoteOrdenadorNome;
  final String sacerdoteOrdenadorCadastro;
  final String cargo; // Sacerdote, Sacerdotisa, Babalorixá, Ialorixá, etc.
  final String? orixaConsagrado;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const CoroacaoSacerdotal({
    required this.id,
    required this.numeroCadastro,
    required this.nomeMembro,
    required this.dataCoroacao,
    required this.localCoroacao,
    required this.sacerdoteOrdenadorNome,
    required this.sacerdoteOrdenadorCadastro,
    required this.cargo,
    this.orixaConsagrado,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        numeroCadastro,
        nomeMembro,
        dataCoroacao,
        localCoroacao,
        sacerdoteOrdenadorNome,
        sacerdoteOrdenadorCadastro,
        cargo,
        orixaConsagrado,
        dataUltimaAlteracao,
        observacoes,
      ];

  CoroacaoSacerdotal copyWith({
    String? id,
    String? numeroCadastro,
    String? nomeMembro,
    DateTime? dataCoroacao,
    String? localCoroacao,
    String? sacerdoteOrdenadorNome,
    String? sacerdoteOrdenadorCadastro,
    String? cargo,
    String? orixaConsagrado,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return CoroacaoSacerdotal(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nomeMembro: nomeMembro ?? this.nomeMembro,
      dataCoroacao: dataCoroacao ?? this.dataCoroacao,
      localCoroacao: localCoroacao ?? this.localCoroacao,
      sacerdoteOrdenadorNome: sacerdoteOrdenadorNome ?? this.sacerdoteOrdenadorNome,
      sacerdoteOrdenadorCadastro: sacerdoteOrdenadorCadastro ?? this.sacerdoteOrdenadorCadastro,
      cargo: cargo ?? this.cargo,
      orixaConsagrado: orixaConsagrado ?? this.orixaConsagrado,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
