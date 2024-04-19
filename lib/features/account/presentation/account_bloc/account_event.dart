part of 'account_bloc.dart';

class AccountEvent {}

class AccountLoadAccountDetailsEvent extends AccountEvent {}

class AccountRefreshAccountDetailsEvent extends AccountEvent {
  final RefreshController refreshController;

  AccountRefreshAccountDetailsEvent({required this.refreshController});
}

class AccountNetworkErrorEvent extends AccountEvent {}
