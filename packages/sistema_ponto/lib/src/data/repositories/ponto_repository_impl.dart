import '../../domain/entities/registro_ponto.dart';
import '../../domain/repositories/ponto_repository.dart';
import '../datasources/ponto_datasource.dart';
import '../models/registro_ponto_model.dart';

class PontoRepositoryImpl implements PontoRepository {
  final PontoDatasource datasource;

  PontoRepositoryImpl(this.datasource);

  @override
  Future<RegistroPonto> atualizarPonto(RegistroPonto registro) async {
    final model = RegistroPontoModel.fromEntity(registro);
    return await datasource.atualizarPonto(model);
  }

  @override
  Future<List<RegistroPonto>> obterHistorico({
    required String membroId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    return await datasource.obterHistorico(
      membroId: membroId,
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  Future<List<RegistroPonto>> obterPontosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    return await datasource.obterPontosPorPeriodo(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  Future<Map<String, dynamic>> obterRelatorioPresenca({
    required DateTime dataInicio,
    required DateTime dataFim,
    String? membroId,
  }) async {
    List<RegistroPonto> pontos;

    if (membroId != null) {
      pontos = await datasource.obterHistorico(
        membroId: membroId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    } else {
      pontos = await datasource.obterPontosPorPeriodo(
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    }

    // Calcular estatísticas
    final totalRegistros = pontos.length;
    final entradas = pontos.where((p) => p.tipo == TipoPonto.entrada).length;
    final saidas = pontos.where((p) => p.tipo == TipoPonto.saida).length;

    // Calcular dias trabalhados
    final diasTrabalhados = pontos
        .map((p) => DateTime(p.dataHora.year, p.dataHora.month, p.dataHora.day))
        .toSet()
        .length;

    return {
      'total_registros': totalRegistros,
      'entradas': entradas,
      'saidas': saidas,
      'dias_trabalhados': diasTrabalhados,
      'registros': pontos,
    };
  }

  @override
  Future<RegistroPonto?> obterUltimoPonto(String membroId) async {
    return await datasource.obterUltimoPonto(membroId);
  }

  @override
  Future<RegistroPonto> registrarPonto(RegistroPonto registro) async {
    final model = RegistroPontoModel.fromEntity(registro);
    return await datasource.registrarPonto(model);
  }

  @override
  Future<void> removerPonto(String id) async {
    await datasource.removerPonto(id);
  }

  @override
  Future<bool> temPontoEmAberto(String membroId) async {
    final ultimoPonto = await datasource.obterUltimoPonto(membroId);
    if (ultimoPonto == null) return false;

    // Verifica se o último ponto foi uma entrada
    return ultimoPonto.tipo == TipoPonto.entrada ||
        ultimoPonto.tipo == TipoPonto.saidaAlmoco;
  }
}
