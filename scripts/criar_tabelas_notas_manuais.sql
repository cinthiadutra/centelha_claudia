-- ==========================================
-- TABELAS PARA NOTAS MANUAIS (C, D, F, G, H, I, J)
-- ==========================================
-- Execute este script no SQL Editor do Supabase

-- ==========================================
-- NOTA C: CONCEITOS DE GRUPO-TAREFA
-- ==========================================
CREATE TABLE IF NOT EXISTS public.conceitos_grupo_tarefa (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    grupo_tarefa TEXT NOT NULL,
    conceito DECIMAL(3,1) NOT NULL CHECK (conceito BETWEEN 0 AND 10),
    lider_id TEXT NOT NULL,
    lider_nome TEXT NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(mes, ano, membro_id, grupo_tarefa)
);

CREATE INDEX idx_conceitos_gt_periodo ON public.conceitos_grupo_tarefa(ano, mes);
CREATE INDEX idx_conceitos_gt_membro ON public.conceitos_grupo_tarefa(membro_id);

-- ==========================================
-- NOTA D: CONCEITOS DE GRUPO DE AÇÃO SOCIAL
-- ==========================================
CREATE TABLE IF NOT EXISTS public.conceitos_acao_social (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    grupo_acao_social TEXT NOT NULL,
    conceito DECIMAL(3,1) NOT NULL CHECK (conceito BETWEEN 0 AND 10),
    lider_id TEXT NOT NULL,
    lider_nome TEXT NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(mes, ano, membro_id, grupo_acao_social)
);

CREATE INDEX idx_conceitos_as_periodo ON public.conceitos_acao_social(ano, mes);
CREATE INDEX idx_conceitos_as_membro ON public.conceitos_acao_social(membro_id);

-- ==========================================
-- NOTA F: ESCALAS DE CAMBONAGEM
-- ==========================================
CREATE TABLE IF NOT EXISTS public.escalas_cambonagem (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data DATE NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL, -- CCU ou CPO
    compareceu BOOLEAN DEFAULT NULL, -- NULL = não registrado ainda
    trocou_escala BOOLEAN DEFAULT FALSE,
    trocou_com_id TEXT,
    trocou_com_nome TEXT,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(data, membro_id)
);

CREATE INDEX idx_escalas_cambonagem_data ON public.escalas_cambonagem(data);
CREATE INDEX idx_escalas_cambonagem_membro ON public.escalas_cambonagem(membro_id);

-- ==========================================
-- NOTA G: ESCALAS DE ARRUMAÇÃO/DESARRUMAÇÃO
-- ==========================================
CREATE TABLE IF NOT EXISTS public.escalas_arrumacao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data DATE NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('arrumacao', 'desarrumacao')),
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL, -- CCU ou CPO
    compareceu BOOLEAN DEFAULT NULL, -- NULL = não registrado ainda
    trocou_escala BOOLEAN DEFAULT FALSE,
    trocou_com_id TEXT,
    trocou_com_nome TEXT,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(data, tipo, membro_id)
);

CREATE INDEX idx_escalas_arrumacao_data ON public.escalas_arrumacao(data);
CREATE INDEX idx_escalas_arrumacao_membro ON public.escalas_arrumacao(membro_id);

-- ==========================================
-- NOTA H: STATUS DE MENSALIDADE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.status_mensalidade (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    em_dia BOOLEAN NOT NULL DEFAULT FALSE,
    valor_pago DECIMAL(10,2),
    data_pagamento DATE,
    observacoes TEXT,
    atualizado_por TEXT, -- ID do tesoureiro
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(mes, ano, membro_id)
);

CREATE INDEX idx_mensalidade_periodo ON public.status_mensalidade(ano, mes);
CREATE INDEX idx_mensalidade_membro ON public.status_mensalidade(membro_id);

-- ==========================================
-- NOTA I: CONCEITOS DE PAIS/MÃES DE TERREIRO
-- ==========================================
CREATE TABLE IF NOT EXISTS public.conceitos_pais_maes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    conceito DECIMAL(3,1) NOT NULL CHECK (conceito BETWEEN 0 AND 10),
    pai_mae_id TEXT NOT NULL,
    pai_mae_nome TEXT NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(mes, ano, membro_id)
);

CREATE INDEX idx_conceitos_pm_periodo ON public.conceitos_pais_maes(ano, mes);
CREATE INDEX idx_conceitos_pm_membro ON public.conceitos_pais_maes(membro_id);

-- ==========================================
-- NOTA J: BÔNUS DO TATA
-- ==========================================
CREATE TABLE IF NOT EXISTS public.bonus_tata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano INT NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    bonus DECIMAL(3,1) NOT NULL CHECK (bonus BETWEEN 0 AND 10),
    motivo TEXT,
    observacoes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(mes, ano, membro_id)
);

CREATE INDEX idx_bonus_tata_periodo ON public.bonus_tata(ano, mes);
CREATE INDEX idx_bonus_tata_membro ON public.bonus_tata(membro_id);

-- ==========================================
-- POLÍTICAS RLS (Row Level Security)
-- ==========================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE public.conceitos_grupo_tarefa ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conceitos_acao_social ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.escalas_cambonagem ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.escalas_arrumacao ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.status_mensalidade ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conceitos_pais_maes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bonus_tata ENABLE ROW LEVEL SECURITY;

-- Políticas para leitura (todos autenticados podem ler)
CREATE POLICY "Leitura para autenticados" ON public.conceitos_grupo_tarefa FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.conceitos_acao_social FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.escalas_cambonagem FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.escalas_arrumacao FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.status_mensalidade FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.conceitos_pais_maes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Leitura para autenticados" ON public.bonus_tata FOR SELECT TO authenticated USING (true);

-- Políticas para escrita (apenas autenticados)
CREATE POLICY "Escrita para autenticados" ON public.conceitos_grupo_tarefa FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.conceitos_acao_social FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.escalas_cambonagem FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.escalas_arrumacao FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.status_mensalidade FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.conceitos_pais_maes FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Escrita para autenticados" ON public.bonus_tata FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ==========================================
-- TRIGGERS PARA ATUALIZAR updated_at
-- ==========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_conceitos_gt_updated_at BEFORE UPDATE ON public.conceitos_grupo_tarefa
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conceitos_as_updated_at BEFORE UPDATE ON public.conceitos_acao_social
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_escalas_cambonagem_updated_at BEFORE UPDATE ON public.escalas_cambonagem
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_escalas_arrumacao_updated_at BEFORE UPDATE ON public.escalas_arrumacao
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mensalidade_updated_at BEFORE UPDATE ON public.status_mensalidade
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conceitos_pm_updated_at BEFORE UPDATE ON public.conceitos_pais_maes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bonus_tata_updated_at BEFORE UPDATE ON public.bonus_tata
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- CONSULTAS ÚTEIS
-- ==========================================

-- Ver todos os conceitos do mês
-- SELECT * FROM conceitos_grupo_tarefa WHERE mes = 8 AND ano = 2025;
-- SELECT * FROM conceitos_acao_social WHERE mes = 8 AND ano = 2025;

-- Ver escalas do mês
-- SELECT * FROM escalas_cambonagem WHERE EXTRACT(MONTH FROM data) = 8 AND EXTRACT(YEAR FROM data) = 2025;
-- SELECT * FROM escalas_arrumacao WHERE EXTRACT(MONTH FROM data) = 8 AND EXTRACT(YEAR FROM data) = 2025;

-- Ver mensalidades do mês
-- SELECT * FROM status_mensalidade WHERE mes = 8 AND ano = 2025;

-- Ver conceitos pais/mães do mês
-- SELECT * FROM conceitos_pais_maes WHERE mes = 8 AND ano = 2025;

-- Ver bônus do Tata do mês
-- SELECT * FROM bonus_tata WHERE mes = 8 AND ano = 2025;
