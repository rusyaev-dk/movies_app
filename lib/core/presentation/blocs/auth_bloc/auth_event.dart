part of 'auth_bloc.dart';

class AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({
    required this.login,
    required this.password,
  });
}

class AuthCheckStatusEvent extends AuthEvent {}
