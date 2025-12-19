import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/usuario_sistema.dart';
import 'auth_datasource.dart';
import '../models/usuario_sistema_model.dart';

/// Datasource para autenticação usando Supabase Auth
class AuthSupabaseDatasource implements AuthDatasource {
  final SupabaseService _supabaseService;

  AuthSupabaseDatasource(this._supabaseService);

  @override
  Future<UsuarioSistemaModel> login(String emailOrLogin, String senha) async {
    try {
      // Para compatibilidade, aceita email ou login
      String email = emailOrLogin;
      
      // Se não parece ser email, buscar email pelo login
      if (!emailOrLogin.contains('@')) {
        final userData = await _supabaseService.client
            .from('usuarios_sistema')
            .select('email')
            .eq('numero_cadastro', emailOrLogin)
            .maybeSingle();
        
        if (userData != null) {
          email = userData['email'] as String;
        }
      }

      // 1. Autenticar com Supabase Auth
      final authResponse = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );

      if (authResponse.user == null) {
        throw Exception('Falha na autenticação');
      }

      // 2. Buscar dados do usuário na tabela usuarios_sistema
      final userData = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('email', email)
          .single();

      // 3. Atualizar último acesso
      await _supabaseService.client
          .from('usuarios_sistema')
          .update({'ultimo_acesso': DateTime.now().toIso8601String()})
          .eq('email', email);

      // 4. Converter para UsuarioSistemaModel
      final nivelPermissao = userData['nivel_permissao'] as int;
      final nivelAcesso = NivelAcesso.values[(nivelPermissao - 1).clamp(0, 3)];
      
      return UsuarioSistemaModel(
        id: userData['id'] as String,
        nome: userData['nome'] as String,
        login: userData['numero_cadastro'] as String? ?? email,
        email: userData['email'] as String,
        nivelAcesso: nivelAcesso,
      );
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        throw Exception('Email ou senha incorretos');
      }
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
}
