-- ================================================
-- SCRIPT PARA IMPORTAR CONSULTAS
-- ================================================
-- Execute este script no SQL Editor do Supabase

-- ================================================
-- PASSO 1: CRIAR TABELA TEMPORÁRIA
-- ================================================
CREATE TABLE IF NOT EXISTS consultas_temp (
  "NUM_CONSULTA" TEXT,
  "DATA" TEXT,
  "HORA" TEXT,
  "CADASTRO_CONSULENTE" TEXT,
  "NOME_CONSULENTE" TEXT,
  "CADASTRO_CAMBONO" TEXT,
  "NOME_CAMBONO" TEXT,
  "CADASTRO_MEDIUM" TEXT,
  "NOME_MEDIUM" TEXT,
  "GUIA" TEXT,
  "DESC_CONSULTA" TEXT
);

-- ================================================
-- PASSO 2: IMPORTAR CSV
-- ================================================
-- Use o Supabase Dashboard para importar o CSV CONSULTAS.csv
-- 1. Vá em Table Editor
-- 2. Selecione a tabela: consultas_temp
-- 3. Clique em "Insert" → "Import data from CSV"
-- 4. Selecione o arquivo CONSULTAS.csv
-- 5. Configure o separador como ";" (ponto e vírgula)
-- 6. Clique em "Import"

-- ================================================
-- PASSO 3: PROCESSAR E INSERIR NA TABELA CONSULTAS
-- ================================================

INSERT INTO consultas (
  numero_consulta,
  cadastro_consulente,
  nome_consulente,
  data_consulta,
  descricao,
  atendente,
  tipo_consulta
)
SELECT 
  t."NUM_CONSULTA" as numero_consulta,
  CASE 
    WHEN t."CADASTRO_CONSULENTE" IS NOT NULL 
      AND t."CADASTRO_CONSULENTE" != '' 
      AND t."CADASTRO_CONSULENTE" != 'S/N'
      AND EXISTS (SELECT 1 FROM usuarios WHERE numero_cadastro = t."CADASTRO_CONSULENTE")
    THEN t."CADASTRO_CONSULENTE"
    ELSE NULL
  END as cadastro_consulente,
  t."NOME_CONSULENTE",
  -- Converter data e hora (formato MM/DD/YY e HH:MM)
  CASE 
    WHEN t."DATA" ~ '^\d{1,2}/\d{1,2}/\d{2}$' 
      AND t."DATA" NOT LIKE '%/12/1899%'
      AND t."HORA" ~ '^\d{1,2}:\d{2}$' THEN
      TO_TIMESTAMP(t."DATA" || ' ' || t."HORA", 'MM/DD/YY HH24:MI')
    WHEN t."DATA" ~ '^\d{1,2}/\d{1,2}/\d{4}$' 
      AND t."DATA" NOT LIKE '%/12/1899'
      AND t."HORA" ~ '^\d{1,2}:\d{2}$' THEN
      TO_TIMESTAMP(t."DATA" || ' ' || t."HORA", 'MM/DD/YYYY HH24:MI')
    WHEN t."DATA" ~ '^\d{1,2}/\d{1,2}/\d{4}$' 
      AND t."DATA" NOT LIKE '%/12/1899' THEN
      TO_TIMESTAMP(t."DATA", 'MM/DD/YYYY')
    WHEN t."DATA" ~ '^\d{1,2}/\d{1,2}/\d{2}$' 
      AND t."DATA" NOT LIKE '%/12/1899%' THEN
      TO_TIMESTAMP(t."DATA", 'MM/DD/YY')
    ELSE
      NOW()
  END as data_consulta,
  t."DESC_CONSULTA" as descricao,
  COALESCE(t."NOME_MEDIUM", '') || 
    CASE 
      WHEN t."GUIA" IS NOT NULL AND t."GUIA" != '' 
      THEN ' - ' || t."GUIA" 
      ELSE '' 
    END as atendente,
  'Consulta Espiritual' as tipo_consulta
FROM consultas_temp t
WHERE t."NUM_CONSULTA" IS NOT NULL AND t."NUM_CONSULTA" != ''
ON CONFLICT (numero_consulta) DO NOTHING;

-- ================================================
-- PASSO 4: VERIFICAR IMPORTAÇÃO
-- ================================================

-- Ver total de consultas importadas
SELECT COUNT(*) as total_consultas FROM consultas;

-- Ver consultas por ano
SELECT 
  EXTRACT(YEAR FROM data_consulta) as ano,
  COUNT(*) as total
FROM consultas
GROUP BY EXTRACT(YEAR FROM data_consulta)
ORDER BY ano DESC;

-- Ver cadastros de consulentes sem correspondência
SELECT DISTINCT 
  t."CADASTRO_CONSULENTE",
  t."NOME_CONSULENTE"
FROM consultas_temp t
WHERE t."CADASTRO_CONSULENTE" IS NOT NULL 
  AND t."CADASTRO_CONSULENTE" != '' 
  AND t."CADASTRO_CONSULENTE" != 'S/N'
  AND NOT EXISTS (
    SELECT 1 FROM usuarios u 
    WHERE u.numero_cadastro = t."CADASTRO_CONSULENTE"
  )
ORDER BY t."CADASTRO_CONSULENTE";

-- Ver últimas consultas importadas
SELECT 
  numero_consulta,
  nome_consulente,
  data_consulta,
  atendente
FROM consultas
ORDER BY data_consulta DESC
LIMIT 10;

-- ================================================
-- PASSO 5: LIMPAR TABELA TEMPORÁRIA (OPCIONAL)
-- ================================================
-- DROP TABLE IF EXISTS consultas_temp;
