import 'package:centelha_claudia/modules/membros/data/models/membro_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const guideNames = {
    'nome_pr': 'Vovó Rosa',
    'nome_bai': 'Zé Baiano',
    'nome_cab': 'Caboclo Sete Flechas',
    'nome_mar': 'Marinheiro João',
    'nome_mal': 'Zé Malandro',
    'nome_cig': 'Cigana Esmeralda',
    'nome_pv': 'Maria Padilha',
  };

  test('lê e grava os nomes dos guias com as colunas do Supabase', () {
    final membro = MembroModel.fromJson(guideNames);

    expect(membro.nomePr, guideNames['nome_pr']);
    expect(membro.nomeBai, guideNames['nome_bai']);
    expect(membro.nomeCab, guideNames['nome_cab']);
    expect(membro.nomeMar, guideNames['nome_mar']);
    expect(membro.nomeMal, guideNames['nome_mal']);
    expect(membro.nomeCig, guideNames['nome_cig']);
    expect(membro.nomePv, guideNames['nome_pv']);
    expect(
      membro.toJson(),
      containsPair('nome_pr', guideNames['nome_pr']!.toUpperCase()),
    );
  });

  test('preserva os nomes dos guias ao converter a entidade para o model', () {
    final membro = MembroModel(
      id: 'member-id',
      numeroCadastro: '123',
      cpf: '',
      nome: 'Membro',
      nucleo: 'Núcleo',
      status: 'Ativo',
      funcao: 'Médium',
      classificacao: 'A',
      diaSessao: 'Sábado',
      nomePr: guideNames['nome_pr'],
      nomeBai: guideNames['nome_bai'],
      nomeCab: guideNames['nome_cab'],
      nomeMar: guideNames['nome_mar'],
      nomeMal: guideNames['nome_mal'],
      nomeCig: guideNames['nome_cig'],
      nomePv: guideNames['nome_pv'],
    );

    final converted = MembroModel.fromEntity(membro);

    expect(converted.nomePr, membro.nomePr);
    expect(converted.nomeBai, membro.nomeBai);
    expect(converted.nomeCab, membro.nomeCab);
    expect(converted.nomeMar, membro.nomeMar);
    expect(converted.nomeMal, membro.nomeMal);
    expect(converted.nomeCig, membro.nomeCig);
    expect(converted.nomePv, membro.nomePv);
  });
}
