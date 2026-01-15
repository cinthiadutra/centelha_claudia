-- ============================================================================
-- TABELA CONSOLIDADA DE AVALIAÇÕES MENSAIS
-- ============================================================================
-- Esta tabela armazena o resultado final do cálculo de todas as notas (A-L)
-- para cada membro em cada mês, incluindo posição no ranking e histórico.
-- ============================================================================

CREATE TABLE IF NOT EXISTS avaliacoes_mensais (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identificação
    mes INTEGER NOT NULL CHECK (mes >= 1 AND mes <= 12),
    ano INTEGER NOT NULL CHECK (ano >= 2024 AND ano <= 2030),
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL,
    
    -- NOTAS INDIVIDUAIS (0.0 a 10.0)
    nota_a DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_a >= 0 AND nota_a <= 10),
    nota_b DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_b >= 0 AND nota_b <= 10),
    nota_c DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_c >= 0 AND nota_c <= 10),
    nota_d DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_d >= 0 AND nota_d <= 10),
    nota_e DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_e >= 0 AND nota_e <= 10),
    nota_f DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_f >= 0 AND nota_f <= 10),
    nota_g DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_g >= 0 AND nota_g <= 10),
    nota_h DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_h >= 0 AND nota_h <= 10),
    nota_i DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_i >= 0 AND nota_i <= 10),
    nota_j DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_j >= 0 AND nota_j <= 10),
    nota_k DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_k >= 0 AND nota_k <= 10),
    nota_l DECIMAL(3,1) DEFAULT 0.0 CHECK (nota_l >= 0 AND nota_l <= 10),
    
    -- TOTALIZADORES
    nota_total DECIMAL(5,1) DEFAULT 0.0, -- Soma de todas as notas (0-120)
    nota_normalizada DECIMAL(5,2) DEFAULT 0.0, -- Normalizada 0-100 (120 * 100/120)
    
    -- POSIÇÃO NO RANKING
    posicao_geral INTEGER, -- Posição entre todos os membros
    posicao_nucleo INTEGER, -- Posição dentro do núcleo
    total_membros INTEGER, -- Total de membros avaliados no mês
    
    -- HISTÓRICO
    nota_mes_anterior DECIMAL(5,1), -- Nota total do mês anterior
    posicao_mes_anterior INTEGER, -- Posição do mês anterior
    variacao_nota DECIMAL(5,1), -- Diferença em relação ao mês anterior
    variacao_posicao INTEGER, -- Diferença de posição (negativo = subiu)
    
    -- MEDALHAS E DESTAQUES
    medalha TEXT, -- 'ouro', 'prata', 'bronze' ou NULL
    destaque_nota TEXT, -- Qual nota teve melhor desempenho
    alerta_nota TEXT, -- Qual nota precisa de atenção
    
    -- OBSERVAÇÕES
    observacao TEXT, -- Observações gerais sobre a avaliação
    status TEXT DEFAULT 'calculado', -- 'calculado', 'revisado', 'aprovado'
    
    -- AUDITORIA
    calculado_em TIMESTAMP DEFAULT NOW(),
    calculado_por TEXT, -- ID do usuário que executou o cálculo
    revisado_em TIMESTAMP,
    revisado_por TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    -- Constraint de unicidade
    UNIQUE (mes, ano, membro_id)
);

-- Índices para performance
CREATE INDEX idx_avaliacoes_mensais_mes_ano ON avaliacoes_mensais(mes, ano);
CREATE INDEX idx_avaliacoes_mensais_membro ON avaliacoes_mensais(membro_id);
CREATE INDEX idx_avaliacoes_mensais_nucleo ON avaliacoes_mensais(nucleo);
CREATE INDEX idx_avaliacoes_mensais_ranking ON avaliacoes_mensais(mes, ano, nota_total DESC);
CREATE INDEX idx_avaliacoes_mensais_status ON avaliacoes_mensais(status);

-- Trigger para atualizar updated_at
CREATE TRIGGER atualizar_avaliacoes_mensais_updated_at
    BEFORE UPDATE ON avaliacoes_mensais
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE avaliacoes_mensais ENABLE ROW LEVEL SECURITY;

-- Política de leitura: todos podem ver
CREATE POLICY "Leitura pública de avaliações"
    ON avaliacoes_mensais
    FOR SELECT
    USING (true);

-- Política de inserção: apenas usuários autenticados
CREATE POLICY "Inserção autenticada de avaliações"
    ON avaliacoes_mensais
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Política de atualização: apenas usuários autenticados
CREATE POLICY "Atualização autenticada de avaliações"
    ON avaliacoes_mensais
    FOR UPDATE
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VIEWS AUXILIARES
-- ============================================================================

-- View: Ranking Geral do Mês Atual
CREATE OR REPLACE VIEW ranking_mes_atual AS
SELECT 
    membro_nome,
    nucleo,
    nota_a, nota_b, nota_c, nota_d, nota_e, nota_f,
    nota_g, nota_h, nota_i, nota_j, nota_k, nota_l,
    nota_total,
    nota_normalizada,
    posicao_geral,
    posicao_nucleo,
    medalha,
    variacao_nota,
    variacao_posicao
FROM avaliacoes_mensais
WHERE mes = EXTRACT(MONTH FROM CURRENT_DATE)
  AND ano = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY nota_total DESC;

-- View: Top 10 do Ano
CREATE OR REPLACE VIEW top_10_ano AS
SELECT 
    membro_nome,
    nucleo,
    AVG(nota_total) as media_anual,
    COUNT(*) as meses_avaliados,
    MAX(nota_total) as melhor_nota,
    MIN(nota_total) as pior_nota
FROM avaliacoes_mensais
WHERE ano = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY membro_id, membro_nome, nucleo
ORDER BY media_anual DESC
LIMIT 10;

-- View: Evolução Mensal por Membro
CREATE OR REPLACE VIEW evolucao_mensal_membros AS
SELECT 
    membro_nome,
    nucleo,
    mes,
    ano,
    nota_total,
    posicao_geral,
    variacao_nota,
    variacao_posicao,
    CASE 
        WHEN variacao_posicao < 0 THEN 'subiu'
        WHEN variacao_posicao > 0 THEN 'desceu'
        ELSE 'manteve'
    END as tendencia
FROM avaliacoes_mensais
ORDER BY membro_nome, ano, mes;

-- View: Estatísticas por Núcleo
CREATE OR REPLACE VIEW estatisticas_por_nucleo AS
SELECT 
    nucleo,
    mes,
    ano,
    COUNT(*) as total_membros,
    AVG(nota_total) as media_nucleo,
    MAX(nota_total) as melhor_nota,
    MIN(nota_total) as pior_nota,
    STDDEV(nota_total) as desvio_padrao
FROM avaliacoes_mensais
GROUP BY nucleo, mes, ano
ORDER BY ano DESC, mes DESC, nucleo;

-- ============================================================================
-- FUNÇÃO: CALCULAR E SALVAR AVALIAÇÃO MENSAL
-- ============================================================================

CREATE OR REPLACE FUNCTION calcular_avaliacao_mensal(
    p_mes INTEGER,
    p_ano INTEGER,
    p_membro_id TEXT
) RETURNS UUID AS $$
DECLARE
    v_avaliacao_id UUID;
    v_nota_total DECIMAL(5,1);
    v_nota_mes_anterior DECIMAL(5,1);
    v_posicao_mes_anterior INTEGER;
BEGIN
    -- Buscar nota do mês anterior
    SELECT nota_total, posicao_geral
    INTO v_nota_mes_anterior, v_posicao_mes_anterior
    FROM avaliacoes_mensais
    WHERE membro_id = p_membro_id
      AND ((mes = p_mes - 1 AND ano = p_ano) OR 
           (mes = 12 AND ano = p_ano - 1 AND p_mes = 1))
    LIMIT 1;
    
    -- Calcular nota total (será atualizada com valores reais)
    -- Esta é apenas a estrutura inicial
    v_nota_total := 0.0;
    
    -- Inserir ou atualizar avaliação
    INSERT INTO avaliacoes_mensais (
        mes, ano, membro_id,
        nota_total,
        nota_mes_anterior,
        posicao_mes_anterior,
        variacao_nota,
        calculado_em
    ) VALUES (
        p_mes, p_ano, p_membro_id,
        v_nota_total,
        v_nota_mes_anterior,
        v_posicao_mes_anterior,
        COALESCE(v_nota_total - v_nota_mes_anterior, 0),
        NOW()
    )
    ON CONFLICT (mes, ano, membro_id)
    DO UPDATE SET
        nota_total = EXCLUDED.nota_total,
        variacao_nota = EXCLUDED.variacao_nota,
        updated_at = NOW()
    RETURNING id INTO v_avaliacao_id;
    
    RETURN v_avaliacao_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FUNÇÃO: RECALCULAR POSIÇÕES DO RANKING
-- ============================================================================

CREATE OR REPLACE FUNCTION recalcular_posicoes_ranking(
    p_mes INTEGER,
    p_ano INTEGER
) RETURNS void AS $$
DECLARE
    v_row RECORD;
    v_posicao_geral INTEGER := 0;
    v_posicao_nucleo INTEGER;
    v_nucleo_atual TEXT := '';
BEGIN
    -- Atualizar posições gerais
    FOR v_row IN (
        SELECT id, nucleo
        FROM avaliacoes_mensais
        WHERE mes = p_mes AND ano = p_ano
        ORDER BY nota_total DESC
    ) LOOP
        v_posicao_geral := v_posicao_geral + 1;
        
        -- Resetar contador de núcleo quando mudar
        IF v_nucleo_atual != v_row.nucleo THEN
            v_nucleo_atual := v_row.nucleo;
            v_posicao_nucleo := 0;
        END IF;
        
        v_posicao_nucleo := v_posicao_nucleo + 1;
        
        -- Atualizar posições
        UPDATE avaliacoes_mensais
        SET 
            posicao_geral = v_posicao_geral,
            posicao_nucleo = v_posicao_nucleo,
            variacao_posicao = COALESCE(posicao_mes_anterior - v_posicao_geral, 0),
            -- Atribuir medalhas
            medalha = CASE 
                WHEN v_posicao_geral = 1 THEN 'ouro'
                WHEN v_posicao_geral = 2 THEN 'prata'
                WHEN v_posicao_geral = 3 THEN 'bronze'
                ELSE NULL
            END
        WHERE id = v_row.id;
    END LOOP;
    
    -- Atualizar total de membros
    UPDATE avaliacoes_mensais
    SET total_membros = v_posicao_geral
    WHERE mes = p_mes AND ano = p_ano;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- COMENTÁRIOS NA TABELA
-- ============================================================================

COMMENT ON TABLE avaliacoes_mensais IS 'Tabela consolidada com todas as avaliações mensais dos membros, incluindo notas individuais (A-L), totalizadores, posições no ranking e histórico';

COMMENT ON COLUMN avaliacoes_mensais.nota_a IS 'Nota A - Presença Ponto Eletrônico (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_b IS 'Nota B - Presença Calendário Oficial (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_c IS 'Nota C - Conceitos Grupo-Tarefa (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_d IS 'Nota D - Conceitos Ação Social (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_e IS 'Nota E - Consulta Espiritual (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_f IS 'Nota F - Escalas Cambonagem (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_g IS 'Nota G - Escalas Arrumação/Desarrumação (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_h IS 'Nota H - Mensalidade (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_i IS 'Nota I - Conceitos Pais/Mães de Terreiro (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_j IS 'Nota J - Bônus Tata (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_k IS 'Nota K - Consulta Espiritual Dada (0-10)';
COMMENT ON COLUMN avaliacoes_mensais.nota_l IS 'Nota L - Liderança de Grupo (0-10)';

COMMENT ON COLUMN avaliacoes_mensais.nota_total IS 'Soma de todas as notas (0-120)';
COMMENT ON COLUMN avaliacoes_mensais.nota_normalizada IS 'Nota total normalizada para escala 0-100';
COMMENT ON COLUMN avaliacoes_mensais.variacao_nota IS 'Diferença de pontos em relação ao mês anterior (positivo = melhorou)';
COMMENT ON COLUMN avaliacoes_mensais.variacao_posicao IS 'Diferença de posição em relação ao mês anterior (negativo = subiu no ranking)';
