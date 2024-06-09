part of 'account_bloc.dart';

sealed class AccountState extends Equatable {}

final class AccountLoadingState extends AccountState {
  @override
  List<Object?> get props => [];
}

final class AccountLoadedState extends AccountState {
  final AccountModel account;

  AccountLoadedState({required this.account});

  @override
  List<Object?> get props => [account];
}

final class AccountFailureState extends AccountState {
  final ApiRepositoryFailure failure;

  AccountFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
