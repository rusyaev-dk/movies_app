part of 'grid_media_bloc.dart';

enum GridMediaStatus { initial, success, failure }

class GridMediaState {
  GridMediaState({
    this.status = GridMediaStatus.initial,
    this.models = const <TMDBModel>[],
    this.page = 1,
    this.failure,
    this.hasReachedMax = false,
  });

  final GridMediaStatus status;
  final List<TMDBModel> models;
  final int page;
  final ApiRepositoryFailure? failure;
  final bool hasReachedMax;

  GridMediaState copyWith({
    GridMediaStatus? status,
    List<TMDBModel>? models,
    int? page,
    ApiRepositoryFailure? failure,
    bool? hasReachedMax = false,
  }) {
    return GridMediaState(
      status: status ?? this.status,
      models: models ?? this.models,
      page: page ?? this.page,
      failure: failure ?? this.failure,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
