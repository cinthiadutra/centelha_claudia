import 'package:equatable/equatable.dart';

/// Entidade que representa um jogo de orixá
class JogoOrixa extends Equatable {
  final String id;
  final String numeroCadastro;
  final String nomeMembro;
  final DateTime dataJogo;
  final String localJogo;
  final String sacerdoteNome;
  final String sacerdoteCadastro;
  final String orixaPrincipal;
  final String? orixaJunto; // Orixá que acompanha
  final String qualidadeOrixa; // Qualidade do orixá
  final String caminhoOrixa; // Caminho do orixá
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const JogoOrixa({
    required this.id,
    required this.numeroCadastro,
    required this.nomeMembro,
    required this.dataJogo,
    required this.localJogo,
    required this.sacerdoteNome,
    required this.sacerdoteCadastro,
    required this.orixaPrincipal,
    this.orixaJunto,
    required this.qualidadeOrixa,
    required this.caminhoOrixa,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        numeroCadastro,
        nomeMembro,
        dataJogo,
        localJogo,
        sacerdoteNome,
        sacerdoteCadastro,
        orixaPrincipal,
        orixaJunto,
        qualidadeOrixa,
        caminhoOrixa,
        dataUltimaAlteracao,
        observacoes,
      ];

  JogoOrixa copyWith({
    String? id,
    String? numeroCadastro,
    String? nomeMembro,
    DateTime? dataJogo,
    String? localJogo,
    String? sacerdoteNome,
    String? sacerdoteCadastro,
    String? orixaPrincipal,
    String? orixaJunto,
    String? qualidadeOrixa,
    String? caminhoOrixa,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return JogoOrixa(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nomeMembro: nomeMembro ?? this.nomeMembro,
      dataJogo: dataJogo ?? this.dataJogo,
      localJogo: localJogo ?? this.localJogo,
      sacerdoteNome: sacerdoteNome ?? this.sacerdoteNome,
      sacerdoteCadastro: sacerdoteCadastro ?? this.sacerdoteCadastro,
      orixaPrincipal: orixaPrincipal ?? this.orixaPrincipal,
      orixaJunto: orixaJunto ?? this.orixaJunto,
      qualidadeOrixa: qualidadeOrixa ?? this.qualidadeOrixa,
      caminhoOrixa: caminhoOrixa ?? this.caminhoOrixa,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
