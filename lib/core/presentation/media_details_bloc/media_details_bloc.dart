import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';

part 'media_details_event.dart';
part 'media_details_state.dart';

class MediaDetailsBloc extends Bloc<MediaDetailsEvent, MediaDetailsState> {
  final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;

  MediaDetailsBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        super(MediaDetailsState()) {
    Future.microtask(
      () {
        _onNetworkStateChanged(networkCubit.state);
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );
    on<MediaDetailsNetworkErrorEvent>(_onNetworkError);
    on<MediaDetailsLoadDetailsEvent>(_onMediaDetails);
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline) {
      add(MediaDetailsNetworkErrorEvent());
    } // else if (state.type == NetworkStateType.connected) {
    //   // add(());
    // }
  }

  void _onNetworkError(
    MediaDetailsNetworkErrorEvent event,
    Emitter<MediaDetailsState> emit,
  ) {
    emit(MediaDetailsFailureState(
        failure: (1, StackTrace.current, ApiClientExceptionType.network, "")));
  }

  Future<void> _onMediaDetails(
    MediaDetailsLoadDetailsEvent event,
    Emitter<MediaDetailsState> emit,
  ) async {
    emit(MediaDetailsLoadingState());

    MediaRepositoryPattern mediaRepoPattern;
    if (event.mediaType == TMDBMediaType.movie) {
      mediaRepoPattern = await _mediaRepository.onGetMediaDetails<MovieModel>(
        mediaType: event.mediaType,
        mediaId: event.mediaId,
        locale: event.locale,
      );
    } else if (event.mediaType == TMDBMediaType.tv) {
      mediaRepoPattern =
          await _mediaRepository.onGetMediaDetails<TVSeriesModel>(
        mediaType: event.mediaType,
        mediaId: event.mediaId,
        locale: event.locale,
      );
    } else {
      mediaRepoPattern = await _mediaRepository.onGetMediaDetails<PersonModel>(
        mediaType: event.mediaType,
        mediaId: event.mediaId,
        locale: event.locale,
      );
    }

    switch (mediaRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(
            MediaDetailsFailureState(failure: failure, mediaId: event.mediaId));
      case (null, final TMDBModel model):
        return emit(MediaDetailsLoadedState(mediaModel: model));
    }
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
