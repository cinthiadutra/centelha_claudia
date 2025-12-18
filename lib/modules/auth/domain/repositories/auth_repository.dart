import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/usuario_sistema.dart';

abstract class AuthRepository {
  Future<Either<Failure, UsuarioSistema>> login(String login, String senha);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UsuarioSistema?>> getUsuarioLogado();
}
