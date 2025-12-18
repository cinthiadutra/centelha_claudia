import '../models/grupo_acao_social_membro_model.dart';

/// Interface do datasource de grupos de ações sociais
abstract class GrupoAcaoSocialDatasource {
  Future<void> adicionar(GrupoAcaoSocialMembroModel membro);
  Future<void> atualizar(GrupoAcaoSocialMembroModel membro);
  Future<List<GrupoAcaoSocialMembroModel>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  });
  Future<GrupoAcaoSocialMembroModel?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoAcaoSocialMembroModel>> getTodos();
  Future<void> remover(String numeroCadastro);
}

/// Implementação mock do datasource
class GrupoAcaoSocialDatasourceImpl implements GrupoAcaoSocialDatasource {
  final List<GrupoAcaoSocialMembroModel> _membros = [
    GrupoAcaoSocialMembroModel(
      numeroCadastro: '00001',
      nome: 'João Silva',
      status: 'Membro ativo',
      grupoAcaoSocial: 'Grupo Sopão Fraterno',
      funcao: 'Líder',
      dataUltimaAlteracao: DateTime(2025, 11, 15),
    ),
    GrupoAcaoSocialMembroModel(
      numeroCadastro: '00002',
      nome: 'Maria Santos',
      status: 'Membro ativo',
      grupoAcaoSocial: 'Grupo de Apoio aos doentes',
      funcao: 'Participante',
      dataUltimaAlteracao: DateTime(2025, 12, 1),
    ),
  ];

  @override
  Future<void> adicionar(GrupoAcaoSocialMembroModel membro) async {
    _membros.add(membro);
  }

  @override
  Future<void> atualizar(GrupoAcaoSocialMembroModel membro) async {
    final index = _membros.indexWhere(
      (m) => m.numeroCadastro == membro.numeroCadastro,
    );
    if (index != -1) {
      _membros[index] = membro;
    }
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) async {
    var resultado = List<GrupoAcaoSocialMembroModel>.from(_membros);

    if (grupoAcaoSocial != null) {
      resultado = resultado
          .where((m) => m.grupoAcaoSocial == grupoAcaoSocial)
          .toList();
    }

    if (funcao != null) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoAcaoSocialMembroModel?> getPorCadastro(
    String numeroCadastro,
  ) async {
    try {
      return _membros.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> getTodos() async {
    return List.from(_membros);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    _membros.removeWhere((m) => m.numeroCadastro == numeroCadastro);
  }
}
