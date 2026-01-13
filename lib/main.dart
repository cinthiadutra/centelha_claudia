import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'core/di/auth_bloc_binding.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/auth/presentation/bloc/auth_event.dart';
import 'modules/auth/presentation/bloc/auth_state.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/cadastro/presentation/pages/cadastrar_page.dart';
import 'modules/cadastro/presentation/pages/editar_page.dart';
import 'modules/cadastro/presentation/pages/excluir_page.dart';
import 'modules/cadastro/presentation/pages/importar_excel_page.dart';
import 'modules/cadastro/presentation/pages/pesquisar_page.dart';
import 'modules/consultas/presentation/pages/ler_consulta_page.dart';
import 'modules/consultas/presentation/pages/nova_consulta_page.dart';
import 'modules/consultas/presentation/pages/pesquisar_consulta_page.dart';
import 'modules/grupos_acoes_sociais/presentation/pages/gerenciar_grupo_acao_social_page.dart';
import 'modules/grupos_acoes_sociais/presentation/pages/relatorios_grupo_acao_social_page.dart';
import 'modules/grupos_tarefas/presentation/pages/gerenciar_grupo_tarefa_page.dart';
import 'modules/grupos_tarefas/presentation/pages/relatorios_grupo_tarefa_page.dart';
import 'modules/grupos_trabalhos_espirituais/presentation/pages/gerenciar_grupo_trabalho_espiritual_page.dart';
import 'modules/grupos_trabalhos_espirituais/presentation/pages/relatorios_grupo_trabalho_espiritual_page.dart';
import 'modules/home/presentation/pages/home_page.dart';
import 'modules/membros/presentation/pages/editar_membro_page.dart';
import 'modules/membros/presentation/pages/incluir_membro_page.dart';
import 'modules/membros/presentation/pages/pesquisar_membro_page.dart';
import 'modules/membros/presentation/pages/relatorios_membro_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_organizacao_page.dart';
import 'modules/usuarios_sistema/presentation/pages/gerenciar_usuario_sistema_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseService.initialize();

  await di.init();
  AuthBlocBinding.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
      child: GetMaterialApp(
        title: 'Centelha Divina',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
        // Rotas GetX
        getPages: [
          GetPage(name: '/cadastrar', page: () => const CadastrarPage()),
          GetPage(name: '/pesquisar', page: () => const PesquisarPage()),
          GetPage(name: '/editar', page: () => const EditarPage()),
          GetPage(name: '/excluir', page: () => const ExcluirPage()),
          GetPage(
            name: '/importar-excel',
            page: () => const ImportarExcelPage(),
          ),

          // Membros
          GetPage(
            name: '/membros/incluir',
            page: () => const IncluirMembroPage(),
          ),
          GetPage(
            name: '/membros/pesquisar',
            page: () => const PesquisarMembroPage(),
          ),
          GetPage(
            name: '/membros/editar',
            page: () => const EditarMembroPage(),
          ),
          GetPage(
            name: '/membros/relatorios',
            page: () => const RelatoriosMembroPage(),
          ),

          // Consultas
          GetPage(
            name: '/consultas/nova',
            page: () => const NovaConsultaPage(),
          ),
          GetPage(
            name: '/consultas/pesquisar',
            page: () => const PesquisarConsultaPage(),
          ),
          GetPage(name: '/consultas/ler', page: () => const LerConsultaPage()),

          // Grupos Tarefas
          GetPage(
            name: '/grupos-tarefas/gerenciar',
            page: () => const GerenciarGrupoTarefaPage(),
          ),
          GetPage(
            name: '/grupos-tarefas/relatorios',
            page: () => const RelatoriosGrupoTarefaPage(),
          ),

          // Grupos Ações Sociais
          GetPage(
            name: '/grupos-acoes-sociais/gerenciar',
            page: () => const GerenciarGrupoAcaoSocialPage(),
          ),
          GetPage(
            name: '/grupos-acoes-sociais/relatorios',
            page: () => const RelatoriosGrupoAcaoSocialPage(),
          ),

          // Grupos Trabalhos Espirituais
          GetPage(
            name: '/grupos-trabalhos-espirituais/gerenciar',
            page: () => const GerenciarGrupoTrabalhoEspiritualPage(),
          ),
          GetPage(
            name: '/grupos-trabalhos-espirituais/relatorios',
            page: () => const RelatoriosGrupoTrabalhoEspiritualPage(),
          ),

          // Usuários Sistema
          GetPage(
            name: '/usuarios-sistema/cadastrar',
            page: () => const GerenciarUsuarioSistemaPage(),
          ),
          GetPage(
            name: '/usuarios-sistema/listar',
            page: () => const GerenciarUsuarioSistemaPage(),
          ),

          // Organização
          GetPage(
            name: '/organizacao/gerenciar',
            page: () => const GerenciarOrganizacaoPage(),
          ),
        ],
      ),
    );
  }
}
