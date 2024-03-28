part of 'home_bloc.dart';

class HomeEvent {}

class HomeLoadMediaEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadMediaEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeRefreshMediaEvent extends HomeEvent {
  final RefreshController refreshController;
  final String locale;
  final int page;

  HomeRefreshMediaEvent({
    required this.refreshController,
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeNetworkErrorEvent extends HomeEvent {}
