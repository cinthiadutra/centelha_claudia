import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/presenca_registro.dart';

/// Repository para acessar dados do calendário 2026 no Supabase
class CalendarioRepository {
  final SupabaseClient _supabase;

  CalendarioRepository(this._supabase);

  /// Busca atividades por data específica
  Future<List<AtividadeCalendario2026>> buscarPorData(DateTime data) async {
    try {
      // Converter data para formato do banco: "26-1-1" (ano-mes-dia sem zeros)
      final ano = (data.year % 100).toString(); // 2026 -> 26
      final mes = data.month.toString();
      final dia = data.day.toString();
      final dataStr = '$ano-$mes-$dia';

      final response =
          await _supabase.from('calendario_2026').select().eq('data', dataStr);

      return (response as List)
          .map((json) => _atividadeFromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar atividades por data: $e');
    }
  }

  /// Busca atividade por ID
  Future<AtividadeCalendario2026?> buscarPorId(String id) async {
    try {
      final response = await _supabase
          .from('calendario_2026')
          .select()
          .eq('id', id)
          .single();

      return _atividadeFromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Busca atividades por mês
  Future<List<AtividadeCalendario2026>> buscarPorMes(int mes, int ano) async {
    try {
      final todasAtividades = await buscarTodasAtividades();

      return todasAtividades.where((atividade) {
        final dataAtividade = atividade.dataAsDateTime;
        if (dataAtividade == null) return false;
        return dataAtividade.month == mes && dataAtividade.year == ano;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar atividades por mês: $e');
    }
  }

  /// Busca atividades por período
  Future<List<AtividadeCalendario2026>> buscarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final todasAtividades = await buscarTodasAtividades();

      return todasAtividades.where((atividade) {
        final dataAtividade = atividade.dataAsDateTime;
        if (dataAtividade == null) return false;

        return (dataAtividade
                .isAfter(inicio.subtract(const Duration(days: 1))) &&
            dataAtividade.isBefore(fim.add(const Duration(days: 1))));
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar atividades por período: $e');
    }
  }

  /// Busca todas as atividades do calendário 2026
  Future<List<AtividadeCalendario2026>> buscarTodasAtividades() async {
    try {
      final response = await _supabase
          .from('calendario_2026')
          .select()
          .order('data', ascending: true);

      return (response as List)
          .map((json) => _atividadeFromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar atividades do calendário: $e');
    }
  }

  AtividadeCalendario2026 _atividadeFromJson(Map<String, dynamic> json) {
    return AtividadeCalendario2026(
      id: json['id']?.toString(),
      data: json['data']?.toString() ?? '',
      diaSemana: json['dia_semana']?.toString(),
      nucleo: json['nucleo']?.toString(),
      inicio: json['inicio']?.toString(),
      atividade: json['atividade']?.toString(),
      vibracoes: json['vibracoes']?.toString(),
      responsavel: json['responsavel']?.toString(),
      gruposTrabalho: json['grupos_trabalho']?.toString(),
      vibracaoNumero: json['vibracao_numero'] != null
          ? int.tryParse(json['vibracao_numero'].toString())
          : null,
    );
  }
}
