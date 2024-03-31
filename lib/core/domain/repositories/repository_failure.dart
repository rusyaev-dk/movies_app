import 'package:movies_app/core/data/api/api_exceptions.dart';

typedef RepositoryFailure = (
  Object error,
  StackTrace stackTrace,
  ApiClientExceptionType type,
  String? message,
);

extension RepositoryFailureX on RepositoryFailure {
  Object get error => $1;

  StackTrace get stackTrace => $2;

  ApiClientExceptionType get type => $3;

  String? get message => $4;
}
