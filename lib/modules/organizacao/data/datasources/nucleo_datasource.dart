import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/nucleo.dart';

/// Datasource para operações com núcleos
class NucleoSupabaseDatasource {
  final SupabaseService _supabaseService;

  NucleoSupabaseDatasource(this._supabaseService);

  Future<void> adicionar(Nucleo nucleo) async {
    try {
      await _supabaseService.client.from('nucleos').insert(nucleo.toJson());
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw ServerException('Código ou sigla já cadastrado');
      }
      throw ServerException('Erro ao adicionar núcleo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> atualizar(Nucleo nucleo) async {
    try {
      await _supabaseService.client
          .from('nucleos')
          .update(nucleo.toJson())
          .eq('cod', nucleo.cod);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao atualizar núcleo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> desativar(String cod) async {
    try {
      await _supabaseService.client
          .from('nucleos')
          .update({'ativo': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('cod', cod);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao desativar núcleo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<Nucleo?> getPorCod(String cod) async {
    try {
      final response = await _supabaseService.client
          .from('nucleos')
          .select()
          .eq('cod', cod)
          .maybeSingle();

      if (response == null) return null;
      return Nucleo.fromJson(response);
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar núcleo: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<List<Nucleo>> getTodos({bool? apenasAtivos}) async {
    try {
      var query = _supabaseService.client.from('nucleos').select();

      if (apenasAtivos == true) {
        query = query.eq('ativo', true);
      }

      final response = await query.order('cod', ascending: true);

      return (response as List).map((json) => Nucleo.fromJson(json)).toList();
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar núcleos: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }
}
