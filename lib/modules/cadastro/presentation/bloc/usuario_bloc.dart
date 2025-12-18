import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/usuario_repository.dart';
import 'usuario_event.dart';
import 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  final UsuarioRepository repository;

  UsuarioBloc({required this.repository}) : super(UsuarioInitial()) {
    on<GetUsuariosEvent>(_onGetUsuarios);
    on<GetUsuarioByIdEvent>(_onGetUsuarioById);
    on<CreateUsuarioEvent>(_onCreateUsuario);
    on<UpdateUsuarioEvent>(_onUpdateUsuario);
    on<DeleteUsuarioEvent>(_onDeleteUsuario);
  }

  Future<void> _onGetUsuarios(
    GetUsuariosEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(UsuarioLoading());
    
    final result = await repository.getUsuarios();
    
    result.fold(
      (failure) => emit(UsuarioError(failure.message)),
      (usuarios) => emit(UsuariosLoaded(usuarios)),
    );
  }

  Future<void> _onGetUsuarioById(
    GetUsuarioByIdEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(UsuarioLoading());
    
    final result = await repository.getUsuarioById(event.id);
    
    result.fold(
      (failure) => emit(UsuarioError(failure.message)),
      (usuario) => emit(UsuarioLoaded(usuario)),
    );
  }

  Future<void> _onCreateUsuario(
    CreateUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(UsuarioLoading());
    
    final result = await repository.createUsuario(event.usuario);
    
    result.fold(
      (failure) => emit(UsuarioError(failure.message)),
      (usuario) => emit(const UsuarioSuccess('Usuário criado com sucesso!')),
    );
  }

  Future<void> _onUpdateUsuario(
    UpdateUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(UsuarioLoading());
    
    final result = await repository.updateUsuario(event.usuario);
    
    result.fold(
      (failure) => emit(UsuarioError(failure.message)),
      (usuario) => emit(const UsuarioSuccess('Usuário atualizado com sucesso!')),
    );
  }

  Future<void> _onDeleteUsuario(
    DeleteUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(UsuarioLoading());
    
    final result = await repository.deleteUsuario(event.id);
    
    result.fold(
      (failure) => emit(UsuarioError(failure.message)),
      (success) => emit(const UsuarioSuccess('Usuário deletado com sucesso!')),
    );
  }
}
