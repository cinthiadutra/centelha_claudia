# Prevenção de Duplicatas nas Importações

## Implementação

### Objetivo

Impedir que registros duplicados sejam inseridos durante as importações de dados do sistema antigo.

## Melhorias Implementadas

### 1. **Importação de Cadastros** - [importar_pessoas_antigas_page.dart](lib/modules/cadastro/presentation/pages/importar_pessoas_antigas_page.dart)

**Verificação de Duplicata:**

- Antes de inserir, verifica se já existe registro com o **mesmo nome**
- Query: `SELECT id FROM cadastros WHERE nome = ?`
- Se encontrado, pula o registro e incrementa contador de duplicados

**Feedback ao Usuário:**

- ✅ Contador de novos registros importados
- ⚠️ Contador de registros já existentes (pulados)
- ❌ Contador de erros

### 2. **Importação de Membros** - [importar_membros_antigos_page.dart](lib/modules/membros/presentation/pages/importar_membros_antigos_page.dart)

**Verificação de Duplicata:**

- Antes de inserir, verifica se já existe registro com **mesmo nome E cadastro**
- Query: `SELECT id FROM membros_historico WHERE nome = ? AND cadastro = ?`
- Se encontrado, pula o registro e incrementa contador de duplicados

**Feedback ao Usuário:**

- ✅ Contador de novos membros importados
- ⚠️ Contador de membros já existentes (pulados)
- ❌ Contador de erros

## Interface do Usuário

### Durante a Importação

```
Progresso: 1234 / 2254

✅ 1200 importados    ⚠️ 30 já existentes    ❌ 4 erros
```

### Ao Concluir

```
🎉 Importação Concluída!

✅ 1200 registros importados com sucesso
⚠️ 30 registros já existentes (pulados)
❌ 4 registros com erro
```

### Notificação Final

```
✅ Importação concluída! 1200 novos, 30 já existentes, 4 erros.
```

## Critérios de Duplicata

### Cadastros (Pessoas)

- **Campo único**: `nome`
- **Motivo**: O JSON original não tem CPF confiável
- **Trade-off**: Homônimos podem ser bloqueados incorretamente

### Membros (Histórico Espiritual)

- **Campos únicos**: `nome` + `cadastro`
- **Motivo**: Combinação garante unicidade
- **Vantagem**: Mesmo nome em núcleos diferentes pode existir

## Benefícios

1. **Segurança**: Não sobrescreve dados existentes
2. **Performance**: Não insere registros desnecessários
3. **Visibilidade**: Usuário vê quantos já existiam
4. **Idempotência**: Pode executar importação múltiplas vezes sem duplicar

## Melhorias Futuras Possíveis

### 1. Estratégia de Merge

- Ao invés de pular, atualizar dados existentes se estiverem mais completos
- Comparar timestamps e manter a versão mais recente

### 2. Detecção Mais Inteligente

- Usar algoritmo de similaridade (Levenshtein) para nomes parecidos
- Verificar CPF + nome para maior precisão
- Normalizar nomes antes de comparar (uppercase + sem acentos)

### 3. Relatório Detalhado

- Exportar CSV com registros duplicados encontrados
- Mostrar diferenças entre registro existente e novo
- Permitir escolha manual em casos ambíguos

### 4. Preview Antes de Importar

- Mostrar quantos duplicados serão encontrados
- Permitir escolher estratégia: pular, atualizar ou duplicar
- Filtrar por critérios (data, núcleo, etc.)

## Código Exemplo

```dart
// Verificar duplicata antes de inserir
final existente = await supabase
    .from('cadastros')
    .select('id')
    .eq('nome', nomeReal)
    .maybeSingle();

if (existente != null) {
  // Já existe, pular
  setState(() {
    _duplicados++;
  });
  continue;
}

// Se não existe, inserir
await supabase.from('cadastros').insert(cadastroData);
```

## Testagem

Para testar a funcionalidade:

1. **Primeira execução**: Importar todos os dados

   - Resultado: X novos, 0 duplicados

2. **Segunda execução**: Importar novamente

   - Resultado: 0 novos, X duplicados

3. **Importação parcial**: Adicionar dados novos + antigos
   - Resultado: Y novos, Z duplicados

## Performance

**Impacto**: Adiciona 1 query SELECT por registro antes de inserir

**Otimizações aplicadas**:

- ✅ Usa `maybeSingle()` ao invés de `select().limit(1)`
- ✅ Seleciona apenas `id` ao invés de campos completos
- ✅ Processa em batches de 50 registros
- ✅ Delay de 100ms entre batches para não sobrecarregar

**Tempo estimado**:

- 2,254 cadastros: ~3-5 minutos (com verificação)
- 446 membros: ~30-60 segundos (com verificação)

## Considerações de Banco de Dados

### Índices Recomendados

Para melhorar performance das verificações:

```sql
-- Cadastros: índice no nome
CREATE INDEX idx_cadastros_nome ON cadastros(nome);

-- Membros: índice composto
CREATE INDEX idx_membros_historico_nome_cadastro
ON membros_historico(nome, cadastro);
```

### Constraints de Banco

Alternativa: adicionar constraints no Supabase

```sql
-- Cadastros: nome único
ALTER TABLE cadastros
ADD CONSTRAINT unique_nome UNIQUE (nome);

-- Membros: combinação única
ALTER TABLE membros_historico
ADD CONSTRAINT unique_nome_cadastro UNIQUE (nome, cadastro);
```

**Vantagem**: Banco garante unicidade automaticamente
**Desvantagem**: Erro 23505 ao tentar inserir duplicata (precisa tratar)
