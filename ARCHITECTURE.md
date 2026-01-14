# Estrutura do Projeto - Centelha Claudia

## 📁 Estrutura de Diretórios Completa

```
centelha_claudia/
│
├── lib/
│   ├── main.dart                                    # Ponto de entrada da aplicação
│   │
│   ├── core/                                        # 🔧 NÚCLEO COMPARTILHADO
│   │   ├── di/
│   │   │   └── injection_container.dart             # Configuração de injeção de dependências
│   │   ├── error/
│   │   │   └── failures.dart                        # Classes de erro padronizadas
│   │   └── utils/
│   │       └── either.dart                          # Helper para Either<Left, Right>
│   │
│   └── modules/                                     # 📦 MÓDULOS DA APLICAÇÃO
│       │
│       └── cadastro/                                # MÓDULO DE CADASTRO
│           │
│           ├── data/                                # 💾 CAMADA DE DADOS
│           │   ├── datasources/
│           │   │   └── usuario_datasource.dart      # Interface + Mock (preparado para API)
│           │   ├── models/
│           │   │   └── usuario_model.dart           # Model com toJson/fromJson
│           │   └── repositories/
│           │       └── usuario_repository_impl.dart # Implementação do repositório
│           │
│           ├── domain/                              # 🎯 CAMADA DE DOMÍNIO (Regras de Negócio)
│           │   ├── entities/
│           │   │   └── usuario.dart                 # Entidade pura de negócio
│           │   └── repositories/
│           │       └── usuario_repository.dart      # Interface do repositório
│           │
│           └── presentation/                        # 🎨 CAMADA DE APRESENTAÇÃO
│               ├── bloc/
│               │   ├── usuario_bloc.dart            # Lógica de gerenciamento de estado
│               │   ├── usuario_event.dart           # Eventos do usuário
│               │   └── usuario_state.dart           # Estados da UI
│               └── pages/
│                   ├── usuario_list_page.dart       # Tela de listagem
│                   └── usuario_form_page.dart       # Tela de cadastro/edição
│
├── pubspec.yaml                                     # Dependências do projeto
├── README.md                                        # Documentação principal
└── DOCUMENTATION.md                                 # Documentação detalhada
```

## 🔄 Fluxo de Dados

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  ┌────────────────┐          ┌──────────────────────────────┐  │
│  │  Usuario Pages │  ◄────►  │      Usuario BLoC            │  │
│  │  - List        │          │  Events ──► Logic ──► States │  │
│  │  - Form        │          │                              │  │
│  └────────────────┘          └──────────────────────────────┘  │
│                                         │                        │
└─────────────────────────────────────────┼────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
│                    ┌────────────────────┐                        │
│                    │  Usuario Entity    │                        │
│                    │  - Business Rules  │                        │
│                    └────────────────────┘                        │
│                              │                                   │
│                    ┌────────────────────┐                        │
│                    │ Repository Interface│                       │
│                    └────────────────────┘                        │
└─────────────────────────────────────────┼────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
│                  ┌──────────────────────────┐                    │
│                  │ Repository Implementation│                    │
│                  └──────────────────────────┘                    │
│                              │                                   │
│                  ┌──────────────────────────┐                    │
│                  │   Usuario Datasource     │                    │
│                  │   - Mock (Atual)         │                    │
│                  │   - Remote (Futuro)      │                    │
│                  └──────────────────────────┘                    │
│                              │                                   │
│         ┌────────────────────┴────────────────────┐             │
│         ▼                                          ▼             │
│  ┌─────────────┐                          ┌─────────────┐       │
│  │ Mock Data   │                          │  API REST   │       │
│  │ (Memória)   │                          │  (Futuro)   │       │
│  └─────────────┘                          └─────────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 Princípios Aplicados

### 1. **Separation of Concerns**

Cada camada tem sua responsabilidade específica:

- **Presentation**: UI e interação com usuário
- **Domain**: Regras de negócio puras
- **Data**: Acesso e manipulação de dados

### 2. **Dependency Rule**

As dependências apontam sempre para dentro:

```
Presentation → Domain ← Data
```

### 3. **Dependency Injection**

Uso do GetIt para inversão de controle:

```dart
// Registrar
sl.registerLazySingleton<Repository>(() => RepositoryImpl());

// Usar
final repository = sl<Repository>();
```

## 📊 Estados do BLoC

```
┌──────────────┐
│   Initial    │  ← Estado inicial
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Loading    │  ← Carregando dados
└──────┬───────┘
       │
       ├──────────────┐
       ▼              ▼
┌──────────────┐  ┌──────────────┐
│   Loaded     │  │    Error     │
│  (Success)   │  │   (Failure)  │
└──────────────┘  └──────────────┘
```

## 🔌 Preparação para Microserviços

### Estrutura Modular Extensível

```
lib/modules/
│
├── cadastro/           ✅ Implementado
│   ├── data/
│   ├── domain/
│   └── presentation/
│
├── vendas/             🔜 Próximo
│   ├── data/
│   ├── domain/
│   └── presentation/
│
├── estoque/            🔜 Futuro
│   ├── data/
│   ├── domain/
│   └── presentation/
│
└── relatorios/         🔜 Futuro
    ├── data/
    ├── domain/
    └── presentation/
```

### Vantagens da Arquitetura

✅ **Independência**: Cada módulo pode ser desenvolvido separadamente
✅ **Testabilidade**: Camadas desacopladas facilitam testes
✅ **Manutenibilidade**: Mudanças isoladas por módulo
✅ **Escalabilidade**: Fácil adicionar novos módulos
✅ **Substituibilidade**: Trocar implementações sem afetar outras camadas

## 🛠️ Tecnologias por Camada

### Presentation

- **flutter_bloc**: Gerenciamento de estado
- **equatable**: Comparação de estados

### Domain

- **equatable**: Comparação de entidades

### Data

- **dio**: HTTP client (preparado)
- **uuid**: Geração de IDs

### Core

- **get_it**: Injeção de dependências

## 📝 Convenções de Nomenclatura

### Arquivos

- `snake_case.dart` para todos os arquivos
- Sufixos descritivos: `_page.dart`, `_bloc.dart`, `_model.dart`

### Classes

- `PascalCase` para classes
- Sufixos: `Page`, `Bloc`, `Event`, `State`, `Model`, `Entity`

### Variáveis e Funções

- `camelCase` para variáveis e funções
- Português para domínio de negócio
- Inglês para código técnico

## 🎓 Aprendizados e Boas Práticas

1. **Sempre use const quando possível** - Melhora performance
2. **Valide dados em múltiplas camadas** - Segurança
3. **Use Either para resultados** - Tratamento de erros explícito
4. **Mantenha BLoCs pequenos** - Um BLoC por feature
5. **Datasource mockado primeiro** - Desenvolvimento paralelo UI/API

---

**Esta estrutura está pronta para crescer! 🚀**
