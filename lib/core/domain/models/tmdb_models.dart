import 'package:equatable/equatable.dart';

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

abstract class TMDBModel extends Equatable {
  const TMDBModel._();

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

  final List<MediaGenre>? genres;
  final List<dynamic>? genreIds;
  final List<ProductionCountry>? productionCountries;
  final String? releaseDate;
  final dynamic budget;
  final dynamic revenue;
  final dynamic runtime;

  const MovieModel({
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
    this.genreIds,
    this.genres,
    this.productionCountries,
  }) : super._();

  @override
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    List<MediaGenre> genres = json["genres"] == null
        ? []
        : MediaGenre.fromJsonGenresList(json["genres"] as List<dynamic>);

    List<ProductionCountry> productionCountries =
        json["production_countries"] == null
            ? []
            : ProductionCountry.fromJsonProdCountriesList(
                json["production_countries"] as List<dynamic>);

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
      genreIds: json["genre_ids"],
      genres: genres,
      productionCountries: productionCountries,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        id,
        originalTitle,
        originalLanguage,
        overview,
        popularity,
        title,
        voteAverage,
        voteCount,
        posterPath,
        backdropPath,
        releaseDate,
        budget,
        revenue,
        runtime,
        genreIds,
        genres,
        productionCountries,
      ];
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

  final List<MediaGenre>? genres;
  final List<dynamic>? genreIds;
  final List<ProductionCountry>? productionCountries;

  final List<dynamic>? languages;
  final String? lastAirDate;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<dynamic>? episodeRunTime;
  final bool? inProduction;
  final String? homepage;
  final String? status;
  final String? tagline;
  final String? type;

  const TVSeriesModel({
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
    this.episodeRunTime,
    this.genreIds,
    this.genres,
    this.productionCountries,
  }) : super._();

  @override
  factory TVSeriesModel.fromJson(Map<String, dynamic> json) {
    List<MediaGenre> genres = json["genres"] == null
        ? []
        : MediaGenre.fromJsonGenresList(json["genres"] as List<dynamic>);

    List<ProductionCountry> productionCountries =
        json["production_countries"] == null
            ? []
            : ProductionCountry.fromJsonProdCountriesList(
                json["production_countries"] as List<dynamic>);

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
      episodeRunTime: json["episode_run_time"],
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
      genreIds: json["genre_ids"],
      genres: genres,
      productionCountries: productionCountries,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        id,
        name,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        homepage,
        languages,
        lastAirDate,
        inProduction,
        status,
        tagline,
        type,
        numberOfEpisodes,
        numberOfSeasons,
        episodeRunTime,
        genreIds,
        genres,
        productionCountries,
      ];
}

class PersonModel extends TMDBModel {
  final int? id;
  final int? gender;
  final String? name;
  final String? originalName;
  final String? birthday;
  final String? deathday;
  final String? biography;
  final dynamic popularity;
  final String? knownForDepartment;
  final String? profilePath;

  const PersonModel({
    this.id,
    this.gender,
    this.name,
    this.originalName,
    this.birthday,
    this.deathday,
    this.biography,
    this.popularity,
    this.knownForDepartment,
    this.profilePath,
  }) : super._();

  @override
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json["id"],
      gender: json["gender"],
      name: json["name"],
      originalName: json["original_name"],
      birthday: json["birthday"],
      deathday: json["deathday"],
      biography: json["biography"],
      popularity: json["popularity"],
      knownForDepartment: json["known_for_department"],
      profilePath: json["profile_path"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        originalName,
        birthday,
        deathday,
        biography,
        popularity,
        knownForDepartment,
        profilePath,
      ];
}

class MediaGenre {
  final dynamic id;
  final String? name;

  MediaGenre({
    this.id,
    this.name,
  });

  factory MediaGenre.fromJson(Map<String, dynamic> json) {
    return MediaGenre(
      id: json["id"],
      name: json["name"],
    );
  }

  static List<MediaGenre> fromJsonGenresList(List<dynamic> genresList) {
    List<MediaGenre> resultList = [];
    for (Map<String, dynamic> json in genresList) {
      resultList.add(MediaGenre.fromJson(json));
    }
    return resultList;
  }
}

class ProductionCountry {
  final String? iso_3166_1;
  final String? name;

  ProductionCountry({
    this.iso_3166_1,
    this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso_3166_1: json["iso_3166_1"],
      name: json["name"],
    );
  }

  static List<ProductionCountry> fromJsonProdCountriesList(
      List<dynamic> countriesList) {
    List<ProductionCountry> resultList = [];
    for (Map<String, dynamic> json in countriesList) {
      resultList.add(ProductionCountry.fromJson(json));
    }
    return resultList;
  }
}

class MediaImageModel extends TMDBModel {
  final dynamic aspectRatio;
  final dynamic height;
  final dynamic width;
  final String? filePath;

  const MediaImageModel({
    this.aspectRatio,
    this.height,
    this.width,
    this.filePath,
  }) : super._();

  @override
  factory MediaImageModel.fromJSON(Map<String, dynamic> json) {
    return MediaImageModel(
      aspectRatio: json["aspect_ratio"],
      height: json["height"],
      width: json["width"],
      filePath: json["file_path"],
    );
  }

  @override
  List<Object?> get props => [
        aspectRatio,
        height,
        width,
        filePath,
      ];
}

class AccountModel extends TMDBModel {
  final int? id;
  final String? name;
  final String? username;
  final String? avatarPath;

  const AccountModel({
    this.id,
    this.name,
    this.username,
    this.avatarPath,
  }) : super._();

  @override
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      avatarPath: json["avatar"]["tmdb"]["avatar_path"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        avatarPath,
      ];
}
