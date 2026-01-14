-- ================================================
-- CENTELHA - Row Level Security (RLS) Policies
-- ================================================
-- Execute este script APÓS executar o supabase_schema.sql
-- Este arquivo configura as políticas de segurança
-- ================================================

-- ================================================
-- HABILITAR RLS EM TODAS AS TABELAS
-- ================================================

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
-- FUNÇÕES AUXILIARES PARA VERIFICAÇÃO DE PERMISSÕES
-- ================================================
-- NOTA: Criadas no schema public pois auth é protegido

-- Função para obter o nível de permissão do usuário atual
CREATE OR REPLACE FUNCTION public.get_user_nivel_permissao()
RETURNS INTEGER AS $$
  SELECT COALESCE(nivel_permissao, 0)
  FROM usuarios_sistema
  WHERE email = auth.jwt()->>'email'
  LIMIT 1;
$$ LANGUAGE SQL SECURITY DEFINER;

-- Função para obter o número de cadastro do usuário atual
CREATE OR REPLACE FUNCTION public.get_user_numero_cadastro()
RETURNS VARCHAR AS $$
  SELECT numero_cadastro
  FROM usuarios_sistema
  WHERE email = auth.jwt()->>'email'
  LIMIT 1;
$$ LANGUAGE SQL SECURITY DEFINER;

-- ================================================
-- POLÍTICAS PARA USUARIOS
-- ================================================

-- Nível 1: Ver apenas próprios dados
CREATE POLICY "usuarios_nivel1_select"
  ON usuarios FOR SELECT
  TO authenticated
  USING (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 2
  );

-- Nível 1: Atualizar apenas próprios dados
CREATE POLICY "usuarios_nivel1_update"
  ON usuarios FOR UPDATE
  TO authenticated
  USING (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 2
  );

-- Nível 2+: Inserir novos usuários
CREATE POLICY "usuarios_nivel2_insert"
  ON usuarios FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

-- Nível 2+: Deletar usuários
CREATE POLICY "usuarios_nivel2_delete"
  ON usuarios FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

-- ================================================
-- POLÍTICAS PARA MEMBROS
-- ================================================

CREATE POLICY "membros_select"
  ON membros FOR SELECT
  TO authenticated
  USING (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 3
  );

CREATE POLICY "membros_insert"
  ON membros FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "membros_update"
  ON membros FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "membros_delete"
  ON membros FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

-- ================================================
-- POLÍTICAS PARA CONSULTAS
-- ================================================

CREATE POLICY "consultas_select"
  ON consultas FOR SELECT
  TO authenticated
  USING (
    cadastro_consulente = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 3
  );

CREATE POLICY "consultas_insert"
  ON consultas FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "consultas_update"
  ON consultas FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "consultas_delete"
  ON consultas FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

-- ================================================
-- POLÍTICAS PARA GRUPOS (TAREFAS, AÇÕES, TRABALHOS)
-- ================================================

-- Grupos Tarefas
CREATE POLICY "grupos_tarefas_select"
  ON grupos_tarefas FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "grupos_tarefas_insert"
  ON grupos_tarefas FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_tarefas_update"
  ON grupos_tarefas FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_tarefas_delete"
  ON grupos_tarefas FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

-- Grupos Ações Sociais
CREATE POLICY "grupos_acoes_select"
  ON grupos_acoes_sociais FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "grupos_acoes_insert"
  ON grupos_acoes_sociais FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_acoes_update"
  ON grupos_acoes_sociais FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_acoes_delete"
  ON grupos_acoes_sociais FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

-- Grupos Trabalhos Espirituais
CREATE POLICY "grupos_trabalhos_select"
  ON grupos_trabalhos_espirituais FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "grupos_trabalhos_insert"
  ON grupos_trabalhos_espirituais FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_trabalhos_update"
  ON grupos_trabalhos_espirituais FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "grupos_trabalhos_delete"
  ON grupos_trabalhos_espirituais FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

-- ================================================
-- POLÍTICAS PARA SACRAMENTOS
-- ================================================

-- Batismos
CREATE POLICY "batismos_select"
  ON batismos FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "batismos_insert"
  ON batismos FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "batismos_update"
  ON batismos FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "batismos_delete"
  ON batismos FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- Casamentos
CREATE POLICY "casamentos_select"
  ON casamentos FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "casamentos_insert"
  ON casamentos FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "casamentos_update"
  ON casamentos FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "casamentos_delete"
  ON casamentos FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- Jogos de Orixá
CREATE POLICY "jogos_orixa_select"
  ON jogos_orixa FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "jogos_orixa_insert"
  ON jogos_orixa FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "jogos_orixa_update"
  ON jogos_orixa FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "jogos_orixa_delete"
  ON jogos_orixa FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- Camarinhas
CREATE POLICY "camarinhas_select"
  ON camarinhas FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "camarinhas_insert"
  ON camarinhas FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "camarinhas_update"
  ON camarinhas FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "camarinhas_delete"
  ON camarinhas FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- Coroação Sacerdotal
CREATE POLICY "coroacao_select"
  ON coroacao_sacerdotal FOR SELECT
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 1);

CREATE POLICY "coroacao_insert"
  ON coroacao_sacerdotal FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 4);

CREATE POLICY "coroacao_update"
  ON coroacao_sacerdotal FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

CREATE POLICY "coroacao_delete"
  ON coroacao_sacerdotal FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- ================================================
-- POLÍTICAS PARA CURSOS
-- ================================================

-- Todos podem ver cursos ativos
CREATE POLICY "cursos_select"
  ON cursos FOR SELECT
  TO authenticated
  USING (ativo = TRUE OR public.get_user_nivel_permissao() >= 2);

CREATE POLICY "cursos_insert"
  ON cursos FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "cursos_update"
  ON cursos FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

CREATE POLICY "cursos_delete"
  ON cursos FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 3);

-- Inscrições em Cursos
CREATE POLICY "inscricoes_select"
  ON inscricoes_cursos FOR SELECT
  TO authenticated
  USING (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 2
  );

CREATE POLICY "inscricoes_insert"
  ON inscricoes_cursos FOR INSERT
  TO authenticated
  WITH CHECK (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 2
  );

CREATE POLICY "inscricoes_update"
  ON inscricoes_cursos FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 2);

CREATE POLICY "inscricoes_delete"
  ON inscricoes_cursos FOR DELETE
  TO authenticated
  USING (
    numero_cadastro = public.get_user_numero_cadastro()
    OR public.get_user_nivel_permissao() >= 2
  );

-- ================================================
-- POLÍTICAS PARA USUARIOS_SISTEMA
-- ================================================

-- Ver apenas próprio usuário ou se for admin
CREATE POLICY "usuarios_sistema_select"
  ON usuarios_sistema FOR SELECT
  TO authenticated
  USING (
    email = auth.jwt()->>'email'
    OR public.get_user_nivel_permissao() >= 4
  );

-- Apenas admin pode criar usuários do sistema
CREATE POLICY "usuarios_sistema_insert"
  ON usuarios_sistema FOR INSERT
  TO authenticated
  WITH CHECK (public.get_user_nivel_permissao() >= 4);

-- Admin atualiza qualquer, usuário atualiza próprio
CREATE POLICY "usuarios_sistema_update"
  ON usuarios_sistema FOR UPDATE
  TO authenticated
  USING (
    email = auth.jwt()->>'email'
    OR public.get_user_nivel_permissao() >= 4
  );

-- Apenas admin pode deletar
CREATE POLICY "usuarios_sistema_delete"
  ON usuarios_sistema FOR DELETE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- ================================================
-- POLÍTICAS PARA ORGANIZAÇÃO
-- ================================================

-- Todos autenticados podem ver
CREATE POLICY "organizacao_select"
  ON organizacao FOR SELECT
  TO authenticated
  USING (TRUE);

-- Apenas admin pode atualizar
CREATE POLICY "organizacao_update"
  ON organizacao FOR UPDATE
  TO authenticated
  USING (public.get_user_nivel_permissao() >= 4);

-- ================================================
-- POLÍTICAS DE ACESSO ANÔNIMO (para login)
-- ================================================

-- Permitir verificação de email para login (sem RLS)
-- Isso será tratado via Supabase Auth, não precisa de política

-- ================================================
-- RESUMO DOS NÍVEIS DE PERMISSÃO
-- ================================================

/*
  NÍVEL 1 - Membro Regular:
    - Ver próprios dados
    - Ver dados públicos (grupos, cursos ativos, sacramentos)
    - Atualizar próprios dados básicos
    - Fazer inscrições em cursos

  NÍVEL 2 - Secretaria:
    - Tudo do nível 1
    - CRUD completo em usuários
    - CRUD em grupos
    - CRUD em consultas
    - Gerenciar inscrições em cursos

  NÍVEL 3 - Líderes Espirituais:
    - Tudo do nível 2
    - CRUD em sacramentos (exceto coroação)
    - Criar e gerenciar cursos
    - Ver relatórios completos

  NÍVEL 4 - Administrador:
    - Acesso total a tudo
    - Gerenciar usuários do sistema
    - Gerenciar dados da organização
    - Realizar coroações sacerdotais
    - Deletar qualquer registro
*/

-- ================================================
-- FIM DAS POLÍTICAS RLS
-- ================================================
