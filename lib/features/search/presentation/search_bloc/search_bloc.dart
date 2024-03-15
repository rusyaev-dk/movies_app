import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
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
      SearchNetworkConnectedEvent event, Emitter<SearchState> emit) {
    emit(SearchState());
  }

  void _onNetworkError(
      SearchNetworkErrorEvent event, Emitter<SearchState> emit) {
    emit(SearchFailureState(
        exception: ApiClientException(ApiClientExceptionType.network)));
  }

  Future<void> _onSearchMulti(
      SearchMultiEvent event, Emitter<SearchState> emit) async {
    try {
      if (event.query.isEmpty) return;

      emit(SearchLoadingState(query: event.query));

      final searchModels = await _mediaRepository.onGetSearchMultiMedia(
        query: event.query,
        locale: event.locale,
        page: event.page,
      );

      emit(SearchLoadedState(searchModels: searchModels));
    } on ApiClientException catch (exception) {
      emit(SearchFailureState(exception: exception, query: event.query));
    } catch (err) {
      print("ERROR !!!!");
    }
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
