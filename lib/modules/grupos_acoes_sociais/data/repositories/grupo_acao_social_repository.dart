import '../../domain/entities/grupo_acao_social_membro.dart';
import '../datasources/grupo_acao_social_datasource.dart';
import '../models/grupo_acao_social_membro_model.dart';

/// Interface do repositório
abstract class GrupoAcaoSocialRepository {
  Future<List<GrupoAcaoSocialMembro>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  });
  Future<GrupoAcaoSocialMembro?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoAcaoSocialMembro>> getTodos();
  Future<void> remover(String numeroCadastro);
  Future<void> salvar(GrupoAcaoSocialMembro membro);
}

/// Implementação do repositório
class GrupoAcaoSocialRepositoryImpl implements GrupoAcaoSocialRepository {
  final GrupoAcaoSocialDatasource datasource;

  GrupoAcaoSocialRepositoryImpl(this.datasource);

  @override
  Future<List<GrupoAcaoSocialMembro>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) async {
    return await datasource.filtrar(
      grupoAcaoSocial: grupoAcaoSocial,
      funcao: funcao,
    );
  }

  @override
  Future<GrupoAcaoSocialMembro?> getPorCadastro(String numeroCadastro) async {
    return await datasource.getPorCadastro(numeroCadastro);
  }

  @override
  Future<List<GrupoAcaoSocialMembro>> getTodos() async {
    return await datasource.getTodos();
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    await datasource.remover(numeroCadastro);
  }

  @override
  Future<void> salvar(GrupoAcaoSocialMembro membro) async {
    final model = GrupoAcaoSocialMembroModel.fromEntity(membro);
    final existe = await datasource.getPorCadastro(membro.numeroCadastro);

    if (existe != null) {
      await datasource.atualizar(model);
    } else {
      await datasource.adicionar(model);
    }
  }
}
