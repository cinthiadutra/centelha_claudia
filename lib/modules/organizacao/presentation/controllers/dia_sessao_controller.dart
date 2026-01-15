import 'package:get/get.dart';

import '../../data/datasources/dia_sessao_datasource.dart';
import '../../domain/entities/dia_sessao.dart';

/// Controller para gerenciar dias de sessão
class DiaSessaoController extends GetxController {
  final DiaSessaoSupabaseDatasource _datasource;

  DiaSessaoController(this._datasource);

  final RxList<DiaSessao> diasSessao = <DiaSessao>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarDiasSessao();
  }

  Future<void> carregarDiasSessao({bool? apenasAtivos, String? nucleo}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      diasSessao.value = await _datasource.getTodos(
        apenasAtivos: apenasAtivos,
        nucleo: nucleo,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao carregar dias de sessão: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> adicionar(DiaSessao diaSessao) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.adicionar(diaSessao);
      await carregarDiasSessao();
      Get.snackbar(
        'Sucesso',
        'Dia de sessão adicionado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao adicionar dia de sessão: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> atualizar(DiaSessao diaSessao) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.atualizar(diaSessao);
      await carregarDiasSessao();
      Get.snackbar(
        'Sucesso',
        'Dia de sessão atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao atualizar dia de sessão: $e',
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
        'Apenas usuários com nível 4 podem desativar dias de sessão',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.desativar(id);
      await carregarDiasSessao();
      Get.snackbar(
        'Sucesso',
        'Dia de sessão desativado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Erro ao desativar dia de sessão: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
