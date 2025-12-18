import '../../domain/entities/usuario_sistema.dart';
import '../datasources/usuario_sistema_datasource.dart';
import '../models/usuario_sistema_model.dart';

/// Interface do repositório
abstract class UsuarioSistemaRepository {
  Future<List<UsuarioSistema>> getTodos();
  Future<UsuarioSistema?> getPorId(String id);
  Future<UsuarioSistema?> getPorEmail(String email);
  Future<UsuarioSistema?> getPorCadastro(String numeroCadastro);
  Future<void> salvar(UsuarioSistema usuario);
  Future<void> remover(String id);
}

/// Implementação do repositório
class UsuarioSistemaRepositoryImpl implements UsuarioSistemaRepository {
  final UsuarioSistemaDatasource datasource;

  UsuarioSistemaRepositoryImpl(this.datasource);

  @override
  Future<List<UsuarioSistema>> getTodos() async {
    return await datasource.getTodos();
  }

  @override
  Future<UsuarioSistema?> getPorId(String id) async {
    return await datasource.getPorId(id);
  }

  @override
  Future<UsuarioSistema?> getPorEmail(String email) async {
    return await datasource.getPorEmail(email);
  }

  @override
  Future<UsuarioSistema?> getPorCadastro(String numeroCadastro) async {
    return await datasource.getPorCadastro(numeroCadastro);
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

  @override
  Future<void> remover(String id) async {
    await datasource.remover(id);
  }
}
