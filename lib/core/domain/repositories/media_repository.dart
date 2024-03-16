import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/clients/media_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

enum MediaType {
  popularMovies,
  trendingMovies,
  popularTVSeries,
  trendingTVSeries,
}

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.popularMovies:
        return 'popularMovies';
      case MediaType.trendingMovies:
        return 'trendingMovies';
      case MediaType.popularTVSeries:
        return 'popularTVSeries';
      case MediaType.trendingTVSeries:
        return 'trendingTVSeries';
    }
  }
}

typedef MediaRepositoryPattern<T> = (RepositoryFailure?, List<T>?);

extension MediaRepositoryPatternX<T> on MediaRepositoryPattern<T> {
  RepositoryFailure? get failure => $1;

  List<T>? get modelsList => $2;
}

class MediaRepository {
  final MediaApiClient _mediaApiClient = MediaApiClient();

  List<T> _createModelsList<T>(
      TMDBModel Function(Map<String, dynamic>)? fromJson, Response response) {
    List<T> models = (response.data['results'] as List)
        .map((json) => fromJson!(json) as T)
        .toList();
    return models;
  }

  Future<MediaRepositoryPattern<T>> onGetMediaModels<T>({
    required MediaType type,
    required String locale,
    required int page,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (type) {
        case MediaType.popularMovies:
          response = await _mediaApiClient.getPopularMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJSON;
          break;
        case MediaType.trendingMovies:
          response = await _mediaApiClient.getTrendingMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJSON;
          break;
        case MediaType.popularTVSeries:
          response = await _mediaApiClient.getPopularTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJSON;
          break;
        case MediaType.trendingTVSeries:
          response = await _mediaApiClient.getTrendingTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJSON;
          break;
        default:
          response = null;
          fromJson = null;
          break;
      }

      List<T> models = _createModelsList(fromJson, response!);
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

      RepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<MediaRepositoryPattern> onGetSearchMultiMedia({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.getSearchMultiMedia(
        query: query,
        locale: locale,
        page: page,
      );

      List<TMDBModel> searchModels = [];
      for (Map<String, dynamic> json in response.data["results"] as List) {
        if (json["media_type"] == TMDBMediaType.movie.asString()) {
          searchModels.add(MovieModel.fromJSON(json));
        } else if (json["media_type"] == TMDBMediaType.tv.asString()) {
          searchModels.add(TVSeriesModel.fromJSON(json));
        } else if (json["media_type"] == TMDBMediaType.person.asString()) {
          searchModels.add(PersonModel.fromJSON(json));
        } else {
          throw ApiJsonKeyException(ApiClientExceptionType.jsonKey);
        }
      }
      return (null, searchModels);
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

      RepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
