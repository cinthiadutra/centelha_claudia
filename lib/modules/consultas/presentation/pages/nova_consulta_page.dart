import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/consulta.dart';
import '../../../cadastro/presentation/controllers/cadastro_controller.dart';
import '../controllers/consulta_controller.dart';
import '../../../../core/constants/consulta_constants.dart';

/// Página para registrar nova consulta espiritual
/// Disponível para níveis 2 e 4
class NovaConsultaPage extends StatefulWidget {
  const NovaConsultaPage({super.key});

  @override
  State<NovaConsultaPage> createState() => _NovaConsultaPageState();
}

class _NovaConsultaPageState extends State<NovaConsultaPage> {
  final _formKey = GlobalKey<FormState>();
  final cadastroController = Get.find<CadastroController>();
  final consultaController = Get.find<ConsultaController>();

  final numeroConsultaController = TextEditingController();
  final cadastroConsulenteController = TextEditingController();
  final cadastroCambonoController = TextEditingController();
  final cadastroMediumController = TextEditingController();
  final nomeConsulenteController = TextEditingController();
  final nomeCambonoController = TextEditingController();
  final nomeMediumController = TextEditingController();
  final descricaoController = TextEditingController();

  DateTime? dataSelecionada;
  TimeOfDay? horaSelecionada;
  String? entidadeSelecionada;

  @override
  void initState() {
    super.initState();
    numeroConsultaController.text = consultaController.gerarProximoNumero();
  }

  @override
  void dispose() {
    numeroConsultaController.dispose();
    cadastroConsulenteController.dispose();
    cadastroCambonoController.dispose();
    cadastroMediumController.dispose();
    nomeConsulenteController.dispose();
    nomeCambonoController.dispose();
    nomeMediumController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void _buscarNomePorCadastro(
    String cadastro,
    TextEditingController nomeController,
  ) {
    if (cadastro.isEmpty) {
      nomeController.clear();
      return;
    }

    final usuario = cadastroController.usuarios.firstWhereOrNull(
      (u) => u.numeroCadastro == cadastro,
    );

    if (usuario != null) {
      nomeController.text = usuario.nome;
    } else {
      nomeController.clear();
      Get.snackbar(
        'Não encontrado',
        'Nenhum cadastro encontrado com este número',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (data != null) {
      setState(() => dataSelecionada = data);
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() => horaSelecionada = hora);
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarHora(TimeOfDay? hora) {
    if (hora == null) return '';
    return '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios');
      return;
    }

    if (dataSelecionada == null) {
      Get.snackbar('Atenção', 'Selecione a data da consulta');
      return;
    }

    if (horaSelecionada == null) {
      Get.snackbar('Atenção', 'Selecione a hora de início');
      return;
    }

    if (entidadeSelecionada == null) {
      Get.snackbar('Atenção', 'Selecione a entidade');
      return;
    }

    final consulta = Consulta(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroConsulta: numeroConsultaController.text,
      data: dataSelecionada!,
      horaInicio: _formatarHora(horaSelecionada),
      cadastroConsulente: cadastroConsulenteController.text,
      cadastroCambono: cadastroCambonoController.text,
      cadastroMedium: cadastroMediumController.text,
      nomeConsulente: nomeConsulenteController.text,
      nomeCambono: nomeCambonoController.text,
      nomeMedium: nomeMediumController.text,
      nomeEntidade: entidadeSelecionada!,
      descricaoConsulta: descricaoController.text,
      dataCriacao: DateTime.now(),
    );

    try {
      await consultaController.adicionarConsulta(consulta);
      Get.back();
    } catch (e) {
      // Erro já tratado no controller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Consulta'),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Número da consulta (gerado automaticamente)
            TextFormField(
              controller: numeroConsultaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Número da Consulta',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('DADOS DA CONSULTA'),

            // Data
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: _formatarData(dataSelecionada)),
              onTap: _selecionarData,
              decoration: InputDecoration(
                labelText: 'Data *',
                prefixIcon: const Icon(Icons.calendar_today),
                border: const OutlineInputBorder(),
                suffixIcon: dataSelecionada != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => dataSelecionada = null),
                      )
                    : null,
              ),
              validator: (v) => dataSelecionada == null ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 16),

            // Hora de início
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: _formatarHora(horaSelecionada)),
              onTap: _selecionarHora,
              decoration: InputDecoration(
                labelText: 'Hora de Início *',
                prefixIcon: const Icon(Icons.access_time),
                border: const OutlineInputBorder(),
                suffixIcon: horaSelecionada != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => horaSelecionada = null),
                      )
                    : null,
              ),
              validator: (v) => horaSelecionada == null ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 16),

            // Entidade
            DropdownButtonFormField<String>(
              value: entidadeSelecionada,
              decoration: const InputDecoration(
                labelText: 'Nome da Entidade *',
                prefixIcon: Icon(Icons.person_pin),
                border: OutlineInputBorder(),
              ),
              items: ConsultaConstants.entidadesOpcoes.map((entidade) {
                return DropdownMenuItem(value: entidade, child: Text(entidade));
              }).toList(),
              onChanged: (v) => setState(() => entidadeSelecionada = v),
              validator: (v) => v == null ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('CONSULENTE'),

            // Cadastro do consulente
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cadastroConsulenteController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Cadastro *',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _buscarNomePorCadastro(
                    cadastroConsulenteController.text,
                    nomeConsulenteController,
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nome do consulente (preenchido automaticamente)
            TextFormField(
              controller: nomeConsulenteController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Nome do Consulente',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Busque o cadastro primeiro' : null,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('CAMBONO'),

            // Cadastro do cambono
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cadastroCambonoController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Cadastro *',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _buscarNomePorCadastro(
                    cadastroCambonoController.text,
                    nomeCambonoController,
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nome do cambono (preenchido automaticamente)
            TextFormField(
              controller: nomeCambonoController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Nome do Cambono',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Busque o cadastro primeiro' : null,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('MÉDIUM'),

            // Cadastro do médium
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cadastroMediumController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Cadastro *',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _buscarNomePorCadastro(
                    cadastroMediumController.text,
                    nomeMediumController,
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nome do médium (preenchido automaticamente)
            TextFormField(
              controller: nomeMediumController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Nome do Médium',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Busque o cadastro primeiro' : null,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('DESCRIÇÃO DA CONSULTA'),

            // Descrição
            TextFormField(
              controller: descricaoController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Descrição da Consulta *',
                hintText: 'Descreva aqui os detalhes da consulta, orientações recebidas, etc.',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
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
                  label: const Text('Registrar Consulta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
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
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
}
