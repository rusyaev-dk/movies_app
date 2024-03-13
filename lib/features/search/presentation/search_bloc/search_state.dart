part of 'search_bloc.dart';

class SearchState {
  final String? query;
  final List<TMDBModel> searchModels;
  final bool isLoading;
  final ApiClientException? exception;

  SearchState({
    this.query,
    this.searchModels = const [],
    this.isLoading = false,
    this.exception,
  });

  SearchState copyWith({
    String? query,
    List<TMDBModel>? searchModels,
    bool? isLoading = false,
    ApiClientException? exception,
  }) {
    return SearchState(
      query: query,
      searchModels: searchModels ?? this.searchModels,
      isLoading: isLoading ?? this.isLoading,
      exception: exception,
    );
  }
}
