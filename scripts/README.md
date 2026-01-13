# 🔐 Scripts de Reset de Senha

Este diretório contém scripts para resetar senhas de usuários no Supabase.

## 📁 Arquivos Disponíveis

### 1. `reset_password.sql` ⭐ MAIS SIMPLES

Script SQL direto para executar no Supabase Dashboard.

**Como usar:**

1. Acesse [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecione seu projeto
3. Vá em **SQL Editor**
4. Abra o arquivo `reset_password.sql`
5. Substitua `NOVA_SENHA_AQUI` pela senha desejada
6. Clique em **Run**

```sql
UPDATE auth.users
SET encrypted_password = crypt('SUA_NOVA_SENHA', gen_salt('bf'))
WHERE email = 'cinthiadutra@gmail.com';
```

### 2. `reset_password.js`

Script Node.js interativo.

**Como usar:**

```bash
# Modo interativo
node scripts/reset_password.js

# Modo direto
node scripts/reset_password.js cinthiadutra@gmail.com nova_senha_123
```

### 3. `reset_password.dart`

Script Dart (requer configuração da service_role key).

**Como usar:**

```bash
dart run scripts/reset_password.dart
```

## 🚀 Opção Mais Rápida

### Reset Rápido via SQL (RECOMENDADO)

Copie e execute no **SQL Editor do Supabase**:

```sql
-- Para cinthiadutra@gmail.com com senha "admin123"
UPDATE auth.users
SET
  encrypted_password = crypt('admin123', gen_salt('bf')),
  updated_at = NOW()
WHERE email = 'cinthiadutra@gmail.com';
```

## 🔑 Senhas Sugeridas para Desenvolvimento

- **Administrador**: `admin123`
- **Desenvolvimento**: `dev123456`
- **Teste**: `teste123`

## ⚠️ Importante

1. Estas senhas são apenas para **ambiente de desenvolvimento**
2. Use senhas fortes em **produção**
3. A função `crypt()` já criptografa a senha automaticamente
4. Nunca commite senhas reais no Git

## 📊 Verificar Usuários

Para ver todos os usuários cadastrados:

```sql
SELECT
  id,
  email,
  created_at,
  last_sign_in_at,
  raw_user_meta_data->>'nome' as nome
FROM auth.users
ORDER BY created_at DESC;
```

## 🆘 Troubleshooting

### "Function crypt does not exist"

Execute antes:

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

### "Permission denied"

Certifique-se de estar usando a **service_role key** ou execute via Dashboard.

## 📞 Contato

Se precisar de ajuda, verifique a documentação do Supabase:

- [Auth API](https://supabase.com/docs/guides/auth)
- [SQL Editor](https://supabase.com/docs/guides/database/sql-editor)
