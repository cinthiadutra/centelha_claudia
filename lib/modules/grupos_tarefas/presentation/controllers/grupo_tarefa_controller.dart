import 'package:get/get.dart';

import '../../data/repositories/grupo_tarefa_repository.dart';
import '../../domain/entities/grupo_tarefa_membro.dart';

/// Controller GetX para gerenciar grupos-tarefas
class GrupoTarefaController extends GetxController {
  final GrupoTarefaRepository repository;

  // Estado reativo
  final RxList<GrupoTarefaMembro> membros = <GrupoTarefaMembro>[].obs;

  final RxBool isLoading = false.obs;
  GrupoTarefaController(this.repository);

  /// Busca membro por número de cadastro
  GrupoTarefaMembro? buscarPorCadastro(String numeroCadastro) {
    return repository.getPorCadastro(numeroCadastro);
  }

  /// Carrega todos os membros de grupos-tarefas
  void carregarTodos() {
    isLoading.value = true;
    try {
      membros.value = repository.getTodos();
    } finally {
      isLoading.value = false;
    }
  }

  /// Filtra membros para relatórios
  List<GrupoTarefaMembro> filtrar({String? grupoTarefa, String? funcao}) {
    return repository.filtrar(grupoTarefa: grupoTarefa, funcao: funcao);
  }

  @override
  void onInit() {
    super.onInit();
    carregarTodos();
  }

  /// Remove membro de grupo-tarefa
  Future<void> remover(String numeroCadastro) async {
    isLoading.value = true;
    try {
      repository.remover(numeroCadastro);
      membros.removeWhere((m) => m.numeroCadastro == numeroCadastro);
      Get.snackbar('Sucesso', 'Membro removido do grupo-tarefa');
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao remover: ${e.toString()}');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Adiciona ou atualiza membro em grupo-tarefa
  Future<void> salvar(GrupoTarefaMembro membro) async {
    isLoading.value = true;
    try {
      final existe = buscarPorCadastro(membro.numeroCadastro);

      if (existe != null) {
        // Atualizar
        repository.atualizar(membro);
        final index = membros.indexWhere(
          (m) => m.numeroCadastro == membro.numeroCadastro,
        );
        if (index != -1) {
          membros[index] = membro;
        }
        Get.snackbar('Sucesso', 'Grupo-tarefa atualizado com sucesso');
      } else {
        // Adicionar
        repository.adicionar(membro);
        membros.add(membro);
        Get.snackbar(
          'Sucesso',
          'Membro adicionado ao grupo-tarefa com sucesso',
        );
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao salvar: ${e.toString()}');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
