part of 'grid_media_bloc.dart';

sealed class GridMediaEvent extends Equatable {}

final class GridMediaLoadNewMediaEvent extends GridMediaEvent {
  final int page;
  final ApiMediaQueryType queryType;
  final String locale;

  GridMediaLoadNewMediaEvent({
    this.page = 1,
    required this.queryType,
    this.locale = "en-US",
  });

  @override
  List<Object?> get props => [
        page,
        locale,
      ];
}
