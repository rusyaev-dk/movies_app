import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  late final MediaRepository _mediaRepository;

  MovieDetailsBloc({
    required MediaRepository mediaRepository,
  })  : _mediaRepository = mediaRepository,
        super(MovieDetailsState()) {
    on<MovieDetailsLoadDetailsEvent>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    MovieDetailsLoadDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoadingState());

    MediaRepositoryPattern mediaRepoPattern =
        await _mediaRepository.onGetMediaDetails<MovieModel>(
      mediaType: TMDBMediaType.movie,
      mediaId: event.movieId,
      locale: event.locale,
    );

    MovieModel? movieModel;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(
            MovieDetailsFailureState(failure: failure, movieId: event.movieId));
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
        return emit(
            MovieDetailsFailureState(failure: failure, movieId: event.movieId));
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
        return emit(
            MovieDetailsFailureState(failure: failure, movieId: event.movieId));
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
        return emit(
            MovieDetailsFailureState(failure: failure, movieId: event.movieId));
      case (null, final List<MovieModel> resSimilarMovies):
        return emit(MovieDetailsLoadedState(
            movieModel: movieModel!,
            movieImages: movieImages!,
            movieCredits: movieCredits!,
            similarMovies: resSimilarMovies));
    }
  }
}
