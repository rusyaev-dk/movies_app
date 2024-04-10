part of 'search_filters_bloc.dart';

class SearchFiltersEvent {}

class SearchFiltersSetShowMediaTypeFilterEvent extends SearchFiltersEvent {
  final ShowMediaTypeFilter showMediaTypeFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetShowMediaTypeFilterEvent({
    required this.showMediaTypeFilter,
    required this.prevFiltersModel,
  });
}

class SearchFiltersSetSortByFilterEvent extends SearchFiltersEvent {
  final SortByFilter sortByFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetSortByFilterEvent({
    required this.sortByFilter,
    required this.prevFiltersModel,
  });
}

class SearchFiltersSetRatingFilterEvent extends SearchFiltersEvent {
  final int ratingFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetRatingFilterEvent({
    required this.ratingFilter,
    required this.prevFiltersModel,
  });
}

class SearchFiltersApplyFiltersEvent extends SearchFiltersEvent {}

class SearchFiltersResetFiltersEvent extends SearchFiltersEvent {}

class SearchFiltersRestoreFiltersEvent extends SearchFiltersEvent {}
