import 'package:equatable/equatable.dart';

/// Entidade que representa a inscrição de um membro em um curso
class InscricaoCurso extends Equatable {
  final String id;
  final String cursoId;
  final String cursoTitulo;
  final String numeroCadastro;
  final String nomeMembro;
  final DateTime dataInscricao;
  final String statusInscricao; // Pendente, Confirmada, Cancelada, Concluída
  final double? frequencia; // Percentual de presença
  final double? notaFinal; // Se houver avaliação
  final bool certificadoEmitido;
  final DateTime? dataConclusao;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const InscricaoCurso({
    required this.id,
    required this.cursoId,
    required this.cursoTitulo,
    required this.numeroCadastro,
    required this.nomeMembro,
    required this.dataInscricao,
    required this.statusInscricao,
    this.frequencia,
    this.notaFinal,
    required this.certificadoEmitido,
    this.dataConclusao,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  bool get aprovado {
    if (frequencia != null && frequencia! < 75) return false;
    if (notaFinal != null && notaFinal! < 7.0) return false;
    return statusInscricao == 'Concluída';
  }

  @override
  List<Object?> get props => [
    id,
    cursoId,
    cursoTitulo,
    numeroCadastro,
    nomeMembro,
    dataInscricao,
    statusInscricao,
    frequencia,
    notaFinal,
    certificadoEmitido,
    dataConclusao,
    dataUltimaAlteracao,
    observacoes,
  ];

  InscricaoCurso copyWith({
    String? id,
    String? cursoId,
    String? cursoTitulo,
    String? numeroCadastro,
    String? nomeMembro,
    DateTime? dataInscricao,
    String? statusInscricao,
    double? frequencia,
    double? notaFinal,
    bool? certificadoEmitido,
    DateTime? dataConclusao,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return InscricaoCurso(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      cursoTitulo: cursoTitulo ?? this.cursoTitulo,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      nomeMembro: nomeMembro ?? this.nomeMembro,
      dataInscricao: dataInscricao ?? this.dataInscricao,
      statusInscricao: statusInscricao ?? this.statusInscricao,
      frequencia: frequencia ?? this.frequencia,
      notaFinal: notaFinal ?? this.notaFinal,
      certificadoEmitido: certificadoEmitido ?? this.certificadoEmitido,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
