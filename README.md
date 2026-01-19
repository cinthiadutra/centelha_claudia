# Centelha Claudia

Um projeto Flutter para gerenciamento de sistema de ponto.

## 🚀 Deploy no GitHub Pages

Este projeto está configurado para fazer deploy automático no GitHub Pages sempre que há um push na branch `main`.

### Como funciona

O deploy é feito automaticamente através do GitHub Actions (`.github/workflows/deploy.yml`). O workflow:
1. Configura o ambiente Flutter
2. Instala as dependências do projeto
3. Compila a aplicação web em modo release
4. Publica os arquivos no GitHub Pages

### Acessar a aplicação

Após o deploy, a aplicação estará disponível em:
```
https://cinthiadutra.github.io/centelha_claudia/
```

### Deploy manual

Para fazer deploy manualmente, você pode:
1. Ir até a aba "Actions" no GitHub
2. Selecionar o workflow "Deploy to GitHub Pages"
3. Clicar em "Run workflow"

### Configuração do GitHub Pages

Certifique-se de que o GitHub Pages está configurado para usar a branch `gh-pages`:
1. Acesse as configurações do repositório no GitHub
2. Vá em "Pages" na barra lateral
3. Em "Source", selecione a branch `gh-pages` e a pasta `/ (root)`
4. Clique em "Save"

## 🛠️ Desenvolvimento Local

### Pré-requisitos
- Flutter SDK ^3.9.2
- Dart SDK

### Executar o projeto

```bash
# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Executar versão web
flutter run -d chrome
```

### Build para web

```bash
# Build para produção
flutter build web --release

# Build com base-href customizado
flutter build web --release --base-href /centelha_claudia/
```

## 📚 Documentação adicional

- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitetura do projeto
- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Configuração do Supabase

