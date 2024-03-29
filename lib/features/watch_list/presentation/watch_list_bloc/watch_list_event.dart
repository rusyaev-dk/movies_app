part of 'watch_list_bloc.dart';

class WatchListEvent {}

class WatchListLoadWatchListEvent extends WatchListEvent {
  final String locale;
  final int page;

  WatchListLoadWatchListEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class WatchListRefreshWatchListEvent extends WatchListEvent {
  final RefreshController refreshController;

  WatchListRefreshWatchListEvent({required this.refreshController});
}
