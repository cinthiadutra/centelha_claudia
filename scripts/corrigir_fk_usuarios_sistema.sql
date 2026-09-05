-- Corrige a FK antiga de usuarios_sistema.
-- O numero_cadastro usado pelo sistema vem de membros_historico.cadastro,
-- que representa um historico e nao deve ser usado como alvo de FK.
-- Execute no SQL Editor do Supabase.

ALTER TABLE IF EXISTS public.usuarios_sistema
  DROP CONSTRAINT IF EXISTS usuarios_sistema_numero_cadastro_fkey;

COMMENT ON COLUMN public.usuarios_sistema.numero_cadastro IS
  'Cadastro do membro em membros_historico.cadastro; validado pela aplicacao';
