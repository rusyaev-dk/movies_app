part of 'watchlist_bloc.dart';

sealed class WatchlistState extends Equatable {}

final class WatchlistLoadingState extends WatchlistState {
  @override
  List<Object?> get props => [];
}

final class WatchlistLoadedState extends WatchlistState {
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

final class WatchlistFailureState extends WatchlistState {
  final ApiRepositoryFailure failure;

  WatchlistFailureState({required this.failure});
  
  @override
  List<Object?> get props => [failure];
}
