part of 'auth_view_bloc.dart';

class AuthViewEvent {}

class AuthViewLoginEvent extends AuthViewEvent {
  final String login;

  AuthViewLoginEvent(this.login);
}

class AuthViewPasswordEvent extends AuthViewEvent {
  final String password;

  AuthViewPasswordEvent(this.password);
}

class AuthViewAuthEvent extends AuthViewEvent {}
