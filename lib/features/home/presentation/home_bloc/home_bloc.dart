import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;

  static const List<ApiQueryType> _searchTypes = [
    ApiQueryType.popularMovies,
    ApiQueryType.trendingMovies,
    ApiQueryType.popularTVSeries,
    ApiQueryType.trendingTVSeries,
  ];

  HomeBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        super(HomeState()) {
    Future.microtask(
      () {
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<HomeNetworkErrorEvent>(_onNetworkError);
    on<HomeLoadMediaEvent>(_onLoadMedia, transformer: sequential());
    on<HomeRefreshMediaEvent>(_onRefreshMedia);
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline ||
        state.type == NetworkStateType.unknown) {
      add(HomeNetworkErrorEvent());
    } else if (state.type == NetworkStateType.connected) {
      add(HomeLoadMediaEvent());
    }
  }

  void _onNetworkError(
    HomeNetworkErrorEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeFailureState(
        failure: (1, StackTrace.current, ApiClientExceptionType.network, "")));
  }

  Future<void> _onLoadMedia(
    HomeLoadMediaEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    Map<String, List<dynamic>> modelsMap = {};

    for (ApiQueryType type in _searchTypes) {
      MediaRepositoryPattern mediaRepoPattern;
      if (type == ApiQueryType.popularMovies ||
          type == ApiQueryType.trendingMovies) {
        mediaRepoPattern = await _mediaRepository.onGetMediaModels<MovieModel>(
          type: type,
          locale: event.locale,
          page: event.page,
        );
      } else {
        mediaRepoPattern =
            await _mediaRepository.onGetMediaModels<TVSeriesModel>(
          type: type,
          locale: event.locale,
          page: event.page,
        );
      }

      switch (mediaRepoPattern) {
        case (final RepositoryFailure failure, null):
          return emit(HomeFailureState(failure: failure));
        case (null, final List<TMDBModel> resModels):
          if (resModels.isEmpty) {
            return emit(HomeFailureState(failure: (
              1,
              StackTrace.current,
              ApiClientExceptionType.unknown,
              ""
            )));
          }
          modelsMap[type.asString()] = resModels;
          break;
      }

      await Future.delayed(const Duration(milliseconds: 150));
    }

    emit(HomeLoadedState(
      popularMovies: modelsMap["popularMovies"] as List<MovieModel>,
      trendingMovies: modelsMap["trendingMovies"] as List<MovieModel>,
      popularTVSeries: modelsMap["popularTVSeries"] as List<TVSeriesModel>,
      trendingTVSeries: modelsMap["trendingTVSeries"] as List<TVSeriesModel>,
    ));
  }

  Future<void> _onRefreshMedia(
      HomeRefreshMediaEvent event, Emitter<HomeState> emit) async {
    add(HomeLoadMediaEvent(locale: event.locale, page: event.page));
    event.refreshController.refreshCompleted();
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
