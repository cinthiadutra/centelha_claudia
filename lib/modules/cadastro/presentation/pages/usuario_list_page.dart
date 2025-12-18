import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/usuario_bloc.dart';
import '../bloc/usuario_event.dart';
import '../bloc/usuario_state.dart';
import 'usuario_form_page.dart';

class UsuarioListPage extends StatelessWidget {
  const UsuarioListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuários'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<UsuarioBloc, UsuarioState>(
        listener: (context, state) {
          if (state is UsuarioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UsuarioSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Recarrega a lista
            context.read<UsuarioBloc>().add(GetUsuariosEvent());
          }
        },
        builder: (context, state) {
          if (state is UsuarioInitial) {
            context.read<UsuarioBloc>().add(GetUsuariosEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsuarioLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsuariosLoaded) {
            if (state.usuarios.isEmpty) {
              return const Center(
                child: Text('Nenhum usuário cadastrado'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.usuarios.length,
              itemBuilder: (context, index) {
                final usuario = state.usuarios[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(usuario.nome[0].toUpperCase()),
                    ),
                    title: Text(usuario.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (usuario.email != null)
                          Text(usuario.email!),
                        if (usuario.telefoneCelular != null)
                          Text(usuario.telefoneCelular!),
                        if (usuario.numeroCadastro != null)
                          Text('N° ${usuario.numeroCadastro}', 
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<UsuarioBloc>(),
                                  child: UsuarioFormPage(usuario: usuario),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, usuario.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Estado desconhecido'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UsuarioBloc>(),
                child: const UsuarioFormPage(),
              ),
            ),
          );
        },
        label: const Text('Novo Usuário'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<UsuarioBloc>().add(DeleteUsuarioEvent(id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
