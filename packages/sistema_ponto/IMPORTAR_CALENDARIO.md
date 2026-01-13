# Como Importar o Calendário 2026

## 📅 Arquivo JSON

O calendário deve estar em formato JSON no arquivo `assets/programacao_2026.json`

### Estruturas Suportadas

#### Opção 1: Lista direta

```json
[
  {
    "data": "01/01/2026",
    "dia_sessao": "Quarta-feira CCU",
    "tipo_atividade": "Sessão Mediúnica",
    "observacoes": ""
  },
  {
    "data": "03/01/2026",
    "dia_sessao": "Sexta-feira CCU",
    "tipo_atividade": "Atendimento Público",
    "observacoes": "Primeiro atendimento do ano"
  }
]
```

#### Opção 2: Organizado por meses

```json
{
  "meses": {
    "janeiro": [
      {
        "data": "01/01/2026",
        "dia_sessao": "Quarta CCU",
        "tipo_atividade": "Sessão"
      }
    ],
    "fevereiro": [...]
  }
}
```

#### Opção 3: Com chave "atividades"

```json
{
  "ano": 2026,
  "atividades": [
    {
      "data": "2026-01-01",
      "dia_sessao": "Quarta CCU",
      "tipo_atividade": "Sessão Mediúnica"
    }
  ]
}
```

## 🔧 Como Usar

### 1. Adicionar arquivo ao pubspec.yaml

```yaml
flutter:
  assets:
    - packages/sistema_ponto/assets/programacao_2026.json
```

### 2. Importar no código

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

// Criar serviço
final importService = CalendarioImportService();

// Carregar calendário completo de 2026
final atividades = await importService.carregarDeJson(
  'packages/sistema_ponto/assets/programacao_2026.json'
);

print('Total de atividades: ${atividades.length}');

// Filtrar apenas janeiro/2026
final atividadesJaneiro = importService.filtrarPorMes(atividades, 1, 2026);

// Contar por tipo
final contagem = importService.contarPorTipo(atividadesJaneiro);
print('Sessões Mediúnicas: ${contagem[TipoAtividadeCalendario.sessaoMedianica]}');
print('Atendimentos Públicos: ${contagem[TipoAtividadeCalendario.atendimentoPublico]}');
```

## 📊 Tipos de Atividades Reconhecidos

O importador identifica automaticamente baseado em palavras-chave:

| Tipo                | Palavras-chave                                 |
| ------------------- | ---------------------------------------------- |
| Sessão Mediúnica    | "sessão", "terça", "quarta", "sexta", "sábado" |
| Atendimento Público | "atendimento público", "público"               |
| COR                 | "cor", "corrente", "oração"                    |
| Ramatis             | "ramatis"                                      |
| Grupo Trabalho      | "grupo", "trabalho espiritual"                 |
| Cambonagem          | "cambonagem", "cambono"                        |
| Arrumação           | "arrumação"                                    |
| Desarrumação        | "desarrumação"                                 |

## 🔄 Formatos de Data Suportados

- `DD/MM/YYYY` - Exemplo: `15/01/2026`
- `YYYY-MM-DD` - Exemplo: `2026-01-15`

## 💡 Exemplo Completo

```dart
Future<void> inicializarCalendario() async {
  try {
    // Importar calendário
    final importService = CalendarioImportService();
    final atividades = await importService.carregarDeJson(
      'packages/sistema_ponto/assets/programacao_2026.json'
    );

    // Salvar no banco de dados
    final repository = sl<CalendarioRepository>();
    for (var atividade in atividades) {
      await repository.salvar(atividade);
    }

    print('✅ ${atividades.length} atividades importadas!');

    // Gerar relatório
    final contagem = importService.contarPorTipo(atividades);
    contagem.forEach((tipo, count) {
      print('$tipo: $count');
    });
  } catch (e) {
    print('❌ Erro ao importar: $e');
  }
}
```

## 📝 Campos do JSON

### Obrigatórios

- `data` - Data da atividade

### Opcionais

- `dia_sessao` - Dia de sessão (Terça CCU, Sábado CPO, etc.)
- `tipo_atividade` - Tipo da atividade
- `observacoes` - Observações adicionais

## 🚀 Próximos Passos

Depois de importar:

1. ✅ As atividades estarão no calendário
2. ✅ Sistema pode calcular Nota A (frequência em sessões)
3. ✅ Sistema pode calcular Nota E (instruções espirituais)
4. ✅ Sistema pode calcular Notas F e G (escalas)
5. ✅ Pronto para receber registros de presença

## ⚠️ Importante

- Certifique-se que as datas estão corretas
- O ano deve ser 2026
- Dias de sessão devem incluir o núcleo (CCU/CPO)
- Nomes devem ser consistentes com os enums do sistema
