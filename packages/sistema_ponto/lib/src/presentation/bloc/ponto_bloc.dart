import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/ponto_repository.dart';
import '../../domain/usecases/obter_historico_ponto_usecase.dart';
import '../../domain/usecases/registrar_ponto_usecase.dart';
import 'ponto_event.dart';
import 'ponto_state.dart';

class PontoBloc extends Bloc<PontoEvent, PontoState> {
  final RegistrarPontoUseCase registrarPontoUseCase;
  final ObterHistoricoPontoUseCase obterHistoricoUseCase;
  final PontoRepository repository;

  PontoBloc({
    required this.registrarPontoUseCase,
    required this.obterHistoricoUseCase,
    required this.repository,
  }) : super(PontoInitial()) {
    on<RegistrarPontoEvent>(_onRegistrarPonto);
    on<CarregarHistoricoEvent>(_onCarregarHistorico);
    on<CarregarRelatorioEvent>(_onCarregarRelatorio);
    on<AtualizarPontoEvent>(_onAtualizarPonto);
    on<RemoverPontoEvent>(_onRemoverPonto);
  }

  Future<void> _onAtualizarPonto(
    AtualizarPontoEvent event,
    Emitter<PontoState> emit,
  ) async {
    emit(PontoLoading());
    try {
      final registro = await repository.atualizarPonto(event.registro);
      emit(PontoRegistrado(registro));
    } catch (e) {
      emit(PontoError('Erro ao atualizar ponto: ${e.toString()}'));
    }
  }

  Future<void> _onCarregarHistorico(
    CarregarHistoricoEvent event,
    Emitter<PontoState> emit,
  ) async {
    emit(PontoLoading());
    try {
      final historico = await obterHistoricoUseCase(
        membroId: event.membroId,
        dataInicio: event.dataInicio,
        dataFim: event.dataFim,
      );
      emit(HistoricoCarregado(historico));
    } catch (e) {
      emit(PontoError('Erro ao carregar histórico: ${e.toString()}'));
    }
  }

  Future<void> _onCarregarRelatorio(
    CarregarRelatorioEvent event,
    Emitter<PontoState> emit,
  ) async {
    emit(PontoLoading());
    try {
      final relatorio = await repository.obterRelatorioPresenca(
        dataInicio: event.dataInicio,
        dataFim: event.dataFim,
        membroId: event.membroId,
      );
      emit(RelatorioCarregado(relatorio));
    } catch (e) {
      emit(PontoError('Erro ao carregar relatório: ${e.toString()}'));
    }
  }

  Future<void> _onRegistrarPonto(
    RegistrarPontoEvent event,
    Emitter<PontoState> emit,
  ) async {
    emit(PontoLoading());
    try {
      final registro = await registrarPontoUseCase(
        membroId: event.membroId,
        membroNome: event.membroNome,
        tipo: event.tipo,
        localizacao: event.localizacao,
        observacao: event.observacao,
        manual: event.manual,
        registradoPor: event.registradoPor,
      );
      emit(PontoRegistrado(registro));
    } catch (e) {
      emit(PontoError('Erro ao registrar ponto: ${e.toString()}'));
    }
  }

  Future<void> _onRemoverPonto(
    RemoverPontoEvent event,
    Emitter<PontoState> emit,
  ) async {
    emit(PontoLoading());
    try {
      await repository.removerPonto(event.id);
      emit(PontoInitial());
    } catch (e) {
      emit(PontoError('Erro ao remover ponto: ${e.toString()}'));
    }
  }
}
