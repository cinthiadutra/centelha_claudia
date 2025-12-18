import '../../domain/entities/grupo_tarefa_membro.dart';
import '../datasources/grupo_tarefa_datasource.dart';
import '../models/grupo_tarefa_membro_model.dart';

/// Repository para operações com grupos-tarefas
abstract class GrupoTarefaRepository {
  void adicionar(GrupoTarefaMembro membro);
  void atualizar(GrupoTarefaMembro membro);
  List<GrupoTarefaMembro> filtrar({String? grupoTarefa, String? funcao});
  GrupoTarefaMembro? getPorCadastro(String numeroCadastro);
  List<GrupoTarefaMembro> getTodos();
  void remover(String numeroCadastro);
}

/// Implementação do repository
class GrupoTarefaRepositoryImpl implements GrupoTarefaRepository {
  final GrupoTarefaDatasource datasource;

  GrupoTarefaRepositoryImpl(this.datasource);

  @override
  void adicionar(GrupoTarefaMembro membro) {
    final model = GrupoTarefaMembroModel.fromEntity(membro);
    datasource.adicionar(model);
  }

  @override
  void atualizar(GrupoTarefaMembro membro) {
    final model = GrupoTarefaMembroModel.fromEntity(membro);
    datasource.atualizar(model);
  }

  @override
  List<GrupoTarefaMembro> filtrar({String? grupoTarefa, String? funcao}) {
    return datasource.filtrar(grupoTarefa: grupoTarefa, funcao: funcao);
  }

  @override
  GrupoTarefaMembro? getPorCadastro(String numeroCadastro) {
    return datasource.getPorCadastro(numeroCadastro);
  }

  @override
  List<GrupoTarefaMembro> getTodos() {
    return datasource.getTodos();
  }

  @override
  void remover(String numeroCadastro) {
    datasource.remover(numeroCadastro);
  }
}
