import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/presenca_registro.dart';

/// Repository para gerenciar registros de presença no Supabase
class PresencaRepository {
  final SupabaseClient _supabase;

  PresencaRepository(this._supabase);

  /// Atualiza um registro de presença
  Future<PresencaRegistro> atualizar(PresencaRegistro registro) async {
    if (registro.id == null) {
      throw Exception('ID do registro é obrigatório para atualização');
    }

    try {
      final data = {
        'membro_id': registro.membroId,
        'atividade_id': registro.atividadeId,
        'data_hora': registro.dataHora.toIso8601String(),
        'presente': registro.presente,
        'codigo': registro.codigo,
        'nome_registrado': registro.nomeRegistrado,
        'justificativa': registro.justificativa,
      };

      final response = await _supabase
          .from('registros_presenca')
          .update(data)
          .eq('id', registro.id!)
          .select()
          .single();

      return _presencaFromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar registro de presença: $e');
    }
  }

  /// Busca registros de presença por atividade
  Future<List<PresencaRegistro>> buscarPorAtividade(String atividadeId) async {
    try {
      final response = await _supabase
          .from('registros_presenca')
          .select()
          .eq('atividade_id', atividadeId)
          .order('data_hora', ascending: true);

      return (response as List).map((json) => _presencaFromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar registros por atividade: $e');
    }
  }

  /// Busca registros de presença por membro
  Future<List<PresencaRegistro>> buscarPorMembro(String membroId) async {
    try {
      final response = await _supabase
          .from('registros_presenca')
          .select()
          .eq('membro_id', membroId)
          .order('data_hora', ascending: false);

      return (response as List).map((json) => _presencaFromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar registros por membro: $e');
    }
  }

  /// Busca registros de presença por período
  Future<List<PresencaRegistro>> buscarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final response = await _supabase
          .from('registros_presenca')
          .select()
          .gte('data_hora', inicio.toIso8601String())
          .lte('data_hora', fim.toIso8601String())
          .order('data_hora', ascending: true);

      return (response as List).map((json) => _presencaFromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar registros por período: $e');
    }
  }

  /// Deleta um registro de presença
  Future<void> deletar(String id) async {
    try {
      await _supabase.from('registros_presenca').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao deletar registro de presença: $e');
    }
  }

  /// Verifica se já existe registro para membro e atividade
  Future<bool> existeRegistro(String membroId, String atividadeId) async {
    try {
      final response = await _supabase
          .from('registros_presenca')
          .select('id')
          .eq('membro_id', membroId)
          .eq('atividade_id', atividadeId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Salva um registro de presença
  Future<PresencaRegistro> salvar(PresencaRegistro registro) async {
    try {
      final data = {
        'membro_id': registro.membroId,
        'atividade_id': registro.atividadeId,
        'data_hora': registro.dataHora.toIso8601String(),
        'presente': registro.presente,
        'codigo': registro.codigo,
        'nome_registrado': registro.nomeRegistrado,
        'justificativa': registro.justificativa,
      };

      final response = await _supabase
          .from('registros_presenca')
          .insert(data)
          .select()
          .single();

      return _presencaFromJson(response);
    } catch (e) {
      throw Exception('Erro ao salvar registro de presença: $e');
    }
  }

  /// Salva múltiplos registros de presença
  Future<List<PresencaRegistro>> salvarLote(
    List<PresencaRegistro> registros,
  ) async {
    try {
      final dataList = registros.map((registro) {
        return {
          'membro_id': registro.membroId,
          'atividade_id': registro.atividadeId,
          'data_hora': registro.dataHora.toIso8601String(),
          'presente': registro.presente,
          'codigo': registro.codigo,
          'nome_registrado': registro.nomeRegistrado,
          'justificativa': registro.justificativa,
        };
      }).toList();

      final response =
          await _supabase.from('registros_presenca').insert(dataList).select();

      return (response as List).map((json) => _presencaFromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao salvar lote de registros: $e');
    }
  }

  PresencaRegistro _presencaFromJson(Map<String, dynamic> json) {
    return PresencaRegistro(
      id: json['id']?.toString(),
      membroId: json['membro_id']?.toString() ?? '',
      atividadeId: json['atividade_id']?.toString() ?? '',
      dataHora: DateTime.parse(json['data_hora']),
      presente: json['presente'] ?? false,
      codigo: json['codigo']?.toString(),
      nomeRegistrado: json['nome_registrado']?.toString(),
      justificativa: json['justificativa']?.toString(),
    );
  }
}
