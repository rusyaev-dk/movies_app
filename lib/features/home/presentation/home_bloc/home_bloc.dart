import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;

  static const List<ApiMediaQueryType> _searchTypes = [
    ApiMediaQueryType.popularMovies,
    ApiMediaQueryType.trendingMovies,
    ApiMediaQueryType.popularTVSeries,
    ApiMediaQueryType.trendingTVSeries,
    ApiMediaQueryType.onTheAirTVSeries,
    ApiMediaQueryType.popularPersons,
  ];

  HomeBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        super(HomeLoadingState()) {
    Future.microtask(
      () {
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<HomeNetworkErrorEvent>(_onNetworkError);
    on<HomeLoadMediaEvent>(_onLoadMedia, transformer: sequential());
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
    if (state is! HomeLoadedState) {
      emit(HomeLoadingState());
    }
    Map<String, List<dynamic>> modelsMap = {};

    for (ApiMediaQueryType type in _searchTypes) {
      MediaRepositoryPattern mediaRepoPattern;
      if (type.asString().contains("movies")) {
        mediaRepoPattern =
            await _mediaRepository.onGetMediaModelsFromQueryType<MovieModel>(
          queryType: type,
          locale: event.locale,
          page: event.page,
        );
      } else if (type.asString().contains("series")) {
        mediaRepoPattern =
            await _mediaRepository.onGetMediaModelsFromQueryType<TVSeriesModel>(
          queryType: type,
          locale: event.locale,
          page: event.page,
        );
      } else {
        mediaRepoPattern =
            await _mediaRepository.onGetMediaModelsFromQueryType<PersonModel>(
          queryType: type,
          locale: event.locale,
          page: event.page,
        );
      }

      switch (mediaRepoPattern) {
        case (final ApiRepositoryFailure failure, null):
          event.completer?.complete();
          return emit(HomeFailureState(failure: failure));
        case (null, final List<TMDBModel> resModels):
          modelsMap[type.asString()] = resModels;
      }
    }

    event.completer?.complete();
    emit(
      HomeLoadedState(
        popularMovies: modelsMap["popular_movies"] as List<MovieModel>,
        trendingMovies: modelsMap["trending_movies"] as List<MovieModel>,
        popularTVSeries: modelsMap["popular_tv_series"] as List<TVSeriesModel>,
        trendingTVSeries:
            modelsMap["trending_tv_series"] as List<TVSeriesModel>,
        onTheAirTVSeries:
            modelsMap["on_the_air_tv_series"] as List<TVSeriesModel>,
        popularPersons: modelsMap["popular_persons"] as List<PersonModel>,
      ),
    );
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
