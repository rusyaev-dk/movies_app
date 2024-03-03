import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/repositories/tmdb_media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

part 'tmdb_media_event.dart';
part 'tmdb_media_state.dart';

class TMDBMediaBloc extends Bloc<TMDBMediaEvent, TMDBMediaState> {
  late final TMDBMediaRepository _tmdbRepository;

  TMDBMediaBloc({required TMDBMediaRepository tmdbRepository})
      : _tmdbRepository = tmdbRepository,
        super(TMDBMediaState()) {
    on<TMDBMediaPopularMoviesEvent>(_onPopularMovies);
    on<TMDBMediaTrendingMoviesEvent>(_onTrendingMovies);
  }

  _onPopularMovies(
      TMDBMediaPopularMoviesEvent event, Emitter<TMDBMediaState> emit) async {
    final popularMovies = await _tmdbRepository.onGetPopularMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(popularMovies: popularMovies));
  }

  _onTrendingMovies(
      TMDBMediaTrendingMoviesEvent event, Emitter<TMDBMediaState> emit) async {
    final trendingMovies = await _tmdbRepository.onGetTrendingMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(trendingMovies: trendingMovies));
  }
}
