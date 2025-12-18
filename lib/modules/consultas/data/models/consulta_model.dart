import '../../domain/entities/consulta.dart';

/// Model para serialização/deserialização de Consulta
class ConsultaModel extends Consulta {
  const ConsultaModel({
    super.id,
    required super.numeroConsulta,
    required super.data,
    required super.horaInicio,
    required super.cadastroConsulente,
    required super.cadastroCambono,
    required super.cadastroMedium,
    required super.nomeConsulente,
    required super.nomeCambono,
    required super.nomeMedium,
    required super.nomeEntidade,
    required super.descricaoConsulta,
    super.dataCriacao,
    super.dataUltimaAlteracao,
  });

  factory ConsultaModel.fromJson(Map<String, dynamic> json) {
    return ConsultaModel(
      id: json['id'] as String?,
      numeroConsulta: json['numeroConsulta'] as String,
      data: DateTime.parse(json['data'] as String),
      horaInicio: json['horaInicio'] as String,
      cadastroConsulente: json['cadastroConsulente'] as String,
      cadastroCambono: json['cadastroCambono'] as String,
      cadastroMedium: json['cadastroMedium'] as String,
      nomeConsulente: json['nomeConsulente'] as String,
      nomeCambono: json['nomeCambono'] as String,
      nomeMedium: json['nomeMedium'] as String,
      nomeEntidade: json['nomeEntidade'] as String,
      descricaoConsulta: json['descricaoConsulta'] as String,
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.parse(json['dataCriacao'] as String)
          : null,
      dataUltimaAlteracao: json['dataUltimaAlteracao'] != null
          ? DateTime.parse(json['dataUltimaAlteracao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroConsulta': numeroConsulta,
      'data': data.toIso8601String(),
      'horaInicio': horaInicio,
      'cadastroConsulente': cadastroConsulente,
      'cadastroCambono': cadastroCambono,
      'cadastroMedium': cadastroMedium,
      'nomeConsulente': nomeConsulente,
      'nomeCambono': nomeCambono,
      'nomeMedium': nomeMedium,
      'nomeEntidade': nomeEntidade,
      'descricaoConsulta': descricaoConsulta,
      'dataCriacao': dataCriacao?.toIso8601String(),
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
    };
  }

  factory ConsultaModel.fromEntity(Consulta consulta) {
    return ConsultaModel(
      id: consulta.id,
      numeroConsulta: consulta.numeroConsulta,
      data: consulta.data,
      horaInicio: consulta.horaInicio,
      cadastroConsulente: consulta.cadastroConsulente,
      cadastroCambono: consulta.cadastroCambono,
      cadastroMedium: consulta.cadastroMedium,
      nomeConsulente: consulta.nomeConsulente,
      nomeCambono: consulta.nomeCambono,
      nomeMedium: consulta.nomeMedium,
      nomeEntidade: consulta.nomeEntidade,
      descricaoConsulta: consulta.descricaoConsulta,
      dataCriacao: consulta.dataCriacao,
      dataUltimaAlteracao: consulta.dataUltimaAlteracao,
    );
  }
}
