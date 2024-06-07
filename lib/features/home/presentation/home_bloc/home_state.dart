part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class HomeLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;
  final List<TVSeriesModel> onTheAirTVSeries;
  final List<PersonModel> popularPersons;

  HomeLoadedState({
    required this.popularMovies,
    required this.trendingMovies,
    required this.popularTVSeries,
    required this.trendingTVSeries,
    required this.onTheAirTVSeries,
    required this.popularPersons,
  });

  @override
  List<Object?> get props => [
        popularMovies,
        trendingMovies,
        popularTVSeries,
        trendingTVSeries,
        popularPersons,
        onTheAirTVSeries,
      ];
}

class HomeFailureState extends HomeState {
  final ApiRepositoryFailure failure;

  HomeFailureState({
    required this.failure,
  });
  
  @override
  List<Object?> get props => [failure];
}
