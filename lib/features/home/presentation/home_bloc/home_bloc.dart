import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;

  HomeBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        super(HomeState()) {
    Future.microtask(
      () {
        _onNetworkStateChanged(networkCubit.state);
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<HomeNetworkErrorEvent>(_onNetworkError);
    
    on<HomeLoadAllMediaEvent>(
      _onAllMedia,
      transformer: sequential(),
    );
    // on<HomeLoadPopularMoviesEvent>(
    //   _onPopularMovies,
    //   transformer: sequential(),
    // );
    // on<HomeLoadTrendingMoviesEvent>(
    //   _onTrendingMovies,
    //   transformer: sequential(),
    // );
    // on<HomeLoadPopularTVSeriesEvent>(
    //   _onPopularTVSeries,
    //   transformer: sequential(),
    // );
    // on<HomeLoadTrendingTVSeriesEvent>(
    //   _onTrendingTVSeries,
    //   transformer: sequential(),
    // );
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline) {
      add(HomeNetworkErrorEvent());
    } else if (state.type == NetworkStateType.connected) {
      add(HomeLoadAllMediaEvent());
    }
  }

  void _onNetworkError(HomeNetworkErrorEvent event, Emitter<HomeState> emit) {
    emit(HomeFailureState(
        exception: ApiClientException(ApiClientExceptionType.network)));
  }

  Future<void> _onAllMedia(
      HomeLoadAllMediaEvent event, Emitter<HomeState> emit) async {
    try {

      emit(HomeLoadingState());
      await Future.delayed(const Duration(milliseconds: 800));

      throw ApiClientException(ApiClientExceptionType.sessionExpired);

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

      emit(HomeLoadedState(
        popularMovies: popularMovies,
        trendingMovies: trendingMovies,
        // popularTVSeries: popularTVSeries,
        // trendingTVSeries: trendingTVSeries,
      ));
    } on ApiClientException catch (exception) {
      emit(HomeFailureState(exception: exception));
    }
  }

  // Future<void> _onPopularMovies(
  //     HomeLoadPopularMoviesEvent event, Emitter<HomeState> emit) async {
  //   final popularMovies = await _mediaRepository.onGetPopularMovies(
  //     locale: event.locale,
  //     page: event.page,
  //   );
  //   emit(state.copyWith(popularMovies: popularMovies));
  // }

  // Future<void> _onTrendingMovies(
  //     HomeLoadTrendingMoviesEvent event, Emitter<HomeState> emit) async {
  //   final trendingMovies = await _mediaRepository.onGetTrendingMovies(
  //     locale: event.locale,
  //     page: event.page,
  //   );
  //   emit(state.copyWith(trendingMovies: trendingMovies));
  // }

  // Future<void> _onPopularTVSeries(
  //     HomeLoadPopularTVSeriesEvent event, Emitter<HomeState> emit) async {
  //   final popularTVSeries = await _mediaRepository.onGetPopularTVSeries(
  //     locale: event.locale,
  //     page: event.page,
  //   );
  //   emit(state.copyWith(popularTVSeries: popularTVSeries));
  // }

  // Future<void> _onTrendingTVSeries(
  //     HomeLoadTrendingTVSeriesEvent event, Emitter<HomeState> emit) async {
  //   final trendingTVSeries = await _mediaRepository.onGetTrendingTVSeries(
  //     locale: event.locale,
  //     page: event.page,
  //   );
  //   emit(state.copyWith(trendingTVSeries: trendingTVSeries));
  // }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
