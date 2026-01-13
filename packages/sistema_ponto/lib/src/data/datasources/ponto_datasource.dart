import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/registro_ponto_model.dart';

abstract class PontoDatasource {
  Future<RegistroPontoModel> atualizarPonto(RegistroPontoModel registro);
  Future<List<RegistroPontoModel>> obterHistorico({
    required String membroId,
    DateTime? dataInicio,
    DateTime? dataFim,
  });
  Future<List<RegistroPontoModel>> obterPontosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  });
  Future<RegistroPontoModel?> obterUltimoPonto(String membroId);
  Future<RegistroPontoModel> registrarPonto(RegistroPontoModel registro);
  Future<void> removerPonto(String id);
}

class SupabasePontoDatasource implements PontoDatasource {
  final SupabaseClient client;

  SupabasePontoDatasource(this.client);

  @override
  Future<RegistroPontoModel> atualizarPonto(RegistroPontoModel registro) async {
    try {
      final data = await client
          .from('registros_ponto')
          .update(registro.toJson())
          .eq('id', registro.id!)
          .select()
          .single();

      return RegistroPontoModel.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar ponto: $e');
    }
  }

  @override
  Future<List<RegistroPontoModel>> obterHistorico({
    required String membroId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      dynamic query = client
          .from('registros_ponto')
          .select()
          .eq('membro_id', membroId);

      if (dataInicio != null) {
        query = query.filter('data_hora', 'gte', dataInicio.toIso8601String());
      }

      if (dataFim != null) {
        query = query.filter('data_hora', 'lte', dataFim.toIso8601String());
      }

      query = query.order('data_hora', ascending: false);

      final data = await query;

      return (data as List)
          .map((json) => RegistroPontoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao obter histórico: $e');
    }
  }

  @override
  Future<List<RegistroPontoModel>> obterPontosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final data = await client
          .from('registros_ponto')
          .select()
          .filter('data_hora', 'gte', dataInicio.toIso8601String())
          .filter('data_hora', 'lte', dataFim.toIso8601String())
          .order('data_hora', ascending: false);

      return (data as List)
          .map((json) => RegistroPontoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao obter pontos por período: $e');
    }
  }

  @override
  Future<RegistroPontoModel?> obterUltimoPonto(String membroId) async {
    try {
      final data = await client
          .from('registros_ponto')
          .select()
          .eq('membro_id', membroId)
          .order('data_hora', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data == null) return null;

      return RegistroPontoModel.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao obter último ponto: $e');
    }
  }

  @override
  Future<RegistroPontoModel> registrarPonto(RegistroPontoModel registro) async {
    try {
      final data = await client
          .from('registros_ponto')
          .insert(registro.toJson())
          .select()
          .single();

      return RegistroPontoModel.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao registrar ponto: $e');
    }
  }

  @override
  Future<void> removerPonto(String id) async {
    try {
      await client.from('registros_ponto').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao remover ponto: $e');
    }
  }
}
