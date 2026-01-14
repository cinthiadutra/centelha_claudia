import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/supabase_service.dart';

class ImportarPessoasAntigasPage extends StatefulWidget {
  const ImportarPessoasAntigasPage({super.key});

  @override
  State<ImportarPessoasAntigasPage> createState() =>
      _ImportarPessoasAntigasPageState();
}

class _ImportarPessoasAntigasPageState
    extends State<ImportarPessoasAntigasPage> {
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
        title: const Text('Importar Pessoas do Sistema Antigo'),
        backgroundColor: Colors.orange,
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
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange[900]),
                            const SizedBox(width: 8),
                            Text(
                              'Importação de Dados Antigos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Esta ferramenta importa os cadastros do sistema antigo para o Supabase.',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '⚠️ ATENÇÃO: Os dados do sistema antigo estão com campos trocados. '
                          'O sistema tentará organizar da melhor forma possível.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Nome real está no campo RG\n'
                          '• Telefone/celular podem estar trocados\n'
                          '• Endereço pode estar incompleto',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão de importar
                if (!_isImporting && !_concluido)
                  ElevatedButton.icon(
                    onPressed: _importarPessoas,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('INICIAR IMPORTAÇÃO'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.orange,
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
                            'Importando registros...',
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
                            '✅ $_importados registros importados com sucesso',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_duplicados > 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              '⚠️ $_duplicados registros já existentes (pulados)',
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

  Future<void> _importarPessoas() async {
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
      // Carregar JSON do assets ou root
      final String jsonString = await rootBundle.loadString('CAD_PESSOAS.json');
      final List<dynamic> pessoas = json.decode(jsonString);

      if (!mounted) return;

      setState(() {
        _totalRegistros = pessoas.length;
      });

      final supabase = SupabaseService.instance.client;

      // Processar em lotes de 50
      const batchSize = 50;
      for (var i = 0; i < pessoas.length; i += batchSize) {
        final end = (i + batchSize < pessoas.length)
            ? i + batchSize
            : pessoas.length;
        final batch = pessoas.sublist(i, end);

        for (var pessoa in batch) {
          // Verificar se ainda está montado antes de processar
          if (!mounted) return;

          try {
            // Extrair dados do JSON CAD_PESSOAS
            final String nomeReal = pessoa['NOME'] ?? 'Nome não informado';
            final String? cpf = pessoa['CPF']?.toString().replaceAll(
              RegExp(r'[^\d]'),
              '',
            );

            // Tentar extrair data de nascimento (formato DD/MM/YYYY)
            DateTime? dataNascimento;
            try {
              if (pessoa['NASCIMENTO'] != null &&
                  pessoa['NASCIMENTO'].toString().isNotEmpty) {
                final parts = pessoa['NASCIMENTO'].toString().split('/');
                if (parts.length == 3) {
                  dataNascimento = DateTime(
                    int.parse(parts[2]), // ano
                    int.parse(parts[1]), // mês
                    int.parse(parts[0]), // dia
                  );
                }
              }
            } catch (e) {
              // Ignorar erro de data
            }

            // Extrair contatos
            final telefone = pessoa['TELEFONE'];
            final celular = pessoa['CELULAR'];
            final email = pessoa['E-MAIL'];

            // Endereço
            final logradouro = pessoa['RUA / AV'];
            final numero = pessoa['NUMERO'];
            final complemento = pessoa['COMPLEMENTO'];
            final bairro = pessoa['BAIRRO'];
            final cep = pessoa['CEP'];
            final cidade = pessoa['CIDADE'];
            final uf = pessoa['UF'];

            // Dados religiosos
            final nucleo = pessoa['NUCLEO'];
            final dataBatismo = pessoa['DATA DE BATISMO'];
            final padrinho = pessoa['PADRINHO'];
            final madrinha = pessoa['MADRINHA'];

            // Verificar se já existe registro com mesmo nome
            final existente = await supabase
                .from('cadastro')
                .select('id')
                .eq('nome', nomeReal)
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
            final Map<String, dynamic> cadastroData = {
              'nome': nomeReal,
              'nascimento': dataNascimento?.toIso8601String(),
              'documentos': {'cpf': cpf, 'rg': null},
              'contato': {
                'telefone': telefone,
                'celular': celular,
                'email': email,
              },
              'endereco': {
                'logradouro': logradouro != null && numero != null
                    ? '$logradouro, $numero${complemento != null && complemento.toString().isNotEmpty ? ' - $complemento' : ''}'
                    : logradouro,
                'bairro': bairro,
                'cidade': cidade,
                'uf': uf ?? 'RJ',
                'cep': cep,
              },
              'religioso': {
                'nucleo': nucleo,
                'data_batismo': dataBatismo,
                'padrinho': padrinho,
                'madrinha': madrinha,
              },
              'data_cadastro': DateTime.now().toIso8601String(),
            };

            // Inserir no Supabase
            await supabase.from('cadastro').insert(cadastroData);

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
                  'Erro no registro ${i + batch.indexOf(pessoa)}: $e',
                );
              }
            });
          }
        }

        // Dar um tempo entre lotes para não sobrecarregar
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
}
