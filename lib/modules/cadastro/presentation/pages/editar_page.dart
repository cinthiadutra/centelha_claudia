import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/usuario.dart';
import '../controllers/cadastro_controller.dart';
import '../../../../core/constants/usuario_constants.dart';

/// Página para editar cadastro existente
class EditarPage extends StatefulWidget {
  const EditarPage({super.key});

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<CadastroController>();

  // Máscaras
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Busca
  final numeroController = TextEditingController();
  bool usuarioCarregado = false;

  // Campos do formulário
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final enderecoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final cepController = TextEditingController();
  final apelido1Controller = TextEditingController();
  final apelido2Controller = TextEditingController();
  final nomeResponsavelController = TextEditingController();
  final telefoneResponsavelController = TextEditingController();
  final emailResponsavelController = TextEditingController();

  String? nucleoSelecionado;
  String? estadoCivilSelecionado;
  String? sexoSelecionado;
  String? tipoSanguineoSelecionado;
  DateTime? dataNascimento;

  String? usuarioId;

  @override
  void dispose() {
    numeroController.dispose();
    nomeController.dispose();
    cpfController.dispose();
    dataNascimentoController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    enderecoController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    cepController.dispose();
    apelido1Controller.dispose();
    apelido2Controller.dispose();
    nomeResponsavelController.dispose();
    telefoneResponsavelController.dispose();
    emailResponsavelController.dispose();
    super.dispose();
  }

  void _buscarPorNumero() async {
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
      return;
    }

    _carregarUsuario(usuario);
  }

  void _carregarUsuario(Usuario usuario) {
    setState(() {
      usuarioId = usuario.id;
      usuarioCarregado = true;

      nomeController.text = usuario.nome;
      cpfController.text = _formatarCPF(usuario.cpf);
      dataNascimento = usuario.dataNascimento;
      dataNascimentoController.text = usuario.dataNascimento != null ? _formatarData(usuario.dataNascimento!) : '';
      telefoneController.text = _formatarTelefone(usuario.telefoneCelular ?? '');
      emailController.text = usuario.email ?? '';
      enderecoController.text = usuario.endereco ?? '';
      bairroController.text = usuario.bairro ?? '';
      cidadeController.text = usuario.cidade ?? '';
      estadoController.text = usuario.estado ?? '';
      cepController.text = _formatarCEP(usuario.cep ?? '');
      nucleoSelecionado = usuario.nucleoPertence != null && usuario.nucleoPertence!.isNotEmpty ? usuario.nucleoPertence : null;

      apelido1Controller.text = usuario.apelido1 ?? '';
      apelido2Controller.text = usuario.apelido2 ?? '';
      sexoSelecionado = usuario.sexo;
      estadoCivilSelecionado = usuario.estadoCivil;
      tipoSanguineoSelecionado = usuario.tipoSanguineo;
      nomeResponsavelController.text = usuario.nomeResponsavel ?? '';
      telefoneResponsavelController.text = usuario.telefoneResponsavel != null 
          ? _formatarTelefone(usuario.telefoneResponsavel!) 
          : '';
      emailResponsavelController.text = usuario.emailResponsavel ?? '';
    });
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        dataNascimento = data;
        dataNascimentoController.text = _formatarData(data);
      });
    }
  }

  Future<void> _salvar() async {
    if (!usuarioCarregado) {
      Get.snackbar('Atenção', 'Busque um cadastro primeiro');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios');
      return;
    }

    final usuarioOriginal = controller.usuarios.firstWhere(
      (u) => u.id == usuarioId,
    );

    final usuario = usuarioOriginal.copyWith(
      nome: nomeController.text.trim(),
      cpf: cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
      dataNascimento: dataNascimento,
      telefoneCelular: telefoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
      email: emailController.text.trim(),
      endereco: enderecoController.text.trim(),
      bairro: bairroController.text.trim(),
      cidade: cidadeController.text.trim(),
      estado: estadoController.text.trim(),
      cep: cepController.text.replaceAll(RegExp(r'[^\d]'), ''),
      nucleoPertence: nucleoSelecionado ?? '',
      apelido1: apelido1Controller.text.isNotEmpty ? apelido1Controller.text.trim() : null,
      apelido2: apelido2Controller.text.isNotEmpty ? apelido2Controller.text.trim() : null,
      estadoCivil: estadoCivilSelecionado,
      sexo: sexoSelecionado,
      tipoSanguineo: tipoSanguineoSelecionado,
      nomeResponsavel: nomeResponsavelController.text.isNotEmpty ? nomeResponsavelController.text.trim() : null,
      telefoneResponsavel: telefoneResponsavelController.text.isNotEmpty ? telefoneResponsavelController.text.replaceAll(RegExp(r'[^\d]'), '') : null,
      emailResponsavel: emailResponsavelController.text.isNotEmpty ? emailResponsavelController.text.trim() : null,
    );

    final sucesso = await controller.editar(usuario);

    if (sucesso) {
      setState(() {
        usuarioCarregado = false;
        usuarioId = null;
      });
      numeroController.clear();
      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    nomeController.clear();
    cpfController.clear();
    dataNascimentoController.clear();
    telefoneController.clear();
    emailController.clear();
    enderecoController.clear();
    bairroController.clear();
    cidadeController.clear();
    estadoController.clear();
    cepController.clear();
    apelido1Controller.clear();
    apelido2Controller.clear();
    nomeResponsavelController.clear();
    telefoneResponsavelController.clear();
    emailResponsavelController.clear();
    setState(() {
      nucleoSelecionado = null;
      estadoCivilSelecionado = null;
      sexoSelecionado = null;
      tipoSanguineoSelecionado = null;
      dataNascimento = null;
    });
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
        title: const Text('Editar Cadastro'),
        backgroundColor: Colors.orange,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Busca por número
            if (!usuarioCarregado)
              Card(
                margin: const EdgeInsets.all(16),
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

            // Formulário de edição
            if (usuarioCarregado)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.blue),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Editando cadastro Nº ${numeroController.text}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    usuarioCarregado = false;
                                    usuarioId = null;
                                  });
                                  numeroController.clear();
                                  _limparFormulario();
                                },
                                icon: const Icon(Icons.close),
                                label: const Text('Cancelar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dados Pessoais
                      _buildSecaoTitulo('Dados Pessoais'),
                      _buildCampoTexto(
                        controller: nomeController,
                        label: 'Nome Completo *',
                        icon: Icons.person,
                        validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCampoTexto(
                              controller: apelido1Controller,
                              label: 'Apelido 1',
                              icon: Icons.badge,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCampoTexto(
                              controller: apelido2Controller,
                              label: 'Apelido 2',
                              icon: Icons.badge_outlined,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCampoTexto(
                              controller: cpfController,
                              label: 'CPF *',
                              icon: Icons.credit_card,
                              mask: cpfMask,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v?.isEmpty ?? true) return 'Campo obrigatório';
                                if (v!.replaceAll(RegExp(r'[^\d]'), '').length != 11) {
                                  return 'CPF inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCampoData(
                              controller: dataNascimentoController,
                              label: 'Data de Nascimento *',
                              onTap: _selecionarData,
                              validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              value: sexoSelecionado,
                              label: 'Sexo',
                              items: UsuarioConstants.sexoOpcoes,
                              onChanged: (v) => setState(() => sexoSelecionado = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              value: estadoCivilSelecionado,
                              label: 'Estado Civil',
                              items: UsuarioConstants.estadoCivilOpcoes,
                              onChanged: (v) => setState(() => estadoCivilSelecionado = v),
                            ),
                          ),
                        ],
                      ),
                      _buildDropdown(
                        value: tipoSanguineoSelecionado,
                        label: 'Tipo Sanguíneo',
                        items: UsuarioConstants.tipoSanguineoOpcoes,
                        onChanged: (v) => setState(() => tipoSanguineoSelecionado = v),
                      ),

                      const SizedBox(height: 24),

                      // Contato
                      _buildSecaoTitulo('Contato'),
                      _buildCampoTexto(
                        controller: telefoneController,
                        label: 'Telefone *',
                        icon: Icons.phone,
                        mask: telefoneMask,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      _buildCampoTexto(
                        controller: emailController,
                        label: 'E-mail *',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v?.isEmpty ?? true) return 'Campo obrigatório';
                          if (!GetUtils.isEmail(v!)) return 'E-mail inválido';
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Endereço
                      _buildSecaoTitulo('Endereço'),
                      _buildCampoTexto(
                        controller: enderecoController,
                        label: 'Logradouro *',
                        icon: Icons.home,
                        validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCampoTexto(
                              controller: bairroController,
                              label: 'Bairro *',
                              icon: Icons.location_city,
                              validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCampoTexto(
                              controller: cepController,
                              label: 'CEP *',
                              icon: Icons.pin_drop,
                              mask: cepMask,
                              keyboardType: TextInputType.number,
                              validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildCampoTexto(
                              controller: cidadeController,
                              label: 'Cidade *',
                              icon: Icons.location_on,
                              validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCampoTexto(
                              controller: estadoController,
                              label: 'UF *',
                              icon: Icons.map,
                              maxLength: 2,
                              validator: (v) => v?.isEmpty ?? true ? 'Campo obrigatório' : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Núcleo
                      _buildSecaoTitulo('Núcleo'),
                      _buildDropdown(
                        value: nucleoSelecionado,
                        label: 'Núcleo *',
                        items: UsuarioConstants.nucleoOpcoes,
                        onChanged: (v) => setState(() => nucleoSelecionado = v),
                        validator: (v) => v == null ? 'Campo obrigatório' : null,
                      ),

                      const SizedBox(height: 24),

                      // Responsável
                      _buildSecaoTitulo('Responsável'),
                      _buildCampoTexto(
                        controller: nomeResponsavelController,
                        label: 'Nome do Responsável',
                        icon: Icons.supervised_user_circle,
                      ),
                      _buildCampoTexto(
                        controller: telefoneResponsavelController,
                        label: 'Telefone do Responsável',
                        icon: Icons.phone,
                        mask: telefoneMask,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildCampoTexto(
                        controller: emailResponsavelController,
                        label: 'E-mail do Responsável',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 32),

                      // Botões
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                usuarioCarregado = false;
                                usuarioId = null;
                              });
                              numeroController.clear();
                              _limparFormulario();
                            },
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _salvar,
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar Alterações'),
                            style: ElevatedButton.styleFrom(
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
        );
      }),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    MaskTextInputFormatter? mask,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        inputFormatters: mask != null ? [mask] : null,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildCampoData({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
