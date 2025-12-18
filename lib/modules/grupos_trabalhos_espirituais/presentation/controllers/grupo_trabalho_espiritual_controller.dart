import 'package:get/get.dart';

import '../../../../core/constants/grupo_trabalho_espiritual_constants.dart';
import '../../data/repositories/grupo_trabalho_espiritual_repository.dart';
import '../../domain/entities/grupo_trabalho_espiritual_membro.dart';

/// Controller para gerenciar grupos de trabalhos espirituais
class GrupoTrabalhoEspiritualController extends GetxController {
  final GrupoTrabalhoEspiritualRepository repository;

  final RxList<GrupoTrabalhoEspiritualMembro> membros = <GrupoTrabalhoEspiritualMembro>[].obs;

  final RxBool isLoading = false.obs;
  GrupoTrabalhoEspiritualController(this.repository);

  Future<GrupoTrabalhoEspiritualMembro?> buscarPorCadastro(String numeroCadastro) async {
    return await repository.getPorCadastro(numeroCadastro);
  }

  Future<void> carregarTodos() async {
    try {
      isLoading.value = true;
      membros.value = await repository.getTodos();
    } finally {
      isLoading.value = false;
    }
  }

  List<GrupoTrabalhoEspiritualMembro> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  }) {
    var resultado = List<GrupoTrabalhoEspiritualMembro>.from(membros);

    if (atividadeEspiritual != null) {
      resultado = resultado.where((m) => m.atividadeEspiritual == atividadeEspiritual).toList();
    }

    if (grupoTrabalho != null) {
      resultado = resultado.where((m) => m.grupoTrabalho == grupoTrabalho).toList();
    }

    if (funcao != null) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  void onInit() {
    super.onInit();
    carregarTodos();
  }

  Future<void> remover(String numeroCadastro) async {
    try {
      isLoading.value = true;
      await repository.remover(numeroCadastro);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Membro removido do grupo de trabalho espiritual com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao remover membro: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> salvar(GrupoTrabalhoEspiritualMembro membro) async {
    try {
      // Validar correspondência entre atividade e grupo
      if (!validarGrupoAtividade(membro.atividadeEspiritual, membro.grupoTrabalho)) {
        Get.snackbar(
          'Erro de Validação',
          'O grupo "${membro.grupoTrabalho}" não pertence à atividade "${membro.atividadeEspiritual}"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      isLoading.value = true;
      await repository.salvar(membro);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Membro salvo no grupo de trabalho espiritual com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao salvar membro: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Valida se o grupo pertence à atividade selecionada
  bool validarGrupoAtividade(String atividadeEspiritual, String grupoTrabalho) {
    return GrupoTrabalhoEspiritualConstants.validarGrupoAtividade(
      atividadeEspiritual,
      grupoTrabalho,
    );
  }
}
