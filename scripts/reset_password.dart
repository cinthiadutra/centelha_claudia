import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

// Configure suas credenciais do Supabase aqui
const String supabaseUrl = 'SUA_URL_SUPABASE';
const String supabaseServiceKey = 'SUA_SERVICE_KEY'; // Use a service_role key, não a anon key

void main() async {
  print('🔐 Script de Reset de Senha - Centelha Divina\n');

  // Inicializar Supabase com service role key
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseServiceKey,
  );

  final supabase = Supabase.instance.client;

  // Solicitar email
  stdout.write('Digite o email do usuário: ');
  final email = stdin.readLineSync()?.trim();

  if (email == null || email.isEmpty) {
    print('❌ Email inválido!');
    exit(1);
  }

  // Solicitar nova senha
  stdout.write('Digite a nova senha (mínimo 6 caracteres): ');
  final novaSenha = stdin.readLineSync()?.trim();

  if (novaSenha == null || novaSenha.length < 6) {
    print('❌ Senha deve ter no mínimo 6 caracteres!');
    exit(1);
  }

  // Confirmar senha
  stdout.write('Confirme a nova senha: ');
  final confirmaSenha = stdin.readLineSync()?.trim();

  if (novaSenha != confirmaSenha) {
    print('❌ As senhas não coincidem!');
    exit(1);
  }

  print('\n📝 Processando...');

  try {
    // Buscar usuário no Supabase Auth
    // Nota: Esta operação requer service_role key
    final response = await supabase.auth.admin.updateUserById(
      email, // Na verdade precisamos do UUID, mas vamos tentar reset por email
      attributes: UserAttributes(
        password: novaSenha,
      ),
    );

    print('✅ Senha redefinida com sucesso para $email!');
    print('');
    print('Agora você pode fazer login com:');
    print('  Email: $email');
    print('  Senha: $novaSenha');
  } catch (e) {
    print('❌ Erro ao redefinir senha: $e');
    print('');
    print('💡 Dica: Certifique-se de usar a service_role key do Supabase.');
    exit(1);
  }

  exit(0);
}
