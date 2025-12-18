import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario.dart';

/// Estados do Bloc de Usuários
abstract class UsuarioState extends Equatable {
  const UsuarioState();

  @override
  List<Object?> get props => [];
}

class UsuarioInitial extends UsuarioState {}

class UsuarioLoading extends UsuarioState {}

class UsuariosLoaded extends UsuarioState {
  final List<Usuario> usuarios;

  const UsuariosLoaded(this.usuarios);

  @override
  List<Object?> get props => [usuarios];
}

class UsuarioLoaded extends UsuarioState {
  final Usuario usuario;

  const UsuarioLoaded(this.usuario);

  @override
  List<Object?> get props => [usuario];
}

class UsuarioSuccess extends UsuarioState {
  final String message;

  const UsuarioSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UsuarioError extends UsuarioState {
  final String message;

  const UsuarioError(this.message);

  @override
  List<Object?> get props => [message];
}
