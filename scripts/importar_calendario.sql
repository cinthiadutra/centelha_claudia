-- ==========================================
-- IMPORTAÇÃO DO CALENDÁRIO 2026 VIA SQL
-- ==========================================
-- Este script importa o CSV diretamente no Supabase

-- PASSO 1: Criar a tabela calendario_2026 (execute apenas uma vez)
CREATE TABLE IF NOT EXISTS public.calendario_2026 (
    id BIGSERIAL PRIMARY KEY,
    data TEXT NOT NULL,
    dia_semana TEXT,
    nucleo TEXT,
    inicio TEXT,
    atividade TEXT,
    vibracoes TEXT,
    responsavel TEXT,
    grupos_trabalho TEXT,
    vibracao_numero INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PASSO 2: Criar tabela temporária para receber os dados do CSV
CREATE TABLE temp_calendario (
    "DATA" TEXT,
    "DIA" TEXT,
    "NUCLEO" TEXT,
    "INÍCIO" TEXT,
    "ATIVIDADE" TEXT,
    "VIBRACOES" TEXT,
    "RESPONSAVEL" TEXT,
    "GRUPOS_TRABALHO" TEXT,
    col_vazia TEXT,
    vibracao TEXT
);

-- PASSO 3: Copiar dados do CSV para tabela temporária
-- IMPORTANTE: No Supabase SQL Editor, use a interface para importar o CSV
-- 1. Selecione a tabela "temp_calendario"
-- 2. Use "Import CSV" e configure:
--    - Delimiter: ; (ponto e vírgula)
--    - Header: Yes (primeira linha é cabeçalho)
--    - Encoding: UTF-8

-- Depois de importar o CSV na temp_calendario, execute o PASSO 4:

-- PASSO 4: Inserir dados limpos na tabela final
INSERT INTO public.calendario_2026 (
    data,
    dia_semana,
    nucleo,
    inicio,
    atividade,
    vibracoes,
    responsavel,
    grupos_trabalho,
    vibracao_numero
)
SELECT 
    NULLIF(TRIM("DATA"), '') as data,
    NULLIF(TRIM("DIA"), '') as dia_semana,
    NULLIF(TRIM("NUCLEO"), '') as nucleo,
    NULLIF(TRIM("INÍCIO"), '') as inicio,
    NULLIF(TRIM("ATIVIDADE"), '') as atividade,
    NULLIF(TRIM("VIBRACOES"), '') as vibracoes,
    NULLIF(TRIM("RESPONSAVEL"), '') as responsavel,
    NULLIF(TRIM("GRUPOS_TRABALHO"), '') as grupos_trabalho,
    CASE 
        WHEN TRIM(vibracao) ~ '^[0-9]+$' THEN TRIM(vibracao)::INTEGER
        ELSE NULL
    END as vibracao_numero
FROM temp_calendario
WHERE "DATA" IS NOT NULL 
  AND "DATA" != ''
  AND "DATA" != 'DATA';  -- Pular linha de cabeçalho

-- PASSO 5: Criar índices
CREATE INDEX IF NOT EXISTS idx_calendario_data ON public.calendario_2026(data);
CREATE INDEX IF NOT EXISTS idx_calendario_dia_semana ON public.calendario_2026(dia_semana);
CREATE INDEX IF NOT EXISTS idx_calendario_nucleo ON public.calendario_2026(nucleo);
CREATE INDEX IF NOT EXISTS idx_calendario_responsavel ON public.calendario_2026(responsavel);

-- PASSO 6: Habilitar RLS e criar políticas
ALTER TABLE public.calendario_2026 ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Permitir leitura para todos os usuários autenticados"
ON public.calendario_2026 FOR SELECT TO authenticated USING (true);

CREATE POLICY "Permitir inserção para usuários autenticados"
ON public.calendario_2026 FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Permitir atualização para usuários autenticados"
ON public.calendario_2026 FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Permitir deleção para usuários autenticados"
ON public.calendario_2026 FOR DELETE TO authenticated USING (true);

-- PASSO 7: Limpar tabela temporária
DROP TABLE IF EXISTS temp_calendario;

-- PASSO 8: Verificar importação
SELECT COUNT(*) as total_registros FROM public.calendario_2026;
SELECT * FROM public.calendario_2026 ORDER BY id LIMIT 10;
