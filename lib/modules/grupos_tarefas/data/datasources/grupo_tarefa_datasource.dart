import '../models/grupo_tarefa_membro_model.dart';

/// Datasource para operações com grupos-tarefas
abstract class GrupoTarefaDatasource {
  void adicionar(GrupoTarefaMembroModel membro);
  void atualizar(GrupoTarefaMembroModel membro);
  List<GrupoTarefaMembroModel> filtrar({String? grupoTarefa, String? funcao});
  GrupoTarefaMembroModel? getPorCadastro(String numeroCadastro);
  List<GrupoTarefaMembroModel> getTodos();
  void remover(String numeroCadastro);
}

/// Implementação mock do datasource
class GrupoTarefaDatasourceImpl implements GrupoTarefaDatasource {
  final List<GrupoTarefaMembroModel> _membros = [
    GrupoTarefaMembroModel(
      id: '1',
      numeroCadastro: 'M001',
      nome: 'Maria Silva Santos',
      status: 'Membro ativo',
      grupoTarefa: 'Auxílio à Secretaria',
      funcao: 'Líder',
      dataUltimaAlteracao: DateTime(2024, 11, 15),
    ),
    GrupoTarefaMembroModel(
      id: '2',
      numeroCadastro: 'M002',
      nome: 'José Oliveira',
      status: 'Membro ativo',
      grupoTarefa: 'Comunicação & Marketing',
      funcao: 'Membro',
      dataUltimaAlteracao: DateTime(2024, 10, 20),
    ),
  ];

  @override
  void adicionar(GrupoTarefaMembroModel membro) {
    _membros.add(membro);
  }

  @override
  void atualizar(GrupoTarefaMembroModel membro) {
    final index = _membros.indexWhere(
      (m) => m.numeroCadastro == membro.numeroCadastro,
    );
    if (index != -1) {
      _membros[index] = membro;
    }
  }

  @override
  List<GrupoTarefaMembroModel> filtrar({String? grupoTarefa, String? funcao}) {
    var resultado = List<GrupoTarefaMembroModel>.from(_membros);

    if (grupoTarefa != null && grupoTarefa.isNotEmpty) {
      resultado = resultado.where((m) => m.grupoTarefa == grupoTarefa).toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  GrupoTarefaMembroModel? getPorCadastro(String numeroCadastro) {
    try {
      return _membros.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  List<GrupoTarefaMembroModel> getTodos() => List.from(_membros);

  @override
  void remover(String numeroCadastro) {
    _membros.removeWhere((m) => m.numeroCadastro == numeroCadastro);
  }
}
