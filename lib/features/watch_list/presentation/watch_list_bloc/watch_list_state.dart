part of 'watch_list_bloc.dart';

class WatchListState {}

class WatchListLoadingState extends WatchListState {}

class WatchListLoadedState extends WatchListState {
  final List<MovieModel> moviesWatchList;
  final List<TVSeriesModel> tvSeriesWatchList;

  WatchListLoadedState({
    required this.moviesWatchList,
    required this.tvSeriesWatchList,
  });
}

class WatchListFailureState extends WatchListState {
  final RepositoryFailure failure;

  WatchListFailureState({required this.failure});
}
