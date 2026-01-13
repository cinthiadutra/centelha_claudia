import 'package:flutter/material.dart';
import 'package:sistema_ponto/sistema_ponto.dart';

/// Página para importar e visualizar o calendário 2026
class ImportarCalendarioPage extends StatefulWidget {
  const ImportarCalendarioPage({super.key});

  @override
  State<ImportarCalendarioPage> createState() => _ImportarCalendarioPageState();
}

class _ImportarCalendarioPageState extends State<ImportarCalendarioPage> {
  final _importService = CalendarioImportService();
  List<AtividadeCalendario> _atividades = [];
  Map<TipoAtividadeCalendario, int> _contagem = {};
  bool _isLoading = false;
  String? _erro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Calendário 2026'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botão importar
                  ElevatedButton.icon(
                    onPressed: _importar,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Importar programacao_2026.json'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Erro
                  if (_erro != null)
                    Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '❌ Erro ao importar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(_erro!),
                          ],
                        ),
                      ),
                    ),

                  // Resumo
                  if (_atividades.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: ${_atividades.length} atividades',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Por tipo:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ..._contagem.entries.map((entry) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_getTipoLabel(entry.key)),
                                    Chip(
                                      label: Text('${entry.value}'),
                                      backgroundColor: Colors.teal[100],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lista de atividades
                    const Text(
                      'Primeiras 50 atividades:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._atividades.take(50).map((atividade) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _getIconForTipo(atividade.tipo),
                            color: Colors.teal,
                          ),
                          title: Text(atividade.descricao),
                          subtitle: Text(
                            '${atividade.data.day}/${atividade.data.month}/${atividade.data.year}',
                          ),
                          trailing: atividade.diaSessao != null
                              ? Chip(
                                  label: Text(
                                    atividade.diaSessao!,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                )
                              : null,
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
    );
  }

  IconData _getIconForTipo(TipoAtividadeCalendario tipo) {
    switch (tipo) {
      case TipoAtividadeCalendario.sessaoMedianica:
        return Icons.auto_awesome;
      case TipoAtividadeCalendario.atendimentoPublico:
        return Icons.people;
      case TipoAtividadeCalendario.correnteOracaoRenovacao:
        return Icons.diversity_3;
      case TipoAtividadeCalendario.encontroRamatis:
        return Icons.groups;
      case TipoAtividadeCalendario.grupoTrabalhoEspiritual:
        return Icons.group_work;
      case TipoAtividadeCalendario.cambonagem:
        return Icons.support_agent;
      case TipoAtividadeCalendario.arrumacao:
      case TipoAtividadeCalendario.desarrumacao:
        return Icons.cleaning_services;
      default:
        return Icons.event;
    }
  }

  String _getTipoLabel(TipoAtividadeCalendario tipo) {
    switch (tipo) {
      case TipoAtividadeCalendario.sessaoMedianica:
        return 'Sessões Mediúnicas';
      case TipoAtividadeCalendario.atendimentoPublico:
        return 'Atendimentos Públicos';
      case TipoAtividadeCalendario.correnteOracaoRenovacao:
        return 'COR';
      case TipoAtividadeCalendario.encontroRamatis:
        return 'Ramatis';
      case TipoAtividadeCalendario.grupoTrabalhoEspiritual:
        return 'Grupos de Trabalho';
      case TipoAtividadeCalendario.cambonagem:
        return 'Cambonagem';
      case TipoAtividadeCalendario.arrumacao:
        return 'Arrumação';
      case TipoAtividadeCalendario.desarrumacao:
        return 'Desarrumação';
      default:
        return 'Outras';
    }
  }

  Future<void> _importar() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      // Importar do JSON
      final atividades = await _importService.carregarDeJson(
        'packages/sistema_ponto/assets/programacao_2026.json',
      );

      // Contar por tipo
      final contagem = _importService.contarPorTipo(atividades);

      setState(() {
        _atividades = atividades;
        _contagem = contagem;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${atividades.length} atividades importadas!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _isLoading = false;
      });
    }
  }
}
