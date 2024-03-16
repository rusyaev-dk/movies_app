// class ApiClientException implements Exception {
//   final ApiClientExceptionType type;

//   ApiClientException(this.type);

//   String getInfo() {
//     switch (type) {
//       case (ApiClientExceptionType.network):
//         return "";
//       case (ApiClientExceptionType.sessionExpired):
//         return ;
//       case (ApiClientExceptionType.jsonKey):
//         return "Oops... Something went wrong. Please try again";
//       case (ApiClientExceptionType.other):
//         return "Oops... Unknown error. Please try again";
//       default:
//         return "Error: $type";
//     }
//   }
// }

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
