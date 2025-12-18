import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/usuario_sistema.dart';
import '../controllers/usuario_sistema_controller.dart';
import '../../../membros/presentation/controllers/membro_controller.dart';

/// Página para gerenciar usuários do sistema
/// Disponível apenas para nível 4 (Administradores)
class GerenciarUsuarioSistemaPage extends StatefulWidget {
  const GerenciarUsuarioSistemaPage({super.key});

  @override
  State<GerenciarUsuarioSistemaPage> createState() => _GerenciarUsuarioSistemaPageState();
}

class _GerenciarUsuarioSistemaPageState extends State<GerenciarUsuarioSistemaPage> {
  final usuarioSistemaController = Get.find<UsuarioSistemaController>();
  final membroController = Get.find<MembroController>();

  final _formKey = GlobalKey<FormState>();
  final _numeroCadastroController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _observacoesController = TextEditingController();

  int? nivelPermissaoSelecionado;
  bool ativoSelecionado = true;
  UsuarioSistema? usuarioEditando;

  bool _obscureSenha = true;

  void _buscarMembro() async {
    final numero = _numeroCadastroController.text.trim();
    if (numero.isEmpty) return;

    final membro = await membroController.buscarPorNumero(numero);
    if (membro != null) {
      setState(() {
        _nomeController.text = membro.nome;
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

  void _novoUsuario() {
    setState(() {
      usuarioEditando = null;
      _numeroCadastroController.clear();
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _observacoesController.clear();
      nivelPermissaoSelecionado = null;
      ativoSelecionado = true;
    });
  }

  void _editarUsuario(UsuarioSistema usuario) {
    setState(() {
      usuarioEditando = usuario;
      _numeroCadastroController.text = usuario.numeroCadastro;
      _nomeController.text = usuario.nome;
      _emailController.text = usuario.email;
      _senhaController.text = usuario.senha;
      _observacoesController.text = usuario.observacoes ?? '';
      nivelPermissaoSelecionado = usuario.nivelPermissao;
      ativoSelecionado = usuario.ativo;
    });
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (nivelPermissaoSelecionado == null) {
      Get.snackbar(
        'Atenção',
        'Selecione o nível de permissão',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final usuario = UsuarioSistema(
      id: usuarioEditando?.id ?? '',
      numeroCadastro: _numeroCadastroController.text.trim(),
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text.trim(),
      nivelPermissao: nivelPermissaoSelecionado!,
      ativo: ativoSelecionado,
      dataCriacao: usuarioEditando?.dataCriacao ?? DateTime.now(),
      dataUltimaAlteracao: DateTime.now(),
      observacoes: _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim(),
    );

    await usuarioSistemaController.salvar(usuario);
    _novoUsuario();
  }

  void _excluir(UsuarioSistema usuario) async {
    final confirma = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente remover o usuário ${usuario.nome}?'),
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
      await usuarioSistemaController.remover(usuario.id);
      if (usuarioEditando?.id == usuario.id) {
        _novoUsuario();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários do Sistema'),
        backgroundColor: Colors.indigo,
      ),
      body: Row(
        children: [
          // Formulário (esquerda)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            usuarioEditando == null ? 'NOVO USUÁRIO' : 'EDITAR USUÁRIO',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (usuarioEditando != null)
                            OutlinedButton.icon(
                              onPressed: _novoUsuario,
                              icon: const Icon(Icons.add),
                              label: const Text('Novo'),
                            ),
                        ],
                      ),
                      const Divider(height: 32),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _numeroCadastroController,
                              decoration: const InputDecoration(
                                labelText: 'Número do Cadastro *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Campo obrigatório' : null,
                              onChanged: (_) => _buscarMembro(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _buscarMembro,
                            icon: const Icon(Icons.search),
                            tooltip: 'Buscar membro',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
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
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _senhaController,
                        decoration: InputDecoration(
                          labelText: 'Senha *',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureSenha ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                          ),
                        ),
                        obscureText: _obscureSenha,
                        validator: (v) {
                          if (v?.isEmpty == true) return 'Campo obrigatório';
                          if (v!.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<int>(
                        value: nivelPermissaoSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Nível de Permissão *',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Nível 1 - Acesso próprio')),
                          DropdownMenuItem(value: 2, child: Text('Nível 2 - Secretaria')),
                          DropdownMenuItem(value: 3, child: Text('Nível 3 - Líder espiritual')),
                          DropdownMenuItem(value: 4, child: Text('Nível 4 - Administrador')),
                        ],
                        onChanged: (v) => setState(() => nivelPermissaoSelecionado = v),
                      ),
                      const SizedBox(height: 16),
                      
                      SwitchListTile(
                        title: const Text('Usuário Ativo'),
                        subtitle: Text(ativoSelecionado ? 'Ativo' : 'Inativo'),
                        value: ativoSelecionado,
                        onChanged: (v) => setState(() => ativoSelecionado = v),
                        activeColor: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _observacoesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save),
                          label: Text(usuarioEditando == null ? 'Criar Usuário' : 'Atualizar Usuário'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Lista de usuários (direita)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      Obx(() => Text(
                            'Total de usuários: ${usuarioSistemaController.usuarios.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700,
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final usuarios = usuarioSistemaController.usuarios;
                    if (usuarios.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum usuário cadastrado',
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarios[index];
                        final isEditando = usuarioEditando?.id == usuario.id;

                        return Card(
                          elevation: isEditando ? 4 : 1,
                          color: isEditando ? Colors.indigo.shade50 : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: usuario.ativo ? Colors.green : Colors.grey,
                              child: Text(
                                usuario.nome.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              usuario.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${usuario.email}'),
                                Text('Cadastro: ${usuario.numeroCadastro}'),
                                Chip(
                                  label: Text(
                                    usuario.nivelPermissaoTexto,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: _getNivelColor(usuario.nivelPermissao),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarUsuario(usuario),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _excluir(usuario),
                                  tooltip: 'Excluir',
                                ),
                              ],
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
          ),
        ],
      ),
    );
  }

  Color _getNivelColor(int nivel) {
    switch (nivel) {
      case 1:
        return Colors.blue.shade100;
      case 2:
        return Colors.green.shade100;
      case 3:
        return Colors.orange.shade100;
      case 4:
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  void dispose() {
    _numeroCadastroController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}
