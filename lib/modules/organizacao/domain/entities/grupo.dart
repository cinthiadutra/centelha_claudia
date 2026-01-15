import 'package:equatable/equatable.dart';

/// Entidade Grupo (unificada para grupo_tarefa, acao_social e trabalho_espiritual)
class Grupo extends Equatable {
  final String? id;
  final String nome;
  final String tipo;
  final String? descricao;
  final String? lider;
  final bool ativo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Grupo({
    this.id,
    required this.nome,
    required this.tipo,
    this.descricao,
    this.lider,
    this.ativo = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        tipo,
        descricao,
        lider,
        ativo,
        createdAt,
        updatedAt,
      ];

  Grupo copyWith({
    String? id,
    String? nome,
    String? tipo,
    String? descricao,
    String? lider,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Grupo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      lider: lider ?? this.lider,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'tipo': tipo,
      'descricao': descricao,
      'lider': lider,
      'ativo': ativo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'] as String?,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      descricao: json['descricao'] as String?,
      lider: json['lider'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  String get tipoExtenso {
    switch (tipo) {
      case 'grupo_tarefa':
        return 'Grupo-Tarefa';
      case 'acao_social':
        return 'Ação Social';
      case 'trabalho_espiritual':
        return 'Trabalho Espiritual';
      default:
        return tipo;
    }
  }
}
