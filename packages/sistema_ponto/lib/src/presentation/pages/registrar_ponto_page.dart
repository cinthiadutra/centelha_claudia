import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/registro_ponto.dart';
import '../bloc/ponto_bloc.dart';
import '../bloc/ponto_event.dart';
import '../bloc/ponto_state.dart';

class RegistrarPontoPage extends StatefulWidget {
  final String? membroId;
  final String? membroNome;

  const RegistrarPontoPage({
    super.key,
    this.membroId,
    this.membroNome,
  });

  @override
  State<RegistrarPontoPage> createState() => _RegistrarPontoPageState();
}

class _RegistrarPontoPageState extends State<RegistrarPontoPage> {
  TipoPonto _tipoSelecionado = TipoPonto.entrada;
  final _observacaoController = TextEditingController();
  final _localizacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Ponto'),
        backgroundColor: Colors.teal,
      ),
      body: BlocListener<PontoBloc, PontoState>(
        listener: (context, state) {
          if (state is PontoRegistrado) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ponto registrado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is PontoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Membro: ${widget.membroNome ?? "Não informado"}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Data/Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tipo de Registro',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTipoButton(TipoPonto.entrada, 'Entrada', Icons.login),
              const SizedBox(height: 8),
              _buildTipoButton(TipoPonto.saida, 'Saída', Icons.logout),
              const SizedBox(height: 8),
              _buildTipoButton(
                TipoPonto.saidaAlmoco,
                'Saída Almoço',
                Icons.restaurant,
              ),
              const SizedBox(height: 8),
              _buildTipoButton(
                TipoPonto.entradaAlmoco,
                'Retorno Almoço',
                Icons.restaurant_menu,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _localizacaoController,
                decoration: const InputDecoration(
                  labelText: 'Localização (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _observacaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<PontoBloc, PontoState>(
                builder: (context, state) {
                  final isLoading = state is PontoLoading;
                  return ElevatedButton.icon(
                    onPressed: isLoading ? null : _registrarPonto,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(isLoading ? 'Registrando...' : 'Registrar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    _localizacaoController.dispose();
    super.dispose();
  }

  Widget _buildTipoButton(TipoPonto tipo, String label, IconData icon) {
    final isSelected = _tipoSelecionado == tipo;
    return InkWell(
      onTap: () => setState(() => _tipoSelecionado = tipo),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarPonto() {
    if (widget.membroId == null || widget.membroNome == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membro não informado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<PontoBloc>().add(
          RegistrarPontoEvent(
            membroId: widget.membroId!,
            membroNome: widget.membroNome!,
            tipo: _tipoSelecionado,
            localizacao: _localizacaoController.text.isEmpty
                ? null
                : _localizacaoController.text,
            observacao: _observacaoController.text.isEmpty
                ? null
                : _observacaoController.text,
          ),
        );
  }
}
