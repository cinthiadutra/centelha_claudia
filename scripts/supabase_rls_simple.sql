-- ================================================
-- CENTELHA - RLS SIMPLIFICADO (Sem Funções Custom)
-- ================================================
-- Use este arquivo SE o supabase_rls_policies.sql der erro
-- Esta é uma versão mais permissiva para desenvolvimento
-- ================================================

-- HABILITAR RLS EM TODAS AS TABELAS
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE membros ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultas ENABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_tarefas ENABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_acoes_sociais ENABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_trabalhos_espirituais ENABLE ROW LEVEL SECURITY;
ALTER TABLE batismos ENABLE ROW LEVEL SECURITY;
ALTER TABLE casamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE jogos_orixa ENABLE ROW LEVEL SECURITY;
ALTER TABLE camarinhas ENABLE ROW LEVEL SECURITY;
ALTER TABLE coroacao_sacerdotal ENABLE ROW LEVEL SECURITY;
ALTER TABLE cursos ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscricoes_cursos ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE organizacao ENABLE ROW LEVEL SECURITY;

-- ================================================
-- POLÍTICAS SIMPLIFICADAS
-- Todos os usuários autenticados têm acesso completo
-- (APENAS PARA DESENVOLVIMENTO - AJUSTAR PARA PRODUÇÃO)
-- ================================================

-- USUARIOS
CREATE POLICY "usuarios_all" ON usuarios 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- MEMBROS
CREATE POLICY "membros_all" ON membros 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- CONSULTAS
CREATE POLICY "consultas_all" ON consultas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- GRUPOS
CREATE POLICY "grupos_tarefas_all" ON grupos_tarefas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "grupos_acoes_all" ON grupos_acoes_sociais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "grupos_trabalhos_all" ON grupos_trabalhos_espirituais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- SACRAMENTOS
CREATE POLICY "batismos_all" ON batismos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "casamentos_all" ON casamentos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "jogos_orixa_all" ON jogos_orixa 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "camarinhas_all" ON camarinhas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "coroacao_all" ON coroacao_sacerdotal 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- CURSOS
CREATE POLICY "cursos_all" ON cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "inscricoes_all" ON inscricoes_cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- USUARIOS SISTEMA
CREATE POLICY "usuarios_sistema_all" ON usuarios_sistema 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ORGANIZAÇÃO
CREATE POLICY "organizacao_all" ON organizacao 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- IMPORTANTE: DESENVOLVIMENTO APENAS!
-- ================================================
-- ⚠️ Estas políticas permitem acesso total a todos
-- ⚠️ Use apenas em desenvolvimento
-- ⚠️ Para produção, use supabase_rls_policies.sql
-- ================================================
