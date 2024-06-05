import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef KeyValueStorageRepositoryPattern<T> = (StorageRepositoryFailure?, T?);

extension KeyValueStorageRepositoryPatternX<T>
    on KeyValueStorageRepositoryPattern<T> {
  StorageRepositoryFailure? get failure => $1;

  T? get value => $2;
}

class KeyValueStorageRepository {
  KeyValueStorageRepository({required KeyValueStorage storage})
      : _storage = storage;

  late final KeyValueStorage _storage;
  final RepositoryFailureFormatter _failureFormatter =
      RepositoryFailureFormatter();

  Future<KeyValueStorageRepositoryPattern<T>> get<T>(
      {required String key}) async {
    try {
      final T? value = await _storage.get<T>(key);
      return (null, value);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;
      final errorParams =
          _failureFormatter.getStorageErrorParams(error, exception);

      StorageRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, StorageExceptionType.unknown, null), null);
    }
  }

  Future<KeyValueStorageRepositoryPattern<bool>> set<T>({
    required String key,
    required T value,
  }) async {
    try {
      final bool res = await _storage.set<T>(key, value);
      return (null, res);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;
      final errorParams =
          _failureFormatter.getStorageErrorParams(error, exception);

      StorageRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, StorageExceptionType.unknown, null), null);
    }
  }

  Future<KeyValueStorageRepositoryPattern<bool>> delete<T>(
      {required String key}) async {
    try {
      final bool res = await _storage.delete<T>(key);
      return (null, res);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;
      final errorParams =
          _failureFormatter.getStorageErrorParams(error, exception);

      StorageRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, StorageExceptionType.unknown, null), null);
    }
  }
}
