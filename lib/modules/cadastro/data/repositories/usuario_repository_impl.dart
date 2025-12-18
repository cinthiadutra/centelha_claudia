import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_datasource.dart';
import '../models/usuario_model.dart';

/// Implementação do repositório de usuários
class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioDatasource datasource;

  UsuarioRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<Usuario>>> getUsuarios() async {
    try {
      final usuarios = await datasource.getUsuarios();
      return Either.right(usuarios);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar usuários: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> getUsuarioById(String id) async {
    try {
      final usuario = await datasource.getUsuarioById(id);
      return Either.right(usuario);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario) async {
    try {
      // Validação básica - apenas nome e CPF são obrigatórios
      if (usuario.nome.isEmpty) {
        return const Either.left(ValidationFailure('Nome é obrigatório'));
      }
      if (usuario.cpf.isEmpty) {
        return const Either.left(ValidationFailure('CPF é obrigatório'));
      }
      
      final model = UsuarioModel.fromEntity(usuario);
      final resultado = await datasource.createUsuario(model);
      return Either.right(resultado);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao criar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario) async {
    try {
      if (usuario.id == null || usuario.id!.isEmpty) {
        return const Either.left(ValidationFailure('ID do usuário é obrigatório'));
      }
      
      final model = UsuarioModel.fromEntity(usuario);
      final resultado = await datasource.updateUsuario(model);
      return Either.right(resultado);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao atualizar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUsuario(String id) async {
    try {
      await datasource.deleteUsuario(id);
      return const Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao deletar usuário: ${e.toString()}'));
    }
  }
}
