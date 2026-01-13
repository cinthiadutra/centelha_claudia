-- ================================================
-- Criar tabela CADASTROS para importação do sistema antigo
-- ================================================
-- Execute este script no SQL Editor do Supabase
-- ================================================

-- Criar tabela cadastros
CREATE TABLE IF NOT EXISTS cadastros (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  cadastro_id INTEGER,
  nome VARCHAR(255) NOT NULL,
  nascimento TIMESTAMP,
  
  -- Documentos (JSONB)
  documentos JSONB DEFAULT '{}'::jsonb,
  
  -- Contato (JSONB)
  contato JSONB DEFAULT '{}'::jsonb,
  
  -- Endereço (JSONB)
  endereco JSONB DEFAULT '{}'::jsonb,
  
  -- Dados Religiosos (JSONB)
  religioso JSONB DEFAULT '{}'::jsonb,
  
  -- Metadados
  data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_cadastros_nome ON cadastros(nome);
CREATE INDEX IF NOT EXISTS idx_cadastros_cpf ON cadastros((documentos->>'cpf'));
CREATE INDEX IF NOT EXISTS idx_cadastros_data_cadastro ON cadastros(data_cadastro);

-- Habilitar RLS (Row Level Security)
ALTER TABLE cadastros ENABLE ROW LEVEL SECURITY;

-- Política: Permitir leitura para usuários autenticados
CREATE POLICY "Permitir leitura para usuários autenticados" 
ON cadastros FOR SELECT 
TO authenticated 
USING (true);

-- Política: Permitir inserção para usuários autenticados
CREATE POLICY "Permitir inserção para usuários autenticados" 
ON cadastros FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Política: Permitir atualização para usuários autenticados
CREATE POLICY "Permitir atualização para usuários autenticados" 
ON cadastros FOR UPDATE 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- Política: Permitir deleção para usuários autenticados
CREATE POLICY "Permitir deleção para usuários autenticados" 
ON cadastros FOR DELETE 
TO authenticated 
USING (true);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_cadastros_updated_at 
BEFORE UPDATE ON cadastros 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- Verificar tabela criada
SELECT 
  table_name, 
  column_name, 
  data_type 
FROM information_schema.columns 
WHERE table_name = 'cadastros'
ORDER BY ordinal_position;
