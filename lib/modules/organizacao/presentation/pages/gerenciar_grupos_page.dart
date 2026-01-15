import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/supabase_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/grupo_datasource.dart';
import '../../domain/entities/grupo.dart';
import '../controllers/grupo_controller.dart';

/// Página para gerenciar grupos (grupo_tarefa, acao_social ou trabalho_espiritual)
class GerenciarGruposPage extends StatefulWidget {
  final String tipo;

  const GerenciarGruposPage({super.key, required this.tipo});

  @override
  State<GerenciarGruposPage> createState() => _GerenciarGruposPageState();
}

class _GerenciarGruposPageState extends State<GerenciarGruposPage> {
  late final GrupoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GrupoController(
      GrupoSupabaseDatasource(di.sl<SupabaseService>()),
    );
    _controller.carregarGrupos(tipo: widget.tipo);
  }

  String get _titulo {
    switch (widget.tipo) {
      case 'grupo_tarefa':
        return 'Grupos-Tarefa';
      case 'acao_social':
        return 'Grupos de Ação Social';
      case 'trabalho_espiritual':
        return 'Grupos de Trabalho Espiritual';
      default:
        return 'Grupos';
    }
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
            title: Text(_titulo),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarDialogGrupo(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Grupo'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final gruposFiltrados = _controller.grupos
                .where((g) => g.tipo == widget.tipo)
                .toList();

            if (gruposFiltrados.isEmpty) {
              return const Center(child: Text('Nenhum grupo cadastrado'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: gruposFiltrados.length,
              itemBuilder: (context, index) {
                final grupo = gruposFiltrados[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: grupo.ativo
                          ? Colors.deepPurple
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.groups),
                    ),
                    title: Text(
                      grupo.nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: grupo.ativo
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (grupo.descricao != null &&
                            grupo.descricao!.isNotEmpty)
                          Text(grupo.descricao!),
                        if (grupo.lider != null && grupo.lider!.isNotEmpty)
                          Text('Líder: ${grupo.lider}'),
                        Text(
                          grupo.ativo ? 'Ativo' : 'Inativo',
                          style: TextStyle(
                            color: grupo.ativo ? Colors.green : Colors.red,
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
                              _mostrarDialogGrupo(context, grupo: grupo),
                        ),
                        if (nivelPermissao >= 4 && grupo.ativo)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () =>
                                _confirmarDesativar(context, grupo),
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

  void _mostrarDialogGrupo(BuildContext context, {Grupo? grupo}) {
    final nomeController = TextEditingController(text: grupo?.nome);
    final descricaoController = TextEditingController(text: grupo?.descricao);
    final liderController = TextEditingController(text: grupo?.lider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(grupo == null ? 'Adicionar Grupo' : 'Editar Grupo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'NOME DO GRUPO',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descrição breve do grupo',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: liderController,
                decoration: const InputDecoration(
                  labelText: 'Líder',
                  hintText: 'NOME DO LÍDER',
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
              if (nomeController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erro',
                  'O nome do grupo é obrigatório',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final novoGrupo = Grupo(
                id: grupo?.id ?? const Uuid().v4(),
                nome: nomeController.text.trim().toUpperCase(),
                tipo: widget.tipo,
                descricao: descricaoController.text.trim().isNotEmpty
                    ? descricaoController.text.trim()
                    : null,
                lider: liderController.text.trim().isNotEmpty
                    ? liderController.text.trim().toUpperCase()
                    : null,
                ativo: grupo?.ativo ?? true,
              );

              bool sucesso;
              if (grupo == null) {
                sucesso = await _controller.adicionar(novoGrupo);
              } else {
                sucesso = await _controller.atualizar(novoGrupo);
              }

              if (sucesso && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(grupo == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmarDesativar(BuildContext context, Grupo grupo) {
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
              'Tem certeza que deseja desativar o grupo "${grupo.nome}"?\n\n'
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
                    grupo.id!,
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
