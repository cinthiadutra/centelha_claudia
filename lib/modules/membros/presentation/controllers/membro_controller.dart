import 'package:get/get.dart';
import '../../domain/entities/membro.dart';
import '../../data/repositories/membro_repository.dart';

/// Controller GetX para gerenciar membros da CENTELHA
class MembroController extends GetxController {
  final MembroRepository repository;

  MembroController(this.repository);

  // Estado reativo
  final RxList<Membro> membros = <Membro>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Membro?> membroSelecionado = Rx<Membro?>(null);

  @override
  void onInit() {
    super.onInit();
    carregarMembros();
  }

  /// Carrega todos os membros
  void carregarMembros() {
    isLoading.value = true;
    try {
      membros.value = repository.getMembros();
    } finally {
      isLoading.value = false;
    }
  }

  /// Gera número de cadastro sequencial
  String gerarNumeroCadastro() {
    final agora = DateTime.now();
    final ano = agora.year.toString().substring(2);
    final mes = agora.month.toString().padLeft(2, '0');
    final dia = agora.day.toString().padLeft(2, '0');
    final hora = agora.hour.toString().padLeft(2, '0');
    final minuto = agora.minute.toString().padLeft(2, '0');
    final segundo = agora.second.toString().padLeft(2, '0');
    
    return 'M$ano$mes$dia$hora$minuto$segundo';
  }

  /// Verifica se número de cadastro já existe
  bool numeroCadastroJaExiste(String numero) {
    return membros.any((m) => m.numeroCadastro == numero);
  }

  /// Verifica se CPF já tem membro cadastrado
  bool cpfJaTemMembro(String cpf) {
    return membros.any((m) => m.cpf == cpf);
  }

  /// Adiciona novo membro
  Future<void> adicionarMembro(Membro membro) async {
    isLoading.value = true;
    try {
      // Validações
      if (numeroCadastroJaExiste(membro.numeroCadastro)) {
        throw Exception('Número de cadastro já existe');
      }

      if (cpfJaTemMembro(membro.cpf)) {
        throw Exception('Já existe um membro com este CPF');
      }

      repository.adicionarMembro(membro);
      membros.add(membro);
      
      Get.snackbar(
        'Sucesso',
        'Membro ${membro.numeroCadastro} cadastrado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Busca membro por número de cadastro
  Membro? buscarPorNumero(String numero) {
    return repository.getMembroPorNumero(numero);
  }

  /// Busca membro por CPF
  Membro? buscarPorCpf(String cpf) {
    return repository.getMembroPorCpf(cpf);
  }

  /// Pesquisa membros por nome
  List<Membro> pesquisarPorNome(String nome) {
    return repository.pesquisarPorNome(nome);
  }

  /// Atualiza dados de um membro
  Future<void> atualizarMembro(Membro membro) async {
    isLoading.value = true;
    try {
      final membroAtualizado = membro.copyWith(
        dataUltimaAlteracao: DateTime.now(),
      );

      repository.atualizarMembro(membroAtualizado);
      
      final index = membros.indexWhere((m) => m.id == membro.id);
      if (index != -1) {
        membros[index] = membroAtualizado;
      }

      Get.snackbar(
        'Sucesso',
        'Membro ${membro.numeroCadastro} atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar membro: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove um membro
  Future<void> removerMembro(String numero) async {
    isLoading.value = true;
    try {
      repository.removerMembro(numero);
      membros.removeWhere((m) => m.numeroCadastro == numero);

      Get.snackbar(
        'Sucesso',
        'Membro removido com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao remover membro: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Filtra membros para relatórios
  List<Membro> filtrarParaRelatorio({
    String? status,
    String? funcao,
    String? classificacao,
    String? diaSessao,
    bool? temJogoOrixa,
    bool? temBatizado,
    bool? temCamarinha,
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? orixa,
  }) {
    var resultado = List<Membro>.from(membros);

    if (status != null && status.isNotEmpty) {
      resultado = resultado.where((m) => m.status == status).toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    if (classificacao != null && classificacao.isNotEmpty) {
      resultado = resultado.where((m) => m.classificacao == classificacao).toList();
    }

    if (diaSessao != null && diaSessao.isNotEmpty) {
      resultado = resultado.where((m) => m.diaSessao == diaSessao).toList();
    }

    if (temJogoOrixa != null && temJogoOrixa) {
      resultado = resultado.where((m) => m.dataJogoOrixa != null).toList();
    }

    if (temBatizado != null && temBatizado) {
      resultado = resultado.where((m) => m.dataBatizado != null).toList();
    }

    if (temCamarinha != null && temCamarinha) {
      resultado = resultado.where((m) => 
        m.primeiraCamarinha != null || 
        m.segundaCamarinha != null || 
        m.terceiraCamarinha != null
      ).toList();
    }

    if (atividadeEspiritual != null && atividadeEspiritual.isNotEmpty) {
      resultado = resultado.where((m) => 
        m.atividadeEspiritual?.contains(atividadeEspiritual) ?? false
      ).toList();
    }

    if (grupoTrabalho != null && grupoTrabalho.isNotEmpty) {
      resultado = resultado.where((m) => 
        m.grupoTrabalhoEspiritual?.contains(grupoTrabalho) ?? false
      ).toList();
    }

    if (orixa != null && orixa.isNotEmpty) {
      resultado = resultado.where((m) =>
        m.primeiroOrixa == orixa ||
        m.segundoOrixa == orixa ||
        m.terceiroOrixa == orixa ||
        m.quartoOrixa == orixa
      ).toList();
    }

    return resultado;
  }

  /// Seleciona um membro
  void selecionarMembro(Membro? membro) {
    membroSelecionado.value = membro;
  }

  /// Limpa seleção
  void limparSelecao() {
    membroSelecionado.value = null;
  }
}
