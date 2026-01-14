import 'package:get/get.dart';
import '../../domain/entities/consulta.dart';
import '../../data/repositories/consulta_repository.dart';

/// Controller GetX para gerenciar consultas espirituais
class ConsultaController extends GetxController {
  final ConsultaRepository repository;

  ConsultaController(this.repository);

  // Estado reativo
  final RxList<Consulta> consultas = <Consulta>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Consulta?> consultaSelecionada = Rx<Consulta?>(null);

  @override
  void onInit() {
    super.onInit();
    carregarConsultas();
  }

  /// Carrega todas as consultas
  Future<void> carregarConsultas() async {
    isLoading.value = true;
    try {
      consultas.value = await repository.getConsultas();
    } finally {
      isLoading.value = false;
    }
  }

  /// Gera próximo número de consulta (5 dígitos)
  Future<String> gerarProximoNumero() async {
    return await repository.gerarProximoNumero();
  }

  /// Adiciona nova consulta
  Future<void> adicionarConsulta(Consulta consulta) async {
    isLoading.value = true;
    try {
      await repository.adicionarConsulta(consulta);
      consultas.add(consulta);

      Get.snackbar(
        'Sucesso',
        'Consulta ${consulta.numeroConsulta} registrada com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao registrar consulta: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Busca consulta por número
  Future<Consulta?> buscarPorNumero(String numero) async {
    return await repository.getConsultaPorNumero(numero);
  }

  /// Pesquisa consultas com filtros
  Future<List<Consulta>> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  }) async {
    return await repository.pesquisarConsultas(
      cadastroConsulente: cadastroConsulente,
      cadastroMedium: cadastroMedium,
      nomeEntidade: nomeEntidade,
    );
  }

  /// Verifica se usuário pode ver consulta (nível 1 só vê as próprias)
  bool podeVerConsulta(Consulta consulta, String cadastroUsuario, int nivelAcesso) {
    // Níveis 2, 3 e 4 podem ver todas
    if (nivelAcesso >= 2) return true;
    
    // Nível 1 só vê consultas onde é o consulente
    return consulta.cadastroConsulente == cadastroUsuario;
  }

  /// Seleciona uma consulta
  void selecionarConsulta(Consulta? consulta) {
    consultaSelecionada.value = consulta;
  }

  /// Limpa seleção
  void limparSelecao() {
    consultaSelecionada.value = null;
  }
}
