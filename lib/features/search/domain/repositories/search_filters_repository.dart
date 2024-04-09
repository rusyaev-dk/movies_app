import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';

abstract class FiltersKeys {
  static const String showMediaTypeKey = "show_media_type";
  static const String genresKey = "genres";
  static const String sortByKey = "sort_by";
  static const String ratingKey = "rating";
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
        break;
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
        break;
      case (null, final List<String> resGenresFilter):
        genresFilter = resGenresFilter;
    }

    keyValueStorageRepoPattern = await _keyValueStorageRepository.get<String>(
        key: FiltersKeys.sortByKey);

    SortByFilter? sortByFilter;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        sortByFilter = SortByFilter.rating;
        break;
      case (null, final String resSortByFilter):
        sortByFilter = SortByFilterX.fromString(resSortByFilter);
    }

    keyValueStorageRepoPattern =
        await _keyValueStorageRepository.get<int>(key: FiltersKeys.ratingKey);

    int? ratingFilter;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        ratingFilter = 5;
        break;
      case (null, final int resRatingFilter):
        ratingFilter = resRatingFilter;
    }

    SearchFiltersModel searchFiltersModel = SearchFiltersModel(
      showMediaTypeFilter: showMediaTypeFilter!,
      genresFilter: genresFilter!,
      sortByFilter: sortByFilter!,
      ratingFilter: ratingFilter!,
    );
    return searchFiltersModel;
  }

  Future<SearchFiltersModel> resetFiltersModel() async {
    KeyValueStorageRepositoryPattern keyValueStorageRepoPattern =
        await _keyValueStorageRepository.set<String>(
      key: FiltersKeys.showMediaTypeKey,
      value: ShowMediaTypeFilter.all.asString(),
    );

    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        // print("Error");
        break;
      case (null, true):
        break;
    }

    keyValueStorageRepoPattern =
        await _keyValueStorageRepository.set<List<String>>(
      key: FiltersKeys.genresKey,
      value: [],
    );

    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        // print("Error");
        break;
      case (null, true):
        break;
    }

    keyValueStorageRepoPattern = await _keyValueStorageRepository.set<String>(
      key: FiltersKeys.sortByKey,
      value: SortByFilter.rating.asString(),
    );

    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        // print("Error");
        break;
      case (null, true):
        break;
    }

    keyValueStorageRepoPattern = await _keyValueStorageRepository.set<int>(
      key: FiltersKeys.ratingKey,
      value: 5,
    );

    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        // print("Error");
        break;
      case (null, true):
        break;
    }

    return SearchFiltersModel(
      showMediaTypeFilter: ShowMediaTypeFilter.all,
      genresFilter: [],
      sortByFilter: SortByFilter.rating,
      ratingFilter: 5,
    );
  }
}
