import '../models/usuario_sistema_model.dart';

abstract class UsuarioSistemaDatasource {
  Future<void> adicionar(UsuarioSistemaModel usuario);
  Future<void> atualizar(UsuarioSistemaModel usuario);
  Future<UsuarioSistemaModel?> getPorCadastro(String numeroCadastro);
  Future<UsuarioSistemaModel?> getPorEmail(String email);
  Future<UsuarioSistemaModel?> getPorEmailOuUsername(String emailOuUsername);
  Future<UsuarioSistemaModel?> getPorId(String id);
  Future<UsuarioSistemaModel?> getPorUsername(String username);
  Future<List<UsuarioSistemaModel>> getTodos();
  Future<void> remover(String id);
}