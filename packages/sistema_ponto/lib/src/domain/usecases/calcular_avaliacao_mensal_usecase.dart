import '../entities/avaliacao_mensal.dart';
import '../entities/calendario.dart';
import '../entities/membro_avaliacao.dart';
import '../services/calculador_nota_a.dart';
import '../services/calculadores_notas.dart';

/// UseCase para calcular avaliação mensal de um membro
class CalcularAvaliacaoMensalUseCase {
  final CalculadorNotaA _calculadorA = CalculadorNotaA();
  final CalculadorNotaB _calculadorB = CalculadorNotaB();
  final CalculadorNotaC _calculadorC = CalculadorNotaC();
  final CalculadorNotaD _calculadorD = CalculadorNotaD();
  final CalculadorNotaE _calculadorE = CalculadorNotaE();
  final CalculadorNotaF _calculadorF = CalculadorNotaF();
  final CalculadorNotaG _calculadorG = CalculadorNotaG();
  final CalculadorNotaH _calculadorH = CalculadorNotaH();
  final CalculadorNotaI _calculadorI = CalculadorNotaI();
  final CalculadorNotaJ _calculadorJ = CalculadorNotaJ();
  final CalculadorNotaK _calculadorK = CalculadorNotaK();
  final CalculadorNotaL _calculadorL = CalculadorNotaL();

  /// Calcula a avaliação mensal de um membro
  AvaliacaoMensal calcular(DadosCalculoAvaliacao dados) {
    // Filtrar atividades e presenças do membro
    final presencasMembro = dados.presencas
        .where((p) => p.membroId == dados.membro.id!)
        .toList();

    // Filtrar sessões mediúnicas
    final sessoes = dados.atividadesDoMes
        .where((a) => a.tipo == TipoAtividadeCalendario.sessaoMedianica)
        .toList();

    // Filtrar instruções (COR e Ramatis)
    final instrucoes = dados.atividadesDoMes.where((a) {
      return a.tipo == TipoAtividadeCalendario.correnteOracaoRenovacao ||
          a.tipo == TipoAtividadeCalendario.encontroRamatis;
    }).toList();

    // Filtrar escalas de cambonagem do membro
    final escalasCambonagem = dados.atividadesDoMes.where((a) {
      return a.tipo == TipoAtividadeCalendario.cambonagem &&
          presencasMembro.any((p) => p.atividadeId == a.id);
    }).toList();

    // Filtrar escalas de arrumação/desarrumação do membro
    final escalasArrumacao = dados.atividadesDoMes.where((a) {
      return (a.tipo == TipoAtividadeCalendario.arrumacao ||
              a.tipo == TipoAtividadeCalendario.desarrumacao) &&
          presencasMembro.any((p) => p.atividadeId == a.id);
    }).toList();

    // Calcular cada nota
    final notaA = _calculadorA.calcular(
      membro: dados.membro,
      sessoesDoMes: sessoes,
      presencas: presencasMembro,
    );

    final notaB = _calculadorB.calcular(
      membro: dados.membro,
      atividadesDoMes: dados.atividadesDoMes,
      presencas: presencasMembro,
    );

    final notaC = _calculadorC.calcular(
      membro: dados.membro,
      conceitosLideres: dados.conceitosLideresGrupoTarefa,
    );

    final notaD = _calculadorD.calcular(
      membro: dados.membro,
      conceitosLideres: dados.conceitosLideresAcaoSocial,
    );

    final notaE = _calculadorE.calcular(
      instrucoesDoMes: instrucoes,
      presencas: presencasMembro,
      membroId: dados.membro.id!,
    );

    final notaF = _calculadorF.calcular(
      escalasCambonagem: escalasCambonagem,
      presencas: presencasMembro,
      membroId: dados.membro.id!,
    );

    final notaG = _calculadorG.calcular(
      escalasArrumacao: escalasArrumacao,
      presencas: presencasMembro,
      membroId: dados.membro.id!,
    );

    final notaH = _calculadorH.calcular(
      mensalidadeEmDia: dados.membro.mensalidadeEmDia,
    );

    final notaI = _calculadorI.calcular(
      conceitosPaisMaes: dados.conceitosPaisMaes,
      membroId: dados.membro.id!,
    );

    final notaJ = _calculadorJ.calcular(
      bonusTata: dados.bonusTata,
      membroId: dados.membro.id!,
    );

    final notaK = _calculadorK.calcular(
      notaMesAnterior: dados.notaMesAnterior,
      membroNovo: dados.membroNovo,
    );

    final notaL = _calculadorL.calcular(
      cargos: dados.membro.cargosLideranca,
    );

    // Calcular nota real (somatório)
    final notaReal = notaA +
        notaB +
        notaC +
        notaD +
        notaE +
        notaF +
        notaG +
        notaH +
        notaI +
        notaJ +
        notaK +
        notaL;

    // Nota final será calculada posteriormente (normalização)
    // Por enquanto, igual à nota real
    final notaFinal = notaReal;

    return AvaliacaoMensal(
      membroId: dados.membro.id!,
      membroNome: dados.membro.nomeCompleto,
      mes: dados.mes,
      ano: dados.ano,
      notaA: notaA,
      notaB: notaB,
      notaC: notaC,
      notaD: notaD,
      notaE: notaE,
      notaF: notaF,
      notaG: notaG,
      notaH: notaH,
      notaI: notaI,
      notaJ: notaJ,
      notaK: notaK,
      notaL: notaL,
      notaReal: notaReal,
      notaFinal: notaFinal,
      dataCalculo: DateTime.now(),
    );
  }

  /// Normaliza as notas finais de uma lista de avaliações
  /// Equipara a maior nota real a 100
  List<AvaliacaoMensal> normalizarNotas(List<AvaliacaoMensal> avaliacoes) {
    if (avaliacoes.isEmpty) return avaliacoes;

    // Encontrar a maior nota real
    final maiorNotaReal = avaliacoes
        .map((a) => a.notaReal)
        .reduce((a, b) => a > b ? a : b);

    if (maiorNotaReal == 0) return avaliacoes;

    // Normalizar todas as notas
    return avaliacoes.map((avaliacao) {
      final notaFinalNormalizada = (avaliacao.notaReal / maiorNotaReal) * 100;
      return avaliacao.copyWith(notaFinal: notaFinalNormalizada);
    }).toList();
  }
}

/// Dados necessários para calcular avaliação mensal
class DadosCalculoAvaliacao {
  final MembroAvaliacao membro;
  final int mes;
  final int ano;
  final List<AtividadeCalendario> atividadesDoMes;
  final List<RegistroPresenca> presencas;
  final Map<String, double> conceitosLideresGrupoTarefa;
  final Map<String, double> conceitosLideresAcaoSocial;
  final Map<String, double> conceitosPaisMaes;
  final Map<String, double> bonusTata;
  final double? notaMesAnterior;
  final bool membroNovo;

  DadosCalculoAvaliacao({
    required this.membro,
    required this.mes,
    required this.ano,
    required this.atividadesDoMes,
    required this.presencas,
    required this.conceitosLideresGrupoTarefa,
    required this.conceitosLideresAcaoSocial,
    required this.conceitosPaisMaes,
    required this.bonusTata,
    this.notaMesAnterior,
    this.membroNovo = false,
  });
}
