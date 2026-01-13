-- Script SQL para resetar senha no Supabase
-- Execute este script no SQL Editor do Supabase Dashboard

-- ⚠️ INSTRUÇÕES:
-- 1. Acesse o Supabase Dashboard
-- 2. Vá em "SQL Editor"
-- 3. Cole este script
-- 4. Substitua o email e a nova senha
-- 5. Execute

-- Resetar senha para um usuário específico
-- A senha será criptografada automaticamente pelo Supabase
UPDATE auth.users
SET 
  encrypted_password = crypt('NOVA_SENHA_AQUI', gen_salt('bf')),
  updated_at = NOW()
WHERE email = 'cinthiadutra@gmail.com';

-- Verificar se foi atualizado
SELECT 
  id,
  email,
  created_at,
  updated_at,
  last_sign_in_at
FROM auth.users
WHERE email = 'cinthiadutra@gmail.com';

-- ✅ Pronto! Agora você pode fazer login com:
-- Email: cinthiadutra@gmail.com
-- Senha: NOVA_SENHA_AQUI (a que você definiu acima)
