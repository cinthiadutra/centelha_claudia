# Sistema de Avaliação Mensal

Package para gerenciamento de avaliações mensais de membros baseado em pontuação (notas A-L).

## 📋 Visão Geral

Sistema completo de avaliação mensal que calcula 12 categorias de notas (A até L) baseadas em:

- Frequência em sessões mediúnicas e atividades espirituais
- Participação em grupos de trabalho, tarefas e ações sociais
- Conceitos dados por líderes e pais/mães de terreiro
- Assiduidade financeira
- Bônus por liderança

## 🎯 Estrutura das Avaliações

### Dados de Entrada

#### Cadastro do Membro

- Nome completo
- Classificação mediúnica (cambono, curimbeiro, graus vermelho até lilás, dirigente)
- Dia de sessão (terça, quarta, sexta, sábado CCU/CPO)
- Núcleo (CCU ou CPO)
- Grupo de trabalho espiritual
- Grupos-tarefa
- Grupos de ação social
- Cargos de liderança

#### Calendário Mensal

- Sessões mediúnicas
- Atendimentos públicos
- Atividades espirituais (COR, Ramatis, etc.)
- Escalas de cambonagem
- Escalas de arrumação/desarrumação

## 📊 Notas Calculadas (A-L)

### Nota A: Frequência em Sessões Mediúnicas

**Regras por classificação:**

**Cambono, Curimbeiro, Grau Vermelho ou Coral:**

- Sem sessão no mês: +10 pontos
- 1 sessão e compareceu: +10 pontos
- 1 sessão e faltou: +5 pontos
- 2+ sessões e compareceu a 1: +5 pontos
- 2+ sessões e compareceu a 2+: +10 pontos
- 2+ sessões e não compareceu: 0 pontos

**Grau Amarelo:**

- Sem sessão: +5 pontos
- 1 sessão e compareceu: +5 pontos
- 1 sessão e faltou: 0 pontos
- 2+ sessões e compareceu a 1: +5 pontos
- 2+ sessões e compareceu a 2+: +5 pontos
- 2+ sessões e não compareceu: 0 pontos
- Atendimentos: +5 pontos se compareceu a algum

**Grau Verde ou Superior:**

- Sem atendimento público: +10 pontos
- 1 atendimento e compareceu: +10 pontos
- 1 atendimento e faltou: +5 pontos
- 2+ atendimentos e compareceu a 1: +5 pontos
- 2+ atendimentos e compareceu a 2+: +10 pontos
- 2+ atendimentos e não compareceu: 0 pontos

### Nota B: Frequência em Atividades Espirituais

- Pertence a grupo e compareceu: +10 pontos
- Pertence a grupo e não compareceu: 0 pontos
- Grupo não teve atividade: +10 pontos
- Não pertence a grupo: 0 pontos

### Nota C: Conceito de Grupo-Tarefa

- Não pertence: 0 pontos
- Pertence: pontos dados pelo líder (0-10)

### Nota D: Conceito de Grupo de Ação Social

- Já pertence a grupo-tarefa: +10 pontos
- Pertence a ação social (sem grupo-tarefa): pontos do líder (0-10)
- Não pertence: 0 pontos

### Nota E: Assistência às Instruções Espirituais

- Sem COR/Ramatis no mês: +10 pontos
- 1 reunião e esteve presente: +10 pontos
- 1 reunião e não esteve: +5 pontos
- 2+ reuniões e presente em 1: +5 pontos
- 2+ reuniões e presente em 2+: +10 pontos
- 2+ reuniões e não presente: 0 pontos

### Nota F: Presença em Escalas de Cambonagem

- Não escalado: +10 pontos
- Escalado e não compareceu (nem trocou): 0 pontos
- Escalado e compareceu (ou trocou): +10 pontos

### Nota G: Presença em Escalas de Arrumação/Desarrumação

- Não escalado: +10 pontos
- Escalado e não compareceu (nem trocou): 0 pontos
- Escalado e compareceu (ou trocou): +10 pontos

### Nota H: Assiduidade de Pagamento

- Em atraso no 1º dia do mês: 0 pontos
- Em dia no 1º dia do mês: +10 pontos

### Nota I: Conceito do Pai/Mãe de Terreiro

- Pontos dados: 0 a 10

### Nota J: Bônus do Tata

- Pontos dados: 0 a 10

### Nota K: Nota do Mês Anterior

- Membro novo: +10 pontos
- Membro antigo: nota final do mês anterior

### Nota L: Bônus por Liderança

- Sem cargo: 0 pontos
- Com cargos: +5 pontos por cargo

## 🔢 Cálculo das Notas

### Nota Real

```
Nota Real = Soma de todas as notas (A + B + C + ... + L)
```

### Nota Final (Normalizada)

```
Nota Final = (Nota Real / Maior Nota Real do Mês) × 100
```

A maior nota real do mês sempre equivale a 100 pontos.

## 🚀 Uso do Package

### Exemplo de Cálculo

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

// Preparar dados
final dados = DadosCalculoAvaliacao(
  membro: membro,
  mes: 1,
  ano: 2026,
  atividadesDoMes: atividades,
  presencas: presencas,
  conceitosLideresGrupoTarefa: {'grupo1': 8.5},
  conceitosLideresAcaoSocial: {'grupo2': 9.0},
  conceitosPaisMaes: {'membroId': 7.5},
  bonusTata: {'membroId': 8.0},
  notaMesAnterior: 85.0,
);

// Calcular avaliação
final useCase = CalcularAvaliacaoMensalUseCase();
final avaliacao = useCase.calcular(dados);

log('Nota Real: ${avaliacao.notaReal}');
log('Nota Final: ${avaliacao.notaFinal}');
```

### Normalização de Notas

```dart
// Calcular todas as avaliações do mês
final avaliacoes = membros.map((m) => useCase.calcular(dados)).toList();

// Normalizar para que a maior nota seja 100
final avaliacoesNormalizadas = useCase.normalizarNotas(avaliacoes);

// Ordenar por nota final (ranking)
avaliacoesNormalizadas.sort((a, b) => b.notaFinal.compareTo(a.notaFinal));
```

## 📅 Fluxo Mensal

### 1º dia do mês:

1. Secretaria registra presença/ausências do mês anterior
2. Tesouraria atualiza situação de mensalidades
3. Líderes de grupos-tarefa dão conceitos
4. Líderes de grupos de ação social dão conceitos
5. Pais/mães de terreiro dão conceitos
6. Tata dá bônus
7. Sistema calcula avaliações automaticamente
8. Relatórios são gerados por núcleo

## 🎨 Funcionalidades Implementadas

- ✅ Cadastro completo de membros com todas classificações
- ✅ Calendário mensal de atividades
- ✅ Registro de presenças
- ✅ Cálculo automático das 12 notas
- ✅ Normalização para nota 0-100
- ✅ Separação por núcleo (CCU/CPO)
- ✅ Ranking mensal
- ✅ Histórico de avaliações
- ✅ Integração com Supabase

## 📂 Estrutura do Package

```
lib/
├── src/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── membro_avaliacao.dart
│   │   │   ├── avaliacao_mensal.dart
│   │   │   └── calendario.dart
│   │   ├── services/
│   │   │   ├── calculador_nota_a.dart
│   │   │   └── calculadores_notas.dart (B-L)
│   │   └── usecases/
│   │       └── calcular_avaliacao_mensal_usecase.dart
│   ├── data/
│   │   ├── models/
│   │   ├── datasources/
│   │   └── repositories/
│   └── presentation/
│       ├── pages/
│       ├── widgets/
│       └── bloc/
└── sistema_ponto.dart
```

## 🗄️ Banco de Dados

Execute o schema SQL em `database/schema.sql` no Supabase para criar:

- `membros_avaliacao`
- `calendario_atividades`
- `registros_presenca`
- `avaliacoes_mensais`
- `conceitos_lideres`
- `conceitos_pais_maes`
- `bonus_tata`

## 🔔 Notificações Automáticas

O sistema pode enviar lembretes automáticos no 1º dia do mês para:

- Secretaria: registrar presenças
- Tesouraria: atualizar mensalidades
- Líderes: dar conceitos
- Pais/mães: avaliar membros
- Tata: dar bônus

## 📈 Relatórios Disponíveis

- Ranking mensal por núcleo
- Evolução individual ao longo dos meses
- Comparativo entre núcleos
- Estatísticas por categoria de nota
- Membros em situação crítica (nota baixa)

---

**Nota**: Este sistema substitui completamente o anterior de "ponto de entrada/saída" por um sistema de avaliação mensal completo e robusto.
