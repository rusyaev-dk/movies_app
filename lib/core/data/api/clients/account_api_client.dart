import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/core/data/api/api_config.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

class AccountApiClient {
  static final _httpClient = AppHttpClient();
  static final _apiKey = dotenv.get('API_KEY');

  Future<Response> getAccountId({required String sessionId}) async {
    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: ApiConfig.accountPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> addFavourite({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    Map<String, dynamic> uriParameters = {
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavorite.toString(),
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.post(
      path: "/accout/$accountId/favorite",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getAccountDetails({
    required int accountId,
    required String sessionId,
  }) async {
    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: "${ApiConfig.accountPath}/$accountId",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getAccountMoviesWatchList({
    required String locale,
    required int page,
    required int accountId,
    required String sessionId,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: "${ApiConfig.accountPath}/$accountId/watchlist/movies",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getAccountTVSeriesWatchList({
    required String locale,
    required int page,
    required int accountId,
    required String sessionId,
  }) async {
    Map<String, dynamic> uriParameters = {
      'language': locale,
      'page': page.toString(),
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: "${ApiConfig.accountPath}/$accountId/watchlist/tv",
      uriParameters: uriParameters,
    );
  }
}
