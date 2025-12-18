import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario.dart';

/// Eventos do Bloc de Usuários
abstract class UsuarioEvent extends Equatable {
  const UsuarioEvent();

  @override
  List<Object?> get props => [];
}

class GetUsuariosEvent extends UsuarioEvent {}

class GetUsuarioByIdEvent extends UsuarioEvent {
  final String id;

  const GetUsuarioByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateUsuarioEvent extends UsuarioEvent {
  final Usuario usuario;

  const CreateUsuarioEvent(this.usuario);

  @override
  List<Object?> get props => [usuario];
}

class UpdateUsuarioEvent extends UsuarioEvent {
  final Usuario usuario;

  const UpdateUsuarioEvent(this.usuario);

  @override
  List<Object?> get props => [usuario];
}

class DeleteUsuarioEvent extends UsuarioEvent {
  final String id;

  const DeleteUsuarioEvent(this.id);

  @override
  List<Object?> get props => [id];
}
