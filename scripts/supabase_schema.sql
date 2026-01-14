-- ================================================
-- CENTELHA - Schema do Banco de Dados Supabase
-- ================================================
-- Execute este script no SQL Editor do Supabase
-- Settings > SQL Editor > New Query > Cole e Execute
-- ================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================
-- 1. TABELA: USUARIOS (Cadastro base - 79 campos)
-- ================================================
CREATE TABLE IF NOT EXISTS usuarios (
  -- Identificação
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) UNIQUE NOT NULL,
  nome VARCHAR(255) NOT NULL,
  cpf VARCHAR(11) UNIQUE NOT NULL,
  
  -- Dados Pessoais
  data_nascimento DATE,
  telefone_fixo VARCHAR(20),
  telefone_celular VARCHAR(20),
  email VARCHAR(255),
  nome_responsavel VARCHAR(255),
  endereco TEXT,
  
  -- Dados de Cadastro e Núcleo
  nucleo_cadastro VARCHAR(100),
  data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  nucleo_pertence VARCHAR(100),
  status_atual VARCHAR(50),
  classificacao VARCHAR(50),
  dia_sessao VARCHAR(20),
  
  -- Dados de Batismo
  data_batismo DATE,
  medium_celebrante_batismo VARCHAR(255),
  guia_celebrante_batismo VARCHAR(255),
  padrinho_batismo VARCHAR(255),
  madrinha_batismo VARCHAR(255),
  
  -- 1º Casamento
  data_primeiro_casamento DATE,
  nome_primeiro_conjuge VARCHAR(255),
  medium_celebrante_primeiro_casamento VARCHAR(255),
  padrinho_primeiro_casamento VARCHAR(255),
  madrinha_primeiro_casamento VARCHAR(255),
  
  -- 2º Casamento
  data_segundo_casamento DATE,
  nome_segundo_conjuge VARCHAR(255),
  medium_celebrante_segundo_casamento VARCHAR(255),
  padrinho_segundo_casamento VARCHAR(255),
  madrinha_segundo_casamento VARCHAR(255),
  
  -- Contatos de Emergência
  primeiro_contato_emergencia VARCHAR(255),
  segundo_contato_emergencia VARCHAR(255),
  
  -- 1º Estágio
  inicio_primeiro_estagio DATE,
  desistencia_primeiro_estagio DATE,
  primeiro_rito_passagem DATE,
  data_primeiro_desligamento DATE,
  justificativa_primeiro_desligamento TEXT,
  
  -- 2º Estágio
  inicio_segundo_estagio DATE,
  desistencia_segundo_estagio DATE,
  segundo_rito_passagem DATE,
  data_segundo_desligamento DATE,
  justificativa_segundo_desligamento TEXT,
  
  -- 3º Estágio
  inicio_terceiro_estagio DATE,
  desistencia_terceiro_estagio DATE,
  terceiro_rito_passagem DATE,
  data_terceiro_desligamento DATE,
  justificativa_terceiro_desligamento TEXT,
  
  -- 4º Estágio
  inicio_quarto_estagio DATE,
  desistencia_quarto_estagio DATE,
  quarto_rito_passagem DATE,
  data_quarto_desligamento DATE,
  justificativa_quarto_desligamento TEXT,
  
  -- Dados de Orixá
  data_jogo_orixa DATE,
  primeiro_orixa VARCHAR(50),
  adjunto_primeiro_orixa VARCHAR(50),
  segundo_orixa VARCHAR(50),
  adjunto_segundo_orixa VARCHAR(50),
  terceiro_orixa VARCHAR(50),
  quarto_orixa VARCHAR(50),
  
  -- Dados de Sacerdote
  coroacao_sacerdote DATE,
  primeira_camarinha DATE,
  segunda_camarinha DATE,
  terceira_camarinha DATE,
  
  -- Atividades e Grupos
  atividade_espiritual VARCHAR(100),
  grupo_atividade_espiritual VARCHAR(100),
  grupo_tarefa VARCHAR(100),
  grupo_acao_social VARCHAR(100),
  cargo_lideranca VARCHAR(100),
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para otimização
CREATE INDEX idx_usuarios_cpf ON usuarios(cpf);
CREATE INDEX idx_usuarios_nome ON usuarios(nome);
CREATE INDEX idx_usuarios_numero_cadastro ON usuarios(numero_cadastro);
CREATE INDEX idx_usuarios_status ON usuarios(status_atual);

-- ================================================
-- 2. TABELA: MEMBROS
-- ================================================
CREATE TABLE IF NOT EXISTS membros (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  status VARCHAR(50),
  orixa_principal VARCHAR(50),
  data_iniciacao DATE,
  grau_espiritual VARCHAR(50),
  
  -- Campos adicionais de membro
  funcao_casa VARCHAR(100),
  tempo_casa INTEGER,
  observacoes TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_membros_cadastro ON membros(numero_cadastro);
CREATE INDEX idx_membros_status ON membros(status);

-- ================================================
-- 3. TABELA: CONSULTAS
-- ================================================
CREATE TABLE IF NOT EXISTS consultas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_consulta VARCHAR(10) UNIQUE NOT NULL,
  cadastro_consulente VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_consulente VARCHAR(255),
  data_consulta TIMESTAMP WITH TIME ZONE NOT NULL,
  tipo_consulta VARCHAR(50),
  descricao TEXT,
  atendente VARCHAR(255),
  atendente_nivel INTEGER,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_consultas_cadastro ON consultas(cadastro_consulente);
CREATE INDEX idx_consultas_data ON consultas(data_consulta);

-- ================================================
-- 4. TABELA: GRUPOS_TAREFAS
-- ================================================
CREATE TABLE IF NOT EXISTS grupos_tarefas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome VARCHAR(255),
  status VARCHAR(50),
  grupo_tarefa VARCHAR(100),
  funcao VARCHAR(100),
  data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_grupos_tarefas_cadastro ON grupos_tarefas(numero_cadastro);

-- ================================================
-- 5. TABELA: GRUPOS_ACOES_SOCIAIS
-- ================================================
CREATE TABLE IF NOT EXISTS grupos_acoes_sociais (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome VARCHAR(255),
  grupo_acao_social VARCHAR(100),
  funcao VARCHAR(100),
  data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_grupos_acoes_cadastro ON grupos_acoes_sociais(numero_cadastro);

-- ================================================
-- 6. TABELA: GRUPOS_TRABALHOS_ESPIRITUAIS
-- ================================================
CREATE TABLE IF NOT EXISTS grupos_trabalhos_espirituais (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome VARCHAR(255),
  atividade_espiritual VARCHAR(100),
  grupo_trabalho VARCHAR(100),
  funcao VARCHAR(100),
  data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_grupos_trabalhos_cadastro ON grupos_trabalhos_espirituais(numero_cadastro);

-- ================================================
-- 7. SACRAMENTOS
-- ================================================

-- 7.1 BATISMOS
CREATE TABLE IF NOT EXISTS batismos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_membro VARCHAR(255),
  data_batismo DATE NOT NULL,
  local_batismo VARCHAR(255),
  sacerdote_nome VARCHAR(255),
  sacerdote_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  rebatismo BOOLEAN DEFAULT FALSE,
  motivo_rebatismo TEXT,
  padrinho_nome VARCHAR(255),
  padrinho_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  madrinha_nome VARCHAR(255),
  madrinha_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7.2 CASAMENTOS
CREATE TABLE IF NOT EXISTS casamentos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro_noivo VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  numero_cadastro_noiva VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_noivo VARCHAR(255),
  nome_noiva VARCHAR(255),
  data_casamento DATE NOT NULL,
  local_casamento VARCHAR(255),
  sacerdote_nome VARCHAR(255),
  sacerdote_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  testemunha1_nome VARCHAR(255),
  testemunha1_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  testemunha2_nome VARCHAR(255),
  testemunha2_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7.3 JOGOS DE ORIXÁ
CREATE TABLE IF NOT EXISTS jogos_orixa (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_membro VARCHAR(255),
  data_jogo DATE NOT NULL,
  local_jogo VARCHAR(255),
  sacerdote_nome VARCHAR(255),
  sacerdote_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  orixa_principal VARCHAR(50),
  orixa_junto VARCHAR(50),
  qualidade_orixa VARCHAR(100),
  caminho_orixa VARCHAR(100),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7.4 CAMARINHAS
CREATE TABLE IF NOT EXISTS camarinhas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_membro VARCHAR(255),
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  local_camarinha VARCHAR(255),
  sacerdote_nome VARCHAR(255),
  sacerdote_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  tipo_obrigacao VARCHAR(50),
  orixa_homenageado VARCHAR(50),
  dias_duracao INTEGER,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7.5 COROAÇÃO SACERDOTAL
CREATE TABLE IF NOT EXISTS coroacao_sacerdotal (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_membro VARCHAR(255),
  data_coroacao DATE NOT NULL,
  local_coroacao VARCHAR(255),
  sacerdote_ordenador_nome VARCHAR(255),
  sacerdote_ordenador_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  cargo VARCHAR(100),
  orixa_consagrado VARCHAR(50),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ================================================
-- 8. CURSOS E TREINAMENTOS
-- ================================================

-- 8.1 CURSOS
CREATE TABLE IF NOT EXISTS cursos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
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

-- 8.2 INSCRIÇÕES EM CURSOS
CREATE TABLE IF NOT EXISTS inscricoes_cursos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  curso_id UUID REFERENCES cursos(id) ON DELETE CASCADE,
  curso_titulo VARCHAR(255),
  numero_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  nome_membro VARCHAR(255),
  data_inscricao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status_inscricao VARCHAR(50) DEFAULT 'Confirmada',
  frequencia DECIMAL(5,2),
  nota_final DECIMAL(5,2),
  certificado_emitido BOOLEAN DEFAULT FALSE,
  aprovado BOOLEAN,
  data_conclusao DATE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(curso_id, numero_cadastro)
);

CREATE INDEX idx_inscricoes_curso ON inscricoes_cursos(curso_id);
CREATE INDEX idx_inscricoes_cadastro ON inscricoes_cursos(numero_cadastro);

-- ================================================
-- 9. USUÁRIOS DO SISTEMA (Autenticação)
-- ================================================
CREATE TABLE IF NOT EXISTS usuarios_sistema (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  numero_cadastro VARCHAR(10) UNIQUE REFERENCES usuarios(numero_cadastro),
  nome VARCHAR(255),
  email VARCHAR(255) UNIQUE NOT NULL,
  senha_hash VARCHAR(255),
  nivel_permissao INTEGER CHECK (nivel_permissao IN (1, 2, 3, 4)),
  ativo BOOLEAN DEFAULT TRUE,
  ultimo_acesso TIMESTAMP WITH TIME ZONE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_usuarios_sistema_email ON usuarios_sistema(email);
CREATE INDEX idx_usuarios_sistema_cadastro ON usuarios_sistema(numero_cadastro);

-- ================================================
-- 10. ORGANIZAÇÃO (Registro único)
-- ================================================
CREATE TABLE IF NOT EXISTS organizacao (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18),
  endereco TEXT,
  cidade VARCHAR(100),
  estado VARCHAR(2),
  cep VARCHAR(10),
  telefone VARCHAR(20),
  email VARCHAR(255),
  site_web VARCHAR(255),
  
  -- Dirigentes
  presidente_nome VARCHAR(255),
  presidente_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  vicepresidente_nome VARCHAR(255),
  vicepresidente_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  secretario_nome VARCHAR(255),
  secretario_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  tesoureiro_nome VARCHAR(255),
  tesoureiro_cadastro VARCHAR(10) REFERENCES usuarios(numero_cadastro),
  
  data_fundacao DATE,
  data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Garantir registro único
CREATE UNIQUE INDEX idx_organizacao_single ON organizacao((1));

-- ================================================
-- TRIGGERS PARA UPDATED_AT
-- ================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger em todas as tabelas
CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_membros_updated_at BEFORE UPDATE ON membros
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_consultas_updated_at BEFORE UPDATE ON consultas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grupos_tarefas_updated_at BEFORE UPDATE ON grupos_tarefas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grupos_acoes_sociais_updated_at BEFORE UPDATE ON grupos_acoes_sociais
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grupos_trabalhos_espirituais_updated_at BEFORE UPDATE ON grupos_trabalhos_espirituais
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cursos_updated_at BEFORE UPDATE ON cursos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_inscricoes_cursos_updated_at BEFORE UPDATE ON inscricoes_cursos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usuarios_sistema_updated_at BEFORE UPDATE ON usuarios_sistema
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_organizacao_updated_at BEFORE UPDATE ON organizacao
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================
-- FUNÇÕES E TRIGGERS PERSONALIZADOS
-- ================================================

-- Função para gerar número de cadastro automaticamente
CREATE OR REPLACE FUNCTION generate_numero_cadastro()
RETURNS TRIGGER AS $$
DECLARE
  max_numero INTEGER;
BEGIN
  IF NEW.numero_cadastro IS NULL OR NEW.numero_cadastro = '' THEN
    SELECT COALESCE(MAX(CAST(numero_cadastro AS INTEGER)), 0) + 1
    INTO max_numero
    FROM usuarios
    WHERE numero_cadastro ~ '^\d+$';
    
    NEW.numero_cadastro := LPAD(max_numero::TEXT, 5, '0');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_numero_cadastro_trigger
BEFORE INSERT ON usuarios
FOR EACH ROW
EXECUTE FUNCTION generate_numero_cadastro();

-- Função para calcular dias de duração de camarinha
CREATE OR REPLACE FUNCTION calculate_dias_duracao()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.data_inicio IS NOT NULL AND NEW.data_fim IS NOT NULL THEN
    NEW.dias_duracao := NEW.data_fim - NEW.data_inicio;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_dias_duracao_trigger
BEFORE INSERT OR UPDATE ON camarinhas
FOR EACH ROW
EXECUTE FUNCTION calculate_dias_duracao();

-- Função para atualizar vagas restantes dos cursos
CREATE OR REPLACE FUNCTION update_vagas_curso()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE cursos
  SET 
    vagas_restantes = vagas_disponiveis - vagas_ocupadas,
    lotado = (vagas_ocupadas >= vagas_disponiveis)
  WHERE id = NEW.curso_id OR id = OLD.curso_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_vagas_curso_trigger
AFTER INSERT OR UPDATE OR DELETE ON inscricoes_cursos
FOR EACH ROW
EXECUTE FUNCTION update_vagas_curso();

-- ================================================
-- COMENTÁRIOS NAS TABELAS
-- ================================================

COMMENT ON TABLE usuarios IS 'Cadastro base com todos os dados pessoais e histórico';
COMMENT ON TABLE membros IS 'Dados específicos de membros da CENTELHA';
COMMENT ON TABLE consultas IS 'Histórico de consultas espirituais';
COMMENT ON TABLE grupos_tarefas IS 'Participação em grupos de tarefas';
COMMENT ON TABLE grupos_acoes_sociais IS 'Participação em grupos de ações sociais';
COMMENT ON TABLE grupos_trabalhos_espirituais IS 'Participação em grupos de trabalhos espirituais';
COMMENT ON TABLE cursos IS 'Cursos e treinamentos oferecidos';
COMMENT ON TABLE inscricoes_cursos IS 'Inscrições de membros em cursos';
COMMENT ON TABLE usuarios_sistema IS 'Usuários com acesso ao sistema (autenticação)';
COMMENT ON TABLE organizacao IS 'Dados da organização CENTELHA';

-- ================================================
-- DADOS INICIAIS (SEEDS)
-- ================================================

-- Inserir registro da organização
INSERT INTO organizacao (
  nome,
  cnpj,
  endereco,
  cidade,
  estado,
  email,
  data_fundacao
) VALUES (
  'CENTELHA - Centro Espírita',
  '00.000.000/0001-00',
  'Endereço a definir',
  'São Paulo',
  'SP',
  'contato@centelha.org',
  '2000-01-01'
) ON CONFLICT DO NOTHING;

-- ================================================
-- FIM DO SCHEMA
-- ================================================
-- Próximo passo: Configurar Row Level Security (RLS)
-- Ver arquivo: supabase_rls_policies.sql
-- ================================================
