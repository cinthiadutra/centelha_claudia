# Como Importar Cursos e Histórico para o Supabase

## 📋 O que será importado

- **CURSOS.csv**: Lista de cursos disponíveis (16 cursos)
- **HIST_CURSOS.csv**: Histórico de inscrições e conclusões

## 🚀 Passos para Importação

### 1. Importar Lista de Cursos

1. Acesse o **Supabase Dashboard**
2. Vá em **SQL Editor**
3. Clique em **New Query**
4. Abra o arquivo `scripts/importar_cursos.sql`
5. Copie e cole a seção **PASSO 1** (INSERT dos cursos)
6. Execute (Run)

Isso vai criar 16 cursos na tabela `cursos`.

### 2. Importar o CSV de Histórico

**Opção A: Via Table Editor (Mais fácil)**

1. No Supabase Dashboard, vá em **Table Editor**
2. Clique em **New table**
3. Nome: `hist_cursos_temp`
4. Adicione as colunas conforme o SQL (ou execute o CREATE TABLE do PASSO 3)
5. Com a tabela criada, clique em **Insert** → **Import data from CSV**
6. Selecione o arquivo `HIST_CURSOS.csv`
7. Configure o separador como `;` (ponto e vírgula)
8. Clique em **Import**

**Opção B: Via SQL Editor**

1. Execute o **PASSO 3** do SQL para criar a tabela temporária
2. Use a interface do Supabase para importar o CSV
3. Ou converta o CSV para INSERTs SQL manualmente

### 3. Processar Histórico para Inscrições

1. No **SQL Editor**, execute o **PASSO 4** do arquivo `importar_cursos.sql`
2. Isso vai transferir os dados da tabela temporária para `inscricoes_cursos`
3. Faz o relacionamento com os cursos criados
4. Converte os status e formata as datas

### 4. Verificar Importação

Execute o **PASSO 5** para verificar:

```sql
-- Ver total importado
SELECT COUNT(*) as total_inscricoes FROM inscricoes_cursos;

-- Ver por curso
SELECT
  c.titulo,
  COUNT(i.id) as total_inscricoes
FROM cursos c
LEFT JOIN inscricoes_cursos i ON c.id = i.curso_id
GROUP BY c.titulo
ORDER BY total_inscricoes DESC;
```

### 5. Limpar Tabela Temporária

Depois de confirmar que está tudo OK:

```sql
DROP TABLE IF EXISTS hist_cursos_temp;
```

## 📊 Dados Importados

### Cursos (16 total):

- Curso de Integração
- Curso de Cambonagem
- Curso de Libras
- Práticas Terapêuticas Espiritualistas
- Treinamento para Atendimento Fraterno
- Curso Básico de Umbanda (níveis 1, 2, 3)
- Curso de Formação de Curimbeiro
- Curso de Tarot Cabalístico
- RCP (Ressuscitação Cardiopulmonar)
- Inglês Básico (módulos 1 e 2)
- Artesanato e Costura
- E outros...

### Status Convertidos:

- `APROVADO` → `Concluído` (aprovado = true)
- `CURSANDO` → `Em andamento`
- `DESISTIU` → `Desistente` (aprovado = false)

## ⚠️ Observações

1. **Cadastros não encontrados**: Se houver números de cadastro no histórico que não existem na tabela `usuarios`, essas inscrições serão criadas mas sem referência ao usuário

2. **Duplicatas**: O script usa `ON CONFLICT DO NOTHING`, então se uma inscrição já existir, ela não será duplicada

3. **Datas**: As datas do CSV estão em formato `MM/DD/YY` e são convertidas automaticamente

4. **Certificados**: Qualquer texto no campo certificado (exceto "SEM CERTIFICADO") marca como certificado emitido

## 🔍 Troubleshooting

### Erro: "relation hist_cursos_temp does not exist"

→ Execute o PASSO 3 antes do PASSO 4

### Cadastros sem correspondência

→ Execute a query de verificação do PASSO 5 para ver quais cadastros não existem

### Cursos não encontrados

→ Verifique se os títulos dos cursos batem exatamente entre o CSV e a tabela `cursos`
