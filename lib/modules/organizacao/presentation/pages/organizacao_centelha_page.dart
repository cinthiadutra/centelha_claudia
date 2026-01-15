import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'gerenciar_classificacoes_mediunicas_page.dart';
import 'gerenciar_dias_sessao_page.dart';
import 'gerenciar_grupos_page.dart';
import 'gerenciar_nucleos_page.dart';

/// Página principal para gerenciar a organização da Centelha
class OrganizacaoCentelhaPage extends StatelessWidget {
  const OrganizacaoCentelhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final nivelPermissao = state is AuthAuthenticated
            ? state.usuario.nivelAcesso.index + 1
            : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organização da Centelha'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context: context,
            icon: Icons.location_city,
            title: 'Núcleos',
            subtitle: 'Gerenciar núcleos (CCU, CPO, etc.)',
            onTap: () => Get.to(() => const GerenciarNucleosPage()),
          ),
          _buildCard(
            context: context,
            icon: Icons.calendar_today,
            title: 'Dias de Sessão',
            subtitle: 'Gerenciar dias e horários de sessões',
            onTap: () => Get.to(() => const GerenciarDiasSessaoPage()),
          ),
          _buildCard(
            context: context,
            icon: Icons.groups,
            title: 'Grupos-Tarefa',
            subtitle: 'Gerenciar grupos de trabalho',
            onTap: () => Get.to(() => const GerenciarGruposPage(tipo: 'grupo_tarefa')),
          ),
          _buildCard(
            context: context,
            icon: Icons.volunteer_activism,
            title: 'Grupos de Ação Social',
            subtitle: 'Gerenciar grupos de ação social',
            onTap: () => Get.to(() => const GerenciarGruposPage(tipo: 'acao_social')),
          ),
          _buildCard(
            context: context,
            icon: Icons.spa,
            title: 'Grupos de Trabalho Espiritual',
            subtitle: 'Gerenciar grupos espirituais',
            onTap: () => Get.to(() => const GerenciarGruposPage(tipo: 'trabalho_espiritual')),
          ),
          _buildCard(
            context: context,
            icon: Icons.auto_awesome,
            title: 'Classificações Mediúnicas',
            subtitle: 'Gerenciar graus e funções mediúnicas',
            onTap: () => Get.to(() => const GerenciarClassificacoesMediunicasPage()),
          ),
          if (nivelPermissao >= 4)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[900]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Você tem permissão de nível $nivelPermissao para excluir registros',
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
