import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/membro.dart';
import '../../../cadastro/domain/entities/usuario.dart';
import '../../../cadastro/presentation/controllers/cadastro_controller.dart';
import '../controllers/membro_controller.dart';
import '../../../../core/constants/membro_constants.dart';

/// Página para incluir novo membro da CENTELHA
/// Busca primeiro o cadastro pelo CPF e puxa dados pessoais
class IncluirMembroPage extends StatefulWidget {
  const IncluirMembroPage({super.key});

  @override
  State<IncluirMembroPage> createState() => _IncluirMembroPageState();
}

class _IncluirMembroPageState extends State<IncluirMembroPage> {
  final _formKey = GlobalKey<FormState>();
  final cadastroController = Get.find<CadastroController>();
  final membroController = Get.find<MembroController>();

  // Passo 1: Buscar CPF
  final cpfController = TextEditingController();
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Usuario? usuarioEncontrado;
  bool cpfBuscado = false;

  // Passo 2: Dados do Membro
  final numeroCadastroController = TextEditingController();
  final contato1Controller = TextEditingController();
  final contato2Controller = TextEditingController();
  final observacoesOrixaController = TextEditingController();

  // Dropdowns obrigatórios
  String? nucleoSelecionado;
  String? statusSelecionado;
  String? funcaoSelecionada;
  String? classificacaoSelecionada;
  String? diaSessaoSelecionado;

  // Datas
  DateTime? inicioPrimeiroEstagio;
  DateTime? desistenciaPrimeiroEstagio;
  DateTime? primeiroRitoPassagem;
  DateTime? dataPrimeiroDesligamento;
  DateTime? inicioSegundoEstagio;
  DateTime? desistenciaSegundoEstagio;
  DateTime? segundoRitoPassagem;
  DateTime? dataSegundoDesligamento;
  DateTime? inicioTerceiroEstagio;
  DateTime? desistenciaTerceiroEstagio;
  DateTime? terceiroRitoPassagem;
  DateTime? dataTerceiroDesligamento;
  DateTime? inicioQuartoEstagio;
  DateTime? desistenciaQuartoEstagio;
  DateTime? quartoRitoPassagem;
  DateTime? dataQuartoDesligamento;
  DateTime? primeiraCamarinha;
  DateTime? segundaCamarinha;
  DateTime? terceiraCamarinha;
  DateTime? dataCoroacaoSacerdote;

  // Histórico - justificativas e condições
  String? justificativa1Selecionada;
  String? condicao2Selecionada;
  String? justificativa2Selecionada;
  String? condicao3Selecionada;
  String? justificativa3Selecionada;
  String? condicao4Selecionada;
  String? justificativa4Selecionada;

  @override
  void dispose() {
    cpfController.dispose();
    numeroCadastroController.dispose();
    contato1Controller.dispose();
    contato2Controller.dispose();
    observacoesOrixaController.dispose();
    super.dispose();
  }

  Future<void> _buscarPorCPF() async {
    final cpfLimpo = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cpfLimpo.length != 11) {
      Get.snackbar('Atenção', 'Digite um CPF válido');
      return;
    }

    final usuario = cadastroController.usuarios.firstWhereOrNull(
      (u) => u.cpf == cpfLimpo,
    );

    setState(() {
      cpfBuscado = true;
      usuarioEncontrado = usuario;
      
      if (usuario != null) {
        // Gera número de cadastro automático
        numeroCadastroController.text = _gerarNumeroCadastro();
      }
    });

    if (usuario == null) {
      Get.snackbar(
        'CPF não encontrado',
        'Este CPF não está cadastrado. Faça primeiro o cadastro pessoal.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  String _gerarNumeroCadastro() {
    return membroController.gerarNumeroCadastro();
  }

  Future<void> _selecionarData(BuildContext context, Function(DateTime?) onSelected) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (data != null) {
      setState(() => onSelected(data));
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios');
      return;
    }

    if (usuarioEncontrado == null) {
      Get.snackbar('Erro', 'Nenhum cadastro selecionado');
      return;
    }

    // Verifica se CPF já tem membro
    if (membroController.cpfJaTemMembro(usuarioEncontrado!.cpf)) {
      Get.snackbar(
        'Atenção',
        'Já existe um membro cadastrado com este CPF',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final membro = Membro(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroCadastro: numeroCadastroController.text,
      cpf: usuarioEncontrado!.cpf,
      nome: usuarioEncontrado!.nome,
      nucleo: nucleoSelecionado!,
      status: statusSelecionado!,
      funcao: funcaoSelecionada!,
      classificacao: classificacaoSelecionada!,
      diaSessao: diaSessaoSelecionado!,
      primeiroContatoEmergencia: contato1Controller.text.isNotEmpty ? contato1Controller.text : null,
      segundoContatoEmergencia: contato2Controller.text.isNotEmpty ? contato2Controller.text : null,
      // Histórico 1º Estágio
      inicioPrimeiroEstagio: inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio: desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: primeiroRitoPassagem,
      dataPrimeiroDesligamento: dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento: justificativa1Selecionada,
      condicaoSegundoEstagio: condicao2Selecionada,
      // Histórico 2º Estágio
      inicioSegundoEstagio: inicioSegundoEstagio,
      desistenciaSegundoEstagio: desistenciaSegundoEstagio,
      segundoRitoPassagem: segundoRitoPassagem,
      dataSegundoDesligamento: dataSegundoDesligamento,
      justificativaSegundoDesligamento: justificativa2Selecionada,
      condicaoTerceiroEstagio: condicao3Selecionada,
      // Histórico 3º Estágio
      inicioTerceiroEstagio: inicioTerceiroEstagio,
      desistenciaTerceiroEstagio: desistenciaTerceiroEstagio,
      terceiroRitoPassagem: terceiroRitoPassagem,
      dataTerceiroDesligamento: dataTerceiroDesligamento,
      justificativaTerceiroDesligamento: justificativa3Selecionada,
      condicaoQuartoEstagio: condicao4Selecionada,
      // Histórico 4º Estágio
      inicioQuartoEstagio: inicioQuartoEstagio,
      desistenciaQuartoEstagio: desistenciaQuartoEstagio,
      quartoRitoPassagem: quartoRitoPassagem,
      dataQuartoDesligamento: dataQuartoDesligamento,
      justificativaQuartoDesligamento: justificativa4Selecionada,
      // Histórico Espiritual (preenchidos do cadastro)
      dataBatizado: usuarioEncontrado!.dataBatismo,
      padrinhoBatismo: usuarioEncontrado!.padrinhoBatismo,
      madrinhaBatismo: usuarioEncontrado!.madrinhaBatismo,
      dataJogoOrixa: usuarioEncontrado!.dataJogoOrixa,
      primeiraCamarinha: primeiraCamarinha,
      segundaCamarinha: segundaCamarinha,
      terceiraCamarinha: terceiraCamarinha,
      dataCoroacaoSacerdote: dataCoroacaoSacerdote,
      atividadeEspiritual: usuarioEncontrado!.atividadeEspiritual,
      grupoTrabalhoEspiritual: usuarioEncontrado!.grupoAtividadeEspiritual,
      // Orixás (preenchidos do cadastro)
      primeiroOrixa: usuarioEncontrado!.primeiroOrixa,
      adjuntoPrimeiroOrixa: usuarioEncontrado!.adjuntoPrimeiroOrixa,
      segundoOrixa: usuarioEncontrado!.segundoOrixa,
      adjuntoSegundoOrixa: usuarioEncontrado!.adjuntoSegundoOrixa,
      terceiroOrixa: usuarioEncontrado!.terceiroOrixa,
      quartoOrixa: usuarioEncontrado!.quartoOrixa,
      observacoesOrixa: observacoesOrixaController.text.isNotEmpty ? observacoesOrixaController.text : null,
      dataCriacao: DateTime.now(),
      dataUltimaAlteracao: DateTime.now(),
    );

    try {
      await membroController.adicionarMembro(membro);
      Get.back();
    } catch (e) {
      // Erro já tratado no controller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incluir Novo Membro'),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Passo 1: Buscar CPF
            if (!cpfBuscado) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buscar Cadastro por CPF',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Digite o CPF do membro que deseja incluir. O sistema buscará os dados pessoais já cadastrados.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cpfController,
                              inputFormatters: [cpfMask],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'CPF *',
                                prefixIcon: Icon(Icons.credit_card),
                                border: OutlineInputBorder(),
                                hintText: '000.000.000-00',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _buscarPorCPF,
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
            ],

            // Passo 2: Cadastro encontrado
            if (cpfBuscado && usuarioEncontrado != null) ...[
              // Informações do cadastro encontrado
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            'Cadastro Encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                cpfBuscado = false;
                                usuarioEncontrado = null;
                                cpfController.clear();
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Alterar CPF'),
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildInfoRow('Nome', usuarioEncontrado!.nome),
                      _buildInfoRow('CPF', _formatarCPF(usuarioEncontrado!.cpf)),
                      if (usuarioEncontrado!.dataNascimento != null)
                        _buildInfoRow('Data Nasc.', _formatarData(usuarioEncontrado!.dataNascimento!)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FRAME: Informações Pessoais
              _buildSecaoTitulo('INFORMAÇÕES PESSOAIS'),
              _buildCampoTexto(
                controller: numeroCadastroController,
                label: 'Número do Cadastro *',
                icon: Icons.numbers,
                readOnly: true,
                hint: 'Gerado automaticamente',
              ),
              _buildDropdown(
                value: nucleoSelecionado,
                label: 'Núcleo *',
                items: MembroConstants.nucleoOpcoes,
                onChanged: (v) => setState(() => nucleoSelecionado = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              _buildDropdown(
                value: statusSelecionado,
                label: 'Status *',
                items: MembroConstants.statusOpcoes,
                onChanged: (v) => setState(() => statusSelecionado = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              _buildDropdown(
                value: funcaoSelecionada,
                label: 'Função *',
                items: MembroConstants.funcaoOpcoes,
                onChanged: (v) => setState(() => funcaoSelecionada = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              _buildDropdown(
                value: classificacaoSelecionada,
                label: 'Última Classificação *',
                items: MembroConstants.classificacaoOpcoes,
                onChanged: (v) => setState(() => classificacaoSelecionada = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              _buildDropdown(
                value: diaSessaoSelecionado,
                label: 'Dia de Sessão *',
                items: MembroConstants.diaSessaoOpcoes,
                onChanged: (v) => setState(() => diaSessaoSelecionado = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              _buildCampoTexto(
                controller: contato1Controller,
                label: '1º Contato para Emergência',
                icon: Icons.phone,
              ),
              _buildCampoTexto(
                controller: contato2Controller,
                label: '2º Contato para Emergência',
                icon: Icons.phone,
              ),

              const SizedBox(height: 24),

              // FRAME: Histórico
              _buildSecaoTitulo('HISTÓRICO'),
              
              // 1º Estágio
              const Text('1º Estágio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildCampoData('Início do 1º estágio', inicioPrimeiroEstagio, (d) => inicioPrimeiroEstagio = d),
              _buildCampoData('Desistência do 1º estágio', desistenciaPrimeiroEstagio, (d) => desistenciaPrimeiroEstagio = d),
              _buildCampoData('1º rito de passagem', primeiroRitoPassagem, (d) => primeiroRitoPassagem = d),
              _buildCampoData('1º desligamento', dataPrimeiroDesligamento, (d) => dataPrimeiroDesligamento = d),
              _buildDropdown(
                value: justificativa1Selecionada,
                label: 'Justificativa do 1º desligamento',
                items: MembroConstants.justificativaDesligamentoOpcoes,
                onChanged: (v) => setState(() => justificativa1Selecionada = v),
              ),
              _buildDropdown(
                value: condicao2Selecionada,
                label: 'Condições para o 2º estágio',
                items: MembroConstants.condicaoEstagioOpcoes,
                onChanged: (v) => setState(() => condicao2Selecionada = v),
              ),

              const SizedBox(height: 16),

              // 2º Estágio
              const Text('2º Estágio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildCampoData('Início do 2º estágio', inicioSegundoEstagio, (d) => inicioSegundoEstagio = d),
              _buildCampoData('Desistência do 2º estágio', desistenciaSegundoEstagio, (d) => desistenciaSegundoEstagio = d),
              _buildCampoData('2º rito de passagem', segundoRitoPassagem, (d) => segundoRitoPassagem = d),
              _buildCampoData('2º desligamento', dataSegundoDesligamento, (d) => dataSegundoDesligamento = d),
              _buildDropdown(
                value: justificativa2Selecionada,
                label: 'Justificativa do 2º desligamento',
                items: MembroConstants.justificativaDesligamentoOpcoes,
                onChanged: (v) => setState(() => justificativa2Selecionada = v),
              ),
              _buildDropdown(
                value: condicao3Selecionada,
                label: 'Condições para o 3º estágio',
                items: MembroConstants.condicaoEstagioOpcoes,
                onChanged: (v) => setState(() => condicao3Selecionada = v),
              ),

              const SizedBox(height: 16),

              // 3º Estágio
              const Text('3º Estágio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildCampoData('Início do 3º estágio', inicioTerceiroEstagio, (d) => inicioTerceiroEstagio = d),
              _buildCampoData('Desistência do 3º estágio', desistenciaTerceiroEstagio, (d) => desistenciaTerceiroEstagio = d),
              _buildCampoData('3º rito de passagem', terceiroRitoPassagem, (d) => terceiroRitoPassagem = d),
              _buildCampoData('3º desligamento', dataTerceiroDesligamento, (d) => dataTerceiroDesligamento = d),
              _buildDropdown(
                value: justificativa3Selecionada,
                label: 'Justificativa do 3º desligamento',
                items: MembroConstants.justificativaDesligamentoOpcoes,
                onChanged: (v) => setState(() => justificativa3Selecionada = v),
              ),
              _buildDropdown(
                value: condicao4Selecionada,
                label: 'Condições para o 4º estágio',
                items: MembroConstants.condicaoEstagioOpcoes,
                onChanged: (v) => setState(() => condicao4Selecionada = v),
              ),

              const SizedBox(height: 16),

              // 4º Estágio
              const Text('4º Estágio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildCampoData('Início do 4º estágio', inicioQuartoEstagio, (d) => inicioQuartoEstagio = d),
              _buildCampoData('Desistência do 4º estágio', desistenciaQuartoEstagio, (d) => desistenciaQuartoEstagio = d),
              _buildCampoData('4º rito de passagem', quartoRitoPassagem, (d) => quartoRitoPassagem = d),
              _buildCampoData('4º desligamento', dataQuartoDesligamento, (d) => dataQuartoDesligamento = d),
              _buildDropdown(
                value: justificativa4Selecionada,
                label: 'Justificativa do 4º desligamento',
                items: MembroConstants.justificativaDesligamentoOpcoes,
                onChanged: (v) => setState(() => justificativa4Selecionada = v),
              ),

              const SizedBox(height: 24),

              // FRAME: Histórico Espiritual
              _buildSecaoTitulo('HISTÓRICO ESPIRITUAL'),
              _buildCampoTextoReadOnly('Data do Batizado', _formatarData(usuarioEncontrado!.dataBatismo)),
              _buildCampoTextoReadOnly('Padrinho de batismo', usuarioEncontrado!.padrinhoBatismo ?? '-'),
              _buildCampoTextoReadOnly('Madrinha de batismo', usuarioEncontrado!.madrinhaBatismo ?? '-'),
              _buildCampoTextoReadOnly('Data do jogo de Orixá', _formatarData(usuarioEncontrado!.dataJogoOrixa)),
              _buildCampoData('1ª camarinha', primeiraCamarinha, (d) => primeiraCamarinha = d),
              _buildCampoData('2ª camarinha', segundaCamarinha, (d) => segundaCamarinha = d),
              _buildCampoData('3ª camarinha', terceiraCamarinha, (d) => terceiraCamarinha = d),
              _buildCampoData('Data da coroação de sacerdote', dataCoroacaoSacerdote, (d) => dataCoroacaoSacerdote = d),
              _buildCampoTextoReadOnly('Atividade espiritual', usuarioEncontrado!.atividadeEspiritual ?? '-'),
              _buildCampoTextoReadOnly('Grupo de trabalho espiritual', usuarioEncontrado!.grupoAtividadeEspiritual ?? '-'),

              const SizedBox(height: 24),

              // FRAME: Orixás
              _buildSecaoTitulo('ORIXÁS'),
              _buildCampoTextoReadOnly('1º Orixá', usuarioEncontrado!.primeiroOrixa ?? '-'),
              _buildCampoTextoReadOnly('Adjuntó do 1º Orixá', usuarioEncontrado!.adjuntoPrimeiroOrixa ?? '-'),
              _buildCampoTextoReadOnly('2º Orixá', usuarioEncontrado!.segundoOrixa ?? '-'),
              _buildCampoTextoReadOnly('Adjuntó do 2º Orixá', usuarioEncontrado!.adjuntoSegundoOrixa ?? '-'),
              _buildCampoTextoReadOnly('3º Orixá', usuarioEncontrado!.terceiroOrixa ?? '-'),
              _buildCampoTextoReadOnly('4º Orixá', usuarioEncontrado!.quartoOrixa ?? '-'),
              TextFormField(
                controller: observacoesOrixaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações relevantes',
                  border: OutlineInputBorder(),
                ),
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
                    label: const Text('Salvar Membro'),
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
          ],
        ),
      ),
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
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey.shade100 : null,
        ),
      ),
    );
  }

  Widget _buildCampoTextoReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildCampoData(String label, DateTime? data, Function(DateTime?) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(text: _formatarData(data)),
        onTap: () => _selecionarData(context, onSelected),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
          suffixIcon: data != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => onSelected(null)),
                )
              : null,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
}
