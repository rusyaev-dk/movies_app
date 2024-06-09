part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

final class AuthUnauthorizedState extends AuthState {
  // @override
  // bool operator ==(Object other) =>
  //     other is AuthAuthorizedState && runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}

final class AuthAuthorizedState extends AuthState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthAuthorizedState && runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}

final class AuthFailureState extends AuthState {
  final Object error;

  AuthFailureState(this.error);

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthFailureState &&
  //         runtimeType == other.runtimeType &&
  //         error == other.error;

  // @override
  // int get hashCode => error.hashCode;
  
  @override
  List<Object?> get props => [error];
}

final class AuthInProgressState extends AuthState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthInProgressState && runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}

final class AuthStatusCheckInProgressState extends AuthState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthStatusCheckInProgressState &&
  //         runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}
