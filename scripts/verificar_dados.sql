-- ================================================
-- SCRIPT DE VERIFICAÇÃO DE DADOS
-- ================================================
-- Execute no SQL Editor do Supabase para verificar
-- se os dados estão nas tabelas
-- ================================================

-- 1. VERIFICAR USUÁRIOS
SELECT COUNT(*) as total_usuarios FROM usuarios;
SELECT * FROM usuarios LIMIT 5;

-- 2. VERIFICAR MEMBROS HISTÓRICO
SELECT COUNT(*) as total_membros FROM membros_historico;
SELECT cadastro, nome, nucleo, status FROM membros_historico LIMIT 10;

-- 3. VERIFICAR POLÍTICAS RLS
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('usuarios', 'membros_historico')
ORDER BY tablename, policyname;

-- 4. VERIFICAR SE USUÁRIO 678 EXISTE
SELECT * FROM usuarios WHERE id = '678' OR nome ILIKE '%678%';

-- 5. VERIFICAR SE MEMBRO 678 EXISTE
SELECT * FROM membros_historico WHERE cadastro = '678' OR nome ILIKE '%678%';

-- 6. VERIFICAR AUTENTICAÇÃO
SELECT email, created_at, last_sign_in_at 
FROM auth.users 
ORDER BY created_at DESC;
