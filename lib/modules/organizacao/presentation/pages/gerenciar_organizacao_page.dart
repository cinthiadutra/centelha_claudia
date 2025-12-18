import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/organizacao_centelha.dart';
import '../controllers/organizacao_centelha_controller.dart';
import '../../../membros/presentation/controllers/membro_controller.dart';

/// Página para gerenciar dados da organização CENTELHA
/// Disponível apenas para nível 4 (Administradores)
class GerenciarOrganizacaoPage extends StatefulWidget {
  const GerenciarOrganizacaoPage({super.key});

  @override
  State<GerenciarOrganizacaoPage> createState() => _GerenciarOrganizacaoPageState();
}

class _GerenciarOrganizacaoPageState extends State<GerenciarOrganizacaoPage> {
  final organizacaoController = Get.find<OrganizacaoCentelhaController>();
  final membroController = Get.find<MembroController>();

  final _formKey = GlobalKey<FormState>();
  
  // Dados institucionais
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _siteWebController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  // Diretoria
  final _presidenteCadastroController = TextEditingController();
  final _presidenteNomeController = TextEditingController();
  final _vicepresidenteCadastroController = TextEditingController();
  final _vicepresidenteNomeController = TextEditingController();
  final _secretarioCadastroController = TextEditingController();
  final _secretarioNomeController = TextEditingController();
  final _tesoureiroCadastroController = TextEditingController();
  final _tesoureiroNomeController = TextEditingController();
  
  final _observacoesController = TextEditingController();
  
  DateTime? dataFundacao;
  OrganizacaoCentelha? organizacaoAtual;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    organizacaoController.organizacao.listen((org) {
      if (org != null) {
        setState(() {
          organizacaoAtual = org;
          _nomeController.text = org.nome;
          _cnpjController.text = org.cnpj;
          _enderecoController.text = org.endereco;
          _cidadeController.text = org.cidade;
          _estadoController.text = org.estado;
          _cepController.text = org.cep;
          _telefoneController.text = org.telefone;
          _emailController.text = org.email;
          _siteWebController.text = org.siteWeb;
          _logoUrlController.text = org.logoUrl ?? '';
          
          _presidenteCadastroController.text = org.presidenteCadastro;
          _presidenteNomeController.text = org.presidenteNome;
          _vicepresidenteCadastroController.text = org.vicepresidenteCadastro;
          _vicepresidenteNomeController.text = org.vicepresidenteNome;
          _secretarioCadastroController.text = org.secretarioCadastro;
          _secretarioNomeController.text = org.secretarioNome;
          _tesoureiroCadastroController.text = org.tesoureiroCadastro;
          _tesoureiroNomeController.text = org.tesoureiroNome;
          
          _observacoesController.text = org.observacoes ?? '';
          dataFundacao = org.dataFundacao;
        });
      }
    });
  }

  Future<void> _buscarMembro(
    TextEditingController cadastroController,
    TextEditingController nomeController,
  ) async {
    final numero = cadastroController.text.trim();
    if (numero.isEmpty) return;

    final membro = await membroController.buscarPorNumero(numero);
    if (membro != null) {
      setState(() {
        nomeController.text = membro.nome;
      });
    } else {
      Get.snackbar(
        'Não encontrado',
        'Membro com cadastro $numero não encontrado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selecionarDataFundacao() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataFundacao ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (data != null) {
      setState(() {
        dataFundacao = data;
      });
    }
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (dataFundacao == null) {
      Get.snackbar(
        'Atenção',
        'Selecione a data de fundação',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final organizacao = OrganizacaoCentelha(
      id: organizacaoAtual?.id ?? '1',
      nome: _nomeController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      endereco: _enderecoController.text.trim(),
      cidade: _cidadeController.text.trim(),
      estado: _estadoController.text.trim(),
      cep: _cepController.text.trim(),
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim(),
      siteWeb: _siteWebController.text.trim(),
      logoUrl: _logoUrlController.text.trim().isEmpty 
          ? null 
          : _logoUrlController.text.trim(),
      presidenteNome: _presidenteNomeController.text.trim(),
      presidenteCadastro: _presidenteCadastroController.text.trim(),
      vicepresidenteNome: _vicepresidenteNomeController.text.trim(),
      vicepresidenteCadastro: _vicepresidenteCadastroController.text.trim(),
      secretarioNome: _secretarioNomeController.text.trim(),
      secretarioCadastro: _secretarioCadastroController.text.trim(),
      tesoureiroNome: _tesoureiroNomeController.text.trim(),
      tesoureiroCadastro: _tesoureiroCadastroController.text.trim(),
      dataFundacao: dataFundacao!,
      observacoes: _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim(),
    );

    await organizacaoController.atualizar(organizacao);
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Organização CENTELHA'),
        backgroundColor: Colors.teal,
        actions: [
          Obx(() {
            final org = organizacaoController.organizacao.value;
            if (org?.dataUltimaAlteracao != null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Última alteração: ${_formatarData(org!.dataUltimaAlteracao)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DADOS INSTITUCIONAIS
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.business, color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'DADOS INSTITUCIONAIS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome da Organização *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cnpjController,
                              decoration: const InputDecoration(
                                labelText: 'CNPJ *',
                                border: OutlineInputBorder(),
                                hintText: '00.000.000/0001-00',
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: _selecionarDataFundacao,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Data de Fundação *',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  dataFundacao != null
                                      ? _formatarData(dataFundacao)
                                      : 'Selecione a data',
                                  style: TextStyle(
                                    color: dataFundacao != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _enderecoController,
                        decoration: const InputDecoration(
                          labelText: 'Endereço *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _cidadeController,
                              decoration: const InputDecoration(
                                labelText: 'Cidade *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _estadoController,
                              decoration: const InputDecoration(
                                labelText: 'Estado *',
                                border: OutlineInputBorder(),
                                hintText: 'SP',
                              ),
                              maxLength: 2,
                              validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cepController,
                              decoration: const InputDecoration(
                                labelText: 'CEP *',
                                border: OutlineInputBorder(),
                                hintText: '01234-567',
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _telefoneController,
                              decoration: const InputDecoration(
                                labelText: 'Telefone *',
                                border: OutlineInputBorder(),
                                hintText: '(11) 1234-5678',
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v?.isEmpty == true) return 'Campo obrigatório';
                                if (!GetUtils.isEmail(v!)) return 'Email inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _siteWebController,
                              decoration: const InputDecoration(
                                labelText: 'Site Web',
                                border: OutlineInputBorder(),
                                hintText: 'www.centelha.org',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _logoUrlController,
                              decoration: const InputDecoration(
                                labelText: 'URL do Logo',
                                border: OutlineInputBorder(),
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

              // DIRETORIA
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.groups, color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'DIRETORIA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      
                      // Presidente
                      const Text('Presidente', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _presidenteCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Nº Cadastro *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                              onChanged: (_) => _buscarMembro(
                                _presidenteCadastroController,
                                _presidenteNomeController,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _buscarMembro(
                              _presidenteCadastroController,
                              _presidenteNomeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _presidenteNomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Vice-presidente
                      const Text('Vice-presidente', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _vicepresidenteCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Nº Cadastro *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                              onChanged: (_) => _buscarMembro(
                                _vicepresidenteCadastroController,
                                _vicepresidenteNomeController,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _buscarMembro(
                              _vicepresidenteCadastroController,
                              _vicepresidenteNomeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _vicepresidenteNomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Secretário
                      const Text('Secretário', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _secretarioCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Nº Cadastro *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                              onChanged: (_) => _buscarMembro(
                                _secretarioCadastroController,
                                _secretarioNomeController,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _buscarMembro(
                              _secretarioCadastroController,
                              _secretarioNomeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _secretarioNomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Tesoureiro
                      const Text('Tesoureiro', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _tesoureiroCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Nº Cadastro *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                              onChanged: (_) => _buscarMembro(
                                _tesoureiroCadastroController,
                                _tesoureiroNomeController,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _buscarMembro(
                              _tesoureiroCadastroController,
                              _tesoureiroNomeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _tesoureiroNomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // OBSERVAÇÕES
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OBSERVAÇÕES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _observacoesController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Informações adicionais sobre a organização...',
                        ),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BOTÃO SALVAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Alterações'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _siteWebController.dispose();
    _logoUrlController.dispose();
    _presidenteCadastroController.dispose();
    _presidenteNomeController.dispose();
    _vicepresidenteCadastroController.dispose();
    _vicepresidenteNomeController.dispose();
    _secretarioCadastroController.dispose();
    _secretarioNomeController.dispose();
    _tesoureiroCadastroController.dispose();
    _tesoureiroNomeController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}
