enum ApiClientExceptionType { network, auth, sessionExpired, other, jsonKey }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);

  String getInfo() {
    switch (type) {
      case (ApiClientExceptionType.network):
        return "Network error :(";
      default:
        return "none";
    }
  }
}
