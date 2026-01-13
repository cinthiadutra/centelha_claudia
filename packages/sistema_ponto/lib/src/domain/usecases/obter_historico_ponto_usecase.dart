import '../entities/registro_ponto.dart';
import '../repositories/ponto_repository.dart';

class ObterHistoricoPontoUseCase {
  final PontoRepository repository;

  ObterHistoricoPontoUseCase(this.repository);

  Future<List<RegistroPonto>> call({
    required String membroId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    return await repository.obterHistorico(
      membroId: membroId,
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }
}
