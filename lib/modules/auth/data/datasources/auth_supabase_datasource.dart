import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/usuario_sistema.dart';
import '../models/usuario_sistema_model.dart';
import 'auth_datasource.dart';

/// Datasource para autenticação usando Supabase Auth
class AuthSupabaseDatasource implements AuthDatasource {
  final SupabaseService _supabaseService;

  AuthSupabaseDatasource(this._supabaseService);

  @override
  Future<UsuarioSistemaModel?> getUsuarioLogado() async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      final userData = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('email', user.email!)
          .single();

      if (userData['ativo'] != true) {
        await _supabaseService.client.auth.signOut();
        return null;
      }

      final nivelPermissao = userData['nivel_permissao'] as int;
      final nivelAcesso = NivelAcesso.values[(nivelPermissao - 1).clamp(0, 3)];

      return UsuarioSistemaModel(
        id: userData['id'] as String,
        nome: userData['nome'] as String,
        login: userData['numero_cadastro'] as String? ?? user.email!,
        email: userData['email'] as String,
        nivelAcesso: nivelAcesso,
      );
    } on PostgrestException catch (error) {
      throw Exception('Erro ao buscar usuário atual: ${error.message}');
    } catch (error) {
      return null;
    }
  }

  @override
  Future<UsuarioSistemaModel> login(String emailOrLogin, String senha) async {
    try {
      final response = await _supabaseService.client.functions.invoke(
        'public-login',
        body: {'login': emailOrLogin.trim(), 'password': senha},
      );
      final data = response.data;
      if (response.status < 200 || response.status >= 300 || data is! Map) {
        final message = data is Map && data['error'] is String
            ? data['error'] as String
            : 'Login ou senha inválidos';
        throw Exception(message);
      }

      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      if (accessToken is! String || refreshToken is! String) {
        throw Exception('Falha na autenticação');
      }

      await _supabaseService.client.auth.setSession(refreshToken);

      final authUser = _supabaseService.client.auth.currentUser;
      if (authUser == null || authUser.email == null) {
        throw Exception('Falha ao iniciar a sessão autenticada');
      }

      final userData = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('email', authUser.email!)
          .single();

      if (userData['ativo'] != true) {
        await _supabaseService.client.auth.signOut();
        throw Exception('Este usuário está inativo. Contate um administrador.');
      }

      await _supabaseService.client
          .from('usuarios_sistema')
          .update({'ultimo_acesso': DateTime.now().toIso8601String()})
          .eq('email', authUser.email!);

      final nivelPermissao = userData['nivel_permissao'] as int;
      final nivelAcesso = NivelAcesso.values[(nivelPermissao - 1).clamp(0, 3)];

      return UsuarioSistemaModel(
        id: userData['id'] as String,
        nome: userData['nome'] as String,
        login: userData['numero_cadastro'] as String? ?? authUser.email!,
        email: userData['email'] as String,
        nivelAcesso: nivelAcesso,
      );
    } on FunctionException catch (error) {
      final details = error.details;
      if (details is Map && details['error'] is String) {
        throw Exception(details['error'] as String);
      }
      throw Exception('Não foi possível autenticar agora.');
    } on AuthException catch (error) {
      throw Exception('Erro de autenticação: ${error.message}');
    } on PostgrestException catch (error) {
      throw Exception('Erro ao buscar dados do usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado no login: $error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseService.client.auth.signOut();
    } on AuthException catch (error) {
      throw Exception('Erro ao fazer logout: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado no logout: $error');
    }
  }
}
