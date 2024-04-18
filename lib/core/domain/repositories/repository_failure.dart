import 'package:dio/dio.dart';
import 'package:movies_app/core/data/app_exceptions.dart';

typedef StorageRepositoryFailure = (
  Object error,
  StackTrace stackTrace,
  StorageExceptionType type,
  String? message,
);

extension StorageRepositoryFailureX on StorageRepositoryFailure {
  Object get error => $1;

  StackTrace get stackTrace => $2;

  StorageExceptionType get type => $3;

  String? get message => $4;
}

typedef ApiRepositoryFailure = (
  Object error,
  StackTrace stackTrace,
  ApiClientExceptionType type,
  String? message,
);

extension RepositoryFailureX on ApiRepositoryFailure {
  Object get error => $1;

  StackTrace get stackTrace => $2;

  ApiClientExceptionType get type => $3;

  String? get message => $4;
}

typedef ApiErrorParams = (
  ApiClientExceptionType type,
  String? message,
);

typedef StorageErrorParams = (
  StorageExceptionType type,
  String? message,
);

class RepositoryFailureFormatter {
  static const _statusCodeMap = {
    30: ApiClientExceptionType.auth,
    6: ApiClientExceptionType.invalidId,
    34: ApiClientExceptionType.invalidId,
    3: ApiClientExceptionType.sessionExpired,
    0: ApiClientExceptionType.unknown,
  };

  ApiErrorParams getApiErrorParams(
    Object error,
    ApiClientException exception,
  ) {
    final ApiErrorParams errorParams;
    switch (error) {
      case DioException _:
        errorParams = (
          ApiClientExceptionType.network,
          (error).message,
        );
        return errorParams;
      case int statusCode:
        errorParams = (
          _statusCodeMap[statusCode] ?? ApiClientExceptionType.unknown,
          exception.message,
        );
        return errorParams;
      default:
        errorParams = (
          ApiClientExceptionType.unknown,
          exception.message,
        );
        return errorParams;
    }
  }

  StorageErrorParams getStorageErrorParams(
    Object error,
    StorageException exception,
  ) {
    final StorageErrorParams errorParams;
    switch (error) {
      case TypeError _:
        errorParams = (
          StorageExceptionType.incorrectDataType,
          (error).toString(),
        );
        return errorParams;
      default:
        errorParams = (
          StorageExceptionType.unknown,
          exception.toString(),
        );
        return errorParams;
    }
  }
}
