# PROBLEMA: Sistema carregando apenas 2 usuários

## 🔍 Diagnóstico Atualizado

Após análise dos logs, identificamos que:

- ✅ A conexão com Supabase está funcionando
- ✅ O datasource está correto
- ❌ **A tabela `usuarios` só tem 2 registros no Supabase**
- 📁 **Existem 2.254 cadastros no arquivo local** `assets/CAD_PESSOAS.json`

## 🎯 Solução Principal: IMPORTAR OS DADOS

**→ Veja o guia completo: [IMPORTAR_CADASTROS_DO_JSON.md](IMPORTAR_CADASTROS_DO_JSON.md)**

### Resumo Rápido:

1. Acesse o sistema
2. Menu → Cadastro → **"Importar Pessoas do Sistema Antigo"**
3. Clique em **"Iniciar Importação"**
4. Aguarde processar os 2.254 registros
5. Reinicie o app

---

## 🔧 Solução Secundária: Configurar RLS

Se mesmo após importar os dados o problema persistir, pode ser problema de RLS.

## ✅ Solução

Execute os passos abaixo no **SQL Editor do Supabase**:

### Opção 1: Desabilitar RLS temporariamente (Desenvolvimento)

1. Acesse o Supabase Dashboard
2. Vá em **SQL Editor**
3. Clique em **New Query**
4. Cole e execute o seguinte script:

```sql
-- DESABILITAR RLS PARA DESENVOLVIMENTO
ALTER TABLE usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE membros DISABLE ROW LEVEL SECURITY;
ALTER TABLE consultas DISABLE ROW LEVEL SECURITY;
ALTER TABLE membros_historico DISABLE ROW LEVEL SECURITY;
ALTER TABLE calendario_2026 DISABLE ROW LEVEL SECURITY;
ALTER TABLE hist_cursos DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_tarefas DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_acoes_sociais DISABLE ROW LEVEL SECURITY;
ALTER TABLE grupos_trabalhos_espirituais DISABLE ROW LEVEL SECURITY;
```

⚠️ **IMPORTANTE**: Esta solução é apenas para desenvolvimento. Antes de colocar em produção, reabilite o RLS!

### Opção 2: Aplicar políticas de leitura pública (Recomendado)

Execute o arquivo já existente: `supabase_rls_public_read.sql`

1. Abra o arquivo [supabase_rls_public_read.sql](../supabase_rls_public_read.sql)
2. Copie todo o conteúdo
3. No Supabase Dashboard > SQL Editor > New Query
4. Cole e execute

Isso permitirá:

- ✅ Leitura pública (sem autenticação)
- 🔒 Escrita apenas para usuários autenticados

### Opção 3: Verificar se há dados na tabela

Para confirmar que há dados no Supabase:

```sql
-- Contar usuários
SELECT COUNT(*) as total_usuarios FROM usuarios;

-- Ver os primeiros 10 usuários
SELECT id, nome, cpf, numero_cadastro FROM usuarios LIMIT 10;

-- Ver políticas ativas
SELECT tablename, policyname, cmd
FROM pg_policies
WHERE tablename = 'usuarios';
```

## 📋 Arquivo de diagnóstico

Execute o script [verificar_e_corrigir_rls.sql](scripts/verificar_e_corrigir_rls.sql) para:

1. Ver todas as políticas ativas
2. Verificar status do RLS
3. Contar registros reais na tabela
4. Opcionalmente desabilitar RLS

## 🔄 Após aplicar a solução

1. Reinicie o aplicativo (Hot Restart - não Hot Reload)
2. Verifique os logs no console
3. Você deverá ver: `✅ [DATASOURCE] XXXX usuários convertidos com sucesso`

## 📝 Logs de debug adicionados

O sistema agora tem logs extras para diagnosticar problemas de carregamento:

```
🔍 [DATASOURCE] Buscando usuários da tabela "usuarios"...
📊 [DATASOURCE] Response type: ...
📊 [DATASOURCE] Response length: ...
✅ [DATASOURCE] XXXX usuários convertidos com sucesso
```

Se aparecer `⚠️ Nenhum dado retornado`, significa que o RLS está bloqueando ou não há dados na tabela.
