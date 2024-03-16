import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/api_config.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';

class AppHttpClient {
  static final _dio = Dio();

  Uri _makeUri({
    required String path,
    Map<String, dynamic>? parameters,
  }) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
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
      _validateResponse(response: response);
      return response;
    } on DioException catch (err, stackStrace) {
      if (err.error is SocketException) {
        Error.throwWithStackTrace(
          ApiNetworkException(err, message: err.message),
          stackStrace,
        );
      } else {
        Error.throwWithStackTrace(
          ApiUnknownException(err, message: err.message),
          stackStrace,
        );
      }
    } on ApiClientException {
      rethrow;
    } catch (err, stackStrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(err),
        stackStrace,
      );
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
    } on DioException catch (err, stackStrace) {
      if (err.error is SocketException) {
        Error.throwWithStackTrace(
          ApiNetworkException(err, message: err.message),
          stackStrace,
        );
      } else {
        _validateResponse(response: err.response!);
        Error.throwWithStackTrace(
          ApiUnknownException(err),
          stackStrace,
        );
      }
    } on ApiClientException {
      rethrow;
    } catch (err, stackStrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(err),
        stackStrace,
      );
    }
  }

  void _validateResponse({required Response response}) {
    if (response.statusCode == 401) {
      final dynamic status = response.data['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiAuthException(1, message: response.statusMessage);
      } else if (code == 3) {
        throw ApiSessionExpiredException(1, message: response.statusMessage);
      } else {
        throw ApiUnknownException(1, message: "Unknown Exception");
      }
    }
  }
}
