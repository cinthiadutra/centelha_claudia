import 'package:equatable/equatable.dart';

/// Entidade que representa um casamento
class Casamento extends Equatable {
  final String id;
  final String numeroCadastroNoivo;
  final String nomeNoivo;
  final String numeroCadastroNoiva;
  final String nomeNoiva;
  final DateTime dataCasamento;
  final String localCasamento;
  final String sacerdoteNome;
  final String sacerdoteCadastro;
  final String? testemunha1Nome;
  final String? testemunha1Cadastro;
  final String? testemunha2Nome;
  final String? testemunha2Cadastro;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const Casamento({
    required this.id,
    required this.numeroCadastroNoivo,
    required this.nomeNoivo,
    required this.numeroCadastroNoiva,
    required this.nomeNoiva,
    required this.dataCasamento,
    required this.localCasamento,
    required this.sacerdoteNome,
    required this.sacerdoteCadastro,
    this.testemunha1Nome,
    this.testemunha1Cadastro,
    this.testemunha2Nome,
    this.testemunha2Cadastro,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
    id,
    numeroCadastroNoivo,
    nomeNoivo,
    numeroCadastroNoiva,
    nomeNoiva,
    dataCasamento,
    localCasamento,
    sacerdoteNome,
    sacerdoteCadastro,
    testemunha1Nome,
    testemunha1Cadastro,
    testemunha2Nome,
    testemunha2Cadastro,
    dataUltimaAlteracao,
    observacoes,
  ];

  Casamento copyWith({
    String? id,
    String? numeroCadastroNoivo,
    String? nomeNoivo,
    String? numeroCadastroNoiva,
    String? nomeNoiva,
    DateTime? dataCasamento,
    String? localCasamento,
    String? sacerdoteNome,
    String? sacerdoteCadastro,
    String? testemunha1Nome,
    String? testemunha1Cadastro,
    String? testemunha2Nome,
    String? testemunha2Cadastro,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return Casamento(
      id: id ?? this.id,
      numeroCadastroNoivo: numeroCadastroNoivo ?? this.numeroCadastroNoivo,
      nomeNoivo: nomeNoivo ?? this.nomeNoivo,
      numeroCadastroNoiva: numeroCadastroNoiva ?? this.numeroCadastroNoiva,
      nomeNoiva: nomeNoiva ?? this.nomeNoiva,
      dataCasamento: dataCasamento ?? this.dataCasamento,
      localCasamento: localCasamento ?? this.localCasamento,
      sacerdoteNome: sacerdoteNome ?? this.sacerdoteNome,
      sacerdoteCadastro: sacerdoteCadastro ?? this.sacerdoteCadastro,
      testemunha1Nome: testemunha1Nome ?? this.testemunha1Nome,
      testemunha1Cadastro: testemunha1Cadastro ?? this.testemunha1Cadastro,
      testemunha2Nome: testemunha2Nome ?? this.testemunha2Nome,
      testemunha2Cadastro: testemunha2Cadastro ?? this.testemunha2Cadastro,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
