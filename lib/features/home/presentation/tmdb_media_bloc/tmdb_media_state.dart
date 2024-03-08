part of 'tmdb_media_bloc.dart';

class TMDBMediaState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final bool isLoading;

  TMDBMediaState({
    this.popularMovies = const [],
    this.trendingMovies = const [],
    this.isLoading = false,
  });

  TMDBMediaState copyWith({
    List<MovieModel>? popularMovies,
    List<MovieModel>? trendingMovies,
    bool isLoading = false,
  }) {
    return TMDBMediaState(
      popularMovies: popularMovies ?? this.popularMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      isLoading: isLoading,
    );
  }
}
