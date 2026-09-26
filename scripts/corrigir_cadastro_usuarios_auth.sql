-- Execute in the Supabase SQL Editor before deploying admin-create-user.
-- Supabase Auth is the sole credential store; the profile table has no password.

ALTER TABLE public.usuarios_sistema
  ADD COLUMN IF NOT EXISTS username varchar(50),
  ADD COLUMN IF NOT EXISTS observacoes text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.usuarios_sistema
    WHERE username IS NOT NULL AND btrim(username) <> ''
    GROUP BY lower(btrim(username))
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION
      'Existem usernames duplicados ignorando maiúsculas/minúsculas; corrija-os antes da migration.';
  END IF;
END;
$$;

UPDATE public.usuarios_sistema
SET username = lower(btrim(username))
WHERE username IS NOT NULL AND username <> lower(btrim(username));

CREATE UNIQUE INDEX IF NOT EXISTS idx_usuarios_sistema_username_lower_unique
  ON public.usuarios_sistema (lower(btrim(username)))
  WHERE username IS NOT NULL AND btrim(username) <> '';

UPDATE public.usuarios_sistema
SET senha_hash = NULL
WHERE senha_hash IS NOT NULL;

CREATE OR REPLACE FUNCTION public.get_user_nivel_permissao()
RETURNS integer
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT COALESCE(us.nivel_permissao, 0)
  FROM public.usuarios_sistema AS us
  WHERE lower(us.email) = lower(auth.jwt() ->> 'email')
    AND COALESCE(us.ativo, false)
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.get_user_numero_cadastro()
RETURNS varchar
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT us.numero_cadastro
  FROM public.usuarios_sistema AS us
  WHERE lower(us.email) = lower(auth.jwt() ->> 'email')
    AND COALESCE(us.ativo, false)
  LIMIT 1;
$$;

COMMENT ON COLUMN public.usuarios_sistema.senha_hash IS
  'Obsoleto: credenciais são gerenciadas exclusivamente pelo Supabase Auth.';