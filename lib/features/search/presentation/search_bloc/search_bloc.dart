import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final MediaRepository _mediaRepository;

  SearchBloc({
    required NetworkCubit networkCubit,
    required MediaRepository mediaRepository,
  })  : _networkCubit = networkCubit,
        _mediaRepository = mediaRepository,
        super(SearchState()) {
    Future.microtask(
      () {
        _onNetworkStateChanged(networkCubit.state);
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<SearchMultiEvent>(
      _onSearchMulti,
      transformer: debounceDroppable(
        const Duration(milliseconds: 400),
      ),
    );
    on<SearchNetworkErrorEvent>(_onNetworkError);
    on<SearchNetworkConnectedEvent>(_onNetworkConnected);
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline) {
      add(SearchNetworkErrorEvent());
    } else if (state.type == NetworkStateType.connected) {
      add(SearchNetworkConnectedEvent());
    }
  }

  void _onNetworkConnected(
    SearchNetworkConnectedEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchState());
  }

  void _onNetworkError(
    SearchNetworkErrorEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchFailureState(
        failure: (1, StackTrace.current, ApiClientExceptionType.network, "")));
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
      case (final RepositoryFailure failure, null):
        return emit(SearchFailureState(failure: failure, query: event.query));
      case (_, final List<TMDBModel> patternSearchModels):
        searchModels = patternSearchModels;
        break;
    }

    emit(SearchLoadedState(searchModels: searchModels!));
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
