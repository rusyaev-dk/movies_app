import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/models/tmdb_models.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'tv_series_details_event.dart';
part 'tv_series_details_state.dart';

class TVSeriesDetailsBloc
    extends Bloc<TvSeriesDetailsEvent, TVSeriesDetailsState> {
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;
  late final MediaRepository _mediaRepository;

  TVSeriesDetailsBloc({
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
    required MediaRepository mediaRepository,
  })  : _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        _mediaRepository = mediaRepository,
        super(const TVSeriesDetailsState()) {
    on<TVSeriesDetailsLoadDetailsEvent>(_onLoadTVSeriesDetails);
    on<TVSeriesDetailsAddToFavouriteEvent>(_onAddToFavourite);
    on<TVSeriesDetailsAddToWatchlistEvent>(_onAddToWatchlist);
  }

  Future<void> _onLoadTVSeriesDetails(
    TVSeriesDetailsLoadDetailsEvent event,
    Emitter<TVSeriesDetailsState> emit,
  ) async {
    if (state.isLoading == false) {
      emit(state.copyWith(isLoading: true));
    }

    String? sessionId;
    final SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    bool? isFavourite;
    bool? isInWatchlist;
    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onGetAccountStates(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      sessionId: sessionId!,
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final Map<String, bool> resAccountStateMap):
        isFavourite = resAccountStateMap["favourite"];
        isInWatchlist = resAccountStateMap["watchlist"];
    }

    MediaRepositoryPattern mediaRepoPattern =
        await _mediaRepository.onGetMediaDetails<TVSeriesModel>(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    TVSeriesModel? tvSeriesModel;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final TVSeriesModel resTVSeriesModel):
        tvSeriesModel = resTVSeriesModel;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaCredits(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    List<PersonModel>? tvSeriesCredits;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final List<PersonModel> resTVSeriesCredits):
        tvSeriesCredits = resTVSeriesCredits;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaImages(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
    );

    List<MediaImageModel>? tvSeriesImages;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final List<MediaImageModel> resTVSeriesImages):
        tvSeriesImages = resTVSeriesImages;
    }

    mediaRepoPattern = await _mediaRepository.onGetSimilarMedia<TVSeriesModel>(
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      locale: event.locale,
      page: 1,
    );

    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final List<TVSeriesModel> resSimilarTVSeries):
        return emit(state.copyWith(
          tvSeriesModel: tvSeriesModel!,
          isFavourite: isFavourite!,
          isInWatchlist: isInWatchlist!,
          tvSeriesImages: tvSeriesImages!,
          tvSeriesCredits: tvSeriesCredits!,
          similarTVSeries: resSimilarTVSeries,
        ));
    }
  }

  Future<void> _onAddToFavourite(
    TVSeriesDetailsAddToFavouriteEvent event,
    Emitter<TVSeriesDetailsState> emit,
  ) async {
    String? sessionId;
    SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    int? accountId;
    sessionDataRepoPattern = await _sessionDataRepository.onGetAccountId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onAddToFavourite(
      accountId: accountId!,
      sessionId: sessionId!,
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      isFavourite: !(event.isFavorite),
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final bool res):
        if (res) {
          emit(state.copyWith(isFavourite: !(event.isFavorite)));
        }
    }
  }

  Future<void> _onAddToWatchlist(
    TVSeriesDetailsAddToWatchlistEvent event,
    Emitter<TVSeriesDetailsState> emit,
  ) async {
    String? sessionId;
    SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    int? accountId;
    sessionDataRepoPattern = await _sessionDataRepository.onGetAccountId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onAddToWatchlist(
      accountId: accountId!,
      sessionId: sessionId!,
      mediaType: TMDBMediaType.tv,
      mediaId: event.tvSeriesId,
      isInWatchlist: !(event.isInWatchlist),
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            state.copyWith(failure: failure, tvSeriesId: event.tvSeriesId));
      case (null, final bool res):
        if (res) {
          return emit(state.copyWith(isInWatchlist: !(event.isInWatchlist)));
        }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
