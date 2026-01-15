import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/grupo.dart';

/// Datasource para operações com grupos
class GrupoSupabaseDatasource {
  final SupabaseService _supabaseService;

  GrupoSupabaseDatasource(this._supabaseService);

  Future<List<Grupo>> getTodos({bool? apenasAtivos, String? tipo}) async {
    try {
      var query = _supabaseService.client.from('grupos').select();

      if (apenasAtivos == true) {
        query = query.eq('ativo', true);
      }

      if (tipo != null) {
        query = query.eq('tipo', tipo);
      }

      final response = await query.order('tipo').order('nome');

      return (response as List).map((json) => Grupo.fromJson(json)).toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar grupos: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<Grupo?> getPorId(String id) async {
    try {
      final response = await _supabaseService.client
          .from('grupos')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return Grupo.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar grupo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> adicionar(Grupo grupo) async {
    try {
      await _supabaseService.client.from('grupos').insert(grupo.toJson());
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao adicionar grupo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> atualizar(Grupo grupo) async {
    try {
      await _supabaseService.client
          .from('grupos')
          .update(grupo.toJson())
          .eq('id', grupo.id!);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao atualizar grupo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> desativar(String id) async {
    try {
      await _supabaseService.client
          .from('grupos')
          .update({'ativo': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao desativar grupo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }
}
