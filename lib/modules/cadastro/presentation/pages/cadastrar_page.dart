import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/usuario.dart';
import '../controllers/cadastro_controller.dart';
import '../../../../core/constants/usuario_constants.dart';

/// Página para cadastrar novo usuário
class CadastrarPage extends StatefulWidget {
  const CadastrarPage({super.key});

  @override
  State<CadastrarPage> createState() => _CadastrarPageState();
}

class _CadastrarPageState extends State<CadastrarPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<CadastroController>();

  // Máscaras de formatação
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

  // Controllers dos campos obrigatórios
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

  // Controllers dos campos opcionais
  final apelido1Controller = TextEditingController();
  final apelido2Controller = TextEditingController();
  final nomeResponsavelController = TextEditingController();
  final telefoneResponsavelController = TextEditingController();
  final emailResponsavelController = TextEditingController();

  // Dropdowns
  String? nucleoSelecionado;
  String? estadoCivilSelecionado;
  String? sexoSelecionado;
  String? tipoSanguineoSelecionado;

  DateTime? dataNascimento;

  @override
  void dispose() {
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

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        dataNascimento = data;
        dataNascimentoController.text =
            '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
      });
    }
  }

  int _calcularIdade(DateTime dataNasc) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month ||
        (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }
    return idade;
  }

  bool _validarIdadeResponsavel() {
    if (dataNascimento == null) return true;

    final idade = _calcularIdade(dataNascimento!);
    
    // Se menor de 18 anos, precisa ter responsável
    if (idade < 18) {
      return nomeResponsavelController.text.isNotEmpty &&
             telefoneResponsavelController.text.isNotEmpty;
    }
    
    return true;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        'Atenção',
        'Preencha todos os campos obrigatórios',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!_validarIdadeResponsavel()) {
      Get.snackbar(
        'Atenção',
        'Cadastro de menor de idade requer dados do responsável',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Verifica CPF duplicado
    final cpfLimpo = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (await controller.cpfJaExiste(cpfLimpo)) {
      Get.snackbar(
        'Erro',
        'CPF já cadastrado no sistema',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Verifica nomes similares
    final nomesSimilares = controller.buscarNomesSimilares(nomeController.text);
    if (nomesSimilares.isNotEmpty) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nome Similar Encontrado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Já existe(m) cadastro(s) com nome similar:'),
              const SizedBox(height: 8),
              ...nomesSimilares.map((u) => Text('• ${u.nome}')),
              const SizedBox(height: 16),
              const Text('Deseja continuar mesmo assim?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (confirmar != true) return;
    }

    // Cria usuario
    final usuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nomeController.text.trim(),
      cpf: cpfLimpo,
      dataNascimento: dataNascimento!,
      telefoneCelular: telefoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
      email: emailController.text.trim(),
      endereco: enderecoController.text.trim(),
      bairro: bairroController.text.trim(),
      cidade: cidadeController.text.trim(),
      estado: estadoController.text.trim(),
      cep: cepController.text.replaceAll(RegExp(r'[^\d]'), ''),
      nucleoPertence: nucleoSelecionado ?? '',
      // Opcionais
      apelido1: apelido1Controller.text.isNotEmpty ? apelido1Controller.text.trim() : null,
      apelido2: apelido2Controller.text.isNotEmpty ? apelido2Controller.text.trim() : null,
      estadoCivil: estadoCivilSelecionado,
      sexo: sexoSelecionado,
      tipoSanguineo: tipoSanguineoSelecionado,
      nomeResponsavel: nomeResponsavelController.text.isNotEmpty ? nomeResponsavelController.text.trim() : null,
      telefoneResponsavel: telefoneResponsavelController.text.isNotEmpty ? telefoneResponsavelController.text.replaceAll(RegExp(r'[^\d]'), '') : null,
      emailResponsavel: emailResponsavelController.text.isNotEmpty ? emailResponsavelController.text.trim() : null,
    );

    final sucesso = await controller.cadastrar(usuario);

    if (sucesso) {
      // Limpa formulário
      _formKey.currentState!.reset();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Importar do Excel',
            onPressed: () {
              Get.toNamed('/importar-excel');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
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

              // Responsável (se menor de idade)
              _buildSecaoTitulo('Responsável (obrigatório se menor de 18 anos)'),
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
                    onPressed: () => Get.back(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Cadastro'),
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
          color: Colors.blue,
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
        decoration: const InputDecoration(
          labelText: 'Data de Nascimento *',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
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
