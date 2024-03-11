import 'package:movies_app/core/data/api/clients/media_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';

class MediaRepository {
  final MediaApiClient _mediaApiClient = MediaApiClient();

  Future<List<T>> _createModelsList<T>(
      T Function(Map<String, dynamic>) fromJson, dynamic response) async {
    try {
      List<T> models = (response.data['results'] as List)
          .map((json) => fromJson(json))
          .toList();
      return models;
    } on ApiClientException {
      rethrow;
    } catch (err) {
      print('Произошла ошибка: $err');
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<List<MovieModel>> onGetPopularMovies({
    required String locale,
    required int page,
  }) async {
    final response = await _mediaApiClient.getPopularMovies(
      locale: locale,
      page: page,
    );
    List<MovieModel> popularMovies =
        await _createModelsList<MovieModel>(MovieModel.fromJSON, response);
    return popularMovies;
  }

  Future<List<MovieModel>> onGetTrendingMovies({
    required String locale,
    required int page,
  }) async {
    final response = await _mediaApiClient.getTrendingMovies(
      locale: locale,
      page: page,
    );
    List<MovieModel> popularMovies =
        await _createModelsList<MovieModel>(MovieModel.fromJSON, response);
    return popularMovies;
  }

  Future<List<TVSeriesModel>> onGetPopularTVSeries({
    required String locale,
    required int page,
  }) async {
    final response = await _mediaApiClient.getPopularTVSeries(
      locale: locale,
      page: page,
    );
    List<TVSeriesModel> popularTVSeries =
        await _createModelsList<TVSeriesModel>(
            TVSeriesModel.fromJSON, response);
    return popularTVSeries;
  }

  Future<List<TVSeriesModel>> onGetTrendingTVSeries({
    required String locale,
    required int page,
  }) async {
    final response = await _mediaApiClient.getTrendingTVSeries(
      locale: locale,
      page: page,
    );
    List<TVSeriesModel> trendingTVSeries =
        await _createModelsList<TVSeriesModel>(
            TVSeriesModel.fromJSON, response);
    return trendingTVSeries;
  }

  Future<List<TMDBModel>> onGetSearchMultiMedia({
    required String query,
    required String locale,
    required int page,
  }) async {
    final response = await _mediaApiClient.getSearchMultiMedia(
      query: query,
      locale: locale,
      page: page,
    );

    try {
      List<TMDBModel> searchModels = [];
      for (Map<String, dynamic> json in response.data["results"] as List) {
        if (json["media_type"] == TMDBMediaType.movie.asString()) {
          searchModels.add(MovieModel.fromJSON(json));
        } else if (json["media_type"] == TMDBMediaType.tv.asString()) {
          searchModels.add(TVSeriesModel.fromJSON(json));
        } else if (json["media_type"] == TMDBMediaType.person.asString()) {
          searchModels.add(PersonModel.fromJSON(json));
        } else {
          throw ApiClientException(ApiClientExceptionType.jsonKey);
        }
      }
      return searchModels;
    } on ApiClientException {
      rethrow;
    } catch (err) {
      print('Произошла ошибка: $err');
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }
}
