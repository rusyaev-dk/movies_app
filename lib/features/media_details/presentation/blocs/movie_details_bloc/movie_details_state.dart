part of 'movie_details_bloc.dart';

class MovieDetailsState {}

class MovieDetailsLoadingState extends MovieDetailsState {}

class MovieDetailsLoadedState extends MovieDetailsState {
  final MovieModel movieModel;
  final List<MediaImageModel>? movieImages;
  final List<PersonModel>? movieCredits;

  MovieDetailsLoadedState({
    required this.movieModel,
    this.movieImages,
    this.movieCredits,
  });
}

class MovieDetailsFailureState extends MovieDetailsState {
  final RepositoryFailure failure;
  final int? movieId;

  MovieDetailsFailureState({
    required this.failure,
    this.movieId,
  });
}
