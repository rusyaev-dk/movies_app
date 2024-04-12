part of 'watchlist_bloc.dart';

class WatchlistState {}

class WatchlistLoadingState extends WatchlistState {}

class WatchlistLoadedState extends WatchlistState {
  final List<MovieModel> moviesWatchlist;
  final List<TVSeriesModel> tvSeriesWatchlist;

  WatchlistLoadedState({
    required this.moviesWatchlist,
    required this.tvSeriesWatchlist,
  });
}

class WatchlistFailureState extends WatchlistState {
  final ApiRepositoryFailure failure;

  WatchlistFailureState({required this.failure});
}
