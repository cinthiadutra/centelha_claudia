-- ================================================
-- SCRIPT PARA IMPORTAR CURSOS E HISTÓRICO
-- ================================================
-- Execute este script no SQL Editor do Supabase

-- ================================================
-- PASSO 1: INSERIR CURSOS
-- ================================================

-- Limpar tabela de cursos (opcional - comente se não quiser deletar)
-- DELETE FROM inscricoes_cursos;
-- DELETE FROM cursos;

-- Inserir cursos do CSV CURSOS.csv
INSERT INTO cursos (titulo, descricao, prerequisitos, ativo, data_inicio, data_fim) VALUES
('CURSO DE INGLÊS BÁSICO 1 - MÓDULO 2', 'Código: ING1.2 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', 'ING1.1', true, '2024-01-01', NULL),
('CURSO DE LIBRAS', 'Código: LIB | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('ARTESANATO', 'Código: ART2 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('COSTURA CRIATIVA', 'Código: ART1 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('CURSO DE TAREFEIRO', 'Código: TAR1 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('CURSO DE INGLÊS BÁSICO 1 - MÓDULO 1', 'Código: ING1.1 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('CURSO DE RESSUSCITAÇÃO CÁRDIO-PULMONAR EM ADULTO', 'Código: RCP | PRESENCIAL | SOMENTE MEMBROS DA CENTELHA', 'INT', true, '2024-01-01', NULL),
('CURSO DE INTEGRAÇÃO', 'Código: INT | PRESENCIAL | SOMENTE MEMBROS DA CENTELHA', NULL, true, '2024-01-01', NULL),
('CURSO DE CAMBONAGEM', 'Código: CAM | PRESENCIAL | SOMENTE MEMBROS DA CENTELHA', 'INT', true, '2024-01-01', NULL),
('CURSO BÁSICO DE UMBANDA - NÍVEL 1', 'Código: CBU1 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('CURSO BÁSICO DE UMBANDA - NÍVEL 2', 'Código: CBU2 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', 'CBU1', true, '2024-01-01', NULL),
('CURSO BÁSICO DE UMBANDA - NÍVEL 3', 'Código: CBU3 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', 'CBU2', true, '2024-01-01', NULL),
('TREINAMENTO PARA ATEND. FRATERNO - GRAUS AMARELO E VERDE', 'Código: TAF | PRESENCIAL | SOMENTE MEMBROS DA CENTELHA', NULL, true, '2024-01-01', NULL),
('PRÁTICAS TERAPÊUTICAS ESPIR. - GRAUS ROSA, VERMELHO E CORAL', 'Código: PTE | PRESENCIAL | SOMENTE MEMBROS DA CENTELHA', NULL, true, '2024-01-01', NULL),
('CURSO PRÁTICO DE TAROT CABALÍSTICO', 'Código: TAR1 | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL),
('CURSO BÁSICO DE FORMAÇÃO DE CURIMBEIRO DE UMBANDA', 'Código: CUR | PRESENCIAL | TODOS (MEMBROS E NÃO MEMBROS DA CENTELHA)', NULL, true, '2024-01-01', NULL);

-- ================================================
-- PASSO 2: VERIFICAR CURSOS INSERIDOS
-- ================================================
SELECT id, titulo FROM cursos ORDER BY titulo;

-- ================================================
-- PASSO 3: CRIAR TABELA TEMPORÁRIA PARA HISTÓRICO
-- ================================================
-- Use o Supabase Dashboard para importar o CSV HIST_CURSOS.csv
-- 1. Vá em Table Editor
-- 2. Crie uma tabela temporária: hist_cursos_temp
-- 3. Use "Import data from CSV"
-- 4. Após importar, execute o script abaixo

-- Ou crie a tabela manualmente:
CREATE TABLE IF NOT EXISTS hist_cursos_temp (
  cadastro VARCHAR(10),
  nome TEXT,
  curso_treinamento TEXT,
  tipo_curso TEXT,
  turma TEXT,
  data_curso TEXT,
  status TEXT,
  certificado TEXT,
  cod_curso TEXT,
  nota1 TEXT,
  nota2 TEXT,
  nota_final TEXT
);

-- ================================================
-- PASSO 4: IMPORTAR HISTÓRICO
-- ================================================
-- Após importar o CSV na tabela temporária, execute:

INSERT INTO inscricoes_cursos (
  curso_id,
  curso_titulo,
  numero_cadastro,
  nome_membro,
  data_inscricao,
  status_inscricao,
  nota_final,
  certificado_emitido,
  aprovado,
  data_conclusao
)
SELECT 
  c.id as curso_id,
  h.curso_treinamento as curso_titulo,
  h.cadastro as numero_cadastro,
  h.nome as nome_membro,
  CASE 
    WHEN h.data_curso ~ '^\d{1,2}/\d{1,2}/\d{2}$' THEN
      TO_TIMESTAMP(h.data_curso, 'MM/DD/YY')
    ELSE
      NOW()
  END as data_inscricao,
  CASE 
    WHEN UPPER(h.status) = 'APROVADO' THEN 'Concluído'
    WHEN UPPER(h.status) = 'CURSANDO' THEN 'Em andamento'
    WHEN UPPER(h.status) = 'DESISTIU' THEN 'Desistente'
    ELSE h.status
  END as status_inscricao,
  CASE 
    WHEN h.nota_final ~ '^\d+\.?\d*$' THEN h.nota_final::DECIMAL
    ELSE NULL
  END as nota_final,
  CASE 
    WHEN h.certificado IS NOT NULL AND h.certificado != '' AND h.certificado != 'SEM CERTIFICADO' 
    THEN true
    ELSE false
  END as certificado_emitido,
  CASE 
    WHEN UPPER(h.status) = 'APROVADO' THEN true
    WHEN UPPER(h.status) = 'DESISTIU' THEN false
    ELSE NULL
  END as aprovado,
  CASE 
    WHEN UPPER(h.status) = 'APROVADO' AND h.data_curso ~ '^\d{1,2}/\d{1,2}/\d{2}$' THEN
      TO_TIMESTAMP(h.data_curso, 'MM/DD/YY')::DATE
    ELSE NULL
  END as data_conclusao
FROM hist_cursos_temp h
LEFT JOIN cursos c ON UPPER(TRIM(c.titulo)) = UPPER(TRIM(h.curso_treinamento))
WHERE h.cadastro IS NOT NULL AND h.cadastro != ''
ON CONFLICT (curso_id, numero_cadastro) DO NOTHING;

-- ================================================
-- PASSO 5: VERIFICAR IMPORTAÇÃO
-- ================================================

-- Ver total de inscrições importadas
SELECT COUNT(*) as total_inscricoes FROM inscricoes_cursos;

-- Ver inscrições por curso
SELECT 
  c.titulo,
  COUNT(i.id) as total_inscricoes,
  SUM(CASE WHEN i.aprovado = true THEN 1 ELSE 0 END) as aprovados,
  SUM(CASE WHEN i.status_inscricao = 'Em andamento' THEN 1 ELSE 0 END) as cursando
FROM cursos c
LEFT JOIN inscricoes_cursos i ON c.id = i.curso_id
GROUP BY c.titulo
ORDER BY total_inscricoes DESC;

-- Ver cadastros que não têm correspondência na tabela usuarios
SELECT DISTINCT h.cadastro, h.nome
FROM hist_cursos_temp h
WHERE NOT EXISTS (
  SELECT 1 FROM usuarios u WHERE u.numero_cadastro = h.cadastro
)
AND h.cadastro IS NOT NULL AND h.cadastro != ''
ORDER BY h.cadastro;

-- ================================================
-- PASSO 6: LIMPAR TABELA TEMPORÁRIA (OPCIONAL)
-- ================================================
-- DROP TABLE IF EXISTS hist_cursos_temp;
