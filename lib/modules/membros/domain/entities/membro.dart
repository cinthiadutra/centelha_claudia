import 'package:equatable/equatable.dart';

/// Entidade de Membro da CLAUDIA
/// Representa o registro espiritual/organizacional de uma pessoa
/// (diferente do cadastro pessoal em Usuario)
class Membro extends Equatable {
  // Identificação
  final String? id;
  final String numeroCadastro; // Número único do membro
  final String cpf; // Referência ao cadastro de Usuario
  final String nome; // Preenchido automaticamente do Usuario

  // Informações Organizacionais (obrigatórias)
  final String
  nucleo; // 001 - Casa do Caboclo Ubirajara, 002 - Casa de Pai Oxalá
  final String status; // Estagiário, Membro ativo, Excluído
  final String funcao; // Médium, Cambono, Curimbeiro, Tarefeiro
  final String classificacao; // Grau vermelho, coral, amarelo, etc.
  final String diaSessao; // Terça-feira, Quarta-feira, Sábado, etc.
  final String? primeiroContatoEmergencia;
  final String? segundoContatoEmergencia;

  // Histórico - 1º Estágio
  final DateTime? inicioPrimeiroEstagio;
  final DateTime? desistenciaPrimeiroEstagio;
  final DateTime? primeiroRitoPassagem;
  final DateTime? dataPrimeiroDesligamento;
  final String? justificativaPrimeiroDesligamento;
  final String? condicaoSegundoEstagio;

  // Histórico - 2º Estágio
  final DateTime? inicioSegundoEstagio;
  final DateTime? desistenciaSegundoEstagio;
  final DateTime? segundoRitoPassagem;
  final DateTime? dataSegundoDesligamento;
  final String? justificativaSegundoDesligamento;
  final String? condicaoTerceiroEstagio;

  // Histórico - 3º Estágio
  final DateTime? inicioTerceiroEstagio;
  final DateTime? desistenciaTerceiroEstagio;
  final DateTime? terceiroRitoPassagem;
  final DateTime? dataTerceiroDesligamento;
  final String? justificativaTerceiroDesligamento;
  final String? condicaoQuartoEstagio;

  // Histórico - 4º Estágio
  final DateTime? inicioQuartoEstagio;
  final DateTime? desistenciaQuartoEstagio;
  final DateTime? quartoRitoPassagem;
  final DateTime? dataQuartoDesligamento;
  final String? justificativaQuartoDesligamento;

  // Histórico Espiritual
  final DateTime? dataBatizado; // Preenchido automaticamente
  final String? padrinhoBatismo; // Preenchido automaticamente
  final String? madrinhaBatismo; // Preenchido automaticamente
  final DateTime? dataJogoOrixa; // Preenchido automaticamente
  final DateTime? primeiraCamarinha;
  final DateTime? segundaCamarinha;
  final DateTime? terceiraCamarinha;
  final DateTime? dataCoroacaoSacerdote;
  final String? atividadeEspiritual; // Preenchido automaticamente
  final String? grupoTrabalhoEspiritual; // Preenchido automaticamente

  // Grupos e Atividades
  final String? grupoTarefa; // Grupo-Tarefa (usado para Nota C)
  final String? acaoSocial; // Grupo de Ação Social (usado para Nota D)
  final String? cargoLideranca; // Cargo de Liderança (usado para Nota L)

  // Orixás (preenchidos automaticamente)
  final String? primeiroOrixa;
  final String? adjuntoPrimeiroOrixa;
  final String? segundoOrixa;
  final String? adjuntoSegundoOrixa;
  final String? terceiroOrixa;
  final String? quartoOrixa;
  final String? observacoesOrixa;

  // Nomes dos Guias Espirituais
  final String? nomePr; // Preto-Velho
  final String? nomeBai; // Baiano
  final String? nomeCab; // Caboclo
  final String? nomeMar; // Marinheiro
  final String? nomeMal; // Malandro
  final String? nomeCig; // Cigano
  final String? nomePv; // Pomba-Gira

  // Metadados
  final DateTime? dataCriacao;
  final DateTime? dataUltimaAlteracao;

  const Membro({
    this.id,
    required this.numeroCadastro,
    required this.cpf,
    required this.nome,
    required this.nucleo,
    required this.status,
    required this.funcao,
    required this.classificacao,
    required this.diaSessao,
    this.primeiroContatoEmergencia,
    this.segundoContatoEmergencia,
    this.inicioPrimeiroEstagio,
    this.desistenciaPrimeiroEstagio,
    this.primeiroRitoPassagem,
    this.dataPrimeiroDesligamento,
    this.justificativaPrimeiroDesligamento,
    this.condicaoSegundoEstagio,
    this.inicioSegundoEstagio,
    this.desistenciaSegundoEstagio,
    this.segundoRitoPassagem,
    this.dataSegundoDesligamento,
    this.justificativaSegundoDesligamento,
    this.condicaoTerceiroEstagio,
    this.inicioTerceiroEstagio,
    this.desistenciaTerceiroEstagio,
    this.terceiroRitoPassagem,
    this.dataTerceiroDesligamento,
    this.justificativaTerceiroDesligamento,
    this.condicaoQuartoEstagio,
    this.inicioQuartoEstagio,
    this.desistenciaQuartoEstagio,
    this.quartoRitoPassagem,
    this.dataQuartoDesligamento,
    this.justificativaQuartoDesligamento,
    this.dataBatizado,
    this.padrinhoBatismo,
    this.madrinhaBatismo,
    this.dataJogoOrixa,
    this.primeiraCamarinha,
    this.segundaCamarinha,
    this.terceiraCamarinha,
    this.dataCoroacaoSacerdote,
    this.atividadeEspiritual,
    this.grupoTrabalhoEspiritual,
    this.grupoTarefa,
    this.acaoSocial,
    this.cargoLideranca,
    this.primeiroOrixa,
    this.adjuntoPrimeiroOrixa,
    this.segundoOrixa,
    this.adjuntoSegundoOrixa,
    this.terceiroOrixa,
    this.quartoOrixa,
    this.observacoesOrixa,
    this.nomePr,
    this.nomeBai,
    this.nomeCab,
    this.nomeMar,
    this.nomeMal,
    this.nomeCig,
    this.nomePv,
    this.dataCriacao,
    this.dataUltimaAlteracao,
  });

  @override
  List<Object?> get props => [
    id,
    numeroCadastro,
    cpf,
    nome,
    nucleo,
    status,
    funcao,
    classificacao,
    diaSessao,
    primeiroContatoEmergencia,
    segundoContatoEmergencia,
    inicioPrimeiroEstagio,
    desistenciaPrimeiroEstagio,
    primeiroRitoPassagem,
    dataPrimeiroDesligamento,
    justificativaPrimeiroDesligamento,
    condicaoSegundoEstagio,
    inicioSegundoEstagio,
    desistenciaSegundoEstagio,
    segundoRitoPassagem,
    dataSegundoDesligamento,
    justificativaSegundoDesligamento,
    condicaoTerceiroEstagio,
    inicioTerceiroEstagio,
    desistenciaTerceiroEstagio,
    terceiroRitoPassagem,
    dataTerceiroDesligamento,
    justificativaTerceiroDesligamento,
    condicaoQuartoEstagio,
    inicioQuartoEstagio,
    desistenciaQuartoEstagio,
    quartoRitoPassagem,
    dataQuartoDesligamento,
    justificativaQuartoDesligamento,
    dataBatizado,
    padrinhoBatismo,
    madrinhaBatismo,
    dataJogoOrixa,
    primeiraCamarinha,
    segundaCamarinha,
    terceiraCamarinha,
    dataCoroacaoSacerdote,
    atividadeEspiritual,
    grupoTrabalhoEspiritual,
    grupoTarefa,
    acaoSocial,
    cargoLideranca,
    primeiroOrixa,
    adjuntoPrimeiroOrixa,
    segundoOrixa,
    adjuntoSegundoOrixa,
    terceiroOrixa,
    quartoOrixa,
    observacoesOrixa,
    nomePr,
    nomeBai,
    nomeCab,
    nomeMar,
    nomeMal,
    nomeCig,
    nomePv,
    dataCriacao,
    dataUltimaAlteracao,
  ];

  Membro copyWith({
    String? id,
    String? numeroCadastro,
    String? cpf,
    String? nome,
    String? nucleo,
    String? status,
    String? funcao,
    String? classificacao,
    String? diaSessao,
    String? primeiroContatoEmergencia,
    String? segundoContatoEmergencia,
    DateTime? inicioPrimeiroEstagio,
    DateTime? desistenciaPrimeiroEstagio,
    DateTime? primeiroRitoPassagem,
    DateTime? dataPrimeiroDesligamento,
    String? justificativaPrimeiroDesligamento,
    String? condicaoSegundoEstagio,
    DateTime? inicioSegundoEstagio,
    DateTime? desistenciaSegundoEstagio,
    DateTime? segundoRitoPassagem,
    DateTime? dataSegundoDesligamento,
    String? justificativaSegundoDesligamento,
    String? condicaoTerceiroEstagio,
    DateTime? inicioTerceiroEstagio,
    DateTime? desistenciaTerceiroEstagio,
    DateTime? terceiroRitoPassagem,
    DateTime? dataTerceiroDesligamento,
    String? justificativaTerceiroDesligamento,
    String? condicaoQuartoEstagio,
    DateTime? inicioQuartoEstagio,
    DateTime? desistenciaQuartoEstagio,
    DateTime? quartoRitoPassagem,
    DateTime? dataQuartoDesligamento,
    String? justificativaQuartoDesligamento,
    DateTime? dataBatizado,
    String? padrinhoBatismo,
    String? madrinhaBatismo,
    DateTime? dataJogoOrixa,
    DateTime? primeiraCamarinha,
    DateTime? segundaCamarinha,
    DateTime? terceiraCamarinha,
    DateTime? dataCoroacaoSacerdote,
    String? atividadeEspiritual,
    String? grupoTrabalhoEspiritual,
    String? grupoTarefa,
    String? acaoSocial,
    String? cargoLideranca,
    String? primeiroOrixa,
    String? adjuntoPrimeiroOrixa,
    String? segundoOrixa,
    String? adjuntoSegundoOrixa,
    String? terceiroOrixa,
    String? quartoOrixa,
    String? observacoesOrixa,
    String? nomePr,
    String? nomeBai,
    String? nomeCab,
    String? nomeMar,
    String? nomeMal,
    String? nomeCig,
    String? nomePv,
    DateTime? dataCriacao,
    DateTime? dataUltimaAlteracao,
  }) {
    return Membro(
      id: id ?? this.id,
      numeroCadastro: numeroCadastro ?? this.numeroCadastro,
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      nucleo: nucleo ?? this.nucleo,
      status: status ?? this.status,
      funcao: funcao ?? this.funcao,
      classificacao: classificacao ?? this.classificacao,
      diaSessao: diaSessao ?? this.diaSessao,
      primeiroContatoEmergencia:
          primeiroContatoEmergencia ?? this.primeiroContatoEmergencia,
      segundoContatoEmergencia:
          segundoContatoEmergencia ?? this.segundoContatoEmergencia,
      inicioPrimeiroEstagio:
          inicioPrimeiroEstagio ?? this.inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio:
          desistenciaPrimeiroEstagio ?? this.desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: primeiroRitoPassagem ?? this.primeiroRitoPassagem,
      dataPrimeiroDesligamento:
          dataPrimeiroDesligamento ?? this.dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento:
          justificativaPrimeiroDesligamento ??
          this.justificativaPrimeiroDesligamento,
      condicaoSegundoEstagio:
          condicaoSegundoEstagio ?? this.condicaoSegundoEstagio,
      inicioSegundoEstagio: inicioSegundoEstagio ?? this.inicioSegundoEstagio,
      desistenciaSegundoEstagio:
          desistenciaSegundoEstagio ?? this.desistenciaSegundoEstagio,
      segundoRitoPassagem: segundoRitoPassagem ?? this.segundoRitoPassagem,
      dataSegundoDesligamento:
          dataSegundoDesligamento ?? this.dataSegundoDesligamento,
      justificativaSegundoDesligamento:
          justificativaSegundoDesligamento ??
          this.justificativaSegundoDesligamento,
      condicaoTerceiroEstagio:
          condicaoTerceiroEstagio ?? this.condicaoTerceiroEstagio,
      inicioTerceiroEstagio:
          inicioTerceiroEstagio ?? this.inicioTerceiroEstagio,
      desistenciaTerceiroEstagio:
          desistenciaTerceiroEstagio ?? this.desistenciaTerceiroEstagio,
      terceiroRitoPassagem: terceiroRitoPassagem ?? this.terceiroRitoPassagem,
      dataTerceiroDesligamento:
          dataTerceiroDesligamento ?? this.dataTerceiroDesligamento,
      justificativaTerceiroDesligamento:
          justificativaTerceiroDesligamento ??
          this.justificativaTerceiroDesligamento,
      condicaoQuartoEstagio:
          condicaoQuartoEstagio ?? this.condicaoQuartoEstagio,
      inicioQuartoEstagio: inicioQuartoEstagio ?? this.inicioQuartoEstagio,
      desistenciaQuartoEstagio:
          desistenciaQuartoEstagio ?? this.desistenciaQuartoEstagio,
      quartoRitoPassagem: quartoRitoPassagem ?? this.quartoRitoPassagem,
      dataQuartoDesligamento:
          dataQuartoDesligamento ?? this.dataQuartoDesligamento,
      justificativaQuartoDesligamento:
          justificativaQuartoDesligamento ??
          this.justificativaQuartoDesligamento,
      dataBatizado: dataBatizado ?? this.dataBatizado,
      padrinhoBatismo: padrinhoBatismo ?? this.padrinhoBatismo,
      madrinhaBatismo: madrinhaBatismo ?? this.madrinhaBatismo,
      dataJogoOrixa: dataJogoOrixa ?? this.dataJogoOrixa,
      primeiraCamarinha: primeiraCamarinha ?? this.primeiraCamarinha,
      segundaCamarinha: segundaCamarinha ?? this.segundaCamarinha,
      terceiraCamarinha: terceiraCamarinha ?? this.terceiraCamarinha,
      dataCoroacaoSacerdote:
          dataCoroacaoSacerdote ?? this.dataCoroacaoSacerdote,
      atividadeEspiritual: atividadeEspiritual ?? this.atividadeEspiritual,
      grupoTrabalhoEspiritual:
          grupoTrabalhoEspiritual ?? this.grupoTrabalhoEspiritual,
      grupoTarefa: grupoTarefa ?? this.grupoTarefa,
      acaoSocial: acaoSocial ?? this.acaoSocial,
      cargoLideranca: cargoLideranca ?? this.cargoLideranca,
      primeiroOrixa: primeiroOrixa ?? this.primeiroOrixa,
      adjuntoPrimeiroOrixa: adjuntoPrimeiroOrixa ?? this.adjuntoPrimeiroOrixa,
      segundoOrixa: segundoOrixa ?? this.segundoOrixa,
      adjuntoSegundoOrixa: adjuntoSegundoOrixa ?? this.adjuntoSegundoOrixa,
      terceiroOrixa: terceiroOrixa ?? this.terceiroOrixa,
      quartoOrixa: quartoOrixa ?? this.quartoOrixa,
      observacoesOrixa: observacoesOrixa ?? this.observacoesOrixa,
      nomePr: nomePr ?? this.nomePr,
      nomeBai: nomeBai ?? this.nomeBai,
      nomeCab: nomeCab ?? this.nomeCab,
      nomeMar: nomeMar ?? this.nomeMar,
      nomeMal: nomeMal ?? this.nomeMal,
      nomeCig: nomeCig ?? this.nomeCig,
      nomePv: nomePv ?? this.nomePv,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }
}
