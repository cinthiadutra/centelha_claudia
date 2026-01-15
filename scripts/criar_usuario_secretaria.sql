-- ============================================================================
-- CRIAR USUÁRIO SECRETARIA NO SISTEMA
-- ============================================================================
-- Este script cria o usuário da secretaria com nível de permissão 2
-- Email: secretaria.ccu@centelha.org
-- Username: secretaria
-- Senha: ExuReiSec
-- ============================================================================

-- Primeiro, adicionar coluna username se não existir
ALTER TABLE public.usuarios_sistema 
ADD COLUMN IF NOT EXISTS username VARCHAR(50) UNIQUE;

COMMENT ON COLUMN public.usuarios_sistema.username IS 'Nome de usuário para login (alternativa ao email)';

-- Criar índice para username
CREATE INDEX IF NOT EXISTS idx_usuarios_sistema_username 
ON public.usuarios_sistema(username);

-- Primeiro, criar o usuário no Supabase Auth (execute no Supabase Dashboard)
-- Authentication > Users > Add User
-- Email: secretaria.ccu@centelha.org
-- Password: ExuReiSec
-- Confirm Password: ExuReiSec
-- Auto Confirm User: YES

-- Depois, inserir o registro na tabela usuarios_sistema
-- IMPORTANTE: O hash da senha será gerado pelo sistema no primeiro login
-- Por enquanto, deixamos senha_hash como NULL pois usamos Supabase Auth

INSERT INTO public.usuarios_sistema (
    numero_cadastro,
    nome,
    username,
    email,
    senha_hash,
    nivel_permissao,
    ativo,
    created_at,
    updated_at
) VALUES (
    NULL, -- Não tem número de cadastro (usuário administrativo)
    'Secretaria CCU',
    'secretaria',
    'secretaria.ccu@centelha.org',
    NULL, -- Senha gerenciada pelo Supabase Auth
    2, -- Nível de permissão 2 (Secretaria)
    true,
    NOW(),
    NOW()
)
ON CONFLICT (email) 
DO UPDATE SET
    nome = EXCLUDED.nome,
    username = EXCLUDED.username,
    nivel_permissao = EXCLUDED.nivel_permissao,
    ativo = EXCLUDED.ativo,
    updated_at = NOW();

-- ============================================================================
-- VERIFICAR CRIAÇÃO
-- ============================================================================

-- Ver usuário criado
SELECT 
    id,
    numero_cadastro,
    nome,
    email,
    nivel_permissao,
    ativo,
    created_at
FROM public.usuarios_sistema
WHERE email = 'secretaria.ccu@centelha.org';

-- ============================================================================
-- NÍVEIS DE PERMISSÃO DO SISTEMA
-- ============================================================================
-- Nível 1: Visualização apenas (leitura)
-- Nível 2: Secretaria (leitura + escrita em cadastros e membros)
-- Nível 3: Coordenação (todas operações exceto configurações críticas)
-- Nível 4: Administrador (acesso total ao sistema)
-- ============================================================================

-- ============================================================================
-- INSTRUÇÕES PARA CRIAR NO SUPABASE AUTH
-- ============================================================================
-- 1. Acesse o Supabase Dashboard
-- 2. Vá em: Authentication > Users
-- 3. Clique em "Add User" (+ New User)
-- 4. Preencha:
--    - Email: secretaria.ccu@centelha.org
--    - Password: ExuReiSec
--    - Confirm Password: ExuReiSec
--    - Auto Confirm User: MARQUE esta opção (importante!)
-- 5. Clique em "Create User"
-- 6. Execute este script SQL acima para criar o registro em usuarios_sistema
-- ============================================================================

-- ============================================================================
-- ALTERNATIVA: CRIAR VIA SQL (pode não funcionar em todos os planos)
-- ============================================================================
-- Se você tem acesso à tabela auth.users, pode tentar:

/*
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at
)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    'secretaria.ccu@centelha.org',
    crypt('ExuReiSec', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW()
);
*/

-- NOTA: A criação via SQL na tabela auth.users pode não funcionar
-- dependendo das configurações do seu plano Supabase.
-- O método recomendado é criar pelo Dashboard.
