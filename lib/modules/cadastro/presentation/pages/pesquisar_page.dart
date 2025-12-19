import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/usuario.dart';
import '../controllers/cadastro_controller.dart';

/// Página para pesquisar cadastros
class PesquisarPage extends StatefulWidget {
  const PesquisarPage({super.key});

  @override
  State<PesquisarPage> createState() => _PesquisarPageState();
}

class _PesquisarPageState extends State<PesquisarPage> {
  final controller = Get.find<CadastroController>();

  final numeroController = TextEditingController();
  final cpfController = TextEditingController();
  final nomeController = TextEditingController();

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String tipoPesquisa = 'numero'; // numero, cpf, nome

  @override
  void initState() {
    super.initState();
    controller.limparPesquisa();
  }

  @override
  void dispose() {
    numeroController.dispose();
    cpfController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  void _pesquisar() {
    switch (tipoPesquisa) {
      case 'numero':
        if (numeroController.text.isEmpty) {
          Get.snackbar('Atenção', 'Digite o número de cadastro');
          return;
        }
        controller.pesquisar(numero: numeroController.text.trim());
        break;
      case 'cpf':
        if (cpfController.text.isEmpty) {
          Get.snackbar('Atenção', 'Digite o CPF');
          return;
        }
        controller.pesquisar(cpf: cpfController.text);
        break;
      case 'nome':
        if (nomeController.text.isEmpty) {
          Get.snackbar('Atenção', 'Digite o nome');
          return;
        }
        controller.pesquisar(nome: nomeController.text.trim());
        break;
    }
  }

  void _limpar() {
    numeroController.clear();
    cpfController.clear();
    nomeController.clear();
    controller.limparPesquisa();
  }

  void _verDetalhes(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usuario.nome),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Número', usuario.numeroCadastro ?? '-'),
              _buildInfoRow('CPF', _formatarCPF(usuario.cpf)),
              if (usuario.dataNascimento != null)
                _buildInfoRow('Data Nasc.', _formatarData(usuario.dataNascimento!)),
              _buildInfoRow('Telefone', _formatarTelefone(usuario.telefoneCelular ?? '')),
              _buildInfoRow('E-mail', usuario.email ?? ''),
              if (usuario.endereco != null && usuario.endereco!.isNotEmpty) ...[
                const Divider(),
                _buildInfoRow('Endereço', usuario.endereco ?? ''),
                _buildInfoRow('Bairro', usuario.bairro ?? ''),
                _buildInfoRow('Cidade', '${usuario.cidade ?? ''}/${usuario.estado ?? ''}'),
                _buildInfoRow('CEP', _formatarCEP(usuario.cep ?? '')),
              ],
              if (usuario.nucleoPertence != null && usuario.nucleoPertence!.isNotEmpty) ...[
                const Divider(),
                _buildInfoRow('Núcleo', usuario.nucleoPertence ?? ''),
              ],
              if (usuario.sexo != null) _buildInfoRow('Sexo', usuario.sexo!),
              if (usuario.estadoCivil != null) _buildInfoRow('Estado Civil', usuario.estadoCivil!),
              if (usuario.tipoSanguineo != null) _buildInfoRow('Tipo Sanguíneo', usuario.tipoSanguineo!),
              if (usuario.nomeResponsavel != null) ...[
                const Divider(),
                _buildInfoRow('Responsável', usuario.nomeResponsavel!),
                if (usuario.telefoneResponsavel != null)
                  _buildInfoRow('Tel. Resp.', _formatarTelefone(usuario.telefoneResponsavel!)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  String _formatarCEP(String cep) {
    if (cep.length == 8) {
      return '${cep.substring(0, 5)}-${cep.substring(5)}';
    }
    return cep;
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Cadastro'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Filtros de pesquisa
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pesquisar por:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Número'),
                          value: 'numero',
                          groupValue: tipoPesquisa,
                          onChanged: (value) {
                            setState(() {
                              tipoPesquisa = value!;
                              _limpar();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('CPF'),
                          value: 'cpf',
                          groupValue: tipoPesquisa,
                          onChanged: (value) {
                            setState(() {
                              tipoPesquisa = value!;
                              _limpar();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Nome'),
                          value: 'nome',
                          groupValue: tipoPesquisa,
                          onChanged: (value) {
                            setState(() {
                              tipoPesquisa = value!;
                              _limpar();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (tipoPesquisa == 'numero')
                    TextField(
                      controller: numeroController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Cadastro',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                        hintText: '00001',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      onSubmitted: (_) => _pesquisar(),
                    ),
                  if (tipoPesquisa == 'cpf')
                    TextField(
                      controller: cpfController,
                      inputFormatters: [cpfMask],
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                        hintText: '000.000.000-00',
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _pesquisar(),
                    ),
                  if (tipoPesquisa == 'nome')
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome (busca parcial)',
                        prefixIcon: Icon(Icons.person_search),
                        border: OutlineInputBorder(),
                        hintText: 'Digite parte do nome',
                      ),
                      onSubmitted: (_) => _pesquisar(),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _limpar,
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpar'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _pesquisar,
                        icon: const Icon(Icons.search),
                        label: const Text('Pesquisar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Resultados
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum resultado encontrado.\nUse os filtros acima para pesquisar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final usuario = controller.searchResults[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        child: Text(usuario.nome[0].toUpperCase()),
                      ),
                      title: Text(usuario.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CPF: ${_formatarCPF(usuario.cpf)}'),
                          if (usuario.numeroCadastro != null)
                            Text('Nº: ${usuario.numeroCadastro}'),
                          Text('Tel: ${_formatarTelefone(usuario.telefoneCelular ?? '')}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _verDetalhes(usuario),
                        tooltip: 'Ver detalhes',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
