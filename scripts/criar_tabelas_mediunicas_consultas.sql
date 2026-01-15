-- ============================================================================
-- TABELAS DE DADOS MEDIÚNICOS E NOTAS DE CONSULTAS
-- ============================================================================

-- ============================================================================
-- TABELA DADOS MEDIÚNICOS
-- ============================================================================
-- Armazena informações dos médiuns e nomes de seus guias espirituais
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.dados_mediunicos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membro_id TEXT NOT NULL,
    nome TEXT NOT NULL,
    funcao TEXT,
    grau TEXT,
    nome_pr TEXT, -- Preto-Velho
    nome_bai TEXT, -- Baiano
    nome_cab TEXT, -- Caboclo
    nome_mar TEXT, -- Marinheiro
    nome_mal TEXT, -- Malandro
    nome_cig TEXT, -- Cigano
    nome_pv TEXT, -- Pomba-Gira
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_dados_mediunicos_membro ON public.dados_mediunicos(membro_id);
CREATE INDEX IF NOT EXISTS idx_dados_mediunicos_nome ON public.dados_mediunicos(nome);
CREATE INDEX IF NOT EXISTS idx_dados_mediunicos_funcao ON public.dados_mediunicos(funcao);

-- Trigger para updated_at
CREATE TRIGGER atualizar_dados_mediunicos_updated_at
    BEFORE UPDATE ON public.dados_mediunicos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- Comentários
COMMENT ON TABLE public.dados_mediunicos IS 'Dados mediúnicos dos membros e nomes de seus guias espirituais';
COMMENT ON COLUMN public.dados_mediunicos.nome_pr IS 'Nome do Preto-Velho';
COMMENT ON COLUMN public.dados_mediunicos.nome_bai IS 'Nome do Baiano';
COMMENT ON COLUMN public.dados_mediunicos.nome_cab IS 'Nome do Caboclo';
COMMENT ON COLUMN public.dados_mediunicos.nome_mar IS 'Nome do Marinheiro';
COMMENT ON COLUMN public.dados_mediunicos.nome_mal IS 'Nome do Malandro';
COMMENT ON COLUMN public.dados_mediunicos.nome_cig IS 'Nome do Cigano';
COMMENT ON COLUMN public.dados_mediunicos.nome_pv IS 'Nome da Pomba-Gira';

-- ============================================================================
-- TABELA NOTAS DE CONSULTAS
-- ============================================================================
-- Armazena as notas dadas às consultas realizadas pelos médiuns
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.nota_consultas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membro_id TEXT NOT NULL,
    nome TEXT NOT NULL,
    nome_guia TEXT NOT NULL,
    nota DECIMAL(3,1) NOT NULL CHECK (nota >= 0 AND nota <= 10),
    data DATE NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_nota_consultas_membro ON public.nota_consultas(membro_id);
CREATE INDEX IF NOT EXISTS idx_nota_consultas_nome ON public.nota_consultas(nome);
CREATE INDEX IF NOT EXISTS idx_nota_consultas_data ON public.nota_consultas(data);
CREATE INDEX IF NOT EXISTS idx_nota_consultas_guia ON public.nota_consultas(nome_guia);

-- Trigger para updated_at
CREATE TRIGGER atualizar_nota_consultas_updated_at
    BEFORE UPDATE ON public.nota_consultas
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- Comentários
COMMENT ON TABLE public.nota_consultas IS 'Notas das consultas realizadas pelos médiuns';
COMMENT ON COLUMN public.nota_consultas.nota IS 'Nota da consulta (0 a 5)';

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Tabela dados_mediunicos
ALTER TABLE public.dados_mediunicos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de dados mediúnicos"
    ON public.dados_mediunicos FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de dados mediúnicos"
    ON public.dados_mediunicos FOR ALL
    USING (auth.role() = 'authenticated');

-- Tabela nota_consultas
ALTER TABLE public.nota_consultas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de notas de consultas"
    ON public.nota_consultas FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de notas de consultas"
    ON public.nota_consultas FOR ALL
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VIEWS ÚTEIS
-- ============================================================================

-- View: Dados mediúnicos completos
CREATE OR REPLACE VIEW v_dados_mediunicos_completos AS
SELECT 
    dm.*,
    mh.nucleo,
    mh.status,
    mh.dia_sessao,
    mh.classificacao
FROM dados_mediunicos dm
LEFT JOIN membros_historico mh ON dm.membro_id = mh.cadastro;

-- View: Estatísticas de consultas por membro
CREATE OR REPLACE VIEW v_estatisticas_consultas AS
SELECT 
    membro_id,
    nome,
    COUNT(*) as total_consultas,
    AVG(nota) as media_notas,
    MIN(nota) as nota_minima,
    MAX(nota) as nota_maxima,
    MIN(data) as primeira_consulta,
    MAX(data) as ultima_consulta
FROM nota_consultas
GROUP BY membro_id, nome;

-- View: Notas de consultas por guia
CREATE OR REPLACE VIEW v_consultas_por_guia AS
SELECT 
    nome_guia,
    COUNT(*) as total_consultas,
    AVG(nota) as media_notas,
    COUNT(DISTINCT membro_id) as total_membros
FROM nota_consultas
GROUP BY nome_guia
ORDER BY total_consultas DESC;

-- ============================================================================
-- VERIFICAÇÃO
-- ============================================================================

-- Listar tabelas criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'public' 
  AND table_name IN ('dados_mediunicos', 'nota_consultas')
ORDER BY table_name;

-- Listar colunas de dados_mediunicos
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'dados_mediunicos'
ORDER BY ordinal_position;

-- Listar colunas de nota_consultas
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'nota_consultas'
ORDER BY ordinal_position;
