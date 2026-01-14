## 📋 Guia de Execução - Criar Tabelas no Supabase

Siga este guia passo a passo para criar todas as tabelas e configurações no Supabase.

### 📍 Passo 1: Acessar o SQL Editor

1. Acesse seu projeto Supabase: https://lnzhgnwwzvpplhaxqbvq.supabase.co
2. No menu lateral, clique em **SQL Editor** (ícone </> )
3. Clique no botão **"+ New query"**

### 📍 Passo 2: Executar o Schema Principal

1. Abra o arquivo `supabase_schema.sql` neste projeto
2. **Copie TODO o conteúdo** do arquivo (são ~700 linhas)
3. Cole no SQL Editor do Supabase
4. Clique no botão **"Run"** (ou pressione Ctrl/Cmd + Enter)

**Aguarde a execução** - pode levar de 10 a 30 segundos.

✅ **Resultado esperado**: Mensagem "Success. No rows returned" e todas as tabelas criadas.

### 📍 Passo 3: Executar as Políticas de Segurança (RLS)

1. Crie uma **nova query** no SQL Editor
2. Abra o arquivo `supabase_rls_policies.sql`
3. **Copie TODO o conteúdo** do arquivo
4. Cole no SQL Editor
5. Clique em **"Run"**

✅ **Resultado esperado**: Todas as políticas RLS configuradas com sucesso.

### 📍 Passo 4: Verificar as Tabelas Criadas

1. No menu lateral, clique em **Table Editor**
2. Você deverá ver todas estas tabelas:
   - ✅ usuarios
   - ✅ membros
   - ✅ consultas
   - ✅ grupos_tarefas
   - ✅ grupos_acoes_sociais
   - ✅ grupos_trabalhos_espirituais
   - ✅ batismos
   - ✅ casamentos
   - ✅ jogos_orixa
   - ✅ camarinhas
   - ✅ coroacao_sacerdotal
   - ✅ cursos
   - ✅ inscricoes_cursos
   - ✅ usuarios_sistema
   - ✅ organizacao

### 📍 Passo 5: Configurar Autenticação (Opcional mas Recomendado)

#### 5.1 Habilitar Autenticação por Email

1. Vá em **Authentication** > **Providers**
2. Certifique-se que **Email** está habilitado
3. Configure:
   - ✅ Enable Email provider
   - ✅ Confirm email (recomendado para produção)

#### 5.2 Configurar Templates de Email (Opcional)

1. Vá em **Authentication** > **Email Templates**
2. Personalize os templates de:
   - Confirmação de conta
   - Recuperação de senha
   - Magic Link

### 📍 Passo 6: Criar Primeiro Usuário Administrador

Execute este SQL para criar o primeiro admin:

```sql
-- 1. Primeiro, crie um usuário no cadastro base
INSERT INTO usuarios (
  numero_cadastro,
  nome,
  cpf,
  email,
  status_atual,
  classificacao
) VALUES (
  '00001',
  'Administrador Sistema',
  '00000000000',
  'admin@centelha.org',
  'Ativo',
  'Sacerdote'
);

-- 2. Crie o usuário do sistema com nível 4 (admin)
-- IMPORTANTE: Troque 'senha_segura_aqui' por uma senha real
INSERT INTO usuarios_sistema (
  numero_cadastro,
  nome,
  email,
  senha_hash,
  nivel_permissao,
  ativo
) VALUES (
  '00001',
  'Administrador Sistema',
  'admin@centelha.org',
  crypt('senha_segura_aqui', gen_salt('bf')),
  4,
  true
);
```

**IMPORTANTE**: Para usar o hash de senha, instale a extensão pgcrypto:

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

### 📍 Passo 7: Testar a Conexão no App

Agora você pode testar a conexão no seu app Flutter:

```dart
// No terminal do projeto
flutter run
```

O app já está configurado para conectar ao Supabase!

---

## 🔧 Comandos Úteis do SQL

### Ver todas as tabelas criadas

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

### Ver estrutura de uma tabela

```sql
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'usuarios'
ORDER BY ordinal_position;
```

### Verificar políticas RLS

```sql
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'public';
```

### Contar registros em todas as tabelas

```sql
SELECT
  schemaname,
  relname as table_name,
  n_live_tup as row_count
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_live_tup DESC;
```

---

## 🚨 Solução de Problemas

### Erro: "relation already exists"

**Solução**: A tabela já foi criada. Você pode:

1. Dropar a tabela: `DROP TABLE nome_tabela CASCADE;`
2. Ou pular este erro e continuar

### Erro: "permission denied"

**Solução**: Certifique-se de estar logado como proprietário do projeto

### Erro: "function does not exist"

**Solução**: Execute antes:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

### Política RLS não funciona

**Solução**: Verifique se o RLS está habilitado:

```sql
ALTER TABLE nome_tabela ENABLE ROW LEVEL SECURITY;
```

---

## 📊 Estrutura de Permissões

| Nível | Descrição        | Permissões                                            |
| ----- | ---------------- | ----------------------------------------------------- |
| **1** | Membro Regular   | Ver próprios dados, cursos públicos, fazer inscrições |
| **2** | Secretaria       | CRUD usuários, consultas, grupos                      |
| **3** | Líder Espiritual | Nível 2 + sacramentos, criar cursos                   |
| **4** | Administrador    | Acesso total, gerenciar sistema                       |

---

## 🎯 Próximos Passos

Após criar as tabelas:

1. ✅ Criar primeiro usuário admin (Passo 6)
2. ✅ Testar login no app
3. ✅ Inserir dados de teste
4. ✅ Criar datasources Flutter para conectar às tabelas
5. ✅ Implementar as telas de CRUD

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs no Supabase Dashboard
2. Teste as queries individualmente
3. Consulte a documentação: https://supabase.com/docs

---

**Data de criação**: 19 de dezembro de 2025  
**Versão do Schema**: 1.0  
**Compatível com**: Supabase PostgreSQL 15+
