import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await repository.login(event.login, event.senha);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (usuario) => emit(AuthAuthenticated(usuario)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await repository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final result = await repository.getUsuarioLogado();

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (usuario) {
        if (usuario != null) {
          emit(AuthAuthenticated(usuario));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}
