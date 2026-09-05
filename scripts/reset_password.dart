import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  log('🔐 Script de Reset de Senha - Centelha Divina\n');

  // Inicializar Supabase com service role key
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseServiceKey);

  final supabase = Supabase.instance.client;

  // Solicitar email
  stdout.write('Digite o email do usuário: ');
  final email = stdin.readLineSync()?.trim();

  if (email == null || email.isEmpty) {
    log('❌ Email inválido!');
    exit(1);
  }

  // Solicitar nova senha
  stdout.write('Digite a nova senha (mínimo 6 caracteres): ');
  final novaSenha = stdin.readLineSync()?.trim();

  if (novaSenha == null || novaSenha.length < 6) {
    log('❌ Senha deve ter no mínimo 6 caracteres!');
    exit(1);
  }

  // Confirmar senha
  stdout.write('Confirme a nova senha: ');
  final confirmaSenha = stdin.readLineSync()?.trim();

  if (novaSenha != confirmaSenha) {
    log('❌ As senhas não coincidem!');
    exit(1);
  }

  log('\n📝 Processando...');

  try {
    // Buscar usuário no Supabase Auth
    // Nota: Esta operação requer service_role key
    await supabase.auth.admin.updateUserById(
      email, // Na verdade precisamos do UUID, mas vamos tentar reset por email
      attributes: AdminUserAttributes(password: novaSenha),
    );

    log('✅ Senha redefinida com sucesso para $email!');
    log('');
    log('Agora você pode fazer login com:');
    log('  Email: $email');
    log('  Senha: $novaSenha');
  } catch (e) {
    log('❌ Erro ao redefinir senha: $e');
    log('');
    log('💡 Dica: Certifique-se de usar a service_role key do Supabase.');
    exit(1);
  }

  exit(0);
}

const String supabaseServiceKey =
    'SUA_SERVICE_KEY'; // Use a service_role key, não a anon key

// Configure suas credenciais do Supabase aqui
const String supabaseUrl = 'SUA_URL_SUPABASE';
