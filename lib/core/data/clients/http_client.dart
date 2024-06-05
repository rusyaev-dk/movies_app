import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/api_config.dart';
import 'package:movies_app/core/data/app_exceptions.dart';

class AppHttpClient {
  AppHttpClient({required Dio dio}) : _dio = dio;
  
  final Dio _dio;

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
        _validateResponse(response: exception.response!);
        Error.throwWithStackTrace(
          ApiUnknownException(exception, message: exception.message),
          stackTrace,
        );
      }
    } on ApiClientException catch (exception) {
      Error.throwWithStackTrace(
        exception,
        StackTrace.current,
      );
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
    } on ApiClientException catch (exception) {
      Error.throwWithStackTrace(
        exception,
        StackTrace.current,
      );
    } catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(exception),
        stackTrace,
      );
    }
  }

  void _validateResponse({required Response response}) {
    if (response.statusCode == 401) {
      final int statusCode = response.data['status_code'];
      if (statusCode == 30) {
        throw ApiAuthException(
          statusCode,
          message: response.data["status_message"],
        );
      } else if (statusCode == 3) {
        throw ApiSessionExpiredException(
          statusCode,
          message: response.data["status_message"],
        );
      } else {
        throw ApiUnknownException(
          0,
          message: response.data["status_message"],
        );
      }
    } else if (response.statusCode == 404) {
      final int statusCode = response.data['status_code'];
      if (statusCode == 6 || statusCode == 34) {
        throw ApiInvalidIdException(
          statusCode,
          message: response.data["status_message"],
        );
      } else {
        throw ApiUnknownException(
          0,
          message: response.data["status_message"],
        );
      }
    }
  }
}
