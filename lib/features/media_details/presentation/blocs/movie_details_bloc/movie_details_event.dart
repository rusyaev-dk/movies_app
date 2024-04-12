part of 'movie_details_bloc.dart';

class MovieDetailsEvent {}

class MovieDetailsLoadDetailsEvent extends MovieDetailsEvent {
  final String locale;
  final int movieId;

  MovieDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.movieId,
  });
}

class MovieDetailsAddToFavouriteEvent extends MovieDetailsEvent {
  final int movieId;
  final bool isFavorite;

  MovieDetailsAddToFavouriteEvent({
    required this.movieId,
    required this.isFavorite,
  });
}

class MovieDetailsAddToWatchlistEvent extends MovieDetailsEvent {
  final int movieId;
  final bool isInWatchlist;

  MovieDetailsAddToWatchlistEvent({
    required this.movieId,
    required this.isInWatchlist,
  });
}
