import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/persistence/storage/storage_interface.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'search_filters_event.dart';
part 'search_filters_state.dart';

class SearchFiltersBloc extends Bloc<SearchFiltersEvent, SearchFiltersState> {
  late final KeyValueStorage _keyValueStorage;
  late final SearchFiltersRepository _searchFiltersRepository;
  late final SearchBloc _searchBloc;

  SearchFiltersBloc({
    required KeyValueStorage keyValueStorage,
    required SearchFiltersRepository searchFiltersRepository,
    required SearchBloc searchBloc,
  })  : _keyValueStorage = keyValueStorage,
        _searchFiltersRepository = searchFiltersRepository,
        _searchBloc = searchBloc,
        super(SearchFiltersLoadingState()) {
    on<SearchFiltersRestoreFiltersEvent>(_onRestoreSearchFiltersModel);
    add(SearchFiltersRestoreFiltersEvent());

    on<SearchFiltersSetShowMediaTypeFilterEvent>(_onSetShowMediaTypeFilter);
    on<SearchFiltersSetSortByFilterEvent>(_onSetSortByFilter);
    on<SearchFiltersSetRatingFilterEvent>(_onSetRatingFilter,
        transformer: debounceDroppable(
          const Duration(milliseconds: 25),
        ));
    on<SearchFiltersApplyFiltersEvent>(_onApplyFilters);
    on<SearchFiltersResetFiltersEvent>(_onResetFilters);
  }

  Future<void> _onRestoreSearchFiltersModel(
    SearchFiltersRestoreFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    emit(SearchFiltersLoadingState());
    SearchFiltersModel restoredFiltersModel;
    try {
      restoredFiltersModel =
          await _searchFiltersRepository.restoreFiltersModel();
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
      restoredFiltersModel = SearchFiltersModel.defaultFilters();
    }
    emit(SearchFiltersLoadedState(searchFiltersModel: restoredFiltersModel));
  }

  Future<void> _onSetShowMediaTypeFilter(
    SearchFiltersSetShowMediaTypeFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    try {
      await _keyValueStorage.set<String>(
        key: KeyValueStorageKeys.showMediaTypeKey,
        value: event.showMediaTypeFilter.asString(),
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(
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

  Future<void> _onSetSortByFilter(
    SearchFiltersSetSortByFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    try {
      await _keyValueStorage.set<String>(
        key: KeyValueStorageKeys.sortByKey,
        value: event.sortByFilter.asString(),
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

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

  Future<void> _onSetRatingFilter(
    SearchFiltersSetRatingFilterEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    try {
      await _keyValueStorage.set<int>(
        key: KeyValueStorageKeys.ratingKey,
        value: event.ratingFilter,
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(
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

  Future<void> _onApplyFilters(
    SearchFiltersApplyFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    String? searchQuery;
    try {
      searchQuery = await _keyValueStorage.get<String?>(
          key: KeyValueStorageKeys.searchQueryKey);
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    if (searchQuery == null || searchQuery.isEmpty) {
      return;
    }
    return _searchBloc.add(SearchMediaEvent(query: searchQuery));
  }

  Future<void> _onResetFilters(
    SearchFiltersResetFiltersEvent event,
    Emitter<SearchFiltersState> emit,
  ) async {
    emit(SearchFiltersLoadingState());

    try {
      await _searchFiltersRepository.resetFiltersModel();
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(SearchFiltersLoadedState(
      searchFiltersModel: SearchFiltersModel.defaultFilters(),
    ));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
