part of 'watchlist_bloc.dart';

class WatchlistEvent {}

class WatchlistloadWatchlistEvent extends WatchlistEvent {
  final String locale;
  final int page;

  WatchlistloadWatchlistEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class WatchlistRefreshWatchlistEvent extends WatchlistEvent {
  final RefreshController refreshController;

  WatchlistRefreshWatchlistEvent({required this.refreshController});
}

class WatchlisrNetworkErrorEvent extends WatchlistEvent {}
