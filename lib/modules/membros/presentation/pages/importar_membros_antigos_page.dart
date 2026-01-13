import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/supabase_service.dart';

class ImportarMembrosAntigosPage extends StatefulWidget {
  const ImportarMembrosAntigosPage({super.key});

  @override
  State<ImportarMembrosAntigosPage> createState() =>
      _ImportarMembrosAntigosPageState();
}

class _ImportarMembrosAntigosPageState
    extends State<ImportarMembrosAntigosPage> {
  bool _isImporting = false;
  int _totalRegistros = 0;
  int _importados = 0;
  int _erros = 0;
  int _duplicados = 0;
  final List<String> _mensagensErro = [];
  bool _concluido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Membros do Sistema Antigo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card de informações
                Card(
                  color: Colors.deepPurple[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.deepPurple[900],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Importação de Histórico Espiritual',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Esta ferramenta importa o histórico espiritual dos membros do sistema antigo (CSV).',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '📋 Dados importados:\n'
                          '• Identificação (nome, cadastro, núcleo)\n'
                          '• Estágios e ritos de passagem\n'
                          '• Sacramentos (batismo, jogo de orixá, camarinhas)\n'
                          '• Orixás e adjuntos\n'
                          '• Atividades e grupos espirituais',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão de importar
                if (!_isImporting && !_concluido)
                  ElevatedButton.icon(
                    onPressed: _importarMembros,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('INICIAR IMPORTAÇÃO'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Progresso
                if (_isImporting) ...[
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Importando membros...',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          if (_totalRegistros > 0)
                            LinearProgressIndicator(
                              value:
                                  (_importados + _erros + _duplicados) /
                                  _totalRegistros,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            'Progresso: ${_importados + _erros + _duplicados} / $_totalRegistros',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                '✅ $_importados importados',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_duplicados > 0)
                                Text(
                                  '⚠️ $_duplicados já existentes',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                '❌ $_erros erros',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Resultado
                if (_concluido) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Importação Concluída!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '✅ $_importados membros importados com sucesso',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_duplicados > 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              '⚠️ $_duplicados membros já existentes (pulados)',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          if (_erros > 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              '❌ $_erros registros com erro',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                // Erros
                if (_mensagensErro.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Primeiros erros encontrados:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._mensagensErro.map(
                            (erro) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '• $erro',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _importarMembros() async {
    if (!mounted) return;

    setState(() {
      _isImporting = true;
      _importados = 0;
      _erros = 0;
      _duplicados = 0;
      _mensagensErro.clear();
      _concluido = false;
    });

    try {
      // Carregar CSV
      final String csvString = await rootBundle.loadString(
        'assets/membros_antigos.csv',
      );

      // Parse CSV
      final csvData = const CsvToListConverter(
        fieldDelimiter: ';',
        eol: '\n',
      ).convert(csvString);

      if (!mounted) return;

      // Ignorar primeiras 3 linhas (metadados) e pegar cabeçalhos da linha 4
      // final headers = csvData[3]; // Não usado
      final registros = csvData.sublist(4);

      setState(() {
        _totalRegistros = registros.length;
      });

      final supabase = SupabaseService.instance.client;

      // Processar em lotes de 50
      const batchSize = 50;
      for (var i = 0; i < registros.length; i += batchSize) {
        if (!mounted) return;

        final end = (i + batchSize < registros.length)
            ? i + batchSize
            : registros.length;
        final batch = registros.sublist(i, end);

        for (var registro in batch) {
          if (!mounted) return;

          try {
            // Extrair dados (índices baseados no CSV)
            final mov = registro.length > 1
                ? _parseIntOrNull(registro[1]?.toString())
                : null;
            final cadastro = registro.length > 2
                ? _stringOrNull(registro[2]?.toString())
                : null;
            final nome = registro.length > 3
                ? (registro[3]?.toString().trim().isEmpty ?? true
                      ? 'Nome não informado'
                      : registro[3]?.toString())
                : 'Nome não informado';
            final nucleo = registro.length > 4
                ? _stringOrNull(registro[4]?.toString())
                : null;
            final status = registro.length > 5
                ? _stringOrNull(registro[5]?.toString())
                : null;
            final funcao = registro.length > 6
                ? _stringOrNull(registro[6]?.toString())
                : null;
            final classificacao = registro.length > 7
                ? _stringOrNull(registro[7]?.toString())
                : null;
            final diaSessao = registro.length > 8
                ? _stringOrNull(registro[8]?.toString())
                : null;

            // Datas de estágios
            final inicioEstagio = _parseDate(
              registro.length > 9 ? registro[9]?.toString() : null,
            );
            final desistenciaEstagio = _parseDate(
              registro.length > 10 ? registro[10]?.toString() : null,
            );
            final primeiroRito = _parseDate(
              registro.length > 11 ? registro[11]?.toString() : null,
            );
            final primeiroDesligamento = _parseDate(
              registro.length > 12 ? registro[12]?.toString() : null,
            );
            final primeiroDesligamentoJust = registro.length > 13
                ? _stringOrNull(registro[13]?.toString())
                : null;
            final segundoRito = _parseDate(
              registro.length > 14 ? registro[14]?.toString() : null,
            );
            final segundoDesligamento = _parseDate(
              registro.length > 15 ? registro[15]?.toString() : null,
            );
            final segundoDesligamentoJust = registro.length > 16
                ? _stringOrNull(registro[16]?.toString())
                : null;
            final terceiroRito = _parseDate(
              registro.length > 17 ? registro[17]?.toString() : null,
            );
            final terceiroDesligamento = _parseDate(
              registro.length > 18 ? registro[18]?.toString() : null,
            );
            final terceiroDesligamentoJust = registro.length > 19
                ? _stringOrNull(registro[19]?.toString())
                : null;

            // Sacramentos
            final ritualBatismo = _parseDate(
              registro.length > 20 ? registro[20]?.toString() : null,
            );
            final jogoOrixa = _parseDate(
              registro.length > 21 ? registro[21]?.toString() : null,
            );
            final coroacao = _parseDate(
              registro.length > 22 ? registro[22]?.toString() : null,
            );
            final camarinha1 = _parseDate(
              registro.length > 23 ? registro[23]?.toString() : null,
            );
            final camarinha2 = _parseDate(
              registro.length > 24 ? registro[24]?.toString() : null,
            );
            final camarinha3 = _parseDate(
              registro.length > 25 ? registro[25]?.toString() : null,
            );

            // Atividades e Grupos
            final atividadeEspiritual = registro.length > 26
                ? _stringOrNull(registro[26]?.toString())
                : null;
            final grupoTrabalho = registro.length > 27
                ? _stringOrNull(registro[27]?.toString())
                : null;

            // Orixás
            final orixa1 = registro.length > 28
                ? _stringOrNull(registro[28]?.toString())
                : null;
            final adjunto1 = registro.length > 29
                ? _stringOrNull(registro[29]?.toString())
                : null;
            final orixa2 = registro.length > 30
                ? _stringOrNull(registro[30]?.toString())
                : null;
            final adjunto2 = registro.length > 31
                ? _stringOrNull(registro[31]?.toString())
                : null;
            final orixa34 = registro.length > 32
                ? _stringOrNull(registro[32]?.toString())
                : null;

            // Observações
            final observacoes = registro.length > 33
                ? _stringOrNull(registro[33]?.toString())
                : null;

            // Verificar se já existe registro com mesmo nome e cadastro
            final existente = await supabase
                .from('membros_historico')
                .select('id')
                .eq('nome', nome ?? '')
                .eq('cadastro', cadastro ?? '')
                .maybeSingle();

            if (existente != null) {
              // Já existe, pular
              if (!mounted) return;
              setState(() {
                _duplicados++;
              });
              continue;
            }

            // Montar objeto para inserir
            final Map<String, dynamic> membroData = {
              'mov': mov,
              'cadastro': cadastro,
              'nome': nome,
              'nucleo': nucleo,
              'status': status,
              'funcao': funcao,
              'classificacao': classificacao,
              'dia_sessao': diaSessao,
              'inicio_estagio': inicioEstagio?.toIso8601String(),
              'desistencia_estagio': desistenciaEstagio?.toIso8601String(),
              'primeiro_rito_passagem': primeiroRito?.toIso8601String(),
              'primeiro_desligamento': primeiroDesligamento?.toIso8601String(),
              'primeiro_desligamento_justificativa': primeiroDesligamentoJust,
              'segundo_rito_passagem': segundoRito?.toIso8601String(),
              'segundo_desligamento': segundoDesligamento?.toIso8601String(),
              'segundo_desligamento_justificativa': segundoDesligamentoJust,
              'terceiro_rito_passagem': terceiroRito?.toIso8601String(),
              'terceiro_desligamento': terceiroDesligamento?.toIso8601String(),
              'terceiro_desligamento_justificativa': terceiroDesligamentoJust,
              'ritual_batismo': ritualBatismo?.toIso8601String(),
              'jogo_orixa': jogoOrixa?.toIso8601String(),
              'coroacao_sacerdote': coroacao?.toIso8601String(),
              'primeira_camarinha': camarinha1?.toIso8601String(),
              'segunda_camarinha': camarinha2?.toIso8601String(),
              'terceira_camarinha': camarinha3?.toIso8601String(),
              'atividade_espiritual': atividadeEspiritual,
              'grupo_trabalho_espiritual': grupoTrabalho,
              'primeiro_orixa': orixa1,
              'adjunto_primeiro_orixa': adjunto1,
              'segundo_orixa': orixa2,
              'adjunto_segundo_orixa': adjunto2,
              'terceiro_quarto_orixa': orixa34,
              'observacoes': observacoes,
            };

            // Inserir no Supabase
            await supabase.from('membros_historico').insert(membroData);

            if (!mounted) return;

            setState(() {
              _importados++;
            });
          } catch (e) {
            if (!mounted) return;

            setState(() {
              _erros++;
              if (_mensagensErro.length < 20) {
                _mensagensErro.add(
                  'Erro no registro ${i + batch.indexOf(registro)}: $e',
                );
              }
            });
          }
        }

        // Dar um tempo entre lotes
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      setState(() {
        _concluido = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Importação concluída! $_importados novos, $_duplicados já existentes, $_erros erros.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao importar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;

    try {
      // Tentar formato M/D/YY
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        int month = int.parse(parts[0]);
        int day = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        // Ajustar ano de 2 dígitos para 4 dígitos
        if (year < 100) {
          year += (year > 50) ? 1900 : 2000;
        }

        return DateTime(year, month, day);
      }
    } catch (e) {
      // Ignorar erro de parse
    }

    return null;
  }

  // Função auxiliar para converter para int ou null
  int? _parseIntOrNull(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    try {
      return int.parse(trimmed);
    } catch (e) {
      return null;
    }
  }

  // Função auxiliar para converter strings vazias em null
  String? _stringOrNull(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
