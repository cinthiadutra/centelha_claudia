import '../models/grupo_trabalho_espiritual_membro_model.dart';

/// Interface do datasource de grupos de trabalhos espirituais
abstract class GrupoTrabalhoEspiritualDatasource {
  Future<void> adicionar(GrupoTrabalhoEspiritualMembroModel membro);
  Future<void> atualizar(GrupoTrabalhoEspiritualMembroModel membro);
  Future<List<GrupoTrabalhoEspiritualMembroModel>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  });
  Future<GrupoTrabalhoEspiritualMembroModel?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoTrabalhoEspiritualMembroModel>> getTodos();
  Future<void> remover(String numeroCadastro);
}

/// Implementação mock do datasource
class GrupoTrabalhoEspiritualDatasourceImpl implements GrupoTrabalhoEspiritualDatasource {
  final List<GrupoTrabalhoEspiritualMembroModel> _membros = [
    GrupoTrabalhoEspiritualMembroModel(
      numeroCadastro: '00001',
      nome: 'João Silva',
      status: 'Membro ativo',
      atividadeEspiritual: 'Evangelização',
      grupoTrabalho: 'Evangelização de crianças',
      funcao: 'Líder',
      dataUltimaAlteracao: DateTime(2025, 11, 15),
    ),
    GrupoTrabalhoEspiritualMembroModel(
      numeroCadastro: '00002',
      nome: 'Maria Santos',
      status: 'Membro ativo',
      atividadeEspiritual: 'Passes',
      grupoTrabalho: 'Sala de passes',
      funcao: 'Participante',
      dataUltimaAlteracao: DateTime(2025, 12, 1),
    ),
  ];

  @override
  Future<void> adicionar(GrupoTrabalhoEspiritualMembroModel membro) async {
    _membros.add(membro);
  }

  @override
  Future<void> atualizar(GrupoTrabalhoEspiritualMembroModel membro) async {
    final index = _membros.indexWhere((m) => m.numeroCadastro == membro.numeroCadastro);
    if (index != -1) {
      _membros[index] = membro;
    }
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  }) async {
    var resultado = List<GrupoTrabalhoEspiritualMembroModel>.from(_membros);

    if (atividadeEspiritual != null) {
      resultado = resultado.where((m) => m.atividadeEspiritual == atividadeEspiritual).toList();
    }

    if (grupoTrabalho != null) {
      resultado = resultado.where((m) => m.grupoTrabalho == grupoTrabalho).toList();
    }

    if (funcao != null) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoTrabalhoEspiritualMembroModel?> getPorCadastro(String numeroCadastro) async {
    try {
      return _membros.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> getTodos() async {
    return List.from(_membros);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    _membros.removeWhere((m) => m.numeroCadastro == numeroCadastro);
  }
}
