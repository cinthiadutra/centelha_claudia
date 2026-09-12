# Plano de Integracao - Claudia ERP + Centelha Consultas

## 1. Objetivo

Este documento descreve o plano para evoluir o projeto Claudia para um ERP central e integrar futuramente os dados do app Centelha Consultas.

O objetivo e organizar:

- o papel de cada sistema;
- as regras de negocio ja conhecidas;
- o que precisa ser melhorado no Claudia;
- o que precisa ser melhorado no app Consultas;
- como integrar Firebase e Supabase sem servidor pago;
- quais tabelas e contratos de dados devem existir;
- quais APIs ou funcoes serverless podem ser criadas no futuro;
- quais prioridades devem entrar no backlog do MVP.

## 2. Contexto Atual

O ecossistema atual possui dois sistemas principais:

| Sistema | Tecnologia | Backend atual | Papel |
| --- | --- | --- | --- |
| Claudia | Flutter + Supabase | Supabase Auth, PostgreSQL, PostgREST e RLS | ERP central da casa de caridade |
| Centelha Consultas | React/Vite + Firebase | Firebase Auth, Realtime Database e IndexedDB | Operacao diaria das consultas |

Nao ha verba neste momento para manter um backend proprio em servidor.

Por isso, a estrategia do MVP e:

- manter Claudia no Supabase;
- manter Consultas no Firebase;
- usar Supabase como base oficial do ERP;
- usar Firebase como modulo operacional das consultas;
- integrar primeiro por historico consolidado;
- evitar backend proprio por enquanto.

## 3. Decisao de Arquitetura do MVP

```txt
Claudia ERP
  -> Supabase Auth
  -> Supabase PostgreSQL
  -> Supabase RLS
  -> Supabase PostgREST

App Consultas
  -> Firebase Auth
  -> Firebase Realtime Database
  -> IndexedDB offline

Integracao inicial
  -> exportacao/importacao
  -> script local
  -> Supabase Edge Function futura
```

## 4. Papel de Cada Sistema

### 4.1 Claudia ERP

O Claudia deve ser o sistema central para:

- cadastros;
- membros;
- usuarios e permissoes;
- nucleos;
- grupos;
- calendario;
- ponto;
- presenca;
- mensalidades;
- avaliacoes mensais;
- dashboards;
- historico consolidado de consultas;
- relatórios gerenciais.

### 4.2 App Consultas

O app Consultas deve continuar responsavel por:

- operacao diaria das consultas;
- fila de espera;
- presenca e disponibilidade dos mediuns;
- consulta em andamento;
- finalizacao da consulta;
- rating;
- feedback;
- relatorio diario operacional;
- estatisticas por medium;
- uso offline durante a operacao.

### 4.3 App Mobile

O App Mobile deve ser uma interface de acesso ao ERP.

Ele pode exibir:

- dados cadastrais;
- frequencia;
- mensalidade;
- historico;
- status;
- consultas consolidadas;
- notificacoes;
- informacoes permitidas por perfil.

## 5. Fonte da Verdade

| Dado | Fonte oficial recomendada | Observacao |
| --- | --- | --- |
| Usuarios do Claudia | Supabase | Usar Supabase Auth + `usuarios_sistema`. |
| Cadastros principais | Supabase | Claudia deve centralizar. |
| Membros | Supabase | Escolher tabela oficial entre estruturas atuais. |
| Nucleos | Supabase | Firebase pode ter espelho operacional. |
| Grupos | Supabase | Claudia centraliza. |
| Calendario | Supabase | Normalizar tabela futura `atividades`. |
| Ponto | Supabase | Claudia centraliza. |
| Presenca | Supabase | Claudia centraliza. |
| Mensalidades | Supabase | Claudia centraliza. |
| Avaliacao mensal | Supabase | Calculo ainda precisa evoluir para persistencia/auditoria. |
| Consultas em tempo real | Firebase | App Consultas controla operacao do dia. |
| Historico de consultas | Supabase | Importado do Firebase para o Claudia. |
| Feedbacks de consultas | Supabase historico | Origem operacional no Firebase. |
| Relatorio diario de consultas | Supabase historico | Gerado pelo Consulta e importado no Claudia. |

## 6. Estado Atual do Claudia

O Claudia atualmente:

- inicializa Supabase no Flutter;
- autentica via Supabase Auth;
- acessa tabelas diretamente pelo cliente;
- usa Supabase PostgREST;
- possui regras importantes no Flutter;
- possui modulos de cadastro, membros, consultas, grupos, ponto, calendario, presenca e avaliacao mensal;
- possui tabelas legadas e atuais coexistindo.

### 6.1 Tabelas observadas

| Tabela | Uso |
| --- | --- |
| `usuarios_sistema` | Login, permissoes e gestao de usuarios |
| `cadastro` | Cadastro de pessoas |
| `usuarios` | Estrutura legada/importacao |
| `membros_historico` | Membros e ranking |
| `consultas` | Historico de consultas no Claudia |
| `grupos` | Organizacao |
| `grupo_membros` | Associacao de membros |
| `nucleos` | Nucleos |
| `dia_sessao` | Dias de sessao |
| `classificacao_mediunica` | Classificacao |
| `registros_ponto` | Ponto eletronico |
| `calendario_2026` | Agenda de atividades |
| `registros_presenca` | Presenca |
| `conceitos_grupo_tarefa` | Nota C |
| `conceitos_acao_social` | Nota D |
| tabelas de notas configuraveis | Lancamentos manuais |
| `avaliacoes_mensais` | Planejada, ainda nao usada como ranking oficial |

## 7. Problemas Atuais do Claudia

### 7.1 Dados e integridade

Pontos de atencao:

- existem tabelas concorrentes para pessoas e membros;
- algumas tabelas parecem legado, mas ainda sao usadas;
- alguns relacionamentos importantes usam texto em vez de FK;
- `calendario_2026.data` usa texto;
- `registros_presenca.membro_id` pode receber IDs temporarios;
- `registros_ponto` precisa de migration oficial confirmada;
- scripts SQL, documentacao e codigo podem estar desalinhados.

### 7.2 Regras no cliente

O Flutter ainda concentra regras importantes, especialmente:

- calculo da avaliacao mensal;
- inferencia de tipos de atividade;
- filtros de calendario;
- importacao de presenca;
- parte da autorizacao via menus.

Para o MVP isso e aceitavel, mas precisa ser documentado e protegido por RLS.

### 7.3 Seguranca

Riscos:

- politicas RLS amplas;
- politicas com `USING (true)` e `WITH CHECK (true)`;
- possivel leitura publica de dados sensiveis;
- controle por menu no Flutter nao substitui autorizacao real;
- service role nunca pode estar no app cliente;
- credenciais de teste nao devem ficar em documentos versionados.

## 8. Regras de Negocio do Claudia

### 8.1 Autenticacao

Fluxo atual:

1. usuario informa e-mail ou numero de cadastro;
2. se informar numero de cadastro, o sistema busca e-mail em `usuarios_sistema`;
3. autentica via Supabase Auth;
4. carrega perfil complementar em `usuarios_sistema`;
5. exibe menus conforme `nivel_permissao`.

Niveis:

| Nivel | Papel |
| --- | --- |
| 1 | Membro ativo, acesso basico |
| 2 | Secretaria, cadastros, membros, consultas, grupos e cursos |
| 3 | Pai/mae de terreiro, sacramentos e exclusoes sensiveis |
| 4 | Administrador, usuarios e organizacao |

### 8.2 Cadastros e membros

Decisao pendente:

- escolher tabela oficial para pessoa;
- escolher tabela oficial para membro;
- mapear tabelas legadas;
- definir regra de duplicidade;
- definir regra de inativacao;
- definir historico de alteracoes.

### 8.3 Calendario

Problema atual:

- atividade usa `calendario_2026`;
- data e texto;
- tipo e inferido pela descricao.

Tipos identificados:

- cambonagem;
- arrumacao;
- desarrumacao;
- Ramatis;
- COR;
- grupo de trabalho;
- sessao mediunica;
- outra.

Melhoria recomendada:

- criar tabela `atividades`;
- usar `date` para data;
- usar `time` ou `timestamptz` para horario;
- criar campo `tipo`;
- criar FK para nucleo;
- indexar por data, nucleo e tipo.

### 8.4 Ponto

Regras:

- registra entrada;
- registra saida para almoco;
- registra retorno;
- registra saida final;
- permite lancamento manual;
- pode guardar localizacao, observacao e operador;
- ponto aberto depende do ultimo registro.

Regra de ponto aberto:

```txt
Se ultimo tipo for entrada ou saidaAlmoco:
  ponto esta aberto
Senao:
  ponto esta fechado
```

### 8.5 Presenca

Regras:

- registra presenca por membro e atividade;
- chave unica recomendada: `(membro_id, atividade_id)`;
- pode conter justificativa;
- pode ser alimentada por importacao.

Ponto critico:

- remover ou mapear IDs temporarios como `temp_<codigo>`.

### 8.6 Avaliacao mensal

Formula:

```txt
notaReal = A+B+C+D+E+F+G+H+I+J+K+L
notaFinal = notaReal / maiorNotaRealDoConjunto * 100
```

Notas:

| Nota | Regra |
| --- | --- |
| A | Frequencia nas sessoes, considerando classificacao e dia de sessao |
| B | Grupo de trabalho espiritual |
| C | Conceito do lider do grupo-tarefa |
| D | Conceito de acao social |
| E | Presenca em COR/Ramatis |
| F | Escala de cambonagem |
| G | Arrumacao/desarrumacao |
| H | Mensalidade em dia |
| I | Conceito de pai/mae |
| J | Bonus do Tata |
| K | Nota anterior ou membro novo |
| L | Cargo de lideranca |

Problemas atuais:

- alguns conceitos podem ir vazios;
- mensalidade pode estar fixa como em dia;
- grupos podem virar listas vazias;
- resultado ainda nao e persistido oficialmente em `avaliacoes_mensais`;
- normalizacao muda quando muda o conjunto de membros.

Recomendacao:

- manter como MVP;
- nao considerar ranking como historico oficial ainda;
- persistir com versao da regra, data, operador e status futuramente.

## 9. Estado Atual do App Consultas

O App Consultas usa:

- Firebase Auth;
- Firebase Realtime Database;
- IndexedDB;
- React/Vite/TypeScript;
- regras de fila e consulta no frontend.

### 9.1 Dados principais

| No Firebase | Papel |
| --- | --- |
| `mediums` | Cadastro operacional de mediuns |
| `consultations/{yyyy-MM-dd}` | Consultas particionadas por data |
| `users` | Perfil complementar |
| `nucleos` | Nucleos do Consulta |
| `reports` | Relatorios diarios e snapshots |
| `mediumStats` | Estatisticas por medium |

### 9.2 Regras principais

- medium possui presenca e disponibilidade;
- consulta possui senha, consulente, medium, guia, nucleo, status, rating e feedback;
- status usados: `waiting`, `in_progress`, `completed`;
- fila usa `waiting`;
- falange do dia trava na primeira consulta;
- senha e normalizada;
- senha duplicada recebe sufixo alfabetico;
- limite padrao por medium: 3 consultas;
- consulta de teste nao entra em relatorio;
- finalizacao salva rating e feedback;
- fechamento do dia gera relatorio e estatisticas.

## 10. Integracao Consulta -> Claudia

### 10.1 Principio

No MVP, o Claudia nao deve controlar a fila operacional do Firebase.

O Claudia deve receber:

- historico consolidado de consultas;
- feedbacks;
- ratings;
- relatorio diario;
- estatisticas agregadas.

### 10.2 Fluxo recomendado

```txt
App Consultas
  -> Firebase
  -> relatorio diario / dados consolidados
  -> importacao
  -> Supabase
  -> Claudia Web
  -> dashboards e historico
```

### 10.3 Dados minimos da consulta

```txt
origem
firebase_date
firebase_consultation_id
nucleo_id_origem
nucleo_nome
senha
consultant_name
medium_id_origem
medium_name
guide_id
guide_name
phalanx
start_time
end_time
status
rating
feedback
is_test
created_at_origem
updated_at_origem
imported_at
```

### 10.4 Dados minimos do relatorio diario

```txt
origem
data
nucleo_id_origem
phalanx_of_day
total_consultations
total_work_time
distribution_by_medium
distribution_by_ribbon
limit_overrides
dirigent_id
dirigent_name
created_at_origem
imported_at
```

## 11. Tabelas Recomendadas para Integracao

Para nao misturar dados externos diretamente com tabelas atuais, criar tabelas especificas:

```sql
consulta_importacoes
consulta_importacao_itens
consulta_historico_externo
consulta_relatorios_diarios_externos
consulta_medium_stats_externos
```

### 11.1 `consulta_importacoes`

Controle de cada importacao.

Campos sugeridos:

```txt
id
origem
tipo
data_referencia
status
arquivo_nome
arquivo_hash
total_itens
total_importados
total_rejeitados
erro
criado_por
created_at
finished_at
```

### 11.2 `consulta_historico_externo`

Historico individual das consultas vindas do Firebase.

Campos sugeridos:

```txt
id
importacao_id
origem
firebase_date
firebase_consultation_id
nucleo_id_origem
nucleo_nome
senha
consultant_name
medium_id_origem
medium_name
guide_id
guide_name
phalanx
start_time
end_time
status
rating
feedback
is_test
raw_payload
created_at_origem
updated_at_origem
imported_at
```

Constraint recomendada:

```txt
unique(origem, firebase_date, firebase_consultation_id)
```

### 11.3 `consulta_relatorios_diarios_externos`

Relatorio consolidado diario.

Campos sugeridos:

```txt
id
importacao_id
origem
data
nucleo_id_origem
nucleo_nome
phalanx_of_day
total_consultations
total_work_time
distribution_by_medium
distribution_by_ribbon
limit_overrides
dirigent_id
dirigent_name
raw_payload
created_at_origem
imported_at
```

Constraint recomendada:

```txt
unique(origem, data, nucleo_id_origem)
```

## 12. API e Funcoes Futuras

No MVP, nao e obrigatorio criar API propria.

Ordem recomendada:

1. Supabase direto com RLS;
2. importacao manual;
3. script local;
4. Supabase Edge Function;
5. backend proprio somente no futuro.

### 12.1 Supabase Edge Function futura

Rota sugerida:

```txt
POST /functions/v1/import-consultas
```

Payload:

```json
{
  "origem": "firebase_consultas",
  "tipo": "relatorio_diario",
  "data": "2026-09-11",
  "nucleo": {
    "id": "nucleo_origem",
    "nome": "Nucleo Central"
  },
  "consultas": [],
  "relatorio": {}
}
```

Resposta de sucesso:

```json
{
  "data": {
    "importacaoId": "uuid",
    "totalRecebidos": 10,
    "totalImportados": 10,
    "totalRejeitados": 0
  }
}
```

Resposta de erro:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Payload invalido",
    "details": []
  }
}
```

### 12.2 Regras da funcao

A funcao deve:

- validar origem;
- validar token ou segredo;
- validar data;
- validar estrutura do payload;
- impedir duplicidade por chave de origem;
- gravar payload bruto;
- gravar itens aceitos;
- registrar rejeicoes;
- retornar resumo da importacao.

## 13. Melhorias Necessarias no Claudia

### 13.1 Dados

- escolher fonte oficial para pessoas;
- escolher fonte oficial para membros;
- mapear tabelas legadas;
- criar migrations faltantes;
- normalizar calendario;
- remover IDs temporarios de presenca;
- adicionar FKs onde possivel;
- criar tabelas de importacao de consultas.

### 13.2 Seguranca

- revisar RLS em todas as tabelas sensiveis;
- remover politicas publicas indevidas;
- remover `USING (true)` onde houver risco;
- restringir por nivel de permissao;
- restringir por nucleo quando aplicavel;
- proteger mensalidades, consultas, conceitos e avaliacoes;
- nunca usar service role no Flutter.

### 13.3 Regras

- documentar regras reais de cada modulo;
- mover regras criticas para banco, RLS, triggers ou funcoes quando necessario;
- versionar calculo de avaliacao;
- persistir avaliacao mensal;
- auditar alteracoes sensiveis.

### 13.4 Produto

- criar dashboard central;
- exibir historico importado de consultas;
- cruzar consultas com cadastros quando houver regra segura;
- mostrar frequencia;
- mostrar mensalidades;
- mostrar avaliacao mensal como pre-visualizacao ate estabilizar.

## 14. Melhorias Necessarias no App Consultas

- melhorar regras do Realtime Database;
- restringir acesso por role;
- restringir acesso por nucleo;
- impedir usuario comum de editar `users`;
- impedir usuario comum de editar `reports`;
- proteger cancelamento de consultas;
- proteger fechamento do dia;
- persistir configuracao importante fora de `localStorage`;
- revisar auto sync offline antes de ativar;
- criar exportacao limpa para o Claudia.

## 15. Backlog do MVP

### Sprint 1 - Inventario do Claudia

- listar tabelas Supabase existentes;
- listar migrations existentes;
- identificar tabelas usadas pelo Flutter;
- separar tabela oficial e tabela legado;
- revisar RLS mais perigosa.

### Sprint 2 - Cadastro e membros

- escolher fonte oficial de pessoa;
- escolher fonte oficial de membro;
- definir regra de duplicidade;
- definir regra de inativacao;
- documentar campos obrigatorios;
- criar matriz de equivalencia entre tabelas legadas.

### Sprint 3 - Calendario, presenca e ponto

- revisar `calendario_2026`;
- planejar tabela `atividades`;
- revisar `registros_presenca`;
- corrigir IDs temporarios;
- confirmar migration de `registros_ponto`;
- documentar importacao de presencas.

### Sprint 4 - Seguranca

- revisar RLS;
- restringir dados sensiveis;
- aplicar escopo por nucleo;
- proteger mensalidades;
- proteger consultas;
- proteger usuarios do sistema.

### Sprint 5 - Integracao Consulta

- definir payload de exportacao do Firebase;
- criar tabelas de importacao no Supabase;
- importar um dia real de teste;
- evitar duplicidade por chave de origem;
- exibir historico no Claudia como somente leitura.

### Sprint 6 - Dashboard MVP

- total de cadastros ativos;
- frequencia por periodo;
- mensalidades pendentes;
- consultas por periodo;
- feedback medio;
- consultas por medium;
- consultas por nucleo;
- ranking/avaliacao como pre-visualizacao.

## 16. O Que Nao Fazer Agora

Evitar no MVP:

- criar backend proprio pago;
- migrar todo Firebase para Supabase de uma vez;
- juntar tabelas legadas sem inventario;
- deixar Claudia editar fila operacional do Consulta;
- expor service role no cliente;
- tratar ranking atual como historico oficial;
- automatizar integracao antes de validar importacao manual;
- criar dashboard em cima de dados sem fonte da verdade definida.

## 17. Criterios de Pronto para Integracao

Antes de integrar em producao, confirmar:

- [ ] Claudia tem tabela oficial de pessoa/membro definida.
- [ ] RLS revisada nas tabelas sensiveis.
- [ ] Consulta tem exportacao confiavel.
- [ ] Supabase tem tabelas de importacao.
- [ ] Importacao evita duplicidade.
- [ ] Dados importados ficam como somente leitura inicialmente.
- [ ] Existe log de importacao.
- [ ] Existe forma de reprocessar importacao.
- [ ] Existe forma de rejeitar item invalido.
- [ ] Dashboard mostra apenas dados consolidados.

## 18. Conclusao

O melhor caminho para o MVP e evoluir o Claudia como ERP central no Supabase e manter o app Consultas no Firebase como modulo operacional.

A integracao deve comecar simples, por historico consolidado, sem tentar controlar a fila de consultas pelo Claudia.

Prioridade maxima:

1. organizar fonte da verdade no Claudia;
2. melhorar RLS e seguranca;
3. criar tabelas de importacao;
4. importar historico do Consulta;
5. montar dashboard MVP;
6. automatizar somente depois que o fluxo manual estiver validado.

