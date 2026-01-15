import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/calendario_repository.dart';
import '../../data/repositories/presenca_repository.dart';
import '../../domain/entities/avaliacao_mensal.dart';
import '../../domain/entities/calendario.dart';
import '../../domain/entities/membro_avaliacao.dart';
import '../../domain/usecases/calcular_avaliacao_mensal_usecase.dart';

/// Página para gerar e visualizar ranking mensal
class RankingMensalPage extends StatefulWidget {
  const RankingMensalPage({super.key});

  @override
  State<RankingMensalPage> createState() => _RankingMensalPageState();
}

class _RankingMensalPageState extends State<RankingMensalPage> {
  late final CalendarioRepository _calendarioRepo;
  late final PresencaRepository _presencaRepo;
  final _useCase = CalcularAvaliacaoMensalUseCase();

  int _mesSelecionado = DateTime.now().month;
  int _anoSelecionado = DateTime.now().year;
  String? _nucleoSelecionado; // null = todos

  List<AvaliacaoMensal> _avaliacoes = [];
  bool _isLoading = false;
  String? _erro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking Mensal'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filtros
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filtros',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  initialValue: _mesSelecionado,
                                  decoration: const InputDecoration(
                                    labelText: 'Mês',
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
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String?>(
                            initialValue: _nucleoSelecionado,
                            decoration: const InputDecoration(
                              labelText: 'Núcleo',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Todos'),
                              ),
                              const DropdownMenuItem(
                                value: 'CCU',
                                child: Text('CCU'),
                              ),
                              const DropdownMenuItem(
                                value: 'CPO',
                                child: Text('CPO'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _nucleoSelecionado = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _gerarRanking,
                            icon: const Icon(Icons.calculate),
                            label: const Text('Gerar Ranking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
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
                                  'Erro',
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

                  // Ranking
                  if (_avaliacoes.isNotEmpty) ...[
                    Card(
                      color: Colors.purple[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.emoji_events,
                                    color: Colors.purple[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Ranking ${_nomeMes(_mesSelecionado)}/$_anoSelecionado',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[900],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_avaliacoes.length} membros avaliados',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista do ranking
                    ..._avaliacoes.asMap().entries.map((entry) {
                      final posicao = entry.key + 1;
                      final avaliacao = entry.value;

                      return Card(
                        elevation: posicao <= 3 ? 4 : 1,
                        color: posicao == 1
                            ? Colors.amber[50]
                            : posicao == 2
                                ? Colors.grey[100]
                                : posicao == 3
                                    ? Colors.brown[50]
                                    : null,
                        child: ListTile(
                          leading: _buildMedalha(posicao),
                          title: Text(
                            avaliacao.membroNome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Nota Real: ${avaliacao.notaReal.toStringAsFixed(1)}'),
                              Text(
                                  'Nota Final: ${avaliacao.notaFinal.toStringAsFixed(1)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () => _mostrarDetalhes(avaliacao),
                          ),
                        ),
                      );
                    }),
                  ],

                  // Mensagem inicial
                  if (_avaliacoes.isEmpty && _erro == null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.search,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Selecione o período e clique em "Gerar Ranking"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildMedalha(int posicao) {
    if (posicao == 1) {
      return const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text('🥇', style: TextStyle(fontSize: 24)),
      );
    } else if (posicao == 2) {
      return const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text('🥈', style: TextStyle(fontSize: 24)),
      );
    } else if (posicao == 3) {
      return const CircleAvatar(
        backgroundColor: Colors.brown,
        child: Text('🥉', style: TextStyle(fontSize: 24)),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.purple[100],
        child: Text(
          '$posicao°',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      );
    }
  }

  Widget _buildNotaDetalhe(String label, double nota, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            nota.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
              color: nota >= 8
                  ? Colors.green
                  : nota >= 5
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Implementar conversão real das entidades
  List<AtividadeCalendario> _converterAtividades(List<dynamic> atividades) {
    // Placeholder - retornar lista vazia por enquanto
    return [];
  }

  RegistroPresenca _converterPresenca(dynamic presenca) {
    // Placeholder
    return const RegistroPresenca(
      membroId: '',
      atividadeId: '',
      presente: true,
    );
  }

  Future<void> _gerarRanking() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      // TODO: Buscar membros reais do banco de dados
      // Por enquanto, usar dados mockados para teste
      final membros = _getMembrosExemplo();

      // Buscar atividades do mês
      final atividades = await _calendarioRepo.buscarPorMes(
        _mesSelecionado,
        _anoSelecionado,
      );

      if (atividades.isEmpty) {
        throw Exception('Nenhuma atividade encontrada para este período');
      }

      // Buscar presenças do período
      final inicio = DateTime(_anoSelecionado, _mesSelecionado, 1);
      final fim = DateTime(_anoSelecionado, _mesSelecionado + 1, 0);
      final presencas = await _presencaRepo.buscarPorPeriodo(inicio, fim);

      // Calcular avaliação para cada membro
      final avaliacoes = <AvaliacaoMensal>[];
      for (var membro in membros) {
        // Filtrar por núcleo se selecionado
        if (_nucleoSelecionado != null &&
            membro.nucleo.toString() != _nucleoSelecionado) {
          continue;
        }

        final avaliacao = _useCase.calcular(
          DadosCalculoAvaliacao(
            membro: membro,
            mes: _mesSelecionado,
            ano: _anoSelecionado,
            atividadesDoMes: _converterAtividades(atividades),
            presencas: presencas.map((p) => _converterPresenca(p)).toList(),
            conceitosLideresGrupoTarefa: {},
            conceitosLideresAcaoSocial: {},
            conceitosPaisMaes: {},
            bonusTata: {},
            membroNovo: false,
          ),
        );
        avaliacoes.add(avaliacao);
      }

      // Normalizar notas
      final avaliacoesNormalizadas = _useCase.normalizarNotas(avaliacoes);

      // Ordenar por nota final (ranking)
      avaliacoesNormalizadas.sort((a, b) => b.notaFinal.compareTo(a.notaFinal));

      setState(() {
        _avaliacoes = avaliacoesNormalizadas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _isLoading = false;
      });
    }
  }

  // Membros de exemplo para teste
  List<MembroAvaliacao> _getMembrosExemplo() {
    return [
      MembroAvaliacao(
        id: '1',
        nomeCompleto: 'João Silva',
        classificacao: ClassificacaoMedinica.grauVerde,
        diaSessao: DiaSessao.tercaCCU,
        nucleo: Nucleo.ccu,
        grupoTrabalhoEspiritual: GrupoTrabalhoEspiritual.grupoPaz,
        gruposTarefa: [GrupoTarefa.vendas],
        gruposAcaoSocial: [],
        cargosLideranca: [],
        mensalidadeEmDia: true,
      ),
      MembroAvaliacao(
        id: '2',
        nomeCompleto: 'Maria Santos',
        classificacao: ClassificacaoMedinica.grauAzul,
        diaSessao: DiaSessao.quartaCCU,
        nucleo: Nucleo.ccu,
        grupoTrabalhoEspiritual: GrupoTrabalhoEspiritual.grupoLuz,
        gruposTarefa: [GrupoTarefa.comunicacaoMarketing],
        gruposAcaoSocial: [GrupoAcaoSocial.projetoSimiromba],
        cargosLideranca: [CargoLideranca.liderGrupoTarefa],
        mensalidadeEmDia: true,
      ),
      MembroAvaliacao(
        id: '3',
        nomeCompleto: 'Pedro Oliveira',
        classificacao: ClassificacaoMedinica.grauAmarelo,
        diaSessao: DiaSessao.sextaCCU,
        nucleo: Nucleo.ccu,
        grupoTrabalhoEspiritual: null,
        gruposTarefa: [],
        gruposAcaoSocial: [],
        cargosLideranca: [],
        mensalidadeEmDia: false,
      ),
    ];
  }

  void _mostrarDetalhes(AvaliacaoMensal avaliacao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(avaliacao.membroNome),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotaDetalhe('A - Frequência Sessões', avaliacao.notaA),
              _buildNotaDetalhe('B - Atividades Espirituais', avaliacao.notaB),
              _buildNotaDetalhe('C - Conceito Grupo-Tarefa', avaliacao.notaC),
              _buildNotaDetalhe('D - Conceito Ação Social', avaliacao.notaD),
              _buildNotaDetalhe('E - Instruções Espirituais', avaliacao.notaE),
              _buildNotaDetalhe('F - Cambonagem', avaliacao.notaF),
              _buildNotaDetalhe('G - Arrumação/Desarrumação', avaliacao.notaG),
              _buildNotaDetalhe('H - Mensalidade', avaliacao.notaH),
              _buildNotaDetalhe('I - Conceito Pai/Mãe', avaliacao.notaI),
              _buildNotaDetalhe('J - Bônus Tata', avaliacao.notaJ),
              _buildNotaDetalhe('K - Nota Mês Anterior', avaliacao.notaK),
              _buildNotaDetalhe('L - Bônus Liderança', avaliacao.notaL),
              const Divider(height: 24),
              _buildNotaDetalhe('NOTA REAL', avaliacao.notaReal, bold: true),
              _buildNotaDetalhe('NOTA FINAL', avaliacao.notaFinal, bold: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _nomeMes(int mes) {
    return DateFormat.MMMM('pt_BR').format(DateTime(2000, mes));
  }
}
