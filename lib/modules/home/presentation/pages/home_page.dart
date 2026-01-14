import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/navigation/app_menus.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(body: Center(child: Text('Não autenticado')));
        }

        return Scaffold(
          body: Row(
            children: [
              // Menu lateral fixo
              _AppDrawer(usuario: state.usuario),
              // Área principal
              Expanded(
                child: Column(
                  children: [
                    // Header superior
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'CENTRAL LÓGICA DE ATENDIMENTO UNIFICADO E DE DISPONIBILIZAÇÃO DE INFORMAÇÕES ADMINISTRATIVAS - CLAUDIA',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Text(
                            state.usuario.nome,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              state.usuario.nivelAcessoDescricao,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.grey),
                            onPressed: () {
                              context.read<AuthBloc>().add(LogoutEvent());
                            },
                            tooltip: 'Sair',
                          ),
                        ],
                      ),
                    ),
                    // Conteúdo principal
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade50,
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo
                                Image.asset(
                                  'assets/images/centelha_new.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  'Centelha Divina',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD81B60),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Sistema de Gestão CENTELHA',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Bem-vindo ao sistema de gestão completo da\nCentelha Divina.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Organize e gerencie cadastros, membros, consultas e\natividades de forma eficiente e respeitosa.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 48),
                                // Features
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFeature(
                                        'Gestão completa de cadastros e membros',
                                      ),
                                      _buildFeature(
                                        'Controle de grupos e atividades',
                                      ),
                                      _buildFeature(
                                        'Gestão de consultas em tempo real',
                                      ),
                                      _buildFeature(
                                        'Sacramentos e trabalhos espirituais',
                                      ),
                                      _buildFeature(
                                        'Relatórios e estatísticas',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 48),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navega para primeira opção disponível
                                    Get.toNamed('/cadastrar');
                                  },
                                  icon: const Icon(Icons.play_circle_outline),
                                  label: const Text('Iniciar Trabalho'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 48,
                                      vertical: 20,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'Sistema desenvolvido com respeito e dedicação às práticas espirituais',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 16, color: Colors.green.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
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

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/centelha_new.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildSimpleMenuItem(
                  context,
                  icon: Icons.home,
                  title: 'Início',
                  isSelected: true,
                  onTap: () {},
                ),
                ...menuItems.map((item) => _buildMenuItem(context, item)),
              ],
            ),
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

      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            _getIconData(item.icon),
            size: 20,
            color: Colors.grey.shade700,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          childrenPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: VisualDensity.compact,
          children: filteredSubItems
              .map(
                (subItem) => Container(
                  margin: const EdgeInsets.only(bottom: 2, left: 8),
                  child: ListTile(
                    leading: Icon(
                      _getIconData(subItem.icon),
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    title: Text(
                      subItem.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 40, right: 12),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    onTap: () {
                      if (subItem.route != null) {
                        _navigateToRoute(context, subItem.route!);
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          _getIconData(item.icon),
          size: 20,
          color: Colors.grey.shade700,
        ),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () {
          if (item.route != null) {
            _navigateToRoute(context, item.route!);
          }
        },
      ),
    );
  }

  Widget _buildSimpleMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade600 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : Colors.grey.shade700,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
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
      'cloud_upload': Icons.cloud_upload,
      'leaderboard': Icons.leaderboard,
      'description': Icons.description,
      'cloud_download': Icons.cloud_download,
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
    // Rotas implementadas mapeadas
    final routeMap = {
      // Cadastros
      '/cadastros/cadastrar': '/cadastrar',
      '/cadastros/pesquisar': '/pesquisar',
      '/cadastros/editar': '/editar',
      '/cadastros/excluir': '/excluir',
      '/importar-pessoas-antigas': '/importar-pessoas-antigas',

      // Membros
      '/membros/incluir': '/membros/incluir',
      '/membros/pesquisar': '/membros/pesquisar',
      '/membros/editar': '/membros/editar',
      '/membros/importar-antigos': '/membros/importar-antigos',
      '/membros/relatorios': '/membros/relatorios',

      // Consultas
      '/consultas/nova': '/consultas/nova',
      '/consultas/pesquisar': '/consultas/pesquisar',
      '/consultas/ler': '/consultas/ler',

      // Grupos Tarefas
      '/grupos-tarefas/gerenciar': '/grupos-tarefas/gerenciar',
      '/grupos-tarefas/relatorios': '/grupos-tarefas/relatorios',

      // Grupos Ações Sociais
      '/grupos-acoes-sociais/gerenciar': '/grupos-acoes-sociais/gerenciar',
      '/grupos-acoes-sociais/relatorios': '/grupos-acoes-sociais/relatorios',

      // Grupos Trabalhos Espirituais
      '/grupos-trabalhos-espirituais/gerenciar':
          '/grupos-trabalhos-espirituais/gerenciar',
      '/grupos-trabalhos-espirituais/relatorios':
          '/grupos-trabalhos-espirituais/relatorios',

      // Sistema de Ponto
      '/sistema-ponto/importar-calendario':
          '/sistema-ponto/importar-calendario',

      // Usuários Sistema
      '/usuarios-sistema/cadastrar': '/usuarios-sistema/cadastrar',
      '/usuarios-sistema/listar': '/usuarios-sistema/listar',

      // Organização
      '/organizacao/incluir-nucleo': '/organizacao/gerenciar',
      '/organizacao/excluir-nucleo': '/organizacao/gerenciar',
      '/organizacao/incluir-dia-sessao': '/organizacao/gerenciar',
      '/organizacao/excluir-dia-sessao': '/organizacao/gerenciar',
      '/organizacao/incluir-grupo-tarefa': '/organizacao/gerenciar',
      '/organizacao/excluir-grupo-tarefa': '/organizacao/gerenciar',
      '/organizacao/incluir-grupo-acao-social': '/organizacao/gerenciar',
      '/organizacao/excluir-grupo-acao-social': '/organizacao/gerenciar',
      '/organizacao/incluir-grupo-trabalho-espiritual':
          '/organizacao/gerenciar',
      '/organizacao/excluir-grupo-trabalho-espiritual':
          '/organizacao/gerenciar',
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
        content: Text(
          'Rota: $route\n\nEm breve essa funcionalidade estará disponível.',
        ),
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
