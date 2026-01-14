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
import 'modules/home/presentation/pages/home_page.dart';

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
        title: 'CLAUDIA',
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
      ),
    );
  }
}
