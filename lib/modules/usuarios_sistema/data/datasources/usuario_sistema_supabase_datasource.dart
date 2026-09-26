import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/usuario_sistema_model.dart';
import 'usuario_sistema_datasource.dart';

/// Datasource de usuários do sistema conectado ao Supabase
class UsuarioSistemaSupabaseDatasource implements UsuarioSistemaDatasource {
  final SupabaseService _supabaseService;

  UsuarioSistemaSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(
    UsuarioSistemaModel usuario, {
    required String password,
  }) async {
    try {
      final response = await _supabaseService.client.functions.invoke(
        'admin-create-user',
        body: {
          'nome': usuario.nome,
          'email': usuario.email.trim().toLowerCase(),
          'username': usuario.username,
          'password': password,
          'numero_cadastro': usuario.numeroCadastro,
          'nivel_permissao': usuario.nivelPermissao,
          'ativo': usuario.ativo,
          'observacoes': usuario.observacoes,
        },
      );

      if (response.status < 200 || response.status >= 300) {
        throw ServerException(_mensagemFuncao(response.data));
      }
    } on FunctionException catch (error) {
      throw ServerException(_mensagemFuncao(error.details));
    } catch (error) {
      log('Erro ao criar usuário autenticado: $error');
      if (error is ServerException) rethrow;
      throw ServerException(
        'Não foi possível criar o usuário. Tente novamente.',
      );
    }
  }

  @override
  Future<void> atualizar(UsuarioSistemaModel usuario) async {
    try {
      final data = usuario.toJson();
      data.remove('id'); // O ID já é usado no filtro da atualização
      data.remove('created_at'); // Não atualizar data de criação
      data.remove(
        'email',
      ); // O email de Auth não é alterado pelo formulário de perfil
      data.remove('senha_hash');

      await _supabaseService.client
          .from('usuarios_sistema')
          .update(data)
          .eq('id', usuario.id);
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw ServerException(
          'Email ou nome de usuário já cadastrado. Use outro valor.',
        );
      }
      if (error.code == '23503') {
        throw ServerException(
          'Número de cadastro inválido. Verifique se o cadastro existe.',
        );
      }
      throw ServerException('Erro ao atualizar usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorCadastro(String numeroCadastro) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('numero_cadastro', numeroCadastro)
          .maybeSingle();

      if (response == null) return null;
      return UsuarioSistemaModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorEmail(String email) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) return null;
      return UsuarioSistemaModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorEmailOuUsername(
    String emailOuUsername,
  ) async {
    final byEmail = await getPorEmail(emailOuUsername);
    if (byEmail != null) return byEmail;
    return getPorUsername(emailOuUsername.toLowerCase());
  }

  @override
  Future<UsuarioSistemaModel?> getPorId(String id) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return UsuarioSistemaModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioSistemaModel?> getPorUsername(String username) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (response == null) return null;
      return UsuarioSistemaModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<List<UsuarioSistemaModel>> getTodos() async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => UsuarioSistemaModel.fromJson(json))
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuários: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<void> remover(String id) async {
    try {
      await _supabaseService.client
          .from('usuarios_sistema')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao remover usuário: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  String _mensagemFuncao(Object? details) {
    if (details is Map && details['error'] is String) {
      return details['error'] as String;
    }
    return 'Não foi possível criar o usuário.';
  }
}
