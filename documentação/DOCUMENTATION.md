# Centelha Claudia - Módulo de Cadastro

## 📋 Sobre o Projeto

Aplicação Flutter Web modular com arquitetura limpa (Clean Architecture), preparada para expansão com múltiplos microserviços.

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com a seguinte estrutura:

```
lib/
├── core/                           # Núcleo compartilhado
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Gestão de erros
│   │   └── failures.dart
│   └── utils/                     # Utilitários
│       └── either.dart
│
└── modules/                       # Módulos da aplicação
    └── cadastro/                  # Módulo de Cadastro
        ├── data/                  # Camada de Dados
        │   ├── datasources/       # Fontes de dados
        │   │   └── usuario_datasource.dart (mockado)
        │   ├── models/            # Models de dados
        │   │   └── usuario_model.dart
        │   └── repositories/      # Implementação dos repositórios
        │       └── usuario_repository_impl.dart
        │
        ├── domain/                # Camada de Domínio
        │   ├── entities/          # Entidades de negócio
        │   │   └── usuario.dart
        │   └── repositories/      # Interfaces dos repositórios
        │       └── usuario_repository.dart
        │
        └── presentation/          # Camada de Apresentação
            ├── bloc/              # Gerenciamento de estado
            │   ├── usuario_bloc.dart
            │   ├── usuario_event.dart
            │   └── usuario_state.dart
            └── pages/             # Telas da aplicação
                ├── usuario_list_page.dart
                └── usuario_form_page.dart
```

## 🎯 Camadas da Arquitetura

### 1. **Domain (Domínio)**
- Contém as regras de negócio puras
- Independente de frameworks e tecnologias
- Define as entidades e interfaces dos repositórios

### 2. **Data (Dados)**
- Implementa os repositórios definidos no domínio
- Gerencia as fontes de dados (datasources)
- Converte models para entidades

### 3. **Presentation (Apresentação)**
- Gerencia a UI e interações do usuário
- Usa BLoC para gerenciamento de estado
- Reage aos estados emitidos pelo BLoC

## 🔧 Tecnologias Utilizadas

- **Flutter** - Framework principal
- **flutter_bloc** - Gerenciamento de estado
- **get_it** - Injeção de dependências
- **equatable** - Comparação de objetos
- **dio** - HTTP client (preparado para futura integração com API)
- **uuid** - Geração de IDs únicos

## 📦 Módulo de Cadastro

### Funcionalidades Implementadas

✅ Listagem de usuários
✅ Cadastro de novos usuários
✅ Edição de usuários existentes
✅ Exclusão de usuários
✅ Validação de formulários
✅ Feedback visual (loading, erros, sucesso)

### Campos do Usuário

- **Nome** (obrigatório)
- **Email** (obrigatório)
- **Telefone** (opcional)
- **CPF** (opcional)
- **Status Ativo** (toggle)
- **Data de Cadastro** (automático)

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.9.2 ou superior
- Navegador web (Chrome recomendado)

### Instalação

```bash
# Clonar o repositório (se aplicável)
git clone [url-do-repositorio]

# Navegar para o diretório
cd centelha_claudia

# Instalar dependências
flutter pub get

# Executar em modo web
flutter run -d chrome
```

## 🔄 Preparação para API Real

Atualmente, o datasource está **mockado** com dados em memória. Para conectar com uma API real:

### 1. Criar novo datasource remoto

```dart
// lib/modules/cadastro/data/datasources/usuario_datasource_remote.dart

class UsuarioDatasourceRemote implements UsuarioDatasource {
  final Dio dio;
  
  UsuarioDatasourceRemote({required this.dio});
  
  @override
  Future<List<UsuarioModel>> getUsuarios() async {
    final response = await dio.get('/api/usuarios');
    return (response.data as List)
        .map((json) => UsuarioModel.fromJson(json))
        .toList();
  }
  
  // Implementar outros métodos...
}
```

### 2. Atualizar injection_container.dart

```dart
// Trocar de:
sl.registerLazySingleton<UsuarioDatasource>(
  () => UsuarioDatasourceMock(),
);

// Para:
sl.registerLazySingleton<UsuarioDatasource>(
  () => UsuarioDatasourceRemote(dio: sl()),
);
```

### 3. Configurar Dio

```dart
sl.registerLazySingleton(() => Dio(
  BaseOptions(
    baseUrl: 'https://sua-api.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
));
```

## 🎨 Personalização

### Temas

Edite o tema em `main.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple, // Alterar cor principal
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

## 📋 Próximos Passos

### Novos Módulos (Microserviços)

Para adicionar novos módulos, replique a estrutura:

```
lib/modules/
├── cadastro/           # ✅ Implementado
├── vendas/             # 🔜 Próximo módulo
├── estoque/            # 🔜 Próximo módulo
└── relatorios/         # 🔜 Próximo módulo
```

### Melhorias Sugeridas

- [ ] Adicionar testes unitários
- [ ] Adicionar testes de widget
- [ ] Implementar paginação na listagem
- [ ] Adicionar filtros e busca
- [ ] Implementar autenticação
- [ ] Adicionar validação de CPF
- [ ] Implementar máscara nos campos (telefone, CPF)
- [ ] Adicionar logs e analytics
- [ ] Implementar cache local
- [ ] Adicionar internacionalização (i18n)

## 📝 Convenções de Código

- Use nomes descritivos em português para entidades de negócio
- Mantenha classes pequenas e com responsabilidade única
- Sempre valide inputs do usuário
- Trate erros adequadamente em todas as camadas
- Comente código complexo quando necessário

## 🤝 Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
2. Commit suas mudanças (`git commit -m 'Add: Nova funcionalidade'`)
3. Push para a branch (`git push origin feature/NovaFuncionalidade`)
4. Abra um Pull Request

## 📄 Licença

Este projeto é privado e confidencial.

---

**Desenvolvido com ❤️ usando Flutter**
