# 📊 Estrutura de Dados do Cadastro - CENTELHA

## Campos do Usuário

### ✅ Campos Obrigatórios

- **Nome** - Nome completo do usuário
- **CPF** - CPF do usuário (único identificador)

### 📝 Dados Pessoais (todos opcionais)

| Campo           | Tipo     | Descrição                                             |
| --------------- | -------- | ----------------------------------------------------- |
| numeroCadastro  | String   | Número do cadastro (gerado automaticamente: 001/2024) |
| dataNascimento  | DateTime | Data de nascimento                                    |
| telefoneFixo    | String   | Telefone fixo                                         |
| telefoneCelular | String   | Telefone celular/móvel                                |
| email           | String   | Email                                                 |
| nomeResponsavel | String   | Nome do responsável (para menores)                    |
| endereco        | String   | Endereço completo                                     |

### 🏢 Dados de Cadastro e Núcleo

| Campo          | Tipo     | Descrição                  | Opções                                 |
| -------------- | -------- | -------------------------- | -------------------------------------- |
| nucleoCadastro | String   | Núcleo em que se cadastrou | Ver UsuarioConstants                   |
| dataCadastro   | DateTime | Data do cadastro (auto)    | -                                      |
| nucleoPertence | String   | Núcleo ao qual pertence    | Ver UsuarioConstants                   |
| statusAtual    | String   | Status atual na CENTELHA   | Ativo, Inativo, Afastado, Desligado    |
| classificacao  | String   | Classificação              | Consulente, Médium, Sacerdote, Cambono |
| diaSessao      | String   | Dia de sessão              | Segunda a Domingo                      |

### 🙏 Dados de Batismo

| Campo                   | Tipo     | Descrição                   |
| ----------------------- | -------- | --------------------------- |
| dataBatismo             | DateTime | Data de batismo na CENTELHA |
| mediumCelebranteBatismo | String   | Nome do médium celebrante   |
| guiaCelebranteBatismo   | String   | Nome do Guia celebrante     |
| padrinhoBatismo         | String   | Nome do padrinho            |
| madrinhaBatismo         | String   | Nome da madrinha            |

### 💑 Dados do 1º Casamento

| Campo                             | Tipo     | Descrição                        |
| --------------------------------- | -------- | -------------------------------- |
| dataPrimeiroCasamento             | DateTime | Data do 1º casamento na CENTELHA |
| nomePrimeiroConjuge               | String   | Nome do 1º cônjuge               |
| mediumCelebrantePrimeiroCasamento | String   | Nome do médium celebrante        |
| padrinhoPrimeiroCasamento         | String   | Nome do padrinho                 |
| madrinhaPrimeiroCasamento         | String   | Nome da madrinha                 |

### 💑 Dados do 2º Casamento

| Campo                            | Tipo     | Descrição                        |
| -------------------------------- | -------- | -------------------------------- |
| dataSegundoCasamento             | DateTime | Data do 2º casamento na CENTELHA |
| nomeSegundoConjuge               | String   | Nome do 2º cônjuge               |
| mediumCelebranteSegundoCasamento | String   | Nome do médium celebrante        |
| padrinhoSegundoCasamento         | String   | Nome do padrinho                 |
| madrinhaSegundoCasamento         | String   | Nome da madrinha                 |

### 🚨 Contatos de Emergência

| Campo                     | Tipo   | Descrição                  |
| ------------------------- | ------ | -------------------------- |
| primeiroContatoEmergencia | String | 1º contato para emergência |
| segundoContatoEmergencia  | String | 2º contato para emergência |

### 📈 1º Estágio

| Campo                             | Tipo     | Descrição                     |
| --------------------------------- | -------- | ----------------------------- |
| inicioPrimeiroEstagio             | DateTime | Início do 1º estágio          |
| desistenciaPrimeiroEstagio        | DateTime | Data de desistência           |
| primeiroRitoPassagem              | DateTime | Data do 1º rito de passagem   |
| dataPrimeiroDesligamento          | DateTime | Data do 1º desligamento       |
| justificativaPrimeiroDesligamento | String   | Justificativa do desligamento |

### 📈 2º Estágio

| Campo                            | Tipo     | Descrição                     |
| -------------------------------- | -------- | ----------------------------- |
| inicioSegundoEstagio             | DateTime | Início do 2º estágio          |
| desistenciaSegundoEstagio        | DateTime | Data de desistência           |
| segundoRitoPassagem              | DateTime | Data do 2º rito de passagem   |
| dataSegundoDesligamento          | DateTime | Data do 2º desligamento       |
| justificativaSegundoDesligamento | String   | Justificativa do desligamento |

### 📈 3º Estágio

| Campo                             | Tipo     | Descrição                     |
| --------------------------------- | -------- | ----------------------------- |
| inicioTerceiroEstagio             | DateTime | Início do 3º estágio          |
| desistenciaTerceiroEstagio        | DateTime | Data de desistência           |
| terceiroRitoPassagem              | DateTime | Data do 3º rito de passagem   |
| dataTerceiroDesligamento          | DateTime | Data do 3º desligamento       |
| justificativaTerceiroDesligamento | String   | Justificativa do desligamento |

### 📈 4º Estágio

| Campo                           | Tipo     | Descrição                     |
| ------------------------------- | -------- | ----------------------------- |
| inicioQuartoEstagio             | DateTime | Início do 4º estágio          |
| desistenciaQuartoEstagio        | DateTime | Data de desistência           |
| quartoRitoPassagem              | DateTime | Data do 4º rito de passagem   |
| dataQuartoDesligamento          | DateTime | Data do 4º desligamento       |
| justificativaQuartoDesligamento | String   | Justificativa do desligamento |

### 🌟 Dados de Orixá

| Campo                | Tipo     | Descrição             | Opções                |
| -------------------- | -------- | --------------------- | --------------------- |
| dataJogoOrixa        | DateTime | Data de jogo de Orixá | -                     |
| primeiroOrixa        | String   | 1º Orixá              | Ver lista de Orixás\* |
| adjuntoPrimeiroOrixa | String   | Adjuntó do 1º Orixá   | Ver lista de Orixás\* |
| segundoOrixa         | String   | 2º Orixá              | Ver lista de Orixás\* |
| adjuntoSegundoOrixa  | String   | Adjuntó do 2º Orixá   | Ver lista de Orixás\* |
| terceiroOrixa        | String   | 3º Orixá              | Ver lista de Orixás\* |
| quartoOrixa          | String   | 4º Orixá              | Ver lista de Orixás\* |

\*_Lista de Orixás_: Exu, Ogum, Oxóssi, Ossaim, Xangô, Iansã, Oxum, Iemanjá, Nanã, Obaluaiê, Oxalá, Oxumarê, Obá, Euá, Logunedé

### 👑 Dados de Sacerdote

| Campo             | Tipo     | Descrição                     |
| ----------------- | -------- | ----------------------------- |
| coroacaoSacerdote | DateTime | Data da coroação de Sacerdote |
| primeiraCamarinha | DateTime | Data da 1ª camarinha          |
| segundaCamarinha  | DateTime | Data da 2ª camarinha          |
| terceiraCamarinha | DateTime | Data da 3ª camarinha          |

### 🎯 Atividades e Grupos

| Campo                    | Tipo   | Descrição            | Opções                                    |
| ------------------------ | ------ | -------------------- | ----------------------------------------- |
| atividadeEspiritual      | String | Atividade espiritual | Desenvolvimento Mediúnico, Consulta, etc. |
| grupoAtividadeEspiritual | String | Nome do grupo        | -                                         |
| grupoTarefa              | String | Grupo-tarefa         | -                                         |
| grupoAcaoSocial          | String | Grupo de ação social | -                                         |
| cargoLideranca           | String | Cargo de liderança   | Dirigente, Coordenador, etc.              |

## 🔧 Métodos Disponíveis

### Datasource

```dart
// Listar todos os usuários
Future<List<UsuarioModel>> getUsuarios()

// Buscar usuário por ID
Future<UsuarioModel> getUsuarioById(String id)

// Criar novo usuário
Future<UsuarioModel> createUsuario(UsuarioModel usuario)

// Atualizar usuário
Future<UsuarioModel> updateUsuario(UsuarioModel usuario)

// Deletar usuário
Future<void> deleteUsuario(String id)
```

### Repository

```dart
// Retorna Either<Failure, Success> para tratamento de erros

Future<Either<Failure, List<Usuario>>> getUsuarios()
Future<Either<Failure, Usuario>> getUsuarioById(String id)
Future<Either<Failure, Usuario>> createUsuario(Usuario usuario)
Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario)
Future<Either<Failure, void>> deleteUsuario(String id)
```

## 📋 Validações

### Campos Obrigatórios

- ✅ **Nome** - Não pode ser vazio
- ✅ **CPF** - Não pode ser vazio

### Todos os outros campos são opcionais

## 💾 Exemplo de JSON

```json
{
  "id": "1",
  "nome": "João Silva",
  "cpf": "12345678900",
  "numeroCadastro": "001/2024",
  "dataNascimento": "1990-05-15T00:00:00.000Z",
  "telefoneFixo": "1133334444",
  "telefoneCelular": "11999999999",
  "email": "joao@email.com",
  "endereco": "Rua das Flores, 123 - São Paulo/SP",
  "nucleoCadastro": "Núcleo Central",
  "dataCadastro": "2024-01-15T00:00:00.000Z",
  "nucleoPertence": "Núcleo Central",
  "statusAtual": "Ativo",
  "classificacao": "Médium",
  "diaSessao": "Quarta-feira",
  "dataBatismo": "2024-03-20T00:00:00.000Z",
  "mediumCelebranteBatismo": "Ana Paula",
  "padrinhoBatismo": "Carlos Alberto",
  "madrinhaBatismo": "Fernanda Costa",
  "primeiroContatoEmergencia": "Maria Silva - (11) 98888-8888",
  "inicioPrimeiroEstagio": "2024-02-01T00:00:00.000Z",
  "primeiroRitoPassagem": "2024-06-15T00:00:00.000Z",
  "dataJogoOrixa": "2024-07-10T00:00:00.000Z",
  "primeiroOrixa": "Oxalá",
  "segundoOrixa": "Iemanjá",
  "atividadeEspiritual": "Desenvolvimento Mediúnico",
  "grupoAtividadeEspiritual": "Grupo Estrela"
}
```

## 🎨 UI - Próximos Passos

Para criar formulários completos, você pode:

1. **Criar abas/tabs** para organizar os campos:

   - Aba "Dados Pessoais"
   - Aba "Batismo"
   - Aba "Casamentos"
   - Aba "Estágios"
   - Aba "Orixá"
   - Aba "Atividades"

2. **Usar Stepper** para cadastro guiado

3. **Criar telas específicas** para cada seção

4. **Implementar busca e filtros** por:
   - Nome
   - CPF
   - Núcleo
   - Status
   - Classificação
   - Orixá

## 📱 Exemplo de Uso

```dart
// Criar novo usuário (apenas campos obrigatórios)
final usuario = Usuario(
  nome: 'João Silva',
  cpf: '12345678900',
);

// Criar usuário com dados completos
final usuarioCompleto = Usuario(
  nome: 'Maria Santos',
  cpf: '98765432100',
  email: 'maria@email.com',
  telefoneCelular: '11988888888',
  nucleoCadastro: 'Núcleo Central',
  dataCadastro: DateTime.now(),
  statusAtual: 'Ativo',
  classificacao: 'Médium',
  primeiroOrixa: 'Oxum',
);

// Usar o BLoC
context.read<UsuarioBloc>().add(CreateUsuarioEvent(usuario));
```

---

**Todos os 68 campos foram implementados e estão prontos para uso!** ✅
