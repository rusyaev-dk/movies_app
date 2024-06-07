part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {}

class WatchlistloadWatchlistEvent extends WatchlistEvent {
  WatchlistloadWatchlistEvent({
    this.locale = "en-US",
    this.page = 1,
    this.completer,
  });

  final String locale;
  final int page;
  final Completer? completer;

  @override
  List<Object?> get props => [
        page,
        locale,
      ];
}

class WatchlisrNetworkErrorEvent extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}
