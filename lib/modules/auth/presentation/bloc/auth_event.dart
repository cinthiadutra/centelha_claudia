import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String login;
  final String senha;

  const LoginEvent({required this.login, required this.senha});

  @override
  List<Object?> get props => [login, senha];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
