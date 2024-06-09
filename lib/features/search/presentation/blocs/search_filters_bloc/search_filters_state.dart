part of 'search_filters_bloc.dart';

sealed class SearchFiltersState extends Equatable {}

final class SearchFiltersLoadingState extends SearchFiltersState {
  @override
  List<Object?> get props => [];
}

final class SearchFiltersLoadedState extends SearchFiltersState {
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
  
  @override
  List<Object?> get props => [searchFiltersModel];
}

final class SearchFiltersFailureState extends SearchFiltersState {
  final StorageRepositoryFailure failure;

  SearchFiltersFailureState({required this.failure});
  
  @override
  List<Object?> get props => [failure];
}
