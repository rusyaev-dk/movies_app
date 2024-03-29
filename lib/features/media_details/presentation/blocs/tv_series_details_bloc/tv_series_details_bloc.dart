import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

part 'tv_series_details_event.dart';
part 'tv_series_details_state.dart';

class TvSeriesDetailsBloc
    extends Bloc<TvSeriesDetailsEvent, TVSeriesDetailsState> {
  late final MediaRepository _mediaRepository;

  TvSeriesDetailsBloc({
    required MediaRepository mediaRepository,
  })  : _mediaRepository = mediaRepository,
        super(TVSeriesDetailsState()) {
    on<TVSeriesDetailsLoadDetailsEvent>(_onLoadTVSeriesDetails);
  }

  Future<void> _onLoadTVSeriesDetails(
    TVSeriesDetailsLoadDetailsEvent event,
    Emitter<TVSeriesDetailsState> emit,
  ) async {
    emit(TVSeriesDetailsLoadingState());

    MediaRepositoryPattern mediaRepoPattern =
        await _mediaRepository.onGetMediaDetails<TVSeriesModel>(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    TVSeriesModel? tvSeriesModel;
    switch (mediaRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(TVSeriesDetailsFailureState(
            failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final TVSeriesModel patternModel):
        tvSeriesModel = patternModel;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaCredits(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    List<PersonModel>? tvSeriesCredits;
    switch (mediaRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(TVSeriesDetailsFailureState(
            failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final List<PersonModel> patternCredits):
        tvSeriesCredits = patternCredits;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaImages(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    switch (mediaRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(TVSeriesDetailsFailureState(
            failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final List<MediaImageModel> patternImages):
        return emit(TVSeriesDetailsLoadedState(
          tvSeriesModel: tvSeriesModel!,
          tvSeriesCredits: tvSeriesCredits!,
          tvSeriesImages: patternImages,
        ));
    }
  }
}
