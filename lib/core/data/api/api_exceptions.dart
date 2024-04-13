enum ApiClientExceptionType { network, auth, sessionExpired, unknown, jsonKey }

extension ApiClientExceptionTypeX on ApiClientExceptionType {
  String formatMessage() {
    switch (this) {
      case ApiClientExceptionType.network:
        return "Something is wrong with the Internet. Check your connection and try to update";
      case ApiClientExceptionType.auth:
        return "Something is wrong with an authentication";
      case ApiClientExceptionType.sessionExpired:
        return "Your account session has expired";
      case ApiClientExceptionType.jsonKey:
      case ApiClientExceptionType.unknown:
        return "Oops... Unknown error. Please try again";
    }
  }
}

abstract class ApiClientException implements Exception {
  final Object error;
  final String? message;
  const ApiClientException(this.error, {this.message});
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
