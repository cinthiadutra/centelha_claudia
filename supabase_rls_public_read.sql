-- ================================================
-- CENTELHA - RLS COM LEITURA PÚBLICA (SCRIPT CORRIGIDO)
-- Idempotente: remove policies existentes antes de criar
-- ================================================

-- ================================================
-- USUÁRIOS - Leitura pública, escrita autenticada
-- ================================================
ALTER TABLE IF EXISTS usuarios ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "usuarios_read_public" ON usuarios;
DROP POLICY IF EXISTS "usuarios_write_auth" ON usuarios;
DROP POLICY IF EXISTS "usuarios_update_auth" ON usuarios;
DROP POLICY IF EXISTS "usuarios_delete_auth" ON usuarios;

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
ALTER TABLE IF EXISTS membros ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "membros_read_public" ON membros;
DROP POLICY IF EXISTS "membros_write_auth" ON membros;
DROP POLICY IF EXISTS "membros_update_auth" ON membros;
DROP POLICY IF EXISTS "membros_delete_auth" ON membros;

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
ALTER TABLE IF EXISTS membros_historico ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "membros_historico_read_public" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_write_auth" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_update_auth" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_delete_auth" ON membros_historico;

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
ALTER TABLE IF EXISTS consultas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "consultas_read_public" ON consultas;
DROP POLICY IF EXISTS "consultas_write_auth" ON consultas;
DROP POLICY IF EXISTS "consultas_update_auth" ON consultas;
DROP POLICY IF EXISTS "consultas_delete_auth" ON consultas;

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
ALTER TABLE IF EXISTS calendario_2026 ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "calendario_2026_read_public" ON calendario_2026;
DROP POLICY IF EXISTS "calendario_2026_write_auth" ON calendario_2026;
DROP POLICY IF EXISTS "calendario_2026_update_auth" ON calendario_2026;
DROP POLICY IF EXISTS "calendario_2026_delete_auth" ON calendario_2026;

CREATE POLICY "calendario_2026_read_public" ON calendario_2026 
  FOR SELECT USING (true);

CREATE POLICY "calendario_2026_write_auth" ON calendario_2026 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "calendario_2026_update_auth" ON calendario_2026 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "calendario_2026_delete_auth" ON calendario_2026 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- GRUPOS - grupos_tarefas
-- ================================================
ALTER TABLE IF EXISTS grupos_tarefas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "grupos_tarefas_read_public" ON grupos_tarefas;
DROP POLICY IF EXISTS "grupos_tarefas_write_auth" ON grupos_tarefas;

CREATE POLICY "grupos_tarefas_read_public" ON grupos_tarefas 
  FOR SELECT USING (true);

CREATE POLICY "grupos_tarefas_write_auth" ON grupos_tarefas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- GRUPOS - grupos_acoes_sociais
-- ================================================
ALTER TABLE IF EXISTS grupos_acoes_sociais ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "grupos_acoes_read_public" ON grupos_acoes_sociais;
DROP POLICY IF EXISTS "grupos_acoes_write_auth" ON grupos_acoes_sociais;

CREATE POLICY "grupos_acoes_read_public" ON grupos_acoes_sociais 
  FOR SELECT USING (true);

CREATE POLICY "grupos_acoes_write_auth" ON grupos_acoes_sociais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- GRUPOS - grupos_trabalhos_espirituais
-- ================================================
ALTER TABLE IF EXISTS grupos_trabalhos_espirituais ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "grupos_trabalhos_read_public" ON grupos_trabalhos_espirituais;
DROP POLICY IF EXISTS "grupos_trabalhos_write_auth" ON grupos_trabalhos_espirituais;

CREATE POLICY "grupos_trabalhos_read_public" ON grupos_trabalhos_espirituais 
  FOR SELECT USING (true);

CREATE POLICY "grupos_trabalhos_write_auth" ON grupos_trabalhos_espirituais 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS - batismos
-- ================================================
ALTER TABLE IF EXISTS batismos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "batismos_read_public" ON batismos;
DROP POLICY IF EXISTS "batismos_write_auth" ON batismos;

CREATE POLICY "batismos_read_public" ON batismos 
  FOR SELECT USING (true);

CREATE POLICY "batismos_write_auth" ON batismos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS - casamentos
-- ================================================
ALTER TABLE IF EXISTS casamentos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "casamentos_read_public" ON casamentos;
DROP POLICY IF EXISTS "casamentos_write_auth" ON casamentos;

CREATE POLICY "casamentos_read_public" ON casamentos 
  FOR SELECT USING (true);

CREATE POLICY "casamentos_write_auth" ON casamentos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS - jogos_orixa
-- ================================================
ALTER TABLE IF EXISTS jogos_orixa ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "jogos_orixa_read_public" ON jogos_orixa;
DROP POLICY IF EXISTS "jogos_orixa_write_auth" ON jogos_orixa;

CREATE POLICY "jogos_orixa_read_public" ON jogos_orixa 
  FOR SELECT USING (true);

CREATE POLICY "jogos_orixa_write_auth" ON jogos_orixa 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS - camarinhas
-- ================================================
ALTER TABLE IF EXISTS camarinhas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "camarinhas_read_public" ON camarinhas;
DROP POLICY IF EXISTS "camarinhas_write_auth" ON camarinhas;

CREATE POLICY "camarinhas_read_public" ON camarinhas 
  FOR SELECT USING (true);

CREATE POLICY "camarinhas_write_auth" ON camarinhas 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- SACRAMENTOS - coroacao_sacerdotal
-- ================================================
ALTER TABLE IF EXISTS coroacao_sacerdotal ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "coroacao_read_public" ON coroacao_sacerdotal;
DROP POLICY IF EXISTS "coroacao_write_auth" ON coroacao_sacerdotal;

CREATE POLICY "coroacao_read_public" ON coroacao_sacerdotal 
  FOR SELECT USING (true);

CREATE POLICY "coroacao_write_auth" ON coroacao_sacerdotal 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- CURSOS - cursos / historico / inscricoes_cursos
-- ================================================
ALTER TABLE IF EXISTS cursos ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS historico ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS inscricoes_cursos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "cursos_read_public" ON cursos;
DROP POLICY IF EXISTS "cursos_write_auth" ON cursos;

CREATE POLICY "cursos_read_public" ON cursos 
  FOR SELECT USING (true);

CREATE POLICY "cursos_write_auth" ON cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "historicor_read_public" ON historico;
DROP POLICY IF EXISTS "historico_write_auth" ON historico;

CREATE POLICY "historicor_read_public" ON historico 
  FOR SELECT USING (true);

CREATE POLICY "historico_write_auth" ON historico 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "inscricoes_read_public" ON inscricoes_cursos;
DROP POLICY IF EXISTS "inscricoes_write_auth" ON inscricoes_cursos;

CREATE POLICY "inscricoes_read_public" ON inscricoes_cursos 
  FOR SELECT USING (true);

CREATE POLICY "inscricoes_write_auth" ON inscricoes_cursos 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- USUARIOS_SISTEMA - Leitura pública, escrita admin
-- ================================================
ALTER TABLE IF EXISTS usuarios_sistema ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "usuarios_sistema_read_public" ON usuarios_sistema;
DROP POLICY IF EXISTS "usuarios_sistema_write_auth" ON usuarios_sistema;

CREATE POLICY "usuarios_sistema_read_public" ON usuarios_sistema 
  FOR SELECT USING (true);

CREATE POLICY "usuarios_sistema_write_auth" ON usuarios_sistema 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- ORGANIZAÇÃO - Leitura pública, escrita autenticada
-- ================================================
ALTER TABLE IF EXISTS organizacao ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "organizacao_read_public" ON organizacao;
DROP POLICY IF EXISTS "organizacao_write_auth" ON organizacao;

CREATE POLICY "organizacao_read_public" ON organizacao 
  FOR SELECT USING (true);

CREATE POLICY "organizacao_write_auth" ON organizacao 
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- FIM DO SCRIPT
-- ================================================