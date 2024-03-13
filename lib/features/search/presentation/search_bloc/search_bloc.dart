import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final MediaRepository _mediaRepository;

  SearchBloc({required MediaRepository mediaRepository})
      : _mediaRepository = mediaRepository,
        super(SearchState()) {
    on<SearchMultiEvent>(
      _onSearchMulti,
      transformer: debounceDroppable(
        const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _onSearchMulti(
      SearchMultiEvent event, Emitter<SearchState> emit) async {
    try {
      if (event.query.isEmpty) {
        emit(state.copyWith(searchModels: const []));
        return;
      }
      emit(state.copyWith(isLoading: true, query: event.query));
      
      final searchModels = await _mediaRepository.onGetSearchMultiMedia(
        query: event.query,
        locale: event.locale,
        page: event.page,
      );
      
      emit(state.copyWith(searchModels: searchModels));
    } on ApiClientException catch (exception) {
      emit(state.copyWith(exception: exception, query: event.query));
    } catch (err) {
      emit(state.copyWith());
    }
  }
}
