-- ============================================================================
-- ADICIONAR COLUNAS DE NOMES DOS GUIAS NA TABELA MEMBROS_HISTORICO
-- ============================================================================

-- Adicionar colunas dos nomes dos guias espirituais
ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_pr CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_bai CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_cab CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_mar CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_mal CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_cig CHARACTER VARYING(255) NULL;

ALTER TABLE public.membros_historico 
ADD COLUMN IF NOT EXISTS nome_pv CHARACTER VARYING(255) NULL;

-- Adicionar comentários nas colunas
COMMENT ON COLUMN public.membros_historico.nome_pr IS 'Nome do Preto-Velho (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_bai IS 'Nome do Baiano (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_cab IS 'Nome do Caboclo (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_mar IS 'Nome do Marinheiro (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_mal IS 'Nome do Malandro (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_cig IS 'Nome do Cigano (guia espiritual)';
COMMENT ON COLUMN public.membros_historico.nome_pv IS 'Nome da Pomba-Gira (guia espiritual)';

-- Criar índices (opcional, para melhorar busca por nomes de guias)
CREATE INDEX IF NOT EXISTS idx_membros_historico_nome_pr 
ON public.membros_historico USING btree (nome_pr) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS idx_membros_historico_nome_cab 
ON public.membros_historico USING btree (nome_cab) TABLESPACE pg_default;

-- ============================================================================
-- VERIFICAR ALTERAÇÕES
-- ============================================================================

-- Listar colunas de guias
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'membros_historico'
  AND column_name IN (
    'nome_pr',
    'nome_bai',
    'nome_cab',
    'nome_mar',
    'nome_mal',
    'nome_cig',
    'nome_pv'
  )
ORDER BY column_name;
