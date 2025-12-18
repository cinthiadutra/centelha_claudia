import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/usuario_sistema.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, UsuarioSistema>> login(String login, String senha) async {
    try {
      if (login.isEmpty || senha.isEmpty) {
        return const Either.left(ValidationFailure('Login e senha são obrigatórios'));
      }

      final usuario = await datasource.login(login, senha);
      return Either.right(usuario);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await datasource.logout();
      return const Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UsuarioSistema?>> getUsuarioLogado() async {
    try {
      final usuario = await datasource.getUsuarioLogado();
      return Either.right(usuario);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
