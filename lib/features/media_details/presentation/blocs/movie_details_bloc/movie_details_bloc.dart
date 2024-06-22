import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/models/tmdb_models.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;
  late final MediaRepository _mediaRepository;

  MovieDetailsBloc({
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
    required MediaRepository mediaRepository,
  })  : _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        _mediaRepository = mediaRepository,
        super(const MovieDetailsState()) {
    on<MovieDetailsLoadDetailsEvent>(_onLoadMovieDetails);
    on<MovieDetailsAddToFavouriteEvent>(_onAddToFavourite);
    on<MovieDetailsAddToWatchlistEvent>(_onAddToWatchlist);
  }

  Future<void> _onLoadMovieDetails(
    MovieDetailsLoadDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state.isLoading == false) {
      emit(state.copyWith(isLoading: true));
    }

    String? sessionId;
    final SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    bool? isFavourite;
    bool? isInWatchlist;
    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onGetAccountStates(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      sessionId: sessionId!,
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final Map<String, bool> resAccountStateMap):
        isFavourite = resAccountStateMap["favourite"];
        isInWatchlist = resAccountStateMap["watchlist"];
    }

    MediaRepositoryPattern mediaRepoPattern =
        await _mediaRepository.onGetMediaDetails<MovieModel>(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      locale: event.locale,
    );

    MovieModel? movieModel;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final MovieModel resMovieModel):
        movieModel = resMovieModel;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaCredits(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      locale: event.locale,
    );

    List<PersonModel>? movieCredits;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final List<PersonModel> resMovieCredits):
        movieCredits = resMovieCredits;
    }

    mediaRepoPattern = await _mediaRepository.onGetMediaImages(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      locale: event.locale,
    );

    List<MediaImageModel>? movieImages;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final List<MediaImageModel> resMovieImages):
        movieImages = resMovieImages;
    }

    mediaRepoPattern = await _mediaRepository.onGetSimilarMedia<MovieModel>(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      locale: event.locale,
      page: 1,
    );

    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final List<MovieModel> resSimilarMovies):
        return emit(
          state.copyWith(
            movieModel: movieModel!,
            isFavourite: isFavourite!,
            isInWatchlist: isInWatchlist!,
            movieImages: movieImages!,
            movieCredits: movieCredits!,
            similarMovies: resSimilarMovies,
            failure: null,
          ),
        );
    }
  }

  Future<void> _onAddToFavourite(
    MovieDetailsAddToFavouriteEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    String? sessionId;
    SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    int? accountId;
    sessionDataRepoPattern = await _sessionDataRepository.onGetAccountId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onAddToFavourite(
      accountId: accountId!,
      sessionId: sessionId!,
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      isFavourite: !(event.isFavorite),
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final bool res):
        if (res) {
          emit(state.copyWith(isFavourite: !(event.isFavorite)));
        }
    }
  }

  Future<void> _onAddToWatchlist(
    MovieDetailsAddToWatchlistEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    String? sessionId;
    SessionDataRepositoryPattern sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    int? accountId;
    sessionDataRepoPattern = await _sessionDataRepository.onGetAccountId();

    switch (sessionDataRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(state.copyWith(failure: failure, movieId: event.movieId));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    final AccountRepositoryPattern accountRepoPattern =
        await _accountRepository.onAddToWatchlist(
      accountId: accountId!,
      sessionId: sessionId!,
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      isInWatchlist: !(event.isInWatchlist),
    );

    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
          state.copyWith(
            failure: failure,
            movieId: event.movieId,
          ),
        );
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
