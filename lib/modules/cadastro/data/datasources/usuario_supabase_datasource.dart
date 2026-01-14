import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/string_utils.dart';
import '../models/usuario_model.dart';
import 'usuario_datasource.dart';

/// Datasource para operações de usuários conectado ao Supabase
class UsuarioSupabaseDatasource implements UsuarioDatasource {
  final SupabaseService _supabaseService;

  UsuarioSupabaseDatasource(this._supabaseService);

  /// Contar total de usuários (com filtros opcionais)
  Future<int> countUsuarios({String? status, String? classificacao}) async {
    try {
      // Usar count direto na query
      final response = await _supabaseService.client
          .from('usuarios')
          .select('id')
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao contar usuários: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    try {
      final data = usuario.toJson();

      // Remove campos auto-gerados
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');

      final response = await _supabaseService.client
          .from('usuarios')
          .insert(data)
          .select()
          .single();

      return UsuarioModel.fromJson(response);
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw Exception('CPF ou email já cadastrado');
      }
      throw Exception('Erro ao criar usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado ao criar usuário: $error');
    }
  }

  @override
  Future<void> deleteUsuario(String id) async {
    try {
      await _supabaseService.client.from('usuarios').delete().eq('id', id);
    } on PostgrestException catch (error) {
      throw Exception('Erro ao deletar usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado ao deletar usuário: $error');
    }
  }

  /// Buscar usuário por CPF
  Future<UsuarioModel?> getUsuarioByCpf(String cpf) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .eq('cpf', cpf)
          .maybeSingle();

      if (response == null) return null;
      return UsuarioModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuário por CPF: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioModel> getUsuarioById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .eq('id', id)
          .single();

      return UsuarioModel.fromJson(response);
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST116') {
        throw Exception('Usuário não encontrado');
      }
      throw Exception('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado ao buscar usuário: $error');
    }
  }

  // Métodos adicionais úteis (não fazem parte da interface base)

  /// Buscar usuário por número de cadastro
  Future<UsuarioModel> getUsuarioByNumeroCadastro(String numeroCadastro) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .eq('numero_cadastro', numeroCadastro)
          .single();

      return UsuarioModel.fromJson(response);
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST116') {
        throw Exception('Usuário não encontrado');
      }
      throw Exception('Erro ao buscar usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado ao buscar usuário: $error');
    }
  }

  @override
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      print('🔍 [DATASOURCE] Buscando usuários da tabela "usuarios"...');

      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .order('nome', ascending: true);

      print('📊 [DATASOURCE] Response type: ${response.runtimeType}');
      print('📊 [DATASOURCE] Response length: ${(response as List).length}');

      if (response.isEmpty) {
        print('⚠️ [DATASOURCE] Nenhum dado retornado do Supabase!');
        print('⚠️ [DATASOURCE] Verifique:');
        print('   1. Se a tabela "usuarios" existe');
        print('   2. Se há dados na tabela');
        print('   3. Se as políticas RLS estão configuradas corretamente');
      }

      final usuarios = (response as List)
          .map((json) => UsuarioModel.fromJson(json))
          .toList();

      print(
        '✅ [DATASOURCE] ${usuarios.length} usuários convertidos com sucesso',
      );

      return usuarios;
    } on PostgrestException catch (error) {
      print('❌ [DATASOURCE] PostgrestException: ${error.message}');
      print('❌ [DATASOURCE] Code: ${error.code}');
      print('❌ [DATASOURCE] Details: ${error.details}');
      throw Exception('Erro ao buscar usuários: ${error.message}');
    } catch (error) {
      print('❌ [DATASOURCE] Erro inesperado: $error');
      throw Exception('Erro inesperado ao buscar usuários: $error');
    }
  }

  /// Buscar usuários por núcleo
  Future<List<UsuarioModel>> getUsuariosByNucleo(String nucleo) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .eq('nucleo_pertence', nucleo)
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => UsuarioModel.fromJson(json))
          .toList();
    } on PostgrestException catch (error) {
      throw Exception('Erro ao buscar usuários por núcleo: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado: $error');
    }
  }

  /// Buscar usuários por status
  Future<List<UsuarioModel>> getUsuariosByStatus(String status) async {
    try {
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .eq('status_atual', status)
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => UsuarioModel.fromJson(json))
          .toList();
    } on PostgrestException catch (error) {
      throw Exception('Erro ao buscar usuários por status: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado: $error');
    }
  }

  /// Buscar usuários por nome (busca parcial, sem acentos)
  Future<List<UsuarioModel>> searchUsuariosByNome(String nome) async {
    try {
      // Normalizar termo de busca
      final nomeNormalizado = normalizarParaBusca(nome);

      // Buscar todos os usuários e filtrar localmente para busca sem acentos
      final response = await _supabaseService.client
          .from('usuarios')
          .select()
          .order('nome', ascending: true);

      final usuarios = (response as List)
          .map((json) => UsuarioModel.fromJson(json))
          .toList();

      // Filtrar por nome normalizado
      return usuarios
          .where((u) => normalizarParaBusca(u.nome).contains(nomeNormalizado))
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar usuários: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  @override
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario) async {
    try {
      if (usuario.id == null) {
        throw Exception('ID é obrigatório para atualização');
      }

      final data = usuario.toJson();

      // Remove campos que não devem ser atualizados
      data.remove('created_at');

      final response = await _supabaseService.client
          .from('usuarios')
          .update(data)
          .eq('id', usuario.id!)
          .select()
          .single();

      return UsuarioModel.fromJson(response);
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw Exception('CPF ou email já cadastrado');
      }
      throw Exception('Erro ao atualizar usuário: ${error.message}');
    } catch (error) {
      throw Exception('Erro inesperado ao atualizar usuário: $error');
    }
  }
}
