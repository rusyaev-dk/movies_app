part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {}

final class MovieDetailsLoadDetailsEvent extends MovieDetailsEvent {
  final String locale;
  final int movieId;

  MovieDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.movieId,
  });

  @override
  List<Object?> get props => [
        locale,
        movieId,
      ];
}

final class MovieDetailsAddToFavouriteEvent extends MovieDetailsEvent {
  final int movieId;
  final bool isFavorite;

  MovieDetailsAddToFavouriteEvent({
    required this.movieId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
        movieId,
        isFavorite,
      ];
}

final class MovieDetailsAddToWatchlistEvent extends MovieDetailsEvent {
  final int movieId;
  final bool isInWatchlist;

  MovieDetailsAddToWatchlistEvent({
    required this.movieId,
    required this.isInWatchlist,
  });

  @override
  List<Object?> get props => [
        movieId,
        isInWatchlist,
      ];
}
