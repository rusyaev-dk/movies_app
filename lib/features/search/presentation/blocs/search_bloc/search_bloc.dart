import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/storage/storage_interface.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;
  late final KeyValueStorage _keyValueStorage;
  late final SearchFiltersRepository _searchFiltersRepository;

  SearchBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
    required KeyValueStorage keyValueStorage,
    required SearchFiltersRepository searchFiltersRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        _keyValueStorage = keyValueStorage,
        _searchFiltersRepository = searchFiltersRepository,
        super(SearchInitialState()) {
    Future.microtask(
      () {
        _onNetworkStateChanged(networkCubit.state);
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<SearchNetworkConnectedEvent>(_onNetworkConnected);
    on<SearchMediaEvent>(
      _onSearch,
      transformer: debounceDroppable(
        const Duration(milliseconds: 350),
      ),
    );
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.connected) {
      add(SearchNetworkConnectedEvent());
    }
  }

  void _onNetworkConnected(
    SearchNetworkConnectedEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitialState());
  }

  Future<void> _onSearch(
    SearchMediaEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      await _keyValueStorage.delete(
        key: KeyValueStorageKeys.searchQueryKey,
      );
      return emit(SearchInitialState());
    }

    if (state is! SearchLoadedState) {
      emit(SearchLoadingState(query: event.query));
    }

    await _keyValueStorage.set<String>(
      key: KeyValueStorageKeys.searchQueryKey,
      value: event.query,
    );

    final SearchFiltersModel searchFiltersModel =
        await _searchFiltersRepository.restoreFiltersModel();

    final MediaRepositoryPattern mediaRepoPattern;
    switch (searchFiltersModel.showMediaTypeFilter) {
      case (ShowMediaTypeFilter.all):
        mediaRepoPattern = await _mediaRepository.onSearchMultiMedia(
          query: event.query,
          locale: event.locale,
          page: event.page,
        );
        break;
      case (ShowMediaTypeFilter.movies):
        mediaRepoPattern = await _mediaRepository.onSearchMovies(
          query: event.query,
          locale: event.locale,
          page: event.page,
        );
        break;
      case (ShowMediaTypeFilter.tvs):
        mediaRepoPattern = await _mediaRepository.onSearchTVSeries(
          query: event.query,
          locale: event.locale,
          page: event.page,
        );
        break;
      case (ShowMediaTypeFilter.persons):
        mediaRepoPattern = await _mediaRepository.onSearchPersons(
          query: event.query,
          locale: event.locale,
          page: event.page,
        );
        break;
    }

    List<TMDBModel>? searchModels;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(SearchFailureState(failure: failure, query: event.query));
      case (null, final List<TMDBModel> resSearchModels):
        searchModels = resSearchModels;
    }

    searchModels = await _searchModelsFiltration(
      searchModels: searchModels,
      searchFiltersModel: searchFiltersModel,
    );
    emit(SearchLoadedState(searchModels: searchModels));
  }

  Future<List<TMDBModel>> _searchModelsFiltration({
    required List<TMDBModel>? searchModels,
    required SearchFiltersModel searchFiltersModel,
  }) async {
    if (searchModels == null || searchModels.isEmpty) return [];

    searchModels.removeWhere((model) => !_ratingCorresponding(
          model,
          searchFiltersModel.ratingFilter,
        ));

    if (searchFiltersModel.sortByFilter == SortByFilter.rating) {
      searchModels.sort(
        (a, b) {
          if (a is MovieModel && b is MovieModel) {
            return b.voteAverage.compareTo(a.voteAverage);
          } else if (a is TVSeriesModel && b is TVSeriesModel) {
            return b.voteAverage.compareTo(a.voteAverage);
          } else if (a is MovieModel && b is TVSeriesModel) {
            return b.voteAverage.compareTo(a.voteAverage);
          } else if (a is TVSeriesModel && b is MovieModel) {
            return b.voteAverage.compareTo(a.voteAverage);
          } else {
            return 0;
          }
        },
      );
    } else {
      searchModels.sort(
        (a, b) {
          if (a is MovieModel && b is MovieModel) {
            return b.popularity.compareTo(a.popularity);
          } else if (a is TVSeriesModel && b is TVSeriesModel) {
            return b.popularity.compareTo(a.popularity);
          } else if (a is MovieModel && b is TVSeriesModel) {
            return b.popularity.compareTo(a.popularity);
          } else if (a is TVSeriesModel && b is MovieModel) {
            return b.popularity.compareTo(a.popularity);
          } else if (a is PersonModel && b is PersonModel) {
            return b.popularity.compareTo(a.popularity);
          } else {
            return 0;
          }
        },
      );
    }
    return searchModels;
  }

  bool _ratingCorresponding(TMDBModel model, int ratingFilter) {
    if (ratingFilter == 0 || model is PersonModel) return true;

    if ((model is MovieModel && model.voteAverage >= ratingFilter.toDouble()) ||
        (model is TVSeriesModel &&
            model.voteAverage >= ratingFilter.toDouble())) {
      return true;
    }

    return false;
  }

  // bool _genresCorresponding(TMDBModel model, List<String> genresFilter) {
  //   if (genresFilter.isEmpty) return true;

  //   return false;
  // }

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
