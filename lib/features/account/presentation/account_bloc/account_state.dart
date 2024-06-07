part of 'account_bloc.dart';

abstract class AccountState extends Equatable {}

class AccountLoadingState extends AccountState {
  @override
  List<Object?> get props => [];
}

class AccountLoadedState extends AccountState {
  final AccountModel account;

  AccountLoadedState({required this.account});

  @override
  List<Object?> get props => [account];
}

class AccountFailureState extends AccountState {
  final ApiRepositoryFailure failure;

  AccountFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
