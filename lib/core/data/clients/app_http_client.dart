import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/clients/tmdb_config.dart';
import 'package:movies_app/core/utils/exceptions.dart';

class AppHttpClient {
  static final _dio = Dio();

  Uri _makeUri({
    required String path,
    Map<String, dynamic>? parameters,
  }) {
    final uri = Uri.parse('${TMDBConfig.baseUrl}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? uriParameters,
  }) async {
    final uri = _makeUri(path: path, parameters: uriParameters);
    try {
      Response response = await _dio.getUri(
        uri,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      _validateResponse(response);
      return response;
    } on DioException catch (err) {
      if (err.error is SocketException) {
        throw ApiClientException(ApiClientExceptionType.network);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    } on ApiClientException {
      rethrow;
    } catch (err) {
      print('Произошла ошибка: $err');
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<Response> post({
    required String path,
    Map<String, dynamic>? uriParameters,
  }) async {
    try {
      final uri = _makeUri(path: path, parameters: uriParameters);
      final response = await _dio.postUri(
        uri,
      );
      
      return response;
    } on DioException catch (err) {
      if (err.error is SocketException) {
        throw ApiClientException(ApiClientExceptionType.network);
      } else {
        _validateResponse(err.response!);
        throw ApiClientException(ApiClientExceptionType.other);
      }
    } on ApiClientException {
      rethrow;
    } catch (err) {
      print('Произошла ошибка: $err');
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  void _validateResponse(Response response) {
    if (response.statusCode == 401) {
      final dynamic status = response.data['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}
