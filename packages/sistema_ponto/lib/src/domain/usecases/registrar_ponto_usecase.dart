import '../entities/registro_ponto.dart';
import '../repositories/ponto_repository.dart';

class RegistrarPontoUseCase {
  final PontoRepository repository;

  RegistrarPontoUseCase(this.repository);

  Future<RegistroPonto> call({
    required String membroId,
    required String membroNome,
    required TipoPonto tipo,
    String? localizacao,
    String? observacao,
    bool manual = false,
    String? registradoPor,
  }) async {
    final registro = RegistroPonto(
      membroId: membroId,
      membroNome: membroNome,
      dataHora: DateTime.now(),
      tipo: tipo,
      localizacao: localizacao,
      observacao: observacao,
      manual: manual,
      registradoPor: registradoPor,
    );

    return await repository.registrarPonto(registro);
  }
}
