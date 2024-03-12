import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final MediaRepository _mediaRepository;

  HomeBloc({required MediaRepository mediaRepository})
      : _mediaRepository = mediaRepository,
        super(HomeState()) {
    on<HomeLoadAllMediaEvent>(
      _onAllMedia,
      transformer: sequential(),
    );
    on<HomeLoadPopularMoviesEvent>(
      _onPopularMovies,
      transformer: sequential(),
    );
    on<HomeLoadTrendingMoviesEvent>(
      _onTrendingMovies,
      transformer: sequential(),
    );
    on<HomeLoadPopularTVSeriesEvent>(
      _onPopularTVSeries,
      transformer: sequential(),
    );
    on<HomeLoadTrendingTVSeriesEvent>(
      _onTrendingTVSeries,
      transformer: sequential(),
    );
  }

  Future<void> _onAllMedia(
      HomeLoadAllMediaEvent event, Emitter<HomeState> emit) async {
    try {
 
      
      emit(state.copyWith(
        isLoading: true,
      ));

      await Future.delayed(const Duration(milliseconds: 800));

      final popularMovies = await _mediaRepository.onGetPopularMovies(
        locale: event.locale,
        page: event.page,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      final trendingMovies = await _mediaRepository.onGetTrendingMovies(
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
    } on ApiClientException catch (exception) {
      emit(state.copyWith(exception: exception));
    }
  }

  Future<void> _onPopularMovies(
      HomeLoadPopularMoviesEvent event, Emitter<HomeState> emit) async {
    final popularMovies = await _mediaRepository.onGetPopularMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(popularMovies: popularMovies));
  }

  Future<void> _onTrendingMovies(
      HomeLoadTrendingMoviesEvent event, Emitter<HomeState> emit) async {
    final trendingMovies = await _mediaRepository.onGetTrendingMovies(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(trendingMovies: trendingMovies));
  }

  Future<void> _onPopularTVSeries(
      HomeLoadPopularTVSeriesEvent event, Emitter<HomeState> emit) async {
    final popularTVSeries = await _mediaRepository.onGetPopularTVSeries(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(popularTVSeries: popularTVSeries));
  }

  Future<void> _onTrendingTVSeries(
      HomeLoadTrendingTVSeriesEvent event, Emitter<HomeState> emit) async {
    final trendingTVSeries = await _mediaRepository.onGetTrendingTVSeries(
      locale: event.locale,
      page: event.page,
    );
    emit(state.copyWith(trendingTVSeries: trendingTVSeries));
  }
}
