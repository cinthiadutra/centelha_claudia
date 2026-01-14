# API CENTELHA - Documentação de Endpoints

**Base URL**: `https://api.centelha.org/v1`

## Autenticação

Todos os endpoints (exceto login) requerem header:

```
Authorization: Bearer {token}
```

### POST /auth/login

```json
Request:
{
  "email": "user@centelha.org",
  "senha": "senha123"
}

Response 200:
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "usuario": {
    "id": "1",
    "nome": "João Silva",
    "email": "user@centelha.org",
    "nivelPermissao": 4,
    "numeroCadastro": "00001"
  }
}
```

---

## 1. CADASTRO (Usuario)

### GET /usuarios

Query params: `?nome={nome}&cpf={cpf}&page={1}&limit={50}`

```json
Response 200:
{
  "data": [
    {
      "numeroCadastro": "00001",
      "nome": "João Silva",
      "cpf": "12345678900",
      "dataNascimento": "1990-05-15",
      "email": "joao@email.com",
      "telefone": "(11) 98765-4321",
      "endereco": "Rua A, 123",
      "cidade": "São Paulo",
      "estado": "SP",
      "cep": "01234-567"
      // ... 79 campos totais
    }
  ],
  "total": 100,
  "page": 1
}
```

### GET /usuarios/:numeroCadastro

```json
Response 200:
{
  "numeroCadastro": "00001",
  "nome": "João Silva",
  // ... todos os 79 campos
}
```

### POST /usuarios

```json
Request:
{
  "nome": "Maria Santos",
  "cpf": "98765432100",
  "dataNascimento": "1985-03-20",
  "email": "maria@email.com"
  // ... demais campos
}

Response 201:
{
  "numeroCadastro": "00123",
  "message": "Usuário criado com sucesso"
}
```

### PUT /usuarios/:numeroCadastro

```json
Request: (mesma estrutura do POST)
Response 200: { "message": "Usuário atualizado" }
```

### DELETE /usuarios/:numeroCadastro

```json
Response 200: { "message": "Usuário removido" }
```

---

## 2. MEMBROS DA CENTELHA

### GET /membros

Query: `?nome={}&status={}&page={}`

```json
Response 200:
{
  "data": [
    {
      "numeroCadastro": "00001",
      "nome": "João Silva",
      "status": "Membro ativo",
      "orixaPrincipal": "Ogum",
      "dataIniciacao": "2020-01-15",
      "grauEspiritual": "Iniciado"
      // ... 50+ campos
    }
  ]
}
```

### POST /membros

```json
Request:
{
  "numeroCadastro": "00001",
  "status": "Membro ativo",
  "orixaPrincipal": "Ogum",
  "dataIniciacao": "2020-01-15"
  // ... demais campos
}
```

### GET /membros/relatorio

Query: `?dataInicio={}&dataFim={}&grau={}&orixa={}`

```json
Response 200:
{
  "data": [...],
  "total": 45,
  "filtros": {...}
}
```

---

## 3. HISTÓRICO DE CONSULTAS

### GET /consultas

Query: `?numeroCadastro={}&dataInicio={}&dataFim={}`

```json
Response 200:
{
  "data": [
    {
      "numeroConsulta": "00001",
      "cadastroConsulente": "00123",
      "nomeConsulente": "Maria Santos",
      "dataConsulta": "2025-12-18T14:30:00Z",
      "tipoConsulta": "Espiritual",
      "descricao": "Consulta sobre...",
      "atendente": "João Silva",
      "atendenteNivel": 3
    }
  ]
}
```

### POST /consultas

```json
Request:
{
  "cadastroConsulente": "00123",
  "dataConsulta": "2025-12-18T14:30:00Z",
  "tipoConsulta": "Espiritual",
  "descricao": "...",
  "atendente": "João Silva"
}

Response 201:
{
  "numeroConsulta": "00001"
}
```

---

## 4. GRUPOS-TAREFAS

### GET /grupos-tarefas

```json
Response 200:
{
  "data": [
    {
      "numeroCadastro": "00001",
      "nome": "João Silva",
      "status": "Membro ativo",
      "grupoTarefa": "Manutenção predial",
      "funcao": "Líder",
      "dataUltimaAlteracao": "2025-11-15"
    }
  ]
}
```

### POST /grupos-tarefas

```json
Request:
{
  "numeroCadastro": "00001",
  "grupoTarefa": "Manutenção predial",
  "funcao": "Líder"
}
```

### GET /grupos-tarefas/relatorio

Query: `?grupoTarefa={}&funcao={}`

---

## 5. GRUPOS DE AÇÕES SOCIAIS

### GET /grupos-acoes-sociais

### POST /grupos-acoes-sociais

```json
Request:
{
  "numeroCadastro": "00001",
  "grupoAcaoSocial": "Grupo Sopão Fraterno",
  "funcao": "Participante"
}
```

### GET /grupos-acoes-sociais/relatorio

Query: `?grupoAcaoSocial={}&funcao={}`

---

## 6. GRUPOS DE TRABALHOS ESPIRITUAIS

### GET /grupos-trabalhos-espirituais

### POST /grupos-trabalhos-espirituais

```json
Request:
{
  "numeroCadastro": "00001",
  "atividadeEspiritual": "Evangelização",
  "grupoTrabalho": "Evangelização de crianças",
  "funcao": "Líder"
}
```

**Validação**: grupoTrabalho deve pertencer à atividadeEspiritual

---

## 7. SACRAMENTOS

### 7.1 BATISMO

#### GET /sacramentos/batismos

```json
Response 200:
{
  "data": [
    {
      "id": "1",
      "numeroCadastro": "00001",
      "nomeMembro": "João Silva",
      "dataBatismo": "2020-05-15",
      "localBatismo": "CENTELHA",
      "sacerdoteNome": "Pai José",
      "sacerdoteCadastro": "00010",
      "rebatismo": false,
      "padrinhoNome": "Carlos",
      "madrinhaNome": "Ana"
    }
  ]
}
```

#### POST /sacramentos/batismos

```json
Request:
{
  "numeroCadastro": "00001",
  "dataBatismo": "2020-05-15",
  "localBatismo": "CENTELHA",
  "sacerdoteCadastro": "00010",
  "rebatismo": false,
  "padrinhoCadastro": "00020",
  "madrinhaCadastro": "00021"
}
```

### 7.2 CASAMENTO

#### GET /sacramentos/casamentos

#### POST /sacramentos/casamentos

```json
Request:
{
  "numeroCadastroNoivo": "00001",
  "numeroCadastroNoiva": "00002",
  "dataCasamento": "2023-06-10",
  "localCasamento": "CENTELHA",
  "sacerdoteCadastro": "00010",
  "testemunha1Cadastro": "00020",
  "testemunha2Cadastro": "00021"
}
```

### 7.3 JOGO DE ORIXÁ

#### GET /sacramentos/jogos-orixa

#### POST /sacramentos/jogos-orixa

```json
Request:
{
  "numeroCadastro": "00001",
  "dataJogo": "2021-08-20",
  "localJogo": "CENTELHA",
  "sacerdoteCadastro": "00010",
  "orixaPrincipal": "Ogum",
  "orixaJunto": "Iansã",
  "qualidadeOrixa": "Guerreiro",
  "caminhoOrixa": "Caminho das pedreiras"
}
```

### 7.4 CAMARINHAS

#### GET /sacramentos/camarinhas

Query: `?numeroCadastro={}` (permite múltiplas por membro)

```json
Response 200:
{
  "data": [
    {
      "id": "1",
      "numeroCadastro": "00001",
      "dataInicio": "2022-03-01",
      "dataFim": "2022-03-21",
      "tipoObrigacao": "3 anos",
      "orixaHomenageado": "Ogum",
      "diasDuracao": 21
    }
  ]
}
```

#### POST /sacramentos/camarinhas

```json
Request:
{
  "numeroCadastro": "00001",
  "dataInicio": "2022-03-01",
  "dataFim": "2022-03-21",
  "localCamarinha": "CENTELHA",
  "sacerdoteCadastro": "00010",
  "tipoObrigacao": "3 anos",
  "orixaHomenageado": "Ogum"
}
```

### 7.5 COROAÇÃO SACERDOTAL

#### GET /sacramentos/coroacao-sacerdotal

#### POST /sacramentos/coroacao-sacerdotal

```json
Request:
{
  "numeroCadastro": "00001",
  "dataCoroacao": "2024-12-01",
  "localCoroacao": "CENTELHA",
  "sacerdoteOrdenadorCadastro": "00010",
  "cargo": "Babalorixá",
  "orixaConsagrado": "Oxalá"
}
```

---

## 8. CURSOS E TREINAMENTOS

### 8.1 CURSOS

#### GET /cursos

Query: `?ativo={true}&dataInicio={}&titulo={}`

```json
Response 200:
{
  "data": [
    {
      "id": "1",
      "titulo": "Curso de Mediunidade",
      "descricao": "Desenvolvimento mediúnico...",
      "instrutor": "João Silva",
      "instrutorCadastro": "00001",
      "dataInicio": "2026-01-15",
      "dataFim": "2026-03-15",
      "local": "CENTELHA - Sala 2",
      "cargaHoraria": 40,
      "vagasDisponiveis": 30,
      "vagasOcupadas": 15,
      "vagasRestantes": 15,
      "ativo": true,
      "lotado": false
    }
  ]
}
```

#### POST /cursos

```json
Request:
{
  "titulo": "Curso de Mediunidade",
  "descricao": "...",
  "instrutorCadastro": "00001",
  "dataInicio": "2026-01-15",
  "dataFim": "2026-03-15",
  "local": "CENTELHA - Sala 2",
  "cargaHoraria": 40,
  "vagasDisponiveis": 30,
  "materiaisNecessarios": "Caderno, caneta",
  "prerequisitos": "Ser membro ativo"
}

Response 201:
{
  "id": "1",
  "message": "Curso criado"
}
```

#### PUT /cursos/:id

#### DELETE /cursos/:id

### 8.2 INSCRIÇÕES

#### GET /cursos/:cursoId/inscricoes

```json
Response 200:
{
  "data": [
    {
      "id": "1",
      "cursoId": "1",
      "cursoTitulo": "Curso de Mediunidade",
      "numeroCadastro": "00001",
      "nomeMembro": "João Silva",
      "dataInscricao": "2025-12-01",
      "statusInscricao": "Confirmada",
      "frequencia": 85.5,
      "notaFinal": 8.5,
      "certificadoEmitido": false,
      "aprovado": true
    }
  ]
}
```

#### POST /cursos/:cursoId/inscricoes

```json
Request:
{
  "numeroCadastro": "00001"
}

Response 201:
{
  "id": "1",
  "message": "Inscrição realizada"
}
```

#### PUT /cursos/:cursoId/inscricoes/:id

```json
Request:
{
  "statusInscricao": "Concluída",
  "frequencia": 85.5,
  "notaFinal": 8.5,
  "certificadoEmitido": true,
  "dataConclusao": "2026-03-15"
}
```

#### GET /membros/:numeroCadastro/cursos

Retorna histórico de cursos de um membro

---

## 9. USUÁRIOS DO SISTEMA

### GET /usuarios-sistema

```json
Response 200:
{
  "data": [
    {
      "id": "1",
      "numeroCadastro": "00001",
      "nome": "João Silva",
      "email": "joao@centelha.org",
      "nivelPermissao": 4,
      "ativo": true,
      "dataCriacao": "2025-01-01"
    }
  ]
}
```

### POST /usuarios-sistema

```json
Request:
{
  "numeroCadastro": "00001",
  "email": "joao@centelha.org",
  "senha": "senha123",
  "nivelPermissao": 4,
  "ativo": true
}

Response 201:
{
  "id": "1"
}
```

**Validações**:

- Email único
- Um cadastro = um usuário sistema
- NivelPermissao: 1, 2, 3 ou 4

### PUT /usuarios-sistema/:id

### DELETE /usuarios-sistema/:id

### PATCH /usuarios-sistema/:id/status

```json
Request:
{
  "ativo": false
}
```

---

## 10. ORGANIZAÇÃO

### GET /organizacao

```json
Response 200:
{
  "id": "1",
  "nome": "CENTELHA - Centro Espírita",
  "cnpj": "00.000.000/0001-00",
  "endereco": "Rua Principal, 123",
  "cidade": "São Paulo",
  "estado": "SP",
  "cep": "01234-567",
  "telefone": "(11) 1234-5678",
  "email": "contato@centelha.org",
  "siteWeb": "www.centelha.org",
  "presidenteNome": "João Silva",
  "presidenteCadastro": "00001",
  "vicepresidenteNome": "Maria Santos",
  "vicepresidenteCadastro": "00002",
  "secretarioNome": "Pedro Oliveira",
  "secretarioCadastro": "00003",
  "tesoureiroNome": "Ana Costa",
  "tesoureiroCadastro": "00004",
  "dataFundacao": "2000-01-01",
  "dataUltimaAlteracao": "2025-12-18"
}
```

### PUT /organizacao

```json
Request: (mesma estrutura do GET)
Response 200: { "message": "Organização atualizada" }
```

**Nota**: Apenas edição (registro único)

---

## Códigos de Status HTTP

- **200**: Success
- **201**: Created
- **400**: Bad Request (validação)
- **401**: Unauthorized
- **403**: Forbidden (sem permissão)
- **404**: Not Found
- **500**: Internal Server Error

## Estrutura de Erro

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email já cadastrado",
    "details": {
      "field": "email",
      "value": "joao@centelha.org"
    }
  }
}
```

## Permissões por Nível

- **Nível 1**: Apenas próprios dados
- **Nível 2**: CRUD completo (secretaria)
- **Nível 3**: ReadAll + Own CRUD (líderes)
- **Nível 4**: Full access (admin)

## Observações Importantes

1. Todos os endpoints de listagem suportam paginação
2. Datas no formato ISO 8601: `YYYY-MM-DDTHH:mm:ssZ`
3. Números de cadastro são strings com 5 dígitos: `"00001"`
4. CPF sem formatação: `"12345678900"`
5. Campos opcionais podem ser `null`
6. Validar status "Membro ativo" antes de incluir em grupos
7. Camarinhas permitem múltiplos registros por membro
8. Batismo permite rebatismo (registrar motivo)
