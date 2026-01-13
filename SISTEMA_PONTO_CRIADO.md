# Sistema de Avaliação Mensal - Package Criado! ✅

O módulo de **Sistema de Avaliação Mensal** foi criado como um package local em `packages/sistema_ponto/`.

## 📊 O que é este Sistema?

Um sistema completo de avaliação mensal de membros baseado em **12 categorias de notas (A-L)**, que considera:

- ✅ Frequência em sessões mediúnicas
- ✅ Participação em atividades espirituais
- ✅ Atuação em grupos de trabalho, tarefas e ações sociais
- ✅ Avaliações de líderes e pais/mães de terreiro
- ✅ Assiduidade financeira
- ✅ Bônus por cargos de liderança
- ✅ Histórico de performance (nota do mês anterior)

## 🏗️ Arquitetura Implementada

### Domain Layer (Regras de Negócio)

**Entidades:**

- `MembroAvaliacao`: Cadastro completo com classificação, grupos, cargos
- `AvaliacaoMensal`: Resultado das 12 notas (A-L) + cálculos
- `AtividadeCalendario`: Calendário mensal de eventos
- `RegistroPresenca`: Controle de presenças em atividades

**Serviços de Cálculo:**

- `CalculadorNotaA`: Frequência em sessões mediúnicas (regras por classificação)
- `CalculadorNotaB`: Frequência em atividades espirituais
- `CalculadorNotaC`: Conceito de grupo-tarefa
- `CalculadorNotaD`: Conceito de grupo de ação social
- `CalculadorNotaE`: Assistência a instruções espirituais
- `CalculadorNotaF`: Presença em escalas de cambonagem
- `CalculadorNotaG`: Presença em escalas de arrumação/desarrumação
- `CalculadorNotaH`: Assiduidade de pagamento
- `CalculadorNotaI`: Conceito do pai/mãe de terreiro
- `CalculadorNotaJ`: Bônus do Tata
- `CalculadorNotaK`: Nota do mês anterior
- `CalculadorNotaL`: Bônus por liderança

**UseCase:**

- `CalcularAvaliacaoMensalUseCase`: Orquestra todos os cálculos e normaliza notas

### Data Layer (próximo passo)

- Models para serialização JSON
- Datasources para Supabase
- Implementação de repositórios

### Presentation Layer (próximo passo)

- Telas de cadastro de membros
- Formulários de entrada de dados mensais
- Visualização de rankings
- Relatórios e históricos

## 📋 Estrutura das Notas

### Nota Real (Somatório)

```
Nota Real = A + B + C + D + E + F + G + H + I + J + K + L
```

Pode ultrapassar 100 pontos (exemplo: 118 pontos)

### Nota Final (Normalizada 0-100)

```
Nota Final = (Nota Real / Maior Nota Real do Mês) × 100
```

A maior nota do mês sempre será 100, e as demais proporcionais.

## 🗄️ Banco de Dados

### Tabelas Criadas (schema.sql)

1. **membros_avaliacao** - Cadastro completo dos membros
2. **calendario_atividades** - Eventos do mês
3. **registros_presenca** - Controle de presenças
4. **avaliacoes_mensais** - Resultado das avaliações (notas A-L)
5. **conceitos_lideres** - Notas dadas por líderes
6. **conceitos_pais_maes** - Notas dadas por pais/mães de terreiro
7. **bonus_tata** - Bônus dados pelo Tata

## 🚀 Próximos Passos

### 1. Executar SQL no Supabase

```sql
-- Execute o arquivo: packages/sistema_ponto/database/schema.sql
```

### 2. Implementar Data Layer

- [ ] Criar models para todas as entidades
- [ ] Criar datasources para Supabase
- [ ] Implementar repositórios

### 3. Implementar Presentation Layer

- [ ] Tela de cadastro de membros
- [ ] Calendário mensal de atividades
- [ ] Formulário de registro de presenças
- [ ] Formulário para líderes darem conceitos
- [ ] Formulário para pais/mães avaliarem
- [ ] Formulário para Tata dar bônus
- [ ] Tela de ranking mensal (por núcleo)
- [ ] Histórico de avaliações
- [ ] Relatórios e gráficos

### 4. Automatizações

- [ ] Notificação automática no 1º dia do mês
- [ ] Cálculo automático quando todos dados inseridos
- [ ] Envio de relatórios por email
- [ ] Dashboard administrativo

## 📊 Fluxo de Uso Mensal

### Último dia do mês (ou 1º dia do próximo):

**1. Secretaria registra:**

- ✍️ Presenças em sessões mediúnicas
- ✍️ Presenças em atendimentos públicos
- ✍️ Presenças em COR/Ramatis
- ✍️ Presenças em grupos de trabalho
- ✍️ Cumprimento de escalas (cambonagem/arrumação)

**2. Tesouraria atualiza:**

- 💰 Situação de mensalidade de cada membro (em dia/atrasado)

**3. Líderes de Grupos-Tarefa avaliam:**

- 📝 Conceito 0-10 para cada membro do grupo

**4. Líderes de Grupos de Ação Social avaliam:**

- 📝 Conceito 0-10 para membros sem grupo-tarefa

**5. Pais/Mães de Terreiro avaliam:**

- 👨‍👩‍👧‍👦 Conceito 0-10 para seus filhos espirituais

**6. Tata dá bônus:**

- ⭐ Bônus 0-10 para membros que merecem destaque

**7. Sistema calcula automaticamente:**

- 🤖 Notas A-L para cada membro
- 🤖 Nota real (somatório)
- 🤖 Nota final (normalizada)
- 🤖 Rankings por núcleo

**8. Relatórios são gerados:**

- 📈 Ranking CCU
- 📈 Ranking CPO
- 📧 Envio para interessados

## 💡 Exemplo Prático

### Membro: João Silva

**Classificação:** Grau Verde | **Núcleo:** CCU

#### Notas do Mês:

- **Nota A** (Sessões): 10.0 - Compareceu a 2 atendimentos públicos
- **Nota B** (Atividades): 10.0 - Compareceu ao Grupo Paz
- **Nota C** (Grupo-Tarefa): 8.5 - Conceito do líder de Vendas
- **Nota D** (Ação Social): 10.0 - Já pertence a grupo-tarefa
- **Nota E** (Instruções): 10.0 - Presente em 2 CORs
- **Nota F** (Cambonagem): 10.0 - Não escalado
- **Nota G** (Arrumação): 10.0 - Compareceu à escala
- **Nota H** (Mensalidade): 10.0 - Em dia
- **Nota I** (Pai/Mãe): 9.0 - Conceito do pai de terreiro
- **Nota J** (Tata): 7.0 - Bônus por dedicação
- **Nota K** (Mês Anterior): 88.5 - Nota final do mês passado
- **Nota L** (Liderança): 5.0 - Líder de grupo-tarefa

#### Cálculo:

```
Nota Real = 10 + 10 + 8.5 + 10 + 10 + 10 + 10 + 10 + 9 + 7 + 88.5 + 5
Nota Real = 188.0 pontos

Se a maior nota do mês foi 200:
Nota Final = (188 / 200) × 100 = 94.0
```

## 🎯 Diferenciais do Sistema

1. **Transparência**: Todas as regras são claras e documentadas
2. **Automação**: Cálculos complexos feitos pelo sistema
3. **Justiça**: Regras diferentes por classificação mediúnica
4. **Histórico**: Acompanhamento da evolução mensal
5. **Reconhecimento**: Bônus por liderança e dedicação
6. **Integração**: Futuro link com cadastro da Claudia

## ⚠️ Importantes Observações

### Regras Especiais:

- **Cambono/Curimbeiro/Vermelho/Coral**: Avaliados por sessões do seu dia
- **Grau Amarelo**: Avaliados por sessões E atendimentos
- **Verde ou superior**: Avaliados principalmente por atendimentos públicos

### Normalização:

- Sistema permite notas reais acima de 100
- Nota final sempre 0-100 (relativa ao melhor do mês)
- Rankings gerados separados por núcleo

### Flexibilidade:

- Grupos sem atividade no mês: membro não é prejudicado
- Trocas de escala são consideradas como presença
- Justificativas podem ser registradas

---

**Status**: ⚙️ Domain Layer implementado | Data e Presentation em desenvolvimento  
**Próximo passo**: Implementar models e datasources do Supabase

## 📁 Estrutura Criada

```
packages/sistema_ponto/
├── lib/
│   ├── sistema_ponto.dart (export principal)
│   └── src/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── registro_ponto.dart
│       │   ├── repositories/
│       │   │   └── ponto_repository.dart
│       │   └── usecases/
│       │       ├── registrar_ponto_usecase.dart
│       │       └── obter_historico_ponto_usecase.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── registro_ponto_model.dart
│       │   ├── datasources/
│       │   │   └── ponto_datasource.dart
│       │   └── repositories/
│       │       └── ponto_repository_impl.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── ponto_bloc.dart
│           │   ├── ponto_event.dart
│           │   └── ponto_state.dart
│           └── pages/
│               ├── registrar_ponto_page.dart
│               └── historico_ponto_page.dart
├── database/
│   └── schema.sql (SQL para criar tabela no Supabase)
├── pubspec.yaml
├── README.md
└── INTEGRATION_GUIDE.md
```

## 🚀 Próximos Passos

### 1. Criar a tabela no Supabase

Execute o SQL em `packages/sistema_ponto/database/schema.sql` no Supabase:

```sql
-- Copie e cole o conteúdo do arquivo schema.sql no SQL Editor do Supabase
```

### 2. Configurar Injeção de Dependências

Edite `lib/core/di/injection_container.dart`:

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

Future<void> init() async {
  // ... código existente ...

  // Sistema de Ponto - Datasource
  sl.registerLazySingleton<PontoDatasource>(
    () => SupabasePontoDatasource(sl<SupabaseService>().client),
  );

  // Sistema de Ponto - Repository
  sl.registerLazySingleton<PontoRepository>(
    () => PontoRepositoryImpl(sl<PontoDatasource>()),
  );

  // Sistema de Ponto - UseCases
  sl.registerLazySingleton(() => RegistrarPontoUseCase(sl<PontoRepository>()));
  sl.registerLazySingleton(() => ObterHistoricoPontoUseCase(sl<PontoRepository>()));

  // Sistema de Ponto - BLoC
  sl.registerFactory(
    () => PontoBloc(
      registrarPontoUseCase: sl<RegistrarPontoUseCase>(),
      obterHistoricoUseCase: sl<ObterHistoricoPontoUseCase>(),
      repository: sl<PontoRepository>(),
    ),
  );
}
```

### 3. Adicionar Rotas no main.dart

Edite `lib/main.dart` para adicionar as rotas:

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

// Dentro de getPages:
getPages: [
  // ... rotas existentes ...

  // Rotas do Sistema de Ponto
  GetPage(
    name: '/ponto/registrar',
    page: () => BlocProvider(
      create: (_) => di.sl<PontoBloc>(),
      child: const RegistrarPontoPage(),
    ),
  ),
  GetPage(
    name: '/ponto/historico',
    page: () => BlocProvider(
      create: (_) => di.sl<PontoBloc>(),
      child: const HistoricoPontoPage(),
    ),
  ),
],
```

### 4. Adicionar no Menu da Home

Edite a HomePage para adicionar acesso ao sistema de ponto:

```dart
// Exemplo de botão para registrar ponto
ElevatedButton.icon(
  onPressed: () {
    Get.toNamed(
      '/ponto/registrar',
      arguments: {
        'membroId': 'uuid-do-membro',
        'membroNome': 'Nome do Membro',
      },
    );
  },
  icon: const Icon(Icons.access_time),
  label: const Text('Registrar Ponto'),
),

// Exemplo de botão para ver histórico
ElevatedButton.icon(
  onPressed: () {
    Get.toNamed(
      '/ponto/historico',
      arguments: {
        'membroId': 'uuid-do-membro',
        'membroNome': 'Nome do Membro',
      },
    );
  },
  icon: const Icon(Icons.history),
  label: const Text('Histórico de Ponto'),
),
```

## 🎯 Funcionalidades Implementadas

### Tipos de Registro

- ✅ Entrada
- ✅ Saída
- ✅ Saída para Almoço
- ✅ Retorno do Almoço

### Recursos

- ✅ Registro manual ou automático
- ✅ Localização opcional
- ✅ Observações
- ✅ Justificativas
- ✅ Histórico com filtro por período
- ✅ Relatórios de presença
- ✅ Integração com Supabase
- ✅ State Management com BLoC
- ✅ Clean Architecture

## 📝 Exemplo de Uso Direto

Se preferir usar direto sem navegação:

```dart
import 'package:sistema_ponto/sistema_ponto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Na sua tela
BlocProvider(
  create: (_) => di.sl<PontoBloc>(),
  child: RegistrarPontoPage(
    membroId: 'uuid-do-membro',
    membroNome: 'João Silva',
  ),
)
```

## 🔧 Customização

O package é totalmente customizável. Você pode:

- Adicionar novos tipos de ponto
- Modificar as validações
- Adicionar novos campos
- Criar relatórios personalizados
- Exportar dados para Excel

## 📚 Documentação

Veja mais detalhes em:

- `packages/sistema_ponto/README.md` - Visão geral do package
- `packages/sistema_ponto/INTEGRATION_GUIDE.md` - Guia de integração completo
- `packages/sistema_ponto/database/schema.sql` - Schema do banco de dados

## ✨ Vantagens do Package

1. **Modular**: Isolado do resto da aplicação
2. **Reutilizável**: Pode ser usado em outros projetos
3. **Testável**: Fácil de testar unitariamente
4. **Manutenível**: Código organizado e bem estruturado
5. **Escalável**: Fácil de adicionar novas funcionalidades

## 🐛 Próximas Melhorias Sugeridas

- [ ] Adicionar testes unitários
- [ ] Implementar geolocalização automática
- [ ] Adicionar notificações de lembrete
- [ ] Criar dashboard de estatísticas
- [ ] Exportar relatórios em PDF/Excel
- [ ] Adicionar autenticação biométrica
- [ ] Implementar modo offline com sincronização

---

**Status**: ✅ Package criado e instalado com sucesso!
**Próximo passo**: Executar o SQL no Supabase e configurar a injeção de dependências.
