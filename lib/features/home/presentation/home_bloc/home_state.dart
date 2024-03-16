part of 'home_bloc.dart';

class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;

  HomeLoadedState({
    required this.popularMovies,
    required this.trendingMovies,
    required this.popularTVSeries,
    required this.trendingTVSeries,
  });
}

class HomeFailureState extends HomeState {
  final RepositoryFailure failure;

  HomeFailureState({
    required this.failure,
  });
}
