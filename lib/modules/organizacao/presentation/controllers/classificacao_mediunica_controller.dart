import 'package:get/get.dart';

import '../../data/datasources/classificacao_mediunica_datasource.dart';
import '../../domain/entities/classificacao_mediunica.dart';

/// Controller para gerenciar classificações mediúnicas
class ClassificacaoMediunicaController extends GetxController {
  final ClassificacaoMediunicaSupabaseDatasource _datasource;

  final RxList<ClassificacaoMediunica> classificacoes =
      <ClassificacaoMediunica>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  ClassificacaoMediunicaController(this._datasource);

  Future<bool> adicionar(ClassificacaoMediunica classificacao) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.adicionar(classificacao);
      await carregarClassificacoes();
      Get.snackbar(
        'Sucesso',
        'Classificação adicionada com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao adicionar classificação: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> atualizar(ClassificacaoMediunica classificacao) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.atualizar(classificacao);
      await carregarClassificacoes();
      Get.snackbar(
        'Sucesso',
        'Classificação atualizada com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao atualizar classificação: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> carregarClassificacoes({
    bool? apenasAtivos,
    String? tipo,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      classificacoes.value = await _datasource.getTodos(
        apenasAtivos: apenasAtivos,
        tipo: tipo,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao carregar classificações: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> desativar(String id, {required int nivelPermissao}) async {
    if (nivelPermissao < 4) {
      Get.snackbar(
        'Sem permissão',
        'Apenas usuários com nível 4 podem desativar classificações',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.desativar(id);
      await carregarClassificacoes();
      Get.snackbar(
        'Sucesso',
        'Classificação desativada com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao desativar classificação: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    carregarClassificacoes();
  }
}
