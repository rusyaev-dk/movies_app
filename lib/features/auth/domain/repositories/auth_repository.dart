import 'dart:async';

import 'package:logging/logging.dart';
import 'package:movies_app/core/data/api/clients/auth_api_client.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef AuthRepositoryPattern = (ApiRepositoryFailure?, String?);

extension AuthRepositoryX on AuthRepositoryPattern {
  ApiRepositoryFailure? get failure => $1;

  String? get value => $2;
}

class AuthRepository {
  static final _authApiClient = AuthApiClient();
  static final RepositoryFailureFormatter _failureFormatter =
      RepositoryFailureFormatter();
  final Logger _logger = Logger("AuthRepo");

  Future<AuthRepositoryPattern> onAuth({
    required String login,
    required String password,
  }) async {
    try {
      final tokenResponse = await _authApiClient.getToken();
      final String token = tokenResponse.data["request_token"] as String;

      final validateResponse = await _authApiClient.validateUser(
        login: login,
        password: password,
        requestToken: token,
      );
      final String validToken =
          validateResponse.data["request_token"] as String;

      final sessionResponse =
          await _authApiClient.getSessionId(requestToken: validToken);
      final String sessionId = sessionResponse.data["session_id"] as String;

      return (null, sessionId);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return ((exception, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
