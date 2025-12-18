import 'package:get/get.dart';

import '../../data/repositories/usuario_sistema_repository.dart';
import '../../domain/entities/usuario_sistema.dart';

/// Controller para gerenciar usuários do sistema
class UsuarioSistemaController extends GetxController {
  final UsuarioSistemaRepository repository;

  final RxList<UsuarioSistema> usuarios = <UsuarioSistema>[].obs;

  final RxBool isLoading = false.obs;
  UsuarioSistemaController(this.repository);

  Future<void> alterarStatus(String id, bool novoStatus) async {
    try {
      final usuario = await buscarPorId(id);
      if (usuario == null) return;

      final usuarioAtualizado = usuario.copyWith(
        ativo: novoStatus,
        dataUltimaAlteracao: DateTime.now(),
      );

      await salvar(usuarioAtualizado);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao alterar status: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<UsuarioSistema?> buscarPorCadastro(String numeroCadastro) async {
    return await repository.getPorCadastro(numeroCadastro);
  }

  Future<UsuarioSistema?> buscarPorEmail(String email) async {
    return await repository.getPorEmail(email);
  }

  Future<UsuarioSistema?> buscarPorId(String id) async {
    return await repository.getPorId(id);
  }

  Future<void> carregarTodos() async {
    try {
      isLoading.value = true;
      usuarios.value = await repository.getTodos();
    } finally {
      isLoading.value = false;
    }
  }

  List<UsuarioSistema> filtrarPorNivel(int? nivelPermissao) {
    if (nivelPermissao == null) {
      return List.from(usuarios);
    }
    return usuarios.where((u) => u.nivelPermissao == nivelPermissao).toList();
  }

  List<UsuarioSistema> filtrarPorStatus(bool? ativo) {
    if (ativo == null) {
      return List.from(usuarios);
    }
    return usuarios.where((u) => u.ativo == ativo).toList();
  }

  @override
  void onInit() {
    super.onInit();
    carregarTodos();
  }

  Future<void> remover(String id) async {
    try {
      isLoading.value = true;
      await repository.remover(id);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Usuário do sistema removido com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao remover usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> salvar(UsuarioSistema usuario) async {
    try {
      // Validar email único
      final emailValido = await validarEmailUnico(usuario.email, idExcluir: usuario.id);
      if (!emailValido) {
        Get.snackbar(
          'Erro de Validação',
          'Este email já está cadastrado no sistema',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      // Validar cadastro único
      final cadastroValido = await validarCadastroUnico(usuario.numeroCadastro, idExcluir: usuario.id);
      if (!cadastroValido) {
        Get.snackbar(
          'Erro de Validação',
          'Este número de cadastro já possui acesso ao sistema',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      isLoading.value = true;
      await repository.salvar(usuario);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Usuário do sistema salvo com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao salvar usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> validarCadastroUnico(String numeroCadastro, {String? idExcluir}) async {
    final usuarioExistente = await buscarPorCadastro(numeroCadastro);
    if (usuarioExistente == null) return true;
    if (idExcluir != null && usuarioExistente.id == idExcluir) return true;
    return false;
  }

  Future<bool> validarEmailUnico(String email, {String? idExcluir}) async {
    final usuarioExistente = await buscarPorEmail(email);
    if (usuarioExistente == null) return true;
    if (idExcluir != null && usuarioExistente.id == idExcluir) return true;
    return false;
  }
}
