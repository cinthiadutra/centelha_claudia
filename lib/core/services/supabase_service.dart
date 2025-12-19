import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

/// Serviço para gerenciar a conexão com o Supabase
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  /// Cliente Supabase
  SupabaseClient get client => Supabase.instance.client;

  /// Inicializa o Supabase
  /// Deve ser chamado no início da aplicação (main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
    );
  }

  /// Verifica se há um usuário autenticado
  bool get isAuthenticated => client.auth.currentUser != null;

  /// Retorna o usuário atual
  User? get currentUser => client.auth.currentUser;

  /// Stream de mudanças de autenticação
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
