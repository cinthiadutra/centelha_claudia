import '../models/usuario_sistema_model.dart';

/// Interface do datasource de usuários do sistema
abstract class UsuarioSistemaDatasource {
  Future<List<UsuarioSistemaModel>> getTodos();
  Future<UsuarioSistemaModel?> getPorId(String id);
  Future<UsuarioSistemaModel?> getPorEmail(String email);
  Future<UsuarioSistemaModel?> getPorCadastro(String numeroCadastro);
  Future<void> adicionar(UsuarioSistemaModel usuario);
  Future<void> atualizar(UsuarioSistemaModel usuario);
  Future<void> remover(String id);
}

/// Implementação mock do datasource
class UsuarioSistemaDatasourceImpl implements UsuarioSistemaDatasource {
  final List<UsuarioSistemaModel> _usuarios = [
    UsuarioSistemaModel(
      id: '1',
      numeroCadastro: '00001',
      nome: 'Admin Sistema',
      email: 'admin@centelha.org',
      senha: 'admin123', // Em produção usar hash
      nivelPermissao: 4,
      ativo: true,
      dataCriacao: DateTime(2025, 1, 1),
      observacoes: 'Administrador principal do sistema',
    ),
    UsuarioSistemaModel(
      id: '2',
      numeroCadastro: '00002',
      nome: 'Secretaria',
      email: 'secretaria@centelha.org',
      senha: 'sec123',
      nivelPermissao: 2,
      ativo: true,
      dataCriacao: DateTime(2025, 1, 15),
    ),
  ];

  int _nextId = 3;

  @override
  Future<List<UsuarioSistemaModel>> getTodos() async {
    return List.from(_usuarios);
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
  Future<UsuarioSistemaModel?> getPorEmail(String email) async {
    try {
      return _usuarios.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
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
  Future<void> adicionar(UsuarioSistemaModel usuario) async {
    final novoUsuario = UsuarioSistemaModel(
      id: usuario.id.isEmpty ? _nextId++.toString() : usuario.id,
      numeroCadastro: usuario.numeroCadastro,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      nivelPermissao: usuario.nivelPermissao,
      ativo: usuario.ativo,
      dataCriacao: usuario.dataCriacao,
      dataUltimaAlteracao: usuario.dataUltimaAlteracao,
      observacoes: usuario.observacoes,
    );
    _usuarios.add(novoUsuario);
  }

  @override
  Future<void> atualizar(UsuarioSistemaModel usuario) async {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      _usuarios[index] = usuario;
    }
  }

  @override
  Future<void> remover(String id) async {
    _usuarios.removeWhere((u) => u.id == id);
  }
}
