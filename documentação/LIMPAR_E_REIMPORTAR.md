# Como Limpar e Reimportar Dados do Supabase

## ⚠️ ATENÇÃO: Operação Irreversível

Deletar dados é **permanente**. Faça backup antes se necessário.

## Passo 1: Deletar Todos os Registros

### Opção A: Via SQL Editor (Recomendado)

1. Acesse o **Supabase Dashboard**
2. Vá em **SQL Editor** (menu lateral esquerdo)
3. Clique em **New Query**
4. Cole o script abaixo:

```sql
-- ============================================
-- SCRIPT PARA LIMPAR TABELAS DE IMPORTAÇÃO
-- ============================================

-- 1. Deletar todos os registros de cadastros
DELETE FROM cadastros;

-- 2. Deletar todos os registros de membros histórico
DELETE FROM membros_historico;

-- 3. (Opcional) Resetar sequences/auto-increment
-- Isso garante que os IDs comecem do 1 novamente
-- Comente se não quiser resetar os IDs

-- Para PostgreSQL, se as tabelas usam SERIAL:
-- ALTER SEQUENCE cadastros_id_seq RESTART WITH 1;
-- ALTER SEQUENCE membros_historico_id_seq RESTART WITH 1;

-- 4. Verificar se as tabelas estão vazias
SELECT COUNT(*) as total_cadastros FROM cadastros;
SELECT COUNT(*) as total_membros FROM membros_historico;

-- Resultado esperado: ambos devem retornar 0
```

5. Clique em **Run** (ou pressione Ctrl+Enter)
6. Verifique se retornou `0` para ambas as contagens

### Opção B: Deletar Apenas Cadastros

```sql
-- Deletar apenas cadastros (pessoas)
DELETE FROM cadastros;

-- Verificar
SELECT COUNT(*) FROM cadastros;
```

### Opção C: Deletar Apenas Membros

```sql
-- Deletar apenas membros histórico
DELETE FROM membros_historico;

-- Verificar
SELECT COUNT(*) FROM membros_historico;
```

## Passo 2: Reimportar Dados

Depois de limpar as tabelas:

### 1. Importar Cadastros (Pessoas)

1. Abra o aplicativo Flutter
2. Navegue: **Menu → CADASTROS → Importar Sistema Antigo**
3. Clique em **INICIAR IMPORTAÇÃO**
4. Aguarde conclusão (2,254 registros)

### 2. Importar Membros (Histórico)

1. Navegue: **Menu → MEMBROS DA CENTELHA → Importar Histórico Antigo**
2. Clique em **INICIAR IMPORTAÇÃO**
3. Aguarde conclusão (446 registros)

## Verificação de Duplicatas

Se os registros duplicaram mesmo com a verificação, pode ser por:

### Problema 1: Importação executada múltiplas vezes simultaneamente

**Solução**: Aguardar a importação anterior completar antes de clicar novamente

### Problema 2: Verificação não está funcionando

**Diagnóstico**: Execute no SQL Editor:

```sql
-- Verificar cadastros duplicados
SELECT nome, COUNT(*) as quantidade
FROM cadastros
GROUP BY nome
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- Verificar membros duplicados
SELECT nome, cadastro, COUNT(*) as quantidade
FROM membros_historico
GROUP BY nome, cadastro
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;
```

### Problema 3: Nomes com case/acentos diferentes

**Exemplo**: "MARIA" vs "Maria" vs "María"

**Solução**: Adicionar índice case-insensitive:

```sql
-- Criar extensão para comparação sem acentos
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Índice case-insensitive para cadastros
CREATE INDEX idx_cadastros_nome_lower
ON cadastros (LOWER(unaccent(nome)));

-- Índice case-insensitive para membros
CREATE INDEX idx_membros_nome_cadastro_lower
ON membros_historico (LOWER(unaccent(nome)), LOWER(unaccent(cadastro)));
```

## Deletar Duplicatas Mantendo o Primeiro

Se você quiser manter os primeiros registros e deletar apenas os duplicados:

### Para Cadastros:

```sql
-- Deletar cadastros duplicados (mantém o mais antigo)
DELETE FROM cadastros
WHERE id NOT IN (
  SELECT MIN(id)
  FROM cadastros
  GROUP BY nome
);

-- Verificar quantos foram deletados
SELECT nome, COUNT(*) as quantidade
FROM cadastros
GROUP BY nome
HAVING COUNT(*) > 1;
```

### Para Membros:

```sql
-- Deletar membros duplicados (mantém o mais antigo)
DELETE FROM membros_historico
WHERE id NOT IN (
  SELECT MIN(id)
  FROM membros_historico
  GROUP BY nome, cadastro
);

-- Verificar quantos foram deletados
SELECT nome, cadastro, COUNT(*) as quantidade
FROM membros_historico
GROUP BY nome, cadastro
HAVING COUNT(*) > 1;
```

## Adicionar Constraints para Prevenir Duplicatas

Para garantir que nunca mais ocorram duplicatas, adicione constraints:

### Cadastros - Nome Único:

```sql
-- Criar constraint de unicidade no nome
ALTER TABLE cadastros
ADD CONSTRAINT unique_cadastro_nome
UNIQUE (nome);
```

### Membros - Nome + Cadastro Único:

```sql
-- Criar constraint de unicidade composta
ALTER TABLE membros_historico
ADD CONSTRAINT unique_membro_nome_cadastro
UNIQUE (nome, cadastro);
```

**⚠️ Importante**: Adicione constraints **SOMENTE DEPOIS** de limpar duplicatas existentes!

## Backup Antes de Deletar

Se quiser fazer backup antes:

### Via SQL:

```sql
-- Backup de cadastros
CREATE TABLE cadastros_backup AS
SELECT * FROM cadastros;

-- Backup de membros
CREATE TABLE membros_historico_backup AS
SELECT * FROM membros_historico;
```

### Restaurar do Backup:

```sql
-- Restaurar cadastros
INSERT INTO cadastros
SELECT * FROM cadastros_backup;

-- Restaurar membros
INSERT INTO membros_historico
SELECT * FROM membros_historico_backup;
```

## Resumo - Passos Rápidos

```sql
-- 1. DELETAR TUDO
DELETE FROM cadastros;
DELETE FROM membros_historico;

-- 2. VERIFICAR
SELECT COUNT(*) FROM cadastros; -- deve retornar 0
SELECT COUNT(*) FROM membros_historico; -- deve retornar 0

-- 3. REIMPORTAR via aplicativo Flutter
-- Menu → CADASTROS → Importar Sistema Antigo
-- Menu → MEMBROS → Importar Histórico Antigo

-- 4. (OPCIONAL) ADICIONAR CONSTRAINTS
ALTER TABLE cadastros
ADD CONSTRAINT unique_cadastro_nome UNIQUE (nome);

ALTER TABLE membros_historico
ADD CONSTRAINT unique_membro_nome_cadastro UNIQUE (nome, cadastro);
```

## Checklist

- [ ] Backup realizado (se necessário)
- [ ] SQL executado no Supabase SQL Editor
- [ ] Contagem retornou 0 para ambas tabelas
- [ ] Reimportação de cadastros concluída
- [ ] Reimportação de membros concluída
- [ ] Verificação de duplicatas executada
- [ ] (Opcional) Constraints adicionados

## Suporte

Se após limpar e reimportar ainda houver duplicatas:

1. Verifique se aguardou a importação concluir completamente
2. Não clique múltiplas vezes no botão de importar
3. Verifique logs de erro durante a importação
4. Execute query de verificação de duplicatas

## Scripts de Manutenção

### Ver estatísticas das tabelas:

```sql
-- Total de registros
SELECT
  'cadastros' as tabela,
  COUNT(*) as total
FROM cadastros
UNION ALL
SELECT
  'membros_historico' as tabela,
  COUNT(*) as total
FROM membros_historico;

-- Espaço ocupado
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE tablename IN ('cadastros', 'membros_historico')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```
