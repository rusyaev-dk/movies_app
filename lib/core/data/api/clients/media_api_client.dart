import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/core/data/api/api_config.dart';

class MediaApiClient {
  static final _httpClient = AppHttpClient();
  static final _apiKey = dotenv.get('API_KEY');

  Future<Response> getPopularMovies({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.popularMoviesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTrendingMovies({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.trendingMoviesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getPopularTVSeries({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.popularTVSeriesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTrendingTVSeries({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.trendingTVSeriesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getSearchMultiMedia({
    required String query,
    required String language,
    required int page,
    bool includeAdult = false,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': language,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.searchMultiMediaPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getMovieDetails({
    required int movieId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'movie_id': movieId.toString(),
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.movieDetailsPath + movieId.toString(),
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTVSeriesDetails({
    required int tvSeriesId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'movie_id': tvSeriesId.toString(),
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.tvSeriesDetailsPath + tvSeriesId.toString(),
      uriParameters: uriParameters,
    );
  }

  Future<Response> getPersonDetails({
    required int personId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'movie_id': personId.toString(),
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.personDetailsPath + personId.toString(),
      uriParameters: uriParameters,
    );
  }
}
