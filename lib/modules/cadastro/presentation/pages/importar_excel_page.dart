import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/supabase_service.dart';
import '../../data/models/usuario_model.dart';

class ImportarExcelPage extends StatefulWidget {
  const ImportarExcelPage({super.key});

  @override
  State<ImportarExcelPage> createState() => _ImportarExcelPageState();
}

class _ImportarExcelPageState extends State<ImportarExcelPage> {
  final _supabaseService = GetIt.I<SupabaseService>();
  
  bool _isLoading = false;
  String? _statusMessage;
  List<Map<String, dynamic>> _dadosPreview = [];
  Uint8List? _fileBytes;
  String? _fileName;
  
  int _totalLinhas = 0;
  int _linhasProcessadas = 0;
  int _sucessos = 0;
  int _erros = 0;

  Future<void> _selecionarArquivo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _fileBytes = result.files.single.bytes;
          _fileName = result.files.single.name;
          _statusMessage = null;
          _dadosPreview = [];
        });

        _processarPreview();
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao selecionar arquivo: $e';
      });
    }
  }

  void _processarPreview() {
    if (_fileBytes == null) return;

    try {
      var excel = Excel.decodeBytes(_fileBytes!);
      var table = excel.tables.keys.first;
      var rows = excel.tables[table]!.rows;

      if (rows.isEmpty) {
        setState(() {
          _statusMessage = 'Planilha vazia';
        });
        return;
      }

      // Pegar primeiras 10 linhas para preview (ignorando cabeçalho)
      List<Map<String, dynamic>> preview = [];
      
      for (int i = 1; i < rows.length && preview.length < 10; i++) {
        var row = rows[i];
        preview.add({
          'numero_cadastro': row[0]?.value?.toString() ?? '',
          'nome': row[1]?.value?.toString() ?? '',
          'cpf': row[2]?.value?.toString() ?? '',
          'data_nascimento': row[3]?.value?.toString() ?? '',
          'telefone_celular': row[4]?.value?.toString() ?? '',
          'email': row[5]?.value?.toString() ?? '',
        });
      }

      setState(() {
        _dadosPreview = preview;
        _totalLinhas = rows.length - 1; // menos cabeçalho
        _statusMessage = 'Arquivo carregado: $_totalLinhas registros encontrados';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao processar arquivo: $e';
      });
    }
  }

  Future<void> _importarDados() async {
    if (_fileBytes == null) return;

    setState(() {
      _isLoading = true;
      _linhasProcessadas = 0;
      _sucessos = 0;
      _erros = 0;
      _statusMessage = 'Importando...';
    });

    try {
      var excel = Excel.decodeBytes(_fileBytes!);
      var table = excel.tables.keys.first;
      var rows = excel.tables[table]!.rows;

      // Processar cada linha (ignorar cabeçalho)
      for (int i = 1; i < rows.length; i++) {
        var row = rows[i];
        
        try {
          // Criar modelo do usuário
          final usuario = UsuarioModel(
            numeroCadastro: row[0]?.value?.toString(),
            nome: row[1]?.value?.toString() ?? '',
            cpf: row[2]?.value?.toString() ?? '',
            dataNascimento: _parseData(row[3]?.value?.toString()),
            telefoneCelular: row[4]?.value?.toString(),
            email: row[5]?.value?.toString(),
            endereco: row[6]?.value?.toString(),
            nucleoCadastro: row[7]?.value?.toString(),
            nucleoPertence: row[8]?.value?.toString(),
            statusAtual: row[9]?.value?.toString() ?? 'Ativo',
            classificacao: row[10]?.value?.toString(),
          );

          // Inserir no Supabase
          await _supabaseService.client
              .from('usuarios')
              .insert(usuario.toJson());

          setState(() {
            _sucessos++;
          });
        } catch (e) {
          print('Erro linha $i: $e');
          setState(() {
            _erros++;
          });
        }

        setState(() {
          _linhasProcessadas++;
          _statusMessage = 'Importando: $_linhasProcessadas/$_totalLinhas';
        });
      }

      setState(() {
        _isLoading = false;
        _statusMessage = 
            'Importação concluída!\n'
            'Sucessos: $_sucessos\n'
            'Erros: $_erros\n'
            'Total: $_linhasProcessadas';
      });

      if (_erros == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Importação concluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Erro na importação: $e';
      });
    }
  }

  DateTime? _parseData(String? dataStr) {
    if (dataStr == null || dataStr.isEmpty) return null;
    
    try {
      // Tentar formato DD/MM/YYYY
      if (dataStr.contains('/')) {
        var parts = dataStr.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      }
      // Tentar formato YYYY-MM-DD
      return DateTime.parse(dataStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Cadastros do Excel'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Informações
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instruções de Importação',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'O arquivo Excel deve conter as seguintes colunas (nesta ordem):',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildColuna('A', 'Número Cadastro'),
                    _buildColuna('B', 'Nome'),
                    _buildColuna('C', 'CPF'),
                    _buildColuna('D', 'Data Nascimento (DD/MM/YYYY)'),
                    _buildColuna('E', 'Telefone Celular'),
                    _buildColuna('F', 'Email'),
                    _buildColuna('G', 'Endereço'),
                    _buildColuna('H', 'Núcleo Cadastro'),
                    _buildColuna('I', 'Núcleo Pertence'),
                    _buildColuna('J', 'Status'),
                    _buildColuna('K', 'Classificação'),
                    const SizedBox(height: 12),
                    const Text(
                      'Obs: A primeira linha deve conter os cabeçalhos das colunas.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Botão selecionar arquivo
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _selecionarArquivo,
              icon: const Icon(Icons.folder_open),
              label: Text(_fileName ?? 'Selecionar Arquivo Excel'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Status
            if (_statusMessage != null)
              Card(
                color: _erros > 0 ? Colors.orange[50] : Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _statusMessage!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

            // Preview
            if (_dadosPreview.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Preview dos Dados:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nº')),
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('CPF')),
                      DataColumn(label: Text('Nasc.')),
                      DataColumn(label: Text('Telefone')),
                      DataColumn(label: Text('Email')),
                    ],
                    rows: _dadosPreview.map((dados) {
                      return DataRow(
                        cells: [
                          DataCell(Text(dados['numero_cadastro'] ?? '')),
                          DataCell(Text(dados['nome'] ?? '')),
                          DataCell(Text(dados['cpf'] ?? '')),
                          DataCell(Text(dados['data_nascimento'] ?? '')),
                          DataCell(Text(dados['telefone_celular'] ?? '')),
                          DataCell(Text(dados['email'] ?? '')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            // Botão importar
            if (_fileBytes != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _importarDados,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.upload),
                label: Text(_isLoading ? 'Importando...' : 'Importar Dados'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],

            // Progresso
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(
                  value: _totalLinhas > 0 ? _linhasProcessadas / _totalLinhas : 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColuna(String letra, String descricao) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.teal[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              letra,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(descricao, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
