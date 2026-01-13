# 📋 Importação de Membros Antigos (Histórico Espiritual)

## 🎯 O que foi criado

Sistema completo para importar o histórico espiritual de 446 membros do sistema antigo (CSV) para o Supabase.

## 📁 Arquivos Criados

### 1. Script SQL

- **`scripts/criar_tabela_membros_historico.sql`**
  - Cria tabela `membros_historico` no Supabase
  - 40+ campos para histórico completo
  - Índices, RLS e políticas de segurança

### 2. Página de Importação

- **`lib/modules/membros/presentation/pages/importar_membros_antigos_page.dart`**
  - Interface visual para importar CSV
  - Progresso em tempo real
  - Tratamento de erros
  - Parse automático de datas

### 3. Asset CSV

- **`assets/membros_antigos.csv`**
  - 446 registros do sistema antigo
  - Histórico espiritual completo

## 🚀 Como Usar

### Passo 1: Criar Tabela no Supabase

1. Acesse **Supabase Dashboard** → **SQL Editor**
2. Copie todo o conteúdo de `scripts/criar_tabela_membros_historico.sql`
3. Cole no editor e clique em **Run**
4. Verifique se a tabela foi criada: `SELECT * FROM membros_historico LIMIT 1;`

### Passo 2: Importar Membros

1. Execute o app Flutter
2. Faça login como **Administrador** (Nível 4)
3. Vá em **MEMBROS DA CENTELHA** → **Importar Histórico Antigo**
4. Clique em **INICIAR IMPORTAÇÃO**
5. Aguarde o processamento dos 446 registros
6. Veja o resumo: importados vs erros

## 📊 Estrutura da Tabela `membros_historico`

### Identificação

- `mov` - Movimento
- `cadastro` - Número de cadastro
- `nome` - Nome completo
- `nucleo` - CCU/CPO
- `status` - Ativo/Inativo/Suspenso
- `funcao` - Função no núcleo
- `classificacao` - Classificação mediúnica
- `dia_sessao` - Segunda/Terça/etc

### Estágios e Ritos

- Início/Desistência do estágio
- 1º, 2º e 3º Rito de Passagem
- 1º, 2º e 3º Desligamento + Justificativas

### Sacramentos

- `ritual_batismo` - Data do batismo
- `jogo_orixa` - Data do jogo
- `coroacao_sacerdote` - Data da coroação
- `primeira_camarinha` - 1ª camarinha
- `segunda_camarinha` - 2ª camarinha
- `terceira_camarinha` - 3ª camarinha

### Orixás

- `primeiro_orixa` + adjunto
- `segundo_orixa` + adjunto
- `terceiro_quarto_orixa`

### Atividades

- `atividade_espiritual`
- `grupo_trabalho_espiritual`

### Suspensões

- 1ª, 2ª e 3ª Suspensão
  - Data inicial
  - Data final
  - Justificativa

### Observações

- `observacoes` - Informações adicionais

## 🎨 Interface Visual

A página de importação mostra:

- ✅ **Total de registros**: 446 membros
- 📊 **Progresso em tempo real**: Barra de progresso
- ✅ **Contador de sucessos**: Registros importados
- ❌ **Contador de erros**: Registros com problema
- 📝 **Lista de erros**: Primeiros 20 erros para análise
- 🎉 **Tela de sucesso**: Resumo final

## 🔧 Tratamento de Dados

### Datas

O sistema converte automaticamente:

- Formato original: `M/D/YY` (ex: `1/13/26`)
- Para: `YYYY-MM-DD` (ex: `2026-01-13`)
- Anos de 2 dígitos: 00-50 = 2000+, 51-99 = 1900+

### Campos Vazios

- Campos vazios no CSV = `null` no banco
- Nomes vazios = `"Nome não informado"`

### CSV Delimiter

- Delimitador: `;` (ponto e vírgula)
- Encoding: UTF-8
- Ignora primeiras 3 linhas (metadados)
- Cabeçalhos na linha 4

## 📍 Menu e Rota

### Menu

```
MEMBROS DA CENTELHA
├── Incluir Novo Membro
├── Pesquisar Dados de Membro
├── Editar Dados de Membro
├── Importar Histórico Antigo ← NOVO (Nível 4 apenas)
└── Gerar Relatórios de Membros
```

### Rota

- **Path**: `/membros/importar-antigos`
- **Componente**: `ImportarMembrosAntigosPage`
- **Acesso**: Somente Nível 4 (Administrador)

## 🎯 Fluxo de Importação

```
1. Usuário clica em "INICIAR IMPORTAÇÃO"
   ↓
2. Sistema carrega CSV do assets
   ↓
3. Parse do CSV (446 registros)
   ↓
4. Processa em lotes de 50
   ↓
5. Para cada registro:
   - Extrai dados das colunas
   - Converte datas
   - Monta objeto JSON
   - Insere no Supabase
   - Atualiza contador
   ↓
6. Exibe resultado final
```

## ⚡ Performance

- **Processamento**: Lotes de 50 registros
- **Delay entre lotes**: 100ms
- **Tempo estimado**: ~1 minuto para 446 registros
- **Memory safe**: Verifica `mounted` em cada setState

## 🔒 Segurança

- RLS habilitado na tabela
- Políticas de acesso apenas para autenticados
- Somente Nível 4 pode importar
- Trigger para atualizar `updated_at`

## 📝 Exemplos de Dados

### Membro Típico

```sql
{
  "cadastro": "1234",
  "nome": "João da Silva",
  "nucleo": "CCU",
  "status": "ATIVO",
  "classificacao": "GRAU AMARELO",
  "dia_sessao": "SEGUNDA",
  "primeiro_orixa": "OGUM",
  "segundo_orixa": "OXOSSI",
  "ritual_batismo": "2020-03-15",
  "jogo_orixa": "2019-12-01"
}
```

## 🆘 Troubleshooting

### "Table membros_historico does not exist"

Execute o script SQL primeiro!

### "Permission denied"

Verifique se você está logado como Nível 4

### "CSV parse error"

Verifique se o arquivo está em UTF-8 e usa `;` como delimitador

### Erros de data

O sistema tenta converter mas ignora datas inválidas (fica null)

## 📊 Após a Importação

Use queries SQL para consultar:

```sql
-- Total por núcleo
SELECT nucleo, COUNT(*)
FROM membros_historico
GROUP BY nucleo;

-- Membros ativos
SELECT COUNT(*)
FROM membros_historico
WHERE status = 'ATIVO';

-- Por classificação
SELECT classificacao, COUNT(*)
FROM membros_historico
GROUP BY classificacao
ORDER BY COUNT(*) DESC;

-- Batizados por ano
SELECT
  EXTRACT(YEAR FROM ritual_batismo) as ano,
  COUNT(*)
FROM membros_historico
WHERE ritual_batismo IS NOT NULL
GROUP BY ano
ORDER BY ano;
```

## ✅ Checklist de Importação

- [ ] Script SQL executado no Supabase
- [ ] Tabela `membros_historico` criada
- [ ] App Flutter rodando
- [ ] Login como Nível 4
- [ ] CSV em `assets/membros_antigos.csv`
- [ ] Dependência `csv: ^6.0.0` instalada
- [ ] Menu visível para seu usuário
- [ ] Importação iniciada
- [ ] Progresso acompanhado
- [ ] Resultado conferido
- [ ] Dados verificados no Supabase

🎉 **Pronto para importar 446 membros do sistema antigo!**
