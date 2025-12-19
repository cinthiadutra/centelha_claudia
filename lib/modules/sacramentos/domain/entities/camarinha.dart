import 'package:equatable/equatable.dart';

/// Entidade que representa uma camarinha
/// Um membro pode ter múltiplas camarinhas ao longo da vida
class Camarinha extends Equatable {
  final String id;
  final String numeroCadastro;
  final String nomeMembro;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String localCamarinha;
  final String sacerdoteNome;
  final String sacerdoteCadastro;
  final String tipoObrigacao; // 1 ano, 3 anos, 7 anos, etc.
  final String orixaHomenageado;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const Camarinha({
    required this.id,
    required this.numeroCadastro,
    required this.nomeMembro,
    required this.dataInicio,
    required this.dataFim,
    required this.localCamarinha,
    required this.sacerdoteNome,
    required this.sacerdoteCadastro,
    required this.tipoObrigacao,
    required this.orixaHomenageado,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        numeroCadastro,
        nomeMembro,
        dataInicio,
        dataFim,
        localCamarinha,
        sacerdoteNome,
        sacerdoteCadastro,
        tipoObrigacao,
        orixaHomenageado,
        dataUltimaAlteracao,
        observacoes,
      ];

  Camarinha copyWith({
    String? id,
    String? numeroCadastro,
    String? nomeMembro,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? localCamarinha,
    String? sacerdoteNome,
    String? sacerdoteCadastro,
    String? tipoObrigacao,
    String? orixaHomenageado,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return Camarinha(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nomeMembro: nomeMembro ?? this.nomeMembro,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      localCamarinha: localCamarinha ?? this.localCamarinha,
      sacerdoteNome: sacerdoteNome ?? this.sacerdoteNome,
      sacerdoteCadastro: sacerdoteCadastro ?? this.sacerdoteCadastro,
      tipoObrigacao: tipoObrigacao ?? this.tipoObrigacao,
      orixaHomenageado: orixaHomenageado ?? this.orixaHomenageado,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  int get diasDuracao => dataFim.difference(dataInicio).inDays;
}
