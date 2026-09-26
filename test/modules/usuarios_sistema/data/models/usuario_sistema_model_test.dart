import 'package:centelha_claudia/modules/usuarios_sistema/data/models/usuario_sistema_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('perfil nunca lê nem serializa senha_hash', () {
    final model = UsuarioSistemaModel.fromJson({
      'id': 'auth-user-id',
      'numero_cadastro': null,
      'nome': 'Administrador',
      'username': 'admin',
      'email': 'admin@example.org',
      'senha_hash': 'legacy-plaintext-secret',
      'nivel_permissao': 4,
      'ativo': true,
      'created_at': '2026-09-25T00:00:00Z',
      'updated_at': null,
      'observacoes': null,
    });

    expect(model.toJson(), isNot(contains('senha_hash')));
    expect(model.toJson(), containsPair('id', 'auth-user-id'));
  });
}
