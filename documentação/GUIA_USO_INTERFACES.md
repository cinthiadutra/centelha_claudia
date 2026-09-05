# Guia de Uso: Interfaces de Lançamento de Notas

## 📋 Resumo das Interfaces

O sistema possui **2 tipos de interfaces** para lançamento de notas:

### 1️⃣ Interface por Grupo (Notas C e D)

**Arquivo:** `lancar_conceitos_page.dart`

Para líderes de **Grupo-Tarefa** e **Ação Social** que precisam avaliar **todos os membros do seu grupo** de uma vez.

### 2️⃣ Interface Individual (Notas F, G, H, I, J)

**Arquivo:** `lancar_notas_com_justificativa_page.dart`

Para lançar notas **individuais com justificativa** - você busca um membro específico e adiciona a nota.

---

## 🎯 Interface por Grupo (Notas C e D)

### Uso

Usado por **líderes de grupo** para avaliar todos os membros do seu grupo.

### Fluxo

1. **Escolhe o tipo**: Grupo-Tarefa (Nota C) ou Ação Social (Nota D)
2. **Seleciona o grupo** que lidera (dropdown)
3. **Escolhe mês/ano**
4. **Vê automaticamente todos os membros daquele grupo**
5. **Ajusta a nota** de cada um com slider (0-10)
6. **Salva todas as notas** de uma vez

### Exemplo de Uso no Menu

```dart
// Menu de Grupo-Tarefa
ListTile(
  leading: const Icon(Icons.group_work),
  title: const Text('Conceitos de Grupo-Tarefa'),
  subtitle: const Text('Avaliar membros do meu grupo'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LancarConceitosPage(),
      ),
    );
  },
)
```

### Visual

```
┌────────────────────────────────────┐
│ Conceitos de Grupo-Tarefa         │
├────────────────────────────────────┤
│ Tipo: [Grupo-Tarefa ▼]            │
│ Grupo: [GT A - Marketing ▼]       │
│ Mês: [Janeiro ▼]  Ano: [2026 ▼]  │
├────────────────────────────────────┤
│ 👤 João Silva - CCU          [7.5] │
│ ────●─────────────────────────     │
│                                    │
│ 👤 Maria Santos - CCM        [9.0] │
│ ──────────────●───────────────     │
│                                    │
│ 👤 Ana Costa - CCU           [8.0] │
│ ─────────●────────────────────     │
├────────────────────────────────────┤
│         [💾 Salvar Conceitos]      │
└────────────────────────────────────┘
```

---

## 🔍 Interface Individual (Notas F, G, H, I, J)

### Uso

Para adicionar notas **individuais com justificativa** para casos específicos.

### 5 Variações da Mesma Interface

Passa o parâmetro `tipoNota` para definir qual nota será lançada:

| Tipo            | Nota | Quem usa   | Descrição                         |
| --------------- | ---- | ---------- | --------------------------------- |
| `'cambonagem'`  | F    | Secretaria | Presença em escalas de cambonagem |
| `'arrumacao'`   | G    | Secretaria | Presença em escalas de arrumação  |
| `'mensalidade'` | H    | Tesouraria | Status de mensalidade             |
| `'pais_maes'`   | I    | Pais/Mães  | Conceitos Pais/Mães de Terreiro   |
| `'tata'`        | J    | Tata       | Bônus Tata                        |

### Fluxo

1. **Escolhe mês/ano**
2. **Busca um membro** (digita o nome)
3. **Seleciona o membro** da lista
4. **Ajusta a nota** (0-10)
5. **Adiciona justificativa** (opcional)
6. **Salva** (pode adicionar mais membros)
7. **Vê a lista** de notas já lançadas no mês

### Exemplo de Uso no Menu

```dart
// Menu de Tesouraria - Mensalidades
ListTile(
  leading: const Icon(Icons.payments),
  title: const Text('Gerenciar Mensalidades'),
  subtitle: const Text('Nota H'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LancarNotasComJustificativaPage(
          tipoNota: 'mensalidade',
        ),
      ),
    );
  },
),

// Menu de Pais/Mães - Conceitos Especiais
ListTile(
  leading: const Icon(Icons.family_restroom),
  title: const Text('Conceitos Pais/Mães'),
  subtitle: const Text('Nota I'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LancarNotasComJustificativaPage(
          tipoNota: 'pais_maes',
        ),
      ),
    );
  },
),

// Menu de Secretaria - Cambonagem
ListTile(
  leading: const Icon(Icons.event_available),
  title: const Text('Escalas de Cambonagem'),
  subtitle: const Text('Nota F'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LancarNotasComJustificativaPage(
          tipoNota: 'cambonagem',
        ),
      ),
    );
  },
),
```

### Visual

```
┌────────────────────────────────────┐
│ Conceitos Pais/Mães (Nota I)      │
├────────────────────────────────────┤
│ Mês: [Janeiro ▼]  Ano: [2026 ▼]  │
├────────────────────────────────────┤
│ ┌──────────────────────────────┐  │
│ │ Adicionar Nova Nota          │  │
│ ├──────────────────────────────┤  │
│ │ Buscar: [João Silva____]  🔍 │  │
│ │                              │  │
│ │ 👤 João Silva - CCU    [8.5] │  │
│ │ Nota: ────────●────────────  │  │
│ │                              │  │
│ │ Justificativa:               │  │
│ │ [Muito participativo...]     │  │
│ │                              │  │
│ │      [💾 Salvar Nota]        │  │
│ └──────────────────────────────┘  │
├────────────────────────────────────┤
│ Notas já lançadas:                │
│                                    │
│ ● João Silva - CCU          [8.5] │
│   Muito participativo              │
│                             🗑️     │
│                                    │
│ ● Maria Santos - CCM        [9.0] │
│   Liderança exemplar               │
│                             🗑️     │
└────────────────────────────────────┘
```

---

## 🔄 Regra Importante: Membros Sem Notas

### Como funciona

**Membros QUE TEM nota na tabela:**

- A nota específica será usada no cálculo

**Membros SEM nota na tabela:**

- Seguem as **regras pré-estabelecidas** do calculador
- Cada calculador (Nota F, G, H, I, J) tem suas próprias regras

### Exemplo - Nota H (Mensalidades)

```dart
// Calculador de Nota H
double calcularNotaH(Map<String, dynamic> statusMensalidade) {
  // Se o membro está na tabela status_mensalidade
  if (statusMensalidade.containsKey('em_dia')) {
    return statusMensalidade['em_dia'] == true ? 10.0 : 0.0;
  }

  // Se NÃO está na tabela, assume regra padrão
  // Por exemplo: considera como mensalidade em dia
  return 10.0;
}
```

### Exemplo - Nota I (Pais/Mães)

```dart
// Calculador de Nota I
double calcularNotaI(Map<String, double> conceitosPaisMaes) {
  // Se o membro tem conceito na tabela
  if (conceitosPaisMaes.containsKey(membroId)) {
    return conceitosPaisMaes[membroId]!;
  }

  // Se NÃO tem, usa nota padrão (por exemplo, 7.0)
  return 7.0;
}
```

---

## 🗂️ Organização do Menu Sugerida

### Menu por Perfil de Usuário

```dart
// LÍDERES
├─ Conceitos de Grupo-Tarefa (Nota C)
│  └─ LancarConceitosPage()
├─ Conceitos de Ação Social (Nota D)
   └─ LancarConceitosPage()

// SECRETARIA
├─ Escalas de Cambonagem (Nota F)
│  └─ LancarNotasComJustificativaPage(tipoNota: 'cambonagem')
├─ Escalas de Arrumação (Nota G)
   └─ LancarNotasComJustificativaPage(tipoNota: 'arrumacao')

// TESOURARIA
└─ Gerenciar Mensalidades (Nota H)
   └─ LancarNotasComJustificativaPage(tipoNota: 'mensalidade')

// PAIS/MÃES DE TERREIRO
└─ Conceitos Pais/Mães (Nota I)
   └─ LancarNotasComJustificativaPage(tipoNota: 'pais_maes')

// TATA
└─ Bônus Tata (Nota J)
   └─ LancarNotasComJustificativaPage(tipoNota: 'tata')

// TODOS
└─ Ranking Mensal
   └─ RankingMensalPage()
```

---

## 🔗 Vinculando Membros aos Grupos

### TODO: Criar Tabela de Vínculos

```sql
-- Tabela para vincular membros aos grupos
CREATE TABLE IF NOT EXISTS grupo_membros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    grupo_id TEXT NOT NULL,
    grupo_nome TEXT NOT NULL,
    grupo_tipo TEXT NOT NULL, -- 'grupo_tarefa' ou 'acao_social'
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL,
    data_entrada DATE DEFAULT CURRENT_DATE,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (grupo_id, membro_id)
);

-- Índices
CREATE INDEX idx_grupo_membros_grupo ON grupo_membros(grupo_id);
CREATE INDEX idx_grupo_membros_membro ON grupo_membros(membro_id);
CREATE INDEX idx_grupo_membros_tipo ON grupo_membros(grupo_tipo);
```

### Atualizar `_obterMembrosPorGrupo()`

```dart
Future<List<Map<String, dynamic>>> _obterMembrosPorGrupo(String grupoId) async {
  try {
    final response = await _supabase
        .from('grupo_membros')
        .select()
        .eq('grupo_id', grupoId)
        .eq('ativo', true);

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    log('Erro ao buscar membros do grupo: $e');
    return [];
  }
}
```

### Atualizar `_carregarGrupos()`

```dart
Future<void> _carregarGrupos() async {
  setState(() => _isLoading = true);

  try {
    // Buscar grupos reais do tipo selecionado
    final response = await _supabase
        .from('grupos')
        .select()
        .eq('tipo', _tipoConceito)
        .eq('ativo', true);

    setState(() {
      _grupos = List<Map<String, dynamic>>.from(response);
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar grupos: $e')),
      );
    }
  }
}
```

---

## ✅ Vantagens desta Arquitetura

### Para Notas C e D (Grupos)

✅ **Eficiente**: Avalia todos os membros de uma vez
✅ **Contextual**: Líder vê apenas seu grupo
✅ **Batch**: Salva tudo junto

### Para Notas F, G, H, I, J (Individual)

✅ **Flexível**: Adiciona apenas membros específicos
✅ **Justificado**: Requer observação/justificativa
✅ **Auditável**: Histórico de quem recebeu cada nota
✅ **Opcional**: Membros sem nota seguem regra padrão

### Geral

✅ **DRY**: Código reutilizado (1 componente para 5 notas)
✅ **Consistente**: UI similar em todas as telas
✅ **Escalável**: Fácil adicionar novos tipos de nota
✅ **Claro**: Cada interface para seu propósito

---

## 📝 Exemplo Completo de Menu Principal

```dart
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text('Sistema de Pontos', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),

          // VISUALIZAÇÃO
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('VISUALIZAÇÃO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Ranking Mensal'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RankingMensalPage())),
          ),
          const Divider(),

          // LANÇAMENTO - GRUPOS
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('LANÇAMENTO - GRUPOS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.group_work),
            title: const Text('Conceitos de Grupo'),
            subtitle: const Text('Notas C e D'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarConceitosPage())),
          ),
          const Divider(),

          // LANÇAMENTO - INDIVIDUAL
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('LANÇAMENTO - INDIVIDUAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Escalas de Cambonagem'),
            subtitle: const Text('Nota F'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarNotasComJustificativaPage(tipoNota: 'cambonagem'))),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Escalas de Arrumação'),
            subtitle: const Text('Nota G'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarNotasComJustificativaPage(tipoNota: 'arrumacao'))),
          ),
          ListTile(
            leading: const Icon(Icons.payments),
            title: const Text('Mensalidades'),
            subtitle: const Text('Nota H'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarNotasComJustificativaPage(tipoNota: 'mensalidade'))),
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Conceitos Pais/Mães'),
            subtitle: const Text('Nota I'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarNotasComJustificativaPage(tipoNota: 'pais_maes'))),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Bônus Tata'),
            subtitle: const Text('Nota J'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LancarNotasComJustificativaPage(tipoNota: 'tata'))),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎓 Resumo

- **2 interfaces** cobrem todas as 7 notas manuais (C, D, F, G, H, I, J)
- **Interface por grupo** para líderes avaliarem todo o grupo
- **Interface individual** para casos específicos com justificativa
- **Membros sem notas** seguem regras padrão dos calculadores
- **Vincular membros aos grupos** facilita o gerenciamento
- **Menu organizado** por tipo de usuário e função
