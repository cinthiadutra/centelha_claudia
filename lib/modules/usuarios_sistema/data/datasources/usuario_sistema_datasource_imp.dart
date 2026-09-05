import '../models/usuario_sistema_model.dart';
import 'usuario_sistema_datasource.dart';

/// Interface do datasource de usuários do sistema

/// Implementação mock do datasource
class UsuarioSistemaDatasourceImpl implements UsuarioSistemaDatasource {
  final List<UsuarioSistemaModel> _usuarios = [];

  @override
  Future<void> adicionar(UsuarioSistemaModel usuario) async {
    _usuarios.add(usuario);
  }

  @override
  Future<void> atualizar(UsuarioSistemaModel usuario) async {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      _usuarios[index] = usuario;
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorCadastro(String numeroCadastro) async {
    try {
      return _usuarios.firstWhere((u) => u.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorEmail(String email) async {
    try {
      return _usuarios.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorEmailOuUsername(
    String emailOuUsername,
  ) async {
    try {
      return _usuarios.firstWhere(
        (u) =>
            u.email.toLowerCase() == emailOuUsername.toLowerCase() ||
            u.username?.toLowerCase() == emailOuUsername.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorId(String id) async {
    try {
      return _usuarios.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorUsername(String username) async {
    try {
      return _usuarios.firstWhere(
        (u) => u.username?.toLowerCase() == username.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<UsuarioSistemaModel>> getTodos() async {
    return List.from(_usuarios);
  }

  @override
  Future<void> remover(String id) async {
    _usuarios.removeWhere((u) => u.id == id);
  }
}
