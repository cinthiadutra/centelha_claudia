-- ================================================
-- CENTELHA - RLS COM LEITURA PÚBLICA
-- ================================================
-- Permite leitura pública (anônima) de dados
-- Requer autenticação apenas para escrita/modificação
-- ================================================

-- REMOVER POLÍTICAS ANTIGAS SE EXISTIREM
DROP POLICY IF EXISTS "usuarios_all" ON usuarios;
DROP POLICY IF EXISTS "membros_all" ON membros;
DROP POLICY IF EXISTS "consultas_all" ON consultas;
DROP POLICY IF EXISTS "grupos_tarefas_all" ON grupos_tarefas;
DROP POLICY IF EXISTS "grupos_acoes_all" ON grupos_acoes_sociais;
DROP POLICY IF EXISTS "grupos_trabalhos_all" ON grupos_trabalhos_espirituais;
DROP POLICY IF EXISTS "batismos_all" ON batismos;
DROP POLICY IF EXISTS "casamentos_all" ON casamentos;
DROP POLICY IF EXISTS "jogos_orixa_all" ON jogos_orixa;
DROP POLICY IF EXISTS "camarinhas_all" ON camarinhas;
DROP POLICY IF EXISTS "coroacao_all" ON coroacao_sacerdotal;
DROP POLICY IF EXISTS "cursos_all" ON cursos;
DROP POLICY IF EXISTS "inscricoes_all" ON inscricoes_cursos;
DROP POLICY IF EXISTS "usuarios_sistema_all" ON usuarios_sistema;
DROP POLICY IF EXISTS "organizacao_all" ON organizacao;
DROP POLICY IF EXISTS "membros_historico_all" ON membros_historico;
DROP POLICY IF EXISTS "calendario_2026_all" ON calendario_2026;
DROP POLICY IF EXISTS "hist_cursos_all" ON hist_cursos;

-- ================================================
-- USUÁRIOS - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "usuarios_read_public" ON usuarios 
  FOR SELECT USING (true);

CREATE POLICY "usuarios_write_auth" ON usuarios 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "usuarios_update_auth" ON usuarios 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "usuarios_delete_auth" ON usuarios 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- MEMBROS - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "membros_read_public" ON membros 
  FOR SELECT USING (true);

CREATE POLICY "membros_write_auth" ON membros 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "membros_update_auth" ON membros 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "membros_delete_auth" ON membros 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- MEMBROS_HISTORICO - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "membros_historico_read_public" ON membros_historico 
  FOR SELECT USING (true);

CREATE POLICY "membros_historico_write_auth" ON membros_historico 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "membros_historico_update_auth" ON membros_historico 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "membros_historico_delete_auth" ON membros_historico 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- CONSULTAS - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "consultas_read_public" ON consultas 
  FOR SELECT USING (true);

CREATE POLICY "consultas_write_auth" ON consultas 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "consultas_update_auth" ON consultas 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "consultas_delete_auth" ON consultas 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- CALENDÁRIO 2026 - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "calendario_2026_read_public" ON calendario_2026 
  FOR SELECT USING (true);

CREATE POLICY "calendario_2026_write_auth" ON calendario_2026 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "calendario_2026_update_auth" ON calendario_2026 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "calendario_2026_delete_auth" ON calendario_2026 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- GRUPOS
-- ================================================
CREATE POLICY "grupos_tarefas_read_public" ON grupos_tarefas 
  FOR SELECT USING (true);

CREATE POLICY "grupos_tarefas_write_auth" ON grupos_tarefas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "grupos_acoes_read_public" ON grupos_acoes_sociais 
  FOR SELECT USING (true);

CREATE POLICY "grupos_acoes_write_auth" ON grupos_acoes_sociais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "grupos_trabalhos_read_public" ON grupos_trabalhos_espirituais 
  FOR SELECT USING (true);

CREATE POLICY "grupos_trabalhos_write_auth" ON grupos_trabalhos_espirituais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS
-- ================================================
CREATE POLICY "batismos_read_public" ON batismos 
  FOR SELECT USING (true);

CREATE POLICY "batismos_write_auth" ON batismos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "casamentos_read_public" ON casamentos 
  FOR SELECT USING (true);

CREATE POLICY "casamentos_write_auth" ON casamentos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "jogos_orixa_read_public" ON jogos_orixa 
  FOR SELECT USING (true);

CREATE POLICY "jogos_orixa_write_auth" ON jogos_orixa 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "camarinhas_read_public" ON camarinhas 
  FOR SELECT USING (true);

CREATE POLICY "camarinhas_write_auth" ON camarinhas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "coroacao_read_public" ON coroacao_sacerdotal 
  FOR SELECT USING (true);

CREATE POLICY "coroacao_write_auth" ON coroacao_sacerdotal 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- CURSOS
-- ================================================
CREATE POLICY "cursos_read_public" ON cursos 
  FOR SELECT USING (true);

CREATE POLICY "cursos_write_auth" ON cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "hist_cursos_read_public" ON hist_cursos 
  FOR SELECT USING (true);

CREATE POLICY "hist_cursos_write_auth" ON hist_cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "inscricoes_read_public" ON inscricoes_cursos 
  FOR SELECT USING (true);

CREATE POLICY "inscricoes_write_auth" ON inscricoes_cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- USUARIOS_SISTEMA - Leitura pública, escrita admin
-- ================================================
CREATE POLICY "usuarios_sistema_read_public" ON usuarios_sistema 
  FOR SELECT USING (true);

CREATE POLICY "usuarios_sistema_write_auth" ON usuarios_sistema 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- ORGANIZAÇÃO - Leitura pública, escrita autenticada
-- ================================================
CREATE POLICY "organizacao_read_public" ON organizacao 
  FOR SELECT USING (true);

CREATE POLICY "organizacao_write_auth" ON organizacao 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
