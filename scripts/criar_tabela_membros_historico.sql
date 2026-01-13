-- ================================================
-- SCRIPT DE IMPORTAÇÃO DE MEMBROS ANTIGOS
-- ================================================
-- Execute este script no SQL Editor do Supabase
-- Importa dados do CSV HIST_ESPIR para a tabela membros_historico
-- ================================================

-- 1. CRIAR TABELA MEMBROS_HISTORICO
CREATE TABLE IF NOT EXISTS membros_historico (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  
  -- Identificação
  mov INTEGER,
  cadastro VARCHAR(20),
  nome VARCHAR(255) NOT NULL,
  nucleo VARCHAR(100),
  status VARCHAR(100),
  funcao VARCHAR(100),
  classificacao VARCHAR(50),
  dia_sessao VARCHAR(50),
  
  -- Estágios e Ritos
  inicio_estagio DATE,
  desistencia_estagio DATE,
  primeiro_rito_passagem DATE,
  primeiro_desligamento DATE,
  primeiro_desligamento_justificativa TEXT,
  segundo_rito_passagem DATE,
  segundo_desligamento DATE,
  segundo_desligamento_justificativa TEXT,
  terceiro_rito_passagem DATE,
  terceiro_desligamento DATE,
  terceiro_desligamento_justificativa TEXT,
  
  -- Sacramentos
  ritual_batismo DATE,
  jogo_orixa DATE,
  coroacao_sacerdote DATE,
  primeira_camarinha DATE,
  segunda_camarinha DATE,
  terceira_camarinha DATE,
  
  -- Atividades
  atividade_espiritual VARCHAR(255),
  grupo_trabalho_espiritual VARCHAR(255),
  
  -- Orixás
  primeiro_orixa VARCHAR(100),
  adjunto_primeiro_orixa VARCHAR(100),
  segundo_orixa VARCHAR(100),
  adjunto_segundo_orixa VARCHAR(100),
  terceiro_quarto_orixa VARCHAR(100),
  
  -- Observações e Suspensões
  observacoes TEXT,
  primeira_suspensao_de DATE,
  primeira_suspensao_ate DATE,
  primeira_suspensao_justificativa TEXT,
  segunda_suspensao_de DATE,
  segunda_suspensao_ate DATE,
  segunda_suspensao_justificativa TEXT,
  terceira_suspensao_de DATE,
  terceira_suspensao_ate DATE,
  terceira_suspensao_justificativa TEXT,
  
  -- Metadados
  data_importacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. CRIAR ÍNDICES
CREATE INDEX IF NOT EXISTS idx_membros_historico_nome ON membros_historico(nome);
CREATE INDEX IF NOT EXISTS idx_membros_historico_cadastro ON membros_historico(cadastro);
CREATE INDEX IF NOT EXISTS idx_membros_historico_nucleo ON membros_historico(nucleo);
CREATE INDEX IF NOT EXISTS idx_membros_historico_status ON membros_historico(status);
CREATE INDEX IF NOT EXISTS idx_membros_historico_classificacao ON membros_historico(classificacao);

-- 3. HABILITAR RLS
ALTER TABLE membros_historico ENABLE ROW LEVEL SECURITY;

-- 4. CRIAR POLÍTICAS DE ACESSO
CREATE POLICY "Permitir leitura para usuários autenticados" 
ON membros_historico FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Permitir inserção para usuários autenticados" 
ON membros_historico FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Permitir atualização para usuários autenticados" 
ON membros_historico FOR UPDATE 
TO authenticated 
USING (true) WITH CHECK (true);

CREATE POLICY "Permitir deleção para usuários autenticados" 
ON membros_historico FOR DELETE 
TO authenticated 
USING (true);

-- 5. CRIAR TRIGGER PARA UPDATED_AT
CREATE OR REPLACE FUNCTION update_membros_historico_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_membros_historico_updated_at 
BEFORE UPDATE ON membros_historico 
FOR EACH ROW 
EXECUTE FUNCTION update_membros_historico_updated_at();

-- 6. VERIFICAR TABELA CRIADA
SELECT 
  column_name, 
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'membros_historico'
ORDER BY ordinal_position;

-- ================================================
-- OBSERVAÇÕES:
-- ================================================
-- Depois de criar a tabela, use a interface do sistema
-- para importar o CSV através da página de importação
-- ou use o comando COPY do PostgreSQL:
--
-- COPY membros_historico(
--   mov, cadastro, nome, nucleo, status, funcao,
--   classificacao, dia_sessao, ...
-- )
-- FROM '/caminho/para/membros_antigos.csv'
-- DELIMITER ';'
-- CSV HEADER;
-- ================================================
