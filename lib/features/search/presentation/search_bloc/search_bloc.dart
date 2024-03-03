import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/tmdb_media_repository.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/utils/exceptions.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final TMDBMediaRepository _tmdbMediaRepository;

  SearchBloc({required TMDBMediaRepository tmdbMediaRepository})
      : _tmdbMediaRepository = tmdbMediaRepository,
        super(SearchState()) {
    on<SearchMultiEvent>(
      _onSearchMulti,
      transformer: debounceDroppable(
        const Duration(milliseconds: 300),
      ),
    );
  }

  _onSearchMulti(SearchMultiEvent event, Emitter<SearchState> emit) async {
    try {
      if (event.query.isEmpty) return emit(SearchState(searchModels: const []));
      if (event.query.length < 3) return;
      final searchModels = await _tmdbMediaRepository.onGetSearchMultiMedia(
        query: event.query,
        locale: event.locale,
        page: event.page,
      );
      emit(SearchState(searchModels: searchModels));
    } on ApiClientException catch (err) {
      print("ошибка: ${err.type}");
      emit(SearchState());
    } catch (err) {
      print("произошла ошипка: $err");
      emit(SearchState());
    }
  }
}
