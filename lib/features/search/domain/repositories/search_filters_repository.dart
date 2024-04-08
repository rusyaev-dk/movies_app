import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';

abstract class FiltersKeys {
  static const String showMediaTypeKey = "show_media_type";
  static const String genresKey = "genres";
  static const String sortByKey = "sort_by";
}

class SearchFiltersRepository {
  late final KeyValueStorageRepository _keyValueStorageRepository;

  SearchFiltersRepository(
      {required KeyValueStorageRepository keyValueStorageRepository})
      : _keyValueStorageRepository = keyValueStorageRepository;

  Future<SearchFiltersModel> loadFiltersModel() async {
    KeyValueStorageRepositoryPattern keyValueStorageRepoPattern =
        await _keyValueStorageRepository.get<String>(
            key: FiltersKeys.showMediaTypeKey);

    ShowMediaTypeFilter? showMediaTypeFilter;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        showMediaTypeFilter = ShowMediaTypeFilter.all;
      case (null, final String resShowMediaTypeFilter):
        showMediaTypeFilter =
            ShowMediaTypeFilterX.fromString(resShowMediaTypeFilter);
    }

    keyValueStorageRepoPattern = await _keyValueStorageRepository
        .get<List<String>>(key: FiltersKeys.genresKey);

    List<String>? genresFilter;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        genresFilter = [];
      case (null, final List<String> resGenresFilter):
        genresFilter = resGenresFilter;
    }

    keyValueStorageRepoPattern = await _keyValueStorageRepository.get<String>(
        key: FiltersKeys.sortByKey);

    SortByFilter? sortByFilter;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        sortByFilter = SortByFilter.rating;
      case (null, final String resSortByFilter):
        sortByFilter = SortByFilterX.fromString(resSortByFilter);
    }

    SearchFiltersModel searchFiltersModel = SearchFiltersModel(
      showMediaTypeFilter: showMediaTypeFilter!,
      genresFilter: genresFilter!,
      sortByFilter: sortByFilter!,
    );
    return searchFiltersModel;
  }

  Future<void> resetFiltersModel() async {
    
  }
}
