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
                              value: (_importados + _erros) / _totalRegistros,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            'Progresso: ${_importados + _erros} / $_totalRegistros',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '✅ $_importados importados',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 24),
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
      _mensagensErro.clear();
      _concluido = false;
    });

    try {
      // Carregar JSON do assets ou root
      final String jsonString = await rootBundle.loadString(
        'pessoas_supabase.json',
      );
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
            // Extrair dados - os campos estão trocados no JSON original
            final String? cpfOriginal = pessoa['documentos']?['cpf'];
            final String nomeReal =
                pessoa['documentos']?['rg'] ?? 'Nome não informado';

            // Tentar extrair data de nascimento
            DateTime? dataNascimento;
            try {
              if (pessoa['nascimento'] != null) {
                dataNascimento = DateTime.parse(pessoa['nascimento']);
              }
            } catch (e) {
              // Ignorar erro de data
            }

            // CPF está no campo cpf mas parece ser um ID
            String? cpf;
            if (cpfOriginal != null && cpfOriginal.length >= 11) {
              cpf = cpfOriginal;
            }

            // Extrair outros dados (que também estão em campos trocados)
            final telefone = pessoa['contato']?['telefone'];
            final celular = pessoa['endereco']?['logradouro'];
            final email = pessoa['contato']?['email'];

            // Endereço
            final logradouro = pessoa['religioso']?['nucleo'];
            final cep = pessoa['religioso']?['padrinho'];
            final cidade = pessoa['religioso']?['madrinha'];
            final bairro = pessoa['endereco']?['bairro'];

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
                'logradouro': logradouro,
                'bairro': bairro,
                'cidade': cidade,
                'uf': 'RJ',
                'cep': cep,
              },
              'religioso': {
                'nucleo': null,
                'data_batismo': null,
                'padrinho': null,
                'madrinha': null,
              },
              'data_cadastro': DateTime.now().toIso8601String(),
            };

            // Inserir no Supabase
            await supabase.from('cadastros').insert(cadastroData);

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
              '✅ Importação concluída! $_importados registros importados, $_erros erros.',
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
