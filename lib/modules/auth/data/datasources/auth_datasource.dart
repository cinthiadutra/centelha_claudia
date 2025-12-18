import '../models/usuario_sistema_model.dart';
import '../../domain/entities/usuario_sistema.dart';

abstract class AuthDatasource {
  Future<UsuarioSistemaModel> login(String login, String senha);
  Future<void> logout();
  Future<UsuarioSistemaModel?> getUsuarioLogado();
}

/// Implementação mockada - substituir por API real posteriormente
class AuthDatasourceMock implements AuthDatasource {
  UsuarioSistemaModel? _usuarioLogado;

  // Usuários mockados para teste
  final List<Map<String, dynamic>> _usuarios = [
    {
      'id': '1',
      'nome': 'Administrador',
      'login': 'admin',
      'senha': '123456',
      'email': 'admin@centelha.com',
      'nivelAcesso': 3, // Nível 4
    },
    {
      'id': '2',
      'nome': 'Pai de Terreiro',
      'login': 'pai',
      'senha': '123456',
      'email': 'pai@centelha.com',
      'nivelAcesso': 2, // Nível 3
    },
    {
      'id': '3',
      'nome': 'Secretaria',
      'login': 'secretaria',
      'senha': '123456',
      'email': 'secretaria@centelha.com',
      'nivelAcesso': 1, // Nível 2
    },
    {
      'id': '4',
      'nome': 'Membro',
      'login': 'membro',
      'senha': '123456',
      'email': 'membro@centelha.com',
      'nivelAcesso': 0, // Nível 1
    },
  ];

  @override
  Future<UsuarioSistemaModel> login(String login, String senha) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final usuario = _usuarios.firstWhere(
      (u) => u['login'] == login && u['senha'] == senha,
      orElse: () => throw Exception('Login ou senha inválidos'),
    );

    _usuarioLogado = UsuarioSistemaModel(
      id: usuario['id'],
      nome: usuario['nome'],
      login: usuario['login'],
      email: usuario['email'],
      nivelAcesso: NivelAcesso.values[usuario['nivelAcesso']],
      ativo: true,
      ultimoAcesso: DateTime.now(),
    );

    return _usuarioLogado!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _usuarioLogado = null;
  }

  @override
  Future<UsuarioSistemaModel?> getUsuarioLogado() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _usuarioLogado;
  }
}
