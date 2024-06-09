import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/core/data/api/api_config.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

class AccountApiClient {
  AccountApiClient({
    required AppHttpClient httpClient,
  }) : _httpClient = httpClient;

  final AppHttpClient _httpClient;
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

  Future<Response> addToFavourite({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isFavourite,
  }) async {
    Map<String, dynamic> data = {
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavourite,
    };

    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.post(
      path: "/account/$accountId/favorite",
      uriParameters: uriParameters,
      headers: headers,
      data: jsonEncode(data),
    );
  }

  Future<Response> addToWatchlist({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isInWatchlist,
  }) async {
    Map<String, dynamic> data = {
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'watchlist': isInWatchlist,
    };

    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.post(
      path: "/account/$accountId/watchlist",
      uriParameters: uriParameters,
      headers: headers,
      data: jsonEncode(data),
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

  Future<Response> getMovieAccountStates({
    required int movieId,
    required String sessionId,
  }) async {
    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path: "${ApiConfig.moviePath}/$movieId/${ApiConfig.accountStatesPath}",
      uriParameters: uriParameters,
    );
  }

  Future<Response> getTvSeriesAccountStates({
    required int tvSeriesId,
    required String sessionId,
  }) async {
    Map<String, dynamic> uriParameters = {
      'session_id': sessionId,
      'api_key': _apiKey,
    };

    return await _httpClient.get(
      path:
          "${ApiConfig.tvSeriesPath}/$tvSeriesId/${ApiConfig.accountStatesPath}",
      uriParameters: uriParameters,
    );
  }
}
