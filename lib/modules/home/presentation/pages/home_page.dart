import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/navigation/app_menus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: Text('Não autenticado')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('CENTELHA CLAUDIA'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      state.usuario.nome,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        state.usuario.nivelAcessoDescricao,
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                tooltip: 'Sair',
              ),
            ],
          ),
          drawer: _AppDrawer(usuario: state.usuario),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.dashboard,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bem-vindo ao Sistema CENTELHA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use o menu lateral para navegar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final dynamic usuario;

  const _AppDrawer({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final menuItems = AppMenus.menuItems
        .where((item) => item.temPermissao(usuario.nivelAcesso))
        .toList();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                ),
                const SizedBox(height: 10),
                Text(
                  usuario.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  usuario.nivelAcessoDescricao,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) => _buildMenuItem(context, item)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair'),
            onTap: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    if (item.subItems != null && item.subItems!.isNotEmpty) {
      final filteredSubItems = item.subItems!
          .where((subItem) => subItem.temPermissao(usuario.nivelAcesso))
          .toList();

      if (filteredSubItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return ExpansionTile(
        leading: Icon(_getIconData(item.icon)),
        title: Text(
          item.title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        children: filteredSubItems
            .map((subItem) => ListTile(
                  leading: Icon(_getIconData(subItem.icon), size: 20),
                  title: Text(subItem.title, style: const TextStyle(fontSize: 13)),
                  contentPadding: const EdgeInsets.only(left: 70, right: 16),
                  onTap: () {
                    Navigator.pop(context);
                    if (subItem.route != null) {
                      _navigateToRoute(context, subItem.route!);
                    }
                  },
                ))
            .toList(),
      );
    }

    return ListTile(
      leading: Icon(_getIconData(item.icon)),
      title: Text(item.title, style: const TextStyle(fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        if (item.route != null) {
          _navigateToRoute(context, item.route!);
        }
      },
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'person_add': Icons.person_add,
      'add_circle': Icons.add_circle,
      'search': Icons.search,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'people': Icons.people,
      'person_search': Icons.person_search,
      'assessment': Icons.assessment,
      'history': Icons.history,
      'add': Icons.add,
      'visibility': Icons.visibility,
      'group_work': Icons.group_work,
      'manage_accounts': Icons.manage_accounts,
      'volunteer_activism': Icons.volunteer_activism,
      'psychology': Icons.psychology,
      'church': Icons.church,
      'water_drop': Icons.water_drop,
      'favorite': Icons.favorite,
      'casino': Icons.casino,
      'home': Icons.home,
      'star': Icons.star,
      'school': Icons.school,
      'class': Icons.class_,
      'assignment': Icons.assignment,
      'grade': Icons.grade,
      'admin_panel_settings': Icons.admin_panel_settings,
      'person_remove': Icons.person_remove,
      'analytics': Icons.analytics,
      'corporate_fare': Icons.corporate_fare,
      'add_business': Icons.add_business,
      'remove_circle': Icons.remove_circle,
      'event': Icons.event,
      'event_busy': Icons.event_busy,
      'remove': Icons.remove,
    };

    return iconMap[iconName] ?? Icons.circle;
  }

  void _navigateToRoute(BuildContext context, String route) {
    // Rotas implementadas para cadastro
    final routeMap = {
      '/cadastro/cadastrar': '/cadastrar',
      '/cadastro/pesquisar': '/pesquisar',
      '/cadastro/editar': '/editar',
      '/cadastro/excluir': '/excluir',
      '/membros/incluir': '/membros/incluir',
      '/membros/pesquisar': '/membros/pesquisar',
      '/membros/editar': '/membros/editar',
      '/membros/relatorios': '/membros/relatorios',
      '/consultas/nova': '/consultas/nova',
      '/consultas/pesquisar': '/consultas/pesquisar',
      '/consultas/ler': '/consultas/ler',
    };

    if (routeMap.containsKey(route)) {
      Get.toNamed(routeMap[route]!);
      return;
    }

    // Para outras rotas, mostra dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Página em Desenvolvimento'),
        content: Text('Rota: $route\n\nEm breve essa funcionalidade estará disponível.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
