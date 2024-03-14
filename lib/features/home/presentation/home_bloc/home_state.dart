part of 'home_bloc.dart';

class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;

  HomeLoadedState({
    this.popularMovies = const [],
    this.trendingMovies = const [],
    this.popularTVSeries = const [],
    this.trendingTVSeries = const [],
  });

  HomeLoadedState copyWith({
    List<MovieModel>? popularMovies,
    List<MovieModel>? trendingMovies,
    List<TVSeriesModel>? popularTVSeries,
    List<TVSeriesModel>? trendingTVSeries,
  }) {
    return HomeLoadedState(
      popularMovies: popularMovies ?? this.popularMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularTVSeries: popularTVSeries ?? this.popularTVSeries,
      trendingTVSeries: trendingTVSeries ?? this.trendingTVSeries,
    );
  }
}

class HomeFailureState extends HomeState {
  final ApiClientException? exception;

  HomeFailureState({
    required this.exception,
  });
}
