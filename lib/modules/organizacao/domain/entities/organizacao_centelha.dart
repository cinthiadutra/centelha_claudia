import 'package:equatable/equatable.dart';

/// Entidade que representa a organização da CENTELHA
class OrganizacaoCentelha extends Equatable {
  final String id;
  final String nome;
  final String cnpj;
  final String endereco;
  final String cidade;
  final String estado;
  final String cep;
  final String telefone;
  final String email;
  final String siteWeb;
  final String? logoUrl;
  final String presidenteNome;
  final String presidenteCadastro;
  final String vicepresidenteNome;
  final String vicepresidenteCadastro;
  final String secretarioNome;
  final String secretarioCadastro;
  final String tesoureiroNome;
  final String tesoureiroCadastro;
  final DateTime dataFundacao;
  final DateTime? dataUltimaAlteracao;
  final String? observacoes;

  const OrganizacaoCentelha({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.telefone,
    required this.email,
    required this.siteWeb,
    this.logoUrl,
    required this.presidenteNome,
    required this.presidenteCadastro,
    required this.vicepresidenteNome,
    required this.vicepresidenteCadastro,
    required this.secretarioNome,
    required this.secretarioCadastro,
    required this.tesoureiroNome,
    required this.tesoureiroCadastro,
    required this.dataFundacao,
    this.dataUltimaAlteracao,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
    id,
    nome,
    cnpj,
    endereco,
    cidade,
    estado,
    cep,
    telefone,
    email,
    siteWeb,
    logoUrl,
    presidenteNome,
    presidenteCadastro,
    vicepresidenteNome,
    vicepresidenteCadastro,
    secretarioNome,
    secretarioCadastro,
    tesoureiroNome,
    tesoureiroCadastro,
    dataFundacao,
    dataUltimaAlteracao,
    observacoes,
  ];

  OrganizacaoCentelha copyWith({
    String? id,
    String? nome,
    String? cnpj,
    String? endereco,
    String? cidade,
    String? estado,
    String? cep,
    String? telefone,
    String? email,
    String? siteWeb,
    String? logoUrl,
    String? presidenteNome,
    String? presidenteCadastro,
    String? vicepresidenteNome,
    String? vicepresidenteCadastro,
    String? secretarioNome,
    String? secretarioCadastro,
    String? tesoureiroNome,
    String? tesoureiroCadastro,
    DateTime? dataFundacao,
    DateTime? dataUltimaAlteracao,
    String? observacoes,
  }) {
    return OrganizacaoCentelha(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      siteWeb: siteWeb ?? this.siteWeb,
      logoUrl: logoUrl ?? this.logoUrl,
      presidenteNome: presidenteNome ?? this.presidenteNome,
      presidenteCadastro: presidenteCadastro ?? this.presidenteCadastro,
      vicepresidenteNome: vicepresidenteNome ?? this.vicepresidenteNome,
      vicepresidenteCadastro:
          vicepresidenteCadastro ?? this.vicepresidenteCadastro,
      secretarioNome: secretarioNome ?? this.secretarioNome,
      secretarioCadastro: secretarioCadastro ?? this.secretarioCadastro,
      tesoureiroNome: tesoureiroNome ?? this.tesoureiroNome,
      tesoureiroCadastro: tesoureiroCadastro ?? this.tesoureiroCadastro,
      dataFundacao: dataFundacao ?? this.dataFundacao,
      dataUltimaAlteracao: dataUltimaAlteracao ?? this.dataUltimaAlteracao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
