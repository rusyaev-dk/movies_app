import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/common/data/clients/http_client.dart';
import 'package:movies_app/api/api_config.dart';

class AuthApiClient {
  AuthApiClient({
    required AppHttpClient httpClient,
  }) : _httpClient = httpClient;

  final AppHttpClient _httpClient;
  static final _apiKey = dotenv.get('API_KEY');

  Future<Response> getToken() async {
    Map<String, dynamic> parameters = {
      'api_key': _apiKey,
    };
    return await _httpClient.get(
      path: ApiConfig.newTokenPath,
      uriParameters: parameters,
    );
  }

  Future<Response> validateUser({
    required String login,
    required String password,
    required String requestToken,
  }) async {
    Map<String, dynamic> uriParameters = {
      'username': login,
      'password': password,
      'request_token': requestToken,
      'api_key': _apiKey,
    };

    return await _httpClient.post(
      path: ApiConfig.validateWithLoginPath,
      uriParameters: uriParameters,
    );
  }

  Future<Response> getSessionId({
    required String requestToken,
  }) async {
    Map<String, dynamic> uriParameters = <String, dynamic>{
      'request_token': requestToken,
      'api_key': _apiKey,
    };

    return await _httpClient.post(
      path: ApiConfig.newSessionPath,
      uriParameters: uriParameters,
    );
  }
}
