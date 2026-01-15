import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Página unificada para lançar notas que requerem justificativa (F, G, H, I, J)
/// Permite buscar um membro e adicionar nota + justificativa
class LancarNotasComJustificativaPage extends StatefulWidget {
  final String tipoNota; // 'cambonagem', 'arrumacao', 'mensalidade', 'pais_maes', 'tata'
  
  const LancarNotasComJustificativaPage({
    super.key,
    required this.tipoNota,
  });

  @override
  State<LancarNotasComJustificativaPage> createState() => _LancarNotasComJustificativaPageState();
}

class _LancarNotasComJustificativaPageState extends State<LancarNotasComJustificativaPage> {
  final _supabase = Supabase.instance.client;
  final _buscaController = TextEditingController();
  final _observacaoController = TextEditingController();

  int _mesSelecionado = DateTime.now().month;
  int _anoSelecionado = DateTime.now().year;
  
  List<Map<String, dynamic>> _todosMembrosFiltrados = [];
  List<Map<String, dynamic>> _notasLancadas = [];
  Map<String, dynamic>? _membroSelecionado;
  double _notaSelecionada = 0.0;
  bool _isLoading = false;

  Color get _corTema {
    switch (widget.tipoNota) {
      case 'cambonagem':
      case 'arrumacao': return Colors.deepPurple;
      case 'mensalidade': return Colors.green[700]!;
      case 'pais_maes':
      case 'tata': return Colors.purple[700]!;
      default: return Colors.deepPurple;
    }
  }

  String get _tabelaNome {
    switch (widget.tipoNota) {
      case 'cambonagem': return 'escalas_cambonagem';
      case 'arrumacao': return 'escalas_arrumacao';
      case 'mensalidade': return 'status_mensalidade';
      case 'pais_maes': return 'conceitos_pais_maes';
      case 'tata': return 'bonus_tata';
      default: return '';
    }
  }

  String get _titulo {
    switch (widget.tipoNota) {
      case 'cambonagem': return 'Escalas de Cambonagem (Nota F)';
      case 'arrumacao': return 'Escalas de Arrumação (Nota G)';
      case 'mensalidade': return 'Mensalidades (Nota H)';
      case 'pais_maes': return 'Conceitos Pais/Mães (Nota I)';
      case 'tata': return 'Bônus Tata (Nota J)';
      default: return 'Lançar Notas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: _corTema,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtros de período
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _mesSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Mês',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(_nomeMes(i + 1)),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _mesSelecionado = value);
                        _carregarNotasLancadas();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _anoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Ano',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    items: [2024, 2025, 2026].map((ano) {
                      return DropdownMenuItem(
                        value: ano,
                        child: Text(ano.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _anoSelecionado = value);
                        _carregarNotasLancadas();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Card para adicionar nova nota
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_circle, color: _corTema),
                        const SizedBox(width: 8),
                        const Text(
                          'Adicionar Nova Nota',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Buscar membro
                    TextField(
                      controller: _buscaController,
                      decoration: InputDecoration(
                        labelText: 'Buscar membro',
                        hintText: 'Digite o nome do membro...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: _buscaController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _buscaController.clear();
                                    _todosMembrosFiltrados = [];
                                    _membroSelecionado = null;
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: _buscarMembros,
                    ),

                    // Resultados da busca
                    if (_todosMembrosFiltrados.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _todosMembrosFiltrados.length,
                          itemBuilder: (context, index) {
                            final membro = _todosMembrosFiltrados[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _corTema,
                                child: Text(
                                  membro['nome'][0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(membro['nome']),
                              subtitle: Text('Núcleo: ${membro['nucleo']}'),
                              onTap: () {
                                setState(() {
                                  _membroSelecionado = membro;
                                  _buscaController.text = membro['nome'];
                                  _todosMembrosFiltrados = [];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    // Membro selecionado + nota
                    if (_membroSelecionado != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _corTema.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: _corTema,
                                  child: Text(
                                    _membroSelecionado!['nome'][0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _membroSelecionado!['nome'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Núcleo: ${_membroSelecionado!['nucleo']}'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getNotaColor(_notaSelecionada),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _notaSelecionada.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Slider
                            Row(
                              children: [
                                const Text('Nota:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Slider(
                                    value: _notaSelecionada,
                                    min: 0,
                                    max: 10,
                                    divisions: 20,
                                    label: _notaSelecionada.toStringAsFixed(1),
                                    activeColor: _corTema,
                                    onChanged: (value) {
                                      setState(() => _notaSelecionada = value);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // Observação/Justificativa
                            const SizedBox(height: 8),
                            TextField(
                              controller: _observacaoController,
                              decoration: const InputDecoration(
                                labelText: 'Justificativa (opcional)',
                                hintText: 'Adicione observações ou justificativa...',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              maxLines: 2,
                            ),

                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _salvarNota,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _corTema,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                ),
                                icon: const Icon(Icons.save),
                                label: const Text('Salvar Nota'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Lista de notas já lançadas
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notasLancadas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma nota lançada para este mês',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notasLancadas.length,
                        itemBuilder: (context, index) {
                          final nota = _notasLancadas[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getNotaColor(nota['nota']?.toDouble() ?? 0),
                                child: Text(
                                  nota['nota']?.toStringAsFixed(1) ?? '0.0',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                nota['membro_nome'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Núcleo: ${nota['nucleo']}'),
                                  if (nota['observacao'] != null && nota['observacao'].toString().isNotEmpty)
                                    Text(
                                      nota['observacao'],
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _deletarNota(nota['id']),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarNotasLancadas();
  }

  void _buscarMembros(String query) {
    if (query.trim().isEmpty) {
      setState(() => _todosMembrosFiltrados = []);
      return;
    }

    // TODO: Buscar membros reais do banco de dados
    final membrosMock = [
      {'id': '1', 'nome': 'João Silva', 'nucleo': 'CCU'},
      {'id': '2', 'nome': 'Maria Santos', 'nucleo': 'CCM'},
      {'id': '3', 'nome': 'Ana Costa', 'nucleo': 'CCU'},
      {'id': '4', 'nome': 'Pedro Oliveira', 'nucleo': 'EST'},
      {'id': '5', 'nome': 'Julia Ferreira', 'nucleo': 'CCM'},
      {'id': '6', 'nome': 'Carlos Mendes', 'nucleo': 'CCU'},
      {'id': '7', 'nome': 'Beatriz Lima', 'nucleo': 'EST'},
      {'id': '8', 'nome': 'Rafael Souza', 'nucleo': 'CCM'},
      {'id': '9', 'nome': 'Fernanda Alves', 'nucleo': 'CCU'},
      {'id': '10', 'nome': 'Lucas Martins', 'nucleo': 'EST'},
    ];

    final filtrados = membrosMock
        .where((m) => m['nome']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() => _todosMembrosFiltrados = filtrados);
  }

  Future<void> _carregarNotasLancadas() async {
    setState(() => _isLoading = true);

    try {
      final response = await _supabase
          .from(_tabelaNome)
          .select()
          .eq('mes', _mesSelecionado)
          .eq('ano', _anoSelecionado)
          .order('membro_nome', ascending: true);

      setState(() {
        _notasLancadas = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar notas: $e')),
        );
      }
    }
  }

  Future<void> _deletarNota(String id) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      await _supabase.from(_tabelaNome).delete().eq('id', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nota excluída'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      await _carregarNotasLancadas();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getNotaColor(double nota) {
    if (nota >= 9) return Colors.green;
    if (nota >= 7) return Colors.lightGreen;
    if (nota >= 5) return Colors.orange;
    if (nota >= 3) return Colors.deepOrange;
    return Colors.red;
  }

  String _nomeMes(int mes) {
    return DateFormat.MMMM('pt_BR').format(DateTime(2000, mes));
  }

  Future<void> _salvarNota() async {
    if (_membroSelecionado == null) return;

    try {
      final dados = {
        'mes': _mesSelecionado,
        'ano': _anoSelecionado,
        'membro_id': _membroSelecionado!['id'],
        'membro_nome': _membroSelecionado!['nome'],
        'nucleo': _membroSelecionado!['nucleo'],
        'nota': _notaSelecionada,
        'observacao': _observacaoController.text.trim().isEmpty 
            ? null 
            : _observacaoController.text.trim(),
      };

      await _supabase.from(_tabelaNome).upsert(dados);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Nota salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Limpar formulário
      setState(() {
        _membroSelecionado = null;
        _notaSelecionada = 0.0;
        _buscaController.clear();
        _observacaoController.clear();
      });

      // Recarregar lista
      await _carregarNotasLancadas();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
