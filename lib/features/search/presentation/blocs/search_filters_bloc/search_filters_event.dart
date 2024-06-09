part of 'search_filters_bloc.dart';

sealed class SearchFiltersEvent extends Equatable {}

final class SearchFiltersSetShowMediaTypeFilterEvent extends SearchFiltersEvent {
  final ShowMediaTypeFilter showMediaTypeFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetShowMediaTypeFilterEvent({
    required this.showMediaTypeFilter,
    required this.prevFiltersModel,
  });

  @override
  List<Object?> get props => [
        showMediaTypeFilter,
        prevFiltersModel,
      ];
}

final class SearchFiltersSetSortByFilterEvent extends SearchFiltersEvent {
  final SortByFilter sortByFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetSortByFilterEvent({
    required this.sortByFilter,
    required this.prevFiltersModel,
  });

  @override
  List<Object?> get props => [
        sortByFilter,
        prevFiltersModel,
      ];
}

final class SearchFiltersSetRatingFilterEvent extends SearchFiltersEvent {
  final int ratingFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetRatingFilterEvent({
    required this.ratingFilter,
    required this.prevFiltersModel,
  });

  @override
  List<Object?> get props => [
        ratingFilter,
        prevFiltersModel,
      ];
}

final class SearchFiltersApplyFiltersEvent extends SearchFiltersEvent {
  @override
  List<Object?> get props => [];
}

final class SearchFiltersResetFiltersEvent extends SearchFiltersEvent {
  @override
  List<Object?> get props => [];
}

final class SearchFiltersRestoreFiltersEvent extends SearchFiltersEvent {
  @override
  List<Object?> get props => [];
}
