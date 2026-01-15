-- ==========================================
-- SCRIPT DE CRIAÇÃO DA TABELA REGISTROS DE PRESENÇA
-- ==========================================
-- Execute este script no SQL Editor do Supabase

-- PASSO 1: Criar a tabela registros_presenca
CREATE TABLE IF NOT EXISTS public.registros_presenca (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membro_id TEXT NOT NULL,                 -- ID do membro (pode ser código temporário)
    atividade_id BIGINT NOT NULL,            -- Referência ao ID de calendario_2026
    data_hora TIMESTAMP WITH TIME ZONE NOT NULL,
    presente BOOLEAN NOT NULL DEFAULT TRUE,
    codigo TEXT,                             -- Código do membro no sistema de ponto
    nome_registrado TEXT,                    -- Nome como aparece no registro
    justificativa TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraint de unicidade para evitar duplicatas
    UNIQUE(membro_id, atividade_id)
);

-- PASSO 2: Criar índices para melhorar performance de busca
CREATE INDEX IF NOT EXISTS idx_presenca_membro ON public.registros_presenca(membro_id);
CREATE INDEX IF NOT EXISTS idx_presenca_atividade ON public.registros_presenca(atividade_id);
CREATE INDEX IF NOT EXISTS idx_presenca_data_hora ON public.registros_presenca(data_hora);
CREATE INDEX IF NOT EXISTS idx_presenca_codigo ON public.registros_presenca(codigo);

-- PASSO 3: Adicionar foreign key para calendario_2026
ALTER TABLE public.registros_presenca
ADD CONSTRAINT fk_atividade_calendario
FOREIGN KEY (atividade_id) REFERENCES public.calendario_2026(id)
ON DELETE CASCADE;

-- PASSO 4: Habilitar RLS (Row Level Security)
ALTER TABLE public.registros_presenca ENABLE ROW LEVEL SECURITY;

-- PASSO 5: Criar políticas de acesso
-- Política para leitura pública (qualquer usuário autenticado pode ler)
CREATE POLICY "Permitir leitura para todos os usuários autenticados"
ON public.registros_presenca
FOR SELECT
TO authenticated
USING (true);

-- Política para inserção (apenas usuários autenticados podem inserir)
CREATE POLICY "Permitir inserção para usuários autenticados"
ON public.registros_presenca
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Política para atualização (apenas usuários autenticados podem atualizar)
CREATE POLICY "Permitir atualização para usuários autenticados"
ON public.registros_presenca
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Política para deleção (apenas usuários autenticados podem deletar)
CREATE POLICY "Permitir deleção para usuários autenticados"
ON public.registros_presenca
FOR DELETE
TO authenticated
USING (true);

-- PASSO 6: Criar função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_registros_presenca_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- PASSO 7: Criar trigger para atualizar updated_at
CREATE TRIGGER trigger_update_registros_presenca_updated_at
    BEFORE UPDATE ON public.registros_presenca
    FOR EACH ROW
    EXECUTE FUNCTION update_registros_presenca_updated_at();

-- ==========================================
-- CONSULTAS ÚTEIS
-- ==========================================

-- Verificar se a tabela foi criada
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'registros_presenca' 
ORDER BY ordinal_position;

-- Contar registros por data
SELECT 
    DATE(data_hora) as data,
    COUNT(*) as total_presencas
FROM registros_presenca
GROUP BY DATE(data_hora)
ORDER BY data;

-- Ver presenças por atividade
SELECT 
    rp.atividade_id,
    c.data,
    c.atividade,
    COUNT(*) as total_presencas
FROM registros_presenca rp
JOIN calendario_2026 c ON c.id = rp.atividade_id
GROUP BY rp.atividade_id, c.data, c.atividade
ORDER BY c.data;

-- Buscar presenças por membro
SELECT 
    rp.membro_id,
    rp.nome_registrado,
    rp.codigo,
    COUNT(*) as total_presencas
FROM registros_presenca rp
GROUP BY rp.membro_id, rp.nome_registrado, rp.codigo
ORDER BY total_presencas DESC;
