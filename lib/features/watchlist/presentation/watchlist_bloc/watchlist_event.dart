part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {}

final class WatchlistloadWatchlistEvent extends WatchlistEvent {
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

final class WatchlisrNetworkErrorEvent extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}
