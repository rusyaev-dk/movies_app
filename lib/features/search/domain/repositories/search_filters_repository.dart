import 'package:movies_app/persistence/storage/storage_interface.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';

abstract class KeyValueStorageKeys {
  static const String showMediaTypeKey = "show_media_type";
  static const String genresKey = "genres";
  static const String sortByKey = "sort_by";
  static const String ratingKey = "rating";
  static const String searchQueryKey = "search_query";
}

class SearchFiltersRepository {
  SearchFiltersRepository({
    required KeyValueStorage keyValueStorage,
  }) : _keyValueStorage = keyValueStorage {
    _keyValueStorage.delete(key: KeyValueStorageKeys.searchQueryKey);
  }

  final KeyValueStorage _keyValueStorage;

  Future<SearchFiltersModel> restoreFiltersModel() async {
    final String? showMediaTypeFilterStr = await _keyValueStorage.get<String?>(
        key: KeyValueStorageKeys.showMediaTypeKey);
    ShowMediaTypeFilter showMediaTypeFilter =
        ShowMediaTypeFilterX.fromString(showMediaTypeFilterStr);

    final List<String> genresFilter = await _keyValueStorage.get<List<String>>(
            key: KeyValueStorageKeys.genresKey) ??
        SearchFiltersModel.defaultGenresFilter;

    final String? sortByFilterStr =
        await _keyValueStorage.get<String?>(key: KeyValueStorageKeys.sortByKey);
    final SortByFilter sortByFilter = SortByFilterX.fromString(sortByFilterStr);

    int? ratingFilter =
        await _keyValueStorage.get<int?>(key: KeyValueStorageKeys.ratingKey) ??
            SearchFiltersModel.defaultRatingFilter;

    return SearchFiltersModel(
      showMediaTypeFilter: showMediaTypeFilter,
      genresFilter: genresFilter,
      sortByFilter: sortByFilter,
      ratingFilter: ratingFilter,
    );
  }

  Future<void> resetFiltersModel() async {
    await _keyValueStorage.set<String>(
      key: KeyValueStorageKeys.showMediaTypeKey,
      value: SearchFiltersModel.defaultShowMediaTypeFilter.asString(),
    );

    await _keyValueStorage.set<List<String>>(
      key: KeyValueStorageKeys.genresKey,
      value: SearchFiltersModel.defaultGenresFilter,
    );

    await _keyValueStorage.set<String>(
      key: KeyValueStorageKeys.sortByKey,
      value: SearchFiltersModel.defaultSortByFiler.asString(),
    );

    await _keyValueStorage.set<int>(
      key: KeyValueStorageKeys.ratingKey,
      value: SearchFiltersModel.defaultRatingFilter,
    );
  }
}
