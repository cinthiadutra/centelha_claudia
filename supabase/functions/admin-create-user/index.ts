import { createClient } from "npm:@supabase/supabase-js@2";

const allowedOrigins = new Set([
  "https://cinthiadutra.github.io",
  "http://localhost:7357",
  "http://127.0.0.1:7357",
]);

function jsonResponse(body: unknown, status: number, origin: string | null) {
  const corsOrigin = origin && allowedOrigins.has(origin)
    ? origin
    : "https://cinthiadutra.github.io";
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": corsOrigin,
      "Access-Control-Allow-Headers":
        "authorization, apikey, content-type, x-client-info",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Vary": "Origin",
    },
  });
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

Deno.serve(async (request) => {
  const origin = request.headers.get("origin");
  if (request.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: {
        "Access-Control-Allow-Origin": origin && allowedOrigins.has(origin)
          ? origin
          : "https://cinthiadutra.github.io",
        "Access-Control-Allow-Headers":
          "authorization, apikey, content-type, x-client-info",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Vary": "Origin",
      },
    });
  }
  if (origin && !allowedOrigins.has(origin)) {
    return jsonResponse({ error: "Origem não permitida." }, 403, origin);
  }
  if (request.method !== "POST") {
    return jsonResponse({ error: "Método não permitido." }, 405, origin);
  }

  const token = request.headers.get("authorization")
    ?.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!token) {
    return jsonResponse({ error: "Autenticação necessária." }, 401, origin);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse({ error: "Serviço não configurado." }, 503, origin);
  }

  let body: Record<string, unknown>;
  try {
    const rawBody = await request.text();
    if (rawBody.length > 12000) {
      return jsonResponse({ error: "Requisição muito grande." }, 413, origin);
    }
    const parsed = JSON.parse(rawBody);
    if (!isRecord(parsed)) throw new Error("Invalid request body");
    body = parsed;
  } catch {
    return jsonResponse({ error: "Requisição inválida." }, 400, origin);
  }

  const nome = typeof body.nome === "string" ? body.nome.trim() : "";
  const email = typeof body.email === "string"
    ? body.email.trim().toLowerCase()
    : "";
  const password = typeof body.password === "string" ? body.password : "";
  const numeroCadastro = typeof body.numero_cadastro === "string"
    ? body.numero_cadastro.trim()
    : "";
  const username = typeof body.username === "string"
    ? body.username.trim().toLowerCase()
    : "";
  const nivelPermissao = Number(body.nivel_permissao);
  const ativo = body.ativo !== false;
  const observacoes = typeof body.observacoes === "string"
    ? body.observacoes.trim()
    : "";

  if (!nome || nome.length > 255) {
    return jsonResponse({ error: "Informe um nome válido." }, 400, origin);
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 320) {
    return jsonResponse({ error: "Informe um email válido." }, 400, origin);
  }
  if (password.length < 6 || password.length > 128) {
    return jsonResponse(
      { error: "A senha precisa ter entre 6 e 128 caracteres." },
      400,
      origin,
    );
  }
  if (
    !Number.isInteger(nivelPermissao) || nivelPermissao < 1 ||
    nivelPermissao > 4
  ) {
    return jsonResponse({ error: "Nível de permissão inválido." }, 400, origin);
  }
  if (observacoes.length > 2000) {
    return jsonResponse({ error: "Observações muito longas." }, 400, origin);
  }
  if (username && !/^[a-z0-9._-]{3,50}$/.test(username)) {
    return jsonResponse({ error: "Username inválido." }, 400, origin);
  }
  if (!numeroCadastro && nivelPermissao !== 4) {
    return jsonResponse(
      { error: "Este nível de acesso exige número de cadastro." },
      400,
      origin,
    );
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: callerData, error: callerError } = await supabase.auth.getUser(
    token,
  );
  if (callerError || !callerData.user?.email) {
    return jsonResponse({ error: "Sessão inválida ou expirada." }, 401, origin);
  }

  const { data: callerProfile, error: profileError } = await supabase
    .from("usuarios_sistema")
    .select("nivel_permissao, ativo")
    .eq("email", callerData.user.email)
    .maybeSingle();
  if (
    profileError || !callerProfile || callerProfile.ativo !== true ||
    callerProfile.nivel_permissao !== 4
  ) {
    return jsonResponse(
      { error: "Apenas administradores ativos podem cadastrar usuários." },
      403,
      origin,
    );
  }

  if (numeroCadastro) {
    const { data: members, error: memberError } = await supabase
      .from("membros_historico")
      .select("id")
      .eq("cadastro", numeroCadastro)
      .limit(2);
    if (memberError) {
      return jsonResponse(
        { error: "Não foi possível validar o cadastro." },
        500,
        origin,
      );
    }
    if (!members || members.length !== 1) {
      return jsonResponse(
        {
          error: members?.length
            ? "O cadastro está duplicado."
            : "Número de cadastro não encontrado.",
        },
        400,
        origin,
      );
    }
  }

  const { data: createdAuth, error: authCreateError } = await supabase.auth
    .admin
    .createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { nome, username: username || null },
    });
  if (authCreateError || !createdAuth.user) {
    const duplicate =
      authCreateError?.message.toLowerCase().includes("already") ||
      authCreateError?.message.toLowerCase().includes("exists");
    return jsonResponse(
      {
        error: duplicate
          ? "Este email já possui conta de autenticação."
          : "Não foi possível criar a conta de autenticação.",
      },
      duplicate ? 409 : 400,
      origin,
    );
  }

  const { error: insertError } = await supabase.from("usuarios_sistema").insert(
    {
      id: createdAuth.user.id,
      numero_cadastro: numeroCadastro || null,
      nome,
      username: username || null,
      email,
      senha_hash: null,
      nivel_permissao: nivelPermissao,
      ativo,
      observacoes: observacoes || null,
    },
  );

  if (insertError) {
    await supabase.auth.admin.deleteUser(createdAuth.user.id);
    const duplicate = insertError.code === "23505";
    return jsonResponse(
      {
        error: duplicate
          ? "Email, username ou cadastro já está em uso."
          : "Não foi possível salvar o perfil do usuário.",
      },
      duplicate ? 409 : 400,
      origin,
    );
  }

  return jsonResponse({ created: true }, 201, origin);
});
