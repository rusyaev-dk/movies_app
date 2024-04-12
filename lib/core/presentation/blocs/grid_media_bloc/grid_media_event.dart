part of 'grid_media_bloc.dart';

class GridMediaEvent {}

class GridMediaLoadNewMediaEvent extends GridMediaEvent {
  final int page;
  final ApiMediaQueryType queryType;
  final String locale;

  GridMediaLoadNewMediaEvent({
    this.page = 1,
    required this.queryType,
    this.locale = "en-US",
  });
}
