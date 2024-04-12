part of 'movie_details_bloc.dart';

class MovieDetailsState {
  final MovieModel? movieModel;
  final bool? isFavourite;
  final bool? isInWatchlist;
  final List<MediaImageModel>? movieImages;
  final List<PersonModel>? movieCredits;
  final List<MovieModel>? similarMovies;
  final ApiRepositoryFailure? failure;
  final int? movieId;
  final bool isLoading;

  MovieDetailsState({
    this.movieModel,
    this.isFavourite,
    this.isInWatchlist,
    this.movieImages,
    this.movieCredits,
    this.similarMovies,
    this.failure,
    this.movieId,
    this.isLoading = false,
  });

  MovieDetailsState copyWith({
    MovieModel? movieModel,
    bool? isFavourite,
    bool? isInWatchlist,
    List<MediaImageModel>? movieImages,
    List<PersonModel>? movieCredits,
    List<MovieModel>? similarMovies,
    ApiRepositoryFailure? failure,
    int? movieId,
    bool? isLoading = false,
  }) {
    return MovieDetailsState(
      movieModel: movieModel ?? this.movieModel,
      isFavourite: isFavourite ?? this.isFavourite,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      movieImages: movieImages ?? this.movieImages,
      movieCredits: movieCredits ?? this.movieCredits,
      similarMovies: similarMovies ?? this.similarMovies,
      failure: failure ?? this.failure,
      movieId: movieId ?? this.movieId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
