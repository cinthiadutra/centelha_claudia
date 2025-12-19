# Próximos Passos - Integração Supabase

## ✅ Concluído

1. **Dependências instaladas**
   - `supabase_flutter: ^2.8.0` adicionado ao `pubspec.yaml`
   - Todas as dependências atualizadas

2. **Serviços configurados**
   - `SupabaseService` criado em `lib/core/services/supabase_service.dart`
   - `SupabaseConstants` configurado com URL e chave pública
   - Inicialização no `main.dart`

3. **Datasources implementados**
   - `AuthSupabaseDatasource` - Autenticação com Supabase Auth
   - `UsuarioSupabaseDatasource` - CRUD de usuários
   - Todos os datasources registrados no `injection_container.dart`

4. **Arquivos SQL criados**
   - `supabase_schema.sql` - Schema completo com 15 tabelas
   - `supabase_rls_policies.sql` - Políticas de segurança RLS
   - `supabase_rls_simple.sql` - Versão simplificada para desenvolvimento

5. **Exceptions customizadas**
   - `ServerException`, `CacheException`, `ValidationException`, `AuthException`
   - Arquivo criado em `lib/core/error/exceptions.dart`

## 🎯 Próximos Passos

### 1. Criar Tabelas no Supabase (URGENTE)

Acesse o dashboard do Supabase e execute os scripts SQL:

1. Acesse: https://lnzhgnwwzvpplhaxqbvq.supabase.co
2. Vá em **SQL Editor** (menu lateral)
3. Execute o arquivo `supabase_schema.sql` completo
4. Execute o arquivo `supabase_rls_policies.sql` para segurança

**Importante**: Execute na ordem para evitar erros de dependências.

### 2. Configurar Autenticação no Supabase

1. No dashboard, vá em **Authentication** > **Providers**
2. Habilite **Email**
3. Desabilite **Confirm Email** (opcional para desenvolvimento)
4. Em **URL Configuration**, configure as URLs de redirecionamento

### 3. Criar Usuário Admin Inicial

Execute este SQL no **SQL Editor** após criar as tabelas:

```sql
-- Criar usuário de autenticação
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  confirmation_sent_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'admin@centelha.org',
  crypt('admin123', gen_salt('bf')),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  now(),
  now()
)
RETURNING id;

-- Copie o ID retornado e use aqui:
INSERT INTO public.usuarios_sistema (
  id,
  nome,
  login,
  email,
  numero_cadastro,
  nivel_permissao,
  ativo
) VALUES (
  '<COLE_O_ID_AQUI>',
  'Administrador',
  'admin',
  'admin@centelha.org',
  '000001',
  4,
  true
);
```

### 4. Testar Conexão

Execute o app e teste o login:

```bash
flutter run
```

**Credenciais**:
- Email: `admin@centelha.org`
- Senha: `admin123`

### 5. Verificar Logs

Se houver erro, verifique:
1. Console do app Flutter
2. Logs do Supabase (Dashboard > Logs)
3. Network tab do DevTools

## 📝 Informações Importantes

### URLs e Chaves

- **Supabase URL**: https://lnzhgnwwzvpplhaxqbvq.supabase.co
- **Chave Pública**: Configurada em `lib/core/constants/supabase_constants.dart`
- **Chave Service Role**: NÃO usar no app (apenas para admin)

### Níveis de Permissão

O sistema usa 4 níveis de acesso:

1. **Nível 1** - Membros ativos (apenas leitura)
2. **Nível 2** - Membros da secretaria (leitura + cadastro)
3. **Nível 3** - Pais e Mães de terreiro (+ edição)
4. **Nível 4** - Administrador (acesso total)

### Segurança RLS

Todas as tabelas têm Row Level Security (RLS) ativado:
- Usuários só veem dados conforme seu nível de permissão
- As políticas usam `auth.uid()` e `public.get_user_nivel_permissao()`

## ⚠️ Avisos

1. **Nunca commite** a chave `service_role` no código
2. **Sempre use** a chave `anon/public` no app
3. **Teste RLS** antes de colocar em produção
4. **Faça backup** antes de modificar o schema

## 🔧 Troubleshooting

### Erro: "Invalid API key"
- Verifique a chave em `supabase_constants.dart`
- Confirme que está usando a chave `anon` correta

### Erro: "Permission denied"
- Execute `supabase_rls_policies.sql`
- Verifique se o usuário tem `nivel_permissao` na tabela `usuarios_sistema`

### Erro: "Table doesn't exist"
- Execute `supabase_schema.sql` no SQL Editor
- Verifique se todas as tabelas foram criadas

### App não conecta
- Verifique internet
- Teste o Supabase URL no navegador
- Veja os logs do Supabase Dashboard

## 📚 Documentação de Referência

- [Guia de Uso dos Datasources](GUIA_USO_DATASOURCES.md)
- [Como Criar Tabelas no Supabase](GUIA_CRIAR_TABELAS_SUPABASE.md)
- [Como Copiar Chave do Supabase](COMO_COPIAR_CHAVE_SUPABASE.md)
- [Resumo da Integração](RESUMO_INTEGRACAO_SUPABASE.md)

## 🎉 Após Tudo Funcionar

1. Crie mais usuários de teste
2. Teste cada nível de permissão
3. Cadastre alguns membros
4. Teste as consultas e relatórios
5. Configure backup automático no Supabase

---

**Última atualização**: 19/12/2025
**Status**: Pronto para executar os scripts SQL e testar
