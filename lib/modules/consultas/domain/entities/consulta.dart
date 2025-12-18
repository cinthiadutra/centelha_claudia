import 'package:equatable/equatable.dart';

/// Entidade de Consulta Espiritual
class Consulta extends Equatable {
  final String? id;
  final String numeroConsulta; // 5 dígitos auto-incrementado
  final DateTime data;
  final String horaInicio; // HH:mm
  
  // Cadastros (referências)
  final String cadastroConsulente;
  final String cadastroCambono;
  final String cadastroMedium;
  
  // Nomes (preenchidos automaticamente)
  final String nomeConsulente;
  final String nomeCambono;
  final String nomeMedium;
  
  // Entidade e descrição
  final String nomeEntidade;
  final String descricaoConsulta;
  
  // Metadados
  final DateTime? dataCriacao;
  final DateTime? dataUltimaAlteracao;

  const Consulta({
    this.id,
    required this.numeroConsulta,
    required this.data,
    required this.horaInicio,
    required this.cadastroConsulente,
    required this.cadastroCambono,
    required this.cadastroMedium,
    required this.nomeConsulente,
    required this.nomeCambono,
    required this.nomeMedium,
    required this.nomeEntidade,
    required this.descricaoConsulta,
    this.dataCriacao,
    this.dataUltimaAlteracao,
  });

  Consulta copyWith({
    String? id,
    String? numeroConsulta,
    DateTime? data,
    String? horaInicio,
    String? cadastroConsulente,
    String? cadastroCambono,
    String? cadastroMedium,
    String? nomeConsulente,
    String? nomeCambono,
    String? nomeMedium,
    String? nomeEntidade,
    String? descricaoConsulta,
    DateTime? dataCriacao,
    DateTime? dataUltimaAlteracao,
  }) {
    return Consulta(
      id: id ?? this.id,
      numeroConsulta: numeroConsulta ?? this.numeroConsulta,
      data: data ?? this.data,
      horaInicio: horaInicio ?? this.horaInicio,
      cadastroConsulente: cadastroConsulente ?? this.cadastroConsulente,
      cadastroCambono: cadastroCambono ?? this.cadastroCambono,
      cadastroMedium: cadastroMedium ?? this.cadastroMedium,
      nomeConsulente: nomeConsulente ?? this.nomeConsulente,
      nomeCambono: nomeCambono ?? this.nomeCambono,
      nomeMedium: nomeMedium ?? this.nomeMedium,
      nomeEntidade: nomeEntidade ?? this.nomeEntidade,
      descricaoConsulta: descricaoConsulta ?? this.descricaoConsulta,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
    );
  }

  @override
  List<Object?> get props => [
        id,
        numeroConsulta,
        data,
        horaInicio,
        cadastroConsulente,
        cadastroCambono,
        cadastroMedium,
        nomeConsulente,
        nomeCambono,
        nomeMedium,
        nomeEntidade,
        descricaoConsulta,
        dataCriacao,
        dataUltimaAlteracao,
      ];
}
