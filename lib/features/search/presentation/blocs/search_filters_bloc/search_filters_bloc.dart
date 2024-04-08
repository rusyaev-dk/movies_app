import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';

part 'search_filters_event.dart';
part 'search_filters_state.dart';

class SearchFiltersBloc extends Bloc<SearchFiltersEvent, SearchFiltersState> {
  late final KeyValueStorageRepository _keyValueStorageRepository;
  late final SearchFiltersRepository _searchFiltersRepository;

  SearchFiltersBloc({
    required KeyValueStorageRepository keyValueStorageRepository,
    required SearchFiltersRepository searchFiltersRepository,
  })  : _keyValueStorageRepository = keyValueStorageRepository,
        _searchFiltersRepository = searchFiltersRepository,
        super(SearchFiltersLoadingState()) {
    on<SearchFiltersRestoreFiltersEvent>(_onRestoreSearchFiltersModel);
    on<SearchFiltersSetShowMediaTypeEvent>(_onSetShowMediaTypeFilter);
    on<SearchFiltersSetSortByEvent>(_onSetSortByFilter);
    add(SearchFiltersRestoreFiltersEvent());
  }

  Future<void> _onRestoreSearchFiltersModel(
    SearchFiltersRestoreFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    emit(SearchFiltersLoadingState());
    final SearchFiltersModel searchFiltersModel =
        await _searchFiltersRepository.loadFiltersModel();
    emit(SearchFiltersLoadedState(searchFiltersModel: searchFiltersModel));
  }

  Future<void> _onSetShowMediaTypeFilter(
    SearchFiltersSetShowMediaTypeEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    KeyValueStorageRepositoryPattern sharedPrefsRepoPattern =
        await _keyValueStorageRepository.set<String>(
      key: FiltersKeys.showMediaTypeKey,
      value: event.showMediaTypeFilter.asString(),
    );

    switch (sharedPrefsRepoPattern) {
      case (final StorageRepositoryFailure failure, null):
        return emit(SearchFiltersFailureState(failure: failure));
      case (null, true):
        return emit(
          SearchFiltersLoadedState(
            searchFiltersModel: SearchFiltersModel(
              showMediaTypeFilter: event.showMediaTypeFilter,
              genresFilter: event.prevFiltersModel.genresFilter,
              sortByFilter: event.prevFiltersModel.sortByFilter,
            ),
          ),
        );
    }
  }

  Future<void> _onSetSortByFilter(
    SearchFiltersSetSortByEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    KeyValueStorageRepositoryPattern sharedPrefsRepoPattern =
        await _keyValueStorageRepository.set<String>(
      key: FiltersKeys.sortByKey,
      value: event.sortByFilter.asString(),
    );

    switch (sharedPrefsRepoPattern) {
      case (final StorageRepositoryFailure failure, null):
        return emit(SearchFiltersFailureState(failure: failure));
      case (null, true):
        return emit(
          SearchFiltersLoadedState(
            searchFiltersModel: SearchFiltersModel(
              showMediaTypeFilter: event.prevFiltersModel.showMediaTypeFilter,
              genresFilter: event.prevFiltersModel.genresFilter,
              sortByFilter: event.sortByFilter,
            ),
          ),
        );
    }
  }
}
