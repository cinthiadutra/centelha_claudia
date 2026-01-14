# 🔐 Sistema de Autenticação e Menus - CENTELHA CLAUDIA

## 🎯 Visão Geral

Sistema completo de autenticação com controle de permissões por níveis de acesso e menu lateral dinâmico baseado nas permissões do usuário.

## 👤 Níveis de Acesso

### Nível 1 - Membros Ativos

- Acesso básico ao sistema
- Visualização de informações gerais

### Nível 2 - Membros da Secretaria

- Todas as permissões do Nível 1
- Gerenciamento de cadastros
- Gerenciamento de membros
- Gestão de consultas
- Gestão de grupos
- Gestão de cursos

### Nível 3 - Pais e Mães de Terreiro

- Todas as permissões do Nível 2
- Gerenciamento de sacramentos
- Exclusão de cadastros

### Nível 4 - Administrador do Sistema

- Todas as permissões
- Gerenciamento de usuários do sistema
- Gestão da organização (núcleos, grupos, etc.)

## 🔑 Usuários de Teste

```
Login: admin      | Senha: 123456 | Nível: Administrador
Login: pai        | Senha: 123456 | Nível: Pai/Mãe de Terreiro
Login: secretaria | Senha: 123456 | Nível: Membro da Secretaria
Login: membro     | Senha: 123456 | Nível: Membro Ativo
```

## 📋 Estrutura de Menus

### 1. CADASTROS (Nível 2+)

```
├── Cadastrar
├── Pesquisar Cadastro
├── Editar Cadastro
└── Excluir Cadastro (Nível 3+)
```

### 2. MEMBROS DA CENTELHA (Nível 2+)

```
├── Incluir Novo Membro
├── Pesquisar Dados de Membro
├── Editar Dados de Membro
└── Gerar Relatórios de Membros
```

### 3. HISTÓRICO DE CONSULTAS (Nível 2+)

```
├── Nova Consulta
├── Pesquisar Consulta
└── Ler Consultas
```

### 4. GRUPOS-TAREFAS (Nível 2+)

```
├── Gerenciar Membros
└── Gerar Relatórios
```

### 5. GRUPOS DE AÇÕES SOCIAIS (Nível 2+)

```
├── Gerenciar Membros
└── Gerar Relatórios
```

### 6. GRUPOS DE TRABALHOS ESPIRITUAIS (Nível 2+)

```
├── Gerenciar Membros
└── Gerar Relatórios
```

### 7. SACRAMENTOS (Nível 3+)

```
├── Batismo
├── Casamento
├── Jogo de Orixá
├── Camarinhas
├── Coroação Sacerdotal
└── Relatórios
```

### 8. CURSOS E TREINAMENTOS (Nível 2+)

```
├── Criar Novo Curso
├── Abrir Nova Turma
├── Inscrição em Curso
├── Lançar Notas
└── Relatórios de Cursos
```

### 9. USUÁRIOS DO SISTEMA (Nível 4 - Admin)

```
├── Cadastrar Novo Usuário
├── Excluir Usuário
├── Ver Usuários Cadastrados
└── Ver Acessos de Usuários
```

### 10. ORGANIZAÇÃO DA CENTELHA (Nível 4 - Admin)

```
├── Incluir Núcleo
├── Excluir Núcleo
├── Incluir Dia de Sessão
├── Excluir Dia de Sessão
├── Incluir Grupo-Tarefa
├── Excluir Grupo-Tarefa
├── Incluir Grupo de Ação Social
├── Excluir Grupo de Ação Social
├── Incluir Grupo de Trabalho Espiritual
└── Excluir Grupo de Trabalho Espiritual
```

## 🏗️ Arquitetura

### Estrutura de Arquivos

```
lib/
├── modules/
│   ├── auth/                          # Módulo de Autenticação
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── usuario_sistema_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── usuario_sistema.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           └── login_page.dart
│   │
│   └── home/                          # Tela Principal
│       └── presentation/
│           └── pages/
│               └── home_page.dart
│
└── core/
    └── navigation/
        └── app_menus.dart             # Definição dos menus
```

## 🔧 Como Funciona

### 1. Autenticação

```dart
// Login
context.read<AuthBloc>().add(
  LoginEvent(login: 'admin', senha: '123456')
);

// Logout
context.read<AuthBloc>().add(LogoutEvent());

// Verificar se está autenticado
context.read<AuthBloc>().add(CheckAuthEvent());
```

### 2. Controle de Permissões

```dart
// Verificar se usuário tem permissão
bool temPermissao = usuario.temPermissao(NivelAcesso.nivel3);

// No menu item
const MenuItem(
  title: 'Excluir Cadastro',
  icon: 'delete',
  route: '/cadastros/excluir',
  nivelRequerido: NivelAcesso.nivel3, // Apenas Nível 3+
)
```

### 3. Menu Dinâmico

O menu lateral é filtrado automaticamente baseado no nível de acesso do usuário:

```dart
// Filtra menus permitidos
final menuItems = AppMenus.menuItems
    .where((item) => item.temPermissao(usuario.nivelAcesso))
    .toList();
```

## 🎨 Componentes UI

### LoginPage

- Formulário de login com validação
- Feedback visual de erros
- Loading state
- Informações de usuários de teste

### HomePage

- AppBar com informações do usuário
- Botão de logout
- Drawer com menu lateral
- Dashboard central

### AppDrawer

- Header com avatar e informações do usuário
- Menus expansíveis organizados por categoria
- Ícones para cada item
- Filtragem automática por permissão
- Opção de logout

## 📱 Fluxo de Navegação

```
┌─────────────┐
│ Login Page  │
└──────┬──────┘
       │ (autenticado)
       ▼
┌─────────────┐
│  Home Page  │
│  + Drawer   │
└──────┬──────┘
       │
       ├─► Cadastros
       ├─► Membros
       ├─► Consultas
       ├─► Grupos
       ├─► Sacramentos
       ├─► Cursos
       ├─► Usuários Sistema (Admin)
       └─► Organização (Admin)
```

## 🔒 Segurança

### Implementado

✅ Login obrigatório para acesso
✅ Controle de sessão via BLoC
✅ Filtragem de menus por permissão
✅ Validação de credenciais
✅ Estado de autenticação persistente na sessão

### Para Implementar (API Real)

- [ ] JWT Tokens
- [ ] Refresh token
- [ ] Timeout de sessão
- [ ] Criptografia de senha
- [ ] 2FA (opcional)
- [ ] Logs de acesso
- [ ] Bloqueio após tentativas falhas

## 🚀 Próximos Passos

### 1. Implementar Rotas

```dart
// Adicionar navegação real em vez de dialogs
Navigator.pushNamed(context, route);
```

### 2. Criar Páginas para Cada Menu

Estrutura sugerida:

```
lib/modules/
├── membros/
│   └── presentation/
│       └── pages/
│           ├── incluir_membro_page.dart
│           ├── pesquisar_membro_page.dart
│           └── editar_membro_page.dart
├── consultas/
├── grupos/
├── sacramentos/
├── cursos/
└── organizacao/
```

### 3. Implementar Middleware de Permissões

```dart
class PermissionGuard {
  static bool canAccess(String route, UsuarioSistema usuario) {
    // Lógica de verificação
  }
}
```

### 4. Conectar com API Real

```dart
class AuthDatasourceRemote implements AuthDatasource {
  final Dio dio;

  @override
  Future<UsuarioSistemaModel> login(String login, String senha) async {
    final response = await dio.post('/auth/login', data: {
      'login': login,
      'senha': senha,
    });

    return UsuarioSistemaModel.fromJson(response.data);
  }
}
```

## 📝 Exemplo de Uso

```dart
// Na HomePage, verificar nível do usuário
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      if (state.usuario.nivelAcesso == NivelAcesso.nivel4) {
        // Mostrar opções de admin
      }
    }
  },
)
```

## 🎓 Boas Práticas

1. **Sempre verificar autenticação** antes de exibir conteúdo sensível
2. **Validar permissões** tanto no frontend quanto backend
3. **Nunca confiar apenas na UI** - validar no servidor
4. **Manter logs de acesso** para auditoria
5. **Implementar timeout de sessão** para segurança

---

**Sistema de autenticação e menus completo e funcional! 🎉**

O menu lateral se adapta automaticamente ao nível de acesso do usuário logado.
