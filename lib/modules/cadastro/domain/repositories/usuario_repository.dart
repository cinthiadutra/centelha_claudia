import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/usuario.dart';

/// Interface do repositório de usuários (camada de domínio)
abstract class UsuarioRepository {
  Future<Either<Failure, List<Usuario>>> getUsuarios();
  Future<Either<Failure, Usuario>> getUsuarioById(String id);
  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario);
  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario);
  Future<Either<Failure, void>> deleteUsuario(String id);
}
