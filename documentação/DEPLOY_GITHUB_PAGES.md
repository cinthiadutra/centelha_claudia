# Deploy no GitHub Pages

O deploy é feito pelo workflow `.github/workflows/deploy.yml`, usando as ações
oficiais do GitHub Pages. Um push na branch `main` inicia o build e a publicação;
também é possível iniciar o workflow manualmente pela aba **Actions**.

## Configuração necessária no GitHub

No repositório, acesse **Settings > Pages > Build and deployment** e selecione
**GitHub Actions** como fonte. Essa mudança é necessária porque o deploy deixou
de publicar os arquivos diretamente na branch `gh-pages`.

## Build local

O projeto usa Flutter `3.47.5` no workflow e fixa as dependências pelo
`pubspec.lock`:

```bash
flutter pub get --enforce-lockfile
flutter build web --release --base-href /centelha_claudia/
```

O `base-href` corresponde ao nome deste repositório. Se o repositório for
renomeado, atualize esse caminho no workflow e no comando acima.
