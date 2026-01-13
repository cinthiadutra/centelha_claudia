-- ============================================
-- SISTEMA DE AVALIAÇÃO MENSAL - SCHEMA SQL
-- ============================================

-- Tabela de Membros para Avaliação
CREATE TABLE IF NOT EXISTS membros_avaliacao (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome_completo TEXT NOT NULL,
    classificacao TEXT NOT NULL,
    nucleo TEXT NOT NULL,
    dia_sessao TEXT NOT NULL,
    grupo_trabalho_espiritual TEXT,
    grupos_tarefa TEXT[], -- Array de grupos
    grupos_acao_social TEXT[],
    atividades_espirituais TEXT[],
    cargos_lideranca TEXT[],
    mensalidade_em_dia BOOLEAN DEFAULT TRUE,
    pai_mae_terreiro UUID,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Calendário de Atividades
CREATE TABLE IF NOT EXISTS calendario_atividades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data DATE NOT NULL,
    tipo TEXT NOT NULL,
    descricao TEXT NOT NULL,
    dia_sessao TEXT,
    grupo_relacionado TEXT,
    realizada BOOLEAN DEFAULT TRUE,
    mes INT NOT NULL,
    ano INT NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Registro de Presenças
CREATE TABLE IF NOT EXISTS registros_presenca (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    membro_id UUID NOT NULL REFERENCES membros_avaliacao(id) ON DELETE CASCADE,
    atividade_id UUID NOT NULL REFERENCES calendario_atividades(id) ON DELETE CASCADE,
    presente BOOLEAN NOT NULL,
    justificativa TEXT,
    trocou_escala BOOLEAN DEFAULT FALSE,
    registrado_por UUID,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id, atividade_id)
);

-- Tabela de Avaliações Mensais
CREATE TABLE IF NOT EXISTS avaliacoes_mensais (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    membro_id UUID NOT NULL REFERENCES membros_avaliacao(id) ON DELETE CASCADE,
    membro_nome TEXT NOT NULL,
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    nota_a DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_b DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_c DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_d DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_e DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_f DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_g DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_h DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_i DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_j DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_k DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_l DECIMAL(5,2) NOT NULL DEFAULT 0,
    nota_real DECIMAL(6,2) NOT NULL,
    nota_final DECIMAL(5,2) NOT NULL,
    data_calculo TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    observacoes TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id, mes, ano)
);

-- Tabela de Conceitos dados por Líderes
CREATE TABLE IF NOT EXISTS conceitos_lideres (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    membro_id UUID NOT NULL REFERENCES membros_avaliacao(id) ON DELETE CASCADE,
    lider_id UUID NOT NULL,
    tipo_grupo TEXT NOT NULL, -- 'grupo_tarefa' ou 'grupo_acao_social'
    grupo TEXT NOT NULL,
    conceito DECIMAL(4,2) NOT NULL CHECK (conceito BETWEEN 0 AND 10),
    mes INT NOT NULL,
    ano INT NOT NULL,
    observacao TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id, tipo_grupo, grupo, mes, ano)
);

-- Tabela de Conceitos de Pais/Mães de Terreiro
CREATE TABLE IF NOT EXISTS conceitos_pais_maes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    membro_id UUID NOT NULL REFERENCES membros_avaliacao(id) ON DELETE CASCADE,
    pai_mae_id UUID NOT NULL,
    conceito DECIMAL(4,2) NOT NULL CHECK (conceito BETWEEN 0 AND 10),
    mes INT NOT NULL,
    ano INT NOT NULL,
    observacao TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id, mes, ano)
);

-- Tabela de Bônus do Tata
CREATE TABLE IF NOT EXISTS bonus_tata (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    membro_id UUID NOT NULL REFERENCES membros_avaliacao(id) ON DELETE CASCADE,
    bonus DECIMAL(4,2) NOT NULL CHECK (bonus BETWEEN 0 AND 10),
    mes INT NOT NULL,
    ano INT NOT NULL,
    observacao TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(membro_id, mes, ano)
);

-- ============================================
-- ÍNDICES
-- ============================================
CREATE INDEX idx_membros_classificacao ON membros_avaliacao(classificacao);
CREATE INDEX idx_membros_nucleo ON membros_avaliacao(nucleo);
CREATE INDEX idx_membros_ativo ON membros_avaliacao(ativo);

CREATE INDEX idx_calendario_data ON calendario_atividades(data);
CREATE INDEX idx_calendario_tipo ON calendario_atividades(tipo);
CREATE INDEX idx_calendario_mes_ano ON calendario_atividades(mes, ano);

CREATE INDEX idx_presenca_membro ON registros_presenca(membro_id);
CREATE INDEX idx_presenca_atividade ON registros_presenca(atividade_id);

CREATE INDEX idx_avaliacoes_membro ON avaliacoes_mensais(membro_id);
CREATE INDEX idx_avaliacoes_mes_ano ON avaliacoes_mensais(mes, ano);
CREATE INDEX idx_avaliacoes_nota_final ON avaliacoes_mensais(nota_final DESC);

-- ============================================
-- RLS (Row Level Security)
-- ============================================
ALTER TABLE membros_avaliacao ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendario_atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros_presenca ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes_mensais ENABLE ROW LEVEL SECURITY;
ALTER TABLE conceitos_lideres ENABLE ROW LEVEL SECURITY;
ALTER TABLE conceitos_pais_maes ENABLE ROW LEVEL SECURITY;
ALTER TABLE bonus_tata ENABLE ROW LEVEL SECURITY;

-- Policies básicas (usuários autenticados podem tudo)
CREATE POLICY "Acesso completo para autenticados" ON membros_avaliacao FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON calendario_atividades FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON registros_presenca FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON avaliacoes_mensais FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON conceitos_lideres FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON conceitos_pais_maes FOR ALL TO authenticated USING (true);
CREATE POLICY "Acesso completo para autenticados" ON bonus_tata FOR ALL TO authenticated USING (true);

-- ============================================
-- TRIGGER PARA ATUALIZAR atualizado_em
-- ============================================
CREATE OR REPLACE FUNCTION update_atualizado_em_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_membros_avaliacao_atualizado_em
    BEFORE UPDATE ON membros_avaliacao
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

CREATE TRIGGER update_calendario_atividades_atualizado_em
    BEFORE UPDATE ON calendario_atividades
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

CREATE TRIGGER update_registros_presenca_atualizado_em
    BEFORE UPDATE ON registros_presenca
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

CREATE TRIGGER update_avaliacoes_mensais_atualizado_em
    BEFORE UPDATE ON avaliacoes_mensais
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();
