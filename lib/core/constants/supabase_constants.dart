class SupabaseConstants {
  // URL do projeto Supabase
  static const String supabaseUrl = 'https://lnzhgnwwzvpplhaxqbvq.supabase.co';
  
  // Publishable Key (antes chamada de "anon key")
  // Esta chave deve ser obtida do dashboard do Supabase
  // Navegue até: Settings > API Keys > Publishable key > default
  static const String supabaseAnonKey = 'sb_publishable_-yAx9slUlGE8rmX9j1w0TA_JzMrZ0Ll';
  
  // IMPORTANTE: 
  // 1. Cole aqui a chave que aparece em "Publishable key" > "default"
  // 2. A chave começa com "eyJ..." (é um JWT token)
  // 3. Esta chave é segura para uso no cliente (frontend)
  // 4. NUNCA use a "Secret key" no código do cliente!
  
  private SupabaseConstants();
}
