import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/core/data/api/api_config.dart';

class MediaApiClient {
  MediaApiClient({required AppHttpClient httpClient}) : _httpClient = httpClient;

  final AppHttpClient _httpClient;
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

  Future<Response> getOnTheAirTVSeries({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.onTheAirTVSeriesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getPopularPersons({
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.popularPersonsPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> searchMultiMedia({
    required String query,
    required String locale,
    required int page,
    bool includeAdult = true,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.searchMultiMediaPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> searchMovies({
    required String query,
    required String locale,
    required int page,
    bool includeAdult = true,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.searchMoviesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> searchTVSeries({
    required String query,
    required String locale,
    required int page,
    bool includeAdult = true,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.searchTVSeriesPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> searchPersons({
    required String query,
    required String locale,
    required int page,
    bool includeAdult = true,
  }) async {
    Map<String, dynamic> uriParameters = {
      'query': query,
      'include_adult': includeAdult.toString(),
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.searchPersonsPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getMovieDetails({
    required int movieId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.moviePath}/$movieId",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTVSeriesDetails({
    required int tvSeriesId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.tvSeriesPath}/$tvSeriesId",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getPersonDetails({
    required int personId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.personPath}/$personId",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getMovieCredits({
    required int movieId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.moviePath}/$movieId/${ApiConfig.creditsPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTVSeriesCredits({
    required int tvSeriesId,
    required String locale,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.tvSeriesPath}/$tvSeriesId/${ApiConfig.creditsPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getMovieImages({
    required int movieId,
    required String locale,
    String? includeImageLanguage = "en",
  }) async {
    Map<String, dynamic> uriParameters = {
      'include_image_language': includeImageLanguage,
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.moviePath}/$movieId/${ApiConfig.imagesPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTVSeriesImages({
    required int tvSeriesId,
    required String locale,
    String? includeImageLanguage = "en",
  }) async {
    Map<String, dynamic> uriParameters = {
      'include_image_language': includeImageLanguage,
      'language': locale,
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.tvSeriesPath}/$tvSeriesId/${ApiConfig.imagesPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getSimilarMovies({
    required int movieId,
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.moviePath}/$movieId/${ApiConfig.similarPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getSimilarTVSeries({
    required int tvSeriesId,
    required String locale,
    required int page,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: "${ApiConfig.tvSeriesPath}/$tvSeriesId/${ApiConfig.similarPath}",
      uriParameters: uriParameters,
    );
  }
}
