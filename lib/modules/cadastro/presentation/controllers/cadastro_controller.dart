import 'package:get/get.dart';
import '../../domain/entities/usuario.dart';
import '../../data/models/usuario_model.dart';
import '../../data/datasources/usuario_datasource.dart';

/// Controller GetX para operações de cadastro
class CadastroController extends GetxController {
  final UsuarioDatasource _datasource;

  CadastroController(this._datasource);

  // Observables
  final usuarios = <Usuario>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchResults = <Usuario>[].obs;

  // Usuario em edição
  final Rx<Usuario?> usuarioEmEdicao = Rx<Usuario?>(null);

  @override
  void onInit() {
    super.onInit();
    carregarUsuarios();
  }

  /// Carrega todos os usuários
  Future<void> carregarUsuarios() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _datasource.getUsuarios();
      usuarios.value = data;
    } catch (e) {
      errorMessage.value = 'Erro ao carregar usuários: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Gera próximo número de cadastro (5 dígitos)
  String gerarNumeroCadastro() {
    if (usuarios.isEmpty) {
      return '00001';
    }

    // Encontra o maior número existente
    final numeros = usuarios
        .where((u) => u.numeroCadastro != null)
        .map((u) => int.tryParse(u.numeroCadastro!) ?? 0)
        .toList();

    if (numeros.isEmpty) {
      return '00001';
    }

    final maiorNumero = numeros.reduce((a, b) => a > b ? a : b);
    final proximoNumero = maiorNumero + 1;

    return proximoNumero.toString().padLeft(5, '0');
  }

  /// Verifica se CPF já existe
  Future<bool> cpfJaExiste(String cpf, {String? ignorarId}) async {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    
    return usuarios.any((u) => 
      u.cpf == cpfLimpo && u.id != ignorarId
    );
  }

  /// Busca usuários com nome similar (para alertar duplicação)
  List<Usuario> buscarNomesSimilares(String nome) {
    if (nome.isEmpty) return [];

    final nomeLimpo = nome.toLowerCase().trim();
    
    return usuarios.where((u) {
      final nomeUsuario = u.nome.toLowerCase();
      return nomeUsuario.contains(nomeLimpo) || nomeLimpo.contains(nomeUsuario);
    }).toList();
  }

  /// Cria novo cadastro
  Future<bool> cadastrar(Usuario usuario) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Verifica CPF duplicado
      if (await cpfJaExiste(usuario.cpf)) {
        errorMessage.value = 'CPF já cadastrado no sistema';
        return false;
      }

      // Gera número de cadastro se não fornecido
      final usuarioComNumero = usuario.numeroCadastro == null
          ? usuario.copyWith(numeroCadastro: gerarNumeroCadastro())
          : usuario;

      // Define datas automáticas
      final now = DateTime.now();
      final usuarioFinal = usuarioComNumero.copyWith(
        dataCadastro: usuarioComNumero.dataCadastro ?? now,
      );

      // Converte para model
      final model = UsuarioModel(
        id: usuarioFinal.id,
        nome: usuarioFinal.nome,
        cpf: usuarioFinal.cpf,
        numeroCadastro: usuarioFinal.numeroCadastro,
        dataNascimento: usuarioFinal.dataNascimento,
        telefoneFixo: usuarioFinal.telefoneFixo,
        telefoneCelular: usuarioFinal.telefoneCelular,
        email: usuarioFinal.email,
        nomeResponsavel: usuarioFinal.nomeResponsavel,
        telefoneResponsavel: usuarioFinal.telefoneResponsavel,
        emailResponsavel: usuarioFinal.emailResponsavel,
        endereco: usuarioFinal.endereco,
        bairro: usuarioFinal.bairro,
        cidade: usuarioFinal.cidade,
        estado: usuarioFinal.estado,
        cep: usuarioFinal.cep,
        sexo: usuarioFinal.sexo,
        estadoCivil: usuarioFinal.estadoCivil,
        tipoSanguineo: usuarioFinal.tipoSanguineo,
        apelido1: usuarioFinal.apelido1,
        apelido2: usuarioFinal.apelido2,
        nucleoCadastro: usuarioFinal.nucleoCadastro,
        nucleoPertence: usuarioFinal.nucleoPertence,
        dataCadastro: usuarioFinal.dataCadastro,
        statusAtual: usuarioFinal.statusAtual,
        classificacao: usuarioFinal.classificacao,
        diaSessao: usuarioFinal.diaSessao,
        dataBatismo: usuarioFinal.dataBatismo,
        mediumCelebranteBatismo: usuarioFinal.mediumCelebranteBatismo,
        guiaCelebranteBatismo: usuarioFinal.guiaCelebranteBatismo,
        padrinhoBatismo: usuarioFinal.padrinhoBatismo,
        madrinhaBatismo: usuarioFinal.madrinhaBatismo,
        dataPrimeiroCasamento: usuarioFinal.dataPrimeiroCasamento,
        nomePrimeiroConjuge: usuarioFinal.nomePrimeiroConjuge,
        mediumCelebrantePrimeiroCasamento: usuarioFinal.mediumCelebrantePrimeiroCasamento,
        padrinhoPrimeiroCasamento: usuarioFinal.padrinhoPrimeiroCasamento,
        madrinhaPrimeiroCasamento: usuarioFinal.madrinhaPrimeiroCasamento,
        dataSegundoCasamento: usuarioFinal.dataSegundoCasamento,
        nomeSegundoConjuge: usuarioFinal.nomeSegundoConjuge,
        mediumCelebranteSegundoCasamento: usuarioFinal.mediumCelebranteSegundoCasamento,
        padrinhoSegundoCasamento: usuarioFinal.padrinhoSegundoCasamento,
        madrinhaSegundoCasamento: usuarioFinal.madrinhaSegundoCasamento,
        primeiroContatoEmergencia: usuarioFinal.primeiroContatoEmergencia,
        segundoContatoEmergencia: usuarioFinal.segundoContatoEmergencia,
        inicioPrimeiroEstagio: usuarioFinal.inicioPrimeiroEstagio,
        desistenciaPrimeiroEstagio: usuarioFinal.desistenciaPrimeiroEstagio,
        primeiroRitoPassagem: usuarioFinal.primeiroRitoPassagem,
        dataPrimeiroDesligamento: usuarioFinal.dataPrimeiroDesligamento,
        justificativaPrimeiroDesligamento: usuarioFinal.justificativaPrimeiroDesligamento,
        inicioSegundoEstagio: usuarioFinal.inicioSegundoEstagio,
        desistenciaSegundoEstagio: usuarioFinal.desistenciaSegundoEstagio,
        segundoRitoPassagem: usuarioFinal.segundoRitoPassagem,
        dataSegundoDesligamento: usuarioFinal.dataSegundoDesligamento,
        justificativaSegundoDesligamento: usuarioFinal.justificativaSegundoDesligamento,
        inicioTerceiroEstagio: usuarioFinal.inicioTerceiroEstagio,
        desistenciaTerceiroEstagio: usuarioFinal.desistenciaTerceiroEstagio,
        terceiroRitoPassagem: usuarioFinal.terceiroRitoPassagem,
        dataTerceiroDesligamento: usuarioFinal.dataTerceiroDesligamento,
        justificativaTerceiroDesligamento: usuarioFinal.justificativaTerceiroDesligamento,
        inicioQuartoEstagio: usuarioFinal.inicioQuartoEstagio,
        desistenciaQuartoEstagio: usuarioFinal.desistenciaQuartoEstagio,
        quartoRitoPassagem: usuarioFinal.quartoRitoPassagem,
        dataQuartoDesligamento: usuarioFinal.dataQuartoDesligamento,
        justificativaQuartoDesligamento: usuarioFinal.justificativaQuartoDesligamento,
        dataJogoOrixa: usuarioFinal.dataJogoOrixa,
        primeiroOrixa: usuarioFinal.primeiroOrixa,
        adjuntoPrimeiroOrixa: usuarioFinal.adjuntoPrimeiroOrixa,
        segundoOrixa: usuarioFinal.segundoOrixa,
        adjuntoSegundoOrixa: usuarioFinal.adjuntoSegundoOrixa,
        terceiroOrixa: usuarioFinal.terceiroOrixa,
        quartoOrixa: usuarioFinal.quartoOrixa,
        coroacaoSacerdote: usuarioFinal.coroacaoSacerdote,
        primeiraCamarinha: usuarioFinal.primeiraCamarinha,
        segundaCamarinha: usuarioFinal.segundaCamarinha,
        terceiraCamarinha: usuarioFinal.terceiraCamarinha,
        atividadeEspiritual: usuarioFinal.atividadeEspiritual,
        grupoAtividadeEspiritual: usuarioFinal.grupoAtividadeEspiritual,
        grupoTarefa: usuarioFinal.grupoTarefa,
        grupoAcaoSocial: usuarioFinal.grupoAcaoSocial,
        cargoLideranca: usuarioFinal.cargoLideranca,
      );

      final usuarioCriado = await _datasource.createUsuario(model);
      usuarios.add(usuarioCriado);
      Get.snackbar(
        'Sucesso',
        'Cadastro ${usuarioCriado.numeroCadastro} criado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Erro ao criar cadastro: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Pesquisa usuários
  void pesquisar({String? numero, String? cpf, String? nome}) {
    searchResults.clear();

    if (numero != null && numero.isNotEmpty) {
      // Busca exata por número
      final resultado = usuarios.where((u) => u.numeroCadastro == numero).toList();
      searchResults.value = resultado;
      return;
    }

    if (cpf != null && cpf.isNotEmpty) {
      // Busca exata por CPF
      final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
      final resultado = usuarios.where((u) => u.cpf == cpfLimpo).toList();
      searchResults.value = resultado;
      return;
    }

    if (nome != null && nome.isNotEmpty) {
      // Busca parcial por nome
      final nomeLimpo = nome.toLowerCase();
      final resultado = usuarios
          .where((u) => u.nome.toLowerCase().contains(nomeLimpo))
          .toList();
      searchResults.value = resultado;
      return;
    }

    // Se não há critério, retorna todos
    searchResults.value = usuarios;
  }

  /// Carrega usuário para edição
  Future<void> carregarParaEdicao(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final usuario = await _datasource.getUsuarioById(id);
      usuarioEmEdicao.value = usuario;
    } catch (e) {
      errorMessage.value = 'Erro ao carregar usuário: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Atualiza cadastro existente
  Future<bool> editar(Usuario usuario) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Verifica CPF duplicado (ignorando o próprio usuário)
      if (await cpfJaExiste(usuario.cpf, ignorarId: usuario.id)) {
        errorMessage.value = 'CPF já cadastrado para outro usuário';
        return false;
      }

      // Converte para model (reutilizando a mesma lógica do cadastrar)
      final model = UsuarioModel(
        id: usuario.id,
        nome: usuario.nome,
        cpf: usuario.cpf,
        numeroCadastro: usuario.numeroCadastro,
        dataNascimento: usuario.dataNascimento,
        telefoneFixo: usuario.telefoneFixo,
        telefoneCelular: usuario.telefoneCelular,
        email: usuario.email,
        nomeResponsavel: usuario.nomeResponsavel,
        telefoneResponsavel: usuario.telefoneResponsavel,
        emailResponsavel: usuario.emailResponsavel,
        endereco: usuario.endereco,
        bairro: usuario.bairro,
        cidade: usuario.cidade,
        estado: usuario.estado,
        cep: usuario.cep,
        sexo: usuario.sexo,
        estadoCivil: usuario.estadoCivil,
        tipoSanguineo: usuario.tipoSanguineo,
        apelido1: usuario.apelido1,
        apelido2: usuario.apelido2,
        nucleoCadastro: usuario.nucleoCadastro,
        nucleoPertence: usuario.nucleoPertence,
        dataCadastro: usuario.dataCadastro,
        statusAtual: usuario.statusAtual,
        classificacao: usuario.classificacao,
        diaSessao: usuario.diaSessao,
        dataBatismo: usuario.dataBatismo,
        mediumCelebranteBatismo: usuario.mediumCelebranteBatismo,
        guiaCelebranteBatismo: usuario.guiaCelebranteBatismo,
        padrinhoBatismo: usuario.padrinhoBatismo,
        madrinhaBatismo: usuario.madrinhaBatismo,
        dataPrimeiroCasamento: usuario.dataPrimeiroCasamento,
        nomePrimeiroConjuge: usuario.nomePrimeiroConjuge,
        mediumCelebrantePrimeiroCasamento: usuario.mediumCelebrantePrimeiroCasamento,
        padrinhoPrimeiroCasamento: usuario.padrinhoPrimeiroCasamento,
        madrinhaPrimeiroCasamento: usuario.madrinhaPrimeiroCasamento,
        dataSegundoCasamento: usuario.dataSegundoCasamento,
        nomeSegundoConjuge: usuario.nomeSegundoConjuge,
        mediumCelebranteSegundoCasamento: usuario.mediumCelebranteSegundoCasamento,
        padrinhoSegundoCasamento: usuario.padrinhoSegundoCasamento,
        madrinhaSegundoCasamento: usuario.madrinhaSegundoCasamento,
        primeiroContatoEmergencia: usuario.primeiroContatoEmergencia,
        segundoContatoEmergencia: usuario.segundoContatoEmergencia,
        inicioPrimeiroEstagio: usuario.inicioPrimeiroEstagio,
        desistenciaPrimeiroEstagio: usuario.desistenciaPrimeiroEstagio,
        primeiroRitoPassagem: usuario.primeiroRitoPassagem,
        dataPrimeiroDesligamento: usuario.dataPrimeiroDesligamento,
        justificativaPrimeiroDesligamento: usuario.justificativaPrimeiroDesligamento,
        inicioSegundoEstagio: usuario.inicioSegundoEstagio,
        desistenciaSegundoEstagio: usuario.desistenciaSegundoEstagio,
        segundoRitoPassagem: usuario.segundoRitoPassagem,
        dataSegundoDesligamento: usuario.dataSegundoDesligamento,
        justificativaSegundoDesligamento: usuario.justificativaSegundoDesligamento,
        inicioTerceiroEstagio: usuario.inicioTerceiroEstagio,
        desistenciaTerceiroEstagio: usuario.desistenciaTerceiroEstagio,
        terceiroRitoPassagem: usuario.terceiroRitoPassagem,
        dataTerceiroDesligamento: usuario.dataTerceiroDesligamento,
        justificativaTerceiroDesligamento: usuario.justificativaTerceiroDesligamento,
        inicioQuartoEstagio: usuario.inicioQuartoEstagio,
        desistenciaQuartoEstagio: usuario.desistenciaQuartoEstagio,
        quartoRitoPassagem: usuario.quartoRitoPassagem,
        dataQuartoDesligamento: usuario.dataQuartoDesligamento,
        justificativaQuartoDesligamento: usuario.justificativaQuartoDesligamento,
        dataJogoOrixa: usuario.dataJogoOrixa,
        primeiroOrixa: usuario.primeiroOrixa,
        adjuntoPrimeiroOrixa: usuario.adjuntoPrimeiroOrixa,
        segundoOrixa: usuario.segundoOrixa,
        adjuntoSegundoOrixa: usuario.adjuntoSegundoOrixa,
        terceiroOrixa: usuario.terceiroOrixa,
        quartoOrixa: usuario.quartoOrixa,
        coroacaoSacerdote: usuario.coroacaoSacerdote,
        primeiraCamarinha: usuario.primeiraCamarinha,
        segundaCamarinha: usuario.segundaCamarinha,
        terceiraCamarinha: usuario.terceiraCamarinha,
        atividadeEspiritual: usuario.atividadeEspiritual,
        grupoAtividadeEspiritual: usuario.grupoAtividadeEspiritual,
        grupoTarefa: usuario.grupoTarefa,
        grupoAcaoSocial: usuario.grupoAcaoSocial,
        cargoLideranca: usuario.cargoLideranca,
      );

      final usuarioEditado = await _datasource.updateUsuario(model);
      final index = usuarios.indexWhere((u) => u.id == usuarioEditado.id);
      if (index != -1) {
        usuarios[index] = usuarioEditado;
      }
      Get.snackbar(
        'Sucesso',
        'Cadastro atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Erro ao editar cadastro: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Exclui cadastro
  Future<bool> excluir(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _datasource.deleteUsuario(id);
      usuarios.removeWhere((u) => u.id == id);
      Get.snackbar(
        'Sucesso',
        'Cadastro excluído com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Erro ao excluir cadastro: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Limpa resultados de pesquisa
  void limparPesquisa() {
    searchResults.clear();
    errorMessage.value = '';
  }

  /// Limpa usuário em edição
  void limparEdicao() {
    usuarioEmEdicao.value = null;
    errorMessage.value = '';
  }
}
