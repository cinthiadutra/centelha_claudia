import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/grupo_tarefa_constants.dart';
import '../../../membros/domain/entities/membro.dart';
import '../../../membros/presentation/controllers/membro_controller.dart';
import '../../domain/entities/grupo_tarefa_membro.dart';
import '../controllers/grupo_tarefa_controller.dart';

/// Página para gerenciar membros de grupo-tarefa
/// Disponível para níveis 2 e 4
class GerenciarGrupoTarefaPage extends StatefulWidget {
  const GerenciarGrupoTarefaPage({super.key});

  @override
  State<GerenciarGrupoTarefaPage> createState() =>
      _GerenciarGrupoTarefaPageState();
}

class _GerenciarGrupoTarefaPageState extends State<GerenciarGrupoTarefaPage> {
  final grupoTarefaController = Get.find<GrupoTarefaController>();
  final membroController = Get.find<MembroController>();

  final _formKey = GlobalKey<FormState>();
  final numeroCadastroController = TextEditingController();

  Membro? membroEncontrado;
  GrupoTarefaMembro? grupoTarefaAtual;
  bool buscaRealizada = false;

  String? grupoTarefaSelecionado;
  String? funcaoSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Membros de Grupo-Tarefa'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                        'Buscar Membro',
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
                              controller: numeroCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Número de Cadastro do Membro',
                                prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(),
                              ),
                              onFieldSubmitted: (_) => _buscar(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _buscar,
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

              if (buscaRealizada && membroEncontrado != null) ...[
                Card(
                  color: membroEncontrado!.status == 'Membro ativo'
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              membroEncontrado!.status == 'Membro ativo'
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: membroEncontrado!.status == 'Membro ativo'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Membro Encontrado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    membroEncontrado!.status == 'Membro ativo'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Número',
                          membroEncontrado!.numeroCadastro,
                        ),
                        _buildInfoRow('Nome', membroEncontrado!.nome),
                        _buildInfoRow('Status', membroEncontrado!.status),
                        if (grupoTarefaAtual != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            'Grupo-Tarefa Atual',
                            grupoTarefaAtual!.grupoTarefa,
                          ),
                          _buildInfoRow(
                            'Função Atual',
                            grupoTarefaAtual!.funcao,
                          ),
                          _buildInfoRow(
                            'Última Alteração',
                            _formatarData(
                              grupoTarefaAtual!.dataUltimaAlteracao,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (membroEncontrado!.status == 'Membro ativo') ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grupoTarefaAtual != null
                                ? 'Alterar Grupo-Tarefa'
                                : 'Incluir em Grupo-Tarefa',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: grupoTarefaSelecionado,
                            decoration: const InputDecoration(
                              labelText: 'Grupo-Tarefa *',
                              border: OutlineInputBorder(),
                            ),
                            items: GrupoTarefaConstants.gruposOpcoes.map((
                              grupo,
                            ) {
                              return DropdownMenuItem(
                                value: grupo,
                                child: Text(grupo),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => grupoTarefaSelecionado = v),
                            validator: (v) =>
                                v == null ? 'Campo obrigatório' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: funcaoSelecionada,
                            decoration: const InputDecoration(
                              labelText: 'Função no Grupo *',
                              border: OutlineInputBorder(),
                            ),
                            items: GrupoTarefaConstants.funcoesOpcoes.map((
                              funcao,
                            ) {
                              return DropdownMenuItem(
                                value: funcao,
                                child: Text(funcao),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => funcaoSelecionada = v),
                            validator: (v) =>
                                v == null ? 'Campo obrigatório' : null,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (grupoTarefaAtual != null)
                                TextButton.icon(
                                  onPressed: _excluir,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Excluir do Grupo',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _salvar,
                                icon: const Icon(Icons.save),
                                label: Text(
                                  grupoTarefaAtual != null
                                      ? 'Atualizar'
                                      : 'Salvar',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    numeroCadastroController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _buscar() {
    final membro = membroController.buscarPorNumero(
      numeroCadastroController.text,
    );
    final grupoTarefa = grupoTarefaController.buscarPorCadastro(
      numeroCadastroController.text,
    );

    setState(() {
      buscaRealizada = true;
      membroEncontrado = membro;
      grupoTarefaAtual = grupoTarefa;

      if (membro != null) {
        // Se já tem grupo-tarefa, preencher
        if (grupoTarefa != null) {
          grupoTarefaSelecionado = grupoTarefa.grupoTarefa;
          funcaoSelecionada = grupoTarefa.funcao;
        } else {
          grupoTarefaSelecionado = null;
          funcaoSelecionada = null;
        }
      }
    });

    if (membro == null) {
      Get.snackbar(
        'Não encontrado',
        'Nenhum membro com este número de cadastro',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _excluir() async {
    if (grupoTarefaAtual == null) {
      Get.snackbar('Erro', 'Este membro não está em nenhum grupo-tarefa');
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja remover ${membroEncontrado!.nome} do grupo-tarefa "${grupoTarefaAtual!.grupoTarefa}"?',
        ),
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

    if (confirmar == true) {
      try {
        await grupoTarefaController.remover(membroEncontrado!.numeroCadastro);
        _limpar();
      } catch (e) {
        // Erro já tratado no controller
      }
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '-';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _limpar() {
    setState(() {
      numeroCadastroController.clear();
      membroEncontrado = null;
      grupoTarefaAtual = null;
      buscaRealizada = false;
      grupoTarefaSelecionado = null;
      funcaoSelecionada = null;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios');
      return;
    }

    if (membroEncontrado == null) {
      Get.snackbar('Erro', 'Nenhum membro selecionado');
      return;
    }

    // Validar se é membro ativo
    if (membroEncontrado!.status != 'Membro ativo') {
      Get.snackbar(
        'Erro',
        'Somente membros ativos podem ser incluídos em grupo-tarefa.\nStatus atual: ${membroEncontrado!.status}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final grupoTarefaMembro = GrupoTarefaMembro(
      id:
          grupoTarefaAtual?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      numeroCadastro: membroEncontrado!.numeroCadastro,
      nome: membroEncontrado!.nome,
      status: membroEncontrado!.status,
      grupoTarefa: grupoTarefaSelecionado!,
      funcao: funcaoSelecionada!,
      dataUltimaAlteracao: DateTime.now(),
    );

    try {
      await grupoTarefaController.salvar(grupoTarefaMembro);
      _limpar();
    } catch (e) {
      // Erro já tratado no controller
    }
  }
}
