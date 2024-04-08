part of 'account_bloc.dart';

class AccountState {}

class AccountLoadingState extends AccountState {}

class AccountLoadedState extends AccountState {
  final AccountModel account;

  AccountLoadedState({required this.account});
}

class AccountFailureState extends AccountState {
  final ApiRepositoryFailure failure;

  AccountFailureState({required this.failure});
}
