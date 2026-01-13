import 'package:equatable/equatable.dart';

import '../../domain/entities/registro_ponto.dart';

class HistoricoCarregado extends PontoState {
  final List<RegistroPonto> historico;

  const HistoricoCarregado(this.historico);

  @override
  List<Object?> get props => [historico];
}

class PontoError extends PontoState {
  final String message;

  const PontoError(this.message);

  @override
  List<Object?> get props => [message];
}

class PontoInitial extends PontoState {}

class PontoLoading extends PontoState {}

class PontoRegistrado extends PontoState {
  final RegistroPonto registro;

  const PontoRegistrado(this.registro);

  @override
  List<Object?> get props => [registro];
}

abstract class PontoState extends Equatable {
  const PontoState();

  @override
  List<Object?> get props => [];
}

class RelatorioCarregado extends PontoState {
  final Map<String, dynamic> relatorio;

  const RelatorioCarregado(this.relatorio);

  @override
  List<Object?> get props => [relatorio];
}
