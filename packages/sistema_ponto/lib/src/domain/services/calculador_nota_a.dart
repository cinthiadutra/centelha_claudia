import '../entities/calendario.dart';
import '../entities/membro_avaliacao.dart';

/// Serviço para calcular a Nota A: Frequência em Sessões Mediúnicas
class CalculadorNotaA {
  /// Calcula a nota A baseado na classificação e presença
  double calcular({
    required MembroAvaliacao membro,
    required List<AtividadeCalendario> sessoesDoMes,
    required List<RegistroPresenca> presencas,
  }) {
    // Filtrar sessões do dia do membro
    final sessoesDoMembro = sessoesDoMes.where((atividade) {
      return atividade.tipo == TipoAtividadeCalendario.sessaoMedianica &&
          _pertenceAoDiaSessao(atividade, membro.diaSessao);
    }).toList();

    // Filtrar atendimentos públicos
    final atendimentosPublicos = sessoesDoMes.where((atividade) {
      return atividade.tipo == TipoAtividadeCalendario.atendimentoPublico;
    }).toList();

    // Calcular baseado na classificação
    if (_isCambonoOuCurimbeiro(membro.classificacao) ||
        _isGrauVermelhoOuCoral(membro.classificacao)) {
      return _calcularParaCambonoVermelhoOuCoral(sessoesDoMembro, presencas);
    } else if (membro.classificacao == ClassificacaoMedinica.grauAmarelo) {
      return _calcularParaGrauAmarelo(
        sessoesDoMembro,
        atendimentosPublicos,
        presencas,
      );
    } else {
      // Grau verde ou superior
      return _calcularParaGrauVerdeSuperior(atendimentosPublicos, presencas);
    }
  }

  double _calcularParaCambonoVermelhoOuCoral(
    List<AtividadeCalendario> sessoes,
    List<RegistroPresenca> presencas,
  ) {
    if (sessoes.isEmpty) {
      return 10.0; // Não houve sessão
    }

    if (sessoes.length == 1) {
      final compareceu = _verificarPresenca(sessoes[0].id!, presencas);
      return compareceu ? 10.0 : 5.0;
    }

    // Duas ou mais sessões
    final presencasCount = sessoes.where((s) => _verificarPresenca(s.id!, presencas)).length;
    
    if (presencasCount >= 2) {
      return 10.0;
    } else if (presencasCount == 1) {
      return 5.0;
    } else {
      return 0.0;
    }
  }

  double _calcularParaGrauAmarelo(
    List<AtividadeCalendario> sessoes,
    List<AtividadeCalendario> atendimentos,
    List<RegistroPresenca> presencas,
  ) {
    double pontosSessoes = 0.0;

    // Calcular pontos das sessões
    if (sessoes.isEmpty) {
      pontosSessoes = 5.0;
    } else if (sessoes.length == 1) {
      final compareceu = _verificarPresenca(sessoes[0].id!, presencas);
      pontosSessoes = compareceu ? 5.0 : 0.0;
    } else {
      final presencasCount = sessoes.where((s) => _verificarPresenca(s.id!, presencas)).length;
      pontosSessoes = presencasCount >= 1 ? 5.0 : 0.0;
    }

    // Calcular pontos dos atendimentos (se aplicável)
    if (atendimentos.isNotEmpty) {
      final compareceuAlgum = atendimentos.any((a) => _verificarPresenca(a.id!, presencas));
      if (compareceuAlgum) {
        pontosSessoes += 5.0; // Adiciona pontos de atendimento
      }
    } else {
      pontosSessoes += 5.0; // Sem atendimento = +5
    }

    return pontosSessoes;
  }

  double _calcularParaGrauVerdeSuperior(
    List<AtividadeCalendario> atendimentos,
    List<RegistroPresenca> presencas,
  ) {
    if (atendimentos.isEmpty) {
      return 10.0;
    }

    if (atendimentos.length == 1) {
      final compareceu = _verificarPresenca(atendimentos[0].id!, presencas);
      return compareceu ? 10.0 : 5.0;
    }

    // Dois ou mais atendimentos
    final presencasCount = atendimentos.where((a) => _verificarPresenca(a.id!, presencas)).length;
    
    if (presencasCount >= 2) {
      return 10.0;
    } else if (presencasCount == 1) {
      return 5.0;
    } else {
      return 0.0;
    }
  }

  String _getDiaSessaoString(DiaSessao dia) {
    switch (dia) {
      case DiaSessao.tercaCCU:
        return 'terça';
      case DiaSessao.quartaCCU:
        return 'quarta';
      case DiaSessao.sextaCCU:
        return 'sexta';
      case DiaSessao.sabadoCCU:
      case DiaSessao.sabadoCPO:
        return 'sábado';
      default:
        return '';
    }
  }

  bool _isCambonoOuCurimbeiro(ClassificacaoMedinica classificacao) {
    return classificacao == ClassificacaoMedinica.cambono ||
        classificacao == ClassificacaoMedinica.curimbeiro;
  }

  bool _isGrauVermelhoOuCoral(ClassificacaoMedinica classificacao) {
    return classificacao == ClassificacaoMedinica.grauVermelho ||
        classificacao == ClassificacaoMedinica.grauCoral;
  }

  bool _pertenceAoDiaSessao(AtividadeCalendario atividade, DiaSessao diaSessao) {
    // Simplificado - verificar se a atividade é do dia de sessão do membro
    return atividade.diaSessao != null &&
        atividade.diaSessao!.toLowerCase().contains(_getDiaSessaoString(diaSessao));
  }

  bool _verificarPresenca(String atividadeId, List<RegistroPresenca> presencas) {
    return presencas.any((p) => p.atividadeId == atividadeId && p.presente);
  }
}
