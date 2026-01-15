import 'package:get/get.dart';

import '../../data/datasources/nucleo_datasource.dart';
import '../../domain/entities/nucleo.dart';

/// Controller para gerenciar núcleos
class NucleoController extends GetxController {
  final NucleoSupabaseDatasource _datasource;

  NucleoController(this._datasource);

  final RxList<Nucleo> nucleos = <Nucleo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarNucleos();
  }

  Future<void> carregarNucleos({bool? apenasAtivos}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      nucleos.value = await _datasource.getTodos(apenasAtivos: apenasAtivos);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao carregar núcleos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> adicionar(Nucleo nucleo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.adicionar(nucleo);
      await carregarNucleos();
      Get.snackbar(
        'Sucesso',
        'Núcleo adicionado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao adicionar núcleo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> atualizar(Nucleo nucleo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.atualizar(nucleo);
      await carregarNucleos();
      Get.snackbar(
        'Sucesso',
        'Núcleo atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao atualizar núcleo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> desativar(String cod, {required int nivelPermissao}) async {
    if (nivelPermissao < 4) {
      Get.snackbar(
        'Sem permissão',
        'Apenas usuários com nível 4 podem desativar núcleos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.desativar(cod);
      await carregarNucleos();
      Get.snackbar(
        'Sucesso',
        'Núcleo desativado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao desativar núcleo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
