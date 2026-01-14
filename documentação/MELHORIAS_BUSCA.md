# Melhorias nas Buscas e Cadastros

## Alterações Implementadas

### 1. Busca Sem Acentos

Todas as buscas por nome agora ignoram acentos, permitindo encontrar:

- "Jose" encontra "José"
- "Maria" encontra "Mária"
- "Joao" encontra "João"

### 2. Busca em Qualquer Parte do Nome

As buscas agora encontram o termo em qualquer posição:

- "Silva" encontra "João Silva", "Silva Santos", "Maria da Silva"
- "Maria" encontra "Maria Santos", "Ana Maria", "Maria José"

### 3. Dados Salvos em UPPERCASE

Todos os campos de texto em cadastros são automaticamente convertidos para MAIÚSCULAS ao salvar:

- **Nome, endereço, bairro, cidade, estado** → salvos em UPPERCASE
- **Nomes de padrinhos, madrinhas, cônjuges** → salvos em UPPERCASE
- **Orixás, justificativas, atividades** → salvos em UPPERCASE
- **Emails** → salvos em lowercase (padrão técnico)
- **CPF, telefones, CEP** → mantidos sem alteração
- Aplicado em: **Usuários/Cadastros** e **Membros**

## Arquivos Modificados

### 1. `/lib/core/utils/string_utils.dart` (NOVO)

Funções utilitárias para normalização de strings:

- `removerAcentos()`: Remove todos os acentos e caracteres especiais
- `normalizarParaBusca()`: Remove acentos + lowercase + trim
- `toUpperCaseOrNull()`: Converte para uppercase com tratamento de null

### 2. `/lib/modules/cadastro/data/models/usuario_model.dart`

- **Método**: `toJson()`
- **Alteração**: Todos campos de texto convertidos para UPPERCASE antes de salvar
- **Exceções**: Emails em lowercase, CPF/telefones/CEP mantidos originais

### 3. `/lib/modules/membros/data/models/membro_model.dart`

- **Método**: `toJson()`
- **Alteração**: Todos campos de texto convertidos para UPPERCASE antes de salvar
- **Campos**: Nome, núcleo, status, função, classificação, orixás, etc.

### 4. `/lib/modules/cadastro/data/datasources/usuario_supabase_datasource.dart`

- **Método**: `searchUsuariosByNome()`
- **Alteração**: Busca todos usuários e filtra localmente com nome normalizado
- **Motivo**: Supabase `ilike` não remove acentos automaticamente

### 5. `/lib/modules/cadastro/presentation/controllers/cadastro_controller.dart`

- **Método**: `buscarUsuariosPorNome()` e `filtrarUsuarios()`
- **Alteração**: Usa `normalizarParaBusca()` para comparação
- **Benefício**: Consistência entre busca local e remota

### 6. `/lib/modules/membros/data/datasources/membro_datasource.dart`

- **Método**: `pesquisarPorNome()`
- **Alteração**: Usa `normalizarParaBusca()` em ambos os lados da comparação
- **Resultado**: Busca sem acentos nos membros

## Exemplo de Uso

```dart
import 'package:centelha_claudia/core/utils/string_utils.dart';

// Normalizar para busca
final termo = normalizarParaBusca("José"); // "jose"
final nome = normalizarParaBusca("José da Silva"); // "jose da silva"

// Verificar se contém
if (nome.contains(termo)) {
  print("Encontrado!"); // ✅ Encontrado!
}
```

## Testes Recomendados

1. **Busca de Cadastros**:

   - Buscar "maria" → deve encontrar "Maria", "Mária", "MARIA"
   - Buscar "silva" → deve encontrar início, meio e fim do nome

2. **Busca de Membros**:

   - Buscar "joao" → deve encontrar "João"
   - Buscar "jose" → deve encontrar "José", "Jose"

3. **Caracteres Especiais**:
   - Testar com: ç, ã, õ, á, é, í, ó, ú, â, ê, ô

## Performance

**Impacto**: Busca em `usuario_supabase_datasource` agora busca TODOS os usuários e filtra localmente.

**Mitigação**:

- Cache de resultados no controller
- Para grandes volumes (>10.000 registros), considerar:
  - Extensão PostgreSQL `unaccent`
  - Índice GIN com `to_tsvector`
  - View materializada com nomes normalizados

## Próximas Melhorias Possíveis

1. **Busca Fuzzy**: Tolerar erros de digitação
2. **Busca por Iniciais**: "JS" encontra "João Silva"
3. **Ranking de Relevância**: Ordenar por melhor match
4. **Highlight**: Destacar termo encontrado nos resultados
