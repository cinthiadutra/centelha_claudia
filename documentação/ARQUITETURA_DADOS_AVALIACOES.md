# Arquitetura de Dados: Sistema de Avaliações Mensais

## 🎯 Visão Geral

O sistema utiliza **duas camadas de tabelas**:

1. **Camada de Entrada** (Tabelas de Lançamento) - Dados brutos
2. **Camada Consolidada** (Tabela de Avaliações) - Dados processados

Esta arquitetura separa a **entrada de dados** do **resultado calculado**, facilitando manutenção, auditoria e performance.

---

## 📊 Arquitetura em 2 Camadas

```
┌─────────────────────────────────────────────────────────────┐
│                    CAMADA DE ENTRADA                        │
│                   (Dados Brutos - Input)                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📝 conceitos_grupo_tarefa      → Nota C                   │
│  📝 conceitos_acao_social       → Nota D                   │
│  📅 escalas_cambonagem          → Nota F                   │
│  📅 escalas_arrumacao           → Nota G                   │
│  💰 status_mensalidade          → Nota H                   │
│  👨‍👩‍👧 conceitos_pais_maes         → Nota I                   │
│  ⭐ bonus_tata                  → Nota J                   │
│                                                             │
│  📊 registros_presenca          → Nota A                   │
│  📆 calendario_2026             → Nota B, E, K, L          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
                     🔄 PROCESSAMENTO
                     (Calculadores A-L)
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  CAMADA CONSOLIDADA                         │
│                (Dados Processados - Output)                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│             📈 avaliacoes_mensais                           │
│                                                             │
│  • Notas A-L individuais                                   │
│  • Nota total (0-120)                                      │
│  • Nota normalizada (0-100)                                │
│  • Posição geral e por núcleo                              │
│  • Histórico (mês anterior)                                │
│  • Variações (nota e posição)                              │
│  • Medalhas (ouro, prata, bronze)                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Camada de Entrada (Input)

### Propósito

Armazenar **dados brutos** lançados por usuários através das interfaces.

### Tabelas

| Tabela                   | Nota    | Responsável | Dados Armazenados                  |
| ------------------------ | ------- | ----------- | ---------------------------------- |
| `conceitos_grupo_tarefa` | C       | Líderes GT  | Nota 0-10 por membro/mês           |
| `conceitos_acao_social`  | D       | Líderes AS  | Nota 0-10 por membro/mês           |
| `escalas_cambonagem`     | F       | Secretaria  | Data, membro, comparecimento       |
| `escalas_arrumacao`      | G       | Secretaria  | Data, membro, tipo, comparecimento |
| `status_mensalidade`     | H       | Tesouraria  | Em dia (sim/não), data pagamento   |
| `conceitos_pais_maes`    | I       | Pais/Mães   | Nota 0-10, observações             |
| `bonus_tata`             | J       | Tata        | Nota 0-10, observações             |
| `registros_presenca`     | A       | Sistema     | Registros do ponto eletrônico      |
| `calendario_2026`        | B,E,K,L | Sistema     | Eventos oficiais                   |

### Características

- ✅ Uma linha por evento/lançamento
- ✅ Editável e auditável
- ✅ Mantém histórico de alterações
- ✅ Interface específica para cada tipo

---

## 📈 Camada Consolidada (Output)

### Propósito

Armazenar **resultado final** do cálculo mensal, otimizado para consultas e rankings.

### Tabela: `avaliacoes_mensais`

```sql
avaliacoes_mensais {
    -- Identificação
    mes, ano, membro_id, membro_nome, nucleo

    -- Notas individuais (0-10)
    nota_a, nota_b, nota_c, nota_d, nota_e, nota_f,
    nota_g, nota_h, nota_i, nota_j, nota_k, nota_l

    -- Totalizadores
    nota_total (0-120)
    nota_normalizada (0-100)

    -- Ranking
    posicao_geral
    posicao_nucleo
    total_membros
    medalha ('ouro', 'prata', 'bronze')

    -- Histórico
    nota_mes_anterior
    posicao_mes_anterior
    variacao_nota
    variacao_posicao

    -- Metadata
    destaque_nota, alerta_nota
    observacao, status
    calculado_em, calculado_por
}
```

### Características

- ✅ Uma linha por membro por mês
- ✅ Todas as notas já calculadas
- ✅ Posições de ranking pré-calculadas
- ✅ Histórico e variações automatizados
- ✅ Otimizada para leitura (views, rankings)

---

## 🔄 Fluxo de Processamento

### 1. Lançamento de Dados (Entrada)

```
Usuário → Interface → Tabela de Entrada
```

**Exemplo:**

```
Líder GT → LancarConceitosPage → conceitos_grupo_tarefa
```

### 2. Cálculo Mensal (Processamento)

```dart
// Pseudocódigo do fluxo
void calcularAvaliacaoMes(int mes, int ano) {
  // 1. Buscar dados das tabelas de entrada
  final conceitosC = buscarConceitosGrupoTarefa(mes, ano);
  final conceitosD = buscarConceitosAcaoSocial(mes, ano);
  final escalasF = buscarEscalasCambonagem(mes, ano);
  // ... todas as outras

  // 2. Para cada membro
  for (var membro in membros) {
    // 3. Calcular notas individuais usando calculadores
    final notaA = CalculadorNotaA.calcular(presencas);
    final notaB = CalculadorNotaB.calcular(calendario);
    final notaC = conceitosC[membro.id] ?? 0.0;
    // ... todas as notas

    // 4. Totalizar
    final notaTotal = notaA + notaB + ... + notaL;
    final notaNormalizada = (notaTotal / 120) * 100;

    // 5. Buscar histórico
    final avaliacaoAnterior = buscarMesAnterior(membro.id);

    // 6. Salvar em avaliacoes_mensais
    await supabase.from('avaliacoes_mensais').upsert({
      'mes': mes,
      'ano': ano,
      'membro_id': membro.id,
      'nota_a': notaA,
      // ... todas as notas
      'nota_total': notaTotal,
      'nota_normalizada': notaNormalizada,
      'nota_mes_anterior': avaliacaoAnterior?.notaTotal,
      'variacao_nota': notaTotal - (avaliacaoAnterior?.notaTotal ?? 0),
    });
  }

  // 7. Recalcular posições do ranking
  await recalcularPosicoes(mes, ano);
}
```

### 3. Visualização (Saída)

```
Query avaliacoes_mensais → RankingPage → Usuário
```

---

## 💡 Vantagens desta Arquitetura

### ✅ Separação de Responsabilidades

- **Entrada**: Foco na experiência do usuário ao lançar dados
- **Consolidada**: Foco em performance e consultas

### ✅ Performance

- Ranking já calculado (não precisa JOIN de 7+ tabelas)
- Índices otimizados para consultas frequentes
- Views pré-definidas para relatórios

### ✅ Histórico e Auditoria

- Tabelas de entrada mantêm histórico completo
- Tabela consolidada mostra evolução temporal
- Possível recalcular tudo a qualquer momento

### ✅ Flexibilidade

- Adicionar nova nota = nova tabela de entrada + update do cálculo
- Mudar fórmula = apenas recalcular consolidado
- Dados brutos sempre preservados

### ✅ Escalabilidade

- Tabelas de entrada crescem linearmente
- Tabela consolidada tem tamanho previsível (12 meses × N membros)
- Pode-se arquivar anos antigos

---

## 📊 Views Disponíveis

### 1. `ranking_mes_atual`

Ranking completo do mês atual com todas as notas.

```sql
SELECT * FROM ranking_mes_atual;
```

### 2. `top_10_ano`

Os 10 melhores do ano baseado na média anual.

```sql
SELECT * FROM top_10_ano;
```

### 3. `evolucao_mensal_membros`

Histórico de evolução de cada membro ao longo dos meses.

```sql
SELECT * FROM evolucao_mensal_membros
WHERE membro_nome = 'João Silva';
```

### 4. `estatisticas_por_nucleo`

Estatísticas agregadas por núcleo.

```sql
SELECT * FROM estatisticas_por_nucleo
WHERE ano = 2026;
```

---

## 🔧 Funções SQL Disponíveis

### 1. `calcular_avaliacao_mensal(mes, ano, membro_id)`

Calcula e salva a avaliação de um membro específico.

```sql
SELECT calcular_avaliacao_mensal(1, 2026, 'membro_123');
```

### 2. `recalcular_posicoes_ranking(mes, ano)`

Recalcula as posições de todos os membros no ranking do mês.

```sql
SELECT recalcular_posicoes_ranking(1, 2026);
```

---

## 🚀 Implementação no Flutter

### Service: AvaliacaoMensalService

```dart
class AvaliacaoMensalService {
  final SupabaseClient _supabase;

  // Calcular avaliações de todos os membros do mês
  Future<void> calcularMes(int mes, int ano) async {
    // 1. Buscar todos os membros ativos
    final membros = await _buscarMembrosAtivos();

    // 2. Para cada membro
    for (var membro in membros) {
      await _calcularAvaliacaoMembro(mes, ano, membro);
    }

    // 3. Recalcular ranking
    await _recalcularRanking(mes, ano);
  }

  // Calcular avaliação de um membro
  Future<void> _calcularAvaliacaoMembro(
    int mes,
    int ano,
    Membro membro,
  ) async {
    // Buscar dados de entrada
    final dadosCalculo = await _buscarDadosCalculo(mes, ano, membro.id);

    // Calcular cada nota
    final notaA = CalculadorNotaA().calcular(dadosCalculo);
    final notaB = CalculadorNotaB().calcular(dadosCalculo);
    // ... todas as notas

    // Salvar resultado
    await _supabase.from('avaliacoes_mensais').upsert({
      'mes': mes,
      'ano': ano,
      'membro_id': membro.id,
      'membro_nome': membro.nome,
      'nucleo': membro.nucleo,
      'nota_a': notaA,
      // ... todas as notas
      'nota_total': notaA + notaB + ... + notaL,
    });
  }

  // Buscar ranking
  Future<List<AvaliacaoMensal>> buscarRanking(int mes, int ano) async {
    final response = await _supabase
        .from('avaliacoes_mensais')
        .select()
        .eq('mes', mes)
        .eq('ano', ano)
        .order('nota_total', ascending: false);

    return response.map((json) => AvaliacaoMensal.fromJson(json)).toList();
  }
}
```

---

## 📋 Checklist de Implementação

### Fase 1: Setup ✅

- [x] Criar tabela `avaliacoes_mensais`
- [x] Criar views auxiliares
- [x] Criar funções SQL
- [ ] Executar SQL no Supabase

### Fase 2: Service

- [ ] Criar `AvaliacaoMensalService`
- [ ] Implementar método `calcularMes()`
- [ ] Implementar método `buscarRanking()`
- [ ] Criar model `AvaliacaoMensal`

### Fase 3: UI

- [ ] Atualizar `RankingMensalPage` para usar `avaliacoes_mensais`
- [ ] Adicionar botão "Calcular Mês"
- [ ] Mostrar histórico/variações
- [ ] Adicionar gráficos de evolução

### Fase 4: Integração

- [ ] Conectar calculadores com service
- [ ] Implementar recálculo automático
- [ ] Adicionar cache de resultados
- [ ] Testes end-to-end

---

## 🎯 Benefícios Práticos

### Para Usuários

- ⚡ Rankings carregam instantaneamente
- 📊 Visualização de evolução clara
- 🏆 Medalhas e destaques automáticos
- 📈 Histórico completo disponível

### Para Desenvolvedores

- 🔧 Fácil adicionar novas notas
- 🐛 Bugs fáceis de debugar
- 🔄 Possível recalcular tudo
- 📝 Código organizado e limpo

### Para Administradores

- 📊 Relatórios prontos (views)
- 🔍 Auditoria completa
- 🎯 Performance otimizada
- 💾 Backup facilitado

---

## 🔮 Próximos Passos

1. **Executar SQL no Supabase**
   - Rodar `criar_tabela_avaliacoes_mensais.sql`
2. **Criar Service e Model**
   - `AvaliacaoMensalService`
   - `AvaliacaoMensal` entity
3. **Atualizar RankingPage**
   - Usar `avaliacoes_mensais` em vez de cálculo em tempo real
   - Adicionar botão "Recalcular Mês"
4. **Adicionar Dashboards**

   - Gráfico de evolução
   - Comparativo entre núcleos
   - Top performers do ano

5. **Automatizar**
   - Cálculo agendado (1º dia do mês)
   - Notificações de mudanças
   - Backup automático
