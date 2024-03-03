part of 'auth_view_bloc.dart';

class AuthViewState {}

class AuthViewFormFillInProgressState extends AuthViewState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewErrorState extends AuthViewState {
  final String errorMessage;

  AuthViewErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewInProgressState extends AuthViewState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewSuccessState extends AuthViewState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewSuccessState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
