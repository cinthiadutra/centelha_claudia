import 'package:equatable/equatable.dart';

import '../../domain/entities/registro_ponto.dart';

class AtualizarPontoEvent extends PontoEvent {
  final RegistroPonto registro;

  const AtualizarPontoEvent(this.registro);

  @override
  List<Object?> get props => [registro];
}

class CarregarHistoricoEvent extends PontoEvent {
  final String membroId;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  const CarregarHistoricoEvent({
    required this.membroId,
    this.dataInicio,
    this.dataFim,
  });

  @override
  List<Object?> get props => [membroId, dataInicio, dataFim];
}

class CarregarRelatorioEvent extends PontoEvent {
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? membroId;

  const CarregarRelatorioEvent({
    required this.dataInicio,
    required this.dataFim,
    this.membroId,
  });

  @override
  List<Object?> get props => [dataInicio, dataFim, membroId];
}

abstract class PontoEvent extends Equatable {
  const PontoEvent();

  @override
  List<Object?> get props => [];
}

class RegistrarPontoEvent extends PontoEvent {
  final String membroId;
  final String membroNome;
  final TipoPonto tipo;
  final String? localizacao;
  final String? observacao;
  final bool manual;
  final String? registradoPor;

  const RegistrarPontoEvent({
    required this.membroId,
    required this.membroNome,
    required this.tipo,
    this.localizacao,
    this.observacao,
    this.manual = false,
    this.registradoPor,
  });

  @override
  List<Object?> get props => [
        membroId,
        membroNome,
        tipo,
        localizacao,
        observacao,
        manual,
        registradoPor,
      ];
}

class RemoverPontoEvent extends PontoEvent {
  final String id;

  const RemoverPontoEvent(this.id);

  @override
  List<Object?> get props => [id];
}
