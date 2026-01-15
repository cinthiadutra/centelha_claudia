import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/dia_sessao.dart';

/// Datasource para operações com dias de sessão
class DiaSessaoSupabaseDatasource {
  final SupabaseService _supabaseService;

  DiaSessaoSupabaseDatasource(this._supabaseService);

  Future<void> adicionar(DiaSessao diaSessao) async {
    try {
      await _supabaseService.client.from('dia_sessao').insert(diaSessao.toJson());
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw ServerException('Código já cadastrado');
      }
      throw ServerException('Erro ao adicionar dia de sessão: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> atualizar(DiaSessao diaSessao) async {
    try {
      await _supabaseService.client
          .from('dia_sessao')
          .update(diaSessao.toJson())
          .eq('id', diaSessao.id!);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao atualizar dia de sessão: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> desativar(String id) async {
    try {
      await _supabaseService.client
          .from('dia_sessao')
          .update({'ativo': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao desativar dia de sessão: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<DiaSessao?> getPorId(String id) async {
    try {
      final response = await _supabaseService.client
          .from('dia_sessao')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return DiaSessao.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar dia de sessão: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<List<DiaSessao>> getTodos({bool? apenasAtivos, String? nucleo}) async {
    try {
      var query = _supabaseService.client.from('dia_sessao').select();

      if (apenasAtivos == true) {
        query = query.eq('ativo', true);
      }

      if (nucleo != null) {
        query = query.eq('nucleo', nucleo);
      }

      final response = await query.order('nucleo').order('dia');

      return (response as List).map((json) => DiaSessao.fromJson(json)).toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar dias de sessão: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }
}
