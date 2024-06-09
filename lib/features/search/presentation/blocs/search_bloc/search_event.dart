part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {}

final class SearchMediaEvent extends SearchEvent {
  final String query;
  final String locale;
  final int page;

  SearchMediaEvent({
    required this.query,
    this.locale = "en-US",
    this.page = 1,
  });

  @override
  List<Object?> get props => [
        query,
        locale,
        page,
      ];
}

final class SearchNetworkErrorEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}

final class SearchNetworkConnectedEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}
