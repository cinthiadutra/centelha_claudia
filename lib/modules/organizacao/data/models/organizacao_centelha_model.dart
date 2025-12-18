import '../../domain/entities/organizacao_centelha.dart';

/// Model para serialização/deserialização de OrganizacaoCentelha
class OrganizacaoCentelhaModel extends OrganizacaoCentelha {
  const OrganizacaoCentelhaModel({
    required super.id,
    required super.nome,
    required super.cnpj,
    required super.endereco,
    required super.cidade,
    required super.estado,
    required super.cep,
    required super.telefone,
    required super.email,
    required super.siteWeb,
    super.logoUrl,
    required super.presidenteNome,
    required super.presidenteCadastro,
    required super.vicepresidenteNome,
    required super.vicepresidenteCadastro,
    required super.secretarioNome,
    required super.secretarioCadastro,
    required super.tesoureiroNome,
    required super.tesoureiroCadastro,
    required super.dataFundacao,
    super.dataUltimaAlteracao,
    super.observacoes,
  });

  factory OrganizacaoCentelhaModel.fromEntity(OrganizacaoCentelha entity) {
    return OrganizacaoCentelhaModel(
      id: entity.id,
      nome: entity.nome,
      cnpj: entity.cnpj,
      endereco: entity.endereco,
      cidade: entity.cidade,
      estado: entity.estado,
      cep: entity.cep,
      telefone: entity.telefone,
      email: entity.email,
      siteWeb: entity.siteWeb,
      logoUrl: entity.logoUrl,
      presidenteNome: entity.presidenteNome,
      presidenteCadastro: entity.presidenteCadastro,
      vicepresidenteNome: entity.vicepresidenteNome,
      vicepresidenteCadastro: entity.vicepresidenteCadastro,
      secretarioNome: entity.secretarioNome,
      secretarioCadastro: entity.secretarioCadastro,
      tesoureiroNome: entity.tesoureiroNome,
      tesoureiroCadastro: entity.tesoureiroCadastro,
      dataFundacao: entity.dataFundacao,
      dataUltimaAlteracao: entity.dataUltimaAlteracao,
      observacoes: entity.observacoes,
    );
  }

  factory OrganizacaoCentelhaModel.fromJson(Map<String, dynamic> json) {
    return OrganizacaoCentelhaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cnpj: json['cnpj'] as String,
      endereco: json['endereco'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      cep: json['cep'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      siteWeb: json['siteWeb'] as String,
      logoUrl: json['logoUrl'] as String?,
      presidenteNome: json['presidenteNome'] as String,
      presidenteCadastro: json['presidenteCadastro'] as String,
      vicepresidenteNome: json['vicepresidenteNome'] as String,
      vicepresidenteCadastro: json['vicepresidenteCadastro'] as String,
      secretarioNome: json['secretarioNome'] as String,
      secretarioCadastro: json['secretarioCadastro'] as String,
      tesoureiroNome: json['tesoureiroNome'] as String,
      tesoureiroCadastro: json['tesoureiroCadastro'] as String,
      dataFundacao: DateTime.parse(json['dataFundacao'] as String),
      dataUltimaAlteracao: json['dataUltimaAlteracao'] != null
          ? DateTime.parse(json['dataUltimaAlteracao'] as String)
          : null,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'telefone': telefone,
      'email': email,
      'siteWeb': siteWeb,
      'logoUrl': logoUrl,
      'presidenteNome': presidenteNome,
      'presidenteCadastro': presidenteCadastro,
      'vicepresidenteNome': vicepresidenteNome,
      'vicepresidenteCadastro': vicepresidenteCadastro,
      'secretarioNome': secretarioNome,
      'secretarioCadastro': secretarioCadastro,
      'tesoureiroNome': tesoureiroNome,
      'tesoureiroCadastro': tesoureiroCadastro,
      'dataFundacao': dataFundacao.toIso8601String(),
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
      'observacoes': observacoes,
    };
  }
}
