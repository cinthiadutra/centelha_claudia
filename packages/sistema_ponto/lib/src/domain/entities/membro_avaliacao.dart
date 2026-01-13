import 'package:equatable/equatable.dart';

/// Cargo de liderança
enum CargoLideranca {
  diretoria,
  liderGrupoTarefa,
  liderGrupoAcaoSocial,
  coordenadorDepartamento, // DIJ, DIM, DAS
  paiMaeTerreiro,
}

/// Classificação mediúnica do membro
enum ClassificacaoMedinica {
  cambono,
  curimbeiro,
  grauVermelho,
  grauCoral,
  grauAmarelo,
  grauVerde,
  grauAzul,
  grauIndigo,
  grauLilas,
  dirigente,
}

/// Dia de sessão
enum DiaSessao {
  tercaCCU,
  tercaCCUOju,
  quartaCCU,
  sextaCCU,
  sabadoCCU,
  sabadoCPO,
}

/// Grupo de ação social
enum GrupoAcaoSocial {
  coordenacao,
  captacaoRecursos,
  projetoSimiromba,
  projetoVisitandoVidas,
  projetoPaoNosso,
  projetoAquecendoCoracoes,
  projetoGestarAmarCuidar,
  projetoBancoAjuda,
  projetoVestibularSemBarreiras,
  projetoEncaminhamentoProfissional,
  projetoArteCriativa,
  projetoTerapias,
}

/// Grupo tarefa
enum GrupoTarefa {
  controlePatrimonioEstoque,
  auxilioSecretaria,
  vendas,
  comunicacaoMarketing,
}

/// Grupo de trabalho espiritual
enum GrupoTrabalhoEspiritual {
  grupoPaz,
  grupoLuz,
  grupoFe,
  grupoAmor,
  grupoForca,
  grupoEsperanca,
  grupoUniao,
}

/// Entidade Membro do sistema de avaliação
class MembroAvaliacao extends Equatable {
  final String? id;
  final String nomeCompleto;
  final ClassificacaoMedinica classificacao;
  final Nucleo nucleo;
  final DiaSessao diaSessao;
  
  // Grupos e atividades
  final GrupoTrabalhoEspiritual? grupoTrabalhoEspiritual;
  final List<GrupoTarefa> gruposTarefa;
  final List<GrupoAcaoSocial> gruposAcaoSocial;
  final List<TipoAtividadeEspiritual> atividadesEspirituais;
  
  // Cargos de liderança
  final List<CargoLideranca> cargosLideranca;
  
  // Informações de pagamento
  final bool mensalidadeEmDia;
  
  // Identificação do pai/mãe de terreiro responsável
  final String? paiMaeTerreiro;
  
  // Status
  final bool ativo;
  final DateTime? dataCadastro;
  
  const MembroAvaliacao({
    this.id,
    required this.nomeCompleto,
    required this.classificacao,
    required this.nucleo,
    required this.diaSessao,
    this.grupoTrabalhoEspiritual,
    this.gruposTarefa = const [],
    this.gruposAcaoSocial = const [],
    this.atividadesEspirituais = const [],
    this.cargosLideranca = const [],
    this.mensalidadeEmDia = true,
    this.paiMaeTerreiro,
    this.ativo = true,
    this.dataCadastro,
  });

  @override
  List<Object?> get props => [
        id,
        nomeCompleto,
        classificacao,
        nucleo,
        diaSessao,
        grupoTrabalhoEspiritual,
        gruposTarefa,
        gruposAcaoSocial,
        atividadesEspirituais,
        cargosLideranca,
        mensalidadeEmDia,
        paiMaeTerreiro,
        ativo,
        dataCadastro,
      ];

  MembroAvaliacao copyWith({
    String? id,
    String? nomeCompleto,
    ClassificacaoMedinica? classificacao,
    Nucleo? nucleo,
    DiaSessao? diaSessao,
    GrupoTrabalhoEspiritual? grupoTrabalhoEspiritual,
    List<GrupoTarefa>? gruposTarefa,
    List<GrupoAcaoSocial>? gruposAcaoSocial,
    List<TipoAtividadeEspiritual>? atividadesEspirituais,
    List<CargoLideranca>? cargosLideranca,
    bool? mensalidadeEmDia,
    String? paiMaeTerreiro,
    bool? ativo,
    DateTime? dataCadastro,
  }) {
    return MembroAvaliacao(
      id: id ?? this.id,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      classificacao: classificacao ?? this.classificacao,
      nucleo: nucleo ?? this.nucleo,
      diaSessao: diaSessao ?? this.diaSessao,
      grupoTrabalhoEspiritual: grupoTrabalhoEspiritual ?? this.grupoTrabalhoEspiritual,
      gruposTarefa: gruposTarefa ?? this.gruposTarefa,
      gruposAcaoSocial: gruposAcaoSocial ?? this.gruposAcaoSocial,
      atividadesEspirituais: atividadesEspirituais ?? this.atividadesEspirituais,
      cargosLideranca: cargosLideranca ?? this.cargosLideranca,
      mensalidadeEmDia: mensalidadeEmDia ?? this.mensalidadeEmDia,
      paiMaeTerreiro: paiMaeTerreiro ?? this.paiMaeTerreiro,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }
}

/// Núcleo do membro
enum Nucleo {
  ccu,
  cpo,
}

/// Tipo de atividade espiritual
enum TipoAtividadeEspiritual {
  encontroAmigosRamatis,
  correnteOracaoRenovacao,
  monitoriaCentelhinha,
  sessaoAntigoecia,
}
