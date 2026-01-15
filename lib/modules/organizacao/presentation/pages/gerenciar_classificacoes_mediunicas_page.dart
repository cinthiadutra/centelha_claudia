import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/supabase_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/classificacao_mediunica_datasource.dart';
import '../../domain/entities/classificacao_mediunica.dart';
import '../controllers/classificacao_mediunica_controller.dart';

/// Página para gerenciar classificações mediúnicas
class GerenciarClassificacoesMediunicasPage extends StatefulWidget {
  const GerenciarClassificacoesMediunicasPage({super.key});

  @override
  State<GerenciarClassificacoesMediunicasPage> createState() =>
      _GerenciarClassificacoesMediunicasPageState();
}

class _GerenciarClassificacoesMediunicasPageState
    extends State<GerenciarClassificacoesMediunicasPage> {
  late final ClassificacaoMediunicaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ClassificacaoMediunicaController(
      ClassificacaoMediunicaSupabaseDatasource(di.sl<SupabaseService>()),
    );
    _controller.carregarClassificacoes();
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
            title: const Text('Classificações Mediúnicas'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarDialogClassificacao(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.classificacoes.isEmpty) {
              return const Center(
                child: Text('Nenhuma classificação cadastrada'),
              );
            }

            // Agrupar por tipo
            final classificacoesPorTipo =
                <String, List<ClassificacaoMediunica>>{};
            for (final classificacao in _controller.classificacoes) {
              final tipo = classificacao.tipo ?? 'Outros';
              classificacoesPorTipo
                  .putIfAbsent(tipo, () => [])
                  .add(classificacao);
            }

            // Ordenar cada lista por ordem
            classificacoesPorTipo.forEach((key, value) {
              value.sort((a, b) => a.ordem.compareTo(b.ordem));
            });

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: classificacoesPorTipo.length,
              itemBuilder: (context, index) {
                final tipo = classificacoesPorTipo.keys.elementAt(index);
                final classificacoes = classificacoesPorTipo[tipo]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: Icon(
                      _getIconForTipo(tipo),
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      _getTipoExtenso(tipo),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${classificacoes.length} ${classificacoes.length == 1 ? "classificação" : "classificações"}',
                    ),
                    children: classificacoes.map((classificacao) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: classificacao.ativo
                              ? Colors.green
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          child: Text(classificacao.ordem.toString()),
                        ),
                        title: Text(
                          classificacao.nome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: classificacao.ativo
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Código: ${classificacao.cod}'),
                            Text('Ordem: ${classificacao.ordem}'),
                            Text(
                              classificacao.ativo ? 'Ativo' : 'Inativo',
                              style: TextStyle(
                                color: classificacao.ativo
                                    ? Colors.green
                                    : Colors.red,
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
                              onPressed: () => _mostrarDialogClassificacao(
                                context,
                                classificacao: classificacao,
                              ),
                            ),
                            if (nivelPermissao >= 4 && classificacao.ativo)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () =>
                                    _confirmarDesativar(context, classificacao),
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

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'GRAU':
        return Icons.auto_awesome;
      case 'FUNCAO_LIDERANCA':
        return Icons.star;
      case 'FUNCAO_APOIO':
        return Icons.support;
      default:
        return Icons.category;
    }
  }

  String _getTipoExtenso(String tipo) {
    switch (tipo) {
      case 'GRAU':
        return 'Graus Mediúnicos';
      case 'FUNCAO_LIDERANCA':
        return 'Funções de Liderança';
      case 'FUNCAO_APOIO':
        return 'Funções de Apoio';
      default:
        return tipo;
    }
  }

  void _mostrarDialogClassificacao(
    BuildContext context, {
    ClassificacaoMediunica? classificacao,
  }) {
    final codController = TextEditingController(text: classificacao?.cod);
    final nomeController = TextEditingController(text: classificacao?.nome);
    final ordemController = TextEditingController(
      text: classificacao?.ordem.toString() ?? '',
    );
    String? tipoSelecionado = classificacao?.tipo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          classificacao == null
              ? 'Adicionar Classificação'
              : 'Editar Classificação',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codController,
                decoration: const InputDecoration(
                  labelText: 'Código *',
                  hintText: 'GRAU_VERM',
                ),
                textCapitalization: TextCapitalization.characters,
                enabled: classificacao == null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'GRAU VERMELHO',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ordemController,
                decoration: const InputDecoration(
                  labelText: 'Ordem *',
                  hintText: '1',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: tipoSelecionado,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(
                    value: 'GRAU',
                    child: Text('Grau Mediúnico'),
                  ),
                  DropdownMenuItem(
                    value: 'FUNCAO_LIDERANCA',
                    child: Text('Função de Liderança'),
                  ),
                  DropdownMenuItem(
                    value: 'FUNCAO_APOIO',
                    child: Text('Função de Apoio'),
                  ),
                ],
                onChanged: (value) => tipoSelecionado = value,
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
                  nomeController.text.trim().isEmpty ||
                  ordemController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erro',
                  'Preencha todos os campos obrigatórios',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final novaClassificacao = ClassificacaoMediunica(
                id: classificacao?.id ?? const Uuid().v4(),
                cod: codController.text.trim().toUpperCase(),
                nome: nomeController.text.trim().toUpperCase(),
                ordem: int.parse(ordemController.text.trim()),
                tipo: tipoSelecionado,
                ativo: classificacao?.ativo ?? true,
              );

              bool sucesso;
              if (classificacao == null) {
                sucesso = await _controller.adicionar(novaClassificacao);
              } else {
                sucesso = await _controller.atualizar(novaClassificacao);
              }

              if (sucesso && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(classificacao == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmarDesativar(
    BuildContext context,
    ClassificacaoMediunica classificacao,
  ) {
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
              'Tem certeza que deseja desativar "${classificacao.nome}"?\n\n'
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
                    classificacao.id!,
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
