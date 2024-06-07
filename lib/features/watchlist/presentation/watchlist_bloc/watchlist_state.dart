part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {}

class WatchlistLoadingState extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistLoadedState extends WatchlistState {
  final List<MovieModel> moviesWatchlist;
  final List<TVSeriesModel> tvSeriesWatchlist;

  WatchlistLoadedState({
    required this.moviesWatchlist,
    required this.tvSeriesWatchlist,
  });

  @override
  List<Object?> get props => [
        moviesWatchlist,
        tvSeriesWatchlist,
      ];
}

class WatchlistFailureState extends WatchlistState {
  final ApiRepositoryFailure failure;

  WatchlistFailureState({required this.failure});
  
  @override
  List<Object?> get props => [failure];
}
