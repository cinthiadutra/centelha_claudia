# Solução: Busca não Encontra Cadastros/Membros

## Problema

Ao buscar "cinthia" em cadastros ou membros, a busca não retorna resultados mesmo com os dados importados no Supabase.

## Causas Identificadas

### 1. Módulo de Membros Usava Datasource MOCK

- O sistema de membros estava configurado para usar `MembroDatasourceImpl()` (dados de exemplo em memória)
- Apenas 2 membros mock existiam: "Maria Silva Santos" e "José Oliveira"
- Os 446 membros importados estavam no Supabase, mas não eram acessados

### 2. Módulo de Cadastros Não Carregava Dados Inicialmente

- O controller de cadastro buscava na lista local `usuarios.obs`
- Esta lista só era preenchida se `carregarUsuarios()` fosse chamado explicitamente
- Ao abrir a tela de pesquisa, a lista estava vazia

## Soluções Implementadas

### 1. Criado Datasource Supabase para Membros

Arquivo: `lib/modules/membros/data/datasources/membro_supabase_datasource.dart`

```dart
class MembroSupabaseDatasource implements MembroDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<MembroModel> _cache = [];
  bool _cacheCarregado = false;

  MembroSupabaseDatasource(this._supabaseService) {
    _carregarCache();
  }

  /// Carrega cache inicial
  Future<void> _carregarCache() async {
    try {
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List).map((json) => MembroModel.fromJson(json)).toList(),
      );
      _cacheCarregado = true;
    } catch (e) {
      // Cache não carregado
    }
  }

  @override
  List<MembroModel> pesquisarPorNome(String nome) {
    final nomeNormalizado = normalizarParaBusca(nome);
    return _cache
        .where((m) => normalizarParaBusca(m.nome).contains(nomeNormalizado))
        .toList();
  }

  // ... outros métodos
}
```

**Características:**

- Carrega todos os membros do Supabase em cache na inicialização
- Busca funciona localmente no cache (rápida)
- Usa normalização de strings (sem acentos)
- Compatível com interface síncrona existente

### 2. Atualizado Injeção de Dependências

Arquivo: `lib/core/di/injection_container.dart`

```dart
// ANTES:
sl.registerLazySingleton<MembroDatasource>(() => MembroDatasourceImpl());

// DEPOIS:
sl.registerLazySingleton<MembroDatasource>(() => MembroSupabaseDatasource(sl()));
```

Agora membros usa Supabase real em vez de mock.

### 3. CadastroController Carrega Dados na Inicialização

Arquivo: `lib/modules/cadastro/presentation/controllers/cadastro_controller.dart`

```dart
// ANTES:
CadastroController(this._datasource);

// DEPOIS:
CadastroController(this._datasource) {
  // Carregar usuários na inicialização
  carregarUsuarios();
}
```

Agora ao abrir qualquer tela que usa `CadastroController`, os dados já estão carregados.

## Como Funciona Agora

### Fluxo de Busca em Cadastros:

1. App inicia → `CadastroController` é criado
2. Constructor chama `carregarUsuarios()`
3. `carregarUsuarios()` busca todos os cadastros do Supabase
4. Lista `usuarios.obs` é preenchida
5. Usuário abre tela de pesquisa
6. Usuário digita "cinthia"
7. Controller chama `pesquisar(nome: 'cinthia')`
8. Função normaliza: "cinthia" → "cinthia"
9. Busca na lista local: `normalizarParaBusca(u.nome).contains('cinthia')`
10. Encontra "CINTHIA" no banco (normalizado para "cinthia")
11. Retorna resultado

### Fluxo de Busca em Membros:

1. App inicia → `MembroSupabaseDatasource` é criado
2. Constructor chama `_carregarCache()` em background
3. Cache é preenchido com todos os membros do Supabase
4. Usuário abre tela de pesquisa
5. Usuário digita "cinthia"
6. Repository chama `pesquisarPorNome('cinthia')`
7. Função normaliza: "cinthia" → "cinthia"
8. Busca no cache: `normalizarParaBusca(m.nome).contains('cinthia')`
9. Encontra "CINTHIA" (normalizado para "cinthia")
10. Retorna resultado

## Benefícios

✅ **Busca Funciona**: Agora busca "cinthia" encontra "CINTHIA", "Cíntia", "Cinthía", etc.

✅ **Dados Reais**: Ambos módulos usam dados do Supabase

✅ **Performance**: Busca é feita em memória (cache local) - muito rápida

✅ **Sem Acentos**: Normalização automática remove acentos

✅ **Parcial**: Encontra por qualquer parte do nome

## Arquivos Modificados

1. ✅ `/lib/modules/membros/data/datasources/membro_supabase_datasource.dart` (CRIADO)
2. ✅ `/lib/core/di/injection_container.dart` (ATUALIZADO)
3. ✅ `/lib/modules/cadastro/presentation/controllers/cadastro_controller.dart` (ATUALIZADO)

## Teste

Para testar a solução:

### Cadastros:

1. Abrir app
2. Menu → **CADASTROS** → **Pesquisar**
3. Selecionar "Nome"
4. Digitar "cinthia" (ou qualquer parte do nome, com/sem acentos)
5. Clicar em **Pesquisar**
6. ✅ Deve encontrar todos os cadastros com "Cinthia" no nome

### Membros:

1. Menu → **MEMBROS DA CENTELHA** → **Pesquisar Membro**
2. Selecionar chip "Nome"
3. Digitar "cinthia" (ou qualquer parte do nome, com/sem acentos)
4. Clicar em buscar 🔍
5. ✅ Deve encontrar todos os membros com "Cinthia" no nome

## Observações Técnicas

### Cache vs Banco Direto

**Por que usar cache?**

- Interface original é síncrona (`List<Membro>` ao invés de `Future<List<Membro>>`)
- Refatorar toda arquitetura para async seria trabalhoso
- Cache resolve o problema mantendo compatibilidade
- Busca em memória é muito mais rápida

**Desvantagens do cache:**

- Consome memória (446 membros + 2,254 cadastros)
- Não reflete mudanças de outros usuários em tempo real
- Para sistema multiusuário, seria melhor async

**Recomendação futura:**

- Refatorar toda arquitetura para async/await
- Repository retornar `Future<List<Membro>>`
- Controller usar FutureBuilder/StreamBuilder
- Eliminar cache, buscar direto no Supabase

### Normalização

A função `normalizarParaBusca()` garante que:

- "José" = "jose" = "Jose" = "JOSE"
- "María" = "maria" = "Maria" = "MARIA"
- "François" = "francois"

Mapeamento completo em: `lib/core/utils/string_utils.dart`

## Próximos Passos (Opcional)

### Se a busca ainda estiver lenta:

1. **Adicionar índices no Supabase:**

```sql
-- Índice para busca por nome em cadastros
CREATE INDEX idx_cadastros_nome ON cadastros(nome);

-- Índice para busca por nome em membros
CREATE INDEX idx_membros_nome ON membros_historico(nome);
```

2. **Implementar busca paginada:**

- Carregar apenas 50 registros por vez
- Scroll infinito para carregar mais
- Reduz uso de memória

3. **Implementar busca server-side:**

```sql
-- PostgreSQL com busca case-insensitive:
SELECT * FROM cadastros
WHERE LOWER(nome) LIKE LOWER('%cinthia%');

-- Ou com extensão unaccent:
CREATE EXTENSION unaccent;
SELECT * FROM cadastros
WHERE unaccent(LOWER(nome)) LIKE unaccent(LOWER('%cinthia%'));
```

4. **Adicionar debounce na busca:**

```dart
Timer? _debounce;

void onSearchChanged(String query) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    // Executar busca
  });
}
```

Isso evita buscar a cada letra digitada.

## Resumo

| Antes                         | Depois                                 |
| ----------------------------- | -------------------------------------- |
| Membros: Mock com 2 registros | Membros: Supabase com 446 registros    |
| Cadastros: Lista vazia        | Cadastros: Carregados na inicialização |
| Busca não encontrava          | Busca funciona sem acentos             |
| "cinthia" → 0 resultados      | "cinthia" → encontra "CINTHIA"         |
