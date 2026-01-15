import 'package:equatable/equatable.dart';

/// Entidade ClassificacaoMediunica
class ClassificacaoMediunica extends Equatable {
  final String? id;
  final String cod;
  final String nome;
  final int ordem;
  final String? tipo;
  final bool ativo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassificacaoMediunica({
    this.id,
    required this.cod,
    required this.nome,
    required this.ordem,
    this.tipo,
    this.ativo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassificacaoMediunica.fromJson(Map<String, dynamic> json) {
    return ClassificacaoMediunica(
      id: json['id'] as String?,
      cod: json['cod'] as String,
      nome: json['nome'] as String,
      ordem: json['ordem'] as int,
      tipo: json['tipo'] as String?,
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
        id,
        cod,
        nome,
        ordem,
        tipo,
        ativo,
        createdAt,
        updatedAt,
      ];

  ClassificacaoMediunica copyWith({
    String? id,
    String? cod,
    String? nome,
    int? ordem,
    String? tipo,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassificacaoMediunica(
      id: id ?? this.id,
      cod: cod ?? this.cod,
      nome: nome ?? this.nome,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cod': cod,
      'nome': nome,
      'ordem': ordem,
      'tipo': tipo,
      'ativo': ativo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
