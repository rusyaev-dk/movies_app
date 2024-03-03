import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/app_http_client.dart';
import 'package:movies_app/core/data/clients/tmdb_config.dart';

class TMDBMediaApiClient {
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
      path: TMDBConfig.popularMoviesPath,
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
      path: TMDBConfig.trendingMoviesPath,
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
      path: TMDBConfig.popularTVSeriesPath,
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
      path: TMDBConfig.trendingTVSeriesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getSearchMultiMedia({
    required String query,
    required String locale,
    required int page,
    bool includeAdult = false,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: TMDBConfig.searchMultiMediaPath,
      uriParameters: uriParameters,
    );
  }
}
