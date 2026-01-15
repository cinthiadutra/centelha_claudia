import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/classificacao_mediunica.dart';

/// Datasource para operações com classificações mediúnicas
class ClassificacaoMediunicaSupabaseDatasource {
  final SupabaseService _supabaseService;

  ClassificacaoMediunicaSupabaseDatasource(this._supabaseService);

  Future<void> adicionar(ClassificacaoMediunica classificacao) async {
    try {
      await _supabaseService.client
          .from('classificacao_mediunica')
          .insert(classificacao.toJson());
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw ServerException('Código ou nome já cadastrado');
      }
      throw ServerException('Erro ao adicionar classificação: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> atualizar(ClassificacaoMediunica classificacao) async {
    try {
      await _supabaseService.client
          .from('classificacao_mediunica')
          .update(classificacao.toJson())
          .eq('id', classificacao.id!);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao atualizar classificação: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> desativar(String id) async {
    try {
      await _supabaseService.client
          .from('classificacao_mediunica')
          .update({'ativo': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao desativar classificação: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<ClassificacaoMediunica?> getPorId(String id) async {
    try {
      final response = await _supabaseService.client
          .from('classificacao_mediunica')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return ClassificacaoMediunica.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar classificação: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<List<ClassificacaoMediunica>> getTodos({bool? apenasAtivos, String? tipo}) async {
    try {
      var query = _supabaseService.client.from('classificacao_mediunica').select();

      if (apenasAtivos == true) {
        query = query.eq('ativo', true);
      }

      if (tipo != null) {
        query = query.eq('tipo', tipo);
      }

      final response = await query.order('ordem', ascending: true);

      return (response as List)
          .map((json) => ClassificacaoMediunica.fromJson(json))
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar classificações: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }
}
