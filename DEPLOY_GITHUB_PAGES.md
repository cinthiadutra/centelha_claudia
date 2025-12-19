# Deploy no GitHub Pages

## Passo 1: Build do projeto Flutter Web

```bash
# Gerar build de produção
flutter build web --release --base-href /centelha_claudia/
```

**Importante**: Substitua `/centelha_claudia/` pelo nome do seu repositório GitHub.

## Passo 2: Configurar repositório Git

```bash
# Se ainda não iniciou o git
git init
git add .
git commit -m "Initial commit"

# Criar repositório no GitHub primeiro, depois:
git remote add origin https://github.com/SEU_USUARIO/centelha_claudia.git
git branch -M main
git push -u origin main
```

## Passo 3: Deploy automático com GitHub Actions

Crie o arquivo `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.19.0"
          channel: "stable"

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release --base-href /centelha_claudia/

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```
