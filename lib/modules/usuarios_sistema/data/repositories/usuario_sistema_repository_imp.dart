import '../../domain/entities/usuario_sistema.dart';
import '../datasources/usuario_sistema_datasource.dart';
import '../models/usuario_sistema_model.dart';
import 'usuario_sistema_repository.dart';

/// Implementação do repositório
class UsuarioSistemaRepositoryImpl implements UsuarioSistemaRepository {
  final UsuarioSistemaDatasource datasource;

  UsuarioSistemaRepositoryImpl(this.datasource);

  @override
  Future<UsuarioSistema?> getPorCadastro(String numeroCadastro) async {
    return await datasource.getPorCadastro(numeroCadastro);
  }

  @override
  Future<UsuarioSistema?> getPorEmail(String email) async {
    return await datasource.getPorEmail(email);
  }

  @override
  Future<UsuarioSistema?> getPorUsername(String username) async {
    return await datasource.getPorUsername(username);
  }

  @override
  Future<UsuarioSistema?> getPorEmailOuUsername(String emailOuUsername) async {
    return await datasource.getPorEmailOuUsername(emailOuUsername);
  }

  @override
  Future<UsuarioSistema?> getPorId(String id) async {
    return await datasource.getPorId(id);
  }

  @override
  Future<List<UsuarioSistema>> getTodos() async {
    return await datasource.getTodos();
  }

  @override
  Future<void> remover(String id) async {
    await datasource.remover(id);
  }

  @override
  Future<void> salvar(UsuarioSistema usuario) async {
    final model = UsuarioSistemaModel.fromEntity(usuario);

    if (usuario.id.isEmpty) {
      await datasource.adicionar(model);
    } else {
      final existe = await datasource.getPorId(usuario.id);
      if (existe != null) {
        await datasource.atualizar(model);
      } else {
        await datasource.adicionar(model);
      }
    }
  }
}
