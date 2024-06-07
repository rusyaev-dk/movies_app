part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class HomeLoadMediaEvent extends HomeEvent {
  final String locale;
  final int page;
  final Completer? completer;

  HomeLoadMediaEvent({
    this.locale = "en-US",
    this.page = 1,
    this.completer,
  });

  @override
  List<Object?> get props => [completer];
}

class HomeNetworkErrorEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
