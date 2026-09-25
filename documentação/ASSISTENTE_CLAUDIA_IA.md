# Assistente Claudia

## O que esta versão faz

O botão flutuante **Assistente Claudia** aparece para usuários autenticados e abre o chat em uma janela. Ela responde em português sobre as áreas do sistema e permite consultar informações atuais de membros. As respostas sobre membros usam uma função SQL somente de leitura, com limite de 20 resultados. O histórico de conversa não é persistido.

A descrição inicial de funcionalidades fica no código da Edge Function. Quando o menu ou as regras do sistema mudarem, atualize também `knowledge` em `supabase/functions/claudia-assistant/index.ts`.

O serviço limita cada usuário a 30 perguntas em 15 minutos. As perguntas e respostas não são persistidas; a tabela `claudia_assistant_usage` guarda somente o UUID autenticado e o horário, removendo registros com mais de dois dias.

## Acesso aos membros

A função identifica a conta autenticada pelo email e usa `usuarios_sistema.numero_cadastro` para encontrar o membro em `membros_historico.cadastro`.

| Nível | Acesso da Claudia |
|---|---|
| 1 - Membro ativo | Apenas o cadastro vinculado à própria conta |
| 2 - Secretaria | Membros de todos os núcleos |
| 3 - Pai/mãe de terreiro | Membros do núcleo vinculado à própria conta |
| 4 - Administrador | Membros de todos os núcleos |

O resultado usa uma lista explícita de campos. Inclui dados organizacionais e datas/histórico espiritual disponíveis na tabela. Exclui CPF, telefones, endereços, contatos de emergência, justificativas, observações livres e metadados. Pedidos que mencionem CPF, telefone ou endereço são respondidos localmente antes de chamar o Gemini. O texto retornado pelo modelo nunca é usado como instrução para consultas SQL.

## Ativação no Supabase

1. Confira se `usuarios_sistema` contém `email`, `numero_cadastro`, `nivel_permissao` e `ativo`, e se `membros_historico` contém `cadastro`, `nome` e `nucleo`. Nível 1 precisa ter cadastro associado; nível 3 precisa ter cadastro associado a um núcleo.
2. No **SQL Editor** do projeto Supabase, execute `scripts/claudia_assistant_search.sql`.
3. No painel Supabase, cadastre `GEMINI_API_KEY` em **Edge Functions > Secrets**. Não coloque essa chave no Flutter, GitHub, arquivos `.env` versionados ou mensagens.
4. Implante a função a partir da raiz do repositório:

   ```bash
   supabase functions deploy claudia-assistant --project-ref lnzhgnwwzvpplhaxqbvq
   ```

5. Publique o app Flutter na `main` para o GitHub Pages atualizar a tela do assistente.

A Edge Function usa `gemini-3.8-flash` por padrão. O modelo pode ser trocado pelo secret `GEMINI_MODEL`. A função exige uma sessão Supabase válida e chama o RPC com o token do usuário; não usa `service_role`.

## Modelo e custo

O modelo implementado é `gemini-3.8-flash`, chamado pela API REST na Edge Function; não é Gemini 1.5 e não usa a biblioteca Dart `google_generative_ai`, que o Google classifica como sem manutenção ativa. A tabela de preços atual oferece entrada e saída sem custo na camada gratuita do Gemini 3.8 Flash, sujeitas aos limites vigentes. Na camada gratuita, o conteúdo pode ser usado para melhorar produtos Google. Como este assistente pode enviar histórico espiritual de membros, não use a camada gratuita com dados reais sem aprovação explícita; avalie a camada paga e os termos/controles da conta antes de ativar.

## Privacidade

Quando a pergunta exige dados de membro, somente os resultados autorizados e os campos permitidos são enviados à API Gemini. Isso inclui histórico espiritual, conforme a decisão do projeto. Antes de habilitar para dados reais, confirme a base legal, a transparência aos membros e as condições de tratamento/retensão da conta Google AI usada. Não inclua dados de teste reais em prompts ou logs.

A configuração e as políticas RLS já existentes do projeto devem ser revisadas no Supabase antes da ativação. A função do assistente impõe seu próprio escopo de leitura, mas não corrige políticas amplas usadas por outras telas do app.

## Verificação

- `flutter analyze lib/modules/assistente lib/main.dart lib/core/navigation/app_menus.dart`
- `deno check supabase/functions/claudia-assistant/index.ts`
- Testar com uma conta de cada nível: membro tentando consultar outro cadastro; secretaria; liderança consultando o próprio e outro núcleo; administrador.
- Confirmar que CPF, telefone, endereço e contatos de emergência nunca aparecem na resposta nem são enviados ao Gemini, inclusive quando solicitados diretamente.
- Confirmar que a 31ª pergunta na janela de 15 minutos é recusada e que o limite não persiste o conteúdo da conversa.
