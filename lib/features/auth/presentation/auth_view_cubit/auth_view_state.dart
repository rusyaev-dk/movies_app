part of 'auth_view_cubit.dart';

sealed class AuthViewState extends Equatable{}

final class AuthViewFormFillInProgressState extends AuthViewState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthViewFormFillInProgressState &&
  //         runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}

final class AuthViewErrorState extends AuthViewState {
  final String errorMessage;

  AuthViewErrorState(this.errorMessage);

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthViewErrorState &&
  //         runtimeType == other.runtimeType &&
  //         errorMessage == other.errorMessage;

  // @override
  // int get hashCode => errorMessage.hashCode;
  
  @override
  List<Object?> get props => [errorMessage];
}

final class AuthViewAuthInProgressState extends AuthViewState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthViewAuthInProgressState && runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}

final class AuthViewSuccessState extends AuthViewState {
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AuthViewSuccessState && runtimeType == other.runtimeType;

  // @override
  // int get hashCode => 0;
  
  @override
  List<Object?> get props => [];
}
