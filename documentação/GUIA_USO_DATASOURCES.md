# 🚀 Guia de Uso - Datasources Supabase

Este guia mostra como usar os datasources criados para conectar o app Flutter ao Supabase.

## 📋 Índice

1. [Executar Scripts SQL no Supabase](#1-executar-scripts-sql)
2. [Configurar Autenticação](#2-configurar-autenticação)
3. [Usar Datasources no Código](#3-usar-datasources)
4. [Exemplos Práticos](#4-exemplos-práticos)
5. [Tratamento de Erros](#5-tratamento-de-erros)

---

## 1. Executar Scripts SQL no Supabase

### Passo 1: Criar as Tabelas

Siga o guia [GUIA_CRIAR_TABELAS_SUPABASE.md](GUIA_CRIAR_TABELAS_SUPABASE.md) para executar:

1. ✅ `supabase_schema.sql` - Cria todas as tabelas
2. ✅ `supabase_rls_policies.sql` - Configura segurança

### Passo 2: Habilitar Extensões

No SQL Editor do Supabase, execute:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

### Passo 3: Criar Primeiro Usuário Admin

```sql
-- 1. Usuário no cadastro
INSERT INTO usuarios (
  numero_cadastro, nome, cpf, email,
  status_atual, classificacao
) VALUES (
  '00001', 'Admin Sistema', '00000000000',
  'admin@centelha.org', 'Ativo', 'Sacerdote'
);

-- 2. Usuário do sistema (login)
INSERT INTO usuarios_sistema (
  numero_cadastro, nome, email,
  senha_hash, nivel_permissao, ativo
) VALUES (
  '00001', 'Admin Sistema', 'admin@centelha.org',
  crypt('admin123', gen_salt('bf')), 4, true
);
```

---

## 2. Configurar Autenticação

### 2.1 Habilitar Email Authentication

No Supabase Dashboard:

1. Vá em **Authentication** > **Providers**
2. Habilite **Email**
3. Configure:
   - ✅ Enable Email provider
   - ✅ Confirm email (opcional para desenvolvimento)

### 2.2 Configurar URL do Site (para emails)

1. Vá em **Settings** > **General**
2. Em **Site URL**, configure:
   - Desenvolvimento: `http://localhost:3000`
   - Produção: `https://seudominio.com`

### 2.3 Desabilitar Confirmação de Email (Desenvolvimento)

Para testes, você pode desabilitar:

1. **Authentication** > **Providers** > **Email**
2. Desmarque "Confirm email"

⚠️ **Importante**: Re-habilite em produção!

---

## 3. Usar Datasources no Código

### 3.1 Atualizar Injection Container

Edite `lib/core/di/injection_container.dart`:

```dart
import '../services/supabase_service.dart';
import '../../modules/auth/data/datasources/auth_supabase_datasource.dart';
import '../../modules/cadastro/data/datasources/usuario_supabase_datasource.dart';

Future<void> init() async {
  // ============ CORE SERVICES ============

  // Supabase Service
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

  // ============ AUTH ============

  // Datasource - TROCAR de Mock para Supabase
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthSupabaseDatasource(sl()),
  );

  // ============ CADASTRO ============

  // Datasource - TROCAR de Mock para Supabase
  sl.registerLazySingleton<UsuarioDatasource>(
    () => UsuarioSupabaseDatasource(sl()),
  );

  // ... resto do código
}
```

### 3.2 Criar Abstract Class para Datasources

Para facilitar a troca entre Mock e Supabase, crie interfaces:

**Exemplo: Auth Datasource Interface**

```dart
// lib/modules/auth/data/datasources/auth_datasource.dart

abstract class AuthDatasource {
  Future<LoginResponse> login(String email, String senha);
  Future<void> logout();
  Future<LoginResponse> register({
    required String email,
    required String senha,
    required String nome,
    required String numeroCadastro,
    required int nivelPermissao,
  });
  bool isAuthenticated();
  Future<UsuarioSistema?> getCurrentUser();
}
```

---

## 4. Exemplos Práticos

### 4.1 Fazer Login

```dart
import 'package:flutter/material.dart';
import 'package:centelha_claudia/core/di/injection_container.dart';
import 'package:centelha_claudia/modules/auth/data/datasources/auth_supabase_datasource.dart';

class LoginExample extends StatefulWidget {
  @override
  _LoginExampleState createState() => _LoginExampleState();
}

class _LoginExampleState extends State<LoginExample> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authDatasource = sl<AuthSupabaseDatasource>();
  bool _loading = false;

  Future<void> _handleLogin() async {
    setState(() => _loading = true);

    try {
      final response = await _authDatasource.login(
        _emailController.text,
        _senhaController.text,
      );

      // Login bem sucedido
      log('Token: ${response.token}');
      log('Usuário: ${response.usuario.nome}');
      log('Nível: ${response.usuario.nivelPermissao}');

      // Navegar para home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _handleLogin,
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4.2 Buscar Usuários

```dart
import 'package:centelha_claudia/core/di/injection_container.dart';
import 'package:centelha_claudia/modules/cadastro/data/datasources/usuario_supabase_datasource.dart';

class UsuariosExample extends StatefulWidget {
  @override
  _UsuariosExampleState createState() => _UsuariosExampleState();
}

class _UsuariosExampleState extends State<UsuariosExample> {
  final _datasource = sl<UsuarioSupabaseDatasource>();
  List<UsuarioModel> _usuarios = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    setState(() => _loading = true);

    try {
      final usuarios = await _datasource.getUsuarios(
        page: 1,
        limit: 50,
      );

      setState(() {
        _usuarios = usuarios;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _usuarios[index];
        return ListTile(
          title: Text(usuario.nome ?? ''),
          subtitle: Text(usuario.email ?? ''),
          trailing: Text(usuario.numeroCadastro ?? ''),
        );
      },
    );
  }
}
```

### 4.3 Criar Usuário

```dart
Future<void> criarNovoUsuario() async {
  final datasource = sl<UsuarioSupabaseDatasource>();

  final novoUsuario = UsuarioModel(
    nome: 'João Silva',
    cpf: '12345678900',
    email: 'joao@example.com',
    telefoneCelular: '11999999999',
    dataNascimento: DateTime(1990, 5, 15),
    statusAtual: 'Ativo',
    classificacao: 'Consulente',
  );

  try {
    final usuarioCriado = await datasource.createUsuario(novoUsuario);
    log('Usuário criado com número: ${usuarioCriado.numeroCadastro}');
  } catch (error) {
    log('Erro: $error');
  }
}
```

### 4.4 Buscar com Filtros

```dart
// Buscar por nome
final usuarios = await datasource.getUsuarios(
  nome: 'João',
  page: 1,
  limit: 20,
);

// Buscar por CPF
final usuario = await datasource.getUsuarios(
  cpf: '12345678900',
);

// Buscar por status
final ativos = await datasource.getUsuariosByStatus('Ativo');

// Buscar por núcleo
final nucleoCentral = await datasource.getUsuariosByNucleo('Núcleo Central');

// Contar usuários
final total = await datasource.countUsuarios();
final totalAtivos = await datasource.countUsuarios(status: 'Ativo');
```

### 4.5 Atualizar Usuário

```dart
Future<void> atualizarUsuario(UsuarioModel usuario) async {
  final datasource = sl<UsuarioSupabaseDatasource>();

  // Modificar dados
  final usuarioAtualizado = usuario.copyWith(
    telefone: '11988888888',
    email: 'novoemail@example.com',
  );

  try {
    await datasource.updateUsuario(usuarioAtualizado);
    log('Usuário atualizado com sucesso');
  } catch (error) {
    log('Erro: $error');
  }
}
```

### 4.6 Deletar Usuário

```dart
Future<void> deletarUsuario(String numeroCadastro) async {
  final datasource = sl<UsuarioSupabaseDatasource>();

  try {
    await datasource.deleteUsuario(numeroCadastro);
    log('Usuário deletado com sucesso');
  } catch (error) {
    log('Erro: $error');
  }
}
```

---

## 5. Tratamento de Erros

### 5.1 Tipos de Erros

**PostgrestException** - Erros do banco de dados:

- `23505`: Violação de constraint único (CPF/email duplicado)
- `PGRST116`: Registro não encontrado

**AuthException** - Erros de autenticação:

- `400`: Credenciais inválidas
- Email já registrado

### 5.2 Exemplo de Tratamento

```dart
try {
  final usuario = await datasource.createUsuario(novoUsuario);
  // Sucesso
} on PostgrestException catch (error) {
  if (error.code == '23505') {
    // CPF ou email já cadastrado
    showError('Este CPF ou email já está em uso');
  } else {
    showError('Erro no banco de dados: ${error.message}');
  }
} on AuthException catch (error) {
  showError('Erro de autenticação: ${error.message}');
} catch (error) {
  showError('Erro inesperado: $error');
}
```

---

## 6. Próximos Passos

Após configurar os datasources:

1. ✅ Criar outros datasources (membros, consultas, cursos, etc.)
2. ✅ Atualizar repositories para usar os novos datasources
3. ✅ Testar todas as operações CRUD
4. ✅ Implementar cache local (opcional)
5. ✅ Adicionar logs e analytics

---

## 📚 Recursos Adicionais

- [Documentação Supabase Flutter](https://supabase.com/docs/reference/dart)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

**Criado em**: 19 de dezembro de 2025  
**Versão**: 1.0
