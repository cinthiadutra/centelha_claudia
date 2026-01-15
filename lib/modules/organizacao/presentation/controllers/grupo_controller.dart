import 'package:get/get.dart';

import '../../data/datasources/grupo_datasource.dart';
import '../../domain/entities/grupo.dart';

/// Controller para gerenciar grupos
class GrupoController extends GetxController {
  final GrupoSupabaseDatasource _datasource;

  GrupoController(this._datasource);

  final RxList<Grupo> grupos = <Grupo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarGrupos();
  }

  Future<void> carregarGrupos({bool? apenasAtivos, String? tipo}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      grupos.value = await _datasource.getTodos(
        apenasAtivos: apenasAtivos,
        tipo: tipo,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao carregar grupos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> adicionar(Grupo grupo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.adicionar(grupo);
      await carregarGrupos();
      Get.snackbar(
        'Sucesso',
        'Grupo adicionado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao adicionar grupo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> atualizar(Grupo grupo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.atualizar(grupo);
      await carregarGrupos();
      Get.snackbar(
        'Sucesso',
        'Grupo atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao atualizar grupo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> desativar(String id, {required int nivelPermissao}) async {
    if (nivelPermissao < 4) {
      Get.snackbar(
        'Sem permissão',
        'Apenas usuários com nível 4 podem desativar grupos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.desativar(id);
      await carregarGrupos();
      Get.snackbar(
        'Sucesso',
        'Grupo desativado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao desativar grupo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
