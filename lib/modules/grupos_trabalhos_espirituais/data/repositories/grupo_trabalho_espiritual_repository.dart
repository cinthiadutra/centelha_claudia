import '../../domain/entities/grupo_trabalho_espiritual_membro.dart';
import '../datasources/grupo_trabalho_espiritual_datasource.dart';
import '../models/grupo_trabalho_espiritual_membro_model.dart';

/// Interface do repositório
abstract class GrupoTrabalhoEspiritualRepository {
  Future<List<GrupoTrabalhoEspiritualMembro>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  });
  Future<GrupoTrabalhoEspiritualMembro?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoTrabalhoEspiritualMembro>> getTodos();
  Future<void> remover(String numeroCadastro);
  Future<void> salvar(GrupoTrabalhoEspiritualMembro membro);
}

/// Implementação do repositório
class GrupoTrabalhoEspiritualRepositoryImpl implements GrupoTrabalhoEspiritualRepository {
  final GrupoTrabalhoEspiritualDatasource datasource;

  GrupoTrabalhoEspiritualRepositoryImpl(this.datasource);

  @override
  Future<List<GrupoTrabalhoEspiritualMembro>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  }) async {
    return await datasource.filtrar(
      atividadeEspiritual: atividadeEspiritual,
      grupoTrabalho: grupoTrabalho,
      funcao: funcao,
    );
  }

  @override
  Future<GrupoTrabalhoEspiritualMembro?> getPorCadastro(String numeroCadastro) async {
    return await datasource.getPorCadastro(numeroCadastro);
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembro>> getTodos() async {
    return await datasource.getTodos();
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    await datasource.remover(numeroCadastro);
  }

  @override
  Future<void> salvar(GrupoTrabalhoEspiritualMembro membro) async {
    final model = GrupoTrabalhoEspiritualMembroModel.fromEntity(membro);
    final existe = await datasource.getPorCadastro(membro.numeroCadastro);

    if (existe != null) {
      await datasource.atualizar(model);
    } else {
      await datasource.adicionar(model);
    }
  }
}
