# 🔑 Como Copiar a Chave do Supabase

## Passo a Passo com Base na Sua Imagem

Na captura de tela que você enviou, siga exatamente estes passos:

### 1. Localize a Seção "Publishable key"

Na sua imagem, você pode ver a seção **"Publishable key"** logo abaixo do aviso azul.

### 2. Copie a Chave "default"

- Clique no ícone de **copiar** (📋) ao lado da chave que aparece na linha "default"
- A chave é aquele texto longo que começa com `eyJ...`
- Na sua imagem, parte da chave visível é: `...yAk8slUIGE6ra%3jlmWTA_JzkZ...`

### 3. Cole no Arquivo

Abra o arquivo:

```
lib/core/constants/supabase_constants.dart
```

E substitua esta linha:

```dart
static const String supabaseAnonKey = 'YOUR_SUPABASE_PUBLISHABLE_KEY_HERE';
```

Por:

```dart
static const String supabaseAnonKey = 'eyJhbG...COLE_AQUI_A_CHAVE_COMPLETA';
```

## ⚠️ IMPORTANTE - NÃO Use a Secret Key!

Na sua imagem também aparece a **"Secret key"** (chave secreta).

- ❌ **NÃO copie a Secret key!**
- ❌ Ela só deve ser usada em servidores backend
- ✅ Use apenas a **Publishable key** (a primeira, que está visível)

## Pronto!

Depois de colar a chave, seu app estará conectado ao Supabase! 🎉

A chave Publishable é segura para uso em aplicativos mobile e web porque ela só permite operações que você configurar nas políticas RLS (Row Level Security) do Supabase.
