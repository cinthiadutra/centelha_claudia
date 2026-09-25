# Importar Guias do Firebase

O export do Firebase contém `mediums`, com `id` do médium e uma lista `guides` de `{name, phalanx}`. O importador usa somente `mediums`; não lê nem envia consultas, consulentes, avaliações ou relatórios ao Supabase.

## Correspondência

O `medium.id` é comparado ao `membros_historico.cadastro` como código numérico, ignorando zeros à esquerda (`0002` corresponde a `2`). Se `medium.id` faltar, usa a chave daquele registro dentro de `mediums`. A associação não usa nomes. Cadastros sem correspondência ou com mais de um resultado ficam sem alteração.

| Falange do Firebase | Coluna do membro |
|---|---|
| Preto-velhos e Preta-velhas | `nome_pv` |
| Baianos e Baianas | `nome_bai` |
| Caboclos e Caboclas | `nome_cab` |
| Marinheiros | `nome_mar` |
| Malandros e Malandras | `nome_mal` |
| Ciganos e Ciganas | `nome_cig` |
| Exus e Pombogiras | `nome_pr` |

No cadastro, `nome_pr` representa Exu/Pomba-Gira e `nome_pv` representa Preto-Velho. O texto `A CONFIRMAR` é importado literalmente. Se uma guia mapeada tiver `name` vazio ou `null`, a coluna correspondente é gravada como `null`; falanges desconhecidas ou ausentes não são alteradas.

## Executar

Confirme que as sete colunas existem em `membros_historico`; se necessário, execute `scripts/adicionar_colunas_guias_membros.sql` no SQL Editor do Supabase. O importador precisa consultar os cadastros e atualizar os membros, então usa a chave administrativa Supabase em variável de ambiente. Não a coloque em arquivo versionado, no Flutter, nem a compartilhe.

No terminal do projeto, carregue a chave sem gravá-la no histórico do shell:

```zsh
export SUPABASE_URL='https://lnzhgnwwzvpplhaxqbvq.supabase.co'
read -s 'SUPABASE_SERVICE_ROLE_KEY?Cole a service_role key do Supabase: '
export SUPABASE_SERVICE_ROLE_KEY
```

Execute primeiro a prévia, que não altera o banco:

```zsh
node scripts/importar_guias_firebase.mjs "$HOME/Downloads/consultas-centelha-default-rtdb-export (1).json"
```

Confira as contagens de correspondências, ambiguidades, valores `A CONFIRMAR` e nomes nulos. Para gravar os membros preparados, rode novamente com `--apply`:

```zsh
node scripts/importar_guias_firebase.mjs "$HOME/Downloads/consultas-centelha-default-rtdb-export (1).json" --apply
unset SUPABASE_SERVICE_ROLE_KEY SUPABASE_URL
```

O modo padrão é sempre prévia. O JSON exportado fica no Downloads e não deve ser copiado para o repositório. A importação pode ser repetida com um export novo.

## Testes

```bash
node --test scripts/importar_guias_firebase.test.mjs
```