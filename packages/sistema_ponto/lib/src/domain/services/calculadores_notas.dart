import '../entities/calendario.dart';
import '../entities/membro_avaliacao.dart';

/// Calculadores para as demais notas (B a L)
class CalculadorNotaB {
  /// Nota B: Frequência em Atividades Espirituais
  double calcular({
    required MembroAvaliacao membro,
    required List<AtividadeCalendario> atividadesDoMes,
    required List<RegistroPresenca> presencas,
  }) {
    if (membro.grupoTrabalhoEspiritual == null) {
      return 0.0; // Não pertence a nenhum grupo
    }

    // Verificar se houve atividade do grupo no mês
    final atividadesDoGrupo = atividadesDoMes.where((atividade) {
      return atividade.tipo == TipoAtividadeCalendario.grupoTrabalhoEspiritual &&
          atividade.grupoRelacionado == membro.grupoTrabalhoEspiritual.toString();
    }).toList();

    if (atividadesDoGrupo.isEmpty) {
      return 10.0; // Grupo não teve atividade
    }

    // Verificar se compareceu
    final compareceu = atividadesDoGrupo.any((atividade) {
      return presencas.any((p) => p.atividadeId == atividade.id! && p.presente);
    });

    return compareceu ? 10.0 : 0.0;
  }
}

class CalculadorNotaC {
  /// Nota C: Conceito de Grupo-Tarefa (dado pelo líder)
  double calcular({
    required MembroAvaliacao membro,
    required Map<String, double> conceitosLideres,
  }) {
    if (membro.gruposTarefa.isEmpty) {
      return 0.0; // Não pertence a nenhum grupo-tarefa
    }

    // Buscar conceito dado pelo líder do grupo-tarefa
    for (var grupo in membro.gruposTarefa) {
      final conceito = conceitosLideres[grupo.toString()];
      if (conceito != null) {
        return conceito; // Retorna o conceito do primeiro grupo encontrado
      }
    }

    return 0.0; // Sem conceito registrado
  }
}

class CalculadorNotaD {
  /// Nota D: Conceito de Grupo de Ação Social
  double calcular({
    required MembroAvaliacao membro,
    required Map<String, double> conceitosLideres,
  }) {
    if (membro.gruposTarefa.isNotEmpty) {
      return 10.0; // Já pertence a grupo-tarefa
    }

    if (membro.gruposAcaoSocial.isEmpty) {
      return 0.0; // Não pertence a nenhum grupo de ação social
    }

    // Buscar conceito dado pelo líder do grupo de ação social
    for (var grupo in membro.gruposAcaoSocial) {
      final conceito = conceitosLideres[grupo.toString()];
      if (conceito != null) {
        return conceito;
      }
    }

    return 0.0;
  }
}

class CalculadorNotaE {
  /// Nota E: Assistência às Instruções Espirituais (COR e Ramatis)
  double calcular({
    required List<AtividadeCalendario> instrucoesDoMes,
    required List<RegistroPresenca> presencas,
    required String membroId,
  }) {
    if (instrucoesDoMes.isEmpty) {
      return 10.0; // Não houve COR nem Ramatis
    }

    // Contar presenças em instruções
    final presencasInstrucoes = instrucoesDoMes.where((instrucao) {
      return presencas.any((p) =>
          p.membroId == membroId &&
          p.atividadeId == instrucao.id! &&
          p.presente);
    }).length;

    if (instrucoesDoMes.length == 1) {
      return presencasInstrucoes >= 1 ? 10.0 : 5.0;
    }

    // Mais de uma instrução
    if (presencasInstrucoes >= 2) {
      return 10.0;
    } else if (presencasInstrucoes == 1) {
      return 5.0;
    } else {
      return 0.0;
    }
  }
}

class CalculadorNotaF {
  /// Nota F: Presença em Escalas de Cambonagem
  double calcular({
    required List<AtividadeCalendario> escalasCambonagem,
    required List<RegistroPresenca> presencas,
    required String membroId,
  }) {
    if (escalasCambonagem.isEmpty) {
      return 10.0; // Não estava escalado
    }

    // Verificar se compareceu ou trocou
    final compareceuOuTrocou = escalasCambonagem.any((escala) {
      return presencas.any((p) =>
          p.membroId == membroId &&
          p.atividadeId == escala.id! &&
          (p.presente || p.trocouEscala));
    });

    return compareceuOuTrocou ? 10.0 : 0.0;
  }
}

class CalculadorNotaG {
  /// Nota G: Presença em Escalas de Arrumação/Desarrumação
  double calcular({
    required List<AtividadeCalendario> escalasArrumacao,
    required List<RegistroPresenca> presencas,
    required String membroId,
  }) {
    if (escalasArrumacao.isEmpty) {
      return 10.0; // Não estava escalado
    }

    // Verificar se compareceu ou trocou
    final compareceuOuTrocou = escalasArrumacao.any((escala) {
      return presencas.any((p) =>
          p.membroId == membroId &&
          p.atividadeId == escala.id! &&
          (p.presente || p.trocouEscala));
    });

    return compareceuOuTrocou ? 10.0 : 0.0;
  }
}

class CalculadorNotaH {
  /// Nota H: Assiduidade de Pagamento de Mensalidade
  double calcular({required bool mensalidadeEmDia}) {
    return mensalidadeEmDia ? 10.0 : 0.0;
  }
}

class CalculadorNotaI {
  /// Nota I: Conceito dado pelo Pai/Mãe de Terreiro
  double calcular({required Map<String, double> conceitosPaisMaes, required String membroId}) {
    return conceitosPaisMaes[membroId] ?? 0.0;
  }
}

class CalculadorNotaJ {
  /// Nota J: Bônus dado pelo Tata
  double calcular({required Map<String, double> bonusTata, required String membroId}) {
    return bonusTata[membroId] ?? 0.0;
  }
}

class CalculadorNotaK {
  /// Nota K: Nota do Mês Anterior
  double calcular({required double? notaMesAnterior, required bool membroNovo}) {
    if (membroNovo || notaMesAnterior == null) {
      return 10.0;
    }
    return notaMesAnterior;
  }
}

class CalculadorNotaL {
  /// Nota L: Bônus por Exercício de Liderança
  double calcular({required List<CargoLideranca> cargos}) {
    return cargos.length * 5.0; // 5 pontos por cargo
  }
}
