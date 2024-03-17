
enum ApiClientExceptionType { network, auth, sessionExpired, unknown, jsonKey }

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
