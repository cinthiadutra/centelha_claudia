import '../../modules/auth/domain/entities/usuario_sistema.dart';

class MenuItem {
  final String title;
  final String icon;
  final String? route;
  final List<MenuItem>? subItems;
  final NivelAcesso? nivelRequerido;

  const MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
    this.nivelRequerido,
  });

  bool temPermissao(NivelAcesso nivelUsuario) {
    if (nivelRequerido == null) return true;
    return nivelUsuario.index >= nivelRequerido!.index;
  }
}

class AppMenus {
  static final List<MenuItem> menuItems = [
    MenuItem(
      title: 'CADASTROS',
      icon: 'person_add',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Cadastrar',
          icon: 'add_circle',
          route: '/cadastros/cadastrar',
        ),
        const MenuItem(
          title: 'Pesquisar Cadastro',
          icon: 'search',
          route: '/cadastros/pesquisar',
        ),
        const MenuItem(
          title: 'Editar Cadastro',
          icon: 'edit',
          route: '/cadastros/editar',
        ),
        const MenuItem(
          title: 'Excluir Cadastro',
          icon: 'delete',
          route: '/cadastros/excluir',
          nivelRequerido: NivelAcesso.nivel3,
        ),
      ],
    ),
    MenuItem(
      title: 'MEMBROS DA CENTELHA',
      icon: 'people',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Incluir Novo Membro',
          icon: 'person_add',
          route: '/membros/incluir',
        ),
        const MenuItem(
          title: 'Pesquisar Dados de Membro',
          icon: 'person_search',
          route: '/membros/pesquisar',
        ),
        const MenuItem(
          title: 'Editar Dados de Membro',
          icon: 'edit',
          route: '/membros/editar',
        ),
        const MenuItem(
          title: 'Gerar Relatórios de Membros',
          icon: 'assessment',
          route: '/membros/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'HISTÓRICO DE CONSULTAS',
      icon: 'history',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Nova Consulta',
          icon: 'add',
          route: '/consultas/nova',
        ),
        const MenuItem(
          title: 'Pesquisar Consulta',
          icon: 'search',
          route: '/consultas/pesquisar',
        ),
        const MenuItem(
          title: 'Ler Consultas',
          icon: 'visibility',
          route: '/consultas/ler',
        ),
      ],
    ),
    MenuItem(
      title: 'GRUPOS-TAREFAS',
      icon: 'group_work',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Gerenciar Membros',
          icon: 'manage_accounts',
          route: '/grupos-tarefas/gerenciar',
        ),
        const MenuItem(
          title: 'Gerar Relatórios',
          icon: 'assessment',
          route: '/grupos-tarefas/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'GRUPOS DE AÇÕES SOCIAIS',
      icon: 'volunteer_activism',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Gerenciar Membros',
          icon: 'manage_accounts',
          route: '/grupos-acoes-sociais/gerenciar',
        ),
        const MenuItem(
          title: 'Gerar Relatórios',
          icon: 'assessment',
          route: '/grupos-acoes-sociais/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'GRUPOS DE TRABALHOS ESPIRITUAIS',
      icon: 'psychology',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Gerenciar Membros',
          icon: 'manage_accounts',
          route: '/grupos-trabalhos-espirituais/gerenciar',
        ),
        const MenuItem(
          title: 'Gerar Relatórios',
          icon: 'assessment',
          route: '/grupos-trabalhos-espirituais/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'SACRAMENTOS',
      icon: 'church',
      nivelRequerido: NivelAcesso.nivel3,
      subItems: [
        const MenuItem(
          title: 'Batismo',
          icon: 'water_drop',
          route: '/sacramentos/batismo',
        ),
        const MenuItem(
          title: 'Casamento',
          icon: 'favorite',
          route: '/sacramentos/casamento',
        ),
        const MenuItem(
          title: 'Jogo de Orixá',
          icon: 'casino',
          route: '/sacramentos/jogo-orixa',
        ),
        const MenuItem(
          title: 'Camarinhas',
          icon: 'home',
          route: '/sacramentos/camarinhas',
        ),
        const MenuItem(
          title: 'Coroação Sacerdotal',
          icon: 'star',
          route: '/sacramentos/coroacao',
        ),
        const MenuItem(
          title: 'Relatórios',
          icon: 'assessment',
          route: '/sacramentos/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'CURSOS E TREINAMENTOS',
      icon: 'school',
      nivelRequerido: NivelAcesso.nivel2,
      subItems: [
        const MenuItem(
          title: 'Criar Novo Curso',
          icon: 'add_circle',
          route: '/cursos/criar',
        ),
        const MenuItem(
          title: 'Abrir Nova Turma',
          icon: 'class',
          route: '/cursos/nova-turma',
        ),
        const MenuItem(
          title: 'Inscrição em Curso',
          icon: 'assignment',
          route: '/cursos/inscricao',
        ),
        const MenuItem(
          title: 'Lançar Notas',
          icon: 'grade',
          route: '/cursos/lancar-notas',
        ),
        const MenuItem(
          title: 'Relatórios de Cursos',
          icon: 'assessment',
          route: '/cursos/relatorios',
        ),
      ],
    ),
    MenuItem(
      title: 'USUÁRIOS DO SISTEMA',
      icon: 'admin_panel_settings',
      nivelRequerido: NivelAcesso.nivel4,
      subItems: [
        const MenuItem(
          title: 'Cadastrar Novo Usuário',
          icon: 'person_add',
          route: '/usuarios-sistema/cadastrar',
        ),
        const MenuItem(
          title: 'Excluir Usuário',
          icon: 'person_remove',
          route: '/usuarios-sistema/excluir',
        ),
        const MenuItem(
          title: 'Ver Usuários Cadastrados',
          icon: 'people',
          route: '/usuarios-sistema/listar',
        ),
        const MenuItem(
          title: 'Ver Acessos de Usuários',
          icon: 'analytics',
          route: '/usuarios-sistema/acessos',
        ),
      ],
    ),
    MenuItem(
      title: 'ORGANIZAÇÃO DA CENTELHA',
      icon: 'corporate_fare',
      nivelRequerido: NivelAcesso.nivel4,
      subItems: [
        const MenuItem(
          title: 'Incluir Núcleo',
          icon: 'add_business',
          route: '/organizacao/incluir-nucleo',
        ),
        const MenuItem(
          title: 'Excluir Núcleo',
          icon: 'remove_circle',
          route: '/organizacao/excluir-nucleo',
        ),
        const MenuItem(
          title: 'Incluir Dia de Sessão',
          icon: 'event',
          route: '/organizacao/incluir-dia-sessao',
        ),
        const MenuItem(
          title: 'Excluir Dia de Sessão',
          icon: 'event_busy',
          route: '/organizacao/excluir-dia-sessao',
        ),
        const MenuItem(
          title: 'Incluir Grupo-Tarefa',
          icon: 'add',
          route: '/organizacao/incluir-grupo-tarefa',
        ),
        const MenuItem(
          title: 'Excluir Grupo-Tarefa',
          icon: 'remove',
          route: '/organizacao/excluir-grupo-tarefa',
        ),
        const MenuItem(
          title: 'Incluir Grupo de Ação Social',
          icon: 'add',
          route: '/organizacao/incluir-grupo-acao-social',
        ),
        const MenuItem(
          title: 'Excluir Grupo de Ação Social',
          icon: 'remove',
          route: '/organizacao/excluir-grupo-acao-social',
        ),
        const MenuItem(
          title: 'Incluir Grupo de Trabalho Espiritual',
          icon: 'add',
          route: '/organizacao/incluir-grupo-trabalho-espiritual',
        ),
        const MenuItem(
          title: 'Excluir Grupo de Trabalho Espiritual',
          icon: 'remove',
          route: '/organizacao/excluir-grupo-trabalho-espiritual',
        ),
      ],
    ),
  ];
}
