import '../../domain/entities/usuario_sistema.dart';

/// Interface do repositório
abstract class UsuarioSistemaRepository {
  Future<UsuarioSistema?> getPorCadastro(String numeroCadastro);
  Future<UsuarioSistema?> getPorEmail(String email);
  Future<UsuarioSistema?> getPorEmailOuUsername(String emailOuUsername);
  Future<UsuarioSistema?> getPorId(String id);
  Future<UsuarioSistema?> getPorUsername(String username);
  Future<List<UsuarioSistema>> getTodos();
  Future<void> remover(String id);
  Future<void> salvar(UsuarioSistema usuario);
}
