part of 'tmdb_media_bloc.dart';

class TMDBMediaState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;

  TMDBMediaState({
    this.popularMovies = const [],
    this.trendingMovies = const [],
  });

  TMDBMediaState copyWith({
    List<MovieModel>? popularMovies,
    List<MovieModel>? trendingMovies,
  }) {
    return TMDBMediaState(
      popularMovies: popularMovies ?? this.popularMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
    );
  }
}
