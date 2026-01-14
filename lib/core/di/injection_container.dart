import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../modules/auth/data/datasources/auth_datasource.dart';
import '../../modules/auth/data/datasources/auth_supabase_datasource.dart';
import '../../modules/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/auth_repository.dart';
import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../modules/cadastro/data/datasources/usuario_datasource.dart';
import '../../modules/cadastro/data/datasources/usuario_supabase_datasource.dart';
import '../../modules/cadastro/data/repositories/usuario_repository_impl.dart';
import '../../modules/cadastro/domain/repositories/usuario_repository.dart';
import '../../modules/cadastro/presentation/bloc/usuario_bloc.dart';
import '../../modules/cadastro/presentation/controllers/cadastro_controller.dart';
import '../../modules/consultas/data/datasources/consulta_datasource.dart';
import '../../modules/consultas/data/repositories/consulta_repository.dart';
import '../../modules/consultas/presentation/controllers/consulta_controller.dart';
import '../../modules/grupos_acoes_sociais/data/datasources/grupo_acao_social_datasource.dart';
import '../../modules/grupos_acoes_sociais/data/repositories/grupo_acao_social_repository.dart';
import '../../modules/grupos_acoes_sociais/presentation/controllers/grupo_acao_social_controller.dart';
import '../../modules/grupos_tarefas/data/datasources/grupo_tarefa_datasource.dart';
import '../../modules/grupos_tarefas/data/repositories/grupo_tarefa_repository.dart';
import '../../modules/grupos_tarefas/presentation/controllers/grupo_tarefa_controller.dart';
import '../../modules/grupos_trabalhos_espirituais/data/datasources/grupo_trabalho_espiritual_datasource.dart';
import '../../modules/grupos_trabalhos_espirituais/data/repositories/grupo_trabalho_espiritual_repository.dart';
import '../../modules/grupos_trabalhos_espirituais/presentation/controllers/grupo_trabalho_espiritual_controller.dart';
import '../../modules/membros/data/datasources/membro_datasource.dart';
import '../../modules/membros/data/datasources/membro_supabase_datasource.dart';
import '../../modules/membros/data/repositories/membro_repository.dart';
import '../../modules/membros/presentation/controllers/membro_controller.dart';
import '../../modules/usuarios_sistema/data/datasources/usuario_sistema_datasource.dart';
import '../../modules/usuarios_sistema/data/repositories/usuario_sistema_repository.dart';
import '../../modules/usuarios_sistema/presentation/controllers/usuario_sistema_controller.dart';
import '../services/supabase_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ CORE SERVICES ============

  // Supabase Service
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

  // ============ AUTH ============

  // Bloc
  sl.registerFactory(() => AuthBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(datasource: sl()),
  );

  // Datasource - SUPABASE (substituiu Mock)
  sl.registerLazySingleton<AuthDatasource>(() => AuthSupabaseDatasource(sl()));

  // ============ CADASTRO ============

  // Bloc
  sl.registerFactory(() => UsuarioBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(datasource: sl()),
  );

  // Datasource - SUPABASE (substituiu Mock)
  sl.registerLazySingleton<UsuarioDatasource>(
    () => UsuarioSupabaseDatasource(sl()),
  );

  // ============ MEMBROS ============

  // Repository
  sl.registerLazySingleton<MembroRepository>(() => MembroRepositoryImpl(sl()));

  // Datasource - SUPABASE (substituiu Mock)
  sl.registerLazySingleton<MembroDatasource>(
    () => MembroSupabaseDatasource(sl()),
  );

  // ============ CONSULTAS ============

  // Repository
  sl.registerLazySingleton<ConsultaRepository>(
    () => ConsultaRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<ConsultaDatasource>(() => ConsultaDatasourceImpl());

  // ============ GRUPOS TAREFAS ============

  // Repository
  sl.registerLazySingleton<GrupoTarefaRepository>(
    () => GrupoTarefaRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<GrupoTarefaDatasource>(
    () => GrupoTarefaDatasourceImpl(),
  );

  // ============ GRUPOS AÇÕES SOCIAIS ============

  // Repository
  sl.registerLazySingleton<GrupoAcaoSocialRepository>(
    () => GrupoAcaoSocialRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<GrupoAcaoSocialDatasource>(
    () => GrupoAcaoSocialDatasourceImpl(),
  );

  // ============ GRUPOS TRABALHOS ESPIRITUAIS ============

  // Repository
  sl.registerLazySingleton<GrupoTrabalhoEspiritualRepository>(
    () => GrupoTrabalhoEspiritualRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<GrupoTrabalhoEspiritualDatasource>(
    () => GrupoTrabalhoEspiritualDatasourceImpl(),
  );

  // ============ USUÁRIOS SISTEMA ============

  // Repository
  sl.registerLazySingleton<UsuarioSistemaRepository>(
    () => UsuarioSistemaRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<UsuarioSistemaDatasource>(
    () => UsuarioSistemaDatasourceImpl(),
  );

  // ============ GETX CONTROLLERS ============
  // Registrar depois de todos os datasources e repositories

  Get.put(CadastroController(sl<UsuarioDatasource>()));
  Get.put(MembroController(sl<MembroRepository>()));
  Get.put(ConsultaController(sl<ConsultaRepository>()));
  Get.put(GrupoTarefaController(sl<GrupoTarefaRepository>()));
  Get.put(GrupoAcaoSocialController(sl<GrupoAcaoSocialRepository>()));
  Get.put(
    GrupoTrabalhoEspiritualController(sl<GrupoTrabalhoEspiritualRepository>()),
  );
  Get.put(UsuarioSistemaController(sl<UsuarioSistemaRepository>()));
}
