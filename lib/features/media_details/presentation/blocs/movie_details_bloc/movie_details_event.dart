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

// class MovieDetailsAddFavouriteEvent extends MovieDetailsEvent {
//   final int movieId;
//   final bool isFavorite;

//   MovieDetailsAddFavouriteEvent({
//     required this.movieId,
//     required this.isFavorite,
//   });
// }
