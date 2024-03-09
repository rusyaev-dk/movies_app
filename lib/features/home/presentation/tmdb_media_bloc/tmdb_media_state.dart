part of 'tmdb_media_bloc.dart';

class TMDBMediaState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;
  final bool isLoading;

  TMDBMediaState({
    this.popularMovies = const [],
    this.trendingMovies = const [],
    this.popularTVSeries = const [],
    this.trendingTVSeries = const [],
    this.isLoading = false,
  });

  TMDBMediaState copyWith({
    List<MovieModel>? popularMovies,
    List<MovieModel>? trendingMovies,
    List<TVSeriesModel>? popularTVSeries,
    List<TVSeriesModel>? trendingTVSeries,
    bool isLoading = false,
  }) {
    return TMDBMediaState(
      popularMovies: popularMovies ?? this.popularMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularTVSeries: popularTVSeries ?? this.popularTVSeries,
      trendingTVSeries: trendingTVSeries ?? this.trendingTVSeries,
      isLoading: isLoading,
    );
  }
}
