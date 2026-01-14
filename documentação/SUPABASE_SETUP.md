# Integração com Supabase

## Configuração Inicial

O projeto já está configurado para usar o Supabase como backend. Siga os passos abaixo para completar a configuração:

### 1. Obter a Publishable Key do Supabase

1. Acesse o dashboard do seu projeto Supabase: https://lnzhgnwwzvpplhaxqbvq.supabase.co
2. Navegue até **Settings** > **API Keys**
3. Na seção **"Publishable key"**, copie a chave do item **"default"**
   - A chave é um token JWT longo que começa com `eyJ...`
   - Esta é a chave pública, segura para usar no frontend
4. Cole a chave no arquivo `lib/core/constants/supabase_constants.dart`

```dart
static const String supabaseAnonKey = 'eyJhbGci...sua_chave_completa_aqui';
```

> ⚠️ **IMPORTANTE**: Não confunda com a "Secret key"! A Secret key só deve ser usada em servidores backend, NUNCA no código do cliente.

### 2. Estrutura de Arquivos Criados

- `lib/core/constants/supabase_constants.dart` - Constantes de configuração
- `lib/core/services/supabase_service.dart` - Serviço principal do Supabase
- Atualização no `lib/core/di/injection_container.dart` - Injeção de dependência
- Atualização no `lib/main.dart` - Inicialização do Supabase

### 3. Como Usar o Supabase Service

#### Obtendo o Cliente Supabase

```dart
import 'package:centelha_claudia/core/services/supabase_service.dart';

// Obter instância do serviço
final supabaseService = SupabaseService.instance;

// Acessar o cliente
final client = supabaseService.client;
```

#### Operações de Banco de Dados

**Consultar dados:**
```dart
final response = await supabaseService.client
    .from('membros')
    .select();
```

**Inserir dados:**
```dart
await supabaseService.client
    .from('membros')
    .insert({
      'nome': 'João Silva',
      'email': 'joao@example.com',
    });
```

**Atualizar dados:**
```dart
await supabaseService.client
    .from('membros')
    .update({'nome': 'João Pedro Silva'})
    .eq('id', 123);
```

**Deletar dados:**
```dart
await supabaseService.client
    .from('membros')
    .delete()
    .eq('id', 123);
```

#### Autenticação

**Fazer login:**
```dart
final response = await supabaseService.client.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password',
);
```

**Registrar novo usuário:**
```dart
final response = await supabaseService.client.auth.signUp(
  email: 'user@example.com',
  password: 'password',
);
```

**Fazer logout:**
```dart
await supabaseService.client.auth.signOut();
```

**Verificar usuário autenticado:**
```dart
final isAuthenticated = supabaseService.isAuthenticated;
final currentUser = supabaseService.currentUser;
```

**Monitorar mudanças de autenticação:**
```dart
supabaseService.authStateChanges.listen((AuthState state) {
  // Reagir a mudanças de autenticação
  final user = state.session?.user;
});
```

### 4. Criando Tabelas no Supabase

Acesse o SQL Editor no dashboard do Supabase e execute comandos para criar suas tabelas. Exemplo:

```sql
-- Tabela de membros
CREATE TABLE membros (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  telefone VARCHAR(20),
  data_nascimento DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar Row Level Security (RLS)
ALTER TABLE membros ENABLE ROW LEVEL SECURITY;

-- Criar políticas de acesso
CREATE POLICY "Membros são visíveis para usuários autenticados"
  ON membros FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Membros podem ser inseridos por usuários autenticados"
  ON membros FOR INSERT
  TO authenticated
  WITH CHECK (true);
```

### 5. Integrando nos Datasources

Exemplo de como adaptar um datasource para usar o Supabase:

```dart
import '../../../core/services/supabase_service.dart';

class MembroDatasourceSupabase implements MembroDatasource {
  final SupabaseService _supabaseService;

  MembroDatasourceSupabase(this._supabaseService);

  @override
  Future<List<Membro>> listarMembros() async {
    final response = await _supabaseService.client
        .from('membros')
        .select();
    
    return (response as List)
        .map((json) => Membro.fromJson(json))
        .toList();
  }

  @override
  Future<void> criarMembro(Membro membro) async {
    await _supabaseService.client
        .from('membros')
        .insert(membro.toJson());
  }

  @override
  Future<void> atualizarMembro(Membro membro) async {
    await _supabaseService.client
        .from('membros')
        .update(membro.toJson())
        .eq('id', membro.id);
  }

  @override
  Future<void> deletarMembro(String id) async {
    await _supabaseService.client
        .from('membros')
        .delete()
        .eq('id', id);
  }
}
```

### 6. Tratamento de Erros

```dart
try {
  final response = await supabaseService.client
      .from('membros')
      .select();
  // Processar resposta
} on PostgrestException catch (error) {
  // Erro do banco de dados
  print('Erro do banco: ${error.message}');
} on AuthException catch (error) {
  // Erro de autenticação
  print('Erro de autenticação: ${error.message}');
} catch (error) {
  // Outro erro
  print('Erro: $error');
}
```

## Próximos Passos

1. Obter e configurar a `supabaseAnonKey`
2. Criar as tabelas necessárias no Supabase
3. Configurar Row Level Security (RLS) para segurança
4. Adaptar os datasources existentes para usar o Supabase
5. Implementar a autenticação real usando Supabase Auth
6. Testar as operações de CRUD

## Recursos Úteis

- [Documentação do Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [Dashboard do Projeto](https://lnzhgnwwzvpplhaxqbvq.supabase.co)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
