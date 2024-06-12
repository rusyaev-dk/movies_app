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

  static const List<ApiMediaQueryType> _queryTypes = [
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

    List<List<TMDBModel>> models;
    try {
      models = await _loadModels(event.locale, event.page);
    } catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
      event.completer?.complete();
      return emit(
        HomeFailureState(failure: err as ApiRepositoryFailure),
      );
    }

    event.completer?.complete();
    emit(
      HomeLoadedState(
        popularMovies: models[0] as List<MovieModel>,
        trendingMovies: models[1] as List<MovieModel>,
        popularTVSeries: models[2] as List<TVSeriesModel>,
        trendingTVSeries: models[3] as List<TVSeriesModel>,
        onTheAirTVSeries: models[4] as List<TVSeriesModel>,
        popularPersons: models[5] as List<PersonModel>,
      ),
    );
  }

  Future<List<List<TMDBModel>>> _loadModels(String locale, int page) async {
    List<List<TMDBModel>> models =
        List.generate(6, (i) => List.of(List.empty()), growable: false);

    List<Future<MediaRepositoryPattern>> futures = List.generate(
      _queryTypes.length,
      (i) {
        final type = _queryTypes[i];
        if (type.asString().contains("movies")) {
          return _mediaRepository.onGetMediaModelsFromQueryType<MovieModel>(
            queryType: type,
            locale: locale,
            page: page,
          );
        } else if (type.asString().contains("series")) {
          return _mediaRepository.onGetMediaModelsFromQueryType<TVSeriesModel>(
            queryType: type,
            locale: locale,
            page: page,
          );
        } else {
          return _mediaRepository.onGetMediaModelsFromQueryType<PersonModel>(
            queryType: type,
            locale: locale,
            page: page,
          );
        }
      },
    );

    List<MediaRepositoryPattern> patterns = await Future.wait(futures);

    int index = 0;
    for (var pattern in patterns) {
      switch (pattern) {
        case (final ApiRepositoryFailure failure, null):
          throw failure;
        case (null, final List<TMDBModel> resModels):
          models[index] = resModels;
      }
      index++;
    }

    return models;
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
