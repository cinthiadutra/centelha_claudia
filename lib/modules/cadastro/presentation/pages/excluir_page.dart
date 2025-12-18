import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/usuario.dart';
import '../controllers/cadastro_controller.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/domain/entities/usuario_sistema.dart';

/// Página para excluir cadastros (apenas Nível 4)
class ExcluirPage extends StatefulWidget {
  const ExcluirPage({super.key});

  @override
  State<ExcluirPage> createState() => _ExcluirPageState();
}

class _ExcluirPageState extends State<ExcluirPage> {
  final controller = Get.find<CadastroController>();
  final authBloc = Get.find<AuthBloc>();

  final numeroController = TextEditingController();
  Usuario? usuarioParaExcluir;

  @override
  void initState() {
    super.initState();
    _verificarPermissao();
  }

  @override
  void dispose() {
    numeroController.dispose();
    super.dispose();
  }

  void _verificarPermissao() {
    final state = authBloc.state;
    if (state is! AuthAuthenticated) {
      Get.back();
      Get.snackbar(
        'Acesso Negado',
        'Você precisa estar autenticado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (state.usuario.nivelAcesso != NivelAcesso.nivel4) {
      Get.back();
      Get.snackbar(
        'Acesso Negado',
        'Apenas Administradores podem excluir cadastros',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _buscarPorNumero() {
    if (numeroController.text.isEmpty) {
      Get.snackbar('Atenção', 'Digite o número de cadastro');
      return;
    }

    final numero = numeroController.text.trim();
    final usuario = controller.usuarios.firstWhereOrNull(
      (u) => u.numeroCadastro == numero,
    );

    if (usuario == null) {
      Get.snackbar(
        'Não encontrado',
        'Nenhum cadastro encontrado com o número $numero',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      setState(() => usuarioParaExcluir = null);
      return;
    }

    setState(() => usuarioParaExcluir = usuario);
  }

  Future<void> _excluir() async {
    if (usuarioParaExcluir == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tem certeza que deseja excluir este cadastro?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Número: ${usuarioParaExcluir!.numeroCadastro}'),
            Text('Nome: ${usuarioParaExcluir!.nome}'),
            Text('CPF: ${_formatarCPF(usuarioParaExcluir!.cpf)}'),
            const SizedBox(height: 16),
            const Text(
              'Esta ação não pode ser desfeita!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final sucesso = await controller.excluir(usuarioParaExcluir!.id!);

    if (sucesso) {
      setState(() {
        usuarioParaExcluir = null;
      });
      numeroController.clear();
    }
  }

  String _formatarCPF(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String _formatarTelefone(String telefone) {
    if (telefone.length == 11) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7)}';
    }
    return telefone;
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir Cadastro'),
        backgroundColor: Colors.red,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Alerta de permissão
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Atenção: Esta ação é irreversível. Apenas administradores podem excluir cadastros.',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Busca
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buscar Cadastro',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: numeroController,
                              decoration: const InputDecoration(
                                labelText: 'Número de Cadastro',
                                prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(),
                                hintText: '00001',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              onSubmitted: (_) => _buscarPorNumero(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _buscarPorNumero,
                            icon: const Icon(Icons.search),
                            label: const Text('Buscar'),
                            style: ElevatedButton.styleFrom(
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

              // Resultado da busca
              if (usuarioParaExcluir != null)
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Cadastro Encontrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Nº ${usuarioParaExcluir!.numeroCadastro}',
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('Nome', usuarioParaExcluir!.nome),
                                  _buildInfoRow('CPF', _formatarCPF(usuarioParaExcluir!.cpf)),
                                  if (usuarioParaExcluir!.dataNascimento != null)
                                    _buildInfoRow('Data Nasc.', _formatarData(usuarioParaExcluir!.dataNascimento!)),
                                  _buildInfoRow('Telefone', _formatarTelefone(usuarioParaExcluir!.telefoneCelular ?? '')),
                                  _buildInfoRow('E-mail', usuarioParaExcluir!.email ?? ''),
                                  const SizedBox(height: 16),
                                  _buildInfoRow('Endereço', usuarioParaExcluir!.endereco ?? ''),
                                  _buildInfoRow('Bairro', usuarioParaExcluir!.bairro ?? ''),
                                  _buildInfoRow('Cidade', '${usuarioParaExcluir!.cidade ?? ''}/${usuarioParaExcluir!.estado ?? ''}'),
                                  const SizedBox(height: 16),
                                  _buildInfoRow('Núcleo', usuarioParaExcluir!.nucleoPertence ?? ''),
                                  if (usuarioParaExcluir!.dataCadastro != null)
                                    _buildInfoRow('Data Cadastro', _formatarData(usuarioParaExcluir!.dataCadastro!)),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _excluir,
                              icon: const Icon(Icons.delete_forever, color: Colors.white),
                              label: const Text(
                                'Excluir Este Cadastro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
