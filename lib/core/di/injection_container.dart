import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../modules/auth/data/datasources/auth_datasource.dart';
import '../../modules/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/auth_repository.dart';
import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../modules/cadastro/data/datasources/usuario_datasource.dart';
import '../../modules/cadastro/data/repositories/usuario_repository_impl.dart';
import '../../modules/cadastro/domain/repositories/usuario_repository.dart';
import '../../modules/cadastro/presentation/bloc/usuario_bloc.dart';
import '../../modules/cadastro/presentation/controllers/cadastro_controller.dart';
import '../../modules/consultas/data/datasources/consulta_datasource.dart';
import '../../modules/consultas/data/repositories/consulta_repository.dart';
import '../../modules/consultas/presentation/controllers/consulta_controller.dart';
import '../../modules/membros/data/datasources/membro_datasource.dart';
import '../../modules/membros/data/repositories/membro_repository.dart';
import '../../modules/membros/presentation/controllers/membro_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ AUTH ============

  // Bloc
  sl.registerFactory(() => AuthBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<AuthDatasource>(() => AuthDatasourceMock());

  // ============ CADASTRO ============

  // Bloc
  sl.registerFactory(() => UsuarioBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<UsuarioDatasource>(() => UsuarioDatasourceMock());

  // ============ MEMBROS ============

  // Repository
  sl.registerLazySingleton<MembroRepository>(() => MembroRepositoryImpl(sl()));

  // Datasource
  sl.registerLazySingleton<MembroDatasource>(() => MembroDatasourceImpl());

  // ============ CONSULTAS ============

  // Repository
  sl.registerLazySingleton<ConsultaRepository>(
    () => ConsultaRepositoryImpl(sl()),
  );

  // Datasource
  sl.registerLazySingleton<ConsultaDatasource>(() => ConsultaDatasourceImpl());

  // ============ GETX CONTROLLERS ============
  // Registrar depois de todos os datasources e repositories

  Get.put(CadastroController(sl<UsuarioDatasource>()));
  Get.put(MembroController(sl<MembroRepository>()));
  Get.put(ConsultaController(sl<ConsultaRepository>()));
}
