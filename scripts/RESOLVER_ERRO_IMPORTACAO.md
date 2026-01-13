# 🔧 Como Resolver o Erro de Importação

## ❌ Erro Encontrado

```
PostgrestException: Could not find the table 'public.cadastros'
in the schema cache
```

## ✅ Solução

A tabela `cadastros` não existe no banco de dados Supabase. Você precisa criá-la primeiro!

### Passo 1: Acessar Supabase Dashboard

1. Acesse: https://supabase.com/dashboard
2. Selecione seu projeto
3. Vá em **SQL Editor** (ícone `</>` no menu lateral)

### Passo 2: Executar o Script SQL

1. Clique em **New Query**
2. Copie TODO o conteúdo do arquivo `scripts/criar_tabela_cadastros.sql`
3. Cole no editor SQL
4. Clique em **Run** (ou pressione Cmd/Ctrl + Enter)

### Passo 3: Verificar Criação

Execute este comando para confirmar:

```sql
SELECT * FROM cadastros LIMIT 1;
```

Se retornar "0 rows" está perfeito! A tabela foi criada.

### Passo 4: Importar Novamente

Volte para o sistema e clique em **INICIAR IMPORTAÇÃO** novamente.

## 📋 O que o script faz?

- ✅ Cria tabela `cadastros` com campos JSONB flexíveis
- ✅ Cria índices para melhor performance
- ✅ Configura RLS (Row Level Security)
- ✅ Adiciona políticas de acesso para usuários autenticados
- ✅ Cria trigger para atualizar `updated_at` automaticamente

## 🔍 Estrutura da Tabela

```sql
cadastros
├── id (UUID) - PK
├── cadastro_id (INTEGER)
├── nome (VARCHAR)
├── nascimento (TIMESTAMP)
├── documentos (JSONB) - {cpf, rg}
├── contato (JSONB) - {telefone, celular, email}
├── endereco (JSONB) - {logradouro, bairro, cidade, uf, cep}
├── religioso (JSONB) - {nucleo, data_batismo, padrinho, madrinha}
├── data_cadastro (TIMESTAMP)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

## 💡 Dica Rápida

**Copie e cole este comando direto no SQL Editor:**

```sql
CREATE TABLE IF NOT EXISTS cadastros (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  nascimento TIMESTAMP,
  documentos JSONB DEFAULT '{}'::jsonb,
  contato JSONB DEFAULT '{}'::jsonb,
  endereco JSONB DEFAULT '{}'::jsonb,
  religioso JSONB DEFAULT '{}'::jsonb,
  data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE cadastros ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Permitir acesso para autenticados"
ON cadastros FOR ALL
TO authenticated
USING (true) WITH CHECK (true);
```

Depois clique em **Run** e pronto! Você pode importar os 2.254 registros! 🚀

## ⚠️ Observações

- Os dados do sistema antigo estão com campos trocados
- O sistema já faz o mapeamento automático
- Campos JSONB permitem flexibilidade nos dados
- RLS garante segurança dos dados

## 🆘 Ainda com problemas?

Se o erro persistir, verifique:

1. ✅ Você está no projeto correto do Supabase?
2. ✅ A extensão `uuid-ossp` está habilitada?
3. ✅ Seu usuário tem permissão de criar tabelas?
4. ✅ Executou o script completo sem erros?
