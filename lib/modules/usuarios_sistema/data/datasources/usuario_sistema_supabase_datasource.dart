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
  Future<void> adicionar(UsuarioSistemaModel usuario) async {
    try {
      final data = usuario.toJson();
      
      // Remove campos que são gerenciados pelo Supabase
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');
      
      // Validar se numero_cadastro existe na tabela usuarios
      if (data['numero_cadastro'] != null && data['numero_cadastro'] != '') {
        final cadastroExiste = await _supabaseService.client
            .from('usuarios')
            .select('numero_cadastro')
            .eq('numero_cadastro', data['numero_cadastro'])
            .maybeSingle();
        
        if (cadastroExiste == null) {
          throw ServerException(
            'Número de cadastro ${data['numero_cadastro']} não encontrado. '
            'Deixe em branco para usuários administrativos ou use um cadastro existente.'
          );
        }
      } else {
        // Remove numero_cadastro se estiver vazio (usuários administrativos)
        data.remove('numero_cadastro');
      }
      
      // Remove senha_hash se estiver vazio
      if (data['senha_hash'] == null || data['senha_hash'] == '') {
        data.remove('senha_hash');
      }
      
      // Remove qualquer campo com nome em camelCase que não deveria existir
      data.removeWhere((key, value) => 
        key.contains(RegExp(r'[A-Z]')) || // Remove qualquer campo com letra maiúscula
        value == null
      );

      print('🔍 [USUARIO_SISTEMA] Dados finais a serem inseridos: $data');
      print('🔍 [USUARIO_SISTEMA] Chaves: ${data.keys.toList()}');

      await _supabaseService.client
          .from('usuarios_sistema')
          .insert(data);
      
      print('✅ [USUARIO_SISTEMA] Usuário adicionado com sucesso');
    } on PostgrestException catch (error) {
      print('❌ [USUARIO_SISTEMA] Erro PostgrestException: ${error.code} - ${error.message}');
      print('❌ [USUARIO_SISTEMA] Details: ${error.details}');
      if (error.code == '23505') {
        throw ServerException('Email já cadastrado');
      }
      if (error.code == '23503') {
        throw ServerException('Número de cadastro inválido. Verifique se o cadastro existe.');
      }
      throw ServerException('Erro ao adicionar usuário: ${error.message}');
    } catch (error) {
      print('❌ [USUARIO_SISTEMA] Erro inesperado: $error');
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<void> atualizar(UsuarioSistemaModel usuario) async {
    try {
      final data = usuario.toJson();
      data.remove('created_at'); // Não atualizar data de criação

      await _supabaseService.client
          .from('usuarios_sistema')
          .update(data)
          .eq('id', usuario.id);
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw ServerException('Email já cadastrado');
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
  Future<UsuarioSistemaModel?> getPorEmailOuUsername(String emailOuUsername) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios_sistema')
          .select()
          .or('email.eq.$emailOuUsername,username.eq.$emailOuUsername')
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
}
