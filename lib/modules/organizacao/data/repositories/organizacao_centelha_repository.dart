import '../../domain/entities/organizacao_centelha.dart';
import '../datasources/organizacao_centelha_datasource.dart';
import '../models/organizacao_centelha_model.dart';

/// Interface do repositório
abstract class OrganizacaoCentelhaRepository {
  Future<void> atualizar(OrganizacaoCentelha organizacao);
  Future<OrganizacaoCentelha> getOrganizacao();
}

/// Implementação do repositório
class OrganizacaoCentelhaRepositoryImpl implements OrganizacaoCentelhaRepository {
  final OrganizacaoCentelhaDatasource datasource;

  OrganizacaoCentelhaRepositoryImpl(this.datasource);

  @override
  Future<void> atualizar(OrganizacaoCentelha organizacao) async {
    final model = OrganizacaoCentelhaModel.fromEntity(organizacao);
    await datasource.atualizar(model);
  }

  @override
  Future<OrganizacaoCentelha> getOrganizacao() async {
    return await datasource.getOrganizacao();
  }
}
