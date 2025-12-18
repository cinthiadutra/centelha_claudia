import 'package:get/get.dart';

import '../../data/repositories/grupo_acao_social_repository.dart';
import '../../domain/entities/grupo_acao_social_membro.dart';

/// Controller para gerenciar grupos de ações sociais
class GrupoAcaoSocialController extends GetxController {
  final GrupoAcaoSocialRepository repository;

  final RxList<GrupoAcaoSocialMembro> membros = <GrupoAcaoSocialMembro>[].obs;

  final RxBool isLoading = false.obs;
  GrupoAcaoSocialController(this.repository);

  Future<GrupoAcaoSocialMembro?> buscarPorCadastro(
    String numeroCadastro,
  ) async {
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

  List<GrupoAcaoSocialMembro> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) {
    var resultado = List<GrupoAcaoSocialMembro>.from(membros);

    if (grupoAcaoSocial != null) {
      resultado = resultado
          .where((m) => m.grupoAcaoSocial == grupoAcaoSocial)
          .toList();
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
        'Membro removido do grupo de ação social com sucesso!',
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

  Future<void> salvar(GrupoAcaoSocialMembro membro) async {
    try {
      isLoading.value = true;
      await repository.salvar(membro);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Membro salvo no grupo de ação social com sucesso!',
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
}
