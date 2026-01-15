import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Página para líderes lançarem conceitos de Grupo-Tarefa (Nota C) e Ação Social (Nota D)
/// O líder primeiro escolhe qual grupo ele lidera, depois vê apenas os membros daquele grupo
class LancarConceitosPage extends StatefulWidget {
  const LancarConceitosPage({super.key});

  @override
  State<LancarConceitosPage> createState() => _LancarConceitosPageState();
}

class _LancarConceitosPageState extends State<LancarConceitosPage> {
  final _supabase = Supabase.instance.client;

  int _mesSelecionado = DateTime.now().month;
  int _anoSelecionado = DateTime.now().year;
  String _tipoConceito = 'grupo_tarefa'; // 'grupo_tarefa' ou 'acao_social'
  String? _grupoSelecionado; // Qual grupo o líder selecionou

  List<Map<String, dynamic>> _grupos = []; // Lista de grupos disponíveis
  List<Map<String, dynamic>> _membros = []; // Membros do grupo selecionado
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final tituloTipo =
        _tipoConceito == 'grupo_tarefa' ? 'Grupo-Tarefa' : 'Ação Social';

    return Scaffold(
      appBar: AppBar(
        title: Text('Conceitos de $tituloTipo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Tipo de conceito
                DropdownButtonFormField<String>(
                  initialValue: _tipoConceito,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Conceito',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'grupo_tarefa',
                      child: Text('Grupo-Tarefa (Nota C)'),
                    ),
                    DropdownMenuItem(
                      value: 'acao_social',
                      child: Text('Ação Social (Nota D)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _tipoConceito = value;
                        _grupoSelecionado = null;
                        _membros = [];
                      });
                      _carregarGrupos();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Seleção do grupo
                DropdownButtonFormField<String>(
                  initialValue: _grupoSelecionado,
                  decoration: InputDecoration(
                    labelText: _grupos.isEmpty
                        ? 'Carregando grupos...'
                        : 'Selecione o ${_tipoConceito == "grupo_tarefa" ? "Grupo-Tarefa" : "Grupo de Ação Social"} que você lidera',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.groups),
                  ),
                  items: _grupos.map((grupo) {
                    return DropdownMenuItem<String>(
                      value: grupo['id'] as String,
                      child: Text(grupo['nome'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _grupoSelecionado = value);
                      _carregarMembrosDoGrupo();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Mês e Ano
                Row(
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
                            if (_grupoSelecionado != null) {
                              _carregarMembrosDoGrupo();
                            }
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
                            if (_grupoSelecionado != null) {
                              _carregarMembrosDoGrupo();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de membros do grupo
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _grupoSelecionado == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group_add,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Selecione o grupo que você lidera',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : _membros.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum membro neste grupo',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _membros.length,
                            itemBuilder: (context, index) {
                              final membro = _membros[index];
                              final nota = membro['nota'] as double?;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Nome e núcleo
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.deepPurple,
                                            child: Text(
                                              membro['nome'][0].toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  membro['nome'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Núcleo: ${membro['nucleo']}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Nota atual
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getNotaColor(nota ?? 0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              nota != null
                                                  ? nota.toStringAsFixed(1)
                                                  : '0.0',
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

                                      // Slider de nota
                                      Row(
                                        children: [
                                          const Text(
                                            'Nota:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              value: nota ?? 0.0,
                                              min: 0,
                                              max: 10,
                                              divisions: 20, // 0.5 em 0.5
                                              label: nota != null
                                                  ? nota.toStringAsFixed(1)
                                                  : '0.0',
                                              activeColor: Colors.deepPurple,
                                              onChanged: (value) {
                                                setState(() {
                                                  membro['nota'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Régua de valores
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(11, (i) {
                                          return Text(
                                            i.toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: _grupoSelecionado != null && _membros.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _salvarConceitos,
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.save),
              label: const Text('Salvar Conceitos'),
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  Future<void> _carregarGrupos() async {
    setState(() => _isLoading = true);

    try {
      // Buscar grupos reais do Supabase
      final response = await _supabase
          .from('grupos')
          .select()
          .eq('tipo', _tipoConceito)
          .eq('ativo', true)
          .order('nome', ascending: true);

      setState(() {
        _grupos = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar grupos: $e')),
        );
      }
    }
  }

  Future<void> _carregarMembrosDoGrupo() async {
    if (_grupoSelecionado == null) return;

    setState(() => _isLoading = true);

    try {
      // Buscar membros reais vinculados ao grupo no Supabase
      final membrosResponse = await _supabase
          .from('grupo_membros')
          .select('membro_id, membro_nome, nucleo')
          .eq('grupo_id', _grupoSelecionado!)
          .eq('ativo', true)
          .order('membro_nome', ascending: true);

      final membrosList = List<Map<String, dynamic>>.from(membrosResponse);

      // Se não houver membros vinculados, usar dados mock temporariamente
      final membrosParaUsar = membrosList.isEmpty
          ? _obterMembrosMockPorGrupo(_grupoSelecionado!)
          : membrosList;

      // Buscar conceitos já lançados para estes membros
      final tabela = _tipoConceito == 'grupo_tarefa'
          ? 'conceitos_grupo_tarefa'
          : 'conceitos_acao_social';

      final conceitos = await _supabase
          .from(tabela)
          .select()
          .eq('mes', _mesSelecionado)
          .eq('ano', _anoSelecionado);

      final conceitosMap = <String, Map<String, dynamic>>{};
      for (var conceito in conceitos) {
        conceitosMap[conceito['membro_id']] = conceito;
      }

      // Combinar membros com conceitos existentes
      final membrosComConceitos = membrosParaUsar.map((membro) {
        final conceito = conceitosMap[membro['membro_id']];
        return {
          'id': membro['membro_id'],
          'nome': membro['membro_nome'],
          'nucleo': membro['nucleo'],
          'nota': conceito?['nota']?.toDouble() ?? 0.0,
          'conceito_id': conceito?['id'],
        };
      }).toList();

      setState(() {
        _membros = membrosComConceitos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar membros: $e')),
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

  List<Map<String, dynamic>> _obterMembrosMockPorGrupo(String grupoId) {
    // Dados mock temporários enquanto não há vínculos reais
    // Retorna formato compatível com grupo_membros: membro_id, membro_nome, nucleo

    final todosMembrosMock = {
      'gt_patrimonio': [
        {'membro_id': '1', 'membro_nome': 'João Silva', 'nucleo': 'CCU'},
        {'membro_id': '2', 'membro_nome': 'Maria Santos', 'nucleo': 'CCM'},
      ],
      'gt_secretaria': [
        {'membro_id': '3', 'membro_nome': 'Ana Costa', 'nucleo': 'CCU'},
        {'membro_id': '4', 'membro_nome': 'Pedro Oliveira', 'nucleo': 'EST'},
      ],
      'gt_vendas': [
        {'membro_id': '5', 'membro_nome': 'Julia Ferreira', 'nucleo': 'CCM'},
        {'membro_id': '6', 'membro_nome': 'Carlos Mendes', 'nucleo': 'CCU'},
      ],
      'gt_comunicacao': [
        {'membro_id': '7', 'membro_nome': 'Beatriz Lima', 'nucleo': 'EST'},
        {'membro_id': '8', 'membro_nome': 'Rafael Souza', 'nucleo': 'CCM'},
      ],
      'gas_coordenacao': [
        {'membro_id': '1', 'membro_nome': 'João Silva', 'nucleo': 'CCU'},
        {'membro_id': '5', 'membro_nome': 'Julia Ferreira', 'nucleo': 'CCM'},
      ],
      'gas_captacao': [
        {'membro_id': '2', 'membro_nome': 'Maria Santos', 'nucleo': 'CCM'},
        {'membro_id': '7', 'membro_nome': 'Beatriz Lima', 'nucleo': 'EST'},
      ],
      'gas_simiromba': [
        {'membro_id': '3', 'membro_nome': 'Ana Costa', 'nucleo': 'CCU'},
        {'membro_id': '8', 'membro_nome': 'Rafael Souza', 'nucleo': 'CCM'},
      ],
    };

    return todosMembrosMock[grupoId] ?? [];
  }

  Future<void> _salvarConceitos() async {
    try {
      final tabela = _tipoConceito == 'grupo_tarefa'
          ? 'conceitos_grupo_tarefa'
          : 'conceitos_acao_social';

      int salvos = 0;

      for (var membro in _membros) {
        final dados = {
          'mes': _mesSelecionado,
          'ano': _anoSelecionado,
          'membro_id': membro['id'],
          'membro_nome': membro['nome'],
          'nucleo': membro['nucleo'],
          'nota': membro['nota'],
        };

        if (membro['conceito_id'] != null) {
          // Atualizar
          await _supabase
              .from(tabela)
              .update(dados)
              .eq('id', membro['conceito_id']);
        } else {
          // Inserir
          await _supabase.from(tabela).insert(dados);
        }

        salvos++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $salvos conceitos salvos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Recarregar para atualizar IDs
      await _carregarMembrosDoGrupo();
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
