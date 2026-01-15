-- ============================================================================
-- ADICIONAR COLUNAS DE GRUPOS NA TABELA MEMBROS_HISTORICO
-- ============================================================================
-- Adiciona colunas para grupo-tarefa, ação social e cargo de liderança
-- ============================================================================

-- Adicionar coluna grupo_tarefa
ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS grupo_tarefa CHARACTER VARYING(255) NULL;

-- Adicionar coluna acao_social
ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS acao_social CHARACTER VARYING(255) NULL;

-- Adicionar coluna cargo_lideranca
ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS cargo_lideranca CHARACTER VARYING(255) NULL;

-- Adicionar comentários nas colunas
COMMENT ON COLUMN public.membros_historico.grupo_tarefa IS 'Grupo-Tarefa ao qual o membro pertence (usado para Nota C)';
COMMENT ON COLUMN public.membros_historico.acao_social IS 'Grupo de Ação Social ao qual o membro pertence (usado para Nota D)';
COMMENT ON COLUMN public.membros_historico.cargo_lideranca IS 'Cargo de liderança que o membro ocupa (usado para Nota L)';

-- Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_membros_historico_grupo_tarefa 
ON public.membros_historico USING btree (grupo_tarefa) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS idx_membros_historico_acao_social 
ON public.membros_historico USING btree (acao_social) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS idx_membros_historico_cargo_lideranca 
ON public.membros_historico USING btree (cargo_lideranca) TABLESPACE pg_default;

-- ============================================================================
-- VERIFICAR ALTERAÇÕES
-- ============================================================================

-- Listar todas as colunas de grupos
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'membros_historico'
  AND column_name IN (
    'atividade_espiritual',
    'grupo_trabalho_espiritual', 
    'grupo_tarefa',
    'acao_social',
    'cargo_lideranca'
  )
ORDER BY column_name;
