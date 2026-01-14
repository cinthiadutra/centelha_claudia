import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../../../modules/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/consulta.dart';
import '../controllers/consulta_controller.dart';

/// Página para ler consulta por número
/// Disponível para todos os níveis (nível 1 só vê as próprias)
class LerConsultaPage extends StatefulWidget {
  const LerConsultaPage({super.key});

  @override
  State<LerConsultaPage> createState() => _LerConsultaPageState();
}

class _LerConsultaPageState extends State<LerConsultaPage> {
  final consultaController = Get.find<ConsultaController>();
  final numeroController = TextEditingController();

  Consulta? consultaEncontrada;
  bool buscaRealizada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler Consulta'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar Consulta por Número',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: numeroController,
                            decoration: const InputDecoration(
                              labelText: 'Número da Consulta (5 dígitos)',
                              prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                              hintText: '00001',
                            ),
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) => _buscar(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => _buscar(context),
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _limpar,
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Resultado da consulta
            if (consultaEncontrada != null) ...[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Consulta ${consultaEncontrada!.numeroConsulta}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 32),

                        _buildInfoSection('INFORMAÇÕES GERAIS'),
                        _buildInfoRow(
                          'Número da Consulta',
                          consultaEncontrada!.numeroConsulta,
                        ),
                        _buildInfoRow(
                          'Data',
                          _formatarData(consultaEncontrada!.data),
                        ),
                        _buildInfoRow(
                          'Hora de Início',
                          consultaEncontrada!.horaInicio,
                        ),

                        const SizedBox(height: 24),
                        _buildInfoSection('PARTICIPANTES'),
                        _buildInfoRow(
                          'Nome do Consulente',
                          consultaEncontrada!.nomeConsulente,
                        ),
                        _buildInfoRow(
                          'Nome do Médium',
                          consultaEncontrada!.nomeMedium,
                        ),
                        _buildInfoRow(
                          'Nome do Cambono',
                          consultaEncontrada!.nomeCambono,
                        ),
                        _buildInfoRow(
                          'Nome da Entidade',
                          consultaEncontrada!.nomeEntidade,
                        ),

                        const SizedBox(height: 24),
                        _buildInfoSection('DESCRIÇÃO DA CONSULTA'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            consultaEncontrada!.descricaoConsulta,
                            style: const TextStyle(fontSize: 15, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            if (buscaRealizada && consultaEncontrada == null) ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma consulta encontrada',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
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
    );
  }

  @override
  void dispose() {
    numeroController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Future<void> _buscar(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      Get.snackbar('Erro', 'Usuário não autenticado');
      return;
    }

    final consulta = await consultaController.buscarPorNumero(
      numeroController.text,
    );

    setState(() {
      buscaRealizada = true;
      consultaEncontrada = consulta;
    });

    if (consulta == null) {
      Get.snackbar(
        'Não encontrado',
        'Nenhuma consulta com este número',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Verifica permissão (nível 1 só vê as próprias)
    final nivelUsuario = authState.usuario.nivelAcesso.index + 1;
    // Para nível 1, usar o ID do usuário como cadastro
    final cadastroUsuario = authState.usuario.id;

    if (!consultaController.podeVerConsulta(
      consulta,
      cadastroUsuario,
      nivelUsuario,
    )) {
      setState(() => consultaEncontrada = null);

      Get.snackbar(
        'Sem Permissão',
        'Você NÃO TEM PERMISSÃO para visualizar esta consulta',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _limpar() {
    setState(() {
      numeroController.clear();
      consultaEncontrada = null;
      buscaRealizada = false;
    });
  }
}
