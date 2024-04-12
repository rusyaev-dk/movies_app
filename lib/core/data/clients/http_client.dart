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
    } on DioException catch (exception, stackTrace) {
      if (exception.error is SocketException) {
        Error.throwWithStackTrace(
          ApiNetworkException(exception, message: exception.message),
          stackTrace,
        );
      } else {
        Error.throwWithStackTrace(
          ApiUnknownException(exception, message: exception.message),
          stackTrace,
        );
      }
    } on ApiClientException {
      rethrow;
    } catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(exception),
        stackTrace,
      );
    }
  }

  Future<Response> post({
    required String path,
    Map<String, dynamic>? uriParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    try {
      final uri = _makeUri(path: path, parameters: uriParameters);
      final response = await _dio.postUri(
        uri,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (exception, stackTrace) {
      if (exception.error is SocketException) {
        Error.throwWithStackTrace(
          ApiNetworkException(exception, message: exception.message),
          stackTrace,
        );
      } else {
        _validateResponse(response: exception.response!);
        Error.throwWithStackTrace(
          ApiUnknownException(exception),
          stackTrace,
        );
      }
    } on ApiClientException {
      rethrow;
    } catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(exception),
        stackTrace,
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
