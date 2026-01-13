import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/registro_ponto.dart';
import '../bloc/ponto_bloc.dart';
import '../bloc/ponto_event.dart';
import '../bloc/ponto_state.dart';

class HistoricoPontoPage extends StatefulWidget {
  final String? membroId;
  final String? membroNome;

  const HistoricoPontoPage({
    super.key,
    this.membroId,
    this.membroNome,
  });

  @override
  State<HistoricoPontoPage> createState() => _HistoricoPontoPageState();
}

class _HistoricoPontoPageState extends State<HistoricoPontoPage> {
  DateTime? _dataInicio;
  DateTime? _dataFim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico - ${widget.membroNome ?? "Todos"}'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarFiltros,
          ),
        ],
      ),
      body: BlocBuilder<PontoBloc, PontoState>(
        builder: (context, state) {
          if (state is PontoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PontoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _carregarHistorico,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoricoCarregado) {
            if (state.historico.isEmpty) {
              return const Center(
                child: Text('Nenhum registro encontrado'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.historico.length,
              itemBuilder: (context, index) {
                final registro = state.historico[index];
                return _buildRegistroCard(registro);
              },
            );
          }

          return const Center(
            child: Text('Selecione um membro para ver o histórico'),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Widget _buildRegistroCard(RegistroPonto registro) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForTipo(registro.tipo),
          child: Icon(
            _getIconForTipo(registro.tipo),
            color: Colors.white,
          ),
        ),
        title: Text(
          _getTipoLabel(registro.tipo),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(registro.dataHora),
            ),
            if (registro.observacao != null)
              Text(
                registro.observacao!,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
        trailing: registro.manual
            ? const Icon(Icons.edit, color: Colors.orange)
            : null,
      ),
    );
  }

  void _carregarHistorico() {
    if (widget.membroId != null) {
      context.read<PontoBloc>().add(
            CarregarHistoricoEvent(
              membroId: widget.membroId!,
              dataInicio: _dataInicio,
              dataFim: _dataFim,
            ),
          );
    }
  }

  Color _getColorForTipo(TipoPonto tipo) {
    switch (tipo) {
      case TipoPonto.entrada:
        return Colors.green;
      case TipoPonto.saida:
        return Colors.red;
      case TipoPonto.saidaAlmoco:
        return Colors.orange;
      case TipoPonto.entradaAlmoco:
        return Colors.blue;
    }
  }

  IconData _getIconForTipo(TipoPonto tipo) {
    switch (tipo) {
      case TipoPonto.entrada:
        return Icons.login;
      case TipoPonto.saida:
        return Icons.logout;
      case TipoPonto.saidaAlmoco:
        return Icons.restaurant;
      case TipoPonto.entradaAlmoco:
        return Icons.restaurant_menu;
    }
  }

  String _getTipoLabel(TipoPonto tipo) {
    switch (tipo) {
      case TipoPonto.entrada:
        return 'Entrada';
      case TipoPonto.saida:
        return 'Saída';
      case TipoPonto.saidaAlmoco:
        return 'Saída Almoço';
      case TipoPonto.entradaAlmoco:
        return 'Retorno Almoço';
    }
  }

  void _mostrarFiltros() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por Período'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                _dataInicio != null
                    ? DateFormat('dd/MM/yyyy').format(_dataInicio!)
                    : 'Data Início',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _dataInicio ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (data != null) {
                  setState(() => _dataInicio = data);
                }
              },
            ),
            ListTile(
              title: Text(
                _dataFim != null
                    ? DateFormat('dd/MM/yyyy').format(_dataFim!)
                    : 'Data Fim',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _dataFim ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (data != null) {
                  setState(() => _dataFim = data);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _dataInicio = null;
                _dataFim = null;
              });
              Navigator.pop(context);
              _carregarHistorico();
            },
            child: const Text('Limpar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _carregarHistorico();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}
