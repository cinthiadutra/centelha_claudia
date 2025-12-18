import '../../domain/entities/membro.dart';
import '../datasources/membro_datasource.dart';
import '../models/membro_model.dart';

/// Repository para operações com membros
abstract class MembroRepository {
  List<Membro> getMembros();
  Membro? getMembroPorNumero(String numero);
  Membro? getMembroPorCpf(String cpf);
  List<Membro> pesquisarPorNome(String nome);
  void adicionarMembro(Membro membro);
  void atualizarMembro(Membro membro);
  void removerMembro(String numero);
}

/// Implementação do repository
class MembroRepositoryImpl implements MembroRepository {
  final MembroDatasource datasource;

  MembroRepositoryImpl(this.datasource);

  @override
  List<Membro> getMembros() {
    return datasource.getMembros();
  }

  @override
  Membro? getMembroPorNumero(String numero) {
    return datasource.getMembroPorNumero(numero);
  }

  @override
  Membro? getMembroPorCpf(String cpf) {
    return datasource.getMembroPorCpf(cpf);
  }

  @override
  List<Membro> pesquisarPorNome(String nome) {
    return datasource.pesquisarPorNome(nome);
  }

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
  void removerMembro(String numero) {
    datasource.removerMembro(numero);
  }
}
