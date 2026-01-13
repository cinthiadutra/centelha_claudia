import 'package:equatable/equatable.dart';

/// Avaliação mensal de um membro
class AvaliacaoMensal extends Equatable {
  final String? id;
  final String membroId;
  final String membroNome;
  final int mes;
  final int ano;
  
  // Notas de A a L (0 a 10 pontos cada)
  final double notaA; // Frequência em sessões mediúnicas
  final double notaB; // Frequência em atividades espirituais
  final double notaC; // Conceito grupo-tarefa
  final double notaD; // Conceito grupo ação social
  final double notaE; // Assistência a instruções espirituais
  final double notaF; // Presença em escalas de cambonagem
  final double notaG; // Presença em escalas de arrumação/desarrumação
  final double notaH; // Assiduidade pagamento mensalidade
  final double notaI; // Conceito pai/mãe de terreiro
  final double notaJ; // Bônus dado pelo Tata
  final double notaK; // Nota do mês anterior
  final double notaL; // Bônus por liderança
  
  // Cálculos
  final double notaReal; // Somatório de todas as notas
  final double notaFinal; // Nota normalizada (0-100)
  
  // Metadados
  final DateTime dataCalculo;
  final String? observacoes;
  
  const AvaliacaoMensal({
    this.id,
    required this.membroId,
    required this.membroNome,
    required this.mes,
    required this.ano,
    required this.notaA,
    required this.notaB,
    required this.notaC,
    required this.notaD,
    required this.notaE,
    required this.notaF,
    required this.notaG,
    required this.notaH,
    required this.notaI,
    required this.notaJ,
    required this.notaK,
    required this.notaL,
    required this.notaReal,
    required this.notaFinal,
    required this.dataCalculo,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        id,
        membroId,
        membroNome,
        mes,
        ano,
        notaA,
        notaB,
        notaC,
        notaD,
        notaE,
        notaF,
        notaG,
        notaH,
        notaI,
        notaJ,
        notaK,
        notaL,
        notaReal,
        notaFinal,
        dataCalculo,
        observacoes,
      ];

  AvaliacaoMensal copyWith({
    String? id,
    String? membroId,
    String? membroNome,
    int? mes,
    int? ano,
    double? notaA,
    double? notaB,
    double? notaC,
    double? notaD,
    double? notaE,
    double? notaF,
    double? notaG,
    double? notaH,
    double? notaI,
    double? notaJ,
    double? notaK,
    double? notaL,
    double? notaReal,
    double? notaFinal,
    DateTime? dataCalculo,
    String? observacoes,
  }) {
    return AvaliacaoMensal(
      id: id ?? this.id,
      membroId: membroId ?? this.membroId,
      membroNome: membroNome ?? this.membroNome,
      mes: mes ?? this.mes,
      ano: ano ?? this.ano,
      notaA: notaA ?? this.notaA,
      notaB: notaB ?? this.notaB,
      notaC: notaC ?? this.notaC,
      notaD: notaD ?? this.notaD,
      notaE: notaE ?? this.notaE,
      notaF: notaF ?? this.notaF,
      notaG: notaG ?? this.notaG,
      notaH: notaH ?? this.notaH,
      notaI: notaI ?? this.notaI,
      notaJ: notaJ ?? this.notaJ,
      notaK: notaK ?? this.notaK,
      notaL: notaL ?? this.notaL,
      notaReal: notaReal ?? this.notaReal,
      notaFinal: notaFinal ?? this.notaFinal,
      dataCalculo: dataCalculo ?? this.dataCalculo,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
