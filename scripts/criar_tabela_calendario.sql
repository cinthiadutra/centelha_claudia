-- ==========================================
-- SCRIPT DE CRIAÇÃO DA TABELA CALENDÁRIO 2026
-- ==========================================
-- Execute este script no SQL Editor do Supabase

-- PASSO 1: Criar a tabela calendario_2026
CREATE TABLE IF NOT EXISTS public.calendario_2026 (
    id BIGSERIAL PRIMARY KEY,
    data TEXT NOT NULL,                    -- Ex: "26-1-1" (formato no CSV)
    dia_semana TEXT,                       -- Ex: "QUINTA-FEIRA"
    nucleo TEXT,                           -- Ex: "CCU", "CPO" (pode ter múltiplos separados por quebra)
    inicio TEXT,                           -- Ex: "19h00", "15h00" (horários)
    atividade TEXT,                        -- Ex: "Sessão de Festa de Oxóssi"
    vibracoes TEXT,                        -- Ex: "Oxóssi / Ossâe / Caboclos (as) / Boiadeiros"
    responsavel TEXT,                      -- Ex: "Babá Luis", "Pai Sérgio"
    grupos_trabalho TEXT,                  -- Ex: "Grupo AMOR", "Grupo PAZ"
    vibracao_numero INTEGER,               -- Número de 1 a 5 (última coluna do CSV)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PASSO 2: Criar índices para melhorar performance de busca
CREATE INDEX IF NOT EXISTS idx_calendario_data ON public.calendario_2026(data);
CREATE INDEX IF NOT EXISTS idx_calendario_dia_semana ON public.calendario_2026(dia_semana);
CREATE INDEX IF NOT EXISTS idx_calendario_nucleo ON public.calendario_2026(nucleo);
CREATE INDEX IF NOT EXISTS idx_calendario_responsavel ON public.calendario_2026(responsavel);

-- PASSO 3: Habilitar RLS (Row Level Security)
ALTER TABLE public.calendario_2026 ENABLE ROW LEVEL SECURITY;

-- PASSO 4: Criar políticas de acesso
-- Política para leitura pública (qualquer usuário autenticado pode ler)
CREATE POLICY "Permitir leitura para todos os usuários autenticados"
ON public.calendario_2026
FOR SELECT
TO authenticated
USING (true);

-- Política para inserção (apenas usuários autenticados podem inserir)
CREATE POLICY "Permitir inserção para usuários autenticados"
ON public.calendario_2026
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Política para atualização (apenas usuários autenticados podem atualizar)
CREATE POLICY "Permitir atualização para usuários autenticados"
ON public.calendario_2026
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Política para deleção (apenas usuários autenticados podem deletar)
CREATE POLICY "Permitir deleção para usuários autenticados"
ON public.calendario_2026
FOR DELETE
TO authenticated
USING (true);

-- ==========================================
-- PRONTO! Agora você pode importar o CSV
-- ==========================================

-- INSTRUÇÕES PARA IMPORTAR O CSV NO SUPABASE:
-- 1. Vá para Table Editor no Supabase
-- 2. Selecione a tabela "calendario_2026"
-- 3. Clique em "Insert" > "Import data from CSV"
-- 4. Selecione o arquivo "GERAL-Tabela 1.csv"
-- 5. Mapeie as colunas:
--    - DATA → data
--    - DIA → dia_semana
--    - NÚCLEO → nucleo
--    - INÍCIO → inicio
--    - ATIVIDADE → atividade
--    - VIBRAÇÕES → vibracoes
--    - RESPONSÁVEL → responsavel
--    - GRUPOS DE TRABALHO → grupos_trabalho
--    - (última coluna numérica) → vibracao_numero
-- 6. Clique em "Import"

-- ==========================================
-- ALTERNATIVA: Importar via SQL usando tabela temporária
-- ==========================================

-- Se preferir importar via SQL, use este método:

-- A) Criar tabela temporária para receber os dados do CSV
CREATE TABLE temp_calendario (
    data TEXT,
    dia_semana TEXT,
    nucleo TEXT,
    inicio TEXT,
    atividade TEXT,
    vibracoes TEXT,
    responsavel TEXT,
    grupos_trabalho TEXT,
    col9 TEXT,
    col10 TEXT,
    col11 TEXT,
    col12 TEXT,
    vibracao_numero TEXT
);

-- B) Depois de copiar os dados do CSV para temp_calendario, execute:
/*
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
    t.data,
    t.dia_semana,
    t.nucleo,
    t.inicio,
    t.atividade,
    t.vibracoes,
    t.responsavel,
    t.grupos_trabalho,
    CASE 
        WHEN t.vibracao_numero ~ '^[0-9]+$' THEN t.vibracao_numero::INTEGER
        ELSE NULL
    END as vibracao_numero
FROM temp_calendario t
WHERE t.data IS NOT NULL AND t.data != 'DATA';  -- Pular o cabeçalho

-- Limpar tabela temporária
DROP TABLE temp_calendario;
*/
