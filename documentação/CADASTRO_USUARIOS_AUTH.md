# Cadastro e autenticação de usuários

## Fluxo corrigido

- Novas contas são criadas pela Edge Function `admin-create-user`, que exige sessão e valida um administrador ativo no servidor.
- A senha é enviada apenas nessa chamada HTTPS, usada para criar a conta Supabase Auth e não é persistida em `usuarios_sistema`.
- O perfil guarda o mesmo UUID da conta Auth. Se salvar o perfil falhar, a Edge Function tenta remover a conta Auth criada.
- Email ou username podem ser usados no login. O número de cadastro continua aceito para compatibilidade.
- A Edge Function `public-login` resolve o identificador sem expor emails e não autentica perfis inativos.
- Ao restaurar sessão, o app verifica `ativo`; contas inativas são desconectadas. A migration também faz as funções de autorização RLS retornarem nível zero para usuários inativos.
- Administradores podem não vincular um número de cadastro. Níveis 1 a 3 exigem vínculo único existente em `membros_historico`.
- Na edição, email Auth fica bloqueado e a senha nunca é lida do banco. Mudança de senha deve usar um fluxo dedicado de redefinição do Supabase Auth.

## Ativação no Supabase

1. Execute `scripts/corrigir_cadastro_usuarios_auth.sql` no SQL Editor. A migration aborta se encontrar usernames duplicados ignorando maiúsculas/minúsculas; nesse caso, corrija os conflitos e execute novamente.
2. Revise as funções auxiliares e políticas ativas do projeto para confirmar que tabelas sensíveis usam `get_user_nivel_permissao()` ou verificam `ativo`. O script `scripts/supabase_rls_policies.sql` foi ajustado, mas não reaplique o script inteiro sem revisar as demais políticas existentes.
3. Implante os endpoints:

   ```bash
   supabase functions deploy admin-create-user --project-ref lnzhgnwwzvpplhaxqbvq
   supabase functions deploy public-login --project-ref lnzhgnwwzvpplhaxqbvq
   ```

4. Publique o app Flutter na `main` para atualizar o GitHub Pages.

As funções usam `SUPABASE_SERVICE_ROLE_KEY` apenas no ambiente server-side do Supabase. Nunca configure essa chave no Flutter, no GitHub Pages ou em arquivos versionados.

## Matriz de verificação

- Administrador ativo cria membro vinculado e conta Auth; o perfil contém `senha_hash = NULL`.
- Administrador ativo cria conta administrativa sem número de cadastro.
- Login funciona por email, username e número de cadastro vinculado.
- Senha inválida, perfil ausente e conta inativa retornam erro genérico de credenciais.
- Membro não vinculado, cadastro inexistente/ambíguo, email/username duplicados e nível inválido são recusados sem deixar conta Auth órfã.
- Usuário não administrador recebe `403` ao chamar `admin-create-user` diretamente.
- Desativar um usuário bloqueia novo login e as permissões RLS do projeto.
- Atualizar perfil não altera email/senha da conta Auth e não envia senha ao banco.

Validação local executada no desenvolvimento:

```bash
flutter analyze lib/modules/auth lib/modules/usuarios_sistema
flutter test test/modules/usuarios_sistema/data/models/usuario_sistema_model_test.dart
npx --yes deno check supabase/functions/admin-create-user/index.ts
npx --yes deno check supabase/functions/public-login/index.ts
```

Os testes locais não substituem o teste de integração com contas dedicadas no projeto Supabase.