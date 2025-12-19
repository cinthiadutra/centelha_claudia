import 'package:equatable/equatable.dart';

/// Entidade que representa um batismo
class Batismo extends Equatable {
  final String id;
  final String numeroCadastro;
  final String nomeMembro;
  final DateTime dataBatismo;
  final String localBatismo;
  final String sacerdoteNome;
  final String sacerdoteCadastro;
  final String? padrinhoNome;
  final String? padrinhoCadastro;
  final String? madrinhaNome;
  final String? madrinhaCadastro;
  final bool rebatismo; // Se for segundo batismo
  final String? motivoRebatismo; // Obrigatório se rebatismo = true
  final DateTime?
  dataPrimeiroBatismo; // Data do primeiro batismo se for rebatismo
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const Batismo({
    required this.id,
    required this.numeroCadastro,
    required this.nomeMembro,
    required this.dataBatismo,
    required this.localBatismo,
    required this.sacerdoteNome,
    required this.sacerdoteCadastro,
    this.padrinhoNome,
    this.padrinhoCadastro,
    this.madrinhaNome,
    this.madrinhaCadastro,
    required this.rebatismo,
    this.motivoRebatismo,
    this.dataPrimeiroBatismo,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
    id,
    numeroCadastro,
    nomeMembro,
    dataBatismo,
    localBatismo,
    sacerdoteNome,
    sacerdoteCadastro,
    padrinhoNome,
    padrinhoCadastro,
    madrinhaNome,
    madrinhaCadastro,
    rebatismo,
    motivoRebatismo,
    dataPrimeiroBatismo,
    dataUltimaAlteracao,
    observacoes,
  ];

  Batismo copyWith({
    String? id,
    String? numeroCadastro,
    String? nomeMembro,
    DateTime? dataBatismo,
    String? localBatismo,
    String? sacerdoteNome,
    String? sacerdoteCadastro,
    String? padrinhoNome,
    String? padrinhoCadastro,
    String? madrinhaNome,
    String? madrinhaCadastro,
    bool? rebatismo,
    String? motivoRebatismo,
    DateTime? dataPrimeiroBatismo,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return Batismo(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nomeMembro: nomeMembro ?? this.nomeMembro,
      dataBatismo: dataBatismo ?? this.dataBatismo,
      localBatismo: localBatismo ?? this.localBatismo,
      sacerdoteNome: sacerdoteNome ?? this.sacerdoteNome,
      sacerdoteCadastro: sacerdoteCadastro ?? this.sacerdoteCadastro,
      padrinhoNome: padrinhoNome ?? this.padrinhoNome,
      padrinhoCadastro: padrinhoCadastro ?? this.padrinhoCadastro,
      madrinhaNome: madrinhaNome ?? this.madrinhaNome,
      madrinhaCadastro: madrinhaCadastro ?? this.madrinhaCadastro,
      rebatismo: rebatismo ?? this.rebatismo,
      motivoRebatismo: motivoRebatismo ?? this.motivoRebatismo,
      dataPrimeiroBatismo: dataPrimeiroBatismo ?? this.dataPrimeiroBatismo,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
