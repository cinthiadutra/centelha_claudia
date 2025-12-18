import 'package:get/get.dart';
import '../../domain/entities/organizacao_centelha.dart';
import '../../data/repositories/organizacao_centelha_repository.dart';

/// Controller para gerenciar dados da organização
class OrganizacaoCentelhaController extends GetxController {
  final OrganizacaoCentelhaRepository repository;

  OrganizacaoCentelhaController(this.repository);

  final Rx<OrganizacaoCentelha?> organizacao = Rx<OrganizacaoCentelha?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    carregarOrganizacao();
  }

  Future<void> carregarOrganizacao() async {
    try {
      isLoading.value = true;
      organizacao.value = await repository.getOrganizacao();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizar(OrganizacaoCentelha novaOrganizacao) async {
    try {
      isLoading.value = true;
      
      final organizacaoAtualizada = novaOrganizacao.copyWith(
        dataUltimaAlteracao: DateTime.now(),
      );
      
      await repository.atualizar(organizacaoAtualizada);
      await carregarOrganizacao();
      
      Get.snackbar(
        'Sucesso',
        'Dados da organização atualizados com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar organização: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatarCNPJ(String cnpj) {
    // Remove tudo que não é dígito
    final numeros = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numeros.length != 14) return cnpj;
    
    return '${numeros.substring(0, 2)}.${numeros.substring(2, 5)}.${numeros.substring(5, 8)}/${numeros.substring(8, 12)}-${numeros.substring(12, 14)}';
  }

  String formatarCEP(String cep) {
    final numeros = cep.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numeros.length != 8) return cep;
    
    return '${numeros.substring(0, 5)}-${numeros.substring(5, 8)}';
  }

  String formatarTelefone(String telefone) {
    final numeros = telefone.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numeros.length == 10) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6, 10)}';
    } else if (numeros.length == 11) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7, 11)}';
    }
    
    return telefone;
  }
}
