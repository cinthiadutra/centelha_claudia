import 'package:equatable/equatable.dart';

/// Entidade DiaSessao
class DiaSessao extends Equatable {
  final String? id;
  final String cod;
  final String nucleo;
  final String dia;
  final String? responsavel;
  final bool ativo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DiaSessao({
    this.id,
    required this.cod,
    required this.nucleo,
    required this.dia,
    this.responsavel,
    this.ativo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory DiaSessao.fromJson(Map<String, dynamic> json) {
    return DiaSessao(
      id: json['id'] as String?,
      cod: json['cod'] as String,
      nucleo: json['nucleo'] as String,
      dia: json['dia'] as String,
      responsavel: json['responsavel'] as String?,
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
        nucleo,
        dia,
        responsavel,
        ativo,
        createdAt,
        updatedAt,
      ];

  DiaSessao copyWith({
    String? id,
    String? cod,
    String? nucleo,
    String? dia,
    String? responsavel,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiaSessao(
      id: id ?? this.id,
      cod: cod ?? this.cod,
      nucleo: nucleo ?? this.nucleo,
      dia: dia ?? this.dia,
      responsavel: responsavel ?? this.responsavel,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cod': cod,
      'nucleo': nucleo,
      'dia': dia,
      'responsavel': responsavel,
      'ativo': ativo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
