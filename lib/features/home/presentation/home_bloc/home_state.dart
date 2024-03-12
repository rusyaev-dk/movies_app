part of 'home_bloc.dart';

class HomeState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;
  final bool isLoading;
  final ApiClientException? exception;

  HomeState({
    this.popularMovies = const [],
    this.trendingMovies = const [],
    this.popularTVSeries = const [],
    this.trendingTVSeries = const [],
    this.isLoading = false,
    this.exception,
  });

  HomeState copyWith({
    List<MovieModel>? popularMovies,
    List<MovieModel>? trendingMovies,
    List<TVSeriesModel>? popularTVSeries,
    List<TVSeriesModel>? trendingTVSeries,
    bool isLoading = false,
    ApiClientException? exception,
  }) {
    return HomeState(
      popularMovies: popularMovies ?? this.popularMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularTVSeries: popularTVSeries ?? this.popularTVSeries,
      trendingTVSeries: trendingTVSeries ?? this.trendingTVSeries,
      isLoading: isLoading,
      exception: exception,
    );
  }
}
