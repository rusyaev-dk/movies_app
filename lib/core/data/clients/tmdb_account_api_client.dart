import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/app_http_client.dart';
import 'package:movies_app/core/data/clients/tmdb_config.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';


class TMDBAccountApiClient {
  static final _httpClient = AppHttpClient();
  static final _apiKey = dotenv.get('API_KEY');

  Future<Response?> getAccountId({required String sessionId}) async {
    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: TMDBConfig.accountPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response?> markAsFavourite({
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
    
    // Map<String, dynamic> bodyParameters = {
      
    // };

    return await _httpClient.post(
      path: "/accout/$accountId/favorite",
      // bodyParameters: bodyParameters,
      uriParameters: uriParameters,
    );
  }
}
