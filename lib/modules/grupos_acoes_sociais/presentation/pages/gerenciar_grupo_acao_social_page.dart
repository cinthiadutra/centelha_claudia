import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/grupo_acao_social_constants.dart';
import '../../../membros/presentation/controllers/membro_controller.dart';
import '../../domain/entities/grupo_acao_social_membro.dart';
import '../controllers/grupo_acao_social_controller.dart';

/// Página para gerenciar membros em grupos de ações sociais
/// Disponível para níveis 2 e 4
class GerenciarGrupoAcaoSocialPage extends StatefulWidget {
  const GerenciarGrupoAcaoSocialPage({super.key});

  @override
  State<GerenciarGrupoAcaoSocialPage> createState() =>
      _GerenciarGrupoAcaoSocialPageState();
}

class _GerenciarGrupoAcaoSocialPageState
    extends State<GerenciarGrupoAcaoSocialPage> {
  final grupoAcaoSocialController = Get.find<GrupoAcaoSocialController>();
  final membroController = Get.find<MembroController>();

  final _numeroCadastroController = TextEditingController();
  final _nomeController = TextEditingController();
  final _statusController = TextEditingController();

  String? grupoAcaoSocialSelecionado;
  String? funcaoSelecionada;

  GrupoAcaoSocialMembro? grupoAcaoSocialAtual;

  @override
  Widget build(BuildContext context) {
    final statusAtivo = _statusController.text == 'Membro ativo';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Grupo de Ação Social'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buscar Membro
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BUSCAR MEMBRO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _numeroCadastroController,
                            decoration: const InputDecoration(
                              labelText: 'Número do Cadastro',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _buscarMembro,
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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

            // Dados do Membro
            if (_nomeController.text.isNotEmpty) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DADOS DO MEMBRO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: statusAtivo
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: statusAtivo ? Colors.green : Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              statusAtivo ? Icons.check_circle : Icons.warning,
                              color: statusAtivo ? Colors.green : Colors.orange,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Status do Membro',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _statusController.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: statusAtivo
                                          ? Colors.green.shade900
                                          : Colors.orange.shade900,
                                    ),
                                  ),
                                  if (!statusAtivo) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Apenas membros ativos podem ser incluídos em grupos de ações sociais',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (grupoAcaoSocialAtual != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Última alteração: ${_formatarData(grupoAcaoSocialAtual!.dataUltimaAlteracao)}',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Formulário (só aparece se status for ativo)
              if (statusAtivo)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DADOS DO GRUPO DE AÇÃO SOCIAL',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: grupoAcaoSocialSelecionado,
                          decoration: const InputDecoration(
                            labelText: 'Grupo de Ação Social *',
                            border: OutlineInputBorder(),
                          ),
                          items: GrupoAcaoSocialConstants.gruposOpcoes.map((
                            grupo,
                          ) {
                            return DropdownMenuItem<String>(
                              value: grupo,
                              child: Text(grupo),
                            );
                          }).toList(),
                          onChanged: (v) =>
                              setState(() => grupoAcaoSocialSelecionado = v),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: funcaoSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Função no Grupo *',
                            border: OutlineInputBorder(),
                          ),
                          items: GrupoAcaoSocialConstants.funcoesOpcoes.map((
                            funcao,
                          ) {
                            return DropdownMenuItem<String>(
                              value: funcao,
                              child: Text(funcao),
                            );
                          }).toList(),
                          onChanged: (v) =>
                              setState(() => funcaoSelecionada = v),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (grupoAcaoSocialAtual != null)
                              OutlinedButton.icon(
                                onPressed: _excluir,
                                icon: const Icon(Icons.delete),
                                label: const Text('Excluir'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _salvar,
                              icon: const Icon(Icons.save),
                              label: const Text('Salvar'),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numeroCadastroController.dispose();
    _nomeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _buscarMembro() async {
    final numero = _numeroCadastroController.text.trim();
    if (numero.isEmpty) {
      Get.snackbar(
        'Atenção',
        'Digite o número do cadastro',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Buscar dados do membro
    final membro = membroController.buscarPorNumero(numero);
    if (membro == null) {
      Get.snackbar(
        'Não encontrado',
        'Membro com cadastro $numero não encontrado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _limparFormulario();
      return;
    }

    // Buscar se já está em algum grupo de ação social
    grupoAcaoSocialAtual = await grupoAcaoSocialController.buscarPorCadastro(
      numero,
    );

    setState(() {
      _nomeController.text = membro.nome;
      _statusController.text = membro.status;

      if (grupoAcaoSocialAtual != null) {
        grupoAcaoSocialSelecionado = grupoAcaoSocialAtual!.grupoAcaoSocial;
        funcaoSelecionada = grupoAcaoSocialAtual!.funcao;
      } else {
        grupoAcaoSocialSelecionado = null;
        funcaoSelecionada = null;
      }
    });
  }

  void _excluir() async {
    if (grupoAcaoSocialAtual == null) {
      Get.snackbar(
        'Atenção',
        'Este membro não está em nenhum grupo de ação social',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final confirma = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja realmente remover ${grupoAcaoSocialAtual!.nome} do grupo de ação social?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirma == true) {
      await grupoAcaoSocialController.remover(
        grupoAcaoSocialAtual!.numeroCadastro,
      );
      _limparFormulario();
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _limparFormulario() {
    setState(() {
      _numeroCadastroController.clear();
      _nomeController.clear();
      _statusController.clear();
      grupoAcaoSocialSelecionado = null;
      funcaoSelecionada = null;
      grupoAcaoSocialAtual = null;
    });
  }

  void _salvar() async {
    final numero = _numeroCadastroController.text.trim();
    final nome = _nomeController.text.trim();
    final status = _statusController.text.trim();

    if (numero.isEmpty || nome.isEmpty) {
      Get.snackbar(
        'Atenção',
        'Busque um membro primeiro',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Validação: status deve ser "Membro ativo"
    if (status != 'Membro ativo') {
      Get.snackbar(
        'Erro de Validação',
        'Somente membros com status "Membro ativo" podem ser incluídos em grupos de ações sociais.\nStatus atual: $status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (grupoAcaoSocialSelecionado == null || funcaoSelecionada == null) {
      Get.snackbar(
        'Atenção',
        'Preencha o grupo de ação social e a função',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final membro = GrupoAcaoSocialMembro(
      numeroCadastro: numero,
      nome: nome,
      status: status,
      grupoAcaoSocial: grupoAcaoSocialSelecionado!,
      funcao: funcaoSelecionada!,
      dataUltimaAlteracao: DateTime.now(),
    );

    await grupoAcaoSocialController.salvar(membro);
    _limparFormulario();
  }
}
