import '../entities/registro_ponto.dart';

abstract class PontoRepository {
  /// Atualiza um registro de ponto existente
  Future<RegistroPonto> atualizarPonto(RegistroPonto registro);

  /// Obtém o histórico de pontos de um membro específico
  Future<List<RegistroPonto>> obterHistorico({
    required String membroId,
    DateTime? dataInicio,
    DateTime? dataFim,
  });

  /// Obtém todos os registros de ponto de um período
  Future<List<RegistroPonto>> obterPontosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  });

  /// Obtém relatório de presença por período
  Future<Map<String, dynamic>> obterRelatorioPresenca({
    required DateTime dataInicio,
    required DateTime dataFim,
    String? membroId,
  });

  /// Obtém o último registro de ponto de um membro
  Future<RegistroPonto?> obterUltimoPonto(String membroId);

  /// Registra um ponto de entrada ou saída
  Future<RegistroPonto> registrarPonto(RegistroPonto registro);

  /// Remove um registro de ponto
  Future<void> removerPonto(String id);

  /// Verifica se um membro está com ponto em aberto (entrou mas não saiu)
  Future<bool> temPontoEmAberto(String membroId);
}
