# Configuração do GitHub Pages

## Passos para habilitar o GitHub Pages

Para que o deploy automático funcione corretamente, siga estes passos:

### 1. Habilitar GitHub Pages no repositório

1. Acesse o repositório no GitHub: https://github.com/cinthiadutra/centelha_claudia
2. Clique em **Settings** (Configurações)
3. No menu lateral, clique em **Pages**
4. Em **Source** (Origem):
   - Selecione **Deploy from a branch**
   - Selecione a branch **gh-pages**
   - Selecione a pasta **/ (root)**
5. Clique em **Save** (Salvar)

### 2. Executar o workflow

Após fazer merge desta PR na branch `main`, o workflow será executado automaticamente e criará a branch `gh-pages` com os arquivos compilados.

Você também pode executar o workflow manualmente:
1. Vá para a aba **Actions**
2. Selecione o workflow **Deploy to GitHub Pages**
3. Clique em **Run workflow**
4. Selecione a branch `main`
5. Clique em **Run workflow**

### 3. Verificar o deploy

Após o workflow ser executado com sucesso:
1. Aguarde alguns minutos para o GitHub Pages processar os arquivos
2. Acesse: https://cinthiadutra.github.io/centelha_claudia/
3. A aplicação Flutter deve estar disponível

### 4. Verificar status

Para verificar o status do deploy:
1. Vá em **Settings** > **Pages**
2. Você verá uma mensagem com o link da aplicação e o status do último deploy

## Troubleshooting

### Erro 404

Se você receber um erro 404:
- Verifique se a branch `gh-pages` foi criada corretamente
- Verifique se o GitHub Pages está configurado para usar a branch `gh-pages`
- Aguarde alguns minutos após o primeiro deploy

### Arquivos não carregam

Se a aplicação carregar mas alguns arquivos não funcionarem:
- Verifique se o arquivo `.nojekyll` foi criado (o workflow já faz isso automaticamente)
- Verifique se o `base-href` está correto no workflow: `/centelha_claudia/`

### Workflow falha

Se o workflow falhar:
- Verifique os logs na aba Actions
- Certifique-se de que as permissões de escrita estão habilitadas (já configurado)
- Verifique se há erros de compilação no Flutter

## Informações adicionais

- **URL da aplicação**: https://cinthiadutra.github.io/centelha_claudia/
- **Branch de deploy**: gh-pages
- **Workflow**: `.github/workflows/deploy.yml`
- **Trigger**: Push na branch main ou execução manual
