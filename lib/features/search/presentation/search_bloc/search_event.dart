part of 'search_bloc.dart';

class SearchEvent {}

class SearchMultiEvent extends SearchEvent {
  final String query;
  final String locale;
  final int page;

  SearchMultiEvent({
    required this.query,
    this.locale = "en-US",
    this.page = 1,
  });
}

class SearchNetworkErrorEvent extends SearchEvent {}

class SearchNetworkConnectedEvent extends SearchEvent {}

class SearchOpenFiltersEvent extends SearchEvent {}
