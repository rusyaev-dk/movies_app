import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';

part 'search_filters_event.dart';
part 'search_filters_state.dart';

class SearchFiltersBloc extends Bloc<SearchFiltersEvent, SearchFiltersState> {
  late final KeyValueStorageRepository _keyValueStorageRepository;
  late final SearchFiltersRepository _searchFiltersRepository;
  late final SearchBloc _searchBloc;

  SearchFiltersBloc({
    required KeyValueStorageRepository keyValueStorageRepository,
    required SearchFiltersRepository searchFiltersRepository,
    required SearchBloc searchBloc,
  })  : _keyValueStorageRepository = keyValueStorageRepository,
        _searchFiltersRepository = searchFiltersRepository,
        _searchBloc = searchBloc,
        super(SearchFiltersLoadingState()) {
    on<SearchFiltersRestoreFiltersEvent>(_onRestoreSearchFiltersModel);
    on<SearchFiltersSetShowMediaTypeFilterEvent>(_onSetShowMediaTypeFilter);
    on<SearchFiltersSetSortByFilterEvent>(_onSetSortByFilter);
    on<SearchFiltersSetRatingFilterEvent>(_onSetRatingFilter);
    on<SearchFiltersApplyFiltersEvent>(_onApplyFilters);
    on<SearchFiltersResetFiltersEvent>(_onResetFilters);
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
    SearchFiltersSetShowMediaTypeFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    KeyValueStorageRepositoryPattern sharedPrefsRepoPattern =
        await _keyValueStorageRepository.set<String>(
      key: KeyValueStorageKeys.showMediaTypeKey,
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
              ratingFilter: event.prevFiltersModel.ratingFilter,
            ),
          ),
        );
    }
  }

  Future<void> _onSetSortByFilter(
    SearchFiltersSetSortByFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    KeyValueStorageRepositoryPattern sharedPrefsRepoPattern =
        await _keyValueStorageRepository.set<String>(
      key: KeyValueStorageKeys.sortByKey,
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
              ratingFilter: event.prevFiltersModel.ratingFilter,
            ),
          ),
        );
    }
  }

  Future<void> _onSetRatingFilter(
    SearchFiltersSetRatingFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    KeyValueStorageRepositoryPattern sharedPrefsRepoPattern =
        await _keyValueStorageRepository.set<int>(
      key: KeyValueStorageKeys.ratingKey,
      value: event.ratingFilter,
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
              sortByFilter: event.prevFiltersModel.sortByFilter,
              ratingFilter: event.ratingFilter,
            ),
          ),
        );
    }
  }

  Future<void> _onApplyFilters(
    SearchFiltersApplyFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    final KeyValueStorageRepositoryPattern keyValueStorageRepoPattern =
        await _keyValueStorageRepository.get<String>(
            key: KeyValueStorageKeys.searchQueryKey);

    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        //
        return;
      case (null, final String resSearchQuery):
        return _searchBloc.add(SearchMediaEvent(query: resSearchQuery));
    }
  }

  Future<void> _onResetFilters(
    SearchFiltersResetFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    emit(SearchFiltersLoadingState());
    final SearchFiltersModel cleanFiltersModel =
        await _searchFiltersRepository.resetFiltersModel();
    emit(SearchFiltersLoadedState(searchFiltersModel: cleanFiltersModel));
  }
}
