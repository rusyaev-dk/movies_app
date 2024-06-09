part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {}

final class AccountLoadAccountDetailsEvent extends AccountEvent {
  AccountLoadAccountDetailsEvent({this.completer});

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

final class AccountNetworkErrorEvent extends AccountEvent {
  @override
  List<Object?> get props => [];
}
