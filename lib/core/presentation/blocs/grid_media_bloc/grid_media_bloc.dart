import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'grid_media_event.dart';
part 'grid_media_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class GridMediaBloc extends Bloc<GridMediaEvent, GridMediaState> {
  late final MediaRepository _mediaRepository;

  GridMediaBloc({required MediaRepository mediaRepository})
      : _mediaRepository = mediaRepository,
        super(const GridMediaState()) {
    on<GridMediaLoadNewMediaEvent>(
      _onLoadNewMedia,
      transformer: throttleDroppable(
        const Duration(milliseconds: 100),
      ),
    );
  }

  Future<void> _onLoadNewMedia(
    GridMediaLoadNewMediaEvent event,
    Emitter<GridMediaState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final MediaRepositoryPattern mediaRepoPattern;
    if (event.queryType.asString().contains("movies")) {
      mediaRepoPattern =
          await _mediaRepository.onGetMediaModelsFromQueryType<MovieModel>(
        queryType: event.queryType,
        locale: event.locale,
        page: event.page,
      );
    } else if (event.queryType.asString().contains("series")) {
      mediaRepoPattern =
          await _mediaRepository.onGetMediaModelsFromQueryType<TVSeriesModel>(
        queryType: event.queryType,
        locale: event.locale,
        page: event.page,
      );
    } else {
      mediaRepoPattern =
          await _mediaRepository.onGetMediaModelsFromQueryType<PersonModel>(
        queryType: event.queryType,
        locale: event.locale,
        page: event.page,
      );
    }

    List<TMDBModel> models = [];
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(
          status: GridMediaStatus.failure,
          failure: failure,
        ));
      case (null, final List<TMDBModel> resModels):
        models = resModels;
    }

    if (state.status == GridMediaStatus.initial) {
      return emit(
        state.copyWith(
          status: GridMediaStatus.success,
          models: models,
          hasReachedMax: false,
        ),
      );
    }
    models.isEmpty
        ? emit(state.copyWith(hasReachedMax: true))
        : emit(
            state.copyWith(
              status: GridMediaStatus.success,
              models: state.models + models,
              hasReachedMax: false,
              page: event.page + 1,
            ),
          );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
