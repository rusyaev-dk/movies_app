enum TMDBMediaType { movie, tv, person }

extension TMDBMediaTypeAsString on TMDBMediaType {
  String asString() {
    switch (this) {
      case TMDBMediaType.movie:
        return 'movie';
      case TMDBMediaType.tv:
        return 'tv';
      case TMDBMediaType.person:
        return 'person';
    }
  }
}

abstract class TMDBModel {
  TMDBModel._();

  factory TMDBModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
        'fromJson() method must be implemented in subclass.');
  }
}

class MovieModel extends TMDBModel {
  final bool? adult;
  final String? backdropPath;
  final int? id;
  final String? title;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final dynamic popularity;
  final dynamic voteAverage;
  final dynamic voteCount;

  final String? releaseDate;
  final dynamic budget;
  final dynamic revenue;
  final dynamic runtime;

  MovieModel({
    this.adult,
    this.id,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.popularity,
    this.title,
    this.voteAverage,
    this.voteCount,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.budget,
    this.revenue,
    this.runtime,
  }): super._();

  @override
  factory MovieModel.fromJSON(Map<String, dynamic> json) {
    return MovieModel(
      adult: json["adult"],
      id: json["id"],
      originalTitle: json["original_title"],
      originalLanguage: json["original_language"],
      overview: json["overview"],
      popularity: json["popularity"],
      releaseDate: json["release_date"],
      title: json["title"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
      posterPath: json["poster_path"],
      backdropPath: json["backdrop_path"],
      budget: json["budget"],
      revenue: json["revenue"],
      runtime: json["runtime"],
    );
  }
}

class TVSeriesModel extends TMDBModel {
  final bool? adult;
  final String? backdropPath;
  final String? firstAirDate;
  final int? id;
  final String? name;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final dynamic popularity;
  final String? posterPath;
  final dynamic voteAverage;
  final dynamic voteCount;

  final List<String>? languages;
  final String? lastAirDate;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final bool? inProduction;
  final String? homepage;
  final String? status;
  final String? tagline;
  final String? type;

  TVSeriesModel({
    this.adult,
    this.backdropPath,
    this.firstAirDate,
    this.id,
    this.name,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.voteAverage,
    this.voteCount,
    this.homepage,
    this.languages,
    this.lastAirDate,
    this.inProduction,
    this.status,
    this.tagline,
    this.type,
    this.numberOfEpisodes,
    this.numberOfSeasons,
  }): super._();

  @override
  factory TVSeriesModel.fromJSON(Map<String, dynamic> json) {
    return TVSeriesModel(
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      firstAirDate: json["first_air_date"],
      homepage: json["homepage"] ?? "None",
      id: json["id"],
      inProduction: json["in_production"],
      languages: json["languages"],
      lastAirDate: json["last_air_date"] ?? "None",
      name: json["name"],
      numberOfEpisodes: json["number_of_episodes"],
      numberOfSeasons: json["number_of_seasons"],
      originalLanguage: json["original_language"],
      originalName: json["original_name"],
      overview: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      status: json["status"],
      tagline: json["tag_line"],
      type: json["type"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
    );
  }
}

class PersonModel extends TMDBModel {
  final int? id;
  final String? name;
  final String? originalName;
  final dynamic popularity;
  final int? gender;
  final String? profilePath;

  PersonModel({
    required this.id,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.gender,
    required this.profilePath,
  }): super._();

  @override
  factory PersonModel.fromJSON(Map<String, dynamic> json) {
    return PersonModel(
      id: json["id"],
      name: json["name"],
      originalName: json["original_name"],
      popularity: json["popularity"],
      gender: json["gender"],
      profilePath: json["profile_path"],
    );
  }
}
