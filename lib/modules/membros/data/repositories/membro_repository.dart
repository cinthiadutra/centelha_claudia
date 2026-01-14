import '../../domain/entities/membro.dart';
import '../datasources/membro_datasource.dart';
import '../models/membro_model.dart';

/// Repository para operações com membros
abstract class MembroRepository {
  void adicionarMembro(Membro membro);
  void atualizarMembro(Membro membro);

  /// Garante que dados estão carregados (importante para datasources assíncronos)
  Future<void> garantirDadosCarregados();
  Membro? getMembroPorCpf(String cpf);
  Membro? getMembroPorNumero(String numero);
  List<Membro> getMembros();
  List<Membro> pesquisarPorNome(String nome);

  void removerMembro(String numero);
}

/// Implementação do repository
class MembroRepositoryImpl implements MembroRepository {
  final MembroDatasource datasource;

  MembroRepositoryImpl(this.datasource);

  @override
  void adicionarMembro(Membro membro) {
    final model = MembroModel.fromEntity(membro);
    datasource.adicionarMembro(model);
  }

  @override
  void atualizarMembro(Membro membro) {
    final model = MembroModel.fromEntity(membro);
    datasource.atualizarMembro(model);
  }

  @override
  Future<void> garantirDadosCarregados() async {
    await datasource.garantirDadosCarregados();
  }

  @override
  Membro? getMembroPorCpf(String cpf) {
    return datasource.getMembroPorCpf(cpf);
  }

  @override
  Membro? getMembroPorNumero(String numero) {
    return datasource.getMembroPorNumero(numero);
  }

  @override
  List<Membro> getMembros() {
    return datasource.getMembros();
  }

  @override
  List<Membro> pesquisarPorNome(String nome) {
    return datasource.pesquisarPorNome(nome);
  }

  @override
  void removerMembro(String numero) {
    datasource.removerMembro(numero);
  }
}
