# 📋 Sistema de Importação de Presenças

## 🎯 Visão Geral

Sistema para importar registros de ponto eletrônico (arquivo CSV/TXT) e vincular automaticamente com as atividades do calendário 2026 já cadastradas no Supabase.

## 📁 Estrutura do Arquivo de Importação

### Formato Esperado

O arquivo deve ser um CSV ou TXT com as seguintes colunas separadas por ponto e vírgula (;):

```
ra. No.;Nome;dept.;Tempo;Máquina No.
```

### Exemplo de Dados

```csv
ra. No.;Nome;dept.;Tempo;Máquina No.
29;0498-THAYANA;Not Set1; 01/08/2025     17:38:10;1
207;1536-ALINE C;Not Set1; 01/08/2025     17:41:01;1
171;1938-FERNANDA;Not Set1; 01/08/2025     18:06:26;1
```

### Campos

- **ra. No.**: Número do registro (ID sequencial)
- **Nome**: Formato "CODIGO-NOME" (ex: "0498-THAYANA")
- **dept.**: Departamento (geralmente "Not Set1")
- **Tempo**: Data e hora no formato " DD/MM/YYYY HH:MM:SS"
- **Máquina No.**: Número da máquina de ponto (geralmente 1)

## 🚀 Como Usar

### 1. Preparar o Banco de Dados

Execute o script SQL no Supabase:

```bash
scripts/criar_tabela_registros_presenca.sql
```

Este script cria:

- Tabela `registros_presenca`
- Índices para performance
- Políticas RLS para segurança
- Triggers para atualização automática

### 2. Acessar o Sistema

1. Faça login no sistema
2. No menu lateral, vá em **SISTEMA DE PONTO**
3. Clique em **Importar Presenças**

### 3. Importar Arquivo

1. Clique em **"Selecionar Arquivo CSV/TXT"**
2. Escolha seu arquivo de presenças
3. O sistema irá:

   - Processar o arquivo
   - Mostrar estatísticas (total de registros, membros únicos, período)
   - Exibir preview dos primeiros 50 registros

4. Clique em **"Processar e Importar para Supabase"**
5. Aguarde o processamento

### 4. Resultado

O sistema irá:

- ✅ Vincular cada registro com a atividade correspondente no `calendario_2026`
- ✅ Salvar os dados em `registros_presenca`
- ✅ Evitar duplicatas (membro + atividade)
- ✅ Mostrar quantidade de registros importados

## 📊 Estrutura de Dados

### Tabela: registros_presenca

| Campo           | Tipo      | Descrição                          |
| --------------- | --------- | ---------------------------------- |
| id              | UUID      | ID único do registro               |
| membro_id       | TEXT      | ID do membro (código temporário)   |
| atividade_id    | BIGINT    | Referência para calendario_2026    |
| data_hora       | TIMESTAMP | Data/hora da presença              |
| presente        | BOOLEAN   | Se esteve presente (default: true) |
| codigo          | TEXT      | Código do membro no ponto          |
| nome_registrado | TEXT      | Nome como aparece no ponto         |
| justificativa   | TEXT      | Justificativa (se houver)          |

### Vinculação com Calendário

O sistema busca a atividade no `calendario_2026` pela **data** do registro:

- Extrai a data do registro de ponto (sem hora)
- Busca atividades dessa data no calendário
- Vincula o registro à atividade encontrada

## 🔧 Funcionalidades

### Service: PresencaImportService

```dart
final service = PresencaImportService();

// Carregar arquivo
final registros = await service.carregarDeArquivo(conteudo);

// Obter estatísticas
final stats = service.obterEstatisticas(registros);

// Filtrar por mês
final agosto = service.filtrarPorMes(registros, 8, 2025);

// Agrupar por data
final porData = service.agruparPorData(registros);

// Agrupar por membro
final porMembro = service.agruparPorMembro(registros);
```

### Repository: CalendarioRepository

```dart
final calendarioRepo = CalendarioRepository(supabase);

// Buscar todas atividades
final atividades = await calendarioRepo.buscarTodasAtividades();

// Buscar por data
final atividadesDia = await calendarioRepo.buscarPorData(DateTime(2026, 1, 15));

// Buscar por mês
final janeiro = await calendarioRepo.buscarPorMes(1, 2026);

// Buscar por período
final periodo = await calendarioRepo.buscarPorPeriodo(inicio, fim);
```

### Repository: PresencaRepository

```dart
final presencaRepo = PresencaRepository(supabase);

// Salvar registro único
final presenca = await presencaRepo.salvar(registro);

// Salvar lote
final presencas = await presencaRepo.salvarLote(listaRegistros);

// Buscar por membro
final presencasMembro = await presencaRepo.buscarPorMembro(membroId);

// Buscar por atividade
final presencasAtividade = await presencaRepo.buscarPorAtividade(atividadeId);

// Verificar existência
final existe = await presencaRepo.existeRegistro(membroId, atividadeId);
```

## ⚠️ Importante

### Mapeamento de Membros

**ATENÇÃO**: Atualmente o sistema usa códigos temporários como `membro_id`.

Para vincular com membros reais do sistema, você precisa:

1. **Criar tabela de mapeamento** código ↔ membro_id real
2. **Ou** adicionar campo `codigo_ponto` na tabela de membros
3. **Ou** implementar busca por nome na importação

#### Exemplo de Implementação:

```dart
// Em importar_presenca_page.dart, linha ~340
// Substituir:
final membroId = 'temp_${registro.codigo}';

// Por:
final membro = await buscarMembroPorCodigo(registro.codigo);
if (membro == null) {
  print('⚠️ Membro não encontrado: ${registro.codigoNome}');
  continue;
}
final membroId = membro.id;
```

### Consultas Úteis

```sql
-- Ver todas as presenças importadas
SELECT * FROM registros_presenca ORDER BY data_hora DESC;

-- Presenças por dia
SELECT DATE(data_hora) as data, COUNT(*) as total
FROM registros_presenca
GROUP BY DATE(data_hora)
ORDER BY data;

-- Presenças vinculadas com atividades
SELECT
    rp.nome_registrado,
    c.data,
    c.atividade,
    c.nucleo
FROM registros_presenca rp
JOIN calendario_2026 c ON c.id = rp.atividade_id
ORDER BY c.data, rp.nome_registrado;

-- Membros mais presentes
SELECT
    codigo,
    nome_registrado,
    COUNT(*) as total_presencas
FROM registros_presenca
GROUP BY codigo, nome_registrado
ORDER BY total_presencas DESC;
```

## 🔄 Fluxo Completo

```
1. Usuário seleciona arquivo CSV/TXT
          ↓
2. PresencaImportService processa arquivo
          ↓
3. Sistema mostra estatísticas e preview
          ↓
4. Usuário confirma importação
          ↓
5. Para cada registro:
   - Busca atividade do dia em calendario_2026
   - Cria registro de presença
   - Salva em registros_presenca
          ↓
6. Mostra resultado final
```

## 📝 Próximos Passos

1. ✅ Importar calendário 2026 (já feito)
2. ✅ Criar sistema de importação de presenças (feito)
3. ⏳ Implementar mapeamento de códigos → membros reais
4. ⏳ Criar relatórios de frequência
5. ⏳ Integrar com sistema de avaliação mensal (notas A-L)

## 🆘 Troubleshooting

### Arquivo não processa

- Verifique se o delimitador é ponto e vírgula (;)
- Confirme que a primeira linha é o cabeçalho
- Certifique-se do formato de data: DD/MM/YYYY HH:MM:SS

### Registros não vinculam com calendário

- Verifique se as datas no arquivo correspondem às datas em `calendario_2026`
- Confirme o formato da data no calendário: "26-1-15" (ano-mês-dia)

### Erro ao salvar no Supabase

- Confirme que executou o script SQL de criação da tabela
- Verifique as políticas RLS no Supabase
- Confirme que o usuário está autenticado

---

✨ **Sistema de importação de presenças pronto para uso!** ✨
