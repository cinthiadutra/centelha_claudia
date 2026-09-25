-- Install with the Supabase SQL Editor.
-- The assistant can only execute this bounded, read-only member lookup.

CREATE TABLE IF NOT EXISTS public.claudia_assistant_usage (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_claudia_assistant_usage_user_created
  ON public.claudia_assistant_usage(user_id, created_at);

ALTER TABLE public.claudia_assistant_usage ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.claudia_assistant_usage FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.claudia_registrar_uso_assistente()
RETURNS boolean
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_usos integer;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::text, 0)
  );

  SELECT count(*)::integer
  INTO v_usos
  FROM public.claudia_assistant_usage
  WHERE user_id = v_user_id
    AND created_at > now() - interval '15 minutes';

  IF v_usos >= 30 THEN
    RETURN false;
  END IF;

  INSERT INTO public.claudia_assistant_usage(user_id) VALUES (v_user_id);
  DELETE FROM public.claudia_assistant_usage
  WHERE user_id = v_user_id
    AND created_at < now() - interval '2 days';

  RETURN true;
END;
$$;

REVOKE ALL ON FUNCTION public.claudia_registrar_uso_assistente() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claudia_registrar_uso_assistente() TO authenticated;

CREATE OR REPLACE FUNCTION public.claudia_buscar_membros(
  p_termo text DEFAULT NULL,
  p_nucleo text DEFAULT NULL,
  p_status text DEFAULT NULL,
  p_limite integer DEFAULT 10
)
RETURNS SETOF jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_email text;
  v_numero_cadastro text;
  v_nivel integer;
  v_nucleo_usuario text;
  v_termo text := NULLIF(btrim(p_termo), '');
  v_limite integer := LEAST(GREATEST(COALESCE(p_limite, 10), 1), 20);
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
  END IF;

  v_email := auth.jwt() ->> 'email';

  SELECT us.numero_cadastro, us.nivel_permissao
  INTO v_numero_cadastro, v_nivel
  FROM public.usuarios_sistema AS us
  WHERE lower(us.email) = lower(v_email)
    AND COALESCE(us.ativo, true);

  IF v_nivel IS NULL OR v_nivel NOT BETWEEN 1 AND 4 THEN
    RAISE EXCEPTION 'User is not authorized' USING ERRCODE = '42501';
  END IF;

  IF v_nivel = 1 AND v_numero_cadastro IS NULL THEN
    RAISE EXCEPTION 'Member account has no linked member record' USING ERRCODE = '42501';
  END IF;

  IF v_nivel = 3 THEN
    SELECT mh.nucleo
    INTO v_nucleo_usuario
    FROM public.membros_historico AS mh
    WHERE mh.cadastro = v_numero_cadastro
    LIMIT 1;

    IF v_nucleo_usuario IS NULL THEN
      RAISE EXCEPTION 'Leadership account has no linked nucleus' USING ERRCODE = '42501';
    END IF;
  END IF;

  RETURN QUERY
  -- Only this allowlist leaves the database; CPF, phones, and addresses are excluded.
  SELECT (
    SELECT pg_catalog.jsonb_object_agg(fields.key, fields.value)
    FROM pg_catalog.jsonb_each(pg_catalog.to_jsonb(mh)) AS fields(key, value)
    WHERE fields.key = ANY (ARRAY[
      'cadastro', 'nome', 'nucleo', 'status', 'funcao', 'classificacao', 'dia_sessao',
      'inicio_estagio', 'desistencia_estagio', 'primeiro_rito_passagem',
      'primeiro_desligamento', 'inicio_primeiro_estagio', 'desistencia_primeiro_estagio',
      'data_primeiro_desligamento', 'primeiro_desligamento_justificativa',
      'segundo_rito_passagem', 'segundo_desligamento', 'inicio_segundo_estagio',
      'desistencia_segundo_estagio', 'data_segundo_desligamento',
      'terceiro_rito_passagem', 'terceiro_desligamento', 'inicio_terceiro_estagio',
      'desistencia_terceiro_estagio', 'data_terceiro_desligamento',
      'quarto_rito_passagem', 'quarto_desligamento', 'inicio_quarto_estagio',
      'desistencia_quarto_estagio', 'data_quarto_desligamento',
      'condicao_segundo_estagio', 'condicao_terceiro_estagio', 'condicao_quarto_estagio',
      'ritual_batismo', 'data_batizado', 'padrinho_batismo', 'madrinha_batismo',
      'jogo_orixa', 'data_jogo_orixa', 'primeira_camarinha', 'segunda_camarinha',
      'terceira_camarinha', 'coroacao_sacerdote', 'data_coroacao_sacerdote',
      'atividade_espiritual', 'grupo_trabalho_espiritual', 'grupo_tarefa', 'acao_social',
      'cargo_lideranca', 'primeiro_orixa', 'adjunto_primeiro_orixa', 'segundo_orixa',
      'adjunto_segundo_orixa', 'terceiro_orixa', 'quarto_orixa', 'terceiro_quarto_orixa',
      'nome_pr', 'nome_bai', 'nome_cab', 'nome_mar', 'nome_mal', 'nome_cig', 'nome_pv'
    ]::text[])
  )
  FROM public.membros_historico AS mh
  WHERE (
      v_nivel IN (2, 4)
      OR (v_nivel = 1 AND mh.cadastro = v_numero_cadastro)
      OR (v_nivel = 3 AND lower(mh.nucleo) = lower(v_nucleo_usuario))
    )
    AND (
      v_termo IS NULL
      OR pg_catalog.strpos(lower(COALESCE(mh.nome, '')), lower(v_termo)) > 0
      OR pg_catalog.strpos(lower(COALESCE(mh.cadastro, '')), lower(v_termo)) > 0
    )
    AND (NULLIF(btrim(p_nucleo), '') IS NULL OR lower(mh.nucleo) = lower(btrim(p_nucleo)))
    AND (NULLIF(btrim(p_status), '') IS NULL OR lower(mh.status) = lower(btrim(p_status)))
  ORDER BY mh.nome
  LIMIT v_limite;
END;
$$;

REVOKE ALL ON FUNCTION public.claudia_buscar_membros(text, text, text, integer)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claudia_buscar_membros(text, text, text, integer)
  TO authenticated;