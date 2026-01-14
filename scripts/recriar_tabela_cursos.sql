-- ================================================
-- RECRIAR TABELA CURSOS
-- ================================================
-- Execute este script no SQL Editor do Supabase

-- Recriar tabela de cursos
CREATE TABLE IF NOT EXISTS cursos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL UNIQUE,
  descricao TEXT,
  instrutor VARCHAR(255),
  instrutor_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  data_inicio DATE NOT NULL,
  data_fim DATE,
  local VARCHAR(255),
  carga_horaria INTEGER,
  vagas_disponiveis INTEGER,
  vagas_ocupadas INTEGER DEFAULT 0,
  vagas_restantes INTEGER,
  ativo BOOLEAN DEFAULT TRUE,
  lotado BOOLEAN DEFAULT FALSE,
  materiais_necessarios TEXT,
  prerequisitos TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Recriar índices
CREATE INDEX IF NOT EXISTS idx_cursos_titulo ON cursos(titulo);
CREATE INDEX IF NOT EXISTS idx_cursos_ativo ON cursos(ativo);

-- Recriar trigger de updated_at
CREATE TRIGGER update_cursos_updated_at 
BEFORE UPDATE ON cursos
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verificar
SELECT * FROM cursos;
