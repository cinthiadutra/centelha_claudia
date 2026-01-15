-- ============================================================================
-- TABELAS DE NÚCLEOS, DIAS DE SESSÃO E CLASSIFICAÇÕES MEDIÚNICAS
-- ============================================================================

-- ============================================================================
-- TABELA 1: NÚCLEOS
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.nucleos (
    cod VARCHAR(3) PRIMARY KEY,
    sigla VARCHAR(10) NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    coordenador VARCHAR(255),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_nucleos_sigla ON public.nucleos(sigla);
CREATE INDEX IF NOT EXISTS idx_nucleos_ativo ON public.nucleos(ativo);

-- Trigger para updated_at
CREATE TRIGGER atualizar_nucleos_updated_at
    BEFORE UPDATE ON public.nucleos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- Comentários
COMMENT ON TABLE public.nucleos IS 'Cadastro dos núcleos da organização';
COMMENT ON COLUMN public.nucleos.cod IS 'Código do núcleo (001, 002, etc)';
COMMENT ON COLUMN public.nucleos.sigla IS 'Sigla do núcleo (CCU, CPO)';

-- Inserir dados dos núcleos
INSERT INTO public.nucleos (cod, sigla, nome, coordenador, ativo) VALUES
('001', 'CCU', 'CASA DO CABOCLO UBIRAJARA', 'LUIS EDUARDO', true),
('002', 'CPO', 'CASA DE PAI OXALA', 'SERGIO VIEIRA', true);

-- ============================================================================
-- TABELA 2: DIAS DE SESSÃO
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.dia_sessao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cod VARCHAR(10) NOT NULL UNIQUE,
    nucleo VARCHAR(10) NOT NULL,
    dia VARCHAR(50) NOT NULL,
    responsavel VARCHAR(255),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_dia_sessao_nucleo ON public.dia_sessao(nucleo);
CREATE INDEX IF NOT EXISTS idx_dia_sessao_dia ON public.dia_sessao(dia);
CREATE INDEX IF NOT EXISTS idx_dia_sessao_ativo ON public.dia_sessao(ativo);

-- Trigger para updated_at
CREATE TRIGGER atualizar_dia_sessao_updated_at
    BEFORE UPDATE ON public.dia_sessao
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- Comentários
COMMENT ON TABLE public.dia_sessao IS 'Dias de sessão de cada núcleo com seus responsáveis';
COMMENT ON COLUMN public.dia_sessao.cod IS 'Código único do dia de sessão';
COMMENT ON COLUMN public.dia_sessao.nucleo IS 'Sigla do núcleo (CCU, CPO)';
COMMENT ON COLUMN public.dia_sessao.dia IS 'Dia da semana da sessão';

-- Inserir dados dos dias de sessão
INSERT INTO public.dia_sessao (cod, nucleo, dia, responsavel, ativo) VALUES
('CCU-TER', 'CCU', 'TERÇA-FEIRA', 'NICOLAS BARROS', true),
('CCU-QUA', 'CCU', 'QUARTA-FEIRA', 'ROSIMAR PEÇANHA', true),
('CCU-QUI', 'CCU', 'QUINTA-FEIRA (OJU)', 'ANA CRISTINA MARQUES', true),
('CCU-SEX', 'CCU', 'SEXTA-FEIRA', 'LUIS EDUARDO', true),
('CCU-SAB', 'CCU', 'SÁBADO', 'ALEXANDRA MONTEIRO', true),
('CPO-SAB', 'CPO', 'SÁBADO', 'SERGIO VIEIRA', true),
('CCU-CEN', 'CCU', 'CENTELHINHA', 'ADRIANA MARQUES', true);

-- ============================================================================
-- TABELA 3: CLASSIFICAÇÃO MEDIÚNICA
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.classificacao_mediunica (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cod VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL UNIQUE,
    ordem INTEGER NOT NULL,
    tipo VARCHAR(50),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_classificacao_mediunica_ordem ON public.classificacao_mediunica(ordem);
CREATE INDEX IF NOT EXISTS idx_classificacao_mediunica_tipo ON public.classificacao_mediunica(tipo);
CREATE INDEX IF NOT EXISTS idx_classificacao_mediunica_ativo ON public.classificacao_mediunica(ativo);

-- Trigger para updated_at
CREATE TRIGGER atualizar_classificacao_mediunica_updated_at
    BEFORE UPDATE ON public.classificacao_mediunica
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- Comentários
COMMENT ON TABLE public.classificacao_mediunica IS 'Classificações mediúnicas da organização';
COMMENT ON COLUMN public.classificacao_mediunica.cod IS 'Código único da classificação';
COMMENT ON COLUMN public.classificacao_mediunica.ordem IS 'Ordem hierárquica da classificação';
COMMENT ON COLUMN public.classificacao_mediunica.tipo IS 'Tipo: GRAU, FUNCAO_LIDERANCA, FUNCAO_APOIO';

-- Inserir dados das classificações mediúnicas
INSERT INTO public.classificacao_mediunica (cod, nome, ordem, tipo, ativo) VALUES
-- Graus mediúnicos (ordem crescente)
('GRAU_VERM', 'GRAU VERMELHO', 1, 'GRAU', true),
('GRAU_CORAL', 'GRAU CORAL', 2, 'GRAU', true),
('GRAU_AMAR', 'GRAU AMARELO', 3, 'GRAU', true),
('GRAU_VERDE', 'GRAU VERDE', 4, 'GRAU', true),
('GRAU_AZUL', 'GRAU AZUL', 5, 'GRAU', true),
('GRAU_INDIGO', 'GRAU ÍNDIGO', 6, 'GRAU', true),
('GRAU_LILAS', 'GRAU LILÁS', 7, 'GRAU', true),
('DIRIGENTE', 'DIRIGENTE', 8, 'FUNCAO_LIDERANCA', true),
-- Funções de apoio
('CAMBONO', 'CAMBONO', 9, 'FUNCAO_APOIO', true),
('CURIMBEIRO', 'CURIMBEIRO', 10, 'FUNCAO_APOIO', true);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Tabela nucleos
ALTER TABLE public.nucleos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de núcleos"
    ON public.nucleos FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de núcleos"
    ON public.nucleos FOR ALL
    USING (auth.role() = 'authenticated');

-- Tabela dia_sessao
ALTER TABLE public.dia_sessao ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de dias de sessão"
    ON public.dia_sessao FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de dias de sessão"
    ON public.dia_sessao FOR ALL
    USING (auth.role() = 'authenticated');

-- Tabela classificacao_mediunica
ALTER TABLE public.classificacao_mediunica ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de classificações"
    ON public.classificacao_mediunica FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de classificações"
    ON public.classificacao_mediunica FOR ALL
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VIEWS ÚTEIS
-- ============================================================================

-- View: Dias de sessão com informações do núcleo
CREATE OR REPLACE VIEW v_dias_sessao_completo AS
SELECT 
    ds.id,
    ds.cod,
    ds.nucleo,
    n.nome as nucleo_nome,
    ds.dia,
    ds.responsavel,
    n.coordenador as coordenador_nucleo,
    ds.ativo
FROM dia_sessao ds
LEFT JOIN nucleos n ON ds.nucleo = n.sigla
WHERE ds.ativo = true;

-- View: Classificações por tipo
CREATE OR REPLACE VIEW v_classificacoes_por_tipo AS
SELECT 
    tipo,
    COUNT(*) as total,
    array_agg(nome ORDER BY ordem) as classificacoes
FROM classificacao_mediunica
WHERE ativo = true
GROUP BY tipo;

-- ============================================================================
-- VERIFICAÇÃO
-- ============================================================================

-- Ver núcleos inseridos
SELECT * FROM public.nucleos ORDER BY cod;

-- Ver dias de sessão inseridos
SELECT * FROM public.dia_sessao ORDER BY nucleo, dia;

-- Ver classificações inseridas
SELECT * FROM public.classificacao_mediunica ORDER BY ordem;

-- Ver view de dias de sessão completo
SELECT * FROM v_dias_sessao_completo ORDER BY nucleo, dia;

-- Ver classificações por tipo
SELECT * FROM v_classificacoes_por_tipo;
