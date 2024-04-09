enum ShowMediaTypeFilter { all, movies, tvs, persons }

extension ShowMediaTypeFilterX on ShowMediaTypeFilter {
  String asString() {
    switch (this) {
      case ShowMediaTypeFilter.all:
        return 'all';
      case ShowMediaTypeFilter.movies:
        return 'movies';
      case ShowMediaTypeFilter.tvs:
        return 'tvs';
      case ShowMediaTypeFilter.persons:
        return 'persons';
      default:
        return '';
    }
  }

  static ShowMediaTypeFilter fromString(String value) {
    switch (value.toLowerCase()) {
      case 'all':
        return ShowMediaTypeFilter.all;
      case 'movies':
        return ShowMediaTypeFilter.movies;
      case 'tvs':
        return ShowMediaTypeFilter.tvs;
      case 'persons':
        return ShowMediaTypeFilter.persons;
      default:
        return ShowMediaTypeFilter.all;
    }
  }
}

enum SortByFilter { rating, popularity }

extension SortByFilterX on SortByFilter {
  String asString() {
    switch (this) {
      case SortByFilter.rating:
        return 'rating';
      case SortByFilter.popularity:
        return 'popularity';
      default:
        return '';
    }
  }

  static SortByFilter fromString(String value) {
    switch (value.toLowerCase()) {
      case 'rating':
        return SortByFilter.rating;
      case 'popularity':
        return SortByFilter.popularity;
      default:
        return SortByFilter.rating;
    }
  }
}

class SearchFiltersModel {
  final ShowMediaTypeFilter showMediaTypeFilter;
  final List<String> genresFilter;
  final SortByFilter sortByFilter;
  final int ratingFilter;

  SearchFiltersModel({
    required this.showMediaTypeFilter,
    required this.genresFilter,
    required this.sortByFilter,
    required this.ratingFilter,
  });

  SearchFiltersModel copyWith({
    ShowMediaTypeFilter? showMediaTypeFilter,
    List<String>? genresFilter,
    SortByFilter? sortByFilter,
    int? ratingFilter,
  }) {
    return SearchFiltersModel(
      showMediaTypeFilter: showMediaTypeFilter ?? this.showMediaTypeFilter,
      genresFilter: genresFilter ?? this.genresFilter,
      sortByFilter: sortByFilter ?? this.sortByFilter,
      ratingFilter: ratingFilter ?? this.ratingFilter,
    );
  }
}
