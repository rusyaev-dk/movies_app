part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {}

final class AuthCheckStatusEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

final class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [
        login,
        password,
      ];
}

final class AuthLogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
