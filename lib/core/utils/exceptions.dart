enum ApiClientExceptionType { network, auth, sessionExpired, other, jsonKey }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}
