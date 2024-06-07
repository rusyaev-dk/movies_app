part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {}

class AccountLoadAccountDetailsEvent extends AccountEvent {
  AccountLoadAccountDetailsEvent({this.completer});

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class AccountNetworkErrorEvent extends AccountEvent {
  @override
  List<Object?> get props => [];
}
