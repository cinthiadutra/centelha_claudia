import 'package:get/get.dart';
import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart' as di;

/// Classe que conecta Get.find com GetIt para o AuthBloc
class AuthBlocBinding {
  static void init() {
    // Registra o AuthBloc no GetX
    Get.put<AuthBloc>(di.sl<AuthBloc>());
  }
}
