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

typedef MediaRepositoryPattern<T> = (RepositoryFailure?, T?);

extension MediaRepositoryPatternX<T> on MediaRepositoryPattern<T> {
  RepositoryFailure? get failure => $1;

  T? get value => $2;
}

class MediaRepository {
  final MediaApiClient _mediaApiClient = MediaApiClient();

  List<T> _createModelsList<T>(
      TMDBModel Function(Map<String, dynamic>) fromJson, Response response) {
    List<T> models = (response.data['results'] as List)
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
          fromJson = MovieModel.fromJSON;
          break;
        case ApiQueryType.trendingMovies:
          response = await _mediaApiClient.getTrendingMovies(
              locale: locale, page: page);
          fromJson = MovieModel.fromJSON;
          break;
        case ApiQueryType.popularTVSeries:
          response = await _mediaApiClient.getPopularTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJSON;
          break;
        case ApiQueryType.trendingTVSeries:
          response = await _mediaApiClient.getTrendingTVSeries(
              locale: locale, page: page);
          fromJson = TVSeriesModel.fromJSON;
          break;
        default:
          response = null;
          fromJson = null;
          break;
      }

      List<T> models = _createModelsList(fromJson!, response!);
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

  Future<MediaRepositoryPattern<List<TMDBModel>>> onGetSearchMultiMedia({
    required String query,
    required String locale,
    required int page,
  }) async {
    try {
      final response = await _mediaApiClient.getSearchMultiMedia(
        query: query,
        language: locale,
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
          fromJson = MovieModel.fromJSON;
        case TMDBMediaType.tv:
          response = await _mediaApiClient.getTVSeriesDetails(
              tvSeriesId: mediaId, locale: locale);
          fromJson = TVSeriesModel.fromJSON;
        case TMDBMediaType.person:
          response = await _mediaApiClient.getPersonDetails(
              personId: mediaId, locale: locale);
          fromJson = PersonModel.fromJSON;
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

      RepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
