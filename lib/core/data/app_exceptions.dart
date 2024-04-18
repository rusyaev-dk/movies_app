abstract class AppException implements Exception {
  final Object error;
  final String? message;
  const AppException(this.error, {this.message});
}

enum StorageExceptionType {
  incorrectDataType,
  key,
  unknown,
}

enum ApiClientExceptionType {
  network,
  auth,
  sessionExpired,
  invalidId,
  jsonKey,
  unknown,
}

extension ApiClientExceptionTypeX on ApiClientExceptionType {
  String formatMessage() {
    switch (this) {
      case ApiClientExceptionType.network:
        return "Something is wrong with the Internet. Check your connection and try to update";
      case ApiClientExceptionType.auth:
        return "Something is wrong with an authentication";
      case ApiClientExceptionType.sessionExpired:
        return "Your account session has expired";
      case ApiClientExceptionType.invalidId:
        return "It seems we can't get information about this media. Please try again later...";
      case ApiClientExceptionType.jsonKey:
      case ApiClientExceptionType.unknown:
        return "Oops... Unknown error. Please try again";
    }
  }
}

abstract class StorageException extends AppException {
  const StorageException(super.error, {super.message});
}

class StorageDataTypeException extends StorageException {
  StorageDataTypeException(super.error, {super.message});
}

class StorageUnknownException extends StorageException {
  StorageUnknownException(super.error, {super.message});
}

abstract class ApiClientException extends AppException {
  const ApiClientException(super.error, {super.message});
}

class ApiNetworkException extends ApiClientException {
  ApiNetworkException(super.error, {super.message});
}

class ApiAuthException extends ApiClientException {
  ApiAuthException(super.error, {super.message});
}

class ApiSessionExpiredException extends ApiClientException {
  ApiSessionExpiredException(super.error, {super.message});
}

class ApiJsonKeyException extends ApiClientException {
  ApiJsonKeyException(super.error, {super.message});
}

class ApiUnknownException extends ApiClientException {
  ApiUnknownException(super.error, {super.message});
}

class ApiInvalidIdException extends ApiClientException {
  ApiInvalidIdException(super.error, {super.message});
}
