import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:stream_transform/stream_transform.dart';

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
  late final SearchFiltersRepository _searchFiltersRepository;

  SearchBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
    required SearchFiltersRepository searchFiltersRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        _searchFiltersRepository = searchFiltersRepository,
        super(SearchState()) {
    Future.microtask(
      () {
        _onNetworkStateChanged(networkCubit.state);
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<SearchNetworkConnectedEvent>(_onNetworkConnected);
    on<SearchMultiEvent>(
      _onSearchMulti,
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
    emit(SearchState());
  }

  Future<void> _onSearchMulti(
    SearchMultiEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) return emit(SearchState());

    emit(SearchLoadingState(query: event.query));

    final mediaRepoPattern = await _mediaRepository.onGetSearchMultiMedia(
      query: event.query,
      locale: event.locale,
      page: event.page,
    );

    List<TMDBModel>? searchModels;
    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(SearchFailureState(failure: failure, query: event.query));
      case (null, final List<TMDBModel> resSearchModels):
        searchModels = resSearchModels;
    }

    searchModels = await _searchModelsFiltration(searchModels: searchModels);
    emit(SearchLoadedState(searchModels: searchModels));
  }

  Future<List<TMDBModel>> _searchModelsFiltration(
      {required List<TMDBModel>? searchModels}) async {
    if (searchModels == null || searchModels.isEmpty) return [];

    final SearchFiltersModel searchFiltersModel =
        await _searchFiltersRepository.loadFiltersModel();

    // print(searchFiltersModel.genresFilter);
    // print(searchFiltersModel.sortByFilter);
    // print(searchFiltersModel.showMediaTypeFilter);

    searchModels.removeWhere((model) => !_mediaTypeCorresponding(
          model,
          searchFiltersModel.showMediaTypeFilter,
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

  bool _mediaTypeCorresponding(
      TMDBModel model, ShowMediaTypeFilter mediaTypeFilter) {
    if (mediaTypeFilter == ShowMediaTypeFilter.all) return true;

    if ((model is MovieModel &&
            mediaTypeFilter == ShowMediaTypeFilter.movies) ||
        (model is TVSeriesModel &&
            mediaTypeFilter == ShowMediaTypeFilter.tvs) ||
        (model is PersonModel &&
            mediaTypeFilter == ShowMediaTypeFilter.persons)) {
      return true;
    }

    return false;
  }

  // bool _genresFiltration(TMDBModel model, List<String> genresFilter) {
  //   if (genresFilter.isEmpty) return true;

  //   return false;
  // }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
