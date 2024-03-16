part of 'search_bloc.dart';

class SearchState {}

class SearchLoadingState extends SearchState {
  final String? query;

  SearchLoadingState({required this.query});
}

class SearchLoadedState extends SearchState {
  final List<TMDBModel> searchModels;

  SearchLoadedState({required this.searchModels});
}

class SearchFailureState extends SearchState {
  final RepositoryFailure failure;
  final String? query;

  SearchFailureState({
    required this.failure,
    this.query,
  });
}
