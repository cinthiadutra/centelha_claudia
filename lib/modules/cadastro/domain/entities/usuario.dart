import 'package:equatable/equatable.dart';

/// Entidade de domínio do Usuário
class Usuario extends Equatable {
  // Dados Básicos (obrigatórios)
  final String? id;
  final String nome;
  final String cpf;

  // Dados Pessoais
  final String? numeroCadastro;
  final DateTime? dataNascimento;
  final String? telefoneFixo;
  final String? telefoneCelular;
  final String? email;
  final String? nomeResponsavel;
  final String? telefoneResponsavel;
  final String? emailResponsavel;
  final String? endereco;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;
  final String? sexo;
  final String? estadoCivil;
  final String? tipoSanguineo;
  final String? apelido1;
  final String? apelido2;

  // Dados de Cadastro
  final String? nucleoCadastro;
  final DateTime? dataCadastro;
  final String? nucleoPertence;
  final String? statusAtual;
  final String? classificacao;
  final String? diaSessao;

  // Dados de Batismo
  final DateTime? dataBatismo;
  final String? mediumCelebranteBatismo;
  final String? guiaCelebranteBatismo;
  final String? padrinhoBatismo;
  final String? madrinhaBatismo;

  // Dados do 1º Casamento
  final DateTime? dataPrimeiroCasamento;
  final String? nomePrimeiroConjuge;
  final String? mediumCelebrantePrimeiroCasamento;
  final String? padrinhoPrimeiroCasamento;
  final String? madrinhaPrimeiroCasamento;

  // Dados do 2º Casamento
  final DateTime? dataSegundoCasamento;
  final String? nomeSegundoConjuge;
  final String? mediumCelebranteSegundoCasamento;
  final String? padrinhoSegundoCasamento;
  final String? madrinhaSegundoCasamento;

  // Contatos de Emergência
  final String? primeiroContatoEmergencia;
  final String? segundoContatoEmergencia;

  // Dados de Estágios - 1º Estágio
  final DateTime? inicioPrimeiroEstagio;
  final DateTime? desistenciaPrimeiroEstagio;
  final DateTime? primeiroRitoPassagem;
  final DateTime? dataPrimeiroDesligamento;
  final String? justificativaPrimeiroDesligamento;

  // Dados de Estágios - 2º Estágio
  final DateTime? inicioSegundoEstagio;
  final DateTime? desistenciaSegundoEstagio;
  final DateTime? segundoRitoPassagem;
  final DateTime? dataSegundoDesligamento;
  final String? justificativaSegundoDesligamento;

  // Dados de Estágios - 3º Estágio
  final DateTime? inicioTerceiroEstagio;
  final DateTime? desistenciaTerceiroEstagio;
  final DateTime? terceiroRitoPassagem;
  final DateTime? dataTerceiroDesligamento;
  final String? justificativaTerceiroDesligamento;

  // Dados de Estágios - 4º Estágio
  final DateTime? inicioQuartoEstagio;
  final DateTime? desistenciaQuartoEstagio;
  final DateTime? quartoRitoPassagem;
  final DateTime? dataQuartoDesligamento;
  final String? justificativaQuartoDesligamento;

  // Dados de Orixá
  final DateTime? dataJogoOrixa;
  final String? primeiroOrixa;
  final String? adjuntoPrimeiroOrixa;
  final String? segundoOrixa;
  final String? adjuntoSegundoOrixa;
  final String? terceiroOrixa;
  final String? quartoOrixa;

  // Dados de Sacerdote
  final DateTime? coroacaoSacerdote;
  final DateTime? primeiraCamarinha;
  final DateTime? segundaCamarinha;
  final DateTime? terceiraCamarinha;

  // Atividades e Grupos
  final String? atividadeEspiritual;
  final String? grupoAtividadeEspiritual;
  final String? grupoTarefa;
  final String? grupoAcaoSocial;
  final String? cargoLideranca;

  const Usuario({
    this.id,
    required this.nome,
    required this.cpf,
    this.numeroCadastro,
    this.dataNascimento,
    this.telefoneFixo,
    this.telefoneCelular,
    this.email,
    this.nomeResponsavel,
    this.telefoneResponsavel,
    this.emailResponsavel,
    this.endereco,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
    this.sexo,
    this.estadoCivil,
    this.tipoSanguineo,
    this.apelido1,
    this.apelido2,
    this.nucleoCadastro,
    this.dataCadastro,
    this.nucleoPertence,
    this.statusAtual,
    this.classificacao,
    this.diaSessao,
    this.dataBatismo,
    this.mediumCelebranteBatismo,
    this.guiaCelebranteBatismo,
    this.padrinhoBatismo,
    this.madrinhaBatismo,
    this.dataPrimeiroCasamento,
    this.nomePrimeiroConjuge,
    this.mediumCelebrantePrimeiroCasamento,
    this.padrinhoPrimeiroCasamento,
    this.madrinhaPrimeiroCasamento,
    this.dataSegundoCasamento,
    this.nomeSegundoConjuge,
    this.mediumCelebranteSegundoCasamento,
    this.padrinhoSegundoCasamento,
    this.madrinhaSegundoCasamento,
    this.primeiroContatoEmergencia,
    this.segundoContatoEmergencia,
    this.inicioPrimeiroEstagio,
    this.desistenciaPrimeiroEstagio,
    this.primeiroRitoPassagem,
    this.dataPrimeiroDesligamento,
    this.justificativaPrimeiroDesligamento,
    this.inicioSegundoEstagio,
    this.desistenciaSegundoEstagio,
    this.segundoRitoPassagem,
    this.dataSegundoDesligamento,
    this.justificativaSegundoDesligamento,
    this.inicioTerceiroEstagio,
    this.desistenciaTerceiroEstagio,
    this.terceiroRitoPassagem,
    this.dataTerceiroDesligamento,
    this.justificativaTerceiroDesligamento,
    this.inicioQuartoEstagio,
    this.desistenciaQuartoEstagio,
    this.quartoRitoPassagem,
    this.dataQuartoDesligamento,
    this.justificativaQuartoDesligamento,
    this.dataJogoOrixa,
    this.primeiroOrixa,
    this.adjuntoPrimeiroOrixa,
    this.segundoOrixa,
    this.adjuntoSegundoOrixa,
    this.terceiroOrixa,
    this.quartoOrixa,
    this.coroacaoSacerdote,
    this.primeiraCamarinha,
    this.segundaCamarinha,
    this.terceiraCamarinha,
    this.atividadeEspiritual,
    this.grupoAtividadeEspiritual,
    this.grupoTarefa,
    this.grupoAcaoSocial,
    this.cargoLideranca,
  });

  Usuario copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? numeroCadastro,
    DateTime? dataNascimento,
    String? telefoneFixo,
    String? telefoneCelular,
    String? email,
    String? nomeResponsavel,
    String? telefoneResponsavel,
    String? emailResponsavel,
    String? endereco,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
    String? sexo,
    String? estadoCivil,
    String? tipoSanguineo,
    String? apelido1,
    String? apelido2,
    String? nucleoCadastro,
    DateTime? dataCadastro,
    String? nucleoPertence,
    String? statusAtual,
    String? classificacao,
    String? diaSessao,
    DateTime? dataBatismo,
    String? mediumCelebranteBatismo,
    String? guiaCelebranteBatismo,
    String? padrinhoBatismo,
    String? madrinhaBatismo,
    DateTime? dataPrimeiroCasamento,
    String? nomePrimeiroConjuge,
    String? mediumCelebrantePrimeiroCasamento,
    String? padrinhoPrimeiroCasamento,
    String? madrinhaPrimeiroCasamento,
    DateTime? dataSegundoCasamento,
    String? nomeSegundoConjuge,
    String? mediumCelebranteSegundoCasamento,
    String? padrinhoSegundoCasamento,
    String? madrinhaSegundoCasamento,
    String? primeiroContatoEmergencia,
    String? segundoContatoEmergencia,
    DateTime? inicioPrimeiroEstagio,
    DateTime? desistenciaPrimeiroEstagio,
    DateTime? primeiroRitoPassagem,
    DateTime? dataPrimeiroDesligamento,
    String? justificativaPrimeiroDesligamento,
    DateTime? inicioSegundoEstagio,
    DateTime? desistenciaSegundoEstagio,
    DateTime? segundoRitoPassagem,
    DateTime? dataSegundoDesligamento,
    String? justificativaSegundoDesligamento,
    DateTime? inicioTerceiroEstagio,
    DateTime? desistenciaTerceiroEstagio,
    DateTime? terceiroRitoPassagem,
    DateTime? dataTerceiroDesligamento,
    String? justificativaTerceiroDesligamento,
    DateTime? inicioQuartoEstagio,
    DateTime? desistenciaQuartoEstagio,
    DateTime? quartoRitoPassagem,
    DateTime? dataQuartoDesligamento,
    String? justificativaQuartoDesligamento,
    DateTime? dataJogoOrixa,
    String? primeiroOrixa,
    String? adjuntoPrimeiroOrixa,
    String? segundoOrixa,
    String? adjuntoSegundoOrixa,
    String? terceiroOrixa,
    String? quartoOrixa,
    DateTime? coroacaoSacerdote,
    DateTime? primeiraCamarinha,
    DateTime? segundaCamarinha,
    DateTime? terceiraCamarinha,
    String? atividadeEspiritual,
    String? grupoAtividadeEspiritual,
    String? grupoTarefa,
    String? grupoAcaoSocial,
    String? cargoLideranca,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      telefoneFixo: telefoneFixo ?? this.telefoneFixo,
      telefoneCelular: telefoneCelular ?? this.telefoneCelular,
      email: email ?? this.email,
      nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
      telefoneResponsavel: telefoneResponsavel ?? this.telefoneResponsavel,
      emailResponsavel: emailResponsavel ?? this.emailResponsavel,
      endereco: endereco ?? this.endereco,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      sexo: sexo ?? this.sexo,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      tipoSanguineo: tipoSanguineo ?? this.tipoSanguineo,
      apelido1: apelido1 ?? this.apelido1,
      apelido2: apelido2 ?? this.apelido2,
      nucleoCadastro: nucleoCadastro ?? this.nucleoCadastro,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      nucleoPertence: nucleoPertence ?? this.nucleoPertence,
      statusAtual: statusAtual ?? this.statusAtual,
      classificacao: classificacao ?? this.classificacao,
      diaSessao: diaSessao ?? this.diaSessao,
      dataBatismo: dataBatismo ?? this.dataBatismo,
      mediumCelebranteBatismo: mediumCelebranteBatismo ?? this.mediumCelebranteBatismo,
      guiaCelebranteBatismo: guiaCelebranteBatismo ?? this.guiaCelebranteBatismo,
      padrinhoBatismo: padrinhoBatismo ?? this.padrinhoBatismo,
      madrinhaBatismo: madrinhaBatismo ?? this.madrinhaBatismo,
      dataPrimeiroCasamento: dataPrimeiroCasamento ?? this.dataPrimeiroCasamento,
      nomePrimeiroConjuge: nomePrimeiroConjuge ?? this.nomePrimeiroConjuge,
      mediumCelebrantePrimeiroCasamento: mediumCelebrantePrimeiroCasamento ?? this.mediumCelebrantePrimeiroCasamento,
      padrinhoPrimeiroCasamento: padrinhoPrimeiroCasamento ?? this.padrinhoPrimeiroCasamento,
      madrinhaPrimeiroCasamento: madrinhaPrimeiroCasamento ?? this.madrinhaPrimeiroCasamento,
      dataSegundoCasamento: dataSegundoCasamento ?? this.dataSegundoCasamento,
      nomeSegundoConjuge: nomeSegundoConjuge ?? this.nomeSegundoConjuge,
      mediumCelebranteSegundoCasamento: mediumCelebranteSegundoCasamento ?? this.mediumCelebranteSegundoCasamento,
      padrinhoSegundoCasamento: padrinhoSegundoCasamento ?? this.padrinhoSegundoCasamento,
      madrinhaSegundoCasamento: madrinhaSegundoCasamento ?? this.madrinhaSegundoCasamento,
      primeiroContatoEmergencia: primeiroContatoEmergencia ?? this.primeiroContatoEmergencia,
      segundoContatoEmergencia: segundoContatoEmergencia ?? this.segundoContatoEmergencia,
      inicioPrimeiroEstagio: inicioPrimeiroEstagio ?? this.inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio: desistenciaPrimeiroEstagio ?? this.desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: primeiroRitoPassagem ?? this.primeiroRitoPassagem,
      dataPrimeiroDesligamento: dataPrimeiroDesligamento ?? this.dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento: justificativaPrimeiroDesligamento ?? this.justificativaPrimeiroDesligamento,
      inicioSegundoEstagio: inicioSegundoEstagio ?? this.inicioSegundoEstagio,
      desistenciaSegundoEstagio: desistenciaSegundoEstagio ?? this.desistenciaSegundoEstagio,
      segundoRitoPassagem: segundoRitoPassagem ?? this.segundoRitoPassagem,
      dataSegundoDesligamento: dataSegundoDesligamento ?? this.dataSegundoDesligamento,
      justificativaSegundoDesligamento: justificativaSegundoDesligamento ?? this.justificativaSegundoDesligamento,
      inicioTerceiroEstagio: inicioTerceiroEstagio ?? this.inicioTerceiroEstagio,
      desistenciaTerceiroEstagio: desistenciaTerceiroEstagio ?? this.desistenciaTerceiroEstagio,
      terceiroRitoPassagem: terceiroRitoPassagem ?? this.terceiroRitoPassagem,
      dataTerceiroDesligamento: dataTerceiroDesligamento ?? this.dataTerceiroDesligamento,
      justificativaTerceiroDesligamento: justificativaTerceiroDesligamento ?? this.justificativaTerceiroDesligamento,
      inicioQuartoEstagio: inicioQuartoEstagio ?? this.inicioQuartoEstagio,
      desistenciaQuartoEstagio: desistenciaQuartoEstagio ?? this.desistenciaQuartoEstagio,
      quartoRitoPassagem: quartoRitoPassagem ?? this.quartoRitoPassagem,
      dataQuartoDesligamento: dataQuartoDesligamento ?? this.dataQuartoDesligamento,
      justificativaQuartoDesligamento: justificativaQuartoDesligamento ?? this.justificativaQuartoDesligamento,
      dataJogoOrixa: dataJogoOrixa ?? this.dataJogoOrixa,
      primeiroOrixa: primeiroOrixa ?? this.primeiroOrixa,
      adjuntoPrimeiroOrixa: adjuntoPrimeiroOrixa ?? this.adjuntoPrimeiroOrixa,
      segundoOrixa: segundoOrixa ?? this.segundoOrixa,
      adjuntoSegundoOrixa: adjuntoSegundoOrixa ?? this.adjuntoSegundoOrixa,
      terceiroOrixa: terceiroOrixa ?? this.terceiroOrixa,
      quartoOrixa: quartoOrixa ?? this.quartoOrixa,
      coroacaoSacerdote: coroacaoSacerdote ?? this.coroacaoSacerdote,
      primeiraCamarinha: primeiraCamarinha ?? this.primeiraCamarinha,
      segundaCamarinha: segundaCamarinha ?? this.segundaCamarinha,
      terceiraCamarinha: terceiraCamarinha ?? this.terceiraCamarinha,
      atividadeEspiritual: atividadeEspiritual ?? this.atividadeEspiritual,
      grupoAtividadeEspiritual: grupoAtividadeEspiritual ?? this.grupoAtividadeEspiritual,
      grupoTarefa: grupoTarefa ?? this.grupoTarefa,
      grupoAcaoSocial: grupoAcaoSocial ?? this.grupoAcaoSocial,
      cargoLideranca: cargoLideranca ?? this.cargoLideranca,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nome,
        cpf,
        numeroCadastro,
        dataNascimento,
        telefoneFixo,
        telefoneCelular,
        email,
        nomeResponsavel,
        telefoneResponsavel,
        emailResponsavel,
        endereco,
        bairro,
        cidade,
        estado,
        cep,
        sexo,
        estadoCivil,
        tipoSanguineo,
        apelido1,
        apelido2,
        nucleoCadastro,
        dataCadastro,
        nucleoPertence,
        statusAtual,
        classificacao,
        diaSessao,
        dataBatismo,
        mediumCelebranteBatismo,
        guiaCelebranteBatismo,
        padrinhoBatismo,
        madrinhaBatismo,
        dataPrimeiroCasamento,
        nomePrimeiroConjuge,
        mediumCelebrantePrimeiroCasamento,
        padrinhoPrimeiroCasamento,
        madrinhaPrimeiroCasamento,
        dataSegundoCasamento,
        nomeSegundoConjuge,
        mediumCelebranteSegundoCasamento,
        padrinhoSegundoCasamento,
        madrinhaSegundoCasamento,
        primeiroContatoEmergencia,
        segundoContatoEmergencia,
        inicioPrimeiroEstagio,
        desistenciaPrimeiroEstagio,
        primeiroRitoPassagem,
        dataPrimeiroDesligamento,
        justificativaPrimeiroDesligamento,
        inicioSegundoEstagio,
        desistenciaSegundoEstagio,
        segundoRitoPassagem,
        dataSegundoDesligamento,
        justificativaSegundoDesligamento,
        inicioTerceiroEstagio,
        desistenciaTerceiroEstagio,
        terceiroRitoPassagem,
        dataTerceiroDesligamento,
        justificativaTerceiroDesligamento,
        inicioQuartoEstagio,
        desistenciaQuartoEstagio,
        quartoRitoPassagem,
        dataQuartoDesligamento,
        justificativaQuartoDesligamento,
        dataJogoOrixa,
        primeiroOrixa,
        adjuntoPrimeiroOrixa,
        segundoOrixa,
        adjuntoSegundoOrixa,
        terceiroOrixa,
        quartoOrixa,
        coroacaoSacerdote,
        primeiraCamarinha,
        segundaCamarinha,
        terceiraCamarinha,
        atividadeEspiritual,
        grupoAtividadeEspiritual,
        grupoTarefa,
        grupoAcaoSocial,
        cargoLideranca,
      ];
}
