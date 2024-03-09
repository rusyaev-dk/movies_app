import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/tmdb_media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

part 'tmdb_media_event.dart';
part 'tmdb_media_state.dart';

class TMDBMediaBloc extends Bloc<TMDBMediaEvent, TMDBMediaState> {
  late final TMDBMediaRepository _tmdbRepository;

  TMDBMediaBloc({required TMDBMediaRepository tmdbRepository})
      : _tmdbRepository = tmdbRepository,
        super(TMDBMediaState()) {
    on<TMDBMediaAllMediaEvent>(_onAllMedia, transformer: sequential());
    on<TMDBMediaPopularMoviesEvent>(_onPopularMovies,
        transformer: sequential());
    on<TMDBMediaTrendingMoviesEvent>(_onTrendingMovies,
        transformer: sequential());
    on<TMDBMediaPopularTVSeriesEvent>(_onPopularTVSeries,
        transformer: sequential());
    on<TMDBMediaTrendingTVSeriesEvent>(_onTrendingTVSeries,
        transformer: sequential());
  }

  Future<void> _onAllMedia(
      TMDBMediaAllMediaEvent event, Emitter<TMDBMediaState> emit) async {
    emit(state.copyWith(isLoading: true));

    final popularMovies = await _tmdbRepository.onGetPopularMovies(
      locale: event.locale,
      page: event.page,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    final trendingMovies = await _tmdbRepository.onGetTrendingMovies(
      locale: event.locale,
      page: event.page,
    );

    await Future.delayed(const Duration(seconds: 4));

    // final popularTVSeries = await _tmdbRepository.onGetPopularTVSeries(
    //   locale: event.locale,
    //   page: event.page,
    // );

    // await Future.delayed(const Duration(milliseconds: 100));

    // final trendingTVSeries = await _tmdbRepository.onGetTrendingTVSeries(
    //   locale: event.locale,
    //   page: event.page,
    // );

    emit(state.copyWith(
      isLoading: false,
      popularMovies: popularMovies,
      trendingMovies: trendingMovies,
      // popularTVSeries: popularTVSeries,
      // trendingTVSeries: trendingTVSeries,
    ));
  }

  Future<void> _onPopularMovies(
      TMDBMediaPopularMoviesEvent event, Emitter<TMDBMediaState> emit) async {
    final popularMovies = await _tmdbRepository.onGetPopularMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(popularMovies: popularMovies));
  }

  Future<void> _onTrendingMovies(
      TMDBMediaTrendingMoviesEvent event, Emitter<TMDBMediaState> emit) async {
    final trendingMovies = await _tmdbRepository.onGetTrendingMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(trendingMovies: trendingMovies));
  }

  Future<void> _onPopularTVSeries(
      TMDBMediaPopularTVSeriesEvent event, Emitter<TMDBMediaState> emit) async {
    final popularTVSeries = await _tmdbRepository.onGetPopularTVSeries(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(popularTVSeries: popularTVSeries));
  }

  Future<void> _onTrendingTVSeries(TMDBMediaTrendingTVSeriesEvent event,
      Emitter<TMDBMediaState> emit) async {
    final trendingTVSeries = await _tmdbRepository.onGetTrendingTVSeries(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(trendingTVSeries: trendingTVSeries));
  }
}
