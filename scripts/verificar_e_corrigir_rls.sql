-- ================================================
-- VERIFICAÇÃO E CORREÇÃO DAS POLÍTICAS RLS
-- ================================================
-- Execute este script para diagnosticar e corrigir problemas de acesso aos dados
-- ================================================

-- 1. VERIFICAR POLÍTICAS ATUAIS DA TABELA USUARIOS
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'usuarios'
ORDER BY policyname;

-- 2. VERIFICAR SE RLS ESTÁ HABILITADO
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables
WHERE tablename IN ('usuarios', 'membros', 'consultas', 'membros_historico');

-- 3. CONTAR REGISTROS NA TABELA (bypassa RLS quando executado como admin)
SELECT COUNT(*) as total_usuarios FROM usuarios;
SELECT COUNT(*) as total_membros FROM membros;

-- ================================================
-- SOLUÇÃO TEMPORÁRIA PARA DESENVOLVIMENTO
-- ================================================
-- DESABILITA RLS TEMPORARIAMENTE (APENAS PARA DESENVOLVIMENTO!)
-- ⚠️ NÃO USE EM PRODUÇÃO ⚠️

-- Desabilitar RLS nas tabelas principais
ALTER TABLE usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE membros DISABLE ROW LEVEL SECURITY;
ALTER TABLE consultas DISABLE ROW LEVEL SECURITY;
ALTER TABLE membros_historico DISABLE ROW LEVEL SECURITY;
ALTER TABLE calendario_2026 DISABLE ROW LEVEL SECURITY;
ALTER TABLE hist_cursos DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_tarefas DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_acoes_sociais DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_trabalhos_espirituais DISABLE ROW LEVEL SECURITY;

-- Mensagem de sucesso
SELECT 'RLS DESABILITADO - Todas as tabelas agora são acessíveis publicamente' as status;
SELECT 'ATENÇÃO: Reabilite o RLS antes de colocar em produção!' as aviso;
