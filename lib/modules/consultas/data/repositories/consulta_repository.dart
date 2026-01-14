import '../../domain/entities/consulta.dart';
import '../datasources/consulta_datasource.dart';
import '../models/consulta_model.dart';

/// Repository para operações com consultas
abstract class ConsultaRepository {
  Future<void> adicionarConsulta(Consulta consulta);
  Future<String> gerarProximoNumero();
  Future<Consulta?> getConsultaPorNumero(String numero);
  Future<List<Consulta>> getConsultas();
  Future<List<Consulta>> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  });
}

/// Implementação do repository
class ConsultaRepositoryImpl implements ConsultaRepository {
  final ConsultaDatasource datasource;

  ConsultaRepositoryImpl(this.datasource);

  @override
  Future<void> adicionarConsulta(Consulta consulta) async {
    final model = ConsultaModel.fromEntity(consulta);
    await datasource.adicionarConsulta(model);
  }

  @override
  String gerarProximoNumero() {
    return datasource.gerarProximoNumero();
  }

  @override
  Future<Consulta?> getConsultaPorNumero(String numero) async {
    return await datasource.getConsultaPorNumero(numero);
  }

  @override
  Future<List<Consulta>> getConsultas() async {
    return await datasource.getConsultas();
  }

  @override
  Future<List<Consulta>> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  }) async {
    return await datasource.pesquisarConsultas(
      cadastroConsulente: cadastroConsulente,
      cadastroMedium: cadastroMedium,
      nomeEntidade: nomeEntidade,
    );
  }
}
