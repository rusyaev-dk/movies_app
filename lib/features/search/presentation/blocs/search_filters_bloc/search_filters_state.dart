part of 'search_filters_bloc.dart';

class SearchFiltersState {}

class SearchFiltersLoadingState extends SearchFiltersState {}

// class SearchFiltersInitialState extends SearchFiltersState {
//   late final SearchFiltersModel searchFilters;

//   SearchFiltersInitialState() : searchFilters = SearchFiltersModel();
// }

class SearchFiltersLoadedState extends SearchFiltersState {
  final SearchFiltersModel searchFiltersModel;

  SearchFiltersLoadedState({
    required this.searchFiltersModel,
  });

  SearchFiltersLoadedState copyWith({
    SearchFiltersModel? searchFiltersModel,
  }) {
    return SearchFiltersLoadedState(
      searchFiltersModel: searchFiltersModel ?? this.searchFiltersModel,
    );
  }
}

class SearchFiltersFailureState extends SearchFiltersState {
  final StorageRepositoryFailure failure;

  SearchFiltersFailureState({required this.failure});
}
