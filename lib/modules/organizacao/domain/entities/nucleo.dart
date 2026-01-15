import 'package:equatable/equatable.dart';

/// Entidade Nucleo
class Nucleo extends Equatable {
  final String cod;
  final String sigla;
  final String nome;
  final String? coordenador;
  final bool ativo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Nucleo({
    required this.cod,
    required this.sigla,
    required this.nome,
    this.coordenador,
    this.ativo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Nucleo.fromJson(Map<String, dynamic> json) {
    return Nucleo(
      cod: json['cod'] as String,
      sigla: json['sigla'] as String,
      nome: json['nome'] as String,
      coordenador: json['coordenador'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        cod,
        sigla,
        nome,
        coordenador,
        ativo,
        createdAt,
        updatedAt,
      ];

  Nucleo copyWith({
    String? cod,
    String? sigla,
    String? nome,
    String? coordenador,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Nucleo(
      cod: cod ?? this.cod,
      sigla: sigla ?? this.sigla,
      nome: nome ?? this.nome,
      coordenador: coordenador ?? this.coordenador,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod': cod,
      'sigla': sigla,
      'nome': nome,
      'coordenador': coordenador,
      'ativo': ativo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
