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
      numeroConsulta: json['numero_consulta'] as String? ?? '',
      data: json['data_consulta'] != null
          ? DateTime.parse(json['data_consulta'] as String)
          : DateTime.now(),
      horaInicio: json['data_consulta'] != null
          ? DateTime.parse(json['data_consulta'] as String).toIso8601String().substring(11, 16)
          : '00:00',
      cadastroConsulente: json['cadastro_consulente'] as String? ?? '',
      cadastroCambono: '',
      cadastroMedium: '',
      nomeConsulente: json['nome_consulente'] as String? ?? '',
      nomeCambono: '',
      nomeMedium: json['atendente'] as String? ?? '',
      nomeEntidade: json['atendente'] as String? ?? '',
      descricaoConsulta: json['descricao'] as String? ?? '',
      dataCriacao: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      dataUltimaAlteracao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_consulta': numeroConsulta,
      'data_consulta': data.toIso8601String(),
      'cadastro_consulente': cadastroConsulente.isEmpty ? null : cadastroConsulente,
      'nome_consulente': nomeConsulente,
      'atendente': nomeEntidade,
      'descricao': descricaoConsulta,
      'tipo_consulta': 'Consulta Espiritual',
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
