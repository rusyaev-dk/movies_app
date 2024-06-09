part of 'search_bloc.dart';

sealed class SearchState extends Equatable {}

final class SearchInitialState extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoadingState extends SearchState {
  final String? query;

  SearchLoadingState({required this.query});
  
  @override
  List<Object?> get props => [query];
}

final class SearchLoadedState extends SearchState {
  final List<TMDBModel> searchModels;

  SearchLoadedState({required this.searchModels});
  
  @override
  List<Object?> get props => [searchModels];
}

final class SearchFailureState extends SearchState {
  final ApiRepositoryFailure failure;
  final String? query;

  SearchFailureState({
    required this.failure,
    this.query,
  });
  
  @override
  List<Object?> get props => [failure];
}
