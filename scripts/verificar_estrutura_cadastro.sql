-- ================================================
-- VERIFICAR ESTRUTURA DA TABELA CADASTRO
-- ================================================
-- Execute este script no SQL Editor do Supabase para ver a estrutura real da tabela
-- ================================================

-- 1. LISTAR TODAS AS COLUNAS DA TABELA CADASTRO
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'cadastro'
ORDER BY ordinal_position;

-- 2. VER OS PRIMEIROS 5 REGISTROS (se houver)
SELECT * FROM cadastro LIMIT 5;

-- 3. CONTAR TOTAL DE REGISTROS
SELECT COUNT(*) as total FROM cadastro;

-- 4. VERIFICAR SE EXISTEM OUTRAS TABELAS SIMILARES
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE '%cadastro%'
ORDER BY table_name;

-- 5. VERIFICAR SE EXISTE TABELA COM NOME DIFERENTE
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
