import '../../../../core/services/supabase_service.dart';
import '../models/consulta_model.dart';

/// Datasource para operações com consultas
abstract class ConsultaDatasource {
  Future<void> adicionarConsulta(ConsultaModel consulta);
  Future<String> gerarProximoNumero();
  Future<ConsultaModel?> getConsultaPorNumero(String numero);
  Future<List<ConsultaModel>> getConsultas();
  Future<List<ConsultaModel>> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  });
}

/// Implementação com Supabase
class ConsultaDatasourceImpl implements ConsultaDatasource {
  final supabase = SupabaseService.instance.client;

  @override
  Future<void> adicionarConsulta(ConsultaModel consulta) async {
    try {
      await supabase.from('consultas').insert(consulta.toJson());
    } catch (e) {
      print('Erro ao adicionar consulta: $e');
      rethrow;
    }
  }

  @override
  Future<String> gerarProximoNumero() async {
    try {
      final response = await supabase
          .from('consultas')
          .select('numero_consulta')
          .order('numero_consulta', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return '1';

      final ultimoNumero =
          int.tryParse(response['numero_consulta'] ?? '0') ?? 0;
      return (ultimoNumero + 1).toString();
    } catch (e) {
      print('Erro ao gerar próximo número: $e');
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  @override
  Future<ConsultaModel?> getConsultaPorNumero(String numero) async {
    try {
      final response = await supabase
          .from('consultas')
          .select()
          .eq('numero_consulta', numero)
          .maybeSingle();

      if (response == null) return null;
      return ConsultaModel.fromJson(response);
    } catch (e) {
      print('Erro ao buscar consulta: $e');
      return null;
    }
  }

  @override
  Future<List<ConsultaModel>> getConsultas() async {
    try {
      final response = await supabase
          .from('consultas')
          .select()
          .order('data_consulta', ascending: false);

      return (response as List)
          .map((json) => ConsultaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Erro ao carregar consultas: $e');
      return [];
    }
  }

  @override
  Future<List<ConsultaModel>> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  }) async {
    try {
      var query = supabase.from('consultas').select();

      if (cadastroConsulente != null && cadastroConsulente.isNotEmpty) {
        query = query.eq('cadastro_consulente', cadastroConsulente);
      }

      if (nomeEntidade != null && nomeEntidade.isNotEmpty) {
        query = query.ilike('atendente', '%$nomeEntidade%');
      }

      final response = await query.order('data_consulta', ascending: false);

      return (response as List)
          .map((json) => ConsultaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Erro ao pesquisar consultas: $e');
      return [];
    }
  }
}
