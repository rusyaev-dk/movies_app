import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:movies_app/common/data/clients/auth_api_client.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:talker_flutter/talker_flutter.dart';

typedef AuthRepositoryPattern = (ApiRepositoryFailure?, String?);

extension AuthRepositoryX on AuthRepositoryPattern {
  ApiRepositoryFailure? get failure => $1;

  String? get value => $2;
}

class AuthRepository {
  AuthRepository({
    required AuthApiClient authApiClient,
    required RepositoryFailureFormatter repositoryFailureFormatter,
  })  : _authApiClient = authApiClient,
        _failureFormatter = repositoryFailureFormatter;

  final AuthApiClient _authApiClient;
  final RepositoryFailureFormatter _failureFormatter;

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
      GetIt.I<Talker>()
          .error("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      GetIt.I<Talker>()
          .error("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }
}
