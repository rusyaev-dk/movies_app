import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:movies_app/core/data/api/clients/media_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

enum ApiMediaQueryType {
  popularMovies,
  trendingMovies,
  popularTVSeries,
  trendingTVSeries,
  onTheAirTVSeries,
  popularPersons,
}

extension ApiMediaQueryTypeX on ApiMediaQueryType {
  String asString() {
    switch (this) {
      case ApiMediaQueryType.popularMovies:
        return 'popular_movies';
      case ApiMediaQueryType.trendingMovies:
        return 'trending_movies';
      case ApiMediaQueryType.popularTVSeries:
        return 'popular_tv_series';
      case ApiMediaQueryType.trendingTVSeries:
        return 'trending_tv_series';
      case ApiMediaQueryType.onTheAirTVSeries:
        return 'on_the_air_tv_series';
      case ApiMediaQueryType.popularPersons:
        return 'popular_persons';
    }
  }

  String asAppBarTitle() {
    switch (this) {
      case ApiMediaQueryType.popularMovies:
        return 'Popular movies';
      case ApiMediaQueryType.trendingMovies:
        return 'Trending movies';
      case ApiMediaQueryType.popularTVSeries:
        return 'Popular TV series';
      case ApiMediaQueryType.trendingTVSeries:
        return 'Trending TV series';
      case ApiMediaQueryType.onTheAirTVSeries:
        return 'On the air';
      case ApiMediaQueryType.popularPersons:
        return 'Popular persons';
    }
  }

  static ApiMediaQueryType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'popular_movies':
        return ApiMediaQueryType.popularMovies;
      case 'trending_movies':
        return ApiMediaQueryType.trendingMovies;
      case 'popular_tv_series':
        return ApiMediaQueryType.popularTVSeries;
      case 'trending_tv_series':
        return ApiMediaQueryType.trendingTVSeries;
      case 'on_the_air_tv_series':
        return ApiMediaQueryType.onTheAirTVSeries;
      case 'popular_persons':
        return ApiMediaQueryType.popularPersons;
      default:
        return ApiMediaQueryType.popularMovies;
    }
  }
}

typedef MediaRepositoryPattern<T> = (ApiRepositoryFailure?, T?);

extension MediaRepositoryPatternX<T> on MediaRepositoryPattern<T> {
  ApiRepositoryFailure? get failure => $1;

  T? get value => $2;
}

class MediaRepository {
  final MediaApiClient _mediaApiClient = MediaApiClient();
  final Logger _logger = Logger("MediaRepo");

  List<T> _createModelsList<T>({
    required TMDBModel Function(Map<String, dynamic>) fromJson,
    required Response response,
    String? jsonKey = "results",
  }) {
    List<T> models = (response.data[jsonKey] as List)
        .map((json) => fromJson(json) as T)
        .toList();
    return models;
  }

  Future<MediaRepositoryPattern<List<T>>> onGetMediaModelsFromQueryType<T>({
    required ApiMediaQueryType queryType,
    required String locale,
    required int page,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (queryType) {
        case ApiMediaQueryType.popularMovies:
          response = await _mediaApiClient.getPopularMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJson;
          break;
        case ApiMediaQueryType.trendingMovies:
          response = await _mediaApiClient.getTrendingMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJson;
          break;
        case ApiMediaQueryType.popularTVSeries:
          response = await _mediaApiClient.getPopularTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
          break;
        case ApiMediaQueryType.trendingTVSeries:
          response = await _mediaApiClient.getTrendingTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
          break;
        case ApiMediaQueryType.onTheAirTVSeries:
          response = await _mediaApiClient.getOnTheAirTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
          break;
        case ApiMediaQueryType.popularPersons:
          response = await _mediaApiClient.getPopularPersons(
              locale: locale, page: page);
          fromJson = PersonModel.fromJson;
          break;
        default:
          response = null;
          fromJson = null;
          break;
      }

      if (response!.data["success"] == false) return (null, <T>[]);

      List<T> models =
          _createModelsList<T>(fromJson: fromJson!, response: response);
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<TMDBModel>>> onSearchMultiMedia({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.searchMultiMedia(
        query: query,
        locale: locale,
        page: page,
      );

      List<TMDBModel> models = [];
      for (Map<String, dynamic> json in response.data["results"] as List) {
        if (json["media_type"] == TMDBMediaType.movie.asString()) {
          models.add(MovieModel.fromJson(json));
        } else if (json["media_type"] == TMDBMediaType.tv.asString()) {
          models.add(TVSeriesModel.fromJson(json));
        } else if (json["media_type"] == TMDBMediaType.person.asString()) {
          models.add(PersonModel.fromJson(json));
        } else {
          throw ApiJsonKeyException(ApiClientExceptionType.jsonKey);
        }
      }
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<MediaRepositoryPattern<List<MovieModel>>> onSearchMovies({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.searchMovies(
        query: query,
        locale: locale,
        page: page,
      );

      List<MovieModel> models = _createModelsList<MovieModel>(
          fromJson: MovieModel.fromJson, response: response);
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<TVSeriesModel>>> onSearchTVSeries({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.searchTVSeries(
        query: query,
        locale: locale,
        page: page,
      );

      List<TVSeriesModel> models = _createModelsList<TVSeriesModel>(
          fromJson: TVSeriesModel.fromJson, response: response);
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<PersonModel>>> onSearchPersons({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.searchPersons(
        query: query,
        locale: locale,
        page: page,
      );

      List<PersonModel> models = _createModelsList<PersonModel>(
          fromJson: PersonModel.fromJson, response: response);
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<T>> onGetMediaDetails<T>({
    required TMDBMediaType mediaType,
    required int mediaId,
    required String locale,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (mediaType) {
        case TMDBMediaType.movie:
          response = await _mediaApiClient.getMovieDetails(
              movieId: mediaId, locale: locale);
          fromJson = MovieModel.fromJson;
        case TMDBMediaType.tv:
          response = await _mediaApiClient.getTVSeriesDetails(
              tvSeriesId: mediaId, locale: locale);
          fromJson = TVSeriesModel.fromJson;
        case TMDBMediaType.person:
          response = await _mediaApiClient.getPersonDetails(
              personId: mediaId, locale: locale);
          fromJson = PersonModel.fromJson;
        default:
          response = null;
          fromJson = null;
      }

      final T model = fromJson!(response!.data as Map<String, dynamic>) as T;
      return (null, model);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<PersonModel>>> onGetMediaCredits({
    required TMDBMediaType mediaType,
    required int mediaId,
    required String locale,
  }) async {
    try {
      final Response? response;
      switch (mediaType) {
        case TMDBMediaType.movie:
          response = await _mediaApiClient.getMovieCredits(
              movieId: mediaId, locale: locale);
        case TMDBMediaType.tv:
          response = await _mediaApiClient.getTVSeriesCredits(
              tvSeriesId: mediaId, locale: locale);
        default:
          response = null;
      }

      final List<PersonModel> models = _createModelsList<PersonModel>(
        fromJson: PersonModel.fromJson,
        response: response!,
        jsonKey: "cast",
      );
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<MediaImageModel>>> onGetMediaImages({
    required TMDBMediaType mediaType,
    required int mediaId,
    required String locale,
  }) async {
    try {
      final Response? response;
      switch (mediaType) {
        case TMDBMediaType.movie:
          response = await _mediaApiClient.getMovieImages(
              movieId: mediaId, locale: locale);
        case TMDBMediaType.tv:
          response = await _mediaApiClient.getTVSeriesImages(
              tvSeriesId: mediaId, locale: locale);
        default:
          response = null;
      }

      final List<MediaImageModel> models = _createModelsList<MediaImageModel>(
        fromJson: MediaImageModel.fromJSON,
        response: response!,
        jsonKey: "backdrops",
      );

      return (null, models.reversed.toList());
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<MediaRepositoryPattern<List<T>>> onGetSimilarMedia<T>({
    required TMDBMediaType mediaType,
    required int mediaId,
    required String locale,
    required int page,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (mediaType) {
        case TMDBMediaType.movie:
          response = await _mediaApiClient.getSimilarMovies(
              movieId: mediaId, locale: locale, page: page);
          fromJson = MovieModel.fromJson;
        case TMDBMediaType.tv:
          response = await _mediaApiClient.getSimilarTVSeries(
              tvSeriesId: mediaId, locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
        default:
          response = null;
          fromJson = null;
      }

      final List<T> models = _createModelsList<T>(
        fromJson: fromJson!,
        response: response!,
        jsonKey: "results",
      );

      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
       _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
       _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return ((exception, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
