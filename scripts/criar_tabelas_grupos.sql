-- ============================================================================
-- FUNÇÃO PARA ATUALIZAR TIMESTAMP
-- ============================================================================

CREATE OR REPLACE FUNCTION atualizar_timestamp_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TABELA DE GRUPOS
-- ============================================================================
-- Armazena todos os grupos, grupo-tarefas, ações sociais e atividades
-- ============================================================================

CREATE TABLE IF NOT EXISTS grupos (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    tipo TEXT NOT NULL,
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Constraint de tipos válidos
ALTER TABLE grupos ADD CONSTRAINT grupos_tipo_valido 
    CHECK (tipo IN (
        'atividade_espiritual',
        'grupo_trabalho_espiritual', 
        'grupo_tarefa',
        'acao_social',
        'cargo_lideranca'
    ));

-- Índices
CREATE INDEX idx_grupos_tipo ON grupos(tipo);
CREATE INDEX idx_grupos_ativo ON grupos(ativo);
CREATE INDEX idx_grupos_nome ON grupos(nome);

-- Trigger para updated_at
CREATE TRIGGER atualizar_grupos_updated_at
    BEFORE UPDATE ON grupos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- ============================================================================
-- TABELA DE VÍNCULOS MEMBROS-GRUPOS
-- ============================================================================
-- Vincula membros aos grupos que participam
-- ============================================================================

CREATE TABLE IF NOT EXISTS grupo_membros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    grupo_id TEXT NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL,
    data_entrada DATE DEFAULT CURRENT_DATE,
    data_saida DATE,
    ativo BOOLEAN DEFAULT true,
    observacao TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (grupo_id, membro_id)
);

-- Índices
CREATE INDEX idx_grupo_membros_grupo ON grupo_membros(grupo_id);
CREATE INDEX idx_grupo_membros_membro ON grupo_membros(membro_id);
CREATE INDEX idx_grupo_membros_ativo ON grupo_membros(ativo);

-- Trigger para updated_at
CREATE TRIGGER atualizar_grupo_membros_updated_at
    BEFORE UPDATE ON grupo_membros
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Tabela grupos
ALTER TABLE grupos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de grupos"
    ON grupos FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de grupos"
    ON grupos FOR ALL
    USING (auth.role() = 'authenticated');

-- Tabela grupo_membros
ALTER TABLE grupo_membros ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública de vínculos"
    ON grupo_membros FOR SELECT
    USING (true);

CREATE POLICY "Escrita autenticada de vínculos"
    ON grupo_membros FOR ALL
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VIEWS ÚTEIS
-- ============================================================================

-- View: Grupos ativos por tipo
CREATE OR REPLACE VIEW grupos_ativos_por_tipo AS
SELECT 
    tipo,
    COUNT(*) as total_grupos,
    array_agg(nome ORDER BY nome) as grupos
FROM grupos
WHERE ativo = true
GROUP BY tipo;

-- View: Membros por grupo
CREATE OR REPLACE VIEW membros_por_grupo AS
SELECT 
    g.id as grupo_id,
    g.nome as grupo_nome,
    g.tipo as grupo_tipo,
    COUNT(gm.membro_id) as total_membros,
    array_agg(gm.membro_nome ORDER BY gm.membro_nome) as membros
FROM grupos g
LEFT JOIN grupo_membros gm ON g.id = gm.grupo_id AND gm.ativo = true
WHERE g.ativo = true
GROUP BY g.id, g.nome, g.tipo
ORDER BY g.tipo, g.nome;

-- ============================================================================
-- COMENTÁRIOS
-- ============================================================================

COMMENT ON TABLE grupos IS 'Cadastro de todos os grupos, grupo-tarefas, ações sociais e atividades';
COMMENT ON TABLE grupo_membros IS 'Vínculo de membros aos grupos que participam';

COMMENT ON COLUMN grupos.tipo IS 'atividade_espiritual | grupo_trabalho_espiritual | grupo_tarefa | acao_social | cargo_lideranca';
COMMENT ON COLUMN grupo_membros.ativo IS 'Se o vínculo está ativo (membro ainda participa do grupo)';
