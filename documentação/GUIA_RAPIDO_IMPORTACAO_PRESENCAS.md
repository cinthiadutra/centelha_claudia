# 🚀 Guia Rápido - Importação de Presenças

## ✅ Pré-requisitos

1. **Calendário 2026 já importado** no Supabase (tabela `calendario_2026`)
2. **Tabela de registros criada** - Execute:
   ```sql
   -- No SQL Editor do Supabase
   scripts/criar_tabela_registros_presenca.sql
   ```

## 📱 Passo a Passo

### 1. Acessar o Sistema

```
Menu Lateral → SISTEMA DE PONTO → Importar Presenças
```

### 2. Selecionar Arquivo

- Clique em **"Selecionar Arquivo CSV/TXT"**
- Escolha o arquivo de ponto (ex: `PRESENÇA AGOSTO.csv`)
- Aguarde o processamento

### 3. Visualizar Estatísticas

O sistema mostrará:

- ✅ Total de registros no arquivo
- ✅ Quantidade de membros únicos
- ✅ Quantidade de datas diferentes
- ✅ Período coberto (primeira e última data)
- ✅ Preview dos primeiros 50 registros

### 4. Processar Importação

- Clique em **"Processar e Importar para Supabase"**
- Aguarde enquanto o sistema:
  - Vincula cada registro com atividade do calendário
  - Salva no banco de dados
  - Evita duplicatas

### 5. Conferir Resultado

- ✅ Mensagem de sucesso com quantidade de registros salvos
- ✅ Dados disponíveis em `registros_presenca` no Supabase

## 📋 Formato do Arquivo

**Obrigatório**: CSV ou TXT com delimitador `;` (ponto e vírgula)

```csv
ra. No.;Nome;dept.;Tempo;Máquina No.
29;0498-THAYANA;Not Set1; 01/08/2025 17:38:10;1
207;1536-ALINE C;Not Set1; 01/08/2025 17:41:01;1
```

## 🔍 Consultas SQL Úteis

### Ver todas as presenças importadas

```sql
SELECT * FROM registros_presenca
ORDER BY data_hora DESC;
```

### Presenças por data

```sql
SELECT
    DATE(data_hora) as data,
    COUNT(*) as total
FROM registros_presenca
GROUP BY DATE(data_hora)
ORDER BY data;
```

### Presenças com dados da atividade

```sql
SELECT
    rp.nome_registrado,
    rp.codigo,
    c.data,
    c.dia_semana,
    c.atividade,
    c.nucleo
FROM registros_presenca rp
JOIN calendario_2026 c ON c.id = rp.atividade_id
ORDER BY c.data, rp.nome_registrado;
```

### Ranking de presenças

```sql
SELECT
    codigo,
    nome_registrado,
    COUNT(*) as total_presencas
FROM registros_presenca
GROUP BY codigo, nome_registrado
ORDER BY total_presencas DESC
LIMIT 20;
```

## ⚠️ Atenção

### Mapeamento de Membros

Atualmente o sistema cria IDs temporários no formato `temp_CODIGO`.

**Próximo passo**: Implementar vínculo com tabela de membros reais.

Opções:

1. Adicionar campo `codigo_ponto` na tabela de membros
2. Criar tabela de mapeamento `codigo_ponto ↔ membro_id`
3. Buscar membro por nome durante importação

## 🎯 Próximos Recursos

- [ ] Vincular registros com membros reais
- [ ] Relatório de frequência mensal
- [ ] Exportar relatório em Excel
- [ ] Dashboard de presenças
- [ ] Integração com cálculo de notas (A-L)

## 📞 Suporte

Se encontrar problemas:

1. Verifique se o calendário 2026 está importado
2. Confirme que executou o script SQL da tabela
3. Verifique o formato do arquivo (delimitador `;`)
4. Consulte a documentação completa em:
   ```
   documentação/SISTEMA_IMPORTACAO_PRESENCAS.md
   ```

---

✨ **Pronto para importar presenças!** ✨
