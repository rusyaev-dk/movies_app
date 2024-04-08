part of 'search_filters_bloc.dart';

class SearchFiltersEvent {}

class SearchFiltersSetShowMediaTypeEvent extends SearchFiltersEvent {
  final ShowMediaTypeFilter showMediaTypeFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetShowMediaTypeEvent({
    required this.showMediaTypeFilter,
    required this.prevFiltersModel,
  });
}

class SearchFiltersSetSortByEvent extends SearchFiltersEvent {
  final SortByFilter sortByFilter;
  final SearchFiltersModel prevFiltersModel;

  SearchFiltersSetSortByEvent({
    required this.sortByFilter,
    required this.prevFiltersModel,
  });
}

class SearchFiltersRestoreFiltersEvent extends SearchFiltersEvent {}
