import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/supabase_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/nucleo_datasource.dart';
import '../../domain/entities/nucleo.dart';
import '../controllers/nucleo_controller.dart';

/// Página para gerenciar núcleos
class GerenciarNucleosPage extends StatefulWidget {
  const GerenciarNucleosPage({super.key});

  @override
  State<GerenciarNucleosPage> createState() => _GerenciarNucleosPageState();
}

class _GerenciarNucleosPageState extends State<GerenciarNucleosPage> {
  late final NucleoController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final nivelPermissao = state is AuthAuthenticated
            ? state.usuario.nivelAcesso.index + 1
            : 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gerenciar Núcleos'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarDialogNucleo(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Núcleo'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.nucleos.isEmpty) {
              return const Center(child: Text('Nenhum núcleo cadastrado'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.nucleos.length,
              itemBuilder: (context, index) {
                final nucleo = _controller.nucleos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: nucleo.ativo
                          ? Colors.green
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      child: Text(nucleo.sigla[0]),
                    ),
                    title: Text(
                      '${nucleo.sigla} - ${nucleo.nome}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: nucleo.ativo
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${nucleo.cod}'),
                        if (nucleo.coordenador != null)
                          Text('Coordenador: ${nucleo.coordenador}'),
                        Text(
                          nucleo.ativo ? 'Ativo' : 'Inativo',
                          style: TextStyle(
                            color: nucleo.ativo ? Colors.green : Colors.red,
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
                          onPressed: () =>
                              _mostrarDialogNucleo(context, nucleo: nucleo),
                        ),
                        if (nivelPermissao >= 4 && nucleo.ativo)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () =>
                                _confirmarDesativar(context, nucleo),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = NucleoController(
      NucleoSupabaseDatasource(di.sl<SupabaseService>()),
    );
    _controller.carregarNucleos();
  }

  void _confirmarDesativar(BuildContext context, Nucleo nucleo) {
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
              'Tem certeza que deseja desativar o núcleo "${nucleo.nome}"?\n\n'
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
                    nucleo.cod,
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

  void _mostrarDialogNucleo(BuildContext context, {Nucleo? nucleo}) {
    final codController = TextEditingController(text: nucleo?.cod);
    final siglaController = TextEditingController(text: nucleo?.sigla);
    final nomeController = TextEditingController(text: nucleo?.nome);
    final coordenadorController = TextEditingController(
      text: nucleo?.coordenador,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nucleo == null ? 'Adicionar Núcleo' : 'Editar Núcleo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codController,
                decoration: const InputDecoration(
                  labelText: 'Código *',
                  hintText: '001',
                ),
                enabled: nucleo == null, // Código não pode ser editado
              ),
              const SizedBox(height: 16),
              TextField(
                controller: siglaController,
                decoration: const InputDecoration(
                  labelText: 'Sigla *',
                  hintText: 'CCU',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'CASA DO CABOCLO UBIRAJARA',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: coordenadorController,
                decoration: const InputDecoration(
                  labelText: 'Coordenador',
                  hintText: 'NOME DO COORDENADOR',
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
                  siglaController.text.trim().isEmpty ||
                  nomeController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erro',
                  'Preencha todos os campos obrigatórios',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final novoNucleo = Nucleo(
                cod: codController.text.trim().toUpperCase(),
                sigla: siglaController.text.trim().toUpperCase(),
                nome: nomeController.text.trim().toUpperCase(),
                coordenador: coordenadorController.text.trim().isNotEmpty
                    ? coordenadorController.text.trim().toUpperCase()
                    : null,
                ativo: nucleo?.ativo ?? true,
              );

              bool sucesso;
              if (nucleo == null) {
                sucesso = await _controller.adicionar(novoNucleo);
              } else {
                sucesso = await _controller.atualizar(novoNucleo);
              }

              if (sucesso && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(nucleo == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }
}
