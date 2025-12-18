import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/usuario.dart';
import '../bloc/usuario_bloc.dart';
import '../bloc/usuario_event.dart';
import '../bloc/usuario_state.dart';

class UsuarioFormPage extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioFormPage({super.key, this.usuario});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneFixoController = TextEditingController();
  final _telefoneCelularController = TextEditingController();
  final _enderecoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nomeController.text = widget.usuario!.nome;
      _cpfController.text = widget.usuario!.cpf;
      _emailController.text = widget.usuario!.email ?? '';
      _telefoneFixoController.text = widget.usuario!.telefoneFixo ?? '';
      _telefoneCelularController.text = widget.usuario!.telefoneCelular ?? '';
      _enderecoController.text = widget.usuario!.endereco ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _telefoneFixoController.dispose();
    _telefoneCelularController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Usuário' : 'Novo Usuário'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<UsuarioBloc, UsuarioState>(
        listener: (context, state) {
          if (state is UsuarioSuccess) {
            Navigator.pop(context);
          } else if (state is UsuarioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações Pessoais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nome é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cpfController,
                          decoration: const InputDecoration(
                            labelText: 'CPF *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                            hintText: '000.000.000-00',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CPF é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefoneFixoController,
                          decoration: const InputDecoration(
                            labelText: 'Telefone Fixo',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            hintText: '(11) 3333-4444',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefoneCelularController,
                          decoration: const InputDecoration(
                            labelText: 'Telefone Celular',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone_android),
                            hintText: '(11) 99999-9999',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _enderecoController,
                          decoration: const InputDecoration(
                            labelText: 'Endereço',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<UsuarioBloc, UsuarioState>(
                  builder: (context, state) {
                    final isLoading = state is UsuarioLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              isEditing ? 'Atualizar' : 'Cadastrar',
                              style: const TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final usuario = Usuario(
        id: widget.usuario?.id,
        nome: _nomeController.text,
        cpf: _cpfController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        telefoneFixo: _telefoneFixoController.text.isEmpty ? null : _telefoneFixoController.text,
        telefoneCelular: _telefoneCelularController.text.isEmpty ? null : _telefoneCelularController.text,
        endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
        dataCadastro: widget.usuario?.dataCadastro ?? DateTime.now(),
      );

      if (widget.usuario != null) {
        context.read<UsuarioBloc>().add(UpdateUsuarioEvent(usuario));
      } else {
        context.read<UsuarioBloc>().add(CreateUsuarioEvent(usuario));
      }
    }
  }
}
