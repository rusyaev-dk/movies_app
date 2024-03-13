enum ApiClientExceptionType { network, auth, sessionExpired, other, jsonKey }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);

  String getInfo() {
    switch (type) {
      case (ApiClientExceptionType.network):
        return "Something is wrong with the Internet. Check your connection and try to update";
      case (ApiClientExceptionType.jsonKey):
        return "Oops... Something went wrong. Please try again.";
      case (ApiClientExceptionType.other):
        return "Oops... Unknown error. Please try again.";
      default:
        return "Error: $type";
    }
  }
}
