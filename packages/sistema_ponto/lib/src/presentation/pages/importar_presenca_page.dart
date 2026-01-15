import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/presenca_import_model.dart';
import '../../data/repositories/calendario_repository.dart';
import '../../data/repositories/presenca_repository.dart';
import '../../data/services/presenca_import_service.dart';

/// Página para importar registros de presença de arquivo CSV/TXT
class ImportarPresencaPage extends StatefulWidget {
  const ImportarPresencaPage({super.key});

  @override
  State<ImportarPresencaPage> createState() => _ImportarPresencaPageState();
}

class _ImportarPresencaPageState extends State<ImportarPresencaPage> {
  final _importService = PresencaImportService();
  late final CalendarioRepository _calendarioRepo;
  late final PresencaRepository _presencaRepo;

  List<PresencaImportModel> _registros = [];
  Map<String, dynamic>? _estatisticas;
  bool _isLoading = false;
  String? _erro;
  String? _nomeArquivo;
  int _registrosImportados = 0;
  bool _importacaoConcluida = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Presenças'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instruções
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              Text(
                                'Como importar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '1. Selecione o arquivo CSV/TXT com os registros de ponto\n'
                            '2. O arquivo deve ter as colunas: ra, Nome, dept, Tempo, Máquina\n'
                            '3. O sistema irá processar e vincular com o calendário 2026\n'
                            '4. Presenças serão registradas automaticamente',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão selecionar arquivo
                  ElevatedButton.icon(
                    onPressed: _selecionarArquivo,
                    icon: const Icon(Icons.file_upload),
                    label: Text(_nomeArquivo ?? 'Selecionar Arquivo CSV/TXT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.indigo,
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
                            const Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Erro ao processar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(_erro!),
                          ],
                        ),
                      ),
                    ),

                  // Estatísticas do arquivo
                  if (_estatisticas != null) ...[
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.analytics, color: Colors.green[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Arquivo processado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildEstatistica(
                              'Total de registros',
                              _estatisticas!['total'].toString(),
                            ),
                            _buildEstatistica(
                              'Membros únicos',
                              _estatisticas!['membros_unicos'].toString(),
                            ),
                            _buildEstatistica(
                              'Datas diferentes',
                              _estatisticas!['datas_unicas'].toString(),
                            ),
                            if (_estatisticas!['primeira_data'] != null)
                              _buildEstatistica(
                                'Período',
                                '${_formatarData(_estatisticas!['primeira_data'])} até ${_formatarData(_estatisticas!['ultima_data'])}',
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão processar
                    if (!_importacaoConcluida)
                      ElevatedButton.icon(
                        onPressed: _processarImportacao,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Processar e Importar para Supabase'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),

                    // Resultado da importação
                    if (_importacaoConcluida)
                      Card(
                        color: Colors.teal[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.teal,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '✅ Importação concluída!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_registrosImportados registros salvos no Supabase',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],

                  // Preview dos registros
                  if (_registros.isNotEmpty && !_importacaoConcluida) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Primeiros 50 registros:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ..._registros.take(50).map((registro) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Text(
                              registro.codigo,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            registro.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _formatarDataHora(registro.dataHora),
                          ),
                          trailing: Icon(
                            Icons.check_circle,
                            color: Colors.green[400],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _calendarioRepo = CalendarioRepository(supabase);
    _presencaRepo = PresencaRepository(supabase);
  }

  Widget _buildEstatistica(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  String _formatarDataHora(DateTime dataHora) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dataHora);
  }

  Future<void> _processarImportacao() async {
    if (_registros.isEmpty) return;

    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      // Buscar todas as atividades do calendário
      final atividades = await _calendarioRepo.buscarTodasAtividades();

      // Criar mapa de data -> atividades
      final atividadesPorData = <DateTime, String>{};
      for (var atividade in atividades) {
        final data = atividade.dataAsDateTime;
        if (data != null && atividade.id != null) {
          atividadesPorData[DateTime(data.year, data.month, data.day)] =
              atividade.id!;
        }
      }

      // TODO: Implementar mapeamento de código/nome para membro_id
      // Por enquanto, vamos criar registros com IDs temporários

      int salvos = 0;
      for (var registro in _registros) {
        final dataRegistro = registro.dataApenas;
        final atividadeId = atividadesPorData[dataRegistro];

        if (atividadeId != null) {
          // Aqui você deve implementar a lógica para buscar o membro_id
          // baseado no código ou nome do registro
          // Por exemplo: buscar na tabela 'membros' ou 'cadastros'

          // Placeholder: usando código como membro_id temporário
          final membroId = 'temp_${registro.codigo}';

          final presenca = registro.toEntity(
            membroId: membroId,
            atividadeId: atividadeId,
          );

          try {
            await _presencaRepo.salvar(presenca);
            salvos++;
          } catch (e) {
            print('Erro ao salvar registro: $e');
          }
        }
      }

      setState(() {
        _registrosImportados = salvos;
        _importacaoConcluida = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $salvos registros importados com sucesso!'),
            backgroundColor: Colors.teal,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao processar importação: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _selecionarArquivo() async {
    try {
      // Selecionar arquivo
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      setState(() {
        _isLoading = true;
        _erro = null;
        _nomeArquivo = result.files.first.name;
        _importacaoConcluida = false;
      });

      // Ler conteúdo do arquivo
      final file = File(result.files.first.path!);
      final conteudo = await file.readAsString();

      // Processar arquivo
      final registros = await _importService.carregarDeArquivo(conteudo);
      final estatisticas = _importService.obterEstatisticas(registros);

      setState(() {
        _registros = registros;
        _estatisticas = estatisticas;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${registros.length} registros carregados!'),
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
