import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/supabase_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/dia_sessao_datasource.dart';
import '../../data/datasources/nucleo_datasource.dart';
import '../../domain/entities/dia_sessao.dart';
import '../controllers/dia_sessao_controller.dart';
import '../controllers/nucleo_controller.dart';

/// Página para gerenciar dias de sessão
class GerenciarDiasSessaoPage extends StatefulWidget {
  const GerenciarDiasSessaoPage({super.key});

  @override
  State<GerenciarDiasSessaoPage> createState() =>
      _GerenciarDiasSessaoPageState();
}

class _GerenciarDiasSessaoPageState extends State<GerenciarDiasSessaoPage> {
  late final DiaSessaoController _controller;
  late final NucleoController _nucleoController;

  @override
  void initState() {
    super.initState();
    _controller = DiaSessaoController(
      DiaSessaoSupabaseDatasource(di.sl<SupabaseService>()),
    );
    _nucleoController = NucleoController(
      NucleoSupabaseDatasource(di.sl<SupabaseService>()),
    );
    _controller.carregarDiasSessao();
    _nucleoController.carregarNucleos(apenasAtivos: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final nivelPermissao = state is AuthAuthenticated
            ? state.usuario.nivelAcesso.index + 1
            : 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gerenciar Dias de Sessão'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarDialogDiaSessao(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Dia'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.diasSessao.isEmpty) {
              return const Center(
                child: Text('Nenhum dia de sessão cadastrado'),
              );
            }

            // Agrupar por núcleo
            final diasPorNucleo = <String, List<DiaSessao>>{};
            for (final dia in _controller.diasSessao) {
              diasPorNucleo.putIfAbsent(dia.nucleo, () => []).add(dia);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: diasPorNucleo.length,
              itemBuilder: (context, index) {
                final nucleo = diasPorNucleo.keys.elementAt(index);
                final dias = diasPorNucleo[nucleo]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      nucleo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${dias.length} ${dias.length == 1 ? "dia" : "dias"} de sessão',
                    ),
                    children: dias.map((dia) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: dia.ativo
                              ? Colors.green
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          child: const Icon(Icons.calendar_today, size: 20),
                        ),
                        title: Text(
                          dia.dia,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: dia.ativo
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Código: ${dia.cod}'),
                            if (dia.responsavel != null)
                              Text('Responsável: ${dia.responsavel}'),
                            Text(
                              dia.ativo ? 'Ativo' : 'Inativo',
                              style: TextStyle(
                                color: dia.ativo ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _mostrarDialogDiaSessao(
                                context,
                                diaSessao: dia,
                              ),
                            ),
                            if (nivelPermissao >= 4 && dia.ativo)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () =>
                                    _confirmarDesativar(context, dia),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  void _mostrarDialogDiaSessao(BuildContext context, {DiaSessao? diaSessao}) {
    final codController = TextEditingController(text: diaSessao?.cod);
    final diaController = TextEditingController(text: diaSessao?.dia);
    final responsavelController = TextEditingController(
      text: diaSessao?.responsavel,
    );
    String? nucleoSelecionado = diaSessao?.nucleo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          diaSessao == null
              ? 'Adicionar Dia de Sessão'
              : 'Editar Dia de Sessão',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codController,
                decoration: const InputDecoration(
                  labelText: 'Código *',
                  hintText: 'CCU-TER',
                ),
                textCapitalization: TextCapitalization.characters,
                enabled: diaSessao == null,
              ),
              const SizedBox(height: 16),
              Obx(() {
                final nucleos = _nucleoController.nucleos
                    .where((n) => n.ativo)
                    .toList();
                return DropdownButtonFormField<String>(
                  initialValue: nucleoSelecionado,
                  decoration: const InputDecoration(labelText: 'Núcleo *'),
                  items: nucleos.map((nucleo) {
                    return DropdownMenuItem(
                      value: nucleo.sigla,
                      child: Text('${nucleo.sigla} - ${nucleo.nome}'),
                    );
                  }).toList(),
                  onChanged: (value) => nucleoSelecionado = value,
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: diaController,
                decoration: const InputDecoration(
                  labelText: 'Dia *',
                  hintText: 'TERÇA-FEIRA',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: responsavelController,
                decoration: const InputDecoration(
                  labelText: 'Responsável',
                  hintText: 'NOME DO RESPONSÁVEL',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codController.text.trim().isEmpty ||
                  nucleoSelecionado == null ||
                  diaController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erro',
                  'Preencha todos os campos obrigatórios',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final novoDiaSessao = DiaSessao(
                id: diaSessao?.id ?? const Uuid().v4(),
                cod: codController.text.trim().toUpperCase(),
                nucleo: nucleoSelecionado!,
                dia: diaController.text.trim().toUpperCase(),
                responsavel: responsavelController.text.trim().isNotEmpty
                    ? responsavelController.text.trim().toUpperCase()
                    : null,
                ativo: diaSessao?.ativo ?? true,
              );

              bool sucesso;
              if (diaSessao == null) {
                sucesso = await _controller.adicionar(novoDiaSessao);
              } else {
                sucesso = await _controller.atualizar(novoDiaSessao);
              }

              if (sucesso && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(diaSessao == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmarDesativar(BuildContext context, DiaSessao diaSessao) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final nivelPermissao = state is AuthAuthenticated
              ? state.usuario.nivelAcesso.index + 1
              : 0;

          return AlertDialog(
            title: const Text('Confirmar Desativação'),
            content: Text(
              'Tem certeza que deseja desativar "${diaSessao.dia}" do núcleo ${diaSessao.nucleo}?\n\n'
              'O registro não será excluído, apenas marcado como inativo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final sucesso = await _controller.desativar(
                    diaSessao.id!,
                    nivelPermissao: nivelPermissao,
                  );
                  if (sucesso && dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Desativar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
