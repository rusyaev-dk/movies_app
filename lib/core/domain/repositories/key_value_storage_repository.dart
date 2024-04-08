import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/core/data/storage/storage_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef KeyValueStorageRepositoryPattern<T> = (StorageRepositoryFailure?, T?);

extension KeyValueStorageRepositoryPatternX<T>
    on KeyValueStorageRepositoryPattern<T> {
  StorageRepositoryFailure? get failure => $1;

  T? get value => $2;
}

class KeyValueStorageRepository {
  late final KeyValueStorage _storage;

  KeyValueStorageRepository({required KeyValueStorage storage})
      : _storage = storage;

  Future<KeyValueStorageRepositoryPattern<T>> get<T>(
      {required String key}) async {
    try {
      final T? value = await _storage.get<T>(key);
      return (null, value);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;

      final errorParams = switch (error) {
        TypeError _ => (
            StorageExceptionType.dataType,
            (error).toString(),
          ),
        _ => (StorageExceptionType.unknown, exception.message),
      };

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
      await _storage.set<T>(key, value);
      return (null, true);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;

      final errorParams = switch (error) {
        TypeError _ => (
            StorageExceptionType.dataType,
            (error).toString(),
          ),
        _ => (StorageExceptionType.unknown, exception.message),
      };

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
      await _storage.delete<T>(key);
      return (null, true);
    } on StorageException catch (exception, stackTrace) {
      final error = exception.error;

      final errorParams = switch (error) {
        TypeError _ => (
            StorageExceptionType.dataType,
            (error).toString(),
          ),
        _ => (StorageExceptionType.unknown, exception.message),
      };

      StorageRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, StorageExceptionType.unknown, null), null);
    }
  }
}
