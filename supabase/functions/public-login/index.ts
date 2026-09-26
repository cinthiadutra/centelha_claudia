import { createClient } from "npm:@supabase/supabase-js@2";

const allowedOrigins = new Set([
  "https://cinthiadutra.github.io",
  "http://localhost:7357",
  "http://127.0.0.1:7357",
]);

function respond(body: unknown, status: number, origin: string | null) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": origin && allowedOrigins.has(origin)
        ? origin
        : "https://cinthiadutra.github.io",
      "Access-Control-Allow-Headers": "apikey, content-type, x-client-info",
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
        "Access-Control-Allow-Headers": "apikey, content-type, x-client-info",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Vary": "Origin",
      },
    });
  }
  if (origin && !allowedOrigins.has(origin)) {
    return respond({ error: "Login ou senha inválidos." }, 403, origin);
  }
  if (request.method !== "POST") {
    return respond({ error: "Método não permitido." }, 405, origin);
  }

  let body: Record<string, unknown>;
  try {
    const rawBody = await request.text();
    if (rawBody.length > 4000) {
      return respond({ error: "Requisição inválida." }, 400, origin);
    }
    const parsed = JSON.parse(rawBody);
    if (!isRecord(parsed)) throw new Error("Invalid body");
    body = parsed;
  } catch {
    return respond({ error: "Requisição inválida." }, 400, origin);
  }

  const identifier = typeof body.login === "string" ? body.login.trim() : "";
  const password = typeof body.password === "string" ? body.password : "";
  if (
    !identifier || identifier.length > 320 || !password || password.length > 128
  ) {
    return respond({ error: "Login ou senha inválidos." }, 401, origin);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !serviceRoleKey || !anonKey) {
    return respond(
      { error: "Serviço de autenticação não configurado." },
      503,
      origin,
    );
  }

  try {
    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const normalizedIdentifier = identifier.toLowerCase();
    let profileQuery = admin
      .from("usuarios_sistema")
      .select("email, ativo");

    if (identifier.includes("@")) {
      profileQuery = profileQuery.eq("email", normalizedIdentifier);
    } else {
      profileQuery = profileQuery.eq("username", normalizedIdentifier);
    }

    let { data: profile, error: profileError } = await profileQuery
      .maybeSingle();
    if (profileError) {
      return respond({ error: "Login ou senha inválidos." }, 401, origin);
    }

    if (!profile && !identifier.includes("@")) {
      const cadastroResult = await admin
        .from("usuarios_sistema")
        .select("email, ativo")
        .eq("numero_cadastro", identifier)
        .maybeSingle();
      profile = cadastroResult.data;
      profileError = cadastroResult.error;
    }

    if (profileError || !profile || profile.ativo !== true) {
      return respond({ error: "Login ou senha inválidos." }, 401, origin);
    }

    const authClient = createClient(supabaseUrl, anonKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: authData, error: authError } = await authClient.auth
      .signInWithPassword({ email: profile.email, password });
    if (authError || !authData.session) {
      return respond({ error: "Login ou senha inválidos." }, 401, origin);
    }

    return respond(
      {
        access_token: authData.session.access_token,
        refresh_token: authData.session.refresh_token,
      },
      200,
      origin,
    );
  } catch {
    return respond(
      { error: "Não foi possível autenticar agora." },
      503,
      origin,
    );
  }
});
