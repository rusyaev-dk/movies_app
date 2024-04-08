import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/data/storage/storage_exceptions.dart';

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
