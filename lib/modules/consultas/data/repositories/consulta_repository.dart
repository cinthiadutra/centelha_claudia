import '../../domain/entities/consulta.dart';
import '../datasources/consulta_datasource.dart';
import '../models/consulta_model.dart';

/// Repository para operações com consultas
abstract class ConsultaRepository {
  List<Consulta> getConsultas();
  Consulta? getConsultaPorNumero(String numero);
  List<Consulta> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  });
  void adicionarConsulta(Consulta consulta);
  String gerarProximoNumero();
}

/// Implementação do repository
class ConsultaRepositoryImpl implements ConsultaRepository {
  final ConsultaDatasource datasource;

  ConsultaRepositoryImpl(this.datasource);

  @override
  List<Consulta> getConsultas() {
    return datasource.getConsultas();
  }

  @override
  Consulta? getConsultaPorNumero(String numero) {
    return datasource.getConsultaPorNumero(numero);
  }

  @override
  List<Consulta> pesquisarConsultas({
    String? cadastroConsulente,
    String? cadastroMedium,
    String? nomeEntidade,
  }) {
    return datasource.pesquisarConsultas(
      cadastroConsulente: cadastroConsulente,
      cadastroMedium: cadastroMedium,
      nomeEntidade: nomeEntidade,
    );
  }

  @override
  void adicionarConsulta(Consulta consulta) {
    final model = ConsultaModel.fromEntity(consulta);
    datasource.adicionarConsulta(model);
  }

  @override
  String gerarProximoNumero() {
    return datasource.gerarProximoNumero();
  }
}
