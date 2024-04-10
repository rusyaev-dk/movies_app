import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/clients/media_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

enum ApiQueryType {
  popularMovies,
  trendingMovies,
  popularTVSeries,
  trendingTVSeries,
}

extension MediaTypeAsString on ApiQueryType {
  String asString() {
    switch (this) {
      case ApiQueryType.popularMovies:
        return 'popularMovies';
      case ApiQueryType.trendingMovies:
        return 'trendingMovies';
      case ApiQueryType.popularTVSeries:
        return 'popularTVSeries';
      case ApiQueryType.trendingTVSeries:
        return 'trendingTVSeries';
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

  Future<MediaRepositoryPattern<List<T>>> onGetMediaModels<T>({
    required ApiQueryType type,
    required String locale,
    required int page,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (type) {
        case ApiQueryType.popularMovies:
          response = await _mediaApiClient.getPopularMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJson;
          break;
        case ApiQueryType.trendingMovies:
          response = await _mediaApiClient.getTrendingMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJson;
          break;
        case ApiQueryType.popularTVSeries:
          response = await _mediaApiClient.getPopularTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
          break;
        case ApiQueryType.trendingTVSeries:
          response = await _mediaApiClient.getTrendingTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJson;
          break;
        default:
          response = null;
          fromJson = null;
          break;
      }

      List<T> models =
          _createModelsList<T>(fromJson: fromJson!, response: response!);
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
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
}
